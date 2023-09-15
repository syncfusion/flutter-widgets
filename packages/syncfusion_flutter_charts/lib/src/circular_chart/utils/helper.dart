import 'dart:math' as math;
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../../charts.dart';
import '../../chart/chart_series/xy_data_series.dart';
import '../../common/utils/helper.dart';
import '../base/circular_state_properties.dart';
import '../renderer/common.dart';
import '../renderer/renderer_extension.dart';

/// To get equivalent value for the percentage.
num? percentToValue(String? value, num size) {
  return value != null
      ? value.contains('%')
          ? (size / 100) *
              num.tryParse(value.replaceAll(RegExp('%'), ''))!.abs()
          : num.tryParse(value)?.abs()
      : null;
}

/// Convert degree to radian.
num degreesToRadians(num deg) => deg * (pi / 180);

/// To get arc path for circular chart render.
Path getArcPath(num innerRadius, num radius, Offset center, num? startAngle,
    num? endAngle, num? degree, SfCircularChart chart, bool isAnimate) {
  final Path path = Path();
  startAngle = degreesToRadians(startAngle!);
  endAngle = degreesToRadians(endAngle!);
  degree = degreesToRadians(degree!);

  final math.Point<double> innerRadiusStartPoint = math.Point<double>(
      innerRadius * cos(startAngle) + center.dx,
      innerRadius * sin(startAngle) + center.dy);
  final math.Point<double> innerRadiusEndPoint = math.Point<double>(
      innerRadius * cos(endAngle) + center.dx,
      innerRadius * sin(endAngle) + center.dy);

  final math.Point<double> radiusStartPoint = math.Point<double>(
      radius * cos(startAngle) + center.dx,
      radius * sin(startAngle) + center.dy);

  if (isAnimate) {
    path.moveTo(innerRadiusStartPoint.x, innerRadiusStartPoint.y);
  }

  final bool isFullCircle =
      // Check if the angle between startAngle and endAngle is equal to a full circle (2 * pi radians)
      // by rounding both values to 5 decimal places and comparing them to avoid precision errors.
      (endAngle - startAngle).toStringAsFixed(5) == (2 * pi).toStringAsFixed(5);

  final num midpointAngle = (endAngle + startAngle) / 2;

  if (isFullCircle) {
    path.arcTo(
        Rect.fromCircle(center: center, radius: radius.toDouble()),
        startAngle.toDouble(),
        midpointAngle.toDouble() - startAngle.toDouble(),
        true);
    path.arcTo(
        Rect.fromCircle(center: center, radius: radius.toDouble()),
        midpointAngle.toDouble(),
        endAngle.toDouble() - midpointAngle.toDouble(),
        true);
  } else {
    path.lineTo(radiusStartPoint.x, radiusStartPoint.y);
    path.arcTo(Rect.fromCircle(center: center, radius: radius.toDouble()),
        startAngle.toDouble(), degree.toDouble(), true);
  }

  if (isFullCircle) {
    path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius.toDouble()),
        endAngle.toDouble(),
        midpointAngle.toDouble() - endAngle.toDouble(),
        true);
    path.arcTo(Rect.fromCircle(center: center, radius: innerRadius.toDouble()),
        midpointAngle.toDouble(), startAngle - midpointAngle.toDouble(), true);
  } else {
    path.lineTo(innerRadiusEndPoint.x, innerRadiusEndPoint.y);
    path.arcTo(Rect.fromCircle(center: center, radius: innerRadius.toDouble()),
        endAngle.toDouble(), startAngle.toDouble() - endAngle.toDouble(), true);
    path.lineTo(radiusStartPoint.x, radiusStartPoint.y);
  }
  return path;
}

