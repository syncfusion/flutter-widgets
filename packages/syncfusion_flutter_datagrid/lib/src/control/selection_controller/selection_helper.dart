part of datagrid;

class _SelectionHelper {
  static int resolveToRowIndex(
      _DataGridSettings dataGridSettings, DataGridRow record) {
    final DataGridRow? rec = dataGridSettings.source._effectiveRows
        .firstWhereOrNull((DataGridRow rec) => rec == record);
    if (rec == null) {
      return -1;
    }

    int recordIndex = dataGridSettings.source._effectiveRows.indexOf(rec);

    recordIndex +=
        _GridIndexResolver.resolveStartIndexBasedOnPosition(dataGridSettings);

    return recordIndex.isNegative ? -1 : recordIndex;
  }

  static DataGridRow? getRecord(_DataGridSettings dataGridSettings, int index) {
    final DataGridSource source = dataGridSettings.source;

    if (source._effectiveRows.isEmpty || index < 0) {
      return null;
    }

    final DataGridRow record = source._effectiveRows[index];
    return record;
  }

  static int getFirstNavigatingRowIndex(_DataGridSettings dataGridSettings) {
    final int index = _SelectionHelper.getFirstRowIndex(dataGridSettings);
    const int count = 0;
    for (int start = index; start >= 0; start--) {
      final List<dynamic> hiddenRowInfo =
          dataGridSettings.container.rowHeights.getHidden(start, count);
      final bool isHiddenRow = hiddenRowInfo.first as bool;
      if (!isHiddenRow) {
        return start;
      }
    }

    return index;
  }

  static int getLastNavigatingRowIndex(_DataGridSettings dataGridSettings) {
    int lastRowIndex = -1;
    const int count = 0;
    final int recordCount = _SelectionHelper.getRecordsCount(dataGridSettings);

    if (recordCount == 0) {
      return -1;
    }

    /// From actual row count we have to reduce the length by 1 to adapt the
    /// row index based on SfDataGrid.
    /// Eg : Total rowCount is 30, we will start the row index from 0 of header
    /// in SfDataGrid. The actual last row index of data grid is 29.
    lastRowIndex = dataGridSettings.container.rowCount - 1;
    if (dataGridSettings.footer != null) {
      lastRowIndex--;
    }
    for (int start = lastRowIndex; start >= 0; start--) {
      final List<dynamic> hiddenRowInfo =
          dataGridSettings.container.rowHeights.getHidden(start, count);
      final bool isHiddenRow = hiddenRowInfo.first as bool;
      if (!isHiddenRow) {
        return start;
      }
    }

    return lastRowIndex;
  }

  static int getRecordsCount(_DataGridSettings dataGridSettings) {
    if (dataGridSettings.source._effectiveRows.isNotEmpty) {
      return dataGridSettings.source._effectiveRows.length;
    } else {
      return 0;
    }
  }

  static int getFirstRowIndex(_DataGridSettings dataGridSettings) {
    if (_SelectionHelper.getRecordsCount(dataGridSettings) == 0) {
      return -1;
    }

    final int index = _GridIndexResolver.getHeaderIndex(dataGridSettings) + 1;
    return index;
  }

  static int getLastCellIndex(_DataGridSettings dataGridSettings) {
    final GridColumn? lastColumn = dataGridSettings.columns
        .lastWhereOrNull((GridColumn col) => col.visible);
    if (lastColumn == null) {
      return -1;
    }

    return dataGridSettings.columns.indexOf(lastColumn);
  }

  static int getFirstCellIndex(_DataGridSettings dataGridSettings) {
    final GridColumn? gridColumn = dataGridSettings.columns
        .firstWhereOrNull((GridColumn col) => col.visible);
    if (gridColumn == null) {
      return -1;
    }

    final int firstIndex = dataGridSettings.columns.indexOf(gridColumn);
    if (firstIndex < 0) {
      return firstIndex;
    }

    return firstIndex;
  }

