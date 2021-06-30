part of pdf;

class _PdfGridLayouter extends _ElementLayouter {
  _PdfGridLayouter(PdfGrid grid) : super(grid) {
    _initialize();
  }

  //Fields
  PdfGraphics? _currentGraphics;
  PdfPage? _currentPage;
  late _Size _currentPageBounds;
  late _Rectangle _currentBounds;
  late _Point _startLocation;
  late double _childHeight;
  late PdfHorizontalOverflowType _hType;
  List<List<int>>? _columnRanges;
  late int _cellEndIndex;
  late int _cellStartIndex;
  static int _repeatRowIndex = -1;
  late List<int> _parentCellIndexList;
  late int _currentRowIndex;
  late int _currentHeaderRowIndex;
  late int _rowBreakPageHeightCellIndex;
  late bool flag;
  late bool _isChanged;
  late _Point _currentLocation;
  bool? _isChildGrid;
  late double _newheight;

  //Properties
  PdfGrid? get _grid => _element as PdfGrid?;

  //Implementation
  void _initialize() {
    _rowBreakPageHeightCellIndex = 0;
    _newheight = 0;
    _hType = PdfHorizontalOverflowType.nextPage;
    _currentPageBounds = _Size.empty;
    _currentRowIndex = 0;
    _currentHeaderRowIndex = 0;
    _currentLocation = _Point.empty;
    _currentBounds = _Rectangle.empty;
    _columnRanges ??= <List<int>>[];
    _childHeight = 0;
    _cellStartIndex = 0;
    _cellEndIndex = 0;
    _isChanged = false;
    flag = true;
    _isChildGrid ??= false;
    _startLocation = _Point.empty;
  }

  void layout(PdfGraphics graphics, _Rectangle bounds) {
    final _PdfLayoutParams param = _PdfLayoutParams();
    param.bounds = bounds;
    _currentGraphics = graphics;
    if (_currentGraphics!._layer != null && _currentGraphics!._page != null) {
      final int index =
          _currentGraphics!._page!._section!._indexOf(_currentGraphics!._page!);
      if (!_grid!._listOfNavigatePages.contains(index)) {
        _grid!._listOfNavigatePages.add(index);
      }
    }
    _layoutInternal(param);
  }

  PdfLayoutFormat _getFormat(PdfLayoutFormat? format) {
    return format != null
        ? PdfLayoutFormat.fromFormat(format)
        : PdfLayoutFormat();
  }

  void _determineColumnDrawRanges() {
    int startColumn = 0;
    int endColumn = 0;
    double cellWidths = 0;
    final double availableWidth =
        _currentGraphics!.clientSize.width - _currentBounds.x;
    for (int i = 0; i < _grid!.columns.count; i++) {
      cellWidths += _grid!.columns[i].width;
      if (cellWidths >= availableWidth) {
        double subWidths = 0;
        for (int j = startColumn; j <= i; j++) {
          subWidths += _grid!.columns[j].width;
          if (subWidths > availableWidth) {
            break;
          }
          endColumn = j;
        }
        _columnRanges!.add(<int>[startColumn, endColumn]);
        startColumn = endColumn + 1;
        endColumn = startColumn;
        cellWidths = (endColumn <= i) ? _grid!.columns[i].width : 0;
      }
    }
    if (startColumn != _grid!.columns.count) {
      _columnRanges!.add(<int>[startColumn, _grid!.columns.count - 1]);
    }
  }

