import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../base.dart';
import '../behaviors/trackball.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../common/core_legend.dart';
import '../common/core_tooltip.dart';
import '../common/legend.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// This class has the properties of the bar series.
///
/// To render a bar chart, create an instance of [BarSeries], and add it to
/// the series collection property of [SfCartesianChart].
/// The bar series are rectangular bars with heights or lengths proportional
/// to their represented values.It has the property of spacing to provide
/// spacing between bars.
///
/// Provides options for color, opacity, border color and border width to
/// customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=MHQzCN_jD1Q}
@immutable
class BarSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of BarSeries class.
  const BarSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.yValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    this.isTrackVisible = false,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    this.width = 0.7,
    this.spacing = 0.0,
    super.markerSettings,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.gradient,
    super.borderGradient,
    this.borderRadius = BorderRadius.zero,
    super.enableTooltip = true,
    super.animationDuration,
    this.trackColor = Colors.grey,
    this.trackBorderColor = Colors.transparent,
    this.trackBorderWidth = 1.0,
    this.trackPadding = 0.0,
    super.trendlines,
    this.borderColor = Colors.transparent,
    super.borderWidth,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.opacity,
    super.animationDelay,
    super.dashArray,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    super.initialSelectedDataIndexes,
  });

  /// Color of the track.
  ///
  /// Defaults to `Colors.grey`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackColor: Colors.red
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color trackColor;

  /// Color of the track border.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackBorderColor: Colors.red
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color trackBorderColor;

  /// Width of the track border.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackBorderColor: Colors.red,
  ///         trackBorderWidth: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double trackBorderWidth;

  /// Padding of the track.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackPadding: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double trackPadding;

  /// Spacing between the bars. The value ranges from 0 to 1.
  ///
  /// 1 represents 100% and 0 represents 0% of the available space.
  ///
  /// Spacing also affects the height of the bar. For example, setting 20%
  /// spacing and 100% height renders the bar with 80% of total height.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         spacing: 0.5
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  /// Customizes the corners of the bar.
  ///
  /// Each corner can be customized with desired
  /// value or with a single value.
  ///
  /// Defaults to `Radius.zero`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         borderRadius: BorderRadius.all(Radius.circular(5))
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderRadius borderRadius;

  /// Renders bars with track.
  ///
  /// Track is a rectangular bar rendered from the start to the
  /// end of the axis.
  ///
  /// Bar series will be rendered above the track.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         isTrackVisible: true
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool isTrackVisible;

  final double width;

  final Color borderColor;

  @override
  @nonVirtual
  bool transposed() => true;

  /// Create the bar series renderer.
  @override
  BarSeriesRenderer<T, D> createRenderer() {
    BarSeriesRenderer<T, D>? renderer;
    if (onCreateRenderer != null) {
      renderer = onCreateRenderer!(this) as BarSeriesRenderer<T, D>?;
      assert(
          renderer != null,
          'This onCreateRenderer callback function should return value as '
          'extends from ChartSeriesRenderer class and should not be return '
          'value as null');
    }

    return renderer ?? BarSeriesRenderer<T, D>();
  }

  @override
  BarSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final BarSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as BarSeriesRenderer<T, D>;
    renderer
      ..isTrackVisible = isTrackVisible
      ..trackColor = trackColor
      ..trackBorderColor = trackBorderColor
      ..trackBorderWidth = trackBorderWidth
      ..trackPadding = trackPadding
      ..spacing = spacing
      ..width = width
      ..borderRadius = borderRadius
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, BarSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..isTrackVisible = isTrackVisible
      ..trackColor = trackColor
      ..trackBorderColor = trackBorderColor
      ..trackBorderWidth = trackBorderWidth
      ..trackPadding = trackPadding
      ..spacing = spacing
      ..width = width
      ..borderRadius = borderRadius
      ..borderColor = borderColor;
  }
}

// Creates series renderer for bar series.
class BarSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with SbsSeriesMixin<T, D>, ClusterSeriesMixin, SegmentAnimationMixin<T, D> {
  /// Calling the default constructor of BarSeriesRenderer class.
  BarSeriesRenderer();

  Color get trackColor => _trackColor;
  Color _trackColor = Colors.grey;
  set trackColor(Color value) {
    if (_trackColor != value) {
      _trackColor = value;
      markNeedsLayout();
    }
  }

  Color get trackBorderColor => _trackBorderColor;
  Color _trackBorderColor = Colors.transparent;
  set trackBorderColor(Color value) {
    if (_trackColor != value) {
      _trackBorderColor = value;
      markNeedsLayout();
    }
  }

  double get trackBorderWidth => _trackBorderWidth;
  double _trackBorderWidth = 1.0;
  set trackBorderWidth(double value) {
    if (_trackBorderWidth != value) {
      _trackBorderWidth = value;
      markNeedsLayout();
    }
  }

  double get trackPadding => _trackPadding;
  double _trackPadding = 0.0;
  set trackPadding(double value) {
    if (_trackPadding != value) {
      _trackPadding = value;
      markNeedsLayout();
    }
  }

  BorderRadius get borderRadius => _borderRadius;
  BorderRadius _borderRadius = BorderRadius.zero;
  set borderRadius(BorderRadius value) {
    if (_borderRadius != value) {
      _borderRadius = value;
      markNeedsLayout();
    }
  }

