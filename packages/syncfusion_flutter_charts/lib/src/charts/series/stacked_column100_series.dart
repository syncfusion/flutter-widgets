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

/// Renders the 100% stacked column series.
///
/// A stacked column 100 is an  chart series type meant to show the relative
/// percentage of multiple data series in stacked columns, where the total
/// (cumulative) of stacked columns always equals 100%.
///
/// To render a 100% stacked column chart, create an instance of
/// [StackedColumn100Series], and add it to the series collection
/// property of [SfCartesianChart].
///
/// Provides options to customize properties such as [color], [opacity],
/// [borderWidth], [borderColor], [borderRadius] of the
/// stacked column 100 segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=NCUDBD_ClHo}
@immutable
class StackedColumn100Series<T, D> extends StackedSeriesBase<T, D> {
  /// Creating an argument constructor of StackedColumn100Series class.
  const StackedColumn100Series({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.yValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    this.width = 0.7,
    super.markerSettings,
    super.trendlines,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.gradient,
    super.borderGradient,
    this.groupName = '',
    this.borderRadius = BorderRadius.zero,
    this.spacing = 0.0,
    super.enableTooltip = true,
    super.animationDuration,
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
  ///     series: <BarSeries<SalesData, num>>[
  ///       BarSeries<SalesData, num>(
  ///         borderRadius: BorderRadius.all(Radius.circular(5))
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderRadius borderRadius;

  final double width;

  final double spacing;

  /// Specifies the group name.
  final String groupName;

  final Color borderColor;

  /// Create the stacked area series renderer.
  @override
  StackedColumn100SeriesRenderer<T, D> createRenderer() {
    StackedColumn100SeriesRenderer<T, D> stackedAreaSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedAreaSeriesRenderer =
          onCreateRenderer!(this) as StackedColumn100SeriesRenderer<T, D>;
      return stackedAreaSeriesRenderer;
    }
    return StackedColumn100SeriesRenderer<T, D>();
  }

  @override
  StackedColumn100SeriesRenderer<T, D> createRenderObject(
      BuildContext context) {
    final StackedColumn100SeriesRenderer<T, D> renderer = super
        .createRenderObject(context) as StackedColumn100SeriesRenderer<T, D>;
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
      BuildContext context, StackedColumn100SeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..spacing = spacing
      ..width = width
      ..groupName = groupName
      ..borderColor = borderColor
      ..borderRadius = borderRadius;
  }
}

/// Creates series renderer for 100% stacked column series.
class StackedColumn100SeriesRenderer<T, D> extends StackedSeriesRenderer<T, D>
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
    segment as StackedColumn100Segment<T, D>
      ..series = this
      ..x = xValues[index]
      ..top = topValues[index]
      ..bottom = xAxis!.crossesAt ?? bottomValues[index]
      .._actualBottom = bottom
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  StackedColumn100Segment<T, D> createSegment() =>
      StackedColumn100Segment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      ShapeMarkerType.stackedColumn100Series;

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final StackedColumn100Segment<T, D> stackedColumn100Segment =
        segment as StackedColumn100Segment<T, D>;
    updateSegmentColor(stackedColumn100Segment, borderColor, borderWidth);
    updateSegmentGradient(stackedColumn100Segment,
        gradientBounds: stackedColumn100Segment.segmentRect?.outerRect,
        gradient: gradient,
        borderGradient: borderGradient);
  }
}

/// Segment class for 100% stacked column series.
class StackedColumn100Segment<T, D> extends ChartSegment {
  late StackedColumn100SeriesRenderer<T, D> series;
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
}
