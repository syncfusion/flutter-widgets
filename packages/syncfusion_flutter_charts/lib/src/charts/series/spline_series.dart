import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../axis/axis.dart';
import '../axis/datetime_axis.dart';
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

// Creates mixin class and handle the control points of spline types are the
// Monotonic, cardinal, natural, and clamped.
mixin _SplineControlPointMixin<T, D> on CartesianSeriesRenderer<T, D> {
  num _yMax = double.negativeInfinity;

  SplineType get splineType => _splineType;
  SplineType _splineType = SplineType.natural;
  set splineType(SplineType value) {
    if (_splineType != value) {
      _splineType = value;
      canUpdateOrCreateSegments = true;
      markNeedsUpdate();
    }
  }

  double get cardinalSplineTension => _cardinalSplineTension;
  double _cardinalSplineTension = 0.5;
  set cardinalSplineTension(double value) {
    if (_cardinalSplineTension != value) {
      _cardinalSplineTension = clampDouble(value, 0.0, 1.0);
      canUpdateOrCreateSegments = true;
      markNeedsUpdate();
    }
  }

  void _computeMonotonicSpline(
      List<num> yValues, List<num?> yCoefficient, List<num?> dx, int length) {
    final List<num?> slope = List<num?>.filled(length - 1, null);
    final int dxLength = dx.length;
    final int slopeLength = slope.length;
    int index = -1;
    for (int i = 0; i < length - 1; i++) {
      dx[i] = xValues[i + 1] - xValues[i];
      final double slopeValue = (yValues[i + 1] - yValues[i]) / dx[i]!;
      slope[i] = slopeValue == double.infinity ? 0 : slopeValue;
    }

    // Add the first and last coefficient value as Slope[0] and Slope[n - 1].
    if (slope.isEmpty) {
      return;
    }

    slope[0]!.isNaN
        ? yCoefficient[++index] = 0
        : yCoefficient[++index] = slope[0];

    for (int i = 0; i < dxLength - 1; i++) {
      if (slopeLength > i + 1) {
        final num m = slope[i]!, next = slope[i + 1]!;
        if (m * next <= 0) {
          yCoefficient[++index] = 0;
        } else {
          if (dx[i] == 0) {
            yCoefficient[++index] = 0;
          } else {
            final num firstPoint = dx[i]!;
            final num nextPoint = dx[i + 1]!;
            final num interPoint = firstPoint + nextPoint;
            yCoefficient[++index] = 3 *
                interPoint /
                (((interPoint + nextPoint) / m) +
                    ((interPoint + firstPoint) / next));
          }
        }
      }
    }

    slope[slopeLength - 1]!.isNaN
        ? yCoefficient[++index] = 0
        : yCoefficient[++index] = slope[slopeLength - 1];
  }

  void _computeCardinalSpline(
      List<num?> yCoefficient, double cardinalSplineTension) {
    if (dataCount <= 2) {
      for (int i = 0; i < dataCount; i++) {
        yCoefficient[i] = 0;
      }
    } else {
      for (int i = 0; i < dataCount; i++) {
        num? coefficient;
        if (i == 0 && dataCount > 2) {
          final num x1 = xValues[i];
          final num x2 = xValues[i + 2];
          coefficient = cardinalSplineTension * (x2 - x1);
        } else if (i == dataCount - 1 && dataCount - 3 >= 0) {
          final num x1 = xValues[dataCount - 1];
          final num x2 = xValues[dataCount - 3];
          coefficient = cardinalSplineTension * (x1 - x2);
        } else if (i - 1 >= 0 && dataCount > i + 1) {
          final num x1 = xValues[i + 1];
          final num x2 = xValues[i - 1];
          coefficient = cardinalSplineTension * (x1 - x2);
        }

        if (coefficient!.isNaN) {
          coefficient = 0;
        }
        yCoefficient[i] = coefficient;
      }
    }
  }

  void _computeNaturalSpline(
      List<num> yValues, List<num?> yCoefficient, SplineType splineType) {
    const double a = 6;
    num d1, d2, d3, dy1, dy2, p;

    final List<num?> u = List<num?>.filled(dataCount, null);
    if (splineType == SplineType.clamped && dataCount > 1) {
      final num x1 = xValues[0];
      final num x2 = xValues[1];
      final num y1 = yValues[0];
      final num y2 = yValues[1];
      final num xDiff = x2 - x1;
      final num yDiff = y2 - y1;
      final num xEnd = xValues[dataCount - 1];
      final num xPenultimate = xValues[dataCount - 2];
      final num yEnd = yValues[dataCount - 1];
      final num yPenultimate = yValues[dataCount - 2];
      final num d0 = xDiff / yDiff;
      final num dn = (xEnd - xPenultimate) / (yEnd - yPenultimate);

      u[0] = 0.5;
      yCoefficient[0] = (3 * yDiff / xDiff) - (3 * d0);
      yCoefficient[dataCount - 1] =
          (3 * dn) - ((3 * (yEnd - yPenultimate)) / (xEnd - xPenultimate));
      if (yCoefficient[0] == double.infinity || yCoefficient[0]!.isNaN) {
        yCoefficient[0] = 0;
      }

      final num? endCoef = yCoefficient[dataCount - 1];
      if (endCoef == double.infinity || endCoef!.isNaN) {
        yCoefficient[dataCount - 1] = 0;
      }
    } else {
      yCoefficient[0] = u[0] = 0;
      yCoefficient[dataCount - 1] = 0;
    }

    final int segmentCount = dataCount - 1;
    for (int i = 1; i < segmentCount; i++) {
      yCoefficient[i] = 0;
      final num x = xValues[i];
      final num y = yValues[i];
      final num nextX = xValues[i + 1];
      final num nextY = yValues[i + 1];
      final num previousX = xValues[i - 1];
      final num previousY = yValues[i - 1];
      if (!y.isNaN && !nextY.isNaN && !previousY.isNaN) {
        d1 = x - previousX;
        d2 = nextX - previousX;
        d3 = nextX - x;
        dy1 = nextY - y;
        dy2 = y - previousY;
        if (x == previousX || x == nextX) {
          yCoefficient[i] = 0;
          u[i] = 0;
        } else {
          p = 1 / ((d1 * yCoefficient[i - 1]!) + (2 * d2));
          yCoefficient[i] = -p * d3;
          if (u[i - 1] != null) {
            u[i] = p * ((a * ((dy1 / d3) - (dy2 / d1))) - (d1 * u[i - 1]!));
          }
        }
      }
    }

    for (int i = dataCount - 2; i >= 0; i--) {
      final num? yCoef1 = yCoefficient[i];
      final num? yCoef2 = yCoefficient[i + 1];
      if (u[i] != null && yCoef1 != null && yCoef2 != null) {
        yCoefficient[i] = (yCoef1 * yCoef2) + u[i]!;
      }
    }
  }

  /// Calculate the datetime interval for cardinal spline type.
  num _cardinalSplineDateTimeInterval() {
    DateTimeIntervalType visibleIntervalType = DateTimeIntervalType.auto;
    if (xAxis is RenderDateTimeAxis) {
      visibleIntervalType = (xAxis! as RenderDateTimeAxis).visibleIntervalType;
    }

    switch (visibleIntervalType) {
      case DateTimeIntervalType.years:
        return 365 * 24 * 60 * 60 * 1000;
      case DateTimeIntervalType.months:
        return 30 * 24 * 60 * 60 * 1000;
      case DateTimeIntervalType.days:
        return 24 * 60 * 60 * 1000;
      case DateTimeIntervalType.hours:
        return 60 * 60 * 1000;
      case DateTimeIntervalType.minutes:
        return 60 * 1000;
      case DateTimeIntervalType.seconds:
        return 1000;
      case DateTimeIntervalType.auto:
      case DateTimeIntervalType.milliseconds:
        return 30 * 24 * 60 * 60 * 1000;
    }
  }

  // This method common for SplineAreaSeries and SplineRangeAreaSeries.
  // Not support for SplineSeries.
  void _buildSplineAreaSegment(
    List<num?> yCoefficients,
    num x1,
    num y1,
    int nextIndex,
    num x2,
    num y2,
    List<num> splineYValues,
    List<num> startControlXPoints,
    List<num> startControlYPoints,
    List<num> endControlXPoints,
    List<num> endControlYPoints,
  ) {
    num controlX1 = 0;
    num controlY1 = 0;
    num controlX2 = 0;
    num controlY2 = 0;
    final int segmentCount = dataCount - 1;
    for (int i = 0; i < segmentCount; i++) {
      switch (splineType) {
        case SplineType.natural:
        case SplineType.clamped:
          _computeNaturalSpline(splineYValues, yCoefficients, splineType);

          final num yCoef1 = yCoefficients[i]!;
          num yCoef2 = yCoef1;
          x1 = xValues[i];
          y1 = splineYValues[i];
          nextIndex = i + 1;
          if (nextIndex < dataCount) {
            x2 = xValues[nextIndex];
            y2 = splineYValues[nextIndex];
            yCoef2 = yCoefficients[nextIndex]!;
          }

          const num oneThird = 1 / 3.0;
          final num deltaXSquared = pow(x2.toDouble() - x1.toDouble(), 2);

          final num dx1 = (2 * x1) + x2;
          final num dx2 = x1 + (2 * x2);
          final num dy1 = (2 * y1) + y2;
          final num dy2 = y1 + (2 * y2);

          controlX1 = dx1 * oneThird;
          controlY1 = oneThird *
              (dy1 - (oneThird * deltaXSquared * (yCoef1 + (0.5 * yCoef2))));
          controlX2 = dx2 * oneThird;
          controlY2 = oneThird *
              (dy2 - (oneThird * deltaXSquared * ((0.5 * yCoef1) + yCoef2)));
          _yMax = max(_yMax, max(controlY1, max(controlY2, max(y1, y2))));
          break;

        case SplineType.monotonic:
          final List<num?> dx = List<num?>.filled(dataCount, 0);
          _computeMonotonicSpline(splineYValues, yCoefficients, dx, dataCount);

          final num yCoef1 = yCoefficients[i]!;
          num yCoef2 = yCoef1;
          x1 = xValues[i];
          y1 = splineYValues[i];
          nextIndex = i + 1;
          if (nextIndex < dataCount) {
            x2 = xValues[nextIndex];
            y2 = splineYValues[nextIndex];
            yCoef2 = yCoefficients[nextIndex]!;
          }

          final num value = dx[i]! / 3;
          controlX1 = x1 + value;
          controlY1 = y1 + (yCoef1 * value);
          controlX2 = x2 - value;
          controlY2 = y2 - (yCoef2 * value);
          _yMax = max(_yMax, max(controlY1, max(controlY2, max(y1, y2))));
          break;

        case SplineType.cardinal:
          _computeCardinalSpline(yCoefficients, cardinalSplineTension);

          final num coefficientY = yCoefficients[i]!;
          num coefficientY1 = coefficientY;
          num yCoefficient = coefficientY;
          num y1Coefficient = coefficientY1;
          x1 = xValues[i];
          y1 = splineYValues[i];

          nextIndex = i + 1;
          if (nextIndex < dataCount) {
            coefficientY1 = yCoefficients[nextIndex]!;
            x2 = xValues[nextIndex];
            y2 = splineYValues[nextIndex];
          }

          if (xAxis is RenderDateTimeAxis) {
            yCoefficient = coefficientY / _cardinalSplineDateTimeInterval();
            y1Coefficient = coefficientY1 / _cardinalSplineDateTimeInterval();
          }

          controlX1 = x1 + (coefficientY / 3);
          controlY1 = y1 + (yCoefficient / 3);
          controlX2 = x2 - (coefficientY1 / 3);
          controlY2 = y2 - (y1Coefficient / 3);
          _yMax = max(_yMax, max(controlY1, max(controlY2, max(y1, y2))));
          break;
      }
      startControlXPoints.add(controlX1);
      startControlYPoints.add(controlY1);
      endControlXPoints.add(controlX2);
      endControlYPoints.add(controlY2);
    }
  }
}

