part of datagrid;

class _SelectedRowCollection {
  List<Object> selectedRow = [];

  bool contains(Object rowData) => findRowData(rowData) != null;

  Object findRowData(Object rowData) {
    final selectedItem = selectedRow.firstWhere((dataRow) => dataRow == rowData,
        orElse: () => null);
    return selectedItem;
  }
}
