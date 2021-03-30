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

    if (dataCell.columnIndex < 0) {
      return;
    }

    final int index = _GridIndexResolver.resolveToGridVisibleColumnIndex(
        dataGridSettings, dataCell.columnIndex);
    final Widget child = dataCell._dataRow!._dataGridRowAdapter!.cells[index];

    dataCell
      .._columnElement = GridCell(
        key: dataCell._key!,
        dataCell: dataCell,
        child: DefaultTextStyle(
            key: dataCell._key, style: dataCell._textStyle!, child: child),
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
