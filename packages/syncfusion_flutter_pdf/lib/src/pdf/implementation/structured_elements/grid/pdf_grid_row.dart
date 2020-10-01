part of pdf;

/// Provides customization of the settings for the particular row.
class PdfGridRow {
  /// Initializes a new instance of the [PdfGridRow] class with the parent grid.
  PdfGridRow(PdfGrid grid, {PdfGridRowStyle style, double height}) {
    _initialize(grid, style, height);
  }

  //Fields
  PdfGrid _grid;
  PdfGridCellCollection _cells;
  PdfGridRowStyle _style;
  double _height;
  double _width;
  bool _rowSpanExists;
  double _rowBreakHeight;
  int _rowOverflowIndex;
  PdfLayoutResult _gridResult;
  bool _isRowBreaksNextPage;
  bool _isrowFinish;
  bool _rowMergeComplete;
  int _noOfPageCount;
  bool _isRowHeightSet;
  int _maximumRowSpan;
  bool _isPageBreakRowSpanApplied;
  bool _isRowSpanRowHeightSet;
  bool _isHeaderRow;

  //Properties
  /// Gets the cells from the selected row.
  PdfGridCellCollection get cells {
    _cells ??= PdfGridCellCollection._(this);
    return _cells;
  }

  /// Gets the row style.
  PdfGridRowStyle get style {
    _style ??= PdfGridRowStyle();
    return _style;
  }

  /// Sets the row style.
  set style(PdfGridRowStyle value) {
    _style = value;
  }

  /// Gets the height of the row.
  double get height {
    if (!_isRowHeightSet) {
      _height = _measureHeight();
    }
    return _height;
  }

  /// Sets the height of the row.
  set height(double value) {
    _isRowHeightSet = true;
    _height = value;
  }

  int get _index => _grid.rows._indexOf(this);

  //Implementation
  void _initialize(PdfGrid grid, PdfGridRowStyle style, double height) {
    ArgumentError.checkNotNull(grid);
    if (style != null) {
      _style = style;
    }
    _grid = grid;
    if (height != null) {
      this.height = height;
    } else {
      _height = -1;
    }
    _width = -1;
    _rowSpanExists = false;
    _rowBreakHeight = 0;
    _rowOverflowIndex = 0;
    _isRowBreaksNextPage = false;
    _isrowFinish = false;
    _rowMergeComplete = true;
    _noOfPageCount = 0;
    _isRowHeightSet = false;
    _maximumRowSpan = 0;
    _isPageBreakRowSpanApplied = false;
    _isRowSpanRowHeightSet = false;
    _isHeaderRow = false;
  }

  double _getWidth() {
    if (_width == -1) {
      _width = _measureWidth();
    }
    return _width;
  }

  double _measureHeight() {
    double rowSpanRemainingHeight = 0;
    bool isHeader = false;
    double rowHeight = cells[0].rowSpan > 1 ? 0 : cells[0].height;
    double maxHeight = 0;
    if (_grid.headers._indexOf(this) != -1) {
      isHeader = true;
    }
    for (int i = 0; i < _cells.count; i++) {
      final PdfGridCell cell = _cells[i];
      if (cell._rowSpanRemainingHeight > rowSpanRemainingHeight) {
        rowSpanRemainingHeight = cell._rowSpanRemainingHeight;
      }
      if (cell._isRowMergeContinue) {
        continue;
      }
      if (!cell._isRowMergeContinue) {
        _rowMergeComplete = false;
      }
      if (cell.rowSpan > 1) {
        if (maxHeight < cell.height) {
          maxHeight = cell.height;
        }
        continue;
      }
      rowHeight = max(rowHeight, cell.height);
    }
    if (rowHeight == 0) {
      rowHeight = maxHeight;
    } else if (rowSpanRemainingHeight > 0) {
      rowHeight += rowSpanRemainingHeight;
    }
    if (isHeader && maxHeight != 0 && rowHeight != 0 && rowHeight < maxHeight) {
      rowHeight = maxHeight;
    }
    return rowHeight;
  }

  double _measureWidth() {
    double width = 0;
    for (int i = 0; i < _grid.columns.count; i++) {
      width += _grid.columns[i].width;
    }
    return width;
  }
}

/// Provides access to an ordered, strongly typed collection of
/// [PdfGridRow] objects.
class PdfGridRowCollection {
  /// Initializes a new instance of the [PdfGridRowCollection] class
  /// with the parent grid.
  PdfGridRowCollection(PdfGrid grid) {
    _grid = grid;
    _rows = <PdfGridRow>[];
  }

  //Fields
  PdfGrid _grid;
  List<PdfGridRow> _rows;

