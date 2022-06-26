import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide DataCell, DataRow;

import '../../grid_common/row_column_index.dart';
import '../../grid_common/scroll_axis.dart';
import '../../grid_common/visible_line_info.dart';
import '../runtime/column.dart';
import '../selection/selection_manager.dart';
import '../sfdatagrid.dart';
import 'datagrid_configuration.dart';
import 'datagrid_helper.dart' as grid_helper;
import 'enums.dart';

/// Get the row index in data grid based provided DataGridRow
int resolveToRowIndex(
    DataGridConfiguration dataGridConfiguration, DataGridRow record) {
  final DataGridRow? rec = effectiveRows(dataGridConfiguration.source)
      .firstWhereOrNull((DataGridRow rec) => rec == record);
  if (rec == null) {
    return -1;
  }

  int recordIndex = effectiveRows(dataGridConfiguration.source).indexOf(rec);

  recordIndex +=
      grid_helper.resolveStartIndexBasedOnPosition(dataGridConfiguration);

  return recordIndex.isNegative ? -1 : recordIndex;
}

/// Helps to get the DataGridRow based on provided row index
DataGridRow? getRecord(DataGridConfiguration dataGridConfiguration, int index) {
  // Restricts the index if it doesn't exist in the `DataGridSource.rows` range.
  if (effectiveRows(dataGridConfiguration.source).isEmpty ||
      index < 0 ||
      index >= effectiveRows(dataGridConfiguration.source).length) {
    return null;
  }

  final DataGridRow record = effectiveRows(dataGridConfiguration.source)[index];
  return record;
}

/// Helps to get the total rows count
int getRecordsCount(DataGridConfiguration dataGridConfiguration) {
  if (effectiveRows(dataGridConfiguration.source).isNotEmpty) {
    return effectiveRows(dataGridConfiguration.source).length;
  } else {
    return 0;
  }
}

/// Helps to get the first navigating row index consider with hidden row
/// in data grid
int getFirstNavigatingRowIndex(DataGridConfiguration dataGridConfiguration) {
  final int index = getFirstRowIndex(dataGridConfiguration);
  const int count = 0;
  for (int start = index; start >= 0; start--) {
    final List<dynamic> hiddenRowInfo =
        dataGridConfiguration.container.rowHeights.getHidden(start, count);
    final bool isHiddenRow = hiddenRowInfo.first as bool;
    if (!isHiddenRow) {
      return start;
    }
  }

  return index;
}

/// Helps to get the last navigating row index consider with hidden row, footer
/// row
int getLastNavigatingRowIndex(DataGridConfiguration dataGridConfiguration) {
  int lastRowIndex = -1;
  const int count = 0;
  final int recordCount = getRecordsCount(dataGridConfiguration);

  if (recordCount == 0) {
    return -1;
  }

  /// From actual row count we have to reduce the length by 1 to adapt the
  /// row index based on SfDataGrid.
  /// Eg : Total rowCount is 30, we will start the row index from 0 of header
  /// in SfDataGrid. The actual last row index of data grid is 29.
  lastRowIndex = dataGridConfiguration.container.rowCount - 1;
  if (dataGridConfiguration.footer != null) {
    lastRowIndex--;
  }
  if (dataGridConfiguration.tableSummaryRows.isNotEmpty) {
    lastRowIndex -= grid_helper.getTableSummaryCount(
        dataGridConfiguration, GridTableSummaryRowPosition.bottom);
  }

  for (int start = lastRowIndex; start >= 0; start--) {
    final List<dynamic> hiddenRowInfo =
        dataGridConfiguration.container.rowHeights.getHidden(start, count);
    final bool isHiddenRow = hiddenRowInfo.first as bool;
    if (!isHiddenRow) {
      return start;
    }
  }

  return lastRowIndex;
}

