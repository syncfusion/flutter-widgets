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

/// This class holds the properties of the Macd indicator.
///
/// The macd indicator has [shortPeriod] and [longPeriod] for defining the
/// motion of the indicator. Also, you can draw line, histogram macd or both
/// using the [macdType] property.
///
/// The [macdLineColor] property is used to define the color for the
/// macd line and the [histogramNegativeColor] and [histogramPositiveColor]
/// property is used to define the color for the macd histogram.
///
/// Provides the options of macd type, name, short Period, long period and macd
/// line color is used to customize the appearance.
@immutable
class MacdIndicator<T, D> extends TechnicalIndicator<T, D> {
  /// Creating an argument constructor of MacdIndicator class.
  MacdIndicator({
    super.isVisible,
    super.xAxisName,
    super.yAxisName,
    super.seriesName,
    super.dashArray,
    super.animationDuration,
    super.animationDelay,
    super.dataSource,
    ChartValueMapper<T, D>? xValueMapper,
    ChartValueMapper<T, num>? closeValueMapper,
    super.name,
    super.isVisibleInLegend,
    super.legendIconType,
    super.legendItemText,
    super.signalLineColor,
    super.signalLineWidth,
    this.period = 14,
    this.shortPeriod = 12,
    this.longPeriod = 26,
    this.macdLineColor = Colors.orange,
    this.macdLineWidth = 2,
    this.macdType = MacdType.both,
    this.histogramPositiveColor = Colors.green,
    this.histogramNegativeColor = Colors.red,
    super.onRenderDetailsUpdate,
  }) : super(
          xValueMapper: xValueMapper != null && dataSource != null
              ? (int index) => xValueMapper(dataSource[index], index)
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
  ///      MacdIndicator<Sample, num>(
  ///        period : 4
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final int period;

  /// Short period value of the macd indicator.
  ///
  /// Defaults to `12`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        shortPeriod: 2
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
  final int shortPeriod;

  /// Long period value of the macd indicator.
  ///
  /// Defaults to `26`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        longPeriod: 31
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
  final int longPeriod;

  /// Macd line color  of the macd indicator.
  ///
  /// Defaults to `Colors.orange`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        macdLineColor: Colors.red
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
  final Color macdLineColor;

  /// Macd line width  of the macd indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        macdLineWidth: 3
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
  final double macdLineWidth;

  /// Macd type line of the macd indicator.
  ///
  /// Defaults to `MacdType.both`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        macdType: MacdType.histogram
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
  final MacdType macdType;

  /// Histogram positive color of the macd indicator.
  ///
  /// Defaults to `Colors.green`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        macdType: MacdType.histogram,
  ///        histogramPositiveColor: Colors.red
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
  final Color histogramPositiveColor;

  /// Histogram negative color of the macd indicator.
  ///
  /// Defaults to `Colors.red`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        macdType: MacdType.histogram,
  ///        histogramNegativeColor: Colors.green
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
  final Color histogramNegativeColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MacdIndicator &&
        other.isVisible == isVisible &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.seriesName == seriesName &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.animationDelay == animationDelay &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.closeValueMapper == closeValueMapper &&
        other.period == period &&
        other.name == name &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.signalLineColor == signalLineColor &&
        other.signalLineWidth == signalLineWidth &&
        other.shortPeriod == shortPeriod &&
        other.longPeriod == longPeriod &&
        other.macdLineColor == macdLineColor &&
        other.macdLineWidth == macdLineWidth &&
        other.macdType == macdType &&
        other.histogramPositiveColor == histogramPositiveColor &&
        other.histogramNegativeColor == histogramNegativeColor;
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
      closeValueMapper,
      name,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      signalLineColor,
      signalLineWidth,
      period,
      shortPeriod,
      longPeriod,
      macdLineColor,
      macdLineWidth,
      macdType,
      histogramPositiveColor,
      histogramNegativeColor
    ];
    return Object.hashAll(values);
  }

  @override
  String toString() => 'MACD';
}

class MacdIndicatorWidget extends IndicatorWidget {
  const MacdIndicatorWidget({
    super.key,
    required super.vsync,
    required super.isTransposed,
    required super.indicator,
    required super.index,
    super.onLegendTapped,
    super.onLegendItemRender,
  });

