import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide DataCell, DataRow;
import 'package:flutter/services.dart';

import '../../grid_common/row_column_index.dart';
import '../helper/datagrid_configuration.dart';
import '../helper/datagrid_helper.dart' as grid_helper;
import '../helper/enums.dart';
import '../helper/selection_helper.dart' as selection_helper;
import '../runtime/generator.dart';
import '../sfdatagrid.dart';

/// Provides the base functionalities to process the selection in [SfDataGrid].
class SelectionManagerBase extends ChangeNotifier {
  final List<DataGridRow> _selectedRows = <DataGridRow>[];

  //Holds the shift key consecutive row selected item
  final List<DataGridRow> _shiftSelectedRows = <DataGridRow>[];

  /// Holds the [DataGridStateDetails].
  DataGridStateDetails? _dataGridStateDetails;

  /// Processes the selection operation when tap a cell.
  void handleTap(RowColumnIndex rowColumnIndex) {}

  /// Processes the selection operation when [SfDataGrid] receives raw keyboard
  /// event.
  void handleKeyEvent(RawKeyEvent keyEvent) {}

  /// Called when the [SfDataGrid.selectionMode] is changed at run time.
  void onGridSelectionModeChanged() {}

  /// Called when the selection is programmatically changed
  /// using [SfDataGrid.controller].
  void handleDataGridSourceChanges() {}

  /// Called when the selectedRow property in [SfDataGrid.controller]
  /// is changed.
  void onSelectedRowChanged() {}

  /// Called when the selectedIndex property in [SfDataGrid.controller]
  /// is changed.
  void onSelectedIndexChanged() {}

