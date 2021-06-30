part of xlsio;

/// Represents a conditional format.
class ConditionalFormat {
  /// Gets or sets the type of the conditional format.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Set color.
  ///   condition1.backColor = '#66FF99';
  ///
  ///   //Set number format.
  ///   condition1.numberFormat = '0.0';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late ExcelCFType formatType;

  ///  Gets or sets one of the constants of <see cref="CFTimePeriods"/> enumeration
  ///  which represents the type of the time period.
  /// ```dart
  ///  // Create a new Excel Document.
  ///  final Workbook workbook = Workbook();
  ///  // Accessing sheet via index.
  ///  final Worksheet sheet = workbook.worksheets[0];
  ///
  ///  sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///  final now = DateTime.now();
  ///  sheet
  ///     .getRangeByIndex(2, 1)
  ///     .setDateTime(DateTime(now.year, now.month, now.day - 1));
  ///  sheet
  ///     .getRangeByIndex(3, 1)
  ///     .setDateTime(DateTime(now.year, now.month, now.day));
  ///  sheet
  ///     .getRangeByIndex(4, 1)
  ///     .setDateTime(DateTime(now.year, now.month, now.day + 1));
  ///  sheet
  ///     .getRangeByIndex(5, 1)
  ///     .setDateTime(DateTime(now.year, now.month, now.day - 1));
  ///  sheet
  ///     .getRangeByIndex(6, 1)
  ///     .setDateTime(DateTime(now.year, now.month, now.day + 1));
  ///  sheet
  ///     .getRangeByIndex(7, 1)
  ///     .setDateTime(DateTime(now.year, now.month, now.day - 1));
  ///  sheet
  ///     .getRangeByIndex(8, 1)
  ///     .setDateTime(DateTime(now.year, now.month, now.day - 1));
  ///  sheet
  ///     .getRangeByIndex(9, 1)
  ///     .setDateTime(DateTime(now.year, now.month, now.day));
  ///  sheet
  ///     .getRangeByIndex(10, 1)
  ///     .setDateTime(DateTime(now.year, now.month, now.day + 1));
  ///
  ///  // Applying conditional formatting to "A1:A11".
  ///  final ConditionalFormats conditions =
  ///     sheet.getRangeByName('A1:A10').conditionalFormats;
  ///  final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///  //Set formatType.
  ///  condition1.formatType = ExcelCFType.timePeriod;
  ///
  ///  //Set CF Time period.
  ///  condition1.timePeriodType = CFTimePeriods.tomorrow;
  ///
  ///  //Set Color
  ///  condition1.backColor = '#FF00FF';
  ///
  ///  //save and dispose.
  ///  final List<int> bytes = workbook.saveAsStream();
  ///  File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  late CFTimePeriods timePeriodType;

  /// Gets or sets the comparison operator for the conditional format.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Set color.
  ///   condition1.backColor = '#66FF99';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late ExcelComparisonOperator operator;

  /// Gets or sets a boolean value indicating whether the font is bold.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Set font bold.
  ///   condition1.isBold = true;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late bool isBold;

  /// Gets or sets a boolean value indicating whether the font is italic.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Set font bold.
  ///   condition1.isItalic = true;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late bool isItalic;

  /// Gets or sets the font color from predefined colors.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Set font bold.
  ///   condition1.fontColor = '#D60093';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late String fontColor;

  /// Gets or sets the underline type for the conditional format.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Set font bold.
  ///   condition1.underline = true;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late bool underline;

  /// Gets or sets the left border color from predefined colors.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Ser border.
  ///   condition1.leftBorderStyle = LineStyle.thick;
  ///
  ///   //Set border color.
  ///   condition1.leftBorderColor = '#66FF99';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late String leftBorderColor;

  /// Gets or sets the left border line style.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Ser border.
  ///   condition1.leftBorderStyle = LineStyle.thick;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late LineStyle leftBorderStyle;

