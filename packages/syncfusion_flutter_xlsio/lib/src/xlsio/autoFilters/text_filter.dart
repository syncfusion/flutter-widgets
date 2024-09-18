// ignore_for_file: unused_element
import '../general/enums.dart';
import 'multiplefilter.dart';

///Class represent text filer in a combination filter.
class TextFilter implements MultipleFilter {
  ///represent Text filter value
  late String text;

  ///Get combination filtertype
  @override
  ExcelCombinationFilterType get combinationFilterType {
    return ExcelCombinationFilterType.textFilter;
  }

  ///Get combinationFilterType
  @override
  set combinationFilterType(ExcelCombinationFilterType combinationFilterType) {}
}