/// To get rounded corners Arc path.
Path getRoundedCornerArcPath(
    num innerRadius,
    num outerRadius,
    Offset? center,
    num startAngle,
    num endAngle,
    num? degree,
    CornerStyle cornerStyle,
    ChartPoint<dynamic> point) {
  final Path path = Path();

  if (cornerStyle == CornerStyle.startCurve ||
      cornerStyle == CornerStyle.bothCurve) {
    final Offset startPoint = degreeToPoint(startAngle, innerRadius, center!);
    final Offset endPoint = degreeToPoint(startAngle, outerRadius, center);

    path.moveTo(startPoint.dx, startPoint.dy);
    path.arcToPoint(endPoint,
        radius: Radius.circular((innerRadius - outerRadius).abs() / 2));
  }

  path.addArc(
      Rect.fromCircle(center: center!, radius: outerRadius.toDouble()),
      degreesToRadians(startAngle).toDouble(),
      degreesToRadians(endAngle - startAngle).toDouble());

  if (cornerStyle == CornerStyle.endCurve ||
      cornerStyle == CornerStyle.bothCurve) {
    final Offset endPoint = degreeToPoint(endAngle, innerRadius, center);
    path.arcToPoint(endPoint,
        radius: Radius.circular((innerRadius - outerRadius).abs() / 2));
  }

  path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius.toDouble()),
      degreesToRadians(endAngle.toDouble()).toDouble(),
      (degreesToRadians(startAngle.toDouble()) -
              degreesToRadians(endAngle.toDouble()))
          .toDouble(),
      false);
  if (cornerStyle == CornerStyle.endCurve) {
    path.close();
  }

  return path;
}

/// To get point region.
Region? getCircularPointRegion(SfCircularChart chart, Offset? position,
    CircularSeriesRendererExtension seriesRenderer) {
  Region? pointRegion;
  const num chartStartAngle = -.5 * pi;
  num fromCenterX,
      fromCenterY,
      tapAngle,
      pointStartAngle,
      pointEndAngle,
      distanceFromCenter;
  // ignore: prefer_is_empty
  if (seriesRenderer.renderPoints?.length == 0 ||
      seriesRenderer.renderPoints == null) {
    seriesRenderer = seriesRenderer.stateProperties.prevSeriesRenderer!;
  }
  for (final Region region in seriesRenderer.pointRegions) {
    fromCenterX = position!.dx - region.center!.dx;
    fromCenterY = position.dy - region.center!.dy;
    tapAngle = (atan2(fromCenterY, fromCenterX) - chartStartAngle) % (2 * pi);
    pointStartAngle = region.start - degreesToRadians(-90);
    pointEndAngle = region.end - degreesToRadians(-90);
    if (chart.onDataLabelRender != null) {
      seriesRenderer.dataPoints[region.pointIndex].labelRenderEvent = false;
    }
    if (((region.endAngle + 90) > 360) && (region.startAngle + 90) > 360) {
      pointEndAngle = degreesToRadians((region.endAngle + 90) % 360);
      pointStartAngle = degreesToRadians((region.startAngle + 90) % 360);
    } else if ((region.endAngle + 90) > 360) {
      tapAngle = tapAngle > pointStartAngle ? tapAngle : 2 * pi + tapAngle;
    }
    if (tapAngle >= pointStartAngle && tapAngle <= pointEndAngle) {
      distanceFromCenter =
          sqrt(pow(fromCenterX.abs(), 2) + pow(fromCenterY.abs(), 2));
      if (distanceFromCenter <= region.outerRadius &&
          distanceFromCenter >= region.innerRadius!) {
        pointRegion = region;
      }
    }
  }

  return pointRegion;
}

/// Draw the path.
void drawPath(Canvas canvas, StyleOptions style, Path path,
    [Rect? rect, Shader? shader]) {
  final Paint paint = Paint();
  if (shader != null) {
    paint.shader = shader;
  }
  if (style.fill != null) {
    paint.color = style.fill == Colors.transparent
        ? style.fill!
        : style.fill!.withOpacity(style.opacity ?? 1);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }
  if (style.strokeColor != null &&
      style.strokeWidth != null &&
      style.strokeWidth! > 0) {
    paint.color = style.strokeColor!;
    paint.strokeWidth = style.strokeWidth!.toDouble();
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }
}

