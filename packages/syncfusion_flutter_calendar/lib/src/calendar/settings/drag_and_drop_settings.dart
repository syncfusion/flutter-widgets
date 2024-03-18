import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The settings have properties which allow to customize the drag and drop
/// environment of the [SfCalendar].
///
/// Allows to customize the [allowNavigation], [allowScroll],
/// [autoNavigateDelay], [indicatorTimeFormat], [showTimeIndicator]
/// and [timeIndicatorStyle] in the [SfCalendar].
///
/// See also:
/// * [monthViewSettings], which allows to customize the month view of
/// the calendar.
/// * [timeSlotViewSettings], which allows to customize the timeslot view
/// of the calendar.
///
/// ``` dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfCalendar(
///       view: CalendarView.month,
///       showWeekNumber: true,
///       allowDragAndDrop: true,
///       dragAndDropSettings: DragAndDropSettings(
///         allowNavigation: true,
///         allowScroll: true,
///         autoNavigateDelay: Duration(seconds: 1),
///         indicatorTimeFormat: 'HH:mm a',
///         showTimeIndicator: true,
///         timeIndicatorStyle: TextStyle(color: Colors.cyan),
///       ),
///     ),
///   );
/// }
@immutable
class DragAndDropSettings with Diagnosticable {
  /// Creates a Drag and Drop settings for calendar.
  ///
  /// The properties allows to customize the Drag and Drop of [SfCalendar].
  const DragAndDropSettings({
    this.allowNavigation = true,
    this.allowScroll = true,
    this.showTimeIndicator = true,
    this.timeIndicatorStyle,
    this.indicatorTimeFormat = 'h:mm a',
    this.autoNavigateDelay = const Duration(seconds: 1),
  });

  /// Allows view navigation when the dragging appointment reaches the start or
  /// end position of the view.
  ///
  /// See also:
  /// * [allowScroll], which allows to auto scroll the timeslot views when it
  /// reaches the start or end position of view port.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///       view: CalendarView.month,
  ///       showWeekNumber: true,
  ///       allowDragAndDrop: true,
  ///       dragAndDropSettings: DragAndDropSettings(
  ///         allowNavigation: true,
  ///         allowScroll: true,
  ///         autoNavigateDelay: Duration(seconds: 1),
  ///         indicatorTimeFormat: 'HH:mm a',
  ///         showTimeIndicator: true,
  ///       ),
  ///     ),
  ///   );
  /// }
  final bool allowNavigation;

  /// Allows to scroll the view when the dragging appointment reaches the
  /// view port start or end position in timeslot views.
  ///
  /// See also:
  /// * [allowNavigation], which allows to navigate to next or previous view
  /// when the dragging appointment reaches the start or end position
  /// of the view.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///       view: CalendarView.month,
  ///       showWeekNumber: true,
  ///       allowDragAndDrop: true,
  ///       dragAndDropSettings: DragAndDropSettings(
  ///         allowNavigation: true,
  ///         allowScroll: true,
  ///         autoNavigateDelay: Duration(seconds: 1),
  ///         indicatorTimeFormat: 'HH:mm a',
  ///         showTimeIndicator: true,
  ///       ),
  ///     ),
  ///   );
  /// }
  final bool allowScroll;

  /// Displays the time indicator on the time ruler view.
  ///
  /// The indicator will display the dragging appointment time on the time ruler
  /// view of calendar.
  ///
  /// See also:
  /// * [timeIndicatorStyle], which used to customize the time indicator text.
  /// * [indicatorTimeFormat], which used to format the time indicator text
  /// in calendar.
  ///
  /// Note:
  /// When the [timeSlotViewSettings.timeRulerSize], when this property
  /// set as 0, the time indicator will not displayed even
  /// the [showTimeIndicator] set as true.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///       view: CalendarView.month,
  ///       showWeekNumber: true,
  ///       allowDragAndDrop: true,
  ///       dragAndDropSettings: DragAndDropSettings(
  ///         allowNavigation: true,
  ///         allowScroll: true,
  ///         autoNavigateDelay: Duration(seconds: 1),
  ///         indicatorTimeFormat: 'HH:mm a',
  ///         showTimeIndicator: true,
  ///       ),
  ///     ),
  ///   );
  /// }
  final bool showTimeIndicator;