  Color get borderColor => _borderColor;
  Color _borderColor = Colors.transparent;
  set borderColor(Color value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsSegmentsPaint();
    }
  }

  bool get isTrackVisible => _isTrackVisible;
  bool _isTrackVisible = false;
  set isTrackVisible(bool value) {
    if (_isTrackVisible != value) {
      _isTrackVisible = value;
      markNeedsLayout();
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as BarSegment<T, D>
      ..series = this
      ..x = xValues[index]
      ..y = yValues[index]
      ..bottom = bottom
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  BarSegment<T, D> createSegment() => BarSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.barSeries;

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final BarSegment<T, D> barSegment = segment as BarSegment<T, D>;
    updateSegmentTrackerStyle(
        barSegment, trackColor, trackBorderColor, trackBorderWidth);
    updateSegmentColor(barSegment, borderColor, borderWidth);
    updateSegmentGradient(barSegment,
        gradientBounds: barSegment.segmentRect?.outerRect,
        gradient: gradient,
        borderGradient: borderGradient);
  }

  @override
  void handleLegendItemTapped(LegendItem item, bool isToggled) {
    if (parent != null && parent!.onLegendTapped != null) {
      final ChartLegendItem legendItem = item as ChartLegendItem;
      final LegendTapArgs args = LegendTapArgs(
          legendItem.series, legendItem.seriesIndex, legendItem.pointIndex);
      parent!.onLegendTapped!(args);
    }
    parent!.behaviorArea?.hideInteractiveTooltip();

    controller.isVisible = !isToggled;
    if (controller.isVisible == !isToggled) {
      item.onToggled?.call();
      visibilityBeforeTogglingLegend = isToggled;
      animateAllBarSeries(parent!);
    }

    if (trendlineContainer != null) {
      trendlineContainer!.updateLegendState(item, isToggled);
      markNeedsLegendUpdate();
    }
    markNeedsUpdate();
  }

  @override
  void onRealTimeAnimationUpdate() {
    super.onRealTimeAnimationUpdate();
    transformValues();
  }
}

/// Creates the segments for bar series.
///
/// This generates the bar series points and has the [calculateSegmentPoints]
/// override method used to customize the bar series segment point calculation.
///
/// It gets the path, stroke color and fill color from the `series` to render
/// the bar segment.
class BarSegment<T, D> extends ChartSegment with BarSeriesTrackerMixin {
  late BarSeriesRenderer<T, D> series;
  late num x;
  late num y;
  late num bottom;

  RRect? _oldSegmentRect;
  RRect? segmentRect;

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _oldSegmentRect = null;
      segmentRect = null;
      return;
    }

    _oldSegmentRect = segmentRect;
  }

  @override
  void transformValues() {
    if (x.isNaN || y.isNaN || bottom.isNaN) {
      segmentRect = null;
      _oldSegmentRect = null;
      points.clear();
      return;
    }

    points.clear();
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;
    final num left = x + series.sbsInfo.minimum;
    final num right = x + series.sbsInfo.maximum;

    final double x1 = transformX(left, y);
    final double y1 = transformY(left, y);
    final double x2 = transformX(right, bottom);
    final double y2 = transformY(right, bottom);

    final BorderRadius borderRadius = series.borderRadius;
    segmentRect = toRRect(x1, y1, x2, y2, borderRadius);
    _oldSegmentRect ??= toRRect(
      transformX(left, bottom),
      transformY(left, bottom),
      x2,
      y2,
      borderRadius,
    );

    if (series.isTrackVisible) {
      calculateTrackerBounds(
        left,
        right,
        borderRadius,
        series.trackPadding,
        series.trackBorderWidth,
        series,
      );
    }
  }

  @override
  bool contains(Offset position) {
    return segmentRect != null && segmentRect!.contains(position);
  }

  CartesianChartPoint<D> _chartPoint() {
    return CartesianChartPoint<D>(
      x: series.xRawValues[currentSegmentIndex],
      xValue: series.xValues[currentSegmentIndex],
      y: series.yValues[currentSegmentIndex],
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (segmentRect != null) {
      pointIndex ??= currentSegmentIndex;
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      final TooltipPosition? tooltipPosition =
          series.parent?.tooltipBehavior?.tooltipPosition;
      final Offset posFromRect = segmentRect!.outerRect.topCenter;
      final Offset preferredPos = tooltipPosition == TooltipPosition.pointer
          ? position ?? posFromRect
          : posFromRect;
      final ChartMarker marker = series.markerAt(pointIndex);
      final double markerHeight =
          series.markerSettings.isVisible ? marker.height / 2 : 0;
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
        markerColors: <Color?>[fillPaint.color],
        markerType: marker.type,
      );
    }
    return null;
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    if (pointIndex != -1 && segmentRect != null) {
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      return ChartTrackballInfo<T, D>(
        position:
            Offset(series.pointToPixelX(x, y), series.pointToPixelY(x, y)),
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
  Paint getFillPaint() => fillPaint;

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() => strokePaint;

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (series.isTrackVisible) {
      // Draws the tracker bounds.
      super.onPaint(canvas);
    }

    if (segmentRect == null) {
      return;
    }

    RRect? paintRRect;
    if (series.parent!.isLegendToggled &&
        _oldSegmentRect != null &&
        series.animationType != AnimationType.loading) {
      paintRRect = performLegendToggleAnimation(
          series, segmentRect!, _oldSegmentRect!, series.borderRadius);
    } else {
      paintRRect = RRect.lerp(_oldSegmentRect, segmentRect, animationFactor);
    }

    if (paintRRect == null || paintRRect.isEmpty) {
      return;
    }

    Paint paint = getFillPaint();
    if (paint.color != Colors.transparent) {
      canvas.drawRRect(paintRRect, paint);
    }

    paint = getStrokePaint();
    final double strokeWidth = paint.strokeWidth;
    if (paint.color != Colors.transparent && strokeWidth > 0) {
      final Path strokePath = strokePathFromRRect(segmentRect, strokeWidth);
      drawDashes(canvas, series.dashArray, paint, path: strokePath);
    }
  }

  @override
  void dispose() {
    segmentRect = null;
    _oldSegmentRect = null;
    super.dispose();
  }
}
