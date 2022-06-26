## unreleased
**Bugs**
* No memory leaks will occur while calling the setState() method repeatedly for refreshing the chart widget.
* No exception will be thrown while using the trackball with multiple series.

## [20.1.52] - 05/03/2022
**Bugs**
* Now the [updateDataSource](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/ChartSeriesController/updateDataSource.html) method will work properly with the fast line series.

## [20.1.47] - 04/04/2022

**Bugs**
* The [onAxisLabelTapped](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfCartesianChart/onAxisLabelTapped.html) callback works properly with the rotated axis labels.

**Features**
* Provided support to display the trackball tooltip smartly when there is no space horizontally.
* Now, the tooltips and the trackball tooltips can be rendered in right-to-left direction.
* Based on the current locale, the built-in texts in legends and tooltips are automatically translated now.

## [19.4.55] - 03/08/2022

**Bugs**
* Now, the border in the edges of the radial bar chart renders properly and will not get cut off.

## [19.4.50] - 02/08/2022

**Bugs**
* Now, the chart will not throw exceptions while showing the chart widget based on the connection state of the FutureBuilder widget and scrolling with the SingleChildScrollView widget.

## [19.4.43] - 01/18/2022

**Bugs**
* The series will not be visible after calling the setstate when its visibility is set to false.

## [19.4.38] - 12/17/2021

**Features**
* Implemented multilevel axis labels support in Cartesian charts to categorize the axis labels.
* Improved the date-time axis label’s default format to display additional detail about the date.
* Provided support to trim, shift, or hide data labels that overflow from their segments in pie, doughnut, pyramid, and funnel charts. 

**Breaking changes**
* The `axisLabelFormatter` callback has been moved from the [SfCartesianChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfCartesianChart-class.html) class to the [ChartAxis](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/ChartAxis-class.html) class.
* The deprecated `onAxisLabelRender` callback has been removed. Instead, use the `axisLabelFormatter` callback from the [ChartAxis](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/ChartAxis-class.html) class.
* The `smartLabelMode` property in the [SfPyramidChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfPyramidChart-class.html) and [SfFunnelChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfFunnelChart-class.html) classes has been removed. Instead, use the `overflowMode` property.
* The deprecated `enableSmartLabels` property in [CircularSeries](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/CircularSeries/CircularSeries.html) has been removed. Instead, use `LabelIntersectAction.shift` of the [labelIntersectAction](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/DataLabelSettings/labelIntersectAction.html) property.
* The deprecated `onPointTapped` callback has been removed in [SfCartesianChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfCartesianChart/SfCartesianChart.html), [SfCircularChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfCircularChart/SfCircularChart.html), [SfPyramidChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfPyramidChart/SfPyramidChart.html) and [SfFunnelChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfFunnelChart/SfFunnelChart.html). Instead, use the `onPointTap` callback from [CartesianSeries](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/CartesianSeries/CartesianSeries.html), [CircularSeries](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/CircularSeries/CircularSeries.html), [PyramidSeries](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/PyramidSeries/PyramidSeries.html), and [FunnelSeries](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/FunnelSeries/FunnelSeries.html) respectively. 

## [19.3.57] - 12/07/2021
**Bugs**
* The trackball will not get disappeared on tapping the chart repeatedly.
* Now the bear and bull colors for candle series with [enableSolidCandles](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/CandleSeries/enableSolidCandles.html) will get applied based on the current data.

## [19.3.56] - 11/30/2021
**Bugs**
* The zoom mode is working properly with [`zoomIn`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/ZoomPanBehavior/zoomIn.html) public method.

## [19.3.55] - 11/23/2021
**Bugs**
* Now, the proper index value is obtained in the data label callback with the auto-scrolling feature.
* With marker rendering callback, the proper index value is obtained in the live update of the chart using the updateDataSource method.

## [19.3.54] - 11/17/2021
**Bugs**
* The series controller instance gets created properly with setstate.

