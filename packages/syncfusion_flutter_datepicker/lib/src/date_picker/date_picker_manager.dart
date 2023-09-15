import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import '../../datepicker.dart';
import 'picker_helper.dart';

/// Sets the style for customizing the [SfDateRangePicker] header view.
///
/// Allows to customize the [textStyle], [textAlign] and [backgroundColor] of
/// the header view in [SfDateRangePicker].
///
/// See also:
/// * [DateRangePickerMonthViewSettings], which allows to customize the month
/// view of the date range picker.
/// * [DateRangePickerViewHeaderStyle], which allows to customize the view
/// header view of the month view in date range picker.
/// * [SfDateRangePicker.headerHeight], which is the size of the header view in
/// the date range picker.
/// * [SfDateRangePicker.showNavigationArrow], which displays the navigation
/// arrows on the header view of the date range picker.
/// * [SfDateRangePicker.monthFormat], which allows to customize the month text
/// in the header view also in the year cell view of date range picker.
/// * Knowledge base: [How to style a header](https://www.syncfusion.com/kb/12342/how-to-style-a-header-in-the-flutter-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to select all days when clicking on the day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
/// * Knowledge base: [How to restrict the year view navigation when tapping on header view](https://www.syncfusion.com/kb/12113/how-to-restrict-the-year-view-navigation-while-tapping-header-of-the-flutter-date-range)
/// * Knowledge base: [How to customize the header in Flutter multi date range picker](https://www.syncfusion.com/kb/11897/how-to-customize-the-header-in-the-flutter-multi-date-range-picker-sfdaterangepicker)
/// * Knowledge base: [How to customize the header view](https://www.syncfusion.com/kb/11427/how-to-customize-the-header-view-of-the-flutter-date-range-picker)
///
/// ``` dart
/// Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfDateRangePicker(
///          view: DateRangePickerView.month,
///          headerStyle: DateRangePickerHeaderStyle(
///            textAlign: TextAlign.left,
///            textStyle: TextStyle(
///                color: Colors.blue, fontSize: 18,
///                     fontWeight: FontWeight.w400),
///            backgroundColor: Colors.grey,
///          ),
///        ),
///      ),
///    );
///  }
///
/// ```
@immutable
class DateRangePickerHeaderStyle with Diagnosticable {
  /// Creates a header style for date range picker.
  const DateRangePickerHeaderStyle(
      {this.textAlign = TextAlign.left, this.backgroundColor, this.textStyle});

  /// The text style for the text in the [SfDateRangePicker] header view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [SfDateRangePicker.monthFormat], which allows to customize the month
  /// text in the header view also in the year cell view of date range picker.
  /// * [textAlign], which aligns the text in the header view of the date
  /// range picker.
  /// * [textStyle], which fills the background of the header view in the date
  /// range picker.
  /// * Knowledge base: [How to style a header](https://www.syncfusion.com/kb/12342/how-to-style-a-header-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the header view](https://www.syncfusion.com/kb/11427/how-to-customize-the-header-view-of-the-flutter-date-range-picker)
  ///
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///            controller: _pickerController,
  ///            view: DateRangePickerView.month,
  ///            selectionMode: DateRangePickerSelectionMode.single,
  ///            headerStyle: DateRangePickerHeaderStyle(
  ///              textStyle: TextStyle(
  ///                  color: Colors.blue,
  ///                  fontSize: 18,
  ///                  fontWeight: FontWeight.w400),
  ///            )),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? textStyle;

  /// How the text should  be aligned horizontally in [SfDateRangePicker] header
  /// view.
  ///
  /// Defaults to `TextAlign.left`.
  ///
  /// See also:
  /// * [textStyle], which allows to set style for the header text in the
  /// date range picker.
  /// * [SfDateRangePicker.showNavigationArrow], which displays the navigation
  /// arrows on the header view of the date range picker.
  /// * [SfDateRangePicker.monthFormat], which allows to customize the month
  /// text in the header view also in the year cell view of date range picker.
  /// * Knowledge base: [How to style a header](https://www.syncfusion.com/kb/12342/how-to-style-a-header-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the header view](https://www.syncfusion.com/kb/11427/how-to-customize-the-header-view-of-the-flutter-date-range-picker)
  /// * Knowledge base: [How to navigate to the previous or next dates using navigation arrows](https://www.syncfusion.com/kb/12270/how-to-navigate-to-the-previous-or-next-views-using-navigation-arrows-in-the-flutter-date)
  ///
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///            controller: _pickerController,
  ///            view: DateRangePickerView.month,
  ///            selectionMode: DateRangePickerSelectionMode.single,
  ///            headerStyle: DateRangePickerHeaderStyle(
  ///              textAlign: TextAlign.right,
  ///            )),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextAlign textAlign;

  /// The color which fills the [SfDateRangePicker] header view background.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [SfDateRangePicker.monthFormat], which allows to customize the month
  /// text in the header view also in the year cell view of date range picker.
  /// * [textAlign], which aligns the text in the header view of the date
  /// range picker.
  /// * [textStyle], which fills the background of the header view in the date
  /// range picker.
  /// * Knowledge base: [How to style a header](https://www.syncfusion.com/kb/12342/how-to-style-a-header-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the header view](https://www.syncfusion.com/kb/11427/how-to-customize-the-header-view-of-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///            controller: _pickerController,
  ///            view: DateRangePickerView.month,
  ///            selectionMode: DateRangePickerSelectionMode.single,
  ///            headerStyle: DateRangePickerHeaderStyle(
  ///              backgroundColor: Colors.grey,
  ///            )),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? backgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final DateRangePickerHeaderStyle otherStyle;
    if (other is DateRangePickerHeaderStyle) {
      otherStyle = other;
    }
    return otherStyle.textStyle == textStyle &&
        otherStyle.textAlign == textAlign &&
        otherStyle.backgroundColor == backgroundColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
  }

  @override
  int get hashCode {
    return Object.hash(
      textStyle,
      textAlign,
      backgroundColor,
    );
  }
}

/// Sets the style to customize [SfDateRangePicker] month view view header.
///
/// Allows to customize the [textStyle] and [backgroundColor] of the view header
/// view in month view of [SfDateRangePicker].
///
/// See also:
/// * [DateRangePickerHeaderStyle], which used to customize the header view of
/// the date range picker.
/// * [SfDateRangePicker.todayHighlightColor], which highlights the today date
/// in the date range picker.
/// * [DateRangePickerMonthViewSettings.viewHeaderHeight], which is the size
/// for the view header view in date range picker.
/// * Knowledge base: [How to replace the view header with the custom widget](https://www.syncfusion.com/kb/12098/how-to-replace-the-view-header-with-the-custom-widget-in-flutter-date-range-picker)
///
/// ```dart
///
/// Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfDateRangePicker(
///          controller: _pickerController,
///          view: DateRangePickerView.month,
///          selectionMode: DateRangePickerSelectionMode.single,
///          monthViewSettings: DateRangePickerMonthViewSettings(
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
@immutable
class DateRangePickerViewHeaderStyle with Diagnosticable {
  /// creates a view header style for month view in [SfDateRangePicker].
  const DateRangePickerViewHeaderStyle({this.backgroundColor, this.textStyle});

  /// The color which fills the background of [SfDateRangePicker] view header in
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [textStyle], which used to style the text in the view header view of the
  /// month view in date range picker.
  /// * [DateRangePickerMonthViewSettings.viewHeaderHeight], which is the size
  /// for the view header view in date range picker.
  /// * [SfDateRangePicker.todayHighlightColor], which highlights the today date
  /// in the date range picker.
  /// * Knowledge base: [How to replace the view header with the custom widget](https://www.syncfusion.com/kb/12098/how-to-replace-the-view-header-with-the-custom-widget-in-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          monthViewSettings: DateRangePickerMonthViewSettings(
  ///              viewHeaderStyle:
  ///                 DateRangePickerViewHeaderStyle(
  ///                       backgroundColor: Colors.red)),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? backgroundColor;

  /// The text style for the text in the [SfDateRangePicker] view header view of
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [backgroundColor], which fills the background of the view header view
  /// in the date range picker.
  /// * [DateRangePickerMonthViewSettings.viewHeaderHeight], which is the size
  /// for the view header view in date range picker.
  /// * [SfDateRangePicker.todayHighlightColor], which highlights the today date
  /// in the date range picker.
  /// * Knowledge base: [How to replace the view header with the custom widget](https://www.syncfusion.com/kb/12098/how-to-replace-the-view-header-with-the-custom-widget-in-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          monthViewSettings: DateRangePickerMonthViewSettings(
  ///              viewHeaderStyle: DateRangePickerViewHeaderStyle(
  ///                  textStyle: TextStyle(
  ///                      fontWeight: FontWeight.w500,
  ///                      fontStyle: FontStyle.italic,
  ///                      fontSize: 20,
  ///                      color: Colors.white))),
  ///        ),
  ///      ),
  ///    );
  /// }
  ///
  /// ```
  final TextStyle? textStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final DateRangePickerViewHeaderStyle otherStyle;
    if (other is DateRangePickerViewHeaderStyle) {
      otherStyle = other;
    }
    return otherStyle.backgroundColor == backgroundColor &&
        otherStyle.textStyle == textStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
  }

  @override
  int get hashCode {
    return Object.hash(
      backgroundColor,
      textStyle,
    );
  }
}

/// Sets the style to customize the week number of [SfDateRangePicker].
///
/// Allows to customize the [backgroundColor], [textStyle]
/// week number in month view of date Range Picker.
///
/// See also:
/// * [DateRangePickerMonthViewSettings], which is used to customize the month
/// view of the date range picker.
/// * [HijriDatePickerMonthViewSettings], which is used to customize the month
/// view of the hijri date range picker.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///   body: SfDateRangePicker(
///     view: DateRangePickerView.month,
///     monthViewSettings: const DateRangePickerMonthViewSettings(
///     showWeekNumber: true,
///     weekNumberStyle: const DateRangePickerWeekNumberStyle(
///         textStyle: TextStyle(fontStyle: FontStyle.italic),
///         backgroundColor: Colors.purple),
///     ),
///   ),
///  );
/// }
///
/// ```
@immutable
class DateRangePickerWeekNumberStyle with Diagnosticable {
  /// Creates a week number style for month view in [SfDateRangePicker].
  ///
  /// The properties allows to customize the week number [SfDateRangePicker].
  const DateRangePickerWeekNumberStyle({this.textStyle, this.backgroundColor});

  /// The color which fills the background of [SfDateRangePicker] view header in
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [textStyle], which used to customize the style for the text in the
  /// week number view of month view in date range picker.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///   body: SfDateRangePicker(
  ///     view: DateRangePickerView.month,
  ///     monthViewSettings: const DateRangePickerMonthViewSettings(
  ///     showWeekNumber: true,
  ///     weekNumberStyle: const DateRangePickerWeekNumberStyle(
  ///         textStyle: TextStyle(fontStyle: FontStyle.italic),
  ///         backgroundColor: Colors.purple),
  ///     ),
  ///   ),
  ///  );
  /// }
  ///
  /// ```
  final Color? backgroundColor;

