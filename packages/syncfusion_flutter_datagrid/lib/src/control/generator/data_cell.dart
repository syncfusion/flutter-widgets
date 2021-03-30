part of datagrid;

/// Provides functionality to display the cell.
class DataCell extends DataCellBase {
  /// Creates [DataCell] for [GridCell] widget.
  DataCell();

  @override
  Widget? _onInitializeColumnElement(bool isInEdit) {
    if (_cellType != CellType.indentCell) {
      if (_renderer != null) {
        _renderer!.setCellStyle(this);
        return _renderer!.onPrepareWidgets(this);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  void _updateColumn() {
    if (_renderer == null) {
      return;
    }
    _renderer!
      ..setCellStyle(this)
      ..onPrepareWidgets(this);
  }
}
