import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_core/theme.dart';

///SfSlidersThemeData gives the color to [SfSlider]
///It gets the [context] as parameter in constructors
///[SlidersThemeData] override the properties
///[SlidersThemeData] get the color of properties.

class SlidersThemeData extends SfSliderThemeData {
  ///context is parameter of the constructor.
  SlidersThemeData(this.context);

  ///[context] refers to the current state of the widget.
  final BuildContext context;

  ///SfTheme.colorScheme(context) retrives the SfThemeData
  ///[colorScheme] is a variable along with
  /// late and final keyword to obtain the theme of the context
  /// from [SfColorScheme].
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);

  @override
  Color? get activeTrackColor => colorScheme.primary;

  @override
  Color? get inactiveTrackColor => colorScheme.primary[61];

  @override
  Color? get disabledActiveTrackColor => colorScheme.onSurface[82];

  @override
  Color? get disabledInactiveTrackColor => colorScheme.onSurface[31];

  @override
  Color? get thumbColor => colorScheme.primary;

  @override
  Color? get overlayColor => colorScheme.primary[31];

  @override
  Color? get disabledThumbColor =>
      Color.alphaBlend(colorScheme.onSurface[97]!, colorScheme.surface);

  @override
  Color? get activeTickColor => colorScheme.onSurface[94];

  @override
  Color? get inactiveTickColor => colorScheme.onSurface[94];

  @override
  Color? get activeMinorTickColor => colorScheme.onSurface[94];

  @override
  Color? get inactiveMinorTickColor => colorScheme.onSurface[94];

  @override
  Color? get activeDividerColor => colorScheme.onPrimary[138];

  @override
  Color? get inactiveDividerColor => colorScheme.primary[138];

  @override
  Color? get disabledActiveDividerColor => colorScheme.onPrimary[31];

  @override
  Color? get disabledInactiveDividerColor => colorScheme.onPrimary[31];

  @override
  Color? get disabledActiveTickColor => colorScheme.onSurface[61];

  @override
  Color? get disabledInactiveTickColor => colorScheme.onSurface[61];

  @override
  Color? get disabledActiveMinorTickColor => colorScheme.onSurface[61];

  @override
  Color? get disabledInactiveMinorTickColor => colorScheme.onSurface[61];

  @override
  Color? get tooltipBackgroundColor => colorScheme.primary[97];
}

///SfRangeSLiderThemeData gives the color to [SfRangeSlider]
///It gets the [context] as parameter in constructors
///[RangeSliderThemeData] override the properties
///[RangeSliderThemeData] get the color of properties.
///
///return SfRangeSliderThemeData() as RangeSliderThemeData;
class RangeSliderThemeData extends SfRangeSliderThemeData {
  ///context is parameter of the constructor.
  RangeSliderThemeData(this.context);

  ///context refers to the current state of the widget.
  final BuildContext context;

  ///SfTheme.of(context) retrives the SfThemeData
  ///[colorScheme] is a variable along with
  /// late and final keyword to obtain the theme of the context
  /// from [SfColorScheme].
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);

  @override
  Color? get activeTrackColor => colorScheme.primary;

  @override
  Color? get inactiveTrackColor => colorScheme.primary[61];

  @override
  Color? get disabledActiveTrackColor => colorScheme.onSurface[82];

  @override
  Color? get disabledInactiveTrackColor => colorScheme.onSurface[31];

  @override
  Color? get disabledThumbColor =>
      Color.alphaBlend(colorScheme.onSurface[97]!, colorScheme.surface);

  @override
  Color? get activeTickColor => colorScheme.onSurface[94];

  @override
  Color? get inactiveTickColor => colorScheme.onSurface[94];

  @override
  Color? get activeMinorTickColor => colorScheme.onSurface[94];

  @override
  Color? get inactiveMinorTickColor => colorScheme.onSurface[94];

  @override
  Color? get thumbColor => colorScheme.primary;

  @override
  Color? get overlayColor => colorScheme.primary[31];

  @override
  Color? get activeDividerColor => colorScheme.onPrimary[138];

  @override
  Color? get inactiveDividerColor => colorScheme.primary[138];

  @override
  Color? get disabledActiveDividerColor => colorScheme.onPrimary[31];

  @override
  Color? get disabledInactiveDividerColor => colorScheme.onPrimary[31];

  @override
  Color? get disabledActiveTickColor => colorScheme.onSurface[61];

  @override
  Color? get disabledInactiveTickColor => colorScheme.onSurface[61];

  @override
  Color? get disabledActiveMinorTickColor => colorScheme.onSurface[61];

  @override
  Color? get disabledInactiveMinorTickColor => colorScheme.onSurface[61];

  @override
  Color? get tooltipBackgroundColor => colorScheme.primary[97];

  @override
  Color? get overlappingTooltipStrokeColor => colorScheme.surface;

  @override
  Color? get overlappingThumbStrokeColor => colorScheme.surface;
}

///SfRangeSelectorThemeData gives the color to [SfRangeSelector]
///It gets the [context] as parameter in constructors
///[RangeSelectorThemeData] override the properties
///[RangeSelectorThemeData] get the color of properties.
///
///return SfRangeSelectorThemeData() as RangeSelectorThemeData.
class RangeSelectorThemeData extends SfRangeSelectorThemeData {
  ///context is parameter of the constructor.
  RangeSelectorThemeData(this.context);

  ///context refers to the current state of the widget.
  final BuildContext context;

  ///SfTheme.of(context) retrives the SfThemeData
  ///[colorScheme] is a variable along with
  /// late and final keyword to obtain the theme of the context
  /// from [SfColorScheme].
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);

  @override
  Color? get activeTrackColor => colorScheme.primary;

  @override
  Color? get inactiveTrackColor => colorScheme.primary[61];

  @override
  Color? get disabledActiveTrackColor => colorScheme.onSurface[82];

  @override
  Color? get disabledInactiveTrackColor => colorScheme.onSurface[31];

  @override
  Color? get disabledThumbColor =>
      Color.alphaBlend(colorScheme.onSurface[97]!, colorScheme.surface);

  @override
  Color? get activeTickColor => colorScheme.onSurface[94];

  @override
  Color? get inactiveTickColor => colorScheme.onSurface[94];

  @override
  Color? get activeMinorTickColor => colorScheme.onSurface[94];

  @override
  Color? get inactiveMinorTickColor => colorScheme.onSurface[94];

  @override
  Color? get thumbColor => colorScheme.primary;

  @override
  Color? get overlayColor => colorScheme.primary[31];

  @override
  Color? get activeDividerColor => colorScheme.onPrimary[138];

  @override
  Color? get inactiveDividerColor => colorScheme.primary[138];

  @override
  Color? get disabledActiveDividerColor => colorScheme.onPrimary[31];

  @override
  Color? get disabledInactiveDividerColor => colorScheme.onPrimary[31];

  @override
  Color? get disabledActiveTickColor => colorScheme.onSurface[61];

  @override
  Color? get disabledInactiveTickColor => colorScheme.onSurface[61];

  @override
  Color? get disabledActiveMinorTickColor => colorScheme.onSurface[61];

  @override
  Color? get disabledInactiveMinorTickColor => colorScheme.onSurface[61];

  @override
  Color? get tooltipBackgroundColor => colorScheme.primary[97];

  @override
  Color? get activeRegionColor => Colors.transparent;

  @override
  Color? get inactiveRegionColor => colorScheme.scrim[82];
}
