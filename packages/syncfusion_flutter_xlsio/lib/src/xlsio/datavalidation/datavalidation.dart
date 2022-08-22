part of xlsio;

/// Represents data validation for a worksheet range.
class DataValidation {
  /// Gets or sets the type of allowType.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the first formula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the errorbox text
  /// textLengthValidation.errorBoxText =
  ///     'Text length should be between 1 and 5';
  ///
  /// //sets the errorbox title
  /// textLengthValidation.errorBoxTitle = 'ERROR';
  ///
  /// //sets the promptBox title
  /// textLengthValidation.promptBoxTitle = 'TextLength';
  ///
  /// //sets the promptbox text
  /// textLengthValidation.promptBoxText = 'Data validation for text length';
  ///
  /// //sets the promptBoxVisibility
  /// textLengthValidation.showPromptBox = true;
  ///
  /// //sets the errorStyle
  /// textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late ExcelDataValidationType allowType;

  /// Gets or sets the listOfValues for DataValidation
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in worksheet and applying the Formula with Between property
  /// final DataValidation listValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// listalidation.allowType = ExcelDataValidationType.user;
  ///
  ///
  /// //sets the listofValues
  /// listValidation.listOfValues = <String>['List1', 'List2', 'List3'];
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExcelUserValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late List<String> listOfValues;

  /// Gets or sets the firstFormula.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  ///  final DataValidation textLengthValidation =
  ///  sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  ///  textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  ///  textLengthValidation.comparisonOperator =
  ///  ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the firstFormula
  ///  textLengthValidation.firstFormula = '1';
  ///
  /// //sets the secondFormula
  ///  textLengthValidation.secondFormula = '5';
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceldateValidation.xlsx');
  /// workbook.dispose();
  /// ```
  late String firstFormula;

  /// Gets or sets the secondFormula
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  ///  final DataValidation textLengthValidation =
  ///  sheet.getRangeByName('A1').dataValidation;
  ///
  ///  //sets the allowType
  ///  textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  ///  textLengthValidation.comparisonOperator =
  ///  ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the firstFormula
  ///  textLengthValidation.firstFormula = '1';
  ///
  /// //sets the secondFormula
  ///  textLengthValidation.secondFormula = '5';
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceldateValidation.xlsx');
  /// workbook.dispose();
  /// ```

  late String secondFormula;

  /// Gets or sets the firstDateTime.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the date properties
  /// final DataValidation dateValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// dateValidation.allowType = ExcelDataValidationType.date;
  ///
  /// //sets the comparisonOperator
  /// dateValidation.comparisonperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the firstDate
  /// dateValidation.firstDateTime = DateTime(1997, 07, 22);
  ///
  /// //sets the secondDate
  /// dateValidation.secondDateTime = DateTime(1997, 07, 25);
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceldateValidation.xlsx');
  /// workbook.dispose();
  /// ```
  late DateTime firstDateTime;

  /// Gets or sets the secondDateTime.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the date properties
  /// final DataValidation dateValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// dateValidation.allowType = ExcelDataValidationType.date;
  ///
  /// //sets the comparisonOperator
  /// dateValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the firstDate
  /// dateValidation.firstDateTime = DateTime(1997, 07, 22);
  ///
  /// //sets the secondDate
  /// dateValidation.secondDateTime = DateTime(1997, 07, 25);
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceldateValidation.xlsx');
  /// workbook.dispose();
  /// ```
  late DateTime secondDateTime;

  /// Gets or sets the showErrorBox.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the first formula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the errorbox text
  /// textLengthValidation.errorBoxText =
  ///     'Text length should be between 1 and 5';
  ///
  /// //sets the errorbox title
  /// textLengthValidation.errorBoxTitle = 'ERROR';
  ///
  /// //sets the promptBox title
  /// textLengthValidation.promptBoxTitle = 'TextLength';
  ///
  /// //sets the showErrorBox
  /// textLengthValidation.showErrorBox=true;
  ///
  /// //sets the promptbox text
  /// textLengthValidation.promptBoxText = 'Data validation for text length';
  ///
  /// //sets the promptBoxVisibility
  /// textLengthValidation.showPromptBox = true;
  ///
  /// //sets the errorStyle
  /// textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late bool showErrorBox;

