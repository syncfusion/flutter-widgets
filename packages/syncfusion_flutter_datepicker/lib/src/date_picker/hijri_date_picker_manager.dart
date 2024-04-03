import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import '../../datepicker.dart';
import 'picker_helper.dart';

/// Options to customize the month view of the [SfHijriDateRangePicker].
///
/// Allows to customize the [firstDayOfWeek], [dayFormat], [viewHeaderHeight].
/// [viewHeaderStyle], [enableSwipeSelection], [blackoutDates], [specialDates]
/// and [weekendDays] in month view of date range picker.
///
/// See also:
/// * [DateRangePickerMonthViewSettings], which used to customize the month view
/// of the date range picker.
/// * [DateRangePickerMonthCellStyle], which used to customize the month cell of
/// the month view in the date range picker.
/// * [HijriDatePickerMonthCellStyle], which used to customize the month cell of
/// the month view in the hijri date range picker.
/// * [SfHijriDateRangePicker.cellBuilder],which allows to set custom widget for
/// the picker cells in the date range picker.
/// * [HijriDatePickerYearCellStyle], which allows to customize the year cell of
///  the year, decade and century views of the date range picker.
/// * [SfHijriDateRangePicker.backgroundColor], which fills the background of
/// the date range picker.
/// * [SfHijriDateRangePicker.todayHighlightColor], which highlights the today
/// date cell in the date range picker.
/// * Knowledge base: [How to use hijri date range picker](https://www.syncfusion.com/kb/12200/how-to-use-hijri-date-range-picker-sfhijridaterangepicker-in-flutter)
/// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
/// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
/// * Knowledge base: [How to update blackout dates using onViewChanged callback](https://www.syncfusion.com/kb/12372/how-to-update-blackout-dates-using-onviewchanged-callback-in-the-flutter-date-range-picker)
/// * Knowledge base: [How to select all days when clicking on the day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
/// * Knowledge base: [How to change the first day of week](https://www.syncfusion.com/kb/12221/how-to-change-the-first-day-of-week-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
/// * Knowledge base: [How to change the week end dates](https://www.syncfusion.com/kb/12182/how-to-change-the-week-end-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to change the number of weeks](https://www.syncfusion.com/kb/12167/how-to-change-the-number-of-weeks-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to add active dates](https://www.syncfusion.com/kb/12075/how-to-add-active-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to create timeline date picker](https://www.syncfusion.com/kb/12474/how-to-create-timeline-date-picker-in-flutter)
/// * Knowledge base: [How to restrict swipe gesture for range selection](https://www.syncfusion.com/kb/12117/how-to-restrict-swipe-gesture-for-range-selection-in-the-flutter-date-range-picker)
///
/// ```dart
///
///Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfHijriDateRangePicker(
///          view: HijriDatePickerView.month,
///          monthViewSettings: HijriDatePickerMonthViewSettings(
///              firstDayOfWeek: 1,
///              dayFormat: 'E',
///              viewHeaderHeight: 70,
///              viewHeaderStyle: DateRangePickerViewHeaderStyle(
///                  backgroundColor: Colors.blue,
///                  textStyle:
///                      TextStyle(fontWeight: FontWeight.w400, fontSize: 15,
///                           color: Colors.black)),
///              enableSwipeSelection: false,
///              blackoutDates: <HijriDateTime>[
///                HijriDateTime.now().add(Duration(days: 4))
///              ],
///              specialDates: <HijriDateTime>[
///                HijriDateTime.now().add(Duration(days: 7)),
///                HijriDateTime.now().add(Duration(days: 8))
///              ],
///              weekendDays: <int>[
///                DateTime.monday,
///                DateTime.friday
///              ]),
///        ),
///      ),
///    );
///  }
///
/// ```
@immutable
class HijriDatePickerMonthViewSettings with Diagnosticable {
  /// Creates a date range picker month view settings for date range picker.
  ///
  /// The properties allows to customize the month view of
  /// [SfHijriDateRangePicker].
  const HijriDatePickerMonthViewSettings(
      {this.firstDayOfWeek = 7,
      this.dayFormat = 'EE',
      this.viewHeaderHeight = 30,
      this.viewHeaderStyle = const DateRangePickerViewHeaderStyle(),
      this.enableSwipeSelection = true,
      this.blackoutDates,
      this.specialDates,
      this.showWeekNumber = false,
      this.weekNumberStyle = const DateRangePickerWeekNumberStyle(),
      this.weekendDays = const <int>[6, 7]})
      : assert(firstDayOfWeek >= 1 && firstDayOfWeek <= 7),
        assert(viewHeaderHeight >= -1);

  /// Formats a text in the [SfHijriDateRangePicker] month view view header.
  ///
  /// Text format in the [SfHijriDateRangePicker] month view view header.
  ///
  /// Defaults to `EE`.
  ///
  /// See also:
  /// * [viewHeaderStyle], which used to customize the view header view of the
  /// hijri date range picker.
  /// * [SfHijriDateRangePicker.backgroundColor], which fills the background of
  /// the  hijri date range picker.
  /// * [SfHijriDateRangePicker.todayHighlightColor], which highlights the today
  ///  date in the hijri date range picker.
  /// * [viewHeaderHeight], which is the size for the view header view in the
  /// month view of date range picker.
  /// * Knowledge base: [How to replace the view header with the custom widget](https://www.syncfusion.com/kb/12098/how-to-replace-the-view-header-with-the-custom-widget-in-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          monthViewSettings: HijriDatePickerMonthViewSettings(
  ///               dayFormat: 'EEE'),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final String dayFormat;

  /// Enables the swipe selection for [SfHijriDateRangePicker], which allows to
  /// select the range of dates by swiping on the dates.
  ///
  /// If it is [false] selecting a two different dates will form the range of
  /// dates by covering the dates between the selected dates.
  ///
  /// Defaults to `true`.
  ///
  /// _Note:_ It is only applicable when the [DateRangePickerSelectionMode]
  ///  set as [DateRangePickerSelectionMode.range] or
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// See also:
  /// * [DateRangePickerSelectionMode], which contains different selection modes
  /// for the hijri date range picker.
  /// * [SfHijriDateRangePicker.enableMultiView], which displays two date range
  /// picker side by side based on the
  /// [SfHijriDateRangePicker.navigationDirection] value.
  /// * Knowledge base: [How to restrict swipe gesture for range selection](https://www.syncfusion.com/kb/12117/how-to-restrict-swipe-gesture-for-range-selection-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              HijriDatePickerMonthViewSettings(
  ///                   enableSwipeSelection: false),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool enableSwipeSelection;

  /// The first day of the week in the [SfHijriDateRangePicker] month view.
  ///
  /// Allows you to change the first day of the week in the month view,
  /// every month view will start from the day set to that property.
  ///
  /// Defaults to `7` which indicates `DateTime.sunday`.
  ///
  /// See also:
  /// * [showWeekNumber], which displays the week number of the year in the
  /// month view of the hijri date range picker.
  /// * Knowledge base: [How to change the first day of week](https://www.syncfusion.com/kb/12221/how-to-change-the-first-day-of-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              HijriDatePickerMonthViewSettings(firstDayOfWeek: 2),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final int firstDayOfWeek;

  /// Sets the style to customize [SfHijriDateRangePicker] month view view
  /// header.
  ///
  /// Allows to customize the [textStyle] and [backgroundColor] of the view
  /// header view in month view of [SfHijriDateRangePicker].
  ///
  /// See also:
  /// * [DateRangePickerViewHeaderStyle], to know more about the available
  /// option for customize the view header view of month view.
  /// * [viewHeaderHeight], which is the size for the view header view in the
  /// month view of hijri date range picker.
  /// * [dayFormat], which is used to customize the format of the view header
  /// text in the month view of hijri date range picker.
  /// * [SfHijriDateRangePicker.todayHighlightColor], which highlights the today
  /// date cell in the hijri date range picker.
  /// * Knowledge base: [How to replace the view header with the custom widget](https://www.syncfusion.com/kb/12098/how-to-replace-the-view-header-with-the-custom-widget-in-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          monthViewSettings: HijriDatePickerMonthViewSettings(
  ///              viewHeaderStyle: DateRangePickerViewHeaderStyle(
  ///                  backgroundColor: Colors.red,
  ///                  textStyle: TextStyle(
  ///                      fontWeight: FontWeight.w500,
  ///                      fontStyle: FontStyle.italic,
  ///                     fontSize: 20,
  ///                      color: Colors.white))),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerViewHeaderStyle viewHeaderStyle;

