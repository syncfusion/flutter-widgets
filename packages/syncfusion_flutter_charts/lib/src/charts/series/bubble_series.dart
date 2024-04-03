import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/data_label.dart';
import '../common/element_widget.dart';
import '../interactions/tooltip.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// This class holds the properties of the bubble series.
///
/// To render a bubble chart, create an instance of [BubbleSeries], and add it
/// to the series collection property of [SfCartesianChart].
/// A bubble chart requires three fields (X, Y, and Size) to plot a point. Here,
/// [sizeValueMapper] is used to map the size of each bubble segment
/// from the data source.
///
/// Provide the options for color, opacity, border color, and border width to
/// customize the appearance.
@immutable
class BubbleSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of BubbleSeries class.
  const BubbleSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.yValueMapper,
    super.sortFieldValueMapper,
    this.sizeValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.xAxisName,
    super.yAxisName,
    super.color,
    super.markerSettings,
    super.trendlines,
    this.minimumRadius = 3.0,
    this.maximumRadius = 10.0,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.name,
    super.enableTooltip = true,
    super.dashArray,
    super.animationDuration,
    this.borderColor = Colors.transparent,
    super.borderWidth,
    super.gradient,
    super.borderGradient,
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
  });

  /// Maximum radius value of the bubble in the series.
  ///
  /// Defaults to `10`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         maximumRadius: 9
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double maximumRadius;

  /// Minimum radius value of the bubble in the series.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         minimumRadius: 9
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double minimumRadius;

  /// Field in the data source, which is considered as size of the bubble for
  /// all the data points.
  ///
  /// _Note:_ This is applicable only for bubble series.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         dataSource: chartData,
  ///         sizeValueMapper: (BubbleColors sales, _) => sales.bubbleSize,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// final List<BubbleColors> chartData = <BubbleColors>[
  ///   BubbleColors(92.2, 7.8, 1.347),
  ///   BubbleColors(74, 6.5, 1.241),
  ///   BubbleColors(90.4, 6.0, 0.238),
  ///   BubbleColors(99.4, 2.2, 0.197),
  /// ];
  /// class BubbleColors {
  ///   BubbleColors(this.year, this.growth,[this.bubbleSize]);
  ///     final num year;
  ///     final num growth;
  ///     final num bubbleSize;
  /// }
  /// ```
  final ChartValueMapper<T, num>? sizeValueMapper;

  final Color borderColor;

  /// Create the bubble series renderer.
  @override
  BubbleSeriesRenderer<T, D> createRenderer() {
    BubbleSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as BubbleSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return BubbleSeriesRenderer<T, D>();
  }

  @override
  BubbleSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final BubbleSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as BubbleSeriesRenderer<T, D>;
    renderer
      ..maximumRadius = maximumRadius
      ..minimumRadius = minimumRadius
      ..sizeValueMapper = sizeValueMapper
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, BubbleSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..maximumRadius = maximumRadius
      ..minimumRadius = minimumRadius
      ..sizeValueMapper = sizeValueMapper
      ..borderColor = borderColor;
  }
}

/// Creates series renderer for bubble series.
class BubbleSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with SegmentAnimationMixin<T, D> {
  /// Calling the default constructor of BubbleSeriesRenderer class.
  BubbleSeriesRenderer();

  double get maximumRadius => _maximumRadius;
  double _maximumRadius = 10;
  set maximumRadius(double value) {
    if (_maximumRadius != value) {
      _maximumRadius = value;
      assert(_maximumRadius >= 0,
          'The maximum radius should be greater than or equal to 0.');
      canUpdateOrCreateSegments = true;
      markNeedsLayout();
    }
  }

  double get minimumRadius => _minimumRadius;
  double _minimumRadius = 3;
  set minimumRadius(double value) {
    if (_minimumRadius != value) {
      _minimumRadius = value;
      assert(_minimumRadius >= 0,
          'The minimum radius should be greater than or equal to 0.');
      canUpdateOrCreateSegments = true;
      markNeedsLayout();
    }
  }

  ChartValueMapper<T, num>? sizeValueMapper;

