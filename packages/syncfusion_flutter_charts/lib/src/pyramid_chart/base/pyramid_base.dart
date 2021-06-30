part of charts;

///Renders the pyramid chart
///
///To render a pyramid chart, create an instance of PyramidSeries, and add it to the series property of SfPyramidChart
///
///Properties such as opacity, [borderWidth], [borderColor], pointColorMapper
///are used to customize the appearance of a pyramid segment.
//ignore:must_be_immutable
class SfPyramidChart extends StatefulWidget {
  /// Creating an argument constructor of SfPyramidChart class.
  SfPyramidChart({
    Key? key,
    this.backgroundColor,
    this.backgroundImage,
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
    ChartTitle? title,
    PyramidSeries<dynamic, dynamic>? series,
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
    SmartLabelMode? smartLabelMode,
    ActivationMode? selectionGesture,
    bool? enableMultiSelection,
  })  : title = title ?? ChartTitle(),
        series = series ?? PyramidSeries<dynamic, dynamic>(),
        margin = margin ?? const EdgeInsets.fromLTRB(10, 10, 10, 10),
        legend = legend ?? Legend(),
        tooltipBehavior = tooltipBehavior ?? TooltipBehavior(),
        smartLabelMode = smartLabelMode ?? SmartLabelMode.hide,
        selectionGesture = selectionGesture ?? ActivationMode.singleTap,
        enableMultiSelection = enableMultiSelection ?? false,
        super(key: key);

  ///Customizes the chart title
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            title: ChartTitle(text: 'Pyramid Chart')
  ///        ));
  ///}
  ///```
  final ChartTitle title;

  ///Background color of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final Color? backgroundColor;

  ///Background color of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Customizes the chart series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<_PyramidData, String>(
  ///                          dataSource: data,
  ///                          xValueMapper: (_PyramidData data, _) => data.xData,
  ///                          yValueMapper: (_PyramidData data, _) => data.yData)
  ///        ));
  ///}
  ///```
  final PyramidSeries<dynamic, dynamic> series;

  ///Margin for chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            margin: const EdgeInsets.all(2),
  ///        ));
  ///}
  ///```
  final EdgeInsets margin;

  ///Customizes the legend in the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            legend: Legend(isVisible: true)
  ///        ));
  ///}
  ///```
  final Legend legend;

  ///Color palette for the data points in the chart series.
  ///
  ///If the series color is not specified, then the series will be rendered with appropriate palette color.
  ///Ten colors are available by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            palette: <Color>[Colors.red, Colors.green]
  ///        ));
  ///}
  ///```
  final List<Color> palette;

  ///Customizes the tooltip in chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            tooltipBehavior: TooltipBehavior(enable: true)
  ///        ));
  ///}
  ///```
  final TooltipBehavior tooltipBehavior;

  /// Occurs while legend is rendered.
  ///
  /// Here, you can get the legend's text, shape, series index, and point index case of circular series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRendererArgs args) => legend(args),
  ///        ));
  ///}
  ///void legend(LegendRendererArgs args) {
  ///   args.legendIconType = LegendIconType.diamond;
  ///}
  ///```
  final PyramidLegendRenderCallback? onLegendItemRender;

  /// Occurs when the tooltip is rendered.
  ///
  /// Here,you can get the tooltip arguments and customize the arguments.
  final PyramidTooltipCallback? onTooltipRender;

  /// Occurs when the datalabel is rendered,Here datalabel arguments can be customized.
  final PyramidDataLabelRenderCallback? onDataLabelRender;

  /// Occurs when the legend is tapped,the arguments can be used to customize the legend arguments
  final ChartLegendTapCallback? onLegendTapped;

  /// Smart labelmode to avoid the overlapping of labels.
  final SmartLabelMode smartLabelMode;

  ///Data points or series can be selected while performing interaction on the chart.
  ///
  ///It can also be selected at the initial rendering using this property.
  ///
  ///Defaults to `[]`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///           series: PyramidSeries<ChartData, String>(
  ///                  initialSelectedDataIndexes: <int>[1,0],
  ///                  selectionBehavior: SelectionBehavior(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///        ));
  ///}
  ///```

  ///Gesture for activating the selection.
  ///
  /// Selection can be activated in tap, double tap, and long press.
  ///
  ///Defaults to `ActivationMode.tap`.
  ///
  ///Also refer [ActivationMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///           selectionGesture: ActivationMode.singleTap,
  ///           series: PyramidSeries<ChartData, String>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///        ));
  ///}
  ///```
  final ActivationMode selectionGesture;