  /// Called when the selectedRows property in [SfDataGrid.controller]
  /// is changed.
  void onSelectedRowsChanged() {}
}

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
///                 GridColumn(columnName: 'id', label = Text('ID')),
///                 GridColumn(columnName: 'name', label = Text('Name')),
///                 GridColumn(columnName: 'designation', label = Text('Designation')),
///                 GridColumn(columnName: 'salary', label = Text('Salary')),
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

  int _pressedRowIndex = -1;

  void _applySelection(RowColumnIndex rowColumnIndex) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();

    final int recordIndex = grid_helper.resolveToRecordIndex(
        dataGridConfiguration, rowColumnIndex.rowIndex);
    DataGridRow? record =
        selection_helper.getRecord(dataGridConfiguration, recordIndex);

    final List<DataGridRow> addedItems = <DataGridRow>[];
    final List<DataGridRow> removeItems = <DataGridRow>[];

    if (dataGridConfiguration.selectionMode == SelectionMode.single) {
      if (record == null || _selectedRows.contains(record)) {
        return;
      }

      if (dataGridConfiguration.onSelectionChanging != null ||
          dataGridConfiguration.onSelectionChanged != null) {
        addedItems.add(record);
        if (_selectedRows.isNotEmpty) {
          removeItems.add(_selectedRows.first);
        }
      }

      if (_raiseSelectionChanging(
          newItems: addedItems, oldItems: removeItems)) {
        _clearSelectedRow(dataGridConfiguration);
        _addSelection(record, dataGridConfiguration);
        notifyListeners();
        _raiseSelectionChanged(newItems: addedItems, oldItems: removeItems);
      }
      //If user, return false in selection changing, and we should need
      // to update the current cell.
      else if (dataGridConfiguration.navigationMode ==
          GridNavigationMode.cell) {
        notifyListeners();
      }
    } else if (dataGridConfiguration.selectionMode ==
        SelectionMode.singleDeselect) {
      if (dataGridConfiguration.onSelectionChanging != null ||
          dataGridConfiguration.onSelectionChanged != null) {
        if (_selectedRows.isNotEmpty) {
          removeItems.add(_selectedRows.first);
        }

        if (record != null && !_selectedRows.contains(record)) {
          addedItems.add(record);
        }
      }

      if (_raiseSelectionChanging(
          newItems: addedItems, oldItems: removeItems)) {
        if (record != null && !_selectedRows.contains(record)) {
          _clearSelectedRow(dataGridConfiguration);
          _addSelection(record, dataGridConfiguration);
        } else {
          _clearSelectedRow(dataGridConfiguration);
        }

        notifyListeners();
        _raiseSelectionChanged(newItems: addedItems, oldItems: removeItems);
      }
      //If user, return false in selection changing, and we should need
      // to update the current cell.
      else if (dataGridConfiguration.navigationMode ==
          GridNavigationMode.cell) {
        notifyListeners();
      }
    } else if (dataGridConfiguration.selectionMode == SelectionMode.multiple) {
      if (dataGridConfiguration.onSelectionChanging != null ||
          dataGridConfiguration.onSelectionChanged != null) {
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
          _addSelection(record, dataGridConfiguration);
        } else {
          _removeSelection(record, dataGridConfiguration);
        }
        notifyListeners();
        _raiseSelectionChanged(newItems: addedItems, oldItems: removeItems);
      }
      //If user, return false in selection changing, and we should need to
      // update the current cell.
      else if (dataGridConfiguration.navigationMode ==
          GridNavigationMode.cell) {
        notifyListeners();
      }
    }

    record = null;
  }

  void _processShiftKeySelection(
      RowColumnIndex rowColumnIndex, int currentRecordIndex) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    List<DataGridRow> addedItems = <DataGridRow>[];
    List<DataGridRow> removedItems = <DataGridRow>[];
    removedItems = _shiftSelectedRows.toList();

    if (dataGridConfiguration.onSelectionChanging != null ||
        dataGridConfiguration.onSelectionChanged != null) {
      addedItems = _getAddedItems(
          _pressedRowIndex, currentRecordIndex, dataGridConfiguration);
      final List<DataGridRow> commonItemsList = addedItems
          .toSet()
          .where((DataGridRow record) => removedItems.toSet().contains(record))
          .toList();
      addedItems = addedItems
          .toSet()
          .where(
              (DataGridRow record) => !_selectedRows.toSet().contains(record))
          .toList();
      removedItems = removedItems
          .toSet()
          .where(
              (DataGridRow record) => !commonItemsList.toSet().contains(record))
          .toList();
    }
    if (_raiseSelectionChanging(newItems: addedItems, oldItems: removedItems)) {
      _addSelectionForShiftKey(currentRecordIndex);
      notifyListeners();
      _raiseSelectionChanged(newItems: addedItems, oldItems: removedItems);
    }
  }

  void _addSelectionForShiftKey(int currentRecordIndex) {
    late DataGridRow? record;
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    if (_shiftSelectedRows.isNotEmpty) {
      for (final DataGridRow record in _shiftSelectedRows) {
        if (record !=
            selection_helper.getRecord(
                dataGridConfiguration, _pressedRowIndex)) {
          _removeSelection(record, dataGridConfiguration);
        }
      }
      _shiftSelectedRows.removeWhere((DataGridRow record) =>
          record !=
          selection_helper.getRecord(dataGridConfiguration, _pressedRowIndex)!);
    }
    if (_pressedRowIndex < currentRecordIndex) {
      for (int rowIndex = _pressedRowIndex + 1;
          rowIndex <= currentRecordIndex;
          rowIndex++) {
        record = selection_helper.getRecord(dataGridConfiguration, rowIndex);
        if (record != null && !_selectedRows.contains(record)) {
          _shiftSelectedRows.add(record);
          _addSelection(record, dataGridConfiguration);
        }
      }
    } else if (_pressedRowIndex > currentRecordIndex) {
      for (int rowIndex = _pressedRowIndex - 1;
          rowIndex >= currentRecordIndex;
          rowIndex--) {
        record = selection_helper.getRecord(dataGridConfiguration, rowIndex);
        if (record != null && !_selectedRows.contains(record)) {
          _shiftSelectedRows.add(record);
          _addSelection(record, dataGridConfiguration);
        }
      }
    }
  }

  List<DataGridRow> _getAddedItems(
      int startIndex, int endIndex, DataGridConfiguration configuration) {
    final List<DataGridRow> addedItems = <DataGridRow>[];
    if (startIndex > endIndex) {
      final int tempIndex = startIndex;
      startIndex = endIndex;
      endIndex = tempIndex;
    }
    for (int i = startIndex; i <= endIndex; i++) {
      addedItems.add(selection_helper.getRecord(configuration, i)!);
    }
    return addedItems;
  }

  void _addSelection(
      DataGridRow? record, DataGridConfiguration dataGridConfiguration) {
    if (record != null && !_selectedRows.contains(record)) {
      final int rowIndex =
          selection_helper.resolveToRowIndex(dataGridConfiguration, record);
      if (!_selectedRows.contains(record)) {
        _selectedRows.add(record);
        dataGridConfiguration.controller.selectedRows.add(record);
        _refreshSelection();
        _setRowSelection(rowIndex, dataGridConfiguration, true);

        /// Check box state should be updated when a row is selected.
        _updateCheckboxStateOnHeader(dataGridConfiguration);
      }
    }
  }

  void _removeSelection(
      DataGridRow? record, DataGridConfiguration dataGridConfiguration) {
    if (record != null && _selectedRows.contains(record)) {
      final int rowIndex =
          selection_helper.resolveToRowIndex(dataGridConfiguration, record);
      _selectedRows.remove(record);
      dataGridConfiguration.controller.selectedRows.remove(record);
      _refreshSelection();
      _setRowSelection(rowIndex, dataGridConfiguration, false);

      /// Check box state should be updated when a row is selected.
      _updateCheckboxStateOnHeader(dataGridConfiguration);
    }
  }

  void _clearSelectedRow(DataGridConfiguration dataGridConfiguration) {
    if (_selectedRows.isNotEmpty) {
      final DataGridRow selectedItem = _selectedRows.first;
      _removeSelection(selectedItem, dataGridConfiguration);
    }
  }

  void _clearSelectedRows(DataGridConfiguration dataGridConfiguration) {
    if (_selectedRows.isNotEmpty) {
      _selectedRows.clear();
      dataGridConfiguration.controller.selectedRows.clear();
      _refreshSelection();
      dataGridConfiguration.container.isDirty = true;
      // Issue:
      // FLUT-6620-The null check operator used on the null value exception occurred
      // While headerCheckboxState is in the intermediate state and deselecting all the selected rows in the Datagrid by using DataGridController.
      // We have resolved the issue by checking if it's null
      if (dataGridConfiguration.headerCheckboxState == null ||
          dataGridConfiguration.headerCheckboxState!) {
        _updateCheckboxStateOnHeader(dataGridConfiguration);
      }
    }

    _clearSelection(dataGridConfiguration);
  }

  void _setRowSelection(int rowIndex,
      DataGridConfiguration dataGridConfiguration, bool isRowSelected) {
    if (dataGridConfiguration.rowGenerator.items.isEmpty) {
      return;
    }

    DataRowBase? row = dataGridConfiguration.rowGenerator.items
        .firstWhereOrNull((DataRowBase item) => item.rowIndex == rowIndex);
    if (row != null && row.rowType == RowType.dataRow) {
      row
        ..isDirty = true
        ..dataGridRowAdapter = grid_helper.getDataGridRowAdapter(
            dataGridConfiguration, row.dataGridRow!)
        ..isSelectedRow = isRowSelected;
    }

    row = null;
  }

  void _clearSelection(DataGridConfiguration dataGridConfiguration) {
    _selectedRows.clear();
    dataGridConfiguration.controller.selectedRows.clear();
    updateSelectedRow(dataGridConfiguration.controller, null);
    updateSelectedIndex(dataGridConfiguration.controller, -1);
    for (final DataRowBase dataRow
        in dataGridConfiguration.rowGenerator.items) {
      if (dataRow.isSelectedRow) {
        dataRow.isSelectedRow = false;
      }
    }

    _clearCurrentCell(dataGridConfiguration);
  }

  void _clearCurrentCell(DataGridConfiguration dataGridConfiguration) {
    dataGridConfiguration.currentCell._removeCurrentCell(dataGridConfiguration);
  }

  void _refreshSelection() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final DataGridRow? selectedRow =
        _selectedRows.isNotEmpty ? _selectedRows.last : null;
    final int recordIndex = selectedRow == null
        ? -1
        : effectiveRows(dataGridConfiguration.source).indexOf(selectedRow);
    updateSelectedRow(dataGridConfiguration.controller, selectedRow);
    updateSelectedIndex(dataGridConfiguration.controller, recordIndex);
  }

  void _addCurrentCell(
      DataGridRow record, DataGridConfiguration dataGridConfiguration,
      {bool isSelectionChanging = false}) {
    final int rowIndex =
        selection_helper.resolveToRowIndex(dataGridConfiguration, record);

    if (rowIndex <= grid_helper.getHeaderIndex(dataGridConfiguration)) {
      return;
    }

    if (dataGridConfiguration.currentCell.columnIndex > 0) {
      dataGridConfiguration.currentCell._moveCurrentCellTo(
          dataGridConfiguration,
          RowColumnIndex(
              rowIndex, dataGridConfiguration.currentCell.columnIndex),
          isSelectionChanged: isSelectionChanging);
    } else {
      final int firstVisibleColumnIndex =
          grid_helper.resolveToStartColumnIndex(dataGridConfiguration);
      dataGridConfiguration.currentCell._moveCurrentCellTo(
          dataGridConfiguration,
          RowColumnIndex(rowIndex, firstVisibleColumnIndex),
          isSelectionChanged: isSelectionChanging);
    }
  }

  void _onNavigationModeChanged() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    if (dataGridConfiguration.navigationMode == GridNavigationMode.row) {
      final RowColumnIndex currentRowColumnIndex = RowColumnIndex(
          dataGridConfiguration.currentCell.rowIndex,
          dataGridConfiguration.currentCell.columnIndex);
      _clearCurrentCell(dataGridConfiguration);
      dataGridConfiguration.currentCell._updateBorderForMultipleSelection(
          dataGridConfiguration,
          nextRowColumnIndex: currentRowColumnIndex);
    } else {
      if (dataGridConfiguration.selectionMode != SelectionMode.none) {
        final DataGridRow? lastRecord =
            dataGridConfiguration.controller.selectedRow;

        if (lastRecord == null) {
          return;
        }

        final RowColumnIndex currentRowColumnIndex =
            _getRowColumnIndexOnModeChanged(dataGridConfiguration, lastRecord);

        if (currentRowColumnIndex.rowIndex <= 0) {
          return;
        }

        // CurrentCell is not drawn when changing the navigation mode at runtime
        // We have to update the particular row and column when current cell
        // index's are same.
        final CurrentCellManager currentCell =
            dataGridConfiguration.currentCell;
        if (currentCell.rowIndex == currentRowColumnIndex.rowIndex &&
            currentCell.columnIndex == currentRowColumnIndex.columnIndex) {
          currentCell._updateCurrentCell(
            dataGridConfiguration,
            currentRowColumnIndex.rowIndex,
            currentRowColumnIndex.columnIndex,
          );
        } else {
          currentCell._moveCurrentCellTo(
              dataGridConfiguration,
              RowColumnIndex(currentRowColumnIndex.rowIndex,
                  currentRowColumnIndex.columnIndex),
              isSelectionChanged: true);
        }
      }
    }
  }

  RowColumnIndex _getRowColumnIndexOnModeChanged(
      DataGridConfiguration dataGridConfiguration, DataGridRow? lastRecord) {
    final int rowIndex =
        lastRecord == null && _pressedRowColumnIndex.rowIndex > 0
            ? _pressedRowColumnIndex.rowIndex
            : selection_helper.resolveToRowIndex(
                dataGridConfiguration, lastRecord!);

    final int columnIndex = _pressedRowColumnIndex.columnIndex != -1
        ? _pressedRowColumnIndex.columnIndex
        : grid_helper.resolveToStartColumnIndex(dataGridConfiguration);

    return RowColumnIndex(rowIndex, columnIndex);
  }

  void _onDataSourceChanged() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    _clearSelection(dataGridConfiguration);
  }

  /// When the selection is applied to a row, we should update the state of the check box also.
  void _updateCheckboxStateOnHeader(
      DataGridConfiguration dataGridConfiguration) {
    if (!dataGridConfiguration.showCheckboxColumn ||
        !dataGridConfiguration.checkboxColumnSettings.showCheckboxOnHeader ||
        dataGridConfiguration.selectionMode == SelectionMode.none) {
      return;
    }

    final DataRowBase? headerDataRow = dataGridConfiguration.rowGenerator.items
        .firstWhereOrNull(
            (DataRowBase dataRow) => dataRow.rowType == RowType.headerRow);

    if (headerDataRow == null) {
      if (dataGridConfiguration.controller.selectedRows.length ==
          dataGridConfiguration.source.rows.length) {
        dataGridConfiguration.headerCheckboxState = true;
      } else if (dataGridConfiguration.controller.selectedRows.isNotEmpty) {
        dataGridConfiguration.headerCheckboxState = null;
      }
      return;
    }

    final DataCellBase? headerDataCell = headerDataRow.visibleColumns
        .firstWhereOrNull((DataCellBase cell) => cell.columnIndex == 0);

    // Issue:
    // FLUT-6617-The null check operator used on the null value exception occurred
    // While selecting and deselecting the same row in the datagrid since the selected rows are empty and headerCheckboxState is null
    // We have resolved the issue by checking the if it's null
    if (_selectedRows.isEmpty &&
        (dataGridConfiguration.headerCheckboxState == null ||
            dataGridConfiguration.headerCheckboxState!)) {
      dataGridConfiguration.headerCheckboxState = false;
      headerDataCell?.updateColumn();
    } else if (dataGridConfiguration.controller.selectedRows.length !=
            effectiveRows(dataGridConfiguration.source).length &&
        dataGridConfiguration.headerCheckboxState != null) {
      dataGridConfiguration.headerCheckboxState = null;
      headerDataCell?.updateColumn();
    } else if (dataGridConfiguration.controller.selectedRows.length ==
            dataGridConfiguration.source.rows.length &&
        dataGridConfiguration.headerCheckboxState != true) {
      dataGridConfiguration.headerCheckboxState = true;
      headerDataCell?.updateColumn();
    }
  }

  @override
  void handleTap(RowColumnIndex rowColumnIndex) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    _pressedRowColumnIndex = rowColumnIndex;
    if (dataGridConfiguration.selectionMode == SelectionMode.none) {
      return;
    }
    final int recordIndex = grid_helper.resolveToRecordIndex(
        dataGridConfiguration, rowColumnIndex.rowIndex);

    final RowColumnIndex previousRowColumnIndex = RowColumnIndex(
        dataGridConfiguration.currentCell.rowIndex,
        dataGridConfiguration.currentCell.columnIndex);
    if (!dataGridConfiguration.currentCell
        ._handlePointerOperation(dataGridConfiguration, rowColumnIndex)) {
      return;
    }
    if (!dataGridConfiguration.isShiftKeyPressed) {
      _pressedRowIndex = recordIndex;
      _shiftSelectedRows.clear();
      _processSelection(
          dataGridConfiguration, rowColumnIndex, previousRowColumnIndex);
    }

    if (dataGridConfiguration.isShiftKeyPressed &&
        dataGridConfiguration.selectionMode == SelectionMode.multiple &&
        _selectedRows.contains(selection_helper.getRecord(
            dataGridConfiguration, _pressedRowIndex))) {
      _processShiftKeySelection(rowColumnIndex, recordIndex);
    }
  }

  void _processSelection(
      DataGridConfiguration dataGridConfiguration,
      RowColumnIndex nextRowColumnIndex,
      RowColumnIndex previousRowColumnIndex) {
    // If selectionMode is single. next current cell is going to present in the
    // same selected row.
    // In this case, we don't update the whole data row. Instead of that
    // we have to update next and previous current cell alone and call setState.
    // In other selection mode we will update the whole data row and
    // it will work.
    if (dataGridConfiguration.selectionMode == SelectionMode.single &&
        dataGridConfiguration.navigationMode == GridNavigationMode.cell &&
        nextRowColumnIndex.rowIndex == previousRowColumnIndex.rowIndex &&
        nextRowColumnIndex.columnIndex != previousRowColumnIndex.columnIndex) {
      notifyListeners();
      return;
    }

    _applySelection(nextRowColumnIndex);
  }

  @override
  void handleDataGridSourceChanges() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    _clearSelectedRows(dataGridConfiguration);
  }

  @override
  void onSelectedRowChanged() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();

    if (dataGridConfiguration.selectionMode == SelectionMode.none) {
      return;
    }

    final DataGridRow? newValue = dataGridConfiguration.controller.selectedRow;

    bool canClearSelections() =>
        _selectedRows.isNotEmpty &&
        dataGridConfiguration.selectionMode != SelectionMode.multiple;

    //If newValue is negative we have clear the whole selection data.
    //In multiple case we shouldn't to clear the collection as well
    // source properties.
    if (newValue == null && canClearSelections()) {
      _clearSelectedRow(dataGridConfiguration);
      notifyListeners();
      return;
    }

    final int recordIndex =
        effectiveRows(dataGridConfiguration.source).indexOf(newValue!);
    final int rowIndex =
        grid_helper.resolveToRowIndex(dataGridConfiguration, recordIndex);

    if (rowIndex < grid_helper.getHeaderIndex(dataGridConfiguration)) {
      return;
    }

    if (!_selectedRows.contains(newValue)) {
      //In multiple case we shouldn't to clear the collection as
      // well source properties.
      if (canClearSelections()) {
        _clearSelectedRow(dataGridConfiguration);
      }

      if (dataGridConfiguration.navigationMode == GridNavigationMode.cell) {
        _addCurrentCell(newValue, dataGridConfiguration,
            isSelectionChanging: true);
      } else {
        final int columnIndex =
            grid_helper.resolveToStartColumnIndex(dataGridConfiguration);
        final int rowIndex =
            selection_helper.resolveToRowIndex(dataGridConfiguration, newValue);
        dataGridConfiguration.currentCell
            ._updateCurrentRowColumnIndex(rowIndex, columnIndex);
      }

      _addSelection(newValue, dataGridConfiguration);
      notifyListeners();
    }
  }

  @override
  void onSelectedIndexChanged() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();

    if (dataGridConfiguration.selectionMode == SelectionMode.none) {
      return;
    }

    final int newValue = dataGridConfiguration.controller.selectedIndex;
    if (effectiveRows(dataGridConfiguration.source).isEmpty ||
        newValue > effectiveRows(dataGridConfiguration.source).length) {
      return;
    }

    bool canClearSelections() =>
        _selectedRows.isNotEmpty &&
        dataGridConfiguration.selectionMode != SelectionMode.multiple;

    //If newValue is negative we have to clear the whole selection data.
    //In multiple case we shouldn't to clear the collection as
    // well source properties.
    if (newValue == -1 && canClearSelections()) {
      _clearSelectedRow(dataGridConfiguration);
      notifyListeners();
      return;
    }

    final DataGridRow? record =
        selection_helper.getRecord(dataGridConfiguration, newValue);
    if (record != null && !_selectedRows.contains(record)) {
      //In multiple case we shouldn't to clear the collection as
      // well source properties.
      if (canClearSelections()) {
        _clearSelectedRow(dataGridConfiguration);
      }

      if (dataGridConfiguration.navigationMode == GridNavigationMode.cell) {
        _addCurrentCell(record, dataGridConfiguration,
            isSelectionChanging: true);
      } else {
        final int rowIndex =
            selection_helper.resolveToRowIndex(dataGridConfiguration, record);
        final int columnIndex =
            grid_helper.resolveToStartColumnIndex(dataGridConfiguration);
        dataGridConfiguration.currentCell
            ._updateCurrentRowColumnIndex(rowIndex, columnIndex);
      }

      _addSelection(record, dataGridConfiguration);
      notifyListeners();
    }
  }

  @override
  void onSelectedRowsChanged() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();

    if (dataGridConfiguration.selectionMode != SelectionMode.multiple ||
        dataGridConfiguration.selectionMode == SelectionMode.none) {
      return;
    }

    final List<DataGridRow> newValue =
        dataGridConfiguration.controller.selectedRows.toList(growable: false);

    if (newValue.isEmpty) {
      _clearSelectedRows(dataGridConfiguration);
      notifyListeners();
      return;
    }

    _clearSelectedRows(dataGridConfiguration);
    _selectedRows.addAll(newValue);
    dataGridConfiguration.controller.selectedRows.addAll(newValue);
    _refreshSelection();
    dataGridConfiguration.container
      ..isDirty = true
      ..refreshView();
    _updateCheckboxStateOnHeader(dataGridConfiguration);

    if (dataGridConfiguration.navigationMode == GridNavigationMode.cell &&
        _selectedRows.isNotEmpty) {
      final DataGridRow lastRecord = _selectedRows.last;
      _addCurrentCell(lastRecord, dataGridConfiguration,
          isSelectionChanging: true);
    } else if (dataGridConfiguration.isDesktop &&
        dataGridConfiguration.navigationMode == GridNavigationMode.row) {
      final DataGridRow lastRecord = _selectedRows.last;
      final int rowIndex =
          selection_helper.resolveToRowIndex(dataGridConfiguration, lastRecord);
      dataGridConfiguration.currentCell._updateBorderForMultipleSelection(
          dataGridConfiguration,
          nextRowColumnIndex: RowColumnIndex(rowIndex, -1));
    }

    notifyListeners();
  }

  @override
  void onGridSelectionModeChanged() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    if (dataGridConfiguration.selectionMode == SelectionMode.none) {
      dataGridConfiguration.headerCheckboxState = false;
      _clearSelectedRows(dataGridConfiguration);
      _pressedRowColumnIndex = RowColumnIndex(-1, -1);
    } else if (dataGridConfiguration.selectionMode != SelectionMode.none &&
        dataGridConfiguration.selectionMode != SelectionMode.multiple) {
      DataGridRow? lastRecord = dataGridConfiguration.controller.selectedRow;
      _clearSelection(dataGridConfiguration);
      if (dataGridConfiguration.navigationMode == GridNavigationMode.cell &&
          lastRecord != null) {
        final RowColumnIndex currentRowColumnIndex =
            _getRowColumnIndexOnModeChanged(dataGridConfiguration, lastRecord);

        if (currentRowColumnIndex.rowIndex <= 0) {
          return;
        }

        lastRecord = dataGridConfiguration.selectionMode == SelectionMode.single
            ? selection_helper.getRecord(
                dataGridConfiguration,
                grid_helper.resolveToRecordIndex(
                    dataGridConfiguration, currentRowColumnIndex.rowIndex))
            : lastRecord;

        dataGridConfiguration.currentCell._moveCurrentCellTo(
            dataGridConfiguration,
            RowColumnIndex(currentRowColumnIndex.rowIndex,
                currentRowColumnIndex.columnIndex),
            isSelectionChanged: true);
      }

      if (lastRecord != null) {
        _addSelection(lastRecord, dataGridConfiguration);
      }
    } else if (dataGridConfiguration.isDesktop &&
        dataGridConfiguration.selectionMode == SelectionMode.multiple) {
      final RowColumnIndex currentRowColumnIndex =
          RowColumnIndex(dataGridConfiguration.currentCell.rowIndex, -1);
      dataGridConfiguration.currentCell._updateBorderForMultipleSelection(
          dataGridConfiguration,
          nextRowColumnIndex: currentRowColumnIndex);
    }
  }

  void _onRowColumnChanged(int recordLength, int columnLength) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;

    if (currentCell.rowIndex == -1 && currentCell.columnIndex == -1) {
      return;
    }

    final int rowIndex = grid_helper.resolveToRecordIndex(
        dataGridConfiguration, currentCell.rowIndex);
    if (recordLength > 0 &&
        rowIndex >= recordLength &&
        currentCell.rowIndex != -1) {
      final int startRowIndex = selection_helper.getPreviousRowIndex(
          dataGridConfiguration, currentCell.rowIndex);
      currentCell._moveCurrentCellTo(dataGridConfiguration,
          RowColumnIndex(startRowIndex, currentCell.columnIndex),
          needToUpdateColumn: false);
      _refreshSelection();
    }

    final int columnIndex = grid_helper.resolveToGridVisibleColumnIndex(
        dataGridConfiguration, currentCell.columnIndex);
    if (columnLength > 0 &&
        columnIndex >= columnLength &&
        currentCell.columnIndex != -1) {
      final int startColumnIndex = selection_helper.getPreviousColumnIndex(
          dataGridConfiguration, currentCell.columnIndex);
      currentCell._moveCurrentCellTo(dataGridConfiguration,
          RowColumnIndex(currentCell.rowIndex, startColumnIndex),
          needToUpdateColumn: false);
    }
  }

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
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    if (dataGridConfiguration.currentCell.isEditing &&
        keyEvent.logicalKey != LogicalKeyboardKey.escape) {
      if (!dataGridConfiguration.currentCell
          .canSubmitCell(dataGridConfiguration)) {
        return;
      }

      dataGridConfiguration.currentCell
          .onCellSubmit(dataGridConfiguration, cancelCanSubmitCell: true);
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.tab) {
      _processKeyTab(keyEvent);
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.home) {
      _processHomeKey(dataGridConfiguration, keyEvent);
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.end) {
      _processEndKey(dataGridConfiguration, keyEvent);
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
      if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
        return;
      }
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (dataGridConfiguration.textDirection == TextDirection.rtl) {
        _processKeyRight(dataGridConfiguration, keyEvent);
      } else {
        _processKeyLeft(dataGridConfiguration, keyEvent);
      }
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (dataGridConfiguration.textDirection == TextDirection.rtl) {
        _processKeyLeft(dataGridConfiguration, keyEvent);
      } else {
        _processKeyRight(dataGridConfiguration, keyEvent);
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

    if (keyEvent.logicalKey == LogicalKeyboardKey.f2) {
      if (dataGridConfiguration.allowEditing &&
          dataGridConfiguration.navigationMode == GridNavigationMode.cell) {
        final RowColumnIndex rowColumnIndex = RowColumnIndex(
            dataGridConfiguration.currentCell.rowIndex,
            dataGridConfiguration.currentCell.columnIndex);
        dataGridConfiguration.currentCell.onCellBeginEdit(
            editingRowColumnIndex: rowColumnIndex,
            isProgrammatic: true,
            needToResolveIndex: false);
      }
    }

    if (keyEvent.logicalKey == LogicalKeyboardKey.escape) {
      if (dataGridConfiguration.allowEditing &&
          dataGridConfiguration.navigationMode == GridNavigationMode.cell &&
          dataGridConfiguration.currentCell.isEditing) {
        dataGridConfiguration.currentCell
            .onCellSubmit(dataGridConfiguration, isCellCancelEdit: true);
      }
    }
  }

  void _processEndKey(
      DataGridConfiguration dataGridConfiguration, RawKeyEvent keyEvent) {
    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
    final int lastCellIndex =
        selection_helper.getLastCellIndex(dataGridConfiguration);
    final bool needToScrollToMinOrMaxExtent =
        dataGridConfiguration.container.extentWidth >
            dataGridConfiguration.viewWidth;

    if (needToScrollToMinOrMaxExtent) {
      selection_helper.scrollInViewFromLeft(dataGridConfiguration,
          needToScrollMaxExtent: true);
    }

    if (keyEvent.isControlPressed &&
        keyEvent.logicalKey != LogicalKeyboardKey.arrowRight) {
      final int lastRowIndex =
          selection_helper.getLastNavigatingRowIndex(dataGridConfiguration);
      selection_helper.scrollInViewFromTop(dataGridConfiguration,
          needToScrollToMaxExtent: true);
      _processSelectionAndCurrentCell(
          dataGridConfiguration, RowColumnIndex(lastRowIndex, lastCellIndex));
    } else {
      _processSelectionAndCurrentCell(dataGridConfiguration,
          RowColumnIndex(currentCell.rowIndex, lastCellIndex));
    }
  }

  void _processHomeKey(
      DataGridConfiguration dataGridConfiguration, RawKeyEvent keyEvent) {
    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
    final int firstCellIndex =
        selection_helper.getFirstCellIndex(dataGridConfiguration);
    final bool needToScrollToMinOrMaxExtend =
        dataGridConfiguration.container.extentWidth >
            dataGridConfiguration.viewWidth;

    if (needToScrollToMinOrMaxExtend) {
      selection_helper.scrollInViewFromRight(dataGridConfiguration,
          needToScrollToMinExtent: true);
    }

    if (keyEvent.isControlPressed &&
        keyEvent.logicalKey != LogicalKeyboardKey.arrowLeft) {
      final int firstRowIndex =
          selection_helper.getFirstNavigatingRowIndex(dataGridConfiguration);
      selection_helper.scrollInViewFromDown(dataGridConfiguration,
          needToScrollToMinExtent: true);
      _processSelectionAndCurrentCell(
          dataGridConfiguration, RowColumnIndex(firstRowIndex, firstCellIndex));
    } else {
      _processSelectionAndCurrentCell(dataGridConfiguration,
          RowColumnIndex(currentCell.rowIndex, firstCellIndex));
    }
  }

  void _processPageDown() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
    final int index = selection_helper.getNextPageIndex(dataGridConfiguration);
    if (currentCell.rowIndex != index && index != -1) {
      _processSelectionAndCurrentCell(dataGridConfiguration,
          RowColumnIndex(index, currentCell.columnIndex));
    }
  }

  void _processPageUp() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
    final int index =
        selection_helper.getPreviousPageIndex(dataGridConfiguration);
    if (currentCell.rowIndex != index) {
      _processSelectionAndCurrentCell(dataGridConfiguration,
          RowColumnIndex(index, currentCell.columnIndex));
    }
  }

  void _processKeyDown(RawKeyEvent keyEvent) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
    final int nextRowIndex = selection_helper.getNextRowIndex(
        dataGridConfiguration, currentCell.rowIndex);
    final int lastRowIndex =
        selection_helper.getLastNavigatingRowIndex(dataGridConfiguration);
    int nextColumnIndex = currentCell.columnIndex;

    if (nextColumnIndex <= 0) {
      nextColumnIndex =
          selection_helper.getFirstCellIndex(dataGridConfiguration);
    }

    if (nextRowIndex > lastRowIndex || currentCell.rowIndex == nextRowIndex) {
      return;
    }

    if (keyEvent.isControlPressed) {
      selection_helper.scrollInViewFromTop(dataGridConfiguration,
          needToScrollToMaxExtent: true);
      _processSelectionAndCurrentCell(
          dataGridConfiguration, RowColumnIndex(lastRowIndex, nextColumnIndex),
          isShiftKeyPressed: keyEvent.isShiftPressed);
    } else {
      _processSelectionAndCurrentCell(
          dataGridConfiguration, RowColumnIndex(nextRowIndex, nextColumnIndex),
          isShiftKeyPressed: keyEvent.isShiftPressed);
    }
  }

  void _processKeyUp(RawKeyEvent keyEvent) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
    final int previousRowIndex = selection_helper.getPreviousRowIndex(
        dataGridConfiguration, currentCell.rowIndex);

    if (previousRowIndex == currentCell.rowIndex) {
      return;
    }

    if (keyEvent.isControlPressed) {
      final int firstRowIndex =
          selection_helper.getFirstRowIndex(dataGridConfiguration);
      selection_helper.scrollInViewFromDown(dataGridConfiguration,
          needToScrollToMinExtent: true);
      _processSelectionAndCurrentCell(dataGridConfiguration,
          RowColumnIndex(firstRowIndex, currentCell.columnIndex),
          isShiftKeyPressed: keyEvent.isShiftPressed);
    } else {
      _processSelectionAndCurrentCell(dataGridConfiguration,
          RowColumnIndex(previousRowIndex, currentCell.columnIndex),
          isShiftKeyPressed: keyEvent.isShiftPressed);
    }
  }

  void _processKeyRight(
      DataGridConfiguration dataGridConfiguration, RawKeyEvent keyEvent) {
    if (dataGridConfiguration.navigationMode == GridNavigationMode.row) {
      return;
    }

    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
    final int lastCellIndex =
        selection_helper.getLastCellIndex(dataGridConfiguration);
    int nextCellIndex;
    // Need to get previous column index only if the control key is
    // pressed in RTL mode since it will perform the home key event.
    if (keyEvent.isControlPressed &&
        dataGridConfiguration.textDirection == TextDirection.rtl) {
      nextCellIndex = selection_helper.getPreviousColumnIndex(
          dataGridConfiguration, currentCell.columnIndex);
    } else {
      nextCellIndex = selection_helper.getNextColumnIndex(
          dataGridConfiguration, currentCell.columnIndex);
    }

    if (currentCell.rowIndex <=
            grid_helper.getHeaderIndex(dataGridConfiguration) ||
        (nextCellIndex < 0 || nextCellIndex > lastCellIndex) ||
        currentCell.columnIndex == nextCellIndex) {
      return;
    }

    if (keyEvent.isControlPressed) {
      if (dataGridConfiguration.textDirection == TextDirection.rtl) {
        _processHomeKey(dataGridConfiguration, keyEvent);
      } else {
        _processEndKey(dataGridConfiguration, keyEvent);
      }
    } else {
      currentCell._processCurrentCell(dataGridConfiguration,
          RowColumnIndex(currentCell.rowIndex, nextCellIndex),
          isSelectionChanged: true);
      if (dataGridConfiguration.navigationMode == GridNavigationMode.cell) {
        notifyListeners();
      }
    }
  }

  void _processKeyLeft(
      DataGridConfiguration dataGridConfiguration, RawKeyEvent keyEvent) {
    if (dataGridConfiguration.navigationMode == GridNavigationMode.row) {
      return;
    }

    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
    int previousCellIndex;
    // Need to get next column index only if the control key is
    // pressed in RTL mode since it will perform the end key event.
    if (keyEvent.isControlPressed &&
        dataGridConfiguration.textDirection == TextDirection.rtl) {
      previousCellIndex = selection_helper.getNextColumnIndex(
          dataGridConfiguration, currentCell.columnIndex);
    } else {
      previousCellIndex = selection_helper.getPreviousColumnIndex(
          dataGridConfiguration, currentCell.columnIndex);
    }

    if (currentCell.rowIndex <=
            grid_helper.getHeaderIndex(dataGridConfiguration) ||
        previousCellIndex <
            grid_helper.resolveToStartColumnIndex(dataGridConfiguration)) {
      return;
    }

    if (keyEvent.isControlPressed) {
      if (dataGridConfiguration.textDirection == TextDirection.rtl) {
        _processEndKey(dataGridConfiguration, keyEvent);
      } else {
        _processHomeKey(dataGridConfiguration, keyEvent);
      }
    } else {
      currentCell._processCurrentCell(dataGridConfiguration,
          RowColumnIndex(currentCell.rowIndex, previousCellIndex),
          isSelectionChanged: true);
      if (dataGridConfiguration.navigationMode == GridNavigationMode.cell) {
        notifyListeners();
      }
    }
  }

  void _processKeyTab(RawKeyEvent keyEvent) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
    final int lastCellIndex =
        selection_helper.getLastCellIndex(dataGridConfiguration);
    int firstCellIndex =
        selection_helper.getFirstCellIndex(dataGridConfiguration);
    final int firstRowIndex =
        selection_helper.getFirstRowIndex(dataGridConfiguration);

    if (dataGridConfiguration.navigationMode == GridNavigationMode.row ||
        (currentCell.rowIndex < 0 && currentCell.columnIndex < 0)) {
      _processSelectionAndCurrentCell(
          dataGridConfiguration, RowColumnIndex(firstRowIndex, firstCellIndex));
      notifyListeners();
      return;
    }

    final bool needToScrollToMinOrMaxExtend =
        dataGridConfiguration.container.extentWidth >
            dataGridConfiguration.viewWidth;

    if (keyEvent.isShiftPressed) {
      if (currentCell.columnIndex == firstCellIndex &&
          currentCell.rowIndex == firstRowIndex) {
        return;
      }

      if (currentCell.columnIndex == firstCellIndex) {
        final int previousRowIndex = selection_helper.getPreviousRowIndex(
            dataGridConfiguration, currentCell.rowIndex);
        if (needToScrollToMinOrMaxExtend) {
          selection_helper.scrollInViewFromLeft(dataGridConfiguration,
              needToScrollMaxExtent: needToScrollToMinOrMaxExtend);
        }
        _processSelectionAndCurrentCell(dataGridConfiguration,
            RowColumnIndex(previousRowIndex, lastCellIndex));
      } else {
        _processKeyLeft(dataGridConfiguration, keyEvent);
      }
    } else {
      if (currentCell.columnIndex == lastCellIndex) {
        final int nextRowIndex = selection_helper.getNextRowIndex(
            dataGridConfiguration, currentCell.rowIndex);
        if (needToScrollToMinOrMaxExtend) {
          selection_helper.scrollInViewFromRight(dataGridConfiguration,
              needToScrollToMinExtent: needToScrollToMinOrMaxExtend);
        }

        firstCellIndex = (nextRowIndex == currentCell.rowIndex &&
                lastCellIndex == currentCell.columnIndex)
            ? currentCell.columnIndex
            : firstCellIndex;

        _processSelectionAndCurrentCell(dataGridConfiguration,
            RowColumnIndex(nextRowIndex, firstCellIndex));
      } else {
        _processKeyRight(dataGridConfiguration, keyEvent);
      }
    }
  }

  void _processSelectedAll() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    if (dataGridConfiguration.selectionMode != SelectionMode.multiple) {
      return;
    }

    final List<DataGridRow> addedItems = <DataGridRow>[];
    final List<DataGridRow> removeItems = <DataGridRow>[];
    if (dataGridConfiguration.onSelectionChanging != null ||
        dataGridConfiguration.onSelectionChanged != null) {
      addedItems.addAll(effectiveRows(dataGridConfiguration.source));
    }

    if (_raiseSelectionChanging(oldItems: removeItems, newItems: addedItems)) {
      dataGridConfiguration.controller.selectedRows.clear();
      _selectedRows.addAll(effectiveRows(dataGridConfiguration.source));
      dataGridConfiguration.controller.selectedRows
          .addAll(effectiveRows(dataGridConfiguration.source));
      _refreshSelection();
      dataGridConfiguration.container
        ..isDirty = true
        ..refreshView();
      _updateCheckboxStateOnHeader(dataGridConfiguration);

      notifyListeners();
      _raiseSelectionChanged(newItems: addedItems, oldItems: removeItems);
    }
  }

  void _processSpaceKey() {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    if (dataGridConfiguration.selectionMode == SelectionMode.single) {
      return;
    }

    final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
    final int recordIndex = grid_helper.resolveToRecordIndex(
        dataGridConfiguration, currentCell.rowIndex);
    _shiftSelectedRows.clear();
    _pressedRowIndex = recordIndex;
    _applySelection(
        RowColumnIndex(currentCell.rowIndex, currentCell.columnIndex));
  }

  void _processSelectionAndCurrentCell(
      DataGridConfiguration dataGridConfiguration,
      RowColumnIndex rowColumnIndex,
      {bool isShiftKeyPressed = false,
      bool isProgrammatic = false}) {
    final RowColumnIndex previousRowColumnIndex = RowColumnIndex(
        dataGridConfiguration.currentCell.rowIndex,
        dataGridConfiguration.currentCell.columnIndex);
    if (isProgrammatic) {
      dataGridConfiguration.currentCell
          ._moveCurrentCellTo(dataGridConfiguration, rowColumnIndex);
    } else {
      dataGridConfiguration.currentCell
          ._processCurrentCell(dataGridConfiguration, rowColumnIndex);
    }

    if (dataGridConfiguration.selectionMode == SelectionMode.multiple) {
      dataGridConfiguration.currentCell._updateBorderForMultipleSelection(
          dataGridConfiguration,
          nextRowColumnIndex: rowColumnIndex,
          previousRowColumnIndex: previousRowColumnIndex);
      if (isShiftKeyPressed) {
        _processSelection(
            dataGridConfiguration, rowColumnIndex, previousRowColumnIndex);
      } else {
        notifyListeners();
      }
    }

    _pressedRowColumnIndex = rowColumnIndex;
  }

  bool _raiseSelectionChanging(
      {List<DataGridRow> oldItems = const <DataGridRow>[],
      List<DataGridRow> newItems = const <DataGridRow>[]}) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    if (dataGridConfiguration.onSelectionChanging == null) {
      return true;
    }

    return dataGridConfiguration.onSelectionChanging!(newItems, oldItems);
  }

  void _raiseSelectionChanged(
      {List<DataGridRow> oldItems = const <DataGridRow>[],
      List<DataGridRow> newItems = const <DataGridRow>[]}) {
    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();
    if (dataGridConfiguration.onSelectionChanged == null) {
      return;
    }

    dataGridConfiguration.onSelectionChanged!(newItems, oldItems);
  }

  /// Refresh the selection state in header and cell check box when selection
  /// gets cleared.
  void _refreshCheckboxSelection() {
    notifyListeners();
  }
}

