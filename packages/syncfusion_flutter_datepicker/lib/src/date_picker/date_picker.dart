import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/core_internal.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../datepicker.dart';

import 'month_view.dart';
import 'picker_helper.dart';
import 'theme.dart';
import 'year_view.dart';

/// Signature for callback that reports that the picker state value changed.
typedef UpdatePickerState = void Function(
    PickerStateArgs updatePickerStateDetails);

/// Signature for callback that reports that a current view or current visible
/// date range changes.
///
/// The visible date range and the visible view which visible on view when the
/// view changes available in the [DateRangePickerViewChangedArgs].
///
/// Used by [SfDateRangePicker.onViewChanged].
///
/// See also:
/// * [SfDateRangePicker.onViewChanged], which matches this signature.
/// * [SfDateRangePicker], which uses this signature in one of it's callback.
typedef DateRangePickerViewChangedCallback = void Function(
    DateRangePickerViewChangedArgs dateRangePickerViewChangedArgs);

/// Signature for callback that reports that a current view or current visible
/// date range changes.
///
/// The visible date range and the visible view which visible on view when the
/// view changes available in the [HijriDatePickerViewChangedArgs].
///
/// Used by [SfHijriDateRangePicker.onViewChanged].
///
/// See also:
/// * [SfHijriDateRangePicker.onViewChanged], which matches this signature.
/// * [SfHijriDateRangePicker], which uses this signature in one of it's
/// callback.
typedef HijriDatePickerViewChangedCallback = void Function(
    HijriDatePickerViewChangedArgs hijriDatePickerViewChangedArgs);

/// Signature for callback that reports that a new dates or date ranges
/// selected.
///
/// The dates or ranges that selected when the selection changes available in
/// the [DateRangePickerSelectionChangedArgs].
///
/// Used by [SfDateRangePicker.onSelectionChanged] and
/// [SfHijriDateRangePicker.onSelectionChanged].
///
/// See also:
/// * [SfDateRangePicker.onSelectionChanged], which matches this signature.
/// * [SfHijriDateRangePicker.onSelectionChanged], which matches this signature.
/// * [SfDateRangePicker], which uses this signature in one of it's callback.
/// * [SfHijriDateRangePicker], which uses this signature in one of it's
/// callback.
typedef DateRangePickerSelectionChangedCallback = void Function(
    DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs);

// method that raise the picker selection changed call back with the given
// parameters.
void _raiseSelectionChangedCallback(_SfDateRangePicker picker,
    {dynamic value}) {
  picker.onSelectionChanged?.call(DateRangePickerSelectionChangedArgs(value));
}

// method that raises the visible dates changed call back with the given
// parameters.
void _raisePickerViewChangedCallback(_SfDateRangePicker picker,
    {dynamic visibleDateRange, dynamic view}) {
  if (picker.onViewChanged == null) {
    return;
  }

  if (picker.isHijri) {
    picker
        .onViewChanged(HijriDatePickerViewChangedArgs(visibleDateRange, view));
  } else {
    picker
        .onViewChanged(DateRangePickerViewChangedArgs(visibleDateRange, view));
  }
}

/// A material design date range picker.
///
/// A [SfDateRangePicker] can be used to select single date, multiple dates, and
/// range of dates in month view alone and provided month, year, decade and
/// century view options to quickly navigate to the desired date, it supports
/// [minDate],[maxDate] and disabled date to restrict the date selection.
///
/// Default displays the [DateRangePickerView.month] view with single selection
/// mode.
///
/// Set the [view] property with the desired [DateRangePickerView] to navigate
/// to different views, or tap the [SfDateRangePicker] header to navigate to the
/// next different view in the hierarchy.
///
/// The hierarchy of views is followed by
/// * [DateRangePickerView.month]
/// * [DateRangePickerView.year]
/// * [DateRangePickerView.decade]
/// * [DateRangePickerView.century]
///
/// ![different views in date range picker](https://help.syncfusion.com/flutter/daterangepicker/images/overview/picker_views.png)
///
/// To change the selection mode, set the [selectionMode] property with the
/// [DateRangePickerSelectionMode] option.
///
/// To restrict the date navigation and selection interaction use [minDate],
/// [maxDate], the dates beyond this will be restricted.
///
/// When the selected dates or ranges change, the widget will call the
/// [onSelectionChanged] callback with new selected dates or ranges.
///
/// When the visible view changes, the widget will call the [onViewChanged]
/// callback with the current view and the current view visible dates.
///
/// Requires one of its ancestors to be a Material widget. This is typically
/// provided by a Scaffold widget.
///
/// Requires one of its ancestors to be a MediaQuery widget. Typically,
/// a MediaQuery widget is introduced by the MaterialApp or WidgetsApp widget
/// at the top of your application widget tree.
///
/// _Note:_ The picker widget allows to customize its appearance using
/// [SfDateRangePickerThemeData] available from [SfDateRangePickerTheme] widget
/// or the [SfTheme.dateRangePickerTheme] widget.
/// It can also be customized using the properties available in
/// [DateRangePickerHeaderStyle], [DateRangePickerViewHeaderStyle],
/// [DateRangePickerMonthViewSettings], [DateRangePickerYearCellStyle],
/// [DateRangePickerMonthCellStyle]
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=3TyuUVExuPs}
///
/// See also:
/// * [SfDateRangePickerThemeData], which used to set consistent look for the
/// date range picker element.
/// * [DateRangePickerHeaderStyle], which used to customize the header view of
/// the date range picker.
/// * [DateRangePickerViewHeaderStyle], which used to customize the view header
/// view of the date range picker.
/// * [DateRangePickerMonthViewSettings], which used to customize the month view
/// of the date range picker.
/// * [DateRangePickerYearCellStyle], which used to customize the year, decade
/// and century views cell of the date range picker.
/// * [DateRangePickerMonthCellStyle], which used to customize the month cells
/// of month view in date range picker.
/// * [SfHijriDateRangePicker], Material widget, which used to display and
/// handle the hijri date time values.
///
/// ``` dart
///class MyApp extends StatefulWidget {
///  @override
///  MyAppState createState() => MyAppState();
///}
///
///class MyAppState extends State<MyApp> {
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfDateRangePicker(
///          view: DateRangePickerView.month,
///          selectionMode: DateRangePickerSelectionMode.range,
///          minDate: DateTime(2020, 02, 05),
///          maxDate: DateTime(2020, 12, 06),
///          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
///            final dynamic value = args.value;
///          },
///          onViewChanged: (DateRangePickerViewChangedArgs args) {
///            final PickerDateRange visibleDates = args.visibleDateRange;
///            final DateRangePickerView view = args.view;
///          },
///        ),
///      ),
///    );
///  }
///}
/// ```
@immutable
class SfDateRangePicker extends StatelessWidget {
  /// Creates a material design date range picker.
  ///
  /// To restrict the date navigation and selection interaction use [minDate],
  /// [maxDate], the dates beyond this will be restricted.
  ///
  /// When the selected dates or ranges change, the widget will call the
  /// [onSelectionChanged] callback with new selected dates or ranges.
  ///
  /// When the visible view changes, the widget will call the [onViewChanged]
  /// callback with the current view and the current view visible dates.
  SfDateRangePicker(
      {Key? key,
      DateRangePickerView view = DateRangePickerView.month,
      this.selectionMode = DateRangePickerSelectionMode.single,
      this.headerHeight = 40,
      this.todayHighlightColor,
      this.backgroundColor,
      DateTime? initialSelectedDate,
      List<DateTime>? initialSelectedDates,
      PickerDateRange? initialSelectedRange,
      List<PickerDateRange>? initialSelectedRanges,
      this.toggleDaySelection = false,
      this.enablePastDates = true,
      this.showNavigationArrow = false,
      this.confirmText = 'OK',
      this.cancelText = 'CANCEL',
      this.showActionButtons = false,
      this.selectionShape = DateRangePickerSelectionShape.circle,
      this.navigationDirection = DateRangePickerNavigationDirection.horizontal,
      this.allowViewNavigation = true,
      this.navigationMode = DateRangePickerNavigationMode.snap,
      this.enableMultiView = false,
      this.controller,
      this.onViewChanged,
      this.onSelectionChanged,
      this.onCancel,
      this.onSubmit,
      this.headerStyle = const DateRangePickerHeaderStyle(),
      this.yearCellStyle = const DateRangePickerYearCellStyle(),
      this.monthViewSettings = const DateRangePickerMonthViewSettings(),
      this.monthCellStyle = const DateRangePickerMonthCellStyle(),
      DateTime? minDate,
      DateTime? maxDate,
      DateTime? initialDisplayDate,
      double viewSpacing = 20,
      this.selectionRadius = -1,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.monthFormat,
      this.cellBuilder,
      this.showTodayButton = false,
      this.selectableDayPredicate,
      this.extendableRangeSelectionDirection =
          ExtendableRangeSelectionDirection.both})
      : assert(headerHeight >= -1),
        assert(minDate == null ||
            maxDate == null ||
            minDate.isBefore(maxDate) ||
            minDate == maxDate),
        assert(viewSpacing >= 0),
        initialSelectedDate =
            controller != null && controller.selectedDate != null
                ? controller.selectedDate
                : initialSelectedDate,
        initialSelectedDates =
            controller != null && controller.selectedDates != null
                ? controller.selectedDates
                : initialSelectedDates,
        initialSelectedRange =
            controller != null && controller.selectedRange != null
                ? controller.selectedRange
                : initialSelectedRange,
        initialSelectedRanges =
            controller != null && controller.selectedRanges != null
                ? controller.selectedRanges
                : initialSelectedRanges,
        view = controller != null && controller.view != null
            ? controller.view!
            : view,
        initialDisplayDate =
            controller != null && controller.displayDate != null
                ? controller.displayDate!
                : initialDisplayDate ?? DateTime.now(),
        minDate = minDate ?? DateTime(1900),
        maxDate = maxDate ?? DateTime(2100, 12, 31),
        viewSpacing = enableMultiView ? viewSpacing : 0,
        super(key: key);

  /// Defines the view for the [SfDateRangePicker].
  ///
  /// Default to `DateRangePickerView.month`.
  ///
  /// _Note:_ If the [controller] and it's [controller.view] property is not
  ///  null, then this property will be ignored and widget will display the view
  ///  described in [controller.view] property.
  ///
  /// See also:
  /// * [DateRangePickerView], to know more about the available views in the
  /// date range picker.
  /// * [DateRangePickerController.view], which used to changed the view of
  /// date range picker dynamically.
  /// * [allowViewNavigation], which allows to navigate to different date range
  /// picker views quick and easily by tapping on the header.
  /// * [How to switch between the date range picker views when calendar has appointments](https://www.syncfusion.com/kb/11305/how-to-switch-between-the-date-range-picker-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.year,
  ///          minDate: DateTime(2019, 02, 05),
  ///          maxDate: DateTime(2021, 12, 06),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerView view;

  /// Defines the selection mode for [SfDateRangePicker].
  ///
  /// Defaults to `DateRangePickerSelectionMode.single`.
  ///
  /// Also refer [DateRangePickerSelectionMode].
  ///
  /// ![different type of selection mode in date range picker](https://help.syncfusion.com/flutter/daterangepicker/images/overview/selection_mode.png)
  ///
  /// _Note:_ If it set as Range or MultiRange, the navigation through swiping
  /// will be restricted by default and the navigation between views can be
  /// achieved by using the navigation arrows in header view.
  ///
  /// If it is set as Range or MultiRange and also the
  /// [DateRangePickerMonthViewSettings.enableSwipeSelection] set as [false] the
  /// navigation through swiping will work as it is without any restriction.
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.enableSwipeSelection], which allows to
  /// select the cells on swipe when the selection mode set as
  /// [DateRangePickerSelectionMode.range],
  /// [DateRangePickerSelectionMode.multiRange], and
  /// [DateRangePickerSelectionMode.extendableRange].
  /// * [DateRangePickerSelectionMode], to know more about the available
  /// selection modes in date range picker.
  /// * [allowViewNavigation], which allows to navigate between views quickly,
  /// and setting this property as `false`, allows to select the cells on
  /// year, decade and century view of date range picker.
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in date range picker.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of date range picker.
  /// * [toggleDaySelection], which allows to deselect a date when the selection
  /// mode set as [DateRangePickerSelectionMode.single].
  /// * [showActionButtons], which displays action buttons on bottom of date
  /// range picker, which allows to confirm and cancel the selection.
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on date range picker.
  /// * [DateRangePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * Knowledge base: [Range selection using multiple view picker](https://www.syncfusion.com/kb/11534/range-selection-using-the-multiple-view-picker-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select a week](https://www.syncfusion.com/kb/11412/how-to-select-a-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select all days when clicking on the day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  ///
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          minDate: DateTime(2019, 02, 05),
  ///          maxDate: DateTime(2021, 12, 06),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerSelectionMode selectionMode;

  /// Sets the style for customizing the [SfDateRangePicker] header view.
  ///
  /// Allows to customize the [DateRangePickerHeaderStyle.textStyle],
  /// [DateRangePickerHeaderStyle.textAlign] and
  /// [DateRangePickerHeaderStyle.backgroundColor] of the header view in
  /// [SfDateRangePicker].
  ///
  /// See also:
  /// * [DateRangePickerHeaderStyle], which contains options to customize the
  /// header view of the date range picker.
  /// * [headerHeight], which is the size of the header view in the date range
  /// picker.
  /// * [showNavigationArrow], which displays the navigation arrows on the
  /// header view of the date range picker.
  /// * [monthFormat], which allows to customize the month text in the header
  /// view also in the year cell view of date range picker.
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
  final DateRangePickerHeaderStyle headerStyle;

  /// The height for header view to layout within this in [SfDateRangePicker]
  ///
  /// Defaults to value `40`.
  ///
  /// ![header height as 100](https://help.syncfusion.com/flutter/daterangepicker/images/headers/headerheight.png)
  ///
  /// _Note:_ If [showNavigationArrows] set as true the arrows will shrink or
  /// grow based on the given header height value.
  ///
  /// See also:
  /// * [headerStyle], which allows to customize the header view of the
  /// date range picker.
  /// * [showNavigationArrow], which displays the navigation arrows on the
  /// header view of the date range picker.
  /// * Knowledge base: [How to style a header](https://www.syncfusion.com/kb/12342/how-to-style-a-header-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select all days when clicking on the day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to restrict the year view navigation when tapping on header view](https://www.syncfusion.com/kb/12113/how-to-restrict-the-year-view-navigation-while-tapping-header-of-the-flutter-date-range)
  /// * Knowledge base: [How to customize the header in Flutter multi date range picker](https://www.syncfusion.com/kb/11897/how-to-customize-the-header-in-the-flutter-multi-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the header view](https://www.syncfusion.com/kb/11427/how-to-customize-the-header-view-of-the-flutter-date-range-picker)
  /// * Knowledge base: [How to navigate to the previous or next views using navigation arrows](https://www.syncfusion.com/kb/12270/how-to-navigate-to-the-previous-or-next-views-using-navigation-arrows-in-the-flutter-date)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          headerHeight: 50,
  ///          showNavigationArrow: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double headerHeight;

  /// Color that highlights the today date cell in [SfDateRangePicker].
  ///
  /// Allows to change the color that highlights the today date cell border in
  /// month, year, decade and century view in date range picker.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [SfDateRangePickerThemeData], to handle theming with date range picker
  /// for giving consistent look.
  /// * [monthCellStyle], which allows to customize the month cells in the
  /// date range picker.
  /// * [yearCellStyle], which allows to customize the year cells in the date
  /// range picker.
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          todayHighlightColor: Colors.red,
  ///          showNavigationArrow: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? todayHighlightColor;

  /// The color to fill the background of the [SfDateRangePicker].
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [SfDateRangePickerThemeData], to handle theming with date range picker
  /// for giving consistent look.
  /// * Knowledge base: [How to add an image as background](https://www.syncfusion.com/kb/12233/how-to-add-an-image-as-background-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          todayHighlightColor: Colors.red,
  ///          backgroundColor: Colors.cyanAccent,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? backgroundColor;

  /// Allows to deselect a date when the [DateRangePickerSelectionMode] set as
  /// [DateRangePickerSelectionMode.single].
  ///
  /// When this [toggleDaySelection] property set as [true] tapping on a single
  /// date for the second time will clear the selection, which means setting
  /// this property as [true] allows to deselect a date when the
  /// [DateRangePickerSelectionMode] set as single.
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [selectionMode], which allows to set different selection modes for
  /// date range picker.
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in date range picker.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on date range picker.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on date range picker.
  /// * [DateRangePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * Knowledge base: [How to deselect the selected date](https://www.syncfusion.com/kb/12138/how-to-deselect-the-selected-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          toggleDaySelection: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool toggleDaySelection;

  /// Used to enable or disable the view switching between [DateRangePickerView]
  /// through interaction in the [SfDateRangePicker] header.
  ///
  /// Selection is allowed for year, decade and century views when
  /// the [allowViewNavigation] property is false.
  /// Otherwise, year, decade and century views are allowed only for view
  /// navigation.
  ///
  /// Defaults to `true`.
  ///
  /// See also:
  /// * [view], which allows to set different views which display initially on
  /// date range picker.
  /// * [DateRangePickerController.view], which allows to set different views
  /// dynamically on date range picker.
  /// * Knowledge base: [How to restrict the year view navigation while tapping header](https://www.syncfusion.com/kb/12113/how-to-restrict-the-year-view-navigation-while-tapping-header-of-the-flutter-date-range)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          allowViewNavigation: false,
  ///       ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool allowViewNavigation;

  /// A builder that builds a widget that replaces the cell in a month, year,
  /// decade and century views. The month cell, year cell, decade cell,
  /// century cell was differentiated by picker view.
  ///
  /// See also:
  /// * [monthViewSettings], which allows to customize the month view in the
  /// date range picker.
  /// * [monthCellStyle], which allows to customize the month cells in the date
  /// range picker.
  /// * [yearCellStyle], which allows to customize the year cells in the date
  /// range picker.
  /// * Knowledge base: [How to customize the leading and trailing dates using cell builder](https://www.syncfusion.com/kb/12674/how-to-customize-leading-and-trailing-dates-using-cell-builder-in-the-flutter-date-range)
  /// * Knowledge base: [How to customize special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select all days when clicking on day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// DateRangePickerController _controller = DateRangePickerController();
  ///
  /// @override
  /// void initState() {
  ///  _controller.view = DateRangePickerView.month;
  ///  super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///       home: Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text('Date range picker'),
  ///     ),
  ///     body: SfDateRangePicker(
  ///       controller: _controller,
  ///       cellBuilder:
  ///           (BuildContext context, DateRangePickerCellDetails cellDetails) {
  ///         if (_controller.view == DateRangePickerView.month) {
  ///           return Container(
  ///             width: cellDetails.bounds.width,
  ///             height: cellDetails.bounds.height,
  ///             alignment: Alignment.center,
  ///             child: Text(cellDetails.date.day.toString()),
  ///           );
  ///         } else if (_controller.view == DateRangePickerView.year) {
  ///           return Container(
  ///             width: cellDetails.bounds.width,
  ///             height: cellDetails.bounds.height,
  ///             alignment: Alignment.center,
  ///             child: Text(cellDetails.date.month.toString()),
  ///           );
  ///         } else if (_controller.view == DateRangePickerView.decade) {
  ///           return Container(
  ///             width: cellDetails.bounds.width,
  ///             height: cellDetails.bounds.height,
  ///             alignment: Alignment.center,
  ///             child: Text(cellDetails.date.year.toString()),
  ///           );
  ///         } else {
  ///           final int yearValue = (cellDetails.date.year ~/ 10) * 10;
  ///           return Container(
  ///             width: cellDetails.bounds.width,
  ///             height: cellDetails.bounds.height,
  ///             alignment: Alignment.center,
  ///             child: Text(
  ///                yearValue.toString() + ' - ' + (yearValue + 9).toString()),
  ///           );
  ///         }
  ///       },
  ///     ),
  ///   ));
  ///  }
  ///
  /// ```
  final DateRangePickerCellBuilder? cellBuilder;

  /// Displays the today button on the bottom of date range picker.
  ///
  /// The today button allows to navigate to the today date quickly in all
  /// view of date range picker.
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [showActionButtons], which used to handle the selected value.
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          showTodayButton: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool showTodayButton;

  /// An [selectableDayPredicate] callback to decide whether the cell is
  /// selectable or not in date range picker.
  ///
  /// Note: This callback is not applicable when the [navigationMode] set as
  /// [DateRangePickerNavigationMode.scroll].
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// [DateRangePickerMonthViewSettings.blackoutDates], which allows to disable
  /// interaction for specific dates.
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///       home: Scaffold(
  ///         body: SfDateRangePicker(
  ///           initialDisplayDate: DateTime(2022),
  ///           selectableDayPredicate: (DateTime dateTime) {
  ///             if (dateTime != DateTime(2022)) {
  ///               return false;
  ///             }
  ///             return true;
  ///           },
  ///         ),
  ///       ));
  /// }
  ///
  /// ```
  final DateRangePickerSelectableDayPredicate? selectableDayPredicate;

  /// Allows to customize the extendable range selection direction.
  ///
  /// Defaults to `ExtendableRangeSelectionDirection.both`.
  ///
  /// See also:
  /// [selectionMode], which contains available selection modes for
  /// date range picker.
  ///
  /// _Note:_ This  applicable only when the [selectionMode]
  /// set as [DateRangePickerSelectionMode.extendableRange].
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          minDate: DateTime(2019, 02, 05),
  ///          maxDate: DateTime(2021, 12, 06),
  ///          extendableRangeSelectionDirection:
  ///           ExtendableRangeSelectionDirection.backward,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final ExtendableRangeSelectionDirection extendableRangeSelectionDirection;

  /// Used to enable or disable showing multiple views
  ///
  /// When setting this [enableMultiView] property set to [true] displaying
  /// multiple views and provide quick navigation and dates selection.
  /// It is applicable for all the [DateRangePickerView] types.
  ///
  /// Decade and century views does not show trailing cells when
  /// the [enableMultiView] property is enabled.
  ///
  /// Enabling this [enableMultiView] property is recommended for web
  /// browser and larger android and iOS devices(iPad, tablet, etc.,)
  ///
  /// Note : Each of the views have individual header when the [textAlign]
  /// property in the [headerStyle] as center
  /// eg.,    May, 2020                 June, 2020
  /// otherwise, shown a single header for the multiple views
  /// eg., May, 2020 - June, 2020
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [viewSpacing], which fills the space between the pickers in the date
  /// range picker.
  /// * [navigationDirection], which allows to arrange and navigate the
  /// multiview in either in [DateRangePickerNavigationDirection.vertical] or
  /// [DateRangePickerNavigationDirection.horizontal] in date range picker.
  /// * Knowledge base: [How to show tow pickers vertically](https://www.syncfusion.com/kb/12193/how-to-show-two-pickers-vertically-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to use multiple picker](https://www.syncfusion.com/kb/11806/how-to-use-multiple-picker-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          enableMultiView: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool enableMultiView;

  /// Used to define the space[double] between multiple views when the
  /// [enableMultiView] is enabled.
  /// Otherwise, the [viewSpacing] value as not applied in [SfDateRangePicker].
  ///
  /// Defaults to value `20`.
  ///
  /// This value not applicable on [SfDateRangePicker] when
  /// [navigationMode] is [DateRangePickerNavigationMode.scroll].
  ///
  /// See also:
  /// * [enableMultiView], which allows displays multiple date picker side by
  /// side in date range picker.
  /// * [navigationDirection], which allows to arrange and navigate the
  /// multiview in either in [DateRangePickerNavigationDirection.vertical] or
  /// [DateRangePickerNavigationDirection.horizontal] in date range picker.
  /// * Knowledge base: [How to show tow pickers vertically](https://www.syncfusion.com/kb/12193/how-to-show-two-pickers-vertically-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to use multiple picker](https://www.syncfusion.com/kb/11806/how-to-use-multiple-picker-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          enableMultiView: true,
  ///          viewSpacing: 20,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double viewSpacing;

  /// The radius for the [SfDateRangePicker] selection circle..
  ///
  /// Defaults to null.
  ///
  /// _Note:_ This only applies if the [DateRangePickerSelectionMode] is set
  /// to [DateRangePickerSelectionMode.circle].
  ///
  /// ```dart
  ///
  /// See also:
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of date range picker in range selection.
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of date range picker.
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          selectionRadius: 20,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double selectionRadius;

  /// The text style for the text in the selected date or dates cell of
  /// [SfDateRangePicker].
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [selectionRadius], which is the radius for the selection view in the
  /// date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionColor], which fills the background of the selected cells in
  /// the date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of date range picker in range selection.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of date range picker.
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfda
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
  ///          selectionTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.normal,
  ///                  fontWeight: FontWeight.w500,
  ///                  fontSize: 12,
  ///                  color: Colors.white),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
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
  /// * [PickerDateRange], which used to holds the start and end date of the
  /// selected range.
  /// * [selectionMode], which allows to customize the selection modes with the
  /// available modes.
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of date range picker.
  /// * Knowledge base: [Range selection using multiple view picker](https://www.syncfusion.com/kb/11534/range-selection-using-the-multiple-view-picker-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
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
  ///          rangeTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.italic,
  ///                  fontWeight: FontWeight.w500,
  ///                  fontSize: 12,
  ///                  color: Colors.black),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? rangeTextStyle;

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
  /// See more:
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of date range picker.
  /// * Knowledge base: [Range selection using multiple view picker](https://www.syncfusion.com/kb/11534/range-selection-using-the-multiple-view-picker-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
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
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          selectionColor: Colors.red,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
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
  /// See also:
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of date range picker.
  /// * [toggleDaySelection], which allows to deselect a date when the selection
  /// mode set as [DateRangePickerSelectionMode.single].
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///         controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          startRangeSelectionColor: Colors.red,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
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
  /// See also:
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in date range picker.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of date range picker.
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          rangeSelectionColor: Colors.red.withOpacity(0.4),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
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
  /// See also:
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of date range picker.
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///         controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          endRangeSelectionColor: Colors.red,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? endRangeSelectionColor;

  /// The settings have properties which allow to customize the month view of
  /// the [SfDateRangePicker].
  ///
  /// Allows to customize the
  /// [DateRangePickerMonthViewSettings.numberOfWeeksInView],
  /// [DateRangePickerMonthViewSettings.firstDayOfWeek],
  /// [DateRangePickerMonthViewSettings.dayFormat],
  /// [DateRangePickerMonthViewSettings.viewHeaderHeight],
  /// [DateRangePickerMonthViewSettings.showTrailingAndLeadingDates],
  /// [DateRangePickerMonthViewSettings.viewHeaderStyle],
  /// [DateRangePickerMonthViewSettings.enableSwipeSelection],
  /// [DateRangePickerMonthViewSettings.blackoutDates],
  /// [DateRangePickerMonthViewSettings.specialDates]
  /// and [DateRangePickerMonthViewSettings.weekendDays] in month view of
  /// date range picker.
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings], to know more about available options
  /// to customize the month view of date range picker
  /// * [monthCellStyle], which allows to customize the month cell of the month
  /// view of the date range picker
  /// * [cellBuilder], which allows to set custom widget for the picker cells
  /// in the date range picker.
  /// * [yearCellStyle], which allows to customize the year cell of the year,
  /// decade and century views of the date range picker.
  /// * [backgroundColor], which fills the background of the date range picker.
  /// * [todayHighlightColor], which highlights the today date cell in the date
  /// range picker.
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
  ///                      TextStyle(fontWeight: FontWeight.w400,
  ///                           fontSize: 15, color: Colors.black)),
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
  final DateRangePickerMonthViewSettings monthViewSettings;

  /// The style have properties which allow to customize the year, decade and
  /// century view of the [SfDateRangePicker].
  ///
  /// Allows to customize the [DateRangePickerYearCellStyle.textStyle],
  /// [DateRangePickerYearCellStyle.todayTextStyle],
  /// [DateRangePickerYearCellStyle.leadingDatesTextStyle],
  /// [DateRangePickerYearCellStyle.disabledDatesTextStyle],
  /// [DateRangePickerYearCellStyle.cellDecoration],
  /// [DateRangePickerYearCellStyle.todayCellDecoration],
  /// [DateRangePickerYearCellStyle.leadingDatesDecoration] and
  /// [DateRangePickerYearCellStyle.disabledDatesDecoration] in year, decade and
  /// century view of the date range picker.
  ///
  /// See also:
  /// * [DateRangePickerYearCellStyle], to know more about available options
  /// to customize the year cells of date range picker
  /// * [monthCellStyle], which allows to customize the month cell of the month
  /// view of the date range picker
  /// * [cellBuilder], which allows to set custom widget for the picker cells
  /// in the date range picker.
  /// * [monthViewSettings], which allows to customize the month view of the
  /// date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of date range picker in range selection.
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of date range picker.
  /// * [backgroundColor], which fills the background of the date range picker.
  /// * [todayHighlightColor], which highlights the today date cell in the date
  /// range picker.
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
  ///                border: Border.all(color: const Color(0xFFB6B6B6),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///            disabledDatesDecoration: BoxDecoration(
  ///                color: const Color(0xFFDFDFDF).withOpacity(0.2),
  ///                border: Border.all(color: const Color(0xFFB6B6B6),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerYearCellStyle yearCellStyle;

  /// The style have properties which allow to customize month cells of the
  /// [SfDateRangePicker].
  ///
  /// Allows to customize the  [DateRangePickerMonthCellStyle.textStyle],
  /// [DateRangePickerMonthCellStyle.todayTextStyle],
  /// [DateRangePickerMonthCellStyle.trailingDatesTextStyle],
  /// [DateRangePickerMonthCellStyle.leadingDatesTextStyle],
  /// [DateRangePickerMonthCellStyle.disabledDatesTextStyle],
  /// [DateRangePickerMonthCellStyle.blackoutDateTextStyle],
  /// [DateRangePickerMonthCellStyle.weekendTextStyle],
  /// [DateRangePickerMonthCellStyle.specialDatesTextStyle],
  /// [DateRangePickerMonthCellStyle.specialDatesDecoration],
  /// [DateRangePickerMonthCellStyle.blackoutDatesDecoration],
  /// [DateRangePickerMonthCellStyle.cellDecoration],
  /// [DateRangePickerMonthCellStyle.todayCellDecoration],
  /// [DateRangePickerMonthCellStyle.disabledDatesDecoration],
  /// [DateRangePickerMonthCellStyle.trailingDatesDecoration],
  /// [DateRangePickerMonthCellStyle.leadingDatesDecoration],
  /// [DateRangePickerMonthCellStyle.weekendDatesDecoration]  in the month cells
  /// of the date range picker.
  ///
  /// See also:
  /// * [DateRangePickerMonthCellStyle] to know more about available options
  /// to customize the month cell of date range picker
  /// * [monthViewSettings], which allows to customize the month view of the
  /// date range picker
  /// * [cellBuilder], which allows to set custom widget for the picker cells
  /// in the date range picker.
  /// * [yearCellStyle], which allows to customize the year cell of the year,
  /// decade and century views of the date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of date range picker in range selection.
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of date range picker.
  /// * [backgroundColor], which fills the background of the date range picker.
  /// * [todayHighlightColor], which highlights the today date cell in the date
  /// range picker.
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
  ///                border: Border.all(color: const Color(0xFFB6B6B6),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///            disabledDatesDecoration: BoxDecoration(
  ///                color: const Color(0xFFDFDFDF).withOpacity(0.2),
  ///                border: Border.all(color: const Color(0xFFB6B6B6),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerMonthCellStyle monthCellStyle;

  /// The initial date to show on the [SfDateRangePicker]
  ///
  /// The [SfDateRangePicker] will display the dates based on the date set in
  /// this property.
  ///
  /// Defaults to current date.
  ///
  /// _Note:_ If the [controller] and it's [controller.displayDate] property is
  /// not [null] then this property will be ignored and the widget render the
  /// dates based on the date given in [controller.displayDate].
  ///
  /// See also:
  /// * [DateRangePickerController.displayDate], which allows to move the
  /// date range picker to specific date.
  /// * [DateRangePickerController.forward], which allows to navigate to next
  /// view of the date range picker programmatically.
  /// * [DateRangePickerController.backward], which allows to navigate to
  /// previous view of the date range picker programmatically.
  /// * [onViewChanged], the callback which will notify that the current visible
  /// dates were changed in date range picker.
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on date range picker.
  /// * [minDate], which is the least available date for the date range picker.
  /// * [maxDate], which is the last available date for the date range picker.
  /// * [showNavigationArrow], which display the navigation arrows on the header
  /// view of the date range picker.
  /// * Knowledge base: [How to navigate to the previous or next views using navigation arrows](https://www.syncfusion.com/kb/12270/how-to-navigate-to-the-previous-or-next-views-using-navigation-arrows-in-the-flutter-date)
  /// * Knowledge base: [How to do programmatic navigation](https://www.syncfusion.com/kb/12140/how-to-do-programmatic-navigation-using-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically navigate to adjacent dates](https://www.syncfusion.com/kb/12137/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically navigate](https://www.syncfusion.com/kb/12135/how-to-programmatically-navigate-to-the-date-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to restrict date range picker within date limit](https://www.syncfusion.com/kb/11329/how-to-restrict-date-range-picker-within-the-date-limit-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          initialDisplayDate: DateTime(2025, 02, 05),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateTime initialDisplayDate;

  /// The date to initially select on the [SfDateRangePicker].
  ///
  /// The [SfDateRangePicker] will select the date that set to this property.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ If the [controller] and it's [controller.selectedDate] property is
  ///  not [null] then this property will be ignored and the widget render the
  /// selection for the date given in [controller.selectedDate].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.single].
  ///
  /// See also:
  /// * [initialDisplayDate], which used to navigate the date range picker to
  /// the specific date initially.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on date range picker.
  /// * [DateRangePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [onSelectionChanged], the callback which notifies when the selection
  /// cell changed on the date range picker.
  /// * [showActionButtons], which allows to cancel of confirm the selection in
  /// the date range picker.
  /// * [onSubmit], the callback which notifies when the selected value
  /// confirmed through confirm button on date range picker.
  /// * [onCancel], the callback which notifies when the selected value canceled
  /// and reverted to previous  confirmed value through cancel button on date
  /// range picker.
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to deselect the selected date](https://www.syncfusion.com/kb/12138/how-to-deselect-the-selected-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)///
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          initialSelectedDate: DateTime.now().add((Duration(days: 5))),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateTime? initialSelectedDate;

  /// The minimum date as much as the [SfDateRangePicker] will navigate.
  ///
  /// The [SfDateRangePicker] widget will navigate as minimum as to the given
  /// date, and the dates before that date will be disabled for interaction and
  /// navigation to those dates were restricted.
  ///
  /// Defaults to `1st January of 1900`.
  ///
  /// _Note:_ If the [initialDisplayDate] or [controller.displayDate] property
  /// set with the date prior to this date, the [SfDateRangePicker] will take
  /// this min date as a display date and render dates based on the date set to
  /// this property.
  ///
  ///
  /// See also:
  /// * [initialDisplayDate], which used to navigate the date range picker to
  /// the specific date on initially.
  /// * [maxDate], which is last available date for the date range picker.
  /// * [controller.displayDate], which used to navigate the date range picker
  /// to specific date on dynamically.
  /// * [enablePastDates], which allows to enable the dates that falls before
  /// the today date for interaction.
  /// * Knowledge base: [How to enable or disable the past dates](https://www.syncfusion.com/kb/12168/how-to-enable-or-disable-the-past-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to restrict date range picker within the date limit](https://www.syncfusion.com/kb/11329/how-to-restrict-date-range-picker-within-the-date-limit-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          minDate: DateTime(2020, 01, 01),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateTime minDate;

  /// The maximum date as much as the [SfDateRangePicker] will navigate.
  ///
  /// The [SfDateRangePicker] widget will navigate as maximum as to the given
  /// date, and the dates after that date will be disabled for interaction and
  /// navigation to those dates were restricted.
  ///
  /// Defaults to `31st December of 2100`.
  ///
  /// _Note:_ If the [initialDisplayDate] or [controller.displayDate] property
  /// set with the date after to this date, the [SfDateRangePicker] will take
  /// this max date as a display date and render dates based on the date set to
  /// this property.
  ///
  /// See also:
  /// * [initialDisplayDate], which used to navigate the date range picker to
  /// the specific date on initially.
  /// * [minDate], which is least available date for the date range picker.
  /// * [controller.displayDate], which used to navigate the date range picker
  /// to specific date on dynamically.
  /// * [enablePastDates], which allows to enable the dates that falls before
  /// the today date for interaction.
  /// * Knowledge base: [How to enable or disable the past dates](https://www.syncfusion.com/kb/12168/how-to-enable-or-disable-the-past-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to restrict date range picker within the date limit](https://www.syncfusion.com/kb/11329/how-to-restrict-date-range-picker-within-the-date-limit-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          maxDate: DateTime(2029, 12, 31),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateTime maxDate;

  /// Allows to disable the dates falls before the today date in
  /// [SfDateRangePicker].
  ///
  /// If it is set as [false] the dates falls before the today date is disabled
  /// and selection interactions to that dates were restricted.
  ///
  /// Defaults to `true`.
  ///
  /// See also:
  /// * [minDate], which is the least available date for the date range picker.
  /// * [maxDate], which is last available date for the date range picker.
  /// * Knowledge base: [How to enable or disable the past dates](https://www.syncfusion.com/kb/12168/how-to-enable-or-disable-the-past-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to restrict date range picker within the date limit](https://www.syncfusion.com/kb/11329/how-to-restrict-date-range-picker-within-the-date-limit-in-the-flutter-date-range-picker)
  ///
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          enablePastDates: false,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///```
  final bool enablePastDates;

  /// The collection of dates to initially select on the [SfDateRangePicker].
  ///
  /// If it is not [null] the [SfDateRangePicker] will select the dates that set
  /// to this property.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ If the [controller] and it's [controller.selectedDates] property
  /// is not [null] then this property will be ignored and the widget render the
  /// selection for the dates given in [controller.selectedDates].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiple].
  ///
  ///
  /// See also:
  /// * [initialDisplayDate], which used to navigate the date range picker to
  /// the specific date initially.
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on date range picker.
  /// * [DateRangePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [onSelectionChanged], the callback which notifies when the selection
  /// cell changed on the date range picker.
  /// * [showActionButtons], which allows to cancel of confirm the selection in
  /// the date range picker.
  /// * [onSubmit], the callback which notifies when the selected value
  /// confirmed through confirm button on date range picker.
  /// * [onCancel], the callback which notifies when the selected value canceled
  /// and reverted to previous  confirmed value through cancel button on date
  /// range picker.
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  /// return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          initialSelectedDates: <DateTime>[
  ///            DateTime.now().add((Duration(days: 4))),
  ///            DateTime.now().add((Duration(days: 5))),
  ///            DateTime.now().add((Duration(days: 9))),
  ///            DateTime.now().add((Duration(days: 11)))
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///}
  ///
  /// ```
  final List<DateTime>? initialSelectedDates;

  /// The date range to initially select on the [SfDateRangePicker].
  ///
  /// If it is not [null] the [SfDateRangePicker] will select the range of dates
  /// that set to this property.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ If the [controller] and it's [controller.selectedRange] property
  /// is not [null] then this property will be ignored and the widget render the
  /// selection for the range given in [controller.selectedRange].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.range].
  ///
  /// See also:
  /// * [PickerDateRange], which is used to store the start and end date of the
  /// range selection.
  /// * [initialDisplayDate], which used to navigate the date range picker to
  /// the specific date initially.
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on date range picker.
  /// * [DateRangePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [onSelectionChanged], the callback which notifies when the selection
  /// cell changed on the date range picker.
  /// * [showActionButtons], which allows to cancel of confirm the selection in
  /// the date range picker.
  /// * [onSubmit], the callback which notifies when the selected value
  /// confirmed through confirm button on date range picker.
  /// * [onCancel], the callback which notifies when the selected value canceled
  /// and reverted to previous  confirmed value through cancel button on date
  /// range picker.
  /// * Knowledge base: [Range selection using multiple view picker](https://www.syncfusion.com/kb/11534/range-selection-using-the-multiple-view-picker-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select a week](https://www.syncfusion.com/kb/11412/how-to-select-a-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select previous or next dates bases on selected date](https://www.syncfusion.com/kb/12354/how-to-select-previous-or-next-dates-based-on-the-selected-date-in-the-flutter-date-range)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to restrict swipe gesture for range selection](https://www.syncfusion.com/kb/12117/how-to-restrict-swipe-gesture-for-range-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  /// return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          initialSelectedRange: PickerDateRange(
  ///              DateTime.now().subtract((Duration(days: 4))),
  ///              DateTime.now().add(Duration(days: 4))),
  ///        ),
  ///      ),
  ///    );
  /// }
  ///
  /// ```
  final PickerDateRange? initialSelectedRange;

  /// The date ranges to initially select on the [SfDateRangePicker].
  ///
  /// If it is not [null] the [SfDateRangePicker] will select the range of dates
  /// that set to this property.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ If the [controller] and it's [controller.selectedRanges] property
  /// is not [null] then this property will be ignored and the widget render the
  /// selection for the ranges given in [controller.selectedRanges].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// See also:
  /// * [PickerDateRange], which is used to store the start and end date of the
  /// range selection.
  /// * [initialDisplayDate], which used to navigate the date range picker to
  /// the specific date initially.
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on date range picker.
  /// * [DateRangePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [onSelectionChanged], the callback which notifies when the selection
  /// cell changed on the date range picker.
  /// * [showActionButtons], which allows to cancel of confirm the selection in
  /// the date range picker.
  /// * [onSubmit], the callback which notifies when the selected value
  /// confirmed through confirm button on date range picker.
  /// * [onCancel], the callback which notifies when the selected value canceled
  /// and reverted to previous  confirmed value through cancel button on date
  /// range picker.
  /// * Knowledge base: [Range selection using multiple view picker](https://www.syncfusion.com/kb/11534/range-selection-using-the-multiple-view-picker-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select a week](https://www.syncfusion.com/kb/11412/how-to-select-a-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select previous or next dates bases on selected date](https://www.syncfusion.com/kb/12354/how-to-select-previous-or-next-dates-based-on-the-selected-date-in-the-flutter-date-range)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to restrict swipe gesture for range selection](https://www.syncfusion.com/kb/12117/how-to-restrict-swipe-gesture-for-range-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  /// return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          initialSelectedRanges: <PickerDateRange>[
  ///            PickerDateRange(DateTime.now().subtract(Duration(days: 4)),
  ///                DateTime.now().add(Duration(days: 4))),
  ///            PickerDateRange(DateTime.now().add(Duration(days: 7)),
  ///                DateTime.now().add(Duration(days: 14)))
  ///          ],
  ///        ),
  ///      ),
  ///    );
  /// }
  ///
  /// ```
  final List<PickerDateRange>? initialSelectedRanges;

  /// An object that used for programmatic date navigation, date and range
  /// selection and view switching in [SfDateRangePicker].
  ///
  /// A [DateRangePickerController] served for several purposes. It can be used
  /// to selected dates and ranges programmatically on [SfDateRangePicker] by
  /// using the[controller.selectedDate], [controller.selectedDates],
  /// [controller.selectedRange], [controller.selectedRanges]. It can be used to
  /// change the [SfDateRangePicker] view by using the [controller.view]
  /// property. It can be used to navigate to specific date by using the
  /// [controller.displayDate] property.
  ///
  /// ## Listening to property changes:
  /// The [DateRangePickerController] is a listenable. It notifies it's
  /// listeners whenever any of attached [SfDateRangePicker]`s selected date,
  /// display date and view changed (i.e: selecting a different date, swiping to
  /// next/previous view and navigates to different view] in in
  /// [SfDateRangePicker].
  ///
  /// ## Navigates to different view:
  /// The [SfDateRangePicker] visible view can be changed by using the
  /// [Controller.view] property, the property allow to change the view of
  /// [SfDateRangePicker] programmatically on initial load and in run time.
  ///
  /// ## Programmatic selection:
  /// In [SfDateRangePicker] selecting dates programmatically can be achieved by
  /// using the [controller.selectedDate], [controller.selectedDates],
  /// [controller.selectedRange], [controller.selectedRanges] which allows to
  /// select the dates or ranges programmatically on [SfDateRangePicker] on
  /// initial load and in run time.
  ///
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [DateRangePickerController], to know more about the controller and it's
  /// usage with the date range picker.
  /// * [initialDisplayDate], which used to navigate the date range picker to
  /// the specific date initially.
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on date range picker.
  /// * [DateRangePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [onViewChanged], the callback which notifies when the current view
  /// visible date changed on the date range picker.
  /// * [onSelectionChanged], the callback which notifies when the selected cell
  /// changed on the the date range picker.
  /// * [showActionButtons], which allows to cancel of confirm the selection in
  /// the date range picker.
  /// * [onSubmit], the callback which notifies when the selected value
  /// confirmed through confirm button on date range picker.
  /// * [onCancel], the callback which notifies when the selected value canceled
  /// and reverted to previous  confirmed value through cancel button on date
  /// range picker.
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
  ///
  /// ``` dart
  ///
  ///class MyApp extends StatefulWidget {
  ///  @override
  ///  MyAppState createState() => MyAppState();
  ///}
  ///
  ///class MyAppState extends State<MyApp> {
  ///  DateRangePickerController _pickerController =
  ///  DateRangePickerController();
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
  ///      final List<DateTime> selectedDates =
  ///      _pickerController.selectedDates!;
  ///    } else if (propertyName == 'displayDate') {
  ///      final DateTime displayDate = _pickerController.displayDate!;
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
  final DateRangePickerController? controller;

  /// Displays the navigation arrows on the header view of [SfDateRangePicker].
  ///
  /// If this property set as [true] the header view of [SfDateRangePicker] will
  /// display the navigation arrows which used to navigate to the previous/next
  /// views through the navigation icon buttons.
  ///
  /// defaults to `false`.
  ///
  /// _Note:_ If the [DateRangePickerSelectionMode] set as range or multi range
  /// then the navigation arrows will be shown in the header by default, even if
  /// the [showNavigationArrow] property set as [false].
  ///
  /// If the [DateRangePickerMonthViewSettings.enableSwipeSelection] set as
  /// [false] the navigation arrows will be shown, only whn the
  /// [showNavigationArrow] property set as [true].
  ///
  /// See also:
  /// * [DateRangePickerController.forward], which allows to navigate to next
  /// view of the date range picker programmatically.
  /// * [DateRangePickerController.backward], which allows to navigate to
  /// previous view of the date range picker programmatically.
  ///  * Knowledge base: [How to navigate to the previous or next dates using navigation arrows](https://www.syncfusion.com/kb/12270/how-to-navigate-to-the-previous-or-next-views-using-navigation-arrows-in-the-flutter-date)
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///        ),
  ///     ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  final bool showNavigationArrow;

  /// The direction that [SfDateRangePicker] is navigating in.
  ///
  /// If it this property set as [DateRangePickerNavigationDirection.vertical]
  /// the [SfDateRangePicker] will navigate to the previous/next views in the
  /// vertical direction instead of the horizontal direction.
  ///
  /// Defaults to `DateRangePickerNavigationDirection.horizontal`.
  ///
  /// See also:
  /// * [navigationMode], which allows to customize the navigation mode with
  /// available options.
  /// * [minDate], which is the least available date in the date range picker.
  /// * [maxDate], which is the last available date in the date range picker.
  /// * [enableMultiView], which allows to display multiple picker side by
  /// side based on the navigation direction.
  /// * Knowledge base: [How to show two pickers vertically](https://www.syncfusion.com/kb/12193/how-to-show-two-pickers-vertically-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the navigation direction](https://www.syncfusion.com/kb/12176/how-to-change-the-navigation-direction-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to restrict swipe gesture for range selection](https://www.syncfusion.com/kb/12117/how-to-restrict-swipe-gesture-for-range-selection-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///          navigationDirection: DateRangePickerNavigationDirection.vertical,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerNavigationDirection navigationDirection;

  /// Defines the shape for the selection view in [SfDateRangePicker].
  ///
  /// If this property set as [DateRangePickerSelectionShape.rectangle] the
  /// widget will render the date selection in the rectangle shape in month
  /// view.
  ///
  /// Defaults to `DateRangePickerSelectionShape.circle`.
  ///
  /// _Note:_ When the [view] set with any other view than
  /// [DateRangePickerView.month] the today cell highlight shape will be
  /// determined by this property.
  ///
  /// If the [DateRangePickerSelectionShape] is set as
  /// [DateRangePickerSelectionShape.circle], then the circle radius can be
  /// adjusted in month view by using the [selectionRadius] property.
  ///
  /// See also:
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [allowViewNavigation], which allows to navigate between views quickly,
  /// and setting this property as `false`, allows to select the cells on
  /// year, decade and century view of date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of date range picker.
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///          selectionShape: DateRangePickerSelectionShape.rectangle,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerSelectionShape selectionShape;

  /// Allows to change the month text format in [SfDateRangePicker].
  ///
  /// The [SfDateRangePicker] will render the month format in the month view
  /// header with expanded month text format and the year view cells with the
  /// short month text format by default.
  ///
  /// If it is not [null] then the month view header and the year view cells
  /// month text will be formatted based on the format given in this property.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [headerStyle], which used to customize the header view of the date range
  /// picker.
  /// * [headerHeight], which is the size of the header view in the date range
  /// picker.
  /// * [yearCellStyle], which is used to customize the year, decade and century
  /// view cells in the date range picker.
  /// * Knowledge base: [How to customize the header view](https://www.syncfusion.com/kb/11427/how-to-customize-the-header-view-of-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the header in the flutter multi date range picker](https://www.syncfusion.com/kb/11897/how-to-customize-the-header-in-the-flutter-multi-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the month format](https://www.syncfusion.com/kb/12169/how-to-change-the-month-format-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///          monthFormat: 'EEE',
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final String? monthFormat;

  /// Defines the view navigation mode based on its [navigationDirection]
  /// for [SfDateRangePicker].
  ///
  /// Defaults to [DateRangePickerNavigationMode.snap]
  ///
  /// See also:
  /// * [navigationDirection], which allows to customize the navigation
  /// direction of the date range picker with available options.
  /// * [minDate], which is the least available date in the date range picker.
  /// * [maxDate], which is the last available date in the date range picker.
  /// * [enableMultiView], which allows to display multiple picker side by
  /// side based on the navigation direction.
  /// * Knowledge base: [How to show two pickers vertically](https://www.syncfusion.com/kb/12193/how-to-show-two-pickers-vertically-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the navigation direction](https://www.syncfusion.com/kb/12176/how-to-change-the-navigation-direction-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to restrict the view navigation](https://www.syncfusion.com/kb/12500/how-to-restrict-the-view-navigation-in-the-flutter-date-range-picker)
  ///
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfDateRangePicker(
  ///        navigationMode: DateRangePickerNavigationMode.scroll,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerNavigationMode navigationMode;

  /// Called when the current visible view or visible date range changes.
  ///
  /// The visible date range and the visible view which visible on view when the
  /// view changes available in the [DateRangePickerViewChangedArgs].
  ///
  /// See also:
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on date range picker.
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * [DateRangePickerViewChangedArgs], which contains the visible date range
  /// details of the current visible view.
  /// * [initialDisplayDate], which is used to navigate the date range picker to
  /// specific date on initially.
  /// * [DateRangePickerController.displayDate], which allows to move the
  /// date range picker to specific date.
  /// * [DateRangePickerController.forward], which allows to navigate to next
  /// view of the date range picker programmatically.
  /// * [DateRangePickerController.backward], which allows to navigate to
  /// previous view of the date range picker programmatically.
  /// * Knowledge base: [How to update blackout dates using onViewChanged callback](https://www.syncfusion.com/kb/12372/how-to-update-blackout-dates-using-onviewchanged-callback-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the header in flutter multi date range picker](https://www.syncfusion.com/kb/11897/how-to-customize-the-header-in-the-flutter-multi-date-range-picker-sfdaterangepicker)
  ///
  ///
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///          onViewChanged: (DateRangePickerViewChangedArgs args) {
  ///           final PickerDateRange _visibleDateRange = args.visibleDateRange;
  ///           final DateRangePickerView _visibleView = args.view;
  ///          },
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerViewChangedCallback? onViewChanged;

  /// Called when the new dates or date ranges selected.
  ///
  /// The dates or ranges that selected when the selection changes available in
  /// the [DateRangePickerSelectionChangedArgs].
  ///
  /// See also:
  /// * [onViewChanged], callback which notifies when the current view visible
  /// dates changed on date range picker.
  /// * [DateRangePickerMonthViewSettings.enableSwipeSelection], which allows to
  /// select the cells on swipe when the selection mode set as
  /// [DateRangePickerSelectionMode.range],
  /// [DateRangePickerSelectionMode.multiRange], and
  /// [DateRangePickerSelectionMode.extendableRange].
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [allowViewNavigation], which allows to navigate between views quickly,
  /// and setting this property as `false`, allows to select the cells on
  /// year, decade and century view of date range picker.
  /// * [toggleDaySelection], which allows to deselect a date when the selection
  /// mode set as [DateRangePickerSelectionMode.single].
  /// * [showActionButtons], which displays action buttons on bottom of date
  /// range picker, which allows to confirm and cancel the selection.
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on date range picker.
  /// * [DateRangePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on date range picker.
  /// * [DateRangePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on date range picker.
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select previous or next dates bases on selected date](https://www.syncfusion.com/kb/12354/how-to-select-previous-or-next-dates-based-on-the-selected-date-in-the-flutter-date-range)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  ///
  ///  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  ///    if (args.value is PickerDateRange) {
  ///      final DateTime rangeStartDate = args.value.startDate;
  ///      final DateTime rangeEndDate = args.value.endDate;
  ///    } else if (args.value is DateTime) {
  ///      final DateTime selectedDate = args.value;
  ///    } else if (args.value is List<DateTime>) {
  ///      final List<DateTime> selectedDates = args.value;
  ///    } else {
  ///      final List<PickerDateRange> selectedRanges = args.value;
  ///    }
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///        home: Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('DatePicker demo'),
  ///      ),
  ///      body: SfDateRangePicker(
  ///        onSelectionChanged: _onSelectionChanged,
  ///        selectionMode: DateRangePickerSelectionMode.range,
  ///        initialSelectedRange: PickerDateRange(
  ///            DateTime.now().subtract(Duration(days: 4)),
  ///            DateTime.now().add(Duration(days: 3))),
  ///      ),
  ///    ));
  ///  }
  ///}
  ///
  /// ```
  final DateRangePickerSelectionChangedCallback? onSelectionChanged;

  /// Text that displays on the confirm button.
  ///
  /// See also:
  /// * [showActionButtons], which allows to display action buttons at the
  /// bottom of the date range picker to handle the selection.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on date range picker.
  /// * [cancelText], which is text that display on the cancel button.
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Date Range Picker'),
  ///         ),
  ///         body: Container(
  ///             child: SfDateRangePicker(
  ///           confirmText: 'Confirm',
  ///           showActionButtons: true,
  ///         )));
  ///   }
  ///
  /// ```
  final String confirmText;

  /// Text that displays on the cancel button.
  ///
  /// See also:
  /// * [showActionButtons], which allows to display action buttons at the
  /// bottom of the date range picker to handle the selection.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on date range picker.
  /// * [confirmText], which is text that display on the confirm button.
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Date Range Picker'),
  ///         ),
  ///         body: Container(
  ///             child: SfDateRangePicker(
  ///           cancelText: 'Dismiss',
  ///           showActionButtons: true,
  ///         )));
  ///   }
  ///
  /// ```
  final String cancelText;

  /// Displays confirm and cancel buttons on the date range picker to perform
  /// the confirm and cancel actions.
  ///
  /// The [onSubmit] and [onCancel] callback is called based on the
  /// actions of the buttons.
  ///
  /// See also:
  /// * [DateRangePickerMonthViewSettings.enableSwipeSelection], which allows to
  /// select the cells on swipe when the selection mode set as
  /// [DateRangePickerSelectionMode.range],
  /// [DateRangePickerSelectionMode.multiRange], and
  /// [DateRangePickerSelectionMode.extendableRange].
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [allowViewNavigation], which allows to navigate between views quickly,
  /// and setting this property as `false`, allows to select the cells on
  /// year, decade and century view of date range picker.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on date range picker.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Date Range Picker'),
  ///         ),
  ///         body: Container(
  ///             child: SfDateRangePicker(
  ///           cancelText: 'Dismiss',
  ///           confirmText: 'Confirm',
  ///           showActionButtons: true,
  ///         )));
  ///   }
  ///
  /// ```
  final bool showActionButtons;

  /// Called whenever the cancel button tapped on date range picker.
  /// It reset the selected values to confirmed selected values.
  ///
  /// See also:
  /// * [showActionButtons], which allows to display action buttons at the
  /// bottom of the date range picker to handle the selection.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on date range picker.
  /// * [cancelText], which is text that display on the cancel button.
  /// * [confirmText], which is text that display on the confirm button
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///     return Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Date Range Picker'),
  ///         ),
  ///         body: Container(
  ///             child: SfDateRangePicker(
  ///           showActionButtons: true,
  ///           onCancel: () {
  ///             Navigator.pop(context);
  ///           },
  ///         )));
  ///   }
  ///
  /// ```
  final VoidCallback? onCancel;

  /// Called whenever the confirm button tapped on date range picker.
  /// The dates or ranges that have been selected are confirmed and the
  /// selected value is available in the value argument.
  ///
  /// See also:
  /// * [showActionButtons], which allows to display action buttons at the
  /// bottom of the date range picker to handle the selection.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on date range picker.
  /// * [cancelText], which is text that display on the cancel button.
  /// * [confirmText], which is text that display on the confirm button
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///     return Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Date Range Picker'),
  ///         ),
  ///         body: Container(
  ///             child: SfDateRangePicker(
  ///           showActionButtons: true,
  ///           onSubmit: (Object value) {
  ///             if (value is PickerDateRange) {
  ///               final DateTime rangeStartDate = value.startDate!;
  ///               final DateTime rangeEndDate = value.endDate!;
  ///             }​ else if (value is DateTime) {​
  ///               final DateTime selectedDate = value;
  ///             }​ else if (value is List<DateTime>) {​
  ///               final List<DateTime> selectedDates = value;
  ///             }​ else if (value is List<PickerDateRange>) {​
  ///               final List<PickerDateRange> selectedRanges = value;
  ///             }​
  ///           },
  ///         )));
  ///   }
  ///
  /// ```
  final Function(Object?)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return _SfDateRangePicker(
      key: key,
      view: view,
      selectionMode: selectionMode,
      headerHeight: headerHeight,
      todayHighlightColor: todayHighlightColor,
      backgroundColor: backgroundColor,
      initialSelectedDate: initialSelectedDate,
      initialSelectedDates: initialSelectedDates,
      initialSelectedRange: initialSelectedRange,
      initialSelectedRanges: initialSelectedRanges,
      toggleDaySelection: toggleDaySelection,
      enablePastDates: enablePastDates,
      showNavigationArrow: showNavigationArrow,
      selectionShape: selectionShape,
      navigationDirection: navigationDirection,
      controller: controller,
      onViewChanged: onViewChanged,
      onSelectionChanged: onSelectionChanged,
      onCancel: onCancel,
      onSubmit: onSubmit,
      headerStyle: headerStyle,
      yearCellStyle: yearCellStyle,
      monthViewSettings: monthViewSettings,
      initialDisplayDate: initialDisplayDate,
      minDate: minDate,
      maxDate: maxDate,
      monthCellStyle: monthCellStyle,
      allowViewNavigation: allowViewNavigation,
      enableMultiView: enableMultiView,
      viewSpacing: viewSpacing,
      selectionRadius: selectionRadius,
      selectionColor: selectionColor,
      startRangeSelectionColor: startRangeSelectionColor,
      endRangeSelectionColor: endRangeSelectionColor,
      rangeSelectionColor: rangeSelectionColor,
      selectionTextStyle: selectionTextStyle,
      rangeTextStyle: rangeTextStyle,
      monthFormat: monthFormat,
      cellBuilder: cellBuilder,
      navigationMode: navigationMode,
      confirmText: confirmText,
      cancelText: cancelText,
      showActionButtons: showActionButtons,
      showTodayButton: showTodayButton,
      selectableDayPredicate: selectableDayPredicate,
      extendableRangeSelectionDirection: extendableRangeSelectionDirection,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<DateRangePickerView>('view', view));
    properties.add(EnumProperty<DateRangePickerSelectionMode>(
        'selectionMode', selectionMode));
    properties.add(EnumProperty<DateRangePickerSelectionShape>(
        'selectionShape', selectionShape));
    properties.add(EnumProperty<DateRangePickerNavigationDirection>(
        'navigationDirection', navigationDirection));
    properties.add(EnumProperty<DateRangePickerNavigationMode>(
        'navigationMode', navigationMode));
    properties.add(DoubleProperty('headerHeight', headerHeight));
    properties.add(DoubleProperty('viewSpacing', viewSpacing));
    properties.add(DoubleProperty('selectionRadius', selectionRadius));
    properties.add(ColorProperty('todayHighlightColor', todayHighlightColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('selectionColor', selectionColor));
    properties.add(
        ColorProperty('startRangeSelectionColor', startRangeSelectionColor));
    properties
        .add(ColorProperty('endRangeSelectionColor', endRangeSelectionColor));
    properties.add(ColorProperty('rangeSelectionColor', rangeSelectionColor));
    properties.add(StringProperty('monthFormat', monthFormat));
    properties.add(DiagnosticsProperty<TextStyle>(
        'selectionTextStyle', selectionTextStyle));
    properties
        .add(DiagnosticsProperty<TextStyle>('rangeTextStyle', rangeTextStyle));
    properties.add(DiagnosticsProperty<DateTime>(
        'initialDisplayDate', initialDisplayDate));
    properties.add(DiagnosticsProperty<DateTime>(
        'initialSelectedDate', initialSelectedDate));
    properties.add(IterableDiagnostics<DateTime>(initialSelectedDates)
        .toDiagnosticsNode(name: 'initialSelectedDates'));
    properties.add(DiagnosticsProperty<PickerDateRange>(
        'initialSelectedRange', initialSelectedRange));
    properties.add(IterableDiagnostics<PickerDateRange>(initialSelectedRanges)
        .toDiagnosticsNode(name: 'initialSelectedRanges'));
    properties.add(DiagnosticsProperty<DateTime>('minDate', minDate));
    properties.add(DiagnosticsProperty<DateTime>('maxDate', maxDate));
    properties.add(DiagnosticsProperty<DateRangePickerCellBuilder>(
        'cellBuilder', cellBuilder));
    properties.add(
        DiagnosticsProperty<bool>('allowViewNavigation', allowViewNavigation));
    properties.add(
        DiagnosticsProperty<bool>('toggleDaySelection', toggleDaySelection));
    properties
        .add(DiagnosticsProperty<bool>('enablePastDates', enablePastDates));
    properties.add(
        DiagnosticsProperty<bool>('showNavigationArrow', showNavigationArrow));
    properties
        .add(DiagnosticsProperty<bool>('showActionButtons', showActionButtons));
    properties.add(StringProperty('cancelText', cancelText));
    properties.add(StringProperty('confirmText', confirmText));
    properties
        .add(DiagnosticsProperty<bool>('enableMultiView', enableMultiView));
    properties.add(DiagnosticsProperty<DateRangePickerViewChangedCallback>(
        'onViewChanged', onViewChanged));
    properties.add(DiagnosticsProperty<DateRangePickerSelectionChangedCallback>(
        'onSelectionChanged', onSelectionChanged));
    properties.add(DiagnosticsProperty<VoidCallback>('onCancel', onCancel));
    properties.add(DiagnosticsProperty<Function(Object)>('onSubmit', onSubmit));
    properties.add(DiagnosticsProperty<DateRangePickerController>(
        'controller', controller));

    properties.add(headerStyle.toDiagnosticsNode(name: 'headerStyle'));

    properties.add(yearCellStyle.toDiagnosticsNode(name: 'yearCellStyle'));

    properties
        .add(monthViewSettings.toDiagnosticsNode(name: 'monthViewSettings'));

    properties.add(monthCellStyle.toDiagnosticsNode(name: 'monthCellStyle'));

    properties
        .add(DiagnosticsProperty<bool>('showTodayButton', showTodayButton));
    properties.add(DiagnosticsProperty<DateRangePickerSelectableDayPredicate>(
        'selectableDayPredicate', selectableDayPredicate));
    properties.add(EnumProperty<ExtendableRangeSelectionDirection>(
        'extendableRangeSelectionDirection',
        extendableRangeSelectionDirection));
  }
}

/// A material design date range picker.
///
/// A [SfHijriDateRangePicker] can be used to select single date, multiple
/// dates, and range of dates in month view alone and provided month, year
/// and decade view options to quickly navigate to the desired date, it
/// supports [minDate],[maxDate] and disabled date to restrict the date
/// selection.
///
/// Default displays the [HijriDatePickerView.month] view with single
/// selection mode.
///
/// Set the [view] property with the desired [HijriDatePickerView] to
/// navigate to different views, or tap the [SfHijriDateRangePicker] header to
/// navigate to the next different view in the hierarchy.
///
/// The hierarchy of views is followed by
/// * [HijriDatePickerView.month]
/// * [HijriDatePickerView.year]
/// * [HijriDatePickerView.decade]
///
/// To change the selection mode, set the [selectionMode] property with the
/// [DateRangePickerSelectionMode] option.
///
/// To restrict the date navigation and selection interaction use [minDate],
/// [maxDate], the dates beyond this will be restricted.
///
/// When the selected dates or ranges change, the widget will call the
/// [onSelectionChanged] callback with new selected dates or ranges.
///
/// When the visible view changes, the widget will call the [onViewChanged]
/// callback with the current view and the current view visible dates.
///
/// Requires one of its ancestors to be a Material widget. This is typically
/// provided by a Scaffold widget.
///
/// Requires one of its ancestors to be a MediaQuery widget. Typically,
/// a MediaQuery widget is introduced by the MaterialApp or WidgetsApp widget
/// at the top of your application widget tree.
///
/// _Note:_ The picker widget allows to customize its appearance using
/// [SfDateRangePickerThemeData] available from [SfDateRangePickerTheme] widget
/// or the [SfTheme.dateRangePickerTheme] widget.
/// It can also be customized using the properties available in
/// [DateRangePickerHeaderStyle], [DateRangePickerViewHeaderStyle],
/// [HijriDatePickerMonthViewSettings],
/// [HijriDatePickerYearCellStyle], [HijriDatePickerMonthCellStyle]
///
/// See also:
/// * [SfDateRangePickerThemeData], which used to set consistent look for the
/// hijri date range picker element.
/// * [DateRangePickerHeaderStyle], which used to customize the header view of
/// the hijri date range picker.
/// * [DateRangePickerViewHeaderStyle], which used to customize the view header
/// view of the hijri date range picker.
/// * [HijriDatePickerMonthViewSettings], which used to customize the month view
/// of the hijri date range picker.
/// * [HijriDatePickerYearCellStyle], which used to customize the year, decade
/// and century views cell of the hijri date range picker.
/// * [HijriDatePickerMonthCellStyle], which used to customize the month cells
/// of month view in hijri date range picker.
/// * [SfDateRangePicker], Material widget, which used to display and
/// handle the gregorian date time values.
/// * Knowledge base: [How to use hijri date picker](https://www.syncfusion.com/kb/12200/how-to-use-hijri-date-range-picker-sfhijridaterangepicker-in-flutter)
///
/// ``` dart
///class MyApp extends StatefulWidget {
///  @override
///  MyAppState createState() => MyAppState();
///}
///
///class MyAppState extends State<MyApp> {
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfHijriDateRangePicker(
///          view: HijriDatePickerView.month,
///          selectionMode: DateRangePickerSelectionMode.range,
///          minDate: HijriDateTime(1440, 02, 05),
///          maxDate: HijriDateTime(1450, 12, 06),
///          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
///            final dynamic value = args.value;
///          },
///          onViewChanged: (HijriDatePickerViewChangedArgs args) {
///            final HijriDateRange visibleDates = args.visibleDateRange;
///            final HijriDatePickerView view = args.view;
///          },
///        ),
///      ),
///    );
///  }
///}
/// ```
@immutable
class SfHijriDateRangePicker extends StatelessWidget {
  /// Creates a material design date range picker.
  ///
  /// To restrict the date navigation and selection interaction use [minDate],
  /// [maxDate], the dates beyond this will be restricted.
  ///
  /// When the selected dates or ranges change, the widget will call the
  /// [onSelectionChanged] callback with new selected dates or ranges.
  ///
  /// When the visible view changes, the widget will call the [onViewChanged]
  /// callback with the current view and the current view visible dates.
  SfHijriDateRangePicker({
    Key? key,
    HijriDatePickerView view = HijriDatePickerView.month,
    this.selectionMode = DateRangePickerSelectionMode.single,
    this.headerHeight = 40,
    this.todayHighlightColor,
    this.backgroundColor,
    HijriDateTime? initialSelectedDate,
    List<HijriDateTime>? initialSelectedDates,
    HijriDateRange? initialSelectedRange,
    List<HijriDateRange>? initialSelectedRanges,
    this.toggleDaySelection = false,
    this.enablePastDates = true,
    this.showNavigationArrow = false,
    this.confirmText = 'OK',
    this.cancelText = 'CANCEL',
    this.showActionButtons = false,
    this.selectionShape = DateRangePickerSelectionShape.circle,
    this.navigationDirection = DateRangePickerNavigationDirection.horizontal,
    this.navigationMode = DateRangePickerNavigationMode.snap,
    this.allowViewNavigation = true,
    this.enableMultiView = false,
    this.controller,
    this.onViewChanged,
    this.onSelectionChanged,
    this.onCancel,
    this.onSubmit,
    this.headerStyle = const DateRangePickerHeaderStyle(),
    this.yearCellStyle = const HijriDatePickerYearCellStyle(),
    this.monthViewSettings = const HijriDatePickerMonthViewSettings(),
    HijriDateTime? initialDisplayDate,
    HijriDateTime? minDate,
    HijriDateTime? maxDate,
    this.monthCellStyle = const HijriDatePickerMonthCellStyle(),
    double viewSpacing = 20,
    this.selectionRadius = -1,
    this.selectionColor,
    this.startRangeSelectionColor,
    this.endRangeSelectionColor,
    this.rangeSelectionColor,
    this.selectionTextStyle,
    this.rangeTextStyle,
    this.monthFormat,
    this.cellBuilder,
    this.showTodayButton = false,
    this.selectableDayPredicate,
    this.extendableRangeSelectionDirection =
        ExtendableRangeSelectionDirection.both,
  })  : initialSelectedDate =
            controller != null && controller.selectedDate != null
                ? controller.selectedDate
                : initialSelectedDate,
        initialSelectedDates =
            controller != null && controller.selectedDates != null
                ? controller.selectedDates
                : initialSelectedDates,
        initialSelectedRange =
            controller != null && controller.selectedRange != null
                ? controller.selectedRange
                : initialSelectedRange,
        initialSelectedRanges =
            controller != null && controller.selectedRanges != null
                ? controller.selectedRanges
                : initialSelectedRanges,
        view = controller != null && controller.view != null
            ? controller.view!
            : view,
        initialDisplayDate =
            controller != null && controller.displayDate != null
                ? controller.displayDate!
                : initialDisplayDate ?? HijriDateTime.now(),
        minDate = minDate ?? HijriDateTime(1356, 01, 01),
        maxDate = maxDate ?? HijriDateTime(1499, 12, 30),
        viewSpacing = enableMultiView ? viewSpacing : 0,
        super(key: key);

  /// Defines the view for the [SfHijriDateRangePicker].
  ///
  /// Default to `HijriDatePickerView.month`.
  ///
  /// _Note:_ If the [controller] and it's [controller.view] property is not
  ///  null, then this property will be ignored and widget will display the view
  ///  described in [controller.view] property.
  ///
  /// Also refer [HijriDatePickerView].
  ///
  /// See also:
  /// * [HijriDatePickerView], to know more about the available views in the
  /// hijri date range picker.
  /// * [HijriDatePickerController.view], which used to changed the view of
  /// hijri date range picker dynamically.
  /// * [allowViewNavigation], which allows to navigate to different hijri date
  ///  range picker views quick and easily by tapping on the header.
  /// * [How to switch between the date range picker views when calendar has appointments](https://www.syncfusion.com/kb/11305/how-to-switch-between-the-date-range-picker-views-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to use hijri date picker](https://www.syncfusion.com/kb/12200/how-to-use-hijri-date-range-picker-sfhijridaterangepicker-in-flutter)
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.year,
  ///          minDate: HijriDateTime(1440, 02, 05),
  ///          maxDate: HijriDateTime(1450, 12, 06),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final HijriDatePickerView view;

  /// Defines the selection mode for [SfHijriDateRangePicker].
  ///
  /// Defaults to `DateRangePickerSelectionMode.single`.
  ///
  /// Also refer [DateRangePickerSelectionMode].
  ///
  /// _Note:_ If it set as Range or MultiRange, the navigation through swiping
  /// will be restricted by default and the navigation between views can be
  /// achieved by using the navigation arrows in header view.
  ///
  /// If it is set as Range or MultiRange and also the
  /// [HijriDatePickerMonthViewSettings.enableSwipeSelection] set as
  /// [false] the navigation through swiping will work as it is without any
  /// restriction.
  ///
  /// See also:
  /// * [HijriDatePickerMonthViewSettings.enableSwipeSelection], which allows to
  /// select the cells on swipe when the selection mode set as
  /// [DateRangePickerSelectionMode.range],
  /// [DateRangePickerSelectionMode.multiRange], and
  /// [DateRangePickerSelectionMode.extendableRange].
  /// * [DateRangePickerSelectionMode], to know more about the available
  /// selection modes in hijri date range picker.
  /// * [allowViewNavigation], which allows to navigate between views quickly,
  /// and setting this property as `false`, allows to select the cells on
  /// year and decade view of the hijri date range picker.
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in hijri date range picker.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on hijri date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the hijri date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in hijri date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in hijri date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of hijri date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// hijri date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of hijri date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of hijri date range picker.
  /// * [toggleDaySelection], which allows to deselect a date when the selection
  /// mode set as [DateRangePickerSelectionMode.single].
  /// * [showActionButtons], which displays action buttons on bottom of hijri
  ///  date range picker, which allows to confirm and cancel the selection.
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on hijri date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on hijri date range picker.
  /// * [HijriDatePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on hijri date range picker.
  /// * Knowledge base: [How to use hijri date range picker](https://www.syncfusion.com/kb/12200/how-to-use-hijri-date-range-picker-sfhijridaterangepicker-in-flutter)
  /// * Knowledge base: [Range selection using multiple view picker](https://www.syncfusion.com/kb/11534/range-selection-using-the-multiple-view-picker-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select a week](https://www.syncfusion.com/kb/11412/how-to-select-a-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select all days when clicking on the day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to use hijri date picker](https://www.syncfusion.com/kb/12200/how-to-use-hijri-date-range-picker-sfhijridaterangepicker-in-flutter)
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          minDate: HijriDateTime(1440, 02, 05),
  ///          maxDate: HijriDateTime(1450, 12, 06),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerSelectionMode selectionMode;

  /// Sets the style for customizing the [SfHijriDateRangePicker] header view.
  ///
  /// Allows to customize the [DateRangePickerHeaderStyle.textStyle],
  /// [DateRangePickerHeaderStyle.textAlign] and
  /// [DateRangePickerHeaderStyle.backgroundColor] of the header view in
  /// [SfHijriDateRangePicker].
  ///
  /// See also:
  /// * [DateRangePickerHeaderStyle], which contains options to customize the
  /// header view of the hijri date range picker.
  /// * [headerHeight], which is the size of the header view in the hijri date
  /// range picker.
  /// * [showNavigationArrow], which displays the navigation arrows on the
  /// header view of the hijri date range picker.
  /// * Knowledge base: [How to style a header](https://www.syncfusion.com/kb/12342/how-to-style-a-header-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select all days when clicking on the day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to restrict the year view navigation when tapping on header view](https://www.syncfusion.com/kb/12113/how-to-restrict-the-year-view-navigation-while-tapping-header-of-the-flutter-date-range)
  /// * Knowledge base: [How to customize the header in Flutter multi date range picker](https://www.syncfusion.com/kb/11897/how-to-customize-the-header-in-the-flutter-multi-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the header view](https://www.syncfusion.com/kb/11427/how-to-customize-the-header-view-of-the-flutter-date-range-picker)
  /// * Knowledge base: [How to use hijri date picker](https://www.syncfusion.com/kb/12200/how-to-use-hijri-date-range-picker-sfhijridaterangepicker-in-flutter)
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
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
  final DateRangePickerHeaderStyle headerStyle;

  /// The height for header view to layout within this in
  /// [SfHijriDateRangePicker].
  ///
  /// Defaults to value `40`.
  ///
  /// _Note:_ If [showNavigationArrows] set as true the arrows will shrink or
  /// grow based on the given header height value.
  ///
  /// See also:
  /// * [headerStyle], which allows to customize the header view of the hijri
  /// date range picker.
  /// * [showNavigationArrow], which displays the navigation arrows on the
  /// header view of the hijri date range picker.
  /// * Knowledge base: [How to style a header](https://www.syncfusion.com/kb/12342/how-to-style-a-header-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to select all days when clicking on the day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to restrict the year view navigation when tapping on header view](https://www.syncfusion.com/kb/12113/how-to-restrict-the-year-view-navigation-while-tapping-header-of-the-flutter-date-range)
  /// * Knowledge base: [How to customize the header in Flutter multi date range picker](https://www.syncfusion.com/kb/11897/how-to-customize-the-header-in-the-flutter-multi-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the header view](https://www.syncfusion.com/kb/11427/how-to-customize-the-header-view-of-the-flutter-date-range-picker)
  /// * Knowledge base: [How to navigate to the previous or next views using navigation arrows](https://www.syncfusion.com/kb/12270/how-to-navigate-to-the-previous-or-next-views-using-navigation-arrows-in-the-flutter-date)
  /// * Knowledge base: [How to use hijri date picker](https://www.syncfusion.com/kb/12200/how-to-use-hijri-date-range-picker-sfhijridaterangepicker-in-flutter)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          headerHeight: 50,
  ///          showNavigationArrow: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double headerHeight;

  /// Color that highlights the today date cell in [SfHijriDateRangePicker].
  ///
  /// Allows to change the color that highlights the today date cell border in
  /// month, year and decade view in date range picker.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [SfDateRangePickerThemeData], to handle theming with hijri date range
  /// picker for giving consistent look.
  /// * [monthCellStyle], which allows to customize the month cells in the
  /// hijri date range picker.
  /// * [yearCellStyle], which allows to customize the year cells in the hijri
  /// date range picker.
  /// * Knowledge base: [How to style the current month date cell](https://www.syncfusion.com/kb/12190/how-to-style-the-current-month-date-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year, decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to use hijri date picker](https://www.syncfusion.com/kb/12200/how-to-use-hijri-date-range-picker-sfhijridaterangepicker-in-flutter)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          todayHighlightColor: Colors.red,
  ///          showNavigationArrow: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? todayHighlightColor;

  /// The color to fill the background of the [SfHijriDateRangePicker].
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [SfDateRangePickerThemeData], to handle theming with hijri date range
  /// picker for giving consistent look.
  /// * Knowledge base: [How to add an image as background](https://www.syncfusion.com/kb/12233/how-to-add-an-image-as-background-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          todayHighlightColor: Colors.red,
  ///          backgroundColor: Colors.cyanAccent,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? backgroundColor;

  /// Allows to deselect a date when the [DateRangePickerSelectionMode] set as
  /// [DateRangePickerSelectionMode.single].
  ///
  /// When this [toggleDaySelection] property set as [true] tapping on a single
  /// date for the second time will clear the selection, which means setting
  /// this property as [true] allows to deselect a date when the
  /// [DateRangePickerSelectionMode] set as single.
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [selectionMode], which allows to set different selection modes for
  /// hijri date range picker.
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in hijri date range picker.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on hijri date range picker.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// hijri date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on hijri date range picker.
  /// * [HijriDatePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on hijri date range picker.
  /// * Knowledge base: [How to deselect the selected date](https://www.syncfusion.com/kb/12138/how-to-deselect-the-selected-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          toggleDaySelection: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool toggleDaySelection;

  /// A builder that builds a widget that replaces the cell in a month, year,
  /// and decade views. The month cell, year cell, decade cell,
  /// was differentiated by picker view.
  ///
  /// See also:
  /// * [monthViewSettings], which allows to customize the month view in the
  /// hijri date range picker.
  /// * [monthCellStyle], which allows to customize the month cells in the hijri
  /// date range picker.
  /// * [yearCellStyle], which allows to customize the year cells in the hijri
  /// date range picker.
  /// * Knowledge base: [How to customize special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select all days when clicking on day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// HijriDatePickerController _controller = HijriDatePickerController();
  ///
  /// @override
  /// void initState() {
  ///  _controller.view = HijriDatePickerView.month;
  ///  super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///       home: Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text('Date range picker'),
  ///     ),
  ///     body: SfHijriDateRangePicker(
  ///       controller: _controller,
  ///       cellBuilder: (BuildContext context,
  ///             HijriDateRangePickerCellDetails cellDetails) {
  ///         if (_controller.view == HijriDatePickerView.month) {
  ///           return Container(
  ///             width: cellDetails.bounds.width,
  ///             height: cellDetails.bounds.height,
  ///             alignment: Alignment.center,
  ///             child: Text(cellDetails.date.day.toString()),
  ///           );
  ///         } else if (_controller.view == HijriDatePickerView.year) {
  ///           return Container(
  ///             width: cellDetails.bounds.width,
  ///             height: cellDetails.bounds.height,
  ///             alignment: Alignment.center,
  ///             child: Text(cellDetails.date.month.toString()),
  ///           );
  ///         } else if (_controller.view == HijriDatePickerView.decade) {
  ///           return Container(
  ///             width: cellDetails.bounds.width,
  ///             height: cellDetails.bounds.height,
  ///             alignment: Alignment.center,
  ///             child: Text(cellDetails.date.year.toString()),
  ///           );
  ///         } else {
  ///           final int yearValue = (cellDetails.date.year ~/ 10) * 10;
  ///           return Container(
  ///             width: cellDetails.bounds.width,
  ///             height: cellDetails.bounds.height,
  ///             alignment: Alignment.center,
  ///             child: Text(
  ///                yearValue.toString() + ' - ' + (yearValue + 9).toString()),
  ///           );
  ///         }
  ///       },
  ///     ),
  ///   ));
  ///  }
  ///
  /// ```
  final HijriDateRangePickerCellBuilder? cellBuilder;

  /// Displays the today button on the bottom of the SfHijriDateRangePicker.
  ///
  /// The today button allows to navigate to the today date quickly in all view
  /// of the SfHijriDateRangePicker.
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [showActionButtons], which used to handle the selected value.
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          showTodayButton: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool showTodayButton;

  /// An [selectableDayPredicate] callback to decide whether the cell is
  /// selectable or not in hijri date range picker.
  ///
  /// Note: This callback is not applicable when the [navigationMode] set as
  /// [DateRangePickerNavigationMode.scroll].
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// [HijriDatePickerMonthViewSettings.blackoutDates], which allows to
  /// disable interaction for specific dates.
  ///
  /// ```dart
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///       home: Scaffold(
  ///         body: SfHijriDateRangePicker(
  ///           initialDisplayDate: HijriDateTime(1442, 1, 1),
  ///           selectableDayPredicate: (HijriDateTime dateTime) {
  ///             if (dateTime != HijriDateTime(1442, 1, 1)) {
  ///               return false;
  ///             }
  ///             return true;
  ///           },
  ///         ),
  ///       ));
  /// }
  ///
  /// ```
  final HijriDatePickerSelectableDayPredicate? selectableDayPredicate;

  /// Allows to customize the extendable range selection direction.
  ///
  /// Defaults to `ExtendableRangeSelectionDirection.both`.
  ///
  /// See also:
  /// [selectionMode], which contains available selection modes for
  /// date range picker.
  ///
  /// _Note:_ This  applicable only when the [selectionMode]
  /// set as [DateRangePickerSelectionMode.extendableRange].
  ///
  /// ``` dart
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          minDate: DateTime(2019, 02, 05),
  ///          maxDate: DateTime(2021, 12, 06),
  ///          extendableRangeSelectionDirection:
  ///           ExtendableRangeSelectionDirection.backward,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final ExtendableRangeSelectionDirection extendableRangeSelectionDirection;

  /// Used to enable or disable the view switching between
  /// [HijriDatePickerView] through interaction in the
  /// [SfHijriDateRangePicker] header.
  ///
  /// Selection is allowed for year and decade views when the
  /// [allowViewNavigation] property is false.
  /// Otherwise, year and decade views are allowed only for view
  /// navigation.
  ///
  /// Defaults to `true`.
  ///
  /// See also:
  /// * [view], which allows to set different views which display initially on
  /// hijri date range picker.
  /// * [HijriDatePickerController.view], which allows to set different views
  /// dynamically on hijri date range picker.
  /// * Knowledge base: [How to restrict the year view navigation while tapping header](https://www.syncfusion.com/kb/12113/how-to-restrict-the-year-view-navigation-while-tapping-header-of-the-flutter-date-range)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          allowViewNavigation: false,
  ///       ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool allowViewNavigation;

  /// Used to enable or disable showing multiple views
  ///
  /// When setting this [enableMultiView] property set to [true] displaying
  /// multiple views and provide quick navigation and dates selection.
  /// It is applicable for all the [HijriDatePickerView] types.
  ///
  ///
  /// Enabling this [enableMultiView] property is recommended for web
  /// browser and larger android and iOS devices(iPad, tablet, etc.,)
  ///
  /// Note : Each of the views have individual header when the [textAlign]
  /// property in the [headerStyle] as center
  /// eg.,    Muharram, 1442                 Safar, 1442
  /// otherwise, shown a single header for the multiple views
  /// eg., Muharram, 1442 - Safar, 1442
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [viewSpacing], which fills the space between the pickers in the hijri
  /// date range picker.
  /// * [navigationDirection], which allows to arrange and navigate the
  /// multiview in either in [DateRangePickerNavigationDirection.vertical] or
  /// [DateRangePickerNavigationDirection.horizontal] in hijri date range
  /// picker.
  /// * Knowledge base: [How to show tow pickers vertically](https://www.syncfusion.com/kb/12193/how-to-show-two-pickers-vertically-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to use multiple picker](https://www.syncfusion.com/kb/11806/how-to-use-multiple-picker-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          enableMultiView: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final bool enableMultiView;

  /// Used to define the space[double] between multiple views when the
  /// [enableMultiView] is enabled.
  /// Otherwise, the [viewSpacing] value as not applied in
  /// [SfHijriDateRangePicker].
  ///
  /// Defaults to value `20`.
  ///
  /// This value not applicable on [SfHijriDateRangePicker] when
  /// [navigationMode] is [DateRangePickerNavigationMode.scroll].
  ///
  /// See also:
  /// * [enableMultiView], which allows displays multiple date picker side by
  /// side in hijri date range picker.
  /// * [navigationDirection], which allows to arrange and navigate the
  /// multiview in either in [DateRangePickerNavigationDirection.vertical] or
  /// [DateRangePickerNavigationDirection.horizontal] in hijri date range
  /// picker.
  /// * Knowledge base: [How to show tow pickers vertically](https://www.syncfusion.com/kb/12193/how-to-show-two-pickers-vertically-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to use multiple picker](https://www.syncfusion.com/kb/11806/how-to-use-multiple-picker-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          enableMultiView: true,
  ///          viewSpacing: 20,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double viewSpacing;

  /// The radius for the [SfHijriDateRangePicker] selection circle.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ This only applies if the [DateRangePickerSelectionMode] is set
  /// to [DateRangePickerSelectionMode.circle].
  ///
  /// See also:
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in hijri date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the hijri date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in hijri date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in hijri date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of hijri date range picker in range selection.
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of hijri date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of hijri date range picker.
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
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
  ///          selectionRadius: 20,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final double selectionRadius;

  /// The text style for the text in the selected date or dates cell of
  /// [SfHijriDateRangePicker].
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// * [selectionRadius], which is the radius for the selection view in the
  /// hijri date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionColor], which fills the background of the selected cells in
  /// the hijri date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in hijri date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in hijri date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of hijri date range picker in range selection.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of hijri date range picker.
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfda
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
  ///          selectionTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.normal,
  ///                  fontWeight: FontWeight.w500,
  ///                  fontSize: 12,
  ///                  color: Colors.white),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? selectionTextStyle;

  /// The text style for the text in the selected range or ranges cell of
  /// [SfHijriDateRangePicker] month view.
  ///
  /// The style applies to the dates that falls between the
  /// [HijriDateRange.startDate] and [HijriDateRange.endDate].
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
  /// * [HijriDateRange], which used to holds the start and end date of the
  /// selected range.
  /// * [selectionMode], which allows to customize the selection modes with the
  /// available modes.
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in hijri date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the hijri date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in hijri date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in hijri date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of hijri date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// hijri date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of hijri date range picker.
  /// * Knowledge base: [Range selection using multiple view picker](https://www.syncfusion.com/kb/11534/range-selection-using-the-multiple-view-picker-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
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
  ///          rangeTextStyle: TextStyle(
  ///                  fontStyle: FontStyle.italic,
  ///                  fontWeight: FontWeight.w500,
  ///                  fontSize: 12,
  ///                  color: Colors.black),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final TextStyle? rangeTextStyle;

  /// The color which fills the [SfHijriDateRangePicker] selection view.
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
  /// See more:
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in hijri date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in hijri date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in hijri date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of hijri date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// hijri date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of hijri date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of hijri date range picker.
  /// * Knowledge base: [Range selection using multiple view picker](https://www.syncfusion.com/kb/11534/range-selection-using-the-multiple-view-picker-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          selectionColor: Colors.red,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? selectionColor;

  /// The color which fills the [SfHijriDateRangePicker] selection view of the
  /// range start date.
  ///
  /// The color fills to the selection view of the date in
  /// [HijriDateRange.startDate] property.
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
  /// See also:
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in hijri date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the hijri date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in hijri date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of hijri date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// hijri date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of hijri date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of hijri date range picker.
  /// * [toggleDaySelection], which allows to deselect a date when the selection
  /// mode set as [DateRangePickerSelectionMode.single].
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///         controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          startRangeSelectionColor: Colors.red,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? startRangeSelectionColor;

  /// The color which fills the [SfHijriDateRangePicker] selection view for the
  /// range of dates which falls between the [HijriDateRange.startDate]
  /// and [HijriDateRange.endDate].
  ///
  /// The color fills to the selection view of the dates in between the
  /// [HijriDateRange.startDate] and [HijriDateRange.endDate]
  /// property.
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
  /// See also:
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in hijri date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the hijri date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in hijri date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in hijri date range picker.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// hijri date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of hijri date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of hijri date range picker.
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          rangeSelectionColor: Colors.red.withOpacity(0.4),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? rangeSelectionColor;

  /// The color which fills the [SfHijriDateRangePicker] selection view of the
  /// range end date.
  ///
  /// The color fills to the selection view of the date in
  /// [HijriDateRange.endDate] property.
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
  /// See also:
  /// * [selectionShape], which allows to customize the shape of the selection
  /// view in hijri date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the hijri date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in hijri date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of hijri date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// hijri date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of hijri date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of hijri date range picker.
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///         controller: _pickerController,
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          endRangeSelectionColor: Colors.red,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color? endRangeSelectionColor;

  /// Options to customize the month view of the [SfHijriDateRangePicker].
  ///
  /// Allows to customize the
  /// [HijriDatePickerMonthViewSettings.firstDayOfWeek],
  /// [HijriDatePickerMonthViewSettings.dayFormat],
  /// [HijriDatePickerMonthViewSettings.viewHeaderHeight],
  /// [HijriDatePickerMonthViewSettings.viewHeaderStyle],
  /// [HijriDatePickerMonthViewSettings.enableSwipeSelection],
  /// [HijriDatePickerMonthViewSettings.blackoutDates],
  /// [HijriDatePickerMonthViewSettings.specialDates]
  /// and [HijriDatePickerMonthViewSettings.weekendDays] in month view of
  /// date range picker.
  ///
  /// See also:
  /// * [HijriDatePickerMonthViewSettings], to know more about available options
  /// to customize the month view of hijri date range picker
  /// * [monthCellStyle], which allows to customize the month cell of the month
  /// view of the hijri date range picker
  /// * [cellBuilder], which allows to set custom widget for the picker cells
  /// in the hijri date range picker.
  /// * [yearCellStyle], which allows to customize the year cell of the year,
  /// and decade views of the hijri date range picker.
  /// * [backgroundColor], which fills the background of the hijri date range
  /// picker.
  /// * [todayHighlightColor], which highlights the today date cell in the hijri
  /// date range picker.
  /// * Knowledge base: [How to customize the special dates using builder](https://www.syncfusion.com/kb/12374/how-to-customize-the-special-dates-using-builder-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to update blackout dates using onViewChanged callback](https://www.syncfusion.com/kb/12372/how-to-update-blackout-dates-using-onviewchanged-callback-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select all days when clicking on the day header](https://www.syncfusion.com/kb/12353/how-to-select-all-days-when-clicking-on-the-day-header-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the first day of week](https://www.syncfusion.com/kb/12221/how-to-change-the-first-day-of-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the date range picker cells using builder](https://www.syncfusion.com/kb/12208/how-to-customize-the-date-range-picker-cells-using-builder-in-the-flutter-sfdaterangepicker)
  /// * Knowledge base: [How to change the week end dates](https://www.syncfusion.com/kb/12182/how-to-change-the-week-end-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to add active dates](https://www.syncfusion.com/kb/12075/how-to-add-active-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to apply theming](https://www.syncfusion.com/kb/11898/how-to-apply-theming-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to restrict swipe gesture for range selection](https://www.syncfusion.com/kb/12117/how-to-restrict-swipe-gesture-for-range-selection-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionRadius: 10,
  ///          monthViewSettings: HijriDatePickerMonthViewSettings(
  ///              firstDayOfWeek: 1,
  ///              dayFormat: 'E',
  ///              viewHeaderHeight: 70,
  ///              viewHeaderStyle: DateRangePickerViewHeaderStyle(
  ///                  backgroundColor: Colors.blue,
  ///                  textStyle:
  ///                      TextStyle(fontWeight: FontWeight.w400,
  ///                           fontSize: 15, color: Colors.black)),
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
  final HijriDatePickerMonthViewSettings monthViewSettings;

  /// Options to customize the year and decade view of the
  /// [SfHijriDateRangePicker].
  ///
  /// Allows to customize the [HijriDatePickerYearCellStyle.textStyle],
  /// [HijriDatePickerYearCellStyle.todayTextStyle],
  /// [HijriDatePickerYearCellStyle.disabledDatesTextStyle],
  /// [HijriDatePickerYearCellStyle.cellDecoration],
  /// [HijriDatePickerYearCellStyle.todayCellDecoration],
  /// [HijriDatePickerYearCellStyle.disabledDatesDecoration] in year and
  /// decade view of the date range picker.
  ///
  /// See also:
  /// * [HijriDatePickerYearCellStyle], to know more about available options
  /// to customize the year cells of hijri date range picker
  /// * [monthCellStyle], which allows to customize the month cell of the month
  /// view of the hijri date range picker
  /// * [cellBuilder], which allows to set custom widget for the picker cells
  /// in the hijri date range picker.
  /// * [monthViewSettings], which allows to customize the month view of the
  /// hijri date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the hijri date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in hijri date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in hijri date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of hijri date range picker in range selection.
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of hijri date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of hijri date range picker.
  /// * [backgroundColor], which fills the background of the hijri date range
  /// picker.
  /// * [todayHighlightColor], which highlights the today date cell in the hijri
  /// date range picker.
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
  ///                border: Border.all(color: const Color(0xFFB6B6B6),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final HijriDatePickerYearCellStyle yearCellStyle;

  /// Options to customize the month cells of the [SfHijriDateRangePicker].
  ///
  /// Allows to customize the [HijriDatePickerMonthCellStyle.textStyle],
  /// [HijriDatePickerMonthCellStyle.todayTextStyle],
  /// [HijriDatePickerMonthCellStyle.disabledDatesTextStyle],
  /// [HijriDatePickerMonthCellStyle.blackoutDateTextStyle],
  /// [HijriDatePickerMonthCellStyle.weekendTextStyle],
  /// [HijriDatePickerMonthCellStyle.specialDatesTextStyle],
  /// [HijriDatePickerMonthCellStyle.specialDatesDecoration],
  /// [HijriDatePickerMonthCellStyle.blackoutDatesDecoration],
  /// [HijriDatePickerMonthCellStyle.cellDecoration],
  /// [HijriDatePickerMonthCellStyle.todayCellDecoration],
  /// [HijriDatePickerMonthCellStyle.disabledDatesDecoration],
  /// [HijriDatePickerMonthCellStyle.weekendDatesDecoration]  in the month
  /// cells of the date range picker.
  ///
  /// See also:
  /// * [HijriDatePickerMonthCellStyle] to know more about available options
  /// to customize the month cell of hijri date range picker
  /// * [monthViewSettings], which allows to customize the month view of the
  /// hijri date range picker
  /// * [cellBuilder], which allows to set custom widget for the picker cells
  /// in the hijri date range picker.
  /// * [yearCellStyle], which allows to customize the year cell of the year,
  /// and decade views of the hijri date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the hijri date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in hijri date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in hijri date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of hijri date range picker in range selection.
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of hijri date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of hijri date range picker.
  /// * [backgroundColor], which fills the background of the hijri date range
  /// picker.
  /// * [todayHighlightColor], which highlights the today date cell in the hijri
  /// date range picker.
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
  ///                border: Border.all(color: const Color(0xFFB6B6B6),
  ///                     width: 1),
  ///                shape: BoxShape.circle),
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final HijriDatePickerMonthCellStyle monthCellStyle;

  /// The initial date to show on the [SfHijriDateRangePicker]
  ///
  /// The [SfHijriDateRangePicker] will display the dates based on the date set
  /// in this property.
  ///
  /// Defaults to current date.
  ///
  /// _Note:_ If the [controller] and it's [controller.displayDate] property is
  /// not [null] then this property will be ignored and the widget render the
  /// dates based on the date given in [controller.displayDate].
  ///
  /// See also:
  /// * [HijriDatePickerController.displayDate], which allows to move the
  /// hijri date range picker to specific date.
  /// * [HijriDatePickerController.forward], which allows to navigate to next
  /// view of the hijri date range picker programmatically.
  /// * [HijriDatePickerController.backward], which allows to navigate to
  /// previous view of the date range picker programmatically.
  /// * [onViewChanged], the callback which will notify that the current visible
  /// dates were changed in hijri date range picker.
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on hijri date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on hijri date range picker.
  /// * [minDate], which is the least available date for the hijri date range
  /// picker.
  /// * [maxDate], which is the last available date for the hijri date range
  /// picker.
  /// * [showNavigationArrow], which display the navigation arrows on the header
  /// view of the hijri date range picker.
  /// * Knowledge base: [How to navigate to the previous or next views using navigation arrows](https://www.syncfusion.com/kb/12270/how-to-navigate-to-the-previous-or-next-views-using-navigation-arrows-in-the-flutter-date)
  /// * Knowledge base: [How to do programmatic navigation](https://www.syncfusion.com/kb/12140/how-to-do-programmatic-navigation-using-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically navigate to adjacent dates](https://www.syncfusion.com/kb/12137/how-to-programmatically-navigate-to-the-adjacent-dates-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically navigate](https://www.syncfusion.com/kb/12135/how-to-programmatically-navigate-to-the-date-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to restrict date range picker within date limit](https://www.syncfusion.com/kb/11329/how-to-restrict-date-range-picker-within-the-date-limit-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          initialDisplayDate: HijriDateTime(1450, 02, 05),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final HijriDateTime initialDisplayDate;

  /// The date to initially select on the [SfHijriDateRangePicker].
  ///
  /// The [SfHijriDateRangePicker] will select the date that set to this
  /// property.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ If the [controller] and it's [controller.selectedDate] property is
  ///  not [null] then this property will be ignored and the widget render the
  /// selection for the date given in [controller.selectedDate].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.single].
  ///
  /// See also:
  /// * [initialDisplayDate], which used to navigate the hijri date range picker
  ///  to the specific date initially.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on hijri date range picker.
  /// * [HijriDatePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on hijri date range picker.
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [onSelectionChanged], the callback which notifies when the selection
  /// cell changed on the hijri date range picker.
  /// * [showActionButtons], which allows to cancel of confirm the selection in
  /// the hijri date range picker.
  /// * [onSubmit], the callback which notifies when the selected value
  /// confirmed through confirm button on hijri date range picker.
  /// * [onCancel], the callback which notifies when the selected value canceled
  /// and reverted to previous  confirmed value through cancel button on hijri
  /// date range picker.
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to deselect the selected date](https://www.syncfusion.com/kb/12138/how-to-deselect-the-selected-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)///
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          initialSelectedDate:
  ///                             HijriDateTime.now().add((Duration(days: 5))),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final HijriDateTime? initialSelectedDate;

  /// The minimum date as much as the [SfHijriDateRangePicker] will navigate.
  ///
  /// The [SfHijriDateRangePicker] widget will navigate as minimum as to the
  /// given date, and the dates before that date will be disabled for
  /// interaction and navigation to those dates were restricted.
  ///
  /// Defaults to `1st Muharram of 1356`.
  ///
  /// _Note:_ If the [initialDisplayDate] or [controller.displayDate] property
  /// set with the date prior to this date, the [SfHijriDateRangePicker] will
  /// take this min date as a display date and render dates based on the date
  /// set to this property.
  ///
  ///
  /// See also:
  /// * [initialDisplayDate], which used to navigate the hijri date range picker
  /// to the specific date on initially.
  /// * [maxDate], which is last available date for the hijri date range picker.
  /// * [controller.displayDate], which used to navigate the hijri date range
  /// picker to specific date on dynamically.
  /// * [enablePastDates], which allows to enable the dates that falls before
  /// the today date for interaction.
  /// * [HijriDateTime], which handles the hijri date value details.
  /// * Knowledge base: [How to enable or disable the past dates](https://www.syncfusion.com/kb/12168/how-to-enable-or-disable-the-past-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to restrict date range picker within the date limit](https://www.syncfusion.com/kb/11329/how-to-restrict-date-range-picker-within-the-date-limit-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          minDate: HijriDateTime(1440, 01, 01),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final HijriDateTime minDate;

  /// The maximum date as much as the [SfHijriDateRangePicker] will navigate.
  ///
  /// The [SfHijriDateRangePicker] widget will navigate as maximum as to the
  /// given date, and the dates after that date will be disabled for interaction
  /// and navigation to those dates were restricted.
  ///
  /// Defaults to `30th Dhu al-Hijjah of 1499`.
  ///
  /// _Note:_ If the [initialDisplayDate] or [controller.displayDate] property
  /// set with the date after to this date, the [SfHijriDateRangePicker] will
  /// take this max date as a display date and render dates based on the date
  /// set to this property.
  ///
  /// See also:
  /// * [initialDisplayDate], which used to navigate the hijri date range picker
  /// to the specific date on initially.
  /// * [minDate], which is least available date for the hijri date range
  /// picker.
  /// * [controller.displayDate], which used to navigate the hijri date range
  /// picker to specific date on dynamically.
  /// * [enablePastDates], which allows to enable the dates that falls before
  /// the today date for interaction.
  /// * [HijriDateTime], which handles the date value in hijri type.
  /// * Knowledge base: [How to enable or disable the past dates](https://www.syncfusion.com/kb/12168/how-to-enable-or-disable-the-past-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to restrict date range picker within the date limit](https://www.syncfusion.com/kb/11329/how-to-restrict-date-range-picker-within-the-date-limit-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          maxDate: HijriDateTime(1450, 12, 30),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final HijriDateTime maxDate;

  /// Allows to disable the dates falls before the today date in
  /// [SfHijriDateRangePicker].
  ///
  /// If it is set as [false] the dates falls before the today date is disabled
  /// and selection interactions to that dates were restricted.
  ///
  /// Defaults to `true`.
  ///
  /// See also:
  /// * [minDate], which is the least available date for the hijri date range
  /// picker.
  /// * [maxDate], which is last available date for the hijri date range picker.
  /// * Knowledge base: [How to enable or disable the past dates](https://www.syncfusion.com/kb/12168/how-to-enable-or-disable-the-past-dates-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to restrict date range picker within the date limit](https://www.syncfusion.com/kb/11329/how-to-restrict-date-range-picker-within-the-date-limit-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          enablePastDates: false,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///```
  final bool enablePastDates;

  /// The collection of dates to initially select on the
  /// [SfHijriDateRangePicker].
  ///
  /// If it is not [null] the [SfHijriDateRangePicker] will select the dates
  /// that set to this property.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ If the [controller] and it's [controller.selectedDates] property
  /// is not [null] then this property will be ignored and the widget render the
  /// selection for the dates given in [controller.selectedDates].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiple].
  ///
  /// See also:
  /// * [initialDisplayDate], which used to navigate the hijri date range picker
  /// to the specific date initially.
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on hijri date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on hijri date range picker.
  /// * [HijriDatePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on hijri date range picker.
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [onSelectionChanged], the callback which notifies when the selection
  /// cell changed on the hijri date range picker.
  /// * [showActionButtons], which allows to cancel of confirm the selection in
  /// the hijri date range picker.
  /// * [onSubmit], the callback which notifies when the selected value
  /// confirmed through confirm button on hijri date range picker.
  /// * [onCancel], the callback which notifies when the selected value canceled
  /// and reverted to previous  confirmed value through cancel button on hijri
  /// date range picker.
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  /// return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          initialSelectedDates: <HijriDateTime>[
  ///            HijriDateTime.now().add((Duration(days: 4))),
  ///            HijriDateTime.now().add((Duration(days: 5))),
  ///            HijriDateTime.now().add((Duration(days: 9))),
  ///            HijriDateTime.now().add((Duration(days: 11)))
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///}
  ///
  /// ```
  final List<HijriDateTime>? initialSelectedDates;

  /// The date range to initially select on the [SfHijriDateRangePicker].
  ///
  /// If it is not [null] the [SfHijriDateRangePicker] will select the range of
  /// dates that set to this property.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ If the [controller] and it's [controller.selectedRange] property
  /// is not [null] then this property will be ignored and the widget render the
  /// selection for the range given in [controller.selectedRange].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.range].
  ///
  /// See also:
  /// * [HijriDateRange], which is used to store the start and end date of the
  /// range selection.
  /// * [initialDisplayDate], which used to navigate the hijri date range picker
  /// to the specific date initially.
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on hijri date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on hijri date range picker.
  /// * [HijriDatePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on hijri date range picker.
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [onSelectionChanged], the callback which notifies when the selection
  /// cell changed on the hijri date range picker.
  /// * [showActionButtons], which allows to cancel of confirm the selection in
  /// the hijri date range picker.
  /// * [onSubmit], the callback which notifies when the selected value
  /// confirmed through confirm button on hijri date range picker.
  /// * [onCancel], the callback which notifies when the selected value canceled
  /// and reverted to previous  confirmed value through cancel button on hijri
  /// date range picker.
  /// * Knowledge base: [Range selection using multiple view picker](https://www.syncfusion.com/kb/11534/range-selection-using-the-multiple-view-picker-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select a week](https://www.syncfusion.com/kb/11412/how-to-select-a-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select previous or next dates bases on selected date](https://www.syncfusion.com/kb/12354/how-to-select-previous-or-next-dates-based-on-the-selected-date-in-the-flutter-date-range)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to restrict swipe gesture for range selection](https://www.syncfusion.com/kb/12117/how-to-restrict-swipe-gesture-for-range-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  /// return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          initialSelectedRange: HijriDateRange(
  ///              HijriDateTime.now().subtract((Duration(days: 4))),
  ///              HijriDateTime.now().add(Duration(days: 4))),
  ///        ),
  ///      ),
  ///    );
  /// }
  ///
  /// ```
  final HijriDateRange? initialSelectedRange;

  /// The date ranges to initially select on the [SfHijriDateRangePicker].
  ///
  /// If it is not [null] the [SfHijriDateRangePicker] will select the range of
  /// dates that set to this property.
  ///
  /// Defaults to null.
  ///
  /// _Note:_ If the [controller] and it's [controller.selectedRanges] property
  /// is not [null] then this property will be ignored and the widget render the
  /// selection for the ranges given in [controller.selectedRanges].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// See also:
  /// * [HijriDateRange], which is used to store the start and end date of the
  /// range selection.
  /// * [initialDisplayDate], which used to navigate the hijri date range picker
  /// to the specific date initially.
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on hijri date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on hijri date range picker.
  /// * [HijriDatePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on hijri date range picker.
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [onSelectionChanged], the callback which notifies when the selection
  /// cell changed on the hijri date range picker.
  /// * [showActionButtons], which allows to cancel of confirm the selection in
  /// the hijri date range picker.
  /// * [onSubmit], the callback which notifies when the selected value
  /// confirmed through confirm button on hijri date range picker.
  /// * [onCancel], the callback which notifies when the selected value canceled
  /// and reverted to previous confirmed value through cancel button on hijri
  /// date range picker.
  /// * Knowledge base: [Range selection using multiple view picker](https://www.syncfusion.com/kb/11534/range-selection-using-the-multiple-view-picker-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select a week](https://www.syncfusion.com/kb/11412/how-to-select-a-week-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select previous or next dates bases on selected date](https://www.syncfusion.com/kb/12354/how-to-select-previous-or-next-dates-based-on-the-selected-date-in-the-flutter-date-range)
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to restrict swipe gesture for range selection](https://www.syncfusion.com/kb/12117/how-to-restrict-swipe-gesture-for-range-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  /// return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///          initialSelectedRanges: <HijriDateRange>[
  ///            HijriDateRange(
  ///                           HijriDateTime.now().subtract(Duration(days: 4)),
  ///                           HijriDateTime.now().add(Duration(days: 4))),
  ///            HijriDateRange(
  ///                              HijriDateTime.now().add(Duration(days: 7)),
  ///                              HijriDateTime.now().add(Duration(days: 14)))
  ///          ],
  ///        ),
  ///      ),
  ///    );
  /// }
  ///
  /// ```
  final List<HijriDateRange>? initialSelectedRanges;

  /// An object that used for programmatic date navigation, date and range
  /// selection and view switching in [SfHijriDateRangePicker].
  ///
  /// A [HijriDatePickerController] served for several purposes. It can be
  /// used to selected dates and ranges programmatically on
  /// [SfHijriDateRangePicker] by using the[controller.selectedDate],
  /// [controller.selectedDates], [controller.selectedRange],
  /// [controller.selectedRanges]. It can be used to change the
  /// [SfHijriDateRangePicker] view by using the [controller.view] property. It
  /// can be used to navigate to specific date by using the
  /// [controller.displayDate] property.
  ///
  /// ## Listening to property changes:
  /// The [HijriDatePickerController] is a listenable. It notifies it's
  /// listeners whenever any of attached [SfHijriDateRangePicker]`s selected
  /// date, display date and view changed (i.e: selecting a different date,
  /// swiping to next/previous view and navigates to different view] in in
  /// [SfHijriDateRangePicker].
  ///
  /// ## Navigates to different view:
  /// The [SfHijriDateRangePicker] visible view can be changed by using the
  /// [Controller.view] property, the property allow to change the view of
  /// [SfHijriDateRangePicker] programmatically on initial load and in run time.
  ///
  /// ## Programmatic selection:
  /// In [SfHijriDateRangePicker] selecting dates programmatically can be
  /// achieved by using the [controller.selectedDate],
  /// [controller.selectedDates], [controller.selectedRange],
  /// [controller.selectedRanges] which allows to select the dates or ranges
  /// programmatically on [SfHijriDateRangePicker] on initial load and in run
  /// time.
  ///
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [HijriDatePickerController], to know more about the controller and it's
  /// usage with the hijri date range picker.
  /// * [initialDisplayDate], which used to navigate the hijri date range picker
  /// to the specific date initially.
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on hijri date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on hijri date range picker.
  /// * [HijriDatePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on hijri date range picker.
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [onViewChanged], the callback which notifies when the current view
  /// visible date changed on the hijri date range picker.
  /// * [onSelectionChanged], the callback which notifies when the selected cell
  /// changed on the the hijri date range picker.
  /// * [showActionButtons], which allows to cancel of confirm the selection in
  /// the hijri date range picker.
  /// * [onSubmit], the callback which notifies when the selected value
  /// confirmed through confirm button on hijri date range picker.
  /// * [onCancel], the callback which notifies when the selected value canceled
  /// and reverted to previous  confirmed value through cancel button on hijri
  /// date range picker.
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
  /// This example demonstrates how to use the [HijriDatePickerController]
  /// for [SfHijriDateRangePicker].
  ///
  /// ``` dart
  ///
  ///class MyApp extends StatefulWidget {
  ///  @override
  ///  MyAppState createState() => MyAppState();
  ///}
  ///
  ///class MyAppState extends State<MyApp> {
  ///  HijriDatePickerController _pickerController =
  ///  HijriDatePickerController();
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
  ///                                         _pickerController.selectedDates!;
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
  final HijriDatePickerController? controller;

  /// Displays the navigation arrows on the header view of
  /// [SfHijriDateRangePicker].
  ///
  /// If this property set as [true] the header view of [SfHijriDateRangePicker]
  /// will display the navigation arrows which used to navigate to the
  /// previous/next views through the navigation icon buttons.
  ///
  /// defaults to `false`.
  ///
  /// _Note:_ If the [DateRangePickerSelectionMode] set as range or multi range
  /// then the navigation arrows will be shown in the header by default, even if
  /// the [showNavigationArrow] property set as [false].
  ///
  /// If the [HijriDatePickerMonthViewSettings.enableSwipeSelection] set as
  /// [false] the navigation arrows will be shown, only whn the
  /// [showNavigationArrow] property set as [true].
  ///
  /// See also:
  /// * [HijriDatePickerController.forward], which allows to navigate to next
  /// view of the date range picker programmatically.
  /// * [HijriDatePickerController.backward], which allows to navigate to
  /// previous view of the date range picker programmatically.
  ///  * Knowledge base: [How to navigate to the previous or next dates using navigation arrows](https://www.syncfusion.com/kb/12270/how-to-navigate-to-the-previous-or-next-views-using-navigation-arrows-in-the-flutter-date)
  ///
  ///
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///        ),
  ///     ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  final bool showNavigationArrow;

  /// The direction that [SfHijriDateRangePicker] is navigating in.
  ///
  /// If it this property set as [DateRangePickerNavigationDirection.vertical]
  /// the [SfHijriDateRangePicker] will navigate to the previous/next views in
  /// the vertical direction instead of the horizontal direction.
  ///
  /// Defaults to `DateRangePickerNavigationDirection.horizontal`.
  ///
  /// See also:
  /// * [navigationMode], which allows to customize the navigation mode with
  /// available options.
  /// * [minDate], which is the least available date in the hijri date range
  /// picker.
  /// * [maxDate], which is the last available date in the hijri date range
  /// picker.
  /// * [enableMultiView], which allows to display multiple date side by
  /// side based on the navigation direction.
  /// * Knowledge base: [How to show two pickers vertically](https://www.syncfusion.com/kb/12193/how-to-show-two-pickers-vertically-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the navigation direction](https://www.syncfusion.com/kb/12176/how-to-change-the-navigation-direction-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///          navigationDirection: DateRangePickerNavigationDirection.vertical,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerNavigationDirection navigationDirection;

  /// Defines the shape for the selection view in [SfHijriDateRangePicker].
  ///
  /// If this property set as [DateRangePickerSelectionShape.rectangle] the
  /// widget will render the date selection in the rectangle shape in month
  /// view.
  ///
  /// Defaults to `DateRangePickerSelectionShape.circle`.
  ///
  /// _Note:_ When the [view] set with any other view than
  /// [DateRangePickerView.month] the today cell highlight shape will be
  /// determined by this property.
  ///
  /// If the [DateRangePickerSelectionShape] is set as
  /// [DateRangePickerSelectionShape.circle], then the circle radius can be
  /// adjusted in month view by using the [selectionRadius] property.
  ///
  /// See also:
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [allowViewNavigation], which allows to navigate between views quickly,
  /// and setting this property as `false`, allows to select the cells on
  /// year and decade view of hijri date range picker.
  /// * [selectionColor], which fills the background of the selected cells in
  /// the hijri date range picker.
  /// * [startRangeSelectionColor], which fills the background of the first cell
  /// of the range selection in hijri date range picker.
  /// * [endRangeSelectionColor], which fills the background of the last cell of
  /// the range selection in hijri date range picker.
  /// * [rangeSelectionColor], which fills the background of the in between
  /// cells of hijri date range picker in range selection.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// hijri date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [selectionTextStyle], which is used to set the text style for the text
  /// in the selected cell of hijri date range picker.
  /// * [rangeTextStyle], which is used to set text style for the text in the
  /// selected range cell's of hijri date range picker.
  /// * Knowledge base: [How to change the selection radius](https://www.syncfusion.com/kb/12230/how-to-change-the-selection-radius-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected range cells](https://www.syncfusion.com/kb/12148/how-to-customize-the-selected-range-cells-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to change the selection shape](https://www.syncfusion.com/kb/11900/how-to-change-the-selection-shape-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to customize the selected month cell](https://www.syncfusion.com/kb/11441/how-to-customize-the-selected-month-cell-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///          selectionShape: DateRangePickerSelectionShape.rectangle,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerSelectionShape selectionShape;

  /// Allows to change the month text format in [SfHijriDateRangePicker].
  ///
  /// The [SfHijriDateRangePicker] will render the month format in the month
  /// view header with expanded month text format and the year view cells with
  /// the short month text format by default.
  ///
  /// If it is not [null] then the month view header and the year view cells
  /// month text will be formatted based on the format given in this property.
  ///
  /// Defaults to null.
  ///
  /// See also:
  /// * [headerStyle], which used to customize the header view of the hijri date
  /// range picker.
  /// * [headerHeight], which is the size of the header view in the hijri date
  /// range picker.
  /// * [yearCellStyle], which is used to customize the year and decade view
  /// cells in the hijri date range picker.
  /// * Knowledge base: [How to customize the header view](https://www.syncfusion.com/kb/11427/how-to-customize-the-header-view-of-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the header in the flutter multi date range picker](https://www.syncfusion.com/kb/11897/how-to-customize-the-header-in-the-flutter-multi-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the month format](https://www.syncfusion.com/kb/12169/how-to-change-the-month-format-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to style the year decade and century views](https://www.syncfusion.com/kb/12321/how-to-style-the-year-decade-century-views-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///          monthFormat: 'EEE',
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final String? monthFormat;

  /// Defines the view navigation mode based on its [navigationDirection]
  /// for [SfHijriDateRangePicker].
  ///
  /// Defaults to [DateRangePickerNavigationMode.snap]
  ///
  /// See also:
  /// * [navigationDirection], which allows to customize the navigation
  /// direction of the hijri date range picker with available options.
  /// * [minDate], which is the least available date in the hijri date range
  /// picker.
  /// * [maxDate], which is the last available date in the hijri date range
  /// picker.
  /// * [enableMultiView], which allows to display multiple picker side by
  /// side based on the navigation direction.
  /// * Knowledge base: [How to show two pickers vertically](https://www.syncfusion.com/kb/12193/how-to-show-two-pickers-vertically-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to change the navigation direction](https://www.syncfusion.com/kb/12176/how-to-change-the-navigation-direction-in-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to restrict the view navigation](https://www.syncfusion.com/kb/12500/how-to-restrict-the-view-navigation-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///      child: SfHijriDateRangePicker(
  ///        navigationMode: DateRangePickerNavigationMode.scroll,
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final DateRangePickerNavigationMode navigationMode;

  /// Called when the current visible view or visible date range changes.
  ///
  /// The visible date range and the visible view which visible on view when the
  /// view changes available in the [HijriDatePickerViewChangedArgs].
  ///
  /// See also:
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on hijri date range picker.
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * [HijriDatePickerViewChangedArgs], which contains the visible date range
  /// details of the current visible view.
  /// * [initialDisplayDate], which is used to navigate the hijri date range
  /// picker to specific date on initially.
  /// * [HijriDatePickerController.displayDate], which allows to move the
  /// hijri date range picker to specific date.
  /// * [HijriDatePickerController.forward], which allows to navigate to next
  /// view of the hijri date range picker programmatically.
  /// * [HijriDatePickerController.backward], which allows to navigate to
  ///  previous view of the hijri date range picker programmatically.
  /// * Knowledge base: [How to update blackout dates using onViewChanged callback](https://www.syncfusion.com/kb/12372/how-to-update-blackout-dates-using-onviewchanged-callback-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to customize the header in flutter multi date range picker](https://www.syncfusion.com/kb/11897/how-to-customize-the-header-in-the-flutter-multi-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfHijriDateRangePicker(
  ///          view: HijriDatePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///          onViewChanged: (HijriDatePickerViewChangedArgs args) {
  ///           final HijriDateRange _visibleDateRange =
  ///                                                     args.visibleDateRange;
  ///           final HijriDatePickerView _visibleView = args.view;
  ///          },
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final HijriDatePickerViewChangedCallback? onViewChanged;

  /// Called when the new dates or date ranges selected.
  ///
  /// The dates or ranges that selected when the selection changes available in
  /// the [DateRangePickerSelectionChangedArgs].
  ///
  /// See also:
  /// * [onViewChanged], callback which notifies when the current view visible
  /// dates changed on hijri date range picker.
  /// * [HijriDatePickerMonthViewSettings.enableSwipeSelection], which allows to
  /// select the cells on swipe when the selection mode set as
  /// [DateRangePickerSelectionMode.range],
  /// [DateRangePickerSelectionMode.multiRange], and
  /// [DateRangePickerSelectionMode.extendableRange].
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [allowViewNavigation], which allows to navigate between views quickly,
  /// and setting this property as `false`, allows to select the cells on
  /// year and decade view of hijri date range picker.
  /// * [toggleDaySelection], which allows to deselect a date when the selection
  /// mode set as [DateRangePickerSelectionMode.single].
  /// * [showActionButtons], which displays action buttons on bottom of date
  /// range picker, which allows to confirm and cancel the selection.
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * [initialSelectedDate], which allows to select date programmatically
  /// initially on hijri date range picker.
  /// * [initialSelectedDates], which allows to list of select date
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRange], which allows to select a range of dates
  /// programmatically initially on hijri date range picker.
  /// * [initialSelectedRanges], which allows to select a ranges of dates
  /// programmatically initially on hijri date range picker.
  /// * [HijriDatePickerController.selectedDate],which allows to select date
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedDates], which allows to select dates
  /// programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRange], which allows to select range
  /// of dates programmatically dynamically on hijri date range picker.
  /// * [HijriDatePickerController.selectedRanges], which allows to select
  /// ranges of dates programmatically dynamically on hijri date range picker.
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to select previous or next dates bases on selected date](https://www.syncfusion.com/kb/12354/how-to-select-previous-or-next-dates-based-on-the-selected-date-in-the-flutter-date-range)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  ///
  ///  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  ///    if (args.value is HijriDateRange) {
  ///      final HijriDateTime rangeStartDate = args.value.startDate;
  ///      final HijriDateTime rangeEndDate = args.value.endDate;
  ///    } else if (args.value is HijriDateTime) {
  ///      final HijriDateTime selectedDate = args.value;
  ///    } else if (args.value is List<HijriDateTime>) {
  ///      final List<HijriDateTime> selectedDates = args.value;
  ///    } else {
  ///      final List<HijriDateRange> selectedRanges = args.value;
  ///    }
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///        home: Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('DatePicker demo'),
  ///      ),
  ///      body: SfHijriDateRangePicker(
  ///        onSelectionChanged: _onSelectionChanged,
  ///        selectionMode: DateRangePickerSelectionMode.range,
  ///        initialSelectedRange: HijriDateRange(
  ///            HijriDateTime.now().subtract(Duration(days: 4)),
  ///            HijriDateTime.now().add(Duration(days: 3))),
  ///      ),
  ///    ));
  ///  }
  ///}
  ///
  /// ```
  final DateRangePickerSelectionChangedCallback? onSelectionChanged;

  /// Text that displays on the confirm button.
  ///
  /// See also:
  /// * [showActionButtons], which allows to display action buttons at the
  /// bottom of the hijri date range picker to handle the selection.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on hijri date range picker.
  /// * [cancelText], which is text that display on the cancel button.
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  ///
  /// ``` dart
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Date Range Picker'),
  ///         ),
  ///         body: Container(
  ///             child: SfHijriDateRangePicker(
  ///           confirmText: 'Confirm',
  ///           showActionButtons: true,
  ///         )));
  ///   }
  ///
  /// ```
  final String confirmText;

  /// Text that displays on the cancel button.
  ///
  /// See also:
  /// * [showActionButtons], which allows to display action buttons at the
  /// bottom of the hijri date range picker to handle the selection.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on hijri date range picker.
  /// * [confirmText], which is text that display on the confirm button.
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Date Range Picker'),
  ///         ),
  ///         body: Container(
  ///             child: SfHijriDateRangePicker(
  ///           cancelText: 'Dismiss',
  ///           showActionButtons: true,
  ///         )));
  ///   }
  ///
  /// ```
  final String cancelText;

  /// Displays confirm and cancel buttons on the date range picker to perform
  /// the confirm and cancel actions.
  ///
  /// The [onSubmit] and [onCancel] callback is called based on the
  /// actions of the buttons.
  ///
  /// See also:
  /// * [HijriDatePickerMonthViewSettings.enableSwipeSelection], which allows to
  /// select the cells on swipe when the selection mode set as
  /// [DateRangePickerSelectionMode.range],
  /// [DateRangePickerSelectionMode.multiRange], and
  /// [DateRangePickerSelectionMode.extendableRange].
  /// * [selectionMode], which allows to customize the selection mode with
  /// available mode options.
  /// * [allowViewNavigation], which allows to navigate between views quickly,
  /// and setting this property as `false`, allows to select the cells on
  /// year and decade view of hijri date range picker.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on hijri date range picker.
  /// * [selectionRadius], which is the radius for the selection view in the
  /// hijri date range picker when the selection shape set as
  /// [DateRangePickerSelectionShape.circle].
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * Knowledge base: [How to get the selected date](https://www.syncfusion.com/kb/11410/how-to-get-the-selected-date-from-the-flutter-date-range-picker-sfdaterangepicker)
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to get the start and end date of the selected range](https://www.syncfusion.com/kb/12248/how-to-get-the-start-and-end-date-of-the-selected-range-in-the-flutter-date-range-picker)
  /// * Knowledge base: [How to programmatically select the date](https://www.syncfusion.com/kb/12114/how-to-programmatically-select-the-date-in-the-flutter-date-range-picker-sfdaterangepicker)
  ///
  /// ``` dart
  ///
  /// @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Date Range Picker'),
  ///         ),
  ///         body: Container(
  ///             child: SfHijriDateRangePicker(
  ///           cancelText: 'Dismiss',
  ///           confirmText: 'Confirm',
  ///           showActionButtons: true,
  ///         )));
  ///   }
  ///
  /// ```
  final bool showActionButtons;

  /// Called whenever the cancel button tapped on date range picker.
  /// It reset the selected values to confirmed selected values.
  ///
  /// See also:
  /// * [showActionButtons], which allows to display action buttons at the
  /// bottom of the hijri date range picker to handle the selection.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on hijri date range picker.
  /// * [cancelText], which is text that display on the cancel button.
  /// * [confirmText], which is text that display on the confirm button
  /// * [onSubmit], callback which notifies when the selection confirmed
  /// through the ok button of [showActionButtons].
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  ///Widget build(BuildContext context) {
  ///     return Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Date Range Picker'),
  ///         ),
  ///         body: Container(
  ///             child: SfHijriDateRangePicker(
  ///           showActionButtons: true,
  ///           onCancel: () {
  ///             Navigator.pop(context);
  ///           },
  ///         )));
  ///   }
  ///
  /// ```
  final VoidCallback? onCancel;

  /// Called whenever the confirm button tapped on date range picker.
  /// The dates or ranges that have been selected are confirmed and the
  /// selected value is available in the value argument.
  ///
  /// See also:
  /// * [showActionButtons], which allows to display action buttons at the
  /// bottom of the hijri date range picker to handle the selection.
  /// * [onSelectionChanged], callback which notifies whenever the selection
  /// changed on hijri date range picker.
  /// * [cancelText], which is text that display on the cancel button.
  /// * [confirmText], which is text that display on the confirm button
  /// * [onCancel], callback which notifies when the selection canceled through
  /// the cancel button of [showActionButtons].
  /// * Knowledge base: [How to confirm or cancel the selection](https://www.syncfusion.com/kb/12546/how-to-confirm-or-cancel-the-selection-in-the-flutter-date-range-picker)
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///     return Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Date Range Picker'),
  ///         ),
  ///         body: Container(
  ///             child: SfHijriDateRangePicker(
  ///           showActionButtons: true,
  ///           onSubmit: (Object value) {
  ///             if (value is HijriDateRange) {
  ///               final HijriDateTime rangeStartDate = value.startDate!;
  ///               final HijriDateTime rangeEndDate = value.endDate!;
  ///             } else if (value is HijriDateTime) {
  ///               final HijriDateTime selectedDate = value;
  ///             } else if (value is List<HijriDateTime>) {
  ///               final List<HijriDateTime> selectedDates = value;
  ///             } else if (value is List<HijriDateRange>) {​
  ///               final List<HijriDateRange> selectedRanges = value;
  ///             }
  ///           },
  ///         )));
  ///   }
  ///
  /// ```
  final Function(Object?)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return _SfDateRangePicker(
      key: key,
      view: DateRangePickerHelper.getPickerView(view),
      selectionMode: selectionMode,
      headerHeight: headerHeight,
      todayHighlightColor: todayHighlightColor,
      backgroundColor: backgroundColor,
      initialSelectedDate: initialSelectedDate,
      initialSelectedDates: initialSelectedDates,
      initialSelectedRange: initialSelectedRange,
      initialSelectedRanges: initialSelectedRanges,
      toggleDaySelection: toggleDaySelection,
      enablePastDates: enablePastDates,
      showNavigationArrow: showNavigationArrow,
      selectionShape: selectionShape,
      navigationDirection: navigationDirection,
      controller: controller,
      onViewChanged: onViewChanged,
      onSelectionChanged: onSelectionChanged,
      onCancel: onCancel,
      onSubmit: onSubmit,
      headerStyle: headerStyle,
      yearCellStyle: yearCellStyle,
      monthViewSettings: monthViewSettings,
      initialDisplayDate: initialDisplayDate,
      minDate: minDate,
      maxDate: maxDate,
      monthCellStyle: monthCellStyle,
      allowViewNavigation: allowViewNavigation,
      enableMultiView: enableMultiView,
      viewSpacing: viewSpacing,
      selectionRadius: selectionRadius,
      selectionColor: selectionColor,
      startRangeSelectionColor: startRangeSelectionColor,
      endRangeSelectionColor: endRangeSelectionColor,
      rangeSelectionColor: rangeSelectionColor,
      selectionTextStyle: selectionTextStyle,
      rangeTextStyle: rangeTextStyle,
      monthFormat: monthFormat,
      cellBuilder: cellBuilder,
      navigationMode: navigationMode,
      confirmText: confirmText,
      cancelText: cancelText,
      showActionButtons: showActionButtons,
      isHijri: true,
      showTodayButton: showTodayButton,
      selectableDayPredicate: selectableDayPredicate,
      extendableRangeSelectionDirection: extendableRangeSelectionDirection,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<HijriDatePickerView>('view', view));
    properties.add(EnumProperty<DateRangePickerSelectionMode>(
        'selectionMode', selectionMode));
    properties.add(EnumProperty<DateRangePickerSelectionShape>(
        'selectionShape', selectionShape));
    properties.add(EnumProperty<DateRangePickerNavigationDirection>(
        'navigationDirection', navigationDirection));
    properties.add(EnumProperty<DateRangePickerNavigationMode>(
        'navigationMode', navigationMode));
    properties.add(DoubleProperty('headerHeight', headerHeight));
    properties.add(DoubleProperty('viewSpacing', viewSpacing));
    properties.add(DoubleProperty('selectionRadius', selectionRadius));
    properties.add(ColorProperty('todayHighlightColor', todayHighlightColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('selectionColor', selectionColor));
    properties.add(
        ColorProperty('startRangeSelectionColor', startRangeSelectionColor));
    properties
        .add(ColorProperty('endRangeSelectionColor', endRangeSelectionColor));
    properties.add(ColorProperty('rangeSelectionColor', rangeSelectionColor));
    properties.add(StringProperty('monthFormat', monthFormat));
    properties.add(DiagnosticsProperty<TextStyle>(
        'selectionTextStyle', selectionTextStyle));
    properties
        .add(DiagnosticsProperty<TextStyle>('rangeTextStyle', rangeTextStyle));
    properties.add(DiagnosticsProperty<HijriDateTime>(
        'initialDisplayDate', initialDisplayDate));
    properties.add(DiagnosticsProperty<HijriDateTime>(
        'initialSelectedDate', initialSelectedDate));
    properties.add(IterableDiagnostics<HijriDateTime>(initialSelectedDates)
        .toDiagnosticsNode(name: 'initialSelectedDates'));
    properties.add(DiagnosticsProperty<HijriDateRange>(
        'HijriDateRange', initialSelectedRange));
    properties.add(IterableDiagnostics<HijriDateRange>(initialSelectedRanges)
        .toDiagnosticsNode(name: 'initialSelectedRanges'));
    properties.add(DiagnosticsProperty<HijriDateTime>('minDate', minDate));
    properties.add(DiagnosticsProperty<HijriDateTime>('maxDate', maxDate));
    properties.add(DiagnosticsProperty<HijriDateRangePickerCellBuilder>(
        'cellBuilder', cellBuilder));
    properties.add(
        DiagnosticsProperty<bool>('allowViewNavigation', allowViewNavigation));
    properties.add(
        DiagnosticsProperty<bool>('toggleDaySelection', toggleDaySelection));
    properties
        .add(DiagnosticsProperty<bool>('enablePastDates', enablePastDates));
    properties.add(
        DiagnosticsProperty<bool>('showNavigationArrow', showNavigationArrow));
    properties
        .add(DiagnosticsProperty<bool>('showActionButtons', showActionButtons));
    properties.add(StringProperty('cancelText', cancelText));
    properties.add(StringProperty('confirmText', confirmText));
    properties
        .add(DiagnosticsProperty<bool>('enableMultiView', enableMultiView));
    properties.add(DiagnosticsProperty<HijriDatePickerViewChangedCallback>(
        'onViewChanged', onViewChanged));
    properties.add(DiagnosticsProperty<DateRangePickerSelectionChangedCallback>(
        'onSelectionChanged', onSelectionChanged));
    properties.add(DiagnosticsProperty<VoidCallback>('onCancel', onCancel));
    properties.add(DiagnosticsProperty<Function(Object)>('onSubmit', onSubmit));
    properties.add(DiagnosticsProperty<HijriDatePickerController>(
        'controller', controller));

    properties.add(headerStyle.toDiagnosticsNode(name: 'headerStyle'));

    properties.add(yearCellStyle.toDiagnosticsNode(name: 'yearCellStyle'));

    properties
        .add(monthViewSettings.toDiagnosticsNode(name: 'monthViewSettings'));

    properties.add(monthCellStyle.toDiagnosticsNode(name: 'monthCellStyle'));

    properties
        .add(DiagnosticsProperty<bool>('showTodayButton', showTodayButton));
    properties.add(DiagnosticsProperty<HijriDatePickerSelectableDayPredicate>(
        'selectableDayPredicate', selectableDayPredicate));
    properties.add(EnumProperty<ExtendableRangeSelectionDirection>(
        'extendableRangeSelectionDirection',
        extendableRangeSelectionDirection));
  }
}

@immutable
class _SfDateRangePicker extends StatefulWidget {
  const _SfDateRangePicker(
      {Key? key,
      required this.view,
      required this.selectionMode,
      this.isHijri = false,
      required this.headerHeight,
      this.todayHighlightColor,
      this.backgroundColor,
      this.initialSelectedDate,
      this.initialSelectedDates,
      this.initialSelectedRange,
      this.initialSelectedRanges,
      this.toggleDaySelection = false,
      this.enablePastDates = true,
      this.showNavigationArrow = false,
      required this.selectionShape,
      required this.navigationDirection,
      this.controller,
      this.onViewChanged,
      this.onSelectionChanged,
      this.onCancel,
      this.onSubmit,
      required this.headerStyle,
      required this.yearCellStyle,
      required this.monthViewSettings,
      required this.initialDisplayDate,
      this.confirmText = 'OK',
      this.cancelText = 'CANCEL',
      this.showActionButtons = false,
      required this.minDate,
      required this.maxDate,
      required this.monthCellStyle,
      this.allowViewNavigation = true,
      this.enableMultiView = false,
      required this.navigationMode,
      required this.viewSpacing,
      required this.selectionRadius,
      this.selectionColor,
      this.startRangeSelectionColor,
      this.endRangeSelectionColor,
      this.rangeSelectionColor,
      this.selectionTextStyle,
      this.rangeTextStyle,
      this.monthFormat,
      this.cellBuilder,
      this.showTodayButton = false,
      this.selectableDayPredicate,
      this.extendableRangeSelectionDirection =
          ExtendableRangeSelectionDirection.both})
      : super(key: key);

  final DateRangePickerView view;

  final DateRangePickerSelectionMode selectionMode;

  final bool isHijri;

  final DateRangePickerHeaderStyle headerStyle;

  final double headerHeight;

  final String confirmText;

  final String cancelText;

  final bool showActionButtons;

  final Color? todayHighlightColor;

  final Color? backgroundColor;

  final bool toggleDaySelection;

  final bool allowViewNavigation;

  final bool enableMultiView;

  final double viewSpacing;

  final double selectionRadius;

  final TextStyle? selectionTextStyle;

  final TextStyle? rangeTextStyle;

  final Color? selectionColor;

  final Color? startRangeSelectionColor;

  final Color? rangeSelectionColor;

  final Color? endRangeSelectionColor;

  final dynamic monthViewSettings;

  final dynamic cellBuilder;

  final dynamic yearCellStyle;

  final dynamic monthCellStyle;

  final dynamic initialDisplayDate;

  final dynamic initialSelectedDate;

  final dynamic minDate;

  final dynamic maxDate;

  final bool enablePastDates;

  final List<dynamic>? initialSelectedDates;

  final dynamic initialSelectedRange;

  final List<dynamic>? initialSelectedRanges;

  final dynamic controller;

  final bool showNavigationArrow;

  final DateRangePickerNavigationDirection navigationDirection;

  final DateRangePickerSelectionShape selectionShape;

  final String? monthFormat;

  final dynamic onViewChanged;

  final DateRangePickerSelectionChangedCallback? onSelectionChanged;

  final DateRangePickerNavigationMode navigationMode;

  final VoidCallback? onCancel;

  final Function(Object?)? onSubmit;

  final bool showTodayButton;

  final dynamic selectableDayPredicate;

  final ExtendableRangeSelectionDirection extendableRangeSelectionDirection;

  @override
  _SfDateRangePickerState createState() => _SfDateRangePickerState();
}

class _SfDateRangePickerState extends State<_SfDateRangePicker>
    with SingleTickerProviderStateMixin {
  late List<dynamic> _currentViewVisibleDates;
  dynamic _currentDate, _selectedDate;
  double? _minWidth, _minHeight;
  late double _textScaleFactor;
  late ValueNotifier<List<dynamic>> _headerVisibleDates;
  late ValueNotifier<List<dynamic>> _viewHeaderVisibleDates;
  List<dynamic>? _selectedDates;
  dynamic _selectedRange;
  List<dynamic>? _selectedRanges;
  final GlobalKey<_PickerScrollViewState> _scrollViewKey =
      GlobalKey<_PickerScrollViewState>();
  late DateRangePickerView _view;
  late bool _isRtl;
  late dynamic _controller;
  late Locale _locale;
  late SfLocalizations _localizations;
  late SfDateRangePickerThemeData _datePickerTheme;

  /// Holds the date collection after the display date.
  // ignore: always_specify_types, strict_raw_type
  final List<List> _forwardDateCollection = <List>[];

  /// Holds the date collection before the display date.
  // ignore: always_specify_types, strict_raw_type
  final List<List> _backwardDateCollection = <List>[];

  /// Holds the current scroll view key and it used to re initialize the
  /// scroll view by create the new instance.
  Key _scrollKey = UniqueKey();

  /// Holds the key value used to specify the forward list that splits the
  /// scroll view into forward list and backward list.
  Key _pickerKey = UniqueKey();

  /// Controller used to get the current scrolled position to handle the view
  /// change callback.
  ScrollController? _pickerScrollController;

  /// Used to store the minimum control width and it's value only assigned for
  /// [didChangeDependencies].
  late double _minPickerWidth;

  /// Used to store the minimum control height and it's value only assigned for
  /// [didChangeDependencies].
  late double _minPickerHeight;

  /// Store the initial selected values and its value updated by whenever the
  /// confirm button pressed.
  late PickerStateArgs _previousSelectedValue;

  late bool _isMobilePlatform;

  /// Fade animation controller to controls fade animation
  AnimationController? _fadeInController;

  /// Fade animation animated on view switching navigation.
  Animation<double>? _fadeIn;

  /// Opacity of widget handles by fade animation.
  final ValueNotifier<double> _opacity = ValueNotifier<double>(1);

  @override
  void initState() {
    _textScaleFactor = 1;
    _isRtl = false;
    //// Update initial values to controller.
    _initPickerController();
    _initNavigation();
    //// Update initial value to state variables.
    _updateSelectionValues();
    _view = DateRangePickerHelper.getPickerView(_controller.view);
    _updateCurrentVisibleDates();
    _headerVisibleDates =
        ValueNotifier<List<dynamic>>(_currentViewVisibleDates);
    _viewHeaderVisibleDates =
        ValueNotifier<List<dynamic>>(_currentViewVisibleDates);
    _controller.addPropertyChangedListener(_pickerValueChangedListener);

    _previousSelectedValue = PickerStateArgs()
      ..selectedDate = _controller.selectedDate
      ..selectedDates =
          DateRangePickerHelper.cloneList(_controller.selectedDates)
      ..selectedRange = _controller.selectedRange
      ..selectedRanges =
          DateRangePickerHelper.cloneList(_controller.selectedRanges);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
    final TextDirection direction = Directionality.of(context);
    // default width value will be device width when the widget placed inside a
    // infinity width widget
    _minPickerWidth = MediaQuery.of(context).size.width;
    // default height for the widget when the widget placed inside a infinity
    // height widget
    _minPickerHeight = 300;
    _locale = Localizations.localeOf(context);
    _localizations = SfLocalizations.of(context);
    _isRtl = direction == TextDirection.rtl;
    _isMobilePlatform =
        DateRangePickerHelper.isMobileLayout(Theme.of(context).platform);
    _fadeInController ??= AnimationController(
        duration: Duration(milliseconds: _isMobilePlatform ? 500 : 600),
        vsync: this)
      ..addListener(_updateFadeAnimation);
    _fadeIn ??= Tween<double>(
      begin: 0.1,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fadeInController!,
      curve: Curves.easeIn,
    ));
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_SfDateRangePicker oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller
          ?.removePropertyChangedListener(_pickerValueChangedListener);
      _controller.removePropertyChangedListener(_pickerValueChangedListener);
      if (widget.controller != null) {
        _controller = widget.controller;
        _controller.selectedDates = _getSelectedDates(
            DateRangePickerHelper.cloneList(widget.controller!.selectedDates));
        _controller.selectedRanges = _getSelectedRanges(
            DateRangePickerHelper.cloneList(widget.controller!.selectedRanges));
        _controller.displayDate ??= _currentDate;
        _currentDate = getValidDate(
            widget.minDate, widget.maxDate, _controller.displayDate);
      } else {
        _initPickerController();
      }

      _controller.view ??= widget.isHijri
          ? DateRangePickerHelper.getHijriPickerView(_view)
          : DateRangePickerHelper.getPickerView(_view);
      _controller.addPropertyChangedListener(_pickerValueChangedListener);
      _initNavigation();
      _updateSelectionValues();
      _view = DateRangePickerHelper.getPickerView(_controller.view);
    }

    final DateRangePickerView view =
        DateRangePickerHelper.getPickerView(_controller.view);
    if (view == DateRangePickerView.month &&
        oldWidget.monthViewSettings.firstDayOfWeek !=
            widget.monthViewSettings.firstDayOfWeek) {
      if (widget.navigationMode == DateRangePickerNavigationMode.scroll) {
        _forwardDateCollection.clear();
        _backwardDateCollection.clear();
      } else {
        _updateCurrentVisibleDates();
        if (widget.navigationDirection ==
            DateRangePickerNavigationDirection.vertical) {
          _viewHeaderVisibleDates.value = _currentViewVisibleDates;
        }
      }
    }

    if (widget.navigationMode != oldWidget.navigationMode) {
      _initializeScrollView();
    }

    if (!widget.isHijri &&
        view == DateRangePickerView.month &&
        widget.navigationMode == DateRangePickerNavigationMode.scroll &&
        oldWidget.monthViewSettings.numberOfWeeksInView !=
            widget.monthViewSettings.numberOfWeeksInView) {
      _initializeScrollView();
    }

    if (view == DateRangePickerView.month &&
        widget.navigationMode == DateRangePickerNavigationMode.scroll &&
        widget.navigationDirection ==
            DateRangePickerNavigationDirection.vertical &&
        oldWidget.monthViewSettings.viewHeaderHeight !=
            widget.monthViewSettings.viewHeaderHeight) {
      _initializeScrollView();
    }

    if (oldWidget.showActionButtons != widget.showActionButtons) {
      if (widget.navigationMode == DateRangePickerNavigationMode.scroll &&
          widget.navigationDirection ==
              DateRangePickerNavigationDirection.vertical) {
        _initializeScrollView();
      }

      /// Update the previous selected value when show action button enabled.
      /// because select the date without action button then the value is
      /// confirmed value so store the confirmed selected values when show
      /// action buttons enabled.
      if (widget.showActionButtons) {
        _previousSelectedValue = PickerStateArgs()
          ..selectedDate = _controller.selectedDate
          ..selectedDates =
              DateRangePickerHelper.cloneList(_controller.selectedDates)
          ..selectedRange = _controller.selectedRange
          ..selectedRanges =
              DateRangePickerHelper.cloneList(_controller.selectedRanges);
      }
    }

    if ((oldWidget.navigationDirection != widget.navigationDirection ||
            oldWidget.enableMultiView != widget.enableMultiView) &&
        widget.navigationMode == DateRangePickerNavigationMode.scroll) {
      _initializeScrollView();
    }

    if (oldWidget.selectionMode != widget.selectionMode) {
      _updateSelectionValues();
    }

    if (widget.isHijri != oldWidget.isHijri) {
      _currentDate = getValidDate(widget.minDate, widget.maxDate, _currentDate);
      _updateCurrentVisibleDates();
    }

    if (oldWidget.minDate != widget.minDate ||
        oldWidget.maxDate != widget.maxDate) {
      _currentDate = getValidDate(widget.minDate, widget.maxDate, _currentDate);
      if (widget.navigationMode == DateRangePickerNavigationMode.scroll &&
          !_isScrollViewDatesValid()) {
        _initializeScrollView();
      }
    }

    if (_view == DateRangePickerView.month &&
        oldWidget.navigationDirection != widget.navigationDirection) {
      _viewHeaderVisibleDates.value = _currentViewVisibleDates;
    }

    if (!widget.isHijri &&
        DateRangePickerHelper.getNumberOfWeeksInView(
                widget.monthViewSettings, widget.isHijri) !=
            DateRangePickerHelper.getNumberOfWeeksInView(
                oldWidget.monthViewSettings, oldWidget.isHijri)) {
      _currentDate = _updateCurrentDate(oldWidget);
      _controller.displayDate = _currentDate;
    }

    if (oldWidget.controller != widget.controller ||
        widget.controller == null) {
      super.didUpdateWidget(oldWidget);
      return;
    }

    if (oldWidget.controller?.selectedDate != widget.controller?.selectedDate) {
      _selectedDate = _controller.selectedDate;
    }

    if (oldWidget.controller?.selectedDates !=
        widget.controller?.selectedDates) {
      _selectedDates =
          DateRangePickerHelper.cloneList(_controller.selectedDates);
    }

    if (oldWidget.controller?.selectedRange !=
        widget.controller?.selectedRange) {
      _selectedRange = _controller.selectedRange;
    }

    if (oldWidget.controller?.selectedRanges !=
        widget.controller?.selectedRanges) {
      _selectedRanges =
          DateRangePickerHelper.cloneList(_controller.selectedRanges);
    }

    if (oldWidget.controller?.view != widget.controller?.view) {
      _view = DateRangePickerHelper.getPickerView(_controller.view);
      _currentDate = _updateCurrentDate(oldWidget);
      _controller.displayDate = _currentDate;
    }

    if (oldWidget.controller?.displayDate != widget.controller?.displayDate &&
        widget.controller?.displayDate != null) {
      _currentDate =
          getValidDate(widget.minDate, widget.maxDate, _controller.displayDate);
      _controller.displayDate = _currentDate;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _datePickerTheme = _getPickerThemeData(
        SfDateRangePickerTheme.of(context), Theme.of(context));
    double top = 0, height;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final double? previousWidth = _minWidth;
      final double? previousHeight = _minHeight;
      _minWidth = constraints.maxWidth == double.infinity
          ? _minPickerWidth
          : constraints.maxWidth;
      _minHeight = constraints.maxHeight == double.infinity
          ? _minPickerHeight
          : constraints.maxHeight;

      final double actionButtonsHeight =
          (widget.showActionButtons || widget.showTodayButton)
              ? _minHeight! * 0.1 < 50
                  ? 50
                  : _minHeight! * 0.1
              : 0;
      _handleScrollViewSizeChanged(_minHeight!, _minWidth!, previousHeight,
          previousWidth, actionButtonsHeight);

      height = _minHeight! - widget.headerHeight;
      top = widget.headerHeight;
      if (_view == DateRangePickerView.month &&
          widget.navigationDirection ==
              DateRangePickerNavigationDirection.vertical) {
        height -= widget.monthViewSettings.viewHeaderHeight;
        top += widget.monthViewSettings.viewHeaderHeight;
      }

      return Container(
        width: _minWidth,
        height: _minHeight,
        color: widget.backgroundColor ?? _datePickerTheme.backgroundColor,
        child: widget.navigationMode == DateRangePickerNavigationMode.scroll
            ? _addScrollView(_minWidth!, _minHeight!, actionButtonsHeight)
            : _addChildren(top, height, _minWidth!, actionButtonsHeight),
      );
    });
  }

  @override
  void dispose() {
    _controller.removePropertyChangedListener(_pickerValueChangedListener);

    if (_fadeInController != null) {
      _fadeInController!.removeListener(_updateFadeAnimation);
      _fadeInController!.dispose();
      _fadeInController = null;
    }

    if (_fadeIn != null) {
      _fadeIn = null;
    }
    super.dispose();
  }

  SfDateRangePickerThemeData _getPickerThemeData(
      SfDateRangePickerThemeData pickerTheme, ThemeData themeData) {
    final ColorScheme colorScheme = themeData.colorScheme;
    final SfDateRangePickerThemeData effectiveThemeData =
        SfDateRangePickerThemeKey(context);
    return pickerTheme.copyWith(
        brightness: themeData.brightness,
        backgroundColor:
            pickerTheme.backgroundColor ?? effectiveThemeData.backgroundColor,
        headerBackgroundColor: pickerTheme.headerBackgroundColor ??
            effectiveThemeData.headerBackgroundColor,
        viewHeaderBackgroundColor: pickerTheme.viewHeaderBackgroundColor ??
            effectiveThemeData.viewHeaderBackgroundColor,
        weekNumberBackgroundColor: pickerTheme.weekNumberBackgroundColor ??
            effectiveThemeData.weekNumberBackgroundColor,
        viewHeaderTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 14,
            )
            .merge(pickerTheme.viewHeaderTextStyle)
            .merge(widget.monthViewSettings.viewHeaderStyle.textStyle),
        headerTextStyle: themeData.textTheme.bodyLarge!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            )
            .merge(pickerTheme.headerTextStyle)
            .merge(widget.headerStyle.textStyle),
        trailingDatesTextStyle:
            (widget.monthCellStyle is DateRangePickerMonthCellStyle)
                ? themeData.textTheme.bodyMedium!
                    .copyWith(
                      color: colorScheme.onSurface.withOpacity(0.54),
                      fontSize: 13,
                    )
                    .merge(pickerTheme.trailingDatesTextStyle)
                    .merge(widget.monthCellStyle.trailingDatesTextStyle)
                : null,
        leadingCellTextStyle:
            (widget.yearCellStyle is DateRangePickerYearCellStyle)
                ? themeData.textTheme.bodyMedium!
                    .copyWith(
                      color: colorScheme.onSurface.withOpacity(0.54),
                      fontSize: 13,
                    )
                    .merge(pickerTheme.leadingCellTextStyle)
                    .merge(widget.yearCellStyle.leadingDatesTextStyle)
                : null,
        activeDatesTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 13,
            )
            .merge(pickerTheme.activeDatesTextStyle)
            .merge(widget.monthCellStyle.textStyle),
        cellTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 13,
            )
            .merge(pickerTheme.cellTextStyle)
            .merge(widget.yearCellStyle.textStyle),
        leadingDatesTextStyle:
            (widget.monthCellStyle is DateRangePickerMonthCellStyle)
                ? themeData.textTheme.bodyMedium!
                    .copyWith(
                      color: colorScheme.onSurface.withOpacity(0.54),
                      fontSize: 13,
                    )
                    .merge(pickerTheme.leadingDatesTextStyle)
                    .merge(widget.monthCellStyle.leadingDatesTextStyle)
                : null,
        rangeSelectionTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 13,
            )
            .merge(pickerTheme.rangeSelectionTextStyle)
            .merge(widget.rangeTextStyle),
        disabledDatesTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.38),
              fontSize: 13,
            )
            .merge(pickerTheme.disabledDatesTextStyle)
            .merge(widget.monthCellStyle.disabledDatesTextStyle),
        disabledCellTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.38),
              fontSize: 13,
            )
            .merge(pickerTheme.disabledCellTextStyle)
            .merge(widget.yearCellStyle.disabledDatesTextStyle),
        selectionTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onPrimary,
              fontSize: 13,
            )
            .merge(pickerTheme.selectionTextStyle)
            .merge(widget.selectionTextStyle),
        weekNumberTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 13,
            )
            .merge(pickerTheme.weekNumberTextStyle)
            .merge(widget.monthViewSettings.weekNumberStyle.textStyle),
        todayTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.primary,
              fontSize: 13,
            )
            .merge(pickerTheme.todayTextStyle)
            .merge(widget.monthCellStyle.todayTextStyle),
        todayCellTextStyle: themeData.textTheme.bodyMedium!
            .copyWith(
              color: colorScheme.primary,
              fontSize: 13,
            )
            .merge(pickerTheme.todayCellTextStyle)
            .merge(widget.yearCellStyle.todayTextStyle),

        /// Check the widget property and theme property styles are null.
        /// If null assign the picker theme style or
        /// If not null then assign the theme data text theme with
        /// merge the styles from widget property or theme properties are given.
        blackoutDatesTextStyle:
            (widget.monthCellStyle.blackoutDateTextStyle == null &&
                    pickerTheme.blackoutDatesTextStyle == null)
                ? pickerTheme.blackoutDatesTextStyle
                : themeData.textTheme.bodyMedium!
                    .copyWith(
                      color: colorScheme.onSurface.withOpacity(0.87),
                      fontSize: 13,
                    )
                    .merge(pickerTheme.blackoutDatesTextStyle)
                    .merge(widget.monthCellStyle.blackoutDateTextStyle),
        specialDatesTextStyle:
            (widget.monthCellStyle.specialDatesTextStyle == null &&
                    pickerTheme.specialDatesTextStyle == null)
                ? pickerTheme.specialDatesTextStyle
                : themeData.textTheme.bodyMedium!
                    .copyWith(
                      color: colorScheme.onSurface.withOpacity(0.87),
                      fontSize: 13,
                    )
                    .merge(pickerTheme.specialDatesTextStyle)
                    .merge(widget.monthCellStyle.specialDatesTextStyle),
        weekendDatesTextStyle:
            (widget.monthCellStyle.weekendTextStyle == null &&
                    pickerTheme.weekendDatesTextStyle == null)
                ? pickerTheme.weekendDatesTextStyle
                : themeData.textTheme.bodyMedium!
                    .copyWith(
                      color: colorScheme.onSurface.withOpacity(0.87),
                      fontSize: 13,
                    )
                    .merge(pickerTheme.weekendDatesTextStyle)
                    .merge(widget.monthCellStyle.weekendTextStyle),
        selectionColor:
            pickerTheme.selectionColor ?? effectiveThemeData.selectionColor,
        startRangeSelectionColor: pickerTheme.startRangeSelectionColor ??
            effectiveThemeData.startRangeSelectionColor,
        rangeSelectionColor: pickerTheme.rangeSelectionColor ??
            effectiveThemeData.rangeSelectionColor,
        endRangeSelectionColor: pickerTheme.endRangeSelectionColor ??
            effectiveThemeData.endRangeSelectionColor,
        todayHighlightColor: pickerTheme.todayHighlightColor ??
            effectiveThemeData.todayHighlightColor);
  }

  void _updateFadeAnimation() {
    if (!mounted) {
      return;
    }

    _opacity.value = _fadeIn!.value;
  }

  void _initNavigation() {
    _controller.forward = _moveToNextView;
    _controller.backward = _moveToPreviousView;
  }

  void _initPickerController() {
    _controller = widget.controller ??
        (widget.isHijri
            ? HijriDatePickerController()
            : DateRangePickerController());
    _controller.selectedDate = widget.initialSelectedDate;
    _controller.selectedDates = _getSelectedDates(
        DateRangePickerHelper.cloneList(widget.initialSelectedDates));
    _controller.selectedRange = widget.initialSelectedRange;
    _controller.selectedRanges =
        DateRangePickerHelper.cloneList(widget.initialSelectedRanges);
    _controller.view = widget.isHijri
        ? DateRangePickerHelper.getHijriPickerView(widget.view)
        : DateRangePickerHelper.getPickerView(widget.view);
    _currentDate =
        getValidDate(widget.minDate, widget.maxDate, widget.initialDisplayDate);
    _controller.displayDate = _currentDate;
  }

  void _updateSelectionValues() {
    _selectedDate = _controller.selectedDate;
    _selectedDates = DateRangePickerHelper.cloneList(_controller.selectedDates);
    _selectedRange = _controller.selectedRange;
    _selectedRanges =
        DateRangePickerHelper.cloneList(_controller.selectedRanges);
  }

  void _pickerValueChangedListener(String value) {
    if (value == 'selectedDate') {
      if (!mounted || isSameDate(_selectedDate, _controller.selectedDate)) {
        return;
      }

      _raiseSelectionChangedCallback(widget, value: _controller.selectedDate);
      setState(() {
        _selectedDate = _controller.selectedDate;
      });
    } else if (value == 'selectedDates') {
      if (!mounted ||
          DateRangePickerHelper.isDateCollectionEquals(
              _selectedDates, _controller.selectedDates)) {
        return;
      }

      _raiseSelectionChangedCallback(widget, value: _controller.selectedDates);
      setState(() {
        _selectedDates =
            DateRangePickerHelper.cloneList(_controller.selectedDates);
      });
    } else if (value == 'selectedRange') {
      if (!mounted ||
          DateRangePickerHelper.isRangeEquals(
              _selectedRange, _controller.selectedRange)) {
        return;
      }

      _raiseSelectionChangedCallback(widget, value: _controller.selectedRange);
      setState(() {
        _selectedRange = _controller.selectedRange;
      });
    } else if (value == 'selectedRanges') {
      if (!mounted ||
          DateRangePickerHelper.isDateRangesEquals(
              _selectedRanges, _controller.selectedRanges)) {
        return;
      }

      _raiseSelectionChangedCallback(widget, value: _controller.selectedRanges);
      setState(() {
        _selectedRanges =
            DateRangePickerHelper.cloneList(_controller.selectedRanges);
      });
    } else if (value == 'view') {
      if (!mounted ||
          _view == DateRangePickerHelper.getPickerView(_controller.view)) {
        return;
      }

      _fadeInController!.reset();
      _fadeInController!.forward();

      setState(() {
        _view = DateRangePickerHelper.getPickerView(_controller.view);
        if (widget.navigationMode == DateRangePickerNavigationMode.scroll) {
          _initializeScrollView();
        } else {
          _scrollViewKey.currentState!._position = 0.0;
          _scrollViewKey.currentState!._children.clear();
          _scrollViewKey.currentState!._updateVisibleDates();
          _scrollViewKey.currentState!._triggerSelectableDayPredicates(
              _scrollViewKey.currentState!._currentViewVisibleDates);
          _scrollViewKey.currentState!._triggerViewChangedCallback();
        }
      });
    } else if (value == 'displayDate') {
      if (!isSameOrAfterDate(widget.minDate, _controller.displayDate)) {
        _controller.displayDate = widget.minDate;
        return;
      }

      if (!isSameOrBeforeDate(widget.maxDate, _controller.displayDate)) {
        _controller.displayDate = widget.maxDate;
        return;
      }

      //// Restrict the update when current visible dates holds updated display date.
      if (isSameDate(_currentDate, _controller.displayDate) ||
          _checkDateWithInVisibleDates(_controller.displayDate)) {
        _currentDate = _controller.displayDate;
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _currentDate = _controller.displayDate;
        if (widget.navigationMode == DateRangePickerNavigationMode.scroll) {
          _initializeScrollView();
        } else {
          _updateCurrentVisibleDates();
        }
      });
    }
  }

  bool _checkDateWithInVisibleDates(dynamic date) {
    final DateRangePickerView view =
        DateRangePickerHelper.getPickerView(_controller.view);
    switch (view) {
      case DateRangePickerView.month:
        {
          if (!widget.isHijri &&
              DateRangePickerHelper.getNumberOfWeeksInView(
                      widget.monthViewSettings, widget.isHijri) !=
                  6) {
            return isDateWithInDateRange(
                _currentViewVisibleDates[0],
                _currentViewVisibleDates[_currentViewVisibleDates.length - 1],
                date);
          } else {
            final dynamic currentMonth = _currentViewVisibleDates[
                _currentViewVisibleDates.length ~/
                    (_isMultiViewEnabled(widget) ? 4 : 2)];
            return date.month == currentMonth.month &&
                date.year == currentMonth.year;
          }
        }
      case DateRangePickerView.year:
        {
          final int currentYear = _currentViewVisibleDates[0].year as int;
          final int year = date.year as int;

          return currentYear == year;
        }
      case DateRangePickerView.decade:
        {
          final int minYear = _currentViewVisibleDates[0].year as int;
          final int maxYear = (_currentViewVisibleDates[10].year as int) - 1;
          final int year = date.year as int;
          return minYear <= year && maxYear >= year;
        }
      case DateRangePickerView.century:
        {
          final int minYear = _currentViewVisibleDates[0].year as int;
          final int maxYear = (_currentViewVisibleDates[10].year as int) - 1;
          final int year = date.year as int;

          return minYear <= year && maxYear >= year;
        }
    }
  }

  void _updateCurrentVisibleDates() {
    switch (_view) {
      case DateRangePickerView.month:
        {
          _currentViewVisibleDates = getVisibleDates(
            _currentDate,
            null,
            widget.monthViewSettings.firstDayOfWeek,
            DateRangePickerHelper.getViewDatesCount(
                _view,
                DateRangePickerHelper.getNumberOfWeeksInView(
                    widget.monthViewSettings, widget.isHijri),
                widget.isHijri),
          );
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          _currentViewVisibleDates = DateRangePickerHelper.getVisibleYearDates(
              _currentDate, _view, widget.isHijri);
        }
    }
  }

  dynamic _updateCurrentDate(_SfDateRangePicker oldWidget) {
    if (oldWidget.controller == widget.controller &&
        widget.controller != null &&
        oldWidget.controller?.view == DateRangePickerView.month &&
        DateRangePickerHelper.getPickerView(_controller.view) !=
            DateRangePickerView.month) {
      return _currentViewVisibleDates[_currentViewVisibleDates.length ~/
          (_isMultiViewEnabled(widget) ? 4 : 2)];
    }

    return _currentViewVisibleDates[0];
  }

  /// Initialize the scroll view on scroll navigation mode.
  void _initializeScrollView() {
    _forwardDateCollection.clear();
    _backwardDateCollection.clear();
    _scrollKey = UniqueKey();
    _pickerKey = UniqueKey();
  }

  /// Check the scroll navigation mode scroll view have before min date or
  /// after max date views.
  bool _isScrollViewDatesValid() {
    if (_forwardDateCollection.isEmpty) {
      return true;
    }
    final DateRangePickerView view =
        DateRangePickerHelper.getPickerView(_controller.view);
    final int numberOfWeekInView = DateRangePickerHelper.getNumberOfWeeksInView(
        widget.monthViewSettings, widget.isHijri);
    // ignore: always_specify_types, strict_raw_type
    final List startDates = _backwardDateCollection.isNotEmpty
        ? _backwardDateCollection[_backwardDateCollection.length - 1]
        : _forwardDateCollection[0];
    // ignore: always_specify_types, strict_raw_type
    final List endDates =
        _forwardDateCollection[_forwardDateCollection.length - 1];
    switch (view) {
      case DateRangePickerView.month:
        {
          if (!widget.isHijri && numberOfWeekInView != 6) {
            final DateTime visibleStartDate =
                DateRangePickerHelper.getDateTimeValue(
                    startDates[startDates.length - 1]);
            final DateTime visibleEndDate =
                DateRangePickerHelper.getDateTimeValue(endDates[0]);
            return isDateWithInDateRange(
                    widget.minDate, widget.maxDate, visibleStartDate) &&
                isDateWithInDateRange(
                    widget.minDate, widget.maxDate, visibleEndDate);
          } else {
            final DateTime visibleStartDate =
                DateRangePickerHelper.getDateTimeValue(
                    startDates[startDates.length ~/ 2]);
            final DateTime visibleEndDate =
                DateRangePickerHelper.getDateTimeValue(
                    endDates[endDates.length ~/ 2]);
            return (visibleStartDate.year > widget.minDate.year ||
                    (visibleStartDate.year == widget.minDate.year &&
                        visibleStartDate.month >= widget.minDate.month)) &&
                (visibleStartDate.year < widget.maxDate.year ||
                    (visibleStartDate.year == widget.maxDate.year &&
                        visibleStartDate.month <= widget.maxDate.month)) &&
                (visibleEndDate.year > widget.minDate.year ||
                    (visibleEndDate.year == widget.minDate.year &&
                        visibleEndDate.month >= widget.minDate.month)) &&
                (visibleEndDate.year < widget.maxDate.year ||
                    (visibleEndDate.year == widget.maxDate.year &&
                        visibleEndDate.month <= widget.maxDate.month));
          }
        }
      case DateRangePickerView.year:
        {
          final int visibleStartYear = startDates[0].year as int;
          final int visibleEndYear = endDates[0].year as int;
          return widget.minDate.year <= visibleStartYear == true &&
              widget.maxDate.year >= visibleStartYear == true &&
              widget.minDate.year <= visibleEndYear == true &&
              widget.maxDate.year >= visibleEndYear == true;
        }
      case DateRangePickerView.decade:
        {
          final int visibleStartYear = ((startDates[0].year as int) ~/ 10) * 10;
          final int visibleEndYear = ((endDates[0].year as int) ~/ 10) * 10;
          final int minDateYear = ((widget.minDate.year as int) ~/ 10) * 10;
          final int maxDateYear = ((widget.maxDate.year as int) ~/ 10) * 10;
          return minDateYear <= visibleStartYear &&
              maxDateYear >= visibleStartYear &&
              minDateYear <= visibleEndYear &&
              maxDateYear >= visibleEndYear;
        }
      case DateRangePickerView.century:
        {
          final int visibleStartYear =
              ((startDates[0].year as int) ~/ 100) * 100;
          final int visibleEndYear = ((endDates[0].year as int) ~/ 100) * 100;
          final int minDateYear = ((widget.minDate.year as int) ~/ 100) * 100;
          final int maxDateYear = ((widget.maxDate.year as int) ~/ 100) * 100;
          return minDateYear <= visibleStartYear &&
              maxDateYear >= visibleStartYear &&
              minDateYear <= visibleEndYear &&
              maxDateYear >= visibleEndYear;
        }
    }
  }

  /// Handle the control size changed related view updates on scroll navigation
  /// mode.
  void _handleScrollViewSizeChanged(double newHeight, double newWidth,
      double? oldHeight, double? oldWidth, double actionButtonHeight) {
    if (widget.navigationMode != DateRangePickerNavigationMode.scroll ||
        _pickerScrollController == null ||
        !_pickerScrollController!.hasClients) {
      return;
    }

    if (oldWidth != null &&
        widget.navigationDirection ==
            DateRangePickerNavigationDirection.horizontal &&
        oldWidth != newWidth) {
      final double index = _pickerScrollController!.position.pixels / oldWidth;
      _pickerScrollController!.removeListener(_handleScrollChanged);
      _pickerScrollController!.dispose();
      _scrollKey = UniqueKey();
      _pickerKey = UniqueKey();
      _pickerScrollController =
          ScrollController(initialScrollOffset: index * newWidth)
            ..addListener(_handleScrollChanged);
    } else if (oldHeight != null &&
        widget.navigationDirection ==
            DateRangePickerNavigationDirection.vertical &&
        oldHeight != newHeight) {
      final double viewHeaderHeight = _view == DateRangePickerView.month
          ? widget.monthViewSettings.viewHeaderHeight as double
          : 0;
      final double viewSize = oldHeight - viewHeaderHeight - actionButtonHeight;
      final double index = _pickerScrollController!.position.pixels / viewSize;
      _pickerScrollController!.removeListener(_handleScrollChanged);
      _pickerScrollController!.dispose();
      _scrollKey = UniqueKey();
      _pickerKey = UniqueKey();
      _pickerScrollController = ScrollController(
          initialScrollOffset:
              index * (newHeight - viewHeaderHeight - actionButtonHeight))
        ..addListener(_handleScrollChanged);
    }
  }

  /// handle the scroll navigation mode scroll view scroll changed.
  void _handleScrollChanged() {
    final double scrolledPosition = _pickerScrollController!.position.pixels;
    final double actionButtonsHeight = widget.showActionButtons
        ? _minHeight! * 0.1 < 50
            ? 50
            : _minHeight! * 0.1
        : 0;
    double widgetSize = widget.navigationDirection ==
            DateRangePickerNavigationDirection.horizontal
        ? _minWidth!
        : _minHeight! -
            (_view == DateRangePickerView.month
                ? widget.monthViewSettings.viewHeaderHeight
                : 0) -
            actionButtonsHeight;
    if (widget.enableMultiView) {
      widgetSize /= 2;
    }

    /// Check the current visible date collection and existing visible date
    /// collection is equal or not.
    bool isViewChanged = false;
    List<dynamic> visibleDates;
    if (scrolledPosition >= 0) {
      final int index = scrolledPosition ~/ widgetSize;
      if (index >= _forwardDateCollection.length) {
        return;
      }

      visibleDates = _forwardDateCollection[index];
      if (isSameDate(_currentViewVisibleDates[0], visibleDates[0])) {
        return;
      }

      isViewChanged = true;
    } else {
      final int index = -(scrolledPosition ~/ widgetSize);
      if (index >= _backwardDateCollection.length) {
        return;
      }

      visibleDates = _backwardDateCollection[index];
      if (isSameDate(_currentViewVisibleDates[0], visibleDates[0])) {
        return;
      }

      isViewChanged = true;
    }

    if (!isViewChanged) {
      return;
    }

    dynamic currentDate = visibleDates[0];
    final int numberOfWeeksInView =
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.monthViewSettings, widget.isHijri);
    if (_view == DateRangePickerView.month &&
        (numberOfWeeksInView == 6 || widget.isHijri)) {
      final dynamic date = visibleDates[visibleDates.length ~/ 2];
      currentDate = DateRangePickerHelper.getDate(
          date.year, date.month, 1, widget.isHijri);
    }

    _currentDate = getValidDate(widget.minDate, widget.maxDate, currentDate);
    _controller.displayDate = _currentDate;
    _currentViewVisibleDates = visibleDates;
    _notifyCurrentVisibleDatesChanged();
  }

  /// Calculate and add the visible date collection for scroll view based on
  /// [isNextView] value.
  void _addScrollViewDateCollection(
      List<dynamic> dateCollection,
      bool isNextView,
      dynamic startDate,
      DateRangePickerView currentView,
      int numberOfWeeksInView,
      int visibleDatesCount) {
    int count = 0;
    dynamic visibleDate = startDate;
    while (count < 10) {
      switch (currentView) {
        case DateRangePickerView.month:
          {
            // ignore: always_specify_types, strict_raw_type
            final List visibleDates = getVisibleDates(
              visibleDate,
              null,
              widget.monthViewSettings.firstDayOfWeek,
              visibleDatesCount,
            );

            if (isNextView) {
              if (!widget.isHijri && numberOfWeeksInView != 6) {
                final dynamic date = visibleDates[0];
                if (!isSameOrBeforeDate(widget.maxDate, date)) {
                  count = 10;
                  break;
                }
              } else {
                final dynamic date = visibleDates[visibleDates.length ~/ 2];
                if ((date.month > widget.maxDate.month == true &&
                        date.year == widget.maxDate.year) ||
                    date.year > widget.maxDate.year == true) {
                  count = 10;
                  break;
                }
              }
            } else {
              if (numberOfWeeksInView != 6 && !widget.isHijri) {
                final dynamic date = visibleDates[visibleDates.length - 1];
                if (!isSameOrAfterDate(widget.minDate, date)) {
                  count = 10;
                  break;
                }
              } else {
                final dynamic date = visibleDates[visibleDates.length ~/ 2];
                if ((date.month < widget.minDate.month == true &&
                        date.year == widget.minDate.year) ||
                    date.year < widget.minDate.year == true) {
                  count = 10;
                  break;
                }
              }
            }

            dateCollection.add(visibleDates);
            if (isNextView) {
              visibleDate = DateRangePickerHelper.getNextViewStartDate(
                  currentView,
                  numberOfWeeksInView,
                  visibleDate,
                  false,
                  widget.isHijri);
            } else {
              visibleDate = DateRangePickerHelper.getPreviousViewStartDate(
                  currentView,
                  numberOfWeeksInView,
                  visibleDate,
                  false,
                  widget.isHijri);
            }
            count++;
          }
          break;
        case DateRangePickerView.decade:
        case DateRangePickerView.year:
        case DateRangePickerView.century:
          {
            if (isNextView) {
              final int currentYear = visibleDate.year as int;
              final int maxYear = widget.maxDate.year as int;
              final int offset = DateRangePickerHelper.getOffset(currentView);
              if (((currentYear ~/ offset) * offset) >
                  ((maxYear ~/ offset) * offset)) {
                count = 10;
                break;
              }
            } else {
              final int currentYear = visibleDate.year as int;
              final int minYear = widget.minDate.year as int;
              final int offset = DateRangePickerHelper.getOffset(currentView);
              if (((currentYear ~/ offset) * offset) <
                  ((minYear ~/ offset) * offset)) {
                count = 10;
                break;
              }
            }
            // ignore: always_specify_types, strict_raw_type
            final List visibleDates = DateRangePickerHelper.getVisibleYearDates(
              visibleDate,
              currentView,
              widget.isHijri,
            );

            dateCollection.add(visibleDates);
            if (isNextView) {
              visibleDate = DateRangePickerHelper.getNextViewStartDate(
                  currentView,
                  numberOfWeeksInView,
                  visibleDate,
                  false,
                  widget.isHijri);
            } else {
              visibleDate = DateRangePickerHelper.getPreviousViewStartDate(
                  currentView,
                  numberOfWeeksInView,
                  visibleDate,
                  false,
                  widget.isHijri);
            }
            count++;
          }
          break;
      }
    }
  }

  Widget _addScrollView(
      double width, double height, double actionButtonsHeight) {
    _pickerScrollController ??= ScrollController()
      ..addListener(_handleScrollChanged);
    final DateRangePickerView currentView =
        DateRangePickerHelper.getPickerView(_view);
    final int numberOfWeeksInView =
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.monthViewSettings, widget.isHijri);
    final int visibleDatesCount = DateRangePickerHelper.getViewDatesCount(
        currentView, numberOfWeeksInView, widget.isHijri);
    final bool isInitialLoading = _forwardDateCollection.isEmpty;
    if (isInitialLoading) {
      _addScrollViewDateCollection(_forwardDateCollection, true, _currentDate,
          currentView, numberOfWeeksInView, visibleDatesCount);
    }

    if (_backwardDateCollection.isEmpty) {
      // ignore: always_specify_types, unnecessary_nullable_for_final_variable_declarations, strict_raw_type
      final List? lastViewDates = _forwardDateCollection[0];
      dynamic visibleDate =
          currentView == DateRangePickerView.month && numberOfWeeksInView != 6
              ? lastViewDates != null && lastViewDates.isNotEmpty
                  ? lastViewDates[0]
                  : _currentDate
              : lastViewDates != null && lastViewDates.isNotEmpty
                  ? lastViewDates[lastViewDates.length ~/ 2]
                  : _currentDate;
      visibleDate = DateRangePickerHelper.getPreviousViewStartDate(
          currentView, numberOfWeeksInView, visibleDate, false, widget.isHijri);
      _addScrollViewDateCollection(_backwardDateCollection, false, visibleDate,
          currentView, numberOfWeeksInView, visibleDatesCount);
    }

    int forwardCollectionLength = _forwardDateCollection.length;
    final int minForwardCollectionLength = widget.enableMultiView ? 2 : 1;

    /// Check the current view have valid views.
    /// for eg., if [enableMultiView] enabled and max date is today then
    /// current view split into two and render first half with today date
    /// month and second half shown empty space.
    while (_backwardDateCollection.isNotEmpty &&
        forwardCollectionLength < minForwardCollectionLength) {
      _forwardDateCollection.insert(0, _backwardDateCollection[0]);
      _backwardDateCollection.removeAt(0);
      forwardCollectionLength += 1;
    }

    if (isInitialLoading) {
      _currentViewVisibleDates = _forwardDateCollection[0];
      _notifyCurrentVisibleDatesChanged();
    }

    final bool isHorizontal = widget.navigationDirection ==
        DateRangePickerNavigationDirection.horizontal;
    final double topPosition =
        _view == DateRangePickerView.month && !isHorizontal
            ? widget.monthViewSettings.viewHeaderHeight as double
            : 0.0;
    final double scrollViewHeight = height - topPosition - actionButtonsHeight;
    double scrollViewItemHeight = scrollViewHeight;
    double scrollViewItemWidth = width;
    if (isHorizontal) {
      scrollViewItemWidth = widget.enableMultiView
          ? scrollViewItemWidth / 2
          : scrollViewItemWidth;
    } else {
      scrollViewItemHeight = widget.enableMultiView
          ? scrollViewItemHeight / 2
          : scrollViewItemHeight;
    }

    final Widget scrollView = CustomScrollView(
      scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
      key: _scrollKey,
      physics: const AlwaysScrollableScrollPhysics(
          parent:
              ClampingScrollPhysics(parent: RangeMaintainingScrollPhysics())),
      controller: _pickerScrollController,
      center: _pickerKey,
      slivers: <Widget>[
        SliverFixedExtentList(
          itemExtent: isHorizontal ? scrollViewItemWidth : scrollViewItemHeight,
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (_backwardDateCollection.length <= index) {
              return null;
            }

            /// Send negative index value to differentiate the
            /// backward view from forward view.
            return _getScrollViewItem(
                -(index + 1),
                scrollViewItemWidth,
                scrollViewItemHeight,
                _backwardDateCollection[index],
                isHorizontal);
          }),
        ),
        SliverFixedExtentList(
          itemExtent: isHorizontal ? scrollViewItemWidth : scrollViewItemHeight,
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            if (_forwardDateCollection.length <= index) {
              return null;
            }

            return _getScrollViewItem(
                index,
                scrollViewItemWidth,
                scrollViewItemHeight,
                _forwardDateCollection[index],
                isHorizontal);
          }),
          key: _pickerKey,
        ),
      ],
    );

    if (isHorizontal) {
      return Stack(
        children: <Widget>[
          scrollView,
          _getActionsButton(
              topPosition + scrollViewHeight, actionButtonsHeight),
        ],
      );
    } else {
      _viewHeaderVisibleDates.value = _currentViewVisibleDates;
      return Stack(children: <Widget>[
        _getViewHeaderView(0),
        Positioned(
            left: 0,
            top: topPosition,
            right: 0,
            height: scrollViewHeight,
            child: scrollView),
        _getActionsButton(topPosition + scrollViewHeight, actionButtonsHeight)
      ]);
    }
  }

  /// Return widget that placed on scroll view when navigation mode is scroll.
  Widget _getScrollViewItem(
      int index,
      double width,
      double height,
      // ignore: always_specify_types, strict_raw_type
      List dates,
      bool isHorizontal) {
    final DateRangePickerView currentView =
        DateRangePickerHelper.getPickerView(_view);
    final int numberOfWeeksInView =
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.monthViewSettings, widget.isHijri);
    final int visibleDatesCount = DateRangePickerHelper.getViewDatesCount(
        currentView, numberOfWeeksInView, widget.isHijri);
    if (index >= 0) {
      if (_forwardDateCollection.isNotEmpty &&
          index > _forwardDateCollection.length - 2) {
        // ignore: always_specify_types, strict_raw_type
        final List lastViewDates =
            _forwardDateCollection[_forwardDateCollection.length - 1];
        dynamic date = currentView == DateRangePickerView.month &&
                DateRangePickerHelper.getNumberOfWeeksInView(
                        widget.monthViewSettings, widget.isHijri) !=
                    6
            ? lastViewDates[0]
            : lastViewDates[lastViewDates.length ~/ 2];
        date = DateRangePickerHelper.getNextViewStartDate(
            currentView, numberOfWeeksInView, date, false, widget.isHijri);
        _addScrollViewDateCollection(_forwardDateCollection, true, date,
            currentView, numberOfWeeksInView, visibleDatesCount);
      }
    } else {
      if (_backwardDateCollection.isNotEmpty &&
          -index > _backwardDateCollection.length - 2) {
        // ignore: always_specify_types, strict_raw_type
        final List lastViewDates =
            _backwardDateCollection[_backwardDateCollection.length - 1];
        dynamic date = currentView == DateRangePickerView.month &&
                DateRangePickerHelper.getNumberOfWeeksInView(
                        widget.monthViewSettings, widget.isHijri) !=
                    6
            ? lastViewDates[0]
            : lastViewDates[lastViewDates.length ~/ 2];
        date = DateRangePickerHelper.getPreviousViewStartDate(
            currentView, numberOfWeeksInView, date, false, widget.isHijri);
        _addScrollViewDateCollection(_backwardDateCollection, false, date,
            currentView, numberOfWeeksInView, visibleDatesCount);
      }
    }

    final double pickerHeight = height - widget.headerHeight;
    final double pickerWidth = width - (isHorizontal ? 1 : 0);
    double headerWidth = pickerWidth;
    if (isHorizontal) {
      final String headerText = _getHeaderText(
          dates,
          _view,
          0,
          widget.isHijri,
          numberOfWeeksInView,
          widget.monthFormat,
          false,
          widget.headerStyle,
          widget.navigationDirection,
          _locale,
          _localizations);
      headerWidth = _getTextWidgetWidth(
              headerText, widget.headerHeight, pickerWidth, context,
              style: _datePickerTheme.headerTextStyle!, widthPadding: 20)
          .width;
    }

    if (headerWidth > pickerWidth) {
      headerWidth = pickerWidth;
    }

    final Color? backgroundColor = widget.headerStyle.backgroundColor ??
        _datePickerTheme.headerBackgroundColor;
    final Widget header = Positioned(
      top: 0,
      left: 0,
      width: headerWidth,
      height: widget.headerHeight,
      child: GestureDetector(
        child: Container(
          color: backgroundColor,
          height: widget.headerHeight,
          child: _PickerHeaderView(
              ValueNotifier<List<dynamic>>(dates),
              widget.headerStyle,
              widget.selectionMode,
              _view,
              DateRangePickerHelper.getNumberOfWeeksInView(
                  widget.monthViewSettings, widget.isHijri),
              widget.showNavigationArrow,
              widget.navigationDirection,
              widget.monthViewSettings.enableSwipeSelection,
              widget.navigationMode,
              widget.minDate,
              widget.maxDate,
              widget.monthFormat,
              _datePickerTheme,
              _locale,
              headerWidth,
              widget.headerHeight,
              widget.allowViewNavigation,
              _controller.backward,
              _controller.forward,
              _isMultiViewEnabled(widget),
              widget.viewSpacing,
              widget.selectionColor ?? _datePickerTheme.selectionColor!,
              _isRtl,
              _textScaleFactor,
              widget.isHijri,
              _localizations),
        ),
        onTapUp: (TapUpDetails details) {
          if (_view == DateRangePickerView.century ||
              !widget.allowViewNavigation) {
            return;
          }

          /// Get the current tapped view date.
          dynamic currentDate = dates[0];
          final int numberOfWeeksInView =
              DateRangePickerHelper.getNumberOfWeeksInView(
                  widget.monthViewSettings, widget.isHijri);
          if (_view == DateRangePickerView.month &&
              (numberOfWeeksInView == 6 || widget.isHijri)) {
            final dynamic date = dates[dates.length ~/ 2];
            currentDate = DateRangePickerHelper.getDate(
                date.year, date.month, 1, widget.isHijri);
          }

          currentDate =
              getValidDate(widget.minDate, widget.maxDate, currentDate);

          /// Check the moved view visible date not contains tapped
          /// header date
          /// Eg., If you scroll to place the month view with Dec 2020
          /// and Jan 2021 then it current visible view date is Dec 2020
          /// and tap the Jan 2021 then it moved to year view 2020. So
          /// check the tapped date's (Jan 2021) year is current display
          /// date year or not. if not then update the display date value.
          if ((_view == DateRangePickerView.month &&
                  _currentDate.year != currentDate.year) ||
              (_view == DateRangePickerView.year &&
                  _currentDate.year ~/ 10 != currentDate.year ~/ 10) ||
              (_view == DateRangePickerView.decade &&
                  _currentDate.year ~/ 100 != currentDate.year ~/ 100)) {
            _currentDate = currentDate;
            _controller.displayDate = _currentDate;
          }
          _updateCalendarTapCallbackForHeader();
        },
      ),
    );
    final Widget pickerView = Positioned(
      top: widget.headerHeight,
      left: 0,
      width: pickerWidth,
      height: pickerHeight,
      child: _AnimatedOpacityWidget(
        opacity: _opacity,
        child: _PickerView(
          widget,
          _controller,
          dates,
          _isMultiViewEnabled(widget),
          pickerWidth,
          pickerHeight,
          _datePickerTheme,
          null,
          _textScaleFactor,
          null,
          getPickerStateDetails: _getPickerStateValues,
          updatePickerStateDetails: _updatePickerStateValues,
          isRtl: _isRtl,
        ),
      ),
    );

    final List<Widget> children = <Widget>[pickerView];
    if (isHorizontal) {
      children.add(Positioned(
        top: 0,
        left: pickerWidth,
        width: 1,
        height: height,
        child: const VerticalDivider(
          thickness: 1,
        ),
      ));
    }

    children.add(header);
    return SizedBox(
        width: width,
        height: height,
        child: _StickyHeader(
          isHorizontal: isHorizontal,
          isRTL: _isRtl,
          children: children,
        ));
  }

  Widget _addChildren(
      double top, double height, double width, double actionButtonsHeight) {
    _headerVisibleDates.value = _currentViewVisibleDates;
    height -= actionButtonsHeight;
    return Stack(children: <Widget>[
      Positioned(
        top: 0,
        right: 0,
        left: 0,
        height: widget.headerHeight,
        child: GestureDetector(
          child: Container(
            color: widget.headerStyle.backgroundColor ??
                _datePickerTheme.headerBackgroundColor,
            height: widget.headerHeight,
            child: _PickerHeaderView(
                _headerVisibleDates,
                widget.headerStyle,
                widget.selectionMode,
                _view,
                DateRangePickerHelper.getNumberOfWeeksInView(
                    widget.monthViewSettings, widget.isHijri),
                widget.showNavigationArrow,
                widget.navigationDirection,
                widget.monthViewSettings.enableSwipeSelection,
                widget.navigationMode,
                widget.minDate,
                widget.maxDate,
                widget.monthFormat,
                _datePickerTheme,
                _locale,
                width,
                widget.headerHeight,
                widget.allowViewNavigation,
                _controller.backward,
                _controller.forward,
                _isMultiViewEnabled(widget),
                widget.viewSpacing,
                widget.selectionColor ?? _datePickerTheme.selectionColor!,
                _isRtl,
                _textScaleFactor,
                widget.isHijri,
                _localizations),
          ),
          onTapUp: (TapUpDetails details) {
            _updateCalendarTapCallbackForHeader();
          },
        ),
      ),
      _getViewHeaderView(widget.headerHeight),
      Positioned(
        top: top,
        left: 0,
        right: 0,
        height: height,
        child: _AnimatedOpacityWidget(
          opacity: _opacity,
          child: _PickerScrollView(
            widget,
            _controller,
            width,
            height,
            _isRtl,
            _datePickerTheme,
            _locale,
            _textScaleFactor,
            getPickerStateValues: (PickerStateArgs details) {
              _getPickerStateValues(details);
            },
            updatePickerStateValues: (PickerStateArgs details) {
              _updatePickerStateValues(details);
            },
            key: _scrollViewKey,
          ),
        ),
      ),
      _getActionsButton(top + height, actionButtonsHeight)
    ]);
  }

  Widget _getActionsButton(double top, double actionButtonsHeight) {
    if (!widget.showActionButtons && !widget.showTodayButton) {
      return const SizedBox(width: 0, height: 0);
    }
    Color textColor =
        widget.todayHighlightColor ?? _datePickerTheme.todayHighlightColor!;
    if (textColor == Colors.transparent) {
      final TextStyle style = _datePickerTheme.todayTextStyle!;
      textColor = style.color != null ? style.color! : Colors.blue;
    }
    final Widget actionButtons = widget.showActionButtons
        ? Container(
            alignment: AlignmentDirectional.centerEnd,
            constraints: const BoxConstraints(minHeight: 52.0),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: OverflowBar(
              spacing: 8,
              children: <Widget>[
                TextButton(
                  onPressed: _handleCancel,
                  child: Text(
                    widget.cancelText,
                    style: TextStyle(color: textColor),
                  ),
                ),
                TextButton(
                  onPressed: _handleOk,
                  child: Text(
                    widget.confirmText,
                    style: TextStyle(color: textColor),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox(width: 0, height: 0);
    final Widget todayButton = widget.showTodayButton
        ? Container(
            alignment: AlignmentDirectional.centerStart,
            constraints: const BoxConstraints(minHeight: 52.0),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: OverflowBar(
              spacing: 8,
              children: <Widget>[
                TextButton(
                  child: Text(
                    _localizations.todayLabel.toUpperCase(),
                    style: TextStyle(color: textColor),
                  ),
                  onPressed: () {
                    if (widget.allowViewNavigation) {
                      _controller.view = widget.isHijri
                          ? HijriDatePickerView.month
                          : DateRangePickerView.month;
                    }

                    _controller.displayDate =
                        DateRangePickerHelper.getToday(widget.isHijri);
                  },
                ),
              ],
            ),
          )
        : const SizedBox(width: 0, height: 0);
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      height: actionButtonsHeight,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[todayButton, actionButtons]),
    );
  }

  void _handleCancel() {
    switch (widget.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          _selectedDate = _previousSelectedValue.selectedDate;
          if (!isSameDate(_controller.selectedDate, _selectedDate)) {
            setState(() {
              _controller.selectedDate = _selectedDate;
            });
          }
        }
        break;
      case DateRangePickerSelectionMode.multiple:
        {
          _selectedDates = _previousSelectedValue.selectedDates != null
              ? _getSelectedDates(_previousSelectedValue.selectedDates)
              : null;
          if (!DateRangePickerHelper.isDateCollectionEquals(
              _selectedDates, _controller.selectedDates)) {
            setState(() {
              _controller.selectedDates =
                  _previousSelectedValue.selectedDates != null
                      ? _getSelectedDates(_previousSelectedValue.selectedDates)
                      : null;
            });
          }
        }
        break;
      case DateRangePickerSelectionMode.range:
      case DateRangePickerSelectionMode.extendableRange:
        {
          _selectedRange = _previousSelectedValue.selectedRange;
          if (!DateRangePickerHelper.isRangeEquals(
              _selectedRange, _controller.selectedRange)) {
            setState(() {
              _controller.selectedRange = _selectedRange;
            });
          }
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          _selectedRanges = _previousSelectedValue.selectedRanges != null
              ? _getSelectedRanges(_previousSelectedValue.selectedRanges)
              : null;
          if (!DateRangePickerHelper.isDateRangesEquals(
              _selectedRanges, _controller.selectedRanges)) {
            setState(() {
              _controller.selectedRanges = _previousSelectedValue
                          .selectedRanges !=
                      null
                  ? _getSelectedRanges(_previousSelectedValue.selectedRanges)
                  : null;
            });
          }
        }
    }

    widget.onCancel?.call();
  }

  void _handleOk() {
    dynamic value;
    switch (widget.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          value = _selectedDate;
          _previousSelectedValue.selectedDate = _selectedDate;
        }
        break;
      case DateRangePickerSelectionMode.multiple:
        {
          value = _getSelectedDates(_selectedDates);
          _previousSelectedValue.selectedDates =
              _getSelectedDates(_selectedDates);
        }
        break;
      case DateRangePickerSelectionMode.range:
      case DateRangePickerSelectionMode.extendableRange:
        {
          value = _selectedRange;
          _previousSelectedValue.selectedRange = _selectedRange;
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          value = _getSelectedRanges(_selectedRanges);
          _previousSelectedValue.selectedRanges =
              _getSelectedRanges(_selectedRanges);
        }
    }

    widget.onSubmit?.call(value);
  }

  Widget _getViewHeaderView(double topPosition) {
    if (_view == DateRangePickerView.month &&
        widget.navigationDirection ==
            DateRangePickerNavigationDirection.vertical) {
      final Color todayTextColor =
          widget.monthCellStyle.todayTextStyle != null &&
                  widget.monthCellStyle.todayTextStyle!.color != null
              ? widget.monthCellStyle.todayTextStyle!.color! as Color
              : (widget.todayHighlightColor != null &&
                      widget.todayHighlightColor! != Colors.transparent
                  ? widget.todayHighlightColor!
                  : _datePickerTheme.todayHighlightColor!);
      return Positioned(
        left: 0,
        top: topPosition,
        right: 0,
        height: widget.monthViewSettings.viewHeaderHeight,
        child: _AnimatedOpacityWidget(
          opacity: _opacity,
          child: Container(
            color: widget.monthViewSettings.viewHeaderStyle.backgroundColor ??
                _datePickerTheme.viewHeaderBackgroundColor,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _PickerViewHeaderPainter(
                    _currentViewVisibleDates,
                    widget.navigationMode,
                    widget.monthViewSettings.viewHeaderStyle,
                    widget.monthViewSettings.viewHeaderHeight,
                    widget.monthViewSettings,
                    _datePickerTheme,
                    _locale,
                    _isRtl,
                    widget.monthCellStyle,
                    _isMultiViewEnabled(widget),
                    widget.viewSpacing,
                    todayTextColor,
                    _textScaleFactor,
                    widget.isHijri,
                    widget.navigationDirection,
                    _viewHeaderVisibleDates,
                    widget.monthViewSettings.showWeekNumber,
                    _isMobilePlatform),
              ),
            ),
          ),
        ),
      );
    }

    return Positioned(left: 0, top: 0, right: 0, height: 0, child: Container());
  }

  void _moveToNextView() {
    if (widget.navigationMode == DateRangePickerNavigationMode.scroll) {
      return;
    }
    if (!DateRangePickerHelper.canMoveToNextView(
        _view,
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.monthViewSettings, widget.isHijri),
        widget.maxDate,
        _currentViewVisibleDates,
        _isMultiViewEnabled(widget),
        widget.isHijri)) {
      return;
    }

    _isRtl
        ? _scrollViewKey.currentState!._moveToPreviousViewWithAnimation()
        : _scrollViewKey.currentState!._moveToNextViewWithAnimation();
  }

  void _moveToPreviousView() {
    if (widget.navigationMode == DateRangePickerNavigationMode.scroll) {
      return;
    }
    if (!DateRangePickerHelper.canMoveToPreviousView(
        _view,
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.monthViewSettings, widget.isHijri),
        widget.minDate,
        _currentViewVisibleDates,
        _isMultiViewEnabled(widget),
        widget.isHijri)) {
      return;
    }

    _isRtl
        ? _scrollViewKey.currentState!._moveToNextViewWithAnimation()
        : _scrollViewKey.currentState!._moveToPreviousViewWithAnimation();
  }

  void _getPickerStateValues(PickerStateArgs details) {
    details.currentDate = _currentDate;
    details.selectedDate = _selectedDate;
    details.selectedDates = _selectedDates;
    details.selectedRange = _selectedRange;
    details.selectedRanges = _selectedRanges;
    details.currentViewVisibleDates = _currentViewVisibleDates;
    details.view = DateRangePickerHelper.getPickerView(_view);
  }

  void _updatePickerStateValues(PickerStateArgs details) {
    if (details.currentDate != null) {
      if (!isSameOrAfterDate(widget.minDate, details.currentDate)) {
        details.currentDate = widget.minDate;
      }

      if (!isSameOrBeforeDate(widget.maxDate, details.currentDate)) {
        details.currentDate = widget.maxDate;
      }

      _currentDate = details.currentDate;
      _controller.displayDate = _currentDate;
    }

    if (_currentViewVisibleDates != details.currentViewVisibleDates) {
      _currentViewVisibleDates = details.currentViewVisibleDates;
      _headerVisibleDates.value = _currentViewVisibleDates;
      _notifyCurrentVisibleDatesChanged();
    }

    if (_view != details.view) {
      _controller.view = widget.isHijri
          ? DateRangePickerHelper.getHijriPickerView(details.view)
          : DateRangePickerHelper.getPickerView(details.view);
      if (_view == DateRangePickerView.month &&
          widget.navigationDirection ==
              DateRangePickerNavigationDirection.vertical) {
        _viewHeaderVisibleDates.value = _currentViewVisibleDates;
      }
    }

    if (_view == DateRangePickerView.month &&
        widget.navigationDirection ==
            DateRangePickerNavigationDirection.vertical) {
      final dynamic today = DateRangePickerHelper.getToday(widget.isHijri);

      final dynamic previousMonthDate = getPreviousMonthDate(today);
      final dynamic nextMonthDate = getNextMonthDate(today);

      if ((_currentDate.month == today.month &&
              _currentDate.year == today.year) ||
          (_currentDate.month == previousMonthDate.month &&
              _currentDate.year == previousMonthDate.year) ||
          (_currentDate.month == nextMonthDate.month &&
              _currentDate.year == nextMonthDate.year) ||
          _viewHeaderVisibleDates.value.length !=
              _currentViewVisibleDates.length) {
        _viewHeaderVisibleDates.value = _currentViewVisibleDates;
      }
    }

    if (_view == DateRangePickerView.month || !widget.allowViewNavigation) {
      switch (widget.selectionMode) {
        case DateRangePickerSelectionMode.single:
          {
            _selectedDate = details.selectedDate;
            final bool isSameSelectedDate =
                isSameDate(_controller.selectedDate, _selectedDate);
            if (widget.navigationMode == DateRangePickerNavigationMode.scroll &&
                !isSameSelectedDate) {
              setState(() {
                /// Update selection views for scroll navigation mode.
              });
            }

            _controller.selectedDate = _selectedDate;
            if (!isSameSelectedDate) {
              _raiseSelectionChangedCallback(widget,
                  value: _controller.selectedDate);
            }
          }
          break;
        case DateRangePickerSelectionMode.multiple:
          {
            _selectedDates = details.selectedDates;
            final bool isSameSelectedDate =
                DateRangePickerHelper.isDateCollectionEquals(
                    _selectedDates, _controller.selectedDates);
            if (widget.navigationMode == DateRangePickerNavigationMode.scroll &&
                !isSameSelectedDate) {
              setState(() {
                /// Update selection views for scroll navigation mode.
              });
            }

            _controller.selectedDates = _getSelectedDates(_selectedDates);
            if (!isSameSelectedDate) {
              _raiseSelectionChangedCallback(widget,
                  value: _controller.selectedDates);
            }
          }
          break;
        case DateRangePickerSelectionMode.range:
        case DateRangePickerSelectionMode.extendableRange:
          {
            _selectedRange = details.selectedRange;
            final bool isSameSelectedDate = DateRangePickerHelper.isRangeEquals(
                _selectedRange, _controller.selectedRange);
            if (widget.navigationMode == DateRangePickerNavigationMode.scroll &&
                !isSameSelectedDate) {
              setState(() {
                /// Update selection views for scroll navigation mode.
              });
            }

            _controller.selectedRange = _selectedRange;
            if (!isSameSelectedDate) {
              _raiseSelectionChangedCallback(widget,
                  value: _controller.selectedRange);
            }
          }
          break;
        case DateRangePickerSelectionMode.multiRange:
          {
            _selectedRanges = details.selectedRanges;
            final bool isSameSelectedDate =
                DateRangePickerHelper.isDateRangesEquals(
                    _selectedRanges, _controller.selectedRanges);
            if (widget.navigationMode == DateRangePickerNavigationMode.scroll &&
                !isSameSelectedDate) {
              setState(() {
                /// Update selection views for scroll navigation mode.
              });
            }

            _controller.selectedRanges = _getSelectedRanges(_selectedRanges);
            if (!isSameSelectedDate) {
              _raiseSelectionChangedCallback(widget,
                  value: _controller.selectedRanges);
            }
          }
      }
    }
  }

  /// Used to call the view changed callback when [_currentViewVisibleDates]
  /// changed.
  void _notifyCurrentVisibleDatesChanged() {
    final DateRangePickerView view =
        DateRangePickerHelper.getPickerView(_controller.view);
    dynamic visibleDateRange;
    switch (view) {
      case DateRangePickerView.month:
        {
          final bool enableMultiView = _isMultiViewEnabled(widget);
          if (widget.isHijri ||
              (!DateRangePickerHelper.canShowLeadingAndTrailingDates(
                      widget.monthViewSettings, widget.isHijri) &&
                  DateRangePickerHelper.getNumberOfWeeksInView(
                          widget.monthViewSettings, widget.isHijri) ==
                      6)) {
            final dynamic visibleDate = _currentViewVisibleDates[
                _currentViewVisibleDates.length ~/ (enableMultiView ? 4 : 2)];
            if (widget.isHijri) {
              visibleDateRange = HijriDateRange(
                  DateRangePickerHelper.getMonthStartDate(
                      visibleDate, widget.isHijri),
                  enableMultiView
                      ? DateRangePickerHelper.getMonthEndDate(
                          DateRangePickerHelper.getNextViewStartDate(
                              DateRangePickerHelper.getPickerView(
                                  _controller.view),
                              6,
                              visibleDate,
                              _isRtl,
                              widget.isHijri))
                      : DateRangePickerHelper.getMonthEndDate(visibleDate));
            } else {
              visibleDateRange = PickerDateRange(
                  DateRangePickerHelper.getMonthStartDate(
                      visibleDate, widget.isHijri),
                  enableMultiView
                      ? DateRangePickerHelper.getMonthEndDate(
                          DateRangePickerHelper.getNextViewStartDate(
                              DateRangePickerHelper.getPickerView(
                                  _controller.view),
                              6,
                              visibleDate,
                              _isRtl,
                              widget.isHijri))
                      : DateRangePickerHelper.getMonthEndDate(visibleDate));
            }
            _raisePickerViewChangedCallback(widget,
                visibleDateRange: visibleDateRange, view: _controller.view);
          } else {
            if (widget.isHijri) {
              visibleDateRange = HijriDateRange(
                  _currentViewVisibleDates[0],
                  _currentViewVisibleDates[
                      _currentViewVisibleDates.length - 1]);
            } else {
              visibleDateRange = PickerDateRange(
                  _currentViewVisibleDates[0],
                  _currentViewVisibleDates[
                      _currentViewVisibleDates.length - 1]);
            }
            _raisePickerViewChangedCallback(widget,
                visibleDateRange: visibleDateRange, view: _controller.view);
          }
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          if (widget.isHijri) {
            visibleDateRange = HijriDateRange(_currentViewVisibleDates[0],
                _currentViewVisibleDates[_currentViewVisibleDates.length - 1]);
          } else {
            visibleDateRange = PickerDateRange(_currentViewVisibleDates[0],
                _currentViewVisibleDates[_currentViewVisibleDates.length - 1]);
          }
          _raisePickerViewChangedCallback(widget,
              visibleDateRange: visibleDateRange, view: _controller.view);
        }
    }
  }

  /// returns the selected ranges in the required type list.
  // ignore: always_specify_types, strict_raw_type
  List? _getSelectedRanges(List<dynamic>? ranges) {
    if (ranges == null) {
      return ranges;
    }

    // ignore: always_specify_types, strict_raw_type
    List selectedRanges;
    if (widget.isHijri) {
      selectedRanges = <HijriDateRange>[];
    } else {
      selectedRanges = <PickerDateRange>[];
    }

    for (int i = 0; i < ranges.length; i++) {
      selectedRanges.add(ranges[i]);
    }

    return selectedRanges;
  }

  /// returns the selected dates in the required type list
  // ignore: always_specify_types, strict_raw_type
  List? _getSelectedDates(List<dynamic>? dates) {
    if (dates == null) {
      return dates;
    }

    // ignore: always_specify_types, strict_raw_type
    List selectedDates;
    if (widget.isHijri) {
      selectedDates = <HijriDateTime>[];
    } else {
      selectedDates = <DateTime>[];
    }

    for (int i = 0; i < dates.length; i++) {
      selectedDates.add(dates[i]);
    }

    return selectedDates;
  }

  // method to update the picker tapped call back for the header view
  void _updateCalendarTapCallbackForHeader() {
    if (_view == DateRangePickerView.century || !widget.allowViewNavigation) {
      return;
    }

    if (_view == DateRangePickerView.month) {
      _controller.view = widget.isHijri
          ? DateRangePickerHelper.getHijriPickerView(DateRangePickerView.year)
          : DateRangePickerHelper.getPickerView(DateRangePickerView.year);
    } else {
      if (_view == DateRangePickerView.year) {
        _controller.view = widget.isHijri
            ? DateRangePickerHelper.getHijriPickerView(
                DateRangePickerView.decade)
            : DateRangePickerHelper.getPickerView(DateRangePickerView.decade);
      } else if (_view == DateRangePickerView.decade) {
        _controller.view = widget.isHijri
            ? DateRangePickerHelper.getHijriPickerView(
                DateRangePickerView.century)
            : DateRangePickerHelper.getPickerView(DateRangePickerView.century);
      }
    }
  }
}

/// Creates a widget that animates its opacity implicitly.
class _AnimatedOpacityWidget extends StatefulWidget {
  const _AnimatedOpacityWidget({required this.child, required this.opacity});

  final Widget child;

  final ValueNotifier<double> opacity;

  @override
  State<StatefulWidget> createState() => _AnimatedOpacityWidgetState();
}

class _AnimatedOpacityWidgetState extends State<_AnimatedOpacityWidget> {
  @override
  void initState() {
    widget.opacity.addListener(_update);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _AnimatedOpacityWidget oldWidget) {
    if (widget.opacity != oldWidget.opacity) {
      oldWidget.opacity.removeListener(_update);
      widget.opacity.addListener(_update);
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Update the opacity widget with new opacity value.
  void _update() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.opacity.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: widget.opacity.value, child: widget.child);
  }
}

/// Holds content and header to show header like sticky based on content.
class _StickyHeader extends Stack {
  const _StickyHeader({
    required List<Widget> children,
    AlignmentDirectional alignment = AlignmentDirectional.topStart,
    this.isHorizontal = false,
    this.isRTL = false,
    Key? key,
  }) : super(
          key: key,
          children: children,
          alignment: alignment,
        );

  final bool isHorizontal;
  final bool isRTL;

  @override
  RenderStack createRenderObject(BuildContext context) =>
      _StickyHeaderRenderObject(
        scrollableState: Scrollable.of(context),
        alignment: alignment,
        textDirection: textDirection ?? Directionality.of(context),
        fit: fit,
        isHorizontal: isHorizontal,
        isRTL: isRTL,
      );

  @override
  @mustCallSuper
  void updateRenderObject(BuildContext context, RenderStack renderObject) {
    super.updateRenderObject(context, renderObject);

    if (renderObject is _StickyHeaderRenderObject) {
      renderObject
        ..scrollableState = Scrollable.of(context)
        ..isRTL = isRTL
        ..isHorizontal = isHorizontal;
    }
  }
}

class _StickyHeaderRenderObject extends RenderStack {
  _StickyHeaderRenderObject({
    required ScrollableState scrollableState,
    required AlignmentGeometry alignment,
    required TextDirection textDirection,
    required StackFit fit,
    required bool isHorizontal,
    required bool isRTL,
  })  : _scrollableState = scrollableState,
        _isHorizontal = isHorizontal,
        _isRTL = isRTL,
        super(
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
        );

  /// Used to update the child position when it scroll changed.
  ScrollableState _scrollableState;

  bool _isHorizontal = false;

  bool get isHorizontal => _isHorizontal;

  set isHorizontal(bool value) {
    if (_isHorizontal == value) {
      return;
    }

    _isHorizontal = value;
    markNeedsPaint();
  }

  bool _isRTL = false;

  bool get isRTL => _isRTL;

  set isRTL(bool value) {
    if (_isRTL == value) {
      return;
    }

    _isRTL = value;
    markNeedsPaint();
  }

  /// Current view port.
  RenderAbstractViewport get _stackViewPort => RenderAbstractViewport.of(this);

  ScrollableState get scrollableState => _scrollableState;

  set scrollableState(ScrollableState newScrollable) {
    final ScrollableState oldScrollable = _scrollableState;
    _scrollableState = newScrollable;

    markNeedsPaint();
    if (attached) {
      oldScrollable.position.removeListener(markNeedsPaint);
      newScrollable.position.addListener(markNeedsPaint);
    }
  }

  /// attach will called when the render object rendered in view.
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    scrollableState.position.addListener(markNeedsPaint);
  }

  /// attach will called when the render object removed from view.
  @override
  void detach() {
    scrollableState.position.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset paintOffset) {
    /// Update the child position.
    updateHeaderOffset();
    paintStack(context, paintOffset);
  }

  void updateHeaderOffset() {
    /// Content widget size based on it axis direction.
    final double contentSize =
        _isHorizontal ? firstChild!.size.width : firstChild!.size.height;

    final RenderBox headerView = lastChild!;

    /// Header view sized based on it axis direction.
    final double headerSize =
        _isHorizontal ? headerView.size.width : headerView.size.height;

    /// Current view position on scroll view.
    final double viewPosition =
        _stackViewPort.getOffsetToReveal(this, 0).offset;

    /// Calculate the current view offset by view position on scroll view,
    /// scrolled position and scroll view view port.
    final double currentViewOffset =
        viewPosition - _scrollableState.position.pixels - _scrollableSize;

    /// Check current header offset exits content size, if exist then place the
    /// header at content size.
    final double offset = _getCurrentOffset(currentViewOffset, contentSize);
    final ParentData parentData = headerView.parentData!;
    final StackParentData? headerParentData =
        parentData is StackParentData ? parentData : null;

    /// Calculate the offset value for horizontal direction with rtl by
    /// using content size and header size
    /// Eg., If initially header in position 0 then calculate the offset on RTL
    /// by content size(total control size) - header size(total header widget
    /// size) - 0 and the header placed on right side end.
    final double headerYOffset = _isRTL && _isHorizontal
        ? contentSize -
            headerSize -
            _getHeaderOffset(contentSize, offset, headerSize)
        : _getHeaderOffset(contentSize, offset, headerSize);

    /// Update the header start y position on vertical direction or update the
    /// header start x position on horizontal direction.
    if (!_isHorizontal && headerYOffset != headerParentData?.offset.dy) {
      headerParentData?.offset =
          Offset(headerParentData.offset.dx, headerYOffset);
    } else if (_isHorizontal && headerYOffset != headerParentData?.offset.dx) {
      headerParentData?.offset =
          Offset(headerYOffset, headerParentData.offset.dy);
    }
  }

  /// Return the view port size.
  double get _scrollableSize {
    final Object viewPort = _stackViewPort;
    double viewPortSize = 0;

    if (viewPort is RenderBox) {
      viewPortSize = _isHorizontal ? viewPort.size.width : viewPort.size.height;
    }

    double anchor = 0;
    if (viewPort is RenderViewport) {
      anchor = viewPort.anchor;
    }

    return -viewPortSize * anchor;
  }

  /// Check current header offset exits content size, if exist then place the
  /// header at content size.
  double _getCurrentOffset(double currentOffset, double contentSize) {
    final double currentHeaderPosition =
        -currentOffset > contentSize ? contentSize : -currentOffset;

    return currentHeaderPosition > 0 ? currentHeaderPosition : 0;
  }

  /// Return current offset value from header size and content size.
  double _getHeaderOffset(
    double contentSize,
    double offset,
    double headerSize,
  ) {
    /// Header max start top position is content size position because the
    /// view holds header and content. The view's height is header height and
    /// content size so header max scroll position is (total height - header
    /// height) content size. So vertical direction, header size is 0.
    if (!_isHorizontal) {
      headerSize = 0;
    }
    return headerSize + offset < contentSize
        ? offset
        : contentSize - headerSize;
  }
}

/// Holds the picker header text, navigation arrow and handle its interactions.
@immutable
class _PickerHeaderView extends StatefulWidget {
  /// Constructor to create picker header view instance.
  const _PickerHeaderView(
      this.visibleDates,
      this.headerStyle,
      this.selectionMode,
      this.view,
      this.numberOfWeeksInView,
      this.showNavigationArrow,
      this.navigationDirection,
      this.enableSwipeSelection,
      this.navigationMode,
      this.minDate,
      this.maxDate,
      this.monthFormat,
      this.datePickerTheme,
      this.locale,
      this.width,
      this.height,
      this.allowViewNavigation,
      this.previousNavigationCallback,
      this.nextNavigationCallback,
      this.enableMultiView,
      this.multiViewSpacing,
      this.hoverColor,
      this.isRtl,
      this.textScaleFactor,
      this.isHijri,
      this.localizations,
      {Key? key})
      : super(key: key);

  /// Defines the text scale factor of [SfDateRangePicker].
  final double textScaleFactor;

  /// Defines the selection mode of [SfDateRangePicker].
  final DateRangePickerSelectionMode selectionMode;

  /// Defines the header style of [SfDateRangePicker].
  final DateRangePickerHeaderStyle headerStyle;

  /// Holds the current picker view of picker.
  final DateRangePickerView view;

  /// Defines the number of week in [SfDateRangePicker] month view.
  final int numberOfWeeksInView;

  /// Decides the navigation arrow will shown or not.
  final bool showNavigationArrow;

  /// Defines the navigation direction of [SfDateRangePicker].
  final DateRangePickerNavigationDirection navigationDirection;

  /// The minimum date as much as the [SfDateRangePicker] will navigate.
  final dynamic minDate;

  /// The maximum date as much as the [SfDateRangePicker] will navigate.
  final dynamic maxDate;

  /// Defines the month format used on header view text.
  final String? monthFormat;

  /// Decides the swipe selection enabled or not.
  final bool enableSwipeSelection;

  final DateRangePickerNavigationMode navigationMode;

  /// Decides the view navigation allowed or not.
  final bool allowViewNavigation;

  /// Holds the theme data for date range picker.
  final SfDateRangePickerThemeData datePickerTheme;

  /// Defines the locale details of date range picker.
  final Locale locale;

  /// Holds the visible dates for the current picker view.
  final ValueNotifier<List<dynamic>> visibleDates;

  /// Holds the previous navigation call back for date range picker.
  final VoidCallback? previousNavigationCallback;

  /// Holds the next navigation call back for date range picker.
  final VoidCallback? nextNavigationCallback;

  /// Holds the picker view width used on widget positioning.
  final double width;

  /// Holds the picker view height used on widget positioning.
  final double height;

  /// Used to identify the widget direction is RTL.
  final bool isRtl;

  /// Holds the header hover color.
  final Color hoverColor;

  /// Decides to show the multi view of picker or not.
  final bool enableMultiView;

  /// Specifies the space between the multi month views.
  final double multiViewSpacing;

  /// Specifies the localization details
  final SfLocalizations localizations;

  /// Specifies the picker mode for [SfDateRangePicker].
  final bool isHijri;

  @override
  _PickerHeaderViewState createState() => _PickerHeaderViewState();
}

class _PickerHeaderViewState extends State<_PickerHeaderView> {
  bool _hovering = false;

  @override
  void initState() {
    _hovering = false;
    _addListener();
    super.initState();
  }

  @override
  void didUpdateWidget(_PickerHeaderView oldWidget) {
    widget.visibleDates.removeListener(_listener);
    _addListener();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobilePlatform =
        DateRangePickerHelper.isMobileLayout(Theme.of(context).platform);
    double arrowWidth = 0;
    double headerWidth = widget.width;
    bool showNavigationArrow = widget.showNavigationArrow ||
        ((widget.view == DateRangePickerView.month ||
                !widget.allowViewNavigation) &&
            _isSwipeInteractionEnabled(
                widget.enableSwipeSelection, widget.navigationMode) &&
            (widget.selectionMode == DateRangePickerSelectionMode.range ||
                widget.selectionMode ==
                    DateRangePickerSelectionMode.multiRange ||
                widget.selectionMode ==
                    DateRangePickerSelectionMode.extendableRange));
    showNavigationArrow = showNavigationArrow &&
        widget.navigationMode != DateRangePickerNavigationMode.scroll;
    if (showNavigationArrow) {
      arrowWidth = widget.width / 6;
      arrowWidth = arrowWidth > 50 ? 50 : arrowWidth;
      headerWidth = widget.width - (arrowWidth * 2);
    }

    Color arrowColor = widget.datePickerTheme.headerTextStyle!.color!;
    arrowColor = arrowColor.withOpacity(arrowColor.opacity * 0.6);
    Color prevArrowColor = arrowColor;
    Color nextArrowColor = arrowColor;
    final List<dynamic> dates = widget.visibleDates.value;
    if (showNavigationArrow &&
        !DateRangePickerHelper.canMoveToNextView(
            widget.view,
            widget.numberOfWeeksInView,
            widget.maxDate,
            dates,
            widget.enableMultiView,
            widget.isHijri)) {
      nextArrowColor = nextArrowColor.withOpacity(arrowColor.opacity * 0.5);
    }

    if (showNavigationArrow &&
        !DateRangePickerHelper.canMoveToPreviousView(
            widget.view,
            widget.numberOfWeeksInView,
            widget.minDate,
            dates,
            widget.enableMultiView,
            widget.isHijri)) {
      prevArrowColor = prevArrowColor.withOpacity(arrowColor.opacity * 0.5);
    }

    final Widget headerText = _getHeaderText(headerWidth, isMobilePlatform);
    if (widget.navigationMode == DateRangePickerNavigationMode.scroll &&
        widget.navigationDirection ==
            DateRangePickerNavigationDirection.horizontal) {
      return headerText;
    }

    double arrowSize = widget.height * 0.5;
    arrowSize = arrowSize > 25 ? 25 : arrowSize;
    arrowSize = arrowSize * widget.textScaleFactor;
    final Container leftArrow = showNavigationArrow
        ? _getLeftArrow(arrowWidth, arrowColor, prevArrowColor, arrowSize)
        : Container();

    final Container rightArrow = showNavigationArrow
        ? _getRightArrow(arrowWidth, arrowColor, nextArrowColor, arrowSize)
        : Container();

    if (widget.headerStyle.textAlign == TextAlign.left ||
        widget.headerStyle.textAlign == TextAlign.start) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            headerText,
            leftArrow,
            rightArrow,
          ]);
    } else if (widget.headerStyle.textAlign == TextAlign.right ||
        widget.headerStyle.textAlign == TextAlign.end) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            leftArrow,
            rightArrow,
            headerText,
          ]);
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            leftArrow,
            headerText,
            rightArrow,
          ]);
    }
  }

  @override
  void dispose() {
    widget.visibleDates.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (!mounted) {
      return;
    }

    if (widget.showNavigationArrow ||
        ((widget.view == DateRangePickerView.month ||
                !widget.allowViewNavigation) &&
            _isSwipeInteractionEnabled(
                widget.enableSwipeSelection, widget.navigationMode) &&
            (widget.selectionMode == DateRangePickerSelectionMode.range ||
                widget.selectionMode ==
                    DateRangePickerSelectionMode.multiRange ||
                widget.selectionMode ==
                    DateRangePickerSelectionMode.extendableRange))) {
      setState(() {
        /*Updates the header when visible dates changes */
      });
    }
  }

  void _addListener() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.visibleDates.addListener(_listener);
    });
  }

  Widget _getHeaderText(double headerWidth, bool isMobilePlatform) {
    return MouseRegion(
        onEnter: (PointerEnterEvent event) {
          if (widget.view == DateRangePickerView.century ||
              (widget.isHijri && widget.view == DateRangePickerView.decade) ||
              isMobilePlatform) {
            return;
          }

          setState(() {
            _hovering = true;
          });
        },
        onHover: (PointerHoverEvent event) {
          if (widget.view == DateRangePickerView.century ||
              (widget.isHijri && widget.view == DateRangePickerView.decade) ||
              isMobilePlatform) {
            return;
          }

          setState(() {
            _hovering = true;
          });
        },
        onExit: (PointerExitEvent event) {
          setState(() {
            _hovering = false;
          });
        },
        child: RepaintBoundary(
            child: CustomPaint(
          // Returns the header view  as a child for the picker.
          painter: _PickerHeaderPainter(
              widget.visibleDates,
              widget.headerStyle,
              widget.view,
              widget.numberOfWeeksInView,
              widget.monthFormat,
              widget.datePickerTheme,
              widget.isRtl,
              widget.locale,
              widget.enableMultiView,
              widget.multiViewSpacing,
              widget.hoverColor,
              _hovering,
              widget.textScaleFactor,
              widget.isHijri,
              widget.localizations,
              widget.navigationDirection),
          size: Size(headerWidth, widget.height),
        )));
  }

  Container _getLeftArrow(double arrowWidth, Color arrowColor,
      Color prevArrowColor, double arrowSize) {
    return Container(
      alignment: Alignment.center,
      color: widget.headerStyle.backgroundColor ??
          widget.datePickerTheme.headerBackgroundColor,
      width: arrowWidth,
      padding: EdgeInsets.zero,
      child: MaterialButton(
        //// set splash color as transparent when arrow reaches min date(disabled)
        splashColor: prevArrowColor != arrowColor ? Colors.transparent : null,
        hoverColor: prevArrowColor != arrowColor ? Colors.transparent : null,
        highlightColor:
            prevArrowColor != arrowColor ? Colors.transparent : null,
        color: widget.headerStyle.backgroundColor ??
            widget.datePickerTheme.headerBackgroundColor,
        onPressed: widget.previousNavigationCallback,
        padding: EdgeInsets.zero,
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        hoverElevation: 0,
        child: Semantics(
          label: 'Backward',
          child: Icon(
            widget.navigationDirection ==
                    DateRangePickerNavigationDirection.horizontal
                ? Icons.chevron_left
                : Icons.keyboard_arrow_up,
            color: prevArrowColor,
            size: arrowSize,
          ),
        ),
      ),
    );
  }

  Container _getRightArrow(double arrowWidth, Color arrowColor,
      Color nextArrowColor, double arrowSize) {
    return Container(
      alignment: Alignment.center,
      color: widget.headerStyle.backgroundColor ??
          widget.datePickerTheme.headerBackgroundColor,
      width: arrowWidth,
      padding: EdgeInsets.zero,
      child: MaterialButton(
        //// set splash color as transparent when arrow reaches max date(disabled)
        splashColor: nextArrowColor != arrowColor ? Colors.transparent : null,
        hoverColor: nextArrowColor != arrowColor ? Colors.transparent : null,
        highlightColor:
            nextArrowColor != arrowColor ? Colors.transparent : null,
        color: widget.headerStyle.backgroundColor ??
            widget.datePickerTheme.headerBackgroundColor,
        onPressed: widget.nextNavigationCallback,
        padding: EdgeInsets.zero,
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        hoverElevation: 0,
        child: Semantics(
          label: 'Forward',
          child: Icon(
            widget.navigationDirection ==
                    DateRangePickerNavigationDirection.horizontal
                ? Icons.chevron_right
                : Icons.keyboard_arrow_down,
            color: nextArrowColor,
            size: arrowSize,
          ),
        ),
      ),
    );
  }
}

class _PickerHeaderPainter extends CustomPainter {
  _PickerHeaderPainter(
      this.visibleDates,
      this.headerStyle,
      this.view,
      this.numberOfWeeksInView,
      this.monthFormat,
      this.datePickerTheme,
      this.isRtl,
      this.locale,
      this.enableMultiView,
      this.multiViewSpacing,
      this.hoverColor,
      this.hovering,
      this.textScaleFactor,
      this.isHijri,
      this.localizations,
      this.navigationDirection)
      : super(repaint: visibleDates);

  final DateRangePickerHeaderStyle headerStyle;
  final DateRangePickerView view;
  final int numberOfWeeksInView;
  final SfDateRangePickerThemeData datePickerTheme;
  final bool isRtl;
  final String? monthFormat;
  final bool hovering;
  final bool enableMultiView;
  final double multiViewSpacing;
  final Color hoverColor;
  final Locale locale;
  final double textScaleFactor;
  final bool isHijri;
  final SfLocalizations localizations;
  final DateRangePickerNavigationDirection navigationDirection;
  ValueNotifier<List<dynamic>> visibleDates;
  String _headerText = '';
  final TextPainter _textPainter = TextPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    double xPosition = 0;
    _textPainter.textDirection = TextDirection.ltr;
    _textPainter.textWidthBasis = TextWidthBasis.longestLine;
    _textPainter.textScaler = TextScaler.linear(textScaleFactor);
    _textPainter.maxLines = 1;

    _headerText = '';
    final double width = (enableMultiView &&
                navigationDirection ==
                    DateRangePickerNavigationDirection.horizontal) &&
            headerStyle.textAlign == TextAlign.center
        ? (size.width - multiViewSpacing) / 2
        : size.width;
    final int count = (enableMultiView &&
                navigationDirection ==
                    DateRangePickerNavigationDirection.horizontal) &&
            headerStyle.textAlign == TextAlign.center
        ? 2
        : 1;
    for (int j = 0; j < count; j++) {
      final int currentViewIndex =
          isRtl ? DateRangePickerHelper.getRtlIndex(count, j) : j;
      xPosition = (currentViewIndex * width) + 10;

      final String text = _getHeaderText(
          visibleDates.value,
          view,
          j,
          isHijri,
          numberOfWeeksInView,
          monthFormat,
          enableMultiView,
          headerStyle,
          navigationDirection,
          locale,
          localizations);
      _headerText += j == 1 ? ' $text' : text;
      TextStyle? style = datePickerTheme.headerTextStyle;
      if (hovering) {
        style = style!.copyWith(color: hoverColor);
      }

      final TextSpan span = TextSpan(text: text, style: style);
      _textPainter.text = span;

      if (headerStyle.textAlign == TextAlign.justify) {
        _textPainter.textAlign = headerStyle.textAlign;
      }

      double textWidth = ((currentViewIndex + 1) * width) - xPosition;
      textWidth = textWidth > 0 ? textWidth : 0;
      _textPainter.layout(maxWidth: textWidth);

      if (headerStyle.textAlign == TextAlign.center) {
        xPosition = (currentViewIndex * width) +
            (currentViewIndex * multiViewSpacing) +
            (width / 2) -
            (_textPainter.width / 2);
      } else if ((!isRtl &&
              (headerStyle.textAlign == TextAlign.right ||
                  headerStyle.textAlign == TextAlign.end)) ||
          (isRtl &&
              (headerStyle.textAlign == TextAlign.left ||
                  headerStyle.textAlign == TextAlign.start))) {
        xPosition =
            ((currentViewIndex + 1) * width) - _textPainter.width - xPosition;
      }
      _textPainter.paint(
          canvas, Offset(xPosition, size.height / 2 - _textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(_PickerHeaderPainter oldDelegate) {
    return oldDelegate.headerStyle != headerStyle ||
        oldDelegate.isRtl != isRtl ||
        oldDelegate.numberOfWeeksInView != numberOfWeeksInView ||
        oldDelegate.locale != locale ||
        oldDelegate.datePickerTheme != datePickerTheme ||
        oldDelegate.monthFormat != monthFormat ||
        oldDelegate.textScaleFactor != textScaleFactor ||
        oldDelegate.hovering != hovering ||
        oldDelegate.hoverColor != hoverColor;
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      final Rect rect = Offset.zero & size;
      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: rect,
          properties: SemanticsProperties(
            label: _headerText.replaceAll('-', 'to'),
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return true;
  }
}

/// Holds the view header cells of the date range picker.
class _PickerViewHeaderPainter extends CustomPainter {
  /// Constructor to create picker view header view instance.
  _PickerViewHeaderPainter(
      this.visibleDates,
      this.navigationMode,
      this.viewHeaderStyle,
      this.viewHeaderHeight,
      this.monthViewSettings,
      this.datePickerTheme,
      this.locale,
      this.isRtl,
      this.monthCellStyle,
      this.enableMultiView,
      this.multiViewSpacing,
      this.todayHighlightColor,
      this.textScaleFactor,
      this.isHijri,
      this.navigationDirection,
      this.viewHeaderVisibleDates,
      this.showWeekNumber,
      this.isMobilePlatform)
      : super(repaint: viewHeaderVisibleDates);

  /// Defines the view header style.
  final DateRangePickerViewHeaderStyle viewHeaderStyle;

  /// Defines the month view settings.
  final dynamic monthViewSettings;

  /// Defines the navigation mode of picker.
  final DateRangePickerNavigationMode navigationMode;

  /// Holds the visible dates for the month view.
  List<dynamic> visibleDates;

  /// Defines the height of the view header height.
  final double viewHeaderHeight;

  /// Defines the month cell style.
  final dynamic monthCellStyle;

  /// Defines the locale details of date range picker.
  final Locale locale;

  /// Used to identify the widget direction is RTL.
  final bool isRtl;

  /// Defines the today cell highlight color.
  final Color? todayHighlightColor;

  /// Decides to show the multi view of picker or not.
  final bool enableMultiView;

  /// Specifies the space between the multi month views.
  final double multiViewSpacing;

  /// Holds the theme data for date range picker.
  final SfDateRangePickerThemeData datePickerTheme;

  /// Specifies the picker type for [SfDateRangePicker].
  final bool isHijri;

  /// Defines the text scale factor of [SfDateRangePicker].
  final double textScaleFactor;

  /// Defines the navigation direction for [SfDateRangePicker].
  final DateRangePickerNavigationDirection navigationDirection;
  final TextPainter _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      textWidthBasis: TextWidthBasis.longestLine);

  final ValueNotifier<List<dynamic>>? viewHeaderVisibleDates;

  /// Defines the week number of year for [SfDateRangePicker].
  final bool showWeekNumber;

  /// Defines the current platform is mobile platform or not.
  final bool isMobilePlatform;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final double weekNumberPanelWidth =
        DateRangePickerHelper.getWeekNumberPanelWidth(
            showWeekNumber, size.width, isMobilePlatform);
    double width = showWeekNumber
        ? (size.width - weekNumberPanelWidth) / DateTime.daysPerWeek
        : size.width / DateTime.daysPerWeek;
    if (enableMultiView &&
        navigationDirection == DateRangePickerNavigationDirection.horizontal) {
      width = showWeekNumber
          ? (size.width - multiViewSpacing - (weekNumberPanelWidth * 2)) /
              (DateTime.daysPerWeek * 2)
          : (size.width - multiViewSpacing) / (DateTime.daysPerWeek * 2);
    }

    /// Initializes the default text style for the texts in view header of
    /// picker.
    final TextStyle? viewHeaderDayStyle = datePickerTheme.viewHeaderTextStyle;
    final dynamic today = DateRangePickerHelper.getToday(isHijri);
    TextStyle? dayTextStyle = viewHeaderDayStyle;
    double xPosition = isRtl ? 0 : weekNumberPanelWidth;
    double yPosition = 0;
    final int count = (enableMultiView &&
            navigationDirection ==
                DateRangePickerNavigationDirection.horizontal)
        ? 2
        : 1;
    final int datesCount = (enableMultiView &&
            navigationDirection ==
                DateRangePickerNavigationDirection.horizontal)
        ? visibleDates.length ~/ 2
        : visibleDates.length;
    final bool isVerticalScroll =
        navigationDirection == DateRangePickerNavigationDirection.vertical &&
            navigationMode == DateRangePickerNavigationMode.scroll;
    visibleDates = viewHeaderVisibleDates != null
        ? viewHeaderVisibleDates!.value
        : visibleDates;

    for (int j = 0; j < count; j++) {
      final int currentViewIndex =
          isRtl ? DateRangePickerHelper.getRtlIndex(count, j) : j;
      dynamic currentDate;
      final int month =
          visibleDates[(currentViewIndex * datesCount) + (datesCount ~/ 2)]
              .month as int;
      final int year =
          visibleDates[(currentViewIndex * datesCount) + (datesCount ~/ 2)].year
              as int;
      final int currentMonth = today.month as int;
      final int currentYear = today.year as int;

      final int numberOfWeeksInView =
          DateRangePickerHelper.getNumberOfWeeksInView(
              monthViewSettings, isHijri);
      final bool isTodayMonth = isDateWithInDateRange(
          visibleDates[(currentViewIndex * datesCount)],
          visibleDates[((currentViewIndex + 1) * datesCount) - 1],
          today);
      final bool hasToday = isVerticalScroll ||
          (numberOfWeeksInView > 0 && numberOfWeeksInView < 6 ||
              month == currentMonth && year == currentYear);
      for (int i = 0; i < DateTime.daysPerWeek; i++) {
        int index = isRtl
            ? DateRangePickerHelper.getRtlIndex(DateTime.daysPerWeek, i)
            : i;
        index = index + (currentViewIndex * datesCount);
        currentDate = visibleDates[index];
        String dayText =
            DateFormat(monthViewSettings.dayFormat, locale.toString())
                .format(isHijri ? currentDate.toDateTime() : currentDate)
                .toUpperCase();
        dayText = _updateViewHeaderFormat(dayText);

        if (hasToday &&
            currentDate.weekday == today.weekday &&
            (isTodayMonth || isVerticalScroll)) {
          final Color textColor = monthCellStyle.todayTextStyle != null &&
                  monthCellStyle.todayTextStyle.color != null
              ? monthCellStyle.todayTextStyle.color! as Color
              : todayHighlightColor ?? datePickerTheme.todayHighlightColor!;
          dayTextStyle = viewHeaderDayStyle!.copyWith(color: textColor);
        } else {
          dayTextStyle = viewHeaderDayStyle;
        }

        final TextSpan dayTextSpan = TextSpan(
          text: dayText,
          style: dayTextStyle,
        );

        _textPainter.textScaler = TextScaler.linear(textScaleFactor);
        _textPainter.text = dayTextSpan;
        _textPainter.layout(maxWidth: width);
        yPosition = (viewHeaderHeight - _textPainter.height) / 2;
        _textPainter.paint(
            canvas,
            Offset(
                xPosition + (width / 2 - _textPainter.width / 2), yPosition));
        xPosition += width;
      }

      xPosition += multiViewSpacing + weekNumberPanelWidth;
    }
  }

  String _updateViewHeaderFormat(String dayText) {
    //// EE format value shows the week days as S, M, T, W, T, F, S.
    /// For other languages showing the first letter of the weekday turns into
    /// wrong meaning, hence we have shown the first letter of weekday when the
    /// date format set as default and the locale set as English.
    ///
    /// Eg: In chinese the first letter or `Sunday` represents `Weekday`, hence
    /// to avoid this added this condition based on locale.
    if (monthViewSettings.dayFormat == 'EE' && locale.languageCode == 'en') {
      dayText = dayText[0];
    }

    return dayText;
  }

  @override
  bool shouldRepaint(_PickerViewHeaderPainter oldDelegate) {
    return oldDelegate.visibleDates != visibleDates ||
        oldDelegate.viewHeaderStyle != viewHeaderStyle ||
        oldDelegate.viewHeaderHeight != viewHeaderHeight ||
        oldDelegate.todayHighlightColor != todayHighlightColor ||
        oldDelegate.monthViewSettings != monthViewSettings ||
        oldDelegate.datePickerTheme != datePickerTheme ||
        oldDelegate.isRtl != isRtl ||
        oldDelegate.locale != locale ||
        oldDelegate.textScaleFactor != textScaleFactor ||
        oldDelegate.isHijri != isHijri ||
        oldDelegate.showWeekNumber != showWeekNumber;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    double left, cellWidth;
    cellWidth = size.width / DateTime.daysPerWeek;
    int count = 1;
    int datesCount = visibleDates.length;
    if (enableMultiView &&
        navigationDirection == DateRangePickerNavigationDirection.horizontal) {
      cellWidth = (size.width - multiViewSpacing) / 14;
      count = 2;
      datesCount = visibleDates.length ~/ 2;
    }

    left = isRtl ? size.width - cellWidth : 0;
    const double top = 0;
    for (int j = 0; j < count; j++) {
      for (int i = 0; i < DateTime.daysPerWeek; i++) {
        semanticsBuilder.add(CustomPainterSemantics(
          rect: Rect.fromLTWH(left, top, cellWidth, size.height),
          properties: SemanticsProperties(
            label: DateFormat('EEEEE')
                .format(isHijri
                    ? visibleDates[(j * datesCount) + i].toDateTime()
                    : visibleDates[(j * datesCount) + i])
                .toUpperCase(),
            textDirection: TextDirection.ltr,
          ),
        ));
        if (isRtl) {
          left -= cellWidth;
        } else {
          left += cellWidth;
        }
      }

      if (isRtl) {
        left -= multiViewSpacing;
      } else {
        left += multiViewSpacing;
      }
    }

    return semanticsBuilder;
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilder(size);
    };
  }

  @override
  bool shouldRebuildSemantics(_PickerViewHeaderPainter oldDelegate) {
    return oldDelegate.visibleDates != visibleDates;
  }
}

/// Holds the picker views and handles the scrolling or swiping
/// related operations.
@immutable
class _PickerScrollView extends StatefulWidget {
  /// Constructor to create the picker scroll view instance.
  const _PickerScrollView(
    this.picker,
    this.controller,
    this.width,
    this.height,
    this.isRtl,
    this.datePickerTheme,
    this.locale,
    this.textScaleFactor, {
    Key? key,
    required this.getPickerStateValues,
    required this.updatePickerStateValues,
  }) : super(key: key);

  /// Holds the picker instance to access the picker details.
  final _SfDateRangePicker picker;

  /// Holds the picker scroll view width.
  final double width;

  /// Holds the picker scroll view height.
  final double height;

  /// Used to identify the widget direction is RTL.
  final bool isRtl;

  /// Used to get the picker values from date picker state.
  final UpdatePickerState getPickerStateValues;

  /// Used to update the picker values to date picker state.
  final UpdatePickerState updatePickerStateValues;

  /// Holds the controller details used on its state
  final dynamic controller;

  /// Holds the theme data for date range picker.
  final SfDateRangePickerThemeData datePickerTheme;

  /// Holds the picker locale.
  final Locale locale;

  /// Defines the text scale factor of [SfDateRangePicker].
  final double textScaleFactor;

  @override
  _PickerScrollViewState createState() => _PickerScrollViewState();
}

/// Handle the picker scroll view children position and it interaction.
class _PickerScrollViewState extends State<_PickerScrollView>
    with TickerProviderStateMixin {
  // three views to arrange the view in vertical/horizontal direction and handle the swiping
  _PickerView? _currentView, _nextView, _previousView;

  // the three children which to be added into the layout
  final List<_PickerView> _children = <_PickerView>[];

  Map<List<dynamic>, List<dynamic>>? _disabledDates;

  // holds the index of the current displaying view
  int _currentChildIndex = 1;

  // _scrollStartPosition contains the touch movement starting position
  // ignore: use_late_for_private_fields_and_variables
  double? _scrollStartPosition;

  // _position contains distance that the view swiped
  double _position = 0;

  // animation controller to control the animation
  late AnimationController _animationController;

  // animation handled for the view swiping
  late Animation<double> _animation;

  // tween animation to handle the animation
  late Tween<double> _tween;

  // three visible dates for the three views, the dates will updated based on
  // the swiping in the swipe end _currentViewVisibleDates which stores the
  // visible dates of the current displaying view
  late List<dynamic> _visibleDates,
      _previousViewVisibleDates,
      _nextViewVisibleDates,
      _currentViewVisibleDates;

  /// keys maintained to access the data and methods from the picker view
  /// class.
  final GlobalKey<_PickerViewState> _previousViewKey =
          GlobalKey<_PickerViewState>(),
      _currentViewKey = GlobalKey<_PickerViewState>(),
      _nextViewKey = GlobalKey<_PickerViewState>();

  final PickerStateArgs _pickerStateDetails = PickerStateArgs();
  final FocusScopeNode _focusNode = FocusScopeNode();

  @override
  void initState() {
    _updateVisibleDates();
    _triggerSelectableDayPredicates(_currentViewVisibleDates);
    _triggerViewChangedCallback();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    _tween = Tween<double>(begin: 0.0, end: 0.1);
    _animation = _tween.animate(_animationController)
      ..addListener(_animationListener);

    super.initState();
  }

  @override
  void didUpdateWidget(_PickerScrollView oldWidget) {
    if (widget.picker.navigationDirection !=
            oldWidget.picker.navigationDirection ||
        widget.width != oldWidget.width ||
        widget.picker.cellBuilder != oldWidget.picker.cellBuilder ||
        oldWidget.datePickerTheme != widget.datePickerTheme ||
        widget.picker.viewSpacing != oldWidget.picker.viewSpacing ||
        widget.picker.selectionMode != oldWidget.picker.selectionMode ||
        widget.height != oldWidget.height ||
        widget.picker.extendableRangeSelectionDirection !=
            oldWidget.picker.extendableRangeSelectionDirection) {
      _position = 0;
      _children.clear();
    }

    if (oldWidget.textScaleFactor != widget.textScaleFactor ||
        oldWidget.picker.isHijri != widget.picker.isHijri) {
      _position = 0;
      _children.clear();
    }

    if (widget.isRtl != oldWidget.isRtl ||
        widget.picker.enableMultiView != oldWidget.picker.enableMultiView) {
      _position = 0;
      _children.clear();
      _updateVisibleDates();
      _triggerSelectableDayPredicates(_currentViewVisibleDates);
      _triggerViewChangedCallback();
    }

    _updateSettings(oldWidget);

    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);

    if (pickerView == DateRangePickerView.year &&
        widget.picker.monthFormat != oldWidget.picker.monthFormat) {
      _position = 0;
      _children.clear();
    }

    if (pickerView != DateRangePickerView.month &&
        widget.picker.yearCellStyle != oldWidget.picker.yearCellStyle) {
      _position = 0;
      _children.clear();
    }

    if (widget.picker.minDate != oldWidget.picker.minDate ||
        widget.picker.maxDate != oldWidget.picker.maxDate) {
      final dynamic previousVisibleDate = _pickerStateDetails.currentDate;
      widget.getPickerStateValues(_pickerStateDetails);
      if (!isSameDate(_pickerStateDetails.currentDate, previousVisibleDate)) {
        _updateVisibleDates();
        _triggerViewChangedCallback();
      }

      _position = 0;
      _children.clear();
    }

    if (widget.picker.enablePastDates != oldWidget.picker.enablePastDates) {
      _position = 0;
      _children.clear();
    }

    if (pickerView == DateRangePickerView.month &&
        (oldWidget.picker.monthViewSettings.viewHeaderStyle !=
                widget.picker.monthViewSettings.viewHeaderStyle ||
            oldWidget.picker.monthViewSettings.viewHeaderHeight !=
                widget.picker.monthViewSettings.viewHeaderHeight ||
            DateRangePickerHelper.canShowLeadingAndTrailingDates(
                    widget.picker.monthViewSettings, widget.picker.isHijri) !=
                DateRangePickerHelper.canShowLeadingAndTrailingDates(
                    oldWidget.picker.monthViewSettings,
                    oldWidget.picker.isHijri))) {
      _children.clear();
      _position = 0;

      if (DateRangePickerHelper.canShowLeadingAndTrailingDates(
              widget.picker.monthViewSettings, widget.picker.isHijri) !=
          DateRangePickerHelper.canShowLeadingAndTrailingDates(
              oldWidget.picker.monthViewSettings, oldWidget.picker.isHijri)) {
        _disabledDates?.clear();
        _triggerSelectableDayPredicates(_currentViewVisibleDates);
      }
    }

    if (DateRangePickerHelper.getNumberOfWeeksInView(
                widget.picker.monthViewSettings, widget.picker.isHijri) !=
            DateRangePickerHelper.getNumberOfWeeksInView(
                oldWidget.picker.monthViewSettings, oldWidget.picker.isHijri) ||
        widget.picker.monthViewSettings.firstDayOfWeek !=
            oldWidget.picker.monthViewSettings.firstDayOfWeek) {
      _updateVisibleDates();
      _position = 0;
      _triggerSelectableDayPredicates(_currentViewVisibleDates);
      _triggerViewChangedCallback();
    }

    /// Update the selection when [allowViewNavigation] property in
    /// [SfDateRangePicker] changed with current picker view not as month view.
    /// because year, decade and century views highlight selection when
    /// [allowViewNavigation] property value as false.
    if (oldWidget.picker.allowViewNavigation !=
            widget.picker.allowViewNavigation &&
        pickerView != DateRangePickerView.month) {
      _position = 0;
      _children.clear();
      _triggerSelectableDayPredicates(_currentViewVisibleDates);
    }

    if (!isSameDate(
        _pickerStateDetails.currentDate, widget.controller.displayDate)) {
      _pickerStateDetails.currentDate = widget.controller?.displayDate;
      _updateVisibleDates();
      _triggerSelectableDayPredicates(_currentViewVisibleDates);
      _triggerViewChangedCallback();
    }

    if (_pickerStateDetails.view != pickerView) {
      _position = 0;
      _children.clear();
      _updateVisibleDates();
      _triggerViewChangedCallback();
    }

    _drawSelection(oldWidget.controller, widget.controller, pickerView);
    widget.getPickerStateValues(_pickerStateDetails);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double leftPosition = 0,
        rightPosition = 0,
        topPosition = 0,
        bottomPosition = 0;
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        {
          leftPosition = -widget.width;
          rightPosition = -widget.width;
        }
        break;
      case DateRangePickerNavigationDirection.vertical:
        {
          topPosition = -widget.height;
          bottomPosition = -widget.height;
        }
    }

    return Stack(
      children: <Widget>[
        Positioned(
          left: leftPosition,
          right: rightPosition,
          bottom: bottomPosition,
          top: topPosition,
          child: GestureDetector(
            onHorizontalDragStart: widget.picker.navigationDirection ==
                        DateRangePickerNavigationDirection.horizontal &&
                    widget.picker.navigationMode !=
                        DateRangePickerNavigationMode.none
                ? _onHorizontalStart
                : null,
            onHorizontalDragUpdate: widget.picker.navigationDirection ==
                        DateRangePickerNavigationDirection.horizontal &&
                    widget.picker.navigationMode !=
                        DateRangePickerNavigationMode.none
                ? _onHorizontalUpdate
                : null,
            onHorizontalDragEnd: widget.picker.navigationDirection ==
                        DateRangePickerNavigationDirection.horizontal &&
                    widget.picker.navigationMode !=
                        DateRangePickerNavigationMode.none
                ? _onHorizontalEnd
                : null,
            onVerticalDragStart: widget.picker.navigationDirection ==
                        DateRangePickerNavigationDirection.vertical &&
                    widget.picker.navigationMode !=
                        DateRangePickerNavigationMode.none
                ? _onVerticalStart
                : null,
            onVerticalDragUpdate: widget.picker.navigationDirection ==
                        DateRangePickerNavigationDirection.vertical &&
                    widget.picker.navigationMode !=
                        DateRangePickerNavigationMode.none
                ? _onVerticalUpdate
                : null,
            onVerticalDragEnd: widget.picker.navigationDirection ==
                        DateRangePickerNavigationDirection.vertical &&
                    widget.picker.navigationMode !=
                        DateRangePickerNavigationMode.none
                ? _onVerticalEnd
                : null,
            child: FocusScope(
              node: _focusNode,
              onKeyEvent: _onKeyDown,
              child: CustomScrollViewerLayout(
                  _addViews(context),
                  widget.picker.navigationDirection ==
                          DateRangePickerNavigationDirection.horizontal
                      ? CustomScrollDirection.horizontal
                      : CustomScrollDirection.vertical,
                  _position,
                  _currentChildIndex),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _previousViewVisibleDates.clear();
    _nextViewVisibleDates.clear();
    _currentViewVisibleDates.clear();
    _animationController.dispose();
    _animation.removeListener(_animationListener);
    _focusNode.dispose();
    super.dispose();
  }

  void _updateVisibleDates() {
    widget.getPickerStateValues(_pickerStateDetails);
    final int numberOfWeeksInView =
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.picker.monthViewSettings, widget.picker.isHijri);
    final dynamic currentDate = _pickerStateDetails.currentDate;
    final dynamic prevDate = DateRangePickerHelper.getPreviousViewStartDate(
        DateRangePickerHelper.getPickerView(widget.controller.view),
        numberOfWeeksInView,
        _pickerStateDetails.currentDate,
        widget.isRtl,
        widget.picker.isHijri);
    final dynamic nextDate = DateRangePickerHelper.getNextViewStartDate(
        DateRangePickerHelper.getPickerView(widget.controller.view),
        numberOfWeeksInView,
        _pickerStateDetails.currentDate,
        widget.isRtl,
        widget.picker.isHijri);

    dynamic afterNextViewDate;
    List<dynamic>? afterVisibleDates;
    if (widget.picker.enableMultiView) {
      afterNextViewDate = DateRangePickerHelper.getNextViewStartDate(
          DateRangePickerHelper.getPickerView(widget.controller.view),
          numberOfWeeksInView,
          widget.isRtl ? prevDate : nextDate,
          false,
          widget.picker.isHijri);
    }

    final DateRangePickerView view =
        DateRangePickerHelper.getPickerView(widget.controller.view);

    switch (view) {
      case DateRangePickerView.month:
        {
          _visibleDates = getVisibleDates(
            currentDate,
            null,
            widget.picker.monthViewSettings.firstDayOfWeek,
            DateRangePickerHelper.getViewDatesCount(
                view, numberOfWeeksInView, widget.picker.isHijri),
          );
          _previousViewVisibleDates = getVisibleDates(
            prevDate,
            null,
            widget.picker.monthViewSettings.firstDayOfWeek,
            DateRangePickerHelper.getViewDatesCount(
                view, numberOfWeeksInView, widget.picker.isHijri),
          );
          _nextViewVisibleDates = getVisibleDates(
            nextDate,
            null,
            widget.picker.monthViewSettings.firstDayOfWeek,
            DateRangePickerHelper.getViewDatesCount(
                view, numberOfWeeksInView, widget.picker.isHijri),
          );
          if (widget.picker.enableMultiView) {
            afterVisibleDates = getVisibleDates(
              afterNextViewDate,
              null,
              widget.picker.monthViewSettings.firstDayOfWeek,
              DateRangePickerHelper.getViewDatesCount(
                  view, numberOfWeeksInView, widget.picker.isHijri),
            );
          }
        }
        break;
      case DateRangePickerView.decade:
      case DateRangePickerView.year:
      case DateRangePickerView.century:
        {
          _visibleDates = DateRangePickerHelper.getVisibleYearDates(
              currentDate, view, widget.picker.isHijri);
          _previousViewVisibleDates = DateRangePickerHelper.getVisibleYearDates(
              prevDate, view, widget.picker.isHijri);
          _nextViewVisibleDates = DateRangePickerHelper.getVisibleYearDates(
              nextDate, view, widget.picker.isHijri);
          if (widget.picker.enableMultiView) {
            afterVisibleDates = DateRangePickerHelper.getVisibleYearDates(
                afterNextViewDate, view, widget.picker.isHijri);
          }
        }
    }

    if (widget.picker.enableMultiView) {
      _updateVisibleDatesForMultiView(afterVisibleDates!);
    }

    _currentViewVisibleDates = _visibleDates;
    _pickerStateDetails.currentViewVisibleDates = _currentViewVisibleDates;

    if (_currentChildIndex == 0) {
      _visibleDates = _nextViewVisibleDates;
      _nextViewVisibleDates = _previousViewVisibleDates;
      _previousViewVisibleDates = _currentViewVisibleDates;
    } else if (_currentChildIndex == 1) {
      _visibleDates = _currentViewVisibleDates;
    } else if (_currentChildIndex == 2) {
      _visibleDates = _previousViewVisibleDates;
      _previousViewVisibleDates = _nextViewVisibleDates;
      _nextViewVisibleDates = _currentViewVisibleDates;
    }
  }

  /// Triggered the view changed callback with the current view visible dates.
  void _triggerViewChangedCallback() {
    _pickerStateDetails.currentViewVisibleDates = _currentViewVisibleDates;
    widget.updatePickerStateValues(_pickerStateDetails);
  }

  void _moveToNextViewWithAnimation() {
    // Resets the controller to forward it again, the animation will forward
    // only from the dismissed state
    if (_animationController.isCompleted || _animationController.isDismissed) {
      _animationController.reset();
    } else {
      return;
    }

    _updateSelection();
    if (widget.picker.navigationDirection ==
        DateRangePickerNavigationDirection.vertical) {
      // update the bottom to top swiping
      _tween.begin = 0;
      _tween.end = -widget.height;
    } else {
      // update the right to left swiping
      _tween.begin = 0;
      _tween.end = -widget.width;
    }

    /// returns the disable dates collection when right to left swiping
    _triggerSelectableDayPredicates(_getCurrentVisibleDates(true));

    _animationController.duration = const Duration(milliseconds: 500);
    _animationController
        .forward()
        .then<dynamic>((dynamic value) => _updateNextView());

    /// updates the current view visible dates when the view swiped
    _updateCurrentViewVisibleDates(isNextView: true);
  }

  void _moveToPreviousViewWithAnimation() {
    // Resets the controller to backward it again, the animation will backward
    // only from the dismissed state
    if (_animationController.isCompleted || _animationController.isDismissed) {
      _animationController.reset();
    } else {
      return;
    }

    _updateSelection();
    if (widget.picker.navigationDirection ==
        DateRangePickerNavigationDirection.vertical) {
      // update the top to bottom swiping
      _tween.begin = 0;
      _tween.end = widget.height;
    } else {
      // update the left to right swiping
      _tween.begin = 0;
      _tween.end = widget.width;
    }

    /// returns the disable dates collection when left to right swiping
    _triggerSelectableDayPredicates(_getCurrentVisibleDates(false));

    _animationController.duration = const Duration(milliseconds: 500);
    _animationController
        .forward()
        .then<dynamic>((dynamic value) => _updatePreviousView());

    /// updates the current view visible dates when the view swiped.
    _updateCurrentViewVisibleDates();
  }

  void _updateVisibleDatesForMultiView(List<dynamic> afterVisibleDates) {
    if (widget.isRtl) {
      for (int i = 0; i < _visibleDates.length; i++) {
        _nextViewVisibleDates.add(_visibleDates[i]);
      }
      for (int i = 0; i < _previousViewVisibleDates.length; i++) {
        _visibleDates.add(_previousViewVisibleDates[i]);
      }
      for (int i = 0; i < afterVisibleDates.length; i++) {
        _previousViewVisibleDates.add(afterVisibleDates[i]);
      }
    } else {
      for (int i = 0; i < _visibleDates.length; i++) {
        _previousViewVisibleDates.add(_visibleDates[i]);
      }
      for (int i = 0; i < _nextViewVisibleDates.length; i++) {
        _visibleDates.add(_nextViewVisibleDates[i]);
      }
      for (int i = 0; i < afterVisibleDates.length; i++) {
        _nextViewVisibleDates.add(afterVisibleDates[i]);
      }
    }
  }

  void _updateNextViewVisibleDates() {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    final int numberOfWeeksInView =
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.picker.monthViewSettings, widget.picker.isHijri);
    dynamic currentViewDate = _currentViewVisibleDates[0];
    if ((pickerView == DateRangePickerView.month &&
            (numberOfWeeksInView == 6 || widget.picker.isHijri)) ||
        pickerView == DateRangePickerView.year ||
        pickerView == DateRangePickerView.decade ||
        pickerView == DateRangePickerView.century) {
      currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length /
                  (widget.picker.enableMultiView ? 4 : 2))
              .truncate()];
    }

    final DateRangePickerView view =
        DateRangePickerHelper.getPickerView(widget.controller.view);

    currentViewDate = DateRangePickerHelper.getNextViewStartDate(
        view,
        numberOfWeeksInView,
        currentViewDate,
        widget.isRtl,
        widget.picker.isHijri);
    List<dynamic>? afterVisibleDates;
    dynamic afterNextViewDate;
    if (widget.picker.enableMultiView && !widget.isRtl) {
      afterNextViewDate = DateRangePickerHelper.getNextViewStartDate(
          view,
          numberOfWeeksInView,
          currentViewDate,
          widget.isRtl,
          widget.picker.isHijri);
    }
    List<dynamic> dates;
    switch (view) {
      case DateRangePickerView.month:
        {
          dates = getVisibleDates(
            currentViewDate,
            null,
            widget.picker.monthViewSettings.firstDayOfWeek,
            DateRangePickerHelper.getViewDatesCount(
                view, numberOfWeeksInView, widget.picker.isHijri),
          );
          if (widget.picker.enableMultiView && !widget.isRtl) {
            afterVisibleDates = getVisibleDates(
              afterNextViewDate,
              null,
              widget.picker.monthViewSettings.firstDayOfWeek,
              DateRangePickerHelper.getViewDatesCount(
                  view, numberOfWeeksInView, widget.picker.isHijri),
            );
          }
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          dates = DateRangePickerHelper.getVisibleYearDates(
              currentViewDate, view, widget.picker.isHijri);
          if (widget.picker.enableMultiView && !widget.isRtl) {
            afterVisibleDates = DateRangePickerHelper.getVisibleYearDates(
                afterNextViewDate, view, widget.picker.isHijri);
          }
        }
    }

    if (widget.picker.enableMultiView) {
      dates.addAll(_updateNextVisibleDateForMultiView(afterVisibleDates));
    }

    if (_currentChildIndex == 0) {
      _nextViewVisibleDates = dates;
    } else if (_currentChildIndex == 1) {
      _previousViewVisibleDates = dates;
    } else {
      _visibleDates = dates;
    }
  }

  List<dynamic> _updateNextVisibleDateForMultiView(
      List<dynamic>? afterVisibleDates) {
    List<dynamic> dates;
    if (widget.picker.isHijri) {
      dates = <HijriDateTime>[];
    } else {
      dates = <DateTime>[];
    }
    if (!widget.isRtl) {
      for (int i = 0; i < afterVisibleDates!.length; i++) {
        dates.add(afterVisibleDates[i]);
      }
    } else {
      for (int i = 0; i < _currentViewVisibleDates.length ~/ 2; i++) {
        dates.add(_currentViewVisibleDates[i]);
      }
    }

    return dates;
  }

  void _updatePreviousViewVisibleDates() {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    final int numberOfWeeksInView =
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.picker.monthViewSettings, widget.picker.isHijri);
    dynamic currentViewDate = _currentViewVisibleDates[0];
    if ((pickerView == DateRangePickerView.month &&
            (numberOfWeeksInView == 6 || widget.picker.isHijri)) ||
        pickerView == DateRangePickerView.year ||
        pickerView == DateRangePickerView.decade ||
        pickerView == DateRangePickerView.century) {
      currentViewDate = _currentViewVisibleDates[
          (_currentViewVisibleDates.length /
                  (widget.picker.enableMultiView ? 4 : 2))
              .truncate()];
    }

    final DateRangePickerView view =
        DateRangePickerHelper.getPickerView(widget.controller.view);

    currentViewDate = DateRangePickerHelper.getPreviousViewStartDate(
        view,
        numberOfWeeksInView,
        currentViewDate,
        widget.isRtl,
        widget.picker.isHijri);
    List<dynamic> dates;
    List<dynamic>? afterVisibleDates;
    dynamic afterNextViewDate;
    if (widget.picker.enableMultiView && widget.isRtl) {
      afterNextViewDate = DateRangePickerHelper.getPreviousViewStartDate(
          view,
          numberOfWeeksInView,
          currentViewDate,
          widget.isRtl,
          widget.picker.isHijri);
    }

    switch (view) {
      case DateRangePickerView.month:
        {
          dates = getVisibleDates(
            currentViewDate,
            null,
            widget.picker.monthViewSettings.firstDayOfWeek,
            DateRangePickerHelper.getViewDatesCount(
                view, numberOfWeeksInView, widget.picker.isHijri),
          );
          if (widget.picker.enableMultiView && widget.isRtl) {
            afterVisibleDates = getVisibleDates(
              afterNextViewDate,
              null,
              widget.picker.monthViewSettings.firstDayOfWeek,
              DateRangePickerHelper.getViewDatesCount(
                  view, numberOfWeeksInView, widget.picker.isHijri),
            );
          }
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          dates = DateRangePickerHelper.getVisibleYearDates(
              currentViewDate, view, widget.picker.isHijri);
          if (widget.picker.enableMultiView && widget.isRtl) {
            afterVisibleDates = DateRangePickerHelper.getVisibleYearDates(
                afterNextViewDate, view, widget.picker.isHijri);
          }
        }
    }

    if (widget.picker.enableMultiView) {
      dates.addAll(_updatePreviousDatesForMultiView(afterVisibleDates));
    }

    if (_currentChildIndex == 0) {
      _visibleDates = dates;
    } else if (_currentChildIndex == 1) {
      _nextViewVisibleDates = dates;
    } else {
      _previousViewVisibleDates = dates;
    }
  }

  List<dynamic> _updatePreviousDatesForMultiView(
      List<dynamic>? afterVisibleDates) {
    List<dynamic> dates;
    if (widget.picker.isHijri) {
      dates = <HijriDateTime>[];
    } else {
      dates = <DateTime>[];
    }
    if (widget.isRtl) {
      for (int i = 0; i < (afterVisibleDates!.length); i++) {
        dates.add(afterVisibleDates[i]);
      }
    } else {
      for (int i = 0; i < (_currentViewVisibleDates.length / 2); i++) {
        dates.add(_currentViewVisibleDates[i]);
      }
    }
    return dates;
  }

  void _getPickerViewStateDetails(PickerStateArgs details) {
    details.currentViewVisibleDates = _currentViewVisibleDates;
    details.currentDate = _pickerStateDetails.currentDate;
    details.selectedDate = _pickerStateDetails.selectedDate;
    details.selectedDates = _pickerStateDetails.selectedDates;
    details.selectedRange = _pickerStateDetails.selectedRange;
    details.selectedRanges = _pickerStateDetails.selectedRanges;
    details.view = _pickerStateDetails.view;
  }

  void _updatePickerViewStateDetails(PickerStateArgs details) {
    _pickerStateDetails.currentDate = details.currentDate;
    _pickerStateDetails.selectedDate = details.selectedDate;
    _pickerStateDetails.selectedDates = details.selectedDates;
    _pickerStateDetails.selectedRange = details.selectedRange;
    _pickerStateDetails.selectedRanges = details.selectedRanges;
    _pickerStateDetails.view = details.view;
    widget.updatePickerStateValues(_pickerStateDetails);
  }

  _PickerView _getView(List<dynamic> dates, Key key) {
    return _PickerView(
      widget.picker,
      widget.controller,
      dates,
      _isMultiViewEnabled(widget.picker),
      widget.width,
      widget.height,
      widget.datePickerTheme,
      _focusNode,
      widget.textScaleFactor,
      DateRangePickerHelper.cloneList((_disabledDates != null &&
              _disabledDates?.values != null &&
              _disabledDates!.values.isNotEmpty)
          ? _disabledDates?.values.first
          : null),
      key: key,
      getPickerStateDetails: (PickerStateArgs details) {
        _getPickerViewStateDetails(details);
      },
      updatePickerStateDetails: (PickerStateArgs details) {
        _updatePickerViewStateDetails(details);
      },
      isRtl: widget.isRtl,
    );
  }

  List<Widget> _addViews(BuildContext context) {
    if (_children.isEmpty) {
      _previousView = _getView(_previousViewVisibleDates, _previousViewKey);
      _currentView = _getView(_visibleDates, _currentViewKey);
      _nextView = _getView(_nextViewVisibleDates, _nextViewKey);

      _children.add(_previousView!);
      _children.add(_currentView!);
      _children.add(_nextView!);
      return _children;
    }

    final _PickerView previousView = _updateViews(
        _previousView!, _previousView!.visibleDates, _previousViewVisibleDates);
    final _PickerView currentView =
        _updateViews(_currentView!, _currentView!.visibleDates, _visibleDates);
    final _PickerView nextView = _updateViews(
        _nextView!, _nextView!.visibleDates, _nextViewVisibleDates);

    /// Update views while the all day view height differ from original height,
    /// else repaint the appointment painter while current child visible
    /// appointment not equals picker visible appointment
    if (_previousView != previousView) {
      _previousView = previousView;
    }
    if (_currentView != currentView) {
      _currentView = currentView;
    }
    if (_nextView != nextView) {
      _nextView = nextView;
    }

    return _children;
  }

  // method to check and update the views and appointments on the swiping end
  _PickerView _updateViews(
      _PickerView view, List<dynamic> viewDates, List<dynamic> visibleDates) {
    final int index = _children.indexOf(view);
    // update the view with the visible dates on swiping end.
    if (viewDates != visibleDates) {
      view = _getView(visibleDates, view.key!);
      _children[index] = view;
    } // check and update the visible appointments in the view
    else if (_disabledDates != null &&
        _disabledDates!.isNotEmpty &&
        _disabledDates?.keys != null &&
        _disabledDates!.keys.isNotEmpty &&
        _disabledDates!.keys.first == viewDates &&
        !DateRangePickerHelper.isDateCollectionEquals(
            view.disableDatePredicates, _disabledDates!.values.first)) {
      view = _getView(viewDates, view.key!);
      _children[index] = view;
    }

    return view;
  }

  void _animationListener() {
    setState(() {
      _position = _animation.value;
    });
  }

  void _updateSettings(_PickerScrollView oldWidget) {
    //// condition to check and update the view when the settings changed, it will check each and every property of settings
    //// to avoid unwanted repainting
    if (oldWidget.picker.monthViewSettings != widget.picker.monthViewSettings ||
        oldWidget.picker.monthCellStyle != widget.picker.monthCellStyle ||
        oldWidget.picker.selectionRadius != widget.picker.selectionRadius ||
        oldWidget.picker.startRangeSelectionColor !=
            widget.picker.startRangeSelectionColor ||
        oldWidget.picker.endRangeSelectionColor !=
            widget.picker.endRangeSelectionColor ||
        oldWidget.picker.rangeSelectionColor !=
            widget.picker.rangeSelectionColor ||
        oldWidget.picker.selectionColor != widget.picker.selectionColor ||
        oldWidget.picker.selectionTextStyle !=
            widget.picker.selectionTextStyle ||
        oldWidget.picker.rangeTextStyle != widget.picker.rangeTextStyle ||
        oldWidget.picker.monthViewSettings.blackoutDates !=
            widget.picker.monthViewSettings.blackoutDates ||
        oldWidget.picker.monthViewSettings.specialDates !=
            widget.picker.monthViewSettings.specialDates ||
        oldWidget.picker.monthViewSettings.weekendDays !=
            widget.picker.monthViewSettings.weekendDays ||
        oldWidget.picker.selectionShape != widget.picker.selectionShape ||
        oldWidget.picker.todayHighlightColor !=
            widget.picker.todayHighlightColor ||
        oldWidget.locale != widget.locale) {
      _children.clear();
      _position = 0;
    }
  }

  void _drawSelection(
      dynamic oldValue, dynamic newValue, DateRangePickerView pickerView) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          if (oldValue.selectedDate != newValue.selectedDate ||
              !isSameDate(
                  _pickerStateDetails.selectedDate, newValue.selectedDate)) {
            _pickerStateDetails.selectedDate = newValue.selectedDate;
            if (pickerView != DateRangePickerView.month &&
                !widget.picker.allowViewNavigation) {
              _drawYearSelection();
            } else {
              _drawMonthSelection();
            }

            _position = 0;
          }
        }
        break;
      case DateRangePickerSelectionMode.multiple:
        {
          if (oldValue.selectedDates != newValue.selectedDates ||
              !DateRangePickerHelper.isDateCollectionEquals(
                  _pickerStateDetails.selectedDates, newValue.selectedDates)) {
            _pickerStateDetails.selectedDates =
                newValue.selectedDates as List<dynamic>?;
            if (pickerView != DateRangePickerView.month &&
                !widget.picker.allowViewNavigation) {
              _drawYearSelection();
            } else {
              _drawMonthSelection();
            }

            _position = 0;
          }
        }
        break;
      case DateRangePickerSelectionMode.range:
      case DateRangePickerSelectionMode.extendableRange:
        {
          if (oldValue.selectedRange != newValue.selectedRange ||
              !DateRangePickerHelper.isRangeEquals(
                  _pickerStateDetails.selectedRange, newValue.selectedRange)) {
            _pickerStateDetails.selectedRange = newValue.selectedRange;
            if (pickerView != DateRangePickerView.month &&
                !widget.picker.allowViewNavigation) {
              _drawYearSelection();
            } else {
              _drawMonthSelection();
            }

            _position = 0;
          }
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          if (oldValue.selectedRanges != newValue.selectedRanges ||
              !DateRangePickerHelper.isDateRangesEquals(
                  _pickerStateDetails.selectedRanges,
                  newValue.selectedRanges)) {
            _pickerStateDetails.selectedRanges =
                newValue.selectedRanges as List<dynamic>?;
            if (pickerView != DateRangePickerView.month &&
                !widget.picker.allowViewNavigation) {
              _drawYearSelection();
            } else {
              _drawMonthSelection();
            }

            _position = 0;
          }
        }
    }
  }

  /// Update the selection details to scroll view children except current view
  /// while view navigation.
  void _updateSelection({dynamic selectedDate}) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);

    /// Update selection on month view and update selection on year view when
    /// [allowViewNavigation] property on [SfDateRangePicker] as false
    if (pickerView != DateRangePickerView.month &&
        widget.picker.allowViewNavigation) {
      return;
    }

    widget.getPickerStateValues(_pickerStateDetails);
    for (int i = 0; i < _children.length; i++) {
      if (i == _currentChildIndex) {
        continue;
      }

      final DateRangePickerView view =
          DateRangePickerHelper.getPickerView(widget.controller.view);

      final _PickerViewState viewState = _getCurrentViewState(i);
      switch (view) {
        case DateRangePickerView.month:
          {
            viewState._monthView!.selectionNotifier.value =
                !viewState._monthView!.selectionNotifier.value;
          }
          break;
        case DateRangePickerView.year:
        case DateRangePickerView.decade:
        case DateRangePickerView.century:
          {
            viewState._yearView!.selectionNotifier.value =
                !viewState._yearView!.selectionNotifier.value;
          }
      }

      if (widget.picker.selectionMode == DateRangePickerSelectionMode.range ||
          widget.picker.selectionMode ==
              DateRangePickerSelectionMode.extendableRange) {
        viewState._lastSelectedDate = selectedDate;
      }
    }
  }

  /// Draw the selection on current month view when selected date value
  /// changed dynamically.
  void _drawMonthSelection() {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    if (pickerView != DateRangePickerView.month || _children.isEmpty) {
      return;
    }

    for (int i = 0; i < _children.length; i++) {
      final _PickerViewState viewState = _getCurrentViewState(i);

      /// Check the visible dates rather than current child index because
      /// current child index value not updated when the selected date value
      /// changed on view changed callback
      if (viewState._monthView!.visibleDates !=
          _pickerStateDetails.currentViewVisibleDates) {
        continue;
      }

      viewState._monthView!.selectionNotifier.value =
          !viewState._monthView!.selectionNotifier.value;
    }
  }

  /// Draw the selection on current year, decade, century view when
  /// selected date value changed dynamically.
  void _drawYearSelection() {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    if (pickerView == DateRangePickerView.month || _children.isEmpty) {
      return;
    }

    for (int i = 0; i < _children.length; i++) {
      final _PickerViewState viewState = _getCurrentViewState(i);

      /// Check the visible dates rather than current child index because
      /// current child index value not updated when the selected date value
      /// changed on view changed callback
      if (viewState._yearView!.visibleDates !=
          _pickerStateDetails.currentViewVisibleDates) {
        continue;
      }

      viewState._yearView!.selectionNotifier.value =
          !viewState._yearView!.selectionNotifier.value;
    }
  }

  /// Return the picker view state details based on view index.
  _PickerViewState _getCurrentViewState(int index) {
    if (index == 1) {
      return _currentViewKey.currentState!;
    } else if (index == 2) {
      return _nextViewKey.currentState!;
    }

    return _previousViewKey.currentState!;
  }

  /// Return the current view visible dates for picker based on view index.
  List<dynamic> _getCurrentVisibleDates(bool isNextView) {
    if (isNextView) {
      if (_currentChildIndex == 0) {
        return _visibleDates;
      } else if (_currentChildIndex == 1) {
        return _nextViewVisibleDates;
      } else {
        return _previousViewVisibleDates;
      }
    } else {
      if (_currentChildIndex == 0) {
        return _nextViewVisibleDates;
      } else if (_currentChildIndex == 1) {
        return _previousViewVisibleDates;
      } else {
        return _visibleDates;
      }
    }
  }

  /// Updates the current view visible dates for picker in the swiping end
  void _updateCurrentViewVisibleDates({bool isNextView = false}) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    _currentViewVisibleDates = _getCurrentVisibleDates(isNextView);

    _pickerStateDetails.currentViewVisibleDates = _currentViewVisibleDates;
    _pickerStateDetails.currentDate = _currentViewVisibleDates[0];
    final int numberOfWeeksInView =
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.picker.monthViewSettings, widget.picker.isHijri);
    if (pickerView == DateRangePickerView.month &&
        (numberOfWeeksInView == 6 || widget.picker.isHijri)) {
      final dynamic date = _currentViewVisibleDates[
          _currentViewVisibleDates.length ~/
              (widget.picker.enableMultiView ? 4 : 2)];
      _pickerStateDetails.currentDate = DateRangePickerHelper.getDate(
          date.year, date.month, 1, widget.picker.isHijri);
    }

    widget.updatePickerStateValues(_pickerStateDetails);
  }

  void _updateNextView() {
    if (!_animationController.isCompleted) {
      return;
    }

    _updateNextViewVisibleDates();

    if (_currentChildIndex == 0) {
      _currentChildIndex = 1;
    } else if (_currentChildIndex == 1) {
      _currentChildIndex = 2;
    } else if (_currentChildIndex == 2) {
      _currentChildIndex = 0;
    }

    if (kIsWeb) {
      setState(() {
        /// set state called to call the build method to fix the date doesn't
        /// update properly issue on web, in Andriod and iOS the build method
        /// called automatically when the animation ends but in web it doesn't
        /// work on that way, hence we have manually called the build method by
        /// adding setstate and i have logged and issue in framework once i got
        /// the solution will remove this setstate
      });
    }

    _resetPosition();
  }

  void _updatePreviousView() {
    if (!_animationController.isCompleted) {
      return;
    }

    _updatePreviousViewVisibleDates();

    if (_currentChildIndex == 0) {
      _currentChildIndex = 2;
    } else if (_currentChildIndex == 1) {
      _currentChildIndex = 0;
    } else if (_currentChildIndex == 2) {
      _currentChildIndex = 1;
    }

    if (kIsWeb) {
      setState(() {
        /// set state called to call the build method to fix the date doesn't
        /// update properly issue on web, in Andriod and iOS the build method
        /// called automatically when the animation ends but in web it doesn't
        /// work on that way, hence we have manually called the build method by
        /// adding setstate and i have logged and issue in framework once i got
        /// the solution will remove this setstate
      });
    }

    _resetPosition();
  }

  // resets position to zero on the swipe end to avoid the unwanted date
  // updates.
  void _resetPosition() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_position.abs() == widget.width || _position.abs() == widget.height) {
        _position = 0;
      }
    });
  }

  /// Calculate and return the date time value based on previous selected date,
  /// keyboard action and current picker view.
  dynamic _getYearSelectedDate(dynamic selectedDate, LogicalKeyboardKey key,
      _PickerView view, _PickerViewState state) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    dynamic date;

    /// Calculate the index value for previous selected date.
    int index = DateRangePickerHelper.getDateCellIndex(
        view.visibleDates, selectedDate, widget.controller.view);
    if (key == LogicalKeyboardKey.arrowRight) {
      /// If index value as last cell index in current view then
      /// navigate to next view. Calculate the selected index on navigated view
      /// and return the selected date on navigated view on right arrow pressed
      /// action.
      if ((index == view.visibleDates.length - 1 ||
              (widget.picker.enableMultiView &&
                  pickerView != DateRangePickerView.year &&
                  index >= view.visibleDates.length - 3)) &&
          widget.picker.selectionMode == DateRangePickerSelectionMode.single) {
        widget.isRtl
            ? _moveToPreviousViewWithAnimation()
            : _moveToNextViewWithAnimation();
      }

      if (index != -1) {
        date = _updateNextYearSelectionDate(selectedDate);
      }
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      /// If index value as first cell index in current view then
      /// navigate to previous view. Calculate the selected index on navigated
      /// view and return the selected date on navigated view on left arrow
      /// pressed action.
      if (index == 0 &&
          widget.picker.selectionMode == DateRangePickerSelectionMode.single) {
        widget.isRtl
            ? _moveToNextViewWithAnimation()
            : _moveToPreviousViewWithAnimation();
      }

      if (index != -1) {
        date = _updatePreviousYearSelectionDate(selectedDate);
      }
    } else if (key == LogicalKeyboardKey.arrowUp) {
      /// If index value not in first row then calculate the date by
      /// subtracting the index value with 3 and return the date value.
      if (index >= 3 && index != -1) {
        index -= 3;
        date = view.visibleDates[index];
      }
    } else if (key == LogicalKeyboardKey.arrowDown) {
      /// If index value not in last row then calculate the date by
      /// adding the index value with 3 and return the date value.
      if (index <= 8 && index != -1) {
        index += 3;
        date = view.visibleDates[index];
      } else if (widget.picker.enableMultiView &&
          widget.picker.navigationDirection ==
              DateRangePickerNavigationDirection.vertical &&
          index <= 20 &&
          index != -1) {
        index += 3;
        date = _updateNextYearSelectionDate(selectedDate);
        for (int i = 1; i < 3; i++) {
          date = _updateNextYearSelectionDate(date);
        }
      }
    }

    return date;
  }

  /// Return the next date for year, decade and century view in keyboard
  /// navigation
  dynamic _updateNextYearSelectionDate(dynamic selectedDate) {
    final DateRangePickerView view =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    final int numberOfWeeksInView =
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.picker.monthViewSettings, widget.picker.isHijri);
    switch (view) {
      case DateRangePickerView.month:
        {
          break;
        }
      case DateRangePickerView.year:
        {
          return DateRangePickerHelper.getNextViewStartDate(
              DateRangePickerView.month,
              numberOfWeeksInView,
              selectedDate,
              widget.isRtl,
              widget.picker.isHijri);
        }
      case DateRangePickerView.decade:
        {
          return DateRangePickerHelper.getNextViewStartDate(
              DateRangePickerView.year,
              numberOfWeeksInView,
              selectedDate,
              widget.isRtl,
              widget.picker.isHijri);
        }
      case DateRangePickerView.century:
        {
          return DateRangePickerHelper.getNextViewStartDate(
              DateRangePickerView.decade,
              numberOfWeeksInView,
              selectedDate,
              widget.isRtl,
              widget.picker.isHijri);
        }
    }

    return selectedDate;
  }

  /// Return the previous date for year, decade and century view in keyboard
  /// navigation
  dynamic _updatePreviousYearSelectionDate(dynamic selectedDate) {
    final int numberOfWeeksInView =
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.picker.monthViewSettings, widget.picker.isHijri);
    final DateRangePickerView view =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    switch (view) {
      case DateRangePickerView.month:
        {
          break;
        }
      case DateRangePickerView.year:
        {
          return DateRangePickerHelper.getPreviousViewStartDate(
              DateRangePickerView.month,
              numberOfWeeksInView,
              selectedDate,
              widget.isRtl,
              widget.picker.isHijri);
        }
      case DateRangePickerView.decade:
        {
          return DateRangePickerHelper.getPreviousViewStartDate(
              DateRangePickerView.year,
              numberOfWeeksInView,
              selectedDate,
              widget.isRtl,
              widget.picker.isHijri);
        }
      case DateRangePickerView.century:
        {
          return DateRangePickerHelper.getPreviousViewStartDate(
              DateRangePickerView.decade,
              numberOfWeeksInView,
              selectedDate,
              widget.isRtl,
              widget.picker.isHijri);
        }
    }

    return selectedDate;
  }

  KeyEventResult _switchViewsByKeyBoardEvent(KeyEvent event) {
    /// Ctrl + and Ctrl - used by browser to zoom the page, hence as referred
    /// EJ2 scheduler, we have used alt + numeric to switch between views in
    /// datepicker web
    if (HardwareKeyboard.instance.isAltPressed) {
      if (event.logicalKey == LogicalKeyboardKey.digit1) {
        _pickerStateDetails.view = DateRangePickerView.month;
      } else if (event.logicalKey == LogicalKeyboardKey.digit2) {
        _pickerStateDetails.view = DateRangePickerView.year;
      } else if (event.logicalKey == LogicalKeyboardKey.digit3) {
        _pickerStateDetails.view = DateRangePickerView.decade;
      } else if (event.logicalKey == LogicalKeyboardKey.digit4) {
        _pickerStateDetails.view = DateRangePickerView.century;
      } else {
        return KeyEventResult.ignored;
      }

      widget.updatePickerStateValues(_pickerStateDetails);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  KeyEventResult _updateYearSelectionByKeyBoardNavigation(
      _PickerViewState currentVisibleViewState,
      _PickerView currentVisibleView,
      DateRangePickerView pickerView,
      KeyEvent event) {
    dynamic selectedDate;
    if (_pickerStateDetails.selectedDate != null &&
        widget.picker.selectionMode == DateRangePickerSelectionMode.single) {
      selectedDate = _getYearSelectedDate(_pickerStateDetails.selectedDate,
          event.logicalKey, currentVisibleView, currentVisibleViewState);
      if (selectedDate != null &&
          DateRangePickerHelper.isBetweenMinMaxDateCell(
              selectedDate,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.controller.view,
              widget.picker.isHijri)) {
        _pickerStateDetails.selectedDate = selectedDate;
      }
    } else if (widget.picker.selectionMode ==
            DateRangePickerSelectionMode.multiple &&
        _pickerStateDetails.selectedDates != null &&
        _pickerStateDetails.selectedDates!.isNotEmpty &&
        HardwareKeyboard.instance.isShiftPressed) {
      final dynamic date = _pickerStateDetails
          .selectedDates![_pickerStateDetails.selectedDates!.length - 1];
      selectedDate = _getYearSelectedDate(
          date, event.logicalKey, currentVisibleView, currentVisibleViewState);
      if (selectedDate != null &&
          DateRangePickerHelper.isBetweenMinMaxDateCell(
              selectedDate,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.controller.view,
              widget.picker.isHijri)) {
        _pickerStateDetails.selectedDates =
            DateRangePickerHelper.cloneList(_pickerStateDetails.selectedDates)
              ?..add(selectedDate);
      }
    } else if ((widget.picker.selectionMode ==
                DateRangePickerSelectionMode.range ||
            widget.picker.selectionMode ==
                DateRangePickerSelectionMode.extendableRange) &&
        _pickerStateDetails.selectedRange != null &&
        _pickerStateDetails.selectedRange.startDate != null &&
        HardwareKeyboard.instance.isShiftPressed) {
      final dynamic date = currentVisibleViewState._lastSelectedDate;
      selectedDate = _getYearSelectedDate(
          date, event.logicalKey, currentVisibleView, currentVisibleViewState);
      if (selectedDate == null ||
          !DateRangePickerHelper.isBetweenMinMaxDateCell(
              selectedDate,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.controller.view,
              widget.picker.isHijri)) {
        return KeyEventResult.ignored;
      }

      final bool isExtendableRange = widget.picker.selectionMode ==
          DateRangePickerSelectionMode.extendableRange;

      /// Ignore the selection date while the extendable range enabled and the
      /// selection value is disabled based on extendable direction on
      /// year view keyboard selection.
      if (isExtendableRange &&
          DateRangePickerHelper.isDisableDirectionDate(
              _pickerStateDetails.selectedRange,
              selectedDate,
              widget.picker.extendableRangeSelectionDirection,
              pickerView,
              widget.picker.isHijri)) {
        return KeyEventResult.ignored;
      }

      dynamic startDate = _pickerStateDetails.selectedRange.startDate;
      dynamic endDate = _pickerStateDetails.selectedRange.endDate ?? startDate;
      if (selectedDate.isAfter(endDate) == true) {
        endDate = selectedDate;
      } else if (selectedDate.isBefore(startDate) == true) {
        startDate = selectedDate;
      } else if (selectedDate.isAfter(startDate) == true &&
          selectedDate.isBefore(endDate) == true) {
        if (isExtendableRange &&
            widget.picker.extendableRangeSelectionDirection !=
                ExtendableRangeSelectionDirection.both) {
          if (widget.picker.extendableRangeSelectionDirection ==
              ExtendableRangeSelectionDirection.forward) {
            endDate = selectedDate;
          } else if (widget.picker.extendableRangeSelectionDirection ==
              ExtendableRangeSelectionDirection.backward) {
            startDate = selectedDate;
          }
        } else {
          final int overAllDifference =
              endDate.difference(startDate).inDays as int;
          final int selectedDateIndex =
              selectedDate.difference(startDate).inDays as int;
          if (selectedDateIndex > overAllDifference / 2) {
            endDate = selectedDate;
          } else {
            startDate = selectedDate;
          }
        }
      }

      if (DateRangePickerHelper.isSameCellDates(
          startDate, endDate, pickerView)) {
        return KeyEventResult.ignored;
      }

      endDate = DateRangePickerHelper.getLastDate(
          endDate, widget.controller.view, widget.picker.isHijri);
      if (widget.picker.maxDate != null) {
        endDate = endDate.isAfter(widget.picker.maxDate) == true
            ? widget.picker.maxDate
            : endDate;
      }

      startDate = DateRangePickerHelper.getFirstDate(
          startDate, widget.picker.isHijri, pickerView);
      if (widget.picker.minDate != null) {
        startDate = startDate.isBefore(widget.picker.minDate) == true
            ? widget.picker.minDate
            : startDate;
      }

      _pickerStateDetails.selectedRange = widget.picker.isHijri
          ? HijriDateRange(startDate, endDate)
          : PickerDateRange(startDate, endDate);
      currentVisibleViewState._lastSelectedDate = selectedDate;
    } else {
      return KeyEventResult.ignored;
    }

    widget.updatePickerStateValues(_pickerStateDetails);
    _drawYearSelection();
    return KeyEventResult.handled;
  }

  /// Updates the range selection based on the keyboard keys
  void _updateRangeSelectionByKeyboardNavigation(dynamic selectedDate) {
    if (_pickerStateDetails.selectedRange != null &&
        _pickerStateDetails.selectedRange.startDate != null &&
        (_pickerStateDetails.selectedRange.endDate == null ||
            isSameDate(_pickerStateDetails.selectedRange.startDate,
                _pickerStateDetails.selectedRange.endDate))) {
      dynamic startDate = _pickerStateDetails.selectedRange.startDate;
      dynamic endDate = selectedDate;
      if (startDate.isAfter(endDate) == true) {
        final dynamic temp = startDate;
        startDate = endDate;
        endDate = temp;
      }

      _pickerStateDetails.selectedRange = widget.picker.isHijri
          ? HijriDateRange(startDate, endDate)
          : PickerDateRange(startDate, endDate);
    } else {
      _pickerStateDetails.selectedRange = widget.picker.isHijri
          ? HijriDateRange(selectedDate, null)
          : PickerDateRange(selectedDate, null);
    }
  }

  void _updateSelectionByKeyboardNavigation(dynamic selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          _pickerStateDetails.selectedDate = selectedDate;
        }
        break;
      case DateRangePickerSelectionMode.multiple:
        {
          _pickerStateDetails.selectedDates!.add(selectedDate);
        }
        break;
      case DateRangePickerSelectionMode.range:
      case DateRangePickerSelectionMode.extendableRange:
        {
          if (_pickerStateDetails.selectedRange != null &&
              _pickerStateDetails.selectedRange.startDate != null &&
              _pickerStateDetails.selectedRange.endDate != null) {
            dynamic startDate = _pickerStateDetails.selectedRange.startDate;
            dynamic endDate = _pickerStateDetails.selectedRange.endDate;
            if (selectedDate.isAfter(endDate) == true) {
              endDate = selectedDate;
            } else if (selectedDate.isBefore(startDate) == true) {
              startDate = selectedDate;
            } else if (selectedDate.isAfter(startDate) == true &&
                selectedDate.isBefore(endDate) == true) {
              if (widget.picker.selectionMode ==
                      DateRangePickerSelectionMode.extendableRange &&
                  widget.picker.extendableRangeSelectionDirection !=
                      ExtendableRangeSelectionDirection.both) {
                if (widget.picker.extendableRangeSelectionDirection ==
                    ExtendableRangeSelectionDirection.forward) {
                  endDate = selectedDate;
                } else if (widget.picker.extendableRangeSelectionDirection ==
                    ExtendableRangeSelectionDirection.backward) {
                  startDate = selectedDate;
                }
              } else {
                final int overAllDifference =
                    endDate.difference(startDate).inDays as int;
                final int selectedDateIndex =
                    selectedDate.difference(startDate).inDays as int;
                if (selectedDateIndex > overAllDifference / 2) {
                  endDate = selectedDate;
                } else {
                  startDate = selectedDate;
                }
              }
            }
            _pickerStateDetails.selectedRange = widget.picker.isHijri
                ? HijriDateRange(startDate, endDate)
                : PickerDateRange(startDate, endDate);
          } else {
            _updateRangeSelectionByKeyboardNavigation(selectedDate);
          }
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        break;
    }
  }

  KeyEventResult _onKeyDown(FocusNode node, KeyEvent event) {
    KeyEventResult result = KeyEventResult.ignored;
    if (event.runtimeType != KeyDownEvent) {
      return result;
    }

    if (HardwareKeyboard.instance.isShiftPressed &&
        event.logicalKey == LogicalKeyboardKey.tab) {
      FocusScope.of(context).previousFocus();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      FocusScope.of(context).nextFocus();
      return KeyEventResult.handled;
    }

    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);

    result = _switchViewsByKeyBoardEvent(event);

    if (HardwareKeyboard.instance.isControlPressed) {
      final bool canMoveToNextView = DateRangePickerHelper.canMoveToNextViewRtl(
          pickerView,
          DateRangePickerHelper.getNumberOfWeeksInView(
              widget.picker.monthViewSettings, widget.picker.isHijri),
          widget.picker.minDate,
          widget.picker.maxDate,
          _currentViewVisibleDates,
          widget.isRtl,
          widget.picker.enableMultiView,
          widget.picker.isHijri);
      final bool canMoveToPreviousView =
          DateRangePickerHelper.canMoveToPreviousViewRtl(
              pickerView,
              DateRangePickerHelper.getNumberOfWeeksInView(
                  widget.picker.monthViewSettings, widget.picker.isHijri),
              widget.picker.minDate,
              widget.picker.maxDate,
              _currentViewVisibleDates,
              widget.isRtl,
              widget.picker.enableMultiView,
              widget.picker.isHijri);
      if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
          canMoveToNextView) {
        widget.isRtl
            ? _moveToPreviousViewWithAnimation()
            : _moveToNextViewWithAnimation();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
          canMoveToPreviousView) {
        widget.isRtl
            ? _moveToNextViewWithAnimation()
            : _moveToPreviousViewWithAnimation();
        return KeyEventResult.handled;
      }
      result = KeyEventResult.ignored;
    }

    if (pickerView != DateRangePickerView.month &&
        widget.picker.allowViewNavigation) {
      return result;
    }

    if (_pickerStateDetails.selectedDate == null &&
        (_pickerStateDetails.selectedDates == null ||
            _pickerStateDetails.selectedDates!.isEmpty) &&
        _pickerStateDetails.selectedRange == null &&
        (_pickerStateDetails.selectedRanges == null ||
            _pickerStateDetails.selectedRanges!.isEmpty)) {
      return result;
    }

    _PickerViewState currentVisibleViewState;
    _PickerView currentVisibleView;
    if (_currentChildIndex == 0) {
      currentVisibleViewState = _previousViewKey.currentState!;
      currentVisibleView = _previousView!;
    } else if (_currentChildIndex == 1) {
      currentVisibleViewState = _currentViewKey.currentState!;
      currentVisibleView = _currentView!;
    } else {
      currentVisibleViewState = _nextViewKey.currentState!;
      currentVisibleView = _nextView!;
    }

    if (pickerView != DateRangePickerView.month) {
      result = _updateYearSelectionByKeyBoardNavigation(
          currentVisibleViewState, currentVisibleView, pickerView, event);
      return result;
    }

    final dynamic selectedDate =
        _updateSelectedDate(event, currentVisibleViewState, currentVisibleView);

    if (DateRangePickerHelper.isDateWithInVisibleDates(
            currentVisibleView.visibleDates,
            widget.picker.monthViewSettings.blackoutDates,
            selectedDate) ||
        DateRangePickerHelper.isDateWithInVisibleDates(
            currentVisibleView.visibleDates,
            currentVisibleView.disableDatePredicates,
            selectedDate) ||
        !DateRangePickerHelper.isEnabledDate(
            widget.picker.minDate,
            widget.picker.maxDate,
            widget.picker.enablePastDates,
            selectedDate,
            widget.picker.isHijri)) {
      return result;
    }

    /// Ignore the selection date while the extendable range enabled and the
    /// selection value is disabled based on extendable direction on
    /// month view keyboard selection.
    if (widget.picker.selectionMode ==
            DateRangePickerSelectionMode.extendableRange &&
        _pickerStateDetails.selectedRange != null &&
        DateRangePickerHelper.isDisableDirectionDate(
            _pickerStateDetails.selectedRange,
            selectedDate,
            widget.picker.extendableRangeSelectionDirection,
            pickerView,
            widget.picker.isHijri)) {
      return result;
    }

    final int numberOfWeeksInView =
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.picker.monthViewSettings, widget.picker.isHijri);
    final dynamic visibleStartDate = currentVisibleView.visibleDates[0];
    final dynamic visibleEndDate = currentVisibleView
        .visibleDates[currentVisibleView.visibleDates.length - 1];
    final int datesCount = currentVisibleView.visibleDates.length ~/
        (widget.picker.enableMultiView ? 2 : 1);
    // ignore: avoid_bool_literals_in_conditional_expressions
    final bool showLeadingTrailingDates = widget.picker.enableMultiView
        ? false
        : DateRangePickerHelper.canShowLeadingAndTrailingDates(
            widget.picker.monthViewSettings, widget.picker.isHijri);
    final bool isCurrentMonthDate = widget.picker.enableMultiView
        ? (DateRangePickerHelper.isDateAsCurrentMonthDate(
                currentVisibleView.visibleDates[datesCount ~/ 2],
                numberOfWeeksInView,
                showLeadingTrailingDates,
                selectedDate,
                widget.picker.isHijri) ||
            DateRangePickerHelper.isDateAsCurrentMonthDate(
                currentVisibleView.visibleDates[datesCount + (datesCount ~/ 2)],
                numberOfWeeksInView,
                showLeadingTrailingDates,
                selectedDate,
                widget.picker.isHijri))
        : DateRangePickerHelper.isDateAsCurrentMonthDate(
            currentVisibleView.visibleDates[datesCount ~/ 2],
            numberOfWeeksInView,
            showLeadingTrailingDates,
            selectedDate,
            widget.picker.isHijri);
    if (!isCurrentMonthDate ||
        !isDateWithInDateRange(
            visibleStartDate, visibleEndDate, selectedDate)) {
      final int month = selectedDate.month as int;
      final dynamic nextMonthDate = getNextMonthDate(
          currentVisibleView.visibleDates[
              currentVisibleView.visibleDates.length ~/
                  (widget.picker.enableMultiView ? 4 : 2)]);
      int nextMonth = nextMonthDate.month as int;
      final dynamic nextMonthEndDate =
          DateRangePickerHelper.getMonthEndDate(nextMonthDate);
      if (isDateWithInDateRange(
          visibleStartDate, visibleEndDate, nextMonthEndDate)) {
        nextMonth = getNextMonthDate(nextMonthEndDate).month as int;
      }
      if (month == nextMonth) {
        widget.isRtl
            ? _moveToPreviousViewWithAnimation()
            : _moveToNextViewWithAnimation();
      } else {
        widget.isRtl
            ? _moveToNextViewWithAnimation()
            : _moveToPreviousViewWithAnimation();
      }

      result = KeyEventResult.handled;
    }

    result = KeyEventResult.handled;
    currentVisibleViewState._drawSelection(selectedDate);
    _updateSelectionByKeyboardNavigation(selectedDate);
    widget.updatePickerStateValues(_pickerStateDetails);
    currentVisibleViewState._monthView!.selectionNotifier.value =
        !currentVisibleViewState._monthView!.selectionNotifier.value;
    _updateSelection(selectedDate: selectedDate);
    return result;
  }

  dynamic _updateSingleSelectionByKeyBoardKeys(
      KeyEvent event, _PickerView currentView) {
    dynamic selectedDate = _pickerStateDetails.selectedDate;
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (isSameDate(_pickerStateDetails.selectedDate,
          currentView.visibleDates[currentView.visibleDates.length - 1])) {
        _moveToNextViewWithAnimation();
      }
      do {
        selectedDate = addDays(selectedDate, 1);
      } while (DateRangePickerHelper.isDateWithInVisibleDates(
          currentView.visibleDates,
          widget.picker.monthViewSettings.blackoutDates,
          selectedDate));

      return selectedDate;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (isSameDate(
          _pickerStateDetails.selectedDate, currentView.visibleDates[0])) {
        _moveToPreviousViewWithAnimation();
      }
      do {
        selectedDate = addDays(selectedDate, -1);
      } while (DateRangePickerHelper.isDateWithInVisibleDates(
          currentView.visibleDates,
          widget.picker.monthViewSettings.blackoutDates,
          selectedDate));

      return selectedDate;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      do {
        selectedDate = addDays(selectedDate, -DateTime.daysPerWeek);
      } while (DateRangePickerHelper.isDateWithInVisibleDates(
          currentView.visibleDates,
          widget.picker.monthViewSettings.blackoutDates,
          selectedDate));
      return selectedDate;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      do {
        selectedDate = addDays(selectedDate, DateTime.daysPerWeek);
      } while (DateRangePickerHelper.isDateWithInVisibleDates(
          currentView.visibleDates,
          widget.picker.monthViewSettings.blackoutDates,
          selectedDate));
      return selectedDate;
    }
    return null;
  }

  dynamic _updateMultiAndRangeSelectionByKeyBoard(
      KeyEvent event, _PickerViewState currentState, _PickerView currentView) {
    dynamic selectedDate;
    if (HardwareKeyboard.instance.isShiftPressed &&
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (widget.picker.selectionMode ==
          DateRangePickerSelectionMode.multiple) {
        selectedDate = _pickerStateDetails
            .selectedDates![_pickerStateDetails.selectedDates!.length - 1];
        do {
          selectedDate = addDays(selectedDate, 1);
        } while (DateRangePickerHelper.isDateWithInVisibleDates(
            currentView.visibleDates,
            widget.picker.monthViewSettings.blackoutDates,
            selectedDate));
        return selectedDate;
      } else {
        selectedDate = currentState._lastSelectedDate;
        do {
          selectedDate = addDays(selectedDate, 1);
        } while (DateRangePickerHelper.isDateWithInVisibleDates(
            currentView.visibleDates,
            widget.picker.monthViewSettings.blackoutDates,
            selectedDate));
        return selectedDate;
      }
    } else if (HardwareKeyboard.instance.isShiftPressed &&
        event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (widget.picker.selectionMode ==
          DateRangePickerSelectionMode.multiple) {
        selectedDate = _pickerStateDetails
            .selectedDates![_pickerStateDetails.selectedDates!.length - 1];
        do {
          selectedDate = addDays(selectedDate, -1);
        } while (DateRangePickerHelper.isDateWithInVisibleDates(
            currentView.visibleDates,
            widget.picker.monthViewSettings.blackoutDates,
            selectedDate));
        return selectedDate;
      } else {
        selectedDate = currentState._lastSelectedDate;
        do {
          selectedDate = addDays(selectedDate, -1);
        } while (DateRangePickerHelper.isDateWithInVisibleDates(
            currentView.visibleDates,
            widget.picker.monthViewSettings.blackoutDates,
            selectedDate));
        return selectedDate;
      }
    } else if (HardwareKeyboard.instance.isShiftPressed &&
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (widget.picker.selectionMode ==
          DateRangePickerSelectionMode.multiple) {
        selectedDate = _pickerStateDetails
            .selectedDates![_pickerStateDetails.selectedDates!.length - 1];
        do {
          selectedDate = addDays(selectedDate, -DateTime.daysPerWeek);
        } while (DateRangePickerHelper.isDateWithInVisibleDates(
            currentView.visibleDates,
            widget.picker.monthViewSettings.blackoutDates,
            selectedDate));
        return selectedDate;
      } else {
        selectedDate = currentState._lastSelectedDate;
        do {
          selectedDate = addDays(selectedDate, -DateTime.daysPerWeek);
        } while (DateRangePickerHelper.isDateWithInVisibleDates(
            currentView.visibleDates,
            widget.picker.monthViewSettings.blackoutDates,
            selectedDate));
        return selectedDate;
      }
    } else if (HardwareKeyboard.instance.isShiftPressed &&
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (widget.picker.selectionMode ==
          DateRangePickerSelectionMode.multiple) {
        selectedDate = _pickerStateDetails
            .selectedDates![_pickerStateDetails.selectedDates!.length - 1];
        do {
          selectedDate = addDays(selectedDate, DateTime.daysPerWeek);
        } while (DateRangePickerHelper.isDateWithInVisibleDates(
            currentView.visibleDates,
            widget.picker.monthViewSettings.blackoutDates,
            selectedDate));
        return selectedDate;
      } else {
        selectedDate = currentState._lastSelectedDate;
        do {
          selectedDate = addDays(selectedDate, DateTime.daysPerWeek);
        } while (DateRangePickerHelper.isDateWithInVisibleDates(
            currentView.visibleDates,
            widget.picker.monthViewSettings.blackoutDates,
            selectedDate));
        return selectedDate;
      }
    }
    return null;
  }

  dynamic _updateSelectedDate(
      KeyEvent event, _PickerViewState currentState, _PickerView currentView) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        {
          return _updateSingleSelectionByKeyBoardKeys(event, currentView);
        }
      case DateRangePickerSelectionMode.multiple:
      case DateRangePickerSelectionMode.range:
      case DateRangePickerSelectionMode.extendableRange:
        {
          return _updateMultiAndRangeSelectionByKeyBoard(
              event, currentState, currentView);
        }
      case DateRangePickerSelectionMode.multiRange:
        break;
    }

    return null;
  }

  void _onHorizontalStart(DragStartDetails dragStartDetails) {
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        {
          _scrollStartPosition = dragStartDetails.globalPosition.dx;
          _updateSelection();
        }
        break;
      case DateRangePickerNavigationDirection.vertical:
        break;
    }
  }

  void _onHorizontalUpdate(DragUpdateDetails dragUpdateDetails) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        {
          final double difference =
              dragUpdateDetails.globalPosition.dx - _scrollStartPosition!;
          if (difference < 0 &&
              !DateRangePickerHelper.canMoveToNextViewRtl(
                  pickerView,
                  DateRangePickerHelper.getNumberOfWeeksInView(
                      widget.picker.monthViewSettings, widget.picker.isHijri),
                  widget.picker.minDate,
                  widget.picker.maxDate,
                  _currentViewVisibleDates,
                  widget.isRtl,
                  widget.picker.enableMultiView,
                  widget.picker.isHijri)) {
            return;
          } else if (difference > 0 &&
              !DateRangePickerHelper.canMoveToPreviousViewRtl(
                  pickerView,
                  DateRangePickerHelper.getNumberOfWeeksInView(
                      widget.picker.monthViewSettings, widget.picker.isHijri),
                  widget.picker.minDate,
                  widget.picker.maxDate,
                  _currentViewVisibleDates,
                  widget.isRtl,
                  widget.picker.enableMultiView,
                  widget.picker.isHijri)) {
            return;
          }

          final bool isNextView = difference < 0;
          _triggerSelectableDayPredicates(_getCurrentVisibleDates(isNextView));

          _position = difference;
          setState(() {
            /* Updates the widget navigated distance and moves the widget
              in the custom scroll view */
          });
        }
        break;
      case DateRangePickerNavigationDirection.vertical:
        break;
    }
  }

  void _onHorizontalEnd(DragEndDetails dragEndDetails) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.vertical:
        break;
      case DateRangePickerNavigationDirection.horizontal:
        {
          _position = _position != 0 ? _position : 0;
          // condition to check and update the right to left swiping
          if (-_position >= widget.width / 2) {
            _tween.begin = _position;
            _tween.end = -widget.width;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted && _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .forward()
                .then<dynamic>((dynamic value) => _updateNextView());

            /// updates the current view visible dates when the view swiped in
            /// right to left direction
            _updateCurrentViewVisibleDates(isNextView: true);
          }
          // fling the view from right to left
          else if (-dragEndDetails.velocity.pixelsPerSecond.dx > widget.width) {
            if (!DateRangePickerHelper.canMoveToNextViewRtl(
                pickerView,
                DateRangePickerHelper.getNumberOfWeeksInView(
                    widget.picker.monthViewSettings, widget.picker.isHijri),
                widget.picker.minDate,
                widget.picker.maxDate,
                _currentViewVisibleDates,
                widget.isRtl,
                widget.picker.enableMultiView,
                widget.picker.isHijri)) {
              _position = 0;
              setState(() {
                /* Completes the swiping and rearrange the children position in
                  the custom scroll view */
              });
              return;
            }

            _tween.begin = _position;
            _tween.end = -widget.width;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted && _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .fling(
                    velocity: 5.0, animationBehavior: AnimationBehavior.normal)
                .then<dynamic>((dynamic value) => _updateNextView());

            /// updates the current view visible dates when fling the view in
            /// right to left direction
            _updateCurrentViewVisibleDates(isNextView: true);
          }
          // condition to check and update the left to right swiping
          else if (_position >= widget.width / 2) {
            _tween.begin = _position;
            _tween.end = widget.width;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .forward()
                .then<dynamic>((dynamic value) => _updatePreviousView());

            /// updates the current view visible dates when the view swiped in
            /// left to right direction
            _updateCurrentViewVisibleDates();
          }
          // fling the view from left to right
          else if (dragEndDetails.velocity.pixelsPerSecond.dx > widget.width) {
            if (!DateRangePickerHelper.canMoveToPreviousViewRtl(
                pickerView,
                DateRangePickerHelper.getNumberOfWeeksInView(
                    widget.picker.monthViewSettings, widget.picker.isHijri),
                widget.picker.minDate,
                widget.picker.maxDate,
                _currentViewVisibleDates,
                widget.isRtl,
                widget.picker.enableMultiView,
                widget.picker.isHijri)) {
              _position = 0;
              setState(() {
                /* Completes the swiping and rearrange the children position in
                  the custom scroll view */
              });
              return;
            }

            _tween.begin = _position;
            _tween.end = widget.width;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted && _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .fling(
                    velocity: 5.0, animationBehavior: AnimationBehavior.normal)
                .then<dynamic>((dynamic value) => _updatePreviousView());

            /// updates the current view visible dates when fling the view in
            /// left to right direction
            _updateCurrentViewVisibleDates();
          }
          // condition to check and revert the right to left swiping
          else if (_position.abs() <= widget.width / 2) {
            _tween.begin = _position;
            _tween.end = 0.0;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted && _position != _tween.end) {
              _animationController.reset();
            }

            _triggerSelectableDayPredicates(_currentViewVisibleDates);
            _animationController.duration = const Duration(milliseconds: 250);
            _animationController.forward();
          }
        }
    }
  }

  void _onVerticalStart(DragStartDetails dragStartDetails) {
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        break;
      case DateRangePickerNavigationDirection.vertical:
        {
          _scrollStartPosition = dragStartDetails.globalPosition.dy;
          _updateSelection();
        }
        break;
    }
  }

  void _onVerticalUpdate(DragUpdateDetails dragUpdateDetails) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        break;
      case DateRangePickerNavigationDirection.vertical:
        {
          final double difference =
              dragUpdateDetails.globalPosition.dy - _scrollStartPosition!;
          if (difference < 0 &&
              !DateRangePickerHelper.canMoveToNextView(
                  pickerView,
                  DateRangePickerHelper.getNumberOfWeeksInView(
                      widget.picker.monthViewSettings, widget.picker.isHijri),
                  widget.picker.maxDate,
                  _currentViewVisibleDates,
                  widget.picker.enableMultiView,
                  widget.picker.isHijri)) {
            return;
          } else if (difference > 0 &&
              !DateRangePickerHelper.canMoveToPreviousView(
                  pickerView,
                  DateRangePickerHelper.getNumberOfWeeksInView(
                      widget.picker.monthViewSettings, widget.picker.isHijri),
                  widget.picker.minDate,
                  _currentViewVisibleDates,
                  widget.picker.enableMultiView,
                  widget.picker.isHijri)) {
            return;
          }

          final bool isNextView = difference < 0;
          _triggerSelectableDayPredicates(_getCurrentVisibleDates(isNextView));

          _position = difference;
          setState(() {
            /* Updates the widget navigated distance and moves the widget
              in the custom scroll view */
          });
        }
    }
  }

  void _onVerticalEnd(DragEndDetails dragEndDetails) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    switch (widget.picker.navigationDirection) {
      case DateRangePickerNavigationDirection.horizontal:
        break;
      case DateRangePickerNavigationDirection.vertical:
        {
          _position = _position != 0 ? _position : 0;
          // condition to check and update the bottom to top swiping
          if (-_position >= widget.height / 2) {
            _tween.begin = _position;
            _tween.end = -widget.height;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .forward()
                .then<dynamic>((dynamic value) => _updateNextView());

            /// updates the current view visible dates when the view swiped in
            /// bottom to top direction
            _updateCurrentViewVisibleDates(isNextView: true);
          }
          // fling the view to bottom to top
          else if (-dragEndDetails.velocity.pixelsPerSecond.dy >
              widget.height) {
            if (!DateRangePickerHelper.canMoveToNextView(
                pickerView,
                DateRangePickerHelper.getNumberOfWeeksInView(
                    widget.picker.monthViewSettings, widget.picker.isHijri),
                widget.picker.maxDate,
                _currentViewVisibleDates,
                widget.picker.enableMultiView,
                widget.picker.isHijri)) {
              _position = 0;
              setState(() {
                /* Completes the swiping and rearrange the children position in
                  the custom scroll view */
              });
              return;
            }
            _tween.begin = _position;
            _tween.end = -widget.height;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .fling(
                    velocity: 5.0, animationBehavior: AnimationBehavior.normal)
                .then<dynamic>((dynamic value) => _updateNextView());

            /// updates the current view visible dates when fling the view in
            /// bottom to top direction
            _updateCurrentViewVisibleDates(isNextView: true);
          }
          // condition to check and update the top to bottom swiping
          else if (_position >= widget.height / 2) {
            _tween.begin = _position;
            _tween.end = widget.height;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .forward()
                .then<dynamic>((dynamic value) => _updatePreviousView());

            /// updates the current view visible dates when the view swiped in
            /// top to bottom direction
            _updateCurrentViewVisibleDates();
          }
          // fling the view to top to bottom
          else if (dragEndDetails.velocity.pixelsPerSecond.dy > widget.height) {
            if (!DateRangePickerHelper.canMoveToPreviousView(
                pickerView,
                DateRangePickerHelper.getNumberOfWeeksInView(
                    widget.picker.monthViewSettings, widget.picker.isHijri),
                widget.picker.minDate,
                _currentViewVisibleDates,
                widget.picker.enableMultiView,
                widget.picker.isHijri)) {
              _position = 0;
              setState(() {
                /* Completes the swiping and rearrange the children position in
                  the custom scroll view */
              });
              return;
            }

            _tween.begin = _position;
            _tween.end = widget.height;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _animationController.duration = const Duration(milliseconds: 250);
            _animationController
                .fling(
                    velocity: 5.0, animationBehavior: AnimationBehavior.normal)
                .then<dynamic>((dynamic value) => _updatePreviousView());

            /// updates the current view visible dates when fling the view in
            /// top to bottom direction
            _updateCurrentViewVisibleDates();
          }
          // condition to check and revert the bottom to top swiping
          else if (_position.abs() <= widget.height / 2) {
            _tween.begin = _position;
            _tween.end = 0.0;

            // Resets the controller to forward it again, the animation will
            // forward only from the dismissed state
            if (_animationController.isCompleted || _position != _tween.end) {
              _animationController.reset();
            }

            _triggerSelectableDayPredicates(_currentViewVisibleDates);
            _animationController.duration = const Duration(milliseconds: 250);
            _animationController.forward();
          }
        }
    }
  }

  /// Check the date cell is disable date or not, based on the callback returns
  /// the value is false. If the date is disabled date, it holds the list of
  /// dates collection. Which is the list of dates to restrict the interaction.
  /// It is applicable for all views.
  void _triggerSelectableDayPredicates(List<dynamic> visibleDates) {
    if ((widget.picker.selectableDayPredicate == null) ||
        (_disabledDates != null &&
            _disabledDates!.isNotEmpty &&
            _disabledDates?.keys != null &&
            _disabledDates!.keys.isNotEmpty &&
            _disabledDates!.keys.first == visibleDates)) {
      return;
    }

    final DateRangePickerView view =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    final int viewCount = _isMultiViewEnabled(widget.picker) ? 2 : 1;

    _disabledDates ??= <List<dynamic>, List<dynamic>>{};
    _disabledDates!.clear();

    final List<dynamic> disabledDateCollection = <dynamic>[];

    switch (view) {
      case DateRangePickerView.month:
        final int datesCount =
            visibleDates.length ~/ (widget.picker.enableMultiView ? 2 : 1);
        for (int i = 0; i < viewCount; i++) {
          int midDateIndex = datesCount ~/ 2;
          if (i == 1) {
            midDateIndex = datesCount + (datesCount ~/ 2);
          }
          for (int j = i * datesCount; j < ((i + 1) * datesCount); j++) {
            final int numberOfWeeksInView =
                DateRangePickerHelper.getNumberOfWeeksInView(
                    widget.picker.monthViewSettings, widget.picker.isHijri);
            final bool showLeadingTrailingDates =
                DateRangePickerHelper.canShowLeadingAndTrailingDates(
                    widget.picker.monthViewSettings, widget.picker.isHijri);
            final bool isCurrentMonthDate =
                DateRangePickerHelper.isDateAsCurrentMonthDate(
                    visibleDates[midDateIndex],
                    numberOfWeeksInView,
                    showLeadingTrailingDates,
                    visibleDates[j],
                    widget.picker.isHijri);
            if (isCurrentMonthDate) {
              final bool isSelectedDayPredicate =
                  widget.picker.selectableDayPredicate(visibleDates[j]) as bool;
              if (!isSelectedDayPredicate) {
                disabledDateCollection.add(visibleDates[j]);
              }
            }
          }
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.century:
      case DateRangePickerView.decade:
        if (widget.picker.allowViewNavigation) {
          return;
        }
        for (int i = 0; i < visibleDates.length; i++) {
          final bool isSelectedDayPredicate =
              widget.picker.selectableDayPredicate(visibleDates[i]) as bool;
          if (!isSelectedDayPredicate) {
            disabledDateCollection.add(visibleDates[i]);
          }
        }
    }

    _disabledDates![visibleDates] = disabledDateCollection;
  }
}

/// Holds the month, year, decade and century view and handle it interactions.
@immutable
class _PickerView extends StatefulWidget {
  /// Constructor to create picker view instance.
  const _PickerView(
    this.picker,
    this.controller,
    this.visibleDates,
    this.enableMultiView,
    this.width,
    this.height,
    this.datePickerTheme,
    this.focusNode,
    this.textScaleFactor,
    this.disableDatePredicates, {
    Key? key,
    required this.getPickerStateDetails,
    required this.updatePickerStateDetails,
    this.isRtl = false,
  }) : super(key: key);

  /// Holds the visible dates for the picker view.
  final List<dynamic> visibleDates;

  /// Holds the picker instance to access the picker details.
  final _SfDateRangePicker picker;

  final bool enableMultiView;

  /// Holds the controller details used on its state
  final dynamic controller;

  /// Holds the picker view width used on widget positioning.
  final double width;

  /// Holds the picker view height used on widget positioning.
  final double height;

  /// Used to get the picker values from date picker state.
  final UpdatePickerState getPickerStateDetails;

  /// Used to update the picker values to date picker state.
  final UpdatePickerState updatePickerStateDetails;

  /// Holds the theme data for date range picker.
  final SfDateRangePickerThemeData datePickerTheme;

  /// Used to identify the widget direction is RTL.
  final bool isRtl;

  /// Holds the node and used to request the focus.
  final FocusNode? focusNode;

  /// Defines the text scale factor of [SfDateRangePicker].
  final double textScaleFactor;

  final List<dynamic>? disableDatePredicates;

  @override
  _PickerViewState createState() => _PickerViewState();
}

/// Handle the picker view children position and it interaction.
class _PickerViewState extends State<_PickerView>
    with TickerProviderStateMixin {
  final PickerStateArgs _pickerStateDetails = PickerStateArgs();

  /// Holds the month view instance used to update selection from scroll view.
  MonthView? _monthView;

  /// Holds the year view instance used to update selection from scroll view.
  YearView? _yearView;
  final ValueNotifier<HoveringDetails?> _mouseHoverPosition =
      ValueNotifier<HoveringDetails?>(null);

  /// The date time property used to range selection to store the
  /// previous selected date value in range.
  dynamic _previousSelectedDate;

  //// drag start boolean variable used to identify whether the drag started or not
  //// For example., if user start drag from disabled date then the start date of the range not created
  //// so in drag update method update the end date of existing selected range.
  bool _isDragStart = false;

  /// Defines whether the current platform is mobile or not.
  bool _isMobilePlatform = true;

  /// Stores the last selected date value to update the selection through
  /// keyboard keys
  dynamic _lastSelectedDate;

  @override
  void dispose() {
    _mouseHoverPosition.value = null;
    _mouseHoverPosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    final SfLocalizations localizations = SfLocalizations.of(context);
    _isMobilePlatform =
        DateRangePickerHelper.isMobileLayout(Theme.of(context).platform);
    widget.getPickerStateDetails(_pickerStateDetails);
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);

    switch (pickerView) {
      case DateRangePickerView.month:
        {
          return GestureDetector(
            onTapUp: _updateTapCallback,
            onHorizontalDragStart: _getDragStartCallback(),
            onVerticalDragStart: _getDragStartCallback(),
            onHorizontalDragUpdate: _getDragUpdateCallback(),
            onVerticalDragUpdate: _getDragUpdateCallback(),
            child: MouseRegion(
                onEnter: _pointerEnterEvent,
                onHover: _pointerHoverEvent,
                onExit: _pointerExitEvent,
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: _addMonthView(
                      locale, widget.datePickerTheme, localizations),
                )),
          );
        }
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          return GestureDetector(
            onTapUp: _updateTapCallback,
            onHorizontalDragStart: _getDragStartCallback(),
            onVerticalDragStart: _getDragStartCallback(),
            onHorizontalDragUpdate: _getDragUpdateCallback(),
            onVerticalDragUpdate: _getDragUpdateCallback(),
            child: MouseRegion(
              onEnter: _pointerEnterEvent,
              onHover: _pointerHoverEvent,
              onExit: _pointerExitEvent,
              child: _addYearView(locale, localizations),
            ),
          );
        }
    }
  }

  /// Used to draw the selection on month view.
  void _drawSelection(dynamic selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        _drawSingleSelectionForMonth(selectedDate);
        break;
      case DateRangePickerSelectionMode.multiple:
        _drawMultipleSelectionForMonth(selectedDate);
        break;
      case DateRangePickerSelectionMode.range:
        _drawRangeSelectionForMonth(selectedDate);
        break;
      case DateRangePickerSelectionMode.multiRange:
        _drawRangesSelectionForMonth(selectedDate);
        break;
      case DateRangePickerSelectionMode.extendableRange:
        _drawExtendableRangeSelection(selectedDate);
    }
  }

  // Returns the month view  as a child for the picker view.
  Widget _addMonthView(
      Locale locale,
      SfDateRangePickerThemeData datePickerTheme,
      SfLocalizations localizations) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    double viewHeaderHeight =
        widget.picker.monthViewSettings.viewHeaderHeight as double;
    if (pickerView == DateRangePickerView.month &&
        widget.picker.navigationDirection ==
            DateRangePickerNavigationDirection.vertical) {
      viewHeaderHeight = 0;
    }

    final double height = widget.height - viewHeaderHeight;
    _monthView = _getMonthView(locale, widget.datePickerTheme, localizations,
        widget.width, height, pickerView);
    return Stack(
      children: <Widget>[
        _getViewHeader(viewHeaderHeight, locale, datePickerTheme),
        Positioned(
          left: 0,
          top: viewHeaderHeight,
          right: 0,
          height: height,
          child: RepaintBoundary(
            child: _monthView,
          ),
        ),
      ],
    );
  }

  MonthView _getMonthView(
      Locale locale,
      SfDateRangePickerThemeData datePickerTheme,
      SfLocalizations localizations,
      double width,
      double height,
      DateRangePickerView pickerView) {
    final int rowCount = DateRangePickerHelper.getNumberOfWeeksInView(
        widget.picker.monthViewSettings, widget.picker.isHijri);
    return MonthView(
      widget.visibleDates,
      rowCount,
      widget.picker.monthCellStyle,
      widget.picker.selectionTextStyle,
      widget.picker.rangeTextStyle,
      widget.picker.selectionColor,
      widget.picker.startRangeSelectionColor,
      widget.picker.endRangeSelectionColor,
      widget.picker.rangeSelectionColor,
      widget.datePickerTheme,
      widget.isRtl,
      widget.picker.todayHighlightColor,
      widget.picker.minDate,
      widget.picker.maxDate,
      widget.picker.enablePastDates,
      DateRangePickerHelper.canShowLeadingAndTrailingDates(
          widget.picker.monthViewSettings, widget.picker.isHijri),
      widget.picker.monthViewSettings.blackoutDates,
      widget.picker.monthViewSettings.specialDates,
      widget.picker.monthViewSettings.weekendDays,
      widget.picker.selectionShape,
      widget.picker.selectionRadius,
      _mouseHoverPosition,
      widget.enableMultiView,
      widget.picker.viewSpacing,
      ValueNotifier<bool>(false),
      widget.textScaleFactor,
      widget.picker.selectionMode,
      widget.picker.isHijri,
      localizations,
      widget.picker.navigationDirection,
      width,
      height,
      widget.getPickerStateDetails,
      widget.picker.cellBuilder,
      widget.picker.monthViewSettings.showWeekNumber,
      widget.picker.monthViewSettings.weekNumberStyle,
      _isMobilePlatform,
      widget.disableDatePredicates,
      widget.picker.extendableRangeSelectionDirection,
    );
  }

  Widget _getViewHeader(double viewHeaderHeight, Locale locale,
      SfDateRangePickerThemeData datePickerTheme) {
    if (viewHeaderHeight == 0) {
      return Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: viewHeaderHeight,
          child: Container());
    }

    final Color todayTextColor =
        widget.picker.monthCellStyle.todayTextStyle != null &&
                widget.picker.monthCellStyle.todayTextStyle!.color != null
            ? widget.picker.monthCellStyle.todayTextStyle!.color! as Color
            : (widget.picker.todayHighlightColor != null &&
                    widget.picker.todayHighlightColor != Colors.transparent
                ? widget.picker.todayHighlightColor!
                : widget.datePickerTheme.todayHighlightColor!);

    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      height: viewHeaderHeight,
      child: Container(
        color:
            widget.picker.monthViewSettings.viewHeaderStyle.backgroundColor ??
                widget.datePickerTheme.viewHeaderBackgroundColor,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _PickerViewHeaderPainter(
                widget.visibleDates,
                widget.picker.navigationMode,
                widget.picker.monthViewSettings.viewHeaderStyle,
                viewHeaderHeight,
                widget.picker.monthViewSettings,
                widget.datePickerTheme,
                locale,
                widget.isRtl,
                widget.picker.monthCellStyle,
                widget.enableMultiView,
                widget.picker.viewSpacing,
                todayTextColor,
                widget.textScaleFactor,
                widget.picker.isHijri,
                widget.picker.navigationDirection,
                null,
                widget.picker.monthViewSettings.showWeekNumber,
                _isMobilePlatform),
          ),
        ),
      ),
    );
  }

  void _updateTapCallback(TapUpDetails details) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    switch (pickerView) {
      case DateRangePickerView.month:
        {
          double viewHeaderHeight =
              widget.picker.monthViewSettings.viewHeaderHeight as double;
          if (widget.picker.navigationDirection ==
              DateRangePickerNavigationDirection.vertical) {
            viewHeaderHeight = 0;
          }

          final double weekNumberPanelWidth =
              DateRangePickerHelper.getWeekNumberPanelWidth(
                  widget.picker.monthViewSettings.showWeekNumber,
                  widget.width,
                  _isMobilePlatform);

          if (details.localPosition.dy < viewHeaderHeight ||
              ((!widget.isRtl &&
                      details.localPosition.dx < weekNumberPanelWidth) ||
                  (widget.isRtl &&
                      details.localPosition.dx >
                          widget.width - weekNumberPanelWidth))) {
            return;
          }

          if (details.localPosition.dy > viewHeaderHeight) {
            _handleTouch(
                Offset(details.localPosition.dx,
                    details.localPosition.dy - viewHeaderHeight),
                details);
          }
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          _handleYearPanelSelection(
              Offset(details.localPosition.dx, details.localPosition.dy));
        }
    }

    if (widget.focusNode != null && !widget.focusNode!.hasFocus) {
      widget.focusNode!.requestFocus();
    }
  }

  void _updateMouseHover(Offset globalPosition) {
    if (_isMobilePlatform) {
      return;
    }

    widget.getPickerStateDetails(_pickerStateDetails);
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    final RenderObject renderObject = context.findRenderObject()!;
    final RenderBox? box = renderObject is RenderBox ? renderObject : null;
    final Offset localPosition = box!.globalToLocal(globalPosition);
    final double viewHeaderHeight = pickerView == DateRangePickerView.month &&
            widget.picker.navigationDirection ==
                DateRangePickerNavigationDirection.horizontal
        ? widget.picker.monthViewSettings.viewHeaderHeight as double
        : 0;
    final double xPosition = localPosition.dx;
    final double yPosition = localPosition.dy - viewHeaderHeight;

    if (localPosition.dy < viewHeaderHeight) {
      _mouseHoverPosition.value = null;
      return;
    }

    /// Got selected date and updated the range based on the selected range,
    /// to render the hovering effect for the hovering range when extendable
    /// selection enable.
    dynamic range;
    if (widget.picker.selectionMode ==
            DateRangePickerSelectionMode.extendableRange &&
        _pickerStateDetails.selectedRange != null &&
        widget.picker.navigationMode != DateRangePickerNavigationMode.scroll) {
      int index;
      dynamic date;
      final DateRangePickerView pickerView =
          DateRangePickerHelper.getPickerView(widget.controller.view);
      switch (pickerView) {
        case DateRangePickerView.month:
          {
            index = _getSelectedIndex(xPosition, yPosition);
            if (index == -1) {
              return;
            }

            date = widget.visibleDates[index];

            if (!DateRangePickerHelper.isEnabledDate(
                widget.picker.minDate,
                widget.picker.maxDate,
                widget.picker.enablePastDates,
                date,
                widget.picker.isHijri)) {
              _mouseHoverPosition.value = null;
              return;
            }

            final int currentMonthIndex = _getCurrentDateIndex(index);
            if (!DateRangePickerHelper.isDateAsCurrentMonthDate(
                widget.visibleDates[currentMonthIndex],
                DateRangePickerHelper.getNumberOfWeeksInView(
                    widget.picker.monthViewSettings, widget.picker.isHijri),
                DateRangePickerHelper.canShowLeadingAndTrailingDates(
                    widget.picker.monthViewSettings, widget.picker.isHijri),
                date,
                widget.picker.isHijri)) {
              _mouseHoverPosition.value = null;
              return;
            }
          }
          break;
        case DateRangePickerView.year:
        case DateRangePickerView.decade:
        case DateRangePickerView.century:
          {
            if (widget.picker.allowViewNavigation) {
              _mouseHoverPosition.value =
                  HoveringDetails(range, Offset(xPosition, yPosition));
              return;
            }

            index = _getYearViewIndex(xPosition, yPosition);
            final int viewCount = widget.enableMultiView ? 2 : 1;
            if (index == -1 || index >= 12 * viewCount) {
              return;
            }

            date = widget.visibleDates[index];
            if (!DateRangePickerHelper.isBetweenMinMaxDateCell(
                date,
                widget.picker.minDate,
                widget.picker.maxDate,
                widget.picker.enablePastDates,
                widget.controller.view,
                widget.picker.isHijri)) {
              _mouseHoverPosition.value = null;
              return;
            }
          }
      }

      /// Ignore the selection date while the extendable range enabled and the
      /// selection value is disabled based on extendable direction on
      /// mouse hovering.
      if (DateRangePickerHelper.isDisableDirectionDate(
          _pickerStateDetails.selectedRange,
          date,
          widget.picker.extendableRangeSelectionDirection,
          pickerView,
          widget.picker.isHijri)) {
        _mouseHoverPosition.value = null;
        return;
      }

      dynamic rangeStartDate = _pickerStateDetails.selectedRange.startDate;
      dynamic rangeEndDate = _pickerStateDetails.selectedRange.endDate ?? date;
      if (_pickerStateDetails.selectedRange.startDate != null &&
          _pickerStateDetails.selectedRange.endDate != null &&
          isSameOrAfterDate(rangeStartDate, date) &&
          isSameOrBeforeDate(rangeEndDate, date)) {
        rangeStartDate = null;
        rangeEndDate = null;
      } else if (date.isAfter(rangeEndDate) == true) {
        rangeStartDate = rangeEndDate;
        rangeEndDate = date;
      } else if (date.isBefore(rangeStartDate) == true) {
        rangeEndDate = rangeStartDate;
        rangeStartDate = date;
      }

      range = widget.picker.isHijri
          ? HijriDateRange(rangeStartDate, rangeEndDate)
          : PickerDateRange(rangeStartDate, rangeEndDate);
    }

    _mouseHoverPosition.value =
        HoveringDetails(range, Offset(xPosition, yPosition));
  }

  void _pointerEnterEvent(PointerEnterEvent event) {
    _updateMouseHover(event.position);
  }

  void _pointerHoverEvent(PointerHoverEvent event) {
    _updateMouseHover(event.position);
  }

  void _pointerExitEvent(PointerExitEvent event) {
    _mouseHoverPosition.value = null;
  }

  Widget _addYearView(Locale locale, SfLocalizations localizations) {
    _yearView = _getYearView(locale, localizations);
    return RepaintBoundary(
      child: _yearView,
    );
  }

  YearView _getYearView(Locale locale, SfLocalizations localizations) {
    return YearView(
        widget.visibleDates,
        widget.picker.yearCellStyle,
        widget.picker.minDate,
        widget.picker.maxDate,
        widget.picker.enablePastDates,
        widget.picker.todayHighlightColor,
        widget.picker.selectionShape,
        widget.picker.monthFormat,
        widget.isRtl,
        widget.datePickerTheme,
        locale,
        _mouseHoverPosition,
        widget.enableMultiView,
        widget.picker.viewSpacing,
        widget.picker.selectionTextStyle,
        widget.picker.rangeTextStyle,
        widget.picker.selectionColor,
        widget.picker.startRangeSelectionColor,
        widget.picker.endRangeSelectionColor,
        widget.picker.rangeSelectionColor,
        widget.picker.selectionMode,
        widget.picker.selectionRadius,
        ValueNotifier<bool>(false),
        widget.textScaleFactor,
        widget.picker.allowViewNavigation,
        widget.picker.cellBuilder,
        widget.getPickerStateDetails,
        DateRangePickerHelper.getPickerView(widget.controller.view),
        widget.picker.isHijri,
        localizations,
        widget.picker.navigationDirection,
        widget.width,
        widget.height,
        widget.disableDatePredicates,
        widget.picker.extendableRangeSelectionDirection);
  }

  GestureDragStartCallback? _getDragStartCallback() {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    //// return drag start start event when selection mode as range or multi range.
    if ((pickerView != DateRangePickerView.month &&
            widget.picker.allowViewNavigation) ||
        !_isSwipeInteractionEnabled(
            widget.picker.monthViewSettings.enableSwipeSelection,
            widget.picker.navigationMode)) {
      return null;
    }

    if (widget.picker.selectionMode != DateRangePickerSelectionMode.range &&
        widget.picker.selectionMode !=
            DateRangePickerSelectionMode.multiRange &&
        widget.picker.selectionMode !=
            DateRangePickerSelectionMode.extendableRange) {
      return null;
    }

    switch (pickerView) {
      case DateRangePickerView.month:
        {
          return _dragStart;
        }
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        return _dragStartOnYear;
    }
  }

  GestureDragUpdateCallback? _getDragUpdateCallback() {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    //// return drag update start event when selection mode as range or multi range.
    if ((pickerView != DateRangePickerView.month &&
            widget.picker.allowViewNavigation) ||
        !_isSwipeInteractionEnabled(
            widget.picker.monthViewSettings.enableSwipeSelection,
            widget.picker.navigationMode)) {
      return null;
    }

    if (widget.picker.selectionMode != DateRangePickerSelectionMode.range &&
        widget.picker.selectionMode !=
            DateRangePickerSelectionMode.multiRange &&
        widget.picker.selectionMode !=
            DateRangePickerSelectionMode.extendableRange) {
      return null;
    }

    switch (pickerView) {
      case DateRangePickerView.month:
        {
          return _dragUpdate;
        }
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          return _dragUpdateOnYear;
        }
    }
  }

  int _getYearViewIndex(double xPosition, double yPosition) {
    int rowIndex, columnIndex;
    int columnCount = YearView.maxColumnCount;
    double width = widget.width;
    double height = widget.height;
    int rowCount = YearView.maxRowCount;
    int index = -1;
    if (widget.enableMultiView) {
      switch (widget.picker.navigationDirection) {
        case DateRangePickerNavigationDirection.horizontal:
          {
            columnCount *= 2;
            width -= widget.picker.viewSpacing;
            if (xPosition > width / 2 &&
                xPosition < (width / 2) + widget.picker.viewSpacing) {
              return index;
            } else if (xPosition > width / 2) {
              xPosition -= widget.picker.viewSpacing;
            }
          }
          break;
        case DateRangePickerNavigationDirection.vertical:
          {
            rowCount *= 2;
            height = (height - widget.picker.viewSpacing) / 2;
            if (yPosition > height &&
                yPosition < height + widget.picker.viewSpacing) {
              return index;
            } else if (yPosition > height) {
              yPosition -= widget.picker.viewSpacing;
            }
          }
      }
    }

    final double cellWidth = width / columnCount;
    final double cellHeight = height / YearView.maxRowCount;
    if (yPosition < 0 || xPosition < 0) {
      return index;
    }

    rowIndex = xPosition ~/ cellWidth;
    if (rowIndex >= columnCount) {
      rowIndex = columnCount - 1;
    } else if (rowIndex < 0) {
      return index;
    }

    columnIndex = yPosition ~/ cellHeight;
    if (columnIndex >= rowCount) {
      columnIndex = rowCount - 1;
    } else if (columnIndex < 0) {
      return index;
    }

    if (widget.isRtl) {
      rowIndex = DateRangePickerHelper.getRtlIndex(columnCount, rowIndex);
      if (widget.enableMultiView &&
          widget.picker.navigationDirection ==
              DateRangePickerNavigationDirection.vertical) {
        if (columnIndex > YearView.maxColumnCount) {
          columnIndex -= YearView.maxColumnCount + 1;
        } else {
          columnIndex += YearView.maxColumnCount + 1;
        }
      }
    }

    const int totalDatesCount = YearView.maxRowCount * YearView.maxColumnCount;
    index = (columnIndex * YearView.maxColumnCount) +
        ((rowIndex ~/ YearView.maxColumnCount) * totalDatesCount) +
        (rowIndex % YearView.maxColumnCount);
    return widget.enableMultiView &&
            DateRangePickerHelper.isLeadingCellDate(
                index,
                (index ~/ totalDatesCount) * totalDatesCount,
                widget.visibleDates,
                widget.controller.view)
        ? -1
        : index;
  }

  int _getSelectedIndex(double xPosition, double yPosition) {
    final double weekNumberPanelWidth =
        DateRangePickerHelper.getWeekNumberPanelWidth(
            widget.picker.monthViewSettings.showWeekNumber,
            widget.width,
            _isMobilePlatform);
    int rowIndex, columnIndex;
    double width = widget.width - weekNumberPanelWidth;
    double height = widget.height;
    int index = -1;
    int totalColumnCount = DateTime.daysPerWeek;
    final int rowCount = DateRangePickerHelper.getNumberOfWeeksInView(
        widget.picker.monthViewSettings, widget.picker.isHijri);
    int totalRowCount = rowCount;
    if (widget.enableMultiView) {
      switch (widget.picker.navigationDirection) {
        case DateRangePickerNavigationDirection.horizontal:
          {
            width = width - widget.picker.viewSpacing - weekNumberPanelWidth;
            final double singleViewWidth = width / 2;
            totalColumnCount *= 2;

            /// return -1 while the position in between the view spacing.
            if (xPosition > weekNumberPanelWidth + singleViewWidth &&
                xPosition <
                    singleViewWidth +
                        widget.picker.viewSpacing +
                        (2 * weekNumberPanelWidth)) {
              return index;
            } else if (xPosition > singleViewWidth + weekNumberPanelWidth) {
              /// Subtract the 2nd view week number panel width and in between
              /// spacing while the position is after the 1st view.
              xPosition =
                  xPosition - widget.picker.viewSpacing - weekNumberPanelWidth;
            }
          }
          break;
        case DateRangePickerNavigationDirection.vertical:
          {
            height = (height - widget.picker.viewSpacing) / 2;
            totalRowCount *= 2;

            /// return -1 while the position in between the view spacing.
            if (yPosition > height &&
                yPosition < height + widget.picker.viewSpacing) {
              return index;
            } else if (yPosition > height) {
              yPosition -= widget.picker.viewSpacing;
            }
          }
      }
    }

    if (yPosition < 0 ||
        (!widget.isRtl && xPosition < weekNumberPanelWidth) ||
        (widget.isRtl && xPosition > widget.width - weekNumberPanelWidth)) {
      return index;
    }

    /// In RTL the week number panel will render on the right side hence,
    /// we didn't consider the week number panel width in rtl.
    if (!widget.isRtl) {
      xPosition -= weekNumberPanelWidth;
    }

    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);

    double viewHeaderHeight =
        widget.picker.monthViewSettings.viewHeaderHeight as double;
    if (pickerView == DateRangePickerView.month &&
        widget.picker.navigationDirection ==
            DateRangePickerNavigationDirection.vertical) {
      viewHeaderHeight = 0;
    }

    final double cellWidth = width / totalColumnCount;
    final double cellHeight = (height - viewHeaderHeight) / rowCount;
    rowIndex = (xPosition / cellWidth).truncate();
    if (rowIndex >= totalColumnCount) {
      rowIndex = totalColumnCount - 1;
    } else if (rowIndex < 0) {
      return index;
    }

    columnIndex = (yPosition / cellHeight).truncate();
    if (columnIndex >= totalRowCount) {
      columnIndex = totalRowCount - 1;
    } else if (columnIndex < 0) {
      return index;
    }

    if (widget.isRtl) {
      rowIndex = DateRangePickerHelper.getRtlIndex(totalColumnCount, rowIndex);
      if (widget.enableMultiView &&
          widget.picker.navigationDirection ==
              DateRangePickerNavigationDirection.vertical) {
        if (columnIndex >= rowCount) {
          columnIndex -= rowCount;
        } else {
          columnIndex += rowCount;
        }
      }
    }

    index = (columnIndex * DateTime.daysPerWeek) +
        ((rowIndex ~/ DateTime.daysPerWeek) *
            (totalRowCount * DateTime.daysPerWeek)) +
        (rowIndex % DateTime.daysPerWeek);
    return index;
  }

  void _dragStart(DragStartDetails details) {
    //// Set drag start value as false, identifies the start date of the range not updated.
    _isDragStart = false;
    widget.getPickerStateDetails(_pickerStateDetails);
    final double xPosition = details.localPosition.dx;
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    double yPosition = details.localPosition.dy;
    if (pickerView == DateRangePickerView.month &&
        widget.picker.navigationDirection ==
            DateRangePickerNavigationDirection.horizontal) {
      yPosition = details.localPosition.dy -
          widget.picker.monthViewSettings.viewHeaderHeight;
    }

    final int index = _getSelectedIndex(xPosition, yPosition);
    if (index == -1) {
      return;
    }

    final dynamic selectedDate = widget.visibleDates[index];
    if (!DateRangePickerHelper.isEnabledDate(
        widget.picker.minDate,
        widget.picker.maxDate,
        widget.picker.enablePastDates,
        selectedDate,
        widget.picker.isHijri)) {
      return;
    }

    final int currentMonthIndex = _getCurrentDateIndex(index);
    if (!DateRangePickerHelper.isDateAsCurrentMonthDate(
        widget.visibleDates[currentMonthIndex],
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.picker.monthViewSettings, widget.picker.isHijri),
        DateRangePickerHelper.canShowLeadingAndTrailingDates(
            widget.picker.monthViewSettings, widget.picker.isHijri),
        selectedDate,
        widget.picker.isHijri)) {
      return;
    }

    if (DateRangePickerHelper.isDateWithInVisibleDates(widget.visibleDates,
            widget.picker.monthViewSettings.blackoutDates, selectedDate) ||
        DateRangePickerHelper.isDateWithInVisibleDates(
            widget.visibleDates, widget.disableDatePredicates, selectedDate)) {
      return;
    }

    /// Ignore the selection date while the extendable range enabled and the
    /// selection value is disabled based on extendable direction on
    /// drag selection.
    if (widget.picker.selectionMode ==
            DateRangePickerSelectionMode.extendableRange &&
        _pickerStateDetails.selectedRange != null &&
        DateRangePickerHelper.isDisableDirectionDate(
            _pickerStateDetails.selectedRange,
            selectedDate,
            widget.picker.extendableRangeSelectionDirection,
            pickerView,
            widget.picker.isHijri)) {
      return;
    }

    //// Set drag start value as false, identifies the start date of the range updated.
    _isDragStart = true;
    _updateSelectedRangesOnDragStart(_monthView, selectedDate);

    /// Assign start date of the range as previous selected date.
    _previousSelectedDate = selectedDate;

    widget.updatePickerStateDetails(_pickerStateDetails);
    _monthView!.selectionNotifier.value = !_monthView!.selectionNotifier.value;
  }

  void _dragUpdate(DragUpdateDetails details) {
    widget.getPickerStateDetails(_pickerStateDetails);
    final double xPosition = details.localPosition.dx;
    double yPosition = details.localPosition.dy;
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    if (pickerView == DateRangePickerView.month &&
        widget.picker.navigationDirection ==
            DateRangePickerNavigationDirection.horizontal) {
      yPosition = details.localPosition.dy -
          widget.picker.monthViewSettings.viewHeaderHeight;
    }

    final int index = _getSelectedIndex(xPosition, yPosition);
    if (index == -1) {
      return;
    }

    final dynamic selectedDate = widget.visibleDates[index];
    if (!DateRangePickerHelper.isEnabledDate(
        widget.picker.minDate,
        widget.picker.maxDate,
        widget.picker.enablePastDates,
        selectedDate,
        widget.picker.isHijri)) {
      return;
    }

    final int currentMonthIndex = _getCurrentDateIndex(index);
    if (!DateRangePickerHelper.isDateAsCurrentMonthDate(
        widget.visibleDates[currentMonthIndex],
        DateRangePickerHelper.getNumberOfWeeksInView(
            widget.picker.monthViewSettings, widget.picker.isHijri),
        DateRangePickerHelper.canShowLeadingAndTrailingDates(
            widget.picker.monthViewSettings, widget.picker.isHijri),
        selectedDate,
        widget.picker.isHijri)) {
      return;
    }

    if (DateRangePickerHelper.isDateWithInVisibleDates(widget.visibleDates,
            widget.picker.monthViewSettings.blackoutDates, selectedDate) ||
        DateRangePickerHelper.isDateWithInVisibleDates(
            widget.visibleDates, widget.disableDatePredicates, selectedDate)) {
      return;
    }

    /// Ignore the selection date while the extendable range enabled and the
    /// selection value is disabled based on extendable direction on
    /// drag selection.
    if (widget.picker.selectionMode ==
            DateRangePickerSelectionMode.extendableRange &&
        _pickerStateDetails.selectedRange != null &&
        DateRangePickerHelper.isDisableDirectionDate(
            _pickerStateDetails.selectedRange,
            selectedDate,
            widget.picker.extendableRangeSelectionDirection,
            pickerView,
            widget.picker.isHijri)) {
      return;
    }

    _updateSelectedRangesOnDragUpdateMonth(selectedDate);

    /// Assign start date of the range as previous selected date.
    _previousSelectedDate = selectedDate;

    //// Set drag start value as false, identifies the start date of the range updated.
    _isDragStart = true;
    widget.updatePickerStateDetails(_pickerStateDetails);
    _monthView!.selectionNotifier.value = !_monthView!.selectionNotifier.value;
  }

  void _updateSelectedRangesOnDragStart(dynamic view, dynamic selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
      case DateRangePickerSelectionMode.multiple:
        break;
      case DateRangePickerSelectionMode.range:
        {
          _pickerStateDetails.selectedRange = widget.picker.isHijri
              ? HijriDateRange(selectedDate, null)
              : PickerDateRange(selectedDate, null);
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          _pickerStateDetails.selectedRanges ??= <dynamic>[];
          _pickerStateDetails.selectedRanges!.add(widget.picker.isHijri
              ? HijriDateRange(selectedDate, null)
              : PickerDateRange(selectedDate, null));
          _removeInterceptRanges(
              _pickerStateDetails.selectedRanges,
              _pickerStateDetails.selectedRanges![
                  _pickerStateDetails.selectedRanges!.length - 1]);
        }
        break;
      case DateRangePickerSelectionMode.extendableRange:
        _drawExtendableRangeSelection(selectedDate);
    }
  }

  void _updateSelectedRangesOnDragUpdateMonth(dynamic selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
      case DateRangePickerSelectionMode.multiple:
        break;
      case DateRangePickerSelectionMode.range:
        {
          //// Check the start date of the range updated or not, if not updated then create the new range.
          if (!_isDragStart) {
            _pickerStateDetails.selectedRange = widget.picker.isHijri
                ? HijriDateRange(selectedDate, null)
                : PickerDateRange(selectedDate, null);
          } else {
            if (_pickerStateDetails.selectedRange != null &&
                _pickerStateDetails.selectedRange.startDate != null) {
              final dynamic updatedRange = _getSelectedRangeOnDragUpdate(
                  _pickerStateDetails.selectedRange, selectedDate);
              if (DateRangePickerHelper.isRangeEquals(
                  _pickerStateDetails.selectedRange, updatedRange)) {
                return;
              }

              _pickerStateDetails.selectedRange = updatedRange;
            } else {
              _pickerStateDetails.selectedRange = widget.picker.isHijri
                  ? HijriDateRange(selectedDate, null)
                  : PickerDateRange(selectedDate, null);
            }
          }
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          _pickerStateDetails.selectedRanges ??= <dynamic>[];
          final int count = _pickerStateDetails.selectedRanges!.length;
          dynamic lastRange;
          if (count > 0) {
            lastRange = _pickerStateDetails.selectedRanges![count - 1];
          }

          //// Check the start date of the range updated or not, if not updated then create the new range.
          if (!_isDragStart) {
            _pickerStateDetails.selectedRanges!.add(widget.picker.isHijri
                ? HijriDateRange(selectedDate, null)
                : PickerDateRange(selectedDate, null));
          } else {
            if (lastRange != null && lastRange.startDate != null) {
              final dynamic updatedRange =
                  _getSelectedRangeOnDragUpdate(lastRange, selectedDate);
              if (DateRangePickerHelper.isRangeEquals(
                  lastRange, updatedRange)) {
                return;
              }

              _pickerStateDetails.selectedRanges![count - 1] = updatedRange;
            } else {
              _pickerStateDetails.selectedRanges!.add(widget.picker.isHijri
                  ? HijriDateRange(selectedDate, null)
                  : PickerDateRange(selectedDate, null));
            }
          }

          _removeInterceptRanges(
              _pickerStateDetails.selectedRanges,
              _pickerStateDetails.selectedRanges![
                  _pickerStateDetails.selectedRanges!.length - 1]);
        }
        break;
      case DateRangePickerSelectionMode.extendableRange:
        _drawExtendableRangeSelection(selectedDate);
    }
  }

  /// Return the range that start date is before of end date in month view.
  dynamic _getSelectedRangeOnDragUpdate(
      dynamic previousRange, dynamic selectedDate) {
    final dynamic previousRangeStartDate = previousRange.startDate;
    final dynamic previousRangeEndDate =
        previousRange.endDate ?? previousRange.startDate;
    dynamic rangeStartDate = previousRangeStartDate;
    dynamic rangeEndDate = selectedDate;
    if (isSameDate(previousRangeStartDate, _previousSelectedDate)) {
      if (isSameOrBeforeDate(previousRangeEndDate, rangeEndDate)) {
        rangeStartDate = selectedDate;
        rangeEndDate = previousRangeEndDate;
      } else {
        rangeStartDate = previousRangeEndDate;
        rangeEndDate = selectedDate;
      }
    } else if (isSameDate(previousRangeEndDate, _previousSelectedDate)) {
      if (isSameOrAfterDate(previousRangeStartDate, rangeEndDate)) {
        rangeStartDate = previousRangeStartDate;
        rangeEndDate = selectedDate;
      } else {
        rangeStartDate = selectedDate;
        rangeEndDate = previousRangeStartDate;
      }
    }

    if (widget.picker.isHijri) {
      return HijriDateRange(rangeStartDate, rangeEndDate);
    }

    return PickerDateRange(rangeStartDate, rangeEndDate);
  }

  /// Return the range that start date is before of end date in year view.
  dynamic _getSelectedRangeOnDragUpdateYear(
      dynamic previousRange, dynamic selectedDate) {
    final dynamic previousRangeStartDate = previousRange.startDate;
    final dynamic previousRangeEndDate =
        previousRange.endDate ?? previousRange.startDate;
    dynamic rangeStartDate = previousRangeStartDate;
    dynamic rangeEndDate = selectedDate;
    if (DateRangePickerHelper.isSameCellDates(previousRangeStartDate,
        _previousSelectedDate, widget.controller.view)) {
      if (_isSameOrBeforeDateCell(previousRangeEndDate, rangeEndDate)) {
        rangeStartDate = selectedDate;
        rangeEndDate = previousRangeEndDate;
      } else {
        rangeStartDate = previousRangeEndDate;
        rangeEndDate = selectedDate;
      }
    } else if (DateRangePickerHelper.isSameCellDates(
        previousRangeEndDate, _previousSelectedDate, widget.controller.view)) {
      if (_isSameOrAfterDateCell(previousRangeStartDate, rangeEndDate)) {
        rangeStartDate = previousRangeStartDate;
        rangeEndDate = selectedDate;
      } else {
        rangeStartDate = selectedDate;
        rangeEndDate = previousRangeStartDate;
      }
    }

    rangeEndDate = DateRangePickerHelper.getLastDate(
        rangeEndDate, widget.controller.view, widget.picker.isHijri);
    if (widget.picker.maxDate != null) {
      rangeEndDate = rangeEndDate.isAfter(widget.picker.maxDate) == true
          ? widget.picker.maxDate
          : rangeEndDate;
    }

    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    rangeStartDate = DateRangePickerHelper.getFirstDate(
        rangeStartDate, widget.picker.isHijri, pickerView);
    if (widget.picker.minDate != null) {
      rangeStartDate = rangeStartDate.isBefore(widget.picker.minDate) == true
          ? widget.picker.minDate
          : rangeStartDate;
    }

    if (widget.picker.isHijri) {
      return HijriDateRange(rangeStartDate, rangeEndDate);
    }

    return PickerDateRange(rangeStartDate, rangeEndDate);
  }

  /// Check the date cell is same or before of the max date cell.
  /// If picker max date as 20-12-2020 and selected date value as 21-12-2020
  /// then the year view need to highlight selection because year view only
  /// consider the month value(max month as 12).
  /// Note: This method not applicable for month view.
  bool _isSameOrBeforeDateCell(dynamic currentMaxDate, dynamic currentDate) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    if (pickerView == DateRangePickerView.year) {
      return (currentDate.month <= currentMaxDate.month == true &&
              currentDate.year == currentMaxDate.year) ||
          currentDate.year < currentMaxDate.year == true;
    } else if (pickerView == DateRangePickerView.decade) {
      return currentDate.year <= currentMaxDate.year == true;
    } else if (pickerView == DateRangePickerView.century) {
      return (currentDate.year ~/ 10) <= (currentMaxDate.year ~/ 10) == true;
    }

    return false;
  }

  /// Check the date cell is same or after of the min date cell.
  /// If picker min date as 20-12-2020 and selected date value as 10-12-2020
  /// then the year view need to highlight selection because year view only
  /// consider the month value(min month as 12).
  /// Note: This method not applicable for month view.
  bool _isSameOrAfterDateCell(dynamic currentMinDate, dynamic currentDate) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    if (pickerView == DateRangePickerView.year) {
      return (currentDate.month >= currentMinDate.month == true &&
              currentDate.year == currentMinDate.year) ||
          currentDate.year > currentMinDate.year == true;
    } else if (pickerView == DateRangePickerView.decade) {
      return currentDate.year >= currentMinDate.year == true;
    } else if (pickerView == DateRangePickerView.century) {
      return (currentDate.year ~/ 10) >= (currentMinDate.year ~/ 10) == true;
    }

    return false;
  }

  void _updateSelectedRangesOnDragUpdateYear(dynamic selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
      case DateRangePickerSelectionMode.multiple:
        break;
      case DateRangePickerSelectionMode.range:
        {
          //// Check the start date of the range updated or not, if not updated then create the new range.
          if (!_isDragStart) {
            _pickerStateDetails.selectedRange = widget.picker.isHijri
                ? HijriDateRange(selectedDate, null)
                : PickerDateRange(selectedDate, null);
          } else {
            if (_pickerStateDetails.selectedRange != null &&
                _pickerStateDetails.selectedRange.startDate != null) {
              final dynamic updatedRange = _getSelectedRangeOnDragUpdateYear(
                  _pickerStateDetails.selectedRange, selectedDate);
              if (DateRangePickerHelper.isRangeEquals(
                  _pickerStateDetails.selectedRange, updatedRange)) {
                return;
              }

              _pickerStateDetails.selectedRange = updatedRange;
            } else {
              _pickerStateDetails.selectedRange = widget.picker.isHijri
                  ? HijriDateRange(selectedDate, null)
                  : PickerDateRange(selectedDate, null);
            }
          }
        }
        break;
      case DateRangePickerSelectionMode.multiRange:
        {
          _pickerStateDetails.selectedRanges ??= <dynamic>[];
          final int count = _pickerStateDetails.selectedRanges!.length;
          dynamic lastRange;
          if (count > 0) {
            lastRange = _pickerStateDetails.selectedRanges![count - 1];
          }

          //// Check the start date of the range updated or not, if not updated then create the new range.
          if (!_isDragStart) {
            _pickerStateDetails.selectedRanges!.add(widget.picker.isHijri
                ? HijriDateRange(selectedDate, null)
                : PickerDateRange(selectedDate, null));
          } else {
            if (lastRange != null && lastRange.startDate != null) {
              final dynamic updatedRange =
                  _getSelectedRangeOnDragUpdateYear(lastRange, selectedDate);
              if (DateRangePickerHelper.isRangeEquals(
                  lastRange, updatedRange)) {
                return;
              }

              _pickerStateDetails.selectedRanges![count - 1] = updatedRange;
            } else {
              _pickerStateDetails.selectedRanges!.add(widget.picker.isHijri
                  ? HijriDateRange(selectedDate, null)
                  : PickerDateRange(selectedDate, null));
            }
          }

          _removeInterceptRanges(
              _pickerStateDetails.selectedRanges,
              _pickerStateDetails.selectedRanges![
                  _pickerStateDetails.selectedRanges!.length - 1]);
        }
        break;
      case DateRangePickerSelectionMode.extendableRange:
        _drawExtendableRangeSelection(selectedDate);
    }
  }

  void _dragStartOnYear(DragStartDetails details) {
    //// Set drag start value as false, identifies the start date of the range not updated.
    _isDragStart = false;
    widget.getPickerStateDetails(_pickerStateDetails);
    final int index =
        _getYearViewIndex(details.localPosition.dx, details.localPosition.dy);
    if (index == -1) {
      return;
    }

    final dynamic selectedDate = widget.visibleDates[index];
    if (!DateRangePickerHelper.isBetweenMinMaxDateCell(
            selectedDate,
            widget.picker.minDate,
            widget.picker.maxDate,
            widget.picker.enablePastDates,
            widget.controller.view,
            widget.picker.isHijri) ||
        DateRangePickerHelper.isDateWithInVisibleDates(
            widget.visibleDates, widget.disableDatePredicates, selectedDate)) {
      return;
    }

    /// Ignore the selection date while the extendable range enabled and the
    /// selection value is disabled based on extendable direction on
    /// drag selection.
    if (widget.picker.selectionMode ==
            DateRangePickerSelectionMode.extendableRange &&
        _pickerStateDetails.selectedRange != null) {
      final DateRangePickerView pickerView =
          DateRangePickerHelper.getPickerView(widget.controller.view);
      if (DateRangePickerHelper.isDisableDirectionDate(
          _pickerStateDetails.selectedRange,
          selectedDate,
          widget.picker.extendableRangeSelectionDirection,
          pickerView,
          widget.picker.isHijri)) {
        return;
      }
    }

    //// Set drag start value as false, identifies the start date of the range updated.
    _isDragStart = true;
    _updateSelectedRangesOnDragStart(_yearView, selectedDate);
    _previousSelectedDate = selectedDate;

    widget.updatePickerStateDetails(_pickerStateDetails);
    _yearView!.selectionNotifier.value = !_yearView!.selectionNotifier.value;
  }

  void _dragUpdateOnYear(DragUpdateDetails details) {
    widget.getPickerStateDetails(_pickerStateDetails);
    final int index =
        _getYearViewIndex(details.localPosition.dx, details.localPosition.dy);
    if (index == -1) {
      return;
    }

    final dynamic selectedDate = widget.visibleDates[index];
    if (!DateRangePickerHelper.isBetweenMinMaxDateCell(
            selectedDate,
            widget.picker.minDate,
            widget.picker.maxDate,
            widget.picker.enablePastDates,
            widget.controller.view,
            widget.picker.isHijri) ||
        DateRangePickerHelper.isDateWithInVisibleDates(
            widget.visibleDates, widget.disableDatePredicates, selectedDate)) {
      return;
    }

    /// Ignore the selection date while the extendable range enabled and the
    /// selection value is disabled based on extendable direction on
    /// drag selection.
    if (widget.picker.selectionMode ==
            DateRangePickerSelectionMode.extendableRange &&
        _pickerStateDetails.selectedRange != null) {
      final DateRangePickerView pickerView =
          DateRangePickerHelper.getPickerView(widget.controller.view);
      if (DateRangePickerHelper.isDisableDirectionDate(
          _pickerStateDetails.selectedRange,
          selectedDate,
          widget.picker.extendableRangeSelectionDirection,
          pickerView,
          widget.picker.isHijri)) {
        return;
      }
    }

    _updateSelectedRangesOnDragUpdateYear(selectedDate);
    _previousSelectedDate = selectedDate;

    //// Set drag start value as false, identifies the start date of the range updated.
    _isDragStart = true;
    widget.updatePickerStateDetails(_pickerStateDetails);
    _yearView!.selectionNotifier.value = !_yearView!.selectionNotifier.value;
  }

  void _handleTouch(Offset details, TapUpDetails tapUpDetails) {
    widget.getPickerStateDetails(_pickerStateDetails);
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    if (pickerView == DateRangePickerView.month) {
      final int index = _getSelectedIndex(details.dx, details.dy);
      if (index == -1) {
        return;
      }

      final dynamic selectedDate = widget.visibleDates[index];
      if (!DateRangePickerHelper.isEnabledDate(
          widget.picker.minDate,
          widget.picker.maxDate,
          widget.picker.enablePastDates,
          selectedDate,
          widget.picker.isHijri)) {
        return;
      }

      final int currentMonthIndex = _getCurrentDateIndex(index);
      if (!DateRangePickerHelper.isDateAsCurrentMonthDate(
          widget.visibleDates[currentMonthIndex],
          DateRangePickerHelper.getNumberOfWeeksInView(
              widget.picker.monthViewSettings, widget.picker.isHijri),
          DateRangePickerHelper.canShowLeadingAndTrailingDates(
              widget.picker.monthViewSettings, widget.picker.isHijri),
          selectedDate,
          widget.picker.isHijri)) {
        return;
      }

      if (DateRangePickerHelper.isDateWithInVisibleDates(widget.visibleDates,
              widget.picker.monthViewSettings.blackoutDates, selectedDate) ||
          DateRangePickerHelper.isDateWithInVisibleDates(widget.visibleDates,
              widget.disableDatePredicates, selectedDate)) {
        return;
      }

      /// Ignore the selection date while the extendable range enabled and the
      /// selection value is disabled based on extendable direction on
      /// month view touch selection.
      if (widget.picker.selectionMode ==
              DateRangePickerSelectionMode.extendableRange &&
          _pickerStateDetails.selectedRange != null &&
          DateRangePickerHelper.isDisableDirectionDate(
              _pickerStateDetails.selectedRange,
              selectedDate,
              widget.picker.extendableRangeSelectionDirection,
              pickerView,
              widget.picker.isHijri)) {
        return;
      }

      _drawSelection(selectedDate);
      widget.updatePickerStateDetails(_pickerStateDetails);
      _monthView!.selectionNotifier.value =
          !_monthView!.selectionNotifier.value;
    }
  }

  int _getCurrentDateIndex(int index) {
    final int datesCount = DateRangePickerHelper.getNumberOfWeeksInView(
            widget.picker.monthViewSettings, widget.picker.isHijri) *
        DateTime.daysPerWeek;
    int currentMonthIndex = datesCount ~/ 2;
    if (widget.enableMultiView && index >= datesCount) {
      currentMonthIndex += datesCount;
    }

    return currentMonthIndex;
  }

  void _drawSingleSelectionForYear(dynamic selectedDate) {
    if (widget.picker.toggleDaySelection &&
        DateRangePickerHelper.isSameCellDates(selectedDate,
            _pickerStateDetails.selectedDate, widget.controller.view)) {
      selectedDate = null;
    }

    _pickerStateDetails.selectedDate = selectedDate;
  }

  void _drawMultipleSelectionForYear(dynamic selectedDate) {
    int selectedIndex = -1;
    if (_pickerStateDetails.selectedDates != null &&
        _pickerStateDetails.selectedDates!.isNotEmpty) {
      selectedIndex = DateRangePickerHelper.getDateCellIndex(
          _pickerStateDetails.selectedDates!,
          selectedDate,
          widget.controller.view);
    }

    if (selectedIndex == -1) {
      _pickerStateDetails.selectedDates ??= <dynamic>[];
      _pickerStateDetails.selectedDates!.add(selectedDate);
    } else {
      _pickerStateDetails.selectedDates!.removeAt(selectedIndex);
    }
  }

  void _drawRangeSelectionForYear(dynamic selectedDate) {
    if (_pickerStateDetails.selectedRange != null &&
        _pickerStateDetails.selectedRange.startDate != null &&
        (_pickerStateDetails.selectedRange.endDate == null ||
            DateRangePickerHelper.isSameCellDates(
                _pickerStateDetails.selectedRange.startDate,
                _pickerStateDetails.selectedRange.endDate,
                widget.controller.view))) {
      dynamic startDate = _pickerStateDetails.selectedRange.startDate;
      dynamic endDate = selectedDate;
      if (startDate.isAfter(endDate) == true) {
        final dynamic temp = startDate;
        startDate = endDate;
        endDate = temp;
      }

      endDate = DateRangePickerHelper.getLastDate(
          endDate, widget.controller.view, widget.picker.isHijri);
      if (widget.picker.maxDate != null) {
        endDate = endDate.isAfter(widget.picker.maxDate) == true
            ? widget.picker.maxDate
            : endDate;
      }

      if (widget.picker.minDate != null) {
        startDate = startDate.isBefore(widget.picker.minDate) == true
            ? widget.picker.minDate
            : startDate;
      }

      _pickerStateDetails.selectedRange = widget.picker.isHijri
          ? HijriDateRange(startDate, endDate)
          : PickerDateRange(startDate, endDate);
    } else {
      _pickerStateDetails.selectedRange = widget.picker.isHijri
          ? HijriDateRange(selectedDate, null)
          : PickerDateRange(selectedDate, null);
    }

    _lastSelectedDate = selectedDate;
  }

  void _drawRangesSelectionForYear(dynamic selectedDate) {
    _pickerStateDetails.selectedRanges ??= <dynamic>[];
    int count = _pickerStateDetails.selectedRanges!.length;
    dynamic lastRange;
    if (count > 0) {
      lastRange = _pickerStateDetails.selectedRanges![count - 1];
    }

    if (lastRange != null &&
        lastRange.startDate != null &&
        (lastRange.endDate == null ||
            DateRangePickerHelper.isSameCellDates(lastRange.startDate,
                lastRange.endDate, widget.controller.view))) {
      dynamic startDate = lastRange.startDate;
      dynamic endDate = selectedDate;
      if (startDate.isAfter(endDate) == true) {
        final dynamic temp = startDate;
        startDate = endDate;
        endDate = temp;
      }

      endDate = DateRangePickerHelper.getLastDate(
          endDate, widget.controller.view, widget.picker.isHijri);
      if (widget.picker.maxDate != null) {
        endDate = endDate.isAfter(widget.picker.maxDate) == true
            ? widget.picker.maxDate
            : endDate;
      }

      if (widget.picker.minDate != null) {
        startDate = startDate.isBefore(widget.picker.minDate) == true
            ? widget.picker.minDate
            : startDate;
      }

      final dynamic newRange = widget.picker.isHijri
          ? HijriDateRange(startDate, endDate)
          : PickerDateRange(startDate, endDate);
      _pickerStateDetails.selectedRanges![count - 1] = newRange;
    } else {
      _pickerStateDetails.selectedRanges!.add(widget.picker.isHijri
          ? HijriDateRange(selectedDate, null)
          : PickerDateRange(selectedDate, null));
    }

    count = _pickerStateDetails.selectedRanges!.length;
    _removeInterceptRanges(
        _pickerStateDetails.selectedRanges,
        _pickerStateDetails
            .selectedRanges![_pickerStateDetails.selectedRanges!.length - 1]);
    lastRange = _pickerStateDetails
        .selectedRanges![_pickerStateDetails.selectedRanges!.length - 1];
    if (count != _pickerStateDetails.selectedRanges!.length &&
        (lastRange.endDate == null ||
            DateRangePickerHelper.isSameCellDates(lastRange.endDate,
                lastRange.startDate, widget.controller.view))) {
      _pickerStateDetails.selectedRanges!.removeLast();
    }
  }

  void _drawYearCellSelection(dynamic selectedDate) {
    switch (widget.picker.selectionMode) {
      case DateRangePickerSelectionMode.single:
        _drawSingleSelectionForYear(selectedDate);
        break;
      case DateRangePickerSelectionMode.multiple:
        _drawMultipleSelectionForYear(selectedDate);
        break;
      case DateRangePickerSelectionMode.range:
        _drawRangeSelectionForYear(selectedDate);
        break;
      case DateRangePickerSelectionMode.multiRange:
        _drawRangesSelectionForYear(selectedDate);
        break;
      case DateRangePickerSelectionMode.extendableRange:
        _drawExtendableRangeSelection(selectedDate);
    }
  }

  void _handleYearPanelSelection(Offset details) {
    final int selectedIndex = _getYearViewIndex(details.dx, details.dy);
    final int viewCount = widget.enableMultiView ? 2 : 1;
    if (selectedIndex == -1 || selectedIndex >= 12 * viewCount) {
      return;
    }

    final dynamic date = widget.visibleDates[selectedIndex];
    widget.getPickerStateDetails(_pickerStateDetails);
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    if (!widget.picker.allowViewNavigation) {
      if (!DateRangePickerHelper.isBetweenMinMaxDateCell(
              date,
              widget.picker.minDate,
              widget.picker.maxDate,
              widget.picker.enablePastDates,
              widget.controller.view,
              widget.picker.isHijri) ||
          DateRangePickerHelper.isDateWithInVisibleDates(
              widget.visibleDates, widget.disableDatePredicates, date)) {
        return;
      }

      /// Ignore the selection date while the extendable range enabled and the
      /// selection value is disabled based on extendable direction on
      /// year view touch selection.
      if (widget.picker.selectionMode ==
              DateRangePickerSelectionMode.extendableRange &&
          _pickerStateDetails.selectedRange != null &&
          DateRangePickerHelper.isDisableDirectionDate(
              _pickerStateDetails.selectedRange,
              date,
              widget.picker.extendableRangeSelectionDirection,
              pickerView,
              widget.picker.isHijri)) {
        return;
      }

      _drawYearCellSelection(date);
      widget.updatePickerStateDetails(_pickerStateDetails);
      _yearView!.selectionNotifier.value = !_yearView!.selectionNotifier.value;
      return;
    }

    switch (pickerView) {
      case DateRangePickerView.month:
        break;
      case DateRangePickerView.century:
        {
          final int year = (date.year as int) ~/ 10;
          final int minYear = (widget.picker.minDate.year as int) ~/ 10;
          final int maxYear = (widget.picker.maxDate.year as int) ~/ 10;
          if (year < minYear || year > maxYear) {
            return;
          }

          _pickerStateDetails.view = DateRangePickerView.decade;
        }
        break;
      case DateRangePickerView.decade:
        {
          final int year = date.year as int;
          final int minYear = widget.picker.minDate.year as int;
          final int maxYear = widget.picker.maxDate.year as int;

          if (year < minYear || year > maxYear) {
            return;
          }
          _pickerStateDetails.view = DateRangePickerView.year;
        }
        break;
      case DateRangePickerView.year:
        {
          final int year = date.year as int;
          final int month = date.month as int;
          final int minYear = widget.picker.minDate.year as int;
          final int maxYear = widget.picker.maxDate.year as int;
          final int minMonth = widget.picker.minDate.month as int;
          final int maxMonth = widget.picker.maxDate.month as int;

          if ((year < minYear || (year == minYear && month < minMonth)) ||
              (year > maxYear || (year == maxYear && month > maxMonth))) {
            return;
          }

          _pickerStateDetails.view = DateRangePickerView.month;
        }
    }

    _pickerStateDetails.currentDate = date;
    widget.updatePickerStateDetails(_pickerStateDetails);
  }

  void _drawSingleSelectionForMonth(dynamic selectedDate) {
    if (widget.picker.toggleDaySelection &&
        isSameDate(selectedDate, _pickerStateDetails.selectedDate)) {
      selectedDate = null;
    }

    _pickerStateDetails.selectedDate = selectedDate;
  }

  void _drawMultipleSelectionForMonth(dynamic selectedDate) {
    final int selectedIndex = DateRangePickerHelper.isDateIndexInCollection(
        _pickerStateDetails.selectedDates, selectedDate);
    if (selectedIndex == -1) {
      _pickerStateDetails.selectedDates ??= <dynamic>[];
      _pickerStateDetails.selectedDates!.add(selectedDate);
    } else {
      _pickerStateDetails.selectedDates!.removeAt(selectedIndex);
    }
  }

  /// Draws the extendable selection, by extending the already available range
  /// selection.
  void _drawExtendableRangeSelection(dynamic selectedDate) {
    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);
    if (_pickerStateDetails.selectedRange == null) {
      dynamic startDate = selectedDate;
      if (pickerView != DateRangePickerView.month &&
          widget.picker.minDate != null) {
        startDate = startDate.isBefore(widget.picker.minDate) == true
            ? widget.picker.minDate
            : startDate;
      }

      _pickerStateDetails.selectedRange = widget.picker.isHijri
          ? HijriDateRange(startDate, null)
          : PickerDateRange(startDate, null);
      _lastSelectedDate = selectedDate;
      return;
    }

    dynamic startDate = _pickerStateDetails.selectedRange.startDate;
    dynamic endDate = _pickerStateDetails.selectedRange.endDate ?? startDate;

    if (selectedDate.isAfter(endDate) == true) {
      endDate = selectedDate;
    } else if (selectedDate.isBefore(startDate) == true) {
      startDate = selectedDate;
    } else if (selectedDate.isAfter(startDate) == true &&
        selectedDate.isBefore(endDate) == true) {
      if (widget.picker.selectionMode ==
              DateRangePickerSelectionMode.extendableRange &&
          widget.picker.extendableRangeSelectionDirection !=
              ExtendableRangeSelectionDirection.both) {
        if (widget.picker.extendableRangeSelectionDirection ==
            ExtendableRangeSelectionDirection.forward) {
          endDate = selectedDate;
        } else if (widget.picker.extendableRangeSelectionDirection ==
            ExtendableRangeSelectionDirection.backward) {
          startDate = selectedDate;
        }
      } else {
        final int overAllDifference =
            endDate.difference(startDate).inDays as int;
        final int selectedDateIndex =
            selectedDate.difference(startDate).inDays as int;
        if (selectedDateIndex > overAllDifference / 2) {
          endDate = selectedDate;
        } else {
          startDate = selectedDate;
        }
      }
    }

    if (DateRangePickerHelper.isSameCellDates(startDate, endDate, pickerView)) {
      return;
    }

    if (pickerView != DateRangePickerView.month) {
      endDate = DateRangePickerHelper.getLastDate(
          endDate, widget.controller.view, widget.picker.isHijri);
      if (widget.picker.maxDate != null) {
        endDate = endDate.isAfter(widget.picker.maxDate) == true
            ? widget.picker.maxDate
            : endDate;
      }

      startDate = DateRangePickerHelper.getFirstDate(
          startDate, widget.picker.isHijri, pickerView);
      if (widget.picker.minDate != null) {
        startDate = startDate.isBefore(widget.picker.minDate) == true
            ? widget.picker.minDate
            : startDate;
      }
    }

    _pickerStateDetails.selectedRange = widget.picker.isHijri
        ? HijriDateRange(startDate, endDate)
        : PickerDateRange(startDate, endDate);
    _lastSelectedDate = selectedDate;

    _mouseHoverPosition.value = HoveringDetails(null, null);
  }

  void _drawRangeSelectionForMonth(dynamic selectedDate) {
    if (_pickerStateDetails.selectedRange != null &&
        _pickerStateDetails.selectedRange.startDate != null &&
        (_pickerStateDetails.selectedRange.endDate == null ||
            isSameDate(_pickerStateDetails.selectedRange.startDate,
                _pickerStateDetails.selectedRange.endDate))) {
      dynamic startDate = _pickerStateDetails.selectedRange.startDate;
      dynamic endDate = selectedDate;
      if (startDate.isAfter(endDate) == true) {
        final dynamic temp = startDate;
        startDate = endDate;
        endDate = temp;
      }

      _pickerStateDetails.selectedRange = widget.picker.isHijri
          ? HijriDateRange(startDate, endDate)
          : PickerDateRange(startDate, endDate);
    } else {
      _pickerStateDetails.selectedRange = widget.picker.isHijri
          ? HijriDateRange(selectedDate, null)
          : PickerDateRange(selectedDate, null);
    }

    _lastSelectedDate = selectedDate;
  }

  void _drawRangesSelectionForMonth(dynamic selectedDate) {
    _pickerStateDetails.selectedRanges ??= <dynamic>[];
    int count = _pickerStateDetails.selectedRanges!.length;
    dynamic lastRange;
    if (count > 0) {
      lastRange = _pickerStateDetails.selectedRanges![count - 1];
    }

    if (lastRange != null &&
        lastRange.startDate != null &&
        (lastRange.endDate == null ||
            isSameDate(lastRange.startDate, lastRange.endDate))) {
      dynamic startDate = lastRange.startDate;
      dynamic endDate = selectedDate;
      if (startDate.isAfter(endDate) == true) {
        final dynamic temp = startDate;
        startDate = endDate;
        endDate = temp;
      }

      final dynamic newRange = widget.picker.isHijri
          ? HijriDateRange(startDate, endDate)
          : PickerDateRange(startDate, endDate);
      _pickerStateDetails.selectedRanges![count - 1] = newRange;
    } else {
      _pickerStateDetails.selectedRanges!.add(widget.picker.isHijri
          ? HijriDateRange(selectedDate, null)
          : PickerDateRange(selectedDate, null));
    }

    count = _pickerStateDetails.selectedRanges!.length;
    _removeInterceptRanges(
        _pickerStateDetails.selectedRanges,
        _pickerStateDetails
            .selectedRanges![_pickerStateDetails.selectedRanges!.length - 1]);
    lastRange = _pickerStateDetails
        .selectedRanges![_pickerStateDetails.selectedRanges!.length - 1];
    if (count != _pickerStateDetails.selectedRanges!.length &&
        (lastRange.endDate == null ||
            isSameDate(lastRange.endDate, lastRange.startDate))) {
      _pickerStateDetails.selectedRanges!.removeLast();
    }
  }

  int? _removeInterceptRangesForMonth(dynamic range, dynamic startDate,
      dynamic endDate, int i, dynamic selectedRangeValue) {
    if (range != null &&
        !DateRangePickerHelper.isRangeEquals(range, selectedRangeValue) &&
        ((range.startDate != null &&
                ((startDate != null &&
                        isSameDate(range.startDate, startDate)) ||
                    (endDate != null &&
                        isSameDate(range.startDate, endDate)))) ||
            (range.endDate != null &&
                ((startDate != null && isSameDate(range.endDate, startDate)) ||
                    (endDate != null && isSameDate(range.endDate, endDate)))) ||
            (range.startDate != null &&
                range.endDate != null &&
                ((startDate != null &&
                        isDateWithInDateRange(
                            range.startDate, range.endDate, startDate)) ||
                    (endDate != null &&
                        isDateWithInDateRange(
                            range.startDate, range.endDate, endDate)))) ||
            (startDate != null &&
                endDate != null &&
                ((range.startDate != null &&
                        isDateWithInDateRange(
                            startDate, endDate, range.startDate)) ||
                    (range.endDate != null &&
                        isDateWithInDateRange(
                            startDate, endDate, range.endDate)))) ||
            (range.startDate != null &&
                range.endDate != null &&
                startDate != null &&
                endDate != null &&
                ((range.startDate.isAfter(startDate) == true &&
                        range.endDate.isBefore(endDate) == true) ||
                    (range.endDate.isAfter(startDate) == true &&
                        range.startDate.isBefore(endDate) == true))))) {
      return i;
    }

    return null;
  }

  int? _removeInterceptRangesForYear(dynamic range, dynamic startDate,
      dynamic endDate, int i, dynamic selectedRangeValue) {
    if (range == null ||
        DateRangePickerHelper.isRangeEquals(range, selectedRangeValue)) {
      return null;
    }

    /// Check the range start date equal to start date or end date.
    if (range.startDate != null &&
        ((startDate != null &&
                DateRangePickerHelper.isSameCellDates(
                    range.startDate, startDate, widget.controller.view)) ||
            (endDate != null &&
                DateRangePickerHelper.isSameCellDates(
                    range.startDate, endDate, widget.controller.view)))) {
      return i;
    }

    /// Check the range end date equal to start date or end date.
    if (range.endDate != null &&
        ((startDate != null &&
                DateRangePickerHelper.isSameCellDates(
                    range.endDate, startDate, widget.controller.view)) ||
            (endDate != null &&
                DateRangePickerHelper.isSameCellDates(
                    range.endDate, endDate, widget.controller.view)))) {
      return i;
    }

    /// Check the start date or end date placed inside the range.
    if (range.startDate != null &&
        range.endDate != null &&
        ((startDate != null &&
                _isDateWithInYearRange(
                    range.startDate, range.endDate, startDate)) ||
            (endDate != null &&
                _isDateWithInYearRange(
                    range.startDate, range.endDate, endDate)))) {
      return i;
    }

    /// Check the range start or end date placed in between the start
    /// and end date.
    if (startDate != null &&
        endDate != null &&
        ((range.startDate != null &&
                _isDateWithInYearRange(startDate, endDate, range.startDate)) ||
            (range.endDate != null &&
                _isDateWithInYearRange(startDate, endDate, range.endDate)))) {
      return i;
    }

    /// Check the range in between the start and end date or the start and end
    /// date placed inside th range.
    if (range.startDate != null &&
        range.endDate != null &&
        startDate != null &&
        endDate != null &&
        ((range.startDate.isAfter(startDate) == true &&
                range.endDate.isBefore(endDate) == true) ||
            (range.endDate.isAfter(startDate) == true &&
                range.startDate.isBefore(endDate) == true))) {
      return i;
    }

    return null;
  }

  /// Check whether the date is in between the start and end date value.
  bool _isDateWithInYearRange(
      dynamic startDate, dynamic endDate, dynamic date) {
    if (startDate == null || endDate == null || date == null) {
      return false;
    }

    final DateRangePickerView pickerView =
        DateRangePickerHelper.getPickerView(widget.controller.view);

    /// Check the start date as before of end date, if not then swap
    /// the start and end date values.
    if (startDate.isAfter(endDate) == true) {
      final dynamic temp = startDate;
      startDate = endDate;
      endDate = temp;
    }

    /// Check the date is equal or after of the start date and
    /// the date is equal or before of the end date.
    if ((DateRangePickerHelper.isSameCellDates(endDate, date, pickerView) ||
            endDate.isAfter(date) == true) &&
        (DateRangePickerHelper.isSameCellDates(startDate, date, pickerView) ||
            startDate.isBefore(date) == true)) {
      return true;
    }

    return false;
  }

  void _removeInterceptRanges(
      List<dynamic>? selectedRanges, dynamic selectedRangeValue) {
    if (selectedRanges == null ||
        selectedRanges.isEmpty ||
        selectedRangeValue == null) {
      return;
    }

    dynamic startDate = selectedRangeValue.startDate;
    dynamic endDate = selectedRangeValue.endDate;
    if (startDate != null &&
        endDate != null &&
        startDate.isAfter(endDate) == true) {
      final dynamic temp = startDate;
      startDate = endDate;
      endDate = temp;
    }

    final List<int> interceptIndex = <int>[];
    for (int i = 0; i < selectedRanges.length; i++) {
      final dynamic range = selectedRanges[i];
      //// The below condition validate the following scenarios
      //// Check the range as not null and range is not a new selected range,
      //// Check the range start date as equal with selected range start or end date
      //// Check the range end date as equal with selected range start or end date
      //// Check the selected start date placed in between range start or end date
      //// Check the selected end date placed in between range start or end date
      //// Check the selected range occupies the range.
      int? index;
      switch (_pickerStateDetails.view) {
        case DateRangePickerView.month:
          {
            index = _removeInterceptRangesForMonth(
                range, startDate, endDate, i, selectedRangeValue);
          }
          break;
        case DateRangePickerView.year:
        case DateRangePickerView.decade:
        case DateRangePickerView.century:
          {
            index = _removeInterceptRangesForYear(
                range, startDate, endDate, i, selectedRangeValue);
          }
      }
      if (index != null) {
        interceptIndex.add(index);
      }
    }

    interceptIndex.sort();
    for (int i = interceptIndex.length - 1; i >= 0; i--) {
      selectedRanges.removeAt(interceptIndex[i]);
    }
  }
}

String _getMonthHeaderText(
    int startIndex,
    int endIndex,
    List<dynamic> dates,
    int middleIndex,
    int datesCount,
    bool isHijri,
    int numberOfWeeksInView,
    String? monthFormat,
    bool enableMultiView,
    DateRangePickerHeaderStyle headerStyle,
    DateRangePickerNavigationDirection navigationDirection,
    Locale locale,
    SfLocalizations localizations) {
  if ((!isHijri && numberOfWeeksInView != 6) &&
      dates[startIndex].month != dates[endIndex].month) {
    final String monthTextFormat =
        monthFormat == null || monthFormat.isEmpty ? 'MMM' : monthFormat;
    int endIndex = dates.length - 1;
    if (enableMultiView && headerStyle.textAlign == TextAlign.center) {
      endIndex = endIndex;
    }
    final String startText =
        // ignore: lines_longer_than_80_chars
        '${DateFormat(monthTextFormat, locale.toString()).format(dates[startIndex])} ${dates[startIndex].year}';
    final String endText =
        // ignore: lines_longer_than_80_chars
        '${DateFormat(monthTextFormat, locale.toString()).format(dates[endIndex])} ${dates[endIndex].year}';
    if (startText == endText) {
      return startText;
    }

    return '$startText - $endText';
  } else {
    final String monthTextFormat = monthFormat == null || monthFormat.isEmpty
        ? enableMultiView &&
                navigationDirection ==
                    DateRangePickerNavigationDirection.vertical
            ? 'MMM'
            : 'MMMM'
        : monthFormat;
    String text;
    dynamic middleDate = dates[middleIndex];
    if (isHijri) {
      text =
          // ignore: lines_longer_than_80_chars
          '${DateRangePickerHelper.getHijriMonthText(middleDate, localizations, monthTextFormat)} ${middleDate.year}';
    } else {
      text =
          '${DateFormat(monthTextFormat, locale.toString()).format(middleDate)}'
          ' ${middleDate.year}';
    }

    /// To restrict the double header when the number of weeks in view given
    /// and the dates were the same month.
    if (enableMultiView &&
        navigationDirection == DateRangePickerNavigationDirection.vertical &&
        numberOfWeeksInView != 6 &&
        dates[startIndex].month == dates[endIndex].month) {
      return text;
    }

    if ((enableMultiView && headerStyle.textAlign != TextAlign.center) ||
        (enableMultiView &&
            navigationDirection ==
                DateRangePickerNavigationDirection.vertical)) {
      middleDate = dates[datesCount + middleIndex];
      if (isHijri) {
        // ignore: lines_longer_than_80_chars
        return '$text - ${DateRangePickerHelper.getHijriMonthText(middleDate, localizations, monthTextFormat)} ${middleDate.year}';
      } else {
        // ignore: lines_longer_than_80_chars
        return '$text - ${DateFormat(monthTextFormat, locale.toString()).format(middleDate)} ${middleDate.year}';
      }
    }

    return text;
  }
}

String _getHeaderText(
    List<dynamic> dates,
    DateRangePickerView view,
    int index,
    bool isHijri,
    int numberOfWeeksInView,
    String? monthFormat,
    bool enableMultiView,
    DateRangePickerHeaderStyle headerStyle,
    DateRangePickerNavigationDirection navigationDirection,
    Locale locale,
    SfLocalizations localizations) {
  final int count = enableMultiView ? 2 : 1;
  final int datesCount = dates.length ~/ count;
  final int startIndex = index * datesCount;
  final int endIndex = ((index + 1) * datesCount) - 1;
  final int middleIndex = startIndex + (datesCount ~/ 2);
  switch (view) {
    case DateRangePickerView.month:
      {
        return _getMonthHeaderText(
            startIndex,
            endIndex,
            dates,
            middleIndex,
            datesCount,
            isHijri,
            numberOfWeeksInView,
            monthFormat,
            enableMultiView,
            headerStyle,
            navigationDirection,
            locale,
            localizations);
      }
    case DateRangePickerView.year:
      {
        final dynamic date = dates[middleIndex];
        if ((enableMultiView && headerStyle.textAlign != TextAlign.center) ||
            (enableMultiView &&
                navigationDirection ==
                    DateRangePickerNavigationDirection.vertical)) {
          return '${date.year} - ${dates[datesCount + middleIndex].year}';
        }

        return date.year.toString();
      }
    case DateRangePickerView.decade:
      {
        final int year = ((dates[middleIndex].year as int) ~/ 10) * 10;
        if ((enableMultiView && headerStyle.textAlign != TextAlign.center) ||
            (enableMultiView &&
                navigationDirection ==
                    DateRangePickerNavigationDirection.vertical)) {
          // ignore: lines_longer_than_80_chars
          return '$year - ${((dates[datesCount + middleIndex].year ~/ 10) * 10) + 9}';
        }

        return '$year - ${year + 9}';
      }
    case DateRangePickerView.century:
      {
        final int year = ((dates[middleIndex].year as int) ~/ 100) * 100;
        if ((enableMultiView && headerStyle.textAlign != TextAlign.center) ||
            (enableMultiView &&
                navigationDirection ==
                    DateRangePickerNavigationDirection.vertical)) {
          // ignore: lines_longer_than_80_chars
          return '$year - ${((dates[datesCount + middleIndex].year ~/ 100) * 100) + 99}';
        }

        return '$year - ${year + 99}';
      }
  }
}

Size _getTextWidgetWidth(
    String text, double height, double width, BuildContext context,
    {required TextStyle style,
    double widthPadding = 10,
    double heightPadding = 10}) {
  /// Create new text with it style.
  final Widget textWidget = Text(
    text,
    style: style,
    maxLines: 1,
    softWrap: false,
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.left,
  ).build(context);

  final RichText? richTextWidget = textWidget is RichText ? textWidget : null;

  /// Create and layout the render object based on
  /// allocated width and height.
  final RenderParagraph renderObject =
      richTextWidget!.createRenderObject(context);
  renderObject.layout(BoxConstraints(
    minWidth: width,
    maxWidth: width,
    minHeight: height,
    maxHeight: height,
  ));

  /// Get the size of text by using render object.
  final List<TextBox> textBox = renderObject.getBoxesForSelection(
      TextSelection(baseOffset: 0, extentOffset: text.length));
  double textWidth = 0;
  double textHeight = 0;
  for (final TextBox box in textBox) {
    textWidth += box.right - box.left;
    final double currentBoxHeight = box.bottom - box.top;
    textHeight = textHeight > currentBoxHeight ? textHeight : currentBoxHeight;
  }

  return Size(textWidth + widthPadding, textHeight + heightPadding);
}

bool _isSwipeInteractionEnabled(
    bool enableSwipeSelection, DateRangePickerNavigationMode navigationMode) {
  return enableSwipeSelection &&
      navigationMode != DateRangePickerNavigationMode.scroll;
}

bool _isMultiViewEnabled(_SfDateRangePicker picker) {
  return picker.enableMultiView &&
      picker.navigationMode != DateRangePickerNavigationMode.scroll;
}
