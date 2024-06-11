## Unreleased

**Bugs**
* \#FB57253 - Now, the appointment details are passed correctly to the [monthCellBuilder](https://pub.dev/documentation/syncfusion_flutter_calendar/latest/calendar/SfCalendar/monthCellBuilder.html) callback when navigating to the months using the navigation buttons.

## [25.2.3] - 05/13/2024
**General**
* Upgraded the `timezone` package to the latest version 0.9.3.

**Bug fixes**
* \#FB51676 - Now, the handleLoadMore method is called once when the CalendarDataSourceAction is set to reset.

## [25.1.35] - 03/15/2024
**General**
* Provided th​e Material 3 themes support.

**Bug fixes**
* \#FB50948 - Now, the 'setState() or markNeedsBuild() called during the build' exception will not be thrown when tapping today's button after swiping the `timelineMonth` view.
* \#FB50846 - Now, text size remains consistent when the app state or themes gets changed.

## [24.1.46] - 17/01/2024
**General**
* Upgraded the `intl` package to the latest version 0.19.0.

## [22.2.5]
**Features**
* Provided support to accessibility for builders in the Flutter event calendar.

## [20.3.56]
**Features**
* Provided text style customization support for the text in the placeholder (`No events` and `No selected date`) in the month agenda view and (`No events`) in the schedule view of the flutter event calendar.

## [20.2.43]
**Enhancements**
* Now, we have improved the behavior of the `appointmentBuilder` details `date` value to hold the start date of the appointment view in the Flutter event calendar.

## [20.2.36]
**Features**
* Now, we have improved the behavior of the month header of ScheduleView with a minimum date in the Flutter event calendar.

## [20.1.47]
**Features**
* Provided support for the number of days in view, it is used to customize the days count in the flutter event calendar.
* Provided support for recurring appointments on the last day of month in the flutter event calendar.

## [19.4.50] - 02/08/2022
**Bug fixes**
* Now, the week number is displayed properly when setting the `firstDayOfWeek` property in the Flutter event calendar.
* Now, the appointments are added to the schedule view properly with an empty appointment schedule weeks are hidden using `hideEmptyScheduleWeek`.

**Enhancements**
* Now, improved the Flutter calendar allowedViews UI to show the `Scrollbar`.

## [19.4.38] - 12/17/2021
**Features**
* Provided support to get calendar details based on the given offset passed through an argument by using the method of the `getCalendarDetailsAtOffset`.

**Enhancements**
* Now, improved the allowedViews UI in the flutter event calendar.

## [19.3.57] - 12/06/2021
**Bug fixes**
* Now, the localization is working properly for the All day label text in schedule view of the Flutter event calendar.

## [19.3.45] - 10/11/2021

**Enhancements**
* Now, the non-working dates are disabled in the date range picker for the work week views of the calendar.

## [19.3.43] - 09/30/2021

**Features**
* Provided resize, drag-and-drop support to reschedule appointments in the event calendar.

**Breaking changes**
* The default `cellEndPadding` value has been changed in the SfCalendar.

**Enhancements**
* Now the calendar will return the recurrence appointment details in the given custom data type instead of `Appointment` type by overriding the `convertAppointmentToObject` method of the `CalendarDataSource`.

## [19.2.55] - 08/11/2021
**Bug fixes**
* Now, the appointment will not intersect when the end time and start time of different appointment is 24 hours for two consecutive days.

**Features**
* Provided support to customize the background color of the all-day panel.

## [19.2.44] - 06/30/2021
**Features**
* Provided support to display week numbers of the year.
* Provided ID, recurrence ID, and appointment type support.
* Provided builder support for the resource header view.
* Now, the occurrence appointment will contain the occurrence date details in the tap callbacks. 
* Now, appointments will be displayed based on the `appointmentDisplayMode` in month view when the month cell builder is used.

## [19.1.54] - 03/30/2021
**Bug fixes**
* Now, the localization is working properly for the spanned appointment count text in Flutter event calendar.

**Features**
* Provided the LoadMore support for the event calendar.
* Provided the negative values support for BYSETPOS in recurrence to display the appointment in the last and second last week of a month.
* Provided the support for the header date format in the Flutter event calendar.
* Provided the support for getting appointments between the start and end date range by using the `getVisibleAppointments` method in the Flutter event calendar.
* Provided the current time indicator support for timeslot views.
* Provided the support for enabling and disabling the swiping interaction in the Flutter event calendar.
* Provided the support for the selected date changed callback in the Flutter event calendar.
* Improved the timeslot views disabled slots appearance in the Flutter event calendar.

**Breaking changes**
* The `startTime` and `endTime` properties of the `Appointment` class are now marked as required.
* The `startTime` property of the `RecurrenceProperties` class is now marked as required.
* The `startTime` and `endTime` properties of the `TimeRegion` class are now marked as required.

## [18.4.34] - 01/12/2021
**Bug fixes**
* Now, the date range picker layouting properly in the calendar header, when the `showDatePickerButton` property enabled.

## [18.4.33] - 01/05/2021
No changes.

## [18.4.32] - 12/30/2020
No changes.

## [18.4.31] - 12/22/2020
**Bug fixes**
* Now, the month view changes properly by date range picker when placing `SfCalendar` in `WillPopUp` widget.
* Now, the appointments are sorting properly in the month cells of `SfCalendar`.

## [18.4.30] - 12/17/2020
**Features**
* The custom builder support is provided for the time region and the appointment views in the calendar.
* Provided the interaction support for the resource header. 
* Support is provided to the right end padding for the cell touch region when the cell has an appointment in the calendar.

**Enhancements**
* The animation for view switching, selection ripple effect, and header picker pop-up animation is improved.

