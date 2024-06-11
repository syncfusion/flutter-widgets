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

/// Renders the hilo series.
///
/// [HiloSeries] illustrates the price movements in stock using the
/// high and low values.
///
/// To render a hilo chart, create an instance of [HiloSeries], and add it to
/// the series collection property of [SfCartesianChart].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=uSsKhlRzC2Q}
class HiloSeries<T, D> extends RangeSeriesBase<T, D> {
  /// Creating an argument constructor of HiloSeries class.
  const HiloSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.lowValueMapper,
    required super.highValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    super.markerSettings,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.enableTooltip = true,
    super.animationDuration,
    super.borderWidth = 2,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.dashArray,
    super.opacity,
    super.animationDelay,
    this.spacing = 0,
    super.initialSelectedDataIndexes,
    this.showIndicationForSameValues = false,
    super.trendlines,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
  });

  /// Spacing between the columns. The value ranges from 0 to 1.
  /// 1 represents 100% and 0 represents 0% of the available space.
  ///
  /// Spacing also affects the width of the column. For example, setting 20%
  /// spacing and 100% width renders the column with 80% of total width.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HiloSeries<SalesData, num>>[
  ///       HiloSeries<SalesData, num>(
  ///         spacing: 0.5,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  /// If it is set to true, a small vertical line will be rendered. Else nothing
  /// will be rendered for that specific data point and left as a blank area.
  ///
  /// This is applicable for the following series types:
  /// * HiLo (High low)
  /// * OHLC (Open high low close)
  /// * Candle
  ///
  /// Defaults to `false`.
  final bool showIndicationForSameValues;

  /// Create the hilo series renderer.
  @override
  HiloSeriesRenderer<T, D> createRenderer() {
    HiloSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as HiloSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return HiloSeriesRenderer<T, D>();
  }

  @override
  HiloSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final HiloSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as HiloSeriesRenderer<T, D>;
    renderer
      ..spacing = spacing
      ..showIndicationForSameValues = showIndicationForSameValues;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, HiloSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..spacing = spacing
      ..showIndicationForSameValues = showIndicationForSameValues;
  }
}

/// Creates series renderer for hilo series.
class HiloSeriesRenderer<T, D> extends RangeSeriesRendererBase<T, D>
    with SegmentAnimationMixin<T, D> {
  double get spacing => _spacing;
  double _spacing = 0;
  set spacing(double value) {
    if (_spacing != value) {
      _spacing = value;
      markNeedsUpdate();
    }
  }

  bool get showIndicationForSameValues => _showIndicationForSameValues;
  bool _showIndicationForSameValues = false;
  set showIndicationForSameValues(bool value) {
    if (_showIndicationForSameValues != value) {
      _showIndicationForSameValues = value;
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as HiloSegment<T, D>
      ..series = this
      ..xValue = xValues[index]
      ..high = highValues[index]
      ..low = lowValues[index]
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  HiloSegment<T, D> createSegment() => HiloSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.hiloSeries;

  /// Changes the series color and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    updateSegmentColor(segment, color, borderWidth, isLineType: true);
    updateSegmentGradient(segment);
  }
}

/// Segment class for hilo series.
class HiloSegment<T, D> extends ChartSegment {
  late HiloSeriesRenderer<T, D> series;

  num xValue = double.nan;
  num high = double.nan;
  num low = double.nan;

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
    if (xValue.isNaN || high.isNaN || low.isNaN) {
      return;
    }

    points.clear();

    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;

    final double centerY = (low + high) / 2;
    if (high == low) {
      if (series.showIndicationForSameValues) {
        if (series.isTransposed) {
          points.add(
              Offset(transformX(xValue, high) - 2, transformY(xValue, high)));
          points.add(
              Offset(transformX(xValue, low) + 2, transformY(xValue, low)));
        } else {
          points.add(
              Offset(transformX(xValue, high), transformY(xValue, high) - 2));
          points.add(
              Offset(transformX(xValue, low), transformY(xValue, low) + 2));
        }
      }
    } else {
      points.add(Offset(transformX(xValue, high), transformY(xValue, high)));
      points.add(Offset(transformX(xValue, low), transformY(xValue, low)));
    }

    if (_oldPoints.isEmpty) {
      final Offset center =
          Offset(transformX(xValue, centerY), transformY(xValue, centerY));
      _oldPoints.addAll(<Offset>[center, center]);
    }

    if (points.length > _oldPoints.length) {
      _oldPoints.addAll(points.sublist(_oldPoints.length));
    }
  }

  @override
  bool contains(Offset position) {
    if (points.isEmpty) {
      return false;
    }

    late Rect segmentBounds;
    if (series.isTransposed) {
      final Offset start = series.yAxis != null && series.yAxis!.isInversed
          ? points[0]
          : points[1];
      final Offset end = series.yAxis != null && series.yAxis!.isInversed
          ? points[1]
          : points[0];
      segmentBounds = Rect.fromLTRB(
          start.dx, start.dy - hiloPadding, end.dx, end.dy + hiloPadding);
    } else {
      final Offset start = series.yAxis != null && series.yAxis!.isInversed
          ? points[1]
          : points[0];
      final Offset end = series.yAxis != null && series.yAxis!.isInversed
          ? points[0]
          : points[1];
      segmentBounds = Rect.fromLTRB(
          start.dx - hiloPadding, start.dy, end.dx + hiloPadding, end.dy);
    }

    if (segmentBounds.contains(position)) {
      return true;
    }

    return false;
  }

  CartesianChartPoint<D> _chartPoint() {
    return CartesianChartPoint<D>(
      x: series.xRawValues[currentSegmentIndex],
      xValue: series.xValues[currentSegmentIndex],
      high: high,
      low: low,
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (points.isEmpty) {
      return null;
    }

    final CartesianChartPoint<D> chartPoint = _chartPoint();
    pointIndex ??= currentSegmentIndex;
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
      hasMultipleYValues: true,
      markerColors: <Color?>[fillPaint.color],
      markerType: marker.type,
    );
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    if (pointIndex != -1 && points.isNotEmpty) {
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      return ChartTrackballInfo<T, D>(
        position: points[0],
        highXPos: series.pointToPixelX(xValue, high),
        highYPos: series.pointToPixelY(xValue, high),
        lowYPos: series.pointToPixelY(xValue, low),
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
    return null;
  }

  /// Gets the color of the series.
  @override
  Paint getFillPaint() => getStrokePaint();

  /// Gets the border color of the series.
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
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      final Offset start =
          Offset.lerp(_oldPoints[0], points[0], animationFactor)!;
      final Offset end =
          Offset.lerp(_oldPoints[1], points[1], animationFactor)!;
      drawDashes(canvas, series.dashArray, paint, start: start, end: end);
    }
  }

  @override
  void dispose() {
    points.clear();
    super.dispose();
  }
}
