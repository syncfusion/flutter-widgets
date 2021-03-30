part of datagrid;

class _VisualContainerHelper {
  _VisualContainerHelper({required this.rowGenerator}) {
    rowHeightsProvider = onCreateRowHeights();
    columnWidthsProvider = onCreateColumnWidths();
  }

  bool _isPreGenerator = false;
  bool _needToRefreshColumn = false;
  bool _isGridLoaded = false;
  int _headerLineCount = 1;
  bool _isDirty = false;

  // Used to set the horizontal offset for LTR to RTL and vise versa,
  bool _needToSetHorizontalOffset = false;

  _DataGridStateDetails? get dataGridStateDetails =>
      rowGenerator.dataGridStateDetails;

  late _RowGenerator rowGenerator;

  late _PaddedEditableLineSizeHostBase rowHeightsProvider;

  late _PaddedEditableLineSizeHostBase columnWidthsProvider;

  _RowHeightManager rowHeightManager = _RowHeightManager();

  _PaddedEditableLineSizeHostBase get rowHeights => rowHeightsProvider;

  _PaddedEditableLineSizeHostBase get columnWidths => columnWidthsProvider;

  _ScrollAxisBase get scrollRows {
    _scrollRows ??=
        createScrollAxis(true, verticalScrollBar, rowHeightsProvider);
    _scrollRows!.name = 'ScrollRows';

    return _scrollRows!;
  }

  _ScrollAxisBase? _scrollRows;

  set scrollRows(_ScrollAxisBase newValue) => _scrollRows = newValue;

  _ScrollAxisBase get scrollColumns {
    _scrollColumns ??=
        createScrollAxis(true, horizontalScrollBar, columnWidthsProvider);
    _scrollColumns!.name = 'ScrollColumns';
    return _scrollColumns!;
  }

  _ScrollAxisBase? _scrollColumns;

  set scrollColumns(_ScrollAxisBase newValue) => _scrollColumns = newValue;

  _ScrollBarBase get horizontalScrollBar =>
      _horizontalScrollBar ?? (_horizontalScrollBar = _ScrollInfo());
  _ScrollBarBase? _horizontalScrollBar;

  _ScrollBarBase get verticalScrollBar =>
      _verticalScrollBar ?? (_verticalScrollBar = _ScrollInfo());
  _ScrollBarBase? _verticalScrollBar;

  int get rowCount => rowHeightsProvider.lineCount;

  set rowCount(int newValue) {
    if (newValue > rowCount) {
      insertRows(rowCount, newValue - rowCount);
    } else if (newValue < rowCount) {
      removeRows(newValue, rowCount - newValue);
    }
  }

  int get columnCount => columnWidthsProvider.lineCount;

  set columnCount(int newValue) {
    if (newValue > columnCount) {
      insertColumns(columnCount, newValue - columnCount);
    } else if (newValue < columnCount) {
      removeColumns(newValue, columnCount - newValue);
    }
  }

  int get frozenRows => rowHeightsProvider.headerLineCount;

  set frozenRows(int newValue) {
    if (newValue < 0 || frozenRows == newValue) {
      return;
    }

    rowHeightsProvider.headerLineCount = newValue;
  }

  int get footerFrozenRows => rowHeightsProvider.footerLineCount;

  set footerFrozenRows(int newValue) {
    if (newValue < 0 || footerFrozenRows == newValue) {
      return;
    }

    rowHeightsProvider.footerLineCount = newValue;
  }

  int get frozenColumns => columnWidthsProvider.headerLineCount;

  set frozenColumns(int newValue) {
    if (newValue < 0 || frozenColumns == newValue) {
      return;
    }

    columnWidthsProvider.headerLineCount = newValue;
  }

  int get footerFrozenColumns => columnWidthsProvider.footerLineCount;

  set footerFrozenColumns(int newValue) {
    if (newValue < 0 || footerFrozenColumns == newValue) {
      return;
    }

    columnWidthsProvider.footerLineCount = newValue;
  }

