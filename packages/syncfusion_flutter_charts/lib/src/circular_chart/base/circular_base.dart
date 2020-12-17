part of charts;

/// Returns the LegendRenderArgs.
typedef CircularLegendRenderCallback = void Function(
    LegendRenderArgs legendRenderArgs);

/// Returns the TooltipArgs.
typedef CircularTooltipCallback = void Function(TooltipArgs tooltipArgs);

/// Returns the DataLabelRenderArgs.
typedef CircularDatalabelRenderCallback = void Function(
    DataLabelRenderArgs dataLabelArgs);

/// Returns the PointTapArgs.
typedef CircularPointTapCallback = void Function(PointTapArgs pointTapArgs);

/// Returns the SelectionArgs.
typedef CircularSelectionCallback = void Function(SelectionArgs selectionArgs);

/// Returns the offset.
typedef CircularTouchInteractionCallback = void Function(
    ChartTouchInteractionArgs tapArgs);

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
      {Key key,
      this.backgroundColor,
      this.backgroundImage,
      this.annotations,
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
      ChartTitle title,
      EdgeInsets margin,
      List<CircularSeries<dynamic, dynamic>> series,
      Legend legend,
      String centerX,
      String centerY,
      TooltipBehavior tooltipBehavior,
      ActivationMode selectionGesture,
      bool enableMultiSelection})
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
  final Color backgroundColor;

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
  final List<CircularChartAnnotation> annotations;

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

  ///Data points or series can be selected while performing interaction on the chart.
  ///It can also be selected at the initial rendering using this property.
  ///
  ///Defaults to `[]`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///           series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  initialSelectedDataIndexes: <int>[2,0],
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red.withOpacity(0.8),
  ///                    unselectedColor: Colors.grey.withOpacity(0.5)
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```

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
  final ImageProvider backgroundImage;

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
  final CircularLegendRenderCallback onLegendItemRender;

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
  final CircularTooltipCallback onTooltipRender;

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
  final CircularDatalabelRenderCallback onDataLabelRender;

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
  final CircularPointTapCallback onPointTapped;

  //Called when the data label is tapped.
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
  ///        child: SfCircularChart(
  ///            onDataLabelTapped: (DataLabelTapDetails args) {
  ///                 print(arg.seriesIndex);
  ///                  }
  ///        ));
  ///}
  ///
  ///```

  final DataLabelTapCallback onDataLabelTapped;

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
  final ChartLegendTapCallback onLegendTapped;

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
  final CircularSelectionCallback onSelectionChanged;

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
  final CircularTouchInteractionCallback onChartTouchInteractionUp;

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
  final CircularTouchInteractionCallback onChartTouchInteractionDown;

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
  final CircularTouchInteractionCallback onChartTouchInteractionMove;

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
  ///                  selectionSettings: SelectionSettings(
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
  ///                  selectionSettings: SelectionSettings(
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
  /// Holds the animation controller list for all series
  //ignore: unused_field
  List<AnimationController> _controllerList;

  /// Animation controller for series
  AnimationController _animationController;

  /// Animation controller for Annotations
  //ignore: unused_field
  AnimationController _annotationController;

  /// Repaint notifier for series container
  ValueNotifier<int> _seriesRepaintNotifier;

  /// To measure legend size and position
  List<_MeasureWidgetContext> _legendWidgetContext;

  /// Chart Template info
  List<_ChartTemplateInfo> _templates;

  /// List of container widgets for chart series
  List<Widget> _chartWidgets;

  /// Holds the information of chart theme arguments
  SfChartThemeData _chartTheme;
  Offset _centerLocation;
  Rect _chartContainerRect;
  Rect _chartAreaRect;
  bool _animateCompleted;
  List<int> _explodedPoints;
  List<_LegendRenderContext> _legendToggleStates;
  List<_MeasureWidgetContext> _legendToggleTemplateStates;
  bool _initialRender;
  //ignore: unused_field
  List<ChartPoint<dynamic>> _selectedDataPoints;
  //ignore: unused_field
  List<ChartPoint<dynamic>> _unselectedDataPoints;
  //ignore: unused_field
  List<_Region> _selectedRegions;
  //ignore: unused_field
  List<_Region> _unselectedRegions;
  List<Rect> _dataLabelTemplateRegions;
  List<Rect> _annotationRegions;
  _ChartTemplate _chartTemplate;
  _ChartInteraction _currentActive;
  Offset _tapPosition;
  _CircularDataLabelRenderer _renderDataLabel;
  bool _widgetNeedUpdate;
  bool _isLegendToggled;
  CircularSeriesRenderer _prevSeriesRenderer;
  List<ChartPoint<dynamic>> _oldPoints;
  List<int> _selectionData;
  //ignore: unused_field
  Animation<double> _chartElementAnimation;
  Orientation _oldDeviceOrientation;
  Orientation _deviceOrientation;
  //ignore: unused_field
  CircularSeriesRenderer _seriesRenderer;
  Size _prevSize;
  bool _didSizeChange = false;
  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCircularChart get _chart => widget;

  _ChartLegend _chartLegend;

  /// Holds the information of SeriesBase class
  _CircularSeries _chartSeries;

  //ignore: unused_field
  _CircularArea _circularArea;

  bool _needToMoveFromCenter;

  bool _needExplodeAll;

  TooltipBehaviorRenderer _tooltipBehaviorRenderer;
  LegendRenderer _legendRenderer;

  //ignore: prefer_final_fields
  bool _isToggled = false;

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

  /// To update chart widgets
  @override
  void didUpdateWidget(SfCircularChart oldWidget) {
    //Update and maintain the series state, when we update the series in the series collection //
    _createAndUpdateSeriesRenderer(oldWidget);

    _needsRepaintCircularChart(_chartSeries.visibleSeriesRenderers,
        <CircularSeriesRenderer>[]..add(_prevSeriesRenderer));

    _needExplodeAll = widget.series.isNotEmpty &&
        widget.series[0].explodeAll &&
        widget.series[0].explode &&
        oldWidget.series[0].explodeAll != widget.series[0].explodeAll;
    _isLegendToggled = false;
    _widgetNeedUpdate = true;
    if (_legendWidgetContext.isNotEmpty) {
      _legendWidgetContext.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _initialRender = (_widgetNeedUpdate && !_isLegendToggled)
        ? _needExplodeAll
        : (_initialRender == null);
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
            color:
                widget.backgroundColor ?? _chartTheme.plotAreaBackgroundColor,
            image: widget.backgroundImage != null
                ? DecorationImage(
                    image: widget.backgroundImage, fit: BoxFit.fill)
                : null,
            border: Border.all(
                color: widget.borderColor, width: widget.borderWidth)),
        child: Column(
          children: <Widget>[_renderChartTitle(this), _renderChartElements()],
        ),
      )),
    ));
  }

  /// To end animation controller
  @override
  void dispose() {
    _disposeAnimationController(_animationController, _repaintChartElements);
    super.dispose();
  }

  /// Method to convert the [SfCirculaChart] as an image.
  ///
  /// As this method is in the widget’s state class,
  /// you have to use a global key to access the state to call this method.
  /// Returns the [dart:ui.image]
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
    final RenderRepaintBoundary boundary =
        context.findRenderObject(); //get the render object from context

    final dart_ui.Image image =
        await boundary.toImage(pixelRatio: pixelRatio); // Convert
    // the repaint boundary as image
    return image;
  }

  /// To intialize default values of circular chart
  void _initializeDefaultValues() {
    _chartSeries = _CircularSeries(this);
    _circularArea = _CircularArea(chartState: this);
    _chartLegend = _ChartLegend(this);
    _needToMoveFromCenter = true;
    _animateCompleted = false;
    _controllerList = <AnimationController>[];
    _annotationController = AnimationController(vsync: this);
    _seriesRepaintNotifier = ValueNotifier<int>(0);
    _legendWidgetContext = <_MeasureWidgetContext>[];
    _explodedPoints = <int>[];
    _templates = <_ChartTemplateInfo>[];
    _legendToggleStates = <_LegendRenderContext>[];
    _selectedDataPoints = <ChartPoint<dynamic>>[];
    _unselectedDataPoints = <ChartPoint<dynamic>>[];
    _selectedRegions = <_Region>[];
    _unselectedRegions = <_Region>[];
    _legendToggleTemplateStates = <_MeasureWidgetContext>[];
    _dataLabelTemplateRegions = <Rect>[];
    _annotationRegions = <Rect>[];
    _widgetNeedUpdate = false;
    _isLegendToggled = false;
    _selectionData = <int>[];
    _animationController = AnimationController(vsync: this)
      ..addListener(_repaintChartElements);
    _tooltipBehaviorRenderer = TooltipBehaviorRenderer(this);
    _legendRenderer = LegendRenderer(widget.legend);
  }

  // In this method, create and update the series renderer for each series //
  void _createAndUpdateSeriesRenderer([SfCircularChart oldWidget]) {
    if (widget.series != null && widget.series.isNotEmpty) {
      final CircularSeriesRenderer oldSeriesRenderer =
          oldWidget != null && oldWidget.series.isNotEmpty
              ? _chartSeries.visibleSeriesRenderers[0]
              : null;
      dynamic series;
      series = widget.series[0];

      CircularSeriesRenderer seriesRenderer;

      if (_prevSeriesRenderer != null &&
          !_prevSeriesRenderer._chartState._isToggled &&
          _isSameSeries(_prevSeriesRenderer._series, series)) {
        seriesRenderer = _prevSeriesRenderer;
      } else {
        seriesRenderer = series.createRenderer(series);
        if (seriesRenderer._controller == null &&
            series.onRendererCreated != null) {
          seriesRenderer._controller = CircularSeriesController(seriesRenderer);
          series.onRendererCreated(seriesRenderer._controller);
        }
      }
      if (oldWidget != null && oldWidget.series.isNotEmpty) {
        _prevSeriesRenderer = oldSeriesRenderer;
        _prevSeriesRenderer._series = oldWidget.series[0];
        _prevSeriesRenderer._oldRenderPoints = <ChartPoint<dynamic>>[]
          //ignore: prefer_spread_collections
          ..addAll(_prevSeriesRenderer._renderPoints ?? []);
        _prevSeriesRenderer._renderPoints = <ChartPoint<dynamic>>[];
      }
      seriesRenderer._series = series;
      seriesRenderer._isSelectionEnable =
          series.selectionBehavior.enable || series.selectionSettings.enable;
      seriesRenderer._chartState = this;
      _chartSeries.visibleSeriesRenderers
        ..clear()
        ..add(seriesRenderer);
    }
  }

  void _repaintChartElements() {
    _seriesRepaintNotifier.value++;
  }

  /// To redraw chart elements
  // ignore:unused_element
  void _redraw() {
    _initialRender = false;
    if (_isLegendToggled) {
      _isToggled = true;
      _prevSeriesRenderer = _chartSeries.visibleSeriesRenderers[0];
      _oldPoints =
          List<ChartPoint<dynamic>>(_prevSeriesRenderer._renderPoints.length);
      for (int i = 0; i < _prevSeriesRenderer._renderPoints.length; i++) {
        _oldPoints[i] = _prevSeriesRenderer._renderPoints[i];
      }
    }
    setState(() {
      /// The chart will be rebuilding again, When we do the legend toggle, zoom/pan the chart.
    });
  }

  void _refresh() {
    final List<_MeasureWidgetContext> legendContexts = _legendWidgetContext;
    if (legendContexts.isNotEmpty) {
      for (int i = 0; i < legendContexts.length; i++) {
        final _MeasureWidgetContext templateContext = legendContexts[i];
        final RenderBox renderBox = templateContext.context.findRenderObject();
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
        _initialize(constraints);
        _chartSeries._findVisibleSeries();
        if (_chartSeries.visibleSeriesRenderers.isNotEmpty) {
          _chartSeries
              ._processDataPoints(_chartSeries.visibleSeriesRenderers[0]);
        }
        final List<Widget> legendTemplates = _bindLegendTemplateWidgets(this);
        if (legendTemplates.isNotEmpty && _legendWidgetContext.isEmpty) {
          element = Container(child: Stack(children: legendTemplates));
          SchedulerBinding.instance.addPostFrameCallback((_) => _refresh());
        } else {
          _chartLegend._calculateLegendBounds(_chartLegend.chartSize);
          element =
              _getElements(this, _CircularArea(chartState: this), constraints);
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
    _legendRenderer._legendPosition =
        (widget.legend.position == LegendPosition.auto)
            ? (height > width ? LegendPosition.bottom : LegendPosition.right)
            : widget.legend.position;
    _chartLegend.chartSize = Size(width - margin.left - margin.right,
        height - margin.top - margin.bottom);
  }
}

// ignore: must_be_immutable
class _CircularArea extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CircularArea({this.chartState});
  //Here, we are using get keyword inorder to get the proper & updated instance of chart widget
  //When we initialize chart widget as a property to other classes like _ChartSeries, the chart widget is not updated properly and by using get we can rectify this.
  SfCircularChart get chart => chartState._chart;
  final SfCircularChartState chartState;
  CircularSeries<dynamic, dynamic> series;

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
            child: Listener(
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
                    child: _initializeChart(constraints, context),
                    decoration: const BoxDecoration(color: Colors.transparent),
                  )),
            )),
      );
    });
  }

  /// Find point index for selection
  void _calculatePointSeriesIndex(SfCircularChart chart, _Region pointRegion) {
    PointTapArgs pointTapArgs;
    pointTapArgs = PointTapArgs(
        pointRegion.seriesIndex,
        pointRegion.pointIndex,
        chartState._chartSeries.visibleSeriesRenderers[0]._dataPoints,
        pointRegion.pointIndex);
    chart.onPointTapped(pointTapArgs);
  }

  RenderBox renderBox;
  _Region pointRegion;
  TapDownDetails tapDownDetails;
  Offset doubleTapPosition;

  /// To perform the pointer down event
  void _onTapDown(PointerDownEvent event) {
    ChartTouchInteractionArgs touchArgs;
    chartState._tooltipBehaviorRenderer._isHovering = false;
    // renderBox = context.findRenderObject();
    chartState._currentActive = null;
    chartState._tapPosition = renderBox.globalToLocal(event.position);
    pointRegion = _getCircularPointRegion(chart, chartState._tapPosition,
        chartState._chartSeries.visibleSeriesRenderers[0]);
    doubleTapPosition = chartState._tapPosition;
    if (chartState._tapPosition != null && pointRegion != null) {
      chartState._currentActive = _ChartInteraction(
          pointRegion.seriesIndex,
          pointRegion.pointIndex,
          chartState._chartSeries
              .visibleSeriesRenderers[pointRegion.seriesIndex]._series,
          chartState
              ._chartSeries
              .visibleSeriesRenderers[pointRegion.seriesIndex]
              ._renderPoints[pointRegion.pointIndex],
          pointRegion);
    } else {
      //hides the tooltip if the point of interaction is outside circular region of the chart
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

  /// To perform the pointer move event
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
    if (doubleTapPosition != null && pointRegion != null) {
      chartState._currentActive = _ChartInteraction(
          pointRegion.seriesIndex,
          pointRegion.pointIndex,
          chartState._chartSeries
              .visibleSeriesRenderers[pointRegion.seriesIndex]._series,
          chartState
              ._chartSeries
              .visibleSeriesRenderers[pointRegion.seriesIndex]
              ._renderPoints[pointRegion.pointIndex],
          pointRegion);
      if (chartState._currentActive != null) {
        if (chartState._currentActive.series.explodeGesture ==
            ActivationMode.doubleTap) {
          chartState._chartSeries
              ._seriesPointExplosion(chartState._currentActive.region);
        }
      }
      chartState._chartSeries
          ._seriesPointSelection(pointRegion, ActivationMode.doubleTap);
      if (chart.tooltipBehavior.enable &&
          chartState._animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.doubleTap) {
        if (chart.tooltipBehavior.builder != null) {
          _showCircularTooltipTemplate();
        } else {
          chartState._tooltipBehaviorRenderer.onDoubleTap(
              doubleTapPosition.dx.toDouble(), doubleTapPosition.dy.toDouble());
        }
      }
    }
  }

  /// To perform long press touch interactions
  void _onLongPress() {
    if (chartState._tapPosition != null && pointRegion != null) {
      chartState._currentActive = _ChartInteraction(
          pointRegion.seriesIndex,
          pointRegion.pointIndex,
          chartState._chartSeries
              .visibleSeriesRenderers[pointRegion.seriesIndex]._series,
          chartState
              ._chartSeries
              .visibleSeriesRenderers[pointRegion.seriesIndex]
              ._renderPoints[pointRegion.pointIndex],
          pointRegion);
      chartState._chartSeries
          ._seriesPointSelection(pointRegion, ActivationMode.longPress);
      if (chartState._currentActive != null) {
        if (chartState._currentActive.series.explodeGesture ==
            ActivationMode.longPress) {
          chartState._chartSeries
              ._seriesPointExplosion(chartState._currentActive.region);
        }
      }
      if (chart.tooltipBehavior.enable &&
          chartState._animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.longPress) {
        if (chart.tooltipBehavior.builder != null) {
          _showCircularTooltipTemplate();
        } else {
          chartState._tooltipBehaviorRenderer.onLongPress(
              chartState._tapPosition.dx.toDouble(),
              chartState._tapPosition.dy.toDouble());
        }
      }
    }
  }

  /// To perform the pointer up event
  void _onTapUp(PointerUpEvent event) {
    chartState._tooltipBehaviorRenderer._isHovering = false;
    ChartTouchInteractionArgs touchArgs;
    final CircularSeriesRenderer seriesRenderer =
        chartState._chartSeries.visibleSeriesRenderers[0];
    if (chart.onPointTapped != null && pointRegion != null) {
      _calculatePointSeriesIndex(chart, pointRegion);
    }
    if (chart.onDataLabelTapped != null) {
      _triggerCircularDataLabelEvent(
          chart, seriesRenderer, chartState, chartState._tapPosition);
    }
    if (chartState._tapPosition != null) {
      if (chartState._currentActive != null &&
          chartState._currentActive.series != null &&
          chartState._currentActive.series.explodeGesture ==
              ActivationMode.singleTap) {
        chartState._chartSeries
            ._seriesPointExplosion(chartState._currentActive.region);
      }

      if (chartState._tapPosition != null &&
          chartState._currentActive != null) {
        chartState._chartSeries._seriesPointSelection(
            chartState._currentActive.region, ActivationMode.singleTap);
      }
      if (chart.tooltipBehavior.enable &&
          chartState._animateCompleted &&
          chart.tooltipBehavior.activationMode == ActivationMode.singleTap &&
          chartState._currentActive != null &&
          chartState._currentActive.series != null) {
        if (chart.tooltipBehavior.builder != null) {
          _showCircularTooltipTemplate();
        } else {
          // final RenderBox renderBox = context.findRenderObject();
          final Offset position = renderBox.globalToLocal(event.position);
          chartState._tooltipBehaviorRenderer
              .onTouchUp(position.dx.toDouble(), position.dy.toDouble());
        }
      }
      if (chart.onChartTouchInteractionUp != null) {
        touchArgs = ChartTouchInteractionArgs();
        touchArgs.position = renderBox.globalToLocal(event.position);
        chart.onChartTouchInteractionUp(touchArgs);
      }
    }
    chartState._tapPosition = null;
  }

  /// To perform  hover event
  void _onHover(PointerEvent event) {
    chartState._currentActive = null;
    chartState._tapPosition = renderBox.globalToLocal(event.position);
    pointRegion = _getCircularPointRegion(chart, chartState._tapPosition,
        chartState._chartSeries.visibleSeriesRenderers[0]);
    final CircularSeriesRenderer seriesRenderer =
        chartState._chartSeries.visibleSeriesRenderers[0];
    if (chart.onDataLabelTapped != null) {
      _triggerCircularDataLabelEvent(
          chart, seriesRenderer, chartState, chartState._tapPosition);
    }
    if (chartState._tapPosition != null && pointRegion != null) {
      chartState._currentActive = _ChartInteraction(
          pointRegion.seriesIndex,
          pointRegion.pointIndex,
          chartState._chartSeries
              .visibleSeriesRenderers[pointRegion.seriesIndex]._series,
          chartState
              ._chartSeries
              .visibleSeriesRenderers[pointRegion.seriesIndex]
              ._renderPoints[pointRegion.pointIndex],
          pointRegion);
    } else if (chart.tooltipBehavior?.builder != null) {
      //hides the tooltip when the mouse is hovering out of the circular region
      chartState._tooltipBehaviorRenderer?._tooltipTemplate?.show = false;
      chartState._tooltipBehaviorRenderer?._tooltipTemplate?.state
          ?.hideOnTimer();
    }
    if (chartState._tapPosition != null) {
      if (chart.tooltipBehavior.enable &&
          chartState._currentActive != null &&
          chartState._currentActive.series != null) {
        chartState._tooltipBehaviorRenderer._isHovering = true;
        if (chart.tooltipBehavior.builder != null &&
            chartState._animateCompleted) {
          _showCircularTooltipTemplate();
        } else {
          final Offset position = renderBox.globalToLocal(event.position);
          chartState._tooltipBehaviorRenderer
              .onEnter(position.dx.toDouble(), position.dy.toDouble());
        }
      } else {
        chartState?._tooltipBehaviorRenderer?._painter?.prevTooltipValue = null;
        chartState?._tooltipBehaviorRenderer?._painter?.currentTooltipValue =
            null;
        chartState?._tooltipBehaviorRenderer?._painter?.hide();
      }
    }
    chartState._tapPosition = null;
  }

  /// This method gets executed for showing tooltip when builder is provided in behavior
  ///the optional parameters will take values once thee public method gets called
  void _showCircularTooltipTemplate([int seriesIndex, int pointIndex]) {
    final _TooltipTemplate tooltipTemplate =
        chartState._tooltipBehaviorRenderer._tooltipTemplate;
    chartState._tooltipBehaviorRenderer._tooltipTemplate?._alwaysShow =
        chart.tooltipBehavior.shouldAlwaysShow;
    if (!chartState._tooltipBehaviorRenderer._isHovering) {
      //assingning null for the previous and current tooltip values in case of touch interaction
      tooltipTemplate?.state?.prevTooltipValue = null;
      tooltipTemplate?.state?.currentTooltipValue = null;
    }
    final CircularSeries<dynamic, dynamic> chartSeries =
        chartState?._currentActive?.series ?? chart.series[seriesIndex];
    final ChartPoint<dynamic> point = pointIndex == null
        ? chartState._currentActive.point
        : chartState
            ._chartSeries.visibleSeriesRenderers[0]._dataPoints[pointIndex];
    if (point.isVisible) {
      final Offset location = _degreeToPoint(point.midAngle,
          (point.innerRadius + point.outerRadius) / 2, point.center);
      if (location != null && (chartSeries.enableTooltip ?? true)) {
        tooltipTemplate.rect = Rect.fromLTWH(location.dx, location.dy, 0, 0);
        tooltipTemplate.template = chart.tooltipBehavior.builder(
            chartSeries
                .dataSource[pointIndex ?? chartState._currentActive.pointIndex],
            point,
            chartSeries,
            seriesIndex ?? chartState._currentActive.seriesIndex,
            pointIndex ?? chartState._currentActive.pointIndex);
        if (chartState._tooltipBehaviorRenderer._isHovering) {
          //assigning values for previous and current tooltip values when the mouse is hovering
          tooltipTemplate.state.prevTooltipValue =
              tooltipTemplate.state.currentTooltipValue;
          tooltipTemplate.state.currentTooltipValue = TooltipValue(
              seriesIndex ?? chartState._currentActive.seriesIndex,
              pointIndex ?? chartState._currentActive.pointIndex);
        }
        tooltipTemplate.show = true;
        tooltipTemplate?.state?._performTooltip();
      }
    }
  }

  /// To initialize chart widgets
  Widget _initializeChart(BoxConstraints constraints, BuildContext context) {
    _calculateContainerSize(constraints);
    if (chart.series.isNotEmpty) {
      chartState._chartSeries?._calculateAngleAndCenterPositions(
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
    chartState._chartContainerRect = Rect.fromLTWH(0, 0, width, height);
    final EdgeInsets margin = chart.margin;
    chartState._chartAreaRect = Rect.fromLTWH(
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
    renderBox = context.findRenderObject();
    return Container(child: Stack(children: chartState._chartWidgets));
  }

  /// To add chart templates
  void _findTemplates() {
    Offset labelLocation;
    const num lineLength = 10;
    ChartPoint<dynamic> point;
    Widget labelWidget;
    chartState._templates = <_ChartTemplateInfo>[];
    chartState._dataLabelTemplateRegions = <Rect>[];
    chartState._annotationRegions = <Rect>[];
    for (int k = 0;
        k < chartState._chartSeries.visibleSeriesRenderers.length;
        k++) {
      final CircularSeriesRenderer seriesRenderer =
          chartState._chartSeries.visibleSeriesRenderers[k];
      final CircularSeries<dynamic, dynamic> series = seriesRenderer._series;
      final ConnectorLineSettings connector =
          series.dataLabelSettings.connectorLineSettings;
      if (series.dataLabelSettings.isVisible &&
          series.dataLabelSettings.builder != null) {
        for (int i = 0; i < seriesRenderer._renderPoints.length; i++) {
          point = seriesRenderer._renderPoints[i];
          ChartAlignment labelAlign;
          if (point.isVisible) {
            labelWidget = series.dataLabelSettings
                .builder(series.dataSource[i], point, series, i, k);
            if (series.dataLabelSettings.labelPosition ==
                ChartDataLabelPosition.inside) {
              labelLocation = _degreeToPoint(point.midAngle,
                  (point.innerRadius + point.outerRadius) / 2, point.center);
              labelLocation = Offset(labelLocation.dx, labelLocation.dy);
              labelAlign = ChartAlignment.center;
            } else {
              final num connectorLength =
                  _percentToValue(connector.length ?? '10%', point.outerRadius);
              labelLocation = _degreeToPoint(point.midAngle,
                  point.outerRadius + connectorLength, point.center);
              labelLocation = Offset(
                  point.dataLabelPosition == Position.right
                      ? labelLocation.dx + lineLength + 5
                      : labelLocation.dx - lineLength - 5,
                  labelLocation.dy);
              labelAlign = point.dataLabelPosition == Position.left
                  ? ChartAlignment.far
                  : ChartAlignment.near;
            }
            chartState._templates.add(_ChartTemplateInfo(
                key: GlobalKey(),
                templateType: 'DataLabel',
                pointIndex: i,
                seriesIndex: k,
                needMeasure: true,
                clipRect: chartState._chartAreaRect,
                animationDuration: 500,
                widget: labelWidget,
                horizontalAlignment: labelAlign,
                verticalAlignment: ChartAlignment.center,
                location: labelLocation));
          }
        }
      }
    }
    if (chart.annotations != null && chart.annotations.isNotEmpty) {
      for (int i = 0; i < chart.annotations.length; i++) {
        final CircularChartAnnotation annotation = chart.annotations[i];
        if (annotation.widget != null) {
          final double radius = _percentToValue(
                  annotation.radius, chartState._chartSeries.size / 2)
              .toDouble();
          final Offset point = _degreeToPoint(
              annotation.angle, radius, chartState._centerLocation);
          final double annotationHeight = _percentToValue(
              annotation.height, chartState._chartSeries.size / 2);
          final double annotationWidth = _percentToValue(
              annotation.width, chartState._chartSeries.size / 2);
          final _ChartTemplateInfo templateInfo = _ChartTemplateInfo(
              key: GlobalKey(),
              templateType: 'Annotation',
              needMeasure: true,
              horizontalAlignment: annotation.horizontalAlignment,
              verticalAlignment: annotation.verticalAlignment,
              clipRect: chartState._chartContainerRect,
              widget: annotationHeight > 0 && annotationWidth > 0
                  ? Container(
                      height: annotationHeight,
                      width: annotationWidth,
                      child: annotation.widget)
                  : annotation.widget,
              pointIndex: i,
              animationDuration: 500,
              location: point);
          chartState._templates.add(templateInfo);
        }
      }
    }
  }

  /// To render chart templates
  void _renderTemplates() {
    if (chartState._templates.isNotEmpty) {
      for (int i = 0; i < chartState._templates.length; i++) {
        chartState._templates[i].animationDuration = !chartState._initialRender
            ? 0
            : chartState._templates[i].animationDuration;
      }
      chartState._chartTemplate = _ChartTemplate(
          templates: chartState._templates,
          render: chartState._animateCompleted,
          chartState: chartState);
      chartState._chartWidgets.add(chartState._chartTemplate);
    }
  }

  /// To add tooltip widgets to chart
  void _bindTooltipWidgets(BoxConstraints constraints) {
    chart.tooltipBehavior._chartState = chartState;
    if (chart.tooltipBehavior.enable) {
      final List<Widget> tooltipWidgets = <Widget>[];
      if (chart.tooltipBehavior.builder != null) {
        chartState._tooltipBehaviorRenderer._tooltipTemplate = _TooltipTemplate(
            show: false,
            clipRect: chartState._chartContainerRect,
            tooltipBehavior: chart.tooltipBehavior,
            duration: chart.tooltipBehavior.duration,
            chartState: chartState);
        tooltipWidgets
            .add(chartState._tooltipBehaviorRenderer._tooltipTemplate);
      } else {
        chartState._tooltipBehaviorRenderer._chartTooltip =
            _ChartTooltipRenderer(chartState: chartState);
        tooltipWidgets.add(chartState._tooltipBehaviorRenderer._chartTooltip);
      }
      final Widget uiWidget =
          IgnorePointer(ignoring: true, child: Stack(children: tooltipWidgets));
      chartState._chartWidgets.add(uiWidget);
    }
  }

  /// To add series widgets in chart
  void _bindSeriesWidgets(BuildContext context) {
    CustomPainter seriesPainter;
    Animation<double> seriesAnimation;
    chartState._animateCompleted = false;
    chartState._chartWidgets ??= <Widget>[];
    CircularSeries<dynamic, dynamic> series;
    CircularSeriesRenderer seriesRenderer;
    for (int i = 0;
        i < chartState._chartSeries.visibleSeriesRenderers.length;
        i++) {
      seriesRenderer = chartState._chartSeries.visibleSeriesRenderers[i];
      series = seriesRenderer._series;
      series.selectionBehavior._chartState = chartState;
      series.selectionSettings._chartState = chartState;
      final dynamic selectionBehavior = seriesRenderer._selectionBehavior =
          series.selectionBehavior.enable
              ? series.selectionBehavior
              : series.selectionSettings;
      SelectionBehaviorRenderer selectionBehaviorRenderer;
      selectionBehaviorRenderer = seriesRenderer._selectionBehaviorRenderer =
          SelectionBehaviorRenderer(selectionBehavior, chart, chartState);
      selectionBehaviorRenderer._selectionRenderer ??= _SelectionRenderer();
      selectionBehaviorRenderer._selectionRenderer.chart = chart;
      selectionBehaviorRenderer._selectionRenderer._chartState = chartState;
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
      chartState._animateCompleted = false;
      if (series.animationDuration > 0 &&
          !chartState._didSizeChange &&
          (chartState._oldDeviceOrientation == chartState._deviceOrientation) &&
          (chartState._initialRender ||
              (chartState._widgetNeedUpdate &&
                  seriesRenderer._needsAnimation) ||
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
      }
      seriesRenderer._repaintNotifier = chartState._seriesRepaintNotifier;
      if (seriesRenderer._seriesType == 'pie') {
        seriesPainter = _PieChartPainter(
            chartState: chartState,
            index: i,
            isRepaint: seriesRenderer._needsRepaint,
            animationController: chartState._animationController,
            seriesAnimation: seriesAnimation,
            notifier: chartState._seriesRepaintNotifier);
      } else if (seriesRenderer._seriesType == 'doughnut') {
        seriesPainter = _DoughnutChartPainter(
            chartState: chartState,
            index: i,
            isRepaint: seriesRenderer._needsRepaint,
            animationController: chartState._animationController,
            seriesAnimation: seriesAnimation,
            notifier: chartState._seriesRepaintNotifier);
      } else if (seriesRenderer._seriesType == 'radialbar') {
        seriesPainter = _RadialBarPainter(
            chartState: chartState,
            index: i,
            isRepaint: seriesRenderer._needsRepaint,
            animationController: chartState._animationController,
            seriesAnimation: seriesAnimation,
            notifier: chartState._seriesRepaintNotifier);
      }
      chartState._chartWidgets
          .add(RepaintBoundary(child: CustomPaint(painter: seriesPainter)));
      chartState._renderDataLabel = _CircularDataLabelRenderer(
          circularChartState: chartState, show: chartState._animateCompleted);
      chartState._chartWidgets.add(chartState._renderDataLabel);
    }
  }
}
