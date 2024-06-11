import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

import '../behaviors/trackball.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../series/chart_series.dart';
import '../utils/constants.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'technical_indicator.dart';

/// Renders stochastic indicator.
///
/// The stochastic indicator  is used to measure the range and momentum of price
/// movements. It contains kPeriod and dPeriod properties defining
/// the ‘k’ percentage and ‘d’ percentage respectively.
///
/// In this indicator [upperLineColor], [lowerLineColor] and [periodLineColor]
/// property are used to define the color for the stochastic indicator lines.
@immutable
class StochasticIndicator<T, D> extends TechnicalIndicator<T, D> {
  /// Creating an argument constructor of StochasticIndicator class.
  StochasticIndicator({
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
    this.showZones = true,
    this.overbought = 80,
    this.oversold = 20,
    this.upperLineColor = Colors.red,
    this.upperLineWidth = 2,
    this.lowerLineColor = Colors.green,
    this.lowerLineWidth = 2,
    this.periodLineColor = Colors.yellow,
    this.periodLineWidth = 2,
    this.kPeriod = 3,
    this.dPeriod = 5,
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

  /// Show zones boolean value for stochastic indicator.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        showZones : false
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
  final bool showZones;

  /// Overbought value for stochastic indicator
  ///
  /// Defaults to `80`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        overbought: 50
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
  final double overbought;

  /// Oversold value for stochastic Indicator.
  ///
  /// Defaults to `20`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        oversold: 30
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
  final double oversold;

  /// Color of the upper line for stochastic Indicator.
  ///
  /// Defaults to `Colors.red`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        upperLineColor: Colors.greenAccent
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
  final Color upperLineColor;

  /// Width of the upper line for stochastic Indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        upperLineWidth: 4.0
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
  final double upperLineWidth;

  /// Color of the lower line for stochastic Indicator.
  ///
  /// Defaults to `Colors.green`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        lowerLineColor: Colors.blue
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
  final Color lowerLineColor;

  /// Width of lower line for stochastic Indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        lowerLineWidth: 4.0
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
  final double lowerLineWidth;

  /// Color of the period line for stochastic Indicator.
  ///
  /// Defaults to `Colors.yellow`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        periodLineColor: Colors.orange
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
  final Color periodLineColor;

  /// Width of the period line for stochastic Indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        periodLineWidth: 5.0
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
  final double periodLineWidth;

  /// Period determines the start point for the rendering of
  /// technical indicators.
  ///
  /// Defaults to `14`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        period : 4
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final int period;

  /// Value of kPeriod  in stochastic Indicator.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        kPeriod: 4
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
  final num kPeriod;

  /// Value of dPeriod  in stochastic Indicator.
  ///
  /// Defaults to `5`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        dPeriod: 4
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
  final num dPeriod;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is StochasticIndicator &&
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
        other.showZones == showZones &&
        other.overbought == overbought &&
        other.oversold == oversold &&
        other.upperLineColor == upperLineColor &&
        other.upperLineWidth == upperLineWidth &&
        other.lowerLineColor == lowerLineColor &&
        other.lowerLineWidth == lowerLineWidth &&
        other.periodLineColor == periodLineColor &&
        other.periodLineWidth == periodLineWidth &&
        other.kPeriod == kPeriod &&
        other.dPeriod == dPeriod;
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
      period,
      showZones,
      overbought,
      oversold,
      upperLineColor,
      upperLineWidth,
      lowerLineColor,
      lowerLineWidth,
      periodLineColor,
      periodLineWidth,
      kPeriod,
      dPeriod
    ];
    return Object.hashAll(values);
  }

  @override
  String toString() => 'Stochastic';
}

class StochasticIndicatorWidget extends IndicatorWidget {
  const StochasticIndicatorWidget({
    super.key,
    required super.vsync,
    required super.isTransposed,
    required super.indicator,
    required super.index,
    super.onLegendTapped,
    super.onLegendItemRender,
  });

