part of pdf;

/// Represents a flexible grid that consists of columns and rows.
class PdfGrid extends PdfLayoutElement {
  /// Initializes a new instance of the [PdfGrid] class.
  PdfGrid() {
    _initialize();
  }

  //Fields
  PdfGridColumnCollection _columns;
  PdfGridRowCollection _rows;
  PdfGridStyle _style;
  PdfGridHeaderCollection _headers;
  PdfBorders _defaultBorder;

  /// Gets or sets a value indicating whether to repeat header.
  bool repeatHeader;
  _Size _gridSize;

  /// Gets or sets a value indicating whether to split or cut rows that overflow a page.
  bool allowRowBreakingAcrossPages;
  bool _isChildGrid;
  PdfGridCell _parentCell;
  double _initialWidth;
  PdfLayoutFormat _layoutFormat;
  bool _isComplete;
  bool _isWidthSet;
  int _parentCellIndex;
  bool _isDrawn;
  double _rowLayoutBoundswidth;
  List<int> _listOfNavigatePages;
  bool _isRearranged;
  _Rectangle _gridLocation;
  bool _isPageWidth;
  bool _isSingleGrid;
  bool _hasColumnSpan;
  bool _hasRowSpan;
  PdfFont _defaultFont;
  DataTable _dataSource;
  bool _headerRow = true;
  bool _bandedRow = true;
  bool _bandedColumn;
  bool _totalRow;
  bool _firstColumn;
  bool _lastColumn;
  bool _isBuiltinStyle;
  PdfGridBuiltInStyle _gridBuiltinStyle;

  //Events
  /// The event raised on starting cell lay outing.
  PdfGridBeginCellLayoutCallback beginCellLayout;

  /// The event raised on finished cell layout.
  PdfGridEndCellLayoutCallback endCellLayout;

  //Properties
  /// Gets the column collection of the PdfGrid.
  PdfGridColumnCollection get columns {
    _columns ??= PdfGridColumnCollection(this);
    return _columns;
  }

  /// Gets the row collection from the PdfGrid.
  PdfGridRowCollection get rows {
    _rows ??= PdfGridRowCollection(this);
    return _rows;
  }

  /// Gets the headers collection from the PdfGrid.
  PdfGridHeaderCollection get headers {
    _headers ??= PdfGridHeaderCollection(this);
    return _headers;
  }

  /// Gets the data bind to the [PdfGrid] by associating it with an external data source.
  DataTable get dataSource => _dataSource;

  /// Sets the data bind to the [PdfGrid] by associating it with an external data source.
  set dataSource(DataTable value) {
    ArgumentError.checkNotNull(value);
    _dataSource = value;
    _setData(this, value);
  }

  /// Gets the grid style.
  PdfGridStyle get style {
    _style ??= PdfGridStyle();
    return _style;
  }

  /// Sets the grid style.
  set style(PdfGridStyle value) {
    _style = value;
  }

  _Size get _size {
    if (_gridSize == null || _gridSize == _Size.empty) {
      _gridSize = _measure();
    }
    return _gridSize;
  }

  /// Gets a value indicating whether the start cell layout event should be raised.
  bool get _raiseBeginCellLayout => beginCellLayout != null;

  /// Gets a value indicating whether the end cell layout event should be raised.
  bool get _raiseEndCellLayout => endCellLayout != null;

  //Implementation
  void _initialize() {
    _gridSize = _Size.empty;
    _isComplete = false;
    _isDrawn = false;
    _isSingleGrid = true;
    _isWidthSet = false;
    repeatHeader = false;
    allowRowBreakingAcrossPages = true;
    _gridLocation = _Rectangle.empty;
    _hasColumnSpan = false;
    _hasRowSpan = false;
    _isChildGrid = false;
    _isPageWidth = false;
    _isRearranged = false;
    _initialWidth = 0;
    _rowLayoutBoundswidth = 0;
    _listOfNavigatePages = <int>[];
    _parentCellIndex = 0;
    _isBuiltinStyle = false;
    _defaultFont = PdfStandardFont(PdfFontFamily.helvetica, 8);
    _defaultBorder = PdfBorders();
  }

  PdfGrid _setData(PdfGrid grid, DataTable source) {
    final List<DataColumn> dataColumns = source.columns;
    if (dataColumns.isNotEmpty) {
      grid.headers.clear();
      grid.rows._rows.clear();
      grid.rows._rows.length = 0;
      grid.columns.add(count: dataColumns.length);
      grid.headers.add(1);
      for (int i = 0; i < dataColumns.length; i++) {
        final Widget cell = dataColumns[i].label;
        if (cell is Text) {
          grid.headers[0].cells[i].value = cell.data;
        } else if (cell is DataTable) {
          grid.headers[0].cells[i].value = _setData(PdfGrid(), cell);
        }
      }
    }
    final List<DataRow> dataRows = source.rows;
    if (dataRows.isNotEmpty) {
      final int columnCount = dataRows[0].cells.length;
      if (grid.columns.count <= 0 && columnCount > 0) {
        grid.columns.add(count: columnCount);
      }
      for (int i = 0; i < dataRows.length; i++) {
        final DataRow dataRow = dataRows[i];
        final PdfGridRow gridRow = grid.rows.add();
        for (int j = 0; j < columnCount; j++) {
          final DataCell dataCell = dataRow.cells[j];
          final Widget cell = dataCell.child;
          if (cell is Text) {
            gridRow.cells[j].value = cell.data;
          } else if (cell is DataTable) {
            gridRow.cells[j].value = _setData(PdfGrid(), cell);
          }
        }
      }
    }
    return grid;
  }

  _Size _measure() {
    double height = 0;
    final double width = columns._width;
    for (int i = 0; i < headers.count; i++) {
      height += headers[i].height;
    }
    for (int i = 0; i < rows.count; i++) {
      height += rows[i].height;
    }
    return _Size(width, height);
  }

