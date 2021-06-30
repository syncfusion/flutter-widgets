part of charts;

/// Customize the technical indicators.
///
///The technical indicator is a mathematical calculation based on historical price, volume or (in the case of futures contracts) open interest information,
/// which is intended to predict the direction of the financial market.
///
/// Indicators generally overlay the  chart data to show the data flow over a period of time.
///
/// _Note:_ This propertty is applicable only for financial chart series types.
class TechnicalIndicators<T, D> {
  /// Creating an argument constructor of TechnicalIndicators class.
  TechnicalIndicators(
      {bool? isVisible,
      this.xAxisName,
      this.yAxisName,
      this.seriesName,
      List<double>? dashArray,
      double? animationDuration,
      this.dataSource,
      ChartValueMapper<T, D>? xValueMapper,
      ChartValueMapper<T, num>? lowValueMapper,
      ChartValueMapper<T, num>? highValueMapper,
      ChartValueMapper<T, num>? openValueMapper,
      ChartValueMapper<T, num>? closeValueMapper,
      this.name,
      this.onRenderDetailsUpdate,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      this.legendItemText,
      Color? signalLineColor,
      double? signalLineWidth,
      int? period})
      : isVisible = isVisible ?? true,
        dashArray = dashArray ?? <double>[0, 0],
        animationDuration = animationDuration ?? 1500,
        isVisibleInLegend = isVisibleInLegend ?? true,
        legendIconType = legendIconType ?? LegendIconType.seriesType,
        signalLineColor = signalLineColor ?? Colors.blue,
        signalLineWidth = signalLineWidth ?? 2,
        period = period ?? 14,
        xValueMapper = (xValueMapper != null)
            ? ((int index) => xValueMapper(dataSource![index], index))
            : null,
        lowValueMapper = (lowValueMapper != null)
            ? ((int index) => lowValueMapper(dataSource![index], index))
            : null,
        highValueMapper = (highValueMapper != null)
            ? ((int index) => highValueMapper(dataSource![index], index))
            : null,
        openValueMapper = (openValueMapper != null)
            ? ((int index) => openValueMapper(dataSource![index], index))
            : null,
        closeValueMapper = (closeValueMapper != null)
            ? ((int index) => closeValueMapper(dataSource![index], index))
            : null;

  /// Boolean property to change  the visibility of the technical indicators.
  ///
  /// Defaults to `true`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                isVisible : false,
  ///              ),
  ///           ],
  ///        ));
  ///}
  ///```
  final bool isVisible;

  ///  Property to map the technical indicators with the axes.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                xAxisName : 'bird',
  ///              ),
  ///            ],
  ///        ));
  ///}
  ///```
  final String? xAxisName;

  /// Property to map the technical indicators with the axes.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                yAxisName : 'ballon',
  ///              ),
  ///           ],
  ///        ));
  ///}
  ///```
  final String? yAxisName;

  /// Property to link indicators to a series based on names.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                seriesName : 'series1',
  ///              ),
  ///            ],
  ///        ));
  ///}
  ///```
  final String? seriesName;

  /// Property to provide DashArray for the technical indicators.
  ///
  /// Defaults to `<double>[0, 0]`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                dashArray : <double>[3,3],
  ///              ),
  ///            ],
  ///        ));
  ///}
  ///```
  final List<double> dashArray;

  /// Animation duration for the technical indicators.
  ///
  /// Defaults to `1500`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                animationDuration : 0,
  ///              ),
  ///           ],
  ///        ));
  ///}
  ///```
  final double animationDuration;

  /// Property to provide data  for the technical indicators without any series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                dataSource : Sample,
  ///              ),
  ///           ],
  ///        ));
  ///}
  ///```
  final List<T>? dataSource;

  /// Value mapper to map the x values with technical indicators.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                xValueMapper: (Sample sales, _) => sales.x,
  ///              ),
  ///           ],
  ///        ));
  ///}
  ///```
  final ChartIndexedValueMapper<D>? xValueMapper;

