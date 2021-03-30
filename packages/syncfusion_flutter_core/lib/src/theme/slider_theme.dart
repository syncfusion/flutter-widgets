import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant Syncfusion slider widget.
class SfSliderTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const SfSliderTheme({Key? key, required this.data, required this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant slider widgets.
  final SfSliderThemeData data;

  /// Specifies a widget that can hold single child.
  @override
  final Widget child;

  /// The data from the closest [SfSliderTheme] instance
  /// that encloses the given context.
  ///
  /// Defaults to [SfThemeData.sliderThemeData] if there is no
  /// [SfSliderTheme] in the given build context.
  static SfSliderThemeData of(BuildContext context) {
    final SfSliderTheme? sliderTheme =
        context.dependOnInheritedWidgetOfExactType<SfSliderTheme>();
    return sliderTheme?.data ?? SfTheme.of(context).sliderThemeData;
  }

  @override
  bool updateShouldNotify(SfSliderTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfSliderTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfSliderTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfSliderTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfSliderTheme]. Use this class
/// to configure a [SfSliderTheme] widget, or to set the
/// [SfThemeData.sliderThemeData] for a [SfTheme] widget.
///
/// To obtain the current theme, use [SfSliderTheme.of].
///
/// The slider elements are:
///
/// * The "track", which is the rounded rectangle in which
/// the thumb is slides over.
/// * The "thumb", which is a shape that slides horizontally when
/// the user drags it.
/// * The "active" side of the slider is between the [min] value and thumb.
/// * The "inactive" side of the slider is between the thumb and
/// the [max] value.
/// * The "divisors", which is a shape that renders on the track based on
/// the given [interval] value.
/// * The "ticks", which is a shape that rendered based on
/// given [interval] value.
/// Basically, it is rendered below the track. It is also called “major ticks”.
/// * The "minor ticks", which is a shape that renders between two major ticks
/// based on given [minorTicksPerInterval] value.
/// Basically, it is rendered below the track.
/// * The "labels", which is a text that rendered based on
/// given [interval] value.
/// Basically, it is rendered below the track and the major ticks.
///
/// The slider will be disabled if [onChanged] is null or
/// [min] is equal to [max].
///
/// See also:
///
///  * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html) and
/// [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the slider.
class SfSliderThemeData with Diagnosticable {
  /// Returns a new instance of [SfSliderThemeData.raw] for the given values.
  ///
  /// If any of the values are null, the default values will be set.
  factory SfSliderThemeData(
      {Brightness? brightness,
      double? activeTrackHeight,
      double? inactiveTrackHeight,
      Size? tickSize,
      Size? minorTickSize,
      Offset? tickOffset,
      Offset? labelOffset,
      TextStyle? inactiveLabelStyle,
      TextStyle? activeLabelStyle,
      TextStyle? tooltipTextStyle,
      Color? inactiveTrackColor,
      Color? activeTrackColor,
      Color? thumbColor,
      Color? activeTickColor,
      Color? inactiveTickColor,
      Color? disabledActiveTickColor,
      Color? disabledInactiveTickColor,
      Color? activeMinorTickColor,
      Color? inactiveMinorTickColor,
      Color? disabledActiveMinorTickColor,
      Color? disabledInactiveMinorTickColor,
      Color? overlayColor,
      Color? inactiveDivisorColor,
      Color? activeDivisorColor,
      Color? disabledActiveTrackColor,
      Color? disabledInactiveTrackColor,
      Color? disabledActiveDivisorColor,
      Color? disabledInactiveDivisorColor,
      Color? disabledThumbColor,
      Color? tooltipBackgroundColor,
      Color? thumbStrokeColor,
      Color? activeDivisorStrokeColor,
      Color? inactiveDivisorStrokeColor,
      double? trackCornerRadius,
      double? overlayRadius,
      double? thumbRadius,
      double? activeDivisorRadius,
      double? inactiveDivisorRadius,
      double? thumbStrokeWidth,
      double? activeDivisorStrokeWidth,
      double? inactiveDivisorStrokeWidth}) {
    brightness = brightness ?? Brightness.light;
    activeTrackHeight ??= 6.0;
    inactiveTrackHeight ??= 4.0;
    overlayRadius ??= 24.0;
    thumbRadius ??= 10.0;
    activeTickColor ??= const Color.fromRGBO(158, 158, 158, 1);
    inactiveTickColor ??= const Color.fromRGBO(158, 158, 158, 1);
    activeMinorTickColor ??= const Color.fromRGBO(158, 158, 158, 1);
    inactiveMinorTickColor ??= const Color.fromRGBO(158, 158, 158, 1);
    disabledActiveTickColor ??= const Color.fromRGBO(189, 189, 189, 1);
    disabledInactiveTickColor ??= const Color.fromRGBO(189, 189, 189, 1);
    disabledActiveMinorTickColor ??= const Color.fromRGBO(189, 189, 189, 1);
    disabledInactiveMinorTickColor ??= const Color.fromRGBO(189, 189, 189, 1);
    disabledThumbColor ??= const Color.fromRGBO(158, 158, 158, 1);

    return SfSliderThemeData.raw(
        brightness: brightness,
        activeTrackHeight: activeTrackHeight,
        inactiveTrackHeight: inactiveTrackHeight,
        tickSize: tickSize,
        minorTickSize: minorTickSize,
        tickOffset: tickOffset,
        labelOffset: labelOffset,
        inactiveLabelStyle: inactiveLabelStyle,
        activeLabelStyle: activeLabelStyle,
        tooltipTextStyle: tooltipTextStyle,
        inactiveTrackColor: inactiveTrackColor,
        activeTrackColor: activeTrackColor,
        inactiveDivisorColor: inactiveDivisorColor,
        activeDivisorColor: activeDivisorColor,
        thumbColor: thumbColor,
        thumbStrokeColor: thumbStrokeColor,
        activeDivisorStrokeColor: activeDivisorStrokeColor,
        inactiveDivisorStrokeColor: inactiveDivisorStrokeColor,
        overlayColor: overlayColor,
        activeTickColor: activeTickColor,
        inactiveTickColor: inactiveTickColor,
        disabledActiveTickColor: disabledActiveTickColor,
        disabledInactiveTickColor: disabledInactiveTickColor,
        activeMinorTickColor: activeMinorTickColor,
        inactiveMinorTickColor: inactiveMinorTickColor,
        disabledActiveMinorTickColor: disabledActiveMinorTickColor,
        disabledInactiveMinorTickColor: disabledInactiveMinorTickColor,
        disabledActiveTrackColor: disabledActiveTrackColor,
        disabledInactiveTrackColor: disabledInactiveTrackColor,
        disabledActiveDivisorColor: disabledActiveDivisorColor,
        disabledInactiveDivisorColor: disabledInactiveDivisorColor,
        disabledThumbColor: disabledThumbColor,
        tooltipBackgroundColor: tooltipBackgroundColor,
        overlayRadius: overlayRadius,
        thumbRadius: thumbRadius,
        activeDivisorRadius: activeDivisorRadius,
        inactiveDivisorRadius: inactiveDivisorRadius,
        thumbStrokeWidth: thumbStrokeWidth,
        activeDivisorStrokeWidth: activeDivisorStrokeWidth,
        inactiveDivisorStrokeWidth: inactiveDivisorStrokeWidth,
        trackCornerRadius: trackCornerRadius);
  }

  /// Create a [SfSliderThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfSliderThemeData] constructor.
  const SfSliderThemeData.raw({
    required this.brightness,
    required this.activeTrackHeight,
    required this.inactiveTrackHeight,
    required this.tickSize,
    required this.minorTickSize,
    required this.tickOffset,
    required this.labelOffset,
    required this.inactiveLabelStyle,
    required this.activeLabelStyle,
    required this.tooltipTextStyle,
    required this.inactiveTrackColor,
    required this.activeTrackColor,
    required this.thumbColor,
    required this.thumbStrokeColor,
    required this.activeDivisorStrokeColor,
    required this.inactiveDivisorStrokeColor,
    required this.activeTickColor,
    required this.inactiveTickColor,
    required this.disabledActiveTickColor,
    required this.disabledInactiveTickColor,
    required this.activeMinorTickColor,
    required this.inactiveMinorTickColor,
    required this.disabledActiveMinorTickColor,
    required this.disabledInactiveMinorTickColor,
    required this.overlayColor,
    required this.inactiveDivisorColor,
    required this.activeDivisorColor,
    required this.disabledActiveTrackColor,
    required this.disabledInactiveTrackColor,
    required this.disabledActiveDivisorColor,
    required this.disabledInactiveDivisorColor,
    required this.disabledThumbColor,
    required this.tooltipBackgroundColor,
    required this.trackCornerRadius,
    required this.overlayRadius,
    required this.thumbRadius,
    required this.activeDivisorRadius,
    required this.inactiveDivisorRadius,
    required this.thumbStrokeWidth,
    required this.activeDivisorStrokeWidth,
    required this.inactiveDivisorStrokeWidth,
  });

  /// Creates a copy of this theme but with the given fields
  /// replaced with the new values.
  SfSliderThemeData copyWith({
    Brightness? brightness,
    double? activeTrackHeight,
    double? inactiveTrackHeight,
    Size? tickSize,
    Size? minorTickSize,
    Offset? tickOffset,
    Offset? labelOffset,
    TextStyle? inactiveLabelStyle,
    TextStyle? activeLabelStyle,
    TextStyle? tooltipTextStyle,
    Color? inactiveTrackColor,
    Color? activeTrackColor,
    Color? thumbColor,
    Color? thumbStrokeColor,
    Color? activeDivisorStrokeColor,
    Color? inactiveDivisorStrokeColor,
    Color? activeTickColor,
    Color? inactiveTickColor,
    Color? disabledActiveTickColor,
    Color? disabledInactiveTickColor,
    Color? activeMinorTickColor,
    Color? inactiveMinorTickColor,
    Color? disabledActiveMinorTickColor,
    Color? disabledInactiveMinorTickColor,
    Color? overlayColor,
    Color? inactiveDivisorColor,
    Color? activeDivisorColor,
    Color? disabledActiveTrackColor,
    Color? disabledInactiveTrackColor,
    Color? disabledActiveDivisorColor,
    Color? disabledInactiveDivisorColor,
    Color? disabledThumbColor,
    Color? activeRegionColor,
    Color? inactiveRegionColor,
    Color? tooltipBackgroundColor,
    double? trackCornerRadius,
    double? overlayRadius,
    double? thumbRadius,
    double? activeDivisorRadius,
    double? inactiveDivisorRadius,
    double? thumbStrokeWidth,
    double? activeDivisorStrokeWidth,
    double? inactiveDivisorStrokeWidth,
  }) {
    return SfSliderThemeData.raw(
      brightness: brightness ?? this.brightness,
      activeTrackHeight: activeTrackHeight ?? this.activeTrackHeight,
      inactiveTrackHeight: inactiveTrackHeight ?? this.inactiveTrackHeight,
      tickSize: tickSize ?? this.tickSize,
      minorTickSize: minorTickSize ?? this.minorTickSize,
      tickOffset: tickOffset ?? this.tickOffset,
      labelOffset: labelOffset ?? this.labelOffset,
      inactiveLabelStyle: inactiveLabelStyle ?? this.inactiveLabelStyle,
      activeLabelStyle: activeLabelStyle ?? this.activeLabelStyle,
      tooltipTextStyle: tooltipTextStyle ?? this.tooltipTextStyle,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      thumbColor: thumbColor ?? this.thumbColor,
      thumbStrokeColor: thumbStrokeColor ?? this.thumbStrokeColor,
      activeDivisorStrokeColor:
          activeDivisorStrokeColor ?? this.activeDivisorStrokeColor,
      inactiveDivisorStrokeColor:
          inactiveDivisorStrokeColor ?? this.inactiveDivisorStrokeColor,
      activeTickColor: activeTickColor ?? this.activeTickColor,
      inactiveTickColor: inactiveTickColor ?? this.inactiveTickColor,
      disabledActiveTickColor:
          disabledActiveTickColor ?? this.disabledActiveTickColor,
      disabledInactiveTickColor:
          disabledInactiveTickColor ?? this.disabledInactiveTickColor,
      activeMinorTickColor: activeMinorTickColor ?? this.activeMinorTickColor,
      inactiveMinorTickColor:
          inactiveMinorTickColor ?? this.inactiveMinorTickColor,
      disabledActiveMinorTickColor:
          disabledActiveMinorTickColor ?? this.disabledActiveMinorTickColor,
      disabledInactiveMinorTickColor:
          disabledInactiveMinorTickColor ?? this.disabledInactiveMinorTickColor,
      overlayColor: overlayColor ?? this.overlayColor,
      inactiveDivisorColor: inactiveDivisorColor ?? this.inactiveDivisorColor,
      activeDivisorColor: activeDivisorColor ?? this.activeDivisorColor,
      disabledActiveTrackColor:
          disabledActiveTrackColor ?? this.disabledActiveTrackColor,
      disabledInactiveTrackColor:
          disabledInactiveTrackColor ?? this.disabledInactiveTrackColor,
      disabledActiveDivisorColor:
          disabledActiveDivisorColor ?? this.disabledActiveDivisorColor,
      disabledInactiveDivisorColor:
          disabledInactiveDivisorColor ?? this.disabledInactiveDivisorColor,
      disabledThumbColor: disabledThumbColor ?? this.disabledThumbColor,
      tooltipBackgroundColor:
          tooltipBackgroundColor ?? this.tooltipBackgroundColor,
      trackCornerRadius: trackCornerRadius ?? this.trackCornerRadius,
      overlayRadius: overlayRadius ?? this.overlayRadius,
      thumbRadius: thumbRadius ?? this.thumbRadius,
      activeDivisorRadius: activeDivisorRadius ?? this.activeDivisorRadius,
      inactiveDivisorRadius:
          inactiveDivisorRadius ?? this.inactiveDivisorRadius,
      thumbStrokeWidth: thumbStrokeWidth ?? this.thumbStrokeWidth,
      activeDivisorStrokeWidth:
          activeDivisorStrokeWidth ?? this.activeDivisorStrokeWidth,
      inactiveDivisorStrokeWidth:
          inactiveDivisorStrokeWidth ?? this.inactiveDivisorStrokeWidth,
    );
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  static SfSliderThemeData? lerp(
      SfSliderThemeData? a, SfSliderThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfSliderThemeData(
        activeTrackHeight:
            lerpDouble(a!.activeTrackHeight, b!.activeTrackHeight, t),
        inactiveTrackHeight:
            lerpDouble(a.inactiveTrackHeight, b.inactiveTrackHeight, t),
        tickSize: Size.lerp(a.tickSize, b.tickSize, t),
        minorTickSize: Size.lerp(a.minorTickSize, b.minorTickSize, t),
        tickOffset: Offset.lerp(a.tickOffset, b.tickOffset, t),
        labelOffset: Offset.lerp(a.labelOffset, b.labelOffset, t),
        inactiveLabelStyle:
            TextStyle.lerp(a.inactiveLabelStyle, b.inactiveLabelStyle, t),
        activeLabelStyle:
            TextStyle.lerp(a.activeLabelStyle, b.activeLabelStyle, t),
        tooltipTextStyle:
            TextStyle.lerp(a.tooltipTextStyle, b.tooltipTextStyle, t),
        inactiveTrackColor:
            Color.lerp(a.inactiveTrackColor, b.inactiveTrackColor, t),
        activeTrackColor: Color.lerp(a.activeTrackColor, b.activeTrackColor, t),
        thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t),
        thumbStrokeColor: Color.lerp(a.thumbStrokeColor, b.thumbStrokeColor, t),
        activeDivisorStrokeColor: Color.lerp(
            a.activeDivisorStrokeColor, b.activeDivisorStrokeColor, t),
        inactiveDivisorStrokeColor: Color.lerp(
            a.inactiveDivisorStrokeColor, b.inactiveDivisorStrokeColor, t),
        activeTickColor: Color.lerp(a.activeTickColor, b.activeTickColor, t),
        inactiveTickColor:
            Color.lerp(a.inactiveTickColor, b.inactiveTickColor, t),
        disabledActiveTickColor:
            Color.lerp(a.disabledActiveTickColor, b.disabledActiveTickColor, t),
        disabledInactiveTickColor: Color.lerp(
            a.disabledInactiveTickColor, b.disabledInactiveTickColor, t),
        activeMinorTickColor:
            Color.lerp(a.activeMinorTickColor, b.activeMinorTickColor, t),
        inactiveMinorTickColor:
            Color.lerp(a.inactiveMinorTickColor, b.inactiveMinorTickColor, t),
        disabledActiveMinorTickColor: Color.lerp(
            a.disabledActiveMinorTickColor, b.disabledActiveMinorTickColor, t),
        disabledInactiveMinorTickColor: Color.lerp(
            a.disabledInactiveMinorTickColor,
            b.disabledInactiveMinorTickColor,
            t),
        overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
        inactiveDivisorColor:
            Color.lerp(a.inactiveDivisorColor, b.inactiveDivisorColor, t),
        activeDivisorColor:
            Color.lerp(a.activeDivisorColor, b.activeDivisorColor, t),
        disabledActiveTrackColor: Color.lerp(
            a.disabledActiveTrackColor, b.disabledActiveTrackColor, t),
        disabledInactiveTrackColor: Color.lerp(
            a.disabledInactiveTrackColor, b.disabledInactiveTrackColor, t),
        disabledActiveDivisorColor: Color.lerp(
            a.disabledActiveDivisorColor, b.disabledActiveDivisorColor, t),
        disabledInactiveDivisorColor: Color.lerp(
            a.disabledInactiveDivisorColor, b.disabledInactiveDivisorColor, t),
        disabledThumbColor:
            Color.lerp(a.disabledThumbColor, b.disabledThumbColor, t),
        tooltipBackgroundColor:
            Color.lerp(a.tooltipBackgroundColor, b.tooltipBackgroundColor, t),
        trackCornerRadius:
            lerpDouble(a.trackCornerRadius, b.trackCornerRadius, t),
        overlayRadius: lerpDouble(a.overlayRadius, b.overlayRadius, t),
        thumbRadius: lerpDouble(a.thumbRadius, b.thumbRadius, t),
        activeDivisorRadius:
            lerpDouble(a.activeDivisorRadius, b.activeDivisorRadius, t),
        inactiveDivisorRadius:
            lerpDouble(a.inactiveDivisorRadius, b.inactiveDivisorRadius, t),
        thumbStrokeWidth: lerpDouble(a.thumbStrokeWidth, b.thumbStrokeWidth, t),
        activeDivisorStrokeWidth:
            lerpDouble(a.activeDivisorStrokeWidth, b.activeDivisorStrokeWidth, t),
        inactiveDivisorStrokeWidth: lerpDouble(a.inactiveDivisorStrokeWidth, b.inactiveDivisorStrokeWidth, t));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SfSliderThemeData &&
        other.brightness == brightness &&
        other.activeTrackHeight == activeTrackHeight &&
        other.inactiveTrackHeight == inactiveTrackHeight &&
        other.tickSize == tickSize &&
        other.minorTickSize == minorTickSize &&
        other.tickOffset == tickOffset &&
        other.labelOffset == labelOffset &&
        other.inactiveLabelStyle == inactiveLabelStyle &&
        other.activeLabelStyle == activeLabelStyle &&
        other.tooltipTextStyle == tooltipTextStyle &&
        other.inactiveTrackColor == inactiveTrackColor &&
        other.activeTrackColor == activeTrackColor &&
        other.thumbColor == thumbColor &&
        other.thumbStrokeColor == thumbStrokeColor &&
        other.activeDivisorStrokeColor == activeDivisorStrokeColor &&
        other.inactiveDivisorStrokeColor == inactiveDivisorStrokeColor &&
        other.activeTickColor == activeTickColor &&
        other.inactiveTickColor == inactiveTickColor &&
        other.disabledActiveTickColor == disabledActiveTickColor &&
        other.disabledInactiveTickColor == disabledInactiveTickColor &&
        other.activeMinorTickColor == activeMinorTickColor &&
        other.inactiveMinorTickColor == inactiveMinorTickColor &&
        other.disabledActiveMinorTickColor == disabledActiveMinorTickColor &&
        other.disabledInactiveMinorTickColor ==
            disabledInactiveMinorTickColor &&
        other.overlayColor == overlayColor &&
        other.inactiveDivisorColor == inactiveDivisorColor &&
        other.activeDivisorColor == activeDivisorColor &&
        other.disabledActiveTrackColor == disabledActiveTrackColor &&
        other.disabledInactiveTrackColor == disabledInactiveTrackColor &&
        other.disabledActiveDivisorColor == disabledActiveDivisorColor &&
        other.disabledInactiveDivisorColor == disabledInactiveDivisorColor &&
        other.disabledThumbColor == disabledThumbColor &&
        other.tooltipBackgroundColor == tooltipBackgroundColor &&
        other.trackCornerRadius == trackCornerRadius &&
        other.overlayRadius == overlayRadius &&
        other.thumbRadius == thumbRadius &&
        other.activeDivisorRadius == activeDivisorRadius &&
        other.inactiveDivisorRadius == inactiveDivisorRadius &&
        other.thumbStrokeWidth == thumbStrokeWidth &&
        other.activeDivisorStrokeWidth == activeDivisorStrokeWidth &&
        other.inactiveDivisorStrokeWidth == inactiveDivisorStrokeWidth;
  }

  @override
  int get hashCode {
    return hashList(<Object?>[
      brightness,
      activeTrackHeight,
      inactiveTrackHeight,
      tickSize,
      minorTickSize,
      tickOffset,
      labelOffset,
      inactiveLabelStyle,
      activeLabelStyle,
      tooltipTextStyle,
      inactiveTrackColor,
      activeTrackColor,
      thumbColor,
      thumbStrokeColor,
      activeDivisorStrokeColor,
      inactiveDivisorStrokeColor,
      activeTickColor,
      inactiveTickColor,
      disabledActiveTickColor,
      disabledInactiveTickColor,
      activeMinorTickColor,
      inactiveMinorTickColor,
      disabledActiveMinorTickColor,
      disabledInactiveMinorTickColor,
      overlayColor,
      inactiveDivisorColor,
      activeDivisorColor,
      disabledActiveTrackColor,
      disabledInactiveTrackColor,
      disabledActiveDivisorColor,
      disabledInactiveDivisorColor,
      disabledThumbColor,
      tooltipBackgroundColor,
      trackCornerRadius,
      overlayRadius,
      activeDivisorRadius,
      inactiveDivisorRadius,
      thumbRadius,
      thumbStrokeWidth,
      activeDivisorStrokeWidth,
      inactiveDivisorStrokeWidth,
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfSliderThemeData defaultData = SfSliderThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(DoubleProperty('activeTrackHeight', activeTrackHeight,
        defaultValue: defaultData.activeTrackHeight));
    properties.add(DoubleProperty('inactiveTrackHeight', inactiveTrackHeight,
        defaultValue: defaultData.inactiveTrackHeight));
    properties.add(DiagnosticsProperty<Size>('tickSize', tickSize,
        defaultValue: defaultData.tickSize));
    properties.add(DiagnosticsProperty<Size>('minorTickSize', minorTickSize,
        defaultValue: defaultData.minorTickSize));
    properties.add(DiagnosticsProperty<Offset>('tickOffset', tickOffset,
        defaultValue: defaultData.tickOffset));
    properties.add(DiagnosticsProperty<Offset>('labelOffset', labelOffset,
        defaultValue: defaultData.labelOffset));
    properties.add(DiagnosticsProperty<TextStyle>(
        'inactiveLabelStyle', inactiveLabelStyle,
        defaultValue: defaultData.inactiveLabelStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'activeLabelStyle', activeLabelStyle,
        defaultValue: defaultData.activeLabelStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'tooltipTextStyle', tooltipTextStyle,
        defaultValue: defaultData.tooltipTextStyle));
    properties.add(ColorProperty('inactiveTrackColor', inactiveTrackColor,
        defaultValue: defaultData.inactiveTrackColor));
    properties.add(ColorProperty('activeTrackColor', activeTrackColor,
        defaultValue: defaultData.activeTrackColor));
    properties.add(ColorProperty('thumbColor', thumbColor,
        defaultValue: defaultData.thumbColor));
    properties.add(ColorProperty('thumbStrokeColor', thumbStrokeColor,
        defaultValue: defaultData.thumbStrokeColor));
    properties.add(ColorProperty(
        'activeDivisorStrokeColor', activeDivisorStrokeColor,
        defaultValue: defaultData.activeDivisorStrokeColor));
    properties.add(ColorProperty(
        'inactiveDivisorStrokeColor', inactiveDivisorStrokeColor,
        defaultValue: defaultData.inactiveDivisorStrokeColor));
    properties.add(ColorProperty('activeTickColor', activeTickColor,
        defaultValue: defaultData.activeTickColor));
    properties.add(ColorProperty('inactiveTickColor', inactiveTickColor,
        defaultValue: defaultData.inactiveTickColor));
    properties.add(ColorProperty(
        'disabledActiveTickColor', disabledActiveTickColor,
        defaultValue: defaultData.disabledActiveTickColor));
    properties.add(ColorProperty(
        'disabledInactiveTickColor', disabledInactiveTickColor,
        defaultValue: defaultData.disabledInactiveTickColor));
    properties.add(ColorProperty('activeMinorTickColor', activeMinorTickColor,
        defaultValue: defaultData.activeMinorTickColor));
    properties.add(ColorProperty(
        'inactiveMinorTickColor', inactiveMinorTickColor,
        defaultValue: defaultData.inactiveMinorTickColor));
    properties.add(ColorProperty(
        'disabledActiveMinorTickColor', disabledActiveMinorTickColor,
        defaultValue: defaultData.disabledActiveMinorTickColor));
    properties.add(ColorProperty(
        'disabledInactiveMinorTickColor', disabledInactiveMinorTickColor,
        defaultValue: defaultData.disabledInactiveMinorTickColor));
    properties.add(ColorProperty('overlayColor', overlayColor,
        defaultValue: defaultData.overlayColor));
    properties.add(ColorProperty('inactiveDivisorColor', inactiveDivisorColor,
        defaultValue: defaultData.inactiveDivisorColor));
    properties.add(ColorProperty('activeDivisorColor', activeDivisorColor,
        defaultValue: defaultData.activeDivisorColor));
    properties.add(ColorProperty(
        'disabledActiveTrackColor', disabledActiveTrackColor,
        defaultValue: defaultData.disabledActiveTrackColor));
    properties.add(ColorProperty(
        'disabledInactiveTrackColor', disabledInactiveTrackColor,
        defaultValue: defaultData.disabledInactiveTrackColor));
    properties.add(ColorProperty(
        'disabledActiveDivisorColor', disabledActiveDivisorColor,
        defaultValue: defaultData.disabledActiveDivisorColor));
    properties.add(ColorProperty(
        'disabledInactiveDivisorColor', disabledInactiveDivisorColor,
        defaultValue: defaultData.disabledInactiveDivisorColor));
    properties.add(ColorProperty('disabledThumbColor', disabledThumbColor,
        defaultValue: defaultData.disabledThumbColor));
    properties.add(ColorProperty(
        'tooltipBackgroundColor', tooltipBackgroundColor,
        defaultValue: defaultData.tooltipBackgroundColor));
    properties.add(DoubleProperty('trackCornerRadius', trackCornerRadius,
        defaultValue: defaultData.trackCornerRadius));
    properties.add(DoubleProperty('overlayRadius', overlayRadius,
        defaultValue: defaultData.overlayRadius));
    properties.add(DoubleProperty('thumbRadius', thumbRadius,
        defaultValue: defaultData.thumbRadius));
    properties.add(DoubleProperty('activeDivisorRadius', activeDivisorRadius,
        defaultValue: defaultData.activeDivisorRadius));
    properties.add(DoubleProperty(
        'inactiveDivisorRadius', inactiveDivisorRadius,
        defaultValue: defaultData.inactiveDivisorRadius));
    properties.add(DoubleProperty('thumbStrokeWidth', thumbStrokeWidth,
        defaultValue: defaultData.thumbStrokeWidth));
    properties.add(DoubleProperty(
        'activeDivisorStrokeWidth', activeDivisorStrokeWidth,
        defaultValue: defaultData.activeDivisorStrokeWidth));
    properties.add(DoubleProperty(
        'inactiveDivisorStrokeWidth', inactiveDivisorStrokeWidth,
        defaultValue: defaultData.inactiveDivisorStrokeWidth));
  }

  /// Specifies the light and dark theme for the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// This theme applies to all the [SfSlider] which are
  /// added as children of [SfSliderTheme].
  ///
  /// This theme applies to all the [SfRangeSlider] which are
  /// added as children of [SfRangeSliderTheme].
  ///
  /// This theme applies to all the [SfRangeSelector] which are
  /// added as children of [SfRangeSelectorTheme].
  ///
  /// This snippet shows how to set brightness in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               brightness: Brightness.dark,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               interval: 2,
  ///               showTicks: true,
  ///               showLabels: true,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final Brightness brightness;

  /// Specifies the height for the active track in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `2.0`.
  ///
  /// This snippet shows how to set active track height
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               activeTrackHeight: 8,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final double activeTrackHeight;

  /// Specifies the height for the inactive track in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `2.0`.
  ///
  /// This snippet shows how to set inactive height in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               inactiveTrackHeight: 8,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final double inactiveTrackHeight;

  /// Specifies the radius for the active divisor in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// By default, active divisor will be in same height of active track.
  ///
  /// This snippet shows how to set active divisor radius
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               activeDivisorRadius: 5,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final double? activeDivisorRadius;

  /// Specifies the radius for the inactive divisor in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// By default, inactive divisor will be in same height of inactive track.
  ///
  /// This snippet shows how to set inactive divisor radius
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               inactiveDivisorRadius: 5,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final double? inactiveDivisorRadius;

  /// Specifies the stroke width for the thumb in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set thumb stroke width
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               thumbStrokeWidth: 2,
  ///               thumbStrokeColor: Colors.red,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final double? thumbStrokeWidth;

  /// Specifies the stroke width for the active divisor in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set active divisor stroke width
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               activeDivisorStrokeWidth: 2,
  ///               activeDivisorStrokeColor: Colors.red,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final double? activeDivisorStrokeWidth;

  /// Specifies the stroke width for the inactive divisor in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set inactive divisor stroke width
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               inactiveDivisorStrokeWidth: 2,
  ///               inactiveDivisorStrokeColor: Colors.red,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final double? inactiveDivisorStrokeWidth;

  /// Specifies the size for tick.
  /// Specifies the size for the major ticks in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Major ticks is a shape which is used to represent the
  /// major interval points of the track.
  ///
  /// Defaults to `Size(1.0, 8.0)`.
  ///
  /// This snippet shows how to set major tick size in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 tickSize: Size(3.0, 12.0),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Size? tickSize;

  /// Specifies the size for the minor ticks in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Minor ticks represents the number of smaller ticks between 2 major ticks.
  ///
  /// Defaults to `Size(1.0, 5.0)`.
  ///
  /// This snippet shows how to set minor tick size in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 minorTickSize: Size(3.0, 8.0),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 interval: 2,
  ///                 minorTicksPerInterval: 1,
  ///                 showTicks: true,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Size? minorTickSize;

  /// Adjust the space around ticks in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The default value is `null`.
  ///
  /// This snippet shows how to set tick offset in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 tickOffset: Offset(0.0, 10.0),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 interval: 2,
  ///                 minorTicksPerInterval: 1,
  ///                 showTicks: true,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Offset? tickOffset;

  /// Adjust the space around labels in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The default value of [labelOffset] property is `Offset(0.0, 13.0)`
  /// if the [showTicks] property is `false`.
  ///
  /// The default value of [labelOffset] property is `Offset(0.0, 5.0)`
  /// if the [showTicks] property is `true`.
  ///
  /// This snippet shows how to set label offset in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 labelOffset: Offset(0.0, 10.0),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 showLabels: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Offset? labelOffset;

  /// Specifies the appearance for inactive label in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between
  /// the [min] value and the start thumb and the end thumb and the [max] value.
  ///
  /// For RTL, the inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [max] value and the start thumb,
  /// and the end thumb and the [min] value.
  ///
  /// The inactive side of the [SfSlider] is between thumb and [max] value.
  ///
  /// This snippet shows how to set inactive label style
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 inactiveLabelStyle: TextStyle(color: Colors.red[200],
  ///                 fontSize: 12, fontStyle: FontStyle.italic),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 showLabels: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final TextStyle? inactiveLabelStyle;

  /// Specifies the appearance for active label in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector]
  /// is between start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between [min] value and the thumb.
  ///
  /// This snippet shows how to set active label
  /// style in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 activeLabelStyle: TextStyle(color: Colors.red,
  ///                 fontSize: 12, fontStyle: FontStyle.italic),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 showLabels: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final TextStyle? activeLabelStyle;

  /// Specifies the appearance for the tooltip in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// This snippet shows how to set tooltip label style
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 tooltipTextStyle: TextStyle(color: Colors.red,
  ///                 fontSize: 16, fontStyle: FontStyle.italic),
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 showLabels: true,
  ///                 showTooltip: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final TextStyle? tooltipTextStyle;

  /// Specifies the color for the inactive track in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [min] value and the start thumb and end thumb and [max] value.
  ///
  /// For RTL, the inactive side of the [SfRangeSlider] and [SfRangeSelector]
  /// between the [max] value and the start thumb, and the end thumb
  /// and the [min] value.
  ///
  /// The inactive side of the [SfSlider] is between [max] value and thumb.
  ///
  /// This snippet shows how to set inactive track color
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 inactiveTrackColor: Colors.red[100],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? inactiveTrackColor;

  /// Specifies the color for active track in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min] value and thumb.
  ///
  /// This snippet shows how to set active track color
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 activeTrackColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? activeTrackColor;

  /// Specifies the color for the thumb in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// This snippet shows how to set thumb color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 thumbColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 showLabels: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? thumbColor;

  /// Specifies the stroke color for the thumb in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set thumb stroke color
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               thumbStrokeWidth: 2,
  ///               thumbStrokeColor: Colors.red,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final Color? thumbStrokeColor;

  /// Specifies the stroke color for the active divisor in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `null`.
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min] value and thumb.
  ///
  /// This snippet shows how to set active divisor stroke color
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               activeDivisorStrokeWidth: 2,
  ///               activeDivisorStrokeColor: Colors.red,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final Color? activeDivisorStrokeColor;

  /// Specifies the stroke color for the inactive divisor in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `null`.
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [min] value and the start thumb and end thumb and [max] value.
  ///
  /// For RTL, the inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [max] value and the start thumb and end thumb and [min] value.
  ///
  /// The inactive side of the [SfSlider] is between the
  /// [max] value and the thumb.
  ///
  /// This snippet shows how to set inactive divisor stroke
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               inactiveDivisorStrokeWidth: 2,
  ///               inactiveDivisorStrokeColor: Colors.red,
  ///           ),
  ///           child:  SfRangeSlider(
  ///               min: 2.0,
  ///               max: 10.0,
  ///               values: _values,
  ///               onChanged: (SfRangeValues newValues){
  ///                   setState(() {
  ///                       _values = newValues;
  ///                   });
  ///               },
  ///           )
  ///       ),
  ///    )
  /// )
  /// ```
  final Color? inactiveDivisorStrokeColor;

  /// Specifies the color for active tick.
  /// Specifies the color for the active major ticks in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min] value and thumb.
  ///
  /// This snippet shows how to set active major ticks color
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 activeTickColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color activeTickColor;

  /// Specifies the color for the inactive major ticks in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [min] value and the start thumb,
  /// and the end thumb and the [max] value.
  ///
  /// For RTL, the inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [max] value and the start thumb,
  /// and the end thumb and the [min] value.
  ///
  /// The inactive side of the [SfSlider] is between the
  /// [min] value and the thumb.
  ///
  /// This snippet shows how to set inactive major ticks
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  inactiveTickColor: Colors.red[100],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color inactiveTickColor;

  /// Specifies the color for the disabled active major ticks in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min]
  /// value and the thumb.
  ///
  /// This snippet shows how to set disabled active major ticks
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledActiveTickColor: Colors.orange,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledActiveTickColor;

  /// Specifies the color for the disabled inactive major ticks in the
  /// [SfSlider], [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [min] value and the start thumb,
  /// and the end thumb and the [max] value.
  ///
  /// For RTL, the inactive side is between the [max] value and the start thumb,
  /// and the end thumb and the [min] value.
  ///
  /// The inactive side of the [SfSlider] is between the
  /// [max] value and the thumb.
  ///
  /// This snippet shows how to set disabled inactive major ticks
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledInactiveTickColor: Colors.orange[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showTicks: true,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledInactiveTickColor;

  /// Specifies the color for the active minor ticks in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min] value and thumb.
  ///
  /// This snippet shows how to set active minor ticks
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  activeMinorTickColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 minorTicksPerInterval: 1,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color activeMinorTickColor;

  /// Specifies the color for the inactive minor ticks in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// This snippet shows how to set inactive minor ticks
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  inactiveMinorTickColor: Colors.red[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 minorTicksPerInterval: 1,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color inactiveMinorTickColor;

  /// Specifies the color for the disabled active minor ticks in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min] and the thumb.
  ///
  /// This snippet shows how to set disabled active minor ticks
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                   disabledActiveMinorTickColor: Colors.orange,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 minorTicksPerInterval: 1,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledActiveMinorTickColor;

  /// Specifies the color for the disabled inactive minor ticks in
  /// the [SfSlider], [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between
  /// the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// The inactive side of the [SfSlider] is between the
  /// [max] value and the thumb.
  ///
  /// This snippet shows how to set disabled inactive minor ticks
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledInactiveMinorTickColor: Colors.orange[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 minorTicksPerInterval: 1,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledInactiveMinorTickColor;

  /// Specifies the color for the overlay in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Overlay appears while interacting with thumbs.
  ///
  /// This snippet shows how to set overlay color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  overlayColor: Colors.red[50],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? overlayColor;

  /// Specifies the color for the inactive divisors in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// The inactive side of the [SfSlider] is between the
  /// [max] value and the thumb.
  ///
  /// This snippet shows how to set inactive divisors
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  inactiveDivisorColor: Colors.red[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showDivisors: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? inactiveDivisorColor;

  /// Specifies the color for the active divisors in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min]
  /// value and the thumb.
  ///
  /// This snippet shows how to set active divisors
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  activeDivisorColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showDivisors: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? activeDivisorColor;

  /// Specifies the color for the disabled active track in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is between
  /// start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between
  /// the [min] value and the thumb.
  ///
  /// This snippet shows how to set disabled active track
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledActiveTrackColor: Colors.orange,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? disabledActiveTrackColor;

  /// Specifies the color for the disabled inactive track in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between
  /// the [min] value and the left thumb,
  /// and the right thumb and the [max] value.
  ///
  /// For RTL, the inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// The inactive side of the [SfSlider] is between the
  /// [max] value and the thumb.
  ///
  /// This snippet shows how to set disabled inactive track
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledInactiveTrackColor: Colors.orange[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? disabledInactiveTrackColor;

  /// Specifies the color for the disabled active divisors in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector]
  /// is between start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min] value and thumb.
  ///
  /// This snippet shows how to set disabled active divisor
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledActiveDivisorColor: Colors.purple,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 showDivisors: true,
  ///                 minorTicksPerInterval: 1,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? disabledActiveDivisorColor;

  /// Specifies the color for the disabled inactive divisors in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The inactive side of the [SfRangeSlider] and [SfRangeSelector] is between
  /// the [min] value and the left thumb and right thumb and the [max] value.
  ///
  /// For RTL, the inactive side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the [max] value and the left thumb,
  /// and the right thumb and the [min] value.
  ///
  /// The inactive side of the [SfSlider] is between the
  /// [max] value and the thumb.
  ///
  /// This snippet shows how to set disabled inactive divisor
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 disabledInactiveDivisorColor: Colors.purple[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 showDivisors: true,
  ///                 minorTicksPerInterval: 1,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? disabledInactiveDivisorColor;

  /// Specifies the color for the disabled thumb in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// This snippet shows how to set disabled
  /// thumb color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 disabledThumbColor: Colors.orange,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color disabledThumbColor;

  /// Specifies the color for the tooltip background in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// This snippet shows how to set tooltip background
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 tooltipBackgroundColor: Colors.red[300],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showLabels: true,
  ///                 showTooltip: true,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? tooltipBackgroundColor;

  /// Specifies the radius for the track corners in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// This snippet shows how to set track corner
  /// radius in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 trackHeight: 10,
  ///                 trackCornerRadius: 5,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final double? trackCornerRadius;

  /// Specifies the radius for the overlay in the [SfSlider], [SfRangeSlider],
  /// and [SfRangeSelector].
  ///
  /// Overlay appears while interacting with thumbs.
  ///
  /// This snippet shows how to set overlay radius in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 overlayRadius: 22,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final double overlayRadius;

  /// Specifies the radius for the thumb in the [SfSlider], [SfRangeSlider],
  /// and [SfRangeSelector].
  ///
  /// This snippet shows how to set thumb radius in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 thumbRadius: 13,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 onChanged: (SfRangeValues newValues){
  ///                     setState(() {
  ///                         _values = newValues;
  ///                     });
  ///                 },
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final double thumbRadius;
}