  PdfLayoutResult? _layoutOnPage(_PdfLayoutParams param) {
    final PdfLayoutFormat format = _getFormat(param.format);
    late PdfGridEndPageLayoutArgs endArgs;
    PdfLayoutResult? result;
    final Map<PdfPage?, List<int>> layoutedPages = <PdfPage?, List<int>>{};
    PdfPage? startPage = param.page;
    bool? isParentCell = false;
    final List<double?> cellBounds = <double?>[];
    for (int rangeIndex = 0; rangeIndex < _columnRanges!.length; rangeIndex++) {
      final List<int> range = _columnRanges![rangeIndex];
      _cellStartIndex = range[0];
      _cellEndIndex = range[1];
      if (_currentPage != null) {
        final Map<String, dynamic> pageLayoutResult = _raiseBeforePageLayout(
            _currentPage, _currentBounds.rect, _currentRowIndex);
        _currentBounds = _Rectangle.fromRect(pageLayoutResult['currentBounds']);
        _currentRowIndex = pageLayoutResult['currentRow'] as int;
        if (pageLayoutResult['cancel'] as bool) {
          result = PdfLayoutResult._(_currentPage!, _currentBounds.rect);
          break;
        }
      }
      bool drawHeader;
      if (_grid!._isBuiltinStyle && _grid!._parentCell == null) {
        if (_grid!._gridBuiltinStyle != PdfGridBuiltInStyle.tableGrid) {
          _grid!._applyBuiltinStyles(_grid!._gridBuiltinStyle);
        }
      }
      for (int rowIndex = 0; rowIndex < _grid!.headers.count; rowIndex++) {
        _currentHeaderRowIndex = rowIndex;
        final PdfGridRow row = _grid!.headers[rowIndex];
        final double headerHeight = _currentBounds.y;
        if (startPage != _currentPage) {
          for (int k = _cellStartIndex; k <= _cellEndIndex; k++) {
            if (row.cells[k]._isCellMergeContinue) {
              row.cells[k]._isCellMergeContinue = false;
              row.cells[k].value = '';
            }
          }
        }
        final _RowLayoutResult headerResult = _drawRow(row)!;
        if (headerHeight == _currentBounds.y) {
          drawHeader = true;
          _repeatRowIndex = _grid!.rows._indexOf(row);
        } else {
          drawHeader = false;
        }
        if (!headerResult.isFinish &&
            startPage != null &&
            format.layoutType != PdfLayoutType.onePage &&
            drawHeader) {
          _startLocation.x = _currentBounds.x;
          _currentPage = getNextPage(format);
          _startLocation.y = _currentBounds.y;
          if (_Rectangle.fromRect(format.paginateBounds) == _Rectangle.empty) {
            _currentBounds.x = _currentBounds.x + _startLocation.x;
          }
          _drawRow(row);
        }
      }
      int i = 0;
      final int length = _grid!.rows.count;
      bool repeatRow;
      double? startingHeight = 0;
      bool flag = true;
      if (isParentCell!) {
        _cellEndIndex = _cellStartIndex = _grid!._parentCellIndex;
        _parentCellIndexList = <int>[];
        _parentCellIndexList.add(_grid!._parentCellIndex);
        _grid!._parentCell!._present = true;
        PdfGrid parentGrid = _grid!._parentCell!._row!._grid;
        while (parentGrid._parentCell != null) {
          _parentCellIndexList.add(parentGrid._parentCellIndex);
          _cellEndIndex = parentGrid._parentCellIndex;
          _cellStartIndex = parentGrid._parentCellIndex;
          parentGrid._parentCell!._present = true;
          parentGrid = parentGrid._parentCell!._row!._grid;
          if (parentGrid._parentCell == null) {
            _parentCellIndexList.removeAt(_parentCellIndexList.length - 1);
          }
        }
        PdfSection section = _currentPage!._section!;
        int index = section._indexOf(_currentPage!);
        if ((!parentGrid._isDrawn) ||
            (!parentGrid._listOfNavigatePages.contains(index))) {
          section = _currentGraphics!._page!._section!;
          index = section._indexOf(_currentPage!);
          parentGrid._isDrawn = true;
          for (int rowIndex = 0; rowIndex < parentGrid.rows.count; rowIndex++) {
            final PdfGridRow row = parentGrid.rows[rowIndex];
            final PdfGridCell cell = row.cells[_cellStartIndex];
            cell.value = '';
            final _Point location = _Point(_currentBounds.x, _currentBounds.y);
            double width = parentGrid.columns[_cellStartIndex].width;
            if (width > _currentGraphics!.clientSize.width) {
              width = _currentGraphics!.clientSize.width - 2 * location.x;
            }
            double? height = cell.height;
            if (row.height > cell.height) {
              height = row.height;
            }
            cell._draw(_currentGraphics,
                _Rectangle(location.x, location.y, width, height), false);
            _currentBounds.y = _currentBounds.y + height;
          }
          _currentBounds.y = 0;
        }
        _drawParentGridRow(parentGrid);
        _cellStartIndex = range[0];
        _cellEndIndex = range[1];
      }
      cellBounds.clear();
      for (int rowIndex = 0; rowIndex < _grid!.rows.count; rowIndex++) {
        final PdfGridRow row = _grid!.rows[rowIndex];
        i++;
        _currentRowIndex = i - 1;
        double? originalHeight = _currentBounds.y;
        startPage = _currentPage;
        _repeatRowIndex = -1;
        if (flag && row._grid._isChildGrid!) {
          startingHeight = originalHeight;
          flag = false;
        }
        if (row._grid._isChildGrid! &&
            row._grid._parentCell!.rowSpan > 1 &&
            (startingHeight! + _childHeight).toInt() <
                (_currentBounds.y + row.height).toInt()) {
          if (_grid!.rows.count > i) {
            final PdfGrid temp = row._grid._parentCell!._row!._grid;
            for (int tempRowIndex = 0;
                tempRowIndex < temp.rows.count;
                tempRowIndex++) {
              final PdfGridRow tempRow = temp.rows[tempRowIndex];
              if (tempRow.cells[row._grid._parentCellIndex] ==
                  row._grid._parentCell) {
                final dynamic grid =
                    tempRow.cells[row._grid._parentCellIndex].value;
                if (grid is PdfGrid) {
                  grid.rows._rows.removeRange(0, i - 1);
                }
              }
            }
          }
          break;
        }
        _RowLayoutResult rowResult = _drawRow(row)!;
        cellBounds.add(rowResult.bounds.width);
        if (row._isRowBreaksNextPage) {
          double x = 0;
          for (int l = 0; l < row.cells.count; l++) {
            bool isNestedRowBreak = false;
            if (row.height == row.cells[l].height &&
                row.cells[l].value is PdfGrid) {
              final PdfGrid grid = row.cells[l].value as PdfGrid;
              for (int m = grid.rows.count; 0 < m; m--) {
                if (grid.rows[m - 1]._rowBreakHeight > 0) {
                  isNestedRowBreak = true;
                  break;
                }
                if (grid.rows[m - 1]._isRowBreaksNextPage) {
                  row._rowBreakHeight = grid.rows[m - 1]._rowBreakHeight;
                  break;
                }
                row._rowBreakHeight =
                    row._rowBreakHeight + grid.rows[m - 1].height;
              }
            }
            if (isNestedRowBreak) {
              break;
            }
          }
          for (int j = 0; j < row.cells.count; j++) {
            if (row.height > row.cells[j].height) {
              row.cells[j].value = '';
              _Rectangle rect;
              PdfPage? page = _getNextPage(_currentPage!);
              final PdfSection section = _currentPage!._section!;
              final int index = section._indexOf(page!);
              for (int k = 0;
                  k < (section._pageReferences!.count - 1) - index;
                  k++) {
                rect = _Rectangle(x, 0, row._grid.columns[j].width,
                    page!.getClientSize().height);
                _repeatRowIndex = -1;
                row.cells[j]._draw(page.graphics, rect, false);
                page = _getNextPage(page);
              }
              rect = _Rectangle(
                  x, 0, row._grid.columns[j].width, row._rowBreakHeight);
              row.cells[j]._draw(page!.graphics, rect, false);
            }
            x += row._grid.columns[j].width;
          }
        }
        if (originalHeight == _currentBounds.y) {
          repeatRow = true;
          _repeatRowIndex = _grid!.rows._indexOf(row);
        } else {
          repeatRow = false;
          _repeatRowIndex = -1;
        }
        while (!rowResult.isFinish && startPage != null) {
          final PdfLayoutResult tempResult = _getLayoutResult();
          if (startPage != _currentPage) {
            if (row._grid._isChildGrid! && row._grid._parentCell != null) {
              final _Rectangle bounds = _Rectangle(
                  format.paginateBounds.left,
                  format.paginateBounds.top,
                  param.bounds!.width,
                  tempResult.bounds.height);
              bounds.x = bounds.x + param.bounds!.x;
              bounds.y = bounds.y +
                  row._grid._parentCell!._row!._grid.style.cellPadding.top;
              if (bounds.height > _currentPageBounds.height) {
                bounds.height = _currentPageBounds.height - bounds.y;
                bounds.height = bounds.height -
                    row._grid._parentCell!._row!._grid.style.cellPadding.bottom;
              }
              for (int c = 0; c < row.cells.count; c++) {
                final PdfGridCell cell = row.cells[c];
                double cellWidth = 0.0;
                if (cell.columnSpan > 1) {
                  for (; c < cell.columnSpan; c++) {
                    cellWidth += row._grid.columns[c].width;
                  }
                } else {
                  cellWidth = max(cell.width, row._grid.columns[c].width);
                }
                _currentGraphics = cell._drawCellBorders(_currentGraphics!,
                    _Rectangle(bounds.x, bounds.y, cellWidth, bounds.height));
                bounds.x = bounds.x + cellWidth;
                c += cell.columnSpan - 1;
              }
            }
          }
          endArgs = _raisePageLayouted(tempResult);
          if (endArgs.cancel || repeatRow) {
            break;
          }
          if (repeatRow) {
            break;
          } else if (_grid!.allowRowBreakingAcrossPages) {
            _currentPage = getNextPage(format);
            originalHeight = _currentBounds.y;
            final _Point location = _Point(
                _grid!._defaultBorder.right.width / 2,
                _grid!._defaultBorder.top.width / 2);
            if (_Rectangle.fromRect(format.paginateBounds) ==
                    _Rectangle.empty &&
                _startLocation == location) {
              _currentBounds.x = _currentBounds.x + _startLocation.x;
              _currentBounds.y = _currentBounds.y + _startLocation.y;
            }
            if (_grid!._isChildGrid! && row._grid._parentCell != null) {
              if (_grid!._parentCell!._row!._grid.style._cellPadding != null) {
                if (row._rowBreakHeight +
                        _grid!._parentCell!._row!._grid.style.cellPadding.top <
                    _currentBounds.height) {
                  _currentBounds.y =
                      _grid!._parentCell!._row!._grid.style.cellPadding.top;
                }
              }
            }
            if (row._grid._parentCell != null) {
              row._grid._parentCell!._row!._isRowBreaksNextPage = true;
              row._grid._parentCell!._row!._rowBreakHeight =
                  row._rowBreakHeight +
                      _grid!._parentCell!._row!._grid.style.cellPadding.top +
                      _grid!._parentCell!._row!._grid.style.cellPadding.bottom;
            }
            if (row._noOfPageCount > 1) {
              final double temp = row._rowBreakHeight;
              for (int j = 1; j < row._noOfPageCount; j++) {
                row._rowBreakHeight = 0;
                row.height = (row._noOfPageCount - 1) *
                    _currentPage!.getClientSize().height;
                _drawRow(row);
                _currentPage = getNextPage(format);
                startPage = _currentPage;
              }
              row._rowBreakHeight = temp;
              row._noOfPageCount = 1;
              rowResult = _drawRow(row)!;
            } else {
              rowResult = _drawRow(row)!;
            }
          } else if (!_grid!.allowRowBreakingAcrossPages && i < length) {
            _currentPage = getNextPage(format);
            break;
          } else if (i >= length) {
            break;
          }
        }
        if (!rowResult.isFinish &&
            startPage != null &&
            format.layoutType != PdfLayoutType.onePage &&
            repeatRow) {
          _startLocation.x = _currentBounds.x;
          bool isAddNextPage = false;
          if (!_grid!._isSingleGrid) {
            for (int j = 0; j < _grid!.rows.count; j++) {
              bool isWidthGreaterthanParent = false;
              for (int k = 0; k < _grid!.rows[j].cells.count; k++) {
                if (_grid!.rows[j].cells[k].width > _currentPageBounds.width) {
                  isWidthGreaterthanParent = true;
                }
              }
              if (isWidthGreaterthanParent &&
                  _grid!.rows[j].cells[_rowBreakPageHeightCellIndex]
                          ._pageCount >
                      0) {
                isAddNextPage = true;
              }
            }
          }
          if (!_grid!._isRearranged && isAddNextPage) {
            final PdfSection section = _currentPage!._section!;
            final PdfPage page = PdfPage();
            section._isNewPageSection = true;
            section._add(page);
            _currentPage = page;
            section._isNewPageSection = false;
            _currentGraphics = _currentPage!.graphics;
            final Size clientSize = _currentPage!.getClientSize();
            _currentBounds =
                _Rectangle(0, 0, clientSize.width, clientSize.height);
            final int pageindex = _currentGraphics!._page!._section!
                ._indexOf(_currentGraphics!._page!);
            if (!_grid!._listOfNavigatePages.contains(pageindex)) {
              _grid!._listOfNavigatePages.add(pageindex);
            }
          } else {
            if (endArgs.nextPage == null) {
              _currentPage = getNextPage(format);
            } else {
              _currentPage = endArgs.nextPage;
              _currentGraphics = endArgs.nextPage!.graphics;
              _currentBounds = _Rectangle(
                  0,
                  0,
                  _currentGraphics!.clientSize.width,
                  _currentGraphics!.clientSize.height);
            }
          }
          final bool isSameSection =
              _currentPage!._section == param.page!._section;
          _currentBounds.y = format.paginateBounds.top == 0
              ? _grid!._defaultBorder.top.width / 2
              : format.paginateBounds.top;
          if (_currentPage != null) {
            final Map<String, dynamic> pageLayoutResult =
                _raiseBeforePageLayout(
                    _currentPage, _currentBounds.rect, _currentRowIndex);
            _currentBounds =
                _Rectangle.fromRect(pageLayoutResult['currentBounds']);
            _currentRowIndex = pageLayoutResult['currentRow'] as int;
            if (pageLayoutResult['cancel'] as bool) {
              break;
            }
          }
          if ((param.format != null) &&
              !param.format!._boundsSet &&
              param.bounds != null &&
              param.bounds!.height > 0 &&
              !_grid!._isChildGrid! &&
              isSameSection) {
            _currentBounds.height = param.bounds!.height;
          }
          _startLocation.y = _currentBounds.y;
          if (_Rectangle.fromRect(format.paginateBounds) == _Rectangle.empty) {
            _currentBounds.x = _currentBounds.x + _startLocation.x;
          }
          if (_currentBounds.x == _grid!._defaultBorder.left.width / 2) {
            _currentBounds.y = _currentBounds.y + _startLocation.x;
          }
          if (_grid!.repeatHeader) {
            for (int headerIndex = 0;
                headerIndex < _grid!.headers.count;
                headerIndex++) {
              _drawRow(_grid!.headers[headerIndex]);
            }
          }
          _drawRow(row);
          if (_currentPage != null &&
              !layoutedPages.containsKey(_currentPage)) {
            layoutedPages[_currentPage] = range;
          }
        }
        if (row._gridResult != null) {
          _currentPage = row._gridResult!.page;
          _currentGraphics = _currentPage!.graphics;
          _startLocation =
              _Point(row._gridResult!.bounds.left, row._gridResult!.bounds.top);
          _currentBounds.y = row._gridResult!.bounds.bottom;
          if (startPage != _currentPage) {
            final PdfSection secion = _currentPage!._section!;
            final int startIndex = secion._indexOf(startPage!) + 1;
            final int endIndex = secion._indexOf(_currentPage!);
            for (int page = startIndex; page < endIndex + 1; page++) {
              PdfGraphics pageGraphics = secion._getPageByIndex(page)!.graphics;
              final _Point location =
                  _Point(format.paginateBounds.left, format.paginateBounds.top);
              if (location == _Point.empty &&
                  _currentBounds.x > location.x &&
                  !row._grid._isChildGrid! &&
                  row._grid._parentCell == null) {
                location.x = _currentBounds.x;
              }
              double height = page == endIndex
                  ? (row._gridResult!.bounds.height - param.bounds!.y)
                  : (_currentBounds.height - location.y);
              if (height <= pageGraphics.clientSize.height) {
                height += param.bounds!.y;
              }
              if (row._grid._isChildGrid! && row._grid._parentCell != null) {
                location.x = location.x + param.bounds!.x;
              }
              location.y = format.paginateBounds.top;
              for (int c = 0; c < row.cells.count; c++) {
                final PdfGridCell cell = row.cells[c];
                double cellWidth = 0.0;
                if (cell.columnSpan > 1) {
                  for (; c < cell.columnSpan; c++) {
                    cellWidth += row._grid.columns[c].width;
                  }
                } else {
                  cellWidth = _grid!._isWidthSet
                      ? min(cell.width, row._grid.columns[c].width)
                      : max(cell.width, row._grid.columns[c].width);
                }
                pageGraphics = cell._drawCellBorders(pageGraphics,
                    _Rectangle(location.x, location.y, cellWidth, height));
                location.x = location.x + cellWidth;
                c += cell.columnSpan - 1;
              }
            }
            startPage = _currentPage;
          }
        }
      }
      bool isPdfGrid = false;
      double maximumCellBoundsWidth = 0;
      if (cellBounds.isNotEmpty) {
        maximumCellBoundsWidth = cellBounds[0]!;
      }
      final List<List<double?>> largeNavigatePage =
          List<List<double?>>.filled(1, List<double?>.filled(2, 0));
      for (int c = 0; c < _grid!.rows.count; c++) {
        if (_cellEndIndex != -1 &&
            _grid!.rows[c].cells[_cellEndIndex].value is PdfGrid) {
          final PdfGrid grid =
              _grid!.rows[c].cells[_cellEndIndex].value as PdfGrid;
          _grid!._rowLayoutBoundswidth = grid._rowLayoutBoundswidth;
          isPdfGrid = true;
          if (largeNavigatePage[0][0]! < grid._listOfNavigatePages.length) {
            largeNavigatePage[0][0] =
                grid._listOfNavigatePages.length.toDouble();
            largeNavigatePage[0][1] = cellBounds[c];
          } else if ((largeNavigatePage[0][0] ==
                  grid._listOfNavigatePages.length) &&
              (largeNavigatePage[0][1]! < cellBounds[c]!)) {
            largeNavigatePage[0][1] = cellBounds[c];
          }
        }
      }
      if (!isPdfGrid && cellBounds.isNotEmpty) {
        for (int c = 0; c < i - 1; c++) {
          if (maximumCellBoundsWidth < cellBounds[c]!) {
            maximumCellBoundsWidth = cellBounds[c]!;
          }
        }
        _grid!._rowLayoutBoundswidth = maximumCellBoundsWidth;
      } else {
        _grid!._rowLayoutBoundswidth = largeNavigatePage[0][1]!;
      }
      if (_columnRanges!.indexOf(range) < _columnRanges!.length - 1 &&
          startPage != null &&
          format.layoutType != PdfLayoutType.onePage) {
        isParentCell = _grid!._isChildGrid;
        if (largeNavigatePage[0][0]!.toInt() != 0) {
          final PdfSection section = _currentPage!._section!;
          final int pageIndex = section._indexOf(_currentPage!);
          if (section._count > pageIndex + largeNavigatePage[0][0]!.toInt()) {
            _currentPage = section
                ._getPageByIndex(pageIndex + largeNavigatePage[0][0]!.toInt());
          } else {
            _currentPage = PdfPage();
            section._isNewPageSection = true;
            section._add(_currentPage!);
            section._isNewPageSection = false;
          }
          _currentGraphics = _currentPage!.graphics;
          _currentBounds = _Rectangle(0, 0, _currentGraphics!.clientSize.width,
              _currentGraphics!.clientSize.height);
          final int pageindex = _currentGraphics!._page!._section!
              ._indexOf(_currentGraphics!._page!);
          if (!_grid!._listOfNavigatePages.contains(pageindex)) {
            _grid!._listOfNavigatePages.add(pageindex);
          }
        } else {
          _currentPage = getNextPage(format);
        }
        final _Point location = _Point(_grid!._defaultBorder.right.width / 2,
            _grid!._defaultBorder.top.width / 2);
        if (_Rectangle.fromRect(format.paginateBounds) == _Rectangle.empty &&
            _startLocation == location) {
          _currentBounds.x = _currentBounds.x + _startLocation.x;
          _currentBounds.y = _currentBounds.y + _startLocation.y;
        }
      }
    }
    if (_currentPage != null) {
      result = _getLayoutResult();
      if (_grid!.style.allowHorizontalOverflow &&
          _grid!.style.horizontalOverflowType ==
              PdfHorizontalOverflowType.nextPage) {
        _reArrangeLayoutedPages(layoutedPages);
      }
      _raisePageLayouted(result);
      return result;
    } else {
      return null;
    }
  }