  /// Value mapper to map the low values with technical indicators.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                lowValueMapper: (Sample sales, _) => sales.low,
  ///              ),
  ///        ],
  ///        ));
  ///}
  ///```
  final ChartIndexedValueMapper<num>? lowValueMapper;

  /// Value mapper to map the high values with technical indicators.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                 highValueMapper: (Sample sales, _) => sales.high,
  ///              ),
  ///           ],
  ///        ));
  ///}
  ///```
  final ChartIndexedValueMapper<num>? highValueMapper;

  /// Value mapper to map the open values with technical indicators.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///               openValueMapper: (Sample sales, _) => sales.open,
  ///              ),
  ///            ],
  ///        ));
  ///}
  ///```
  final ChartIndexedValueMapper<num>? openValueMapper;

  /// Value mapper to map the close values with technical indicators.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///              closeValueMapper: (Sample sales, _) => sales.close,
  ///              ),
  ///            ],
  ///        ));
  ///}
  ///```
  final ChartIndexedValueMapper<num>? closeValueMapper;

  /// Property to provide name for the technical indicators.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                name :'indicators',
  ///              ),
  ///           ],
  ///        ));
  ///}
  ///```
  final String? name;

  /// Boolean property to determine the rendering of legends for the technical indicators.
  ///
  /// Defaults to `true`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                isVisibleInLegend : false,
  ///              ),
  ///           ],
  ///        ));
  ///}
  ///```
  final bool isVisibleInLegend;

  /// Property to provide icon type for the technical indicators legend.
  ///
  /// Deafults to `LegendIconType.seriesType`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                legendIconType :  LegendIconType.diamond,
  ///              ),
  ///            ],
  ///        ));
  ///}
  ///```
  final LegendIconType legendIconType;

  /// Property to provide the text for the technical indicators legend.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                legendItemText : 'SMA',
  ///              ),
  ///            ],
  ///        ));
  ///}
  ///```
  final String? legendItemText;

  /// Property to provide the color of the signal line in the technical indicators.
  ///
  /// Defaults to `blue`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                signalLineColor : Colors.red,
  ///              ),
  ///            ],
  ///        ));
  ///}
  ///```
  final Color signalLineColor;

  /// Property to provide the width of the signal line in the technical indicators.
  ///
  /// Defaults to `2`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                signalLineWidth : 4.0,
  ///              ),
  ///            ],
  ///        ));
  ///}
  ///```
  final double signalLineWidth;

  /// Period determines the start point for the rendering of technical indicators.
  ///
  /// Defaults to `14`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                period : 4,
  ///              ),
  ///            ],
  ///        ));
  ///}
  ///```
  final int period;

  /// Callback which gets called while rendering the indicators
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///  indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  /// onRenderDetailsUpdate: (IndicatorRenderParams params) {
  ///             return TechnicalIndicatorRenderDetails(Colors.cyan, 3.0, <double>[5,5]);
  ///                },
  /// )],
  ///        ));
  ///}
  ///```
  final ChartIndicatorRenderCallback? onRenderDetailsUpdate;
}

///Technical indicator renderer class for mutable fields and methods
class TechnicalIndicatorsRenderer {
  /// Creates an argument constructor for TechnicalIndicator renderer class
  TechnicalIndicatorsRenderer(this._technicalIndicatorRenderer);

  final TechnicalIndicators<dynamic, dynamic> _technicalIndicatorRenderer;

  late String _name;
  bool? _visible;
  //ignore: prefer_final_fields
  bool _isIndicator = true;
  final String _seriesType = 'indicator';
  late String _indicatorType;
  //ignore: unused_field
  late int _index;

  //ignore: prefer_final_fields
  List<CartesianSeriesRenderer> _targetSeriesRenderers =
      <CartesianSeriesRenderer>[];
  //ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>>? _dataPoints =
      <CartesianChartPoint<dynamic>>[];

  ///used for test case
  //ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>> _renderPoints =
      <CartesianChartPoint<dynamic>>[];

