import 'dart:math';

import 'package:flutter/material.dart';

import '../behaviors/trackball.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../series/chart_series.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'technical_indicator.dart';

/// This class holds the properties of the average true range indicator.
///
/// ATR indicator is a technical analysis volatility indicator. This indicator
/// does not indicate the price trend, simply the degree of price volatility.
/// The average true range is an N-day smoothed moving average (SMA) of the true
/// range values.
///
/// Provides options for series visible, axis name, series name, animation
/// duration, legend visibility, signal line width, and color to customize
/// the appearance of indicator.
@immutable
class AtrIndicator<T, D> extends TechnicalIndicator<T, D> {
  /// Creating an argument constructor of AtrIndicator class.
  AtrIndicator({
    super.isVisible,
    super.xAxisName,
    super.yAxisName,
    super.seriesName,
    super.dashArray,
    super.animationDuration,
    super.animationDelay,
    super.dataSource,
    ChartValueMapper<T, D>? xValueMapper,
    ChartValueMapper<T, num>? highValueMapper,
    ChartValueMapper<T, num>? lowValueMapper,
    ChartValueMapper<T, num>? closeValueMapper,
    super.name,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.signalLineColor,
    super.signalLineWidth,
    this.period = 14,
    super.onRenderDetailsUpdate,
  }) : super(
          xValueMapper: xValueMapper != null && dataSource != null
              ? (int index) => xValueMapper(dataSource[index], index)
              : null,
          highValueMapper: highValueMapper != null && dataSource != null
              ? (int index) => highValueMapper(dataSource[index], index)
              : null,
          lowValueMapper: lowValueMapper != null && dataSource != null
              ? (int index) => lowValueMapper(dataSource[index], index)
              : null,
          closeValueMapper: closeValueMapper != null && dataSource != null
              ? (int index) => closeValueMapper(dataSource[index], index)
              : null,
        );

  /// Period determines the start point for the rendering of
  /// technical indicators.
  ///
  /// Defaults to `14`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      AtrIndicator<Sample, num>(
  ///        period : 4
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final int period;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is AtrIndicator &&
        other.isVisible == isVisible &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.seriesName == seriesName &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.animationDelay == animationDelay &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.highValueMapper == highValueMapper &&
        other.lowValueMapper == lowValueMapper &&
        other.closeValueMapper == closeValueMapper &&
        other.period == period &&
        other.name == name &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.signalLineColor == signalLineColor &&
        other.signalLineWidth == signalLineWidth;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      isVisible,
      xAxisName,
      yAxisName,
      seriesName,
      dashArray,
      animationDuration,
      animationDelay,
      dataSource,
      xValueMapper,
      highValueMapper,
      lowValueMapper,
      closeValueMapper,
      name,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      signalLineColor,
      signalLineWidth,
      period
    ];
    return Object.hashAll(values);
  }

  @override
  String toString() => 'ATR';
}

class AtrIndicatorWidget extends IndicatorWidget {
  const AtrIndicatorWidget({
    super.key,
    required super.vsync,
    required super.isTransposed,
    required super.indicator,
    required super.index,
    super.onLegendTapped,
    super.onLegendItemRender,
  });

  /// Create the ADIndicatorRenderer renderer.
  @override
  AtrIndicatorRenderer createRenderer() {
    return AtrIndicatorRenderer();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    final AtrIndicatorRenderer renderer =
        super.createRenderObject(context) as AtrIndicatorRenderer;
    final AtrIndicator atr = indicator as AtrIndicator;

    renderer
      ..highValueMapper = atr.highValueMapper
      ..lowValueMapper = atr.lowValueMapper
      ..closeValueMapper = atr.closeValueMapper
      ..period = atr.period;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, AtrIndicatorRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    final AtrIndicator atr = indicator as AtrIndicator;

    renderObject
      ..highValueMapper = atr.highValueMapper
      ..lowValueMapper = atr.lowValueMapper
      ..closeValueMapper = atr.closeValueMapper
      ..period = atr.period;
  }
}

class AtrIndicatorRenderer<T, D> extends IndicatorRenderer<T, D> {
  late List<double>? _dashArray;

  List<num> _highValues = <num>[];
  List<num> _lowValues = <num>[];
  List<num> _closeValues = <num>[];