  /// Gets or sets the right border color from predefined colors.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Ser border.
  ///   condition1.rightBorderStyle = LineStyle.thick;
  ///
  ///   //Set border color.
  ///   condition1.rightBorderColor = '#66FF99';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late String rightBorderColor;

  /// Gets or sets the right border line style.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Ser border.
  ///   condition1.rightBorderStyle = LineStyle.thick;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late LineStyle rightBorderStyle;

  /// Gets or sets the top border color from predefined colors.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Ser border.
  ///   condition1.topBorderStyle = LineStyle.thick;
  ///
  ///   //Set border color.
  ///   condition1.topBorderColor = '#66FF99';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late String topBorderColor;

  /// Gets or sets the top border line style.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Ser border.
  ///   condition1.topBorderStyle = LineStyle.thick;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late LineStyle topBorderStyle;

  /// Gets or sets the bottom border color from predefined colors.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Ser border.
  ///   condition1.bottomBorderStyle = LineStyle.thick;
  ///
  ///   //Set border color.
  ///   condition1.bottomBorderColor = '#66FF99';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late String bottomBorderColor;

  /// Gets or sets the bottom border line style.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Ser border.
  ///   condition1.bottomBorderStyle = LineStyle.thick;
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late LineStyle bottomBorderStyle;

  /// Gets or sets the value or expression associated with the conditional format.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Set color.
  ///   condition1.backColor = '#66FF99';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late String firstFormula;

  /// Gets the value or expression associated with the second part of a conditional format.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.between;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Set firstFormula.
  ///   condition1.secondFormula = '70';
  ///
  ///   //Set color.
  ///   condition1.backColor = '#66FF99';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late String secondFormula;

  /// Gets or sets the background color from predefined colors.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Set color.
  ///   condition1.backColor = '#66FF99';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late String backColor;

  /// Gets or sets number format of the conditional format rule.
  /// ```dart
  ///   // Create a new Excel Document.
  ///   final Workbook workbook = Workbook();
  ///   // Accessing sheet via index.
  ///   final Worksheet sheet = workbook.worksheets[0];
  ///
  ///   sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///   sheet.getRangeByIndex(2, 1).setNumber(10);
  ///   sheet.getRangeByIndex(3, 1).setNumber(20);
  ///   sheet.getRangeByIndex(4, 1).setNumber(30);
  ///   sheet.getRangeByIndex(5, 1).setNumber(40);
  ///   sheet.getRangeByIndex(6, 1).setNumber(50);
  ///   sheet.getRangeByIndex(7, 1).setNumber(60);
  ///   sheet.getRangeByIndex(8, 1).setNumber(70);
  ///   sheet.getRangeByIndex(9, 1).setNumber(80);
  ///   sheet.getRangeByIndex(10, 1).setNumber(90);
  ///   sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///   // Applying conditional formatting to "A1:A11".
  ///   final ConditionalFormats conditions =
  ///       sheet.getRangeByName('A1:A11').conditionalFormats;
  ///   final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///   //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  ///   //Set operators.
  ///   condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///   //Set firstFormula.
  ///   condition1.firstFormula = '30';
  ///
  ///   //Set number format.
  ///   condition1.numberFormat = '0.0';
  ///
  ///   //save and dispose.
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  String? numberFormat;

