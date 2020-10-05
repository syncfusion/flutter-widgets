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

  /// Sets the grid line visible.
  /// True if grid lines are visible. otherwise, False.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// sheet.showGridLines = false;
  /// workbook.save('GridLine.xlsx');
  /// workbook.dispose();
  /// ```
  bool showGridLines = true;

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
  /// workbook.save('ExcelEmptyChart.xlsx');
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

  /// Represents parent workbook.
  Workbook get workbook {
    return _book;
  }

  /// Represents all the columns in the specified worksheet.
  ColumnCollection get columns {
    _columns ??= ColumnCollection(this);
    return _columns;
  }

  /// Returns or sets the name of the worksheet.
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

  ///  Gets/Sets a pictures collections in the worksheet.
  /// Gets/Sets a pictures collections in the worksheet.
  PicturesCollection get pictures {
    _pictures ??= PicturesCollection(this);
    return _pictures;
  }

  /// Gets/Sets a rows collections in the worksheet.
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
  /// workbook.save('Range.xlsx');
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
  /// workbook.save('Range.xlsx');
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
      calcEngine.excelLikeComputations = true;

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

      for (final String v in calcEngine._formulaErrorStrings) {
        if (value == v) istext = true;
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
      for (int i = firstRow + 1; i < rows.count; i++) {
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

  /// This API supports the .NET Framework infrastructure and is not intended to be used directly from your code.
  // ignore: unused_element
  int _getColumnCount() {
    return getLastColumn() - getFirstColumn();
  }

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
