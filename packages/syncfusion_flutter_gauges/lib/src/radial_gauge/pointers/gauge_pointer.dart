import 'package:flutter/material.dart';

import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';

/// [GaugePointer] has properties for customizing gauge pointers.
abstract class GaugePointer {
  /// Create a pointer with the default or required properties.
  GaugePointer({
    this.value = 0,
    this.enableDragging = false,
    this.onValueChanged,
    this.onValueChangeStart,
    this.onValueChanging,
    this.onValueChangeEnd,
    this.enableAnimation = false,
    this.animationType = AnimationType.ease,
    this.animationDuration = 1000,
  });

  /// Specifies the value to the pointer.
  ///
  /// Changing the pointer value will cause the pointer to animate to the
  /// new value.
  ///
  /// Defaults to `0`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double value;

  /// Whether to allow the pointer dragging.
  ///
  /// It provides an option to drag a pointer from one value to another.
  /// It is used to change the value at run time.
  ///
  /// Defaults to `false`.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             enableDragging: true)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool enableDragging;

  /// Called during a drag when the user is selecting a new value for the
  /// pointer by dragging.
  ///
  /// The pointer passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the pointer
  /// with the new value.
  ///
  /// The callback provided to onValueChanged should update the state
  /// of the parent [StatefulWidget] using the [State.setState] method,
  /// so that the parent gets rebuilt; for example:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Container(
  ///      child: SfRadialGauge(axes: <RadialAxis>[
  ///    RadialAxis(
  ///      pointers: <GaugePointer>[
  ///        MarkerPointer(
  ///            value: _currentValue,
  ///            onValueChanged: (double newValue) {
  ///              setState(() {
  ///                _currentValue = newValue;
  ///              });
  ///            })
  ///      ],
  ///    )
  ///  ]));
  /// }
  /// ```
  final ValueChanged<double>? onValueChanged;

  /// Called when the user starts selecting a new value of pointer by dragging.
  ///
  /// This callback shouldn't be used to update the pointer value
  /// (use onValueChanged for that), but rather to be notified  when the user
  /// has started selecting a new value by starting a drag.

  /// The value passed will be the last value that the pointer had before
  /// the change began.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Container(
  ///      child: SfRadialGauge(axes: <RadialAxis>[
  ///    RadialAxis(
  ///      pointers: <GaugePointer>[
  ///        MarkerPointer(
  ///            value: 50,
  ///            onValueChangeStart: (double startValue) {
  ///              setState(() {
  ///                print('Started change at $startValue');
  ///              });
  ///            })
  ///      ],
  ///    )
  ///  ]));
  /// }
  /// ```
  final ValueChanged<double>? onValueChangeStart;

  /// Called when the user is done selecting a new value of the pointer
  /// by dragging.
  ///
  /// This callback shouldn't be used to update the pointer
  /// value (use onValueChanged for that),
  /// but rather to know when the user has completed selecting a new value
  /// by ending a drag.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Container(
  ///      child: SfRadialGauge(axes: <RadialAxis>[
  ///    RadialAxis(
  ///      pointers: <GaugePointer>[
  ///        MarkerPointer(
  ///            value: 50,
  ///            onValueChangeStart: (double newValue) {
  ///              setState(() {
  ///                print('Ended change on $newValue');
  ///              });
  ///            })
  ///      ],
  ///    )
  ///  ]));
  /// }
  /// ```
  final ValueChanged<double>? onValueChangeEnd;

  /// Called during a drag when the user is selecting before a new value
  /// for the pointer by dragging.
  ///
  /// This callback shouldn't be used to update the pointer value
  /// (use onValueChanged for that), but rather to know the new value before
  /// when the user has completed selecting a new value by drag.
  ///
  /// To restrict the update of current drag pointer value,
  /// set [ValueChangingArgs.cancel] is true.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///       child: SfRadialGauge(axes: <RadialAxis>[
  ///     RadialAxis(
  ///       pointers: <GaugePointer>[
  ///         MarkerPointer(
  ///             value: 50,
  ///             onValueChanging: (ValueChangingArgs args) {
  ///               setState(() {
  ///                 if (args.value > 10) {
  ///                   args.cancel = false;
  ///                 }
  ///               });
  ///             })
  ///       ],
  ///     )
  ///   ]));
  /// }
  /// ```
  final ValueChanged<ValueChangingArgs>? onValueChanging;

  /// Whether to enable the pointer animation.
  ///
  /// Set [enableAnimation] is true, the pointer value will cause the pointer
  /// to animate to the new value.
  /// The animation duration is specified by [animationDuration].
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             enableAnimation: true)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool enableAnimation;

  /// Specifies the duration of the pointer animation.
  ///
  /// Duration is defined in milliseconds.
  ///
  /// Defaults to `1000`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             enableAnimation: true, animationDuration: 2000 )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double animationDuration;

  /// Specifies the different type of animation for pointer.
  ///
  /// Different type of animation provides visually appealing way
  /// when the pointer moves from one value to another.
  ///
  /// Defaults to `AnimationType.linear`.
  ///
  /// Also refer [AnimationType]
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             animationType: AnimationType.ease
  ///             enableAnimation: true, animationDuration: 2000 )],
  ///            )]
  ///        ));
  ///}
  ///```
  final AnimationType animationType;
}
