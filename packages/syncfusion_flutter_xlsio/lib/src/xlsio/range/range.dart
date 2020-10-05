part of xlsio;

/// Represent the Range
class Range {
  /// Create an instance of class
  Range(Worksheet worksheet) {
    _worksheet = worksheet;
  }

  /// Represents the row in range.
  int row;

  /// Represents the colunm in range.
  int column;

  /// Represents the last row in range.
  int lastRow;

  /// Represents the last column in range.
  int lastColumn;

  /// Represents the cell type.
  CellType type;

  /// Represents the save type.
  String _saveType;
  String _formula;
  double _number;
  String _text;
  DateTime _dateTime;
  Object _value;
  Style _cellStyle;

  /// Represent the index of the Range.
  int _index;
  int _textIndex;
  Column _columnObj;
  Worksheet _worksheet;
  int _styleIndex;
  BuiltInStyles _builtInStyle;
  String _styleName;
  List<Range> _cells;
  bool _bCells = false;
  String _boolean;
  String _errorValue;

  /// Represents the row span.
  int _rowSpan = 0;

  /// Represents the column span.
  int _colSpan = 0;

  /// False if Number format is set in run time
  bool _isDefaultFormat = true;

  /// General format.
  static const String _defaultGeneralFormat = 'General';

  /// Whitspace for the numberformat.
  static const String _defaultEmptyDigit = ' ';

  ///Open brace for formula.
  static const String _defaultOpenBrace = '(';

  ///Equivalent symbol for formula.
  static const String _defaultEquivalent = '=';

  /// Gets the Range reference along with its sheet name in format "'Sheet1'!$A$1". Read-only.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// String address = range.addressGlobal;
  /// workbook.save('AddressGlobal.xlsx');
  /// workbook.dispose();
  /// ```
  String get addressGlobal {
    final String result = worksheet.name + '!';
    final String cell0 = '\$' + _getCellNameWithSymbol(row, column);

    if (isSingleRange) {
      return result + cell0;
    } else {
      final String cell1 = '\$' + _getCellNameWithSymbol(lastRow, lastColumn);
      return result + cell0 + ':' + cell1;
    }
  }

  /// Represents the reference name.
  String get addressLocal {
    return _getCellName(row, column);
  }

  /// Represent the range formula.
  String get formula {
    if (isSingleRange) {
      return _formula;
    } else {
      return getFormula();
    }
  }

  /// Sets the range formula.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.fromula = '=10+10';
  /// workbook.save('Formula.xlsx');
  /// workbook.dispose();
  /// ```
  set formula(String value) {
    setFormula(value);
  }

  /// Represent the Number of the Range
  double get number {
    if (isSingleRange) {
      return _number;
    } else {
      return _getNumber();
    }
  }

  /// Sets the Number of the Range.
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.number = 44;
  /// workbook.save('Number.xlsx');
  /// workbook.dispose();
  /// ```
  set number(double value) {
    setNumber(value);
  }

  /// Represent the Text of the Range
  String get text {
    if (isSingleRange) {
      return _text;
    } else {
      return getText();
    }
  }

  /// Sets the text of the range.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.text = 'Hello World';
  /// workbook.save('Text.xlsx');
  /// workbook.dispose();
  /// ```
  set text(String value) {
    setText(value);
  }

  /// Represent the DateTime of the Range
  DateTime get dateTime {
    if (isSingleRange) {
      return _dateTime;
    } else {
      return getDateTime();
    }
  }

  /// Sets the DateTime of the Range.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.dateTime = DateTime(2011, 1, 20, 20, 37, 80);
  /// workbook.save('DateTime.xlsx');
  /// workbook.dispose();
  /// ```
  set dateTime(DateTime value) {
    setDateTime(value);
  }

  /// Represent the DateTime of the Range
  Object get value {
    return _value;
  }

  /// sets the value of the Range.
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.value = 44;
  /// workbook.save('value.xlsx');
  /// workbook.dispose();
  /// ```
  set value(Object value) {
    setValue(value);
  }

  /// Gets cell value text with its number format. Read-only.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.value = '1/1/2015';
  /// range.numberFormat = 'dd-MMM-yyyy';
  /// String displayText = range.displayText;
  /// workbook.save('displayText.xlsx');
  /// workbook.dispose();
  /// ```
  String get displayText {
    return getDisplayText(row, column);
  }