  double get horizontalOffset =>
      horizontalScrollBar.value - horizontalScrollBar.minimum;

  set horizontalOffset(double newValue) {
    final _DataGridSettings dataGridSettings = dataGridStateDetails!();
    if (dataGridSettings.textDirection == TextDirection.ltr) {
      horizontalScrollBar.value = newValue + horizontalScrollBar.minimum;
    } else {
      horizontalScrollBar.value = max(horizontalScrollBar.minimum,
              horizontalScrollBar.maximum - horizontalScrollBar.largeChange) -
          newValue;
    }
    dataGridSettings.controller._horizontalOffset = horizontalScrollBar.value;

    _needToRefreshColumn = true;
  }

  double get verticalOffset =>
      verticalScrollBar.value - verticalScrollBar.minimum;

  set verticalOffset(double newValue) {
    if (verticalScrollBar.value != (newValue + verticalScrollBar.minimum)) {
      verticalScrollBar.value = newValue + verticalScrollBar.minimum;
      dataGridStateDetails!().controller._verticalOffset =
          verticalScrollBar.value;
    }
  }

  double get extentWidth {
    final _PixelScrollAxis _scrollColumns = scrollColumns as _PixelScrollAxis;
    return _scrollColumns.totalExtent;
  }

  double get extentHeight {
    final _PixelScrollAxis _scrollRows = scrollRows as _PixelScrollAxis;
    return _scrollRows.totalExtent;
  }

  void setRowHeights() {
    if (dataGridStateDetails!().onQueryRowHeight == null) {
      return;
    }

    final visibleRows = scrollRows.getVisibleLines();

    int endIndex = 0;

    if (visibleRows.length <= visibleRows.firstBodyVisibleIndex) {
      return;
    }

    endIndex = visibleRows[visibleRows.lastBodyVisibleIndex].lineIndex;

    const headerStart = 0;

    final headerEnd = scrollRows.headerLineCount - 1;
    rowHeightHelper(headerStart, headerEnd, RowRegion.header);

    rowHeightManager.updateRegion(headerStart, headerEnd, RowRegion.header);

    final footerStart =
        visibleRows.length > visibleRows.firstFooterVisibleIndex &&
                scrollRows.footerLineCount > 0
            ? visibleRows[visibleRows.firstFooterVisibleIndex].lineIndex
            : -1;
    final footerEnd =
        scrollRows.footerLineCount > 0 ? scrollRows.lineCount - 1 : -1;

    rowHeightHelper(footerStart, footerEnd, RowRegion.footer);

    rowHeightManager.updateRegion(footerStart, footerEnd, RowRegion.footer);

    final bodyStart = visibleRows[visibleRows.firstBodyVisibleIndex].origin;

    final bodyEnd = visibleRows[visibleRows.firstFooterVisibleIndex - 1].corner;

    final bodyStartLineIndex =
        visibleRows[visibleRows.firstBodyVisibleIndex].lineIndex;

    var current = bodyStart;
    var currentEnd = endIndex;

    final _LineSizeCollection lineSizeCollection =
        rowHeights as _LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    for (int index = bodyStartLineIndex;
        current <= bodyEnd && index < scrollRows.firstFooterLineIndex;
        index++) {
      var height = rowHeights[index];

      if (!rowHeightManager.contains(index, RowRegion.body)) {
        final rowHeight = rowGenerator._queryRowHeight(index, height);
        if (rowHeight != height) {
          height = rowHeight;
          rowHeights.setRange(index, index, height);
        }
      }

      current += height;
      currentEnd = index;
    }

    rowHeightManager.updateRegion(
        bodyStartLineIndex, currentEnd, RowRegion.body);

    if (rowHeightManager.dirtyRows.isNotEmpty) {
      for (final index in rowHeightManager.dirtyRows) {
        if (index < 0 || index >= rowHeights.lineCount) {
          continue;
        }

        final height = rowHeights[index];
        final rowHeight = rowGenerator._queryRowHeight(index, height);
        if (rowHeight != height) {
          rowHeights.setRange(index, index, rowHeight);
        }
      }

      rowHeightManager.dirtyRows.clear();
    }

    lineSizeCollection.resumeUpdates();
    scrollRows.updateScrollBar(false);
  }

