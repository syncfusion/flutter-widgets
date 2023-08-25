import 'dart:ui' as dart_ui;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../chart/common/data_label.dart';
import '../../common/event_args.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../base/circular_base.dart';
import '../base/circular_state_properties.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'chart_point.dart';
import 'circular_series.dart';
import 'circular_series_controller.dart';
import 'common.dart';
import 'radial_bar_series.dart';
import 'renderer_base.dart';

/// Creates a series renderer for circular series.
class CircularSeriesRendererExtension implements CircularSeriesRenderer {
  /// Specifies the circular series.
  late CircularSeries<dynamic, dynamic> series;

  /// Specifies the chart series renderer.
  late ChartSeriesRender renderer;

  /// Specifies the series type.
  late String seriesType;

  /// Specifies the list of data points.
  late List<ChartPoint<dynamic>> dataPoints;

  /// Specifies whether to repaint the series.
  bool needsRepaint = true;

  /// Specifies the list of rendering points.
  List<ChartPoint<dynamic>>? renderPoints;

  /// Specifies the list of old render points.
  List<ChartPoint<dynamic>>? oldRenderPoints;

  /// Specifies the map collection that holds all the values for rendering
  /// the segment.
  Map<String, num> segmentRenderingValues = <String, num>{};

  /// Specifies the value of center.
  Offset? center;

  /// Specifies the value of point region
  late List<Region> pointRegions;

  /// Specifies the value of rect.
  // ignore:unused_field
  late Rect rect;

  /// Path saved for radial bar series.
  List<Path> renderPaths = <Path>[];

  /// Specifies the value of render list.
  List<dynamic> renderList = <dynamic>[];

  /// Specifies the value of inner radial radius.
  num? innerRadialradius;

  /// Specifies the value of selection args.
  SelectionArgs? selectionArgs;

  /// Determines whether there is a need for animation.
  late bool needsAnimation;

  /// We can redraw the series by updating or creating new points by using this controller. If we need to access the redrawing methods
  /// in this before we must get the ChartSeriesController onRendererCreated event.
  CircularSeriesController? controller;

  /// Specifies the circular state properties.
  late CircularStateProperties stateProperties;

  /// Repaint notifier for series.
  late ValueNotifier<int> repaintNotifier;

  /// Specifies the data label setting renderer.
  late DataLabelSettingsRenderer dataLabelSettingsRenderer;

  /// Specifies the  selection behavior renderer.
  late SelectionBehaviorRenderer selectionBehaviorRenderer;

  /// Specifies the selection behavior.
  dynamic selectionBehavior;

  /// Check whether the selection is enabled.
  // ignore: prefer_final_fields
  bool isSelectionEnable = false;

  /// To set style properties for selected points.
  StyleOptions? selectPoint(
      int currentPointIndex,
      CircularSeriesRendererExtension seriesRenderer,
      SfCircularChart chart,
      ChartPoint<dynamic>? point) {
    StyleOptions? pointStyle;
    final dynamic selection = series.selectionBehavior;
    if (selection.enable == true) {
      if (stateProperties.renderingDetails.selectionData.isNotEmpty) {
        int selectionIndex;
        for (int i = 0;
            i < stateProperties.renderingDetails.selectionData.length;
            i++) {
          selectionIndex = stateProperties.renderingDetails.selectionData[i];
          if (currentPointIndex == selectionIndex) {
            pointStyle = StyleOptions(
                fill: seriesRenderer.selectionArgs != null
                    ? seriesRenderer.selectionArgs!.selectedColor
                    : selection.selectedColor,
                strokeWidth: seriesRenderer.selectionArgs != null
                    ? seriesRenderer.selectionArgs!.selectedBorderWidth
                    : selection.selectedBorderWidth,
                strokeColor: seriesRenderer.selectionArgs != null
                    ? seriesRenderer.selectionArgs!.selectedBorderColor
                    : selection.selectedBorderColor,
                opacity: selection.selectedOpacity);
            break;
          } else if (i ==
              stateProperties.renderingDetails.selectionData.length - 1) {
            pointStyle = StyleOptions(
                fill: seriesRenderer.selectionArgs != null
                    ? seriesRenderer.selectionArgs!.unselectedColor
                    : selection.unselectedColor,
                strokeWidth: seriesRenderer.selectionArgs != null
                    ? selectionArgs!.unselectedBorderWidth
                    : selection.unselectedBorderWidth,
                strokeColor: seriesRenderer.selectionArgs != null
                    ? seriesRenderer.selectionArgs!.unselectedBorderColor
                    : selection.unselectedBorderColor,
                opacity: selection.unselectedOpacity);
          }
        }
      }
    }
    return pointStyle;
  }

