import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../radial_gauge/annotation/gauge_annotation.dart';
import '../../radial_gauge/axis/radial_axis_parent_widget.dart';
import '../../radial_gauge/axis/radial_axis_scope.dart';
import '../../radial_gauge/axis/radial_axis_widget.dart';
import '../../radial_gauge/gauge/radial_gauge_scope.dart';
import '../../radial_gauge/pointers/gauge_pointer.dart';
import '../../radial_gauge/range/gauge_range.dart';
import '../../radial_gauge/styles/radial_text_style.dart';
import '../../radial_gauge/styles/radial_tick_style.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';
import '../../radial_gauge/utils/radial_gauge_typedef.dart';

/// The [RadialAxis] is a circular arc in which a set of values are
/// displayed along a linear or custom scale
/// based on the design requirements.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///            )]
///        ));
///}
/// ```
class RadialAxis extends StatefulWidget {
  /// Create [RadialAxis] with the default or required scale range and
  /// customized axis properties.
  ///
  /// The arguments [minimum], [maximum], [startAngle], [endAngle],
  /// [radiusFactor], [centerX], [centerY],
  /// [tickOffset] and [labelOffset] must not be null.
  /// Additionally [centerX], [centerY] must be non-negative
  /// and [maximum] must be greater than [minimum].
  RadialAxis(
      {Key? key,
      this.startAngle = 130,
      this.endAngle = 50,
      this.radiusFactor = 0.95,
      this.centerX = 0.5,
      this.centerY = 0.5,
      this.onLabelCreated,
      this.onAxisTapped,
      this.canRotateLabels = false,
      this.showFirstLabel = true,
      this.showLastLabel = false,
      this.canScaleToFit = false,
      this.backgroundImage,
      this.ranges,
      this.pointers,
      this.annotations,
      this.minimum = 0,
      this.maximum = 100,
      this.interval,
      this.minorTicksPerInterval = 1,
      this.showLabels = true,
      this.showAxisLine = true,
      this.showTicks = true,
      this.tickOffset = 0,
      this.labelOffset = 15,
      this.isInversed = false,
      this.maximumLabels = 3,
      this.useRangeColorForAxis = false,
      this.labelFormat,
      NumberFormat? numberFormat,
      this.onCreateAxisRenderer,
      this.ticksPosition = ElementsPosition.inside,
      this.labelsPosition = ElementsPosition.inside,
      this.offsetUnit = GaugeSizeUnit.logicalPixel,
      GaugeTextStyle? axisLabelStyle,
      AxisLineStyle? axisLineStyle,
      MajorTickStyle? majorTickStyle,
      MinorTickStyle? minorTickStyle})
      : assert(
            radiusFactor >= 0, 'Radius factor must be a non-negative value.'),
        assert(centerX >= 0, 'Center X must be a non-negative value.'),
        assert(centerY >= 0, 'Center Y must be a non-negative value.'),
        assert(minimum < maximum, 'Maximum should be greater than minimum.'),
        axisLabelStyle = axisLabelStyle ?? const GaugeTextStyle(),
        axisLineStyle = axisLineStyle ?? const AxisLineStyle(),
        numberFormat = numberFormat ?? NumberFormat('#.##'),
        majorTickStyle = majorTickStyle ?? const MajorTickStyle(),
        minorTickStyle = minorTickStyle ?? const MinorTickStyle(),
        super(key: key);

  /// Specifies the start angle of axis.
  ///
  /// The axis line begins from [startAngle] to [endAngle].
  ///
  /// The picture below illustrates the direction of the angle from 0 degree
  /// to 360 degree.
  ///
  /// ![The radial gauge direction of the angle from 0 degree to
  /// 360 degree.](https://cdn.syncfusion.com/content/images/FTControl/Gauge-Angle.jpg)
  ///
  /// Defaults to 130
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           startAngle: 90,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double startAngle;

