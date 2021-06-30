part of charts;

class _PyramidSeriesBase<T, D> extends ChartSeries<T, D>
    implements TriangularChartEmptyPointBehavior {
  _PyramidSeriesBase({
    this.key,
    this.onCreateRenderer,
    this.onRendererCreated,
    this.onPointTap,
    this.onPointDoubleTap,
    this.onPointLongPress,
    this.dataSource,
    this.xValueMapper,
    this.yValueMapper,
    this.pointColorMapper,
    this.textFieldMapper,
    this.name,
    this.explodeIndex,
    String? height,
    String? width,
    PyramidMode? pyramidMode,
    double? gapRatio,
    EmptyPointSettings? emptyPointSettings,
    String? explodeOffset,
    bool? explode,
    ActivationMode? explodeGesture,
    Color? borderColor,
    double? borderWidth,
    LegendIconType? legendIconType,
    DataLabelSettings? dataLabelSettings,
    double? animationDuration,
    double? opacity,
    SelectionBehavior? selectionBehavior,
    List<int>? initialSelectedDataIndexes,
  })  : height = height ?? '80%',
        width = width ?? '80%',
        pyramidMode = pyramidMode ?? PyramidMode.linear,
        gapRatio = gapRatio ?? 0,
        emptyPointSettings = emptyPointSettings ?? EmptyPointSettings(),
        explodeOffset = explodeOffset ?? '10%',
        explode = explode ?? false,
        explodeGesture = explodeGesture ?? ActivationMode.singleTap,
        borderColor = borderColor ?? Colors.transparent,
        borderWidth = borderWidth ?? 0.0,
        legendIconType = legendIconType ?? LegendIconType.seriesType,
        dataLabelSettings = dataLabelSettings ?? const DataLabelSettings(),
        animationDuration = animationDuration ?? 1500,
        opacity = opacity ?? 1,
        initialSelectedDataIndexes = initialSelectedDataIndexes ?? <int>[],
        selectionBehavior = selectionBehavior ?? SelectionBehavior(),
        super(
            name: name,
            dataSource: dataSource,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper) {
    // _renderer = _PyramidSeriesRender();
  }

  ///A collection of data required for rendering the series. If no data source is specified,
  ///empty chart will be rendered without series.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///              )],
  ///        ));
  ///}
  @override
  final List<T>? dataSource;

  ///Maps the field name, which will be considered as x-values.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///              )],
  ///        ));
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal);
  ///   final String xVal;
  ///   final int yVal;
  ///}
  ///```
  @override
  final ChartIndexedValueMapper<D>? xValueMapper;

  ///Maps the field name, which will be considered as y-values.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///              )],
  ///        ));
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal);
  ///   final String xVal;
  ///   final int yVal;
  ///}
  ///```
  @override
  final ChartIndexedValueMapper<num>? yValueMapper;

  ///Name of the series.
  ///
  ///Defaults to ''
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///                name: 'Pyramid'
  ///        ));
  ///}
  ///```
  @override
  final String? name;

  ///Height of the series.
  ///
  ///Defaults to '80%'
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               height:'50%'
  ///        ));
  ///}
  ///```
  final String height;

  ///Width of the series.
  ///
  ///Defaults to '80%'
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               width:'50%'
  ///        ));
  ///}
  ///```
  final String width;

  ///Specifies the rendering type of pyramid.
  ///
  ///Defaults to PyramidMode.linear
  ///
  ///Also refer [PyramidMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               pyramidMode:PyramidMode.surface
  ///        ));
  ///}
  ///```
  final PyramidMode pyramidMode;

  ///Gap ratio between the segments of pyramid. Ranges from 0 to 1
  ///
  ///Defaults to 0.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               gapRatio: 0.3
  ///        ));
  ///}
  ///```
  final double gapRatio;

  ///Customizes the empty data points in the series
  ///
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               emptyPointSettings: EmptyPointSettings (color: Colors.red))
  ///        ));
  ///}
  ///```
  @override
  final EmptyPointSettings emptyPointSettings;

  ///Offset of exploded slice. The value ranges from 0% to 100%.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               explodeOffset: '5%')
  ///        ));
  ///}
  ///```
  final String explodeOffset;

  ///Enables or disables the explode of slices on tap.
  ///
  ///Default to false.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               explode: true)
  ///        ));
  ///}
  ///```
  final bool explode;

  ///Gesture for activating the explode. Explode can be activated in tap, double tap,
  ///and long press.
  ///
  ///Defaults to ActivationMode.tap
  ///
  ///Also refer [ActivationMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               explode: true,
  ///               explodeGesture: ActivationMode.singleTap
  ///             )
  ///        ));
  ///}
  ///```
  final ActivationMode explodeGesture;

  ///Border width of the data points in the series.
  ///
  ///Defaults to 0
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               borderWidth: 2
  ///             )
  ///        ));
  ///}
  ///```
  @override
  final double borderWidth;

  ///Border color of the data points in the series.
  ///
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               borderColor: Colors.red
  ///             )
  ///        ));
  ///}
  ///```
  @override
  final Color borderColor;

  ///Shape of the legend icon. Any shape in the LegendIconType can be applied to this property.
  ///By default, icon will be rendered based on the type of the series.
  ///
  ///
  ///Also refer [LegendIconType]
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               legendIconType: LegendIconType.diamond,
  ///             )
  ///        ));
  ///}
  ///```
  @override
  final LegendIconType legendIconType;

  ///Enables the dataLabel of the series
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               dataLabelSettings: DataLabelSettings(isVisible: true),
  ///             )
  ///        ));
  ///}
  ///```
  @override
  final DataLabelSettings dataLabelSettings;

  ///Duration for animating the data points.
  ///
  ///Defaults to 1500
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               animationDuration: 2000,
  ///             )
  ///        ));
  ///}
  ///```
  @override
  final double animationDuration;

  ///Maps the field name, which will be considered as data point color.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               pointColorMapper: (ChartData data, _) => data.pointColor,
  ///             )
  ///        ));
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.pointColor]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final Color pointColor;
  ///}
  ///```
  @override
  final ChartIndexedValueMapper<Color>? pointColorMapper;

  ///Maps the field name, which will be considered as text for data label.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               textFieldMapper: (ChartData data, _) => data.xVal,
  ///             )
  ///        ));
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.pointColor]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final Color pointColor;
  ///}
  ///```
  final ChartIndexedValueMapper<String>? textFieldMapper;

  ///Opacity of the series. The value ranges from 0 to 1.
  ///
  ///Defaults to 1
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               opacity: 0.5,
  ///             )
  ///        ));
  ///}
  ///```
  @override
  final double opacity;

  ///Customizes the selection of series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               selectionBehavior: SelectionBehavior(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///             )
  ///        ));
  ///}
  ///```
  @override
  final SelectionBehavior selectionBehavior;

  ///Index of the slice to explode it at the initial rendering.
  ///
  ///Defaults to null
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               explodeIndex: 1,
  ///               explode: true
  ///             )
  ///        ));
  ///}
  ///```
  final num? explodeIndex;

  /// List of data indexes initially selected
  ///
  /// Defaults to `null`.
  ///```dart
  ///     Widget build(BuildContext context) {
  ///    return Scaffold(
  ///        body: Center(
  ///            child: Container(
  ///                  child: SfPyramidChart(
  ///                      initialSelectedDataIndexes: <IndexesModel>[IndexesModel(1, 0)]
  ///                 )
  ///              )
  ///          )
  ///      );
  ///  }
  List<int> initialSelectedDataIndexes;

  ///Key to identify a series in a collection.

  ///

  ///On specifying [ValueKey] as the series [key], existing series index
  ///can be changed in the series collection without losing its state.

  ///

  ///When a new series is added dynamically to the collection,
  ///existing series index will be changed. On that case,

  /// the existing series and its state will be linked based on its chart type and this key value.

  ///

  ///Defaults to `null`.

  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<SalesData, num>(
  ///                      key: const ValueKey<String>('line_series_key'),
  ///                 ),
  ///        ));
  ///}
  ///```
  final ValueKey<String>? key;

  ///Used to create the renderer for custom series.
  ///
  ///This is applicable only when the custom series is defined in the sample
  /// and for built-in series types, it is not applicable.
  ///
  ///Renderer created in this will hold the series state and
  /// this should be created for each series. [onCreateRenderer] callback
  /// function should return the renderer class and should not return null.
  ///
  ///Series state will be created only once per series and will not be created
  ///again when we update the series.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<SalesData, num>(
  ///                  onCreateRenderer:(PyramidSeries<dynamic, dynamic> series){
  ///                      return CustomLinerSeriesRenderer();
  ///                    }
  ///                ),
  ///        ));
  /// }
  ///  class CustomLinerSeriesRenderer extends PyramidSeriesRenderer {
  ///       // custom implementation here...
  ///  }
  ///```
  final ChartSeriesRendererFactory<T, D>? onCreateRenderer;

  ///Triggers when the series renderer is created.

  ///

  ///Using this callback, able to get the [ChartSeriesController] instance, which is used to access the public methods in the series.

  ///

  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<SalesData, num>(
  ///                    onRendererCreated: (PyramidSeriesController controller) {
  ///                       _chartSeriesController = controller;
  ///                    },
  ///              ],
  ///        ));
  ///}
  ///```
  final PyramidSeriesRendererCreatedCallback? onRendererCreated;

  ///Called when tapped on the chart data point.
  ///
  ///The user can fetch the series index, point index, viewport point index and
  /// data of the tapped data point.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <LineSeries<SalesData, num>>[
  ///                LineSeries<SalesData, num>(
  ///                    onPointTap: (ChartPointDetails details) {
  ///                       print(details.pointIndex);
  ///                    },
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ChartPointInteractionCallback? onPointTap;

  ///Called when double tapped on the chart data point.
  ///
  ///The user can fetch the series index, point index, viewport point index and
  /// data of the double-tapped data point.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <LineSeries<SalesData, num>>[
  ///                LineSeries<SalesData, num>(
  ///                    onPointDoubleTap: (ChartPointDetails details) {
  ///                       print(details.pointIndex);
  ///                    },
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ChartPointInteractionCallback? onPointDoubleTap;

  ///Called when long pressed on the chart data point.
  ///
  ///The user can fetch the series index, point index, viewport point index and
  /// data of the long-pressed data point.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <LineSeries<SalesData, num>>[
  ///                LineSeries<SalesData, num>(
  ///                    onPointLongPress: (ChartPointDetails details) {
  ///                       print(details.pointIndex);
  ///                    },
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ChartPointInteractionCallback? onPointLongPress;

  @override
  void calculateEmptyPointValue(
      int pointIndex, dynamic currentPoint, dynamic seriesRenderer) {
    final List<PointInfo<dynamic>> dataPoints = seriesRenderer._dataPoints;
    final EmptyPointSettings empty = emptyPointSettings;
    final int pointLength = dataPoints.length;
    final PointInfo<dynamic> point = dataPoints[pointIndex];
    if (point.y == null) {
      switch (empty.mode) {
        case EmptyPointMode.average:
          final num previous =
              pointIndex - 1 >= 0 ? dataPoints[pointIndex - 1].y ?? 0 : 0;
          final num next = pointIndex + 1 <= pointLength - 1
              ? dataPoints[pointIndex + 1].y ?? 0
              : 0;
          point.y = (previous + next).abs() / 2;
          point.isVisible = true;
          point.isEmpty = true;
          break;
        case EmptyPointMode.zero:
          point.y = 0;
          point.isVisible = true;
          point.isEmpty = true;
          break;
        default:
          point.isEmpty = true;
          point.isVisible = false;
          break;
      }
    }
  }
}

/// Renders the pyramid series
///
/// To render a pyramid chart, create an instance of [PyramidSeries], and add it to the series property of [SfPyramidChart],
/// it is the form of a triangle with lines dividing it into sections.
///
/// Provides the property of color, [opacity], border color and border width for customizing the appearance.
///
@immutable
class PyramidSeries<T, D> extends _PyramidSeriesBase<T, D> {
  /// Creating an argument constructor of PyramidSeries class.
  PyramidSeries({
    ValueKey<String>? key,
    ChartSeriesRendererFactory<T, D>? onCreateRenderer,
    PyramidSeriesRendererCreatedCallback? onRendererCreated,
    ChartPointInteractionCallback? onPointTap,
    ChartPointInteractionCallback? onPointDoubleTap,
    ChartPointInteractionCallback? onPointLongPress,
    List<T>? dataSource,
    ChartValueMapper<T, D>? xValueMapper,
    ChartValueMapper<T, num>? yValueMapper,
    ChartValueMapper<T, Color>? pointColorMapper,
    ChartValueMapper<T, String>? textFieldMapper,
    String? name,
    String? height,
    String? width,
    PyramidMode? pyramidMode,
    double? gapRatio,
    LegendIconType? legendIconType,
    EmptyPointSettings? emptyPointSettings,
    DataLabelSettings? dataLabelSettings,
    double? animationDuration,
    double? opacity,
    Color? borderColor,
    double? borderWidth,
    bool? explode,
    num? explodeIndex,
    ActivationMode? explodeGesture,
    String? explodeOffset,
    SelectionBehavior? selectionBehavior,
    List<int>? initialSelectedDataIndexes,
  }) : super(
          key: key,
          onCreateRenderer: onCreateRenderer,
          onRendererCreated: onRendererCreated,
          onPointTap: onPointTap,
          onPointDoubleTap: onPointDoubleTap,
          onPointLongPress: onPointLongPress,
          dataSource: dataSource,
          xValueMapper: (int index) => xValueMapper!(dataSource![index], index),
          yValueMapper: (int index) => yValueMapper!(dataSource![index], index),
          pointColorMapper: (int index) => pointColorMapper != null
              ? pointColorMapper(dataSource![index], index)
              : null,
          textFieldMapper: (int index) => textFieldMapper != null
              ? textFieldMapper(dataSource![index], index)
              : null,
          name: name,
          height: height,
          width: width,
          pyramidMode: pyramidMode,
          gapRatio: gapRatio,
          emptyPointSettings: emptyPointSettings,
          dataLabelSettings: dataLabelSettings,
          legendIconType: legendIconType,
          opacity: opacity,
          borderColor: borderColor,
          borderWidth: borderWidth,
          animationDuration: animationDuration,
          explode: explode,
          explodeIndex: explodeIndex,
          explodeOffset: explodeOffset,
          explodeGesture: explodeGesture,
          selectionBehavior: selectionBehavior,
          initialSelectedDataIndexes: initialSelectedDataIndexes,
        );

  /// Create the  pie series renderer.
  PyramidSeriesRenderer createRenderer(PyramidSeries<T, D> series) {
    PyramidSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as PyramidSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return PyramidSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PyramidSeries &&
        other.onCreateRenderer == onCreateRenderer &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.textFieldMapper == textFieldMapper &&
        other.name == name &&
        other.height == height &&
        other.width == width &&
        other.pyramidMode == pyramidMode &&
        other.gapRatio == gapRatio &&
        other.legendIconType == legendIconType &&
        other.emptyPointSettings == emptyPointSettings &&
        other.dataLabelSettings == dataLabelSettings &&
        other.animationDuration == animationDuration &&
        other.opacity == opacity &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.explode == explode &&
        other.explodeIndex == explodeIndex &&
        other.explodeGesture == explodeGesture &&
        other.explodeOffset == explodeOffset &&
        other.selectionBehavior == selectionBehavior &&
        listEquals(
            other.initialSelectedDataIndexes, initialSelectedDataIndexes);
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      onCreateRenderer,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress,
      dataSource,
      xValueMapper,
      yValueMapper,
      pointColorMapper,
      textFieldMapper,
      name,
      height,
      width,
      pyramidMode,
      gapRatio,
      legendIconType,
      emptyPointSettings,
      dataLabelSettings,
      animationDuration,
      opacity,
      borderColor,
      borderWidth,
      explode,
      explodeIndex,
      explodeGesture,
      explodeOffset,
      selectionBehavior,
      initialSelectedDataIndexes
    ];
    return hashList(values);
  }
}

