import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// [SfCalendarThemeColors] this class provides material 2
///  and material 3 themeData.
/// SfCalendarThemeColors class extends the 'SfCalendarThemeData' class and
/// customize the appearance of a mapping component based on th color scheme
/// obtained from the provided [BuildContext].
class SfCalendarThemeColors extends SfCalendarThemeData {
  /// This a constructor that takes a [BuildContext] as a parameter.This context
  /// is used for obtaining the color scheme of the current theme.
  SfCalendarThemeColors(
    this.context,
  );

  /// Property that stores the provided [BuildContext]
  /// context is later used to obtain the color scheme.
  final BuildContext context;

  /// A late-initialized property representing the color scheme obtained from
  /// the current theme using the provided [BuildContext]
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);
  @override
  Color? get backgroundColor => Colors.transparent;

  @override
  Color? get headerBackgroundColor => Theme.of(context).useMaterial3
      ? (Theme.of(context).brightness == Brightness.light
          ? const Color.fromRGBO(247, 242, 251, 1)
          : const Color.fromRGBO(37, 35, 42, 1))
      : Colors.transparent;

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
  Color? get weekNumberBackgroundColor => colorScheme.onSurface[11];

  @override
  Color? get cellBorderColor => colorScheme.onSurface[42];

  @override
  Color? get todayHighlightColor => colorScheme.primary;

  @override
  Color? get selectionBorderColor => colorScheme.primary;
}
