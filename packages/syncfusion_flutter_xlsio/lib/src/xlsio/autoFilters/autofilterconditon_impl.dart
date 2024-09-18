import '../general/enums.dart';
import 'autofilter_impl.dart';
import 'autofiltercondition.dart';

///class For Autofilter Condition implementation
class AutofilterConditionImpl implements AutoFilterCondition {
  ///Constructor for AutoFilterConditionImpl class
  AutofilterConditionImpl(AutoFilterImpl autoFilterImpl) {
    autoFilter = autoFilterImpl;
  }

  /// Represents the _AutoFilterImpl parent class.
  late AutoFilterImpl autoFilter;

  ///Represents filter's datatype
  late ExcelFilterDataType _filterDataType = ExcelFilterDataType.notUsed;

  ///Represents conditional operator to Perform operation
  late ExcelFilterCondition _conditionOperator;

  ///Represents double data Type
  late double _double;

  ///Represents String dataType
  late String _string;

  ///Set excelFilterData type
  @override
  set dataType(ExcelFilterDataType value) {
    _filterDataType = value;
  }

  ///Get excelFilterData type
  @override
  ExcelFilterDataType get dataType {
    return _filterDataType;
  }

  ///Set ExcelFilter condition
  @override
  set conditionOperator(ExcelFilterCondition value) {
    _conditionOperator = value;
  }

  ///Set ExcelFilter condition
  @override
  ExcelFilterCondition get conditionOperator {
    return _conditionOperator;
  }

  ///Get double value
  @override
  double get numberValue {
    return _double;
  }

  ///Set double Value
  @override
  set numberValue(double value) {
    _double = value;

    dataType = ExcelFilterDataType.floatingPoint;

    if (autoFilter.isFirstCondition) {
      final AutoFilterCondition firstCondition = autoFilter.firstCondition;

      if (firstCondition.numberValue == value &&
          firstCondition.dataType == dataType &&
          firstCondition.conditionOperator == conditionOperator) {
        autoFilter.selectRangesToFilter();
        autoFilter.filterType = ExcelFilterType.customFilter;
        autoFilter.setCondition(firstCondition.conditionOperator,
            firstCondition.dataType, value, autoFilter.colIndex, true);
      }
    }
    if (autoFilter.isSecondCondition) {
      final AutoFilterCondition secondCondition = autoFilter.secondCondition;
      if (secondCondition.numberValue == value &&
          secondCondition.dataType == dataType &&
          secondCondition.conditionOperator == conditionOperator) {
        autoFilter.selectRangesToFilter();
        autoFilter.filterType = ExcelFilterType.customFilter;
        autoFilter.setCondition(secondCondition.conditionOperator,
            secondCondition.dataType, value, autoFilter.colIndex, false);
      }
    }
    autoFilter.showFilteredRow(
        autoFilter.firstConditionboolList, autoFilter.secondConditionboolList);
  }

  ///Get string value
  @override
  String get textValue {
    return _string;
  }

  ///Set string value
  @override
  set textValue(String value) {
    _string = value;
    dataType = ExcelFilterDataType.string;

    if (autoFilter.isFirstCondition) {
      final AutoFilterCondition firstCondition = autoFilter.firstCondition;
      if (firstCondition.textValue == value &&
          firstCondition.dataType == dataType &&
          firstCondition.conditionOperator == conditionOperator) {
        autoFilter.selectRangesToFilter();
        autoFilter.filterType = ExcelFilterType.customFilter;
        autoFilter.setCondition(firstCondition.conditionOperator,
            firstCondition.dataType, value, autoFilter.colIndex, true);
      }
    }

    if (autoFilter.isSecondCondition) {
      final AutoFilterCondition secondCondition = autoFilter.secondCondition;
      if (secondCondition.textValue == value &&
          secondCondition.dataType == dataType &&
          secondCondition.conditionOperator == conditionOperator) {
        autoFilter.selectRangesToFilter();
        autoFilter.filterType = ExcelFilterType.customFilter;
        autoFilter.setCondition(secondCondition.conditionOperator,
            secondCondition.dataType, value, autoFilter.colIndex, false);
      }
    }

    autoFilter.showFilteredRow(
        autoFilter.firstConditionboolList, autoFilter.secondConditionboolList);
  }
}
