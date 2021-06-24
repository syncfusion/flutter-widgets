part of datagrid;

/// Provides functionality to process the row.
class DataRow extends DataRowBase {
  /// Creates [DataCell] for [SfDataGrid] widget.
  DataRow();

  @override
  void _onGenerateVisibleColumns(_VisibleLinesCollection visibleColumnLines) {
    _visibleColumns.clear();

    int startColumnIndex = 0;
    int endColumnIndex = -1;

    for (int i = 0; i < 3; i++) {
      if (i == 0) {
        if (visibleColumnLines.firstBodyVisibleIndex <= 0) {
          continue;
        }

        startColumnIndex = 0;
        endColumnIndex =
            visibleColumnLines[visibleColumnLines.firstBodyVisibleIndex - 1]
                .lineIndex;
      } else if (i == 1) {
        if (visibleColumnLines.firstBodyVisibleIndex <= 0 &&
            visibleColumnLines.lastBodyVisibleIndex < 0) {
          continue;
        }

        if (visibleColumnLines.length >
            visibleColumnLines.firstBodyVisibleIndex) {
          startColumnIndex =
              visibleColumnLines[visibleColumnLines.firstBodyVisibleIndex]
                  .lineIndex;
        } else {
          continue;
        }

        endColumnIndex =
            visibleColumnLines[visibleColumnLines.lastBodyVisibleIndex]
                .lineIndex;
      } else {
        if (visibleColumnLines.firstFooterVisibleIndex >=
            visibleColumnLines.length) {
          continue;
        }

        startColumnIndex =
            visibleColumnLines[visibleColumnLines.firstFooterVisibleIndex]
                .lineIndex;
        endColumnIndex =
            visibleColumnLines[visibleColumnLines.length - 1].lineIndex;
      }

      for (int index = startColumnIndex; index <= endColumnIndex; index++) {
        DataCellBase? dc = _createColumn(index);
        _visibleColumns.add(dc);
        dc = null;
      }
    }
  }

  @override
  void _ensureColumns(_VisibleLinesCollection visibleColumnLines) {
    // Need to ignore footer view Row. because footer view row doesn't have
    // visible columns.
    if (rowType == RowType.footerRow) {
      return;
    }

    for (int i = 0; i < _visibleColumns.length; i++) {
      _visibleColumns[i]._isEnsured = false;
    }

    int startColumnIndex = 0;
    int endColumnIndex = -1;

    for (int i = 0; i < 3; i++) {
      if (i == 0) {
        if (visibleColumnLines.firstBodyVisibleIndex <= 0) {
          continue;
        }

        startColumnIndex = 0;
        endColumnIndex =
            visibleColumnLines[visibleColumnLines.firstBodyVisibleIndex - 1]
                .lineIndex;
      } else if (i == 1) {
        if (visibleColumnLines.firstBodyVisibleIndex <= 0 &&
            visibleColumnLines.lastBodyVisibleIndex < 0) {
          continue;
        }

        if (visibleColumnLines.length >
            visibleColumnLines.firstBodyVisibleIndex) {
          startColumnIndex =
              visibleColumnLines[visibleColumnLines.firstBodyVisibleIndex]
                  .lineIndex;
        } else {
          continue;
        }

        endColumnIndex =
            visibleColumnLines[visibleColumnLines.lastBodyVisibleIndex]
                .lineIndex;
      } else {
        if (visibleColumnLines.firstFooterVisibleIndex >=
            visibleColumnLines.length) {
          continue;
        }

        startColumnIndex =
            visibleColumnLines[visibleColumnLines.firstFooterVisibleIndex]
                .lineIndex;
        endColumnIndex =
            visibleColumnLines[visibleColumnLines.length - 1].lineIndex;
      }

      for (int index = startColumnIndex; index <= endColumnIndex; index++) {
        DataCellBase? dc = _indexer(index);
        if (dc == null) {
          DataCellBase? dataCell = _reUseCell(startColumnIndex, endColumnIndex);

          dataCell ??= _visibleColumns.firstWhereOrNull((DataCellBase col) =>
              col.columnIndex == -1 && col._cellType != CellType.indentCell);

          _updateColumn(dataCell, index);
          dataCell = null;
        }

        dc ??= _visibleColumns
            .firstWhereOrNull((DataCellBase col) => col.columnIndex == index);

        if (dc != null) {
          if (!dc._isVisible) {
            dc._isVisible = true;
          }
        } else {
          dc = _createColumn(index);
          _visibleColumns.add(dc);
        }

        dc._isEnsured = true;
        dc = null;
      }
    }

    for (final DataCellBase col in _visibleColumns) {
      if (!col._isEnsured || col.columnIndex == -1) {
        col._isVisible = false;
      }
    }
  }