  //Properties
  /// Gets the rows count.
  int get count => _rows.length;

  /// Gets the [PdfGridRow] at the specified index.
  PdfGridRow operator [](int index) => _returnValue(index);

  //Public methods
  /// Add a row to the grid.
  PdfGridRow add([PdfGridRow row]) {
    if (row == null) {
      final PdfGridRow row = PdfGridRow(_grid);
      add(row);
      return row;
    } else {
      row.style.font = _grid.style.font;
      row.style.backgroundBrush = _grid.style.backgroundBrush;
      row.style.textPen = _grid.style.textPen;
      row.style.textBrush = _grid.style.textBrush;
      if (row.cells.count == 0) {
        for (int i = 0; i < _grid.columns.count; i++) {
          row.cells._add(PdfGridCell());
        }
      }
      _rows.add(row);
      return row;
    }
  }

  /// Sets the row span and column span to a cell.
  void setSpan(int rowIndex, int cellIndex, int rowSpan, int columnSpan) {
    ArgumentError.checkNotNull(rowSpan);
    ArgumentError.checkNotNull(columnSpan);
    if (rowIndex > _grid.rows.count) {
      ArgumentError.value(rowIndex, 'rowIndex', 'Index out of range');
    }
    if (cellIndex > _grid.columns.count) {
      ArgumentError.value(cellIndex, 'cellIndex', 'Index out of range');
    }
    final PdfGridCell cell = _grid.rows[rowIndex].cells[cellIndex];
    cell.rowSpan = rowSpan;
    cell.columnSpan = columnSpan;
  }

  /// Applies the style to all the rows in the grid.
  void applyStyle(PdfGridStyleBase style) {
    if (style is PdfGridCellStyle) {
      for (int i = 0; i < _grid.rows.count; i++) {
        final PdfGridRow row = _grid.rows[i];
        for (int j = 0; j < row.cells.count; j++) {
          row.cells[j].style = style;
        }
      }
    } else if (style is PdfGridRowStyle) {
      for (int i = 0; i < _grid.rows.count; i++) {
        _grid.rows[i].style = style;
      }
    } else if (style is PdfGridStyle) {
      _grid.style = style;
    }
  }

  //Implementation
  PdfGridRow _returnValue(int index) {
    if (index < 0 || index >= _rows.length) {
      throw IndexError(index, _rows);
    }
    return _rows[index];
  }

  int _indexOf(PdfGridRow row) {
    return _rows.indexOf(row);
  }
}

/// Provides customization of the settings for the header.
class PdfGridHeaderCollection {
  /// Initializes a new instance of the [PdfGridHeaderCollection] class
  /// with the parent grid.
  PdfGridHeaderCollection(PdfGrid grid) {
    _grid = grid;
    _rows = <PdfGridRow>[];
  }

  //Fields
  PdfGrid _grid;
  List<PdfGridRow> _rows;

  //Properties
  ///  Gets the number of header in the [PdfGrid].
  int get count => _rows.length;

  /// Gets a [PdfGridRow] object that represents the header row in a
  /// [PdfGridHeaderCollection] control.
  PdfGridRow operator [](int index) => _returnValue(index);

  //Public methods
  /// [PdfGrid] enables you to quickly and easily add rows
  /// to the header at run time.
  List<PdfGridRow> add(int count) {
    return _addRows(count);
  }

  /// Enables you to set the appearance of the header row in a [PdfGrid].
  void applyStyle(PdfGridStyleBase style) {
    if (style is PdfGridCellStyle) {
      for (int i = 0; i < _rows.length; i++) {
        final PdfGridRow row = _rows[i];
        for (int j = 0; j < row.cells.count; j++) {
          row.cells[j].style = style;
        }
      }
    } else if (style is PdfGridRowStyle) {
      for (int i = 0; i < _rows.length; i++) {
        _rows[i].style = style;
      }
    }
  }

  /// Removes all the header information in the [PdfGrid].
  void clear() {
    _rows.clear();
  }

  //Implementation
  PdfGridRow _returnValue(int index) {
    if (index < 0 || index >= count) {
      throw IndexError(index, _rows);
    }
    return _rows[index];
  }

  void _add(PdfGridRow row) {
    row._isHeaderRow = true;
    _rows.add(row);
  }

  List<PdfGridRow> _addRows(int count) {
    PdfGridRow row;
    for (int i = 0; i < count; i++) {
      row = PdfGridRow(_grid);
      for (int j = 0; j < _grid.columns.count; j++) {
        row.cells._add(PdfGridCell());
      }
      _add(row);
    }
    return _rows.toList();
  }

  int _indexOf(PdfGridRow row) {
    return _rows.indexOf(row);
  }
}