  // Create the MacdIndicatorRenderer renderer.
  @override
  MacdIndicatorRenderer createRenderer() {
    return MacdIndicatorRenderer();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    final MacdIndicatorRenderer renderer =
        super.createRenderObject(context) as MacdIndicatorRenderer;
    final MacdIndicator macd = indicator as MacdIndicator;

    renderer
      ..closeValueMapper = macd.closeValueMapper
      ..period = macd.period
      ..shortPeriod = macd.shortPeriod
      ..longPeriod = macd.longPeriod
      ..macdLineColor = macd.macdLineColor
      ..macdLineWidth = macd.macdLineWidth
      ..macdType = macd.macdType
      ..histogramPositiveColor = macd.histogramPositiveColor
      ..histogramNegativeColor = macd.histogramNegativeColor;
    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, MacdIndicatorRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    final MacdIndicator macd = indicator as MacdIndicator;

    renderObject
      ..closeValueMapper = macd.closeValueMapper
      ..period = macd.period
      ..shortPeriod = macd.shortPeriod
      ..longPeriod = macd.longPeriod
      ..macdLineColor = macd.macdLineColor
      ..macdLineWidth = macd.macdLineWidth
      ..macdType = macd.macdType
      ..histogramPositiveColor = macd.histogramPositiveColor
      ..histogramNegativeColor = macd.histogramNegativeColor;
  }
}

class MacdIndicatorRenderer<T, D> extends IndicatorRenderer<T, D> {
  late num _bottom;
  late List<double>? _dashArray;

  final List<Offset> _macdLineActualValues = <Offset>[];
  final List<Offset> _signalLineActualValues = <Offset>[];
  final List<Offset> _histogramActualValues = <Offset>[];
  final List<Offset> _macdPoints = <Offset>[];
  final Path _macdPath = Path();
  final List<num> _yValues = <num>[];
  final List<Rect> _bounds = <Rect>[];
  List<num> _closeValues = <num>[];

  final List<CartesianChartPoint<D>> _macdChartPoints =
      <CartesianChartPoint<D>>[];
  final List<CartesianChartPoint<D>> _histogramChartPoints =
      <CartesianChartPoint<D>>[];

  num _xMinimum = double.infinity;
  num _xMaximum = double.negativeInfinity;
  num _yMinimum = double.infinity;
  num _yMaximum = double.negativeInfinity;

  int get period => _period;
  int _period = 14;
  set period(int value) {
    if (_period != value) {
      _period = value;
      markNeedsPopulateAndLayout();
    }
  }

  int get shortPeriod => _shortPeriod;
  int _shortPeriod = 12;
  set shortPeriod(int value) {
    if (_shortPeriod != value) {
      _shortPeriod = value;
      markNeedsPopulateAndLayout();
    }
  }

  int get longPeriod => _longPeriod;
  int _longPeriod = 26;
  set longPeriod(int value) {
    if (_longPeriod != value) {
      _longPeriod = value;
      markNeedsPopulateAndLayout();
    }
  }

  Color get macdLineColor => _macdLineColor;
  Color _macdLineColor = Colors.orange;
  set macdLineColor(Color value) {
    if (_macdLineColor != value) {
      _macdLineColor = value;
      markNeedsPaint();
    }
  }

  double get macdLineWidth => _macdLineWidth;
  double _macdLineWidth = 2;
  set macdLineWidth(double value) {
    if (_macdLineWidth != value) {
      _macdLineWidth = value;
      markNeedsPaint();
    }
  }

  MacdType get macdType => _macdType;
  MacdType _macdType = MacdType.both;
  set macdType(MacdType value) {
    if (_macdType != value) {
      _macdType = value;
      markNeedsPopulateAndLayout();
    }
  }

  Color get histogramPositiveColor => _histogramPositiveColor;
  Color _histogramPositiveColor = Colors.green;
  set histogramPositiveColor(Color value) {
    if (_histogramPositiveColor != value) {
      _histogramPositiveColor = value;
      markNeedsPaint();
    }
  }

  Color get histogramNegativeColor => _histogramNegativeColor;
  Color _histogramNegativeColor = Colors.red;
  set histogramNegativeColor(Color value) {
    if (_histogramNegativeColor != value) {
      _histogramNegativeColor = value;
      markNeedsPaint();
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
        <ChartIndexedValueMapper<num?>?>[closeValueMapper],
        <List<num>>[_closeValues],
      );
    } else {
      if (seriesName != null) {
        if (dependent is FinancialSeriesRendererBase<T, D>) {
          final FinancialSeriesRendererBase<T, D> series =
              dependent! as FinancialSeriesRendererBase<T, D>;
          seriesDataSource = series.dataSource;
          xValues = series.xValues;
          xRawValues = series.xRawValues;
          _closeValues = series.closeValues;
          dataCount = xValues.length;
        }
      }
    }