  /// The text style for the text in the [SfDateRangePicker] view header view of
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [backgroundColor], which fills the background of the week number view in
  /// the date range picker.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///   body: SfDateRangePicker(
  ///     view: DateRangePickerView.month,
  ///     monthViewSettings: const DateRangePickerMonthViewSettings(
  ///     showWeekNumber: true,
  ///     weekNumberStyle: const DateRangePickerWeekNumberStyle(
  ///         textStyle: TextStyle(fontStyle: FontStyle.italic),
  ///         backgroundColor: Colors.purple),
  ///     ),
  ///   ),
  ///  );
  /// }
  ///
  /// ```
  final TextStyle? textStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final DateRangePickerWeekNumberStyle otherStyle;
    if (other is DateRangePickerWeekNumberStyle) {
      otherStyle = other;
    }
    return otherStyle.textStyle == textStyle &&
        otherStyle.backgroundColor == backgroundColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }

  @override
  int get hashCode {
    return Object.hash(
      textStyle,
      backgroundColor,
    );
  }
}

/// The settings have properties which allow to customize the month view of the
/// [SfDateRangePicker].
///
/// Allows to customize the [numberOfWeeksInView], [firstDayOfWeek],
/// [dayFormat], [viewHeaderHeight], [showTrailingAndLeadingDates],
/// [viewHeaderStyle], [enableSwipeSelection], [blackoutDates], [specialDates]
/// and [weekendDays] in month view of date range picker.
///
/// See also:
/// * [HijriDatePickerMonthViewSettings], which used to customize the month view
/// of the hijri date range picker.
/// * [DateRangePickerMonthCellStyle], which used to customize the month cell of
/// the month view in the date range picker.
/// * [HijriDatePickerMonthCellStyle], which used to customize the month cell of
/// the month view in the hijri date range picker.
/// * [SfDateRangePicker.cellBuilder],which allows to set custom widget for the
/// picker cells in the date range picker.
/// * [DateRangePickerYearCellStyle], which allows to customize the year cell of
///  the year, decade and century views of the date range picker.
/// * [SfDateRangePicker.backgroundColor], which fills the background of the
/// date range picker.
/// * [SfDateRangePicker.todayHighlightColor], which highlights the today date
/// cell in the date range picker.
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
///        body: SfDateRangePicker(
///          view: DateRangePickerView.month,
///          monthViewSettings: DateRangePickerMonthViewSettings(
///              numberOfWeeksInView: 5,
///              firstDayOfWeek: 1,
///              dayFormat: 'E',
///              viewHeaderHeight: 70,
///              selectionRadius: 10,
///              showTrailingAndLeadingDates: true,
///              viewHeaderStyle: DateRangePickerViewHeaderStyle(
///                  backgroundColor: Colors.blue,
///                  textStyle:
///                      TextStyle(fontWeight: FontWeight.w400, fontSize: 15,
///                           color: Colors.black)),
///              enableSwipeSelection: false,
///              blackoutDates: <DateTime>[
///                DateTime.now().add(Duration(days: 4))
///              ],
///              specialDates: <DateTime>[
///                DateTime.now().add(Duration(days: 7)),
///                DateTime.now().add(Duration(days: 8))
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
class DateRangePickerMonthViewSettings with Diagnosticable {
  /// Creates a date range picker month view settings for date range picker.
  ///
  /// The properties allows to customize the month view of [SfDateRangePicker].
  const DateRangePickerMonthViewSettings(
      {this.numberOfWeeksInView = 6,
      this.firstDayOfWeek = 7,
      this.dayFormat = 'EE',
      this.viewHeaderHeight = 30,
      @Deprecated('Use selectionRadius property in SfDateRangePicker')
      // ignore: deprecated_member_use, deprecated_member_use_from_same_package
      this.selectionRadius = -1,
      this.showTrailingAndLeadingDates = false,
      this.viewHeaderStyle = const DateRangePickerViewHeaderStyle(),
      this.enableSwipeSelection = true,
      this.blackoutDates,
      this.specialDates,
      this.weekendDays = const <int>[6, 7],
      this.showWeekNumber = false,
      this.weekNumberStyle = const DateRangePickerWeekNumberStyle()})
      : assert(numberOfWeeksInView >= 1 && numberOfWeeksInView <= 6),
        assert(firstDayOfWeek >= 1 && firstDayOfWeek <= 7),
        assert(viewHeaderHeight >= -1);

  /// Formats a text in the [SfDateRangePicker] month view view header.
  ///
  /// Text format in the [SfDateRangePicker] month view view header.
  ///
  /// Defaults to `EE`.
  ///
  /// See also:
  /// * [viewHeaderStyle], which used to customize the view header view of the
  /// date range picker.
  /// * [SfDateRangePicker.backgroundColor], which fills the background of the
  /// date range picker.
  /// * [SfDateRangePicker.todayHighlightColor], which highlights the today date
  /// in the date range picker.
  /// * [viewHeaderHeight], which is the size for the view header view in the
  /// month view of date range picker.
  /// * Knowledge base: [How to replace the view header with the custom widget](https://www.syncfusion.com/kb/12098/how-to-replace-the-view-header-with-the-custom-widget-in-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          monthViewSettings: DateRangePickerMonthViewSettings(
  ///               dayFormat: 'EEE'),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final String dayFormat;

  /// The number of weeks to display in [SfDateRangePicker]'s month view.
  ///
  /// Defaults to `6`.
  ///
  /// _Note:_ If this property is set to a value other than ' 6, ' the trailing
  /// and lead dates style will not be updated and the trailing and leading
  /// dates will be displayed even if the [showTrailingAndLeadingDates] property
  /// is set to [false].
  ///
  /// This property not applicable when the [SfDateRangePicker.pickerMode] set
  ///  as [DateRangePickerMode.hijri].
  ///
  /// See also: [DateRangePickerMonthCellStyle] to know about leading and
  /// trailing dates style.
  ///
  /// See also:
  /// * [showTrailingAndLeadingDates], which used to display the previous month
  /// and next month dates on the month view of the date range picker.
  /// * [firstDayOfWeek], which used to customize the week start day of the
  /// month view in date range picker.
  /// * Knowledge base: [How to change the number of weeks](https://www.syncfusion.com/kb/12167/how-to-change-the-number-of-weeks-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to create timeline date picker](https://www.syncfusion.com/kb/12474/how-to-create-timeline-date-picker-in-flutter)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          monthViewSettings:
  ///              DateRangePickerMonthViewSettings(numberOfWeeksInView: 4),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final int numberOfWeeksInView;

  /// Enables the swipe selection for [SfDateRangePicker], which allows to
  /// select the range of dates by swiping on the dates.
  ///
  /// If it is [false] selecting a two different dates will form the range of
  /// dates by covering the dates between the selected dates.
  ///
  /// Defaults to `true`.
  ///
  /// _Note:_ It is only applicable when the [DateRangePickerSelectionMode] set
  /// as [DateRangePickerSelectionMode.range] or
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// See also:
  /// * [DateRangePickerSelectionMode], which contains different selection modes
  /// for the date range picker.
  /// * [SfDateRangePicker.enableMultiView], which displays two date range
  /// picker side by side based on the [SfDateRangePicker.navigationDirection]
  /// value.
  /// * Knowledge base: [How to restrict swipe gesture for range selection](https://www.syncfusion.com/kb/12117/how-to-restrict-swipe-gesture-for-range-selection-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              DateRangePickerMonthViewSettings(
  ///                   enableSwipeSelection: false),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool enableSwipeSelection;

  /// The first day of the week in the [SfDateRangePicker] month view.
  ///
  /// Allows you to change the first day of the week in the month view,
  /// every month view will start from the day set to that property.
  ///
  /// Defaults to `7` which indicates `DateTime.sunday`.
  ///
  /// See also:
  /// * [showWeekNumber], which displays the week number of the year in the
  /// month view of the date range picker.
  /// * [showTrailingAndLeadingDates], which used to display the previous month
  /// and next month dates on the month view of the date range picker.
  /// * [numberOfWeeksInView], which used to customize the displaying week count
  /// in the month view of date range picker.
  /// * Knowledge base: [How to change the first day of week](https://www.syncfusion.com/kb/12221/how-to-change-the-first-day-of-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              DateRangePickerMonthViewSettings(firstDayOfWeek: 2),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final int firstDayOfWeek;

  /// Sets the style to customize [SfDateRangePicker] month view view header.
  ///
  /// Allows to customize the [textStyle] and [backgroundColor] of the view
  /// header view in month view of [SfDateRangePicker].
  ///
  /// See also:
  /// * [DateRangePickerViewHeaderStyle], to know more about the available
  /// option for customize the view header view of month view.
  /// * [viewHeaderHeight], which is the size for the view header view in the
  /// month view of date range picker.
  /// * [dayFormat], which is used to customize the format of the view header
  /// text in the month view of date range picker.
  /// * [SfDateRangePicker.todayHighlightColor], which highlights the today date
  /// cell in the date range picker.
  /// * Knowledge base: [How to replace the view header with the custom widget](https://www.syncfusion.com/kb/12098/how-to-replace-the-view-header-with-the-custom-widget-in-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          monthViewSettings: DateRangePickerMonthViewSettings(
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
  /// [SfDateRangePicker].
  ///
  /// Defaults to `30`.
  ///
  /// ![view header with height as 100](https://help.syncfusion.com/flutter/daterangepicker/images/headers/viewheaderheight.png)
  ///
  /// See also:
  /// * [viewHeaderStyle], which used to customize the view header view of the
  /// month view in date range picker.
  /// * [dayFormat], which is used to customize the format of the view header
  /// text in the month view of date range picker.
  /// * [SfDateRangePicker.todayHighlightColor], which highlights the today date
  /// cell in the date range picker.
  /// * Knowledge base: [How to replace the view header with the custom widget](https://www.syncfusion.com/kb/12098/how-to-replace-the-view-header-with-the-custom-widget-in-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              DateRangePickerMonthViewSettings(viewHeaderHeight: 50),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double viewHeaderHeight;

  /// The radius for the [SfDateRangePicker] selection circle in month view.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ This only applies if the [DateRangePickerSelectionMode] is set
  /// to [DateRangePickerSelectionMode.circle].
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              DateRangePickerMonthViewSettings(selectionRadius: 20),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  @Deprecated('Use selectionRadius property in SfDateRangePicker')
  final double selectionRadius;

  /// Makes the [SfDateRangePicker] month view leading and trailing dates
  /// visible.
  ///
  /// Defaults to `false`.
  ///
  /// _Note:_ This property not applicable when the
  /// [SfDateRangePicker.pickerMode] set as [DateRangePickerMode.hijri].
  ///
  /// See also:
  /// * [numberOfWeeksInView], which used to customize the displaying week count
  /// displayed in the month view of date range picker.
  /// * [firstDayOfWeek], which used to customize the first week day of the
  /// month view in date range picker.
  /// * [DateRangePickerMonthCellStyle.trailingDatesTextStyle], which used to
  /// customize the trailing dates cell text in the month view.
  /// * [DateRangePickerMonthCellStyle.leadingDatesTextStyle], which used to
  /// customize the leading dates cell text in the month view.
  /// * [DateRangePickerMonthCellStyle.trailingDatesDecoration], which used to
  /// customize the trailing dates with decoration in the month view.
  /// * [DateRangePickerMonthCellStyle.leadingDatesDecoration], which used to
  /// customize the leading dates with decoration in the month view.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///         selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings: DateRangePickerMonthViewSettings(
  ///              showTrailingAndLeadingDates: true),
  ///        ),
  ///      ),
  ///   );
  ///  }
  ///
  /// ```
  final bool showTrailingAndLeadingDates;