/// Renders the spline series.
///
/// The spline chart draws a curved line between the points in a data series.
/// To render a spline chart, create an instance of [SplineSeries],
/// and add it to the series collection property of [SfCartesianChart].
///
/// Provides options to customize the color, opacity and width of the
/// spline series segments.
@immutable
class SplineSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of SplineSeries class.
  const SplineSeries({
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
    double width = 2,
    super.markerSettings,
    this.splineType = SplineType.natural,
    this.cardinalSplineTension = 0.5,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.trendlines,
    super.enableTooltip = true,
    super.dashArray,
    super.animationDuration,
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
  }) : super(borderWidth: width);

  /// Type of the spline curve. Various type of curves such as clamped,
  /// cardinal, monotonic, and natural can be rendered between the data points.
  ///
  /// Defaults to `SplineType.natural`.
  ///
  /// Also refer [SplineType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         splineType: SplineType.monotonic,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final SplineType splineType;

  /// Line tension of the cardinal spline. The value ranges from 0 to 1.
  ///
  /// Defaults to `0.5`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         cardinalSplineTension: 0.4,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double cardinalSplineTension;

  /// Create the spline area series renderer.
  @override
  SplineSeriesRenderer<T, D> createRenderer() {
    SplineSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as SplineSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return SplineSeriesRenderer<T, D>();
  }

  @override
  SplineSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final SplineSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as SplineSeriesRenderer<T, D>;
    renderer
      ..splineType = splineType
      ..cardinalSplineTension = cardinalSplineTension;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, SplineSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..splineType = splineType
      ..cardinalSplineTension = cardinalSplineTension;
  }
}

/// Creates series renderer for spline series.
class SplineSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with _SplineControlPointMixin<T, D>, LineSeriesMixin<T, D> {
  /// Calling the default constructor of SplineSeriesRenderer class.
  SplineSeriesRenderer();

  @override
  DoubleRange range(RenderChartAxis axis) {
    // TODO(VijayakumarM): Update [yMax].
    // yMax = _yMax;
    return super.range(axis);
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    final List<num?> yCoefficients = List<num?>.filled(dataCount, 0);
    _yMax = double.negativeInfinity;

    num x1 = xValues[index];
    num y1 = nonEmptyYValues[index];
    num x2 = double.nan;
    num y2 = double.nan;

    int nextIndex = index + 1;
    if (nextIndex < dataCount) {
      x2 = xValues[nextIndex];
      y2 = nonEmptyYValues[nextIndex];
    }

    num controlX1 = 0;
    num controlY1 = 0;
    num controlX2 = 0;
    num controlY2 = 0;

    switch (splineType) {
      case SplineType.natural:
      case SplineType.clamped:
        _computeNaturalSpline(nonEmptyYValues, yCoefficients, splineType);

        const num oneThird = 1 / 3.0;
        final num deltaXSquared = pow(x2.toDouble() - x1.toDouble(), 2);
        final num yCoef1 = yCoefficients[index]!;
        num yCoef2 = yCoef1;
        if (nextIndex < dataCount) {
          yCoef2 = yCoefficients[nextIndex]!;
        }

        final num dx1 = (2 * x1) + x2;
        final num dx2 = x1 + (2 * x2);
        final num dy1 = (2 * y1) + y2;
        final num dy2 = y1 + (2 * y2);

        controlX1 = dx1 * oneThird;
        controlY1 = oneThird *
            (dy1 - (oneThird * deltaXSquared * (yCoef1 + (0.5 * yCoef2))));
        controlX2 = dx2 * oneThird;
        controlY2 = oneThird *
            (dy2 - (oneThird * deltaXSquared * ((0.5 * yCoef1) + yCoef2)));
        _yMax = max(_yMax, max(controlY1, max(controlY2, max(y1, y2))));
        break;

      case SplineType.monotonic:
        final List<num?> dx = List<num?>.filled(dataCount, 0);
        _computeMonotonicSpline(nonEmptyYValues, yCoefficients, dx, dataCount);

        final num yCoef1 = yCoefficients[index]!;
        num yCoef2 = yCoef1;
        if (nextIndex < dataCount) {
          yCoef2 = yCoefficients[nextIndex]!;
        }

        final num value = dx[index]! / 3;
        controlX1 = x1 + value;
        controlY1 = y1 + (yCoef1 * value);
        controlX2 = x2 - value;
        controlY2 = y2 - (yCoef2 * value);
        _yMax = max(_yMax, max(controlY1, max(controlY2, max(y1, y2))));
        break;

      case SplineType.cardinal:
        _computeCardinalSpline(yCoefficients, cardinalSplineTension);

        final num coefficientY = yCoefficients[index]!;
        num coefficientY1 = coefficientY;
        num yCoefficient = coefficientY;
        num y1Coefficient = coefficientY1;
        if (nextIndex < dataCount) {
          coefficientY1 = yCoefficients[nextIndex]!;
        }

        if (xAxis is RenderDateTimeAxis) {
          yCoefficient = coefficientY / _cardinalSplineDateTimeInterval();
          y1Coefficient = coefficientY1 / _cardinalSplineDateTimeInterval();
        }

        controlX1 = x1 + (coefficientY / 3);
        controlY1 = y1 + (yCoefficient / 3);
        controlX2 = x2 - (coefficientY1 / 3);
        controlY2 = y2 - (y1Coefficient / 3);
        _yMax = max(_yMax, max(controlY1, max(controlY2, max(y1, y2))));
        break;
    }

    x1 = xValues[index];
    y1 = yValues[index];
    nextIndex = nextIndexConsideringEmptyPointMode(
        index, emptyPointSettings.mode, yValues, dataCount);
    if (nextIndex != -1) {
      x2 = xValues[nextIndex];
      y2 = yValues[nextIndex];
    }

    segment as SplineSegment<T, D>
      ..series = this
      ..currentSegmentIndex = index
      .._x1 = x1
      .._y1 = y1
      .._controlX1 = controlX1
      .._controlY1 = controlY1
      .._controlX2 = controlX2
      .._controlY2 = controlY2
      .._x2 = x2
      .._y2 = y2
      ..isEmpty = isEmpty(index);
  }

