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

/// Renders weighted moving average (WMA) indicator.
///
/// A weighted moving average (WMA) is an arithmetic moving average calculated by
/// adding recent closing prices and then dividing the total by the number of
/// time periods in the calculation average.
///
/// It also has a [valueField] property. Based on this property, the indicator
/// will be rendered.
///
/// The indicator elements are:
///
/// * The [dataSource], which is used provide data for the technical indicators without any series.
/// * The [xValueMapper], which is a value mapper to map the x values with the technical indicator.
/// * The [highValueMapper], which is a value mapper to map the high values with the technical indicator.
/// * The [lowValueMapper], which is a value mapper to map the low values with the technical indicator.
/// * The [openValueMapper], which is a value mapper to map the open values with the technical indicator.
/// * The [closeValueMapper], which is a value mapper to map the close values with the technical indicator.
/// * The [xAxisName] and [yAxisName], which is used map the technical indicator with the multiple axes.
/// * The [seriesName], which is used map the technical indicator with the series based on names.
/// * The [valueField], which is used to determines the field for the rendering of WMA indicator.
/// * The [period], which is used determines the start point for the rendering of technical indicator.
///
/// ## Formula
///
/// Data (Closing Prices for Each Day):
///
/// *  Day 1: $100
/// *  Day 2: $105
/// *  Day 3: $110
/// *  Day 4: $120
/// *  Day 5: $103
/// *  ...
/// *  Day 15: $110
/// *  Day 16: $108
/// *  …
/// *  Day 29: $110
/// *  Day 30: $120
///
///
/// Calculation of WMA:
/// *  WMA for single data = currentPrice * (n/ sum of period);
/// *  The equation we use for weighing each number is the day number divided by the sum of
///  all day numbers.  Since we are looking at five days, the sum of all day numbers in this example
///  is 15 (i.e., 5 + 4 + 3 + 2 + 1).
///
/// *  WMA on Period 3:
/// *  If we need to calculate the 3rd day WMA means, current value is 110, period 3 days sum is 6 (3+2+1), then
/// *  100 * (1/6) = 6.25
/// *  105 * (2/6) = 17.5
/// *  110 * (3/6) = 18.33
///
/// *  WMA on Period 16:
/// *  If we need to calculate the 16th day WMA means, current value is 108, previous 16-day sum is
/// 136 (16+15+14+13+...+1).
/// *  Day1: 100 * (1/136) = 0.7
/// *  ....
/// *  Day 16: 108 * (16/136) = 12.070
///
/// ## Example
///
/// This snippet shows how to create a [WmaIndicator] by mapping the series data source.
///
/// ```dart
///
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: Center(
///          child: SfCartesianChart(
///            primaryXAxis: const DateTimeAxis(),
///            primaryYAxis: const NumericAxis(),
///            axes: const <ChartAxis>[
///              NumericAxis(
///                majorGridLines: MajorGridLines(width: 0),
///                opposedPosition: true,
///                name: 'yAxis',
///              ),
///            ],
///            indicators: <TechnicalIndicator<ChartSampleData, DateTime>>[
///              WmaIndicator<ChartSampleData, DateTime>(
///                seriesName: 'AAPL',
///                yAxisName: 'yAxis',
///                period: 15,
///              ),
///            ],
///            series: <CartesianSeries<ChartSampleData, DateTime>>[
///              HiloOpenCloseSeries<ChartSampleData, DateTime>(
///                dataSource: getChartData(),
///                xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
///                lowValueMapper: (ChartSampleData sales, _) => sales.low,
///                highValueMapper: (ChartSampleData sales, _) => sales.high,
///                openValueMapper: (ChartSampleData sales, _) => sales.open,
///                closeValueMapper: (ChartSampleData sales, _) => sales.close,
///                name: 'AAPL',
///              ),
///            ],
///          ),
///        ),
///      ),
///    );
///  }
/// ```
/// This snippet shows how to create a [WmaIndicator] using a direct data source.
///
/// ```dart
///
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: Center(
///          child: SfCartesianChart(
///            primaryXAxis: const DateTimeAxis(),
///            primaryYAxis: const NumericAxis(),
///            axes: const <ChartAxis>[
///              NumericAxis(
///                majorGridLines: MajorGridLines(width: 0),
///                opposedPosition: true,
///                name: 'yAxis',
///              ),
///            ],
///            indicators: <TechnicalIndicator<ChartSampleData, DateTime>>[
///              WmaIndicator<ChartSampleData, DateTime>(
///                dataSource: getChartData(),
///                xValueMapper: (ChartSampleData sales, _) => sales.x as DateTime,
///                lowValueMapper: (ChartSampleData sales, _) => sales.low,
///                highValueMapper: (ChartSampleData sales, _) => sales.high,
///                openValueMapper: (ChartSampleData sales, _) => sales.open,
///                closeValueMapper: (ChartSampleData sales, _) => sales.close,
///                yAxisName: 'yAxis',
///                period: 15,
///              ),
///            ],
///          ),
///        ),
///      ),
///    );
///  }
/// ```
///
@immutable
class WmaIndicator<T, D> extends TechnicalIndicator<T, D> {
  /// Creating an argument constructor of WmaIndicator class.
  WmaIndicator({
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

  /// Value field value for WMA indicator.
  ///
  /// Value field determines the field for the rendering of WMA indicator.
  ///
  /// Defaults to `close`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      WmaIndicator<Sample, num>(
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
  ///      WmaIndicator<Sample, num>(
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

    return other is WmaIndicator &&
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
  String toString() => 'WMA';
}

class WmaIndicatorWidget extends IndicatorWidget {
  const WmaIndicatorWidget({
    super.key,
    required super.vsync,
    required super.isTransposed,
    required super.indicator,
    required super.index,
    super.onLegendTapped,
    super.onLegendItemRender,
  });

  // Create the WmaIndicatorRenderer renderer.
  @override
  WmaIndicatorRenderer createRenderer() {
    return WmaIndicatorRenderer();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    final WmaIndicatorRenderer renderer =
        super.createRenderObject(context) as WmaIndicatorRenderer;
    final WmaIndicator wma = indicator as WmaIndicator;
    return renderer
      ..highValueMapper = wma.highValueMapper
      ..lowValueMapper = wma.lowValueMapper
      ..openValueMapper = wma.openValueMapper
      ..closeValueMapper = wma.closeValueMapper
      ..valueField = wma.valueField
      ..period = wma.period;
  }

  @override
  void updateRenderObject(
      BuildContext context, WmaIndicatorRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    final WmaIndicator wma = indicator as WmaIndicator;
    renderObject
      ..highValueMapper = wma.highValueMapper
      ..lowValueMapper = wma.lowValueMapper
      ..openValueMapper = wma.openValueMapper
      ..closeValueMapper = wma.closeValueMapper
      ..valueField = wma.valueField
      ..period = wma.period;
  }
}

class WmaIndicatorRenderer<T, D> extends IndicatorRenderer<T, D> {
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

    _calculateSignalLineValues();
    populateChartPoints();
  }

  void _calculateSignalLineValues() {
    _signalLineActualValues.clear();
    _yValues.clear();

    if (xValues.isNotEmpty &&
        dataCount >= period &&
        period > 0 &&
        signalLineWidth > 0) {
      num xMinimum = double.infinity;
      num xMaximum = double.negativeInfinity;
      num yMinimum = double.infinity;
      num yMaximum = double.negativeInfinity;

      // Calculate the total sum of periods.
      int sumOfPeriods = 0;
      for (int i = 0; i <= period; i++) {
        sumOfPeriods += i;
      }

      for (int i = period - 1; i < dataCount; i++) {
        double weightedSum = 0.0;
        for (int j = 0; j < period; j++) {
          weightedSum += _fieldValue(i, valueField) * (j + 1);
        }

        final double x = xValues[i].toDouble();
        final double y = (weightedSum / sumOfPeriods).toDouble();
        xMinimum = min(xMinimum, x);
        xMaximum = max(xMaximum, x);
        yMinimum = min(yMinimum, y);
        yMaximum = max(yMaximum, y);
        _signalLineActualValues.add(Offset(x, y));
      }

      xMin = xMinimum.isInfinite ? xMin : xMinimum;
      xMax = xMaximum.isInfinite ? xMax : xMaximum;
      yMin = yMinimum.isInfinite ? yMin : yMinimum;
      yMax = yMaximum.isInfinite ? yMax : yMaximum;
    }
  }

  num _fieldValue(int index, String valueField) {
    num? value;
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
  String defaultLegendItemText() => 'WMA';

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
    context.canvas.save();
    final Rect clip = clipRect(paintBounds, animationFactor,
        isInversed: xAxis!.isInversed, isTransposed: isTransposed);
    context.canvas.clipRect(clip);

    if (signalLinePoints.isNotEmpty) {
      if (strokePaint.color != Colors.transparent &&
          strokePaint.strokeWidth > 0) {
        final int length = signalLinePoints.length - 1;
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
    }

    context.canvas.restore();
  }

  @override
  void dispose() {
    _highValues.clear();
    _lowValues.clear();
    _openValues.clear();
    _closeValues.clear();
    _yValues.clear();
    _signalLineActualValues.clear();
    super.dispose();
  }
}
