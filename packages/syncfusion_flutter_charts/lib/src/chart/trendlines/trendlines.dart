import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../base/chart_base.dart';
import '../chart_series/candle_series.dart';
import '../chart_series/hilo_series.dart';
import '../chart_series/hiloopenclose_series.dart';
import '../chart_series/range_area_series.dart';
import '../chart_series/range_column_series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/stacked_series_base.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/marker.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

export 'package:syncfusion_flutter_core/core.dart'
    show DataMarkerType, TooltipAlignment;

/// Renders the chart trendline.
///
/// A trendline is a straight line that connects two or more price points
/// and then extends into the future to act as a line of support.
/// Trendlines provide support for forward and backward forecastings.
///
/// Provides option to customize the trendline types, [width], [forwardForecast] and [backwardForecast].
class Trendline {
  /// Creating an argument constructor of Trendline class.
  Trendline(
      {this.enableTooltip = true,
      this.intercept,
      this.name,
      this.dashArray,
      this.color = Colors.blue,
      this.type = TrendlineType.linear,
      this.backwardForecast = 0,
      this.forwardForecast = 0,
      this.opacity = 1,
      this.isVisible = true,
      this.width = 2,
      this.animationDuration = 1500,
      this.animationDelay = 0,
      this.valueField = 'high',
      this.isVisibleInLegend = true,
      this.legendIconType = LegendIconType.horizontalLine,
      this.markerSettings = const MarkerSettings(),
      this.polynomialOrder = 2,
      this.period = 2,
      this.onRenderDetailsUpdate});

  /// Determines the animation time of trendline.
  ///
  /// Defaults to `1500 `.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(animationDuration: 150)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double animationDuration;

  /// Delay duration of the trendline animation.
  /// It takes a millisecond value as input.
  /// By default,the trendline will get animated for the specified duration.
  /// If animationDelay is specified, then the trendline will begin to animate
  /// after the specified duration.
  ///
  /// Defaults to '0'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(animationDelay: 500)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double? animationDelay;

  /// Specifies the backward forecasting of trendlines.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(backwardForecast: 3)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double backwardForecast;

  /// Specifies the forward forecasting of trendlines.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(forwardForecast: 3)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double forwardForecast;

  /// Width of trendlines.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(width: 4)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double width;

  /// Opacity of the trendline.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(opacity: 0.85)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double opacity;

  /// Pattern of dashes and gaps used to stroke the trendline.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(dashArray: <double>[2,3])
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final List<double>? dashArray;

  /// Enables the tooltip for trendlines.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(enableTooltip: false)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final bool enableTooltip;

  /// Color of the trendline.
  ///
  /// Defaults to `Colors.blue`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(color: Colors.greenAccent)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final Color color;

  /// Provides the name for trendline.
  ///
  /// Defaults to `type` of the trendline chosen.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(name: 'Trendline1')
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final String? name;

  /// Specifies the intercept value of the trendlines.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(intercept: 20)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final double? intercept;

  /// Determines the visibility of the trendline.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(isVisible: false)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final bool isVisible;

  /// Specifies the type of legend icon for trendline.
  ///
  /// Defaults to `LegendIconType.HorizontalLine`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(legendIconType: LegendIconType.circle)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final LegendIconType legendIconType;

  /// Specifies the intercept value of the trendlines.
  ///
  /// Defaults to `TrendlineType.linear`.
  ///
  /// Also refer [TrendlineType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(type: TrendlineType.power)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final TrendlineType type;

  /// To choose the valueField(low or high) to render the trendline.
  ///
  /// Defaults to `high`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(valueField: 'low')
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final String valueField;

  /// Settings to configure the marker of trendline.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(
  ///             markerSettings: MarkerSettings(isVisible: true)
  ///           )
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final MarkerSettings markerSettings;

  /// Show/hides the legend for trendline.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(isVisibleInLegend: false)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final bool isVisibleInLegend;

  /// Specifies the order of the polynomial for polynomial trendline.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(
  ///             type: TrendlineType.polynomial,
  ///             polynomialOrder: 4
  ///           )
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final int polynomialOrder;

  /// Specifies the period for moving average trendline.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           Trendline(period: 3)
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final int period;

  /// Callback which gets called while rendering the trendline.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <CartesianSeries<ChartData,String>>[
  ///       LineSeries<ChartData,String>(
  ///         trendlines: <TrendLine>[
  ///           onRenderDetailsUpdate: (TrendlineRenderParams args) {
  ///             print('Slope value: ' + args.slope[0]);
  ///             print('r-squared value: ' + args.rSquaredValue);
  ///             print('Intercept value (x): ' + args.intercept);
  ///           }
  ///         ]
  ///       )
  ///     ]
  ///   );
  /// }
  /// ```
  final ChartTrendlineRenderCallback? onRenderDetailsUpdate;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is Trendline &&
        other.enableTooltip == enableTooltip &&
        other.intercept == intercept &&
        other.name == name &&
        other.dashArray == dashArray &&
        other.color == color &&
        other.type == type &&
        other.backwardForecast == backwardForecast &&
        other.forwardForecast == forwardForecast &&
        other.opacity == opacity &&
        other.isVisible == isVisible &&
        other.width == width &&
        other.animationDuration == animationDuration &&
        other.valueField == valueField &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.markerSettings == markerSettings &&
        other.polynomialOrder == polynomialOrder &&
        other.period == period;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      enableTooltip,
      intercept,
      name,
      dashArray,
      color,
      type,
      backwardForecast,
      forwardForecast,
      opacity,
      isVisible,
      width,
      animationDuration,
      valueField,
      isVisibleInLegend,
      legendIconType,
      markerSettings,
      polynomialOrder,
      period
    ];
    return Object.hashAll(values);
  }
}