  /// The height of the view header to the layout within this in month view of
  /// [SfHijriDateRangePicker].
  ///
  /// Defaults to `30`.
  ///
  /// See also:
  /// * [viewHeaderStyle], which used to customize the view header view of the
  /// month view in hijri date range picker.
  /// * [dayFormat], which is used to customize the format of the view header
  /// text in the month view of hijri date range picker.
  /// * [SfHijriDateRangePicker.todayHighlightColor], which highlights the today
  /// date cell in the hijri date range picker.
  /// * Knowledge base: [How to replace the view header with the custom widget](https://www.syncfusion.com/kb/12098/how-to-replace-the-view-header-with-the-custom-widget-in-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              HijriDatePickerMonthViewSettings(viewHeaderHeight: 50),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double viewHeaderHeight;

  /// Disables the interactions for certain dates in the month view of
  /// [SfHijriDateRangePicker].
  ///
  /// Defaults to null.
  ///
  /// Use [HijriDatePickerMonthCellStyle.blackoutDateTextStyle] or
  /// [HijriDatePickerMonthCellStyle.blackoutDatesDecoration] property to
  /// customize the appearance of blackout dates in month view.
  ///
  /// See also:
  /// * [HijriDatePickerMonthCellStyle.blackoutDateTextStyle], which used to set
  /// text style for the black out date cell in the month view.
  /// * [HijriDatePickerMonthCellStyle.blackoutDatesDecoration], which used to
  /// set the decoration for the black out date cell in the month view.
  /// * [specialDates], which is the list of dates to highlight the specific
  /// dates in the month view.
  /// * [weekendDays], which used to change the week end days in the month view.
  /// * [SfHijriDateRangePicker.enablePastDates], which allows to enable the
  /// dates that falls before the today date for interaction.
  /// * Knowledge base: [How to update blackout dates using onViewChanged callback](https://www.syncfusion.com/kb/12372/how-to-update-blackout-dates-using-onviewchanged-callback-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to add active dates](https://www.syncfusion.com/kb/12075/how-to-add-active-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              HijriDatePickerMonthViewSettings(
  ///              blackoutDates: <HijriDateTime>[
  ///               HijriDateTime.now().add(Duration(days: 2)),
  ///               HijriDateTime.now().add(Duration(days: 3)),
  ///               HijriDateTime.now().add(Duration(days: 6)),
  ///               HijriDateTime.now().add(Duration(days: 7))
  ///          ]),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final List<HijriDateTime>? blackoutDates;

  /// In the month view of [SfHijriDateRangePicker] highlights the unique dates
  /// with different style rather than the other dates style.
  ///
  /// Defaults to null.
  ///
  /// Use [HijriDatePickerMonthCellStyle.specialDatesTextStyle] or
  /// [HijriDatePickerMonthCellStyle.specialDatesDecoration] property to
  /// customize the appearance of blackout dates in month view.
  ///
  /// See also:
  /// [HijriDatePickerMonthCellStyle.specialDatesTextStyle],which used to set
  /// text style for the text in special dates cell in the month view.
  /// [HijriDatePickerMonthCellStyle.specialDatesDecoration], which used to set
  /// decoration for the special dates cell in the month view.
  /// * [blackoutDates], which is the list of dates to restrict the interaction
  /// for specific dates in month view.
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              HijriDatePickerMonthViewSettings(
  ///              specialDates: <HijriDateTime>[
  ///               HijriDateTime.now().add(Duration(days: 2)),
  ///               HijriDateTime.now().add(Duration(days: 3)),
  ///               HijriDateTime.now().add(Duration(days: 6)),
  ///               HijriDateTime.now().add(Duration(days: 7))
  ///          ]),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final List<HijriDateTime>? specialDates;

  /// Used to displays the week number of the year in the month view of
  /// the SfHijriDateRangePicker.
  ///
  /// In the month view, it is displayed at the the left side of the month view
  /// as a separate column in the SfHijriDateRangePicker.
  ///
  /// Defaults to false
  ///
  /// see also:
  /// * [weekNumberStyle], which used to customize the week number view of the
  /// month view in the hijri date range picker.
  /// * [firstDayOfWeek], which used to customize the start day of the week in
  /// month view of hijri date range picker.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfHijriDateRangePicker(
  ///       view: HijriDatePickerView.month,
  ///       monthViewSettings: const HijriDatePickerMonthViewSettings(
  ///       showWeekNumber: true,
  ///       ),
  ///      ),
  ///    );
  ///  }
  final bool showWeekNumber;

  /// Defines the text style for the text in the week number panel of the
  /// SfHijriDateRangePicker.
  ///
  /// Defaults to null
  ///
  /// see also:
  /// * [showWeekNumber], which allows to display the week number of the year in
  /// the month view of the hijri date range picker.
  /// * [firstDayOfWeek], which used to customize the start day of the week in
  /// month view of hijri date range picker.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///   body: SfHijriDateRangePicker(
  ///     view: HijriDatePickerView.month,
  ///     monthViewSettings: const HijriDatePickerMonthViewSettings(
  ///     showWeekNumber: true,
  ///     weekNumberStyle: const DateRangePickerWeekNumberStyle(
  ///         textStyle: TextStyle(fontStyle: FontStyle.italic),
  ///         backgroundColor: Colors.purple),
  ///     ),
  ///   ),
  ///  );
  /// }
  final DateRangePickerWeekNumberStyle weekNumberStyle;

  /// The weekends for month view in [SfHijriDateRangePicker].
  ///
  /// Defaults to `<int>[6,7]` represents `<int>[DateTime.saturday,
  ///                                                     DateTime.sunday]`.
  ///
  /// _Note:_ The [weekendDays] will not be highlighted until it's customize by
  /// using the [HijriDatePickerMonthCellStyle.weekendTextStyle] or
  /// [HijriDatePickerMonthCellStyle.weekendDatesDecoration] property.
  ///
  /// See also:
  /// * [HijriDatePickerMonthCellStyle.weekendTextStyle], which used to set
  /// text style for the week end cell text in month view.
  /// * [HijriDatePickerMonthCellStyle.weekendDatesDecoration], which used to
  /// set decoration for the week end cell text in month view.
  /// * [specialDates], which used to highlight specific dates in the month view
  /// of hijri date range picker.
  /// * [blackoutDates], which used to restrict the user interaction for the
  /// specific dates in teh month view of date range picker.
  /// * Knowledge base: [How to change the week end dates](https://www.syncfusion.com/kb/12182/how-to-change-the-week-end-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the number of weeks](https://www.syncfusion.com/kb/12167/how-to-change-the-number-of-weeks-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings: HijriDatePickerMonthViewSettings(
  ///             weekendDays: <int>[DateTime.friday, DateTime.saturday]),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final List<int> weekendDays;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final HijriDatePickerMonthViewSettings otherStyle;
    if (other is HijriDatePickerMonthViewSettings) {
      otherStyle = other;
    }
    return otherStyle.dayFormat == dayFormat &&
        otherStyle.firstDayOfWeek == firstDayOfWeek &&
        otherStyle.viewHeaderStyle == viewHeaderStyle &&
        otherStyle.viewHeaderHeight == viewHeaderHeight &&
        otherStyle.blackoutDates == blackoutDates &&
        otherStyle.specialDates == specialDates &&
        otherStyle.weekendDays == weekendDays &&
        otherStyle.enableSwipeSelection == enableSwipeSelection &&
        otherStyle.showWeekNumber == showWeekNumber &&
        otherStyle.weekNumberStyle == weekNumberStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableDiagnostics<HijriDateTime>(blackoutDates)
        .toDiagnosticsNode(name: 'blackoutDates'));
    properties.add(IterableDiagnostics<HijriDateTime>(specialDates)
        .toDiagnosticsNode(name: 'specialDates'));
    properties.add(IntProperty('firstDayOfWeek', firstDayOfWeek));
    properties.add(DoubleProperty('viewHeaderHeight', viewHeaderHeight));
    properties.add(StringProperty('dayFormat', dayFormat));
    properties.add(DiagnosticsProperty<bool>(
        'enableSwipeSelection', enableSwipeSelection));
    properties.add(viewHeaderStyle.toDiagnosticsNode(name: 'viewHeaderStyle'));
    properties.add(IterableProperty<int>('weekendDays', weekendDays));
    properties.add(DiagnosticsProperty<bool>('showWeekNumber', showWeekNumber));
    properties.add(weekNumberStyle.toDiagnosticsNode(name: 'weekNumberStyle'));
  }

  @override
  int get hashCode {
    return Object.hash(
        dayFormat,
        firstDayOfWeek,
        viewHeaderStyle,
        enableSwipeSelection,
        viewHeaderHeight,
        showWeekNumber,
        weekNumberStyle,

        /// Below condition is referred from text style class
        /// https://api.flutter.dev/flutter/painting/TextStyle/hashCode.html
        specialDates == null ? null : Object.hashAll(specialDates!),
        blackoutDates == null ? null : Object.hashAll(blackoutDates!),
        Object.hashAll(weekendDays));
  }
}

