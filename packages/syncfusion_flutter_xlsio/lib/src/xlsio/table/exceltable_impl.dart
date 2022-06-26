part of xlsio;

///Represents Implementation of List Object
class _ExcelTableImpl implements ExcelTable {
  /// Initializes new instance of the list object.
  _ExcelTableImpl(String name, Range location, int index) {
    _showHeaderRow = true;
    _showFirstColumn = false;
    _showLastColumn = false;
    _showBandedColumns = false;
    _showBandedRows = true;
    _totalRowCount = 0;
    totalsRowShown = false;
    _alternativeText = '';
    _summary = '';
    _worksheet = location.worksheet;
    displayName = _name = name;
    _location = location;
    _index = index;
    _builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium2;
  }

  /// Represents the variable for checking valid table name.
  int count = 0;

  /// Represents the Variable for incrementing Column index.
  int columnIndex = 0;

  /// Name of the list object.
  late String _name;

  /// List object's columns.
  late List<ExcelTableColumn> _columns = <ExcelTableColumn>[];

  /// Count of rows with totals.
  late int _totalRowCount;

  /// Gets or sets the alternative text description.
  late String _summary;

  /// Gets or sets the alternative text title.
  late String _alternativeText;

  /// Built-in table style index.
  late ExcelTableBuiltInStyle _builtInTableStyle;

  /// Display name.
  late String _displayName;

  /// Location of the list object.
  late Range _location;

  /// A Boolean indicating whether the First Columns are shown.
  late bool _showFirstColumn;

  /// A Boolean indicating whether the Header Row is shown.
  late bool _showHeaderRow;

  /// A Boolean indicating whether the Last Columns are shown.
  late bool _showLastColumn;

  /// Indicates whether column stripes are shown.
  late bool _showBandedColumns;

  /// Indicates whether row stripes are shown.
  late bool _showBandedRows;

  /// Index of the list object.
  late int _index;

  /// Count of rows with totals.
  late bool totalsRowShown;

  /// Represents the Parent worksheet.
  late Worksheet _worksheet;

  /// Gets index of the table in a worksheet. Read-only.
  int get _tableIndex {
    return _index;
  }

  /// Gets or sets a Boolean value indicating whether the Total row is visible.
  @override
  bool get showTotalRow {
    return totalRowCount != 0;
  }

  @override
  set showTotalRow(bool value) {
    if (value != showTotalRow) {
      final Worksheet sheet = _location.worksheet;
      final Workbook book = sheet.workbook;
      final int iMaxRow = book._maxRowCount;

      if (value) {
        totalsRowShown = true;
        if (_location.lastRow < iMaxRow) {
          final Range beforeTotalRow = _worksheet.getRangeByIndex(_location.row,
              _location.column, _location.lastRow, _location.lastColumn);
          _location = _checkTotalsRange(beforeTotalRow);
          _totalRowCount = 1;
        }
      } else {
        _totalRowCount = 0;
      }
    }
  }

  /// Checks for TotalsCalculation and updates Range.
  Range _checkTotalsRange(Range range) {
    if (range.row <= range.lastRow) {
      range = _worksheet.getRangeByIndex(
          range.row, range.column, range.lastRow + 1, range.lastColumn);
    }
    return range;
  }

  /// Gets or sets the alternative text title.
  @override
  String get altTextTitle {
    return _alternativeText;
  }

  @override
  set altTextTitle(String value) {
    _alternativeText = value;
  }

  /// Gets or sets the built-in style for the table.
  @override
  ExcelTableBuiltInStyle get builtInTableStyle {
    return _builtInTableStyle;
  }

  @override
  set builtInTableStyle(ExcelTableBuiltInStyle value) {
    _builtInTableStyle = value;
  }

  /// Gets collection of columns in the table. Read-only.
  @override
  List<ExcelTableColumn> get columns {
    return _columns;
  }

  @override
  set columns(List<ExcelTableColumn> value) {
    _columns = value;
  }

  /// Gets or sets the display name for the table.
  @override
  String get displayName {
    return _displayName;
  }

  @override
  set displayName(String value) {
    _checkValidName(value);
    _displayName = value;
  }

  /// Gets or sets the location of the table in a worksheet.
  @override
  Range get dataRange {
    return _location;
  }

  @override
  set dataRange(Range value) {
    _location = value;
    _updateColumns();
  }

  /// Gets the name of the table.
  String get _tableName {
    return _name;
  }

  /// Gets or sets a Boolean value indicating whether first column format is present.
  @override
  bool get showFirstColumn {
    return _showFirstColumn;
  }

  @override
  set showFirstColumn(bool value) {
    _showFirstColumn = value;
  }

  /// Gets or sets a Boolean value indicating whether to hide/display header row.
  @override
  bool get showHeaderRow {
    return _showHeaderRow;
  }