  /// Gets or sets a boolean value that determines if additional formatting rules on the cell should be evaluated
  /// if the current rule evaluates to True.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  /// sheet.getRangeByIndex(2, 1).setNumber(10);
  /// sheet.getRangeByIndex(3, 1).setNumber(20);
  /// sheet.getRangeByIndex(4, 1).setNumber(30);
  /// sheet.getRangeByIndex(5, 1).setNumber(40);
  /// sheet.getRangeByIndex(6, 1).setNumber(50);
  /// sheet.getRangeByIndex(7, 1).setNumber(60);
  /// sheet.getRangeByIndex(8, 1).setNumber(70);
  /// sheet.getRangeByIndex(9, 1).setNumber(80);
  /// sheet.getRangeByIndex(10, 1).setNumber(90);
  /// sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  /// //Applying conditional formatting to "A1:A11".
  /// final ConditionalFormats conditions =
  ///     sheet.getRangeByName('A1:A11').conditionalFormats;
  /// final ConditionalFormat condition1 = conditions.addCondition();
  /// final ConditionalFormat condition2 = conditions.addCondition();
  /// final ConditionalFormat condition3 = conditions.addCondition();
  ///
  /// //set conditions
  /// condition1.formatType = ExcelCFType.cellValue;
  /// condition1.operator = ExcelComparisonOperator.between;
  /// condition1.firstFormula = '10';
  /// condition1.secondFormula = '40';
  ///
  /// //Set color.
  /// condition1.backColor = '#66FF99';
  ///
  /// //set conditions
  /// condition2.formatType = ExcelCFType.cellValue;
  /// condition2.operator = ExcelComparisonOperator.between;
  /// condition2.firstFormula = '30';
  /// condition2.secondFormula = '60';
  /// condition2.stopIfTrue = true;
  ///
  /// //Set color.
  /// condition2.backColor = '#99FF66';
  ///
  /// //set conditions
  /// condition3.formatType = ExcelCFType.cellValue;
  /// condition3.operator = ExcelComparisonOperator.between;
  /// condition3.firstFormula = '50';
  /// condition3.secondFormula = '100';
  ///
  /// //Set color.
  /// condition3.backColor = '#FF9966';
  ///
  /// //save and dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('ConditionalFormatting.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool stopIfTrue;

  /// Gets or sets the text value used for specific text conditional formatting rule.
  /// The default value is null.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// sheet.getRangeByIndex(1, 1).setText('John');
  /// sheet.getRangeByIndex(2, 1).setText('James');
  /// sheet.getRangeByIndex(3, 1).setText('Anne');
  /// sheet.getRangeByIndex(4, 1).setText('Jai');
  /// sheet.getRangeByIndex(5, 1).setText('Harish');
  /// sheet.getRangeByIndex(6, 1).setText('Dinesh');
  /// sheet.getRangeByIndex(7, 1).setText('Avnish');
  /// sheet.getRangeByIndex(8, 1).setText('Yamini');
  /// sheet.getRangeByIndex(9, 1).setText('Kani');
  /// sheet.getRangeByIndex(10, 1).setText('Anu');
  ///
  /// //Applying conditional formatting to "A1:A11".
  /// final ConditionalFormats conditions =
  ///     sheet.getRangeByName('A1:A11').conditionalFormats;
  /// final ConditionalFormat condition1 = conditions.addCondition();
  ///
  /// //set conditions
  /// condition1.formatType = ExcelCFType.specificText;
  /// condition1.operator = ExcelComparisonOperator.containsText;
  /// condition1.text = 'j';
  ///
  /// //Set color.
  /// condition1.backColor = '#66FF99';
  ///
  /// //save and dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('ConditionalFormatting.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  String? text;

  /// Gets TopBottom conditional formatting rule. Read-only.
  /// ```dart
  /// // create a Excel document.
  /// final Workbook workbook = Workbook();
  ///
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// // Setting value in the cell.
  /// sheet.getRangeByIndex(1, 1).setText('Mark');
  /// sheet.getRangeByIndex(2, 1).setNumber(29);
  /// sheet.getRangeByIndex(3, 1).setNumber(13);
  /// sheet.getRangeByIndex(4, 1).setNumber(88);
  /// sheet.getRangeByIndex(5, 1).setNumber(98);
  /// sheet.getRangeByIndex(6, 1).setNumber(60);
  /// sheet.getRangeByIndex(7, 1).setNumber(69);
  /// sheet.getRangeByIndex(8, 1).setNumber(49);
  /// sheet.getRangeByIndex(9, 1).setNumber(100);
  /// sheet.getRangeByIndex(10, 1).setNumber(19);
  ///
  /// // Applying conditional formatting.
  /// final ConditionalFormats conditions =
  ///     sheet.getRangeByName('A1:A10').conditionalFormats;
  /// final ConditionalFormat condition = conditions.addCondition();
  ///
  /// //Applying top or bottom rule in the conditional formatting.
  /// condition.formatType = ExcelCFType.topBottom;
  /// final TopBottom topBottom = condition.topBottom!;
  ///
  /// //Set type as Top for TopBottom rule.
  /// topBottom.type = ExcelCFTopBottomType.top;
  ///
  /// //Set true to Percent property for TopBottom rule.
  /// topBottom.percent = true;
  ///
  /// //Set rank value for the TopBottom rule.
  /// topBottom.rank = 50;
  ///
  /// //Setting format properties to be applied when the above condition is met.
  /// condition.backColor = '#934ADD';
  /// condition.isBold = true;
  ///
  /// //save and dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CFTopBottom.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  TopBottom? topBottom;

