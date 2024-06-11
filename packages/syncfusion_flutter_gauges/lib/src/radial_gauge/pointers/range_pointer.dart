import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/axis/radial_axis_scope.dart';
import '../../radial_gauge/pointers/gauge_pointer.dart';
import '../../radial_gauge/pointers/range_pointer_renderer.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';

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
class RangePointer extends LeafRenderObjectWidget implements GaugePointer {
  /// Create a range pointer with the default or required properties.
  ///
  /// The arguments [value], [pointerOffset], must not be null and
  /// [animationDuration], [width], must be non-negative.
  const RangePointer(
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
      this.cornerStyle = CornerStyle.bothFlat,
      this.gradient,
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
        super(key: key);

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
  ///             pointers: <GaugePointer>[RangePointer(value: 50,
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
  ///             pointers: <GaugePointer>[RangePointer(value: 50,
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
  ///             pointers: <GaugePointer>[RangePointer(value: 50,
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
  ///             pointers: <GaugePointer>[RangePointer(value: 50,
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
  ///        RangePointer(
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
  ///        RangePointer(
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
  ///        RangePointer(
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
  ///         RangePointer(
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
  ///             pointers: <GaugePointer>[RangePointer(value: 50,
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  @override
  final double value;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final SfGaugeThemeData gaugeTheme = SfGaugeTheme.of(context)!;
    final ThemeData themeData = Theme.of(context);
    final RadialAxisScope radialAxisScope = RadialAxisScope.of(context);
    final RadialAxisInheritedWidget ancestor = context
        .dependOnInheritedWidgetOfExactType<RadialAxisInheritedWidget>()!;

    return RenderRangePointer(
      value: value.clamp(ancestor.minimum, ancestor.maximum),
      enableDragging: enableDragging,
      onValueChanged: onValueChanged,
      onValueChangeStart: onValueChangeStart,
      onValueChangeEnd: onValueChangeEnd,
      onValueChanging: onValueChanging,
      cornerStyle: cornerStyle,
      gradient: gradient,
      pointerOffset: pointerOffset,
      sizeUnit: sizeUnit,
      width: width,
      dashArray: dashArray,
      color: color,
      pointerAnimationController: radialAxisScope.animationController,
      pointerInterval: radialAxisScope.pointerInterval,
      enableAnimation: enableAnimation,
      isRadialGaugeAnimationEnabled:
          radialAxisScope.isRadialGaugeAnimationEnabled,
      repaintNotifier: radialAxisScope.repaintNotifier,
      animationType: animationType,
      themeData: themeData,
      gaugeThemeData: gaugeTheme,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderRangePointer renderObject) {
    final SfGaugeThemeData gaugeTheme = SfGaugeTheme.of(context)!;
    final ThemeData themeData = Theme.of(context);
    final RadialAxisScope radialAxisScope = RadialAxisScope.of(context);
    final RadialAxisInheritedWidget ancestor = context
        .dependOnInheritedWidgetOfExactType<RadialAxisInheritedWidget>()!;

    renderObject
      ..enableDragging = enableDragging
      ..onValueChanged = onValueChanged
      ..onValueChangeStart = onValueChangeStart
      ..onValueChangeEnd = onValueChangeEnd
      ..onValueChanging = onValueChanging
      ..cornerStyle = cornerStyle
      ..gradient = gradient
      ..pointerOffset = pointerOffset
      ..sizeUnit = sizeUnit
      ..width = width
      ..dashArray = dashArray
      ..color = color
      ..pointerAnimationController = radialAxisScope.animationController
      ..enableAnimation = enableAnimation
      ..animationType = animationType
      ..repaintNotifier = radialAxisScope.repaintNotifier
      ..isRadialGaugeAnimationEnabled =
          radialAxisScope.isRadialGaugeAnimationEnabled
      ..gaugeThemeData = gaugeTheme
      ..themeData = themeData
      ..value = value.clamp(ancestor.minimum, ancestor.maximum);
    super.updateRenderObject(context, renderObject);
  }
}