  /// Creates a segment for a data point in the series.
  @override
  SplineSegment<T, D> createSegment() => SplineSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      dashArray != null && !dashArray!.every((double value) => value <= 0)
          ? ShapeMarkerType.splineSeriesWithDashArray
          : ShapeMarkerType.splineSeries;

  @override
  double legendIconBorderWidth() {
    return 1.5;
  }

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    updateSegmentColor(segment, color, borderWidth, isLineType: true);
    updateSegmentGradient(segment);
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    final Rect clip = clipRect(paintBounds, animationFactor,
        isInversed: xAxis!.isInversed, isTransposed: isTransposed);
    context.canvas.save();
    context.canvas.clipRect(clip);
    paintSegments(context, offset);
    context.canvas.restore();
    paintMarkers(context, offset);
    paintDataLabels(context, offset);
    paintTrendline(context, offset);
  }
}

/// Creates the segments for spline series.
///
/// Generates the spline series points and has the [calculateSegmentPoints]
/// method overrides to customize the spline segment point calculation.
///
/// Gets the path and color from the `series`.
class SplineSegment<T, D> extends ChartSegment {
  late SplineSeriesRenderer<T, D> series;
  late num _x1;
  late num _y1;
  late num _x2;
  late num _y2;

  late num _controlX1;
  late num _controlY1;
  late num _controlX2;
  late num _controlY2;

  double? startControlX;
  double? startControlY;
  double? endControlX;
  double? endControlY;

  double? _oldStartControlX;
  double? _oldStartControlY;
  double? _oldEndControlX;
  double? _oldEndControlY;

  final List<Offset> _oldPoints = <Offset>[];

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _oldStartControlX = null;
      _oldStartControlY = null;
      _oldEndControlX = null;
      _oldEndControlY = null;
      _oldPoints.clear();
      return;
    }

    if (series.animationDuration > 0) {
      if (points.isEmpty) {
        _oldPoints.clear();
        return;
      }

      final int newPointsLength = points.length;
      final int oldPointsLength = _oldPoints.length;
      if (oldPointsLength == newPointsLength) {
        for (int i = 0; i < newPointsLength; i++) {
          _oldPoints[i] =
              Offset.lerp(_oldPoints[i], points[i], segmentAnimationFactor)!;
        }
      } else {
        final int minLength = min(oldPointsLength, newPointsLength);
        for (int i = 0; i < minLength; i++) {
          _oldPoints[i] =
              Offset.lerp(_oldPoints[i], points[i], segmentAnimationFactor)!;
        }

        if (newPointsLength > oldPointsLength) {
          _oldPoints.addAll(points.sublist(oldPointsLength));
        } else {
          _oldPoints.removeRange(minLength, oldPointsLength);
        }
      }

      _oldStartControlX =
          lerpDouble(_oldStartControlX, startControlX, segmentAnimationFactor);
      _oldStartControlY =
          lerpDouble(_oldStartControlY, startControlY, segmentAnimationFactor);
      _oldEndControlX =
          lerpDouble(_oldEndControlX, endControlX, segmentAnimationFactor);
      _oldEndControlY =
          lerpDouble(_oldEndControlY, endControlY, segmentAnimationFactor);
    } else {
      _oldPoints.clear();
    }
  }

  @override
  void transformValues() {
    points.clear();

    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;

    if (!_x1.isNaN && !_y1.isNaN) {
      points.add(Offset(transformX(_x1, _y1), transformY(_x1, _y1)));
    }

    if (!_x2.isNaN && !_y2.isNaN) {
      startControlX = transformX(_controlX1, _controlY1);
      startControlY = transformY(_controlX1, _controlY1);
      endControlX = transformX(_controlX2, _controlY2);
      endControlY = transformY(_controlX2, _controlY2);
      points.add(Offset(transformX(_x2, _y2), transformY(_x2, _y2)));
    }

    if (points.length > _oldPoints.length) {
      _oldPoints.addAll(points.sublist(_oldPoints.length));
    }
    _oldStartControlX ??= startControlX;
    _oldStartControlY ??= startControlY;
    _oldEndControlX ??= endControlX;
    _oldEndControlY ??= endControlY;
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

  int _nearestPointIndex(List<Offset> points, Offset position) {
    for (int i = 0; i < points.length; i++) {
      if ((points[i] - position).distance <= pointDistance) {
        return i;
      }
    }
    return -1;
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
    final int nearestPointIndex =
        position == null ? 0 : _nearestPointIndex(points, position);
    if (nearestPointIndex != -1) {
      pointIndex ??= (position == null || nearestPointIndex == 0
          ? currentSegmentIndex
          : currentSegmentIndex + 1);
      CartesianChartPoint<D> chartPoint = _chartPoint(pointIndex);
      List<Color?> markerColors = <Color?>[fillPaint.color];
      if (chartPoint.y != null && chartPoint.y!.isNaN) {
        pointIndex += 1;
        chartPoint = _chartPoint(pointIndex);
        markerColors = <Color?>[series.segments[pointIndex].fillPaint.color];
      }
      final ChartMarker marker = series.markerAt(pointIndex);
      final double markerHeight =
          series.markerSettings.isVisible ? marker.height / 2 : 0;
      final Offset preferredPos = points[nearestPointIndex];
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
        markerColors: markerColors,
        markerType: marker.type,
      );
    }
    return null;
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    final CartesianChartPoint<D> chartPoint = _chartPoint(pointIndex);
    if (pointIndex == -1 ||
        points.isEmpty ||
        (chartPoint.y != null && chartPoint.y!.isNaN)) {
      return null;
    }

    return ChartTrackballInfo<T, D>(
      position: points[0],
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

  /// Gets the color of the series.
  @override
  Paint getFillPaint() => strokePaint;

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() => strokePaint;

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (points.isEmpty || points.length != 2) {
      return;
    }

    final Offset? start =
        Offset.lerp(_oldPoints[0], points[0], animationFactor);
    final Offset? end = Offset.lerp(_oldPoints[1], points[1], animationFactor);
    final double controlX1 =
        lerpDouble(_oldStartControlX, startControlX, animationFactor)!;
    final double controlY1 =
        lerpDouble(_oldStartControlY, startControlY, animationFactor)!;
    final double controlX2 =
        lerpDouble(_oldEndControlX, endControlX, animationFactor)!;
    final double controlY2 =
        lerpDouble(_oldEndControlY, endControlY, animationFactor)!;

    if (start != null && end != null) {
      final Path path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(controlX1, controlY1, controlX2, controlY2, end.dx, end.dy);
      final Paint paint = getStrokePaint();
      if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
        drawDashes(canvas, series.dashArray, paint, path: path);
      }
    }
  }

  @override
  void dispose() {
    points.clear();
    _oldPoints.clear();
    super.dispose();
  }
}

