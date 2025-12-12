// ignore_for_file: unnecessary_getters_setters, unused_element
import '../general/enums.dart';
import 'multiplefilter.dart';

/// Represen the date time filter.
class DateTimeFilter implements MultipleFilter {
  /// Represent the date time value.
  late DateTime dateTimeValue;

  /// Represent the date time groupting type.
  late DateTimeFilterType _groupingTypeVal;

  /// Get the filter date time value.
  DateTime get dateTime {
    return dateTimeValue;
  }

  /// Set the filter date time value.
  set dateTime(DateTime dateTime) {
    dateTimeValue = dateTime;
  }

  /// Get the date time filter grouping type.
  DateTimeFilterType get groupingType {
    return _groupingTypeVal;
  }

  /// Set the date time filter grouping type.
  set groupingType(DateTimeFilterType dateTimeGroup) {
    _groupingTypeVal = dateTimeGroup;
  }

  /// Get the combination filter type.
  @override
  ExcelCombinationFilterType get combinationFilterType {
    return ExcelCombinationFilterType.dateTimeFilter;
  }

  /// Set the combination filter type.
  @override
  set combinationFilterType(ExcelCombinationFilterType combinationFilterType) {}
}
