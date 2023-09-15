import 'package:flutter/material.dart';
import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../common/common.dart';
import '../../common/series/chart_series.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../utils/common.dart';

/// Represents the class of pyramid series base.
class PyramidSeriesBase<T, D> extends ChartSeries<T, D>
    implements TriangularChartEmptyPointBehavior {
  /// Creates an instance of pyramid series base.
  PyramidSeriesBase({
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
    double? animationDelay,
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
        animationDelay = animationDelay ?? 0,
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

  /// A collection of data required for rendering the series. If no data source is specified,
  /// empty chart will be rendered without series.
  ///
  /// Defaults to `null`.
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
  ///              )
  ///           ],
  ///        )
  ///    );
  ///}
  @override
  final List<T>? dataSource;

  /// Maps the field name, which will be considered as x-values.
  ///
  /// Defaults to `null`.
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
  ///              )
  ///           ],
  ///        )
  ///    );
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal);
  ///   final String xVal;
  ///   final int yVal;
  ///}
  ///```
  @override
  final ChartIndexedValueMapper<D>? xValueMapper;

  /// Maps the field name, which will be considered as y-values.
  ///
  /// Defaults to `null`.
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
  ///              )
  ///           ],
  ///        )
  ///    );
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal);
  ///   final String xVal;
  ///   final int yVal;
  ///}
  ///```
  @override
  final ChartIndexedValueMapper<num>? yValueMapper;

  /// Name of the series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///                name: 'Pyramid'
  ///        )
  ///    );
  ///}
  ///```
  @override
  final String? name;

  /// Height of the series.
  ///
  /// Defaults to `80%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               height:'50%'
  ///        )
  ///   );
  ///}
  ///```
  final String height;

  /// Width of the series.
  ///
  /// Defaults to `80%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               width:'50%'
  ///        )
  ///    );
  ///}
  ///```
  final String width;

  /// Specifies the rendering type of pyramid.
  ///
  /// Defaults to `PyramidMode.linear`.
  ///
  /// Also refer [PyramidMode].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               pyramidMode:PyramidMode.surface
  ///        )
  ///    );
  ///}
  ///```
  final PyramidMode pyramidMode;

  /// Gap ratio between the segments of pyramid. Ranges from 0 to 1.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               gapRatio: 0.3
  ///        )
  ///    );
  ///}
  ///```
  final double gapRatio;

  /// Customizes the empty data points in the series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               emptyPointSettings: EmptyPointSettings (color: Colors.red))
  ///        )
  ///    );
  ///}
  ///```
  @override
  final EmptyPointSettings emptyPointSettings;

  /// Offset of exploded slice. The value ranges from 0% to 100%.
  ///
  /// Defaults to `10%`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               explodeOffset: '5%')
  ///        )
  ///    );
  ///}
  ///```
  final String explodeOffset;

  /// Enables or disables the explode of slices on tap.
  ///
  /// Default to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               explode: true)
  ///        )
  ///   );
  ///}
  ///```
  final bool explode;

  /// Gesture for activating the explode.
  ///
  /// Explode can be activated in `ActivationMode.none`, `ActivationMode.singleTap` ,
  /// `ActivationMode.doubleTap` and `ActivationMode.longPress`.
  ///
  /// Defaults to `ActivationMode.singleTap`.
  ///
  /// Also refer [ActivationMode].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               explode: true,
  ///               explodeGesture: ActivationMode.singleTap
  ///             )
  ///        )
  ///    );
  ///}
  ///```
  final ActivationMode explodeGesture;

  /// Border width of the data points in the series.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               borderWidth: 2
  ///             )
  ///        )
  ///    );
  ///}
  ///```
  @override
  final double borderWidth;

  /// Border color of the data points in the series.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               borderColor: Colors.red
  ///             )
  ///        )
  ///    );
  ///}
  ///```
  @override
  final Color borderColor;

  /// Shape of the legend icon.
  ///
  /// Defaults to `LegendIconType.seriesType`.
  ///
  /// Also refer [LegendIconType].
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               legendIconType: LegendIconType.diamond,
  ///             )
  ///        )
  ///    );
  ///}
  ///```
  @override
  final LegendIconType legendIconType;

  /// Customizes the data labels in a series. Data label is a text, which displays
  /// the details about the data point.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               dataLabelSettings: DataLabelSettings(isVisible: true),
  ///             )
  ///        )
  ///    );
  ///}
  ///```
  @override
  final DataLabelSettings dataLabelSettings;

  /// Duration for animating the data points.
  ///
  /// Defaults to `1500`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               animationDuration: 2000,
  ///             )
  ///        )
  ///    );
  ///}
  ///```
  @override
  final double animationDuration;

  /// Delay duration of the series animation.It takes a millisecond value as input.
  /// By default, the series will get animated for the specified duration.
  /// If animationDelay is specified, then the series will begin to animate
  /// after the specified duration.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               animationDelay: 2000,
  ///             )
  ///        )
  ///    );
  ///}
  ///```
  @override
  final double animationDelay;

  /// Maps the field name, which will be considered as data point color.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               xValueMapper: (ChartData data, _) => data.xVal,
  ///               yValueMapper: (ChartData data, _) => data.yVal,
  ///               pointColorMapper: (ChartData data, _) => data.pointColor,
  ///             )
  ///        )
  ///    );
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

  /// Maps the field name, which will be considered as a text.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               xValueMapper: (ChartData data, _) => data.xVal,
  ///               yValueMapper: (ChartData data, _) => data.yVal,
  ///               textFieldMapper: (ChartData data, _) => data.xVal,
  ///             )
  ///        )
  ///    );
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal);
  ///   final String xVal;
  ///   final int yVal;
  ///}
  ///```
  final ChartIndexedValueMapper<String>? textFieldMapper;

  /// Opacity of the series. The value ranges from 0 to 1.
  ///
  /// Defaults to `1`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               opacity: 0.5,
  ///             )
  ///        )
  ///    );
  ///}
  ///```
  @override
  final double opacity;

  /// Customizes the selection of series.
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
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               selectionBehavior: _selectionBehavior,
  ///             )
  ///        )
  ///    );
  ///}
  ///```
  @override
  final SelectionBehavior selectionBehavior;

  /// Index of the slice to explode it at the initial rendering.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<ChartData, String>(
  ///               explodeIndex: 1,
  ///               explode: true
  ///             )
  ///         )
  ///     );
  ///}
  ///```
  final num? explodeIndex;

  /// List of data indexes initially selected.
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

  /// Key to identify a series in a collection.
  ///
  /// On specifying [ValueKey] as the series [key], existing series index
  /// can be changed in the series collection without losing its state.
  ///
  /// When a new series is added dynamically to the collection,
  /// existing series index will be changed. On that case,
  /// the existing series and its state will be linked based on its chart type and this key value.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<SalesData, num>(
  ///                      key: const ValueKey<String>('line_series_key'),
  ///                 ),
  ///           )
  ///    );
  ///}
  ///```
  final ValueKey<String>? key;

  /// Used to create the renderer for custom series.
  ///
  /// This is applicable only when the custom series is defined in the sample
  /// and for built-in series types, it is not applicable.
  ///
  /// Renderer created in this will hold the series state and
  /// this should be created for each series. [onCreateRenderer] callback
  /// function should return the renderer class and should not return null.
  ///
  /// Series state will be created only once per series and will not be created
  /// again when we update the series.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<SalesData, num>(
  ///                  onCreateRenderer:(PyramidSeries<dynamic, dynamic> series){
  ///                      return CustomPyramidSeriesRenderer();
  ///                    }
  ///              ),
  ///        )
  ///     );
  /// }
  ///  class CustomPyramidSeriesRenderer extends PyramidSeriesRenderer {
  ///       // custom implementation here...
  ///  }
  ///```
  final ChartSeriesRendererFactory<T, D>? onCreateRenderer;

  /// Triggers when the series renderer is created.
  /// Using this callback, able to get the [ChartSeriesController] instance, which is used to access the public methods in the series.
  ///
  /// Defaults to `null`.
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
  ///        )
  ///    );
  ///}
  ///```
  final PyramidSeriesRendererCreatedCallback? onRendererCreated;

  /// Called when tapped on the chart data point.
  ///
  /// The user can fetch the series index, point index, view port index and
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
  ///        )
  ///    );
  ///}
  ///```
  final ChartPointInteractionCallback? onPointTap;

  /// Called when double tapped on the chart data point.
  ///
  /// The user can fetch the series index, point index, view port index and
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
  ///        )
  ///    );
  ///}
  ///```
  final ChartPointInteractionCallback? onPointDoubleTap;

  /// Called when long pressed on the chart data point.
  ///
  /// The user can fetch the series index, point index, view port index and
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
  ///        )
  ///     );
  ///}
  ///```
  final ChartPointInteractionCallback? onPointLongPress;

  @override
  void calculateEmptyPointValue(
      int pointIndex, dynamic currentPoint, dynamic seriesRenderer) {
    final List<PointInfo<dynamic>> dataPoints = seriesRenderer.dataPoints;
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
        // ignore: no_default_cases
        default:
          point.isEmpty = true;
          point.isVisible = false;
          break;
      }
    }
  }
}