/// Help to get the first row index in data grid
int getFirstRowIndex(DataGridConfiguration dataGridConfiguration) {
  if (getRecordsCount(dataGridConfiguration) == 0) {
    return -1;
  }

  int index = grid_helper.getHeaderIndex(dataGridConfiguration) + 1;

  if (dataGridConfiguration.tableSummaryRows.isNotEmpty) {
    index += grid_helper.getTableSummaryCount(
        dataGridConfiguration, GridTableSummaryRowPosition.top);
  }

  return index;
}

/// Help to get the last row index in data grid
int getLastRowIndex(DataGridConfiguration dataGridConfiguration) {
  if (getRecordsCount(dataGridConfiguration) == 0) {
    return -1;
  }

  const int count = 0;

  /// From actual row count we have to reduce the length by 1 to adapt the
  /// row index based on SfDataGrid.
  /// Eg : Total rowCount is 30, we will start the row index from 0 of header
  /// in SfDataGrid. The actual last row index of data grid is 29.
  int index = dataGridConfiguration.container.rowCount - 1;
  if (dataGridConfiguration.footer != null) {
    index--;
  }

  if (dataGridConfiguration.tableSummaryRows.isNotEmpty) {
    index -= grid_helper.getTableSummaryCount(
        dataGridConfiguration, GridTableSummaryRowPosition.bottom);
  }

  for (int start = index; start >= 0; start--) {
    final List<dynamic> hiddenRowInfo =
        dataGridConfiguration.container.rowHeights.getHidden(start, count);
    final bool isHiddenRow = hiddenRowInfo.first as bool;
    if (!isHiddenRow) {
      return start;
    }
  }

  return index;
}

/// Help to get the first column index in row
int getFirstCellIndex(DataGridConfiguration dataGridConfiguration) {
  final GridColumn? gridColumn = dataGridConfiguration.columns
      .firstWhereOrNull((GridColumn col) => col.visible);
  if (gridColumn == null) {
    return -1;
  }

  final int firstIndex = dataGridConfiguration.columns.indexOf(gridColumn);
  if (firstIndex < 0) {
    return firstIndex;
  }

  return firstIndex;
}

/// Help to get the last column index in row
int getLastCellIndex(DataGridConfiguration dataGridConfiguration) {
  final GridColumn? lastColumn = dataGridConfiguration.columns.lastWhereOrNull(
      (GridColumn col) => col.visible && col.actualWidth > 0.0);
  if (lastColumn != null) {
    return dataGridConfiguration.columns.indexOf(lastColumn);
  }
  return -1;
}

/// Helps to get the previous row index on PageUp key
int getPreviousPageIndex(DataGridConfiguration dataGridConfiguration) {
  final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
  final int rowIndex = currentCell.rowIndex;
  int lastBodyVisibleIndex = -1;
  final VisibleLinesCollection visibleLines =
      dataGridConfiguration.container.scrollRows.getVisibleLines();
  if (visibleLines.lastBodyVisibleIndex < visibleLines.length) {
    lastBodyVisibleIndex =
        visibleLines[visibleLines.lastBodyVisibleIndex - 1].lineIndex;
  }

  int index = lastBodyVisibleIndex < rowIndex ? lastBodyVisibleIndex : rowIndex;
  index = dataGridConfiguration.container.scrollRows.getPreviousPage(index);
  final int firstRowIndex = getFirstRowIndex(dataGridConfiguration);
  if (index < firstRowIndex || rowIndex < firstRowIndex) {
    return firstRowIndex;
  }

  return index;
}

