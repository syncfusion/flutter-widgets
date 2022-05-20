part of xlsio;

/// Represents a dataValidationWrapper used for Single Range
class _DataValidationWrapper implements DataValidation {
  /// Create a instance for dataValidationWrapper
  _DataValidationWrapper(Range range, _DataValidationImpl? wrap) {
    _sheet = range.worksheet;
    _range = range;
    if (wrap == null) {
      if (_sheet._dvTable._innerList.isNotEmpty) {
        _dvCollection = _sheet._dvTable._innerList[0];
      } else {
        _dvCollection = _sheet._dvTable._add();
      }

      wrap = _dvCollection._addDataValidation();
    }

    _mdataValidation = wrap;
    _mdataValidation._cellRange = _range._dvValue;
    _mdataValidation._dataRangeVal = range;
  }

  /// stores the entire range from range class
  late Range _range;

  /// Represents the parent Worksheet
  late Worksheet _sheet;

  /// Represents an instance for DataValidationCollection
  late _DataValidationCollection _dvCollection;

  /// Represents an instance for DataValidationImpl
  late _DataValidationImpl _mdataValidation;

  @override

  /// gets or sets the type of allowType for DataValidation
  ExcelDataValidationType get allowType {
    return _mdataValidation.allowType;
  }

  @override

  /// gets or sets the allowType for DataValidation
  set allowType(ExcelDataValidationType value) {
    if (allowType != value) {
      _mdataValidation.allowType = value;
    }
    if (_mdataValidation.isListInFormula &&
        value != ExcelDataValidationType.user) {
      _mdataValidation.isListInFormula = false;
    }
  }

  @override

  /// gets or sets the type of comparisonOperator for DataValidation
  ExcelDataValidationComparisonOperator get comparisonOperator {
    return _mdataValidation.comparisonOperator;
  }

  @override

  /// gets or sets the comparisonOperator value for DataValidation
  set comparisonOperator(ExcelDataValidationComparisonOperator value) {
    if (comparisonOperator != value) {
      _mdataValidation.comparisonOperator = value;
    }
  }

  @override

  /// gets or sets the firstFormula for DataValidation
  String get firstFormula {
    if (allowType == ExcelDataValidationType.date) {
      return _mdataValidation.firstDateTime.toString();
    } else if (allowType == ExcelDataValidationType.time) {
      return _mdataValidation.firstFormula;
    } else {
      return _mdataValidation.firstFormula;
    }
  }

  @override

  /// gets or sets the firstFormula for DataValidation
  set firstFormula(String value) {
    if (firstFormula != value) {
      _mdataValidation.firstFormula = value;
    }
  }

  @override

  /// gets or sets the firstDateTime for DataValidation
  DateTime get firstDateTime {
    return _mdataValidation.firstDateTime;
  }

  @override

  /// gets or sets the firstDateTime for DataValidation
  set firstDateTime(DateTime value) {
    if (firstDateTime != value || firstDateTime == DateTime(1)) {
      _mdataValidation.firstDateTime = value;
    }
  }

  @override

  /// gets or sets the secondDateTime for DataValidation
  DateTime get secondDateTime {
    return _mdataValidation.secondDateTime;
  }

  @override

  /// gets or sets the secondDateTime for DataValidation
  set secondDateTime(DateTime value) {
    if (secondDateTime != value || firstDateTime == DateTime(1)) {
      _mdataValidation.secondDateTime = value;
    }
  }

  @override

  /// gets or sets the secondFormula for DataValidation
  String get secondFormula {
    if (allowType == ExcelDataValidationType.date) {
      return _mdataValidation.secondDateTime.toString();
    } else if (allowType == ExcelDataValidationType.time) {
      return _mdataValidation.secondFormula;
    } else {
      return _mdataValidation.secondFormula;
    }
  }

  @override

  /// gets or sets the secondFormula for DataValidation
  set secondFormula(String value) {
    if (secondFormula != value) {
      _mdataValidation.secondFormula = value;
    }
  }

  @override

  /// gets or sets the showErrorBox for DataValidation
  bool get showErrorBox {
    return _mdataValidation.showErrorBox;
  }

  @override

  /// gets or sets the showErrorBox for DataValidation
  set showErrorBox(bool value) {
    if (showErrorBox != value) {
      _mdataValidation.showErrorBox = value;
    }
  }

  @override

  /// gets or sets the errorBoxText for DataValidation
  set errorBoxText(String value) {
    if (errorBoxText != value) {
      _mdataValidation.errorBoxText = value;
    }
  }

  @override

  /// gets or sets the errorBoxText for DataValidation
  String get errorBoxText {
    return _mdataValidation.errorBoxText;
  }

  @override

  /// gets or sets the errorBoxTitle for DataValidation
  set errorBoxTitle(String value) {
    if (errorBoxTitle != value) {
      _mdataValidation.errorBoxTitle = value;
    }
  }

  @override

