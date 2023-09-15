import 'dart:math';
import 'package:flutter/material.dart';
import '../../chart/utils/enum.dart';
import '../../common/common.dart';
import '../../common/event_args.dart';
import '../../common/legend/renderer.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/typedef.dart';

import '../renderer/chart_point.dart';
import '../renderer/circular_series.dart';
import '../renderer/common.dart';
import '../renderer/data_label_renderer.dart';
import '../renderer/radial_bar_series.dart';
import '../renderer/renderer_extension.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'circular_base.dart';
import 'circular_state_properties.dart';

/// Represents the circular series base.
///
class CircularSeriesBase {
  /// Creates the instance for the circular series base.
  CircularSeriesBase(this.stateProperties);

  /// Represents the  circular chart state.
  final CircularStateProperties stateProperties;

  /// Gets the chart widget from the state properties.
  SfCircularChart get chart => stateProperties.chart;

  /// Specifies the current circular series.
  late CircularSeries<dynamic, dynamic> currentSeries;

  /// Specifies the value of size.
  late num size;

  /// Specifies the value of sum of group.
  late num sumOfGroup;

  /// Specifies the value of exploded region.
  late Region explodedRegion;

  /// Specifies the value of select region.
  late Region selectRegion;

  /// Specifies the list that holds the visible series renderers.
  List<CircularSeriesRendererExtension> visibleSeriesRenderers =
      <CircularSeriesRendererExtension>[];

  /// To find the visible series.
  void findVisibleSeries() {
    CircularSeries<dynamic, dynamic> series;
    List<ChartPoint<dynamic>>? oldPoints;
    CircularSeries<dynamic, dynamic>? oldSeries;
    int oldPointIndex = 0;
    ChartPoint<dynamic> currentPoint;
    for (final CircularSeriesRendererExtension seriesRenderer
        in stateProperties.chartSeries.visibleSeriesRenderers) {
      _setSeriesType(seriesRenderer);
      series = seriesRenderer.series = chart.series[0];
      seriesRenderer.dataPoints = <ChartPoint<dynamic>>[];
      seriesRenderer.needsAnimation = false;
      oldPoints = stateProperties.prevSeriesRenderer?.oldRenderPoints;
      oldSeries = stateProperties.prevSeriesRenderer?.series;
      oldPointIndex = 0;
      if (series.dataSource != null) {
        for (int pointIndex = 0;
            pointIndex < series.dataSource!.length;
            pointIndex++) {
          currentPoint = getCircularPoint(seriesRenderer, pointIndex);
          if (currentPoint.x != null) {
            seriesRenderer.dataPoints.add(currentPoint);
            if (!seriesRenderer.needsAnimation) {
              if (oldSeries != null) {
                seriesRenderer.needsAnimation =
                    (oldSeries.startAngle != series.startAngle) ||
                        (oldSeries.endAngle != series.endAngle);
              }

              seriesRenderer.needsAnimation = !(oldPoints != null &&
                      oldPoints.isNotEmpty &&
                      !seriesRenderer.needsAnimation &&
                      oldPointIndex < oldPoints.length) ||
                  isDataUpdated(currentPoint, oldPoints[oldPointIndex++]);
            }
          }
        }
      }
      if (series.sortingOrder != SortingOrder.none &&
          series.sortFieldValueMapper != null) {
        _sortDataSource(seriesRenderer);
      }
      visibleSeriesRenderers
        ..clear()
        ..add(seriesRenderer);
      break;
    }
  }

  /// Method to check whether the data is updated.
  bool isDataUpdated(ChartPoint<dynamic> point, ChartPoint<dynamic> oldPoint) {
    return point.x != oldPoint.x ||
        point.y != oldPoint.y ||
        point.sortValue != oldPoint.sortValue;
  }

