part of xlsio;

/// Represents a worksheet in a workbook.
class Worksheet {
  /// Creates an instance of Worksheet.
  Worksheet(Workbook workbook) {
    _book = workbook;
    _isRightToLeft = workbook.isRightToLeft;
  }

  /// set summary row below
  final bool _isSummaryRowBelow = true;

  /// Represent the worksheet index.
  late int index;

  /// Represents Worksheet's name.
  String _name = '';

  /// Standard column width.
  final double _standardWidth = 8.43;

  /// Standard column width.
  final double _standardHeight = 15;

  /// Default character (for width measuring).
  final String _defaultStandardChar = '0';

  /// Maximum row height in points.
  final double _defaultMaxHeight = 409.5;

  /// One degree in radians.
  final double _defaultAxeInRadians = pi / 180;

  /// Represents indent width.
  final int _defaultIndentWidth = 12;

  /// Represent the hyperlink relation id
  final List<String> _hyperlinkRelationId = <String>[];

  /// Represents the count of the number of tables
  late int _count = 0;

  ///Represents the datavalidation table
  _DataValidationTable? _mdataValidation;

  // Represents the number of columns visible in the top pane
  int _verticalSplit = 0;

  // Represents the number of rows visible in the left pane
  int _horizontalSplit = 0;

  // Represents topLeftCell
  String _topLeftCell = '';

  // Represents is panes are frozen
  bool _isfreezePane = false;

  // Represents active pane
  late _ActivePane _activePane;

  ///Represents autoFilter class
  AutoFilterCollection? _autoFilters;

  ///Represents worksheet named range collection.
  Names? _namesColl;

  ///Represents worksheet named range collection.
  Names get names {
    _namesColl ??= _WorksheetNamesCollection(this);
    return _namesColl!;
  }

  /// Represents auto fit manager.
  _AutoFitManager get _autoFitManager {
    final _AutoFitManager autoFit = _AutoFitManager._withSheet(this);
    return autoFit;
  }

  ///Get the page setup settings for the worksheet. Read-only.
  PageSetup? _pageSetup;

  ///Get a collection of tables in the worksheet. Read-only.
  ExcelTableCollection? _tableCollection;

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
  PicturesCollection? _pictures;

  /// Collection of all pictures in the current worksheet.
  RowCollection? _rows;

  /// Represents all the columns in the specified worksheet.
  ColumnCollection? _columns;

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
  ChartHelper? charts;

  //Represent the RTL direction for worksheet
  bool _isRightToLeft = false;

  /// Represents the chart count in the workbook.
  int chartCount = 0;

  // Parent workbook
  late Workbook _book;

  /// Gets or sets the a CalcEngine object.
  CalcEngine? calcEngine;

  ///Collection of all merged cells in the current worksheet.
  MergedCellCollection? _mergeCells;

  /// Represents tab color of the sheet.
  late String _tabColor;

  ///Determine whether the tab color is applied on the worksheet or not.
  bool _isTapColorApplied = false;

  /// Collection of all hyperlinks in the current worksheet.
  HyperlinkCollection? _hyperlinks;