  /// Specifies the end angle of axis.
  ///
  /// The axis line begins from [startAngle] to [endAngle].
  ///
  /// The picture below illustrates the direction of the angle from 0 degree
  /// to 360 degree.
  ///
  /// ![The radial gauge direction of the angle from 0 degree to
  /// 360 degree.](https://cdn.syncfusion.com/content/images/FTControl/Gauge-Angle.jpg)
  ///
  /// Defaults to 50
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           endAngle: 90,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double endAngle;

  /// The size of the axis, expressed as the radius (half the diameter)
  /// in factor.
  ///
  /// The [radiusFactor] must be between 0 and 1. Axis radius is determined
  /// by multiplying this factor
  /// value to the minimum width or height of the widget.
  ///
  /// Defaults to 0.95
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           radiusFactor: 0.8,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double radiusFactor;

  /// Left location of center axis.
  ///
  /// The [centerX] value must be between 0 to 1. Change the left position
  /// of the axis inside the boundary of the widget.
  ///
  /// Defaults to 0.5
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           centerX: 0.2,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double centerX;

  /// Top location of center axis.
  ///
  /// The [centerY] value must be between 0 to 1. Change the top position
  /// of the axis inside the boundary of the widget.
  ///
  /// Defaults to 0.5
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           centerY: 0.2,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double centerY;

  /// Whether to show the first label of the axis.
  ///
  /// When [startAngle] and [endAngle] are the same, the first and
  /// last labels are intersected.
  /// To prevent this, enable this property to be false,
  /// if [showLastLabel] is true.
  ///
  /// Defaults to true
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           showFirstLabel: false,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool showFirstLabel;

  /// Whether to show the last label of the axis.
  ///
  /// Defaults to false
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           showLastLabel: false,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool showLastLabel;

  /// Callback that gets triggered when an axis label is created.
  ///
  /// The [RadialAxis] passes the [AxisLabelCreatedArgs] to the callback
  /// used to change text value and rotate the
  /// text based on angle.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           labelCreated: _handleAxisLabelCreated,
  ///            )]
  ///        ));
  ///}
  ///
  ///   void _handleAxisLabelCreated(AxisLabelCreatedArgs args){
  //    if(args.text == '100'){
  //      args.text = 'Completed';
  //      args.canRotate = true;
  //    }
  //  }
  /// ```
  final ValueChanged<AxisLabelCreatedArgs>? onLabelCreated;

  ///  Callback, which is triggered by tapping an axis.
  ///
  /// [RadialAxis] returns the tapped axis value to the callback.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           onAxisTapped: (double value) {
  ///             print('Axis tapped on $value');
  ///            })]
  ///        ));
  ///}
  ///
  /// ```
  final ValueChanged<double>? onAxisTapped;

  /// whether to rotate the labels based on angle.
  ///
  /// Defaults to false
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           canRotateLabels: true,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool canRotateLabels;

  /// The background image of the [RadialAxis]. Changing the image
  /// will set the background to the new image.
  ///
  /// The [backgroundImage] applied for the [RadialAxis] boundary.
  ///
  /// This property is a type of [ImageProvider]. Therefore, you can set
  /// the following types of image on this.
  ///
  /// * [AssetImage]
  /// * [NetworkImage]
  /// * [FileImage]
  /// * [MemoryImage]
  ///
  /// Defaults to null.
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           backgroundImage: AssetImage('images/dark_background.png')
  ///            )]
  ///        ));
  ///}
  ///```
  final ImageProvider? backgroundImage;

  /// Adjust the half or quarter gauge to fit the axis boundary.
  ///
  /// if [canScaleToFit] true, the center and radius position of the axis
  /// will be modified on the basis of the angle value.
  ///
  /// Defaults to false
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           canScaleToFit : true
  ///            )]
  ///        ));
  ///}
  ///```
  final bool canScaleToFit;

  /// Add a list of gauge range to the radial gauge and customize
  /// each range by adding it to the [ranges] collection.
  ///
  /// Also refer [GaugeRange]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final List<GaugeRange>? ranges;