  /// To calculate point start and end angle.
  num? circularRenderPoint(
      SfCircularChart chart,
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic> point,
      num? pointStartAngle,
      num? innerRadius,
      num? outerRadius,
      Canvas canvas,
      int seriesIndex,
      int pointIndex,
      num animationDegreeValue,
      num animationRadiusValue,
      bool isAnyPointSelect,
      ChartPoint<dynamic>? oldPoint,
      List<ChartPoint<dynamic>?>? oldPointList) {
    final bool isDynamicUpdate = oldPoint != null;
    final num oldStartAngle = oldPoint?.startAngle ?? 0;
    final num oldEndAngle = oldPoint?.endAngle ?? 0;
    num? degree, pointEndAngle;

    /// Below lines for dynamic dataSource changes.
    if (isDynamicUpdate) {
      if (!oldPoint.isVisible && point.isVisible) {
        final num val = point.startAngle ==
                seriesRenderer.segmentRenderingValues['start']!
            ? seriesRenderer.segmentRenderingValues['start']!
            : oldPointList![
                    getVisiblePointIndex(oldPointList, 'before', pointIndex)!]!
                .endAngle!;
        pointStartAngle =
            val - (val - point.startAngle!) * animationDegreeValue;
        pointEndAngle = val + (point.endAngle! - val) * animationDegreeValue;
        degree = pointEndAngle - pointStartAngle;
      } else if (oldPoint.isVisible && !point.isVisible) {
        if (oldPoint.startAngle!.round() ==
                seriesRenderer.segmentRenderingValues['start'] &&
            (oldPoint.endAngle!.round() ==
                    seriesRenderer.segmentRenderingValues['end'] ||
                oldPoint.endAngle!.round() ==
                    360 + seriesRenderer.segmentRenderingValues['end']!)) {
          pointStartAngle = oldPoint.startAngle!;
          pointEndAngle = oldPoint.endAngle! -
              (oldPoint.endAngle! - oldPoint.startAngle!) *
                  animationDegreeValue;
        } else if (oldPoint.startAngle == oldPoint.endAngle) {
          pointStartAngle = pointEndAngle = oldPoint.startAngle!;
        } else {
          pointStartAngle = oldPoint.startAngle! -
              (oldPoint.startAngle! -
                      (oldPoint.startAngle ==
                              seriesRenderer.segmentRenderingValues['start']!
                          ? seriesRenderer.segmentRenderingValues['start']!
                          : seriesRenderer
                              .renderPoints![getVisiblePointIndex(
                                  seriesRenderer.renderPoints!,
                                  'before',
                                  pointIndex)!]
                              .endAngle!)) *
                  animationDegreeValue;
          pointEndAngle = oldPoint.endAngle! -
              (oldPoint.endAngle! -
                      ((oldPoint.endAngle!.round() ==
                                  seriesRenderer
                                      .segmentRenderingValues['end'] ||
                              oldPoint.endAngle!.round() ==
                                  360 +
                                      seriesRenderer
                                          .segmentRenderingValues['end']!)
                          ? oldPoint.endAngle!
                          : seriesRenderer
                              .renderPoints![getVisiblePointIndex(
                                  seriesRenderer.renderPoints!,
                                  'after',
                                  pointIndex)!]
                              .startAngle!)) *
                  animationDegreeValue;
        }
        degree = pointEndAngle - pointStartAngle;
      } else if (point.isVisible && oldPoint.isVisible) {
        pointStartAngle = (point.startAngle! > oldStartAngle)
            ? oldStartAngle +
                ((point.startAngle! - oldStartAngle) * animationDegreeValue)
            : oldStartAngle -
                ((oldStartAngle - point.startAngle!) * animationDegreeValue);
        pointEndAngle = (point.endAngle! > oldEndAngle)
            ? oldEndAngle +
                ((point.endAngle! - oldEndAngle) * animationDegreeValue)
            : oldEndAngle -
                ((oldEndAngle - point.endAngle!) * animationDegreeValue);
        degree = pointEndAngle - pointStartAngle;
      }
    } else if (point.isVisible) {
      degree = animationDegreeValue * point.degree!;
      pointEndAngle = pointStartAngle! + degree;
    }
    outerRadius = stateProperties.renderingDetails.initialRender!
        ? animationRadiusValue * outerRadius!
        : outerRadius;
    _calculatePath(
        pointIndex,
        seriesIndex,
        chart,
        seriesRenderer,
        point,
        oldPoint,
        canvas,
        degree,
        innerRadius,
        outerRadius,
        pointStartAngle,
        pointEndAngle,
        isDynamicUpdate);
    return pointEndAngle;
  }