/// Renders the spline are series.
///
/// To render a spline area chart, create an instance of [SplineAreaSeries],
/// and add it to the series collection property of [SfCartesianChart].
/// Properties such as [color], [opacity], [width] are used to customize the
/// appearance of spline area chart.
@immutable
class SplineAreaSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of SplineAreaSeries class.
  const SplineAreaSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.yValueMapper,
    super.sortFieldValueMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    super.markerSettings,
    this.splineType = SplineType.natural,
    super.trendlines,
    this.cardinalSplineTension = 0.5,
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

  /// Border type of area series.
  ///
  /// Defaults to `BorderDrawMode.top`.
  ///
  /// Also refer [BorderDrawMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineAreaSeries<SalesData, num>>[
  ///       SplineAreaSeries<SalesData, num>(
  ///         borderColor: Colors.red,
  ///         borderWidth: 3,
  ///         borderDrawMode: BorderDrawMode.all,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderDrawMode borderDrawMode;

  /// Type of the spline curve. Various type of curves such as clamped,
  /// cardinal, monotonic, and natural can be rendered between the data points.
  ///
  /// Defaults to `SplineType.natural`.
  ///
  /// Also refer [SplineType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///      series: <SplineAreaSeries<SalesData, num>>[
  ///        SplineAreaSeries<SalesData, num>(
  ///          splineType: SplineType.monotonic,
  ///        ),
  ///      ],
  ///   );
  /// }
  /// ```
  final SplineType splineType;

  /// Line tension of the cardinal spline. The value ranges from 0 to 1.
  ///
  /// Defaults to `0.5`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineAreaSeries<SalesData, num>>[
  ///       SplineAreaSeries<SalesData, num>(
  ///         cardinalSplineTension: 0.4,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double cardinalSplineTension;

  final Color borderColor;

  /// Create the spline area series renderer.
  @override
  SplineAreaSeriesRenderer<T, D> createRenderer() {
    SplineAreaSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer =
          onCreateRenderer!(this) as SplineAreaSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return SplineAreaSeriesRenderer<T, D>();
  }

  @override
  SplineAreaSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final SplineAreaSeriesRenderer<T, D> renderer =
        super.createRenderObject(context) as SplineAreaSeriesRenderer<T, D>;
    renderer
      ..borderDrawMode = borderDrawMode
      ..splineType = splineType
      ..cardinalSplineTension = cardinalSplineTension
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant SplineAreaSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..borderDrawMode = borderDrawMode
      ..splineType = splineType
      ..cardinalSplineTension = cardinalSplineTension
      ..borderColor = borderColor;
  }
}

/// Creates series renderer for spline area series.
class SplineAreaSeriesRenderer<T, D> extends XyDataSeriesRenderer<T, D>
    with _SplineControlPointMixin<T, D>, ContinuousSeriesMixin<T, D> {
  /// Calling the default constructor of SplineAreaSeriesRenderer class.
  SplineAreaSeriesRenderer();

  BorderDrawMode get borderDrawMode => _borderDrawMode;
  BorderDrawMode _borderDrawMode = BorderDrawMode.top;
  set borderDrawMode(BorderDrawMode value) {
    if (_borderDrawMode != value) {
      _borderDrawMode = value;
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

  final List<num> _startControlXValues = <num>[];
  final List<num> _startControlYValues = <num>[];
  final List<num> _endControlXValues = <num>[];
  final List<num> _endControlYValues = <num>[];

  @override
  void computeNonEmptyYValues() {
    nonEmptyYValues.clear();
    if (emptyPointSettings.mode == EmptyPointMode.drop) {
      final List<num> yValuesCopy = <num>[...yValues];
      nonEmptyYValues = yValuesCopy;
      for (int i = 0; i < dataCount; i++) {
        if (yValues[i].isNaN) {
          nonEmptyYValues[i] = 0;
        }
      }
    } else if (emptyPointSettings.mode == EmptyPointMode.gap) {
      super.computeNonEmptyYValues();
    } else {
      final List<num> yValuesCopy = <num>[...yValues];
      nonEmptyYValues = yValuesCopy;
    }
  }

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);

    _startControlXValues.clear();
    _startControlYValues.clear();
    _endControlXValues.clear();
    _endControlYValues.clear();

    final List<num?> yCoefficients = List<num?>.filled(dataCount, 0);
    _yMax = double.negativeInfinity;

    final num x1 = xValues[index];
    final num y1 = nonEmptyYValues[index];
    num x2 = double.nan;
    num y2 = double.nan;

    final int nextIndex = index + 1;
    if (nextIndex < dataCount) {
      x2 = xValues[nextIndex];
      y2 = nonEmptyYValues[nextIndex];
    }

    _buildSplineAreaSegment(
      yCoefficients,
      x1,
      y1,
      nextIndex,
      x2,
      y2,
      nonEmptyYValues,
      _startControlXValues,
      _startControlYValues,
      _endControlXValues,
      _endControlYValues,
    );

    final num bottom = xAxis!.crossesAt ?? max(yAxis!.visibleRange!.minimum, 0);
    segment as SplineAreaSegment<T, D>
      ..series = this
      ..currentSegmentIndex = index
      .._xValues = xValues
      .._yValues = yValues
      .._startControlHighXValues = _startControlXValues
      .._startControlHighYValues = _startControlYValues
      .._endControlHighXValues = _endControlXValues
      .._endControlHighYValues = _endControlYValues
      ..bottom = bottom;
  }

  /// Creates a segment for a data point in the series.
  @override
  SplineAreaSegment<T, D> createSegment() => SplineAreaSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.splineAreaSeries;

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final SplineAreaSegment<T, D> splineAreaSegment =
        segment as SplineAreaSegment<T, D>;
    updateSegmentColor(splineAreaSegment, borderColor, borderWidth);
    updateSegmentGradient(splineAreaSegment,
        gradientBounds: splineAreaSegment._fillPath.getBounds(),
        gradient: gradient,
        borderGradient: borderGradient);
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    final Rect clip = clipRect(paintBounds, animationFactor,
        isInversed: xAxis!.isInversed, isTransposed: isTransposed);
    context.canvas.clipRect(clip);
    super.onPaint(context, offset);
  }

  @override
  void dispose() {
    _startControlXValues.clear();
    _startControlYValues.clear();
    _endControlXValues.clear();
    _endControlYValues.clear();
    super.dispose();
  }
}

/// Creates the segments for spline area series.
///
/// Generates the spline area series points and has the [calculateSegmentPoints]
/// method overridden to customize the spline area segment point calculation.
///
/// Gets the path and color from the `series`.
class SplineAreaSegment<T, D> extends ChartSegment {
  late SplineAreaSeriesRenderer<T, D> series;
  late num bottom;
  late List<num> _xValues;
  late List<num> _yValues;
  late List<num> _startControlHighXValues;
  late List<num> _startControlHighYValues;
  late List<num> _endControlHighXValues;
  late List<num> _endControlHighYValues;

  final Path _fillPath = Path();
  Path _strokePath = Path();

  final List<int> _drawIndexes = <int>[];
  final List<Offset> _highPoints = <Offset>[];
  final List<Offset> _lowPoints = <Offset>[];
  final List<Offset> _startControlHighPoints = <Offset>[];
  final List<Offset> _endControlHighPoints = <Offset>[];

