import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/data_label.dart';
import '../interactions/tooltip.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'chart_series.dart';

/// Renders the scatter series.
///
/// To render a scatter chart, create an instance of [ScatterSeries],
/// and add it to the series collection property of [SfCartesianChart].
///
/// The following properties, such as [color], [opacity], [borderWidth],
/// [borderColor] can be used to customize the appearance of the
/// scatter segment.
@immutable
class ScatterSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of ScatterSeries class.
  const ScatterSeries({
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
    super.name,
    super.color,
    super.markerSettings,
    super.emptyPointSettings,
    super.initialIsVisible,
    super.dataLabelSettings,
    super.enableTooltip = true,
    super.trendlines,
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

  final Color borderColor;

  /// Create the scatter series renderer.
  @override
  ScatterSeriesRenderer<T, D> createRenderer() {
    ScatterSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as ScatterSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return ScatterSeriesRenderer<T, D>();
  }

  @override
  ScatterSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final ScatterSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as ScatterSeriesRenderer<T, D>;
    renderer.borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, ScatterSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.borderColor = borderColor;
  }
}

/// Creates series renderer for scatter series
class ScatterSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with SegmentAnimationMixin<T, D> {
  /// Calling the default constructor of ScatterSeriesRenderer class.
  ScatterSeriesRenderer();

  Color get borderColor => _borderColor;
  Color _borderColor = Colors.transparent;
  set borderColor(Color value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsSegmentsPaint();
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as ScatterSegment<T, D>
      ..series = this
      ..xValue = xValues[index]
      ..yValue = yValues[index]
      ..width = markerSettings.width
      ..height = markerSettings.height
      ..shape = markerSettings.shape
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  ScatterSegment<T, D> createSegment() => ScatterSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      toShapeMarkerType(markerSettings.shape);

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final ScatterSegment<T, D> scatterSegment = segment as ScatterSegment<T, D>;
    updateSegmentColor(scatterSegment, borderColor, borderWidth);
    updateSegmentGradient(scatterSegment,
        gradientBounds: scatterSegment.segmentRect,
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
}

/// Creates the segments for scatter series.
///
/// Generates the scatter series points and has the [calculateSegmentPoints]
/// method overrides to customize the scatter segment point calculation.
///
/// Gets the path and color from the `series`.
class ScatterSegment<T, D> extends ChartSegment {
  late ScatterSeriesRenderer<T, D> series;
  num xValue = double.nan;
  num yValue = double.nan;
  double width = 8.0;
  double height = 8.0;

  Rect? _oldSegmentRect;
  Rect? segmentRect;

  DataMarkerType shape = DataMarkerType.circle;

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
          Rect.lerp(_oldSegmentRect, segmentRect, segmentAnimationFactor);
    } else {
      _oldSegmentRect = segmentRect;
    }
  }

  @override
  void transformValues() {
    if (xValue.isNaN || yValue.isNaN || width.isNaN || height.isNaN) {
      segmentRect = null;
      _oldSegmentRect = null;
      points.clear();
      return;
    }

    points.clear();
    final double pixelX = series.pointToPixelX(xValue, yValue);
    final double pixelY = series.pointToPixelY(xValue, yValue);
    final Offset center = Offset(pixelX, pixelY);
    segmentRect = Rect.fromCenter(center: center, width: width, height: height);
    _oldSegmentRect ??= Rect.fromCircle(center: center, radius: 0.0);
  }

  @override
  bool contains(Offset position) {
    return segmentRect != null && segmentRect!.contains(position);
  }

  CartesianChartPoint<D> _chartPoint() {
    return CartesianChartPoint<D>(
      x: series.xRawValues[currentSegmentIndex],
      xValue: xValue,
      y: yValue,
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (segmentRect != null) {
      pointIndex ??= currentSegmentIndex;
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      return ChartTooltipInfo<T, D>(
        primaryPosition: series.localToGlobal(segmentRect!.topCenter),
        secondaryPosition: series.localToGlobal(segmentRect!.bottomCenter),
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
        markerType: series.markerAt(pointIndex).type,
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
        pointIndex: currentSegmentIndex,
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
    if (segmentRect == null ||
        _oldSegmentRect == null ||
        segmentRect!.isEmpty ||
        shape == DataMarkerType.none) {
      return;
    }

    final Rect? paintRect =
        Rect.lerp(_oldSegmentRect, segmentRect, animationFactor);
    if (paintRect == null || paintRect.isEmpty) {
      return;
    }

    paint(
      canvas: canvas,
      rect: paintRect,
      shapeType: toShapeMarkerType(shape),
      paint: fillPaint,
      borderPaint: strokePaint,
    );
  }

  @override
  void dispose() {
    segmentRect = null;
    _oldSegmentRect = null;
    super.dispose();
  }
}
