import 'dart:math';
import 'package:flutter/material.dart';
import '../../chart/utils/enum.dart';
import '../../circular_chart/renderer/common.dart';
import '../../circular_chart/utils/helper.dart';
import '../../common/common.dart';
import '../../common/event_args.dart';
import '../../common/legend/renderer.dart';

import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../renderer/pyramid_series.dart';
import '../renderer/renderer_extension.dart';
import '../utils/common.dart';
import '../utils/helper.dart';
import 'pyramid_base.dart';
import 'pyramid_state_properties.dart';

/// Represents the pyramid chart base.
class PyramidChartBase {
  /// Creates an instance of pyramid chart base.
  PyramidChartBase(this.stateProperties);

  /// Specifies the pyramid state properties.
  final PyramidStateProperties stateProperties;

  /// Specifies the current pyramid series.
  late PyramidSeries<dynamic, dynamic> currentSeries;

  /// Specifies the list of the visible series renderers.
  List<PyramidSeriesRendererExtension> visibleSeriesRenderers =
      <PyramidSeriesRendererExtension>[];

  /// Specifies the selection args.
  SelectionArgs? _selectionArgs;

  /// To find the visible series.
  void findVisibleSeries() {
    stateProperties.chartSeries.visibleSeriesRenderers[0].dataPoints =
        <PointInfo<dynamic>>[];

    //Considered the first series, since in triangular series one series will be considered for rendering
    final PyramidSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[0];
    currentSeries = seriesRenderer.series;
    //Setting series type
    seriesRenderer.seriesType = 'pyramid';
    final ChartIndexedValueMapper<dynamic>? xValue = currentSeries.xValueMapper;
    final ChartIndexedValueMapper<dynamic>? yValue = currentSeries.yValueMapper;
    for (int pointIndex = 0;
        pointIndex < currentSeries.dataSource!.length;
        pointIndex++) {
      if (xValue!(pointIndex) != null) {
        seriesRenderer.dataPoints
            .add(PointInfo<dynamic>(xValue(pointIndex), yValue!(pointIndex)));
      }
    }
    visibleSeriesRenderers
      ..clear()
      ..add(seriesRenderer);
  }

  /// To calculate empty point values if null values are provided.
  void _calculatePyramidEmptyPoints(
      PyramidSeriesRendererExtension seriesRenderer) {
    for (int i = 0; i < seriesRenderer.dataPoints.length; i++) {
      if (seriesRenderer.dataPoints[i].y == null) {
        seriesRenderer.series.calculateEmptyPointValue(
            i, seriesRenderer.dataPoints[i], seriesRenderer);
      }
    }
  }

  /// To process the data points for series render.
  void processDataPoints() {
    for (final PyramidSeriesRendererExtension seriesRenderer
        in visibleSeriesRenderers) {
      currentSeries = seriesRenderer.series;
      _calculatePyramidEmptyPoints(seriesRenderer);
      _calculateVisiblePoints(seriesRenderer);
      _setPointStyle(seriesRenderer);
      _findSumOfPoints(seriesRenderer);
    }
  }

  /// To calculate the visible points in a series.
  void _calculateVisiblePoints(PyramidSeriesRendererExtension seriesRenderer) {
    final List<PointInfo<dynamic>> points = seriesRenderer.dataPoints;
    seriesRenderer.renderPoints = <PointInfo<dynamic>>[];
    for (int i = 0; i < points.length; i++) {
      if (points[i].isVisible) {
        seriesRenderer.renderPoints!.add(points[i]);
      }
    }
  }

