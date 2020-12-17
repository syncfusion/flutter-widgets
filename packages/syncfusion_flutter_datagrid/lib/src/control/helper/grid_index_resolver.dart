part of datagrid;

@protected
class _GridIndexResolver {
  static int getHeaderIndex(_DataGridSettings dataGridSettings) {
    if (dataGridSettings == null) {
      return 0;
    }

    final headerIndex = dataGridSettings.headerLineCount - 1;
    return headerIndex < 0 ? 0 : headerIndex;
  }

  static int resolveToGridVisibleColumnIndex(
      _DataGridSettings dataGridSettings, int columnIndex) {
    if (dataGridSettings == null) {
      return -1;
    }

    final indentColumnCount = 0;
    return columnIndex - indentColumnCount;
  }

  static int resolveToRowIndex(
      _DataGridSettings dataGridSettings, int rowIndex) {
    if (dataGridSettings == null ||
        dataGridSettings.container == null ||
        rowIndex < 0) {
      return -1;
    }

    rowIndex = rowIndex +
        _GridIndexResolver.resolveStartIndexBasedOnPosition(dataGridSettings);
    if (rowIndex >= 0 && rowIndex <= dataGridSettings.container.rowCount) {
      return rowIndex;
    } else {
      return -1;
    }
  }

  static int resolveStartIndexBasedOnPosition(
      _DataGridSettings dataGridSettings) {
    return dataGridSettings != null ? dataGridSettings.headerLineCount : 0;
  }

  static int resolveToRecordIndex(
      _DataGridSettings dataGridSettings, int rowIndex) {
    if (dataGridSettings == null ||
        dataGridSettings.container == null ||
        rowIndex < 0) {
      return -1;
    }

    if (rowIndex == 0) {
      return 0;
    }

    rowIndex = rowIndex -
        _GridIndexResolver.resolveStartIndexBasedOnPosition(dataGridSettings);
    if (rowIndex >= 0 &&
        rowIndex <= dataGridSettings.source._effectiveDataSource.length - 1) {
      return rowIndex;
    } else {
      return -1;
    }
  }

  static int resolveToStartColumnIndex(_DataGridSettings dataGridSettings) => 0;

  static RowColumnIndex resolveToRowColumnIndex(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    final rowIndex = _GridIndexResolver.resolveToRecordIndex(
        dataGridSettings, rowColumnIndex.rowIndex);
    final columnIndex = _GridIndexResolver.resolveToGridVisibleColumnIndex(
        dataGridSettings, rowColumnIndex.columnIndex);
    return RowColumnIndex(rowIndex, columnIndex);
  }

  static int resolveToScrollColumnIndex(
          _DataGridSettings dataGridSettings, int gridColumnIndex) =>
      gridColumnIndex;

  static int getLastFrozenColumnIndex(_DataGridSettings dataGridSettings) {
    if (dataGridSettings.frozenColumnsCount <= 0) {
      return -1;
    }

    final int startScrollColumnIndex =
        _GridIndexResolver.resolveToScrollColumnIndex(
            dataGridSettings, dataGridSettings.container.frozenColumns);
    return startScrollColumnIndex.isFinite ? startScrollColumnIndex - 1 : -1;
  }

  static int getStartFooterFrozenColumnIndex(
      _DataGridSettings dataGridSettings) {
    final columnsCount = dataGridSettings.container.columnCount;
    if (columnsCount <= 0 || dataGridSettings.footerFrozenColumnsCount <= 0) {
      return -1;
    }

    return columnsCount - dataGridSettings.container.footerFrozenColumns;
  }

  static int getLastFrozenRowIndex(_DataGridSettings dataGridSettings) {
    if (dataGridSettings.frozenRowsCount <= 0) {
      return -1;
    }

    final rowIndex = dataGridSettings.container.frozenRows -
        (dataGridSettings.headerLineCount + 1);
    return _GridIndexResolver.resolveToRowIndex(dataGridSettings, rowIndex);
  }

  static int getStartFooterFrozenRowIndex(_DataGridSettings dataGridSettings) {
    final rowCount = dataGridSettings.container.rowCount;
    if (rowCount <= 0 || dataGridSettings.footerFrozenRowsCount <= 0) {
      return -1;
    }

    final rowIndex = rowCount -
        dataGridSettings.container.footerFrozenRows -
        dataGridSettings.headerLineCount;
    return _GridIndexResolver.resolveToRowIndex(dataGridSettings, rowIndex);
  }
}

@protected
class _StackedHeaderHelper {
  static List<int> _getChildSequence(_DataGridSettings dataGridSettings,
      StackedHeaderCell column, int rowIndex) {
    final List<int> childSequenceNo = [];

    if (column != null &&
        (column.columnNames != null || column.columnNames.isNotEmpty)) {
      final childColumns = column.columnNames;
      for (final child in childColumns) {
        final columns = dataGridSettings.columns;
        for (int i = 0; i < columns.length; ++i) {
          if (columns[i].mappingName == child) {
            childSequenceNo.add(i);
            break;
          }
        }
      }
    }
    return childSequenceNo;
  }

  static int _getRowSpan(_DataGridSettings dataGridSettings, int rowindex,
      int columnIndex, bool isStackedHeader,
      {String mappingName, StackedHeaderCell stackedHeaderCell}) {
    int rowSpan = 0;
    int startIndex = 0;
    int endIndex = 0;
    if (isStackedHeader) {
      final List<List<int>> spannedColumns =
          _getConsecutiveRanges(stackedHeaderCell._childColumnIndexes);
      final List<int> spannedColumn = spannedColumns.singleWhere(
          (element) => element.first == columnIndex,
          orElse: () => null);
      if (spannedColumn != null) {
        startIndex = spannedColumn.reduce(min);
        endIndex = startIndex + spannedColumn.length - 1;
      }
      rowindex = rowindex - 1;
    } else {
      if (rowindex >= dataGridSettings.stackedHeaderRows.length) {
        return rowSpan;
      }
    }

    while (rowindex >= 0) {
      final stackedHeaderRow = dataGridSettings.stackedHeaderRows[rowindex];
      for (final stackedColumn in stackedHeaderRow.cells) {
        if (stackedColumn != null && isStackedHeader) {
          final List<List<int>> columnsRange =
              _getConsecutiveRanges(stackedColumn._childColumnIndexes);
          for (final column in columnsRange) {
            if ((startIndex >= column.first && startIndex <= column.last) ||
                (endIndex >= column.first && endIndex <= column.last)) {
              return rowSpan;
            }
          }
        } else if (stackedColumn != null &&
            (stackedColumn.columnNames != null ||
                stackedColumn.columnNames.isNotEmpty)) {
          final children = stackedColumn.columnNames;
          for (int child = 0; child < children.length; child++) {
            if (children[child] == mappingName) {
              return rowSpan;
            }
          }
        }
      }

      rowSpan += 1;
      rowindex -= 1;
    }

    return rowSpan;
  }

  static List<List<int>> _getConsecutiveRanges(List<int> columnsIndex) {
    int endIndex = 1;
    final List<List<int>> list = [];
    if (columnsIndex.isEmpty) {
      return list;
    }
    for (int i = 1; i <= columnsIndex.length; i++) {
      if (i == columnsIndex.length ||
          columnsIndex[i] - columnsIndex[i - 1] != 1) {
        if (endIndex == 1) {
          list.add(columnsIndex.sublist(i - endIndex, (i - endIndex) + 1));
        } else {
          list.add(columnsIndex.sublist(i - endIndex, i));
        }
        endIndex = 1;
      } else {
        endIndex++;
      }
    }
    return list;
  }
}
