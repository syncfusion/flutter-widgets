import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'base.dart';
import 'common/annotation.dart';
import 'common/callbacks.dart';
import 'common/core_legend.dart' as core;
import 'common/core_tooltip.dart';
import 'common/legend.dart';
import 'common/title.dart';
import 'interactions/behavior.dart';
import 'interactions/tooltip.dart';
import 'series/chart_series.dart';
import 'theme.dart';
import 'utils/enum.dart';
import 'utils/helper.dart';
import 'utils/typedef.dart';

/// Renders the circular chart.
///
/// The SfCircularChart widget supports pie, doughnut, and radial bar series
/// that can be customized within the circular chart's class.
///
/// ```dart
/// Widget build(BuildContext context) {
///  return Center(
///    child:SfCircularChart(
///    title: ChartTitle(text: 'Sales by sales person'),
///    legend: Legend(isVisible: true),
///    series: <PieSeries<_PieData, String>>[
///      PieSeries<_PieData, String>(
///        explode: true,
///        explodeIndex: 0,
///        dataSource: pieData,
///        xValueMapper: (_PieData data, _) => data.xData,
///        yValueMapper: (_PieData data, _) => data.yData,
///        dataLabelMapper: (_PieData data, _) => data.text,
///        dataLabelSettings: DataLabelSettings(isVisible: true)),
///    ]
///   )
///  );
/// }
///
/// class _PieData {
///  _PieData(this.xData, this.yData, [this.text]);
///  final String xData;
///  final num yData;
///  String? text;
/// }
/// ```
//ignore:must_be_immutable
class SfCircularChart extends StatefulWidget {
  /// Creating an argument constructor of SfCircularChart class.
  const SfCircularChart({
    Key? key,
    this.backgroundColor,
    this.backgroundImage,
    this.annotations,
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
    this.onCreateShader,
    this.palette,
    this.margin = const EdgeInsets.fromLTRB(10, 10, 10, 10),
    this.series = const <CircularSeries>[],
    this.title = const ChartTitle(),
    this.legend = const Legend(),
    this.centerX = '50%',
    this.centerY = '50%',
    this.tooltipBehavior,
    this.selectionGesture = ActivationMode.singleTap,
    this.enableMultiSelection = false,
  }) : super(key: key);

  /// Customizes the chart title.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            title: ChartTitle(text: 'Default rendering')
  ///        )
  ///   );
  /// }
  /// ```
  final ChartTitle title;

  /// Customizes the chart series.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: chartData,
  ///              ),
  ///           ],
  ///        )
  ///    );
  /// }
  /// ```
  final List<CircularSeries> series;

  /// Specifies the margin for circular chart.
  ///
  /// Defaults to `const EdgeInsets.fromLTRB(10, 10, 10, 10)`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            margin: const EdgeInsets.all(2)
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
  ///        child: SfCircularChart(
  ///            legend: Legend(isVisible: true)
  ///        )
  ///    );
  /// }
  /// ```
  final Legend legend;

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
  ///        child: SfCircularChart(
  ///            tooltipBehavior: _tooltipBehavior
  ///        )
  ///    );
  /// }
  /// ```
  final TooltipBehavior? tooltipBehavior;

  /// Background color of the chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            backgroundColor: Colors.blue
  ///        )
  ///    );
  /// }
  /// ```
  final Color? backgroundColor;

  /// Customizes the annotations. Annotations are used to mark the specific area
  /// of interest in the plot area with texts, shapes, or images.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                   angle: 200,
  ///                   radius: '80%',
  ///                   widget: const Text('Circular Chart')
  ///                 ),
  ///             ],
  ///        )
  ///    );
  /// }
  /// ```
  final List<CircularChartAnnotation>? annotations;

  /// Border color of the chart.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            borderColor: Colors.red
  ///        )
  ///    );
  /// }
  /// ```
  final Color borderColor;

  /// Border width of the chart.
  ///
  /// Defaults to `0.0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            borderWidth: 2
  ///        )
  ///    );
  /// }
  /// ```
  final double borderWidth;

