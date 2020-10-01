part of datagrid;

/// The base class for the cell renderer that used to display the widget.
abstract class GridCellRendererBase {
  /// Creates the [GridCellRendererBase] for [SfDataGrid] widget.
  GridCellRendererBase();

  _DataGridStateDetails _dataGridStateDetails;

  /// Called when the child widgets for the GridCell are prepared.
  Widget onPrepareWidgets(DataCellBase dataColumn) {
    return null;
  }

  /// Called when the style is set for the cell.
  void setCellStyle(DataCellBase dataCell) {}
}