  /// Disables the interactions for certain dates in the month view of
  /// [SfDateRangePicker].
  ///
  /// Defaults to null.
  ///
  /// Use [DateRangePickerMonthCellStyle.blackoutDateTextStyle] or
  /// [DateRangePickerMonthCellStyle.blackoutDatesDecoration] property to
  /// customize the appearance of blackout dates in month view.
  ///
  /// See also:
  /// * [DateRangePickerMonthCellStyle.blackoutDateTextStyle], which used to set
  /// text style for the black out date cell in the month view.
  /// * [DateRangePickerMonthCellStyle.blackoutDatesDecoration], which used to
  /// set the decoration for the black out date cell in the month view.
  /// * [specialDates], which is the list of dates to highlight the specific
  /// dates in the month view.
  /// * [weekendDays], which used to change the week end days in the month view.
  /// * [SfDateRangePicker.enablePastDates], which allows to enable the dates
  /// that falls before the today date for interaction.
  /// * Knowledge base: [How to update blackout dates using onViewChanged callback](https://www.syncfusion.com/kb/12372/how-to-update-blackout-dates-using-onviewchanged-callback-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to add active dates](https://www.syncfusion.com/kb/12075/how-to-add-active-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              DateRangePickerMonthViewSettings(blackoutDates: <DateTime>[
  ///            DateTime.now().add(Duration(days: 2)),
  ///            DateTime.now().add(Duration(days: 3)),
  ///            DateTime.now().add(Duration(days: 6)),
  ///            DateTime.now().add(Duration(days: 7))
  ///          ]),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final List<DateTime>? blackoutDates;

  /// In the month view of [SfDateRangePicker] highlights the unique dates with
  /// different style rather than the other dates style.
  ///
  /// Defaults to null.
  ///
  /// Use [DateRangePickerMonthCellStyle.specialDatesTextStyle] or
  /// [DateRangePickerMonthCellStyle.specialDatesDecoration] property to
  /// customize the appearance of blackout dates in month view.
  ///
  /// See also:
  /// [DateRangePickerMonthCellStyle.specialDatesTextStyle],which used to set
  /// text style for the text in special dates cell in the month view.
  /// [DateRangePickerMonthCellStyle.specialDatesDecoration], which used to set
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings:
  ///              DateRangePickerMonthViewSettings(specialDates: <DateTime>[
  ///            DateTime.now().add(Duration(days: 2)),
  ///            DateTime.now().add(Duration(days: 3)),
  ///            DateTime.now().add(Duration(days: 6)),
  ///            DateTime.now().add(Duration(days: 7))
  ///          ]),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final List<DateTime>? specialDates;

  /// The weekends for month view in [SfDateRangePicker].
  ///
  /// Defaults to `<int>[6,7]` represents `<int>[DateTime.saturday,
  ///  DateTime.sunday]`.
  ///
  /// _Note:_ The [weekendDays] will not be highlighted until it's customize by
  /// using the [DateRangePickerMonthCellStyle.weekendTextStyle] or
  /// [DateRangePickerMonthCellStyle.weekendDatesDecoration] property.
  ///
  /// See also:
  /// * [DateRangePickerMonthCellStyle.weekendTextStyle], which used to set
  /// text style for the week end cell text in month view.
  /// * [DateRangePickerMonthCellStyle.weekendDatesDecoration], which used to
  /// set decoration for the week end cell text in month view.
  /// * [specialDates], which used to highlight specific dates in the month view
  /// of date range picker.
  /// * [blackoutDates], which used to restrict the user interaction for the
  /// specific dates in teh month view of date range picker.
  /// * [numberOfWeeksInView],  which allows to customize the displaying week
  /// count in month view of date range picker.
  /// * Knowledge base: [How to change the week end dates](https://www.syncfusion.com/kb/12182/how-to-change-the-week-end-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the number of weeks](https://www.syncfusion.com/kb/12167/how-to-change-the-number-of-weeks-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings: DateRangePickerMonthViewSettings(
  ///             weekendDays: <int>[DateTime.friday, DateTime.saturday]),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final List<int> weekendDays;

  /// Used to displays the week number of the year in the month view of
  /// the SfDateRangePicker.
  ///
  /// In the month view, it is displayed at the the left side of the month view
  /// as a separate column in the DateRangePicker.
  ///
  /// Defaults to false
  ///
  /// see also:
  /// * [weekNumberStyle], which used to customize the week number view of the
  /// month view in the date range picker.
  /// * [numberOfWeeksInView],  which allows to customize the displaying week
  /// count in month view of date range picker.
  /// * [firstDayOfWeek], which used to customize the start day of the week in
  /// month view of date range picker.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfDateRangePicker(
  ///       view: DateRangePickerView.month,
  ///       monthViewSettings: const DateRangePickerMonthViewSettings(
  ///       showWeekNumber: true,
  ///       ),
  ///      ),
  ///    );
  ///  }
  final bool showWeekNumber;

  /// Defines the text style for the text in the week number panel of the
  /// SfDateRangePicker.
  ///
  /// Defaults to null
  ///
  /// see also:
  /// * [showWeekNumber], which allows to display the week number of the year in
  /// the month view of the date range picker.
  /// * [numberOfWeeksInView],  which allows to customize the displaying week
  /// count in month view of date range picker.
  /// * [firstDayOfWeek], which used to customize the start day of the week in
  /// month view of date range picker.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///   body: SfDateRangePicker(
  ///     view: DateRangePickerView.month,
  ///     monthViewSettings: const DateRangePickerMonthViewSettings(
  ///     showWeekNumber: true,
  ///     weekNumberStyle: const DateRangePickerWeekNumberStyle(
  ///         textStyle: TextStyle(fontStyle: FontStyle.italic),
  ///         backgroundColor: Colors.purple),
  ///     ),
  ///   ),
  ///  );
  /// }
  final DateRangePickerWeekNumberStyle weekNumberStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final DateRangePickerMonthViewSettings otherStyle;
    if (other is DateRangePickerMonthViewSettings) {
      otherStyle = other;
    }
    return otherStyle.dayFormat == dayFormat &&
        otherStyle.numberOfWeeksInView == numberOfWeeksInView &&
        otherStyle.firstDayOfWeek == firstDayOfWeek &&
        otherStyle.viewHeaderStyle == viewHeaderStyle &&
        otherStyle.viewHeaderHeight == viewHeaderHeight &&
        otherStyle.showTrailingAndLeadingDates == showTrailingAndLeadingDates &&
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
    properties.add(IterableDiagnostics<DateTime>(blackoutDates)
        .toDiagnosticsNode(name: 'blackoutDates'));
    properties.add(IterableDiagnostics<DateTime>(specialDates)
        .toDiagnosticsNode(name: 'specialDates'));
    properties.add(IntProperty('numberOfWeeksInView', numberOfWeeksInView));
    properties.add(IntProperty('firstDayOfWeek', firstDayOfWeek));
    properties.add(DoubleProperty('viewHeaderHeight', viewHeaderHeight));
    properties.add(StringProperty('dayFormat', dayFormat));
    properties.add(DiagnosticsProperty<bool>(
        'showTrailingAndLeadingDates', showTrailingAndLeadingDates));
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
        showTrailingAndLeadingDates,
        numberOfWeeksInView,
        showWeekNumber,
        weekNumberStyle,

        /// Below condition is referred from text style class
        /// https://api.flutter.dev/flutter/painting/TextStyle/hashCode.html
        specialDates == null ? null : Object.hashAll(specialDates!),
        blackoutDates == null ? null : Object.hashAll(blackoutDates!),
        Object.hashAll(weekendDays));
  }
}

/// The style have properties which allow to customize the year, decade and
/// century view of the [SfDateRangePicker].
///
/// Allows to customize the [textStyle], [todayTextStyle],
/// [leadingDatesTextStyle], [disabledDatesTextStyle], [cellDecoration],
/// [todayCellDecoration], [leadingDatesDecoration] and
/// [disabledDatesDecoration] in year, decade and century view of the
/// [SfDateRangePicker].
///
/// See also:
/// * [DateRangePickerMonthCellStyle], which allows to customize the month cell
/// of the month view of the date range picker
/// * [SfDateRangePicker.cellBuilder], which allows to set custom widget for the
/// picker cells in the date range picker.
/// * [DateRangePickerMonthViewSettings], which allows to customize the month
/// view of the date range picker.
/// * [SfDateRangePicker.selectionColor], which fills the background of the
/// selected cells in the date range picker.
/// * [SfDateRangePicker.startRangeSelectionColor], which fills the background
/// of the first cell of the range selection in date range picker.
/// * [SfDateRangePicker.endRangeSelectionColor], which fills the background of
/// the last cell of the range selection in date range picker.
/// * [SfDateRangePicker.rangeSelectionColor], which fills the background of the
///  in between cells of date range picker in range selection.
/// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
/// style for the text in the selected cell of date range picker.
/// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
/// the text in the selected range cell's of date range picker.
/// * [SfDateRangePicker.backgroundColor], which fills the background of the
/// date range picker.
/// * [SfDateRangePicker.todayHighlightColor], which highlights the today date
/// cell in the date range picker.
/// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
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
///        body: SfDateRangePicker(
///          view: DateRangePickerView.decade,
///          enablePastDates: false,
///          yearCellStyle: DateRangePickerYearCellStyle(
///            textStyle: TextStyle(
///                fontWeight: FontWeight.w400, fontSize: 15,
///                     color: Colors.black),
///            todayTextStyle: TextStyle(
///                fontStyle: FontStyle.italic,
///                fontSize: 15,
///                fontWeight: FontWeight.w500,
///                color: Colors.red),
///            leadingDatesDecoration: BoxDecoration(
///                color: const Color(0xFFDFDFDF),
///                border: Border.all(color: const Color(0xFFB6B6B6), width: 1),
///                shape: BoxShape.circle),
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
class DateRangePickerYearCellStyle with Diagnosticable {
  /// Creates a date range picker year cell style for date range picker.
  ///
  /// The properties allows to customize the year cells in year view of
  /// [SfDateRangePicker].
  const DateRangePickerYearCellStyle(
      {this.textStyle,
      this.todayTextStyle,
      this.leadingDatesTextStyle,
      this.disabledDatesTextStyle,
      this.cellDecoration,
      this.todayCellDecoration,
      this.disabledDatesDecoration,
      this.leadingDatesDecoration});

  /// The text style for the text in the [SfDateRangePicker] year, decade and
  /// century view cells.
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
  /// * [leadingDatesTextStyle], which used to set text style for the leading
  /// date cells in the year views of the dat range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.year,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: DateRangePickerYearCellStyle(
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

  /// The text style for the text in the today cell of [SfDateRangePicker]
  /// year, decade and century view.
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
  /// * [leadingDatesTextStyle], which used to set text style for the leading
  /// date cells in the year views of the dat range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.year,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: DateRangePickerYearCellStyle(
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

  /// The text style for the text in the leading dates cells of
  /// [SfDateRangePicker] year, decade and century view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// _Note:_ This property not applicable when the
  /// [SfDateRangePicker.pickerMode] set as [DateRangePickerMode.hijri].
  ///
  /// See also:
  /// * [leadingDatesDecoration], which used to set decoration for the leading
  /// date cells in the year views of date range picker.
  /// * [textStyle], which used to set text style for the year cell in the
  /// year views of the date range picker.
  /// * [disabledDatesTextStyle], which used to set text style for the disabled
  /// cell in the year views of the date range picker.
  /// * [leadingDatesTextStyle], which used to set text style for the leading
  /// date cells in the year views of the dat range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.year,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: DateRangePickerYearCellStyle(
  ///              leadingDatesTextStyle: TextStyle(
  ///                  fontSize: 12,
  ///                  fontWeight: FontWeight.w300,
  ///                  color: Colors.black)),
  ///       ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? leadingDatesTextStyle;

