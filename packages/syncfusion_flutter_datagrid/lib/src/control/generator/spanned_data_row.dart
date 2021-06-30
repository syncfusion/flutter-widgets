part of datagrid;

/// Provides functionality to process the spanned data row.
class _SpannedDataRow extends DataRow {
  @override
  void _onGenerateVisibleColumns(_VisibleLinesCollection visibleColumnLines) {
    if (visibleColumnLines.isEmpty) {
      return;
    }
    _visibleColumns.clear();

    _SpannedDataColumn dc;
    final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
    if (rowType == RowType.stackedHeaderRow) {
      if (dataGridSettings.stackedHeaderRows.isNotEmpty) {
        final List<StackedHeaderCell> stackedColumns =
            dataGridSettings.stackedHeaderRows[rowIndex].cells;
        for (final StackedHeaderCell column in stackedColumns) {
          final List<List<int>> columnsSequence =
              _StackedHeaderHelper._getConsecutiveRanges(
                  column._childColumnIndexes);

          for (final List<int> columns in columnsSequence) {
            final int columnIndex = columns.reduce(min);
            dc = _createStackedHeaderColumn(
                columnIndex, columns.length - 1, column);
            _visibleColumns.add(dc);
          }
        }
      }
    }
  }

  _SpannedDataColumn _createStackedHeaderColumn(
      int index, int columnSpan, StackedHeaderCell stackedHeaderCell) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
    final GridColumn gridColumn = dataGridSettings.columns[index];
    final int rowSpan = _StackedHeaderHelper._getRowSpan(
        dataGridSettings, rowIndex, index, true,
        stackedHeaderCell: stackedHeaderCell);
    final _SpannedDataColumn dc = _SpannedDataColumn()
      .._dataRow = this
      ..columnIndex = index
      ..rowIndex = rowIndex;
    dc._key = ObjectKey(dc);
    dc
      .._cellType = CellType.stackedHeaderCell
      .._stackedHeaderCell = stackedHeaderCell
      .._columnSpan = columnSpan
      .._rowSpan = rowSpan
      ..gridColumn = gridColumn
      .._isEnsured = true;

    if (rowType == RowType.stackedHeaderRow) {
      dc._renderer = dataGridSettings.cellRenderers['StackedHeader'];
    }
    dc._columnElement = dc._onInitializeColumnElement(false);
    return dc;
  }

  @override
  void _ensureColumns(_VisibleLinesCollection visibleColumnLines) {
    if (rowIndex == -1) {
      return;
    }

    final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
    if (dataGridSettings.stackedHeaderRows.isNotEmpty) {
      final StackedHeaderRow stackedHeaderRow =
          dataGridSettings.stackedHeaderRows[rowIndex];
      final List<StackedHeaderCell> stackedColumns = stackedHeaderRow.cells;
      dataGridSettings.rowGenerator
          ._createStackedHeaderCell(stackedHeaderRow, rowIndex);
      for (final StackedHeaderCell column in stackedColumns) {
        final List<List<int>> columnsSequence =
            _StackedHeaderHelper._getConsecutiveRanges(
                column._childColumnIndexes);

        for (final List<int> columns in columnsSequence) {
          final int actualColumnIndex = columns.reduce(min);
          DataCellBase? dc = _indexer(actualColumnIndex);

          if (dc == null) {
            DataCellBase? dataCell = _reUseCell(
                actualColumnIndex, actualColumnIndex + columns.length - 1);
            dataCell ??= _visibleColumns.firstWhereOrNull((DataCellBase col) =>
                col.columnIndex == -1 && col._cellType != CellType.indentCell);

            _updateStackedHeaderColumn(
                dataCell, actualColumnIndex, columns.length - 1, column);
            dataCell = null;
          }

          dc ??= _visibleColumns.firstWhereOrNull(
              (DataCellBase col) => col.columnIndex == actualColumnIndex);

          if (dc != null) {
            if (!dc._isVisible) {
              dc._isVisible = true;
            }
          } else {
            dc = _createStackedHeaderColumn(
                actualColumnIndex, columns.toList().length - 1, column);
            _visibleColumns.add(dc);
          }

          dc._isEnsured = true;
          dc = null;
        }
      }
    }

    for (final DataCellBase col in _visibleColumns) {
      if (!col._isEnsured || col.columnIndex == -1) {
        col._isVisible = false;
      }
    }
  }

  void _updateStackedHeaderColumn(DataCellBase? dc, int index, int columnSpan,
      StackedHeaderCell stackedHeaderCell) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
    if (dc != null) {
      if (index < 0 || index >= dataGridSettings.container.columnCount) {
        dc._isVisible = false;
      } else {
        final int columnIndex =
            _GridIndexResolver.resolveToGridVisibleColumnIndex(
                dataGridSettings, index);
        final GridColumn gridColumn = dataGridSettings.columns[columnIndex];
        final int rowSpan = _StackedHeaderHelper._getRowSpan(
            dataGridSettings, rowIndex, index, true,
            stackedHeaderCell: stackedHeaderCell);
        dc
          ..columnIndex = index
          ..rowIndex = rowIndex
          .._stackedHeaderCell = stackedHeaderCell
          .._cellType = CellType.stackedHeaderCell
          .._columnSpan = columnSpan
          .._rowSpan = rowSpan
          .._key = dc._key
          .._isVisible = true;
        dc.gridColumn = gridColumn;
        if (rowType == RowType.stackedHeaderRow) {
          dc._renderer = dataGridSettings.cellRenderers['StackedHeader'];
        }
        dc
          .._columnElement = dc._onInitializeColumnElement(false)
          .._isEnsured = true;
      }

      if (dc._isVisible != true) {
        dc._isVisible = true;
      }
    } else {
      dc = _createStackedHeaderColumn(index, columnSpan, stackedHeaderCell);
      _visibleColumns.add(dc);
    }
  }
}

/// Provides functionality to display the spanned cell.
class _SpannedDataColumn extends DataCell {}
