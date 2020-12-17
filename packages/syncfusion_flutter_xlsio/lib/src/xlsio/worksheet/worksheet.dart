part of xlsio;

/// Represents a worksheet in a workbook.
class Worksheet {
  /// Creates an instance of Worksheet.
  Worksheet(Workbook workbook) {
    _book = workbook;
  }

  /// set summary row below
  final bool _isSummaryRowBelow = true;

  /// Represent the worksheet index.
  int index;

  /// Represents Worksheet's name.
  String _name;

  /// Standard column width.
  final double _standardWidth = 8.43;

  /// Standard column width.
  final double _standardHeight = 12.5;

  /// Default character (for width measuring).
  final String _defaultStandardChar = '0';

  /// Maximum row height in points.
  final double _defaultMaxHeight = 409.5;

  /// One degree in radians.
  final double _defaultAxeInRadians = pi / 180;

  /// Represents indent width.
  final int _defaultIndentWidth = 12;

  /// Represent the hyperlink relation id
  final List<String> _hyperlinkRelationId = [];

  /// Represents auto fit manager.
  _AutoFitManager get _autoFitManager {
    final autoFit = _AutoFitManager._withSheet(this);
    return autoFit;
  }

  /// Sets the grid line visible.
  /// True if grid lines are visible. otherwise, False.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// sheet.showGridlines = false;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Gridline.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  bool showGridlines = true;

  /// Collection of all pictures in the current worksheet.
  PicturesCollection _pictures;

  /// Collection of all pictures in the current worksheet.
  RowCollection _rows;

  /// Represents all the columns in the specified worksheet.
  ColumnCollection _columns;

  /// Sets a Chart helper in the worksheet.
  ///
  /// ```dart
  /// Workbook workbook = Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// ChartCollection charts = ChartCollection(sheet);
  /// charts.add();
  /// sheet.charts = charts;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ExcelEmptyChart.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ChartHelper charts;

  /// Represents the chart count in the workbook.
  int chartCount = 0;

  // Parent workbook
  Workbook _book;

  /// Gets or sets the a CalcEngine object.
  CalcEngine calcEngine;

  ///Collection of all merged cells in the current worksheet.
  MergedCellCollection _mergeCells;

  /// Collection of all hyperlinks in the current worksheet.
  HyperlinkCollection _hyperlinks;

  /// Represents parent workbook.
  Workbook get workbook {
    return _book;
  }

