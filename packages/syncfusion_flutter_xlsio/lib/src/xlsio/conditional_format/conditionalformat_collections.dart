part of xlsio;

/// Collection of conditional formats for the single-cell range.
class _ConditionalFormatsImpl implements ConditionalFormats {
  /// Create a instances of conditionsal collection.
  _ConditionalFormatsImpl(Worksheet sheet, Range range) {
    _sheet = sheet;
    conditionalFormat = <_ConditionalFormatImpl>[];
    _cellList = range._cfValue;
  }

  /// list of conditional format
  late List<_ConditionalFormatImpl> conditionalFormat;

  /// Conditional format InnerList
  List<_ConditionalFormatImpl> get innerList {
    return conditionalFormat;
  }

  /// Parent worksheet.
  late Worksheet _sheet;

  late String _cellList;

  // Maximum conditional formats number. Depends on current Excel version.
  static const int _maxCFNumber = 2147483647;

  /// Get worksheet. Read only.
  Worksheet get sheet {
    return _sheet;
  }

  @override

  /// Gets the number of conditional formats in the collection. Read-only.
  int get count {
    return innerList.length;
  }

  @override

  /// Gets the number of conditional formats in the collection. Read-only.
  set count(int value) {
    innerList.length = value;
  }

  @override

  /// Adds new condition to the collection.
  ConditionalFormat addCondition() {
    if (count >= _maxCFNumber) {
      throw Exception('Too many conditional formats.');
    }
    final _ConditionalFormatImpl result =
        _ConditionalFormatImpl(sheet, _cellList);
    _addConditionalFormat(result);
    return result;
  }

  /// Adds new condition to the collection.
  void _addConditionalFormat(ConditionalFormat? conditionalFormat) {
    if (conditionalFormat != null) {
      innerList.add(conditionalFormat as _ConditionalFormatImpl);
    }
  }
}

/// Represents a collection of conditional formats.
class ConditionalFormats {
  /// Gets the number of conditional formats in the collection. Read-only.
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
  ///  //Applying conditional formatting to "A1:A11".
  ///  final ConditionalFormats conditions =
  ///     sheet.getRangeByName('A1:A11').conditionalFormats;
  ///  final ConditionalFormat condition1 = conditions.addCondition();
  ///  final ConditionalFormat condition2 = conditions.addCondition();
  ///  final ConditionalFormat condition3 = conditions.addCondition();
  ///
  ///  //set conditions
  ///  condition1.formatType = ExcelCFType.cellValue;
  ///  condition1.operator = ExcelComparisonOperator.between;
  ///  condition1.firstFormula = '30';
  ///  condition1.secondFormula = '70';
  ///
  ///  //Set color.
  ///  condition1.backColor = '#66FF99';
  ///
  ///  //set conditions
  ///  condition2.formatType = ExcelCFType.cellValue;
  ///  condition2.operator = ExcelComparisonOperator.between;
  ///  condition2.firstFormula = '30';
  ///  condition2.secondFormula = '50';
  ///
  ///  //Set color.
  ///  condition2.backColor = '#99FF66';
  ///
  ///  //set conditions
  ///  condition3.formatType = ExcelCFType.cellValue;
  ///  condition3.operator = ExcelComparisonOperator.between;
  ///  condition3.firstFormula = '20';
  ///  condition3.secondFormula = '60';
  ///
  ///  //Set color.
  ///  condition3.backColor = '#FF9966';
  ///
  ///  //Check Count.
  ///  print(conditions.count);
  ///
  ///  //save and dispose.
  ///  final List<int> bytes = workbook.saveAsStream();
  ///  File('ConditionalFormatting.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  late int count;

  /// Adds new condition to the collection.
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
  ///  //Applying conditional formatting to "A1:A11".
  ///  final ConditionalFormats conditions =
  ///     sheet.getRangeByName('A1:A11').conditionalFormats;
  ///  final ConditionalFormat condition1 = conditions.addCondition();
  ///  final ConditionalFormat condition2 = conditions.addCondition();
  ///  final ConditionalFormat condition3 = conditions.addCondition();
  ///
  ///  //set conditions
  ///  condition1.formatType = ExcelCFType.cellValue;
  ///  condition1.operator = ExcelComparisonOperator.between;
  ///  condition1.firstFormula = '30';
  ///  condition1.secondFormula = '70';
  ///
  ///  //Set color.
  ///  condition1.backColor = '#66FF99';
  ///
  ///  //set conditions
  ///  condition2.formatType = ExcelCFType.cellValue;
  ///  condition2.operator = ExcelComparisonOperator.between;
  ///  condition2.firstFormula = '30';
  ///  condition2.secondFormula = '50';
  ///
  ///  //Set color.
  ///  condition2.backColor = '#99FF66';
  ///
  ///  //set conditions
  ///  condition3.formatType = ExcelCFType.cellValue;
  ///  condition3.operator = ExcelComparisonOperator.between;
  ///  condition3.firstFormula = '20';
  ///  condition3.secondFormula = '60';
  ///
  ///  //Set color.
  ///  condition3.backColor = '#FF9966';
  ///
  ///  //save and dispose.
  ///  final List<int> bytes = workbook.saveAsStream();
  ///  File('ConditionalFormatting.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  ConditionalFormat addCondition() {
    return ConditionalFormat();
  }

  // /// Removes all the conditional formats in the collection.
  // void remove() {}

  // /// Removes the conditional format at the specified index from the collection.
  // void removeAt(int index) {}
}
