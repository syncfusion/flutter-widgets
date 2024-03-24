import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show IterableDiagnostics;

import '../../../calendar.dart';

/// It is used to highlight time slots on day, week, work week
/// and timeline views based on start and end time and
/// also used to restrict interaction on time slots.
///
/// Note: If time region have both the [text] and [iconData] then the region
/// will draw icon only.
///
/// See also:
/// * [SfCalendar.timeRegionBuilder], to set custom widget for the time regions
/// in the calendar
/// * [SfCalendar.specialRegions], which allows to set and handle the time
/// region collection fo the calendar and date range picker.
/// * Knowledge base: [How to customize special regions with builder](https://www.syncfusion.com/kb/12192/how-to-customize-the-special-time-region-using-custom-builder-in-the-flutter-calendar)
/// * Knowledge base: [How to create time table](https://www.syncfusion.com/kb/12392/how-to-create-time-table-using-flutter-event-calendar)
/// * Knowledge base: [How to add a special region dynamically using onTap and onViewChanged](https://www.syncfusion.com/kb/11729/how-to-add-a-special-region-dynamically-using-ontap-onviewchanged-callbacks-of-the-flutter)
/// * Knowledge base: [How to use multiple recurrence rule in special region](https://www.syncfusion.com/kb/11730/how-to-use-multiple-recurrence-rule-rrule-in-special-region-using-flutter-calendar)
/// * Knowledge base: [How to highlight the weekends](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
/// * Knowledge base: [How to highlight the lunch hours](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
///
/// ``` dart
///  Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.week,
///        specialRegions: _getTimeRegions(),
///      ),
///    );
///  }
///
///  List<TimeRegion> _getTimeRegions() {
///    final List<TimeRegion> regions = <TimeRegion>[];
///    regions.add(TimeRegion(
///        startTime: DateTime.now(),
///        endTime: DateTime.now().add(Duration(hours: 1)),
///        enablePointerInteraction: false,
///        color: Colors.grey.withOpacity(0.2),
///        text: 'Break'));
///
///    return regions;
///  }
///
///  ```
@immutable
class TimeRegion with Diagnosticable {
  /// Creates a Time region for timeslot views in calendar.
  ///
  /// The time region used to highlight and block the specific timeslots in
  /// timeslots view of [SfCalendar].
  TimeRegion(
      {required this.startTime,
      required this.endTime,
      this.text,
      this.recurrenceRule,
      this.color,
      this.enablePointerInteraction = true,
      this.recurrenceExceptionDates,
      this.resourceIds,
      this.timeZone,
      this.iconData,
      this.textStyle});

  /// Used to specify the start time of the [TimeRegion].
  ///
  /// Defaults to 'DateTime.now()'.
  ///
  /// See also:
  /// * [endTime], the date time value in which the time region will end.
  /// * [timeZone], the time zone for the time region, the region will be render
  /// by converting the given time based on [timeZone] and
  /// [SfCalendar.timeZone].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        color: Colors.grey.withOpacity(0.2),
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final DateTime startTime;

  /// Used to specify the end time of the [TimeRegion].
  /// [endTime] value as always greater than or equal to [startTime] of
  /// [TimeRegion].
  ///
  /// Defaults to 'DateTime.now()'.
  ///
  /// See also:
  /// * [startTime], the date time value in which the time region will start.
  /// * [timeZone], the time zone for the time region, the region will be render
  /// by converting the given time based on [timeZone] and
  /// [SfCalendar.timeZone].
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        color: Colors.grey.withOpacity(0.2),
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final DateTime endTime;

  /// Used to specify the text of [TimeRegion].
  ///
  /// Note: If time region have both the text and icon data then it will draw
  /// icon only.
  ///
  /// See also:
  /// * [iconData], the icon which will be displayed on the time region view.
  /// * [textStyle], which used to customize the style of the text on the time
  /// region view.
  /// * Knowledge base: [How to highlight the weekends](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
  /// * Knowledge base: [How to highlight the lunch hours](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
  /// * Knowledge base: [How to add a special region dynamically using onTap and onViewChanged](https://www.syncfusion.com/kb/11729/how-to-add-a-special-region-dynamically-using-ontap-onviewchanged-callbacks-of-the-flutter)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        color: Colors.grey.withOpacity(0.2),
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final String? text;

