part of charts;

/// Returns the LegendRenderArgs.
typedef PyramidLegendRenderCallback = void Function(
    LegendRenderArgs legendRenderArganimateCompleteds);

/// Returns the TooltipArgs.
typedef PyramidTooltipCallback = void Function(TooltipArgs tooltipArgs);

/// Returns the DataLabelRenderArgs.
typedef PyramidDataLabelRenderCallback = void Function(
    DataLabelRenderArgs dataLabelArgs);

/// Returns the SelectionArgs.
typedef PyramidSelectionCallback = void Function(SelectionArgs selectionArgs);

///Returns tha PointTapArgs.
typedef PyramidPointTapCallback = void Function(PointTapArgs pointTapArgs);

/// Returns the Offset
typedef PyramidTouchInteractionCallback = void Function(
    ChartTouchInteractionArgs tapArgs);

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
    Key key,
    this.backgroundColor,
    this.backgroundImage,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.onLegendItemRender,
    this.onTooltipRender,
    this.onDataLabelRender,
    this.onPointTapped,
    this.onDataLabelTapped,
    this.onLegendTapped,
    this.onSelectionChanged,
    this.onChartTouchInteractionUp,
    this.onChartTouchInteractionDown,
    this.onChartTouchInteractionMove,
    ChartTitle title,
    PyramidSeries<dynamic, dynamic> series,
    EdgeInsets margin,
    Legend legend,
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
    TooltipBehavior tooltipBehavior,
    SmartLabelMode smartLabelMode,
    ActivationMode selectionGesture,
    bool enableMultiSelection,
  })  : title = title ?? ChartTitle(),
        series = series ?? series,
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
  final Color backgroundColor;

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
  final PyramidLegendRenderCallback onLegendItemRender;

  /// Occurs when the tooltip is rendered.
  ///
  /// Here,you can get the tooltip arguments and customize the arguments.
  final PyramidTooltipCallback onTooltipRender;

  /// Occurs when the datalabel is rendered,Here datalabel arguments can be customized.
  final PyramidDataLabelRenderCallback onDataLabelRender;

  /// Occurs when the legend is tapped,the arguments can be used to customize the legend arguments
  final ChartLegendTapCallback onLegendTapped;

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
  ///                  selectionSettings: SelectionSettings(
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
  ///                  selectionSettings: SelectionSettings(
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
  ///                  selectionSettings: SelectionSettings(
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
  final ImageProvider backgroundImage;

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
  final PyramidSelectionCallback onSelectionChanged;

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
  final PyramidPointTapCallback onPointTapped;

  //Called when the data label is tapped.
  ///
  ///Whenever the data label is tapped, `onDataLabelTapped` callback will be called. Provides options to
  /// get the position of the data label, series index, point index and its text.
  ///
  ///_Note:_ - This callback will not be called, when the builder is specified for data label
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
  final DataLabelTapCallback onDataLabelTapped;

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
  final PyramidTouchInteractionCallback onChartTouchInteractionUp;

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
  final PyramidTouchInteractionCallback onChartTouchInteractionMove;

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
  final PyramidTouchInteractionCallback onChartTouchInteractionDown;

  @override
  State<StatefulWidget> createState() => SfPyramidChartState();
}

