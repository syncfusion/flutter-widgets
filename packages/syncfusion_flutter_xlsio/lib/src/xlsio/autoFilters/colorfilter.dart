// ignore_for_file: unused_field, unused_element, unnecessary_getters_setters

part of xlsio;

///Represent the color filter.
class _ColorFilter implements _Filter {
  ///Constructor of color filter.
  _ColorFilter(_AutoFilterImpl filter) {
    _autoFilter = filter;
    _colorFilter = ExcelColorFilterType.cellColor;
  }

  /// Represent the autoFilter.
  late _AutoFilterImpl _autoFilter;

  /// Specifies the color filter type ( Cell Color or Font Color)
  late ExcelColorFilterType _colorFilter;

  /// Holds the color that has to be filtered
  late String _colorValue;

  /// Get the filter type.
  @override
  _ExcelFilterType get _filterType {
    return _ExcelFilterType.colorFilter;
  }

  /// Set the filter type.
  @override
  set _filterType(_ExcelFilterType filterType) {}

  /// Get the color filter type.
  ExcelColorFilterType get _colorFilterType {
    return _colorFilter;
  }

  /// Set the color filter type.
  set _colorFilterType(ExcelColorFilterType colorFilterType) {
    _colorFilter = colorFilterType;
  }

  /// Get the color value.
  String get _color {
    return _colorValue;
  }

  /// Set the filter color value.
  set _color(String colorValue) {
    _colorValue = colorValue;
  }
}
