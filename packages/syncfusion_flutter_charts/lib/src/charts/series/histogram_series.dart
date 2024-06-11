import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
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
/// It supports only NumericAxis and LogarithmicAxis alone.
/// It does not support sortingOrder and emptyPointSettings.
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
      ..curveWidth = curveWidth
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
      ..curveWidth = curveWidth
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
class HistogramSeriesRenderer<T, D> extends HistogramSeriesRendererBase<T, D> {
  @override
  void populateDataSource([
    List<ChartValueMapper<T, num>>? yPaths,
    List<List<num>>? chaoticYLists,
    List<List<num>>? yLists,
    List<ChartValueMapper<T, Object>>? fPaths,
    List<List<Object?>>? chaoticFLists,
    List<List<Object?>>? fLists,
  ]) {
    super.populateDataSource(
        yPaths, chaoticYLists, yLists, fPaths, chaoticFLists, fLists);
    populateChartPoints();
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as HistogramSegment<T, D>
      ..series = this
      ..x = xValues[index]
      ..y = yValues[index]
      ..bottom = bottom
      .._binWidth = binWidth
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
      final int dataSourceLength = series.dataSource!.length;
      pointIndex ??= currentSegmentIndex;
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      final TooltipBehavior tooltipBehavior = series.parent!.tooltipBehavior!;
      final int digits = tooltipBehavior.decimalPlaces;
      final TooltipPosition? tooltipPosition = tooltipBehavior.tooltipPosition;
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
        text: _tooltipTextFormat(chartPoint, digits),
        header: tooltipBehavior.shared
            ? _tooltipText(series.tooltipHeaderText(chartPoint), digits)
            : series.name,
        data: series.dataSource![
            pointIndex >= dataSourceLength ? dataSourceLength - 1 : pointIndex],
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

  String _tooltipTextFormat(CartesianChartPoint<D> chartPoint, int digits) {
    if (series.parent == null) {
      return '';
    }

    final TooltipBehavior tooltipBehavior = series.parent!.tooltipBehavior!;
    if (tooltipBehavior.format != null) {
      if (tooltipBehavior.format!.contains('point.x')) {
        return _tooltipText(series.tooltipText(chartPoint), digits);
      } else {
        return series.tooltipText(chartPoint);
      }
    }

    if (tooltipBehavior.shared) {
      return series.tooltipText(chartPoint);
    } else {
      return _tooltipText(series.tooltipText(chartPoint), digits);
    }
  }

  String _tooltipText(String text, int digits) {
    if (series.parent == null) {
      return '';
    }

    final num xValue = series.xValues[currentSegmentIndex];
    final num binWidth = _binWidth / 2;
    final String x1 =
        formatNumericValue(xValue - binWidth, series.xAxis, digits);
    final String x2 =
        formatNumericValue(xValue + binWidth, series.xAxis, digits);
    if (text.contains(':')) {
      // Tooltip text.
      text = '$x1 - $x2 : ${text.split(':')[1]}';
    } else {
      // Tooltip header text.
      text = '$x1 - $x2';
    }

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
}