  bool _drawParentGridRow(PdfGrid grid) {
    bool present = false;
    grid._isDrawn = true;
    double? y = _currentBounds.y;
    for (int rowIndex = 0; rowIndex < grid.rows.count; rowIndex++) {
      final PdfGridRow row = grid.rows[rowIndex];
      final PdfGridCell cell = row.cells[_cellStartIndex];
      cell.value = '';
      final _Point location = _Point(_currentBounds.x, _currentBounds.y);
      double width = grid.columns[_cellStartIndex].width;
      if (width > _currentGraphics!.clientSize.width) {
        width = _currentGraphics!.clientSize.width - 2 * location.x;
      }
      final double height = row.height > cell.height ? row.height : cell.height;
      if (_isChildGrid!) {
        cell._draw(_currentGraphics,
            _Rectangle(location.x, location.y, width, height), false);
      }
      _currentBounds.y = _currentBounds.y + height;
    }
    for (int j = 0; j < grid.rows.count; j++) {
      if (grid.rows[j].cells[_cellStartIndex]._present) {
        present = true;
        if (grid.rows[j].cells[_cellStartIndex].value is PdfGrid) {
          final PdfGrid? childGrid =
              grid.rows[j].cells[_cellStartIndex].value as PdfGrid?;
          grid.rows[j].cells[_cellStartIndex]._present = false;
          if (childGrid == _grid) {
            if (!_isChildGrid!) {
              _currentBounds.y = y!;
            } else {
              if (j == 0) {
                _currentBounds.y = _currentBounds.y - grid._size.height;
              } else {
                int k = j;
                while (k < grid.rows.count) {
                  _currentBounds.y = _currentBounds.y - grid.rows[k].height;
                  k++;
                }
              }
            }
            childGrid!._isDrawn = true;
            grid.rows[j].cells[_cellStartIndex].value = childGrid;
            _currentBounds.x = _currentBounds.x +
                grid.style.cellPadding.left +
                grid.style.cellPadding.right;
            _currentBounds.y = _currentBounds.y +
                grid.style.cellPadding.top +
                grid.style.cellPadding.bottom;
            _currentBounds.width = _currentBounds.width - 2 * _currentBounds.x;
            break;
          } else {
            _isChildGrid = true;
            if (_parentCellIndexList.isNotEmpty) {
              _cellStartIndex =
                  _parentCellIndexList[_parentCellIndexList.length - 1];
              _parentCellIndexList.removeAt(_parentCellIndexList.length - 1);
            }
            _currentBounds.y = y!;
            _currentBounds.x = _currentBounds.x +
                grid.style.cellPadding.left +
                grid.style.cellPadding.right;
            _currentBounds.y = _currentBounds.y +
                grid.style.cellPadding.top +
                grid.style.cellPadding.bottom;
            final bool isPresent = _drawParentGridRow(childGrid!);
            if (!isPresent) {
              _currentBounds.y = _currentBounds.y - childGrid._size.height;
            }
            _isChildGrid = false;
            break;
          }
        } else {
          y = y! + grid.rows[j].height;
        }
      } else {
        y = y! + grid.rows[j].height;
      }
    }
    return present;
  }

