part of xlsio;

///class For Autofilter Condition implementation
class _AutofilterConditionImpl implements AutoFilterCondition {
  ///Constructor for AutoFilterConditionImpl class
  _AutofilterConditionImpl(_AutoFilterImpl autoFilter) {
    _autoFilter = autoFilter;
  }

  /// Represents the _AutoFilterImpl parent class.
  late _AutoFilterImpl _autoFilter;

  ///Represents filter's datatype
  late _ExcelFilterDataType _filterDataType = _ExcelFilterDataType.notUsed;

  ///Represents conditional operator to Perform operation
  late ExcelFilterCondition _conditionOperator;

  ///Represents double data Type
  late double _double;

  ///Represents String dataType
  late String _string;

  ///Set excelFilterData type
  @override
  set _dataType(_ExcelFilterDataType value) {
    _filterDataType = value;
  }

  ///Get excelFilterData type
  @override
  _ExcelFilterDataType get _dataType {
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

    _dataType = _ExcelFilterDataType.floatingPoint;

    if (_autoFilter._isFirstCondition) {
      final AutoFilterCondition firstCondition = _autoFilter.firstCondition;

      if (firstCondition.numberValue == value &&
          firstCondition._dataType == _dataType &&
          firstCondition.conditionOperator == conditionOperator) {
        _autoFilter._selectRangesToFilter();
        _autoFilter._filtertype = _ExcelFilterType.customFilter;
        _autoFilter._setCondition(firstCondition.conditionOperator,
            firstCondition._dataType, value, _autoFilter._colIndex, true);
      }
    }
    if (_autoFilter._isSecondCondition) {
      final AutoFilterCondition secondCondition = _autoFilter.secondCondition;
      if (secondCondition.numberValue == value &&
          secondCondition._dataType == _dataType &&
          secondCondition.conditionOperator == conditionOperator) {
        _autoFilter._selectRangesToFilter();
        _autoFilter._typeOfFilter = _ExcelFilterType.customFilter;
        _autoFilter._setCondition(secondCondition.conditionOperator,
            secondCondition._dataType, value, _autoFilter._colIndex, false);
      }
    }
    _autoFilter._showFilteredRow(_autoFilter._firstConditionboolList,
        _autoFilter._secondConditionboolList);
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
    _dataType = _ExcelFilterDataType.string;

    if (_autoFilter._isFirstCondition) {
      final AutoFilterCondition firstCondition = _autoFilter.firstCondition;
      if (firstCondition.textValue == value &&
          firstCondition._dataType == _dataType &&
          firstCondition.conditionOperator == conditionOperator) {
        _autoFilter._selectRangesToFilter();
        _autoFilter._filtertype = _ExcelFilterType.customFilter;
        _autoFilter._setCondition(firstCondition.conditionOperator,
            firstCondition._dataType, value, _autoFilter._colIndex, true);
      }
    }

    if (_autoFilter._isSecondCondition) {
      final AutoFilterCondition secondCondition = _autoFilter.secondCondition;
      if (secondCondition.textValue == value &&
          secondCondition._dataType == _dataType &&
          secondCondition.conditionOperator == conditionOperator) {
        _autoFilter._selectRangesToFilter();
        _autoFilter._typeOfFilter = _ExcelFilterType.customFilter;
        _autoFilter._setCondition(secondCondition.conditionOperator,
            secondCondition._dataType, value, _autoFilter._colIndex, false);
      }
    }

    _autoFilter._showFilteredRow(_autoFilter._firstConditionboolList,
        _autoFilter._secondConditionboolList);
  }
}
