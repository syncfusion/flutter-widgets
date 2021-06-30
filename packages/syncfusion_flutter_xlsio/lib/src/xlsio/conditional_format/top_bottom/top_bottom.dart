part of xlsio;

/// Represents the top or bottom conditional formatting rule.
/// Applying this rule to a range helps you highlight the top or bottom “n” cells from the selected range.
class TopBottom {
  /// Specifies whether the ranking is evaluated from the top or bottom.
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
  /// //Setting format properties to be applied when the above condition is met.
  /// condition.backColor = '#934ADD';
  /// condition.isBold = true;
  ///
  /// //save and dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CFTopBottom.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late ExcelCFTopBottomType type;

  /// Specifies whether the rank is determined by a percentage value.
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
  /// //Set true to Percent property for TopBottom rule.
  /// topBottom.percent = true;
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
  late bool percent;

  /// Specifies the maximum number or percentage of cells to be highlighted for this conditional formatting rule.
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
  /// //Set rank value for the TopBottom rule.
  /// topBottom.rank = 10;
  ///
  /// //save and dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CFTopBottom.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int rank;
}
