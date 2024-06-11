import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'base.dart';
import 'common/core_legend.dart' as core;
import 'common/core_tooltip.dart';
import 'common/legend.dart';
import 'common/title.dart';
import 'interactions/behavior.dart';
import 'interactions/tooltip.dart';
import 'series/funnel_series.dart';
import 'theme.dart';
import 'utils/enum.dart';
import 'utils/helper.dart';
import 'utils/typedef.dart';

/// Renders the funnel chart.
///
/// A funnel chart is a specialized chart type that demonstrates
/// the flow of users through a business or sales process.
/// The chart begins with a broad head and ends in a narrow neck.
///
/// The number of users at each stage of the process are indicated
/// from the funnel's width as it narrows.
///
/// To render a funnel chart, create an instance of FunnelSeries,
/// and add it to the series property of [SfFunnelChart].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=t3Dczqj8-10}
//ignore:must_be_immutable
class SfFunnelChart extends StatefulWidget {
  /// Creating an argument constructor of SfFunnelChart class.
  const SfFunnelChart({
    Key? key,
    this.backgroundColor,
    this.backgroundImage,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.onLegendItemRender,
    this.onTooltipRender,
    this.onDataLabelRender,
    this.onLegendTapped,
    this.onDataLabelTapped,
    this.onSelectionChanged,
    this.onChartTouchInteractionUp,
    this.onChartTouchInteractionDown,
    this.onChartTouchInteractionMove,
    this.palette,
    this.margin = const EdgeInsets.fromLTRB(10, 10, 10, 10),
    this.series = const FunnelSeries(),
    this.title = const ChartTitle(),
    this.legend = const Legend(),
    this.tooltipBehavior,
    this.selectionGesture = ActivationMode.singleTap,
    this.enableMultiSelection = false,
  }) : super(key: key);

  /// Customizes the chart title.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            title: ChartTitle(text: 'Funnel Chart')
  ///        )
  ///    );
  /// }
  /// ```
  final ChartTitle title;

  /// Background color of the chart.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            backgroundColor: Colors.blue
  ///        )
  ///    );
  /// }
  /// ```
  final Color? backgroundColor;

  /// Border color of the chart.
  ///
  /// Defaults to `Colors.transparent`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            borderColor: Colors.blue
  ///        )
  ///   );
  /// }
  /// ```
  final Color borderColor;

  /// Border width of the chart.
  ///
  /// Defaults to `0.0`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            borderWidth: 2
  ///        )
  ///    );
  /// }
  /// ```
  final double borderWidth;

  /// Customizes the chart series.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfFunnelChart(
  ///       series: FunnelSeries<_FunnelData, String>(
  ///         dataSource: data,
  ///         xValueMapper: (_FunnelData data, _) => data.xData,
  ///         yValueMapper: (_FunnelData data, _) => data.yData,
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final FunnelSeries series;

  /// Margin for chart.
  ///
  /// Defaults to `const EdgeInsets.all(10)`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            margin: const EdgeInsets.all(2),
  ///        )
  ///    );
  /// }
  /// ```
  final EdgeInsets margin;

  /// Customizes the legend in the chart.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            legend: Legend(isVisible: true)
  ///        )
  ///    );
  /// }
  /// ```
  final Legend legend;

  /// Color palette for the data points in the chart series.
  ///
  /// If the series color is not specified,
  /// then the series will be rendered with appropriate palette color.
  ///
  /// Ten colors are available by default.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            palette: <Color>[Colors.red, Colors.green]
  ///        )
  ///    );
  /// }
  /// ```
  final List<Color>? palette;

  /// Customizes the tooltip in chart.
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
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            tooltipBehavior: _tooltipBehavior
  ///        )
  ///    );
  /// }
  /// ```
  final TooltipBehavior? tooltipBehavior;

  /// Occurs while legend is rendered.
  ///
  /// Here, you can get the legend's text, shape, series index, and
  /// the point index case of funnel series.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRendererArgs args) => legend(args),
  ///        )
  ///    );
  /// }
  /// void legend(LegendRendererArgs args) {
  ///   args.legendIconType = LegendIconType.diamond;
  /// }
  /// ```
  final FunnelLegendRenderCallback? onLegendItemRender;

  /// Occurs while tooltip is rendered.
  ///
  /// Here, you can get the Tooltip render arguments and customize them.
  final FunnelTooltipCallback? onTooltipRender;

  /// Occurs when the data label is rendered.
  ///
  /// Here we can get get the data label render arguments and
  /// customize the data label parameters.
  final FunnelDataLabelRenderCallback? onDataLabelRender;

  /// Occurs when the legend is tapped,
  /// using this event the legend tap arguments can be customized.
  final ChartLegendTapCallback? onLegendTapped;

