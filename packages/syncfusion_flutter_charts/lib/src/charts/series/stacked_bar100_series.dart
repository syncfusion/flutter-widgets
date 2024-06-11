import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../base.dart';
import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/element_widget.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// Renders the 100% stacked bar series.
///
/// A [StackedBar100Series] is a chart series type designed to show the relative
/// percentage of multiple data series in stacked bars,
/// where the total (cumulative) of each stacked bar always equals 100.
///
/// To render a 100% stacked bar chart, create an instance of
/// [StackedBar100Series], and add it to the series collection
/// property of [SfCartesianChart].
///
/// Provides options to customize properties such as [color], [opacity],
/// [borderWidth], [borderColor], [borderRadius] of the
/// stacked bar 100 segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=NCUDBD_ClHo}
@immutable
class StackedBar100Series<T, D> extends StackedSeriesBase<T, D> {
  /// Creating an argument constructor of StackedBar100Series class.
  const StackedBar100Series({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.yValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    this.groupName = '',
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
    super.trendlines,
    this.borderColor = Colors.transparent,
    super.borderWidth,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.dashArray,
    super.opacity,
    super.animationDelay,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    super.initialSelectedDataIndexes,
  });

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
  ///     series: <StackedBar100Series<SalesData, num>>[
  ///       StackedBar100Series<SalesData, num>(
  ///         borderRadius: BorderRadius.all(Radius.circular(5))
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderRadius borderRadius;

  final double spacing;

  final double width;

  /// Specifies the group name.
  final String groupName;

  final Color borderColor;

  @override
  bool transposed() => true;

  /// Create the stacked area series renderer.
  @override
  StackedBar100SeriesRenderer<T, D> createRenderer() {
    StackedBar100SeriesRenderer<T, D> stackedBarSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedBarSeriesRenderer =
          onCreateRenderer!(this) as StackedBar100SeriesRenderer<T, D>;
      return stackedBarSeriesRenderer;
    }
    return StackedBar100SeriesRenderer<T, D>();
  }

  @override
  StackedBar100SeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final StackedBar100SeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as StackedBar100SeriesRenderer<T, D>;
    renderer
      ..spacing = spacing
      ..width = width
      ..groupName = groupName
      ..borderColor = borderColor
      ..borderRadius = borderRadius;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, StackedBar100SeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..spacing = spacing
      ..width = width
      ..groupName = groupName
      ..borderColor = borderColor
      ..borderRadius = borderRadius;
  }
}

/// Creates series renderer for 100% stacked bar series.
class StackedBar100SeriesRenderer<T, D> extends StackedSeriesRenderer<T, D>
    with
        SbsSeriesMixin<T, D>,
        ClusterSeriesMixin,
        SegmentAnimationMixin<T, D>,
        Stacking100SeriesMixin<T, D> {
  Color get borderColor => _borderColor;
  Color _borderColor = Colors.transparent;
  set borderColor(Color value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsSegmentsPaint();
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

  @override
  Offset dataLabelPosition(ChartElementParentData current,
      ChartDataLabelAlignment alignment, Size size) {
    final num x = current.x! + (sbsInfo.maximum + sbsInfo.minimum) / 2;
    final double bottomValue = bottomValues[current.dataPointIndex].toDouble();
    double y = current.y!.toDouble();
    if (alignment == ChartDataLabelAlignment.bottom) {
      y = bottomValue;
    } else if (alignment == ChartDataLabelAlignment.middle) {
      y = (y + bottomValue) / 2;
    }
    return _calculateDataLabelPosition(x, y, alignment, size);
  }

  Offset _calculateDataLabelPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    final EdgeInsets margin = dataLabelSettings.margin;
    double translationX = 0.0;
    double translationY = 0.0;
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.bottom:
        if (isTransposed) {
          translationX = dataLabelPadding;
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = -(dataLabelPadding + size.height + margin.vertical);
        }
        return translateTransform(x, y, translationX, translationY);

      case ChartDataLabelAlignment.top:
        if (isTransposed) {
          translationX = -(dataLabelPadding + size.width + margin.horizontal);
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = dataLabelPadding;
        }
        return translateTransform(x, y, translationX, translationY);

      case ChartDataLabelAlignment.middle:
        final Offset center = translateTransform(x, y);
        if (isTransposed) {
          translationX = -margin.left - size.width / 2;
          translationY = -margin.top;
        } else {
          translationX = -margin.left;
          translationY = -margin.top - size.height / 2;
        }
        return center.translate(translationX, translationY);
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as StackedBar100Segment<T, D>
      ..series = this
      ..x = xValues[index]
      ..top = topValues[index]
      ..bottom = xAxis!.crossesAt ?? bottomValues[index]
      .._actualBottom = bottom
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  StackedBar100Segment<T, D> createSegment() => StackedBar100Segment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      ShapeMarkerType.stackedBar100Series;

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final StackedBar100Segment<T, D> stackedBar100Segment =
        segment as StackedBar100Segment<T, D>;
    updateSegmentColor(stackedBar100Segment, borderColor, borderWidth);
    updateSegmentGradient(stackedBar100Segment,
        gradientBounds: stackedBar100Segment.segmentRect?.outerRect,
        gradient: gradient,
        borderGradient: borderGradient);
  }
}

/// Segment class for 100% stacked bar series.
class StackedBar100Segment<T, D> extends ChartSegment {
  late StackedBar100SeriesRenderer<T, D> series;
  late num x;

  num top = double.nan;
  num bottom = double.nan;
  num _actualBottom = double.nan;

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
    _oldSegmentRect ??= toRRect(
      transformX(left, _actualBottom),
      transformY(left, _actualBottom),
      transformX(right, _actualBottom),
      transformY(right, _actualBottom),
      borderRadius,
    );
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
      cumulative: series.topValues[currentSegmentIndex],
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
            Offset(series.pointToPixelX(x, top), series.pointToPixelY(x, top)),
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
    super.dispose();
  }
}
