part of xlsio;

/// Represnets a single conditional format. Used for single-cell range.
class _ConditionalFormatImpl implements ConditionalFormat {
  /// Create a instances of conditionsal collection.
  _ConditionalFormatImpl(Worksheet worksheet, String value) {
    _book = worksheet._book;
    formatType = ExcelCFType.cellValue;
    operator = ExcelComparisonOperator.none;
    isBold = false;
    isItalic = false;
    fontColor = '#000000';
    underline = false;
    leftBorderColor = '#000000';
    rightBorderColor = '#000000';
    topBorderColor = '#000000';
    bottomBorderColor = '#000000';
    leftBorderStyle = LineStyle.none;
    rightBorderStyle = LineStyle.none;
    topBorderStyle = LineStyle.none;
    bottomBorderStyle = LineStyle.none;
    backColor = '#FFFFFF';
    stopIfTrue = false;
    numberFormat = 'General';
    _cfTimePeriod = CFTimePeriods.today;
    _cellList = value;
  }

  late String _cellList;

  /// Default Formula for Blank conditional Formatting type
  static const String _defaultBlankFormula = 'LEN(TRIM({0}))=0';

  ///  Default Formula for No Blank conditional Formatting type
  static const String _defaultNoBlankFormula = 'LEN(TRIM({0}))>0';

  ///  Default Formula for Error conditional Formatting type
  static const String _defaultErrorFormula = 'ISERROR({0})';

  /// Default Formula for NoError conditional Formatting type
  static const String _defaultNotErrorFormula = 'NOT(ISERROR({0}))';

  /// Default Formula for Begins With Specific Text conditional Formatting type
  static const String _defaultBeginsWithFormula = 'LEFT({0},LEN({1}))={1}';

  /// Default Formula for Ends With Specific Text conditional Formatting type
  static const String _defaultEndsWithFormula = 'RIGHT({0},LEN({1}))={1}';

  /// Default Formula for Contains Text Specific Text conditional Formatting type
  static const String _defaultContainsTextFormula =
      'NOT(ISERROR(SEARCH({0},{1})))';

  /// Default Formula for NotContains Text Specific Text conditional Formatting type
  static const String _defaultNotContainsTextFormula =
      'ISERROR(SEARCH({0},{1}))';

  /// Default formula for yesterday's time period type
  static const String _defaultYesterdayTimePeriodFormula =
      'FLOOR({0},1)=TODAY()-1';

  /// Default formula for today's time period ytype
  static const String _defaultTodayTimePeriodFormula = 'FLOOR({0},1)=TODAY()';

  /// Default formula for tomorrow's time period type
  static const String _defaultTomorrowTimePeriodFormula =
      'FLOOR({0},1)=TODAY()+1';

  /// Default formula for last seven days time period type
  static const String _defaultLastSevenDaysTimePeriodFormula =
      'AND(TODAY()-FLOOR({0},1)<=6,FLOOR({0},1)<=TODAY())';

  /// Default formula for last week time period type
  static const String _defaultLastWeekTimePeriodFormula =
      'AND(TODAY()-ROUNDDOWN({0},0)>=(WEEKDAY(TODAY())),TODAY()-ROUNDDOWN({0},0)<(WEEKDAY(TODAY())+7))';

  /// Default formula for this week time period type
  static const String _defaultThisWeekTimePeriodFormula =
      'AND(TODAY()-ROUNDDOWN({0},0)<=WEEKDAY(TODAY())-1,ROUNDDOWN({0},0)-TODAY()<=7-WEEKDAY(TODAY()))';

  ///  Default formula for next week time period type
  static const String _defaultNextWeekTimePeriodFormula =
      'AND(ROUNDDOWN({0},0)-TODAY()>(7-WEEKDAY(TODAY())),ROUNDDOWN({0},0)-TODAY()<(15-WEEKDAY(TODAY())))';

  ///  Default formula for last month time period type
  static const String _defaultLastMonthTimePeriodFormula =
      'AND(MONTH({0})=MONTH(EDATE(TODAY(),0-1)),YEAR({0})=YEAR(EDATE(TODAY(),0-1)))';