  /// Background image for chart.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            backgroundImage: const AssetImage('image.png'),
  ///        )
  ///    );
  /// }
  /// ```
  final ImageProvider? backgroundImage;

  /// X value for placing the chart. The value ranges from 0% to 100% and also
  /// if values are mentioned in pixel then the chart will moved accordingly.
  ///
  /// For example, if set `50%` means the x value place center of the chart area
  /// or we set `50` means the x value placed 50 pixel.
  ///
  /// Defaults to `50%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            centerX: '50%'
  ///        )
  ///    );
  /// }
  /// ```
  final String centerX;

  /// Y value for placing the chart. The value ranges from 0% to 100% and also
  /// if values are mentioned in pixel then the chart will moved accordingly.
  ///
  /// For example,  if set `50%` means the y value place center of the chart
  /// area or we set `50` means the y value placed 50 pixel.
  ///
  /// Defaults to `50%`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            centerY: '50%'
  ///        )
  ///    );
  /// }
  /// ```
  final String centerY;

  /// Occurs while legend is rendered. Here, you can get the legend's text,
  /// shape, series index, and point index case of circular series.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRendererArgs args) => legend(args),
  ///        )
  ///    );
  /// }
  /// void legend(LegendRendererArgs args) {
  ///   args.legendIconType = LegendIconType.diamond;
  /// }
  /// ```
  final CircularLegendRenderCallback? onLegendItemRender;

  /// Occurs while tooltip is rendered.  You can customize the position and
  /// header. Here, you can get the text, header, point index, series,
  /// x and y-positions.
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
  ///        child: SfCircularChart(
  ///            tooltipBehavior: _tooltipBehavior,
  ///            onTooltipRender: (TooltipArgs args) => tool(args)
  ///        )
  ///    );
  /// }
  /// void tool(TooltipArgs args) {
  ///   args.locationX = 30;
  /// }
  /// ```
  final CircularTooltipCallback? onTooltipRender;

  /// Occurs while rendering the data label. The data label and text styles
  /// such as color, font size, and font weight can be customized. You can get
  /// the series index, point index, text, and text style.
  /// ```dart
  ///   Widget build(BuildContext context) {
  ///   return Container(
  ///     child: SfCircularChart(
  ///       onDataLabelRender: (DataLabelRenderArgs args) => dataLabel(args),
  ///       series: <PieSeries<ChartData, String>>[
  ///         PieSeries<ChartData, String>(
  ///           dataLabelSettings: DataLabelSettings(isVisible: true),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// void dataLabel(DataLabelRenderArgs args) {
  ///    args.text = 'dataLabel';
  /// }
  /// ```
  final CircularDataLabelRenderCallback? onDataLabelRender;

