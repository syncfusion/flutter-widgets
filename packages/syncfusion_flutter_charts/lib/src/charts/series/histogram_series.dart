import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../base.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../interactions/trackball.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// This class has the properties of the histogram series.
///
/// To render a histogram chart, create an instance of [HistogramSeries],
/// and add it to the series collection property of [SfCartesianChart].
/// The histogram series is a rectangular histogram with heights or
/// lengths proportional to the values that they represent. It has the spacing
/// property to separate the histogram.
///
/// Provide the options of color, opacity, border color, and border width to
/// customize the appearance.
class HistogramSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of HistogramSeries class.
  const HistogramSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
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
    this.width = 0.95,
    this.spacing = 0.0,
    super.markerSettings,
    super.trendlines,
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
    this.borderColor = Colors.transparent,
    super.borderWidth,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.opacity,
    super.animationDelay,
    super.dashArray,
    this.binInterval,
    this.showNormalDistributionCurve = false,
    this.curveColor = Colors.blue,
    this.curveWidth = 2.0,
    this.curveDashArray,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
  });

  /// Interval value by which the data points are grouped and rendered as bars,
  /// in histogram series.
  ///
  /// For example, if the [binInterval] is set to 20, the x-axis will split
  /// with 20 as the interval. The first bar in the histogram represents the
  /// count of values lying between 0 to 20 in the provided data and the second
  /// bar will represent 20 to 40.
  ///
  /// If no value is specified for this property, then the interval will be
  /// calculated automatically based on the data points count and value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         binInterval: 4
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? binInterval;

  /// Renders a spline curve for the normal distribution, calculated based
  /// on the series data points.
  ///
  /// This spline curve type can be changed using the `splineType` property.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         showNormalDistributionCurve: true
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool showNormalDistributionCurve;

  /// Color of the normal distribution spline curve.
  ///
  /// Defaults to `Colors.blue`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         curveColor: Colors.red
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color curveColor;

  /// Width of the normal distribution spline curve.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         curveWidth: 4
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double curveWidth;

  /// Dash array of the normal distribution spline curve.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         curveDashArray: [2, 3]
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final List<double>? curveDashArray;

  /// Color of the track.
  ///
  /// Defaults to `Colors.grey`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
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
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
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
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
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
  /// By default, track will be rendered based on the bar’s available width and
  /// spacing. If you wish to change the track width, you can use this property.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackPadding: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double trackPadding;

  /// Spacing between the bars in histogram series.
  ///
  /// The value ranges from 0 to 1. 1 represents 100% and 0 represents
  /// 0% of the available space.
  ///
  /// Spacing also affects the width of the bar. For example, setting 20%
  /// spacing and 100% width renders the bar with 80% of total width.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         spacing: 0.5,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  /// Renders the bar in histogram series with track.
  ///
  /// Track is a rectangular bar rendered from the start to the end of the axis.
  /// Bars in the histogram will be rendered above the track.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///       ),
  ///     ],
  ///    );
  /// }
  /// ```
  final bool isTrackVisible;

  /// Customizes the corners of the bars in histogram series.
  ///
  /// Each corner can be customized individually or can be customized together,
  /// by specifying a single value.
  ///
  /// Defaults to `Radius.zero`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         borderRadius: BorderRadius.circular(5),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderRadius borderRadius;

  final double width;

  final Color borderColor;

  /// Create the histogram series renderer.
  @override
  HistogramSeriesRenderer<T, D> createRenderer() {
    HistogramSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as HistogramSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return HistogramSeriesRenderer<T, D>();
  }

  @override
  HistogramSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final HistogramSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as HistogramSeriesRenderer<T, D>;
    renderer
      ..binInterval = binInterval
      ..showNormalDistributionCurve = showNormalDistributionCurve
      ..curveColor = curveColor
      ..curveDashArray = curveDashArray
      ..trackColor = trackColor
      ..trackBorderColor = trackBorderColor
      ..trackBorderWidth = trackBorderWidth
      ..trackPadding = trackPadding
      ..width = width
      ..spacing = spacing
      ..width = width
      ..borderRadius = borderRadius
      ..isTrackVisible = isTrackVisible
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, HistogramSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..binInterval = binInterval
      ..showNormalDistributionCurve = showNormalDistributionCurve
      ..curveColor = curveColor
      ..curveDashArray = curveDashArray
      ..trackColor = trackColor
      ..trackBorderColor = trackBorderColor
      ..trackBorderWidth = trackBorderWidth
      ..trackPadding = trackPadding
      ..width = width
      ..spacing = spacing
      ..width = width
      ..borderRadius = borderRadius
      ..isTrackVisible = isTrackVisible
      ..borderColor = borderColor;
  }
}