  void _setSpan() {
    int colSpan, rowSpan = 1;
    int currentCellIndex, currentRowIndex = 0;
    int maxSpan = 0;
    for (int i = 0; i < headers.count; i++) {
      final PdfGridRow row = headers[i];
      maxSpan = 0;
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        maxSpan = max(maxSpan, cell.rowSpan);
        if (!cell._isCellMergeContinue &&
            !cell._isRowMergeContinue &&
            (cell.columnSpan > 1 || cell.rowSpan > 1)) {
          if (cell.columnSpan + j > row.cells.count) {
            throw ArgumentError.value(
                'Invalid span specified at row $j column $i');
          }
          if (cell.rowSpan + i > headers.count) {
            throw ArgumentError.value(
                'Invalid span specified at row $j column $i');
          }
          if (cell.columnSpan > 1 && cell.rowSpan > 1) {
            colSpan = cell.columnSpan;
            rowSpan = cell.rowSpan;
            currentCellIndex = j;
            currentRowIndex = i;
            while (colSpan > 1) {
              currentCellIndex++;
              row.cells[currentCellIndex]._isCellMergeContinue = true;
              row.cells[currentCellIndex]._isRowMergeContinue = true;
              row.cells[currentCellIndex].rowSpan = rowSpan;
              colSpan--;
            }
            currentCellIndex = j;
            colSpan = cell.columnSpan;
            while (rowSpan > 1) {
              currentRowIndex++;
              headers[currentRowIndex].cells[j]._isRowMergeContinue = true;
              headers[currentRowIndex]
                  .cells[currentCellIndex]
                  ._isRowMergeContinue = true;
              rowSpan--;
              while (colSpan > 1) {
                currentCellIndex++;
                headers[currentRowIndex]
                    .cells[currentCellIndex]
                    ._isCellMergeContinue = true;
                headers[currentRowIndex]
                    .cells[currentCellIndex]
                    ._isRowMergeContinue = true;
                colSpan--;
              }
              colSpan = cell.columnSpan;
              currentCellIndex = j;
            }
          } else if (cell.columnSpan > 1 && cell.rowSpan == 1) {
            colSpan = cell.columnSpan;
            currentCellIndex = j;
            while (colSpan > 1) {
              currentCellIndex++;
              row.cells[currentCellIndex]._isCellMergeContinue = true;
              colSpan--;
            }
          } else if (cell.columnSpan == 1 && cell.rowSpan > 1) {
            rowSpan = cell.rowSpan;
            currentRowIndex = i;
            while (rowSpan > 1) {
              currentRowIndex++;
              headers[currentRowIndex].cells[j]._isRowMergeContinue = true;
              rowSpan--;
            }
          }
        }
      }
      row._maximumRowSpan = maxSpan;
    }
    colSpan = rowSpan = 1;
    currentCellIndex = currentRowIndex = 0;
    if (_hasColumnSpan || _hasRowSpan) {
      for (int i = 0; i < rows.count; i++) {
        final PdfGridRow row = rows[i];
        maxSpan = 0;
        for (int j = 0; j < row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j];
          maxSpan = max(maxSpan, cell.rowSpan);
          if (!cell._isCellMergeContinue &&
              !cell._isRowMergeContinue &&
              (cell.columnSpan > 1 || cell.rowSpan > 1)) {
            if (cell.columnSpan + j > row.cells.count) {
              throw ArgumentError.value(
                  'Invalid span specified at row $j column $i');
            }
            if (cell.rowSpan + i > rows.count) {
              throw ArgumentError.value(
                  'Invalid span specified at row $j column $i');
            }
            if (cell.columnSpan > 1 && cell.rowSpan > 1) {
              colSpan = cell.columnSpan;
              rowSpan = cell.rowSpan;
              currentCellIndex = j;
              currentRowIndex = i;
              while (colSpan > 1) {
                currentCellIndex++;
                row.cells[currentCellIndex]._isCellMergeContinue = true;
                row.cells[currentCellIndex]._isRowMergeContinue = true;
                colSpan--;
              }
              currentCellIndex = j;
              colSpan = cell.columnSpan;
              while (rowSpan > 1) {
                currentRowIndex++;
                rows[currentRowIndex].cells[j]._isRowMergeContinue = true;
                rows[currentRowIndex]
                    .cells[currentCellIndex]
                    ._isRowMergeContinue = true;
                rowSpan--;
                while (colSpan > 1) {
                  currentCellIndex++;
                  rows[currentRowIndex]
                      ._cells[currentCellIndex]
                      ._isCellMergeContinue = true;
                  rows[currentRowIndex]
                      ._cells[currentCellIndex]
                      ._isRowMergeContinue = true;
                  colSpan--;
                }
                colSpan = cell.columnSpan;
                currentCellIndex = j;
              }
            } else if (cell.columnSpan > 1 && cell.rowSpan == 1) {
              colSpan = cell.columnSpan;
              currentCellIndex = j;
              while (colSpan > 1) {
                currentCellIndex++;
                row.cells[currentCellIndex]._isCellMergeContinue = true;
                colSpan--;
              }
            } else if (cell.columnSpan == 1 && cell.rowSpan > 1) {
              rowSpan = cell.rowSpan;
              currentRowIndex = i;
              while (rowSpan > 1) {
                currentRowIndex++;
                rows[currentRowIndex].cells[j]._isRowMergeContinue = true;
                rowSpan--;
              }
            }
          }
        }
        row._maximumRowSpan = maxSpan;
      }
    }
  }

  void _measureColumnsWidth([_Rectangle bounds]) {
    if (bounds == null) {
      List<double> widths = List<double>.filled(columns.count, 0);
      double cellWidth = 0;
      if (headers.count > 0) {
        for (int i = 0; i < headers[0].cells.count; i++) {
          for (int j = 0; j < headers.count; j++) {
            cellWidth = max(
                cellWidth,
                _initialWidth > 0.0
                    ? min(_initialWidth, headers[j].cells[i].width)
                    : headers[j].cells[i].width);
          }
          widths[i] = cellWidth.toDouble();
        }
      }
      cellWidth = 0;
      for (int i = 0; i < columns.count; i++) {
        for (int j = 0; j < rows.count; j++) {
          final bool isGrid = rows[j].cells[i].value != null &&
              rows[j].cells[i].value is PdfGrid;
          if ((rows[j].cells[i].columnSpan == 1 &&
                  !rows[j].cells[i]._isCellMergeContinue) ||
              isGrid) {
            if (isGrid &&
                !rows[j]._grid.style.allowHorizontalOverflow &&
                _initialWidth != 0) {
              (rows[j].cells[i].value as PdfGrid)._initialWidth =
                  _initialWidth -
                      (rows[j]._grid.style.cellPadding.right +
                          rows[j]._grid.style.cellPadding.left +
                          rows[j].cells[i].style.borders.left.width / 2 +
                          _gridLocation.x);
            }
            cellWidth = max(
                widths[i],
                max(
                    cellWidth,
                    _initialWidth > 0.0
                        ? min(_initialWidth, rows[j].cells[i].width)
                        : rows[j].cells[i].width));
            cellWidth = max(columns[i].width, cellWidth);
          }
        }
        if (rows.count != 0) {
          widths[i] = cellWidth.toDouble();
        }
        cellWidth = 0;
      }
      for (int i = 0; i < rows.count; i++) {
        for (int j = 0; j < columns.count; j++) {
          if (rows[i].cells[j].columnSpan > 1) {
            double totalWidth = widths[j];
            for (int k = 1; k < rows[i].cells[j].columnSpan; k++) {
              totalWidth += widths[j + k];
            }
            if (rows[i].cells[j].width > totalWidth) {
              double extendedWidth = rows[i].cells[j].width - totalWidth;
              extendedWidth = extendedWidth / rows[i].cells[j].columnSpan;
              for (int k = j; k < j + rows[i].cells[j].columnSpan; k++) {
                widths[k] += extendedWidth;
              }
            }
          }
        }
      }
      if (_isChildGrid && _initialWidth != 0) {
        widths = columns._getDefaultWidths(_initialWidth);
      }
      for (int i = 0; i < columns.count; i++) {
        if (columns[i].width < 0) {
          columns[i]._width = widths[i];
        } else if (columns[i].width > 0 && !columns[i]._isCustomWidth) {
          columns[i]._width = widths[i];
        }
      }
    } else {
      List<double> widths = columns._getDefaultWidths(bounds.width - bounds.x);
      for (int i = 0; i < columns.count; i++) {
        if (columns[i].width < 0) {
          columns[i]._width = widths[i];
        } else if (columns[i].width > 0 &&
            !columns[i]._isCustomWidth &&
            widths[i] > 0 &&
            _isComplete) {
          columns[i]._width = widths[i];
        }
      }
      if (_parentCell != null &&
          (!style.allowHorizontalOverflow) &&
          (!_parentCell._row._grid.style.allowHorizontalOverflow)) {
        double padding = 0;
        double columnWidth = 0;
        int columnCount = columns.count;
        if (_parentCell.style.cellPadding != null) {
          padding += _parentCell.style.cellPadding.left +
              _parentCell.style.cellPadding.right;
        } else if (_parentCell._row._grid.style.cellPadding != null) {
          padding += _parentCell._row._grid.style.cellPadding.left +
              _parentCell._row._grid.style.cellPadding.right;
        }
        for (int i = 0; i < _parentCell.columnSpan; i++) {
          columnWidth +=
              _parentCell._row._grid.columns[_parentCellIndex + i].width;
        }
        for (int i = 0; i < columns.count; i++) {
          if (_columns[i].width > 0 && _columns[i]._isCustomWidth) {
            columnWidth -= _columns[i].width;
            columnCount--;
          }
        }
        if (columnWidth > padding) {
          final double childGridColumnWidth =
              (columnWidth - padding) / columnCount;
          if (_parentCell != null &&
              _parentCell.stringFormat.alignment != PdfTextAlignment.right) {
            for (int j = 0; j < columns.count; j++) {
              if (!columns[j]._isCustomWidth) {
                columns[j]._width = childGridColumnWidth;
              }
            }
          }
        }
      }
      if (_parentCell != null && _parentCell._row._getWidth() > 0) {
        if (_isChildGrid && _size.width > _parentCell._row._getWidth()) {
          widths = columns._getDefaultWidths(bounds.width);
          for (int i = 0; i < columns.count; i++) {
            columns[i].width = widths[i];
          }
        }
      }
    }
  }

  void _onBeginCellLayout(PdfGridBeginCellLayoutArgs args) {
    if (_raiseBeginCellLayout) {
      beginCellLayout(this, args);
    }
  }

  void _onEndCellLayout(PdfGridEndCellLayoutArgs args) {
    if (_raiseEndCellLayout) {
      endCellLayout(this, args);
    }
  }

  @override

  /// Draws the [PdfGrid]
  PdfLayoutResult draw(
      {Rect bounds,
      PdfLayoutFormat format,
      PdfGraphics graphics,
      PdfPage page}) {
    ArgumentError.checkNotNull(bounds);
    _initialWidth = bounds.width == 0
        ? page != null
            ? page.getClientSize().width
            : graphics.clientSize.width
        : bounds.width;
    _isWidthSet = true;
    if (graphics != null) {
      _drawInternal(graphics, _Rectangle.fromRect(bounds));
    } else if (page != null) {
      final PdfLayoutResult result =
          super.draw(page: page, bounds: bounds, format: format);
      _isComplete = true;
      return result;
    }
    return null;
  }

  @override
  void _drawInternal(PdfGraphics graphics, _Rectangle bounds) {
    _setSpan();
    final _PdfGridLayouter layouter = _PdfGridLayouter(this);
    layouter.layout(graphics, bounds);
    _isComplete = true;
  }

  @override
  PdfLayoutResult _layout(_PdfLayoutParams param) {
    if (param.bounds.width < 0) {
      ArgumentError.value('width', 'width', 'out of range');
    }
    if (rows.count != 0) {
      final PdfBorders borders = rows[0].cells[0].style.borders;
      if (borders != null && borders.left != null && borders.left.width != 1) {
        final double x = borders.left.width / 2;
        final double y = borders.top.width / 2;
        if (param.bounds.x == _defaultBorder.right.width / 2 &&
            param.bounds.y == _defaultBorder.right.width / 2) {
          param.bounds = _Rectangle(x, y, _size.width, _size.height);
        }
      }
    }
    _setSpan();
    _layoutFormat = param.format;
    _gridLocation = param.bounds;
    return _PdfGridLayouter(this)._layoutInternal(param);
  }

  /// Apply built-in table style to the table
  void applyBuiltInStyle(PdfGridBuiltInStyle gridStyle,
      {PdfGridBuiltInStyleSettings settings}) {
    _intializeBuiltInStyle(gridStyle, settings: settings);
  }

  void _intializeBuiltInStyle(PdfGridBuiltInStyle gridStyle,
      {PdfGridBuiltInStyleSettings settings}) {
    if (settings != null) {
      _headerRow = (settings.applyStyleForHeaderRow == null)
          ? _headerRow
          : settings.applyStyleForHeaderRow;
      _totalRow = settings.applyStyleForLastRow ??= false;
      _firstColumn = settings.applyStyleForFirstColumn ??= false;
      _lastColumn = settings.applyStyleForLastColumn ??= false;
      _bandedColumn = settings.applyStyleForBandedColumns ??= false;
      _bandedRow = (settings.applyStyleForBandedRows == null)
          ? _bandedRow
          : settings.applyStyleForBandedRows;
    } else {
      _totalRow = false;
      _firstColumn = false;
      _lastColumn = false;
      _bandedColumn = false;
    }
    _isBuiltinStyle = true;
    _gridBuiltinStyle = gridStyle;
  }

  void _applyBuiltinStyles(PdfGridBuiltInStyle gridStyle) {
    switch (gridStyle) {
      case PdfGridBuiltInStyle.tableGrid:
        _applyTableGridLight(PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.tableGridLight:
        _applyTableGridLight(PdfColor(191, 191, 191));
        break;

      case PdfGridBuiltInStyle.plainTable1:
        _applyPlainTable1(PdfColor(191, 191, 191), PdfColor(242, 242, 242));
        break;

      case PdfGridBuiltInStyle.plainTable2:
        _applyPlainTable2(PdfColor(127, 127, 127));
        break;

      case PdfGridBuiltInStyle.plainTable3:
        _applyPlainTable3(PdfColor(127, 127, 127), PdfColor(242, 242, 242));
        break;

      case PdfGridBuiltInStyle.plainTable4:
        _applyPlainTable4(PdfColor(242, 242, 242));
        break;

      case PdfGridBuiltInStyle.plainTable5:
        _applyPlainTable5(PdfColor(127, 127, 127), PdfColor(242, 242, 242));
        break;
      case PdfGridBuiltInStyle.gridTable1Light:
        _applyGridTable1Light(PdfColor(153, 153, 153), PdfColor(102, 102, 102));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent1:
        _applyGridTable1Light(PdfColor(189, 214, 238), PdfColor(156, 194, 229));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent2:
        _applyGridTable1Light(PdfColor(247, 202, 172), PdfColor(244, 176, 131));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent3:
        _applyGridTable1Light(PdfColor(219, 219, 219), PdfColor(201, 201, 201));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent4:
        _applyGridTable1Light(PdfColor(255, 229, 153), PdfColor(255, 217, 102));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent5:
        _applyGridTable1Light(PdfColor(180, 198, 231), PdfColor(142, 170, 219));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent6:
        _applyGridTable1Light(PdfColor(192, 224, 179), PdfColor(168, 208, 141));
        break;

      case PdfGridBuiltInStyle.gridTable2:
        _applyGridTable2(PdfColor(102, 102, 102), PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent1:
        _applyGridTable2(PdfColor(156, 194, 229), PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent2:
        _applyGridTable2(PdfColor(244, 176, 131), PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent3:
        _applyGridTable2(PdfColor(201, 201, 201), PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent4:
        _applyGridTable2(PdfColor(255, 217, 102), PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent5:
        _applyGridTable2(PdfColor(142, 170, 219), PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent6:
        _applyGridTable2(PdfColor(168, 208, 141), PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.gridTable3:
        _applyGridTable3(PdfColor(102, 102, 102), PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent1:
        _applyGridTable3(PdfColor(156, 194, 229), PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent2:
        _applyGridTable3(PdfColor(244, 176, 131), PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent3:
        _applyGridTable3(PdfColor(201, 201, 201), PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent4:
        _applyGridTable3(PdfColor(255, 217, 102), PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent5:
        _applyGridTable3(PdfColor(142, 170, 219), PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent6:
        _applyGridTable3(PdfColor(168, 208, 141), PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.gridTable4:
        _applyGridTable4(PdfColor(102, 102, 102), PdfColor(204, 204, 204),
            PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent1:
        _applyGridTable4(PdfColor(156, 194, 229), PdfColor(222, 234, 246),
            PdfColor(91, 155, 213));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent2:
        _applyGridTable4(PdfColor(244, 176, 131), PdfColor(251, 228, 213),
            PdfColor(237, 125, 49));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent3:
        _applyGridTable4(PdfColor(201, 201, 201), PdfColor(237, 237, 237),
            PdfColor(165, 165, 165));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent4:
        _applyGridTable4(PdfColor(255, 217, 102), PdfColor(255, 242, 204),
            PdfColor(255, 192, 0));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent5:
        _applyGridTable4(PdfColor(142, 170, 219), PdfColor(217, 226, 243),
            PdfColor(68, 114, 196));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent6:
        _applyGridTable4(PdfColor(168, 208, 141), PdfColor(226, 239, 217),
            PdfColor(112, 173, 71));
        break;

      case PdfGridBuiltInStyle.gridTable5Dark:
        _applyGridTable5Dark(PdfColor(0, 0, 0), PdfColor(153, 153, 153),
            PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent1:
        _applyGridTable5Dark(PdfColor(91, 155, 213), PdfColor(189, 214, 238),
            PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent2:
        _applyGridTable5Dark(PdfColor(237, 125, 49), PdfColor(247, 202, 172),
            PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent3:
        _applyGridTable5Dark(PdfColor(165, 165, 165), PdfColor(219, 219, 219),
            PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent4:
        _applyGridTable5Dark(PdfColor(255, 192, 0), PdfColor(255, 229, 153),
            PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent5:
        _applyGridTable5Dark(PdfColor(68, 114, 196), PdfColor(180, 198, 231),
            PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent6:
        _applyGridTable5Dark(PdfColor(112, 171, 71), PdfColor(197, 224, 179),
            PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.gridTable6Colorful:
        _applyGridTable6Colorful(PdfColor(102, 102, 102),
            PdfColor(204, 204, 204), PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent1:
        _applyGridTable6Colorful(PdfColor(156, 194, 229),
            PdfColor(222, 234, 246), PdfColor(46, 116, 181));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent2:
        _applyGridTable6Colorful(PdfColor(244, 176, 131),
            PdfColor(251, 228, 213), PdfColor(196, 89, 17));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent3:
        _applyGridTable6Colorful(PdfColor(201, 201, 201),
            PdfColor(237, 237, 237), PdfColor(123, 123, 123));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent4:
        _applyGridTable6Colorful(PdfColor(255, 217, 102),
            PdfColor(255, 242, 204), PdfColor(191, 143, 0));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent5:
        _applyGridTable6Colorful(PdfColor(142, 170, 219),
            PdfColor(217, 226, 243), PdfColor(47, 84, 150));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent6:
        _applyGridTable6Colorful(PdfColor(168, 208, 141),
            PdfColor(226, 239, 217), PdfColor(83, 129, 53));
        break;

      case PdfGridBuiltInStyle.gridTable7Colorful:
        _applyGridTable7Colorful(PdfColor(102, 102, 102),
            PdfColor(204, 204, 204), PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent1:
        _applyGridTable7Colorful(PdfColor(156, 194, 229),
            PdfColor(222, 234, 246), PdfColor(46, 116, 181));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent2:
        _applyGridTable7Colorful(PdfColor(244, 176, 131),
            PdfColor(251, 228, 213), PdfColor(196, 89, 17));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent3:
        _applyGridTable7Colorful(PdfColor(201, 201, 201),
            PdfColor(237, 237, 237), PdfColor(123, 123, 123));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent4:
        _applyGridTable7Colorful(PdfColor(255, 217, 102),
            PdfColor(255, 242, 204), PdfColor(191, 143, 0));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent5:
        _applyGridTable7Colorful(PdfColor(142, 170, 219),
            PdfColor(217, 226, 243), PdfColor(47, 84, 150));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent6:
        _applyGridTable7Colorful(PdfColor(168, 208, 141),
            PdfColor(226, 239, 217), PdfColor(83, 129, 53));
        break;
      case PdfGridBuiltInStyle.listTable1Light:
        _applyListTable1Light(PdfColor(102, 102, 102), PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent1:
        _applyListTable1Light(PdfColor(156, 194, 229), PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent2:
        _applyListTable1Light(PdfColor(244, 176, 131), PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent3:
        _applyListTable1Light(PdfColor(201, 201, 201), PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent4:
        _applyListTable1Light(PdfColor(255, 217, 102), PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent5:
        _applyListTable1Light(PdfColor(142, 170, 219), PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent6:
        _applyListTable1Light(PdfColor(168, 208, 141), PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.listTable2:
        _applyListTable2(PdfColor(102, 102, 102), PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.listTable2Accent1:
        _applyListTable2(PdfColor(156, 194, 229), PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.listTable2Accent2:
        _applyListTable2(PdfColor(244, 176, 131), PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.listTable2Accent3:
        _applyListTable2(PdfColor(201, 201, 201), PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.listTable2Accent4:
        _applyListTable2(PdfColor(255, 217, 102), PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.listTable2Accent5:
        _applyListTable2(PdfColor(142, 170, 219), PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.listTable2Accent6:
        _applyListTable2(PdfColor(168, 208, 141), PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.listTable3:
        _applyListTable3(PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.listTable3Accent1:
        _applyListTable3(PdfColor(91, 155, 213));
        break;

      case PdfGridBuiltInStyle.listTable3Accent2:
        _applyListTable3(PdfColor(237, 125, 49));
        break;

      case PdfGridBuiltInStyle.listTable3Accent3:
        _applyListTable3(PdfColor(165, 165, 165));
        break;

      case PdfGridBuiltInStyle.listTable3Accent4:
        _applyListTable3(PdfColor(255, 192, 0));
        break;

      case PdfGridBuiltInStyle.listTable3Accent5:
        _applyListTable3(PdfColor(68, 114, 196));
        break;

      case PdfGridBuiltInStyle.listTable3Accent6:
        _applyListTable3(PdfColor(112, 171, 71));
        break;

      case PdfGridBuiltInStyle.listTable4:
        _applyListTable4(PdfColor(102, 102, 102), PdfColor(0, 0, 0),
            PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.listTable4Accent1:
        _applyListTable4(PdfColor(156, 194, 229), PdfColor(91, 155, 213),
            PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.listTable4Accent2:
        _applyListTable4(PdfColor(244, 176, 131), PdfColor(237, 125, 49),
            PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.listTable4Accent3:
        _applyListTable4(PdfColor(201, 201, 201), PdfColor(165, 165, 165),
            PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.listTable4Accent4:
        _applyListTable4(PdfColor(255, 217, 102), PdfColor(255, 192, 0),
            PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.listTable4Accent5:
        _applyListTable4(PdfColor(142, 170, 219), PdfColor(68, 114, 196),
            PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.listTable4Accent6:
        _applyListTable4(PdfColor(168, 208, 141), PdfColor(112, 173, 71),
            PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.listTable5Dark:
        _applyListTable5Dark(PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent1:
        _applyListTable5Dark(PdfColor(91, 155, 213));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent2:
        _applyListTable5Dark(PdfColor(237, 125, 49));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent3:
        _applyListTable5Dark(PdfColor(165, 165, 165));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent4:
        _applyListTable5Dark(PdfColor(255, 192, 0));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent5:
        _applyListTable5Dark(PdfColor(68, 114, 196));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent6:
        _applyListTable5Dark(PdfColor(112, 173, 71));
        break;

      case PdfGridBuiltInStyle.listTable6Colorful:
        _applyListTable6Colorful(PdfColor(102, 102, 102),
            PdfColor(204, 204, 204), PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent1:
        _applyListTable6Colorful(PdfColor(91, 155, 213),
            PdfColor(222, 234, 246), PdfColor(46, 116, 181));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent2:
        _applyListTable6Colorful(PdfColor(237, 125, 49),
            PdfColor(251, 228, 213), PdfColor(196, 89, 17));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent3:
        _applyListTable6Colorful(PdfColor(165, 165, 165),
            PdfColor(237, 237, 237), PdfColor(123, 123, 123));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent4:
        _applyListTable6Colorful(PdfColor(255, 192, 0), PdfColor(255, 242, 204),
            PdfColor(191, 143, 0));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent5:
        _applyListTable6Colorful(PdfColor(68, 114, 196),
            PdfColor(217, 226, 243), PdfColor(47, 84, 150));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent6:
        _applyListTable6Colorful(PdfColor(112, 173, 71),
            PdfColor(226, 239, 217), PdfColor(83, 129, 53));
        break;

      case PdfGridBuiltInStyle.listTable7Colorful:
        _applyListTable7Colorful(PdfColor(102, 102, 102),
            PdfColor(204, 204, 204), PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent1:
        _applyListTable7Colorful(PdfColor(91, 155, 213),
            PdfColor(222, 234, 246), PdfColor(46, 116, 181));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent2:
        _applyListTable7Colorful(PdfColor(237, 125, 49),
            PdfColor(251, 228, 213), PdfColor(196, 89, 17));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent3:
        _applyListTable7Colorful(PdfColor(165, 165, 165),
            PdfColor(237, 237, 237), PdfColor(123, 123, 123));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent4:
        _applyListTable7Colorful(PdfColor(255, 192, 0), PdfColor(255, 242, 204),
            PdfColor(191, 143, 0));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent5:
        _applyListTable7Colorful(PdfColor(68, 114, 196),
            PdfColor(217, 226, 243), PdfColor(47, 84, 150));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent6:
        _applyListTable7Colorful(PdfColor(112, 173, 71),
            PdfColor(226, 239, 217), PdfColor(83, 129, 53));
        break;

      default:
    }
  }

  PdfFont _createBoldFont(PdfFont font) {
    PdfFont boldStyleFont;
    if (font is PdfStandardFont) {
      final PdfStandardFont standardFont = font;
      boldStyleFont = PdfStandardFont(standardFont.fontFamily, font.size,
          style: PdfFontStyle.bold);
    } else {
      final PdfTrueTypeFont trueTypeFont = font as PdfTrueTypeFont;
      boldStyleFont = PdfTrueTypeFont(
          trueTypeFont._fontInternal._fontData, font.size,
          style: PdfFontStyle.bold);
    }
    return boldStyleFont;
  }

  PdfFont _createRegularFont(PdfFont font) {
    PdfFont regularStyleFont;
    if (font is PdfStandardFont) {
      final PdfStandardFont standardFont = font;
      regularStyleFont = PdfStandardFont(standardFont.fontFamily, font.size,
          style: PdfFontStyle.regular);
    } else {
      final PdfTrueTypeFont trueTypeFont = font as PdfTrueTypeFont;
      regularStyleFont = PdfTrueTypeFont(
          trueTypeFont._fontInternal._fontData, font.size,
          style: PdfFontStyle.regular);
    }
    return regularStyleFont;
  }

  PdfFont _createItalicFont(PdfFont font) {
    PdfFont italicStyleFont;
    if (font is PdfStandardFont) {
      final PdfStandardFont standardFont = font;
      italicStyleFont = PdfStandardFont(standardFont.fontFamily, font.size,
          style: PdfFontStyle.italic);
    } else {
      final PdfTrueTypeFont trueTypeFont = font as PdfTrueTypeFont;
      italicStyleFont = PdfTrueTypeFont(
          trueTypeFont._fontInternal._fontData, font.size,
          style: PdfFontStyle.italic);
    }
    return italicStyleFont;
  }

  PdfFont _changeFontStyle(PdfFont font) {
    PdfFont pdfFont;
    if (font.style == PdfFontStyle.regular) {
      pdfFont = _createBoldFont(font);
    } else if (font.style == PdfFontStyle.bold) {
      pdfFont = _createRegularFont(font);
    }
    return pdfFont;
  }

  PdfBrush _applyBandedColStyle(
      bool firstColumn, PdfColor backColor, int cellIndex) {
    PdfBrush backBrush;
    if (firstColumn) {
      if (cellIndex % 2 == 0) {
        backBrush = PdfSolidBrush(backColor);
      }
    } else {
      if (cellIndex % 2 != 0) {
        backBrush = PdfSolidBrush(backColor);
      }
    }
    return backBrush;
  }

  PdfBrush _applyBandedRowStyle(
      bool headerRow, PdfColor backColor, int rowIndex) {
    PdfBrush backBrush;
    if (headerRow) {
      if (rowIndex % 2 != 0) {
        backBrush = PdfSolidBrush(backColor);
      }
    } else {
      if (rowIndex % 2 == 0) {
        backBrush = PdfSolidBrush(backColor);
      }
    }
    return backBrush;
  }

  void _applyTableGridLight(PdfColor borderColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 1);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
        }
      }
    }
    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
      }
    }
  }

  void _applyPlainTable1(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = borderPen;
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
            }
          } else {
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              if (_bandedRow) {
                if (i % 2 != 0) {
                  cell.style.backgroundBrush = backBrush;
                }
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);
          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(borderColor);
          if (_bandedColumn) {
            if (!(_lastColumn && j == row.cells.count)) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
          }
        }
      }
    }
  }

  void _applyPlainTable2(PdfColor borderColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfPen emptyPen = PdfPen(PdfColor.empty);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = borderPen;
          if (_bandedColumn) {
            cell.style.borders.left = borderPen;
            cell.style.borders.right = borderPen;
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.bottom = borderPen;
            if (_firstColumn && j == 1) {
              cell.style.borders.left = emptyPen;
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.borders.right = emptyPen;
            }
          } else {
            if (_bandedRow) {
              cell.style.borders.top = borderPen;
              cell.style.borders.bottom = borderPen;
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.borders.left = emptyPen;
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.borders.right = emptyPen;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;
        if (i == rows.count) {
          cell.style.borders.bottom = borderPen;
        }
        if (_bandedColumn) {
          cell.style.borders.left = borderPen;
          cell.style.borders.right = borderPen;
        }
        if (_bandedRow) {
          cell.style.borders.top = borderPen;
          cell.style.borders.bottom = borderPen;
        }
        if (i == rows.count && _totalRow) {
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = borderPen;
          if (_bandedColumn) {
            cell.style.borders.left = borderPen;
            cell.style.borders.right = borderPen;
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.right = emptyPen;
          } else if (_bandedColumn) {
            cell.style.borders.right = emptyPen;
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.left = emptyPen;
          } else if (_bandedColumn) {
            cell.style.borders.left = emptyPen;
          }
        }
      }
    }
  }

  void _applyPlainTable3(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfPen whitePen = PdfPen(PdfColor.empty);
    final PdfBrush backBrush = PdfSolidBrush(backColor);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = whitePen;
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
            if (i == 1) {
              cell.style.borders.bottom = borderPen;
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
            }
          } else {
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
                if (_firstColumn && j == 2) {
                  cell.style.borders.left = borderPen;
                }
                if (_headerRow && i == 1) {
                  cell.style.borders.top = borderPen;
                }
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
              if (cell.value is String) {
                final String cellvalue = cell.value as String;
                cell.value = cellvalue.toUpperCase();
              }
              cell.style.borders.right = borderPen;
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.borders.all = whitePen;
              if (cell.value is String) {
                final String cellvalue = cell.value as String;
                cell.value = cellvalue.toUpperCase();
              }
              if (_bandedColumn) {
                cell.style.backgroundBrush = null;
                if (_bandedRow) {
                  if (i % 2 != 0) {
                    cell.style.backgroundBrush = backBrush;
                  }
                }
              }
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = whitePen;
        if (_bandedRow && _bandedColumn) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (_firstColumn && j == 2) {
            cell.style.borders.left = borderPen;
          }
          if (_headerRow && i == 1) {
            cell.style.borders.top = borderPen;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              if (_firstColumn && j == 2) {
                cell.style.borders.left = borderPen;
              }
              if (_headerRow && i == 1) {
                cell.style.borders.top = borderPen;
              }
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (_firstColumn && j == 2) {
              cell.style.borders.left = borderPen;
            }
            if (_headerRow && i == 1) {
              cell.style.borders.top = borderPen;
            }
          }
        }
        if (i == rows.count && _totalRow) {
          if (_bandedRow) {
            cell.style.borders.all = whitePen;
          }
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          if (cell.value is String) {
            final String cellvalue = cell.value as String;
            cell.value = cellvalue.toUpperCase();
          }
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              if (_firstColumn && j == 2) {
                cell.style.borders.left = borderPen;
              }
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
          }
          cell.style.borders.right = borderPen;
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
            cell.style.backgroundBrush = null;

            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }
            cell.style.borders.all = whitePen;
          } else if (_bandedColumn) {
            cell.style.backgroundBrush = null;
          }
        }

        if (_headerRow && i == 1) {
          cell.style.borders.top = borderPen;
        }
      }
    }
  }

  void _applyPlainTable4(PdfColor backColor) {
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen whitePen = PdfPen(PdfColor.empty);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = whitePen;
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
            }
          } else {
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
              if (cell.value is String) {
                final String cellvalue = cell.value as String;
                cell.value = cellvalue.toUpperCase();
              }
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              if (_bandedRow) {
                if (i % 2 != 0) {
                  cell.style.backgroundBrush = backBrush;
                }
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.borders.all = whitePen;
              cell.style.font = _changeFontStyle(font);
              if (cell.value is String) {
                final String cellvalue = cell.value as String;
                cell.value = cellvalue.toUpperCase();
              }
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = whitePen;
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
          }
        }
        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);
          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.borders.all = whitePen;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          if (cell.value is String) {
            final String cellvalue = cell.value as String;
            cell.value = cellvalue.toUpperCase();
          }
          if (cell.value is String) {
            final String cellvalue = cell.value as String;
            cell.value = cellvalue.toUpperCase();
          }
          if (_bandedColumn) {
            if (!(_lastColumn && j == row.cells.count)) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
          }
        }
      }
    }
  }

  void _applyPlainTable5(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfPen whitePen = PdfPen(PdfColor.empty);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen backBrushPen = PdfPen(backColor, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = whitePen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            if (font.style != PdfFontStyle.italic) {
              cell.style.font = _createItalicFont(font);
            }
            if (i == 1) {
              cell.style.borders.bottom = borderPen;
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                if (_firstColumn && j == 2) {
                  cell.style.borders.left = borderPen;
                } else {
                  cell.style.borders.all = backBrushPen;
                }
              }
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
                if (_firstColumn && j == 2) {
                  cell.style.borders.left = borderPen;
                } else {
                  cell.style.borders.all = backBrushPen;
                }
              }
            }
            if (_firstColumn && j == 1) {
              cell.style.borders.all = whitePen;
              cell.style.backgroundBrush = null;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              if (font.style != PdfFontStyle.italic) {
                cell.style.font = _createItalicFont(font);
              }
              cell.style.borders.right = borderPen;
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _createItalicFont(font);
              cell.style.borders.all = whitePen;
              cell.style.backgroundBrush = null;
              cell.style.borders.left = borderPen;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = whitePen;
        if (_bandedRow && _bandedColumn) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);
          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (cell.style.backgroundBrush != null) {
            if (_firstColumn && j == 2) {
              cell.style.borders.left = borderPen;
            } else {
              cell.style.borders.all = backBrushPen;
            }
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              if (_firstColumn && j == 2) {
                cell.style.borders.left = borderPen;
              } else {
                cell.style.borders.all = backBrushPen;
              }
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (_firstColumn && j == 2) {
              cell.style.borders.left = borderPen;
            } else {
              cell.style.borders.all = backBrushPen;
            }
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.borders.all = PdfPen(PdfColor.empty);
          cell.style.backgroundBrush = null;
          cell.style.borders.top = borderPen;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          if (font.style != PdfFontStyle.italic) {
            cell.style.font = _createItalicFont(font);
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.borders.all = whitePen;
            cell.style.backgroundBrush = null;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            if (font.style != PdfFontStyle.italic) {
              cell.style.font = _createItalicFont(font);
            }
            cell.style.borders.right = borderPen;
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _createItalicFont(font);
            cell.style.borders.all = whitePen;
            cell.style.backgroundBrush = null;
            cell.style.borders.left = borderPen;
          }
        }

        if (_headerRow && i == 1) {
          cell.style.borders.top = borderPen;
        }
      }
    }
  }

  void _applyGridTable1Light(PdfColor borderColor, PdfColor headerBottomColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          } else {
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        if (_headerRow && i == 1) {
          cell.style.borders.top = PdfPen(headerBottomColor);
        }
        if (_totalRow) {
          if (i == rows.count) {
            cell.style.borders.top = PdfPen(headerBottomColor);
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
      }
    }
  }

  void _applyGridTable2(PdfColor borderColor, PdfColor backColor) {
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen borderPen = PdfPen(borderColor, width: 0.25);
    final PdfPen backColorPen = PdfPen(backColor, width: 0.25);
    final PdfPen emptyPen = PdfPen(PdfColor.empty);
    final PdfPen headerBorder = PdfPen(borderColor);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        row.cells[0].style.borders.bottom = headerBorder;
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          if (j == 1) {
            cell.style.borders.left = emptyPen;
          } else if (j == row.cells.count) {
            cell.style.borders.right = emptyPen;
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = PdfPen(PdfColor.empty);
            if (cell._row._grid.style.cellSpacing > 0) {
              cell.style.borders.bottom = headerBorder;
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                if (j == 1) {
                  cell.style.borders.left = backColorPen;
                } else if (row.cells.count % 2 != 0 && j == row.cells.count) {
                  cell.style.borders.right = backColorPen;
                }
              }
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
              if (cell.style.backgroundBrush != null) {
                if (j == 1) {
                  cell.style.borders.left = backColorPen;
                } else if (j == row.cells.count) {
                  cell.style.borders.right = backColorPen;
                }
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              if (_bandedRow) {
                if (i % 2 != 0) {
                  cell.style.backgroundBrush = backBrush;
                }
                if (cell.style.backgroundBrush != null) {
                  if (j == 1) {
                    cell.style.borders.left = backColorPen;
                  } else if (j == row.cells.count) {
                    cell.style.borders.right = backColorPen;
                  }
                }
              }

              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        if (j == 1) {
          cell.style.borders.left = emptyPen;
        } else if (j == row.cells.count) {
          cell.style.borders.right = emptyPen;
        }
        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedRowStyle(_headerRow, backColor, i);
          cell.style.backgroundBrush ??=
              _applyBandedColStyle(_firstColumn, backColor, j);
          if (cell.style.backgroundBrush != null) {
            if (j == 1) {
              cell.style.borders.left = backColorPen;
            } else if (j == row.cells.count) {
              cell.style.borders.right = backColorPen;
            }
          }
        } else {
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);

            if (cell.style.backgroundBrush != null) {
              if (j == 1) {
                cell.style.borders.left = backColorPen;
              } else if (j == row.cells.count) {
                cell.style.borders.right = backColorPen;
              }
            }
          }
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              if (j == 1) {
                cell.style.borders.left = backColorPen;
              } else if (row.cells.count % 2 != 0 && j == row.cells.count) {
                cell.style.borders.right = backColorPen;
              }
            }
          }
        }
        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.backgroundBrush = null;
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = headerBorder;
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.backgroundBrush = null;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
              if (cell.style.backgroundBrush == null) {
                cell.style.borders.right = emptyPen;
              }
            }
          } else if (_bandedColumn) {
            cell.style.backgroundBrush = null;
          }
        }

        if (_headerRow && _headers.count > 0) {
          if (i == 1) {
            cell.style.borders.top = headerBorder;
          }
        }
      }
    }
  }

  void _applyGridTable3(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen whitePen = PdfPen(PdfColor.empty);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = whitePen;
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = whitePen;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _createItalicFont(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = whitePen;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _createItalicFont(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.all = PdfPen(PdfColor.empty);
          cell.style.backgroundBrush = null;
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = whitePen;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _createItalicFont(font);
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderPen;
            }
          } else {
            cell.style.borders.top = borderPen;
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = whitePen;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _createItalicFont(font);
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderPen;
            }
          } else {
            cell.style.borders.top = borderPen;
          }
        }
      }
    }
  }

  void _applyGridTable4(
      PdfColor borderColor, PdfColor backColor, PdfColor headerBackColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen headerBackColorPen = PdfPen(headerBackColor, width: 0.5);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = PdfPen(headerBackColor);
            cell.style.textBrush = PdfSolidBrush(PdfColor(255, 255, 255));
            cell.style.backgroundBrush = PdfSolidBrush(headerBackColor);
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              if (_bandedColumn) {
                cell.style.backgroundBrush =
                    _applyBandedColStyle(_firstColumn, backColor, j);
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);
          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }

          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(borderColor);
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }

            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          } else if (_bandedColumn) {
            cell.style.backgroundBrush = null;
          }
        }

        if (_headerRow && _headers.count > 0) {
          if (i == 1) {
            cell.style.borders.top = headerBackColorPen;
          }
        }
      }
    }
  }

  void _applyGridTable5Dark(PdfColor headerBackColor, PdfColor oddRowBackColor,
      PdfColor evenRowBackColor) {
    final PdfPen whitePen = PdfPen(PdfColor(255, 255, 255), width: 0.5);
    final PdfBrush evenRowBrush = PdfSolidBrush(evenRowBackColor);
    final PdfBrush oddRowBrush = PdfSolidBrush(oddRowBackColor);
    final PdfBrush headerBrush = PdfSolidBrush(headerBackColor);
    final PdfBrush textBrush = PdfSolidBrush(PdfColor(255, 255, 255));

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = whitePen;
          cell.style.backgroundBrush = evenRowBrush;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.textBrush = PdfSolidBrush(PdfColor(255, 255, 255));
            cell.style.backgroundBrush = headerBrush;
            cell.style.borders.all = PdfPen(PdfColor.empty, width: 0.5);
            if (j == 1) {
              cell.style.borders.left = whitePen;
            } else if (j == row.cells.count) {
              cell.style.borders.right = whitePen;
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, oddRowBackColor, j);

              cell.style.backgroundBrush ??= evenRowBrush;
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = oddRowBrush;
              }
            }
            if ((_firstColumn && j == 1) ||
                (_lastColumn && j == row.cells.count)) {
              cell.style.backgroundBrush = headerBrush;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.textBrush = textBrush;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = whitePen;
        cell.style.backgroundBrush = evenRowBrush;

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, oddRowBackColor, j);
          if (cell.style.backgroundBrush == null) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, oddRowBackColor, i);

            cell.style.backgroundBrush ??= evenRowBrush;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, oddRowBackColor, j);

            cell.style.backgroundBrush ??= evenRowBrush;
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, oddRowBackColor, i);

            cell.style.backgroundBrush ??= evenRowBrush;
          }
        }
        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.textBrush = textBrush;
          cell.style.backgroundBrush = PdfSolidBrush(headerBackColor);
          cell.style.borders.all = whitePen;
          if (j == 1) {
            cell.style.borders.left = whitePen;
          } else if (j == row.cells.count) {
            cell.style.borders.right = whitePen;
          }
        }

        if ((_firstColumn && j == 1) || (_lastColumn && j == row.cells.count)) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = headerBrush;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.textBrush = textBrush;
          }
        }
      }
    }
  }

  void _applyGridTable6Colorful(
      PdfColor borderColor, PdfColor backColor, PdfColor textColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen headerBottomPen = PdfPen(borderColor);
    final PdfBrush textBrush = PdfSolidBrush(textColor);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          cell.style.textBrush = textBrush;
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
            }
          } else {
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        cell.style.textBrush = textBrush;

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          if (_bandedColumn && (!(_lastColumn && j == row.cells.count))) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(borderColor);
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }

        if (_headerRow && i == 1) {
          cell.style.borders.top = headerBottomPen;
        }
      }
    }
  }

  void _applyGridTable7Colorful(
      PdfColor borderColor, PdfColor backColor, PdfColor textColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfBrush textBrush = PdfSolidBrush(textColor);
    final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.textBrush = textBrush;
          cell.style.borders.all = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = PdfPen(PdfColor(255, 255, 255));
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }

            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = whitePen;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _createItalicFont(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = whitePen;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _createItalicFont(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];

      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        cell.style.textBrush = textBrush;
        if (_bandedRow && _bandedColumn) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.all = PdfPen(PdfColor.empty);
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = whitePen;
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderPen;
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _createItalicFont(font);
          } else {
            cell.style.borders.top = borderPen;
          }
        }

        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = whitePen;
            cell.style.borders.left = borderPen;
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderPen;
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _createItalicFont(font);
          } else {
            cell.style.borders.top = borderPen;
          }
        }
      }
    }
  }

  void _applyListTable1Light(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfPen emptyPen = PdfPen(PdfColor.empty);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen backBrushPen = PdfPen(backColor, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);

            if (i == 1) {
              cell.style.borders.bottom = PdfPen(borderColor);
            }
            if (_bandedColumn) {
              if (_lastColumn && j == rows.count) {
                cell.style.backgroundBrush =
                    _applyBandedColStyle(_firstColumn, backColor, j);
              }
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.all = backBrushPen;
              }
              if (_lastColumn && j == row.cells.count) {
                cell.style.borders.all = emptyPen;
                cell.style.backgroundBrush = null;
              }
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.all = backBrushPen;
              }
            }

            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
                cell.style.borders.all = backBrushPen;
              }
            }

            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = emptyPen;
              if (_bandedRow && i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (cell.style.backgroundBrush != null) {
            cell.style.borders.all = backBrushPen;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.all = backBrushPen;
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.all = backBrushPen;
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          } else {
            cell.style.borders.top = borderPen;
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = emptyPen;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          cell.style.borders.all = emptyPen;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          if (_bandedColumn) {
            if (!(_lastColumn && j == row.cells.count)) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.all = backBrushPen;
            }
          }

          cell.style.borders.top = PdfPen(borderColor);
        }

        if (_headerRow && i == 1) {
          cell.style.borders.top = borderPen;
        }
      }
    }
  }

  void _applyListTable2(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen backColorPen = PdfPen(backColor, width: 0.5);
    final PdfPen emptyPen = PdfPen(PdfColor.empty, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.borders.bottom = borderPen;
          cell.style.borders.top = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (_lastColumn && j == row.cells.count) {
                cell.style.backgroundBrush = null;
              }
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.right = backColorPen;
                cell.style.borders.left = backColorPen;
              }
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.right = backColorPen;
                cell.style.borders.left = backColorPen;
              }
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.borders.left = backColorPen;
                cell.style.borders.right = backColorPen;
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              cell.style.borders.left = emptyPen;
              cell.style.borders.right = emptyPen;
              if (_bandedRow && i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
                if (cell.style.backgroundBrush != null) {
                  cell.style.borders.left = backColorPen;
                  cell.style.borders.right = backColorPen;
                }
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;
        cell.style.borders.bottom = borderPen;
        cell.style.borders.top = borderPen;
        if (_bandedRow && _bandedColumn) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (cell.style.backgroundBrush != null) {
            cell.style.borders.right = backColorPen;
            cell.style.borders.left = backColorPen;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.right = backColorPen;
              cell.style.borders.left = backColorPen;
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.left = backColorPen;
              cell.style.borders.right = backColorPen;
            }
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = borderPen;
          cell.style.borders.bottom = borderPen;

          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);

          if (_bandedColumn) {
            if (!(j == row.cells.count && _lastColumn)) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.right = backColorPen;
              cell.style.borders.left = backColorPen;
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.left = emptyPen;
            cell.style.borders.right = emptyPen;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.right = backColorPen;
              }
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
      }
    }
  }

  void _applyListTable3(PdfColor backColor) {
    final PdfPen backColorPen = PdfPen(backColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen emptyPen = PdfPen(PdfColor.empty, width: 0.5);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = backColorPen;
          if (j == 1) {
            cell.style.borders.left = backColorPen;
          } else if (j == row.cells.count) {
            cell.style.borders.right = backColorPen;
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = backColorPen;
            cell.style.backgroundBrush = backBrush;
            cell.style.textBrush = PdfSolidBrush(PdfColor(255, 255, 255));
          } else {
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
          if (_bandedColumn) {
            cell.style.borders.left = backColorPen;
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;
        if (headers.count == 0 && i == 1) {
          cell.style.borders.top = backColorPen;
        }
        if (j == 1) {
          cell.style.borders.left = backColorPen;
        } else if (j == row.cells.count) {
          cell.style.borders.right = backColorPen;
        }
        if (i == rows.count) {
          cell.style.borders.bottom = backColorPen;
        }
        if (_bandedColumn) {
          cell.style.borders.left = backColorPen;
        }
        if (_bandedRow) {
          cell.style.borders.top = backColorPen;
        }
        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(backColor);
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
      }
    }
  }

  void _applyListTable4(
      PdfColor borderColor, PdfColor headerBackColor, PdfColor bandRowColor) {
    final PdfPen borderColorPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush headerBrush = PdfSolidBrush(headerBackColor);
    final PdfBrush bandRowBrush = PdfSolidBrush(bandRowColor);
    final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = whitePen;
          cell.style.borders.top = borderColorPen;
          if (j == 1) {
            cell.style.borders.left = borderColorPen;
          } else if (j == row.cells.count) {
            cell.style.borders.right = borderColorPen;
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = PdfPen(headerBackColor, width: 0.5);
            cell.style.backgroundBrush = headerBrush;
            cell.style.textBrush = PdfSolidBrush(PdfColor(255, 255, 255));
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, bandRowColor, j);
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = bandRowBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;

              if (_bandedRow && i % 2 != 0) {
                cell.style.backgroundBrush = bandRowBrush;
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = whitePen;
        cell.style.borders.top = borderColorPen;
        if (j == 1) {
          cell.style.borders.left = borderColorPen;
        } else if (j == row.cells.count) {
          cell.style.borders.right = borderColorPen;
        }
        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, bandRowColor, j);
          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, bandRowColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, bandRowColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, bandRowColor, i);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(borderColor);
          if (_bandedColumn) {
            if (!(_lastColumn && j == rows.count)) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, bandRowColor, j);
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, bandRowColor, i);
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }

        if (i == rows.count) {
          cell.style.borders.bottom = borderColorPen;
        }
      }
    }
  }

  void _applyListTable5Dark(PdfColor backColor) {
    final PdfBrush backColorBrush = PdfSolidBrush(backColor);
    final PdfPen whitePen = PdfPen(PdfColor(255, 255, 255), width: 0.5);
    final PdfBrush whiteBrush = PdfSolidBrush(PdfColor(255, 255, 255));
    final PdfPen emptyPen = PdfPen(PdfColor.empty);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.textBrush = whiteBrush;
          cell.style.backgroundBrush = backColorBrush;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.backgroundBrush = backColorBrush;
            cell.style.textBrush = whiteBrush;
            cell.style.borders.bottom =
                PdfPen(PdfColor(255, 255, 255), width: 2);
            if (_bandedColumn) {
              if (j > 1) {
                cell.style.borders.left = whitePen;
              }
            }
          } else {
            if (_firstColumn) {
              if (j == 1) {
                final PdfFont font = cell.style.font ??
                    row.style.font ??
                    row._grid.style.font ??
                    _defaultFont;
                cell.style.font = _changeFontStyle(font);
              } else if (j == 2) {
                cell.style.borders.left = whitePen;
              }
            }
            if (_bandedColumn) {
              if (j > 1) {
                cell.style.borders.left = whitePen;
              }
            }
            if (_bandedRow) {
              cell.style.borders.top = whitePen;
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.borders.left = whitePen;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;
        cell.style.textBrush = whiteBrush;
        cell.style.backgroundBrush = backColorBrush;
        if (_firstColumn) {
          if (!(_totalRow && i == rows.count)) {
            if (j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            } else if (j == 2) {
              cell.style.borders.left = whitePen;
            }
          }
        }
        if (_bandedColumn) {
          if (j > 1) {
            cell.style.borders.left = whitePen;
          }
        }
        if (_bandedRow) {
          cell.style.borders.top = whitePen;
        }
        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = whitePen;
          if (_headerRow) {
            if (_firstColumn && j == 1) {
              cell.style.borders.top = emptyPen;
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.borders.top = emptyPen;
            }
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.left = whitePen;
          }
        }
      }
    }
  }

  void _applyListTable6Colorful(
      PdfColor borderColor, PdfColor backColor, PdfColor textColor) {
    final PdfBrush backColorBrush = PdfSolidBrush(backColor);
    final PdfPen borderColorPen = PdfPen(borderColor, width: 0.5);
    final PdfPen backColorPen = PdfPen(backColor, width: 0.5);
    final PdfPen emptyPen = PdfPen(PdfColor.empty, width: 0.5);
    final PdfBrush textBrush = PdfSolidBrush(textColor);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = borderColorPen;
          cell.style.textBrush = textBrush;
          if (_headerRow) {
            if (_bandedColumn) {
              if (!(_lastColumn && j == row.cells.count)) {
                cell.style.backgroundBrush =
                    _applyBandedColStyle(_firstColumn, backColor, j);
              }
              if (cell.style.backgroundBrush != null) {
                cell..style.borders.left = backColorPen;
                cell.style.borders.right = backColorPen;
              }
            }

            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.bottom = borderColorPen;
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                if (i == 1 && _headerRow) {
                  cell.style.borders.top = borderColorPen;
                }
              }
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backColorBrush;
                if (j == 1) {
                  cell..style.borders.left = backColorPen;
                } else if (j == row.cells.count) {
                  cell.style.borders.right = backColorPen;
                }
                if (i == 1) {
                  cell.style.borders.top = borderColorPen;
                }
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = emptyPen;
              cell.style.borders.top = borderColorPen;
              if (_bandedRow) {
                if (i % 2 != 0) {
                  cell.style.backgroundBrush = backColorBrush;
                }
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell..style.borders.left = emptyPen;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.textBrush = textBrush;
        cell.style.borders.all = emptyPen;
        if (headers.count == 0 && i == 1) {
          cell.style.borders.top = borderColorPen;
        }
        if (i == rows.count) {
          cell.style.borders.bottom = borderColorPen;
        }

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (cell.style.backgroundBrush != null) {
            if (j == 1) {
              cell..style.borders.left = backColorPen;
            } else if (j == row.cells.count) {
              cell.style.borders.right = backColorPen;
            }
          }
          if (i == 1 && _headerRow) {
            cell.style.borders.top = borderColorPen;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              cell..style.borders.left = backColorPen;
              cell.style.borders.right = backColorPen;
              if (i == 1 && _headerRow) {
                cell.style.borders.top = borderColorPen;
              }
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (j == 1) {
              cell..style.borders.left = backColorPen;
            } else if (j == row.cells.count) {
              cell.style.borders.right = backColorPen;
            }
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderColorPen;
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell..style.borders.left = emptyPen;
            cell.style.borders.right = emptyPen;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.right = backColorPen;
              }
            }

            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderColorPen;
            }
          } else if (_bandedColumn) {
            cell.style.backgroundBrush = null;
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          cell..style.borders.left = emptyPen;
          cell.style.borders.right = emptyPen;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(borderColor);
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
            }
            if (cell.style.backgroundBrush != null) {
              cell..style.borders.left = backColorPen;
              cell.style.borders.right = backColorPen;
            }
          }
        }
      }
    }
  }

  void _applyListTable7Colorful(
      PdfColor borderColor, PdfColor backColor, PdfColor textColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfPen emptyPen = PdfPen(PdfColor.empty);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen backColorPen = PdfPen(backColor, width: 0.5);
    final PdfBrush textBrush = PdfSolidBrush(textColor);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.textBrush = textBrush;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            if (font.style != PdfFontStyle.italic) {
              cell.style.font = _createItalicFont(font);
            }
            if (i == 1) {
              cell.style.borders.bottom = borderPen;
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.all = backColorPen;
              }
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
                cell.style.borders.all = backColorPen;
              }
            }
            if (_firstColumn && j == 1) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = emptyPen;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _createItalicFont(font);
              cell.style.borders.right = borderPen;
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  row._grid.style.font ??
                  _defaultFont;
              cell.style.font = _createItalicFont(font);
              cell.style.borders.all = emptyPen;
              cell.style.borders.left = borderPen;
            }

            if (_firstColumn && j == 2) {
              cell.style.borders.left = borderPen;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;
        cell.style.textBrush = textBrush;

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (cell.style.backgroundBrush != null) {
            cell.style.borders.all = backColorPen;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.all = backColorPen;
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.all = backColorPen;
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = emptyPen;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _createItalicFont(font);
            cell.style.borders.right = borderPen;
          }
        }

        if (_firstColumn && j == 2) {
          cell.style.borders.all = emptyPen;
          cell.style.borders.left = borderPen;
        }

        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              row._grid.style.font ??
              _defaultFont;
          if (font.style != PdfFontStyle.italic) {
            cell.style.font = _createItalicFont(font);
          }
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = borderPen;
          cell.style.backgroundBrush = null;
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                row._grid.style.font ??
                _defaultFont;
            cell.style.font = _createItalicFont(font);
            cell.style.borders.all = emptyPen;
            cell.style.borders.left = borderPen;
          }
        }
        if (_headerRow && i == 1) {
          cell.style.borders.top = borderPen;
        }
      }
    }
  }
}

