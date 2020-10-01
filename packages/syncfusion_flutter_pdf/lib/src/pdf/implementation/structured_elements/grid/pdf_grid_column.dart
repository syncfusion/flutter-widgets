part of pdf;

/// Represents the schema of a column in a [PdfGrid].
class PdfGridColumn {
  //Constructors
  /// Initializes a new instance of the [PdfGridColumn] class
  /// with the parent grid.
  PdfGridColumn(PdfGrid grid) {
    _grid = grid;
    _width = -1;
    _isCustomWidth = false;
  }

  //Fields
  PdfGrid _grid;
  double _width;
  PdfStringFormat _format;
  bool _isCustomWidth;

  //Properties
  /// Gets the width of the [PdfGridColumn].
  double get width => _width;

  /// Sets the width of the [PdfGridColumn].
  set width(double value) {
    _isCustomWidth = true;
    _width = value;
  }

  /// Gets the information about the text formatting.
  PdfStringFormat get format => _format ??= PdfStringFormat();

  /// Sets the information about the text formatting.
  set format(PdfStringFormat value) {
    _format = value;
  }

  /// Gets the parent [PdfGrid].
  PdfGrid get grid => _grid;
}

/// Provides access to an ordered, strongly typed collection of [PdfGridColumn]
/// objects.
class PdfGridColumnCollection {
  /// Initializes a new instance of the [PdfGridColumnCollection] class
  /// with the parent grid.
  PdfGridColumnCollection(PdfGrid grid) {
    _grid = grid;
    _columns = <PdfGridColumn>[];
    _columnsWidth = -1;
  }

  //Fields
  PdfGrid _grid;
  List<PdfGridColumn> _columns;
  double _columnsWidth;

  //Properties
  /// Gets the number of columns in the [PdfGrid].
  int get count => _columns.length;

  /// Gets the [PdfGridColumn] at the specified index.
  PdfGridColumn operator [](int index) => _returnValue(index);
  double get _width {
    if (_columnsWidth == -1) {
      _columnsWidth = _measureColumnsWidth();
    }
    if (_grid._initialWidth != 0 &&
        _columnsWidth != _grid._initialWidth &&
        !_grid.style.allowHorizontalOverflow) {
      _columnsWidth = _grid._initialWidth;
      _grid._isPageWidth = true;
    }
    return _columnsWidth;
  }

  //Public methods

  /// Adds the column into the collection.
  void add({int count, PdfGridColumn column}) {
    if (count == null && column == null) {
      final PdfGridColumn column = PdfGridColumn(_grid);
      _columns.add(column);
    } else {
      if (count != null) {
        for (int i = 0; i < count; i++) {
          _columns.add(PdfGridColumn(_grid));
          for (int i = 0; i < _grid.rows.count; i++) {
            final PdfGridRow row = _grid.rows[i];
            final PdfGridCell cell = PdfGridCell();
            cell.value = '';
            row.cells._add(cell);
          }
        }
      }
      if (column != null) {
        _columns.add(column);
      }
    }
  }

  //Implementation
  PdfGridColumn _returnValue(int index) {
    if (index < 0 || index >= _columns.length) {
      throw IndexError(index, _columns);
    }
    return _columns[index];
  }

  double _measureColumnsWidth() {
    double totalWidth = 0;
    _grid._measureColumnsWidth();
    for (int i = 0; i < _columns.length; i++) {
      totalWidth += _columns[i].width;
    }
    return totalWidth;
  }

  List<double> _getDefaultWidths(double totalWidth) {
    final List<double> widths = List<double>.filled(count, 0);
    int subFactor = count;
    for (int i = 0; i < count; i++) {
      if (_grid._isPageWidth &&
          totalWidth >= 0 &&
          !_columns[i]._isCustomWidth) {
        _columns[i].width = -1;
      } else {
        widths[i] = _columns[i].width;
        if (_columns[i].width > 0 && _columns[i]._isCustomWidth) {
          totalWidth -= _columns[i].width;
          subFactor--;
        } else {
          widths[i] = -1;
        }
      }
    }
    for (int i = 0; i < count; i++) {
      final double width = totalWidth / subFactor;
      if (widths[i] <= 0) {
        widths[i] = width;
      }
    }
    return widths;
  }
}
