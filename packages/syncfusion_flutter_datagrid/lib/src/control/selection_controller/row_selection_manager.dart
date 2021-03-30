part of datagrid;

/// Processes the row selection operation in [SfDataGrid].
///
/// You can override the available methods in this class to customize the
/// selection operation
/// in DataGrid and set the instance to the [SfDataGrid.selectionManager].
///
/// The following code shows how to change the Enter key behavior by
/// overriding the handleKeyEvent() method in RowSelectionManager,
///
/// ``` dart
/// final CustomSelectionManager _customSelectionManager = CustomSelectionManager();

/// @override
/// Widget build(BuildContext context){
///   return MaterialApp(
///       home: Scaffold(
///           body: SfDataGrid(
///             source: _employeeDataSource,
///             columns: [
///                 GridTextColumn(columnName: 'id', label = Text('ID')),
///                 GridTextColumn(columnName: 'name', label = Text('Name')),
///                 GridTextColumn(columnName: 'designation', label = Text('Designation')),
///                 GridTextColumn(columnName: 'salary', label = Text('Salary')),
///             ],
///             selectionMode: SelectionMode.multiple,
///             navigationMode: GridNavigationMode.cell,
///             selectionManager: _customSelectionManager,
///           ))
///   );
/// }

/// class CustomSelectionManager extends RowSelectionManager{
///     @override
///     void handleKeyEvent(RawKeyEvent keyEvent) {
///         if(keyEvent.logicalKey == LogicalKeyboardKey.enter){
///             //apply your logic
///             return;
///         }

///         super.handleKeyEvent(keyEvent);
///     }
/// }
/// ```
class RowSelectionManager extends SelectionManagerBase {
  /// Creates the [RowSelectionManager] for [SfDataGrid] widget.
  RowSelectionManager() : super();

  RowColumnIndex _pressedRowColumnIndex = RowColumnIndex(-1, -1);

  void _applySelection(RowColumnIndex rowColumnIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();

    final recordIndex = _GridIndexResolver.resolveToRecordIndex(
        dataGridSettings, rowColumnIndex.rowIndex);
    var record = _SelectionHelper.getRecord(dataGridSettings, recordIndex);

    final List<DataGridRow> addedItems = [];
    final List<DataGridRow> removeItems = [];

    if (dataGridSettings.selectionMode == SelectionMode.single) {
      if (record == null || _selectedRows.contains(record)) {
        return;
      }

      if (dataGridSettings.onSelectionChanging != null ||
          dataGridSettings.onSelectionChanged != null) {
        addedItems.add(record);
        if (_selectedRows.selectedRow.isNotEmpty) {
          removeItems.add(_selectedRows.selectedRow.first);
        }
      }

      if (_raiseSelectionChanging(
          newItems: addedItems, oldItems: removeItems)) {
        _clearSelectedRow(dataGridSettings);
        _addSelection(record, dataGridSettings);
        notifyListeners();
        _raiseSelectionChanged(newItems: addedItems, oldItems: removeItems);
      }
      //If user, return false in selection changing, and we should need
      // to update the current cell.
      else if (dataGridSettings.navigationMode == GridNavigationMode.cell) {
        notifyListeners();
      }
    } else if (dataGridSettings.selectionMode == SelectionMode.singleDeselect) {
      if (dataGridSettings.onSelectionChanging != null ||
          dataGridSettings.onSelectionChanged != null) {
        if (_selectedRows.selectedRow.isNotEmpty) {
          removeItems.add(_selectedRows.selectedRow.first);
        }

        if (record != null && !_selectedRows.contains(record)) {
          addedItems.add(record);
        }
      }

      if (_raiseSelectionChanging(
          newItems: addedItems, oldItems: removeItems)) {
        if (record != null && !_selectedRows.contains(record)) {
          _clearSelectedRow(dataGridSettings);
          _addSelection(record, dataGridSettings);
        } else {
          _clearSelectedRow(dataGridSettings);
        }

        notifyListeners();
        _raiseSelectionChanged(newItems: addedItems, oldItems: removeItems);
      }
      //If user, return false in selection changing, and we should need
      // to update the current cell.
      else if (dataGridSettings.navigationMode == GridNavigationMode.cell) {
        notifyListeners();
      }
    } else if (dataGridSettings.selectionMode == SelectionMode.multiple) {
      if (dataGridSettings.onSelectionChanging != null ||
          dataGridSettings.onSelectionChanged != null) {
        if (record != null) {
          if (!_selectedRows.contains(record)) {
            addedItems.add(record);
          } else {
            removeItems.add(record);
          }
        }
      }

      if (_raiseSelectionChanging(
              newItems: addedItems, oldItems: removeItems) &&
          record != null) {
        if (!_selectedRows.contains(record)) {
          _addSelection(record, dataGridSettings);
        } else {
          _removeSelection(record, dataGridSettings);
        }

        notifyListeners();
        _raiseSelectionChanged(newItems: addedItems, oldItems: removeItems);
      }
      //If user, return false in selection changing, and we should need to
      // update the current cell.
      else if (dataGridSettings.navigationMode == GridNavigationMode.cell) {
        notifyListeners();
      }
    }

    record = null;
  }