/// Delegate for handling StartCellLayoutEvent.
typedef PdfGridBeginCellLayoutCallback = void Function(
    Object sender, PdfGridBeginCellLayoutArgs args);

/// Delegate for handling EndCellLayoutEvent.
typedef PdfGridEndCellLayoutCallback = void Function(
    Object sender, PdfGridEndCellLayoutArgs args);

/// Represents arguments of StartCellLayout Event.
class PdfGridBeginCellLayoutArgs extends GridCellLayoutArgs {
  //Constructor
  PdfGridBeginCellLayoutArgs._(
      PdfGraphics graphics,
      int rowIndex,
      int cellInder,
      _Rectangle bounds,
      String value,
      PdfGridCellStyle style,
      bool isHeaderRow)
      : super._(graphics, rowIndex, cellInder, bounds, value, isHeaderRow) {
    if (style != null) {
      this.style = style;
    }
    skip = false;
  }
  //Fields
  /// PDF grid cell style
  PdfGridCellStyle style;

  /// A value that indicates whether the cell is drawn or not in the PDF document.
  bool skip;
}

/// Represents arguments of EndCellLayout Event.
class PdfGridEndCellLayoutArgs extends GridCellLayoutArgs {
  //Constructor
  PdfGridEndCellLayoutArgs._(PdfGraphics graphics, int rowIndex, int cellInder,
      _Rectangle bounds, String value, PdfGridCellStyle style, bool isHeaderRow)
      : super._(graphics, rowIndex, cellInder, bounds, value, isHeaderRow) {
    if (style != null) {
      this.style = style;
    }
  }
  //Fields
  /// PDF grid cell style
  PdfGridCellStyle style;
}