    _macdLineActualValues.clear();
    _signalLineActualValues.clear();
    _histogramActualValues.clear();
    _macdPoints.clear();

    final num fastPeriod = longPeriod;
    final num slowPeriod = shortPeriod;
    final num trigger = period;
    final num length = fastPeriod + trigger;

    if (length < dataCount &&
        slowPeriod <= fastPeriod &&
        slowPeriod > 0 &&
        period > 0 &&
        (length - 2) >= 0) {
      final List<num> shortEMA = _emaValues(slowPeriod, 'close');
      final List<num> longEMA = _emaValues(fastPeriod, 'close');
      final List<num> macdValues = _macdValues(shortEMA, longEMA);
      _calculateMACDValues(macdValues);

      final List<num> signalEMA = _emaValues(trigger, 'y');
      _calculateSignalValues(signalEMA);

      if (macdType == MacdType.histogram || macdType == MacdType.both) {
        _calculateHistogramValues(macdValues, signalEMA);
      }
    }

    xMin = _xMinimum.isInfinite ? xMin : _xMinimum;
    xMax = _xMaximum.isInfinite ? xMax : _xMaximum;
    yMin = _yMinimum.isInfinite ? yMin : _yMinimum;
    yMax = _yMaximum.isInfinite ? yMax : _yMaximum;

