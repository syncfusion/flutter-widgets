import 'package:flutter/rendering.dart';
import '../common/common.dart';
import '../pointers/gauge_pointer.dart';
import '../renderers/needle_pointer_renderer.dart';
import '../utils/enum.dart';

/// Create the pointer to indicate the value with needle or arrow shape.
///
/// [NeedlePointer] contains three parts, namely needle, knob, and tail
/// and that can be placed on a gauge to mark the values.
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis
///          ( pointers: <GaugePointer>[
///             NeedlePointer( value: 30,
///           )])]
///        ));
///}
/// ```
class NeedlePointer extends GaugePointer {
  /// Create a needle pointer with the default or required properties.
  ///
  /// The arguments [value], must not be null and [animationDuration],
  /// [needleLength], [needleStartWidth], [needleEndWidth] must be non-negative.
  NeedlePointer(
      {double value = 0,
      bool enableDragging = false,
      ValueChanged<double>? onValueChanged,
      ValueChanged<double>? onValueChangeStart,
      ValueChanged<double>? onValueChangeEnd,
      ValueChanged<ValueChangingArgs>? onValueChanging,
      KnobStyle? knobStyle,
      this.tailStyle,
      this.gradient,
      this.needleLength = 0.6,
      this.lengthUnit = GaugeSizeUnit.factor,
      this.needleStartWidth = 1,
      this.needleEndWidth = 10,
      this.onCreatePointerRenderer,
      bool enableAnimation = false,
      double animationDuration = 1000,
      AnimationType animationType = AnimationType.ease,
      this.needleColor})
      : knobStyle = knobStyle ?? KnobStyle(knobRadius: 0.08),
        assert(animationDuration > 0,
            'Animation duration must be a non-negative value'),
        assert(needleLength >= 0, 'Needle length must be greater than zero.'),
        assert(needleStartWidth >= 0,
            'Needle start width must be greater than zero.'),
        assert(
            needleEndWidth >= 0, 'Needle end width must be greater than zero.'),
        super(
            value: value,
            enableDragging: enableDragging,
            onValueChanged: onValueChanged,
            onValueChangeStart: onValueChangeStart,
            onValueChangeEnd: onValueChangeEnd,
            onValueChanging: onValueChanging,
            animationType: animationType,
            enableAnimation: enableAnimation,
            animationDuration: animationDuration);

  /// The style to use for the needle knob.
  ///
  /// A knob is a rounded ball at the end of an needle or arrow which style
  /// customized by [knobStyle].
  ///
  /// Defaults to the [knobStyle] property with knobRadius is 0.08 radius
  /// factor.
  ///
  /// Also refer [KnobStyle].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( value: 30,
  ///              knobStyle: KnobStyle(knobRadius: 0.1),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final KnobStyle knobStyle;

  /// The style to use for the needle tail.
  ///
  /// Defaults to `null`..
  ///
  /// Also refer [TailStyle].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( value: 20, tailStyle:
  ///                 TailStyle(width: 5, lengthFactor: 0.2)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final TailStyle? tailStyle;

  /// Adjusts the needle pointer length from center.
  ///
  /// You can specify length value either in logical pixel or radius factor
  /// using the [lengthUnit] property. if [lengthUnit] is
  /// [GaugeSizeUnit.factor], value will be given from 0 to 1.
  /// Here pointer length is calculated by [needleLength] * axis radius value.
  ///
  /// Example: [needleLength] value is 0.5 and axis radius is 100, pointer
  /// length is 50(0.5 * 100) logical pixels from axis center.
  /// if [lengthUnit] is [GaugeSizeUnit.logicalPixel], defined value length
  /// from axis center.
  ///
  /// Defaults to 0.6 and [lengthUnit] is [GaugeSizeUnit.factor].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( needleLength: 0.8, value: 20,
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double needleLength;

