part of datagrid;

/// A base class which provides functionalities for [DataRow].
abstract class DataRowBase {
  /// Creates the [DataRowBase] for [SfDataGrid] widget.
  DataRowBase() {
    _isDirty = false;
    _isEnsured = false;
    _isVisible = true;
    _visibleColumns = [];
    _stylePreference = StylePreference.selection;
  }

  _DataGridStateDetails _dataGridStateDetails;

  Key _key;

  bool _isDirty;

  bool _isEnsured;

  bool _isVisible;

  List<DataCellBase> _visibleColumns;

  StylePreference _stylePreference;

  /// The row index of the [DataRow].
  int rowIndex = -1;

  /// The type of the [DataRow].
  RowType rowType = RowType.headerRow;

  /// The region of the [DataRow] to identify whether the row is scrollable
  RowRegion rowRegion = RowRegion.header;

  /// Decides whether the [DataRow] is visible.
  bool get isVisible => _isVisible;

  /// The style of the row which is set through [SfDataGrid.onQueryRowStyle].
  DataGridCellStyle rowStyle;

  /// Decides whether the [DataRow] is currently active
  bool isCurrentRow = false;

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

  _VisibleLineInfo _getColumnVisibleLineInfo(int index) =>
      _dataGridStateDetails()
          .container
          .scrollColumns
          .getVisibleLineAtLineIndex(index);

  double _getColumnSize(int index, bool lineNull) {
    if (lineNull) {
      final currentPos = _dataGridStateDetails()
          .container
          .scrollColumns
          .rangeToRegionPoints(index, index, true);
      return currentPos[1].length;
    }

    final line = _getColumnVisibleLineInfo(index);
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
