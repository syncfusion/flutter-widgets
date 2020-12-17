part of datagrid;

/// A base class which provides functionalities for [DataCell].
abstract class DataCellBase {
  /// Creates the [DataCellBase] for [SfDataGrid] widget.
  DataCellBase() {
    _isVisible = true;
    _isEnsured = false;
    _isDirty = false;
    _columnSpan = 0;
    _rowSpan = 0;
    _ishover = false;
  }

  Widget _columnElement;

  Key _key;

  DataGridCellStyle _cellStyle;

  GridCellRendererBase _renderer;

  CellType _cellType;

  bool _isVisible;

  bool _isEnsured;

  DataRowBase _dataRow;

  bool _isDirty;

  bool _ishover;

  String _displayText;

  /// The column index of the [DataCell].
  int columnIndex = -1;

  /// The row index of the [DataCell].
  int rowIndex = -1;

  /// [GridColumn] which is associated with [DataCell].
  GridColumn gridColumn;

  /// The cell value of the column element associated with the [DataCell].
  Object cellValue;

  /// Decides whether the [DataCell] has the currentcell.
  bool isCurrentCell = false;

  int _columnSpan;

  int _rowSpan;

  StackedHeaderCell _stackedHeaderCell;

  /// Decides whether the [DataCell] is visible.
  bool get isVisible => _isVisible;

  Widget _onInitializeColumnElement(bool isInEdit) => null;

  void _updateColumn() {}

  void _onTouchUp() {
    if (_dataRow != null) {
      final _DataGridSettings dataGridSettings =
          _dataRow._dataGridStateDetails();
      if (rowIndex <= _GridIndexResolver.getHeaderIndex(dataGridSettings) ||
          dataGridSettings.selectionMode == SelectionMode.none) {
        return;
      }

      final RowColumnIndex currentRowColumnIndex =
          RowColumnIndex(rowIndex, columnIndex);
      dataGridSettings.rowSelectionManager.handleTap(currentRowColumnIndex);
    }
  }
}