  /// Gets AboveBelowAverage conditional formatting rule. Read-only.
  /// ```dart
  /// // create a Excel document.
  /// final Workbook workbook = Workbook();
  ///
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// // Setting value in the cell.
  /// sheet.getRangeByIndex(1, 1).setText('Mark');
  /// sheet.getRangeByIndex(2, 1).setNumber(29);
  /// sheet.getRangeByIndex(3, 1).setNumber(13);
  /// sheet.getRangeByIndex(4, 1).setNumber(88);
  /// sheet.getRangeByIndex(5, 1).setNumber(98);
  /// sheet.getRangeByIndex(6, 1).setNumber(60);
  /// sheet.getRangeByIndex(7, 1).setNumber(69);
  /// sheet.getRangeByIndex(8, 1).setNumber(49);
  /// sheet.getRangeByIndex(9, 1).setNumber(100);
  /// sheet.getRangeByIndex(10, 1).setNumber(19);
  ///
  /// // Applying conditional formatting.
  /// final ConditionalFormats conditions =
  ///     sheet.getRangeByName('A1:A10').conditionalFormats;
  /// final ConditionalFormat condition = conditions.addCondition();
  ///
  /// //Applying above or below average rule in the conditional formatting.
  /// condition.formatType = ExcelCFType.aboveBelowAverage;
  /// final AboveBelowAverage aboveBelowAverage = condition.aboveBelowAverage!;
  ///
  /// //Set AverageType as AboveStdDev for AboveBelowAverage rule.
  /// aboveBelowAverage.averageType = ExcelCFAverageType.aboveStdDev;
  ///
  /// //Set value to StdDevValue property for AboveBelowAverage rule.
  /// aboveBelowAverage.stdDevValue = 1;
  ///
  /// //Set color for Conditional Formattting.
  /// condition.backColor = '#FF0D0D';
  /// condition.fontColor = '#FFFFFF';
  /// condition.isItalic = true;
  /// condition.isBold = true;
  ///
  /// //save and dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CFAboveBelowAverage.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  AboveBelowAverage? aboveBelowAverage;

  /// Gets color scale conditional formatting rule. Read-only.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  ///
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').number = 12;
  /// sheet.getRangeByName('A2').number = 29;
  /// sheet.getRangeByName('A3').number = 41;
  /// sheet.getRangeByName('A4').number = 84;
  /// sheet.getRangeByName('A5').number = 90;
  /// sheet.getRangeByName('A6').number = 112;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 20;
  ///
  /// //Create color scale for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat =
  ///     conditionalFormats.addCondition();
  ///
  /// // set colorscale CF.
  /// conditionalFormat.formatType = ExcelCFType.colorScale;
  /// final ColorScale colorScale = conditionalFormat.colorScale;
  ///
  /// //Sets 3 - color scale and its constraints
  /// colorScale.setConditionCount(3);
  /// colorScale.criteria[0].formatColor = '#63BE7B';
  /// colorScale.criteria[0].type = ConditionValueType.lowestValue;
  ///
  /// colorScale.criteria[1].formatColor = '#FFFFFF';
  /// colorScale.criteria[1].type = ConditionValueType.number;
  /// colorScale.criteria[1].value = "70";
  ///
  /// colorScale.criteria[2].formatColor = '#F8696B';
  /// colorScale.criteria[2].type = ConditionValueType.highestValue;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('ColorScale.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ColorScale? colorScale;