/// To convert degree to point and return position.
Offset degreeToPoint(num degree, num radius, Offset center) {
  degree = degreesToRadians(degree);
  return Offset(
      center.dx + cos(degree) * radius, center.dy + sin(degree) * radius);
}

/// To repaint circular chart.
void needsRepaintCircularChart(
    List<CircularSeriesRendererExtension> currentSeriesRenderers,
    List<CircularSeriesRendererExtension?> oldSeriesRenderers) {
  if (currentSeriesRenderers.length == oldSeriesRenderers.length &&
      currentSeriesRenderers[0].series == oldSeriesRenderers[0]!.series) {
    for (int seriesIndex = 0;
        seriesIndex < oldSeriesRenderers.length;
        seriesIndex++) {
      canRepaintSeries(currentSeriesRenderers, oldSeriesRenderers, seriesIndex);
    }
  } else {
    // ignore: avoid_function_literals_in_foreach_calls
    currentSeriesRenderers.forEach(
        (CircularSeriesRendererExtension seriesRenderer) =>
            seriesRenderer.needsRepaint = true);
  }
}

/// To repaint series.
void canRepaintSeries(
    List<CircularSeriesRendererExtension> currentSeriesRenderers,
    List<CircularSeriesRendererExtension?> oldSeriesRenderers,
    int seriesIndex) {
  final CircularSeriesRendererExtension seriesRenderer =
      currentSeriesRenderers[0];
  final CircularSeriesRendererExtension oldWidgetSeriesRenderer =
      oldSeriesRenderers[seriesIndex]!;
  final CircularSeries<dynamic, dynamic> series = seriesRenderer.series;
  final CircularSeries<dynamic, dynamic> oldWidgetSeries =
      oldWidgetSeriesRenderer.series;
  if (seriesRenderer.center?.dy != oldWidgetSeriesRenderer.center?.dy ||
      seriesRenderer.center?.dx != oldWidgetSeriesRenderer.center?.dx ||
      series.borderWidth != oldWidgetSeries.borderWidth ||
      series.name != oldWidgetSeries.name ||
      series.borderColor.value != oldWidgetSeries.borderColor.value ||
      seriesRenderer.segmentRenderingValues['currentInnerRadius'] !=
          oldWidgetSeriesRenderer
              .segmentRenderingValues['currentInnerRadius'] ||
      seriesRenderer.segmentRenderingValues['currentRadius'] !=
          oldWidgetSeriesRenderer.segmentRenderingValues['currentRadius'] ||
      seriesRenderer.segmentRenderingValues['start'] !=
          oldWidgetSeriesRenderer.segmentRenderingValues['start'] ||
      seriesRenderer.segmentRenderingValues['totalAngle'] !=
          oldWidgetSeriesRenderer.segmentRenderingValues['totalAngle'] ||
      seriesRenderer.dataPoints.length !=
          oldWidgetSeriesRenderer.dataPoints.length ||
      series.emptyPointSettings.borderWidth !=
          oldWidgetSeries.emptyPointSettings.borderWidth ||
      series.emptyPointSettings.borderColor.value !=
          oldWidgetSeries.emptyPointSettings.borderColor.value ||
      series.emptyPointSettings.color.value !=
          oldWidgetSeries.emptyPointSettings.color.value ||
      series.emptyPointSettings.mode !=
          oldWidgetSeries.emptyPointSettings.mode ||
      series.dataSource?.length != oldWidgetSeries.dataSource?.length ||
      series.dataLabelSettings.isVisible !=
          oldWidgetSeries.dataLabelSettings.isVisible ||
      series.dataLabelSettings.color?.value !=
          oldWidgetSeries.dataLabelSettings.color?.value ||
      series.dataLabelSettings.borderRadius !=
          oldWidgetSeries.dataLabelSettings.borderRadius ||
      series.dataLabelSettings.borderWidth !=
          oldWidgetSeries.dataLabelSettings.borderWidth ||
      series.dataLabelSettings.borderColor.value !=
          oldWidgetSeries.dataLabelSettings.borderColor.value ||
      series.dataLabelSettings.textStyle != null &&
          (series.dataLabelSettings.textStyle?.color?.value !=
                  oldWidgetSeries.dataLabelSettings.textStyle?.color?.value ||
              series.dataLabelSettings.textStyle?.fontStyle !=
                  oldWidgetSeries.dataLabelSettings.textStyle?.fontStyle ||
              series.dataLabelSettings.textStyle?.fontFamily !=
                  oldWidgetSeries.dataLabelSettings.textStyle?.fontFamily ||
              series.dataLabelSettings.textStyle?.fontSize !=
                  oldWidgetSeries.dataLabelSettings.textStyle?.fontSize ||
              series.dataLabelSettings.textStyle?.fontWeight !=
                  oldWidgetSeries.dataLabelSettings.textStyle?.fontWeight) ||
      series.dataLabelSettings.labelIntersectAction !=
          oldWidgetSeries.dataLabelSettings.labelIntersectAction ||
      series.dataLabelSettings.labelPosition !=
          oldWidgetSeries.dataLabelSettings.labelPosition ||
      series.dataLabelSettings.connectorLineSettings.color?.value !=
          oldWidgetSeries
              .dataLabelSettings.connectorLineSettings.color?.value ||
      series.dataLabelSettings.connectorLineSettings.width !=
          oldWidgetSeries.dataLabelSettings.connectorLineSettings.width ||
      series.dataLabelSettings.connectorLineSettings.length !=
          oldWidgetSeries.dataLabelSettings.connectorLineSettings.length ||
      series.dataLabelSettings.connectorLineSettings.type !=
          oldWidgetSeries.dataLabelSettings.connectorLineSettings.type ||
      series.xValueMapper != oldWidgetSeries.xValueMapper ||
      series.yValueMapper != oldWidgetSeries.yValueMapper ||
      series.enableTooltip != oldWidgetSeries.enableTooltip) {
    seriesRenderer.needsRepaint = true;
  } else {
    seriesRenderer.needsRepaint = false;
  }
}