  /// Used to specify the recurrence of [TimeRegion].
  /// It used to recur the [TimeRegion] and it value like
  /// 'FREQ=DAILY;INTERVAL=1'
  ///
  /// Defaults to null.
  ///
  /// See also;
  /// * [RecurrenceProperties], which used to create the recurrence rule based
  /// on the values set to these properties.
  /// * [SfCalendar.generateRRule], which used to generate recurrence rule
  /// based on the [RecurrenceProperties] values.
  /// * [SfCalendar.getRecurrenceDateTimeCollection], to get the recurrence date
  /// time collection based on the given recurrence rule and start date.
  /// * Knowledge base: [How to use a negative value for bysetpos in rrule](https://www.syncfusion.com/kb/12552/how-to-use-a-negative-value-for-bysetpos-in-a-rrule-of-recurrence-appointment-in-the)
  /// * Knowledge base: [How to get the recurrence date collection](https://www.syncfusion.com/kb/12344/how-to-get-the-recurrence-date-collection-in-the-flutter-calendar)
  /// * Knowledge base: [How to use multiple recurrence rule in special region](https://www.syncfusion.com/kb/11730/how-to-use-multiple-recurrence-rule-rrule-in-special-region-using-flutter-calendar)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        timeZone: 'Eastern Standard Time',
  ///        recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
  ///        textStyle: TextStyle(color: Colors.black45, fontSize: 15),
  ///        color: Colors.grey.withOpacity(0.2),
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final String? recurrenceRule;

  /// Used to specify the background color of [TimeRegion].
  ///
  /// See also:
  /// * [textStyle], which used to customize the style for the text on the
  /// time region view.
  /// * [iconData], the icon will which will be displayed on the time region
  /// view.
  /// * [SfCalendar.timeRegionBuilder], to set custom widget for the time
  /// regions in the calendar
  /// * Knowledge base: [How to customize special regions with builder](https://www.syncfusion.com/kb/12192/how-to-customize-the-special-time-region-using-custom-builder-in-the-flutter-calendar)
  ///
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        color: Colors.grey.withOpacity(0.2),
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final Color? color;

  /// Used to allow or restrict the interaction of [TimeRegion].
  ///
  /// Note: This property only restrict the interaction on region and it does
  /// not restrict the following
  ///
  /// 1. Programmatic selection(if user update the selected date value
  /// dynamically)
  /// 2. Does not clear the selection when user select the region and
  /// dynamically change the [enablePointerInteraction] property to false.
  /// 3. It does not restrict appointment interaction when the appointment
  /// placed in the region.
  /// 4. It does not restrict the appointment rendering on specified region
  ///
  /// See also:
  /// * [SfCalendar.onTap], the callback which notifies when the calendar
  /// element tapped on view.
  /// * [SfCalendar.onLongPress], the callback which notifies when the calendar
  /// element long pressed on view.
  /// * Knowledge base: [How to add a special region dynamically using onTap and onViewChanged](https://www.syncfusion.com/kb/11729/how-to-add-a-special-region-dynamically-using-ontap-onviewchanged-callbacks-of-the-flutter)
  /// * Knowledge base: [How to highlight the weekends](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
  /// * Knowledge base: [How to highlight the lunch hours](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        color: Colors.grey.withOpacity(0.2),
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final bool enablePointerInteraction;

  /// Used to specify the time zone of [TimeRegion] start and end time.
  ///
  /// See also:
  /// * [endTime], the date time value in which the time region will end.
  /// * [startTime], the date time value in which the time region will start.
  /// * [SfCalendar.timeZone], to set the timezone for the calendar.
  /// * [The documentation for time zone](https://help.syncfusion.com/flutter/calendar/timezone)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        timeZone: 'Eastern Standard Time',
  ///        color: Colors.grey.withOpacity(0.2),
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final String? timeZone;

  /// Used to specify the text style for [TimeRegion] text and icon.
  ///
  /// See also:
  /// * [color], which used to fill the background of the time region view.
  /// * [iconData], the icon will which will be displayed on the time region
  /// view.
  /// * [SfCalendar.timeRegionBuilder], to set custom widget for the time
  /// regions in the calendar
  /// * Knowledge base: [How to customize special regions with builder](https://www.syncfusion.com/kb/12192/how-to-customize-the-special-time-region-using-custom-builder-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        timeZone: 'Eastern Standard Time',
  ///        textStyle: TextStyle(color: Colors.black45, fontSize: 15),
  ///        color: Colors.grey.withOpacity(0.2),
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final TextStyle? textStyle;

