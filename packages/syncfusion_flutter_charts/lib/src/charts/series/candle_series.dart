import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/data_label.dart';
import '../interactions/tooltip.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// This class holds the properties of the candle series.
///
/// To render a candle chart, create an instance of [CandleSeries], and add
/// it to the `series` collection property of [SfCartesianChart].
/// The candle chart represents the hollow rectangle with the open, close, high
/// and low value in the given data.
///
/// It has the [bearColor] and [bullColor] properties to change the appearance
/// of the candle series.
///
/// Provides options for color, opacity, border color, and border width
/// to customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=g5cniDExpRw}
@immutable
class CandleSeries<T, D> extends FinancialSeriesBase<T, D> {
  /// Creating an argument constructor of CandleSeries class.
  const CandleSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.lowValueMapper,
    required super.highValueMapper,
    required super.openValueMapper,
    required super.closeValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.bearColor,
    super.bullColor,
    super.enableSolidCandles,
    super.emptyPointSettings,
    super.dataLabelSettings,
    super.initialIsVisible,
    super.enableTooltip = true,
    super.animationDuration,
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
    super.showIndicationForSameValues = false,
    super.trendlines,
  });

  /// Create the candle series renderer.
  @override
  CandleSeriesRenderer<T, D> createRenderer() {
    CandleSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(this) as CandleSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return CandleSeriesRenderer<T, D>();
  }
}

/// Creates series renderer for candle series.
class CandleSeriesRenderer<T, D> extends FinancialSeriesRendererBase<T, D>
    with SegmentAnimationMixin<T, D> {
  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    final num open = openValues[index];
    final num close = closeValues[index];
    final bool isHollow = close > open;

    segment as CandleSegment<T, D>
      ..series = this
      ..currentSegmentIndex = index
      ..x = xValues[index]
      ..high = highValues[index]
      ..low = lowValues[index]
      ..open = open
      ..close = close
      ..top = isHollow ? close : open
      ..bottom = isHollow ? open : close
      ..isEmpty = isEmpty(index);
  }

  @override
  CandleSegment<T, D> createSegment() => CandleSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() => ShapeMarkerType.candleSeries;

  @override
  void customizeSegment(ChartSegment segment) {
    final int index = segment.currentSegmentIndex;
    num previousClose = double.negativeInfinity;
    if (index != 0) {
      previousClose = closeValues[index - 1];
    }

    final num open = openValues[index];
    final num close = closeValues[index];
    final bool isHollow = close > open;
    final bool isBull = close > previousClose;

    // TODO(Natrayasf): Comment section is pending.
    //  Naming of colors.
    //  +--------+-----------+
    //  | Color  | colorName |
    //  +--------+-----------+
    //  | Green  | bullColor |
    //  | Red    | bearColor |
    //  +--------+-----------+

    // Set [enableSolidCandles: true].
    //  +--------+--------+----------------+
    //  | Hollow | Color  | Rendering      |
    //  +--------+--------+----------------+
    //  | true   | Green  | Solid, Fill    |
    //  | false  | Red    | Solid, Fill    |
    //  +--------+--------+----------------+

    // Set [enableSolidCandles: false].
    //  +---------+----------+-------------+-------------+
    //  | isBull  | isHollow | FillColor   | StrokeColor |
    //  +---------+----------+-------------+-------------+
    //  | true    | true     | transparent | Green       |
    //  | false   | true     | transparent | Red         |
    //  | true    | false    | Green       | Green       |
    //  | false   | false    | Red         | Red         |
    //  +---------+----------+-------------+-------------+

    late Color color;
    if (enableSolidCandles) {
      color = isHollow ? bullColor : bearColor;
      final Color? segmentColor = pointColorMapper != null &&
              pointColors[segment.currentSegmentIndex] != null
          ? null
          : color;
      updateSegmentColor(segment, segmentColor, borderWidth,
          fillColor: segmentColor, isLineType: true);
    } else {
      color = isBull ? bullColor : bearColor;
      final Color? segmentColor = pointColorMapper != null &&
              pointColors[segment.currentSegmentIndex] != null
          ? null
          : color;
      updateSegmentColor(segment, segmentColor, borderWidth,
          fillColor: isHollow ? Colors.transparent : segmentColor,
          isLineType: true);
    }
    updateSegmentGradient(segment);
  }

  @override
  Color dataLabelSurfaceColor(CartesianChartDataLabelPositioned label) {
    final SfChartThemeData chartThemeData = parent!.chartThemeData!;
    final ThemeData themeData = parent!.themeData!;
    if (chartThemeData.plotAreaBackgroundColor != Colors.transparent) {
      return chartThemeData.plotAreaBackgroundColor!;
    } else if (chartThemeData.backgroundColor != Colors.transparent) {
      return chartThemeData.backgroundColor!;
    }
    return themeData.colorScheme.surface;
  }
}

/// Segment class for candle series.
class CandleSegment<T, D> extends ChartSegment {
  late CandleSeriesRenderer<T, D> series;
  late num x;
  late num high;
  late num low;
  late num open;
  late num close;
  late num top;
  late num bottom;

  bool _isSameValue = false;
  Rect? _oldSegmentRect;
  Rect? segmentRect;
  final List<Offset> _oldPoints = <Offset>[];

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
      _oldSegmentRect = null;
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