  /// Add a list of gauge pointer to the radial gauge and customize
  /// each pointer by adding it to the [pointers] collection.
  ///
  /// Also refer [GaugePointer]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final List<GaugePointer>? pointers;

  /// Add a list of gauge annotation to the radial gauge and customize
  /// each annotation by adding it to the [annotations] collection.
  ///
  /// Also refer [GaugeAnnotation]
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///            annotations: <GaugeAnnotation>[
  ///            GaugeAnnotation(widget: Text('Annotation'))
  ///            ]
  ///            )]
  ///        ));
  ///}
  /// ```
  final List<GaugeAnnotation>? annotations;

  /// The minimum value for the axis.
  ///
  /// The range of the axis scale is starting from this value.
  ///
  /// Defaults to `0`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          minimum : 30,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double minimum;

  /// The maximum value for the axis.
  ///
  /// The range of the axis scale is end with this value.
  ///
  /// Defaults to `100`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          maximum: 200,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double maximum;

  /// The interval value for the axis.
  ///
  /// Using this, the axis labels can be shown at a certain interval value.
  /// Unless the interval is not defined,
  /// interval will be measured automatically based on scale range
  /// along with the available width.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          interval: 20,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double? interval;

  /// Add minor ticks count per interval.
  ///
  /// Defaults to `1`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          minorTicksPerInterval: 3,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double minorTicksPerInterval;

  /// Whether to show the labels on the axis of the gauge.
  ///
  /// Defaults to `true`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          showLabels: false,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool showLabels;

  /// Whether to show the axis line of the gauge.
  ///
  /// Defaults to `true`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           showAxisLine: false,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool showAxisLine;

  /// Whether to show the ticks on the axis of the gauge.
  ///
  /// Defaults to `true`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           showTicks: false,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool showTicks;

  /// Adjusts the axis ticks distance from the axis line.
  ///
  /// You can specify value either in logical pixel or radius factor
  /// using the [offsetUnit] property.
  /// if [offsetUnit] is [GaugeSizeUnit.factor], value will be given
  /// from 0 to 1. Here ticks placing position is calculated
  /// by [tickOffset] * axis radius value.
  ///
  /// Example: [tickOffset] value is 0.2 and axis radius is 100, ticks
  /// moving 20(0.2 * 100) logical pixels from axis line.
  /// If [offsetUnit] is [GaugeSizeUnit.logicalPixel], the defined value
  /// distance ticks will move from the axis line.
  ///
  /// Defaults to `0` and [offsetUnit] is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           tickOffset: 20
  ///            )]
  ///        ));
  ///}
  /// ```
  final double tickOffset;

  /// Adjusts the axis label distance from tick end.
  ///
  /// You can specify value either in logical pixel or radius factor using the
  /// [offsetUnit] property.
  /// if [offsetUnit] is [GaugeSizeUnit.factor], value will be given
  /// from 0 to 1. Here labels placing position is calculated
  /// by [labelOffset] * axis radius value.
  ///
  /// Example: [labelOffset] value is 0.2 and axis radius is 100, labels
  /// moving 20(0.2 * 100) logical pixels from ticks end.
  /// If [offsetUnit] is [GaugeSizeUnit.logicalPixel], the defined value
  /// distance labels will move from the end of the tick.
  ///
  /// Defaults to `15` and [offsetUnit] is `GaugeSizeUnit.logicalPixel`.
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           labelOffset: 30
  ///            )]
  ///        ));
  ///}
  ///```
  final double labelOffset;

  /// Inverts the axis from right to left.
  ///
  /// Axis is rendered by default in the clockwise direction and can be
  /// inverted to render the axis element in the counter clockwise direction.
  ///
  /// Defaults to `false`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///            isInversed: true,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool isInversed;