  final List<Offset> _signalLineActualValues = <Offset>[];

  int get period => _period;
  int _period = 14;
  set period(int value) {
    if (_period != value) {
      _period = value;
      markNeedsPopulateAndLayout();
    }
  }

  @override
  void populateDataSource([
    List<T>? seriesDataSource,
    ChartIndexedValueMapper<D>? xPath,
    List<num>? xList,
    List<ChartIndexedValueMapper<num?>?>? yPaths,
    List<List<num>?>? yList,
  ]) {
    if (dataSource != null) {
      super.populateDataSource(
        dataSource,
        xValueMapper,
        xValues,
        <ChartIndexedValueMapper<num?>?>[
          lowValueMapper,
          highValueMapper,
          closeValueMapper
        ],
        <List<num>>[_lowValues, _highValues, _closeValues],
      );
    } else {
      if (seriesName != null) {
        if (dependent is FinancialSeriesRendererBase<T, D>) {
          final FinancialSeriesRendererBase<T, D> series =
              dependent! as FinancialSeriesRendererBase<T, D>;
          seriesDataSource = series.dataSource;
          xValues = series.xValues;
          xRawValues = series.xRawValues;
          _highValues = series.highValues;
          _lowValues = series.lowValues;
          _closeValues = series.closeValues;
          dataCount = xValues.length;
        }
      }
    }

    _signalLineActualValues.clear();
    if (signalLineWidth > 0 &&
        _highValues.isNotEmpty &&
        _lowValues.isNotEmpty &&
        _closeValues.isNotEmpty) {
      _calculateSignalLineValues();
    }

    populateChartPoints();
  }