**Breaking changes**
* Now, the display date that does not contain an appointment will show the text as `No events`.

## [18.3.50] - 11/17/2020
**Bug fixes**
* Now, the time of the `displayDate` of `CalendarController` is working properly with the `timeInterval` changes.


## [18.3.48] - 11/11/2020
**Bug fixes**
* Now, the `SfCalendar` time zone support has been enhanced to IANA time zone support.


## [18.3.38] - 10/07/2020
No changes.

## [18.3.35] - 10/01/2020
**Bug fixes**
* Now, the appointment will render on the correct timeslot, when the local set as French,  Canada, and in `Eastern Standard Time`.
* Now, the appointments will render on the correct timeslot, when the start time of the time slot is set as a different value.

**Features**
* Timeline month view support
* Resource view support
* Internal view navigation support
* Blackout dates support
* Hide leading and trailing dates support
* The custom builder support for the month cells and the month header of the schedule view
* Agenda appointment time format support

**Breaking changes**
* The `todayTextStyle` property from the `MonthCellStyle` class has been deprecated, use the same property from the `SfCalendar` class instead.
* The `timeIntervalHeight` property will not work for timeline views, use the `timeIntervalWidth` property instead for the timeline views alone.
* The default value for the `timeIntervalWidth` is changed from 40 to 60.
* The appointment UI width is reduced in the day, week, and workweek views.
* Now, the `view` property from the `SfCalendar` does not work dynamically. To switch the view dynamically, use the same property from the `CalendarController`.

## [18.2.59] - 09/23/2020
No changes.

## [18.2.57] - 09/08/2020
**Bug fixes**
* Now, the calendar appointment text will no longer disappear when screen width changed.


## [18.2.56] - 09/01/2020
No changes.

## [18.2.55] - 25/08/2020

**Bug fixes**
* Now, the `SfCalendar` will no longer throw any exceptions when adding more appointments in the same timeslots.

## [18.2.54] - 08/18/2020

**Features**
* The time format support has been given for the agenda view and schedule view appointments.

## [18.2.48] - 08/04/2020

No changes.

## [18.2.47] - 07/28/2020

**Bug fixes**
* Now, the issue with swiping efficiency with appointments has been resolved and enhanced in calendar views.

## [18.2.46+1] - 07/24/2020

**Bug fixes**
* Now, the issue overflow not found is cleared with the Flutter latest beta channel.

## [18.2.46] - 07/21/2020

**Bug fixes**
* Now, the `SfCalendar` will not throw any exceptions when tapping the agenda view.

## [18.2.45] - 07/14/2020

**Bug fixes**
* Now, the `SfCalendar` shows the proper month in a week and workweek when view changed.


## [18.2.44] - 07/07/2020

**Features**
* The long press callback support 
* Schedule view support
* Special time regions support
* Navigation arrow support
* Mouse hovering for all calendar elements [web]

**Bug fixes**
* Now, the appointment indicator was shown properly in the month cells using the recurrence rule.
* Now, the onTap callback of the `SfCalendar` calling properly when tapping out of the calendar.
* Now, the scrolling is working properly when touchpoint is on the calendar inside a Column widget.

## [18.1.55-beta] - 06/03/2020

**Bug fixes**
* Now, the month cell dates are aligned properly with the Flutter latest beta channel.

## [18.1.52-beta] - 05/14/2020

**Bug fixes**
* Now, the visible dates do not show the repeated dates when the local time zone has daylight saving in `SfCalendar`.

## [18.1.48-beta] - 05/05/2020

No changes.

## [18.1.46-beta] - 04/28/2020

**Bug fixes**
* The error `No file or variants found for assert:packages/timezone/data/2019c.tzf` now cleared.

## [18.1.45-beta] - 04/21/2020

No changes.

## [18.1.44-beta] - 04/14/2020

**Bug fixes**
* The `parseRRule` now works without the `count` value in `SfCalendar`.

## [18.1.43-beta] - 04/07/2020 

No changes.

## [18.1.42-beta] - 04/01/2020 

No changes.

## [18.1.36-beta] - 03/19/2020

**Features**
* Right-to-left direction support.
* Localization support.
* Accessibility support.
* Calendar web support.
* Minimum and maximum date support.
* Theme support.
* Calendar controller for programmatic date selection and date navigation.

## [17.4.51-beta] - 02/25/2020

No changes.

## [17.4.50-beta] - 02/19/2020

No changes.

## [17.4.46-beta] - 01/30/2020

**Features**
* Provided the all-day appointment expander support in day/week/work week views.
* Provided the `appointments` property setter in `CalendarDataSource`.

## [17.4.43-beta] - 01/14/2020

No changes.

## [17.4.40-beta] - 12/18/2019

**Breaking changes**
* Renamed the `dataSource` property as `appointments` in `CalendarDataSource` abstract class.
* The `appointmentMapper` implementation replaced by override methods for custom appointments.
* The `timeZone` package updated to latest version and its database updated.
* The enum properties in `CalendarDataSourceAction` renamed as `add`, `remove` and `reset` instead of `Add`, `Remove` and `Reset`.

## [17.4.39-beta] - 12/17/2019

Initial release.

**Features** 
* Day, week, workweek, timeline day, timeline week, timeline workweek, and month. Seven built-in calendar views.
* Appointment scheduling. Default and custom appointments supported.
* Recursive appointments with daily, weekly, monthly, and yearly recurrence types.
* Time zones support for events and calendar.
* Different nonworking days.
* Different first day of week for all applicable views.
* Flexible start and end hours for time slot views.
* Agenda view support in calendar month view.
* Additional features like customizable calendar appearance and format.
