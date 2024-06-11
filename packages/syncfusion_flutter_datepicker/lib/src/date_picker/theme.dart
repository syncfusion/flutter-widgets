import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// [SfDateRangePickerThemeDataKey] this class provides material2 and material3
///  themeData.
/// SfDateRangePickerThemeDataKey class extends the 'SfDateRangePickerThemeData'
/// class and customize the appearance of a mapping component based on th color
/// scheme obtained from the provided [BuildContext].
class SfDateRangePickerThemeKey extends SfDateRangePickerThemeData {
  /// This a constructor that takes a [BuildContext] as a parameter.This context
  /// is used for obtaining the color scheme of the current theme.
  SfDateRangePickerThemeKey(this.context);

  /// Property that stores the provided [BuildContext]
  /// context is later used to obtain the color scheme.
  final BuildContext context;

  /// A late-initialized property representing the color scheme obtained from
  /// the current theme using the provided [BuildContext]
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);

  @override
  Color? get backgroundColor => Theme.of(context).useMaterial3
      ? (Theme.of(context).brightness == Brightness.light
          ? const Color.fromRGBO(238, 232, 244, 1)
          : const Color.fromRGBO(48, 45, 56, 1))
      : Colors.transparent;

  @override
  Color? get headerBackgroundColor => Theme.of(context).useMaterial3
      ? (Theme.of(context).brightness == Brightness.light
          ? const Color.fromRGBO(238, 232, 244, 1)
          : const Color.fromRGBO(48, 45, 56, 1))
      : Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.grey[850];

  @override
  Color? get viewHeaderBackgroundColor => colorScheme.transparent;

  @override
  Color? get weekNumberBackgroundColor => colorScheme.onSurface[22];

  @override
  Color? get selectionColor => colorScheme.primary;

  @override
  Color? get startRangeSelectionColor => colorScheme.primary;

  @override
  Color? get rangeSelectionColor => colorScheme.primary[30];

  @override
  Color? get endRangeSelectionColor => colorScheme.primary;

  @override
  Color? get todayHighlightColor => colorScheme.primary;
}
