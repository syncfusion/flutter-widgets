import 'package:flutter/material.dart';
import '../chart/axis/axis.dart';
import '../chart/chart_series/xy_data_series.dart';
import '../chart/common/data_label.dart';
import '../chart/common/interactive_tooltip.dart';
import '../chart/technical_indicators/technical_indicator.dart';
import '../chart/utils/enum.dart';
import 'utils/enum.dart';

/// Holds the arguments for the event onTooltipRender.
///
/// Event is triggered when the tooltip is rendered, which allows you to customize tooltip arguments.
class TooltipArgs {
  /// Creating an argument constructor of TooltipArgs class.
  TooltipArgs(
      [this.seriesIndex,
      this.dataPoints,
      this.viewportPointIndex,
      this.pointIndex]);

  /// Get and set the tooltip text.
  String? text;

  /// Get and set the header text of the tooltip.
  String? header;

  /// Get and set the x location of the tooltip.
  double? locationX;

  /// Get and set the y location of the tooltip.
  double? locationY;

  /// Get the index of the current series.
  final dynamic seriesIndex;

  /// Get the list of data points in the series.
  final List<dynamic>? dataPoints;

  /// Get the overall index value of the tooltip.
  final num? pointIndex;

  /// Get the view port index value of the tooltip.
  final num? viewportPointIndex;
}

/// Holds the `onActualRangeChanged` event arguments.
///
/// ActualRangeChangedArgs is the type argument for `onActualRangeChanged` event. Whenever the actual range is changed, the `onActualRangeChanged` event is
/// triggered and provides options to set the visible minimum and maximum values.
///
/// It has the public properties of axis name, axis type, actual minimum, and maximum, visible minimum and maximum and axis orientation.
class ActualRangeChangedArgs {
  /// Creating an argument constructor of ActualRangeChangedArgs class.
  ActualRangeChangedArgs(
      [this.axisName,
      this.axis,
      this.actualMin,
      this.actualMax,
      this.actualInterval,
      this.orientation]);

  /// Get the name of the axis.
  final String? axisName;

  /// Get the axis type.
  final ChartAxis? axis;

  /// Get the actual minimum range of an axis.
  final dynamic actualMin;

  /// Get the actual maximum range of an axis.
  final dynamic actualMax;

  /// Get the actual interval of an axis.
  final dynamic actualInterval;

  /// Get and set the minimum visible range for an axis.
  dynamic visibleMin;

  /// Get and set the maximum visible range for an axis.
  dynamic visibleMax;

  /// Get and set the interval for the visible range for an axis.
  dynamic visibleInterval;

  /// Get the orientation of an axis.
  final AxisOrientation? orientation;
}

/// Holds label text, axis name, orientation of the axis, trimmed text and text styles such as color,
/// font size, and font weight for label formatter event.
class AxisLabelRenderDetails {
  /// Creating an argument constructor of AxisLabelRenderDetails class.
  AxisLabelRenderDetails(this.value, this.text, this.textStyle, this.axis,
      this.currentDateTimeIntervalType, this.currentDateFormat);

  /// Actual text value of the axis label.
  final String text;

  /// Get the value of the axis label.
  final num value;

  /// Get the chart axis type and its properties.
  final ChartAxis axis;

  /// Get the text style of an axis label.
  final TextStyle textStyle;

  /// Specifies the date time interval type calculated internally for the date-time values that are
  /// displayed on the axis.
  ///
  /// _Note:_ This is applicable for DateTimeAxis and DateTimeCategoryAxis.
  final DateTimeIntervalType? currentDateTimeIntervalType;

  /// Specifies the date format calculated internally for the current date-time values that are
  /// displayed on the axis.
  ///
  /// _Note:_ This is applicable for DateTimeAxis and DateTimeCategoryAxis.
  final String? currentDateFormat;
}

/// Holds multi-level label text, name of the axis, index, actual level of the
/// multi-level label, text style such as color, font size, etc arguments for
/// multi-level label formatter callback.
///
/// The value in the `index` will be obtained as per the order of the labels specified in
/// the `multiLevelLabels` property irrespective of the value specified in
/// the `level` property.
///
/// The level obtained in the `actualLevel`property is the re-ordered level
/// irrespective of the value specified in the `level` property.
class MultiLevelLabelRenderDetails {
  /// Creating an argument constructor of MultiLevelLabelRenderDetails class.
  MultiLevelLabelRenderDetails(
      this.actualLevel, this.text, this.textStyle, this.index, this.axisName);