      _oldSegmentRect =
          Rect.lerp(_oldSegmentRect, segmentRect, segmentAnimationFactor);
    } else {
      _oldPoints.clear();
      _oldSegmentRect = segmentRect;
    }
  }

  @override
  void transformValues() {
    if (x.isNaN || top.isNaN || bottom.isNaN || high.isNaN || low.isNaN) {
      segmentRect = null;
      _oldSegmentRect = null;
      _oldPoints.clear();
      points.clear();
      return;
    }

    points.clear();
    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;
    final num left = x + series.sbsInfo.minimum;
    final num right = x + series.sbsInfo.maximum;

    final double centerX = (right + left) / 2;
    final double centerY = (low + high) / 2;

    final double x1 = transformX(left, top);
    final double y1 = transformY(left, top);
    final double x2 = transformX(right, bottom);
    final double y2 = transformY(right, bottom);
    segmentRect = Rect.fromLTRB(x1, y1, x2, y2);
    _oldSegmentRect ??= Rect.fromLTRB(
      series.pointToPixelX(left, centerY),
      series.pointToPixelY(left, centerY),
      series.pointToPixelX(right, centerY),
      series.pointToPixelY(right, centerY),
    );

    _isSameValue = top == bottom;
    if (_isSameValue) {
      points.add(Offset(x1, y1));
      points.add(Offset(x2, y2));

      if (series.showIndicationForSameValues) {
        final double x = transformX(centerX, centerY);
        final double y = transformY(centerX, centerY);
        if (series.isTransposed) {
          points.add(Offset(x - 2, y));
          points.add(Offset(x + 2, y));
        } else {
          points.add(Offset(x, y - 2));
          points.add(Offset(x, y + 2));
        }
      }
      segmentRect = Rect.fromPoints(points[0], points[1]);
    } else {
      points.add(Offset(transformX(centerX, high), transformY(centerX, high)));
      points.add(Offset(transformX(centerX, top), transformY(centerX, top)));

      points.add(Offset(transformX(centerX, low), transformY(centerX, low)));
      points.add(
          Offset(transformX(centerX, bottom), transformY(centerX, bottom)));

      if (_oldPoints.isEmpty) {
        final Offset point =
            Offset(transformX(centerX, centerY), transformY(centerX, centerY));
        _oldPoints.add(point);
        _oldPoints.add(point);
        _oldPoints.add(point);
        _oldPoints.add(point);
      }
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
      high: high,
      low: low,
      open: open,
      close: close,
    );
  }

  @override
  TooltipInfo? tooltipInfo({Offset? position, int? pointIndex}) {
    if (segmentRect == null) {
      return null;
    }

    pointIndex ??= currentSegmentIndex;
    final CartesianChartPoint<D> chartPoint = _chartPoint();
    Offset primaryPos;
    Offset secondaryPos;
    if (points.isNotEmpty) {
      primaryPos = series.localToGlobal(points[0]);
      secondaryPos = primaryPos;
    } else {
      primaryPos = series.localToGlobal(segmentRect!.topCenter);
      secondaryPos = series.localToGlobal(segmentRect!.bottomCenter);
    }
    return ChartTooltipInfo<T, D>(
      primaryPosition: primaryPos,
      secondaryPosition: secondaryPos,
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
      hasMultipleYValues: true,
      markerColors: <Color?>[series.paletteColor],
      markerType: series.markerAt(pointIndex).type,
    );
  }

  @override
  TrackballInfo? trackballInfo(Offset position, int pointIndex) {
    if (pointIndex != -1 && segmentRect != null) {
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      Offset preferredPos;
      if (points.isNotEmpty) {
        preferredPos = Offset(
            series.pointToPixelX(x, high), series.pointToPixelY(x, high));
      } else {
        preferredPos =
            Offset(series.pointToPixelX(x, top), series.pointToPixelX(x, top));
      }
      return ChartTrackballInfo<T, D>(
        position: preferredPos,
        highXPos: preferredPos.dx,
        highYPos: series.pointToPixelY(x, high),
        lowYPos: series.pointToPixelY(x, bottom),
        point: chartPoint,
        series: series,
        seriesIndex: series.index,
        segmentIndex: currentSegmentIndex,
        pointIndex: pointIndex,
        text: series.trackballText(chartPoint, series.name),
        header: series.tooltipHeaderText(chartPoint),
        color: fillPaint.color == Colors.transparent
            ? strokePaint.color
            : fillPaint.color,
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
    if (points.isEmpty || segmentRect == null) {
      return;
    }

    final Rect? paintRect =
        Rect.lerp(_oldSegmentRect, segmentRect, animationFactor);
    Paint paint = getFillPaint();
    if (paint.color != Colors.transparent && !_isSameValue) {
      canvas.drawRect(paintRect!, paint);
    }

    paint = getStrokePaint();
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      if (_isSameValue) {
        drawDashes(canvas, series.dashArray, paint,
            start: points[0], end: points[1]);
        if (series.showIndicationForSameValues) {
          drawDashes(canvas, series.dashArray, paint,
              start: points[2], end: points[3]);
        }
      } else {
        final Path strokePath =
            strokePathFromRect(paintRect, paint.strokeWidth);
        drawDashes(canvas, series.dashArray, paint, path: strokePath);

        final Offset start =
            Offset.lerp(_oldPoints[0], points[0], animationFactor)!;
        final Offset end =
            Offset.lerp(_oldPoints[1], points[1], animationFactor)!;
        drawDashes(canvas, series.dashArray, paint, start: start, end: end);

        final Offset start2 =
            Offset.lerp(_oldPoints[2], points[2], animationFactor)!;
        final Offset end2 =
            Offset.lerp(_oldPoints[3], points[3], animationFactor)!;
        drawDashes(canvas, series.dashArray, paint, start: start2, end: end2);
      }
    }
  }

  @override
  void dispose() {
    points.clear();
    segmentRect = null;
    super.dispose();
  }
}
