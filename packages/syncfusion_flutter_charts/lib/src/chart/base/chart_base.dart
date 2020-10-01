part of charts;

/// Returns the  TooltipArgs.
typedef ChartTooltipCallback = void Function(TooltipArgs tooltipArgs);

/// Returns the ActualRangeChangedArgs.
typedef ChartActualRangeChangedCallback = void Function(
    ActualRangeChangedArgs rangeChangedArgs);

/// Returns the AxisLabelRenderArgs.
typedef ChartAxisLabelRenderCallback = void Function(
    AxisLabelRenderArgs axisLabelRenderArgs);

/// Returns the DataLabelRenderArgs.
typedef ChartDataLabelRenderCallback = void Function(
    DataLabelRenderArgs dataLabelArgs);

/// Returns the LegendRenderArgs.
typedef ChartLegendRenderCallback = void Function(
    LegendRenderArgs legendRenderArgs);

/// Returns the Trendline args
typedef ChartTrendlineRenderCallback = void Function(
    TrendlineRenderArgs trendlineRenderArgs);

///Returns the TrackballArgs.
typedef ChartTrackballCallback = void Function(TrackballArgs trackballArgs);

/// Returns the CrosshairRenderArgs
typedef ChartCrosshairCallback = void Function(
    CrosshairRenderArgs crosshairArgs);

/// Returns the ZoomPanArgs.
typedef ChartZoomingCallback = void Function(ZoomPanArgs zoomingArgs);

/// Returns the  PointTapArgs.
typedef ChartPointTapCallback = void Function(PointTapArgs pointTapArgs);

/// Returns the  AxisLabelTapArgs.
typedef ChartAxisLabelTapCallback = void Function(
    AxisLabelTapArgs axisLabelTapArgs);

/// Returns the  LegendTapArgs.
typedef ChartLegendTapCallback = void Function(LegendTapArgs legendTapArgs);

/// Returns the SelectionArgs.
typedef ChartSelectionCallback = void Function(SelectionArgs selectionArgs);

/// Returns the offset.
typedef ChartTouchInteractionCallback = void Function(
    ChartTouchInteractionArgs tapArgs);

/// Returns the IndicatorRenderArgs.
typedef ChartIndicatorRenderCallback = void Function(
    IndicatorRenderArgs indicatorRenderArgs);

///Returns the MarkerRenderArgs.
typedef ChartMarkerRenderCallback = void Function(MarkerRenderArgs markerArgs);

///Renders the cartesian type charts.
///
///Cartesian charts are generally charts with horizontal and vertical axes.[SfCartesianChart] provides options to cusomize
/// chart types using the [series] property.
///
///```dart
///Widget build(BuildContext context) {
///  return Center(
///    child:SfCartesianChart(
///      title: ChartTitle(text: 'Flutter Chart'),
///     legend: Legend(isVisible: true),
///     series: getDefaultData(),
///     tooltipBehavior: TooltipBehavior(enable: true),
///    )
/// );
///}
///static List<LineSeries<SalesData, num>> getDefaultData() {
///    final List<SalesData> chartData = <SalesData>[
///      SalesData(DateTime(2005, 0, 1), 'India', 1.5, 21, 28, 680, 760),
///      SalesData(DateTime(2006, 0, 1), 'China', 2.2, 24, 44, 550, 880),
///      SalesData(DateTime(2007, 0, 1), 'USA', 3.32, 36, 48, 440, 788),
///      SalesData(DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560),
///      SalesData(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566),
///      SalesData(DateTime(2010, 0, 1), 'France', 6.8, 57, 78, 780, 650),
///     SalesData(DateTime(2011, 0, 1), 'Germany', 8.5, 70, 84, 450, 800)
///    ];
///   return <LineSeries<SalesData, num>>[
///      LineSeries<SalesData, num>(
///          enableToolTip: isTooltipVisible,
///          dataSource: chartData,
///          xValueMapper: (SalesData sales, _) => sales.numeric,
///          yValueMapper: (SalesData sales, _) => sales.sales1,
///          width: lineWidth ?? 2,
///          enableAnimation: false,
///         markerSettings: MarkerSettings(
///              isVisible: isMarkerVisible,
///              height: markerWidth ?? 4,
///              width: markerHeight ?? 4,
///              shape: DataMarkerType.Circle,
///              borderWidth: 3,
///              borderColor: Colors.red),
///          dataLabelSettings: DataLabelSettings(
///              visible: isDataLabelVisible, position: ChartDataLabelAlignment.Auto)),
///      LineSeries<SalesData, num>(
///          enableToolTip: isTooltipVisible,
///          dataSource: chartData,
///          enableAnimation: false,
///          width: lineWidth ?? 2,
///          xValueMapper: (SalesData sales, _) => sales.numeric,
///          yValueMapper: (SalesData sales, _) => sales.sales2,
///          markerSettings: MarkerSettings(
///              isVisible: isMarkerVisible,
///              height: markerWidth ?? 4,
///              width: markerHeight ?? 4,
///              shape: DataMarkerType.Circle,
///              borderWidth: 3,
///              borderColor: Colors.black),
///          dataLabelSettings: DataLabelSettings(
///              isVisible: isDataLabelVisible, position: ChartDataLabelAlignment.Auto))
///    ];
///  }
///  ```
///
// ignore: must_be_immutable
class SfCartesianChart extends StatefulWidget {
  /// Creating an argument constructor of SfCartesianChart class.
  SfCartesianChart(
      {Key key,
      this.backgroundColor,
      this.enableSideBySideSeriesPlacement = true,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      this.plotAreaBackgroundColor,
      this.plotAreaBorderColor,
      this.plotAreaBorderWidth = 0.7,
      this.plotAreaBackgroundImage,
      this.onTooltipRender,
      this.onActualRangeChanged,
      this.onAxisLabelRender,
      this.onDataLabelRender,
      this.onLegendItemRender,
      this.onTrackballPositionChanging,
      this.onCrosshairPositionChanging,
      this.onZooming,
      this.onZoomStart,
      this.onZoomEnd,
      this.onZoomReset,
      this.onPointTapped,
      this.onAxisLabelTapped,
      this.onDataLabelTapped,
      this.onTrendlineRender,
      this.onLegendTapped,
      this.onSelectionChanged,
      this.onChartTouchInteractionUp,
      this.onChartTouchInteractionDown,
      this.onChartTouchInteractionMove,
      this.onIndicatorRender,
      this.onMarkerRender,
      this.isTransposed = false,
      this.enableAxisAnimation = false,
      this.annotations,
      this.palette = const <Color>[
        Color.fromRGBO(75, 135, 185, 1),
        Color.fromRGBO(192, 108, 132, 1),
        Color.fromRGBO(246, 114, 128, 1),
        Color.fromRGBO(248, 177, 149, 1),
        Color.fromRGBO(116, 180, 155, 1),
        Color.fromRGBO(0, 168, 181, 1),
        Color.fromRGBO(73, 76, 162, 1),
        Color.fromRGBO(255, 205, 96, 1),
        Color.fromRGBO(255, 240, 219, 1),
        Color.fromRGBO(238, 238, 238, 1)
      ],
      ChartAxis primaryXAxis,
      ChartAxis primaryYAxis,
      EdgeInsets margin,
      TooltipBehavior tooltipBehavior,
      ZoomPanBehavior zoomPanBehavior,
      Legend legend,
      SelectionType selectionType,
      ActivationMode selectionGesture,
      bool enableMultiSelection,
      CrosshairBehavior crosshairBehavior,
      TrackballBehavior trackballBehavior,
      dynamic series,
      ChartTitle title,
      List<ChartAxis> axes,
      List<TechnicalIndicators<dynamic, dynamic>> indicators})
      : primaryXAxis = primaryXAxis ?? NumericAxis(),
        primaryYAxis = primaryYAxis ?? NumericAxis(),
        title = title ?? ChartTitle(),
        axes = axes ?? <ChartAxis>[],
        series = series ?? <ChartSeries<dynamic, dynamic>>[],
        margin = margin ?? const EdgeInsets.all(10),
        zoomPanBehavior = zoomPanBehavior ?? ZoomPanBehavior(),
        tooltipBehavior = tooltipBehavior ?? TooltipBehavior(),
        crosshairBehavior = crosshairBehavior ?? CrosshairBehavior(),
        trackballBehavior = trackballBehavior ?? TrackballBehavior(),
        legend = legend ?? Legend(),
        selectionType = selectionType ?? SelectionType.point,
        selectionGesture = selectionGesture ?? ActivationMode.singleTap,
        enableMultiSelection = enableMultiSelection ?? false,
        indicators = indicators ?? <TechnicalIndicators<dynamic, dynamic>>[],
        super(key: key);

