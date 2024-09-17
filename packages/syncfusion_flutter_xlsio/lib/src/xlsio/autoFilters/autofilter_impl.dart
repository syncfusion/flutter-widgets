import 'package:jiffy/jiffy.dart';

import '../autoFilters/datetime_filter.dart';
import '../autoFilters/multiplefilter.dart';
import '../general/enums.dart';
import '../range/range.dart';
import '../worksheet/worksheet.dart';
import 'auto_filter.dart';
import 'autofiltercollection.dart';
import 'autofiltercondition.dart';
import 'autofilterconditon_impl.dart';
import 'colorfilter.dart';
import 'combination_filter.dart';
import 'dynamicfilter.dart';
import 'filter.dart';
import 'text_filter.dart';

///Implementation class for autofilter
/// This class represents single autofilter item.
class AutoFilterImpl implements AutoFilter {
  //Constructor for autofilterimpl class
  AutoFilterImpl(AutoFilterCollection parent, Worksheet worksheet,
      [int iRow = 0, int lRow = 0]) {
    intializeConditions();
    _autoFilterCollection = parent;
    _worksheet = worksheet;
    _iRow = iRow;
    _lastRow = lRow;
    _rangeList = <Range, double?>{};
    firstConditionboolList = <bool>[];
    secondConditionboolList = <bool>[];
    _rangeListtemp = <int>[];
    _logicalOperator = ExcelLogicalOperator.or;
    _isFilterUsed = false;
  }

  ///Represents range List For adding ranges in custom filter
  late Map<Range, double?> _rangeList;

  /// Represents the autoFiltercollection parent class.
  late AutoFilterCollection _autoFilterCollection;

  /// Represents the combinationFilter filter object.
  late CombinationFilter _combinationFilter;

  ///Indicates whether to use AND, OR logical operation between first and second conditions. By default, it uses OR operation.
  late ExcelLogicalOperator _logicalOperator;

  /// False indicates that this autofilter was not used; otherwise True.
  late bool _isFilterUsed;

  /// First condition of autofilter
  late AutoFilterCondition _firstconditions;

  /// Second condition of autofilter
  late AutoFilterCondition _secondconditions;

  ///Defines type of filter used
  ExcelFilterType _typeOfFilter = ExcelFilterType.notUsed;

  ///Represents column index
  late int colIndex;

  /// Represent the dynamic filter object.
  late Worksheet _worksheet;

  ///Reperesents FirstRow
  late int _iRow;

  ///Reperesents lastRow
  late int _lastRow;

  ///For adding values Of the hidden rows in first condition.
  late List<bool> firstConditionboolList;

  ///For adding values Of the hidden rows in second condition.
  late List<bool> secondConditionboolList;

  ///For adding range lists to be filtered.
  late List<int> _rangeListtemp;

  ///Indicates wheather it is firstCondition Or not.
  late bool _isFirstCondition;

  ///Indicates wheather it is secondCondition Or not.
  late bool _isSecondCondition;

  /// Represent the dynamic filter object.
  late DynamicFilter dateFilter;

  /// Represent the color filter object.
  late ColorFilter colorFilter;

  ///Get second condition indicator
  bool get isSecondCondition {
    return _isSecondCondition;
  }

  ///Get first condition indicator
  bool get isFirstCondition {
    return _isFirstCondition;
  }

  ///Get autoFilter firstcondition.
  @override
  AutoFilterCondition get firstCondition {
    _isFirstCondition = true;
    _isSecondCondition = false;

    return _firstconditions;
  }

  ///Set autoFilter firstcondition.
  @override
  set firstCondition(AutoFilterCondition value) {}

  ///Get autoFilter firstcondition.
  @override
  AutoFilterCondition get secondCondition {
    //isBoth = false;
    _isFirstCondition = false;
    _isSecondCondition = true;

    return _secondconditions;
  }

  ///Set autoFilter firstcondition.
  @override
  set secondCondition(AutoFilterCondition value) {}

  ///Get combinationFilter.
  CombinationFilter get combinationFilter {
    return _combinationFilter;
  }

  ///Indicates whether to use AND, OR logical operation between first and second conditions. By default, it uses OR operation.
  @override
  ExcelLogicalOperator get logicalOperator {
    return _logicalOperator;
  }

