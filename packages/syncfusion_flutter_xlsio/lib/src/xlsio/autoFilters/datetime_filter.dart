// ignore_for_file: unnecessary_getters_setters, unused_element

part of xlsio;

/// Represen the date time filter.
class _DateTimeFilter implements _MultipleFilter {
  /// Represent the date time value.
  late DateTime _dateTimeValue;

  /// Represent the date time groupting type.
  late DateTimeFilterType _groupingTypeVal;

  /// Get the filter date time value.
  DateTime get _dateTime {
    return _dateTimeValue;
  }

  /// Set the filter date time value.
  set _dateTime(DateTime dateTimeValue) {
    _dateTimeValue = dateTimeValue;
  }

  /// Get the date time filter grouping type.
  DateTimeFilterType get _groupingType {
    return _groupingTypeVal;
  }

  /// Set the date time filter grouping type.
  set _groupingType(DateTimeFilterType dateTimeGroup) {
    _groupingTypeVal = dateTimeGroup;
  }

  /// Get the combination filter type.
  @override
  _ExcelCombinationFilterType get _combinationFilterType {
    return _ExcelCombinationFilterType.dateTimeFilter;
  }

  /// Set the combination filter type.
  @override
  set _combinationFilterType(
      _ExcelCombinationFilterType combinationFilterType) {}
}