  /// Used to specify the icon of [TimeRegion].
  ///
  /// Note: If time region have both the text and icon then it will draw icon
  /// only.
  ///
  /// See also:
  /// * [text], the string which will be displayed on the time region view.
  /// * [textStyle], which used to customize the style of the text on the time
  /// region view.
  /// * Knowledge base: [How to highlight the weekends](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
  /// * Knowledge base: [How to highlight the lunch hours](https://www.syncfusion.com/kb/11712/how-to-highlight-the-weekends-in-the-flutter-calendar)
  /// * Knowledge base: [How to add a special region dynamically using onTap and onViewChanged](https://www.syncfusion.com/kb/11729/how-to-add-a-special-region-dynamically-using-ontap-onviewchanged-callbacks-of-the-flutter)
  ///
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        color: Colors.grey.withOpacity(0.2),
  ///        iconData: Icons.free_breakfast));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final IconData? iconData;

  /// Used to restrict the occurrence for an recurrence region.
  ///
  /// [TimeRegion] will recur on all possible dates given by the
  /// [recurrenceRule]. If it is not empty, then recurrence region not applied
  /// to specified collection of dates in [recurrenceExceptionDates].
  ///
  /// See also:
  /// * [recurrenceRule], which used to generate the recurrence time region
  /// based on the rule set.
  /// * [RecurrenceProperties], which used to create the recurrence rule based
  /// on the values set to these properties.
  /// * [SfCalendar.generateRRule], which used to generate recurrence rule
  /// based on the [RecurrenceProperties] values.
  /// * Knowledge base: [How to use multiple recurrence rule in special region](https://www.syncfusion.com/kb/11730/how-to-use-multiple-recurrence-rule-rrule-in-special-region-using-flutter-calendar)
  /// * Knowledge base: [How to exclude the dates from the recurrence appointments](https://www.syncfusion.com/kb/12161/how-to-exclude-the-dates-from-recurrence-appointments-in-the-flutter-calendar)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.week,
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///
  ///  List<TimeRegion> _getTimeRegions() {
  ///    final List<TimeRegion> regions = <TimeRegion>[];
  ///    regions.add(TimeRegion(
  ///        startTime: DateTime.now(),
  ///        endTime: DateTime.now().add(Duration(hours: 1)),
  ///        enablePointerInteraction: false,
  ///        timeZone: 'Eastern Standard Time',
  ///        recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
  ///        textStyle: TextStyle(color: Colors.black45, fontSize: 15),
  ///        color: Colors.grey.withOpacity(0.2),
  ///        recurrenceExceptionDates: [
  ///              DateTime.now().add(Duration(days: 2))
  ///            ],
  ///        text: 'Break'));
  ///
  ///    return regions;
  ///  }
  ///
  ///  ```
  final List<DateTime>? recurrenceExceptionDates;

