// ignore_for_file: unused_element

part of xlsio;

///Class represent text filer in a combination filter.
class _TextFilter implements _MultipleFilter {
  ///represent Text filter value
  late String _text;

  ///Get combination filtertype
  @override
  _ExcelCombinationFilterType get _combinationFilterType {
    return _ExcelCombinationFilterType.textFilter;
  }

  ///Get combinationFilterType
  @override
  set _combinationFilterType(
      _ExcelCombinationFilterType combinationFilterType) {}
}