  ///used for events
  //ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>>? _bollingerUpper =
      <CartesianChartPoint<dynamic>>[];

  ///used for events
  //ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>>? _bollingerLower =
      <CartesianChartPoint<dynamic>>[];

  ///used for events
  //ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>>? _macdLine =
      <CartesianChartPoint<dynamic>>[];

  ///used for events
  //ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>>? _macdHistogram =
      <CartesianChartPoint<dynamic>>[];

  ///used for events
  //ignore: prefer_final_fields
  List<CartesianChartPoint<dynamic>>? _stochasticperiod =
      <CartesianChartPoint<dynamic>>[];

  ///used for events
  //ignore: prefer_final_fields
  double? _momentumCenterLineValue;

  /// To get and return  CartesianChartPoint
  CartesianChartPoint<dynamic> _getDataPoint(
      dynamic x, num y, CartesianChartPoint<dynamic> sourcePoint, int index,
      [TechnicalIndicators<dynamic, dynamic>? indicator]) {
    final CartesianChartPoint<dynamic> point =
        CartesianChartPoint<dynamic>(x, y);
    point.xValue = sourcePoint.xValue;
    point.index = index;
    point.yValue = y;
    point.isVisible = true;
    if (indicator is MacdIndicator &&
        (indicator.macdType == MacdType.histogram ||
            indicator.macdType == MacdType.both)) {
      final MacdIndicator<dynamic, dynamic> _indicator = indicator;
      point.pointColorMapper = point.yValue >= 0 == true
          ? _indicator.histogramPositiveColor
          : _indicator.histogramNegativeColor;
    }
    return point;
  }

  /// To get chart point of range type series
  CartesianChartPoint<dynamic> _getRangePoint(dynamic x, num high, num low,
      CartesianChartPoint<dynamic> sourcePoint, int index,
      //ignore: unused_element
      [TechnicalIndicators<dynamic, dynamic>? indicator]) {
    final CartesianChartPoint<dynamic> point =
        CartesianChartPoint<dynamic>(x, null);
    point.high = high;
    point.low = low;
    point.xValue = sourcePoint.xValue;
    point.index = index;
    point.isVisible = true;
    return point;
  }

