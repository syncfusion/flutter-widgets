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

/// Renders the stacked area series.
///
/// A stacked area chart is the extension of a basic area chart to display
/// the evolution of the value of several groups on the same graphic.
///
/// The values of each group are displayed on top of each other.
///
/// To render a stacked area chart, create an instance of [StackedAreaSeries],
/// and add it to the series collection property of [SfCartesianChart].
///
/// Provides options to customize the [color], [opacity], [borderWidth],
/// [borderColor] of the stacked area segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=NCUDBD_ClHo}
@immutable
class StackedAreaSeries<T, D> extends StackedSeriesBase<T, D> {
  /// Creating an argument constructor of StackedAreaSeries class.
  const StackedAreaSeries({
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
    this.groupName = '',
    super.trendlines,
    super.color,
    super.markerSettings,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
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
    super.legendItemText,
    super.opacity,
    super.animationDelay,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    this.borderDrawMode = BorderDrawMode.top,
  });

  /// Border type of stacked area series.
  ///
  /// Defaults to `BorderDrawMode.top`.
  ///
  /// Also refer [BorderDrawMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedAreaSeries<SalesData, num>>[
  ///       StackedAreaSeries<SalesData, num>(
  ///         borderDrawMode: BorderDrawMode.all,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderDrawMode borderDrawMode;

  /// Specifies the group name.
  final String groupName;

  final Color borderColor;

  /// Create the stacked area series renderer.
  @override
  StackedAreaSeriesRenderer<T, D> createRenderer() {
    StackedAreaSeriesRenderer<T, D> stackedAreaSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedAreaSeriesRenderer =
          onCreateRenderer!(this) as StackedAreaSeriesRenderer<T, D>;
      return stackedAreaSeriesRenderer;
    }
    return StackedAreaSeriesRenderer<T, D>();
  }

  @override
  StackedAreaSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final StackedAreaSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as StackedAreaSeriesRenderer<T, D>;
    renderer
      ..groupName = groupName
      ..borderDrawMode = borderDrawMode
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, StackedAreaSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..groupName = groupName
      ..borderDrawMode = borderDrawMode
      ..borderColor = borderColor;
  }
}

