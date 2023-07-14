import 'dart:ui' as dart_ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../charts.dart';
import '../../chart/utils/helper.dart';
import '../../common/common.dart';
import '../../common/legend/legend.dart';
import '../../common/legend/renderer.dart';
import '../../common/rendering_details.dart';
import '../../common/user_interaction/tooltip.dart';
import '../../common/user_interaction/tooltip_rendering_details.dart';
import '../../common/utils/helper.dart';
import '../base/funnel_plot_area.dart';
import '../base/funnel_state_properties.dart';
import '../base/series_base.dart';
import '../renderer/renderer_extension.dart';

/// Renders the funnel chart.
///
/// A funnel chart is a specialized chart type that demonstrates the flow of users through a business or sales process.
/// The chart begins with a broad head and ends in a narrow neck.
///
/// The number of users at each stage of the process are indicated from the funnel's width as it narrows.
///
/// To render a funnel chart, create an instance of FunnelSeries, and add it to the series property of [SfFunnelChart].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=t3Dczqj8-10}
//ignore:must_be_immutable
class SfFunnelChart extends StatefulWidget {
  /// Creating an argument constructor of SfFunnelChart class.
  SfFunnelChart({
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
    ChartTitle? title,
    FunnelSeries<dynamic, dynamic>? series,
    EdgeInsets? margin,
    Legend? legend,
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
    TooltipBehavior? tooltipBehavior,
    ActivationMode? selectionGesture,
    bool? enableMultiSelection,
  })  : title = title ?? ChartTitle(),
        series = series ?? FunnelSeries<dynamic, dynamic>(),
        margin = margin ?? const EdgeInsets.fromLTRB(10, 10, 10, 10),
        legend = legend ?? const Legend(),
        tooltipBehavior = tooltipBehavior ?? TooltipBehavior(),
        selectionGesture = selectionGesture ?? ActivationMode.singleTap,
        enableMultiSelection = enableMultiSelection ?? false,
        super(key: key);

  /// Customizes the chart title.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            title: ChartTitle(text: 'Funnel Chart')
  ///        )
  ///    );
  ///}
  ///```
  final ChartTitle title;

  /// Background color of the chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            backgroundColor: Colors.blue
  ///        )
  ///    );
  ///}
  ///```
  final Color? backgroundColor;

  /// Border color of the chart.
  ///
  /// Defaults to `Colors.transparent`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            borderColor: Colors.blue
  ///        )
  ///   );
  ///}
  ///```
  final Color borderColor;

  /// Border width of the chart.
  ///
  /// Defaults to `0.0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            borderWidth: 2
  ///        )
  ///    );
  ///}
  ///```
  final double borderWidth;

  /// Customizes the chart series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            series: FunnelSeries<_FunnelData, String>(
  ///                          dataSource: data,
  ///                          xValueMapper: (_FunnelData data, _) => data.xData,
  ///                          yValueMapper: (_FunnelData data, _) => data.yData)
  ///        )
  ///    );
  ///}
  ///```
  final FunnelSeries<dynamic, dynamic> series;

  /// Margin for chart.
  ///
  /// Defaults to `const EdgeInsets.fromLTRB(10, 10, 10, 10)`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            margin: const EdgeInsets.all(2),
  ///        )
  ///    );
  ///}
  ///```
  final EdgeInsets margin;

  /// Customizes the legend in the chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            legend: Legend(isVisible: true)
  ///        )
  ///    );
  ///}
  ///```
  final Legend legend;

  /// Color palette for the data points in the chart series.
  ///
  /// If the series color is not specified, then the series will be rendered with appropriate palette color.
  ///
  /// Ten colors are available by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            palette: <Color>[Colors.red, Colors.green]
  ///        )
  ///    );
  ///}
  ///```
  final List<Color> palette;

  /// Customizes the tooltip in chart.
  ///
  ///```dart
  ///TooltipBehavior _tooltipBehavior;
  ///
  ///@override
  ///void initState() {
  ///   _tooltipBehavior = TooltipBehavior(enable: true);
  ///   super.initState();
  ///}
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            tooltipBehavior: _tooltipBehavior
  ///        )
  ///    );
  ///}
  ///```
  final TooltipBehavior tooltipBehavior;