  /// Get the multi-level label text.
  final String text;

  /// Get the text style of the multi-level label.
  final TextStyle textStyle;

  /// Get the index value of the multi-level label.
  final int index;

  /// Get the actual level of the multi-level label.
  final int actualLevel;

  /// Get the axis name.
  final String? axisName;
}

/// Holds the axis label text and style details.
class ChartAxisLabel {
  /// Creating an argument constructor of ChartAxisLabel class.
  ChartAxisLabel(this.text, TextStyle? textStyle)
      : textStyle = textStyle ??
            const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 12);

  ///Text which is to be rendered as an axis label.
  final String text;

  ///Text style of the axis label.
  final TextStyle textStyle;
}

/// Holds the onDataLabelRender event arguments.
///
/// DataLabelRenderArgs is the type of argument for the onDataLabelRender event. Whenever the data label gets rendered, the onDataLabelRender event is
/// triggered and provides options to customize the data label text, data label text style, the background color.
///
/// It has the public properties of data label text, series, data points, and point index.
class DataLabelRenderArgs {
  /// Creating an argument constructor of DataLabelRenderArgs class.
  DataLabelRenderArgs(
      [this.seriesRenderer,
      this.dataPoints,
      this.viewportPointIndex,
      this.pointIndex]);

  /// Get and set the text value of a data label.
  late String text;

  /// Get and set the style property of the data label text.
  TextStyle? textStyle;

  /// Get the current series.
  ///
  /// ```dart
  /// SfCartesianChart(
  ///    onDataLabelRender: (DataLabelRenderArgs args) {
  ///      CartesianSeries<dynamic, dynamic> series = args.seriesRenderer;
  ///      //Changed the background color of the data label based on the series type
  ///      if (series.name == 'Product A') {
  ///        args.color = Colors.blue;
  ///      } else if(series.name == 'Product B'){
  ///        args.color = Colors.red;
  ///      }
  ///    },
  ///  )
  /// ```
  ///
  /// _Note:_ Series type may vary based on the chart type.
  ///
  /// * Cartesian chart: CartesianSeries<dynamic, dynamic> series;
  /// * Circular chart: CircularSeries<dynamic, dynamic> series;
  /// * Funnel Chart: FunnelSeries<dynamic, dynamic> series;
  /// * Pyramid Chart: PyramidSeries<dynamic, dynamic> series;
  ///
  final dynamic seriesRenderer;

  /// Get the data points of the series.
  final dynamic dataPoints;

  /// Get the overall index value of a data label.
  final int? pointIndex;

  /// Get and set the background color of a data label.
  Color? color;

  /// Get and set the horizontal/vertical position of the data label.
  ///
  /// The first argument sets the horizontal component to dx,  while the second
  /// argument sets the vertical component to dy.
  Offset? offset;

  /// Get the view port index value of a data label.
  final int? viewportPointIndex;
}

/// Holds the onLegendItemRender event arguments.
///
/// The onLegendItemRender event triggers when the legend item is rendering and can customize the [text], [legendIconType], and [color].
///
/// _Note:_ [pointIndex] and [color] is applicable for [SfCircularChart], [SfPyramidChart] and [SfFunnelChart].
class LegendRenderArgs {
  /// Creating an argument constructor of LegendRenderArgs class.
  LegendRenderArgs([this.seriesIndex, this.pointIndex]);

  /// Get and set the legend text.
  String? text;

  /// Get and set the shape of a legend.
  LegendIconType? legendIconType;

  /// Get the current series index.
  final int? seriesIndex;

  /// Get the current point index.
  final int? pointIndex;

  /// Get and set the color of the legend icon.
  Color? color;
}

/// Holds the onRenderDetailsUpdate callback arguments of trendline.
class TrendlineRenderParams {
  /// Creating an argument constructor of TrendlineRenderParams class.
  TrendlineRenderParams(
      [this.intercept,
      this.seriesIndex,
      this.trendlineName,
      this.seriesName,
      this.calculatedDataPoints,
      this.slope,
      this.rSquaredValue]);

  /// Get the intercept value.
  final double? intercept;