  _RowLayoutResult? _drawRow(PdfGridRow? row,
      [_RowLayoutResult? result, double? height]) {
    if (result == null && height == null) {
      _RowLayoutResult result = _RowLayoutResult();
      double rowHeightWithSpan = 0;
      bool isHeader = false;
      if (row!._rowSpanExists) {
        int currRowIndex = _grid!.rows._indexOf(row);
        int maxSpan = row._maximumRowSpan;
        if (currRowIndex == -1) {
          currRowIndex = _grid!.headers._indexOf(row);
          if (currRowIndex != -1) {
            isHeader = true;
          }
        }
        for (int i = currRowIndex; i < currRowIndex + maxSpan; i++) {
          rowHeightWithSpan +=
              isHeader ? _grid!.headers[i].height : _grid!.rows[i].height;
        }
        if ((rowHeightWithSpan > _currentBounds.height ||
                rowHeightWithSpan + _currentBounds.y > _currentBounds.height) &&
            !row._isPageBreakRowSpanApplied) {
          rowHeightWithSpan = 0;
          row._isPageBreakRowSpanApplied = true;
          for (int cellIndex = 0; cellIndex < row.cells.count; cellIndex++) {
            final PdfGridCell cell = row.cells[cellIndex];
            maxSpan = cell.rowSpan;
            for (int i = currRowIndex; i < currRowIndex + maxSpan; i++) {
              rowHeightWithSpan +=
                  isHeader ? _grid!.headers[i].height : _grid!.rows[i].height;
              if ((_currentBounds.y + rowHeightWithSpan) >
                  _currentPageBounds.height) {
                rowHeightWithSpan -=
                    isHeader ? _grid!.headers[i].height : _grid!.rows[i].height;
                for (int j = 0;
                    j < _grid!.rows[currRowIndex].cells.count;
                    j++) {
                  final int newSpan = i - currRowIndex;
                  if (!isHeader &&
                      (_grid!.rows[currRowIndex].cells[j].rowSpan == maxSpan)) {
                    _grid!.rows[currRowIndex].cells[j].rowSpan =
                        newSpan == 0 ? 1 : newSpan;
                    _grid!.rows[currRowIndex]._maximumRowSpan =
                        newSpan == 0 ? 1 : newSpan;
                    _grid!.rows[i].cells[j].rowSpan = maxSpan - newSpan;
                    PdfGrid? pdfGrid;
                    if (_grid!.rows[currRowIndex].cells[j].value is PdfGrid) {
                      pdfGrid =
                          _grid!.rows[currRowIndex].cells[j].value as PdfGrid?;
                    }
                    _grid!.rows[i].cells[j].stringFormat =
                        _grid!.rows[currRowIndex].cells[j].stringFormat;
                    _grid!.rows[i].cells[j].style =
                        _grid!.rows[currRowIndex].cells[j].style;
                    _grid!.rows[i].cells[j].style.backgroundImage = null;
                    _grid!.rows[i].cells[j].columnSpan =
                        _grid!.rows[currRowIndex].cells[j].columnSpan;
                    if (pdfGrid is PdfGrid &&
                        _currentBounds.y +
                                pdfGrid._size.height +
                                _grid!.rows[i].height +
                                pdfGrid.style.cellPadding.top +
                                pdfGrid.style.cellPadding.bottom >=
                            _currentBounds.height) {
                      _grid!.rows[i].cells[j].value =
                          _grid!.rows[currRowIndex].cells[j].value;
                    } else if (pdfGrid is! PdfGrid) {
                      _grid!.rows[i].cells[j].value =
                          _grid!.rows[currRowIndex].cells[j].value;
                    }
                    if (i > 0) {
                      _grid!.rows[i - 1]._rowSpanExists = true;
                    }
                    _grid!.rows[i].cells[j]._isRowMergeContinue = false;
                  } else if (isHeader &&
                      (_grid!.headers[currRowIndex].cells[j].rowSpan ==
                          maxSpan)) {
                    _grid!.headers[currRowIndex].cells[j].rowSpan =
                        newSpan == 0 ? 1 : newSpan;
                    _grid!.headers[i].cells[j].rowSpan = maxSpan - newSpan;
                    _grid!.headers[i].cells[j].stringFormat =
                        _grid!.headers[currRowIndex].cells[j].stringFormat;
                    _grid!.headers[i].cells[j].style =
                        _grid!.headers[currRowIndex].cells[j].style;
                    _grid!.headers[i].cells[j].columnSpan =
                        _grid!.headers[currRowIndex].cells[j].columnSpan;
                    _grid!.headers[i].cells[j].value =
                        _grid!.headers[currRowIndex].cells[j].value;
                    _grid!.headers[i - 1]._rowSpanExists = false;
                    _grid!.headers[i].cells[j]._isRowMergeContinue = false;
                  }
                }
                break;
              }
            }
            rowHeightWithSpan = 0;
          }
        }
      }
      double? height =
          row._rowBreakHeight > 0.0 ? row._rowBreakHeight : row.height;
      if (_grid!._isChildGrid! && _grid!._parentCell != null) {
        if (height +
                _grid!._parentCell!._row!._grid.style.cellPadding.bottom +
                _grid!._parentCell!._row!._grid.style.cellPadding.top >
            _currentPageBounds.height) {
          if (_grid!.allowRowBreakingAcrossPages) {
            result.isFinish = true;
            if (_grid!._isChildGrid! && row._rowBreakHeight > 0) {
              _currentBounds.y = _currentBounds.y +
                  _grid!._parentCell!._row!._grid.style.cellPadding.top;
              _currentBounds.x = _startLocation.x;
            }
            result.bounds = _currentBounds;
            result = _drawRowWithBreak(row, result, height);
          } else {
            _currentBounds.y = _currentBounds.y +
                _grid!._parentCell!._row!._grid.style.cellPadding.top;
            height = _currentBounds.height -
                _currentBounds.y -
                _grid!._parentCell!._row!._grid.style.cellPadding.bottom;
            result.isFinish = false;
            _drawRow(row, result, height);
          }
        } else if (_currentBounds.y +
                    _grid!._parentCell!._row!._grid.style.cellPadding.bottom +
                    height >
                _currentPageBounds.height ||
            _currentBounds.y +
                    _grid!._parentCell!._row!._grid.style.cellPadding.bottom +
                    height >
                _currentBounds.height ||
            _currentBounds.y +
                    _grid!._parentCell!._row!._grid.style.cellPadding.bottom +
                    rowHeightWithSpan >
                _currentPageBounds.height) {
          if (_repeatRowIndex > -1 && _repeatRowIndex == row._index) {
            if (_grid!.allowRowBreakingAcrossPages) {
              result.isFinish = true;
              if (_grid!._isChildGrid! && row._rowBreakHeight > 0) {
                _currentBounds.y = _currentBounds.y +
                    _grid!._parentCell!._row!._grid.style.cellPadding.top;

                _currentBounds.x = _startLocation.x;
              }
              result.bounds = _currentBounds;
              result = _drawRowWithBreak(row, result, height);
            } else {
              result.isFinish = false;
              _drawRow(row, result, height);
            }
          } else {
            result.isFinish = false;
          }
        } else {
          result.isFinish = true;
          if (_grid!._isChildGrid! && row._rowBreakHeight > 0) {
            height += _grid!._parentCell!._row!._grid.style.cellPadding.bottom;
          }
          _drawRow(row, result, height);
        }
      } else {
        if (height > _currentPageBounds.height) {
          if (_grid!.allowRowBreakingAcrossPages) {
            result.isFinish = true;
            result = _drawRowWithBreak(row, result, height);
          } else {
            result.isFinish = false;
            _drawRow(row, result, height);
          }
        } else if (_currentBounds.y + height > _currentPageBounds.height ||
            _currentBounds.y + height > _currentBounds.height ||
            _currentBounds.y + rowHeightWithSpan > _currentPageBounds.height) {
          if (_repeatRowIndex > -1 && _repeatRowIndex == row._index) {
            if (_grid!.allowRowBreakingAcrossPages) {
              result.isFinish = true;
              result = _drawRowWithBreak(row, result, height);
            } else {
              result.isFinish = false;
              _drawRow(row, result, height);
            }
          } else {
            result.isFinish = false;
          }
        } else {
          result.isFinish = true;
          _drawRow(row, result, height);
        }
      }
      return result;
    } else {
      bool? skipcell = false;
      final _Point location = _currentBounds.location;
      if (row!._grid._isChildGrid! &&
          row._grid.allowRowBreakingAcrossPages &&
          _startLocation.x != _currentBounds.x &&
          row._getWidth() < _currentPage!.getClientSize().width) {
        location.x = _startLocation.x;
      }
      result!.bounds = _Rectangle(location.x, location.y, 0, 0);
      height = _reCalculateHeight(row, height!);
      for (int i = _cellStartIndex; i <= _cellEndIndex; i++) {
        final bool cancelSpans =
            i > _cellEndIndex + 1 && row.cells[i].columnSpan > 1;
        if (!cancelSpans) {
          for (int j = 1; j < row.cells[i].columnSpan; j++) {
            row.cells[i + j]._isCellMergeContinue = true;
          }
        }
        final _Size size = _Size(_grid!.columns[i].width, height);
        if (size.width > _currentGraphics!.clientSize.width) {
          size.width = _currentGraphics!.clientSize.width;
        }
        if (_grid!._isChildGrid! && _grid!.style.allowHorizontalOverflow) {
          if (size.width >= _currentGraphics!.clientSize.width) {
            size.width = size.width - 2 * _currentBounds.x;
          }
        }
        if (!_checkIfDefaultFormat(_grid!.columns[i].format) &&
            _checkIfDefaultFormat(row.cells[i].stringFormat)) {
          row.cells[i].stringFormat = _grid!.columns[i].format;
        }

        PdfGridCellStyle cellstyle = row.cells[i].style;
        final Map<String, dynamic> bclResult = _raiseBeforeCellLayout(
            _currentGraphics,
            row._isHeaderRow ? _currentHeaderRowIndex : _currentRowIndex,
            i,
            _Rectangle(location.x, location.y, size.width, size.height),
            (row.cells[i].value is String) ? row.cells[i].value.toString() : '',
            cellstyle,
            row._isHeaderRow);
        cellstyle = bclResult['style'] as PdfGridCellStyle;
        final PdfGridBeginCellLayoutArgs? gridbclArgs =
            bclResult['args'] as PdfGridBeginCellLayoutArgs?;
        row.cells[i].style = cellstyle;
        if (gridbclArgs != null) {
          skipcell = gridbclArgs.skip;
        }
        if (!skipcell!) {
          if (row.cells[i].value is PdfGrid) {
            final PdfGrid grid = row.cells[i].value as PdfGrid;
            grid._parentCellIndex = i;
          }
          final _PdfStringLayoutResult? stringResult = row.cells[i]._draw(
              _currentGraphics,
              _Rectangle(location.x, location.y, size.width, size.height),
              cancelSpans);
          if (row._grid.style.allowHorizontalOverflow &&
              (row.cells[i].columnSpan > _cellEndIndex ||
                  i + row.cells[i].columnSpan > _cellEndIndex + 1) &&
              _cellEndIndex < row.cells.count - 1) {
            row._rowOverflowIndex = _cellEndIndex;
          }
          if (row._grid.style.allowHorizontalOverflow &&
              (row._rowOverflowIndex > 0 &&
                  (row.cells[i].columnSpan > _cellEndIndex ||
                      i + row.cells[i].columnSpan > _cellEndIndex + 1)) &&
              row.cells[i].columnSpan - _cellEndIndex + i - 1 > 0) {
            row.cells[row._rowOverflowIndex + 1].value =
                stringResult != null ? stringResult._remainder : null;
            row.cells[row._rowOverflowIndex + 1].stringFormat =
                row.cells[i].stringFormat;
            row.cells[row._rowOverflowIndex + 1].style = row.cells[i].style;
            row.cells[row._rowOverflowIndex + 1].columnSpan =
                row.cells[i].columnSpan - _cellEndIndex + i - 1;
          }
        }

        if (!cancelSpans) {
          _raiseAfterCellLayout(
              _currentGraphics,
              _currentRowIndex,
              i,
              _Rectangle(location.x, location.y, size.width, size.height),
              (row.cells[i].value is String)
                  ? row.cells[i].value.toString()
                  : '',
              row.cells[i].style,
              row._isHeaderRow);
        }

        if (row.cells[i].value is PdfGrid) {
          final PdfGrid grid = row.cells[i].value as PdfGrid;
          row.cells[i]._pageCount = grid._listOfNavigatePages.length;
          _rowBreakPageHeightCellIndex = i;
          for (int k = 0; k < grid._listOfNavigatePages.length; k++) {
            final int pageIndex = grid._listOfNavigatePages[k];
            if (!_grid!._listOfNavigatePages.contains(pageIndex)) {
              _grid!._listOfNavigatePages.add(pageIndex);
            }
          }
          if (_grid!.columns[i].width >= _currentGraphics!.clientSize.width) {
            location.x = grid._rowLayoutBoundswidth;
            location.x = location.x + grid.style.cellSpacing;
          } else {
            location.x = location.x + _grid!.columns[i].width;
          }
        } else {
          location.x = location.x + _grid!.columns[i].width;
        }
      }
      if (!row._rowMergeComplete || row._isRowHeightSet) {
        _currentBounds.y = _currentBounds.y + height;
      }
      result.bounds =
          _Rectangle(result.bounds.x, result.bounds.y, location.x, location.y);
      return null;
    }
  }

