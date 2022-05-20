part of xlsio;

/// Represents the class used for storing DataValidationImpl properties
class _DataValidationImpl implements DataValidation {
  /// Represents the instance created for DataValidationImpl
  _DataValidationImpl() {
    _allowTypeVal = ExcelDataValidationType.any;
    _isListInformulaVal = false;
    _comparisonOperatorVal = ExcelDataValidationComparisonOperator.between;
    _firstDateTimeVal = DateTime(1);
    _secondDateTimeVal = DateTime(1);
    _firstFormulaVal = '';
    _secondFormulaVal = '';
    _showErrorBoxVal = true;
    _errorBoxTextVal = '';
    _errorBoxTitleVal = '';
    _promptBoxTextVal = '';
    _showPromptBoxVal = true;
    _promptBoxTitleVal = '';
    _cellRange = '';
    _isSuppressDropDownArrowVal = false;
    _isEmptyCellAllowedVal = true;
    _errorStyleVal = ExcelDataValidationErrorStyle.stop;

    _listOfValuesVal = <String>[];
  }

  /// Represents the variable for storing the maximum textLimit
  /// for errorBoxTitle and promptBoxTitle
  static const int _textLimit = 225;

  /// Represents the variable used for getting and setting allowType values
  late ExcelDataValidationType _allowTypeVal;

  /// Represents the variable used for getting and setting isListInFormula values
  late bool _isListInformulaVal;

  /// Represents the variable used for getting and setting comparisonOperator values
  late ExcelDataValidationComparisonOperator _comparisonOperatorVal;

  /// Represents the variable used for getting and setting firstDateTime values
  late DateTime _firstDateTimeVal;

  /// Represents the variable used for getting and setting secondDateTime values
  late DateTime _secondDateTimeVal;

  /// Represents the variable used for getting and setting firstFormula values
  late String _firstFormulaVal;

  /// Represents the variable used for getting and setting secondFormula values
  late String _secondFormulaVal;

  /// Represents the variable used for getting and setting showErrorBox values
  late bool _showErrorBoxVal;

  /// Represents the variable used for getting and setting errorBoxText values
  late String _errorBoxTextVal;

  /// Represents the variable used for getting and setting errorBoxTitle values
  late String _errorBoxTitleVal;

  /// Represents the variable used for getting and setting promptBoxText values
  late String _promptBoxTextVal;

  /// Represents the variable used for getting and setting showPromptBox values
  late bool _showPromptBoxVal;

  /// Represents the variable used for getting and setting promptBoxTitle values
  late String _promptBoxTitleVal;

  /// Represents an instance for DataValidationCollection
  final _DataValidationCollection _dataValidationCollection =
      _DataValidationCollection();

  ///Represents the variable used for getting and setting isSuppressDropDownArrow values
  late bool _isSuppressDropDownArrowVal;

  ///Represents the variable used for getting and setting isEmptyCellAllowed values
  late bool _isEmptyCellAllowedVal;

  ///Represents the variable used for getting and setting errorStyle values
  late ExcelDataValidationErrorStyle _errorStyleVal;

  ///Represents the variable used for getting and setting dataRange values
  late Range _dataRangeVal;

  ///Represents the variable used for getting and setting listOfValues values
  late List<String> _listOfValuesVal;

  ///Represents the variable used for getting cellRange values
  late String _cellRange;

  @override

  /// gets or sets the dataRange for DataValidation
  set dataRange(Range value) {
    _dataRangeVal = value;
    _allowTypeVal = ExcelDataValidationType.user;
  }

  @override

  /// gets or sets the dataRange for DataValidation
  Range get dataRange {
    return _dataRangeVal;
  }

  @override

  /// gets or sets the type of allowType for DataValidation
  ExcelDataValidationType get allowType {
    return _allowTypeVal;
  }

  @override

  /// gets or sets the type of allowType for DataValidation
  set allowType(ExcelDataValidationType value) {
    _allowTypeVal = value;
  }

  @override

  /// gets or sets the isListInFormula for DataValidation
  bool get isListInFormula {
    return _isListInformulaVal;
  }

  @override

  /// gets or sets the isListInFormula for DataValidation
  set isListInFormula(bool value) {
    _isListInformulaVal = value;
  }

  @override

  /// gets or sets the comparisonOperator value for DataValidation
  set comparisonOperator(ExcelDataValidationComparisonOperator value) {
    _comparisonOperatorVal = value;
  }

  @override

  /// gets or sets the comparisonOperator value for DataValidation
  ExcelDataValidationComparisonOperator get comparisonOperator {
    return _comparisonOperatorVal;
  }

  @override

  /// gets or sets the firstDateTime for DataValidation
  DateTime get firstDateTime {
    return _firstDateTimeVal;
  }

  @override

  /// gets or sets the firstDateTime for DataValidation
  set firstDateTime(DateTime value) {
    _firstDateTimeVal = value;
  }

  @override

  /// gets or sets the firstFormula for DataValidation
  set firstFormula(String value) {
    if (firstFormula != value) {
      _firstFormulaVal = value;
    }
  }

  @override

  /// gets or sets the firstFormula for DataValidation
  String get firstFormula {
    return _firstFormulaVal;
  }

  @override

  /// gets or sets the secondFormula for DataValidation
  set secondFormula(String value) {
    if (secondFormula != value) {
      _secondFormulaVal = value;
    }
  }