  /// Allows to set style for the time indicator text.
  ///
  /// See also:
  /// * [showTimeIndicator], which allows to display the time indicator.
  /// * [indicatorTimeFormat], which used to format the time indicator text
  /// in calendar.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///       view: CalendarView.month,
  ///       showWeekNumber: true,
  ///       allowDragAndDrop: true,
  ///       dragAndDropSettings: DragAndDropSettings(
  ///         allowNavigation: true,
  ///         allowScroll: true,
  ///         autoNavigateDelay: Duration(seconds: 1),
  ///         indicatorTimeFormat: 'HH:mm a',
  ///         showTimeIndicator: true,
  ///         timeIndicatorStyle: TextStyle(color: Colors.cyan),
  ///       ),
  ///     ),
  ///   );
  /// }
  final TextStyle? timeIndicatorStyle;

  /// Allows to format the time indicator text.
  ///
  /// See also:
  /// * [showTimeIndicator], which allows to display the time indicator.
  /// * [timeIndicatorStyle], which used to customize the time indicator text.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///       view: CalendarView.month,
  ///       showWeekNumber: true,
  ///       allowDragAndDrop: true,
  ///       dragAndDropSettings: DragAndDropSettings(
  ///         allowNavigation: true,
  ///         allowScroll: true,
  ///         autoNavigateDelay: Duration(seconds: 1),
  ///         indicatorTimeFormat: 'HH:mm a',
  ///         showTimeIndicator: true,
  ///       ),
  ///     ),
  ///   );
  /// }
  final String indicatorTimeFormat;

  ///The delay to hold the appointment on the view start or end position,
  /// to navigate to next or previous view.
  ///
  /// See also:
  /// * [allowViewNavigation], which allows to navigate to next or
  /// previous date when the dragging appointment reaches the start or
  /// end position of the view.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfCalendar(
  ///       view: CalendarView.month,
  ///       showWeekNumber: true,
  ///       allowDragAndDrop: true,
  ///       dragAndDropSettings: DragAndDropSettings(
  ///         allowNavigation: true,
  ///         allowScroll: true,
  ///         autoNavigateDelay: Duration(seconds: 1),
  ///         indicatorTimeFormat: 'HH:mm a',
  ///         showTimeIndicator: true,
  ///       ),
  ///     ),
  ///   );
  /// }
  final Duration autoNavigateDelay;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final DragAndDropSettings otherSetting;
    if (other is DragAndDropSettings) {
      otherSetting = other;
    }
    return otherSetting.allowNavigation == allowNavigation &&
        otherSetting.allowScroll == allowScroll &&
        otherSetting.showTimeIndicator == showTimeIndicator &&
        otherSetting.timeIndicatorStyle == timeIndicatorStyle &&
        otherSetting.indicatorTimeFormat == indicatorTimeFormat &&
        otherSetting.autoNavigateDelay == autoNavigateDelay;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<bool>('allowNavigation', allowNavigation));
    properties.add(DiagnosticsProperty<bool>('allowScroll', allowScroll));
    properties
        .add(DiagnosticsProperty<bool>('showTimeIndicator', showTimeIndicator));
    properties.add(DiagnosticsProperty<TextStyle>(
        'timeIndicatorStyle', timeIndicatorStyle));
    properties.add(DiagnosticsProperty<String>(
        'indicatorTimeFormat', indicatorTimeFormat));
    properties.add(
        DiagnosticsProperty<Duration>('autoNavigateDelay', autoNavigateDelay));
  }

  @override
  int get hashCode {
    return Object.hash(allowNavigation, allowScroll, showTimeIndicator,
        timeIndicatorStyle, indicatorTimeFormat, autoNavigateDelay);
  }
}