  static int getLastRowIndex(_DataGridSettings dataGridSettings) {
    if (_SelectionHelper.getRecordsCount(dataGridSettings) == 0) {
      return -1;
    }

    const int count = 0;

    /// From actual row count we have to reduce the length by 1 to adapt the
    /// row index based on SfDataGrid.
    /// Eg : Total rowCount is 30, we will start the row index from 0 of header
    /// in SfDataGrid. The actual last row index of data grid is 29.
    int index = dataGridSettings.container.rowCount - 1;
    if (dataGridSettings.footer != null) {
      index--;
    }
    for (int start = index; start >= 0; start--) {
      final List<dynamic> hiddenRowInfo =
          dataGridSettings.container.rowHeights.getHidden(start, count);
      final bool isHiddenRow = hiddenRowInfo.first as bool;
      if (!isHiddenRow) {
        return start;
      }
    }

    return index;
  }

  static int getPreviousPageIndex(_DataGridSettings dataGridSettings) {
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;
    final int rowIndex = currentCell.rowIndex;
    int lastBodyVisibleIndex = -1;
    final _VisibleLinesCollection visibleLines =
        dataGridSettings.container.scrollRows.getVisibleLines();
    if (visibleLines.lastBodyVisibleIndex < visibleLines.length) {
      lastBodyVisibleIndex =
          visibleLines[visibleLines.lastBodyVisibleIndex - 1].lineIndex;
    }

    int index =
        lastBodyVisibleIndex < rowIndex ? lastBodyVisibleIndex : rowIndex;
    index = dataGridSettings.container.scrollRows.getPreviousPage(index);
    final int firstRowIndex =
        _SelectionHelper.getFirstRowIndex(dataGridSettings);
    if (index < firstRowIndex || rowIndex < firstRowIndex) {
      return firstRowIndex;
    }

    return index;
  }

  static int getNextPageIndex(_DataGridSettings dataGridSettings) {
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;
    int rowIndex = currentCell.rowIndex;
    if (rowIndex <
        _SelectionHelper.getFirstNavigatingRowIndex(dataGridSettings)) {
      rowIndex = 0;
    }

    final _VisibleLinesCollection visibleLines =
        dataGridSettings.container.scrollRows.getVisibleLines();
    int firstBodyVisibleIndex = -1;
    if (visibleLines.firstBodyVisibleIndex < visibleLines.length) {
      firstBodyVisibleIndex =
          visibleLines[visibleLines.firstBodyVisibleIndex].lineIndex;
    }

    int index =
        firstBodyVisibleIndex > rowIndex ? firstBodyVisibleIndex : rowIndex;
    final int lastRowIndex = _SelectionHelper.getLastRowIndex(dataGridSettings);
    index = dataGridSettings.container.scrollRows.getNextPage(index);
    if (index > _SelectionHelper.getLastNavigatingRowIndex(dataGridSettings) &&
        currentCell.rowIndex > lastRowIndex) {
      return currentCell.rowIndex;
    }

    return index = index <= lastRowIndex ? index : lastRowIndex;
  }

  static double getVerticalCumulativeDistance(
      _DataGridSettings dataGridSettings, int rowIndex) {
    double verticalOffset = 0.0;
    final int headerRowIndex =
        _GridIndexResolver.getHeaderIndex(dataGridSettings);
    rowIndex = rowIndex > headerRowIndex ? rowIndex : headerRowIndex + 1;
    final _PixelScrollAxis _scrollRows =
        dataGridSettings.container.scrollRows as _PixelScrollAxis;
    verticalOffset = _scrollRows.distances!.getCumulatedDistanceAt(rowIndex);
    return verticalOffset;
  }

  static double getHorizontalCumulativeDistance(
      _DataGridSettings dataGridSettings, int columnIndex) {
    double horizontalOffset = 0.0;
    final int firstVisibleColumnIndex =
        _GridIndexResolver.resolveToStartColumnIndex(dataGridSettings);
    columnIndex = columnIndex < firstVisibleColumnIndex
        ? firstVisibleColumnIndex
        : columnIndex;
    final _PixelScrollAxis _scrollColumns =
        dataGridSettings.container.scrollColumns as _PixelScrollAxis;
    horizontalOffset =
        _scrollColumns.distances!.getCumulatedDistanceAt(columnIndex);
    return horizontalOffset;
  }

  // ScrollingView Helping API