class _PyramidChartPainter extends CustomPainter {
  _PyramidChartPainter({
    required this.chartState,
    required this.seriesIndex,
    required this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    required ValueNotifier<num> notifier,
  }) : super(repaint: notifier);
  final SfPyramidChartState chartState;
  final int seriesIndex;
  final bool isRepaint;
  final AnimationController? animationController;
  final Animation<double>? seriesAnimation;
  late PyramidSeriesRenderer seriesRenderer;
  //ignore: unused_field
  static late PointInfo<dynamic> point;

  @override
  void paint(Canvas canvas, Size size) {
    seriesRenderer =
        chartState._chartSeries.visibleSeriesRenderers[seriesIndex];

    double animationFactor, factor, height;
    for (int pointIndex = 0;
        pointIndex < seriesRenderer._renderPoints!.length;
        pointIndex++) {
      if (seriesRenderer._renderPoints![pointIndex].isVisible) {
        animationFactor = seriesAnimation != null ? seriesAnimation!.value : 1;
        if (seriesRenderer._series.animationDuration > 0 &&
            !chartState._renderingDetails.isLegendToggled) {
          factor = (chartState._renderingDetails.chartAreaRect.top +
                  chartState._renderingDetails.chartAreaRect.height) -
              animationFactor *
                  (chartState._renderingDetails.chartAreaRect.top +
                      chartState._renderingDetails.chartAreaRect.height);
          height = chartState._renderingDetails.chartAreaRect.top +
              chartState._renderingDetails.chartAreaRect.height -
              factor;
          canvas.clipRect(Rect.fromLTRB(
              0,
              chartState._renderingDetails.chartAreaRect.top +
                  chartState._renderingDetails.chartAreaRect.height -
                  height,
              chartState._renderingDetails.chartAreaRect.left +
                  chartState._renderingDetails.chartAreaRect.width,
              chartState._renderingDetails.chartAreaRect.top +
                  chartState._renderingDetails.chartAreaRect.height));
        }
        chartState._chartSeries
            ._calculatePyramidSegments(canvas, pointIndex, seriesRenderer);
      }
    }
  }