/// Trendline renderer class for mutable fields and methods.
class TrendlineRenderer {
  /// Creates an argument constructor for Trendline renderer class.
  TrendlineRenderer(this.trendline) {
    opacity = trendline.opacity;
    dashArray = trendline.dashArray;
    fillColor = trendline.color;
    visible = trendline.isVisible;
    name = trendline.name;
  }

  /// Holds the value of trendline.
  final Trendline trendline;

  /// Holds the collection of Cartesian data points.
  List<CartesianChartPoint<dynamic>>? pointsData;

  /// Holds the slope intercept.
  // ignore: library_private_types_in_public_api
  _SlopeIntercept slopeIntercept = _SlopeIntercept();

  /// Holds the slope intercept value for equation.
  // ignore: library_private_types_in_public_api
  _SlopeIntercept slopeInterceptData = _SlopeIntercept();

  /// Holds the polynomial slopes.
  List<dynamic>? polynomialSlopes;

  /// Holds the polynomial slopes for equation.
  List<double>? polynomialSlopesData;

  /// Holds the list of marker shapes.
  late List<Path> markerShapes;

  /// Holds the list of point value.
  late List<Offset> points;

  /// Holds the opacity value.
  late double opacity;

  /// Holds the list of dash array.
  List<double>? dashArray;

  /// Holds the fill color value.
  late Color fillColor;

  /// Specifies whether the trendline is visible.
  late bool visible;

  /// Specifies the value of name.
  String? name;

  /// Specifies whether the renderer is needed.
  late bool isNeedRender;

  /// Holds the value of animation controller.
  late AnimationController animationController;

  /// Checks whether the trendline rendered event is specified.
  bool isTrendlineRenderEvent = false;

  late SeriesRendererDetails _seriesRendererDetails;

  // In excel, the date is considered from Jan 1, 1900. To achieve the same scenario, we have considered the year from 1900.
  // Reference link: https://support.microsoft.com/en-us/office/datevalue-function-df8b07d4-7761-4a93-bc33-b7471bbff252
  /// Holds the excel starting date value.
  final DateTime excelDate = DateTime(1900);

  /// Defines the data point of trendline.
  CartesianChartPoint<dynamic> getDataPoint(
      dynamic x,
      num y,
      CartesianChartPoint<dynamic> sourcePoint,
      SeriesRendererDetails seriesRendererDetails,
      int index) {
    final CartesianChartPoint<dynamic> trendPoint =
        CartesianChartPoint<dynamic>(x, y);
    trendPoint.x = (seriesRendererDetails.xAxisDetails is DateTimeAxisRenderer)
        ? DateTime.fromMillisecondsSinceEpoch(x.floor())
        : x;
    trendPoint.y = y;
    trendPoint.xValue = x;
    trendPoint.pointColorMapper = _seriesRendererDetails.series.color;
    trendPoint.index = index;
    trendPoint.yValue = y;
    trendPoint.isVisible = true;
    seriesRendererDetails.minimumX =
        math.min(seriesRendererDetails.minimumX!, trendPoint.xValue);
    seriesRendererDetails.minimumY =
        math.min(seriesRendererDetails.minimumY!, trendPoint.yValue);
    seriesRendererDetails.maximumX =
        math.max(seriesRendererDetails.maximumX!, trendPoint.xValue);
    seriesRendererDetails.maximumY =
        math.max(seriesRendererDetails.maximumY!, trendPoint.yValue);
    return trendPoint;
  }

