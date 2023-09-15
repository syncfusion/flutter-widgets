import 'dart:ui' as dart_ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../chart/utils/enum.dart';
import '../../chart/utils/helper.dart';
import '../../common/common.dart';
import '../../common/legend/legend.dart';
import '../../common/legend/renderer.dart';
import '../../common/rendering_details.dart';
import '../../common/template/rendering.dart';
import '../../common/user_interaction/tooltip.dart';
import '../../common/user_interaction/tooltip_rendering_details.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/helper.dart';
import '../../common/utils/typedef.dart';
import '../renderer/chart_point.dart';
import '../renderer/circular_chart_annotation.dart';
import '../renderer/circular_series.dart';
import '../renderer/circular_series_controller.dart';
import '../renderer/common.dart';
import '../renderer/renderer_base.dart';
import '../renderer/renderer_extension.dart';
import '../utils/helper.dart';
import 'circular_area.dart';
import 'circular_state_properties.dart';
import 'series_base.dart';

/// Renders the circular chart.
///
/// The SfCircularChart widget supports pie, doughnut, and radial bar series that can be customized within the circular chart's class.
///
///```dart
///Widget build(BuildContext context) {
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
///  final String text;
/// }
/// ```
//ignore:must_be_immutable
class SfCircularChart extends StatefulWidget {
  /// Creating an argument constructor of SfCircularChart class.
  SfCircularChart(
      {Key? key,
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
      ChartTitle? title,
      EdgeInsets? margin,
      List<CircularSeries<dynamic, dynamic>>? series,
      Legend? legend,
      String? centerX,
      String? centerY,
      TooltipBehavior? tooltipBehavior,
      ActivationMode? selectionGesture,
      bool? enableMultiSelection})
      : series = series = series ?? <CircularSeries<dynamic, dynamic>>[],
        title = title ?? ChartTitle(),
        legend = legend ?? const Legend(),
        margin = margin ?? const EdgeInsets.fromLTRB(10, 10, 10, 10),
        centerX = centerX ?? '50%',
        centerY = centerY ?? '50%',
        tooltipBehavior = tooltipBehavior ?? TooltipBehavior(),
        selectionGesture = selectionGesture ?? ActivationMode.singleTap,
        enableMultiSelection = enableMultiSelection ?? false,
        super(key: key);

  /// Customizes the chart title.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            title: ChartTitle(text: 'Default rendering')
  ///        )
  ///   );
  ///}
  ///```
  final ChartTitle title;

  /// Customizes the chart series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                enableTooltip: true,
  ///              ),
  ///           ],
  ///        )
  ///    );
  ///}
  ///```
  final List<CircularSeries<dynamic, dynamic>> series;

  /// Specifies the margin for circular chart.
  ///
  /// Defaults to `const EdgeInsets.fromLTRB(10, 10, 10, 10)`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            margin: const EdgeInsets.all(2)
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
  ///        child: SfCircularChart(
  ///            legend: Legend(isVisible: true)
  ///        )
  ///    );
  ///}
  ///```
  final Legend legend;

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
  ///        child: SfCircularChart(
  ///            tooltipBehavior: _tooltipBehavior
  ///        )
  ///    );
  ///}
  ///```
  final TooltipBehavior tooltipBehavior;

  /// Background color of the chart.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            backgroundColor: Colors.blue
  ///        )
  ///    );
  ///}
  ///```
  final Color? backgroundColor;

  /// Customizes the annotations. Annotations are used to mark the specific area
  /// of interest in the plot area with texts, shapes, or images.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
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
  ///}
  ///```
  final List<CircularChartAnnotation>? annotations;

  /// Border color of the chart.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            borderColor: Colors.red
  ///        )
  ///    );
  ///}
  ///```
  final Color borderColor;

  /// Border width of the chart.
  ///
  /// Defaults to `0.0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            borderWidth: 2
  ///        )
  ///    );
  ///}
  ///```
  final double borderWidth;