  /// To set properties of technical indicators
  void _setSeriesProperties(TechnicalIndicators<dynamic, dynamic> indicator,
      String name, Color color, double width, SfCartesianChart chart,
      [bool isLine = false,
      bool isRangeArea = false,
      bool isHistogram = false]) {
    List<double>? _dashArray;
    if (indicator.onRenderDetailsUpdate != null &&
        isRangeArea == false &&
        isHistogram == false &&
        isLine == false) {
      TechnicalIndicatorRenderDetails indicators;
      if (indicator is BollingerBandIndicator) {
        final BollingerBandIndicatorRenderParams indicatorRenderParams =
            BollingerBandIndicatorRenderParams(_bollingerUpper, _bollingerLower,
                _renderPoints, name, width, color, indicator.dashArray);
        indicators = indicator.onRenderDetailsUpdate!(indicatorRenderParams);
      } else if (indicator is MomentumIndicator) {
        final MomentumIndicatorRenderParams indicatorRenderParams =
            MomentumIndicatorRenderParams(_momentumCenterLineValue,
                _renderPoints, name, width, color, indicator.dashArray);
        indicators = indicator.onRenderDetailsUpdate!(indicatorRenderParams);
      } else if (indicator is StochasticIndicator) {
        final StochasticIndicatorRenderParams indicatorRenderParams =
            StochasticIndicatorRenderParams(_stochasticperiod, _renderPoints,
                name, width, color, indicator.dashArray);
        indicators = indicator.onRenderDetailsUpdate!(indicatorRenderParams);
      } else if (indicator is MacdIndicator) {
        final MacdIndicatorRenderParams indicatorRenderParams =
            MacdIndicatorRenderParams(_macdLine, _macdHistogram, _renderPoints,
                name, width, color, indicator.dashArray);
        indicators = indicator.onRenderDetailsUpdate!(indicatorRenderParams);
      } else {
        final IndicatorRenderParams indicatorRenderParams =
            IndicatorRenderParams(
                _renderPoints, name, width, color, indicator.dashArray);
        indicators = indicator.onRenderDetailsUpdate!(indicatorRenderParams);
      }

      color = indicators.signalLineColor ?? color;
      width = indicators.signalLineWidth ?? width;
      _dashArray = indicators.signalLineDashArray ?? indicator.dashArray;
    }
    final CartesianSeries<dynamic, dynamic> series = isRangeArea == true
        ? RangeAreaSeries<dynamic, dynamic>(
            name: name,
            color: color,
            dashArray: indicator.dashArray,
            borderWidth: width,
            xAxisName: indicator.xAxisName,
            animationDuration: indicator.animationDuration,
            yAxisName: indicator.yAxisName,
            enableTooltip: false,
            //ignore: always_specify_types
            xValueMapper: (dynamic, _) => null,
            //ignore: always_specify_types
            highValueMapper: (dynamic, _) => null,
            //ignore: always_specify_types
            lowValueMapper: (dynamic, _) => null,
            dataSource: <dynamic>[])
        : (isHistogram == true
            ? ColumnSeries<dynamic, dynamic>(
                name: name,
                color: color,
                width: width,
                xAxisName: indicator.xAxisName,
                animationDuration: indicator.animationDuration,
                yAxisName: indicator.yAxisName,
                //ignore: always_specify_types
                xValueMapper: (dynamic, _) => null,
                //ignore: always_specify_types
                yValueMapper: (dynamic, _) => null,
                dataSource: <dynamic>[])
            : LineSeries<dynamic, dynamic>(
                name: name,
                color: color,
                dashArray: _dashArray ?? indicator.dashArray,
                width: width,
                xAxisName: indicator.xAxisName,
                animationDuration: indicator.animationDuration,
                yAxisName: indicator.yAxisName,
                //ignore: always_specify_types
                xValueMapper: (dynamic, _) => null,
                //ignore: always_specify_types
                yValueMapper: (dynamic, _) => null,
                dataSource: <dynamic>[]));
    final CartesianSeriesRenderer seriesRenderer = isRangeArea == true
        ? RangeAreaSeriesRenderer()
        : (isHistogram == true ? ColumnSeriesRenderer() : LineSeriesRenderer());
    seriesRenderer._series = series;
    seriesRenderer._visible = _visible;
    seriesRenderer._chart = chart;
    seriesRenderer._seriesType = isRangeArea == true
        ? 'rangearea'
        : (isHistogram == true ? 'column' : 'line');
    seriesRenderer._isIndicator = true;
    seriesRenderer._seriesName = _name;
    _targetSeriesRenderers.add(seriesRenderer);
  }

  /// Set series range of technical indicators
  void _setSeriesRange(List<CartesianChartPoint<dynamic>> points,
      TechnicalIndicators<dynamic, dynamic> indicator, List<dynamic> xValues,
      [CartesianSeriesRenderer? seriesRenderer]) {
    if (seriesRenderer == null) {
      _targetSeriesRenderers[0]._dataPoints = points;
      _targetSeriesRenderers[0]._xValues = xValues;
    } else {
      seriesRenderer._dataPoints = points;
      seriesRenderer._xValues = xValues;
    }
  }

  /// To get the value field value of technical indicators
  num _getFieldValue(List<CartesianChartPoint<dynamic>?> dataPoints, int index,
      String valueField) {
    num? val;
    if (valueField == 'low') {
      val = dataPoints[index]?.low;
    } else if (valueField == 'high') {
      val = dataPoints[index]?.high;
    } else if (valueField == 'open') {
      val = dataPoints[index]?.open;
    } else if (valueField == 'y') {
      val = dataPoints[index]?.y;
    } else {
      val = dataPoints[index]?.close;
    }

    ///ignore: unnecessary_statements
    val = val ?? 0;
    return val;
  }
}