  /// Get the index of the series.
  final int? seriesIndex;

  /// Gets the name of the trendline.
  ///
  /// If the user specifies a value for the `name` property in the series,
  /// that value can be fetched here. If it is null, then the name generated
  /// internally for the trendline can be fetched here.
  final String? trendlineName;

  /// Gets the name of the series.
  ///
  /// If the user specifies a value for the `name` property in the series,
  /// that value can be fetched here. If it is null, then the name generated
  /// internally for the series can be fetched here.
  final String? seriesName;

  /// Get the data points of the trendline.
  final List<Offset>? calculatedDataPoints;

  /// Gets the r-squared value.
  final double? rSquaredValue;

  /// Gets the slope value.
  final List<double>? slope;
}

/// Holds arguments for onTrackballPositionChanging event.
///
/// The event is triggered when the trackball is rendered and provides options to customize the label text.
class TrackballArgs {
  ///  Get and set the trackball tooltip text.
  ChartPointInfo chartPointInfo = ChartPointInfo();
}

/// Holds the onCrosshairPositionChanging event arguments.
///
/// CrosshairRenderArgs is the type of Argument to the onCrosshairPositionChanging event, whenever the crosshair position is changed, the onCrosshairPositionChanging event is
/// triggered and provides options to customize the text, line color.
///
/// It has the public properties of text, line color, axis, axis name, value, and orientation.
class CrosshairRenderArgs {
  /// Creating an argument constructor of CrosshairRenderArgs class.
  CrosshairRenderArgs([this.axis, this.value, this.axisName, this.orientation]);

  /// Get the type of chart axis and its properties.
  final ChartAxis? axis;

  /// Get and set the crosshair text.
  late String text;

  /// Get and set the color of the crosshair line.
  late Color lineColor;

  /// Get the visible range value.
  final dynamic value;

  /// Get the name of the axis.
  final String? axisName;

  /// Get the axis orientation.
  final AxisOrientation? orientation;
}

/// Holds the chart TouchUp event arguments.
///
/// ChartTouchInteractionArgs is used to store the touch point coordinates when the touch event is triggered.
/// Detects the points or areas in the chart as the offset values of x and y.
class ChartTouchInteractionArgs {
  /// Get the position of the touch interaction.
  late Offset position;
}

/// Holds the zooming event arguments.
///
/// The zooming events are onZooming, onZoomStart, onZoomEnd and onZoomReset.
/// It contains [axis], [currentZoomPosition], [currentZoomFactor], [previousZoomPosition]
/// and [previousZoomFactor] arguments.
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class ZoomPanArgs {
  /// Creating an argument constructor of ZoomPanArgs class.
  ZoomPanArgs([this.axis, this.previousZoomPosition, this.previousZoomFactor]);

  /// Get the chart axis types and properties.
  final ChartAxis? axis;

  /// Get and set the current zoom position.
  late double currentZoomPosition;

  /// Get and set the current zoom factor.
  late double currentZoomFactor;

  /// Get the previous zoom position.
  final double? previousZoomPosition;

  /// Get the previous zoom factor.
  final double? previousZoomFactor;
}

/// Holds the arguments of `onPointTap`, `onPointDoubleTap` and `onPointLongPress` callbacks.
///
/// The user can fetch the series index, point index, view port point index and data of the current point.
class ChartPointDetails {
  /// Creating an argument constructor of ChartPointDetails class.
  ChartPointDetails(
      [this.seriesIndex,
      this.viewportPointIndex,
      this.dataPoints,
      this.pointIndex]);

  /// Get the series index.
  final int? seriesIndex;

  /// Get the overall index value.
  final int? pointIndex;

  /// Get the list of data points.
  final List<dynamic>? dataPoints;

  /// Get the view port index value.
  final num? viewportPointIndex;
}

/// Holds the onAxisLabelTapped event arguments.
///
/// This is the argument type of the onAxisLabelTapped event. Whenever the axis label is tapped, the onAxisLabelTapped event is triggered and provides options to get the axis type, label text, and axis name.
///
class AxisLabelTapArgs {
  /// Creating an argument constructor of AxisLabelTapArgs class.
  AxisLabelTapArgs([this.axis, this.axisName]);

  /// Get the type of chart axis and its properties.
  final ChartAxis? axis;