  /// To set style properties for the current point.
  void _setPointStyle(PyramidSeriesRendererExtension seriesRenderer) {
    currentSeries = seriesRenderer.series;
    final List<Color> palette = stateProperties.chart.palette;
    final ChartIndexedValueMapper<Color>? pointColor =
        currentSeries.pointColorMapper;
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final ChartIndexedValueMapper<String>? textMapping =
        currentSeries.textFieldMapper;
    final List<PointInfo<dynamic>> points = seriesRenderer.renderPoints!;
    PointInfo<dynamic> currentPoint;
    List<MeasureWidgetContext> legendToggles;
    MeasureWidgetContext item;
    LegendRenderContext legendRenderContext;
    for (int i = 0; i < points.length; i++) {
      currentPoint = points[i];
      currentPoint.fill = currentPoint.isEmpty &&
              empty.color != null // ignore: unnecessary_null_comparison
          ? empty.color
          : pointColor!(i) ?? palette[i % palette.length];
      currentPoint.color = currentPoint.fill;
      currentPoint.borderColor = currentPoint.isEmpty &&
              empty.borderColor != null // ignore: unnecessary_null_comparison
          ? empty.borderColor
          : currentSeries.borderColor;
      currentPoint.borderWidth = currentPoint.isEmpty &&
              empty.borderWidth != null // ignore: unnecessary_null_comparison
          ? empty.borderWidth
          : currentSeries.borderWidth;
      currentPoint.borderColor = currentPoint.borderWidth == 0
          ? Colors.transparent
          : currentPoint.borderColor;

      currentPoint.text = currentPoint.text ??
          (textMapping != null
              ? textMapping(i) ?? currentPoint.y.toString()
              : currentPoint.y.toString());

      if (stateProperties.chart.legend.legendItemBuilder != null) {
        legendToggles =
            stateProperties.renderingDetails.legendToggleTemplateStates;
        if (legendToggles.isNotEmpty) {
          for (int j = 0; j < legendToggles.length; j++) {
            item = legendToggles[j];
            if (i == item.pointIndex) {
              currentPoint.isVisible = false;
              break;
            }
          }
        }
      } else {
        if (stateProperties.renderingDetails.legendToggleStates.isNotEmpty) {
          for (int j = 0;
              j < stateProperties.renderingDetails.legendToggleStates.length;
              j++) {
            legendRenderContext =
                stateProperties.renderingDetails.legendToggleStates[j];
            if (i == legendRenderContext.seriesIndex) {
              currentPoint.isVisible = false;
              break;
            }
          }
        }
      }
    }
  }

  /// To find the sum of points.
  void _findSumOfPoints(PyramidSeriesRendererExtension seriesRenderer) {
    seriesRenderer.sumOfPoints = 0;
    for (final PointInfo<dynamic> point in seriesRenderer.renderPoints!) {
      if (point.isVisible) {
        seriesRenderer.sumOfPoints += point.y!.abs();
      }
    }
  }

  /// To initialize the series properties in the chart.
  void initializeSeriesProperties(
      PyramidSeriesRendererExtension seriesRenderer) {
    final PyramidSeries<dynamic, dynamic> series = seriesRenderer.series;
    final Rect chartAreaRect = stateProperties.renderingDetails.chartAreaRect;
    final bool reverse = seriesRenderer.seriesType == 'pyramid';
    seriesRenderer.triangleSize = Size(
        percentToValue(series.width, chartAreaRect.width)!.toDouble(),
        percentToValue(series.height, chartAreaRect.height)!.toDouble());
    seriesRenderer.explodeDistance =
        percentToValue(series.explodeOffset, chartAreaRect.width)!;
    if (series.pyramidMode == PyramidMode.linear) {
      _initializeSizeRatio(seriesRenderer, reverse);
    } else {
      _initializeSurfaceSizeRatio(seriesRenderer);
    }
  }

  /// To initialize the surface size ratio in the chart.
  void _initializeSurfaceSizeRatio(
      PyramidSeriesRendererExtension seriesRenderer) {
    final num count = seriesRenderer.renderPoints!.length;
    final num sumOfValues = seriesRenderer.sumOfPoints;
    List<num> y;
    List<num> height;
    y = <num>[];
    height = <num>[];
    final num gapRatio = min(max(seriesRenderer.series.gapRatio, 0), 1);
    final num gapHeight = gapRatio / (count - 1);
    final num preSum = _getSurfaceHeight(0, sumOfValues);
    num currY = 0;
    PointInfo<dynamic> point;
    for (int i = 0; i < count; i++) {
      point = seriesRenderer.renderPoints![i];
      if (point.isVisible) {
        y.add(currY);
        height.add(_getSurfaceHeight(currY, point.y!.abs()));
        currY += height[i] + gapHeight * preSum;
      }
    }
    final num coeff = 1 / (currY - gapHeight * preSum);
    for (int i = 0; i < count; i++) {
      point = seriesRenderer.renderPoints![i];
      if (point.isVisible) {
        point.yRatio = coeff * y[i];
        point.heightRatio = coeff * height[i];
      }
    }
  }

  /// To get the surface height.
  num _getSurfaceHeight(num y, num surface) =>
      _solveQuadraticEquation(1, 2 * y, -surface);

  /// To solve quadratic equations.
  num _solveQuadraticEquation(num a, num b, num c) {
    num root1;
    num root2;
    final num d = b * b - 4 * a * c;
    if (d >= 0) {
      final num sd = sqrt(d);
      root1 = (-b - sd) / (2 * a);
      root2 = (-b + sd) / (2 * a);
      return max(root1, root2);
    }
    return 0;
  }