  void _addSelection(DataGridRow? record, _DataGridSettings dataGridSettings) {
    if (record != null && !_selectedRows.contains(record)) {
      final rowIndex =
          _SelectionHelper.resolveToRowIndex(dataGridSettings, record);
      if (!_selectedRows.selectedRow.contains(record)) {
        _selectedRows.selectedRow.add(record);
        dataGridSettings.controller._selectedRows.add(record);
        _refreshSelection();
        _setRowSelection(rowIndex, dataGridSettings, true);
      }
    }
  }

  void _removeSelection(
      DataGridRow? record, _DataGridSettings dataGridSettings) {
    if (record != null && _selectedRows.contains(record)) {
      final rowIndex =
          _SelectionHelper.resolveToRowIndex(dataGridSettings, record);
      _selectedRows.selectedRow.remove(record);
      dataGridSettings.controller._selectedRows.remove(record);
      _refreshSelection();
      _setRowSelection(rowIndex, dataGridSettings, false);
    }
  }

  void _clearSelectedRow(_DataGridSettings dataGridSettings) {
    if (_selectedRows.selectedRow.isNotEmpty) {
      final selectedItem = _selectedRows.selectedRow.first;
      _removeSelection(selectedItem, dataGridSettings);
    }
  }

  void _clearSelectedRows(_DataGridSettings dataGridSettings) {
    if (_selectedRows.selectedRow.isNotEmpty) {
      for (int i = _selectedRows.selectedRow.length - 1; i >= 0; i--) {
        final selectedItem = _selectedRows.selectedRow[i];
        _removeSelection(selectedItem, dataGridSettings);
      }
    }

    _clearSelection(dataGridSettings);
  }

  void _setRowSelection(
      int rowIndex, _DataGridSettings dataGridSettings, bool isRowSelected) {
    if (dataGridSettings.rowGenerator.items.isEmpty) {
      return;
    }

    var row = dataGridSettings.rowGenerator.items
        .firstWhereOrNull((item) => item.rowIndex == rowIndex);
    if (row != null && row.rowType == RowType.dataRow) {
      row
        .._isDirty = true
        .._dataGridRowAdapter = _SfDataGridHelper.getDataGridRowAdapter(
            dataGridSettings, row._dataGridRow!)
        ..isSelectedRow = isRowSelected;
    }

    row = null;
  }

  void _clearSelection(_DataGridSettings dataGridSettings) {
    _selectedRows.selectedRow.clear();
    dataGridSettings.controller._selectedRows.clear();
    dataGridSettings.controller._selectedRow = null;
    dataGridSettings.controller._selectedIndex = -1;
    for (final dataRow in dataGridSettings.rowGenerator.items) {
      if (dataRow.isSelectedRow) {
        dataRow.isSelectedRow = false;
      }
    }

    _clearCurrentCell(dataGridSettings);
  }

  void _clearCurrentCell(_DataGridSettings dataGridSettings) {
    dataGridSettings.currentCell._removeCurrentCell(dataGridSettings);
  }