  /// To calculate circular empty points in chart.
  void _calculateCircularEmptyPoints(
      CircularSeriesRendererExtension seriesRenderer) {
    final List<ChartPoint<dynamic>> points = seriesRenderer.dataPoints;
    for (int i = 0; i < points.length; i++) {
      if (points[i].y == null) {
        seriesRenderer.series
            .calculateEmptyPointValue(i, points[i], seriesRenderer);
      }
    }
  }

  /// To process data points from series.
  void processDataPoints(CircularSeriesRendererExtension seriesRenderer) {
    currentSeries = seriesRenderer.series;
    _calculateCircularEmptyPoints(seriesRenderer);
    _findingGroupPoints();
  }

  /// Sort the dataSource.
  void _sortDataSource(CircularSeriesRendererExtension seriesRenderer) {
    seriesRenderer.dataPoints.sort(
        // ignore: missing_return
        (ChartPoint<dynamic> firstPoint, ChartPoint<dynamic> secondPoint) {
      if (seriesRenderer.series.sortingOrder == SortingOrder.ascending) {
        return (firstPoint.sortValue == null)
            ? -1
            : (secondPoint.sortValue == null
                ? 1
                : (firstPoint.sortValue is String
                    ? firstPoint.sortValue
                        .toLowerCase()
                        .compareTo(secondPoint.sortValue.toLowerCase())
                    : firstPoint.sortValue
                        .compareTo(secondPoint.sortValue))) as int;
      } else if (seriesRenderer.series.sortingOrder ==
          SortingOrder.descending) {
        return (firstPoint.sortValue == null)
            ? 1
            : (secondPoint.sortValue == null
                ? -1
                : (firstPoint.sortValue! is String
                    ? secondPoint.sortValue!
                        .toLowerCase()
                        .compareTo(firstPoint.sortValue!.toLowerCase())
                    : secondPoint.sortValue!
                        .compareTo(firstPoint.sortValue))) as int;
      } else {
        return 0;
      }
    });
  }

  /// To group points based on group mode.
  void _findingGroupPoints() {
    final List<CircularSeriesRendererExtension> seriesRenderers =
        stateProperties.chartSeries.visibleSeriesRenderers;
    final CircularSeriesRendererExtension seriesRenderer = seriesRenderers[0];
    final double? groupValue = currentSeries.groupTo;
    final CircularChartGroupMode? mode = currentSeries.groupMode;
    late bool isYText;
    final ChartIndexedValueMapper<String>? textMapping =
        currentSeries.dataLabelMapper;
    ChartPoint<dynamic> point;
    sumOfGroup = 0;
    seriesRenderer.renderPoints = <ChartPoint<dynamic>>[];
    for (int i = 0; i < seriesRenderer.dataPoints.length; i++) {
      point = seriesRenderer.dataPoints[i];
      //ignore: prefer_if_null_operators
      point.text = point.text == null
          ? textMapping != null
              ? textMapping(i) ?? point.y.toString()
              : point.y.toString()
          : point.text;
      isYText = point.text == point.y.toString();

      if (point.isVisible) {
        if (groupValue != null &&
            ((mode == CircularChartGroupMode.point && i >= groupValue) ||
                (mode == CircularChartGroupMode.value &&
                    point.y! <= groupValue))) {
          sumOfGroup += point.y!.abs();
        } else {
          seriesRenderer.renderPoints!.add(point);
        }
      }
    }

    if (sumOfGroup > 0) {
      seriesRenderer.renderPoints!
          .add(ChartPoint<dynamic>('Others', sumOfGroup));
      seriesRenderer.renderPoints![seriesRenderer.renderPoints!.length - 1]
          .text = isYText == true ? 'Others : $sumOfGroup}' : 'Others';
    }
    _setPointStyle(seriesRenderer);
  }