  void rowHeightHelper(int startIndex, int endIndex, RowRegion region) {
    if (startIndex < 0 || endIndex < 0) {
      return;
    }

    final _DataGridSettings dataGridSettings = dataGridStateDetails!();
    for (int index = startIndex; index <= endIndex; index++) {
      if (!rowHeightManager.contains(index, region)) {
        final height = dataGridSettings.container.rowHeights[index];
        final rowHeight = rowGenerator._queryRowHeight(index, height);
        if (rowHeight != height) {
          rowHeights.setRange(index, index, rowHeight);

          if (region == RowRegion.header &&
              index == _GridIndexResolver.getHeaderIndex(dataGridSettings)) {
            dataGridSettings.headerRowHeight = rowHeight;
          }
        }
      }
    }
  }

  void preGenerateItems() {
    final _VisibleLinesCollection visibleRows = scrollRows.getVisibleLines();
    final _VisibleLinesCollection visibleColumns =
        _SfDataGridHelper.getVisibleLines(rowGenerator.dataGridStateDetails());

    if (visibleRows.isNotEmpty && visibleColumns.isNotEmpty) {
      rowGenerator._preGenerateRows(visibleRows, visibleColumns);
      _isPreGenerator = true;
    }
  }

  _PaddedEditableLineSizeHostBase onCreateRowHeights() {
    final _LineSizeCollection lineSizeCollection = _LineSizeCollection();
    return lineSizeCollection;
  }

  _PaddedEditableLineSizeHostBase onCreateColumnWidths() {
    final _LineSizeCollection lineSizeCollection = _LineSizeCollection();
    return lineSizeCollection;
  }

  void insertRows(int insertAtRowIndex, int count) {
    rowHeightsProvider.insertLines(insertAtRowIndex, count, null);
  }

  void removeRows(int removeAtRowIndex, int count) {
    rowHeightsProvider.removeLines(removeAtRowIndex, count, null);
  }

  void insertColumns(int insertAtColumnIndex, int count) {
    columnWidthsProvider.insertLines(insertAtColumnIndex, count, null);
  }

  void removeColumns(int removeAtColumnIndex, int count) {
    final _LineSizeCollection lineSizeCollection =
        columnWidths as _LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    columnWidthsProvider.removeLines(removeAtColumnIndex, count, null);
    lineSizeCollection.resumeUpdates();
  }

  void updateScrollBars() {
    scrollRows.updateScrollBar(false);
    scrollColumns.updateScrollBar(false);
  }

  void updateAxis(Size availableSize) {
    scrollRows.renderSize = availableSize.height;
    scrollColumns.renderSize = availableSize.width;
  }

  _ScrollAxisBase createScrollAxis(bool isPixelScroll, _ScrollBarBase scrollBar,
      _LineSizeHostBase lineSizes) {
    if (isPixelScroll) {
      final Object _lineSizes = lineSizes;
      if (lineSizes is _DistancesHostBase) {
        return _PixelScrollAxis.fromPixelScrollAxis(
            scrollBar, lineSizes, _lineSizes as _DistancesHostBase);
      } else {
        return _PixelScrollAxis.fromPixelScrollAxis(scrollBar, lineSizes, null);
      }
    } else {
      return _LineScrollAxis(scrollBar, lineSizes);
    }
  }

  _VisibleLineInfo? getRowVisibleLineInfo(int index) =>
      scrollRows.getVisibleLineAtLineIndex(index);