  @override
  bool shouldRepaint(_PyramidChartPainter oldDelegate) => true;
}

/// Creates series renderer for Pyramid series
class PyramidSeriesRenderer extends ChartSeriesRenderer {
  /// Calling the default constructor of PyramidSeriesRenderer class.
  PyramidSeriesRenderer();

  late PyramidSeries<dynamic, dynamic> _series;
  //Internal variables
  late String _seriesType;
  late List<PointInfo<dynamic>> _dataPoints;
  List<PointInfo<dynamic>>? _renderPoints;
  late num _sumOfPoints;
  late Size _triangleSize;
  late num _explodeDistance;
  late Rect _maximumDataLabelRegion;
  PyramidSeriesController? _controller;
  late SfPyramidChartState _chartState;

  /// Repaint notifier for series
  late ValueNotifier<int> _repaintNotifier;
  late DataLabelSettingsRenderer _dataLabelSettingsRenderer;
  late SelectionBehaviorRenderer _selectionBehaviorRenderer;
  late dynamic _selectionBehavior;
  // ignore: prefer_final_fields
  bool _isSelectionEnable = false;
}

///We can redraw the series with updating or creating new points by using this controller.If we need to access the redrawing methods
///in this before we must get the ChartSeriesController onRendererCreated event.
class PyramidSeriesController {
  /// Creating an argument constructor of PyramidSeriesController class.
  PyramidSeriesController(this.seriesRenderer);