  /// Gets the calculated value of a formula in the Range. Read-only.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1').number = 44;
  /// Range range = sheet.getRangeByName('C1');
  /// range.formula = '=A1';
  /// //Initializes Calculate Engine to perform calculation
  /// sheet.enableSheetCalculations();
  /// String calculatedValue = range.calculatedValue;
  /// workbook.save('CalculatedValue.xlsx');
  /// workbook.dispose();
  /// ```
  String get calculatedValue {
    if (formula != null) {
      if (worksheet.calcEngine != null) {
        final String cellRef = addressLocal;
        return worksheet.calcEngine._pullUpdatedValue(cellRef);
      }
      return null;
    } else {
      return '';
    }
  }

  /// Represent the NumberFormat of the Range
  String get numberFormat {
    if (cellStyle == null) return null;

    String format;
    if (isSingleRange) format = (cellStyle as CellStyle).numberFormat;

    if (format == null) {
      final List<Range> rangeColection = cells;
      final int iCount = rangeColection.length;

      if (iCount == 0) return null;

      Range range = rangeColection[0];
      String strResult;
      if (range != null) {
        strResult = range.numberFormat;
        for (int i = 1; i < iCount; i++) {
          range = rangeColection[i];
          if (strResult != range.numberFormat) return null;
        }
      }
      format = strResult;
    }
    if (format != null && format != '') {
      if (format.contains('\\')) {
        format = _checkAndGetDateUncustomizedString(format);
      }

      format = _checkForAccountingString(format);
      format.replaceAllMapped(_FormatParser._numberFormatRegex, (match) {
        return '';
      });
    }
    return format;
  }

