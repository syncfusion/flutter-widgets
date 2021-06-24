part of datagrid;

class _CurrentCellManager {
  _CurrentCellManager({required _DataGridStateDetails dataGridStateDetails}) {
    _dataGridStateDetails = dataGridStateDetails;
  }

  late _DataGridStateDetails _dataGridStateDetails;

  int rowIndex = -1;

  int columnIndex = -1;

  /// Current editing dataCell.
  DataCellBase? dataCell;

  /// Indicate the any [DataGridCell] is in editing state.
  bool isEditing = false;

  bool _handlePointerOperation(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    if (dataGridSettings.allowSwiping) {
      dataGridSettings.container.resetSwipeOffset();
    }
    final RowColumnIndex previousRowColumnIndex =
        RowColumnIndex(rowIndex, columnIndex);
    if (!rowColumnIndex.equals(previousRowColumnIndex) &&
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
    _updateCurrentCell(
        dataGridSettings, rowIndex, columnIndex, needToUpdateColumn);
  }

  void _updateCurrentCell(
      _DataGridSettings dataGridSettings, int rowIndex, int columnIndex,
      [bool needToUpdateColumn = true]) {
    final DataRowBase? dataRowBase = _getDataRow(dataGridSettings, rowIndex);
    if (dataRowBase != null && needToUpdateColumn) {
      final DataCellBase? dataCellBase = _getDataCell(dataRowBase, columnIndex);
      if (dataCellBase != null) {
        dataCell = dataCellBase;
        _setCurrentCellDirty(dataRowBase, dataCellBase, true);
        dataCellBase._updateColumn();
      }
    }

    dataGridSettings.controller._currentCell =
        _GridIndexResolver.resolveToRecordRowColumnIndex(
            dataGridSettings, RowColumnIndex(rowIndex, columnIndex));
  }

  void _removeCurrentCell(_DataGridSettings dataGridSettings,
      [bool needToUpdateColumn = true]) {
    if (rowIndex == -1 && columnIndex == -1) {
      return;
    }

    final DataRowBase? dataRowBase = _getDataRow(dataGridSettings, rowIndex);
    if (dataRowBase != null && needToUpdateColumn) {
      final DataCellBase? dataCellBase = _getDataCell(dataRowBase, columnIndex);
      if (dataCellBase != null) {
        _setCurrentCellDirty(dataRowBase, dataCellBase, false);
        dataCellBase._updateColumn();
      }
    }

    _updateCurrentRowColumnIndex(-1, -1);
    dataGridSettings.controller._currentCell = RowColumnIndex(-1, -1);
  }

  DataRowBase? _getDataRow(_DataGridSettings dataGridSettings, int rowIndex) {
    final List<DataRowBase> dataRows = dataGridSettings.rowGenerator.items;
    if (dataRows.isEmpty) {
      return null;
    }

    return dataRows
        .firstWhereOrNull((DataRowBase row) => row.rowIndex == rowIndex);
  }

  DataCellBase? _getDataCell(DataRowBase dataRow, int columnIndex) {
    if (dataRow._visibleColumns.isEmpty) {
      return null;
    }

    return dataRow._visibleColumns.firstWhereOrNull(
        (DataCellBase dataCell) => dataCell.columnIndex == columnIndex);
  }

  void _updateCurrentRowColumnIndex(int rowIndex, int columnIndex) {
    this.rowIndex = rowIndex;
    this.columnIndex = columnIndex;
  }

  void _setCurrentCellDirty(
      DataRowBase? dataRow, DataCellBase? dataCell, bool enableCurrentCell) {
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

    final RowColumnIndex newRowColumnIndex =
        _GridIndexResolver.resolveToRecordRowColumnIndex(
            dataGridSettings, rowColumnIndex);
    final RowColumnIndex oldRowColumnIndex =
        _GridIndexResolver.resolveToRecordRowColumnIndex(
            dataGridSettings, RowColumnIndex(rowIndex, columnIndex));
    return dataGridSettings.onCurrentCellActivating!(
        newRowColumnIndex, oldRowColumnIndex);
  }

  void _raiseCurrentCellActivated(RowColumnIndex previousRowColumnIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataGridSettings.onCurrentCellActivated == null) {
      return;
    }

    final RowColumnIndex newRowColumnIndex =
        _GridIndexResolver.resolveToRecordRowColumnIndex(
            dataGridSettings, RowColumnIndex(rowIndex, columnIndex));
    final RowColumnIndex oldRowColumnIndex =
        _GridIndexResolver.resolveToRecordRowColumnIndex(
            dataGridSettings, previousRowColumnIndex);
    dataGridSettings.onCurrentCellActivated!(
        newRowColumnIndex, oldRowColumnIndex);
  }