  ///Customizes the chart title
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            title: ChartTitle(
  ///                    text: 'Area with animation',
  ///                    alignment: ChartAlignment.center,
  ///                    backgroundColor: Colors.white,
  ///                    borderColor: Colors.transparent,
  ///                    borderWidth: 0)
  ///        ));
  ///}
  ///```
  final ChartTitle title;

  ///Customizes the legend in the chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(isVisible: true),
  ///        ));
  ///}
  ///```
  final Legend legend;

  ///Background color of the chart.
  ///
  ///Defaults to `Colors.transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final Color backgroundColor;

  ///Color of the chart border.
  ///
  ///Defaults to `Colors.transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            borderColor: Colors.red
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Width of the chart border.
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            borderColor: Colors.red,
  ///            borderWidth: 2
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Background color of the plot area.
  ///
  ///Defaults to `Colors.transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBackgroundColor: Colors.red,
  ///        ));
  ///}
  ///```
  final Color plotAreaBackgroundColor;

  ///Border color of the plot area.
  ///
  ///Defaults to `Colors.grey`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBorderColor: Colors.red,
  ///        ));
  ///}
  ///```
  final Color plotAreaBorderColor;

  ///Border width of the plot area.
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBorderColor: Colors.red,
  ///            plotAreaBorderWidth: 2
  ///        ));
  ///}
  ///```
  final double plotAreaBorderWidth;

  ///Customizes the primary x-axis in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: DateTimeAxis(interval: 1)
  ///        ));
  ///}
  ///```
  final ChartAxis primaryXAxis;

  ///Customizes the primary y-axis in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryYAxis: NumericAxis(isinversed: false)
  ///        ));
  ///}
  ///```
  final ChartAxis primaryYAxis;

  ///Margin for chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            margin: const EdgeInsets.all(2),
  ///            borderColor: Colors.blue
  ///        ));
  ///}
  ///```
  final EdgeInsets margin;

  ///Customizes the additional axes in the chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///             axes: <ChartAxis>[
  ///                NumericAxis(
  ///                             majorGridLines: MajorGridLines(
  ///                                     color: Colors.transparent)
  ///                             )]
  ///        ));
  ///}
  ///```
  final List<ChartAxis> axes;

  ///Enables or disables the placing of series side by side.
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           enableSideBySideSeriesPlacement: false
  ///        ));
  ///}
  ///```
  final bool enableSideBySideSeriesPlacement;

  /// Occurs while tooltip is rendered. You can customize the position and header.
  /// Here, you can get the text, header, point index, series, x and y-positions.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            tooltipBehavior: TooltipBehavior(enable: true)
  ///            onTooltipRender: (TooltipArgs args) => tool(args)
  ///        ));
  ///}
  ///void tool(TooltipArgs args) {
  ///   args.locationX = 30;
  ///}
  ///```
  final ChartTooltipCallback onTooltipRender;

  /// Occurs when the visible range of an axis is changed, i.e. value changes for minimum,
  ///  maximum, and interval. Here, you can get the actual and visible range of an axis.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onActualRangeChanged: (ActualRangeChangedArgs args) => range(args)
  ///        ));
  ///}
  ///void range(ActualRangeChangedArgs args) {
  ///   print(args.visibleMin);
  ///}
  ///```
  final ChartActualRangeChangedCallback onActualRangeChanged;

  /// Occurs while rendering the axis labels. Text and text styles such as color, font size,
  /// and font weight can be customized.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onAxisLabelRender: (AxisLabelRenderArgs args) => axis(args),
  ///        ));
  ///}
  ///void axis(AxisLabelRenderArgs args) {
  ///   args.text = 'axis Label';
  ///}
  ///```
  final ChartAxisLabelRenderCallback onAxisLabelRender;

  /// Occurs when tapping the axis label. Here, you can get the appropriate axis that is
  /// tapped and the axis label text.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onDataLabelRender: (DataLabelRenderArgs args) => dataLabel(args),
  ///        ));
  ///}
  ///void dataLabel(DataLabelRenderArgs args) {
  ///   args.text = 'data Label';
  ///}
  ///```
  final ChartDataLabelRenderCallback onDataLabelRender;

  /// Occurs when the legend item is rendered. Here, you can get the legend’s text,
  /// shape, series index, and point index of circular series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRenderArgs args) => legend(args)
  ///        ));
  ///}
  ///void legend(LegendRenderArgs args) {
  ///   args.seriesIndex = 2;
  ///}
  ///```
  final ChartLegendRenderCallback onLegendItemRender;

  /// Occurs when the trendline is rendered. Here, you can get the legend’s text,
  /// shape, series index, and point index of circular series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onTrendlineRender: (TrendlineRenderArgs args) => trendline(args)
  ///        ));
  ///}
  ///void trendline(TrendlineRenderArgs args) {
  ///   args.seriesIndex = 2;
  ///}
  ///```
  final ChartTrendlineRenderCallback onTrendlineRender;

  /// Occurs while the trackball position is changed. Here, you can customize the text of
  /// the trackball.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            trackballBehavior: TrackballBehavior(enable: true),
  ///            onTrackballPositionChanging: (TrackballArgs args) => trackball(args)
  ///        ));
  ///}
  ///void trackball(TrackballArgs args) {
  ///    args.chartPointInfo = ChartPointInfo();
  ///}
  ///```
  final ChartTrackballCallback onTrackballPositionChanging;

  /// Occurs when tapping the axis label. Here, you can get the appropriate axis that is
  /// tapped and the axis label text.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            crosshairBehavior: CrosshairBehavior(enable: true),
  ///            onCrosshairPositionChanging: (CrosshairRenderArgs args) => crosshair(args)
  ///        ));
  ///}
  ///void crosshair(CrosshairRenderArgs args) {
  ///    args.text = 'crosshair';
  ///}
  ///```
  final ChartCrosshairCallback onCrosshairPositionChanging;

  /// Occurs when zooming action begins. You can customize the zoom factor and zoom
  /// position of an axis. Here, you can get the axis, current zoom factor, current
  /// zoom position, previous zoom factor, and previous zoom position.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true),
  ///            onZoomStart: (ZoomPanArgs args) => zoom(args),
  ///        ));
  ///}
  ///void zoom(ZoomPanArgs args) {
  ///    args.currentZoomFactor = 0.2;
  ///}
  ///```
  final ChartZoomingCallback onZoomStart;

  /// Occurs when the zooming action is completed. Here, you can get the axis, current
  /// zoom factor, current zoom position, previous zoom factor, and previous zoom position.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true),
  ///            onZoomEnd: (ZoomPanArgs args) => zoom(args),
  ///        ));
  ///}
  ///void zoom(ZoomPanArgs args) {
  ///    print(args.currentZoomPosition);
  ///}
  ///```
  final ChartZoomingCallback onZoomEnd;

  /// Occurs when zoomed state is reset. Here, you can get the axis, current zoom factor,
  /// current zoom position, previous zoom factor, and previous zoom position.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true),
  ///            onZoomReset: (ZoomPanArgs args) => zoom(args),
  ///        ));
  ///}
  ///void zoom(ZoomPanArgs args) {
  ///    print(args.currentZoomPosition);
  ///}
  ///```
  final ChartZoomingCallback onZoomReset;

  /// Occurs when Zoooming event is performed. Here, you can get the axis, current zoom factor,
  /// current zoom position, previous zoom factor, and previous zoom position.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true),
  ///            onZooming: (ZoomPanArgs args) => zoom(args),
  ///        ));
  ///}
  ///void zoom(ZoomPanArgs args) {
  ///    print(args.currentZoomPosition);
  ///}
  ///```
  final ChartZoomingCallback onZooming;

  /// Occurs when tapping the series point. Here, you can get the series, series index
  /// and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onPointTapped: (PointTapArgs args) => point(args),
  ///        ));
  ///}
  ///void point(PointTapArgs args) {
  ///   print(args.seriesIndex);
  ///}
  ///```

  final ChartPointTapCallback onPointTapped;

  ///Called when the data label is tapped.
  ///
  ///Whenever the data label is tapped, `onDataLabelTapped` callback will be called. Provides options to
  /// get the position of the data label, series index, point index and its text.
  ///
  ///_Note:_ - This callback will not be called, when the builder is specified for data label
  /// (data label template). For this case, custom widget specified in the `DataLabelSettings.builder` property
  /// can be wrapped using the `GestureDetector` and this functionality can be achieved in the application level.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onDataLabelTapped: (DataLabelTapDetails args) {
  ///                 print(arg.seriesIndex);
  ///                  }
  ///        ));
  ///}
  ///
  ///```

  final DataLabelTapCallback onDataLabelTapped;

  ///Occurs when tapping the axis label. Here, you can get the appropriate axis that is
  /// tapped and the axis label text.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onAxisLabelTapped: (AxisLabelTapArgs args) => axis(args),
  ///        ));
  ///}
  ///void axis(AxisLabelTapArgs args) {
  ///   print(args.text);
  ///}
  ///```
  final ChartAxisLabelTapCallback onAxisLabelTapped;

  /// Occurs when the legend item is rendered. Here, you can get the legend’s text,
  /// shape, series index, and point index of circular series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onLegendTapped: (LegendTapArgs args) => legend(args),
  ///        ));
  ///}
  ///void legend(LegendTapArgs args) {
  ///   print(args.pointIndex);
  ///}
  ///```
  final ChartLegendTapCallback onLegendTapped;

  /// Occurs while selection changes. Here, you can get the series, selected color,
  /// unselected color, selected border color, unselected border color, selected border
  ///  width, unselected border width, series index, and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onSelectionChanged: (SelectionArgs args) => print(args.selectedColor),
  ///        ));
  ///}
  final ChartSelectionCallback onSelectionChanged;

  /// Occurs when tapped on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final ChartTouchInteractionCallback onChartTouchInteractionUp;

  /// Occurs when touched on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onChartTouchInteractionDown: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final ChartTouchInteractionCallback onChartTouchInteractionDown;

  /// Occurs when touched and moved on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onChartTouchInteractionMove: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final ChartTouchInteractionCallback onChartTouchInteractionMove;

  /// Occurs when the indicator is rendered. Here, you can get the indicatorname,,
  /// seriesname, indicator index, and width of indicators.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///             onIndicatorRender: (IndicatorRenderArgs args)
  ///           {
  ///            if(args.index==1)
  ///            {
  ///           args.indicatorname="changed1";
  ///           args.signalLineColor=Colors.green;
  ///           args.signalLineWidth=10.0;
  ///           }
  ///          },
  ///        ));
  ///}
  ///```
  final ChartIndicatorRenderCallback onIndicatorRender;

  /// Occurs when the marker is rendered. Here, you can get the marker pointIndex
  /// shape, height and width of data markers.
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               onMarkerRender: (MarkerRenderArgs markerargs)
  ///            {
  ///              if(markerargs.pointIndex==2)
  ///              {
  ///              markerargs.markerHeight=20.0;
  ///              markerargs.markerWidth=20.0;
  ///              markerargs.shape=DataMarkerType.triangle;
  ///              }
  ///            },
  ///        ));
  ///}
  ///```
  ///
  final ChartMarkerRenderCallback onMarkerRender;

  ///Customizes the tooltip in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            tooltipBehavior: TooltipBehavior(enable: true)
  ///        ));
  ///}
  ///```
  final TooltipBehavior tooltipBehavior;

  ///Customizes the crosshair in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            crosshairBehavior: CrosshairBehavior(enable: true),
  ///        ));
  ///}
  ///```
  final CrosshairBehavior crosshairBehavior;

  ///Customizes the trackball in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            trackballBehavior: TrackballBehavior(enable: true),
  ///        ));
  ///}
  ///```
  final TrackballBehavior trackballBehavior;

  ///Customizes the zooming and panning settings.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            zoomPanBehavior: ZoomPanBehavior( enablePanning: true),
  ///        ));
  ///}
  ///```
  final ZoomPanBehavior zoomPanBehavior;

  ///Mode of selecting the data points or series.
  ///
  ///Defaults to `SelectionType.point`.
  ///
  ///Also refer [SelectionType]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionType: SelectionType.series,
  ///        ));
  ///}
  ///```
  final SelectionType selectionType;

  ///Customizes the annotations. Annotations are used to mark the specific area of interest
  /// in the plot area with texts, shapes, or images.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60
  ///                 ),
  ///             ],
  ///        ));
  ///}
  ///```
  final List<CartesianChartAnnotation> annotations;

  ///Enables or disables the multiple data points or series selection.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            enableMultiSelection: true,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool enableMultiSelection;

  ///Gesture for activating the selection. Selection can be activated in tap,
  ///double tap, and long press.
  ///
  ///Defaults to `ActivationMode.tap`.
  ///
  ///Also refer [ActivationMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ActivationMode selectionGesture;

  ///Background image for chart.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBackgroundImage: const AssetImage('images/bike.png'),
  ///        ));
  ///}
  ///```
  final ImageProvider plotAreaBackgroundImage;

  ///Data points or series can be selected while performing interaction on the chart.
  ///It can also be selected at the initial rendering using this property.
  ///
  ///Defaults to `[]`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                 initialSelectedDataIndexes: <int>[2, 0],
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```

  ///By setting this, the orientation of x-axis is set to vertical and orientation of
  ///y-axis is set to horizontal.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            isTransposed: true,
  ///        ));
  ///}
  ///```
  final bool isTransposed;

  ///Axis elements animation on visible range change.
  ///
  ///Axis elements like grid lines, tick lines and labels will be animated when the axis range is changed dynamically.
  /// Axis visible range will be changed while zooming, panning or while updating the data points.
  ///
  ///The elements will be animated on setting `true` to this property and this is applicable for all primary and secondary axis in the chart.
  ///
  ///Defaults to `false`
  ///
  ///See also [ChartSeries.animationDuration] for changing the series animation duration.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            enableAxisAnimation: true,
  ///        ));
  ///}
  ///```
  final bool enableAxisAnimation;

  ///Customizes the series in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           series: <ChartSeries<SalesData, num>>[
  ///                AreaSeries<SalesData, num>(
  ///                    dataSource: chartData,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final List<ChartSeries<dynamic, dynamic>> series;

  ///Color palette for chart series. If the series color is not specified, then the series
  ///will be rendered with appropriate palette color. Ten colors are available by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            palette: <Color>[Colors.red, Colors.green]
  ///        ));
  ///}
  ///```
  final List<Color> palette;

  ///Technical indicators for charts.
  final List<TechnicalIndicators<dynamic, dynamic>> indicators;

  @override
  State<StatefulWidget> createState() => SfCartesianChartState();
}

/// Represents the state class of [SfCartesianChart] widget
///
class SfCartesianChartState extends State<SfCartesianChart>
    with TickerProviderStateMixin {
  /// Holds the animation controller along with their listener for all series and trenddlines
  Map<AnimationController, VoidCallback> _controllerList;

  /// Repaint notifier for zoom container
  ValueNotifier<int> _zoomRepaintNotifier;

  /// Repaint notifier for trendline container
  ValueNotifier<int> _trendlineRepaintNotifier;

  /// Repaint notifier for trackball container
  ValueNotifier<int> _trackballRepaintNotifier;

  /// Repaint notifier for crosshair container
  ValueNotifier<int> _crosshairRepaintNotifier;

  /// Repaint notifier for indicator
  //ignore: unused_field
  ValueNotifier<int> _indicatorRepaintNotifier;

  /// To measure legend size and position
  List<_MeasureWidgetContext> _legendWidgetContext;

  /// Chart Template info
  List<_ChartTemplateInfo> _templates;
  List<ChartAxisRenderer> _zoomedAxisRendererStates;

  List<ChartAxisRenderer> _oldAxisRenderers;

  /// Contains chart container size
  Rect _containerRect;

  /// Holds the information of chart theme arguments
  SfChartThemeData _chartTheme;
  bool _zoomProgress;
  List<_ZoomAxisRange> _zoomAxes;
  bool _initialRender;
  List<_LegendRenderContext> _legendToggleStates;
  List<ChartSegment> _selectedSegments;
  List<ChartSegment> _unselectedSegments;
  List<_MeasureWidgetContext> _legendToggleTemplateStates;
  List<Rect> _renderDatalabelRegions;
  Orientation _deviceOrientation;
  List<Rect> _dataLabelTemplateRegions;
  List<Rect> _annotationRegions;
  bool _animateCompleted;
  bool _widgetNeedUpdate;
  _DataLabelRenderer _renderDataLabel;
  _CartesianAxisRenderer _renderAxis;
  List<CartesianSeriesRenderer> _oldSeriesRenderers;
  List<ValueKey<String>> _oldSeriesKeys;
  bool _isLegendToggled;
  List<ChartSegment> _segments;
  List<bool> _oldSeriesVisible;
  bool _zoomedState;
  List<PointerEvent> _touchStartPositions;
  List<PointerEvent> _touchMovePositions;
  bool _enableDoubleTap;
  Orientation _oldDeviceOrientation;
  bool _legendToggling;
  dart_ui.Image _backgroundImage;
  dart_ui.Image _legendIconImage;
  bool _isTrendlineToggled = false;
  List<_PainterKey> _painterKeys;
  bool _triggerLoaded;
  //ignore: prefer_final_fields
  bool _rangeChangeBySlider = false;
  //ignore: prefer_final_fields
  bool _rangeChangedByChart = false;
  //ignore: prefer_final_fields
  bool _isRangeSelectionSlider = false;
  bool _isSeriesLoaded;
  bool _isNeedUpdate;
  //ignore: prefer_final_fields
  bool _trackballWithoutTouch = true;
  //ignore: prefer_final_fields
  bool _crosshairWithoutTouch = true;
  List<CartesianSeriesRenderer> _seriesRenderers;

  /// Holds the information of AxisBase class
  _ChartAxis _chartAxis;

  /// Holds the information of SeriesBase class
  _ChartSeries _chartSeries;

  /// Holds the information of LegendBase class
  _ChartLegend _chartLegend;

  /// Holds the information of _ContainerArea class
  /// ignore: unused_field
  _ContainerArea _containerArea;

  /// Whether to check chart axis is inverted or not
  bool _requireInvertedAxis;

  //ignore: prefer_final_fields
  List<_ChartPointInfo> _chartPointInfo = <_ChartPointInfo>[];

  ZoomPanBehaviorRenderer _zoomPanBehaviorRenderer;

  TooltipBehaviorRenderer _tooltipBehaviorRenderer;

  TrackballBehaviorRenderer _trackballBehaviorRenderer;

  CrosshairBehaviorRenderer _crosshairBehaviorRenderer;

  LegendRenderer _legendRenderer;

  List<TechnicalIndicatorsRenderer> _technicalIndicatorRenderer;

  TrackballMarkerSettingsRenderer _trackballMarkerSettingsRenderer;

  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCartesianChart get _chart => widget;

  /// Setting series animation duration factor
  final double _seriesDurationFactor = 0.85;

  /// Setting trendline animation duration factor
  final double _trendlineDurationFactor = 0.85;

  //holds the count for total no of series that should be animated
  int _totalAnimatingSeries;

  //holds the no of animation completed series
  int _animationCompleteCount;

  /// To intialize default values
  void _initializeDefaultValues() {
    _chartAxis = _ChartAxis(this);
    _chartSeries = _ChartSeries(this);
    _chartLegend = _ChartLegend(this);
    _containerArea = _ContainerArea(this);
    _seriesRenderers = <CartesianSeriesRenderer>[];
    _controllerList = <AnimationController, VoidCallback>{};
    _zoomRepaintNotifier = ValueNotifier<int>(0);
    _trendlineRepaintNotifier = ValueNotifier<int>(0);
    _trackballRepaintNotifier = ValueNotifier<int>(0);
    _crosshairRepaintNotifier = ValueNotifier<int>(0);
    _indicatorRepaintNotifier = ValueNotifier<int>(0);
    _legendWidgetContext = <_MeasureWidgetContext>[];
    _templates = <_ChartTemplateInfo>[];
    _oldAxisRenderers = <ChartAxisRenderer>[];
    _zoomedAxisRendererStates = <ChartAxisRenderer>[];
    _zoomAxes = <_ZoomAxisRange>[];
    _containerRect = const Rect.fromLTRB(0, 0, 0, 0);
    _zoomProgress = false;
    _legendToggleStates = <_LegendRenderContext>[];
    _selectedSegments = <ChartSegment>[];
    _unselectedSegments = <ChartSegment>[];
    _legendToggleTemplateStates = <_MeasureWidgetContext>[];
    _renderDatalabelRegions = <Rect>[];
    _dataLabelTemplateRegions = <Rect>[];
    _annotationRegions = <Rect>[];
    _animateCompleted = false;
    _widgetNeedUpdate = false;
    _oldSeriesRenderers = <CartesianSeriesRenderer>[];
    _oldSeriesKeys = <ValueKey<String>>[];
    _isLegendToggled = false;
    _oldSeriesVisible = <bool>[];
    _touchStartPositions = <PointerEvent>[];
    _touchMovePositions = <PointerEvent>[];
    _enableDoubleTap = false;
    _legendToggling = false;
    _painterKeys = <_PainterKey>[];
    _isNeedUpdate = true;
    _technicalIndicatorRenderer = <TechnicalIndicatorsRenderer>[];
    _zoomPanBehaviorRenderer = ZoomPanBehaviorRenderer(this);
    _trackballBehaviorRenderer = TrackballBehaviorRenderer(this);
    _crosshairBehaviorRenderer = CrosshairBehaviorRenderer(this);
    _tooltipBehaviorRenderer = TooltipBehaviorRenderer(this);
    _legendRenderer = LegendRenderer(widget.legend);
    _trackballMarkerSettingsRenderer = TrackballMarkerSettingsRenderer(
        widget.trackballBehavior.markerSettings);
  }

  @override
  void initState() {
    _initializeDefaultValues();
    // Create the series renderer while initial rendering //
    _createAndUpdateSeriesRenderer();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _chartTheme = SfChartTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfCartesianChart oldWidget) {
    final List<CartesianSeriesRenderer> oldWidgetSeriesRenderers =
        //ignore: prefer_spread_collections
        <CartesianSeriesRenderer>[]..addAll(_seriesRenderers);
    final List<CartesianSeriesRenderer> oldWidgetOldSeriesRenderers =
        //ignore: prefer_spread_collections
        <CartesianSeriesRenderer>[]..addAll(_oldSeriesRenderers);

    //Update and maintain the series state, when we update the series in the series collection //

    _createAndUpdateSeriesRenderer(
        oldWidget, oldWidgetSeriesRenderers, oldWidgetOldSeriesRenderers);
    _needsRepaintChart(
        this, _chartAxis._axisRenderersCollection, oldWidgetSeriesRenderers);
    _isLegendToggled = false;
    if (_legendWidgetContext != null && _legendWidgetContext.isNotEmpty) {
      _legendWidgetContext.clear();
    }
    if (_isNeedUpdate) {
      _widgetNeedUpdate = true;
      _oldSeriesRenderers = oldWidgetSeriesRenderers;
      _getOldSeriesKeys(_oldSeriesRenderers);
      _oldAxisRenderers = <ChartAxisRenderer>[]
        //ignore: prefer_spread_collections
        ..addAll(_chartAxis._axisRenderersCollection);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _oldDeviceOrientation = _oldDeviceOrientation == null
        ? MediaQuery.of(context).orientation
        : _deviceOrientation;
    _deviceOrientation = MediaQuery.of(context).orientation;
    _initialRender = _initialRender == null;
    _requireInvertedAxis = false;
    _triggerLoaded = false;
    _isSeriesLoaded = _isSeriesLoaded ?? true;
    _findVisibleSeries(context);
    _isSeriesLoaded = false;
    return RepaintBoundary(
        child: _ChartContainer(
            child: Container(
      decoration: BoxDecoration(
          color: widget.backgroundColor ?? _chartTheme.backgroundColor,
          border:
              Border.all(color: widget.borderColor, width: widget.borderWidth)),
      child: Container(
          margin: EdgeInsets.fromLTRB(widget.margin.left, widget.margin.top,
              widget.margin.right, widget.margin.bottom),
          child: Column(
            children: <Widget>[_renderTitle(), _renderChartElements(context)],
          )),
    )));
  }

  @override
  void dispose() {
    _controllerList.forEach(_disposeAnimationController);
    super.dispose();
  }

  /// Method to convert the [SfCartesianChart] as an image.
  ///
  /// As this method is in the widget’s state class,
  /// you have to use a global key to access the state to call this method.
  /// Returns the [dart:ui.image]
  ///
  /// ```dart
  /// final GlobalKey<SfCartesianChartState> _key = GlobalKey();
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Column(
  ///      children: [SfCartesianChart(
  ///        key: _key
  ///          series: <ChartSeries<SalesData, num>>[
  ///                AreaSeries<SalesData, num>(
  ///                    dataSource: chartData,
  ///                ),
  ///              ],
  ///        ),
  ///              RaisedButton(
  ///                child: Text(
  ///                  'To Image',
  ///                ),
  ///               onPressed: _renderImage,
  ///                shape: RoundedRectangleBorder(
  ///                    borderRadius: BorderRadius.circular(20)),
  ///              )
  ///      ],
  ///    ),
  ///  );
  /// }

  /// Future<void> _renderImage() async {
  ///  dart_ui.Image data = await _key.currentState.toImage(pixelRatio: 3.0);
  ///  final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
  ///  if (data != null) {
  ///    await Navigator.of(context).push(
  ///      MaterialPageRoute(
  ///        builder: (BuildContext context) {
  ///          return Scaffold(
  ///            appBar: AppBar(),
  ///            body: Center(
  ///              child: Container(
  ///                color: Colors.white,
  ///                child: Image.memory(bytes.buffer.asUint8List()),
  ///            ),
  ///            ),
  ///         );
  ///        },
  ///      ),
  ///    );
  ///  }
  ///}
  ///```

  Future<dart_ui.Image> toImage({double pixelRatio = 1.0}) async {
    final RenderRepaintBoundary boundary =
        context.findRenderObject(); //get the render object from context

    final dart_ui.Image image =
        await boundary.toImage(pixelRatio: pixelRatio); // Convert
    // the repaint boundary as image

    return image;
  }

  ///Storing old series key values
  void _getOldSeriesKeys(List<CartesianSeriesRenderer> oldSeriesRenderers) {
    _oldSeriesKeys = <ValueKey<String>>[];
    for (int i = 0; i < oldSeriesRenderers.length; i++) {
      _oldSeriesKeys.add(oldSeriesRenderers[i]._series.key);
    }
  }

  // In this method, create and update the series renderer for each series //
  void _createAndUpdateSeriesRenderer(
      [SfCartesianChart oldWidget,
      List<CartesianSeriesRenderer> oldWidgetSeriesRenderers,
      List<CartesianSeriesRenderer> oldWidgetOldSeriesRenderers]) {
    if (widget.series != null && widget.series.isNotEmpty) {
      if (oldWidget != null) {
        _oldSeriesRenderers = <CartesianSeriesRenderer>[];
        _oldSeriesRenderers.addAll(oldWidgetSeriesRenderers);
      }
      _seriesRenderers = <CartesianSeriesRenderer>[];
      final int seriesLength = widget.series.length;
      dynamic series;
      int index, oldSeriesIndex;
      for (int i = 0; i < seriesLength; i++) {
        series = widget.series[i];
        index = null;
        oldSeriesIndex = null;
        if (oldWidget != null) {
          if (oldWidgetOldSeriesRenderers.isNotEmpty) {
            // Check the current series is already exist in oldwidget //
            index = i < oldWidgetOldSeriesRenderers.length &&
                    _isSameSeries(
                        oldWidgetOldSeriesRenderers[i]._series, series)
                ? i
                : _getExistingSeriesIndex(series, oldWidgetOldSeriesRenderers);
          }
          if (oldWidgetSeriesRenderers.isNotEmpty) {
            oldSeriesIndex = i < oldWidgetSeriesRenderers.length &&
                    _isSameSeries(oldWidgetSeriesRenderers[i]._series, series)
                ? i
                : _getExistingSeriesIndex(series, oldWidgetSeriesRenderers);
          }
        }
        // Create and update the series list here
        CartesianSeriesRenderer seriesRenderer;

        if (index != null &&
            index < oldWidgetOldSeriesRenderers.length &&
            oldWidgetOldSeriesRenderers[index] != null) {
          seriesRenderer = oldWidgetOldSeriesRenderers[index];
        } else {
          seriesRenderer = series.createRenderer(series);
          seriesRenderer._repaintNotifier = ValueNotifier<int>(0);
          if (seriesRenderer is XyDataSeriesRenderer) {
            seriesRenderer._animationController =
                AnimationController(vsync: this)
                  ..addListener(seriesRenderer._repaintSeriesElement);
            _controllerList[seriesRenderer._animationController] =
                seriesRenderer._repaintSeriesElement;
            seriesRenderer._animationController
                .addStatusListener(seriesRenderer._animationStatusListener);
          }
          seriesRenderer._controller ??= ChartSeriesController(seriesRenderer);
        }
        if (series.onRendererCreated != null) {
          series.onRendererCreated(seriesRenderer._controller);
        }
        seriesRenderer._series = series;
        seriesRenderer._isSelectionEnable =
            series.selectionBehavior.enable || series.selectionSettings.enable;
        seriesRenderer._visible = null;
        seriesRenderer._chart = widget;

        if (oldWidgetSeriesRenderers != null &&
            oldSeriesIndex != null &&
            oldWidgetSeriesRenderers.length > oldSeriesIndex) {
          seriesRenderer._oldSeries =
              oldWidgetSeriesRenderers[oldSeriesIndex]._series;
          seriesRenderer._oldDataPoints = <CartesianChartPoint<dynamic>>[]
            //ignore: prefer_spread_collections
            ..addAll(oldWidgetSeriesRenderers[oldSeriesIndex]._dataPoints);
          seriesRenderer._repaintNotifier =
              oldWidgetSeriesRenderers[oldSeriesIndex]._repaintNotifier;
          seriesRenderer._animationController =
              oldWidgetSeriesRenderers[oldSeriesIndex]._animationController;
        } else {
          seriesRenderer._oldSeries = null;
          seriesRenderer._oldDataPoints = <CartesianChartPoint<dynamic>>[];
        }

        _seriesRenderers.add(seriesRenderer);
        _chartSeries.visibleSeriesRenderers.add(seriesRenderer);
      }
    } else {
      _seriesRenderers.clear();
      _chartSeries.visibleSeriesRenderers.clear();
    }
  }

  /// Check current series index is exist in another index
  int _getExistingSeriesIndex(CartesianSeries<dynamic, dynamic> currentSeries,
      List<CartesianSeriesRenderer> oldSeriesRenderers) {
    if (currentSeries.key != null) {
      for (int index = 0; index < oldSeriesRenderers.length; index++) {
        final CartesianSeries<dynamic, dynamic> series =
            oldSeriesRenderers[index]._series;
        if (_isSameSeries(series, currentSeries)) {
          return index;
        }
      }
    }
    return null;
  }

  /// Refresh method for axis
  void _refresh() {
    if (_legendWidgetContext.isNotEmpty) {
      for (int i = 0; i < _legendWidgetContext.length; i++) {
        final _MeasureWidgetContext templateContext = _legendWidgetContext[i];
        final RenderBox renderBox = templateContext.context.findRenderObject();
        templateContext.size = renderBox.size;
      }
      setState(() {
        /// The chart will be rebuilding again, Once legend template sizes will be calculated.
      });
    }
  }

  /// Redraw method for chart axis
  void _redraw() {
    _oldAxisRenderers = _chartAxis._axisRenderersCollection;
    if (_tooltipBehaviorRenderer?._painter?.timer != null) {
      _tooltipBehaviorRenderer._painter.timer.cancel();
    }
    if (_trackballBehaviorRenderer?._trackballPainter?.timer != null) {
      _trackballBehaviorRenderer._trackballPainter.timer.cancel();
    }
    if (_isLegendToggled) {
      _segments = <ChartSegment>[];
      _oldSeriesVisible =
          List<bool>(_chartSeries.visibleSeriesRenderers.length);
      for (int i = 0; i < _chartSeries.visibleSeriesRenderers.length; i++) {
        final CartesianSeriesRenderer seriesRenderer =
            _chartSeries.visibleSeriesRenderers[i];
        if (seriesRenderer is ColumnSeriesRenderer ||
            seriesRenderer is BarSeriesRenderer) {
          for (int j = 0; j < seriesRenderer._segments.length; j++) {
            _segments.add(seriesRenderer._segments[j]);
          }
        }
      }
    }
    if (_zoomedAxisRendererStates != null &&
        _zoomedAxisRendererStates.isNotEmpty) {
      _zoomedState = false;
      for (final ChartAxisRenderer axisRenderer in _zoomedAxisRendererStates) {
        _zoomedState = axisRenderer._zoomFactor != 1;
        if (_zoomedState) {
          break;
        }
      }
    }
    _widgetNeedUpdate = false;

    if (mounted) {
      setState(() {
        /// check the "mounted" property of this object and  to ensure the object is still in the tree.
        /// The chart will be rebuilding again, When we do the legend toggle, zoom/pan the chart.
      });
    }
  }

  void _redrawByRangeChange() {
    if (mounted) {
      setState(() {
        /// check the "mounted" property of this object and  to ensure the object is still in the tree.
        /// When we do the range change by using the slider or other way, chart will be rebuilding again.
      });
    }
  }

  void _forwardAnimation(CartesianSeriesRenderer seriesRenderer) {
    seriesRenderer._animationController.duration = Duration(
        milliseconds: seriesRenderer._series.animationDuration.toInt());
    seriesRenderer._seriesAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: seriesRenderer._animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
    ));
    seriesRenderer._seriesElementAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: seriesRenderer._animationController,
      curve: const Interval(0.85, 1.0, curve: Curves.decelerate),
    ));
    seriesRenderer._animationController.forward(from: 0.0);
  }

  void _repaintTrendlines() {
    _trendlineRepaintNotifier.value++;
  }

  void _setPainterKey(int index, String name, bool renderComplete) {
    int value = 0;
    for (int i = 0; i < _painterKeys.length; i++) {
      final _PainterKey painterKey = _painterKeys[i];
      if (painterKey.isRenderCompleted) {
        value++;
      } else if (painterKey.index == index &&
          painterKey.name == name &&
          !painterKey.isRenderCompleted) {
        painterKey.isRenderCompleted = renderComplete;
        value++;
      }
      if (value >= _painterKeys.length && !_triggerLoaded) {
        _triggerLoaded = true;
      }
    }
  }

  Widget _renderTitle() {
    Widget titleWidget;
    if (_chart.title.text != null && _chart.title.text.isNotEmpty) {
      final Paint titleBackground = Paint()
        ..color = _chart.title.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _chart.title.borderWidth;
      final TextStyle titleStyle = _getTextStyle(
          textStyle: _chart.title.textStyle,
          background: titleBackground,
          fontColor:
              _chart.title.textStyle.color ?? _chartTheme.titleTextColor);
      final TextStyle textStyle = TextStyle(
          color: titleStyle.color,
          fontSize: titleStyle.fontSize,
          fontFamily: titleStyle.fontFamily,
          fontStyle: titleStyle.fontStyle,
          fontWeight: titleStyle.fontWeight);
      titleWidget = Container(
        child: Container(
          child: Text(_chart.title.text,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              textScaleFactor: 1.2,
              style: textStyle),
          decoration: BoxDecoration(
              color: _chart.title.backgroundColor ??
                  _chartTheme.titleBackgroundColor,
              border: Border.all(
                  color: _chart.title.borderWidth == 0
                      ? Colors.transparent
                      : _chart.title.borderColor ?? _chartTheme.titleTextColor,
                  width: _chart.title.borderWidth)),
        ),
        alignment: (_chart.title.alignment == ChartAlignment.near)
            ? Alignment.topLeft
            : (_chart.title.alignment == ChartAlignment.far)
                ? Alignment.topRight
                : (_chart.title.alignment == ChartAlignment.center)
                    ? Alignment.topCenter
                    : Alignment.topCenter,
      );
    } else {
      titleWidget = Container();
    }
    return titleWidget;
  }

  /// To arrange the chart area and legend area based on the legend position
  Widget _renderChartElements(BuildContext context) {
    if (widget.plotAreaBackgroundImage != null || widget.legend.image != null) {
      _calculateImage(widget);
    }
    _deviceOrientation = MediaQuery.of(context).orientation;
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        Widget element;
        final List<Widget> legendTemplates =
            _bindCartesianLegendTemplateWidgets();
        if (legendTemplates.isNotEmpty && _legendWidgetContext.isEmpty) {
          element = Container(child: Stack(children: legendTemplates));
          SchedulerBinding.instance.addPostFrameCallback((_) => _refresh());
        } else {
          _initialize(constraints);
          _chartLegend._calculateLegendBounds(_chartLegend.chartSize);
          element = _getElements(this, _ContainerArea(this), constraints);
        }
        return element;
      }),
    );
  }

  /// To return the template widget
  List<Widget> _bindCartesianLegendTemplateWidgets() {
    Widget legendWidget;
    final List<Widget> templates = <Widget>[];
    if (widget.legend.isVisible && widget.legend.legendItemBuilder != null) {
      for (int i = 0; i < _seriesRenderers.length; i++) {
        final CartesianSeriesRenderer seriesRenderer = _seriesRenderers[i];
        if (seriesRenderer._series.isVisibleInLegend) {
          legendWidget = widget.legend.legendItemBuilder(
              seriesRenderer._seriesName, seriesRenderer._series, null, i);
          templates.add(_MeasureWidgetSize(
              chartState: this,
              seriesIndex: i,
              pointIndex: null,
              type: 'Legend',
              currentKey: GlobalKey(),
              currentWidget: legendWidget,
              opacityValue: 0.0));
        }
      }
    }
    return templates;
  }

  /// To initialise chart legend
  void _initialize(BoxConstraints constraints) {
    final double width = constraints.maxWidth;
    final double height = constraints.maxHeight;
    _legendRenderer._legendPosition =
        (widget.legend.position == LegendPosition.auto)
            ? (height > width ? LegendPosition.bottom : LegendPosition.right)
            : widget.legend.position;
    final LegendPosition position = _legendRenderer._legendPosition;
    final double widthPadding =
        position == LegendPosition.left || position == LegendPosition.right
            ? 5
            : 0;
    final double heightPadding =
        position == LegendPosition.top || position == LegendPosition.bottom
            ? 5
            : 0;
    _chartLegend.chartSize = Size(width - widthPadding, height - heightPadding);
  }

  /// To find the visible series
  void _findVisibleSeries(BuildContext context) {
    bool legendCheck = false;
    _chartSeries.visibleSeriesRenderers = <CartesianSeriesRenderer>[];
    final List<CartesianSeriesRenderer> visibleSeriesRenderers =
        _chartSeries.visibleSeriesRenderers;
    for (int i = 0; i < _seriesRenderers.length; i++) {
      _seriesRenderers[i]._seriesName =
          _seriesRenderers[i]._series.name ?? 'Series $i';
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          _seriesRenderers[i]._series;
      _seriesRenderers[i]._markerSettingsRenderer =
          MarkerSettingsRenderer(_seriesRenderers[i]._series.markerSettings);
      Trendline trendline;
      TrendlineRenderer trendlineRenderer;
      if (cartesianSeries.trendlines != null) {
        _seriesRenderers[i]._trendlineRenderer = <TrendlineRenderer>[];
        final List<int> trendlineTypes = <int>[0, 0, 0, 0, 0, 0];
        for (final Trendline trendline in cartesianSeries.trendlines) {
          trendlineRenderer = TrendlineRenderer(trendline);
          _seriesRenderers[i]._trendlineRenderer.add(trendlineRenderer);
          trendlineRenderer._name ??=
              (trendline.type == TrendlineType.movingAverage
                      ? 'Moving average'
                      : trendline.type.toString().substring(14)) +
                  (' ' + (trendlineTypes[trendline.type.index]++).toString());
        }
        for (final TrendlineRenderer trendlineRenderer
            in _seriesRenderers[i]._trendlineRenderer) {
          trendline = trendlineRenderer._trendline;
          trendlineRenderer._name = trendlineRenderer._name[0].toUpperCase() +
              trendlineRenderer._name.substring(1);
          if (trendlineTypes[trendline.type.index] == 1 &&
              trendlineRenderer._name[trendlineRenderer._name.length - 1] ==
                  '0') {
            trendlineRenderer._name = trendlineRenderer._name
                .substring(0, trendlineRenderer._name.length - 2);
          }
        }
      }
      if (_initialRender ||
          (_widgetNeedUpdate &&
              !_legendToggling &&
              (_oldDeviceOrientation == MediaQuery.of(context).orientation))) {
        if (_seriesRenderers[i]._oldSeries != null &&
            (_seriesRenderers[i]._oldSeries.isVisible ==
                _seriesRenderers[i]._series.isVisible)) {
          legendCheck = true;
        } else {
          _seriesRenderers[i]._visible = _initialRender
              ? _seriesRenderers[i]._series.isVisible
              : _seriesRenderers[i]._visible ??
                  _seriesRenderers[i]._series.isVisible;
        }
      } else {
        legendCheck = true;
      }
      if (i == 0 ||
          (!_seriesRenderers[0]._series.toString().contains('Bar') &&
              !_seriesRenderers[i]._series.toString().contains('Bar')) ||
          (_seriesRenderers[0]._series.toString().contains('Bar') &&
              (_seriesRenderers[i]._series.toString().contains('Bar')))) {
        visibleSeriesRenderers.add(_seriesRenderers[i]);
        if (!_initialRender &&
            _oldSeriesVisible.isNotEmpty &&
            i < visibleSeriesRenderers.length) {
          if (i < visibleSeriesRenderers.length &&
              i < _oldSeriesVisible.length) {
            _oldSeriesVisible[i] = visibleSeriesRenderers[i]._visible;
          }
        }
        if (legendCheck) {
          final int index = visibleSeriesRenderers.length - 1;
          final String legendItemText =
              visibleSeriesRenderers[index]._series.legendItemText;
          final String seriesName = visibleSeriesRenderers[index]._series.name;
          _chartSeries.visibleSeriesRenderers[visibleSeriesRenderers.length - 1]
                  ._visible =
              _checkWithLegendToggleState(
                  visibleSeriesRenderers.length - 1,
                  visibleSeriesRenderers[visibleSeriesRenderers.length - 1]
                      ._series,
                  legendItemText ?? seriesName ?? 'Series $index');
        }
        final CartesianSeriesRenderer cSeriesRenderer = _chartSeries
                    .visibleSeriesRenderers[visibleSeriesRenderers.length - 1]
                is CartesianSeriesRenderer
            ? _chartSeries
                .visibleSeriesRenderers[visibleSeriesRenderers.length - 1]
            : null;
        if (cSeriesRenderer?._series != null &&
            cSeriesRenderer._series.trendlines != null) {
          Trendline trendline;
          TrendlineRenderer trendlineRenderer;
          for (int j = 0; j < cSeriesRenderer._series.trendlines.length; j++) {
            trendline = cSeriesRenderer._series.trendlines[j];
            trendlineRenderer = cSeriesRenderer._trendlineRenderer[j];
            trendlineRenderer._visible = _checkWithTrendlineLegendToggleState(
                    visibleSeriesRenderers.length - 1,
                    cSeriesRenderer._series,
                    j,
                    trendline,
                    trendlineRenderer._name) &&
                cSeriesRenderer._visible;
          }
          _isTrendlineToggled = false;
        }
      }
      legendCheck = false;
    }
    _chartSeries.visibleSeriesRenderers = visibleSeriesRenderers;

    /// setting indicators visibility
    if (_chart.indicators.isNotEmpty) {
      TechnicalIndicatorsRenderer technicalIndicatorRenderer;
      _technicalIndicatorRenderer.clear();
      for (int i = 0; i < _chart.indicators.length; i++) {
        technicalIndicatorRenderer =
            TechnicalIndicatorsRenderer(_chart.indicators[i]);
        _technicalIndicatorRenderer.add(technicalIndicatorRenderer);
        if (_initialRender) {
          technicalIndicatorRenderer._visible = _chart.indicators[i].isVisible;
        } else {
          technicalIndicatorRenderer._visible =
              _checkIndicatorLegendToggleState(
                  visibleSeriesRenderers.length + i,
                  technicalIndicatorRenderer._visible ??
                      _chart.indicators[i].isVisible);
        }
      }
    }
  }

  /// To check the legend toggle state
  bool _checkIndicatorLegendToggleState(int seriesIndex, bool seriesVisible) {
    bool seriesRender;
    if (widget.legend.legendItemBuilder != null) {
      final List<_MeasureWidgetContext> legendToggles =
          _legendToggleTemplateStates;
      if (legendToggles.isNotEmpty) {
        for (int j = 0; j < legendToggles.length; j++) {
          final _MeasureWidgetContext item = legendToggles[j];
          if (seriesIndex == item.seriesIndex) {
            seriesRender = false;
            break;
          }
        }
      }
    } else {
      if (_legendToggleStates.isNotEmpty) {
        for (int j = 0; j < _legendToggleStates.length; j++) {
          final _LegendRenderContext legendRenderContext =
              _legendToggleStates[j];
          if (seriesIndex == legendRenderContext.seriesIndex) {
            seriesRender = false;
            break;
          }
        }
      }
    }
    return seriesRender ?? true;
  }

  /// Check whether trendline enable with legend toggled state
  bool _checkWithTrendlineLegendToggleState(
      int seriesIndex,
      CartesianSeries<dynamic, dynamic> series,
      int trendlineIndex,
      Trendline trendline,
      String text) {
    bool seriesRender;
    if (_legendToggleStates.isNotEmpty) {
      for (int j = 0; j < _legendToggleStates.length; j++) {
        final _LegendRenderContext legendRenderContext = _legendToggleStates[j];
        if ((legendRenderContext.text == text &&
                legendRenderContext.seriesIndex == seriesIndex &&
                legendRenderContext.trendlineIndex == trendlineIndex) ||
            _isTrendlineToggled) {
          seriesRender = false;
          break;
        }
      }
    }
    return seriesRender ?? true;
  }

  /// To toggle series visiblity based on legend toggle states
  bool _checkWithLegendToggleState(
      int seriesIndex, ChartSeries<dynamic, dynamic> series, String text) {
    bool seriesRender;
    if (_chart.legend.legendItemBuilder != null) {
      final List<_MeasureWidgetContext> legendToggles =
          _legendToggleTemplateStates;
      if (legendToggles.isNotEmpty) {
        for (int j = 0; j < legendToggles.length; j++) {
          final _MeasureWidgetContext item = legendToggles[j];
          if (seriesIndex == item.seriesIndex) {
            seriesRender = false;
            break;
          }
        }
      }
    } else {
      if (_legendToggleStates.isNotEmpty) {
        for (int j = 0; j < _legendToggleStates.length; j++) {
          final _LegendRenderContext legendRenderContext =
              _legendToggleStates[j];
          if (seriesIndex == legendRenderContext.seriesIndex &&
              legendRenderContext.text == text) {
            if (series is CartesianSeries) {
              final CartesianSeries<dynamic, dynamic> cSeries = series;
              if (cSeries.trendlines != null) {
                _isTrendlineToggled = true;
              }
            }
            seriesRender = false;
            break;
          }
        }
      }
    }
    return seriesRender ?? true;
  }
}

