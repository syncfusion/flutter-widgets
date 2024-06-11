import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/axis/radial_axis_scope.dart';
import '../../radial_gauge/pointers/gauge_pointer.dart';
import '../../radial_gauge/pointers/marker_pointer_renderer.dart';
import '../../radial_gauge/renderers/marker_pointer_renderer.dart';
import '../../radial_gauge/styles/radial_text_style.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';
import '../../radial_gauge/utils/radial_gauge_typedef.dart';

/// Create the pointer to indicate the value with built-in shape.
///
/// To highlight values, set the marker pointer type to a built-in shape,
/// such as a circle, text, image, triangle, inverted triangle, square,
/// or diamond.
///
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
class MarkerPointer extends LeafRenderObjectWidget implements GaugePointer {
  /// Create a marker pointer with the default or required properties.
  ///
  /// The arguments [value], [markerOffset], must not be null and
  /// [animationDuration], [markerWidth], [markerHeight], [borderWidth]
  /// must be non-negative.
  ///
  const MarkerPointer({
    Key? key,
    this.value = 0,
    this.enableDragging = false,
    this.onValueChanged,
    this.onValueChangeStart,
    this.onValueChangeEnd,
    this.onValueChanging,
    this.animationType = AnimationType.ease,
    this.enableAnimation = false,
    this.animationDuration = 1000,
    this.markerType = MarkerType.invertedTriangle,
    this.color,
    this.markerWidth = 10,
    this.markerHeight = 10,
    this.borderWidth = 0,
    this.markerOffset = 0,
    this.text,
    this.borderColor,
    this.offsetUnit = GaugeSizeUnit.logicalPixel,
    this.imageUrl,
    this.onCreatePointerRenderer,
    GaugeTextStyle? textStyle,
    this.overlayColor,
    this.overlayRadius,
    this.elevation = 0,
  })  : textStyle = textStyle ?? const GaugeTextStyle(),
        assert(animationDuration > 0,
            'Animation duration must be a non-negative value.'),
        assert(markerWidth >= 0, 'Marker width must be a non-negative value.'),
        assert(markerHeight >= 0, 'Marker height must be non-negative value.'),
        assert(borderWidth >= 0, 'Border width must be non-negative value.'),
        assert(
            elevation >= 0, 'Shadow elevation must be a non-negative value.'),
        super(key: key);

  /// Specifies the built-in shape type for  pointer.
  ///
  /// When use [MarkerType.text], [text] value must be set along with
  /// [textStyle] to apply style for text.
  ///
  /// When use [MarkerType.image], [imageUrl] must be set.
  ///
  /// To customize the marker size use [markerHeight] and
  /// [markerWidth] properties.
  ///
  /// Defaults to [MarkerType.invertedTriangle].
  ///
  /// Also refer [MarkerType.invertedTriangle].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             markerType: MarkerType.circle)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final MarkerType markerType;

  /// Specifies the color for marker pointer.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             color: Colors.red)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Color? color;

  /// Specifies the marker height in logical pixels.
  ///
  /// Defaults to 10
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             markerHeight: 20
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double markerHeight;

  /// Specifies the marker width in logical pixels.
  ///
  /// Defaults to 10
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             markerWidth: 20
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double markerWidth;

  /// Specifies the image Url path for marker pointer.
  ///
  /// [imageUrl] is required when setting [MarkerType.image].
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             imageUrl:'images/pin.png',
  ///             markerType: MarkerShape.image
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final String? imageUrl;

  /// Specifies the text for marker pointer.
  ///
  /// [text] is required when setting [MarkerType.text].
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             text: 'marker',
  ///             markerType: MarkerShape.text
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final String? text;

  /// The style to use for the marker pointer text.
  ///
  /// Using [GaugeTextStyle] to add the style to the pointer text.
  ///
  /// Defaults to the [GaugeTextStyle] property with font size is 12.0 and
  /// font family is Segoe UI.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             text: 'marker', textStyle:
  ///             GaugeTextStyle(fontSize: 20, fontStyle: FontStyle.italic),
  ///             markerType: MarkerType.text
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeTextStyle textStyle;