/// Helps to get the next row index on PageDown key
int getNextPageIndex(DataGridConfiguration dataGridConfiguration) {
  final CurrentCellManager currentCell = dataGridConfiguration.currentCell;
  int rowIndex = currentCell.rowIndex;
  if (rowIndex < getFirstNavigatingRowIndex(dataGridConfiguration)) {
    rowIndex = 0;
  }

  final VisibleLinesCollection visibleLines =
      dataGridConfiguration.container.scrollRows.getVisibleLines();
  int firstBodyVisibleIndex = -1;
  if (visibleLines.firstBodyVisibleIndex < visibleLines.length) {
    firstBodyVisibleIndex =
        visibleLines[visibleLines.firstBodyVisibleIndex].lineIndex;
  }

  int index =
      firstBodyVisibleIndex > rowIndex ? firstBodyVisibleIndex : rowIndex;
  final int lastRowIndex = getLastRowIndex(dataGridConfiguration);
  index = dataGridConfiguration.container.scrollRows.getNextPage(index);
  if (index > getLastNavigatingRowIndex(dataGridConfiguration) &&
      currentCell.rowIndex > lastRowIndex) {
    return currentCell.rowIndex;
  }

  return index = index <= lastRowIndex ? index : lastRowIndex;
}

/// Help to get the previous cell index from current cell index.
int getPreviousColumnIndex(
    DataGridConfiguration dataGridConfiguration, int currentColumnIndex) {
  int previousCellIndex = currentColumnIndex;
  final GridColumn? column =
      getNextGridColumn(dataGridConfiguration, currentColumnIndex - 1, false);
  if (column != null) {
    previousCellIndex = grid_helper.resolveToScrollColumnIndex(
        dataGridConfiguration, dataGridConfiguration.columns.indexOf(column));
  }

  // Need to set column index as -1 to disable navigation since there are no
  // visible columns in the previous columns.
  if (previousCellIndex == currentColumnIndex) {
    previousCellIndex = -1;
  }

  return previousCellIndex;
}

/// Help to get the next cell index from current cell index.
int getNextColumnIndex(
    DataGridConfiguration dataGridConfiguration, int currentColumnIndex) {
  int nextCellIndex = currentColumnIndex;
  final int lastCellIndex = getLastCellIndex(dataGridConfiguration);

  final GridColumn? column =
      getNextGridColumn(dataGridConfiguration, currentColumnIndex + 1, true);
  if (column != null) {
    final int columnIndex = dataGridConfiguration.columns.indexOf(column);
    nextCellIndex = grid_helper.resolveToScrollColumnIndex(
        dataGridConfiguration, columnIndex);
  }

  // Need to set column index to -1 to disable navigation since there are no
  // visible columns in the next columns.
  if (nextCellIndex == currentColumnIndex) {
    nextCellIndex = -1;
  }

  return nextCellIndex >= 0 && nextCellIndex > lastCellIndex
      ? lastCellIndex
      : nextCellIndex;
}

/// Help to get the previous row index from current cell index.
int getPreviousRowIndex(
    DataGridConfiguration dataGridConfiguration, int currentRowIndex) {
  final int lastRowIndex = getLastNavigatingRowIndex(dataGridConfiguration);
  if (currentRowIndex > lastRowIndex) {
    return lastRowIndex;
  }

  final int firstRowIndex = getFirstNavigatingRowIndex(dataGridConfiguration);
  if (currentRowIndex <= firstRowIndex) {
    return firstRowIndex;
  }

  int previousIndex = currentRowIndex;
  previousIndex = dataGridConfiguration.container.scrollRows
      .getPreviousScrollLineIndex(currentRowIndex);
  if (previousIndex == currentRowIndex) {
    previousIndex = previousIndex - 1;
  }

  return previousIndex;
}

/// Help to get the next row index from current cell index.
int getNextRowIndex(
    DataGridConfiguration dataGridConfiguration, int currentRowIndex) {
  final int lastRowIndex = getLastNavigatingRowIndex(dataGridConfiguration);
  if (currentRowIndex >= lastRowIndex) {
    return lastRowIndex;
  }

  final int firstRowIndex = getFirstNavigatingRowIndex(dataGridConfiguration);

  if (currentRowIndex < firstRowIndex) {
    return firstRowIndex;
  }

  if (currentRowIndex >= dataGridConfiguration.container.scrollRows.lineCount) {
    return -1;
  }

  int nextIndex = 0;
  nextIndex = dataGridConfiguration.container.scrollRows
      .getNextScrollLineIndex(currentRowIndex);
  if (nextIndex == currentRowIndex) {
    nextIndex = nextIndex + 1;
  }

  return nextIndex;
}