/// Options to customize the year and decade view of the
/// [SfHijriDateRangePicker].
///
/// Allows to customize the [textStyle], [todayTextStyle],
/// [disabledDatesTextStyle], [cellDecoration], [todayCellDecoration], and
/// [disabledDatesDecoration] in year and decade view of the
/// [SfHijriDateRangePicker].
///
/// See also:
/// * [HijriDatePickerMonthCellStyle], which allows to customize the month cell
/// of the month view of the hijri date range picker
/// * [SfHijriDateRangePicker.cellBuilder], which allows to set custom widget
/// for the picker cells in the dhijri ate range picker.
/// * [HijriDatePickerMonthViewSettings], which allows to customize the month
/// view of the hijri date range picker.
/// * [SfHijriDateRangePicker.selectionColor], which fills the background of the
/// selected cells in the hijri date range picker.
/// * [SfHijriDateRangePicker.startRangeSelectionColor], which fills the
/// background of the first cell of the range selection in hijri date range
/// picker.
/// * [SfHijriDateRangePicker.endRangeSelectionColor], which fills the
/// background of the last cell of the range selection in hijri date range
/// picker.
/// * [SfHijriDateRangePicker.rangeSelectionColor], which fills the background
///  of the in between cells of hijri date range picker in range selection.
/// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the text
/// style for the text in the selected cell of hijri date range picker.
/// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
/// for the text in the selected range cell's of hijri date range picker.
/// * [SfHijriDateRangePicker.backgroundColor], which fills the background of
/// the hijri date range picker.
/// * [SfHijriDateRangePicker.todayHighlightColor], which highlights the today
/// date cell in the hijri date range picker.
/// * Knowledge base: [How to select all days when clicking on the day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
/// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
/// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
///
/// ``` dart
///
/// Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfHijriDateRangePicker(
///          view: HijriDatePickerView.decade,
///          enablePastDates: false,
///          yearCellStyle: HijriDatePickerYearCellStyle(
///            textStyle: TextStyle(
///                fontWeight: FontWeight.w400, fontSize: 15,
///                     color: Colors.black),
///            todayTextStyle: TextStyle(
///                fontStyle: FontStyle.italic,
///                fontSize: 15,
///                fontWeight: FontWeight.w500,
///                color: Colors.red),
///            disabledDatesDecoration: BoxDecoration(
///                color: const Color(0xFFDFDFDF).withOpacity(0.2),
///                border: Border.all(color: const Color(0xFFB6B6B6), width: 1),
///                shape: BoxShape.circle),
///          ),
///        ),
///      ),
///    );
///  }
///
/// ```
@immutable
class HijriDatePickerYearCellStyle with Diagnosticable {
  /// Creates a date range picker year cell style for date range picker.
  ///
  /// The properties allows to customize the year cells in year view of
  /// [SfHijriDateRangePicker].
  const HijriDatePickerYearCellStyle(
      {this.textStyle,
      this.todayTextStyle,
      this.disabledDatesTextStyle,
      this.cellDecoration,
      this.todayCellDecoration,
      this.disabledDatesDecoration});

  /// The text style for the text in the [SfHijriDateRangePicker] year and
  /// decade view cells.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [cellDecoration], which used to set decoration for the year cells in the
  /// year view of the date range picker.
  /// * [todayTextStyle], which used to set text style for the today cell in the
  /// year view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set text style for the disabled
  /// cell in the year view of the date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.year,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: HijriDatePickerYearCellStyle(
  ///              textStyle: TextStyle(
  ///            fontSize: 14,
  ///            fontWeight: FontWeight.w400,
  ///            color: Colors.blue,
  ///          )),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? textStyle;

  /// The text style for the text in the today cell of [SfHijriDateRangePicker]
  /// year and decade view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [todayCellDecoration], which used to set decoration for the today cell
  /// in the year views of date range picker.
  /// * [textStyle], which used to set text style for the year cell in the
  /// year views of the date range picker.
  /// * [disabledDatesTextStyle], which used to set text style for the disabled
  /// cell in the year views of the date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.year,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: HijriDatePickerYearCellStyle(
  ///              todayTextStyle: TextStyle(
  ///                  fontSize: 14,
  ///                  fontWeight: FontWeight.w400,
  ///                  color: Colors.red,
  ///                  fontStyle: FontStyle.italic)),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? todayTextStyle;

  /// The text style for the text in the disabled dates cell of
  /// [SfHijriDateRangePicker] year and decade view.
  ///
  /// Here, disabled cells are the one which falls beyond the minimum and
  /// maximum date range.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [disabledDatesDecoration], which used to set decoration for the disabled
  /// date cells in the year views of date range picker.
  /// * [textStyle], which used to set text style for the year cell in the
  /// year views of the date range picker.
  /// * [todayTextStyle], which used to set text style for the today date
  /// cell in the year views of the date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.year,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: HijriDatePickerYearCellStyle(
  ///              disabledDatesTextStyle: TextStyle(
  ///                  fontSize: 12,
  ///                  fontWeight: FontWeight.w300,
  ///                  color: Colors.black)),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? disabledDatesTextStyle;

  /// The decoration for the disabled cells of [SfHijriDateRangePicker]
  /// year and decade view.
  ///
  /// Here, disabled cells are the one which falls beyond the minimum and
  /// maximum date range.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [disabledDatesTextStyle], which used to set text style for the disabled
  /// date cells in the year views of date range picker.
  /// * [cellDecoration], which used to set decoration for the year cell in the
  /// year views of the date range picker.
  /// * [todayCellDecoration], which used to set decoration for the today date
  /// cell in the year views of the date range picker.
  /// * [SfHijriDateRangePicker.selectionColor], which fills the background of
  /// the selected cells in the date range picker.
  /// * [SfHijriDateRangePicker.startRangeSelectionColor], which fills the
  /// background of the first cell of the range selection in date range picker.
  /// * [SfHijriDateRangePicker.endRangeSelectionColor], which fills the
  /// background of the last cell of the range selection in date range picker.
  /// * [SfHijriDateRangePicker.rangeSelectionColor], which fills the background
  /// of the in between cells of date range picker in range selection.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.decade,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: HijriDatePickerYearCellStyle(
  ///            disabledDatesDecoration: BoxDecoration(
  ///                color: Colors.black.withOpacity(0.4),
  ///                border: Border.all(color: const Color(0xFF2B732F),
  ///                     width: 1),
  ///                shape: BoxShape.rectangle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Decoration? disabledDatesDecoration;

  /// The decoration for the cells of [SfHijriDateRangePicker] year and decade
  /// view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [textStyle], which used to set text style for the year cells in the
  /// year views of date range picker.
  /// * [disabledDatesDecoration], which used to set decoration for the disabled
  /// year cells in the year views of the date range picker.
  /// * [todayCellDecoration], which used to set decoration for the today date
  /// cell in the year views of the date range picker.
  /// * [SfHijriDateRangePicker.selectionColor], which fills the background of
  /// the selected cells in the date range picker.
  /// * [SfHijriDateRangePicker.startRangeSelectionColor], which fills the
  /// background of the first cell of the range selection in date range picker.
  /// * [SfHijriDateRangePicker.endRangeSelectionColor], which fills the
  /// background of the last cell of the range selection in date range picker.
  /// * [SfHijriDateRangePicker.rangeSelectionColor], which fills the background
  /// of the in between cells of date range picker in range selection.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.decade,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: HijriDatePickerYearCellStyle(
  ///            cellDecoration: BoxDecoration(
  ///                color: Colors.green,
  ///                border: Border.all(color: const Color(0xFF2B732F),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Decoration? cellDecoration;

