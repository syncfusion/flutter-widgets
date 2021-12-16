part of xlsio;

/// Represents a color scale conditional formatting rule.
abstract class ColorScale {
  /// Gets a collection of individual ConditionValue objects.
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
  /// final ColorScale colorScale = conditionalFormat.colorScale!;
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
  late List<ColorConditionValue> criteria;

  /// Sets the number of ColorConditionValue objects in the collection. Supported values are 2 and 3.
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
  /// final ColorScale colorScale = conditionalFormat.colorScale!;
  ///
  /// //Sets 3 - color scale and its constraints
  /// colorScale.setConditionCount(3);
  ///
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
  /// workbook.dispose();;
  /// ```
  void setConditionCount(int count);
}