  double _reCalculateHeight(PdfGridRow? row, double height) {
    double newHeight = 0.0;
    for (int i = _cellStartIndex; i <= _cellEndIndex; i++) {
      if (row!.cells[i]._remainingString != null &&
          row.cells[i]._remainingString!.isNotEmpty) {
        newHeight = max(newHeight, row.cells[i]._measureHeight());
      }
    }
    return max(height, newHeight);
  }

  _RowLayoutResult _drawRowWithBreak(
      PdfGridRow row, _RowLayoutResult result, double? height) {
    final _Point location = _currentBounds.location;
    if (row._grid._isChildGrid! &&
        row._grid.allowRowBreakingAcrossPages &&
        _startLocation.x != _currentBounds.x) {
      location.x = _startLocation.x;
    }
    result.bounds = _Rectangle(location.x, location.y, 0, 0);
    _newheight = row._rowBreakHeight > 0
        ? _currentBounds.height < _currentPageBounds.height
            ? _currentBounds.height
            : _currentPageBounds.height
        : 0;
    if (row._grid.style.cellPadding.top +
            _currentBounds.y +
            row._grid.style.cellPadding.bottom <
        _currentPageBounds.height) {
      row._rowBreakHeight =
          _currentBounds.y + height! - _currentPageBounds.height;
    } else {
      row._rowBreakHeight = height!;
      result.isFinish = false;
      return result;
    }
    for (int cellIndex = 0; cellIndex < row.cells.count; cellIndex++) {
      final PdfGridCell cell = row.cells[cellIndex];
      if (cell._measureHeight() == height) {
        row._rowBreakHeight = cell.value is PdfGrid
            ? 0
            : _currentBounds.y + height - _currentBounds.height <
                    _currentPageBounds.height
                ? _currentBounds.height
                : _currentPageBounds.height;
      }
    }
    for (int i = _cellStartIndex; i <= _cellEndIndex; i++) {
      final bool cancelSpans =
          row.cells[i].columnSpan + i > _cellEndIndex + 1 &&
              row.cells[i].columnSpan > 1;
      if (!cancelSpans) {
        for (int j = 1; j < row.cells[i].columnSpan; j++) {
          row.cells[i + j]._isCellMergeContinue = true;
        }
      }
      _Size size = _Size(
          _grid!.columns[i].width,
          _newheight > 0.0
              ? _newheight
              : _currentBounds.height < _currentPageBounds.height
                  ? _currentBounds.height
                  : _currentPageBounds.height);
      if (size.width == 0) {
        size = _Size(row.cells[i].width, size.height);
      }
      if (!_checkIfDefaultFormat(_grid!.columns[i].format) &&
          _checkIfDefaultFormat(row.cells[i].stringFormat)) {
        row.cells[i].stringFormat = _grid!.columns[i].format;
      }
      PdfGridCellStyle cellstyle = row.cells[i].style;
      final Map<String, dynamic> cellLayoutResult = _raiseBeforeCellLayout(
          _currentGraphics,
          row._isHeaderRow ? _currentHeaderRowIndex : _currentRowIndex,
          i,
          _Rectangle(location.x, location.y, size.width, size.height),
          row.cells[i].value is String ? row.cells[i].value.toString() : '',
          cellstyle,
          row._isHeaderRow);
      cellstyle = cellLayoutResult['style'] as PdfGridCellStyle;
      final PdfGridBeginCellLayoutArgs? bclArgs =
          cellLayoutResult['args'] as PdfGridBeginCellLayoutArgs?;
      row.cells[i].style = cellstyle;
      final bool skipcell = bclArgs != null && bclArgs.skip;
      _PdfStringLayoutResult? stringResult;
      if (!skipcell) {
        stringResult = row.cells[i]._draw(
            _currentGraphics,
            _Rectangle(location.x, location.y, size.width, size.height),
            cancelSpans);
      }
      if (row._rowBreakHeight > 0.0) {
        if (stringResult != null) {
          row.cells[i]._finished = false;
          row.cells[i]._remainingString = stringResult._remainder ?? '';
          if (row._grid._isChildGrid!) {
            row._rowBreakHeight = height - stringResult._size.height;
          }
        } else if (row.cells[i].value is PdfImage) {
          row.cells[i]._finished = false;
        }
      }
      result.isFinish =
          (!result.isFinish) ? result.isFinish : row.cells[i]._finished;
      if (!cancelSpans) {
        _raiseAfterCellLayout(
            _currentGraphics,
            _currentRowIndex,
            i,
            _Rectangle(location.x, location.y, size.width, size.height),
            (row.cells[i].value is String) ? row.cells[i].value.toString() : '',
            row.cells[i].style,
            row._isHeaderRow);
      }
      if (row.cells[i].value is PdfGrid) {
        final PdfGrid grid = row.cells[i].value as PdfGrid;
        _rowBreakPageHeightCellIndex = i;
        row.cells[i]._pageCount = grid._listOfNavigatePages.length;
        for (int i = 0; i < grid._listOfNavigatePages.length; i++) {
          final int pageIndex = grid._listOfNavigatePages[i];
          if (!_grid!._listOfNavigatePages.contains(pageIndex)) {
            _grid!._listOfNavigatePages.add(pageIndex);
          }
        }
        if (_grid!.columns[i].width >= _currentGraphics!.clientSize.width) {
          location.x = grid._rowLayoutBoundswidth;
          location.x = location.x + grid.style.cellSpacing;
        } else {
          location.x = location.x + _grid!.columns[i].width;
        }
      } else {
        location.x = location.x + _grid!.columns[i].width;
      }
    }
    _currentBounds.y =
        _currentBounds.y + (_newheight > 0.0 ? _newheight : height);
    result.bounds =
        _Rectangle(result.bounds.x, result.bounds.y, location.x, location.y);
    return result;
  }

