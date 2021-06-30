part of xlsio;

/// Represents a data bar conditional formatting rule. Applying a data bar to a
/// range helps you see the value of a cell relative to other cells.
abstract class DataBar {
  /// Gets a ConditionValue object which specifies how the shortest bar is evaluated
  /// for a data bar conditional format.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// sheet.getRangeByName('A1').number = 12;
  /// sheet.getRangeByName('A2').number = 29;
  /// sheet.getRangeByName('A3').number = 41;
  /// sheet.getRangeByName('A4').number = -84;
  /// sheet.getRangeByName('A5').number = 90;
  /// sheet.getRangeByName('A6').number = 112;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 20;
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
  ///
  /// //Set type and value.
  /// dataBar.minPoint.type = ConditionValueType.percent;
  /// dataBar.minPoint.value = '20';
  ///
  /// //Set color for DataBar
  /// dataBar.barColor = '#FF7C80';
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late ConditionValue minPoint;

  /// Gets a ConditionValue object which specifies how the longest bar is evaluated
  /// for a data bar conditional format.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// sheet.getRangeByName('A1').number = 12;
  /// sheet.getRangeByName('A2').number = 29;
  /// sheet.getRangeByName('A3').number = 41;
  /// sheet.getRangeByName('A4').number = -84;
  /// sheet.getRangeByName('A5').number = 90;
  /// sheet.getRangeByName('A6').number = 112;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 20;
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  late ConditionValue maxPoint;

  /// Gets or sets the color of the bars in a data bar conditional format.
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
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  late String barColor;

  /// Gets or sets a value that specifies the length of the longest
  /// data bar as a percentage of cell width.
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
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
  ///
  /// //Set minumum percentage.
  /// dataBar.percentMax = 90;
  ///
  /// //Set color for DataBar
  /// dataBar.barColor = '#FF7C80';
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int percentMax;

  /// Gets or sets a value that specifies the length of the shortest
  /// data bar as a percentage of cell width.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// sheet.getRangeByName('A1').number = 12;
  /// sheet.getRangeByName('A2').number = 29;
  /// sheet.getRangeByName('A3').number = 41;
  /// sheet.getRangeByName('A4').number = -84;
  /// sheet.getRangeByName('A5').number = 90;
  /// sheet.getRangeByName('A6').number = 112;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 20;
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
  ///
  /// // Set maximum percentage.
  /// dataBar.percentMin = 20;
  ///
  /// //Set color for DataBar
  /// dataBar.barColor = '#FF7C80';
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int percentMin;

  /// Gets or sets a Boolean value that specifies if the value in the cell should be displayed or not. Default value is true.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// sheet.getRangeByName('A1').number = 12;
  /// sheet.getRangeByName('A2').number = 29;
  /// sheet.getRangeByName('A3').number = 41;
  /// sheet.getRangeByName('A4').number = -84;
  /// sheet.getRangeByName('A5').number = 90;
  /// sheet.getRangeByName('A6').number = 112;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 20;
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Hide the data bar values
  /// dataBar.showValue = false;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool showValue;

  /// Gets or sets the axis color of the data bar.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// sheet.getRangeByName('A1').number = 12;
  /// sheet.getRangeByName('A2').number = 29;
  /// sheet.getRangeByName('A3').number = 41;
  /// sheet.getRangeByName('A4').number = -84;
  /// sheet.getRangeByName('A5').number = 90;
  /// sheet.getRangeByName('A6').number = 112;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 20;
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Set BarAxis color for DataBar.
  /// dataBar.barAxisColor = '#FFDD12';
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String barAxisColor;

  /// Gets or sets the border color of the data bar.
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
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Set Border color for DataBar
  /// dataBar.borderColor = '#12DD01';
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String borderColor;