  /// To initialize the size ratio for the pyramid.
  void _initializeSizeRatio(PyramidSeriesRendererExtension seriesRenderer,
      [bool? reverse]) {
    final List<PointInfo<dynamic>> points = seriesRenderer.renderPoints!;
    double y;
    assert(
        // ignore: unnecessary_null_comparison
        !(seriesRenderer.series.gapRatio != null) ||
            seriesRenderer.series.gapRatio >= 0 &&
                seriesRenderer.series.gapRatio <= 1,
        'The gap ratio for the pyramid chart must be between 0 and 1.');
    final double gapRatio = min(max(seriesRenderer.series.gapRatio, 0), 1);
    final double coEff =
        1 / (seriesRenderer.sumOfPoints * (1 + gapRatio / (1 - gapRatio)));
    final double spacing = gapRatio / (points.length - 1);
    y = 0;
    int index;
    num height;
    for (int i = points.length - 1; i >= 0; i--) {
      index = reverse! ? points.length - 1 - i : i;
      if (points[index].isVisible) {
        height = coEff * points[index].y!;
        points[index].yRatio = y;
        points[index].heightRatio = height;
        y += height + spacing;
      }
    }
  }

  /// To explode current point index.
  void pointExplode(int pointIndex) {
    bool existExplodedRegion = false;
    final PyramidSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[0];
    final PointInfo<dynamic> point = seriesRenderer.renderPoints![pointIndex];
    if (seriesRenderer.series.explode) {
      if (stateProperties.renderingDetails.explodedPoints.isNotEmpty) {
        existExplodedRegion = true;
        final int previousIndex =
            stateProperties.renderingDetails.explodedPoints[0];
        seriesRenderer.renderPoints![previousIndex].explodeDistance = 0;
        point.explodeDistance =
            previousIndex == pointIndex ? 0 : seriesRenderer.explodeDistance;
        stateProperties.renderingDetails.explodedPoints[0] = pointIndex;
        if (previousIndex == pointIndex) {
          stateProperties.renderingDetails.explodedPoints = <int>[];
        }
        stateProperties.renderingDetails.seriesRepaintNotifier.value++;
      }
      if (!existExplodedRegion) {
        point.explodeDistance = seriesRenderer.explodeDistance;
        stateProperties.renderingDetails.explodedPoints.add(pointIndex);
        stateProperties.renderingDetails.seriesRepaintNotifier.value++;
      }
      calculatePathRegion(pointIndex, seriesRenderer);
    }
  }

  /// To calculate region path for rendering chart.
  void calculatePathRegion(
      int pointIndex, PyramidSeriesRendererExtension seriesRenderer) {
    final PointInfo<dynamic> currentPoint =
        seriesRenderer.renderPoints![pointIndex];
    currentPoint.pathRegion = <Offset>[];
    final Size area = seriesRenderer.triangleSize;
    final Rect rect = stateProperties.renderingDetails.chartContainerRect;
    final num seriesTop = rect.top + (rect.height - area.height) / 2;
    const num offset = 0;

    // ignore: prefer_if_null_operators
    final num extraSpace = (currentPoint.explodeDistance != null
            ? currentPoint.explodeDistance!
            : isNeedExplode(pointIndex, currentSeries, stateProperties)
                ? seriesRenderer.explodeDistance
                : 0) +
        (rect.width - seriesRenderer.triangleSize.width) / 2;
    final num emptySpaceAtLeft = extraSpace + rect.left;
    num top = currentPoint.yRatio;
    num bottom = currentPoint.yRatio + currentPoint.heightRatio;
    final num topRadius = 0.5 * (1 - currentPoint.yRatio);
    final num bottomRadius = 0.5 * (1 - bottom);
    top += seriesTop / area.height;
    bottom += seriesTop / area.height;
    num line1X, line1Y, line2X, line2Y, line3X, line3Y, line4X, line4Y;
    line1X = emptySpaceAtLeft + offset + topRadius * area.width;
    line1Y = top * area.height;
    line2X = emptySpaceAtLeft + offset + (1 - topRadius) * area.width;
    line2Y = top * area.height;
    line3X = emptySpaceAtLeft + offset + (1 - bottomRadius) * area.width;
    line3Y = bottom * area.height;
    line4X = emptySpaceAtLeft + offset + bottomRadius * area.width;
    line4Y = bottom * area.height;
    currentPoint.pathRegion.add(Offset(line1X.toDouble(), line1Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line2X.toDouble(), line2Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line3X.toDouble(), line3Y.toDouble()));
    currentPoint.pathRegion.add(Offset(line4X.toDouble(), line4Y.toDouble()));
    _calculatePathSegment(seriesRenderer.seriesType, currentPoint);
  }

