import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// [SfDateRangePickerThemeDataM2] this class provides material2 themeData.
/// SfDateRangePickerThemeDataM2 class extends the 'SfDateRangePickerThemeData'
/// class and customize the appearance of a mapping component based on th color
/// scheme obtained from the provided [BuildContext].
class SfDateRangePickerThemeDataM2 extends SfDateRangePickerThemeData {
  /// This a constructor that takes a [BuildContext] as a parameter.This context
  /// is used for obtaining the color scheme of the current theme.
  SfDateRangePickerThemeDataM2(this.context);

  /// Property that stores the provided [BuildContext]
  /// context is later used to obtain the color scheme.
  final BuildContext context;

  /// A late-initialized property representing the color scheme obtained from
  /// the current theme using the provided [BuildContext]
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get backgroundColor => Colors.transparent;

  @override
  Color? get headerBackgroundColor => colorScheme.brightness == Brightness.light
      ? Colors.white
      : Colors.grey[850];

  @override
  Color? get viewHeaderBackgroundColor => Colors.transparent;

  @override
  Color? get weekNumberBackgroundColor =>
      colorScheme.onSurface.withOpacity(0.08);

  @override
  Color? get selectionColor => colorScheme.primary;

  @override
  Color? get startRangeSelectionColor => colorScheme.primary;

  @override
  Color? get rangeSelectionColor => colorScheme.primary.withOpacity(0.1);

  @override
  Color? get endRangeSelectionColor => colorScheme.primary;

  @override
  Color? get todayHighlightColor => colorScheme.primary;
}

/// [SfDateRangePickerThemeDataM3] this class provides material3 themeData.
/// SfDateRangePickerThemeDataM3 class extends the 'SfDateRangePickerThemeData'
/// class and customize the appearance of a mapping component based on th color
/// scheme obtained from the provided [BuildContext].
class SfDateRangePickerThemeDataM3 extends SfDateRangePickerThemeData {
  /// This a constructor that takes a [BuildContext] as a parameter.This context
  /// is used for obtaining the color scheme of the current theme.
  SfDateRangePickerThemeDataM3(this.context);

  /// Property that stores the provided [BuildContext]
  /// context is later used to obtain the color scheme.
  final BuildContext context;

  /// A late-initialized property representing the color scheme obtained from
  /// the current theme using the provided [BuildContext]
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get backgroundColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(238, 232, 244, 1)
      : const Color.fromRGBO(48, 45, 56, 1);

  @override
  Color? get headerBackgroundColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(238, 232, 244, 1)
      : const Color.fromRGBO(48, 45, 56, 1);

  @override
  Color? get viewHeaderBackgroundColor => Colors.transparent;

  @override
  Color? get weekNumberBackgroundColor => colorScheme.surfaceVariant;

  @override
  Color? get selectionColor => colorScheme.primary;

  @override
  Color? get startRangeSelectionColor => colorScheme.primary;

  @override
  Color? get rangeSelectionColor => colorScheme.primary.withOpacity(0.12);

  @override
  Color? get endRangeSelectionColor => colorScheme.primary;

  @override
  Color? get todayHighlightColor => colorScheme.primary;
}