  /// Represents the visibility of worksheet.
  WorksheetVisibility _visibility = WorksheetVisibility.visible;

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
    return _columns!;
  }

  ///Indicates whether worksheet is displayed right to left.FALSE by default
  ///
  /// ```dart
  /// Workbook workbook = Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// sheet.isRightToLeft = true;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ExcelRTL.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  // ignore: unnecessary_getters_setters
  bool get isRightToLeft {
    return _isRightToLeft;
  }

  set isRightToLeft(bool value) {
    _isRightToLeft = value;
  }

  /// Represents the method to create an instance for table if it is null
  _DataValidationTable get _dvTable {
    if (_mdataValidation == null) {
      _mdataValidation = _DataValidationTable(this);
      _count++;
    }

    return _mdataValidation!;
  }

  /// Represents the getter to get the table count
  int get _tableCount {
    return _count;
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
    if (_name == '') {
      _name = 'Sheet$index';
    }
    return _name;
  }

  set name(String value) {
    _name = value;
  }

  /// Gets/Sets a merged cell collections in the worksheet.
  MergedCellCollection get mergeCells {
    _mergeCells ??= MergedCellCollection();
    return _mergeCells!;
  }

  set mergeCells(MergedCellCollection value) {
    _mergeCells = value;
  }

  /// Gets/Sets a pictures collections in the worksheet.
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// String base64Image = base64Encode(File('image.png').readAsBytesSync());
  /// sheet.picutes.addBase64(1, 1, base64Image);
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Picutes.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  PicturesCollection get pictures {
    _pictures ??= PicturesCollection(this);
    return _pictures!;
  }

  /// Gets/Sets a hyperlink collections in the worksheet.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1');
  ///
  /// // Add hyperlink to sheet.
  /// sheet.hyperlinks
  ///        .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
  ///
  /// //Save and dispose.
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Hyperlinks.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  HyperlinkCollection get hyperlinks {
    _hyperlinks ??= HyperlinkCollection(this);
    return _hyperlinks!;
  }

  ///Get a collection of tables in the worksheet. Read-only.
  ExcelTableCollection get tableCollection {
    _tableCollection ??= ExcelTableCollection(this);
    return _tableCollection!;
  }

  /// Represents the page setup settings for the worksheet.
  PageSetup get pageSetup {
    _pageSetup ??= _PageSetupImpl(this);
    return _pageSetup!;
  }

  /// Gets/Sets a Conditional Format collections in the worksheet.
  // ignore: library_private_types_in_public_api
  List<_ConditionalFormatsImpl> conditionalFormats =
      <_ConditionalFormatsImpl>[];

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
    return _rows!;
  }

  ///Get the tab color for the worksheet.
  String get tabColor {
    return _tabColor;
  }

  ///Set the tab color for the worksheet.
  set tabColor(String value) {
    _tabColor = value;
    _isTapColorApplied = true;
  }

  // ignore: public_member_api_docs
  AutoFilterCollection get autoFilters {
    _autoFilters ??= AutoFilterCollection(this);
    return _autoFilters!;
  }

  ///Get the visibility of worksheet.
  WorksheetVisibility get visibility {
    return _visibility;
  }

  ///Set the visibility of worksheet.
  set visibility(WorksheetVisibility visibilty) {
    if (_book.worksheets.innerList.length <= 1 &&
        visibilty == WorksheetVisibility.hidden) {
      throw Exception(
          'A workbook must contain at least one visible worksheet.');
    } else {
      _visibility = visibilty;
    }
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

    Range? range;
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
    } else if (cellReference.isEmpty) {
      final Error error =
          ArgumentError('cellReference - Value cannot be empty.');
      throw error;
    }
    final List<String> cells = cellReference.split(':');
    int firstRow = 0;
    int lastRow = 0;
    int firstColumn = 0;
    int lastColumn = 0;
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
          if (iDigitStart < 0) {
            iDigitStart = j;
          }
        } else if (!_isNumeric(ch)) {
          if (iLetterStart < 0) {
            iLetterStart = j;
          }

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
        final Error error = ArgumentError(
            'cellReference - name cannot be less then 2 symbols.');
        throw error;
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
    if ((dNumber % 1) == 0) {
      isDateValue = true;
    }
    final CultureInfo currentCulture = CultureInfo.currentCulture;
    if (!isDateValue &&
        (dNumber > -657435.0) &&
        (dNumber < 2958465.99999999) &&
        Range._fromOADate(dNumber).millisecond >
            _SecondToken._defaultMilliSecondHalf) {
      final String decimalSeparator =
          currentCulture.numberFormat.numberDecimalSeparator;
      final RegExp regex = RegExp(
          '([0-9]*:[0-9]*:[0-9]*"$decimalSeparator[0-9]*|[0-9]*:[0-9]*:[0-9]*|[0-9]*:[0-9]*"$decimalSeparator[0-9]*|[0-9]*:[0-9]*)');
      final List<RegExpMatch> matches = regex.allMatches(value).toList();
      for (final Match match in matches) {
        final String semiColon = currentCulture.dateTimeFormat.timeSeparator;
        const String valueFormat = _SecondToken._defaultFormatLong;
        final List<String> timeValues =
            match.pattern.toString().split(semiColon);
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
                  timeValues[timeValues.length - 1].replaceAll(
                      timeValues[timeValues.length - 1], valueFormat);
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
    return double.tryParse(s) != null;
  }

  /// Converts column name into index.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook(1);
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// // get column Index.
  /// print(sheet.getColumnIndex('AA'));
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Output.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  int getColumnIndex(String columnName) {
    if (columnName.isEmpty) {
      final Error error =
          ArgumentError('columnName - name cannot be less then 1 symbols.');
      throw error;
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
    if (iColumn < 0) {
      iColumn = -iColumn;
    }
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
    if (calcEngine == null) {
      CalcEngine.parseArgumentSeparator =
          _book._getCultureInfo().textInfo.argumentSeparator;
      CalcEngine.parseDecimalSeparator =
          _book._getCultureInfo().numberFormat.numberDecimalSeparator;

      calcEngine = CalcEngine(this);
      calcEngine!.useDatesInCalculations = true;
      calcEngine!.useNoAmpersandQuotes = true;

      final int sheetFamilyID = CalcEngine.createSheetFamilyID();

      //register the sheet names with calculate
      for (final Worksheet sheet in workbook.worksheets.innerList) {
        if (sheet.calcEngine == null) {
          sheet.calcEngine = CalcEngine(sheet);
          sheet.calcEngine!.useDatesInCalculations = true;
          sheet.calcEngine!.useNoAmpersandQuotes = true;
          sheet.calcEngine!.excelLikeComputations = true;
        }
        if (CalcEngine._modelToSheetID != null &&
            (CalcEngine._modelToSheetID!.containsKey(sheet))) {
          CalcEngine._modelToSheetID!.remove(sheet);
        }
        sheet.calcEngine!
            ._registerGridAsSheet(sheet.name, sheet, sheetFamilyID);
      }
    }
  }

  /// get range from row and column from worksheet.
  Range? _getRangeFromSheet(int row, int column) {
    if (row <= rows.count &&
        rows[row] != null &&
        column <= rows[row]!.ranges.count) {
      return rows[row]!.ranges[column];
    }
    return null;
  }

  /// Get the value from the specified cell.
  Object _getValueRowCol(int iRow, int iColumn) {
    final Range range = getRangeByIndex(iRow, iColumn);
    if (range.formula != null) {
      return range.formula!;
    } else if (range.text != null) {
      return range.text!;
    } else if (range.dateTime != null) {
      return range.dateTime!;
    } else if (range.number != null) {
      return range.number!;
    }
    return '';
  }

  /// Sets value for the specified cell.
  void _setValueRowCol(String value, int iRow, int iColumn) {
    final Range range = getRangeByIndex(iRow, iColumn);
    final CellType valType = range.type;
    if (value.isNotEmpty && value[0] == '=') {
      range.setFormula(value.substring(1));
    } else {
      double? doubleValue;
      DateTime? dateValue;
      if (value.runtimeType == double) {
        doubleValue = double.tryParse(value);
      } else {
        dateValue = DateTime.tryParse(value);
      }

      final CultureInfo cultureInfo = _book._getCultureInfo();
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

      if (value.isNotEmpty &&
          calcEngine!._formulaErrorStrings.contains(value)) {
        istext = true;
      }

      if (valType == CellType.formula) {
        if (isNumber && !bDateTime && doubleValue != null) {
          range._setFormulaNumberValue(doubleValue);
        } else if (bDateTime) {
          range._setFormulaDateValue(dateValue);
        } else if (isboolean) {
          range._setFormulaBooleanValue(value);
        } else if (iserrorStrings) {
          range._setFormulaErrorStringValue(value);
        } else if (value.contains('Exception:') || istext) {
          range.setText(value);
        } else {
          range._setFormulaStringValue(value);
        }
      } else {
        if (isNumber && !bDateTime && doubleValue != null) {
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
      final RegExp decimalSepRegex =
          RegExp('[${cultureInfo.numberFormat.numberDecimalSeparator}]');
      final List<RegExpMatch> decimalSepMatches =
          decimalSepRegex.allMatches(value).toList();
      //Checks whether the value has more than one decimal point.
      if (decimalSepMatches.length > 1) {
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

    final RegExp groupSepRegex =
        RegExp('[${cultureInfo.numberFormat.numberGroupSeparator}]');
    final List<RegExpMatch> groupSepMatches =
        groupSepRegex.allMatches(value).toList();

    int index = 0;
    while (index < groupSepMatches.length) {
      //Checks whether the group separator at third digit.
      if ((groupSepMatches[index].start - index) % 3 != 0) {
        return false;
      }
      index++;
    }
    return true;
  }

  /// Get the index of the first row in UsedRange.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook(1);
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1:D4');
  /// range.setText('Hi');
  ///
  /// // get first row.
  /// print(sheet.getFirstRow());
  /// // get last row.
  /// print(sheet.getLastRow());
  /// // get first column.
  /// print(sheet.getFirstColumn());
  /// // get last Column.
  /// print(sheet.getLastColumn());
  ///
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Output.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  int getFirstRow() {
    for (final Row? row in rows.innerList) {
      if (row != null) {
        return row.index;
      }
    }
    return -1;
  }

  /// get the index of the last row in UsedRange.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook(1);
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1:D4');
  /// range.setText('Hi');
  ///
  /// // get first row.
  /// print(sheet.getFirstRow());
  /// // get last row.
  /// print(sheet.getLastRow());
  /// // get first column.
  /// print(sheet.getFirstColumn());
  /// // get last Column.
  /// print(sheet.getLastColumn());
  ///
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Output.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  int getLastRow() {
    int lastRow = -1;
    for (final Row? row in rows.innerList) {
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
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook(1);
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1:D4');
  /// range.setText('Hi');
  ///
  /// // get first row.
  /// print(sheet.getFirstRow());
  /// // get last row.
  /// print(sheet.getLastRow());
  /// // get first column.
  /// print(sheet.getFirstColumn());
  /// // get last Column.
  /// print(sheet.getLastColumn());
  ///
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Output.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  int getFirstColumn() {
    final int firstRow = getFirstRow();
    if (firstRow != -1) {
      int firstCol = 1;
      for (int i = firstRow; i <= rows.count; i++) {
        final Row? row = rows[i];
        if (row != null) {
          for (final Range? cell in row.ranges.innerList) {
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
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook(1);
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1:D4');
  /// range.setText('Hi');
  ///
  /// // get first row.
  /// print(sheet.getFirstRow());
  /// // get last row.
  /// print(sheet.getLastRow());
  /// // get first column.
  /// print(sheet.getFirstColumn());
  /// // get last Column.
  /// print(sheet.getLastColumn());
  ///
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Output.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  int getLastColumn() {
    final int firstRow = getFirstRow();
    if (firstRow != -1) {
      int firstCol = 1;
      for (int i = firstRow; i <= rows.count; i++) {
        final Row? row = rows[i];
        if (row != null) {
          for (final Range? cell in row.ranges.innerList) {
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
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1');
  /// range.setText('Test for AutoFit Column');
  ///
  /// // Auto Fit column.
  /// sheet.autoFitColumn(1);
  ///
  /// // save and dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'AutoFitColumn.xlsx');
  /// workbook.dispose();
  /// ```
  void autoFitColumn(int colIndex) {
    final Range range = getRangeByIndex(
        getFirstRow(), getFirstColumn(), getLastRow(), getLastColumn());
    range._autoFitToColumn(colIndex, colIndex);
  }

  /// Changes the height of the specified row to achieve the best fit.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range1 = sheet.getRangeByName('A1');
  /// range1.setText('WrapTextWrapTextWrapTextWrapText');
  /// final CellStyle style = workbook.styles.add('Style1');
  /// style.wrapText = true;
  /// range1.cellStyle = style;
  ///
  /// //Auto Fit Row
  /// sheet.autoFitRow(1);
  ///
  /// // save and dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'AutoFitRow.xlsx');
  /// workbook.dispose();
  /// ```
  void autoFitRow(int rowIndex) {
    final int iFirstColumn = getFirstColumn();
    final int iLastColumn = getLastColumn();
    _autoFitToRow(rowIndex, iFirstColumn, iLastColumn);
  }

  /// Returns the width of the specified column.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook(1);
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1');
  /// // get column Width.
  /// print(sheet.getColumnWidth(1));
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Output.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  double getColumnWidth(int iColumnIndex) {
    if (iColumnIndex < 1 || iColumnIndex > _book._maxColumnCount) {
      throw Exception(
          'Value cannot be less 1 and greater than max column index.');
    }
    return _innerGetColumnWidth(iColumnIndex);
  }

  /// Returns the height of the specified row.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook(1);
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByName('A1');
  /// // get row height.
  /// print(sheet.getRowHeight(1));
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Output.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  double getRowHeight(int iRow) {
    return _innerGetRowHeight(iRow, true);
  }

  /// Returns height from RowRecord if there is a corresponding Row.
  double _innerGetRowHeight(int iRow, bool bRaiseEvents) {
    if (iRow < 1 || iRow > _book._maxRowCount) {
      throw Exception('Value cannot be less 1 and greater than max row index.');
    }
    Row? row = rows[iRow];
    if (rows[iRow] == null) {
      row = Row(this);
      row.index = iRow;
      rows[iRow] = row;
    }

    bool hasMaxHeight = false;
    bool hasRotation = false;

    if (row != null) {
      final int firstColumn = getFirstColumn();
      final int lastColumn = getLastColumn();
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
        for (final Range? migrantCell in row.ranges.innerList) {
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
      return row!.height;
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
      if (rows[rowIndex] == null || rows[rowIndex]!._ranges![j] == null) {
        continue;
      }
      final Range range = getRangeByIndex(rowIndex, j);
      if (range._rowSpan > 1) {
        continue;
      }
      final List<dynamic> result =
          _measureCell(range, true, false, isMergedAndWrapped);
      curSize = result[0] as _SizeF;
      isMergedAndWrapped = result[1] as bool;
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

    Row? rowObj = rows[iRowIndex];
    if (rows[iRowIndex] == null) {
      rowObj = Row(this);
      rowObj.index = iRowIndex;
      rows[iRowIndex] = rowObj;
    }
    if (rowObj!.height != value) {
      rowObj.height = value;
    }
  }

  /// Gets size of string that contain cell found by cellindex.
  List<dynamic> _measureCell(Range range, bool bAutoFitRows,
      bool ignoreRotation, bool bIsMergedAndWrapped) {
    final int iColumn = range.column;
    bool isMerged = false;
    final String? strText = range.text;

    if (strText == null || strText.isEmpty) {
      bIsMergedAndWrapped = false;
      return <dynamic>[_SizeF(0, 0), bIsMergedAndWrapped];
    }

    if (range.rowSpan != 0 || range.columnSpan != 0) {
      isMerged = true;
    }

    final Style format = range.cellStyle;
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
        const Rectangle<num> rectF = Rectangle<num>(0, 0, 1800, 100);
        defWidth =
            _book._getMeasuredRectangle('0', fontStyle, rectF).width + 0.05;

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
        if (rotation == 255) {
          curSize._width = _book._convertToPixels(
                  _autoFitManager._calculateWrappedCell(
                      format, strText, defWidth.toInt()),
                  6) -
              defWidth;
        } else if (rotation != 90 && rotation != 180) {
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

    return <dynamic>[curSize, bIsMergedAndWrapped];
  }

  /// Updates indent size.
  _SizeF _updateAutofitByIndent(_SizeF curSize, Style format) {
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

    if (rotation > 90) {
      rotation -= 90;
    }

    if (bUpdateHeight) {
      rotation = 90 - rotation;
    }

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
  ///  ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.setText('Hello');
  /// range = sheet.getRangeByName('B1');
  /// range.setText('World');
  ///
  /// // Insert a row
  /// sheet.insertRow(1, 1, ExcelInsertOptions.formatAsAfter);
  ///
  /// // Insert a column.
  /// sheet.insertColumn(2, 1, ExcelInsertOptions.formatAsBefore);
  ///
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('InsertRow.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  void insertRow(int rowIndex,
      [int? rowCount, ExcelInsertOptions? insertOptions]) {
    if (rowIndex < 1 || rowIndex > workbook._maxRowCount) {
      throw Exception('rowIndex');
    }
    rowCount ??= 1;
    if (rowCount < 0) {
      throw Exception('count');
    }
    insertOptions ??= ExcelInsertOptions.formatDefault;
    final bool isLastRow = (rowIndex + rowCount) >= workbook._maxRowCount;
    const int columnIndex = 1;
    final int lastRow = getLastRow();
    if (!isLastRow) {
      for (int count = 1; count <= rowCount; count++) {
        for (int i = lastRow + rowCount; i >= rowIndex; i--) {
          final Row? row = rows[i];
          if (row == null && i != rowIndex && rows[i - 1] != null) {
            rows[i] = Row(this);
            rows[i] = rows[i - 1];
            rows[i]!.index = rows[i]!.index + 1;
            for (int j = rows[i]!.ranges.innerList.length; j >= 1; j--) {
              final Range? range = rows[i]!.ranges[j];
              if (range != null) {
                rows[i]!.ranges[j]!.row = rows[i]!.ranges[j]!.row + 1;
                rows[i]!.ranges[j]!.lastRow = rows[i]!.ranges[j]!.lastRow + 1;
                rows[i]!.ranges[j]!.column = rows[i]!.ranges[j]!.column;
                rows[i]!.ranges[j]!.lastColumn = rows[i]!.ranges[j]!.lastColumn;
              }
            }
          } else if (row != null && i != rowIndex && rows[i - 1] != null) {
            rows[i] = rows[i - 1];
            rows[i]!.index = rows[i]!.index + 1;
            for (int j = rows[i]!.ranges.innerList.length; j >= 1; j--) {
              final Range? range = rows[i]!.ranges[j];
              if (range != null) {
                rows[i]!.ranges[j]!.row = rows[i]!.ranges[j]!.row + 1;
                rows[i]!.ranges[j]!.lastRow = rows[i]!.ranges[j]!.lastRow + 1;
                rows[i]!.ranges[j]!.column = rows[i]!.ranges[j]!.column;
                rows[i]!.ranges[j]!.lastColumn = rows[i]!.ranges[j]!.lastColumn;
              }
            }
          } else if (i == rowIndex) {
            rows[i] = Row(this);
            rows[i]!.index = rowIndex;
            if (insertOptions == ExcelInsertOptions.formatAsBefore) {
              if (rows[i - 1] != null) {
                if (rows[i - 1]!.height != 0) {
                  rows[i]!.height = rows[i - 1]!.height;
                }
                for (int z = 1;
                    z <= rows[i - 1]!.ranges.innerList.length;
                    z++) {
                  if (rows[i - 1]!.ranges[z] != null) {
                    rows[i]!.ranges[z] = Range(this);
                    rows[i]!.ranges[z]!._index = rows[i - 1]!.ranges[z]!._index;
                    rows[i]!.ranges[z]!.row = rows[i - 1]!.ranges[z]!.row + 1;
                    rows[i]!.ranges[z]!.lastRow =
                        rows[i - 1]!.ranges[z]!.lastRow + 1;
                    rows[i]!.ranges[z]!.column = rows[i - 1]!.ranges[z]!.column;
                    rows[i]!.ranges[z]!.lastColumn =
                        rows[i - 1]!.ranges[z]!.lastColumn;
                    rows[i]!.ranges[z]!.cellStyle =
                        rows[i - 1]!.ranges[z]!.cellStyle;
                  }
                }
              }
            } else if (insertOptions == ExcelInsertOptions.formatAsAfter) {
              if (rows[i + 1] != null) {
                if (rows[i + 1]!.height != 0) {
                  rows[i]!.height = rows[i + 1]!.height;
                }
                for (int z = 1;
                    z <= rows[i + 1]!.ranges.innerList.length;
                    z++) {
                  if (rows[i + 1]!.ranges[z] != null) {
                    rows[i]!.ranges[z] = Range(this);
                    rows[i]!.ranges[z]!._index = rows[i + 1]!.ranges[z]!._index;
                    rows[i]!.ranges[z]!.row = rows[i + 1]!.ranges[z]!.row - 1;
                    rows[i]!.ranges[z]!.lastRow =
                        rows[i + 1]!.ranges[z]!.lastRow - 1;
                    rows[i]!.ranges[z]!.column = rows[i + 1]!.ranges[z]!.column;
                    rows[i]!.ranges[z]!.lastColumn =
                        rows[i + 1]!.ranges[z]!.lastColumn;
                    rows[i]!.ranges[z]!.cellStyle =
                        rows[i + 1]!.ranges[z]!.cellStyle;
                  }
                }
              }
            } else {
              rows[i]!.ranges[columnIndex] = null;
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
            rows[i]!.index = i;
          }
        }
      }
    }
  }

  /// Delete the Row in the Worksheet.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A2');
  /// range.setText('Hello');
  /// range = sheet.getRangeByName('C2');
  /// range.setText('World');
  ///
  /// // Delete a row
  /// sheet.deleteRow(1, 1);
  ///
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DeleteRowandColumn.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  void deleteRow(int rowIndex, [int? rowCount]) {
    if (rowIndex < 1 || rowIndex > workbook._maxRowCount) {
      throw Exception('rowIndex');
    }
    rowCount ??= 1;
    if (rowCount < 0) {
      throw Exception('count');
    }
    for (int count = 1; count <= rowCount; count++) {
      final int lastRow = getLastRow();
      for (int i = rowIndex; i <= lastRow; i++) {
        final Row? row = rows[i];
        if (row != null && i != lastRow && rows[i + 1] != null) {
          rows[i] = rows[i + 1];
          rows[i]!.index = rows[i]!.index - 1;
          for (int j = rows[i]!.ranges.innerList.length; j >= 1; j--) {
            final Range? range = rows[i]!.ranges[j];
            if (range != null) {
              rows[i]!.ranges[j]!.row = rows[i]!.ranges[j]!.row - 1;
              rows[i]!.ranges[j]!.lastRow = rows[i]!.ranges[j]!.lastRow - 1;
              rows[i]!.ranges[j]!.column = rows[i]!.ranges[j]!.column;
              rows[i]!.ranges[j]!.lastColumn = rows[i]!.ranges[j]!.lastColumn;
            }
          }
        } else if (row == null && i != lastRow && rows[i + 1] != null) {
          rows[i] = Row(this);
          rows[i] = rows[i + 1];
          rows[i]!.index = rows[i]!.index - 1;
          for (int j = rows[i]!.ranges.innerList.length; j >= 1; j--) {
            final Range? range = rows[i]!.ranges[j];
            if (range != null) {
              rows[i]!.ranges[j]!.row = rows[i]!.ranges[j]!.row - 1;
              rows[i]!.ranges[j]!.lastRow = rows[i]!.ranges[j]!.lastRow - 1;
              rows[i]!.ranges[j]!.column = rows[i]!.ranges[j]!.column;
              rows[i]!.ranges[j]!.lastColumn = rows[i]!.ranges[j]!.lastColumn;
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
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A1');
  /// range.setText('Hello');
  /// range = sheet.getRangeByName('B1');
  /// range.setText('World');
  ///
  /// // Insert a column.
  /// sheet.insertColumn(2, 1, ExcelInsertOptions.formatAsBefore);
  ///
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('InsertColumn.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  void insertColumn(int columnIndex,
      [int? columnCount, ExcelInsertOptions? insertOptions]) {
    if (columnIndex < 1 || columnIndex > workbook._maxColumnCount) {
      throw Exception(
          'Value cannot be less 1 and greater than max column index.');
    }
    columnCount ??= 1;
    if (columnCount < 0) {
      throw Exception('count');
    }
    insertOptions ??= ExcelInsertOptions.formatDefault;
    final int firstRow = getFirstRow();
    final int lastRow = getLastRow();
    final int lastColumn = getLastColumn();
    if (rows.count > 0) {
      for (int i = lastRow; i >= firstRow; i--) {
        if (rows[i] != null) {
          for (int count = 1; count <= columnCount; count++) {
            for (int j = lastColumn + columnCount; j >= columnIndex; j--) {
              final Range? range = rows[i]!.ranges[j];
              if (range == null &&
                  j != columnIndex &&
                  rows[i]!.ranges[j - 1] != null) {
                rows[i]!.ranges[j] = Range(this);
                rows[i]!.ranges[j] = rows[i]!.ranges[j - 1];
                rows[i]!.ranges[j]!._index = j;
                rows[i]!.ranges[j]!.row = rows[i]!.ranges[j]!.row;
                rows[i]!.ranges[j]!.lastRow = rows[i]!.ranges[j]!.lastRow;
                rows[i]!.ranges[j]!.column = rows[i]!.ranges[j]!.column + 1;
                rows[i]!.ranges[j]!.lastColumn =
                    rows[i]!.ranges[j]!.lastColumn + 1;
              } else if (range != null &&
                  j != columnIndex &&
                  rows[i]!.ranges[j - 1] != null) {
                rows[i]!.ranges[j] = rows[i]!.ranges[j - 1];
                rows[i]!.ranges[j]!._index = j;
                rows[i]!.ranges[j]!.row = rows[i]!.ranges[j]!.row;
                rows[i]!.ranges[j]!.lastRow = rows[i]!.ranges[j]!.lastRow;
                rows[i]!.ranges[j]!.column = rows[i]!.ranges[j]!.column + 1;
                rows[i]!.ranges[j]!.lastColumn =
                    rows[i]!.ranges[j]!.lastColumn + 1;
              } else if (j == columnIndex &&
                  rows[i]!.ranges[j] == rows[i]!.ranges[columnIndex]) {
                if (insertOptions == ExcelInsertOptions.formatAsBefore) {
                  if (rows[i]!.ranges[j - 1] != null) {
                    rows[i]!.ranges[j] = Range(this);
                    rows[i]!.ranges[j]!._index = j;
                    rows[i]!.ranges[j]!.row = rows[i]!.ranges[j - 1]!.row;
                    rows[i]!.ranges[j]!.lastRow =
                        rows[i]!.ranges[j - 1]!.lastRow;
                    rows[i]!.ranges[j]!.column =
                        rows[i]!.ranges[j - 1]!.column + 1;
                    rows[i]!.ranges[j]!.lastColumn =
                        rows[i]!.ranges[j - 1]!.lastColumn + 1;
                    rows[i]!.ranges[j]!.cellStyle =
                        rows[i]!.ranges[j - 1]!.cellStyle;
                  } else {
                    rows[i]!.ranges[j] = null;
                  }
                } else if (insertOptions == ExcelInsertOptions.formatAsAfter) {
                  if (rows[i]!.ranges[j + 1] != null) {
                    rows[i]!.ranges[j] = Range(this);
                    rows[i]!.ranges[j]!._index = j;
                    rows[i]!.ranges[j]!.row = rows[i]!.ranges[j + 1]!.row;
                    rows[i]!.ranges[j]!.lastRow =
                        rows[i]!.ranges[j + 1]!.lastRow;
                    rows[i]!.ranges[j]!.column =
                        rows[i]!.ranges[j + 1]!.column - 1;
                    rows[i]!.ranges[j]!.lastColumn =
                        rows[i]!.ranges[j + 1]!.lastColumn - 1;
                    rows[i]!.ranges[j]!.cellStyle =
                        rows[i]!.ranges[j + 1]!.cellStyle;
                  } else {
                    rows[i]!.ranges[j] = null;
                  }
                } else {
                  rows[i]!.ranges[j] = null;
                }
              } else {
                rows[i]!.ranges[j] = null;
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
      if (insertOptions == ExcelInsertOptions.formatAsAfter) {
        for (int count = 1; count <= columnCount; count++) {
          for (int j = lastColumn + columnCount; j > columnIndex; j--) {
            if (j > 1) {
              if (columns[j] == null && columns[j - 1] == null) {
                columns[j - 1] = Column(this);
                columns[j - 1]!.index = j - 1;
                columns[j] = Column(this);
                columns[j]!.index = j;
              } else if (columns[j] == null && columns[j - 1] != null) {
                columns[j] = Column(this);
                columns[j]!.index = j;
                columns[j]!.width = columns[j - 1]!.width;
              } else if (columns[j] != null && columns[j - 1] == null) {
                columns[j - 1] = Column(this);
                columns[j - 1]!.index = j - 1;
                columns[j]!.width = columns[j - 1]!.width;
              } else {
                columns[j]!.width = columns[j - 1]!.width;
              }
            } else {
              if (columns[j] == null) {
                columns[j] = Column(this);
                columns[j]!.index = j;
              }
              columns[j]!.width = 0.0;
            }
          }
        }
      } else if (insertOptions == ExcelInsertOptions.formatAsBefore ||
          insertOptions == ExcelInsertOptions.formatDefault) {
        for (int count = 1; count <= columnCount; count++) {
          for (int j = lastColumn + columnCount; j >= columnIndex; j--) {
            if (j > 1) {
              if (columns[j] == null && columns[j - 1] == null) {
                columns[j - 1] = Column(this);
                columns[j - 1]!.index = j - 1;
                columns[j] = Column(this);
                columns[j]!.index = j;
              } else if (columns[j] == null && columns[j - 1] != null) {
                columns[j] = Column(this);
                columns[j]!.index = j;
                columns[j]!.width = columns[j - 1]!.width;
              } else if (columns[j] != null && columns[j - 1] == null) {
                columns[j - 1] = Column(this);
                columns[j - 1]!.index = j - 1;
                columns[j]!.width = columns[j - 1]!.width;
              } else {
                columns[j]!.width = columns[j - 1]!.width;
              }
            } else {
              if (columns[j] == null) {
                columns[j] = Column(this);
                columns[j]!.index = j;
              }
              columns[j]!.width = 0.0;
            }
          }
        }
      }
      if (insertOptions == ExcelInsertOptions.formatDefault) {
        for (int z = columnIndex; z < columnIndex + columnCount; z++) {
          if (columns[z] == null) {
            columns[z] = Column(this);
            columns[z]!.index = z;
          }
          columns[z]!.width = 0.0;
        }
      }
    }
  }

  /// Delete the Column in the Worksheet.
  /// ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// Range range = sheet.getRangeByName('A2');
  /// range.setText('Hello');
  /// range = sheet.getRangeByName('C2');
  /// range.setText('World');
  ///
  /// // Delete a column.
  /// sheet.deleteColumn(2, 1);
  ///
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('DeleteRowandColumn.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  void deleteColumn(int columnIndex, [int? columnCount]) {
    if (columnIndex < 1 || columnIndex > workbook._maxColumnCount) {
      throw Exception(
          'Value cannot be less 1 and greater than max column index.');
    }
    columnCount ??= 1;
    if (columnCount < 0) {
      throw Exception('count');
    }
    final int firstRow = getFirstRow();
    final int lastRow = getLastRow();
    final int lastColumn = getLastColumn();
    for (int i = firstRow; i <= lastRow; i++) {
      if (rows[i] != null) {
        for (int count = 1; count <= columnCount; count++) {
          for (int j = columnIndex; j <= lastColumn; j++) {
            final Range? range = rows[i]!.ranges[j];
            if (range != null &&
                j != lastColumn &&
                rows[i]!.ranges[j + 1] != null) {
              rows[i]!.ranges[j] = rows[i]!.ranges[j + 1];
              rows[i]!.ranges[j]!._index = rows[i]!.ranges[j]!._index - 1;
              rows[i]!.ranges[j]!.row = rows[i]!.ranges[j]!.row;
              rows[i]!.ranges[j]!.lastRow = rows[i]!.ranges[j]!.lastRow;
              rows[i]!.ranges[j]!.column = rows[i]!.ranges[j]!.column - 1;
              rows[i]!.ranges[j]!.lastColumn =
                  rows[i]!.ranges[j]!.lastColumn - 1;
            } else if (range == null &&
                j != lastColumn &&
                rows[i]!.ranges[j + 1] != null) {
              rows[i]!.ranges[j] = Range(this);
              rows[i]!.ranges[j] = rows[i]!.ranges[j + 1];
              rows[i]!.ranges[j]!._index = rows[i]!.ranges[j]!._index - 1;
              rows[i]!.ranges[j]!.row = rows[i]!.ranges[j]!.row;
              rows[i]!.ranges[j]!.lastRow = rows[i]!.ranges[j]!.lastRow;
              rows[i]!.ranges[j]!.column = rows[i]!.ranges[j]!.column - 1;
              rows[i]!.ranges[j]!.lastColumn =
                  rows[i]!.ranges[j]!.lastColumn - 1;
            } else if (j == lastColumn &&
                rows[i]!.ranges[j] == rows[i]!.ranges[lastColumn]) {
              rows[i]!.ranges[j] = null;
            } else {
              rows[i]!.ranges[j] = rows[i]!.ranges[j + 1];
            }
          }
        }
      }
    }
    for (int count = 1; count <= columnCount; count++) {
      for (int j = columnIndex; j <= lastColumn + columnCount; j++) {
        if (columns[j] == null && columns[j + 1] == null) {
          columns[j + 1] = Column(this);
          columns[j + 1]!.index = j + 1;
          columns[j] = Column(this);
          columns[j]!.index = j;
        }
        if (columns[j] == null && columns[j + 1] != null) {
          columns[j] = Column(this);
          columns[j]!.index = j;
          columns[j]!.width = columns[j + 1]!.width;
        }
        if (columns[j] != null && columns[j + 1] == null) {
          columns[j + 1] = Column(this);
          columns[j + 1]!.index = j + 1;
          columns[j]!.width = columns[j + 1]!.width;
        } else {
          columns[j]!.width = columns[j + 1]!.width;
        }
      }
    }
  }

  /// Maximum length of the password.
  final int _maxPassWordLength = 255;

  /// Alogrithm name to protect/unprotect worksheet.
  String? _algorithmName;

  /// Random generated Salt for the sheet password.
  late List<int> _saltValue;

  /// Spin count to loop the hash algorithm.
  final int _spinCount = 500;

  /// Hash value to ensure the sheet protected password.
  late List<int> _hashValue;

  /// Gets a value indicating whether worksheet is protected with password.
  bool _isPasswordProtected = false;

  ExcelSheetProtectionOption _prepareProtectionOptions(
      ExcelSheetProtectionOption options) {
    options.content = false;
    return options;
  }

  /// 16-bit hash value of the password.
  int _isPassword = 0;

  /// Represent the flag for sheet protection.
  final List<bool> _flag = <bool>[];

  /// Default password hash value.
  static const int _defPasswordConst = 52811;

  /// Protect the worksheet with specific protection options and password.
  ///  ```dart
  /// //Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1');
  /// range.setText('Worksheet Protected');
  ///
  /// // ExcelSheetProtectionOption.
  /// final ExcelSheetProtectionOption options = ExcelSheetProtectionOption();
  /// options.all = true;
  /// // Protecting the Worksheet by using a Password.
  /// sheet.protect('Password', options);
  ///
  /// //Save and Dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExcelworksheetProtectionAllOption1.xlsx');
  /// workbook.dispose();
  /// ```
  void protect(String password, [ExcelSheetProtectionOption? options]) {
    if (_isPasswordProtected) {
      throw Exception(
          'Sheet is already protected, before use unprotect method');
    }
    if (password.length > _maxPassWordLength) {
      throw Exception(
          "Length of the password can't be more than $_maxPassWordLength");
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
    _algorithmName = _sha512Alogrithm;
    _saltValue = _createSalt(16);
    final Hash algorithm = _getAlgorithm(_algorithmName!);
    List<int> arrPassword = utf8.encode(password).toList();
    arrPassword = _convertCodeUnitsToUnicodeByteArray(arrPassword);
    List<int> temp = _combineArray(_saltValue, arrPassword);
    final List<int> h0 = algorithm.convert(temp).bytes.toList();
    List<int> h1 = h0;
    for (int iterator = 0; iterator < _spinCount; iterator++) {
      final List<int> arrIterator = _getBytes(iterator);
      temp = _combineArray(h1, arrIterator);
      temp = Uint8List.fromList(temp);
      h1 = algorithm.convert(temp).bytes.toList();
    }
    _hashValue = h1;
  }

  /// Creates random salt.
  List<int> _createSalt(int length) {
    if (length <= 0) {
      Exception('length');
    }
    final List<int> result = List<int>.filled(length, 0);
    final Random rnd = Random(Range._toOADate(DateTime.now()).toInt());
    final int iMaxValue = _maxPassWordLength + 1;

    for (int i = 0; i < length; i++) {
      result[i] = rnd.nextInt(iMaxValue);
    }
    return result;
  }

  /// Returns hash value for the password string.
  static int _getPasswordHash(String password) {
    if (password == '') {
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
    return usHash ^ password.length ^ _defPasswordConst;
  }

  /// Convert code units to Unicode byte array.
  static List<int> _convertCodeUnitsToUnicodeByteArray(List<int> codeUnits) {
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
    final List<bool> arrResult = List<bool>.filled(15, false);
    final int usSource = char.codeUnitAt(0);
    int curBit = 1;
    for (int i = 0; i < 15; i++) {
      arrResult[i] = (usSource & curBit) == curBit;
      curBit <<= 1;
    }

    return arrResult;
  }

  /// Rotate bits
  static List<bool> _rotateBits(List<bool> bits, int count) {
    if (bits.isEmpty) {
      return bits;
    }

    if (count < 0) {
      throw Exception("Count can't be less than zero");
    }

    final List<bool> arrResult = List<bool>.filled(bits.length, false);
    // ignore: prefer_final_locals
    for (int i = 0, len = bits.length; i < len; i++) {
      final int newPos = (i + count) % len;
      arrResult[newPos] = bits[i];
    }
    return arrResult;
  }

  /// Converts bits array to UInt16 value.
  static int _getUInt16FromBits(List<bool> bits) {
    if (bits.length > 16) {
      throw Exception('There cannot be more than 16 bits');
    }

    int usResult = 0;
    int curBit = 1;
    for (int i = 0; i < bits.length; i++) {
      if (bits[i]) {
        usResult += curBit;
      }
      curBit <<= 1;
    }

    return usResult;
  }

  /// Represents Protection Attributes
  final List<String> _protectionAttributes = <String>[
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
  final List<bool> _defaultValues = <bool>[
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
      throw Exception('iColumn cannot be less then 1');
    }
    final Column? column = columns[iColumn];

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

  /// Sets column width in pixels for the specified row.
  ///  ```dart
  /// //Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// // set columnWidth in pixels.
  /// sheet.setColumnWidthInPixels(2, 20);
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('ColumnWidth.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  void setColumnWidthInPixels(int iColumnIndex, int columnWidth) {
    final double dColumnWidth = _pixelsToColumnWidth(columnWidth);
    _setColumnWidth(iColumnIndex, dColumnWidth);
  }

  /// Sets Rows Heights in pixels for the specified column.
  ///  ```dart
  /// //Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// // set row height in pixels.
  /// sheet.setRowHeightInPixels(2, 30);
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('RowHeight.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  void setRowHeightInPixels(int iRowIndex, double rowHeight) {
    if (iRowIndex < 1 || iRowIndex > _book._maxRowCount) {
      throw Exception(
          'iRowIndex ,Value cannot be less 1 and greater than max row index.');
    }

    if (rowHeight < 0) {
      throw Exception('value');
    }

    _innerSetRowHeight(iRowIndex, rowHeight, true, 5);
  }

  /// Sets column width for the specified column.
  void _setColumnWidth(int iColumn, double value) {
    if (iColumn < 1 || iColumn > _book._maxColumnCount) {
      throw Exception(
          'Column index cannot be larger then 256 or less then one');
    }
    final double iOldValue = _innerGetColumnWidth(iColumn);
    if (iOldValue != value) {
      Column? colInfo;
      if (iColumn < columns.count) {
        colInfo = columns[iColumn];
      }

      if (colInfo == null) {
        colInfo = Column(this);
        colInfo.index = iColumn;
        colInfo.width = _standardWidth;
        columns[iColumn] = colInfo;
      }

      if (value > 255) {
        value = 255;
      }
      colInfo.width = value;

      // colInfo._isBestFit = isBestFit;
    }
  }

  /// Creates collection with specified argument.
  ConditionalFormats _createCondFormatCollectionWrapper(
      Range range, String value) {
    return _CondFormatCollectionWrapper(range);
  }

  /// Imports an array of objects into a worksheet with specified alignment.
  ///  ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  ///
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// //Initialize the list
  /// final List<Object> list = [
  ///   'Toatal Income',
  ///   20000,
  ///   'On Date',
  ///   DateTime(2021, 11, 11)
  /// ];
  ///
  /// //Import the Object list to Sheet
  /// sheet.importList(list, 1, 1, true);
  ///
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('Importlist.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  int importList(
      List<Object?> arrObject, int firstRow, int firstColumn, bool isVertical) {
    if (firstRow < 1 || firstRow > _book._maxRowCount) {
      throw Exception('firstRow is not proper');
    }

    if (firstColumn < 1 || firstColumn > _book._maxColumnCount) {
      throw Exception('firstColumn is not proper');
    }

    int i = 0;
    int elementsToImport;

    if (isVertical) {
      elementsToImport =
          min(firstRow + arrObject.length - 1, _book._maxRowCount) -
              firstRow +
              1;
    } else {
      elementsToImport =
          min(firstColumn + arrObject.length - 1, _book._maxColumnCount) -
              firstColumn +
              1;
    }

    Range range;
    if (elementsToImport > 0) {
      range = getRangeByIndex(firstRow, firstColumn);
      if (arrObject[i] == null) {
        range.value = null;
      } else {
        range.value = arrObject[i];
      }
    }

    for (i = 1; i < elementsToImport; i++) {
      if (!isVertical) {
        range = getRangeByIndex(firstRow, firstColumn + i);
      } else {
        range = getRangeByIndex(firstRow + i, firstColumn);
      }
      range.value = arrObject[i];
    }

    return i;
  }

  /// Removes the existing freeze panes from the worksheet.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:H10').text = "Freeze panes";
  /// worksheet.getRangeByName('B2').freezePanes();
  /// worksheet.unfreezePanes();
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'UnfreezePanes.xlsx');
  /// workbook.dispose();
  /// ```
  void unfreezePanes() {
    _horizontalSplit = 0;
    _verticalSplit = 0;
    _topLeftCell = '';
    _isfreezePane = false;
  }

  /// Imports collection of ExcelDataRows into a worksheet.
  /// ```dart
  /// //Create a new Excel Document.
  /// final Workbook workbook = Workbook();
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  ///
  /// // Create Data Rows for importing.
  /// final List<ExcelDataRow> dataRows = _buildReportDataRows();
  /// // Import the Data Rows in Worksheet.
  /// sheet.importData(dataRows, 1, 1);
  ///
  /// //Save and Dispose.
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExcelworksheetProtectionAllOption1.xlsx');
  /// workbook.dispose();
  ///
  /// // Custom Report class.
  /// class _Report {
  ///   _Report(String name, int juneToJuly, int julyToDec) {
  ///     salesPerson = name;
  ///     salesJanJune = juneToJuly;
  ///     salesJulyDec = julyToDec;
  ///   }
  ///   late String salesPerson;
  ///   late int salesJanJune;
  ///   late int salesJulyDec;
  /// }
  ///
  /// // Create collection objects for Report class.
  /// List<_Report> _getSalesReports() {
  ///   final List<_Report> reports = List.empty(growable: true);
  ///   reports.add(_Report("Andy Bernard", 45000, 58000));
  ///   reports.add(_Report("Jim Halpert", 34000, 65000));
  ///   reports.add(_Report("Karen Fillippelli", 75000, 64000));
  ///   reports.add(_Report("Phyllis Lapin", 56500, 33600));
  ///   reports.add(_Report("Stanley Hudson", 46500, 52000));
  ///   return reports;
  /// }
  ///
  /// // Create Data Rows with Collection objects of Report class.
  /// List<ExcelDataRow> _buildReportDataRows() {
  ///   List<ExcelDataRow> excelDataRows = [];
  ///   final List<_Report> reports = _getSalesReports();
  ///
  ///   excelDataRows = reports.map<ExcelDataRow>((dataRow) {
  ///     return ExcelDataRow(cells: [
  ///       ExcelDataCell(columnName: 'Sales Person', value: dataRow.salesPerson),
  ///       ExcelDataCell(
  ///           columnName: 'Sales Jan to June', value: dataRow.salesJanJune),
  ///       ExcelDataCell(
  ///           columnName: 'Sales July to Dec', value: dataRow.salesJulyDec),
  ///     ]);
  ///   }).toList();
  ///
  ///   return excelDataRows;
  /// }
  /// ```
  void importData(
      List<ExcelDataRow> excelDataRows, int rowIndex, int colIndex) {
    for (int i = 0; i <= excelDataRows.length; i++) {
      final ExcelDataRow dataRow =
          i > 0 ? excelDataRows[i - 1] : excelDataRows[i];
      for (int j = 0; j < dataRow.cells.length; j++) {
        final ExcelDataCell dataCell = dataRow.cells[j];
        final Range range = getRangeByIndex(rowIndex + i, colIndex + j);
        if (i == 0) {
          range.value = dataCell.columnHeader;
        } else if (dataCell.value != null) {
          if (dataCell.value is Hyperlink) {
            final Hyperlink link = dataCell.value! as Hyperlink;
            hyperlinks.add(range, link.type, link.address, link.screenTip,
                link.textToDisplay);
          } else if (dataCell.value is Picture) {
            final Picture picture = dataCell.value! as Picture;
            picture.row = range.row;
            picture.column = range.column;
            pictures.innerList.add(picture);
            final Hyperlink? link = picture.hyperlink;
            if (link != null) {
              hyperlinks.addImage(
                  picture, link.type, link.address, link.screenTip);
            }
            final int width = picture.width;
            final int height = picture.height;
            if (_innerGetColumnWidth(range.column) <
                _pixelsToColumnWidth(width)) {
              setColumnWidthInPixels(range.column, width);
            }
            if (range.rowHeight < height) {
              range._setRowHeight(
                  _book._convertFromPixel(height.toDouble(), 6), true);
            }
          } else {
            range.value = dataCell.value;
          }
        }
      }
    }
  }

  /// Converts width displayed by Excel to width that should be written into file.
  double _evaluateFileColumnWidth(double realWidth) {
    return _book._widthToFileWidth(realWidth);
  }

  /// Clear the worksheet.
  void _clear() {
    if (_rows != null) {
      _rows!._clear();
    }

    if (_columns != null) {
      _columns!._clear();
    }

    if (_pictures != null) {
      _pictures!._clear();
    }

    if (_tableCollection != null) {
      _tableCollection!._clear();
      _tableCollection = null;
    }

    if (_mdataValidation != null) {
      _mdataValidation!._clear();
      _mdataValidation = null;
    }
  }
}