  /// Gets a Boolean value indicating whether the data bar has a border.
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
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
  ///
  /// //Set type and value.
  /// dataBar.minPoint.type = ConditionValueType.percent;
  /// dataBar.minPoint.value = '20';
  /// dataBar.maxPoint.type = ConditionValueType.percent;
  /// dataBar.maxPoint.value = '90';
  ///
  /// dataBar.barColor = '#FF7C80';
  /// //Hide the data bar values
  /// dataBar.hasBorder = true;
  /// //Set Border color for DataBar
  /// dataBar.borderColor = '#12DD01';
  ///
  /// print(dataBar.hasBorder);
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool hasBorder;

  /// Gets or sets a Boolean value indicating whether the data bar has a gradient fill.
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
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Hide the data bar values
  /// dataBar.showValue = false;
  ///
  /// // Set Gradient fill to false.
  /// dataBar.hasGradientFill = false;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late bool hasGradientFill;

  /// Gets or sets the direction of the data bar.
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
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Set Bar Direction
  /// dataBar.dataBarDirection = DataBarDirection.rightToLeft;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late DataBarDirection dataBarDirection;

  /// Gets or sets the negative border color of the data bar.
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
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Set NegativeBorder color for DataBar
  /// dataBar.negativeBorderColor = '#790DDA';
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String negativeBorderColor;

  /// Gets or sets the negative fill color of the data bar.
  /// This element MUST exist if and only if negativeBarColorSameAsPositive equals "false".
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
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Set NegativeBar color for DataBar
  /// dataBar.negativeFillColor = '#013461';
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String negativeFillColor;

  /// Gets or sets the axis position for the data bar.
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
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Set Bar Axis Position.
  /// dataBar.dataBarAxisPosition = DataBarAxisPosition.middle;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late DataBarAxisPosition dataBarAxisPosition;

  /// The color of the bars in a data bar conditional format in Rgb.
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
  /// final DataBar dataBar = conditionalFormat.dataBar!;
  ///
  /// //Set type and value.
  /// dataBar.minPoint.type = ConditionValueType.percent;
  /// dataBar.minPoint.value = '20';
  /// dataBar.maxPoint.type = ConditionValueType.percent;
  /// dataBar.maxPoint.value = '90';
  ///
  /// //Set color for DataBar
  /// dataBar.barColorRgb = Color.fromARGB(255, 200, 13, 145);
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Color barColorRgb;

  /// Gets or sets the negative border color of the data bar in Rgb.
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
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Set NegativeBorder color for DataBar
  /// dataBar.negativeBorderColorRgb = Color.fromARGB(255, 200, 130, 0);
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Color negativeBorderColorRgb;

  /// Gets or sets the negative fill color of the data bar in Rgb.
  /// This element MUST exist if and only if negativeBarColorSameAsPositive equals "false".
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
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Set NegativeBar color for DataBar
  /// dataBar.negativeFillColorRgb = Color.fromARGB(230, 201, 230, 100);
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Color negativeFillColorRgb;

  /// Gets or sets the axis color of the data bar in Rgb.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// sheet.getRangeByName('A1').number = 12;
  /// sheet.getRangeByName('A2').number = 29;
  /// sheet.getRangeByName('A3').number = 41;
  /// sheet.getRangeByName('A4').number = -84;
  /// sheet.getRangeByName('A5').number = 90;
  /// sheet.getRangeByName('A6').number = 112;
  /// sheet.getRangeByName('A7').number = 131;
  /// sheet.getRangeByName('A8').number = 20;
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// dataBar.hasBorder = true;
  /// //Set BarAxis color for DataBar in Rgb.
  /// dataBar.barAxisColorRgb = Color.fromARGB(255, 134, 44, 224);
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Color barAxisColorRgb;

  /// Gets or sets the border color of the data bar in Rgb.
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
  ///
  /// //Create data bars for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat = conditionalFormats.addCondition();
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar!;
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
  /// //Set Border color for DataBar
  /// dataBar.borderColorRgb = Color.fromARGB(245, 245, 44, 13);
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DataBar.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late Color borderColorRgb;
}
