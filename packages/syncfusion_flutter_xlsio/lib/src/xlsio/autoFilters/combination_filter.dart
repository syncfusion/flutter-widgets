// ignore_for_file: unused_field, unused_element, unnecessary_getters_setters
part of xlsio;

///Combination filter class
class _CombinationFilter implements _Filter {
  ///Constructor for combinationFilter class
  _CombinationFilter(AutoFilter autoFilter) {
    _filter = autoFilter;
    _filterCollection = <_MultipleFilter>[];
    _isBlankValue = false;
  }

  ///Represents Autofilter Parent Class
  late AutoFilter _filter;

  ///Indicates wheather cell is blank or not
  late bool _isBlankValue;

  /// Collection  of text filter.
  late List<_MultipleFilter> _filterCollection;

  ///Get textfilterCollection.
  List<String> get _textFilterCollection {
    return _textCollection();
  }

  ///Return total number combination filter values.
  int get count {
    return _filterCollection.length;
  }

  /// Returns collection of text filter values alone for currnet combination.
  /// Returns collection of unique text filter values alone.
  List<String> _textCollection() {
    final List<String> collection = <String>[];
    for (final _MultipleFilter multiFilter in _filterCollection) {
      if (multiFilter._combinationFilterType ==
          _ExcelCombinationFilterType.textFilter) {
        collection.add((multiFilter as _TextFilter)._text);
      }
    }
    return collection;
  }

  ///Represents filterType
  ///Get filterType
  @override
  _ExcelFilterType get _filterType {
    return _ExcelFilterType.combinationFilter;
  }

  @override

  ///Set filter type
  set _filterType(_ExcelFilterType filterType) {}

  ///Get isblank
  bool get _isBlank {
    return _isBlankValue;
  }

  ///Indicates wheather cell is blank or not
  ///Set isBlank
  set _isBlank(bool value) {
    _isBlankValue = value;
  }
}