  /// The decoration for the today cell of [SfHijriDateRangePicker] year and
  /// decade view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [todayTextStyle], which used to set text style for the today date cell
  /// in the year views of date range picker.
  /// * [disabledDatesDecoration], which used to set decoration for the disabled
  /// year cells in the year views of the date range picker.
  /// * [todayCellDecoration], which used to set decoration for the today date
  /// cell in the year views of the date range picker.
  /// * [SfHijriDateRangePicker.selectionColor], which fills the background of
  /// the selected cells in the date range picker.
  /// * [SfHijriDateRangePicker.startRangeSelectionColor], which fills the
  /// background of the first cell of the range selection in date range picker.
  /// * [SfHijriDateRangePicker.endRangeSelectionColor], which fills the
  /// background of the last cell of the range selection in date range picker.
  /// * [SfHijriDateRangePicker.rangeSelectionColor], which fills the background
  /// of the in between cells of date range picker in range selection.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.decade,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: HijriDatePickerYearCellStyle(
  ///            todayCellDecoration: BoxDecoration(
  ///                color: Colors.red,
  ///                border: Border.all(color: const Color(0xFF2B732F),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Decoration? todayCellDecoration;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final HijriDatePickerYearCellStyle otherStyle;
    if (other is HijriDatePickerYearCellStyle) {
      otherStyle = other;
    }
    return otherStyle.textStyle == textStyle &&
        otherStyle.todayTextStyle == todayTextStyle &&
        otherStyle.disabledDatesDecoration == disabledDatesDecoration &&
        otherStyle.cellDecoration == cellDecoration &&
        otherStyle.todayCellDecoration == todayCellDecoration &&
        otherStyle.disabledDatesTextStyle == disabledDatesTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
    properties
        .add(DiagnosticsProperty<TextStyle>('todayTextStyle', todayTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'disabledDatesTextStyle', disabledDatesTextStyle));
    properties.add(DiagnosticsProperty<Decoration>(
        'disabledDatesDecoration', disabledDatesDecoration));
    properties
        .add(DiagnosticsProperty<Decoration>('cellDecoration', cellDecoration));
    properties.add(DiagnosticsProperty<Decoration>(
        'todayCellDecoration', todayCellDecoration));
  }

  @override
  int get hashCode {
    return Object.hash(textStyle, todayTextStyle, disabledDatesTextStyle,
        disabledDatesDecoration, cellDecoration, todayCellDecoration);
  }
}

/// Options to customize the month cells of the [SfHijriDateRangePicker].
///
///
/// Allows to customize the [textStyle], [todayTextStyle],
/// [disabledDatesTextStyle], [blackoutDateTextStyle], [weekendTextStyle],
/// [specialDatesTextStyle], [specialDatesDecoration],
/// [blackoutDatesDecoration], [cellDecoration], [todayCellDecoration],
/// [disabledDatesDecoration],and [weekendDatesDecoration]  in the month cells
/// of the date range picker.
///
/// See also:
/// * [HijriDatePickerMonthViewSettings], which allows to customize the month
/// view of the date range picker
/// * [SfHijriDateRangePicker.cellBuilder], which allows to set custom widget
/// for the picker cells in the date range picker.
/// * [HijriDatePickerYearCellStyle], which allows to customize the year cell of
/// the year, decade and century views of the date range picker.
/// * [SfHijriDateRangePicker.selectionColor], which fills the background of the
/// selected cells in the date range picker.
/// * [SfHijriDateRangePicker.startRangeSelectionColor], which fills the
/// background of the first cell of the range selection in date range picker.
/// * [SfHijriDateRangePicker.endRangeSelectionColor], which fills the
/// background of the last cell of the range selection in date range picker.
/// * [SfHijriDateRangePicker.rangeSelectionColor], which fills the background
/// of the in between cells of date range picker in range selection.
/// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the text
/// style for the text in the selected cell of date range picker.
/// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
/// for the text in the selected range cell's of date range picker.
/// * [SfHijriDateRangePicker.backgroundColor], which fills the background of
/// the date range picker.
/// * [SfHijriDateRangePicker.todayHighlightColor], which highlights the today
/// date cell in the date range picker.
/// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
/// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
/// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
/// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
///
/// ``` dart
///
/// Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfHijriDateRangePicker(
///          view: HijriDatePickerView.month,
///          enablePastDates: false,
///          monthCellStyle: HijriDatePickerMonthCellStyle(
///            textStyle: TextStyle(
///                fontWeight: FontWeight.w400, fontSize: 15,
///                     color: Colors.black),
///            todayTextStyle: TextStyle(
///                fontStyle: FontStyle.italic,
///                fontSize: 15,
///                fontWeight: FontWeight.w500,
///                color: Colors.red),
///            disabledDatesDecoration: BoxDecoration(
///                color: const Color(0xFFDFDFDF).withOpacity(0.2),
///                border: Border.all(color: const Color(0xFFB6B6B6), width: 1),
///                shape: BoxShape.circle),
///          ),
///        ),
///      ),
///    );
///  }
///
/// ```
@immutable
class HijriDatePickerMonthCellStyle with Diagnosticable {
  /// Creates a date range picker month cell style for date range picker.
  ///
  /// The properties allows to customize the month cells in month view of
  /// [SfHijriDateRangePicker].
  const HijriDatePickerMonthCellStyle(
      {this.textStyle,
      this.todayTextStyle,
      this.disabledDatesTextStyle,
      this.blackoutDateTextStyle,
      this.weekendTextStyle,
      this.specialDatesTextStyle,
      this.specialDatesDecoration,
      this.blackoutDatesDecoration,
      this.cellDecoration,
      this.todayCellDecoration,
      this.disabledDatesDecoration,
      this.weekendDatesDecoration});

  /// The text style for the text in the [SfHijriDateRangePicker] month cells.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [cellDecoration], which used to set decoration for the month cells in
  /// the month view of the date range picker.
  /// * [todayTextStyle], which used to set text style for the today date cell
  /// in the month view of the date range picker.
  /// trailing dates cells in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled cells in the month view of the date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set text style for the the week end
  /// date cells in the date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///         view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///            textStyle: TextStyle(
  ///              fontStyle: FontStyle.normal,
  ///              fontWeight: FontWeight.w400,
  ///              fontSize: 12,
  ///              color: Colors.blue
  ///            )
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? textStyle;

  /// The text style for the text in the today cell of [SfHijriDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [todayCellDecoration], which used to set decoration for the today month
  /// cell in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled cells in the month view of the date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set text style for the the week end
  /// date cells in the date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///            todayTextStyle: TextStyle(
  ///              fontStyle: FontStyle.italic,
  ///              fontWeight: FontWeight.w400,
  ///             fontSize: 12,
  ///              color: Colors.red
  ///            )
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? todayTextStyle;

  /// The text style for the text in the disabled dates cell of
  /// [SfHijriDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [SfHijriDateRangePicker.minDate], which is the minimum available date
  /// for the date range picker.
  /// * [SfHijriDateRangePicker.maxDate], which is the last available date for
  /// the date range picker.
  /// * [SfHijriDateRangePicker.enablePastDates], which allows to enable the
  /// dates that falls before the today date for interaction.
  /// * [disabledDatesDecoration], which used to set decoration for the disabled
  /// date cells in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [todayTextStyle], which used to set the text style for the today date
  /// cell in the month view of the date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set text style for the the week end
  /// date cells in the date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///              disabledDatesTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.normal,
  ///                  fontWeight: FontWeight.w300,
  ///                  fontSize: 10,
  ///                  color: Colors.grey)),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? disabledDatesTextStyle;

  /// The text style for the text in the blackout dates cell of
  /// [SfHijriDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [HijriDatePickerMonthViewSettings.blackoutDates], which is used to
  /// disable interaction for the specific month dates in month view.
  /// * [SfHijriDateRangePicker.enablePastDates], which allows to enable the
  /// dates that falls before the today date for interaction.
  /// * [blackoutDatesDecoration], which used to set decoration for the black
  /// out date cells in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [todayTextStyle], which used to set the text style for the today date
  /// cell in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled date cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set text style for the the week end
  /// date cells in the date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///              blackoutDateTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.italic,
  ///                  fontWeight: FontWeight.w500,
  ///                  fontSize: 18,
  ///                  color: Colors.black54)),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? blackoutDateTextStyle;

  /// The text style for the text in the weekend dates cell of
  /// [SfHijriDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [HijriDatePickerMonthViewSettings.weekendDays], which is used change the
  /// week ends for month.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [todayTextStyle], which used to set the text style for the today date
  /// cell in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled date cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///              weekendTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.italic,
  ///                  fontWeight: FontWeight.w500,
  ///                  fontSize: 12,
  ///                  color: Colors.green)),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? weekendTextStyle;

