// ignore_for_file: unused_field, unused_element, unnecessary_getters_setters
import '../autoFilters/autofilter_impl.dart';
import '../general/enums.dart';
import 'filter.dart';

///Represent the color filter.
class ColorFilter implements Filter {
  ///Constructor of color filter.
  ColorFilter(AutoFilterImpl filter) {
    _autoFilter = filter;
    _colorFilter = ExcelColorFilterType.cellColor;
  }

  /// Represent the autoFilter.
  late AutoFilterImpl _autoFilter;

  /// Specifies the color filter type ( Cell Color or Font Color)
  late ExcelColorFilterType _colorFilter;

  /// Holds the color that has to be filtered
  late String _colorValue;

  /// Get the filter type.
  @override
  ExcelFilterType get filterType {
    return ExcelFilterType.colorFilter;
  }

  /// Set the filter type.
  @override
  set filterType(ExcelFilterType filterType) {}

  /// Get the color filter type.
  ExcelColorFilterType get colorFilterType {
    return _colorFilter;
  }

  /// Set the color filter type.
  set colorFilterType(ExcelColorFilterType colorFilterType) {
    _colorFilter = colorFilterType;
  }

  /// Get the color value.
  String get color {
    return _colorValue;
  }

  /// Set the filter color value.
  set color(String colorValue) {
    _colorValue = colorValue;
  }
}
