part of datagrid;

/// The base class for the cell renderer that used to display the widget.
abstract class GridCellRendererBase {
  /// Creates the [GridCellRendererBase] for [SfDataGrid] widget.
  GridCellRendererBase() {
    _isEditable = true;
  }

  late _DataGridStateDetails _dataGridStateDetails;

  /// Decide to enable the editing in the renderer.
  late bool _isEditable;

  /// Called when the child widgets for the GridCell are prepared.
  Widget? onPrepareWidgets(DataCellBase dataCell) {
    return null;
  }

  /// Called when the style is set for the cell.
  void setCellStyle(DataCellBase dataCell) {}
}
