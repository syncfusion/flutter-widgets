part of datagrid;

/// A base class which provides functionalities for [DataRow].
abstract class DataRowBase {
  _DataGridStateDetails? _dataGridStateDetails;

  Key? _key;

  bool _isDirty = false;

  bool _isEnsured = false;

  bool _isVisible = true;

  List<DataCellBase> _visibleColumns = [];

  // This flag is used to indicating whether the row is swiped or not.
  bool _isSwipingRow = false;

  /// The row index of the [DataRow].
  int rowIndex = -1;

  /// The type of the [DataRow].
  RowType rowType = RowType.headerRow;

  /// The region of the [DataRow] to identify whether the row is scrollable
  RowRegion rowRegion = RowRegion.header;

  /// Decides whether the [DataRow] is visible.
  bool get isVisible => _isVisible;

  /// Decides whether the [DataRow] is currently active
  bool isCurrentRow = false;

  DataGridRow? _dataGridRow;

  DataGridRowAdapter? _dataGridRowAdapter;

  void _rowIndexChanged() {
    if (rowIndex < 0) {
      return;
    }

    for (final col in _visibleColumns) {
      col
        ..rowIndex = rowIndex
        .._dataRow = this
        .._updateColumn();
    }
  }

  void _onGenerateVisibleColumns(_VisibleLinesCollection visibleColumnLines) {}

  void _initializeDataRow(_VisibleLinesCollection visibleColumnLines) {
    _onGenerateVisibleColumns(visibleColumnLines);
  }

  void _ensureColumns(_VisibleLinesCollection visibleColumnLines) {}

  _VisibleLineInfo? _getColumnVisibleLineInfo(int index) =>
      _dataGridStateDetails!()
          .container
          .scrollColumns
          .getVisibleLineAtLineIndex(index);

  _VisibleLineInfo? _getRowVisibleLineInfo(int index) =>
      _dataGridStateDetails!()
          .container
          .scrollRows
          .getVisibleLineAtLineIndex(index);

  double _getColumnWidth(int startIndex, int endIndex) {
    if (startIndex != endIndex) {
      final currentPos = _dataGridStateDetails!()
          .container
          .scrollColumns
          .rangeToRegionPoints(startIndex, endIndex, true);
      return currentPos[1].length;
    }

    final line = _getColumnVisibleLineInfo(startIndex);
    if (line == null) {
      return 0;
    }

    return line.size;
  }

  double _getRowHeight(int startIndex, int endIndex) {
    if (startIndex != endIndex) {
      final currentPos = _dataGridStateDetails!()
          .container
          .scrollRows
          .rangeToRegionPoints(startIndex, endIndex, true);
      return currentPos[1].length;
    }

    final line = _getRowVisibleLineInfo(startIndex);
    if (line == null) {
      return 0;
    }

    return line.size;
  }

  /// Decides whether the [DataRow] is selected.
  bool get isSelectedRow => _isSelectedRow;
  bool _isSelectedRow = false;

  /// Decides whether the [DataRow] is selected.
  set isSelectedRow(bool newValue) {
    if (_isSelectedRow != newValue) {
      _isSelectedRow = newValue;
      for (final dataCell in _visibleColumns) {
        dataCell
          .._isDirty = true
          .._updateColumn();
      }
    }
  }
}
