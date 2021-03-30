import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../common/common.dart';
import '../pointers/gauge_pointer.dart';
import '../utils/enum.dart';

/// Create the pointer to indicate the value with built-in shape.
///
/// To highlight values, set any desired widget to [child] property.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///             pointers: <GaugePointer>[WidgetPointer(value: 50,
///              widget: Container( height: 30, width: 30,
///                   decoration: BoxDecoration(
///                     shape: BoxShape.circle,
///                     border: Border.all(color: Colors.red)),
///                       child: Icon( Icons.check, color: Colors.black ))
///             )],
///            )]
///        ));
///}
/// ```
class WidgetPointer extends GaugePointer {
  /// Create a widget pointer with the default or required properties.
  ///
  /// The arguments [child], [value], [offset], must not be null and
  /// [animationDuration] must be non-negative.
  ///
  WidgetPointer(
      {required this.child,
      this.offsetUnit = GaugeSizeUnit.logicalPixel,
      this.offset = 0,
      double value = 0,
      bool enableDragging = false,
      ValueChanged<double>? onValueChanged,
      ValueChanged<double>? onValueChangeStart,
      ValueChanged<double>? onValueChangeEnd,
      ValueChanged<ValueChangingArgs>? onValueChanging,
      AnimationType animationType = AnimationType.ease,
      bool enableAnimation = false,
      double animationDuration = 1000})
      : assert(animationDuration > 0,
            'Animation duration must be a non-negative value.'),
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

  /// A widget, which is to be used as the pointer.
  ///
  /// You can set any custom widget as pointer to point a value in the gauge scale.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[WidgetPointer(value: 50,
  ///              widget: Container( height: 30, width: 30,
  ///                   decoration: BoxDecoration(
  ///                     shape: BoxShape.circle,
  ///                     border: Border.all(color: Colors.red)),
  ///                       child: Icon( Icons.check, color: Colors.black ))
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Widget child;

  /// Calculates the pointer position either in logical pixel or radius factor.
  ///
  /// Using [GaugeSizeUnit], widget pointer position is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.logicalPixel`.
  ///
  /// Also refer [GaugeSizeUnit].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[WidgetPointer(pointerOffset: 0.3,
  ///             value: 20,
  ///             offsetUnit: GaugeSizeUnit.factor, width: 0.5
  ///              widget: Container( height: 30, width: 30,
  ///                   decoration: BoxDecoration(
  ///                     shape: BoxShape.circle,
  ///                     border: Border.all(color: Colors.red)),
  ///                       child: Icon( Icons.check, color: Colors.black ))
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit offsetUnit;

  /// Adjusts the widget pointer position.
  ///
  /// You can specify position value either in logical pixel or radius factor
  /// using the [offsetUnit] property.
  ///
  /// If offsetUnit is `GaugeSizeUnit.factor`, value can be specified from
  /// 0 to 1. Here pointer placing position is calculated by
  /// (offset * axis radius value). For example: offset value is 0.2
  /// and axis radius is 100, pointer is moving 20(0.2 * 100) logical pixels
  /// from axis outer radius.
  ///
  /// If offsetUnit is `GaugeSizeUnit.logicalPixel`, pointer will move to the
  /// defined value's distance from the outer radius axis.
  ///
  /// If you specify negative value to this property, the pointer will be
  /// positioned outside the axis.
  ///
  /// Defaults to `0` and offsetUnit is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[WidegtPointer(offset: 30,
  ///              widget: Container( height: 30, width: 30,
  ///                   decoration: BoxDecoration(
  ///                     shape: BoxShape.circle,
  ///                     border: Border.all(color: Colors.red)),
  ///                       child: Icon( Icons.check, color: Colors.black ))
  ///             value: 20)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double offset;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is WidgetPointer &&
        other.value == value &&
        other.enableDragging == enableDragging &&
        other.onValueChanged == onValueChanged &&
        other.onValueChangeStart == onValueChangeStart &&
        other.onValueChanging == onValueChanging &&
        other.onValueChangeEnd == onValueChangeEnd &&
        other.enableAnimation == enableAnimation &&
        other.animationDuration == animationDuration &&
        other.animationType == animationType &&
        other.child == child &&
        other.offset == offset &&
        other.offsetUnit == offsetUnit;
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
      animationType,
      child,
      offset,
      offsetUnit
    ];
    return hashList(values);
  }
}
