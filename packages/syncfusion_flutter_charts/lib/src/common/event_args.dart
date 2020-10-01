//Event Arguments
part of charts;

///Holds the arguments for the event onTooltipRender.
///
/// Event is triggered when the tooltip is rendered, which allows you to customize tooltip arguments.
class TooltipArgs {
  /// Creating an argument constructor of TooltipArgs class.
  TooltipArgs([this.seriesIndex, this.dataPoints, this.pointIndex]);

  ///Tooltip text
  String text;

  /// Header text of tooltip
  String header;

  /// x location
  double locationX;

  /// y location
  double locationY;

  /// Index of current series
  final dynamic seriesIndex;

  /// List of datapoints in the series
  final List<dynamic> dataPoints;

  /// Index of the current point
  final num pointIndex;
}

/// Holds the onActualRangeChanged event arguments.
///
/// ActualRangeChangedArgs is the type argument for onActualRangeChanged event. whenever the actual ranges is changed,onActualRangeChanged event is
/// triggered and provides options to set the actual minimum and maximum, visible minimum and maximum values.
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

  /// Specify the name of the axis.
  final String axisName;

  /// Specify the axis type .
  final ChartAxis axis;

  /// Specify the minimum actual range to an axis.
  final dynamic actualMin;

  /// Specify the maximum actual range to an axis.
  final dynamic actualMax;

  /// Specify the actual interval of an axis.
  final dynamic actualInterval;

  /// Minimum visible range of the axis.
  dynamic visibleMin;

  /// Maximum visible range of the axis.
  dynamic visibleMax;

  /// Interval for the visible range of the axis.
  dynamic visibleInterval;

  /// Specifies the axis orientation.
  final AxisOrientation orientation;
}

/// Holds the onAxisLabelRender event arguments.
///
/// AxisLabelRenderArgs is the type argument for onAxisLabelRender event. whenever the Axis gets rednered,onAxisLabelRender event is
/// triggered  and provides options to set the axis label text, axis name, label text style, orientation, and axis type.
///
///It has the public properties of axis label text, axis name, axis type, label text style, and orientation.

class AxisLabelRenderArgs {
  /// Creating an argument constructor of AxisLabelRenderArgs class.
  AxisLabelRenderArgs([this.value, this.axisName, this.orientation, this.axis]);

  /// Text value of the axis label.
  String text;

  /// Value of the axis label.
  final num value;

  /// Specifies the axis name.
  final String axisName;

  /// Specifies the axis orientation.
  final AxisOrientation orientation;

  /// Chart axis type and its property.
  final ChartAxis axis;

  /// Text style of the axis label.
  TextStyle textStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontSize: 12);
}

/// Holds the onDataLabelRender event arguments.
///
/// DataLabelRenderArgs is the type of Argument to the onDataLabelRender event, whenever the datalabel gets rendered, onDataLabelRender event is
/// triggered it provides options to customize the data label text, data label text style, series, data point, and current point index value.
///
/// It has the public properties of data label text, series, data points and Point index.
///
class DataLabelRenderArgs {
  /// Creating an argument constructor of DataLabelRenderArgs class.
  DataLabelRenderArgs([this.seriesRenderer, this.dataPoints, this.pointIndex]);

  /// Text value of the data label.
  String text;

  /// Style property of the data label text.
  TextStyle textStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontSize: 12);

  /// Current series.
  final dynamic seriesRenderer;

  /// Data points of the series.
  final dynamic dataPoints;

  ///Current point index .
  final num pointIndex;

  /// Color of datalabels
  Color color;
}

/// Holds the onLegendItemRender event arguments.
///
/// Triggers when the legend item is rendering.It can be customize the [text], [legendIconType],
/// [seriesIndex], [pointIndex] and [color].
///
/// _Note:_ [pointIndex] and [color] only applicable for [SfCircularChart].
class LegendRenderArgs {
  /// Creating an argument constructor of LegendRenderArgs class.
  LegendRenderArgs([this.seriesIndex, this.pointIndex]);

  ///Legend text.
  String text;

  ///Specifies the shape of  legend.
  LegendIconType legendIconType;

  ///Current series index.
  final int seriesIndex;

  ///Current point index.
  final int pointIndex;

  ///Color of legend
  Color color;
}