  ///Indicates whether to use AND, OR logical operation between first and second conditions. By default, it uses OR operation.
  @override
  set logicalOperator(ExcelLogicalOperator logicOperator) {
    _logicalOperator = logicOperator;
  }

  ///Get isFiltered
  bool get isFiltered {
    if (_typeOfFilter == ExcelFilterType.notUsed) {
      return _isFilterUsed;
    }
    _isFilterUsed = true;
    return _isFilterUsed;
  }

  ///Set isFiltered
  set isFiltered(bool value) {
    _isFilterUsed = value;
  }

  ///Set filterType
  @override
  set filterType(ExcelFilterType value) {
    _typeOfFilter = value;
  }

  ///Get filterType
  @override
  ExcelFilterType get filterType {
    return _typeOfFilter;
  }

  /// Returns filter values for combination type (Text and DateTime),
  /// dynamic and color type. It returns null, if custom filter is applied.
  Filter get filteredItems {
    late Filter temp;
    switch (filterType) {
      case ExcelFilterType.customFilter:
        break;
      case ExcelFilterType.combinationFilter:
        temp = combinationFilter;
        break;
      case ExcelFilterType.dynamicFilter:
        temp = dateFilter;
        break;
      case ExcelFilterType.colorFilter:
        temp = colorFilter;
        break;
      case ExcelFilterType.iconFilter:
        break;
      case ExcelFilterType.notUsed:
        break;
    }
    return temp;
  }

  ///Set for filteredItems
  // ignore: unused_element
  set filteredItems(Filter filteredItems) {}

  ///Apply text filter with the specified string.
  @override
  void addTextFilter(Set<String> filterCollection) {
    filterType = ExcelFilterType.combinationFilter;

    for (final String filter in filterCollection) {
      if (!combinationFilter.textFilterCollection.contains(filter)) {
        final TextFilter textFilter = TextFilter();
        textFilter.text = filter.trim();
        _combinationFilter.filterCollection.add(textFilter);
        combinationFilter.isBlank = false;
        // _textCollection.add(filter.toLowerCase());
      }
    }
    _applyTextFilter();
  }

  /// Applying text filter.
  void _applyTextFilter() {
    final Map<String, String> filterCollection = <String, String>{};

    String cellText = '';
    if (combinationFilter.isBlank) {
      filterCollection.addAll(<String, String>{'': ''});
    }
    for (final MultipleFilter multiFilter
        in _combinationFilter.filterCollection) {
      if (multiFilter.combinationFilterType ==
          ExcelCombinationFilterType.textFilter) {
        cellText = (multiFilter as TextFilter).text.toLowerCase();
        // ignore: always_specify_types
        filterCollection.addAll({cellText: cellText});
      }
    }

    for (int iRow = _iRow + 1; iRow <= _lastRow; iRow++) {
      if (filterCollection.isNotEmpty) {
        if (!filterCollection.containsKey(_worksheet
            .getRangeByIndex(iRow, colIndex)
            .getText()
            ?.toLowerCase())) {
          _worksheet.getRangeByIndex(iRow, colIndex).showRows(false);
        } else {
          _worksheet.getRangeByIndex(iRow, colIndex).showRows(true);
          isFiltered = true;
        }
      } else {
        _worksheet.getRangeByIndex(iRow, colIndex).showRows(false);
      }
    }
    if (_combinationFilter.textFilterCollection.length !=
        _combinationFilter.filterCollection.length) {
      _applyDateTimeFilter();
    }
  }

  /// Add the dynamic filter.
  @override
  void addDynamicFilter(DynamicFilterType dynamicFilterType) {
    filterType = ExcelFilterType.dynamicFilter;
    dateFilter.dateFilterType = dynamicFilterType;
    _applyDynamicFilter();
  }