final FocusScopeNode _focusScopeNode = FocusScopeNode();

/// A class that can be used to manage the current cell operations in the
/// [SfDataGrid].
class CurrentCellManager {
  /// Creates the [CurrentCellManager] for the [SfDataGrid].
  CurrentCellManager(this.dataGridStateDetails);

  /// Holds the [DataGridStateDetails].
  final DataGridStateDetails dataGridStateDetails;

  /// The row index of the current cell.
  int rowIndex = -1;

  /// The column index of the current cell.
  int columnIndex = -1;

  /// Current editing dataCell.
  DataCellBase? dataCell;

  /// Indicate the any [DataGridCell] is in editing state.
  bool isEditing = false;

  bool _handlePointerOperation(DataGridConfiguration dataGridConfiguration,
      RowColumnIndex rowColumnIndex) {
    if (dataGridConfiguration.allowSwiping) {
      dataGridConfiguration.container.resetSwipeOffset();
    }
    final RowColumnIndex previousRowColumnIndex =
        RowColumnIndex(rowIndex, columnIndex);
    if (!rowColumnIndex.equals(previousRowColumnIndex) &&
        dataGridConfiguration.navigationMode != GridNavigationMode.row) {
      if (!_raiseCurrentCellActivating(rowColumnIndex)) {
        return false;
      }
      _setCurrentCell(dataGridConfiguration, rowColumnIndex.rowIndex,
          rowColumnIndex.columnIndex);
      _raiseCurrentCellActivated(previousRowColumnIndex);
    } else if (dataGridConfiguration.navigationMode == GridNavigationMode.row &&
        rowIndex != rowColumnIndex.rowIndex) {
      _updateCurrentRowColumnIndex(
          rowColumnIndex.rowIndex, rowColumnIndex.columnIndex);
      _updateBorderForMultipleSelection(dataGridConfiguration,
          previousRowColumnIndex: previousRowColumnIndex,
          nextRowColumnIndex: rowColumnIndex);
    }

    return true;
  }