  /// The text style for the text in the special dates cell of
  /// [SfHijriDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [HijriDatePickerMonthViewSettings.specialDates], which is used highlight
  /// the specific dates in the month view.
  /// * [specialDatesDecoration], which used to set decoration for the special
  /// date cells in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [todayTextStyle], which used to set the text style for the today date
  /// cell in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled date cells in the month view of date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set the text style for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///              specialDatesTextStyle: TextStyle(
  ///                  fontWeight: FontWeight.bold,
  ///                  fontSize: 12,
  ///                  color: Colors.orange)),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? specialDatesTextStyle;

  /// The decoration for the special date cells of [SfHijriDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [HijriDatePickerMonthViewSettings.specialDates], which is used highlight
  /// the specific dates in the month view.
  /// * [specialDatesTextStyle], which used to set text style for the special
  /// date cells in the month view of the date range picker.
  /// * [cellDecoration], which used to set decoration for the month cells
  /// in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [disabledDatesDecoration], which used to set the decoration for the
  /// disabled date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set the decoration for the
  /// weekend date cells in the month view of date range picker.
  /// * [blackoutDatesDecoration], which used to set decoration for the blackout
  /// date cells in the month view of date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///            specialDatesDecoration: BoxDecoration(
  ///                color: Colors.blueGrey,
  ///                border: Border.all(color: const Color(0xFF2B732F),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///     ),
  ///    );
  ///  }
  ///
  /// ```
  final Decoration? specialDatesDecoration;

  /// The decoration for the weekend date cells of [SfHijriDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [HijriDatePickerMonthViewSettings.weekendDates], which is used to change
  /// the weekends for the month in month view.
  /// * [weekendTextStyle], which used to set text style for the special
  /// date cells in the month view of the date range picker.
  /// * [cellDecoration], which used to set decoration for the month cells
  /// in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [disabledDatesDecoration], which used to set the decoration for the
  /// disabled date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [blackoutDatesDecoration], which used to set decoration for the blackout
  /// date cells in the month view of date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///            weekendDatesDecoration: BoxDecoration(
  ///                color: Colors.green,
  ///                border: Border.all(color: const Color(0xFF2B732F),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Decoration? weekendDatesDecoration;

  /// The decoration for the blackout date cells of [SfHijriDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [HijriDatePickerMonthViewSettings.blackoutDates], which is used to
  /// disable interactions for specific dates  in month view.
  /// * [blackoutDateTextStyle], which used to set text style for the blackout
  /// date cells in the month view of the date range picker.
  /// * [cellDecoration], which used to set decoration for the month cells
  /// in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [disabledDatesDecoration], which used to set the decoration for the
  /// disabled date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///            blackoutDatesDecoration: BoxDecoration(
  ///                color: Colors.black,
  ///                border: Border.all(color: const Color(0xFF2B732F),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Decoration? blackoutDatesDecoration;

  /// The decoration for the disabled date cells of [SfHijriDateRangePicker]
  /// month view.
  ///
  /// The disabled dates are the one which falls beyond the minimum and maximum
  /// date range.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [SfHijriDateRangePicker.minDate], which is the least available date in
  /// the date range picker.
  /// * [SfHijriDateRangePicker.maxDate], which is the last available date in
  /// the date range picker.
  /// * [disabledDatesTextStyle], which used to set text style for the disabled
  /// date cells in the month view of the date range picker.
  /// * [cellDecoration], which used to set decoration for the month cells
  /// in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [blackoutDatesDecoration], which used to set the decoration for the
  /// blackout date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///            disabledDatesDecoration: BoxDecoration(
  ///                color: Colors.black.withOpacity(0.4),
  ///                border: Border.all(color: const Color(0xFF2B732F),
  ///                     width: 1),
  ///                shape: BoxShape.rectangle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Decoration? disabledDatesDecoration;

  /// The decoration for the month cells of [SfHijriDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [disabledDatesDecoration], which used to set decoration for the disabled
  /// date cells in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [blackoutDatesDecoration], which used to set the decoration for the
  /// blackout date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///            cellDecoration: BoxDecoration(
  ///                color: Colors.blueGrey.withOpacity(0.4),
  ///                border: Border.all(color: const Color(0xFF2B732F),
  ///                     width: 1),
  ///               shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Decoration? cellDecoration;

  /// The decoration for the today text cell of [SfHijriDateRangePicker] month
  /// view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [todayTextStyle], which used to set text style for the today date cell
  /// in the month view of the date range picker.
  /// * [disabledDatesDecoration], which used to set decoration for the disabled
  /// date cells in the month view of the date range picker.
  /// * [cellDecoration], which used to set the decoration for the month cells
  /// in the month view of the date range picker.
  /// * [blackoutDatesDecoration], which used to set the decoration for the
  /// blackout date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfHijriDateRangePicker.selectionTextStyle], which is used to set the
  /// text style for the text in the selected cell of date range picker.
  /// * [SfHijriDateRangePicker.rangeTextStyle], which is used to set text style
  /// for the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: HijriDatePickerMonthCellStyle(
  ///            todayCellDecoration: BoxDecoration(
  ///                color: Colors.red,
  ///                border: Border.all(color: const Color(0xFF2B732F),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///      ),
  ///   );
  ///  }
  ///
  /// ```
  final Decoration? todayCellDecoration;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final HijriDatePickerMonthCellStyle otherStyle;
    if (other is HijriDatePickerMonthCellStyle) {
      otherStyle = other;
    }
    return otherStyle.textStyle == textStyle &&
        otherStyle.todayTextStyle == todayTextStyle &&
        otherStyle.blackoutDateTextStyle == blackoutDateTextStyle &&
        otherStyle.weekendTextStyle == weekendTextStyle &&
        otherStyle.specialDatesTextStyle == specialDatesTextStyle &&
        otherStyle.specialDatesDecoration == specialDatesDecoration &&
        otherStyle.weekendDatesDecoration == weekendDatesDecoration &&
        otherStyle.blackoutDatesDecoration == blackoutDatesDecoration &&
        otherStyle.disabledDatesDecoration == disabledDatesDecoration &&
        otherStyle.cellDecoration == cellDecoration &&
        otherStyle.todayCellDecoration == todayCellDecoration &&
        otherStyle.disabledDatesTextStyle == disabledDatesTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
    properties
        .add(DiagnosticsProperty<TextStyle>('todayTextStyle', todayTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'blackoutDateTextStyle', blackoutDateTextStyle));
    properties.add(
        DiagnosticsProperty<TextStyle>('weekendTextStyle', weekendTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'specialDatesTextStyle', specialDatesTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'disabledDatesTextStyle', disabledDatesTextStyle));
    properties.add(DiagnosticsProperty<Decoration>(
        'disabledDatesDecoration', disabledDatesDecoration));
    properties
        .add(DiagnosticsProperty<Decoration>('cellDecoration', cellDecoration));
    properties.add(DiagnosticsProperty<Decoration>(
        'todayCellDecoration', todayCellDecoration));
    properties.add(DiagnosticsProperty<Decoration>(
        'blackoutDatesDecoration', blackoutDatesDecoration));
    properties.add(DiagnosticsProperty<Decoration>(
        'weekendDatesDecoration', weekendDatesDecoration));
    properties.add(DiagnosticsProperty<Decoration>(
        'specialDatesDecoration', specialDatesDecoration));
  }

  @override
  int get hashCode {
    return Object.hashAll(<dynamic>[
      textStyle,
      todayTextStyle,
      disabledDatesTextStyle,
      specialDatesDecoration,
      weekendDatesDecoration,
      blackoutDatesDecoration,
      disabledDatesDecoration,
      cellDecoration,
      todayCellDecoration,
      specialDatesTextStyle,
      blackoutDateTextStyle,
      weekendTextStyle,
    ]);
  }
}

