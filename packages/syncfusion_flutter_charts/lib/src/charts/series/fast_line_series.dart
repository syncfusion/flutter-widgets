import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../axis/axis.dart';
import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// Renders the [FastLineSeries].
///
/// [FastLineSeries] is a line chart, but it loads faster than [LineSeries].
///
/// You can use this when there are large number of points to be loaded
/// in a chart. To render a fast line chart,
/// create an instance of [FastLineSeries], and add it to the series collection
/// property of [SfCartesianChart].
///
/// The following properties are used to customize the appearance
/// of fast line segment:
///
/// * color - Changes the color of the line.
/// * opacity - Controls the transparency of the chart series.
/// * width - Changes the stroke width of the line.
class FastLineSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of FastLineSeries class.
  const FastLineSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.yValueMapper,
    super.sortFieldValueMapper,
    super.dataLabelMapper,
    super.xAxisName,
    super.yAxisName,
    super.color,
    double width = 2,
    super.dashArray,
    super.gradient,
    super.markerSettings,
    super.emptyPointSettings,
    super.trendlines,
    super.dataLabelSettings,
    super.sortingOrder,
    super.initialIsVisible,
    super.name,
    super.enableTooltip = true,
    super.animationDuration,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.opacity,
    super.animationDelay,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
  }) : super(borderWidth: width);

  /// Create the fastline series renderer.
  @override
  FastLineSeriesRenderer<T, D> createRenderer() {
    FastLineSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as FastLineSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return FastLineSeriesRenderer<T, D>();
  }
}

/// Creates series renderer for fastline series.
class FastLineSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with ContinuousSeriesMixin<T, D> {
  /// Calling the default constructor of FastLineSeriesRenderer class.
  FastLineSeriesRenderer();

  @override
  double legendIconBorderWidth() {
    return 3;
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as FastLineSegment<T, D>
      ..series = this
      .._xValues = xValues
      .._yValues = yValues;
  }

  /// Creates a segment for a data point in the series.
  @override
  FastLineSegment<T, D> createSegment() => FastLineSegment<T, D>();

  /// Changes the series color and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final Color fastlineColor = color ?? paletteColor;
    updateSegmentColor(segment, fastlineColor, borderWidth);
    updateSegmentGradient(segment,
        gradientBounds: paintBounds, borderGradient: gradient);
  }

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      dashArray != null && !dashArray!.every((double value) => value <= 0)
          ? ShapeMarkerType.fastLineSeriesWithDashArray
          : ShapeMarkerType.fastLineSeries;

  @override
  void onPaint(PaintingContext context, Offset offset) {
    context.canvas.save();
    final Rect clip = clipRect(paintBounds, animationFactor,
        isInversed: xAxis!.isInversed, isTransposed: isTransposed);
    context.canvas.clipRect(clip);
    paintSegments(context, offset);
    context.canvas.restore();
    paintMarkers(context, offset);
    paintDataLabels(context, offset);
    paintTrendline(context, offset);
  }
}

