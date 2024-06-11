import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../behaviors/trackball.dart';
import '../common/chart_point.dart';
import '../common/core_tooltip.dart';
import '../common/data_label.dart';
import '../common/element_widget.dart';
import '../interactions/tooltip.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'chart_series.dart';

/// Renders the hilo open close series.
///
/// Hilo open close series is used to represent the low, high,
/// open and closing values over time.
///
/// To render a hilo open close chart, create an instance of
/// [HiloOpenCloseSeries], and add it to the series collection
/// property of [SfCartesianChart].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=g5cniDExpRw}
class HiloOpenCloseSeries<T, D> extends FinancialSeriesBase<T, D> {
  /// Creating an argument constructor of HiloOpenCloseSeries class.
  const HiloOpenCloseSeries({
    super.key,
    super.onCreateRenderer,
    super.dataSource,
    required super.xValueMapper,
    required super.lowValueMapper,
    required super.highValueMapper,
    required super.openValueMapper,
    required super.closeValueMapper,
    super.volumeValueMapper,
    super.sortFieldValueMapper,
    super.pointColorMapper,
    super.dataLabelMapper,
    super.sortingOrder,
    super.xAxisName,
    super.yAxisName,
    super.name,
    super.bearColor,
    super.bullColor,
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
    super.spacing = 0,
    super.initialSelectedDataIndexes,
    super.showIndicationForSameValues = false,
    super.trendlines,
    super.onRendererCreated,
    super.onPointTap,
    super.onPointDoubleTap,
    super.onPointLongPress,
    super.onCreateShader,
  });

  /// Create the hilo open close series renderer.
  @override
  HiloOpenCloseSeriesRenderer<T, D> createRenderer() {
    HiloOpenCloseSeriesRenderer<T, D> seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer =
          onCreateRenderer!(this) as HiloOpenCloseSeriesRenderer<T, D>;
      return seriesRenderer;
    }
    return HiloOpenCloseSeriesRenderer<T, D>();
  }
}

