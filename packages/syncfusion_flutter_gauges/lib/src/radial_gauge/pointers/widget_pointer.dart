import 'package:flutter/material.dart';

import '../../radial_gauge/axis/radial_axis_scope.dart';
import '../../radial_gauge/pointers/gauge_pointer.dart';
import '../../radial_gauge/pointers/widget_pointer_renderer.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';

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
class WidgetPointer extends SingleChildRenderObjectWidget
    implements GaugePointer {
  /// Create a widget pointer with the default or required properties.
  ///
  /// The arguments [child], [value], [offset], must not be null and
  /// [animationDuration] must be non-negative.
  ///
  const WidgetPointer(
      {Key? key,
      this.value = 0,
      this.enableDragging = false,
      this.onValueChanged,
      this.onValueChangeStart,
      this.onValueChangeEnd,
      this.onValueChanging,
      this.animationType = AnimationType.ease,
      this.enableAnimation = false,
      this.animationDuration = 1000,
      this.offsetUnit = GaugeSizeUnit.logicalPixel,
      this.offset = 0,
      required this.child})
      : assert(animationDuration > 0,
            'Animation duration must be a non-negative value.'),
        super(key: key, child: child);

  /// A widget, which is to be used as the pointer.
  ///
  /// You can set any custom widget as pointer to point a value in the gauge scale.
  ///
  /// Defaults to `null`.
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
  @override
  final Widget child;

  /// Calculates the pointer position either in logical pixel or radius factor.
  ///
  /// Using [GaugeSizeUnit], widget pointer position is calculated.
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

  /// Adjusts the widget pointer position.
  ///
  /// You can specify position value either in logical pixel or radius factor
  /// using the [offsetUnit] property.
  ///
  /// If offsetUnit is `GaugeSizeUnit.factor`, value can be specified from
  /// 0 to 1. Here pointer placing position is calculated by
  /// (offset * axis radius value). For example: offset value is 0.2
  /// and axis radius is 100, pointer is moving 20(0.2 * 100) logical pixels
  /// from axis outer radius.
  ///
  /// If offsetUnit is `GaugeSizeUnit.logicalPixel`, pointer will move to the
  /// defined value's distance from the outer radius axis.
  ///
  /// If you specify negative value to this property, the pointer will be
  /// positioned outside the axis.
  ///
  /// Defaults to `0` and offsetUnit is `GaugeSizeUnit.logicalPixel`.
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
  ///             pointers: <GaugePointer>[WidgetPointer(value: 50,
  ///             enableAnimation: true, animationDuration: 2000 )],
  ///            )]
  ///        ));
  ///}
  /// ```
  @override
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
  ///             pointers: <GaugePointer>[WidgetPointer(value: 50,
  ///             animationType: AnimationType.ease
  ///             enableAnimation: true, animationDuration: 2000 )],
  ///            )]
  ///        ));
  ///}
  ///```
  @override
  final AnimationType animationType;

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
  ///             pointers: <GaugePointer>[WidgetPointer(value: 50,
  ///             enableAnimation: true)],
  ///            )]
  ///        ));
  ///}
  /// ```
  @override
  final bool enableAnimation;

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
  ///             pointers: <GaugePointer>[WidgetPointer(value: 50,
  ///             enableDragging: true)],
  ///            )]
  ///        ));
  ///}
  /// ```
  @override
  final bool enableDragging;

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
  ///        WidgetPointer(
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
  @override
  final ValueChanged<double>? onValueChangeEnd;

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
  ///        WidgetPointer(
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
  @override
  final ValueChanged<double>? onValueChangeStart;

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
  ///        WidgetPointer(
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
  @override
  final ValueChanged<double>? onValueChanged;

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
  ///         WidgetPointer(
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
  @override
  final ValueChanged<ValueChangingArgs>? onValueChanging;

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
  ///             pointers: <GaugePointer>[WidgetPointer(value: 50,
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  @override
  final double value;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final RadialAxisScope radialAxisScope = RadialAxisScope.of(context);
    final RadialAxisInheritedWidget ancestor = context
        .dependOnInheritedWidgetOfExactType<RadialAxisInheritedWidget>()!;
    return RenderWidgetPointer(
        value: value.clamp(ancestor.minimum, ancestor.maximum),
        enableDragging: enableDragging,
        onValueChanged: onValueChanged,
        onValueChangeStart: onValueChangeStart,
        onValueChangeEnd: onValueChangeEnd,
        onValueChanging: onValueChanging,
        offsetUnit: offsetUnit,
        pointerAnimationController: radialAxisScope.animationController,
        pointerInterval: radialAxisScope.pointerInterval,
        enableAnimation: enableAnimation,
        repaintNotifier: radialAxisScope.repaintNotifier,
        isRadialGaugeAnimationEnabled:
            radialAxisScope.isRadialGaugeAnimationEnabled,
        animationType: animationType,
        offset: offset);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderWidgetPointer renderObject) {
    final RadialAxisScope radialAxisScope = RadialAxisScope.of(context);
    final RadialAxisInheritedWidget ancestor = context
        .dependOnInheritedWidgetOfExactType<RadialAxisInheritedWidget>()!;

    renderObject
      ..enableDragging = enableDragging
      ..onValueChanged = onValueChanged
      ..onValueChangeStart = onValueChangeStart
      ..onValueChangeEnd = onValueChangeEnd
      ..onValueChanging = onValueChanging
      ..offsetUnit = offsetUnit
      ..pointerAnimationController = radialAxisScope.animationController
      ..enableAnimation = enableAnimation
      ..animationType = animationType
      ..repaintNotifier = radialAxisScope.repaintNotifier
      ..isRadialGaugeAnimationEnabled =
          radialAxisScope.isRadialGaugeAnimationEnabled
      ..offset = offset
      ..value = value.clamp(ancestor.minimum, ancestor.maximum);
    super.updateRenderObject(context, renderObject);
  }
}
