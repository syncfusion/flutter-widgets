import 'dart:math';
import 'dart:ui';

import '../../../drawing/drawing.dart';
import '../../../graphics/figures/base/element_layouter.dart';
import '../../../graphics/figures/base/layout_element.dart';
import '../../../graphics/figures/base/text_layouter.dart';
import '../../../graphics/figures/enums.dart';
import '../../../graphics/fonts/pdf_string_format.dart';
import '../../../graphics/fonts/pdf_string_layout_result.dart';
import '../../../graphics/images/pdf_image.dart';
import '../../../graphics/pdf_graphics.dart';
import '../../../pages/enum.dart';
import '../../../pages/pdf_page.dart';
import '../../../pages/pdf_page_collection.dart';
import '../../../pages/pdf_section.dart';
import '../../../pdf_document/pdf_document.dart';
import '../enums.dart';
import '../pdf_grid.dart';
import '../pdf_grid_cell.dart';
import '../pdf_grid_column.dart';
import '../pdf_grid_row.dart';
import '../styles/style.dart';

/// internal class
class PdfGridLayouter extends ElementLayouter {
  /// internal constructor
  PdfGridLayouter(PdfGrid grid) : super(grid) {
    _initialize();
  }

  //Fields
  PdfGraphics? _currentGraphics;
  PdfPage? _currentPage;
  late PdfSize _currentPageBounds;
  late PdfRectangle _currentBounds;
  late PdfPoint _startLocation;
  late double _childHeight;
  late PdfHorizontalOverflowType _hType;
  List<List<int>>? _columnRanges;
  late int _cellEndIndex;
  late int _cellStartIndex;

  /// internal field
  static int repeatRowIndex = -1;
  late List<int> _parentCellIndexList;
  late int _currentRowIndex;
  late int _currentHeaderRowIndex;
  late int _rowBreakPageHeightCellIndex;

  /// internal field
  late bool flag;
  late bool _isChanged;
  late PdfPoint _currentLocation;
  bool? _isChildGrid;
  late double _newheight;

  //Properties
  PdfGrid? get _grid {
    return element as PdfGrid?;
  }

  //Implementation
  void _initialize() {
    _rowBreakPageHeightCellIndex = 0;
    _newheight = 0;
    _hType = PdfHorizontalOverflowType.nextPage;
    _currentPageBounds = PdfSize.empty;
    _currentRowIndex = 0;
    _currentHeaderRowIndex = 0;
    _currentLocation = PdfPoint.empty;
    _currentBounds = PdfRectangle.empty;
    _columnRanges ??= <List<int>>[];
    _childHeight = 0;
    _cellStartIndex = 0;
    _cellEndIndex = 0;
    _isChanged = false;
    flag = true;
    _isChildGrid ??= false;
    _startLocation = PdfPoint.empty;
  }

