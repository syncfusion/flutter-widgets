part of xlsio;

///AutoFilter class
abstract class AutoFilter {
  /// Represents the first condition for the filter.
  late AutoFilterCondition firstCondition;

  ///  Represents the second condition for the filter.
  late AutoFilterCondition secondCondition;

  ///Indicates whether to use AND, OR logical operation between first and second conditions. By default, it uses OR operation.
  ExcelLogicalOperator logicalOperator = ExcelLogicalOperator.or;

  /// Specifies the type of filter
  late _ExcelFilterType _filtertype;

  ///Applies text filter with the specified string collection.
  void addTextFilter(Set<String> filterCollection);

  /// Applies date filter with the specified date period.
  void addDynamicFilter(DynamicFilterType dynamicFilterType);

  /// Applies date filter with the specified date.
  void addDateFilter(DateTime dateTime, DateTimeFilterType groupingType);

  /// Applies color filter with the specified font or back color.
  void addColorFilter(String color, ExcelColorFilterType colorFilterType);
}