  /// Represents all the columns in the specified worksheet.
  ///
  /// ```dart
  /// Workbook workbook = Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Column col = sheet.columns.add();
  /// col.width = 25;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ExcelColumns.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  ColumnCollection get columns {
    _columns ??= ColumnCollection(this);
    return _columns;
  }

  /// Returns or sets the name of the worksheet.
  ///
  /// ```dart
  /// Workbook workbook = Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// sheet.name = 'MySheet';
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ExcelSheetName.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  String get name {
    if (_name == null || _name == '') {
      _name = 'Sheet' + (index).toString();
    }
    return _name;
  }

  set name(String value) {
    _name = value;
  }

  /// Gets/Sets a merged cell collections in the worksheet.
  MergedCellCollection get mergeCells {
    _mergeCells ??= MergedCellCollection();
    return _mergeCells;
  }

  set mergeCells(MergedCellCollection value) {
    _mergeCells = value;
  }

  /// Gets/Sets a pictures collections in the worksheet.
  PicturesCollection get pictures {
    _pictures ??= PicturesCollection(this);
    return _pictures;
  }

  /// Gets/Sets a hyperlink collections in the worksheet.
  HyperlinkCollection get hyperlinks {
    _hyperlinks ??= HyperlinkCollection(this);
    return _hyperlinks;
  }

  /// Gets/Sets a rows collections in the worksheet.
  ///
  /// ```dart
  /// Workbook workbook = Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// Row row = sheet.rows.add();
  /// row.height = 25;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ExcelRows.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  RowCollection get rows {
    _rows ??= RowCollection(this);
    return _rows;
  }

  /// Checks if specified cell has correct row and column index.
  void checkRange(int row, int column) {
    if (row < 1 ||
        row > workbook._maxRowCount ||
        column < 1 ||
        column > workbook._maxColumnCount) {
      throw Exception(
          'Specified argument was out of the range of valid values.');
    }
  }

  /// Get range by index value.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByIndex(1, 1, 2, 2);
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Range.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  Range getRangeByIndex(int rowIndex, int columnIndex,
      [int lastRowIndex = -1, int lastColumnIndex = -1]) {
    checkRange(rowIndex, columnIndex);
    if (lastRowIndex != -1 && lastColumnIndex != -1) {
      checkRange(lastRowIndex, lastColumnIndex);
    }

    Range range;
    if ((rowIndex == lastRowIndex && columnIndex == lastColumnIndex) ||
        (lastRowIndex == -1 && lastColumnIndex == -1)) {
      range = _getRangeFromSheet(rowIndex, columnIndex);
      if (range == null) {
        range = Range(this);
        range.row = rowIndex;
        range.column = range._index = columnIndex;
      }
      range.lastRow = rowIndex;
      range.lastColumn = columnIndex;
    } else {
      range = Range(this);
      range.row = rowIndex;
      range.column = range._index = columnIndex;
      range.lastRow = lastRowIndex;
      range.lastColumn = lastColumnIndex;
    }
    return range;
  }

  /// Get range by Name.
  ///
  /// ```dart
  /// Workbook workbook =  Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1:D4');
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Range.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  Range getRangeByName(String cellReference) {
    if (cellReference == '') {
      throw Exception('cellReference should not be null');
    } else if (cellReference.length < 2) {
      throw Exception('cellReference cannot be less then 2 symbols');
    } else if (cellReference == null) {
      throw 'cellReference - Value cannot be null.';
    } else if (cellReference.isEmpty) {
      throw ('cellReference - Value cannot be empty.');
    }
    final cells = cellReference.split(':');
    int firstRow, lastRow = 0;
    int firstColumn, lastColumn = 0;
    // ignore: prefer_final_locals
    for (int i = 0, len = cells.length; i < len; i++) {
      final String cellReference = cells[i];
      int iLetterStart = -1;
      int iLetterCount = 0;
      int iDigitStart = -1;
      // ignore: prefer_final_locals
      for (int j = 0, len = cellReference.length; j < len; j++) {
        final String ch = cellReference[j];
        if (_isNumeric(ch)) {
          if (iDigitStart < 0) iDigitStart = j;
        } else if (!_isNumeric(ch)) {
          if (iLetterStart < 0) iLetterStart = j;

          iLetterCount++;
        }
      }
      if (iDigitStart == -1) {
        iDigitStart = 1;
      }
      if (iLetterStart == -1) {
        iLetterStart = 0;
      }
      if (cellReference.length < 2) {
        throw ('cellReference - name cannot be less then 2 symbols.');
      }

      final String strNumber = cellReference.substring(iDigitStart);
      final String strAlpha =
          cellReference.substring(iLetterStart, iLetterCount);

      if (i == 0) {
        firstRow = lastRow = int.parse(strNumber);
        firstColumn = lastColumn = getColumnIndex(strAlpha);
      } else if (i == 1) {
        lastRow = int.parse(strNumber);
        lastColumn = getColumnIndex(strAlpha);
      }
    }
    return getRangeByIndex(firstRow, firstColumn, lastRow, lastColumn);
  }

  /// Convert seconds into minute and minutes into hour.
  static String _convertSecondsMinutesToHours(String value, double dNumber) {
    bool isDateValue = false;
    if ((dNumber % 1) == 0) isDateValue = true;
    final CultureInfo currentCulture = CultureInfo.currentCulture;
    if (!isDateValue &&
        (dNumber > -657435.0) &&
        (dNumber < 2958465.99999999) &&
        Range._fromOADate(dNumber).millisecond >
            _SecondToken._defaultMilliSecondHalf) {
      final String decimalSeparator =
          currentCulture.numberFormat.numberDecimalSeparator;
      final RegExp regex = RegExp('([0-9]*:[0-9]*:[0-9]*\"' +
          decimalSeparator +
          '[0-9]*' +
          '|[0-9]*:[0-9]*:[0-9]*|[0-9]*:[0-9]*\"' +
          decimalSeparator +
          '[0-9]*|[0-9]*:[0-9]*)');
      final matches = regex.allMatches(value);
      for (final Match match in matches) {
        final String semiColon = currentCulture.dateTimeFormat.timeSeparator;
        final String valueFormat = _SecondToken._defaultFormatLong;
        final List<String> timeValues =
            match.pattern.toString().split(semiColon.toString());
        final int minutesValue = Range._fromOADate(dNumber).minute;
        String updatedValue = timeValues[0];
        int updateMinutesValue = 0;
        switch (timeValues.length) {
          case 2:
            updateMinutesValue = minutesValue + 1;
            if (updateMinutesValue == 60) {
              updatedValue = (int.parse(timeValues[0]) + 1).toString();
              // .toString(valueFormat);
              updatedValue = updatedValue +
                  semiColon +
                  (timeValues[timeValues.length - 1]).replaceAll(
                      timeValues[timeValues.length - 1].toString(),
                      valueFormat);
              value = value.replaceAll(match.pattern.toString(), updatedValue);
            }
            break;
          case 3:
            final int secondsValue = Range._fromOADate(dNumber).second;
            final int updatedSecondsValue = secondsValue +
                (timeValues[timeValues.length - 1].contains(decimalSeparator)
                    ? 0
                    : 1);
            if (updatedSecondsValue == 60) {
              updateMinutesValue = minutesValue + 1;
              if (updateMinutesValue == 60) {
                updatedValue = (int.parse(timeValues[0]) + 1).toString();
                // .toString(valueFormat);
                updatedValue = updatedValue +
                    semiColon +
                    valueFormat +
                    semiColon +
                    timeValues[timeValues.length - 1]
                        .replaceAll(secondsValue.toString(), valueFormat);
              } else {
                updatedValue = timeValues[0] +
                    semiColon +
                    updateMinutesValue.toString() +
                    // .toString(valueFormat)
                    semiColon +
                    timeValues[timeValues.length - 1]
                        .replaceAll(secondsValue.toString(), valueFormat);
              }
            } else {
              updatedValue = timeValues[0] +
                  semiColon +
                  timeValues[1] +
                  semiColon +
                  timeValues[timeValues.length - 1].replaceAll(
                      secondsValue.toString(), updatedSecondsValue.toString());
            }
            value = value.replaceAll(match.pattern.toString(), updatedValue);
            break;
        }
      }
    }
    return value;
  }

  /// Check the string is Numeric or Not.
  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  /// Converts column name into index.
  int getColumnIndex(String columnName) {
    if (columnName == null) throw 'columnName - Value cannot be null.';

    if (columnName.isEmpty) {
      throw ('columnName - name cannot be less then 1 symbols.');
    }

    int iColumn = 0;

    // ignore: prefer_final_locals
    for (int i = 0, len = columnName.length; i < len; i++) {
      final String currentChar = columnName[i];
      iColumn *= 26;
      iColumn += 1 +
          ((currentChar.codeUnitAt(0) >= 'a'.codeUnitAt(0))
              ? (currentChar.codeUnitAt(0) - 'a'.codeUnitAt(0))
              : (currentChar.codeUnitAt(0) - 'A'.codeUnitAt(0)));
    }
    if (iColumn < 0) iColumn = -iColumn;
    return iColumn;
  }

  /// Enables the calculation support.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook(1);
  /// Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByIndex(1, 1).number = 10;
  /// Range range1 = sheet.getRangeByIndex(1, 2);
  /// range1.formula = '=A1';
  /// sheet.enableSheetCalculations();
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Formulas.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  void enableSheetCalculations() {
    _book._enabledCalcEngine = true;
    if (calcEngine == null) {
      CalcEngine.parseArgumentSeparator =
          _book._getCultureInfo().textInfo.argumentSeparator;
      CalcEngine.parseDecimalSeparator =
          _book._getCultureInfo().numberFormat.numberDecimalSeparator;

      calcEngine = CalcEngine(this);
      calcEngine.useDatesInCalculations = true;
      calcEngine.useNoAmpersandQuotes = true;

      final int sheetFamilyID = CalcEngine.createSheetFamilyID();

      //register the sheet names with calculate
      for (final Worksheet sheet in workbook.worksheets.innerList) {
        if (sheet.calcEngine == null) {
          sheet.calcEngine = CalcEngine(sheet);
          sheet.calcEngine.useDatesInCalculations = true;
          sheet.calcEngine.useNoAmpersandQuotes = true;
          sheet.calcEngine.excelLikeComputations = true;
        }
        if (CalcEngine._modelToSheetID != null &&
            (CalcEngine._modelToSheetID.containsKey(sheet))) {
          CalcEngine._modelToSheetID.remove(sheet);
        }
        sheet.calcEngine._registerGridAsSheet(sheet.name, sheet, sheetFamilyID);
      }
    }
  }

  /// get range from row and column from worksheet.
  Range _getRangeFromSheet(int row, int column) {
    if (row < rows.count &&
        rows[row] != null &&
        column < rows[row].ranges.count) {
      return rows[row].ranges[column];
    }
    return null;
  }

  /// Get the value from the specified cell.
  Object _getValueRowCol(int iRow, int iColumn) {
    final Range range = getRangeByIndex(iRow, iColumn);
    if (range.formula != null) {
      return range.formula;
    } else if (range.text != null) {
      return range.text;
    } else if (range.dateTime != null) {
      return range.dateTime;
    } else if (range.number != null) return range.number;
    return '';
  }

  /// Sets value for the specified cell.
  void _setValueRowCol(String value, int iRow, int iColumn) {
    if (value == null) throw Exception('null value');
    final Range range = getRangeByIndex(iRow, iColumn);
    final CellType valType = range.type;
    if (value.isNotEmpty && value[0] == '=') {
      range.setFormula(value.substring(1));
    } else {
      final CultureInfo cultureInfo = _book._getCultureInfo();
      final double doubleValue = double.tryParse(value);
      final DateTime dateValue = DateTime.tryParse(value);
      final bool bDateTime =
          !value.contains(cultureInfo.dateTimeFormat.dateSeparator) &&
              dateValue != null;
      bool isNumber = doubleValue != null;
      bool isboolean = false;
      bool iserrorStrings = false;
      bool istext = false;

      if (value == 'TRUE' || value == 'FALSE') {
        isboolean = true;
      } else if (value == 'Exception: #N/A' ||
          value == 'Exception: #VALUE!' ||
          value == 'Exception: #REF!' ||
          value == 'Exception: #DIV/0!' ||
          value == 'Exception: #NUM!' ||
          value == 'Exception: #NAME?' ||
          value == 'Exception: #NULL!') {
        iserrorStrings = true;
      } else if (isNumber) {
        // Checks whether the decimal and group separator at correct position.
        isNumber = _checkIsNumber(value, cultureInfo);
      }

      if (value != null &&
          value.isNotEmpty &&
          calcEngine._formulaErrorStrings.contains(value)) {
        istext = true;
      }

      if (valType == CellType.formula) {
        if (isNumber && !bDateTime) {
          range._setFormulaNumberValue(doubleValue);
        } else if (bDateTime) {
          range._setFormulaDateValue(dateValue);
        } else if (isboolean) {
          range._setFormulaBooleanValue(value);
        } else if (iserrorStrings) {
          range._setFormulaErrorStringValue(value);
        } else if (value.contains('Exception:', 0) || istext) {
          range.setText(value);
        } else {
          range._setFormulaStringValue(value);
        }
      } else {
        if (isNumber && !bDateTime) {
          range.setNumber(doubleValue);
        } else if (bDateTime) {
          range.setDateTime(dateValue);
        } else {
          range.setText(value);
        }
      }
    }
  }

  /// Checks whether the value is number or not.
  bool _checkIsNumber(String value, CultureInfo cultureInfo) {
    bool isNumber = true;
    if (value.contains(cultureInfo.numberFormat.numberDecimalSeparator)) {
      RegExp decimalSepRegex =
          RegExp('[' + cultureInfo.numberFormat.numberDecimalSeparator + ']');
      final List<RegExpMatch> decimalSepMatches =
          decimalSepRegex.allMatches(value).toList();
      //Checks whether the value has more than one decimal point.
      if (decimalSepMatches.length > 1) {
        decimalSepRegex = null;
        return false;
      } // Checks group separator before and after the decimal point.
      else if (value.contains(cultureInfo.numberFormat.numberGroupSeparator)) {
        final int decimalIndex =
            value.indexOf(cultureInfo.numberFormat.numberDecimalSeparator);
        final String beforeDecimalValue = value.substring(0, decimalIndex);
        final String afterDecimalValue =
            value.substring(decimalIndex + 1, value.length - 1 - decimalIndex);

        if (afterDecimalValue
            .contains(cultureInfo.numberFormat.numberGroupSeparator)) {
          return false;
        } else {
          isNumber =
              _checkGroupSeparatorPosition(beforeDecimalValue, cultureInfo);
        }
      }
    } else {
      isNumber = _checkGroupSeparatorPosition(value, cultureInfo);
    }

    return isNumber;
  }

  /// Checks whether the value has group separator in curret position to detect as number.
  bool _checkGroupSeparatorPosition(String value, CultureInfo cultureInfo) {
    value = value.trimRight();
    String revStr = '';
    for (int i = value.length - 1; i >= 0; i--) {
      revStr = revStr + value[i];
    }

    RegExp groupSepRegex =
        RegExp('[' + cultureInfo.numberFormat.numberGroupSeparator + ']');
    final List<RegExpMatch> groupSepMatches =
        groupSepRegex.allMatches(value).toList();

    int index = 0;
    while (index < groupSepMatches.length) {
      //Checks whether the group separator at third digit.
      if ((groupSepMatches[index].start - index) % 3 != 0) {
        groupSepRegex = null;
        return false;
      }
      index++;
    }
    groupSepRegex = null;
    return true;
  }

  /// Get the index of the first row in UsedRange.
  int getFirstRow() {
    for (final Row row in rows.innerList) {
      if (row != null) {
        return row.index;
      }
    }
    return -1;
  }

  /// get the index of the last row in UsedRange.
  int getLastRow() {
    int lastRow = -1;
    for (final Row row in rows.innerList) {
      if (row != null && lastRow < row.index) {
        lastRow = row.index;
      }
    }
    return lastRow;
  }

  /// This API supports the .NET Framework infrastructure and is not intended to be used directly from your code.
  // ignore: unused_element
  int _getRowCount() {
    return rows.count;
  }

  /// Gets the first column index.
  int getFirstColumn() {
    final int firstRow = getFirstRow();
    if (firstRow != -1) {
      int firstCol = rows[firstRow].index;
      for (int i = firstRow + 1; i < rows.count; i++) {
        final Row row = rows[i];
        if (row != null) {
          for (final Range cell in row.ranges.innerList) {
            if (cell != null && firstCol > cell._index) {
              firstCol = cell._index;
            }
          }
        }
      }
      return firstCol;
    }
    return -1;
  }

  /// Gets the last column index / column count.
  int getLastColumn() {
    final int firstRow = getFirstRow();
    if (firstRow != -1) {
      int firstCol = rows[firstRow].index;
      for (int i = firstRow; i < rows.count; i++) {
        final Row row = rows[i];
        if (row != null) {
          for (final Range cell in row.ranges.innerList) {
            if (cell != null && firstCol < cell._index) {
              firstCol = cell._index;
            }
          }
        }
      }
      return firstCol;
    }
    return -1;
  }

  /// Changes the width of the specified column to achieve the best fit.
  void autoFitColumn(int colIndex) {
    final Range range = getRangeByIndex(
        getFirstRow(), getFirstColumn(), getLastRow(), getLastColumn());
    range._autoFitToColumn(colIndex, colIndex);
  }

  /// Changes the height of the specified row to achieve the best fit.
  void autoFitRow(int rowIndex) {
    final int iFirstColumn = getFirstColumn();
    final int iLastColumn = getLastColumn();
    _autoFitToRow(rowIndex, iFirstColumn, iLastColumn);
  }

  /// Returns the width of the specified column.
  double getColumnWidth(int iColumnIndex) {
    if (iColumnIndex < 1 || iColumnIndex > _book._maxColumnCount) {
      throw Exception(
          'Value cannot be less 1 and greater than max column index.');
    }
    return _innerGetColumnWidth(iColumnIndex);
  }

  /// Returns the height of the specified row.
  double getRowHeight(int iRow) {
    return _innerGetRowHeight(iRow, true);
  }

  /// Returns height from RowRecord if there is a corresponding Row.
  double _innerGetRowHeight(int iRow, bool bRaiseEvents) {
    if (iRow < 1 || iRow > _book._maxRowCount) {
      throw Exception('Value cannot be less 1 and greater than max row index.');
    }
    Row row = rows[iRow];
    if (rows[iRow] == null) {
      row = Row(this);
      row.index = iRow;
      rows[iRow] = row;
    }

    bool hasMaxHeight = false;
    bool hasRotation = false;

    if (row != null) {
      final int firstColumn = getFirstColumn();
      final lastColumn = getLastColumn();
      final Range rowRange =
          getRangeByIndex(iRow, firstColumn, iRow, lastColumn);

      if (firstColumn > 0 &&
              lastColumn > 0 &&
              (_standardHeight == row.height &&
                  !(rowRange.cellStyle.rotation > 0)) ||
          (rowRange.cellStyle.wrapText &&
              !(rowRange.columnSpan != 0 &&
                  rowRange.columnSpan == lastColumn - firstColumn))) {
        return row.height;
      } else if (row.height == 0) {
        return _standardHeight;
      } else if (firstColumn <= _book._maxColumnCount &&
          lastColumn <= _book._maxColumnCount) {
        final double standardFontSize = _book._standardFontSize;
        for (final Range migrantCell in row.ranges.innerList) {
          if (migrantCell != null) {
            final Style style = migrantCell.cellStyle;
            final double fontSize = style.fontSize;
            final String fontName = style.fontName;
            if (migrantCell.rowSpan == 0) {
              if (!hasRotation &&
                  style.rotation > 0 &&
                  migrantCell.columnSpan == 0 &&
                  row.height == 0) {
                hasMaxHeight = true;
                hasRotation = true;
                _autoFitToRow(iRow, firstColumn, lastColumn);
                break;
              }
              if (fontSize > standardFontSize ||
                  fontName != _book._standardFont ||
                  style.rotation > 0) {
                hasMaxHeight = true;
                if (row.height == _standardHeight) {
                  _autoFitToRow(iRow, firstColumn, lastColumn);
                } else if ((fontName != _book._standardFont) &&
                    !(fontSize > standardFontSize || (style.rotation) > 0)) {
                  if (row.height - _standardHeight > 5) {
                    _autoFitToRow(iRow, firstColumn, lastColumn);
                  }
                }
                break;
              }
            }
          }
        }
      }
    }

    if (hasMaxHeight) {
      return row.height;
    } else {
      return _standardHeight;
    }
  }

  /// Autofits row by checking only the cells in the row that are specified by column range.
  void _autoFitToRow(int rowIndex, int firstColumn, int lastColumn) {
    if (firstColumn == 0 || lastColumn == 0 || firstColumn > lastColumn) {
      return;
    }

    final _SizeF maxSize = _SizeF(0, 0);
    _SizeF curSize;
    bool hasRotation = false;
    bool isMergedAndWrapped = false;
    for (int j = firstColumn; j <= lastColumn; j++) {
      if (rows[rowIndex] == null || rows[rowIndex]._ranges[j] == null) {
        continue;
      }
      final Range range = getRangeByIndex(rowIndex, j);
      if (range._rowSpan > 1) {
        continue;
      }
      final List result = _measureCell(range, true, false, isMergedAndWrapped);
      curSize = result[0];
      isMergedAndWrapped = result[1];
      if (maxSize._height < curSize._height &&
          !(range.number != null &&
              _book._standardFontSize == range.cellStyle.fontSize)) {
        maxSize._height = curSize._height;
      }
      if (range.cellStyle.rotation > 0 &&
          maxSize._height < curSize._width &&
          !range._isMerged &&
          !range.cellStyle.wrapText) {
        maxSize._height = curSize._width;
        hasRotation = true;
      }
    }

    if (maxSize._height == 0) {
      maxSize._height =
          _book._measureString(_defaultStandardChar, _book.fonts[0])._height;
    }

    double newHeight;
    if (!hasRotation) {
      newHeight = _book._convertFromPixel(maxSize._height, 6);
    } else {
      newHeight = _book._convertFromPixel(maxSize._height + _standardWidth, 6);
    }

    if (newHeight > _defaultMaxHeight) {
      newHeight = _defaultMaxHeight;
    }

    final Range range = getRangeByIndex(rowIndex, firstColumn);
    if (newHeight > _standardHeight) {
      range._setRowHeight(newHeight, isMergedAndWrapped);
    } else {
      range._setRowHeight(_standardHeight, isMergedAndWrapped);
    }
  }

  /// Sets inner row height.
  void _innerSetRowHeight(
      int iRowIndex, double value, bool bIsBadFontHeight, int units) {
    value = _book._convertUnits(value, units, 6);

    Row rowObj = rows[iRowIndex];
    if (rows[iRowIndex] == null) {
      rowObj = Row(this);
      rowObj.index = iRowIndex;
      rows[iRowIndex] = rowObj;
    }
    if (rowObj.height != value) {
      rowObj.height = value;
    }
  }

  /// Gets size of string that contain cell found by cellindex.
  List _measureCell(Range range, bool bAutoFitRows, bool ignoreRotation,
      bool bIsMergedAndWrapped) {
    final int iColumn = range.column;
    bool isMerged = false;
    final String strText = range.text;

    if (strText == null || strText.isEmpty) {
      bIsMergedAndWrapped = false;
      return [_SizeF(0, 0), bIsMergedAndWrapped];
    }

    if (range.rowSpan != 0 || range.columnSpan != 0) {
      isMerged = true;
    }

    final CellStyle format = range.cellStyle;
    final Font font = Font();
    font.name = format.fontName;
    font.size = format.fontSize;
    final int rotation = format.rotation;
    _SizeF curSize = _book._measureStringSpecial(strText, font);

    if (bAutoFitRows) {
      final double indentLevel = format.indent.toDouble();
      double colWidth = _getColumnWidthInPixels(iColumn).toDouble();
      double defWidth = 0;
      if (indentLevel > 0 || rotation == 255) {
        final Font fontStyle =
            Font._withNameSize(format.fontName, format.fontSize);
        final Rectangle rectF = Rectangle(0, 0, 1800, 100);
        defWidth =
            ((_book._getMeasuredRectangle('0', fontStyle, rectF).width + 0.05));

        if (rotation == 255) {
          defWidth += _standardWidth;
        }
        final double indentWidth = indentLevel * defWidth;
        if (indentWidth < colWidth) {
          colWidth -= indentWidth;
        } else {
          colWidth = defWidth;
        }
      }
      if ((!isMerged) &&
          format.wrapText &&
          !((range.number == null &&
                  range.text == null &&
                  range.formula == null) &&
              workbook._standardFontSize != format.fontSize)) {
        final double value = _autoFitManager._calculateWrappedCell(
            format, strText, colWidth.toInt());
        if (range.number != null) {
          curSize._width = value;
        } else {
          curSize._height = value;
        }
      }
      if (format.wrapText && rotation > 0) {
        ignoreRotation = true;
      }

      if (!ignoreRotation && !isMerged && rotation > 0) {
        if ((rotation == 90 || rotation == 180)) {
          if (range != null) {}
        } else if (rotation == 255) {
          curSize._width = (_book._convertToPixels(
                  _autoFitManager
                      ._calculateWrappedCell(format, strText, defWidth.toInt())
                      .toDouble(),
                  6) -
              defWidth);
        } else {
          curSize._width =
              _updateTextWidthOrHeightByRotation(curSize, rotation, false);
        }
      }
    } else {
      curSize = _updateAutofitByIndent(curSize, format);

      if (!ignoreRotation) {
        curSize._width =
            _updateTextWidthOrHeightByRotation(curSize, rotation, false);
      }
    }
    bIsMergedAndWrapped = isMerged && format.wrapText;

    return [curSize, bIsMergedAndWrapped];
  }

  /// Updates indent size.
  _SizeF _updateAutofitByIndent(_SizeF curSize, Style format) {
    if (format == null) throw Exception('format');

    final bool bFlag =
        format.hAlign != HAlignType.left && format.hAlign != HAlignType.right;

    if (bFlag && format.rotation != 0 && format.indent == 0) {
      return curSize;
    }

    curSize._width += format.indent * _defaultIndentWidth;

    return curSize;
  }

  /// Updates text width by rotation.
  double _updateTextWidthOrHeightByRotation(
      _SizeF size, int rotation, bool bUpdateHeight) {
    if (rotation == 0) {
      return bUpdateHeight ? size._height : size._width;
    }

    if (rotation == 90 || rotation == 180) {
      return bUpdateHeight ? size._width : size._height;
    }

    if (rotation > 90) rotation -= 90;

    if (bUpdateHeight) rotation = 90 - rotation;

    final double fPart = sin(_defaultAxeInRadians * rotation) * size._height;
    final double fResult = cos(_defaultAxeInRadians * rotation) * size._width;

    return fResult + fPart;
  }

  /// This API supports the .NET Framework infrastructure and is not intended to be used directly from your code.
  // ignore: unused_element
  int _getColumnCount() {
    return getLastColumn() - getFirstColumn();
  }

  /// Inserts an empty row in the specified row index.
  void insertRow(int rowIndex,
      [int rowCount, ExcelInsertOptions insertOptions]) {
    if (rowIndex < 1 || rowIndex > workbook._maxRowCount) {
      throw Exception('rowIndex');
    }
    rowCount ??= 1;
    if (rowCount < 0) throw Exception('count');
    insertOptions ??= ExcelInsertOptions.formatDefault;
    final bool isLastRow = (rowIndex + rowCount) >= workbook._maxRowCount;
    final int columnIndex = 1;
    final int lastRow = getLastRow();
    if (!isLastRow) {
      for (int count = 1; count <= rowCount; count++) {
        for (int i = lastRow + rowCount; i >= rowIndex; i--) {
          final Row row = rows[i];
          if (row == null && i != rowIndex && rows[i - 1] != null) {
            rows[i] = Row(this);
            rows[i] = rows[i - 1];
            rows[i].index = rows[i].index + 1;
            for (int j = rows[i].ranges.innerList.length - 1; j >= 1; j--) {
              final Range range = rows[i].ranges[j];
              if (range != null) {
                rows[i].ranges[j].row = rows[i].ranges[j].row + 1;
                rows[i].ranges[j].lastRow = rows[i].ranges[j].lastRow + 1;
                rows[i].ranges[j].column = rows[i].ranges[j].column;
                rows[i].ranges[j].lastColumn = rows[i].ranges[j].lastColumn;
              }
            }
          } else if (row != null && i != rowIndex && rows[i - 1] != null) {
            rows[i] = rows[i - 1];
            rows[i].index = rows[i].index + 1;
            for (int j = rows[i].ranges.innerList.length - 1; j >= 1; j--) {
              final Range range = rows[i].ranges[j];
              if (range != null) {
                rows[i].ranges[j].row = rows[i].ranges[j].row + 1;
                rows[i].ranges[j].lastRow = rows[i].ranges[j].lastRow + 1;
                rows[i].ranges[j].column = rows[i].ranges[j].column;
                rows[i].ranges[j].lastColumn = rows[i].ranges[j].lastColumn;
              }
            }
          } else if (i == rowIndex) {
            rows[i] = Row(this);
            rows[i].index = rowIndex;
            if (insertOptions == ExcelInsertOptions.formatAsBefore) {
              if (rows[i - 1] != null) {
                if (rows[i - 1].height != null) {
                  rows[i].height = rows[i - 1].height;
                }
                for (int z = 1;
                    z <= rows[i - 1].ranges.innerList.length - 1;
                    z++) {
                  if (rows[i - 1].ranges[z] != null) {
                    rows[i].ranges[z] = Range(this);
                    rows[i].ranges[z]._index = rows[i - 1].ranges[z]._index;
                    rows[i].ranges[z].row = rows[i - 1].ranges[z].row + 1;
                    rows[i].ranges[z].lastRow =
                        rows[i - 1].ranges[z].lastRow + 1;
                    rows[i].ranges[z].column = rows[i - 1].ranges[z].column;
                    rows[i].ranges[z].lastColumn =
                        rows[i - 1].ranges[z].lastColumn;
                    rows[i].ranges[z].cellStyle =
                        rows[i - 1].ranges[z].cellStyle;
                  }
                }
              }
            } else if (insertOptions == ExcelInsertOptions.formatAsAfter) {
              if (rows[i + 1] != null) {
                if (rows[i + 1].height != null) {
                  rows[i].height = rows[i + 1].height;
                }
                for (int z = 1;
                    z <= rows[i + 1].ranges.innerList.length - 1;
                    z++) {
                  if (rows[i + 1].ranges[z] != null) {
                    rows[i].ranges[z] = Range(this);
                    rows[i].ranges[z]._index = rows[i + 1].ranges[z]._index;
                    rows[i].ranges[z].row = rows[i + 1].ranges[z].row - 1;
                    rows[i].ranges[z].lastRow =
                        rows[i + 1].ranges[z].lastRow - 1;
                    rows[i].ranges[z].column = rows[i + 1].ranges[z].column;
                    rows[i].ranges[z].lastColumn =
                        rows[i + 1].ranges[z].lastColumn;
                    rows[i].ranges[z].cellStyle =
                        rows[i + 1].ranges[z].cellStyle;
                  }
                }
              }
            } else {
              rows[i].ranges[columnIndex] = null;
            }
            if (hyperlinks.count > 0) {
              for (final Hyperlink link in hyperlinks.innerList) {
                if (link._attachedType == ExcelHyperlinkAttachedType.range &&
                    link._row >= rowIndex) {
                  link._row = link._row + 1;
                }
              }
            }
          } else {
            rows[i] = Row(this);
            rows[i].index = i;
          }
        }
      }
    }
  }

  /// Delete the Row in the Worksheet.
  void deleteRow(int rowIndex, [int rowCount]) {
    if (rowIndex < 1 || rowIndex > workbook._maxRowCount) {
      throw Exception('rowIndex');
    }
    rowCount ??= 1;
    if (rowCount < 0) throw Exception('count');
    for (int count = 1; count <= rowCount; count++) {
      final int lastRow = getLastRow();
      for (int i = rowIndex; i <= lastRow; i++) {
        final Row row = rows[i];
        if (row != null && i != lastRow && rows[i + 1] != null) {
          rows[i] = rows[i + 1];
          rows[i].index = rows[i].index - 1;
          for (int j = rows[i].ranges.innerList.length - 1; j >= 1; j--) {
            final Range range = rows[i].ranges[j];
            if (range != null) {
              rows[i].ranges[j].row = rows[i].ranges[j].row - 1;
              rows[i].ranges[j].lastRow = rows[i].ranges[j].lastRow - 1;
              rows[i].ranges[j].column = rows[i].ranges[j].column;
              rows[i].ranges[j].lastColumn = rows[i].ranges[j].lastColumn;
            }
          }
        } else if (row == null && i != lastRow && rows[i + 1] != null) {
          rows[i] = Row(this);
          rows[i] = rows[i + 1];
          rows[i].index = rows[i].index - 1;
          for (int j = rows[i].ranges.innerList.length - 1; j >= 1; j--) {
            final Range range = rows[i].ranges[j];
            if (range != null) {
              rows[i].ranges[j].row = rows[i].ranges[j].row - 1;
              rows[i].ranges[j].lastRow = rows[i].ranges[j].lastRow - 1;
              rows[i].ranges[j].column = rows[i].ranges[j].column;
              rows[i].ranges[j].lastColumn = rows[i].ranges[j].lastColumn;
            }
          }
        } else if (i == lastRow) {
          rows[i] = null;
          if (hyperlinks.count > 0) {
            for (int z = 0; z < hyperlinks.count; z++) {
              if (hyperlinks[z]._attachedType ==
                      ExcelHyperlinkAttachedType.range &&
                  hyperlinks[z]._row > rowIndex) {
                hyperlinks[z]._row = hyperlinks[z]._row - 1;
              }
            }
          }
        } else {
          rows[i] = rows[i + 1];
        }
      }
    }
  }

  /// Inserts an empty column for the specified column index.
  void insertColumn(int columnIndex,
      [int columnCount, ExcelInsertOptions insertOptions]) {
    if (columnIndex < 1 || columnIndex > workbook._maxColumnCount) {
      throw Exception(
          'Value cannot be less 1 and greater than max column index.');
    }
    columnCount ??= 1;
    if (columnCount < 0) throw Exception('count');
    insertOptions ??= ExcelInsertOptions.formatDefault;
    final int firstRow = getFirstRow();
    final int lastRow = getLastRow();
    final int lastColumn = getLastColumn();
    for (int i = lastRow; i >= firstRow; i--) {
      if (rows[i] != null) {
        for (int count = 1; count <= columnCount; count++) {
          for (int j = lastColumn + columnCount; j >= columnIndex; j--) {
            final Range range = rows[i].ranges[j];
            if (range == null &&
                j != columnIndex &&
                rows[i].ranges[j - 1] != null) {
              final double columnWidth = rows[i].ranges[j - 1].columnWidth;
              rows[i].ranges[j] = Range(this);
              rows[i].ranges[j] = rows[i].ranges[j - 1];
              rows[i].ranges[j]._index = j;
              rows[i].ranges[j].row = rows[i].ranges[j].row;
              rows[i].ranges[j].lastRow = rows[i].ranges[j].lastRow;
              rows[i].ranges[j].column = rows[i].ranges[j].column + 1;
              rows[i].ranges[j].lastColumn = rows[i].ranges[j].lastColumn + 1;
              if (rows[i].ranges[j].columnWidth != 0.0) {
                rows[i].ranges[j]._columnObj = null;
                rows[i].ranges[j].columnWidth = columnWidth;
              }
            } else if (range != null &&
                j != columnIndex &&
                rows[i].ranges[j - 1] != null) {
              final double columnWidth = rows[i].ranges[j - 1].columnWidth;
              rows[i].ranges[j] = rows[i].ranges[j - 1];
              rows[i].ranges[j]._index = j;
              rows[i].ranges[j].row = rows[i].ranges[j].row;
              rows[i].ranges[j].lastRow = rows[i].ranges[j].lastRow;
              rows[i].ranges[j].column = rows[i].ranges[j].column + 1;
              rows[i].ranges[j].lastColumn = rows[i].ranges[j].lastColumn + 1;
              if (rows[i].ranges[j].columnWidth != 0.0) {
                rows[i].ranges[j]._columnObj = null;
                rows[i].ranges[j].columnWidth = columnWidth;
              }
            } else if (j == columnIndex &&
                rows[i].ranges[j] == rows[i].ranges[columnIndex]) {
              if (insertOptions == ExcelInsertOptions.formatAsBefore) {
                if (rows[i].ranges[j - 1] != null) {
                  rows[i].ranges[j] = Range(this);
                  rows[i].ranges[j]._index = j;
                  rows[i].ranges[j].row = rows[i].ranges[j - 1].row;
                  rows[i].ranges[j].lastRow = rows[i].ranges[j - 1].lastRow;
                  rows[i].ranges[j].column = rows[i].ranges[j - 1].column + 1;
                  rows[i].ranges[j].lastColumn =
                      rows[i].ranges[j - 1].lastColumn + 1;
                  rows[i].ranges[j].cellStyle = rows[i].ranges[j - 1].cellStyle;
                  if (rows[i].ranges[j - 1].columnWidth != 0.0) {
                    rows[i].ranges[j].columnWidth =
                        rows[i].ranges[j - 1].columnWidth;
                  }
                } else {
                  rows[i].ranges[j] = null;
                }
              } else if (insertOptions == ExcelInsertOptions.formatAsAfter) {
                if (rows[i].ranges[j + 1] != null) {
                  rows[i].ranges[j] = Range(this);
                  rows[i].ranges[j]._index = j;
                  rows[i].ranges[j].row = rows[i].ranges[j + 1].row;
                  rows[i].ranges[j].lastRow = rows[i].ranges[j + 1].lastRow;
                  rows[i].ranges[j].column = rows[i].ranges[j + 1].column - 1;
                  rows[i].ranges[j].lastColumn =
                      rows[i].ranges[j + 1].lastColumn - 1;
                  rows[i].ranges[j].cellStyle = rows[i].ranges[j + 1].cellStyle;
                  if (rows[i].ranges[j + 1].columnWidth != 0.0) {
                    rows[i].ranges[j].columnWidth =
                        rows[i].ranges[j + 1].columnWidth;
                  }
                }
              } else {
                rows[i].ranges[j] = null;
              }
            } else {
              rows[i].ranges[j] = null;
            }
          }
        }
      }
    }
    if (hyperlinks.count > 0) {
      for (final Hyperlink link in hyperlinks.innerList) {
        if (link._attachedType == ExcelHyperlinkAttachedType.range &&
            link._column >= columnIndex) {
          link._column = link._column + columnCount;
        }
      }
    }
    if (insertOptions == ExcelInsertOptions.formatDefault &&
        lastColumn >= columnIndex) {
      if (columns.count > 0 && columns.count >= columnIndex) {
        columns.innerList.removeAt(0);
      }
    }
  }

  /// Delete the Column in the Worksheet.
  void deleteColumn(int columnIndex, [int columnCount]) {
    if (columnIndex < 1 || columnIndex > workbook._maxColumnCount) {
      throw Exception(
          'Value cannot be less 1 and greater than max column index.');
    }
    columnCount ??= 1;
    if (columnCount < 0) throw Exception('count');
    final int firstRow = getFirstRow();
    final int lastRow = getLastRow();
    final int lastColumn = getLastColumn();
    for (int i = firstRow; i <= lastRow; i++) {
      if (rows[i] != null) {
        for (int count = 1; count <= columnCount; count++) {
          for (int j = columnIndex; j <= lastColumn; j++) {
            final Range range = rows[i].ranges[j];
            if (range != null &&
                j != lastColumn &&
                rows[i].ranges[j + 1] != null) {
              rows[i].ranges[j] = rows[i].ranges[j + 1];
              rows[i].ranges[j]._index = rows[i].ranges[j]._index - 1;
              rows[i].ranges[j].row = rows[i].ranges[j].row;
              rows[i].ranges[j].lastRow = rows[i].ranges[j].lastRow;
              rows[i].ranges[j].column = rows[i].ranges[j].column - 1;
              rows[i].ranges[j].lastColumn = rows[i].ranges[j].lastColumn - 1;
            } else if (range == null &&
                j != lastColumn &&
                rows[i].ranges[j + 1] != null) {
              rows[i].ranges[j] = Range(this);
              rows[i].ranges[j] = rows[i].ranges[j + 1];
              rows[i].ranges[j]._index = rows[i].ranges[j]._index - 1;
              rows[i].ranges[j].row = rows[i].ranges[j].row;
              rows[i].ranges[j].lastRow = rows[i].ranges[j].lastRow;
              rows[i].ranges[j].column = rows[i].ranges[j].column - 1;
              rows[i].ranges[j].lastColumn = rows[i].ranges[j].lastColumn - 1;
            } else if (j == lastColumn &&
                rows[i].ranges[j] == rows[i].ranges[lastColumn]) {
              rows[i].ranges[j] = null;
            } else {
              rows[i].ranges[j] = rows[i].ranges[j + 1];
            }
          }
        }
      }
    }
    if (hyperlinks.count > 0) {
      for (final Hyperlink link in hyperlinks.innerList) {
        if (link._attachedType == ExcelHyperlinkAttachedType.range &&
            link._column >= columnIndex) {
          link._column = link._column - columnCount;
        }
      }
    }
    for (int k = 1; k <= columnCount; k++) {
      if (columns.count > 0) {
        for (int z = 0; z < columns.count - 1; z++) {
          if (columns[z].index >= columnIndex &&
              columns[z + 1] != null &&
              columns[z + 1].width != 0.0) {
            columns[z].width = columns[z + 1].width;
          }
        }
        final int lastCol = getLastColumn() + 1;
        for (final Column col in columns.innerList) {
          if (col.index >= lastCol) {
            col.width = 0.0;
          }
        }
      }
      if (columns.count == 1 && columns[0].index == columnIndex) {
        columns[0].width = 0.0;
      }
    }
  }

  /// Maximum length of the password.
  final int _maxPassWordLength = 255;

  /// Alogrithm name to protect/unprotect worksheet.
  String _algorithmName;

  /// Random generated Salt for the sheet password.
  List<int> _saltValue;

  /// Spin count to loop the hash algorithm.
  int _spinCount;

  /// Hash value to ensure the sheet protected password.
  List<int> _hashValue;

  /// Gets a value indicating whether worksheet is protected with password.
  bool _isPasswordProtected = false;

  /// Gets protected options. Read-only. For sets protection options use "Protect" method.
  ExcelSheetProtectionOption _innerProtection;

  ExcelSheetProtectionOption _prepareProtectionOptions(
      ExcelSheetProtectionOption options) {
    options.content = false;
    return options;
  }

  /// 16-bit hash value of the password.
  int _isPassword;

  /// Represent the flag for sheet protection.
  final List<bool> _flag = [];

  /// Default password hash value.
  static const int _defPasswordConst = 52811;

  /// Protect the worksheet with specific protection options and password.
  void protect(String password, [ExcelSheetProtectionOption options]) {
    if (_isPasswordProtected) {
      throw Exception(
          'Sheet is already protected, before use unprotect method');
    }
    if (password == null) throw Exception('password');

    if (password.length > _maxPassWordLength) {
      throw Exception('Length of the password can\'t be more than ' +
          _maxPassWordLength.toString());
    }
    if (options == null) {
      options = ExcelSheetProtectionOption();
      options.content = true;
      options.lockedCells = true;
      options.unlockedCells = true;
    }
    if (options.all == true) {
      options.content = true;
      options.objects = true;
      options.scenarios = true;
      options.formatCells = true;
      options.formatColumns = true;
      options.formatRows = true;
      options.insertColumns = true;
      options.insertRows = true;
      options.insertHyperlinks = true;
      options.deleteColumns = true;
      options.deleteRows = true;
      options.lockedCells = true;
      options.sort = true;
      options.useAutoFilter = true;
      options.usePivotTableAndPivotChart = true;
      options.unlockedCells = true;
    }

    _prepareProtectionOptions(options);
    _innerProtection = options;

    _flag.add(!options.content);
    _flag.add(!options.objects);
    _flag.add(!options.scenarios);
    _flag.add(!options.formatCells);
    _flag.add(!options.formatColumns);
    _flag.add(!options.formatRows);
    _flag.add(!options.insertColumns);
    _flag.add(!options.insertRows);
    _flag.add(!options.insertHyperlinks);
    _flag.add(!options.deleteColumns);
    _flag.add(!options.deleteRows);
    _flag.add(!options.lockedCells);
    _flag.add(!options.sort);
    _flag.add(!options.useAutoFilter);
    _flag.add(!options.usePivotTableAndPivotChart);
    _flag.add(!options.unlockedCells);
    _advancedSheetProtection(password);
    final int usPassword =
        (password.isNotEmpty) ? _getPasswordHash(password) : 1;
    _isPassword = usPassword;
    _isPasswordProtected = true;
  }

  /// Protects the worksheet based on the Excel 2013.
  void _advancedSheetProtection(String password) {
    _algorithmName = _SecurityHelper._sha512Alogrithm;
    _saltValue = _createSalt(16);
    _spinCount = 500;
    final Hash algorithm = _SecurityHelper._getAlgorithm(_algorithmName);
    List<int> arrPassword = utf8.encode(password).toList();
    arrPassword = _convertCodeUnitsToUnicodeByteArray(arrPassword);
    List<int> temp = _SecurityHelper._combineArray(_saltValue, arrPassword);
    final List<int> h0 = algorithm.convert(temp).bytes.toList();
    List<int> hi = h0;
    for (int iterator = 0; iterator < _spinCount; iterator++) {
      final Uint8List int32Bytes = Uint8List(4)
        ..buffer.asByteData().setInt32(0, iterator, Endian.big);
      final List<int> arrIterator = int32Bytes.reversed.toList();
      temp = _SecurityHelper._combineArray(hi, arrIterator);
      temp = Uint8List.fromList(temp);
      hi = algorithm.convert(temp).bytes.toList();
    }
    _hashValue = hi;
  }

  /// Creates random salt.
  List<int> _createSalt(int length) {
    if (length <= 0) {
      Exception('length');
    }
    final List<int> result = List(length);
    final rnd = Random(Range._toOADate(DateTime.now()).toInt());
    // final rnd = Random();
    final int iMaxValue = _maxPassWordLength + 1;

    for (int i = 0; i < length; i++) {
      result[i] = rnd.nextInt(iMaxValue);
    }
    return result;
  }

  /// Returns hash value for the password string.
  static int _getPasswordHash(String password) {
    if (password == null) {
      return 0;
    }
    int usHash = 0;
    // ignore: prefer_final_locals
    for (int iCharIndex = 0, len = password.length;
        iCharIndex < len;
        iCharIndex++) {
      List<bool> bits = _getCharBits15(password[iCharIndex]);
      bits = _rotateBits(bits, iCharIndex + 1);
      final int curNumber = _getUInt16FromBits(bits);
      usHash ^= curNumber;
    }
    return (usHash ^ password.length ^ _defPasswordConst);
  }

  List<int> _convertCodeUnitsToUnicodeByteArray(List<int> codeUnits) {
    final ByteBuffer buffer = Uint8List(codeUnits.length * 2).buffer;
    final ByteData bdata = ByteData.view(buffer);
    int pos = 0;
    for (final int val in codeUnits) {
      bdata.setInt16(pos, val, Endian.little);
      pos += 2;
    }
    return bdata.buffer.asUint8List();
  }

  /// Converts character to 15 bits sequence
  static List<bool> _getCharBits15(String char) {
    final List<bool> arrResult = List(15);
    final int usSource = char.codeUnitAt(0);
    int curBit = 1;
    for (int i = 0; i < 15; i++) {
      arrResult[i] = ((usSource & curBit) == curBit);
      curBit <<= 1;
    }

    return arrResult;
  }

  static List<bool> _rotateBits(List<bool> bits, int count) {
    if (bits == null) throw Exception('bits');

    if (bits.isEmpty) return bits;

    if (count < 0) throw Exception('Count can\'t be less than zero');

    final List<bool> arrResult = List(bits.length);
    // ignore: prefer_final_locals
    for (int i = 0, len = bits.length; i < len; i++) {
      final int newPos = (i + count) % len;
      arrResult[newPos] = bits[i];
    }
    return arrResult;
  }

  /// Converts bits array to UInt16 value.
  static int _getUInt16FromBits(List<bool> bits) {
    if (bits == null) throw Exception('bits');

    if (bits.length > 16) throw Exception("There can't be more than 16 bits");

    int usResult = 0;
    int curBit = 1;
    // ignore: prefer_final_locals
    for (int i = 0, len = bits.length; i < len; i++) {
      if (bits[i]) usResult += curBit;
      curBit <<= 1;
    }

    return usResult;
  }

  /// Represents Protection Attributes
  final List<String> _protectionAttributes = [
    'sheet',
    'objects',
    'scenarios',
    'formatCells',
    'formatColumns',
    'formatRows',
    'insertColumns',
    'insertRows',
    'insertHyperlinks',
    'deleteColumns',
    'deleteRows',
    'selectLockedCells',
    'sort',
    'autoFilter',
    'pivotTables',
    'selectunlockedCells',
  ];

  /// Represents the defeault values for sheet Protection.
  final List<bool> _defaultValues = [
    false,
    false,
    false,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    false,
    true,
    true,
    false,
    false,
  ];

  /// Clear the worksheet.
  /// Returns width of the specified column in pixels.
  int _getColumnWidthInPixels(int iColumnIndex) {
    if (iColumnIndex > _book._maxColumnCount) {
      iColumnIndex = _book._maxColumnCount;
    }

    if (iColumnIndex < 1 || iColumnIndex > _book._maxColumnCount) {
      throw Exception(
          'Value cannot be less 1 and greater than max column index.');
    }

    final double widthInChars = _innerGetColumnWidth(iColumnIndex);
    return _columnWidthToPixels(widthInChars);
  }

  /// Returns width from ColumnInfoRecord if there is corresponding ColumnInfoRecord or StandardWidth if not.
  double _innerGetColumnWidth(int iColumn) {
    if (iColumn < 1) {
      throw Exception("iColumn can't be less then 1");
    }
    Column column;
    if (columns != null && columns.contains(iColumn)) {
      column = columns.getColumn(iColumn);
    }

    double dResult;

    if (column == null) {
      dResult = _standardWidth;
    } else {
      dResult = column.width;
    }

    return dResult;
  }

  /// Converts the specified column width from points to pixels.
  int _columnWidthToPixels(double widthInChars) {
    final double dFileWidth = _book._widthToFileWidth(widthInChars);
    return _book._fileWidthToPixels(dFileWidth).toInt();
  }

  /// Converts the specified column width from pixels to points.
  double _pixelsToColumnWidth(int pixels) {
    return _book._pixelsToWidth(pixels);
  }

  /// Sets column width in pixels for the specified column.
  void _setColumnWidthInPixels(int iColumn, int value, bool isBestFit) {
    final double dColumnWidth = _pixelsToColumnWidth(value);
    _setColumnWidth(iColumn, dColumnWidth, isBestFit);
  }

  /// Sets column width for the specified column.
  void _setColumnWidth(int iColumn, double value, bool isBestFit) {
    if (iColumn < 1 || iColumn > _book._maxColumnCount) {
      throw Exception(
          'Column index cannot be larger then 256 or less then one');
    }
    final double iOldValue = _innerGetColumnWidth(iColumn);
    if (iOldValue != value) {
      Column colInfo;
      if (iColumn < columns.count) {
        colInfo = columns[iColumn];
      }

      if (colInfo == null) {
        colInfo = columns.add();
        colInfo.index = iColumn;
        colInfo.width = _standardWidth;
      }

      if (value > 255) value = 255;
      colInfo.width = value;

      // colInfo._isBestFit = isBestFit;
    }
  }

  // /// Converts width displayed by Excel to width that should be written into file.
  // double _evaluateFileColumnWidth(int realWidth) {
  //   return _book._widthToFileWidth(realWidth / 256.0) * 256;
  // }

  /// Clear the worksheet.
  void _clear() {
    if (_rows != null) {
      _rows._clear();
    }

    if (_columns != null) {
      _columns._clear();
    }

    if (_pictures != null) {
      _pictures._clear();
    }
  }
}