/// To return deviation angle.
num findAngleDeviation(num innerRadius, num outerRadius, num totalAngle) {
  final num calcRadius = (innerRadius + outerRadius) / 2;
  final num circumference = 2 * pi * calcRadius;
  final num rimSize = (innerRadius - outerRadius).abs();
  final num deviation = ((rimSize / 2) / circumference) * 100;
  return (deviation * 360) / 100;
}

/// It returns the actual label value for tooltip and data label etc.
String getDecimalLabelValue(num? value, [int? showDigits]) {
  if (value != null && value.toString().split('.').length > 1) {
    final String str = value.toString();
    final List<String> list = str.split('.');
    value = double.parse(value.toStringAsFixed(showDigits ?? 3));
    value = (list[1] == '0' ||
            list[1] == '00' ||
            list[1] == '000' ||
            list[1] == '0000' ||
            list[1] == '00000' ||
            list[1] == '000000' ||
            list[1] == '0000000')
        ? value.round()
        : value;
  }

  return value.toString();
}

/// Method to rotate Sweep gradient.
Float64List resolveTransform(Rect bounds, TextDirection textDirection) {
  final GradientTransform transform = GradientRotation(degreeToRadian(-90));
  return transform.transform(bounds, textDirection: textDirection)!.storage;
}