/// Represents the state class of [SfPyramidChart] widget
///
class SfPyramidChartState extends State<SfPyramidChart>
    with TickerProviderStateMixin {
  //ignore: unused_field
  List<AnimationController> _controllerList;
  //ignore: unused_field
  AnimationController _animationController; // Animation controller for series

  //ignore: unused_field
  AnimationController _annotationController; // Controller for Annotations

  ValueNotifier<int> _seriesRepaintNotifier;
  List<_MeasureWidgetContext>
      _legendWidgetContext; // To measure legend size and position
  List<_ChartTemplateInfo> _templates; // Chart Template info
  List<Widget> _chartWidgets;
  //ignore: unused_field
  PyramidSeriesRenderer _seriesRenderer;

  /// Holds the information of chart theme arguments
  SfChartThemeData _chartTheme;
  Rect _chartContainerRect;
  Rect _chartAreaRect;
  _ChartTemplate _chartTemplate;
  _ChartInteraction _currentActive;
  bool _initialRender;
  List<_LegendRenderContext> _legendToggleStates;
  List<_MeasureWidgetContext> _legendToggleTemplateStates;
  bool _isLegendToggled;
  Offset _tapPosition;
  bool _animateCompleted;
  //ignore: unused_field
  Animation<double> _chartElementAnimation;
  _PyramidDataLabelRenderer _renderDataLabel;
  bool _widgetNeedUpdate;
  List<int> _explodedPoints;
  List<Rect> _dataLabelTemplateRegions;
  List<int> _selectionData;
  int _tooltipPointIndex;
  Orientation _oldDeviceOrientation;
  Orientation _deviceOrientation;
  Size _prevSize;
  bool _didSizeChange = false;
  //Internal variables
  String _seriesType;
  List<PointInfo<dynamic>> _dataPoints;
  List<PointInfo<dynamic>> _renderPoints;
  _PyramidSeries _chartSeries;
  _ChartLegend _chartLegend;
  //ignore: unused_field
  _PyramidPlotArea _chartPlotArea;
  TooltipBehaviorRenderer _tooltipBehaviorRenderer;
  LegendRenderer _legendRenderer;
  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfPyramidChart get _chart => widget;

  @override
  void initState() {
    _initializeDefaultValues();
    //Update and maintain the series state, when we update the series in the series collection //
    _createAndUpdateSeriesRenderer();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _chartTheme = SfChartTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfPyramidChart oldWidget) {
    //Update and maintain the series state, when we update the series in the series collection //
    _createAndUpdateSeriesRenderer(oldWidget);
    _initialRender = !widget.series.explode;
    super.didUpdateWidget(oldWidget);
    _isLegendToggled = false;
    _widgetNeedUpdate = true;
  }

  @override
  Widget build(BuildContext context) {
    _prevSize = _prevSize ?? MediaQuery.of(context).size;
    _didSizeChange = _prevSize != MediaQuery.of(context).size;
    _prevSize = MediaQuery.of(context).size;
    _oldDeviceOrientation = _oldDeviceOrientation == null
        ? MediaQuery.of(context).orientation
        : _deviceOrientation;
    _deviceOrientation = MediaQuery.of(context).orientation;
    return RepaintBoundary(
        child: _ChartContainer(
            child: GestureDetector(
                child: Container(
                    decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        image: widget.backgroundImage != null
                            ? DecorationImage(
                                image: widget.backgroundImage, fit: BoxFit.fill)
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

  @override
  void dispose() {
    _disposeAnimationController(_animationController, _repaintChartElements);
    super.dispose();
  }

  /// Method to convert the [SfPyramidChart] as an image.
  ///
  /// Returns the [dart:ui.image]
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
    final RenderRepaintBoundary boundary =
        context.findRenderObject(); //get the render object from context
    final dart_ui.Image image =
        await boundary.toImage(pixelRatio: pixelRatio); // Convert
    // the repaint boundary as image
    return image;
  }

  /// To intialize default chart elements value
  void _initializeDefaultValues() {
    _chartSeries = _PyramidSeries(this);
    _chartLegend = _ChartLegend(this);
    _chartPlotArea = _PyramidPlotArea(chartState: this);
    _initialRender = true;
    _controllerList = <AnimationController>[];
    _annotationController = AnimationController(vsync: this);
    _seriesRepaintNotifier = ValueNotifier<int>(0);
    _legendToggleStates = <_LegendRenderContext>[];
    _legendToggleTemplateStates = <_MeasureWidgetContext>[];
    _explodedPoints = <int>[];
    _animateCompleted = false;
    _isLegendToggled = false;
    _widgetNeedUpdate = false;
    _legendWidgetContext = <_MeasureWidgetContext>[];
    _dataLabelTemplateRegions = <Rect>[];
    _selectionData = <int>[];
    _animationController = AnimationController(vsync: this)
      ..addListener(_repaintChartElements);
    _tooltipBehaviorRenderer = TooltipBehaviorRenderer(this);
    _legendRenderer = LegendRenderer(widget.legend);
  }

  // In this method, create and update the series renderer for each series //
  void _createAndUpdateSeriesRenderer([SfPyramidChart oldWidget]) {
    if (widget.series != null) {
      final PyramidSeriesRenderer oldSeriesRenderer =
          oldWidget != null && oldWidget.series != null
              ? _chartSeries.visibleSeriesRenderers[0]
              : null;
      dynamic series;
      series = widget.series;

      // Create and update the series list here
      PyramidSeriesRenderer seriesRenderers;

      if (oldSeriesRenderer != null &&
          _isSameSeries(oldWidget.series, series)) {
        seriesRenderers = oldSeriesRenderer;
      } else {
        seriesRenderers = series.createRenderer(series);
        if (seriesRenderers._controller == null &&
            series.onRendererCreated != null) {
          seriesRenderers._controller =
              PyramidSeriesController(seriesRenderers);
          series.onRendererCreated(seriesRenderers._controller);
        }
      }

      seriesRenderers._series = series;
      seriesRenderers._isSelectionEnable =
          series.selectionBehavior.enable || series.selectionSettings.enable;
      seriesRenderers._chartState = this;
      _chartSeries.visibleSeriesRenderers
        ..clear()
        ..add(seriesRenderers);
    }
  }

  void _repaintChartElements() {
    _seriesRepaintNotifier.value++;
  }

  /// To render chart elements
  Widget _renderChartElements() {
    return Expanded(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      Widget element;
      if (widget.series?.dataSource != null) {
        _initialize(constraints);

        _chartSeries._findVisibleSeries();
        _chartSeries._processDataPoints();
        final List<Widget> legendTemplates = _bindLegendTemplateWidgets(this);
        if (legendTemplates.isNotEmpty && _legendWidgetContext.isEmpty) {
          element = Container(child: Stack(children: legendTemplates));
          SchedulerBinding.instance.addPostFrameCallback((_) => _refresh());
        } else {
          _chartLegend._calculateLegendBounds(_chartLegend.chartSize);
          element = _getElements(
              this, _PyramidPlotArea(chartState: this), constraints);
        }
      } else {
        element = Container();
      }
      return element;
    }));
  }

  void _refresh() {
    final List<_MeasureWidgetContext> legendWidgetContexts =
        _legendWidgetContext;
    if (legendWidgetContexts.isNotEmpty) {
      for (int i = 0; i < legendWidgetContexts.length; i++) {
        final _MeasureWidgetContext templateContext = legendWidgetContexts[i];
        final RenderBox renderBox = templateContext.context.findRenderObject();
        templateContext.size = renderBox.size;
      }
      setState(() {
        /// The chart will be rebuilding again, Once legend template sizes will be calculated.
      });
    }
  }

  // ignore:unused_element
  void _redraw() {
    _initialRender = false;
    setState(() {
      /// The chart will be rebuilding again, When we do the legend toggle, zoom/pan the chart.
    });
  }

  /// To intialize chart container area
  void _initialize(BoxConstraints constraints) {
    _chartWidgets = <Widget>[];
    final num width = constraints.maxWidth;
    final num height = constraints.maxHeight;
    final EdgeInsets margin = widget.margin;
    final LegendRenderer legendRenderer = _legendRenderer;
    if (widget.legend.position == LegendPosition.auto) {
      legendRenderer._legendPosition =
          height > width ? LegendPosition.bottom : LegendPosition.right;
    } else {
      legendRenderer._legendPosition = widget.legend.position;
    }
    _chartLegend.chartSize = Size(width - margin.left - margin.right,
        height - margin.top - margin.bottom);
  }
}

// ignore: must_be_immutable
class _PyramidPlotArea extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PyramidPlotArea({this.chartState});
  final SfPyramidChartState chartState;
  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfPyramidChart get chart => chartState._chart;
  PyramidSeriesRenderer seriesRenderer;
  RenderBox renderBox;
  _Region pointRegion;
  TapDownDetails tapDownDetails;
  Offset doubleTapPosition;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          child: MouseRegion(
              onHover: (PointerEvent event) => _onHover(event),
              onExit: (PointerEvent event) {
                chartState._tooltipBehaviorRenderer._isHovering = false;
              },
              child: Stack(children: <Widget>[
                _initializeChart(constraints, context),
                Listener(
                  onPointerUp: (PointerUpEvent event) => _onTapUp(event),
                  onPointerDown: (PointerDownEvent event) => _onTapDown(event),
                  onPointerMove: (PointerMoveEvent event) =>
                      _performPointerMove(event),
                  child: GestureDetector(
                      onLongPress: _onLongPress,
                      onDoubleTap: _onDoubleTap,
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
    chartState._chartContainerRect = Rect.fromLTWH(0, 0, width, height);
    final EdgeInsets margin = chart.margin;
    chartState._chartAreaRect = Rect.fromLTWH(
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
    renderBox = context.findRenderObject();
    chartState._chartPlotArea = this;
    return Container(child: Stack(children: chartState._chartWidgets));
  }

  /// To calculate region path of pyramid
  void _calculatePathRegion() {
    final List<PyramidSeriesRenderer> visibleSeriesRenderers =
        chartState._chartSeries.visibleSeriesRenderers;
    if (visibleSeriesRenderers.isNotEmpty) {
      seriesRenderer = visibleSeriesRenderers[0];
      for (int i = 0; i < seriesRenderer._renderPoints.length; i++) {
        if (seriesRenderer._renderPoints[i].isVisible) {
          chartState._chartSeries._calculatePathRegion(i, seriesRenderer);
        }
      }
    }
  }

  /// To bind series widget together
  void _bindSeriesWidgets() {
    CustomPainter seriesPainter;
    Animation<double> seriesAnimation;
    PyramidSeries<dynamic, dynamic> series;
    final List<PyramidSeriesRenderer> visibleSeriesRenderers =
        chartState._chartSeries.visibleSeriesRenderers;
    for (int i = 0; i < visibleSeriesRenderers.length; i++) {
      seriesRenderer = visibleSeriesRenderers[i];
      series = seriesRenderer._series;
      series.selectionBehavior._chartState = chartState;
      series.selectionSettings._chartState = chartState;
      chartState._chartSeries._initializeSeriesProperties(seriesRenderer);
      SelectionBehaviorRenderer selectionBehaviorRenderer;
      final dynamic selectionBehavior = seriesRenderer._selectionBehavior =
          series.selectionBehavior.enable
              ? series.selectionBehavior
              : series.selectionSettings;
      selectionBehaviorRenderer = seriesRenderer._selectionBehaviorRenderer =
          SelectionBehaviorRenderer(selectionBehavior, chart, chartState);
      selectionBehaviorRenderer = seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer._selectionRenderer ??= _SelectionRenderer();
      selectionBehaviorRenderer._selectionRenderer.chart = chart;
      selectionBehaviorRenderer._selectionRenderer.seriesRenderer =
          seriesRenderer;
      if (series.initialSelectedDataIndexes.isNotEmpty) {
        for (int index = 0;
            index < series.initialSelectedDataIndexes.length;
            index++) {
          chartState._selectionData
              .add(series.initialSelectedDataIndexes[index]);
        }
      }
      if (series.animationDuration > 0 &&
          !chartState._didSizeChange &&
          (chartState._deviceOrientation == chartState._oldDeviceOrientation) &&
          ((!chartState._widgetNeedUpdate && chartState._initialRender) ||
              chartState._isLegendToggled)) {
        chartState._animationController.duration =
            Duration(milliseconds: series.animationDuration.toInt());
        seriesAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: chartState._animationController,
          curve: const Interval(0.1, 0.8, curve: Curves.linear),
        )..addStatusListener((AnimationStatus status) {
                if (status == AnimationStatus.completed) {
                  chartState._animateCompleted = true;
                  if (chartState._renderDataLabel != null) {
                    chartState._renderDataLabel.state.render();
                  }
                  if (chartState._chartTemplate != null &&
                      chartState._chartTemplate.state != null) {
                    chartState._chartTemplate.state.templateRender();
                  }
                }
              }));
        chartState._chartElementAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: chartState._animationController,
          curve: const Interval(0.85, 1.0, curve: Curves.decelerate),
        ));
        chartState._animationController.forward(from: 0.0);
      } else {
        chartState._animateCompleted = true;
        if (chartState._renderDataLabel != null) {
          chartState._renderDataLabel.state.render();
        }
      }
      seriesRenderer._repaintNotifier = chartState._seriesRepaintNotifier;
      if (seriesRenderer._seriesType == 'pyramid') {
        seriesPainter = _PyramidChartPainter(
            chartState: chartState,
            seriesIndex: i,
            isRepaint: seriesRenderer._needsRepaint,
            animationController: chartState._animationController,
            seriesAnimation: seriesAnimation,
            notifier: chartState._seriesRepaintNotifier);
      }
      chartState._chartWidgets
          .add(RepaintBoundary(child: CustomPaint(painter: seriesPainter)));
      chartState._renderDataLabel = _PyramidDataLabelRenderer(
          chartState: chartState,
          show: !chartState._widgetNeedUpdate
              ? chartState._animationController.status ==
                      AnimationStatus.completed ||
                  chartState._animationController.duration == null
              : true);
      chartState._chartWidgets.add(chartState._renderDataLabel);
    }
  }

  /// To bind tooltip widgets
  void _bindTooltipWidgets(BoxConstraints constraints) {
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        chartState._tooltipBehaviorRenderer;
    tooltip._chartState = chartState;
    if (tooltip.enable) {
      if (tooltip.builder != null) {
        tooltipBehaviorRenderer._tooltipTemplate = _TooltipTemplate(
            show: false,
            clipRect: chartState._chartContainerRect,
            tooltipBehavior: chart.tooltipBehavior,
            duration: tooltip.duration,
            chartState: chartState);
        chartState._chartWidgets.add(tooltipBehaviorRenderer._tooltipTemplate);
      } else {
        tooltipBehaviorRenderer._chartTooltip =
            _ChartTooltipRenderer(chartState: chartState);
        chartState._chartWidgets.add(tooltipBehaviorRenderer._chartTooltip);
      }
    }
  }

  /// Find point index for selection
  void _calculatePointSeriesIndex(SfPyramidChart chart,
      PyramidSeriesRenderer seriesRenderer, Offset touchPosition) {
    PointTapArgs pointTapArgs;
    num index;
    for (int i = 0; i < seriesRenderer._renderPoints.length; i++) {
      if (seriesRenderer._renderPoints[i].region.contains(touchPosition)) {
        index = i;
        break;
      }
    }
    if (index != null) {
      pointTapArgs = PointTapArgs(0, index, seriesRenderer._dataPoints, index);
      chart.onPointTapped(pointTapArgs);
    }
  }

  /// To perform pointer down event
  void _onTapDown(PointerDownEvent event) {
    chartState._tooltipBehaviorRenderer._isHovering = false;
    //renderBox = context.findRenderObject();
    chartState._currentActive = null;
    chartState._tapPosition = renderBox.globalToLocal(event.position);
    bool isPoint;
    const num seriesIndex = 0;
    num pointIndex;
    final List<PyramidSeriesRenderer> visibleSeriesRenderers =
        chartState._chartSeries.visibleSeriesRenderers;
    final PyramidSeriesRenderer seriesRenderer =
        visibleSeriesRenderers[seriesIndex];
    ChartTouchInteractionArgs touchArgs;
    for (int j = 0; j < seriesRenderer._renderPoints.length; j++) {
      if (seriesRenderer._renderPoints[j].isVisible) {
        isPoint = _isPointInPolygon(seriesRenderer._renderPoints[j].pathRegion,
            chartState._tapPosition);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    doubleTapPosition = chartState._tapPosition;
    if (chartState._tapPosition != null && isPoint) {
      chartState._currentActive = _ChartInteraction(
        seriesIndex,
        pointIndex,
        visibleSeriesRenderers[seriesIndex]._series,
        visibleSeriesRenderers[seriesIndex]._renderPoints[pointIndex],
      );
    } else {
      //hides the tooltip if the point of interaction is outside pyramid region of the chart
      chartState._tooltipBehaviorRenderer?._tooltipTemplate?.show = false;
      chartState._tooltipBehaviorRenderer?._tooltipTemplate?.state
          ?.hideOnTimer();
    }
    if (chart.onChartTouchInteractionDown != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = renderBox.globalToLocal(event.position);
      chart.onChartTouchInteractionDown(touchArgs);
    }
  }

  /// To perform pointer move event
  void _performPointerMove(PointerMoveEvent event) {
    ChartTouchInteractionArgs touchArgs;
    final Offset position = renderBox.globalToLocal(event.position);
    if (chart.onChartTouchInteractionMove != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = position;
      chart.onChartTouchInteractionMove(touchArgs);
    }
  }

  /// To perform double tap touch interactions
  void _onDoubleTap() {
    const num seriesIndex = 0;
    if (doubleTapPosition != null && chartState._currentActive != null) {
      final num pointIndex = chartState._currentActive.pointIndex;
      final List<PyramidSeriesRenderer> visibleSeriesRenderers =
          chartState._chartSeries.visibleSeriesRenderers;
      chartState._currentActive = _ChartInteraction(
          seriesIndex,
          pointIndex,
          visibleSeriesRenderers[seriesIndex]._series,
          visibleSeriesRenderers[seriesIndex]._renderPoints[pointIndex]);
      if (chartState._currentActive != null) {
        if (chartState._currentActive.series.explodeGesture ==
            ActivationMode.doubleTap) {
          chartState._chartSeries._pointExplode(pointIndex);
        }
      }
      chartState._chartSeries
          ._seriesPointSelection(pointIndex, ActivationMode.doubleTap);
      if (chart.tooltipBehavior.enable &&
          chartState._animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.doubleTap) {
        if (chart.tooltipBehavior.builder != null) {
          _showPyramidTooltipTemplate();
        } else {
          chartState._tooltipBehaviorRenderer.onDoubleTap(
              doubleTapPosition.dx.toDouble(), doubleTapPosition.dy.toDouble());
        }
      }
    }
  }

  /// To perform long press touch interactions
  void _onLongPress() {
    const num seriesIndex = 0;
    if (chartState._tapPosition != null && chartState._currentActive != null) {
      final List<PyramidSeriesRenderer> visibleSeriesRenderers =
          chartState._chartSeries.visibleSeriesRenderers;
      final num pointIndex = chartState._currentActive.pointIndex;
      chartState._currentActive = _ChartInteraction(
          seriesIndex,
          pointIndex,
          visibleSeriesRenderers[seriesIndex]._series,
          visibleSeriesRenderers[seriesIndex]._renderPoints[pointIndex],
          pointRegion);
      chartState._chartSeries
          ._seriesPointSelection(pointIndex, ActivationMode.longPress);
      if (chartState._currentActive != null) {
        if (chartState._currentActive.series.explodeGesture ==
            ActivationMode.longPress) {
          chartState._chartSeries._pointExplode(pointIndex);
        }
      }
      if (chart.tooltipBehavior.enable &&
          chartState._animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.longPress) {
        if (chart.tooltipBehavior.builder != null) {
          _showPyramidTooltipTemplate();
        } else {
          chartState._tooltipBehaviorRenderer.onLongPress(
              chartState._tapPosition.dx.toDouble(),
              chartState._tapPosition.dy.toDouble());
        }
      }
    }
  }

  /// To perform pointer up event
  void _onTapUp(PointerUpEvent event) {
    chartState._tooltipBehaviorRenderer._isHovering = false;
    final _ChartInteraction currentActive = chartState._currentActive;
    chartState._tapPosition = renderBox.globalToLocal(event.position);
    ChartTouchInteractionArgs touchArgs;
    if (chart.onPointTapped != null && seriesRenderer != null) {
      _calculatePointSeriesIndex(
          chart, seriesRenderer, chartState._tapPosition);
    }
    if (chart.onDataLabelTapped != null && seriesRenderer != null) {
      _triggerPyramidDataLabelEvent(
          chart, seriesRenderer, chartState, chartState._tapPosition);
    }
    if (chartState._tapPosition != null && chartState._currentActive != null) {
      if (currentActive.series != null &&
          currentActive.series.explodeGesture == ActivationMode.singleTap) {
        chartState._chartSeries._pointExplode(currentActive.pointIndex);
      }

      if (chartState
          ._chartSeries.visibleSeriesRenderers[0]._isSelectionEnable) {
        chartState._chartSeries._seriesPointSelection(
            currentActive.pointIndex, ActivationMode.singleTap);
      }

      if (chart.tooltipBehavior.enable &&
          chartState._animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.singleTap &&
          currentActive.series != null) {
        if (chart.tooltipBehavior.builder != null) {
          _showPyramidTooltipTemplate();
        } else {
          // final RenderBox renderBox = context.findRenderObject();
          final Offset position = renderBox.globalToLocal(event.position);
          chartState._tooltipBehaviorRenderer
              .onTouchUp(position.dx.toDouble(), position.dy.toDouble());
        }
      }
    }
    if (chart.onChartTouchInteractionUp != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = renderBox.globalToLocal(event.position);
      chart.onChartTouchInteractionUp(touchArgs);
    }
    chartState._tapPosition = null;
  }

  /// To perform event on mouse hover
  void _onHover(PointerEvent event) {
    chartState._currentActive = null;
    chartState._tapPosition = renderBox.globalToLocal(event.position);
    bool isPoint;
    const num seriesIndex = 0;
    num pointIndex;
    final PyramidSeriesRenderer seriesRenderer =
        chartState._chartSeries.visibleSeriesRenderers[seriesIndex];
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        chartState._tooltipBehaviorRenderer;
    for (int j = 0; j < seriesRenderer._renderPoints.length; j++) {
      if (seriesRenderer._renderPoints[j].isVisible) {
        isPoint = _isPointInPolygon(seriesRenderer._renderPoints[j].pathRegion,
            chartState._tapPosition);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    if (chartState._tapPosition != null && isPoint) {
      chartState._currentActive = _ChartInteraction(
        seriesIndex,
        pointIndex,
        chartState._chartSeries.visibleSeriesRenderers[seriesIndex]._series,
        chartState._chartSeries.visibleSeriesRenderers[seriesIndex]
            ._renderPoints[pointIndex],
      );
    } else if (tooltip?.builder != null) {
      tooltipBehaviorRenderer?._tooltipTemplate?.show = false;
      tooltipBehaviorRenderer?._tooltipTemplate?.state?.hideOnTimer();
    }
    if (chartState._tapPosition != null) {
      if (tooltip.enable &&
          chartState._currentActive != null &&
          chartState._currentActive.series != null) {
        tooltipBehaviorRenderer._isHovering = true;
        if (tooltip.builder != null && chartState._animateCompleted) {
          _showPyramidTooltipTemplate();
        } else {
          final Offset position = renderBox.globalToLocal(event.position);
          tooltipBehaviorRenderer.onEnter(
              position.dx.toDouble(), position.dy.toDouble());
        }
      } else {
        tooltipBehaviorRenderer?._painter?.prevTooltipValue = null;
        tooltipBehaviorRenderer?._painter?.currentTooltipValue = null;
        tooltipBehaviorRenderer?._painter?.hide();
      }
    }
    chartState._tapPosition = null;
  }

  /// This method gets executed for showing tooltip when builder is provided in behavior
  void _showPyramidTooltipTemplate([int pointIndex]) {
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    final TooltipBehaviorRenderer tooltipBehaviorRenderer =
        chartState._tooltipBehaviorRenderer;
    tooltipBehaviorRenderer._tooltipTemplate?._alwaysShow =
        tooltip.shouldAlwaysShow;
    if (!tooltipBehaviorRenderer._isHovering) {
      //assingning null for the previous and current tooltip values in case of touch interaction
      tooltipBehaviorRenderer._tooltipTemplate?.state?.prevTooltipValue = null;
      tooltipBehaviorRenderer._tooltipTemplate?.state?.currentTooltipValue =
          null;
    }
    final PyramidSeries<dynamic, dynamic> chartSeries =
        chartState._currentActive?.series ?? chart.series;
    final PointInfo<dynamic> point = pointIndex == null
        ? chartState._currentActive?.point
        : chartState
            ._chartSeries.visibleSeriesRenderers[0]._dataPoints[pointIndex];
    final Offset location = point.symbolLocation;
    if (location != null && (chartSeries.enableTooltip ?? true)) {
      tooltipBehaviorRenderer._tooltipTemplate.rect =
          Rect.fromLTWH(location.dx, location.dy, 0, 0);
      tooltipBehaviorRenderer._tooltipTemplate.template = tooltip.builder(
          chartSeries
              .dataSource[pointIndex ?? chartState._currentActive.pointIndex],
          point,
          chartSeries,
          chartState._currentActive?.seriesIndex ?? 0,
          pointIndex ?? chartState._currentActive?.pointIndex);
      if (tooltipBehaviorRenderer._isHovering) {
        //assingning values for the previous and current tooltip values on mouse hover
        tooltipBehaviorRenderer._tooltipTemplate.state.prevTooltipValue =
            tooltipBehaviorRenderer._tooltipTemplate.state.currentTooltipValue;
        tooltipBehaviorRenderer._tooltipTemplate.state.currentTooltipValue =
            TooltipValue(
                0, pointIndex ?? chartState._currentActive?.pointIndex);
      }
      tooltipBehaviorRenderer._tooltipTemplate.show = true;
      tooltipBehaviorRenderer._tooltipTemplate?.state?._performTooltip();
    }
  }
}