  void _setCurrentCell(DataGridConfiguration dataGridConfiguration,
      int rowIndex, int columnIndex,
      [bool needToUpdateColumn = true]) {
    if (this.rowIndex == rowIndex && this.columnIndex == columnIndex) {
      return;
    }

    _removeCurrentCell(dataGridConfiguration, needToUpdateColumn);
    _updateCurrentRowColumnIndex(rowIndex, columnIndex);
    _updateCurrentCell(
        dataGridConfiguration, rowIndex, columnIndex, needToUpdateColumn);
  }

  void _updateCurrentCell(DataGridConfiguration dataGridConfiguration,
      int rowIndex, int columnIndex,
      [bool needToUpdateColumn = true]) {
    final DataRowBase? dataRowBase =
        _getDataRow(dataGridConfiguration, rowIndex);
    if (dataRowBase != null && needToUpdateColumn) {
      final DataCellBase? dataCellBase = _getDataCell(dataRowBase, columnIndex);
      if (dataCellBase != null) {
        dataCell = dataCellBase;
        setCurrentCellDirty(dataRowBase, dataCellBase, true);
        dataCellBase.updateColumn();
      }
    }

    updateCurrentCellIndex(
        dataGridConfiguration.controller,
        grid_helper.resolveToRecordRowColumnIndex(
            dataGridConfiguration, RowColumnIndex(rowIndex, columnIndex)));
  }