/// Helps to get the next and previous grid column based on provided column
/// index
/// moveToRight: Consider to check on next column else it will check the
/// previous column
GridColumn? getNextGridColumn(DataGridConfiguration dataGridConfiguration,
    int columnIndex, bool moveToRight) {
  final int resolvedIndex = grid_helper.resolveToGridVisibleColumnIndex(
      dataGridConfiguration, columnIndex);
  if (resolvedIndex < 0 ||
      resolvedIndex >= dataGridConfiguration.columns.length) {
    return null;
  }

  GridColumn? gridColumn = dataGridConfiguration.columns[resolvedIndex];
  if (!gridColumn.visible || gridColumn.actualWidth == 0.0) {
    gridColumn = getNextGridColumn(dataGridConfiguration,
        moveToRight ? columnIndex + 1 : columnIndex - 1, moveToRight);
  }

  return gridColumn;
}

/// Helps to get the cumulative distance of provided row index
double getVerticalCumulativeDistance(
    DataGridConfiguration dataGridConfiguration, int rowIndex) {
  double verticalOffset = 0.0;
  final int headerRowIndex = grid_helper.getHeaderIndex(dataGridConfiguration);
  rowIndex = rowIndex > headerRowIndex ? rowIndex : headerRowIndex + 1;
  final PixelScrollAxis scrollRows =
      dataGridConfiguration.container.scrollRows as PixelScrollAxis;
  verticalOffset = scrollRows.distances!.getCumulatedDistanceAt(rowIndex);
  return verticalOffset;
}

/// Helps to get the cumulative distance of provided column index
double getHorizontalCumulativeDistance(
    DataGridConfiguration dataGridConfiguration, int columnIndex) {
  double horizontalOffset = 0.0;
  final int firstVisibleColumnIndex =
      grid_helper.resolveToStartColumnIndex(dataGridConfiguration);
  columnIndex = columnIndex < firstVisibleColumnIndex
      ? firstVisibleColumnIndex
      : columnIndex;
  final PixelScrollAxis scrollColumns =
      dataGridConfiguration.container.scrollColumns as PixelScrollAxis;
  horizontalOffset =
      scrollColumns.distances!.getCumulatedDistanceAt(columnIndex);
  return horizontalOffset;
}

// ScrollingView Helping API

/// Decide to scroll toward bottom or not based on next row index
/// If next row index not present in view it will return true, else it will
/// return false
bool needToScrollDown(
    DataGridConfiguration dataGridConfiguration, int nextRowIndex) {
  final VisibleLinesCollection visibleLines =
      dataGridConfiguration.container.scrollRows.getVisibleLines();
  if (visibleLines.isEmpty) {
    return false;
  }

  final VisibleLineInfo? nextRowInfo = dataGridConfiguration
      .container.scrollRows
      .getVisibleLineAtLineIndex(nextRowIndex);
  return nextRowInfo == null || nextRowInfo.isClipped;
}

/// Decide to scroll toward top or not based on previous row index
/// If previous row index not present in view it will return true, else it will
/// return false
bool needToScrollUp(
    DataGridConfiguration dataGridConfiguration, int previousRowIndex) {
  final VisibleLinesCollection visibleLineCollection =
      dataGridConfiguration.container.scrollRows.getVisibleLines();
  if (visibleLineCollection.isEmpty) {
    return false;
  }

  final VisibleLineInfo? previousRowLineInfo = dataGridConfiguration
      .container.scrollRows
      .getVisibleLineAtLineIndex(previousRowIndex);
  return previousRowLineInfo == null || previousRowLineInfo.isClipped;
}

