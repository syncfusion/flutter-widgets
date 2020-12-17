part of datagrid;

/// A cell renderer which loads any widget to the cells.
///
/// This renderer is typically used for [GridWidgetColumn].
class GridCellWidgetRenderer<T1, T2>
    extends GridVirtualizingCellRendererBase<Widget, Widget> {
  /// Creates the [GridCellWidgetRenderer] for [SfDataGrid] widget.
  GridCellWidgetRenderer(_DataGridStateDetails dataGridStateDetails) {
    _dataGridStateDetails = dataGridStateDetails;
  }
  @override
  void onInitializeDisplayWidget(DataCellBase dataCell, Widget widget) {
    if (dataCell != null) {
      dataCell._columnElement = GridWidgetCell(
        key: dataCell._key,
        dataCell: dataCell,
        padding: dataCell.gridColumn.padding ?? EdgeInsets.zero,
        backgroundColor: dataCell._cellStyle?.backgroundColor,
        isDirty:
            _dataGridStateDetails().container._isDirty || dataCell._isDirty,
      );
    }
  }
}