  static bool needToScrollDown(
      _DataGridSettings dataGridSettings, int nextRowIndex) {
    final _VisibleLinesCollection visibleLines =
        dataGridSettings.container.scrollRows.getVisibleLines();
    if (visibleLines.isEmpty) {
      return false;
    }

    final _VisibleLineInfo? nextRowInfo = dataGridSettings.container.scrollRows
        .getVisibleLineAtLineIndex(nextRowIndex);
    return nextRowInfo == null || nextRowInfo.isClipped;
  }

  static bool needToScrollUp(
      _DataGridSettings dataGridSettings, int previousRowIndex) {
    final _VisibleLinesCollection visibleLineCollection =
        dataGridSettings.container.scrollRows.getVisibleLines();
    if (visibleLineCollection.isEmpty) {
      return false;
    }

    final _VisibleLineInfo? previousRowLineInfo = dataGridSettings
        .container.scrollRows
        .getVisibleLineAtLineIndex(previousRowIndex);
    return previousRowLineInfo == null || previousRowLineInfo.isClipped;
  }

  static bool needToScrollLeft(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    final _VisibleLinesCollection visibleLineCollection =
        _SfDataGridHelper.getVisibleLines(dataGridSettings);
    if (visibleLineCollection.isEmpty) {
      return false;
    }

    final _VisibleLineInfo? previousCellLineInfo = visibleLineCollection
        .getVisibleLineAtLineIndex(rowColumnIndex.columnIndex);
    return previousCellLineInfo == null || previousCellLineInfo.isClipped;
  }

  static bool needToScrollRight(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    final _VisibleLinesCollection visibleLineCollection =
        _SfDataGridHelper.getVisibleLines(dataGridSettings);
    if (visibleLineCollection.isEmpty) {
      return false;
    }
    final _VisibleLineInfo? nextCellLineInfo = visibleLineCollection
        .getVisibleLineAtLineIndex(rowColumnIndex.columnIndex);
    return nextCellLineInfo == null || nextCellLineInfo.isClipped;
  }

  static void scrollInViewFromLeft(_DataGridSettings dataGridSettings,
      {int nextCellIndex = -1, bool needToScrollMaxExtent = false}) {
    if (dataGridSettings.horizontalScrollController != null) {
      final ScrollController horizontalController =
          dataGridSettings.horizontalScrollController!;
      double measuredHorizontalOffset = 0.0;

      final int lastFrozenColumnIndex =
          _GridIndexResolver.getLastFrozenColumnIndex(dataGridSettings);

      final int firstFooterFrozenColumnIndex =
          _GridIndexResolver.getStartFooterFrozenColumnIndex(dataGridSettings);

      if (dataGridSettings.frozenColumnsCount > 0 &&
          lastFrozenColumnIndex + 1 == nextCellIndex) {
        measuredHorizontalOffset =
            horizontalController.position.minScrollExtent;
      } else if (needToScrollMaxExtent ||
          (dataGridSettings.footerFrozenColumnsCount > 0 &&
              firstFooterFrozenColumnIndex - 1 == nextCellIndex)) {
        measuredHorizontalOffset =
            horizontalController.position.maxScrollExtent;
      } else {
        if (dataGridSettings.currentCell.columnIndex != -1 &&
            nextCellIndex == dataGridSettings.currentCell.columnIndex + 1) {
          final List<dynamic> nextCellIndexHeight = dataGridSettings
              .container.columnWidthsProvider
              .getSize(nextCellIndex, 0);
          final _VisibleLinesCollection visibleInfoCollection =
              _SfDataGridHelper.getVisibleLines(dataGridSettings);
          final _VisibleLineInfo? nextCellInfo =
              visibleInfoCollection.getVisibleLineAtLineIndex(nextCellIndex);
          measuredHorizontalOffset = nextCellInfo != null
              ? dataGridSettings.textDirection == TextDirection.rtl
                  ? nextCellInfo.clippedSize -
                      (~nextCellInfo.clippedOrigin.toInt())
                  : nextCellInfo.size -
                      (nextCellInfo.size - nextCellInfo.clippedCornerExtent)
              : nextCellIndexHeight.first as double;
          measuredHorizontalOffset =
              horizontalController.offset + measuredHorizontalOffset;
        } else {
          final _VisibleLinesCollection visibleInfoCollection =
              _SfDataGridHelper.getVisibleLines(dataGridSettings);
          final int firstBodyVisibleLineIndex =
              visibleInfoCollection.firstBodyVisibleIndex <
                      visibleInfoCollection.length
                  ? visibleInfoCollection[
                          visibleInfoCollection.firstBodyVisibleIndex]
                      .lineIndex
                  : 0;
          if (nextCellIndex < firstBodyVisibleLineIndex) {
            scrollInViewFromRight(dataGridSettings,
                previousCellIndex: nextCellIndex,
                needToScrollToMinExtent: false);
          } else {
            measuredHorizontalOffset =
                _SelectionHelper.getHorizontalCumulativeDistance(
                    dataGridSettings, nextCellIndex);
            measuredHorizontalOffset =
                _SfDataGridHelper.resolveHorizontalScrollOffset(
                    dataGridSettings, measuredHorizontalOffset);
            measuredHorizontalOffset =
                horizontalController.offset + measuredHorizontalOffset;
          }
        }
      }

      _SfDataGridHelper.scrollHorizontal(
          dataGridSettings, measuredHorizontalOffset);
    }
  }