  /// Gets icon set conditional formatting rule.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// sheet.getRangeByName('A1').number = 125;
  /// sheet.getRangeByName('A2').number = 279;
  /// sheet.getRangeByName('A3').number = 42;
  /// sheet.getRangeByName('A4').number = 384;
  /// sheet.getRangeByName('A5').number = 129;
  /// sheet.getRangeByName('A6').number = 212;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 230;
  ///
  /// //Create icon set for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat =
  ///     conditionalFormats.addCondition();
  ///
  /// conditionalFormat.formatType = ExcelCFType.iconSet;
  /// final IconSet iconSet = conditionalFormat.iconSet;
  ///
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  /// iconSet.iconCriteria[1].type = ConditionValueType.percent;
  /// iconSet.iconCriteria[1].value = "30";
  /// iconSet.iconCriteria[2].type = ConditionValueType.percent;
  /// iconSet.iconCriteria[2].value = "60";
  /// iconSet.showIconOnly = true;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  ///   File('Iconset.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  IconSet? iconSet;

  /// Gets data bar conditional formatting rule.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').number = 12;
  /// sheet.getRangeByName('A2').number = 29;
  /// sheet.getRangeByName('A3').number = 41;
  /// sheet.getRangeByName('A4').number = -84;
  /// sheet.getRangeByName('A5').number = 90;
  /// sheet.getRangeByName('A6').number = 112;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 20;
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar;
  ///
  /// //Set type and value.
  /// dataBar.minPoint.type = ConditionValueType.percent;
  /// dataBar.minPoint.value = '20';
  /// dataBar.maxPoint.type = ConditionValueType.percent;
  /// dataBar.maxPoint.value = '90';
  ///
  /// //Set color for DataBar
  /// dataBar.barColor = '#FF7C80';
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  DataBar? dataBar;

  /// Gets or sets the value or expression associated with the conditional format
  /// in R1C1 notation.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByIndex(1, 1).setNumber(123);
  /// sheet.getRangeByIndex(2, 1).setNumber(23);
  /// sheet.getRangeByIndex(3, 1).setNumber(25);
  /// sheet.getRangeByIndex(4, 1).setNumber(5);
  /// sheet.getRangeByIndex(5, 1).setNumber(44);
  /// sheet.getRangeByIndex(6, 1).setNumber(2);
  /// sheet.getRangeByIndex(7, 1).setNumber(67);
  /// sheet.getRangeByIndex(8, 1).setNumber(92);
  /// sheet.getRangeByIndex(9, 1).setNumber(68);
  /// sheet.getRangeByIndex(10, 1).setNumber(84);
  ///
  /// //Applying conditional formatting to "A1:D4".
  /// final ConditionalFormats conditions =
  ///     sheet.getRangeByName('A1:D4').conditionalFormats;
  /// final ConditionalFormat condition1 = conditions.addCondition();
  /// //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  /// //Set operators.
  /// condition1.operator = ExcelComparisonOperator.greater;
  ///
  /// //Set R1C1 style first formula.
  /// condition1.firstFormulaR1C1 = '=R[1]C[0]';
  ///
  /// //save and dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('FormulaR1C1.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String firstFormulaR1C1;

