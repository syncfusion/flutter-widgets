import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant Syncfusion calendar widgets.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfCalendarTheme(
///       data: SfCalendarThemeData(
///         brightness: Brightness.dark,
///         backgroundColor: Colors.grey
///       ),
///       child: SfCalendar()
///     ),
///   );
/// }
/// ```
class SfCalendarTheme extends InheritedTheme {
  /// Constructor for the calendar theme class, which applies a theme to
  /// descendant Syncfusion calendar widgets.
  const SfCalendarTheme({Key? key, required this.data, required this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant calendar widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendarTheme(
  ///       data: SfCalendarThemeData(
  ///         brightness: Brightness.dark,
  ///         backgroundColor: Colors.grey
  ///       ),
  ///       child: SfCalendar()
  ///     ),
  ///   );
  /// }
  /// ```
  final SfCalendarThemeData data;

  /// Specifies a widget that can hold single child.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendarTheme(
  ///       data: SfCalendarThemeData(
  ///         brightness: Brightness.dark,
  ///         backgroundColor: Colors.grey
  ///       ),
  ///       child: SfCalendar()
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Widget child;

  /// The data from the closest [SfCalendarTheme]
  /// instance that encloses the given context.
  ///
  /// Defaults to [SfThemeData.calendarThemeData]
  /// if there is no [SfCalendarTheme] in the given build context.
  static SfCalendarThemeData of(BuildContext context) {
    final SfCalendarTheme? sfCalendarTheme =
        context.dependOnInheritedWidgetOfExactType<SfCalendarTheme>();
    return sfCalendarTheme?.data ?? SfTheme.of(context).calendarThemeData;
  }

  @override
  bool updateShouldNotify(SfCalendarTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfCalendarTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfCalendarTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfCalendarTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfCalendarTheme]. Use
///  this class to configure a [SfCalendarTheme] widget
///
/// To obtain the current theme, use [SfCalendarTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfCalendarTheme(
///       data: SfCalendarThemeData(
///         brightness: Brightness.dark,
///         backgroundColor: Colors.grey
///       ),
///       child: SfCalendar()
///     ),
///   );
/// }
/// ```
class SfCalendarThemeData with Diagnosticable {
  /// Create a [SfCalendarThemeData] that's used to configure a
  /// [SfCalendarTheme].
  factory SfCalendarThemeData({
    Brightness? brightness,
    Color? backgroundColor,
    Color? headerBackgroundColor,
    Color? agendaBackgroundColor,
    Color? cellBorderColor,
    Color? activeDatesBackgroundColor,
    Color? todayBackgroundColor,
    Color? trailingDatesBackgroundColor,
    Color? leadingDatesBackgroundColor,
    Color? selectionBorderColor,
    Color? todayHighlightColor,
    Color? viewHeaderBackgroundColor,
    TextStyle? todayTextStyle,
    TextStyle? agendaDayTextStyle,
    TextStyle? agendaDateTextStyle,
    TextStyle? headerTextStyle,
    TextStyle? viewHeaderDateTextStyle,
    TextStyle? viewHeaderDayTextStyle,
    TextStyle? timeTextStyle,
    TextStyle? activeDatesTextStyle,
    TextStyle? trailingDatesTextStyle,
    TextStyle? leadingDatesTextStyle,
    TextStyle? blackoutDatesTextStyle,
    TextStyle? displayNameTextStyle,
  }) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;
    backgroundColor ??= isLight ? Colors.white : Colors.transparent;
    headerBackgroundColor ??= Colors.transparent;
    agendaBackgroundColor ??= Colors.transparent;
    agendaDayTextStyle ??= isLight
        ? TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            fontFamily: 'Roboto')
        : TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            fontFamily: 'Roboto');
    agendaDateTextStyle ??= isLight
        ? TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal)
        : TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal);
    activeDatesBackgroundColor ??= Colors.transparent;
    todayBackgroundColor ??= Colors.transparent;
    trailingDatesBackgroundColor ??= Colors.transparent;
    leadingDatesBackgroundColor ??= Colors.transparent;
    viewHeaderBackgroundColor ??= Colors.transparent;
    cellBorderColor ??=
        isLight ? Colors.black.withOpacity(0.16) : Colors.white30;
    todayTextStyle ??= isLight
        ? TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.black, fontSize: 13, fontFamily: 'Roboto');
    headerTextStyle ??= isLight
        ? const TextStyle(
            color: Colors.black87, fontSize: 18, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Roboto');
    activeDatesTextStyle ??= isLight
        ? const TextStyle(
            color: Colors.black87, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Roboto');
    timeTextStyle ??= isLight
        ? TextStyle(
            color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 10)
        : TextStyle(
            color: Colors.white38, fontWeight: FontWeight.w500, fontSize: 10);
    viewHeaderDateTextStyle ??= isLight
        ? const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto')
        : TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto');
    viewHeaderDayTextStyle ??= isLight
        ? const TextStyle(
            color: Colors.black87,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto')
        : TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto');
    trailingDatesTextStyle ??= isLight
        ? TextStyle(color: Colors.black54, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Roboto');
    leadingDatesTextStyle ??= isLight
        ? TextStyle(color: Colors.black54, fontSize: 13, fontFamily: 'Roboto')
        : TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Roboto');
    displayNameTextStyle ??= isLight
        ? TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto')
        : TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto');

    return SfCalendarThemeData.raw(
      brightness: brightness,
      backgroundColor: backgroundColor,
      headerTextStyle: headerTextStyle,
      headerBackgroundColor: headerBackgroundColor,
      agendaBackgroundColor: agendaBackgroundColor,
      viewHeaderDateTextStyle: viewHeaderDateTextStyle,
      viewHeaderDayTextStyle: viewHeaderDayTextStyle,
      agendaDayTextStyle: agendaDayTextStyle,
      agendaDateTextStyle: agendaDateTextStyle,
      cellBorderColor: cellBorderColor,
      timeTextStyle: timeTextStyle,
      activeDatesTextStyle: activeDatesTextStyle,
      activeDatesBackgroundColor: activeDatesBackgroundColor,
      todayBackgroundColor: todayBackgroundColor,
      trailingDatesBackgroundColor: trailingDatesBackgroundColor,
      leadingDatesBackgroundColor: leadingDatesBackgroundColor,
      trailingDatesTextStyle: trailingDatesTextStyle,
      blackoutDatesTextStyle: blackoutDatesTextStyle,
      displayNameTextStyle: displayNameTextStyle,
      leadingDatesTextStyle: leadingDatesTextStyle,
      todayTextStyle: todayTextStyle,
      todayHighlightColor: todayHighlightColor,
      viewHeaderBackgroundColor: viewHeaderBackgroundColor,
      selectionBorderColor: selectionBorderColor,
    );
  }

  /// Create a [SfCalendarThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfCalendarThemeData] constructor.
  const SfCalendarThemeData.raw({
    required this.brightness,
    required this.backgroundColor,
    required this.headerTextStyle,
    required this.headerBackgroundColor,
    required this.agendaBackgroundColor,
    required this.cellBorderColor,
    required this.viewHeaderDateTextStyle,
    required this.viewHeaderDayTextStyle,
    required this.viewHeaderBackgroundColor,
    required this.agendaDayTextStyle,
    required this.agendaDateTextStyle,
    required this.timeTextStyle,
    required this.activeDatesTextStyle,
    required this.activeDatesBackgroundColor,
    required this.todayBackgroundColor,
    required this.trailingDatesBackgroundColor,
    required this.leadingDatesBackgroundColor,
    required this.trailingDatesTextStyle,
    required this.blackoutDatesTextStyle,
    required this.displayNameTextStyle,
    required this.leadingDatesTextStyle,
    required this.todayTextStyle,
    required this.todayHighlightColor,
    required this.selectionBorderColor,
  });

  /// The brightness of the overall theme of the
  /// application for the calendar widgets.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).brightness], brightness for
  /// calendar widgets will be applied.
  ///
  /// Also refer [Brightness].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              brightness: Brightness.light
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Brightness brightness;

  /// Specifies the background color of calendar widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              backgroundColor: Colors.grey
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color backgroundColor;

  /// Specifies the calendar header text style.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              headerTextStyle: TextStyle(color: Colors.purple)
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle headerTextStyle;

  ///Specifies the cell border color of calendar widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              cellBorderColor: Colors.pink
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color cellBorderColor;

  ///Specifies the calendar Header background color.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              headerBackgroundColor: Colors.brown
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color headerBackgroundColor;

  ///Specifies the border color the default BoxDecoration , border color.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              selectionBorderColor: Colors.black
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///  );
  ///}
  /// ```
  final Color? selectionBorderColor;

  ///Specifies the agenda view background color.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              agendaBackgroundColor: Colors.red
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color agendaBackgroundColor;

  ///Specifies the agenda view background color.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              viewHeaderBackgroundColor: Colors.blueGrey
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color viewHeaderBackgroundColor;

  /// Specifies the day text style for the view header.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              viewHeaderDayTextStyle: TextStyle(decoration:
  ///                TextDecoration.lineThrough)
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle viewHeaderDayTextStyle;

  /// Specifies the agenda view day text style.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              agendaDayTextStyle: TextStyle(color: Colors.teal)
  ///            )
  ///           ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle agendaDayTextStyle;

  /// Specifies the agenda view date text style.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              agendaDateTextStyle: TextStyle(backgroundColor:
  ///                Colors.yellow)
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle agendaDateTextStyle;

  /// Specifies the background color for the current month cells.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              activeDatesBackgroundColor: Colors.green
  ///            )
  ///           ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color activeDatesBackgroundColor;

  ///Specifies the background for the today month cell.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              todayBackgroundColor: Colors.tealAccent
  ///            )
  ///          ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color todayBackgroundColor;

  ///Specifies the background for the trailing dates month cells.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              trailingDatesBackgroundColor: Colors.yellow
  ///            )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color trailingDatesBackgroundColor;

  ///Specifies the background for the leading dates month cells.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              leadingDatesBackgroundColor: Colors.deepPurpleAccent
  ///            )
  ///          ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color leadingDatesBackgroundColor;

  /// Specifies the text style for the leading month cell dates.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              leadingDatesTextStyle: TextStyle(decoration:
  ///                TextDecoration.lineThrough, color: Colors.green)
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle leadingDatesTextStyle;

  /// Specifies the text style for the blackout dates text in calendar.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              blackoutDatesTextStyle: TextStyle(decoration:
  ///                TextDecoration.lineThrough, color: Colors.green)
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle? blackoutDatesTextStyle;

  /// Specifies the text style for the text in the resource view of calendar.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              displayNameTextStyle: TextStyle( color:Colors.red,
  ///                fontSize: 10,
  ///                fontWeight: FontWeight.w500,
  ///                fontFamily: 'Roboto')
  ///              )
  ///            ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle displayNameTextStyle;

  /// Specifies the text style for the today month cell.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              todayTextStyle: TextStyle(color: Colors.pink)
  ///            )
  ///          ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle todayTextStyle;

  ///Specifies the today highlight color.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              todayHighlightColor: Colors.limeAccent
  ///            )
  ///          ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color? todayHighlightColor;

  /// Specifies the date text style for the view header.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              viewHeaderDateTextStyle: TextStyle(decoration:
  ///                TextDecoration.underline,color: Colors.red)
  ///            )
  ///          ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle viewHeaderDateTextStyle;

  /// Specifies the time label text style in days and timeline views.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              timeTextStyle: TextStyle(color:Colors.green)
  ///            )
  ///          ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle timeTextStyle;

  ///Specifies the current month text style color of calendar widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              activeDatesTextStyle: TextStyle(decoration:
  ///                TextDecoration.lineThrough,color: Colors.red)
  ///            )
  ///          ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle activeDatesTextStyle;

  /// Specifies the text style for the trailing month cell dates.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData(
  ///              trailingDatesTextStyle: TextStyle(decoration:
  ///                TextDecoration.lineThrough,color: Colors.amber)
  ///            )
  ///          ),
  ///          child: SfCalendar(),
  ///          ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle trailingDatesTextStyle;

  /// Creates a copy of this theme but with the given
  /// fields replaced with the new values.
  SfCalendarThemeData copyWith({
    Brightness? brightness,
    Color? backgroundColor,
    TextStyle? headerTextStyle,
    Color? headerBackgroundColor,
    Color? agendaBackgroundColor,
    Color? cellBorderColor,
    TextStyle? viewHeaderDateTextStyle,
    TextStyle? viewHeaderDayTextStyle,
    TextStyle? agendaDayTextStyle,
    TextStyle? agendaDateTextStyle,
    TextStyle? timeTextStyle,
    TextStyle? activeDatesTextStyle,
    Color? activeDatesBackgroundColor,
    Color? todayBackgroundColor,
    Color? trailingDatesBackgroundColor,
    Color? leadingDatesBackgroundColor,
    TextStyle? trailingDatesTextStyle,
    TextStyle? blackoutDatesTextStyle,
    TextStyle? displayNameTextStyle,
    TextStyle? leadingDatesTextStyle,
    TextStyle? todayTextStyle,
    Color? todayHighlightColor,
    Color? viewHeaderBackgroundColor,
    Color? selectionBorderColor,
  }) {
    return SfCalendarThemeData.raw(
      brightness: brightness ?? this.brightness,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      agendaBackgroundColor:
          agendaBackgroundColor ?? this.agendaBackgroundColor,
      cellBorderColor: cellBorderColor ?? this.cellBorderColor,
      viewHeaderDateTextStyle:
          viewHeaderDateTextStyle ?? this.viewHeaderDateTextStyle,
      viewHeaderDayTextStyle:
          viewHeaderDayTextStyle ?? this.viewHeaderDayTextStyle,
      agendaDayTextStyle: agendaDayTextStyle ?? this.agendaDayTextStyle,
      agendaDateTextStyle: agendaDateTextStyle ?? this.agendaDateTextStyle,
      timeTextStyle: timeTextStyle ?? this.timeTextStyle,
      activeDatesTextStyle: activeDatesTextStyle ?? this.activeDatesTextStyle,
      activeDatesBackgroundColor:
          activeDatesBackgroundColor ?? this.activeDatesBackgroundColor,
      todayBackgroundColor: todayBackgroundColor ?? this.todayBackgroundColor,
      trailingDatesBackgroundColor:
          trailingDatesBackgroundColor ?? this.trailingDatesBackgroundColor,
      leadingDatesBackgroundColor:
          leadingDatesBackgroundColor ?? this.leadingDatesBackgroundColor,
      trailingDatesTextStyle:
          trailingDatesTextStyle ?? this.trailingDatesTextStyle,
      blackoutDatesTextStyle:
          blackoutDatesTextStyle ?? this.blackoutDatesTextStyle,
      displayNameTextStyle: displayNameTextStyle ?? this.displayNameTextStyle,
      leadingDatesTextStyle:
          leadingDatesTextStyle ?? this.leadingDatesTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      todayHighlightColor: todayHighlightColor ?? this.todayHighlightColor,
      viewHeaderBackgroundColor:
          viewHeaderBackgroundColor ?? this.viewHeaderBackgroundColor,
      selectionBorderColor: selectionBorderColor ?? this.selectionBorderColor,
    );
  }

  /// Linearly interpolate between two themes.
  static SfCalendarThemeData? lerp(
      SfCalendarThemeData? a, SfCalendarThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfCalendarThemeData(
        backgroundColor: Color.lerp(a!.backgroundColor, b!.backgroundColor, t),
        headerBackgroundColor:
            Color.lerp(a.headerBackgroundColor, b.headerBackgroundColor, t),
        agendaBackgroundColor:
            Color.lerp(a.agendaBackgroundColor, b.agendaBackgroundColor, t),
        cellBorderColor: Color.lerp(a.cellBorderColor, b.cellBorderColor, t),
        selectionBorderColor:
            Color.lerp(a.selectionBorderColor, b.selectionBorderColor, t),
        activeDatesBackgroundColor: Color.lerp(
            a.activeDatesBackgroundColor, b.activeDatesBackgroundColor, t),
        todayBackgroundColor:
            Color.lerp(a.todayBackgroundColor, b.todayBackgroundColor, t),
        trailingDatesBackgroundColor: Color.lerp(
            a.trailingDatesBackgroundColor, b.trailingDatesBackgroundColor, t),
        leadingDatesBackgroundColor: Color.lerp(
            a.leadingDatesBackgroundColor, b.leadingDatesBackgroundColor, t),
        todayHighlightColor:
            Color.lerp(a.todayHighlightColor, b.todayHighlightColor, t),
        viewHeaderBackgroundColor: Color.lerp(
            a.viewHeaderBackgroundColor, b.viewHeaderBackgroundColor, t));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SfCalendarThemeData &&
        other.backgroundColor == backgroundColor &&
        other.headerTextStyle == headerTextStyle &&
        other.headerBackgroundColor == headerBackgroundColor &&
        other.agendaBackgroundColor == agendaBackgroundColor &&
        other.cellBorderColor == cellBorderColor &&
        other.viewHeaderDateTextStyle == viewHeaderDateTextStyle &&
        other.viewHeaderDayTextStyle == viewHeaderDayTextStyle &&
        other.agendaDayTextStyle == agendaDayTextStyle &&
        other.agendaDateTextStyle == agendaDateTextStyle &&
        other.timeTextStyle == timeTextStyle &&
        other.activeDatesTextStyle == activeDatesTextStyle &&
        other.activeDatesBackgroundColor == activeDatesBackgroundColor &&
        other.todayBackgroundColor == todayBackgroundColor &&
        other.trailingDatesBackgroundColor == trailingDatesBackgroundColor &&
        other.leadingDatesBackgroundColor == leadingDatesBackgroundColor &&
        other.trailingDatesTextStyle == trailingDatesTextStyle &&
        other.blackoutDatesTextStyle == blackoutDatesTextStyle &&
        other.leadingDatesTextStyle == leadingDatesTextStyle &&
        other.todayTextStyle == todayTextStyle &&
        other.todayHighlightColor == todayHighlightColor &&
        other.viewHeaderBackgroundColor == viewHeaderBackgroundColor &&
        other.selectionBorderColor == selectionBorderColor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      backgroundColor,
      headerTextStyle,
      headerBackgroundColor,
      agendaBackgroundColor,
      cellBorderColor,
      viewHeaderDateTextStyle,
      viewHeaderDayTextStyle,
      agendaDayTextStyle,
      agendaDateTextStyle,
      timeTextStyle,
      activeDatesTextStyle,
      activeDatesBackgroundColor,
      todayBackgroundColor,
      trailingDatesBackgroundColor,
      leadingDatesBackgroundColor,
      trailingDatesTextStyle,
      blackoutDatesTextStyle,
      leadingDatesTextStyle,
      todayTextStyle,
      todayHighlightColor,
      viewHeaderBackgroundColor,
      selectionBorderColor,
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfCalendarThemeData defaultData = SfCalendarThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(ColorProperty('backgroundColor', backgroundColor,
        defaultValue: defaultData.backgroundColor));
    properties.add(ColorProperty('headerBackgroundColor', headerBackgroundColor,
        defaultValue: defaultData.headerBackgroundColor));
    properties.add(ColorProperty('agendaBackgroundColor', agendaBackgroundColor,
        defaultValue: defaultData.agendaBackgroundColor));
    properties.add(ColorProperty('cellBorderColor', cellBorderColor,
        defaultValue: defaultData.cellBorderColor));
    properties.add(ColorProperty(
        'activeDatesBackgroundColor', activeDatesBackgroundColor,
        defaultValue: defaultData.activeDatesBackgroundColor));
    properties.add(ColorProperty('todayBackgroundColor', todayBackgroundColor,
        defaultValue: defaultData.todayBackgroundColor));
    properties.add(ColorProperty(
        'trailingDatesBackgroundColor', trailingDatesBackgroundColor,
        defaultValue: defaultData.trailingDatesBackgroundColor));
    properties.add(ColorProperty(
        'leadingDatesBackgroundColor', leadingDatesBackgroundColor,
        defaultValue: defaultData.leadingDatesBackgroundColor));
    properties.add(ColorProperty('todayHighlightColor', todayHighlightColor,
        defaultValue: defaultData.todayHighlightColor));
    properties.add(ColorProperty(
        'viewHeaderBackgroundColor', viewHeaderBackgroundColor,
        defaultValue: defaultData.viewHeaderBackgroundColor));
    properties.add(ColorProperty('selectionBorderColor', selectionBorderColor,
        defaultValue: defaultData.selectionBorderColor));
  }
}
