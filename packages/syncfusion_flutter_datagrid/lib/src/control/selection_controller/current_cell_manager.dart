part of datagrid;

class _CurrentCellManager {
  _CurrentCellManager(_DataGridStateDetails dataGridStateDetails) {
    _dataGridStateDetails = dataGridStateDetails;
  }

  _DataGridStateDetails _dataGridStateDetails;

  int rowIndex = -1;

  int columnIndex = -1;

  bool _handlePointerOperation(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    final previousRowColumnIndex = RowColumnIndex(rowIndex, columnIndex);
    if (rowColumnIndex != previousRowColumnIndex &&
        dataGridSettings.navigationMode != GridNavigationMode.row) {
      if (!_raiseCurrentCellActivating(rowColumnIndex)) {
        return false;
      }
      _setCurrentCell(dataGridSettings, rowColumnIndex.rowIndex,
          rowColumnIndex.columnIndex);
      _raiseCurrentCellActivated(previousRowColumnIndex);
    } else if (dataGridSettings.navigationMode == GridNavigationMode.row &&
        rowIndex != rowColumnIndex.rowIndex) {
      _updateCurrentRowColumnIndex(
          rowColumnIndex.rowIndex, rowColumnIndex.columnIndex);
      _updateBorderForMultipleSelection(dataGridSettings,
          previousRowColumnIndex: previousRowColumnIndex,
          nextRowColumnIndex: rowColumnIndex);
    }

    return true;
  }

  void _setCurrentCell(
      _DataGridSettings dataGridSettings, int rowIndex, int columnIndex,
      [bool needToUpdateColumn = true]) {
    if (this.rowIndex == rowIndex && this.columnIndex == columnIndex) {
      return;
    }

    _removeCurrentCell(dataGridSettings, needToUpdateColumn);
    _updateCurrentRowColumnIndex(rowIndex, columnIndex);
    final dataRowBase = _getDataRow(dataGridSettings, rowIndex);
    if (dataRowBase != null && needToUpdateColumn) {
      final dataCellBase = _getDataCell(dataRowBase, columnIndex);
      if (dataCellBase != null) {
        _setCurrentCellDirty(dataRowBase, dataCellBase, true);
        dataCellBase._updateColumn();
      }
    }

    dataGridSettings.controller?._currentCell =
        _GridIndexResolver.resolveToRowColumnIndex(
            dataGridSettings, RowColumnIndex(rowIndex, columnIndex));
  }

  void _removeCurrentCell(_DataGridSettings dataGridSettings,
      [bool needToUpdateColumn = true]) {
    if (rowIndex == -1 && columnIndex == -1) {
      return;
    }

    final dataRowBase = _getDataRow(dataGridSettings, rowIndex);
    if (dataRowBase != null && needToUpdateColumn) {
      final dataCellBase = _getDataCell(dataRowBase, columnIndex);
      if (dataCellBase != null) {
        _setCurrentCellDirty(dataRowBase, dataCellBase, false);
        dataCellBase._updateColumn();
      }
    }

    _updateCurrentRowColumnIndex(-1, -1);
    dataGridSettings.controller?._currentCell = RowColumnIndex(-1, -1);
  }

  DataRowBase _getDataRow(_DataGridSettings dataGridSettings, int rowIndex) {
    final dataRows = dataGridSettings.rowGenerator.items;
    if (dataRows.isEmpty) {
      return null;
    }

    return dataRows.firstWhere((row) => row.rowIndex == rowIndex,
        orElse: () => null);
  }

  DataCellBase _getDataCell(DataRowBase dataRow, int columnIndex) {
    if (dataRow._visibleColumns.isEmpty) {
      return null;
    }

    return dataRow._visibleColumns.firstWhere(
        (dataCell) => dataCell.columnIndex == columnIndex,
        orElse: () => null);
  }

  void _updateCurrentRowColumnIndex(int rowIndex, int columnIndex) {
    this.rowIndex = rowIndex;
    this.columnIndex = columnIndex;
  }

  void _setCurrentCellDirty(
      DataRowBase dataRow, DataCellBase dataCell, bool enableCurrentCell) {
    dataCell?.isCurrentCell = enableCurrentCell;
    dataCell?._isDirty = true;
    dataRow?.isCurrentRow = enableCurrentCell;
    dataRow?._isDirty = true;
  }

  bool _raiseCurrentCellActivating(RowColumnIndex rowColumnIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataGridSettings.onCurrentCellActivating == null) {
      return true;
    }

