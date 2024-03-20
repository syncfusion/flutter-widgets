import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_core/theme.dart';

///SfSLiderThemeData gives the color to [SfSlider]
///when useMaterial 3 is false
///It gets the [context] as parameter in constructors
///[SfSliderThemeDataM2] override the properties
///[SfSliderThemeDataM2] get the color of properties.
///return SfSliderThemeData() as SfSliderThemeDataM2 in matrial 2;

class SfSliderThemeDataM2 extends SfSliderThemeData {
  ///context is parameter of the constructor.
  SfSliderThemeDataM2(this.context);

  ///[context] refers to the current state of the widget.
  final BuildContext context;

  ///Theme.of(context) retrives the ThemeData
  ///[colorScheme] is a variable along with
  /// late and final keyword
  /// to obtain the theme of the context from [ColorScheme].
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get activeTrackColor => colorScheme.primary;

  @override
  Color? get inactiveTrackColor => colorScheme.primary.withOpacity(0.24);

  @override
  Color? get disabledActiveTrackColor =>
      colorScheme.onSurface.withOpacity(0.32);

  @override
  Color? get disabledInactiveTrackColor =>
      colorScheme.onSurface.withOpacity(0.12);

  @override
  Color? get thumbColor => colorScheme.primary;

  @override
  Color? get overlayColor => colorScheme.primary.withOpacity(0.12);

  @override
  Color? get disabledThumbColor => Color.alphaBlend(
      colorScheme.onSurface.withOpacity(0.38), colorScheme.surface);

  @override
  Color? get activeTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get inactiveTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get activeMinorTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get inactiveMinorTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get activeDividerColor => colorScheme.onPrimary.withOpacity(0.54);

  @override
  Color? get inactiveDividerColor => colorScheme.primary.withOpacity(0.54);

  @override
  Color? get disabledActiveDividerColor =>
      colorScheme.onPrimary.withOpacity(0.12);

  @override
  Color? get disabledInactiveDividerColor =>
      colorScheme.onSurface.withOpacity(0.12);

  @override
  Color? get disabledActiveTickColor => colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get disabledInactiveTickColor =>
      colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get disabledActiveMinorTickColor =>
      colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get disabledInactiveMinorTickColor =>
      colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get tooltipBackgroundColor =>
      colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(97, 97, 97, 1)
          : const Color.fromRGBO(224, 224, 224, 1);
}

///SfSLiderThemeData gives the color to [SfSlider]
///when useMaterial 3 is true
///It gets the [context] as parameter in constructors
///[SfSliderThemeDataM3] override the properties
///[SfSliderThemeDataM3] get the color of properties.
///
///return SfSliderThemeData() as SfSliderThemeDataM3;

class SfSliderThemeDataM3 extends SfSliderThemeData {
  ///context is parameter of the constructor.
  SfSliderThemeDataM3(this.context);

  ///context refers to the current state of the widget.
  final BuildContext context;

  ///Theme.of(context) retrives the ThemeData
  ///[colorScheme] is a variable along with
  /// late and final keyword to obtain the theme of the context
  /// from [ColorScheme].
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get activeTrackColor => colorScheme.primary;

  @override
  Color? get inactiveTrackColor => colorScheme.surfaceVariant;

  @override
  Color? get disabledActiveTrackColor => colorScheme.onSurfaceVariant;

  @override
  Color? get disabledInactiveTrackColor =>
      colorScheme.onSurface.withOpacity(0.12);

  @override
  Color? get disabledThumbColor => Color.alphaBlend(
      colorScheme.onSurface.withOpacity(0.38), colorScheme.surface);

  @override
  Color? get activeTickColor => colorScheme.outlineVariant;

  @override
  Color? get inactiveTickColor => colorScheme.outlineVariant;

  @override
  Color? get activeMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get inactiveMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get thumbColor => colorScheme.primary;

  @override
  Color? get overlayColor => colorScheme.primary.withOpacity(0.08);

  @override
  Color? get activeDividerColor => colorScheme.onPrimary.withOpacity(0.38);

  @override
  Color? get inactiveDividerColor =>
      colorScheme.onSurfaceVariant.withOpacity(0.38);

  @override
  Color? get disabledActiveDividerColor =>
      colorScheme.onSurfaceVariant.withOpacity(0.38);

  @override
  Color? get disabledInactiveDividerColor =>
      colorScheme.onSurfaceVariant.withOpacity(0.38);

  @override
  Color? get disabledActiveTickColor => colorScheme.outlineVariant;

  @override
  Color? get disabledInactiveTickColor => colorScheme.outlineVariant;

  @override
  Color? get disabledActiveMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get disabledInactiveMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get tooltipBackgroundColor => colorScheme.primary;
}

///SfRangeSLiderThemeData gives the color to [SfRangeSlider]
///when useMaterial 3 is false
///It gets the [context] as parameter in constructors
///[SfRangeSliderThemeDataM2] override the properties
///[SfRangeSliderThemeDataM2] get the color of properties.
///return SfRangeSliderThemeData() as SfRangeSliderThemeDataM2;
class SfRangeSliderThemeDataM2 extends SfRangeSliderThemeData {
  ///context is parameter of the constructor.
  SfRangeSliderThemeDataM2(this.context);