  /// Gets or sets the errorBoxText.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the first formula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the errorbox text
  /// textLengthValidation.errorBoxText =
  ///     'Text length should be between 1 and 5';
  ///
  /// //sets the errorbox title
  /// textLengthValidation.errorBoxTitle = 'ERROR';
  ///
  /// //sets the promptBox title
  /// textLengthValidation.promptBoxTitle = 'TextLength';
  ///
  /// //sets the showErrorBox
  /// textLengthValidation.showErrorBox=true;
  ///
  /// //sets the promptbox text
  /// textLengthValidation.promptBoxText = 'Data validation for text length';
  ///
  /// //sets the promptBoxVisibility
  /// textLengthValidation.showPromptBox = true;
  ///
  /// //sets the errorStyle
  /// textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late String errorBoxText;

  /// Gets or sets the errorBoxTitle.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the first formula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the errorbox text
  /// textLengthValidation.errorBoxText =
  ///     'Text length should be between 1 and 5';
  ///
  /// //sets the errorbox title
  /// textLengthValidation.errorBoxTitle = 'ERROR';
  ///
  /// //sets the promptBox title
  /// textLengthValidation.promptBoxTitle = 'TextLength';
  ///
  /// //sets the showErrorBox
  /// textLengthValidation.showErrorBox=true;
  ///
  /// //sets the promptbox text
  /// textLengthValidation.promptBoxText = 'Data validation for text length';
  ///
  /// //sets the promptBoxVisibility
  /// textLengthValidation.showPromptBox = true;
  ///
  /// //sets the errorStyle
  /// textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late String errorBoxTitle;

  /// Gets or sets the promptBoxText.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the first formula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the errorbox text
  /// textLengthValidation.errorBoxText =
  ///     'Text length should be between 1 and 5';
  ///
  /// //sets the errorbox title
  /// textLengthValidation.errorBoxTitle = 'ERROR';
  ///
  /// //sets the promptBox title
  /// textLengthValidation.promptBoxTitle = 'TextLength';
  ///
  /// //sets the showErrorBox
  /// textLengthValidation.showErrorBox=true;
  ///
  /// //sets the promptbox text
  /// textLengthValidation.promptBoxText = 'Data validation for text length';
  ///
  /// //sets the promptBoxVisibility
  /// textLengthValidation.showPromptBox = true;
  ///
  /// //sets the errorStyle
  /// textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late String promptBoxText;

  /// Gets or sets the showPromptBox.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the first formula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the errorbox text
  /// textLengthValidation.errorBoxText =
  ///     'Text length should be between 1 and 5';
  ///
  /// //sets the errorbox title
  /// textLengthValidation.errorBoxTitle = 'ERROR';
  ///
  /// //sets the promptBox title
  /// textLengthValidation.promptBoxTitle = 'TextLength';
  ///
  /// //sets the showPromptBox
  /// textLengthValidation.showPromptBox=true;
  ///
  /// //sets the showErrorBox
  /// textLengthValidation.showErrorBox=true;
  ///
  /// //sets the promptbox text
  /// textLengthValidation.promptBoxText = 'Data validation for text length';
  ///
  /// //sets the promptBoxVisibility
  /// textLengthValidation.showPromptBox = true;
  ///
  /// //sets the errorStyle
  /// textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late bool showPromptBox;

  /// Gets or sets the promptBoxTitle.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the first formula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the errorbox text
  /// textLengthValidation.errorBoxText =
  ///     'Text length should be between 1 and 5';
  ///
  /// //sets the errorbox title
  /// textLengthValidation.errorBoxTitle = 'ERROR';
  ///
  /// //sets the promptBox title
  /// textLengthValidation.promptBoxTitle = 'TextLength';
  ///
  /// //sets the showPromptBox
  /// textLengthValidation.showPromptBox=true;
  ///
  /// //sets the showErrorBox
  /// textLengthValidation.showErrorBox=true;
  ///
  /// //sets the promptbox text
  /// textLengthValidation.promptBoxText = 'Data validation for text length';
  ///
  /// //sets the promptBoxVisibility
  /// textLengthValidation.showPromptBox = true;
  ///
  /// //sets the errorStyle
  /// textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late String promptBoxTitle;