  ///Used to access the series properties.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<SalesData, num>(
  ///                    onRendererCreated: (PyramidSeriesController controller) {
  ///                       _chartSeriesController = controller;
  ///                       // prints series yAxisName
  ///                      print(_chartSeriesController.seriesRenderer._series.yAxisName);
  ///                    },
  ///                ),
  ///        ));
  ///}
  ///```
  final PyramidSeriesRenderer seriesRenderer;

  ///Used to process only the newly added, updated and removed data points in a series,
  /// instead of processing all the data points.
  ///
  ///To re-render the chart with modified data points, setState() will be called.
  /// This will render the process and render the chart from scratch.
  /// Thus, the app’s performance will be degraded on continuous update.
  /// To overcome this problem, [updateDataSource] method can be called by passing updated data points indexes.
  /// Chart will process only that point and skip various steps like bounds calculation,
  /// old data points processing, etc. Thus, this will improve the app’s performance.
  ///
  ///The following are the arguments of this method.
  /// * addedDataIndexes – `List<int>` type – Indexes of newly added data points in the existing series.
  /// * removedDataIndexes – `List<int>` type – Indexes of removed data points in the existing series.
  /// * updatedDataIndexes – `List<int>` type – Indexes of updated data points in the existing series.
  /// * addedDataIndex – `int` type – Index of newly added data point in the existing series.
  /// * removedDataIndex – `int` type – Index of removed data point in the existing series.
  /// * updatedDataIndex – `int` type – Index of updated data point in the existing series.
  ///
  ///Returns `void`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    PyramidSeriesController _pyramidSeriesController;
  ///    return Column(
  ///      children: <Widget>[
  ///      Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<SalesData, num>(
  ///                   dataSource: chartData,
  ///                    onRendererCreated: (PyramidSeriesController controller) {
  ///                       _pyramidSeriesController = controller;
  ///                    },
  ///                ),
  ///        )),
  ///   Container(
  ///      child: RaisedButton(
  ///           onPressed: () {
  ///           chartData.removeAt(0);
  ///           chartData.add(ChartData(3,23));
  ///           _pyramidSeriesController.updateDataSource(
  ///               addedDataIndexes: <int>[chartData.length -1],
  ///               removedDataIndexes: <int>[0],
  ///           );
  ///      })
  ///   )]
  ///  );
  /// }
  ///```
  void updateDataSource(
      {List<int>? addedDataIndexes,
      List<int>? removedDataIndexes,
      List<int>? updatedDataIndexes,
      int? addedDataIndex,
      int? removedDataIndex,
      int? updatedDataIndex}) {
    if (removedDataIndexes != null && removedDataIndexes.isNotEmpty) {
      _removeDataPointsList(removedDataIndexes);
    } else if (removedDataIndex != null) {
      _removeDataPoint(removedDataIndex);
    }
    if (addedDataIndexes != null && addedDataIndexes.isNotEmpty) {
      _addOrUpdateDataPoints(addedDataIndexes, false);
    } else if (addedDataIndex != null) {
      _addOrUpdateDataPoint(addedDataIndex, false);
    }
    if (updatedDataIndexes != null && updatedDataIndexes.isNotEmpty) {
      _addOrUpdateDataPoints(updatedDataIndexes, true);
    } else if (updatedDataIndex != null) {
      _addOrUpdateDataPoint(updatedDataIndex, true);
    }
    _updatePyramidSeries();
  }