  /// Gets or sets the value or expression associated with the conditional format
  /// in R1C1 notation.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByIndex(1, 1).setNumber(123);
  /// sheet.getRangeByIndex(2, 1).setNumber(23);
  /// sheet.getRangeByIndex(3, 1).setNumber(25);
  /// sheet.getRangeByIndex(4, 1).setNumber(5);
  /// sheet.getRangeByIndex(5, 1).setNumber(44);
  /// sheet.getRangeByIndex(6, 1).setNumber(2);
  /// sheet.getRangeByIndex(7, 1).setNumber(67);
  /// sheet.getRangeByIndex(8, 1).setNumber(92);
  /// sheet.getRangeByIndex(9, 1).setNumber(68);
  /// sheet.getRangeByIndex(10, 1).setNumber(84);
  ///
  /// //Applying conditional formatting to "A1:D4".
  /// final ConditionalFormats conditions =
  ///     sheet.getRangeByName('A1:D4').conditionalFormats;
  /// final ConditionalFormat condition1 = conditions.addCondition();
  /// //Set formatType.
  ///   condition1.formatType = ExcelCFType.cellValue;
  ///
  /// //Set operators.
  /// condition1.operator = ExcelComparisonOperator.between;
  ///
  /// //Set R1C1 style first formula.
  /// condition1.firstFormulaR1C1 = '=R[1]C[0]';
  /// //Set R1C1 style second formula.
  /// condition1.secondFormulaR1C1 ='=R[8]C[0]';
  ///
  /// //save and dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('FormulaR1C1.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String secondFormulaR1C1;

  /// Gets or sets the background color from Rgb.
  /// ```dart
  ///  // Create a new Excel Document.
  ///  final Workbook workbook = Workbook();
  ///  // Accessing sheet via index.
  ///  final Worksheet sheet = workbook.worksheets[0];
  ///
  ///  sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///  sheet.getRangeByIndex(2, 1).setNumber(10);
  ///  sheet.getRangeByIndex(3, 1).setNumber(20);
  ///  sheet.getRangeByIndex(4, 1).setNumber(30);
  ///  sheet.getRangeByIndex(5, 1).setNumber(40);
  ///  sheet.getRangeByIndex(6, 1).setNumber(50);
  ///  sheet.getRangeByIndex(7, 1).setNumber(60);
  ///  sheet.getRangeByIndex(8, 1).setNumber(70);
  ///  sheet.getRangeByIndex(9, 1).setNumber(80);
  ///  sheet.getRangeByIndex(10, 1).setNumber(90);
  ///  sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///  // Applying conditional formatting to "A1:A11".
  ///  final ConditionalFormats conditions =
  ///      sheet.getRangeByName('A2:A11').conditionalFormats;
  ///  final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///  //Set formatType.
  ///  condition1.formatType = ExcelCFType.cellValue;
  ///
  ///  //Set operators.
  ///  condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///  //Set firstFormula.
  ///  condition1.firstFormula = '30';
  ///
  ///  //Set back color Rgb.
  ///  condition1.backColorRgb = Color.fromARGB(234, 156, 135, 5);
  ///
  ///  //save and dispose.
  ///  final List<int> bytes = workbook.saveAsStream();
  ///  File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  late Color backColorRgb;

  /// Gets or sets the background color from Rgb.
  /// ```dart
  ///  // Create a new Excel Document.
  ///  final Workbook workbook = Workbook();
  ///  // Accessing sheet via index.
  ///  final Worksheet sheet = workbook.worksheets[0];
  ///
  ///  sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///  sheet.getRangeByIndex(2, 1).setNumber(10);
  ///  sheet.getRangeByIndex(3, 1).setNumber(20);
  ///  sheet.getRangeByIndex(4, 1).setNumber(30);
  ///  sheet.getRangeByIndex(5, 1).setNumber(40);
  ///  sheet.getRangeByIndex(6, 1).setNumber(50);
  ///  sheet.getRangeByIndex(7, 1).setNumber(60);
  ///  sheet.getRangeByIndex(8, 1).setNumber(70);
  ///  sheet.getRangeByIndex(9, 1).setNumber(80);
  ///  sheet.getRangeByIndex(10, 1).setNumber(90);
  ///  sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///  // Applying conditional formatting to "A1:A11".
  ///  final ConditionalFormats conditions =
  ///      sheet.getRangeByName('A2:A11').conditionalFormats;
  ///  final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///  //Set formatType.
  ///  condition1.formatType = ExcelCFType.cellValue;
  ///
  ///  //Set operators.
  ///  condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///  //Set firstFormula.
  ///  condition1.firstFormula = '30';
  ///
  ///  //Set back color Rgb.
  ///  condition1.fontColorRgb = Color.fromARGB(234, 15, 135, 145);;
  ///
  ///  //save and dispose.
  ///  final List<int> bytes = workbook.saveAsStream();
  ///  File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  late Color fontColorRgb;

