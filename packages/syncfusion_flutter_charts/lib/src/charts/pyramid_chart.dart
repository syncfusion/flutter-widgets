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
import 'series/pyramid_series.dart';
import 'theme.dart';
import 'utils/enum.dart';
import 'utils/helper.dart';
import 'utils/typedef.dart';

/// Renders the pyramid chart.
///
/// To render a pyramid chart, create an instance of PyramidSeries, and
/// add it to the series property of SfPyramidChart.
///
/// Properties such as opacity, [borderWidth], [borderColor], pointColorMapper
/// are used to customize the appearance of a pyramid segment.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=t3Dczqj8-10}
class SfPyramidChart extends StatefulWidget {
  /// Creating an argument constructor of [SfPyramidChart] class.
  const SfPyramidChart({
    Key? key,
    this.backgroundColor,
    this.backgroundImage,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.onLegendItemRender,
    this.onTooltipRender,
    this.onDataLabelRender,
    this.onDataLabelTapped,
    this.onLegendTapped,
    this.onSelectionChanged,
    this.onChartTouchInteractionUp,
    this.onChartTouchInteractionDown,
    this.onChartTouchInteractionMove,
    this.palette,
    this.margin = const EdgeInsets.fromLTRB(10, 10, 10, 10),
    this.series = const PyramidSeries(),
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
  ///        child: SfPyramidChart(
  ///            title: ChartTitle(text: 'Pyramid Chart')
  ///        )
  ///   );
  /// }
  /// ```
  final ChartTitle title;

  /// Background color of the chart.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
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
  ///        child: SfPyramidChart(
  ///            borderColor: Colors.blue
  ///        )
  ///    );
  /// }
  /// ```
  final Color borderColor;

  /// Border width of the chart.
  ///
  /// Defaults to `0.0`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
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
  ///     child: SfPyramidChart(
  ///       series: PyramidSeries<_PyramidData, String>(
  ///         dataSource: data,
  ///         xValueMapper: (_PyramidData data, _) => data.xData,
  ///         yValueMapper: (_PyramidData data, _) => data.yData,
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final PyramidSeries series;

  /// Customizes the chart.
  ///
  /// Defaults to `const EdgeInsets.all(10)`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
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
  ///        child: SfPyramidChart(
  ///            legend: Legend(isVisible: true)
  ///        )
  ///    );
  /// }
  /// ```
  final Legend legend;

  /// Color palette for the data points in the chart series.
  ///
  /// If the series color is not specified, then the series will be rendered
  /// with the appropriate palette color.
  /// Ten colors are available by default.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
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
  ///        child: SfPyramidChart(
  ///            tooltipBehavior: _tooltipBehavior
  ///        )
  ///    );
  /// }
  /// ```
  final TooltipBehavior? tooltipBehavior;

  /// Occurs while the legend is rendered.
  ///
  /// Here, you can get the legend's text, shape, series index, and
  /// point index case of the pyramid series.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRendererArgs args) => legend(args),
  ///        )
  ///    );
  /// }
  /// void legend(LegendRendererArgs args) {
  ///   args.legendIconType = LegendIconType.diamond;
  /// }
  /// ```
  final PyramidLegendRenderCallback? onLegendItemRender;

  /// Occurs when the tooltip is rendered.
  ///
  /// Here, you can get the tooltip arguments and customize the arguments.
  final PyramidTooltipCallback? onTooltipRender;

  /// Occurs when the data label is rendered,
  /// here data label arguments can be customized.
  final PyramidDataLabelRenderCallback? onDataLabelRender;

  /// Occurs when the legend is tapped, the arguments can be used to customize
  /// the legend arguments.
  final ChartLegendTapCallback? onLegendTapped;

  /// Data points or series can be selected while performing interaction on the
  /// chart.
  ///
  /// It can also be selected at the initial rendering using this property.
  ///
  /// Defaults to `[]`.
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
  ///        child: SfPyramidChart(
  ///           series: PyramidSeries<ChartData, String>(
  ///                  initialSelectedDataIndexes: <int>[1,0],
  ///                  selectionBehavior: _selectionBehavior
  ///              ),
  ///        )
  ///    );
  /// }
  /// ```

  /// Gesture for activating the selection.
  ///
  /// Selection can be activated in `ActivationMode.none`,
  /// `ActivationMode.singleTap`,
  /// `ActivationMode.doubleTap` and
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
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///           selectionGesture: ActivationMode.singleTap,
  ///           series: PyramidSeries<ChartData, String>(
  ///                  selectionBehavior: _selectionBehavior
  ///              ),
  ///        )
  ///    );
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
  ///        child: SfPyramidChart(
  ///           enableMultiSelection: true,
  ///           series: PyramidSeries<ChartData, String>(
  ///                  selectionBehavior: _selectionBehavior
  ///              ),
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
  ///        child: SfPyramidChart(
  ///            backgroundImage: const AssetImage('image.png'),
  ///        )
  ///    );
  /// }
  /// ```
  final ImageProvider? backgroundImage;

  /// Occurs while selection changes. Here, you can get the series, selected
  /// color, unselected color, selected border color, unselected border color,
  /// selected border width, unselected border width, series index, and
  /// point index.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onSelectionChanged: (SelectionArgs args) => select(args),
  ///        )
  ///    );
  /// }
  /// void select(SelectionArgs args) {
  ///   print(args.selectedBorderColor);
  /// }
  /// ```
  final PyramidSelectionCallback? onSelectionChanged;

  /// Called when the data label is tapped.
  ///
  /// Whenever the data label is tapped, the `onDataLabelTapped` callback will
  /// be called. Provides options to get the position of the data label,
  /// series index, point index and its text.
  ///
  /// _Note:_  This callback will not be called, when the builder is specified
  /// for data label (data label template).
  /// For this case, custom widget specified in the `DataLabelSettings.builder`
  /// property can be wrapped using the `GestureDetector` and this functionality
  ///  can be achieved at the application level.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onDataLabelTapped: (DataLabelTapDetails args) {
  ///                 print(arg.seriesIndex);
  ///                  }
  ///        )
  ///    );
  /// }
  /// ```
  final DataLabelTapCallback? onDataLabelTapped;

  /// Occurs when tapped on the chart area.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  /// }
  /// ```
  final PyramidTouchInteractionCallback? onChartTouchInteractionUp;

  /// Occurs when touched and moved on the chart area.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onChartTouchInteractionMove: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  /// }
  /// ```
  final PyramidTouchInteractionCallback? onChartTouchInteractionMove;

  /// Occurs when touched on the chart area.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onChartTouchInteractionDown: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  /// }
  /// ```
  final PyramidTouchInteractionCallback? onChartTouchInteractionDown;

  @override
  State<StatefulWidget> createState() => SfPyramidChartState();
}

/// Represents the state class of [SfPyramidChart] widget.
///
class SfPyramidChartState extends State<SfPyramidChart>
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
  /// [SfPyramidChart].
  @override
  void initState() {
    _legendKey = GlobalKey();
    _tooltipKey = GlobalKey();
    super.initState();
  }

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
  /// in [SfPyramidChart].
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
        legendItems: _legendItems,
        legendKey: _legendKey,
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

  /// Method to convert the [SfPyramidChart] as an image.
  ///
  /// Returns the `dart:ui.image`.
  ///
  /// As this method is in the widget’s state class,
  /// you have to use a global key to access the state to call this method.
  ///
  /// ```dart
  /// final GlobalKey<SfPyramidChartState> _key = GlobalKey();
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [
  ///         SfPyramidChart(
  ///           key: _key,
  ///           series: PyramidSeries<_PyramidData, String>(
  ///             dataSource: data,
  ///             xValueMapper: (_PyramidData data, _) => data.xData,
  ///             yValueMapper: (_PyramidData data, _) => data.yData,
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
  ///            ),
  ///            ),
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
}
