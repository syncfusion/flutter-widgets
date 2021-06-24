part of xlsio;

/// Represents implementation of single condition value for iconset, databar, colorscale conditions.
abstract class ConditionValue {
  ///Gets or sets a condition value which specifies how the threshold values for a [DataBar], [ColorScale]
  /// and [IconSet] conditional format are determined.
  /// By default for IconSets [ConditionValue.type] property is set to [ConditionValueType.percent]. Here for example,
  /// we set [ConditionValueType.percentile] to [ConditionValue.type] property.
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
  /// final IconSet iconSet = conditionalFormat.iconSet;
  ///
  /// //Set conditions for IconCriteria.
  /// //Set icon set.
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  /// // Set Type and Value.
  /// iconSet.iconCriteria[1].type = ConditionValueType.percentile;
  /// iconSet.iconCriteria[1].value = "30";
  /// iconSet.iconCriteria[2].type = ConditionValueType.percentile;
  /// iconSet.iconCriteria[2].value = "60";
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('IconSet.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  /// For DataBars the [ConditionValue.type] is set to [ConditionValueType.automatic] by default. Here for example, we
  /// set [ConditionValueType.percent] to [ConditionValue.type] property.
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
  /// //Create dataBar for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat =
  ///     conditionalFormats.addCondition();
  ///
  /// //Set conditions.
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar;
  ///
  /// //Set the type and value.
  /// dataBar.minPoint.type = ConditionValueType.percent;
  /// dataBar.minPoint.value ='10';
  /// dataBar.maxPoint.type = ConditionValueType.percent;
  /// dataBar.maxPoint.value ='80';
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
  /// To set the [ConditionValueType] for [ColorScale] refer [ColorConditionValue.Type] property.
  late ConditionValueType type;

  /// Gets or sets the shortest bar or longest bar threshold value for a data
  ///
  /// IconSets use [IconSet.iconCriteria] list property to set icons, So each [ConditionValue] object has individual [ConditionValue.value]
  /// property. By default the [IconSet.iconCriteria] list property holds three objects and those object's [ConditionValue.value] property
  /// set "0", "33" and "67" respectively. In our example, we set "20" and "70" to [ConditionValue.value] property of second and third objects in
  /// [iconSet.iconCriteria] list property.
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
  /// final IconSet iconSet = conditionalFormat.iconSet;
  ///
  /// //Set conditions for IconCriteria.
  /// //Set icon set.
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  /// // Set Type and Value.
  /// iconSet.iconCriteria[1].type = ConditionValueType.percentile;
  /// iconSet.iconCriteria[1].value = "20";
  /// // set operators
  /// iconSet.iconCriteria[1].operator = ConditionalFormatOperator.greaterThan;
  /// iconSet.iconCriteria[2].type = ConditionValueType.percentile;
  /// iconSet.iconCriteria[2].value = "70";
  /// // set operators
  /// iconSet.iconCriteria[2].operator = ConditionalFormatOperator.greaterThan;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('IconSet.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  /// For DataBars the default value of [ConditionValue.value] property is set to "0". This property is can be changed by getting
  /// [DataBar.minPoint] or [DataBar.maxPoint] properties. These two properties define the shortest and longest bars of
  /// DataBar. For example, we have set the [ConditionValue.value] of [DataBar.minPoint] to "30".
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
  /// //Create dataBar for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat =
  ///     conditionalFormats.addCondition();
  ///
  /// //Set conditions.
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar;
  ///
  /// //Set the type and value.
  /// dataBar.minPoint.type = ConditionValueType.percent;
  /// dataBar.minPoint.value ='30';
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
  /// To set the value for [ColorScale] refer [ColorConditionValue.value] property.
  late String value;

  /// Gets or sets the operator for the threshold values in the conditional format.
  ///
  /// By default [ConditionValue.operator] is set to [ConditionalFormatOperator.greaterThanorEqualTo] and it can be changed to
  /// <see [ConditionalFormatOperator.greaterThan]. In our example, we change the [ConditionValue.operator] to [ConditionalFormatOperator.GreaterThan].
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
  /// final IconSet iconSet = conditionalFormat.iconSet;
  ///
  /// //Set conditions for IconCriteria.
  /// //Set icon set.
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  /// // Set Type and Value.
  /// iconSet.iconCriteria[1].type = ConditionValueType.percentile;
  /// iconSet.iconCriteria[1].value = "20";
  /// // set operators
  /// iconSet.iconCriteria[1].operator = ConditionalFormatOperator.greaterThan;
  /// iconSet.iconCriteria[2].type = ConditionValueType.percentile;
  /// iconSet.iconCriteria[2].value = "70";
  /// // set operators
  /// iconSet.iconCriteria[2].operator = ConditionalFormatOperator.greaterThan;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('IconSet.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  /// Similar to IconSets, DataBars also have [ConditionValue.operator] property set to [ConditionalFormatOperator.greaterThanorEqualTo]
  /// by default which can be changed to [ConditionalFormatOperator.greaterThan]
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
  /// //Create dataBar for the data in specified range.
  /// final ConditionalFormats conditionalFormats =
  ///     sheet.getRangeByName('A1:A8').conditionalFormats;
  /// final ConditionalFormat conditionalFormat =
  ///     conditionalFormats.addCondition();
  ///
  /// //Set conditions.
  /// conditionalFormat.formatType = ExcelCFType.dataBar;
  /// final DataBar dataBar = conditionalFormat.dataBar;
  ///
  /// //Set the type and value.
  /// dataBar.minPoint.type = ConditionValueType.percent;
  /// dataBar.minPoint.value ='30';
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
  /// To set the operator for [ColorScale] refer [ColorConditionValue.operator] property.
  late ConditionalFormatOperator operator;
}

/// Represents implementation of single condition value for iconset, databar, colorscale conditions.
class _ConditionValueImpl extends ConditionValue {
  /// Initializes new instance of the class.
  _ConditionValueImpl(this.type, this.value);

