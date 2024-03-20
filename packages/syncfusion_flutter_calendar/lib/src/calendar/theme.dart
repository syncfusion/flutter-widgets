import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// [SfCalendarThemeDataM2] this class provides material2 themeData.
/// SfCalendarThemeDataM2 class extends the 'SfCalendarThemeData' class and
/// customize the appearance of a mapping component based on th color scheme
/// obtained from the provided [BuildContext].
class SfCalendarThemeDataM2 extends SfCalendarThemeData {
  /// This a constructor that takes a [BuildContext] as a parameter.This context
  /// is used for obtaining the color scheme of the current theme.
  SfCalendarThemeDataM2(this.context);

  /// Property that stores the provided [BuildContext]
  /// context is later used to obtain the color scheme.
  final BuildContext context;

  /// A late-initialized property representing the color scheme obtained from
  /// the current theme using the provided [BuildContext]
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Color? get backgroundColor => Colors.transparent;

  @override
  Color? get headerBackgroundColor => Colors.transparent;

  @override
  Color? get agendaBackgroundColor => Colors.transparent;

  @override
  Color? get activeDatesBackgroundColor => Colors.transparent;

  @override
  Color? get todayBackgroundColor => Colors.transparent;

  @override
  Color? get trailingDatesBackgroundColor => Colors.transparent;

  @override
  Color? get leadingDatesBackgroundColor => Colors.transparent;

  @override
  Color? get viewHeaderBackgroundColor => Colors.transparent;

  @override
  Color? get allDayPanelColor => Colors.transparent;

  @override
  Color? get weekNumberBackgroundColor =>
      colorScheme.onSurface.withOpacity(0.04);

  @override
  Color? get cellBorderColor => colorScheme.onSurface.withOpacity(0.16);

  @override
  Color? get todayHighlightColor => colorScheme.primary;

  @override
  Color? get selectionBorderColor => colorScheme.primary;
}

/// [SfCalendarThemeDataM3] this class provides material3 themeData.
/// SfCalendarThemeDataM3 class extends the 'SfCalendarThemeData' class and
/// customize the appearance of a mapping component based on th color scheme
/// obtained from the provided [BuildContext].
class SfCalendarThemeDataM3 extends SfCalendarThemeData {
  /// This a constructor that takes a [BuildContext] as a parameter.This context
  /// is used for obtaining the color scheme of the current theme.
  SfCalendarThemeDataM3(this.context);

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
      ? const Color.fromRGBO(247, 242, 251, 1)
      : const Color.fromRGBO(37, 35, 42, 1);

  @override
  Color? get agendaBackgroundColor => Colors.transparent;

  @override
  Color? get activeDatesBackgroundColor => Colors.transparent;

  @override
  Color? get todayBackgroundColor => Colors.transparent;

  @override
  Color? get trailingDatesBackgroundColor => Colors.transparent;

  @override
  Color? get leadingDatesBackgroundColor => Colors.transparent;

  @override
  Color? get viewHeaderBackgroundColor => Colors.transparent;

  @override
  Color? get allDayPanelColor => Colors.transparent;

  @override
  Color? get weekNumberBackgroundColor =>
      colorScheme.onSurface.withOpacity(0.04);

  @override
  Color? get cellBorderColor => colorScheme.outlineVariant;

  @override
  Color? get todayHighlightColor => colorScheme.primary;

  @override
  Color? get selectionBorderColor => colorScheme.primary;
}
