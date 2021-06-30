part of datagrid;

/// A base class for cell renderer classes which displays widget in a cell.
abstract class GridVirtualizingCellRendererBase<T1 extends Widget,
    T2 extends Widget> extends GridCellRendererBase {
  /// Creates the [GridVirtualizingCellRendererBase] for [SfDataGrid] widget.
  GridVirtualizingCellRendererBase();

  /// Initializes the column element of a [DataCell]
  ///
  /// object with the given widget and required values.
  void onInitializeDisplayWidget(DataCellBase dataCell) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();

    // Need to restrict invisible rows (rowIndex == -1) from the item collection.
    // Because we generate the `ensureColumns` for all the data rows in the
    // `rowGenerator.items` collection not visible rows.
    if (dataCell.columnIndex < 0 || dataCell.rowIndex < 0) {
      return;
    }

    final int index = _GridIndexResolver.resolveToGridVisibleColumnIndex(
        dataGridSettings, dataCell.columnIndex);
    final Widget child = dataCell._dataRow!._dataGridRowAdapter!.cells[index];

    Widget getChild() {
      if (dataGridSettings.currentCell.isEditing && dataCell._isEditing) {
        return dataCell._editingWidget ?? child;
      } else {
        return child;
      }
    }

    dataCell._columnElement = GridCell(
      key: dataCell._key!,
      dataCell: dataCell,
      child: DefaultTextStyle(
          key: dataCell._key, style: dataCell._textStyle!, child: getChild()),
      backgroundColor: Colors.transparent,
      isDirty: dataGridSettings.container._isDirty ||
          dataCell._isDirty ||
          dataCell._dataRow!._isDirty,
    );
  }

  @override
  Widget? onPrepareWidgets(DataCellBase dataCell) {
    onInitializeDisplayWidget(dataCell);
    return dataCell._columnElement;
  }
}