  /// Background image for chart.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            backgroundImage: const AssetImage('image.png'),
  ///        )
  ///    );
  ///}
  ///```
  final ImageProvider? backgroundImage;

  /// X value for placing the chart. The value ranges from 0% to 100% and also
  /// if values are mentioned in pixel then the chart will moved accordingly.
  ///
  /// For example, if set `50%` means the x value place center of the chart area or
  /// we set `50` means the x value placed 50 pixel.
  ///
  /// Defaults to `50%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            centerX: '50%'
  ///        )
  ///    );
  ///}
  ///```
  final String centerX;

  /// Y value for placing the chart. The value ranges from 0% to 100% and also
  /// if values are mentioned in pixel then the chart will moved accordingly.
  ///
  /// For example,  if set `50%` means the y value place center of the chart area or
  /// we set `50` means the y value placed 50 pixel.
  ///
  /// Defaults to `50%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            centerY: '50%'
  ///        )
  ///    );
  ///}
  ///```
  final String centerY;

  /// Occurs while legend is rendered. Here, you can get the legend's text, shape
  /// series index, and point index case of circular series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRendererArgs args) => legend(args),
  ///        )
  ///    );
  ///}
  ///void legend(LegendRendererArgs args) {
  ///   args.legendIconType = LegendIconType.diamond;
  ///}
  ///```
  final CircularLegendRenderCallback? onLegendItemRender;

  /// Occurs while tooltip is rendered. You can customize the position and header. Here,
  /// you can get the text, header, point index, series, x and y-positions.
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
  ///        child: SfCircularChart(
  ///            tooltipBehavior: _tooltipBehavior,
  ///            onTooltipRender: (TooltipArgs args) => tool(args)
  ///        )
  ///    );
  ///}
  ///void tool(TooltipArgs args) {
  ///   args.locationX = 30;
  ///}
  ///```
  final CircularTooltipCallback? onTooltipRender;

  /// Occurs while rendering the data label. The data label and text styles such as color,
  /// font size, and font weight can be customized. You can get the series index, point
  /// index, text, and text style.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onDataLabelRender: (DataLabelRenderArgs args) => dataLabel(args),
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///               dataLabelSettings: DataLabelSettings(isVisible: true)
  ///              ),
  ///           ],
  ///        )
  ///    );
  ///}
  ///void dataLabel(DataLabelRenderArgs args) {
  ///    args.text = 'dataLabel';
  ///}
  ///```
  final CircularDatalabelRenderCallback? onDataLabelRender;

  /// Fills the data points with the gradient and image shaders.
  ///
  /// The data points of pie, doughnut and radial bar charts can be filled with [gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html)
  /// (linear, radial and sweep gradient) and [image shaders](https://api.flutter.dev/flutter/dart-ui/ImageShader-class.html).
  ///
  /// All the data points are together considered as a single segment and the shader is applied commonly.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///final List<Color> colors = <Color>[
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
  ///Widget build(BuildContext context) {
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
  ///}
  ///```
  final CircularShaderCallback? onCreateShader;

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
  ///        child: SfCircularChart(
  ///            onDataLabelTapped: (DataLabelTapDetails args) {
  ///                 print(arg.seriesIndex);
  ///                  }
  ///           )
  ///    );
  ///}
  ///
  ///```

  final DataLabelTapCallback? onDataLabelTapped;

  /// Occurs when the legend is tapped. Here, you can get the series,
  /// series index, and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onLegendTapped: (LegendTapArgs args) => legend(args),
  ///            legend: Legend(isVisible: true),
  ///        )
  ///    );
  ///}
  ///void legend(LegendTapArgs args) {
  ///   print(args.pointIndex);
  ///}
  ///```
  final ChartLegendTapCallback? onLegendTapped;

  /// Occurs while selection changes. Here, you can get the series, selected color,
  /// unselected color, selected border color, unselected border color, selected
  /// border width, unselected border width, series index, and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onSelectionChanged: (SelectionArgs args) => select(args),
  ///        )
  ///    );
  ///}
  ///void select(SelectionArgs args) {
  ///   print(args.selectedBorderColor);
  ///}
  ///```
  final CircularSelectionCallback? onSelectionChanged;

