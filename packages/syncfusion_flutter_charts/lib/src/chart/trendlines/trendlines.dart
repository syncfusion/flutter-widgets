part of charts;

///Renders the chart trend line
///
///A trend line is a straight line that connects two or more price points
///and then extends into the future to act as a line of support.
/// Trendlines provide Support for forward and backward forecastings.
///
/// Provides option to customize the trendline types, [width], [forwardForecast] and [backwardForecast].
class Trendline {
  /// Creating an argument constructor of Trendline class.
  Trendline(
      {bool enableTooltip,
      this.intercept,
      this.name,
      this.dashArray,
      Color color,
      TrendlineType type,
      double backwardForecast,
      double forwardForecast,
      double opacity,
      bool isVisible,
      double width,
      double animationDuration,
      String valueField,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      MarkerSettings markerSettings,
      int polynomialOrder,
      int period})
      : enableTooltip = enableTooltip ?? true,
        type = type ?? TrendlineType.linear,
        backwardForecast = backwardForecast ?? 0,
        forwardForecast = forwardForecast ?? 0,
        opacity = opacity ?? 1,
        valueField = valueField ?? 'high',
        width = width ?? 2,
        isVisible = isVisible ?? true,
        isVisibleInLegend = isVisibleInLegend ?? true,
        animationDuration = animationDuration ?? 1500,
        markerSettings = markerSettings ?? MarkerSettings(),
        legendIconType = legendIconType ?? LegendIconType.horizontalLine,
        polynomialOrder = polynomialOrder ?? 2,
        period = period ?? 2,
        color = color ?? Colors.blue;

  ///Determines the animation time of trendline.
  ///
  ///Defaults to `1500 `.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(animationDuration: 150)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final double animationDuration;

  ///Specifies the backward forecasting of trendlines.
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(backwardForecast: 3)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final double backwardForecast;

  ///Specifies the forward forecasting of trendlines.
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(forwardForecast: 3)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final double forwardForecast;

  ///Width of trendlines.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(width: 4)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final double width;

  ///Opacity of the trendline.
  ///
  ///Defaults to `1`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(opacity: 0.85)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final double opacity;

  ///Pattern of dashes and gaps used to stroke the trendline.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline()
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final List<double> dashArray;

  ///Enables the tooltip for trendlines.
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(enableTooltip: false)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final bool enableTooltip;

  ///Color of the trenline.
  ///
  ///Defaults to `Colors.blue`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(color: Colors.greenAccent)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final Color color;

  ///Provides the name for trendline.
  ///
  ///Defaults to `type` of the trendline chosen.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline()
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final String name;

  ///Specifies the intercept value of the trendlines.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(intercept: 20)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final double intercept;

  ///Determines the visiblity of the trendline.
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(isVisible: true)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final bool isVisible;

  ///Specifies the type of legend icon for trendline.
  ///
  ///Defaults to `LegendIconType.HorizontalLine`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(legendIconType: LegendIconType.circle)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final LegendIconType legendIconType;

  ///Specifies the intercept value of the trendlines.
  ///
  ///Defaults to `TrendlineType.linear`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(type: TrendlineType.power)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final TrendlineType type;

  ///To choose the valueField(low or high) to render the trendline.
  ///
  ///Defaults to `high`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(valueField: 'low')
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final String valueField;

  ///Settings to configure the Marker of trendline.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(
  ///                    markerSettings: MarkerSettings(color: Colors.red)
  ///                  )
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final MarkerSettings markerSettings;

  ///Show/hides the legend for trenline.
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(isVisibleInLegend: true)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final bool isVisibleInLegend;

  ///Specifies the order of te polynomial for polynomial trendline.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(
  ///                  type: TrendlineType.polynomial,
  ///                  polynomialOrder: 4)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final int polynomialOrder;

  ///Specifies the period for moving average trendline.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <CartseianSeries<dynamic,dynamic>>[
  ///              LineSeries<dynamic,String>(
  ///                trendlines: <TrendLine>[
  ///                  Trendline(
  ///                    type: TrendlineType.movingAverage,
  ///                    period: 3)
  ///                ])
  ///            ]
  ///        ));
  ///}
  ///```
  final int period;
}

///Trendline renderer class for mutable fields and methods
class TrendlineRenderer {
  /// Creates an argument constructor for Trendline renderer class
  TrendlineRenderer(this._trendline) {
    _opacity = _trendline.opacity ?? 1;
    _dashArray = _trendline.dashArray;
    _fillColor = _trendline.color ?? Colors.blue;
    _visible = _trendline.isVisible;
    _name = _trendline.name;
  }

  final Trendline _trendline;

  /// Holds the collection of cartesian data points
  List<CartesianChartPoint<dynamic>> _pointsData;
  CartesianSeriesRenderer _seriesRenderer;
  _SlopeIntercept _slopeIntercept;
  List<dynamic> _polynomialSlopes;
  List<Path> _markerShapes;
  List<Offset> _points;
  //ignore: prefer_final_fields
  double _opacity;
  //ignore: prefer_final_fields
  List<double> _dashArray;
  //ignore: prefer_final_fields
  Color _fillColor;
  //ignore: prefer_final_fields
  bool _visible;
  //ignore: prefer_final_fields
  String _name;
  bool _isNeedRender;
  AnimationController _animationController;
  //ignore: prefer_final_fields
  bool _isTrendlineRenderEvent = false;

