import 'package:flutter/material.dart';
import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../common/common.dart';
import '../../common/series/chart_series.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../base/circular_base.dart';
import '../renderer/renderer_base.dart';
import '../renderer/renderer_extension.dart';
import '../utils/enum.dart';
import 'chart_point.dart';

/// This class holds the property of circular series.
///
/// To render the Circular chart, create an instance of [PieSeries] or [DoughnutSeries] or [RadialBarSeries], and add it to the
/// series collection property of [SfCircularChart]. You can use the radius property to change the diameter of the circular chart for the plot area.
/// Also, explode the circular chart segment by enabling the explode property.
///
/// Provide the options of stroke width, stroke color, opacity, and point color mapper to customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=VJxPp7-2nGk}
class CircularSeries<T, D> extends ChartSeries<T, D>
    implements CircularChartEmptyPointBehavior {
  /// Creating an argument constructor of CircularSeries class.
  CircularSeries(
      {this.key,
      this.onCreateRenderer,
      this.onRendererCreated,
      this.onPointTap,
      this.onPointDoubleTap,
      this.onPointLongPress,
      this.dataSource,
      this.xValueMapper,
      this.yValueMapper,
      this.pointColorMapper,
      this.pointShaderMapper,
      this.pointRadiusMapper,
      this.dataLabelMapper,
      this.sortFieldValueMapper,
      int? startAngle,
      int? endAngle,
      String? radius,
      String? innerRadius,
      bool? explode,
      bool? explodeAll,
      this.explodeIndex,
      ActivationMode? explodeGesture,
      String? explodeOffset,
      this.groupTo,
      this.groupMode,
      this.pointRenderMode,
      String? gap,
      double? opacity,
      EmptyPointSettings? emptyPointSettings,
      Color? borderColor,
      double? borderWidth,
      DataLabelSettings? dataLabelSettings,
      bool? enableTooltip,
      this.name,
      double? animationDuration,
      double? animationDelay,
      SelectionBehavior? selectionBehavior,
      SortingOrder? sortingOrder,
      LegendIconType? legendIconType,
      CornerStyle? cornerStyle,
      List<int>? initialSelectedDataIndexes})
      : startAngle = startAngle ?? 0,
        animationDuration = animationDuration ?? 1500,
        animationDelay = animationDelay ?? 0,
        endAngle = endAngle ?? 360,
        radius = radius ?? '80%',
        innerRadius = innerRadius ?? '50%',
        explode = explode ?? false,
        explodeAll = explodeAll ?? false,
        explodeOffset = explodeOffset ?? '10%',
        explodeGesture = explodeGesture ?? ActivationMode.singleTap,
        gap = gap ?? '1%',
        cornerStyle = cornerStyle ?? CornerStyle.bothFlat,
        dataLabelSettings = dataLabelSettings ?? const DataLabelSettings(),
        emptyPointSettings = emptyPointSettings ?? EmptyPointSettings(),
        selectionBehavior = selectionBehavior ?? SelectionBehavior(),
        borderColor = borderColor ?? Colors.transparent,
        borderWidth = borderWidth ?? 0.0,
        opacity = opacity ?? 1,
        enableTooltip = enableTooltip ?? true,
        sortingOrder = sortingOrder ?? SortingOrder.none,
        legendIconType = legendIconType ?? LegendIconType.seriesType,
        initialSelectedDataIndexes = initialSelectedDataIndexes ?? <int>[],
        super(name: name);

  /// Opacity of the series. The value ranges from 0 to 1.
  ///
  /// Defaults to `1`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                 opacity: 1,
  ///              ),
  ///           ],
  ///        )
  ///   );
  ///}
  ///```
  @override
  final double opacity;

  /// Customizes the data labels in a series. Data label is a text, which displays
  /// the details about the data point.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataLabelSettings: DataLabelSettings(isVisible: true),
  ///              ),
  ///           ],
  ///        )
  ///     );
  ///}
  ///```
  @override
  final DataLabelSettings dataLabelSettings;

  /// A collection of data required for rendering the series.
  ///
  /// If no data source is specified,
  /// empty chart will be rendered without series.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///              ),
  ///           ],
  ///        )
  ///    );
  ///}
  ///```
  @override
  final List<T>? dataSource;

  /// Maps the field name, which will be considered as x-values.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///              ),
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
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///              ),
  ///           ],
  ///        )
  ///   );
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal);
  ///   final String xVal;
  ///   final int yVal;
  ///}
  ///```
  @override
  final ChartIndexedValueMapper<num>? yValueMapper;

  /// Maps the field name, which will be considered as data point color.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10, Colors.red),
  ///                   ChartData('China', 11, Colors.green),
  ///                   ChartData('Russia', 9, Colors.blue),
  ///                   ChartData('Germany', 10, Colors.voilet),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///                pointColorMapper: (ChartData data, _) => data.pointColor,
  ///              ),
  ///           ],
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

  /// Returns the shaders to fill each data point.
  ///
  /// The data points of pie, doughnut and radial bar charts can be filled with [gradient](https://api.flutter.dev/flutter/dart-ui/Gradient-class.html)
  /// (linear, radial and sweep gradient) and [image shaders](https://api.flutter.dev/flutter/dart-ui/ImageShader-class.html).
  ///
  /// A shader specified in a data source cell will be applied to that specific data point. Also, a data point may have a gradient
  /// and another data point may have an image shader.
  ///
  /// The user can also get the data, index, color and rect values of the specific data point from [ChartShaderMapper] and
  /// can use this method, for creating shaders.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///import 'dart:ui' as ui;
  ///
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10, ui.Gradient.radial(Offset(112.4, 140.0), 90, [
  ///                            Colors.pink,
  ///                            Colors.red,
  ///                          ], [
  ///                            0.25,
  ///                          0.5,
  ///                          ]),),
  ///                   ChartData('China', 11, ui.Gradient.sweep(Offset(112.4, 140.0),[
  ///                            Colors.pink,
  ///                            Colors.red,
  ///                          ], [
  ///                            0.25,
  ///                          0.5,
  ///                          ]),),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///                pointShaderMapper: (ChartData data, _, Color color, Rect rect) => data.pointShader,
  ///              ),
  ///           ],
  ///        )
  ///   );
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.pointShader]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final Shader pointShader;
  ///}
  ///```
  final ChartShaderMapper<dynamic>? pointShaderMapper;

  /// Maps the field name, which will be considered for calculating the radius of
  /// all the data points.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10, '50%'),
  ///                   ChartData('China', 11, '55%'),
  ///                   ChartData('Russia', 9, '60%'),
  ///                   ChartData('Germany', 10, '65%'),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///                pointRadiusMapper: (ChartData data, _) => data.radius,
  ///              ),
  ///           ],
  ///        )
  ///    );
  ///}
  ///class ChartData {
  ///   ChartData(this.xVal, this.yVal, [this.radius]);
  ///   final String xVal;
  ///   final int yVal;
  ///   final String radius;
  ///}
  ///```
  final ChartIndexedValueMapper<String>? pointRadiusMapper;

  /// Maps the field name, which will be considered as a text for the data points.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///                dataLabelMapper: (ChartData data, _) => data.xVal,
  ///              ),
  ///             ],
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
  final ChartIndexedValueMapper<String>? dataLabelMapper;

  /// Field in the data source for performing sorting.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                dataSource: <ChartData>[
  ///                   ChartData('USA', 10),
  ///                   ChartData('China', 11),
  ///                   ChartData('Russia', 9),
  ///                   ChartData('Germany', 10),
  ///                ],
  ///                xValueMapper: (ChartData data, _) => data.xVal,
  ///                yValueMapper: (ChartData data, _) => data.yVal,
  ///                sortFieldValueMapper: (ChartData data, _) => data.xVal,
  ///              ),
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
  final ChartIndexedValueMapper<dynamic>? sortFieldValueMapper;

  /// Shape of the legend icon.
  ///
  /// Any shape in the LegendIconType can be applied to this property.
  /// By default, icon will be rendered based on the type of the series.
  ///
  /// Defaults to `LegendIconType.seriesType`.
  ///
  /// Also refer [LegendIconType].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///           series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  legendIconType: LegendIconType.diamond,
  ///                  )
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  @override
  final LegendIconType legendIconType;

  /// Type of sorting.
  ///
  /// The data points in the series can be sorted in ascending or descending
  /// order.The data points will be rendered in the specified order if it is set to none.
  ///
  /// Default to `SortingOrder.none`.
  ///
  /// Also refer [SortingOrder].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///           series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  sortingOrder: SortingOrder.ascending,
  ///                  )
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  @override
  final SortingOrder sortingOrder;

  /// Determines whether to enable tooltip.
  ///
  /// Defaults to `true`.
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
  @override
  final bool enableTooltip;

  /// Border width of the data points in the series.
  ///
  /// Defaults to `0`.
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
  @override
  final double borderWidth;

  /// Border color of the data points in the series.
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
  @override
  final Color borderColor;

  /// Customizes the empty data points in the series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  emptyPointSettings: EmptyPointSettings (color: Colors.red)
  ///                ),
  ///              ],
  ///        )
  ///    );
  ///}
  ///```
  @override
  final EmptyPointSettings emptyPointSettings;

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
  ///        child: SfCircularChart(
  ///           series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  selectionBehavior: _selectionBehavior
  ///                ),
  ///              ],
  ///        )
  ///    );
  ///}
  ///```
  @override
  final SelectionBehavior selectionBehavior;

  /// Starting angle of the series.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  startAngle: 270;
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final int startAngle;

  /// Ending angle of the series.
  ///
  /// Defaults to `360`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  endAngle: 270;
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final int endAngle;

  /// Radius of the series.
  ///
  /// The value ranges from 0% to 100%.
  ///
  /// Defaults to `80%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  radius: '10%';
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final String radius;

  /// Inner radius of the series.
  ///
  /// The value ranges from 0% to 100%.
  ///
  /// Defaults to `50%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <DoughnutSeries<ChartData, String>>[
  ///                DoughnutSeries<ChartData, String>(
  ///                  innerRadius: '20%';
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final String innerRadius;

  /// Enables or disables the explode of slices on tap.
  ///
  /// Default to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  explode: true;
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final bool explode;

  /// Enables or disables exploding all the slices at the initial rendering.
  ///
  /// Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  explodeAll: true
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final bool explodeAll;

  /// Index of the slice to explode it at the initial rendering.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  explode: true,
  ///                  explodeIndex: 2
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final int? explodeIndex;

  /// Offset of exploded slice. The value ranges from 0% to 100%.
  ///
  /// Defaults to `20%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  explode: true,
  ///                  explodeOffset: '30%'
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final String explodeOffset;

  /// Gesture for activating the explode.
  ///
  /// Explode can be activated in `ActivationMode.none`, `ActivationMode.singleTap`, `ActivationMode.doubleTap`,
  /// and `ActivationMode.longPress`.
  ///
  /// Defaults to `ActivationMode.singleTap`.
  ///
  /// Also refer [ActivationMode].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  explode: true,
  ///                  explodeGesture: ActivationMode.singleTap
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final ActivationMode explodeGesture;

  /// Groups the data points of the series based on their index or values.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  groupTo: 4,
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final double? groupTo;

  /// Slice can also be grouped based on the data points value or based on index.
  ///
  /// Defaults to `CircularChartGroupMode.point`.
  ///
  /// Also refer [CircularChartGroupMode].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  groupMode: CircularChartGroupMode.value,
  ///                ),
  ///            ],
  ///        )
  ///   );
  ///}
  ///```
  final CircularChartGroupMode? groupMode;

  /// Defines the painting mode of the data points.
  ///
  /// The data points in pie and doughnut chart can be filled either with solid colors or with sweep gradient
  /// by using this property.
  ///
  /// * If `PointRenderMode.segment` is specified, the data points are filled with solid colors from palette
  /// or with the colors mentioned in `pointColorMapping` property.
  /// * If `PointRenderMode.gradient` is specified, a sweep gradient is formed with the solid colors and fills
  /// the data points.
  ///
  /// _Note:_ This property is applicable only if the `onCreateShader` or `pointShaderMapper` is null and
  /// not applicable for radial bar series.
  ///
  /// Also refer [PointRenderMode].
  ///
  /// Defaults to `pointRenderMode.segment`.
  final PointRenderMode? pointRenderMode;

  /// Specifies the gap between the radial bars in percentage.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  gap: '10%',
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final String gap;

  /// Specifies the radial bar’s corner type.
  ///
  /// _Note:_ This is applicable only for radial bar series type.
  ///
  /// Defaults to `CornerStyle.bothFlat`.
  ///
  /// Also refer [CornerStyle].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  cornerStyle: CornerStyle.bothCurve,
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final CornerStyle cornerStyle;

  /// Name of the series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///              PieSeries<ChartData, String>(
  ///                name: 'default',
  ///              ),
  ///           ],
  ///        )
  ///    );
  ///}
  ///```
  @override
  final String? name;

  /// Duration for animating the data points.
  ///
  /// Defaults to `1500`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  animationDuration: 3000;
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  @override
  final double animationDuration;

  /// Delay duration of the series animation. It takes a millisecond value as input.
  /// By default, the series will get animated for the specified duration.
  /// If animationDelay is specified, then the series will begin to animate
  /// after the specified duration.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<ChartData, String>>[
  ///                PieSeries<ChartData, String>(
  ///                  animationDelay: 500;
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  @override
  final double animationDelay;

  /// List of data indexes initially selected.
  ///
  /// Defaults to `null`.
  ///```dart
  ///     Widget build(BuildContext context) {
  ///    return Scaffold(
  ///        body: Center(
  ///            child: Container(
  ///                  child: SfCircularChart(
  ///                      initialSelectedDataIndexes: <IndexesModel>[IndexesModel(1, 0)]
  ///                 )
  ///              )
  ///          )
  ///      );
  ///  }
  List<int> initialSelectedDataIndexes;

  /// Key to identify a series in a collection.
  ///
  /// On specifying [ValueKey] as the series [key], existing series index can be changed in the series collection without losing its state.
  ///
  /// When a new series is added dynamically to the collection, existing series index will be changed. On that case,
  /// the existing series and its state will be linked based on its chart type and this key value.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <PieSeries<SalesData, num>>[
  ///                PieSeries<SalesData, num>(
  ///                      key: const ValueKey<String>('pie_series_key'),
  ///                 ),
  ///             ],
  ///        )
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
  ///        child: SfCircularChart(
  ///            series: <PieSeries<SalesData, num>>[
  ///                PieSeries<SalesData, num>(
  ///                  onCreateRenderer:(CircularSeries<dynamic, dynamic> series){
  ///                      return CustomPieSeriesRenderer();
  ///                    }
  ///                ),
  ///            ],
  ///        )
  ///    );
  /// }
  ///  class CustomPieSeriesRenderer extends PieSeriesRenderer {
  ///       // custom implementation here...
  ///  }
  ///```
  final ChartSeriesRendererFactory<T, D>? onCreateRenderer;

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
  ///            ],
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
  ///            ],
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
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final ChartPointInteractionCallback? onPointLongPress;

  /// Triggers when the series renderer is created.
  ///
  /// Using this callback, able to get the [ChartSeriesController] instance, which is used to access the public methods in the series.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    ChartSeriesController _chartSeriesController;
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <CircularSeries<SalesData, num>>[
  ///                PieSeries<SalesData, num>(
  ///                    onRendererCreated: (ChartSeriesController controller) {
  ///                       _chartSeriesController = controller;
  ///                    },
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final CircularSeriesRendererCreatedCallback? onRendererCreated;

  /// To calculate empty point values.
  @override
  void calculateEmptyPointValue(
      int pointIndex, ChartPoint<dynamic> currentPoint,
      [CircularSeriesRenderer? seriesRenderer]) {
    final EmptyPointSettings empty = emptyPointSettings;
    final List<ChartPoint<dynamic>>? dataPoints =
        (seriesRenderer as CircularSeriesRendererExtension?)?.dataPoints;
    final int pointLength = dataPoints!.length;
    final ChartPoint<dynamic> point = dataPoints[pointIndex];
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
        case EmptyPointMode.drop:
        case EmptyPointMode.gap:
          point.isEmpty = true;
          point.isVisible = false;
          break;
      }
    }
  }
}

/// To get visible point index.
int? getVisiblePointIndex(
    List<ChartPoint<dynamic>?> points, String loc, int index) {
  if (loc == 'before') {
    for (int i = index; i >= 0; i--) {
      if (points[i - 1]!.isVisible) {
        return i - 1;
      }
    }
  } else {
    for (int i = index; i < points.length; i++) {
      if (points[i + 1]!.isVisible) {
        return i + 1;
      }
    }
  }
  return null;
}