  /// Gesture for activating the selection.
  ///
  /// Selection can be activated in `ActivationMode.none`,
  /// `ActivationMode.singleTap`,
  /// `ActivationMode.doubleTap`, and
  /// `ActivationMode.longPress`.
  ///
  /// Defaults to `ActivationMode.singleTap`.
  ///
  /// Also refer [ActivationMode].
  ///
  /// ```dart
  /// late SelectionBehavior _selectionBehavior;
  ///
  /// void initState() {
  ///   _selectionBehavior = SelectionBehavior(enable: true);
  ///   super.initState();
  /// }
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///           selectionGesture: ActivationMode.singleTap,
  ///           series: FunnelSeries<ChartData, String>(
  ///                  selectionBehavior: _selectionBehavior
  ///             ),
  ///        )
  ///   );
  /// }
  /// ```
  final ActivationMode selectionGesture;

  /// Enables or disables the multiple data points selection.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// late SelectionBehavior _selectionBehavior;
  ///
  /// void initState() {
  ///   _selectionBehavior = SelectionBehavior(enable: true);
  ///   super.initState();
  /// }
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///           enableMultiSelection: true,
  ///           series: FunnelSeries<ChartData, String>(
  ///                  selectionBehavior: _selectionBehavior
  ///             ),
  ///        )
  ///    );
  /// }
  /// ```
  final bool enableMultiSelection;

  /// Background image for chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            backgroundImage: const AssetImage('image.png'),
  ///        )
  ///    );
  /// }
  /// ```
  final ImageProvider? backgroundImage;

  /// Occurs while selection changes. Here, you can get the series,
  /// selected color, unselected color, selected border color,
  /// unselected border color, selected border width, unselected border width,
  /// series index, and point index.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            onSelectionChanged: (SelectionArgs args) => select(args),
  ///        )
  ///    );
  /// }
  /// void select(SelectionArgs args) {
  ///   print(args.selectedBorderColor);
  /// }
  /// ```
  final FunnelSelectionCallback? onSelectionChanged;

  /// Occurs when tapped on the chart area.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///     );
  /// }
  /// ```
  final FunnelTouchInteractionCallback? onChartTouchInteractionUp;

  /// Occurs when touched on the chart area.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            onChartTouchInteractionDown: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///     );
  /// }
  /// ```
  final FunnelTouchInteractionCallback? onChartTouchInteractionDown;

  /// Occurs when touched and moved on the chart area.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            onChartTouchInteractionMove: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  /// }
  /// ```
  final FunnelTouchInteractionCallback? onChartTouchInteractionMove;

  /// Called when the data label is tapped.
  ///
  /// Whenever the data label is tapped, `onDataLabelTapped` callback will be
  /// called. Provides options to get the position of the data label,
  /// series index, point index and its text.
  ///
  /// _Note:_  This callback will not be called, when the builder is specified
  /// for data label (data label template). For this case, custom widget
  /// specified in the `DataLabelSettings.builder` property can be wrapped
  /// using the `GestureDetector` and this functionality can be achieved in the
  /// application level.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            onDataLabelTapped: (DataLabelTapDetails args) {
  ///                 print(args.seriesIndex);
  ///                  }
  ///           )
  ///    );
  /// }
  /// ```

  final DataLabelTapCallback? onDataLabelTapped;

  @override
  State<StatefulWidget> createState() => SfFunnelChartState();
}