  /// To set point properties.
  void _setPointStyle(CircularSeriesRendererExtension seriesRenderer) {
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final List<Color> palette = chart.palette;
    int i = 0;
    List<MeasureWidgetContext> legendToggles;
    MeasureWidgetContext item;
    LegendRenderContext legendRenderContext;
    for (final ChartPoint<dynamic> point in seriesRenderer.renderPoints!) {
      // ignore: unnecessary_null_comparison
      point.fill = point.isEmpty && empty.color != null
          ? empty.color
          : point.pointColor ?? palette[i % palette.length];
      point.color = point.fill;
      // ignore: unnecessary_null_comparison
      point.strokeColor = point.isEmpty && empty.borderColor != null
          ? empty.borderColor
          : currentSeries.borderColor;
      // ignore: unnecessary_null_comparison
      point.strokeWidth = point.isEmpty && empty.borderWidth != null
          ? empty.borderWidth
          : currentSeries.borderWidth;
      point.strokeColor =
          point.strokeWidth == 0 ? Colors.transparent : point.strokeColor;

      if (chart.legend.legendItemBuilder != null) {
        legendToggles =
            stateProperties.renderingDetails.legendToggleTemplateStates;
        if (legendToggles.isNotEmpty) {
          for (int j = 0; j < legendToggles.length; j++) {
            item = legendToggles[j];
            if (i == item.pointIndex) {
              point.isVisible = false;
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
              point.isVisible = false;
              break;
            }
          }
        }
      }
      i++;
    }
  }

  /// To calculate angle, radius and center positions of circular charts.
  void calculateAngleAndCenterPositions(
      CircularSeriesRendererExtension seriesRenderer) {
    currentSeries = seriesRenderer.series;
    _findSumOfPoints(seriesRenderer);
    _calculateAngle(seriesRenderer);
    _calculateRadius(seriesRenderer);
    _calculateOrigin(seriesRenderer);
    _calculateStartAndEndAngle(seriesRenderer);
    _calculateCenterPosition(seriesRenderer);
  }

  /// To calculate circular rect position  for  rendering chart.
  void _calculateCenterPosition(
      CircularSeriesRendererExtension seriesRenderer) {
    if (stateProperties.needToMoveFromCenter &&
        currentSeries.pointRadiusMapper == null &&
        (seriesRenderer.seriesType == 'pie' ||
            seriesRenderer.seriesType == 'doughnut')) {
      final Rect areaRect = stateProperties.renderingDetails.chartAreaRect;
      bool needExecute = true;
      double radius =
          seriesRenderer.segmentRenderingValues['currentRadius']!.toDouble();
      while (needExecute) {
        radius += 1;
        final Rect circularRect = getArcPath(
                0.0,
                radius,
                seriesRenderer.center!,
                seriesRenderer.segmentRenderingValues['start'],
                seriesRenderer.segmentRenderingValues['end'],
                seriesRenderer.segmentRenderingValues['totalAngle'],
                chart,
                true)
            .getBounds();
        if (circularRect.width > areaRect.width ||
            circularRect.height > areaRect.height) {
          needExecute = false;
          seriesRenderer.rect = circularRect;
          break;
        }
      }
      seriesRenderer.rect = getArcPath(
              0.0,
              seriesRenderer.segmentRenderingValues['currentRadius']!,
              seriesRenderer.center!,
              seriesRenderer.segmentRenderingValues['start'],
              seriesRenderer.segmentRenderingValues['end'],
              seriesRenderer.segmentRenderingValues['totalAngle'],
              chart,
              true)
          .getBounds();
      for (final ChartPoint<dynamic> point in seriesRenderer.renderPoints!) {
        point.outerRadius =
            seriesRenderer.segmentRenderingValues['currentRadius'];
      }
    }
  }

