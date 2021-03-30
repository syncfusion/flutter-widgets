part of datagrid;

class _SelectedRowCollection {
  List<DataGridRow> selectedRow = [];

  bool contains(DataGridRow rowData) => findRowData(rowData) != null;

  DataGridRow? findRowData(Object rowData) {
    final selectedItem =
        selectedRow.firstWhereOrNull((dataRow) => dataRow == rowData);
    return selectedItem;
  }
}