///Holds the arguments for the event onTrendlineRender.
///
/// Event is triggered when the trend line is rendered, trendline arguments such as [opacity], [color] and
/// [dashArray] can be customized.
class TrendlineRenderArgs {
  /// Creating an argument constructor of TrendlineRenderArgs class.
  TrendlineRenderArgs(
      [this.intercept,
      this.trendlineIndex,
      this.seriesIndex,
      this.trendlineName,
      this.seriesName,
      this.data]);

  /// Intercept value
  final double intercept;

  ///Index of trendline
  final int trendlineIndex;

  ///Index of series
  final int seriesIndex;

  /// Name of the trendline
  final String trendlineName;

  /// Name of the series
  final String seriesName;

  ///Event color
  Color color;

  ///Opacity value
  double opacity;

  /// TrendlineRenderArgs dashArray
  List<double> dashArray;

  /// Data points of the Trendline.
  final List<CartesianChartPoint<dynamic>> data;
}

///Holds arguments for TrackballPositionChanging event.
///
///The event is triggered when the trackball is rendered and the trackball arguments can be customized.
///Provides options to customise the label text.
class TrackballArgs {
  /// Chart point info
  _ChartPointInfo chartPointInfo = _ChartPointInfo();
}

/// Holds the onCrosshairPositionChanging event arguments.
///
/// CrosshairRenderArgs is the type of Argument to the onCrosshairPositionChanging event, whenever the crosshair position is changed,
/// onCrosshairPositionChanging event is triggered, provids options to customize the text, Line color, axis name, and orientation and value.
///
/// It has the public properties of text, Line color, axis name, and orientation and value.
///
class CrosshairRenderArgs {
  /// Creating an argument constructor of CrosshairRenderArgs class.
  CrosshairRenderArgs([this.axis, this.value, this.axisName, this.orientation]);

  /// Specifies the type of chart axis and its property.
  final ChartAxis axis;

  /// Specifies the crosshair text.
  String text;

  /// Specifies the color of the cross-hair.
  Color lineColor;

  /// Visible range value.
  final dynamic value;

  /// Name of the axis.
  final String axisName;

  /// Specifies the axis orientation.
  final AxisOrientation orientation;
}

/// Holds the chart TouchUp event arguments.
///
/// ChartTouchInteractionArgs is used to store the touch point coordinates when the Touch event is triggered.
/// Detects the points or areas in the chart as the offset values of x and y.
///
class ChartTouchInteractionArgs {
  /// Position of the Touch interaction.
  Offset position;
}

/// Holds the zooming event arguments.
///
/// In this ZoomPanArg events will trigger onZooming, onZoomStart, onZoomEnd and onZoomReset.
/// It contains [axis], [currentZoomPosition], [currentZoomFactor], [previousZoomPosition]
/// and [previousZoomFactor] arguments.
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class ZoomPanArgs {
  /// Creating an argument constructor of ZoomPanArgs class.
  ZoomPanArgs([this.axis, this.previousZoomPosition, this.previousZoomFactor]);

  ///Chart Axis types and property
  final ChartAxis axis;

  /// Position of current zooom.
  double currentZoomPosition;

  /// Zoom factor for currrent position.
  double currentZoomFactor;

  /// Previous zooom position.
  final double previousZoomPosition;

  /// Previous zoom factor.
  final double previousZoomFactor;
}

/// Holds the onPointTapped event arguments.
///
/// The PointTapArgs is the argument type of onPointTapped event, whenever the [onPointTapped] is triggered it sets the series index,
/// current point index, and respective data point.
///
/// It has the public properties of the series index, point index, and data points.
///
class PointTapArgs {
  /// Creating an argument constructor of PointTapArgs class.
  PointTapArgs([this.seriesIndex, this.pointIndex, this.dataPoints]);

  /// Series index value.
  final int seriesIndex;

  /// Current point index.
  final int pointIndex;

  /// Stores the list of data points.
  final List<dynamic> dataPoints;
}

/// Holds the onAxisLabelTapped event arguments.
///
/// This is the argument type of onAxisLabelTapped event. Whenever the Axis lebal is tapped, onAxisLabelTapped event is
/// triggered and provides options to set the axis type, label text, and axis name.
///
/// It provides options for axis type, axis label text, and axis name.
class AxisLabelTapArgs {
  /// Creating an argument constructor of AxisLabelTapArgs class.
  AxisLabelTapArgs([this.axis, this.axisName]);

  /// Specifies the type of chart axis and its property.
  final ChartAxis axis;

