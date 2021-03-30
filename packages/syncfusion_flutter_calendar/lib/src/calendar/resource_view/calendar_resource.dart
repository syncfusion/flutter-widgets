import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The resource data for calendar.
///
/// An object that contains properties to hold the detailed information about
/// the data, which will be rendered in [SfCalendar].
///
/// See also:
///
/// * [CalendarDataSource.resources], the collection of resource to be displayed
///  in the timeline views of [SfCalendar].
/// * [ResourceViewSettings], the settings have properties which allow to
/// customize the resource view of the [SfCalendar].
///
/// _Note:_ The resources will render only on the timeline view of [SfCalendar],
/// and it's not applicable for other calendar views.
///
/// The [id] property must not be null, to filter appointments based on
/// resource.
///
/// ``` dart
///
///@override
///  Widget build(BuildContext context) {
///    return Container(
///      child: SfCalendar(
///        view: CalendarView.timelineMonth,
///        dataSource: _getCalendarDataSource(),
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
///  resources.add(CalendarResource(
///    displayName: 'John',
///    id: '0001',
///    color: Colors.red
///  ));
///
///  return DataSource(appointments, resources);
///}
///
/// ```
class CalendarResource with Diagnosticable {
  /// Creates an resource data for [SfCalendar].
  ///
  /// An object that contains properties to hold the detailed information
  /// about the data, which will be rendered in [SfCalendar].
  CalendarResource(
      {this.displayName = '',
      required this.id,
      this.image,
      this.color = Colors.lightBlue});

  /// The name which displayed on the [CalendarResource] view of [SfCalendar].
  ///
  /// Defaults to ` `.
  ///
  /// _Note:_ The display name text style can be customized using the
  /// [ResourceViewSettings.displayNameTextStyle] property.
  ///
  /// See also:
  ///
  /// * [ResourceViewSettings], the settings have properties which allow to
  /// customize the resource view of the [SfCalendar].
  ///
  /// ``` dart
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
  ///  resources.add(CalendarResource(
  ///    displayName: 'John',
  ///    id: '0001',
  ///  ));
  ///
  ///  return DataSource(appointments, resources);
  ///}
  ///
  /// ```
  final String displayName;

  /// The unique id for the [CalendarResource] view of [SfCalendar].
  ///
  /// See also:
  ///
  /// * [Appointment.resourceIds], the ids of the [CalendarResource] that shares
  /// an [Appointment].
  /// * [TimeRegion.resourceIds], the ids of the [CalendarResource] that shares
  /// an [TimeRegion].
  ///
  /// ``` dart
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
  ///  resources.add(CalendarResource(
  ///    id: '0001',
  ///  ));
  ///
  ///  return DataSource(appointments, resources);
  ///}
  ///
  /// ```
  final Object id;

  /// The color that fills the background of the [CalendarResource] view in
  /// [SfCalendar].
  ///
  /// _Note:_ If [showAvatar] property set to `true`, this color property
  /// applies to color of avatar view.
  ///
  /// Defaults to `Colors.lightBlue`.
  ///
  /// ``` dart
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
  ///  resources.add(CalendarResource(
  ///    id: '0001',
  ///    color: Colors.red
  ///  ));
  ///
  ///  return DataSource(appointments, resources);
  ///}
  ///
  /// ```
  final Color color;

  /// An image that displayed on the [CalendarResource] view in [SfCalendar].
  ///
  ///  _Note:_ This only applicable when the [showAvatar] property set to
  ///  `true`.
  ///
  /// See also:
  ///
  /// * [ResourceViewSettings], the settings have properties which allow to
  /// customize the resource view of the [SfCalendar].
  /// * [ResourceViewSettings.showAvatar], shows a circle that represents a
  /// user.
  /// * [ImageProvider], commonly used to add image in flutter
  ///
  /// ``` dart
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
  ///  resources.add(CalendarResource(
  ///    displayName: 'John',
  ///    id: '0001',
  ///    color: Colors.red,
  ///    image: ExactAssetImage('images/john.png'),
  ///  ));
  ///
  ///  return DataSource(appointments, resources);
  ///}
  ///
  /// ```
  final ImageProvider? image;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CalendarResource resource = other;
    return resource.displayName == displayName &&
        resource.id == id &&
        resource.image == image &&
        resource.color == color;
  }

  @override
  int get hashCode {
    return hashValues(displayName, id, image, color);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(ColorProperty('color', color));
    properties.add(StringProperty('displayName', displayName));
    properties.add(DiagnosticsProperty<Object>('id', id));
    properties.add(DiagnosticsProperty<ImageProvider>('image', image));
  }
}