/// An object that used for programmatic date navigation, date and range
/// selection and view switching in [SfHijriDateRangePicker].
///
/// A [HijriDatePickerController] served for several purposes. It can be
/// used to selected dates and ranges programmatically on
/// [SfHijriDateRangePicker] by using the [controller.selectedDate],
/// [controller.selectedDates], [controller.selectedRange],
/// [controller.selectedRanges]. It can be used to change the
/// [SfHijriDateRangePicker] view by using the [controller.view] property.
/// It can be used to navigate to specific date by using the
/// [controller.displayDate] property.
///
/// ## Listening to property changes:
/// The [HijriDatePickerController] is a listenable. It notifies it's
/// listeners whenever any of attached [SfHijriDateRangePicker]`s selected date,
/// display date and view changed (i.e: selecting a different date, swiping to
/// next/previous view and navigates to different view] in in
/// [SfHijriDateRangePicker].
///
/// ## Navigates to different view:
/// The [SfHijriDateRangePicker] visible view can be changed by using the
/// [Controller.view] property, the property allow to change the view of
/// [SfHijriDateRangePicker] programmatically on initial load and in rum time.
///
/// ## Programmatic selection:
/// In [SfHijriDateRangePicker] selecting dates programmatically can be achieved
///  by using the [controller.selectedDate], [controller.selectedDates],
/// [controller.selectedRange], [controller.selectedRanges] which allows to
/// select the dates or ranges programmatically on [SfHijriDateRangePicker] on
/// initial load and in run time.
///
/// Defaults to null.
///
/// See also:
/// * [SfHijriDateRangePicker.initialDisplayDate], which used to navigate the
/// date range picker to the specific date initially.
/// * [SfHijriDateRangePicker.initialSelectedDate], which allows to select date
/// programmatically initially on date range picker.
/// * [SfHijriDateRangePicker.initialSelectedDates], which allows to list of
/// select date programmatically initially on date range picker.
/// * [SfHijriDateRangePicker.initialSelectedRange], which allows to select a
/// range of dates programmatically initially on date range picker.
/// * [SfHijriDateRangePicker.initialSelectedRanges], which allows to select a
/// ranges of dates programmatically initially on date range picker.
/// * [selectedDate],which allows to select date
/// programmatically dynamically on date range picker.
/// * [selectedDates], which allows to select dates
/// programmatically dynamically on date range picker.
/// * [selectedRange], which allows to select range
/// of dates programmatically dynamically on date range picker.
/// * [selectedRanges], which allows to select
/// ranges of dates programmatically dynamically on date range picker.
/// * [SfHijriDateRangePicker.selectionMode], which allows to customize the
/// selection mode with available mode options.
/// * [SfHijriDateRangePicker.onViewChanged], the callback which notifies when
/// the current view visible date changed on the date range picker.
/// * [SfHijriDateRangePicker.onSelectionChanged], the callback which notifies
/// when the selected cell changed on the the date range picker.
/// * [SfHijriDateRangePicker.showActionButtons], which allows to cancel of
/// confirm the selection in the date range picker.
/// * [SfHijriDateRangePicker.onSubmit], the callback which notifies when the
/// selected value confirmed through confirm button on date range picker.
/// * [SfHijriDateRangePicker.onCancel], the callback which notifies when the
/// selected value canceled and reverted to previous  confirmed value through
/// cancel button on date range picker.
/// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to select a week](https://www.syncfusion.com/kb/11412/how-to-select-a-week-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to select all days when clicking on the day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
/// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
/// * Knowledge base: [How to select previous or next dates bases on selected date](https://www.syncfusion.com/kb/12354/how-to-select-previous-or-next-dates-based-on-the-selected-date-in-the-flutter-date-range)
/// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
/// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to do programmatic navigation](https://www.syncfusion.com/kb/12140/how-to-do-programmatic-navigation-using-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to programmatically navigate to adjacent dates](https://www.syncfusion.com/kb/12137/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-date-range-picker)
/// * Knowledge base: [How to programmatically navigate](https://www.syncfusion.com/kb/12135/how-to-programmatically-navigate-to-the-date-in-the-flutter-date-range-picker)
///
/// This example demonstrates how to use the [HijriDatePickerController] for
/// [SfHijriDateRangePicker].
///
/// ``` dart
///
///class MyApp extends StatefulWidget {
///  @override
///  MyAppState createState() => MyAppState();
///}
///
///class MyAppState extends State<MyApp> {
///  HijriDatePickerController _pickerController = HijriDatePickerController();
///
///  @override
///  void initState() {
///    _pickerController.selectedDates = <HijriDateTime>[
///      HijriDateTime.now().add(Duration(days: 2)),
///      HijriDateTime.now().add(Duration(days: 4)),
///      HijriDateTime.now().add(Duration(days: 7)),
///      HijriDateTime.now().add(Duration(days: 11))
///    ];
///    _pickerController.displayDate = HijriDateTime.now();
///    _pickerController.addPropertyChangedListener(handlePropertyChange);
///    super.initState();
///  }
///
///  void handlePropertyChange(String propertyName) {
///    if (propertyName == 'selectedDates') {
///      final List<HijriDateTime> selectedDates =
///                                 _pickerController.selectedDates!;
///    } else if (propertyName == 'displayDate') {
///      final HijriDateTime displayDate = _pickerController.displayDate!;
///    }
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfHijriDateRangePicker(
///          view: HijriDatePickerView.month,
///          controller: _pickerController,
///          selectionMode: DateRangePickerSelectionMode.multiple,
///        ),
///      ),
///    );
///  }
///}
///
/// ```
class HijriDatePickerController extends DateRangePickerValueChangeNotifier {
  HijriDateTime? _selectedDate;
  List<HijriDateTime>? _selectedDates;
  HijriDateRange? _selectedRange;
  List<HijriDateRange>? _selectedRanges;
  HijriDateTime? _displayDate;
  HijriDatePickerView? _view;

  /// The selected date in the [SfHijriDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.single] for other selection modes this
  /// property will return as null.
  HijriDateTime? get selectedDate => _selectedDate;

  /// Selects the given date programmatically in the [SfHijriDateRangePicker] by
  /// checking that the date falls in between the minimum and maximum date
  /// range.
  ///
  /// _Note:_ If any date selected previously, will be removed and the selection
  ///  will be drawn to the date given in this property.
  ///
  /// If it is not [null] the widget will render the date selection for the date
  /// set to this property, even the
  /// [SfHijriDateRangePicker.initialSelectedDate] is not null.
  ///
  /// It is only applicable when the [DateRangePickerSelectionMode] set as
  /// [DateRangePickerSelectionMode.single].
  ///
  /// See also:
  /// * [SfHijriDateRangePicker.initialSelectedDate], which allows to select
  /// date programmatically initially on date range picker.
  /// * [selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [SfHijriDateRangePicker.selectionMode], which allows to customize the
  /// selection mode with available mode options.
  /// * [SfHijriDateRangePicker.onSelectionChanged], the callback which notifies
  /// when the selected cell changed on the the date range picker.
  /// * [SfHijriDateRangePicker.showActionButtons], which allows to cancel of
  /// confirm the selection in the date range picker.
  /// * [SfHijriDateRangePicker.onSubmit], the callback which notifies when the
  /// selected value confirmed through confirm button on date range picker.
  /// * [SfHijriDateRangePicker.onCancel], the callback which notifies when the
  /// selected value canceled and reverted to previous  confirmed value through
  /// cancel button on date range picker.
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  /// HijriDatePickerController _pickerController = HijriDatePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.selectedDate = HijriDateTime.now().add((Duration(
  ///                                days: 4)));
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          showNavigationArrow: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedDate(HijriDateTime? date) {
    if (isSameDate(_selectedDate, date)) {
      return;
    }

    _selectedDate = date;
    notifyPropertyChangedListeners('selectedDate');
  }

  /// The list of dates selected in the [SfHijriDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiple] for other selection modes
  /// this property will return as null.
  List<HijriDateTime>? get selectedDates => _selectedDates;

  /// Selects the given dates programmatically in the [SfHijriDateRangePicker]
  /// by checking that the dates falls in between the minimum and maximum date
  /// range.
  ///
  /// _Note:_ If any list of dates selected previously, will be removed and the
  /// selection will be drawn to the dates set to this property.
  ///
  /// If it is not [null] the widget will render the date selection for the
  /// dates set to this property, even the
  /// [SfHijriDateRangePicker.initialSelectedDates] is not null.
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiple].
  ///
  /// See also:
  /// * [SfHijriDateRangePicker.initialSelectedDates], which allows to list of
  /// select date programmatically initially on date range picker.
  /// * [selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [SfHijriDateRangePicker.selectionMode], which allows to customize the
  /// selection mode with available mode options.
  /// * [SfHijriDateRangePicker.onSelectionChanged], the callback which notifies
  /// when the selected cell changed on the the date range picker.
  /// * [SfHijriDateRangePicker.showActionButtons], which allows to cancel of
  /// confirm the selection in the date range picker.
  /// * [SfHijriDateRangePicker.onSubmit], the callback which notifies when the
  /// selected value confirmed through confirm button on date range picker.
  /// * [SfHijriDateRangePicker.onCancel], the callback which notifies when the
  /// selected value canceled and reverted to previous  confirmed value through
  /// cancel button on date range picker.
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select a week](https://www.syncfusion.com/kb/11412/how-to-select-a-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select previous or next dates bases on selected date](https://www.syncfusion.com/kb/12354/how-to-select-previous-or-next-dates-based-on-the-selected-date-in-the-flutter-date-range)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  /// HijriDatePickerController _pickerController = HijriDatePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.selectedDates = <HijriDateTime>[
  ///      HijriDateTime.now().add((Duration(days: 4))),
  ///      HijriDateTime.now().add((Duration(days: 7))),
  ///      HijriDateTime.now().add((Duration(days: 8)))
  ///    ];
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedDates(List<HijriDateTime>? dates) {
    if (DateRangePickerHelper.isDateCollectionEquals(_selectedDates, dates)) {
      return;
    }

    _selectedDates =
        DateRangePickerHelper.cloneList(dates)!.cast<HijriDateTime>();
    notifyPropertyChangedListeners('selectedDates');
  }

  /// selected date range in the [SfHijriDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.range] for other selection modes this
  /// property will return as null.
  HijriDateRange? get selectedRange => _selectedRange;

  /// Selects the given date range programmatically in the
  /// [SfHijriDateRangePicker] by checking that the range of dates falls in
  /// between the minimum and maximum date range.
  ///
  /// _Note:_ If any date range selected previously, will be removed and the
  /// selection will be drawn to the range of dates set to this property.
  ///
  /// If it is not [null] the widget will render the date selection for the
  /// range set to this property, even the
  /// [SfHijriDateRangePicker.initialSelectedRange] is not null.
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [HijriDateRangePickerSelectionMode.range].
  ///
  /// See also:
  /// * [SfHijriDateRangePicker.initialSelectedRange], which allows to select a
  /// range of dates programmatically initially on date range picker.
  /// * [selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [SfHijriDateRangePicker.selectionMode], which allows to customize the
  /// selection mode with available mode options.
  /// * [SfHijriDateRangePicker.onSelectionChanged], the callback which notifies
  /// when the selected cell changed on the the date range picker.
  /// * [SfHijriDateRangePicker.showActionButtons], which allows to cancel of
  /// confirm the selection in the date range picker.
  /// * [SfHijriDateRangePicker.onSubmit], the callback which notifies when the
  /// selected value confirmed through confirm button on date range picker.
  /// * [SfHijriDateRangePicker.onCancel], the callback which notifies when the
  /// selected value canceled and reverted to previous  confirmed value through
  /// cancel button on date range picker.
  /// * Knowledge base: [How to select a week](https://www.syncfusion.com/kb/11412/how-to-select-a-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select previous or next dates bases on selected date](https://www.syncfusion.com/kb/12354/how-to-select-previous-or-next-dates-based-on-the-selected-date-in-the-flutter-date-range)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  /// HijriDatePickerController _pickerController = HijriDatePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.selectedRange = HijriDateRange(
  ///        HijriDateTime.now().add(Duration(days: 4)),
  ///        HijriDateTime.now().add(Duration(days: 5)));
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedRange(HijriDateRange? range) {
    if (DateRangePickerHelper.isRangeEquals(_selectedRange, range)) {
      return;
    }

    _selectedRange = range;
    notifyPropertyChangedListeners('selectedRange');
  }

  /// List of selected ranges in the [SfHijriDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiRange] for other selection modes
  /// this property will return as null.
  List<HijriDateRange>? get selectedRanges => _selectedRanges;

  /// Selects the given date ranges programmatically in the
  /// [SfHijriDateRangePicker] by checking that the ranges of dates falls in
  /// between the minimum and maximum date range.
  ///
  /// If it is not [null] the widget will render the date selection for the
  /// ranges set to this property, even the
  /// [SfHijriDateRangePicker.initialSelectedRanges] is not null.
  ///
  /// _Note:_ If any date ranges selected previously, will be removed and the
  /// selection will be drawn to the ranges of dates set to this property.
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// See also:
  /// * [SfHijriDateRangePicker.initialSelectedRanges], which allows to select a
  /// ranges of dates programmatically initially on date range picker.
  /// * [selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [SfHijriDateRangePicker.selectionMode], which allows to customize the
  /// selection mode with available mode options.
  /// * [SfHijriDateRangePicker.onSelectionChanged], the callback which notifies
  /// when the selected cell changed on the the date range picker.
  /// * [SfHijriDateRangePicker.showActionButtons], which allows to cancel of
  /// confirm the selection in the date range picker.
  /// * [SfHijriDateRangePicker.onSubmit], the callback which notifies when the
  /// selected value confirmed through confirm button on date range picker.
  /// * [SfHijriDateRangePicker.onCancel], the callback which notifies when the
  /// selected value canceled and reverted to previous  confirmed value through
  /// cancel button on date range picker.
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select a week](https://www.syncfusion.com/kb/11412/how-to-select-a-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select previous or next dates bases on selected date](https://www.syncfusion.com/kb/12354/how-to-select-previous-or-next-dates-based-on-the-selected-date-in-the-flutter-date-range)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  /// HijriDatePickerController _pickerController = HijriDatePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.selectedRanges = <HijriDateRange>[
  ///      HijriDateRange(HijriDateTime.now().subtract(Duration(days: 4)),
  ///          HijriDateTime.now().add(Duration(days: 4))),
  ///      HijriDateRange(HijriDateTime.now().add(Duration(days: 11)),
  ///          HijriDateTime.now().add(Duration(days: 16)))
  ///    ];
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedRanges(List<HijriDateRange>? ranges) {
    if (DateRangePickerHelper.isDateRangesEquals(_selectedRanges, ranges)) {
      return;
    }

    _selectedRanges =
        DateRangePickerHelper.cloneList(ranges)!.cast<HijriDateRange>();
    notifyPropertyChangedListeners('selectedRanges');
  }

  /// The first date of the current visible view month, when the
  /// [HijriDatePickerMonthViewSettings.numberOfWeeksInView] set with
  /// default value 6.
  ///
  /// If the [HijriDatePickerMonthViewSettings.numberOfWeeksInView]
  /// property set with value other then 6, this will return the first visible
  /// date of the current month.
  HijriDateTime? get displayDate => _displayDate;

  /// Navigates to the given date programmatically without any animation in the
  /// [SfHijriDateRangePicker] by checking that the date falls in between the
  /// [SfHijriDateRangePicker.minDate] and [SfHijriDateRangePicker.maxDate]
  /// date range.
  ///
  /// If the date falls beyond the [SfHijriDateRangePicker.minDate] and
  /// [SfHijriDateRangePicker.maxDate] the widget will move the widgets min or
  /// max date.
  ///
  /// See also:
  /// * [SfHijriDateRangePicker.initialDisplayDate], which used to navigate the
  /// date range picker to the specific date initially.
  /// * [SfHijriDateRangePicker.onViewChanged], the callback which notifies when
  /// the current view visible date changed on the date range picker.
  /// * Knowledge base: [How to do programmatic navigation](https://www.syncfusion.com/kb/12140/how-to-do-programmatic-navigation-using-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically navigate to adjacent dates](https://www.syncfusion.com/kb/12137/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically navigate](https://www.syncfusion.com/kb/12135/how-to-programmatically-navigate-to-the-date-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  /// HijriDatePickerController _pickerController = HijriDatePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.displayDate = HijriDateTime(2022, 02, 05);
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set displayDate(HijriDateTime? date) {
    if (isSameDate(_displayDate, date)) {
      return;
    }

    _displayDate = date;
    notifyPropertyChangedListeners('displayDate');
  }

  /// The current visible [HijriDatePickerView] of
  /// [SfHijriDateRangePicker].
  HijriDatePickerView? get view => _view;

  /// Set the [HijriDatePickerView] for the [SfHijriDateRangePicker].
  ///
  ///
  /// The [SfHijriDateRangePicker] will display the view sets to this property.
  ///
  /// See also:
  /// * [SfHijriDateRangePicker.view], which used to display the required view
  /// on the date range picker initially.
  /// * [SfHijriDateRangePicker.onViewChanged], the callback which notifies when
  /// the current view visible date changed on the date range picker.
  /// * [HijriDatePickerView], to know more about the available view options in
  /// the hijri date range picker.
  /// * Knowledge base: [How to do programmatic navigation](https://www.syncfusion.com/kb/12140/how-to-do-programmatic-navigation-using-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically navigate to adjacent dates](https://www.syncfusion.com/kb/12137/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically navigate](https://www.syncfusion.com/kb/12135/how-to-programmatically-navigate-to-the-date-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// class MyAppState extends State<MyApp> {
  /// HijriDatePickerController _pickerController = HijriDatePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.view = HijriDatePickerView.year;
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///       ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set view(HijriDatePickerView? value) {
    if (_view == value) {
      return;
    }

    _view = value;
    notifyPropertyChangedListeners('view');
  }

  /// Moves to the next view programmatically with animation by checking that
  /// the next view dates falls between the minimum and maximum date range.
  ///
  /// _Note:_ If the current view has the maximum date range, it will not move
  /// to the next view.
  ///
  /// See also:
  /// * [SfHijriDateRangePicker.showNavigationArrow], which allows to display
  /// the navigation arrows on the header view of the date range picker.
  /// * [backward], which used to navigate to the previous view of the date
  /// range picker programmatically.
  /// * [SfHijriDateRangePicker.onViewChanged], the callback which notifies when
  /// the current view visible date changed on the date range picker.
  /// * Knowledge base: [How to do programmatic navigation](https://www.syncfusion.com/kb/12140/how-to-do-programmatic-navigation-using-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically navigate to adjacent dates](https://www.syncfusion.com/kb/12137/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically navigate](https://www.syncfusion.com/kb/12135/how-to-programmatically-navigate-to-the-date-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// class MyApp extends StatefulWidget {
  ///  @override
  ///  MyAppState createState() => MyAppState();
  ///}
  ///
  ///class MyAppState extends State<MyApp> {
  /// HijriDatePickerController _pickerController = HijriDatePickerController();
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///          actions: <Widget>[
  ///            IconButton(
  ///              icon: Icon(Icons.arrow_forward),
  ///              onPressed: () {
  ///                _pickerController.forward!();
  ///              },
  ///            )
  ///          ],
  ///          title: Text('Date Range Picker Demo'),
  ///          leading: IconButton(
  ///            icon: Icon(Icons.arrow_back),
  ///            onPressed: () {
  ///              _pickerController.backward!();
  ///            },
  ///          ),
  ///        ),
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  VoidCallback? forward;

  /// Moves to the previous view programmatically with animation by checking
  /// that the previous view dates falls between the minimum and maximum date
  /// range.
  ///
  /// _Note:_ If the current view has the minimum date range, it will not move
  /// to the previous view.
  ///
  /// See also:
  /// * [SfHijriDateRangePicker.showNavigationArrow], which allows to display
  /// the navigation arrows on the header view of the date range picker.
  /// * [forward], which used to navigate to the next view of the date
  /// range picker programmatically.
  /// * [SfHijriDateRangePicker.onViewChanged], the callback which notifies when
  /// the current view visible date changed on the date range picker.
  /// * Knowledge base: [How to do programmatic navigation](https://www.syncfusion.com/kb/12140/how-to-do-programmatic-navigation-using-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically navigate to adjacent dates](https://www.syncfusion.com/kb/12137/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically navigate](https://www.syncfusion.com/kb/12135/how-to-programmatically-navigate-to-the-date-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// class MyApp extends StatefulWidget {
  ///  @override
  ///  MyAppState createState() => MyAppState();
  ///}
  ///
  ///class MyAppState extends State<MyApp> {
  /// HijriDatePickerController _pickerController = HijriDatePickerController();
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///          actions: <Widget>[
  ///            IconButton(
  ///              icon: Icon(Icons.arrow_forward),
  ///              onPressed: () {
  ///                _pickerController.forward!();
  ///              },
  ///            )
  ///          ],
  ///          title: Text('Date Range Picker Demo'),
  ///          leading: IconButton(
  ///            icon: Icon(Icons.arrow_back),
  ///            onPressed: () {
  ///              _pickerController.backward!();
  ///            },
  ///          ),
  ///        ),
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  VoidCallback? backward;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<HijriDateTime>('displayDate', displayDate));
    properties
        .add(DiagnosticsProperty<HijriDateTime>('selectedDate', selectedDate));
    properties.add(IterableDiagnostics<HijriDateTime>(selectedDates)
        .toDiagnosticsNode(name: 'selectedDates'));
    properties.add(
        DiagnosticsProperty<HijriDateRange>('selectedRange', selectedRange));
    properties.add(IterableDiagnostics<HijriDateRange>(selectedRanges)
        .toDiagnosticsNode(name: 'selectedRanges'));
    properties.add(EnumProperty<HijriDatePickerView>('view', view));
  }
}