  void _moveCurrentCellTo(
      _DataGridSettings dataGridSettings, RowColumnIndex nextRowColumnIndex,
      {bool isSelectionChanged = false, bool needToUpdateColumn = true}) {
    final RowColumnIndex previousRowColumnIndex = RowColumnIndex(
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
      final SelectionManagerBase rowSelectionController =
          dataGridSettings.rowSelectionManager;
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
      {RowColumnIndex? previousRowColumnIndex,
      RowColumnIndex? nextRowColumnIndex}) {
    if (dataGridSettings._isDesktop &&
        dataGridSettings.navigationMode == GridNavigationMode.row &&
        dataGridSettings.selectionMode == SelectionMode.multiple) {
      if (previousRowColumnIndex != null) {
        dataGridSettings.currentCell
            ._getDataRow(dataGridSettings, previousRowColumnIndex.rowIndex)
            ?._isDirty = true;
      }

      if (nextRowColumnIndex != null) {
        final int firstVisibleColumnIndex =
            _GridIndexResolver.resolveToStartColumnIndex(dataGridSettings);
        _updateCurrentRowColumnIndex(
            nextRowColumnIndex.rowIndex >= 0
                ? nextRowColumnIndex.rowIndex
                : rowIndex,
            nextRowColumnIndex.columnIndex >= 0
                ? nextRowColumnIndex.columnIndex
                : firstVisibleColumnIndex);
        dataGridSettings.currentCell
            ._getDataRow(
                dataGridSettings,
                nextRowColumnIndex.rowIndex >= 0
                    ? nextRowColumnIndex.rowIndex
                    : rowIndex)
            ?._isDirty = true;
      }
    }
  }

  // ------------------------------Editing-------------------------------------

  void _onCellBeginEdit(
      {DataCellBase? editingDataCell,
      RowColumnIndex? editingRowColumnIndex,
      bool isProgrammatic = false,
      bool needToResolveIndex = true}) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();

    final bool checkEditingIsEnabled = dataGridSettings.allowEditing &&
        dataGridSettings.selectionMode != SelectionMode.none &&
        dataGridSettings.navigationMode != GridNavigationMode.row;

    bool checkDataCellIsValidForEditing(DataCellBase? editingDataCell) =>
        editingDataCell != null &&
        editingDataCell.gridColumn!.allowEditing &&
        !editingDataCell._isEditing &&
        editingDataCell._renderer != null &&
        editingDataCell._renderer!._isEditable &&
        editingDataCell._dataRow!.rowType == RowType.dataRow;

    if (!checkEditingIsEnabled ||
        (!isProgrammatic && !checkDataCellIsValidForEditing(editingDataCell))) {
      return;
    }

    // Enable the current cell first to start the on programmatic case.
    if (isProgrammatic) {
      if (editingRowColumnIndex == null ||
          editingRowColumnIndex.rowIndex.isNegative ||
          editingRowColumnIndex.columnIndex.isNegative) {
        return;
      }

      // When editing is initiate from the f2 key, we need not to to resolve
      // the editing row column index because its already resolved based on the
      // SfDataGrid.
      editingRowColumnIndex = needToResolveIndex
          ? _GridIndexResolver.resolveToRowColumnIndex(
              dataGridSettings, editingRowColumnIndex)
          : editingRowColumnIndex;

      if (editingRowColumnIndex.rowIndex.isNegative ||
          editingRowColumnIndex.columnIndex.isNegative ||
          editingRowColumnIndex.columnIndex >
              _SelectionHelper.getLastCellIndex(dataGridSettings) ||
          editingRowColumnIndex.rowIndex >
              _SelectionHelper.getLastRowIndex(dataGridSettings)) {
        return;
      }

      // If the editing is initiate from f2 key, need not to process the
      // handleTap.
      if (needToResolveIndex) {
        dataGridSettings.rowSelectionManager.handleTap(editingRowColumnIndex);
      } else {
        // Need to skip the editing when current cell is not in view and we
        // process initiate the editing from f2 key.
        final DataRowBase? dataRow =
            _getDataRow(dataGridSettings, editingRowColumnIndex.rowIndex);
        if (dataRow != null) {
          dataCell = _getDataCell(dataRow, editingRowColumnIndex.columnIndex);
        } else {
          return;
        }
      }

      editingDataCell = dataCell;
    }

    if (!checkDataCellIsValidForEditing(editingDataCell)) {
      return;
    }

    editingRowColumnIndex = _GridIndexResolver.resolveToRecordRowColumnIndex(
        dataGridSettings,
        RowColumnIndex(editingDataCell!.rowIndex, editingDataCell.columnIndex));

    if (editingRowColumnIndex.rowIndex.isNegative ||
        editingRowColumnIndex.columnIndex.isNegative) {
      return;
    }

    final bool beginEdit = _raiseCellBeginEdit(
        dataGridSettings, editingRowColumnIndex, editingDataCell);

    if (beginEdit) {
      void onCellSubmit() {
        _onCellSubmit(dataGridSettings);
      }

      final Widget? child = dataGridSettings.source.buildEditWidget(
          editingDataCell._dataRow!._dataGridRow!,
          editingRowColumnIndex,
          editingDataCell.gridColumn!,
          onCellSubmit);

      /// If child is null, we will not initiate the editing
      if (child != null) {
        /// Wrapped the editing widget inside the FocusScope.
        /// To bring the focus automatically to editing widget.
        /// canRequestFocus need to set true to auto detect the focus
        /// User need to set the autoFocus to true in their editable widget.
        editingDataCell._editingWidget =
            FocusScope(canRequestFocus: true, child: child);
        editingDataCell._isEditing =
            editingDataCell._dataRow!._isEditing = isEditing = true;

        dataGridSettings.source._notifyDataGridPropertyChangeListeners(
            rowColumnIndex: editingRowColumnIndex, propertyName: 'editing');
      }
    }
  }