  /// Fills the data points with the gradient and image shaders.
  ///
  /// The data points of pie, doughnut and radial bar charts can be filled with
  /// [gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html)
  /// (linear, radial and sweep gradient) and
  /// [image shaders](https://api.flutter.dev/flutter/dart-ui/ImageShader-class.html).
  ///
  /// All the data points are together considered as a single segment and the
  /// shader is applied commonly.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// final List<Color> colors = <Color>[
  ///   const Color.fromRGBO(75, 135, 185, 1),
  ///   const Color.fromRGBO(192, 108, 132, 1),
  ///   const Color.fromRGBO(246, 114, 128, 1),
  ///   const Color.fromRGBO(248, 177, 149, 1),
  ///   const Color.fromRGBO(116, 180, 155, 1)
  /// ];
  /// final List<double> stops = <double>[
  ///    0.2,
  ///    0.4,
  ///    0.6,
  ///    0.8,
  ///    1,
  /// ];
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onCreateShader: (ChartShaderDetails chartShaderDetails) {
  ///                 return ui.Gradient.linear(
  ///                   chartShaderDetails.outerRect.topRight,
  ///                   chartShaderDetails.outerRect.centerLeft,
  ///                   colors,
  ///                   stops);
  ///               },
  ///        )
  ///    );
  /// }
  /// ```
  final CircularShaderCallback? onCreateShader;

  /// Called when the data label is tapped.
  ///
  /// Whenever the data label is tapped, `onDataLabelTapped` callback will be
  /// called. Provides options to get the position of the data label,
  /// series index, point index and its text.
  ///
  /// _Note:_  This callback will not be called, when the builder is specified
  /// for data label (data label template). For this case, custom widget
  /// specified in the `DataLabelSettings.builder` property can be wrapped using
  /// the `GestureDetector` and this functionality can be achieved
  /// in the application level.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onDataLabelTapped: (DataLabelTapDetails args) {
  ///                 print(arg.seriesIndex);
  ///                  }
  ///           )
  ///    );
  /// }
  /// ```

  final DataLabelTapCallback? onDataLabelTapped;

  /// Occurs when the legend is tapped. Here, you can get the series,
  /// series index, and point index.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onLegendTapped: (LegendTapArgs args) => legend(args),
  ///            legend: Legend(isVisible: true),
  ///        )
  ///    );
  /// }
  /// void legend(LegendTapArgs args) {
  ///   print(args.pointIndex);
  /// }
  /// ```
  final ChartLegendTapCallback? onLegendTapped;

  /// Occurs while selection changes. Here, you can get the series, selected
  /// color, unselected color, selected border color, unselected border color,
  /// selected border width, unselected border width, series index, and
  /// point index.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onSelectionChanged: (SelectionArgs args) => select(args),
  ///        )
  ///    );
  /// }
  /// void select(SelectionArgs args) {
  ///   print(args.selectedBorderColor);
  /// }
  /// ```
  final CircularSelectionCallback? onSelectionChanged;

  /// Occurs when tapped on the chart area.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  /// }
  /// ```
  final CircularTouchInteractionCallback? onChartTouchInteractionUp;

  /// Occurs when touched on the chart area.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onChartTouchInteractionDown: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  /// }
  /// ```
  ///
  final CircularTouchInteractionCallback? onChartTouchInteractionDown;

  /// Occurs when touched and moved on the chart area.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onChartTouchInteractionMove: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  /// }
  /// ```
  final CircularTouchInteractionCallback? onChartTouchInteractionMove;

  /// Color palette for the data points in the chart series. If the series color
  /// is not specified, then the series will be rendered with appropriate
  /// palette color.
  /// Ten colors are available by default.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            palette: <Color>[Colors.red, Colors.green]
  ///        )
  ///    );
  /// }
  /// ```
  final List<Color>? palette;

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
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            selectionGesture: ActivationMode.singleTap,
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  selectionBehavior: _selectionBehavior
  ///                ),
  ///              ],
  ///        )
  ///    );
  /// }
  /// ```
  final ActivationMode selectionGesture;

  /// Enables or disables the multiple data points or series selection.
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
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            enableMultiSelection: true,
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  selectionBehavior: _selectionBehavior
  ///                ),
  ///              ],
  ///        )
  ///    );
  /// }
  /// ```
  final bool enableMultiSelection;

  @override
  State<StatefulWidget> createState() => SfCircularChartState();
}

/// Represents the state class of [SfCircularChart] widget.
///
class SfCircularChartState extends State<SfCircularChart>
    with TickerProviderStateMixin {
  final List<core.LegendItem> _legendItems = <core.LegendItem>[];

  late GlobalKey _legendKey;
  late GlobalKey _tooltipKey;
  late SfChartThemeData _chartThemeData;
  late ThemeData _themeData;
  SfLocalizations? _localizations;
  List<Widget>? _annotations;

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

  // ignore: unused_element
  void _handleTouchDown(Offset localPosition) {
    widget.onChartTouchInteractionDown
        ?.call(ChartTouchInteractionArgs()..position = localPosition);
  }

  // ignore: unused_element
  void _handleTouchMove(Offset localPosition) {
    widget.onChartTouchInteractionMove
        ?.call(ChartTouchInteractionArgs()..position = localPosition);
  }

  // ignore: unused_element
  void _handleTouchUp(Offset localPosition) {
    widget.onChartTouchInteractionUp
        ?.call(ChartTouchInteractionArgs()..position = localPosition);
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
  /// [SfCircularChart].
  @override
  void initState() {
    _legendKey = GlobalKey();
    _tooltipKey = GlobalKey();
    super.initState();
  }

  /// Called when a dependency of this [State] object changes.
  ///
  /// For example, if the previous call to [build] referenced
  /// an [InheritedWidget] that later changed, the framework would call this
  /// method to notify this object about the change.
  ///
  /// This method is also called immediately after [initState]. It is safe to
  /// call [BuildContext.dependOnInheritedWidgetOfExactType] from this method.
  ///
  /// Here it called for initializing the chart theme of [SfCircularChart].
  @override
  void didChangeDependencies() {
    _localizations = SfLocalizations.of(context);
    if (widget.annotations != null) {
      _collectAnnotationWidgets();
    }
    super.didChangeDependencies();
  }

  void _collectAnnotationWidgets() {
    if (widget.annotations != null) {
      if (_annotations == null) {
        _annotations = <Widget>[];
      } else {
        _annotations!.clear();
      }

      for (final CircularChartAnnotation annotation in widget.annotations!) {
        _annotations!.add(annotation.widget);
      }
    }
  }

  /// Called whenever the widget configuration changes.
  ///
  /// If the parent widget rebuilds and request that this location in the tree
  /// update to display a new widget with the same [runtimeType] and
  /// [Widget.key], the framework will update the widget property of this
  /// [State] object to refer to the new widget and then call this method with
  /// the previous widget as an argument.
  ///
  /// Override this method to respond when the widget changes.
  ///
  /// The framework always calls [build] after calling [didUpdateWidget], which
  /// means any calls to [setState] in [didUpdateWidget] are redundant.
  ///
  /// * In [didUpdateWidget] unsubscribe from the old object and subscribe to
  /// the new one if the updated widget configuration requires replacing
  /// the object.
  ///
  /// Here it called whenever the series collection gets updated in
  /// [SfCircularChart].

  @override
  void didUpdateWidget(SfCircularChart oldWidget) {
    if (oldWidget.annotations != widget.annotations) {
      _collectAnnotationWidgets();
    }
    super.didUpdateWidget(oldWidget);
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
  /// in [SfCircularChart].
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
          CircularChartPlotArea(
            vsync: this,
            localizations: _localizations,
            legendKey: _legendKey,
            palette: widget.palette ?? effectiveChartThemeData.palette,
            chartThemeData: _chartThemeData,
            themeData: _themeData,
            backgroundColor: null,
            borderWidth: widget.borderWidth,
            legend: widget.legend,
            onLegendItemRender: widget.onLegendItemRender,
            onDataLabelRender: widget.onDataLabelRender,
            onLegendTapped: widget.onLegendTapped,
            onTooltipRender: widget.onTooltipRender,
            onDataLabelTapped: widget.onDataLabelTapped,
            selectionMode: SelectionType.point,
            selectionGesture: widget.selectionGesture,
            enableMultiSelection: widget.enableMultiSelection,
            tooltipBehavior: widget.tooltipBehavior,
            centerX: widget.centerX,
            centerY: widget.centerY,
            onCreateShader: widget.onCreateShader,
            onSelectionChanged: widget.onSelectionChanged,
            children: widget.series,
          ),
          if (widget.annotations != null &&
              widget.annotations!.isNotEmpty &&
              _annotations != null &&
              _annotations!.isNotEmpty)
            CircularAnnotationArea(
              annotations: widget.annotations,
              children: _annotations!,
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

  /// Method to convert the [SfCircularChart] as an image.
  ///
  /// As this method is in the widget’s state class,
  /// you have to use a global key to access the state to call this method.
  /// Returns the `dart:ui.image`.
  ///
  /// ```dart
  /// final GlobalKey<SfCircularChartState> _key = GlobalKey();
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Column(
  ///      children: [SfCircularChart(
  ///        key: _key
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                enableTooltip: true,
  ///              ),
  ///             ],
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