  /// To calculate start and end angle of circular charts.
  void _calculateStartAndEndAngle(
      CircularSeriesRendererExtension seriesRenderer) {
    int pointIndex = 0;
    num pointEndAngle;
    num pointStartAngle = seriesRenderer.segmentRenderingValues['start']!;
    final num innerRadius =
        seriesRenderer.segmentRenderingValues['currentInnerRadius']!;
    num? ringSize;
    int? firstVisible;
    num? gap;
    late RadialBarSeriesRendererExtension radialBarSeriesRenderer;
    final bool radialSeries = seriesRenderer.seriesType == 'radialbar';
    if (radialSeries) {
      radialBarSeriesRenderer =
          seriesRenderer as RadialBarSeriesRendererExtension;
      radialBarSeriesRenderer.innerRadius =
          seriesRenderer.segmentRenderingValues['currentInnerRadius']!;
      firstVisible = seriesRenderer.getFirstVisiblePointIndex(seriesRenderer);
      ringSize = (seriesRenderer.segmentRenderingValues['currentRadius']! -
                  seriesRenderer.segmentRenderingValues['currentInnerRadius']!)
              .abs() /
          seriesRenderer.renderPoints!.length;
      gap = percentToValue(
          seriesRenderer.series.gap,
          (seriesRenderer.segmentRenderingValues['currentRadius']! -
                  seriesRenderer.segmentRenderingValues['currentInnerRadius']!)
              .abs());
    }
    for (final ChartPoint<dynamic> point in seriesRenderer.renderPoints!) {
      if (point.isVisible) {
        if (radialSeries) {
          num? degree;
          final RadialBarSeries<dynamic, dynamic> series =
              seriesRenderer.series as RadialBarSeries<dynamic, dynamic>;
          degree = point.y!.abs() /
              (series.maximumValue ??
                  seriesRenderer.segmentRenderingValues['sumOfPoints']!);
          degree = degree * (360 - 0.001);
          pointEndAngle = pointStartAngle + degree;
          point.midAngle = (pointStartAngle + pointEndAngle) / 2;
          point.startAngle = pointStartAngle;
          point.endAngle = pointEndAngle;
          point.center = seriesRenderer.center!;
          point.innerRadius = radialBarSeriesRenderer.innerRadius =
              radialBarSeriesRenderer.innerRadius +
                  ((point.index == firstVisible) ? 0 : ringSize!) -
                  (series.trackBorderWidth / 2) / series.dataSource!.length;
          point.outerRadius = seriesRenderer
                  .renderPoints![point.index].outerRadius =
              ringSize! < gap!
                  ? 0
                  : seriesRenderer.renderPoints![point.index].innerRadius! +
                      ringSize -
                      gap -
                      (series.trackBorderWidth / 2) / series.dataSource!.length;
        } else {
          point.innerRadius =
              (seriesRenderer.seriesType == 'doughnut') ? innerRadius : 0.0;
          point.degree = (point.y!.abs() /
                  (seriesRenderer.segmentRenderingValues['sumOfPoints']! != 0
                      ? seriesRenderer.segmentRenderingValues['sumOfPoints']!
                      : 1)) *
              seriesRenderer.segmentRenderingValues['totalAngle']!;
          pointEndAngle = pointStartAngle + point.degree!;
          point.startAngle = pointStartAngle;
          point.endAngle = pointEndAngle;
          point.midAngle = (pointStartAngle + pointEndAngle) / 2;
          point.outerRadius = _calculatePointRadius(point.radius, point,
              seriesRenderer.segmentRenderingValues['currentRadius']!);
          point.center = _needExplode(pointIndex, currentSeries)
              ? _findExplodeCenter(
                  point.midAngle!, seriesRenderer, point.outerRadius!)
              : seriesRenderer.center;
          // ignore: unnecessary_null_comparison
          if (currentSeries.dataLabelSettings != null) {
            findDataLabelPosition(point);
          }
          pointStartAngle = pointEndAngle;
        }
      }
      pointIndex++;
    }
  }