/// Decide to scroll toward left or not based on previous cell index
/// If previous cell index not present in view it will return true, else it will
/// return false
bool needToScrollLeft(DataGridConfiguration dataGridConfiguration,
    RowColumnIndex rowColumnIndex) {
  final VisibleLinesCollection visibleLineCollection =
      grid_helper.getVisibleLines(dataGridConfiguration);
  if (visibleLineCollection.isEmpty) {
    return false;
  }

  final VisibleLineInfo? previousCellLineInfo = visibleLineCollection
      .getVisibleLineAtLineIndex(rowColumnIndex.columnIndex);
  return previousCellLineInfo == null || previousCellLineInfo.isClipped;
}

/// Decide to scroll toward right or not based on previous cell index
/// If next cell index not present in view it will return true, else it will
/// return false
bool needToScrollRight(DataGridConfiguration dataGridConfiguration,
    RowColumnIndex rowColumnIndex) {
  final VisibleLinesCollection visibleLineCollection =
      grid_helper.getVisibleLines(dataGridConfiguration);
  if (visibleLineCollection.isEmpty) {
    return false;
  }
  final VisibleLineInfo? nextCellLineInfo = visibleLineCollection
      .getVisibleLineAtLineIndex(rowColumnIndex.columnIndex);
  return nextCellLineInfo == null || nextCellLineInfo.isClipped;
}

/// Perform to scroll the view to left
void scrollInViewFromLeft(DataGridConfiguration dataGridConfiguration,
    {int nextCellIndex = -1, bool needToScrollMaxExtent = false}) {
  if (dataGridConfiguration.horizontalScrollController != null) {
    final ScrollController horizontalController =
        dataGridConfiguration.horizontalScrollController!;
    double measuredHorizontalOffset = 0.0;

    final int lastFrozenColumnIndex =
        grid_helper.getLastFrozenColumnIndex(dataGridConfiguration);

    final int firstFooterFrozenColumnIndex =
        grid_helper.getStartFooterFrozenColumnIndex(dataGridConfiguration);

    if (dataGridConfiguration.frozenColumnsCount > 0 &&
        lastFrozenColumnIndex + 1 == nextCellIndex) {
      measuredHorizontalOffset = horizontalController.position.minScrollExtent;
    } else if (needToScrollMaxExtent ||
        (dataGridConfiguration.footerFrozenColumnsCount > 0 &&
            firstFooterFrozenColumnIndex - 1 == nextCellIndex)) {
      measuredHorizontalOffset = horizontalController.position.maxScrollExtent;
    } else {
      if (dataGridConfiguration.currentCell.columnIndex != -1 &&
          nextCellIndex == dataGridConfiguration.currentCell.columnIndex + 1) {
        final List<dynamic> nextCellIndexHeight = dataGridConfiguration
            .container.columnWidthsProvider
            .getSize(nextCellIndex, 0);
        final VisibleLinesCollection visibleInfoCollection =
            grid_helper.getVisibleLines(dataGridConfiguration);
        final VisibleLineInfo? nextCellInfo =
            visibleInfoCollection.getVisibleLineAtLineIndex(nextCellIndex);
        measuredHorizontalOffset = nextCellInfo != null
            ? dataGridConfiguration.textDirection == TextDirection.rtl
                ? nextCellInfo.clippedSize -
                    (~nextCellInfo.clippedOrigin.toInt())
                : nextCellInfo.size -
                    (nextCellInfo.size - nextCellInfo.clippedCornerExtent)
            : nextCellIndexHeight.first as double;
        measuredHorizontalOffset =
            horizontalController.offset + measuredHorizontalOffset;
      } else {
        final VisibleLinesCollection visibleInfoCollection =
            grid_helper.getVisibleLines(dataGridConfiguration);
        final int firstBodyVisibleLineIndex = visibleInfoCollection
                    .firstBodyVisibleIndex <
                visibleInfoCollection.length
            ? visibleInfoCollection[visibleInfoCollection.firstBodyVisibleIndex]
                .lineIndex
            : 0;
        if (nextCellIndex < firstBodyVisibleLineIndex) {
          scrollInViewFromRight(dataGridConfiguration,
              previousCellIndex: nextCellIndex);
        } else {
          measuredHorizontalOffset = getHorizontalCumulativeDistance(
              dataGridConfiguration, nextCellIndex);
          measuredHorizontalOffset = grid_helper.resolveHorizontalScrollOffset(
              dataGridConfiguration, measuredHorizontalOffset);
          measuredHorizontalOffset =
              horizontalController.offset + measuredHorizontalOffset;
        }
      }
    }

    grid_helper.scrollHorizontal(
        dataGridConfiguration, measuredHorizontalOffset);
  }
}

