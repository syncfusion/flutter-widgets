part of datagrid;

class _SelectionHelper {
  static int resolveToRowIndex(
      _DataGridSettings dataGridSettings, DataGridRow record) {
    var recordIndex = dataGridSettings.source._effectiveRows.indexOf(record);
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
    final index = _SelectionHelper.getFirstRowIndex(dataGridSettings);
    final int count = 0;
    for (int start = index; start >= 0; start--) {
      final hiddenRowInfo =
          dataGridSettings.container.rowHeights.getHidden(start, count);
      if (!hiddenRowInfo.first) {
        return start;
      }
    }

    return index;
  }

  static int getLastNavigatingRowIndex(_DataGridSettings dataGridSettings) {
    var lastRowIndex = -1;
    final count = 0;
    final recordCount = _SelectionHelper.getRecordsCount(dataGridSettings);

    if (recordCount == 0) {
      return -1;
    }

    lastRowIndex = dataGridSettings.container.rowCount -
        dataGridSettings.container._headerLineCount;
    for (int start = lastRowIndex; start >= 0; start--) {
      final hiddenRowInfo =
          dataGridSettings.container.rowHeights.getHidden(start, count);
      if (!hiddenRowInfo.first) {
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

    final index = _GridIndexResolver.getHeaderIndex(dataGridSettings) + 1;
    return index;
  }

  static int getLastCellIndex(_DataGridSettings dataGridSettings) {
    final lastColumn =
        dataGridSettings.columns.lastWhereOrNull((col) => col.visible);
    if (lastColumn == null) {
      return -1;
    }

    return dataGridSettings.columns.indexOf(lastColumn);
  }

  static int getFirstCellIndex(_DataGridSettings dataGridSettings) {
    final gridColumn =
        dataGridSettings.columns.firstWhereOrNull((col) => col.visible);
    if (gridColumn == null) {
      return -1;
    }

    final firstIndex = dataGridSettings.columns.indexOf(gridColumn);
    if (firstIndex < 0) {
      return firstIndex;
    }

    return firstIndex;
  }

  static int getLastRowIndex(_DataGridSettings dataGridSettings) {
    if (_SelectionHelper.getRecordsCount(dataGridSettings) == 0) {
      return -1;
    }

    final count = 0;
    final index = dataGridSettings.container.rowCount;

    for (int start = index; start >= 0; start--) {
      final hiddenRowInfo =
          dataGridSettings.container.rowHeights.getHidden(start, count);
      if (!hiddenRowInfo.first) {
        return start;
      }
    }

    return index;
  }

  static int getPreviousPageIndex(_DataGridSettings dataGridSettings) {
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;
    final rowIndex = currentCell.rowIndex;
    int lastBodyVisibleIndex = -1;
    final visibleLines =
        dataGridSettings.container.scrollRows.getVisibleLines();
    if (visibleLines.lastBodyVisibleIndex < visibleLines.length) {
      lastBodyVisibleIndex =
          visibleLines[visibleLines.lastBodyVisibleIndex - 1].lineIndex;
    }

    var index =
        lastBodyVisibleIndex < rowIndex ? lastBodyVisibleIndex : rowIndex;
    index = dataGridSettings.container.scrollRows.getPreviousPage(index);
    final firstRowIndex = _SelectionHelper.getFirstRowIndex(dataGridSettings);
    if (index < firstRowIndex || rowIndex < firstRowIndex) {
      return firstRowIndex;
    }

    return index;
  }

  static int getNextPageIndex(_DataGridSettings dataGridSettings) {
    final _CurrentCellManager currentCell = dataGridSettings.currentCell;
    var rowIndex = currentCell.rowIndex;
    if (rowIndex <
        _SelectionHelper.getFirstNavigatingRowIndex(dataGridSettings)) {
      rowIndex = 0;
    }

    final visibleLines =
        dataGridSettings.container.scrollRows.getVisibleLines();
    int firstBodyVisibleIndex = -1;
    if (visibleLines.firstBodyVisibleIndex < visibleLines.length) {
      firstBodyVisibleIndex =
          visibleLines[visibleLines.firstBodyVisibleIndex].lineIndex;
    }

    var index =
        firstBodyVisibleIndex > rowIndex ? firstBodyVisibleIndex : rowIndex;
    final lastRowIndex = _SelectionHelper.getLastRowIndex(dataGridSettings);
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
    final headerRowIndex = _GridIndexResolver.getHeaderIndex(dataGridSettings);
    rowIndex = rowIndex > headerRowIndex ? rowIndex : headerRowIndex + 1;
    final _PixelScrollAxis _scrollRows =
        dataGridSettings.container.scrollRows as _PixelScrollAxis;
    verticalOffset = _scrollRows.distances!.getCumulatedDistanceAt(rowIndex);
    final frozenRowsCount = headerRowIndex + dataGridSettings.frozenRowsCount;
    if (frozenRowsCount > 0) {
      for (int i = 0; i <= frozenRowsCount; i++) {
        verticalOffset -= dataGridSettings.container.rowHeights[i];
      }
      return verticalOffset;
    }
    return verticalOffset -= dataGridSettings.container.rowHeights[0];
  }

  static double getHorizontalCumulativeDistance(
      _DataGridSettings dataGridSettings, int columnIndex) {
    double horizontalOffset = 0.0;
    final firstVisibleColumnIndex =
        _GridIndexResolver.resolveToStartColumnIndex(dataGridSettings);
    columnIndex = columnIndex < firstVisibleColumnIndex
        ? firstVisibleColumnIndex
        : columnIndex;
    final _PixelScrollAxis _scrollColumns =
        dataGridSettings.container.scrollColumns as _PixelScrollAxis;
    horizontalOffset =
        _scrollColumns.distances!.getCumulatedDistanceAt(columnIndex);
    final frozenColumnsCount = dataGridSettings.frozenColumnsCount;
    if (frozenColumnsCount > 0) {
      for (int i = 0; i <= frozenColumnsCount; i++) {
        horizontalOffset -= dataGridSettings.container.columnWidths[i];
      }
      return horizontalOffset;
    }
    return horizontalOffset;
  }

  // ScrollingView Helping API

  static bool needToScrollDown(
      _DataGridSettings dataGridSettings, int nextRowIndex) {
    final visibleLines =
        dataGridSettings.container.scrollRows.getVisibleLines();
    if (visibleLines.isEmpty) {
      return false;
    }

    final nextRowInfo = dataGridSettings.container.scrollRows
        .getVisibleLineAtLineIndex(nextRowIndex);
    return nextRowInfo == null || nextRowInfo.isClipped;
  }

  static bool needToScrollUp(
      _DataGridSettings dataGridSettings, int previousRowIndex) {
    final visibleLineCollection =
        dataGridSettings.container.scrollRows.getVisibleLines();
    if (visibleLineCollection.isEmpty) {
      return false;
    }

    final previousRowLineInfo = dataGridSettings.container.scrollRows
        .getVisibleLineAtLineIndex(previousRowIndex);
    return previousRowLineInfo == null || previousRowLineInfo.isClipped;
  }

  static bool needToScrollLeft(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    final visibleLineCollection =
        _SfDataGridHelper.getVisibleLines(dataGridSettings);
    if (visibleLineCollection.isEmpty) {
      return false;
    }

    final previousCellLineInfo = visibleLineCollection
        .getVisibleLineAtLineIndex(rowColumnIndex.columnIndex);
    return previousCellLineInfo == null || previousCellLineInfo.isClipped;
  }

  static bool needToScrollRight(
      _DataGridSettings dataGridSettings, RowColumnIndex rowColumnIndex) {
    final visibleLineCollection =
        _SfDataGridHelper.getVisibleLines(dataGridSettings);
    if (visibleLineCollection.isEmpty) {
      return false;
    }
    final nextCellLineInfo = visibleLineCollection
        .getVisibleLineAtLineIndex(rowColumnIndex.columnIndex);
    return nextCellLineInfo == null || nextCellLineInfo.isClipped;
  }

  static void scrollInViewFromLeft(_DataGridSettings dataGridSettings,
      {int nextCellIndex = -1, bool needToScrollMaxExtent = false}) {
    if (dataGridSettings.horizontalController != null) {
      final horizontalController = dataGridSettings.horizontalController!;
      var measuredHorizontalOffset = 0.0;

      if (dataGridSettings.frozenColumnsCount > 0 &&
          _GridIndexResolver.getLastFrozenColumnIndex(dataGridSettings) + 1 ==
              nextCellIndex) {
        measuredHorizontalOffset =
            horizontalController.position.minScrollExtent;
      } else if (needToScrollMaxExtent) {
        measuredHorizontalOffset =
            horizontalController.position.maxScrollExtent;
      } else {
        if (dataGridSettings.currentCell.columnIndex != -1 &&
            nextCellIndex == dataGridSettings.currentCell.columnIndex + 1) {
          final nextCellIndexHeight = dataGridSettings
              .container.columnWidthsProvider
              .getSize(nextCellIndex, 0);
          final visibleInfoCollection =
              _SfDataGridHelper.getVisibleLines(dataGridSettings);
          final nextCellInfo =
              visibleInfoCollection.getVisibleLineAtLineIndex(nextCellIndex);
          measuredHorizontalOffset = nextCellInfo != null
              ? dataGridSettings.textDirection == TextDirection.rtl
                  ? nextCellInfo.clippedSize -
                      (~nextCellInfo.clippedOrigin.toInt())
                  : nextCellInfo.size -
                      (nextCellInfo.size - nextCellInfo.clippedCornerExtent)
              : nextCellIndexHeight.first;
          measuredHorizontalOffset =
              horizontalController.offset + measuredHorizontalOffset;
        } else {
          final visibleInfoCollection =
              _SfDataGridHelper.getVisibleLines(dataGridSettings);
          final firstBodyVisibleLineIndex =
              visibleInfoCollection.firstBodyVisibleIndex <
                      visibleInfoCollection.length
                  ? visibleInfoCollection[
                          visibleInfoCollection.firstBodyVisibleIndex]
                      .lineIndex
                  : 0;
          if (nextCellIndex < firstBodyVisibleLineIndex) {
            return scrollInViewFromRight(dataGridSettings,
                previousCellIndex: nextCellIndex,
                needToScrollToMinExtent: false);
          } else {
            measuredHorizontalOffset = horizontalController.offset +
                _SelectionHelper.getHorizontalCumulativeDistance(
                    dataGridSettings, nextCellIndex);
          }
        }
      }

      _SfDataGridHelper.scrollHorizontal(
          dataGridSettings, measuredHorizontalOffset);
    }
  }

  static void scrollInViewFromRight(_DataGridSettings dataGridSettings,
      {int previousCellIndex = -1, bool needToScrollToMinExtent = false}) {
    var measuredHorizontalOffset = 0.0;

    if (dataGridSettings.horizontalController != null) {
      final ScrollController horizontalController =
          dataGridSettings.horizontalController!;

      if (dataGridSettings.footerFrozenColumnsCount > 0 &&
          _GridIndexResolver.getStartFooterFrozenColumnIndex(dataGridSettings) -
                  1 ==
              previousCellIndex) {
        measuredHorizontalOffset =
            horizontalController.position.maxScrollExtent;
      } else if (needToScrollToMinExtent) {
        measuredHorizontalOffset =
            horizontalController.position.minScrollExtent;
      } else {
        if (dataGridSettings.currentCell.columnIndex != -1 &&
            previousCellIndex == dataGridSettings.currentCell.columnIndex - 1) {
          final previousCellIndexWidth = dataGridSettings
              .container.columnWidthsProvider
              .getSize(previousCellIndex, 0);
          final visibleInfoCollection =
              _SfDataGridHelper.getVisibleLines(dataGridSettings);
          final previousCellInfo = visibleInfoCollection
              .getVisibleLineAtLineIndex(previousCellIndex);
          measuredHorizontalOffset = previousCellInfo != null
              ? previousCellInfo.size -
                  (previousCellInfo.clippedSize -
                      previousCellInfo.clippedCornerExtent)
              : previousCellIndexWidth.first;
          measuredHorizontalOffset =
              horizontalController.offset - measuredHorizontalOffset;
        } else {
          measuredHorizontalOffset = horizontalController.offset -
              (horizontalController.offset -
                  _SelectionHelper.getHorizontalCumulativeDistance(
                      dataGridSettings, previousCellIndex));
        }
      }

      _SfDataGridHelper.scrollHorizontal(
          dataGridSettings, measuredHorizontalOffset);
    }
  }

  static void scrollInViewFromTop(_DataGridSettings dataGridSettings,
      {int nextRowIndex = -1, bool needToScrollToMaxExtent = false}) {
    var measuredVerticalOffset = 0.0;

    if (dataGridSettings.verticalController != null) {
      final ScrollController verticalController =
          dataGridSettings.verticalController!;

      if (dataGridSettings.frozenRowsCount > 0 &&
          _GridIndexResolver.getLastFrozenRowIndex(dataGridSettings) + 1 ==
              nextRowIndex) {
        measuredVerticalOffset = verticalController.position.minScrollExtent;
      } else if (needToScrollToMaxExtent) {
        measuredVerticalOffset = verticalController.position.maxScrollExtent;
      } else {
        if (dataGridSettings.currentCell.rowIndex != -1 &&
            nextRowIndex == dataGridSettings.currentCell.rowIndex + 1) {
          final nextRowIndexHeight = dataGridSettings
              .container.rowHeightsProvider
              .getSize(nextRowIndex, 0);
          final nextRowInfo = dataGridSettings.container.scrollRows
              .getVisibleLineAtLineIndex(nextRowIndex);
          measuredVerticalOffset = nextRowInfo != null
              ? nextRowInfo.size -
                  (nextRowInfo.size - nextRowInfo.clippedCornerExtent)
              : nextRowIndexHeight.first;
          measuredVerticalOffset =
              verticalController.offset + measuredVerticalOffset;
        } else {
          final visibleInfoCollection =
              dataGridSettings.container.scrollRows.getVisibleLines();
          final firstBodyVisibleLineIndex =
              visibleInfoCollection.firstBodyVisibleIndex <
                      visibleInfoCollection.length
                  ? visibleInfoCollection[
                          visibleInfoCollection.firstBodyVisibleIndex]
                      .lineIndex
                  : 0;
          if (nextRowIndex < firstBodyVisibleLineIndex) {
            return scrollInViewFromDown(dataGridSettings,
                previousRowIndex: nextRowIndex, needToScrollToMinExtent: false);
          } else {
            measuredVerticalOffset =
                _SelectionHelper.getVerticalCumulativeDistance(
                    dataGridSettings, nextRowIndex);
          }
        }
      }

      _SfDataGridHelper.scrollVertical(
          dataGridSettings, measuredVerticalOffset);
    }
  }

  static void scrollInViewFromDown(_DataGridSettings dataGridSettings,
      {int previousRowIndex = -1, bool needToScrollToMinExtent = false}) {
    var measuredVerticalOffset = 0.0;

    if (dataGridSettings.verticalController != null) {
      final ScrollController verticalController =
          dataGridSettings.verticalController!;

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
          final previousRowIndexHeight = dataGridSettings
              .container.rowHeightsProvider
              .getSize(previousRowIndex, 0);
          final previousRowInfo = dataGridSettings.container.scrollRows
              .getVisibleLineAtLineIndex(previousRowIndex);
          measuredVerticalOffset = previousRowInfo != null
              ? previousRowInfo.size -
                  (previousRowInfo.clippedSize -
                      previousRowInfo.clippedCornerExtent)
              : previousRowIndexHeight.first;
          measuredVerticalOffset =
              verticalController.offset - measuredVerticalOffset;
        } else {
          measuredVerticalOffset = verticalController.offset -
              (verticalController.offset -
                  _SelectionHelper.getVerticalCumulativeDistance(
                      dataGridSettings, previousRowIndex));
        }
      }

      _SfDataGridHelper.scrollVertical(
          dataGridSettings, measuredVerticalOffset);
    }
  }
}