  /// Calculating the data point path.
  void _calculatePath(
      int pointIndex,
      int seriesIndex,
      SfCircularChart chart,
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic>? point,
      ChartPoint<dynamic>? oldPoint,
      Canvas canvas,
      num? degree,
      num? innerRadius,
      num? outerRadius,
      num? pointStartAngle,
      num? pointEndAngle,
      bool isDynamicUpdate) {
    Path? renderPath;
    final CornerStyle cornerStyle = series.cornerStyle;
    late num actualStartAngle, actualEndAngle;
    if (!isDynamicUpdate ||
        (isDynamicUpdate &&
            ((oldPoint!.isVisible && point!.isVisible) ||
                (oldPoint.isVisible && !point!.isVisible) ||
                (!oldPoint.isVisible && point!.isVisible)))) {
      innerRadius = innerRadius ?? oldPoint!.innerRadius;
      outerRadius = outerRadius ?? oldPoint!.outerRadius;
      if (cornerStyle != CornerStyle.bothFlat) {
        final num angleDeviation =
            findAngleDeviation(innerRadius!, outerRadius!, 360);
        actualStartAngle = (cornerStyle == CornerStyle.startCurve ||
                cornerStyle == CornerStyle.bothCurve)
            ? (pointStartAngle! + angleDeviation)
            : pointStartAngle!;
        actualEndAngle = (cornerStyle == CornerStyle.endCurve ||
                cornerStyle == CornerStyle.bothCurve)
            ? (pointEndAngle! - angleDeviation)
            : pointEndAngle!;
      }
      renderPath = Path();
      renderPath = (cornerStyle == CornerStyle.startCurve ||
              cornerStyle == CornerStyle.endCurve ||
              cornerStyle == CornerStyle.bothCurve)
          ? getRoundedCornerArcPath(
              innerRadius!,
              outerRadius!,
              point!.center ?? oldPoint!.center,
              actualStartAngle,
              actualEndAngle,
              degree,
              cornerStyle,
              point)
          : getArcPath(
              innerRadius!,
              outerRadius!,
              point!.center ?? oldPoint!.center!,
              pointStartAngle,
              pointEndAngle,
              degree,
              chart,
              stateProperties.renderingDetails.animateCompleted);
    }
    drawDataPoints(pointIndex, seriesIndex, chart, seriesRenderer, point,
        canvas, renderPath, degree, innerRadius);
  }