  @override
  set showHeaderRow(bool value) {
    if (_showHeaderRow != value) {
      if (!_worksheet.workbook._saving) {
        if (value == false) {
          _worksheet
              .getRangeByIndex(dataRange.row, dataRange.column, dataRange.row,
                  dataRange.lastColumn)
              .text = '';
          dataRange = _worksheet.getRangeByIndex(dataRange.row + 1,
              dataRange.column, dataRange.lastRow, dataRange.lastColumn);
        } else {
          final int iHeaderRow = dataRange.row - 1;
          dataRange = _worksheet.getRangeByIndex(iHeaderRow, dataRange.column,
              dataRange.lastRow, dataRange.lastColumn);
          final int iFirstColumn = dataRange.column;

          for (int columnCount = 0;
              columnCount < _columns.length;
              columnCount++) {
            final int iColumn = iFirstColumn + columnCount;
            _worksheet
                .getRangeByIndex(iHeaderRow, iColumn, iHeaderRow, iColumn)
                .text = _columns[columnCount].columnName;
          }
        }
      }
    }
    _showHeaderRow = value;
  }

  /// Gets or sets a Boolean value indicating whether last column format is present.
  @override
  bool get showLastColumn {
    return _showLastColumn;
  }

  @override
  set showLastColumn(bool value) {
    _showLastColumn = value;
  }

  /// Gets or sets a Boolean value indicating whether column stripes should be present.
  @override
  bool get showBandedColumns {
    return _showBandedColumns;
  }

  @override
  set showBandedColumns(bool value) {
    _showBandedColumns = value;
  }

  /// Gets or sets a Boolean value indicating whether row stripes should be present.
  @override
  bool get showBandedRows {
    return _showBandedRows;
  }

  @override
  set showBandedRows(bool value) {
    _showBandedRows = value;
  }

  /// Gets or sets the alternative text description.
  @override
  String get altTextSummary {
    return _summary;
  }

  @override
  set altTextSummary(String value) {
    _summary = value;
  }

  /// Gets number of totals rows in the table. Read-only.
  int get totalRowCount {
    return _totalRowCount;
  }

  void _updateColumns() {
    _columns = <ExcelTableColumn>[];
    final List<String> columnNames = <String>[];

    for (int columnCount = _location.column;
        columnCount <= _location.lastColumn;
        columnCount++) {
      final Range range =
          _worksheet.getRangeByIndex(_location.row, columnCount);
      String? strColumnName = range.text;
      if (strColumnName == null || strColumnName.isEmpty) {
        if (range.numberFormat != 'General') {
          strColumnName = range.displayText;
        } else {
          strColumnName = 'Column${++columnIndex}';
        }

        range.text = strColumnName;
      }
      columnNames.add(strColumnName);
      _columns.add(_ExcelTableColumnImpl(
          strColumnName, _columns.length + 1, this, columnCount));
    }

    _updateColumnNames(columnNames);
  }

  /// Updates column name
  void _updateColumnNames(List<String> columnNames) {
    int iCol = 2;
    int index = 0;
    bool delete = true;
    String name = '';
    String colName = '';
    while (index < _columns.length) {
      if (delete) {
        colName = name = columnNames[index];
        columnNames.removeAt(index);
      }
      if (delete
          // ignore: prefer_contains
          ? columnNames.indexOf(name) >= 0 && columnNames.indexOf(name) < index
          : columnNames.contains(name)) {
        name = colName + (iCol).toString();
        ++iCol;
        delete = false;
      } else {
        delete = true;
        (_columns[index] as _ExcelTableColumnImpl)._setName(name);
        columnNames.insert(index, name);
        index++;
      }
    }
  }

  void _checkValidName(String name) {
    if (name.isEmpty) {
      throw Exception('name');
    }

    if (name.length > 255)
      throw Exception('Name should not be more than 255 characters length.');

    if (int.tryParse(name[0]) != null) {
      throw Exception(
          'This is not a valid name. Name should start with letter or underscore.');
    }
    final List<String> arr = <String>[
      '~',
      '!',
      '@',
      '#',
      r'\$',
      '%',
      '^',
      '&',
      '*',
      '(',
      ')',
      '+',
      '-',
      '{',
      '}',
      '[',
      ']',
      ':',
      ';',
      '<',
      '>',
      ',',
      ' '
    ];

    for (int arrayLength = 0; arrayLength < arr.length; arrayLength++) {
      for (int nameLength = 0; nameLength < name.length; nameLength++) {
        if (arr[arrayLength] == name[nameLength]) {
          count++;
        }
      }
    }
    if (count != 0) {
      throw Exception(
          'This is not a valid name. Name should not contain space or characters not allowed.');
    }
  }
}
