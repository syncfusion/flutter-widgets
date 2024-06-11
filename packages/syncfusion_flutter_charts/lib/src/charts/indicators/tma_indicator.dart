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

/// Renders Triangular Moving Average (TMA) indicator.
///
/// The Triangular Moving Average (TMA) is a technical indicator similar to
/// other moving averages. The TMA shows the average (or average) price of an
/// asset over a specified number of data points over a period of time.
///
/// The technical indicator is rendered on the basis of the
/// [valueField] property.
@immutable
class TmaIndicator<T, D> extends TechnicalIndicator<T, D> {
  /// Creating an argument constructor of TmaIndicator class.
  TmaIndicator({
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
    ChartValueMapper<T, num>? openValueMapper,
    ChartValueMapper<T, num>? closeValueMapper,
    super.name,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.signalLineColor,
    super.signalLineWidth,
    this.period = 14,
    this.valueField = 'close',
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
          openValueMapper: openValueMapper != null && dataSource != null
              ? (int index) => openValueMapper(dataSource[index], index)
              : null,
          closeValueMapper: closeValueMapper != null && dataSource != null
              ? (int index) => closeValueMapper(dataSource[index], index)
              : null,
        );

  /// ValueField value for tma indicator.
  ///
  /// Value field determines the field for rendering the indicators.
  ///
  /// Defaults to `close`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      TmaIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        period: 4,
  ///        valueField: 'low'
  ///      ),
  ///    ],
  ///    series: <CartesianSeries<Sample, num>>[
  ///      HiloOpenCloseSeries<Sample, num>(
  ///        name: 'Series1'
  ///      )
  ///    ]
  ///  );
  /// }
  /// ```
  final String valueField;

  /// Period determines the start point for the rendering of
  /// technical indicators.
  ///
  /// Defaults to `14`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      TmaIndicator<Sample, num>(
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

    return other is TmaIndicator &&
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
        other.openValueMapper == openValueMapper &&
        other.closeValueMapper == closeValueMapper &&
        other.period == period &&
        other.name == name &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.signalLineColor == signalLineColor &&
        other.signalLineWidth == signalLineWidth &&
        other.valueField == valueField;
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
      openValueMapper,
      closeValueMapper,
      name,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      signalLineColor,
      signalLineWidth,
      valueField,
      period
    ];
    return Object.hashAll(values);
  }

  @override
  String toString() => 'TMA';
}

class TmaIndicatorWidget extends IndicatorWidget {
  const TmaIndicatorWidget({
    super.key,
    required super.vsync,
    required super.isTransposed,
    required super.indicator,
    required super.index,
    super.onLegendTapped,
    super.onLegendItemRender,
  });

  // Create the TmaIndicatorRenderer renderer.
  @override
  TmaIndicatorRenderer createRenderer() {
    return TmaIndicatorRenderer();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    final TmaIndicatorRenderer renderer =
        super.createRenderObject(context) as TmaIndicatorRenderer;
    final TmaIndicator tma = indicator as TmaIndicator;

    renderer
      ..highValueMapper = tma.highValueMapper
      ..lowValueMapper = tma.lowValueMapper
      ..openValueMapper = tma.openValueMapper
      ..closeValueMapper = tma.closeValueMapper
      ..valueField = tma.valueField
      ..period = tma.period;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, TmaIndicatorRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    final TmaIndicator tma = indicator as TmaIndicator;

    renderObject
      ..highValueMapper = tma.highValueMapper
      ..lowValueMapper = tma.lowValueMapper
      ..openValueMapper = tma.openValueMapper
      ..closeValueMapper = tma.closeValueMapper
      ..valueField = tma.valueField
      ..period = tma.period;
  }
}

class TmaIndicatorRenderer<T, D> extends IndicatorRenderer<T, D> {
  late List<double>? _dashArray;

  final List<Offset> _signalLineActualValues = <Offset>[];
  final List<num> _yValues = <num>[];
  List<num> _highValues = <num>[];
  List<num> _lowValues = <num>[];
  List<num> _openValues = <num>[];
  List<num> _closeValues = <num>[];