  /// Defines the linear points.
  List<CartesianChartPoint<dynamic>> getLinearPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      SeriesRendererDetails seriesRendererDetails,
      // ignore: library_private_types_in_public_api
      _SlopeIntercept slopeInterceptLinear) {
    num x1Linear, x2Linear;
    final List<CartesianChartPoint<dynamic>> pts =
        <CartesianChartPoint<dynamic>>[];
    xValues.sort();
    if (seriesRendererDetails.xAxisDetails is DateTimeAxisRenderer) {
      x1Linear = _increaseDateTimeForecast(
          seriesRendererDetails.xAxisDetails as DateTimeAxisRenderer,
          xValues[0],
          -trendline.backwardForecast);
      x2Linear = _increaseDateTimeForecast(
          seriesRendererDetails.xAxisDetails as DateTimeAxisRenderer,
          xValues[xValues.length - 1],
          trendline.forwardForecast);
    } else {
      x1Linear = xValues[0] - trendline.backwardForecast;
      x2Linear = xValues[xValues.length - 1] + trendline.forwardForecast;
    }
    final num y1Linear = slopeInterceptLinear.slope! * x1Linear +
        slopeInterceptLinear.intercept!;
    final num y2Linear = slopeInterceptLinear.slope! * x2Linear +
        slopeInterceptLinear.intercept!;
    pts.add(getDataPoint(
        x1Linear, y1Linear, points[0], seriesRendererDetails, pts.length));
    pts.add(getDataPoint(x2Linear, y2Linear, points[points.length - 1],
        seriesRendererDetails, pts.length));
    return pts;
  }

  /// Setting the linear range for trendline series.
  void _setLinearRange(List<CartesianChartPoint<dynamic>> points,
      SeriesRendererDetails seriesRendererDetails) {
    final List<dynamic> xValues = <dynamic>[];
    final List<int> slopeInterceptXValues = <int>[];
    final List<num> yValues = <num>[];
    int index = 0;
    const int startXValue = 1;
    while (index < points.length) {
      final CartesianChartPoint<dynamic> point = points[index];
      xValues.add(point.xValue ?? point.x);
      slopeInterceptXValues.add((seriesRendererDetails
              .xAxisDetails?.axisRenderer is DateTimeAxisRenderer)
          ? point.x.difference(excelDate).inDays
          : startXValue + index);
      (!(seriesRendererDetails.series is RangeAreaSeries ||
              seriesRendererDetails.series is RangeColumnSeries ||
              seriesRendererDetails.series is HiloSeries ||
              seriesRendererDetails.series is HiloOpenCloseSeries ||
              seriesRendererDetails.series is CandleSeries))
          ? yValues.add(point.yValue ?? point.y)
          : yValues.add(trendline.valueField.toLowerCase() == 'low'
              ? point.low
              : point.high);

      index++;
    }
    slopeIntercept = _findSlopeIntercept(xValues, yValues, points);
    if (!slopeIntercept.slope!.isNaN && !slopeIntercept.intercept!.isNaN)
      pointsData = getLinearPoints(
          points, xValues, yValues, seriesRendererDetails, slopeIntercept);
    slopeInterceptData =
        _findSlopeIntercept(slopeInterceptXValues, yValues, points);
  }

  /// Defines Exponential Points.
  List<CartesianChartPoint<dynamic>> getExponentialPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      SeriesRendererDetails seriesRendererDetails,
      // ignore: library_private_types_in_public_api
      _SlopeIntercept slopeInterceptExpo) {
    num x1, x2, x3;
    final int midPoint = (points.length / 2).round();
    final List<CartesianChartPoint<dynamic>> ptsExpo =
        <CartesianChartPoint<dynamic>>[];
    if (seriesRendererDetails.xAxisDetails is DateTimeAxisRenderer) {
      x1 = _increaseDateTimeForecast(
          seriesRendererDetails.xAxisDetails as DateTimeAxisRenderer,
          xValues[0],
          -trendline.backwardForecast);
      x2 = xValues[midPoint - 1];
      x3 = _increaseDateTimeForecast(
          seriesRendererDetails.xAxisDetails as DateTimeAxisRenderer,
          xValues[xValues.length - 1],
          trendline.forwardForecast);
    } else {
      x1 = xValues[0] - trendline.backwardForecast;
      x2 = xValues[midPoint - 1];
      x3 = xValues[xValues.length - 1] + trendline.forwardForecast;
    }
    final num y1 = slopeInterceptExpo.intercept! *
        math.exp(slopeInterceptExpo.slope! * x1);

    final num y2 = slopeInterceptExpo.intercept! *
        math.exp(slopeInterceptExpo.slope! * x2);

    final num y3 = slopeInterceptExpo.intercept! *
        math.exp(slopeInterceptExpo.slope! * x3);
    ptsExpo.add(getDataPoint(x1, y1.isNaN ? 0 : y1, points[0],
        seriesRendererDetails, ptsExpo.length));
    ptsExpo.add(getDataPoint(x2, y2.isNaN ? 0 : y2, points[midPoint - 1],
        seriesRendererDetails, ptsExpo.length));
    ptsExpo.add(getDataPoint(x2, y2.isNaN ? 0 : y2, points[midPoint - 1],
        seriesRendererDetails, ptsExpo.length));
    ptsExpo.add(getDataPoint(x3, y3.isNaN ? 0 : y3, points[points.length - 1],
        seriesRendererDetails, ptsExpo.length));
    // avoid rendering trendline when values are NaN
    if (y1.isNaN || y2.isNaN || y3.isNaN) {
      for (int i = 0; i < ptsExpo.length; i++) {
        ptsExpo[i].x = 0;
        ptsExpo[i].y = 0;
      }
    }
    return ptsExpo;
  }

  /// Setting the exponential range for trendline series.
  void _setExponentialRange(List<CartesianChartPoint<dynamic>> points,
      SeriesRendererDetails seriesRendererDetails) {
    final List<dynamic> xValues = <dynamic>[];
    final List<int> slopeInterceptXValues = <int>[];
    final List<num> yValues = <num>[];
    int index = 0;
    const int startXValue = 1;
    while (index < points.length) {
      final CartesianChartPoint<dynamic> point = points[index];
      xValues.add(point.xValue ?? point.x);
      slopeInterceptXValues.add(seriesRendererDetails.xAxisDetails?.axisRenderer
              is DateTimeAxisRenderer
          ? seriesRendererDetails.dataPoints[index].x
              .difference(excelDate)
              .inDays
          : startXValue + index);
      (!(seriesRendererDetails.series is RangeAreaSeries ||
              seriesRendererDetails.series is RangeColumnSeries ||
              seriesRendererDetails.series is HiloSeries ||
              seriesRendererDetails.series is HiloOpenCloseSeries ||
              seriesRendererDetails.series is CandleSeries))
          ? yValues.add(math.log(point.yValue ?? point.y))
          : yValues.add(trendline.valueField.toLowerCase() == 'low'
              ? math.log(point.low)
              : math.log(point.high));

      index++;
    }
    xValues.sort();
    slopeIntercept = _findSlopeIntercept(xValues, yValues, points);
    if (!slopeIntercept.slope!.isNaN && !slopeIntercept.intercept!.isNaN)
      pointsData = getExponentialPoints(
          points, xValues, yValues, seriesRendererDetails, slopeIntercept);
    slopeInterceptData =
        _findSlopeIntercept(slopeInterceptXValues, yValues, points);
  }

  /// Defines Power Points.
  List<CartesianChartPoint<dynamic>> getPowerPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      SeriesRendererDetails seriesRendererDetails,
      // ignore: library_private_types_in_public_api
      _SlopeIntercept slopeInterceptPow) {
    num x1, x2, x3;
    final int midPoint = (points.length / 2).round();
    final List<CartesianChartPoint<dynamic>> ptsPow =
        <CartesianChartPoint<dynamic>>[];
    if (seriesRendererDetails.xAxisDetails is DateTimeAxisRenderer) {
      x1 = _increaseDateTimeForecast(
          seriesRendererDetails.xAxisDetails as DateTimeAxisRenderer,
          xValues[0],
          -trendline.backwardForecast);
      x2 = xValues[midPoint - 1];
      x3 = _increaseDateTimeForecast(
          seriesRendererDetails.xAxisDetails as DateTimeAxisRenderer,
          xValues[xValues.length - 1],
          trendline.forwardForecast);
    } else {
      x1 = xValues[0] - trendline.backwardForecast;
      x1 = x1 > -1 ? x1 : 0;
      x2 = xValues[midPoint - 1];
      x3 = xValues[xValues.length - 1] + trendline.forwardForecast;
    }
    final num y1 = x1 == 0
        ? 0
        : slopeInterceptPow.intercept! * math.pow(x1, slopeInterceptPow.slope!);
    final num y2 =
        slopeInterceptPow.intercept! * math.pow(x2, slopeInterceptPow.slope!);
    final num y3 =
        slopeInterceptPow.intercept! * math.pow(x3, slopeInterceptPow.slope!);
    ptsPow.add(getDataPoint(x1, y1.isNaN ? 0 : y1, points[0],
        seriesRendererDetails, ptsPow.length));
    ptsPow.add(getDataPoint(x2, y2.isNaN ? 0 : y2, points[midPoint - 1],
        seriesRendererDetails, ptsPow.length));
    ptsPow.add(getDataPoint(x3, y3.isNaN ? 0 : y3, points[points.length - 1],
        seriesRendererDetails, ptsPow.length));
    // avoid rendering trendline when values are NaN
    if (y1.isNaN || y2.isNaN || y3.isNaN) {
      for (int i = 0; i < ptsPow.length; i++) {
        ptsPow[i].x = 0;
        ptsPow[i].y = 0;
      }
    }
    return ptsPow;
  }

  /// Setting the power range values for trendline series.
  void _setPowerRange(List<CartesianChartPoint<dynamic>> points,
      SeriesRendererDetails seriesRendererDetails) {
    final List<dynamic> xValues = <dynamic>[];
    final List<num> slopeInterceptXValues = <num>[];
    final List<num> yValues = <num>[];
    final List<dynamic> powerPoints = <dynamic>[];
    int index = 0;
    const int startXValue = 1;
    while (index < points.length) {
      final CartesianChartPoint<dynamic> point = points[index];
      powerPoints.add(point.xValue ?? point.x);
      final dynamic xVal =
          point.xValue != null && math.log(point.xValue).isFinite
              ? math.log(point.xValue)
              : (seriesRendererDetails.xAxisDetails?.axisRenderer
                          is CategoryAxisRenderer ||
                      seriesRendererDetails.xAxisDetails?.axisRenderer
                          is DateTimeCategoryAxisRenderer)
                  ? point.xValue
                  : point.x;
      xValues.add(xVal);
      slopeInterceptXValues.add(math.log(seriesRendererDetails
              .xAxisDetails?.axisRenderer is DateTimeAxisRenderer
          ? seriesRendererDetails.dataPoints[index].x
              .difference(excelDate)
              .inDays
          : startXValue + index));
      (!(seriesRendererDetails.series is RangeAreaSeries ||
              seriesRendererDetails.series is RangeColumnSeries ||
              seriesRendererDetails.series is HiloSeries ||
              seriesRendererDetails.series is HiloOpenCloseSeries ||
              seriesRendererDetails.series is CandleSeries))
          ? yValues.add(math.log(point.yValue ?? point.y))
          : yValues.add(trendline.valueField.toLowerCase() == 'low'
              ? math.log(point.low)
              : math.log(point.high));
      index++;
    }
    powerPoints.sort();
    slopeIntercept = _findSlopeIntercept(xValues, yValues, points);
    if (!slopeIntercept.slope!.isNaN && !slopeIntercept.intercept!.isNaN)
      pointsData = getPowerPoints(
          points, powerPoints, yValues, seriesRendererDetails, slopeIntercept);
    slopeInterceptData =
        _findSlopeIntercept(slopeInterceptXValues, yValues, points);
  }

  /// Defines Logarithmic Points.
  List<CartesianChartPoint<dynamic>> getLogarithmicPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      SeriesRendererDetails seriesRendererDetails,
      // ignore: library_private_types_in_public_api
      _SlopeIntercept slopeInterceptLog) {
    num x1, x2, x3;
    final int midPoint = (points.length / 2).round();
    final List<CartesianChartPoint<dynamic>> ptsLog =
        <CartesianChartPoint<dynamic>>[];
    if (seriesRendererDetails.xAxisDetails is DateTimeAxisRenderer) {
      x1 = _increaseDateTimeForecast(
          seriesRendererDetails.xAxisDetails as DateTimeAxisRenderer,
          xValues[0],
          -trendline.backwardForecast);
      x2 = xValues[midPoint - 1];
      x3 = _increaseDateTimeForecast(
          seriesRendererDetails.xAxisDetails as DateTimeAxisRenderer,
          xValues[xValues.length - 1],
          trendline.forwardForecast);
    } else {
      x1 = xValues[0] - trendline.backwardForecast;
      x2 = xValues[midPoint - 1];
      x3 = xValues[xValues.length - 1] + trendline.forwardForecast;
    }
    final num y1 = slopeInterceptLog.intercept! +
        (slopeInterceptLog.slope! *
            (math.log(x1).isFinite ? math.log(x1) : x1));
    final num y2 = slopeInterceptLog.intercept! +
        (slopeInterceptLog.slope! *
            (math.log(x2).isFinite ? math.log(x2) : x2));
    final num y3 = slopeInterceptLog.intercept! +
        (slopeInterceptLog.slope! *
            (math.log(x3).isFinite ? math.log(x3) : x3));
    ptsLog.add(
        getDataPoint(x1, y1, points[0], seriesRendererDetails, ptsLog.length));
    ptsLog.add(getDataPoint(
        x2, y2, points[midPoint - 1], seriesRendererDetails, ptsLog.length));
    ptsLog.add(getDataPoint(x3, y3, points[points.length - 1],
        seriesRendererDetails, ptsLog.length));
    return ptsLog;
  }

  /// Setting the logarithmic range for trendline series.
  void _setLogarithmicRange(List<CartesianChartPoint<dynamic>> points,
      SeriesRendererDetails seriesRendererDetails) {
    final List<dynamic> xLogValue = <dynamic>[];
    final List<num> slopeInterceptXLogValue = <num>[];
    final List<num> yLogValue = <num>[];
    final List<dynamic> xPointsLgr = <dynamic>[];
    int index = 0;
    const int startXValue = 1;
    while (index < points.length) {
      final CartesianChartPoint<dynamic> point = points[index];
      xPointsLgr.add(point.xValue ?? point.x);
      final dynamic xVal =
          (point.xValue != null && math.log(point.xValue).isFinite)
              ? math.log(point.xValue)
              : (seriesRendererDetails.xAxisDetails?.axisRenderer
                          is CategoryAxisRenderer ||
                      seriesRendererDetails.xAxisDetails?.axisRenderer
                          is DateTimeCategoryAxisRenderer)
                  ? point.xValue
                  : point.x;
      xLogValue.add(xVal);
      slopeInterceptXLogValue.add(math.log(seriesRendererDetails
              .xAxisDetails?.axisRenderer is DateTimeAxisRenderer
          ? points[index].x.difference(excelDate).inDays
          : startXValue + index));
      (!(seriesRendererDetails.series is RangeAreaSeries ||
              seriesRendererDetails.series is RangeColumnSeries ||
              seriesRendererDetails.series is HiloSeries ||
              seriesRendererDetails.series is HiloOpenCloseSeries ||
              seriesRendererDetails.series is CandleSeries))
          ? yLogValue.add(point.yValue ?? point.y)
          : yLogValue.add(trendline.valueField.toLowerCase() == 'low'
              ? point.low
              : point.high);
      index++;
    }
    xPointsLgr.sort();
    slopeIntercept = _findSlopeIntercept(xLogValue, yLogValue, points);
    if (!slopeIntercept.slope!.isNaN && !slopeIntercept.intercept!.isNaN)
      pointsData = getLogarithmicPoints(
          points, xPointsLgr, yLogValue, seriesRendererDetails, slopeIntercept);
    slopeInterceptData =
        _findSlopeIntercept(slopeInterceptXLogValue, yLogValue, points);
  }

  /// Defines Polynomial points.
  List<CartesianChartPoint<dynamic>> _getPolynomialPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      SeriesRendererDetails seriesRendererDetails) {
    //ignore: unused_local_variable
    final int midPoint = (points.length / 2).round();
    const int startXValue = 1;
    List<CartesianChartPoint<dynamic>> pts = <CartesianChartPoint<dynamic>>[];
    polynomialSlopes =
        List<dynamic>.filled(trendline.polynomialOrder + 1, null);

    for (int i = 0; i < xValues.length; i++) {
      final dynamic xVal = xValues[i];
      final num yVal = yValues[i];
      for (int j = 0; j <= trendline.polynomialOrder; j++) {
        polynomialSlopes![j] ??= 0;
        polynomialSlopes![j] += pow(xVal.toDouble(), j) * yVal;
      }
    }

    final List<dynamic> matrix = _getMatrix(trendline, xValues);
    if (!_gaussJordanElimination(matrix, polynomialSlopes!)) {
      // The trendline will not be generated if there is just one data point or if the x and y values are the same,
      // for example (1,1), (1,1). So, the line was commented. And now marker alone will be rendered in this case.
      // _polynomialSlopes = null;
    }
    pts = _getPoints(points, xValues, yValues, seriesRendererDetails);
    if (trendline.onRenderDetailsUpdate != null) {
      polynomialSlopesData =
          List<double>.filled(trendline.polynomialOrder + 1, 0);

      for (int i = 0; i < xValues.length; i++) {
        final num yVal = yValues[i];
        for (int j = 0; j <= trendline.polynomialOrder; j++) {
          polynomialSlopesData![j] += pow(
                  seriesRendererDetails.xAxisDetails?.axisRenderer
                          is DateTimeAxisRenderer
                      ? points[i].x.difference(excelDate).inDays
                      : startXValue + i.toDouble(),
                  j) *
              yVal;
        }
      }
      final List<num> xData = <num>[];
      for (int i = 0; i < xValues.length; i++) {
        xData.add(seriesRendererDetails.xAxisDetails?.axisRenderer
                is DateTimeAxisRenderer
            ? points[i].x.difference(excelDate).inDays
            : startXValue + i.toDouble());
      }
      final List<dynamic> matrix = _getMatrix(trendline, xData);
      // To find the prompt polynomial slopes for the trendline equation, gaussJordanElimination method is used here.
      if (!_gaussJordanElimination(matrix, polynomialSlopesData!)) {}
    }
    return pts;
  }

  /// Get matrix values for polynomial type.
  List<dynamic> _getMatrix(Trendline trendline, dynamic xValues) {
    final List<dynamic> numArray =
        List<dynamic>.filled(2 * trendline.polynomialOrder + 1, null);
    final List<dynamic> matrix =
        List<dynamic>.filled(trendline.polynomialOrder + 1, null);
    for (int i = 0; i <= trendline.polynomialOrder; i++) {
      matrix[i] = List<dynamic>.filled(trendline.polynomialOrder + 1, null);
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

    for (int i = 0; i <= trendline.polynomialOrder; i++) {
      for (int j = 0; j <= trendline.polynomialOrder; j++) {
        matrix[i][j] = numArray[i + j];
      }
    }
    return matrix;
  }

  /// Setting the polynomial range for trendline series.
  void _setPolynomialRange(List<CartesianChartPoint<dynamic>> points,
      SeriesRendererDetails seriesRendererDetails) {
    final List<dynamic> xPolyValues = <dynamic>[];
    final List<num> yPolyValues = <num>[];
    int index = 0;
    while (index < points.length) {
      final CartesianChartPoint<dynamic> point = points[index];
      xPolyValues.add(point.xValue ?? point.x);
      (!(seriesRendererDetails.series is RangeAreaSeries ||
              seriesRendererDetails.series is RangeColumnSeries ||
              seriesRendererDetails.series is HiloSeries ||
              seriesRendererDetails.series is HiloOpenCloseSeries ||
              seriesRendererDetails.series is CandleSeries))
          ? yPolyValues.add(point.yValue ?? point.y)
          : yPolyValues.add(trendline.valueField.toLowerCase() == 'low'
              ? point.low
              : point.high);
      index++;
    }
    xPolyValues.sort();
    pointsData = _getPolynomialPoints(
        points, xPolyValues, yPolyValues, seriesRendererDetails);
  }

  /// To return points list.
  List<CartesianChartPoint<dynamic>> _getPoints(
      List<CartesianChartPoint<dynamic>> points,
      dynamic xValues,
      List<num> yValues,
      SeriesRendererDetails seriesRendererDetails) {
    //ignore: unused_local_variable
    final int midPoint = (points.length / 2).round();
    final List<dynamic> polynomialSlopesList = polynomialSlopes!;
    final List<CartesianChartPoint<dynamic>> pts =
        <CartesianChartPoint<dynamic>>[];

    num x1 = 1;
    dynamic xVal;
    num yVal;
    final num backwardForecast =
        seriesRendererDetails.xAxisDetails is DateTimeAxisDetails
            ? _getForecastDate(seriesRendererDetails.xAxisDetails!, false)
            : trendline.backwardForecast;
    final num forwardForecast =
        seriesRendererDetails.xAxisDetails is DateTimeAxisDetails
            ? _getForecastDate(seriesRendererDetails.xAxisDetails!, true)
            : trendline.forwardForecast;

    for (int index = 1; index <= polynomialSlopesList.length; index++) {
      if (index == 1) {
        xVal = xValues[0] - backwardForecast.toDouble();
        yVal = _getPolynomialYValue(polynomialSlopesList, xVal);
        pts.add(getDataPoint(
            xVal, yVal, points[0], seriesRendererDetails, pts.length));
      } else if (index == polynomialSlopesList.length) {
        xVal = xValues[points.length - 1] + forwardForecast.toDouble();
        yVal = _getPolynomialYValue(polynomialSlopesList, xVal);
        pts.add(getDataPoint(xVal, yVal, points[points.length - 1],
            seriesRendererDetails, pts.length));
      } else {
        x1 += (points.length + trendline.forwardForecast) /
            polynomialSlopesList.length;
        xVal = xValues[x1.floor() - 1] * 1.0;
        yVal = _getPolynomialYValue(polynomialSlopesList, xVal);
        pts.add(getDataPoint(xVal, yVal, points[x1.floor() - 1],
            seriesRendererDetails, pts.length));
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

  /// Defines moving average points.
  List<CartesianChartPoint<dynamic>> getMovingAveragePoints(
      List<CartesianChartPoint<dynamic>> points,
      List<dynamic> xValues,
      List<num?> yValues,
      SeriesRendererDetails seriesRendererDetails) {
    final List<CartesianChartPoint<dynamic>> pts =
        <CartesianChartPoint<dynamic>>[];
    int periods = trendline.period >= points.length
        ? points.length - 1
        : trendline.period;
    periods = max(2, periods);
    double? y;
    dynamic x;
    int count, nullCount;
    for (int index = 0; index < points.length - 1; index++) {
      y = 0.0;
      count = nullCount = 0;
      for (int j = index; count < periods; j++) {
        count++;
        if (j >= yValues.length || yValues[j] == null) {
          nullCount++;
        }
        y = y! + (j >= yValues.length ? 0 : yValues[j]!);
      }
      y = ((periods - nullCount) <= 0) ? null : (y! / (periods - nullCount));
      if (y != null && !y.isNaN && index + periods < xValues.length + 1) {
        x = xValues[periods - 1 + index];
        pts.add(getDataPoint(x, y, points[periods - 1 + index],
            seriesRendererDetails, pts.length));
      }
    }
    return pts;
  }

  /// Setting the moving average range for trendline series.
  void _setMovingAverageRange(List<CartesianChartPoint<dynamic>> points,
      SeriesRendererDetails seriesRendererDetails) {
    final List<dynamic> xValues = <dynamic>[], xAvgValues = <dynamic>[];
    final List<num> yValues = <num>[];

    for (int index = 0; index < points.length; index++) {
      final dynamic point = points[index];
      xAvgValues.add(point.xValue ?? point.x);
      xValues.add(index + 1);
      (!(seriesRendererDetails.series is RangeAreaSeries ||
              seriesRendererDetails.series is RangeColumnSeries ||
              seriesRendererDetails.series is HiloSeries ||
              seriesRendererDetails.series is HiloOpenCloseSeries ||
              seriesRendererDetails.series is CandleSeries))
          ? yValues.add(point.yValue ?? point.y)
          : yValues.add(trendline.valueField.toLowerCase() == 'low'
              ? point.low
              : point.high);
    }
    xAvgValues.sort();
    pointsData = getMovingAveragePoints(
        points, xAvgValues, yValues, seriesRendererDetails);
  }

  /// Setting the slope intercept for trendline series.
  _SlopeIntercept _findSlopeIntercept(dynamic xValues, dynamic yValues,
      List<CartesianChartPoint<dynamic>> points) {
    double xAvg = 0.0, yAvg = 0.0, xyAvg = 0.0, xxAvg = 0.0;
    int index = 0;
    double slope = 0.0, intercept = 0.0;
    while (index < points.length) {
      if (yValues[index].isNaN == true) {
        yValues[index] = (yValues[index - 1] + yValues[index + 1]) / 2;
      }
      xAvg += xValues[index];
      yAvg += yValues[index];
      xyAvg += xValues[index].toDouble() * yValues[index].toDouble();
      xxAvg += xValues[index].toDouble() * xValues[index].toDouble();
      index++;
    }
    if (trendline.intercept != null &&
        trendline.intercept != 0 &&
        (trendline.type == TrendlineType.linear ||
            trendline.type == TrendlineType.exponential)) {
      intercept = trendline.intercept!.toDouble();
      switch (trendline.type) {
        case TrendlineType.linear:
          slope = (xyAvg - (intercept * xAvg)) / xxAvg;
          break;
        case TrendlineType.exponential:
          slope = (xyAvg - (math.log(intercept.abs()) * xAvg)) / xxAvg;
          break;
        // ignore: no_default_cases
        default:
          break;
      }
    } else {
      slope = ((points.length * xyAvg) - (xAvg * yAvg)) /
          ((points.length * xxAvg) - (xAvg * xAvg));

      intercept = (trendline.type == TrendlineType.exponential ||
              trendline.type == TrendlineType.power)
          ? math.exp((yAvg - (slope * xAvg)) / points.length)
          : (yAvg - (slope * xAvg)) / points.length;
    }
    slopeIntercept.slope = slope;
    slopeIntercept.intercept = intercept;
    return slopeIntercept;
  }

  /// To set initial data source for trendlines.
  void _initDataSource(
      SfCartesianChart chart, SeriesRendererDetails seriesRendererDetails) {
    if (pointsData!.isNotEmpty) {
      switch (trendline.type) {
        case TrendlineType.linear:
          _setLinearRange(pointsData!, seriesRendererDetails);
          break;
        case TrendlineType.exponential:
          _setExponentialRange(pointsData!, seriesRendererDetails);
          break;
        case TrendlineType.power:
          _setPowerRange(pointsData!, seriesRendererDetails);
          break;
        case TrendlineType.logarithmic:
          _setLogarithmicRange(pointsData!, seriesRendererDetails);
          break;
        case TrendlineType.polynomial:
          _setPolynomialRange(pointsData!, seriesRendererDetails);
          break;
        case TrendlineType.movingAverage:
          _setMovingAverageRange(pointsData!, seriesRendererDetails);
          break;
      }
    }
  }

  /// To find the actual points of trend line series.
  void calculateTrendlinePoints(SeriesRendererDetails seriesRendererDetails,
      CartesianStateProperties stateProperties) {
    final Rect rect = calculatePlotOffset(
        stateProperties.chartAxis.axisClipRect,
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    points = <Offset>[];
    if (seriesRendererDetails.series.trendlines != null && pointsData != null) {
      for (int i = 0; i < pointsData!.length; i++) {
        if (pointsData![i].x != null && pointsData![i].y != null) {
          final ChartLocation currentChartPoint = pointsData![i].markerPoint =
              calculatePoint(
                  (seriesRendererDetails.xAxisDetails is DateTimeAxisRenderer)
                      ? pointsData![i].xValue
                      : pointsData![i].x,
                  pointsData![i].y,
                  seriesRendererDetails.xAxisDetails!,
                  seriesRendererDetails.yAxisDetails!,
                  stateProperties.requireInvertedAxis,
                  seriesRendererDetails.series,
                  rect);
          points.add(Offset(currentChartPoint.x, currentChartPoint.y));
          pointsData![i].region = Rect.fromLTRB(
              points[i].dx, points[i].dy, points[i].dx, points[i].dy);
        }
      }
      _calculateMarkerShapesPoint(seriesRendererDetails);
    }
  }

  /// Calculate marker shapes for trendlines.
  void _calculateMarkerShapesPoint(
      SeriesRendererDetails seriesRendererDetails) {
    markerShapes = <Path>[];
    for (int i = 0; i < pointsData!.length; i++) {
      final CartesianChartPoint<dynamic> point = pointsData![i];
      final DataMarkerType markerType = trendline.markerSettings.shape;
      final Size size =
          Size(trendline.markerSettings.width, trendline.markerSettings.height);
      markerShapes.add(getMarkerShapesPath(
          markerType,
          Offset(point.markerPoint!.x, point.markerPoint!.y),
          size,
          seriesRendererDetails));
    }
  }

  /// To set data source for trendlines.
  void setDataSource(
      SeriesRendererDetails? seriesRendererDetails, SfCartesianChart chart) {
    if (seriesRendererDetails?.series != null) {
      _seriesRendererDetails = seriesRendererDetails!;
      pointsData = seriesRendererDetails.dataPoints;
      if (seriesRendererDetails.renderer is StackedSeriesRenderer) {
        for (int i = 0; i < pointsData!.length; i++) {
          pointsData![i].y =
              seriesRendererDetails.stackingValues[0].endValues[i];
          pointsData![i].yValue =
              seriesRendererDetails.stackingValues[0].endValues[i];
        }
      }
      _initDataSource(chart, _seriesRendererDetails);
    }
  }

  /// To obtain control points for type curve trendlines.
  List<Offset> getControlPoints(List<Offset> dataPoints, int index) {
    List<num?> yCoef = <num?>[];
    final List<Offset> controlPoints = <Offset>[];
    final List<num> xValues = <num>[], yValues = <num>[];
    for (int i = 0; i < dataPoints.length; i++) {
      xValues.add(dataPoints[i].dx);
      yValues.add(dataPoints[i].dy);
    }
    yCoef = naturalSpline(
        xValues, yValues, yCoef, xValues.length, SplineType.natural);
    return calculateControlPoints(xValues, yValues, yCoef[index]!.toDouble(),
        yCoef[index + 1]!.toDouble(), index, controlPoints);
  }

  /// It returns the date-time values of trendline series.
  int _increaseDateTimeForecast(
      DateTimeAxisRenderer axisRenderer, int value, num interval) {
    final DateTimeAxis axis =
        AxisHelper.getAxisRendererDetails(axisRenderer).axis as DateTimeAxis;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    switch (axis.intervalType) {
      case DateTimeIntervalType.years:
        dateTime = DateTime(
            dateTime.year + interval.floor(), dateTime.month, dateTime.day);
        break;
      case DateTimeIntervalType.months:
        dateTime = DateTime(
            dateTime.year, dateTime.month + interval.floor(), dateTime.day);
        break;
      case DateTimeIntervalType.days:
        dateTime = DateTime(
            dateTime.year, dateTime.month, dateTime.day + interval.floor());
        break;
      case DateTimeIntervalType.hours:
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour + interval.floor());
        break;
      case DateTimeIntervalType.minutes:
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute + interval.floor());
        break;
      case DateTimeIntervalType.seconds:
        dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second + interval.floor());
        break;
      case DateTimeIntervalType.milliseconds:
        dateTime = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            dateTime.hour,
            dateTime.minute,
            dateTime.second,
            dateTime.millisecond + interval.floor());
        break;
      case DateTimeIntervalType.auto:
        break;
    }
    return dateTime.millisecondsSinceEpoch;
  }

  /// Boolean for gaussJordanElimination in polynomial type trendlines.
  bool _gaussJordanElimination(
      List<dynamic> matrix, List<dynamic> polynomialSlopesList) {
    final int length = matrix.length;
    final List<dynamic> numArray1 = List<dynamic>.filled(length, null);
    final List<dynamic> numArray2 = List<dynamic>.filled(length, null);
    final List<dynamic> numArray3 = List<dynamic>.filled(length, null);

    for (int index = 0; index < length; index++) {
      numArray3[index] = 0;
    }
    int index1 = 0;
    while (index1 < length) {
      num num1 = 0;
      int index2 = 0, index3 = 0, index4 = 0;
      while (index4 < length) {
        if (numArray3[index4] != 1) {
          int index5 = 0;
          while (index5 < length) {
            if (numArray3[index5] == 0 &&
                matrix[index4][index5].abs() >= num1 == true) {
              num1 = matrix[index4][index5].abs();
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
        final num num3 = polynomialSlopesList[index2];
        polynomialSlopesList[index2] = polynomialSlopesList[index3];
        polynomialSlopesList[index3] = num3;
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
      polynomialSlopesList[index3] *= num4;
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
          polynomialSlopesList[iandex4] -= polynomialSlopesList[index3] * num2;
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

  /// It returns the polynomial points.
  List<Offset> getPolynomialCurve(
      List<CartesianChartPoint<dynamic>> points,
      SeriesRendererDetails seriesRendererDetails,
      CartesianStateProperties stateProperties) {
    final List<Offset> polyPoints = <Offset>[];
    final dynamic start =
        seriesRendererDetails.xAxisDetails is DateTimeAxisRenderer
            ? points[0].xValue
            : points[0].x;
    final dynamic end =
        seriesRendererDetails.xAxisDetails is DateTimeAxisRenderer
            ? points[points.length - 1].xValue
            : points[points.length - 1].xValue;
    for (dynamic x = start;
        polyPoints.length <= 100;
        x += (end - start) / 100) {
      final double y = _getPolynomialYValue(polynomialSlopes!, x);
      final ChartLocation position = calculatePoint(
          x,
          y,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          stateProperties.chartAxis.axisClipRect);
      polyPoints.add(Offset(position.x, position.y));
    }
    return polyPoints;
  }

  /// To return predicted forecast values.
  int _getForecastDate(
      ChartAxisRendererDetails axisRendererDetails, bool isForward) {
    Duration duration = Duration.zero;
    final DateTimeAxis axis = axisRendererDetails.axis as DateTimeAxis;
    switch (axis.intervalType) {
      case DateTimeIntervalType.auto:
        duration = Duration.zero;
        break;
      case DateTimeIntervalType.years:
        duration = Duration(
            days: (365.25 *
                    (isForward
                        ? trendline.forwardForecast
                        : trendline.backwardForecast))
                .round());
        break;
      case DateTimeIntervalType.months:
        duration = Duration(
            days: 31 *
                (isForward
                        ? trendline.forwardForecast
                        : trendline.backwardForecast)
                    .round());
        break;
      case DateTimeIntervalType.days:
        duration = Duration(
            days: (isForward
                    ? trendline.forwardForecast
                    : trendline.backwardForecast)
                .round());
        break;
      case DateTimeIntervalType.hours:
        duration = Duration(
            hours: (isForward
                    ? trendline.forwardForecast
                    : trendline.backwardForecast)
                .round());
        break;
      case DateTimeIntervalType.minutes:
        duration = Duration(
            minutes: (isForward
                    ? trendline.forwardForecast
                    : trendline.backwardForecast)
                .round());
        break;
      case DateTimeIntervalType.seconds:
        duration = Duration(
            seconds: (isForward
                    ? trendline.forwardForecast
                    : trendline.backwardForecast)
                .round());
        break;
      case DateTimeIntervalType.milliseconds:
        duration = Duration(
            milliseconds: (isForward
                    ? trendline.forwardForecast
                    : trendline.backwardForecast)
                .round());
    }
    return duration.inMilliseconds;
  }
}

class _SlopeIntercept {
  num? slope;
  num? intercept;
}
