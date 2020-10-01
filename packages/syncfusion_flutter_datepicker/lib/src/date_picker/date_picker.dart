part of datepicker;

/// The number of days in a week
const int _kNumberOfDaysInWeek = 7;

typedef _UpdatePickerState = void Function(
    _PickerStateArgs _updatePickerStateDetails);

/// Signature for callback that reports that a current view or current visible
/// date range changes.
///
/// The visible date range and the visible view which visible on view when the
/// view changes available in the [DateRangePickerViewChangedArgs].
///
/// Used by [SfDateRangePicker.onViewChanged].
typedef DateRangePickerViewChangedCallback = void Function(
    DateRangePickerViewChangedArgs dateRangePickerViewChangedArgs);

/// Signature for callback that reports that a new dates or date ranges
/// selected.
///
/// The dates or ranges that selected when the selection changes available in
/// the [DateRangePickerSelectionChangedArgs].
///
/// Used by [SfDateRangePicker.onSelectionChanged].
typedef DateRangePickerSelectionChangedCallback = void Function(
    DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs);

// method that raise the picker selection changed call back with the given
// parameters.
void _raiseSelectionChangedCallback(SfDateRangePicker picker, {dynamic value}) {
  if (picker.onSelectionChanged == null) {
    return;
  }

  picker.onSelectionChanged(DateRangePickerSelectionChangedArgs(value));
}