  /// The ids of the [CalendarResource] that shares this [TimeRegion].
  ///
  /// Based on this Id the [TimeRegion]s are grouped and arranged to each
  /// resource in calendar view.
  ///
  /// See also:
  /// * [CalendarResource], object which contains the resource data.
  /// * [ResourceViewSettings], the settings have properties which allow to
  /// customize the resource view of the [SfCalendar].
  /// * [CalendarResource.id], the unique id for the [CalendarResource] view of
  /// [SfCalendar].
  /// * [CalendarDataSource], which used to set the resources collection to the
  /// calendar.
  /// * Knowledge base: [How to add resources](https://www.syncfusion.com/kb/12070/how-to-add-resources-in-the-flutter-calendar)
  ///
  ///```dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineMonth,
  ///        dataSource: _getCalendarDataSource(),
  ///        specialRegions: _getTimeRegions(),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  ///class DataSource extends CalendarDataSource {
  ///  DataSource(List<Appointment> source,
  ///         List<CalendarResource> resourceColl) {
  ///    appointments = source;
  ///    resources = resourceColl;
  ///  }
  ///}
  ///
  ///DataSource _getCalendarDataSource() {
  ///  List<Appointment> appointments = <Appointment>[];
  ///  List<CalendarResource> resources = <CalendarResource>[];
  ///  appointments.add(Appointment(
  ///      startTime: DateTime.now(),
  ///      endTime: DateTime.now().add(Duration(hours: 2)),
  ///      isAllDay: true,
  ///      subject: 'Meeting',
  ///      color: Colors.blue,
  ///      resourceIds: <Object>['0001'],
  ///      startTimeZone: '',
  ///      endTimeZone: ''));
  ///
  ///  resources.add(
  ///      CalendarResource(displayName: 'John', id: '0001',
  ///                                         color: Colors.red));
  ///
  ///  return DataSource(appointments, resources);
  ///}
  ///
  ///List<TimeRegion> _getTimeRegions() {
  ///  final List<TimeRegion> regions = <TimeRegion>[];
  ///  regions.add(TimeRegion(
  ///      startTime: DateTime.now(),
  ///      endTime: DateTime.now().add(Duration(hours: 1)),
  ///      enablePointerInteraction: false,
  ///      color: Colors.grey.withOpacity(0.2),
  ///      resourceIds: <Object>['0001'],
  ///      text: 'Break'));
  ///
  ///  return regions;
  ///}
  ///
  /// ```
  final List<Object>? resourceIds;

  /// Creates a copy of this [TimeRegion] but with the given fields replaced
  /// with the new values.
  TimeRegion copyWith(
      {DateTime? startTime,
      DateTime? endTime,
      String? text,
      String? recurrenceRule,
      Color? color,
      bool? enablePointerInteraction,
      List<DateTime>? recurrenceExceptionDates,
      String? timeZone,
      IconData? iconData,
      TextStyle? textStyle,
      List<Object>? resourceIds}) {
    return TimeRegion(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        color: color ?? this.color,
        recurrenceRule: recurrenceRule ?? this.recurrenceRule,
        textStyle: textStyle ?? this.textStyle,
        enablePointerInteraction:
            enablePointerInteraction ?? this.enablePointerInteraction,
        recurrenceExceptionDates:
            recurrenceExceptionDates ?? this.recurrenceExceptionDates,
        text: text ?? this.text,
        iconData: iconData ?? this.iconData,
        timeZone: timeZone ?? this.timeZone,
        resourceIds: resourceIds ?? this.resourceIds);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final TimeRegion region;
    if (other is TimeRegion) {
      region = other;
    }
    return region.textStyle == textStyle &&
        region.startTime == startTime &&
        region.endTime == endTime &&
        region.color == color &&
        region.recurrenceRule == recurrenceRule &&
        region.enablePointerInteraction == enablePointerInteraction &&
        region.recurrenceExceptionDates == recurrenceExceptionDates &&
        region.iconData == iconData &&
        region.timeZone == timeZone &&
        region.resourceIds == resourceIds &&
        region.text == text;
  }

  @override
  int get hashCode {
    return Object.hash(
        startTime,
        endTime,
        color,
        recurrenceRule,
        textStyle,
        enablePointerInteraction,

        /// Below condition is referred from text style class
        /// https://api.flutter.dev/flutter/painting/TextStyle/hashCode.html
        recurrenceExceptionDates == null
            ? null
            : Object.hashAll(recurrenceExceptionDates!),
        resourceIds == null ? null : Object.hashAll(resourceIds!),
        text,
        iconData,
        timeZone);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableDiagnostics<DateTime>(recurrenceExceptionDates)
        .toDiagnosticsNode(name: 'recurrenceExceptionDates'));
    properties.add(IterableDiagnostics<Object>(resourceIds)
        .toDiagnosticsNode(name: 'resourceIds'));
    properties.add(StringProperty('timeZone', timeZone));
    properties.add(StringProperty('recurrenceRule', recurrenceRule));
    properties.add(StringProperty('text', text));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<DateTime>('startTime', startTime));
    properties.add(DiagnosticsProperty<DateTime>('endTime', endTime));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
    properties.add(DiagnosticsProperty<IconData>('iconData', iconData));
    properties.add(DiagnosticsProperty<bool>(
        'enablePointerInteraction', enablePointerInteraction));
  }
}