  bool _raiseCellBeginEdit(_DataGridSettings dataGridSettings,
      RowColumnIndex rowColumnIndex, DataCellBase dataCell) {
    return dataGridSettings.source.onCellBeginEdit(
        dataCell._dataRow!._dataGridRow!, rowColumnIndex, dataCell.gridColumn!);
  }

  /// Help to end-edit editable widget and refresh the [DataGridCell].
  ///
  /// * isCellCancelEdit - Used to avoid the onCellSubmit behaviour and perform
  /// the cellCancelEdit behaviour,
  /// * Default value is [false].
  /// Case:
  /// 1) Keyboard navigation - Escape key
  ///
  /// * cancelCanCellSubmit - Used to skip the call canCellSubmit.
  /// * Default value is [false].
  /// Case:
  /// 1) In keyboard navigation we will call the canCellSubmit before the
  /// processing the key. So, we need to skip the canCellSubmit second time. so
  /// if we pass the cancelCanCellSubmit to false its will skip it.
  ///
  /// * canRefresh - Used to skip the call notifyListener
  /// * Default value is [true].
  /// Case:
  /// 1) _onCellSubmit is call from handleDataGridSource we no need to call the
  /// _notifyDataGridPropertyChangeListeners to refresh twice.By, set value false
  /// it will skip the refreshing.
  void _onCellSubmit(_DataGridSettings dataGridSettings,
      {bool isCellCancelEdit = false,
      bool cancelCanSubmitCell = false,
      bool canRefresh = true}) {
    if (!isEditing) {
      return;
    }

    final DataRowBase? dataRow = _getEditingRow(dataGridSettings);

    if (dataRow == null) {
      return;
    }

    final DataCellBase? dataCell = _getEditingCell(dataRow);

    if (dataCell == null || !dataCell._isEditing) {
      return;
    }

    if (isEditing) {
      final RowColumnIndex rowColumnIndex =
          _GridIndexResolver.resolveToRecordRowColumnIndex(dataGridSettings,
              RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex));

      if (rowColumnIndex.rowIndex.isNegative ||
          rowColumnIndex.columnIndex.isNegative) {
        return;
      }

      final DataGridRow dataGridRow = dataCell._dataRow!._dataGridRow!;

      void resetEditing() {
        dataCell._editingWidget = null;
        dataCell._isDirty = true;
        dataCell._isEditing = dataRow._isEditing = isEditing = false;
      }

      if (!isCellCancelEdit) {
        bool canSubmitCell = false;

        /// Via keyboard navigation we will check the canCellSubmit before
        /// moving to other cell or another row. so we need to skip the
        /// canCellSubmit method calling once again
        if (!cancelCanSubmitCell) {
          canSubmitCell = dataGridSettings.source
              .canSubmitCell(dataGridRow, rowColumnIndex, dataCell.gridColumn!);
        } else {
          canSubmitCell = true;
        }
        if (canSubmitCell) {
          resetEditing();
          dataGridSettings.source
              .onCellSubmit(dataGridRow, rowColumnIndex, dataCell.gridColumn!);
        }
      } else {
        resetEditing();
        dataGridSettings.source.onCellCancelEdit(
            dataGridRow, rowColumnIndex, dataCell.gridColumn!);
      }

      if (canRefresh) {
        /// Refresh the visible [DataRow]'s on editing the [DataCell] when
        /// sorting enabled
        if (dataGridSettings.allowSorting) {
          dataGridSettings.source._updateDataSource();
          dataGridSettings.container
            .._updateDataGridRows(dataGridSettings)
            .._isDirty = true;
        }

        dataGridSettings.source._notifyDataGridPropertyChangeListeners(
            rowColumnIndex: rowColumnIndex, propertyName: 'editing');
      }

      if (dataGridSettings.dataGridFocusNode != null &&
          !dataGridSettings.dataGridFocusNode!.hasPrimaryFocus) {
        dataGridSettings.dataGridFocusNode!.requestFocus();
      }
    }
  }

  DataRowBase? _getEditingRow(_DataGridSettings dataGridSettings) {
    return dataGridSettings.rowGenerator.items
        .firstWhereOrNull((DataRowBase dataRow) => dataRow._isEditing);
  }

  DataCellBase? _getEditingCell(DataRowBase dataRow) {
    return dataRow._visibleColumns
        .firstWhereOrNull((DataCellBase dataCell) => dataCell._isEditing);
  }

  bool _canSubmitCell(_DataGridSettings dataGridSettings) {
    final DataRowBase? dataRow = _getEditingRow(dataGridSettings);

    if (dataRow == null) {
      return false;
    }

    final DataCellBase? dataCell = _getEditingCell(dataRow);

    if (dataCell == null || !dataCell._isEditing) {
      return false;
    }

    final RowColumnIndex rowColumnIndex =
        _GridIndexResolver.resolveToRecordRowColumnIndex(dataGridSettings,
            RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex));

    if (rowColumnIndex.rowIndex.isNegative ||
        rowColumnIndex.columnIndex.isNegative) {
      return false;
    }

    final DataGridRow dataGridRow = dataCell._dataRow!._dataGridRow!;

    return dataGridSettings.source
        .canSubmitCell(dataGridRow, rowColumnIndex, dataCell.gridColumn!);
  }
}
