import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'axis/axis.dart';
import 'axis/numeric_axis.dart';
import 'base.dart';
import 'behaviors/crosshair.dart';
import 'behaviors/trackball.dart';
import 'behaviors/zooming.dart';
import 'common/annotation.dart';
import 'common/callbacks.dart';
import 'common/chart_point.dart';
import 'common/core_legend.dart' as core;
import 'common/core_tooltip.dart';
import 'common/legend.dart';
import 'common/title.dart';
import 'indicators/technical_indicator.dart';
import 'interactions/behavior.dart';
import 'interactions/tooltip.dart';
import 'series/chart_series.dart';
import 'theme.dart';
import 'utils/constants.dart';
import 'utils/enum.dart';
import 'utils/helper.dart';
import 'utils/typedef.dart';

/// Renders the Cartesian type charts.
///
/// Cartesian charts are generally charts with horizontal and vertical axes.
/// [SfCartesianChart] provides options to customize
/// chart types using the `series` property.
///
/// ```dart
/// late TooltipBehavior _tooltipBehavior;
///
/// @override
/// void initState() {
///   _tooltipBehavior = TooltipBehavior(enable: true);
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return Center(
///       child: SfCartesianChart(
///     title: ChartTitle(text: 'Flutter Chart'),
///     legend: Legend(isVisible: true),
///     series: getDefaultData(),
///     tooltipBehavior: _tooltipBehavior,
///   ));
/// }
///
/// static List<LineSeries<SalesData, num>> getDefaultData() {
///   final bool isDataLabelVisible = true,
///       isMarkerVisible = true,
///       isTooltipVisible = true;
///   double? lineWidth, markerWidth, markerHeight;
///   final List<SalesData> chartData = <SalesData>[
///     SalesData(DateTime(2005, 0, 1), 'India', 1.5, 21, 28, 680, 760),
///     SalesData(DateTime(2006, 0, 1), 'China', 2.2, 24, 44, 550, 880),
///     SalesData(DateTime(2007, 0, 1), 'USA', 3.32, 36, 48, 440, 788),
///     SalesData(DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560),
///     SalesData(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566),
///     SalesData(DateTime(2010, 0, 1), 'France', 6.8, 57, 78, 780, 650),
///     SalesData(DateTime(2011, 0, 1), 'Germany', 8.5, 70, 84, 450, 800)
///   ];
///   return <LineSeries<SalesData, num>>[
///     LineSeries<SalesData, num>(
///         enableTooltip: true,
///         dataSource: chartData,
///         xValueMapper: (SalesData sales, _) => sales.y,
///         yValueMapper: (SalesData sales, _) => sales.y4,
///         width: lineWidth ?? 2,
///         markerSettings: MarkerSettings(
///             isVisible: isMarkerVisible,
///             height: markerWidth ?? 4,
///             width: markerHeight ?? 4,
///             shape: DataMarkerType.circle,
///             borderWidth: 3,
///             borderColor: Colors.red),
///         dataLabelSettings: DataLabelSettings(
///             isVisible: isDataLabelVisible,
///             labelAlignment: ChartDataLabelAlignment.auto)),
///     LineSeries<SalesData, num>(
///         enableTooltip: isTooltipVisible,
///         dataSource: chartData,
///         width: lineWidth ?? 2,
///         xValueMapper: (SalesData sales, _) => sales.y,
///         yValueMapper: (SalesData sales, _) => sales.y3,
///         markerSettings: MarkerSettings(
///             isVisible: isMarkerVisible,
///             height: markerWidth ?? 4,
///             width: markerHeight ?? 4,
///             shape: DataMarkerType.circle,
///             borderWidth: 3,
///             borderColor: Colors.black),
///         dataLabelSettings: DataLabelSettings(
///             isVisible: isDataLabelVisible,
///             labelAlignment: ChartDataLabelAlignment.auto))
///   ];
/// }
/// ```
class SfCartesianChart extends StatefulWidget {
  /// Creating an argument constructor of [SfCartesianChart] class.
  const SfCartesianChart({
    Key? key,
    this.backgroundColor,
    this.enableSideBySideSeriesPlacement = true,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.plotAreaBackgroundColor,
    this.plotAreaBorderColor,
    this.plotAreaBorderWidth = 0.7,
    this.plotAreaBackgroundImage,
    this.onTooltipRender,
    this.onActualRangeChanged,
    this.onDataLabelRender,
    this.onLegendItemRender,
    this.onTrackballPositionChanging,
    this.onCrosshairPositionChanging,
    this.onZooming,
    this.onZoomStart,
    this.onZoomEnd,
    this.onZoomReset,
    this.onAxisLabelTapped,
    this.onDataLabelTapped,
    this.onLegendTapped,
    this.onSelectionChanged,
    this.onChartTouchInteractionUp,
    this.onChartTouchInteractionDown,
    this.onChartTouchInteractionMove,
    this.onMarkerRender,
    this.isTransposed = false,
    this.enableAxisAnimation = false,
    this.annotations,
    this.loadMoreIndicatorBuilder,
    this.onPlotAreaSwipe,
    this.palette,
    this.primaryXAxis = const NumericAxis(),
    this.primaryYAxis = const NumericAxis(),
    this.margin = const EdgeInsets.all(10),
    this.tooltipBehavior,
    this.zoomPanBehavior,
    this.legend = const Legend(),
    this.selectionType = SelectionType.point,
    this.selectionGesture = ActivationMode.singleTap,
    this.enableMultiSelection = false,
    this.crosshairBehavior,
    this.trackballBehavior,
    this.series = const <CartesianSeries>[],
    this.title = const ChartTitle(),
    this.axes = const <ChartAxis>[],
    this.indicators = const <TechnicalIndicator>[],
  }) : super(key: key);

  /// Customizes the chart title.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            title: ChartTitle(
  ///                    text: 'Area with animation',
  ///                    alignment: ChartAlignment.center,
  ///                    backgroundColor: Colors.white,
  ///                    borderColor: Colors.transparent,
  ///                    borderWidth: 0)
  ///        )
  ///    );
  /// }
  /// ```
  final ChartTitle title;

  /// Customizes the legend in the chart.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(isVisible: true),
  ///        )
  ///    );
  /// }
  /// ```
  final Legend legend;

  /// Background color of the chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            backgroundColor: Colors.blue
  ///        )
  ///    );
  /// }
  /// ```
  final Color? backgroundColor;

  /// Color of the chart border.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            borderColor: Colors.red
  ///        )
  ///   );
  /// }
  /// ```
  final Color borderColor;

  /// Width of the chart border.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            borderWidth: 2
  ///        )
  ///     );
  /// }
  /// ```
  final double borderWidth;

  /// Background color of the plot area.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBackgroundColor: Colors.red,
  ///        )
  ///    );
  /// }
  /// ```
  final Color? plotAreaBackgroundColor;

  /// Border color of the plot area.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBorderColor: Colors.red,
  ///        )
  ///    );
  /// }
  /// ```
  final Color? plotAreaBorderColor;

  /// Border width of the plot area.
  ///
  /// Defaults to `0.7`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBorderColor: Colors.red,
  ///            plotAreaBorderWidth: 2
  ///        )
  ///    );
  /// }
  /// ```
  final double plotAreaBorderWidth;

  /// Customizes the primary x-axis in chart.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: DateTimeAxis(interval: 1)
  ///        )
  ///    );
  /// }
  /// ```
  final ChartAxis primaryXAxis;

  /// Customizes the primary y-axis in chart.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryYAxis: NumericAxis(isInversed: false)
  ///        )
  ///    );
  /// }
  /// ```
  final ChartAxis primaryYAxis;

  /// Margin for chart.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            margin: const EdgeInsets.all(2),
  ///            borderColor: Colors.blue
  ///        )
  ///    );
  /// }
  /// ```
  final EdgeInsets margin;

  /// Customizes the additional axes in the chart.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  /// return Container(
  ///   child: SfCartesianChart(axes: <ChartAxis>[
  ///     NumericAxis(majorGridLines: MajorGridLines(color: Colors.transparent))
  ///  ]));
  /// }
  /// ```
  final List<ChartAxis> axes;

  /// Enables or disables the placing of series side by side.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           enableSideBySideSeriesPlacement: false
  ///        )
  ///    );
  /// }
  /// ```
  final bool enableSideBySideSeriesPlacement;

  /// Occurs while tooltip is rendered. You can customize the position
  /// and header. Here, you can get the text, header, point index, series,
  /// x and y-positions.
  ///
  /// ```dart
  /// TooltipBehavior _tooltipBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _tooltipBehavior = TooltipBehavior( enable: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             tooltipBehavior: _tooltipBehavior,
  ///             onTooltipRender: (TooltipArgs args) => tool(args)
  ///         )
  ///     );
  /// }
  ///
  /// void tool(TooltipArgs args) {
  ///    args.locationX = 30;
  /// }
  /// ```
  final ChartTooltipCallback? onTooltipRender;

  /// Occurs when the visible range of an axis is changed, i.e. value changes
  /// for minimum, maximum, and interval. Here, you can get the actual and
  /// visible range of an axis.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///         onActualRangeChanged: (ActualRangeChangedArgs args) => range(args)
  ///        )
  ///    );
  /// }
  ///
  /// void range(ActualRangeChangedArgs args) {
  ///   print(args.visibleMin);
  /// }
  /// ```
  final ChartActualRangeChangedCallback? onActualRangeChanged;

  /// Occurs when tapping the axis label. Here, you can get the appropriate axis
  /// that is tapped and the axis label text.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///          onDataLabelRender: (DataLabelRenderArgs args) => dataLabel(args),
  ///          series: <CartesianSeries<ChartData, String>>[
  ///         ColumnSeries<ChartData, String>(
  ///           dataLabelSettings: DataLabelSettings(isVisible: true),
  ///         ),
  ///       ],
  ///     )
  ///   );
  /// }
  ///
  /// void dataLabel(DataLabelRenderArgs args) {
  ///   args.text = 'data Label';
  /// }
  /// ```
  final ChartDataLabelRenderCallback? onDataLabelRender;

  /// Occurs when the legend item is rendered. Here, you can get the legend’s
  /// text, shape, series index, and point index of circular series.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRenderArgs args) => legend(args)
  ///        )
  ///    );
  /// }
  /// void legend(LegendRenderArgs args) {
  ///   args.seriesIndex = 2;
  /// }
  /// ```
  final ChartLegendRenderCallback? onLegendItemRender;

  /// Occurs while the trackball position is changed. Here, you can customize
  /// the text of the trackball.
  ///
  /// ```dart
  /// late TrackballBehavior _trackballBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _trackballBehavior = TrackballBehavior( enable: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             trackballBehavior: _trackballBehavior,
  ///       onTrackballPositionChanging: (TrackballArgs args) => trackball(args)
  ///         )
  ///     );
  /// }
  /// void trackball(TrackballArgs args) {
  ///     args.chartPointInfo = ChartPointInfo();
  /// }
  /// ```
  final ChartTrackballCallback? onTrackballPositionChanging;

  /// Occurs when tapping the axis label. Here, you can get the appropriate axis
  /// that is tapped and the axis label text.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(enable: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             crosshairBehavior: _crosshairBehavior,
  /// onCrosshairPositionChanging: (CrosshairRenderArgs args) => crosshair(args)
  ///         )
  ///     );
  /// }
  /// void crosshair(CrosshairRenderArgs args) {
  ///     args.text = 'crosshair';
  /// }
  /// ```
  final ChartCrosshairCallback? onCrosshairPositionChanging;

  /// Occurs when zooming action begins. You can customize the zoom factor and
  /// zoom position of an axis. Here, you can get the axis, current zoom factor,
  /// current zoom position, previous zoom factor, and previous zoom position.
  ///
  /// ```dart
  /// late ZoomPanBehavior _zoomPanBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _zoomPanBehavior = ZoomPanBehavior(enableSelectionZooming: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             onZoomStart: (ZoomPanArgs args) => zoom(args),
  ///         )
  ///     );
  /// }
  /// void zoom(ZoomPanArgs args) {
  ///     args.currentZoomFactor = 0.2;
  /// }
  /// ```
  final ChartZoomingCallback? onZoomStart;

  /// Occurs when the zooming action is completed. Here, you can get the axis,
  /// current zoom factor, current zoom position, previous zoom factor, and
  /// previous zoom position.
  ///
  /// ```dart
  /// late ZoomPanBehavior _zoomPanBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _zoomPanBehavior = ZoomPanBehavior(enableSelectionZooming: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             onZoomEnd: (ZoomPanArgs args) => zoom(args),
  ///         )
  ///     );
  /// }
  /// void zoom(ZoomPanArgs args) {
  ///     print(args.currentZoomPosition);
  /// }
  /// ```
  final ChartZoomingCallback? onZoomEnd;

  /// Occurs when zoomed state is reset. Here, you can get the axis,
  /// current zoom factor, current zoom position, previous zoom factor,
  /// and previous zoom position.
  ///
  /// ```dart
  /// late ZoomPanBehavior _zoomPanBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _zoomPanBehavior = ZoomPanBehavior(enableSelectionZooming: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             onZoomReset: (ZoomPanArgs args) => zoom(args),
  ///         )
  ///     );
  /// }
  /// void zoom(ZoomPanArgs args) {
  ///     print(args.currentZoomPosition);
  /// }
  /// ```
  final ChartZoomingCallback? onZoomReset;

  /// Occurs when Zooming event is performed. Here, you can get the axis,
  /// current zoom factor, current zoom position, previous zoom factor,
  /// and previous zoom position.
  ///
  /// ```dart
  /// late ZoomPanBehavior _zoomPanBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _zoomPanBehavior = ZoomPanBehavior(enableSelectionZooming: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             onZooming: (ZoomPanArgs args) => zoom(args),
  ///         )
  ///     );
  /// }
  /// void zoom(ZoomPanArgs args) {
  ///     print(args.currentZoomPosition);
  /// }
  /// ```
  final ChartZoomingCallback? onZooming;

  /// Called when the data label is tapped.
  ///
  /// Whenever the data label is tapped, `onDataLabelTapped` callback will be
  /// called. Provides options to get the position of the data label, series
  /// index, point index and its text.
  ///
  /// _Note:_  This callback will not be called, when the builder is specified
  /// for data label (data label template). For this case, custom widget
  /// specified in the `DataLabelSettings.builder` property can be wrapped
  /// using the `GestureDetector` and this functionality can be achieved
  /// in the application level.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onDataLabelTapped: (DataLabelTapDetails args) {
  ///                 print(arg.seriesIndex);
  ///                  }
  ///        )
  ///    );
  /// }
  /// ```
  final DataLabelTapCallback? onDataLabelTapped;

  /// Occurs when tapping the axis label. Here, you can get the appropriate
  /// axis that is tapped and the axis label text.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onAxisLabelTapped: (AxisLabelTapArgs args) => axis(args),
  ///        )
  ///    );
  /// }
  ///
  /// void axis(AxisLabelTapArgs args) {
  ///   print(args.text);
  /// }
  /// ```
  final ChartAxisLabelTapCallback? onAxisLabelTapped;

  /// Occurs when the legend item is rendered. Here, you can get the legend’s
  /// text, shape, series index, and point index of circular series.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onLegendTapped: (LegendTapArgs args) => legend(args),
  ///        )
  ///    );
  /// }
  ///
  /// void legend(LegendTapArgs args) {
  ///   print(args.pointIndex);
  /// }
  /// ```
  final ChartLegendTapCallback? onLegendTapped;

  /// Occurs while selection changes. Here, you can get the series,
  /// selected color, unselected color, selected border color,
  /// unselected border color, selected border width, unselected border width,
  /// series index, and point index.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///     onSelectionChanged: (SelectionArgs args) => print(args.selectedColor),
  ///        )
  ///    );
  /// }
  final ChartSelectionCallback? onSelectionChanged;

  /// Occurs when tapped on the chart area.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  /// }
  /// ```
  final ChartTouchInteractionCallback? onChartTouchInteractionUp;

  /// Occurs when touched on the chart area.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onChartTouchInteractionDown: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  /// }
  /// ```
  final ChartTouchInteractionCallback? onChartTouchInteractionDown;

  /// Occurs when touched and moved on the chart area.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onChartTouchInteractionMove: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///     );
  /// }
  /// ```
  final ChartTouchInteractionCallback? onChartTouchInteractionMove;

  /// Occurs when the marker is rendered. Here, you can get the marker
  /// pointIndex shape, height and width of data markers.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Container(child: SfCartesianChart(
  ///    onMarkerRender: (MarkerRenderArgs args) {
  ///      if (args.pointIndex == 2) {
  ///        args.markerHeight = 20.0;
  ///        args.markerWidth = 20.0;
  ///        args.shape = DataMarkerType.triangle;
  ///      }
  ///    },
  ///  ));
  /// }
  /// ```
  final ChartMarkerRenderCallback? onMarkerRender;

  /// Customizes the tooltip in chart.
  ///
  /// ```dart
  /// late TooltipBehavior _tooltipBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _tooltipBehavior = TooltipBehavior(enable: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             tooltipBehavior: _tooltipBehavior
  ///           )
  ///      );
  /// }
  /// ```
  final TooltipBehavior? tooltipBehavior;

  /// Customizes the crosshair in chart.
  ///
  /// ```dart
  /// late CrosshairBehavior _crosshairBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _crosshairBehavior = CrosshairBehavior(enable: true);
  ///   super.initState();
  ///  }
  ///
  ///  Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             crosshairBehavior: _crosshairBehavior,
  ///          )
  ///      );
  /// }
  /// ```
  final CrosshairBehavior? crosshairBehavior;

  /// Customizes the trackball in chart.
  ///
  /// ```dart
  /// late TrackballBehavior _trackballBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _trackballBehavior = TrackballBehavior(enable: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             trackballBehavior: _trackballBehavior,
  ///           )
  ///      );
  /// }
  /// ```
  final TrackballBehavior? trackballBehavior;

  /// Customizes the zooming and panning settings.
  ///
  /// ```dart
  /// late ZoomPanBehavior _zoomPanBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _zoomPanBehavior = ZoomPanBehavior( enablePanning: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             zoomPanBehavior: _zoomPanBehavior
  ///           )
  ///      );
  /// }
  /// ```
  final ZoomPanBehavior? zoomPanBehavior;

  /// Mode of selecting the data points or series.
  ///
  /// Defaults to `SelectionType.point`.
  ///
  /// Also refer [SelectionType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionType: SelectionType.series,
  ///         )
  ///     );
  /// }
  /// ```
  final SelectionType selectionType;

  /// Customizes the annotations. Annotations are used to mark the specific area
  /// of interest in the plot area with texts, shapes, or images.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    widget: Container(
  ///                    child: const Text('Annotation')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chart,
  ///                    x: 3,
  ///                    y: 60
  ///                 ),
  ///             ],
  ///          )
  ///     );
  /// }
  /// ```
  final List<CartesianChartAnnotation>? annotations;

  /// Enables or disables the multiple data points or series selection.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late SelectionBehavior _selectionBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _selectionBehavior = SelectionBehavior( enable: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             enableMultiSelection: true,
  ///             series: <BarSeries<SalesData, num>>[
  ///                 BarSeries<SalesData, num>(
  ///                   selectionBehavior: _selectionBehavior
  ///                 ),
  ///               ],
  ///           )
  ///      );
  /// }
  /// ```
  final bool enableMultiSelection;

  /// Gesture for activating the selection. Selection can be activated in tap,
  /// double tap, and long press.
  ///
  /// Defaults to `ActivationMode.tap`.
  ///
  /// Also refer [ActivationMode].
  ///
  /// ```dart
  /// late SelectionBehavior _selectionBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _selectionBehavior = SelectionBehavior( enable: true);
  ///   super.initState();
  ///  }
  ///
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             selectionGesture: ActivationMode.doubleTap,
  ///             series: <BarSeries<SalesData, num>>[
  ///                 BarSeries<SalesData, num>(
  ///                   selectionBehavior: _selectionBehavior
  ///                 ),
  ///               ],
  ///           )
  ///      );
  /// }
  /// ```
  final ActivationMode selectionGesture;

  /// Background image for chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             plotAreaBackgroundImage: const AssetImage('images/bike.png'),
  ///          )
  ///      );
  /// }
  /// ```
  final ImageProvider? plotAreaBackgroundImage;

  /// By setting this, the orientation of x-axis is set to vertical and
  /// orientation of y-axis is set to horizontal.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             isTransposed: true,
  ///           )
  ///      );
  /// }
  /// ```
  final bool isTransposed;

  /// Axis elements animation on visible range change.
  ///
  /// Axis elements like grid lines, tick lines and labels will be animated when
  /// the axis range is changed dynamically. Axis visible range will be changed
  /// while zooming, panning or while updating the data points.
  ///
  /// The elements will be animated on setting `true` to this property and this
  /// is applicable for all primary and secondary axis in the chart.
  ///
  /// Defaults to `false`.
  ///
  /// See also [ChartSeries.animationDuration] for changing the series
  /// animation duration.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             enableAxisAnimation: true,
  ///           )
  ///      );
  /// }
  /// ```
  final bool enableAxisAnimation;

  /// Customizes the series in chart.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///            series: <CartesianSeries<SalesData, num>>[
  ///                 AreaSeries<SalesData, num>(
  ///                     dataSource: chartData,
  ///                 ),
  ///               ],
  ///           )
  ///      );
  /// }
  /// ```
  final List<CartesianSeries> series;

  /// Color palette for chart series. If the series color is not specified,
  /// then the series will be rendered with appropriate palette color.
  /// Ten colors are available by default.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///     return Container(
  ///         child: SfCartesianChart(
  ///             palette: <Color>[Colors.red, Colors.green]
  ///           )
  ///      );
  /// }
  /// ```
  final List<Color>? palette;

  /// Technical indicators for charts.
  final List<TechnicalIndicator> indicators;

  /// A builder that builds the widget (ex., loading indicator or load more
  /// button) to display at the top of the chart area when horizontal scrolling
  /// reaches the start or end of the chart.
  ///
  /// This can be used to achieve the features like load more and infinite
  /// scrolling in the chart. Also provides the swiping direction value
  /// to the user.
  ///
  /// If the chart is transposed, this will be called when the vertical
  /// scrolling reaches the top or bottom of the chart.
  ///
  /// ## Infinite scrolling
  ///
  /// The below example demonstrates the infinite scrolling by showing
  /// the circular progress indicator until the data is loaded when horizontal
  /// scrolling reaches the end of the chart.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           loadMoreIndicatorBuilder:
  ///             (BuildContext context, ChartSwipeDirection direction) =>
  ///                 getLoadMoreViewBuilder(context, direction),
  ///           series: <CartesianSeries<SalesData, num>>[
  ///                AreaSeries<SalesData, num>(
  ///                    dataSource: chartData,
  ///                ),
  ///              ],
  ///          )
  ///     );
  /// }
  /// Widget getLoadMoreViewBuilder(
  ///      BuildContext context, ChartSwipeDirection direction) {
  ///     if (direction == ChartSwipeDirection.end) {
  ///       return FutureBuilder<String>(
  ///         future: _updateData(), /// Adding data by updateDataSource method
  ///         builder:
  ///          (BuildContext futureContext, AsyncSnapshot<String> snapShot) {
  ///           return snapShot.connectionState != ConnectionState.done
  ///               ? const CircularProgressIndicator()
  ///               : SizedBox.fromSize(size: Size.zero);
  ///         },
  ///     );
  ///     } else {
  ///       return SizedBox.fromSize(size: Size.zero);
  ///     }
  /// }
  /// ```
  ///
  /// ## Load more
  ///
  /// The below example demonstrates how to show a button when horizontal
  /// scrolling reaches the end of the chart.
  /// On tapping the button circular indicator will be displayed and data will
  /// be loaded to the chart.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           loadMoreIndicatorBuilder:
  ///             (BuildContext context, ChartSwipeDirection direction) =>
  ///                 _buildLoadMoreView(context, direction),
  ///           series: <CartesianSeries<SalesData, num>>[
  ///                LineSeries<SalesData, num>(
  ///                    dataSource: chartData,
  ///                ),
  ///              ],
  ///         )
  ///     );
  /// }
  /// Widget _buildLoadMoreView(
  ///       BuildContext context, ChartSwipeDirection direction) {
  ///     _visible = true;
  /// if (direction == ChartSwipeDirection.end) {
  ///     return StatefulBuilder(
  ///         builder: (BuildContext context, StateSetter stateSetter) {
  ///       return Visibility(
  ///         visible: _visible,
  ///         child: RaisedButton(
  ///             child: const Text('Load More'),
  ///             onPressed: () async{
  ///               stateSetter(() {
  ///                   _visible = false;
  ///               });
  ///               await loadMore();
  ///             }),
  ///       );
  ///     });
  ///  } else {
  ///     return null;
  ///  }
  /// }
  /// FutureBuilder<String> loadMore() {
  ///       return FutureBuilder<String>(
  ///         future: _updateData(), /// Adding data by updateDataSource method
  ///         builder:
  ///          (BuildContext futureContext, AsyncSnapshot<String> snapShot) {
  ///           return snapShot.connectionState != ConnectionState.done
  ///               ? const CircularProgressIndicator()
  ///               : SizedBox.fromSize(size: Size.zero);
  ///         },
  ///     );
  /// }
  /// ```
  final LoadMoreViewBuilderCallback? loadMoreIndicatorBuilder;

  /// Called while swiping on the plot area.
  ///
  /// Whenever the swiping happens on the plot area (the series rendering area),
  /// `onPlotAreaSwipe` callback will be called. It provides options to get the
  /// direction of swiping.
  ///
  /// If the chart is swiped from left to right direction, the direction is
  /// `ChartSwipeDirection.start` and if the swipe happens from right to left
  /// direction, the direction is `ChartSwipeDirection.end`.
  ///
  /// Using this callback, the user able to achieve pagination functionality
  /// (on swiping over chart area, next set of data points can be
  /// loaded to the chart).
  ///
  /// Also refer [ChartSwipeDirection].
  ///
  /// ```dart
  /// ChartSeriesController? seriesController;
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           onPlotAreaSwipe:
  ///             (ChartSwipeDirection direction) =>
  ///                 performSwipe(direction),
  ///           series: <CartesianSeries<SalesData, num>>[
  ///                AreaSeries<SalesData, num>(
  ///                    dataSource: chartData,
  ///                ),
  ///              ],
  ///          )
  ///     );
  /// }
  /// Widget performSwipe(ChartSwipeDirection direction) {
  ///     if (direction == ChartSwipeDirection.end) {
  ///         chartData.add(ChartSampleData(
  ///             x: chartData[chartData.length - 1].x + 1,
  ///             y: 10));
  ///   seriesController.updateDataSource(addedDataIndex: chartData.length - 1);
  ///     }
  /// }
  /// ```
  final ChartPlotAreaSwipeCallback? onPlotAreaSwipe;

  @override
  State<StatefulWidget> createState() => SfCartesianChartState();
}

class SfCartesianChartState extends State<SfCartesianChart>
    with TickerProviderStateMixin {
  final List<core.LegendItem> _legendItems = <core.LegendItem>[];

  late GlobalKey? _legendKey;
  late GlobalKey? _tooltipKey;
  late GlobalKey _trackballBuilderKey;
  late SfChartThemeData _chartThemeData;
  late ThemeData _themeData;
  List<Widget>? _annotations;
  ChartSwipeDirection? _swipeDirection;
  SfLocalizations? _localizations;
  Widget? _trackballBuilder;

  SfChartThemeData _updateThemeData(
      BuildContext context, ChartThemeData effectiveChartThemeData) {
    SfChartThemeData chartThemeData = SfChartTheme.of(context);
    chartThemeData = chartThemeData.copyWith(
      axisLineColor:
          chartThemeData.axisLineColor ?? effectiveChartThemeData.axisLineColor,
      axisLabelColor: chartThemeData.axisLabelColor ??
          effectiveChartThemeData.axisLabelColor,
      axisTitleColor: chartThemeData.axisTitleColor ??
          effectiveChartThemeData.axisTitleColor,
      titleTextColor: chartThemeData.titleTextColor ??
          effectiveChartThemeData.titleTextColor,
      crosshairBackgroundColor: chartThemeData.crosshairBackgroundColor ??
          effectiveChartThemeData.crosshairBackgroundColor,
      crosshairLabelColor: chartThemeData.crosshairLabelColor ??
          effectiveChartThemeData.crosshairLabelColor,
      legendTextColor: chartThemeData.legendTextColor ??
          effectiveChartThemeData.legendTextColor,
      legendTitleColor: chartThemeData.legendTitleColor ??
          effectiveChartThemeData.legendTitleColor,
      majorGridLineColor: chartThemeData.majorGridLineColor ??
          effectiveChartThemeData.majorGridLineColor,
      minorGridLineColor: chartThemeData.minorGridLineColor ??
          effectiveChartThemeData.minorGridLineColor,
      majorTickLineColor: chartThemeData.majorTickLineColor ??
          effectiveChartThemeData.majorTickLineColor,
      minorTickLineColor: chartThemeData.minorTickLineColor ??
          effectiveChartThemeData.minorTickLineColor,
      selectionRectColor: chartThemeData.selectionRectColor ??
          effectiveChartThemeData.selectionRectColor,
      selectionRectBorderColor: chartThemeData.selectionRectBorderColor ??
          effectiveChartThemeData.selectionRectBorderColor,
      selectionTooltipConnectorLineColor:
          chartThemeData.selectionTooltipConnectorLineColor ??
              effectiveChartThemeData.selectionTooltipConnectorLineColor,
      waterfallConnectorLineColor: chartThemeData.waterfallConnectorLineColor ??
          effectiveChartThemeData.waterfallConnectorLineColor,
      tooltipLabelColor: chartThemeData.tooltipLabelColor ??
          effectiveChartThemeData.tooltipLabelColor,
      tooltipSeparatorColor: chartThemeData.tooltipSeparatorColor ??
          effectiveChartThemeData.tooltipSeparatorColor,
      backgroundColor: widget.backgroundColor ??
          chartThemeData.backgroundColor ??
          effectiveChartThemeData.backgroundColor,
      titleBackgroundColor: widget.title.backgroundColor ??
          chartThemeData.titleBackgroundColor ??
          effectiveChartThemeData.titleBackgroundColor,
      plotAreaBackgroundColor: widget.plotAreaBackgroundColor ??
          chartThemeData.plotAreaBackgroundColor ??
          effectiveChartThemeData.plotAreaBackgroundColor,
      plotAreaBorderColor: widget.plotAreaBorderColor ??
          chartThemeData.plotAreaBorderColor ??
          effectiveChartThemeData.plotAreaBorderColor,
      legendBackgroundColor: widget.legend.backgroundColor ??
          chartThemeData.legendBackgroundColor ??
          effectiveChartThemeData.legendBackgroundColor,
      crosshairLineColor: widget.crosshairBehavior?.lineColor ??
          chartThemeData.crosshairLineColor ??
          effectiveChartThemeData.crosshairLineColor,
      tooltipColor: widget.tooltipBehavior?.color ??
          chartThemeData.tooltipColor ??
          effectiveChartThemeData.tooltipColor,
      titleTextStyle: effectiveChartThemeData.titleTextStyle!
          .copyWith(
              color: chartThemeData.titleTextColor ??
                  effectiveChartThemeData.titleTextColor)
          .merge(chartThemeData.titleTextStyle)
          .merge(widget.title.textStyle),
      axisTitleTextStyle: effectiveChartThemeData.axisTitleTextStyle!
          .copyWith(
              color: chartThemeData.axisTitleColor ??
                  effectiveChartThemeData.axisTitleColor)
          .merge(chartThemeData.axisTitleTextStyle),
      axisLabelTextStyle: effectiveChartThemeData.axisLabelTextStyle!
          .copyWith(
              color: chartThemeData.axisLabelColor ??
                  effectiveChartThemeData.axisLabelColor)
          .merge(chartThemeData.axisLabelTextStyle),
      axisMultiLevelLabelTextStyle: effectiveChartThemeData
          .axisMultiLevelLabelTextStyle!
          .copyWith(
              color: chartThemeData.axisLabelColor ??
                  effectiveChartThemeData.axisLabelColor)
          .merge(chartThemeData.axisMultiLevelLabelTextStyle),
      plotBandLabelTextStyle: effectiveChartThemeData.plotBandLabelTextStyle!
          .merge(chartThemeData.plotBandLabelTextStyle),
      legendTitleTextStyle: effectiveChartThemeData.legendTitleTextStyle!
          .copyWith(
              color: chartThemeData.legendTitleColor ??
                  effectiveChartThemeData.legendTitleColor)
          .merge(chartThemeData.legendTitleTextStyle)
          .merge(widget.legend.title?.textStyle),
      legendTextStyle: effectiveChartThemeData.legendTextStyle!
          .copyWith(
              color: chartThemeData.legendTextColor ??
                  effectiveChartThemeData.legendTextColor)
          .merge(chartThemeData.legendTextStyle)
          .merge(widget.legend.textStyle),
      tooltipTextStyle: effectiveChartThemeData.tooltipTextStyle!
          .copyWith(
              color: chartThemeData.tooltipLabelColor ??
                  effectiveChartThemeData.tooltipLabelColor)
          .merge(chartThemeData.tooltipTextStyle)
          .merge(widget.tooltipBehavior?.textStyle),
      trackballTextStyle: effectiveChartThemeData.trackballTextStyle!
          .copyWith(
              color: chartThemeData.crosshairLabelColor ??
                  effectiveChartThemeData.crosshairLabelColor)
          .merge(chartThemeData.trackballTextStyle)
          .merge(widget.trackballBehavior?.tooltipSettings.textStyle),
      crosshairTextStyle: effectiveChartThemeData.crosshairTextStyle!
          .copyWith(
              color: chartThemeData.crosshairLabelColor ??
                  effectiveChartThemeData.crosshairLabelColor)
          .merge(chartThemeData.crosshairTextStyle),
      selectionZoomingTooltipTextStyle: effectiveChartThemeData
          .selectionZoomingTooltipTextStyle!
          .copyWith(
              color: chartThemeData.tooltipLabelColor ??
                  effectiveChartThemeData.tooltipLabelColor)
          .merge(chartThemeData.selectionZoomingTooltipTextStyle),
    );
    return chartThemeData;
  }

  Widget _buildLegendItem(BuildContext context, int index) {
    return buildLegendItem(context, _legendItems[index], widget.legend);
  }

  void _collectAnnotationWidgets() {
    if (widget.annotations != null) {
      if (_annotations == null) {
        _annotations = <Widget>[];
      } else {
        _annotations!.clear();
      }

      for (final CartesianChartAnnotation annotation in widget.annotations!) {
        _annotations!.add(annotation.widget);
      }
    }
  }

  Widget? _buildTooltipWidget(
      BuildContext context, TooltipInfo? info, Size maxSize) {
    return buildTooltipWidget(context, info, maxSize, widget.tooltipBehavior,
        _chartThemeData, _themeData);
  }

  void _buildTrackballWidget(List<TrackballDetails> details) {
    final TrackballBehavior trackballBehavior = widget.trackballBehavior!;
    final List<ChartPointInfo> chartPointInfo =
        trackballBehavior.chartPointInfo;
    if (details.isEmpty || trackballBehavior.builder == null) {
      _trackballBuilder = const SizedBox(width: 0, height: 0);
    } else if (details.isNotEmpty &&
        trackballBehavior.builder != null &&
        chartPointInfo.isNotEmpty) {
      _trackballBuilder = Stack(
        children: List<Widget>.generate(details.length, (int index) {
          final ChartPointInfo info = chartPointInfo[index];
          final Widget builder =
              trackballBehavior.builder!.call(context, details[index]);
          return TrackballBuilderRenderObjectWidget(
            index: index,
            xPos: info.xPosition!,
            yPos: info.yPosition!,
            builder: builder,
            chartPointInfo: chartPointInfo,
            trackballBehavior: trackballBehavior,
            child: builder,
          );
        }).toList(),
      );
    }
    final RenderObjectElement? trackballBuilderElement =
        _trackballBuilderKey.currentContext as RenderObjectElement?;
    if (trackballBuilderElement != null &&
        trackballBuilderElement.mounted &&
        trackballBuilderElement.renderObject.attached) {
      final RenderObject? renderObject =
          trackballBuilderElement.findRenderObject();
      if (renderObject != null &&
          renderObject.attached &&
          renderObject is RenderConstrainedLayoutBuilder) {
        renderObject.markNeedsBuild();
      }
    }
  }

  void _handleSwipe(ChartSwipeDirection direction) {
    _swipeDirection = direction;
    widget.onPlotAreaSwipe?.call(direction);
  }

  Widget _buildLoadingIndicator(
      BuildContext context, BoxConstraints constraints) {
    if (widget.loadMoreIndicatorBuilder != null && _swipeDirection != null) {
      return widget.loadMoreIndicatorBuilder!(context, _swipeDirection!);
    }
    return const SizedBox(width: 0, height: 0);
  }

  @override
  void initState() {
    _legendKey = GlobalKey();
    _tooltipKey = GlobalKey();
    _trackballBuilderKey = GlobalKey();
    _collectAnnotationWidgets();
    super.initState();
  }

  @override
  void didUpdateWidget(SfCartesianChart oldWidget) {
    if (oldWidget.annotations != widget.annotations) {
      _collectAnnotationWidgets();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _localizations = SfLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    final ChartThemeData effectiveChartThemeData = ChartThemeData(context);
    _chartThemeData = _updateThemeData(context, effectiveChartThemeData);
    bool isTransposed = widget.isTransposed;
    if (widget.series.isNotEmpty && widget.series[0].transposed()) {
      isTransposed = !isTransposed;
    }

    final core.LegendPosition legendPosition =
        effectiveLegendPosition(widget.legend);
    final Axis orientation =
        effectiveLegendOrientation(legendPosition, widget.legend);
    Widget current = core.LegendLayout(
      key: _legendKey,
      padding: EdgeInsets.zero,
      showLegend: widget.legend.isVisible,
      legendPosition: legendPosition,
      legendAlignment: effectiveLegendAlignment(widget.legend.alignment),
      legendTitleAlignment:
          effectiveLegendAlignment(widget.legend.title?.alignment),
      itemIconBorderColor: widget.legend.iconBorderColor,
      itemIconBorderWidth: widget.legend.iconBorderWidth,
      legendBorderColor: widget.legend.borderColor,
      legendBackgroundColor: _chartThemeData.legendBackgroundColor,
      legendBorderWidth: widget.legend.borderWidth,
      itemOpacity: widget.legend.opacity,
      legendWidthFactor:
          percentageToWidthFactor(widget.legend.width, legendPosition),
      legendHeightFactor:
          percentageToHeightFactor(widget.legend.height, legendPosition),
      itemInnerSpacing: widget.legend.padding,
      itemSpacing: 0.0,
      itemPadding: widget.legend.itemPadding,
      itemRunSpacing: 0.0,
      itemIconHeight: widget.legend.iconHeight,
      itemIconWidth: widget.legend.iconWidth,
      scrollbarVisibility: effectiveScrollbarVisibility(widget.legend),
      enableToggling: widget.legend.toggleSeriesVisibility,
      itemTextStyle: _chartThemeData.legendTextStyle!,
      isResponsive: widget.legend.isResponsive,
      legendWrapDirection: orientation,
      legendTitle: buildLegendTitle(_chartThemeData, widget.legend),
      legendOverflowMode: effectiveOverflowMode(widget.legend),
      legendItemBuilder:
          widget.legend.legendItemBuilder != null ? _buildLegendItem : null,
      legendFloatingOffset: widget.legend.offset,
      toggledTextOpacity: 0.2,
      child: CartesianChartArea(
        legendKey: _legendKey,
        legendItems: _legendItems,
        onChartTouchInteractionDown: widget.onChartTouchInteractionDown,
        onChartTouchInteractionMove: widget.onChartTouchInteractionMove,
        onChartTouchInteractionUp: widget.onChartTouchInteractionUp,
        plotAreaBackgroundImage: widget.plotAreaBackgroundImage,
        plotAreaBackgroundColor: _chartThemeData.plotAreaBackgroundColor,
        children: <Widget>[
          CartesianChartPlotArea(
            vsync: this,
            localizations: _localizations,
            legendKey: _legendKey,
            isTransposed: isTransposed,
            backgroundColor: null,
            borderColor: _chartThemeData.plotAreaBorderColor,
            borderWidth: widget.plotAreaBorderWidth,
            enableAxisAnimation: widget.enableAxisAnimation,
            enableSideBySideSeriesPlacement:
                widget.enableSideBySideSeriesPlacement,
            legend: widget.legend,
            onLegendItemRender: widget.onLegendItemRender,
            onLegendTapped: widget.onLegendTapped,
            onDataLabelRender: widget.onDataLabelRender,
            onDataLabelTapped: widget.onDataLabelTapped,
            onMarkerRender: widget.onMarkerRender,
            onTooltipRender: widget.onTooltipRender,
            palette: widget.palette ?? effectiveChartThemeData.palette,
            selectionMode: widget.selectionType,
            selectionGesture: widget.selectionGesture,
            enableMultiSelection: widget.enableMultiSelection,
            tooltipBehavior: widget.tooltipBehavior,
            crosshairBehavior: widget.crosshairBehavior,
            trackballBehavior: widget.trackballBehavior,
            zoomPanBehavior: widget.zoomPanBehavior,
            onSelectionChanged: widget.onSelectionChanged,
            chartThemeData: _chartThemeData,
            themeData: _themeData,
            children: widget.series,
          ),
          CartesianAxes(
            vsync: this,
            enableAxisAnimation: widget.enableAxisAnimation,
            isTransposed: isTransposed,
            onAxisLabelTapped: widget.onAxisLabelTapped,
            onActualRangeChanged: widget.onActualRangeChanged,
            indicators: widget.indicators,
            chartThemeData: _chartThemeData,
            children: <ChartAxis>[
              widget.primaryXAxis,
              widget.primaryYAxis,
              ...widget.axes
            ],
          ),
          if (widget.indicators.isNotEmpty)
            IndicatorStack(
              vsync: this,
              isTransposed: isTransposed,
              indicators: widget.indicators,
              onLegendItemRender: widget.onLegendItemRender,
              onLegendTapped: widget.onLegendTapped,
              trackballBehavior: widget.trackballBehavior,
              textDirection: Directionality.of(context),
            ),
          if (widget.annotations != null &&
              widget.annotations!.isNotEmpty &&
              _annotations != null &&
              _annotations!.isNotEmpty)
            AnnotationArea(
              isTransposed: isTransposed,
              annotations: widget.annotations,
              children: _annotations!,
            ),
          BehaviorArea(
            tooltipKey: _tooltipKey,
            primaryXAxisName:
                widget.primaryXAxis.name ?? primaryXAxisDefaultName,
            primaryYAxisName:
                widget.primaryYAxis.name ?? primaryYAxisDefaultName,
            isTransposed: isTransposed,
            tooltipBehavior: widget.tooltipBehavior,
            crosshairBehavior: widget.crosshairBehavior,
            zoomPanBehavior: widget.zoomPanBehavior,
            onZooming: widget.onZooming,
            onZoomStart: widget.onZoomStart,
            onZoomEnd: widget.onZoomEnd,
            onZoomReset: widget.onZoomReset,
            textDirection: Directionality.of(context),
            trackballBehavior: widget.trackballBehavior,
            chartThemeData: _chartThemeData,
            themeData: _themeData,
            trackballBuilder: _buildTrackballWidget,
            onTrackballPositionChanging: widget.onTrackballPositionChanging,
            onCrosshairPositionChanging: widget.onCrosshairPositionChanging,
            onTooltipRender: widget.onTooltipRender,
            children: <Widget>[
              if (widget.trackballBehavior != null &&
                  widget.trackballBehavior!.enable &&
                  widget.trackballBehavior!.builder != null)
                TrackballBuilderOpacityWidget(
                  opacity: 1.0,
                  child: LayoutBuilder(
                    key: _trackballBuilderKey,
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return _trackballBuilder ?? const SizedBox(height: 0);
                    },
                  ),
                ),
              if (widget.loadMoreIndicatorBuilder != null ||
                  widget.onPlotAreaSwipe != null)
                LoadingIndicator(
                  isTransposed: widget.isTransposed,
                  isInversed: widget.primaryXAxis.isInversed,
                  onSwipe: _handleSwipe,
                  builder: _buildLoadingIndicator,
                ),
              if (widget.tooltipBehavior != null &&
                  widget.tooltipBehavior!.enable)
                CoreTooltip(
                  key: _tooltipKey,
                  builder: _buildTooltipWidget,
                  opacity: widget.tooltipBehavior!.opacity,
                  borderColor: widget.tooltipBehavior!.borderColor,
                  borderWidth: widget.tooltipBehavior!.borderWidth,
                  color: (widget.tooltipBehavior!.color ??
                      _chartThemeData.tooltipColor)!,
                  showDuration: widget.tooltipBehavior!.duration.toInt(),
                  shadowColor: widget.tooltipBehavior!.shadowColor,
                  elevation: widget.tooltipBehavior!.elevation,
                  animationDuration: widget.tooltipBehavior!.animationDuration,
                  shouldAlwaysShow: widget.tooltipBehavior!.shouldAlwaysShow,
                ),
            ],
          ),
        ],
      ),
    );

    current = buildChartWithTitle(current, widget.title, _chartThemeData);

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: _chartThemeData.backgroundColor,
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: Padding(
          padding: widget.margin.resolve(Directionality.maybeOf(context)),
          child: current,
        ),
      ),
    );
  }

  /// Method to convert the [SfCartesianChart] as an image.
  ///
  /// As this method is in the widget’s state class,
  /// you have to use a global key to access the state to call this method.
  /// Returns the `dart:ui.image`
  ///
  /// ```dart
  /// final GlobalKey<SfCartesianChartState> _key = GlobalKey();
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Column(
  ///      children: [SfCartesianChart(
  ///        key: _key
  ///          series: <CartesianSeries<SalesData, num>>[
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
  ///           ),
  ///         );
  ///        },
  ///      ),
  ///    );
  ///  }
  /// }
  /// ```
  Future<Image?> toImage({double pixelRatio = 1.0}) async {
    final RenderRepaintBoundary? boundary =
        context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      final Image image = await boundary.toImage(pixelRatio: pixelRatio);
      return image;
    }

    return null;
  }

  @override
  void dispose() {
    _annotations?.clear();
    super.dispose();
  }
}