  /// Occurs while legend is rendered.
  ///
  /// Here, you can get the legend's text, shape, series index, and point index case of funnel series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRendererArgs args) => legend(args),
  ///        )
  ///    );
  ///}
  ///void legend(LegendRendererArgs args) {
  ///   args.legendIconType = LegendIconType.diamond;
  ///}
  ///```
  final FunnelLegendRenderCallback? onLegendItemRender;

  /// Occurs while tooltip is rendered.
  ///
  /// Here, you can get the Tooltip render arguments and customize them.
  final FunnelTooltipCallback? onTooltipRender;

  /// Occurs when the data label is rendered.
  ///
  /// Here we can get get the data label render arguments and customize the data label parameters.
  final FunnelDataLabelRenderCallback? onDataLabelRender;

  /// Occurs when the legend is tapped, using this event the legend tap arguments can be customized.
  final ChartLegendTapCallback? onLegendTapped;

  /// Customizes the points or series selection behavior.
  ///
  /// It can also be selected at the initial rendering using this property.
  ///
  /// Defaults to `[]`.
  ///
  ///```dart
  ///SelectionBehavior _selectionBehavior;
  ///
  ///void initState() {
  ///   _selectionBehavior = SelectionBehavior(enable: true);
  ///   super.initState();
  ///}
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///           series: FunnelSeries<ChartData, String>(
  ///                  initialSelectedDataIndexes: <int>[1,0],
  ///                  selectionBehavior: _selectionBehavior
  ///             ),
  ///        )
  ///   );
  ///}
  ///```

  /// Gesture for activating the selection.
  ///
  /// Selection can be activated in `ActivationMode.none`, `ActivationMode.singleTap`,
  /// `ActivationMode.doubleTap`, and `ActivationMode.longPress`.
  ///
  /// Defaults to `ActivationMode.singleTap`.
  ///
  /// Also refer [ActivationMode].
  ///
  ///```dart
  ///SelectionBehavior _selectionBehavior;
  ///
  ///void initState() {
  ///   _selectionBehavior = SelectionBehavior(enable: true);
  ///   super.initState();
  ///}
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
  ///}
  ///```
  final ActivationMode selectionGesture;

  /// Enables or disables the multiple data points selection.
  ///
  /// Defaults to `false`.
  ///
  ///```dart
  ///SelectionBehavior _selectionBehavior;
  ///
  ///void initState() {
  ///   _selectionBehavior = SelectionBehavior(enable: true);
  ///   super.initState();
  ///}
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///           enableMultiSelection: true,
  ///           series: FunnelSeries<ChartData, String>(
  ///                  selectionBehavior: _selectionBehavior
  ///             ),
  ///        )
  ///    );
  ///}
  ///```
  final bool enableMultiSelection;

  /// Background image for chart.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            backgroundImage: const AssetImage('image.png'),
  ///        )
  ///    );
  ///}
  ///```
  final ImageProvider? backgroundImage;

  /// Occurs while selection changes. Here, you can get the series, selected color,
  /// unselected color, selected border color, unselected border color, selected
  /// border width, unselected border width, series index, and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            onSelectionChanged: (SelectionArgs args) => select(args),
  ///        )
  ///    );
  ///}
  ///void select(SelectionArgs args) {
  ///   print(args.selectedBorderColor);
  ///}
  ///```
  final FunnelSelectionCallback? onSelectionChanged;

  /// Occurs when tapped on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///     );
  ///}
  ///```
  final FunnelTouchInteractionCallback? onChartTouchInteractionUp;

  /// Occurs when touched on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            onChartTouchInteractionDown: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///     );
  ///}
  ///```
  final FunnelTouchInteractionCallback? onChartTouchInteractionDown;

  /// Occurs when touched and moved on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            onChartTouchInteractionMove: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  ///}
  ///```
  final FunnelTouchInteractionCallback? onChartTouchInteractionMove;

  /// Called when the data label is tapped.
  ///
  /// Whenever the data label is tapped, `onDataLabelTapped` callback will be called. Provides options to
  /// get the position of the data label, series index, point index and its text.
  ///
  /// _Note:_  This callback will not be called, when the builder is specified for data label
  /// (data label template). For this case, custom widget specified in the `DataLabelSettings.builder` property
  /// can be wrapped using the `GestureDetector` and this functionality can be achieved in the application level.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfFunnelChart(
  ///            onDataLabelTapped: (DataLabelTapDetails args) {
  ///                 print(arg.seriesIndex);
  ///                  }
  ///           )
  ///    );
  ///}
  ///
  ///```