  /// Apply the dynamic filter.
  void _applyDynamicFilter() {
    if (dateFilter.dateFilterType == DynamicFilterType.none) {
      _removeDynamicFilter();
      return;
    }
    final Range filterRange = _autoFilterCollection.filterRange;
    for (int row = filterRange.row + 1; row <= filterRange.lastRow; row++) {
      final Range range = _worksheet.getRangeByIndex(row, colIndex);
      DateTime? dateTime;
      if (range.dateTime != null) {
        bool isVisible = false;
        final DateTime currentDate = DateTime.now();
        dateTime = range.dateTime;
        DateTime startDate;
        DateTime endDate;
        int temp;
        switch (dateFilter.dateFilterType) {
          case DynamicFilterType.yesterday:
            if ((dateTime!.year == currentDate.year) &&
                (dateTime.month == currentDate.month) &&
                (dateTime.day == currentDate.day - 1)) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.today:
            if ((dateTime!.year == currentDate.year) &&
                (dateTime.month == currentDate.month) &&
                (dateTime.day == currentDate.day)) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.tomorrow:
            if ((dateTime!.year == currentDate.year) &&
                (dateTime.month == currentDate.month) &&
                (dateTime.day == currentDate.day + 1)) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.thisWeek:
            startDate = currentDate.add(Duration(days: -currentDate.weekday));
            endDate = startDate.add(const Duration(days: 6));
            if ((dateTime!.year >= startDate.year &&
                    dateTime.year <= endDate.year) &&
                (dateTime.month >= startDate.month &&
                    dateTime.month <= endDate.month) &&
                (dateTime.day >= startDate.day &&
                    dateTime.day <= endDate.day)) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.nextWeek:
            startDate =
                currentDate.add(Duration(days: 7 - currentDate.weekday));
            endDate = startDate.add(const Duration(days: 6));
            if ((dateTime!.year >= startDate.year &&
                    dateTime.year <= endDate.year) &&
                (dateTime.month >= startDate.month &&
                    dateTime.month <= endDate.month) &&
                (dateTime.day >= startDate.day &&
                    dateTime.day <= endDate.day)) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.lastWeek:
            endDate =
                currentDate.add(Duration(days: -(currentDate.weekday + 1)));
            startDate = endDate.add(const Duration(days: -6));
            if ((dateTime!.year >= startDate.year &&
                    dateTime.year <= endDate.year) &&
                (dateTime.month >= startDate.month &&
                    dateTime.month <= endDate.month) &&
                (dateTime.day >= startDate.day &&
                    dateTime.day <= endDate.day)) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.lastMonth:
            final Jiffy jiffyLast =
                Jiffy.parseFromDateTime(currentDate).add(months: -1);
            startDate = DateTime(
                jiffyLast.year,
                jiffyLast.month,
                jiffyLast.date,
                jiffyLast.hour,
                jiffyLast.minute,
                jiffyLast.second);
            if ((dateTime!.year == startDate.year) &&
                (dateTime.month == startDate.month)) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.nextMonth:
            final Jiffy jiffyNext =
                Jiffy.parseFromDateTime(currentDate).add(months: 1);
            startDate = DateTime(
                jiffyNext.year,
                jiffyNext.month,
                jiffyNext.date,
                jiffyNext.hour,
                jiffyNext.minute,
                jiffyNext.second);
            if ((dateTime!.year == startDate.year) &&
                (dateTime.month == startDate.month)) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.thisMonth:
            if ((dateTime!.year == currentDate.year) &&
                (dateTime.month == currentDate.month)) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.thisYear:
            if (dateTime!.year == currentDate.year) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.lastYear:
            if (dateTime!.year == currentDate.year - 1) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.nextYear:
            if (dateTime!.year == currentDate.year + 1) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.thisQuarter:
            temp = currentDate.month / 3 as int;
            if (currentDate.month % 3 != 0) {
              temp++;
            }
            for (int monthIndex = temp * 3 - 2;
                monthIndex <= temp * 3;
                monthIndex++) {
              if (dateTime!.year == currentDate.year &&
                  dateTime.month == monthIndex) {
                isVisible = true;
                break;
              }
            }
            break;
          case DynamicFilterType.nextQuarter:
            temp = currentDate.month / 3 as int;
            if (currentDate.month % 3 != 0) {
              temp++;
            }
            if (temp == 4) {
              temp = 1;
              for (int monthIndex = (temp * 3) - 2;
                  monthIndex <= temp * 3;
                  monthIndex++) {
                if (dateTime!.year == currentDate.year + 1 &&
                    dateTime.month == monthIndex) {
                  isVisible = true;
                  break;
                }
              }
            } else {
              temp++;
              for (int monthIndex = (temp * 3) - 2;
                  monthIndex <= temp * 3;
                  monthIndex++) {
                if (dateTime!.year == currentDate.year &&
                    dateTime.month == monthIndex) {
                  isVisible = true;
                  break;
                }
              }
            }
            break;
          case DynamicFilterType.lastQuarter:
            temp = currentDate.month / 3 as int;
            if (currentDate.month % 3 != 0) {
              temp++;
            }
            if (temp == 1) {
              temp = 4;
              for (int monthIndex = (temp * 3) - 2;
                  monthIndex <= temp * 3;
                  monthIndex++) {
                if (dateTime!.year == currentDate.year - 1 &&
                    dateTime.month == monthIndex) {
                  isVisible = true;
                  break;
                }
              }
            } else {
              temp--;
              for (int monthIndex = (temp * 3) - 2;
                  monthIndex <= temp * 3;
                  monthIndex++) {
                if (dateTime!.year == currentDate.year &&
                    dateTime.month == monthIndex) {
                  isVisible = true;
                  break;
                }
              }
            }
            break;
          case DynamicFilterType.quarter1:
            for (int monthIndex = 1; monthIndex <= 3; monthIndex++) {
              if (dateTime!.month == monthIndex) {
                isVisible = true;
                break;
              }
            }
            break;
          case DynamicFilterType.quarter2:
            for (int monthIndex = 4; monthIndex <= 6; monthIndex++) {
              if (dateTime!.month == monthIndex) {
                isVisible = true;
                break;
              }
            }
            break;
          case DynamicFilterType.quarter3:
            for (int monthIndex = 7; monthIndex <= 9; monthIndex++) {
              if (dateTime!.month == monthIndex) {
                isVisible = true;
                break;
              }
            }
            break;
          case DynamicFilterType.quarter4:
            for (int monthIndex = 10; monthIndex <= 12; monthIndex++) {
              if (dateTime!.month == monthIndex) {
                isVisible = true;
                break;
              }
            }
            break;
          case DynamicFilterType.january:
            if (dateTime!.month == 1) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.february:
            if (dateTime!.month == 2) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.march:
            if (dateTime!.month == 3) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.april:
            if (dateTime!.month == 4) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.may:
            if (dateTime!.month == 5) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.june:
            if (dateTime!.month == 6) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.july:
            if (dateTime!.month == 7) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.august:
            if (dateTime!.month == 8) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.september:
            if (dateTime!.month == 9) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.october:
            if (dateTime!.month == 10) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.november:
            if (dateTime!.month == 11) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.december:
            if (dateTime!.month == 12) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.yearToDate:
            if (currentDate.year == dateTime!.year &&
                currentDate.day >= dateTime.day &&
                currentDate.month >= dateTime.month) {
              isVisible = true;
            }
            break;
          case DynamicFilterType.none:
            break;
        }
        range.showRows(isVisible);
      } else {
        range.showRows(false);
      }
    }
  }