  /// The text style for the text in the disabled dates cell of
  /// [SfDateRangePicker] year, decade and century view.
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
  /// * [leadingDatesTextStyle], which used to set text style for the leading
  /// date cells in the year views of the dat range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.year,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: DateRangePickerYearCellStyle(
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

  /// The decoration for the disabled cells of [SfDateRangePicker]
  /// year, decade and century view.
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
  /// * [leadingDatesDecoration], which used to set decoration for the leading
  /// date cells in the year views of the dat range picker.
  /// * [SfDateRangePicker.selectionColor], which fills the background of the
  /// selected cells in the date range picker.
  /// * [SfDateRangePicker.startRangeSelectionColor], which fills the background
  /// of the first cell of the range selection in date range picker.
  /// * [SfDateRangePicker.endRangeSelectionColor], which fills the background
  /// of the last cell of the range selection in date range picker.
  /// * [SfDateRangePicker.rangeSelectionColor], which fills the background of
  /// the in between cells of date range picker in range selection.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.century,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: DateRangePickerYearCellStyle(
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

  /// The decoration for the cells of [SfDateRangePicker] year, decade
  /// and century view.
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
  /// * [leadingDatesDecoration], which used to set decoration for the leading
  /// date cells in the year views of the dat range picker.
  /// * [SfDateRangePicker.selectionColor], which fills the background of the
  /// selected cells in the date range picker.
  /// * [SfDateRangePicker.startRangeSelectionColor], which fills the background
  /// of the first cell of the range selection in date range picker.
  /// * [SfDateRangePicker.endRangeSelectionColor], which fills the background
  /// of the last cell of the range selection in date range picker.
  /// * [SfDateRangePicker.rangeSelectionColor], which fills the background of
  /// the in between cells of date range picker in range selection.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.century,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: DateRangePickerYearCellStyle(
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

  /// The decoration for the today cell of [SfDateRangePicker] year, decade
  /// and century view.
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
  /// * [leadingDatesDecoration], which used to set decoration for the leading
  /// date cells in the year views of the dat range picker.
  /// * [SfDateRangePicker.selectionColor], which fills the background of the
  /// selected cells in the date range picker.
  /// * [SfDateRangePicker.startRangeSelectionColor], which fills the background
  /// of the first cell of the range selection in date range picker.
  /// * [SfDateRangePicker.endRangeSelectionColor], which fills the background
  /// of the last cell of the range selection in date range picker.
  /// * [SfDateRangePicker.rangeSelectionColor], which fills the background of
  /// the in between cells of date range picker in range selection.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.century,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: DateRangePickerYearCellStyle(
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

  /// The decoration for the leading date cells of [SfDateRangePicker]
  /// year, decade and century view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// _Note:_ This property not applicable when the
  /// [SfDateRangePicker.pickerMode] set as [DateRangePickerMode.hijri].
  ///
  /// See also:
  /// * [leadingDatesTextStyle], which used to set text style for the leading
  ///  date cell in the year views of date range picker.
  /// * [disabledDatesDecoration], which used to set decoration for the disabled
  /// year cells in the year views of the date range picker.
  /// * [todayCellDecoration], which used to set decoration for the today date
  /// cell in the year views of the date range picker.
  /// * [cellDecoration], which used to set decoration for the year cells in the
  /// year views of the dat range picker.
  /// * [SfDateRangePicker.selectionColor], which fills the background of the
  /// selected cells in the date range picker.
  /// * [SfDateRangePicker.startRangeSelectionColor], which fills the background
  /// of the first cell of the range selection in date range picker.
  /// * [SfDateRangePicker.endRangeSelectionColor], which fills the background
  /// of the last cell of the range selection in date range picker.
  /// * [SfDateRangePicker.rangeSelectionColor], which fills the background of
  /// the in between cells of date range picker in range selection.
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.century,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          yearCellStyle: DateRangePickerYearCellStyle(
  ///            leadingDatesDecoration: BoxDecoration(
  ///                color: Colors.grey.withOpacity(0.4),
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
  final Decoration? leadingDatesDecoration;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final DateRangePickerYearCellStyle otherStyle;
    if (other is DateRangePickerYearCellStyle) {
      otherStyle = other;
    }
    return otherStyle.textStyle == textStyle &&
        otherStyle.todayTextStyle == todayTextStyle &&
        otherStyle.leadingDatesTextStyle == leadingDatesTextStyle &&
        otherStyle.disabledDatesDecoration == disabledDatesDecoration &&
        otherStyle.cellDecoration == cellDecoration &&
        otherStyle.todayCellDecoration == todayCellDecoration &&
        otherStyle.leadingDatesDecoration == leadingDatesDecoration &&
        otherStyle.disabledDatesTextStyle == disabledDatesTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
    properties
        .add(DiagnosticsProperty<TextStyle>('todayTextStyle', todayTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'leadingDatesTextStyle', leadingDatesTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'disabledDatesTextStyle', disabledDatesTextStyle));
    properties.add(DiagnosticsProperty<Decoration>(
        'disabledDatesDecoration', disabledDatesDecoration));
    properties
        .add(DiagnosticsProperty<Decoration>('cellDecoration', cellDecoration));
    properties.add(DiagnosticsProperty<Decoration>(
        'todayCellDecoration', todayCellDecoration));
    properties.add(DiagnosticsProperty<Decoration>(
        'leadingDatesDecoration', leadingDatesDecoration));
  }

  @override
  int get hashCode {
    return Object.hash(
        textStyle,
        todayTextStyle,
        leadingDatesTextStyle,
        disabledDatesTextStyle,
        disabledDatesDecoration,
        cellDecoration,
        todayCellDecoration,
        leadingDatesDecoration);
  }
}

/// The style allows to customize month cells of the [SfDateRangePicker].
///
///
/// Allows to customize the [textStyle],
/// [todayTextStyle], [trailingDatesTextStyle], [leadingDatesTextStyle],
/// [disabledDatesTextStyle], [blackoutDateTextStyle],
/// [weekendTextStyle], [specialDatesTextStyle], [specialDatesDecoration],
/// [blackoutDatesDecoration], [cellDecoration], [todayCellDecoration],
/// [disabledDatesDecoration], [trailingDatesDecoration],
/// [leadingDatesDecoration], and [weekendDatesDecoration]  in the month cells
/// of the date range picker.
///
/// See also:
/// * [DateRangePickerMonthViewSettings], which allows to customize the month
/// view of the date range picker
/// * [SfDateRangePicker.cellBuilder], which allows to set custom widget for the
///  picker cells in the date range picker.
/// * [DateRangePickerYearCellStyle], which allows to customize the year cell of
/// the year, decade and century views of the date range picker.
/// * [SfDateRangePicker.selectionColor], which fills the background of the
/// selected cells in the date range picker.
/// * [SfDateRangePicker.startRangeSelectionColor], which fills the background
/// of the first cell of the range selection in date range picker.
/// * [SfDateRangePicker.endRangeSelectionColor], which fills the background of
/// the last cell of the range selection in date range picker.
/// * [SfDateRangePicker.rangeSelectionColor], which fills the background of the
///  in between cells of date range picker in range selection.
/// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
/// style for the text in the selected cell of date range picker.
/// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
/// the text in the selected range cell's of date range picker.
/// * [SfDateRangePicker.backgroundColor], which fills the background of the
/// date range picker.
/// * [SfDateRangePicker.todayHighlightColor], which highlights the today date
/// cell in the date range picker.
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
///        body: SfDateRangePicker(
///          view: DateRangePickerView.month,
///          enablePastDates: false,
///          monthCellStyle: DateRangePickerMonthCellStyle(
///            textStyle: TextStyle(
///                fontWeight: FontWeight.w400, fontSize: 15,
///                     color: Colors.black),
///            todayTextStyle: TextStyle(
///                fontStyle: FontStyle.italic,
///                fontSize: 15,
///                fontWeight: FontWeight.w500,
///                color: Colors.red),
///            leadingDatesDecoration: BoxDecoration(
///                color: const Color(0xFFDFDFDF),
///                border: Border.all(color: const Color(0xFFB6B6B6), width: 1),
///                shape: BoxShape.circle),
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
class DateRangePickerMonthCellStyle with Diagnosticable {
  /// Creates a date range picker month cell style for date range picker.
  ///
  /// The properties allows to customize the month cells in month view of
  /// [SfDateRangePicker].
  const DateRangePickerMonthCellStyle(
      {@Deprecated('Use selectionColor property in SfDateRangePicker')
      // ignore: deprecated_member_use, deprecated_member_use_from_same_package
      this.selectionColor,
      @Deprecated('Use startRangeSelectionColor property in SfDateRangePicker')
      // ignore: deprecated_member_use, deprecated_member_use_from_same_package
      this.startRangeSelectionColor,
      @Deprecated('Use endRangeSelectionColor property in SfDateRangePicker')
      // ignore: deprecated_member_use, deprecated_member_use_from_same_package
      this.endRangeSelectionColor,
      @Deprecated('Use rangeSelectionColor property in SfDateRangePicker')
      // ignore: deprecated_member_use, deprecated_member_use_from_same_package
      this.rangeSelectionColor,
      this.textStyle,
      this.todayTextStyle,
      this.trailingDatesTextStyle,
      this.leadingDatesTextStyle,
      @Deprecated('Use selectionTextStyle property in SfDateRangePicker')
      // ignore: deprecated_member_use, deprecated_member_use_from_same_package
      this.selectionTextStyle,
      this.disabledDatesTextStyle,
      this.blackoutDateTextStyle,
      this.weekendTextStyle,
      this.specialDatesTextStyle,
      this.specialDatesDecoration,
      this.blackoutDatesDecoration,
      this.cellDecoration,
      this.todayCellDecoration,
      this.disabledDatesDecoration,
      this.trailingDatesDecoration,
      this.leadingDatesDecoration,
      @Deprecated('Use rangeTextStyle property in SfDateRangePicker')
      // ignore: deprecated_member_use, deprecated_member_use_from_same_package
      this.rangeTextStyle,
      this.weekendDatesDecoration});

  /// The text style for the text in the [SfDateRangePicker] month cells.
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
  /// * [leadingDatesTextStyle], which used to set the text style for the
  /// leading dates cells in the month view of the date range picker.
  /// * [trailingDatesTextStyle], which used to set the text style for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled cells in the month view of the date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set text style for the the week end
  /// date cells in the date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///         view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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

  /// The text style for the text in the today cell of [SfDateRangePicker]
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
  /// * [leadingDatesTextStyle], which used to set the text style for the
  /// leading dates cells in the month view of the date range picker.
  /// * [trailingDatesTextStyle], which used to set the text style for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled cells in the month view of the date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set text style for the the week end
  /// date cells in the date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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