/// Represents the abstract class of the [GridCellLayoutArgs].
abstract class GridCellLayoutArgs {
  //Constructors
  /// Initializes a new instance of the [StartCellLayoutArgs] class.
  GridCellLayoutArgs._(PdfGraphics graphics, int rowIndex, int cellIndex,
      _Rectangle bounds, String value, bool isHeaderRow) {
    ArgumentError.checkNotNull(graphics);
    _rowIndex = rowIndex;
    _cellIndex = cellIndex;
    _value = value;
    _bounds = bounds.rect;
    _graphics = graphics;
    _isHeaderRow = isHeaderRow;
  }

  //Fields
  int _rowIndex;
  int _cellIndex;
  String _value;
  Rect _bounds;
  PdfGraphics _graphics;
  bool _isHeaderRow;

  //Properties
  /// Gets the index of the row.
  int get rowIndex => _rowIndex;

  /// Gets the index of the cell.
  int get cellIndex => _cellIndex;

  /// Gets the value.
  String get value => _value;

  /// Gets the bounds of the cell.
  Rect get bounds => _bounds;

  /// Gets the graphics, on which the cell should be drawn.
  PdfGraphics get graphics => _graphics;

  /// Gets the type of Grid row.
  bool get isHeaderRow => _isHeaderRow;
}