  /// Gets or sets the promptBoxVPosition.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in worksheet and applying the textLength with promptBox property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the firstFormula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second Formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the promptBox Text
  /// textLengthValidation.promptBoxText='textLength Validation';
  ///
  /// //sets the promptBoxVPosition
  /// textLengthValidation.promptBoxVPosition = 50;
  ///
  /// //sets the promptBoxHPosition
  /// textLengthValidation.promptBoxHPosition = 50;
  ///
  /// //sets the isPromptBoxPositionFixed
  /// textLengthValidation.isPromptBoxPositionFixed = true;
  ///
  /// //sets the isSuppressDropDownArrow
  /// textLengthValidation.isSuppressDropDownArrow = true;
  ///
  /// //sets the isEmptyCellAllowed
  /// textLengthValidation.isEmptyCellAllowed = false;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationpromptBox.xlsx');
  /// workbook.dispose();
  /// ```
  late int promptBoxVPosition;

  /// Gets or sets the promptBoxHPosition.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in worksheet and applying the textLength with promptBox property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the firstFormula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second Formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the promptBox text
  /// textLengthValidation.promptBoxText = 'textLengthValidation';
  ///
  /// //sets the promptBoxVPosition
  /// textLengthValidation.promptBoxVPosition = 50;
  ///
  /// //sets the promptBoxHPosition
  /// textLengthValidation.promptBoxHPosition = 50;
  ///
  /// //sets the isPromptBoxPositionFixed
  /// textLengthValidation.isPromptBoxPositionFixed = true;
  ///
  /// //sets the isSuppressDropDownArrow
  /// textLengthValidation.isSuppressDropDownArrow = true;
  ///
  /// //sets the isEmptyCellAllowed
  /// textLengthValidation.isEmptyCellAllowed = false;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationpromptBox.xlsx');
  /// workbook.dispose();
  /// ```
  late int promptBoxHPosition;

  /// Gets or sets the isPromptBoxPositionFixed.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in worksheet and applying the textLength with promptBox property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the firstFormula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second Formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// // sets the promptBox Text
  /// textLengthValidation.promptBoxText = 'TextLength Validation';
  ///
  /// //sets the promptBoxVPosition
  /// textLengthValidation.promptBoxVPosition = 50;
  ///
  /// //sets the promptBoxHPosition
  /// textLengthValidation.promptBoxHPosition = 50;
  ///
  /// //sets the isPromptBoxPositionFixed
  /// textLengthValidation.isPromptBoxPositionFixed = true;
  ///
  /// //sets the isSuppressDropDownArrow
  /// textLengthValidation.isSuppressDropDownArrow = true;
  ///
  /// //sets the isEmptyCellAllowed
  /// textLengthValidation.isEmptyCellAllowed = false;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationpromptBox.xlsx');
  /// workbook.dispose();
  /// ```
  late bool isPromptBoxPositionFixed;

  /// Gets or sets the isSuppressDropDownArrow.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the User properties
  /// final DataValidation listValidation =
  ///          sheet.getRangeByName('A1').dataValidation;
  ///
  /// // sets the allowtype with User type
  /// listValidation.allowType = ExcelDataValidationType.user;
  ///
  /// // sets the list of values
  /// listValidation.listOfValues = <String>['List1', 'List2', 'List3'];
  ///
  /// // sets the errorBoxText
  /// listValidation.errorBoxText = 'The value given in list should be given';
  ///
  /// //sets the errorBoxTitle
  /// listValidation.errorBoxTitle = 'ERROR';
  ///
  /// //sets the promptBoxText
  /// listValidation.promptBoxText = 'Data validation for list';
  ///
  /// //sets the showPromptBox
  /// listValidation.showPromptBox = true;
  ///
  /// //sets the isSuppressDropDownArrow
  /// listValidation.isSuppressDropDownArrow = true;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExcelUserValidation.xlsx');
  /// workbook.dispose();
  /// ```
  late bool isSuppressDropDownArrow;