  /// The text style for the text in the trailing dates cell of
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// _Note:_ This is applies only when the
  /// [DateRangePickerMonthViewSettings.showTrailingAndLeadingDates] property
  /// set as [true].
  ///
  /// This property not applicable when the [SfDateRangePicker.pickerMode] set
  /// as [DateRangePickerMode.hijri].
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.showTrailingAndLeadingDates], which
  /// used to display the previous and next month cell dates in the month view.
  /// * [trailingDatesDecoration], which used to set decoration for the trailing
  /// date cells in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [leadingDatesTextStyle], which used to set the text style for the
  /// leading dates cells in the month view of the date range picker.
  /// * [todayTextStyle], which used to set the text style for the today date
  /// cell in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled cells in the month view of the date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set text style for the the week end
  /// date cells in the date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings: DateRangePickerMonthViewSettings(
  ///              showTrailingAndLeadingDates: true),
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
  ///              trailingDatesTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.normal,
  ///                  fontWeight: FontWeight.w300,
  ///                  fontSize: 11,
  ///                  color: Colors.black)),
  ///        ),
  ///     ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? trailingDatesTextStyle;

  /// The text style for the text in the leading dates cell of
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// _Note:_ This is applies only when the
  /// [DateRangePickerMonthViewSettings.showTrailingAndLeadingDates] property
  /// set as [true].
  ///
  /// This property not applicable when the [SfDateRangePicker.pickerMode] set
  /// as [DateRangePickerMode.hijri].
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.showTrailingAndLeadingDates], which
  /// used to display the previous and next month cell dates in the month view.
  /// * [leadingDatesDecoration], which used to set decoration for the leading
  /// date cells in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [trailingDatesTextStyle], which used to set the text style for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [todayTextStyle], which used to set the text style for the today date
  /// cell in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled cells in the month view of the date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set text style for the the week end
  /// date cells in the date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthViewSettings: DateRangePickerMonthViewSettings(
  ///              showTrailingAndLeadingDates: true),
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
  ///              leadingDatesTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.normal,
  ///                  fontWeight: FontWeight.w300,
  ///                  fontSize: 11,
  ///                  color: Colors.black)),
  ///        ),
  ///     ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? leadingDatesTextStyle;

  /// The text style for the text in the disabled dates cell of
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [SfDateRangePicker.minDate], which is the minimum available date for the
  /// date range picker.
  /// * [SfDateRangePicker.maxDate], which is the last available date for the
  /// date range picker.
  /// * [SfDateRangePicker.enablePastDates], which allows to enable the dates
  /// that falls before the today date for interaction.
  /// * [disabledDatesDecoration], which used to set decoration for the disabled
  /// date cells in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [trailingDatesTextStyle], which used to set the text style for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [todayTextStyle], which used to set the text style for the today date
  /// cell in the month view of the date range picker.
  /// * [leadingDatesTextStyle], which used to set the text style for the
  /// leading date cells in the month view of the date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set text style for the the week end
  /// date cells in the date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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

  /// The text style for the text in the selected date or dates cell of
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
  ///              selectionTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.normal,
  ///                  fontWeight: FontWeight.w500,
  ///                  fontSize: 12,
  ///                  color: Colors.white)),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  @Deprecated('Use selectionTextStyle property in SfDateRangePicker')
  final TextStyle? selectionTextStyle;

  /// The text style for the text in the selected range or ranges cell of
  /// [SfDateRangePicker] month view.
  ///
  /// The style applies to the dates that falls between the
  /// [PickerDateRange.startDate] and [PickerDateRange.endDate].
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// _Note:_ This applies only when [DateRangePickerSelectionMode] set as
  /// [DateRangePickerSelectionMode.range] or
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// See also:
  /// [PickerDateRange]
  /// [DateRangePickerSelectionMode]
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
  ///              rangeTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.italic,
  ///                  fontWeight: FontWeight.w500,
  ///                  fontSize: 12,
  ///                  color: Colors.black)),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  @Deprecated('Use rangeTextStyle property in SfDateRangePicker')
  final TextStyle? rangeTextStyle;

  /// The text style for the text in the blackout dates cell of
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.blackoutDates], which is used to
  /// disable interaction for the specific month dates in month view.
  /// * [SfDateRangePicker.enablePastDates], which allows to enable the dates
  /// that falls before the today date for interaction.
  /// * [blackoutDatesDecoration], which used to set decoration for the black
  /// out date cells in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [trailingDatesTextStyle], which used to set the text style for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [todayTextStyle], which used to set the text style for the today date
  /// cell in the month view of the date range picker.
  /// * [leadingDatesTextStyle], which used to set the text style for the
  /// leading date cells in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled date cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set text style for the the week end
  /// date cells in the date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.weekendDays], which is used change the
  /// week ends for month.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [trailingDatesTextStyle], which used to set the text style for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [todayTextStyle], which used to set the text style for the today date
  /// cell in the month view of the date range picker.
  /// * [leadingDatesTextStyle], which used to set the text style for the
  /// leading date cells in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled date cells in the month view of date range picker.
  /// * [specialDatesTextStyle], which used to set the text style for the
  /// special dates cells in the month view of date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.specialDates], which is used highlight
  /// the specific dates in the month view.
  /// * [specialDatesDecoration], which used to set decoration for the special
  /// date cells in the month view of the date range picker.
  /// * [textStyle], which used to set text style for the month cells in the
  /// month view of the date range picker.
  /// * [trailingDatesTextStyle], which used to set the text style for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [todayTextStyle], which used to set the text style for the today date
  /// cell in the month view of the date range picker.
  /// * [leadingDatesTextStyle], which used to set the text style for the
  /// leading date cells in the month view of the date range picker.
  /// * [disabledDatesTextStyle], which used to set the text style for the
  /// disabled date cells in the month view of date range picker.
  /// * [blackoutDateTextStyle], which used to set the text style for the black
  /// out dates cells in the month view of date range picker.
  /// * [weekendTextStyle], which used to set the text style for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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

  /// The decoration for the special date cells of [SfDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.specialDates], which is used highlight
  /// the specific dates in the month view.
  /// * [specialDatesTextStyle], which used to set text style for the special
  /// date cells in the month view of the date range picker.
  /// * [cellDecoration], which used to set decoration for the month cells
  /// in the month view of the date range picker.
  /// * [trailingDatesDecoration], which used to set the decoration for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [leadingDatesDecoration], which used to set the decoration for the
  /// leading date cells in the month view of the date range picker.
  /// * [disabledDatesDecoration], which used to set the decoration for the
  /// disabled date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set the decoration for the
  /// weekend date cells in the month view of date range picker.
  /// * [blackoutDatesDecoration], which used to set decoration for the blackout
  /// date cells in the month view of date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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

  /// The decoration for the weekend date cells of [SfDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.weekendDates], which is used to change
  /// the weekends for the month in month view.
  /// * [weekendTextStyle], which used to set text style for the special
  /// date cells in the month view of the date range picker.
  /// * [cellDecoration], which used to set decoration for the month cells
  /// in the month view of the date range picker.
  /// * [trailingDatesDecoration], which used to set the decoration for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [leadingDatesDecoration], which used to set the decoration for the
  /// leading date cells in the month view of the date range picker.
  /// * [disabledDatesDecoration], which used to set the decoration for the
  /// disabled date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [blackoutDatesDecoration], which used to set decoration for the blackout
  /// date cells in the month view of date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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

  /// The decoration for the blackout date cells of [SfDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.blackoutDates], which is used to
  /// disable interactions for specific dates  in month view.
  /// * [blackoutDateTextStyle], which used to set text style for the blackout
  /// date cells in the month view of the date range picker.
  /// * [cellDecoration], which used to set decoration for the month cells
  /// in the month view of the date range picker.
  /// * [trailingDatesDecoration], which used to set the decoration for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [leadingDatesDecoration], which used to set the decoration for the
  /// leading date cells in the month view of the date range picker.
  /// * [disabledDatesDecoration], which used to set the decoration for the
  /// disabled date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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

  /// The decoration for the disabled date cells of [SfDateRangePicker]
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
  /// * [SfDateRangePicker.minDate], which is the least available date in the
  /// date range picker.
  /// * [SfDateRangePicker.maxDate], which is the last available date in the
  /// date range picker.
  /// * [disabledDatesTextStyle], which used to set text style for the disabled
  /// date cells in the month view of the date range picker.
  /// * [cellDecoration], which used to set decoration for the month cells
  /// in the month view of the date range picker.
  /// * [trailingDatesDecoration], which used to set the decoration for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [leadingDatesDecoration], which used to set the decoration for the
  /// leading date cells in the month view of the date range picker.
  /// * [blackoutDatesDecoration], which used to set the decoration for the
  /// blackout date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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

  /// The decoration for the month cells of [SfDateRangePicker] month view.
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
  /// * [trailingDatesDecoration], which used to set the decoration for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [leadingDatesDecoration], which used to set the decoration for the
  /// leading date cells in the month view of the date range picker.
  /// * [blackoutDatesDecoration], which used to set the decoration for the
  /// blackout date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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

  /// The decoration for the today text cell of [SfDateRangePicker] month view.
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
  /// * [trailingDatesDecoration], which used to set the decoration for the
  /// trailing dates cells in the month view of the date range picker.
  /// * [cellDecoration], which used to set the decoration for the month cells
  /// in the month view of the date range picker.
  /// * [leadingDatesDecoration], which used to set the decoration for the
  /// leading date cells in the month view of the date range picker.
  /// * [blackoutDatesDecoration], which used to set the decoration for the
  /// blackout date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
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

  /// The decoration for the trailing date cells of [SfDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// _Note:_ This is applies only when the
  /// [DateRangePickerMonthViewSettings.showTrailingAndLeadingDates] property
  /// set as [true].
  ///
  /// This property not applicable when the [SfDateRangePicker.pickerMode] set
  /// as [DateRangePickerMode.hijri].
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.showTrailingAndLeadingDates], which
  /// used to display the previous and next month dates in the month view.
  /// * [trailingDatesTextStyle], which used to set text style for the trailing
  ///  date cell in the month view of the date range picker.
  /// * [disabledDatesDecoration], which used to set decoration for the disabled
  /// date cells in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [cellDecoration], which used to set the decoration for the month cells
  /// in the month view of the date range picker.
  /// * [leadingDatesDecoration], which used to set the decoration for the
  /// leading date cells in the month view of the date range picker.
  /// * [blackoutDatesDecoration], which used to set the decoration for the
  /// blackout date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
  ///            trailingDatesDecoration: BoxDecoration(
  ///                color: Colors.black26,
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
  final Decoration? trailingDatesDecoration;

  /// The decoration for the leading date cells of [SfDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// _Note:_  This is applies only when the
  /// [DateRangePickerMonthViewSettings.showLeadingAndTrailingDate] property set
  /// as [true].
  ///
  /// This property not applicable when the [SfDateRangePicker.pickerMode] set
  /// as [DateRangePickerMode.hijri].
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.showTrailingAndLeadingDates], which
  /// used to display the previous and next month dates in the month view.
  /// * [leadingDatesTextStyle], which used to set text style for the leading
  ///  date cell in the month view of the date range picker.
  /// * [disabledDatesDecoration], which used to set decoration for the disabled
  /// date cells in the month view of the date range picker.
  /// * [todayCellDecoration], which used to set the decoration for the today
  /// date cell in the month view of the date range picker.
  /// * [cellDecoration], which used to set the decoration for the month cells
  /// in the month view of the date range picker.
  /// * [trailingDatesDecoration], which used to set the decoration for the
  /// trailing date cells in the month view of the date range picker.
  /// * [blackoutDatesDecoration], which used to set the decoration for the
  /// blackout date cells in the month view of date range picker.
  /// * [specialDatesDecoration], which used to set the decoration for the
  /// special date cells in the month view of date range picker.
  /// * [weekendDatesDecoration], which used to set decoration for the weekend
  /// date cells in the month view of date range picker.
  /// * [SfDateRangePicker.selectionTextStyle], which is used to set the text
  /// style for the text in the selected cell of date range picker.
  /// * [SfDateRangePicker.rangeTextStyle], which is used to set text style for
  /// the text in the selected range cell's of date range picker.
  /// * Knowledge base: [How to customize leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the month cell](https://www.syncfusion.com/kb/11307/how-to-customize-the-month-cell-of-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
  ///            leadingDatesDecoration: BoxDecoration(
  ///                color: Colors.black26,
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
  final Decoration? leadingDatesDecoration;

  /// The color which fills the [SfDateRangePicker] selection view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// Note : It is applies only when the [DateRangePickerSelectionMode] set as
  /// [DateRangePickerSelectionMode.single] of
  /// [DateRangePickerSelectionMode.multiple].
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          monthCellStyle:
  ///              DateRangePickerMonthCellStyle(selectionColor: Colors.red),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  @Deprecated('Use selectionColor property in SfDateRangePicker')
  final Color? selectionColor;

  /// The color which fills the [SfDateRangePicker] selection view of the range
  /// start date.
  ///
  /// The color fills to the selection view of the date in
  /// [PickerDateRange.startDate] property.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// Note : It is applies only when the [DateRangePickerSelectionMode] set as
  /// [DateRangePickerSelectionMode.range] of
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// ``` dart
  ///
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///         controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
  ///              startRangeSelectionColor: Colors.red),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  @Deprecated('Use startRangeSelectionColor property in SfDateRangePicker')
  final Color? startRangeSelectionColor;

  /// The color which fills the [SfDateRangePicker] selection view for the range
  /// of dates which falls between the [PickerDateRange.startDate] and
  /// [PickerDateRange.endDate].
  ///
  /// The color fills to the selection view of the dates in between the
  /// [PickerDateRange.startDate] and [PickerDateRange.endDate] property.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// Note : It is applies only when the [DateRangePickerSelectionMode] set as
  /// [DateRangePickerSelectionMode.range] of
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// ``` dart
  ///
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
  ///              rangeSelectionColor: Colors.red.withOpacity(0.4)),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  @Deprecated('Use rangeSelectionColor property in SfDateRangePicker')
  final Color? rangeSelectionColor;

  /// The color which fills the [SfDateRangePicker] selection view of the range
  /// end date.
  ///
  /// The color fills to the selection view of the date in
  /// [PickerDateRange.endDate] property.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// Note : It is applies only when the [DateRangePickerSelectionMode] set as
  /// [DateRangePickerSelectionMode.range] of
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// ``` dart
  ///
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///         controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          monthCellStyle: DateRangePickerMonthCellStyle(
  ///              endRangeSelectionColor: Colors.red),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  @Deprecated('Use endRangeSelectionColor property in SfDateRangePicker')
  final Color? endRangeSelectionColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    late final DateRangePickerMonthCellStyle otherStyle;
    if (other is DateRangePickerMonthCellStyle) {
      otherStyle = other;
    }
    return otherStyle.textStyle == textStyle &&
        otherStyle.todayTextStyle == todayTextStyle &&
        otherStyle.trailingDatesTextStyle == trailingDatesTextStyle &&
        otherStyle.leadingDatesTextStyle == leadingDatesTextStyle &&
        otherStyle.blackoutDateTextStyle == blackoutDateTextStyle &&
        otherStyle.weekendTextStyle == weekendTextStyle &&
        otherStyle.specialDatesTextStyle == specialDatesTextStyle &&
        otherStyle.specialDatesDecoration == specialDatesDecoration &&
        otherStyle.weekendDatesDecoration == weekendDatesDecoration &&
        otherStyle.blackoutDatesDecoration == blackoutDatesDecoration &&
        otherStyle.disabledDatesDecoration == disabledDatesDecoration &&
        otherStyle.cellDecoration == cellDecoration &&
        otherStyle.todayCellDecoration == todayCellDecoration &&
        otherStyle.trailingDatesDecoration == trailingDatesDecoration &&
        otherStyle.leadingDatesDecoration == leadingDatesDecoration &&
        otherStyle.disabledDatesTextStyle == disabledDatesTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
    properties
        .add(DiagnosticsProperty<TextStyle>('todayTextStyle', todayTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'trailingDatesTextStyle', trailingDatesTextStyle));
    properties.add(DiagnosticsProperty<TextStyle>(
        'leadingDatesTextStyle', leadingDatesTextStyle));
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
        'trailingDatesDecoration', trailingDatesDecoration));
    properties.add(DiagnosticsProperty<Decoration>(
        'leadingDatesDecoration', leadingDatesDecoration));
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
      trailingDatesTextStyle,
      leadingDatesTextStyle,
      disabledDatesTextStyle,
      specialDatesDecoration,
      weekendDatesDecoration,
      blackoutDatesDecoration,
      disabledDatesDecoration,
      cellDecoration,
      todayCellDecoration,
      trailingDatesDecoration,
      leadingDatesDecoration,
      specialDatesTextStyle,
      blackoutDateTextStyle,
      weekendTextStyle,
    ]);
  }
}