  void _refreshSelection() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    _removeUnWantedDataGridRows(dataGridSettings);
    final DataGridRow? _selectedRow = _selectedRows.selectedRow.isNotEmpty
        ? _selectedRows.selectedRow.last
        : null;
    final int _recordIndex = _selectedRow == null
        ? -1
        : dataGridSettings.source._effectiveRows.indexOf(_selectedRow);
    dataGridSettings.controller._selectedIndex = _recordIndex;
    dataGridSettings.controller._selectedRow = _selectedRow;
  }

  void _removeUnWantedDataGridRows(_DataGridSettings dataGridSettings) {
    final List<DataGridRow> duplicateSelectedRows =
        _selectedRows.selectedRow.toList();
    for (final selectedRow in duplicateSelectedRows) {
      final int rowIndex =
          dataGridSettings.source._effectiveRows.indexOf(selectedRow);
      if (rowIndex.isNegative) {
        _selectedRows.selectedRow.remove(selectedRow);
        dataGridSettings.controller._selectedRows.remove(selectedRow);
      }
    }
  }

  void _addCurrentCell(DataGridRow record, _DataGridSettings dataGridSettings,
      {bool isSelectionChanging = false}) {
    final rowIndex =
        _SelectionHelper.resolveToRowIndex(dataGridSettings, record);

    if (rowIndex <= _GridIndexResolver.getHeaderIndex(dataGridSettings)) {
      return;
    }

    if (dataGridSettings.currentCell.columnIndex > 0) {
      dataGridSettings.currentCell._moveCurrentCellTo(dataGridSettings,
          RowColumnIndex(rowIndex, dataGridSettings.currentCell.columnIndex),
          isSelectionChanged: isSelectionChanging);
    } else {
      final firstVisibleColumnIndex =
          _GridIndexResolver.resolveToStartColumnIndex(dataGridSettings);
      dataGridSettings.currentCell._moveCurrentCellTo(
          dataGridSettings, RowColumnIndex(rowIndex, firstVisibleColumnIndex),
          isSelectionChanged: isSelectionChanging);
    }
  }

  void _onNavigationModeChanged() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataGridSettings.navigationMode == GridNavigationMode.row) {
      final currentRowColumnIndex = RowColumnIndex(
          dataGridSettings.currentCell.rowIndex,
          dataGridSettings.currentCell.columnIndex);
      _clearCurrentCell(dataGridSettings);
      dataGridSettings.currentCell._updateBorderForMultipleSelection(
          dataGridSettings,
          nextRowColumnIndex: currentRowColumnIndex);
    } else {
      if (dataGridSettings.selectionMode != SelectionMode.none) {
        final lastRecord = dataGridSettings.controller.selectedRow;

        if (lastRecord == null) {
          return;
        }

        final _currentRowColumnIndex =
            _getRowColumnIndexOnModeChanged(dataGridSettings, lastRecord);

        if (_currentRowColumnIndex.rowIndex <= 0) {
          return;
        }

        dataGridSettings.currentCell._moveCurrentCellTo(
            dataGridSettings,
            RowColumnIndex(_currentRowColumnIndex.rowIndex,
                _currentRowColumnIndex.columnIndex),
            isSelectionChanged: true);
      }
    }
  }

  RowColumnIndex _getRowColumnIndexOnModeChanged(
      _DataGridSettings dataGridSettings, DataGridRow? lastRecord) {
    final int rowIndex =
        lastRecord == null && _pressedRowColumnIndex.rowIndex > 0
            ? _pressedRowColumnIndex.rowIndex
            : _SelectionHelper.resolveToRowIndex(dataGridSettings, lastRecord!);

    final int columnIndex = _pressedRowColumnIndex.columnIndex != -1
        ? _pressedRowColumnIndex.columnIndex
        : _GridIndexResolver.resolveToStartColumnIndex(dataGridSettings);

    return RowColumnIndex(rowIndex, columnIndex);
  }

  void _onDataSourceChanged() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    _clearSelection(dataGridSettings);
  }

  @override
  void handleTap(RowColumnIndex rowColumnIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    _pressedRowColumnIndex = rowColumnIndex;
    if (dataGridSettings.selectionMode == SelectionMode.none) {
      return;
    }

    final previousRowColumnIndex = RowColumnIndex(
        dataGridSettings.currentCell.rowIndex,
        dataGridSettings.currentCell.columnIndex);
    if (!dataGridSettings.currentCell
        ._handlePointerOperation(dataGridSettings, rowColumnIndex)) {
      return;
    }

    _processSelection(dataGridSettings, rowColumnIndex, previousRowColumnIndex);
  }

  void _processSelection(
      _DataGridSettings dataGridSettings,
      RowColumnIndex nextRowColumnIndex,
      RowColumnIndex previousRowColumnIndex) {
    // If selectionMode is single. next current cell is going to present in the
    // same selected row.
    // In this case, we don't update the whole data row. Instead of that
    // we have to update next and previous current cell alone and call setState.
    // In other selection mode we will update the whole data row and
    // it will work.
    if (dataGridSettings.selectionMode == SelectionMode.single &&
        dataGridSettings.navigationMode == GridNavigationMode.cell &&
        nextRowColumnIndex.rowIndex == previousRowColumnIndex.rowIndex &&
        nextRowColumnIndex.columnIndex != previousRowColumnIndex.columnIndex) {
      notifyListeners();
      return;
    }

    _applySelection(nextRowColumnIndex);
  }

  @override
  void handleDataGridSourceChanges() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    _clearSelectedRows(dataGridSettings);
  }

  @override
  void onSelectedRowChanged() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();

    if (dataGridSettings.selectionMode == SelectionMode.none) {
      return;
    }

    final DataGridRow? newValue = dataGridSettings.controller.selectedRow;

    bool canClearSelections() =>
        _selectedRows.selectedRow.isNotEmpty &&
        dataGridSettings.selectionMode != SelectionMode.multiple;

    //If newValue is negative we have clear the whole selection data.
    //In multiple case we shouldn't to clear the collection as well
    // source properties.
    if (newValue == null && canClearSelections()) {
      _clearSelectedRow(dataGridSettings);
      notifyListeners();
      return;
    }

    final int recordIndex =
        dataGridSettings.source._effectiveRows.indexOf(newValue!);
    final int rowIndex =
        _GridIndexResolver.resolveToRowIndex(dataGridSettings, recordIndex);

    if (rowIndex < _GridIndexResolver.getHeaderIndex(dataGridSettings)) {
      return;
    }

    if (!_selectedRows.contains(newValue)) {
      //In multiple case we shouldn't to clear the collection as
      // well source properties.
      if (canClearSelections()) {
        _clearSelectedRow(dataGridSettings);
      }

      if (dataGridSettings.navigationMode == GridNavigationMode.cell) {
        _addCurrentCell(newValue, dataGridSettings, isSelectionChanging: true);
      } else {
        final columnIndex =
            _GridIndexResolver.resolveToStartColumnIndex(dataGridSettings);
        final rowIndex =
            _SelectionHelper.resolveToRowIndex(dataGridSettings, newValue);
        dataGridSettings.currentCell
            ._updateCurrentRowColumnIndex(rowIndex, columnIndex);
      }

      _addSelection(newValue, dataGridSettings);
      notifyListeners();
    }
  }

  @override
  void onSelectedIndexChanged() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();

    if (dataGridSettings.selectionMode == SelectionMode.none) {
      return;
    }

    final int newValue = dataGridSettings.controller.selectedIndex;

    if (dataGridSettings.source._effectiveRows.isEmpty ||
        newValue > dataGridSettings.source._effectiveRows.length) {
      return;
    }

    bool canClearSelections() =>
        _selectedRows.selectedRow.isNotEmpty &&
        dataGridSettings.selectionMode != SelectionMode.multiple;

    //If newValue is negative we have to clear the whole selection data.
    //In multiple case we shouldn't to clear the collection as
    // well source properties.
    if (newValue == -1 && canClearSelections()) {
      _clearSelectedRow(dataGridSettings);
      notifyListeners();
      return;
    }

    final record = _SelectionHelper.getRecord(dataGridSettings, newValue);
    if (record != null && !_selectedRows.contains(record)) {
      //In multiple case we shouldn't to clear the collection as
      // well source properties.
      if (canClearSelections()) {
        _clearSelectedRow(dataGridSettings);
      }

      if (dataGridSettings.navigationMode == GridNavigationMode.cell) {
        _addCurrentCell(record, dataGridSettings, isSelectionChanging: true);
      } else {
        final rowIndex =
            _SelectionHelper.resolveToRowIndex(dataGridSettings, record);
        final columnIndex =
            _GridIndexResolver.resolveToStartColumnIndex(dataGridSettings);
        dataGridSettings.currentCell
            ._updateCurrentRowColumnIndex(rowIndex, columnIndex);
      }

      _addSelection(record, dataGridSettings);
      notifyListeners();
    }
  }

  @override
  void onSelectedRowsChanged() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();

    if (dataGridSettings.selectionMode != SelectionMode.multiple ||
        dataGridSettings.selectionMode == SelectionMode.none) {
      return;
    }

    final List<DataGridRow> newValue =
        dataGridSettings.controller.selectedRows.toList(growable: false);

    if (newValue.isEmpty) {
      _clearSelectedRows(dataGridSettings);
      notifyListeners();
      return;
    }

    _clearSelectedRows(dataGridSettings);
    for (final DataGridRow record in newValue) {
      _addSelection(record, dataGridSettings);
    }

    if (dataGridSettings.navigationMode == GridNavigationMode.cell &&
        _selectedRows.selectedRow.isNotEmpty) {
      final lastRecord = _selectedRows.selectedRow.last;
      _addCurrentCell(lastRecord, dataGridSettings, isSelectionChanging: true);
    } else if (dataGridSettings._isDesktop &&
        dataGridSettings.navigationMode == GridNavigationMode.row) {
      final lastRecord = _selectedRows.selectedRow.last;
      final rowIndex =
          _SelectionHelper.resolveToRowIndex(dataGridSettings, lastRecord);
      dataGridSettings.currentCell._updateBorderForMultipleSelection(
          dataGridSettings,
          nextRowColumnIndex: RowColumnIndex(rowIndex, -1));
    }

    notifyListeners();
  }

  @override
  void onGridSelectionModeChanged() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataGridSettings.selectionMode == SelectionMode.none) {
      _clearSelectedRows(dataGridSettings);
      _pressedRowColumnIndex = RowColumnIndex(-1, -1);
    } else if (dataGridSettings.selectionMode != SelectionMode.none &&
        dataGridSettings.selectionMode != SelectionMode.multiple) {
      var lastRecord = dataGridSettings.controller.selectedRow;
      _clearSelection(dataGridSettings);
      if (dataGridSettings.navigationMode == GridNavigationMode.cell &&
          lastRecord != null) {
        final _currentRowColumnIndex =
            _getRowColumnIndexOnModeChanged(dataGridSettings, lastRecord);

        if (_currentRowColumnIndex.rowIndex <= 0) {
          return;
        }

        lastRecord = dataGridSettings.selectionMode == SelectionMode.single
            ? _SelectionHelper.getRecord(
                dataGridSettings,
                _GridIndexResolver.resolveToRecordIndex(
                    dataGridSettings, _currentRowColumnIndex.rowIndex))
            : lastRecord;

        dataGridSettings.currentCell._moveCurrentCellTo(
            dataGridSettings,
            RowColumnIndex(_currentRowColumnIndex.rowIndex,
                _currentRowColumnIndex.columnIndex),
            isSelectionChanged: true);
      }

      if (lastRecord != null) {
        _addSelection(lastRecord, dataGridSettings);
      }
    } else if (dataGridSettings._isDesktop &&
        dataGridSettings.selectionMode == SelectionMode.multiple) {
      final currentRowColumnIndex =
          RowColumnIndex(dataGridSettings.currentCell.rowIndex, -1);
      dataGridSettings.currentCell._updateBorderForMultipleSelection(
          dataGridSettings,
          nextRowColumnIndex: currentRowColumnIndex);
    }
  }

  @override
  void _onRowColumnChanged(int recordLength, int columnLength) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final currentCell = dataGridSettings.currentCell;

    if (currentCell.rowIndex == -1 && currentCell.columnIndex == -1) {
      return;
    }

    final rowIndex = _GridIndexResolver.resolveToRecordIndex(
        dataGridSettings, currentCell.rowIndex);
    if (recordLength > 0 &&
        rowIndex >= recordLength &&
        currentCell.rowIndex != -1) {
      final startRowIndexIndex =
          _getPreviousRowIndex(dataGridSettings, currentCell.rowIndex);
      currentCell._moveCurrentCellTo(dataGridSettings,
          RowColumnIndex(startRowIndexIndex, currentCell.columnIndex),
          needToUpdateColumn: false);
      _refreshSelection();
    }

    final columnIndex = _GridIndexResolver.resolveToGridVisibleColumnIndex(
        dataGridSettings, currentCell.columnIndex);
    if (columnLength > 0 &&
        columnIndex >= columnLength &&
        currentCell.columnIndex != -1) {
      final startColumnIndex =
          _getPreviousColumnIndex(dataGridSettings, currentCell.columnIndex);
      currentCell._moveCurrentCellTo(dataGridSettings,
          RowColumnIndex(currentCell.rowIndex, startColumnIndex),
          needToUpdateColumn: false);
    }
  }

  @override
  void _updateSelectionController(
      {bool isSelectionModeChanged = false,
      bool isNavigationModeChanged = false,
      bool isDataSourceChanged = false}) {
    if (isDataSourceChanged) {
      _onDataSourceChanged();
    }

    if (isSelectionModeChanged) {
      onGridSelectionModeChanged();
    }

    if (isNavigationModeChanged) {
      _onNavigationModeChanged();
    }
  }

  @override
  void _handleSelectionPropertyChanged(
      {RowColumnIndex? rowColumnIndex,
      String? propertyName,
      bool recalculateRowHeight = false}) {
    switch (propertyName) {
      case 'selectedIndex':
        onSelectedIndexChanged();
        break;
      case 'selectedRow':
        onSelectedRowChanged();
        break;
      case 'selectedRows':
        onSelectedRowsChanged();
        break;
      default:
        break;
    }
  }

  //KeyNavigation
  @override
  void handleKeyEvent(RawKeyEvent keyEvent) {
    if (keyEvent.logicalKey == LogicalKeyboardKey.tab) {
      _processKeyTab(keyEvent);
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.home) {
      final _DataGridSettings dataGridSettings = _dataGridStateDetails();
      _processHomeKey(dataGridSettings, keyEvent);
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.end) {
      final _DataGridSettings dataGridSettings = _dataGridStateDetails();
      _processEndKey(dataGridSettings, keyEvent);
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.pageUp) {
      _processPageUp();
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.pageDown) {
      _processPageDown();
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp) {
      _processKeyUp(keyEvent);
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown ||
        keyEvent.logicalKey == LogicalKeyboardKey.enter) {
      _processKeyDown(keyEvent);
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.arrowLeft) {
      final _DataGridSettings dataGridSettings = _dataGridStateDetails();
      if (dataGridSettings.textDirection == TextDirection.rtl) {
        _processKeyRight(dataGridSettings, keyEvent);
      } else {
        _processKeyLeft(dataGridSettings, keyEvent);
      }
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.arrowRight) {
      final _DataGridSettings dataGridSettings = _dataGridStateDetails();
      if (dataGridSettings.textDirection == TextDirection.rtl) {
        _processKeyLeft(dataGridSettings, keyEvent);
      } else {
        _processKeyRight(dataGridSettings, keyEvent);
      }
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.keyA) {
      if (keyEvent.isControlPressed) {
        _processSelectedAll();
      }
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.space) {
      _processSpaceKey();
    }
  }

  void _processEndKey(
      _DataGridSettings dataGridSettings, RawKeyEvent keyEvent) {
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;
    final int lastCellIndex =
        _SelectionHelper.getLastCellIndex(dataGridSettings);
    final needToScrollToMinOrMaxExtent =
        dataGridSettings.container.extentWidth > dataGridSettings.viewWidth
            ? true
            : false;

    if (needToScrollToMinOrMaxExtent) {
      _SelectionHelper.scrollInViewFromLeft(dataGridSettings,
          needToScrollMaxExtent: true);
    }

    if (keyEvent.isControlPressed &&
        keyEvent.logicalKey != LogicalKeyboardKey.arrowRight) {
      final lastRowIndex =
          _SelectionHelper.getLastNavigatingRowIndex(dataGridSettings);
      _SelectionHelper.scrollInViewFromTop(dataGridSettings,
          needToScrollToMaxExtent: true);
      _processSelectionAndCurrentCell(
          dataGridSettings, RowColumnIndex(lastRowIndex, lastCellIndex));
    } else {
      _processSelectionAndCurrentCell(dataGridSettings,
          RowColumnIndex(currentCell.rowIndex, lastCellIndex));
    }
  }

  void _processHomeKey(
      _DataGridSettings dataGridSettings, RawKeyEvent keyEvent) {
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;
    final firstCellIndex = _SelectionHelper.getFirstCellIndex(dataGridSettings);
    final needToScrollToMinOrMaxExtend =
        dataGridSettings.container.extentWidth > dataGridSettings.viewWidth
            ? true
            : false;

    if (needToScrollToMinOrMaxExtend) {
      _SelectionHelper.scrollInViewFromRight(dataGridSettings,
          needToScrollToMinExtent: true);
    }

    if (keyEvent.isControlPressed &&
        keyEvent.logicalKey != LogicalKeyboardKey.arrowLeft) {
      final firstRowIndex =
          _SelectionHelper.getFirstNavigatingRowIndex(dataGridSettings);
      _SelectionHelper.scrollInViewFromDown(dataGridSettings,
          needToScrollToMinExtent: true);
      _processSelectionAndCurrentCell(
          dataGridSettings, RowColumnIndex(firstRowIndex, firstCellIndex));
    } else {
      _processSelectionAndCurrentCell(dataGridSettings,
          RowColumnIndex(currentCell.rowIndex, firstCellIndex));
    }
  }

  void _processPageDown() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;
    final index = _SelectionHelper.getNextPageIndex(dataGridSettings);
    if (currentCell.rowIndex != index && index != -1) {
      _processSelectionAndCurrentCell(
          dataGridSettings, RowColumnIndex(index, currentCell.columnIndex));
    }
  }

  void _processPageUp() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;
    final index = _SelectionHelper.getPreviousPageIndex(dataGridSettings);
    if (currentCell.rowIndex != index) {
      _processSelectionAndCurrentCell(
          dataGridSettings, RowColumnIndex(index, currentCell.columnIndex));
    }
  }

  void _processKeyDown(RawKeyEvent keyEvent) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;
    final int nextRowIndex =
        _getNextRowIndex(dataGridSettings, currentCell.rowIndex);
    final lastRowIndex =
        _SelectionHelper.getLastNavigatingRowIndex(dataGridSettings);
    int nextColumnIndex = currentCell.columnIndex;

    if (nextColumnIndex <= 0) {
      nextColumnIndex = _SelectionHelper.getFirstCellIndex(dataGridSettings);
    }

    if (nextRowIndex > lastRowIndex) {
      return;
    }

    if (keyEvent.isControlPressed) {
      _SelectionHelper.scrollInViewFromTop(dataGridSettings,
          needToScrollToMaxExtent: true);
      _processSelectionAndCurrentCell(
          dataGridSettings, RowColumnIndex(lastRowIndex, nextColumnIndex),
          isShiftKeyPressed: keyEvent.isShiftPressed);
    } else {
      _processSelectionAndCurrentCell(
          dataGridSettings, RowColumnIndex(nextRowIndex, nextColumnIndex),
          isShiftKeyPressed: keyEvent.isShiftPressed);
    }
  }

  void _processKeyUp(RawKeyEvent keyEvent) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final currentCell = dataGridSettings.currentCell;
    final int previousRowIndex =
        _getPreviousRowIndex(dataGridSettings, currentCell.rowIndex);

    if (previousRowIndex == currentCell.rowIndex) {
      return;
    }

    if (keyEvent.isControlPressed) {
      final firstRowIndex = _SelectionHelper.getFirstRowIndex(dataGridSettings);
      _SelectionHelper.scrollInViewFromDown(dataGridSettings,
          needToScrollToMinExtent: true);
      _processSelectionAndCurrentCell(dataGridSettings,
          RowColumnIndex(firstRowIndex, currentCell.columnIndex),
          isShiftKeyPressed: keyEvent.isShiftPressed);
    } else {
      _processSelectionAndCurrentCell(dataGridSettings,
          RowColumnIndex(previousRowIndex, currentCell.columnIndex),
          isShiftKeyPressed: keyEvent.isShiftPressed);
    }
  }

  void _processKeyRight(
      _DataGridSettings dataGridSettings, RawKeyEvent keyEvent) {
    if (dataGridSettings.navigationMode == GridNavigationMode.row) {
      return;
    }

    final currentCell = dataGridSettings.currentCell;
    final lastCellIndex = _SelectionHelper.getLastCellIndex(dataGridSettings);
    final nextCellIndex =
        _getNextColumnIndex(dataGridSettings, currentCell.columnIndex);

    if (currentCell.rowIndex <=
            _GridIndexResolver.getHeaderIndex(dataGridSettings) ||
        nextCellIndex > lastCellIndex ||
        currentCell.columnIndex == nextCellIndex) {
      return;
    }

    if (keyEvent.isControlPressed) {
      if (dataGridSettings.textDirection == TextDirection.rtl) {
        _processHomeKey(dataGridSettings, keyEvent);
      } else {
        _processEndKey(dataGridSettings, keyEvent);
      }
    } else {
      currentCell._processCurrentCell(
          dataGridSettings, RowColumnIndex(currentCell.rowIndex, nextCellIndex),
          isSelectionChanged: true);
      if (dataGridSettings.navigationMode == GridNavigationMode.cell) {
        notifyListeners();
      }
    }
  }

  void _processKeyLeft(
      _DataGridSettings dataGridSettings, RawKeyEvent keyEvent) {
    if (dataGridSettings.navigationMode == GridNavigationMode.row) {
      return;
    }

    final currentCell = dataGridSettings.currentCell;
    final int previousCellIndex =
        _getPreviousColumnIndex(dataGridSettings, currentCell.columnIndex);

    if (currentCell.rowIndex <=
            _GridIndexResolver.getHeaderIndex(dataGridSettings) ||
        previousCellIndex <
            _GridIndexResolver.resolveToStartColumnIndex(dataGridSettings)) {
      return;
    }

    if (keyEvent.isControlPressed) {
      if (dataGridSettings.textDirection == TextDirection.rtl) {
        _processEndKey(dataGridSettings, keyEvent);
      } else {
        _processHomeKey(dataGridSettings, keyEvent);
      }
    } else {
      currentCell._processCurrentCell(dataGridSettings,
          RowColumnIndex(currentCell.rowIndex, previousCellIndex),
          isSelectionChanged: true);
      if (dataGridSettings.navigationMode == GridNavigationMode.cell) {
        notifyListeners();
      }
    }
  }

  void _processKeyTab(RawKeyEvent keyEvent) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;
    final lastCellIndex = _SelectionHelper.getLastCellIndex(dataGridSettings);
    final firstCellIndex = _SelectionHelper.getFirstCellIndex(dataGridSettings);
    final int firstRowIndex =
        _SelectionHelper.getFirstRowIndex(dataGridSettings);

    if (dataGridSettings.navigationMode == GridNavigationMode.row ||
        (currentCell.rowIndex < 0 && currentCell.columnIndex < 0)) {
      _processSelectionAndCurrentCell(
          dataGridSettings, RowColumnIndex(firstRowIndex, firstCellIndex));
      notifyListeners();
      return;
    }

    final needToScrollToMinOrMaxExtend =
        dataGridSettings.container.extentWidth > dataGridSettings.viewWidth
            ? true
            : false;

    if (keyEvent.isShiftPressed) {
      if (currentCell.columnIndex == firstCellIndex &&
          currentCell.rowIndex == firstRowIndex) {
        return;
      }

      if (currentCell.columnIndex == firstCellIndex) {
        final previousRowIndex =
            _getPreviousRowIndex(dataGridSettings, currentCell.rowIndex);
        if (needToScrollToMinOrMaxExtend) {
          _SelectionHelper.scrollInViewFromLeft(dataGridSettings,
              needToScrollMaxExtent: needToScrollToMinOrMaxExtend);
        }
        _processSelectionAndCurrentCell(
            dataGridSettings, RowColumnIndex(previousRowIndex, lastCellIndex));
      } else {
        _processKeyLeft(dataGridSettings, keyEvent);
      }
    } else {
      if (currentCell.columnIndex == lastCellIndex) {
        final nextRowIndex =
            _getNextRowIndex(dataGridSettings, currentCell.rowIndex);
        if (needToScrollToMinOrMaxExtend) {
          _SelectionHelper.scrollInViewFromRight(dataGridSettings,
              needToScrollToMinExtent: needToScrollToMinOrMaxExtend);
        }
        _processSelectionAndCurrentCell(
            dataGridSettings, RowColumnIndex(nextRowIndex, firstCellIndex));
      } else {
        _processKeyRight(dataGridSettings, keyEvent);
      }
    }
  }

  void _processSelectedAll() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataGridSettings.selectionMode != SelectionMode.multiple) {
      return;
    }

    final List<DataGridRow> addedItems = [];
    final List<DataGridRow> removeItems = [];
    if (dataGridSettings.onSelectionChanging != null ||
        dataGridSettings.onSelectionChanged != null) {
      addedItems.addAll(dataGridSettings.source._effectiveRows);
    }

    if (_raiseSelectionChanging(oldItems: removeItems, newItems: addedItems)) {
      for (final record in dataGridSettings.source._effectiveRows) {
        if (!_selectedRows.contains(record)) {
          final rowIndex =
              _SelectionHelper.resolveToRowIndex(dataGridSettings, record);
          if (rowIndex != -1 &&
              dataGridSettings.rowGenerator.items
                  .any((row) => row.rowIndex == rowIndex)) {
            _setRowSelection(rowIndex, dataGridSettings, true);
            _selectedRows.selectedRow.add(record);
          } else {
            _selectedRows.selectedRow.add(record);
          }
        }
      }

      dataGridSettings.controller.selectedRows
          .addAll(dataGridSettings.source._effectiveRows);
      _refreshSelection();
      dataGridSettings.container._isDirty = true;
      notifyListeners();
      _raiseSelectionChanged(newItems: addedItems, oldItems: removeItems);
    }
  }

  void _processSpaceKey() {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataGridSettings.selectionMode == SelectionMode.single) {
      return;
    }

    final currentCell = dataGridSettings.currentCell;
    _applySelection(
        RowColumnIndex(currentCell.rowIndex, currentCell.columnIndex));
  }

  void _processSelectionAndCurrentCell(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex,
      {bool isShiftKeyPressed = false, bool isProgrammatic = false}) {
    final previousRowColumnIndex = RowColumnIndex(
        dataGridSettings.currentCell.rowIndex,
        dataGridSettings.currentCell.columnIndex);
    if (isProgrammatic) {
      dataGridSettings.currentCell
          ._moveCurrentCellTo(dataGridSettings, rowColumnIndex);
    } else {
      dataGridSettings.currentCell
          ._processCurrentCell(dataGridSettings, rowColumnIndex);
    }

    if (dataGridSettings.selectionMode == SelectionMode.multiple) {
      dataGridSettings.currentCell._updateBorderForMultipleSelection(
          dataGridSettings,
          nextRowColumnIndex: rowColumnIndex,
          previousRowColumnIndex: previousRowColumnIndex);
      if (isShiftKeyPressed) {
        _processSelection(
            dataGridSettings, rowColumnIndex, previousRowColumnIndex);
      } else {
        notifyListeners();
      }
    }

    _pressedRowColumnIndex = rowColumnIndex;
  }
}