  ///[context] refers to the current state of the widget.
  final BuildContext context;

  ///Theme.of(context) retrives the ThemeData
  ///[colorScheme] is a variable along with
  /// late and final keyword
  /// to obtain the theme of the context from [ColorScheme].
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get activeTrackColor => colorScheme.primary;

  @override
  Color? get inactiveTrackColor => colorScheme.primary.withOpacity(0.24);

  @override
  Color? get disabledActiveTrackColor =>
      colorScheme.onSurface.withOpacity(0.32);

  @override
  Color? get disabledInactiveTrackColor =>
      colorScheme.onSurface.withOpacity(0.12);

  @override
  Color? get thumbColor => colorScheme.primary;

  @override
  Color? get disabledThumbColor => Color.alphaBlend(
      colorScheme.onSurface.withOpacity(0.38), colorScheme.surface);

  @override
  Color? get activeTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get inactiveTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get activeMinorTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get inactiveMinorTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get overlayColor => colorScheme.primary.withOpacity(0.12);

  @override
  Color? get activeDividerColor => colorScheme.onPrimary.withOpacity(0.54);

  @override
  Color? get inactiveDividerColor => colorScheme.primary.withOpacity(0.54);

  @override
  Color? get disabledActiveDividerColor =>
      colorScheme.onPrimary.withOpacity(0.12);

  @override
  Color? get disabledInactiveDividerColor =>
      colorScheme.onSurface.withOpacity(0.12);

  @override
  Color? get disabledActiveTickColor => colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get disabledInactiveTickColor =>
      colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get disabledActiveMinorTickColor =>
      colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get disabledInactiveMinorTickColor =>
      colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get tooltipBackgroundColor =>
      colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(97, 97, 97, 1)
          : const Color.fromRGBO(224, 224, 224, 1);

  @override
  Color? get overlappingTooltipStrokeColor => colorScheme.surface;

  @override
  Color? get overlappingThumbStrokeColor => colorScheme.surface;
}

///SfRangeSLiderThemeData gives the color to [SfRangeSlider]
/// when useMaterial 3 is true
///It gets the [context] as parameter in constructors
///[SfRangeSliderThemeDataM3] override the properties
///[SfRangeSliderThemeDataM3] get the color of properties.
///
///return SfRangeSliderThemeData() as SfRangeSliderThemeDataM3;
class SfRangeSliderThemeDataM3 extends SfRangeSliderThemeData {
  ///context is parameter of the constructor.
  SfRangeSliderThemeDataM3(this.context);

  ///context refers to the current state of the widget.
  final BuildContext context;

  ///Theme.of(context) retrives the ThemeData
  ///[colorScheme] is a variable along with
  /// late and final keyword to obtain the theme of the context
  /// from [ColorScheme].
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get activeTrackColor => colorScheme.primary;

  @override
  Color? get inactiveTrackColor => colorScheme.surfaceVariant;

  @override
  Color? get disabledActiveTrackColor => colorScheme.onSurfaceVariant;

  @override
  Color? get disabledInactiveTrackColor =>
      colorScheme.onSurface.withOpacity(0.12);

  @override
  Color? get disabledThumbColor => Color.alphaBlend(
      colorScheme.onSurface.withOpacity(0.38), colorScheme.surface);

  @override
  Color? get activeTickColor => colorScheme.outlineVariant;

  @override
  Color? get inactiveTickColor => colorScheme.outlineVariant;

  @override
  Color? get activeMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get inactiveMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get thumbColor => colorScheme.primary;

  @override
  Color? get overlayColor => colorScheme.primary.withOpacity(0.08);

  @override
  Color? get activeDividerColor => colorScheme.onPrimary.withOpacity(0.38);

  @override
  Color? get inactiveDividerColor =>
      colorScheme.onSurfaceVariant.withOpacity(0.38);

  @override
  Color? get disabledActiveDividerColor =>
      colorScheme.onSurfaceVariant.withOpacity(0.38);

  @override
  Color? get disabledInactiveDividerColor =>
      colorScheme.onSurfaceVariant.withOpacity(0.38);

  @override
  Color? get disabledActiveTickColor => colorScheme.outlineVariant;

  @override
  Color? get disabledInactiveTickColor => colorScheme.outlineVariant;

  @override
  Color? get disabledActiveMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get disabledInactiveMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get tooltipBackgroundColor => colorScheme.primary;

  @override
  Color? get overlappingTooltipStrokeColor => colorScheme.surface;

  @override
  Color? get overlappingThumbStrokeColor => colorScheme.surface;
}

///SfRangeSelectorThemeData gives the color to [SfRangeSelector]
/// when useMaterial 3 is false
///It gets the [context] as parameter in constructors
///[SfRangeSelectorThemeDataM2] override the properties
///[SfRangeSelectorThemeDataM2] get the color of properties.
///return SfRangeSelectorThemeData() as SfRangeSelectorThemeDataM2;
class SfRangeSelectorThemeDataM2 extends SfRangeSelectorThemeData {
  ///context is parameter of the constructor.
  SfRangeSelectorThemeDataM2(this.context);