  /// internal method
  void layoutGrid(PdfGraphics graphics, PdfRectangle bounds) {
    final PdfLayoutParams param = PdfLayoutParams();
    param.bounds = bounds;
    _currentGraphics = graphics;
    if (PdfGraphicsHelper.getHelper(_currentGraphics!).layer != null &&
        PdfGraphicsHelper.getHelper(_currentGraphics!).page != null) {
      final int index = PdfSectionHelper.getHelper(PdfPageHelper.getHelper(
                  PdfGraphicsHelper.getHelper(_currentGraphics!).page!)
              .section!)
          .indexOf(PdfGraphicsHelper.getHelper(_currentGraphics!).page!);
      if (!PdfGridHelper.getHelper(_grid!)
          .listOfNavigatePages
          .contains(index)) {
        PdfGridHelper.getHelper(_grid!).listOfNavigatePages.add(index);
      }
    }
    layoutInternal(param);
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

  PdfLayoutResult? _layoutOnPage(PdfLayoutParams param) {
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
        _currentBounds =
            PdfRectangle.fromRect(pageLayoutResult['currentBounds']);
        _currentRowIndex = pageLayoutResult['currentRow'] as int;
        if (pageLayoutResult['cancel'] as bool) {
          result =
              PdfLayoutResultHelper.load(_currentPage!, _currentBounds.rect);
          break;
        }
      }
      bool drawHeader;
      if (PdfGridHelper.getHelper(_grid!).isBuiltinStyle &&
          PdfGridHelper.getHelper(_grid!).parentCell == null) {
        if (PdfGridHelper.getHelper(_grid!).gridBuiltinStyle !=
            PdfGridBuiltInStyle.tableGrid) {
          PdfGridHelper.getHelper(_grid!).applyBuiltinStyles(
              PdfGridHelper.getHelper(_grid!).gridBuiltinStyle);
        }
      }
      for (int rowIndex = 0; rowIndex < _grid!.headers.count; rowIndex++) {
        _currentHeaderRowIndex = rowIndex;
        final PdfGridRow row = _grid!.headers[rowIndex];
        final double headerHeight = _currentBounds.y;
        if (startPage != _currentPage) {
          for (int k = _cellStartIndex; k <= _cellEndIndex; k++) {
            if (PdfGridCellHelper.getHelper(row.cells[k]).isCellMergeContinue) {
              PdfGridCellHelper.getHelper(row.cells[k]).isCellMergeContinue =
                  false;
              row.cells[k].value = '';
            }
          }
        }
        final _RowLayoutResult headerResult = _drawRow(row)!;
        if (headerHeight == _currentBounds.y) {
          drawHeader = true;
          repeatRowIndex = PdfGridRowCollectionHelper.indexOf(_grid!.rows, row);
        } else {
          drawHeader = false;
        }
        if (!headerResult.isFinish &&
            startPage != null &&
            format.layoutType != PdfLayoutType.onePage &&
            drawHeader) {
          _startLocation.x = _currentBounds.x;
          _currentPage = _getNextPage(format);
          _startLocation.y = _currentBounds.y;
          if (PdfRectangle.fromRect(format.paginateBounds) ==
              PdfRectangle.empty) {
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
        _cellEndIndex =
            _cellStartIndex = PdfGridHelper.getHelper(_grid!).parentCellIndex;
        _parentCellIndexList = <int>[];
        _parentCellIndexList
            .add(PdfGridHelper.getHelper(_grid!).parentCellIndex);
        PdfGridCellHelper.getHelper(PdfGridHelper.getHelper(_grid!).parentCell!)
            .present = true;
        PdfGrid parentGrid = PdfGridRowHelper.getHelper(
                PdfGridCellHelper.getHelper(
                        PdfGridHelper.getHelper(_grid!).parentCell!)
                    .row!)
            .grid;
        while (PdfGridHelper.getHelper(parentGrid).parentCell != null) {
          _parentCellIndexList
              .add(PdfGridHelper.getHelper(parentGrid).parentCellIndex);
          _cellEndIndex = PdfGridHelper.getHelper(parentGrid).parentCellIndex;
          _cellStartIndex = PdfGridHelper.getHelper(parentGrid).parentCellIndex;
          PdfGridCellHelper.getHelper(
                  PdfGridHelper.getHelper(parentGrid).parentCell!)
              .present = true;
          parentGrid = PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                      PdfGridHelper.getHelper(parentGrid).parentCell!)
                  .row!)
              .grid;
          if (PdfGridHelper.getHelper(parentGrid).parentCell == null) {
            _parentCellIndexList.removeAt(_parentCellIndexList.length - 1);
          }
        }
        PdfSection section = PdfPageHelper.getHelper(_currentPage!).section!;
        int index = PdfSectionHelper.getHelper(section).indexOf(_currentPage!);
        if ((!PdfGridHelper.getHelper(parentGrid).isDrawn) ||
            (!PdfGridHelper.getHelper(parentGrid)
                .listOfNavigatePages
                .contains(index))) {
          section = PdfPageHelper.getHelper(
                  PdfGraphicsHelper.getHelper(_currentGraphics!).page!)
              .section!;
          index = PdfSectionHelper.getHelper(section).indexOf(_currentPage!);
          PdfGridHelper.getHelper(parentGrid).isDrawn = true;
          for (int rowIndex = 0; rowIndex < parentGrid.rows.count; rowIndex++) {
            final PdfGridRow row = parentGrid.rows[rowIndex];
            final PdfGridCell cell = row.cells[_cellStartIndex];
            cell.value = '';
            final PdfPoint location =
                PdfPoint(_currentBounds.x, _currentBounds.y);
            double width = parentGrid.columns[_cellStartIndex].width;
            if (width > _currentGraphics!.clientSize.width) {
              width = _currentGraphics!.clientSize.width - 2 * location.x;
            }
            double? height = cell.height;
            if (row.height > cell.height) {
              height = row.height;
            }
            PdfGridCellHelper.getHelper(cell).draw(_currentGraphics,
                PdfRectangle(location.x, location.y, width, height), false);
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
        repeatRowIndex = -1;
        if (flag &&
            PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                .isChildGrid!) {
          startingHeight = originalHeight;
          flag = false;
        }
        if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                .isChildGrid! &&
            PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                    .parentCell!
                    .rowSpan >
                1 &&
            (startingHeight! + _childHeight).toInt() <
                (_currentBounds.y + row.height).toInt()) {
          if (_grid!.rows.count > i) {
            final PdfGrid temp = PdfGridRowHelper.getHelper(
                    PdfGridCellHelper.getHelper(PdfGridHelper.getHelper(
                                PdfGridRowHelper.getHelper(row).grid)
                            .parentCell!)
                        .row!)
                .grid;
            for (int tempRowIndex = 0;
                tempRowIndex < temp.rows.count;
                tempRowIndex++) {
              final PdfGridRow tempRow = temp.rows[tempRowIndex];
              if (tempRow.cells[PdfGridHelper.getHelper(
                          PdfGridRowHelper.getHelper(row).grid)
                      .parentCellIndex] ==
                  PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                      .parentCell) {
                final dynamic grid = tempRow
                    .cells[PdfGridHelper.getHelper(
                            PdfGridRowHelper.getHelper(row).grid)
                        .parentCellIndex]
                    .value;
                if (grid is PdfGrid) {
                  PdfGridRowCollectionHelper.getRows(grid.rows)
                      .removeRange(0, i - 1);
                }
              }
            }
          }
          break;
        }
        _RowLayoutResult rowResult = _drawRow(row)!;
        cellBounds.add(rowResult.bounds.width);
        if (PdfGridRowHelper.getHelper(row).isRowBreaksNextPage) {
          double x = 0;
          for (int l = 0; l < row.cells.count; l++) {
            bool isNestedRowBreak = false;
            if (row.height == row.cells[l].height &&
                row.cells[l].value is PdfGrid) {
              final PdfGrid grid = row.cells[l].value as PdfGrid;
              for (int m = grid.rows.count; 0 < m; m--) {
                if (PdfGridRowHelper.getHelper(grid.rows[m - 1])
                        .rowBreakHeight >
                    0) {
                  isNestedRowBreak = true;
                  break;
                }
                if (PdfGridRowHelper.getHelper(grid.rows[m - 1])
                    .isRowBreaksNextPage) {
                  PdfGridRowHelper.getHelper(row).rowBreakHeight =
                      PdfGridRowHelper.getHelper(grid.rows[m - 1])
                          .rowBreakHeight;
                  break;
                }
                PdfGridRowHelper.getHelper(row).rowBreakHeight =
                    PdfGridRowHelper.getHelper(row).rowBreakHeight +
                        grid.rows[m - 1].height;
              }
            }
            if (isNestedRowBreak) {
              break;
            }
          }
          for (int j = 0; j < row.cells.count; j++) {
            if (row.height > row.cells[j].height) {
              row.cells[j].value = '';
              PdfRectangle rect;
              PdfPage page = getNextPage(_currentPage!)!;
              final PdfSection section =
                  PdfPageHelper.getHelper(_currentPage!).section!;
              final int index =
                  PdfSectionHelper.getHelper(section).indexOf(page);
              for (int k = 0;
                  k <
                      (PdfSectionHelper.getHelper(section)
                                  .pageReferences!
                                  .count -
                              1) -
                          index;
                  k++) {
                rect = PdfRectangle(
                    x,
                    0,
                    PdfGridRowHelper.getHelper(row).grid.columns[j].width,
                    page.getClientSize().height);
                repeatRowIndex = -1;
                PdfGridCellHelper.getHelper(row.cells[j])
                    .draw(page.graphics, rect, false);
                page = getNextPage(page)!;
              }
              rect = PdfRectangle(
                  x,
                  0,
                  PdfGridRowHelper.getHelper(row).grid.columns[j].width,
                  PdfGridRowHelper.getHelper(row).rowBreakHeight);
              PdfGridCellHelper.getHelper(row.cells[j])
                  .draw(page.graphics, rect, false);
            }
            x += PdfGridRowHelper.getHelper(row).grid.columns[j].width;
          }
        }
        if (originalHeight == _currentBounds.y) {
          repeatRow = true;
          repeatRowIndex = PdfGridRowCollectionHelper.indexOf(_grid!.rows, row);
        } else {
          repeatRow = false;
          repeatRowIndex = -1;
        }
        while (!rowResult.isFinish && startPage != null) {
          final PdfLayoutResult tempResult = _getLayoutResult();
          if (startPage != _currentPage) {
            if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                    .isChildGrid! &&
                PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                        .parentCell !=
                    null) {
              final PdfRectangle bounds = PdfRectangle(
                  format.paginateBounds.left,
                  format.paginateBounds.top,
                  param.bounds!.width,
                  tempResult.bounds.height);
              bounds.x = bounds.x + param.bounds!.x;
              bounds.y = bounds.y +
                  PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                              PdfGridHelper.getHelper(
                                      PdfGridRowHelper.getHelper(row).grid)
                                  .parentCell!)
                          .row!)
                      .grid
                      .style
                      .cellPadding
                      .top;
              if (bounds.height > _currentPageBounds.height) {
                bounds.height = _currentPageBounds.height - bounds.y;
                bounds.height = bounds.height -
                    PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                                PdfGridHelper.getHelper(
                                        PdfGridRowHelper.getHelper(row).grid)
                                    .parentCell!)
                            .row!)
                        .grid
                        .style
                        .cellPadding
                        .bottom;
              }
              for (int c = 0; c < row.cells.count; c++) {
                final PdfGridCell cell = row.cells[c];
                double cellWidth = 0.0;
                if (cell.columnSpan > 1) {
                  for (; c < cell.columnSpan; c++) {
                    cellWidth +=
                        PdfGridRowHelper.getHelper(row).grid.columns[c].width;
                  }
                } else {
                  cellWidth = max(cell.width,
                      PdfGridRowHelper.getHelper(row).grid.columns[c].width);
                }
                _currentGraphics = PdfGridCellHelper.getHelper(cell)
                    .drawCellBorders(
                        _currentGraphics!,
                        PdfRectangle(
                            bounds.x, bounds.y, cellWidth, bounds.height));
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
            _currentPage = _getNextPage(format);
            originalHeight = _currentBounds.y;
            final PdfPoint location = PdfPoint(
                PdfGridHelper.getHelper(_grid!).defaultBorder.right.width / 2,
                PdfGridHelper.getHelper(_grid!).defaultBorder.top.width / 2);
            if (PdfRectangle.fromRect(format.paginateBounds) ==
                    PdfRectangle.empty &&
                _startLocation == location) {
              _currentBounds.x = _currentBounds.x + _startLocation.x;
              _currentBounds.y = _currentBounds.y + _startLocation.y;
            }
            if (PdfGridHelper.getHelper(_grid!).isChildGrid! &&
                PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                        .parentCell !=
                    null) {
              if (PdfGridStyleHelper.getPadding(PdfGridRowHelper.getHelper(
                          PdfGridCellHelper.getHelper(
                                  PdfGridHelper.getHelper(_grid!).parentCell!)
                              .row!)
                      .grid
                      .style) !=
                  null) {
                if (PdfGridRowHelper.getHelper(row).rowBreakHeight +
                        PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                                    PdfGridHelper.getHelper(_grid!).parentCell!)
                                .row!)
                            .grid
                            .style
                            .cellPadding
                            .top <
                    _currentBounds.height) {
                  _currentBounds.y = PdfGridRowHelper.getHelper(
                          PdfGridCellHelper.getHelper(
                                  PdfGridHelper.getHelper(_grid!).parentCell!)
                              .row!)
                      .grid
                      .style
                      .cellPadding
                      .top;
                }
              }
            }
            if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                    .parentCell !=
                null) {
              PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                          PdfGridHelper.getHelper(
                                  PdfGridRowHelper.getHelper(row).grid)
                              .parentCell!)
                      .row!)
                  .isRowBreaksNextPage = true;
              PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                              PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                                  .parentCell!)
                          .row!)
                      .rowBreakHeight =
                  PdfGridRowHelper.getHelper(row).rowBreakHeight +
                      PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                                  PdfGridHelper.getHelper(_grid!).parentCell!)
                              .row!)
                          .grid
                          .style
                          .cellPadding
                          .top +
                      PdfGridRowHelper.getHelper(
                              PdfGridCellHelper.getHelper(PdfGridHelper.getHelper(_grid!).parentCell!).row!)
                          .grid
                          .style
                          .cellPadding
                          .bottom;
            }
            if (PdfGridRowHelper.getHelper(row).noOfPageCount > 1) {
              final double temp =
                  PdfGridRowHelper.getHelper(row).rowBreakHeight;
              for (int j = 1;
                  j < PdfGridRowHelper.getHelper(row).noOfPageCount;
                  j++) {
                PdfGridRowHelper.getHelper(row).rowBreakHeight = 0;
                row.height =
                    (PdfGridRowHelper.getHelper(row).noOfPageCount - 1) *
                        _currentPage!.getClientSize().height;
                _drawRow(row);
                _currentPage = _getNextPage(format);
                startPage = _currentPage;
              }
              PdfGridRowHelper.getHelper(row).rowBreakHeight = temp;
              PdfGridRowHelper.getHelper(row).noOfPageCount = 1;
              rowResult = _drawRow(row)!;
            } else {
              rowResult = _drawRow(row)!;
            }
          } else if (!_grid!.allowRowBreakingAcrossPages && i < length) {
            _currentPage = _getNextPage(format);
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
          if (!PdfGridHelper.getHelper(_grid!).isSingleGrid) {
            for (int j = 0; j < _grid!.rows.count; j++) {
              bool isWidthGreaterthanParent = false;
              for (int k = 0; k < _grid!.rows[j].cells.count; k++) {
                if (_grid!.rows[j].cells[k].width > _currentPageBounds.width) {
                  isWidthGreaterthanParent = true;
                }
              }
              if (isWidthGreaterthanParent &&
                  PdfGridCellHelper.getHelper(_grid!
                              .rows[j].cells[_rowBreakPageHeightCellIndex])
                          .pageCount >
                      0) {
                isAddNextPage = true;
              }
            }
          }
          if (!PdfGridHelper.getHelper(_grid!).isRearranged && isAddNextPage) {
            final PdfSection section =
                PdfPageHelper.getHelper(_currentPage!).section!;
            final PdfPage page = PdfPage();
            PdfSectionHelper.getHelper(section).isNewPageSection = true;
            PdfSectionHelper.getHelper(section).add(page);
            _currentPage = page;
            PdfSectionHelper.getHelper(section).isNewPageSection = false;
            _currentGraphics = _currentPage!.graphics;
            final Size clientSize = _currentPage!.getClientSize();
            _currentBounds =
                PdfRectangle(0, 0, clientSize.width, clientSize.height);
            final int pageindex = PdfSectionHelper.getHelper(
                    PdfPageHelper.getHelper(
                            PdfGraphicsHelper.getHelper(_currentGraphics!)
                                .page!)
                        .section!)
                .indexOf(PdfGraphicsHelper.getHelper(_currentGraphics!).page!);
            if (!PdfGridHelper.getHelper(_grid!)
                .listOfNavigatePages
                .contains(pageindex)) {
              PdfGridHelper.getHelper(_grid!)
                  .listOfNavigatePages
                  .add(pageindex);
            }
          } else {
            if (endArgs.nextPage == null) {
              _currentPage = _getNextPage(format);
            } else {
              _currentPage = endArgs.nextPage;
              _currentGraphics = endArgs.nextPage!.graphics;
              _currentBounds = PdfRectangle(
                  0,
                  0,
                  _currentGraphics!.clientSize.width,
                  _currentGraphics!.clientSize.height);
            }
          }
          final bool isSameSection =
              PdfPageHelper.getHelper(_currentPage!).section ==
                  PdfPageHelper.getHelper(param.page!).section;
          _currentBounds.y = format.paginateBounds.top == 0
              ? PdfGridHelper.getHelper(_grid!).defaultBorder.top.width / 2
              : format.paginateBounds.top;
          if (_currentPage != null) {
            final Map<String, dynamic> pageLayoutResult =
                _raiseBeforePageLayout(
                    _currentPage, _currentBounds.rect, _currentRowIndex);
            _currentBounds =
                PdfRectangle.fromRect(pageLayoutResult['currentBounds']);
            _currentRowIndex = pageLayoutResult['currentRow'] as int;
            if (pageLayoutResult['cancel'] as bool) {
              break;
            }
          }
          if ((param.format != null) &&
              !PdfLayoutFormatHelper.isBoundsSet(param.format!) &&
              param.bounds != null &&
              param.bounds!.height > 0 &&
              !PdfGridHelper.getHelper(_grid!).isChildGrid! &&
              isSameSection) {
            _currentBounds.height = param.bounds!.height;
          }
          _startLocation.y = _currentBounds.y;
          if (PdfRectangle.fromRect(format.paginateBounds) ==
              PdfRectangle.empty) {
            _currentBounds.x = _currentBounds.x + _startLocation.x;
          }
          if (_currentBounds.x ==
              PdfGridHelper.getHelper(_grid!).defaultBorder.left.width / 2) {
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
        if (PdfGridRowHelper.getHelper(row).gridResult != null) {
          _currentPage = PdfGridRowHelper.getHelper(row).gridResult!.page;
          _currentGraphics = _currentPage!.graphics;
          _startLocation = PdfPoint(
              PdfGridRowHelper.getHelper(row).gridResult!.bounds.left,
              PdfGridRowHelper.getHelper(row).gridResult!.bounds.top);
          _currentBounds.y =
              PdfGridRowHelper.getHelper(row).gridResult!.bounds.bottom;
          if (startPage != _currentPage) {
            final PdfSection secion =
                PdfPageHelper.getHelper(_currentPage!).section!;
            final int startIndex =
                PdfSectionHelper.getHelper(secion).indexOf(startPage!) + 1;
            final int endIndex =
                PdfSectionHelper.getHelper(secion).indexOf(_currentPage!);
            for (int page = startIndex; page < endIndex + 1; page++) {
              PdfGraphics pageGraphics = PdfSectionHelper.getHelper(secion)
                  .getPageByIndex(page)!
                  .graphics;
              final PdfPoint location = PdfPoint(
                  format.paginateBounds.left, format.paginateBounds.top);
              if (location == PdfPoint.empty &&
                  _currentBounds.x > location.x &&
                  !PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                      .isChildGrid! &&
                  PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                          .parentCell ==
                      null) {
                location.x = _currentBounds.x;
              }
              double height = page == endIndex
                  ? (PdfGridRowHelper.getHelper(row).gridResult!.bounds.height -
                      param.bounds!.y)
                  : (_currentBounds.height - location.y);
              if (height <= pageGraphics.clientSize.height) {
                height += param.bounds!.y;
              }
              if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                      .isChildGrid! &&
                  PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
                          .parentCell !=
                      null) {
                location.x = location.x + param.bounds!.x;
              }
              location.y = format.paginateBounds.top;
              for (int c = 0; c < row.cells.count; c++) {
                final PdfGridCell cell = row.cells[c];
                double cellWidth = 0.0;
                if (cell.columnSpan > 1) {
                  for (; c < cell.columnSpan; c++) {
                    cellWidth +=
                        PdfGridRowHelper.getHelper(row).grid.columns[c].width;
                  }
                } else {
                  cellWidth = PdfGridHelper.getHelper(_grid!).isWidthSet
                      ? min(cell.width,
                          PdfGridRowHelper.getHelper(row).grid.columns[c].width)
                      : max(
                          cell.width,
                          PdfGridRowHelper.getHelper(row)
                              .grid
                              .columns[c]
                              .width);
                }
                pageGraphics = PdfGridCellHelper.getHelper(cell)
                    .drawCellBorders(
                        pageGraphics,
                        PdfRectangle(
                            location.x, location.y, cellWidth, height));
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
          PdfGridHelper.getHelper(_grid!).rowLayoutBoundswidth =
              PdfGridHelper.getHelper(grid).rowLayoutBoundswidth;
          isPdfGrid = true;
          if (largeNavigatePage[0][0]! <
              PdfGridHelper.getHelper(grid).listOfNavigatePages.length) {
            largeNavigatePage[0][0] = PdfGridHelper.getHelper(grid)
                .listOfNavigatePages
                .length
                .toDouble();
            largeNavigatePage[0][1] = cellBounds[c];
          } else if ((largeNavigatePage[0][0] ==
                  PdfGridHelper.getHelper(grid).listOfNavigatePages.length) &&
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
        PdfGridHelper.getHelper(_grid!).rowLayoutBoundswidth =
            maximumCellBoundsWidth;
      } else {
        PdfGridHelper.getHelper(_grid!).rowLayoutBoundswidth =
            largeNavigatePage[0][1]!;
      }
      if (_columnRanges!.indexOf(range) < _columnRanges!.length - 1 &&
          startPage != null &&
          format.layoutType != PdfLayoutType.onePage) {
        isParentCell = PdfGridHelper.getHelper(_grid!).isChildGrid;
        if (largeNavigatePage[0][0]!.toInt() != 0) {
          final PdfSection section =
              PdfPageHelper.getHelper(_currentPage!).section!;
          final int pageIndex =
              PdfSectionHelper.getHelper(section).indexOf(_currentPage!);
          if (PdfSectionHelper.getHelper(section).count >
              pageIndex + largeNavigatePage[0][0]!.toInt()) {
            _currentPage = PdfSectionHelper.getHelper(section)
                .getPageByIndex(pageIndex + largeNavigatePage[0][0]!.toInt());
          } else {
            _currentPage = PdfPage();
            PdfSectionHelper.getHelper(section).isNewPageSection = true;
            PdfSectionHelper.getHelper(section).add(_currentPage!);
            PdfSectionHelper.getHelper(section).isNewPageSection = false;
          }
          _currentGraphics = _currentPage!.graphics;
          _currentBounds = PdfRectangle(
              0,
              0,
              _currentGraphics!.clientSize.width,
              _currentGraphics!.clientSize.height);
          final int pageindex = PdfSectionHelper.getHelper(
                  PdfPageHelper.getHelper(
                          PdfGraphicsHelper.getHelper(_currentGraphics!).page!)
                      .section!)
              .indexOf(PdfGraphicsHelper.getHelper(_currentGraphics!).page!);
          if (!PdfGridHelper.getHelper(_grid!)
              .listOfNavigatePages
              .contains(pageindex)) {
            PdfGridHelper.getHelper(_grid!).listOfNavigatePages.add(pageindex);
          }
        } else {
          _currentPage = _getNextPage(format);
        }
        final PdfPoint location = PdfPoint(
            PdfGridHelper.getHelper(_grid!).defaultBorder.right.width / 2,
            PdfGridHelper.getHelper(_grid!).defaultBorder.top.width / 2);
        if (PdfRectangle.fromRect(format.paginateBounds) ==
                PdfRectangle.empty &&
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
    PdfGridHelper.getHelper(grid).isDrawn = true;
    double? y = _currentBounds.y;
    for (int rowIndex = 0; rowIndex < grid.rows.count; rowIndex++) {
      final PdfGridRow row = grid.rows[rowIndex];
      final PdfGridCell cell = row.cells[_cellStartIndex];
      cell.value = '';
      final PdfPoint location = PdfPoint(_currentBounds.x, _currentBounds.y);
      double width = grid.columns[_cellStartIndex].width;
      if (width > _currentGraphics!.clientSize.width) {
        width = _currentGraphics!.clientSize.width - 2 * location.x;
      }
      final double height = row.height > cell.height ? row.height : cell.height;
      if (_isChildGrid!) {
        PdfGridCellHelper.getHelper(cell).draw(_currentGraphics,
            PdfRectangle(location.x, location.y, width, height), false);
      }
      _currentBounds.y = _currentBounds.y + height;
    }
    for (int j = 0; j < grid.rows.count; j++) {
      if (PdfGridCellHelper.getHelper(grid.rows[j].cells[_cellStartIndex])
          .present) {
        present = true;
        if (grid.rows[j].cells[_cellStartIndex].value is PdfGrid) {
          final PdfGrid? childGrid =
              grid.rows[j].cells[_cellStartIndex].value as PdfGrid?;
          PdfGridCellHelper.getHelper(grid.rows[j].cells[_cellStartIndex])
              .present = false;
          if (childGrid == _grid) {
            if (!_isChildGrid!) {
              _currentBounds.y = y!;
            } else {
              if (j == 0) {
                _currentBounds.y = _currentBounds.y -
                    PdfGridHelper.getHelper(grid).size.height;
              } else {
                int k = j;
                while (k < grid.rows.count) {
                  _currentBounds.y = _currentBounds.y - grid.rows[k].height;
                  k++;
                }
              }
            }
            PdfGridHelper.getHelper(childGrid!).isDrawn = true;
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
              _currentBounds.y = _currentBounds.y -
                  PdfGridHelper.getHelper(childGrid).size.height;
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
      if (PdfGridRowHelper.getHelper(row!).rowSpanExists) {
        int currRowIndex = PdfGridRowCollectionHelper.indexOf(_grid!.rows, row);
        int maxSpan = PdfGridRowHelper.getHelper(row).maximumRowSpan;
        if (currRowIndex == -1) {
          currRowIndex = PdfGridHeaderCollectionHelper.getHelper(_grid!.headers)
              .indexOf(row);
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
            !PdfGridRowHelper.getHelper(row).isPageBreakRowSpanApplied) {
          rowHeightWithSpan = 0;
          PdfGridRowHelper.getHelper(row).isPageBreakRowSpanApplied = true;
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
                    PdfGridRowHelper.getHelper(_grid!.rows[currRowIndex])
                        .maximumRowSpan = newSpan == 0 ? 1 : newSpan;
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
                                PdfGridHelper.getHelper(pdfGrid).size.height +
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
                      PdfGridRowHelper.getHelper(_grid!.rows[i - 1])
                          .rowSpanExists = true;
                    }
                    PdfGridCellHelper.getHelper(_grid!.rows[i].cells[j])
                        .isRowMergeContinue = false;
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
                    PdfGridRowHelper.getHelper(_grid!.headers[i - 1])
                        .rowSpanExists = false;
                    PdfGridCellHelper.getHelper(_grid!.headers[i].cells[j])
                        .isRowMergeContinue = false;
                  }
                }
                break;
              }
            }
            rowHeightWithSpan = 0;
          }
        }
      }
      double? height = PdfGridRowHelper.getHelper(row).rowBreakHeight > 0.0
          ? PdfGridRowHelper.getHelper(row).rowBreakHeight
          : row.height;
      if (PdfGridHelper.getHelper(_grid!).isChildGrid! &&
          PdfGridHelper.getHelper(_grid!).parentCell != null) {
        if (height +
                PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(PdfGridHelper.getHelper(_grid!).parentCell!).row!)
                    .grid
                    .style
                    .cellPadding
                    .bottom +
                PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(PdfGridHelper.getHelper(_grid!).parentCell!).row!)
                    .grid
                    .style
                    .cellPadding
                    .top >
            _currentPageBounds.height) {
          if (_grid!.allowRowBreakingAcrossPages) {
            result.isFinish = true;
            if (PdfGridHelper.getHelper(_grid!).isChildGrid! &&
                PdfGridRowHelper.getHelper(row).rowBreakHeight > 0) {
              _currentBounds.y = _currentBounds.y +
                  PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                              PdfGridHelper.getHelper(_grid!).parentCell!)
                          .row!)
                      .grid
                      .style
                      .cellPadding
                      .top;
              _currentBounds.x = _startLocation.x;
            }
            result.bounds = _currentBounds;
            result = _drawRowWithBreak(row, result, height);
          } else {
            _currentBounds.y = _currentBounds.y +
                PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                            PdfGridHelper.getHelper(_grid!).parentCell!)
                        .row!)
                    .grid
                    .style
                    .cellPadding
                    .top;
            height = _currentBounds.height -
                _currentBounds.y -
                PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                            PdfGridHelper.getHelper(_grid!).parentCell!)
                        .row!)
                    .grid
                    .style
                    .cellPadding
                    .bottom;
            result.isFinish = false;
            _drawRow(row, result, height);
          }
        } else if (_currentBounds.y +
                    PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(PdfGridHelper.getHelper(_grid!).parentCell!).row!)
                        .grid
                        .style
                        .cellPadding
                        .bottom +
                    height >
                _currentPageBounds.height ||
            _currentBounds.y +
                    PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(PdfGridHelper.getHelper(_grid!).parentCell!).row!)
                        .grid
                        .style
                        .cellPadding
                        .bottom +
                    height >
                _currentBounds.height ||
            _currentBounds.y +
                    PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                                PdfGridHelper.getHelper(_grid!).parentCell!)
                            .row!)
                        .grid
                        .style
                        .cellPadding
                        .bottom +
                    rowHeightWithSpan >
                _currentPageBounds.height) {
          if (repeatRowIndex > -1 &&
              repeatRowIndex == PdfGridRowHelper.getHelper(row).index) {
            if (_grid!.allowRowBreakingAcrossPages) {
              result.isFinish = true;
              if (PdfGridHelper.getHelper(_grid!).isChildGrid! &&
                  PdfGridRowHelper.getHelper(row).rowBreakHeight > 0) {
                _currentBounds.y = _currentBounds.y +
                    PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                                PdfGridHelper.getHelper(_grid!).parentCell!)
                            .row!)
                        .grid
                        .style
                        .cellPadding
                        .top;

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
          if (PdfGridHelper.getHelper(_grid!).isChildGrid! &&
              PdfGridRowHelper.getHelper(row).rowBreakHeight > 0) {
            height += PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                        PdfGridHelper.getHelper(_grid!).parentCell!)
                    .row!)
                .grid
                .style
                .cellPadding
                .bottom;
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
          if (repeatRowIndex > -1 &&
              repeatRowIndex == PdfGridRowHelper.getHelper(row).index) {
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
      final PdfPoint location = _currentBounds.location;
      if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
              .isChildGrid! &&
          PdfGridRowHelper.getHelper(row).grid.allowRowBreakingAcrossPages &&
          _startLocation.x != _currentBounds.x &&
          PdfGridRowHelper.getHelper(row).getWidth() <
              _currentPage!.getClientSize().width) {
        location.x = _startLocation.x;
      }
      result!.bounds = PdfRectangle(location.x, location.y, 0, 0);
      height = _reCalculateHeight(row, height!);
      for (int i = _cellStartIndex; i <= _cellEndIndex; i++) {
        final bool cancelSpans =
            i > _cellEndIndex + 1 && row.cells[i].columnSpan > 1;
        if (!cancelSpans) {
          for (int j = 1; j < row.cells[i].columnSpan; j++) {
            PdfGridCellHelper.getHelper(row.cells[i + j]).isCellMergeContinue =
                true;
          }
        }
        final PdfSize size = PdfSize(_grid!.columns[i].width, height);
        if (size.width > _currentGraphics!.clientSize.width) {
          size.width = _currentGraphics!.clientSize.width;
        }
        if (PdfGridHelper.getHelper(_grid!).isChildGrid! &&
            _grid!.style.allowHorizontalOverflow) {
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
            PdfGridRowHelper.getHelper(row).isHeaderRow
                ? _currentHeaderRowIndex
                : _currentRowIndex,
            i,
            PdfRectangle(location.x, location.y, size.width, size.height),
            (row.cells[i].value is String) ? row.cells[i].value.toString() : '',
            cellstyle,
            PdfGridRowHelper.getHelper(row).isHeaderRow);
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
            PdfGridHelper.getHelper(grid).parentCellIndex = i;
          }
          final PdfStringLayoutResult? stringResult =
              PdfGridCellHelper.getHelper(row.cells[i]).draw(
                  _currentGraphics,
                  PdfRectangle(location.x, location.y, size.width, size.height),
                  cancelSpans);
          if (PdfGridRowHelper.getHelper(row)
                  .grid
                  .style
                  .allowHorizontalOverflow &&
              (row.cells[i].columnSpan > _cellEndIndex ||
                  i + row.cells[i].columnSpan > _cellEndIndex + 1) &&
              _cellEndIndex < row.cells.count - 1) {
            PdfGridRowHelper.getHelper(row).rowOverflowIndex = _cellEndIndex;
          }
          if (PdfGridRowHelper.getHelper(row)
                  .grid
                  .style
                  .allowHorizontalOverflow &&
              (PdfGridRowHelper.getHelper(row).rowOverflowIndex >= 0 &&
                  (row.cells[i].columnSpan > _cellEndIndex ||
                      i + row.cells[i].columnSpan > _cellEndIndex + 1)) &&
              row.cells[i].columnSpan - _cellEndIndex + i - 1 > 0) {
            row.cells[PdfGridRowHelper.getHelper(row).rowOverflowIndex + 1]
                    .value =
                stringResult != null && stringResult.remainder != null
                    ? stringResult.remainder
                    : '';
            row.cells[PdfGridRowHelper.getHelper(row).rowOverflowIndex + 1]
                .stringFormat = row.cells[i].stringFormat;
            row.cells[PdfGridRowHelper.getHelper(row).rowOverflowIndex + 1]
                .style = row.cells[i].style;
            row.cells[PdfGridRowHelper.getHelper(row).rowOverflowIndex + 1]
                .columnSpan = row.cells[i].columnSpan - _cellEndIndex + i - 1;
          }
        }

        if (!cancelSpans) {
          _raiseAfterCellLayout(
              _currentGraphics,
              _currentRowIndex,
              i,
              PdfRectangle(location.x, location.y, size.width, size.height),
              (row.cells[i].value is String)
                  ? row.cells[i].value.toString()
                  : '',
              row.cells[i].style,
              PdfGridRowHelper.getHelper(row).isHeaderRow);
        }

        if (row.cells[i].value is PdfGrid) {
          final PdfGrid grid = row.cells[i].value as PdfGrid;
          PdfGridCellHelper.getHelper(row.cells[i]).pageCount =
              PdfGridHelper.getHelper(grid).listOfNavigatePages.length;
          _rowBreakPageHeightCellIndex = i;
          for (int k = 0;
              k < PdfGridHelper.getHelper(grid).listOfNavigatePages.length;
              k++) {
            final int pageIndex =
                PdfGridHelper.getHelper(grid).listOfNavigatePages[k];
            if (!PdfGridHelper.getHelper(_grid!)
                .listOfNavigatePages
                .contains(pageIndex)) {
              PdfGridHelper.getHelper(_grid!)
                  .listOfNavigatePages
                  .add(pageIndex);
            }
          }
          if (_grid!.columns[i].width >= _currentGraphics!.clientSize.width) {
            location.x = PdfGridHelper.getHelper(grid).rowLayoutBoundswidth;
            location.x = location.x + grid.style.cellSpacing;
          } else {
            location.x = location.x + _grid!.columns[i].width;
          }
        } else {
          location.x = location.x + _grid!.columns[i].width;
        }
      }
      if (!PdfGridRowHelper.getHelper(row).rowMergeComplete ||
          PdfGridRowHelper.getHelper(row).isRowHeightSet) {
        _currentBounds.y = _currentBounds.y + height;
      }
      result.bounds = PdfRectangle(
          result.bounds.x, result.bounds.y, location.x, location.y);
      return null;
    }
  }

  double _reCalculateHeight(PdfGridRow? row, double height) {
    double newHeight = 0.0;
    for (int i = _cellStartIndex; i <= _cellEndIndex; i++) {
      if (PdfGridCellHelper.getHelper(row!.cells[i]).remainingString != null &&
          PdfGridCellHelper.getHelper(row.cells[i])
              .remainingString!
              .isNotEmpty) {
        newHeight = max(newHeight,
            PdfGridCellHelper.getHelper(row.cells[i]).measureHeight());
      }
    }
    return max(height, newHeight);
  }

  _RowLayoutResult _drawRowWithBreak(
      PdfGridRow row, _RowLayoutResult result, double? height) {
    final PdfPoint location = _currentBounds.location;
    if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
            .isChildGrid! &&
        PdfGridRowHelper.getHelper(row).grid.allowRowBreakingAcrossPages &&
        _startLocation.x != _currentBounds.x) {
      location.x = _startLocation.x;
    }
    result.bounds = PdfRectangle(location.x, location.y, 0, 0);
    _newheight = PdfGridRowHelper.getHelper(row).rowBreakHeight > 0
        ? _currentBounds.height < _currentPageBounds.height
            ? _currentBounds.height
            : _currentPageBounds.height
        : 0;
    if (PdfGridRowHelper.getHelper(row).grid.style.cellPadding.top +
            _currentBounds.y +
            PdfGridRowHelper.getHelper(row).grid.style.cellPadding.bottom <
        _currentPageBounds.height) {
      PdfGridRowHelper.getHelper(row).rowBreakHeight =
          _currentBounds.y + height! - _currentPageBounds.height;
    } else {
      PdfGridRowHelper.getHelper(row).rowBreakHeight = height!;
      result.isFinish = false;
      return result;
    }
    for (int cellIndex = 0; cellIndex < row.cells.count; cellIndex++) {
      final PdfGridCell cell = row.cells[cellIndex];
      if (PdfGridCellHelper.getHelper(cell).measureHeight() == height) {
        PdfGridRowHelper.getHelper(row).rowBreakHeight = cell.value is PdfGrid
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
          PdfGridCellHelper.getHelper(row.cells[i + j]).isCellMergeContinue =
              true;
        }
      }
      PdfSize size = PdfSize(
          _grid!.columns[i].width,
          _newheight > 0.0
              ? _newheight
              : _currentBounds.height < _currentPageBounds.height
                  ? _currentBounds.height
                  : _currentPageBounds.height);
      if (size.width == 0) {
        size = PdfSize(row.cells[i].width, size.height);
      }
      if (!_checkIfDefaultFormat(_grid!.columns[i].format) &&
          _checkIfDefaultFormat(row.cells[i].stringFormat)) {
        row.cells[i].stringFormat = _grid!.columns[i].format;
      }
      PdfGridCellStyle cellstyle = row.cells[i].style;
      final Map<String, dynamic> cellLayoutResult = _raiseBeforeCellLayout(
          _currentGraphics,
          PdfGridRowHelper.getHelper(row).isHeaderRow
              ? _currentHeaderRowIndex
              : _currentRowIndex,
          i,
          PdfRectangle(location.x, location.y, size.width, size.height),
          row.cells[i].value is String ? row.cells[i].value.toString() : '',
          cellstyle,
          PdfGridRowHelper.getHelper(row).isHeaderRow);
      cellstyle = cellLayoutResult['style'] as PdfGridCellStyle;
      final PdfGridBeginCellLayoutArgs? bclArgs =
          cellLayoutResult['args'] as PdfGridBeginCellLayoutArgs?;
      row.cells[i].style = cellstyle;
      final bool skipcell = bclArgs != null && bclArgs.skip;
      PdfStringLayoutResult? stringResult;
      if (!skipcell) {
        stringResult = PdfGridCellHelper.getHelper(row.cells[i]).draw(
            _currentGraphics,
            PdfRectangle(location.x, location.y, size.width, size.height),
            cancelSpans);
      }
      if (PdfGridRowHelper.getHelper(row).rowBreakHeight > 0.0) {
        if (stringResult != null) {
          PdfGridCellHelper.getHelper(row.cells[i]).finished = false;
          PdfGridCellHelper.getHelper(row.cells[i]).remainingString =
              stringResult.remainder ?? '';
          if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row).grid)
              .isChildGrid!) {
            PdfGridRowHelper.getHelper(row).rowBreakHeight =
                height - stringResult.size.height;
          }
        } else if (row.cells[i].value is PdfImage) {
          PdfGridCellHelper.getHelper(row.cells[i]).finished = false;
        }
      }
      result.isFinish = (!result.isFinish)
          ? result.isFinish
          : PdfGridCellHelper.getHelper(row.cells[i]).finished;
      if (!cancelSpans) {
        _raiseAfterCellLayout(
            _currentGraphics,
            _currentRowIndex,
            i,
            PdfRectangle(location.x, location.y, size.width, size.height),
            (row.cells[i].value is String) ? row.cells[i].value.toString() : '',
            row.cells[i].style,
            PdfGridRowHelper.getHelper(row).isHeaderRow);
      }
      if (row.cells[i].value is PdfGrid) {
        final PdfGrid grid = row.cells[i].value as PdfGrid;
        _rowBreakPageHeightCellIndex = i;
        PdfGridCellHelper.getHelper(row.cells[i]).pageCount =
            PdfGridHelper.getHelper(grid).listOfNavigatePages.length;
        for (int i = 0;
            i < PdfGridHelper.getHelper(grid).listOfNavigatePages.length;
            i++) {
          final int pageIndex =
              PdfGridHelper.getHelper(grid).listOfNavigatePages[i];
          if (!PdfGridHelper.getHelper(_grid!)
              .listOfNavigatePages
              .contains(pageIndex)) {
            PdfGridHelper.getHelper(_grid!).listOfNavigatePages.add(pageIndex);
          }
        }
        if (_grid!.columns[i].width >= _currentGraphics!.clientSize.width) {
          location.x = PdfGridHelper.getHelper(grid).rowLayoutBoundswidth;
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
        PdfRectangle(result.bounds.x, result.bounds.y, location.x, location.y);
    return result;
  }

  bool _checkIfDefaultFormat(PdfStringFormat format) {
    final PdfStringFormat defaultFormat = PdfStringFormat();
    return format.alignment == defaultFormat.alignment &&
        format.characterSpacing == defaultFormat.characterSpacing &&
        format.clipPath == defaultFormat.clipPath &&
        PdfStringFormatHelper.getHelper(format).firstLineIndent ==
            PdfStringFormatHelper.getHelper(defaultFormat).firstLineIndent &&
        PdfStringFormatHelper.getHelper(format).scalingFactor ==
            PdfStringFormatHelper.getHelper(defaultFormat).scalingFactor &&
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
    final PdfDocument? document =
        PdfPageHelper.getHelper(_currentPage!).document;
    final List<PdfPage?> pages = layoutedPages.keys.toList();
    for (int i = 0; i < pages.length; i++) {
      final PdfPage page = pages[i]!;
      PdfPageHelper.getHelper(page).section = null;
      PdfPageCollectionHelper.getHelper(document!.pages).remove(page);
    }
    for (int i = 0; i < layoutedPages.length; i++) {
      for (int j = i;
          j < layoutedPages.length;
          j += layoutedPages.length ~/ _columnRanges!.length) {
        final PdfPage page = pages[j]!;
        if (document!.pages.indexOf(page) == -1) {
          PdfPageCollectionHelper.getHelper(document.pages).addPage(page);
        }
      }
    }
  }

  void _reArrangePages(PdfPage page) {
    final List<PdfPage?> pages = <PdfPage?>[];
    final PdfDocument document = PdfPageHelper.getHelper(page).document!;
    int pageCount = document.pages.count;
    int m = document.pages.indexOf(page);
    int n = _columnRanges!.length;
    if (pageCount <= _columnRanges!.length) {
      for (int i = 0; i < _columnRanges!.length; i++) {
        document.pages.add();
        if (document.pages.count > _columnRanges!.length) {
          break;
        }
      }
    }
    pageCount = document.pages.count;
    for (int i = 0; i < pageCount; i++) {
      if (m < pageCount && pages.length != pageCount) {
        final PdfPage tempPage = document.pages[m];
        if (!pages.contains(tempPage)) {
          pages.add(tempPage);
        }
      }
      if (n < pageCount && pages.length != pageCount) {
        final PdfPage tempPage = document.pages[n];
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
    for (int i = 0; i < pages.length; i++) {
      final PdfPage tempPage = pages[i]!;
      PdfPageHelper.getHelper(tempPage).section = null;
      PdfPageCollectionHelper.getHelper(document.pages).remove(tempPage);
    }
    for (int i = 0; i < pages.length; i++) {
      PdfPageCollectionHelper.getHelper(document.pages).addPage(pages[i]!);
    }
  }

  PdfPage? _getNextPage(PdfLayoutFormat format) {
    final PdfSection section = PdfPageHelper.getHelper(_currentPage!).section!;
    PdfPage? nextPage;
    final int index =
        PdfSectionHelper.getHelper(section).indexOf(_currentPage!);
    if (PdfPageHelper.getHelper(_currentPage!).document!.pages.count > 1 &&
        _hType == PdfHorizontalOverflowType.nextPage &&
        flag &&
        _columnRanges!.length > 1) {
      PdfGridHelper.getHelper(_grid!).isRearranged = true;
      _reArrangePages(_currentPage!);
    }
    flag = false;
    if (index == PdfSectionHelper.getHelper(section).count - 1) {
      nextPage = PdfPage();
      PdfSectionHelper.getHelper(section).isNewPageSection = true;
      PdfSectionHelper.getHelper(section).add(nextPage);
      PdfSectionHelper.getHelper(section).isNewPageSection = false;
    } else {
      nextPage = PdfSectionHelper.getHelper(section).getPageByIndex(index + 1);
    }
    _currentGraphics = nextPage!.graphics;
    final int pageindex = PdfSectionHelper.getHelper(PdfPageHelper.getHelper(
                PdfGraphicsHelper.getHelper(_currentGraphics!).page!)
            .section!)
        .indexOf(PdfGraphicsHelper.getHelper(_currentGraphics!).page!);
    if (!PdfGridHelper.getHelper(_grid!)
        .listOfNavigatePages
        .contains(pageindex)) {
      PdfGridHelper.getHelper(_grid!).listOfNavigatePages.add(pageindex);
    }
    _currentBounds = PdfRectangle(0, 0, _currentGraphics!.clientSize.width,
        _currentGraphics!.clientSize.height);
    if (PdfRectangle.fromRect(format.paginateBounds) != PdfRectangle.empty) {
      _currentBounds.x = format.paginateBounds.left;
      _currentBounds.y = format.paginateBounds.top;
      _currentBounds.height = format.paginateBounds.height;
    }
    return nextPage;
  }

  PdfLayoutResult _getLayoutResult() {
    if (PdfGridHelper.getHelper(_grid!).isChildGrid! &&
        _grid!.allowRowBreakingAcrossPages) {
      for (int rowIndex = 0; rowIndex < _grid!.rows.count; rowIndex++) {
        final PdfGridRow row = _grid!.rows[rowIndex];
        if (PdfGridRowHelper.getHelper(row).rowBreakHeight > 0) {
          _startLocation.y = PdfPageHelper.getHelper(_currentPage!).origin.dy;
        }
      }
    }
    final Rect bounds = _isChanged
        ? Rect.fromLTWH(_currentLocation.x, _currentLocation.y,
            _currentBounds.width, _currentBounds.y - _currentLocation.y)
        : Rect.fromLTWH(_startLocation.x, _startLocation.y,
            _currentBounds.width, _currentBounds.y - _startLocation.y);
    return PdfLayoutResultHelper.load(_currentPage!, bounds);
  }

  Map<String, dynamic> _raiseBeforePageLayout(
      PdfPage? currentPage, Rect currentBounds, int? currentRow) {
    bool cancel = false;
    if (PdfLayoutElementHelper.getHelper(element!).raiseBeginPageLayout) {
      final PdfGridBeginPageLayoutArgs args =
          PdfGridBeginPageLayoutArgsHelper.load(
              currentBounds, currentPage!, currentRow);
      PdfLayoutElementHelper.getHelper(element!).onBeginPageLayout(args);
      if (PdfRectangle.fromRect(currentBounds) !=
          PdfRectangle.fromRect(args.bounds)) {
        _isChanged = true;
        _currentLocation = PdfPoint(args.bounds.left, args.bounds.top);
        PdfGridHelper.getHelper(_grid!).measureColumnsWidth(PdfRectangle(
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
    final PdfGridEndPageLayoutArgs args =
        PdfGridEndPageLayoutArgsHelper.load(result);
    if (PdfLayoutElementHelper.getHelper(element!).raisePageLayouted) {
      PdfLayoutElementHelper.getHelper(element!).onEndPageLayout(args);
    }
    return args;
  }

  Map<String, dynamic> _raiseBeforeCellLayout(
      PdfGraphics? graphics,
      int rowIndex,
      int cellIndex,
      PdfRectangle bounds,
      String value,
      PdfGridCellStyle? style,
      bool isHeaderRow) {
    PdfGridBeginCellLayoutArgs? args;
    if (PdfGridHelper.getHelper(_grid!).raiseBeginCellLayout) {
      args = PdfGridBeginCellLayoutArgsHelper.load(
          graphics!, rowIndex, cellIndex, bounds, value, style, isHeaderRow);
      PdfGridHelper.getHelper(_grid!).onBeginCellLayout(args);
      style = args.style;
    }
    return <String, dynamic>{'args': args, 'style': style};
  }

  void _raiseAfterCellLayout(
      PdfGraphics? graphics,
      int rowIndex,
      int cellIndex,
      PdfRectangle bounds,
      String value,
      PdfGridCellStyle? cellstyle,
      bool isHeaderRow) {
    PdfGridEndCellLayoutArgs args;
    if (PdfGridHelper.getHelper(_grid!).raiseEndCellLayout) {
      args = PdfGridEndCellLayoutArgsHelper.load(graphics!, rowIndex, cellIndex,
          bounds, value, cellstyle, isHeaderRow);
      PdfGridHelper.getHelper(_grid!).onEndCellLayout(args);
    }
  }

  //Override methods
  @override
  PdfLayoutResult? layoutInternal(PdfLayoutParams param) {
    final PdfLayoutFormat format = _getFormat(param.format);
    _currentPage = param.page;
    if (_currentPage != null) {
      final Size size = _currentPage!.getClientSize();
      final double pageHeight = size.height;
      final double pageWidth = size.width;
      if (pageHeight > pageWidth ||
          (PdfPageHelper.getHelper(param.page!).orientation ==
                  PdfPageOrientation.landscape &&
              format.breakType == PdfLayoutBreakType.fitPage)) {
        _currentPageBounds = PdfSize.fromSize(size);
      } else {
        _currentPageBounds = PdfSize.fromSize(_currentPage!.size);
      }
    } else {
      _currentPageBounds = PdfSize.fromSize(_currentGraphics!.clientSize);
    }
    if (_currentPage != null) {
      _currentGraphics = _currentPage!.graphics;
    }
    if (PdfGraphicsHelper.getHelper(_currentGraphics!).layer != null) {
      final int index = !PdfPageHelper.getHelper(
                  PdfGraphicsHelper.getHelper(_currentGraphics!).page!)
              .isLoadedPage
          ? PdfSectionHelper.getHelper(PdfPageHelper.getHelper(
                      PdfGraphicsHelper.getHelper(_currentGraphics!).page!)
                  .section!)
              .indexOf(PdfGraphicsHelper.getHelper(_currentGraphics!).page!)
          : PdfGraphicsHelper.getHelper(_currentGraphics!)
              .page!
              .defaultLayerIndex;
      if (!PdfGridHelper.getHelper(_grid!)
          .listOfNavigatePages
          .contains(index)) {
        PdfGridHelper.getHelper(_grid!).listOfNavigatePages.add(index);
      }
    }
    _currentBounds = PdfRectangle(
        param.bounds!.x,
        param.bounds!.y,
        format.breakType == PdfLayoutBreakType.fitColumnsToPage
            ? PdfGridColumnCollectionHelper.getHelper(_grid!.columns)
                .columnWidth
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
    if (PdfGridHelper.getHelper(_grid!).isChildGrid!) {
      _childHeight = param.bounds!.height;
    }
    if (param.format != null &&
        PdfLayoutFormatHelper.isBoundsSet(param.format!)) {
      if (param.format!.paginateBounds.height > 0) {
        _currentBounds.height = param.format!.paginateBounds.height;
      }
    } else if (param.bounds!.height > 0 &&
        !PdfGridHelper.getHelper(_grid!).isChildGrid!) {
      _currentBounds.height = param.bounds!.height;
    }
    if (PdfGridHelper.getHelper(_grid!).isChildGrid!) {
      _hType = _grid!.style.horizontalOverflowType;
    }
    if (!_grid!.style.allowHorizontalOverflow) {
      PdfGridHelper.getHelper(_grid!).measureColumnsWidth(_currentBounds);
      _columnRanges!.add(<int>[0, _grid!.columns.count - 1]);
    } else {
      PdfGridHelper.getHelper(_grid!).measureColumnsWidth();
      _determineColumnDrawRanges();
    }
    if (PdfGridHelper.getHelper(_grid!).hasRowSpan) {
      for (int i = 0; i < _grid!.rows.count; i++) {
        _grid!.rows[i].height;
        if (!PdfGridRowHelper.getHelper(_grid!.rows[i]).isRowHeightSet) {
          PdfGridRowHelper.getHelper(_grid!.rows[i]).isRowHeightSet = true;
        } else {
          PdfGridRowHelper.getHelper(_grid!.rows[i]).isRowSpanRowHeightSet =
              true;
        }
      }
    }
    return _layoutOnPage(param);
  }
}

class _RowLayoutResult {
  _RowLayoutResult() {
    bounds = PdfRectangle.empty;
    isFinish = false;
  }
  late bool isFinish;
  late PdfRectangle bounds;
}