  DataCellBase _createColumn(int index) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
    final bool canIncrementHeight = rowType == RowType.headerRow &&
        dataGridSettings.stackedHeaderRows.isNotEmpty;
    final DataCellBase dc = DataCell()
      .._dataRow = this
      ..columnIndex = index
      ..rowIndex = rowIndex;
    dc._key = ObjectKey(dc);
    final int columnIndex = _GridIndexResolver.resolveToGridVisibleColumnIndex(
        dataGridSettings, index);
    dc.gridColumn = dataGridSettings.columns[columnIndex];
    _checkForCurrentCell(dataGridSettings, dc);
    if (rowIndex == _GridIndexResolver.getHeaderIndex(dataGridSettings) &&
        rowIndex >= 0) {
      dc
        .._renderer = dataGridSettings.cellRenderers['ColumnHeader']
        .._cellType = CellType.headerCell;
    } else {
      dc
        .._renderer = dataGridSettings.cellRenderers['TextField']
        .._cellType = CellType.gridCell;
    }
    if (canIncrementHeight) {
      final int rowSpan = _StackedHeaderHelper._getRowSpan(
          dataGridSettings, dc._dataRow!.rowIndex - 1, index, false,
          mappingName: dc.gridColumn!.columnName);
      dc._rowSpan = rowSpan;
    }

    dc._columnElement = dc._onInitializeColumnElement(false);
    return dc;
  }

  DataCellBase? _indexer(int index) {
    for (final DataCellBase column in _visibleColumns) {
      if (column.columnIndex == index) {
        return column;
      }
    }

    return null;
  }

  DataCellBase? _reUseCell(int startColumnIndex, int endColumnIndex) =>
      _visibleColumns.firstWhereOrNull((DataCellBase cell) =>
          cell.gridColumn != null &&
          (cell.columnIndex < 0 ||
              cell.columnIndex < startColumnIndex ||
              cell.columnIndex > endColumnIndex) &&
          !cell._isEnsured &&
          !cell._isEditing);

  void _updateColumn(DataCellBase? dc, int index) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
    final bool canIncrementHeight = rowType == RowType.headerRow &&
        dataGridSettings.stackedHeaderRows.isNotEmpty;
    if (dc != null) {
      if (index < 0 || index >= dataGridSettings.container.columnCount) {
        dc._isVisible = false;
      } else {
        dc
          ..columnIndex = index
          ..rowIndex = rowIndex
          .._key = dc._key
          .._isVisible = true;
        final int columnIndex =
            _GridIndexResolver.resolveToGridVisibleColumnIndex(
                dataGridSettings, index);
        dc.gridColumn = dataGridSettings.columns[columnIndex];
        _checkForCurrentCell(dataGridSettings, dc);
        _updateRenderer(dataGridSettings, dc, dc.gridColumn);
        if (canIncrementHeight) {
          final int rowSpan = _StackedHeaderHelper._getRowSpan(
              dataGridSettings, dc._dataRow!.rowIndex - 1, index, false,
              mappingName: dc.gridColumn!.columnName);
          dc._rowSpan = rowSpan;
        } else {
          dc._rowSpan = 0;
        }
        dc
          .._columnElement = dc._onInitializeColumnElement(false)
          .._isEnsured = true;
      }

      if (dc._isVisible != true) {
        dc._isVisible = true;
      }
    } else {
      dc = _createColumn(index);
      _visibleColumns.add(dc);
    }
  }

  void _updateRenderer(_DataGridSettings dataGridSettings,
      DataCellBase dataColumn, GridColumn? column) {
    GridCellRendererBase? newRenderer;
    if (rowRegion == RowRegion.header && rowType == RowType.headerRow) {
      newRenderer = dataGridSettings.cellRenderers['ColumnHeader'];
      dataColumn._cellType = CellType.headerCell;
    } else {
      newRenderer = dataGridSettings.cellRenderers['TextField'];
      dataColumn._cellType = CellType.gridCell;
    }

    dataColumn._renderer = newRenderer;
    newRenderer = null;
  }

  void _checkForCurrentCell(
      _DataGridSettings dataGridSettings, DataCellBase dc) {
    if (dataGridSettings.navigationMode == GridNavigationMode.cell) {
      final _CurrentCellManager currentCellManager =
          dataGridSettings.currentCell;
      if (currentCellManager.columnIndex != -1 &&
          currentCellManager.rowIndex != -1 &&
          currentCellManager.rowIndex == rowIndex &&
          currentCellManager.columnIndex == dc.columnIndex) {
        dc.isCurrentCell = true;
      } else {
        dc.isCurrentCell = false;
      }
    }
  }
}