/// Available views for [SfHijriDateRangePicker].
///
/// See also:
/// * [DateRangePickerView], which used to set different views for date range
/// picker.
enum HijriDatePickerView {
  /// - HijriDatePickerView.month, Displays the month view.
  month,

  /// - HijriDatePickerView.year, Displays the year view.
  year,

  /// - HijriDatePickerView.decade, Displays the decade view.
  decade,
}

/// The dates that visible on the view changes in [SfHIjriDateRangePicker].
///
/// Details for [HijriDatePickerViewChangedCallback], such as
/// [visibleDateRange] and [view].
///
/// See also:
/// * [SfHijriDateRangePicker.onViewChanged], which receives the information.
/// * [SfHijriDateRangePicker], which passes the information to one of its
/// receiver.
/// * [HijriDatePickerViewChangedCallback], signature when the current visible
/// dates changed in date range picker.
@immutable
class HijriDatePickerViewChangedArgs {
  /// Creates details for [DateRangePickerViewChangedCallback].
  const HijriDatePickerViewChangedArgs(this.visibleDateRange, this.view);

  /// The date range of the currently visible view dates.
  ///
  /// See also: [HijriDateRange].
  final HijriDateRange visibleDateRange;

  /// The currently visible [HijriDatePickerView] in the
  /// [SfHijriDateRangePicker].
  ///
  /// See also: [HijriDatePickerView].
  final HijriDatePickerView view;
}