  /// Draw slice path.
  void drawDataPoints(
      int pointIndex,
      int seriesIndex,
      SfCircularChart chart,
      CircularSeriesRendererExtension seriesRenderer,
      ChartPoint<dynamic>? point,
      Canvas canvas,
      Path? renderPath,
      num? degree,
      num? innerRadius) {
    if (point != null && point.isVisible) {
      final Region pointRegion = Region(
          degreesToRadians(point.startAngle!),
          degreesToRadians(point.endAngle!),
          point.startAngle!,
          point.endAngle!,
          seriesIndex,
          pointIndex,
          point.center,
          innerRadius,
          point.outerRadius!);
      seriesRenderer.pointRegions.add(pointRegion);
    }
    final StyleOptions? style =
        selectPoint(pointIndex, seriesRenderer, chart, point);

    final Color? fillColor = style != null && style.fill != null
        ? style.fill
        : (point != null && point.fill != Colors.transparent
            ? seriesRenderer.renderer.getPointColor(
                seriesRenderer,
                point,
                pointIndex,
                seriesIndex,
                point.fill,
                seriesRenderer.series.opacity)
            : point!.fill);

    final Color? strokeColor = style != null && style.strokeColor != null
        ? style.strokeColor
        : seriesRenderer.renderer.getPointStrokeColor(
            seriesRenderer, point, pointIndex, seriesIndex, point!.strokeColor);

    final num? strokeWidth = style != null && style.strokeWidth != null
        ? style.strokeWidth
        : seriesRenderer.renderer.getPointStrokeWidth(
            seriesRenderer, point, pointIndex, seriesIndex, point!.strokeWidth);

    assert(seriesRenderer.series.opacity >= 0,
        'The opacity value will not accept negative numbers.');
    assert(seriesRenderer.series.opacity <= 1,
        'The opacity value must be less than 1.');
    final double? opacity = style != null && style.opacity != null
        ? style.opacity
        : seriesRenderer.renderer.getOpacity(seriesRenderer, point, pointIndex,
            seriesIndex, seriesRenderer.series.opacity);

    Shader? renderModeShader;

    if (chart.series[0].pointRenderMode == PointRenderMode.gradient &&
        point?.shader == null) {
      final List<Color> colorsList = <Color>[];
      final List<double> stopsList = <double>[];
      num initStops = 0;
      for (int i = 0; i < seriesRenderer.renderPoints!.length; i++) {
        point = seriesRenderer.renderPoints![i];
        if (point.isVisible) {
          colorsList.add(point.fill);
          if (stopsList.isEmpty) {
            initStops = (point.y! / segmentRenderingValues['sumOfPoints']!) / 4;
            stopsList.add(
                point.y! / segmentRenderingValues['sumOfPoints']! - initStops);
          } else {
            if (stopsList.length == 1) {
              stopsList.add((point.y! / segmentRenderingValues['sumOfPoints']! +
                      stopsList.last) +
                  initStops / 1.5);
            } else {
              stopsList.add(point.y! / segmentRenderingValues['sumOfPoints']! +
                  stopsList.last);
            }
          }
        }
      }

      renderModeShader = dart_ui.Gradient.sweep(
          center!,
          colorsList,
          stopsList,
          TileMode.clamp,
          degreeToRadian(chart.series[0].startAngle),
          degreeToRadian(chart.series[0].endAngle),
          resolveTransform(
              Rect.fromCircle(
                center: center!,
                radius: point!.outerRadius!.toDouble(),
              ),
              TextDirection.ltr));
    }

    if (renderPath != null && degree! > 0) {
      if (seriesRenderer is DoughnutSeriesRenderer) {
        seriesRenderer.innerRadialradius =
            !point!.isVisible || (seriesRenderer.innerRadialradius == null)
                ? innerRadius
                : seriesRenderer.innerRadialradius;
      }
      if (point != null &&
          (point.isVisible ||
              (!point.isVisible &&
                  point.index == seriesRenderer.dataPoints.length - 1 &&
                  chart.onCreateShader != null))) {
        PointHelper.setPathRect(
            point,
            Rect.fromCircle(
              center: center!,
              radius: point.outerRadius!.toDouble(),
            ));
      }
      seriesRenderer.renderPaths.add(renderPath);
      if (chart.onCreateShader != null &&
          point != null &&
          (point.isVisible ||
              (!point.isVisible &&
                  point.index == seriesRenderer.dataPoints.length - 1 &&
                  chart.onCreateShader != null)) &&
          point.shader == null) {
        Rect? innerRect;
        if (seriesRenderer is DoughnutSeriesRenderer &&
            seriesRenderer.innerRadialradius != null) {
          innerRect = Rect.fromCircle(
            center: center!,
            radius: seriesRenderer.innerRadialradius!.toDouble(),
          );
        } else {
          innerRect = null;
        }
        if (point.isVisible ||
            (!point.isVisible &&
                point.index == seriesRenderer.dataPoints.length - 1 &&
                chart.onCreateShader != null)) {
          renderList.clear();
          seriesRenderer.renderList.add(StyleOptions(
              fill: fillColor!,
              strokeWidth: stateProperties.renderingDetails.animateCompleted
                  ? strokeWidth!
                  : 0,
              strokeColor: strokeColor!,
              opacity: opacity));
          seriesRenderer.renderList.add(PointHelper.getPathRect(point));
          seriesRenderer.renderList.add(innerRect);
        }
      } else {
        drawPath(
            canvas,
            StyleOptions(
                fill: fillColor!,
                strokeWidth: stateProperties.renderingDetails.animateCompleted
                    ? strokeWidth!
                    : 0,
                strokeColor: strokeColor!,
                opacity: opacity),
            renderPath,
            PointHelper.getPathRect(point!),
            point.shader ?? renderModeShader);
        // ignore: unnecessary_null_comparison
        if (point != null &&
            (renderModeShader != null || point.shader != null)) {
          // ignore: unnecessary_null_comparison
          if (strokeColor != null &&
              strokeWidth != null &&
              strokeWidth > 0 &&
              stateProperties.renderingDetails.animateCompleted) {
            final Paint paint = Paint();
            paint.color = strokeColor;
            paint.strokeWidth = strokeWidth.toDouble();
            paint.style = PaintingStyle.stroke;
            canvas.drawPath(renderPath, paint);
          }
        }
      }
    }
  }
}