  static void scrollInViewFromRight(_DataGridSettings dataGridSettings,
      {int previousCellIndex = -1, bool needToScrollToMinExtent = false}) {
    double measuredHorizontalOffset = 0.0;

    if (dataGridSettings.horizontalScrollController != null) {
      final ScrollController horizontalController =
          dataGridSettings.horizontalScrollController!;

      final int startingFooterFrozenColumnIndex =
          _GridIndexResolver.getStartFooterFrozenColumnIndex(dataGridSettings);
      final int lastFrozenColumnIndex =
          _GridIndexResolver.getLastFrozenColumnIndex(dataGridSettings);

      if (dataGridSettings.footerFrozenColumnsCount > 0 &&
          startingFooterFrozenColumnIndex - 1 == previousCellIndex) {
        measuredHorizontalOffset =
            horizontalController.position.maxScrollExtent;
      } else if (needToScrollToMinExtent ||
          (dataGridSettings.frozenColumnsCount > 0 &&
              lastFrozenColumnIndex + 1 == previousCellIndex)) {
        measuredHorizontalOffset =
            horizontalController.position.minScrollExtent;
      } else {
        if (dataGridSettings.currentCell.columnIndex != -1 &&
            previousCellIndex == dataGridSettings.currentCell.columnIndex - 1) {
          final List<dynamic> previousCellIndexWidth = dataGridSettings
              .container.columnWidthsProvider
              .getSize(previousCellIndex, 0);
          final _VisibleLinesCollection visibleInfoCollection =
              _SfDataGridHelper.getVisibleLines(dataGridSettings);
          final _VisibleLineInfo? previousCellInfo = visibleInfoCollection
              .getVisibleLineAtLineIndex(previousCellIndex);
          measuredHorizontalOffset = previousCellInfo != null
              ? previousCellInfo.size -
                  (previousCellInfo.clippedSize -
                      previousCellInfo.clippedCornerExtent)
              : previousCellIndexWidth.first as double;
          measuredHorizontalOffset =
              horizontalController.offset - measuredHorizontalOffset;
        } else {
          measuredHorizontalOffset =
              _SelectionHelper.getHorizontalCumulativeDistance(
                  dataGridSettings, previousCellIndex);
          measuredHorizontalOffset =
              _SfDataGridHelper.resolveHorizontalScrollOffset(
                  dataGridSettings, measuredHorizontalOffset);
          measuredHorizontalOffset = horizontalController.offset -
              (horizontalController.offset - measuredHorizontalOffset);
        }
      }

      _SfDataGridHelper.scrollHorizontal(
          dataGridSettings, measuredHorizontalOffset);
    }
  }

