import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../base.dart';
import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/data_label.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// Renders the range column series.
///
/// To render a range column chart, create an instance of [RangeColumnSeries]
/// and add to the series collection property of [SfCartesianChart].
///
/// [RangeColumnSeries] is similar to column series but requires two Y values
/// for a point, your data should contain high and low values.
/// High and low value specify the maximum and minimum range of the point.
///
/// * [highValueMapper] - Field in the data source, which is considered as
/// high value for the data points.
/// * [lowValueMapper] - Field in the data source, which is considered as
/// low value for the data points.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=uSsKhlRzC2Q}
@immutable
class RangeColumnSeries<T, D> extends RangeSeriesBase<T, D> {
  /// Creating an argument constructor of RangeColumnSeries class.
  const RangeColumnSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.highValueMapper,
    required super.lowValueMapper,
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
    super.borderColor = Colors.transparent,
    super.trendlines,
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
  ///     series: <RangeColumnSeries<SalesData, num>>[
  ///       RangeColumnSeries<SalesData, num>(
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
  ///     series: <RangeColumnSeries<SalesData, num>>[
  ///       RangeColumnSeries<SalesData, num>(
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
  ///     series: <RangeColumnSeries<SalesData, num>>[
  ///       RangeColumnSeries<SalesData, num>(
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
  ///     series: <RangeColumnSeries<SalesData, num>>[
  ///       RangeColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackPadding: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double trackPadding;

  /// Spacing between the columns.
  ///
  /// The value ranges from 0 to 1. 1 represents 100% and 0 represents 0%
  /// of the available space.
  ///
  /// Spacing also affects the width of the range column. For example, setting
  /// 20% spacing and 100% width renders the column with 80% of total width.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <RangeColumnSeries<SalesData, num>>[
  ///       RangeColumnSeries<SalesData, num>(
  ///         spacing: 0.5,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  /// Renders range column with track.
  ///
  /// Track is a rectangular bar rendered from the start to the end of the axis.
  /// Range Column Series will be rendered above the track.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <RangeColumnSeries<SalesData, num>>[
  ///       RangeColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool isTrackVisible;

  /// Customizes the corners of the range column.
  ///
  /// Each corner can be customized with a desired value or with a single value.
  ///
  /// Defaults to `Radius.zero`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <RangeColumnSeries<SalesData, num>>[
  ///       RangeColumnSeries<SalesData, num>(
  ///         borderRadius: BorderRadius.circular(5),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderRadius borderRadius;

  final double width;

  /// Create the range column series renderer.
  @override
  RangeColumnSeriesRenderer<T, D> createRenderer() {
    RangeColumnSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer =
          onCreateRenderer!(this) as RangeColumnSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return RangeColumnSeriesRenderer<T, D>();
  }

  @override
  RangeColumnSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final RangeColumnSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as RangeColumnSeriesRenderer<T, D>;
    renderer
      ..trackColor = trackColor
      ..trackBorderColor = trackBorderColor
      ..trackBorderWidth = trackBorderWidth
      ..trackPadding = trackPadding
      ..spacing = spacing
      ..borderRadius = borderRadius
      ..isTrackVisible = isTrackVisible
      ..width = width
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, RangeColumnSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..trackColor = trackColor
      ..trackBorderColor = trackBorderColor
      ..trackBorderWidth = trackBorderWidth
      ..trackPadding = trackPadding
      ..spacing = spacing
      ..borderRadius = borderRadius
      ..isTrackVisible = isTrackVisible
      ..width = width
      ..borderColor = borderColor;
  }
}