  Color get borderColor => _borderColor;
  Color _borderColor = Colors.transparent;
  set borderColor(Color value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsSegmentsPaint();
    }
  }

  final List<num> _chaoticSizes = <num>[];
  final List<num> _sizes = <num>[];

  num _minBubbleSize = double.infinity;
  num _maxBubbleSize = double.negativeInfinity;

  void _resetDataSourceHolders() {
    _chaoticSizes.clear();
    _sizes.clear();
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>?>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    _resetDataSourceHolders();
    if (sortingOrder == SortingOrder.none) {
      super.populateDataSource(
        <ChartValueMapper<T, num>>[],
        <List<num>>[],
        <List<num>>[],
        <ChartValueMapper<T, Object>>[sizeValueMapper ?? _defaultSize],
        <List<Object?>>[_sizes],
      );
    } else {
      super.populateDataSource(
        <ChartValueMapper<T, num>>[],
        <List<num>>[],
        <List<num>>[],
        <ChartValueMapper<T, Object>>[sizeValueMapper ?? _defaultSize],
        <List<Object?>>[_chaoticSizes],
        <List<Object?>>[_sizes],
      );
    }

    _minBubbleSize = double.infinity;
    _maxBubbleSize = double.negativeInfinity;
    for (final num size in _sizes) {
      _minBubbleSize = min(_minBubbleSize, size);
      _maxBubbleSize = max(_maxBubbleSize, size);
    }
    populateChartPoints();
  }

  @override
  void updateDataPoints(
    List<int>? removedIndexes,
    List<int>? addedIndexes,
    List<int>? replacedIndexes, [
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    if (sortingOrder == SortingOrder.none) {
      super.updateDataPoints(
        removedIndexes,
        addedIndexes,
        replacedIndexes,
        <ChartValueMapper<T, num>>[],
        <List<num>>[],
        <List<num>>[],
        <ChartValueMapper<T, Object>>[sizeValueMapper ?? _defaultSize],
        <List<Object?>>[_sizes],
      );
    } else {
      _sizes.clear();
      super.updateDataPoints(
        removedIndexes,
        addedIndexes,
        replacedIndexes,
        <ChartValueMapper<T, num>>[],
        <List<num>>[],
        <List<num>>[],
        <ChartValueMapper<T, Object>>[sizeValueMapper ?? _defaultSize],
        <List<Object?>>[_chaoticSizes],
        <List<Object?>>[_sizes],
      );
    }
  }

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    if (yLists == null) {
      yLists = <List<num>>[_sizes];
      positions = <ChartDataPointType>[
        ChartDataPointType.bubbleSize,
      ];
    } else {
      yLists.add(_sizes);
      positions!.add(ChartDataPointType.bubbleSize);
    }

    super.populateChartPoints(positions: positions, yLists: yLists);
  }

  num _defaultSize(T type, num value) => minimumRadius;

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);

    num radius = _sizes[index];
    if (radius.isNaN || sizeValueMapper == null) {
      radius = minimumRadius;
    } else {
      final num sizeDelta = _maxBubbleSize - _minBubbleSize;
      if (sizeDelta == 0) {
        radius = radius == 0 ? minimumRadius : maximumRadius;
      } else {
        final num radiusDiff = maximumRadius - minimumRadius;
        radius = minimumRadius + radiusDiff * (radius / _maxBubbleSize);
      }
    }

    segment as BubbleSegment<T, D>
      ..series = this
      ..x = xValues[index]
      ..y = yValues[index]
      ..radius = radius
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  BubbleSegment<T, D> createSegment() => BubbleSegment<T, D>();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final BubbleSegment<T, D> bubbleSegment = segment as BubbleSegment<T, D>;
    updateSegmentColor(bubbleSegment, borderColor, borderWidth);
    updateSegmentGradient(bubbleSegment,
        gradientBounds: bubbleSegment.segmentRect,
        gradient: gradient,
        borderGradient: borderGradient);
  }

  @override
  Color dataLabelSurfaceColor(CartesianChartDataLabelPositioned label) {
    final ChartDataLabelAlignment alignment = label.labelAlignment;
    final ChartSegment segment = segments[label.dataPointIndex];
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.bottom:
        return super.dataLabelSurfaceColor(label);

      case ChartDataLabelAlignment.middle:
        return segment.getFillPaint().color;
    }
  }

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.bubbleSeries;

  @override
  ChartDataLabelAlignment effectiveDataLabelAlignment(
    ChartDataLabelAlignment alignment,
    ChartDataPointType position,
    ChartElementParentData? previous,
    ChartElementParentData current,
    ChartElementParentData? next,
  ) {
    return alignment == ChartDataLabelAlignment.auto
        ? ChartDataLabelAlignment.outer
        : alignment;
  }

  @override
  Offset dataLabelPosition(
    ChartElementParentData current,
    ChartDataLabelAlignment alignment,
    Size size,
  ) {
    final EdgeInsets margin = dataLabelSettings.margin;
    double translationX = 0.0;
    double translationY = 0.0;
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.middle:
        if (isTransposed) {
          translationX = -margin.left - size.width / 2;
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = -margin.top - size.height / 2;
        }
        return translateTransform(
            current.x!, current.y!, translationX, translationY);

      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
        final BubbleSegment<T, D> segment =
            segments[current.dataPointIndex] as BubbleSegment<T, D>;
        translationX = -margin.left;
        translationY = -(segment.radius +
            dataLabelPadding +
            size.height +
            margin.vertical);
        return translateTransform(
            current.x!, current.y!, translationX, translationY);

      case ChartDataLabelAlignment.bottom:
        final BubbleSegment<T, D> segment =
            segments[current.dataPointIndex] as BubbleSegment<T, D>;
        translationX = -margin.left;
        translationY = segment.radius + dataLabelPadding;
        return translateTransform(
            current.x!, current.y!, translationX, translationY);
    }
  }

  @override
  void dispose() {
    _resetDataSourceHolders();
    super.dispose();
  }
}