  @override

  /// Returns or sets one of the constants of the ConditionValueType enumeration
  /// which specifies how the threshold values for a data bar, color scale,
  /// or icon set conditional format are determined.
  late ConditionValueType type;

  @override

  /// Returns or sets threshold values for the conditional format.
  late String value;

  @override

  /// Sets the operator for the threshold values in the conditional format.
  ConditionalFormatOperator operator =
      ConditionalFormatOperator.greaterThanorEqualTo;
}

/// Represents condition value for colorset condition.
class ColorConditionValue extends ConditionValue {
  /// The color assigned to the threshold of a color scale conditional format.
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
  ///
  /// // set Color for FormatColor Property.
  /// colorScale.criteria[0].formatColor = '#63BE7B';
  /// colorScale.criteria[0].type = ConditionValueType.lowestValue;
  ///
  /// // set Color for FormatColor Property.
  /// colorScale.criteria[1].formatColor = '#FFFFFF';
  /// colorScale.criteria[1].type = ConditionValueType.number;
  /// colorScale.criteria[1].value = "70";
  ///
  /// // set Color for FormatColor Property.
  /// colorScale.criteria[2].formatColor = '#F8696B';
  /// colorScale.criteria[2].type = ConditionValueType.highestValue;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('ColorScale.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  late String formatColor;

  /// The color assigned to the threshold of a color scale conditional format in Rgb.
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
  ///
  /// // set Color for FormatColorRgb Property.
  /// colorScale.criteria[0].formatColorRgb = Color.fromARGB(255, 134, 10, 200);
  /// colorScale.criteria[0].type = ConditionValueType.lowestValue;
  ///
  /// // set Color for FormatColorRgb Property.
  /// colorScale.criteria[1].formatColorRgb = Color.fromARGB(250, 13, 200, 20);
  /// colorScale.criteria[1].type = ConditionValueType.number;
  /// colorScale.criteria[1].value = "70";
  ///
  /// // set Color for FormatColorRgb Property.
  /// colorScale.criteria[2].formatColorRgb = Color.fromARGB(255, 184, 110, 20);
  /// colorScale.criteria[2].type = ConditionValueType.highestValue;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('ColorScale.xlsx').writeAsBytes(bytes);
  ///  workbook.dispose();
  /// ```
  late Color formatColorRgb;
}

/// Represents the implementation of color condition value
class _ColorConditionValueImpl implements ColorConditionValue {
  /// Initializes new instance of the class.
  _ColorConditionValueImpl(this.type, this.value, String color) {
    formatColor = color;
  }