  void _calculateSignalLineValues() {
    num xMinimum = double.infinity;
    num xMaximum = double.negativeInfinity;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;

    final List<Offset> averageOffsetValues = <Offset>[];
    num highClose = 0;
    num lowClose = 0;
    num average = 0;
    num sum = 0;
    for (int i = 0; i < dataCount; i++) {
      final double x = xValues[i].toDouble();
      final num high = _highValues[i].isNaN ? 0 : _highValues[i];
      final num low = _lowValues[i].isNaN ? 0 : _lowValues[i];
      final num highLow = high - low;

      if (i > 0) {
        final num high = _highValues[i].isNaN ? 0 : _highValues[i];
        final num low = _lowValues[i].isNaN ? 0 : _lowValues[i];
        final num close = _closeValues[i - 1].isNaN ? 0 : _closeValues[i - 1];
        highClose = (high - close).abs();
        lowClose = (low - close).abs();
      }

      final num range = max(highLow, highClose);
      final num trueRange = max(range, lowClose);
      sum += trueRange;
      if (i >= period && period > 0) {
        average = (averageOffsetValues[averageOffsetValues.length - 1].dy *
                    (period - 1) +
                trueRange) /
            period;

        final double y = average.toDouble();
        xMinimum = min(xMinimum, x);
        xMaximum = max(xMaximum, x);
        yMinimum = min(yMinimum, y);
        yMaximum = max(yMaximum, y);
        _signalLineActualValues.add(Offset(x, y));
      } else {
        average = sum / period;
        if (i == period - 1) {
          final double y = average.toDouble();
          xMinimum = min(xMinimum, x);
          xMaximum = max(xMaximum, x);
          yMinimum = min(yMinimum, y);
          yMaximum = max(yMaximum, y);
          _signalLineActualValues.add(Offset(x, y));
        }
      }
      averageOffsetValues.add(Offset(x, average.toDouble()));
    }

    xMin = xMinimum.isInfinite ? xMin : xMinimum;
    xMax = xMaximum.isInfinite ? xMax : xMaximum;
    yMin = yMinimum.isInfinite ? yMin : yMinimum;
    yMax = yMaximum.isInfinite ? yMax : yMaximum;
  }

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    yLists = <List<num>>[_highValues, _lowValues, _closeValues];
    positions = <ChartDataPointType>[
      ChartDataPointType.high,
      ChartDataPointType.low,
      ChartDataPointType.close,
    ];
    super.populateChartPoints(positions: positions, yLists: yLists);
  }

  @override
  String defaultLegendItemText() => 'ATR';

  @override
  Color effectiveLegendIconColor() => signalLineColor;

  @override
  void transformValues() {
    signalLinePoints.clear();
    if (_signalLineActualValues.isNotEmpty) {
      final int length = _signalLineActualValues.length;
      for (int i = 0; i < length; i++) {
        final num x = _signalLineActualValues[i].dx;
        final num y = _signalLineActualValues[i].dy;
        signalLinePoints.add(Offset(pointToPixelX(x, y), pointToPixelY(x, y)));
      }
    }
  }

  @override
  List<TrackballInfo>? trackballInfo(Offset position) {
    final int nearestPointIndex = _findNearestPoint(signalLinePoints, position);
    if (nearestPointIndex != -1) {
      final CartesianChartPoint<D> chartPoint = _chartPoint(nearestPointIndex);
      final String text = defaultLegendItemText();
      return <ChartTrackballInfo<T, D>>[
        ChartTrackballInfo<T, D>(
          position: signalLinePoints[nearestPointIndex],
          point: chartPoint,
          series: this,
          pointIndex: nearestPointIndex,
          seriesIndex: index,
          name: text,
          header: tooltipHeaderText(chartPoint),
          text: trackballText(chartPoint, text),
          color: signalLineColor,
          segmentIndex: nearestPointIndex,
        )
      ];
    }
    return null;
  }

  int _findNearestPoint(List<Offset> points, Offset position) {
    double delta = 0;
    num? nearPointX;
    num? nearPointY;
    int? pointIndex;
    final int length = points.length;
    for (int i = 0; i < length; i++) {
      nearPointX ??= points[0].dx;
      nearPointY ??= yAxis!.visibleRange!.minimum;

      final num touchXValue = position.dx;
      final num touchYValue = position.dy;
      final double curX = points[i].dx;
      final double curY = points[i].dy;
      if (isTransposed) {
        if (delta == touchYValue - curY) {
          pointIndex = i;
        } else if ((touchYValue - curY).abs() <=
            (touchYValue - nearPointY).abs()) {
          nearPointX = curX;
          nearPointY = curY;
          delta = touchYValue - curY;
          pointIndex = i;
        }
      } else {
        if (delta == touchXValue - curX) {
          pointIndex = i;
        } else if ((touchXValue - curX).abs() <=
            (touchXValue - nearPointX).abs()) {
          nearPointX = curX;
          nearPointY = curY;
          delta = touchXValue - curX;
          pointIndex = i;
        }
      }
    }
    return pointIndex ?? -1;
  }

  CartesianChartPoint<D> _chartPoint(int pointIndex) {
    return CartesianChartPoint<D>(
      x: xRawValues[pointIndex + period - 1],
      xValue: xValues[pointIndex + period - 1],
      y: _signalLineActualValues[pointIndex].dy,
    );
  }

  @override
  void customizeIndicator() {
    if (onRenderDetailsUpdate != null) {
      final IndicatorRenderParams params = IndicatorRenderParams(
        chartPoints,
        legendItemText ?? name ?? defaultLegendItemText(),
        signalLineWidth,
        signalLineColor,
        dashArray,
      );
      final TechnicalIndicatorRenderDetails details =
          onRenderDetailsUpdate!(params);
      strokePaint
        ..color = details.signalLineColor
        ..strokeWidth = details.signalLineWidth;
      _dashArray = details.signalLineDashArray;
    } else {
      strokePaint
        ..color = signalLineColor
        ..strokeWidth = signalLineWidth;
      _dashArray = dashArray;
    }
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    if (signalLinePoints.isNotEmpty) {
      context.canvas.save();
      final Rect clip = clipRect(paintBounds, animationFactor,
          isInversed: xAxis!.isInversed, isTransposed: isTransposed);
      context.canvas.clipRect(clip);

      final int length = signalLinePoints.length - 1;
      if (strokePaint.color != Colors.transparent &&
          strokePaint.strokeWidth > 0) {
        for (int i = 0; i < length; i++) {
          drawDashes(
            context.canvas,
            _dashArray,
            strokePaint,
            start: signalLinePoints[i],
            end: signalLinePoints[i + 1],
          );
        }
      }
      context.canvas.restore();
    }
  }

  @override
  void dispose() {
    _highValues.clear();
    _lowValues.clear();
    _closeValues.clear();
    _signalLineActualValues.clear();
    super.dispose();
  }
}
