import 'package:flutter/rendering.dart';
import '../common/common.dart';
import '../pointers/gauge_pointer.dart';
import '../renderers/marker_pointer_renderer.dart';
import '../utils/enum.dart';

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
class MarkerPointer extends GaugePointer {
  /// Create a marker pointer with the default or required properties.
  ///
  /// The arguments [value], [markerOffset], must not be null and
  /// [animationDuration], [markerWidth], [markerHeight], [borderWidth]
  /// must be non-negative.
  ///
  MarkerPointer({
    double value = 0,
    bool enableDragging = false,
    ValueChanged<double>? onValueChanged,
    ValueChanged<double>? onValueChangeStart,
    ValueChanged<double>? onValueChangeEnd,
    ValueChanged<ValueChangingArgs>? onValueChanging,
    AnimationType animationType = AnimationType.ease,
    bool enableAnimation = false,
    double animationDuration = 1000,
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
  })  : textStyle = textStyle ??
            GaugeTextStyle(
                fontSize: 12.0,
                fontFamily: 'Segoe UI',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal),
        assert(animationDuration > 0,
            'Animation duration must be a non-negative value.'),
        assert(markerWidth >= 0, 'Marker width must be a non-negative value.'),
        assert(markerHeight >= 0, 'Marker height must be non-negative value.'),
        assert(borderWidth >= 0, 'Border width must be non-negative value.'),
        assert(
            elevation >= 0, 'Shadow elevation must be a non-negative value.'),
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MarkerPointer &&
        other.value == value &&
        other.enableDragging == enableDragging &&
        other.onValueChanged == onValueChanged &&
        other.onValueChangeStart == onValueChangeStart &&
        other.onValueChanging == onValueChanging &&
        other.onValueChangeEnd == onValueChangeEnd &&
        other.enableAnimation == enableAnimation &&
        other.animationDuration == animationDuration &&
        other.markerType == markerType &&
        other.color == color &&
        other.markerWidth == markerWidth &&
        other.markerHeight == markerHeight &&
        other.borderWidth == borderWidth &&
        other.markerOffset == markerOffset &&
        other.text == text &&
        other.borderColor == borderColor &&
        other.imageUrl == imageUrl &&
        other.offsetUnit == offsetUnit &&
        other.onCreatePointerRenderer == onCreatePointerRenderer &&
        other.textStyle == textStyle &&
        other.overlayColor == overlayColor &&
        other.overlayRadius == overlayRadius &&
        other.elevation == elevation;
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
      markerType,
      color,
      markerWidth,
      markerHeight,
      borderWidth,
      markerOffset,
      text,
      borderColor,
      imageUrl,
      offsetUnit,
      textStyle,
      onCreatePointerRenderer,
      overlayColor,
      overlayRadius,
      elevation
    ];
    return hashList(values);
  }
}
