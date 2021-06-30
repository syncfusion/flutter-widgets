part of datagrid;

@protected
class _GridIndexResolver {
  // Get the header index in [SfDataGrid].
  static int getHeaderIndex(_DataGridSettings dataGridSettings) {
    final int headerIndex = dataGridSettings.headerLineCount - 1;
    return headerIndex < 0 ? 0 : headerIndex;
  }

  /// Helps to find the column index based on [SfDataGrid.columns] count
  /// In this we will not include the static column like, indent column, row
  /// header etc
  static int resolveToGridVisibleColumnIndex(
      _DataGridSettings dataGridSettings, int columnIndex) {
    if (columnIndex >= dataGridSettings.container.columnCount) {
      return -1;
    }

    return columnIndex;
  }

  /// Help to resolve the record index to [SfDataGrid] position row index.
  static int resolveToRowIndex(
      _DataGridSettings dataGridSettings, int rowIndex) {
    if (rowIndex < 0) {
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

  /// Help to resolve the [SfDataGrid] position row index to record index.
  static int resolveToRecordIndex(
      _DataGridSettings dataGridSettings, int rowIndex) {
    if (rowIndex < 0) {
      return -1;
    }

    if (rowIndex == 0) {
      return 0;
    }

    rowIndex = rowIndex -
        _GridIndexResolver.resolveStartIndexBasedOnPosition(dataGridSettings);
    if (rowIndex >= 0 &&
        rowIndex <= dataGridSettings.source._effectiveRows.length - 1) {
      return rowIndex;
    } else {
      return -1;
    }
  }

  /// Helps to resolve the [SfDataGrid] row column index to record [RowColumnIndex].
  static RowColumnIndex resolveToRecordRowColumnIndex(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    final int rowIndex = _GridIndexResolver.resolveToRecordIndex(
        dataGridSettings, rowColumnIndex.rowIndex);
    final int columnIndex = _GridIndexResolver.resolveToGridVisibleColumnIndex(
        dataGridSettings, rowColumnIndex.columnIndex);
    return RowColumnIndex(rowIndex, columnIndex);
  }

  static RowColumnIndex resolveToRowColumnIndex(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    final int rowIndex = _GridIndexResolver.resolveToRowIndex(
        dataGridSettings, rowColumnIndex.rowIndex);
    final int columnIndex = _GridIndexResolver.resolveToGridVisibleColumnIndex(
        dataGridSettings, rowColumnIndex.columnIndex);
    return RowColumnIndex(rowIndex, columnIndex);
  }

  /// Helps to find the exact starting scrolling row index.
  static int resolveStartIndexBasedOnPosition(
      _DataGridSettings dataGridSettings) {
    return dataGridSettings.headerLineCount;
  }

  /// Helps to find the actual starting scrolling column index
  /// Its ignore the indent column, row header and provide the actual staring
  /// column index
  static int resolveToStartColumnIndex(_DataGridSettings dataGridSettings) => 0;

  /// Helps to resolve the provided column index based on [SfDataGrid] column
  /// order. Its ignore the indent column, row header and provide the exact
  /// column index
  static int resolveToScrollColumnIndex(
          _DataGridSettings dataGridSettings, int gridColumnIndex) =>
      gridColumnIndex;

  /// Get the last index of frozen column in left side view, it will
  /// consider the row header,indent column and frozen column
  static int getLastFrozenColumnIndex(_DataGridSettings dataGridSettings) {
    if (dataGridSettings.frozenColumnsCount <= 0) {
      return -1;
    }

    final int startScrollColumnIndex =
        dataGridSettings.container.frozenColumns - 1;
    return startScrollColumnIndex.isFinite ? startScrollColumnIndex : -1;
  }

  /// Get the  starting index of frozen column in right side view, it
  /// will consider the right frozen pane
  static int getStartFooterFrozenColumnIndex(
      _DataGridSettings dataGridSettings) {
    final int columnsCount = dataGridSettings.container.columnCount;
    if (columnsCount <= 0 || dataGridSettings.footerFrozenColumnsCount <= 0) {
      return -1;
    }

    return columnsCount - dataGridSettings.container.footerFrozenColumns;
  }

  /// Get the last frozen row index in top of data grid, it
  /// will consider the stacked header, header and top frozen pane
  static int getLastFrozenRowIndex(_DataGridSettings dataGridSettings) {
    if (dataGridSettings.frozenRowsCount <= 0) {
      return -1;
    }

    final int rowIndex = dataGridSettings.container.frozenRows - 1;
    return rowIndex.isFinite ? rowIndex : -1;
  }

  /// Get the starting frozen row index in bottom of data grid, it
  /// will consider the bottom table summary and bottom frozen pane
  static int getStartFooterFrozenRowIndex(_DataGridSettings dataGridSettings) {
    final int rowCount = dataGridSettings.container.rowCount;
    if (rowCount <= 0 || dataGridSettings.footerFrozenRowsCount <= 0) {
      return -1;
    }

    final int rowIndex = rowCount - dataGridSettings.container.footerFrozenRows;
    return rowIndex.isFinite ? rowIndex : -1;
  }

  /// Checks whether the row is a footer widget row or not.
  static bool isFooterWidgetRow(
      int rowIndex, _DataGridSettings dataGridSettings) {
    return dataGridSettings.footer != null &&
        rowIndex == dataGridSettings.container.rowCount - 1;
  }
}

@protected
class _StackedHeaderHelper {
  static List<int> _getChildSequence(_DataGridSettings dataGridSettings,
      StackedHeaderCell? column, int rowIndex) {
    final List<int> childSequenceNo = <int>[];

    if (column != null && column.columnNames.isNotEmpty) {
      for (final String child in column.columnNames) {
        final List<GridColumn> columns = dataGridSettings.columns;
        for (int i = 0; i < columns.length; ++i) {
          if (columns[i].columnName == child) {
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
      {String? mappingName, StackedHeaderCell? stackedHeaderCell}) {
    int rowSpan = 0;
    int startIndex = 0;
    int endIndex = 0;
    if (isStackedHeader && stackedHeaderCell != null) {
      final List<List<int>> spannedColumns =
          _getConsecutiveRanges(stackedHeaderCell._childColumnIndexes);
      final List<int>? spannedColumn = spannedColumns.singleWhereOrNull(
          (List<int> element) => element.first == columnIndex);
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
      final StackedHeaderRow stackedHeaderRow =
          dataGridSettings.stackedHeaderRows[rowindex];
      for (final StackedHeaderCell stackedColumn in stackedHeaderRow.cells) {
        if (isStackedHeader) {
          final List<List<int>> columnsRange =
              _getConsecutiveRanges(stackedColumn._childColumnIndexes);
          for (final List<int> column in columnsRange) {
            if ((startIndex >= column.first && startIndex <= column.last) ||
                (endIndex >= column.first && endIndex <= column.last)) {
              return rowSpan;
            }
          }
        } else if (stackedColumn.columnNames.isNotEmpty) {
          final List<String> children = stackedColumn.columnNames;
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
    final List<List<int>> list = <List<int>>[];
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