  static void scrollInViewFromTop(_DataGridSettings dataGridSettings,
      {int nextRowIndex = -1, bool needToScrollToMaxExtent = false}) {
    double measuredVerticalOffset = 0.0;

    if (dataGridSettings.verticalScrollController != null) {
      final ScrollController verticalController =
          dataGridSettings.verticalScrollController!;

      if (dataGridSettings.frozenRowsCount > 0 &&
          _GridIndexResolver.getLastFrozenRowIndex(dataGridSettings) + 1 ==
              nextRowIndex) {
        measuredVerticalOffset = verticalController.position.minScrollExtent;
      } else if (needToScrollToMaxExtent) {
        measuredVerticalOffset = verticalController.position.maxScrollExtent;
      } else {
        if (dataGridSettings.currentCell.rowIndex != -1 &&
            nextRowIndex == dataGridSettings.currentCell.rowIndex + 1) {
          final List<dynamic> nextRowIndexHeight = dataGridSettings
              .container.rowHeightsProvider
              .getSize(nextRowIndex, 0);
          final _VisibleLineInfo? nextRowInfo = dataGridSettings
              .container.scrollRows
              .getVisibleLineAtLineIndex(nextRowIndex);
          measuredVerticalOffset = nextRowInfo != null
              ? nextRowInfo.size -
                  (nextRowInfo.size - nextRowInfo.clippedCornerExtent)
              : nextRowIndexHeight.first as double;
          measuredVerticalOffset =
              verticalController.offset + measuredVerticalOffset;
        } else {
          final _VisibleLinesCollection visibleInfoCollection =
              dataGridSettings.container.scrollRows.getVisibleLines();
          final int firstBodyVisibleLineIndex =
              visibleInfoCollection.firstBodyVisibleIndex <
                      visibleInfoCollection.length
                  ? visibleInfoCollection[
                          visibleInfoCollection.firstBodyVisibleIndex]
                      .lineIndex
                  : 0;
          if (nextRowIndex < firstBodyVisibleLineIndex) {
            scrollInViewFromDown(dataGridSettings,
                previousRowIndex: nextRowIndex, needToScrollToMinExtent: false);
          } else {
            measuredVerticalOffset =
                _SelectionHelper.getVerticalCumulativeDistance(
                    dataGridSettings, nextRowIndex);
            measuredVerticalOffset =
                _SfDataGridHelper.resolveVerticalScrollOffset(
                    dataGridSettings, measuredVerticalOffset);
          }
        }
      }

      _SfDataGridHelper.scrollVertical(
          dataGridSettings, measuredVerticalOffset);
    }
  }

  static void scrollInViewFromDown(_DataGridSettings dataGridSettings,
      {int previousRowIndex = -1, bool needToScrollToMinExtent = false}) {
    double measuredVerticalOffset = 0.0;

    if (dataGridSettings.verticalScrollController != null) {
      final ScrollController verticalController =
          dataGridSettings.verticalScrollController!;

      if (dataGridSettings.footerFrozenRowsCount > 0 &&
          _GridIndexResolver.getStartFooterFrozenRowIndex(dataGridSettings) -
                  1 ==
              previousRowIndex) {
        measuredVerticalOffset = verticalController.position.maxScrollExtent;
      } else if (needToScrollToMinExtent) {
        measuredVerticalOffset = verticalController.position.minScrollExtent;
      } else {
        if (dataGridSettings.currentCell.rowIndex != -1 &&
            previousRowIndex == dataGridSettings.currentCell.rowIndex - 1) {
          final List<dynamic> previousRowIndexHeight = dataGridSettings
              .container.rowHeightsProvider
              .getSize(previousRowIndex, 0);
          final _VisibleLineInfo? previousRowInfo = dataGridSettings
              .container.scrollRows
              .getVisibleLineAtLineIndex(previousRowIndex);
          measuredVerticalOffset = previousRowInfo != null
              ? previousRowInfo.size -
                  (previousRowInfo.clippedSize -
                      previousRowInfo.clippedCornerExtent)
              : previousRowIndexHeight.first as double;
          measuredVerticalOffset =
              verticalController.offset - measuredVerticalOffset;
        } else {
          measuredVerticalOffset =
              _SelectionHelper.getVerticalCumulativeDistance(
                  dataGridSettings, previousRowIndex);
          measuredVerticalOffset =
              _SfDataGridHelper.resolveVerticalScrollOffset(
                  dataGridSettings, measuredVerticalOffset);
          measuredVerticalOffset = verticalController.offset -
              (verticalController.offset - measuredVerticalOffset);
        }
      }

      _SfDataGridHelper.scrollVertical(
          dataGridSettings, measuredVerticalOffset);
    }
  }
}