// method that raises the visible dates changed call back with the given
// parameters.
void _raisePickerViewChangedCallback(SfDateRangePicker picker,
    {PickerDateRange visibleDateRange, DateRangePickerView view}) {
  if (picker.onViewChanged == null) {
    return;
  }

  picker.onViewChanged(DateRangePickerViewChangedArgs(visibleDateRange, view));
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
/// to different views, or tap the [SfCalendar] header to navigate to the next
/// different view in the hierarchy.
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
/// See also:
/// * [SfDateRangePickerThemeData]
/// * [DateRangePickerHeaderStyle]
/// * [DateRangePickerViewHeaderStyle]
/// * [DateRangePickerMonthViewSettings]
/// * [DateRangePickerYearCellStyle]
/// * [DateRangePickerMonthCellStyle]
///
/// ``` dart
///class MyApp extends StatefulWidget {
///  @override
///  MyAppState createState() => MyAppState();
//}
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
class SfDateRangePicker extends StatefulWidget {
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
  SfDateRangePicker({
    Key key,
    DateRangePickerView view,
    this.selectionMode = DateRangePickerSelectionMode.single,
    this.headerHeight = 40,
    this.todayHighlightColor,
    this.backgroundColor,
    DateTime initialSelectedDate,
    List<DateTime> initialSelectedDates,
    PickerDateRange initialSelectedRange,
    List<PickerDateRange> initialSelectedRanges,
    this.toggleDaySelection = false,
    this.enablePastDates = true,
    this.showNavigationArrow = false,
    this.selectionShape = DateRangePickerSelectionShape.circle,
    this.navigationDirection = DateRangePickerNavigationDirection.horizontal,
    this.controller,
    this.onViewChanged,
    this.onSelectionChanged,
    DateRangePickerHeaderStyle headerStyle,
    DateRangePickerYearCellStyle yearCellStyle,
    DateRangePickerMonthViewSettings monthViewSettings,
    DateTime initialDisplayDate,
    DateTime minDate,
    DateTime maxDate,
    DateRangePickerMonthCellStyle monthCellStyle,
    bool allowViewNavigation,
    bool enableMultiView,
    double viewSpacing,
    this.selectionRadius,
    this.selectionColor,
    this.startRangeSelectionColor,
    this.endRangeSelectionColor,
    this.rangeSelectionColor,
    this.selectionTextStyle,
    this.rangeTextStyle,
    this.monthFormat,
  })  : headerStyle = headerStyle ??
            (enableMultiView != null && enableMultiView
                ? DateRangePickerHeaderStyle(textAlign: TextAlign.center)
                : DateRangePickerHeaderStyle()),
        yearCellStyle = yearCellStyle ?? DateRangePickerYearCellStyle(),
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
            ? controller.view
            : (view ?? DateRangePickerView.month),
        monthViewSettings =
            monthViewSettings ?? DateRangePickerMonthViewSettings(),
        initialDisplayDate =
            controller != null && controller.displayDate != null
                ? controller.displayDate
                : (initialDisplayDate ??
                    DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day, 08, 45, 0)),
        minDate = minDate ?? DateTime(1900, 01, 01),
        maxDate = maxDate ?? DateTime(2100, 12, 31),
        monthCellStyle = monthCellStyle ?? DateRangePickerMonthCellStyle(),
        enableMultiView = enableMultiView ?? false,
        viewSpacing = viewSpacing ??
            (enableMultiView != null && enableMultiView ? 20 : 0),
        allowViewNavigation = allowViewNavigation ?? true,
        super(key: key);

  /// Defines the view for the [SfDateRangePicker].
  ///
  /// Default to `DateRangePickerView.month`.
  ///
  /// _Note:_ If the [controller] and it's [controller.view] property is not
  ///  null, then this property will be ignored and widget will display the view
  ///  described in [controller.view] property.
  ///
  /// Also refer [DateRangePickerView].
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
  /// See also: [DateRangePickerMonthViewSettings.enableSwipeSelection].
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
  /// See also: [DateRangePickerHeaderStyle]
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
  final Color todayHighlightColor;

  /// The color to fill the background of the [SfDateRangePicker].
  ///
  /// Defaults to null.
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
  final Color backgroundColor;

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
  final TextStyle selectionTextStyle;

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
  final TextStyle rangeTextStyle;

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
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          selectionColor: Colors.red,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color selectionColor;

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
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          startRangeSelectionColor: Colors.red,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color startRangeSelectionColor;

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
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          rangeSelectionColor: Colors.red.withOpacity(0.4),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color rangeSelectionColor;

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
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///          endRangeSelectionColor: Colors.red,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// ```
  final Color endRangeSelectionColor;

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
  /// See also: [DateRangePickerMonthViewSettings]
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
  ///                           fontSize: 15, Colors.black)),
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
  /// See also: [DateRangePickerYearCellStyle].
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
  /// See also: [DateRangePickerMonthCellStyle]
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
  final DateTime initialSelectedDate;

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
  /// See also:
  /// [initialDisplayDate].
  /// [maxDate].
  /// [controller.displayDate].
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

  /// The minimum date as much as the [SfDateRangePicker] will navigate.
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
  /// [initialDisplayDate].
  /// [minDate].
  /// [controller.displayDate].
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
  /// ``` dart
  ///
  ///Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  //          view: DateRangePickerView.month,
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
  final List<DateTime> initialSelectedDates;

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
  /// See also: [PickerDateRange].
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
  final PickerDateRange initialSelectedRange;

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
  /// See also: [PickerDateRange].
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
  final List<PickerDateRange> initialSelectedRanges;

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
  /// See also: [DateRangePickerSelectionMode]
  ///
  /// Defaults to null.
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
  ///  DateRangePickerController _pickerController;
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController = DateRangePickerController();
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
  final DateRangePickerController controller;

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
  final String monthFormat;

  /// Called when the current visible view or visible date range changes.
  ///
  /// The visible date range and the visible view which visible on view when the
  /// view changes available in the [DateRangePickerViewChangedArgs].
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
  final DateRangePickerViewChangedCallback onViewChanged;

  /// Called when the new dates or date ranges selected.
  ///
  /// The dates or ranges that selected when the selection changes available in
  /// the [DateRangePickerSelectionChangedArgs].
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
  final DateRangePickerSelectionChangedCallback onSelectionChanged;

  @override
  _SfDateRangePickerState createState() => _SfDateRangePickerState();
}

class _SfDateRangePickerState extends State<SfDateRangePicker> {
  List<DateTime> _currentViewVisibleDates;
  DateTime _currentDate, _selectedDate;
  double _minWidth, _minHeight;
  double _textScaleFactor;
  ValueNotifier<List<DateTime>> _headerVisibleDates;
  List<DateTime> _selectedDates;
  PickerDateRange _selectedRange;
  List<PickerDateRange> _selectedRanges;
  GlobalKey<_PickerScrollViewState> _scrollViewKey;
  DateRangePickerView _view;
  bool _isRtl;
  DateRangePickerController _controller;
  Locale _locale;
  SfDateRangePickerThemeData _datePickerTheme;