  /// Text of the axis label at the tap position.
  String text;

  /// The value holds the properties of the visible label.
  num value;

  /// Specifies the axis name.
  final String axisName;
}

/// Holds the onLegendTapped event arguments.
///
/// When the legend is tapped, the legendtapArgs event is triggered.
/// It contains [series], [seriesIndex], [pointIndex] that can be customized.
class LegendTapArgs {
  /// Creating an argument constructor of LegendTapArgs class.
  LegendTapArgs([this.series, this.seriesIndex, this.pointIndex]);

  ///Specifies the current series.
  final dynamic series;

  ///Specifies the current series index.
  final int seriesIndex;

  ///Specifies the current point index.
  final int pointIndex;
}

/// Holds the onSelectionChanged event arguments.
///
/// The selection arguments can be changed when the selection event is performed.
///
/// The selection arguments such as color, width can be customized.
class SelectionArgs {
  /// Creating an argument constructor of SelectionArgs class.
  SelectionArgs(
      [this.seriesRenderer,
      this.seriesIndex,
      this.pointIndex,
      this.overallDataPointIndex]);

  ///Selected series
  final dynamic seriesRenderer;

  ///color of the selected series or data points
  Color selectedColor;

  ///color of unselected series or data points
  Color unselectedColor;

  ///border color of the selected series or data points
  Color selectedBorderColor;

  ///width of the selected series or data points
  double selectedBorderWidth;

  ///border color of the unselected series or data points
  Color unselectedBorderColor;

  /// width of the unselected series or data points
  double unselectedBorderWidth;

  /// series index of the series in the chart
  final int seriesIndex;

  /// point index of the points in the series
  final int pointIndex;

  /// data point index of points in the series
  final int overallDataPointIndex;
}

/// Holds the onIndicatorRender event arguments.
///
///Triggers when indicator is rendering. You can customize the
///[indicatorname], [signalLineColor], [signalLineWidth], linedashArray and so on.
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class IndicatorRenderArgs {
  /// Creating an argument constructor of IndicatorRenderArgs class.
  IndicatorRenderArgs(
      [this.indicator, this.index, this.seriesName, this.dataPoints]);

  ///Specifies which incicator type to use.
  final TechnicalIndicators<dynamic, dynamic> indicator;

  ///Used to change the indicator name.
  String indicatorname;

  /// Current index
  final int index;

  ///Used to change the color of the signal line.
  Color signalLineColor;

  ///Used to change the width of the signal line.
  double signalLineWidth;

  ///Used to change the dash array size.
  List<double> lineDashArray;

  ///Specifies the series name.
  final String seriesName;

  ///Specifies the current datapoints.
  final List<dynamic> dataPoints;
}

/// Holds the onMarkerRender event arguments.
///
/// MarkerRenderArgs is the argument type of onMarkerRender event. Whenever the onMarkerRender is triggered the point index,
/// series index shape of the marker, marker width, and height can be customized.
///
/// Has the public properties of point index, series index, shape, marker width, and height.
///
class MarkerRenderArgs {
  /// Creating an argument constructor of MarkerRenderArgs class.
  MarkerRenderArgs([this.pointIndex, this.seriesIndex]);

  /// Point index of the marker.
  final int pointIndex;

  /// Series index of the marker.
  final int seriesIndex;

  /// Stores the Shape  of the marker.
  DataMarkerType shape;

  /// Stores the width of the marker.
  double markerWidth;

  /// Stores the height of the marker.
  double markerHeight;

  /// Stores the color of the marker.
  Color color;

  /// Stores the border color of the marker.
  Color borderColor;

  /// border width of marker
  double borderWidth;
}

///Holds the onDataLabelTapped callback arguments.
///
///Whenever the data label is tapped, [onDataLabelTapped] callback will be called. Provides options to get the position of the data label,
/// series index, point index and its text.

class DataLabelTapDetails {
  /// Creating an argument constructor of DataLabelTapDetails class.
  DataLabelTapDetails(
      this.seriesIndex, this.pointIndex, this.text, this.dataLabelSettings);

  ///Position of the tapped data label in logical pixels.
  Offset position;

  ///Series index of the tapped data label.
  final int seriesIndex;

  ///Point index of the tapped data label.
  final int pointIndex;

  ///Text of the tapped data label.
  final String text;

  ///Data label customization options specified in that particular series.
  final DataLabelSettings dataLabelSettings;
}