  // Create the StochasticIndicatorRenderer renderer.
  @override
  StochasticIndicatorRenderer createRenderer() {
    return StochasticIndicatorRenderer();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    final StochasticIndicatorRenderer renderer =
        super.createRenderObject(context) as StochasticIndicatorRenderer;
    final StochasticIndicator stochastic = indicator as StochasticIndicator;

    renderer
      ..highValueMapper = stochastic.highValueMapper
      ..lowValueMapper = stochastic.lowValueMapper
      ..highValueMapper = stochastic.highValueMapper
      ..closeValueMapper = stochastic.closeValueMapper
      ..showZones = stochastic.showZones
      ..overbought = stochastic.overbought
      ..oversold = stochastic.oversold
      ..upperLineColor = stochastic.upperLineColor
      ..upperLineWidth = stochastic.upperLineWidth
      ..lowerLineColor = stochastic.lowerLineColor
      ..lowerLineWidth = stochastic.lowerLineWidth
      ..periodLineColor = stochastic.periodLineColor
      ..periodLineWidth = stochastic.periodLineWidth
      ..period = stochastic.period
      ..kPeriod = stochastic.kPeriod
      ..dPeriod = stochastic.dPeriod;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, StochasticIndicatorRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    final StochasticIndicator stochastic = indicator as StochasticIndicator;

    renderObject
      ..highValueMapper = stochastic.highValueMapper
      ..lowValueMapper = stochastic.lowValueMapper
      ..highValueMapper = stochastic.highValueMapper
      ..closeValueMapper = stochastic.closeValueMapper
      ..showZones = stochastic.showZones
      ..overbought = stochastic.overbought
      ..oversold = stochastic.oversold
      ..upperLineColor = stochastic.upperLineColor
      ..upperLineWidth = stochastic.upperLineWidth
      ..lowerLineColor = stochastic.lowerLineColor
      ..lowerLineWidth = stochastic.lowerLineWidth
      ..periodLineColor = stochastic.periodLineColor
      ..periodLineWidth = stochastic.periodLineWidth
      ..period = stochastic.period
      ..kPeriod = stochastic.kPeriod
      ..dPeriod = stochastic.dPeriod;
  }
}

class StochasticIndicatorRenderer<T, D> extends IndicatorRenderer<T, D> {
  late List<double>? _dashArray;

  List<num> _highValues = <num>[];
  List<num> _lowValues = <num>[];
  List<num> _openValues = <num>[];
  List<num> _closeValues = <num>[];

  final List<Offset> _signalLineActualValues = <Offset>[];
  final List<Offset> _periodLineActualValues = <Offset>[];
  final List<Offset> _lowerLineActualValues = <Offset>[];
  final List<Offset> _upperLineActualValues = <Offset>[];

  final List<Offset> _upperLinePoints = <Offset>[];
  final List<Offset> _lowerLinePoints = <Offset>[];
  final List<Offset> _periodLinePoints = <Offset>[];
  final Path _upperLinePath = Path();
  final Path _lowerLinePath = Path();

  final List<CartesianChartPoint<D>> _periodChartPoints =
      <CartesianChartPoint<D>>[];

  num _xMinimum = double.infinity;
  num _xMaximum = double.negativeInfinity;
  num _yMinimum = double.infinity;
  num _yMaximum = double.negativeInfinity;

  bool get showZones => _showZones;
  bool _showZones = true;
  set showZones(bool value) {
    if (_showZones != value) {
      _showZones = value;
      markNeedsPaint();
    }
  }

  double get overbought => _overbought;
  double _overbought = 80;
  set overbought(double value) {
    if (_overbought != value) {
      _overbought = value;
      markNeedsPopulateAndLayout();
    }
  }

  double get oversold => _oversold;
  double _oversold = 20;
  set oversold(double value) {
    if (_oversold != value) {
      _oversold = value;
      markNeedsPopulateAndLayout();
    }
  }

  Color get upperLineColor => _upperLineColor;
  Color _upperLineColor = Colors.red;
  set upperLineColor(Color value) {
    if (_upperLineColor != value) {
      _upperLineColor = value;
      markNeedsPaint();
    }
  }

  double get upperLineWidth => _upperLineWidth;
  double _upperLineWidth = 2;
  set upperLineWidth(double value) {
    if (_upperLineWidth != value) {
      _upperLineWidth = value;
      markNeedsPaint();
    }
  }