/// Signature for the callback that reports when the picker controller value
/// changed.
typedef DateRangePickerValueChangedCallback = void Function(String);

/// Notifier used to notify the when the objects properties changed.
class DateRangePickerValueChangeNotifier with Diagnosticable {
  List<DateRangePickerValueChangedCallback>? _listeners;

  /// Calls the listener every time the controller's property changed.
  ///
  /// Listeners can be removed with [removePropertyChangedListener].
  void addPropertyChangedListener(
      DateRangePickerValueChangedCallback listener) {
    _listeners ??= <DateRangePickerValueChangedCallback>[];
    _listeners?.add(listener);
  }

  /// remove the listener used for notify the data source changes.
  ///
  /// Stop calling the listener every time in controller's property changed.
  ///
  /// If `listener` is not currently registered as a listener, this method does
  /// nothing.
  ///
  /// Listeners can be added with [addPropertyChangedListener].
  void removePropertyChangedListener(
      DateRangePickerValueChangedCallback listener) {
    if (_listeners == null) {
      return;
    }

    _listeners?.remove(listener);
  }

  /// Call all the registered listeners.
  ///
  /// Call this method whenever the object changes, to notify any clients the
  /// object may have. Listeners that are added during this iteration will not
  /// be visited. Listeners that are removed during this iteration will not be
  /// visited after they are removed.
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// Surprising behavior can result when reentrantly removing a listener (i.e.
  /// in response to a notification) that has been registered multiple times.
  /// See the discussion at [removePropertyChangedListener].
  void notifyPropertyChangedListeners(String value) {
    if (_listeners == null) {
      return;
    }

    for (final DateRangePickerValueChangedCallback listener in _listeners!) {
      listener.call(value);
    }
  }

  /// Discards any resources used by the object. After this is called, the
  /// object is not in a usable state and should be discarded (calls to
  /// [addListener] and [removeListener] will throw after the object is
  /// disposed).
  ///
  /// This method should only be called by the object's owner.
  @mustCallSuper
  void dispose() {
    _listeners = null;
  }
}

