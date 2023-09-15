import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/axis/radial_axis_scope.dart';
import '../../radial_gauge/range/gauge_range_renderer.dart';
import '../../radial_gauge/styles/radial_text_style.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';

/// Create the range to add a color bar in the gauge.
///
/// [GaugeRange] is a visual element that helps to quickly visualize
/// where a value falls on the axis.
/// The text can be easily annotated in range to improve the readability.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
///          endValue: 100)],
///            )]
///        ));
///}
/// ```
class GaugeRange extends LeafRenderObjectWidget {
  /// Create a range with the default or required properties.
  ///
  /// The arguments [startValue], [endValue], must not be null.
  GaugeRange(
      {Key? key,
      required this.startValue,
      required this.endValue,
      double? startWidth,
      double? endWidth,
      this.sizeUnit = GaugeSizeUnit.logicalPixel,
      this.color,
      this.gradient,
      this.rangeOffset = 0,
      this.label,
      GaugeTextStyle? labelStyle})
      : startWidth =
            startWidth = startWidth ?? (label != null ? startWidth : 10),
        endWidth = endWidth = endWidth ?? (label != null ? endWidth : 10),
        labelStyle = labelStyle ?? const GaugeTextStyle(),
        assert(
            (gradient != null && gradient is SweepGradient) || gradient == null,
            'The gradient must be null or else the gradient must be equal'
            ' to sweep gradient.'),
        super(key: key);

  /// Specifies the range start value.
  ///
  /// The range is drawn from [startValue] to [endValue].
  ///
  /// The [startValue] must be greater than the minimum value of the axis.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double startValue;

  /// Specifies the range end value.
  ///
  /// The range is drawn from [startValue] to [endValue].
  ///
  /// The [endValue] must be less than the maximum value of the axis.
  ///
  /// Defaults to `null`.
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
  final double endValue;

  /// Specifies the range start width.
  ///
  /// You can specify range start width either in logical pixel or radius
  /// factor using the [sizeUnit] property.
  /// if [sizeUnit] is [GaugeSizeUnit.factor], value must be given from 0 to 1.
  /// Here range start width is calculated by [startWidth] * axis radius value.
  ///
  /// Example: [startWidth] value is 0.2 and axis radius is 100, range start
  /// width is 20(0.2 * 100) logical pixels.
  /// if [sizeUnit] is [GaugeSizeUnit.logicalPixel], the defined value is set
  /// for the start width of the range.
  ///
  /// Defaults to `10` and [sizeUnit] is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, startWidth: 20)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double? startWidth;

  /// Specifies the range end width.
  ///
  /// You can specify range end width either in logical pixel or radius factor
  /// using the [sizeUnit] property.
  /// if [sizeUnit] is [GaugeSizeUnit.factor], value must be given from 0 to 1.
  /// Here range end width is calculated by [endWidth] * axis radius value.
  ///
  /// Example: [endWidth] value is 0.2 and axis radius is 100, range end width
  /// is 20(0.2 * 100) logical pixels.
  /// If [sizeUnit] is [GaugeSizeUnit.logicalPixel], the defined value is set
  /// for the end width of the range.
  ///
  /// Defaults to `10` and [sizeUnit] is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, endWidth: 40)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double? endWidth;

  /// Calculates the range position and size either in logical pixel
  /// or radius factor.
  ///
  /// Using [GaugeSizeUnit], range position and size is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.logicalPixel`.
  ///
  /// Also refer [GaugeSizeUnit].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, rangeOffset: 0.1,
  ///          sizeUnit: GaugeSizeUnit.factor)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit sizeUnit;