  /// gets or sets the errorBoxTitle for DataValidation
  String get errorBoxTitle {
    return _mdataValidation.errorBoxTitle;
  }

  @override

  /// gets or sets the promptBoxText for DataValidation
  set promptBoxText(String value) {
    if (promptBoxText != value) {
      _mdataValidation.promptBoxText = value;
    }
  }

  @override

  /// gets or sets the promptBoxText for DataValidation
  String get promptBoxText {
    return _mdataValidation.promptBoxText;
  }

  @override

  /// gets or sets the showPromptBox for DataValidation
  set showPromptBox(bool value) {
    if (showPromptBox != value) {
      _mdataValidation.showPromptBox = value;
    }
  }

  @override

  /// gets or sets the showPromptBox for DataValidation
  bool get showPromptBox {
    return _mdataValidation.showPromptBox;
  }

  @override

  /// gets or sets the promptBoxTitle for DataValidation
  set promptBoxTitle(String value) {
    if (promptBoxTitle != value) {
      _mdataValidation.promptBoxTitle = value;
    }
  }

  @override

  /// gets or sets the promptBoxTitle for DataValidation
  String get promptBoxTitle {
    return _mdataValidation.promptBoxTitle;
  }

  @override

  /// gets or sets the promptBoxVposition for DataValidation
  set promptBoxVPosition(int value) {
    if (promptBoxVPosition != value) {
      _mdataValidation.promptBoxVPosition = value;
      _dvCollection._promptBoxVPositionVal = value;
    }
  }

  @override

  /// gets or sets the promptBoxVposition for DataValidation
  int get promptBoxVPosition {
    return _mdataValidation.promptBoxVPosition;
  }

  @override

  /// gets or sets the promptBoxHposition for DataValidation
  set promptBoxHPosition(int value) {
    if (promptBoxHPosition != value) {
      _mdataValidation.promptBoxHPosition = value;
      _dvCollection._promptBoxHPositionVal = value;
    }
  }

  @override

  /// gets or sets the promptBoxHposition for DataValidation
  int get promptBoxHPosition {
    return _mdataValidation.promptBoxHPosition;
  }

  @override

  /// gets or sets the isPromptBoxPositionFixed for DataValidation.
  set isPromptBoxPositionFixed(bool value) {
    if (isPromptBoxPositionFixed != value) {
      _mdataValidation.isPromptBoxPositionFixed = value;
      _dvCollection._isPromptBoxPositionFixedVal = value;
    }
  }

  @override

  /// gets or sets the isPromptBoxPositionFixed for DataValidation
  bool get isPromptBoxPositionFixed {
    return _mdataValidation.isPromptBoxPositionFixed;
  }

  @override

  /// gets or sets the isEmptyCellAllowed for DataValidation
  set isEmptyCellAllowed(bool value) {
    if (isEmptyCellAllowed != value) {
      _mdataValidation.isEmptyCellAllowed = value;
    }
  }

  @override

  /// gets or sets the isEmptyCellAllowed for DataValidation
  bool get isEmptyCellAllowed {
    return _mdataValidation.isEmptyCellAllowed;
  }

  @override

  /// gets or sets the errorStyle for DataValidation
  set errorStyle(ExcelDataValidationErrorStyle value) {
    if (errorStyle != value) {
      _mdataValidation.errorStyle = value;
    }
  }

  @override

  /// gets or sets the errorStyle for DataValidation
  ExcelDataValidationErrorStyle get errorStyle {
    return _mdataValidation.errorStyle;
  }

  @override

  /// gets or sets the isListInFormula for DataValidation
  set isListInFormula(bool value) {
    if (isListInFormula != value) {
      _mdataValidation.isListInFormula = value;
    }
  }

  @override

  /// gets or sets the isListInFormula for DataValidation
  bool get isListInFormula {
    return _mdataValidation.isListInFormula;
  }

  @override

  /// gets or sets the isSuppressDropDownArrow for DataValidation
  set isSuppressDropDownArrow(bool value) {
    if (isSuppressDropDownArrow != value) {
      _mdataValidation.isSuppressDropDownArrow = value;
    }
  }

  @override

  /// gets or sets the isSuppressDropDownArrow for DataValidation
  bool get isSuppressDropDownArrow {
    return _mdataValidation.isSuppressDropDownArrow;
  }

  @override

  /// gets or sets the dataRange for DataValidation
  set dataRange(Range value) {
    _mdataValidation.dataRange = value;
    //_mdataValidation._cellRange = value._dvValue;
  }

  @override

  /// gets or sets the dataRange for DataValidation
  Range get dataRange {
    return _mdataValidation.dataRange;
  }

  @override

  /// gets or sets the listOfValues for DataValidation
  List<String> get listOfValues {
    return _mdataValidation.listOfValues;
  }

  @override

  /// gets or sets the listOfValues for DataValidation
  set listOfValues(List<String> value) {
    _mdataValidation.listOfValues = value;
  }
}