/// An object that used for programmatic date navigation, date and range
/// selection and view switching in [SfDateRangePicker].
///
/// A [DateRangePickerController] served for several purposes. It can be used
/// to selected dates and ranges programmatically on [SfDateRangePicker] by
/// using the[controller.selectedDate], [controller.selectedDates],
/// [controller.selectedRange], [controller.selectedRanges]. It can be used to
/// change the [SfDateRangePicker] view by using the [controller.view] property.
/// It can be used to navigate to specific date by using the
/// [controller.displayDate] property.
///
/// ## Listening to property changes:
/// The [DateRangePickerController] is a listenable. It notifies it's listeners
/// whenever any of attached [SfDateRangePicker]`s selected date, display date
/// and view changed (i.e: selecting a different date, swiping to next/previous
/// view and navigates to different view] in in [SfDateRangePicker].
///
/// ## Navigates to different view:
/// The [SfDateRangePicker] visible view can be changed by using the
/// [Controller.view] property, the property allow to change the view of
/// [SfDateRangePicker] programmatically on initial load and in rum time.
///
/// ## Programmatic selection:
/// In [SfDateRangePicker] selecting dates programmatically can be achieved by
/// using the [controller.selectedDate], [controller.selectedDates],
/// [controller.selectedRange], [controller.selectedRanges] which allows to
/// select the dates or ranges programmatically on [SfDateRangePicker] on
/// initial load and in run time.
///
/// Defaults to null.
///
/// See also:
/// * [SfDateRangePicker.initialDisplayDate], which used to navigate the date
/// range picker to the specific date initially.
/// * [SfDateRangePicker.initialSelectedDate], which allows to select date
/// programmatically initially on date range picker.
/// * [SfDateRangePicker.initialSelectedDates], which allows to list of select
/// date programmatically initially on date range picker.
/// * [SfDateRangePicker.initialSelectedRange], which allows to select a range
/// of dates programmatically initially on date range picker.
/// * [SfDateRangePicker.initialSelectedRanges], which allows to select a ranges
/// of dates programmatically initially on date range picker.
/// * [selectedDate],which allows to select date
/// programmatically dynamically on date range picker.
/// * [selectedDates], which allows to select dates
/// programmatically dynamically on date range picker.
/// * [selectedRange], which allows to select range
/// of dates programmatically dynamically on date range picker.
/// * [selectedRanges], which allows to select
/// ranges of dates programmatically dynamically on date range picker.
/// * [SfDateRangePicker.selectionMode], which allows to customize the selection
/// mode with available mode options.
/// * [SfDateRangePicker.onViewChanged], the callback which notifies when the
/// current view visible date changed on the date range picker.
/// * [SfDateRangePicker.onSelectionChanged], the callback which notifies when
/// the selected cell changed on the the date range picker.
/// * [SfDateRangePicker.showActionButtons], which allows to cancel of confirm
/// the selection in the date range picker.
/// * [SfDateRangePicker.onSubmit], the callback which notifies when the
/// selected value confirmed through confirm button on date range picker.
/// * [SfDateRangePicker.onCancel], the callback which notifies when the
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
/// This example demonstrates how to use the [SfDateRangePickerController] for
/// [SfDateRangePicker].
///
/// ``` dart
///
///class MyApp extends StatefulWidget {
///  @override
///  MyAppState createState() => MyAppState();
///}
///
///class MyAppState extends State<MyApp> {
///  DateRangePickerController _pickerController = DateRangePickerController();
///
///  @override
///  void initState() {
///    _pickerController.selectedDates = <DateTime>[
///      DateTime.now().add(Duration(days: 2)),
///      DateTime.now().add(Duration(days: 4)),
///      DateTime.now().add(Duration(days: 7)),
///      DateTime.now().add(Duration(days: 11))
///    ];
///    _pickerController.displayDate = DateTime.now();
///    _pickerController.addPropertyChangedListener(handlePropertyChange);
///    super.initState();
///  }
///
///  void handlePropertyChange(String propertyName) {
///    if (propertyName == 'selectedDates') {
///      final List<DateTime> selectedDates = _pickerController.selectedDates;
///    } else if (propertyName == 'displayDate') {
///      final DateTime displayDate = _pickerController.displayDate;
///    }
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfDateRangePicker(
///          view: DateRangePickerView.month,
///          controller: _pickerController,
///          selectionMode: DateRangePickerSelectionMode.multiple,
///        ),
///      ),
///    );
///  }
///}
///
/// ```
class DateRangePickerController extends DateRangePickerValueChangeNotifier {
  DateTime? _selectedDate;
  List<DateTime>? _selectedDates;
  PickerDateRange? _selectedRange;
  List<PickerDateRange>? _selectedRanges;
  DateTime? _displayDate;
  DateRangePickerView? _view;

  /// The selected date in the [SfDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.single] for other selection modes this
  /// property will return as null.
  DateTime? get selectedDate => _selectedDate;

  /// Selects the given date programmatically in the [SfDateRangePicker] by
  /// checking that the date falls in between the minimum and maximum date
  /// range.
  ///
  /// _Note:_ If any date selected previously, will be removed and the selection
  ///  will be drawn to the date given in this property.
  ///
  /// If it is not [null] the widget will render the date selection for the date
  /// set to this property, even the [SfDateRangePicker.initialSelectedDate] is
  /// not null.
  ///
  /// It is only applicable when the [DateRangePickerSelectionMode] set as
  /// [DateRangePickerSelectionMode.single].
  ///
  /// See also:
  /// * [SfDateRangePicker.initialSelectedDate], which allows to select date
  /// programmatically initially on date range picker.
  /// * [selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [SfDateRangePicker.selectionMode], which allows to customize the
  /// selection mode with available mode options.
  /// * [SfDateRangePicker.onSelectionChanged], the callback which notifies when
  /// the selected cell changed on the the date range picker.
  /// * [SfDateRangePicker.showActionButtons], which allows to cancel of confirm
  /// the selection in the date range picker.
  /// * [SfDateRangePicker.onSubmit], the callback which notifies when the
  /// selected value confirmed through confirm button on date range picker.
  /// * [SfDateRangePicker.onCancel], the callback which notifies when the
  /// selected value canceled and reverted to previous  confirmed value through
  /// cancel button on date range picker.
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  ///  DateRangePickerController _pickerController =
  ///  DateRangePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.selectedDate = DateTime.now().add((Duration(
  ///                                days: 4)));
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          showNavigationArrow: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedDate(DateTime? date) {
    if (isSameDate(_selectedDate, date)) {
      return;
    }

    _selectedDate = date;
    notifyPropertyChangedListeners('selectedDate');
  }

  /// The list of dates selected in the [SfDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiple] for other selection modes this
  /// property will return as null.
  List<DateTime>? get selectedDates => _selectedDates;

  /// Selects the given dates programmatically in the [SfDateRangePicker] by
  /// checking that the dates falls in between the minimum and maximum date
  /// range.
  ///
  /// _Note:_ If any list of dates selected previously, will be removed and the
  /// selection will be drawn to the dates set to this property.
  ///
  /// If it is not [null] the widget will render the date selection for the
  /// dates set to this property, even the
  /// [SfDateRangePicker.initialSelectedDates] is not null.
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiple].
  ///
  /// See also:
  /// * [SfDateRangePicker.initialSelectedDates], which allows to list of select
  /// date programmatically initially on date range picker.
  /// * [selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [SfDateRangePicker.selectionMode], which allows to customize the
  /// selection mode with available mode options.
  /// * [SfDateRangePicker.onSelectionChanged], the callback which notifies when
  /// the selected cell changed on the the date range picker.
  /// * [SfDateRangePicker.showActionButtons], which allows to cancel of confirm
  /// the selection in the date range picker.
  /// * [SfDateRangePicker.onSubmit], the callback which notifies when the
  /// selected value confirmed through confirm button on date range picker.
  /// * [SfDateRangePicker.onCancel], the callback which notifies when the
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
  /// DateRangePickerController _pickerController = DateRangePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.selectedDates = <DateTime>[
  ///      DateTime.now().add((Duration(days: 4))),
  ///      DateTime.now().add((Duration(days: 7))),
  ///      DateTime.now().add((Duration(days: 8)))
  ///    ];
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedDates(List<DateTime>? dates) {
    if (DateRangePickerHelper.isDateCollectionEquals(_selectedDates, dates)) {
      return;
    }

    _selectedDates = DateRangePickerHelper.cloneList(dates)?.cast<DateTime>();
    notifyPropertyChangedListeners('selectedDates');
  }

  /// selected date range in the [SfDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.range] for other selection modes this
  /// property will return as null.
  PickerDateRange? get selectedRange => _selectedRange;

  /// Selects the given date range programmatically in the [SfDateRangePicker]
  /// by checking that the range of dates falls in between the minimum and
  /// maximum date range.
  ///
  /// _Note:_ If any date range selected previously, will be removed and the
  /// selection will be drawn to the range of dates set to this property.
  ///
  /// If it is not [null] the widget will render the date selection for the
  /// range set to this property, even the
  /// [SfDateRangePicker.initialSelectedRange] is not null.
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.range].
  ///
  /// See also:
  /// * [SfDateRangePicker.initialSelectedRange], which allows to select a range
  /// of dates programmatically initially on date range picker.
  /// * [selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [SfDateRangePicker.selectionMode], which allows to customize the
  /// selection mode with available mode options.
  /// * [SfDateRangePicker.onSelectionChanged], the callback which notifies when
  /// the selected cell changed on the the date range picker.
  /// * [SfDateRangePicker.showActionButtons], which allows to cancel of confirm
  /// the selection in the date range picker.
  /// * [SfDateRangePicker.onSubmit], the callback which notifies when the
  /// selected value confirmed through confirm button on date range picker.
  /// * [SfDateRangePicker.onCancel], the callback which notifies when the
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
  /// DateRangePickerController _pickerController = DateRangePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.selectedRange = PickerDateRange(
  ///        DateTime.now().add(Duration(days: 4)),
  ///        DateTime.now().add(Duration(days: 5)));
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedRange(PickerDateRange? range) {
    if (DateRangePickerHelper.isRangeEquals(_selectedRange, range)) {
      return;
    }

    _selectedRange = range;
    notifyPropertyChangedListeners('selectedRange');
  }

  /// List of selected ranges in the [SfDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiRange] for other selection modes this
  /// property will return as null.
  List<PickerDateRange>? get selectedRanges => _selectedRanges;

  /// Selects the given date ranges programmatically in the [SfDateRangePicker]
  /// by checking that the ranges of dates falls in between the minimum and
  /// maximum date range.
  ///
  /// If it is not [null] the widget will render the date selection for the
  /// ranges set to this property, even the
  /// [SfDateRangePicker.initialSelectedRanges] is not null.
  ///
  /// _Note:_ If any date ranges selected previously, will be removed and the
  /// selection will be drawn to the ranges of dates set to this property.
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// See also:
  /// * [SfDateRangePicker.initialSelectedRanges], which allows to select a
  /// ranges of dates programmatically initially on date range picker.
  /// * [selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [SfDateRangePicker.selectionMode], which allows to customize the
  /// selection mode with available mode options.
  /// * [SfDateRangePicker.onSelectionChanged], the callback which notifies when
  /// the selected cell changed on the the date range picker.
  /// * [SfDateRangePicker.showActionButtons], which allows to cancel of confirm
  /// the selection in the date range picker.
  /// * [SfDateRangePicker.onSubmit], the callback which notifies when the
  /// selected value confirmed through confirm button on date range picker.
  /// * [SfDateRangePicker.onCancel], the callback which notifies when the
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
  /// DateRangePickerController _pickerController = DateRangePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.selectedRanges = <PickerDateRange>[
  ///      PickerDateRange(DateTime.now().subtract(Duration(days: 4)),
  ///          DateTime.now().add(Duration(days: 4))),
  ///      PickerDateRange(DateTime.now().add(Duration(days: 11)),
  ///          DateTime.now().add(Duration(days: 16)))
  ///    ];
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedRanges(List<PickerDateRange>? ranges) {
    if (DateRangePickerHelper.isDateRangesEquals(_selectedRanges, ranges)) {
      return;
    }

    _selectedRanges =
        DateRangePickerHelper.cloneList(ranges)?.cast<PickerDateRange>();
    notifyPropertyChangedListeners('selectedRanges');
  }

  /// The first date of the current visible view month, when the
  /// [MonthViewSettings.numberOfWeeksInView] set with default value 6.
  ///
  /// If the [MonthViewSettings.numberOfWeeksInView] property set with value
  /// other then 6, this will return the first visible date of the current
  /// month.
  DateTime? get displayDate => _displayDate;

  /// Navigates to the given date programmatically without any animation in the
  /// [SfDateRangePicker] by checking that the date falls in between the
  /// [SfDateRangePicker.minDate] and [SfDateRangePicker.maxDate] date range.
  ///
  /// If the date falls beyond the [SfDateRangePicker.minDate] and
  /// [SfDateRangePicker.maxDate] the widget will move the widgets min or max
  /// date.
  ///
  /// See also:
  /// * [SfDateRangePicker.initialDisplayDate], which used to navigate the date
  /// range picker to the specific date initially.
  /// * [SfDateRangePicker.onViewChanged], the callback which notifies when the
  /// current view visible date changed on the date range picker.
  /// * Knowledge base: [How to do programmatic navigation](https://www.syncfusion.com/kb/12140/how-to-do-programmatic-navigation-using-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically navigate to adjacent dates](https://www.syncfusion.com/kb/12137/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically navigate](https://www.syncfusion.com/kb/12135/how-to-programmatically-navigate-to-the-date-in-the-flutter-date-range-picker)
  ///
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  /// DateRangePickerController _pickerController = DateRangePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.displayDate = DateTime(2022, 02, 05);
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set displayDate(DateTime? date) {
    if (isSameDate(_displayDate, date)) {
      return;
    }

    _displayDate = date;
    notifyPropertyChangedListeners('displayDate');
  }

  /// The current visible [DateRangePickerView] of [SfDateRangePicker].
  DateRangePickerView? get view => _view;

  /// Set the [SfDateRangePickerView] for the [SfDateRangePicker].
  ///
  ///
  /// The [SfDateRangePicker] will display the view sets to this property.
  ///
  /// See also:
  /// * [SfDateRangePicker.view], which used to display the required view on
  /// the date range picker initially.
  /// * [SfDateRangePicker.onViewChanged], the callback which notifies when the
  /// current view visible date changed on the date range picker.
  /// * [DateRangePickerView], to know more about the available view options in
  /// date range picker.
  /// * Knowledge base: [How to do programmatic navigation](https://www.syncfusion.com/kb/12140/how-to-do-programmatic-navigation-using-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically navigate to adjacent dates](https://www.syncfusion.com/kb/12137/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically navigate](https://www.syncfusion.com/kb/12135/how-to-programmatically-navigate-to-the-date-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// class MyAppState extends State<MyApp> {
  /// DateRangePickerController _pickerController = DateRangePickerController();
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController.view = DateRangePickerView.year;
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///       ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set view(DateRangePickerView? value) {
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
  /// * [SfDateRangePicker.showNavigationArrow], which allows to display the
  /// navigation arrows on the header view of the date range picker.
  /// * [backward], which used to navigate to the previous view of the date
  /// range picker programmatically.
  /// * [SfDateRangePicker.onViewChanged], the callback which notifies when the
  /// current view visible date changed on the date range picker.
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
  /// DateRangePickerController _pickerController = DateRangePickerController();
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
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
  /// * [SfDateRangePicker.showNavigationArrow], which allows to display the
  /// navigation arrows on the header view of the date range picker.
  /// * [forward], which used to navigate to the next view of the date
  /// range picker programmatically.
  /// * [SfDateRangePicker.onViewChanged], the callback which notifies when the
  /// current view visible date changed on the date range picker.
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
  /// DateRangePickerController _pickerController = DateRangePickerController();
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
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
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
    properties.add(DiagnosticsProperty<DateTime>('displayDate', displayDate));
    properties.add(DiagnosticsProperty<DateTime>('selectedDate', selectedDate));
    properties.add(IterableDiagnostics<DateTime>(selectedDates)
        .toDiagnosticsNode(name: 'selectedDates'));
    properties.add(
        DiagnosticsProperty<PickerDateRange>('selectedRange', selectedRange));
    properties.add(IterableDiagnostics<PickerDateRange>(selectedRanges)
        .toDiagnosticsNode(name: 'selectedRanges'));
    properties.add(EnumProperty<DateRangePickerView>('view', view));
  }
}