    final newRowColumnIndex = _GridIndexResolver.resolveToRowColumnIndex(
        dataGridSettings, rowColumnIndex);
    final oldRowColumnIndex = _GridIndexResolver.resolveToRowColumnIndex(
        dataGridSettings, RowColumnIndex(rowIndex, columnIndex));
    return dataGridSettings.onCurrentCellActivating(
            newRowColumnIndex, oldRowColumnIndex) ??
        true;
  }

  void _raiseCurrentCellActivated(RowColumnIndex previousRowColumnIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataGridSettings.onCurrentCellActivated == null) {
      return;
    }

    final newRowColumnIndex = _GridIndexResolver.resolveToRowColumnIndex(
        dataGridSettings, RowColumnIndex(rowIndex, columnIndex));
    final oldRowColumnIndex = _GridIndexResolver.resolveToRowColumnIndex(
        dataGridSettings, previousRowColumnIndex);
    dataGridSettings.onCurrentCellActivated(
        newRowColumnIndex, oldRowColumnIndex);
  }

  void _moveCurrentCellTo(
      _DataGridSettings dataGridSettings, RowColumnIndex nextRowColumnIndex,
      {bool isSelectionChanged = false, bool needToUpdateColumn = true}) {
    final previousRowColumnIndex = RowColumnIndex(
        dataGridSettings.currentCell.rowIndex,
        dataGridSettings.currentCell.columnIndex);

    _scrollVertical(dataGridSettings, nextRowColumnIndex);
    _scrollHorizontal(dataGridSettings, nextRowColumnIndex);

    if (dataGridSettings.navigationMode == GridNavigationMode.cell) {
      _setCurrentCell(dataGridSettings, nextRowColumnIndex.rowIndex,
          nextRowColumnIndex.columnIndex, needToUpdateColumn);
    } else {
      _updateCurrentRowColumnIndex(
          nextRowColumnIndex.rowIndex, nextRowColumnIndex.columnIndex);
    }

    if (dataGridSettings.selectionMode != SelectionMode.none &&
        dataGridSettings.selectionMode != SelectionMode.multiple &&
        !isSelectionChanged) {
      final rowSelectionController = dataGridSettings.rowSelectionManager;
      if (rowSelectionController is RowSelectionManager) {
        rowSelectionController
          .._processSelection(
              dataGridSettings, nextRowColumnIndex, previousRowColumnIndex)
          .._pressedRowColumnIndex = nextRowColumnIndex;
      }
    }
  }

  void _processCurrentCell(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex,
      {bool isSelectionChanged = false}) {
    if (dataGridSettings.navigationMode == GridNavigationMode.row) {
      _moveCurrentCellTo(dataGridSettings, rowColumnIndex,
          isSelectionChanged: isSelectionChanged);
      return;
    }

    if (_raiseCurrentCellActivating(rowColumnIndex)) {
      _moveCurrentCellTo(dataGridSettings, rowColumnIndex,
          isSelectionChanged: isSelectionChanged);
      _raiseCurrentCellActivated(rowColumnIndex);
    }
  }

  void _scrollHorizontal(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex.columnIndex < columnIndex) {
      if (_SelectionHelper.needToScrollLeft(dataGridSettings, rowColumnIndex)) {
        _SelectionHelper.scrollInViewFromRight(dataGridSettings,
            previousCellIndex: rowColumnIndex.columnIndex);
      }
    }

    if (rowColumnIndex.columnIndex > columnIndex) {
      if (_SelectionHelper.needToScrollRight(
          dataGridSettings, rowColumnIndex)) {
        _SelectionHelper.scrollInViewFromLeft(dataGridSettings,
            nextCellIndex: rowColumnIndex.columnIndex);
      }
    }
  }

  void _scrollVertical(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex.rowIndex < rowIndex) {
      if (_SelectionHelper.needToScrollUp(
          dataGridSettings, rowColumnIndex.rowIndex)) {
        _SelectionHelper.scrollInViewFromDown(dataGridSettings,
            previousRowIndex: rowColumnIndex.rowIndex);
      }
    }

    if (rowColumnIndex.rowIndex > rowIndex) {
      if (_SelectionHelper.needToScrollDown(
          dataGridSettings, rowColumnIndex.rowIndex)) {
        _SelectionHelper.scrollInViewFromTop(dataGridSettings,
            nextRowIndex: rowColumnIndex.rowIndex);
      }
    }
  }

  void _updateBorderForMultipleSelection(_DataGridSettings dataGridSettings,
      {RowColumnIndex previousRowColumnIndex,
      RowColumnIndex nextRowColumnIndex}) {
    if (kIsWeb &&
        dataGridSettings.navigationMode == GridNavigationMode.row &&
        dataGridSettings.selectionMode == SelectionMode.multiple) {
      if (previousRowColumnIndex != null) {
        dataGridSettings.currentCell
            ._getDataRow(dataGridSettings, previousRowColumnIndex.rowIndex)
            ?._isDirty = true;
      }

      final firstVisibleColumnIndex =
          _GridIndexResolver.resolveToStartColumnIndex(dataGridSettings);
      _updateCurrentRowColumnIndex(nextRowColumnIndex?.rowIndex ?? rowIndex,
          nextRowColumnIndex?.columnIndex ?? firstVisibleColumnIndex);
      dataGridSettings.currentCell
          ._getDataRow(
              dataGridSettings, nextRowColumnIndex?.rowIndex ?? rowIndex)
          ?._isDirty = true;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _CurrentCellManager && runtimeType == other.runtimeType;

  @override
  int get hashCode {
    final List<Object> _hashList = [this];
    return hashList(_hashList);
  }
}