  /// To calculate pyramid segments.
  void calculatePyramidSegments(Canvas canvas, int pointIndex,
      PyramidSeriesRendererExtension seriesRenderer) {
    calculatePathRegion(pointIndex, seriesRenderer);
    final PointInfo<dynamic> currentPoint =
        seriesRenderer.renderPoints![pointIndex];
    final Path path = Path();
    path.moveTo(currentPoint.pathRegion[0].dx, currentPoint.pathRegion[0].dy);
    path.lineTo(currentPoint.pathRegion[1].dx, currentPoint.pathRegion[0].dy);
    path.lineTo(currentPoint.pathRegion[1].dx, currentPoint.pathRegion[1].dy);
    path.lineTo(currentPoint.pathRegion[2].dx, currentPoint.pathRegion[2].dy);
    path.lineTo(currentPoint.pathRegion[3].dx, currentPoint.pathRegion[3].dy);
    path.close();
    if (pointIndex == seriesRenderer.renderPoints!.length - 1) {
      seriesRenderer.maximumDataLabelRegion = path.getBounds();
    }
    _segmentPaint(canvas, path, pointIndex, seriesRenderer);
  }

  /// To paint the pyramid segments.
  void _segmentPaint(Canvas canvas, Path path, int pointIndex,
      PyramidSeriesRendererExtension seriesRenderer) {
    final PointInfo<dynamic> point = seriesRenderer.renderPoints![pointIndex];
    final StyleOptions? style = _getPointStyle(
        pointIndex, seriesRenderer, stateProperties.chart, point);

    final Color fillColor =
        style != null && style.fill != null ? style.fill! : point.fill;

    final Color strokeColor = style != null && style.strokeColor != null
        ? style.strokeColor!
        : point.borderColor;

    final double strokeWidth = style != null && style.strokeWidth != null
        ? style.strokeWidth!.toDouble()
        : point.borderWidth.toDouble();

    final double opacity = style != null && style.opacity != null
        ? style.opacity!
        : currentSeries.opacity;

    drawPath(
        canvas,
        StyleOptions(
            fill: fillColor,
            strokeWidth: stateProperties.renderingDetails.animateCompleted
                ? strokeWidth
                : 0,
            strokeColor: strokeColor,
            opacity: opacity),
        path);
  }

  /// To calculate the segment path.
  void _calculatePathSegment(String seriesType, PointInfo<dynamic> point) {
    final List<Offset> pathRegion = point.pathRegion;
    final int bottom =
        seriesType == 'funnel' ? pathRegion.length - 2 : pathRegion.length - 1;
    final num x = (pathRegion[0].dx + pathRegion[bottom].dx) / 2;
    final num right = (pathRegion[1].dx + pathRegion[bottom - 1].dx) / 2;
    point.region = Rect.fromLTWH(x.toDouble(), pathRegion[0].dy,
        (right - x).toDouble(), pathRegion[bottom].dy - pathRegion[0].dy);
    point.symbolLocation = Offset(point.region!.left + point.region!.width / 2,
        point.region!.top + point.region!.height / 2);
  }

  /// To add selection points to selection list.
  void seriesPointSelection(int pointIndex, ActivationMode mode) {
    bool isPointAlreadySelected = false;
    final SfPyramidChart chart = stateProperties.chart;
    final PyramidSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[0];
    int? currentSelectedIndex;
    const int seriesIndex = 0;
    if (seriesRenderer.isSelectionEnable && mode == chart.selectionGesture) {
      if (stateProperties.renderingDetails.selectionData.isNotEmpty) {
        if (!chart.enableMultiSelection &&
            stateProperties.renderingDetails.selectionData.isNotEmpty &&
            stateProperties.renderingDetails.selectionData.length > 1) {
          if (stateProperties.renderingDetails.selectionData
              .contains(pointIndex)) {
            currentSelectedIndex = pointIndex;
          }
          stateProperties.renderingDetails.selectionData.clear();
          if (currentSelectedIndex != null) {
            stateProperties.renderingDetails.selectionData.add(pointIndex);
          }
        }

        int selectionIndex;
        for (int i = 0;
            i < stateProperties.renderingDetails.selectionData.length;
            i++) {
          selectionIndex = stateProperties.renderingDetails.selectionData[i];
          if (!chart.enableMultiSelection) {
            isPointAlreadySelected =
                stateProperties.renderingDetails.selectionData.length == 1 &&
                    pointIndex == selectionIndex;
            if (seriesRenderer.selectionBehavior.toggleSelection == true ||
                !isPointAlreadySelected) {
              stateProperties.renderingDetails.selectionData.removeAt(i);
            }
            stateProperties.renderingDetails.seriesRepaintNotifier.value++;
            if (chart.onSelectionChanged != null) {
              chart.onSelectionChanged!(_getSelectionEventArgs(
                  seriesRenderer, seriesIndex, selectionIndex));
            }
          } else if (pointIndex == selectionIndex) {
            if (seriesRenderer.selectionBehavior.toggleSelection == true) {
              stateProperties.renderingDetails.selectionData.removeAt(i);
            }
            isPointAlreadySelected = true;
            stateProperties.renderingDetails.seriesRepaintNotifier.value++;
            if (chart.onSelectionChanged != null) {
              chart.onSelectionChanged!(_getSelectionEventArgs(
                  seriesRenderer, seriesIndex, selectionIndex));
            }
            break;
          }
        }
      }
      if (!isPointAlreadySelected) {
        stateProperties.renderingDetails.selectionData.add(pointIndex);
        stateProperties.renderingDetails.seriesRepaintNotifier.value++;
        if (chart.onSelectionChanged != null) {
          chart.onSelectionChanged!(
              _getSelectionEventArgs(seriesRenderer, seriesIndex, pointIndex));
        }
      }
    }
  }