  Color get lowerLineColor => _lowerLineColor;
  Color _lowerLineColor = Colors.green;
  set lowerLineColor(Color value) {
    if (_lowerLineColor != value) {
      _lowerLineColor = value;
      markNeedsPaint();
    }
  }

  double get lowerLineWidth => _lowerLineWidth;
  double _lowerLineWidth = 2;
  set lowerLineWidth(double value) {
    if (_lowerLineWidth != value) {
      _lowerLineWidth = value;
      markNeedsPaint();
    }
  }

  Color get periodLineColor => _periodLineColor;
  Color _periodLineColor = Colors.yellow;
  set periodLineColor(Color value) {
    if (_periodLineColor != value) {
      _periodLineColor = value;
      markNeedsPaint();
    }
  }

  double get periodLineWidth => _periodLineWidth;
  double _periodLineWidth = 2;
  set periodLineWidth(double value) {
    if (_periodLineWidth != value) {
      _periodLineWidth = value;
      markNeedsPaint();
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

  num get kPeriod => _kPeriod;
  num _kPeriod = 3;
  set kPeriod(num value) {
    if (_kPeriod != value) {
      _kPeriod = value;
      markNeedsPopulateAndLayout();
    }
  }

  num get dPeriod => _dPeriod;
  num _dPeriod = 5;
  set dPeriod(num value) {
    if (_dPeriod != value) {
      _dPeriod = value;
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

    if (dataCount >= period && period > 0) {
      _upperLineActualValues.clear();
      _lowerLineActualValues.clear();
      _signalLineActualValues.clear();
      _periodLineActualValues.clear();

      _calculateZones();
      _calculateStochasticIndicatorValues();
    }

    xMin = _xMinimum.isInfinite ? xMin : _xMinimum;
    xMax = _xMaximum.isInfinite ? xMax : _xMaximum;
    yMin = _yMinimum.isInfinite ? yMin : _yMinimum;
    yMax = _yMaximum.isInfinite ? yMax : _yMaximum;

    populateChartPoints();
  }

  void _calculateZones() {
    if (!showZones || (upperLineWidth <= 0 && lowerLineWidth <= 0)) {
      return;
    }

    for (int i = 0; i < dataCount; i++) {
      final double x = xValues[i].toDouble();
      if (upperLineWidth > 0) {
        _upperLineActualValues.add(Offset(x, overbought));
      }

      if (lowerLineWidth > 0) {
        _lowerLineActualValues.add(Offset(x, oversold));
      }

      _xMinimum = min(_xMinimum, x);
      _xMaximum = max(_xMaximum, x);
    }

    _yMinimum = min(_yMinimum, min(overbought, oversold));
    _yMaximum = max(_yMaximum, max(overbought, oversold));
  }

  void _calculateStochasticIndicatorValues() {
    final List<Offset> source = _calculatePeriodValues(period, kPeriod.toInt());
    if (periodLineWidth > 0) {
      _periodLineActualValues
          .addAll(_calculateStochasticValues(period, kPeriod.toInt(), source));
    }

    if (signalLineWidth > 0) {
      _signalLineActualValues.addAll(_calculateStochasticValues(
          (period + kPeriod - 1).toInt(), dPeriod.toInt(), source));
    }
  }

  List<Offset> _calculateStochasticValues(
      int period, int kPeriod, List<Offset> data) {
    final List<Offset> points = <Offset>[];
    final int dataLength = data.length;
    if (dataLength >= period + kPeriod && kPeriod > 0) {
      final int count = period + (kPeriod - 1);
      final List<num> temp = <num>[], values = <num>[];
      for (int i = 0; i < dataLength; i++) {
        temp.add(data[i].dy);
      }

      num tempCount = temp.length;
      while (tempCount >= count) {
        num sum = 0;
        for (int i = period - 1; i < (period + kPeriod - 1); i++) {
          sum = sum + temp[i];
        }
        sum = sum / kPeriod;
        final String stochasticSum = sum.toStringAsFixed(2);
        values.add(double.parse(stochasticSum));
        temp.removeRange(0, 1);
        tempCount = temp.length;
      }

      final int total = count - 1;
      for (int i = 0; i < dataLength; i++) {
        if (!(i < total)) {
          final double x = data[i].dx;
          final double y = values[i - total].toDouble();
          _xMinimum = min(_xMinimum, x);
          _xMaximum = max(_xMaximum, x);
          _yMinimum = min(_yMinimum, y);
          _yMaximum = max(_yMaximum, y);

          final Offset offset = Offset(x, y);
          points.add(offset);
          data[i] = offset;
        }
      }
    }

    return points;
  }

  List<Offset> _calculatePeriodValues(int period, int kPeriod) {
    if (_lowValues.isEmpty || _highValues.isEmpty || _closeValues.isEmpty) {
      return <Offset>[];
    }

    final List<num> lowValues = List<num>.filled(dataCount, -1);
    final List<num> highValues = List<num>.filled(dataCount, -1);
    final List<num> closeValues = List<num>.filled(dataCount, -1);
    final List<Offset> modifiedSourceValues = <Offset>[];

    for (int j = 0; j < dataCount; j++) {
      lowValues[j] = _lowValues[j].isNaN ? 0 : _lowValues[j];
      highValues[j] = _highValues[j].isNaN ? 0 : _highValues[j];
      closeValues[j] = _closeValues[j].isNaN ? 0 : _closeValues[j];
    }

    if (dataCount > period) {
      final List<num> minValues = <num>[];
      final List<num> maxValues = <num>[];
      for (int i = 0; i < period - 1; ++i) {
        maxValues.add(0);
        minValues.add(0);

        final double x = xValues[i].toDouble();
        double y = _closeValues[i].toDouble();
        if (y.isNaN) {
          y = 0.0;
        }

        _xMinimum = min(_xMinimum, x);
        _xMaximum = max(_xMaximum, x);
        _yMinimum = min(_yMinimum, y);
        _yMaximum = max(_yMaximum, y);
        modifiedSourceValues.add(Offset(xValues[i].toDouble(), y));
      }

      num? minValue, maxValue;
      for (int i = period - 1; i < dataCount; ++i) {
        for (int j = 0; j < period; ++j) {
          minValue ??= lowValues[i - j];
          maxValue ??= highValues[i - j];
          minValue = math.min(minValue, lowValues[i - j]);
          maxValue = math.max(maxValue, highValues[i - j]);
        }
        maxValues.add(maxValue!);
        minValues.add(minValue!);
        minValue = null;
        maxValue = null;
      }

      for (int i = period - 1; i < dataCount; ++i) {
        num top = 0, bottom = 0;
        top += closeValues[i] - minValues[i];
        bottom += maxValues[i] - minValues[i];

        final double x = xValues[i].toDouble();
        final double y = (top / bottom) * 100;
        _xMinimum = min(_xMinimum, x);
        _xMaximum = max(_xMaximum, x);
        _yMinimum = min(_yMinimum, y);
        _yMaximum = max(_yMaximum, y);
        modifiedSourceValues.add(Offset(x, y));
      }
    }

    return modifiedSourceValues;
  }

  @override
  List<TrackballInfo>? trackballInfo(Offset position) {
    final List<TrackballInfo> trackballInfo = [];
    final int stocasticPointIndex =
        _findNearestPoint(signalLinePoints, position);
    if (stocasticPointIndex != -1) {
      final CartesianChartPoint<D> stocasticPoint =
          _chartPoint(stocasticPointIndex, 'stocastic');
      final String stocasticText = defaultLegendItemText();
      trackballInfo.add(
        ChartTrackballInfo<T, D>(
          position: signalLinePoints[stocasticPointIndex],
          point: stocasticPoint,
          series: this,
          pointIndex: stocasticPointIndex,
          segmentIndex: stocasticPointIndex,
          seriesIndex: index,
          name: stocasticText,
          header: tooltipHeaderText(stocasticPoint),
          text: trackballText(stocasticPoint, stocasticText),
          color: signalLineColor,
        ),
      );
    }
    final int periodPointIndex = _findNearestPoint(_periodLinePoints, position);
    if (periodPointIndex != -1) {
      final CartesianChartPoint<D> periodPoint =
          _chartPoint(periodPointIndex, 'periodLine');
      trackballInfo.add(
        ChartTrackballInfo<T, D>(
          position: _periodLinePoints[periodPointIndex],
          point: periodPoint,
          series: this,
          pointIndex: periodPointIndex,
          segmentIndex: periodPointIndex,
          seriesIndex: index,
          name: trackballPeriodLineText,
          header: tooltipHeaderText(periodPoint),
          text: trackballText(periodPoint, trackballPeriodLineText),
          color: periodLineColor,
        ),
      );
    }
    if (showZones) {
      final int upperPointIndex = _findNearestPoint(_upperLinePoints, position);
      if (upperPointIndex != -1) {
        final CartesianChartPoint<D> upperPoint =
            _chartPoint(upperPointIndex, 'upperLine');
        trackballInfo.add(
          ChartTrackballInfo<T, D>(
            position: _upperLinePoints[upperPointIndex],
            point: upperPoint,
            series: this,
            pointIndex: upperPointIndex,
            segmentIndex: upperPointIndex,
            seriesIndex: index,
            name: trackballUpperLineText,
            header: tooltipHeaderText(upperPoint),
            text: trackballText(upperPoint, trackballUpperLineText),
            color: upperLineColor,
          ),
        );
      }
      final int lowerPointIndex = _findNearestPoint(_lowerLinePoints, position);
      if (lowerPointIndex != -1) {
        final CartesianChartPoint<D> lowerPoint =
            _chartPoint(lowerPointIndex, 'lowerLine');
        trackballInfo.add(
          ChartTrackballInfo<T, D>(
            position: _lowerLinePoints[lowerPointIndex],
            point: lowerPoint,
            series: this,
            pointIndex: lowerPointIndex,
            segmentIndex: lowerPointIndex,
            seriesIndex: index,
            name: trackballLowerLineText,
            header: tooltipHeaderText(lowerPoint),
            text: trackballText(lowerPoint, trackballLowerLineText),
            color: lowerLineColor,
          ),
        );
      }
    }
    return trackballInfo;
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

  CartesianChartPoint<D> _chartPoint(int pointIndex, String type) {
    return CartesianChartPoint<D>(
        x: type == 'stocastic'
            ? xRawValues[pointIndex +
                (signalLinePoints.length - xRawValues.length).abs()]
            : type == 'periodLine'
                ? xRawValues[pointIndex +
                    (_periodLinePoints.length - xRawValues.length).abs()]
                : xRawValues[pointIndex],
        xValue: type == 'stocastic'
            ? xValues[pointIndex +
                (signalLinePoints.length - xRawValues.length).abs()]
            : type == 'periodLine'
                ? xValues[pointIndex +
                    (_periodLinePoints.length - xValues.length).abs()]
                : xValues[pointIndex],
        y: type == 'stocastic'
            ? _signalLineActualValues[pointIndex].dy
            : type == 'periodLine'
                ? _periodLineActualValues[pointIndex].dy
                : type == 'upperLine'
                    ? _upperLineActualValues[pointIndex].dy
                    : _lowerLineActualValues[pointIndex].dy);
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

    chartPoints.clear();
    _periodChartPoints.clear();

    if (parent == null || yLists.isEmpty) {
      return;
    }

    if (onRenderDetailsUpdate == null) {
      return;
    }

    final int yLength = yLists.length;
    if (positions.length != yLength) {
      return;
    }

    for (int i = 0; i < dataCount; i++) {
      final num xValue = xValues[i];
      final CartesianChartPoint<D> point =
          CartesianChartPoint<D>(x: xRawValues[i], xValue: xValue);
      for (int j = 0; j < yLength; j++) {
        point[positions[j]] = yLists[j][i];
      }
      chartPoints.add(point);
    }

    if (_periodLineActualValues.isNotEmpty) {
      final int length = _periodLineActualValues.length;
      for (int i = 0; i < length; i++) {
        final CartesianChartPoint<D> point = CartesianChartPoint<D>(
          x: xRawValues[i],
          xValue: _periodLineActualValues[i].dx,
          y: _periodLineActualValues[i].dy,
        );
        _periodChartPoints.add(point);
      }
    }
  }

  @override
  String defaultLegendItemText() => 'Stochastic';

  @override
  Color effectiveLegendIconColor() => signalLineColor;

  @override
  void transformValues() {
    signalLinePoints.clear();
    _upperLinePoints.clear();
    _lowerLinePoints.clear();
    _periodLinePoints.clear();

    if (showZones) {
      if (_upperLineActualValues.isNotEmpty) {
        final int length = _upperLineActualValues.length;
        for (int i = 0; i < length; i++) {
          final num x = _upperLineActualValues[i].dx;
          final num y = _upperLineActualValues[i].dy;
          _upperLinePoints
              .add(Offset(pointToPixelX(x, y), pointToPixelY(x, y)));
        }
      }

      if (_lowerLineActualValues.isNotEmpty) {
        final int length = _lowerLineActualValues.length;
        for (int i = 0; i < length; i++) {
          final num x = _lowerLineActualValues[i].dx;
          final num y = _lowerLineActualValues[i].dy;
          _lowerLinePoints
              .add(Offset(pointToPixelX(x, y), pointToPixelY(x, y)));
        }
      }
    }

    if (_periodLineActualValues.isNotEmpty) {
      final int length = _periodLineActualValues.length;
      for (int i = 0; i < length; i++) {
        final num x = _periodLineActualValues[i].dx;
        final num y = _periodLineActualValues[i].dy;
        _periodLinePoints.add(Offset(pointToPixelX(x, y), pointToPixelY(x, y)));
      }
    }

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
      final StochasticIndicatorRenderParams params =
          StochasticIndicatorRenderParams(
        _periodChartPoints,
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
    int length = signalLinePoints.length - 1;

    context.canvas.save();
    final Rect clip = clipRect(paintBounds, animationFactor,
        isInversed: xAxis!.isInversed, isTransposed: isTransposed);
    context.canvas.clipRect(clip);

    strokePaint
      ..color = signalLineColor
      ..strokeWidth = signalLineWidth;
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

    if (_periodLinePoints.isNotEmpty) {
      length = _periodLinePoints.length - 1;
      strokePaint
        ..color = periodLineColor
        ..strokeWidth = periodLineWidth;
      if (strokePaint.color != Colors.transparent &&
          strokePaint.strokeWidth > 0) {
        for (int i = 0; i < length; i++) {
          drawDashes(
            context.canvas,
            _dashArray,
            strokePaint,
            start: _periodLinePoints[i],
            end: _periodLinePoints[i + 1],
          );
        }
      }
    }

    if (showZones &&
        _upperLinePoints.isNotEmpty &&
        upperLineWidth > 0 &&
        upperLineColor != Colors.transparent) {
      _upperLinePath.reset();
      length = _upperLinePoints.length;

      _upperLinePath.moveTo(
          _upperLinePoints.first.dx, _upperLinePoints.first.dy);
      for (int i = 1; i < length; i++) {
        _upperLinePath.lineTo(_upperLinePoints[i].dx, _upperLinePoints[i].dy);
      }

      drawDashes(
          context.canvas,
          _dashArray,
          strokePaint
            ..color = upperLineColor
            ..strokeWidth = upperLineWidth,
          path: _upperLinePath);
    }

    // Draw lower line.
    if (showZones &&
        _lowerLinePoints.isNotEmpty &&
        lowerLineWidth > 0 &&
        lowerLineColor != Colors.transparent) {
      _lowerLinePath.reset();
      length = _lowerLinePoints.length;

      _lowerLinePath.moveTo(
          _lowerLinePoints.first.dx, _lowerLinePoints.first.dy);
      for (int i = 1; i < length; i++) {
        _lowerLinePath.lineTo(_lowerLinePoints[i].dx, _lowerLinePoints[i].dy);
      }

      drawDashes(
          context.canvas,
          _dashArray,
          strokePaint
            ..color = lowerLineColor
            ..strokeWidth = lowerLineWidth,
          path: _lowerLinePath);
    }

    context.canvas.restore();
  }

  @override
  void dispose() {
    signalLinePoints.clear();
    _upperLinePoints.clear();
    _lowerLinePoints.clear();
    _periodLinePoints.clear();
    _upperLineActualValues.clear();
    _lowerLineActualValues.clear();
    _signalLineActualValues.clear();
    _periodLineActualValues.clear();
    _upperLinePath.reset();
    _lowerLinePath.reset();
    _highValues.clear();
    _lowValues.clear();
    _openValues.clear();
    _closeValues.clear();
    _periodChartPoints.clear();
    super.dispose();
  }
}