  /// Adjusts the marker pointer position.
  ///
  /// You can specify position value either in logical pixel or radius factor
  /// using the [offsetUnit] property.
  /// if [offsetUnit] is [GaugeSizeUnit.factor], value will be given from 0 to
  /// 1. Here pointer placing position is calculated by
  /// [markerOffset] * axis radius value.
  ///
  /// Example: [markerOffset] value is 0.2 and axis radius is 100, pointer
  /// is moving 20(0.2 * 100) logical pixels from axis outer radius.
  /// if [offsetUnit] is [GaugeSizeUnit.logicalPixel], defined value distance
  /// pointer will move from the outer radius axis.
  ///
  /// When you specify [markerOffset] is negative, the pointer will be
  /// positioned outside the axis.
  ///
  /// Defaults to 0 and [offsetUnit] is [GaugeSizeUnit.logicalPixel]
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             markerOffset: 10
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double markerOffset;

  /// Calculates the marker position either in logical pixel or radius factor.
  ///
  /// Using [GaugeSizeUnit], marker pointer position is calculated.
  ///
  /// Defaults to [GaugeSizeUnit.logicalPixel].
  ///
  /// Also refer [GaugeSizeUnit].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             markerUnit: GaugeSizeUnit.factor, markerOffset = 0.2
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit offsetUnit;

