import 'dart:math';

import 'package:flutter/material.dart';

import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../interactions/trackball.dart';
import '../series/chart_series.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';
import 'technical_indicator.dart';

/// Renders relative strength index (RSI) indicator.
///
/// The relative strength index (RSI) is a momentum indicator that measures the
/// magnitude of recent price changes to evaluate [overbought] or [oversold]
/// conditions.
///
/// The RSI indicator has additional two lines other than the signal line. They
/// indicate the [overbought] and [oversold] region.
///
/// The [upperLineColor] property is used to define the color for the line that
/// indicates [overbought] region, and the [lowerLineColor] property is used
/// to define the color for the line that indicates [oversold] region.
@immutable
class RsiIndicator<T, D> extends TechnicalIndicator<T, D> {
  /// Creating an argument constructor of RsiIndicator class.
  RsiIndicator({
    super.isVisible = true,
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
    this.showZones = true,
    this.overbought = 80,
    this.oversold = 20,
    this.upperLineColor = Colors.red,
    this.upperLineWidth = 2,
    this.lowerLineColor = Colors.green,
    this.lowerLineWidth = 2,
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

  /// Show zones boolean value for RSI indicator.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
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

  /// Overbought value for RSI indicator.
  ///
  /// Defaults to `80`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        overbought : 50
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

  /// Oversold value for RSI indicator.
  ///
  /// Defaults to `20`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        oversold : 30
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

  /// Color of the upper line for RSI indicator.
  ///
  /// Defaults to `Colors.red`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        upperLineColor : Colors.greenAccent
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

  /// Width of the upper line for RSI indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        upperLineWidth : 4.0
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

  /// Color of the lower line for RSI indicator.
  ///
  /// Defaults to `Colors.green`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        lowerLineColor : Colors.blue
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

  /// Width of the lower line for RSI indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        lowerLineWidth : 4.0
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

  /// Period determines the start point for the rendering of
  /// technical indicators.
  ///
  /// Defaults to `14`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
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

    return other is RsiIndicator &&
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
        other.signalLineWidth == signalLineWidth &&
        other.showZones == showZones &&
        other.overbought == overbought &&
        other.oversold == oversold &&
        other.upperLineColor == upperLineColor &&
        other.upperLineWidth == upperLineWidth &&
        other.lowerLineColor == lowerLineColor &&
        other.lowerLineWidth == lowerLineWidth;
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
      period,
      showZones,
      overbought,
      oversold,
      upperLineColor,
      upperLineWidth,
      lowerLineColor,
      lowerLineWidth
    ];
    return Object.hashAll(values);
  }

  @override
  String toString() => 'RSI';
}

class RsiIndicatorWidget extends IndicatorWidget {
  const RsiIndicatorWidget({
    super.key,
    required super.vsync,
    required super.isTransposed,
    required super.indicator,
    required super.index,
    super.onLegendTapped,
    super.onLegendItemRender,
  });

  // Create the RsiIndicatorRenderer renderer.
  @override
  RsiIndicatorRenderer createRenderer() {
    return RsiIndicatorRenderer();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    final RsiIndicatorRenderer renderer =
        super.createRenderObject(context) as RsiIndicatorRenderer;
    final RsiIndicator rsi = indicator as RsiIndicator;

    renderer
      ..highValueMapper = rsi.highValueMapper
      ..lowValueMapper = rsi.lowValueMapper
      ..closeValueMapper = rsi.closeValueMapper
      ..period = rsi.period
      ..showZones = rsi.showZones
      ..overbought = rsi.overbought
      ..oversold = rsi.oversold
      ..upperLineColor = rsi.upperLineColor
      ..upperLineWidth = rsi.upperLineWidth
      ..lowerLineColor = rsi.lowerLineColor
      ..lowerLineWidth = rsi.lowerLineWidth;

    return renderer;
  }

  @override
  void updateRenderObject(
      BuildContext context, RsiIndicatorRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    final RsiIndicator rsi = indicator as RsiIndicator;

    renderObject
      ..highValueMapper = rsi.highValueMapper
      ..lowValueMapper = rsi.lowValueMapper
      ..closeValueMapper = rsi.closeValueMapper
      ..period = rsi.period
      ..showZones = rsi.showZones
      ..overbought = rsi.overbought
      ..oversold = rsi.oversold
      ..upperLineColor = rsi.upperLineColor
      ..upperLineWidth = rsi.upperLineWidth
      ..lowerLineColor = rsi.lowerLineColor
      ..lowerLineWidth = rsi.lowerLineWidth;
  }
}