  ///Enables or disables the multiple data points selection.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///           enableMultiSelection: true,
  ///           series: PyramidSeries<ChartData, String>(
  ///                  selectionBehavior: SelectionBehavior(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///        ));
  ///}
  ///```
  final bool enableMultiSelection;

  ///Background image for chart.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            backgroundImage: const AssetImage('image.png'),
  ///        ));
  ///}
  ///```
  final ImageProvider? backgroundImage;

  /// Occurs while selection changes. Here, you can get the series, selected color,
  /// unselected color, selected border color, unselected border color, selected
  /// border width, unselected border width, series index, and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onSelectionChanged: (SelectionArgs args) => select(args),
  ///        ));
  ///}
  ///void select(SelectionArgs args) {
  ///   print(args.selectedBorderColor);
  ///}
  ///```
  final PyramidSelectionCallback? onSelectionChanged;

  /// Occurs when tapping a series point. Here, you can get the series, series index
  /// and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onPointTapped: (PointTapArgs args) => point(args),
  ///        ));
  ///}
  ///void point(PointTapArgs args) {
  ///   print(args.pointIndex);
  ///}
  ///```
  @Deprecated('Use onPointTap in PyramidSeries instead.')
  final PyramidPointTapCallback? onPointTapped;

  //Called when the data label is tapped.
  ///
  ///Whenever the data label is tapped, `onDataLabelTapped` callback will be called. Provides options to
  /// get the position of the data label, series index, point index and its text.
  ///
  ///_Note:_  This callback will not be called, when the builder is specified for data label
  /// (data label template). For this case, custom widget specified in the `DataLabelSettings.builder` property
  /// can be wrapped using the `GestureDetector` and this functionality can be achieved in the application level.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onDataLabelTapped: (DataLabelTapDetails args) {
  ///                 print(arg.seriesIndex);
  ///                  }
  ///        ));
  ///}
  ///
  ///```
  final DataLabelTapCallback? onDataLabelTapped;

  /// Occurs when tapped on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final PyramidTouchInteractionCallback? onChartTouchInteractionUp;

  /// Occurs when touched and moved on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onChartTouchInteractionMove: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final PyramidTouchInteractionCallback? onChartTouchInteractionMove;

  /// Occurs when touched on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onChartTouchInteractionDown: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final PyramidTouchInteractionCallback? onChartTouchInteractionDown;

  @override
  State<StatefulWidget> createState() => SfPyramidChartState();
}

