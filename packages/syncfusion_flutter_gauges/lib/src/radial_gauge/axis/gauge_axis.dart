import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show NumberFormat;
import '../annotation/gauge_annotation.dart';
import '../common/common.dart';
import '../pointers/gauge_pointer.dart';
import '../range/gauge_range.dart';
import '../utils/enum.dart';

/// [GaugeAxis] has properties for customizing axis elements such as labels,
/// ticks and axis lines.
///
/// This is base class for [RadialAxis].
abstract class GaugeAxis {
  /// Create an axis with the default or required scale range and customized
  /// axis properties.
  ///
  /// Add the collection of [ranges], [pointers] and [annotations] to the axis.
  ///
  /// Default value of [minimum] is 0, [maximum] is 100,
  /// [minorTicksPerInterval] is 1, [labelOffset] is 20,
  /// [maximumLabels] is 3, [ticksPosition] is [ElementsPosition.inside] ,
  /// [labelsPosition] is [ElementsPosition.inside],
  /// [offsetUnit] is [GaugeSizeUnit.logicalPixel].
  GaugeAxis(
      {this.ranges,
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
      this.labelOffset = 20,
      this.isInversed = false,
      this.maximumLabels = 3,
      this.useRangeColorForAxis = false,
      this.labelFormat,
      this.numberFormat,
      this.onCreateAxisRenderer,
      this.ticksPosition = ElementsPosition.inside,
      this.labelsPosition = ElementsPosition.inside,
      this.offsetUnit = GaugeSizeUnit.logicalPixel,
      GaugeTextStyle? axisLabelStyle,
      AxisLineStyle? axisLineStyle,
      MajorTickStyle? majorTickStyle,
      MinorTickStyle? minorTickStyle})
      : axisLabelStyle = axisLabelStyle ??
            GaugeTextStyle(
                fontSize: 12.0,
                fontFamily: 'Segoe UI',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal),
        axisLineStyle = axisLineStyle ??
            AxisLineStyle(
              thickness: 10,
            ),
        majorTickStyle = majorTickStyle ?? MajorTickStyle(length: 10),
        minorTickStyle = minorTickStyle ?? MinorTickStyle(length: 5);

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
  final GaugeAxisRendererFactory? onCreateAxisRenderer;
}