  /// Occurs when tapped on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  ///}
  ///```
  final CircularTouchInteractionCallback? onChartTouchInteractionUp;

  /// Occurs when touched on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onChartTouchInteractionDown: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  ///}
  ///```
  ///
  final CircularTouchInteractionCallback? onChartTouchInteractionDown;

  /// Occurs when touched and moved on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onChartTouchInteractionMove: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        )
  ///    );
  ///}
  ///```
  final CircularTouchInteractionCallback? onChartTouchInteractionMove;

  /// Color palette for the data points in the chart series. If the series color is
  /// not specified, then the series will be rendered with appropriate palette color.
  /// Ten colors are available by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            palette: <Color>[Colors.red, Colors.green]
  ///        )
  ///    );
  ///}
  ///```
  final List<Color> palette;

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
  ///        child: SfCircularChart(
  ///            selectionGesture: ActivationMode.singleTap,
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  selectionBehavior: _selectionBehavior
  ///                ),
  ///              ],
  ///        )
  ///    );
  ///}
  ///```
  final ActivationMode selectionGesture;

  /// Enables or disables the multiple data points or series selection.
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
  ///Widget build(BuildContext context) {
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
  ///}
  ///```
  final bool enableMultiSelection;

  @override
  State<StatefulWidget> createState() => SfCircularChartState();
}

