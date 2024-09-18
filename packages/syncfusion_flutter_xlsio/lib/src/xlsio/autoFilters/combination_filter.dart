// ignore_for_file: unused_field, unused_element, unnecessary_getters_setters
import '../autoFilters/auto_filter.dart';
import '../autoFilters/multiplefilter.dart';
import '../autoFilters/text_filter.dart';
import '../general/enums.dart';
import 'filter.dart';

///Combination filter class
class CombinationFilter implements Filter {
  ///Constructor for combinationFilter class
  CombinationFilter(AutoFilter autoFilter) {
    _filter = autoFilter;
    filterCollection = <MultipleFilter>[];
    _isBlankValue = false;
  }

  ///Represents Autofilter Parent Class
  late AutoFilter _filter;

  ///Indicates wheather cell is blank or not
  late bool _isBlankValue;

  /// Collection  of text filter.
  late List<MultipleFilter> filterCollection;

  ///Get textfilterCollection.
  List<String> get textFilterCollection {
    return _textCollection();
  }

  ///Return total number combination filter values.
  int get count {
    return filterCollection.length;
  }

  /// Returns collection of text filter values alone for currnet combination.
  /// Returns collection of unique text filter values alone.
  List<String> _textCollection() {
    final List<String> collection = <String>[];
    for (final MultipleFilter multiFilter in filterCollection) {
      if (multiFilter.combinationFilterType ==
          ExcelCombinationFilterType.textFilter) {
        collection.add((multiFilter as TextFilter).text);
      }
    }
    return collection;
  }

  ///Represents filterType
  ///Get filterType
  @override
  ExcelFilterType get filterType {
    return ExcelFilterType.combinationFilter;
  }

  @override

  ///Set filter type
  set filterType(ExcelFilterType filterType) {}

  ///Get isblank
  bool get isBlank {
    return _isBlankValue;
  }

  ///Indicates wheather cell is blank or not
  ///Set isBlank
  set isBlank(bool value) {
    _isBlankValue = value;
  }
}