/// Circular pixel to point.
ChartPoint<dynamic> circularPixelToPoint(
    Offset position, CircularStateProperties chartState) {
  int pointIndex;
  ChartPoint<dynamic>? dataPoint;
  final Region? pointRegion = getCircularPointRegion(chartState.chart, position,
      chartState.chartSeries.visibleSeriesRenderers[0]);
  if (pointRegion != null) {
    pointIndex = pointRegion.pointIndex;
    // ignore: prefer_is_empty
    if (chartState.chartSeries.visibleSeriesRenderers[0].renderPoints?.length ==
            0 ||
        chartState.chartSeries.visibleSeriesRenderers[0].renderPoints == null) {
      dataPoint = chartState.chartSeries.visibleSeriesRenderers[0]
          .stateProperties.prevSeriesRenderer!.dataPoints[pointIndex];
    } else {
      dataPoint = chartState
          .chartSeries.visibleSeriesRenderers[0].dataPoints[pointIndex];
    }
  }
  return dataPoint!;
}

/// Circular point to pixel.
Offset circularPointToPixel(
    ChartPoint<dynamic> point, CircularStateProperties chartState) {
  Offset location;

  if (point.midAngle == null) {
    final String x = point.x;
    final num y = point.y!;
    final CircularSeriesRendererExtension seriesRenderer =
        chartState.chartSeries.visibleSeriesRenderers[0];
    for (int i = 0; i < seriesRenderer.dataPoints.length; i++) {
      if (seriesRenderer.dataPoints[i].x == x &&
          seriesRenderer.dataPoints[i].y == y) {
        point = seriesRenderer.dataPoints[i];
      }
    }
  }

  location = degreeToPoint(point.midAngle!,
      (point.innerRadius! + point.outerRadius!) / 2, point.center!);
  location = Offset(location.dx, location.dy);
  return location;
}

/// To find the current point overlapped with previous points.
bool isOverlapWithPrevious(ChartPoint<dynamic> currentPoint,
    List<ChartPoint<dynamic>> points, int currentPointIndex) {
  for (int i = 0; i < currentPointIndex; i++) {
    if (i != points.indexOf(currentPoint) &&
        points[i].isVisible &&
        isOverlap(currentPoint.labelRect, points[i].labelRect)) {
      return true;
    }
  }
  return false;
}

/// To find the current point overlapped with next points.
bool isOverlapWithNext(ChartPoint<dynamic> point,
    List<ChartPoint<dynamic>> points, int pointIndex) {
  for (int i = pointIndex; i < points.length; i++) {
    if (i != points.indexOf(point) &&
        points[i].isVisible &&
        // ignore: unnecessary_null_comparison
        (points[i].labelRect != null && point.labelRect != null) &&
        isOverlap(point.labelRect, points[i].labelRect)) {
      return true;
    }
  }
  return false;
}

/// Calculate the connected line path for shifted data label.
ChartLocation getPerpendicularDistance(
    ChartLocation startPoint, ChartPoint<dynamic> point) {
  ChartLocation increasedLocation;
  const num add = 10;
  final num height = add + 10 * math.sin(point.midAngle! * math.pi / 360);
  if (point.midAngle! > 270 && point.midAngle! < 360) {
    increasedLocation = ChartLocation(
        startPoint.x +
            height * (math.cos((360 - point.midAngle!) * math.pi / 180)),
        startPoint.y -
            height * (math.sin((360 - point.midAngle!) * math.pi / 180)));
  } else if (point.midAngle! > 0 && point.midAngle! < 90) {
    increasedLocation = ChartLocation(
        startPoint.x + height * (math.cos((point.midAngle)! * math.pi / 180)),
        startPoint.y + height * (math.sin((point.midAngle)! * math.pi / 180)));
  } else if (point.midAngle! > 0 && point.midAngle! < 90) {
    increasedLocation = ChartLocation(
        startPoint.x -
            height * (math.cos((point.midAngle! - 90) * math.pi / 180)),
        startPoint.y +
            height * (math.sin((point.midAngle! - 90) * math.pi / 180)));
  } else {
    increasedLocation = ChartLocation(
        startPoint.x -
            height * (math.cos((point.midAngle! - 180) * math.pi / 180)),
        startPoint.y -
            height * (math.sin((point.midAngle! - 180) * math.pi / 180)));
  }
  return increasedLocation;
}
