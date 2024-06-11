import 'dart:math';

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

/// This class renders the area series.
///
/// To render an area chart, create an instance of [AreaSeries], and add it
/// to the series collection property of [SfCartesianChart].
/// The area chart shows the filled area to represent the data, but when there
/// are more than a series, this may hide the other series.
/// To get rid of this, increase or decrease the transparency of the series.
///
/// It provides options for color, opacity, border color, and border width to
/// customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=E_odUnOsBtQ}
@immutable
class AreaSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of AreaSeries class.
  const AreaSeries({
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
    super.markerSettings,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.trendlines,
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
    this.borderDrawMode = BorderDrawMode.top,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
  });

  /// Border type of area series.
  ///
  /// It has three types of [BorderDrawMode],
  ///
  /// * [BorderDrawMode.all] renders border for all the sides of area.
  ///
  /// * [BorderDrawMode.top] renders border only for top side.
  ///
  /// * [BorderDrawMode.excludeBottom] renders border except bottom side.
  ///
  /// Defaults to `BorderDrawMode.top`.
  ///
  /// Also refer [BorderDrawMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <AreaSeries<SalesData, num>>[
  ///       AreaSeries<SalesData, num>(
  ///         borderWidth: 3,
  ///         borderColor: Colors.red,
  ///         borderDrawMode: BorderDrawMode.all,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderDrawMode borderDrawMode;

  final Color borderColor;

  /// Create the area series renderer.
  @override
  AreaSeriesRenderer<T, D> createRenderer() {
    AreaSeriesRenderer<T, D>? renderer;
    if (onCreateRenderer != null) {
      renderer = onCreateRenderer!(this) as AreaSeriesRenderer<T, D>?;
      assert(
          renderer != null,
          'This onCreateRenderer callback function should return value as '
          'extends from ChartSeriesRenderer class and should not be return '
          'value as null');
    }

    return renderer ?? AreaSeriesRenderer<T, D>();
  }

  @override
  AreaSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final AreaSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as AreaSeriesRenderer<T, D>;
    renderer
      ..borderDrawMode = borderDrawMode
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, AreaSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..borderDrawMode = borderDrawMode
      ..borderColor = borderColor;
  }
}

/// Creates series renderer for area series.
class AreaSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with ContinuousSeriesMixin<T, D> {
  /// Calling the default constructor of [AreaSeriesRenderer] class.
  AreaSeriesRenderer();