/// Selection modes for [SfDateRangePicker].
///
/// [DateRangePickerSelectionShape], which used to set different shape for the
/// selection view in date range picker.
enum DateRangePickerSelectionMode {
  /// - DateRangePickerSelectionMode.single, Allows to select a single date,
  /// selecting a new date will remove the selection for previous date and
  /// updates selection to the new selected date.
  single,

  /// - DateRangePickerSelection.multiple, Allows multiple date selection,
  /// selecting a new date will not remove the selection for previous dates,
  /// allows to select as many dates as possible.
  multiple,

  /// - DateRangePickerSelection.range, Allows to select a single range of
  /// dates.
  /// See also: [PickerDateRange]
  range,

  /// - DateRangePickerSelection.multiRange, Allows to select a multiple ranges
  /// of dates.
  ///
  /// See also: [PickerDateRange].
  multiRange,

  /// Extends the selected range with the new selected date in the date range
  /// picker.
  /// If a new date, after the existing selected range’s end date, is selected,
  /// the newly selected range’s start date stays unchanged while the end date
  /// will be changed to the newly selected date.
  /// Similarly, if a new date, before the existing selected range’s start date,
  /// is selected, the newly selected range’s start date will be changed to the
  /// newly selected date while the end date still is unchanged.
  /// Selecting a date between the ranges will update the range end date if the
  /// date selection index is half or more of the total dates count and vice
  /// versa for range start date.
  /// The range selection will not be updated if you tap on the blackout and
  /// disabled dates.
  ///
  /// _Note:_ The hovering effect which occurrs while extend the range will not
  /// be displayed when the [DateRangePickerNavigationMode] set as
  /// [DateRangePickerNavigationMode.scroll].
  ///
  /// See also:
  /// * [pickerDateRange], which used to store the start and end date of the
  /// range in date range picker.
  /// [HijriDateRange], which used to store the start and end date of the
  /// range in hijri date range picker.
  extendableRange,
}

/// Available views for [SfDateRangePicker].
///
/// See also:
/// * [HijriDatePickerView], which used to set different views for hijri date
/// range picker.
enum DateRangePickerView {
  /// - DateRangePickerView.month, Displays the month view.
  month,

  /// - DateRangePickerView.year, Displays the year view.
  year,

  /// - DateRangePickerView.decade, Displays the decade view.
  decade,

  /// - DateRangePickerView.century, Display the century view.
  ///
  /// _Note:_ This property not applicable when the
  /// [SfDateRangePicker.pickerMode] set as [DateRangePickerMode.hijri].
  century
}

/// The shape for the selection view in [SfDateRangePicker].
///
/// See also:
/// * [DateRangePickerSelectionMode], which used to set different selectio modes
/// for date range picker.
enum DateRangePickerSelectionShape {
  /// - DateRangePickerSelectionShape.circle, Draws the date selection in circle
  /// shape.
  circle,

  /// - DateRangePickerSelectionShape.rectangle, Draws the date selection in
  /// rectangle shape.
  rectangle
}

/// A direction in which the [SfDateRangePicker] navigates.
///
/// See also:
/// * [DateRangePickerNavigationMode], which used to set different navigation
/// modes for calendar.
enum DateRangePickerNavigationDirection {
  /// - DateRangePickerNavigationDirection.vertical, Navigates in top and bottom
  /// direction.
  vertical,

  /// - DateRangePickerNavigationDirection.horizontal, Navigates in right and
  /// left direction.
  horizontal
}

/// A type specifies how the date picker navigation interaction works.
///
/// See also:
/// * [DateRangePickerNavigationDirection], which allows to navigate through
/// date picker views with different modes.
enum DateRangePickerNavigationMode {
  /// Disables the next or previous view dates to be shown by scrolling or
  /// swipe interaction in [SfDateRangePicker] and [SfHijriDateRangePicker].
  ///
  /// It will not impact [DateRangePickerController.forward()],
  /// [DateRangePickerController.backward()] and [showNavigationArrow].
  none,

  /// Allows navigating to previous/next views through swipe interaction in
  /// [SfDateRangePicker] and [SfHijriDateRangePicker].
  snap,

  /// Enable free-scrolling based on [SfDateRangePicker]'s navigation direction.
  ///
  /// Note:
  /// 1.Swipe selection is not supported when range and multi-range are the
  /// selection modes.
  /// 2.[onViewChanged] will be called when the view reaches the starting
  /// position of the date range picker view.
  /// 3.[DateRangePickerController.forward()],
  /// [DateRangePickerController.backward()] and [showNavigationArrow] is
  /// not supported.
  /// 4. [viewSpacing] value not applicable when [enableMultiView] enabled for
  /// scroll mode.
  /// 5. [textAlign] in picker header style is not supported on horizontal
  /// navigation direction.
  /// 6. header view background color changed to white on light theme or
  /// grey[850] on dark theme when [backgroundColor] in
  /// [DateRangePickerHeaderStyle] is transparent.
  scroll
}

/// The direction for extendable range selection in [SfDateRangePicker].
/// Extends the selected range with the new selected date in the date range
/// picker based on the extendable range selection direction.
enum ExtendableRangeSelectionDirection {
  /// Doesn’t allows to extend the selection, the initial range will remains.
  none,

  /// Allows to extend the selection in both the direction.
  both,

  /// Allows to extend the selection only in forward direction.
  /// The start date will not be changed here.
  forward,

  /// Allows to extend the selection only in backward direction.
  /// The end date will not be changed here.
  backward
}

/// The dates that visible on the view changes in [SfDateRangePicker].
///
/// Details for [DateRangePickerViewChangedCallback], such as [visibleDateRange]
/// and [view].
///
/// See also:
/// * [SfDateRangePicker.onViewChanged], which receives the information.
/// * [SfDateRangePicker], which passes the information to one of its receiver.
/// * [DateRangePickerViewChangedCallback], signature when the current visible
/// dates changed in date range picker.
@immutable
class DateRangePickerViewChangedArgs {
  /// Creates details for [DateRangePickerViewChangedCallback].
  const DateRangePickerViewChangedArgs(this.visibleDateRange, this.view);

  /// The date range of the currently visible view dates.
  ///
  /// See also: [PickerDateRange].
  final PickerDateRange visibleDateRange;

  /// The currently visible [DateRangePickerView] in the [SfDateRangePicker].
  ///
  /// See also: [DateRangePickerView].
  final DateRangePickerView view;
}

/// The selected dates or ranges changes in the [SfDateRangePicker].
///
/// Details for [DateRangePickerSelectionChangedCallback], such as selected
/// value.
///
/// See also:
/// * [SfDateRangePicker.onSelectionChanged], which receives the information.
/// * [SfDateRangePicker], which passes the information to one of its receiver.
/// * [DateRangePickerSelectionChangedCallback], signature when the selectoin
/// changed in date range picker.
@immutable
class DateRangePickerSelectionChangedArgs {
  /// Creates details for [DateRangePickerSelectionChangedCallback].
  const DateRangePickerSelectionChangedArgs(this.value);

  /// The changed selected dates or ranges value.
  ///
  /// The argument value will return the changed date as [DateTime] when the
  /// widget [DateRangePickerSelectionMode] set as single.
  ///
  /// The argument value will return the changed dates as [List<DateTime>] when
  /// the widget [DateRangePickerSelectionMode] set as multiple.
  ///
  /// The argument value will return the changed range as [PickerDateRange]
  /// when the widget [DateRangePickerSelectionMode] set as range.
  ///
  /// The argument value will return the changed ranges as
  /// [List<PickerDateRange>] when the widget [DateRangePickerSelectionMode] set
  /// as multi range.
  final dynamic value;
}

/// Defines a range of dates, covers the dates in between the given [startDate]
/// and [endDate] as a range.
///
/// See also:
/// * [HijriDateRange], which is used to store the range value for hijri date
/// range picker.
/// * [DateRangePickerSelectionMode], which is used to handle different
/// available selection modes in date range picker.
/// * [SfDateRangePicker.initialSelectedRange], which allows to select a range
/// of dates programmatically initially on date range picker.
/// * [SfDateRangePicker.initialSelectedRanges], which allows to select a ranges
/// of dates programmatically initially on date range picker.
/// * [DateRangePickerController.selectedRange], which allows to select range
/// of dates programmatically dynamically on date range picker.
/// * [DateRangePickerController.selectedRanges], which allows to select
@immutable
class PickerDateRange with Diagnosticable {
  /// Creates a picker date range with the given start and end date.
  const PickerDateRange(this.startDate, this.endDate);

  /// The start date of the range.
  final DateTime? startDate;

  /// The end date of the range.
  final DateTime? endDate;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime>('startDate', startDate));
    properties.add(DiagnosticsProperty<DateTime>('endDate', endDate));
  }
}

/// Signature for a function that creates a widget based on date range picker
/// cell details.
///
/// See also:
/// * [SfDateRangePicker.cellBuilder], which matches this signature.
/// * [SfDateRangePicker], which uses this signature in one of it's callback.
typedef DateRangePickerCellBuilder = Widget Function(
    BuildContext context, DateRangePickerCellDetails cellDetails);

/// Signature for predicating dates for enabled date selections.
///
/// [SelectableDayPredicate] parameter used to specify allowable days in the
/// SfDateRangePicker.
typedef DateRangePickerSelectableDayPredicate = bool Function(DateTime date);

/// Contains the details that needed on calendar cell builder.
///
/// See also:
/// * [SfDateRangePicker.cellBuilder], which matches this signature.
/// * [SfDateRangePicker], which uses this signature in one of it's callback.
class DateRangePickerCellDetails {
  /// Constructor to store the details that needed on calendar cell builder.
  DateRangePickerCellDetails(
      {required this.date, required this.bounds, required this.visibleDates});

  /// Date value associated with the picker cell in month, year, decade and
  /// century views.
  final DateTime date;

  /// Position and size of the widget.
  final Rect bounds;

  /// Visible dates value associated with the current picker month, year,
  /// decade and century views. It is used to get the cell, leading and
  /// trailing dates details.
  final List<DateTime> visibleDates;
}

/// Defines the diagnostics for the collection.
class IterableDiagnostics<T> extends DiagnosticableTree {
  /// Constructor for collection diagnostics.
  IterableDiagnostics(this.collection);

  /// Iterable that used to generate diagnostics.
  final List<T>? collection;

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    if (collection != null && collection!.isNotEmpty) {
      return collection!.map<DiagnosticsNode>((T value) {
        if (value is Diagnosticable) {
          return value.toDiagnosticsNode();
        } else {
          return DiagnosticsProperty<T>('', value);
        }
      }).toList();
    }
    return super.debugDescribeChildren();
  }

  @override
  String toStringShort() {
    return collection == null
        ? 'null'
        : collection!.isNotEmpty
            ? '<$T>'
            : '<none>';
  }
}