  /// The color assigned to the threshold of a color scale conditional format.
  late String _formatColor;

  /// The color assigned to the threshold of a color scale conditional format in Rgb.
  late Color _formatColorRgb;

  @override

  /// Returns or sets one of the constants of the ConditionValueType enumeration
  /// which specifies how the threshold values for a data bar, color scale,
  /// or icon set conditional format are determined.
  late ConditionValueType type;

  @override

  /// Returns or sets threshold values for the conditional format.
  late String value;

  @override

  /// Sets the operator for the threshold values in the conditional format.
  ConditionalFormatOperator operator =
      ConditionalFormatOperator.greaterThanorEqualTo;

  @override

  /// The color assigned to the threshold of a color scale conditional format.
  String get formatColor => _formatColor;

  @override
  set formatColor(String value) {
    _formatColor = value;
    _formatColorRgb =
        Color(int.parse(_formatColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override

  /// The color assigned to the threshold of a color scale conditional format in Rgb.
  Color get formatColorRgb => _formatColorRgb;

  @override
  set formatColorRgb(Color value) {
    _formatColorRgb = value;
    _formatColor = _formatColorRgb.value.toRadixString(16).toUpperCase();
  }
}

/// This object wraps ConditionValue object to ensure correct parent object update.
class _ColorConditionValueWrapper extends ColorConditionValue {
  /// Initializes new instance of the wrapped.
  _ColorConditionValueWrapper(
      _ColorConditionValueImpl value, _ColorScaleWrapper parent) {
    _wrapped = value;
    _parent = parent;
  }

  /// Wrapped item.
  late _ColorConditionValueImpl _wrapped;

  /// Parent item;
  late _ColorScaleWrapper _parent;

  @override

  /// <summary>
  String get formatColor {
    {
      return _wrapped.formatColor;
    }
  }

  @override
  set formatColor(String value) {
    _beginUpdate();
    _wrapped.formatColor = value;
    _endUpdate();
  }

  @override
  Color get formatColorRgb {
    {
      return _wrapped.formatColorRgb;
    }
  }

  @override
  set formatColorRgb(Color value) {
    _beginUpdate();
    _wrapped.formatColorRgb = value;
    _endUpdate();
  }

  @override

  /// Returns one of the constants of the XlConditionValueTypes enumeration,
  /// which specifies how the threshold values for a data bar, color scale,
  /// or icon set conditional format are determined. Read-only.
  ConditionValueType get type {
    {
      return _wrapped.type;
    }
  }

  @override
  set type(ConditionValueType value) {
    _beginUpdate();
    _wrapped.type = value;
    _endUpdate();
  }

  @override

  /// Returns or sets the shortest bar or longest bar threshold value for a data
  /// bar conditional format.
  String get value {
    {
      return _wrapped.value;
    }
  }

  @override
  set value(String value) {
    _beginUpdate();
    _wrapped.value = value;
    _endUpdate();
  }

  @override

  /// Returns or sets one of the constants of the ConditionalFormatOperator enumeration,
  /// which specifes if the threshold is "greater than" or "greater than or equal to" the threshold value.
  ConditionalFormatOperator get operator {
    {
      return _wrapped.operator;
    }
  }

  @override
  set operator(ConditionalFormatOperator value) {
    _beginUpdate();
    _wrapped.operator = value;
    _endUpdate();
  }

  /// Initiates updates to the object.
  void _beginUpdate() {
    _parent._beginUpdate();
  }

  /// Ends updating the object.
  void _endUpdate() {
    _parent._endUpdate();
  }
}

/// Represents a condition value for IconSet conditions.
class IconConditionValue extends ConditionValue {
  /// Returns or sets one of the constants of the IconConditionValueType enumeration. It specifies how the threshold values for icon set conditional format are determined.
  ///  /// Returns or sets index of the iconset type's individual icon index.
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
  /// final IconSet iconSet = conditionalFormat.iconSet;
  ///
  /// //Set conditions for IconCriteria.
  /// // set iconset.
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  ///
  /// final IconConditionValue iconValue1 = iconSet.iconCriteria[0];
  /// iconValue1.iconSet = ExcelIconSetType.fiveBoxes;
  /// // set Index of iconset.
  /// iconValue1.index = 3;
  /// iconValue1.type = ConditionValueType.percent;
  /// iconValue1.value = '25';
  /// iconValue1.operator = ConditionalFormatOperator.greaterThan;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Iconset.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late ExcelIconSetType iconSet;

  /// Returns or sets index of the iconset type's individual icon index.
  ///  /// Returns or sets index of the iconset type's individual icon index.
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
  /// final IconSet iconSet = conditionalFormat.iconSet;
  ///
  /// //Set conditions for IconCriteria.
  /// // set iconset.
  /// iconSet.iconSet = ExcelIconSetType.threeSymbols;
  ///
  /// final IconConditionValue iconValue1 = iconSet.iconCriteria[0];
  /// iconValue1.iconSet = ExcelIconSetType.fiveBoxes;
  /// // set Index of iconset.
  /// iconValue1.index = 3;
  /// iconValue1.type = ConditionValueType.percent;
  /// iconValue1.value = '25';
  /// iconValue1.operator = ConditionalFormatOperator.greaterThan;
  ///
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Iconset.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late int index;
}

/// Represents the implementation of Icon condition value
class _IconConditionValueImpl implements IconConditionValue {
  /// Initializes new instance of the class.
  _IconConditionValueImpl(this.iconSet, this.index);

  /// Initializes new instance of the class.
  _IconConditionValueImpl._withType(
      this.iconSet, this.index, this.type, this.value);

  @override

  /// Returns or sets one of the constants of the IconConditionValueType enumeration. It specifies how the threshold values for icon set conditional format are determined.
  late ExcelIconSetType iconSet;

  @override

  /// Returns or sets index of the iconset type's individual icon index.
  late int index;

  @override

  /// Returns or sets one of the constants of the ConditionValueType enumeration
  /// which specifies how the threshold values for a data bar, color scale,
  /// or icon set conditional format are determined.
  late ConditionValueType type;

  @override

  /// Returns or sets threshold values for the conditional format.
  late String value;

  @override

  /// Sets the operator for the threshold values in the conditional format.
  ConditionalFormatOperator operator =
      ConditionalFormatOperator.greaterThanorEqualTo;
}

/// This object wraps IconConditionValue object to ensure correct parent object update.
class _IconConditionValueWrapper implements IconConditionValue {
  /// Initializes new instance of wrapper.
  _IconConditionValueWrapper(
      _IconConditionValueImpl value, _IconSetWrapper parent) {
    _wrapped = value;
    _parent = parent;
  }

  /// Wrapped item.
  late _IconConditionValueImpl _wrapped;

  /// Parent.
  late _IconSetWrapper _parent;

  @override

  /// Returns or sets IconSet for individual IconSet criteria.
  ExcelIconSetType get iconSet {
    return _wrapped.iconSet;
  }

  @override
  set iconSet(ExcelIconSetType value) {
    _beginUpdate();
    _wrapped.iconSet = value;
    _endUpdate();
  }

  @override

  /// Gets or sets index of the iconset type's individual icon index.
  int get index {
    return _wrapped.index;
  }

  @override
  set index(int value) {
    _beginUpdate();
    _wrapped.index = value;
    _endUpdate();
  }

  @override

  /// Gets or sets the condition value type
  /// which specifies how the threshold values for a data bar, color scale,
  /// or icon set conditional format are determined. Read-only.
  ConditionValueType get type {
    return _wrapped.type;
  }

  @override
  set type(ConditionValueType value) {
    _beginUpdate();
    _wrapped.type = value;
    _endUpdate();
  }

  @override

  /// Gets or sets the shortest bar or longest bar threshold value for a data bar conditional format.
  String get value {
    return _wrapped.value;
  }

  @override
  set value(String value) {
    _beginUpdate();
    _wrapped.value = value;
    _endUpdate();
  }

  @override

  /// Gets or sets the operator
  ConditionalFormatOperator get operator {
    return _wrapped.operator;
  }

  @override
  set operator(ConditionalFormatOperator value) {
    _beginUpdate();
    _wrapped.operator = value;
    _endUpdate();
  }

  /// Initiates updates to the object.
  void _beginUpdate() {
    _parent._beginUpdate();
  }

  /// Ends updating the object.
  void _endUpdate() {
    _parent._endUpdate();
  }
}