  String get valueField => _valueField;
  String _valueField = 'Close';
  set valueField(String value) {
    if (_valueField != value) {
      _valueField = value;
      markNeedsPopulateAndLayout();
    }
  }

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
    List<ChartIndexedValueMapper<num>?>? yPaths,
    List<List<num>?>? yList,
  ]) {
    if (dataSource != null) {
      super.populateDataSource(
        dataSource,
        xValueMapper,
        xValues,
        <ChartIndexedValueMapper<num?>?>[
          highValueMapper,
          lowValueMapper,
          openValueMapper,
          closeValueMapper
        ],
        <List<num>>[_highValues, _lowValues, _openValues, _closeValues],
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
          _openValues = series.openValues;
          _closeValues = series.closeValues;
          dataCount = xValues.length;
        }
      }
    }

    _signalLineActualValues.clear();
    _yValues.clear();
    if (dataCount >= period && period > 0 && signalLineWidth > 0) {
      _calculateSignalLineValues();
    }

    populateChartPoints();
  }

  void _calculateSignalLineValues() {
    num xMinimum = double.infinity;
    num xMaximum = double.negativeInfinity;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;

    num sum = 0;
    int l = 0;
    List<num> smaValues = <num>[];
    int length = dataCount;

    while (length >= period) {
      sum = 0;
      l = dataCount - length;
      for (int i = l; i < l + period; i++) {
        sum += _fieldValue(i, valueField);
      }
      sum = sum / period;
      _yValues.add(sum);
      smaValues.add(sum);
      length--;
    }

    for (int j = 0; j < period - 1; j++) {
      sum = 0;
      for (int k = 0; k < j + 1; k++) {
        sum += _fieldValue(k, valueField);
      }
      sum = sum / (j + 1);
      _yValues.add(sum);
      smaValues = _splice(smaValues, j, sum);
    }

    l = period;
    while (l <= smaValues.length) {
      sum = 0;
      for (int j = l - period; j < l; j++) {
        sum = sum + smaValues[j];
      }
      sum = sum / period;
      _yValues.add(sum);

      final double x = xValues[l - 1].toDouble();
      final double y = sum.toDouble();
      xMinimum = min(xMinimum, x);
      xMaximum = max(xMaximum, x);
      yMinimum = min(yMinimum, y);
      yMaximum = max(yMaximum, y);
      _signalLineActualValues.add(Offset(x, y));

      l++;
    }

    xMin = xMinimum.isInfinite ? xMin : xMinimum;
    xMax = xMaximum.isInfinite ? xMax : xMaximum;
    yMin = yMinimum.isInfinite ? yMin : yMinimum;
    yMax = yMaximum.isInfinite ? yMax : yMaximum;
  }

  List<num> _splice<num>(List<num> list, int index, num? elements) {
    if (elements != null) {
      list.insertAll(index, <num>[elements]);
    }
    return list;
  }

  num _fieldValue(int index, String valueField) {
    num value;
    if (valueField == 'low') {
      value = _lowValues[index];
    } else if (valueField == 'high') {
      value = _highValues[index];
    } else if (valueField == 'open') {
      value = _openValues[index];
    } else if (valueField == 'y') {
      value = _yValues[index];
    } else {
      value = _closeValues[index];
    }
    return value.isNaN ? 0 : value;
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
          segmentIndex: nearestPointIndex,
          seriesIndex: index,
          name: text,
          header: tooltipHeaderText(chartPoint),
          text: trackballText(chartPoint, text),
          color: signalLineColor,
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
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    yLists = <List<num>>[_highValues, _lowValues, _openValues, _closeValues];
    positions = <ChartDataPointType>[
      ChartDataPointType.high,
      ChartDataPointType.low,
      ChartDataPointType.open,
      ChartDataPointType.close,
    ];
    super.populateChartPoints(positions: positions, yLists: yLists);
  }

  @override
  String defaultLegendItemText() => 'TMA';

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
      final int length = signalLinePoints.length - 1;
      if (strokePaint.color != Colors.transparent &&
          strokePaint.strokeWidth > 0) {
        context.canvas.save();
        final Rect clip = clipRect(paintBounds, animationFactor,
            isInversed: xAxis!.isInversed, isTransposed: isTransposed);
        context.canvas.clipRect(clip);

        for (int i = 0; i < length; i++) {
          drawDashes(
            context.canvas,
            _dashArray,
            strokePaint,
            start: signalLinePoints[i],
            end: signalLinePoints[i + 1],
          );
        }

        context.canvas.restore();
      }
    }
  }

  @override
  void dispose() {
    _signalLineActualValues.clear();
    _yValues.clear();
    _highValues.clear();
    _lowValues.clear();
    _openValues.clear();
    _closeValues.clear();
    super.dispose();
  }
}
