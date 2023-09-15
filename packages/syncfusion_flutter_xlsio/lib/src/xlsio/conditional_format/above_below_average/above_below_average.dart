part of xlsio;

/// Represents the above or below conditional formatting rule.
/// Applying this rule to a range helps you highlight the cells which contain values above or below the average of selected range.
class AboveBelowAverage {
  /// Specifies whether the conditional formatting rule looks for cell values above or below the range average or standard deviation.
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
  /// aboveBelowAverage.averageType = ExcelCFAverageType.above;
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
  late ExcelCFAverageType averageType;

  /// Specifies standard deviation number for AboveBelowAverage conditional formatting rule.
  /// Valid only if AverageType is set to AboveStdDev or BelowStdDev.
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
  late int stdDevValue;
}