/// Creates series renderer for hilo open close series.
class HiloOpenCloseSeriesRenderer<T, D>
    extends FinancialSeriesRendererBase<T, D> with SegmentAnimationMixin<T, D> {
  @override
  Offset dataLabelPosition(ChartElementParentData current,
      ChartDataLabelAlignment alignment, Size size) {
    if (current.position != ChartDataPointType.open ||
        current.position != ChartDataPointType.close) {
      return super.dataLabelPosition(current, alignment, size);
    }

    final num x = current.x! + (sbsInfo.maximum + sbsInfo.minimum) / 2;
    if (current.position == ChartDataPointType.open) {
      return _calculateDataLabelOpenPosition(x, current.y!, alignment, size);
    } else if (current.position == ChartDataPointType.close) {
      return _calculateDataLabelClosePosition(x, current.y!, alignment, size);
    }

    return Offset.zero;
  }

  Offset _calculateDataLabelOpenPosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.middle:
        return _calculateOpenAndClosePosition(
            x, y, ChartDataLabelAlignment.outer, size, ChartDataPointType.open);

      case ChartDataLabelAlignment.bottom:
        return _calculateOpenAndClosePosition(
            x, y, ChartDataLabelAlignment.top, size, ChartDataPointType.open);
    }
  }

  Offset _calculateDataLabelClosePosition(
      num x, num y, ChartDataLabelAlignment alignment, Size size) {
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.top:
      case ChartDataLabelAlignment.middle:
        return _calculateOpenAndClosePosition(x, y,
            ChartDataLabelAlignment.outer, size, ChartDataPointType.close);

      case ChartDataLabelAlignment.bottom:
        return _calculateOpenAndClosePosition(
            x, y, ChartDataLabelAlignment.top, size, ChartDataPointType.close);
    }
  }

  Offset _calculateOpenAndClosePosition(
      num x,
      num y,
      ChartDataLabelAlignment alignment,
      Size size,
      ChartDataPointType position) {
    final EdgeInsets margin = dataLabelSettings.margin;
    final double openAndCloseDataLabelPadding =
        _openAndCloseDataLabelPadding(position, margin);

    double translationX = 0.0;
    double translationY = 0.0;
    switch (alignment) {
      case ChartDataLabelAlignment.auto:
      case ChartDataLabelAlignment.outer:
      case ChartDataLabelAlignment.middle:
      case ChartDataLabelAlignment.bottom:
        if (isTransposed) {
          translationX = dataLabelPadding;
          translationY = -margin.top + openAndCloseDataLabelPadding;
        } else {
          translationX = -margin.left + openAndCloseDataLabelPadding;
          translationY = -(dataLabelPadding + size.height + margin.vertical);
        }
        return translateTransform(x, y, translationX, translationY);

      case ChartDataLabelAlignment.top:
        if (isTransposed) {
          translationX = -(dataLabelPadding + size.width + margin.horizontal);
          translationY = -margin.top + openAndCloseDataLabelPadding;
        } else {
          translationX = -margin.left + openAndCloseDataLabelPadding;
          translationY = dataLabelPadding;
        }
        return translateTransform(x, y, translationX, translationY);
    }
  }

  double _openAndCloseDataLabelPadding(
      ChartDataPointType position, EdgeInsets margin) {
    double paddingValue = dataLabelPadding + (2 * margin.left);
    if (isTransposed) {
      paddingValue = dataLabelPadding + (2 * margin.top);
      return position == ChartDataPointType.open ? paddingValue : -paddingValue;
    }
    return position == ChartDataPointType.open ? -paddingValue : paddingValue;
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

  @override
  void setData(int index, ChartSegment segment) {
    super.setData(index, segment);
    segment as HiloOpenCloseSegment<T, D>
      ..series = this
      ..x = xValues[index]
      ..high = highValues[index]
      ..low = lowValues[index]
      ..open = openValues[index]
      ..close = closeValues[index]
      ..isEmpty = isEmpty(index);
  }

  @override
  HiloOpenCloseSegment<T, D> createSegment() => HiloOpenCloseSegment<T, D>();

  @override
  ShapeMarkerType effectiveLegendIconType() =>
      ShapeMarkerType.hiloOpenCloseSeries;

  @override
  void customizeSegment(ChartSegment segment) {
    final int index = segment.currentSegmentIndex;
    final bool isBull = closeValues[index] > openValues[index];
    final Color color = isBull ? bullColor : bearColor;
    final Color? segmentColor = pointColorMapper != null &&
            pointColors[segment.currentSegmentIndex] != null
        ? null
        : color;
    updateSegmentColor(segment, segmentColor, borderWidth,
        fillColor: segmentColor, isLineType: true);
    updateSegmentGradient(segment);
  }
}

/// Segment class for hilo open close series.
class HiloOpenCloseSegment<T, D> extends ChartSegment {
  late HiloOpenCloseSeriesRenderer<T, D> series;
  bool _isSameValue = false;

  late num x;
  num high = double.nan;
  num low = double.nan;
  num open = double.nan;
  num close = double.nan;

  final List<Offset> _oldPoints = <Offset>[];

  @override
  void copyOldSegmentValues(
      double seriesAnimationFactor, double segmentAnimationFactor) {
    if (series.animationType == AnimationType.loading) {
      points.clear();
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
    } else {
      _oldPoints.clear();
    }
  }