  ///  Default formula for this month time period type
  static const String _defaultThisMonthTimePeriodFormula =
      'AND(MONTH({0})=MONTH(TODAY()),YEAR({0})=YEAR(TODAY()))';

  ///  Default formula for next month time period type
  static const String _defaultNextMonthTimePeriodFormula =
      'AND(MONTH({0})=MONTH(EDATE(TODAY(),0+1)),YEAR({0})=YEAR(EDATE(TODAY(),0+1)))';

  /// Parent workbook.
  late Workbook _book;

  /// Represents the text value.
  String? _text;

  // ignore: unused_field
  Range? _range;

  /// Represents the Time Period conditional formatting types.
  late CFTimePeriods _cfTimePeriod;

  /// Represent the Format Type.
  late ExcelCFType _formatType;

  /// Represents whether the conditional format has extension list or not
  // ignore: prefer_final_fields
  bool _bCFHasExtensionList = false;

  /// Represents the range refernce of Conditional formatting
  // ignore: prefer_final_fields
  String _rangeRefernce = '';

  /// Represents the priority of the conditional format.
  // ignore: prefer_final_fields
  int _priority = 0;

  /// Gets TopBottom conditional formatting rule. Read-only.
  _TopBottomImpl? _topBottom;

  /// Gets AboveBelowAverage conditional formatting rule. Read-only.
  _AboveBelowAverageImpl? _aboveBelowAverage;

  /// Color scale settings.
  _ColorScaleImpl? _colorScale;

  /// Icon set settings.
  _IconSetImpl? _iconSet;

  /// Data bar settings.
  _DataBarImpl? _dataBar;

  late String _backColor;
  @override

  /// Gets/sets back color.
  String get backColor => _backColor;