/// Creates series renderer for range column series.
class RangeColumnSeriesRenderer<T, D> extends RangeSeriesRendererBase<T, D>
    with SbsSeriesMixin<T, D>, ClusterSeriesMixin, SegmentAnimationMixin<T, D> {
  Color get trackBorderColor => _trackBorderColor;
  Color _trackBorderColor = Colors.transparent;
  set trackBorderColor(Color value) {
    if (_trackBorderColor != value) {
      _trackBorderColor = value;
      markNeedsSegmentsPaint();
    }
  }

  Color get trackColor => _trackColor;
  Color _trackColor = Colors.grey;
  set trackColor(Color value) {
    if (_trackBorderColor != value) {
      _trackColor = value;
      markNeedsSegmentsPaint();
    }
  }

  double get trackBorderWidth => _trackBorderWidth;
  double _trackBorderWidth = 1.0;
  set trackBorderWidth(double value) {
    if (_trackBorderWidth != value) {
      _trackBorderWidth = value;
      markNeedsSegmentsPaint();
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

  bool get isTrackVisible => _isTrackVisible;
  bool _isTrackVisible = false;
  set isTrackVisible(bool value) {
    if (_isTrackVisible != value) {
      _isTrackVisible = value;
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

  Color _dataLabelSurfaceColor() {
    final SfChartThemeData chartThemeData = parent!.chartThemeData!;
    final ThemeData themeData = parent!.themeData!;
    if (chartThemeData.plotAreaBackgroundColor != Colors.transparent) {
      return chartThemeData.plotAreaBackgroundColor!;
    } else if (chartThemeData.backgroundColor != Colors.transparent) {
      return chartThemeData.backgroundColor!;
    }
    return themeData.colorScheme.surface;
  }

  @override
  Color dataLabelSurfaceColor(CartesianChartDataLabelPositioned label) {
    final ChartDataLabelAlignment alignment = label.labelAlignment;
    final ChartSegment segment = segments[label.dataPointIndex];
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.middle:
      case ChartDataLabelAlignment.bottom:
        return _dataLabelSurfaceColor();

      case ChartDataLabelAlignment.top:
        return segment.getFillPaint().color;
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as RangeColumnSegment<T, D>
      ..series = this
      ..x = xValues[index]
      ..top = highValues[index]
      ..bottom = lowValues[index]
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  RangeColumnSegment<T, D> createSegment() => RangeColumnSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      ShapeMarkerType.rangeColumnSeries;

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final RangeColumnSegment<T, D> rangeColumnSegment =
        segment as RangeColumnSegment<T, D>;
    updateSegmentTrackerStyle(
        rangeColumnSegment, trackColor, trackBorderColor, trackBorderWidth);
    updateSegmentColor(rangeColumnSegment, borderColor, borderWidth);
    updateSegmentGradient(rangeColumnSegment,
        gradientBounds: rangeColumnSegment.segmentRect?.outerRect,
        gradient: gradient,
        borderGradient: borderGradient);
  }
}

/// Segment class for range column series.
class RangeColumnSegment<T, D> extends ChartSegment with BarSeriesTrackerMixin {
  late RangeColumnSeriesRenderer<T, D> series;
  late num x;
  late num top;
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

    if (series.animationDuration > 0) {
      _oldSegmentRect =
          RRect.lerp(_oldSegmentRect, segmentRect, segmentAnimationFactor);
    } else {
      _oldSegmentRect = segmentRect;
    }
  }

  @override
  void transformValues() {
    if (x.isNaN || top.isNaN || bottom.isNaN) {
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

    final double x1 = transformX(left, top);
    final double y1 = transformY(left, top);
    final double x2 = transformX(right, bottom);
    final double y2 = transformY(right, bottom);

    final BorderRadius borderRadius = series._borderRadius;
    segmentRect = toRRect(x1, y1, x2, y2, borderRadius);
    final double centerY = (bottom + top) / 2;
    _oldSegmentRect ??= toRRect(
      transformX(left, centerY),
      transformY(left, centerY),
      transformX(right, centerY),
      transformY(right, centerY),
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
      high: top,
      low: bottom,
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (segmentRect != null) {
      pointIndex ??= currentSegmentIndex;
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      final TooltipPosition? tooltipPosition =
          series.parent?.tooltipBehavior?.tooltipPosition;
      final ChartMarker marker = series.markerAt(pointIndex);
      final double markerHeight =
          series.markerSettings.isVisible ? marker.height / 2 : 0;
      final Offset preferredPos = tooltipPosition == TooltipPosition.pointer
          ? position ?? segmentRect!.outerRect.topCenter
          : segmentRect!.outerRect.topCenter;
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
    return null;
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    if (pointIndex != -1 && segmentRect != null) {
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      final Offset preferredPos =
          Offset(series.pointToPixelX(x, top), series.pointToPixelY(x, top));
      return ChartTrackballInfo<T, D>(
        position: preferredPos,
        highXPos: preferredPos.dx,
        highYPos: preferredPos.dy,
        lowYPos: series.pointToPixelY(chartPoint.xValue!, bottom),
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

    final RRect? paintRRect =
        RRect.lerp(_oldSegmentRect, segmentRect, animationFactor);
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
      final Path strokePath = strokePathFromRRect(paintRRect, strokeWidth);
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