/// Represents the state class of [SfCircularChart] widget.
///
class SfCircularChartState extends State<SfCircularChart>
    with TickerProviderStateMixin {
  /// Specifies the chart rendering details.
  late CircularStateProperties _stateProperties;

  /// Called when this object is inserted into the tree.
  ///
  /// The framework will call this method exactly once for each State object it creates.
  ///
  /// Override this method to perform initialization that depends on the location at
  /// which this object was inserted into the tree or on the widget used to configure this object.
  ///
  /// * In [initState], subscribe to the object.
  ///
  /// Here it overrides to initialize the object that depends on rendering the [SfCircularChart].

  @override
  void initState() {
    _stateProperties = CircularStateProperties(
        renderingDetails: RenderingDetails(), chartState: this);

    _stateProperties.isToggled = false;
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
  /// Here it called for initializing the chart theme of [SfCircularChart].

  @override
  void didChangeDependencies() {
    _stateProperties.renderingDetails.chartTheme =
        _updateThemeData(context, Theme.of(context), SfChartTheme.of(context));
    _stateProperties.renderingDetails.themeData = Theme.of(context);
    _stateProperties.isRtl = Directionality.of(context) == TextDirection.rtl;
    super.didChangeDependencies();
  }

  SfChartThemeData _updateThemeData(BuildContext context, ThemeData themeData,
      SfChartThemeData chartThemeData) {
    chartThemeData = chartThemeData.copyWith(
      titleTextStyle: themeData.textTheme.bodySmall!
          .copyWith(color: chartThemeData.titleTextColor, fontSize: 15)
          .merge(chartThemeData.titleTextStyle)
          .merge(widget.title.textStyle),
      tooltipTextStyle: themeData.textTheme.bodySmall!
          .copyWith(
              color: widget.tooltipBehavior.color ??
                  chartThemeData.tooltipLabelColor)
          .merge(chartThemeData.tooltipTextStyle)
          .merge(widget.tooltipBehavior.textStyle),
      legendTitleTextStyle: themeData.textTheme.bodySmall!
          .copyWith(color: chartThemeData.legendTitleColor)
          .merge(chartThemeData.legendTitleTextStyle)
          .merge(widget.legend.title.textStyle),
      legendTextStyle: themeData.textTheme.bodySmall!
          .copyWith(color: chartThemeData.legendTextColor, fontSize: 13)
          .merge(chartThemeData.legendTextStyle)
          .merge(widget.legend.textStyle),
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
  /// Here it called whenever the series collection gets updated in [SfCircularChart].

  @override
  void didUpdateWidget(SfCircularChart oldWidget) {
    //Update and maintain the series state, when we update the series in the series collection //
    _createAndUpdateSeriesRenderer(oldWidget);

    needsRepaintCircularChart(
        _stateProperties.chartSeries.visibleSeriesRenderers,
        <CircularSeriesRendererExtension?>[
          _stateProperties.prevSeriesRenderer
        ]);

    _stateProperties.needExplodeAll = widget.series.isNotEmpty &&
        (widget.series[0].explodeAll &&
            widget.series[0].explode &&
            oldWidget.series[0].explodeAll != widget.series[0].explodeAll);
    _stateProperties.renderingDetails.isLegendToggled = false;
    _stateProperties.renderingDetails.widgetNeedUpdate = true;
    if (_stateProperties.renderingDetails.legendWidgetContext.isNotEmpty) {
      _stateProperties.renderingDetails.legendWidgetContext.clear();
    }

    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(
            _stateProperties.renderingDetails.tooltipBehaviorRenderer);
    if (tooltipRenderingDetails.chartTooltipState != null) {
      tooltipRenderingDetails.show = false;
    }
    super.didUpdateWidget(oldWidget);
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
  /// Here it is called whenever the user interaction is performed and it removes the old widget and updates a chart with a new widget in [SfCircularChart].

  @override
  Widget build(BuildContext context) {
    _stateProperties.renderingDetails.initialRender =
        (_stateProperties.renderingDetails.widgetNeedUpdate &&
                !_stateProperties.renderingDetails.isLegendToggled)
            ? _stateProperties.needExplodeAll
            : (_stateProperties.renderingDetails.initialRender == null);
    _stateProperties.renderingDetails.oldDeviceOrientation =
        _stateProperties.renderingDetails.oldDeviceOrientation == null
            ? MediaQuery.of(context).orientation
            : _stateProperties.renderingDetails.deviceOrientation;
    _stateProperties.renderingDetails.deviceOrientation =
        MediaQuery.of(context).orientation;
    _stateProperties.isTooltipOrientationChanged = false;

    final Widget container = ChartContainer(
      child: GestureDetector(
          child: Container(
        decoration: BoxDecoration(
            color: widget.backgroundColor ??
                _stateProperties
                    .renderingDetails.chartTheme.plotAreaBackgroundColor,
            image: widget.backgroundImage != null
                ? DecorationImage(
                    image: widget.backgroundImage!, fit: BoxFit.fill)
                : null,
            border: Border.all(
                color: widget.borderColor, width: widget.borderWidth)),
        child: Column(
          children: <Widget>[
            renderChartTitle(_stateProperties),
            _renderChartElements()
          ],
        ),
      )),
    );
    return RepaintBoundary(child: container);
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
  /// Here it end the animation controller of the series in [SfCircularChart].

  @override
  void dispose() {
    disposeAnimationController(
        _stateProperties.renderingDetails.animationController,
        _repaintChartElements);
    super.dispose();
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

  /// To initialize default values of circular chart.
  void _initializeDefaultValues() {
    _stateProperties.chartSeries = CircularSeriesBase(_stateProperties);
    _stateProperties.circularArea =
        CircularArea(stateProperties: _stateProperties);
    _stateProperties.renderingDetails.chartLegend =
        ChartLegend(_stateProperties);
    _stateProperties.needToMoveFromCenter = true;
    _stateProperties.renderingDetails.animateCompleted = false;
    _stateProperties.renderingDetails.annotationController =
        AnimationController(vsync: this);
    _stateProperties.renderingDetails.seriesRepaintNotifier =
        ValueNotifier<int>(0);
    _stateProperties.renderingDetails.legendWidgetContext =
        <MeasureWidgetContext>[];
    _stateProperties.renderingDetails.explodedPoints = <int>[];
    _stateProperties.renderingDetails.templates = <ChartTemplateInfo>[];
    _stateProperties.renderingDetails.legendToggleStates =
        <LegendRenderContext>[];
    _stateProperties.renderingDetails.legendToggleTemplateStates =
        <MeasureWidgetContext>[];
    _stateProperties.renderingDetails.dataLabelTemplateRegions = <Rect>[];
    _stateProperties.annotationRegions = <Rect>[];
    _stateProperties.renderingDetails.widgetNeedUpdate = false;
    _stateProperties.renderingDetails.isLegendToggled = false;
    _stateProperties.renderingDetails.selectionData = <int>[];
    _stateProperties.renderingDetails.animationController =
        AnimationController(vsync: this)..addListener(_repaintChartElements);
    _stateProperties.renderingDetails.tooltipBehaviorRenderer =
        TooltipBehaviorRenderer(_stateProperties);
    _stateProperties.renderingDetails.legendRenderer =
        LegendRenderer(widget.legend);
  }

  /// In this method, create and update the series renderer for each series.
  void _createAndUpdateSeriesRenderer([SfCircularChart? oldWidget]) {
    if (widget.series.isNotEmpty) {
      final CircularSeriesRendererExtension? oldSeriesRenderer =
          oldWidget != null && oldWidget.series.isNotEmpty
              ? _stateProperties.chartSeries.visibleSeriesRenderers[0]
              : null;
      dynamic series;
      series = widget.series[0];

      CircularSeriesRendererExtension? seriesRenderer;

      if (_stateProperties.prevSeriesRenderer != null &&
          !_stateProperties.prevSeriesRenderer!.stateProperties.isToggled &&
          isSameSeries(_stateProperties.prevSeriesRenderer!.series, series)) {
        seriesRenderer = _stateProperties.prevSeriesRenderer!;
      } else {
        final CircularSeriesRenderer renderer = series.createRenderer(series);
        if (renderer is CircularSeriesRendererExtension) {
          seriesRenderer = renderer;
        } else {
          if (renderer is PieSeriesRenderer) {
            seriesRenderer = PieSeriesRendererExtension();
          } else if (renderer is DoughnutSeriesRenderer) {
            seriesRenderer = DoughnutSeriesRendererExtension();
          } else if (renderer is RadialBarSeriesRenderer) {
            seriesRenderer = RadialBarSeriesRendererExtension();
          }
        }
        seriesRenderer!.renderer = ChartSeriesRender();
        if (seriesRenderer.controller == null &&
            series.onRendererCreated != null) {
          seriesRenderer.controller = CircularSeriesController(seriesRenderer);
          series.onRendererCreated!(seriesRenderer.controller);
        }
      }
      if (oldWidget != null && oldWidget.series.isNotEmpty) {
        _stateProperties.prevSeriesRenderer = oldSeriesRenderer;
        _stateProperties.prevSeriesRenderer!.series = oldWidget.series[0];
        _stateProperties.prevSeriesRenderer!.oldRenderPoints =
            <ChartPoint<dynamic>>[]
              //ignore: prefer_spread_collections
              ..addAll(_stateProperties.prevSeriesRenderer!.renderPoints ??
                  <ChartPoint<dynamic>>[]);
        _stateProperties.prevSeriesRenderer!.renderPoints =
            <ChartPoint<dynamic>>[];
      }
      seriesRenderer.series = series;
      seriesRenderer.isSelectionEnable =
          series.selectionBehavior.enable == true;
      seriesRenderer.stateProperties = _stateProperties;
      _stateProperties.chartSeries.visibleSeriesRenderers
        ..clear()
        ..add(seriesRenderer);
    }
  }

  void _repaintChartElements() {
    _stateProperties.renderingDetails.seriesRepaintNotifier.value++;
  }

  void _refresh() {
    final List<MeasureWidgetContext> legendContexts =
        _stateProperties.renderingDetails.legendWidgetContext;
    if (legendContexts.isNotEmpty) {
      MeasureWidgetContext templateContext;
      RenderBox renderBox;
      for (int i = 0; i < legendContexts.length; i++) {
        templateContext = legendContexts[i];
        renderBox = templateContext.context!.findRenderObject() as RenderBox;
        templateContext.size = renderBox.size;
      }
      _stateProperties.legendRefresh = true;
      setState(() {
        /// The chart will be rebuilding again, Once legend template sizes will be calculated.
      });
    }
  }

  /// To return widget with chart elements.
  Widget _renderChartElements() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        Widget element;
        _initialize(constraints);
        _stateProperties.renderingDetails.prevSize =
            _stateProperties.renderingDetails.prevSize ?? constraints.biggest;
        _stateProperties.renderingDetails.didSizeChange =
            _stateProperties.renderingDetails.prevSize != constraints.biggest;
        _stateProperties.renderingDetails.prevSize = constraints.biggest;
        final ChartPoint<dynamic> tooltipPoint =
            _getChartPoints(_stateProperties);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _validateStateMaintenance(_stateProperties, tooltipPoint);
        });
        _stateProperties.chartSeries.findVisibleSeries();
        if (_stateProperties.chartSeries.visibleSeriesRenderers.isNotEmpty) {
          _stateProperties.chartSeries.processDataPoints(
              _stateProperties.chartSeries.visibleSeriesRenderers[0]);
        }
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
          element = getElements(_stateProperties,
              CircularArea(stateProperties: _stateProperties), constraints)!;
        }
        return element;
      }),
    );
  }

  /// To initialize chart widgets.
  void _initialize(BoxConstraints constraints) {
    final num width = constraints.maxWidth;
    final num height = constraints.maxHeight;
    final EdgeInsets margin = widget.margin;
    final bool isMobilePlatform =
        defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS;
    _stateProperties.renderingDetails.legendRenderer.legendPosition =
        (widget.legend.position == LegendPosition.auto)
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
  ChartPoint<dynamic> _getChartPoints(CircularStateProperties stateProperties) {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        stateProperties.renderingDetails.tooltipBehaviorRenderer;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(tooltipBehaviorRenderer);

    ChartPoint<dynamic> tooltipChartPoint = ChartPoint<dynamic>();

    if (stateProperties.renderingDetails.oldDeviceOrientation !=
            stateProperties.renderingDetails.deviceOrientation ||
        stateProperties.renderingDetails.didSizeChange) {
      if (tooltipRenderingDetails.showLocation != null &&
          stateProperties.chart.tooltipBehavior.enable == true &&
          stateProperties.isTooltipHidden == false &&
          stateProperties.requireDataLabelTooltip == null) {
        tooltipChartPoint = circularPixelToPoint(
            tooltipRenderingDetails.showLocation!, stateProperties);
      }
    }
    return tooltipChartPoint;
  }

  /// Here for orientation change/browser resize, the logic in this method will get executed.
  void _validateStateMaintenance(CircularStateProperties stateProperties,
      ChartPoint<dynamic> tooltipChartPoint) {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        stateProperties.renderingDetails.tooltipBehaviorRenderer;
    final TooltipRenderingDetails tooltipRenderingDetails =
        TooltipHelper.getRenderingDetails(tooltipBehaviorRenderer);
    if (stateProperties.renderingDetails.oldDeviceOrientation !=
            stateProperties.renderingDetails.deviceOrientation ||
        stateProperties.renderingDetails.didSizeChange) {
      if (tooltipRenderingDetails.showLocation != null &&
          stateProperties.chart.tooltipBehavior.enable &&
          !stateProperties.isTooltipHidden &&
          stateProperties.requireDataLabelTooltip == null) {
        stateProperties.isTooltipOrientationChanged = true;
        ChartPoint<dynamic>? point;
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
            point = stateProperties
                .chartSeries.visibleSeriesRenderers[0].dataPoints[i];
          }
        }
        if (point != null) {
          final Offset tooltipPosition =
              circularPointToPixel(point, stateProperties);
          if (stateProperties.chart.tooltipBehavior.builder != null) {
            stateProperties.circularArea
                .showCircularTooltipTemplate(0, point.index);
          } else {
            tooltipRenderingDetails.internalShowByPixel(
                tooltipPosition.dx, tooltipPosition.dy);
          }
        }
      }
    }
  }
}
