import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../utils/constants.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// Renders the step line series.
///
/// A step line chart is a line chart in which points are connected
/// by horizontal and vertical line segments, looking like steps of a staircase.
///
/// To render a step line chart, create an instance of [StepLineSeries], and
/// add it to the series collection property of [SfCartesianChart].
/// Provides option to customize the [color], [opacity], [width] of
/// the step line segments.
@immutable
class StepLineSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of StepLineSeries class.
  const StepLineSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.yValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    double width = 2,
    super.markerSettings,
    super.trendlines,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.enableTooltip = true,
    super.dashArray,
    super.animationDuration,
    super.selectionBehavior,
    super.sortingOrder,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    super.animationDelay,
    super.opacity,
  }) : super(borderWidth: width);

  /// Create the stacked area series renderer.
  @override
  StepLineSeriesRenderer<T, D> createRenderer() {
    StepLineSeriesRenderer<T, D> stepLineSeriesRenderer;
    if (onCreateRenderer != null) {
      stepLineSeriesRenderer =
          onCreateRenderer!(this) as StepLineSeriesRenderer<T, D>;
      return stepLineSeriesRenderer;
    }
    return StepLineSeriesRenderer<T, D>();
  }
}

/// Creates series renderer for step line series.
class StepLineSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with LineSeriesMixin<T, D> {
  /// Calling the default constructor of StepLineSeriesRenderer class.
  StepLineSeriesRenderer();

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);

    final num x1 = xValues[index];
    final num y1 = yValues[index];
    num x2 = double.nan;
    num y2 = double.nan;

    final int nextIndex = nextIndexConsideringEmptyPointMode(
        index, emptyPointSettings.mode, yValues, dataCount);
    if (nextIndex != -1) {
      x2 = xValues[nextIndex];
      y2 = yValues[nextIndex];
    }

    segment as StepLineSegment<T, D>
      ..series = this
      .._x1 = x1
      .._y1 = y1
      .._x2 = x2
      .._y2 = y2
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  StepLineSegment<T, D> createSegment() => StepLineSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      dashArray != null && !dashArray!.every((double value) => value <= 0)
          ? ShapeMarkerType.stepLineSeriesWithDashArray
          : ShapeMarkerType.stepLineSeries;

  @override
  double legendIconBorderWidth() {
    return 1.5;
  }

  /// Changes the series color and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    updateSegmentColor(segment, color, borderWidth, isLineType: true);
    updateSegmentGradient(segment);
  }

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

/// Creates the segments for a step line series.
///
/// Generates the step line series points and has the [calculateSegmentPoints]
/// method overrides to customize the step line segment point calculation.
///
/// Gets the path and color from the `series`.
class StepLineSegment<T, D> extends ChartSegment {
  late StepLineSeriesRenderer<T, D> series;
  late num _x1;
  late num _x2;
  late num _y1;
  late num _y2;

  final List<Offset> _oldPoints = <Offset>[];

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
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

    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;

    if (!_x1.isNaN && !_y1.isNaN) {
      points.add(Offset(transformX(_x1, _y1), transformY(_x1, _y1)));
    }

    if (!_x2.isNaN && !_y1.isNaN) {
      points.add(Offset(transformX(_x2, _y1), transformY(_x2, _y1)));
    }

    if (!_x2.isNaN && !_y2.isNaN) {
      points.add(Offset(transformX(_x2, _y2), transformY(_x2, _y2)));
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

  int _nearestPointIndex(List<Offset> points, Offset position) {
    for (int i = 0; i < points.length; i++) {
      if ((points[i] - position).distance <= pointDistance) {
        return i;
      }
    }
    return -1;
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

    final List<Offset> linePoints = <Offset>[points.first, points.last];
    pointDistance = series.markerSettings.width / 2;
    final int nearestPointIndex =
        position == null ? 0 : _nearestPointIndex(linePoints, position);
    if (nearestPointIndex != -1) {
      pointIndex ??= (position == null || nearestPointIndex == 0
          ? currentSegmentIndex
          : currentSegmentIndex + 1);
      CartesianChartPoint<D> chartPoint = _chartPoint(pointIndex);
      List<Color?> markerColors = <Color?>[fillPaint.color];
      if (chartPoint.y != null && chartPoint.y!.isNaN) {
        pointIndex += 1;
        chartPoint = _chartPoint(pointIndex);
        markerColors = <Color?>[series.segments[pointIndex].fillPaint.color];
      }
      final ChartMarker marker = series.markerAt(pointIndex);
      final double markerHeight =
          series.markerSettings.isVisible ? marker.height / 2 : 0;
      final Offset preferredPos = linePoints[nearestPointIndex];
      return ChartTooltipInfo<T, D>(
        primaryPosition:
            series.localToGlobal(preferredPos.translate(0, -markerHeight)),
        secondaryPosition:
            series.localToGlobal(preferredPos.translate(0, markerHeight)),
        text: series.tooltipText(chartPoint),
        header: series.parent!.tooltipBehavior!.shared
            ? series.tooltipHeaderText(chartPoint)
            : series.name,
        data: series.dataSource![pointIndex],
        point: chartPoint,
        series: series.widget,
        renderer: series,
        seriesIndex: series.index,
        segmentIndex: currentSegmentIndex,
        pointIndex: pointIndex,
        markerColors: markerColors,
        markerType: marker.type,
      );
    }
    return null;
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    final CartesianChartPoint<D> chartPoint = _chartPoint(pointIndex);
    if (pointIndex == -1 ||
        points.isEmpty ||
        (chartPoint.y != null && chartPoint.y!.isNaN)) {
      return null;
    }

    return ChartTrackballInfo<T, D>(
      position: points[0],
      point: chartPoint,
      series: series,
      seriesIndex: series.index,
      segmentIndex: currentSegmentIndex,
      pointIndex: pointIndex,
      text: series.trackballText(chartPoint, series.name),
      header: series.tooltipHeaderText(chartPoint),
      color: fillPaint.color,
    );
  }

  @override
  Paint getFillPaint() => strokePaint;

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() => strokePaint;

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (points.isEmpty || points.length != 3) {
      return;
    }

    final Paint paint = getStrokePaint();
    if (paint.color == Colors.transparent || paint.strokeWidth < 0) {
      return;
    }

    final Offset start =
        Offset.lerp(_oldPoints[0], points[0], animationFactor)!;
    final Offset mid = Offset.lerp(_oldPoints[1], points[1], animationFactor)!;
    final Offset end = Offset.lerp(_oldPoints[2], points[2], animationFactor)!;
    drawDashes(canvas, series.dashArray, paint, start: start, end: mid);
    drawDashes(canvas, series.dashArray, paint, start: mid, end: end);
  }

  @override
  void dispose() {
    _oldPoints.clear();
    points.clear();
    super.dispose();
  }
}