/// Creates the segments for bubble series.
///
/// Generates the bubble series points and has the [calculateSegmentPoints]
/// override method used to customize the bubble series
/// segment point calculation.
///
/// Gets the path, stroke color and fill color from the `series` to render
/// the bubble series.
class BubbleSegment<T, D> extends ChartSegment {
  late BubbleSeriesRenderer<T, D> series;
  late num x;
  late num y;
  late num radius;

  Rect? _oldSegmentRect;
  Rect? segmentRect;

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _oldSegmentRect = null;
      return;
    }

    if (series.animationDuration > 0) {
      _oldSegmentRect =
          Rect.lerp(_oldSegmentRect, segmentRect, segmentAnimationFactor);
    } else {
      _oldSegmentRect = segmentRect;
    }
  }

  @override
  void transformValues() {
    if (x.isNaN || y.isNaN || radius.isNaN) {
      segmentRect = null;
      _oldSegmentRect = null;
      points.clear();
      return;
    }

    points.clear();
    final double pixelX = series.pointToPixelX(x, y);
    final double pixelY = series.pointToPixelY(x, y);
    final Offset center = Offset(pixelX, pixelY);
    final double size = radius * 2.0;
    segmentRect = Rect.fromCircle(center: center, radius: size);
    _oldSegmentRect ??= Rect.fromCircle(center: center, radius: 0.0);
    points.add(center);
  }

  @override
  bool contains(Offset position) {
    return segmentRect != null && segmentRect!.contains(position);
  }

  CartesianChartPoint<D> _chartPoint() {
    return CartesianChartPoint<D>(
      x: series.xRawValues[currentSegmentIndex],
      xValue: x,
      y: y,
      bubbleSize: series._sizes[currentSegmentIndex],
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (segmentRect != null) {
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      return ChartTooltipInfo<T, D>(
        primaryPosition: series.localToGlobal(segmentRect!.topCenter),
        secondaryPosition: series.localToGlobal(segmentRect!.bottomCenter),
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
        pointIndex: currentSegmentIndex,
        markerColors: <Color?>[fillPaint.color],
        markerType: series.markerAt(pointIndex ?? currentSegmentIndex).type,
      );
    }
    return null;
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    if (pointIndex != -1 && segmentRect != null) {
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      return ChartTrackballInfo<T, D>(
        position: segmentRect!.center,
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
    if (segmentRect == null) {
      return;
    }
    final Rect? paintRect =
        Rect.lerp(_oldSegmentRect, segmentRect, animationFactor);
    if (paintRect == null || paintRect.isEmpty) {
      return;
    }

    Paint paint = getFillPaint();
    if (paint.color != Colors.transparent) {
      canvas.drawOval(paintRect, paint);
    }

    paint = getStrokePaint();
    final double strokeWidth = paint.strokeWidth;
    if (paint.color != Colors.transparent && strokeWidth > 0) {
      final Path strokePath = Path()
        ..addOval(paintRect.deflate(strokeWidth / 2));
      drawDashes(canvas, series.dashArray, paint, path: strokePath);
    }
  }

  @override
  void dispose() {
    segmentRect = null;
    _oldSegmentRect = null;
    points.clear();
    super.dispose();
  }
}