  /// Gets or sets the left border color from Rgb  .
  /// ```dart
  ///  // Create a new Excel Document.
  ///  final Workbook workbook = Workbook();
  ///  // Accessing sheet via index.
  ///  final Worksheet sheet = workbook.worksheets[0];
  ///
  ///  sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///  sheet.getRangeByIndex(2, 1).setNumber(10);
  ///  sheet.getRangeByIndex(3, 1).setNumber(20);
  ///  sheet.getRangeByIndex(4, 1).setNumber(30);
  ///  sheet.getRangeByIndex(5, 1).setNumber(40);
  ///  sheet.getRangeByIndex(6, 1).setNumber(50);
  ///  sheet.getRangeByIndex(7, 1).setNumber(60);
  ///  sheet.getRangeByIndex(8, 1).setNumber(70);
  ///  sheet.getRangeByIndex(9, 1).setNumber(80);
  ///  sheet.getRangeByIndex(10, 1).setNumber(90);
  ///  sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///  // Applying conditional formatting to "A1:A11".
  ///  final ConditionalFormats conditions =
  ///      sheet.getRangeByName('A2:A11').conditionalFormats;
  ///  final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///  //Set formatType.
  ///  condition1.formatType = ExcelCFType.cellValue;
  ///
  ///  //Set operators.
  ///  condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///  //Set firstFormula.
  ///  condition1.firstFormula = '30';
  ///
  ///  //Set left border style and color Rgb.
  ///  condition1.leftBorderStyle = LineStyle.double;
  ///  condition1.leftBorderColorRgb = Color.fromARGB(190, 144, 0, 200);
  ///
  ///  //save and dispose.
  ///  final List<int> bytes = workbook.saveAsStream();
  ///  File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  late Color leftBorderColorRgb;

  /// Gets or sets the right border color from Rgb  .
  /// ```dart
  ///  // Create a new Excel Document.
  ///  final Workbook workbook = Workbook();
  ///  // Accessing sheet via index.
  ///  final Worksheet sheet = workbook.worksheets[0];
  ///
  ///  sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///  sheet.getRangeByIndex(2, 1).setNumber(10);
  ///  sheet.getRangeByIndex(3, 1).setNumber(20);
  ///  sheet.getRangeByIndex(4, 1).setNumber(30);
  ///  sheet.getRangeByIndex(5, 1).setNumber(40);
  ///  sheet.getRangeByIndex(6, 1).setNumber(50);
  ///  sheet.getRangeByIndex(7, 1).setNumber(60);
  ///  sheet.getRangeByIndex(8, 1).setNumber(70);
  ///  sheet.getRangeByIndex(9, 1).setNumber(80);
  ///  sheet.getRangeByIndex(10, 1).setNumber(90);
  ///  sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///  // Applying conditional formatting to "A1:A11".
  ///  final ConditionalFormats conditions =
  ///      sheet.getRangeByName('A2:A11').conditionalFormats;
  ///  final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///  //Set formatType.
  ///  condition1.formatType = ExcelCFType.cellValue;
  ///
  ///  //Set operators.
  ///  condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///  //Set firstFormula.
  ///  condition1.firstFormula = '30';
  ///
  ///  //Set right border style and color Rgb.
  ///  condition1.rightBorderStyle = LineStyle.double;
  ///  condition1.rightBorderColorRgb = Color.fromARGB(255, 200, 200, 0);
  ///
  ///  //save and dispose.
  ///  final List<int> bytes = workbook.saveAsStream();
  ///  File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  late Color rightBorderColorRgb;

