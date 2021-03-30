import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

/// Applies a theme to descendant [SfDataPager] widgets.
class SfDataPagerTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  const SfDataPagerTheme({Key? key, required this.data, required this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant [SfDataPager]
  /// widgets.
  final SfDataPagerThemeData data;

  /// The widget below this widget in the tree.
  @override
  final Widget child;

  /// The data from the closest [SfDataPagerTheme]
  /// instance that encloses the given context.
  ///
  /// Defaults to [SfThemeData.dataPagerThemeData] if there
  /// is no [SfDataPagerTheme] in the given build context.
  static SfDataPagerThemeData? of(BuildContext context) {
    final SfDataPagerTheme? sfDataPagerTheme =
        context.dependOnInheritedWidgetOfExactType<SfDataPagerTheme>();
    return sfDataPagerTheme?.data ?? SfTheme.of(context).dataPagerThemeData;
  }

  @override
  bool updateShouldNotify(SfDataPagerTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfDataPagerTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfDataPagerTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfDataPagerTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfDataPagerTheme]. Use
///  this class to configure a [SfDataPagerTheme] widget
///
/// To obtain the current theme, use [SfDataPagerTheme.of].
class SfDataPagerThemeData with Diagnosticable {
  /// Create a [SfDataPagerThemeData] that's used to configure a
  /// [SfDataPagerTheme].
  factory SfDataPagerThemeData(
      {Brightness? brightness,
      Color? backgroundColor,
      Color? itemColor,
      TextStyle? itemTextStyle,
      Color? selectedItemColor,
      TextStyle? selectedItemTextStyle,
      Color? disabledItemColor,
      TextStyle? disabledItemTextStyle,
      Color? itemBorderColor,
      double? itemBorderWidth,
      BorderRadiusGeometry? itemBorderRadius}) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;

    backgroundColor ??= isLight
        ? Color.fromRGBO(255, 255, 255, 1)
        : Color.fromRGBO(33, 33, 33, 1);

    itemColor ??= isLight
        ? Color.fromRGBO(255, 255, 255, 1)
        : Color.fromRGBO(33, 33, 33, 1);

    itemTextStyle ??= TextStyle(
        color: isLight
            ? Color.fromRGBO(0, 0, 0, 0.87)
            : Color.fromRGBO(255, 255, 255, 1),
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400);

    itemBorderRadius ??= BorderRadius.circular(50);

    itemBorderColor ??= Colors.transparent;

    selectedItemColor ??= Color.fromRGBO(33, 150, 243, 1);

    selectedItemTextStyle ??= TextStyle(
        color: Color.fromRGBO(255, 255, 255, 1),
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400);

    disabledItemColor ??= Colors.transparent;

    disabledItemTextStyle ??= TextStyle(
        color: isLight
            ? Color.fromRGBO(0, 0, 0, 0.36)
            : Color.fromRGBO(255, 255, 255, 0.36));

    return SfDataPagerThemeData.raw(
        brightness: brightness,
        backgroundColor: backgroundColor,
        itemColor: itemColor,
        itemTextStyle: itemTextStyle,
        selectedItemColor: selectedItemColor,
        selectedItemTextStyle: selectedItemTextStyle,
        disabledItemColor: disabledItemColor,
        disabledItemTextStyle: disabledItemTextStyle,
        itemBorderColor: itemBorderColor,
        itemBorderWidth: itemBorderWidth,
        itemBorderRadius: itemBorderRadius);
  }

  /// Create a [SfDataPagerThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfDataPagerThemeData] constructor.
  const SfDataPagerThemeData.raw(
      {required this.brightness,
      required this.backgroundColor,
      required this.itemColor,
      required this.itemTextStyle,
      required this.selectedItemColor,
      required this.selectedItemTextStyle,
      required this.disabledItemColor,
      required this.disabledItemTextStyle,
      required this.itemBorderColor,
      required this.itemBorderWidth,
      required this.itemBorderRadius});

  /// The brightness of the overall theme of the
  /// application for the [SfDataPager] widgets.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).brightness], brightness for
  /// datapager widgets will be applied.
  final Brightness brightness;

  /// The color of the page Items
  final Color itemColor;

  /// The color of the data pager background
  final Color backgroundColor;

  /// The style of the text of page Items
  final TextStyle itemTextStyle;

  /// The color of the page Items which are disabled.
  final Color disabledItemColor;

  /// The style of the text of page items which are disabled.
  final TextStyle disabledItemTextStyle;

  /// The color of the currently selected page item.
  final Color selectedItemColor;

  /// The style of the text of currently selected page Item.
  final TextStyle selectedItemTextStyle;

  /// The color of the border in page Item.
  final Color itemBorderColor;

  /// The width of the border in page item.
  final double? itemBorderWidth;

  ///If non null, the corners of the page item are rounded by this [ItemBorderRadius].
  ///
  /// Applies only to boxes with rectangular shapes;
  /// see also:
  ///
  /// [BoxDecoration.borderRadius]
  final BorderRadiusGeometry itemBorderRadius;

  /// Creates a copy of this theme but with the given
  /// fields replaced with the new values.
  SfDataPagerThemeData copyWith(
      {Brightness? brightness,
      Color? backgroundColor,
      Color? itemColor,
      TextStyle? itemTextStyle,
      Color? selectedItemColor,
      TextStyle? selectedItemTextStyle,
      Color? disabledItemColor,
      TextStyle? disabledItemTextStyle,
      Color? itemBorderColor,
      double? itemBorderWidth,
      BorderRadiusGeometry? itemBorderRadius}) {
    return SfDataPagerThemeData.raw(
        brightness: brightness ?? this.brightness,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        itemColor: itemColor ?? this.itemColor,
        itemTextStyle: itemTextStyle ?? this.itemTextStyle,
        selectedItemColor: selectedItemColor ?? this.selectedItemColor,
        selectedItemTextStyle:
            selectedItemTextStyle ?? this.selectedItemTextStyle,
        disabledItemColor: disabledItemColor ?? this.disabledItemColor,
        disabledItemTextStyle:
            disabledItemTextStyle ?? this.disabledItemTextStyle,
        itemBorderColor: itemBorderColor ?? this.itemBorderColor,
        itemBorderWidth: itemBorderWidth ?? this.itemBorderWidth,
        itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius);
  }

  /// Linearly interpolate between two themes.
  static SfDataPagerThemeData? lerp(
      SfDataPagerThemeData? a, SfDataPagerThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfDataPagerThemeData(
        backgroundColor: Color.lerp(a!.backgroundColor, b!.backgroundColor, t),
        itemColor: Color.lerp(a.itemColor, b.itemColor, t),
        itemTextStyle: TextStyle.lerp(a.itemTextStyle, b.itemTextStyle, t),
        selectedItemColor:
            Color.lerp(a.selectedItemColor, b.selectedItemColor, t),
        selectedItemTextStyle:
            TextStyle.lerp(a.selectedItemTextStyle, b.selectedItemTextStyle, t),
        disabledItemColor:
            Color.lerp(a.disabledItemColor, b.disabledItemColor, t),
        disabledItemTextStyle:
            TextStyle.lerp(a.disabledItemTextStyle, b.disabledItemTextStyle, t),
        itemBorderColor: Color.lerp(a.itemBorderColor, b.itemBorderColor, t),
        itemBorderWidth: lerpDouble(a.itemBorderWidth, b.itemBorderWidth, t),
        itemBorderRadius: BorderRadiusGeometry.lerp(
            a.itemBorderRadius, b.itemBorderRadius, t));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SfDataPagerThemeData &&
        other.brightness == brightness &&
        other.itemColor == itemColor &&
        other.backgroundColor == backgroundColor &&
        other.itemTextStyle == itemTextStyle &&
        other.selectedItemColor == selectedItemColor &&
        other.selectedItemTextStyle == selectedItemTextStyle &&
        other.disabledItemColor == disabledItemColor &&
        other.disabledItemTextStyle == disabledItemTextStyle &&
        other.itemBorderColor == itemBorderColor &&
        other.itemBorderWidth == itemBorderWidth &&
        other.itemBorderRadius == itemBorderRadius;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      itemColor,
      backgroundColor,
      itemTextStyle,
      selectedItemColor,
      selectedItemTextStyle,
      disabledItemColor,
      disabledItemTextStyle,
      itemBorderColor,
      itemBorderWidth,
      itemBorderRadius
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfDataPagerThemeData defaultData = SfDataPagerThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(ColorProperty('backgroundColor', backgroundColor,
        defaultValue: defaultData.backgroundColor));
    properties.add(ColorProperty('itemColor', itemColor,
        defaultValue: defaultData.itemColor));
    properties.add(ColorProperty('selectedItemColor', selectedItemColor,
        defaultValue: defaultData.selectedItemColor));
    properties.add(ColorProperty('disabledItemColor', disabledItemColor,
        defaultValue: defaultData.disabledItemColor));
    properties.add(ColorProperty('itemBorderColor', itemBorderColor,
        defaultValue: defaultData.itemBorderColor));
    properties.add(DiagnosticsProperty<TextStyle>(
        'itemTextStyle', itemTextStyle,
        defaultValue: defaultData.itemTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'selectedItemTextStyle', selectedItemTextStyle,
        defaultValue: defaultData.selectedItemTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'disabledItemTextStyle', disabledItemTextStyle,
        defaultValue: defaultData.disabledItemTextStyle));
    properties.add(DoubleProperty('itemBorderWidth', itemBorderWidth,
        defaultValue: defaultData.itemBorderWidth));
    properties.add(DiagnosticsProperty<BorderRadiusGeometry>(
        'itemBorderRadius', itemBorderRadius,
        defaultValue: defaultData.itemBorderRadius));
  }
}
