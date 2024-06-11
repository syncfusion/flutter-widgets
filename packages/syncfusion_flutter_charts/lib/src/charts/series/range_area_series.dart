import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/marker.dart';
import '../interactions/tooltip.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// Renders the range area series.
///
/// To render a range area chart, create an instance of [RangeAreaSeries] and
/// add to the series collection property of [SfCartesianChart].
/// [RangeAreaSeries] is similar to [AreaSeries] requires two Y values for a
/// point, data should contain high and low values.
///
/// High and low value specify the maximum and minimum range of the point.
///
/// [highValueMapper] - Field in the data source, which is considered as
/// high value for the data points.
/// [lowValueMapper] - Field in the data source, which is considered as
/// low value for the data points.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=uSsKhlRzC2Q}
class RangeAreaSeries<T, D> extends RangeSeriesBase<T, D> {
  /// Creating an argument constructor of RangeAreaSeries class.
  const RangeAreaSeries({
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
    super.xAxisName,
    super.trendlines,
    super.yAxisName,
    super.name,
    super.color,
    super.markerSettings,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.enableTooltip = true,
    super.dashArray,
    super.animationDuration,
    super.borderColor = Colors.transparent,
    super.borderWidth,
    super.gradient,
    super.borderGradient,
    super.selectionBehavior,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.opacity,
    super.animationDelay,
    this.borderDrawMode = RangeAreaBorderMode.all,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
  });

  /// Border type of area series.
  ///
  /// Defaults to `BorderDrawMode.top`.
  ///
  /// Also refer [BorderDrawMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <RangeAreaSeries<SalesData, num>>[
  ///       RangeAreaSeries<SalesData, num>(
  ///         borderDrawMode: RangeAreaBorderMode.all,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final RangeAreaBorderMode borderDrawMode;

  /// Create the range area series renderer.
  @override
  RangeAreaSeriesRenderer<T, D> createRenderer() {
    RangeAreaSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as RangeAreaSeriesRenderer<T, D>;
      // ignore: unnecessary_null_comparison
      return seriesRenderer;
    }
    return RangeAreaSeriesRenderer<T, D>();
  }

  @override
  RangeAreaSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final RangeAreaSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as RangeAreaSeriesRenderer<T, D>;
    renderer
      ..borderDrawMode = borderDrawMode
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, RangeAreaSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..borderDrawMode = borderDrawMode
      ..borderColor = borderColor;
  }
}