  /// Gets or sets the top border color from Rgb  .
  /// ```dart
  ///  // Create a new Excel Document.
  ///  final Workbook workbook = Workbook();
  ///  // Accessing sheet via index.
  ///  final Worksheet sheet = workbook.worksheets[0];
  ///
  ///  sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///  sheet.getRangeByIndex(2, 1).setNumber(10);
  ///  sheet.getRangeByIndex(3, 1).setNumber(20);
  ///  sheet.getRangeByIndex(4, 1).setNumber(30);
  ///  sheet.getRangeByIndex(5, 1).setNumber(40);
  ///  sheet.getRangeByIndex(6, 1).setNumber(50);
  ///  sheet.getRangeByIndex(7, 1).setNumber(60);
  ///  sheet.getRangeByIndex(8, 1).setNumber(70);
  ///  sheet.getRangeByIndex(9, 1).setNumber(80);
  ///  sheet.getRangeByIndex(10, 1).setNumber(90);
  ///  sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///  // Applying conditional formatting to "A1:A11".
  ///  final ConditionalFormats conditions =
  ///      sheet.getRangeByName('A2:A11').conditionalFormats;
  ///  final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///  //Set formatType.
  ///  condition1.formatType = ExcelCFType.cellValue;
  ///
  ///  //Set operators.
  ///  condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///  //Set firstFormula.
  ///  condition1.firstFormula = '30';
  ///
  ///  //Set top border style and color Rgb.
  ///  condition1.topBorderStyle = LineStyle.double;
  ///  condition1.topBorderColorRgb = Color.fromARGB(200, 141, 13, 0);
  ///
  ///  //save and dispose.
  ///  final List<int> bytes = workbook.saveAsStream();
  ///  File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  late Color topBorderColorRgb;

  /// Gets or sets the bottom border color from Rgb  .
  /// ```dart
  ///  // Create a new Excel Document.
  ///  final Workbook workbook = Workbook();
  ///  // Accessing sheet via index.
  ///  final Worksheet sheet = workbook.worksheets[0];
  ///
  ///  sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
  ///  sheet.getRangeByIndex(2, 1).setNumber(10);
  ///  sheet.getRangeByIndex(3, 1).setNumber(20);
  ///  sheet.getRangeByIndex(4, 1).setNumber(30);
  ///  sheet.getRangeByIndex(5, 1).setNumber(40);
  ///  sheet.getRangeByIndex(6, 1).setNumber(50);
  ///  sheet.getRangeByIndex(7, 1).setNumber(60);
  ///  sheet.getRangeByIndex(8, 1).setNumber(70);
  ///  sheet.getRangeByIndex(9, 1).setNumber(80);
  ///  sheet.getRangeByIndex(10, 1).setNumber(90);
  ///  sheet.getRangeByIndex(11, 1).setNumber(100);
  ///
  ///  // Applying conditional formatting to "A1:A11".
  ///  final ConditionalFormats conditions =
  ///      sheet.getRangeByName('A2:A11').conditionalFormats;
  ///  final ConditionalFormat condition1 = conditions.addCondition();
  ///
  ///  //Set formatType.
  ///  condition1.formatType = ExcelCFType.cellValue;
  ///
  ///  //Set operators.
  ///  condition1.operator = ExcelComparisonOperator.greater;
  ///
  ///  //Set firstFormula.
  ///  condition1.firstFormula = '30';
  ///
  ///  //Set bottom border style and color Rgb.
  ///  condition1.bottomBorderStyle = LineStyle.double;
  ///  condition1.bottomderColorRgb = Color.fromARGB(255, 0, 200, 100);
  ///
  ///  //save and dispose.
  ///  final List<int> bytes = workbook.saveAsStream();
  ///  File('ConditionalFormats.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  late Color bottomBorderColorRgb;
}
