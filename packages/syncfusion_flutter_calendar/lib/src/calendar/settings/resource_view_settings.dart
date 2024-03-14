import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The settings have properties which allow to customize the resource view of
/// the [SfCalendar].
///
/// Allows to customize the [visibleResourceCount],[showAvatar],
/// [size], and [displayNameTextStyle] in resource view of calendar.
///
/// See also:
/// * [CalendarResource], which holds the data for the resource in the
/// * [CalendarDataSource.resources], which used to set and handle the resource
/// collection for the calendar.
/// * [SfCalendar.resourceViewHeaderBuilder], which used to set custom widget
/// for the resource view header in calendar.
/// * Knowledge base: [How to customize the resource view](https://www.syncfusion.com/kb/12351/how-to-customize-the-resource-view-in-the-flutter-calendar)
/// * Knowledge base: [How to add resources](https://www.syncfusion.com/kb/12070/how-to-add-resources-in-the-flutter-calendar)
///
///
/// ```dart
///@override
///  Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.timelineMonth,
///        dataSource: _getCalendarDataSource(),
///        resourceViewSettings: ResourceViewSettings(
///            visibleResourceCount: 4,
///            size: 150,
///            displayNameTextStyle: TextStyle(
///                fontStyle: FontStyle.italic,
///                fontSize: 15,
///                fontWeight: FontWeight.w400)),
///      ),
///    );
///  }
///}
///
///class DataSource extends CalendarDataSource {
///  DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
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
///      CalendarResource(displayName: 'John', id: '0001', color: Colors.red));
///
///  return DataSource(appointments, resources);
///}
///
/// ```
@immutable
class ResourceViewSettings with Diagnosticable {
  /// Creates a resource view settings for calendar.
  ///
  /// The properties allows to customize the resource view of [SfCalendar].
  const ResourceViewSettings(
      {this.size = 75,
      this.visibleResourceCount = -1,
      this.showAvatar = true,
      this.displayNameTextStyle})
      : assert(size >= 0),
        assert(visibleResourceCount >= -1);

  /// The number of resources to be displayed in the available screen height in
  /// [SfCalendar]
  ///
  /// See also:
  /// * [CalendarResource], the object which holds the data for the resource in
  /// the calendar
  /// * [CalendarDataSource.resources], which set and handle the resource
  /// collection for the calendar.
  /// * Knowledge base: [How to customize the resource view](https://www.syncfusion.com/kb/12351/how-to-customize-the-resource-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to add resources](https://www.syncfusion.com/kb/12070/how-to-add-resources-in-the-flutter-calendar)
  ///
  /// ```dart
  ///@override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineMonth,
  ///        dataSource: _getCalendarDataSource(),
  ///        resourceViewSettings: ResourceViewSettings(
  ///            visibleResourceCount: 4,
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  ///
  /// ```
  final int visibleResourceCount;

  /// The text style for the text in the [CalendarResource] view of
  /// [SfCalendar].
  ///
  /// Defaults to null.
  ///
  /// Using a [SfCalendarTheme] gives more fine-grained control over the
  /// appearance of various components of the calendar.
  ///
  /// See also:
  /// * [CalendarResource], the object which holds the data for the resource in
  /// the calendar
  /// * [CalendarDataSource.resources], which set and handle the resource
  /// collection for the calendar.
  /// * [SfCalendar.resourceViewHeaderBuilder], which allows to set custom
  /// widget for the resource view header.in calendar.
  /// * Knowledge base: [How to customize the resource view](https://www.syncfusion.com/kb/12351/how-to-customize-the-resource-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to add resources](https://www.syncfusion.com/kb/12070/how-to-add-resources-in-the-flutter-calendar)
  ///
  /// ```dart
  ///@override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineMonth,
  ///        dataSource: _getCalendarDataSource(),
  ///        resourceViewSettings: ResourceViewSettings(
  ///            visibleResourceCount: 4,
  ///            size: 150,
  ///            displayNameTextStyle: TextStyle(
  ///                fontStyle: FontStyle.italic,
  ///                fontSize: 15,
  ///                fontWeight: FontWeight.w400)),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  final TextStyle? displayNameTextStyle;

  /// The size of the resource view panel in timeline views of [SfCalendar].
  ///
  /// Defaults to `75`.
  ///
  /// See also:
  /// * [CalendarResource], the object which holds the data for the resource in
  /// the calendar
  /// * [CalendarDataSource.resources], which set and handle the resource
  /// collection for the calendar.
  /// * [SfCalendar.resourceViewHeaderBuilder], which allows to set custom
  /// widget for the resource view header.in calendar.
  /// * Knowledge base: [How to customize the resource view](https://www.syncfusion.com/kb/12351/how-to-customize-the-resource-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to add resources](https://www.syncfusion.com/kb/12070/how-to-add-resources-in-the-flutter-calendar)
  ///
  /// ```dart
  ///@override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineMonth,
  ///        dataSource: _getCalendarDataSource(),
  ///        resourceViewSettings: ResourceViewSettings(
  ///            visibleResourceCount: 4,
  ///            size: 150,
  ///            displayNameTextStyle: TextStyle(
  ///                fontStyle: FontStyle.italic,
  ///                fontSize: 15,
  ///                fontWeight: FontWeight.w400)),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  final double size;

  /// Shows a circle that represents a user.
  ///
  /// Typically used with a user's profile image, or, in the absence of such an
  /// image, the user's initials. A given user's initials should always be
  /// paired with the same color, for consistency.
  ///
  ///
  /// See also:
  /// * [CalendarResource], the object which holds the data for the resource in
  /// the calendar
  /// * [CalendarDataSource.resources], which set and handle the resource
  /// collection for the calendar.
  /// * [SfCalendar.resourceViewHeaderBuilder], which allows to set custom
  /// widget for the resource view header.in calendar.
  /// * Knowledge base: [How to customize the resource view](https://www.syncfusion.com/kb/12351/how-to-customize-the-resource-view-in-the-flutter-calendar)
  /// * Knowledge base: [How to add resources](https://www.syncfusion.com/kb/12070/how-to-add-resources-in-the-flutter-calendar)
  ///
  /// ```dart
  ///@override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineMonth,
  ///        dataSource: _getCalendarDataSource(),
  ///        resourceViewSettings: ResourceViewSettings(
  ///            visibleResourceCount: 4,
  ///            size: 150,
  ///            showAvatar: false,
  ///            displayNameTextStyle: TextStyle(
  ///                fontStyle: FontStyle.italic,
  ///                fontSize: 15,
  ///                fontWeight: FontWeight.w400)),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  final bool showAvatar;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final ResourceViewSettings otherStyle;
    if (other is ResourceViewSettings) {
      otherStyle = other;
    }
    return otherStyle.size == size &&
        otherStyle.visibleResourceCount == visibleResourceCount &&
        otherStyle.showAvatar == showAvatar &&
        otherStyle.displayNameTextStyle == displayNameTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>(
        'displayNameTextStyle', displayNameTextStyle));
    properties.add(DoubleProperty('size', size));
    properties.add(DiagnosticsProperty<bool>('showAvatar', showAvatar));
    properties.add(IntProperty('visibleResourceCount', visibleResourceCount));
  }

  @override
  int get hashCode {
    return Object.hash(
        size, visibleResourceCount, showAvatar, displayNameTextStyle);
  }
}