  /// Remove the existing dynamic filter from filter collection.
  bool _removeDynamicFilter() {
    filterType = ExcelFilterType.customFilter;
    dateFilter.dateFilterType = DynamicFilterType.none;

    final Range filterRange = _autoFilterCollection.filterRange;
    final int firstRow = filterRange.row;
    final int lastRow = filterRange.lastRow;
    for (int row = firstRow + 1; row <= lastRow; row++) {
      _worksheet.getRangeByIndex(row, colIndex).showRows(true);
    }

    return true;
  }

  /// Add the date filter.
  @override
  void addDateFilter(DateTime? dateTime, DateTimeFilterType groupingType) {
    filterType = ExcelFilterType.combinationFilter;
    final DateTimeFilter dateTimeFilter = DateTimeFilter();
    dateTimeFilter.dateTime = dateTime!;
    dateTimeFilter.groupingType = groupingType;
    combinationFilter.filterCollection.add(dateTimeFilter);
    _applyTextFilter();
  }

  /// Apply the date time filter.
  void _applyDateTimeFilter() {
    final Range filterRange = _autoFilterCollection.filterRange;
    for (int row = filterRange.row + 1; row <= filterRange.lastRow; row++) {
      final Range range = _worksheet.getRangeByIndex(row, colIndex);
      if (range.dateTime != null) {
        for (int index = 0;
            index < _combinationFilter.filterCollection.length;
            index++) {
          final MultipleFilter filter =
              _combinationFilter.filterCollection[index];
          if (filter.combinationFilterType ==
              ExcelCombinationFilterType.dateTimeFilter) {
            final DateTimeFilter dateTimeFilter = filter as DateTimeFilter;
            final DateTimeFilterType dateGroup = dateTimeFilter.groupingType;
            final DateTime filterDate = dateTimeFilter.dateTime;
            final DateTime? dateTime = range.dateTime;
            if (filterDate.year == dateTime!.year) {
              if (dateGroup == DateTimeFilterType.year) {
                range.showRows(true);
                break;
              }
              if (filterDate.month == dateTime.month) {
                if (dateGroup == DateTimeFilterType.month) {
                  range.showRows(true);
                  break;
                }
                if (filterDate.day == dateTime.day) {
                  if (dateGroup == DateTimeFilterType.day) {
                    range.showRows(true);
                    break;
                  }
                  if (filterDate.hour == dateTime.hour) {
                    if (dateGroup == DateTimeFilterType.hour) {
                      range.showRows(true);
                      break;
                    }
                    if (filterDate.minute == dateTime.minute) {
                      if (dateGroup == DateTimeFilterType.minute) {
                        range.showRows(true);
                        break;
                      }
                      if (filterDate.second == dateTime.second) {
                        range.showRows(true);
                        break;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  /// Add the color filter.
  @override
  void addColorFilter(String color, ExcelColorFilterType colorFilterType) {
    filterType = ExcelFilterType.colorFilter;
    colorFilter.color = color;
    colorFilter.colorFilterType = colorFilterType;
    final Range filterRange = _autoFilterCollection.filterRange;
    if (color == '#000000') {
      switch (colorFilterType) {
        case ExcelColorFilterType.cellColor:
          color = '#FFFFFF';
          break;
        case ExcelColorFilterType.fontColor:
          color = _worksheet.book.styles['Normal']!.fontColor;
          break;
      }
    }
    for (int row = filterRange.row + 1; row <= filterRange.lastRow; row++) {
      final Range range = _worksheet.getRangeByIndex(row, colIndex);
      String toCompare = '#000000';
      if (colorFilterType == ExcelColorFilterType.cellColor) {
        toCompare = range.cellStyle.backColor;
      } else {
        toCompare = range.cellStyle.fontColor;
      }
      if (color != toCompare) {
        range.showRows(false);
      }
    }
  }

  /// To select the range in which the autofilter has to be applied
  void selectRangesToFilter() {
    Range filterRange = _autoFilterCollection.filterRange;
    final int row = filterRange.row;
    final int column = filterRange.column;
    int lastRow = filterRange.lastRow;
    final int lastColumn = filterRange.lastColumn;
    filterRange = _autoFilterCollection.includeBottomAdjacents(
        row, column, lastRow, lastColumn, filterRange);
    lastRow = filterRange.lastRow;
    _rangeList.clear();
    for (int rowIndex = row + 1; rowIndex <= lastRow; rowIndex++) {
      final Range range = _worksheet.getRangeByIndex(rowIndex, colIndex);
      _rangeList.addAll(<Range, double?>{range: range.number});
    }
  }

  ///To set condition to check which row going to hide based on condition operator
  void setCondition(
      ExcelFilterCondition conditionOperator,
      ExcelFilterDataType datatype,
      Object conditionValue,
      int currentAutoFilter,
      bool isFirstCondition) {
    if (datatype == ExcelFilterDataType.matchAllBlanks) {
      _setMatchAllBlanks();
    } else if (datatype == ExcelFilterDataType.matchAllNonBlanks) {
      _setMatchAllNonBlanks();
    } else {
      _setConditionImpl(conditionOperator, conditionValue, _worksheet,
          _rangeList, isFirstCondition);
    }
  }

  /// To show/hide rows based on the blanks.
  void _setMatchAllBlanks() {
    final Range filterRange = _autoFilterCollection.filterRange;
    int row = filterRange.row;
    final int lastRow = filterRange.lastRow;
    for (final int iRow = row; iRow <= lastRow; row++) {
      if (_worksheet.getRangeByIndex(iRow, colIndex).displayText.isEmpty) {
        _worksheet.getRangeByIndex(iRow, colIndex).showRows(true);
      } else {
        _worksheet.getRangeByIndex(iRow, colIndex).showRows(false);
      }
    }
  }

  /// To show/hide rows based on the non-blanks.
  void _setMatchAllNonBlanks() {
    final Range filterRange = _autoFilterCollection.filterRange;
    int row = filterRange.row;
    final int lastRow = filterRange.lastRow;
    for (final int iRow = row; iRow <= lastRow; row++) {
      if (_worksheet.getRangeByIndex(iRow, colIndex).displayText.isNotEmpty) {
        _worksheet.getRangeByIndex(iRow, colIndex).showRows(true);
      } else {
        _worksheet.getRangeByIndex(iRow, colIndex).showRows(false);
      }
    }
  }

  ///To set the condition Between Two Objects Based On ConditionOpertion
  void _setConditionImpl(
      ExcelFilterCondition conditionOperator,
      Object conditionValue,
      Worksheet worksheet,
      Map<Range, double?> range,
      bool isFirstCondition) {
    for (final Range key in range.keys) {
      if (conditionValue.runtimeType == double ||
          conditionValue.runtimeType == int) {
        late Object cellvalue, compareValue;

        switch (conditionOperator) {
          case ExcelFilterCondition.equal:
            if (conditionValue.runtimeType == String) {
              cellvalue = key.displayText;
              compareValue = conditionValue.toString();
            } else {
              cellvalue = key.getNumber();
              compareValue = conditionValue as double;
            }

            break;
          case ExcelFilterCondition.less:
          case ExcelFilterCondition.lessOrEqual:
          case ExcelFilterCondition.greater:
          case ExcelFilterCondition.notEqual:
          case ExcelFilterCondition.greaterOrEqual:
            cellvalue = key.getNumber();
            compareValue = conditionValue as double;
            break;
          case ExcelFilterCondition.contains:
          case ExcelFilterCondition.doesNotContain:
          case ExcelFilterCondition.beginsWith:
          case ExcelFilterCondition.doesNotBeginWith:
          case ExcelFilterCondition.endsWith:
          case ExcelFilterCondition.doesNotEndWith:
            //cellvalue = key.text.toString();
            //compareValue = conditionOperator.toString();
            break;
        }

        _getCompareResults(cellvalue, compareValue, conditionOperator,
            isFirstCondition, key.row);
      } else if (conditionValue.runtimeType == String) {
        late Object cellValue, compareValue;

        switch (conditionOperator) {
          case ExcelFilterCondition.less:
          case ExcelFilterCondition.lessOrEqual:
          case ExcelFilterCondition.greater:
          case ExcelFilterCondition.greaterOrEqual:
            break;
          case ExcelFilterCondition.equal:
          case ExcelFilterCondition.notEqual:
          case ExcelFilterCondition.contains:
          case ExcelFilterCondition.doesNotContain:
          case ExcelFilterCondition.beginsWith:
          case ExcelFilterCondition.doesNotBeginWith:
          case ExcelFilterCondition.endsWith:
          case ExcelFilterCondition.doesNotEndWith:
            cellValue = key.text.toString().toLowerCase();
            compareValue = conditionValue.toString().toLowerCase();
            break;
        }
        _getCompareResults(cellValue, compareValue, conditionOperator,
            isFirstCondition, key.row);
      }
    }
  }

  ///To get the result of comparison between two objects based on the condition operator
  void _getCompareResults(Object a, Object b,
      ExcelFilterCondition conditionOperator, bool isFirstCondition, int key) {
    late double doubleA;
    late double doubleB;
    late String stringA;
    late String stringB;
    late bool temp;
    if (a.runtimeType == double && b.runtimeType == double) {
      doubleA = a as double;
      doubleB = b as double;
    } else if (a.runtimeType == String && b.runtimeType == String) {
      stringA = a.toString();
      stringB = b.toString();
    }

    switch (conditionOperator) {
      case ExcelFilterCondition.less:
        if (doubleA < doubleB) {
          temp = true;
        } else {
          temp = false;
        }
        break;
      case ExcelFilterCondition.equal:
        if (a.runtimeType == String && b.runtimeType == String) {
          if (stringA == stringB) {
            temp = true;
          } else {
            temp = false;
          }
        } else {
          if (doubleA == doubleB) {
            temp = true;
          } else {
            temp = false;
          }
        }
        break;
      case ExcelFilterCondition.lessOrEqual:
        if (doubleA <= doubleB) {
          temp = true;
        } else {
          temp = false;
        }
        break;
      case ExcelFilterCondition.greater:
        if (doubleA > doubleB) {
          temp = true;
        } else {
          temp = false;
        }
        break;
      case ExcelFilterCondition.notEqual:
        if (doubleA != doubleB) {
          temp = true;
        } else {
          temp = false;
        }
        break;
      case ExcelFilterCondition.greaterOrEqual:
        if (doubleA >= doubleB) {
          temp = true;
        } else {
          temp = false;
        }
        break;
      case ExcelFilterCondition.contains:
        if (stringA.contains(stringB)) {
          temp = true;
        } else {
          temp = false;
        }
        break;
      case ExcelFilterCondition.doesNotContain:
        if (!stringA.contains(stringB)) {
          temp = true;
        } else {
          temp = false;
        }
        break;
      case ExcelFilterCondition.beginsWith:
        if (stringA.startsWith(stringB)) {
          temp = true;
        } else {
          temp = false;
        }
        break;
      case ExcelFilterCondition.doesNotBeginWith:
        if (!stringA.startsWith(stringB)) {
          temp = true;
        } else {
          temp = false;
        }
        break;
      case ExcelFilterCondition.endsWith:
        if (stringA.endsWith(stringB)) {
          temp = true;
        } else {
          temp = false;
        }
        break;
      case ExcelFilterCondition.doesNotEndWith:
        if (!stringA.endsWith(stringB)) {
          temp = true;
        } else {
          temp = false;
        }
        break;
    }
    if (isFirstCondition) {
      firstConditionboolList.add(temp);
      _rangeListtemp.add(key);
    } else {
      secondConditionboolList.add(temp);
      if (_rangeListtemp.isEmpty) {
        _rangeListtemp.add(key);
      }
    }
  }

  /// Show/hide a row by checking/changing the property hidden by filters
  void showFilteredRow(List<bool> firstCondition, List<bool> secondCondition) {
    if (logicalOperator == ExcelLogicalOperator.and) {
      for (int temp = 0; temp <= _rangeListtemp.length - 1; temp++) {
        if (firstConditionboolList[temp] && secondConditionboolList[temp]) {
          _worksheet
              .getRangeByIndex(_rangeListtemp[temp], colIndex)
              .showRows(true);
        } else {
          _worksheet
              .getRangeByIndex(_rangeListtemp[temp], colIndex)
              .showRows(false);
        }
      }
    } else {
      if (firstConditionboolList.isNotEmpty &&
          secondConditionboolList.isNotEmpty) {
        for (int temp = 0; temp <= _rangeListtemp.length - 1; temp++) {
          if (firstConditionboolList[temp] || secondConditionboolList[temp]) {
            _worksheet
                .getRangeByIndex(_rangeListtemp[temp], colIndex)
                .showRows(true);
          } else {
            _worksheet
                .getRangeByIndex(_rangeListtemp[temp], colIndex)
                .showRows(false);
          }
        }
      } else if (firstConditionboolList.isNotEmpty &&
          secondConditionboolList.isEmpty) {
        for (int temp = 0; temp <= _rangeListtemp.length - 1; temp++) {
          if (firstConditionboolList[temp]) {
            _worksheet
                .getRangeByIndex(_rangeListtemp[temp], colIndex)
                .showRows(true);
          } else {
            _worksheet
                .getRangeByIndex(_rangeListtemp[temp], colIndex)
                .showRows(false);
          }
        }
      } else if (firstConditionboolList.isEmpty &&
          secondConditionboolList.isNotEmpty) {
        for (int temp = 0; temp <= _rangeListtemp.length - 1; temp++) {
          if (secondConditionboolList[temp]) {
            _worksheet
                .getRangeByIndex(_rangeListtemp[temp], colIndex)
                .showRows(true);
          } else {
            _worksheet
                .getRangeByIndex(_rangeListtemp[temp], colIndex)
                .showRows(false);
          }
        }
      }
    }
  }

  /// Creates new instances of condition variables.
  void intializeConditions() {
    _combinationFilter = CombinationFilter(this);
    _firstconditions = AutofilterConditionImpl(this);
    _secondconditions = AutofilterConditionImpl(this);
    dateFilter = DynamicFilter(this);
    colorFilter = ColorFilter(this);
  }
}