/// Represents the state class of [SfPyramidChart] widget
///
class SfPyramidChartState extends State<SfPyramidChart>
    with TickerProviderStateMixin {
  _PyramidDataLabelRenderer? _renderDataLabel;
  int? _tooltipPointIndex;
  //Internal variables
  late String _seriesType;
  late List<PointInfo<dynamic>> _dataPoints;
  List<PointInfo<dynamic>>? _renderPoints;
  late _PyramidSeries _chartSeries;
  late _PyramidPlotArea _chartPlotArea;

  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfPyramidChart get _chart => widget;

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
  /// Here it overrides to initialize the object that depends on rendering the [SfPyramidChart].

  @override
  void initState() {
    _renderingDetails = _RenderingDetails();
    _renderingDetails.didSizeChange = false;
    _initializeDefaultValues();
    //Update and maintain the series state, when we update the series in the series collection //
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
  /// Here it called for initializing the chart theme of [SfPyramidChart].

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
  /// Here it called whenever the series collection gets updated in [SfPyramidChart].

  @override
  void didUpdateWidget(SfPyramidChart oldWidget) {
    //Update and maintain the series state, when we update the series in the series collection //
    _createAndUpdateSeriesRenderer(oldWidget);
    if (_renderingDetails.tooltipBehaviorRenderer._chartTooltipState != null) {
      _renderingDetails.tooltipBehaviorRenderer._show = false;
    }
    super.didUpdateWidget(oldWidget);
    _renderingDetails.widgetNeedUpdate = true;
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
  /// Here it is called whenever the user interaction is performed and it removes the old widget and updates a chart with a new widget in [SfPyramidChart].

  @override
  Widget build(BuildContext context) {
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
                        _renderChartTitle(this),
                        _renderChartElements()
                      ],
                    )))));
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
  /// Here it end the animation controller of the series in [SfPyramidChart].

  @override
  void dispose() {
    _disposeAnimationController(
        _renderingDetails.animationController, _repaintChartElements);
    super.dispose();
  }

  /// Method to convert the [SfPyramidChart] as an image.
  ///
  /// Returns the `dart:ui.image`
  ///
  /// As this method is in the widget’s state class,
  ///  you have to use a global key to access the state to call this method.
  ///
  /// ```dart
  ///final GlobalKey<SfPyramidChartState> _key = GlobalKey();
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Column(
  ///      children: [SfPyramidChart(
  ///        key: _key
  ///            series: PyramidSeries<_PyramidData, String>(
  ///                          dataSource: data,
  ///                          xValueMapper: (_PyramidData data, _) => data.xData,
  ///                          yValueMapper: (_PyramidData data, _) => data.yData)
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

  /// To intialize default chart elements value
  void _initializeDefaultValues() {
    _chartSeries = _PyramidSeries(this);
    _renderingDetails.chartLegend = _ChartLegend(this);
    _chartPlotArea = _PyramidPlotArea(chartState: this);
    _renderingDetails.initialRender = true;
    _renderingDetails.annotationController = AnimationController(vsync: this);
    _renderingDetails.seriesRepaintNotifier = ValueNotifier<int>(0);
    _renderingDetails.legendToggleStates = <_LegendRenderContext>[];
    _renderingDetails.legendToggleTemplateStates = <_MeasureWidgetContext>[];
    _renderingDetails.explodedPoints = <int>[];
    _renderingDetails.animateCompleted = false;
    _renderingDetails.isLegendToggled = false;
    _renderingDetails.widgetNeedUpdate = false;
    _renderingDetails.legendWidgetContext = <_MeasureWidgetContext>[];
    _renderingDetails.dataLabelTemplateRegions = <Rect>[];
    _renderingDetails.selectionData = <int>[];
    _renderingDetails.animationController = AnimationController(vsync: this)
      ..addListener(_repaintChartElements);
    _renderingDetails.tooltipBehaviorRenderer = TooltipBehaviorRenderer(this);
    _renderingDetails.legendRenderer = LegendRenderer(widget.legend);
  }

  // In this method, create and update the series renderer for each series //
  void _createAndUpdateSeriesRenderer([SfPyramidChart? oldWidget]) {
    // ignore: unnecessary_null_comparison
    if (widget.series != null) {
      final PyramidSeriesRenderer? oldSeriesRenderer =
          // ignore: unnecessary_null_comparison
          oldWidget != null && oldWidget.series != null
              ? _chartSeries.visibleSeriesRenderers[0]
              : null;
      PyramidSeries<dynamic, dynamic> series;
      series = widget.series;

      // Create and update the series list here
      PyramidSeriesRenderer seriesRenderers;

      if (oldSeriesRenderer != null &&
          _isSameSeries(oldWidget!.series, series)) {
        seriesRenderers = oldSeriesRenderer;
      } else {
        seriesRenderers = series.createRenderer(series);
        if (seriesRenderers._controller == null &&
            series.onRendererCreated != null) {
          seriesRenderers._controller =
              PyramidSeriesController(seriesRenderers);
          series.onRendererCreated!(seriesRenderers._controller!);
        }
      }

      seriesRenderers._series = series;
      seriesRenderers._isSelectionEnable = series.selectionBehavior.enable;
      seriesRenderers._chartState = this;
      _chartSeries.visibleSeriesRenderers
        ..clear()
        ..add(seriesRenderers);
    }
  }

  void _repaintChartElements() {
    _renderingDetails.seriesRepaintNotifier.value++;
  }

  /// To render chart elements
  Widget _renderChartElements() {
    return Expanded(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      Widget element;
      _renderingDetails.prevSize =
          _renderingDetails.prevSize ?? constraints.biggest;
      _renderingDetails.didSizeChange =
          _renderingDetails.prevSize != constraints.biggest;
      _renderingDetails.prevSize = constraints.biggest;
      if (widget.series.dataSource != null) {
        _initialize(constraints);

        _chartSeries._findVisibleSeries();
        _chartSeries._processDataPoints();
        final List<Widget> legendTemplates = _bindLegendTemplateWidgets(this);
        if (legendTemplates.isNotEmpty &&
            _renderingDetails.legendWidgetContext.isEmpty) {
          element = Container(child: Stack(children: legendTemplates));
          SchedulerBinding.instance!.addPostFrameCallback((_) => _refresh());
        } else {
          _renderingDetails.chartLegend
              ._calculateLegendBounds(_renderingDetails.chartLegend.chartSize);
          element = _getElements(
              this, _PyramidPlotArea(chartState: this), constraints)!;
        }
      } else {
        element = Container();
      }
      return element;
    }));
  }

  void _refresh() {
    final List<_MeasureWidgetContext> legendWidgetContexts =
        _renderingDetails.legendWidgetContext;
    if (legendWidgetContexts.isNotEmpty) {
      _MeasureWidgetContext templateContext;
      RenderBox renderBox;
      for (int i = 0; i < legendWidgetContexts.length; i++) {
        templateContext = legendWidgetContexts[i];
        renderBox = templateContext.context!.findRenderObject() as RenderBox;
        templateContext.size = renderBox.size;
      }
      setState(() {
        /// The chart will be rebuilding again, Once legend template sizes will be calculated.
      });
    }
  }

  // ignore:unused_element
  void _redraw() {
    _renderingDetails.initialRender = false;
    if (_renderingDetails.tooltipBehaviorRenderer._chartTooltipState != null) {
      _renderingDetails.tooltipBehaviorRenderer._show = false;
    }
    setState(() {
      /// The chart will be rebuilding again, When we do the legend toggle, zoom/pan the chart.
    });
  }

  /// To intialize chart container area
  void _initialize(BoxConstraints constraints) {
    _renderingDetails.chartWidgets = <Widget>[];
    final num width = constraints.maxWidth;
    final num height = constraints.maxHeight;
    final EdgeInsets margin = widget.margin;
    final LegendRenderer legendRenderer = _renderingDetails.legendRenderer;
    legendRenderer._legendPosition =
        widget.legend.position == LegendPosition.auto
            ? (height > width ? LegendPosition.bottom : LegendPosition.right)
            : widget.legend.position;

    _renderingDetails.chartLegend.chartSize = Size(
        width - margin.left - margin.right,
        height - margin.top - margin.bottom);
  }
}

