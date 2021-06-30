part of charts;

/// To get equivalent value for the percentage
num? _percentToValue(String? value, num size) {
  return value != null
      ? value.contains('%')
          ? (size / 100) *
              (num.tryParse(value.replaceAll(RegExp('%'), '')))!.abs()
          : (num.tryParse(value))?.abs()
      : null;
}

/// Convert degree to radian
num _degreesToRadians(num deg) => deg * (pi / 180);

/// To get arc  path for circular chart render
Path _getArcPath(num innerRadius, num radius, Offset center, num? startAngle,
    num? endAngle, num? degree, SfCircularChart chart, bool isAnimate) {
  final Path path = Path();
  startAngle = _degreesToRadians(startAngle!);
  endAngle = _degreesToRadians(endAngle!);
  degree = _degreesToRadians(degree!);

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
      // ignore: unnecessary_null_comparison
      startAngle != null && endAngle != null && endAngle - startAngle == 2 * pi;

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

/// To get current point
ChartPoint<dynamic> _getCircularPoint(
    CircularSeriesRenderer seriesRenderer, int pointIndex) {
  final CircularSeries<dynamic, dynamic> series = seriesRenderer._series;
  late ChartPoint<dynamic> currentPoint;
  final ChartIndexedValueMapper<dynamic>? xMap = series.xValueMapper;
  final ChartIndexedValueMapper<dynamic>? yMap = series.yValueMapper;
  final ChartIndexedValueMapper<dynamic>? sortFieldMap =
      series.sortFieldValueMapper;
  final ChartIndexedValueMapper<String>? radiusMap = series.pointRadiusMapper;
  final ChartIndexedValueMapper<Color>? colorMap = series.pointColorMapper;
  final ChartShaderMapper<dynamic>? shadeMap = series.pointShaderMapper;

  /// Can be either a string or num value
  dynamic xVal;
  num? yVal;
  String? radiusVal;
  Color? colorVal;
  String? sortVal;
  if (xMap != null) {
    xVal = xMap(pointIndex);
  }

  if (xVal != null) {
    if (yMap != null) {
      yVal = yMap(pointIndex);
    }

    if (radiusMap != null) {
      radiusVal = radiusMap(pointIndex);
    }

    if (colorMap != null) {
      colorVal = colorMap(pointIndex);
    }
    if (sortFieldMap != null) {
      sortVal = sortFieldMap(pointIndex);
    }

    currentPoint =
        ChartPoint<dynamic>(xVal, yVal, radiusVal, colorVal, sortVal);
  }
  currentPoint.index = pointIndex;
  if (shadeMap != null) {
    currentPoint._pointShaderMapper = shadeMap;
  } else {
    currentPoint._pointShaderMapper = null;
  }
  currentPoint.center = seriesRenderer._center;

  return currentPoint;
}

/// To get rounded corners Arc path
Path _getRoundedCornerArcPath(
    num innerRadius,
    num outerRadius,
    Offset? center,
    num startAngle,
    num endAngle,
    num? degree,
    CornerStyle cornerStyle,
    ChartPoint<dynamic> point) {
  final Path path = Path();

  Offset _midPoint;
  num midStartAngle, midEndAngle;
  if (cornerStyle == CornerStyle.startCurve ||
      cornerStyle == CornerStyle.bothCurve) {
    _midPoint =
        _degreeToPoint(startAngle, (innerRadius + outerRadius) / 2, center!);

    midStartAngle = _degreesToRadians(180);

    midEndAngle = midStartAngle + _degreesToRadians(180);

    path.addArc(
        Rect.fromCircle(
            center: _midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle.toDouble(),
        midEndAngle.toDouble());
  }

  path.addArc(
      Rect.fromCircle(center: center!, radius: outerRadius.toDouble()),
      _degreesToRadians(startAngle).toDouble(),
      _degreesToRadians(endAngle - startAngle).toDouble());

  if (cornerStyle == CornerStyle.endCurve ||
      cornerStyle == CornerStyle.bothCurve) {
    _midPoint =
        _degreeToPoint(endAngle, (innerRadius + outerRadius) / 2, center);

    midStartAngle = _degreesToRadians(endAngle / 2);

    midEndAngle = midStartAngle + _degreesToRadians(180);

    path.arcTo(
        Rect.fromCircle(
            center: _midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle.toDouble(),
        midEndAngle.toDouble(),
        false);
  }

  path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius.toDouble()),
      _degreesToRadians(endAngle.toDouble()).toDouble(),
      (_degreesToRadians(startAngle.toDouble()) -
              _degreesToRadians(endAngle.toDouble()))
          .toDouble(),
      false);
  return path;
}

/// To get point region
_Region? _getCircularPointRegion(SfCircularChart chart, Offset? position,
    CircularSeriesRenderer seriesRenderer) {
  _Region? pointRegion;
  const num chartStartAngle = -.5 * pi;
  num fromCenterX,
      fromCenterY,
      tapAngle,
      pointStartAngle,
      pointEndAngle,
      distanceFromCenter;
  for (final _Region region in seriesRenderer._pointRegions) {
    fromCenterX = position!.dx - region.center!.dx;
    fromCenterY = position.dy - region.center!.dy;
    tapAngle = (atan2(fromCenterY, fromCenterX) - chartStartAngle) % (2 * pi);
    pointStartAngle = region.start - _degreesToRadians(-90);
    pointEndAngle = region.end - _degreesToRadians(-90);
    if (chart.onDataLabelRender != null) {
      seriesRenderer._dataPoints[region.pointIndex].labelRenderEvent = false;
    }
    if (((region.endAngle + 90) > 360) && (region.startAngle + 90) > 360) {
      pointEndAngle = _degreesToRadians((region.endAngle + 90) % 360);
      pointStartAngle = _degreesToRadians((region.startAngle + 90) % 360);
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

/// Draw the path
void _drawPath(Canvas canvas, _StyleOptions style, Path path,
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

/// To convert degree to point and return position
Offset _degreeToPoint(num degree, num radius, Offset center) {
  degree = _degreesToRadians(degree);
  return Offset(
      center.dx + cos(degree) * radius, center.dy + sin(degree) * radius);
}

/// To repaint circular chart
void _needsRepaintCircularChart(
    List<CircularSeriesRenderer> currentSeriesRenderers,
    List<CircularSeriesRenderer?> oldSeriesRenderers) {
  if (currentSeriesRenderers.length == oldSeriesRenderers.length &&
      currentSeriesRenderers[0]._series == oldSeriesRenderers[0]!._series) {
    for (int seriesIndex = 0;
        seriesIndex < oldSeriesRenderers.length;
        seriesIndex++) {
      _canRepaintSeries(
          currentSeriesRenderers, oldSeriesRenderers, seriesIndex);
    }
  } else {
    // ignore: avoid_function_literals_in_foreach_calls
    currentSeriesRenderers.forEach((CircularSeriesRenderer seriesRenderer) =>
        seriesRenderer._needsRepaint = true);
  }
}

/// To repaint series
void _canRepaintSeries(List<CircularSeriesRenderer> currentSeriesRenderers,
    List<CircularSeriesRenderer?> oldSeriesRenderers, int seriesIndex) {
  final CircularSeriesRenderer seriesRenderer = currentSeriesRenderers[0];
  final CircularSeriesRenderer oldWidgetSeriesRenderer =
      oldSeriesRenderers[seriesIndex]!;
  final CircularSeries<dynamic, dynamic> series = seriesRenderer._series;
  final CircularSeries<dynamic, dynamic> oldWidgetSeries =
      oldWidgetSeriesRenderer._series;
  if (seriesRenderer._center?.dy != oldWidgetSeriesRenderer._center?.dy ||
      seriesRenderer._center?.dx != oldWidgetSeriesRenderer._center?.dx ||
      series.borderWidth != oldWidgetSeries.borderWidth ||
      series.name != oldWidgetSeries.name ||
      series.borderColor.value != oldWidgetSeries.borderColor.value ||
      seriesRenderer._segmentRenderingValues['currentInnerRadius'] !=
          oldWidgetSeriesRenderer
              ._segmentRenderingValues['currentInnerRadius'] ||
      seriesRenderer._segmentRenderingValues['currentRadius'] !=
          oldWidgetSeriesRenderer._segmentRenderingValues['currentRadius'] ||
      seriesRenderer._segmentRenderingValues['start'] !=
          oldWidgetSeriesRenderer._segmentRenderingValues['start'] ||
      seriesRenderer._segmentRenderingValues['totalAngle'] !=
          oldWidgetSeriesRenderer._segmentRenderingValues['totalAngle'] ||
      seriesRenderer._dataPoints.length !=
          oldWidgetSeriesRenderer._dataPoints.length ||
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
      series.dataLabelSettings.textStyle.color?.value !=
          oldWidgetSeries.dataLabelSettings.textStyle.color?.value ||
      series.dataLabelSettings.textStyle.fontWeight !=
          oldWidgetSeries.dataLabelSettings.textStyle.fontWeight ||
      series.dataLabelSettings.textStyle.fontSize !=
          oldWidgetSeries.dataLabelSettings.textStyle.fontSize ||
      series.dataLabelSettings.textStyle.fontFamily !=
          oldWidgetSeries.dataLabelSettings.textStyle.fontFamily ||
      series.dataLabelSettings.textStyle.fontStyle !=
          oldWidgetSeries.dataLabelSettings.textStyle.fontStyle ||
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
    seriesRenderer._needsRepaint = true;
  } else {
    seriesRenderer._needsRepaint = false;
  }
}

/// To return deviation angle
num _findAngleDeviation(num innerRadius, num outerRadius, num totalAngle) {
  final num calcRadius = (innerRadius + outerRadius) / 2;

  final num circumference = 2 * pi * calcRadius;

  final num rimSize = (innerRadius - outerRadius).abs();

  final num deviation = ((rimSize / 2) / circumference) * 100;

  return (deviation * 360) / 100;
}

/// It returns the actual label value for tooltip and data label etc
String _getDecimalLabelValue(num? value, [int? showDigits]) {
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

/// Method to rotate Sweep gradient
Float64List _resolveTransform(Rect bounds, TextDirection textDirection) {
  final GradientTransform transform = GradientRotation(degreeToRadian(-90));
  return transform.transform(bounds, textDirection: textDirection)!.storage;
}