// ignore: must_be_immutable
class _ContainerArea extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ContainerArea([this._chartState]);
  final SfCartesianChartState _chartState;
  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCartesianChart get chart => _chartState._chart;
  List<Widget> _chartWidgets;
  RenderBox renderBox;
  Offset _touchPosition;
  Offset _tapDownDetails;
  Offset _mousePointerDetails;
  CartesianSeries<dynamic, dynamic> _series;
  XyDataSeriesRenderer _seriesRenderer;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          decoration: const BoxDecoration(color: Colors.transparent),

          /// To get the mouse region of the chart
          child: MouseRegion(
              child: _initializeChart(constraints, context),
              onHover: (PointerEvent event) => _performMouseHover(event),
              onExit: (PointerEvent event) => _performMouseExit(event)));
    });
  }

  Offset _zoomStartPosition;

  /// To initialise chart
  Widget _initializeChart(BoxConstraints constraints, BuildContext context) {
    // chart._chartState._tooltipBehaviorRenderer = TooltipBehaviorRenderer(chart.tooltipBehavior);

    _calculateContainerSize(constraints);
    _calculateBounds();
    return Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: _renderWidgets(constraints, context));
  }

  /// To get the size of a container
  void _calculateContainerSize(BoxConstraints constraints) {
    final double width = constraints.maxWidth;
    final double height = constraints.maxHeight;
    _chartState._containerRect = Rect.fromLTWH(0, 0, width, height);
  }

  /// Calculate container bounds
  void _calculateBounds() {
    _chartState._chartSeries?._processData();
    _chartState._chartAxis?._measureAxesBounds();
    _chartState._rangeChangeBySlider = false;
    _chartState._rangeChangedByChart = false;
  }

  /// To calculate the trendline region
  void _calculateTrendlineRegion(
      SfCartesianChartState _chartState, XyDataSeriesRenderer seriesRenderer) {
    if (seriesRenderer._series.trendlines != null) {
      TrendlineRenderer trendlineRenderer;
      for (int i = 0; i < seriesRenderer._series.trendlines.length; i++) {
        trendlineRenderer = seriesRenderer._trendlineRenderer[i];
        if (trendlineRenderer._isNeedRender) {
          trendlineRenderer.calculateTrendlinePoints(
              seriesRenderer, _chartState);
        }
      }
    }
  }

  /// To render chart widgets
  Widget _renderWidgets(BoxConstraints constraints, BuildContext context) {
    _chartWidgets = <Widget>[];
    _chartState._renderDatalabelRegions = <Rect>[];
    _bindAxisWidgets('outside');
    _bindPlotBandWidgets(true);
    _bindSeriesWidgets();
    _bindPlotBandWidgets(false);
    _bindDataLabelWidgets();
    _bindTrendlineWidget();
    _bindAxisWidgets('inside');
    _renderTemplates();
    _bindInteractionWidgets(constraints, context);
    renderBox = context.findRenderObject();
    _chartState._containerArea = this;
    return Container(child: Stack(children: _chartWidgets));
  }

  void _bindPlotBandWidgets(bool shouldRenderAboveSeries) {
    _chartWidgets.add(RepaintBoundary(
        child: CustomPaint(
            painter: _PlotBandPainter(
                chartState: _chartState,
                shouldRenderAboveSeries: shouldRenderAboveSeries))));
  }

  void _bindTrendlineWidget() {
    bool isTrendline = false;
    final Map<String, Animation<double>> trendlineAnimations =
        <String, Animation<double>>{};
    for (int i = 0;
        i < _chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      _seriesRenderer = _chartState._chartSeries.visibleSeriesRenderers[i];
      _series = _seriesRenderer._series;
      if (_seriesRenderer != null &&
          _seriesRenderer._visible &&
          _series.trendlines != null) {
        isTrendline = true;
        for (int j = 0; j < _seriesRenderer._trendlineRenderer.length; j++) {
          final TrendlineRenderer trendlineRenderer =
              _seriesRenderer._trendlineRenderer[j];
          final Trendline trendline = _series.trendlines[j];
          if (trendline.animationDuration > 0 &&
              (_chartState._oldDeviceOrientation == null ||
                  _chartState._oldDeviceOrientation ==
                      _chartState._deviceOrientation) &&
              _seriesRenderer._needsAnimation &&
              _seriesRenderer._oldSeries == null) {
            trendlineRenderer._animationController.duration =
                Duration(milliseconds: trendline.animationDuration.toInt());
            trendlineAnimations['$i-$j'] =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: trendlineRenderer._animationController,
              curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
            ));
            trendlineRenderer._animationController.forward(from: 0.0);
          }
        }
      }
    }
    if (isTrendline) {
      _chartWidgets.add(RepaintBoundary(
        child: CustomPaint(
            painter: _TrendlinePainter(
                chartState: _chartState,
                trendlineAnimations: trendlineAnimations,
                notifier: _chartState._trendlineRepaintNotifier)),
      ));
    }
  }

  /// To bind the widget for data label
  void _bindDataLabelWidgets() {
    _chartState._renderDataLabel = _DataLabelRenderer(
        cartesianChartState: _chartState, show: _chartState._animateCompleted);
    _chartWidgets.add(_chartState._renderDataLabel);
  }

  /// To render a template
  void _renderTemplates() {
    _chartState._annotationRegions = <Rect>[];
    _chartState._templates = <_ChartTemplateInfo>[];
    _renderDataLabelTemplates();
    if (chart.annotations != null && chart.annotations.isNotEmpty) {
      for (int i = 0; i < chart.annotations.length; i++) {
        final CartesianChartAnnotation annotation = chart.annotations[i];
        final _ChartLocation location =
            _getAnnotationLocation(annotation, _chartState);
        final _ChartTemplateInfo chartTemplateInfo = _ChartTemplateInfo(
            key: GlobalKey(),
            animationDuration: 200,
            widget: annotation.widget,
            templateType: 'Annotation',
            needMeasure: true,
            pointIndex: i,
            verticalAlignment: annotation.verticalAlignment,
            horizontalAlignment: annotation.horizontalAlignment,
            clipRect: annotation.region == AnnotationRegion.chart
                ? _chartState._containerRect
                : _chartState._chartAxis._axisClipRect,
            location: Offset(location.x.toDouble(), location.y.toDouble()));
        _chartState._templates.add(chartTemplateInfo);
      }
    }

    if (_chartState._templates.isNotEmpty) {
      final int templateLength = _chartState._templates.length;
      for (int i = 0; i < _chartState._templates.length; i++) {
        final _ChartTemplateInfo templateInfo = _chartState._templates[i];
        _chartWidgets.add(_RenderTemplate(
            template: templateInfo,
            templateIndex: i,
            templateLength: templateLength,
            chartState: _chartState));
      }
    }
  }

  /// To render data label template
  void _renderDataLabelTemplates() {
    Widget labelWidget;
    CartesianChartPoint<dynamic> point;
    _chartState._dataLabelTemplateRegions = <Rect>[];
    for (int i = 0;
        i < _chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final CartesianSeriesRenderer seriesRenderer =
          _chartState._chartSeries.visibleSeriesRenderers[i];
      final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
      if (series.dataLabelSettings.isVisible && seriesRenderer._visible) {
        for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
          point = seriesRenderer._dataPoints[j];
          if (point.isVisible && !point.isGap) {
            labelWidget = (series.dataLabelSettings.builder != null)
                ? series.dataLabelSettings.builder(
                    series.dataSource[point.overallDataPointIndex],
                    point,
                    series,
                    point.overallDataPointIndex,
                    i)
                : null;
            if (labelWidget != null) {
              final _ChartLocation location = _calculatePoint(
                  point.xValue,
                  seriesRenderer._seriesType.contains('range')
                      ? point.high
                      : seriesRenderer._seriesType.contains('boxandwhisker')
                          ? point.minimum
                          : point.yValue,
                  seriesRenderer._xAxisRenderer,
                  seriesRenderer._yAxisRenderer,
                  _chartState._requireInvertedAxis,
                  series,
                  _chartState._chartAxis._axisClipRect);
              final _ChartTemplateInfo templateInfo = _ChartTemplateInfo(
                  key: GlobalKey(),
                  templateType: 'DataLabel',
                  pointIndex: j,
                  seriesIndex: i,
                  needMeasure: true,
                  clipRect: _chartState._chartAxis._axisClipRect,
                  animationDuration:
                      (series.animationDuration + 1000.0).floor(),
                  widget: labelWidget,
                  location: Offset(location.x, location.y));
              _chartState._templates.add(templateInfo);
              if (seriesRenderer._seriesType.contains('range')) {
                final _ChartLocation rangeLocation = _calculatePoint(
                    point.xValue,
                    point.low,
                    seriesRenderer._xAxisRenderer,
                    seriesRenderer._yAxisRenderer,
                    _chartState._requireInvertedAxis,
                    series,
                    _chartState._chartAxis._axisClipRect);
                final _ChartTemplateInfo templateInfo2 = _ChartTemplateInfo(
                    key: GlobalKey(),
                    templateType: 'DataLabel',
                    pointIndex: j,
                    seriesIndex: i,
                    needMeasure: true,
                    clipRect: _chartState._chartAxis._axisClipRect,
                    animationDuration:
                        (series.animationDuration + 1000.0).floor(),
                    widget: labelWidget,
                    location: Offset(rangeLocation.x, rangeLocation.y));
                _chartState._templates.add(templateInfo2);
              }
            }
          }
        }
      }
    }
  }

  /// To bind a series of widgets for all series
  void _bindSeriesWidgets() {
    _chartState._painterKeys = <_PainterKey>[];
    _chartState._animationCompleteCount = 0;
    _chartState._animateCompleted = false;
    for (int i = 0;
        i < _chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      _seriesRenderer = _chartState._chartSeries.visibleSeriesRenderers[i];
      _series = _seriesRenderer._series;
      final String _seriesType = _seriesRenderer._seriesType;
      if (_seriesRenderer != null && _seriesRenderer._visible) {
        _calculateTrendlineRegion(_chartState, _seriesRenderer);
        _series.selectionBehavior._chartState = _chartState;
        _series.selectionSettings._chartState = _chartState;
        _seriesRenderer._selectionBehavior = _series.selectionBehavior.enable
            ? _series.selectionBehavior
            : _series.selectionSettings;
        final dynamic selectionBehavior = _seriesRenderer._selectionBehavior;
        _seriesRenderer._selectionBehaviorRenderer =
            SelectionBehaviorRenderer(selectionBehavior, chart, _chartState);
        final SelectionBehaviorRenderer selectionBehaviorRenderer =
            _seriesRenderer._selectionBehaviorRenderer;
        if (selectionBehaviorRenderer != null) {
          selectionBehaviorRenderer._selectionRenderer ??= _SelectionRenderer();
          selectionBehaviorRenderer._selectionRenderer.chart = chart;
          selectionBehaviorRenderer._selectionRenderer._chartState =
              _chartState;
          selectionBehaviorRenderer._selectionRenderer.seriesRenderer =
              _seriesRenderer;
          _series = _seriesRenderer._series;
          if (selectionBehavior.selectionController != null) {
            selectionBehaviorRenderer._selectRange();
          }
          selectionBehaviorRenderer._selectionRenderer.selectedSegments =
              _chartState._selectedSegments;
          selectionBehaviorRenderer._selectionRenderer.unselectedSegments =
              _chartState._unselectedSegments;
          if (_chartState._isRangeSelectionSlider == false &&
              selectionBehavior.enable &&
              _series.initialSelectedDataIndexes.isNotEmpty) {
            for (int j = 0;
                j < _seriesRenderer._series.initialSelectedDataIndexes.length;
                j++) {
              final ChartSegment segment = ColumnSegment();
              segment.currentSegmentIndex =
                  _seriesRenderer._series.initialSelectedDataIndexes[j];
              segment._seriesIndex = i;
              if (_seriesRenderer._series.initialSelectedDataIndexes
                  .contains(segment.currentSegmentIndex)) {
                selectionBehaviorRenderer._selectionRenderer.selectedSegments
                    .add(segment);
              }
            }
          }
        }
        if (_seriesRenderer._isIndicator) {
          _seriesRenderer._repaintNotifier = ValueNotifier<int>(0);
          if (_seriesRenderer is XyDataSeriesRenderer) {
            _seriesRenderer._animationController =
                AnimationController(vsync: _chartState)
                  ..addListener(_seriesRenderer._repaintSeriesElement);
            _chartState._controllerList[_seriesRenderer._animationController] =
                _seriesRenderer._repaintSeriesElement;
            _seriesRenderer._animationController
                .addStatusListener(_seriesRenderer._animationStatusListener);
          }
        }

        if (_seriesRenderer._animationController != null &&
            _series.animationDuration > 0 &&
            (_chartState._oldDeviceOrientation == null ||
                _chartState._oldDeviceOrientation ==
                    _chartState._deviceOrientation) &&
            (_chartState._initialRender ||
                ((_seriesType == 'column' || _seriesType == 'bar') &&
                    _chartState._legendToggling) ||
                (!_chartState._legendToggling &&
                    _seriesRenderer._needsAnimation &&
                    _chartState._widgetNeedUpdate))) {
          if ((_seriesType == 'column' || _seriesType == 'bar') &&
              _chartState._legendToggling) {
            _seriesRenderer._needAnimateSeriesElements = true;
          }
          _chartState._forwardAnimation(_seriesRenderer);
        } else {
          _seriesRenderer._animationController.duration =
              const Duration(milliseconds: 0);
          _seriesRenderer._seriesAnimation =
              Tween<double>(begin: 1, end: 1.0).animate(CurvedAnimation(
            parent: _seriesRenderer._animationController,
            curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
          ));
          _seriesRenderer._seriesElementAnimation =
              Tween<double>(begin: 1, end: 1.0).animate(CurvedAnimation(
            parent: _seriesRenderer._animationController,
            curve: const Interval(1.0, 1.0, curve: Curves.decelerate),
          ));
          _chartState._animationCompleteCount++;
          _setAnimationStatus(_chartState);
        }
      }
      _chartWidgets.add(Container(
          child: RepaintBoundary(
              child: CustomPaint(
        painter: _getSeriesPainter(
            i, _seriesRenderer._animationController, _seriesRenderer),
      ))));
    }
    _chartWidgets.add(Container(
        color: Colors.red,
        child: RepaintBoundary(
            child: CustomPaint(
                painter: _ZoomRectPainter(
                    isRepaint: true,
                    chartState: _chartState,
                    notifier: _chartState._zoomRepaintNotifier)))));
    _chartState._legendToggling = false;
  }

  /// Bind the axis widgets
  void _bindAxisWidgets(String renderType) {
    if (_chartState._chartAxis._axisRenderersCollection != null &&
        _chartState._chartAxis._axisRenderersCollection.isNotEmpty &&
        _chartState._chartAxis._axisRenderersCollection.length > 1) {
      _chartState._renderAxis = _CartesianAxisRenderer(
          chartState: _chartState, renderType: renderType);
      _chartWidgets.add(_chartState._renderAxis);
    }
  }

  /// To find a series on selection event
  CartesianSeriesRenderer _findSeries(Offset position) {
    CartesianSeriesRenderer seriesRenderer;
    SelectionBehaviorRenderer selectionBehaviorRenderer;
    outerLoop:
    for (int i = _chartState._chartSeries.visibleSeriesRenderers.length - 1;
        i >= 0;
        i--) {
      seriesRenderer = _chartState._chartSeries.visibleSeriesRenderers[i];
      final String _seriesType = seriesRenderer._seriesType;
      if (_seriesType == 'column' ||
          _seriesType == 'bar' ||
          _seriesType == 'scatter' ||
          _seriesType == 'bubble' ||
          _seriesType == 'fastline' ||
          _seriesType.contains('area') ||
          _seriesType.contains('stackedcolumn') ||
          _seriesType.contains('stackedbar') ||
          _seriesType.contains('range') ||
          _seriesType == 'waterfall') {
        for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
          if (seriesRenderer._dataPoints[j].region != null &&
              seriesRenderer._dataPoints[j].region.contains(position)) {
            seriesRenderer._isOuterRegion = false;
            break outerLoop;
          } else {
            seriesRenderer._isOuterRegion = true;
          }
        }
      } else {
        selectionBehaviorRenderer = seriesRenderer._selectionBehaviorRenderer;
        bool isSelect = false;
        seriesRenderer = _chartState._chartSeries.visibleSeriesRenderers[i];
        for (int k = _chartState._chartSeries.visibleSeriesRenderers.length - 1;
            k >= 0;
            k--) {
          isSelect =
              seriesRenderer._isSelectionEnable && seriesRenderer._visible
                  ? selectionBehaviorRenderer._selectionRenderer
                      ._isSeriesContainsPoint(
                          _chartState._chartSeries.visibleSeriesRenderers[i],
                          position)
                  : false;
          if (isSelect) {
            return _chartState._chartSeries.visibleSeriesRenderers[i];
          }
        }
      }
    }
    return seriesRenderer;
  }

  /// To perform the pointer down event
  void _performPointerDown(PointerDownEvent event) {
    _chartState._tooltipBehaviorRenderer._isHovering = false;
    _tapDownDetails = event.position;
    if (chart.zoomPanBehavior.enablePinching == true) {
      ZoomPanArgs zoomStartArgs;
      if (_chartState._touchStartPositions.length < 2) {
        _chartState._touchStartPositions.add(event);
      }
      if (_chartState._touchStartPositions.length == 2) {
        for (int axisIndex = 0;
            axisIndex < _chartState._chartAxis._axisRenderersCollection.length;
            axisIndex++) {
          final ChartAxisRenderer axisRenderer =
              _chartState._chartAxis._axisRenderersCollection[axisIndex];
          if (chart.onZoomStart != null) {
            zoomStartArgs = _bindZoomEvent(
                chart, axisRenderer, zoomStartArgs, chart.onZoomStart);
            axisRenderer._zoomFactor = zoomStartArgs.currentZoomFactor;
            axisRenderer._zoomPosition = zoomStartArgs.currentZoomPosition;
          }
          _chartState._zoomPanBehaviorRenderer.onPinchStart(
              axisRenderer._axis,
              _chartState._touchStartPositions[0].position.dx,
              _chartState._touchStartPositions[0].position.dy,
              _chartState._touchStartPositions[1].position.dx,
              _chartState._touchStartPositions[1].position.dy,
              axisRenderer._zoomFactor);
        }
      }
    }
    final Offset position = renderBox.globalToLocal(event.position);
    _touchPosition = position;
    if (_chartState._chartSeries.visibleSeriesRenderers != null &&
        _chartState._chartSeries.visibleSeriesRenderers.isNotEmpty &&
        chart.selectionGesture == ActivationMode.singleTap &&
        _chartState._zoomPanBehaviorRenderer._isPinching != true) {
      final CartesianSeriesRenderer selectionSeriesRenderer =
          _findSeries(position);
      final SelectionBehaviorRenderer selectionBehaviorRenderer =
          selectionSeriesRenderer._selectionBehaviorRenderer;
      if (selectionSeriesRenderer._isSelectionEnable &&
          selectionBehaviorRenderer._selectionRenderer != null &&
          !selectionSeriesRenderer._isOuterRegion) {
        selectionBehaviorRenderer._selectionRenderer.seriesRenderer =
            selectionSeriesRenderer;
        selectionBehaviorRenderer.onTouchDown(position.dx, position.dy);
      }
    }
    if (chart.trackballBehavior != null &&
        chart.trackballBehavior.enable &&
        chart.trackballBehavior.activationMode == ActivationMode.singleTap) {
      _chartState._trackballBehaviorRenderer
          .onTouchDown(position.dx, position.dy);
    }
    if (chart.crosshairBehavior != null &&
        chart.crosshairBehavior.enable &&
        chart.crosshairBehavior.activationMode == ActivationMode.singleTap) {
      _chartState._crosshairBehaviorRenderer
          .onTouchDown(position.dx, position.dy);
    }
  }

  /// To perform the pointer move event
  void _performPointerMove(PointerMoveEvent event) {
    _chartState._tooltipBehaviorRenderer._isHovering = false;
    if (chart.zoomPanBehavior.enablePinching == true &&
        _chartState._touchStartPositions.length == 2) {
      _chartState._zoomPanBehaviorRenderer._isPinching = true;
      final int pointerID = event.pointer;
      bool addPointer = true;
      for (int i = 0; i < _chartState._touchMovePositions.length; i++) {
        if (_chartState._touchMovePositions[i].pointer == pointerID) {
          addPointer = false;
        }
      }
      if (_chartState._touchMovePositions.length < 2 && addPointer) {
        _chartState._touchMovePositions.add(event);
      }

      if (_chartState._touchMovePositions.length == 2 &&
          _chartState._touchStartPositions.length == 2) {
        if (_chartState._touchMovePositions[0].pointer == event.pointer) {
          _chartState._touchMovePositions[0] = event;
        }
        if (_chartState._touchMovePositions[1].pointer == event.pointer) {
          _chartState._touchMovePositions[1] = event;
        }
        _chartState._zoomPanBehaviorRenderer._performPinchZooming(
            _chartState._touchStartPositions, _chartState._touchMovePositions);
      }
    }
  }

  /// To perform the pointer up event
  void _performPointerUp(PointerUpEvent event) {
    if (_chartState._touchStartPositions.length == 2 &&
        _chartState._touchMovePositions.length == 2 &&
        _chartState._zoomPanBehaviorRenderer._isPinching) {
      _calculatePinchZoomingArgs();
    }
    _chartState._touchStartPositions = <PointerEvent>[];
    _chartState._touchMovePositions = <PointerEvent>[];
    _chartState._zoomPanBehaviorRenderer._isPinching = false;
    _chartState._zoomPanBehaviorRenderer._delayRedraw = false;
    _chartState._tooltipBehaviorRenderer._isHovering = false;
    final Offset position = renderBox.globalToLocal(event.position);
    if ((chart.trackballBehavior != null &&
            chart.trackballBehavior.enable &&
            !chart.trackballBehavior.shouldAlwaysShow &&
            chart.trackballBehavior.activationMode !=
                ActivationMode.doubleTap &&
            _chartState._zoomPanBehaviorRenderer._isPinching != true) ||
        (chart.zoomPanBehavior != null &&
            ((chart.zoomPanBehavior.enableDoubleTapZooming ||
                    chart.zoomPanBehavior.enablePanning ||
                    chart.zoomPanBehavior.enablePinching ||
                    chart.zoomPanBehavior.enableSelectionZooming) &&
                !chart.trackballBehavior.shouldAlwaysShow))) {
      ChartTouchInteractionArgs touchUpArgs;
      _chartState._trackballBehaviorRenderer
          .onTouchUp(position.dx, position.dy);
      _chartState._trackballBehaviorRenderer._isLongPressActivated = false;
      if (chart.onChartTouchInteractionUp != null) {
        touchUpArgs = ChartTouchInteractionArgs();
        touchUpArgs.position = position;
        chart.onChartTouchInteractionUp(touchUpArgs);
      }
    }
    if ((chart.crosshairBehavior != null &&
            chart.crosshairBehavior.enable &&
            !chart.crosshairBehavior.shouldAlwaysShow &&
            chart.crosshairBehavior.activationMode !=
                ActivationMode.doubleTap &&
            _chartState._zoomPanBehaviorRenderer._isPinching != true) ||
        (chart.zoomPanBehavior != null &&
            ((chart.zoomPanBehavior.enableDoubleTapZooming ||
                    chart.zoomPanBehavior.enablePanning ||
                    chart.zoomPanBehavior.enablePinching ||
                    chart.zoomPanBehavior.enableSelectionZooming) &&
                !chart.crosshairBehavior.shouldAlwaysShow))) {
      ChartTouchInteractionArgs touchUpArgs;
      _chartState._crosshairBehaviorRenderer
          .onTouchUp(position.dx, position.dy);
      _chartState._crosshairBehaviorRenderer._isLongPressActivated = true;
      if (chart.onChartTouchInteractionUp != null) {
        touchUpArgs = ChartTouchInteractionArgs();
        touchUpArgs.position = position;
        chart.onChartTouchInteractionUp(touchUpArgs);
      }
    }
    if (chart.tooltipBehavior.enable &&
        chart.tooltipBehavior.activationMode == ActivationMode.singleTap) {
      _chartState._tooltipBehaviorRenderer._isInteraction = true;
      if (chart.tooltipBehavior.builder != null) {
        _chartState._tooltipBehaviorRenderer._showTemplateTooltip(position);
      } else {
        _chartState._tooltipBehaviorRenderer
            .onTouchUp(position.dx, position.dy);
      }
    }
  }

  /// To perform the pointer signal event
  void _performPointerSignal(PointerScrollEvent event) {
    _mousePointerDetails = event.position;
    if (_mousePointerDetails != null) {
      final Offset position = renderBox.globalToLocal(event.position);
      if (chart.zoomPanBehavior.enableMouseWheelZooming &&
          _chartState._chartAxis._axisClipRect.contains(position)) {
        _chartState._zoomPanBehaviorRenderer
            ._performMouseWheelZooming(event, position.dx, position.dy);
      }
    }
  }

  /// To calculate the arguments of pinch zooming event
  void _calculatePinchZoomingArgs() {
    ZoomPanArgs zoomEndArgs, zoomResetArgs;
    bool resetFlag = false;
    int axisIndex;
    for (axisIndex = 0;
        axisIndex < _chartState._chartAxis._axisRenderersCollection.length;
        axisIndex++) {
      final ChartAxisRenderer axisRenderer =
          _chartState._chartAxis._axisRenderersCollection[axisIndex];
      if (chart.onZoomEnd != null) {
        zoomEndArgs =
            _bindZoomEvent(chart, axisRenderer, zoomEndArgs, chart.onZoomEnd);
        axisRenderer._zoomFactor = zoomEndArgs.currentZoomFactor;
        axisRenderer._zoomPosition = zoomEndArgs.currentZoomPosition;
      }
      if (axisRenderer._zoomFactor.toInt() == 1 &&
          axisRenderer._zoomPosition.toInt() == 0 &&
          chart.onZoomReset != null) {
        resetFlag = true;
      }
      _chartState._zoomAxes = <_ZoomAxisRange>[];
      _chartState._zoomPanBehaviorRenderer.onPinchEnd(
          axisRenderer._axis,
          _chartState._touchMovePositions[0].position.dx,
          _chartState._touchMovePositions[0].position.dy,
          _chartState._touchMovePositions[1].position.dx,
          _chartState._touchMovePositions[1].position.dy,
          axisRenderer._zoomFactor);
    }
    if (resetFlag) {
      for (int index = 0;
          index < _chartState._chartAxis._axisRenderersCollection.length;
          index++) {
        final ChartAxisRenderer axisRenderer =
            _chartState._chartAxis._axisRenderersCollection[index];
        _bindZoomEvent(chart, axisRenderer, zoomResetArgs, chart.onZoomReset);
      }
    }
  }

  /// To perform long press move update
  void _performLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    final Offset position = renderBox.globalToLocal(details.globalPosition);
    if (_chartState._zoomPanBehaviorRenderer._isPinching != true) {
      if (chart.zoomPanBehavior.enableSelectionZooming &&
          position != null &&
          _zoomStartPosition != null) {
        _chartState._zoomPanBehaviorRenderer._canPerformSelection = true;
        _chartState._zoomPanBehaviorRenderer.onDrawSelectionZoomRect(
            position.dx,
            position.dy,
            _zoomStartPosition.dx,
            _zoomStartPosition.dy);
      }
    }
    if (chart.trackballBehavior != null &&
        chart.trackballBehavior.enable &&
        _chartState != null &&
        chart.trackballBehavior.activationMode != ActivationMode.doubleTap &&
        position != null) {
      if (chart.trackballBehavior.activationMode == ActivationMode.singleTap) {
        _chartState._trackballBehaviorRenderer
            .onTouchMove(position.dx, position.dy);
      } else if (chart.trackballBehavior.activationMode ==
              ActivationMode.longPress &&
          _chartState._trackballBehaviorRenderer._isLongPressActivated) {
        _chartState._trackballBehaviorRenderer
            .onTouchMove(position.dx, position.dy);
      }
    }
    if (chart.crosshairBehavior != null &&
        chart.crosshairBehavior.enable &&
        chart.crosshairBehavior.activationMode != ActivationMode.doubleTap &&
        position != null) {
      if (chart.crosshairBehavior.activationMode == ActivationMode.singleTap) {
        _chartState._crosshairBehaviorRenderer
            .onTouchMove(position.dx, position.dy);
      } else if ((chart.crosshairBehavior != null &&
              chart.crosshairBehavior.activationMode ==
                  ActivationMode.longPress &&
              _chartState._crosshairBehaviorRenderer._isLongPressActivated) &&
          !chart.zoomPanBehavior.enableSelectionZooming) {
        _chartState._crosshairBehaviorRenderer
            .onTouchMove(position.dx, position.dy);
      }
    }
  }

  /// To perform long press end
  void _performLongPressEnd() {
    if (_chartState._zoomPanBehaviorRenderer._isPinching != true) {
      _chartState._zoomPanBehaviorRenderer._canPerformSelection = false;
      if (chart.zoomPanBehavior.enableSelectionZooming &&
          _chartState._zoomPanBehaviorRenderer._zoomingRect.width != 0) {
        _chartState._zoomPanBehaviorRenderer._doSelectionZooming(
            _chartState._zoomPanBehaviorRenderer._zoomingRect);
        if (_chartState._zoomPanBehaviorRenderer._canPerformSelection != true) {
          _chartState._zoomPanBehaviorRenderer._zoomingRect =
              const Rect.fromLTRB(0, 0, 0, 0);
        }
      }
    }
  }

  /// To perform pan down
  void _performPanDown(DragDownDetails details) {
    if (_chartState._zoomPanBehaviorRenderer._isPinching != true) {
      _zoomStartPosition = renderBox.globalToLocal(details.globalPosition);
      if (chart.zoomPanBehavior.enablePanning == true) {
        _chartState._zoomPanBehaviorRenderer._isPanning = true;
        _chartState._zoomPanBehaviorRenderer._previousMovedPosition = null;
      }
    }
  }

  /// To perform long press on chart
  void _performLongPress() {
    Offset position;
    if (_tapDownDetails != null) {
      position = renderBox.globalToLocal(_tapDownDetails);
      if (chart.tooltipBehavior.enable &&
          chart.tooltipBehavior.activationMode == ActivationMode.longPress) {
        _chartState._tooltipBehaviorRenderer._isInteraction = true;
        if (chart.tooltipBehavior.builder != null) {
          _chartState._tooltipBehaviorRenderer._showTemplateTooltip(position);
        } else {
          _chartState._tooltipBehaviorRenderer
              .onLongPress(position.dx, position.dy);
        }
      }
    }
    if (_chartState._chartSeries.visibleSeriesRenderers != null &&
        chart.selectionGesture == ActivationMode.longPress) {
      final CartesianSeriesRenderer selectionSeriesRenderer =
          _findSeries(position);
      final SelectionBehaviorRenderer selectionBehaviorRenderer =
          selectionSeriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer._selectionRenderer.seriesRenderer =
          selectionSeriesRenderer;
      selectionBehaviorRenderer.onLongPress(position.dx, position.dy);
    }

    if ((chart.trackballBehavior != null &&
            chart.trackballBehavior.enable == true &&
            chart.trackballBehavior.activationMode ==
                ActivationMode.longPress) &&
        _chartState._zoomPanBehaviorRenderer._isPinching != true) {
      _chartState._trackballBehaviorRenderer._isLongPressActivated = true;
      _chartState._trackballBehaviorRenderer
          .onTouchDown(position.dx, position.dy);
    }
    if ((chart.crosshairBehavior != null &&
            chart.crosshairBehavior.enable == true &&
            chart.crosshairBehavior.activationMode ==
                ActivationMode.longPress) &&
        !chart.zoomPanBehavior.enableSelectionZooming &&
        _chartState._zoomPanBehaviorRenderer._isPinching != true &&
        position != null) {
      _chartState._crosshairBehaviorRenderer._isLongPressActivated = true;
      _chartState._crosshairBehaviorRenderer
          .onTouchDown(position.dx, position.dy);
    }
  }

  /// Method for double tap
  void _performDoubleTap() {
    if (_tapDownDetails != null) {
      final Offset position = renderBox.globalToLocal(_tapDownDetails);
      if (chart.trackballBehavior != null &&
          chart.trackballBehavior.enable &&
          chart.trackballBehavior.activationMode == ActivationMode.doubleTap) {
        _chartState._trackballBehaviorRenderer
            .onDoubleTap(position.dx, position.dy);
        _chartState._enableDoubleTap = true;
        _chartState._trackballBehaviorRenderer
            .onTouchUp(position.dx, position.dy);
        _chartState._enableDoubleTap = false;
      }
      if (chart.crosshairBehavior != null &&
          chart.crosshairBehavior.enable &&
          chart.crosshairBehavior.activationMode == ActivationMode.doubleTap) {
        _chartState._crosshairBehaviorRenderer
            .onDoubleTap(position.dx, position.dy);
        _chartState._enableDoubleTap = true;
        _chartState._crosshairBehaviorRenderer
            .onTouchUp(position.dx, position.dy);
        _chartState._enableDoubleTap = false;
      }
      if (chart.tooltipBehavior.enable &&
          chart.tooltipBehavior.activationMode == ActivationMode.doubleTap) {
        _chartState._tooltipBehaviorRenderer._isInteraction = true;
        if (chart.tooltipBehavior.builder != null) {
          _chartState._tooltipBehaviorRenderer._showTemplateTooltip(position);
        } else {
          _chartState._tooltipBehaviorRenderer
              .onDoubleTap(position.dx, position.dy);
        }
      }
      if (_chartState._chartSeries.visibleSeriesRenderers != null &&
          chart.selectionGesture == ActivationMode.doubleTap) {
        final CartesianSeriesRenderer selectionSeriesRenderer =
            _findSeries(position);
        final SelectionBehaviorRenderer selectionBehaviorRenderer =
            selectionSeriesRenderer._selectionBehaviorRenderer;
        selectionBehaviorRenderer._selectionRenderer.seriesRenderer =
            selectionSeriesRenderer;
        selectionBehaviorRenderer.onDoubleTap(position.dx, position.dy);
      }
    }

    if (chart.zoomPanBehavior.enableDoubleTapZooming == true) {
      final Offset doubleTapPosition = _touchPosition;
      final Offset position = doubleTapPosition;
      if (position != null) {
        _chartState._zoomPanBehaviorRenderer.onDoubleTap(position.dx,
            position.dy, _chartState._zoomPanBehaviorRenderer._zoomFactor);
      }
    }
  }

  /// Update the details for pan
  void _performPanUpdate(DragUpdateDetails details) {
    Offset position;
    if (_chartState._zoomPanBehaviorRenderer._isPinching != true) {
      position = renderBox.globalToLocal(details.globalPosition);
      if (_chartState._zoomPanBehaviorRenderer._isPanning == true &&
          chart.zoomPanBehavior.enablePanning &&
          _chartState._zoomPanBehaviorRenderer._previousMovedPosition != null) {
        _chartState._zoomPanBehaviorRenderer.onPan(position.dx, position.dy);
      }
      _chartState._zoomPanBehaviorRenderer._previousMovedPosition = position;
    }
    final bool panInProgress = chart.zoomPanBehavior.enablePanning &&
        _chartState._zoomPanBehaviorRenderer._previousMovedPosition != null;
    if (chart.trackballBehavior != null &&
        chart.trackballBehavior.enable &&
        position != null &&
        !panInProgress &&
        chart.trackballBehavior.activationMode != ActivationMode.doubleTap) {
      if (chart.trackballBehavior.activationMode == ActivationMode.singleTap) {
        _chartState._trackballBehaviorRenderer
            .onTouchMove(position.dx, position.dy);
      } else if (chart.trackballBehavior != null &&
          chart.trackballBehavior.activationMode == ActivationMode.longPress &&
          _chartState._trackballBehaviorRenderer._isLongPressActivated ==
              true) {
        _chartState._trackballBehaviorRenderer
            .onTouchMove(position.dx, position.dy);
      }
    }
    if (chart.crosshairBehavior != null &&
        chart.crosshairBehavior.enable &&
        chart.crosshairBehavior.activationMode != ActivationMode.doubleTap &&
        position != null &&
        !panInProgress) {
      if (chart.crosshairBehavior.activationMode == ActivationMode.singleTap) {
        _chartState._crosshairBehaviorRenderer
            .onTouchMove(position.dx, position.dy);
      } else if (chart.crosshairBehavior != null &&
          chart.crosshairBehavior.activationMode == ActivationMode.longPress &&
          _chartState._crosshairBehaviorRenderer._isLongPressActivated) {
        _chartState._crosshairBehaviorRenderer
            .onTouchMove(position.dx, position.dy);
      }
    }
  }

  /// Method for the pan end event
  void _performPanEnd(DragEndDetails details) {
    if (_chartState._zoomPanBehaviorRenderer._isPinching != true) {
      _chartState._zoomPanBehaviorRenderer._isPanning = false;
      _chartState._zoomPanBehaviorRenderer._previousMovedPosition = null;
    }
    if (chart.trackballBehavior.enable &&
        !chart.trackballBehavior.shouldAlwaysShow &&
        chart.trackballBehavior.activationMode != ActivationMode.doubleTap &&
        _touchPosition != null) {
      _chartState._trackballBehaviorRenderer
          .onTouchUp(_touchPosition.dx, _touchPosition.dy);
      _chartState._trackballBehaviorRenderer._isLongPressActivated = false;
    }
    if (chart.crosshairBehavior.enable &&
        !chart.crosshairBehavior.shouldAlwaysShow &&
        chart.crosshairBehavior.activationMode != ActivationMode.doubleTap) {
      _chartState._crosshairBehaviorRenderer
          .onTouchUp(_touchPosition?.dx, _touchPosition?.dy);
    }
  }

  /// To perform mouse hover event
  void _performMouseHover(PointerEvent event) {
    _chartState._tooltipBehaviorRenderer._isHovering = true;
    _chartState._tooltipBehaviorRenderer._isInteraction = true;
    final Offset position = renderBox.globalToLocal(event.position);
    if (chart.tooltipBehavior.enable) {
      if (chart.tooltipBehavior.builder != null) {
        _chartState._tooltipBehaviorRenderer._showTemplateTooltip(position);
      } else {
        _chartState._tooltipBehaviorRenderer.onEnter(position.dx, position.dy);
      }
    }
    if (chart.trackballBehavior.enable) {
      _chartState._trackballBehaviorRenderer.onEnter(position.dx, position.dy);
    }
    if (chart.crosshairBehavior.enable) {
      _chartState._crosshairBehaviorRenderer.onEnter(position.dx, position.dy);
    }
  }

  /// To perform the mouse exit event
  void _performMouseExit(PointerEvent event) {
    _chartState._tooltipBehaviorRenderer._isHovering = false;
    final Offset position = renderBox.globalToLocal(event.position);
    if (chart.tooltipBehavior.enable) {
      _chartState._tooltipBehaviorRenderer.onExit(position.dx, position.dy);
    }
    if (chart.crosshairBehavior.enable) {
      _chartState._crosshairBehaviorRenderer.onExit(position.dx, position.dy);
    }
    if (chart.trackballBehavior.enable) {
      _chartState._trackballBehaviorRenderer.onExit(position.dx, position.dy);
    }
  }

  /// To bind the interaction widgets
  void _bindInteractionWidgets(
      BoxConstraints constraints, BuildContext context) {
    final RenderBox renderBox = context.findRenderObject();
    _TrackballPainter trackballPainter;
    _CrosshairPainter crosshairPainter;
    final _ZoomRectPainter zoomRectPainter =
        _ZoomRectPainter(chartState: _chartState);
    _chartState._zoomPanBehaviorRenderer._painter = zoomRectPainter;
    chart.trackballBehavior._chartState = chart.tooltipBehavior._chartState =
        chart.zoomPanBehavior._chartState =
            chart.crosshairBehavior._chartState = _chartState;
    if (chart.trackballBehavior != null && chart.trackballBehavior.enable) {
      trackballPainter = _TrackballPainter(
          chartState: _chartState,
          valueNotifier: _chartState._trackballRepaintNotifier);
      _chartState._trackballBehaviorRenderer._trackballPainter =
          trackballPainter;
      _chartWidgets.add(Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: CustomPaint(painter: trackballPainter)));
    }
    if (chart.crosshairBehavior != null && chart.crosshairBehavior.enable) {
      crosshairPainter = _CrosshairPainter(
          chartState: _chartState,
          valueNotifier: _chartState._crosshairRepaintNotifier);
      _chartState._crosshairBehaviorRenderer._crosshairPainter =
          crosshairPainter;
      _chartWidgets.add(Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: CustomPaint(painter: crosshairPainter)));
    }
    _chartWidgets.add(_getListener(renderBox, constraints));
    if (chart.tooltipBehavior.enable) {
      if (chart.tooltipBehavior.builder != null) {
        _chartState._tooltipBehaviorRenderer._tooltipTemplate =
            _TooltipTemplate(
                show: false,
                clipRect: _chartState._chartAxis._axisClipRect,
                duration: chart.tooltipBehavior.duration,
                tooltipBehavior: chart.tooltipBehavior,
                chartState: _chartState);
        _chartWidgets
            .add(_chartState._tooltipBehaviorRenderer._tooltipTemplate);
      } else {
        _chartState._tooltipBehaviorRenderer._chartTooltip =
            _ChartTooltipRenderer(chartState: _chartState);
        _chartWidgets.add(_chartState._tooltipBehaviorRenderer._chartTooltip);
      }
    }
  }

  /// Listener method for all events
  Widget _getListener(RenderBox renderBox, BoxConstraints constraints) {
    final bool isUserInteractionEnabled =
        chart.zoomPanBehavior.enableDoubleTapZooming ||
            chart.zoomPanBehavior.enableMouseWheelZooming ||
            chart.zoomPanBehavior.enableSelectionZooming ||
            chart.zoomPanBehavior.enablePanning ||
            chart.zoomPanBehavior.enablePinching ||
            chart.trackballBehavior.enable ||
            chart.crosshairBehavior.enable ||
            chart.onChartTouchInteractionMove != null;
    return Listener(
        onPointerDown: (PointerDownEvent event) {
          _performPointerDown(event);
          ChartTouchInteractionArgs touchArgs;
          if (chart.onChartTouchInteractionDown != null) {
            touchArgs = ChartTouchInteractionArgs();
            touchArgs.position = renderBox.globalToLocal(event.position);
            chart.onChartTouchInteractionDown(touchArgs);
          }
        },
        onPointerMove: (PointerMoveEvent event) {
          _performPointerMove(event);
          ChartTouchInteractionArgs touchArgs;
          if (chart.onChartTouchInteractionMove != null) {
            touchArgs = ChartTouchInteractionArgs();
            touchArgs.position = renderBox.globalToLocal(event.position);
            chart.onChartTouchInteractionMove(touchArgs);
          }
        },
        onPointerUp: (PointerUpEvent event) {
          _performPointerUp(event);
          ChartTouchInteractionArgs touchArgs;
          if (chart.onChartTouchInteractionUp != null) {
            touchArgs = ChartTouchInteractionArgs();
            touchArgs.position = renderBox.globalToLocal(event.position);
            chart.onChartTouchInteractionUp(touchArgs);
          }
        },
        onPointerSignal: (PointerSignalEvent event) {
          if (event is PointerScrollEvent) {
            _performPointerSignal(event);
          }
        },
        child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              final Offset position =
                  renderBox.globalToLocal(details.globalPosition);
              _touchPosition = position;
            },
            onTapUp: (TapUpDetails details) {
              final Offset position =
                  renderBox.globalToLocal(details.globalPosition);
              final List<CartesianSeriesRenderer> visibleSeriesRenderer =
                  _chartState._chartSeries.visibleSeriesRenderers;
              if (chart.onPointTapped != null) {
                _calculatePointSeriesIndex(chart, position);
              }
              if (chart.onAxisLabelTapped != null) {
                _triggerAxisLabelEvent(position);
              }
              if (chart.onDataLabelTapped != null) {
                _triggerDataLabelEvent(chart, visibleSeriesRenderer, position);
              }
            },
            onDoubleTap: () {
              _performDoubleTap();
            },
            onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
              _performLongPressMoveUpdate(details);
            },
            onLongPress: () {
              _performLongPress();
            },
            onLongPressEnd: (LongPressEndDetails details) {
              _performLongPressEnd();
            },
            // onPanUpdate: (DragUpdateDetails details) {
            //   _performPanUpdate(details);
            // },
            // onPanEnd: (DragEndDetails details) {
            //   _performPanEnd(details);
            // },
            // onPanDown: (DragDownDetails details) {
            //   _performPanDown(details);
            // },
            onVerticalDragUpdate: isUserInteractionEnabled
                ? (DragUpdateDetails details) {
                    _performPanUpdate(details);
                  }
                : null,
            onVerticalDragEnd: isUserInteractionEnabled
                ? (DragEndDetails details) {
                    _performPanEnd(details);
                  }
                : null,
            onVerticalDragDown: isUserInteractionEnabled
                ? (DragDownDetails details) {
                    _performPanDown(details);
                  }
                : null,
            onHorizontalDragUpdate: isUserInteractionEnabled
                ? (DragUpdateDetails details) {
                    _performPanUpdate(details);
                  }
                : null,
            onHorizontalDragEnd: isUserInteractionEnabled
                ? (DragEndDetails details) {
                    _performPanEnd(details);
                  }
                : null,
            onHorizontalDragDown: isUserInteractionEnabled
                ? (DragDownDetails details) {
                    _performPanDown(details);
                  }
                : null,
            child: Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                decoration: const BoxDecoration(color: Colors.transparent))));
  }

  /// Find point index for selection
  void _calculatePointSeriesIndex(SfCartesianChart chart, Offset position) {
    for (int i = 0;
        i < _chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final CartesianSeriesRenderer seriesRenderer =
          _chartState._chartSeries.visibleSeriesRenderers[i];
      final String _seriesType = seriesRenderer._seriesType;
      num pointIndex;
      int count = 0;
      final double padding = (_seriesType == 'bubble') ||
              (_seriesType == 'scatter') ||
              (_seriesType == 'bar') ||
              (_seriesType == 'column' ||
                  _seriesType == 'rangecolumn' ||
                  _seriesType.contains('stackedcolumn') ||
                  _seriesType.contains('stackedbar') ||
                  _seriesType == 'waterfall')
          ? 0
          : 15;

      /// regional padding to detect smooth touch
      seriesRenderer._regionalData
          .forEach((dynamic regionRect, dynamic values) {
        final Rect region = regionRect[0];
        final double left = region.left - padding;
        final double right = region.right + padding;
        final double top = region.top - padding;
        final double bottom = region.bottom + padding;
        final Rect paddedRegion = Rect.fromLTRB(left, top, right, bottom);
        if (paddedRegion.contains(position)) {
          pointIndex = count;
        }
        count++;
      });

      if (pointIndex != null) {
        PointTapArgs pointTapArgs;
        pointTapArgs = PointTapArgs(i, pointIndex, seriesRenderer._dataPoints);
        chart.onPointTapped(pointTapArgs);
      }
    }
  }

  /// Triggering onAxisLabelTapped event
  void _triggerAxisLabelEvent(Offset position) {
    for (int i = 0;
        i < _chartState._chartAxis._axisRenderersCollection.length;
        i++) {
      final List<AxisLabel> labels =
          _chartState._chartAxis._axisRenderersCollection[i]._visibleLabels;
      for (int k = 0; k < labels.length; k++) {
        if (_chartState
                ._chartAxis._axisRenderersCollection[i]._axis.isVisible &&
            labels[k]._labelRegion.contains(position)) {
          AxisLabelTapArgs labelArgs;
          labelArgs = AxisLabelTapArgs(
              _chartState._chartAxis._axisRenderersCollection[i]._axis,
              _chartState._chartAxis._axisRenderersCollection[i]._name);
          labelArgs.text = labels[k].text;
          labelArgs.value = labels[k].value;
          chart.onAxisLabelTapped(labelArgs);
        }
      }
    }
  }

  /// Getter method of the series painter
  CustomPainter _getSeriesPainter(int value, AnimationController controller,
      CartesianSeriesRenderer seriesRenderer) {
    CustomPainter customPainter;
    final _PainterKey painterKey = _PainterKey(
        index: value, name: 'series $value', isRenderCompleted: false);
    _chartState._painterKeys.add(painterKey);
    switch (seriesRenderer._seriesType) {
      case 'line':
        customPainter = _LineChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            painterKey: painterKey,
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'spline':
        customPainter = _SplineChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'column':
        customPainter = _ColumnChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : true,
            painterKey: painterKey,
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;

      case 'scatter':
        customPainter = _ScatterChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            painterKey: painterKey,
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'stepline':
        customPainter = _StepLineChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'area':
        customPainter = _AreaChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            painterKey: painterKey,
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'bubble':
        customPainter = _BubbleChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            painterKey: painterKey,
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'bar':
        customPainter = _BarChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : true,
            painterKey: painterKey,
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'fastline':
        customPainter = _FastLineChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            painterKey: painterKey,
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'rangecolumn':
        customPainter = _RangeColumnChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'rangearea':
        customPainter = _RangeAreaChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'steparea':
        customPainter = _StepAreaChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'splinearea':
        customPainter = _SplineAreaChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'splinerangearea':
        customPainter = _SplineRangeAreaChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'stackedarea':
        customPainter = _StackedAreaChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'stackedbar':
        customPainter = _StackedBarChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'stackedcolumn':
        customPainter = _StackedColummnChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'stackedline':
        customPainter = _StackedLineChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'stackedarea100':
        customPainter = _StackedArea100ChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'stackedbar100':
        customPainter = _StackedBar100ChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'stackedcolumn100':
        customPainter = _StackedColumn100ChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'stackedline100':
        customPainter = _StackedLine100ChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'hilo':
        customPainter = _HiloPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;

      case 'hiloopenclose':
        customPainter = _HiloOpenClosePainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'candle':
        customPainter = _CandlePainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'histogram':
        customPainter = _HistogramChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'boxandwhisker':
        customPainter = _BoxAndWhiskerPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
        break;
      case 'waterfall':
        customPainter = _WaterfallChartPainter(
            chartState: _chartState,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: _chartState._zoomedState != null
                ? _chartState._zoomedAxisRendererStates.isNotEmpty
                : (_chartState._legendToggling
                    ? true
                    : seriesRenderer._needsRepaint),
            animationController: controller,
            notifier: seriesRenderer._repaintNotifier);
    }
    return customPainter;
  }
}