// ignore: must_be_immutable
class _PyramidPlotArea extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PyramidPlotArea({required this.chartState});
  final SfPyramidChartState chartState;
  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfPyramidChart get chart => chartState._chart;
  late PyramidSeriesRenderer seriesRenderer;
  late RenderBox renderBox;
  _Region? pointRegion;
  late TapDownDetails tapDownDetails;
  Offset? doubleTapPosition;
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
                chartState._renderingDetails.tooltipBehaviorRenderer
                    ._isHovering = false;
              },
              child: Stack(textDirection: TextDirection.ltr, children: <Widget>[
                _initializeChart(constraints, context),
                Listener(
                  onPointerUp: (PointerUpEvent event) => _onTapUp(event),
                  onPointerDown: (PointerDownEvent event) => _onTapDown(event),
                  onPointerMove: (PointerMoveEvent event) =>
                      _performPointerMove(event),
                  child: GestureDetector(
                      onLongPress: _onLongPress,
                      onDoubleTap: _onDoubleTap,
                      onTapUp: (TapUpDetails details) {
                        chartState._renderingDetails.tapPosition =
                            renderBox.globalToLocal(details.globalPosition);
                        if (chart.onPointTapped != null &&
                            // ignore: unnecessary_null_comparison
                            seriesRenderer != null) {
                          _calculatePointSeriesIndex(chart, seriesRenderer,
                              chartState._renderingDetails.tapPosition!);
                        }
                        if (chart.series.onPointTap != null &&
                            // ignore: unnecessary_null_comparison
                            seriesRenderer != null) {
                          _calculatePointSeriesIndex(
                              chart,
                              seriesRenderer,
                              chartState._renderingDetails.tapPosition!,
                              null,
                              ActivationMode.singleTap);
                        }
                      },
                      child: Container(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                      )),
                ),
              ])));
    });
  }

  /// To initialize chart
  Widget _initializeChart(BoxConstraints constraints, BuildContext context) {
    _calculateContainerSize(constraints);
    return GestureDetector(
        child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: _renderWidgets(constraints, context)));
  }

  /// To calculate chart plot area
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

  Widget _renderWidgets(BoxConstraints constraints, BuildContext context) {
    _bindSeriesWidgets();
    _calculatePathRegion();
    _findTemplates(chartState);
    _renderTemplates(chartState);
    _bindTooltipWidgets(constraints);
    renderBox = context.findRenderObject() as RenderBox;
    chartState._chartPlotArea = this;
    return Container(
        child: Stack(
            textDirection: TextDirection.ltr,
            children: chartState._renderingDetails.chartWidgets!));
  }

  /// To calculate region path of pyramid
  void _calculatePathRegion() {
    final List<PyramidSeriesRenderer> visibleSeriesRenderers =
        chartState._chartSeries.visibleSeriesRenderers;
    if (visibleSeriesRenderers.isNotEmpty) {
      seriesRenderer = visibleSeriesRenderers[0];
      for (int i = 0; i < seriesRenderer._renderPoints!.length; i++) {
        if (seriesRenderer._renderPoints![i].isVisible) {
          chartState._chartSeries._calculatePathRegion(i, seriesRenderer);
        }
      }
    }
  }

  /// To bind series widget together
  void _bindSeriesWidgets() {
    late CustomPainter seriesPainter;
    Animation<double>? seriesAnimation;
    PyramidSeries<dynamic, dynamic> series;
    final List<PyramidSeriesRenderer> visibleSeriesRenderers =
        chartState._chartSeries.visibleSeriesRenderers;
    SelectionBehaviorRenderer selectionBehaviorRenderer;
    dynamic selectionBehavior;
    for (int i = 0; i < visibleSeriesRenderers.length; i++) {
      seriesRenderer = visibleSeriesRenderers[i];
      series = seriesRenderer._series;
      series.selectionBehavior._chartState = chartState;
      chartState._chartSeries._initializeSeriesProperties(seriesRenderer);
      selectionBehavior =
          seriesRenderer._selectionBehavior = series.selectionBehavior;
      selectionBehaviorRenderer = seriesRenderer._selectionBehaviorRenderer =
          SelectionBehaviorRenderer(selectionBehavior, chart, chartState);
      selectionBehaviorRenderer = seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer._selectionRenderer ??= _SelectionRenderer();
      selectionBehaviorRenderer._selectionRenderer!.chart = chart;
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
      if (series.animationDuration > 0 &&
          !chartState._renderingDetails.didSizeChange &&
          (chartState._renderingDetails.deviceOrientation ==
              chartState._renderingDetails.oldDeviceOrientation) &&
          ((!chartState._renderingDetails.widgetNeedUpdate &&
                  chartState._renderingDetails.initialRender!) ||
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
                    chartState._renderDataLabel!.state?.render();
                  }
                  if (chartState._renderingDetails.chartTemplate != null &&
                      // ignore: unnecessary_null_comparison
                      chartState._renderingDetails.chartTemplate!.state !=
                          null) {
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
        if (chartState._renderDataLabel != null) {
          chartState._renderDataLabel!.state?.render();
        }
      }
      seriesRenderer._repaintNotifier =
          chartState._renderingDetails.seriesRepaintNotifier;
      if (seriesRenderer._seriesType == 'pyramid') {
        seriesPainter = _PyramidChartPainter(
            chartState: chartState,
            seriesIndex: i,
            isRepaint: seriesRenderer._needsRepaint,
            animationController:
                chartState._renderingDetails.animationController,
            seriesAnimation: seriesAnimation,
            notifier: chartState._renderingDetails.seriesRepaintNotifier);
      }
      chartState._renderingDetails.chartWidgets!
          .add(RepaintBoundary(child: CustomPaint(painter: seriesPainter)));
      chartState._renderDataLabel = _PyramidDataLabelRenderer(
          key: GlobalKey(),
          chartState: chartState,
          //ignore: avoid_bool_literals_in_conditional_expressions
          show: !chartState._renderingDetails.widgetNeedUpdate
              ? chartState._renderingDetails.animationController.status ==
                      AnimationStatus.completed ||
                  chartState._renderingDetails.animationController.duration ==
                      null
              : true);
      chartState._renderingDetails.chartWidgets!
          .add(chartState._renderDataLabel!);
    }
  }

  /// To bind tooltip widgets
  void _bindTooltipWidgets(BoxConstraints constraints) {
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        chartState._renderingDetails.tooltipBehaviorRenderer;
    tooltip._chartState = chartState;
    if (tooltip.enable) {
      final SfChartThemeData _chartTheme =
          chartState._renderingDetails.chartTheme;
      tooltipBehaviorRenderer._prevTooltipValue =
          tooltipBehaviorRenderer._currentTooltipValue = null;
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
      chartState._renderingDetails.chartWidgets!
          .add(tooltipBehaviorRenderer._chartTooltip!);
    }
  }

  /// To perform pointer down event
  void _onTapDown(PointerDownEvent event) {
    chartState._renderingDetails.tooltipBehaviorRenderer._isHovering = false;
    //renderBox = context.findRenderObject();
    chartState._renderingDetails.currentActive = null;
    chartState._renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    bool isPoint = false;
    const int seriesIndex = 0;
    late int pointIndex;
    final List<PyramidSeriesRenderer> visibleSeriesRenderers =
        chartState._chartSeries.visibleSeriesRenderers;
    final PyramidSeriesRenderer seriesRenderer =
        visibleSeriesRenderers[seriesIndex];
    ChartTouchInteractionArgs touchArgs;
    for (int j = 0; j < seriesRenderer._renderPoints!.length; j++) {
      if (chart.onDataLabelRender != null) {
        seriesRenderer._dataPoints[j].labelRenderEvent = false;
      }
      if (seriesRenderer._renderPoints![j].isVisible && !isPoint) {
        isPoint = _isPointInPolygon(seriesRenderer._renderPoints![j].pathRegion,
            chartState._renderingDetails.tapPosition!);
        if (isPoint) {
          pointIndex = j;
          if (chart.onDataLabelRender == null) {
            break;
          }
        }
      }
    }
    doubleTapPosition = chartState._renderingDetails.tapPosition;
    if (chartState._renderingDetails.tapPosition != null && isPoint) {
      chartState._renderingDetails.currentActive = _ChartInteraction(
        seriesIndex,
        pointIndex,
        visibleSeriesRenderers[seriesIndex]._series,
        visibleSeriesRenderers[seriesIndex]._renderPoints![pointIndex],
      );
    } else {
      //hides the tooltip if the point of interaction is outside pyramid region of the chart
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

  /// To perform pointer move event
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
    const int seriesIndex = 0;
    if (doubleTapPosition != null &&
        chartState._renderingDetails.currentActive != null) {
      if (chart.series.onPointDoubleTap != null &&
          // ignore: unnecessary_null_comparison
          seriesRenderer != null) {
        _calculatePointSeriesIndex(
            chart,
            seriesRenderer,
            chartState._renderingDetails.tapPosition!,
            null,
            ActivationMode.doubleTap);
        chartState._renderingDetails.tapPosition = null;
      }
      final int pointIndex =
          chartState._renderingDetails.currentActive!.pointIndex!;
      final List<PyramidSeriesRenderer> visibleSeriesRenderers =
          chartState._chartSeries.visibleSeriesRenderers;
      chartState._renderingDetails.currentActive = _ChartInteraction(
          seriesIndex,
          pointIndex,
          visibleSeriesRenderers[seriesIndex]._series,
          visibleSeriesRenderers[seriesIndex]._renderPoints![pointIndex]);
      if (chartState._renderingDetails.currentActive != null) {
        if (chartState._renderingDetails.currentActive!.series.explodeGesture ==
            ActivationMode.doubleTap) {
          chartState._chartSeries._pointExplode(pointIndex);
          final GlobalKey key = chartState._renderDataLabel!.key as GlobalKey;
          final _PyramidDataLabelRendererState _pyramidDataLabelRendererState =
              key.currentState as _PyramidDataLabelRendererState;
          _pyramidDataLabelRendererState.dataLabelRepaintNotifier.value++;
        }
      }
      chartState._chartSeries
          ._seriesPointSelection(pointIndex, ActivationMode.doubleTap);
      if (chart.tooltipBehavior.enable &&
          chartState._renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.doubleTap) {
        if (chart.tooltipBehavior.builder != null) {
          _showPyramidTooltipTemplate();
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
    const int seriesIndex = 0;
    if (chartState._renderingDetails.tapPosition != null &&
        chartState._renderingDetails.currentActive != null) {
      if (chart.series.onPointLongPress != null &&
          // ignore: unnecessary_null_comparison
          seriesRenderer != null) {
        _calculatePointSeriesIndex(
            chart,
            seriesRenderer,
            chartState._renderingDetails.tapPosition!,
            null,
            ActivationMode.longPress);
        chartState._renderingDetails.tapPosition = null;
      }
      final List<PyramidSeriesRenderer> visibleSeriesRenderers =
          chartState._chartSeries.visibleSeriesRenderers;
      final int pointIndex =
          chartState._renderingDetails.currentActive!.pointIndex!;
      chartState._renderingDetails.currentActive = _ChartInteraction(
          seriesIndex,
          pointIndex,
          visibleSeriesRenderers[seriesIndex]._series,
          visibleSeriesRenderers[seriesIndex]._renderPoints![pointIndex],
          pointRegion);
      chartState._chartSeries
          ._seriesPointSelection(pointIndex, ActivationMode.longPress);
      if (chartState._renderingDetails.currentActive != null) {
        if (chartState._renderingDetails.currentActive!.series.explodeGesture ==
            ActivationMode.longPress) {
          chartState._chartSeries._pointExplode(pointIndex);
          final GlobalKey key = chartState._renderDataLabel!.key as GlobalKey;
          final _PyramidDataLabelRendererState _pyramidDataLabelRendererState =
              key.currentState as _PyramidDataLabelRendererState;
          _pyramidDataLabelRendererState.dataLabelRepaintNotifier.value++;
        }
      }
      if (chart.tooltipBehavior.enable &&
          chartState._renderingDetails.animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.longPress) {
        if (chart.tooltipBehavior.builder != null) {
          _showPyramidTooltipTemplate();
        } else {
          chartState._renderingDetails.tooltipBehaviorRenderer.onLongPress(
              chartState._renderingDetails.tapPosition!.dx.toDouble(),
              chartState._renderingDetails.tapPosition!.dy.toDouble());
        }
      }
    }
  }

  /// To perform pointer up event
  void _onTapUp(PointerUpEvent event) {
    chartState._renderingDetails.tooltipBehaviorRenderer._isHovering = false;
    bool isPoint = false;
    chartState._renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    for (int j = 0; j < seriesRenderer._renderPoints!.length; j++) {
      if (seriesRenderer._renderPoints![j].isVisible) {
        isPoint = _isPointInPolygon(seriesRenderer._renderPoints![j].pathRegion,
            chartState._renderingDetails.tapPosition!);
        if (isPoint) {
          break;
        }
      }
    }
    final _ChartInteraction? currentActive =
        isPoint ? chartState._renderingDetails.currentActive! : null;
    ChartTouchInteractionArgs touchArgs;
    if (currentActive != null) {
      // ignore: unnecessary_null_comparison
      if (chart.onDataLabelTapped != null && seriesRenderer != null) {
        _triggerPyramidDataLabelEvent(chart, seriesRenderer, chartState,
            chartState._renderingDetails.tapPosition!);
      }
      if (chartState._renderingDetails.tapPosition != null &&
          chartState._renderingDetails.currentActive != null) {
        if (currentActive.series != null &&
            currentActive.series.explodeGesture == ActivationMode.singleTap) {
          chartState._chartSeries._pointExplode(currentActive.pointIndex!);
          final GlobalKey key = chartState._renderDataLabel!.key as GlobalKey;
          final _PyramidDataLabelRendererState _pyramidDataLabelRendererState =
              key.currentState as _PyramidDataLabelRendererState;
          _pyramidDataLabelRendererState.dataLabelRepaintNotifier.value++;
        }

        if (chartState
            ._chartSeries.visibleSeriesRenderers[0]._isSelectionEnable) {
          chartState._chartSeries._seriesPointSelection(
              currentActive.pointIndex!, ActivationMode.singleTap);
        }

        if (chart.tooltipBehavior.enable &&
            chartState._renderingDetails.animateCompleted &&
            chart.tooltipBehavior.activationMode == ActivationMode.singleTap &&
            currentActive.series != null) {
          if (chart.tooltipBehavior.builder != null) {
            _showPyramidTooltipTemplate();
          } else {
            final Offset position = renderBox.globalToLocal(event.position);
            chartState._renderingDetails.tooltipBehaviorRenderer
                .onTouchUp(position.dx.toDouble(), position.dy.toDouble());
          }
        }
      }
    }
    if (chart.onChartTouchInteractionUp != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = renderBox.globalToLocal(event.position);
      chart.onChartTouchInteractionUp!(touchArgs);
    }
    if (chart.series.onPointTap == null &&
        chart.series.onPointDoubleTap == null &&
        chart.series.onPointLongPress == null) {
      chartState._renderingDetails.tapPosition = null;
    }
  }

  /// To perform event on mouse hover
  void _onHover(PointerEvent event) {
    chartState._renderingDetails.currentActive = null;
    chartState._renderingDetails.tapPosition =
        renderBox.globalToLocal(event.position);
    bool? isPoint;
    const int seriesIndex = 0;
    int? pointIndex;
    final PyramidSeriesRenderer seriesRenderer =
        chartState._chartSeries.visibleSeriesRenderers[seriesIndex];
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        chartState._renderingDetails.tooltipBehaviorRenderer;
    for (int j = 0; j < seriesRenderer._renderPoints!.length; j++) {
      if (seriesRenderer._renderPoints![j].isVisible) {
        isPoint = _isPointInPolygon(seriesRenderer._renderPoints![j].pathRegion,
            chartState._renderingDetails.tapPosition!);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    if (chartState._renderingDetails.tapPosition != null &&
        isPoint != null &&
        isPoint) {
      chartState._renderingDetails.currentActive = _ChartInteraction(
        seriesIndex,
        pointIndex!,
        chartState._chartSeries.visibleSeriesRenderers[seriesIndex]._series,
        chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
            ._renderPoints![pointIndex],
      );
    } else if (tooltip.builder != null) {
      tooltipBehaviorRenderer._hide();
    }
    if (chartState._renderingDetails.tapPosition != null) {
      if (tooltip.enable &&
          chartState._renderingDetails.currentActive != null &&
          chartState._renderingDetails.currentActive!.series != null) {
        tooltipBehaviorRenderer._isHovering = true;
        if (tooltip.builder != null &&
            chartState._renderingDetails.animateCompleted) {
          _showPyramidTooltipTemplate();
        } else {
          final Offset position = renderBox.globalToLocal(event.position);
          tooltipBehaviorRenderer.onEnter(
              position.dx.toDouble(), position.dy.toDouble());
        }
      } else {
        tooltipBehaviorRenderer._prevTooltipValue = null;
        tooltipBehaviorRenderer._currentTooltipValue = null;
        tooltipBehaviorRenderer._hide();
      }
    }
    chartState._renderingDetails.tapPosition = null;
  }

  /// This method gets executed for showing tooltip when builder is provided in behavior
  void _showPyramidTooltipTemplate([int? pointIndex]) {
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        chartState._renderingDetails.tooltipBehaviorRenderer;

    if (!tooltipBehaviorRenderer._isHovering) {
      //assingning null for the previous and current tooltip values in case of touch interaction
      tooltipBehaviorRenderer._prevTooltipValue = null;
      tooltipBehaviorRenderer._currentTooltipValue = null;
    }
    final PyramidSeries<dynamic, dynamic> chartSeries =
        chartState._renderingDetails.currentActive?.series ?? chart.series;
    final PointInfo<dynamic> point = pointIndex == null
        ? chartState._renderingDetails.currentActive?.point
        : chartState
            ._chartSeries.visibleSeriesRenderers[0]._dataPoints[pointIndex];
    final Offset? location = chart.tooltipBehavior.tooltipPosition ==
                TooltipPosition.pointer &&
            !chartState._chartSeries.visibleSeriesRenderers[0]._series.explode
        ? chartState._renderingDetails.tapPosition!
        : point.symbolLocation;
    bool isPoint = false;
    for (int j = 0; j < seriesRenderer._renderPoints!.length; j++) {
      if (seriesRenderer._renderPoints![j].isVisible) {
        isPoint = _isPointInPolygon(
            seriesRenderer._renderPoints![j].pathRegion, location!);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    if (location != null && isPoint && (chartSeries.enableTooltip)) {
      tooltipBehaviorRenderer._showLocation = location;
      chartState._renderingDetails.tooltipBehaviorRenderer._chartTooltipState!
              .boundaryRect =
          chartState._renderingDetails.tooltipBehaviorRenderer._tooltipBounds =
              chartState._renderingDetails.chartContainerRect;
      tooltipBehaviorRenderer._tooltipTemplate = tooltip.builder!(
          chartSeries.dataSource![pointIndex ??
              chartState._renderingDetails.currentActive!.pointIndex!],
          point,
          chartSeries,
          chartState._renderingDetails.currentActive?.seriesIndex ?? 0,
          pointIndex ??
              chartState._renderingDetails.currentActive!.pointIndex!);
      if (tooltipBehaviorRenderer._isHovering) {
        //assingning values for the previous and current tooltip values on mouse hover
        tooltipBehaviorRenderer._prevTooltipValue =
            tooltipBehaviorRenderer._currentTooltipValue;
        tooltipBehaviorRenderer._currentTooltipValue = TooltipValue(
            0,
            pointIndex ??
                chartState._renderingDetails.currentActive!.pointIndex!);
      } else {
        chartState._renderingDetails.tooltipBehaviorRenderer
            ._hideTooltipTemplate();
      }
      tooltipBehaviorRenderer._show = true;
      tooltipBehaviorRenderer._performTooltip();
      tooltipBehaviorRenderer._chartTooltipState!
          .hide(hideDelay: tooltip.duration.toInt());
    }
  }
}
