part of charts;

///Renders the circular chart
///
///The SfCircularChart supports pie, doughnut and radial bar series that can be customized within the Circular Charts class.
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
      @deprecated this.onPointTapped,
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
        legend = legend ?? Legend(),
        margin = margin ?? const EdgeInsets.fromLTRB(10, 10, 10, 10),
        centerX = centerX ?? '50%',
        centerY = centerY ?? '50%',
        tooltipBehavior = tooltipBehavior ?? TooltipBehavior(),
        selectionGesture = selectionGesture ?? ActivationMode.singleTap,
        enableMultiSelection = enableMultiSelection ?? false,
        super(key: key);

  ///Customizes the chart title
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            title: ChartTitle(text: 'Default rendering')
  ///        ));
  ///}
  ///```
  final ChartTitle title;

  ///Customizes the chart series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                enableTooltip: true,
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final List<CircularSeries<dynamic, dynamic>> series;

  ///Margin for chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            margin: const EdgeInsets.all(2),
  ///            borderColor: Colors.blue
  ///        ));
  ///}
  ///```
  final EdgeInsets margin;

  ///Customizes the legend in the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            legend: Legend(isVisible: true, position: LegendPosition.auto)
  ///        ));
  ///}
  ///```
  final Legend legend;

  ///Customizes the tooltip in chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            tooltipBehavior: TooltipBehavior(enable: true)
  ///        ));
  ///}
  ///```
  final TooltipBehavior tooltipBehavior;

  ///Background color of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final Color? backgroundColor;

  ///Customizes the annotations. Annotations are used to mark the specific area
  ///of interest in the plot area with texts, shapes, or images
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                   child Container(
  ///                   child: const Text('Empty data'),
  ///                    angle: 200,
  ///                    radius: '80%'
  ///                 ),
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///```
  final List<CircularChartAnnotation>? annotations;

  ///Border color of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            borderColor: Colors.red
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            borderWidth: 2,
  ///            borderColor: Colors.red
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Background image for chart.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            backgroundImage: const AssetImage('image.png'),
  ///        ));
  ///}
  ///```
  final ImageProvider? backgroundImage;

  ///X value for placing the chart.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            centerX: '50%'
  ///        ));
  ///}
  ///```
  final String centerX;

  ///Y value for placing the chart.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            centerY: '50%'
  ///        ));
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
  ///        ));
  ///}
  ///void legend(LegendRendererArgs args) {
  ///   args.legendIconType = LegendIconType.diamond;
  ///}
  ///```
  final CircularLegendRenderCallback? onLegendItemRender;

  /// Occurs while tooltip is rendered. You can customize the position and header. Here,
  /// you can get the text, header, point index, series, x and y-positions.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            tooltipBehavior: TooltipBehavior(enable: true)
  ///            onTooltipRender: (TooltipArgs args) => tool(args)
  ///        ));
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
  ///                enableTooltip: true,
  ///              ),
  ///             ],
  ///        ));
  ///}
  ///void dataLabel(DataLabelRenderArgs args) {
  ///    args.text = 'dataLabel';
  ///}
  ///```
  final CircularDatalabelRenderCallback? onDataLabelRender;

  /// Occurs when tapping a series point. Here, you can get the series, series index
  /// and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onPointTapped: (PointTapArgs args) => point(args),
  ///        ));
  ///}
  ///void point(PointTapArgs args) {
  ///   print(args.seriesIndex);
  ///}
  ///```
  @Deprecated('Use onPointTap in CircularSeries instead.')
  final CircularPointTapCallback? onPointTapped;

  ///Fills the data points with the gradient and image shaders.
  ///
  ///The data points of pie, doughnut and radial bar charts can be filled with [gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html)
  /// (linear, radial and sweep gradient) and [image shaders](https://api.flutter.dev/flutter/dart-ui/ImageShader-class.html).
  ///
  ///All the data points are together considered as a single segment and the shader is applied commonly.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onCreateShader: (ChartShaderDetails chartShaderDetails) => shader,
  ///        ));
  ///}
  ///```
  final CircularShaderCallback? onCreateShader;

  //Called when the data label is tapped.
  ///
  ///Whenever the data label is tapped, `onDataLabelTapped` callback will be called. Provides options to
  /// get the position of the data label, series index, point index and its text.
  ///
  ///_Note:_  This callback will not be called, when the builder is specified for data label
  /// (data label template). For this case, custom widget specified in the `DataLabelSettings.builder` property
  /// can be wrapped using the `GestureDetector` and this functionality can be achieved in the application level.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            onDataLabelTapped: (DataLabelTapDetails args) {
  ///                 print(arg.seriesIndex);
  ///                  }
  ///        ));
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
  ///        ));
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
  ///        ));
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
  ///        ));
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
  ///        ));
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
  ///        ));
  ///}
  ///```
  final CircularTouchInteractionCallback? onChartTouchInteractionMove;

  ///Color palette for the data points in the chart series. If the series color is
  ///not specified, then the series will be rendered with appropriate palette color.
  ///Ten colors are available by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            palette: <Color>[Colors.red, Colors.green]
  ///        ));
  ///}
  ///```
  final List<Color> palette;

  ///Gesture for activating the selection. Selection can be activated in tap,
  ///double tap, and long press.
  ///
  ///Defaults to `ActivationMode.tap`.
  ///
  ///Also refer [ActivationMode].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            selectionGesture: ActivationMode.singleTap,
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    selectedColor: Colors.red.withOpacity(0.8),
  ///                    unselectedColor: Colors.grey.withOpacity(0.5)
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ActivationMode selectionGesture;

  ///Enables or disables the multiple data points or series selection.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            enableMultiSelection: true,
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    selectedColor: Colors.red.withOpacity(0.8),
  ///                    unselectedColor: Colors.grey.withOpacity(0.5)
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool enableMultiSelection;

  @override
  State<StatefulWidget> createState() => SfCircularChartState();
}