  bool _checkIfDefaultFormat(PdfStringFormat format) {
    final PdfStringFormat defaultFormat = PdfStringFormat();
    return format.alignment == defaultFormat.alignment &&
        format.characterSpacing == defaultFormat.characterSpacing &&
        format.clipPath == defaultFormat.clipPath &&
        format._firstLineIndent == defaultFormat._firstLineIndent &&
        format._scalingFactor == defaultFormat._scalingFactor &&
        format.lineAlignment == defaultFormat.lineAlignment &&
        format.lineLimit == defaultFormat.lineLimit &&
        format.lineSpacing == defaultFormat.lineSpacing &&
        format.measureTrailingSpaces == defaultFormat.measureTrailingSpaces &&
        format.noClip == defaultFormat.noClip &&
        format.paragraphIndent == defaultFormat.paragraphIndent &&
        format.textDirection == defaultFormat.textDirection &&
        format.subSuperscript == defaultFormat.subSuperscript &&
        format.wordSpacing == defaultFormat.wordSpacing &&
        format.wordWrap == defaultFormat.wordWrap;
  }

  void _reArrangeLayoutedPages(Map<PdfPage?, List<int>> layoutedPages) {
    final PdfDocument? document = _currentPage!._document;
    final List<PdfPage?> pages = layoutedPages.keys.toList();
    for (int i = 0; i < pages.length; i++) {
      final PdfPage page = pages[i]!;
      page._section = null;
      document!.pages._remove(page);
    }
    for (int i = 0; i < layoutedPages.length; i++) {
      for (int j = i;
          j < layoutedPages.length;
          j += layoutedPages.length ~/ _columnRanges!.length) {
        final PdfPage page = pages[j]!;
        if (document!.pages.indexOf(page) == -1) {
          document.pages._addPage(page);
        }
      }
    }
  }