  @override
  set backColor(String value) {
    _backColor = value;
    _backColorRgb =
        Color(int.parse(_backColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  late int _numberFormatIndex;

  /// Gets number format object.
  _Format get numberFormatObject {
    //MS Excel sets 14th index by default if the index is out of range for any the datatype.
    //So, using the same here in XlsIO.
    if (_book.innerFormats.count > 14 &&
        !_book.innerFormats._contains(_numberFormatIndex)) {
      _numberFormatIndex = 14;
    }
    return _book.innerFormats[_numberFormatIndex];
  }

  @override

  /// Returns or sets the format code for the object. Read/write String.
  String? get numberFormat {
    return numberFormatObject._formatString;
  }

  @override

  /// Sets the number format.
  set numberFormat(String? value) {
    _numberFormatIndex = _book.innerFormats._findOrCreateFormat(value);
  }

  @override

  /// Gets or sets the type of the conditional format.
  ExcelCFType get formatType {
    return _formatType;
  }

  @override

  /// Gets or sets the type of the conditional format.
  set formatType(ExcelCFType value) {
    switch (value) {
      case ExcelCFType.cellValue:
        operator = ExcelComparisonOperator.between;
        break;
      case ExcelCFType.specificText:
        operator = ExcelComparisonOperator.containsText;
        break;
      case ExcelCFType.timePeriod:
        operator = ExcelComparisonOperator.none;
        timePeriodType = CFTimePeriods.today;
        break;
      case ExcelCFType.blank:
        firstFormula = _defaultBlankFormula;
        firstFormula = firstFormula.replaceAll('{0}', _cellList);
        break;
      case ExcelCFType.noBlank:
        firstFormula = _defaultNoBlankFormula;
        firstFormula = firstFormula.replaceAll('{0}', _cellList);
        break;
      case ExcelCFType.containsErrors:
        firstFormula = _defaultErrorFormula;
        firstFormula = firstFormula.replaceAll('{0}', _cellList);
        break;
      case ExcelCFType.notContainsErrors:
        firstFormula = _defaultNotErrorFormula;
        firstFormula = firstFormula.replaceAll('{0}', _cellList);
        break;
      case ExcelCFType.topBottom:
        topBottom = _TopBottomImpl();
        break;
      case ExcelCFType.aboveBelowAverage:
        aboveBelowAverage = _AboveBelowAverageImpl();
        break;
      case ExcelCFType.colorScale:
        _colorScale = _ColorScaleImpl();
        break;
      case ExcelCFType.iconSet:
        _iconSet = _IconSetImpl();
        break;
      case ExcelCFType.dataBar:
        _dataBar = _DataBarImpl();
        _dataBar!._hasExtensionList = true;
        break;
      case ExcelCFType.formula:
        operator = ExcelComparisonOperator.none;
        break;
      case ExcelCFType.duplicate:
        operator = ExcelComparisonOperator.none;
        break;
      case ExcelCFType.unique:
        operator = ExcelComparisonOperator.none;
        break;
    }

    _formatType = value;
  }

  late String _topBorderColor;

  @override

  /// Gets/sets top Border.
  String get topBorderColor => _topBorderColor;

  @override
  set topBorderColor(String value) {
    _topBorderColor = value;
    _topBorderColorRgb = Color(
        int.parse(_topBorderColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  late String _bottomBorderColor;

  @override

  /// Gets/sets top Border.
  String get bottomBorderColor => _bottomBorderColor;

  @override
  set bottomBorderColor(String value) {
    _bottomBorderColor = value;
    _bottomBorderColorRgb = Color(
        int.parse(_bottomBorderColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  late String _rightBorderColor;

  @override

  /// Gets/sets right Border.
  String get rightBorderColor => _rightBorderColor;

  @override
  set rightBorderColor(String value) {
    _rightBorderColor = value;
    _rightBorderColorRgb = Color(
        int.parse(_rightBorderColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  late String _leftBorderColor;
  @override

  /// Gets/sets leftBorder.
  String get leftBorderColor => _leftBorderColor;

  @override
  set leftBorderColor(String value) {
    _leftBorderColor = value;
    _leftBorderColorRgb = Color(
        int.parse(_leftBorderColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override

  // Gets or sets right border style
  late LineStyle rightBorderStyle;

  @override

  // Gets or set bottom border style
  late LineStyle bottomBorderStyle;

  @override

  // Gets or sets left border style
  late LineStyle leftBorderStyle;

  @override

  // Gets or sets top border style
  late LineStyle topBorderStyle;

  /// Gets/sets font color.
  late String _fontColor;

  @override

  /// Gets/sets font color.
  String get fontColor => _fontColor;

  @override
  set fontColor(String value) {
    _fontColor = value;
    _fontColorRgb =
        Color(int.parse(_fontColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override

  /// Gets or sets the comparison operator for the conditional format.
  late ExcelComparisonOperator operator;

  @override

  /// Gets and sets boolean value indicating whether the font is bold.
  late bool isBold;

  @override

  /// Gets a boolean value indicating whether the font is italic.
  late bool isItalic;

  @override

  /// Gets or sets the underline type for the conditional format.
  late bool underline;

  @override

  /// Gets the text value used in conditional formatting rule.
  /// The default value is null.
  String? get text => _text;

  @override

  /// sets the text value used in conditional formatting rule.
  set text(String? value) {
    if (value == null || value == '') {
      throw Exception('Argument cannot be null or empty.');
    }
    _text = value;
    if (formatType == ExcelCFType.specificText) {
      _setSpecificTextString(operator, value);
    }
  }

  @override

  /// Gets or sets a boolean value that determines if additional formatting rules on the cell should be evaluated
  /// if the current rule evaluates to True.
  late bool stopIfTrue;

  @override

  ///  Gets one of the constants of <see cref="CFTimePeriods"/> enumeration
  ///  which represents the type of the time period.
  CFTimePeriods get timePeriodType => _cfTimePeriod;

  @override

  ///  Sets one of the constants of <see cref="CFTimePeriods"/> enumeration
  ///  which represents the type of the time period.
  set timePeriodType(CFTimePeriods value) {
    if (formatType == ExcelCFType.timePeriod) {
      _cfTimePeriod = value;
    }
    _setTimePeriodFormula(timePeriodType);
  }

  @override

  /// Gets the value or expression associated with the conditional format.
  String firstFormula = '';

  @override

  /// Gets the value or expression associated with the conditional format.
  String secondFormula = '';

  /// Sets the specifed text value for the SpecficText conditional format.
  void _setSpecificTextString(
      ExcelComparisonOperator compOperator, String value) {
    String val;
    switch (compOperator) {
      case ExcelComparisonOperator.beginsWith:
        val = _defaultBeginsWithFormula;
        val = val.replaceAll('{0}', _cellList);
        val = val.replaceAll('{1}', '"$value"');
        firstFormula = val;
        break;
      case ExcelComparisonOperator.endsWith:
        val = _defaultEndsWithFormula;
        val = val.replaceAll('{0}', _cellList);
        val = val.replaceAll('{1}', '"$value"');
        firstFormula = val;
        break;
      case ExcelComparisonOperator.containsText:
        val = _defaultContainsTextFormula;
        val = val.replaceAll('{0}', '"$value"');
        val = val.replaceAll('{1}', _cellList);
        firstFormula = val;
        break;
      case ExcelComparisonOperator.notContainsText:
        val = _defaultNotContainsTextFormula;
        val = val.replaceAll('{0}', '"$value"');
        val = val.replaceAll('{1}', _cellList);
        firstFormula = val;
        break;
      case ExcelComparisonOperator.none:
      case ExcelComparisonOperator.between:
      case ExcelComparisonOperator.notBetween:
      case ExcelComparisonOperator.equal:
      case ExcelComparisonOperator.notEqual:
      case ExcelComparisonOperator.greater:
      case ExcelComparisonOperator.less:
      case ExcelComparisonOperator.greaterOrEqual:
      case ExcelComparisonOperator.lessOrEqual:
        operator = ExcelComparisonOperator.containsText;
        val = _defaultContainsTextFormula;
        val = val.replaceAll('{0}', '"$value"');
        val = val.replaceAll('{1}', _cellList);
        firstFormula = val;
        break;
    }
  }

  /// Sets the formula for time period types.
  void _setTimePeriodFormula(CFTimePeriods cfTimePeriods) {
    String val;
    switch (cfTimePeriods) {
      case CFTimePeriods.today:
        val = _defaultTodayTimePeriodFormula;
        val = val.replaceAll('{0}', _cellList);
        firstFormula = val;
        break;
      case CFTimePeriods.tomorrow:
        val = _defaultTomorrowTimePeriodFormula;
        val = val.replaceAll('{0}', _cellList);
        firstFormula = val;
        break;
      case CFTimePeriods.yesterday:
        val = _defaultYesterdayTimePeriodFormula;
        val = val.replaceAll('{0}', _cellList);
        firstFormula = val;
        break;
      case CFTimePeriods.last7Days:
        val = _defaultLastSevenDaysTimePeriodFormula;
        val = val.replaceAll('{0}', _cellList);
        firstFormula = val;
        break;
      case CFTimePeriods.lastWeek:
        val = _defaultLastWeekTimePeriodFormula;
        val = val.replaceAll('{0}', _cellList);
        firstFormula = val;
        break;
      case CFTimePeriods.thisWeek:
        val = _defaultThisWeekTimePeriodFormula;
        val = val.replaceAll('{0}', _cellList);
        firstFormula = val;
        break;
      case CFTimePeriods.nextWeek:
        val = _defaultNextWeekTimePeriodFormula;
        val = val.replaceAll('{0}', _cellList);
        firstFormula = val;
        break;
      case CFTimePeriods.lastMonth:
        val = _defaultLastMonthTimePeriodFormula;
        val = val.replaceAll('{0}', _cellList);
        firstFormula = val;
        break;
      case CFTimePeriods.thisMonth:
        val = _defaultThisMonthTimePeriodFormula;
        val = val.replaceAll('{0}', _cellList);
        firstFormula = val;
        break;
      case CFTimePeriods.nextMonth:
        val = _defaultNextMonthTimePeriodFormula;
        val = val.replaceAll('{0}', _cellList);
        firstFormula = val;
        break;
    }
  }

  @override

  /// Gets TopBottom conditional formatting rule.
  TopBottom? get topBottom {
    return _topBottom;
  }

  @override
  set topBottom(TopBottom? value) {
    _topBottom = value! as _TopBottomImpl;
  }

  @override

  /// Gets AboveBelowAverage conditional formatting rule.
  AboveBelowAverage? get aboveBelowAverage {
    return _aboveBelowAverage;
  }

  @override
  set aboveBelowAverage(AboveBelowAverage? value) {
    _aboveBelowAverage = value! as _AboveBelowAverageImpl;
  }

  @override

  /// Color scale settings.
  ColorScale? get colorScale {
    return _colorScale;
  }

  @override
  set colorScale(ColorScale? value) {
    _colorScale = value! as _ColorScaleImpl;
  }

  @override

  /// Color scale settings.
  IconSet? get iconSet {
    return _iconSet;
  }

  @override
  set iconSet(IconSet? value) {
    _iconSet = value! as _IconSetImpl;
  }

  @override

  /// Gets data bar conditional formatting rule. Valid only if FormatType is set to DataBar.
  DataBar? get dataBar {
    return _dataBar;
  }

  @override
  set dataBar(DataBar? value) {
    _dataBar = value! as _DataBarImpl;
  }

  late String _firstFormulaR1C1;

  @override

  /// Gets the value or expression associated with the conditional format
  /// in R1C1 notation.
  String get firstFormulaR1C1 => _firstFormulaR1C1;

  @override

  /// sets the value or expression associated with the conditional format
  /// in R1C1 notation.
  set firstFormulaR1C1(String value) {
    if (value.isEmpty) {
      throw Exception('FirstFormulaR1C1 value should be null or empty');
    }
    if (value[0] == '=') {
      value = value.substring(1);
    }
    _firstFormulaR1C1 = value;
    firstFormula = _getFormulaValue(_firstFormulaR1C1);
  }

  // Gets the Formula value from R1C1 formula Style.
  String _getFormulaValue(String formulaR1C1) {
    String formula = '';
    if (_range != null) {
      final List<String> cells = <String>[];
      final RegExp regex = RegExp(
          r'\R\C(-?\d+)|\R\[(-?\d+)\]\C(-?\d+)|\R(-?\d+)\C(-?\d+)|\R(-?\d+)\C\[(-?\d+)\]|\R\[(-?\d+)\]\C\[(-?\d+)\]|\R\C\[(-?\d+)\]|\R\[(-?\d+)\]\C|\R\C|\R(-?\d+)\C');
      final List<RegExpMatch> matches = regex.allMatches(formulaR1C1).toList();
      for (final Match match in matches) {
        cells.add(formulaR1C1.substring(match.start, match.end));
      }
      final int iLen = cells.length;
      int val1, val2;
      List<dynamic> result;
      int row, column;
      bool bRow, bColumn;
      final List<String> formulaValue = <String>[];
      for (int i = 0; i < iLen; i++) {
        result = _parseR1C1Expression(cells[i]);
        val1 = result[0] as int;
        val2 = result[1] as int;
        bRow = result[2] as bool;
        bColumn = result[3] as bool;
        row = val1 + _range!.row;
        column = val2 + _range!.column;
        String strFormula, strRow, strColumn;
        if (bRow) {
          strRow = row.toString();
        } else {
          strRow = r'$' + (row - 1).toString();
        }
        if (bColumn) {
          strColumn = Range._getColumnName(column);
        } else {
          strColumn = r'$' + Range._getColumnName(column - 1);
        }
        strFormula = strColumn + strRow;
        formulaValue.add(strFormula);
      }
      formula = formulaR1C1;
      for (int i = 0; i < formulaValue.length; i++) {
        formula = formula.replaceFirst(cells[i], formulaValue[i]);
      }
    }
    return formula;
  }

  // Parse the R1C1 cell style to get index of cells
  List<dynamic> _parseR1C1Expression(String cells) {
    final int iColumnStart = cells.indexOf('C');
    final bool bRowPresent = cells[0] == 'R';
    final bool bColPresent = iColumnStart != -1;
    if (!bRowPresent && !bColPresent) {
      throw Exception('"FromulaR1C1" , Can\'t locate row or column section.');
    }
    final String strColumn =
        bColPresent ? cells.substring(iColumnStart + 1) : '';

    final int iRowSectionLen = bColPresent ? iColumnStart : cells.length;
    final String strRow = bRowPresent ? cells.substring(1, iRowSectionLen) : '';
    bool bRow, bColumn;
    if (strRow.isEmpty || strRow.contains('[')) {
      bRow = true;
    } else {
      bRow = false;
    }
    if (strColumn.isEmpty || strColumn.contains('[')) {
      bColumn = true;
    } else {
      bColumn = false;
    }
    final int iRowIndex = _getIndexFromR1C1(strRow);
    final int iColumnIndex = _getIndexFromR1C1(strColumn);
    return <dynamic>[iRowIndex, iColumnIndex, bRow, bColumn];
  }

  // Return the indexes of R1C1 style value.
  int _getIndexFromR1C1(String value) {
    if (value.isEmpty) {
      return 0;
    }
    final int iLength = value.length;
    if (value[0] == '[' && value[iLength - 1] == ']') {
      value = value.substring(1, iLength - 1);
    }
    int? d;
    int index = -1;
    d = int.tryParse(value);
    if (d != null && d >= -2147483648 && d <= 2147483647) {
      index = d;
    }
    return index;
  }

  String _secondFormulaR1C1 = '';

  @override

  /// Gets the value or expression associated with the conditional format
  /// in R1C1 notation.
  String get secondFormulaR1C1 => _secondFormulaR1C1;

  @override

  /// sets the value or expression associated with the conditional format
  /// in R1C1 notation.
  set secondFormulaR1C1(String value) {
    if (value.isEmpty) {
      throw Exception('SecondFormulaR1C1 value should be null or empty');
    }
    if (value[0] == '=') {
      value = value.substring(1);
    }
    _secondFormulaR1C1 = value;
    secondFormula = _getFormulaValue(_secondFormulaR1C1);
  }

  late Color _backColorRgb;

  late Color _fontColorRgb;

  late Color _leftBorderColorRgb;

  late Color _rightBorderColorRgb;

  late Color _bottomBorderColorRgb;

  late Color _topBorderColorRgb;

  @override

  /// Gets/sets back color Rgb.
  Color get backColorRgb => _backColorRgb;

  @override
  set backColorRgb(Color value) {
    _backColorRgb = value;
    _backColor = _backColorRgb.value.toRadixString(16).toUpperCase();
  }

  @override

  /// Gets/sets font color Rgb.
  Color get fontColorRgb => _fontColorRgb;

  @override
  set fontColorRgb(Color value) {
    _fontColorRgb = value;
    _fontColor = _fontColorRgb.value.toRadixString(16).toUpperCase();
  }

  @override

  /// Gets or sets the left border color from Rgb.
  Color get leftBorderColorRgb => _leftBorderColorRgb;

  @override
  set leftBorderColorRgb(Color value) {
    _leftBorderColorRgb = value;
    _leftBorderColor =
        _leftBorderColorRgb.value.toRadixString(16).toUpperCase();
  }

  @override

  /// Gets or sets the right border color from Rgb.
  Color get rightBorderColorRgb => _rightBorderColorRgb;

  @override
  set rightBorderColorRgb(Color value) {
    _rightBorderColorRgb = value;
    _rightBorderColor =
        _rightBorderColorRgb.value.toRadixString(16).toUpperCase();
  }

  @override

  /// Gets or sets the top border color from Rgb.
  Color get topBorderColorRgb => _topBorderColorRgb;

  @override
  set topBorderColorRgb(Color value) {
    _topBorderColorRgb = value;
    _topBorderColor = _topBorderColorRgb.value.toRadixString(16).toUpperCase();
  }

  @override

  /// Gets or sets the bottom border color from Rgb.
  Color get bottomBorderColorRgb => _bottomBorderColorRgb;

  @override
  set bottomBorderColorRgb(Color value) {
    _bottomBorderColorRgb = value;
    _bottomBorderColor =
        _bottomBorderColorRgb.value.toRadixString(16).toUpperCase();
  }
}