  /// Gets or sets the isEmptyCellAllowed.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in worksheet and applying the textLength with promptBox property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the firstFormula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second Formula
  /// textLengthValidation.secondFormula = '5';
  ///
  ///
  /// //sets the promptBoxVPosition
  /// textLengthValidation.promptBoxVPosition = 50;
  ///
  /// //sets the promptBoxHPosition
  /// textLengthValidation.promptBoxHPosition = 50;
  ///
  /// //sets the isPromptBoxPositionFixed
  /// textLengthValidation.isPromptBoxPositionFixed = true;
  ///
  /// //sets the isSuppressDropDownArrow
  /// textLengthValidation.isSuppressDropDownArrow = true;
  ///
  /// //sets the isEmptyCellAllowed
  /// textLengthValidation.isEmptyCellAllowed = false;
  ///
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationpromptBox.xlsx');
  /// workbook.dispose();
  /// ```
  late bool isEmptyCellAllowed;

  /// Gets or sets the dataRange, which acts as a list type.
  /// ```dart
  /// final Workbook workbook = Workbook(1);
  /// //Accessing the first cell in excel-sheet and applying the dataRange property
  /// final DataValidation dataRangeValidation =
  ///           sheet.getRangeByName('A1').dataValidation;
  ///
  /// //Accessing the D1 cell and providing a text
  ///       sheet.getRangeByName('D1').text = 'ListItem1';
  ///
  /// //Accesing the D2 cell and providing a text
  ///       sheet.getRangeByName('D2').text = 'ListItem2';
  ///
  /// // Accessing a group of cell to be added to the list
  ///       dataRangeValidation.dataRange = sheet.getRangeByName('D1:D2');
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExcelDataRangeValidation.xlsx');
  /// workbook.dispose();
  /// ```
  late Range dataRange;

  /// Gets or sets the isListInFormula which is used both internally and externally.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in worksheet and applying the Formula with Between property
  /// final DataValidation listValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// listValidation.allowType = ExcelDataValidationType.user;
  ///
  ///
  /// //sets the listofValues
  /// listValidation.listOfValues = <String>['List1', 'List2', 'List3'];
  ///
  /// //True if dataValiadation's ListOfValues property has a value
  ///            if(dataValidation.IsListInFormula)
  ///            {
  ///               //Your code here
  ///            }
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExcelFormulaValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late bool isListInFormula;

  /// Gets or sets the errorStyle.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the first formula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the errorbox text
  /// textLengthValidation.errorBoxText =
  ///     'Text length should be between 1 and 5';
  ///
  /// //sets the errorbox title
  /// textLengthValidation.errorBoxTitle = 'ERROR';
  ///
  /// //sets the promptBox title
  /// textLengthValidation.promptBoxTitle = 'TextLength';
  ///
  /// //sets the promptbox text
  /// textLengthValidation.promptBoxText = 'Data validation for text length';
  ///
  /// //sets the promptBoxVisibility
  /// textLengthValidation.showPromptBox = true;
  ///
  /// //sets the errorStyle
  /// textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late ExcelDataValidationErrorStyle errorStyle;

  /// Gets or sets the comparisonOperator.
  /// ```dart
  /// //Creating one worksheet and accessing the first sheet
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Accessing the first cell in excel-sheet and applying the textLength with Between property
  /// final DataValidation textLengthValidation =
  ///     sheet.getRangeByName('A1').dataValidation;
  ///
  /// //sets the allowType
  /// textLengthValidation.allowType = ExcelDataValidationType.textLength;
  ///
  /// //sets the comparisonOperator
  /// textLengthValidation.comparisonOperator =
  ///     ExcelDataValidationComparisonOperator.between;
  ///
  /// //sets the first formula
  /// textLengthValidation.firstFormula = '1';
  ///
  /// //sets the second formula
  /// textLengthValidation.secondFormula = '5';
  ///
  /// //sets the errorbox text
  /// textLengthValidation.errorBoxText =
  ///     'Text length should be between 1 and 5';
  ///
  /// //sets the errorbox title
  /// textLengthValidation.errorBoxTitle = 'ERROR';
  ///
  /// //sets the promptBox title
  /// textLengthValidation.promptBoxTitle = 'TextLength';
  ///
  /// //sets the promptbox text
  /// textLengthValidation.promptBoxText = 'Data validation for text length';
  ///
  /// //sets the promptBoxVisibility
  /// textLengthValidation.showPromptBox = true;
  ///
  /// //sets the errorStyle
  /// textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;
  ///
  /// //Save and dispose Workbook
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExceltextLengthValidationbetween.xlsx');
  /// workbook.dispose();
  /// ```
  late ExcelDataValidationComparisonOperator comparisonOperator;
}