  List<int> _getStartEndIndex(
      _VisibleLinesCollection visibleLines, int region) {
    var startIndex = 0;
    var endIndex = -1;
    switch (region) {
      case 0:
        if (visibleLines.firstBodyVisibleIndex > 0) {
          startIndex = 0;
          endIndex =
              visibleLines[visibleLines.firstBodyVisibleIndex - 1].lineIndex;
        }
        break;
      case 1:
        if ((visibleLines.firstBodyVisibleIndex <= 0 &&
                visibleLines.lastBodyVisibleIndex < 0) ||
            visibleLines.length <= visibleLines.firstBodyVisibleIndex) {
          return [startIndex, endIndex];
        } else {
          startIndex =
              visibleLines[visibleLines.firstBodyVisibleIndex].lineIndex;
          endIndex = visibleLines[visibleLines.lastBodyVisibleIndex].lineIndex;
        }
        break;
      case 2:
        if (visibleLines.firstFooterVisibleIndex < visibleLines.length) {
          startIndex =
              visibleLines[visibleLines.firstFooterVisibleIndex].lineIndex;
          endIndex = visibleLines[visibleLines.length - 1].lineIndex;
        }
        break;
    }

    return [startIndex, endIndex];
  }

  void _refreshDefaultLineSize() {
    final _DataGridSettings dataGridSettings = dataGridStateDetails!();
    rowHeights.defaultLineSize = dataGridSettings.rowHeight;
    columnWidths.defaultLineSize = dataGridSettings.defaultColumnWidth;
  }

  void _refreshHeaderLineCount() {
    final dataGridSettings = dataGridStateDetails!();
    _headerLineCount = 1;
    if (dataGridSettings.stackedHeaderRows.isNotEmpty) {
      _headerLineCount += dataGridSettings.stackedHeaderRows.length;
      dataGridSettings.headerLineCount = _headerLineCount;
    } else {
      dataGridSettings.headerLineCount = 1;
    }
  }

  void _updateRowAndColumnCount() {
    final _LineSizeCollection lineSizeCollection =
        columnWidths as _LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    final _DataGridSettings dataGridSettings = dataGridStateDetails!();
    _updateColumnCount(dataGridSettings);
    _updateRowCount(dataGridSettings);
    if (rowCount > 0) {
      for (int i = 0;
          i <= _GridIndexResolver.getHeaderIndex(dataGridSettings);
          i++) {
        rowHeights[i] = dataGridSettings.headerRowHeight;
      }
    }

    //need to update the indent column width here
    lineSizeCollection.resumeUpdates();
    updateScrollBars();
    _updateFreezePaneColumns(dataGridSettings);

    rowHeights.lineCount = rowCount;
    columnWidths.lineCount = columnCount;
  }

  void _updateColumnCount(_DataGridSettings dataGridSettings) {
    final columnCount = dataGridSettings.columns.length;
    this.columnCount = columnCount;
  }

  void _updateRowCount(_DataGridSettings dataGridSettings) {
    final _LineSizeCollection lineSizeCollection =
        rowHeights as _LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    int _rowCount = 0;
    _rowCount = dataGridSettings.source._effectiveRows.isNotEmpty
        ? dataGridSettings.source._effectiveRows.length
        : 0;
    _rowCount += dataGridSettings.headerLineCount;
    this.rowCount = _rowCount;
    _updateFreezePaneRows(dataGridSettings);
    // FLUT-2047 Need to mark all visible rows height as dirty when
    // updating the row count if onQueryRowHeight is not null.
    if (dataGridStateDetails!().onQueryRowHeight != null) {
      rowHeightManager.reset();
    }
    //need to reset the hidden state
    lineSizeCollection.resumeUpdates();
    //need to check again need to call the updateFreezePaneRows here
    _updateFreezePaneRows(dataGridSettings);
  }

  void _updateFreezePaneColumns(_DataGridSettings dataGridSettings) {
    final frozenColumnCount = _GridIndexResolver.resolveToScrollColumnIndex(
        dataGridSettings, dataGridSettings.frozenColumnsCount);
    if (frozenColumnCount > 0 && columnCount >= frozenColumnCount) {
      frozenColumns = frozenColumnCount;
    } else {
      frozenColumns = 0;
    }

    final footerFrozenColumnsCount = dataGridSettings.footerFrozenColumnsCount;
    if (footerFrozenColumnsCount > 0 &&
        columnCount > frozenColumnCount + footerFrozenColumnsCount) {
      footerFrozenColumns = footerFrozenColumnsCount;
    } else {
      footerFrozenColumns = 0;
    }
  }