  @override
  void initState() {
    _isRtl = false;
    _scrollViewKey = GlobalKey<_PickerScrollViewState>();
    //// Update initial values to controller.
    _initPickerController();
    _initNavigation();
    //// Update initial value to state variables.
    _updateSelectionValues();
    _view = _controller.view;
    _updateCurrentVisibleDates();
    _headerVisibleDates =
        ValueNotifier<List<DateTime>>(_currentViewVisibleDates);
    _controller.addPropertyChangedListener(_pickerValueChangedListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _textScaleFactor = MediaQuery.of(context).textScaleFactor ?? 1.0;
    final TextDirection direction = Directionality.of(context);
    // default width value will be device width when the widget placed inside a
    // infinity width widget
    _minWidth = MediaQuery.of(context).size.width;
    // default height for the widget when the widget placed inside a infinity
    // height widget
    _minHeight = 300;
    _locale = Localizations.localeOf(context);
    final SfDateRangePickerThemeData pickerTheme =
        SfDateRangePickerTheme.of(context);
    final ThemeData themeData = Theme.of(context);
    _datePickerTheme = pickerTheme.copyWith(
        todayTextStyle: pickerTheme.todayTextStyle != null &&
                pickerTheme.todayTextStyle.color == null
            ? pickerTheme.todayTextStyle.copyWith(color: themeData.accentColor)
            : pickerTheme.todayTextStyle,
        todayCellTextStyle: pickerTheme.todayCellTextStyle != null &&
                pickerTheme.todayCellTextStyle.color == null
            ? pickerTheme.todayCellTextStyle
                .copyWith(color: themeData.accentColor)
            : pickerTheme.todayCellTextStyle,
        selectionColor: pickerTheme.selectionColor ?? themeData.accentColor,
        startRangeSelectionColor:
            pickerTheme.startRangeSelectionColor ?? themeData.accentColor,
        rangeSelectionColor: pickerTheme.rangeSelectionColor ??
            themeData.accentColor.withOpacity(0.1),
        endRangeSelectionColor:
            pickerTheme.endRangeSelectionColor ?? themeData.accentColor,
        todayHighlightColor:
            pickerTheme.todayHighlightColor ?? themeData.accentColor);
    _isRtl = direction != null && direction == TextDirection.rtl;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfDateRangePicker oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller
          ?.removePropertyChangedListener(_pickerValueChangedListener);
      if (widget.controller != null) {
        _controller.selectedDate = widget.controller.selectedDate;
        _controller.selectedDates = _cloneList(widget.controller.selectedDates);
        _controller.selectedRange = widget.controller.selectedRange;
        _controller.selectedRanges =
            _cloneList(widget.controller.selectedRanges);
        _controller.view = widget.controller.view;
        _controller.displayDate = widget.controller.displayDate ?? _currentDate;
        _currentDate = getValidDate(
            widget.minDate, widget.maxDate, _controller.displayDate);
      } else {
        _initPickerController();
      }

      _controller.view ??= _view;
      _controller.addPropertyChangedListener(_pickerValueChangedListener);
      _initNavigation();
      _updateSelectionValues();
      _view = _controller.view;
    }

    if (oldWidget.selectionMode != widget.selectionMode) {
      _updateSelectionValues();
    }

    if (oldWidget.minDate != widget.minDate ||
        oldWidget.maxDate != widget.maxDate) {
      _currentDate = getValidDate(widget.minDate, widget.maxDate, _currentDate);
    }

    if (widget.monthViewSettings.numberOfWeeksInView !=
        oldWidget.monthViewSettings.numberOfWeeksInView) {
      _currentDate = _updateCurrentDate(oldWidget);
      _controller.displayDate = _currentDate;
    }

    if (oldWidget.controller != widget.controller ||
        widget.controller == null) {
      super.didUpdateWidget(oldWidget);
      return;
    }

    if (oldWidget.controller.selectedDate != widget.controller.selectedDate) {
      _selectedDate = _controller.selectedDate;
    }

    if (oldWidget.controller.selectedDates != widget.controller.selectedDates) {
      _selectedDates = _cloneList(_controller.selectedDates);
    }

    if (oldWidget.controller.selectedRange != widget.controller.selectedRange) {
      _selectedRange = _controller.selectedRange;
    }

    if (oldWidget.controller.selectedRanges !=
        widget.controller.selectedRanges) {
      _selectedRanges = _cloneList(_controller.selectedRanges);
    }

    if (oldWidget.controller.view != widget.controller.view) {
      _view = _controller.view;
      _currentDate = _updateCurrentDate(oldWidget);
      _controller.displayDate = _currentDate;
    }

    if (oldWidget.controller.displayDate != widget.controller.displayDate &&
        widget.controller.displayDate != null) {
      _currentDate =
          getValidDate(widget.minDate, widget.maxDate, _controller.displayDate);
      _controller.displayDate = _currentDate;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double top = 0, height;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      _minWidth = constraints.maxWidth == double.infinity
          ? _minWidth
          : constraints.maxWidth;
      _minHeight = constraints.maxHeight == double.infinity
          ? _minHeight
          : constraints.maxHeight;

      height = _minHeight - widget.headerHeight;
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
        child: _addChildren(top, height, _minWidth),
      );
    });
  }

  @override
  void dispose() {
    _controller.removePropertyChangedListener(_pickerValueChangedListener);
    _controller._backward = null;
    _controller._forward = null;
    super.dispose();
  }

  void _initNavigation() {
    _controller._forward = _moveToNextView;
    _controller._backward = _moveToPreviousView;
  }

  void _initPickerController() {
    _controller = widget.controller ?? DateRangePickerController();
    _controller.selectedDate = widget.initialSelectedDate;
    _controller.selectedDates = _cloneList(widget.initialSelectedDates);
    _controller.selectedRange = widget.initialSelectedRange;
    _controller.selectedRanges = _cloneList(widget.initialSelectedRanges);
    _controller.view = widget.view;
    _currentDate =
        getValidDate(widget.minDate, widget.maxDate, widget.initialDisplayDate);
    _controller.displayDate = _currentDate;
  }

  void _updateSelectionValues() {
    _selectedDate = _controller.selectedDate;
    _selectedDates = _cloneList(_controller.selectedDates);
    _selectedRange = _controller.selectedRange;
    _selectedRanges = _cloneList(_controller.selectedRanges);
  }

  void _pickerValueChangedListener(String value) {
    if (value == _kSelectedDateString) {
      _raiseSelectionChangedCallback(widget, value: _controller.selectedDate);
      if (!mounted || isSameDate(_selectedDate, _controller.selectedDate)) {
        return;
      }

      setState(() {
        _selectedDate = _controller.selectedDate;
      });
    } else if (value == _kSelectedDatesString) {
      _raiseSelectionChangedCallback(widget, value: _controller.selectedDates);
      if (!mounted ||
          _isDateCollectionEquals(_selectedDates, _controller.selectedDates)) {
        return;
      }

      setState(() {
        _selectedDates = _cloneList(_controller.selectedDates);
      });
    } else if (value == _kSelectedRangeString) {
      _raiseSelectionChangedCallback(widget, value: _controller.selectedRange);
      if (!mounted ||
          _isRangeEquals(_selectedRange, _controller.selectedRange)) {
        return;
      }

      setState(() {
        _selectedRange = _controller.selectedRange;
      });
    } else if (value == _kSelectedRangesString) {
      _raiseSelectionChangedCallback(widget, value: _controller.selectedRanges);
      if (!mounted ||
          _isDateRangesEquals(_selectedRanges, _controller.selectedRanges)) {
        return;
      }

      setState(() {
        _selectedRanges = _cloneList(_controller.selectedRanges);
      });
    } else if (value == _kViewString) {
      if (!mounted || _view == _controller.view) {
        return;
      }

      setState(() {
        _view = _controller.view;
        _scrollViewKey.currentState._position = 0.0;
        _scrollViewKey.currentState._children.clear();
        _scrollViewKey.currentState._updateVisibleDates();
      });
    } else if (value == _kDisplayDateString) {
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
        _updateCurrentVisibleDates();
      });
    }
  }

  bool _checkDateWithInVisibleDates(DateTime date) {
    switch (_controller.view) {
      case DateRangePickerView.month:
        {
          if (widget.monthViewSettings.numberOfWeeksInView != 6) {
            return isDateWithInDateRange(
                _currentViewVisibleDates[0],
                _currentViewVisibleDates[_currentViewVisibleDates.length - 1],
                date);
          } else {
            final DateTime currentMonth = _currentViewVisibleDates[
                _currentViewVisibleDates.length ~/
                    (widget.enableMultiView ? 4 : 2)];
            return date.month == currentMonth.month &&
                date.year == currentMonth.year;
          }
        }
        break;
      case DateRangePickerView.year:
        {
          final int currentYear = _currentViewVisibleDates[0].year;
          return currentYear == date.year;
        }
      case DateRangePickerView.decade:
        {
          final int minYear = _currentViewVisibleDates[0].year;
          final int maxYear = _currentViewVisibleDates[10].year - 1;
          final int year = date.year;
          return minYear <= year && maxYear >= year;
        }
      case DateRangePickerView.century:
        {
          final int minYear = _currentViewVisibleDates[0].year;
          final int maxYear = _currentViewVisibleDates[10].year - 1;
          final int year = date.year;
          return minYear <= year && maxYear >= year;
        }
    }

    return false;
  }

  void _updateCurrentVisibleDates() {
    switch (_view) {
      case DateRangePickerView.month:
        {
          _currentViewVisibleDates = getVisibleDates(
              _currentDate,
              null,
              widget.monthViewSettings.firstDayOfWeek,
              _getViewDatesCount(
                  _view, widget.monthViewSettings.numberOfWeeksInView));
        }
        break;
      case DateRangePickerView.year:
      case DateRangePickerView.decade:
      case DateRangePickerView.century:
        {
          _currentViewVisibleDates = _getVisibleYearDates(_currentDate, _view);
        }
    }
  }

  DateTime _updateCurrentDate(SfDateRangePicker oldWidget) {
    if (oldWidget.controller == widget.controller &&
        widget.controller != null &&
        oldWidget.controller.view == DateRangePickerView.month &&
        _controller.view != DateRangePickerView.month) {
      return _currentViewVisibleDates[
          _currentViewVisibleDates.length ~/ (widget.enableMultiView ? 4 : 2)];
    }

    return _currentViewVisibleDates[0];
  }

  Widget _addChildren(double top, double height, double width) {
    _headerVisibleDates.value = _currentViewVisibleDates;
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
            child: _PickerHeaderView(
                _headerVisibleDates,
                widget.headerStyle,
                widget.selectionMode,
                _view,
                widget.monthViewSettings.numberOfWeeksInView,
                widget.showNavigationArrow,
                widget.navigationDirection,
                widget.monthViewSettings.enableSwipeSelection,
                widget.minDate,
                widget.maxDate,
                widget.monthFormat,
                _datePickerTheme,
                _locale,
                width,
                widget.headerHeight,
                widget.allowViewNavigation,
                _moveToPreviousView,
                _moveToNextView,
                widget.enableMultiView,
                widget.viewSpacing,
                widget.selectionColor ?? _datePickerTheme.selectionColor,
                _isRtl,
                _textScaleFactor),
            height: widget.headerHeight,
          ),
          onTapUp: (TapUpDetails details) {
            _updateCalendarTapCallbackForHeader();
          },
        ),
      ),
      _getViewHeaderView(),
      Positioned(
        top: top,
        left: 0,
        right: 0,
        height: height,
        child: _PickerScrollView(
          widget,
          _controller,
          width,
          height,
          _isRtl,
          _datePickerTheme,
          _locale,
          _textScaleFactor,
          getPickerStateValues: (_PickerStateArgs details) {
            _getPickerStateValues(details);
          },
          updatePickerStateValues: (_PickerStateArgs details) {
            _updatePickerStateValues(details);
          },
          key: _scrollViewKey,
        ),
      ),
    ]);
  }

  Widget _getViewHeaderView() {
    if (_view == DateRangePickerView.month &&
        widget.navigationDirection ==
            DateRangePickerNavigationDirection.vertical) {
      final Color todayTextColor =
          widget.monthCellStyle.todayTextStyle != null &&
                  widget.monthCellStyle.todayTextStyle.color != null
              ? widget.monthCellStyle.todayTextStyle.color
              : (widget.todayHighlightColor != null &&
                      widget.todayHighlightColor != Colors.transparent
                  ? widget.todayHighlightColor
                  : _datePickerTheme.todayHighlightColor);
      return Positioned(
        left: 0,
        top: widget.headerHeight,
        right: 0,
        height: widget.monthViewSettings.viewHeaderHeight,
        child: Container(
          color: widget.monthViewSettings.viewHeaderStyle.backgroundColor ??
              _datePickerTheme.viewHeaderBackgroundColor,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _PickerViewHeaderPainter(
                  _currentViewVisibleDates,
                  widget.monthViewSettings.viewHeaderStyle,
                  widget.monthViewSettings.viewHeaderHeight,
                  widget.monthViewSettings,
                  _datePickerTheme,
                  _locale,
                  _isRtl,
                  widget.monthCellStyle,
                  widget.enableMultiView,
                  widget.viewSpacing,
                  todayTextColor,
                  _textScaleFactor),
            ),
          ),
        ),
      );
    }

    return Positioned(left: 0, top: 0, right: 0, height: 0, child: Container());
  }

  void _moveToNextView() {
    if (!_canMoveToNextView(_view, widget.monthViewSettings.numberOfWeeksInView,
        widget.maxDate, _currentViewVisibleDates, widget.enableMultiView)) {
      return;
    }

    _isRtl
        ? _scrollViewKey.currentState._moveToPreviousViewWithAnimation()
        : _scrollViewKey.currentState._moveToNextViewWithAnimation();
  }

  void _moveToPreviousView() {
    if (!_canMoveToPreviousView(
        _view,
        widget.monthViewSettings.numberOfWeeksInView,
        widget.minDate,
        _currentViewVisibleDates,
        widget.enableMultiView)) {
      return;
    }

    _isRtl
        ? _scrollViewKey.currentState._moveToNextViewWithAnimation()
        : _scrollViewKey.currentState._moveToPreviousViewWithAnimation();
  }

  void _getPickerStateValues(_PickerStateArgs details) {
    details._currentDate = _currentDate;
    details._selectedDate = _selectedDate;
    details._selectedDates = _selectedDates;
    details._selectedRange = _selectedRange;
    details._selectedRanges = _selectedRanges;
    details._view = _view;
  }

  void _updatePickerStateValues(_PickerStateArgs details) {
    if (details._currentDate != null) {
      if (!isSameOrAfterDate(widget.minDate, details._currentDate)) {
        details._currentDate = widget.minDate;
      }

      if (!isSameOrBeforeDate(widget.maxDate, details._currentDate)) {
        details._currentDate = widget.maxDate;
      }

      _currentDate = details._currentDate;
      _controller.displayDate = _currentDate;
    }

    if (details._currentViewVisibleDates != null &&
        _currentViewVisibleDates != details._currentViewVisibleDates) {
      _currentViewVisibleDates = details._currentViewVisibleDates;
      _headerVisibleDates.value = _currentViewVisibleDates;
      switch (_controller.view) {
        case DateRangePickerView.month:
          {
            if (!widget.monthViewSettings.showTrailingAndLeadingDates &&
                widget.monthViewSettings.numberOfWeeksInView == 6) {
              final DateTime visibleDate = _currentViewVisibleDates[
                  _currentViewVisibleDates.length ~/
                      (widget.enableMultiView ? 4 : 2)];
              _raisePickerViewChangedCallback(widget,
                  visibleDateRange: PickerDateRange(
                      _getMonthStartDate(visibleDate),
                      widget.enableMultiView
                          ? _getMonthEndDate(_getNextViewStartDate(
                              _controller.view, 6, visibleDate, _isRtl))
                          : _getMonthEndDate(visibleDate)),
                  view: _controller.view);
            } else {
              _raisePickerViewChangedCallback(widget,
                  visibleDateRange: PickerDateRange(
                      _currentViewVisibleDates[0],
                      _currentViewVisibleDates[
                          _currentViewVisibleDates.length - 1]),
                  view: _controller.view);
            }
          }
          break;
        case DateRangePickerView.year:
        case DateRangePickerView.decade:
        case DateRangePickerView.century:
          {
            _raisePickerViewChangedCallback(widget,
                visibleDateRange: PickerDateRange(
                    _currentViewVisibleDates[0],
                    _currentViewVisibleDates[
                        _currentViewVisibleDates.length - 1]),
                view: _controller.view);
          }
      }
    }

    if (details._view != null && _view != details._view) {
      _controller.view = details._view;
    }

    if (_view == DateRangePickerView.month || !widget.allowViewNavigation) {
      switch (widget.selectionMode) {
        case DateRangePickerSelectionMode.single:
          {
            _selectedDate = details._selectedDate;
            _controller.selectedDate = _selectedDate;
          }
          break;
        case DateRangePickerSelectionMode.multiple:
          {
            _selectedDates = details._selectedDates;
            _controller.selectedDates = _selectedDates;
          }
          break;
        case DateRangePickerSelectionMode.range:
          {
            _selectedRange = details._selectedRange;
            _controller.selectedRange = _selectedRange;
          }
          break;
        case DateRangePickerSelectionMode.multiRange:
          {
            _selectedRanges = details._selectedRanges;
            _controller.selectedRanges = _selectedRanges;
          }
      }
    }
  }

  // method to update the calendar tapped call back for the header view
  void _updateCalendarTapCallbackForHeader() {
    if (_view == DateRangePickerView.century || !widget.allowViewNavigation) {
      return;
    }

    if (_view == DateRangePickerView.month) {
      _controller.view = DateRangePickerView.year;
    } else {
      if (_view == DateRangePickerView.year) {
        _controller.view = DateRangePickerView.decade;
      } else if (_view == DateRangePickerView.decade) {
        _controller.view = DateRangePickerView.century;
      }
    }
  }
}
