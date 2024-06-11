import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// Renders the line series.
///
/// This class holds the properties of line series. To render a line chart,
/// create an instance of [LineSeries], and add it to the series collection
/// property of [SfCartesianChart]. A line chart requires two fields (X and Y)
/// to plot a point.
///
/// Provide the options for color, opacity, border color, and border width
/// to customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=zhcxdh4-Jt8}
class LineSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of [LineSeries] class.
  const LineSeries({
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
    super.color,
    double width = 2,
    super.markerSettings,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.trendlines,
    super.initialIsVisible,
    super.name,
    super.enableTooltip = true,
    super.dashArray,
    super.animationDuration,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.sortingOrder,
    super.legendItemText,
    super.opacity,
    super.animationDelay,
    super.initialSelectedDataIndexes,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
  }) : super(borderWidth: width);

  /// Create the line series renderer.
  @override
  LineSeriesRenderer<T, D> createRenderer() {
    LineSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as LineSeriesRenderer<T, D>;
      // ignore: unnecessary_null_comparison
      return seriesRenderer;
    }
    return LineSeriesRenderer<T, D>();
  }
}

/// Creates series renderer for line series.
class LineSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with LineSeriesMixin<T, D> {
  /// Calling the default constructor of LineSeriesRenderer class.
  LineSeriesRenderer();

  @override
  double legendIconBorderWidth() {
    return 3;
  }

  bool _hasNewSegmentAdded = false;

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

    segment as LineSegment<T, D>
      ..series = this
      .._x1 = x1
      .._y1 = y1
      .._x2 = x2
      .._y2 = y2
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  LineSegment<T, D> createSegment() {
    _hasNewSegmentAdded = true;
    return LineSegment<T, D>();
  }

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      dashArray != null && !dashArray!.every((double value) => value <= 0)
          ? ShapeMarkerType.lineSeriesWithDashArray
          : ShapeMarkerType.lineSeries;

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
    if (animationController!.isCompleted) {
      _hasNewSegmentAdded = false;
    }
  }
}

// Creates the segments for line series.
///
/// Line segment is a part of a line series that is bounded
/// by two distinct end point.
/// Generates the line series points and has the [calculateSegmentPoints]
/// override method used to customize the line series segment point calculation.
///
/// Gets the path, stroke color and fill color from the `series`.
class LineSegment<T, D> extends ChartSegment {
  late LineSeriesRenderer<T, D> series;
  late num _x1;
  late num _y1;
  late num _x2;
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
  @nonVirtual
  void transformValues() {
    points.clear();

    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;
    if (!_x1.isNaN && !_y1.isNaN) {
      points.add(Offset(transformX(_x1, _y1), transformY(_x1, _y1)));
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
    if (points.isNotEmpty) {
      final ChartMarker marker = series.markerAt(currentSegmentIndex);
      return tooltipTouchBounds(points[0], marker.width, marker.height)
          .contains(position);
    }
    return false;
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (points.isEmpty) {
      return null;
    }

    pointIndex ??= currentSegmentIndex;
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
    final Offset preferredPos = points[0];
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

  CartesianChartPoint<D> _chartPoint(int pointIndex) {
    return CartesianChartPoint<D>(
      x: series.xRawValues[pointIndex],
      xValue: series.xValues[pointIndex],
      y: series.yValues[pointIndex],
    );
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
    if (points.isEmpty || points.length != 2) {
      return;
    }

    final Paint paint = getStrokePaint();
    if (paint.color == Colors.transparent || paint.strokeWidth < 0) {
      return;
    }

    final Offset start;
    final Offset end;
    if (animationFactor < 1) {
      if (series.animationType == AnimationType.realtime &&
          series._hasNewSegmentAdded &&
          !isEmpty &&
          series.dataCount == currentSegmentIndex + 2) {
        final double prevX = _oldPoints[0].dx;
        final double prevY = _oldPoints[0].dy;
        final double x1 = points[0].dx;
        final double y1 = points[0].dy;
        final double x2 = points[1].dx;
        final double y2 = points[1].dy;

        final double newX1 = prevX + (x1 - prevX) * animationFactor;
        final double newY1 = prevY + (y1 - prevY) * animationFactor;
        final double newX2 = newX1 + (x2 - newX1) * animationFactor;
        final double newY2 = newY1 + (y2 - newY1) * animationFactor;

        start = Offset(newX1, newY1);
        end = Offset(newX2, newY2);
      } else {
        start = Offset.lerp(_oldPoints[0], points[0], animationFactor)!;
        end = Offset.lerp(_oldPoints[1], points[1], animationFactor)!;
      }
    } else {
      start = points[0];
      end = points[1];
    }

    if (start.isNaN || end.isNaN) {
      return;
    }
    drawDashes(canvas, series.dashArray, paint, start: start, end: end);
  }

  @override
  void dispose() {
    points.clear();
    super.dispose();
  }
}