  /// Get the text of the axis label at the tapped position.
  late String text;

  /// Get the value holds the properties of the visible label.
  late num value;

  /// Get the axis name.
  final String? axisName;
}

/// Holds the onLegendTapped event arguments.
///
/// When the legend is tapped, the onLegendTapped event is triggered and we can get the `series`, [seriesIndex], and [pointIndex].
///
class LegendTapArgs {
  /// Creating an argument constructor of LegendTapArgs class.
  LegendTapArgs([this.series, this.seriesIndex, this.pointIndex]);

  /// Get the current series.
  ///
  /// ```dart
  /// SfCartesianChart(
  ///    onDataLabelRender: (DataLabelRenderArgs args) {
  ///      CartesianSeries<dynamic, dynamic> series = args.series;
  ///      //Changed the background color of the data label based on the series type
  ///      if (series.name == 'Product A') {
  ///        args.color = Colors.blue;
  ///      } else if(series.name == 'Product B'){
  ///        args.color = Colors.red;
  ///      }
  ///    },
  ///  )
  /// ```
  ///
  /// _Note_: Series type may vary based on the chart type.
  ///
  /// * Cartesian chart: CartesianSeries<dynamic, dynamic> series;
  /// * Circular chart: CircularSeries<dynamic, dynamic> series;
  /// * Funnel Chart: FunnelSeries<dynamic, dynamic> series;
  /// * Pyramid Chart: PyramidSeries<dynamic, dynamic> series;
  ///
  final dynamic series;

  /// Get the current series index.
  final int? seriesIndex;

  /// Get the current point index.
  final int? pointIndex;
}

/// Holds the onSelectionChanged event arguments.
///
/// Here [selectedColor], [unselectedColor], [selectedBorderColor], [selectedBorderWidth], [unselectedBorderColor] and [unselectedBorderWidth] can be customized.
///
class SelectionArgs {
  /// Creating an argument constructor of SelectionArgs class.
  SelectionArgs(
      {required this.seriesRenderer,
      required this.seriesIndex,
      required this.viewportPointIndex,
      required this.pointIndex});

  /// Get the selected series.
  final dynamic seriesRenderer;

  /// Get and set the color of the selected series or data points.
  Color? selectedColor;

  /// Get and set the color of unselected series or data points.
  Color? unselectedColor;

  /// Get and set the border color of the selected series or data points.
  Color? selectedBorderColor;

  /// Get and set the border width of the selected series or data points.
  double? selectedBorderWidth;

  /// Get and set the border color of the unselected series or data points.
  Color? unselectedBorderColor;

  /// Get and set the border width of the unselected series or data points.
  double? unselectedBorderWidth;

  /// Get the series index.
  final int seriesIndex;

  /// Get the overall index value of the selected data points.
  final int pointIndex;

  /// Get the view port index value of the selected data points.
  final int viewportPointIndex;
}

@Deprecated('Use IndicatorRenderParams instead.')

/// Holds the onRenderDetailsUpdate event arguments.
///
/// Triggers when indicator is rendering. You can customize the [signalLineColor], [signalLineWidth], and [signalLineDashArray].
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class IndicatorRenderArgs {
  /// Creating an argument constructor of IndicatorRenderArgs class.
  @Deprecated('Use IndicatorRenderParams instead.')
  IndicatorRenderArgs([
    this.indicator,
    this.index,
    this.seriesName,
    this.dataPoints,
  ]);

  /// Get the technical indicator information.
  final TechnicalIndicators<dynamic, dynamic>? indicator;

  /// Get the indicator name.
  late String indicatorName;

  /// Get the current index of the technical indicator.
  final int? index;

  /// Get and set the color of the signal line.
  late Color signalLineColor;

  /// Get and set the width of the signal line.
  late double signalLineWidth;

  /// Get and set the dash array size.
  late List<double> lineDashArray;

  /// Get the series name.
  final String? seriesName;

  /// Get the current data points.
  final List<dynamic>? dataPoints;
}

/// Holds the onMarkerRender event arguments.
///
/// MarkerRenderArgs is the argument type of onMarkerRender event. Whenever the onMarkerRender is triggered, the shape of the marker, color, marker width, height, border color, and border width can be customized.
///
/// Has the public properties of point index, series index, shape, marker width, and height.
class MarkerRenderArgs {
  /// Creating an argument constructor of MarkerRenderArgs class.
  MarkerRenderArgs(
      [this.viewportPointIndex, this.seriesIndex, this.pointIndex]);