/// Represents the state class of [SfFunnelChart] widget.
class SfFunnelChartState extends State<SfFunnelChart>
    with TickerProviderStateMixin {
  final List<core.LegendItem> _legendItems = <core.LegendItem>[];

  late GlobalKey _legendKey;
  late GlobalKey _tooltipKey;
  late SfChartThemeData _chartThemeData;
  late ThemeData _themeData;
  SfLocalizations? _localizations;

  SfChartThemeData _updateThemeData(
      BuildContext context, ChartThemeData effectiveChartThemeData) {
    SfChartThemeData chartThemeData = SfChartTheme.of(context);
    chartThemeData = chartThemeData.copyWith(
      backgroundColor: widget.backgroundColor ??
          chartThemeData.backgroundColor ??
          effectiveChartThemeData.backgroundColor,
      titleBackgroundColor: widget.title.backgroundColor ??
          chartThemeData.titleBackgroundColor ??
          effectiveChartThemeData.titleBackgroundColor,
      legendBackgroundColor: widget.legend.backgroundColor ??
          chartThemeData.legendBackgroundColor ??
          effectiveChartThemeData.legendBackgroundColor,
      tooltipColor: widget.tooltipBehavior?.color ??
          chartThemeData.tooltipColor ??
          effectiveChartThemeData.tooltipColor,
      plotAreaBackgroundColor: chartThemeData.plotAreaBackgroundColor ??
          effectiveChartThemeData.plotAreaBackgroundColor,
      titleTextStyle: effectiveChartThemeData.titleTextStyle!
          .copyWith(
              color: chartThemeData.titleTextColor ??
                  effectiveChartThemeData.titleTextColor)
          .merge(chartThemeData.titleTextStyle)
          .merge(widget.title.textStyle),
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
    );
    return chartThemeData;
  }

  Widget _buildLegendItem(BuildContext context, int index) {
    return buildLegendItem(context, _legendItems[index], widget.legend);
  }

  Widget? _buildTooltipWidget(
      BuildContext context, TooltipInfo? info, Size maxSize) {
    return buildTooltipWidget(context, info, maxSize, widget.tooltipBehavior,
        _chartThemeData, _themeData);
  }

  /// Called when this object is inserted into the tree.
  ///
  /// The framework will call this method exactly once for each State object it
  /// creates.
  ///
  /// Override this method to perform initialization that depends on the
  /// location at which this object was inserted into the tree or on the widget
  /// used to configure this object.
  ///
  /// * In [initState], subscribe to the object.
  ///
  /// Here it overrides to initialize the object that depends on rendering the
  /// [SfFunnelChart].
  @override
  void initState() {
    _legendKey = GlobalKey();
    _tooltipKey = GlobalKey();
    super.initState();
  }

  /// Called when a dependency of this [State] object changes.
  ///
  /// For example, if the previous call to [build] referenced an
  /// [InheritedWidget] that later changed, the framework would call this method
  /// to notify this object about the change.
  ///
  /// This method is also called immediately after [initState]. It is safe to
  /// call [BuildContext.dependOnInheritedWidgetOfExactType] from this method.
  ///
  /// Here it called for initializing the chart theme of [SfFunnelChart].
  @override
  void didChangeDependencies() {
    _localizations = SfLocalizations.of(context);
    super.didChangeDependencies();
  }

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method in a number of different situations.
  /// For example:
  ///
  /// * After calling [initState].
  /// * After calling [didUpdateWidget].
  /// * After receiving a call to [setState].
  /// * After a dependency of this [State] object changes.
  ///
  /// Here it is called whenever the user interaction is performed and
  /// it removes the old widget and updates a chart with a new widget
  /// in [SfFunnelChart].
  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    final ChartThemeData effectiveChartThemeData = ChartThemeData(context);
    _chartThemeData = _updateThemeData(context, effectiveChartThemeData);
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
      child: ChartArea(
        legendKey: _legendKey,
        legendItems: _legendItems,
        onChartTouchInteractionDown: widget.onChartTouchInteractionDown,
        onChartTouchInteractionMove: widget.onChartTouchInteractionMove,
        onChartTouchInteractionUp: widget.onChartTouchInteractionUp,
        children: <Widget>[
          ChartPlotArea(
            vsync: this,
            localizations: _localizations,
            legendKey: _legendKey,
            backgroundColor: null,
            borderWidth: widget.borderWidth,
            legend: widget.legend,
            onLegendItemRender: widget.onLegendItemRender,
            onDataLabelRender: widget.onDataLabelRender,
            onLegendTapped: widget.onLegendTapped,
            onTooltipRender: widget.onTooltipRender,
            onDataLabelTapped: widget.onDataLabelTapped,
            palette: widget.palette ?? effectiveChartThemeData.palette,
            selectionMode: SelectionType.point,
            selectionGesture: widget.selectionGesture,
            enableMultiSelection: widget.enableMultiSelection,
            tooltipBehavior: widget.tooltipBehavior,
            onSelectionChanged: widget.onSelectionChanged,
            chartThemeData: _chartThemeData,
            themeData: _themeData,
            children: <Widget>[widget.series],
          ),
          if (widget.tooltipBehavior != null)
            BehaviorArea(
              tooltipKey: _tooltipKey,
              chartThemeData: _chartThemeData,
              themeData: _themeData,
              tooltipBehavior: widget.tooltipBehavior,
              onTooltipRender: widget.onTooltipRender,
              children: <Widget>[
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
                    animationDuration:
                        widget.tooltipBehavior!.animationDuration,
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
          image: widget.backgroundImage != null
              ? DecorationImage(
                  image: widget.backgroundImage!,
                  fit: BoxFit.fill,
                )
              : null,
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

  /// Method to convert the [SfFunnelChart] as an image.
  ///
  /// Returns the `dart:ui.image`.
  ///
  /// As this method is in the widget’s state class, you have to use a global
  /// key to access the state to call this method.
  ///
  /// ```dart
  /// final GlobalKey<SfFunnelChartState> _key = GlobalKey();
  /// @override
  /// Widget build(BuildContext context) {
  ///     return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfFunnelChart(
  ///           key: _key,
  ///           series: FunnelSeries<_FunnelData, String>(
  ///             dataSource: data,
  ///             xValueMapper: (_FunnelData data, _) => data.xData,
  ///             yValueMapper: (_FunnelData data, _) => data.yData,
  ///           ),
  ///         ),
  ///         RaisedButton(
  ///           child: Text(
  ///             'To Image',
  ///           ),
  ///           onPressed: _renderImage,
  ///           shape: RoundedRectangleBorder(
  ///             borderRadius: BorderRadius.circular(20),
  ///           ),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
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
  ///                 ),
  ///               ),
  ///             );
  ///           },
  ///         ),
  ///       );
  ///    }
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
}