  /// To check need for explode.
  bool _needExplode(int pointIndex, CircularSeries<dynamic, dynamic> series) {
    bool isNeedExplode = false;
    if (series.explode) {
      if (stateProperties.renderingDetails.initialRender!) {
        if (pointIndex == series.explodeIndex || series.explodeAll) {
          stateProperties.renderingDetails.explodedPoints.add(pointIndex);
          isNeedExplode = true;
        }
      } else if (!stateProperties.renderingDetails.initialRender!) {
        if (!stateProperties.renderingDetails.explodedPoints
                .contains(pointIndex) &&
            !stateProperties.renderingDetails.isLegendToggled) {
          if (pointIndex == series.explodeIndex || series.explodeAll) {
            if (!series.explodeAll && pointIndex == 0) {
              stateProperties.renderingDetails.explodedPoints.clear();
            }
            stateProperties.renderingDetails.explodedPoints.add(pointIndex);
            isNeedExplode = true;
          } else if (!series.explodeAll &&
              stateProperties.renderingDetails.explodedPoints.isNotEmpty &&
              pointIndex <=
                  stateProperties.renderingDetails.explodedPoints.length - 1) {
            stateProperties.renderingDetails.explodedPoints
                .removeAt(pointIndex);
          }
        }
        isNeedExplode = stateProperties.renderingDetails.explodedPoints
            .contains(pointIndex);
      }
    }
    return isNeedExplode;
  }

  /// To find sum of points in the series.
  void _findSumOfPoints(CircularSeriesRendererExtension seriesRenderer) {
    seriesRenderer.segmentRenderingValues['sumOfPoints'] = 0;
    for (final ChartPoint<dynamic> point in seriesRenderer.renderPoints!) {
      if (point.isVisible) {
        seriesRenderer.segmentRenderingValues['sumOfPoints'] =
            seriesRenderer.segmentRenderingValues['sumOfPoints']! +
                point.y!.abs();
      }
    }
  }

  /// To calculate angle of series.
  void _calculateAngle(CircularSeriesRendererExtension seriesRenderer) {
    seriesRenderer.segmentRenderingValues['start'] =
        currentSeries.startAngle < 0
            ? currentSeries.startAngle < -360
                ? (currentSeries.startAngle % 360) + 360
                : currentSeries.startAngle + 360
            : currentSeries.startAngle;
    seriesRenderer.segmentRenderingValues['end'] = currentSeries.endAngle < 0
        ? currentSeries.endAngle < -360
            ? (currentSeries.endAngle % 360) + 360
            : currentSeries.endAngle + 360
        : currentSeries.endAngle;
    seriesRenderer.segmentRenderingValues['start'] =
        seriesRenderer.segmentRenderingValues['start']! > 360 == true
            ? seriesRenderer.segmentRenderingValues['start']! % 360
            : seriesRenderer.segmentRenderingValues['start']!;
    seriesRenderer.segmentRenderingValues['end'] =
        seriesRenderer.segmentRenderingValues['end']! > 360 == true
            ? seriesRenderer.segmentRenderingValues['end']! % 360
            : seriesRenderer.segmentRenderingValues['end']!;
    seriesRenderer.segmentRenderingValues['start'] =
        seriesRenderer.segmentRenderingValues['start']! - 90;
    seriesRenderer.segmentRenderingValues['end'] =
        seriesRenderer.segmentRenderingValues['end']! - 90;
    seriesRenderer.segmentRenderingValues['end'] =
        seriesRenderer.segmentRenderingValues['start']! ==
                seriesRenderer.segmentRenderingValues['end']!
            ? seriesRenderer.segmentRenderingValues['start']! + 360
            : seriesRenderer.segmentRenderingValues['end']!;
    seriesRenderer.segmentRenderingValues['totalAngle'] =
        seriesRenderer.segmentRenderingValues['start']! >
                    seriesRenderer.segmentRenderingValues['end']! ==
                true
            ? (seriesRenderer.segmentRenderingValues['start']! - 360).abs() +
                seriesRenderer.segmentRenderingValues['end']!
            : (seriesRenderer.segmentRenderingValues['start']! -
                    seriesRenderer.segmentRenderingValues['end']!)
                .abs();
  }