/// Represents the state class of [SfCircularChart] widget
///
class SfCircularChartState extends State<SfCircularChart>
    with TickerProviderStateMixin {
  /// Specifies the center location
  late Offset _centerLocation;

  /// Specifies the annoatation region
  late List<Rect> _annotationRegions;

  /// Specifies the data label renderer
  _CircularDataLabelRenderer? _renderDataLabel;

  /// Specifies the previous series renderer
  CircularSeriesRenderer? _prevSeriesRenderer;

  /// Specifies the previous chart points
  List<ChartPoint<dynamic>?>? _oldPoints;

  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCircularChart get _chart => widget;

  /// Holds the information of SeriesBase class
  late _CircularSeries _chartSeries;

  /// Specifies the  circular chart area
  late _CircularArea _circularArea;

  /// Specifies whether move the label from center
  late bool _needToMoveFromCenter;

  /// Specifies whether to explode the segments
  late bool _needExplodeAll;

  /// Gets or sets the value for is toggled
  late bool _isToggled;

  /// Specifies the chart rendering details
  late _RenderingDetails _renderingDetails;

  // ignore: unused_element
  bool get _animationCompleted {
    return _renderingDetails.animationController.status !=
        AnimationStatus.forward;
  }

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
    _renderingDetails = _RenderingDetails();
    _renderingDetails.didSizeChange = false;
    _isToggled = false;
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
    _renderingDetails.chartTheme = SfChartTheme.of(context);
    super.didChangeDependencies();
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

    _needsRepaintCircularChart(_chartSeries.visibleSeriesRenderers,
        <CircularSeriesRenderer?>[_prevSeriesRenderer]);

    _needExplodeAll = widget.series.isNotEmpty &&
        (widget.series[0].explodeAll &&
            widget.series[0].explode &&
            oldWidget.series[0].explodeAll != widget.series[0].explodeAll);
    _renderingDetails.isLegendToggled = false;
    _renderingDetails.widgetNeedUpdate = true;
    if (_renderingDetails.legendWidgetContext.isNotEmpty) {
      _renderingDetails.legendWidgetContext.clear();
    }
    if (_renderingDetails.tooltipBehaviorRenderer._chartTooltipState != null) {
      _renderingDetails.tooltipBehaviorRenderer._show = false;
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
    _renderingDetails.initialRender = (_renderingDetails.widgetNeedUpdate &&
            !_renderingDetails.isLegendToggled)
        ? _needExplodeAll
        : (_renderingDetails.initialRender == null);
    _renderingDetails.oldDeviceOrientation =
        _renderingDetails.oldDeviceOrientation == null
            ? MediaQuery.of(context).orientation
            : _renderingDetails.deviceOrientation;
    _renderingDetails.deviceOrientation = MediaQuery.of(context).orientation;
    return RepaintBoundary(
        child: _ChartContainer(
      child: GestureDetector(
          child: Container(
        decoration: BoxDecoration(
            color: widget.backgroundColor ??
                _renderingDetails.chartTheme.plotAreaBackgroundColor,
            image: widget.backgroundImage != null
                ? DecorationImage(
                    image: widget.backgroundImage!, fit: BoxFit.fill)
                : null,
            border: Border.all(
                color: widget.borderColor, width: widget.borderWidth)),
        child: Column(
          children: <Widget>[_renderChartTitle(this), _renderChartElements()],
        ),
      )),
    ));
  }

  /// Called when this object is removed from the tree permanently.
  ///
  /// The framework calls this method when this [State] object will never build again. After the framework calls [dispose],
  /// the [State] object is considered unmounted and the [mounted] property is false. It is an error to call [setState] at this
  /// point. This stage of the lifecycle is terminal: there is no way to remount a [State] object that has been disposed.
  ///
  /// Subclasses should override this method to release any resources retained by this object.
  ///
  /// * In [dispose], unsubscribe from the object.
  ///
  /// Here it end the animation controller of the series in [SfCircularChart].

  @override
  void dispose() {
    _disposeAnimationController(
        _renderingDetails.animationController, _repaintChartElements);
    super.dispose();
  }

  /// Method to convert the [SfCircularChart] as an image.
  ///
  /// As this method is in the widget’s state class,
  /// you have to use a global key to access the state to call this method.
  /// Returns the `dart:ui.image`
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

  /// To intialize default values of circular chart
  void _initializeDefaultValues() {
    _chartSeries = _CircularSeries(this);
    _circularArea = _CircularArea(chartState: this);
    _renderingDetails.chartLegend = _ChartLegend(this);
    _needToMoveFromCenter = true;
    _renderingDetails.animateCompleted = false;
    _renderingDetails.annotationController = AnimationController(vsync: this);
    _renderingDetails.seriesRepaintNotifier = ValueNotifier<int>(0);
    _renderingDetails.legendWidgetContext = <_MeasureWidgetContext>[];
    _renderingDetails.explodedPoints = <int>[];
    _renderingDetails.templates = <_ChartTemplateInfo>[];
    _renderingDetails.legendToggleStates = <_LegendRenderContext>[];
    _renderingDetails.legendToggleTemplateStates = <_MeasureWidgetContext>[];
    _renderingDetails.dataLabelTemplateRegions = <Rect>[];
    _annotationRegions = <Rect>[];
    _renderingDetails.widgetNeedUpdate = false;
    _renderingDetails.isLegendToggled = false;
    _renderingDetails.selectionData = <int>[];
    _renderingDetails.animationController = AnimationController(vsync: this)
      ..addListener(_repaintChartElements);
    _renderingDetails.tooltipBehaviorRenderer = TooltipBehaviorRenderer(this);
    _renderingDetails.legendRenderer = LegendRenderer(widget.legend);
  }

  // In this method, create and update the series renderer for each series //
  void _createAndUpdateSeriesRenderer([SfCircularChart? oldWidget]) {
    if (widget.series.isNotEmpty) {
      final CircularSeriesRenderer? oldSeriesRenderer =
          oldWidget != null && oldWidget.series.isNotEmpty
              ? _chartSeries.visibleSeriesRenderers[0]
              : null;
      dynamic series;
      series = widget.series[0];

      CircularSeriesRenderer seriesRenderer;

      if (_prevSeriesRenderer != null &&
          !_prevSeriesRenderer!._chartState._isToggled &&
          _isSameSeries(_prevSeriesRenderer!._series, series)) {
        seriesRenderer = _prevSeriesRenderer!;
      } else {
        seriesRenderer = series.createRenderer(series);
        if (seriesRenderer._controller == null &&
            series.onRendererCreated != null) {
          seriesRenderer._controller = CircularSeriesController(seriesRenderer);
          series.onRendererCreated!(seriesRenderer._controller);
        }
      }
      if (oldWidget != null && oldWidget.series.isNotEmpty) {
        _prevSeriesRenderer = oldSeriesRenderer;
        _prevSeriesRenderer!._series = oldWidget.series[0];
        _prevSeriesRenderer!._oldRenderPoints = <ChartPoint<dynamic>>[]
          //ignore: prefer_spread_collections
          ..addAll(
              _prevSeriesRenderer!._renderPoints ?? <ChartPoint<dynamic>>[]);
        _prevSeriesRenderer!._renderPoints = <ChartPoint<dynamic>>[];
      }
      seriesRenderer._series = series;
      seriesRenderer._isSelectionEnable =
          series.selectionBehavior.enable == true;
      seriesRenderer._chartState = this;
      _chartSeries.visibleSeriesRenderers
        ..clear()
        ..add(seriesRenderer);
    }
  }

  void _repaintChartElements() {
    _renderingDetails.seriesRepaintNotifier.value++;
  }

  /// To redraw chart elements
  // ignore:unused_element
  void _redraw() {
    _renderingDetails.initialRender = false;
    if (_renderingDetails.isLegendToggled) {
      _isToggled = true;
      _prevSeriesRenderer = _chartSeries.visibleSeriesRenderers[0];
      _oldPoints = List<ChartPoint<dynamic>?>.filled(
          _prevSeriesRenderer!._renderPoints!.length, null);
      for (int i = 0; i < _prevSeriesRenderer!._renderPoints!.length; i++) {
        _oldPoints![i] = _prevSeriesRenderer!._renderPoints![i];
      }
    }
    if (_renderingDetails.tooltipBehaviorRenderer._chartTooltipState != null) {
      _renderingDetails.tooltipBehaviorRenderer._show = false;
    }
    setState(() {
      /// The chart will be rebuilding again, When we do the legend toggle, zoom/pan the chart.
    });
  }

  void _refresh() {
    final List<_MeasureWidgetContext> legendContexts =
        _renderingDetails.legendWidgetContext;
    if (legendContexts.isNotEmpty) {
      _MeasureWidgetContext templateContext;
      RenderBox renderBox;
      for (int i = 0; i < legendContexts.length; i++) {
        templateContext = legendContexts[i];
        renderBox = templateContext.context!.findRenderObject() as RenderBox;
        templateContext.size = renderBox.size;
      }
      setState(() {
        /// The chart will be rebuilding again, Once legend template sizes will be calculated.
      });
    }
  }

  /// To return widget with chart elements
  Widget _renderChartElements() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        Widget element;
        _renderingDetails.prevSize =
            _renderingDetails.prevSize ?? constraints.biggest;
        _renderingDetails.didSizeChange =
            _renderingDetails.prevSize != constraints.biggest;
        _renderingDetails.prevSize = constraints.biggest;
        _initialize(constraints);
        _chartSeries._findVisibleSeries();
        if (_chartSeries.visibleSeriesRenderers.isNotEmpty) {
          _chartSeries
              ._processDataPoints(_chartSeries.visibleSeriesRenderers[0]);
        }
        final List<Widget> legendTemplates = _bindLegendTemplateWidgets(this);
        if (legendTemplates.isNotEmpty &&
            _renderingDetails.legendWidgetContext.isEmpty) {
          element = Container(child: Stack(children: legendTemplates));
          SchedulerBinding.instance!.addPostFrameCallback((_) => _refresh());
        } else {
          _renderingDetails.chartLegend
              ._calculateLegendBounds(_renderingDetails.chartLegend.chartSize);
          element =
              _getElements(this, _CircularArea(chartState: this), constraints)!;
        }
        return element;
      }),
    );
  }

  /// To initialize chart widgets
  void _initialize(BoxConstraints constraints) {
    final num width = constraints.maxWidth;
    final num height = constraints.maxHeight;
    final EdgeInsets margin = widget.margin;
    _renderingDetails.legendRenderer._legendPosition =
        (widget.legend.position == LegendPosition.auto)
            ? (height > width ? LegendPosition.bottom : LegendPosition.right)
            : widget.legend.position;
    _renderingDetails.chartLegend.chartSize = Size(
        width - margin.left - margin.right,
        height - margin.top - margin.bottom);
  }
}