  Color get borderColor => _borderColor;
  Color _borderColor = Colors.transparent;
  set borderColor(Color value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsSegmentsPaint();
    }
  }

  BorderDrawMode get borderDrawMode => _borderDrawMode;
  BorderDrawMode _borderDrawMode = BorderDrawMode.top;
  set borderDrawMode(BorderDrawMode value) {
    if (_borderDrawMode != value) {
      _borderDrawMode = value;
      forceTransformValues = true;
      markNeedsLayout();
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    final num bottom = xAxis!.crossesAt ?? max(yAxis!.visibleRange!.minimum, 0);
    segment as AreaSegment<T, D>
      ..series = this
      ..currentSegmentIndex = index
      ..xValues = xValues
      ..yValues = yValues
      ..bottom = bottom;
  }

  /// To create area series segment.
  @override
  AreaSegment<T, D> createSegment() => AreaSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.areaSeries;

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final AreaSegment<T, D> areaSegment = segment as AreaSegment<T, D>;
    updateSegmentColor(areaSegment, borderColor, borderWidth);
    updateSegmentGradient(areaSegment,
        gradientBounds: areaSegment._fillPath.getBounds(),
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

/// Creates the segments for area series.
///
/// This generates the area series points and has the [calculateSegmentPoints]
/// override method used to customize the area series segment point calculation.
///
/// It gets the path, stroke color and fill color from the `series`
/// to render the segment.
class AreaSegment<T, D> extends ChartSegment {
  late AreaSeriesRenderer<T, D> series;
  late List<num> xValues;
  late List<num> yValues;
  num bottom = 0.0;

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
              .lerp(_highPoints[i], segmentAnimationFactor, bottom)!;
          _oldLowPoints[i] = _oldLowPoints[i]
              .lerp(_lowPoints[i], segmentAnimationFactor, bottom)!;
        }
      } else if (oldPointsLength < newPointsLength) {
        for (int i = 0; i < oldPointsLength; i++) {
          _oldHighPoints[i] = _oldHighPoints[i]
              .lerp(_highPoints[i], segmentAnimationFactor, bottom)!;
          _oldLowPoints[i] = _oldLowPoints[i]
              .lerp(_lowPoints[i], segmentAnimationFactor, bottom)!;
        }
        _oldHighPoints.addAll(_highPoints.sublist(oldPointsLength));
        _oldLowPoints.addAll(_lowPoints.sublist(oldPointsLength));
      } else {
        for (int i = 0; i < newPointsLength; i++) {
          _oldHighPoints[i] = _oldHighPoints[i]
              .lerp(_highPoints[i], segmentAnimationFactor, bottom)!;
          _oldLowPoints[i] = _oldLowPoints[i]
              .lerp(_lowPoints[i], segmentAnimationFactor, bottom)!;
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
    if (xValues.isEmpty || yValues.isEmpty) {
      return;
    }

    points.clear();
    _drawIndexes.clear();
    _highPoints.clear();
    _lowPoints.clear();

    _fillPath.reset();
    _strokePath.reset();

    _calculatePoints(xValues, yValues);
    // Calculated path here for getting gradient bounds.
    _createFillPath(_fillPath, _highPoints, _lowPoints);
  }

  void _calculatePoints(List<num> xValues, List<num> yValues) {
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;

    final bool canDrop = series.emptyPointSettings.mode == EmptyPointMode.drop;
    int length = series.dataCount;
    for (int i = 0; i < length; i++) {
      final num x = xValues[i];
      final num high = yValues[i];
      if (high.isNaN && canDrop) {
        continue;
      }

      _drawIndexes.add(i);
      final Offset highPoint = Offset(transformX(x, high), transformY(x, high));
      _highPoints.add(highPoint);

      final num low = high.isNaN ? double.nan : bottom;
      final Offset lowPoint = Offset(transformX(x, low), transformY(x, low));
      _lowPoints.add(lowPoint);

      points.add(highPoint);
    }

    length = _oldHighPoints.length;
    if (points.length > length) {
      _oldHighPoints.addAll(_highPoints.sublist(length));
      _oldLowPoints.addAll(_lowPoints.sublist(length));
    }
  }

  List<Offset> _lerpPoints(List<Offset> oldPoints, List<Offset> newPoints) {
    final List<Offset> lerpPoints = <Offset>[];
    final int oldPointsLength = oldPoints.length;
    final int newPointsLength = newPoints.length;
    if (oldPointsLength == newPointsLength) {
      for (int i = 0; i < oldPointsLength; i++) {
        lerpPoints
            .add(oldPoints[i].lerp(newPoints[i], animationFactor, bottom)!);
      }
    } else if (oldPointsLength < newPointsLength) {
      for (int i = 0; i < oldPointsLength; i++) {
        lerpPoints
            .add(oldPoints[i].lerp(newPoints[i], animationFactor, bottom)!);
      }
      lerpPoints.addAll(newPoints.sublist(oldPointsLength));
    } else {
      for (int i = 0; i < newPointsLength; i++) {
        lerpPoints
            .add(oldPoints[i].lerp(newPoints[i], animationFactor, bottom)!);
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
      final ChartMarker marker = series.markerAt(pointIndex);
      final num x = chartPoint.xValue!;
      final num y = chartPoint.y!;
      final double dx = series.pointToPixelX(x, y);
      final double dy = series.pointToPixelY(x, y);
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
      case BorderDrawMode.all:
        _strokePath = _fillPath;
        break;
      case BorderDrawMode.top:
        _createTopStrokePath(_strokePath, lerpHighPoints);
        break;
      case BorderDrawMode.excludeBottom:
        _createExcludeBottomStrokePath(
            _strokePath, lerpHighPoints, lerpLowPoints);
        break;
    }
  }

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
    _oldHighPoints.clear();
    _oldLowPoints.clear();
    super.dispose();
  }
}