/// Creates series renderer for histogram series.
class HistogramSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with SbsSeriesMixin<T, D>, ClusterSeriesMixin, SegmentAnimationMixin<T, D> {
  double? get binInterval => _binInterval;
  double? _binInterval;
  set binInterval(double? value) {
    if (_binInterval != value) {
      _binInterval = value;
      markNeedsLayout();
    }
  }

  bool get showNormalDistributionCurve => _showNormalDistributionCurve;
  bool _showNormalDistributionCurve = false;
  set showNormalDistributionCurve(bool value) {
    if (_showNormalDistributionCurve != value) {
      _showNormalDistributionCurve = value;
      markNeedsLayout();
    }
  }

  Color get curveColor => _curveColor;
  Color _curveColor = Colors.blue;
  set curveColor(Color value) {
    if (_curveColor != value) {
      _curveColor = value;
      markNeedsSegmentsPaint();
    }
  }

  double get curveWidth => _curveWidth;
  double _curveWidth = 2.0;
  set curveWidth(double value) {
    if (_curveWidth != value) {
      _curveWidth = value;
      markNeedsSegmentsPaint();
    }
  }

  List<double>? get curveDashArray => _curveDashArray;
  List<double>? _curveDashArray;
  set curveDashArray(List<double>? value) {
    if (_curveDashArray != value) {
      _curveDashArray = value;
      markNeedsLayout();
    }
  }

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
    if (_trackColor != value) {
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

  @override
  double get spacing => _spacing;
  double _spacing = 0.0;
  @override
  set spacing(double value) {
    assert(value >= 0 && value <= 1,
        'The spacing of the series should be between 0 and 1');
    if (_spacing != value) {
      _spacing = value;
      markNeedsUpdate();
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

  /// It holds the raw Y value from the [super.yValueMapper].
  final List<num> _yRawValues = <num>[];

  /// It holds the actual Histogram [X] and [Y] values.
  final List<num> _histogramXValues = <num>[];
  final List<num> _histogramYValues = <num>[];

  /// It holds actual [_histogramXValues] count.
  int _xCount = 0;

  num _deviation = 0.0;
  num _mean = 0.0;
  num _binWidth = 0.0;

  Path? _distributionPath;

  void _resetDataHolders() {
    _xCount = 0;
    _yRawValues.clear();
    _histogramXValues.clear();
    _histogramYValues.clear();
  }

  @override
  ChartValueMapper<T, num>? get yValueMapper => _histogramYValueMapper;

  // TODO(Natrayansf): Avoid casting.
  D? _histogramXValueMapper(T data, int index) {
    return index < _xCount ? _histogramXValues[index] as D : null;
  }

  num? _histogramYValueMapper(T data, int index) {
    return index < _xCount ? _histogramYValues[index] : null;
  }

  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? fLists,
  ]) {
    _resetDataHolders();
    if (dataSource == null ||
        dataSource!.isEmpty ||
        super.yValueMapper == null) {
      return;
    }

    final int length = dataSource!.length;
    for (int i = 0; i < length; i++) {
      final T current = dataSource![i];
      final num? yValue = super.yValueMapper!(current, i);
      // TODO(Natrayansf): Handle null properly.
      if (yValue == null || yValue.isNaN) {
        _yRawValues.add(0);
      } else {
        _yRawValues.add(yValue);
      }
    }

    // Calculate the actual Histogram [X] and [Y] values.
    _calculateStandardDeviation(_histogramXValues, _histogramYValues);

    _xCount = _histogramXValues.length;
    // Invoke custom [_histogramXValueMapper] method.
    xValueMapper = _histogramXValueMapper;

    super.populateDataSource(yPaths, chaoticYLists, yLists, fPaths, fLists);
    populateChartPoints();
  }

  void _calculateStandardDeviation(
      List<num> histogramXValues, List<num> histogramYValues) {
    if (_yRawValues.isEmpty) {
      return;
    }

    num sumOfY = 0;
    num sumValue = 0;
    _mean = 0;
    final num yLength = _yRawValues.length;
    for (int i = 0; i < yLength; i++) {
      final num yValue = _yRawValues[i];
      sumOfY += yValue;
      _mean = sumOfY / yLength;
    }

    for (int i = 0; i < yLength; i++) {
      final num yValue = _yRawValues[i];
      sumValue += (yValue - _mean) * (yValue - _mean);
    }

    _deviation = sqrt(sumValue / (yLength - 1));
    num minValue = _yRawValues.reduce(min);
    _binWidth = binInterval ?? (3.5 * _deviation) / pow(yLength, 1 / 3);

    for (int i = 0; i < yLength;) {
      final num count = _yRawValues
          .where((num y) => y >= minValue && y < (minValue + _binWidth))
          .length;
      // TODO(VijayakumarM): What happened when count is 0?
      if (count >= 0) {
        histogramYValues.add(count);
        final num x = minValue + _binWidth / 2;
        histogramXValues.add(x);
        minValue += _binWidth;
        i += count as int;
      }
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as HistogramSegment<T, D>
      ..series = this
      ..x = xValues[index]
      ..y = yValues[index]
      ..bottom = bottom
      .._binWidth = _binWidth
      ..isEmpty = isEmpty(index);
  }

  @override
  HistogramSegment<T, D> createSegment() => HistogramSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.histogramSeries;

  @override
  void customizeSegment(ChartSegment segment) {
    final HistogramSegment<T, D> histogramSegment =
        segment as HistogramSegment<T, D>;
    updateSegmentTrackerStyle(
        histogramSegment, trackColor, trackBorderColor, trackBorderWidth);
    updateSegmentColor(histogramSegment, borderColor, borderWidth);
    updateSegmentGradient(histogramSegment,
        gradientBounds: histogramSegment.segmentRect?.outerRect,
        gradient: gradient,
        borderGradient: borderGradient);
  }

  @override
  void onLoadingAnimationUpdate() {
    super.onLoadingAnimationUpdate();
    transformValues();
  }

  @override
  List<ChartSegment> contains(Offset position) {
    if (animationController != null && animationController!.isAnimating) {
      return <ChartSegment>[];
    }
    final List<ChartSegment> segmentCollection = <ChartSegment>[];
    int index = 0;
    double delta = 0;
    num? nearPointX;
    num? nearPointY;

    for (final ChartSegment segment in segments) {
      if (segment is HistogramSegment<T, D>) {
        nearPointX ??= segment.series.xValues[0];
        nearPointY ??= segment.series.yAxis!.visibleRange!.minimum;
        final Rect rect = segment.series.paintBounds;

        final num touchXValue =
            segment.series.xAxis!.pixelToPoint(rect, position.dx, position.dy);
        final num touchYValue =
            segment.series.yAxis!.pixelToPoint(rect, position.dx, position.dy);
        final double curX = segment.series.xValues[index].toDouble();
        final double curY = segment.series.yValues[index].toDouble();
        if (delta == touchXValue - curX) {
          if ((touchYValue - curY).abs() > (touchYValue - nearPointY).abs()) {
            segmentCollection.clear();
          }
          segmentCollection.add(segment);
        } else if ((touchXValue - curX).abs() <=
            (touchXValue - nearPointX).abs()) {
          nearPointX = curX;
          nearPointY = curY;
          delta = touchXValue - curX;
          segmentCollection.clear();
          segmentCollection.add(segment);
        }
      }
      index++;
    }
    return segmentCollection;
  }

  @override
  void transformValues() {
    super.transformValues();
    _createNormalDistributionPath();
  }

  void _createNormalDistributionPath() {
    if (!showNormalDistributionCurve ||
        xAxis == null ||
        yAxis == null ||
        segments.isEmpty ||
        xAxis!.visibleRange == null ||
        yAxis!.visibleRange == null) {
      return;
    }

    final int dataCount = _yRawValues.length;
    const num pointsCount = 500;
    final num minimum = xAxis!.visibleRange!.minimum;
    final num maximum = xAxis!.visibleRange!.maximum;
    final num delta = (maximum - minimum) / (pointsCount - 1);

    if (_distributionPath == null) {
      _distributionPath = Path();
    } else {
      _distributionPath!.reset();
    }

    for (int i = 0; i < pointsCount; i++) {
      final num xValue = minimum + i * delta;
      final num yValue =
          exp(-pow(xValue - _mean, 2) / (2 * pow(_deviation, 2))) /
              (_deviation * sqrt(2 * pi));
      final num dx = yValue * _binWidth * dataCount;
      final double x = pointToPixelX(xValue, dx);
      final double y = pointToPixelY(xValue, dx);
      i == 0
          ? _distributionPath!.moveTo(x, y)
          : _distributionPath!.lineTo(x, y);
    }
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    paintSegments(context, offset);
    if (showNormalDistributionCurve && _distributionPath != null) {
      context.canvas.save();
      final Rect clip = clipRect(paintBounds, segmentAnimationFactor,
          isInversed: xAxis!.isInversed, isTransposed: isTransposed);
      context.canvas.clipRect(clip);
      final Paint strokePaint = Paint()
        ..color = curveColor
        ..strokeWidth = curveWidth
        ..style = PaintingStyle.stroke;
      curveDashArray == null
          ? context.canvas.drawPath(_distributionPath!, strokePaint)
          : drawDashes(context.canvas, curveDashArray, strokePaint,
              path: _distributionPath);
    }
    context.canvas.restore();
    paintMarkers(context, offset);
    paintDataLabels(context, offset);
    paintTrendline(context, offset);
  }

  @override
  void dispose() {
    _yRawValues.clear();
    _histogramYValues.clear();
    _histogramXValues.clear();
    _xCount = 0;
    super.dispose();
  }
}

class HistogramSegment<T, D> extends ChartSegment with BarSeriesTrackerMixin {
  late HistogramSeriesRenderer<T, D> series;
  num _binWidth = 0.0;

  RRect? _oldSegmentRect;
  RRect? segmentRect;

  late num x;
  num y = double.nan;
  num bottom = double.nan;

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

    final BorderRadius borderRadius = series._borderRadius;
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
        text: _tooltipText(series.tooltipText(chartPoint)),
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
  TrackballInfo? trackballInfo(Offset position) {
    if (segmentRect != null) {
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      return ChartTrackballInfo<T, D>(
        position: series.isTransposed
            ? series.yAxis!.isInversed
                ? segmentRect!.outerRect.centerLeft
                : segmentRect!.outerRect.centerRight
            : series.yAxis!.isInversed
                ? segmentRect!.outerRect.bottomCenter
                : segmentRect!.outerRect.topCenter,
        point: chartPoint,
        series: series,
        pointIndex: currentSegmentIndex,
        seriesIndex: series.index,
      );
    }
    return null;
  }

  String _tooltipText(String text) {
    if (series.parent == null) {
      return '';
    }

    final num xValue = series.xValues[currentSegmentIndex];
    final int digits = series.parent!.tooltipBehavior!.decimalPlaces;
    final num binWidth = _binWidth / 2;
    final String x1 =
        formatNumericValue(xValue - binWidth, series.xAxis, digits);
    final String x2 =
        formatNumericValue(xValue + binWidth, series.xAxis, digits);
    final String yValue = text.split(':')[1];
    text = '$x1 - $x2 : $yValue';

    return text;
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
    // Draws the tracker bounds.
    super.onPaint(canvas);

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
}