  void _removeCurrentCell(DataGridConfiguration dataGridConfiguration,
      [bool needToUpdateColumn = true]) {
    if (rowIndex == -1 && columnIndex == -1) {
      return;
    }

    final DataRowBase? dataRowBase =
        _getDataRow(dataGridConfiguration, rowIndex);
    if (dataRowBase != null && needToUpdateColumn) {
      final DataCellBase? dataCellBase = _getDataCell(dataRowBase, columnIndex);
      if (dataCellBase != null) {
        setCurrentCellDirty(dataRowBase, dataCellBase, false);
        dataCellBase.updateColumn();
      }
    }

    _updateCurrentRowColumnIndex(-1, -1);
    updateCurrentCellIndex(
        dataGridConfiguration.controller, RowColumnIndex(-1, -1));
  }

  DataRowBase? _getDataRow(
      DataGridConfiguration dataGridConfiguration, int rowIndex) {
    final List<DataRowBase> dataRows = dataGridConfiguration.rowGenerator.items;
    if (dataRows.isEmpty) {
      return null;
    }

    return dataRows
        .firstWhereOrNull((DataRowBase row) => row.rowIndex == rowIndex);
  }

  DataCellBase? _getDataCell(DataRowBase dataRow, int columnIndex) {
    if (dataRow.visibleColumns.isEmpty) {
      return null;
    }

    return dataRow.visibleColumns.firstWhereOrNull(
        (DataCellBase dataCell) => dataCell.columnIndex == columnIndex);
  }