class RsiIndicatorRenderer<T, D> extends IndicatorRenderer<T, D> {
  late List<double>? _dashArray;

  final List<Offset> _signalLineActualValues = <Offset>[];
  final List<Offset> _lowerLineValues = <Offset>[];
  final List<Offset> _upperLineValues = <Offset>[];
  final List<Offset> _lowerLinePoints = <Offset>[];
  final List<Offset> _upperLinePoints = <Offset>[];
  final Path _upperLinePath = Path();
  final Path _lowerLinePath = Path();

  List<num> _highValues = <num>[];
  List<num> _lowValues = <num>[];
  List<num> _closeValues = <num>[];

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
      populateDataSource();
      markNeedsLayout();
    }
  }

  double get oversold => _oversold;
  double _oversold = 20;
  set oversold(double value) {
    if (_oversold != value) {
      _oversold = value;
      populateDataSource();
      markNeedsLayout();
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

  int get period => _period;
  int _period = 14;
  set period(int value) {
    if (_period != value) {
      _period = value;
      populateDataSource();
      markNeedsLayout();
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
          closeValueMapper
        ],
        <List<num>>[_highValues, _lowValues, _closeValues],
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

    if (dataCount >= period && period > 0) {
      _upperLineValues.clear();
      _lowerLineValues.clear();
      _signalLineActualValues.clear();

      _calculateZones();
      _calculateSignalLineValues();
    }

    populateChartPoints();
  }

  void _calculateZones() {
    if (showZones) {
      num yMinimum = double.infinity;
      num yMaximum = double.negativeInfinity;
      for (int i = 0; i < dataCount; i++) {
        final double x = xValues[i].toDouble();
        final double minY = min(overbought, oversold);
        final double maxY = max(overbought, oversold);
        yMinimum = min(yMinimum, minY);
        yMaximum = max(yMaximum, maxY);

        _upperLineValues.add(Offset(x, overbought));
        _lowerLineValues.add(Offset(x, oversold));
      }

      yMin = min(yMin, yMinimum);
      yMax = max(yMax, yMaximum);
    }
  }

  void _calculateSignalLineValues() {
    num xMinimum = double.infinity;
    num xMaximum = double.negativeInfinity;
    num yMinimum = double.infinity;
    num yMaximum = double.negativeInfinity;

    num previousClose = _closeValues[0];
    if (previousClose.isNaN) {
      previousClose = 0;
    }
    num gain = 0;
    num loss = 0;

    for (int i = 1; i <= period; i++) {
      num close = _closeValues[i];
      if (close.isNaN) {
        close = 0;
      }
      if (close > previousClose) {
        gain += close - previousClose;
      } else {
        loss += previousClose - close;
      }
      previousClose = close;
    }

    gain = gain / period;
    loss = loss / period;
    final num value = 100 - (100 / (1 + (gain / loss)));

    final double x = xValues[period].toDouble();
    final double y = value.toDouble();
    xMinimum = min(xMinimum, x);
    xMaximum = max(xMaximum, x);
    yMinimum = min(yMinimum, y);
    yMaximum = max(yMaximum, y);

    _signalLineActualValues.add(Offset(x, y));

    for (int j = period + 1; j < dataCount; j++) {
      num currentClose = _closeValues[j];
      if (currentClose.isNaN) {
        currentClose = 0;
      }
      if (currentClose > previousClose) {
        gain = (gain * (period - 1) + (currentClose - previousClose)) / period;
        loss = (loss * (period - 1)) / period;
      } else if (currentClose < previousClose) {
        loss = (loss * (period - 1) + (previousClose - currentClose)) / period;
        gain = (gain * (period - 1)) / period;
      }
      previousClose = currentClose;
      final num value = 100 - (100 / (1 + (gain / loss)));

      final double y = value.toDouble();
      yMinimum = min(yMinimum, y);
      yMaximum = max(yMaximum, y);

      _signalLineActualValues.add(Offset(xValues[j].toDouble(), y));
    }

    xMin = min(xMin, xMinimum);
    xMax = max(xMax, xMaximum);
    yMin = min(yMin, yMinimum);
    yMax = max(yMax, yMaximum);
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
  String defaultLegendItemText() => 'RSI';

  @override
  Color effectiveLegendIconColor() => signalLineColor;

  @override
  void transformValues() {
    signalLinePoints.clear();
    _upperLinePoints.clear();
    _lowerLinePoints.clear();

    if (showZones) {
      if (_upperLineValues.isNotEmpty) {
        final int length = _upperLineValues.length;
        for (int i = 0; i < length; i++) {
          final num x = _upperLineValues[i].dx;
          final num y = _upperLineValues[i].dy;
          _upperLinePoints
              .add(Offset(pointToPixelX(x, y), pointToPixelY(x, y)));
        }
      }

      if (_lowerLineValues.isNotEmpty) {
        final int length = _lowerLineValues.length;
        for (int i = 0; i < length; i++) {
          final num x = _lowerLineValues[i].dx;
          final num y = _lowerLineValues[i].dy;
          _lowerLinePoints
              .add(Offset(pointToPixelX(x, y), pointToPixelY(x, y)));
        }
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
  List<TrackballInfo>? trackballInfo(Offset position) {
    final List<ChartTrackballInfo<T, D>> trackballInfo =
        <ChartTrackballInfo<T, D>>[];
    final int rsiPointIndex = _findNearestPoint(signalLinePoints, position);
    if (rsiPointIndex != -1) {
      final CartesianChartPoint<D> rsiPointInfo =
          _chartPoint(rsiPointIndex, 'rsi');
      trackballInfo.add(
        ChartTrackballInfo<T, D>(
          position: signalLinePoints[rsiPointIndex],
          point: rsiPointInfo,
          series: this,
          pointIndex: rsiPointIndex,
          seriesIndex: index,
          name: defaultLegendItemText(),
          color: signalLineColor,
        ),
      );
    }
    if (showZones) {
      final int upperPointIndex = _findNearestPoint(_upperLinePoints, position);
      if (upperPointIndex != -1) {
        final CartesianChartPoint<D> upperPointInfo =
            _chartPoint(upperPointIndex, 'upper');
        trackballInfo.add(
          ChartTrackballInfo<T, D>(
            position: _upperLinePoints[upperPointIndex],
            point: upperPointInfo,
            series: this,
            pointIndex: upperPointIndex,
            seriesIndex: index,
            name: 'UpperLine',
            color: _upperLineColor,
          ),
        );
      }
      final int lowerPointIndex = _findNearestPoint(_lowerLinePoints, position);
      if (lowerPointIndex != -1) {
        final CartesianChartPoint<D> lowerPointInfo =
            _chartPoint(lowerPointIndex, 'lower');
        trackballInfo.add(
          ChartTrackballInfo<T, D>(
            position: _lowerLinePoints[lowerPointIndex],
            point: lowerPointInfo,
            series: this,
            pointIndex: lowerPointIndex,
            seriesIndex: index,
            name: 'LowerLine',
            color: _lowerLineColor,
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
    for (int i = 0; i < points.length; i++) {
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
        x: type == 'rsi'
            ? xRawValues[pointIndex + period]
            : xRawValues[pointIndex],
        xValue:
            type == 'rsi' ? xValues[pointIndex + period] : xValues[pointIndex],
        y: type == 'rsi'
            ? yAxis!.pixelToPoint(
                yAxis!.paintBounds,
                signalLinePoints[pointIndex].dx,
                signalLinePoints[pointIndex].dy)
            : type == 'upper'
                ? yAxis!.pixelToPoint(
                    yAxis!.paintBounds,
                    _upperLinePoints[pointIndex].dx,
                    _upperLinePoints[pointIndex].dy)
                : yAxis!.pixelToPoint(
                    yAxis!.paintBounds,
                    _lowerLinePoints[pointIndex].dx,
                    _lowerLinePoints[pointIndex].dy));
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

      context.canvas.drawPath(
          _upperLinePath,
          strokePaint
            ..color = upperLineColor
            ..strokeWidth = upperLineWidth);
    }

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

      context.canvas.drawPath(
          _lowerLinePath,
          strokePaint
            ..color = lowerLineColor
            ..strokeWidth = lowerLineWidth);
    }

    context.canvas.restore();
  }

  @override
  void dispose() {
    _signalLineActualValues.clear();
    _lowerLineValues.clear();
    _upperLineValues.clear();
    _lowerLinePoints.clear();
    _upperLinePoints.clear();
    _highValues.clear();
    _lowValues.clear();
    _closeValues.clear();
    _upperLinePath.reset();
    _lowerLinePath.reset();
    super.dispose();
  }
}