  /// The maximum number of labels to be displayed in 100 logical
  /// pixels on the axis.
  ///
  /// Defaults to `3`.
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           maximumLabels: 5
  ///            )]
  ///        ));
  ///}
  ///```
  final int maximumLabels;

  /// Whether to use the range color for axis elements such as labels and ticks.
  ///
  /// Defaults to `false`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           useRangeColorForAxis : true,
  ///           ranges: <GaugeRange>[GaugeRange(
  ///           startValue: 50,
  ///           endValue: 100)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool useRangeColorForAxis;

  /// Formats the axis labels.
  ///
  /// The labels can be customized by adding the desired text as prefix
  /// or suffix.
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           labelFormat: '{value}M'
  ///            )]
  ///        ));
  ///}
  /// ```
  final String? labelFormat;

  /// Formats the axis labels with globalized label formats.
  ///
  /// Defaults to `null`.
  ///
  /// Also refer [NumberFormat].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           numberFormat: NumberFormat.currencyCompact()
  ///            )]
  ///        ));
  ///}
  /// ```
  final NumberFormat? numberFormat;

  /// Positions the tick lines inside or outside the axis line.
  ///
  /// If [ElementsPosition.inside], the position of the tick is inside the
  /// axis line.
  /// If [ElementsPosition.outside], the position of the tick is outside the
  /// axis line.
  ///
  /// Defaults to `ElementsPosition.inside`.
  ///
  /// Also refer [ElementsPosition].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           ticksPosition: ElementsPosition.outside,
  ///            )]
  ///        ));
  ///}
  /// ```
  final ElementsPosition ticksPosition;

  /// Positions the axis labels inside or outside the axis line.
  ///
  /// If [ElementsPosition.inside], the position of the labels is inside the
  /// axis line.
  /// If [ElementsPosition.outside], the position of the labels is outside the
  /// axis line.
  ///
  /// Defaults to `ElementsPosition.inside`.
  ///
  /// Also refer [ElementsPosition]
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           labelsPosition: ElementsPosition.outside,
  ///            )]
  ///        ));
  ///}
  /// ```
  final ElementsPosition labelsPosition;

