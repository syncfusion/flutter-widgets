import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/axis/radial_axis_scope.dart';
import '../../radial_gauge/pointers/gauge_pointer.dart';
import '../../radial_gauge/pointers/needle_pointer_renderer.dart';
import '../../radial_gauge/renderers/needle_pointer_renderer.dart';
import '../../radial_gauge/styles/radial_knob_style.dart';
import '../../radial_gauge/styles/radial_tail_style.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';
import '../../radial_gauge/utils/radial_gauge_typedef.dart';

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
class NeedlePointer extends LeafRenderObjectWidget implements GaugePointer {
  /// Create a needle pointer with the default or required properties.
  ///
  /// The arguments [value], must not be null and [animationDuration],
  /// [needleLength], [needleStartWidth], [needleEndWidth] must be non-negative.
  const NeedlePointer(
      {Key? key,
      this.value = 0,
      this.enableDragging = false,
      this.onValueChanged,
      this.onValueChangeStart,
      this.onValueChangeEnd,
      this.onValueChanging,
      KnobStyle? knobStyle,
      this.tailStyle,
      this.gradient,
      this.needleLength = 0.6,
      this.lengthUnit = GaugeSizeUnit.factor,
      this.needleStartWidth = 1,
      this.needleEndWidth = 10,
      this.onCreatePointerRenderer,
      this.enableAnimation = false,
      this.animationDuration = 1000,
      this.animationType = AnimationType.ease,
      this.needleColor})
      : knobStyle = knobStyle ?? const KnobStyle(),
        assert(animationDuration > 0,
            'Animation duration must be a non-negative value'),
        assert(needleLength >= 0, 'Needle length must be greater than zero.'),
        assert(needleStartWidth >= 0,
            'Needle start width must be greater than zero.'),
        assert(
            needleEndWidth >= 0, 'Needle end width must be greater than zero.'),
        super(key: key);

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
  /// Widget build(BuildContext context) {
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
  ///             pointers: <GaugePointer>[NeedlePointer(value: 50,
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
  ///             pointers: <GaugePointer>[NeedlePointer(value: 50,
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
  ///             pointers: <GaugePointer>[NeedlePointer(value: 50,
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
  ///             pointers: <GaugePointer>[NeedlePointer(value: 50,
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
  ///        NeedlePointer(
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
  ///        NeedlePointer(
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
  ///        NeedlePointer(
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
  ///         NeedlePointer(
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
  ///             pointers: <GaugePointer>[NeedlePointer(value: 50,
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
    final SfColorScheme colorScheme = SfTheme.colorScheme(context);
    final RadialAxisScope radialAxisScope = RadialAxisScope.of(context);
    final RadialAxisInheritedWidget ancestor = context
        .dependOnInheritedWidgetOfExactType<RadialAxisInheritedWidget>()!;

    NeedlePointerRenderer? needlePointerRenderer;
    if (onCreatePointerRenderer != null) {
      needlePointerRenderer = onCreatePointerRenderer!();
      needlePointerRenderer.pointer = this;
    }

    return RenderNeedlePointer(
        value: value.clamp(ancestor.minimum, ancestor.maximum),
        enableDragging: enableDragging,
        onValueChanged: onValueChanged,
        onValueChangeStart: onValueChangeStart,
        onValueChangeEnd: onValueChangeEnd,
        onValueChanging: onValueChanging,
        knobStyle: knobStyle,
        tailStyle: tailStyle,
        gradient: gradient,
        needleLength: needleLength,
        lengthUnit: lengthUnit,
        needleStartWidth: needleStartWidth,
        needleEndWidth: needleEndWidth,
        needlePointerRenderer: needlePointerRenderer,
        needleColor: needleColor,
        pointerAnimationController: radialAxisScope.animationController,
        pointerInterval: radialAxisScope.pointerInterval,
        isRadialGaugeAnimationEnabled:
            radialAxisScope.isRadialGaugeAnimationEnabled,
        enableAnimation: enableAnimation,
        animationType: animationType,
        repaintNotifier: radialAxisScope.repaintNotifier,
        gaugeThemeData: gaugeTheme,
        themeData: themeData,
        colorScheme: colorScheme);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderNeedlePointer renderObject) {
    final SfGaugeThemeData gaugeTheme = SfGaugeTheme.of(context)!;
    final SfColorScheme colorScheme = SfTheme.colorScheme(context);
    final ThemeData themeData = Theme.of(context);
    final RadialAxisScope radialAxisScope = RadialAxisScope.of(context);
    final RadialAxisInheritedWidget ancestor = context
        .dependOnInheritedWidgetOfExactType<RadialAxisInheritedWidget>()!;
    NeedlePointerRenderer? needlePointerRenderer;
    if (onCreatePointerRenderer != null) {
      needlePointerRenderer = onCreatePointerRenderer!();
      needlePointerRenderer.pointer = this;
    }

    renderObject
      ..enableDragging = enableDragging
      ..onValueChanged = onValueChanged
      ..onValueChangeStart = onValueChangeStart
      ..onValueChangeEnd = onValueChangeEnd
      ..onValueChanging = onValueChanging
      ..knobStyle = knobStyle
      ..tailStyle = tailStyle
      ..gradient = gradient
      ..needleLength = needleLength
      ..lengthUnit = lengthUnit
      ..needleStartWidth = needleStartWidth
      ..needleEndWidth = needleEndWidth
      ..needlePointerRenderer = needlePointerRenderer
      ..needleColor = needleColor
      ..enableAnimation = enableAnimation
      ..animationType = animationType
      ..pointerAnimationController = radialAxisScope.animationController
      ..repaintNotifier = radialAxisScope.repaintNotifier
      ..isRadialGaugeAnimationEnabled =
          radialAxisScope.isRadialGaugeAnimationEnabled
      ..gaugeThemeData = gaugeTheme
      ..themeData = themeData
      ..colorScheme = colorScheme
      ..value = value.clamp(ancestor.minimum, ancestor.maximum);
    super.updateRenderObject(context, renderObject);
  }
}