  /// Sets number format of cell which is similar to Style.numberFormat property.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.value = '1/1/2015';
  /// range.numberFormat = 'dd-MMM-yyyy';
  /// String displayText = range.displayText;
  /// workbook.save('NumberFormat.xlsx');
  /// workbook.dispose();
  /// ```
  set numberFormat(String value) {
    if (isSingleRange) {
      _cellStyle ??= CellStyle(workbook);
      (_cellStyle as CellStyle).numberFormat = value;
      _isDefaultFormat = false;
      _setRange();
    } else {
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        // ignore: prefer_final_locals
        for (int iCol = column, iLastCol = lastColumn;
            iCol <= iLastCol;
            iCol++) {
          worksheet.getRangeByIndex(iRow, iCol).numberFormat = value;
        }
      }
    }
  }

  /// Gets number format object corresponding to this Range. Read-only.
  _Format get _innerNumberFormat {
    int iFormatIndex = cellStyle.numberFormatIndex;
    if (workbook.innerFormats.count > 14 &&
        !workbook.innerFormats._contains(iFormatIndex)) iFormatIndex = 14;
    return workbook.innerFormats[iFormatIndex];
  }

  /// Checks if the Range represents a single cell or Range of cells. Read-only.
  bool get isSingleRange {
    return (row == lastRow && column == lastColumn);
  }

  /// Represent the format is default or not.
  bool get isDefaultFormat {
    return _isDefaultFormat;
  }

  // Gets a <see cref='Style'/> object that represents the style of the Range.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Style rangeStyle = sheet.getRangeByName('A1').cellStyle;
  /// rangeStyle.bold = true;
  /// workbook.save('CellstyleRange.xlsx');
  /// workbook.dispose();
  /// ```
  Style get cellStyle {
    if (isSingleRange) {
      if (_cellStyle == null && !workbook._saving) {
        _cellStyle = CellStyle(workbook);
        _setRange();
      } else if (_cellStyle != null &&
          !workbook._saving &&
          (_cellStyle as CellStyle).isGlobalStyle) {
        _cellStyle = (_cellStyle as CellStyle)._clone();
      }
      return _cellStyle;
    }
    return CellStyleWrapper(this);
  }

  /// Sets the cell style.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Style cellStyle = new CellStyle(workbook);
  /// cellStyle.backColor = '#78921A';
  /// workbook.styles.addStyle(cellStyle);
  /// Range range1 = sheet.getRangeByIndex(1, 1);
  /// range1.cellStyle = cellStyle;
  /// workbook.save('CellstyleRange.xlsx');
  /// workbook.dispose();
  /// ```
  set cellStyle(CellStyle value) {
    if (isSingleRange) {
      _cellStyle = value._clone();
      _setRange();
    } else {
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        // ignore: prefer_final_locals
        for (int iCol = column, iLastCol = lastColumn;
            iCol <= iLastCol;
            iCol++) {
          final Range range = worksheet.getRangeByIndex(iRow, iCol);
          range._cellStyle = value;
          range._setRange();
        }
      }
    }
  }

  /// Represent the worksheet of the range.
  Worksheet get worksheet {
    return _worksheet;
  }

  /// Represent the workbook of the range.
  Workbook get workbook {
    return _worksheet.workbook;
  }

  /// Represent the built-in-style of the range.
  BuiltInStyles get builtInStyle {
    return _builtInStyle;
  }

  /// Set the built-in-style of the range.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.builtInStyle = BuiltInStyles.accent1;
  /// workbook.save('BuiltInStyle.xlsx');
  /// workbook.dispose();
  /// ```
  set builtInStyle(BuiltInStyles value) {
    setBuiltInStyle(value);
  }

  /// Represents the row span.
  int get rowSpan {
    return _rowSpan;
  }

  set rowSpan(int value) {
    _rowSpan = value;
    _setRange();
  }

  /// Represents the column span.
  int get columnSpan {
    return _colSpan;
  }

  set columnSpan(int value) {
    _colSpan = value;
    _setRange();
  }

  /// Represents the row height.
  double get rowHeight {
    final Row _rowObj = _worksheet.rows[row];
    if (_rowObj != null) {
      return _rowObj.height;
    }
    return 0;
  }

  /// sets the height of all the rows in the range, measured in points.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.rowHeight = 25;
  /// workbook.save('RowHeight.xlsx');
  /// workbook.dispose();
  /// ```
  set rowHeight(double value) {
    if (isSingleRange) {
      Row _rowObj = _worksheet.rows[row];
      if (worksheet.rows[row] == null) {
        _rowObj = Row(_worksheet);
        _rowObj.index = row;
        worksheet.rows[row] = _rowObj;
      }
      _rowObj.height = value;
    } else {
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        // ignore: prefer_final_locals
        for (int iCol = column, iLastCol = lastColumn;
            iCol <= iLastCol;
            iCol++) {
          worksheet.getRangeByIndex(iRow, iCol).rowHeight = value;
        }
      }
    }
  }

  /// Represents the column width.
  double get columnWidth {
    if (_columnObj != null) {
      return _columnObj.width;
    }
    return 0;
  }

  /// Sets width of all the column in the range, measured in points.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.columnWidth = 25;
  /// workbook.save('ColumnWidth.xlsx');
  /// workbook.dispose();
  /// ```
  set columnWidth(double value) {
    if (isSingleRange) {
      if (_columnObj == null) {
        if (worksheet.columns != null && worksheet.columns.contains(column)) {
          _columnObj = worksheet.columns.getColumn(column);
        } else {
          _columnObj = worksheet.columns.add();
          _columnObj.index = column;
        }
      }
      _columnObj.width = value;
    } else {
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        // ignore: prefer_final_locals
        for (int iCol = column, iLastCol = lastColumn;
            iCol <= iLastCol;
            iCol++) {
          worksheet.getRangeByIndex(iRow, iCol).columnWidth = value;
        }
      }
    }
  }

  /// Gets a <see cref='Range'/> object that represents the cells in the Range.Read-only.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// List<Range> cells = sheet.getRangeByName('A1').cells;
  /// for (Range range in cells)
  /// {
  ///       // Do some manipulations
  ///   }
  /// workbook.save('Cells.xlsx');
  /// workbook.dispose();
  /// ```
  List<Range> get cells {
    if (_cells == null && !_bCells) _infillCells();
    if (_cells == null) throw Exception('Null cells');
    return _cells;
  }

  void _setRange() {
    Row currRow;
    final RowCollection rows = worksheet.rows;
    if (rows[row] != null) {
      currRow = rows[row];
    } else {
      currRow = Row(worksheet);
      currRow.index = row;
      rows[row] = currRow;
    }
    currRow.ranges[column] = this;
  }

  /// Set number value to the range.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.setNumber(44);
  /// workbook.save('Number.xlsx');
  /// workbook.dispose();
  /// ```
  void setNumber(double number) {
    if (isSingleRange) {
      _number = number;
      type = CellType.number;
      _saveType = 'n';
      _setRange();
    } else {
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        // ignore: prefer_final_locals
        for (int iCol = column, iLastCol = lastColumn;
            iCol <= iLastCol;
            iCol++) {
          worksheet.getRangeByIndex(iRow, iCol).number = number;
        }
      }
    }
  }

  /// Set number value to the range.
  double _getNumber() {
    final double dValue = worksheet.getRangeByIndex(row, column).number;
    if (dValue == null) return dValue;
    // ignore: prefer_final_locals
    for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
      // ignore: prefer_final_locals
      for (int iCol = column, iLastCol = lastColumn; iCol <= iLastCol; iCol++) {
        if (dValue != worksheet.getRangeByIndex(iRow, iCol).number &&
            dValue == 0) return double.nan;
      }
    }
    return dValue;
  }

  /// Set text value to the range.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.setText('Hello');
  /// workbook.save('Text.xlsx');
  /// workbook.dispose();
  /// ```
  void setText(String text) {
    int sharedStringIndex = 0;
    if (workbook._sharedStrings != null &&
        workbook._sharedStrings.containsKey(text)) {
      sharedStringIndex = workbook._sharedStrings[text];
    } else {
      sharedStringIndex = workbook._sharedStrings.length;
      workbook._sharedStrings[text] = sharedStringIndex;
      workbook._sharedStringCount++;
    }
    if (isSingleRange) {
      _text = text;
      type = CellType.text;
      _saveType = 's';
      _textIndex = sharedStringIndex;
      _setRange();
    } else {
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        // ignore: prefer_final_locals
        for (int iCol = column, iLastCol = lastColumn;
            iCol <= iLastCol;
            iCol++) {
          worksheet.getRangeByIndex(iRow, iCol).text = text;
        }
      }
    }
  }

  /// Get text value to the range.
  String getText() {
    final String strValue = worksheet.getRangeByIndex(row, column).text;
    if (strValue == null) {
      return null;
    }
    // ignore: prefer_final_locals
    for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
      // ignore: prefer_final_locals
      for (int iCol = column, iLastCol = lastColumn; iCol <= iLastCol; iCol++) {
        if (strValue != worksheet.getRangeByIndex(iRow, iCol).text) return null;
      }
    }
    return strValue;
  }

  /// Get count of the present Range
  int get count {
    int tempCount = 0;
    // ignore: prefer_final_locals
    for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
      // ignore: prefer_final_locals
      for (int iCol = column, iLastCol = lastColumn; iCol <= iLastCol; iCol++) {
        tempCount++;
      }
    }
    return tempCount;
  }

  /// Set DateTime value to the range.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.setDateTime(DateTime(2011, 1, 20, 20, 37, 80));
  /// workbook.save('DateTime.xlsx');
  /// workbook.dispose();
  /// ```
  void setDateTime(DateTime dateTime) {
    if (_cellStyle == null) {
      _cellStyle = CellStyle(workbook);
      _cellStyle.numberFormatIndex = 14;
    }
    if (isSingleRange) {
      _number = _toOADate(dateTime);
      _dateTime = dateTime;
      type = CellType.dateTime;
      _cellStyle = _cellStyle;
      _saveType = 'n';
      _setRange();
    } else {
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        // ignore: prefer_final_locals
        for (int iCol = column, iLastCol = lastColumn;
            iCol <= iLastCol;
            iCol++) {
          worksheet.getRangeByIndex(iRow, iCol).dateTime = dateTime;
        }
      }
    }
  }

  /// Get Range Date time value.
  DateTime getDateTime() {
    final DateTime minimumDateValue = DateTime(0001, 1, 1, 0, 0, 0);
    Range range = worksheet.getRangeByIndex(row, column);
    final double dValue = range.number;

    if (dValue == null ||
        dValue == double.nan ||
        dValue < 0 ||
        range.type != CellType.dateTime) {
      return minimumDateValue;
    }

    final DateTime dateValue = range.dateTime;
    // ignore: prefer_final_locals
    for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
      // ignore: prefer_final_locals
      for (int iCol = column, iLastCol = lastColumn; iCol <= iLastCol; iCol++) {
        double dVal;
        range = worksheet.getRangeByIndex(iRow, iCol);
        dVal = range.number;

        if (dVal == null || dValue != dVal || range.type != CellType.dateTime) {
          return minimumDateValue;
        }
      }
    }
    return dateValue;
  }

  /// Set formula value to the range.
  void setFormula(String formula) {
    if (isSingleRange) {
      if (formula[0] != '=') formula = '=' + formula;
      _formula = formula;
      type = CellType.formula;
      _setRange();
    } else {
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        // ignore: prefer_final_locals
        for (int iCol = column, iLastCol = lastColumn;
            iCol <= iLastCol;
            iCol++) {
          worksheet.getRangeByIndex(iRow, iCol).formula = formula;
        }
      }
    }
  }

  /// Get formula value to the range.
  String getFormula() {
    final String strValue = worksheet.getRangeByIndex(row, column).formula;
    if (strValue == null) return strValue;
    // ignore: prefer_final_locals
    for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
      // ignore: prefer_final_locals
      for (int iCol = column, iLastCol = lastColumn; iCol <= iLastCol; iCol++) {
        if (strValue != worksheet.getRangeByIndex(iRow, iCol).formula) {
          return null;
        }
      }
    }
    return strValue;
  }

  /// Set value to the range.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.setValue('Hello World');
  /// workbook.save('value.xlsx');
  /// workbook.dispose();
  /// ```
  void setValue(Object value) {
    if (isSingleRange) {
      if (value is num) {
        setNumber(value.toDouble());
      } else if (value is DateTime) {
        setDateTime(value);
      } else if (value is String) {
        setText(value);
      } else {
        setText(value.toString());
      }
    } else {
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        // ignore: prefer_final_locals
        for (int iCol = column, iLastCol = lastColumn;
            iCol <= iLastCol;
            iCol++) {
          worksheet.getRangeByIndex(iRow, iCol).value = value;
        }
      }
    }
  }

  /// Set formula number value to the range.
  void _setFormulaNumberValue(double number) {
    _number = number;
  }

  /// Set formula string value to the range.
  void _setFormulaStringValue(String text) {
    _text = text;
    _saveType = 'str';
  }

  /// Set formula DateTime value to the range.
  void _setFormulaDateValue(DateTime dateTime) {
    _dateTime = dateTime;
    _number = _toOADate(dateTime);
    if (_cellStyle != null) {
      _cellStyle = CellStyle(workbook);
    }
    _cellStyle.numberFormatIndex = 14;
  }

  /// Set formula boolean value.
  void _setFormulaBooleanValue(String value) {
    if (value == 'TRUE') {
      _boolean = '1';
    } else {
      _boolean = '0';
    }
    _saveType = 'b';
  }

  /// Set formula error string value.
  void _setFormulaErrorStringValue(String eValue) {
    _errorValue = eValue.split(' ').toList().removeAt(1).toString();
    _saveType = 'e';
  }

  /// Get cell name from row and column.
  static String _getCellName(int row, int column) {
    return _getColumnName(column) + row.toString();
  }

  /// Get cell name from row and column.
  static String _getCellNameWithSymbol(int row, int column) {
    return _getColumnName(column) + '\$' + row.toString();
  }

  /// Get column name from column.
  static String _getColumnName(int col) {
    col--;
    String strColumnName = '';
    do {
      final int iCurrentDigit = col % 26;
      col = (col ~/ 26) - 1;
      strColumnName = String.fromCharCode(65 + iCurrentDigit) + strColumnName;
    } while (col >= 0);
    return strColumnName;
  }

  /// Check for escape sequence added string and removes it.
  String _checkAndGetDateUncustomizedString(String inputFormat) {
    bool removed = false;
    if ((inputFormat.contains(',') ||
            inputFormat.contains('.') ||
            inputFormat.contains(' ') ||
            inputFormat.contains('-')) &&
        (inputFormat.contains('d') ||
            inputFormat.contains('m') ||
            inputFormat.contains('y') ||
            inputFormat.contains('h') ||
            inputFormat.contains('s'))) {
      final int firstIndex = inputFormat.indexOf('\\');
      int lastIndex = inputFormat.lastIndexOf('\\');
      int count = inputFormat.length;
      for (int i = firstIndex; i <= lastIndex; i++) {
        if (i != 0 && i != count - 1) {
          if (inputFormat[i] == '\\' &&
              (inputFormat[i + 1] == ',' ||
                  inputFormat[i + 1] == '.' ||
                  inputFormat[i + 1] == ' ' ||
                  inputFormat[i + 1] == '-')) {
            inputFormat =
                inputFormat.substring(0, i) + inputFormat.substring(i + 1);
            count--;
            lastIndex--;
            removed = true;
          }
        }
      }
    }
    if (!removed) inputFormat = inputFormat.replaceAll('\\', '');
    return inputFormat;
  }

  /// Check for quotes added to format string.
  String _checkForAccountingString(String inputFormat) {
    if ((inputFormat.contains('\"'))) {
      final String currencySymbol =
          workbook.cultureInfo.numberFormat._currencySymbol;
      final int currencyIndex = inputFormat.indexOf(currencySymbol);
      if (currencyIndex != -1) {
        inputFormat = inputFormat.replaceAll(
            '\"' + currencySymbol + '\"', currencySymbol);
      }
    }
    return inputFormat;
  }

  /// Gets the display text.
  String getDisplayText(int row, int column) {
    final CellType valType = type;
    String displayText;
    switch (valType) {
      case CellType.blank:
        return '';
        break;
      case CellType.text:
        return text;
        break;
      case CellType.number:
      case CellType.dateTime:
        final double dValue = number;
        return _getNumberOrDateTime(_innerNumberFormat, dValue, row, column);
        break;
      case CellType.formula:
        final bool bUpdate = _updateNumberFormat();
        _updateCellValue(worksheet, column, row, true);
        _Format formatImpl;
        if (bUpdate) {
          formatImpl =
              worksheet.workbook.innerFormats[_cellStyle.numberFormatIndex];
        } else {
          formatImpl = _innerNumberFormat;
        }
        if (text != null) return text;
        if (number != null || dateTime != null) {
          return _getNumberOrDateTime(formatImpl, number, row, column);
        }
        break;
      default:
        break;
    }
    return displayText;
  }

  /// Gets the number or date time.
  String _getNumberOrDateTime(
      _Format formatImpl, double dValue, int row, int column) {
    String displayText = '';
    final ExcelFormatType formatType1 = formatImpl._getFormatTypeFromDouble(0);

    switch (formatType1) {
      case ExcelFormatType.number:
      case ExcelFormatType.general:
      case ExcelFormatType.text:
      case ExcelFormatType.unknown:
        if (dValue != double.nan) {
          if (displayText == '') {
            if (dValue == double.nan) {
              displayText = dValue.toString();
            } else if (dValue.isInfinite) {
              return '#DIV/0!';
            } else {
              final NumberFormat formatter =
                  NumberFormat(numberFormat, workbook._culture);
              String displayText = formatter.format(dValue);
              if (displayText.contains('\$') || displayText.endsWith('*')) {
                if (displayText.startsWith('_(')) {
                  displayText = displayText.replaceAll('*', '');
                }
                displayText = displayText.replaceAll('_(', '');
                displayText = displayText.replaceAll('_)', '');
                displayText = displayText.replaceAll('-??', '');
              }
              return displayText;
            }
          }
        }
        break;
      case ExcelFormatType.dateTime:
        if (displayText == '') {
          //dValue = GetCalculateOnOpen(dValue);
          dValue = number;
          if (dValue < 60) dValue++;
          if (dValue >
                  _toOADate(workbook
                      .cultureInfo.dateTimeFormat._maxSupportedDateTime) ||
              (dValue < 0)) {
            displayText = '######';
          } else {
            displayText = formatImpl._applyFormat(dValue, false, this);
          }
        }
        return displayText;
        break;
      default:
        break;
    }
    return displayText;
  }

  /// Update the cell value when calc engine is enabled.
  static void _updateCellValue(
      Worksheet worksheet, int column, int row, bool updateCellVaue) {
    if (worksheet.calcEngine != null && updateCellVaue) {
      final String cellRef = RangeInfo._getAlphaLabel(column) + row.toString();
      worksheet.calcEngine._pullUpdatedValue(cellRef);
    }
  }

  /// Updates the format for formula based display text.
  bool _updateNumberFormat() {
    final CalcEngine calcEngine = _worksheet.calcEngine;
    bool updated = false;
    if (numberFormat == _defaultGeneralFormat && formula != null) {
      final DateTimeFormatInfo dateTime =
          worksheet.workbook.cultureInfo.dateTimeFormat;
      final String formula = _getFormulaWithoutSymbol(this.formula);
      switch (formula) {
        case 'TIME':
          numberFormat = dateTime.shortTimePattern;
          updated = true;
          break;

        case 'DATE':
        case 'TODAY':
          numberFormat = dateTime.shortDatePattern;
          updated = true;
          break;

        case 'NOW':
          numberFormat =
              dateTime.shortDatePattern + ' ' + dateTime.shortTimePattern;
          updated = true;
          break;

        default:
          break;
      }
      if (calcEngine != null && !calcEngine.excelLikeComputations) {
        calcEngine.excelLikeComputations = true;
      }
    } else if (calcEngine != null && numberFormat != _defaultGeneralFormat) {
      calcEngine.excelLikeComputations = false;
    }
    return updated;
  }

  /// Returns the formula function name.
  static String _getFormulaWithoutSymbol(String formula) {
    if (formula != null) {
      formula = formula.replaceAll(_defaultEquivalent, _defaultEmptyDigit);
      formula = formula.trim();
      final int position = formula.indexOf(_defaultOpenBrace);
      if (position > 0) formula = formula.substring(0, position);
    }
    return formula;
  }

  /// Convert date to tricks value.
  static int _dateToTicks(int year, int month, int day) {
    final ticksPerDay = 10000 * 1000 * 60 * 60 * 24;
    final daysToMonth365 = [
      0,
      31,
      59,
      90,
      120,
      151,
      181,
      212,
      243,
      273,
      304,
      334,
      365
    ];
    final daysToMonth366 = [
      0,
      31,
      60,
      91,
      121,
      152,
      182,
      213,
      244,
      274,
      305,
      335,
      366
    ];
    if (year >= 1 && year <= 9999 && month >= 1 && month <= 12) {
      final days = _isLeapYear(year) ? daysToMonth366 : daysToMonth365;
      final y = year - 1;
      final n = y * 365 +
          ((y ~/ 4) | 0) -
          ((y ~/ 100) | 0) +
          ((y ~/ 400) | 0) +
          days[month - 1] +
          day -
          1;
      return n * ticksPerDay;
    }
    throw Exception('Not a valid date');
  }

  /// Convert time to tricks value.
  static int _timeToTicks(int hour, int minute, int second) {
    if (hour >= 0 &&
        hour < 24 &&
        minute >= 0 &&
        minute < 60 &&
        second >= 0 &&
        second < 60) {
      final totalSeconds = hour * 3600 + minute * 60 + second;
      return totalSeconds * 10000 * 1000;
    }
    throw Exception('Not valid time');
  }

  /// Check if the year is leap or not.
  static bool _isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  /// Convert date to OA value.
  static double _toOADate(DateTime date) {
    var ticks = 0;
    ticks = _dateToTicks(date.year, (date.month), date.day) +
        _timeToTicks(date.hour, date.minute, date.second);
    if (ticks == 0) {
      return 0.0;
    }
    final ticksPerDay = 10000 * 1000 * 60 * 60 * 24;
    final daysTo1899 = (((365 * 4 + 1) * 25 - 1) * 4 + 1) * 4 +
        ((365 * 4 + 1) * 25 - 1) * 3 -
        367;
    final doubleDateOffset = daysTo1899 * ticksPerDay;
    final oaDateMinAsTicks = (((365 * 4 + 1) * 25 - 1) - 365) * ticksPerDay;
    if (ticks < oaDateMinAsTicks) {
      throw Exception('Arg_OleAutDateInvalid');
    }
    final millisPerDay = 1000 * 60 * 60 * 24;
    return ((ticks - doubleDateOffset) / 10000) / millisPerDay;
  }

  /// Returns a DateTime equivalent to the specified OLE Automation Date.
  static DateTime _fromOADate(double doubleOLEValue) {
    if (doubleOLEValue < -657435.0 || doubleOLEValue > 2958465.99999999) {
      throw Exception('Not an valid OLE value.');
    }

    final double doubleSecondsPerDay = (24 * 60 * 60).toDouble();
    final double mantisaPart = doubleOLEValue % 1;

    final int integralPart = (doubleOLEValue - mantisaPart).toInt();
    final int totalMilliseconds =
        (mantisaPart * doubleSecondsPerDay * 1000).toInt();
    final DateTime minOLEDate = DateTime.parse('1899-12-30 00:00:00');
    DateTime oleDateFromValue = minOLEDate.add(Duration(days: integralPart));
    oleDateFromValue =
        oleDateFromValue.add(Duration(milliseconds: totalMilliseconds));
    return oleDateFromValue;
  }

  /// Set built-in-style.
  void setBuiltInStyle(BuiltInStyles value) {
    _styleName = value.toString().split('.').toList().removeAt(1).toString();
    final CellStyle globalStyle = workbook.styles.add(_styleName);
    if (isSingleRange) {
      _cellStyle = globalStyle;
      _setRange();
    } else {
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        // ignore: prefer_final_locals
        for (int iCol = column, iLastCol = lastColumn;
            iCol <= iLastCol;
            iCol++) {
          worksheet.getRangeByIndex(iRow, iCol).cellStyle = globalStyle;
        }
      }
    }
  }

  /// Set Merge
  /// Combines the contents of the selected cells in a new larger cell.
  ///
  /// ```dart
  ///  Workbook workbook = new Workbook();
  ///  Worksheet sheet = workbook.worksheets[0];
  ///  Range range1 = sheet.getRangeByName('A1:D4');
  ///  //Merging cells
  ///  range1.merge();
  ///  workbook.save('Merge.xlsx');
  ///  workbook.dispose();
  /// ```
  void merge() {
    if (isSingleRange) {
      return;
    } else {
      int countRow = 0;
      int countCol = 0;
      // ignore: prefer_final_locals
      for (int iRow = row, iLastRow = lastRow; iRow <= iLastRow; iRow++) {
        countRow = countRow + 1;
      }
      // ignore: prefer_final_locals
      for (int iCol = column, iLastCol = lastColumn; iCol <= iLastCol; iCol++) {
        countCol = countCol + 1;
      }
      final Range range = worksheet.getRangeByIndex(row, column);
      range.rowSpan = countRow;
      range.columnSpan = countCol;
    }
  }

  /// Separates merged cells into individual cells.
  ///
  /// ```dart
  ///  Workbook workbook = new Workbook();
  ///  Worksheet sheet = workbook.worksheets[0];
  ///  Range range1 = sheet.getRangeByName('A1:D4');
  ///  //Merging cells
  ///  range1.unmerge();
  ///  workbook.save('UnMerge.xlsx');
  ///  workbook.dispose();
  /// ```
  void unmerge() {
    if (isSingleRange) {
      return;
    } else {
      final Range range = worksheet.getRangeByIndex(row, column);
      range.rowSpan = 0;
      range.columnSpan = 0;
    }
  }

  /// Fill internal collection by references on cells.
  void _infillCells() {
    if (!_bCells) {
      _cells = [];

      if (row > 0 && column > 0) {
        final int iLastRow = lastRow;
        for (int iRow = row; iRow <= iLastRow; iRow++) {
          final int iLastCol = lastColumn;
          for (int iCol = column; iCol <= iLastCol; iCol++) {
            _cells.add(worksheet.getRangeByIndex(iRow, iCol));
          }
        }
      }
      _bCells = true;
    }
  }

  /// Releases the unmanaged resources used by the XmlReader and optionally releases the managed resources.
  void _clear() {
    if (_cellStyle != null) {
      (_cellStyle as CellStyle)._clear();
      _cellStyle = null;
    }
  }
}