// ignore: must_be_immutable
class _CircularArea extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CircularArea({required this.chartState});
  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCircularChart get chart => chartState._chart;

  /// Specifies the chart state
  final SfCircularChartState chartState;

  /// Gets or sets the circular series
  CircularSeries<dynamic, dynamic>? series;

  /// Holds the render box of the circular chart
  late RenderBox renderBox;

  /// Specifies the point region
  _Region? pointRegion;

  /// Holds the tap down details
  late TapDownDetails tapDownDetails;

  /// Holds the double tap position
  Offset? doubleTapPosition;

  /// Specifies whether the mouse is hovered
  final bool _enableMouseHover = kIsWeb;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        child: MouseRegion(
            // Using the _enableMouseHover property, prevented mouse hover function in mobile platforms. The mouse hover event should not be triggered for mobile platforms and logged an issue regarding this to the Flutter team.
            // Issue:  https://github.com/flutter/flutter/issues/68690
            onHover: (PointerEvent event) =>
                _enableMouseHover ? _onHover(event) : null,
            onExit: (PointerEvent event) {
              chartState._renderingDetails.tooltipBehaviorRenderer._isHovering =
                  false;
            },
            child: Listener(
              onPointerUp: (PointerUpEvent event) => _onTapUp(event),
              onPointerDown: (PointerDownEvent event) => _onTapDown(event),
              onPointerMove: (PointerMoveEvent event) =>
                  _performPointerMove(event),
              child: GestureDetector(
                  onLongPress: _onLongPress,
                  onTapUp: (TapUpDetails details) {
                    if (chart.onPointTapped != null && pointRegion != null) {
                      _calculatePointSeriesIndex(
                          chart, chartState, null, pointRegion);
                    }
                    if (chart.series[0].onPointTap != null &&
                        pointRegion != null) {
                      _calculatePointSeriesIndex(chart, chartState, null,
                          pointRegion, ActivationMode.singleTap);
                    }
                  },
                  onDoubleTap: _onDoubleTap,
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: _initializeChart(constraints, context),
                    decoration: const BoxDecoration(color: Colors.transparent),
                  )),
            )),
      );
    });
  }

  /// To perform the pointer down event
  void _onTapDown(PointerDownEvent event) {
    ChartTouchInteractionArgs touchArgs;
    chartState._renderingDetails.tooltipBehaviorRenderer._isHovering = false;
    chartState._renderingDetails.currentActive = null;
    chartState._renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    pointRegion = _getCircularPointRegion(
        chart,
        chartState._renderingDetails.tapPosition,
        chartState._chartSeries.visibleSeriesRenderers[0]);
    doubleTapPosition = chartState._renderingDetails.tapPosition;
    if (chartState._renderingDetails.tapPosition != null &&
        pointRegion != null) {
      chartState._renderingDetails.currentActive = _ChartInteraction(
          pointRegion?.seriesIndex,
          pointRegion?.pointIndex,
          chartState._chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]._series,
          chartState
              ._chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]
              ._renderPoints![pointRegion!.pointIndex],
          pointRegion);
    } else {
      //hides the tooltip if the point of interaction is outside circular region of the chart
      chartState._renderingDetails.tooltipBehaviorRenderer._show = false;
      chartState._renderingDetails.tooltipBehaviorRenderer
          ._hideTooltipTemplate();
    }
    if (chart.onChartTouchInteractionDown != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = renderBox.globalToLocal(event.position);
      chart.onChartTouchInteractionDown!(touchArgs);
    }
  }

  /// To perform the pointer move event
  void _performPointerMove(PointerMoveEvent event) {
    ChartTouchInteractionArgs touchArgs;
    final Offset position = renderBox.globalToLocal(event.position);
    if (chart.onChartTouchInteractionMove != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = position;
      chart.onChartTouchInteractionMove!(touchArgs);
    }
  }

  /// To perform double tap touch interactions
  void _onDoubleTap() {
    if (doubleTapPosition != null && pointRegion != null) {
      if (chart.series[0].onPointDoubleTap != null && pointRegion != null) {
        _calculatePointSeriesIndex(
            chart, chartState, null, pointRegion, ActivationMode.doubleTap);
      }
      chartState._renderingDetails.currentActive = _ChartInteraction(
          pointRegion?.seriesIndex,
          pointRegion?.pointIndex,
          chartState._chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]._series,
          chartState
              ._chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]
              ._renderPoints![pointRegion!.pointIndex],
          pointRegion);
      if (chartState._renderingDetails.currentActive != null) {
        if (chartState._renderingDetails.currentActive?.series.explodeGesture ==
            ActivationMode.doubleTap) {
          chartState._chartSeries._seriesPointExplosion(
              chartState._renderingDetails.currentActive?.region);
        }
      }
      chartState._chartSeries
          ._seriesPointSelection(pointRegion, ActivationMode.doubleTap);
      if (chart.tooltipBehavior.enable &&
          chartState._renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.doubleTap &&
          doubleTapPosition != null) {
        if (chart.tooltipBehavior.builder != null) {
          _showCircularTooltipTemplate();
        } else {
          chartState._renderingDetails.tooltipBehaviorRenderer.onDoubleTap(
              doubleTapPosition!.dx.toDouble(),
              doubleTapPosition!.dy.toDouble());
        }
      }
    }
  }

  /// To perform long press touch interactions
  void _onLongPress() {
    if (chartState._renderingDetails.tapPosition != null &&
        pointRegion != null) {
      if (chart.series[0].onPointLongPress != null && pointRegion != null) {
        _calculatePointSeriesIndex(
            chart, chartState, null, pointRegion, ActivationMode.longPress);
      }
      chartState._renderingDetails.currentActive = _ChartInteraction(
          pointRegion?.seriesIndex,
          pointRegion?.pointIndex,
          chartState._chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]._series,
          chartState
              ._chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]
              ._renderPoints![pointRegion!.pointIndex],
          pointRegion);
      chartState._chartSeries
          ._seriesPointSelection(pointRegion, ActivationMode.longPress);
      if (chartState._renderingDetails.currentActive != null) {
        if (chartState._renderingDetails.currentActive?.series.explodeGesture ==
            ActivationMode.longPress) {
          chartState._chartSeries._seriesPointExplosion(
              chartState._renderingDetails.currentActive?.region);
        }
      }
      if (chart.tooltipBehavior.enable &&
          chartState._renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.longPress &&
          chartState._renderingDetails.tapPosition != null) {
        if (chart.tooltipBehavior.builder != null) {
          _showCircularTooltipTemplate();
        } else {
          chartState._renderingDetails.tooltipBehaviorRenderer.onLongPress(
              chartState._renderingDetails.tapPosition!.dx.toDouble(),
              chartState._renderingDetails.tapPosition!.dy.toDouble());
        }
      }
    }
  }

  /// To perform the pointer up event
  void _onTapUp(PointerUpEvent event) {
    chartState._renderingDetails.tooltipBehaviorRenderer._isHovering = false;
    ChartTouchInteractionArgs touchArgs;
    final CircularSeriesRenderer seriesRenderer =
        chartState._chartSeries.visibleSeriesRenderers[0];
    if (chart.onDataLabelTapped != null) {
      _triggerCircularDataLabelEvent(chart, seriesRenderer, chartState,
          chartState._renderingDetails.tapPosition);
    }
    if (chartState._renderingDetails.tapPosition != null) {
      if (chartState._renderingDetails.currentActive != null &&
          chartState._renderingDetails.currentActive!.series != null &&
          chartState._renderingDetails.currentActive!.series.explodeGesture ==
              ActivationMode.singleTap) {
        chartState._chartSeries._seriesPointExplosion(
            chartState._renderingDetails.currentActive!.region);
      }

      if (chartState._renderingDetails.tapPosition != null &&
          chartState._renderingDetails.currentActive != null) {
        chartState._chartSeries._seriesPointSelection(
            chartState._renderingDetails.currentActive!.region,
            ActivationMode.singleTap);
      }
      if (chart.tooltipBehavior.enable &&
          chartState._renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.singleTap &&
          chartState._renderingDetails.currentActive != null &&
          chartState._renderingDetails.currentActive!.series != null) {
        if (chart.tooltipBehavior.builder != null) {
          _showCircularTooltipTemplate();
        } else {
          final Offset position = renderBox.globalToLocal(event.position);
          chartState._renderingDetails.tooltipBehaviorRenderer
              .onTouchUp(position.dx.toDouble(), position.dy.toDouble());
        }
      }
      if (chart.onChartTouchInteractionUp != null) {
        touchArgs = ChartTouchInteractionArgs();
        touchArgs.position = renderBox.globalToLocal(event.position);
        chart.onChartTouchInteractionUp!(touchArgs);
      }
    }
    chartState._renderingDetails.tapPosition = null;
  }

  /// To perform  hover event
  void _onHover(PointerEvent event) {
    chartState._renderingDetails.currentActive = null;
    chartState._renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    pointRegion = _getCircularPointRegion(
        chart,
        chartState._renderingDetails.tapPosition,
        chartState._chartSeries.visibleSeriesRenderers[0]);
    final CircularSeriesRenderer seriesRenderer =
        chartState._chartSeries.visibleSeriesRenderers[0];
    if (chart.onDataLabelTapped != null) {
      _triggerCircularDataLabelEvent(chart, seriesRenderer, chartState,
          chartState._renderingDetails.tapPosition);
    }
    if (chartState._renderingDetails.tapPosition != null &&
        pointRegion != null) {
      chartState._renderingDetails.currentActive = _ChartInteraction(
          pointRegion!.seriesIndex,
          pointRegion!.pointIndex,
          chartState._chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]._series,
          chartState
              ._chartSeries
              .visibleSeriesRenderers[pointRegion!.seriesIndex]
              ._renderPoints![pointRegion!.pointIndex],
          pointRegion);
    } else {
      //hides the tooltip when the mouse is hovering out of the circular region
      chartState._renderingDetails.tooltipBehaviorRenderer._hide();
    }
    if (chartState._renderingDetails.tapPosition != null) {
      if (chart.tooltipBehavior.enable &&
          chartState._renderingDetails.currentActive != null &&
          chartState._renderingDetails.currentActive!.series != null) {
        chartState._renderingDetails.tooltipBehaviorRenderer._isHovering = true;
        if (chart.tooltipBehavior.builder != null) {
          _showCircularTooltipTemplate();
        } else {
          final Offset position = renderBox.globalToLocal(event.position);
          chartState._renderingDetails.tooltipBehaviorRenderer
              .onEnter(position.dx.toDouble(), position.dy.toDouble());
        }
      } else {
        chartState._renderingDetails.tooltipBehaviorRenderer._prevTooltipValue =
            null;
        chartState._renderingDetails.tooltipBehaviorRenderer
            ._currentTooltipValue = null;
      }
    }
    chartState._renderingDetails.tapPosition = null;
  }

  /// This method gets executed for showing tooltip when builder is provided in behavior
  ///the optional parameters will take values once thee public method gets called
  void _showCircularTooltipTemplate([int? seriesIndex, int? pointIndex]) {
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        chartState._renderingDetails.tooltipBehaviorRenderer;
    if (!tooltipBehaviorRenderer._isHovering) {
      //assingning null for the previous and current tooltip values in case of touch interaction
      tooltipBehaviorRenderer._prevTooltipValue = null;
      tooltipBehaviorRenderer._currentTooltipValue = null;
    }
    final CircularSeries<dynamic, dynamic> chartSeries =
        chartState._renderingDetails.currentActive?.series ??
            chart.series[seriesIndex!];
    final ChartPoint<dynamic> point = pointIndex == null
        ? chartState._renderingDetails.currentActive?.point
        : chartState
            ._chartSeries.visibleSeriesRenderers[0]._dataPoints[pointIndex];
    if (point.isVisible) {
      final Offset? location = _degreeToPoint(point.midAngle!,
          (point.innerRadius! + point.outerRadius!) / 2, point.center!);
      if (location != null && (chartSeries.enableTooltip)) {
        tooltipBehaviorRenderer._showLocation = location;
        tooltipBehaviorRenderer._chartTooltipState!.boundaryRect =
            tooltipBehaviorRenderer._tooltipBounds =
                chartState._renderingDetails.chartContainerRect;
        tooltipBehaviorRenderer._tooltipTemplate =
            chart.tooltipBehavior.builder!(
                chartSeries.dataSource![pointIndex ??
                    chartState._renderingDetails.currentActive!.pointIndex!],
                point,
                chartSeries,
                seriesIndex ??
                    chartState._renderingDetails.currentActive!.seriesIndex!,
                pointIndex ??
                    chartState._renderingDetails.currentActive!.pointIndex!);
        if (tooltipBehaviorRenderer._isHovering) {
          // assigning values for previous and current tooltip values when the mouse is hovering
          tooltipBehaviorRenderer._prevTooltipValue =
              tooltipBehaviorRenderer._currentTooltipValue;
          tooltipBehaviorRenderer._currentTooltipValue = TooltipValue(
              seriesIndex ??
                  chartState._renderingDetails.currentActive!.seriesIndex!,
              pointIndex ??
                  chartState._renderingDetails.currentActive!.pointIndex!);
        }
        if (!tooltipBehaviorRenderer._isHovering) {
          tooltipBehaviorRenderer._hideTooltipTemplate();
        }
        tooltipBehaviorRenderer._show = true;
        tooltipBehaviorRenderer._performTooltip();
      }
    }
  }

  /// To initialize chart widgets
  Widget _initializeChart(BoxConstraints constraints, BuildContext context) {
    _calculateContainerSize(constraints);
    if (chart.series.isNotEmpty) {
      chartState._chartSeries._calculateAngleAndCenterPositions(
          chartState._chartSeries.visibleSeriesRenderers[0]);
    }
    return Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: _renderWidgets(constraints, context));
  }

  /// To calculate chart rect area size
  void _calculateContainerSize(BoxConstraints constraints) {
    final num width = constraints.maxWidth;
    final num height = constraints.maxHeight;
    chartState._renderingDetails.chartContainerRect =
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    final EdgeInsets margin = chart.margin;
    chartState._renderingDetails.chartAreaRect = Rect.fromLTWH(
        margin.left,
        margin.top,
        width - margin.right - margin.left,
        height - margin.top - margin.bottom);
  }

  /// To render chart widgets
  Widget _renderWidgets(BoxConstraints constraints, BuildContext context) {
    _bindSeriesWidgets(context);
    _findTemplates();
    _renderTemplates();
    _bindTooltipWidgets(constraints);
    chartState._circularArea = this;
    renderBox = context.findRenderObject() as RenderBox;
    return Container(
        child: Stack(
            textDirection: TextDirection.ltr,
            children: chartState._renderingDetails.chartWidgets!));
  }

  /// To add chart templates
  void _findTemplates() {
    Offset labelLocation;
    const num lineLength = 10;
    ChartPoint<dynamic> point;
    Widget labelWidget;
    chartState._renderingDetails.templates = <_ChartTemplateInfo>[];
    chartState._renderingDetails.dataLabelTemplateRegions = <Rect>[];
    chartState._annotationRegions = <Rect>[];
    CircularSeriesRenderer seriesRenderer;
    CircularSeries<dynamic, dynamic> series;
    ConnectorLineSettings connector;
    ChartAlignment labelAlign;
    num connectorLength;
    for (int k = 0;
        k < chartState._chartSeries.visibleSeriesRenderers.length;
        k++) {
      seriesRenderer = chartState._chartSeries.visibleSeriesRenderers[k];
      series = seriesRenderer._series;
      connector = series.dataLabelSettings.connectorLineSettings;
      if (series.dataLabelSettings.isVisible &&
          series.dataLabelSettings.builder != null) {
        for (int i = 0; i < seriesRenderer._renderPoints!.length; i++) {
          point = seriesRenderer._renderPoints![i];
          if (point.isVisible) {
            labelWidget = series.dataLabelSettings.builder!(
                series.dataSource![i], point, series, i, k);
            if (series.dataLabelSettings.labelPosition ==
                ChartDataLabelPosition.inside) {
              labelLocation = _degreeToPoint(point.midAngle!,
                  (point.innerRadius! + point.outerRadius!) / 2, point.center!);
              labelLocation = Offset(labelLocation.dx, labelLocation.dy);
              labelAlign = ChartAlignment.center;
            } else {
              connectorLength = _percentToValue(
                  connector.length ?? '10%', point.outerRadius!)!;
              labelLocation = _degreeToPoint(point.midAngle!,
                  point.outerRadius! + connectorLength, point.center!);
              labelLocation = Offset(
                  point.dataLabelPosition == Position.right
                      ? labelLocation.dx + lineLength + 5
                      : labelLocation.dx - lineLength - 5,
                  labelLocation.dy);
              labelAlign = point.dataLabelPosition == Position.left
                  ? ChartAlignment.far
                  : ChartAlignment.near;
            }
            chartState._renderingDetails.templates.add(_ChartTemplateInfo(
                key: GlobalKey(),
                templateType: 'DataLabel',
                pointIndex: i,
                seriesIndex: k,
                needMeasure: true,
                clipRect: chartState._renderingDetails.chartAreaRect,
                animationDuration: 500,
                widget: labelWidget,
                horizontalAlignment: labelAlign,
                verticalAlignment: ChartAlignment.center,
                location: labelLocation));
          }
        }
      }
    }

    _setTemplateInfo();
  }

  /// Method to set the tempalte info
  void _setTemplateInfo() {
    CircularChartAnnotation annotation;
    double radius, annotationHeight, annotationWidth;
    _ChartTemplateInfo templateInfo;
    Offset point;
    if (chart.annotations != null && chart.annotations!.isNotEmpty) {
      for (int i = 0; i < chart.annotations!.length; i++) {
        annotation = chart.annotations![i];
        if (annotation.widget != null) {
          radius = _percentToValue(
                  annotation.radius, chartState._chartSeries.size / 2)!
              .toDouble();
          point = _degreeToPoint(
              annotation.angle, radius, chartState._centerLocation);
          annotationHeight = _percentToValue(
                  annotation.height, chartState._chartSeries.size / 2)!
              .toDouble();
          annotationWidth = _percentToValue(
                  annotation.width, chartState._chartSeries.size / 2)!
              .toDouble();
          templateInfo = _ChartTemplateInfo(
              key: GlobalKey(),
              templateType: 'Annotation',
              needMeasure: true,
              horizontalAlignment: annotation.horizontalAlignment,
              verticalAlignment: annotation.verticalAlignment,
              clipRect: chartState._renderingDetails.chartContainerRect,
              widget: annotationHeight > 0 && annotationWidth > 0
                  ? Container(
                      height: annotationHeight,
                      width: annotationWidth,
                      child: annotation.widget)
                  : annotation.widget!,
              pointIndex: i,
              animationDuration: 500,
              location: point);
          chartState._renderingDetails.templates.add(templateInfo);
        }
      }
    }
  }

  /// To render chart templates
  void _renderTemplates() {
    if (chartState._renderingDetails.templates.isNotEmpty) {
      for (int i = 0; i < chartState._renderingDetails.templates.length; i++) {
        chartState._renderingDetails.templates[i].animationDuration =
            !chartState._renderingDetails.initialRender!
                ? 0
                : chartState._renderingDetails.templates[i].animationDuration;
      }
      chartState._renderingDetails.chartTemplate = _ChartTemplate(
          templates: chartState._renderingDetails.templates,
          render: chartState._renderingDetails.animateCompleted,
          chartState: chartState);
      chartState._renderingDetails.chartWidgets!
          .add(chartState._renderingDetails.chartTemplate!);
    }
  }

  /// To add tooltip widgets to chart
  void _bindTooltipWidgets(BoxConstraints constraints) {
    chart.tooltipBehavior._chartState = chartState;
    final SfChartThemeData _chartTheme =
        chartState._renderingDetails.chartTheme;
    if (chart.tooltipBehavior.enable) {
      final TooltipBehavior tooltip = chart.tooltipBehavior;
      chartState._renderingDetails.tooltipBehaviorRenderer._prevTooltipValue =
          chartState._renderingDetails.tooltipBehaviorRenderer
              ._currentTooltipValue = null;
      chartState._renderingDetails.tooltipBehaviorRenderer._chartTooltip =
          SfTooltip(
              color: tooltip.color ?? _chartTheme.tooltipColor,
              key: GlobalKey(),
              textStyle: tooltip.textStyle,
              animationDuration: tooltip.animationDuration,
              animationCurve:
                  const Interval(0.1, 0.8, curve: Curves.easeOutBack),
              enable: tooltip.enable,
              opacity: tooltip.opacity,
              borderColor: tooltip.borderColor,
              borderWidth: tooltip.borderWidth,
              duration: tooltip.duration.toInt(),
              shouldAlwaysShow: tooltip.shouldAlwaysShow,
              elevation: tooltip.elevation,
              canShowMarker: tooltip.canShowMarker,
              textAlignment: tooltip.textAlignment,
              decimalPlaces: tooltip.decimalPlaces,
              labelColor:
                  tooltip.textStyle.color ?? _chartTheme.tooltipLabelColor,
              header: tooltip.header,
              format: tooltip.format,
              shadowColor: tooltip.shadowColor,
              onTooltipRender: chart.onTooltipRender != null
                  ? chartState._renderingDetails.tooltipBehaviorRenderer
                      ._tooltipRenderingEvent
                  : null);
      final Widget uiWidget = IgnorePointer(
          ignoring: true,
          child: Stack(children: <Widget>[
            chartState._renderingDetails.tooltipBehaviorRenderer._chartTooltip!
          ]));
      chartState._renderingDetails.chartWidgets!.add(uiWidget);
    }
  }

  /// To add series widgets in chart
  void _bindSeriesWidgets(BuildContext context) {
    late CustomPainter seriesPainter;
    Animation<double>? seriesAnimation;
    chartState._renderingDetails.animateCompleted = false;
    chartState._renderingDetails.chartWidgets ??= <Widget>[];
    CircularSeries<dynamic, dynamic> series;
    CircularSeriesRenderer seriesRenderer;
    dynamic selectionBehavior;
    SelectionBehaviorRenderer selectionBehaviorRenderer;
    for (int i = 0;
        i < chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      seriesRenderer = chartState._chartSeries.visibleSeriesRenderers[i];
      series = seriesRenderer._series;
      series.selectionBehavior._chartState = chartState;
      selectionBehavior =
          seriesRenderer._selectionBehavior = series.selectionBehavior;
      selectionBehaviorRenderer = seriesRenderer._selectionBehaviorRenderer =
          SelectionBehaviorRenderer(selectionBehavior, chart, chartState);
      selectionBehaviorRenderer._selectionRenderer ??= _SelectionRenderer();
      selectionBehaviorRenderer._selectionRenderer!.chart = chart;
      selectionBehaviorRenderer._selectionRenderer!._chartState = chartState;
      selectionBehaviorRenderer._selectionRenderer!.seriesRenderer =
          seriesRenderer;
      if (series.initialSelectedDataIndexes.isNotEmpty) {
        for (int index = 0;
            index < series.initialSelectedDataIndexes.length;
            index++) {
          chartState._renderingDetails.selectionData
              .add(series.initialSelectedDataIndexes[index]);
        }
      }
      chartState._renderingDetails.animateCompleted = false;
      if (series.animationDuration > 0 &&
          !chartState._renderingDetails.didSizeChange &&
          (chartState._renderingDetails.oldDeviceOrientation ==
              chartState._renderingDetails.deviceOrientation) &&
          (chartState._renderingDetails.initialRender! ||
              (chartState._renderingDetails.widgetNeedUpdate &&
                  seriesRenderer._needsAnimation) ||
              chartState._renderingDetails.isLegendToggled)) {
        chartState._renderingDetails.animationController.duration =
            Duration(milliseconds: series.animationDuration.toInt());
        seriesAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: chartState._renderingDetails.animationController,
          curve: const Interval(0.1, 0.8, curve: Curves.linear),
        )..addStatusListener((AnimationStatus status) {
                if (status == AnimationStatus.completed) {
                  chartState._renderingDetails.animateCompleted = true;
                  if (chartState._renderDataLabel != null) {
                    chartState._renderDataLabel!.state.render();
                  }
                  if (chartState._renderingDetails.chartTemplate != null) {
                    chartState._renderingDetails.chartTemplate!.state
                        .templateRender();
                  }
                }
              }));
        chartState._renderingDetails.chartElementAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: chartState._renderingDetails.animationController,
          curve: const Interval(0.85, 1.0, curve: Curves.decelerate),
        ));
        chartState._renderingDetails.animationController.forward(from: 0.0);
      } else {
        chartState._renderingDetails.animateCompleted = true;
      }
      seriesRenderer._repaintNotifier =
          chartState._renderingDetails.seriesRepaintNotifier;
      if (seriesRenderer._seriesType == 'pie') {
        seriesPainter = _PieChartPainter(
            chartState: chartState,
            index: i,
            isRepaint: seriesRenderer._needsRepaint,
            animationController:
                chartState._renderingDetails.animationController,
            seriesAnimation: seriesAnimation,
            notifier: chartState._renderingDetails.seriesRepaintNotifier);
      } else if (seriesRenderer._seriesType == 'doughnut') {
        seriesPainter = _DoughnutChartPainter(
            chartState: chartState,
            index: i,
            isRepaint: seriesRenderer._needsRepaint,
            animationController:
                chartState._renderingDetails.animationController,
            seriesAnimation: seriesAnimation,
            notifier: chartState._renderingDetails.seriesRepaintNotifier);
      } else if (seriesRenderer._seriesType == 'radialbar') {
        seriesPainter = _RadialBarPainter(
            chartState: chartState,
            index: i,
            isRepaint: seriesRenderer._needsRepaint,
            animationController:
                chartState._renderingDetails.animationController,
            seriesAnimation: seriesAnimation,
            notifier: chartState._renderingDetails.seriesRepaintNotifier);
      }
      chartState._renderingDetails.chartWidgets!
          .add(RepaintBoundary(child: CustomPaint(painter: seriesPainter)));
      chartState._renderDataLabel = _CircularDataLabelRenderer(
          circularChartState: chartState,
          show: chartState._renderingDetails.animateCompleted);
      chartState._renderingDetails.chartWidgets!
          .add(chartState._renderDataLabel!);
    }
  }
}