  /// Add or update the data points on dynamic series update
  void _addOrUpdateDataPoints(List<int> indexes, bool needUpdate) {
    int dataIndex;
    for (int i = 0; i < indexes.length; i++) {
      dataIndex = indexes[i];
      _addOrUpdateDataPoint(dataIndex, needUpdate);
    }
  }

  /// add or update a data point in the given index
  void _addOrUpdateDataPoint(int index, bool needUpdate) {
    final PyramidSeries<dynamic, dynamic> series = seriesRenderer._series;
    if (index >= 0 &&
        series.dataSource!.length > index &&
        series.dataSource![index] != null) {
      final ChartIndexedValueMapper<dynamic>? xValue = series.xValueMapper;
      final ChartIndexedValueMapper<dynamic>? yValue = series.yValueMapper;
      final PointInfo<dynamic> _currentPoint =
          PointInfo<dynamic>(xValue!(index), yValue!(index));
      if (_currentPoint.x != null) {
        if (needUpdate) {
          if (seriesRenderer._dataPoints.length > index) {
            seriesRenderer._dataPoints[index] = _currentPoint;
          }
        } else {
          if (seriesRenderer._dataPoints.length == index) {
            seriesRenderer._dataPoints.add(_currentPoint);
          } else if (seriesRenderer._dataPoints.length > index && index >= 0) {
            seriesRenderer._dataPoints.insert(index, _currentPoint);
          }
        }
      }
    }
  }