/// Defines a range of dates, covers the dates in between the given [startDate]
/// and [endDate] as a range.
///
/// See also:
/// * [PickerDateRange], which is used to store the range value for hijri date
/// range picker.
/// * [DateRangePickerSelectionMode], which is used to handle different
/// available selection modes in date range picker.
/// * [SfHijriDateRangePicker.initialSelectedRange], which allows to select a
/// range of dates programmatically initially on date range picker.
/// * [SfHijriDateRangePicker.initialSelectedRanges], which allows to select a
/// ranges of dates programmatically initially on date range picker.
/// * [HijriDatePickerController.selectedRange], which allows to select range
/// of dates programmatically dynamically on date range picker.
/// * [HijriDatePickerController.selectedRanges], which allows to select
@immutable
class HijriDateRange with Diagnosticable {
  /// Creates a picker date range with the given start and end date.
  const HijriDateRange(this.startDate, this.endDate);

  /// The start date of the range.
  final HijriDateTime? startDate;

  /// The end date of the range.
  final HijriDateTime? endDate;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<HijriDateTime>('startDate', startDate));
    properties.add(DiagnosticsProperty<HijriDateTime>('endDate', endDate));
  }
}

/// Signature for a function that creates a widget based on date range picker
/// cell details.
///
/// See also:
/// * [SfHijriDateRangePicker.cellBuilder], which matches this signature.
/// * [SfHijriDateRangePicker], which uses this signature in one of it's
/// callback.
typedef HijriDateRangePickerCellBuilder = Widget Function(
    BuildContext context, HijriDateRangePickerCellDetails cellDetails);

/// Signature for predicating dates for enabled date selections.
///
/// [SelectableDayPredicate] parameter used to specify allowable days in the
/// SfHijriDateRangePicker.
typedef HijriDatePickerSelectableDayPredicate = bool Function(
    HijriDateTime date);

/// Contains the details that needed on calendar cell builder.
///
/// See also:
/// * [SfHijriDateRangePicker.cellBuilder], which matches this signature.
/// * [SfHijriDateRangePicker], which uses this signature in one of it's
/// callback.
class HijriDateRangePickerCellDetails {
  /// Constructor to store the details that needed on calendar cell builder.
  HijriDateRangePickerCellDetails(
      {required this.date, required this.bounds, required this.visibleDates});

  /// Date value associated with the picker cell in month, year, decade and
  /// century views.
  final HijriDateTime date;

  /// Position and size of the widget.
  final Rect bounds;

  /// Visible dates value associated with the current picker month, year,
  /// decade and century views. It is used to get the cell, leading and
  /// trailing dates details.
  final List<HijriDateTime> visibleDates;
}
