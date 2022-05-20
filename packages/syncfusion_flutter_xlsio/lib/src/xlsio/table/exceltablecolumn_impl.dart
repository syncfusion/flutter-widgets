// ignore_for_file: unused_local_variable

part of xlsio;

///Represents Implementation of List Object Column
class _ExcelTableColumnImpl implements ExcelTableColumn {
  /// Initializes new instance of the class.
  _ExcelTableColumnImpl(
      String name, int index, _ExcelTableImpl parentTable, int id) {
    _name = name;
    _index = index;
    _parentTable = parentTable;
    _id = id;
    _totalsCalculation = ExcelTableTotalFormula.none;
    _totalsRowLabel = 'Total';
  }

  /// Column Id of the list object column.
  late int _id;

  /// Name of the list object column.
  late String _name;

  /// Represents the function used for totals calculation.
  late ExcelTableTotalFormula _totalsCalculation;

  /// Label for totals count
  late String _totalsRowLabel;

  /// Index of the list object column.
  late int _index;

  /// Represent the parent table
  late _ExcelTableImpl _parentTable;

  /// Gets column id of current column. Read-only.
  int get _columnId {
    return _id;
  }

  /// Gets or sets the name of the column.
  @override
  String get columnName {
    return _name;
  }

  @override
  set columnName(String value) {
    final Range tableRange = _parentTable.dataRange;
    final int sheetColumnIndex = _getColumnIndex(tableRange);
    final int tableColumnIndex = tableRange.column;
    final int setIndex = sheetColumnIndex - tableColumnIndex;
    final List<String> colNames = <String>[];
    final int firstColumn = tableRange.column - tableColumnIndex;
    final int lastColumn = tableRange.lastColumn - tableColumnIndex;
    for (int columnIndex = firstColumn;
        columnIndex <= lastColumn;
        columnIndex++) {
      colNames.add(_parentTable.columns[columnIndex].columnName);
    }
    colNames.removeAt(setIndex);
    colNames.insert(setIndex, value);
    _parentTable._updateColumnNames(colNames);
    value = colNames[setIndex];
    _setName(value);
  }

  /// Gets column index of current column. Read-only.
  int get _columnIndex {
    return _index;
  }

  /// Get the total cell for the column.
  Range get totalCell {
    final Range location = _parentTable.dataRange;
    return location.worksheet
        .getRangeByIndex(location.lastRow, location.column + _columnIndex - 1);
  }

  /// Gets or sets the function used for totals calculation.
  @override
  ExcelTableTotalFormula get totalFormula {
    return _totalsCalculation;
  }

  @override
  set totalFormula(ExcelTableTotalFormula value) {
    _totalsCalculation = value;

    final Range cell = totalCell;
    final Workbook book = cell.worksheet.workbook;

    const String strComma = ',';
    if (value != ExcelTableTotalFormula.none) {
      cell.formula =
          '=SUBTOTAL(${_getTotalsCalculation(value)}$strComma${_parentTable._tableName}[$columnName])';
      if (value == ExcelTableTotalFormula.count ||
          value == ExcelTableTotalFormula.countNums) {
        cell.numberFormat = 'General';
      }
    } else {
      cell.value = '';
    }
  }

  /// Gets or sets the label for the totals row.
  @override
  String get totalRowLabel {
    return _totalsRowLabel;
  }

  @override
  set totalRowLabel(String value) {
    _totalsRowLabel = value;
    totalCell.value = value;
  }

  /// Find Column Index.
  int _getColumnIndex(Range range) {
    final int iColumn = range.column;
    return iColumn + _columnIndex - 1;
  }

  ///Returns the calculation of selected formula.
  String _getTotalsCalculation(ExcelTableTotalFormula totalsCalcution) {
    switch (totalsCalcution) {
      case ExcelTableTotalFormula.average:
        return '101';

      case ExcelTableTotalFormula.countNums:
        return '102';

      case ExcelTableTotalFormula.count:
        return '103';

      case ExcelTableTotalFormula.max:
        return '104';

      case ExcelTableTotalFormula.min:
        return '105';

      case ExcelTableTotalFormula.custom:
        return '106';

      case ExcelTableTotalFormula.stdDev:
        return '107';

      case ExcelTableTotalFormula.sum:
        return '109';

      case ExcelTableTotalFormula.variable:
        return '110';

      case ExcelTableTotalFormula.none:
        return 'none';
    }
  }

  /// sets Name
  void _setName(String value) {
    final Range tableRange = _parentTable.dataRange;
    final int iRow = tableRange.row;
    final int iColumn = _getColumnIndex(tableRange);

    if (_parentTable.showHeaderRow &&
        (_parentTable._worksheet.getRangeByIndex(iRow, iColumn).text == null ||
            !(_parentTable._worksheet.getRangeByIndex(iRow, iColumn).text ==
                value))) {
      _parentTable._worksheet.getRangeByIndex(iRow, iColumn).text = value;
    }
    _name = value;
  }
}