  ///Remove list of points
  void _removeDataPointsList(List<int> removedDataIndexes) {
    ///Remove the redudant index from the list
    final List<int> indexList = removedDataIndexes.toSet().toList();
    indexList.sort((int b, int a) => a.compareTo(b));
    int dataIndex;
    for (int i = 0; i < indexList.length; i++) {
      dataIndex = indexList[i];
      _removeDataPoint(dataIndex);
    }
  }

  /// remove a data point in the given index
  void _removeDataPoint(int index) {
    if (seriesRenderer._dataPoints.isNotEmpty &&
        index >= 0 &&
        index < seriesRenderer._dataPoints.length) {
      seriesRenderer._dataPoints.removeAt(index);
    }
  }

  /// After add/remove/update datapoints, recalculate the chart angle and positions
  void _updatePyramidSeries() {
    final SfPyramidChartState _chartState = seriesRenderer._chartState;
    _chartState._chartSeries._processDataPoints();
    _chartState._chartSeries._initializeSeriesProperties(seriesRenderer);
    seriesRenderer._repaintNotifier.value++;
    if (seriesRenderer._series.dataLabelSettings.isVisible &&
        _chartState._renderDataLabel != null) {
      _chartState._renderDataLabel!.state?.render();
    }
    if (seriesRenderer._series.dataLabelSettings.isVisible &&
        _chartState._renderingDetails.chartTemplate != null &&
        // ignore: unnecessary_null_comparison
        _chartState._renderingDetails.chartTemplate!.state != null) {
      _chartState._renderingDetails.chartTemplate!.state.templateRender();
    }
  }
}