  final List<Offset> _oldHighPoints = <Offset>[];
  final List<Offset> _oldLowPoints = <Offset>[];
  final List<Offset> _oldStartControlHighPoints = <Offset>[];
  final List<Offset> _oldEndControlHighPoints = <Offset>[];

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _drawIndexes.clear();
      _oldHighPoints.clear();
      _oldLowPoints.clear();
      _oldStartControlHighPoints.clear();
      _oldEndControlHighPoints.clear();
      return;
    }

    if (series.animationDuration > 0) {
      if (points.isEmpty) {
        _oldHighPoints.clear();
        _oldLowPoints.clear();
        _oldStartControlHighPoints.clear();
        _oldEndControlHighPoints.clear();
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

      final int oldControlPointsLength = _oldStartControlHighPoints.length;
      final int newControlPointsLength = _startControlHighPoints.length;
      if (oldControlPointsLength == newControlPointsLength) {
        for (int i = 0; i < oldControlPointsLength; i++) {
          _oldStartControlHighPoints[i] = _oldStartControlHighPoints[i].lerp(
              _startControlHighPoints[i], segmentAnimationFactor, bottom)!;
          _oldEndControlHighPoints[i] = _oldEndControlHighPoints[i]
              .lerp(_endControlHighPoints[i], segmentAnimationFactor, bottom)!;
        }
      } else if (oldControlPointsLength < newControlPointsLength) {
        for (int i = 0; i < oldControlPointsLength; i++) {
          _oldStartControlHighPoints[i] = _oldStartControlHighPoints[i].lerp(
              _startControlHighPoints[i], segmentAnimationFactor, bottom)!;
          _oldEndControlHighPoints[i] = _oldEndControlHighPoints[i]
              .lerp(_endControlHighPoints[i], segmentAnimationFactor, bottom)!;
        }
        _oldStartControlHighPoints
            .addAll(_startControlHighPoints.sublist(oldControlPointsLength));
        _oldEndControlHighPoints
            .addAll(_endControlHighPoints.sublist(oldControlPointsLength));
      } else {
        for (int i = 0; i < newControlPointsLength; i++) {
          _oldStartControlHighPoints[i] = _oldStartControlHighPoints[i].lerp(
              _startControlHighPoints[i], segmentAnimationFactor, bottom)!;
          _oldEndControlHighPoints[i] = _oldEndControlHighPoints[i]
              .lerp(_endControlHighPoints[i], segmentAnimationFactor, bottom)!;
        }
        _oldStartControlHighPoints.removeRange(
            newControlPointsLength, oldControlPointsLength);
        _oldEndControlHighPoints.removeRange(
            newControlPointsLength, oldControlPointsLength);
      }
    } else {
      _oldHighPoints.clear();
      _oldLowPoints.clear();
      _oldStartControlHighPoints.clear();
      _oldEndControlHighPoints.clear();
    }
  }

  @override
  void transformValues() {
    points.clear();
    _drawIndexes.clear();
    _highPoints.clear();
    _lowPoints.clear();
    _startControlHighPoints.clear();
    _endControlHighPoints.clear();

    _fillPath.reset();
    _strokePath.reset();
    if (_xValues.isEmpty || _yValues.isEmpty) {
      return;
    }

    _calculatePoints(_xValues, _yValues);
    _createFillPath(_fillPath, _highPoints, _lowPoints, _startControlHighPoints,
        _endControlHighPoints);
  }

  void _calculatePoints(List<num> xValues, List<num> yValues) {
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;

    final bool canDrop = series.emptyPointSettings.mode == EmptyPointMode.drop;
    int length = series.dataCount;
    final int controlPointsLength = _startControlHighXValues.length;
    for (int i = 0; i < length; i++) {
      final num x = xValues[i];
      final num high = yValues[i];
      if (high.isNaN && canDrop) {
        continue;
      }

      _drawIndexes.add(i);
      final Offset highPoint = Offset(transformX(x, high), transformY(x, high));
      _highPoints.add(highPoint);
      points.add(highPoint);

      final num low = high.isNaN ? double.nan : bottom;
      final Offset lowPoint = Offset(transformX(x, low), transformY(x, low));
      _lowPoints.add(lowPoint);

      if (i < controlPointsLength) {
        final num startHighX = _startControlHighXValues[i];
        final num startHighY = _startControlHighYValues[i];
        final Offset startControlHighPoint = Offset(
            transformX(startHighX, startHighY),
            transformY(startHighX, startHighY));
        _startControlHighPoints.add(startControlHighPoint);

        final num endHighX = _endControlHighXValues[i];
        final num endHighY = _endControlHighYValues[i];
        final Offset endControlHighPoint = Offset(
            transformX(endHighX, endHighY), transformY(endHighX, endHighY));
        _endControlHighPoints.add(endControlHighPoint);
      }
    }

    length = _oldHighPoints.length;
    if (points.length > length) {
      _oldHighPoints.addAll(_highPoints.sublist(length));
      _oldLowPoints.addAll(_lowPoints.sublist(length));
    }

    length = _oldStartControlHighPoints.length;
    if (_startControlHighPoints.length > length) {
      _oldStartControlHighPoints
          .addAll(_startControlHighPoints.sublist(length));
      _oldEndControlHighPoints.addAll(_endControlHighPoints.sublist(length));
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
    final List<Offset> lerpStartControlHighPoints =
        _lerpPoints(_oldStartControlHighPoints, _startControlHighPoints);
    final List<Offset> lerpEndControlHighPoints =
        _lerpPoints(_oldEndControlHighPoints, _endControlHighPoints);
    _createFillPath(_fillPath, lerpHighPoints, lerpLowPoints,
        lerpStartControlHighPoints, lerpEndControlHighPoints);

    switch (series.borderDrawMode) {
      case BorderDrawMode.all:
        _strokePath = _fillPath;
        break;
      case BorderDrawMode.top:
        _createTopStrokePath(
          _strokePath,
          lerpHighPoints,
          lerpStartControlHighPoints,
          lerpEndControlHighPoints,
        );
        break;
      case BorderDrawMode.excludeBottom:
        _createExcludeBottomStrokePath(
          _strokePath,
          lerpHighPoints,
          lerpLowPoints,
          lerpStartControlHighPoints,
          lerpEndControlHighPoints,
        );
        break;
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
    Path source,
    List<Offset> highPoints,
    List<Offset> lowPoints,
    List<Offset> startControlHighPoints,
    List<Offset> endControlHighPoints,
  ) {
    Path? path;
    final int length = highPoints.length;
    final int lastIndex = length - 1;
    for (int i = 0; i <= lastIndex; i++) {
      final Offset highPoint = highPoints[i];
      final Offset lowPoint = lowPoints[i];
      if (i == 0) {
        if (lowPoint.isNaN) {
          final int sublistFrom = i + 1;
          final int controlPointsLength = startControlHighPoints.length;
          if (sublistFrom < length && sublistFrom < controlPointsLength) {
            _createFillPath(
              source,
              highPoints.sublist(sublistFrom),
              lowPoints.sublist(sublistFrom),
              startControlHighPoints.sublist(sublistFrom),
              endControlHighPoints.sublist(sublistFrom),
            );
          }
          break;
        } else {
          path = Path();
          path.moveTo(lowPoint.dx, lowPoint.dy);
          path.lineTo(highPoint.dx, highPoint.dy);
          continue;
        }
      }

      if (highPoint.isNaN) {
        for (int j = i - 1; j >= 0; j--) {
          final Offset lowPoint = lowPoints[j];
          path!.lineTo(lowPoint.dx, lowPoint.dy);
        }
        final int controlPointsLength = startControlHighPoints.length;
        if (i < length && i < controlPointsLength) {
          _createFillPath(
            source,
            highPoints.sublist(i),
            lowPoints.sublist(i),
            startControlHighPoints.sublist(i),
            endControlHighPoints.sublist(i),
          );
        }
        break;
      } else {
        final Offset startControlHigh = startControlHighPoints[i - 1];
        final Offset endControlHigh = endControlHighPoints[i - 1];
        path!.cubicTo(startControlHigh.dx, startControlHigh.dy,
            endControlHigh.dx, endControlHigh.dy, highPoint.dx, highPoint.dy);
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

  Path _createTopStrokePath(
    Path source,
    List<Offset> highPoints,
    List<Offset> startControlHighPoints,
    List<Offset> endControlHighPoints,
  ) {
    Path? path;
    final int length = highPoints.length;
    final int lastIndex = length - 1;
    for (int i = 0; i <= lastIndex; i++) {
      final Offset highPoint = highPoints[i];
      if (highPoint.isNaN) {
        final int sublistFrom = i + 1;
        final int controlPointsLength = startControlHighPoints.length;
        if (sublistFrom < length && sublistFrom < controlPointsLength) {
          _createTopStrokePath(
            source,
            highPoints.sublist(sublistFrom),
            startControlHighPoints.sublist(sublistFrom),
            endControlHighPoints.sublist(sublistFrom),
          );
        }
        break;
      } else {
        if (i == 0) {
          path = Path();
          path.moveTo(highPoint.dx, highPoint.dy);
        } else {
          final Offset startControlHigh = startControlHighPoints[i - 1];
          final Offset endControlHigh = endControlHighPoints[i - 1];
          path!.cubicTo(startControlHigh.dx, startControlHigh.dy,
              endControlHigh.dx, endControlHigh.dy, highPoint.dx, highPoint.dy);
        }
      }
    }

    if (path != null) {
      source.addPath(path, Offset.zero);
    }
    return source;
  }

  Path _createExcludeBottomStrokePath(
    Path source,
    List<Offset> highPoints,
    List<Offset> lowPoints,
    List<Offset> startControlHighPoints,
    List<Offset> endControlHighPoints,
  ) {
    Path? path;
    final int length = highPoints.length;
    final int lastIndex = length - 1;
    for (int i = 0; i <= lastIndex; i++) {
      final Offset highPoint = highPoints[i];
      final Offset lowPoint = lowPoints[i];
      if (i == 0) {
        if (lowPoint.isNaN) {
          final int sublistFrom = i + 1;
          final int controlPointsLength = startControlHighPoints.length;
          if (sublistFrom < length && sublistFrom < controlPointsLength) {
            _createExcludeBottomStrokePath(
              source,
              highPoints.sublist(sublistFrom),
              lowPoints.sublist(sublistFrom),
              startControlHighPoints.sublist(sublistFrom),
              endControlHighPoints.sublist(sublistFrom),
            );
          }
          break;
        } else {
          path = Path();
          path.moveTo(lowPoint.dx, lowPoint.dy);
          path.lineTo(highPoint.dx, highPoint.dy);
          continue;
        }
      }

      if (highPoint.isNaN) {
        final Offset lowPoint = lowPoints[i - 1];
        path!.lineTo(lowPoint.dx, lowPoint.dy);
        final int controlPointsLength = startControlHighPoints.length;
        if (i < length && i < controlPointsLength) {
          _createExcludeBottomStrokePath(
            source,
            highPoints.sublist(i),
            lowPoints.sublist(i),
            startControlHighPoints.sublist(i),
            endControlHighPoints.sublist(i),
          );
        }
        break;
      } else {
        final Offset startControlHigh = startControlHighPoints[i - 1];
        final Offset endControlHigh = endControlHighPoints[i - 1];
        path!.cubicTo(startControlHigh.dx, startControlHigh.dy,
            endControlHigh.dx, endControlHigh.dy, highPoint.dx, highPoint.dy);
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
      final num x = chartPoint.xValue!;
      final num y = chartPoint.y!;
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
    _startControlHighXValues.clear();
    _startControlHighYValues.clear();
    _endControlHighXValues.clear();
    _endControlHighYValues.clear();

    _fillPath.reset();
    _strokePath.reset();

    points.clear();
    _drawIndexes.clear();
    _highPoints.clear();
    _lowPoints.clear();
    _startControlHighPoints.clear();
    _endControlHighPoints.clear();
    super.dispose();
  }
}

/// Renders the spline range area series.
///
/// To render a spline range area chart, create an instance of
/// [SplineRangeAreaSeries], and add it to the series collection property
/// of [SfCartesianChart]. Properties such as [color], [opacity], [width] are
/// used to customize the appearance of spline area chart.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=uSsKhlRzC2Q}
@immutable
class SplineRangeAreaSeries<T, D> extends RangeSeriesBase<T, D> {
  /// Creating an argument constructor of SplineRangeAreaSeries class.
  const SplineRangeAreaSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.highValueMapper,
    required super.lowValueMapper,
    super.sortFieldValueMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.color,
    super.markerSettings,
    this.splineType = SplineType.natural,
    super.trendlines,
    this.cardinalSplineTension = 0.5,
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
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
    this.borderDrawMode = RangeAreaBorderMode.all,
  });

  /// Border type of the spline range area series.
  ///
  /// It takes the following two values:
  ///
  /// * [RangeAreaBorderMode.all] renders border for all the sides of
  /// the series.
  /// * [RangeAreaBorderMode.excludeSides] renders border at the top and bottom
  /// of the series,
  /// and excludes both sides.
  ///
  /// Defaults to `RangeAreaBorderMode.all`.
  ///
  /// Also refer [RangeAreaBorderMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineRangeAreaSeries<SalesData, num>>[
  ///       SplineRangeAreaSeries<SalesData, num>(
  ///         borderColor: Colors.red,
  ///         borderWidth: 3,
  ///         borderDrawMode: RangeAreaBorderMode.excludeSides,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final RangeAreaBorderMode borderDrawMode;

  /// Type of the spline curve in spline range area series.
  ///
  /// Various type of curves such as `SplineType.clamped`,
  /// `SplineType.cardinal`, `SplineType.monotonic`
  /// and `SplineType.natural` can be rendered between the data points.
  ///
  /// Defaults to `SplineType.natural`.
  ///
  /// Also refer [SplineType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineRangeAreaSeries<SalesData, num>>[
  ///       SplineRangeAreaSeries<SalesData, num>(
  ///         splineType: SplineType.monotonic
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final SplineType splineType;

  /// Line tension of the cardinal spline curve.
  ///
  /// This is applicable only when `SplineType.cardinal` is set to [splineType]
  /// property.
  ///
  /// Defaults to `0.5`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineRangeAreaSeries<SalesData, num>>[
  ///       SplineRangeAreaSeries<SalesData, num>(
  ///         splineType: SplineType.cardinal,
  ///         cardinalSplineTension: 0.2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double cardinalSplineTension;

  /// Create the spline area series renderer.
  @override
  SplineRangeAreaSeriesRenderer<T, D> createRenderer() {
    SplineRangeAreaSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer =
          onCreateRenderer!(this) as SplineRangeAreaSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return SplineRangeAreaSeriesRenderer<T, D>();
  }

  @override
  SplineRangeAreaSeriesRenderer<T, D> createRenderObject(BuildContext context) {
    final SplineRangeAreaSeriesRenderer<T, D> renderer = super
        .createRenderObject(context) as SplineRangeAreaSeriesRenderer<T, D>;
    renderer
      ..borderDrawMode = borderDrawMode
      ..splineType = splineType
      ..cardinalSplineTension = cardinalSplineTension
      ..borderColor = borderColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, SplineRangeAreaSeriesRenderer<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..borderDrawMode = borderDrawMode
      ..splineType = splineType
      ..cardinalSplineTension = cardinalSplineTension
      ..borderColor = borderColor;
  }
}

/// Creates series renderer for spline range area series.
class SplineRangeAreaSeriesRenderer<T, D> extends RangeSeriesRendererBase<T, D>
    with _SplineControlPointMixin<T, D>, ContinuousSeriesMixin<T, D> {
  RangeAreaBorderMode get borderDrawMode => _borderDrawMode;
  RangeAreaBorderMode _borderDrawMode = RangeAreaBorderMode.all;
  set borderDrawMode(RangeAreaBorderMode value) {
    if (_borderDrawMode != value) {
      _borderDrawMode = value;
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

  final List<num> _startControlX1Values = <num>[];
  final List<num> _startControlY1Values = <num>[];
  final List<num> _endControlX1Values = <num>[];
  final List<num> _endControlY1Values = <num>[];
  final List<num> _startControlX2Values = <num>[];
  final List<num> _startControlY2Values = <num>[];
  final List<num> _endControlX2Values = <num>[];
  final List<num> _endControlY2Values = <num>[];
  bool _isHigh = false;

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);

    _startControlX1Values.clear();
    _startControlY1Values.clear();
    _endControlX1Values.clear();
    _endControlY1Values.clear();
    _startControlX2Values.clear();
    _startControlY2Values.clear();
    _endControlX2Values.clear();
    _endControlY2Values.clear();

    final List<num?> highCoefficients = List<num?>.filled(dataCount, 0);
    final List<num?> lowCoefficients = List<num?>.filled(dataCount, 0);
    _yMax = double.negativeInfinity;

    _isHigh = true;
    for (int i = 0; i < 2; i++) {
      final num x1 = xValues[index];
      final num y1 =
          _isHigh ? nonEmptyHighValues[index] : nonEmptyLowValues[index];
      num x2 = double.nan;
      num y2 = double.nan;

      final int nextIndex = index + 1;
      if (nextIndex < dataCount) {
        x2 = xValues[nextIndex];
        y2 = _isHigh
            ? nonEmptyHighValues[nextIndex]
            : nonEmptyLowValues[nextIndex];
      }

      _buildSplineAreaSegment(
        _isHigh ? highCoefficients : lowCoefficients,
        x1,
        y1,
        nextIndex,
        x2,
        y2,
        _isHigh ? nonEmptyHighValues : nonEmptyLowValues,
        _isHigh ? _startControlX1Values : _startControlX2Values,
        _isHigh ? _startControlY1Values : _startControlY2Values,
        _isHigh ? _endControlX1Values : _endControlX2Values,
        _isHigh ? _endControlY1Values : _endControlY2Values,
      );

      _isHigh = false;
    }

    segment as SplineRangeAreaSegment<T, D>
      ..series = this
      ..currentSegmentIndex = 0
      .._xValues = xValues
      .._highValues = highValues
      .._lowValues = lowValues
      .._startControlHighXValues = _startControlX1Values
      .._startControlHighYValues = _startControlY1Values
      .._endControlHighXValues = _endControlX1Values
      .._endControlHighYValues = _endControlY1Values
      .._startControlLowXValues = _startControlX2Values
      .._startControlLowYValues = _startControlY2Values
      .._endControlLowXValues = _endControlX2Values
      .._endControlLowYValues = _endControlY2Values;
  }

  /// Creates a segment for a data point in the series.
  @override
  SplineRangeAreaSegment<T, D> createSegment() =>
      SplineRangeAreaSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      ShapeMarkerType.splineRangeAreaSeries;

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final SplineRangeAreaSegment<T, D> splineRangeAreaSegment =
        segment as SplineRangeAreaSegment<T, D>;
    updateSegmentColor(splineRangeAreaSegment, borderColor, borderWidth);
    updateSegmentGradient(splineRangeAreaSegment,
        gradientBounds: splineRangeAreaSegment._fillPath.getBounds(),
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

  @override
  void dispose() {
    _startControlX1Values.clear();
    _startControlY1Values.clear();
    _endControlX1Values.clear();
    _endControlY1Values.clear();
    _startControlX2Values.clear();
    _startControlY2Values.clear();
    _endControlX2Values.clear();
    _endControlY2Values.clear();
    super.dispose();
  }
}

/// Segment class for spline range area series.
class SplineRangeAreaSegment<T, D> extends ChartSegment {
  late SplineRangeAreaSeriesRenderer<T, D> series;
  late List<num> _startControlHighXValues;
  late List<num> _endControlHighXValues;
  late List<num> _startControlHighYValues;
  late List<num> _endControlHighYValues;
  late List<num> _startControlLowXValues;
  late List<num> _endControlLowXValues;
  late List<num> _startControlLowYValues;
  late List<num> _endControlLowYValues;
  late List<num> _xValues;
  late List<num> _highValues;
  late List<num> _lowValues;

  final Path _fillPath = Path();
  Path _strokePath = Path();

  final List<int> _drawIndexes = <int>[];
  final List<Offset> _highPoints = <Offset>[];
  final List<Offset> _lowPoints = <Offset>[];
  final List<Offset> _startControlHighPoints = <Offset>[];
  final List<Offset> _endControlHighPoints = <Offset>[];
  final List<Offset> _startControlLowPoints = <Offset>[];
  final List<Offset> _endControlLowPoints = <Offset>[];

  final List<Offset> _oldHighPoints = <Offset>[];
  final List<Offset> _oldLowPoints = <Offset>[];
  final List<Offset> _oldStartControlHighPoints = <Offset>[];
  final List<Offset> _oldEndControlHighPoints = <Offset>[];
  final List<Offset> _oldStartControlLowPoints = <Offset>[];
  final List<Offset> _oldEndControlLowPoints = <Offset>[];

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _drawIndexes.clear();
      _oldHighPoints.clear();
      _oldLowPoints.clear();
      _oldStartControlHighPoints.clear();
      _oldEndControlHighPoints.clear();
      _oldStartControlLowPoints.clear();
      _oldEndControlLowPoints.clear();
      return;
    }

    if (series.animationDuration > 0) {
      if (points.isEmpty) {
        _oldHighPoints.clear();
        _oldLowPoints.clear();
        _oldStartControlHighPoints.clear();
        _oldEndControlHighPoints.clear();
        _oldStartControlLowPoints.clear();
        _oldEndControlLowPoints.clear();
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

      final int oldControlPointsLength = _oldStartControlHighPoints.length;
      final int newControlPointsLength = _startControlHighPoints.length;
      if (oldControlPointsLength == newControlPointsLength) {
        for (int i = 0; i < oldControlPointsLength; i++) {
          _oldStartControlHighPoints[i] = _oldStartControlHighPoints[i].lerp(
              _startControlHighPoints[i],
              segmentAnimationFactor,
              _startControlHighPoints[i].dy)!;
          _oldEndControlHighPoints[i] = _oldEndControlHighPoints[i].lerp(
              _endControlHighPoints[i],
              segmentAnimationFactor,
              _oldEndControlHighPoints[i].dy)!;

          _oldStartControlLowPoints[i] = _oldStartControlLowPoints[i].lerp(
              _startControlLowPoints[i],
              segmentAnimationFactor,
              _startControlLowPoints[i].dy)!;
          _oldEndControlLowPoints[i] = _oldEndControlLowPoints[i].lerp(
              _endControlLowPoints[i],
              segmentAnimationFactor,
              _oldEndControlLowPoints[i].dy)!;
        }
      } else if (oldControlPointsLength < newControlPointsLength) {
        for (int i = 0; i < oldControlPointsLength; i++) {
          _oldStartControlHighPoints[i] = _oldStartControlHighPoints[i].lerp(
              _startControlHighPoints[i],
              segmentAnimationFactor,
              _startControlHighPoints[i].dy)!;
          _oldEndControlHighPoints[i] = _oldEndControlHighPoints[i].lerp(
              _endControlHighPoints[i],
              segmentAnimationFactor,
              _oldEndControlHighPoints[i].dy)!;
          _oldStartControlLowPoints[i] = _oldStartControlLowPoints[i].lerp(
              _startControlLowPoints[i],
              segmentAnimationFactor,
              _startControlLowPoints[i].dy)!;
          _oldEndControlLowPoints[i] = _oldEndControlLowPoints[i].lerp(
              _endControlLowPoints[i],
              segmentAnimationFactor,
              _oldEndControlLowPoints[i].dy)!;
        }
        _oldStartControlHighPoints
            .addAll(_startControlHighPoints.sublist(oldControlPointsLength));
        _oldEndControlHighPoints
            .addAll(_endControlHighPoints.sublist(oldControlPointsLength));
        _oldStartControlLowPoints
            .addAll(_startControlLowPoints.sublist(oldControlPointsLength));
        _oldEndControlLowPoints
            .addAll(_endControlLowPoints.sublist(oldControlPointsLength));
      } else {
        for (int i = 0; i < newControlPointsLength; i++) {
          _oldStartControlHighPoints[i] = _oldStartControlHighPoints[i].lerp(
              _startControlHighPoints[i],
              segmentAnimationFactor,
              _startControlHighPoints[i].dy)!;
          _oldEndControlHighPoints[i] = _oldEndControlHighPoints[i].lerp(
              _endControlHighPoints[i],
              segmentAnimationFactor,
              _oldEndControlHighPoints[i].dy)!;

          _oldStartControlLowPoints[i] = _oldStartControlLowPoints[i].lerp(
              _startControlLowPoints[i],
              segmentAnimationFactor,
              _startControlLowPoints[i].dy)!;
          _oldEndControlLowPoints[i] = _oldEndControlLowPoints[i].lerp(
              _endControlLowPoints[i],
              segmentAnimationFactor,
              _oldEndControlLowPoints[i].dy)!;
        }
        _oldStartControlHighPoints.removeRange(
            newControlPointsLength, oldControlPointsLength);
        _oldEndControlHighPoints.removeRange(
            newControlPointsLength, oldControlPointsLength);
        _oldStartControlLowPoints.removeRange(
            newControlPointsLength, oldControlPointsLength);
        _oldEndControlLowPoints.removeRange(
            newControlPointsLength, oldControlPointsLength);
      }
    } else {
      _oldHighPoints.clear();
      _oldLowPoints.clear();
      _oldStartControlHighPoints.clear();
      _oldEndControlHighPoints.clear();
      _oldStartControlLowPoints.clear();
      _oldEndControlLowPoints.clear();
    }
  }

  @override
  void transformValues() {
    points.clear();
    _drawIndexes.clear();
    _highPoints.clear();
    _lowPoints.clear();
    _startControlHighPoints.clear();
    _endControlHighPoints.clear();
    _startControlLowPoints.clear();
    _endControlLowPoints.clear();

    _fillPath.reset();
    _strokePath.reset();
    if (_xValues.isEmpty || _highValues.isEmpty || _lowValues.isEmpty) {
      return;
    }

    _calculatePoints();
    _createFillPath(
      _fillPath,
      _highPoints,
      _lowPoints,
      _startControlHighPoints,
      _endControlHighPoints,
      _startControlLowPoints,
      _endControlLowPoints,
    );
  }

  void _calculatePoints() {
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;

    final bool canDrop = series.emptyPointSettings.mode == EmptyPointMode.drop;
    final int length = series.dataCount;
    final int controlPointsLength = _startControlHighXValues.length;
    for (int i = 0; i < length; i++) {
      final num x = _xValues[i];
      num highY = _highValues[i];
      num lowY = _lowValues[i];
      if (lowY.isNaN || highY.isNaN) {
        if (canDrop) {
          continue;
        }
        highY = lowY = double.nan;
      }

      _drawIndexes.add(i);
      final Offset highPoint =
          Offset(transformX(x, highY), transformY(x, highY));
      _highPoints.add(highPoint);
      final Offset lowPoint = Offset(transformX(x, lowY), transformY(x, lowY));
      _lowPoints.add(lowPoint);
      points.add(lowPoint);
      points.add(highPoint);

      if (i < controlPointsLength) {
        num xValue = _startControlHighXValues[i];
        num yValue = _startControlHighYValues[i];
        Offset point =
            Offset(transformX(xValue, yValue), transformY(xValue, yValue));
        _startControlHighPoints.add(point);

        xValue = _endControlHighXValues[i];
        yValue = _endControlHighYValues[i];
        point = Offset(transformX(xValue, yValue), transformY(xValue, yValue));
        _endControlHighPoints.add(point);

        xValue = _startControlLowXValues[i];
        yValue = _startControlLowYValues[i];
        point = Offset(transformX(xValue, yValue), transformY(xValue, yValue));
        _startControlLowPoints.add(point);

        xValue = _endControlLowXValues[i];
        yValue = _endControlLowYValues[i];
        point = Offset(transformX(xValue, yValue), transformY(xValue, yValue));
        _endControlLowPoints.add(point);
      }
    }

    int oldLength = _oldHighPoints.length;
    if (_highPoints.length > oldLength) {
      _oldHighPoints.addAll(_highPoints.sublist(oldLength));
      _oldLowPoints.addAll(_lowPoints.sublist(oldLength));
    }

    oldLength = _oldStartControlHighPoints.length;
    if (_startControlHighPoints.length > oldLength) {
      _oldStartControlHighPoints
          .addAll(_startControlHighPoints.sublist(oldLength));
      _oldEndControlHighPoints.addAll(_endControlHighPoints.sublist(oldLength));
      _oldStartControlLowPoints
          .addAll(_startControlLowPoints.sublist(oldLength));
      _oldEndControlLowPoints.addAll(_endControlLowPoints.sublist(oldLength));
    }
  }

  void _computeAreaPath() {
    _fillPath.reset();
    _strokePath.reset();

    if (_highPoints.isEmpty || _lowPoints.isEmpty) {
      return;
    }

    final List<Offset> lerpHighPoints =
        _lerpPoints(_oldHighPoints, _highPoints);
    final List<Offset> lerpLowPoints = _lerpPoints(_oldLowPoints, _lowPoints);
    final List<Offset> lerpStartControlHighPoints =
        _lerpPoints(_oldStartControlHighPoints, _startControlHighPoints);
    final List<Offset> lerpEndControlHighPoints =
        _lerpPoints(_oldEndControlHighPoints, _endControlHighPoints);
    final List<Offset> lerpStartControlLowPoints =
        _lerpPoints(_oldStartControlLowPoints, _startControlLowPoints);
    final List<Offset> lerpEndControlLowPoints =
        _lerpPoints(_oldEndControlLowPoints, _endControlLowPoints);
    _createFillPath(
      _fillPath,
      lerpHighPoints,
      lerpLowPoints,
      lerpStartControlHighPoints,
      lerpEndControlHighPoints,
      lerpStartControlLowPoints,
      lerpEndControlLowPoints,
    );

    switch (series.borderDrawMode) {
      case RangeAreaBorderMode.all:
        _strokePath = _fillPath;
        break;
      case RangeAreaBorderMode.excludeSides:
        _createStrokePathForExcludeSides(
          _strokePath,
          lerpHighPoints,
          lerpLowPoints,
          lerpStartControlHighPoints,
          lerpEndControlHighPoints,
          lerpStartControlLowPoints,
          lerpEndControlLowPoints,
        );
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
    Path source,
    List<Offset> highPoints,
    List<Offset> lowPoints,
    List<Offset> startControlHighPoints,
    List<Offset> endControlHighPoints,
    List<Offset> startControlLowPoints,
    List<Offset> endControlLowPoints,
  ) {
    Path? path;
    final int length = highPoints.length;
    final int lastIndex = length - 1;
    for (int i = 0; i < length; i++) {
      final Offset highPoint = highPoints[i];
      final Offset lowPoint = lowPoints[i];
      if (i == 0) {
        if (lowPoint.isNaN) {
          final int sublistFrom = i + 1;
          final int controlPointsLength = startControlHighPoints.length;
          if (sublistFrom < length && sublistFrom < controlPointsLength) {
            _createFillPath(
              source,
              highPoints.sublist(sublistFrom),
              lowPoints.sublist(sublistFrom),
              startControlHighPoints.sublist(sublistFrom),
              endControlHighPoints.sublist(sublistFrom),
              startControlLowPoints.sublist(sublistFrom),
              endControlLowPoints.sublist(sublistFrom),
            );
          }
          break;
        } else {
          path = Path();
          path.moveTo(lowPoint.dx, lowPoint.dy);
          path.lineTo(highPoint.dx, highPoint.dy);
          continue;
        }
      }

      if (highPoint.isNaN) {
        for (int j = i - 1; j >= 0; j--) {
          if (j == i - 1) {
            final Offset lowPoint = lowPoints[j];
            path!.lineTo(lowPoint.dx, lowPoint.dy);
            continue;
          }

          final Offset lowPoint = lowPoints[j];
          final Offset startLow = startControlLowPoints[j];
          final Offset endLow = endControlLowPoints[j];
          path!.cubicTo(endLow.dx, endLow.dy, startLow.dx, startLow.dy,
              lowPoint.dx, lowPoint.dy);
        }
        final int controlPointsLength = startControlHighPoints.length;
        if (i < length && i < controlPointsLength) {
          _createFillPath(
            source,
            highPoints.sublist(i),
            lowPoints.sublist(i),
            startControlHighPoints.sublist(i),
            endControlHighPoints.sublist(i),
            startControlLowPoints.sublist(i),
            endControlLowPoints.sublist(i),
          );
        }
        break;
      } else {
        final Offset startHigh = startControlHighPoints[i - 1];
        final Offset endHigh = endControlHighPoints[i - 1];
        path!.cubicTo(startHigh.dx, startHigh.dy, endHigh.dx, endHigh.dy,
            highPoint.dx, highPoint.dy);
        if (i == lastIndex) {
          for (int j = i; j >= 0; j--) {
            if (j == i) {
              final Offset lowPoint = lowPoints[j];
              path.lineTo(lowPoint.dx, lowPoint.dy);
              continue;
            }

            final Offset lowPoint = lowPoints[j];
            final Offset startLow = startControlLowPoints[j];
            final Offset endLow = endControlLowPoints[j];
            path.cubicTo(endLow.dx, endLow.dy, startLow.dx, startLow.dy,
                lowPoint.dx, lowPoint.dy);
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
    Path source,
    List<Offset> highPoints,
    List<Offset> lowPoints,
    List<Offset> startControlHighPoints,
    List<Offset> endControlHighPoints,
    List<Offset> startControlLowPoints,
    List<Offset> endControlLowPoints,
  ) {
    Path? highPath;
    Path? lowPath;
    final int length = highPoints.length;
    for (int i = 0; i < length; i++) {
      final Offset highPoint = highPoints[i];
      final Offset lowPoint = lowPoints[i];
      if (highPoint.isNaN) {
        final int sublistFrom = i + 1;
        final int controlPointsLength = startControlHighPoints.length;
        if (sublistFrom < length && sublistFrom < controlPointsLength) {
          _createStrokePathForExcludeSides(
            source,
            highPoints.sublist(sublistFrom),
            lowPoints.sublist(sublistFrom),
            startControlHighPoints.sublist(sublistFrom),
            endControlHighPoints.sublist(sublistFrom),
            startControlLowPoints.sublist(sublistFrom),
            endControlLowPoints.sublist(sublistFrom),
          );
        }
        break;
      } else {
        if (i == 0) {
          highPath = Path();
          lowPath = Path();
          highPath.moveTo(highPoint.dx, highPoint.dy);
          lowPath.moveTo(lowPoint.dx, lowPoint.dy);
        } else {
          final Offset startHigh = startControlHighPoints[i - 1];
          final Offset endHigh = endControlHighPoints[i - 1];
          highPath!.cubicTo(startHigh.dx, startHigh.dy, endHigh.dx, endHigh.dy,
              highPoint.dx, highPoint.dy);

          final Offset startLow = startControlLowPoints[i - 1];
          final Offset endLow = endControlLowPoints[i - 1];
          lowPath!.cubicTo(startLow.dx, startLow.dy, endLow.dx, endLow.dy,
              lowPoint.dx, lowPoint.dy);
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
      xValue: _xValues[pointIndex],
      high: _highValues[pointIndex],
      low: _lowValues[pointIndex],
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
    _startControlHighXValues.clear();
    _startControlHighYValues.clear();
    _endControlHighXValues.clear();
    _endControlHighYValues.clear();
    _startControlLowXValues.clear();
    _startControlLowYValues.clear();
    _endControlLowXValues.clear();
    _endControlLowYValues.clear();
    _fillPath.reset();
    _strokePath.reset();

    points.clear();
    _drawIndexes.clear();
    _highPoints.clear();
    _lowPoints.clear();
    _startControlHighPoints.clear();
    _endControlHighPoints.clear();
    _startControlLowPoints.clear();
    _endControlLowPoints.clear();
    super.dispose();
  }
}