/// Creates series renderer for Pie series.
class PieSeriesRendererExtension extends PieSeriesRenderer
    with CircularSeriesRendererExtension {
  /// Calling the default constructor of PieSeriesRenderer class.
  PieSeriesRendererExtension() {
    seriesType = 'pie';
  }

  @override
  late CircularSeries<dynamic, dynamic> series;

  /// Specifies the chart point info.
  ChartPoint<dynamic>? point;
}

/// Creates series renderer for Doughnut series.
class DoughnutSeriesRendererExtension extends DoughnutSeriesRenderer
    with CircularSeriesRendererExtension {
  /// Calling the default constructor of DoughnutSeriesRenderer class.
  DoughnutSeriesRendererExtension() {
    seriesType = 'doughnut';
  }

  /// Stores the series of the corresponding series for renderer.
  @override
  late CircularSeries<dynamic, dynamic> series;

  /// Specifies the inner radius value.
  late num innerRadius;

  /// Specifies the radius value.
  late num radius;
}

/// Creates series renderer for RadialBar series.
///
class RadialBarSeriesRendererExtension extends RadialBarSeriesRenderer
    with CircularSeriesRendererExtension {
  /// Calling the default constructor of RadialBarSeriesRenderer class.
  RadialBarSeriesRendererExtension() {
    shadowPaths = <Path>[];
    overFilledPaths = <Path>[];
    seriesType = 'radialbar';
  }

  @override
  late CircularSeries<dynamic, dynamic> series;

  /// Specifies the inner radius value.
  late num innerRadius;

  /// Specifies the radius value.
  late num radius;

  /// Specifies the value of fill color and stroke color.
  late Color fillColor, strokeColor;

  /// Specifies the value of opacity and stroke width.
  late double opacity, strokeWidth;

  /// Holds the value of shadow path.
  late List<Path> shadowPaths;

  /// Holds the value of over filled path.
  late List<Path> overFilledPaths;

  /// Represents the value of shadow paint.
  late Paint shadowPaint;

  /// Represents the value of over filles paint
  Paint? overFilledPaint;

  @override
  Offset? center;

  /// Method to find first visible point.
  int? getFirstVisiblePointIndex(
      RadialBarSeriesRendererExtension seriesRenderer) {
    for (int i = 0; i < seriesRenderer.renderPoints!.length; i++) {
      if (seriesRenderer.renderPoints![i].isVisible) {
        return i;
      }
    }
    return null;
  }

  /// Method for calculating animation for visible points on legend toggle.
  ///
  void calculateVisiblePointLegendToggleAnimation(ChartPoint<dynamic> point,
      ChartPoint<dynamic>? oldPoint, int i, num animationValue) {
    if (!oldPoint!.isVisible && point.isVisible) {
      radius = i == 0
          ? point.outerRadius!
          : (point.innerRadius! +
              (point.outerRadius! - point.innerRadius!) * animationValue);
      innerRadius = i == 0
          ? (point.outerRadius! -
              (point.outerRadius! - point.innerRadius!) * animationValue)
          : innerRadius;
    } else {
      radius = (point.outerRadius! > oldPoint.outerRadius!)
          ? oldPoint.outerRadius! +
              (point.outerRadius! - oldPoint.outerRadius!) * animationValue
          : oldPoint.outerRadius! -
              (oldPoint.outerRadius! - point.outerRadius!) * animationValue;
      innerRadius = (point.innerRadius! > oldPoint.innerRadius!)
          ? oldPoint.innerRadius! +
              (point.innerRadius! - oldPoint.innerRadius!) * animationValue
          : oldPoint.innerRadius! -
              (oldPoint.innerRadius! - point.innerRadius!) * animationValue;
    }
  }

  /// To draw data points of the radial bar series.
  ///
  void drawDataPoint(
      ChartPoint<dynamic> point,
      num? degree,
      num pointStartAngle,
      num? pointEndAngle,
      RadialBarSeriesRendererExtension seriesRenderer,
      bool hide,
      num? oldRadius,
      num? oldInnerRadius,
      ChartPoint<dynamic>? oldPoint,
      num? oldStart,
      num? oldEnd,
      int i,
      Canvas canvas,
      int index,
      SfCircularChart chart,
      double actualDegree) {
    late RadialBarSeries<dynamic, dynamic> series;
    if (seriesRenderer.series is RadialBarSeries) {
      series = seriesRenderer.series as RadialBarSeries<dynamic, dynamic>;
    }
    drawPath(
        canvas,
        StyleOptions(
            fill: series.useSeriesColor ? point.fill : series.trackColor,
            strokeWidth: series.trackBorderWidth,
            strokeColor: series.trackBorderColor,
            opacity: series.trackOpacity),
        getArcPath(
            hide ? oldInnerRadius! : innerRadius,
            hide ? oldRadius! : radius.toDouble(),
            center!,
            0,
            360 - 0.001,
            360 - 0.001,
            chart,
            true));
    if (radius > 0 && degree != null && degree > 0) {
      _renderRadialPoints(
          point,
          degree,
          pointStartAngle,
          pointEndAngle,
          seriesRenderer,
          hide,
          oldRadius,
          oldInnerRadius,
          oldPoint,
          oldStart,
          oldEnd,
          i,
          canvas,
          index,
          chart,
          actualDegree);
    }
  }

  /// Method to render radial data points.
  ///
  void _renderRadialPoints(
      ChartPoint<dynamic> point,
      num? degree,
      num pointStartAngle,
      num? pointEndAngle,
      RadialBarSeriesRendererExtension seriesRenderer,
      bool hide,
      num? oldRadius,
      num? oldInnerRadius,
      ChartPoint<dynamic>? oldPoint,
      num? oldStart,
      num? oldEnd,
      int i,
      Canvas canvas,
      int index,
      SfCircularChart chart,
      double actualDegree) {
    if (point.isVisible) {
      final Region pointRegion = Region(
          degreesToRadians(point.startAngle!),
          degreesToRadians(point.endAngle!),
          point.startAngle!,
          point.endAngle!,
          index,
          i,
          point.center,
          innerRadius,
          point.outerRadius!);
      seriesRenderer.pointRegions.add(pointRegion);
    }

    final num angleDeviation = findAngleDeviation(
        hide ? oldInnerRadius! : innerRadius, hide ? oldRadius! : radius, 360);
    final CornerStyle cornerStyle = series.cornerStyle;
    if (cornerStyle == CornerStyle.bothCurve ||
        cornerStyle == CornerStyle.startCurve) {
      hide
          ? oldStart = oldPoint!.startAngle! + angleDeviation
          : pointStartAngle += angleDeviation;
    }
    if (cornerStyle == CornerStyle.bothCurve ||
        cornerStyle == CornerStyle.endCurve) {
      hide
          ? oldEnd = oldPoint!.endAngle! - angleDeviation
          : pointEndAngle = pointEndAngle! - angleDeviation;
    }
    final StyleOptions? style =
        seriesRenderer.selectPoint(i, seriesRenderer, chart, point);
    fillColor = style != null && style.fill != null
        ? style.fill!
        : (point.fill != Colors.transparent
            ? seriesRenderer.renderer.getPointColor(
                seriesRenderer, point, i, index, point.fill, series.opacity)!
            : point.fill);
    strokeColor = style != null && style.strokeColor != null
        ? style.strokeColor!
        : seriesRenderer.renderer.getPointStrokeColor(
            seriesRenderer, point, i, index, point.strokeColor);
    strokeWidth = style != null && style.strokeWidth != null
        ? style.strokeWidth!.toDouble()
        : seriesRenderer.renderer
            .getPointStrokeWidth(
                seriesRenderer, point, i, index, point.strokeWidth)
            .toDouble();
    opacity = style != null && style.opacity != null
        ? style.opacity!.toDouble()
        : seriesRenderer.renderer
            .getOpacity(seriesRenderer, point, i, index, series.opacity);
    seriesRenderer.innerRadialradius =
        !point.isVisible || (seriesRenderer.innerRadialradius == null)
            ? innerRadius
            : seriesRenderer.innerRadialradius;
    seriesRenderer.renderList.clear();

    _drawRadialBarPath(
        canvas,
        point,
        chart,
        seriesRenderer,
        hide,
        pointStartAngle,
        pointEndAngle,
        oldRadius,
        oldInnerRadius,
        oldStart,
        oldEnd,
        degree,
        actualDegree);
  }

  /// Method to draw the radial bar series path.
  ///
  void _drawRadialBarPath(
      Canvas canvas,
      ChartPoint<dynamic> point,
      SfCircularChart chart,
      RadialBarSeriesRendererExtension seriesRenderer,
      bool hide,
      num pointStartAngle,
      num? pointEndAngle,
      num? oldRadius,
      num? oldInnerRadius,
      num? oldStart,
      num? oldEnd,
      num? degree,
      double actualDegree) {
    Path path;
    if (degree! > 360) {
      path = getRoundedCornerArcPath(
          hide ? oldInnerRadius! : innerRadius,
          hide ? oldRadius! : radius,
          center!,
          0,
          360 - 0.001,
          360 - 0.001,
          series.cornerStyle,
          point);
      final double currentInnerRadius =
          hide ? oldInnerRadius!.toDouble() : innerRadius.toDouble();
      final double outerRadius =
          hide ? oldRadius!.toDouble() : radius.toDouble();
      final double startAngle =
          hide ? oldStart!.toDouble() : pointStartAngle.toDouble();
      final double endAngle =
          hide ? oldEnd!.toDouble() : pointEndAngle!.toDouble();
      path.arcTo(
          Rect.fromCircle(center: center!, radius: outerRadius.toDouble()),
          degreesToRadians(startAngle).toDouble(),
          degreesToRadians(endAngle - startAngle).toDouble(),
          true);
      path.arcTo(
          Rect.fromCircle(
              center: center!, radius: currentInnerRadius.toDouble()),
          degreesToRadians(endAngle.toDouble()).toDouble(),
          (degreesToRadians(startAngle.toDouble()) -
                  degreesToRadians(endAngle.toDouble()))
              .toDouble(),
          false);
    } else {
      path = getRoundedCornerArcPath(
          hide ? oldInnerRadius! : innerRadius,
          hide ? oldRadius! : radius,
          center!,
          hide ? oldStart! : pointStartAngle,
          hide ? oldEnd! : pointEndAngle!,
          degree,
          series.cornerStyle,
          point);
    }

    seriesRenderer.renderPaths.add(path);

    if (chart.onCreateShader != null && point.shader == null) {
      PointHelper.setPathRect(
          point,
          Rect.fromCircle(
            center: center!,
            radius: radius.toDouble(),
          ));
      Rect innerRect;
      innerRect = Rect.fromCircle(
        center: center!,
        radius: seriesRenderer.innerRadialradius!.toDouble(),
      );
      seriesRenderer.renderList.add(StyleOptions(
          fill: fillColor,
          strokeWidth: stateProperties.renderingDetails.animateCompleted
              ? strokeWidth
              : 0,
          strokeColor: strokeColor,
          opacity: opacity));
      seriesRenderer.renderList.add(PointHelper.getPathRect(point));
      seriesRenderer.renderList.add(innerRect);
    } else {
      if (hide
          ? (((oldEnd! - oldStart!) > 0) && (oldRadius != oldInnerRadius))
          : ((pointEndAngle! - pointStartAngle) > 0)) {
        drawPath(
            canvas,
            StyleOptions(
                fill: fillColor,
                strokeWidth: stateProperties.renderingDetails.animateCompleted
                    ? strokeWidth
                    : 0,
                strokeColor: strokeColor,
                opacity: opacity),
            path,
            PointHelper.getPathRect(point),
            point.shader);
        // ignore: unnecessary_null_comparison
        if (point.shader != null &&
            // ignore: unnecessary_null_comparison
            strokeColor != null &&
            // ignore: unnecessary_null_comparison
            strokeWidth != null &&
            strokeWidth > 0 &&
            stateProperties.renderingDetails.animateCompleted) {
          final Paint paint = Paint();
          paint.color = strokeColor;
          paint.strokeWidth = strokeWidth;
          paint.style = PaintingStyle.stroke;
          canvas.drawPath(path, paint);
        }
      }
    }

    final num? angle = hide ? oldEnd : pointEndAngle;
    final num? startAngle = hide ? oldStart : pointStartAngle;
    if (actualDegree > 360 &&
        angle != null &&
        startAngle != null &&
        angle >= startAngle + 180) {
      _applyShadow(hide, angle, actualDegree, canvas, chart, point,
          oldInnerRadius, oldRadius);
    }
  }

  /// Method to apply shadow at segment's end.
  void _applyShadow(
      bool hide,
      num? pointEndAngle,
      double actualDegree,
      Canvas canvas,
      SfCircularChart chart,
      ChartPoint<dynamic> point,
      num? oldInnerRadius,
      num? oldRadius) {
    if (pointEndAngle != null && actualDegree > 360) {
      final double currentInnerRadius =
          hide ? oldInnerRadius!.toDouble() : innerRadius.toDouble();
      final double outerRadius =
          hide ? oldRadius!.toDouble() : radius.toDouble();
      final double actualRadius = (currentInnerRadius - outerRadius).abs() / 2;
      final Offset? midPoint = degreeToPoint(
          pointEndAngle, (currentInnerRadius + outerRadius) / 2, center!);
      if (actualRadius > 0) {
        double strokeWidth = actualRadius * 0.2;
        strokeWidth = strokeWidth < 3 ? 3 : (strokeWidth > 5 ? 5 : strokeWidth);
        shadowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, _getSigmaFromRadius(3));

        overFilledPaint = Paint()..color = fillColor;
        if (point.shader != null) {
          overFilledPaint!.shader = point.shader;
        }

        if (series.cornerStyle == CornerStyle.endCurve ||
            series.cornerStyle == CornerStyle.bothCurve) {
          pointEndAngle =
              (pointEndAngle > 360 ? pointEndAngle : (pointEndAngle - 360)) +
                  11.5;
          final Path path = Path()
            ..addArc(
                Rect.fromCircle(
                    center: midPoint!,
                    radius: actualRadius - (actualRadius * 0.05)),
                degreesToRadians(pointEndAngle + 22.5).toDouble(),
                degreesToRadians(118.125).toDouble());
          final Path overFilledPath = Path()
            ..addArc(
                Rect.fromCircle(center: midPoint, radius: actualRadius),
                degreesToRadians(pointEndAngle - 20).toDouble(),
                degreesToRadians(225).toDouble());
          if (chart.onCreateShader != null && point.shader == null) {
            shadowPaths.add(path);
            overFilledPaths.add(overFilledPath);
          } else {
            canvas.drawPath(path, shadowPaint);
            canvas.drawPath(overFilledPath, overFilledPaint!);
          }
        } else if (series.cornerStyle == CornerStyle.bothFlat ||
            series.cornerStyle == CornerStyle.startCurve) {
          overFilledPaint!
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = fillColor;
          final Offset? startPoint = degreeToPoint(
              pointEndAngle, outerRadius - (outerRadius * 0.025), center!);

          final Offset? endPoint = degreeToPoint(pointEndAngle,
              currentInnerRadius + (currentInnerRadius * 0.025), center!);

          final Offset? overFilledStartPoint =
              degreeToPoint(pointEndAngle - 2, outerRadius, center!);
          final Offset? overFilledEndPoint =
              degreeToPoint(pointEndAngle - 2, currentInnerRadius, center!);
          if (chart.onCreateShader != null && point.shader == null) {
            final Path path = Path()
              ..moveTo(startPoint!.dx, startPoint.dy)
              ..lineTo(endPoint!.dx, endPoint.dy);
            path.close();
            final Path overFilledPath = Path()
              ..moveTo(overFilledStartPoint!.dx, overFilledStartPoint.dy)
              ..lineTo(overFilledEndPoint!.dx, overFilledEndPoint.dy);
            path.close();
            shadowPaths.add(path);
            overFilledPaths.add(overFilledPath);
          } else {
            canvas.drawLine(startPoint!, endPoint!, shadowPaint);
            canvas.drawLine(
                overFilledStartPoint!, overFilledEndPoint!, overFilledPaint!);
          }
        }
      }
    }
  }

  /// Method to convert the radius to sigma.
  double _getSigmaFromRadius(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