  void _updateCurrentRowColumnIndex(int rowIndex, int columnIndex) {
    this.rowIndex = rowIndex;
    this.columnIndex = columnIndex;
  }

  /// Sets the current data cell as dirty to refresh the cell.
  void setCurrentCellDirty(
      DataRowBase? dataRow, DataCellBase? dataCell, bool enableCurrentCell) {
    dataCell?.isCurrentCell = enableCurrentCell;
    dataCell?.isDirty = true;
    dataRow?.isCurrentRow = enableCurrentCell;
    dataRow?.isDirty = true;
  }

  bool _raiseCurrentCellActivating(RowColumnIndex rowColumnIndex) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.onCurrentCellActivating == null) {
      return true;
    }

    final RowColumnIndex newRowColumnIndex = grid_helper
        .resolveToRecordRowColumnIndex(dataGridConfiguration, rowColumnIndex);
    final RowColumnIndex oldRowColumnIndex =
        grid_helper.resolveToRecordRowColumnIndex(
            dataGridConfiguration, RowColumnIndex(rowIndex, columnIndex));
    return dataGridConfiguration.onCurrentCellActivating!(
        newRowColumnIndex, oldRowColumnIndex);
  }

  void _raiseCurrentCellActivated(RowColumnIndex previousRowColumnIndex) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();
    if (dataGridConfiguration.onCurrentCellActivated == null) {
      return;
    }

    final RowColumnIndex newRowColumnIndex =
        grid_helper.resolveToRecordRowColumnIndex(
            dataGridConfiguration, RowColumnIndex(rowIndex, columnIndex));
    final RowColumnIndex oldRowColumnIndex =
        grid_helper.resolveToRecordRowColumnIndex(
            dataGridConfiguration, previousRowColumnIndex);
    dataGridConfiguration.onCurrentCellActivated!(
        newRowColumnIndex, oldRowColumnIndex);
  }

  void _moveCurrentCellTo(DataGridConfiguration dataGridConfiguration,
      RowColumnIndex nextRowColumnIndex,
      {bool isSelectionChanged = false, bool needToUpdateColumn = true}) {
    final RowColumnIndex previousRowColumnIndex = RowColumnIndex(
        dataGridConfiguration.currentCell.rowIndex,
        dataGridConfiguration.currentCell.columnIndex);

    _scrollVertical(dataGridConfiguration, nextRowColumnIndex);
    _scrollHorizontal(dataGridConfiguration, nextRowColumnIndex);

    if (dataGridConfiguration.navigationMode == GridNavigationMode.cell) {
      _setCurrentCell(dataGridConfiguration, nextRowColumnIndex.rowIndex,
          nextRowColumnIndex.columnIndex, needToUpdateColumn);
    } else {
      _updateCurrentRowColumnIndex(
          nextRowColumnIndex.rowIndex, nextRowColumnIndex.columnIndex);
    }

    if (dataGridConfiguration.selectionMode != SelectionMode.none &&
        dataGridConfiguration.selectionMode != SelectionMode.multiple &&
        !isSelectionChanged) {
      final SelectionManagerBase rowSelectionController =
          dataGridConfiguration.rowSelectionManager;
      if (rowSelectionController is RowSelectionManager) {
        rowSelectionController
          .._processSelection(
              dataGridConfiguration, nextRowColumnIndex, previousRowColumnIndex)
          .._pressedRowColumnIndex = nextRowColumnIndex;
      }
    }
  }

  void _processCurrentCell(DataGridConfiguration dataGridConfiguration,
      RowColumnIndex rowColumnIndex,
      {bool isSelectionChanged = false}) {
    if (dataGridConfiguration.navigationMode == GridNavigationMode.row) {
      _moveCurrentCellTo(dataGridConfiguration, rowColumnIndex,
          isSelectionChanged: isSelectionChanged);
      return;
    }

    if (_raiseCurrentCellActivating(rowColumnIndex)) {
      _moveCurrentCellTo(dataGridConfiguration, rowColumnIndex,
          isSelectionChanged: isSelectionChanged);
      _raiseCurrentCellActivated(rowColumnIndex);
    }
  }

  void _scrollHorizontal(DataGridConfiguration dataGridConfiguration,
      RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex.columnIndex < columnIndex) {
      if (selection_helper.needToScrollLeft(
          dataGridConfiguration, rowColumnIndex)) {
        selection_helper.scrollInViewFromRight(dataGridConfiguration,
            previousCellIndex: rowColumnIndex.columnIndex);
      }
    }

    if (rowColumnIndex.columnIndex > columnIndex) {
      if (selection_helper.needToScrollRight(
          dataGridConfiguration, rowColumnIndex)) {
        selection_helper.scrollInViewFromLeft(dataGridConfiguration,
            nextCellIndex: rowColumnIndex.columnIndex);
      }
    }
  }

  void _scrollVertical(DataGridConfiguration dataGridConfiguration,
      RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex.rowIndex < rowIndex) {
      if (selection_helper.needToScrollUp(
          dataGridConfiguration, rowColumnIndex.rowIndex)) {
        selection_helper.scrollInViewFromDown(dataGridConfiguration,
            previousRowIndex: rowColumnIndex.rowIndex);
      }
    }

    if (rowColumnIndex.rowIndex > rowIndex) {
      if (selection_helper.needToScrollDown(
          dataGridConfiguration, rowColumnIndex.rowIndex)) {
        selection_helper.scrollInViewFromTop(dataGridConfiguration,
            nextRowIndex: rowColumnIndex.rowIndex);
      }
    }
  }

  void _updateBorderForMultipleSelection(
      DataGridConfiguration dataGridConfiguration,
      {RowColumnIndex? previousRowColumnIndex,
      RowColumnIndex? nextRowColumnIndex}) {
    if (dataGridConfiguration.isDesktop &&
        dataGridConfiguration.navigationMode == GridNavigationMode.row &&
        dataGridConfiguration.selectionMode == SelectionMode.multiple) {
      if (previousRowColumnIndex != null) {
        dataGridConfiguration.currentCell
            ._getDataRow(dataGridConfiguration, previousRowColumnIndex.rowIndex)
            ?.isDirty = true;
      }

      if (nextRowColumnIndex != null) {
        final int firstVisibleColumnIndex =
            grid_helper.resolveToStartColumnIndex(dataGridConfiguration);
        _updateCurrentRowColumnIndex(
            nextRowColumnIndex.rowIndex >= 0
                ? nextRowColumnIndex.rowIndex
                : rowIndex,
            nextRowColumnIndex.columnIndex >= 0
                ? nextRowColumnIndex.columnIndex
                : firstVisibleColumnIndex);
        dataGridConfiguration.currentCell
            ._getDataRow(
                dataGridConfiguration,
                nextRowColumnIndex.rowIndex >= 0
                    ? nextRowColumnIndex.rowIndex
                    : rowIndex)
            ?.isDirty = true;
      }
    }
  }

  // ------------------------------Editing-------------------------------------
  /// Called when the editing is begin to the data cell.
  void onCellBeginEdit(
      {DataCellBase? editingDataCell,
      RowColumnIndex? editingRowColumnIndex,
      bool isProgrammatic = false,
      bool needToResolveIndex = true}) {
    final DataGridConfiguration dataGridConfiguration = dataGridStateDetails();

    final bool checkEditingIsEnabled = dataGridConfiguration.allowEditing &&
        dataGridConfiguration.selectionMode != SelectionMode.none &&
        dataGridConfiguration.navigationMode != GridNavigationMode.row;

    bool checkDataCellIsValidForEditing(DataCellBase? editingDataCell) =>
        editingDataCell != null &&
        editingDataCell.gridColumn!.allowEditing &&
        !editingDataCell.isEditing &&
        editingDataCell.renderer != null &&
        editingDataCell.renderer!.isEditable &&
        editingDataCell.dataRow!.rowType == RowType.dataRow;

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
          ? grid_helper.resolveToRowColumnIndex(
              dataGridConfiguration, editingRowColumnIndex)
          : editingRowColumnIndex;

      if (editingRowColumnIndex.rowIndex.isNegative ||
          editingRowColumnIndex.columnIndex.isNegative ||
          editingRowColumnIndex.columnIndex >
              selection_helper.getLastCellIndex(dataGridConfiguration) ||
          editingRowColumnIndex.rowIndex >
              selection_helper.getLastRowIndex(dataGridConfiguration)) {
        return;
      }

      // If the editing is initiate from f2 key, need not to process the
      // handleTap.
      if (needToResolveIndex) {
        dataGridConfiguration.rowSelectionManager
            .handleTap(editingRowColumnIndex);
      } else {
        // Need to skip the editing when current cell is not in view and we
        // process initiate the editing from f2 key.
        final DataRowBase? dataRow =
            _getDataRow(dataGridConfiguration, editingRowColumnIndex.rowIndex);
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

    editingRowColumnIndex = grid_helper.resolveToRecordRowColumnIndex(
        dataGridConfiguration,
        RowColumnIndex(editingDataCell!.rowIndex, editingDataCell.columnIndex));

    if (editingRowColumnIndex.rowIndex.isNegative ||
        editingRowColumnIndex.columnIndex.isNegative) {
      return;
    }

    final bool beginEdit = _raiseCellBeginEdit(
        dataGridConfiguration, editingRowColumnIndex, editingDataCell);

    if (beginEdit) {
      void submitCell() {
        onCellSubmit(dataGridConfiguration);
      }

      final Widget? child = dataGridConfiguration.source.buildEditWidget(
          editingDataCell.dataRow!.dataGridRow!,
          editingRowColumnIndex,
          editingDataCell.gridColumn!,
          submitCell);

      /// If child is null, we will not initiate the editing
      if (child != null) {
        /// Wrapped the editing widget inside the FocusScope.
        /// To bring the focus automatically to editing widget.
        /// canRequestFocus need to set true to auto detect the focus
        /// User need to set the autoFocus to true in their editable widget.
        editingDataCell.editingWidget = FocusScope(
            canRequestFocus: true,
            node: _focusScopeNode,
            onFocusChange: (bool details) {
              /// We should not allow the focus to the other widgets
              /// when the cell is in the edit mode and return false from the canSubmitCell
              /// So, we need to request the focus here.
              /// Also, if we return false from the canSubmitCell method and tap other cells
              /// We need to retain the focus on the text field instead of losing focus.
              if (!_focusScopeNode.hasFocus &&
                  !dataGridConfiguration.dataGridFocusNode!.hasFocus &&
                  dataGridConfiguration.controller.isCurrentCellInEditing) {
                _focusScopeNode.requestFocus();
              }
            },
            child: child);
        editingDataCell.isEditing =
            editingDataCell.dataRow!.isEditing = isEditing = true;

        notifyDataGridPropertyChangeListeners(dataGridConfiguration.source,
            rowColumnIndex: editingRowColumnIndex, propertyName: 'editing');
      }
    }
  }

  bool _raiseCellBeginEdit(DataGridConfiguration dataGridConfiguration,
      RowColumnIndex rowColumnIndex, DataCellBase dataCell) {
    return dataGridConfiguration.source.onCellBeginEdit(
        dataCell.dataRow!.dataGridRow!, rowColumnIndex, dataCell.gridColumn!);
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
  void onCellSubmit(DataGridConfiguration dataGridConfiguration,
      {bool isCellCancelEdit = false,
      bool cancelCanSubmitCell = false,
      bool canRefresh = true}) {
    if (!isEditing) {
      return;
    }

    final DataRowBase? dataRow = _getEditingRow(dataGridConfiguration);

    if (dataRow == null) {
      return;
    }

    final DataCellBase? dataCell = _getEditingCell(dataRow);

    if (dataCell == null || !dataCell.isEditing) {
      return;
    }

    if (isEditing) {
      final RowColumnIndex rowColumnIndex =
          grid_helper.resolveToRecordRowColumnIndex(dataGridConfiguration,
              RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex));

      if (rowColumnIndex.rowIndex.isNegative ||
          rowColumnIndex.columnIndex.isNegative) {
        return;
      }

      final DataGridRow dataGridRow = dataCell.dataRow!.dataGridRow!;

      void resetEditing() {
        dataCell.editingWidget = null;
        dataCell.isDirty = true;
        dataCell.isEditing = dataRow.isEditing = isEditing = false;
      }

      if (!isCellCancelEdit) {
        bool canSubmitCell = false;

        /// Via keyboard navigation we will check the canCellSubmit before
        /// moving to other cell or another row. so we need to skip the
        /// canCellSubmit method calling once again
        if (!cancelCanSubmitCell) {
          canSubmitCell = dataGridConfiguration.source
              .canSubmitCell(dataGridRow, rowColumnIndex, dataCell.gridColumn!);
        } else {
          canSubmitCell = true;
        }
        if (canSubmitCell) {
          resetEditing();
          dataGridConfiguration.source
              .onCellSubmit(dataGridRow, rowColumnIndex, dataCell.gridColumn!);
        }
      } else {
        resetEditing();
        dataGridConfiguration.source.onCellCancelEdit(
            dataGridRow, rowColumnIndex, dataCell.gridColumn!);
      }

      if (canRefresh) {
        /// Refresh the visible [DataRow]'s on editing the [DataCell] when
        /// sorting or filtering is enabled.
        if (dataGridConfiguration.allowSorting ||
            dataGridConfiguration.allowFiltering) {
          updateDataSource(dataGridConfiguration.source);
          if (dataGridConfiguration.source.filterConditions.isNotEmpty) {
            dataGridConfiguration.container.updateRowAndColumnCount();
          }
          dataGridConfiguration.container
            ..updateDataGridRows(dataGridConfiguration)
            ..isDirty = true;
        }

        notifyDataGridPropertyChangeListeners(dataGridConfiguration.source,
            rowColumnIndex: rowColumnIndex, propertyName: 'editing');
      }

      // Allow focus only if any data cell is in editing state and the
      // data grid currently isn't focused.
      if (dataGridConfiguration.currentCell.isEditing &&
          dataGridConfiguration.dataGridFocusNode != null &&
          !dataGridConfiguration.dataGridFocusNode!.hasPrimaryFocus) {
        dataGridConfiguration.dataGridFocusNode!.requestFocus();
      }
    }
  }

  DataRowBase? _getEditingRow(DataGridConfiguration dataGridConfiguration) {
    return dataGridConfiguration.rowGenerator.items
        .firstWhereOrNull((DataRowBase dataRow) => dataRow.isEditing);
  }

  DataCellBase? _getEditingCell(DataRowBase dataRow) {
    return dataRow.visibleColumns
        .firstWhereOrNull((DataCellBase dataCell) => dataCell.isEditing);
  }

  /// Called when the editing is submitted in the data cell.
  bool canSubmitCell(DataGridConfiguration dataGridConfiguration) {
    final DataRowBase? dataRow = _getEditingRow(dataGridConfiguration);

    if (dataRow == null) {
      return false;
    }

    final DataCellBase? dataCell = _getEditingCell(dataRow);

    if (dataCell == null || !dataCell.isEditing) {
      return false;
    }

    final RowColumnIndex rowColumnIndex =
        grid_helper.resolveToRecordRowColumnIndex(dataGridConfiguration,
            RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex));

    if (rowColumnIndex.rowIndex.isNegative ||
        rowColumnIndex.columnIndex.isNegative) {
      return false;
    }

    final DataGridRow dataGridRow = dataCell.dataRow!.dataGridRow!;

    return dataGridConfiguration.source
        .canSubmitCell(dataGridRow, rowColumnIndex, dataCell.gridColumn!);
  }
}