/// Perform to scroll the view to right
void scrollInViewFromRight(DataGridConfiguration dataGridConfiguration,
    {int previousCellIndex = -1, bool needToScrollToMinExtent = false}) {
  double measuredHorizontalOffset = 0.0;

  if (dataGridConfiguration.horizontalScrollController != null) {
    final ScrollController horizontalController =
        dataGridConfiguration.horizontalScrollController!;

    final int startingFooterFrozenColumnIndex =
        grid_helper.getStartFooterFrozenColumnIndex(dataGridConfiguration);
    final int lastFrozenColumnIndex =
        grid_helper.getLastFrozenColumnIndex(dataGridConfiguration);

    if (dataGridConfiguration.footerFrozenColumnsCount > 0 &&
        startingFooterFrozenColumnIndex - 1 == previousCellIndex) {
      measuredHorizontalOffset = horizontalController.position.maxScrollExtent;
    } else if (needToScrollToMinExtent ||
        (dataGridConfiguration.frozenColumnsCount > 0 &&
            lastFrozenColumnIndex + 1 == previousCellIndex)) {
      measuredHorizontalOffset = horizontalController.position.minScrollExtent;
    } else {
      if (dataGridConfiguration.currentCell.columnIndex != -1 &&
          previousCellIndex ==
              dataGridConfiguration.currentCell.columnIndex - 1) {
        final List<dynamic> previousCellIndexWidth = dataGridConfiguration
            .container.columnWidthsProvider
            .getSize(previousCellIndex, 0);
        final VisibleLinesCollection visibleInfoCollection =
            grid_helper.getVisibleLines(dataGridConfiguration);
        final VisibleLineInfo? previousCellInfo =
            visibleInfoCollection.getVisibleLineAtLineIndex(previousCellIndex);
        measuredHorizontalOffset = previousCellInfo != null
            ? previousCellInfo.size -
                (previousCellInfo.clippedSize -
                    previousCellInfo.clippedCornerExtent)
            : previousCellIndexWidth.first as double;
        measuredHorizontalOffset =
            horizontalController.offset - measuredHorizontalOffset;
      } else {
        measuredHorizontalOffset = getHorizontalCumulativeDistance(
            dataGridConfiguration, previousCellIndex);
        measuredHorizontalOffset = grid_helper.resolveHorizontalScrollOffset(
            dataGridConfiguration, measuredHorizontalOffset);
        measuredHorizontalOffset = horizontalController.offset -
            (horizontalController.offset - measuredHorizontalOffset);
      }
    }

    grid_helper.scrollHorizontal(
        dataGridConfiguration, measuredHorizontalOffset);
  }
}