  /// To calculate radius of circular chart.
  void _calculateRadius(CircularSeriesRendererExtension seriesRenderer) {
    final Rect chartAreaRect = stateProperties.renderingDetails.chartAreaRect;
    size = min(chartAreaRect.width, chartAreaRect.height);
    seriesRenderer.segmentRenderingValues['currentRadius'] =
        percentToValue(currentSeries.radius, size / 2)!.toDouble();
    seriesRenderer.segmentRenderingValues['currentInnerRadius'] =
        percentToValue(currentSeries.innerRadius,
            seriesRenderer.segmentRenderingValues['currentRadius']!)!;
  }

  /// To calculate center location of chart.
  void _calculateOrigin(CircularSeriesRendererExtension seriesRenderer) {
    final Rect chartAreaRect = stateProperties.renderingDetails.chartAreaRect;
    final Rect chartContainerRect =
        stateProperties.renderingDetails.chartContainerRect;
    seriesRenderer.center = Offset(
        percentToValue(chart.centerX, chartAreaRect.width)!.toDouble(),
        percentToValue(chart.centerY, chartAreaRect.height)!.toDouble());
    seriesRenderer.center = Offset(
        seriesRenderer.center!.dx +
            (chartContainerRect.width - chartAreaRect.width).abs() / 2,
        seriesRenderer.center!.dy +
            (chartContainerRect.height - chartAreaRect.height).abs() / 2);
    stateProperties.centerLocation = seriesRenderer.center!;
  }

  /// To find explode center position.
  Offset _findExplodeCenter(num midAngle,
      CircularSeriesRendererExtension seriesRenderer, num currentRadius) {
    final num explodeCenter =
        percentToValue(seriesRenderer.series.explodeOffset, currentRadius)!;
    return degreeToPoint(midAngle, explodeCenter, seriesRenderer.center!);
  }

  /// To calculate and return point radius.
  num _calculatePointRadius(
      dynamic value, ChartPoint<dynamic> point, num radius) {
    radius = value != null ? percentToValue(value, size / 2)! : radius;
    return radius;
  }