  /// Defines the data point of trendline
  CartesianChartPoint<dynamic> getDataPoint(
      dynamic x,
      num y,
      CartesianChartPoint<dynamic> sourcePoint,
      CartesianSeriesRenderer seriesRenderer,
      int index) {
    final CartesianChartPoint<dynamic> trendPoint =
        CartesianChartPoint<dynamic>(x, y);
    trendPoint.x = (seriesRenderer._xAxisRenderer is DateTimeAxisRenderer)
        ? DateTime.fromMillisecondsSinceEpoch(x.floor())
        : x;
    trendPoint.y = y;
    trendPoint.xValue = x;
    trendPoint.pointColorMapper = _seriesRenderer._series.color;
    // trendPoint.index = index;
    trendPoint.yValue = y;
    trendPoint.isVisible = true;
    seriesRenderer._minimumX =
        math.min(seriesRenderer._minimumX, trendPoint.xValue);
    seriesRenderer._minimumY =
        math.min(seriesRenderer._minimumY, trendPoint.yValue);
    seriesRenderer._maximumX =
        math.max(seriesRenderer._maximumX, trendPoint.xValue);
    seriesRenderer._maximumY =
        math.max(seriesRenderer._maximumY, trendPoint.yValue);
    return trendPoint;
  }

  ///Defines the linear points
  List<CartesianChartPoint<dynamic>> getLinearPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      CartesianSeriesRenderer seriesRenderer,
      _SlopeIntercept slopeInterceptLinear) {
    num x1Linear, x2Linear;
    final List<CartesianChartPoint<dynamic>> pts =
        <CartesianChartPoint<dynamic>>[];
    if (seriesRenderer._xAxisRenderer is DateTimeAxisRenderer) {
      x1Linear = _increaseDateTimeForecast(seriesRenderer._xAxisRenderer,
          xValues[0], -(_trendline.backwardForecast));
      x2Linear = _increaseDateTimeForecast(seriesRenderer._xAxisRenderer,
          xValues[xValues.length - 1], _trendline.forwardForecast);
    } else {
      x1Linear = xValues[0] - _trendline.backwardForecast;
      x2Linear = xValues[xValues.length - 1] + _trendline.forwardForecast;
    }
    final num y1Linear =
        slopeInterceptLinear.slope * x1Linear + slopeInterceptLinear.intercept;
    final num y2Linear =
        slopeInterceptLinear.slope * x2Linear + slopeInterceptLinear.intercept;
    pts.add(getDataPoint(
        x1Linear, y1Linear, points[0], seriesRenderer, pts.length));
    pts.add(getDataPoint(x2Linear, y2Linear, points[points.length - 1],
        seriesRenderer, pts.length));
    return pts;
  }

  /// Setting the linear range for trendline series
  void _setLinearRange(List<CartesianChartPoint<dynamic>> points,
      CartesianSeriesRenderer seriesRenderer) {
    final List<dynamic> xValues = <dynamic>[];
    final List<num> yValues = <num>[];
    int index = 0;
    while (index < points.length) {
      final CartesianChartPoint<dynamic> point = points[index];
      xValues.add(point.xValue ?? point.x);
      if (!(seriesRenderer._series is RangeAreaSeries<dynamic, dynamic> ||
          seriesRenderer._series is RangeColumnSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloOpenCloseSeries<dynamic, dynamic> ||
          seriesRenderer._series is CandleSeries)) {
        yValues.add(point.yValue ?? point.y);
      } else {
        yValues.add(_trendline.valueField.toLowerCase() == 'low'
            ? point.low
            : point.high);
      }
      index++;
    }
    _slopeIntercept = _findSlopeIntercept(xValues, yValues, points);
    _pointsData = getLinearPoints(
        points, xValues, yValues, seriesRenderer, _slopeIntercept);
  }

  ///Defines Exponential Points
  List<CartesianChartPoint<dynamic>> getExponentialPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      CartesianSeriesRenderer seriesRenderer,
      _SlopeIntercept slopeInterceptExpo) {
    num x1, x2, x3;
    final num midPoint = (points.length / 2).round();
    final List<CartesianChartPoint<dynamic>> ptsExpo =
        <CartesianChartPoint<dynamic>>[];
    if (seriesRenderer._xAxisRenderer is DateTimeAxisRenderer) {
      x1 = _increaseDateTimeForecast(seriesRenderer._xAxisRenderer, xValues[0],
          -(_trendline.backwardForecast));
      x2 = xValues[midPoint - 1];
      x3 = _increaseDateTimeForecast(seriesRenderer._xAxisRenderer,
          xValues[xValues.length - 1], _trendline.forwardForecast);
    } else {
      x1 = xValues[0] - _trendline.backwardForecast;
      x2 = xValues[midPoint - 1];
      x3 = xValues[xValues.length - 1] + _trendline.forwardForecast;
    }
    final num y1 =
        slopeInterceptExpo.intercept * math.exp(slopeInterceptExpo.slope * x1);

    final num y2 =
        slopeInterceptExpo.intercept * math.exp(slopeInterceptExpo.slope * x2);

    final num y3 =
        slopeInterceptExpo.intercept * math.exp(slopeInterceptExpo.slope * x3);
    ptsExpo
        .add(getDataPoint(x1, y1, points[0], seriesRenderer, ptsExpo.length));
    ptsExpo.add(getDataPoint(
        x2, y2, points[midPoint - 1], seriesRenderer, ptsExpo.length));
    ptsExpo.add(getDataPoint(
        x3, y3, points[points.length - 1], seriesRenderer, ptsExpo.length));
    return ptsExpo;
  }

  /// Setting the exponential range for trendline series
  void _setExponentialRange(List<CartesianChartPoint<dynamic>> points,
      CartesianSeriesRenderer seriesRenderer) {
    final List<dynamic> xValues = <dynamic>[];
    final List<num> yValues = <num>[];
    int index = 0;
    while (index < points.length) {
      final CartesianChartPoint<dynamic> point = points[index];
      xValues.add(point.xValue ?? point.x);
      if (!(seriesRenderer._series is RangeAreaSeries<dynamic, dynamic> ||
          seriesRenderer._series is RangeColumnSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloOpenCloseSeries<dynamic, dynamic> ||
          seriesRenderer._series is CandleSeries<dynamic, dynamic>)) {
        yValues.add(math.log(point.yValue ?? point.y));
      } else {
        yValues.add(_trendline.valueField.toLowerCase() == 'low'
            ? math.log(point.low)
            : math.log(point.high));
      }
      index++;
    }
    _slopeIntercept = _findSlopeIntercept(xValues, yValues, points);
    _pointsData = getExponentialPoints(
        points, xValues, yValues, seriesRenderer, _slopeIntercept);
  }

  ///Defines Power Points
  List<CartesianChartPoint<dynamic>> getPowerPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      CartesianSeriesRenderer seriesRenderer,
      _SlopeIntercept slopeInterceptPow) {
    num x1, x2, x3;
    final num midPoint = (points.length / 2).round();
    final List<CartesianChartPoint<dynamic>> ptsPow =
        <CartesianChartPoint<dynamic>>[];
    if (seriesRenderer._xAxisRenderer is DateTimeAxisRenderer) {
      x1 = _increaseDateTimeForecast(seriesRenderer._xAxisRenderer, xValues[0],
          -(_trendline.backwardForecast));
      x2 = xValues[midPoint - 1];
      x3 = _increaseDateTimeForecast(seriesRenderer._xAxisRenderer,
          xValues[xValues.length - 1], _trendline.forwardForecast);
    } else {
      x1 = xValues[0] - _trendline.backwardForecast;
      x1 = x1 > -1 ? x1 : 0;
      x2 = xValues[midPoint - 1];
      x3 = xValues[xValues.length - 1] + _trendline.forwardForecast;
    }
    final num y1 = x1 == 0
        ? 0
        : slopeInterceptPow.intercept * math.pow(x1, slopeInterceptPow.slope);
    final num y2 =
        slopeInterceptPow.intercept * math.pow(x2, slopeInterceptPow.slope);
    final num y3 =
        slopeInterceptPow.intercept * math.pow(x3, slopeInterceptPow.slope);
    ptsPow.add(getDataPoint(x1, y1, points[0], seriesRenderer, ptsPow.length));
    ptsPow.add(getDataPoint(
        x2, y2, points[midPoint - 1], seriesRenderer, ptsPow.length));
    ptsPow.add(getDataPoint(
        x3, y3, points[points.length - 1], seriesRenderer, ptsPow.length));
    return ptsPow;
  }

  /// Setting the power range values for trendline series
  void _setPowerRange(List<CartesianChartPoint<dynamic>> points,
      CartesianSeriesRenderer seriesRenderer) {
    final List<dynamic> xValues = <dynamic>[];
    final List<num> yValues = <num>[];
    final List<dynamic> powerPoints = <dynamic>[];
    int index = 0;
    while (index < points.length) {
      final CartesianChartPoint<dynamic> point = points[index];
      powerPoints.add(point.xValue ?? point.x);
      final dynamic xVal =
          point.xValue != null && (math.log(point.xValue)).isFinite
              ? math.log(point.xValue)
              : (point.x is String) ? point.xValue : point.x;
      xValues.add(xVal);
      if (!(seriesRenderer._series is RangeAreaSeries<dynamic, dynamic> ||
          seriesRenderer._series is RangeColumnSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloOpenCloseSeries<dynamic, dynamic> ||
          seriesRenderer._series is CandleSeries<dynamic, dynamic>)) {
        yValues.add(math.log(point.yValue ?? point.y));
      } else {
        yValues.add(_trendline.valueField.toLowerCase() == 'low'
            ? math.log(point.low)
            : math.log(point.high));
      }
      index++;
    }
    _slopeIntercept = _findSlopeIntercept(xValues, yValues, points);
    _pointsData = getPowerPoints(
        points, powerPoints, yValues, seriesRenderer, _slopeIntercept);
  }

  ///Defines Logarithmic Points
  List<CartesianChartPoint<dynamic>> getLogarithmicPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      CartesianSeriesRenderer seriesRenderer,
      _SlopeIntercept slopeInterceptLog) {
    num x1, x2, x3;
    final num midPoint = (points.length / 2).round();
    final List<CartesianChartPoint<dynamic>> ptsLog =
        <CartesianChartPoint<dynamic>>[];
    if (seriesRenderer._xAxisRenderer is DateTimeAxisRenderer) {
      x1 = _increaseDateTimeForecast(seriesRenderer._xAxisRenderer, xValues[0],
          -(_trendline.backwardForecast));
      x2 = xValues[midPoint - 1];
      x3 = _increaseDateTimeForecast(seriesRenderer._xAxisRenderer,
          xValues[xValues.length - 1], _trendline.forwardForecast);
    } else {
      x1 = xValues[0] - _trendline.backwardForecast;
      x2 = xValues[midPoint - 1];
      x3 = xValues[xValues.length - 1] + _trendline.forwardForecast;
    }
    final num y1 = slopeInterceptLog.intercept +
        (slopeInterceptLog.slope *
            ((math.log(x1)).isFinite ? math.log(x1) : x1));
    final num y2 = slopeInterceptLog.intercept +
        (slopeInterceptLog.slope *
            ((math.log(x2)).isFinite ? math.log(x2) : x2));
    final num y3 = slopeInterceptLog.intercept +
        (slopeInterceptLog.slope *
            ((math.log(x3)).isFinite ? math.log(x3) : x3));
    ptsLog.add(getDataPoint(x1, y1, points[0], seriesRenderer, ptsLog.length));
    ptsLog.add(getDataPoint(
        x2, y2, points[midPoint - 1], seriesRenderer, ptsLog.length));
    ptsLog.add(getDataPoint(
        x3, y3, points[points.length - 1], seriesRenderer, ptsLog.length));
    return ptsLog;
  }

  /// Setting the logarithmic range for _trendline series
  void _setLogarithmicRange(List<CartesianChartPoint<dynamic>> points,
      CartesianSeriesRenderer seriesRenderer) {
    final List<dynamic> xLogValue = <dynamic>[];
    final List<num> yLogValue = <num>[];
    final List<dynamic> xPointsLgr = <dynamic>[];
    int index = 0;
    while (index < points.length) {
      final CartesianChartPoint<dynamic> point = points[index];
      xPointsLgr.add(point.xValue ?? point.x);
      final dynamic xVal =
          (point.xValue != null && (math.log(point.xValue)).isFinite)
              ? math.log(point.xValue)
              : (point.x is String) ? point.xValue : point.x;
      xLogValue.add(xVal);
      if (!(seriesRenderer._series is RangeAreaSeries<dynamic, dynamic> ||
          seriesRenderer._series is RangeColumnSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloOpenCloseSeries<dynamic, dynamic> ||
          seriesRenderer._series is CandleSeries<dynamic, dynamic>)) {
        yLogValue.add(point.yValue ?? point.y);
      } else {
        yLogValue.add(_trendline.valueField.toLowerCase() == 'low'
            ? point.low
            : point.high);
      }
      index++;
    }
    _slopeIntercept = _findSlopeIntercept(xLogValue, yLogValue, points);
    _pointsData = getLogarithmicPoints(
        points, xPointsLgr, yLogValue, seriesRenderer, _slopeIntercept);
  }

  ///Defines Polynomial points
  List<CartesianChartPoint<dynamic>> _getPolynomialPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      CartesianSeriesRenderer seriesRenderer) {
    //ignore: unused_local_variable
    final int midPoint = (points.length / 2).round();
    List<dynamic> pts = <dynamic>[];
    _polynomialSlopes = List<dynamic>(_trendline.polynomialOrder + 1);

    for (int i = 0; i < xValues.length; i++) {
      final dynamic xVal = xValues[i];
      final num yVal = yValues[i];
      for (int j = 0; j <= _trendline.polynomialOrder; j++) {
        _polynomialSlopes[j] ??= 0;
        _polynomialSlopes[j] += pow(xVal.toDouble(), j) * yVal;
      }
    }

    final List<dynamic> numArray =
        List<dynamic>(2 * _trendline.polynomialOrder + 1);
    final List<dynamic> matrix = List<dynamic>(_trendline.polynomialOrder + 1);

    for (int i = 0; i <= _trendline.polynomialOrder; i++) {
      matrix[i] = List<dynamic>(_trendline.polynomialOrder + 1);
    }

    num num1 = 0;
    for (int nIndex = 0; nIndex < xValues.length; nIndex++) {
      final num d = xValues[nIndex];
      num num2 = 1.0;
      for (int j = 0; j < numArray.length; j++, num1++) {
        numArray[j] ??= 0;
        numArray[j] += num2;
        num2 *= d;
      }
    }

    for (int i = 0; i <= _trendline.polynomialOrder; i++) {
      for (int j = 0; j <= _trendline.polynomialOrder; j++) {
        matrix[i][j] = numArray[i + j];
      }
    }
    if (!_gaussJordanElimination(matrix, _polynomialSlopes)) {
      _polynomialSlopes = null;
    }
    pts = _getPoints(points, xValues, yValues, seriesRenderer);
    return pts;
  }

  /// Setting the polynomial range for trendline series
  void _setPolynomialRange(List<CartesianChartPoint<dynamic>> points,
      CartesianSeriesRenderer seriesRenderer) {
    final List<dynamic> xPolyValues = <dynamic>[];
    final List<num> yPolyValues = <num>[];
    int index = 0;
    while (index < points.length) {
      final CartesianChartPoint<dynamic> point = points[index];
      xPolyValues.add(point.xValue ?? point.x);
      if (!(seriesRenderer._series is RangeAreaSeries<dynamic, dynamic> ||
          seriesRenderer._series is RangeColumnSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloOpenCloseSeries<dynamic, dynamic> ||
          seriesRenderer._series is CandleSeries<dynamic, dynamic>)) {
        yPolyValues.add(point.yValue ?? point.y);
      } else {
        yPolyValues.add(_trendline.valueField.toLowerCase() == 'low'
            ? point.low
            : point.high);
      }
      index++;
    }
    _pointsData =
        _getPolynomialPoints(points, xPolyValues, yPolyValues, seriesRenderer);
  }

  /// To return points list
  List<CartesianChartPoint<dynamic>> _getPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      CartesianSeriesRenderer seriesRenderer) {
    //ignore: unused_local_variable
    final int midPoint = (points.length / 2).round();
    final List<dynamic> _polynomialSlopesList = _polynomialSlopes;
    final List<CartesianChartPoint<dynamic>> pts =
        <CartesianChartPoint<dynamic>>[];

    num x1 = 1;
    dynamic xVal;
    num yVal;
    final dynamic _backwardForecast =
        seriesRenderer._xAxisRenderer is DateTimeAxisRenderer
            ? _getForecastDate(seriesRenderer._xAxisRenderer, false)
            : _trendline.backwardForecast;
    final dynamic _forwardForecast =
        seriesRenderer._xAxisRenderer is DateTimeAxisRenderer
            ? _getForecastDate(seriesRenderer._xAxisRenderer, true)
            : _trendline.forwardForecast;

    for (int index = 1; index <= _polynomialSlopesList.length; index++) {
      if (index == 1) {
        xVal = xValues[0] - _backwardForecast.toDouble();
        yVal = _getPolynomialYValue(_polynomialSlopesList, xVal);
        pts.add(
            getDataPoint(xVal, yVal, points[0], seriesRenderer, pts.length));
      } else if (index == _polynomialSlopesList.length) {
        xVal = xValues[points.length - 1] + _forwardForecast.toDouble();
        yVal = _getPolynomialYValue(_polynomialSlopesList, xVal);
        pts.add(getDataPoint(
            xVal, yVal, points[points.length - 1], seriesRenderer, pts.length));
      } else {
        x1 += (points.length + _trendline.forwardForecast) /
            _polynomialSlopesList.length;
        xVal = xValues[x1.floor() - 1] * 1.0;
        yVal = _getPolynomialYValue(_polynomialSlopesList, xVal);
        pts.add(getDataPoint(
            xVal, yVal, points[x1.floor() - 1], seriesRenderer, pts.length));
      }
    }
    return pts;
  }

  /// To get polynomial Y value of trendline
  double _getPolynomialYValue(List<dynamic> slopes, dynamic x) {
    double sum = 0;
    for (int i = 0; i < slopes.length; i++) {
      sum += slopes[i] * pow(x, i);
    }
    return sum;
  }

  ///Defines moving average points
  List<CartesianChartPoint<dynamic>> getMovingAveragePoints(
      List<CartesianChartPoint<dynamic>> points,
      List<dynamic> xValues,
      List<num> yValues,
      CartesianSeriesRenderer seriesRenderer) {
    final List<CartesianChartPoint<dynamic>> pts =
        <CartesianChartPoint<dynamic>>[];
    int periods = _trendline.period >= points.length
        ? points.length - 1
        : _trendline.period;
    periods = max(2, periods);
    num y;
    dynamic x;
    int count;
    int nullCount;
    for (int index = 0; index < points.length - 1; index++) {
      y = count = nullCount = 0;
      for (int j = index; count < periods; j++) {
        count++;
        if (j >= yValues.length || yValues[j] == null) {
          nullCount++;
        }
        y += j >= yValues.length ? 0 : yValues[j];
      }
      y = periods - nullCount <= 0 ? null : y / (periods - nullCount);
      if (y != null && !y.isNaN && index + periods < xValues.length + 1) {
        x = xValues[periods - 1 + index];
        pts.add(getDataPoint(
            x, y, points[periods - 1 + index], seriesRenderer, pts.length));
      }
    }
    return pts;
  }

  /// Setting the moving average range for trendline series
  void _setMovingAverageRange(List<CartesianChartPoint<dynamic>> points,
      CartesianSeriesRenderer seriesRenderer) {
    final List<dynamic> xValues = <dynamic>[];
    final List<num> yValues = <num>[];
    final List<dynamic> xAvgValues = <dynamic>[];

    for (int index = 0; index < points.length; index++) {
      final dynamic point = points[index];
      xAvgValues.add(point.xValue ?? point.x);
      xValues.add(index + 1);
      if (!(seriesRenderer._series is RangeAreaSeries<dynamic, dynamic> ||
          seriesRenderer._series is RangeColumnSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloSeries<dynamic, dynamic> ||
          seriesRenderer._series is HiloOpenCloseSeries<dynamic, dynamic> ||
          seriesRenderer._series is CandleSeries<dynamic, dynamic>)) {
        yValues.add(point.yValue ?? point.y);
      } else {
        yValues.add(_trendline.valueField.toLowerCase() == 'low'
            ? point.low
            : point.high);
      }
    }
    _pointsData =
        getMovingAveragePoints(points, xAvgValues, yValues, seriesRenderer);
  }

  /// Setting the slope intercept for trendline series
  _SlopeIntercept _findSlopeIntercept(dynamic xValues, dynamic yValues,
      List<CartesianChartPoint<dynamic>> points) {
    double xAvg = 0.0;
    double yAvg = 0.0;
    double xyAvg = 0.0;
    double xxAvg = 0.0;
    // double yyAvg = 0.0;
    int index = 0;
    double slope = 0.0;
    double intercept = 0.0;
    while (index < points.length) {
      if ((yValues[index]).isNaN) {
        yValues[index] = (yValues[index - 1] + yValues[index + 1]) / 2;
      }
      xAvg += xValues[index];
      yAvg += yValues[index];
      xyAvg += xValues[index].toDouble() * yValues[index].toDouble();
      xxAvg += xValues[index].toDouble() * xValues[index].toDouble();
      // yyAvg += yValues[index].toDouble() * yValues[index].toDouble();
      index++;
    }
    if (_trendline.intercept != null &&
        _trendline.intercept != 0 &&
        (_trendline.type == TrendlineType.linear ||
            _trendline.type == TrendlineType.exponential)) {
      intercept = _trendline.intercept.toDouble();
      switch (_trendline.type) {
        case TrendlineType.linear:
          slope = (xyAvg - (intercept * xAvg)) / xxAvg;
          break;
        case TrendlineType.exponential:
          slope = (xyAvg - (math.log(intercept.abs()) * xAvg)) / xxAvg;
          break;
        default:
          break;
      }
    } else {
      slope = ((points.length * xyAvg) - (xAvg * yAvg)) /
          ((points.length * xxAvg) - (xAvg * xAvg));
      if (_trendline.type == TrendlineType.exponential ||
          _trendline.type == TrendlineType.power) {
        intercept = math.exp((yAvg - (slope * xAvg)) / points.length);
      } else {
        intercept = (yAvg - (slope * xAvg)) / points.length;
      }
    }
    _SlopeIntercept _slopeIntercept;
    _slopeIntercept = _SlopeIntercept();
    _slopeIntercept.slope = slope;
    _slopeIntercept.intercept = intercept;
    return _slopeIntercept;
  }

  /// To set initial data source for trendlines
  void _initDataSource(
      SfCartesianChart chart, CartesianSeriesRenderer seriesRenderer) {
    if (_pointsData.isNotEmpty) {
      switch (_trendline.type) {
        case TrendlineType.linear:
          _setLinearRange(_pointsData, seriesRenderer);
          break;
        case TrendlineType.exponential:
          _setExponentialRange(_pointsData, seriesRenderer);
          break;
        case TrendlineType.power:
          _setPowerRange(_pointsData, seriesRenderer);
          break;
        case TrendlineType.logarithmic:
          _setLogarithmicRange(_pointsData, seriesRenderer);
          break;
        case TrendlineType.polynomial:
          _setPolynomialRange(_pointsData, seriesRenderer);
          break;
        case TrendlineType.movingAverage:
          _setMovingAverageRange(_pointsData, seriesRenderer);
          break;
        default:
          break;
      }
    }
  }

  /// To find the actual points of trend line series
  void calculateTrendlinePoints(CartesianSeriesRenderer seriesRenderer,
      SfCartesianChartState _chartState) {
    final Rect rect = _calculatePlotOffset(
        _chartState._chartAxis._axisClipRect,
        Offset(seriesRenderer._xAxisRenderer._axis.plotOffset,
            seriesRenderer._yAxisRenderer._axis.plotOffset));
    _points = <Offset>[];
    if (seriesRenderer._series.trendlines != null && _pointsData != null) {
      for (int i = 0; i < _pointsData.length; i++) {
        if (_pointsData[i].x != null && _pointsData[i].y != null) {
          final _ChartLocation currentChartPoint = _pointsData[i].markerPoint =
              _calculatePoint(
                  (seriesRenderer._xAxisRenderer is DateTimeAxisRenderer)
                      ? _pointsData[i].xValue
                      : _pointsData[i].x,
                  _pointsData[i].y,
                  seriesRenderer._xAxisRenderer,
                  seriesRenderer._yAxisRenderer,
                  _chartState._requireInvertedAxis,
                  seriesRenderer._series,
                  rect);
          _points.add(Offset(currentChartPoint.x, currentChartPoint.y));
          _pointsData[i].region = Rect.fromLTRB(
              _points[i].dx, _points[i].dy, _points[i].dx, _points[i].dy);
        }
      }
      _calculateMarkerShapesPoint(seriesRenderer);
    }
  }

  /// Calculate marker shapes for trendlines
  void _calculateMarkerShapesPoint(CartesianSeriesRenderer seriesRenderer) {
    _markerShapes = <Path>[];
    for (int i = 0; i < _pointsData.length; i++) {
      final CartesianChartPoint<dynamic> point = _pointsData[i];
      final DataMarkerType markerType = _trendline.markerSettings.shape;
      final Size size = Size(
          _trendline.markerSettings.width, _trendline.markerSettings.height);
      _markerShapes.add(_getMarkerShapesPath(
          markerType,
          Offset(point.markerPoint.x, point.markerPoint.y),
          size,
          seriesRenderer));
    }
  }

  /// To set data source for trendlines
  void _setDataSource(
      CartesianSeriesRenderer seriesRenderer, SfCartesianChart chart) {
    if (seriesRenderer?._series != null) {
      _seriesRenderer = seriesRenderer;
      _pointsData = seriesRenderer._dataPoints;
      if (seriesRenderer is _StackedSeriesRenderer) {
        for (int i = 0; i < _pointsData.length; i++) {
          _pointsData[i].y = seriesRenderer._stackingValues[0].endValues[i];
          _pointsData[i].yValue =
              seriesRenderer._stackingValues[0].endValues[i];
        }
      }
      _initDataSource(chart, _seriesRenderer);
    }
  }

  /// To obtain control points for type curve trendlines
  List<double> _getControlPoints(List<Offset> _dataPoints, int index) {
    List<num> yCoef = <num>[];
    final List<num> xValues = <num>[];
    final List<num> yValues = <num>[];
    for (int i = 0; i < _dataPoints.length; i++) {
      xValues.add(_dataPoints[i].dx);
      yValues.add(_dataPoints[i].dy);
    }
    yCoef = _naturalSpline(
        xValues, yValues, yCoef, xValues.length, SplineType.natural);
    return _calculateControlPoints(xValues, yValues, yCoef[index].toDouble(),
        yCoef[index + 1].toDouble(), index);
  }

  /// It returns the date-time values of trendline series
  int _increaseDateTimeForecast(
      DateTimeAxisRenderer axisRenderer, int value, num interval) {
    final DateTimeAxis axis = axisRenderer._axis;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    switch (axis.intervalType) {
      case DateTimeIntervalType.years:
        dateTime = DateTime(dateTime.year + interval.floor(), dateTime.month,
            dateTime.day, 0, 0, 0);
        break;
      case DateTimeIntervalType.months:
        dateTime = DateTime(dateTime.year, dateTime.month + interval.floor(),
            dateTime.day, 0, 0, 0);
        break;
      case DateTimeIntervalType.days:
        dateTime = DateTime(dateTime.year, dateTime.month,
            dateTime.day + interval.floor(), 0, 0, 0);
        break;
      case DateTimeIntervalType.hours:
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour + interval.floor(), 0, 0);
        break;
      case DateTimeIntervalType.minutes:
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute + interval.floor(), 0);
        break;
      case DateTimeIntervalType.seconds:
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second + interval.floor());
        break;
      case DateTimeIntervalType.auto:
        break;
    }
    return dateTime.millisecondsSinceEpoch;
  }

  /// Boolean for gaussJordanElimination in polynomial type trendlines
  bool _gaussJordanElimination(
      List<dynamic> matrix, List<dynamic> _polynomialSlopesList) {
    final int length = matrix.length;
    final List<dynamic> numArray1 = List<dynamic>(length);
    final List<dynamic> numArray2 = List<dynamic>(length);
    final List<dynamic> numArray3 = List<dynamic>(length);

    for (int index = 0; index < length; index++) {
      numArray3[index] = 0;
    }
    int index1 = 0;
    while (index1 < length) {
      num num1 = 0;
      int index2 = 0;
      int index3 = 0;
      int index4 = 0;
      while (index4 < length) {
        if (numArray3[index4] != 1) {
          int index5 = 0;
          while (index5 < length) {
            if (numArray3[index5] == 0 &&
                (matrix[index4][index5]).abs() >= num1) {
              num1 = (matrix[index4][index5]).abs();
              index2 = index4;
              index3 = index5;
            }
            ++index5;
          }
        }
        ++index4;
      }
      ++numArray3[index3];
      if (index2 != index3) {
        int index4_1 = 0;
        while (index4_1 < length) {
          final num num2 = matrix[index2][index4_1];
          matrix[index2][index4_1] = matrix[index3][index4_1];
          matrix[index3][index4_1] = num2;
          ++index4_1;
        }
        final num num3 = _polynomialSlopes[index2];
        _polynomialSlopes[index2] = _polynomialSlopes[index3];
        _polynomialSlopes[index3] = num3;
      }
      numArray2[index1] = index2;
      numArray1[index1] = index3;
      if (matrix[index3][index3] == 0.0) {
        return false;
      }
      final num num4 = 1.0 / matrix[index3][index3];
      matrix[index3][index3] = 1.0;
      int iindex4 = 0;
      while (iindex4 < length) {
        matrix[index3][iindex4] *= num4;
        ++iindex4;
      }
      _polynomialSlopes[index3] *= num4;
      int iandex4 = 0;
      while (iandex4 < length) {
        if (iandex4 != index3) {
          final num num2 = matrix[iandex4][index3];
          matrix[iandex4][index3] = 0.0;
          int index5 = 0;
          while (index5 < length) {
            matrix[iandex4][index5] -= matrix[index3][index5] * num2;
            ++index5;
          }
          _polynomialSlopes[iandex4] -= _polynomialSlopes[index3] * num2;
        }
        ++iandex4;
      }
      ++index1;
    }
    for (int iindex1 = length - 1; iindex1 >= 0; iindex1--) {
      if (numArray2[iindex1] != numArray1[iindex1]) {
        for (int iindex2 = 0; iindex2 < length; iindex2++) {
          final num number = matrix[iindex2][numArray2[iindex1]];
          matrix[iindex2][numArray2[iindex1]] =
              matrix[iindex2][numArray1[iindex1]];
          matrix[iindex2][numArray1[iindex1]] = number;
        }
      }
    }
    return true;
  }

  /// It returns the polynomial points
  List<Offset> getPolynomialCurve(
      List<CartesianChartPoint<dynamic>> points,
      CartesianSeriesRenderer seriesRenderer,
      SfCartesianChartState _chartState) {
    final List<Offset> polyPoints = <Offset>[];
    final dynamic start = seriesRenderer._xAxisRenderer is DateTimeAxisRenderer
        ? points[0].xValue
        : points[0].x;
    final dynamic end = seriesRenderer._xAxisRenderer is DateTimeAxisRenderer
        ? points[points.length - 1].xValue
        : points[points.length - 1].xValue;
    for (dynamic x = start;
        polyPoints.length <= 100;
        x += (end - start) / 100) {
      final dynamic y = _getPolynomialYValue(_polynomialSlopes, x);
      final _ChartLocation position = _calculatePoint(
          x,
          y,
          seriesRenderer._xAxisRenderer,
          seriesRenderer._yAxisRenderer,
          _chartState._requireInvertedAxis,
          seriesRenderer._series,
          _chartState._chartAxis._axisClipRect);
      polyPoints.add(Offset(position.x, position.y));
    }
    return polyPoints;
  }

  /// To return predicted forecast values
  dynamic _getForecastDate(dynamic axisRenderer, bool _isForward) {
    Duration duration = const Duration(seconds: 0);
    final DateTimeAxis axis = axisRenderer._axis;
    switch (axis.intervalType) {
      case DateTimeIntervalType.auto:
        duration = const Duration(seconds: 0);
        break;
      case DateTimeIntervalType.years:
        duration = Duration(
            days: (365.25 *
                    (_isForward
                        ? _trendline.forwardForecast
                        : _trendline.backwardForecast))
                .round());
        break;
      case DateTimeIntervalType.months:
        duration = Duration(
            days: 31 *
                (_isForward
                        ? _trendline.forwardForecast
                        : _trendline.backwardForecast)
                    .round());
        break;
      case DateTimeIntervalType.days:
        duration = Duration(
            days: (_isForward
                    ? _trendline.forwardForecast
                    : _trendline.backwardForecast)
                .round());
        break;
      case DateTimeIntervalType.hours:
        duration = Duration(
            hours: (_isForward
                    ? _trendline.forwardForecast
                    : _trendline.backwardForecast)
                .round());
        break;
      case DateTimeIntervalType.minutes:
        duration = Duration(
            minutes: (_isForward
                    ? _trendline.forwardForecast
                    : _trendline.backwardForecast)
                .round());
        break;
      case DateTimeIntervalType.seconds:
        duration = Duration(
            seconds: (_isForward
                    ? _trendline.forwardForecast
                    : _trendline.backwardForecast)
                .round());
    }
    return duration.inMilliseconds;
  }
}

class _SlopeIntercept {
  num slope;
  num intercept;
}