    populateChartPoints();
  }

  List<num> _emaValues(num period, String valueField) {
    num sum = 0;
    final List<num> emaValues = <num>[];
    final num emaPercent = 2 / (period + 1);
    for (int i = 0; i < period; i++) {
      sum += _fieldValue(i, valueField);
    }

    final num initialEMA = sum / period;
    emaValues.add(initialEMA);
    num emaAvg = initialEMA;
    final int start = period.toInt();
    final int end = valueField == 'close' ? dataCount : _yValues.length;
    for (int j = start; j < end; j++) {
      emaAvg = (_fieldValue(j, valueField) - emaAvg) * emaPercent + emaAvg;
      emaValues.add(emaAvg);
    }
    return emaValues;
  }

  num _fieldValue(int index, String valueField) {
    num? value;
    if (valueField == 'close') {
      value = _closeValues[index];
    } else {
      value = _yValues[index];
    }
    return value.isNaN ? 0 : value;
  }

  List<num> _macdValues(List<num> shortEma, List<num> longEma) {
    final List<num> macdPoints = <num>[];
    final int diff = longPeriod - shortPeriod;
    for (int i = 0; i < longEma.length; i++) {
      macdPoints.add(shortEma[i + diff] - longEma[i]);
    }
    return macdPoints;
  }

  void _calculateMACDValues(List<num> macdPoints) {
    if (macdLineWidth > 0) {
      int dataMACDIndex = longPeriod - 1;
      int macdIndex = 0;
      while (dataMACDIndex < dataCount) {
        final double x = xValues[dataMACDIndex].toDouble();
        final double y = macdPoints[macdIndex].toDouble();

        _xMinimum = min(_xMinimum, x);
        _xMaximum = max(_xMaximum, x);
        _yMinimum = min(_yMinimum, y);
        _yMaximum = max(_yMaximum, y);

        _yValues.add(y);
        _macdLineActualValues.add(Offset(x, y));

        dataMACDIndex++;
        macdIndex++;
      }
    }
  }

  void _calculateSignalValues(List<num> signalEma) {
    if (signalLineWidth > 0) {
      int index = longPeriod + period - 2;
      int signalIndex = 0;
      while (index < dataCount) {
        final double x = xValues[index].toDouble();
        final double y = signalEma[signalIndex].toDouble();
        _xMinimum = min(_xMinimum, x);
        _xMaximum = max(_xMaximum, x);
        _yMinimum = min(_yMinimum, y);
        _yMaximum = max(_yMaximum, y);
        _signalLineActualValues.add(Offset(x, y));

        index++;
        signalIndex++;
      }
    }
  }

  void _calculateHistogramValues(List<num> macdPoints, List<num> signalEma) {
    int index = longPeriod + period - 2;
    int histogramIndex = 0;
    while (index < dataCount) {
      final double x = xValues[index].toDouble();
      final double y = macdPoints[histogramIndex + (period - 1)] -
          signalEma[histogramIndex].toDouble();

      _xMinimum = min(_xMinimum, x);
      _xMaximum = max(_xMaximum, x);
      _yMinimum = min(_yMinimum, y);
      _yMaximum = max(_yMaximum, y);
      _histogramActualValues.add(Offset(x, y));

      index++;
      histogramIndex++;
    }
  }

  @override
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    yLists = <List<num>>[_closeValues];
    positions = <ChartDataPointType>[ChartDataPointType.close];

    chartPoints.clear();
    _macdChartPoints.clear();
    _histogramChartPoints.clear();

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

    if (_macdLineActualValues.isNotEmpty) {
      final int length = _macdLineActualValues.length;
      for (int i = 0; i < length; i++) {
        final CartesianChartPoint<D> point = CartesianChartPoint<D>(
          x: xRawValues[i],
          xValue: _macdLineActualValues[i].dx,
          y: _macdLineActualValues[i].dy,
        );
        _macdChartPoints.add(point);
      }
    }

    if (_histogramActualValues.isNotEmpty) {
      final int length = _histogramActualValues.length;
      for (int i = 0; i < length; i++) {
        final CartesianChartPoint<D> point = CartesianChartPoint<D>(
          x: xRawValues[i],
          xValue: _histogramActualValues[i].dx,
          y: _histogramActualValues[i].dy,
        );
        _histogramChartPoints.add(point);
      }
    }
  }

  @override
  List<TrackballInfo>? trackballInfo(Offset position) {
    final List<TrackballInfo> trackballInfo = [];
    if (macdType == MacdType.both || macdType == MacdType.line) {
      final int macdPointIndex = _findNearestPoint(signalLinePoints, position);
      if (macdPointIndex != -1) {
        final CartesianChartPoint<D> macdPoint =
            _chartPoint(macdPointIndex, 'macd');
        final String text = defaultLegendItemText();
        trackballInfo.add(
          ChartTrackballInfo<T, D>(
            position: signalLinePoints[macdPointIndex],
            point: macdPoint,
            series: this,
            pointIndex: macdPointIndex,
            segmentIndex: macdPointIndex,
            seriesIndex: index,
            name: text,
            header: tooltipHeaderText(macdPoint),
            text: trackballText(macdPoint, text),
            color: signalLineColor,
          ),
        );
      }

      final int macdLinePointIndex = _findNearestPoint(_macdPoints, position);
      if (macdLinePointIndex != -1) {
        final CartesianChartPoint<D> macdLinePoint =
            _chartPoint(macdLinePointIndex, 'macdLine');
        trackballInfo.add(
          ChartTrackballInfo<T, D>(
            position: _macdPoints[macdLinePointIndex],
            point: macdLinePoint,
            series: this,
            pointIndex: macdLinePointIndex,
            segmentIndex: macdLinePointIndex,
            seriesIndex: index,
            name: trackballMACDLineText,
            header: tooltipHeaderText(macdLinePoint),
            text: trackballText(macdLinePoint, trackballMACDLineText),
            color: _macdLineColor,
          ),
        );
      }
    }

    if (macdType == MacdType.both || macdType == MacdType.histogram) {
      final int histogramPointIndex = _findNearestPoint(
          List<Offset>.generate(
              _bounds.length, (int index) => _bounds[index].center).toList(),
          position);
      if (histogramPointIndex != -1) {
        final CartesianChartPoint<D> histogramPoint =
            _chartPoint(histogramPointIndex, 'histogram');
        final Offset histogramPosition = Offset(
            xAxis!.pointToPixel(_histogramActualValues[histogramPointIndex].dx),
            yAxis!.pointToPixel(
                _histogramActualValues[histogramPointIndex].dy.abs()));
        trackballInfo.add(
          ChartTrackballInfo<T, D>(
            position: histogramPosition,
            point: histogramPoint,
            series: this,
            pointIndex: histogramPointIndex,
            segmentIndex: histogramPointIndex,
            seriesIndex: index,
            name: trackballHistogramText,
            header: tooltipHeaderText(histogramPoint),
            text: trackballText(histogramPoint, trackballHistogramText),
            color: histogramPoint.y!.isNegative
                ? histogramNegativeColor
                : histogramPositiveColor,
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
      x: type == 'macd'
          ? xRawValues[
              pointIndex + (signalLinePoints.length - xRawValues.length).abs()]
          : type == 'macdLine'
              ? xRawValues[
                  pointIndex + (_macdPoints.length - xRawValues.length).abs()]
              : xRawValues[pointIndex +
                  (_histogramActualValues.length - xRawValues.length).abs()],
      xValue: type == 'macd'
          ? xValues[
              pointIndex + (signalLinePoints.length - xValues.length).abs()]
          : type == 'macdLine'
              ? xValues[
                  pointIndex + (_macdPoints.length - xValues.length).abs()]
              : _histogramActualValues[pointIndex].dx,
      y: type == 'macd'
          ? _signalLineActualValues[pointIndex].dy
          : type == 'macdLine'
              ? _macdLineActualValues[pointIndex].dy
              : _histogramActualValues[pointIndex].dy,
    );
  }

  @override
  void customizeIndicator() {
    if (onRenderDetailsUpdate != null) {
      final MacdIndicatorRenderParams params = MacdIndicatorRenderParams(
        _macdChartPoints,
        _histogramChartPoints,
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
  String defaultLegendItemText() => 'MACD';

  @override
  Color effectiveLegendIconColor() => signalLineColor;

  @override
  void transformValues() {
    _bounds.clear();
    _macdPoints.clear();
    signalLinePoints.clear();
    _macdPath.reset();

    if (_macdLineActualValues.isNotEmpty) {
      _transformCollections(_macdLineActualValues, _macdPoints);
    }

    if (_signalLineActualValues.isNotEmpty) {
      _transformCollections(_signalLineActualValues, signalLinePoints);
    }

    if (_histogramActualValues.isNotEmpty) {
      _bottom = xAxis!.crossesAt ?? max(yAxis!.visibleRange!.minimum, 0);
      num sbsMin = -0.35;
      num sbsMax = 0.35;
      if (dependent != null && dependent! is SbsSeriesMixin<T, D>) {
        sbsMin = (dependent! as SbsSeriesMixin<T, D>).sbsInfo.minimum;
        sbsMax = (dependent! as SbsSeriesMixin<T, D>).sbsInfo.maximum;
      }

      final int histoLength = _histogramActualValues.length;
      for (int i = 0; i < histoLength; i++) {
        final Offset point = _histogramActualValues[i];
        final num leftValue = point.dx + sbsMin;
        final num rightValue = point.dx + sbsMax;
        final num topValue = point.dy;
        final num bottomValue = _bottom.toDouble();

        final double left = pointToPixelX(leftValue, topValue);
        final double top = pointToPixelY(leftValue, topValue);
        final double right = pointToPixelX(rightValue, bottomValue);
        final double bottoms = pointToPixelY(rightValue, bottomValue);

        _bounds.add(Rect.fromLTRB(left, top, right, bottoms));
      }
    }
  }

  void _transformCollections(List<Offset> collections, List<Offset> points) {
    final int length = collections.length;
    for (int i = 0; i < length; i++) {
      final num x = collections[i].dx;
      final num y = collections[i].dy;
      points.add(Offset(pointToPixelX(x, y), pointToPixelY(x, y)));
    }
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    context.canvas.save();
    final Rect clip = clipRect(paintBounds, animationFactor,
        isInversed: xAxis!.isInversed, isTransposed: isTransposed);
    context.canvas.clipRect(clip);
    int length = signalLinePoints.length - 1;
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

    if (macdType == MacdType.both || macdType == MacdType.line) {
      if (_macdPoints.isNotEmpty) {
        final Paint paint = Paint()
          ..isAntiAlias = true
          ..color = macdLineColor
          ..strokeWidth = macdLineWidth
          ..style = PaintingStyle.stroke;
        if (paint.color != Colors.transparent && paint.strokeWidth > 0) {
          _macdPath.reset();
          length = _macdPoints.length;

          _macdPath.moveTo(_macdPoints.first.dx, _macdPoints.first.dy);
          for (int i = 1; i < length; i++) {
            _macdPath.lineTo(_macdPoints[i].dx, _macdPoints[i].dy);
          }

          drawDashes(context.canvas, _dashArray, paint, path: _macdPath);
        }
      }
    }

    if (macdType == MacdType.both || macdType == MacdType.histogram) {
      if (_bounds.isNotEmpty && _histogramActualValues.isNotEmpty) {
        length = _histogramActualValues.length;
        for (int i = 0; i < length; i++) {
          if (_histogramActualValues[i].dy > _bottom) {
            fillPaint.color = histogramPositiveColor;
          } else {
            fillPaint.color = histogramNegativeColor;
          }

          if (fillPaint.color != Colors.transparent) {
            context.canvas.drawRect(_bounds[i], fillPaint);
          }
        }
      }
    }
    context.canvas.restore();
  }

  @override
  void dispose() {
    _bounds.clear();
    _macdLineActualValues.clear();
    _macdPoints.clear();
    _signalLineActualValues.clear();
    _histogramActualValues.clear();
    signalLinePoints.clear();
    _macdPath.reset();
    _closeValues.clear();
    _yValues.clear();
    _macdChartPoints.clear();
    _histogramChartPoints.clear();
    super.dispose();
  }
}