  final DataLabelTapCallback? onDataLabelTapped;

  @override
  State<StatefulWidget> createState() => SfFunnelChartState();
}

/// Represents the state class of [SfFunnelChart] widget.
class SfFunnelChartState extends State<SfFunnelChart>
    with TickerProviderStateMixin {
  late FunnelStateProperties _stateProperties;

  /// Called when this object is inserted into the tree.
  ///
  /// The framework will call this method exactly once for each State object it creates.
  ///
  /// Override this method to perform initialization that depends on the location at
  /// which this object was inserted into the tree or on the widget used to configure this object.
  ///
  /// * In [initState], subscribe to the object.
  ///
  /// Here it overrides to initialize the object that depends on rendering the [SfFunnelChart].

  @override
  void initState() {
    _stateProperties = FunnelStateProperties(
        renderingDetails: RenderingDetails(), chartState: this);
    _initializeDefaultValues();
    // Create the series renderer while initial rendering //
    _createAndUpdateSeriesRenderer();
    super.initState();
  }

  /// Called when a dependency of this [State] object changes.
  ///
  /// For example, if the previous call to [build] referenced an [InheritedWidget] that later changed,
  /// the framework would call this method to notify this object about the change.
  ///
  /// This method is also called immediately after [initState]. It is safe to call [BuildContext.dependOnInheritedWidgetOfExactType] from this method.
  ///
  /// Here it called for initializing the chart theme of [SfFunnelChart].

  @override
  void didChangeDependencies() {
    _stateProperties.renderingDetails.chartTheme =
        _updateThemeData(context, Theme.of(context), SfChartTheme.of(context));
    _stateProperties.renderingDetails.themeData = Theme.of(context);
    _stateProperties.renderingDetails.isRtl =
        Directionality.of(context) == TextDirection.rtl;
    super.didChangeDependencies();
  }

  SfChartThemeData _updateThemeData(BuildContext context, ThemeData themeData,
      SfChartThemeData chartThemeData) {
    chartThemeData = chartThemeData.copyWith(
      titleTextStyle: themeData.textTheme.bodySmall!
          .copyWith(color: chartThemeData.titleTextColor, fontSize: 15)
          .merge(chartThemeData.titleTextStyle)
          .merge(widget.title.textStyle),
      legendTitleTextStyle: themeData.textTheme.bodySmall!
          .copyWith(color: chartThemeData.legendTitleColor)
          .merge(chartThemeData.legendTitleTextStyle)
          .merge(widget.legend.title.textStyle),
      legendTextStyle: themeData.textTheme.bodySmall!
          .copyWith(color: chartThemeData.legendTextColor, fontSize: 13)
          .merge(chartThemeData.legendTextStyle)
          .merge(widget.legend.textStyle),
      tooltipTextStyle: themeData.textTheme.bodySmall!
          .copyWith(
              color: widget.tooltipBehavior.color ??
                  chartThemeData.tooltipLabelColor)
          .merge(chartThemeData.tooltipTextStyle)
          .merge(widget.tooltipBehavior.textStyle),
    );
    return chartThemeData;
  }

  /// Called whenever the widget configuration changes.
  ///
  /// If the parent widget rebuilds and request that this location in the tree update to display a new widget with the same [runtimeType] and [Widget.key],
  /// the framework will update the widget property of this [State] object to refer to the new widget and then call this method with the previous widget as an argument.
  ///
  /// Override this method to respond when the widget changes.
  ///
  /// The framework always calls [build] after calling [didUpdateWidget], which means any calls to [setState] in [didUpdateWidget] are redundant.
  ///
  /// * In [didUpdateWidget] unsubscribe from the old object and subscribe to the new one if the updated widget configuration requires replacing the object.
  ///
  /// Here it called whenever the series collection gets updated in [SfFunnelChart].

  @override
  void didUpdateWidget(SfFunnelChart oldWidget) {
    //Update and maintain the series state, when we update the series in the series collection //
    _createAndUpdateSeriesRenderer(oldWidget);

    super.didUpdateWidget(oldWidget);
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            _stateProperties.renderingDetails.tooltipBehaviorRenderer);
    if (tooltipRenderingDetails.chartTooltipState != null) {
      tooltipRenderingDetails.show = false;
    }
    _stateProperties.renderingDetails.isLegendToggled = false;
    _stateProperties.renderingDetails.widgetNeedUpdate = true;
  }

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method in a number of different situations. For example:
  ///
  /// * After calling [initState].
  /// * After calling [didUpdateWidget].
  /// * After receiving a call to [setState].
  /// * After a dependency of this [State] object changes.
  ///
  /// Here it is called whenever the user interaction is performed and it removes the old widget and updates a chart with a new widget in [SfFunnelChart].

  @override
  Widget build(BuildContext context) {
    _stateProperties.renderingDetails.oldDeviceOrientation =
        _stateProperties.renderingDetails.oldDeviceOrientation == null
            ? MediaQuery.of(context).orientation
            : _stateProperties.renderingDetails.deviceOrientation;
    _stateProperties.renderingDetails.deviceOrientation =
        MediaQuery.of(context).orientation;
    _stateProperties.isTooltipOrientationChanged = false;
    return RepaintBoundary(
        child: ChartContainer(
            child: GestureDetector(
                child: Container(
                    decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        image: widget.backgroundImage != null
                            ? DecorationImage(
                                image: widget.backgroundImage!,
                                fit: BoxFit.fill)
                            : null,
                        border: Border.all(
                            color: widget.borderColor,
                            width: widget.borderWidth)),
                    child: Column(
                      children: <Widget>[
                        renderChartTitle(_stateProperties),
                        _renderChartElements()
                      ],
                    )))));
  }

  /// Called when this object is removed from the tree permanently.
  ///
  /// The framework calls this method when this [State] object will never build again. After the framework calls [dispose],
  /// the [State] object is considered unmounted and the [mounted] property is false. It is an error to call [setState] at this
  /// point. This stage of the life cycle is terminal: there is no way to remount a [State] object that has been disposed.
  ///
  /// Sub classes should override this method to release any resources retained by this object.
  ///
  /// * In [dispose], unsubscribe from the object.
  ///
  /// Here it end the animation controller of the series in [SfFunnelChart].

  @override
  void dispose() {
    disposeAnimationController(
        _stateProperties.renderingDetails.animationController,
        _repaintChartElements);
    super.dispose();
  }

  /// Method to convert the [SfFunnelChart] as an image.
  ///
  /// Returns the `dart:ui.image`.
  ///
  /// As this method is in the widget’s state class, you have to use a global key
  /// to access the state to call this method.
  ///
  /// ```dart
  /// final GlobalKey<SfFunnelChartState> _key = GlobalKey();
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Column(
  ///      children: [SfFunnelChart(
  ///        key: _key
  ///       series: FunnelSeries<_FunnelData, String>(
  ///                          dataSource: data,
  ///                          xValueMapper: (_FunnelData data, _) => data.xData,
  ///                          yValueMapper: (_FunnelData data, _) => data.yData)
  ///        ),
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
  ///           ],
  ///        ),
  ///    );
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
  ///}
  ///```

  Future<dart_ui.Image> toImage({double pixelRatio = 1.0}) async {
    final RenderRepaintBoundary boundary = context.findRenderObject()
        as RenderRepaintBoundary; //get the render object from context
    final dart_ui.Image image =
        await boundary.toImage(pixelRatio: pixelRatio); // Convert
    // the repaint boundary as image
    return image;
  }

  /// To initialize chart default values.
  void _initializeDefaultValues() {
    _stateProperties.chartSeries = FunnelChartBase(_stateProperties);
    _stateProperties.renderingDetails.chartLegend =
        ChartLegend(_stateProperties);
    _stateProperties.renderingDetails.initialRender = true;
    _stateProperties.renderingDetails.annotationController =
        AnimationController(vsync: this);
    _stateProperties.renderingDetails.seriesRepaintNotifier =
        ValueNotifier<int>(0);
    _stateProperties.renderingDetails.legendToggleStates =
        <LegendRenderContext>[];
    _stateProperties.renderingDetails.legendToggleTemplateStates =
        <MeasureWidgetContext>[];
    _stateProperties.renderingDetails.explodedPoints = <int>[];
    _stateProperties.renderingDetails.animateCompleted = false;
    _stateProperties.renderingDetails.isLegendToggled = false;
    _stateProperties.renderingDetails.widgetNeedUpdate = false;
    _stateProperties.renderingDetails.dataLabelTemplateRegions = <Rect>[];
    _stateProperties.renderingDetails.selectionData = <int>[];
    _stateProperties.renderingDetails.legendWidgetContext =
        <MeasureWidgetContext>[];
    _stateProperties.renderingDetails.animationController =
        AnimationController(vsync: this)..addListener(_repaintChartElements);
    _stateProperties.renderingDetails.tooltipBehaviorRenderer =
        TooltipBehaviorRenderer(_stateProperties);
    _stateProperties.renderingDetails.legendRenderer =
        LegendRenderer(widget.legend);
  }

  // In this method, create and update the series renderer for each series //
  void _createAndUpdateSeriesRenderer([SfFunnelChart? oldWidget]) {
    // ignore: unnecessary_null_comparison
    if (widget.series != null) {
      final FunnelSeriesRenderer? oldSeriesRenderer =
          // ignore: unnecessary_null_comparison
          oldWidget != null && oldWidget.series != null
              ? _stateProperties.chartSeries.visibleSeriesRenderers[0]
              : null;

      FunnelSeries<dynamic, dynamic> series;
      series = widget.series;

      // Create and update the series list here
      FunnelSeriesRendererExtension seriesRenderers;

      if (oldSeriesRenderer != null &&
          isSameSeries(oldWidget!.series, series)) {
        seriesRenderers = oldSeriesRenderer as FunnelSeriesRendererExtension;
      } else {
        final FunnelSeriesRenderer renderer = series.createRenderer(series);
        seriesRenderers = renderer is FunnelSeriesRendererExtension
            ? renderer
            : FunnelSeriesRendererExtension();
        if (seriesRenderers.controller == null &&
            series.onRendererCreated != null) {
          seriesRenderers.controller = FunnelSeriesController(seriesRenderers);
          series.onRendererCreated!(seriesRenderers.controller!);
        }
      }

      seriesRenderers.series = series;
      seriesRenderers.isSelectionEnable = series.selectionBehavior.enable;
      seriesRenderers.stateProperties = _stateProperties;
      _stateProperties.chartSeries.visibleSeriesRenderers
        ..clear()
        ..add(seriesRenderers);
    }
  }

  void _repaintChartElements() {
    _stateProperties.renderingDetails.seriesRepaintNotifier.value++;
  }

  /// To render chart elements.
  Widget _renderChartElements() {
    return Expanded(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      Widget element;
      if (widget.series.dataSource != null) {
        _initialize(constraints);
        _stateProperties.renderingDetails.prevSize =
            _stateProperties.renderingDetails.prevSize ?? constraints.biggest;
        _stateProperties.renderingDetails.didSizeChange =
            _stateProperties.renderingDetails.prevSize != constraints.biggest;
        _stateProperties.renderingDetails.prevSize = constraints.biggest;
        final PointInfo<dynamic> tooltipPoint =
            _getChartPoints(_stateProperties);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _validateStateMaintenance(_stateProperties, tooltipPoint);
        });
        _stateProperties.chartSeries.findVisibleSeries();
        _stateProperties.chartSeries.processDataPoints(
            _stateProperties.chartSeries.visibleSeriesRenderers[0]);
        final List<Widget> legendTemplates =
            bindLegendTemplateWidgets(_stateProperties);
        if (legendTemplates.isNotEmpty &&
            _stateProperties.renderingDetails.legendWidgetContext.isEmpty) {
          // ignore: avoid_unnecessary_containers
          element = Container(child: Stack(children: legendTemplates));
          SchedulerBinding.instance.addPostFrameCallback((_) => _refresh());
        } else {
          _stateProperties.renderingDetails.chartLegend.calculateLegendBounds(
              _stateProperties.renderingDetails.chartLegend.chartSize);
          _stateProperties.funnelplotArea =
              FunnelPlotArea(stateProperties: _stateProperties);
          element = getElements(
              _stateProperties, _stateProperties.funnelplotArea, constraints)!;
        }
      } else {
        element = Container();
      }
      return element;
    }));
  }

  /// To refresh chart elements.
  void _refresh() {
    if (_stateProperties.renderingDetails.legendWidgetContext.isNotEmpty) {
      MeasureWidgetContext templateContext;
      RenderBox renderBox;
      for (int i = 0;
          i < _stateProperties.renderingDetails.legendWidgetContext.length;
          i++) {
        templateContext =
            _stateProperties.renderingDetails.legendWidgetContext[i];
        renderBox = templateContext.context!.findRenderObject() as RenderBox;
        templateContext.size = renderBox.size;
      }
      _stateProperties.legendRefresh = true;
      setState(() {
        /// The chart will be rebuilding again, Once legend template sizes will be calculated.
      });
    }
  }

  /// To initialize chart container.
  void _initialize(BoxConstraints constraints) {
    _stateProperties.renderingDetails.chartWidgets = <Widget>[];
    final num width = constraints.maxWidth;
    final num height = constraints.maxHeight;
    final EdgeInsets margin = widget.margin;
    final bool isMobilePlatform =
        defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS;
    _stateProperties.renderingDetails.legendRenderer.legendPosition =
        widget.legend.position == LegendPosition.auto
            ? (height > width
                ? isMobilePlatform
                    ? LegendPosition.top
                    : LegendPosition.bottom
                : LegendPosition.right)
            : widget.legend.position;
    _stateProperties.renderingDetails.chartLegend.chartSize = Size(
        width - margin.left - margin.right,
        height - margin.top - margin.bottom);
  }

  /// This will return tooltip chart point.
  PointInfo<dynamic> _getChartPoints(FunnelStateProperties stateProperties) {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        stateProperties.renderingDetails.tooltipBehaviorRenderer;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(tooltipBehaviorRenderer);

    PointInfo<dynamic> tooltipChartPoint = PointInfo<dynamic>(null, null);

    if (stateProperties.renderingDetails.oldDeviceOrientation !=
            stateProperties.renderingDetails.deviceOrientation ||
        stateProperties.renderingDetails.didSizeChange) {
      if (tooltipRenderingDetails.showLocation != null &&
          stateProperties.chart.tooltipBehavior.enable == true &&
          stateProperties.isTooltipHidden == false) {
        tooltipChartPoint = pyramidFunnelPixelToPoint(
            tooltipRenderingDetails.showLocation!,
            stateProperties.chartSeries.visibleSeriesRenderers[0]);
      }
    }
    return tooltipChartPoint;
  }

  /// Here for orientation change/browser resize, the logic in this method will get executed.
  void _validateStateMaintenance(FunnelStateProperties stateProperties,
      PointInfo<dynamic> tooltipChartPoint) {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        stateProperties.renderingDetails.tooltipBehaviorRenderer;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(tooltipBehaviorRenderer);
    if (stateProperties.renderingDetails.oldDeviceOrientation !=
            stateProperties.renderingDetails.deviceOrientation ||
        stateProperties.renderingDetails.didSizeChange) {
      if (tooltipRenderingDetails.showLocation != null &&
          stateProperties.chart.tooltipBehavior.enable == true &&
          stateProperties.isTooltipHidden == false) {
        stateProperties.isTooltipOrientationChanged = true;
        late PointInfo<dynamic> point;
        late int index;
        for (int i = 0;
            i <
                stateProperties
                    .chartSeries.visibleSeriesRenderers[0].dataPoints.length;
            i++) {
          if (stateProperties
                      .chartSeries.visibleSeriesRenderers[0].dataPoints[i].x ==
                  tooltipChartPoint.x &&
              stateProperties
                      .chartSeries.visibleSeriesRenderers[0].dataPoints[i].y ==
                  tooltipChartPoint.y) {
            index = i;
            point = stateProperties
                .chartSeries.visibleSeriesRenderers[0].dataPoints[i];
          }
        }
        final Offset tooltipPosition = pyramidFunnelPointToPixel(
            point, stateProperties.chartSeries.visibleSeriesRenderers[0]);
        if (stateProperties.chart.tooltipBehavior.builder != null) {
          stateProperties.funnelplotArea.showFunnelTooltipTemplate(index);
        } else {
          tooltipRenderingDetails.internalShowByPixel(
              tooltipPosition.dx, tooltipPosition.dy);
        }
      }
    }
  }
}