## [19.3.47] - 10/26/2021
**Bugs**
* The legend border renders properly and the exception will not be thrown with the tooltip template. 

## [19.3.46] - 10/19/2021
**Bugs**
* The trendline will consider dynamically added points and renders properly.

## [19.3.45] - 10/12/2021
**Bugs**
* Now the axis padding is ignored when axis elements are moved inside the axis.
* The tooltip builder's gesture detector will work properly.
* Now, the [`binInterval`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/HistogramSeries/binInterval.html) property supports for double value.

## [19.3.43] - 09/30/2021

**Features**
* Implemented the error bar series type with all its functionalities to indicate errors or uncertain values in the data.
* Provided support to place the pie and doughnut chart data labels smartly without intersecting one another.
* Provided support to retrieve the internally calculated slope and intercept values of a trendline for later use in the application.
* Provided support to fill the Cartesian chart types data points using the shader.
* Now, the trackball, crosshair, and tooltip states are maintained when the device orientation changes.
* Now the annotations can also be placed on the chart based on the percentage value.
* Provided support to get data point details by passing the logical pixel value as input to the circular, pyramid and funnel charts.
* Provided delay support for animating the series, trendline and indicators after the specified time.

**Breaking changes**
* [`onTrendlineRender`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfCartesianChart/onTrendlineRender.html) callback has been deprecated; instead, use the `onRenderDetailsUpdate` callback in the [`Trendline`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/Trendline-class.html) class to get the trendline details.
* [`enableSmartLabels`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/CircularSeries/enableSmartLabels.html) callback has been deprecated; instead, use `LabelIntersectAction.shift` callback in `DataLabelSettings` class for [`pie`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/PieSeries-class.html) and [`doughnut`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/DoughnutSeries-class.html) series to position the data labels smartly when they intersect.
* [`ChartTextStyle`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/ChartTextStyle-class.html) class has been removed; instead, use the [`TextStyle`](https://api.flutter.dev/flutter/painting/TextStyle-class.html) class.
* In mobile devices, when the height is greater than the width, and the [`legend position`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/LegendPosition-class.html) is `auto`, then the legend gets positioned at the bottom. Hereafter, the legend will get positioned at the top.

## [19.2.59] - 08/31/2021
**Bugs**
* With the auto-scrolling feature, a single point will now render at the proper position in the line series.

## [19.2.57] - 08/24/2021 
**Bugs**
* Multiple scatter series of image type will render properly on invoking the setstate.

## [19.2.49] - 07/27/2021
**Bugs**
* Trendline will not throw an exception for the single point.
* Trackball template will not throw any exception.

## [19.2.46] - 07/06/2021
**Bugs**
* The `visibleMaximum` will be applied properly after the legend toggle and panning. Also, the exception will not be thrown on panning.
 
## [19.2.44+1] - 06/30/2021 
**Bugs**
* Now, the performance of the scatter series with image has been improved.
 
## [19.2.44] - 06/30/2021

**Bugs**
* The axis interval, zoom factor and zoom position will be maintained properly when enabled auto-scrolling.
* Now, no exception will be thrown while adding multiple indicators and enabling the legend.

**Features**
* Provided milliseconds interval support for date time and date time category axis.
* Provided support to place the legend anywhere at the top of the chart. 
* Provided support to decide whether to deselect or let the data point remain selected on tapping the selected data point in the chart. 
* Provided overfilled radial bar support which indicates the value that is above the maximum value. 
* Provided support to trigger an event when long-pressing or double-tapping the data points. 
* Now all the internally calculated indicator values can be retrieved for further use in the application. 

**Breaking changes**

* `onPointTapped` callback has been deprecated, instead use `onPointTap` callback in Series class to get the tapped data point details. 
* `onIndicatorRender` callback has been deprecated, instead use ` onRenderDetailsUpdate` callback in TechnicalIndicators class to get the indicator details.


## [19.1.54] - 03/30/2021 

**Bugs**
* The annotation will not flicker on zooming or panning and will get positioned properly in the plot area of the chart.

**Features**
* Provided on-demand data loading support to load more data lazily.
* Provided auto-scrolling support to display a fixed number of data points in the visible range and can view the remaining data by panning.
* Implemented a new x-axis type named DateTimeCategory axis, which is a mixture of date-time and category axis.
* Provided support to fill the circular charts with gradient and image shader.
* Provided support to switch the circular charts rendering mode as gradient instead of solid colors.
* Now, the trackball tooltip can be rendered along with markers alike the series tooltip.
* The swiping gesture has been added to the chart to achieve pagination functionality.
* Provided support to change the trackball/crosshair position even after the touch interaction leaves the chart area.

**Breaking changes**

* `onAxisLabelRender` callback has been deprecated, instead use `axisLabelFormatter` callback to customize the axis labels.
* Hereafter initialize the chart behaviors in the `initState` method instead of `build method.
* Now, the marker will be displayed in the trackball tooltip by default.


## [18.4.44] - 02/23/2021 

**Bugs**
* An exception will not be thrown while selecting the data points, after updating the data source

## [18.4.43] - 02/16/2021

**Bugs**
* The zoomed charts can be panned properly after changing the visible minimum and maximum values.
* Now, on selecting a data point, no exception is thrown when selection is enabled.

## [18.4.42] - 02/09/2021

**Bugs** 
* Now, the trackball tooltip is rendering properly when its height is greater than the chart widget.
* The spline series is rendering properly with cardinal type and date time axis.

## [18.4.41] - 02/02/2021

**Bugs**
* Line series will not throw any exceptions on showing the tooltip with a single point.
* Now, the axis ranges will be calculated properly even the axis visibility is set to false.
* The text changed using onTooltipRender event is working properly.

## [18.4.35] - 01/19/2021

**Bugs**
* Now, the spline rage area series will fill properly with negative values.

## [18.4.34] - 01/12/2021

**Bugs**
* Now, the stacked charts are rendering properly with multiple axes and animation.
* The circular chart will not throw any exception while using selectDataPoints method.
* Tooltip format with `point.cumulativeValue` will not throw any exception now.

## [18.4.33] - 01/05/2021

**Bugs**
 
* The `onSelectionChanged` event triggers properly on selecting point using `selectDataPoints` method.

## [18.4.31] - 12/22/2020

**Bugs**

* Now, you can disable the `enableAutoIntervalOnZooming` property for the numeric axis of the cartesian chart.

## [18.4.30] - 12/17/2020

### Chart

**Features**

* Support for defining the maximum width of the axis labels is provided.
* Provided template support for the trackball.
* Support for converting a logical pixel value to a chart data point and vice versa has been provided. 
* Now, you can get the `viewportPointIndex` from `onDataLabelTapped`, `onSelectionChanged` and other applicable events.
* Provided `maximumZoomLevel` support for pinch-zooming in the Cartesian chart.

### Spark Charts `Preview`

**Features**

* Provided support for Line, Area, Column, and Win-loss chart types.
* Provided support for Numeric, Category, and Date-time axis types.
* Provided marker and data label supports.
* Provided trackball support to display additional information about the data points.
* Provided plot band support to highlight a particular vertical range.

## [18.3.52] - 12/01/2020

**Bugs**
* Now the zooming will reset properly on the zoom out.
* The legend's width and height properties will work as intended.
* The trackball tooltip will not throw an exception when the tooltip is hidden using `onTrackballPositionChanging` event.

## [18.3.50] - 11/17/2020

**Features**
* Now, we can get the `overallPointIndex` from `onDataLabelTapped` and `onSelectionChanged` events.
* Provided `maximumZoomLevel` support for pinch-zooming in the cartesian chart.

## [18.3.48+1] - 11/12/2020 

**Bugs**
* The selection is working properly with `initialSelectedDataIndexes` property.

## [18.3.48] - 11/11/2020

**Bugs**
* The trackball is showing properly with public methods.

## [18.3.47] - 11/05/2020

**Bugs**
* The tooltip builder will not throw any exceptions in Circular charts.

## [18.3.44] - 10/27/2020

**Bugs**
* The zoomed column chart with custom tooltip will not throw any exceptions.
* Now, the rounded corners will be applied properly to the column type charts.

## [18.3.42] - 10/19/2020

**Bugs**
* Now, after resetting the zoomed chart using the public method, the visible range can be set.
* The circular chart will not throw any exception when wrapped with the Column widget.

## [18.3.40] - 10/13/2020

**Bugs**
* Now the chart series will not animate on resetting the zoom. 

## [18.3.38] - 10/07/2020

**Bugs**
* Now the spline area series will animate properly on adding new data points dynamically. 

## [18.3.35] - 10/01/2020

**Features**

* Provided support to render waterfall chart type.
* Provided support to render box and whisker chart type.
* Now, the rendered chart can be exported and saved as a png image or pdf document for future use.
* Provided support to display the markers at data point positions when moving the trackball.
* Provided support to position the trackball tooltips without intersecting each other.
* Now, the data labels can be rearranged by moving it vertically or horizontally.
* Provided support for `onDataLabelTapped` event to get the information of tapped data label.
* Now, the data points of the chart can be selected programmatically using the `selectDataPoints` public method.
* The rendered series can be animated using the `animate` method of the series.
* Provided support to calculate the value axis auto-range based on the visible data point or overall data points.

**Breaking changes**

* The `selectionSettings` property and the `SelectionSettings` class have been deprecated. Now, you can use the `selectionBehavior` property and `SelectionBehavior` class, respectively.

## [18.2.59] - 09/23/2020

**Bugs**

* The `onZooming` event returns proper `previousZoomFactor` and `previousZoomPosition` values.
* Now, the tooltip on the web will close properly when the mouse is moved out of the chart area.

## [18.2.57] - 09/08/2020

**Bugs**
* Now, the rotated data labels are aligned properly in column series.

## [18.2.56] - 09/01/2020

No changes.

## [18.2.55] - 08/26/2020

**Bugs**

* The spline chart will not throw any exception with null values.
* The data label builder can now return proper index value with visibleMinimum and visibleMaximum properties.

## [18.2.54] - 08/18/2020

**Features**

* Provided support to calculate the axis range based on the visible data points or based on the overall data points in the chart.

**Bugs**

* Animation for dynamic updates now works even in a zoomed state.

## [18.2.48] - 08/04/2020

**Bugs**

* Now, the onZooming event will not be triggered while handling the onTrackballPositionChanging event.

## [18.2.47] - 07/28/2020

**Bugs**

* Now, panning is working properly with LayoutBuilder and FutureBuilder.
* Annotations are rendering properly with plot offset.
* The `onTrackballPositionChanging` event is firing properly.
* Now, crosshair label is showing at the correct position with the public method.

## [18.2.46] - 07/21/2020

No changes.

## [18.2.45] - 07/14/2020

**Bugs**

* Now, `onSelectionChanged` event will return the proper index value.
* The custom data label will be visible for small y values.
* Series visibility is working properly with FutureBuilder.

## [18.2.44] - 07/07/2020

**Breaking changes**

* Considering the readability, the axis labels rotation of rotate45 and rotate90 values in [`labelIntersectAction`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/ChartAxis/labelIntersectAction.html) property is changed from 45, 90 degree to -45, -90 degree respectively.
* [`ChartTextStyle`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/ChartTextStyle-class.html) class is deprecated now and use `TextStyle` class as alternate to customize the text.
* Now, to modify the series types rendering with your own custom implementation, you must override that specific series renderer class, instead of overriding that series class. 
* Now, we have considered the values of transform, start and end properties in `LinearGradient` while rendering gradient. So specify the `begin` value as `bottomCenter` and `end` as `topCenter` to maintain the same appearance.

**Features** 

* Provided support for Spline range area and Histogram chart types.
* Provided `updateDataSource` public method to update the chart dynamically on data source change.
* Now, the gradient can be applied to the border of all the applicable series.
* Provided support for animating the axis elements like labels, gridlines, and ticks, when the axis range is changed.
* Now, the visibility of the data label and its connector line can be collapsed when its value is zero.
* The date-time interval can be specified in double value.
* Provided touch down, touch move, and marker render callback functions for the chart widget.
* Now with the same [`start`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/PlotBand/start.html) and [`end`](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/PlotBand/end.html) values, a single line will be drawn with plot band feature.
* Provided support for aligning the axis labels above, below, or center to the gridlines.
* The size and shape of the markers can be customized with `onMarkerRender` callback function.
* Now, the y-axis range will be calculated based on the visible points when panning with zoom mode x.

**Bugs**

* Legends are toggled properly on user interactions.
* Now, the tick lines will not appear outside of the plot area.

## [18.1.59] - 06/23/2020

**Bugs**

* Now, the bubble segment will not render if its size and minRadius values are the same.
* Legend state is properly maintained and the series will not be hidden in the dynamic updates.

## [18.1.56] - 06/10/2020

**Bugs**

* Now, the y-axis visible range will be calculated based on the visible points in live update.
* Selection of a single point will not throw any exception.

## [18.1.55] - 06/03/2020

**Bugs**

* Data labels for stacked series will be properly visible.
* Now, the chart will not throw any exceptions for more fraction points.
* User interaction related to zooming is working properly.

## [18.1.54] - 05/26/2020

**Bugs**

* Data labels of the Circular chart is rendering properly with StreamBuilder.

## [18.1.53] - 05/19/2020

**Bugs**

* Now, the chart widget will render with multiple axes without any exception.

## [18.1.52] - 05/14/2020

**Bugs**

* Synchronized panning in multiple charts will be working properly.
* Now, the ranges for the axis will be calculated based on the visible points and ranges.
* Individual data label background color can be customized with the event.

## [18.1.48] - 05/05/2020

**Bugs**

* Now the rotated data labels are aligned properly in Bar series.

## [18.1.46] - 04/28/2020

**Breaking changes**

* Considering the readability, the axis labels rotation of `rotate45` and `rotate90` values in `labelIntersectAction` property is changed from 45, 90 degree to -45, -90 degree respectively. 

**Features**

* Provided option to show an indication when both high and low values are same in financial chart types.

**Bugs**

* Now, the tooltip template will not flicker when the data points overlap each other.
* Technical indicators are updating properly now on dynamic changes.

## [18.1.45] - 04/21/2020

**Bug fixes**

* Now, markers for HiLo series is rendering properly.
* Tooltip is displaying properly without any exception and flickering on the web.

## [18.1.44] - 04/14/2020

**Bug fixes**

* Public methods of trackball and crosshair for financial series and cartesian series with more number of points will be working properly.

## [18.1.43] - 04/07/2020 

**Bug fixes**

* User interactions on the tooltip template will be working properly.
* Now, public methods of trackball and crosshair will be working properly in the live updates.

## [18.1.42] - 04/01/2020 

No changes.

## [18.1.36] - 03/19/2020

**Features** 

* Provided support for financial charts types like High low (HiLo), Open high low close (OHLC) and Candle.
* Provided support for 10 types of technical indicators namely Accumulation distribution, ATR, Bollinger band, EMA, Momentum, RSI, SMA, Stochastic, TMA, and MACD.
* Provided support for 6 types of trendlines namely Linear, Exponential, Power, Logarithmic, Polynomial, and Moving average.
* Provided public methods to show the tooltip/trackball/crosshair by passing data point/index/pixel values.

## [17.4.51] - 02/25/2020

No major changes.

## [17.4.50] - 02/19/2020

**Bug fixes**
* Tooltip will not be shown for the hidden series.
* Plot band text will be properly positioned on panning.
* Spline area with empty point is rendering properly.

**Features** 
* Provided support for showing trackball, tooltip, crosshair based on the pixel, index and points.

## [17.4.46] - 01/30/2020

**Features** 
* Provided support for displaying the trackball dynamically based on the data point index.

**Bug fixes**
* Now, the series will not be visible when `isVisible` property is set to false in initial rendering.
* Data labels are positioned properly on panning.

## [17.4.43] - 01/14/2020

**Bug fixes**
* Now the plot bands are rendering properly when end value is not specified and on panning.
* `onTrackballPositionChanging` event is triggered properly now.
* Panning with visible minimum and maximum values are working fine for DateTime axis now.

## [17.4.40] - 12/17/2019

**Features** 
* Provided support for 100% stacked line, 100% stacked area, 100% stacked column, 100% stacked bar, range area, spline area, and step area chart types.
* Provided support to delay the hiding of trackball and crosshair.
* Provided support to display the tooltip at the pointer location.
* Provided support to calculate the empty points average with a custom implementation.
 
**Breaking changes**
* `borderMode` property in area series has been renamed as `borderDrawMode`.

## [17.3.26] - 11/05/2019

**Bug fixes**
* Data labels are positioned properly and will not collide with the y-axis.
* Now exception will not be thrown while using the chart with tooltip template in the tab widget.

## [17.3.14] - 10/03/2019

**Breaking changes**
* `roundingPlace` property has been changed to `decimalPlaces` in the axis and tooltip.
* `child` property has been changed to `widget` in chart annotation.
* `position` property has been changed to `labelAlignment` in dataLabelSettings.
* `imageUrl` property has been changed to `image` in markerSettings.
* `backgroundImageUrl` property has been changed to `backgroundImage` in SfCartesianChart.
* `initialSelectedDatIndexes` property has been moved to series from SfCartesianChart. 

**Bug fixes**
* Tooltip format with point.y value is working properly now.
* Bar chart with negative values is rendering properly now.

## [1.0.0-beta.5] - 09/17/2019

**Features**
* Stacked line, stacked area, stacked column, stacked bar, range column, pyramid and funnel chart types.
* Logarithmic axis.
* Axis crossing support.
* Plot bands and recursive plot bands support.
* Dynamic data source update animation.

**Bug fixes**
* Tooltip template will not be displayed for hidden series.
* Now the axis interval will be calculated properly for small decimal values.
* Normal range padding is working fine for category axis.
* Few more improvements and bug fixes.

## [1.0.0-beta.4] - 08/29/2019

**Bug fixes**
* Now, the category axis will work properly with additional range padding.
* Now, the column series of category axis with a point can be placed on the ticks.
* Trackball interactive tooltip will be shown only for the visible series.
* On panning with grid lines, the grid lines will be moved within the chart area.
* Panning will work properly on adding or removing the chart series dynamically.
* Now, the data labels will not be hidden on scrolling.
* The circular chart will render at the center position along with the legend.
* Now, the panning is working properly for the inversed axis.
* Now, the data labels appearance can be customized using onDataLabelRender event.
* The tooltip and explode in the circular charts will work together. properly.
* The scatter series is rendering properly with image markers.
* Few more improvements and bug fixes.

## [1.0.0-beta] - 07/16/2019

Initial release.

**Features** 
* Line, spline, area, column, bar, bubble, scatter, step line, fast line, pie, doughnut and radial bar chart types.
* Numeric, category and date time axis types.
* User interactive features like zooming and panning, trackball, crosshair, selection and tooltip.
* Additional features like animation, marker, data label, empty points, legend, annotation and much more.