///
void onRowColumnChanged(DataGridConfiguration dataGridConfiguration,
    int recordLength, int columnLength) {
  if (dataGridConfiguration.rowSelectionManager is RowSelectionManager) {
    final RowSelectionManager rowSelectionManager =
        dataGridConfiguration.rowSelectionManager as RowSelectionManager;
    rowSelectionManager._onRowColumnChanged(recordLength, columnLength);
  }
}

///
void removeUnWantedDataGridRows(DataGridConfiguration dataGridConfiguration) {
  final RowSelectionManager rowSelectionManager =
      dataGridConfiguration.rowSelectionManager as RowSelectionManager;
  final List<DataGridRow> duplicateSelectedRows =
      rowSelectionManager._selectedRows.toList();
  for (final DataGridRow selectedRow in duplicateSelectedRows) {
    final int rowIndex =
        effectiveRows(dataGridConfiguration.source).indexOf(selectedRow);
    if (rowIndex.isNegative) {
      rowSelectionManager._selectedRows.remove(selectedRow);
      dataGridConfiguration.controller.selectedRows.remove(selectedRow);
    }
  }
}

///
void handleSelectionPropertyChanged(
    {required DataGridConfiguration dataGridConfiguration,
    RowColumnIndex? rowColumnIndex,
    String? propertyName,
    bool recalculateRowHeight = false}) {
  if (dataGridConfiguration.rowSelectionManager is RowSelectionManager) {
    final RowSelectionManager rowSelectionManager =
        dataGridConfiguration.rowSelectionManager as RowSelectionManager;
    rowSelectionManager._handleSelectionPropertyChanged(
        propertyName: propertyName,
        rowColumnIndex: rowColumnIndex,
        recalculateRowHeight: recalculateRowHeight);
  }
}