  /// Calculates the needle pointer length either in logical pixel
  /// or radius factor.
  ///
  /// Using [GaugeSizeUnit], needle pointer length is calculated.
  ///
  /// Defaults to [GaugeSizeUnit.factor].
  ///
  /// Also refer [GaugeSizeUnit].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( needleLength: 30,
  ///             lengthUnit: GaugeSizeUnit.logicalPixel
  ///           )])]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit lengthUnit;

  /// Specifies the start width of the needle pointer in logical pixels.
  ///
  /// Using [needleStartWidth] and [needleEndWidth], you can customize the
  /// needle shape as rectangle or triangle.
  ///
  ///  Defaults to 1
  ///  ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( needleStartWidth: 20, value: 30
  ///           )])]
  ///        ));
  ///}
  ///  ```
  final double needleStartWidth;

  /// Specifies the end width of the needle pointer in logical pixels.
  ///
  /// Using [needleStartWidth] and [needleEndWidth], you can customize
  /// the needle shape as rectangle or triangle.
  ///
  /// Defaults to 10
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( needleEndWidth: 30
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double needleEndWidth;

  /// Specifies the color of the needle pointer.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( color: Colors.blue, value: 30
  ///           )])]
  ///        ));
  ///}
  /// ```
  final Color? needleColor;

  /// A gradient to use when filling the needle pointer.
  ///
  /// [gradient] of [NeedlePointer] only support [LinearGradient]. You can use
  /// this to display the depth effect of the needle pointer.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( color: Colors.blue, value: 30
  ///             gradient: LinearGradient(
  ///                colors: const <Color>[Color.fromRGBO(28, 114, 189, 1),
  ///                Color.fromRGBO(28, 114, 189, 1),
  ///                  Color.fromRGBO(23, 173, 234, 1),
  ///                  Color.fromRGBO(23, 173, 234, 1)],
  ///                stops: const <double>[0,0.5,0.5,1],
  ///            )
  ///           )])]
  ///        ));
  ///}
  /// ```
  final LinearGradient? gradient;

  /// The callback that is called when the custom renderer for
  /// the needle pointer is created. and it is not applicable for
  /// built-in needle pointer
  ///
  /// The needle pointer is passed as the argument to the callback in
  /// order to access the pointer property
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[NeedlePointer(value: 50,
  ///                onCreatePointerRenderer: handleCreatePointerRenderer,
  ///             )],
  ///            )]
  ///        ));
  ///}
  ///
  /// Called before creating the renderer
  /// NeedlePointerRenderer handleCreatePointerRenderer(NeedlePointer pointer){
  /// final _CustomPointerRenderer _customPointerRenderer =
  ///                                                 _CustomPointerRenderer();
  /// return _customPointerRenderer;
  ///}
  ///
  /// class _CustomPointerRenderer extends NeedlePointerRenderer{
  /// _CustomPointerRenderer class implementation
  /// }
  ///```
  final NeedlePointerRendererFactory<NeedlePointerRenderer>?
      onCreatePointerRenderer;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is NeedlePointer &&
        other.value == value &&
        other.enableDragging == enableDragging &&
        other.onValueChanged == onValueChanged &&
        other.onValueChangeStart == onValueChangeStart &&
        other.onValueChanging == onValueChanging &&
        other.onValueChangeEnd == onValueChangeEnd &&
        other.enableAnimation == enableAnimation &&
        other.animationDuration == animationDuration &&
        other.knobStyle == knobStyle &&
        other.tailStyle == tailStyle &&
        other.gradient == gradient &&
        other.needleLength == needleLength &&
        other.lengthUnit == lengthUnit &&
        other.needleStartWidth == needleStartWidth &&
        other.needleEndWidth == needleEndWidth &&
        other.onCreatePointerRenderer == onCreatePointerRenderer &&
        other.needleColor == needleColor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      value,
      enableDragging,
      onValueChanged,
      onValueChangeStart,
      onValueChanging,
      onValueChangeEnd,
      enableAnimation,
      animationDuration,
      knobStyle,
      tailStyle,
      gradient,
      needleLength,
      lengthUnit,
      needleStartWidth,
      needleEndWidth,
      needleColor,
      onCreatePointerRenderer
    ];
    return hashList(values);
  }
}
