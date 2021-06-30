part of datagrid;

/// A base class which provides functionalities for [DataCell].
abstract class DataCellBase {
  /// Creates [DataCell] for [SfDataGrid]
  DataCellBase() {
    _isVisible = true;
    _isEnsured = false;
    _isDirty = false;
    _columnSpan = 0;
    _rowSpan = 0;
    _isEditing = false;
  }

  Widget? _columnElement;

  Key? _key;

  TextStyle? _textStyle;

  GridCellRendererBase? _renderer;

  CellType? _cellType;

  late bool _isVisible;

  late bool _isEnsured;

  DataRowBase? _dataRow;

  late bool _isDirty;

  /// The column index of the [DataCell].
  int columnIndex = -1;

  /// The row index of the [DataCell].
  int rowIndex = -1;

  /// [GridColumn] which is associated with [DataCell].
  GridColumn? gridColumn;

  /// Decides whether the [DataCell] has the currentcell.
  bool isCurrentCell = false;

  late int _columnSpan;

  late int _rowSpan;

  StackedHeaderCell? _stackedHeaderCell;

  Widget? _editingWidget;

  late bool _isEditing;

  /// Decides whether the [DataCell] is visible.
  bool get isVisible => _isVisible;

  Widget? _onInitializeColumnElement(bool isInEdit) => null;

  void _updateColumn() {}

  void _onTouchUp() {
    if (_dataRow != null) {
      final _DataGridSettings dataGridSettings =
          _dataRow!._dataGridStateDetails!();
      if (rowIndex <= _GridIndexResolver.getHeaderIndex(dataGridSettings) ||
          _GridIndexResolver.isFooterWidgetRow(rowIndex, dataGridSettings) ||
          dataGridSettings.selectionMode == SelectionMode.none) {
        return;
      }

      final RowColumnIndex currentRowColumnIndex =
          RowColumnIndex(rowIndex, columnIndex);
      dataGridSettings.rowSelectionManager.handleTap(currentRowColumnIndex);
    }
  }
}
