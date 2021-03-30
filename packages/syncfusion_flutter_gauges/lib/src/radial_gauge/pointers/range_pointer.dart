import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import '../common/common.dart';
import '../pointers/gauge_pointer.dart';
import '../utils/enum.dart';

/// Create the pointer to indicate the value with rounded range bar arc.
///
/// A [RangePointer] is used to indicate the current value relative to the
/// start value of a axis scale.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///             pointers: <GaugePointer>[RangePointer( value: 20)],
///            )]
///        ));
///}
/// ```
class RangePointer extends GaugePointer {
  /// Create a range pointer with the default or required properties.
  ///
  /// The arguments [value], [pointerOffset], must not be null and
  /// [animationDuration], [width], must be non-negative.
  RangePointer(
      {double value = 0,
      bool enableDragging = false,
      ValueChanged<double>? onValueChanged,
      ValueChanged<double>? onValueChangeStart,
      ValueChanged<double>? onValueChangeEnd,
      ValueChanged<ValueChangingArgs>? onValueChanging,
      AnimationType animationType = AnimationType.ease,
      this.cornerStyle = CornerStyle.bothFlat,
      this.gradient,
      bool enableAnimation = false,
      double animationDuration = 1000,
      this.pointerOffset = 0,
      this.sizeUnit = GaugeSizeUnit.logicalPixel,
      this.width = 10,
      this.dashArray,
      this.color})
      : assert(
            animationDuration > 0, 'Animation duration must be non-negative'),
        assert(width >= 0, 'Width must be a non-negative value.'),
        assert(
            (gradient != null && gradient is SweepGradient) || gradient == null,
            'The gradient must be null or else the gradient must be equal to '
            'sweep gradient.'),
        super(
            value: value,
            enableDragging: enableDragging,
            animationType: animationType,
            onValueChanged: onValueChanged,
            onValueChangeStart: onValueChangeStart,
            onValueChangeEnd: onValueChangeEnd,
            onValueChanging: onValueChanging,
            enableAnimation: enableAnimation,
            animationDuration: animationDuration);

  /// Adjusts the range pointer position.
  ///
  /// You can specify position value either in logical pixel or radius factor
  /// using the [sizeUnit] property.
  /// if [sizeUnit] is [GaugeSizeUnit.factor], value will be given from 0 to 1.
  /// Here pointer placing position is calculated by
  /// [pointerOffset] * axis radius value.
  ///
  /// Example: [pointerOffset] value is 0.2 and axis radius is 100, pointer is
  /// moving 20(0.2 * 100) logical pixels from axis outer radius.
  /// if [sizeUnit] is [GaugeSizeUnit.logicalPixel], defined value distance
  /// pointer will move from the outer radius axis.
  ///
  /// When you specify [pointerOffset] is negative, the range pointer will be
  /// positioned outside the axis.
  ///
  /// Defaults to `0` and [sizeUnit] is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[RangePointer(pointerOffset: 30,
  ///             value: 20)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double pointerOffset;

  /// Calculates the position and size for pointer either in logical pixel or
  /// radius factor.
  ///
  /// Using [GaugeSizeUnit], range pointer position is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.logicalPixel`.
  ///
  /// Also refer [GaugeSizeUnit].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[RangePointer(pointerOffset: 0.3,
  ///             value: 20,
  ///             sizeUnit: GaugeSizeUnit.factor, width: 0.5
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit sizeUnit;

  /// Specifies the range pointer width.
  ///
  /// You can specify pointer width either in logical pixel or radius factor
  /// using the [sizeUnit] property.
  /// if [sizeUnit] is [GaugeSizeUnit.factor], value must be given from 0 to 1.
  /// Here pointer width is calculated by [width] * axis radius value.
  ///
  /// Example: [width] value is 0.2 and axis radius is 100, pointer width
  /// is 20(0.2 * 100) logical pixels.
  /// if [sizeUnit] is [GaugeSizeUnit.logicalPixel], defined value is set
  /// to the pointer width.
  ///
  /// Defaults to `10` and [sizeUnit] is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ```Dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[RangePointer(width: 20 , value: 20)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double width;

  /// Specifies the range pointer color.
  ///
  /// Defaults to  `null`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[RangePointer(
  ///             color: Colors.red , value: 20)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Color? color;

  /// The style to use for the range pointer corner edge.
  ///
  /// [CornerStyle.bothFlat] does not render the rounded corner on both side.
  /// [CornerStyle.bothCurve] renders the rounded corner on both side.
  /// [CornerStyle.startCurve] renders the rounded corner on start side.
  /// [CornerStyle.endCurve] renders the rounded corner on end side.
  ///
  /// Defaults to `CornerStyle.bothFlat`.
  ///
  /// Also refer [CornerStyle]
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[RangePointer(value: 20,
  ///             cornerStyle: CornerStyle.bothCurve)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final CornerStyle cornerStyle;

  /// A gradient to use when filling the range pointer.
  ///
  /// [gradient] of [RangePointer] only support [SweepGradient] and
  /// specified [SweepGradient.stops] are applied within the pointer value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[RangePointer(value: 20,
  ///              gradient:SweepGradient(
  ///             colors: const <Color>[Colors.red, Color(0xFFFFDD00),
  ///             Color(0xFFFFDD00), Color(0xFF30B32D),],
  ///             stops: const <double>[0, 0.2722222, 0.5833333, 0.777777,],
  ///           ))],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Gradient? gradient;

  /// Specifies the dash array to draw the dashed line.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///             pointers: <GaugePointer>[RangePointer(value: 20,
  ///             dashArray: <double>[2.5, 2.5])],
  ///            )])]
  ///        ));
  ///}
  /// ```
  final List<double>? dashArray;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is RangePointer &&
        other.value == value &&
        other.enableDragging == enableDragging &&
        other.onValueChanged == onValueChanged &&
        other.onValueChangeStart == onValueChangeStart &&
        other.onValueChanging == onValueChanging &&
        other.onValueChangeEnd == onValueChangeEnd &&
        other.enableAnimation == enableAnimation &&
        other.animationDuration == animationDuration &&
        other.cornerStyle == cornerStyle &&
        other.gradient == gradient &&
        other.pointerOffset == pointerOffset &&
        other.sizeUnit == sizeUnit &&
        other.width == width &&
        other.color == color &&
        listEquals(other.dashArray, dashArray);
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
      cornerStyle,
      gradient,
      pointerOffset,
      sizeUnit,
      width,
      color,
      dashArray
    ];
    return hashList(values);
  }
}