/// Arguments of BeginPageLayoutEvent.
class PdfGridBeginPageLayoutArgs extends BeginPageLayoutArgs {
  //Constructor
  PdfGridBeginPageLayoutArgs._(Rect bounds, PdfPage page, int startRow)
      : super(bounds, page) {
    startRowIndex = startRow ?? 0;
  }

  //Fields
  /// Gets the start row index.
  int startRowIndex;
}

/// Arguments of EndPageLayoutEvent.
class PdfGridEndPageLayoutArgs extends EndPageLayoutArgs {
  //Constructor
  PdfGridEndPageLayoutArgs._(PdfLayoutResult result) : super(result);
}

/// Represents the grid built-in style settings.
class PdfGridBuiltInStyleSettings {
  // Constructor
  /// Represents the grid built-in style settings.
  PdfGridBuiltInStyleSettings(
      {this.applyStyleForBandedColumns = false,
      this.applyStyleForBandedRows = true,
      this.applyStyleForFirstColumn = false,
      this.applyStyleForHeaderRow = true,
      this.applyStyleForLastColumn = false,
      this.applyStyleForLastRow = false});

  //Fields
  /// Gets or sets a value indicating whether to apply style bands to the columns in a table.
  bool applyStyleForBandedColumns;

  /// Gets or sets a value indicating whether to apply style bands to the rows in a table.
  bool applyStyleForBandedRows;

  /// Gets or sets a value indicating whether to apply first-column formatting to the first column of the specified table.
  bool applyStyleForFirstColumn;

  ///  Gets or sets a value indicating whether to apply heading-row formatting to the first row of the table.
  bool applyStyleForHeaderRow;

  /// Gets or sets a value indicating whether to apply first-column formatting to the first column of the specified table.
  bool applyStyleForLastColumn;

  /// Gets or sets a value indicating whether to apply last-row formatting to the last row of the specified table.
  bool applyStyleForLastRow;
}