  @override
  void transformValues() {
    if (x.isNaN || high.isNaN || low.isNaN || open.isNaN || close.isNaN) {
      return;
    }

    points.clear();

    final PointToPixelCallback transformX = series.pointToPixelX;
    final PointToPixelCallback transformY = series.pointToPixelY;
    final num left = x + series.sbsInfo.minimum;
    final num right = x + series.sbsInfo.maximum;

    final double centerY = (low + high) / 2;
    _isSameValue = high == low;

    final double centerX = (right + left) / 2;
    points.add(Offset(transformX(centerX, high), transformY(centerX, high)));
    points.add(Offset(transformX(centerX, low), transformY(centerX, low)));

    points.add(Offset(transformX(left, open), transformY(left, open)));
    points.add(Offset(transformX(centerX, open), transformY(centerX, open)));

    points.add(Offset(transformX(right, close), transformY(right, close)));
    points.add(Offset(transformX(centerX, close), transformY(centerX, close)));

    if (_isSameValue && series.showIndicationForSameValues) {
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

    if (_oldPoints.isEmpty) {
      final Offset center =
          Offset(transformX(centerX, centerY), transformY(centerX, centerY));
      _oldPoints.add(center);
      _oldPoints.add(center);
      _oldPoints
          .add(Offset(transformX(left, centerY), transformY(left, centerY)));
      _oldPoints.add(center);
      _oldPoints
          .add(Offset(transformX(right, centerY), transformY(right, centerY)));
      _oldPoints.add(center);
    }

    if (points.length > _oldPoints.length) {
      _oldPoints.addAll(points.sublist(_oldPoints.length));
    }
  }

  @override
  bool contains(Offset position) {
    late Rect segmentRegion;
    if (series.isTransposed) {
      final Offset start = series.yAxis != null && series.yAxis!.isInversed
          ? points[0]
          : points[1];
      final Offset end = series.yAxis != null && series.yAxis!.isInversed
          ? points[1]
          : points[0];
      segmentRegion = Rect.fromLTRB(
          start.dx, start.dy - hiloPadding, end.dx, end.dy + hiloPadding);
    } else {
      final Offset start = series.yAxis != null && series.yAxis!.isInversed
          ? points[1]
          : points[0];
      final Offset end = series.yAxis != null && series.yAxis!.isInversed
          ? points[0]
          : points[1];
      segmentRegion = Rect.fromLTRB(
          start.dx - hiloPadding, start.dy, end.dx + hiloPadding, end.dy);
    }

    if (segmentRegion.contains(position)) {
      return true;
    }
    return false;
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
    if (points.isEmpty) {
      return null;
    }

    pointIndex ??= currentSegmentIndex;
    final CartesianChartPoint<D> chartPoint = _chartPoint();
    final Offset preferredPos = series.localToGlobal(points[0]);
    return ChartTooltipInfo<T, D>(
      primaryPosition: preferredPos,
      secondaryPosition: preferredPos,
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
    if (pointIndex != -1 && points.isNotEmpty) {
      final Offset preferredPos =
          Offset(series.pointToPixelX(x, high), series.pointToPixelY(x, high));
      final CartesianChartPoint<D> chartPoint = _chartPoint();
      return ChartTrackballInfo<T, D>(
        position: preferredPos,
        highXPos: preferredPos.dx,
        highYPos: preferredPos.dy,
        lowYPos: series.pointToPixelY(x, low),
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
    if (points.isEmpty) {
      return;
    }

    final Paint paint = getStrokePaint();
    if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
      Offset start = Offset.lerp(_oldPoints[0], points[0], animationFactor)!;
      Offset end = Offset.lerp(_oldPoints[1], points[1], animationFactor)!;
      drawDashes(canvas, series.dashArray, paint, start: start, end: end);

      start = Offset.lerp(_oldPoints[2], points[2], animationFactor)!;
      end = Offset.lerp(_oldPoints[3], points[3], animationFactor)!;
      drawDashes(canvas, series.dashArray, paint, start: start, end: end);

      start = Offset.lerp(_oldPoints[4], points[4], animationFactor)!;
      end = Offset.lerp(_oldPoints[5], points[5], animationFactor)!;
      drawDashes(canvas, series.dashArray, paint, start: start, end: end);

      if (_isSameValue && series.showIndicationForSameValues) {
        start = Offset.lerp(_oldPoints[6], points[6], animationFactor)!;
        end = Offset.lerp(_oldPoints[7], points[7], animationFactor)!;
        drawDashes(canvas, series.dashArray, paint, start: start, end: end);
      }
    }
  }

  @override
  void dispose() {
    points.clear();
    super.dispose();
  }
}
