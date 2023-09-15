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
/// * The "dividers", which is a shape that renders on the track based on
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
@immutable
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
      Color? inactiveDividerColor,
      Color? activeDividerColor,
      Color? disabledActiveTrackColor,
      Color? disabledInactiveTrackColor,
      Color? disabledActiveDividerColor,
      Color? disabledInactiveDividerColor,
      Color? disabledThumbColor,
      Color? tooltipBackgroundColor,
      Color? thumbStrokeColor,
      Color? activeDividerStrokeColor,
      Color? inactiveDividerStrokeColor,
      double? trackCornerRadius,
      double? overlayRadius,
      double? thumbRadius,
      double? activeDividerRadius,
      double? inactiveDividerRadius,
      double? thumbStrokeWidth,
      double? activeDividerStrokeWidth,
      double? inactiveDividerStrokeWidth}) {
    brightness = brightness ?? Brightness.light;
    activeTrackHeight ??= 6.0;
    inactiveTrackHeight ??= 4.0;
    overlayRadius ??= 24.0;
    thumbRadius ??= 10.0;

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
        inactiveDividerColor: inactiveDividerColor,
        activeDividerColor: activeDividerColor,
        thumbColor: thumbColor,
        thumbStrokeColor: thumbStrokeColor,
        activeDividerStrokeColor: activeDividerStrokeColor,
        inactiveDividerStrokeColor: inactiveDividerStrokeColor,
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
        disabledActiveDividerColor: disabledActiveDividerColor,
        disabledInactiveDividerColor: disabledInactiveDividerColor,
        disabledThumbColor: disabledThumbColor,
        tooltipBackgroundColor: tooltipBackgroundColor,
        overlayRadius: overlayRadius,
        thumbRadius: thumbRadius,
        activeDividerRadius: activeDividerRadius,
        inactiveDividerRadius: inactiveDividerRadius,
        thumbStrokeWidth: thumbStrokeWidth,
        activeDividerStrokeWidth: activeDividerStrokeWidth,
        inactiveDividerStrokeWidth: inactiveDividerStrokeWidth,
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
    required this.activeDividerStrokeColor,
    required this.inactiveDividerStrokeColor,
    required this.activeTickColor,
    required this.inactiveTickColor,
    required this.disabledActiveTickColor,
    required this.disabledInactiveTickColor,
    required this.activeMinorTickColor,
    required this.inactiveMinorTickColor,
    required this.disabledActiveMinorTickColor,
    required this.disabledInactiveMinorTickColor,
    required this.overlayColor,
    required this.inactiveDividerColor,
    required this.activeDividerColor,
    required this.disabledActiveTrackColor,
    required this.disabledInactiveTrackColor,
    required this.disabledActiveDividerColor,
    required this.disabledInactiveDividerColor,
    required this.disabledThumbColor,
    required this.tooltipBackgroundColor,
    required this.trackCornerRadius,
    required this.overlayRadius,
    required this.thumbRadius,
    required this.activeDividerRadius,
    required this.inactiveDividerRadius,
    required this.thumbStrokeWidth,
    required this.activeDividerStrokeWidth,
    required this.inactiveDividerStrokeWidth,
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
    Color? activeDividerStrokeColor,
    Color? inactiveDividerStrokeColor,
    Color? activeTickColor,
    Color? inactiveTickColor,
    Color? disabledActiveTickColor,
    Color? disabledInactiveTickColor,
    Color? activeMinorTickColor,
    Color? inactiveMinorTickColor,
    Color? disabledActiveMinorTickColor,
    Color? disabledInactiveMinorTickColor,
    Color? overlayColor,
    Color? inactiveDividerColor,
    Color? activeDividerColor,
    Color? disabledActiveTrackColor,
    Color? disabledInactiveTrackColor,
    Color? disabledActiveDividerColor,
    Color? disabledInactiveDividerColor,
    Color? disabledThumbColor,
    Color? activeRegionColor,
    Color? inactiveRegionColor,
    Color? tooltipBackgroundColor,
    double? trackCornerRadius,
    double? overlayRadius,
    double? thumbRadius,
    double? activeDividerRadius,
    double? inactiveDividerRadius,
    double? thumbStrokeWidth,
    double? activeDividerStrokeWidth,
    double? inactiveDividerStrokeWidth,
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
      activeDividerStrokeColor:
          activeDividerStrokeColor ?? this.activeDividerStrokeColor,
      inactiveDividerStrokeColor:
          inactiveDividerStrokeColor ?? this.inactiveDividerStrokeColor,
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
      inactiveDividerColor: inactiveDividerColor ?? this.inactiveDividerColor,
      activeDividerColor: activeDividerColor ?? this.activeDividerColor,
      disabledActiveTrackColor:
          disabledActiveTrackColor ?? this.disabledActiveTrackColor,
      disabledInactiveTrackColor:
          disabledInactiveTrackColor ?? this.disabledInactiveTrackColor,
      disabledActiveDividerColor:
          disabledActiveDividerColor ?? this.disabledActiveDividerColor,
      disabledInactiveDividerColor:
          disabledInactiveDividerColor ?? this.disabledInactiveDividerColor,
      disabledThumbColor: disabledThumbColor ?? this.disabledThumbColor,
      tooltipBackgroundColor:
          tooltipBackgroundColor ?? this.tooltipBackgroundColor,
      trackCornerRadius: trackCornerRadius ?? this.trackCornerRadius,
      overlayRadius: overlayRadius ?? this.overlayRadius,
      thumbRadius: thumbRadius ?? this.thumbRadius,
      activeDividerRadius: activeDividerRadius ?? this.activeDividerRadius,
      inactiveDividerRadius:
          inactiveDividerRadius ?? this.inactiveDividerRadius,
      thumbStrokeWidth: thumbStrokeWidth ?? this.thumbStrokeWidth,
      activeDividerStrokeWidth:
          activeDividerStrokeWidth ?? this.activeDividerStrokeWidth,
      inactiveDividerStrokeWidth:
          inactiveDividerStrokeWidth ?? this.inactiveDividerStrokeWidth,
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
        activeDividerStrokeColor: Color.lerp(
            a.activeDividerStrokeColor, b.activeDividerStrokeColor, t),
        inactiveDividerStrokeColor: Color.lerp(
            a.inactiveDividerStrokeColor, b.inactiveDividerStrokeColor, t),
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
        inactiveDividerColor:
            Color.lerp(a.inactiveDividerColor, b.inactiveDividerColor, t),
        activeDividerColor:
            Color.lerp(a.activeDividerColor, b.activeDividerColor, t),
        disabledActiveTrackColor: Color.lerp(
            a.disabledActiveTrackColor, b.disabledActiveTrackColor, t),
        disabledInactiveTrackColor: Color.lerp(
            a.disabledInactiveTrackColor, b.disabledInactiveTrackColor, t),
        disabledActiveDividerColor: Color.lerp(
            a.disabledActiveDividerColor, b.disabledActiveDividerColor, t),
        disabledInactiveDividerColor: Color.lerp(
            a.disabledInactiveDividerColor, b.disabledInactiveDividerColor, t),
        disabledThumbColor:
            Color.lerp(a.disabledThumbColor, b.disabledThumbColor, t),
        tooltipBackgroundColor:
            Color.lerp(a.tooltipBackgroundColor, b.tooltipBackgroundColor, t),
        trackCornerRadius:
            lerpDouble(a.trackCornerRadius, b.trackCornerRadius, t),
        overlayRadius: lerpDouble(a.overlayRadius, b.overlayRadius, t),
        thumbRadius: lerpDouble(a.thumbRadius, b.thumbRadius, t),
        activeDividerRadius:
            lerpDouble(a.activeDividerRadius, b.activeDividerRadius, t),
        inactiveDividerRadius:
            lerpDouble(a.inactiveDividerRadius, b.inactiveDividerRadius, t),
        thumbStrokeWidth: lerpDouble(a.thumbStrokeWidth, b.thumbStrokeWidth, t),
        activeDividerStrokeWidth:
            // ignore: lines_longer_than_80_chars
            lerpDouble(a.activeDividerStrokeWidth, b.activeDividerStrokeWidth, t),
        // ignore: lines_longer_than_80_chars
        inactiveDividerStrokeWidth: lerpDouble(a.inactiveDividerStrokeWidth, b.inactiveDividerStrokeWidth, t));
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
        other.activeDividerStrokeColor == activeDividerStrokeColor &&
        other.inactiveDividerStrokeColor == inactiveDividerStrokeColor &&
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
        other.inactiveDividerColor == inactiveDividerColor &&
        other.activeDividerColor == activeDividerColor &&
        other.disabledActiveTrackColor == disabledActiveTrackColor &&
        other.disabledInactiveTrackColor == disabledInactiveTrackColor &&
        other.disabledActiveDividerColor == disabledActiveDividerColor &&
        other.disabledInactiveDividerColor == disabledInactiveDividerColor &&
        other.disabledThumbColor == disabledThumbColor &&
        other.tooltipBackgroundColor == tooltipBackgroundColor &&
        other.trackCornerRadius == trackCornerRadius &&
        other.overlayRadius == overlayRadius &&
        other.thumbRadius == thumbRadius &&
        other.activeDividerRadius == activeDividerRadius &&
        other.inactiveDividerRadius == inactiveDividerRadius &&
        other.thumbStrokeWidth == thumbStrokeWidth &&
        other.activeDividerStrokeWidth == activeDividerStrokeWidth &&
        other.inactiveDividerStrokeWidth == inactiveDividerStrokeWidth;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
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
      activeDividerStrokeColor,
      inactiveDividerStrokeColor,
      activeTickColor,
      inactiveTickColor,
      disabledActiveTickColor,
      disabledInactiveTickColor,
      activeMinorTickColor,
      inactiveMinorTickColor,
      disabledActiveMinorTickColor,
      disabledInactiveMinorTickColor,
      overlayColor,
      inactiveDividerColor,
      activeDividerColor,
      disabledActiveTrackColor,
      disabledInactiveTrackColor,
      disabledActiveDividerColor,
      disabledInactiveDividerColor,
      disabledThumbColor,
      tooltipBackgroundColor,
      trackCornerRadius,
      overlayRadius,
      activeDividerRadius,
      inactiveDividerRadius,
      thumbRadius,
      thumbStrokeWidth,
      activeDividerStrokeWidth,
      inactiveDividerStrokeWidth,
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
        'activeDividerStrokeColor', activeDividerStrokeColor,
        defaultValue: defaultData.activeDividerStrokeColor));
    properties.add(ColorProperty(
        'inactiveDividerStrokeColor', inactiveDividerStrokeColor,
        defaultValue: defaultData.inactiveDividerStrokeColor));
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
    properties.add(ColorProperty('inactiveDividerColor', inactiveDividerColor,
        defaultValue: defaultData.inactiveDividerColor));
    properties.add(ColorProperty('activeDividerColor', activeDividerColor,
        defaultValue: defaultData.activeDividerColor));
    properties.add(ColorProperty(
        'disabledActiveTrackColor', disabledActiveTrackColor,
        defaultValue: defaultData.disabledActiveTrackColor));
    properties.add(ColorProperty(
        'disabledInactiveTrackColor', disabledInactiveTrackColor,
        defaultValue: defaultData.disabledInactiveTrackColor));
    properties.add(ColorProperty(
        'disabledActiveDividerColor', disabledActiveDividerColor,
        defaultValue: defaultData.disabledActiveDividerColor));
    properties.add(ColorProperty(
        'disabledInactiveDividerColor', disabledInactiveDividerColor,
        defaultValue: defaultData.disabledInactiveDividerColor));
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
    properties.add(DoubleProperty('activeDividerRadius', activeDividerRadius,
        defaultValue: defaultData.activeDividerRadius));
    properties.add(DoubleProperty(
        'inactiveDividerRadius', inactiveDividerRadius,
        defaultValue: defaultData.inactiveDividerRadius));
    properties.add(DoubleProperty('thumbStrokeWidth', thumbStrokeWidth,
        defaultValue: defaultData.thumbStrokeWidth));
    properties.add(DoubleProperty(
        'activeDividerStrokeWidth', activeDividerStrokeWidth,
        defaultValue: defaultData.activeDividerStrokeWidth));
    properties.add(DoubleProperty(
        'inactiveDividerStrokeWidth', inactiveDividerStrokeWidth,
        defaultValue: defaultData.inactiveDividerStrokeWidth));
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

  /// Specifies the radius for the active divider in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// By default, active divider will be in same height of active track.
  ///
  /// This snippet shows how to set active divider radius
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               activeDividerRadius: 5,
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
  final double? activeDividerRadius;

  /// Specifies the radius for the inactive divider in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// By default, inactive divider will be in same height of inactive track.
  ///
  /// This snippet shows how to set inactive divider radius
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               inactiveDividerRadius: 5,
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
  final double? inactiveDividerRadius;

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

  /// Specifies the stroke width for the active divider in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set active divider stroke width
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               activeDividerStrokeWidth: 2,
  ///               activeDividerStrokeColor: Colors.red,
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
  final double? activeDividerStrokeWidth;

  /// Specifies the stroke width for the inactive divider in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `null`.
  ///
  /// This snippet shows how to set inactive divider stroke width
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               inactiveDividerStrokeWidth: 2,
  ///               inactiveDividerStrokeColor: Colors.red,
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
  final double? inactiveDividerStrokeWidth;

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

  /// Specifies the stroke color for the active divider in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// Defaults to `null`.
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between the start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min] value and thumb.
  ///
  /// This snippet shows how to set active divider stroke color
  /// in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               activeDividerStrokeWidth: 2,
  ///               activeDividerStrokeColor: Colors.red,
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
  final Color? activeDividerStrokeColor;

  /// Specifies the stroke color for the inactive divider in the [SfSlider],
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
  /// This snippet shows how to set inactive divider stroke
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 7.0);
  ///
  /// Scaffold(
  ///   body: Center(
  ///       child: SfRangeSliderTheme(
  ///           data: SfRangeSliderThemeData(
  ///               inactiveDividerStrokeWidth: 2,
  ///               inactiveDividerStrokeColor: Colors.red,
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
  final Color? inactiveDividerStrokeColor;

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
  final Color? activeTickColor;

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
  final Color? inactiveTickColor;

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
  final Color? disabledActiveTickColor;

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
  final Color? disabledInactiveTickColor;

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
  final Color? activeMinorTickColor;

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
  final Color? inactiveMinorTickColor;

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
  final Color? disabledActiveMinorTickColor;

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
  final Color? disabledInactiveMinorTickColor;

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

  /// Specifies the color for the inactive dividers in the [SfSlider],
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
  /// This snippet shows how to set inactive dividers
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  inactiveDividerColor: Colors.red[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showDividers: true,
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
  final Color? inactiveDividerColor;

  /// Specifies the color for the active dividers in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector] is
  /// between start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min]
  /// value and the thumb.
  ///
  /// This snippet shows how to set active dividers
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  activeDividerColor: Colors.red,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 1,
  ///                 showDividers: true,
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
  final Color? activeDividerColor;

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

  /// Specifies the color for the disabled active dividers in the [SfSlider],
  /// [SfRangeSlider], and [SfRangeSelector].
  ///
  /// The active side of the [SfRangeSlider] and [SfRangeSelector]
  /// is between start and end thumbs.
  ///
  /// The active side of the [SfSlider] is between the [min] value and thumb.
  ///
  /// This snippet shows how to set disabled active divider
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                  disabledActiveDividerColor: Colors.purple,
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 showDividers: true,
  ///                 minorTicksPerInterval: 1,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? disabledActiveDividerColor;

  /// Specifies the color for the disabled inactive dividers in the [SfSlider],
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
  /// This snippet shows how to set disabled inactive divider
  /// color in [SfRangeSliderThemeData].
  ///
  /// ```dart
  /// SfRangeValues _values = SfRangeValues(4.0, 8.0);
  ///
  /// Scaffold(
  ///     body: Center(
  ///         child: SfRangeSliderTheme(
  ///             data: SfRangeSliderThemeData(
  ///                 disabledInactiveDividerColor: Colors.purple[200],
  ///             ),
  ///             child:  SfRangeSlider(
  ///                 min: 2.0,
  ///                 max: 10.0,
  ///                 values: _values,
  ///                 interval: 2,
  ///                 showTicks: true,
  ///                 showDividers: true,
  ///                 minorTicksPerInterval: 1,
  ///            )
  ///        ),
  ///    )
  /// )
  /// ```
  final Color? disabledInactiveDividerColor;

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
  final Color? disabledThumbColor;

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