  ///[context] refers to the current state of the widget.
  final BuildContext context;

  ///Theme.of(context) retrives the ThemeData
  ///[colorScheme] is a variable along with
  /// late and final keyword
  /// to obtain the theme of the context from [ColorScheme].
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get activeTrackColor => colorScheme.primary;

  @override
  Color? get inactiveTrackColor => colorScheme.primary.withOpacity(0.24);

  @override
  Color? get disabledActiveTrackColor =>
      colorScheme.onSurface.withOpacity(0.32);

  @override
  Color? get disabledInactiveTrackColor =>
      colorScheme.onSurface.withOpacity(0.12);

  @override
  Color? get thumbColor => colorScheme.primary;

  @override
  Color? get disabledThumbColor => Color.alphaBlend(
      colorScheme.onSurface.withOpacity(0.38), colorScheme.surface);

  @override
  Color? get activeTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get inactiveTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get activeMinorTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get inactiveMinorTickColor => colorScheme.onSurface.withOpacity(0.37);

  @override
  Color? get overlayColor => colorScheme.primary.withOpacity(0.12);

  @override
  Color? get activeDividerColor => colorScheme.onPrimary.withOpacity(0.54);

  @override
  Color? get inactiveDividerColor => colorScheme.primary.withOpacity(0.54);

  @override
  Color? get disabledActiveDividerColor =>
      colorScheme.onPrimary.withOpacity(0.12);

  @override
  Color? get disabledInactiveDividerColor =>
      colorScheme.onSurface.withOpacity(0.12);

  @override
  Color? get disabledActiveTickColor => colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get disabledInactiveTickColor =>
      colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get disabledActiveMinorTickColor =>
      colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get disabledInactiveMinorTickColor =>
      colorScheme.onSurface.withOpacity(0.24);

  @override
  Color? get tooltipBackgroundColor =>
      colorScheme.brightness == Brightness.light
          ? const Color.fromRGBO(97, 97, 97, 1)
          : const Color.fromRGBO(224, 224, 224, 1);

  @override
  Color? get activeRegionColor => Colors.transparent;

  @override
  Color? get inactiveRegionColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.75)
      : const Color.fromRGBO(48, 48, 48, 1).withOpacity(0.75);
}

///SfRangeSelectorThemeData gives the color to [SfRangeSelector]
///when useMaterial 3 is true
///It gets the [context] as parameter in constructors
///[SfRangeSelectorThemeDataM3] override the properties
///[SfRangeSelectorThemeDataM3] get the color of properties.
///
///return SfRangeSelectorThemeData() as SfRangeSelectorThemeDataM3;
class SfRangeSelectorThemeDataM3 extends SfRangeSelectorThemeData {
  ///context is parameter of the constructor.
  SfRangeSelectorThemeDataM3(this.context);

  ///context refers to the current state of the widget.
  final BuildContext context;

  ///Theme.of(context) retrives the ThemeData
  ///[colorScheme] is a variable along with
  /// late and final keyword to obtain the theme of the context
  /// from [ColorScheme].
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get activeTrackColor => colorScheme.primary;

  @override
  Color? get inactiveTrackColor => colorScheme.surfaceVariant;

  @override
  Color? get disabledActiveTrackColor => colorScheme.onSurfaceVariant;

  @override
  Color? get disabledInactiveTrackColor =>
      colorScheme.onSurface.withOpacity(0.12);

  @override
  Color? get disabledThumbColor => Color.alphaBlend(
      colorScheme.onSurface.withOpacity(0.38), colorScheme.surface);

  @override
  Color? get activeTickColor => colorScheme.outlineVariant;

  @override
  Color? get inactiveTickColor => colorScheme.outlineVariant;

  @override
  Color? get activeMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get inactiveMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get thumbColor => colorScheme.primary;

  @override
  Color? get overlayColor => colorScheme.primary.withOpacity(0.08);

  @override
  Color? get activeDividerColor => colorScheme.onPrimary.withOpacity(0.38);

  @override
  Color? get inactiveDividerColor =>
      colorScheme.onSurfaceVariant.withOpacity(0.38);

  @override
  Color? get disabledActiveDividerColor =>
      colorScheme.onSurfaceVariant.withOpacity(0.38);

  @override
  Color? get disabledInactiveDividerColor =>
      colorScheme.onSurfaceVariant.withOpacity(0.38);

  @override
  Color? get disabledActiveTickColor => colorScheme.outlineVariant;

  @override
  Color? get disabledInactiveTickColor => colorScheme.outlineVariant;

  @override
  Color? get disabledActiveMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get disabledInactiveMinorTickColor => colorScheme.outlineVariant;

  @override
  Color? get tooltipBackgroundColor => colorScheme.primary;

  @override
  Color? get activeRegionColor => Colors.transparent;

  @override
  Color? get inactiveRegionColor => colorScheme.scrim.withOpacity(0.32);
}
