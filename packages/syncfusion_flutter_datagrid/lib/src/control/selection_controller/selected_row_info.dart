part of datagrid;

class _SelectedRowCollection {
  List<DataGridRow> selectedRow = <DataGridRow>[];

  bool contains(DataGridRow rowData) => findRowData(rowData) != null;

  DataGridRow? findRowData(DataGridRow rowData) {
    final DataGridRow? selectedItem = selectedRow
        .firstWhereOrNull((DataGridRow dataRow) => dataRow == rowData);
    return selectedItem;
  }
}
