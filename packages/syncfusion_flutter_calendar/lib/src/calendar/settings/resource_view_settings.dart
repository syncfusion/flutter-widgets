import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The settings have properties which allow to customize the resource view of
/// the [SfCalendar].
///
/// Allows to customize the [visibleResourceCount],[showAvatar],
/// size, and [displayNameTextStyle] in resource view of calendar.
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
  /// Creates resource view settings for [SfCalendar].
  ///
  /// Use this to customize the size, layout, and appearance of the resource view.
  ///
  /// `size` — Sets both the resource panel width and each resource item's height.
  /// Defaults to `75`.
  ///
  /// `height` — Sets the height for each resource item when given explicitly.
  /// Ignored when `visibleResourceCount` > 0. Falls back to `size` when null.
  ///
  /// `width` — Sets the width for the resource panel when given explicitly.
  /// Falls back to `size` when null.
  ///
  /// `visibleResourceCount` — When greater than `0`, splits the available
  /// vertical space equally among visible resources, overriding both `height`
  /// and `size`.
  ///
  /// `showAvatar` — Indicates whether a circular avatar is shown for each
  /// resource. Defaults to `true`.
  ///
  /// `displayNameTextStyle` — Text style used for the display name of each
  /// resource.
  ///
  /// ### Behavior and precedence
  ///
  /// * If `height` or `width` is provided, the provided value is used.
  /// * If neither is provided, `size` is used for both dimensions.
  /// * When `visibleResourceCount` > 0, it takes precedence for resource item
  ///   height over both `height` and `size`.
  const ResourceViewSettings({
    this.size = 75,
    this.visibleResourceCount = -1,
    this.showAvatar = true,
    this.displayNameTextStyle,
    this.height,
    double? width,
  }) : width = width ?? size,
       assert(size >= 0),
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

  /// Optional explicit height to use for each resource item.
  ///
  /// When `height` is provided, value will be used as the per-resource height in scenarios where `visibleResourceCount`
  /// is not provided. If `visibleResourceCount` is provided, it determines
  /// the height distribution and height property will be ignored.
  ///
  /// Example:
  /// ```dart
  ///@override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineMonth,
  ///        dataSource: _getCalendarDataSource(),
  ///        resourceViewSettings: ResourceViewSettings(
  ///          height: 120,
  ///          displayNameTextStyle: TextStyle(
  ///              fontStyle: FontStyle.italic,
  ///              fontSize: 15,
  ///              fontWeight: FontWeight.w400,
  ///        ),
  ///      ),
  ///    ),
  ///  );
  ///}
  ///```
  final double? height;

  /// Optional explicit width to use for the resource panel.
  ///
  /// When `width` is provided, value will be used as the resource panel width.
  ///
  /// Example:
  /// ```dart
  ///@override
  ///  Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfCalendar(
  ///        view: CalendarView.timelineMonth,
  ///        dataSource: _getCalendarDataSource(),
  ///        resourceViewSettings: ResourceViewSettings(
  ///          width: 150,
  ///          displayNameTextStyle: TextStyle(
  ///              fontStyle: FontStyle.italic,
  ///              fontSize: 15,
  ///              fontWeight: FontWeight.w400,
  ///        ),
  ///      ),
  ///    ),
  ///  );
  ///}
  ///```
  final double? width;

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
    // ignore: deprecated_member_use_from_same_package
    return otherStyle.size == size &&
        otherStyle.height == height &&
        otherStyle.width == width &&
        otherStyle.visibleResourceCount == visibleResourceCount &&
        otherStyle.showAvatar == showAvatar &&
        otherStyle.displayNameTextStyle == displayNameTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TextStyle>(
        'displayNameTextStyle',
        displayNameTextStyle,
      ),
    );
    // ignore: deprecated_member_use_from_same_package
    properties.add(DoubleProperty('size', size));
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('width', width));
    properties.add(DiagnosticsProperty<bool>('showAvatar', showAvatar));
    properties.add(IntProperty('visibleResourceCount', visibleResourceCount));
  }

  @override
  int get hashCode {
    return Object.hash(
      // ignore: deprecated_member_use_from_same_package
      size,
      height,
      width,
      visibleResourceCount,
      showAvatar,
      displayNameTextStyle,
    );
  }
}