  void _reArrangePages(PdfPage page) {
    final List<PdfPage?> pages = <PdfPage?>[];
    int pageCount = page._document!.pages.count;
    int m = 0;
    int n = _columnRanges!.length;
    if (pageCount <= _columnRanges!.length) {
      for (int i = 0; i < _columnRanges!.length; i++) {
        page._document!.pages.add();
        if (page._document!.pages.count > _columnRanges!.length + 1) {
          break;
        }
      }
    }
    pageCount = page._document!.pages.count;
    for (int i = 0; i < pageCount; i++) {
      if (m < pageCount && pages.length != pageCount) {
        final PdfPage tempPage = page._document!.pages[m];
        if (!pages.contains(tempPage)) {
          pages.add(tempPage);
        }
      }
      if (n < pageCount && pages.length != pageCount) {
        final PdfPage tempPage = page._document!.pages[n];
        if (!pages.contains(tempPage)) {
          pages.add(tempPage);
        }
      }
      if (pages.length == pageCount) {
        break;
      }
      m++;
      n++;
    }
    final PdfDocument? document = page._document;
    for (int i = 0; i < pages.length; i++) {
      final PdfPage tempPage = pages[i]!;
      tempPage._section = null;
      document!.pages._remove(tempPage);
    }
    for (int i = 0; i < pages.length; i++) {
      document!.pages._addPage(pages[i]!);
    }
  }

  PdfPage? getNextPage(PdfLayoutFormat format) {
    final PdfSection section = _currentPage!._section!;
    PdfPage? nextPage;
    final int index = section._indexOf(_currentPage!);
    if (_currentPage!._document!.pages.count > 1 &&
        _hType == PdfHorizontalOverflowType.nextPage &&
        flag &&
        _columnRanges!.length > 1) {
      _grid!._isRearranged = true;
      _reArrangePages(_currentPage!);
    }
    flag = false;
    if (index == section._count - 1) {
      nextPage = PdfPage();
      section._isNewPageSection = true;
      section._add(nextPage);
      section._isNewPageSection = false;
    } else {
      nextPage = section._getPageByIndex(index + 1);
    }
    _currentGraphics = nextPage!.graphics;
    final int pageindex =
        _currentGraphics!._page!._section!._indexOf(_currentGraphics!._page!);
    if (!_grid!._listOfNavigatePages.contains(pageindex)) {
      _grid!._listOfNavigatePages.add(pageindex);
    }
    _currentBounds = _Rectangle(0, 0, _currentGraphics!.clientSize.width,
        _currentGraphics!.clientSize.height);
    if (_Rectangle.fromRect(format.paginateBounds) != _Rectangle.empty) {
      _currentBounds.x = format.paginateBounds.left;
      _currentBounds.y = format.paginateBounds.top;
      _currentBounds.height = format.paginateBounds.height;
    }
    return nextPage;
  }