  /// The style to use for the axis label text.
  ///
  /// Using [GaugeTextStyle] to add the style to the axis labels.
  ///
  /// Defaults to the [GaugeTextStyle] property with font size `12.0` and
  /// font family `Segoe UI`.
  ///
  /// Also refer [GaugeTextStyle]
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          axisLabelStyle: GaugeTextStyle(fontSize: 20,
  ///          fontStyle: FontStyle.italic),
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeTextStyle axisLabelStyle;

  /// The style to use for the axis line.
  ///
  /// Using [AxisLineStyle] to add the customized style to the axis line.
  ///
  /// Defaults to the [AxisLineStyle] property with thickness `10
  /// logical pixels`.
  ///
  /// Also refer [AxisLineStyle]
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           axisLineStyle: AxisLineStyle(color: Colors.red,
  ///           thickness: 20),
  ///            )]
  ///        ));
  ///}
  /// ```
  final AxisLineStyle axisLineStyle;

  /// The style to use for the major axis tick lines.
  ///
  /// Using [MajorTickStyle] to add the customized style to the axis
  /// major tick line.
  ///
  /// Defaults to the [MajorTickStyle] property with length `10 logical
  /// pixels`.
  ///
  /// Also refer [MajorTickStyle]
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///            majorTickStyle: MajorTickStyle(color: Colors.red,
  ///            thickness: 3,
  ///            length: 10),
  ///            )]
  ///        ));
  ///}
  /// ```
  final MajorTickStyle majorTickStyle;

  /// The style to use for the minor axis tick lines.
  ///
  /// Using [MinorTickStyle] to add the customized style to the axis minor tick
  /// line.
  ///
  /// Defaults to the [MinorTickStyle] property with length `5
  /// logical pixels`.
  ///
  /// Also refer [MinorTickStyle].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///            minorTickStyle: MinorTickStyle(color: Colors.red,
  ///            thickness: 3,
  ///            length: 10),
  ///            )]
  ///        ));
  ///}
  /// ```
  final MinorTickStyle minorTickStyle;

  /// Calculates the position either in logical pixel or radius factor.
  ///
  /// Using [GaugeSizeUnit], axis ticks and label position is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.logicalPixel`.
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           labelOffset: 0.3, offsetUnit: GaugeSizeUnit.factor
  ///            )]
  ///        ));
  ///}
  ///```
  final GaugeSizeUnit offsetUnit;

  /// The callback that is called when the custom renderer for
  /// the custom axis is created. and it is not applicable for
  /// built-in axis
  ///
  /// The corresponding axis is passed as the argument to the callback in
  /// order to access the axis property
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           onCreateAxisRenderer: handleCreateAxisRenderer,
  ///            )]
  ///        ));
  ///}
  ///
  /// Called before creating the renderer
  /// GaugeAxisRenderer handleCreateAxisRenderer(){
  /// final _CustomAxisRenderer _customAxisRenderer = _CustomAxisRenderer();
  /// return _customAxisRenderer;
  ///}
  ///
  /// class _CustomAxisRenderer extends RadialAxisRenderer{
  /// _CustomAxisRenderer class implementation
  /// }
  ///
  /// ```
  // ignore: strict_raw_type
  final GaugeAxisRendererFactory? onCreateAxisRenderer;

  @override
  State<StatefulWidget> createState() => _RadialAxisState();
}

class _RadialAxisState extends State<RadialAxis> with TickerProviderStateMixin {
  bool _hasAxisLine = false,
      _hasAxisElements = false,
      _hasRanges = false,
      _hasPointers = false,
      _hasAnnotations = false;

  /// Specifies the axis line interval for animation
  List<double?> _axisLineInterval = List<double?>.filled(5, null);
  List<double?> _axisElementsInterval = List<double?>.filled(5, null);
  List<double?> _rangesInterval = List<double?>.filled(5, null);
  List<double?> _pointersInterval = List<double?>.filled(5, null);
  List<double?> _annotationInterval = List<double?>.filled(5, null);

  AnimationController? _animationController;

  Animation<double>? _axisAnimation,
      _axisElementAnimation,
      _rangeAnimation,
      _annotationAnimation;

  final List<Widget> _radialAxisWidgets = <Widget>[];
  final List<AnimationController?> _pointerAnimationControllers =
      <AnimationController?>[];
  List<GaugePointer>? _oldPointerList = <GaugePointer>[];

  late bool _enableAnimation;
  bool _isPointerAnimationStarted = false;

  /// Holds the pointer repaint notifier.
  final ValueNotifier<int> _repaintNotifier = ValueNotifier<int>(0);
  Timer? _timer;

  @override
  void initState() {
    _calculateDurationForAnimation();
    _updateOldList();
    _initializeAnimations();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RadialAxis oldWidget) {
    final bool isAnimationEnabled =
        RadialGaugeScope.of(context).enableLoadingAnimation;
    if (isAnimationEnabled != _enableAnimation ||
        !_isEqualLists(widget.pointers, _oldPointerList)) {
      _updateOldList();
      _initializeAnimations();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _updateOldList() {
    _oldPointerList = (widget.pointers != null)
        ? List<GaugePointer>.from(widget.pointers!)
        : null;
  }

  bool _isEqualLists(List<dynamic>? a, List<dynamic>? b) {
    if (a == null) {
      return b == null;
    }

    if (b == null || a.length != b.length) {
      return false;
    }

    for (int index = 0; index < a.length; index++) {
      if (a[index].enableAnimation != b[index].enableAnimation ||
          a[index].animationDuration != b[index].animationDuration ||
          a[index].animationType != b[index].animationType) {
        return false;
      }
    }

    return true;
  }

  /// Initialize the animations.
  void _initializeAnimations() {
    _enableAnimation = RadialGaugeScope.of(context).enableLoadingAnimation;
    final int animationDuration =
        RadialGaugeScope.of(context).animationDuration;
    _isPointerAnimationStarted = false;
    _disposeAnimationControllers();
    if (_enableAnimation) {
      _animationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: animationDuration));
      _animationController!.addListener(_axisAnimationListener);
      if (_hasAxisLine) {
        _axisAnimation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
                parent: _animationController!,
                curve: Interval(_axisLineInterval[0]!, _axisLineInterval[1]!,
                    curve: Curves.easeIn)));
      }

      // Includes animation duration for axis ticks and labels
      if (_hasAxisElements) {
        _axisElementAnimation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
                parent: _animationController!,
                curve: Interval(
                    _axisElementsInterval[0]!, _axisElementsInterval[1]!,
                    curve: Curves.easeIn)));
      }