  void _updateFreezePaneRows(_DataGridSettings dataGridSettings) {
    final frozenRowCount = _GridIndexResolver.resolveToRowIndex(
        dataGridSettings, dataGridSettings.frozenRowsCount);
    if (frozenRowCount > 0 && rowCount >= frozenRowCount) {
      frozenRows = _headerLineCount + dataGridSettings.frozenRowsCount;
    } else {
      frozenRows = _headerLineCount;
    }

    final int footerFrozenRowsCount = dataGridSettings.footerFrozenRowsCount;
    if (footerFrozenRowsCount > 0 &&
        rowCount > frozenRows + footerFrozenRowsCount &&
        footerFrozenRowsCount < rowCount - frozenRowCount) {
      footerFrozenRows = footerFrozenRowsCount;
    } else {
      footerFrozenRows = 0;
    }
  }

  void _refreshView() {
    void resetRowIndex(DataRowBase dataRow) {
      dataRow.rowIndex = -1;
    }

    rowGenerator.items.forEach(resetRowIndex);
  }

  void _refreshViewStyle() {
    void updateColumn(DataCellBase dataCell) {
      dataCell
        .._isDirty = true
        .._updateColumn();
    }

    for (final dataRow in rowGenerator.items) {
      dataRow
        .._isDirty = true
        .._visibleColumns.forEach(updateColumn);
    }
  }

  void resetSwipeOffset() {
    final dataGridSettings = dataGridStateDetails!();
    if (!dataGridSettings.allowSwiping) {
      return;
    }

    final swipedRow = dataGridSettings.rowGenerator.items.firstWhereOrNull(
      (row) => row._isSwipingRow && dataGridSettings.swipingOffset.abs() > 0,
    );
    if (swipedRow != null) {
      swipedRow._isSwipingRow = false;
      dataGridSettings.swipingOffset = 0.0;
    }
  }
}

class _RowHeightManager {
  _Range header = _Range();
  _Range body = _Range();
  _Range footer = _Range();
  List<int> dirtyRows = [];

  bool contains(int index, RowRegion region) {
    _Range range;
    if (region == RowRegion.header) {
      range = header;
    } else if (region == RowRegion.body) {
      range = body;
    } else {
      range = footer;
    }

    if (range.isEmpty()) {
      if (dirtyRows.contains(index)) {
        dirtyRows.remove(index);
      }

      return false;
    }

    if (index >= range.start && index <= range.end) {
      if (dirtyRows.contains(index)) {
        dirtyRows.remove(index);
        return false;
      }

      return true;
    }

    return false;
  }

  void setDirty(int rowIndex) {
    if (!dirtyRows.contains(rowIndex)) {
      dirtyRows.add(rowIndex);
    }
  }

  _Range getRange(int index) {
    if (index == 0) {
      return header;
    } else if (index == 1) {
      return body;
    } else {
      return footer;
    }
  }

  void reset() {
    header.start =
        header.end = body.start = body.end = footer.start = footer.end = -1;
  }

  void resetBody() {
    body.start = body.end = -1;
  }

  void resetFooter() {
    footer.start = footer.end = -1;
  }

  void updateBody(int index, int count) {
    if ((index + count) <= body.start) {
      resetBody();
      return;
    } else if (index > body.end) {
      return;
    } else {
      body.end = index;
    }
  }

  void updateRegion(int start, int end, RowRegion region) {
    _Range range;
    if (region == RowRegion.header) {
      range = header;
    } else if (region == RowRegion.body) {
      range = body;
    } else {
      range = footer;
    }

    range
      ..start = start
      ..end = end;
  }
}

class _Range {
  _Range();

  int start = -1;
  int end = -1;

  bool isEmpty() => start < 0 || end < 0;
}