  PdfLayoutResult _getLayoutResult() {
    if (_grid!._isChildGrid! && _grid!.allowRowBreakingAcrossPages) {
      for (int rowIndex = 0; rowIndex < _grid!.rows.count; rowIndex++) {
        final PdfGridRow row = _grid!.rows[rowIndex];
        if (row._rowBreakHeight > 0) {
          _startLocation.y = _currentPage!._origin.dy;
        }
      }
    }
    final Rect bounds = _isChanged
        ? Rect.fromLTWH(_currentLocation.x, _currentLocation.y,
            _currentBounds.width, _currentBounds.y - _currentLocation.y)
        : Rect.fromLTWH(_startLocation.x, _startLocation.y,
            _currentBounds.width, _currentBounds.y - _startLocation.y);
    return PdfLayoutResult._(_currentPage!, bounds);
  }

  Map<String, dynamic> _raiseBeforePageLayout(
      PdfPage? currentPage, Rect currentBounds, int? currentRow) {
    bool cancel = false;
    if (_element!._raiseBeginPageLayout) {
      final PdfGridBeginPageLayoutArgs args =
          PdfGridBeginPageLayoutArgs._(currentBounds, currentPage!, currentRow);
      _element!._onBeginPageLayout(args);
      if (_Rectangle.fromRect(currentBounds) !=
          _Rectangle.fromRect(args.bounds)) {
        _isChanged = true;
        _currentLocation = _Point(args.bounds.left, args.bounds.top);
        _grid!._measureColumnsWidth(_Rectangle(
            args.bounds.left,
            args.bounds.top,
            args.bounds.width + args.bounds.left,
            args.bounds.height));
      }
      cancel = args.cancel;
      currentBounds = args.bounds;
      currentRow = args.startRowIndex;
    }
    return <String, dynamic>{
      'cancel': cancel,
      'currentBounds': currentBounds,
      'currentRow': currentRow
    };
  }

  PdfGridEndPageLayoutArgs _raisePageLayouted(PdfLayoutResult result) {
    final PdfGridEndPageLayoutArgs args = PdfGridEndPageLayoutArgs._(result);
    if (_element!._raisePageLayouted) {
      _element!._onEndPageLayout(args);
    }
    return args;
  }

  Map<String, dynamic> _raiseBeforeCellLayout(
      PdfGraphics? graphics,
      int rowIndex,
      int cellIndex,
      _Rectangle bounds,
      String value,
      PdfGridCellStyle? style,
      bool isHeaderRow) {
    PdfGridBeginCellLayoutArgs? args;
    if (_grid!._raiseBeginCellLayout) {
      args = PdfGridBeginCellLayoutArgs._(
          graphics!, rowIndex, cellIndex, bounds, value, style, isHeaderRow);
      _grid!._onBeginCellLayout(args);
      style = args.style;
    }
    return <String, dynamic>{'args': args, 'style': style};
  }

  void _raiseAfterCellLayout(
      PdfGraphics? graphics,
      int rowIndex,
      int cellIndex,
      _Rectangle bounds,
      String value,
      PdfGridCellStyle? cellstyle,
      bool isHeaderRow) {
    PdfGridEndCellLayoutArgs args;
    if (_grid!._raiseEndCellLayout) {
      args = PdfGridEndCellLayoutArgs._(graphics!, rowIndex, cellIndex, bounds,
          value, cellstyle, isHeaderRow);
      _grid!._onEndCellLayout(args);
    }
  }

  //Override methods
  @override
  PdfLayoutResult? _layoutInternal(_PdfLayoutParams param) {
    final PdfLayoutFormat format = _getFormat(param.format);
    _currentPage = param.page;
    if (_currentPage != null) {
      final Size size = _currentPage!.getClientSize();
      final double pageHeight = size.height;
      final double pageWidth = size.width;
      if (pageHeight > pageWidth ||
          (param.page!._orientation == PdfPageOrientation.landscape &&
              format.breakType == PdfLayoutBreakType.fitPage)) {
        _currentPageBounds = _Size.fromSize(size);
      } else {
        _currentPageBounds = _Size.fromSize(_currentPage!.size);
      }
    } else {
      _currentPageBounds = _Size.fromSize(_currentGraphics!.clientSize);
    }
    if (_currentPage != null) {
      _currentGraphics = _currentPage!.graphics;
    }
    if (_currentGraphics!._layer != null) {
      final int index = _currentGraphics!._page is PdfPage
          ? _currentGraphics!._page!._section!
              ._indexOf(_currentGraphics!._page!)
          : _currentGraphics!._page!._defaultLayerIndex;
      if (!_grid!._listOfNavigatePages.contains(index)) {
        _grid!._listOfNavigatePages.add(index);
      }
    }
    _currentBounds = _Rectangle(
        param.bounds!.x,
        param.bounds!.y,
        format.breakType == PdfLayoutBreakType.fitColumnsToPage
            ? _grid!.columns._width
            : _currentGraphics!.clientSize.width,
        _currentGraphics!.clientSize.height);
    if (_grid!.rows.count != 0) {
      _currentBounds.width = (param.bounds!.width > 0)
          ? param.bounds!.width
          : (_currentBounds.width -
              _grid!.rows[0].cells[0].style.borders.left.width / 2);
    } else if (_grid!.headers.count != 0) {
      _currentBounds.width = (param.bounds!.width > 0)
          ? param.bounds!.width
          : (_currentBounds.width -
              _grid!.headers[0].cells[0].style.borders.left.width / 2);
    }
    _startLocation = param.bounds!.location;
    if (_grid!.style.allowHorizontalOverflow &&
        _currentBounds.width > _currentGraphics!.clientSize.width) {
      _currentBounds.width =
          _currentGraphics!.clientSize.width - _currentBounds.x;
    }
    if (_grid!._isChildGrid!) {
      _childHeight = param.bounds!.height;
    }
    if (param.format != null && param.format!._boundsSet) {
      if (param.format!.paginateBounds.height > 0) {
        _currentBounds.height = param.format!.paginateBounds.height;
      }
    } else if (param.bounds!.height > 0 && !_grid!._isChildGrid!) {
      _currentBounds.height = param.bounds!.height;
    }
    if (!_grid!._isChildGrid!) {
      _hType = _grid!.style.horizontalOverflowType;
    }
    if (!_grid!.style.allowHorizontalOverflow) {
      _grid!._measureColumnsWidth(_currentBounds);
      _columnRanges!.add(<int>[0, _grid!.columns.count - 1]);
    } else {
      _grid!._measureColumnsWidth();
      _determineColumnDrawRanges();
    }
    if (_grid!._hasRowSpan) {
      for (int i = 0; i < _grid!.rows.count; i++) {
        _grid!.rows[i].height;
        if (!_grid!.rows[i]._isRowHeightSet) {
          _grid!.rows[i]._isRowHeightSet = true;
        } else {
          _grid!.rows[i]._isRowSpanRowHeightSet = true;
        }
      }
    }
    return _layoutOnPage(param);
  }
}

class _RowLayoutResult {
  _RowLayoutResult() {
    bounds = _Rectangle.empty;
    isFinish = false;
  }
  late bool isFinish;
  late _Rectangle bounds;
}