/// Creates series renderer for stacked area series.
class StackedAreaSeriesRenderer<T, D> extends StackedSeriesRenderer<T, D>
    with ContinuousSeriesMixin<T, D> {
  BorderDrawMode get borderDrawMode => _borderDrawMode;
  BorderDrawMode _borderDrawMode = BorderDrawMode.top;
  set borderDrawMode(BorderDrawMode value) {
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
    segment as StackedAreaSegment<T, D>
      ..series = this
      ..currentSegmentIndex = 0
      .._xValues = xValues
      .._topValues = topValues
      .._bottomValues = bottomValues
      .._bottom = xAxis!.crossesAt;
  }

  /// Creates a segment for a data point in the series.
  @override
  StackedAreaSegment<T, D> createSegment() => StackedAreaSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      ShapeMarkerType.stackedAreaSeries;

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final StackedAreaSegment<T, D> stackedAreaSegment =
        segment as StackedAreaSegment<T, D>;
    updateSegmentColor(stackedAreaSegment, borderColor, borderWidth);
    updateSegmentGradient(stackedAreaSegment,
        gradientBounds: stackedAreaSegment._fillPath.getBounds(),
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

/// Segment class for stacked area series.
class StackedAreaSegment<T, D> extends ChartSegment {
  late StackedAreaSeriesRenderer<T, D> series;
  late List<num> _xValues;
  late List<num> _topValues;
  late List<num> _bottomValues;
  // ignore: unused_field
  num? _bottom;

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
    if (_xValues.isEmpty || _topValues.isEmpty || _bottomValues.isEmpty) {
      return;
    }

    _fillPath.reset();
    _strokePath.reset();

    switch (series.emptyPointSettings.mode) {
      case EmptyPointMode.gap:
      case EmptyPointMode.zero:
      case EmptyPointMode.average:
        _calculatePoints(_xValues, _topValues, _bottomValues);
        break;

      case EmptyPointMode.drop:
        _calculateDropPoints(_xValues, _topValues, _bottomValues);
        break;
    }
    _createFillPath(_fillPath, _highPoints, _lowPoints);
  }

  void _calculatePoints(
      List<num> xValues, List<num> topValues, List<num> bottomValues) {
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;

    final bool isGap = series.emptyPointSettings.mode == EmptyPointMode.gap;
    final List<num> rawYValues = series.yValues;
    int length = series.dataCount;
    for (int i = 0; i < length; i++) {
      final num x = xValues[i];
      num topY = topValues[i];
      num bottomY = bottomValues[i];

      final num rawY = rawYValues[i];
      if (rawY.isNaN && isGap) {
        topY = bottomY = double.nan;
      }

      _drawIndexes.add(i);
      final Offset highPoint = Offset(transformX(x, topY), transformY(x, topY));
      _highPoints.add(highPoint);

      final Offset lowPoint =
          Offset(transformX(x, bottomY), transformY(x, bottomY));
      _lowPoints.add(lowPoint);

      points.add(highPoint);
    }

    length = _oldHighPoints.length;
    if (points.length > length) {
      _oldHighPoints.addAll(_highPoints.sublist(length));
      _oldLowPoints.addAll(_lowPoints.sublist(length));
    }
  }

  void _calculateDropPoints(
      List<num> xValues, List<num> topValues, List<num> bottomValues) {
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;

    final bool canDrop = series.emptyPointSettings.mode == EmptyPointMode.drop;
    final List<num> rawYValues = series.yValues;
    int length = series.dataCount;
    for (int i = 0; i < length; i++) {
      final num x = xValues[i];
      final num topY = topValues[i];

      final num rawY = rawYValues[i];
      if (rawY.isNaN && canDrop) {
        continue;
      }

      _drawIndexes.add(i);
      final Offset highPoint = Offset(transformX(x, topY), transformY(x, topY));
      _highPoints.add(highPoint);
      points.add(highPoint);
    }

    final List<num> rawPrevSeriesYValues = series.prevSeriesYValues;
    for (int i = 0; i < length; i++) {
      final num x = xValues[i];
      final num bottomY = bottomValues[i];

      final num rawY = rawPrevSeriesYValues[i];
      if (rawY.isNaN && canDrop) {
        continue;
      }

      final Offset lowPoint =
          Offset(transformX(x, bottomY), transformY(x, bottomY));
      _lowPoints.add(lowPoint);
    }

    length = _oldHighPoints.length;
    if (points.length > length) {
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

    switch (series.emptyPointSettings.mode) {
      case EmptyPointMode.gap:
      case EmptyPointMode.zero:
      case EmptyPointMode.average:
        _createFillPath(_fillPath, lerpHighPoints, lerpLowPoints);
        break;

      case EmptyPointMode.drop:
        _createDropFillPath(_fillPath, lerpHighPoints, lerpLowPoints);
        break;
    }

    switch (series.borderDrawMode) {
      case BorderDrawMode.all:
        _strokePath = _fillPath;
        break;

      case BorderDrawMode.top:
        _createTopStrokePath(_strokePath, lerpHighPoints);
        break;

      case BorderDrawMode.excludeBottom:
        switch (series.emptyPointSettings.mode) {
          case EmptyPointMode.gap:
          case EmptyPointMode.zero:
          case EmptyPointMode.average:
            _createExcludeBottomStrokePath(
                _strokePath, lerpHighPoints, lerpLowPoints);
            break;

          case EmptyPointMode.drop:
            _createExcludeBottomStrokePathForDrop(
                _strokePath, lerpHighPoints, lerpLowPoints);
            break;
        }
        break;
    }
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

  Path _createFillPath(
      Path source, List<Offset> highPoints, List<Offset> lowPoints) {
    Path? path;
    final int length = highPoints.length;
    final int lastIndex = length - 1;
    for (int i = 0; i < length; i++) {
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

  Path _createDropFillPath(
      Path source, List<Offset> highPoints, List<Offset> lowPoints) {
    Path? path;
    int length = highPoints.length;
    for (int i = 0; i < length; i++) {
      final Offset highPoint = highPoints[i];
      if (i == 0) {
        path = Path();
        path.moveTo(highPoint.dx, highPoint.dy);
      }
      path!.lineTo(highPoint.dx, highPoint.dy);
    }

    length = lowPoints.length;
    for (int j = length - 1; j >= 0; j--) {
      final Offset lowPoint = lowPoints[j];
      path!.lineTo(lowPoint.dx, lowPoint.dy);
    }

    if (path != null) {
      path.close();
      source.addPath(path, Offset.zero);
    }
    return source;
  }

  Path _createTopStrokePath(Path source, List<Offset> highPoints) {
    Path? path;
    final int length = highPoints.length;
    for (int i = 0; i < length; i++) {
      final Offset highPoint = highPoints[i];
      if (highPoint.isNaN) {
        _createTopStrokePath(source, highPoints.sublist(i + 1));
        break;
      } else {
        if (i == 0) {
          path = Path();
          path.moveTo(highPoint.dx, highPoint.dy);
        } else {
          path!.lineTo(highPoint.dx, highPoint.dy);
        }
      }
    }

    if (path != null) {
      source.addPath(path, Offset.zero);
    }

    return source;
  }

  Path _createExcludeBottomStrokePath(
      Path source, List<Offset> highPoints, List<Offset> lowPoints) {
    Path? path;
    final int length = highPoints.length;
    final int lastIndex = length - 1;
    for (int i = 0; i < length; i++) {
      if (i == 0) {
        final Offset lowPoint = lowPoints[i];
        if (lowPoint.isNaN) {
          _createExcludeBottomStrokePath(
              source, highPoints.sublist(i + 1), lowPoints.sublist(i + 1));
          break;
        } else {
          path = Path();
          path.moveTo(lowPoint.dx, lowPoint.dy);
        }
      }

      final Offset highPoint = highPoints[i];
      if (highPoint.isNaN) {
        final Offset lowPoint = lowPoints[i - 1];
        path!.lineTo(lowPoint.dx, lowPoint.dy);
        _createExcludeBottomStrokePath(
            source, highPoints.sublist(i), lowPoints.sublist(i));
        break;
      } else {
        path!.lineTo(highPoint.dx, highPoint.dy);
        if (i == lastIndex) {
          final Offset lowPoint = lowPoints[i];
          path.lineTo(lowPoint.dx, lowPoint.dy);
        }
      }
    }

    if (path != null) {
      source.addPath(path, Offset.zero);
    }

    return source;
  }

  Path _createExcludeBottomStrokePathForDrop(
      Path source, List<Offset> highPoints, List<Offset> lowPoints) {
    Path? path;
    final int length = highPoints.length;
    for (int i = 0; i < length; i++) {
      if (i == 0) {
        final Offset lowPoint = lowPoints[i];
        path = Path();
        path.moveTo(lowPoint.dx, lowPoint.dy);
      }
    }

    for (int i = 0; i < length; i++) {
      final Offset highPoint = highPoints[i];
      path!.lineTo(highPoint.dx, highPoint.dy);
    }

    final int lastIndex = lowPoints.length - 1;
    final Offset lowPoint = lowPoints[lastIndex];
    path!.lineTo(lowPoint.dx, lowPoint.dy);

    source.addPath(path, Offset.zero);
    return source;
  }

  @override
  bool contains(Offset position) {
    final MarkerSettings marker = series.markerSettings;
    final int length = points.length;
    for (int i = 0; i < length; i++) {
      if (tooltipTouchBounds(points[i], marker.width, marker.height)
          .contains(position)) {
        return true;
      }
    }
    return false;
  }

  CartesianChartPoint<D> _chartPoint(int pointIndex) {
    return CartesianChartPoint<D>(
      x: series.xRawValues[pointIndex],
      xValue: series.xValues[pointIndex],
      y: series.yValues[pointIndex],
      cumulative: series.topValues[pointIndex],
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (points.isEmpty) {
      return null;
    }

    pointDistance = series.markerSettings.width / 2;
    pointIndex ??= _findNearestChartPointIndex(points, position!);
    if (pointIndex != -1) {
      final Offset position = points[pointIndex];
      if (position.isNaN) {
        return null;
      }

      final int actualPointIndex = _drawIndexes[pointIndex];
      final CartesianChartPoint<D> chartPoint = _chartPoint(actualPointIndex);
      final num x = chartPoint.xValue!;
      final num y = series.topValues[actualPointIndex];
      final double dx = series.pointToPixelX(x, y);
      final double dy = series.pointToPixelY(x, y);
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
        markerColors: <Color?>[fillPaint.color],
        markerType: marker.type,
      );
    }
    return null;
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    if (pointIndex != -1 && points.isNotEmpty) {
      final Offset preferredPos = points[pointIndex];
      if (preferredPos.isNaN) {
        return null;
      }

      final int actualPointIndex = _drawIndexes[pointIndex];
      final CartesianChartPoint<D> chartPoint = _chartPoint(actualPointIndex);
      return ChartTrackballInfo<T, D>(
        position: preferredPos,
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
      if ((points[i] - position).distance <= pointDistance) {
        return i;
      }
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
    _drawIndexes.clear();
    _highPoints.clear();
    _lowPoints.clear();
    _oldHighPoints.clear();
    _oldLowPoints.clear();

    _xValues.clear();
    _topValues.clear();
    _bottomValues.clear();
    super.dispose();
  }
}