/// Creates series renderer for range area series.
class RangeAreaSeriesRenderer<T, D> extends RangeSeriesRendererBase<T, D>
    with ContinuousSeriesMixin<T, D> {
  RangeAreaSeriesRenderer();

  RangeAreaBorderMode get borderDrawMode => _borderDrawMode;
  RangeAreaBorderMode _borderDrawMode = RangeAreaBorderMode.all;
  set borderDrawMode(RangeAreaBorderMode value) {
    if (_borderDrawMode != value) {
      _borderDrawMode = value;
      forceTransformValues = true;
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

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as RangeAreaSegment<T, D>
      ..series = this
      ..currentSegmentIndex = 0
      .._xValues = xValues
      .._lowValues = lowValues
      .._highValues = highValues;
  }

  /// Creates a segment for a data point in the series.
  @override
  RangeAreaSegment<T, D> createSegment() => RangeAreaSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.rangeAreaSeries;

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final RangeAreaSegment<T, D> rangeAreaSegment =
        segment as RangeAreaSegment<T, D>;
    updateSegmentColor(rangeAreaSegment, borderColor, borderWidth);
    updateSegmentGradient(rangeAreaSegment,
        gradientBounds: rangeAreaSegment._fillPath.getBounds(),
        gradient: gradient,
        borderGradient: borderGradient);
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

/// Segment class for  range area series.
class RangeAreaSegment<T, D> extends ChartSegment {
  late RangeAreaSeriesRenderer<T, D> series;
  late List<num> _xValues;
  late List<num> _highValues;
  late List<num> _lowValues;

  final Path _fillPath = Path();
  Path _strokePath = Path();

  final List<int> _drawIndexes = <int>[];
  final List<Offset> _highPoints = <Offset>[];
  final List<Offset> _lowPoints = <Offset>[];
  final List<Offset> _oldHighPoints = <Offset>[];
  final List<Offset> _oldLowPoints = <Offset>[];

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _drawIndexes.clear();
      _oldHighPoints.clear();
      _oldLowPoints.clear();
      return;
    }

    if (series.animationDuration > 0) {
      if (points.isEmpty) {
        _oldHighPoints.clear();
        _oldLowPoints.clear();
        return;
      }

      final int oldPointsLength = _oldHighPoints.length;
      final int newPointsLength = _highPoints.length;
      if (oldPointsLength == newPointsLength) {
        for (int i = 0; i < oldPointsLength; i++) {
          _oldHighPoints[i] = _oldHighPoints[i]
              .lerp(_highPoints[i], segmentAnimationFactor, _highPoints[i].dy)!;
          _oldLowPoints[i] = _oldLowPoints[i]
              .lerp(_lowPoints[i], segmentAnimationFactor, _lowPoints[i].dy)!;
        }
      } else if (oldPointsLength < newPointsLength) {
        for (int i = 0; i < oldPointsLength; i++) {
          _oldHighPoints[i] = _oldHighPoints[i]
              .lerp(_highPoints[i], segmentAnimationFactor, _highPoints[i].dy)!;
          _oldLowPoints[i] = _oldLowPoints[i]
              .lerp(_lowPoints[i], segmentAnimationFactor, _lowPoints[i].dy)!;
        }
        _oldHighPoints.addAll(_highPoints.sublist(oldPointsLength));
        _oldLowPoints.addAll(_lowPoints.sublist(oldPointsLength));
      } else {
        for (int i = 0; i < newPointsLength; i++) {
          _oldHighPoints[i] = _oldHighPoints[i]
              .lerp(_highPoints[i], segmentAnimationFactor, _highPoints[i].dy)!;
          _oldLowPoints[i] = _oldLowPoints[i]
              .lerp(_lowPoints[i], segmentAnimationFactor, _lowPoints[i].dy)!;
        }
        _oldHighPoints.removeRange(newPointsLength, oldPointsLength);
        _oldLowPoints.removeRange(newPointsLength, oldPointsLength);
      }
    } else {
      _oldHighPoints.clear();
      _oldLowPoints.clear();
    }
  }

  @override
  void transformValues() {
    points.clear();
    _drawIndexes.clear();
    _highPoints.clear();
    _lowPoints.clear();
    if (_xValues.isEmpty || _lowValues.isEmpty || _highValues.isEmpty) {
      return;
    }

    _fillPath.reset();
    _strokePath.reset();

    _calculatePoints(_xValues, _highValues, _lowValues);
    _createFillPath(_fillPath, _highPoints, _lowPoints);
  }

  List<Offset> _lerpPoints(List<Offset> oldPoints, List<Offset> newPoints) {
    final List<Offset> lerpPoints = <Offset>[];
    final int oldPointsLength = oldPoints.length;
    final int newPointsLength = newPoints.length;
    if (oldPointsLength == newPointsLength) {
      for (int i = 0; i < oldPointsLength; i++) {
        lerpPoints.add(
            oldPoints[i].lerp(newPoints[i], animationFactor, newPoints[i].dy)!);
      }
    } else if (oldPointsLength < newPointsLength) {
      for (int i = 0; i < oldPointsLength; i++) {
        lerpPoints.add(
            oldPoints[i].lerp(newPoints[i], animationFactor, newPoints[i].dy)!);
      }
      lerpPoints.addAll(newPoints.sublist(oldPointsLength));
    } else {
      for (int i = 0; i < newPointsLength; i++) {
        lerpPoints.add(
            oldPoints[i].lerp(newPoints[i], animationFactor, newPoints[i].dy)!);
      }
    }

    return lerpPoints;
  }

  void _calculatePoints(
      List<num> xValues, List<num> highValues, List<num> lowValues) {
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;

    final bool isDropMode =
        series.emptyPointSettings.mode == EmptyPointMode.drop;
    int length = series.dataCount;
    for (int i = 0; i < length; i++) {
      final num x = xValues[i];
      num topY = highValues[i];
      num bottomY = lowValues[i];
      if (topY.isNaN || bottomY.isNaN) {
        if (isDropMode) {
          continue;
        }
        topY = bottomY = double.nan;
      }

      _drawIndexes.add(i);
      final Offset highPoint = Offset(transformX(x, topY), transformY(x, topY));
      _highPoints.add(highPoint);
      final Offset lowPoint =
          Offset(transformX(x, bottomY), transformY(x, bottomY));
      _lowPoints.add(lowPoint);
      points.add(lowPoint);
      points.add(highPoint);
    }

    length = _oldHighPoints.length;
    if (_highPoints.length > length) {
      _oldHighPoints.addAll(_highPoints.sublist(length));
      _oldLowPoints.addAll(_lowPoints.sublist(length));
    }
  }

  void _computeAreaPath() {
    _fillPath.reset();
    _strokePath.reset();

    if (_highPoints.isEmpty) {
      return;
    }

    final List<Offset> lerpHighPoints =
        _lerpPoints(_oldHighPoints, _highPoints);
    final List<Offset> lerpLowPoints = _lerpPoints(_oldLowPoints, _lowPoints);
    _createFillPath(_fillPath, lerpHighPoints, lerpLowPoints);

    switch (series.borderDrawMode) {
      case RangeAreaBorderMode.all:
        _strokePath = _fillPath;
        break;
      case RangeAreaBorderMode.excludeSides:
        _createStrokePathForExcludeSides(
            _strokePath, lerpHighPoints, lerpLowPoints);
        break;
    }
  }

  Path _createFillPath(
      Path source, List<Offset> highPoints, List<Offset> lowPoints) {
    Path? path;
    final int lastIndex = highPoints.length - 1;
    for (int i = 0; i <= lastIndex; i++) {
      if (i == 0) {
        final Offset lowPoint = lowPoints[i];
        if (lowPoint.isNaN) {
          _createFillPath(
              source, highPoints.sublist(i + 1), lowPoints.sublist(i + 1));

          break;
        } else {
          path = Path();
          path.moveTo(lowPoint.dx, lowPoint.dy);
        }
      }

      final Offset highPoint = highPoints[i];
      if (highPoint.isNaN) {
        for (int j = i - 1; j >= 0; j--) {
          final Offset lowPoint = lowPoints[j];
          path!.lineTo(lowPoint.dx, lowPoint.dy);
        }
        _createFillPath(source, highPoints.sublist(i), lowPoints.sublist(i));
        break;
      } else {
        path!.lineTo(highPoint.dx, highPoint.dy);
        if (i == lastIndex) {
          for (int j = i; j >= 0; j--) {
            final Offset lowPoint = lowPoints[j];
            path.lineTo(lowPoint.dx, lowPoint.dy);
          }
        }
      }
    }

    if (path != null) {
      source.addPath(path, Offset.zero);
    }
    return source;
  }

  Path _createStrokePathForExcludeSides(
      Path source, List<Offset> highPoints, List<Offset> lowPoints) {
    Path? highPath;
    Path? lowPath;
    final int lastIndex = highPoints.length - 1;
    for (int i = 0; i <= lastIndex; i++) {
      final Offset highPoint = highPoints[i];
      final Offset lowPoint = lowPoints[i];
      if (highPoint.isNaN) {
        _createStrokePathForExcludeSides(
            source, highPoints.sublist(i + 1), lowPoints.sublist(i + 1));
        break;
      } else {
        if (i == 0) {
          highPath = Path();
          lowPath = Path();
          highPath.moveTo(highPoint.dx, highPoint.dy);
          lowPath.moveTo(lowPoint.dx, lowPoint.dy);
        } else {
          highPath!.lineTo(highPoint.dx, highPoint.dy);
          lowPath!.lineTo(lowPoint.dx, lowPoint.dy);
        }
      }
    }

    if (highPath != null) {
      source.addPath(highPath, Offset.zero);
    }
    if (lowPath != null) {
      source.addPath(lowPath, Offset.zero);
    }
    return source;
  }

  @override
  bool contains(Offset position) {
    final int length = points.length;
    for (int i = 0; i < length; i++) {
      final Offset a = points[i];
      final Offset b = i + 1 < length ? points[i + 1] : a;
      final Rect rect = Rect.fromPoints(a, b);
      final Rect paddedRect = rect.inflate(tooltipPadding);
      if (paddedRect.contains(position)) {
        return true;
      }
      i++;
    }
    return false;
  }

  CartesianChartPoint<D> _chartPoint(int pointIndex) {
    return CartesianChartPoint<D>(
      x: series.xRawValues[pointIndex],
      xValue: series.xValues[pointIndex],
      high: series.highValues[pointIndex],
      low: series.lowValues[pointIndex],
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (points.isEmpty) {
      return null;
    }

    pointIndex ??= _findNearestChartPointIndex(points, position!);
    if (pointIndex != -1) {
      final Offset position = points[pointIndex];
      if (position.isNaN) {
        return null;
      }

      final int actualPointIndex = _drawIndexes[pointIndex];
      final CartesianChartPoint<D> chartPoint = _chartPoint(actualPointIndex);
      final num x = chartPoint.xValue!;
      final num high = chartPoint.high!;
      final double dx = series.pointToPixelX(x, high);
      final double dy = series.pointToPixelY(x, high);
      final ChartMarker marker = series.markerAt(pointIndex);
      final double markerHeight =
          series.markerSettings.isVisible ? marker.height / 2 : 0;
      final Offset preferredPos = Offset(dx, dy);
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
        pointIndex: actualPointIndex,
        hasMultipleYValues: true,
        markerColors: <Color?>[fillPaint.color],
        markerType: marker.type,
      );
    }
    return null;
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    if (pointIndex != -1 && _highPoints.isNotEmpty) {
      final Offset preferredPos = _highPoints[pointIndex];
      if (preferredPos.isNaN) {
        return null;
      }

      final int actualPointIndex = _drawIndexes[pointIndex];
      final CartesianChartPoint<D> chartPoint = _chartPoint(actualPointIndex);
      return ChartTrackballInfo<T, D>(
        position: preferredPos,
        highXPos: preferredPos.dx,
        highYPos: preferredPos.dy,
        lowYPos: series.pointToPixelY(chartPoint.xValue!, chartPoint.low!),
        point: chartPoint,
        series: series,
        seriesIndex: series.index,
        segmentIndex: currentSegmentIndex,
        pointIndex: actualPointIndex,
        text: series.trackballText(chartPoint, series.name),
        header: series.tooltipHeaderText(chartPoint),
        color: fillPaint.color,
      );
    }
    return null;
  }

  int _findNearestChartPointIndex(List<Offset> points, Offset position) {
    for (int i = 0; i < points.length; i++) {
      final Offset a = points[i];
      final Offset b = i + 1 < points.length ? points[i + 1] : a;
      final Rect rect = Rect.fromPoints(a, b);
      final Rect paddedRect = rect.inflate(tooltipPadding);
      if (paddedRect.contains(position)) {
        return i ~/ 2;
      }
      i++;
    }
    return -1;
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
    _computeAreaPath();

    Paint paint = getFillPaint();
    if (paint.color != Colors.transparent) {
      canvas.drawPath(_fillPath, paint);
    }

    paint = getStrokePaint();
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      drawDashes(canvas, series.dashArray, paint, path: _strokePath);
    }
  }

  @override
  void dispose() {
    _fillPath.reset();
    _strokePath.reset();

    points.clear();
    _drawIndexes.clear();
    _highPoints.clear();
    _lowPoints.clear();
    super.dispose();
  }
}
