part of datagrid;

/// Provides the base functionalities to process the selection in [SfDataGrid].
class SelectionManagerBase extends ChangeNotifier {
  /// Creates the [SelectionManagerBase].
  SelectionManagerBase() {
    _selectedRows = _SelectedRowCollection();
  }

  late _SelectedRowCollection _selectedRows;

  late _DataGridStateDetails _dataGridStateDetails;

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

  void _onRowColumnChanged(int recordLength, int columnLength) {}

  void _handleSelectionPropertyChanged(
      {RowColumnIndex? rowColumnIndex,
      String? propertyName,
      bool recalculateRowHeight = false}) {}

  void _updateSelectionController(
      {bool isSelectionModeChanged = false,
      bool isNavigationModeChanged = false,
      bool isDataSourceChanged = false}) {}

  bool _raiseSelectionChanging(
      {List<DataGridRow> oldItems = const <DataGridRow>[],
      List<DataGridRow> newItems = const <DataGridRow>[]}) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataGridSettings.onSelectionChanging == null) {
      return true;
    }

    return dataGridSettings.onSelectionChanging!(newItems, oldItems);
  }

  void _raiseSelectionChanged(
      {List<DataGridRow> oldItems = const <DataGridRow>[],
      List<DataGridRow> newItems = const <DataGridRow>[]}) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataGridSettings.onSelectionChanged == null) {
      return;
    }

    dataGridSettings.onSelectionChanged!(newItems, oldItems);
  }

  int _getPreviousColumnIndex(
      _DataGridSettings dataGridSettings, int currentColumnIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    int previousCellIndex = currentColumnIndex;
    final GridColumn? column =
        _getNextGridColumn(dataGridSettings, currentColumnIndex - 1, false);
    if (column != null) {
      previousCellIndex = _GridIndexResolver.resolveToScrollColumnIndex(
          dataGridSettings, dataGridSettings.columns.indexOf(column));
    }

    if (previousCellIndex == currentColumnIndex) {
      previousCellIndex = currentColumnIndex - 1;
    }

    return previousCellIndex;
  }

  int _getPreviousRowIndex(
      _DataGridSettings dataGridSettings, int currentRowIndex) {
    final int lastRowIndex =
        _SelectionHelper.getLastNavigatingRowIndex(dataGridSettings);
    if (currentRowIndex > lastRowIndex) {
      return lastRowIndex;
    }

    final int firstRowIndex =
        _SelectionHelper.getFirstNavigatingRowIndex(dataGridSettings);
    if (currentRowIndex <= firstRowIndex) {
      return firstRowIndex;
    }

    int previousIndex = currentRowIndex;
    previousIndex = dataGridSettings.container.scrollRows
        .getPreviousScrollLineIndex(currentRowIndex);
    if (previousIndex == currentRowIndex) {
      previousIndex = previousIndex - 1;
    }

    return previousIndex;
  }

  GridColumn? _getNextGridColumn(
      _DataGridSettings dataGridSettings, int columnIndex, bool moveToRight) {
    final int resolvedIndex =
        _GridIndexResolver.resolveToGridVisibleColumnIndex(
            dataGridSettings, columnIndex);
    if (resolvedIndex < 0 || resolvedIndex >= dataGridSettings.columns.length) {
      return null;
    }

    GridColumn? gridColumn = dataGridSettings.columns[resolvedIndex];
    if (!gridColumn.visible || gridColumn._actualWidth == 0.0) {
      gridColumn = _getNextGridColumn(dataGridSettings,
          moveToRight ? columnIndex + 1 : columnIndex - 1, moveToRight);
    }

    return gridColumn;
  }

  int _getNextColumnIndex(
      _DataGridSettings dataGridSettings, int currentColumnIndex) {
    int nextCellIndex = currentColumnIndex;
    final int lastCellIndex =
        _SelectionHelper.getLastCellIndex(dataGridSettings);

    final GridColumn? column =
        _getNextGridColumn(dataGridSettings, currentColumnIndex + 1, true);
    if (column != null) {
      final int columnIndex = dataGridSettings.columns.indexOf(column);
      nextCellIndex = _GridIndexResolver.resolveToScrollColumnIndex(
          dataGridSettings, columnIndex);
    }

    if (nextCellIndex == currentColumnIndex) {
      nextCellIndex = currentColumnIndex + 1;
    }

    return nextCellIndex > lastCellIndex ? lastCellIndex : nextCellIndex;
  }

  int _getNextRowIndex(
      _DataGridSettings dataGridSettings, int currentRowIndex) {
    final int lastRowIndex =
        _SelectionHelper.getLastNavigatingRowIndex(dataGridSettings);
    if (currentRowIndex >= lastRowIndex) {
      return lastRowIndex;
    }

    final int firstRowIndex =
        _SelectionHelper.getFirstNavigatingRowIndex(dataGridSettings);

    if (currentRowIndex < firstRowIndex) {
      return firstRowIndex;
    }

    if (currentRowIndex >= dataGridSettings.container.scrollRows.lineCount) {
      return -1;
    }

    int nextIndex = 0;
    nextIndex = dataGridSettings.container.scrollRows
        .getNextScrollLineIndex(currentRowIndex);
    if (nextIndex == currentRowIndex) {
      nextIndex = nextIndex + 1;
    }

    return nextIndex;
  }
}