/// Perform to scroll the view to top
void scrollInViewFromTop(DataGridConfiguration dataGridConfiguration,
    {int nextRowIndex = -1, bool needToScrollToMaxExtent = false}) {
  double measuredVerticalOffset = 0.0;

  if (dataGridConfiguration.verticalScrollController != null) {
    final ScrollController verticalController =
        dataGridConfiguration.verticalScrollController!;

    if (dataGridConfiguration.frozenRowsCount > 0 &&
        grid_helper.getLastFrozenRowIndex(dataGridConfiguration) + 1 ==
            nextRowIndex) {
      measuredVerticalOffset = verticalController.position.minScrollExtent;
    } else if (needToScrollToMaxExtent) {
      measuredVerticalOffset = verticalController.position.maxScrollExtent;
    } else {
      if (dataGridConfiguration.currentCell.rowIndex != -1 &&
          nextRowIndex == dataGridConfiguration.currentCell.rowIndex + 1) {
        final List<dynamic> nextRowIndexHeight = dataGridConfiguration
            .container.rowHeightsProvider
            .getSize(nextRowIndex, 0);
        final VisibleLineInfo? nextRowInfo = dataGridConfiguration
            .container.scrollRows
            .getVisibleLineAtLineIndex(nextRowIndex);
        measuredVerticalOffset = nextRowInfo != null
            ? nextRowInfo.size -
                (nextRowInfo.size - nextRowInfo.clippedCornerExtent)
            : nextRowIndexHeight.first as double;
        measuredVerticalOffset =
            verticalController.offset + measuredVerticalOffset;
      } else {
        final VisibleLinesCollection visibleInfoCollection =
            dataGridConfiguration.container.scrollRows.getVisibleLines();
        final int firstBodyVisibleLineIndex = visibleInfoCollection
                    .firstBodyVisibleIndex <
                visibleInfoCollection.length
            ? visibleInfoCollection[visibleInfoCollection.firstBodyVisibleIndex]
                .lineIndex
            : 0;
        if (nextRowIndex < firstBodyVisibleLineIndex) {
          scrollInViewFromDown(dataGridConfiguration,
              previousRowIndex: nextRowIndex);
        } else {
          measuredVerticalOffset = getVerticalCumulativeDistance(
              dataGridConfiguration, nextRowIndex);
          measuredVerticalOffset = grid_helper.resolveVerticalScrollOffset(
              dataGridConfiguration, measuredVerticalOffset);
        }
      }
    }

    grid_helper.scrollVertical(dataGridConfiguration, measuredVerticalOffset);
  }
}

/// Perform to scroll the view to down
void scrollInViewFromDown(DataGridConfiguration dataGridConfiguration,
    {int previousRowIndex = -1, bool needToScrollToMinExtent = false}) {
  double measuredVerticalOffset = 0.0;

  if (dataGridConfiguration.verticalScrollController != null) {
    final ScrollController verticalController =
        dataGridConfiguration.verticalScrollController!;

    if (dataGridConfiguration.footerFrozenRowsCount > 0 &&
        grid_helper.getStartFooterFrozenRowIndex(dataGridConfiguration) - 1 ==
            previousRowIndex) {
      measuredVerticalOffset = verticalController.position.maxScrollExtent;
    } else if (needToScrollToMinExtent) {
      measuredVerticalOffset = verticalController.position.minScrollExtent;
    } else {
      if (dataGridConfiguration.currentCell.rowIndex != -1 &&
          previousRowIndex == dataGridConfiguration.currentCell.rowIndex - 1) {
        final List<dynamic> previousRowIndexHeight = dataGridConfiguration
            .container.rowHeightsProvider
            .getSize(previousRowIndex, 0);
        final VisibleLineInfo? previousRowInfo = dataGridConfiguration
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
        measuredVerticalOffset = getVerticalCumulativeDistance(
            dataGridConfiguration, previousRowIndex);
        measuredVerticalOffset = grid_helper.resolveVerticalScrollOffset(
            dataGridConfiguration, measuredVerticalOffset);
        measuredVerticalOffset = verticalController.offset -
            (verticalController.offset - measuredVerticalOffset);
      }
    }

    grid_helper.scrollVertical(dataGridConfiguration, measuredVerticalOffset);
  }
}
