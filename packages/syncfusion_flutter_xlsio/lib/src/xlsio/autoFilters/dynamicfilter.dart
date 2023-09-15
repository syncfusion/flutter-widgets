// ignore_for_file: unused_element, unused_field, unnecessary_getters_setters

part of xlsio;

///Represent the dynamic filter.
class _DynamicFilter implements _Filter {
  /// Constructor of dynamic filter.
  _DynamicFilter(_AutoFilterImpl filter) {
    _autoFilter = filter;
  }

  /// Represent the autoFilter.
  late _AutoFilterImpl _autoFilter;

  /// Relative date filter type used.
  late DynamicFilterType _dateFilter;

  /// Get the filter type.
  @override
  _ExcelFilterType get _filterType {
    return _ExcelFilterType.dynamicFilter;
  }

  /// Set the filter type.
  @override
  set _filterType(_ExcelFilterType filterType) {}

  /// Get the dynamic filter type.
  DynamicFilterType get _dateFilterType {
    return _dateFilter;
  }

  /// Set the dynamic filter type.
  set _dateFilterType(DynamicFilterType dateFilter) {
    _dateFilter = dateFilter;
  }
}
