// ignore_for_file: unused_element, unused_field, unnecessary_getters_setters
import '../autoFilters/autofilter_impl.dart';
import '../general/enums.dart';
import 'filter.dart';

///Represent the dynamic filter.
class DynamicFilter implements Filter {
  /// Constructor of dynamic filter.
  DynamicFilter(AutoFilterImpl filter) {
    _autoFilter = filter;
  }

  /// Represent the autoFilter.
  late AutoFilterImpl _autoFilter;

  /// Relative date filter type used.
  late DynamicFilterType _dateFilter;

  /// Get the filter type.
  @override
  ExcelFilterType get filterType {
    return ExcelFilterType.dynamicFilter;
  }

  /// Set the filter type.
  @override
  set filterType(ExcelFilterType filterType) {}

  /// Get the dynamic filter type.
  DynamicFilterType get dateFilterType {
    return _dateFilter;
  }

  /// Set the dynamic filter type.
  set dateFilterType(DynamicFilterType dateFilter) {
    _dateFilter = dateFilter;
  }
}