  /// To return style options for the point on selection.
  StyleOptions? _getPointStyle(
      int currentPointIndex,
      PyramidSeriesRendererExtension seriesRenderer,
      SfPyramidChart chart,
      PointInfo<dynamic> point) {
    StyleOptions? pointStyle;
    final dynamic selection = seriesRenderer.series.selectionBehavior;
    if (selection.enable == true) {
      if (stateProperties.renderingDetails.selectionData.isNotEmpty) {
        int selectionIndex;
        for (int i = 0;
            i < stateProperties.renderingDetails.selectionData.length;
            i++) {
          selectionIndex = stateProperties.renderingDetails.selectionData[i];
          if (currentPointIndex == selectionIndex) {
            pointStyle = StyleOptions(
                fill: _selectionArgs != null
                    ? _selectionArgs!.selectedColor
                    : selection!.selectedColor,
                strokeWidth: _selectionArgs != null
                    ? _selectionArgs!.selectedBorderWidth
                    : selection!.selectedBorderWidth,
                strokeColor: _selectionArgs != null
                    ? _selectionArgs!.selectedBorderColor
                    : selection!.selectedBorderColor,
                opacity: selection.selectedOpacity);
            break;
          } else if (i ==
              stateProperties.renderingDetails.selectionData.length - 1) {
            pointStyle = StyleOptions(
                fill: _selectionArgs != null
                    ? _selectionArgs!.unselectedColor
                    : selection.unselectedColor,
                strokeWidth: _selectionArgs != null
                    ? _selectionArgs!.unselectedBorderWidth
                    : selection.unselectedBorderWidth,
                strokeColor: _selectionArgs != null
                    ? _selectionArgs!.unselectedBorderColor
                    : selection.unselectedBorderColor,
                opacity: selection.unselectedOpacity);
          }
        }
      }
    }
    return pointStyle;
  }

  /// To perform selection event and return selectionArgs.
  SelectionArgs _getSelectionEventArgs(
      PyramidSeriesRendererExtension seriesRenderer,
      int seriesIndex,
      int pointIndex) {
    final SfPyramidChart chart = seriesRenderer.stateProperties.chart;
    // ignore: unnecessary_null_comparison
    if (seriesRenderer != null &&
        //ignore: unnecessary_null_comparison
        chart.series != null &&
        pointIndex < chart.series.dataSource!.length) {
      final dynamic selectionBehavior = seriesRenderer.selectionBehavior;
      _selectionArgs = SelectionArgs(
          seriesRenderer: seriesRenderer,
          seriesIndex: seriesIndex,
          viewportPointIndex: pointIndex,
          pointIndex: pointIndex);
      _selectionArgs!.selectedBorderColor =
          selectionBehavior.selectedBorderColor;
      _selectionArgs!.selectedBorderWidth =
          selectionBehavior.selectedBorderWidth;
      _selectionArgs!.selectedColor = selectionBehavior.selectedColor;
      _selectionArgs!.unselectedBorderColor =
          selectionBehavior.unselectedBorderColor;
      _selectionArgs!.unselectedBorderWidth =
          selectionBehavior.unselectedBorderWidth;
      _selectionArgs!.unselectedColor = selectionBehavior.unselectedColor;
    }
    return _selectionArgs!;
  }
}
