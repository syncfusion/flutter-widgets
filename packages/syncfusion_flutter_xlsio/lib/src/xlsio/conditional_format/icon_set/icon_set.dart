part of xlsio;

/// Represents a set of icons that are used in an icon set conditional formatting rule.
abstract class IconSet {
  /// Gets ConditionValue collection which represents the set of criteria for icon set conditional formatting rule.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  ///
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').number = 125;
  /// sheet.getRangeByName('A2').number = 279;
  /// sheet.getRangeByName('A3').number = 42;
  /// sheet.getRangeByName('A4').number = 384;
  /// sheet.getRangeByName('A5').number = 129;
  /// sheet.getRangeByName('A6').number = 212;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 230;
  ///
  /// //Create iconset for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat =
  ///     conditionalFormats.addCondition();
  ///
  /// //Set FormatType as IconSet.
  /// conditionalFormat.formatType = ExcelCFType.iconSet;
  /// final IconSet iconSet = conditionalFormat.iconSet!;
  ///
  /// //Set conditions for IconCriteria.
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  /// iconSet.iconCriteria[1].type = ConditionValueType.percent;
  /// iconSet.iconCriteria[1].value = "30";
  /// iconSet.iconCriteria[2].type = ConditionValueType.percent;
  /// iconSet.iconCriteria[2].value = "60";
  /// iconSet.showIconOnly = true;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'IconSetThreeSymbols.xlsx');
  /// workbook.dispose();
  /// ```
  late List<ConditionValue> iconCriteria;

  /// Gets or sets the type of the icon set conditional formatting.
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
  /// //Create iconset for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat =
  ///     conditionalFormats.addCondition();
  ///
  /// //Set FormatType as IconSet.
  /// conditionalFormat.formatType = ExcelCFType.iconSet;
  /// final IconSet iconSet = conditionalFormat.iconSet!;
  ///
  /// //Set conditions for IconCriteria.
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  ///
  /// iconSet.iconCriteria[1].type = ConditionValueType.percent;
  /// iconSet.iconCriteria[1].value = "30";
  /// iconSet.iconCriteria[2].type = ConditionValueType.percent;
  /// iconSet.iconCriteria[2].value = "60";
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  ///   File('Iconset.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late ExcelIconSetType iconSet;

  /// Gets or sets a Boolean value indicating if the thresholds for an icon set conditional format are determined using percentiles. Default value is false.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  ///
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').number = 125;
  /// sheet.getRangeByName('A2').number = 279;
  /// sheet.getRangeByName('A3').number = 42;
  /// sheet.getRangeByName('A4').number = 384;
  /// sheet.getRangeByName('A5').number = 129;
  /// sheet.getRangeByName('A6').number = 212;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 230;
  ///
  /// //Create iconset for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat =
  ///     conditionalFormats.addCondition();
  ///
  /// //Set FormatType as IconSet.
  /// conditionalFormat.formatType = ExcelCFType.iconSet;
  /// final IconSet iconSet = conditionalFormat.iconSet!;
  ///
  /// //Set conditions for IconCriteria.
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  ///
  /// iconSet.iconCriteria[1].type = ConditionValueType.percent;
  /// iconSet.iconCriteria[1].value = "30";
  /// iconSet.iconCriteria[2].type = ConditionValueType.percent;
  /// iconSet.iconCriteria[2].value = "60";
  ///
  /// //Set PercentileValues.
  /// iconSet.percentileValues = true;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  ///   File('Iconset.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// ```
  late bool percentileValues;

  /// Gets or sets a Boolean value indicating if the order of icons are reversed for an icon set. Default value is false.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  ///
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').number = 125;
  /// sheet.getRangeByName('A2').number = 279;
  /// sheet.getRangeByName('A3').number = 42;
  /// sheet.getRangeByName('A4').number = 384;
  /// sheet.getRangeByName('A5').number = 129;
  /// sheet.getRangeByName('A6').number = 212;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 230;
  ///
  /// //Create iconset for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat =
  ///     conditionalFormats.addCondition();
  ///
  /// //Set FormatType as IconSet.
  /// conditionalFormat.formatType = ExcelCFType.iconSet;
  /// final IconSet iconSet = conditionalFormat.iconSet!;
  ///
  /// //Set conditions for IconCriteria.
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  ///
  /// //Set reverse order.
  /// iconSet.reverseOrder = true;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Iconset.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool reverseOrder;

  /// Gets or sets a Boolean value indicating if only the icon is displayedfor an icon set conditional format. Default value is false.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  ///
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').number = 125;
  /// sheet.getRangeByName('A2').number = 279;
  /// sheet.getRangeByName('A3').number = 42;
  /// sheet.getRangeByName('A4').number = 384;
  /// sheet.getRangeByName('A5').number = 129;
  /// sheet.getRangeByName('A6').number = 212;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 230;
  ///
  /// //Create iconset for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat =
  ///     conditionalFormats.addCondition();
  ///
  /// //Set FormatType as IconSet.
  /// conditionalFormat.formatType = ExcelCFType.iconSet;
  /// final IconSet iconSet = conditionalFormat.iconSet!;
  ///
  /// //Set conditions for IconCriteria.
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  /// iconSet.iconCriteria[1].type = ConditionValueType.percent;
  /// iconSet.iconCriteria[1].value = "30";
  /// iconSet.iconCriteria[2].type = ConditionValueType.percent;
  /// iconSet.iconCriteria[2].value = "60";
  ///
  /// // Set show icon only.
  /// iconSet.showIconOnly = true;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Iconset.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool showIconOnly;
}
