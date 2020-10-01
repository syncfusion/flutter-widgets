part of datepicker;

/// Sets the style for customizing the [SfDateRangePicker] header view.
///
/// Allows to customize the [textStyle], [textAlign] and [backgroundColor] of
/// the header view in [SfDateRangePicker].
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
class DateRangePickerHeaderStyle {
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
  final TextStyle textStyle;

  /// How the text should  be aligned horizontally in [SfDateRangePicker] header
  /// view.
  ///
  /// Defaults to `TextAlign.left`.
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
  final Color backgroundColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DateRangePickerHeaderStyle otherStyle = other;
    return otherStyle.textStyle == textStyle &&
        otherStyle.textAlign == textAlign &&
        otherStyle.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return hashValues(
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
class DateRangePickerViewHeaderStyle {
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
  final Color backgroundColor;

  /// The text style for the text in the [SfDateRangePicker] view header view of
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final TextStyle textStyle;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DateRangePickerViewHeaderStyle otherStyle = other;
    return otherStyle.backgroundColor == backgroundColor &&
        otherStyle.textStyle == textStyle;
  }

  @override
  int get hashCode {
    return hashValues(
      backgroundColor,
      textStyle,
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
///                           Colors.black)),
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
class DateRangePickerMonthViewSettings {
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
          this.selectionRadius,
      this.showTrailingAndLeadingDates = false,
      DateRangePickerViewHeaderStyle viewHeaderStyle,
      this.enableSwipeSelection = true,
      this.blackoutDates,
      this.specialDates,
      List<int> weekendDays})
      : viewHeaderStyle =
            viewHeaderStyle ?? const DateRangePickerViewHeaderStyle(),
        weekendDays = weekendDays ?? const <int>[6, 7];

  /// Formats a text in the [SfDateRangePicker] month view view header.
  ///
  /// Text format in the [SfDateRangePicker] month view view header.
  ///
  /// Defaults to `EE`.
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
  /// See also: [DateRangePickerMonthCellStyle] to know about leading and
  /// trailing dates style.
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
  /// See also: [DateRangePickerViewHeaderStyle].
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
  /// [DateRangePickerMonthCellStyle.blackoutDateTextStyle]
  /// [DateRangePickerMonthCellStyle.blackoutDatesDecoration].
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
  final List<DateTime> blackoutDates;

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
  /// [DateRangePickerMonthCellStyle.specialDatesTextStyle]
  /// [DateRangePickerMonthCellStyle.specialDatesDecoration].
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
  final List<DateTime> specialDates;

  /// The weekends for month view in [SfDateRangePicker].
  ///
  /// Defaults to `<int>[6,7]` represents `<int>[DateTime.saturday,
  ///  DateTime.sunday]`.
  ///
  /// _Note:_ The [weekendDays] will not be highlighted until it's customize by
  /// using the [DateRangePickerMonthCellStyle.weekendTextStyle] or
  /// [DateRangePickerMonthCellStyle.weekendDatesDecoration] property.
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

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DateRangePickerMonthViewSettings otherStyle = other;
    return otherStyle.dayFormat == dayFormat &&
        otherStyle.numberOfWeeksInView == numberOfWeeksInView &&
        otherStyle.firstDayOfWeek == firstDayOfWeek &&
        otherStyle.viewHeaderStyle == viewHeaderStyle &&
        otherStyle.viewHeaderHeight == viewHeaderHeight &&
        otherStyle.showTrailingAndLeadingDates == showTrailingAndLeadingDates &&
        otherStyle.blackoutDates == blackoutDates &&
        otherStyle.specialDates == specialDates &&
        otherStyle.weekendDays == weekendDays &&
        otherStyle.enableSwipeSelection == enableSwipeSelection;
  }

  @override
  int get hashCode {
    return hashValues(
        dayFormat,
        firstDayOfWeek,
        viewHeaderStyle,
        enableSwipeSelection,
        viewHeaderHeight,
        showTrailingAndLeadingDates,
        numberOfWeeksInView,
        specialDates,
        blackoutDates,
        weekendDays);
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
class DateRangePickerYearCellStyle {
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
  final TextStyle textStyle;

  /// The text style for the text in the today cell of [SfDateRangePicker]
  /// year, decade and century view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final TextStyle todayTextStyle;

  /// The text style for the text in the leading dates cells of
  /// [SfDateRangePicker] year, decade and century view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final TextStyle leadingDatesTextStyle;

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
  final TextStyle disabledDatesTextStyle;

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
  final Decoration disabledDatesDecoration;

  /// The decoration for the cells of [SfDateRangePicker] year, decade
  /// and century view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final Decoration cellDecoration;

  /// The decoration for the today cell of [SfDateRangePicker] year, decade
  /// and century view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final Decoration todayCellDecoration;

  /// The decoration for the leading date cells of [SfDateRangePicker]
  /// year, decade and century view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final Decoration leadingDatesDecoration;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DateRangePickerYearCellStyle otherStyle = other;
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
  int get hashCode {
    return hashValues(
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
class DateRangePickerMonthCellStyle {
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
  final TextStyle textStyle;

  /// The text style for the text in the today cell of [SfDateRangePicker]
  /// month view.
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
  final TextStyle todayTextStyle;

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
  /// See also:[DateRangePickerMonthViewSettings.showTrailingAndLeadingDates].
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
  final TextStyle trailingDatesTextStyle;

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
  /// See also:[DateRangePickerMonthViewSettings.showTrailingAndLeadingDates].
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
  final TextStyle leadingDatesTextStyle;

  /// The text style for the text in the disabled dates cell of
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also:
  /// [SfDateRangePicker.minDate].
  /// [SfDateRangePicker.maxDate].
  /// [SfDateRangePicker.enablePastDates].
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
  final TextStyle disabledDatesTextStyle;

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
  final TextStyle rangeTextStyle;

  /// The text style for the text in the blackout dates cell of
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also: [DateRangePickerMonthViewSettings.blackoutDates].
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
  final TextStyle blackoutDateTextStyle;

  /// The text style for the text in the weekend dates cell of
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also: [DateRangePickerMonthViewSettings.weekendDays].
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
  final TextStyle weekendTextStyle;

  /// The text style for the text in the special dates cell of
  /// [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
  ///
  /// See also: [DateRangePickerMonthViewSettings.specialDates].
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
  final TextStyle specialDatesTextStyle;

  /// The decoration for the special date cells of [SfDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final Decoration specialDatesDecoration;

  /// The decoration for the weekend date cells of [SfDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final Decoration weekendDatesDecoration;

  /// The decoration for the blackout date cells of [SfDateRangePicker]
  /// month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final Decoration blackoutDatesDecoration;

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
  /// [SfDateRangePicker.minDate].
  /// [SfDateRangePicker.maxDate].
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
  final Decoration disabledDatesDecoration;

  /// The decoration for the month cells of [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final Decoration cellDecoration;

  /// The decoration for the today text cell of [SfDateRangePicker] month view.
  ///
  /// Defaults to null.
  ///
  /// Using a [SfDateRangePickerTheme] gives more fine-grained control over the
  /// appearance of various components of the date range picker.
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
  final Decoration todayCellDecoration;

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
  /// See also:[DateRangePickerMonthViewSettings.showTrailingAndLeadingDates].
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
  final Decoration trailingDatesDecoration;

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
  /// See also:[DateRangePickerMonthViewSettings.showLeadingAndTrailingDate].
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
  final Decoration leadingDatesDecoration;

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
  final Color endRangeSelectionColor;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DateRangePickerMonthCellStyle otherStyle = other;
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
  int get hashCode {
    return hashList(<Object>[
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