  @override

  /// gets or sets the secondFormula for DataValidation
  String get secondFormula {
    return _secondFormulaVal;
  }

  @override

  /// gets or sets the showErrorBox for DataValidation
  set showErrorBox(bool value) {
    _showErrorBoxVal = value;
  }

  @override

  /// gets or sets the showErrorBox for DataValidation
  bool get showErrorBox {
    return _showErrorBoxVal;
  }

  @override

  /// gets or sets the secondDateTime for DataValidation
  set secondDateTime(DateTime value) {
    _secondDateTimeVal = value;
  }

  @override

  /// gets or sets the secondDateTime for DataValidation
  DateTime get secondDateTime {
    return _secondDateTimeVal;
  }

  @override

  /// gets or sets the errorBoxText for DataValidation
  set errorBoxText(String value) {
    _checkLimit('ErrorBoxText', value, _textLimit);
    _errorBoxTextVal = value;
  }

  @override

  /// gets or sets the errorBoxText for DataValidation
  String get errorBoxText {
    return _errorBoxTextVal;
  }

  @override

  /// gets or sets the errorBoxTitle for DataValidation
  set errorBoxTitle(String value) {
    _checkLimit('ErrorBoxTitle', value, _textLimit);
    _errorBoxTitleVal = value;
  }

  @override

  /// gets or sets the errorBoxTitle for DataValidation
  String get errorBoxTitle {
    return _errorBoxTitleVal;
  }

  @override

  /// gets or sets the promptBoxText for DataValidation
  set promptBoxText(String value) {
    _checkLimit('PromptBoxText', value, _textLimit);
    _promptBoxTextVal = value;
  }

  @override

  /// gets or sets the promptBoxText for DataValidation
  String get promptBoxText {
    return _promptBoxTextVal;
  }

  @override

  /// gets or sets the showPromptBox for DataValidation
  set showPromptBox(bool value) {
    _showPromptBoxVal = value;
  }

  @override

  /// gets or sets the showPromptBox for DataValidation
  bool get showPromptBox {
    return _showPromptBoxVal;
  }

  @override

  /// gets or sets the promptBoxTitle for DataValidation
  set promptBoxTitle(String value) {
    _checkLimit('PromptBoxTitle', value, _textLimit);
    _promptBoxTitleVal = value;
  }

  @override

  /// gets or sets the promptBoxTitle for DataValidation
  String get promptBoxTitle {
    return _promptBoxTitleVal;
  }

  @override

  /// gets or sets the promptBoxVposition for DataValidation
  set promptBoxVPosition(int value) {
    _dataValidationCollection._promptBoxVPositionVal = value;
  }

  @override

  /// gets or sets the promptBoxVposition for DataValidation
  int get promptBoxVPosition {
    return _dataValidationCollection._promptBoxVPositionVal;
  }

  @override

  /// gets or sets the promptBoxHposition for DataValidation
  set promptBoxHPosition(int value) {
    _dataValidationCollection._promptBoxHPositionVal = value;
  }

  @override

  /// gets or sets the promptBoxHposition for DataValidation
  int get promptBoxHPosition {
    return _dataValidationCollection._promptBoxHPositionVal;
  }

  @override

  /// gets or sets the isPromptBoxPositionFixed for DataValidation
  set isPromptBoxPositionFixed(bool value) {
    _dataValidationCollection._isPromptBoxPositionFixedVal = value;
  }

  @override

  /// gets or sets the isPromptBoxPositionFixed for DataValidation
  bool get isPromptBoxPositionFixed {
    return _dataValidationCollection._isPromptBoxPositionFixedVal;
  }

  @override

  ///gets or sets the isSuppressDropDownArrow for DataValidation
  set isSuppressDropDownArrow(bool value) {
    _isSuppressDropDownArrowVal = value;
  }

  @override

  /// gets or sets the isSuppressDropDownArrow for DataValidation
  bool get isSuppressDropDownArrow {
    return _isSuppressDropDownArrowVal;
  }

  @override

  /// gets or sets the isEmptyCellAllowed for DataValidation
  set isEmptyCellAllowed(bool value) {
    _isEmptyCellAllowedVal = value;
  }

  @override

  /// gets or sets the isEmptyCellAllowed for DataValidation
  bool get isEmptyCellAllowed {
    return _isEmptyCellAllowedVal;
  }

  @override

  /// gets or sets the errorStyle for DataValidation
  set errorStyle(ExcelDataValidationErrorStyle value) {
    _errorStyleVal = value;
  }

  @override

  /// gets or sets the errorStyle for DataValidation
  ExcelDataValidationErrorStyle get errorStyle {
    return _errorStyleVal;
  }

  @override

  /// gets or sets the listOfValues for DataValidation
  set listOfValues(List<String> value) {
    _listOfValuesVal = value;
    _isListInformulaVal = true;
    _allowTypeVal = ExcelDataValidationType.user;
  }

  @override

  /// gets or sets the listOfValues for DataValidation
  List<String> get listOfValues {
    return _listOfValuesVal;
  }

  /// Represents the method used for checking the limit for promptBoxTitle and errorBoxTitle
  void _checkLimit(String text, String value, int textLimit) {
    if (value.length > textLimit) {
      throw Exception('the textLimit should not exceed 225 characters');
    }
  }
}