  /// Get the overall index value of the marker.
  final int? pointIndex;

  /// Get the series index of the marker.
  final int? seriesIndex;

  /// Get and set the shape of the marker.
  late DataMarkerType shape;

  /// Get and set the width of the marker.
  late double markerWidth;

  /// Get and set the height of the marker.
  late double markerHeight;

  /// Get and set the color of the marker.
  Color? color;

  /// Get and set the border color of the marker.
  Color? borderColor;

  /// Get and set the border width of marker.
  late double borderWidth;

  /// Get the view port index value of the marker.
  final num? viewportPointIndex;
}

/// Holds the onDataLabelTapped callback arguments.
///
/// Whenever the data label is tapped, `onDataLabelTapped` callback will be called. Provides options to get the position of the data label,
/// series index, point index and its text.

class DataLabelTapDetails {
  /// Creating an argument constructor of DataLabelTapDetails class.
  DataLabelTapDetails(this.seriesIndex, this.viewportPointIndex, this.text,
      this.dataLabelSettings, this.pointIndex);

  /// Get the position of the tapped data label in logical pixels.
  late Offset position;

  /// Get the series index of the tapped data label.
  final int seriesIndex;

  /// Get the overall index value of the tapped data label.
  final int pointIndex;

  /// Get the text of the tapped data label.
  final String text;

  /// Get the data label customization options specified in that particular series.
  final DataLabelSettings dataLabelSettings;

  /// Get the view port index value of the tapped data label.
  final int viewportPointIndex;
}

/// Holds the onCreateShader callback arguments.
///
/// This is the argument type of the onCreateShader callback. The onCreateShader callback is called once while rendering
/// the data points and legend. This provides options to get the outer rect, inner rect, and render type (either series or legend).
class ChartShaderDetails {
  /// Creating an argument constructor of ChartShaderDetails class.
  ChartShaderDetails(this.outerRect, this.innerRect, this.renderType);

  /// Holds the pie, doughnut and radial bar chart's outer rect value.
  final Rect outerRect;

  /// Conveys whether the current rendering element is 'series' or 'legend'.
  final String renderType;

  /// Holds the doughnut and radial bar chart's inner rect value.
  final Rect? innerRect;
}

/// Holds the onCreateShader callback arguments.
class ShaderDetails {
  /// Creating an argument constructor of ShaderDetails class.
  ShaderDetails(this.rect, this.renderType);

  /// Holds the chart area rect.
  final Rect rect;

  ///Conveys whether the current rendering element is 'series' or 'legend'.
  final String renderType;
}

/// Holds the onRenderDetailsUpdate callback arguments.
class IndicatorRenderParams {
  /// Creating an argument constructor of IndicatorRenderParams class.
  IndicatorRenderParams(this.calculatedDataPoints, this.name,
      this.signalLineWidth, this.signalLineColor, this.signalLineDashArray);

  /// Gets the calculated indicator data points details.
  final List<CartesianChartPoint<dynamic>>? calculatedDataPoints;

  /// Gets the width of the signal line.
  late double signalLineWidth;

  /// Gets the color of the signal line.
  late Color signalLineColor;

  /// Gets the name of the indicator.
  ///
  /// If the user specifies a value for the `name` property in the `TechnicalIndicators` class,
  /// that value can be fetched here. If it is null, then the name generated internally for the
  /// indicator can be fetched here.
  final String name;

  /// Gets the dash array of the signal line.
  late List<double> signalLineDashArray;
}

/// Holds the onRenderDetailsUpdate callback arguments.
class BollingerBandIndicatorRenderParams extends IndicatorRenderParams {
  /// Creating an argument constructor of BollingerBandIndicatorRenderParams class.
  BollingerBandIndicatorRenderParams(
      this.upperLineValues,
      this.lowerLineValues,
      List<CartesianChartPoint<dynamic>>? calculatedDataPoints,
      String name,
      double signalLineWidth,
      Color signalLineColor,
      List<double> signalLineDashArray)
      : super(calculatedDataPoints, name, signalLineWidth, signalLineColor,
            signalLineDashArray);