///
void updateSelectionController(
    {required DataGridConfiguration dataGridConfiguration,
    bool isSelectionModeChanged = false,
    bool isNavigationModeChanged = false,
    bool isDataSourceChanged = false}) {
  if (dataGridConfiguration.rowSelectionManager is RowSelectionManager) {
    final RowSelectionManager rowSelectionManager =
        dataGridConfiguration.rowSelectionManager as RowSelectionManager;
    rowSelectionManager._updateSelectionController(
        isDataSourceChanged: isDataSourceChanged,
        isNavigationModeChanged: isNavigationModeChanged,
        isSelectionModeChanged: isSelectionModeChanged);
  }
}

/// Ensures the selection and current cell update in the [RowSelectionManager].
void processSelectionAndCurrentCell(
    DataGridConfiguration dataGridConfiguration, RowColumnIndex rowColumnIndex,
    {bool isShiftKeyPressed = false, bool isProgrammatic = false}) {
  if (dataGridConfiguration.rowSelectionManager is RowSelectionManager) {
    final RowSelectionManager rowSelectionManager =
        dataGridConfiguration.rowSelectionManager as RowSelectionManager;
    rowSelectionManager._processSelectionAndCurrentCell(
        dataGridConfiguration, rowColumnIndex,
        isShiftKeyPressed: isShiftKeyPressed, isProgrammatic: isProgrammatic);
  }
}

/// Need to clarify
bool isSelectedRow(
    DataGridConfiguration dataGridConfiguration, DataGridRow dataGridRow) {
  if (dataGridConfiguration.rowSelectionManager is RowSelectionManager) {
    final RowSelectionManager rowSelectionManager =
        dataGridConfiguration.rowSelectionManager as RowSelectionManager;
    return rowSelectionManager._selectedRows.contains(dataGridRow);
  }

  return false;
}

/// Set the DataGridStateDetails in SelectionManagerBase
void setStateDetailsInSelectionManagerBase(
    SelectionManagerBase selectionManagerBase,
    DataGridStateDetails dataGridStateDetails) {
  selectionManagerBase._dataGridStateDetails = dataGridStateDetails;
}

/// Helps to handle the selection from header and grid cell check box
/// interaction.
void handleSelectionFromCheckbox(DataGridConfiguration dataGridConfiguration,
    DataCellBase dataCell, bool? oldValue, bool? newValue) {
  if (dataGridConfiguration.rowSelectionManager is RowSelectionManager &&
      dataGridConfiguration.selectionMode != SelectionMode.none) {
    final RowSelectionManager rowSelectionManager =
        dataGridConfiguration.rowSelectionManager as RowSelectionManager;
    if (dataGridConfiguration.selectionMode == SelectionMode.single) {
      if (dataCell.cellType == CellType.checkboxCell && !oldValue!) {
        dataCell.onTouchUp();
      }
    } else if (dataGridConfiguration.selectionMode ==
        SelectionMode.singleDeselect) {
      if (dataCell.cellType == CellType.checkboxCell && oldValue != newValue) {
        dataCell.onTouchUp();
      }
    } else {
      if (dataCell.cellType == CellType.headerCell) {
        if (oldValue == null || oldValue == false) {
          dataGridConfiguration.headerCheckboxState = true;
          dataCell.updateColumn();
          rowSelectionManager._processSelectedAll();
        } else if (oldValue) {
          dataGridConfiguration.headerCheckboxState = false;
          dataCell.updateColumn();

          // Issue:
          // FLUT-6838-The onSelectionChanged callback is not being called with deselected rows
          // while deselecting through the checkbox column header
          // We have resolved the issue by creating the list instead of the reference.
          final List<DataGridRow> oldSelectedItems =
              rowSelectionManager._selectedRows.toList();
          if (rowSelectionManager._raiseSelectionChanging(
              newItems: <DataGridRow>[], oldItems: oldSelectedItems)) {
            rowSelectionManager._clearSelectedRows(dataGridConfiguration);
            rowSelectionManager._refreshCheckboxSelection();
            rowSelectionManager._raiseSelectionChanged(
                oldItems: oldSelectedItems, newItems: <DataGridRow>[]);
          }
          // Cleared the oldSelectedItems list after the callback is called.
          oldSelectedItems.clear();
        }
      } else {
        dataCell.onTouchUp();
      }
    }
  }
}
