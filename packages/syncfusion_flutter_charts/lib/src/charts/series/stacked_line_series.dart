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

/// Renders the stacked line series.
///
/// A stacked line chart is a line chart in which lines do not overlap because
/// they are cumulative at each point.
///
/// A stacked line chart displays series as a set of points connected by a line.
///
/// To render a stacked line chart, create an instance of [StackedLineSeries],
/// and add it to the series collection property of [SfCartesianChart].
/// Provides options to customize [color], [opacity], [width] of the
/// stacked line segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=NCUDBD_ClHo}
@immutable
class StackedLineSeries<T, D> extends StackedSeriesBase<T, D> {
  /// Creating an argument constructor of StackedLineSeries class.
  const StackedLineSeries({
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
    super.initialIsVisible,
    super.name,
    super.enableTooltip = true,
    super.dashArray,
    super.animationDuration,
    this.groupName = '',
    super.trendlines,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.sortingOrder,
    super.legendItemText,
    super.opacity,
    super.animationDelay,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    super.initialSelectedDataIndexes,
  }) : super(borderWidth: width);

  /// Specifies the group name.
  final String groupName;

  /// To create a stacked line series renderer.
  @override
  StackedLineSeriesRenderer<T, D> createRenderer() {
    StackedLineSeriesRenderer<T, D> stackedLineSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedLineSeriesRenderer =
          onCreateRenderer!(this) as StackedLineSeriesRenderer<T, D>;
      return stackedLineSeriesRenderer;
    }
    return StackedLineSeriesRenderer<T, D>();
  }

  @override
  StackedLineSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final StackedLineSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as StackedLineSeriesRenderer<T, D>;
    renderer.groupName = groupName;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, StackedLineSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.groupName = groupName;
  }
}

/// Creates series renderer for stacked line series.
class StackedLineSeriesRenderer<T, D> extends StackedSeriesRenderer<T, D>
    with LineSeriesMixin<T, D> {
  @override
  double legendIconBorderWidth() {
    return 3;
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);

    final num x1 = xValues[index];
    final num y1 = topValues[index];
    num x2 = double.nan;
    num y2 = double.nan;

    final int nextIndex = nextIndexConsideringEmptyPointMode(
        index, emptyPointSettings.mode, topValues, dataCount);
    if (nextIndex != -1) {
      x2 = xValues[nextIndex];
      y2 = topValues[nextIndex];
    }

    segment as StackedLineSegment<T, D>
      ..series = this
      .._x1 = x1
      .._y1 = y1
      .._x2 = x2
      .._y2 = y2
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  StackedLineSegment<T, D> createSegment() => StackedLineSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      dashArray != null && !dashArray!.every((double value) => value <= 0)
          ? ShapeMarkerType.stackedLineSeriesWithDashArray
          : ShapeMarkerType.stackedLineSeries;

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

/// Segment class for stacked line series.
class StackedLineSegment<T, D> extends ChartSegment {
  late StackedLineSeriesRenderer<T, D> series;
  late num _x1, _y1, _x2, _y2;

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
      cumulative: series.topValues[pointIndex],
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (points.isEmpty) {
      return null;
    }

    pointDistance = series.markerSettings.width / 2;
    final int nearestPointIndex =
        position == null ? 0 : _nearestPointIndex(points, position);
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
      final Offset preferredPos = points[nearestPointIndex];
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

  /// Gets the color of the series.
  @override
  Paint getFillPaint() => strokePaint;

  /// Gets the border color of the series.
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
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      drawDashes(canvas, series.dashArray, paint,
          start: points[0], end: points[1]);
    }
  }

  @override
  void dispose() {
    points.clear();
    super.dispose();
  }
}