  /// Gets the calculated upper line values of the Bollinger band indicator.
  final List<CartesianChartPoint<dynamic>>? upperLineValues;

  /// Gets the calculated lower line values of the Bollinger band indicator.
  final List<CartesianChartPoint<dynamic>>? lowerLineValues;
}

/// Holds the onRenderDetailsUpdate callback arguments.
class MomentumIndicatorRenderParams extends IndicatorRenderParams {
  /// Creating an argument constructor of MomentumIndicatorRenderParams class.
  MomentumIndicatorRenderParams(
      this.centerLineValue,
      List<CartesianChartPoint<dynamic>>? calculatedDataPoints,
      String name,
      double signalLineWidth,
      Color signalLineColor,
      List<double> signalLineDashArray)
      : super(calculatedDataPoints, name, signalLineWidth, signalLineColor,
            signalLineDashArray);

  /// Gets the calculated center line value of the Momentum indicator.
  final double? centerLineValue;
}

/// Holds the onRenderDetailsUpdate callback arguments.
class StochasticIndicatorRenderParams extends IndicatorRenderParams {
  /// Creating an argument constructor of StochasticIndicatorRenderParams class.
  StochasticIndicatorRenderParams(
      this.periodLineValues,
      List<CartesianChartPoint<dynamic>>? calculatedDataPoints,
      String name,
      double signalLineWidth,
      Color signalLineColor,
      List<double> signalLineDashArray)
      : super(calculatedDataPoints, name, signalLineWidth, signalLineColor,
            signalLineDashArray);

  /// Gets the calculated period line values of the stochastic indicator.
  final List<CartesianChartPoint<dynamic>>? periodLineValues;
}

/// Holds the onRenderDetailsUpdate callback arguments.
class MacdIndicatorRenderParams extends IndicatorRenderParams {
  /// Creating an argument constructor of MacdIndicatorRenderParams class.
  MacdIndicatorRenderParams(
      this.macdLineValues,
      this.macdHistogramValues,
      List<CartesianChartPoint<dynamic>>? calculatedDataPoints,
      String name,
      double signalLineWidth,
      Color signalLineColor,
      List<double> signalLineDashArray)
      : super(calculatedDataPoints, name, signalLineWidth, signalLineColor,
            signalLineDashArray);

  /// Gets the calculated Macd line values of the Macd indicator.
  final List<CartesianChartPoint<dynamic>>? macdLineValues;

  /// Gets the calculated histogram values of the Macd indicator.
  final List<CartesianChartPoint<dynamic>>? macdHistogramValues;
}

/// Holds the TechnicalIndicatorRenderDetails values
class TechnicalIndicatorRenderDetails {
  /// Creating an argument constructor of TechnicalIndicatorRenderDetails class.
  TechnicalIndicatorRenderDetails(
      this.signalLineColor, this.signalLineWidth, this.signalLineDashArray);

  /// Color of the signal line.
  final Color? signalLineColor;

  /// Width of the signal line.
  final double? signalLineWidth;

  /// Dash array of the signal line
  final List<double>? signalLineDashArray;
}

/// Holds the ErrorBarRenderDetails values.
class ErrorBarRenderDetails {
  /// Creating an argument constructor of ErrorBarRenderDetails class.
  ErrorBarRenderDetails(
      this.pointIndex, this.viewPortPointIndex, this.calculatedErrorBarValues);

  /// Specifies the overall point index.
  final int? pointIndex;

  /// Specifies the current point index.
  final int? viewPortPointIndex;

  ///	Specifies the current data point's error values.
  final ErrorBarValues? calculatedErrorBarValues;
}

/// Holds the error values of data point.
class ErrorBarValues {
  /// Creating an argument constructor of ErrorBarValues class.
  ErrorBarValues(
    this.horizontalPositiveErrorValue,
    this.horizontalNegativeErrorValue,
    this.verticalPositiveErrorValue,
    this.verticalNegativeErrorValue,
  );

  /// Holds the positive error value in horizontal point.
  final double? horizontalPositiveErrorValue;

  /// Holds the negative error value in horizontal point.
  final double? horizontalNegativeErrorValue;

  /// Holds the positive error value in vertical point.
  final double? verticalPositiveErrorValue;

  /// Holds the negative error value in vertical point.
  final double? verticalNegativeErrorValue;
}
