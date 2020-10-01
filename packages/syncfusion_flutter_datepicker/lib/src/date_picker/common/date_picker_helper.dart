part of datepicker;

/// Selection modes for [SfDateRangePicker].
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
  multiRange
}

/// Available views for [SfDateRangePicker].
enum DateRangePickerView {
  /// - DateRangePickerView.month, Displays the month view.
  month,

  /// - DateRangePickerView.year, Displays the year view.
  year,

  /// - DateRangePickerView.decade, Displays the decade view.
  decade,

  /// - DateRangePickerView.century, Display the century view.
  century
}

/// The shape for the selection view in [SfDateRangePicker].
enum DateRangePickerSelectionShape {
  /// - DateRangePickerSelectionShape.circle, Draws the date selection in circle
  /// shape.
  circle,

  /// - DateRangePickerSelectionShape.rectangle, Draws the date selection in
  /// rectangle shape.
  rectangle
}

/// A direction in which the [SfDateRangePicker] navigates.
enum DateRangePickerNavigationDirection {
  /// - DateRangePickerNavigationDirection.vertical, Navigates in top and bottom
  /// direction.
  vertical,

  /// - DateRangePickerNavigationDirection.horizontal, Navigates in right and
  /// left direction.
  horizontal
}

/// args to update the required properties from picker state to it's children's
class _PickerStateArgs {
  DateTime _currentDate;
  List<DateTime> _currentViewVisibleDates;
  DateTime _selectedDate;
  List<DateTime> _selectedDates;
  PickerDateRange _selectedRange;
  List<PickerDateRange> _selectedRanges;
  DateRangePickerView _view;
}

/// The dates that visible on the view changes in [SfDateRangePicker].
///
/// Details for [DateRangePickerViewChangedCallback], such as [visibleDateRange]
/// and [view].
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
  /// [List<PickerDateRange] when the widget [DateRangePickerSelectionMode] set
  /// as multi range.
  final dynamic value;
}

/// Defines a range of dates, covers the dates in between the given [startDate]
/// and [endDate] as a range.
@immutable
class PickerDateRange {
  /// Creates a picker date range with the given start and end date.
  const PickerDateRange(this.startDate, this.endDate);

  /// The start date of the range.
  final DateTime startDate;

  /// The end date of the range.
  final DateTime endDate;
}