  /// Adjusts the range position in gauge.
  ///
  /// You can specify position value either in logical pixel or radius factor
  /// using the [sizeUnit] property.
  /// if [sizeUnit] is [GaugeSizeUnit.factor], value will be given from 0 to 1.
  /// Here range placing position is calculated
  /// by [rangeOffset] * axis radius value.
  ///
  /// Example: [rangeOffset] value is 0.2 and axis radius is 100, range is
  /// moving 20(0.2 * 100) logical pixels from axis outer radius.
  /// If [sizeUnit] is [GaugeSizeUnit.logicalPixel], the given value distance
  /// range moves from the outer radius axis.
  ///
  /// When you specify [rangeOffset] is negative, the range will be positioned
  /// outside the axis.
  ///
  /// Defaults to `0` and [sizeUnit] is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, rangeOffset: 10)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double rangeOffset;

  /// Specifies the range color.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, color: Colors.blue)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Color? color;

  /// The style to use for the range label text.
  ///
  /// Using [GaugeTextStyle] to add the style to the axis labels.
  ///
  /// Defaults to the [GaugeTextStyle] property with font size  `12.0` and
  /// font family `Segoe UI`.
  ///
  /// Also refer [GaugeTextStyle].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, label: 'High',
  ///          labelStyle: GaugeTextStyle(fontSize: 20)
  ///          )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeTextStyle labelStyle;

  /// Specifies the text for range.
  ///
  /// [label] style is customized by [labelStyle].
  ///
  /// Defaults to `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, label: 'High')],
  ///            )]
  ///        ));
  ///}
  /// ```
  final String? label;

  /// A gradient to use when filling the range.
  ///
  /// [gradient] of [GaugeRange] only support [SweepGradient] and
  /// specified [SweepGradient.stops] are applied within the range value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 0,
  ///          endValue: 100, startWidth: 10, endWidth: 10,
  ///          gradient:SweepGradient(
  ///            colors: const <Color>[Colors.red, Color(0xFFFFDD00),
  ///             Color(0xFFFFDD00), Color(0xFF30B32D),],
  ///            stops: const <double>[0, 0.2722222, 0.5833333, 0.777777,],
  ///          ))],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Gradient? gradient;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final SfGaugeThemeData gaugeTheme = SfGaugeTheme.of(context)!;
    final RadialAxisScope radialAxisScope = RadialAxisScope.of(context);
    final RadialAxisInheritedWidget ancestor = context
        .dependOnInheritedWidgetOfExactType<RadialAxisInheritedWidget>()!;

    return RenderGaugeRange(
        startValue: startValue.clamp(ancestor.minimum, ancestor.maximum),
        endValue: endValue.clamp(ancestor.minimum, ancestor.maximum),
        startWidth: startWidth,
        endWidth: endWidth,
        sizeUnit: sizeUnit,
        color: color,
        gradient: gradient,
        rangeOffset: rangeOffset,
        label: label,
        rangeAnimation: radialAxisScope.animation,
        labelStyle: labelStyle,
        repaintNotifier: radialAxisScope.repaintNotifier,
        gaugeThemeData: gaugeTheme);
  }

  @override
  void updateRenderObject(BuildContext context, RenderGaugeRange renderObject) {
    final SfGaugeThemeData gaugeTheme = SfGaugeTheme.of(context)!;
    final RadialAxisScope radialAxisScope = RadialAxisScope.of(context);
    final RadialAxisInheritedWidget ancestor = context
        .dependOnInheritedWidgetOfExactType<RadialAxisInheritedWidget>()!;

    renderObject
      ..startValue = startValue.clamp(ancestor.minimum, ancestor.maximum)
      ..endValue = endValue.clamp(ancestor.minimum, ancestor.maximum)
      ..startWidth = startWidth
      ..endWidth = endWidth
      ..sizeUnit = sizeUnit
      ..color = color
      ..gradient = gradient
      ..rangeOffset = rangeOffset
      ..rangeAnimation = radialAxisScope.animation
      ..label = label
      ..labelStyle = labelStyle
      ..repaintNotifier = radialAxisScope.repaintNotifier
      ..gaugeThemeData = gaugeTheme;
    super.updateRenderObject(context, renderObject);
  }
}