      if (_hasRanges) {
        _rangeAnimation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
                parent: _animationController!,
                curve: Interval(_rangesInterval[0]!, _rangesInterval[1]!,
                    curve: Curves.easeIn)));
      }

      if (_hasAnnotations) {
        _annotationAnimation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
                parent: _animationController!,
                curve: Interval(
                    _annotationInterval[0]!, _annotationInterval[1]!,
                    curve: Curves.easeIn)));
      }
    }

    if (_hasPointers) {
      _pointerAnimationControllers.clear();

      for (int i = 0; i < widget.pointers!.length; i++) {
        AnimationController? pointerAnimationController;
        if (widget.pointers![i].enableAnimation) {
          pointerAnimationController = AnimationController(
              vsync: this,
              duration: Duration(
                  milliseconds: widget.pointers![i].animationDuration.toInt()));
          _pointerAnimationControllers.add(pointerAnimationController);
        }
      }
    }

    _animateElements();
  }

  void _axisAnimationListener() {
    if (_pointersInterval[0] == null ||
        (_pointersInterval[0] != null &&
            _pointersInterval[0]! <= _animationController!.value &&
            !_isPointerAnimationStarted)) {
      _isPointerAnimationStarted = true;
      _animatePointers();
    }
  }

  /// Animates the gauge elements.
  void _animateElements() {
    if (_enableAnimation) {
      _animationController!.forward();
    } else {
      if (mounted) {
        _timer = Timer(const Duration(milliseconds: 50), () {
          _animatePointers();
        });
      }
    }
  }

  void _animatePointers() {
    if (_pointerAnimationControllers.isNotEmpty) {
      for (int i = 0; i < _pointerAnimationControllers.length; i++) {
        _pointerAnimationControllers[i]!.forward();
      }
    }
  }

  List<Widget> _buildRadialAxis() {
    _radialAxisWidgets.clear();

    /// Adding the axis widget.
    _radialAxisWidgets.add(RadialAxisScope(
        animation1: _axisElementAnimation,
        isRadialGaugeAnimationEnabled: _enableAnimation,
        repaintNotifier: _repaintNotifier,
        animation: _axisAnimation,
        child: RadialAxisRenderObjectWidget(axis: widget)));

    if (widget.ranges != null) {
      for (int i = 0; i < widget.ranges!.length; i++) {
        _radialAxisWidgets.add(RadialAxisScope(
            isRadialGaugeAnimationEnabled: _enableAnimation,
            repaintNotifier: _repaintNotifier,
            animation: _rangeAnimation,
            child: widget.ranges![i]));
      }
    }

    if (widget.pointers != null) {
      int pointerIndex = 0;

      for (int i = 0; i < widget.pointers!.length; i++) {
        AnimationController? pointerAnimationController;
        if (widget.pointers![i].enableAnimation) {
          pointerAnimationController =
              _pointerAnimationControllers[pointerIndex];
          pointerIndex++;
        } else if (_enableAnimation) {
          pointerAnimationController = _animationController;
        }

        _radialAxisWidgets.add(RadialAxisScope(
            animationController: pointerAnimationController,
            isRadialGaugeAnimationEnabled: _enableAnimation,
            repaintNotifier: _repaintNotifier,
            pointerInterval: _pointersInterval,
            child: widget.pointers![i] as Widget));
      }
    }

    if (widget.annotations != null) {
      for (int i = 0; i < widget.annotations!.length; i++) {
        _radialAxisWidgets.add(RadialAxisScope(
            isRadialGaugeAnimationEnabled: _enableAnimation,
            repaintNotifier: _repaintNotifier,
            animation: _annotationAnimation,
            child: widget.annotations![i]));
      }
    }

    return _radialAxisWidgets;
  }

  /// Calculates the  gauge elements
  void _calculateAxisElements() {
    final RadialAxis axis = widget;

    if (axis.showAxisLine && !_hasAxisLine) {
      _hasAxisLine = true;
    }

    if ((axis.showTicks || axis.showLabels) && !_hasAxisElements) {
      _hasAxisElements = true;
    }

    if (axis.ranges != null && axis.ranges!.isNotEmpty && !_hasRanges) {
      _hasRanges = true;
    }

    if (axis.pointers != null && axis.pointers!.isNotEmpty && !_hasPointers) {
      _hasPointers = true;
    }

    if (axis.annotations != null &&
        axis.annotations!.isNotEmpty &&
        !_hasAnnotations) {
      _hasAnnotations = true;
    }
  }

  ///calculates the duration for animation
  void _calculateDurationForAnimation() {
    num totalCount = 5;
    double interval;
    double startValue = 0.05;
    double endValue = 0;
    _calculateAxisElements();

    totalCount = _getElementsCount(totalCount);

    interval = 1 / totalCount;
    endValue = interval;

    if (_hasAxisLine) {
      _axisLineInterval = List<double?>.filled(2, null);
      _axisLineInterval[0] = startValue;
      _axisLineInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (_hasAxisElements) {
      _axisElementsInterval = List<double?>.filled(2, null);
      _axisElementsInterval[0] = startValue;
      _axisElementsInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (_hasRanges) {
      _rangesInterval = List<double?>.filled(2, null);
      _rangesInterval[0] = startValue;
      _rangesInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (_hasPointers) {
      _pointersInterval = List<double?>.filled(2, null);
      _pointersInterval[0] = startValue;
      _pointersInterval[1] = endValue;
      startValue = endValue;
      endValue += interval;
    }

    if (_hasAnnotations) {
      _annotationInterval = List<double?>.filled(2, null);
      _annotationInterval[0] = startValue;
      _annotationInterval[1] = endValue;
    }
  }

  /// Returns the total elements count
  num _getElementsCount(num totalCount) {
    if (!_hasAnnotations) {
      totalCount -= 1;
    }

    if (!_hasPointers) {
      totalCount -= 1;
    }

    if (!_hasRanges) {
      totalCount -= 1;
    }

    if (!_hasAxisElements) {
      totalCount -= 1;
    }

    if (!_hasAxisLine) {
      totalCount -= 1;
    }

    return totalCount;
  }

  @override
  Widget build(BuildContext context) {
    return RadialAxisInheritedWidget(
      minimum: widget.minimum,
      maximum: widget.maximum,
      child: RadialAxisParentWidget(children: _buildRadialAxis()),
    );
  }

  void _disposeAnimationControllers() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    if (_animationController != null) {
      _animationController!.removeListener(_axisAnimationListener);
      _animationController!.dispose();
      _animationController = null;
    }

    if (_pointerAnimationControllers.isNotEmpty) {
      for (int i = 0; i < _pointerAnimationControllers.length; i++) {
        if (_pointerAnimationControllers[i] != null) {
          _pointerAnimationControllers[i]!.dispose();
          _pointerAnimationControllers[i] = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _disposeAnimationControllers();
    super.dispose();
  }
}