  /// To add selection points to selection list.
  void seriesPointSelection(Region? pointRegion, ActivationMode mode,
      [int? pointIndex, int? seriesIndex]) {
    bool isPointAlreadySelected = false;
    pointIndex = pointRegion != null ? pointRegion.pointIndex : pointIndex;
    seriesIndex = pointRegion != null ? pointRegion.seriesIndex : seriesIndex;
    final CircularSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex!];
    int? currentSelectedIndex;
    if (seriesRenderer.isSelectionEnable && mode == chart.selectionGesture) {
      if (stateProperties.renderingDetails.selectionData.isNotEmpty) {
        if (!chart.enableMultiSelection &&
            stateProperties.renderingDetails.selectionData.isNotEmpty &&
            stateProperties.renderingDetails.selectionData.length > 1) {
          if (stateProperties.renderingDetails.selectionData
              .contains(pointIndex)) {
            currentSelectedIndex = pointIndex!;
          }
          stateProperties.renderingDetails.selectionData.clear();
          if (currentSelectedIndex != null) {
            stateProperties.renderingDetails.selectionData.add(pointIndex!);
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
        stateProperties.renderingDetails.selectionData.add(pointIndex!);
        stateProperties.renderingDetails.seriesRepaintNotifier.value++;
        if (chart.onSelectionChanged != null) {
          chart.onSelectionChanged!(
              _getSelectionEventArgs(seriesRenderer, seriesIndex, pointIndex));
        }
      }
    }
  }

  /// To perform selection event and return Selection Args.
  SelectionArgs _getSelectionEventArgs(
      dynamic seriesRenderer, int seriesIndex, int pointIndex) {
    if (seriesRenderer != null) {
      final SelectionBehavior selectionBehavior =
          seriesRenderer.selectionBehavior;
      final SelectionArgs args = SelectionArgs(
          seriesRenderer: seriesRenderer,
          seriesIndex: seriesIndex,
          viewportPointIndex: pointIndex,
          pointIndex: pointIndex);
      args.selectedBorderColor = selectionBehavior.selectedBorderColor;
      args.selectedBorderWidth = selectionBehavior.selectedBorderWidth;
      args.selectedColor = selectionBehavior.selectedColor;
      args.unselectedBorderColor = selectionBehavior.unselectedBorderColor;
      args.unselectedBorderWidth = selectionBehavior.unselectedBorderWidth;
      args.unselectedColor = selectionBehavior.unselectedColor;
      seriesRenderer.selectionArgs = args;
    }
    return seriesRenderer.selectionArgs as SelectionArgs;
  }

  /// Method to explode the series point.
  void seriesPointExplosion(Region? pointRegion) {
    bool existExplodedRegion = false;
    final CircularSeriesRendererExtension seriesRenderer = stateProperties
        .chartSeries.visibleSeriesRenderers[pointRegion!.seriesIndex];
    final ChartPoint<dynamic> point =
        seriesRenderer.renderPoints![pointRegion.pointIndex];
    int explodeIndex;
    if (seriesRenderer.series.explode) {
      if (stateProperties.renderingDetails.explodedPoints.isNotEmpty) {
        if (stateProperties.renderingDetails.explodedPoints.length == 1 &&
            stateProperties.renderingDetails.explodedPoints
                .contains(pointRegion.pointIndex)) {
          existExplodedRegion = true;
          point.center = seriesRenderer.center;
          final int index = stateProperties.renderingDetails.explodedPoints
              .indexOf(pointRegion.pointIndex);
          stateProperties.renderingDetails.explodedPoints.removeAt(index);
          stateProperties.renderingDetails.seriesRepaintNotifier.value++;
          stateProperties
              .renderDataLabel!.state.dataLabelRepaintNotifier.value++;
        } else if (seriesRenderer.series.explodeAll &&
            stateProperties.renderingDetails.explodedPoints.length > 1 &&
            stateProperties.renderingDetails.explodedPoints
                .contains(pointRegion.pointIndex)) {
          for (int i = 0;
              i < stateProperties.renderingDetails.explodedPoints.length;
              i++) {
            explodeIndex = stateProperties.renderingDetails.explodedPoints[i];
            seriesRenderer.renderPoints![explodeIndex].center =
                seriesRenderer.center;
            stateProperties.renderingDetails.explodedPoints.removeAt(i);
            i--;
          }
          existExplodedRegion = true;
          stateProperties.renderingDetails.seriesRepaintNotifier.value++;
          stateProperties
              .renderDataLabel!.state.dataLabelRepaintNotifier.value++;
        } else if (stateProperties.renderingDetails.explodedPoints.length ==
            1) {
          for (int i = 0;
              i < stateProperties.renderingDetails.explodedPoints.length;
              i++) {
            explodeIndex = stateProperties.renderingDetails.explodedPoints[i];
            seriesRenderer.renderPoints![explodeIndex].center =
                seriesRenderer.center;
            stateProperties.renderingDetails.explodedPoints.removeAt(i);
            stateProperties.renderingDetails.seriesRepaintNotifier.value++;
            stateProperties
                .renderDataLabel!.state.dataLabelRepaintNotifier.value++;
          }
        }
      }
      if (!existExplodedRegion) {
        point.center = _findExplodeCenter(
            point.midAngle!, seriesRenderer, point.outerRadius!);
        stateProperties.renderingDetails.explodedPoints
            .add(pointRegion.pointIndex);
        stateProperties.renderingDetails.seriesRepaintNotifier.value++;
        stateProperties.renderDataLabel!.state.dataLabelRepaintNotifier.value++;
      }
    }
  }

  /// Setting series type.
  void _setSeriesType(CircularSeriesRendererExtension seriesRenderer) {
    if (seriesRenderer is PieSeriesRendererExtension) {
      seriesRenderer.seriesType = 'pie';
    } else if (seriesRenderer is DoughnutSeriesRendererExtension) {
      seriesRenderer.seriesType = 'doughnut';
    } else if (seriesRenderer is RadialBarSeriesRendererExtension) {
      seriesRenderer.seriesType = 'radialbar';
    }
  }
}