// Creates the segments for fast line series.
///
/// This generates the fast line series points and
/// has the [calculateSegmentPoints] method overridden to customize
/// the fast line segment point calculation.
///
/// Gets the path and color from the `series`.
class FastLineSegment<T, D> extends ChartSegment {
  late FastLineSeriesRenderer<T, D> series;
  late List<num> _xValues;
  late List<num> _yValues;
  final List<int> _drawIndexes = <int>[];
  final List<Offset> _oldPoints = <Offset>[];

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _drawIndexes.clear();
      _oldPoints.clear();
      return;
    }

    if (series.animationDuration > 0) {
      if (points.isEmpty) {
        _oldPoints.clear();
        return;
      }

      final int newPointsLength = points.length;
      final int oldPointsLength = _oldPoints.length;
      if (oldPointsLength == newPointsLength) {
        for (int i = 0; i < newPointsLength; i++) {
          _oldPoints[i] =
              Offset.lerp(_oldPoints[i], points[i], segmentAnimationFactor)!;
        }
      } else {
        final int minLength = min(oldPointsLength, newPointsLength);
        for (int i = 0; i < minLength; i++) {
          _oldPoints[i] =
              Offset.lerp(_oldPoints[i], points[i], segmentAnimationFactor)!;
        }

        if (newPointsLength > oldPointsLength) {
          _oldPoints.addAll(points.sublist(oldPointsLength));
        } else {
          _oldPoints.removeRange(minLength, oldPointsLength);
        }
      }
    } else {
      _oldPoints.clear();
    }
  }

  @override
  void transformValues() {
    points.clear();
    _drawIndexes.clear();
    if (series.canFindLinearVisibleIndexes) {
      _linearPoints();
    } else {
      _nonLinearPoints();
    }
  }

  void _linearPoints() {
    final RenderChartAxis xAxis = series.xAxis!;
    final RenderChartAxis yAxis = series.yAxis!;
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;
    final bool canDrop = series.emptyPointSettings.mode == EmptyPointMode.drop;

    final List<int> visibleIndexes = series.visibleIndexes;
    final int length = visibleIndexes.length;
    final int start = visibleIndexes[0];
    final int end = visibleIndexes[length - 1];
    final num xTol = (xAxis.visibleRange!.delta / series.size.width).abs();
    final num yTol = (yAxis.visibleRange!.delta / series.size.height).abs();

    final num startX = _xValues[start];
    final num startY = _yValues[start];
    final double startXValue = transformX(startX, startY);
    final double startYValue = transformY(startX, startY);

    points.add(Offset(startXValue, startYValue));
    _drawIndexes.add(0);

    num previousX = startX;
    num previousY = startY;
    for (int i = start; i <= end; i++) {
      final num currentX = _xValues[i];
      if (currentX.isNaN) {
        if (canDrop) {
          continue;
        }
        previousX = xAxis.visibleRange!.minimum;
      }
      final num currentY = _yValues[i];
      if (currentY.isNaN) {
        if (canDrop) {
          continue;
        }
        previousY = yAxis.visibleRange!.minimum;
      }
      if ((previousX - currentX).abs() >= xTol ||
          (previousY - currentY).abs() >= yTol) {
        final double currentXValue = transformX(currentX, currentY);
        final double currentYValue = transformY(currentX, currentY);
        points.add(Offset(currentXValue, currentYValue));
        _drawIndexes.add(i);
        previousX = currentX;
        previousY = currentY;
      }
    }

    if (points.length > _oldPoints.length) {
      _oldPoints.addAll(points.sublist(_oldPoints.length));
    }
  }

  void _nonLinearPoints() {
    if (_xValues.isEmpty || _yValues.isEmpty) {
      return;
    }

    final RenderChartAxis xAxis = series.xAxis!;
    final RenderChartAxis yAxis = series.yAxis!;
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;
    final bool canDrop = series.emptyPointSettings.mode == EmptyPointMode.drop;

    final num xTol = (xAxis.visibleRange!.delta / series.size.width).abs();
    final num yTol = (yAxis.visibleRange!.delta / series.size.height).abs();

    final List<int> visibleIndexes = series.visibleIndexes;
    final num startX = _xValues[0];
    final num startY = _yValues[0];
    num previousX = startX.isNaN ? 0 : startX;
    num previousY = startY.isNaN ? 0 : startY;

    points.add(Offset(transformX(startX, startY), transformY(startX, startY)));
    _drawIndexes.add(0);

    for (final int i in visibleIndexes) {
      num currentX = _xValues[i];
      if (currentX.isNaN) {
        if (canDrop) {
          continue;
        }
        currentX = xAxis.visibleRange!.minimum;
      }
      num currentY = _yValues[i];
      if (currentY.isNaN) {
        if (canDrop) {
          continue;
        }
        currentY = yAxis.visibleRange!.minimum;
      }

      if ((previousX - currentX).abs() >= xTol ||
          (previousY - currentY).abs() >= yTol) {
        final double currentXValue = transformX(currentX, currentY);
        final double currentYValue = transformY(currentX, currentY);
        points.add(Offset(currentXValue, currentYValue));
        _drawIndexes.add(i);
        previousX = currentX;
        previousY = currentY;
      }
    }

    if (points.length > _oldPoints.length) {
      _oldPoints.addAll(points.sublist(_oldPoints.length));
    }
  }

  @override
  bool contains(Offset position) {
    final MarkerSettings marker = series.markerSettings;
    final int length = points.length;
    for (int i = 0; i < length; i++) {
      if (tooltipTouchBounds(points[i], marker.width, marker.height)
          .contains(position)) {
        return true;
      }
    }
    return false;
  }

  CartesianChartPoint<D> _chartPoint(int pointIndex) {
    return CartesianChartPoint<D>(
      x: series.xRawValues[pointIndex],
      xValue: series.xValues[pointIndex],
      y: series.yValues[pointIndex],
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (points.isEmpty) {
      return null;
    }

    pointDistance = series.markerSettings.width / 2;
    pointIndex ??= _findNearestChartPointIndex(points, position!);
    if (pointIndex != -1) {
      final Offset position = points[pointIndex];
      if (position.isNaN) {
        return null;
      }

      final int actualPointIndex = _drawIndexes[pointIndex];
      final CartesianChartPoint<D> chartPoint = _chartPoint(actualPointIndex);
      final num x = chartPoint.xValue!;
      final num y = chartPoint.y!;
      final double dx = series.pointToPixelX(x, y);
      final double dy = series.pointToPixelY(x, y);
      final ChartMarker marker = series.markerAt(pointIndex);
      final double markerHeight =
          series.markerSettings.isVisible ? marker.height / 2 : 0;
      final Offset preferredPos = Offset(dx, dy);
      return ChartTooltipInfo<T, D>(
        primaryPosition:
            series.localToGlobal(preferredPos.translate(0, -markerHeight)),
        secondaryPosition:
            series.localToGlobal(preferredPos.translate(0, markerHeight)),
        text: series.tooltipText(chartPoint),
        header: series.parent!.tooltipBehavior!.shared
            ? series.tooltipHeaderText(chartPoint)
            : series.name,
        data: series.dataSource![currentSegmentIndex],
        point: chartPoint,
        series: series.widget,
        renderer: series,
        seriesIndex: series.index,
        segmentIndex: currentSegmentIndex,
        pointIndex: actualPointIndex,
        markerColors: <Color?>[fillPaint.color],
        markerType: marker.type,
      );
    }
    return null;
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    final int nearestPointIndex = _findNearestPoint(points, position);
    if (nearestPointIndex != -1) {
      final Offset preferredPos = points[nearestPointIndex];
      if (preferredPos.isNaN) {
        return null;
      }

      final int actualPointIndex = _drawIndexes[nearestPointIndex];
      final CartesianChartPoint<D> chartPoint = _chartPoint(actualPointIndex);
      return ChartTrackballInfo<T, D>(
        position: preferredPos,
        point: chartPoint,
        series: series,
        seriesIndex: series.index,
        segmentIndex: currentSegmentIndex,
        pointIndex: actualPointIndex,
        text: series.trackballText(chartPoint, series.name),
        header: series.tooltipHeaderText(chartPoint),
        color: fillPaint.color,
      );
    }
    return null;
  }

  int _findNearestPoint(List<Offset> points, Offset position) {
    double delta = 0;
    num? nearPointX;
    num? nearPointY;
    int? pointIndex;
    final int length = points.length;
    for (int i = 0; i < length; i++) {
      nearPointX ??= series.isTransposed
          ? series.xAxis!.visibleRange!.minimum
          : points[0].dx;
      nearPointY ??= series.isTransposed
          ? points[0].dy
          : series.yAxis!.visibleRange!.minimum;

      final num touchXValue = position.dx;
      final num touchYValue = position.dy;
      final double curX = points[i].dx;
      final double curY = points[i].dy;

      if (series.isTransposed) {
        if (delta == touchYValue - curY) {
          pointIndex = i;
        } else if ((touchYValue - curY).abs() <=
            (touchYValue - nearPointY).abs()) {
          nearPointX = curX;
          nearPointY = curY;
          delta = touchYValue - curY;
          pointIndex = i;
        }
      } else {
        if (delta == touchXValue - curX) {
          pointIndex = i;
        } else if ((touchXValue - curX).abs() <=
            (touchXValue - nearPointX).abs()) {
          nearPointX = curX;
          nearPointY = curY;
          delta = touchXValue - curX;
          pointIndex = i;
        }
      }
    }
    return pointIndex ?? -1;
  }

  int _findNearestChartPointIndex(List<Offset> points, Offset position) {
    for (int i = 0; i < points.length; i++) {
      if ((points[i] - position).distance <= pointDistance) {
        return i;
      }
    }
    return -1;
  }

  /// Gets the color of the series.
  @override
  Paint getFillPaint() => getStrokePaint();

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() => strokePaint;

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (points.isEmpty) {
      return;
    }

    final Paint paint = getStrokePaint();
    final List<double>? dashedArray = series.dashArray;
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      if (dashedArray != null || series.emptyPointIndexes.isNotEmpty) {
        drawDashesFromPoints(canvas, points, dashedArray, paint);
      } else {
        canvas.drawPoints(PointMode.polygon, points, paint);
      }
    }
  }

  @override
  void dispose() {
    points.clear();
    _drawIndexes.clear();
    super.dispose();
  }
}