  /// Specifies the border color for marker.
  ///
  /// [borderColor] is applicable for [MarkerType.circle],
  /// [MarkerType.diamond], [MarkerType.invertedTriangle],
  /// [MarkerType.triangle] and [MarkerType.rectangle].
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             borderColor: Colors.red, borderWidth : 2)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Color? borderColor;

  /// Specifies the border width for marker.
  ///
  /// [borderWidth] is applicable for [MarkerType.circle],
  /// [MarkerType.diamond], [MarkerType.invertedTriangle],
  /// [MarkerType.triangle] and [MarkerType.rectangle].
  ///
  /// Defaults to 0
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             borderColor: Colors.red, borderWidth : 2)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double borderWidth;

  /// The callback that is called when the custom renderer for
  /// the marker pointer is created. and it is not applicable for
  /// built-in marker pointer
  ///
  /// The marker pointer is passed as the argument to the callback in
  /// order to access the pointer property
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///                onCreatePointerRenderer: handleCreatePointerRenderer,
  ///             )],
  ///            )]
  ///        ));
  ///}
  ///
  /// Called before creating the renderer
  /// MarkerPointerRenderer handleCreatePointerRenderer(MarkerPointer pointer){
  /// final _CustomPointerRenderer _customPointerRenderer =
  ///                                                 _CustomPointerRenderer();
  /// return _customPointerRenderer;
  ///}
  ///
  /// class _CustomPointerRenderer extends MarkerPointerRenderer{
  /// _CustomPointerRenderer class implementation
  /// }
  ///```
  final MarkerPointerRendererFactory<MarkerPointerRenderer>?
      onCreatePointerRenderer;

  /// Elevation of the pointer.
  ///
  /// The pointer can be elevated by rendering with the shadow behind it.
  /// By default, `Colors.black` is used as shadow color.
  /// This property controls the size of the shadow.
  ///
  /// Defaults to `0`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             enableDragging: true,
  ///             borderColor: Colors.red, elevation : 2)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double elevation;

  /// Color of the overlay drawn around the marker pointer.
  ///
  /// If [enableDragging] is set to true, while touching the marker pointer in mobile and on hovering/clicking
  /// the marker pointer in web, the overlay will be displayed in the marker’s color by default with reduced
  /// opacity. If [enableDragging] is set to false, the overlay will not be displayed.
  ///
  ///If it has to be hidden, `Colors.transparent` can be set to this property.
  ///
  /// Defaults to `null`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///                 enableDragging: true,
  ///                overlayColor: Colors.red[50])],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Color? overlayColor;

  /// Radius of the overlay drawn around the marker pointer.
  ///
  ///If [enableDragging] is set to true, while touching the marker pointer in mobile and on hovering/clicking
  /// the marker pointer in web, the overlay will be displayed. If [enableDragging] is set to false, the
  /// overlay will not be displayed.
  ///
  ///If the value of this property is `null`, the overlay radius is calculated by adding 15 logical pixels to
  /// the marker's width. Else it will be rendered with the specified value as radius.
  ///
  ///If it has to be hidden, `0` can be set to this property.
  ///
  ///Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///                 enableDragging: true,
  ///                overlayColor: Colors.red[50],
  ///                 overlayRadius: 35)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double? overlayRadius;

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
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
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
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
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
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
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
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
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

    MarkerPointerRenderer? markerPointerRenderer;
    if (onCreatePointerRenderer != null) {
      markerPointerRenderer = onCreatePointerRenderer!();
      markerPointerRenderer.pointer = this;
    }

    return RenderMarkerPointer(
        value: value.clamp(ancestor.minimum, ancestor.maximum),
        enableDragging: enableDragging,
        onValueChanged: onValueChanged,
        onValueChangeStart: onValueChangeStart,
        onValueChangeEnd: onValueChangeEnd,
        onValueChanging: onValueChanging,
        markerType: markerType,
        color: color,
        markerWidth: markerWidth,
        markerHeight: markerHeight,
        borderWidth: borderWidth,
        markerOffset: markerOffset,
        text: text,
        borderColor: borderColor,
        offsetUnit: offsetUnit,
        imageUrl: imageUrl,
        markerPointerRenderer: markerPointerRenderer,
        textStyle: textStyle,
        overlayColor: overlayColor,
        overlayRadius: overlayRadius,
        elevation: elevation,
        animationType: animationType,
        pointerInterval: radialAxisScope.pointerInterval,
        enableAnimation: enableAnimation,
        isRadialGaugeAnimationEnabled:
            radialAxisScope.isRadialGaugeAnimationEnabled,
        pointerAnimationController: radialAxisScope.animationController,
        repaintNotifier: radialAxisScope.repaintNotifier,
        gaugeThemeData: gaugeTheme,
        themeData: themeData,
        colorScheme: colorScheme);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderMarkerPointer renderObject) {
    final SfGaugeThemeData gaugeTheme = SfGaugeTheme.of(context)!;
    final ThemeData themeData = Theme.of(context);
    final RadialAxisScope radialAxisScope = RadialAxisScope.of(context);
    final RadialAxisInheritedWidget ancestor = context
        .dependOnInheritedWidgetOfExactType<RadialAxisInheritedWidget>()!;
    MarkerPointerRenderer? markerPointerRenderer;
    if (onCreatePointerRenderer != null) {
      markerPointerRenderer = onCreatePointerRenderer!();
      markerPointerRenderer.pointer = this;
    }

    renderObject
      ..enableDragging = enableDragging
      ..onValueChanged = onValueChanged
      ..onValueChangeStart = onValueChangeStart
      ..onValueChangeEnd = onValueChangeEnd
      ..onValueChanging = onValueChanging
      ..markerType = markerType
      ..color = color
      ..markerWidth = markerWidth
      ..markerHeight = markerHeight
      ..borderWidth = borderWidth
      ..markerOffset = markerOffset
      ..text = text
      ..borderColor = borderColor
      ..offsetUnit = offsetUnit
      ..imageUrl = imageUrl
      ..markerPointerRenderer = markerPointerRenderer
      ..textStyle = textStyle
      ..overlayColor = overlayColor
      ..overlayRadius = overlayRadius
      ..elevation = elevation
      ..enableAnimation = enableAnimation
      ..animationType = animationType
      ..pointerAnimationController = radialAxisScope.animationController
      ..repaintNotifier = radialAxisScope.repaintNotifier
      ..isRadialGaugeAnimationEnabled =
          radialAxisScope.isRadialGaugeAnimationEnabled
      ..gaugeThemeData = gaugeTheme
      ..themeData = themeData
      ..value = value.clamp(ancestor.minimum, ancestor.maximum);
    super.updateRenderObject(context, renderObject);
  }
}
