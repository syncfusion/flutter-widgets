import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide DataCell, DataRow;
import 'package:syncfusion_flutter_core/localizations.dart';

import '../../grid_common/row_column_index.dart';
import '../../grid_common/scroll_axis.dart';
import '../../grid_common/visible_line_info.dart';
import '../runtime/column.dart';
import '../sfdatagrid.dart';
import 'datagrid_configuration.dart';
import 'enums.dart';
import 'selection_helper.dart' as selection_helper;

//----------------------------------------------------------------------------//
//------------------DataGridIndex-Resolving-Helpers---------------------------//
//----------------------------------------------------------------------------//

/// Get the header index in [SfDataGrid].
int getHeaderIndex(DataGridConfiguration dataGridConfiguration) {
  int headerIndex = dataGridConfiguration.headerLineCount - 1;

  // Removes the top table summary rows from the headerLineCount to resolve the
  // actual column header row index.
  if (dataGridConfiguration.tableSummaryRows.isNotEmpty) {
    headerIndex -= getTableSummaryCount(
        dataGridConfiguration, GridTableSummaryRowPosition.top);
  }

  return headerIndex < 0 ? 0 : headerIndex;
}

/// Helps to find the column index based on [SfDataGrid.columns] count
/// In this we will not include the  column like, indent column, row
/// header etc
int resolveToGridVisibleColumnIndex(
    DataGridConfiguration dataGridConfiguration, int columnIndex) {
  if (columnIndex >= dataGridConfiguration.container.columnCount) {
    return -1;
  }

  return columnIndex;
}

/// Helps to resolve the column index based on the [DataGridRowAdapter.cells]
/// count when indent cell, row header, [SfDataGrid.showCheckboxColumn] are enabled.
int resolveToDataGridRowAdapterCellIndex(
    DataGridConfiguration dataGridConfiguration, int columnIndex) {
  if (columnIndex >= dataGridConfiguration.container.columnCount) {
    return -1;
  }

  if (columnIndex == 0) {
    return columnIndex;
  } else {
    columnIndex -= dataGridConfiguration.showCheckboxColumn ? 1 : 0;
    return columnIndex;
  }
}

/// Help to resolve the record index to [SfDataGrid] position row index.
int resolveToRowIndex(
    DataGridConfiguration dataGridConfiguration, int rowIndex) {
  if (rowIndex < 0) {
    return -1;
  }

  rowIndex = rowIndex + resolveStartIndexBasedOnPosition(dataGridConfiguration);
  if (rowIndex >= 0 && rowIndex <= dataGridConfiguration.container.rowCount) {
    return rowIndex;
  } else {
    return -1;
  }
}

/// Help to get the [SfDataGrid] swipeMaxOffset when it changing at runtime
double getSwipeMaxOffset(DataGridConfiguration dataGridConfiguration) {
  return dataGridConfiguration.effectiveSwipeMaxOffset ??
      dataGridConfiguration.swipeMaxOffset;
}

/// Help to resolve the [SfDataGrid] position row index to record index.
int resolveToRecordIndex(
    DataGridConfiguration dataGridConfiguration, int rowIndex) {
  if (rowIndex < 0) {
    return -1;
  }

  if (rowIndex == 0) {
    return 0;
  }

  rowIndex = rowIndex - resolveStartIndexBasedOnPosition(dataGridConfiguration);
  if (rowIndex >= 0 &&
      rowIndex <= effectiveRows(dataGridConfiguration.source).length - 1) {
    return rowIndex;
  } else {
    return -1;
  }
}

/// Helps to resolve the [SfDataGrid] row column index to record [RowColumnIndex].
RowColumnIndex resolveToRecordRowColumnIndex(
    DataGridConfiguration dataGridConfiguration,
    RowColumnIndex rowColumnIndex) {
  final int rowIndex =
      resolveToRecordIndex(dataGridConfiguration, rowColumnIndex.rowIndex);
  final int columnIndex = resolveToGridVisibleColumnIndex(
      dataGridConfiguration, rowColumnIndex.columnIndex);
  return RowColumnIndex(rowIndex, columnIndex);
}

/// Helps to resolve the row and column index according to DataGrid alignment
RowColumnIndex resolveToRowColumnIndex(
    DataGridConfiguration dataGridConfiguration,
    RowColumnIndex rowColumnIndex) {
  final int rowIndex =
      resolveToRowIndex(dataGridConfiguration, rowColumnIndex.rowIndex);
  final int columnIndex = resolveToGridVisibleColumnIndex(
      dataGridConfiguration, rowColumnIndex.columnIndex);
  return RowColumnIndex(rowIndex, columnIndex);
}

/// Helps to find the exact starting scrolling row index.
int resolveStartIndexBasedOnPosition(
    DataGridConfiguration dataGridConfiguration) {
  return dataGridConfiguration.headerLineCount;
}

/// Helps to find the actual starting scrolling column index
/// Its ignore the indent column, row header and provide the actual staring
/// column index
int resolveToStartColumnIndex(DataGridConfiguration dataGridConfiguration) => 0;

/// Helps to resolve the provided column index based on [SfDataGrid] column
/// order. Its ignore the indent column, row header and provide the exact
/// column index
int resolveToScrollColumnIndex(
        DataGridConfiguration dataGridConfiguration, int gridColumnIndex) =>
    gridColumnIndex;

/// Get the last index of frozen column in left side view, it will
/// consider the row header,indent column and frozen column
int getLastFrozenColumnIndex(DataGridConfiguration dataGridConfiguration) {
  if (dataGridConfiguration.frozenColumnsCount <= 0) {
    return -1;
  }

  final int startScrollColumnIndex =
      dataGridConfiguration.container.frozenColumns - 1;
  return startScrollColumnIndex.isFinite ? startScrollColumnIndex : -1;
}

/// Get the  starting index of frozen column in right side view, it
/// will consider the right frozen pane
int getStartFooterFrozenColumnIndex(
    DataGridConfiguration dataGridConfiguration) {
  final int columnsCount = dataGridConfiguration.container.columnCount;
  if (columnsCount <= 0 ||
      dataGridConfiguration.footerFrozenColumnsCount <= 0) {
    return -1;
  }

  return columnsCount - dataGridConfiguration.container.footerFrozenColumns;
}

/// Get the last frozen row index in top of data grid, it
/// will consider the stacked header, header and top frozen pane
int getLastFrozenRowIndex(DataGridConfiguration dataGridConfiguration) {
  if (dataGridConfiguration.frozenRowsCount <= 0) {
    return -1;
  }

  final int rowIndex = dataGridConfiguration.container.frozenRows - 1;
  return rowIndex.isFinite ? rowIndex : -1;
}

/// Get the starting frozen row index in bottom of data grid, it
/// will consider the bottom table summary and bottom frozen pane
int getStartFooterFrozenRowIndex(DataGridConfiguration dataGridConfiguration) {
  final int rowCount = dataGridConfiguration.container.rowCount;
  if (rowCount <= 0 || dataGridConfiguration.footerFrozenRowsCount <= 0) {
    return -1;
  }

  final int rowIndex =
      rowCount - dataGridConfiguration.container.footerFrozenRows;
  return rowIndex.isFinite ? rowIndex : -1;
}

//---------------------- Footer view helper methods ------------------------//

/// Checks whether the row is a footer widget row or not.
bool isFooterWidgetRow(
    int rowIndex, DataGridConfiguration dataGridConfiguration) {
  final int bottomSummariesCount = getTableSummaryCount(
      dataGridConfiguration, GridTableSummaryRowPosition.bottom);
  final int footerIndex =
      dataGridConfiguration.container.rowCount - bottomSummariesCount - 1;
  return dataGridConfiguration.footer != null && rowIndex == footerIndex;
}

/// Returns the row index of a footer widget row.
int getFooterViewRowIndex(DataGridConfiguration dataGridConfiguration) {
  final int bottomSummaryRowsCount = getTableSummaryCount(
      dataGridConfiguration, GridTableSummaryRowPosition.bottom);
  return dataGridConfiguration.container.rowCount - bottomSummaryRowsCount - 1;
}

//-------------------- Table summary row helper methods ----------------------//

/// Checks whether the givem row is a top summary row or not.
bool isTopTableSummaryRow(
    DataGridConfiguration dataGridConfiguration, int rowIndex) {
  if (dataGridConfiguration.tableSummaryRows.isNotEmpty &&
      rowIndex < dataGridConfiguration.headerLineCount) {
    final int tableSummaryStartIndex =
        dataGridConfiguration.stackedHeaderRows.length + 1;
    final int tableSummaryEndIndex = tableSummaryStartIndex +
        getTableSummaryCount(
            dataGridConfiguration, GridTableSummaryRowPosition.top);
    return rowIndex >= tableSummaryStartIndex &&
        rowIndex < tableSummaryEndIndex;
  }
  return false;
}

/// Checks whether the given row is a bottom summary row or not.
bool isBottomTableSummaryRow(
    DataGridConfiguration dataGridConfiguration, int rowIndex) {
  if (dataGridConfiguration.tableSummaryRows.isNotEmpty) {
    final int tableSummaryEndIndex = dataGridConfiguration.container.rowCount;
    final int tableSummaryStartIndex = tableSummaryEndIndex -
        getTableSummaryCount(
            dataGridConfiguration, GridTableSummaryRowPosition.bottom);
    return rowIndex >= tableSummaryStartIndex &&
        rowIndex < tableSummaryEndIndex;
  }
  return false;
}

/// Checks whether the given row index is a table summary row or not.
bool isTableSummaryIndex(
    DataGridConfiguration dataGridConfiguration, int rowIndex) {
  return isTopTableSummaryRow(dataGridConfiguration, rowIndex) ||
      isBottomTableSummaryRow(dataGridConfiguration, rowIndex);
}

/// Checks whether the row index is a start index of a bottom summary rows or not.
int getStartBottomSummaryRowIndex(DataGridConfiguration dataGridConfiguration) {
  final int bottomSummariesCount = getTableSummaryCount(
      dataGridConfiguration, GridTableSummaryRowPosition.bottom);
  return dataGridConfiguration.container.rowCount - bottomSummariesCount;
}

/// Returns the table summary count based on position.
int getTableSummaryCount(DataGridConfiguration dataGridConfiguration,
    GridTableSummaryRowPosition position) {
  if (dataGridConfiguration.tableSummaryRows.isNotEmpty) {
    return dataGridConfiguration.tableSummaryRows
        .where((GridTableSummaryRow row) => row.position == position)
        .length;
  }
  return 0;
}

/// Returns the title column span to the table summary column.
int getSummaryTitleColumnSpan(DataGridConfiguration dataGridConfiguration,
    GridTableSummaryRow tableSummaryRow) {
  int titleSpan = dataGridConfiguration.frozenColumnsCount > 0
      ? min(dataGridConfiguration.frozenColumnsCount,
          tableSummaryRow.titleColumnSpan)
      : tableSummaryRow.titleColumnSpan;
  titleSpan = min(titleSpan, dataGridConfiguration.container.columnCount);
  return titleSpan;
}

/// Returns the span count for the table summary column.
int getSummaryColumnSpan(DataGridConfiguration dataGridConfiguration, int index,
    RowType rowType, GridTableSummaryRow? tableSummaryRow) {
  int span = 0;
  final int columnCount = dataGridConfiguration.container.columnCount;
  index = resolveToScrollColumnIndex(dataGridConfiguration, index);
  if (rowType == RowType.tableSummaryRow) {
    if (tableSummaryRow != null) {
      final int titleSpan =
          getSummaryTitleColumnSpan(dataGridConfiguration, tableSummaryRow);
      if (titleSpan > 0 && index < titleSpan) {
        span = titleSpan - 1;
      }
    }
  } else {
    span = columnCount - 1;
  }
  return span;
}

/// Helps to get the table summary row for the given rowIndex from the
/// `SfDataGrid.tableSummaryRows` collection.
GridTableSummaryRow? getTableSummaryRow(
    DataGridConfiguration dataGridConfiguration,
    int rowIndex,
    GridTableSummaryRowPosition position) {
  GridTableSummaryRow getSummaryRowByPosition(
      GridTableSummaryRowPosition position, int index) {
    final List<GridTableSummaryRow> summaryRows = dataGridConfiguration
        .tableSummaryRows
        .where((GridTableSummaryRow row) => row.position == position)
        .toList();
    return summaryRows[index];
  }

  late int currentSummaryRowIndex;
  if (position == GridTableSummaryRowPosition.bottom) {
    final int startTableSummaryIndex =
        dataGridConfiguration.container.rowCount -
            getTableSummaryCount(
                dataGridConfiguration, GridTableSummaryRowPosition.bottom);
    currentSummaryRowIndex = rowIndex - startTableSummaryIndex;
  } else if (position == GridTableSummaryRowPosition.top) {
    final int startTableSummaryIndex =
        getHeaderIndex(dataGridConfiguration) + 1;
    currentSummaryRowIndex = rowIndex - startTableSummaryIndex;
  }
  return getSummaryRowByPosition(position, currentSummaryRowIndex);
}

/// Calculates the summary value for the given summary column based on the
/// summary type.
String getSummaryValue(
    GridSummaryColumn summaryColumn, List<DataGridRow> rows) {
  switch (summaryColumn.summaryType) {
    case GridSummaryType.sum:
      return calculateSum(rows, summaryColumn);
    case GridSummaryType.maximum:
      return calculateMaximum(rows, summaryColumn);
    case GridSummaryType.minimum:
      return calculateMinimum(rows, summaryColumn);
    case GridSummaryType.average:
      return calculateAverage(rows, summaryColumn);
    case GridSummaryType.count:
      return rows.length.toString();
  }
}

/// Calculates the sum value for the given summary column.
String calculateSum(List<DataGridRow> rows, GridSummaryColumn summaryColumn) {
  num? sum;
  bool isNumericColumn = false;
  for (final DataGridRow row in rows) {
    final DataGridCell? cell = row.getCells().firstWhereOrNull(
        (DataGridCell element) =>
            element.columnName == summaryColumn.columnName);
    if (cell != null && cell.value != null) {
      if (!isNumericColumn && cell.value is! num) {
        break;
      }

      sum ??= 0;
      sum += cell.value;

      if (!isNumericColumn) {
        isNumericColumn = true;
      }
    }
  }
  return sum?.toString() ?? '';
}

/// Calculates the minimum value for the given summary column.
String calculateMinimum(
    List<DataGridRow> rows, GridSummaryColumn summaryColumn) {
  dynamic minimum;
  bool isNumericColumn = false;
  for (final DataGridRow row in rows) {
    final DataGridCell? cell = row.getCells().firstWhereOrNull(
        (DataGridCell element) =>
            element.columnName == summaryColumn.columnName);
    if (cell != null && cell.value != null) {
      if (!isNumericColumn && cell.value is! num) {
        break;
      }

      minimum ??= cell.value;
      minimum = min<num>(minimum, cell.value);

      if (!isNumericColumn) {
        isNumericColumn = true;
      }
    }
  }

  return minimum?.toString() ?? '';
}

/// Calculates the maximum value for the given summary column.
String calculateMaximum(
    List<DataGridRow> rows, GridSummaryColumn summaryColumn) {
  dynamic maximum;
  bool isNumericColumn = false;
  for (final DataGridRow row in rows) {
    final DataGridCell? cell = row.getCells().firstWhereOrNull(
        (DataGridCell element) =>
            element.columnName == summaryColumn.columnName);
    if (cell != null && cell.value != null) {
      if (!isNumericColumn && cell.value is! num) {
        break;
      }

      maximum ??= cell.value;
      maximum = max<num>(maximum, cell.value);

      if (!isNumericColumn) {
        isNumericColumn = true;
      }
    }
  }

  return maximum?.toString() ?? '';
}

/// Calculates the average value for the given summary column.
String calculateAverage(
    List<DataGridRow> rows, GridSummaryColumn summaryColumn) {
  num? sum;
  int count = 0;
  bool isNumericColumn = false;
  for (final DataGridRow row in rows) {
    final DataGridCell? cell = row.getCells().firstWhereOrNull(
        (DataGridCell element) =>
            element.columnName == summaryColumn.columnName);

    if (cell != null && cell.value != null) {
      if (!isNumericColumn && cell.value is! num) {
        break;
      }

      sum ??= 0;
      sum += cell.value;
      count++;

      if (!isNumericColumn) {
        isNumericColumn = true;
      }
    }
  }
  return sum != null ? (sum / count).toString() : '';
}

//--------------------- Filtering helper methods ------------------------//

/// Compare the AND logical operator for the filtering support.
bool compareAnd(bool? a, bool b) {
  return (a == null || a) ? b : a;
}

/// Compare the OR logical operator for the filtering support.
bool compareOr(bool? a, bool b) {
  return (a != null && a) || b;
}

/// Compare the old and new comparer values based on `predicateType`.
bool compare(bool? comparerValue, bool result, FilterOperator predicateType) {
  return predicateType == FilterOperator.or
      ? compareOr(comparerValue, result)
      : compareAnd(comparerValue, result);
}

/// Checkes whether the cell value and the filter value is equal or not.
bool compareEquals(FilterCondition condition, Object? cellValue) {
  // To handle the null value.
  if (condition.value == null && cellValue == null) {
    return true;
  }

  // To handle the null and empty values.
  if ((condition.value == null && cellValue != null) ||
      (condition.value != null && cellValue == null)) {
    return false;
  }

  if (cellValue is String ||
      condition.filterBehavior == FilterBehavior.stringDataType) {
    return _compareByType(condition, cellValue, 'equals');
  }

  final int? value = _getCompareValue(cellValue, condition.value);
  return value != null && value == 0;
}

/// Checkes whether the filter value contains in any cell value or not.
bool compareContains(FilterCondition condition, Object? cellValue) {
  return _compareByType(condition, cellValue, 'contains');
}

/// Checkes whether the filter value begins with any cell value.
bool compareBeginsWith(FilterCondition condition, Object? cellValue) {
  return _compareByType(condition, cellValue, 'startsWidth');
}

/// Checkes whether the filter value ends with any cell value.
bool compareEndsWith(FilterCondition condition, Object? cellValue) {
  return _compareByType(condition, cellValue, 'endsWidth');
}

bool _compareByType(FilterCondition condition, Object? cellValue, String type) {
  String displayText = cellValue?.toString() ?? '';
  String filterText = condition.value?.toString() ?? '';
  if (!condition.isCaseSensitive) {
    filterText = filterText.toLowerCase();
    displayText = displayText.toLowerCase();
  }

  switch (type) {
    case 'contains':
      return displayText.contains(filterText);
    case 'startsWidth':
      return displayText.startsWith(filterText);
    case 'endsWidth':
      return displayText.endsWith(filterText);
    case 'equals':
      return displayText == filterText;
    default:
      return false;
  }
}

/// Checkes whether any cell has greater value than the filter value.
bool compareGreaterThan(FilterCondition condition, Object? cellValue,
    [bool checkEqual = false]) {
  if (condition.value == null || cellValue == null) {
    return false;
  }

  final int? value = _getCompareValue(cellValue, condition.value);
  if (value != null) {
    return checkEqual ? (value == 0 || value == 1) : value == 1;
  }

  return false;
}

/// Checkes whether any cell has less value than the filter value.
bool compareLessThan(FilterCondition condition, Object? cellValue,
    [bool checkEqual = false]) {
  if (condition.value == null || cellValue == null) {
    return false;
  }

  final int? value = _getCompareValue(cellValue, condition.value);
  if (value != null) {
    return checkEqual ? (value == 0 || value == -1) : value == -1;
  }

  return false;
}

int? _getCompareValue(Object? cellValue, Object? filterValue) {
  if (cellValue == null || filterValue == null) {
    return null;
  }

  if (cellValue is num) {
    return cellValue.compareTo(filterValue as num);
  } else if (cellValue is DateTime) {
    return cellValue.compareTo(filterValue as DateTime);
  }
  return null;
}

/// Gets the advanced filter name.
String getFilterTileText(
    SfLocalizations localizations, AdvancedFilterType type) {
  switch (type) {
    case AdvancedFilterType.text:
      return localizations.textFiltersDataGridFilteringLabel;
    case AdvancedFilterType.numeric:
      return localizations.numberFiltersDataGridFilteringLabel;
    case AdvancedFilterType.date:
      return localizations.dateFiltersDataGridFilteringLabel;
  }
}

/// Returns the Sort button text based on the filter type.
String getSortButtonText(
    SfLocalizations localizations, bool isAscending, AdvancedFilterType type) {
  switch (type) {
    case AdvancedFilterType.text:
      return isAscending
          ? localizations.sortAToZDataGridFilteringLabel
          : localizations.sortZToADataGridFilteringLabel;
    case AdvancedFilterType.numeric:
      return isAscending
          ? localizations.sortSmallestToLargestDataGridFilteringLabel
          : localizations.sortLargestToSmallestDataGridFilteringLabel;
    case AdvancedFilterType.date:
      return isAscending
          ? localizations.sortOldestToNewestDataGridFilteringLabel
          : localizations.sortNewestToOldestDataGridFilteringLabel;
  }
}

/// Returns the `FilterType` based on the given value.
FilterType getFilterType(
    DataGridConfiguration dataGridConfiguration, String value) {
  bool isEqual(String labelValue) {
    return labelValue == value;
  }

  final SfLocalizations localizations = dataGridConfiguration.localizations;

  if (isEqual(localizations.equalsDataGridFilteringLabel) ||
      isEqual(localizations.emptyDataGridFilteringLabel) ||
      isEqual(localizations.nullDataGridFilteringLabel)) {
    return FilterType.equals;
  } else if (isEqual(localizations.doesNotEqualDataGridFilteringLabel) ||
      isEqual(localizations.notEmptyDataGridFilteringLabel) ||
      isEqual(localizations.notNullDataGridFilteringLabel)) {
    return FilterType.notEqual;
  } else if (isEqual(localizations.beginsWithDataGridFilteringLabel)) {
    return FilterType.beginsWith;
  } else if (isEqual(localizations.doesNotBeginWithDataGridFilteringLabel)) {
    return FilterType.doesNotBeginWith;
  } else if (isEqual(localizations.endsWithDataGridFilteringLabel)) {
    return FilterType.endsWith;
  } else if (isEqual(localizations.doesNotEndWithDataGridFilteringLabel)) {
    return FilterType.doesNotEndsWith;
  } else if (isEqual(localizations.containsDataGridFilteringLabel)) {
    return FilterType.contains;
  } else if (isEqual(localizations.doesNotContainDataGridFilteringLabel)) {
    return FilterType.doesNotContain;
  } else if (isEqual(localizations.lessThanDataGridFilteringLabel) ||
      isEqual(localizations.beforeDataGridFilteringLabel)) {
    return FilterType.lessThan;
  } else if (isEqual(localizations.beforeOrEqualDataGridFilteringLabel) ||
      isEqual(localizations.lessThanOrEqualDataGridFilteringLabel)) {
    return FilterType.lessThanOrEqual;
  } else if (isEqual(localizations.greaterThanDataGridFilteringLabel) ||
      isEqual(localizations.afterDataGridFilteringLabel)) {
    return FilterType.greaterThan;
  } else if (isEqual(localizations.greaterThanOrEqualDataGridFilteringLabel) ||
      isEqual(localizations.afterOrEqualDataGridFilteringLabel)) {
    return FilterType.greaterThanOrEqual;
  }
  return FilterType.equals;
}

/// Gets the name of the given `FilterType`.
String getFilterName(DataGridConfiguration dataGridConfiguration,
    FilterType type, Object? value) {
  final SfLocalizations localizations = dataGridConfiguration.localizations;
  switch (type) {
    case FilterType.equals:
      if (value == null) {
        return localizations.nullDataGridFilteringLabel;
      } else if (value is String && value.isEmpty) {
        return localizations.emptyDataGridFilteringLabel;
      } else {
        return localizations.equalsDataGridFilteringLabel;
      }
    case FilterType.notEqual:
      if (value == null) {
        return localizations.notNullDataGridFilteringLabel;
      } else if (value is String && value.isEmpty) {
        return localizations.notEmptyDataGridFilteringLabel;
      } else {
        return localizations.doesNotEqualDataGridFilteringLabel;
      }
    case FilterType.beginsWith:
      return localizations.beginsWithDataGridFilteringLabel;
    case FilterType.doesNotBeginWith:
      return localizations.doesNotBeginWithDataGridFilteringLabel;
    case FilterType.endsWith:
      return localizations.endsWithDataGridFilteringLabel;
    case FilterType.doesNotEndsWith:
      return localizations.doesNotEndWithDataGridFilteringLabel;
    case FilterType.contains:
      return localizations.containsDataGridFilteringLabel;
    case FilterType.doesNotContain:
      return localizations.doesNotContainDataGridFilteringLabel;
    case FilterType.lessThan:
      if (value is DateTime) {
        return localizations.beforeDataGridFilteringLabel;
      }
      return localizations.lessThanDataGridFilteringLabel;
    case FilterType.lessThanOrEqual:
      if (value is DateTime) {
        return localizations.beforeOrEqualDataGridFilteringLabel;
      }
      return localizations.lessThanOrEqualDataGridFilteringLabel;
    case FilterType.greaterThan:
      if (value is DateTime) {
        return localizations.afterDataGridFilteringLabel;
      }
      return localizations.greaterThanDataGridFilteringLabel;
    case FilterType.greaterThanOrEqual:
      if (value is DateTime) {
        return localizations.afterOrEqualDataGridFilteringLabel;
      }
      return localizations.greaterThanOrEqualDataGridFilteringLabel;
  }
}

//--------------------DataGridIndex-Resolving-Helpers-End---------------------//

//----------------------------------------------------------------------------//
//--------------------- StackedHeader Helper Method --------------------------//
//----------------------------------------------------------------------------//

/// Helps to get the sequence of spanned cell indexes
List<int> getChildSequence(DataGridConfiguration dataGridConfiguration,
    StackedHeaderCell? column, int rowIndex) {
  final List<int> childSequenceNo = <int>[];

  if (column != null && column.columnNames.isNotEmpty) {
    for (final String child in column.columnNames) {
      final List<GridColumn> columns = dataGridConfiguration.columns;
      for (int i = 0; i < columns.length; ++i) {
        if (columns[i].columnName == child) {
          childSequenceNo.add(i);
          break;
        }
      }
    }
  }
  return childSequenceNo;
}

/// Helps to find the total count of row spanned.
int getRowSpan(DataGridConfiguration dataGridConfiguration, int rowIndex,
    int columnIndex, bool isStackedHeader,
    {String? mappingName, StackedHeaderCell? stackedHeaderCell}) {
  int rowSpan = 0;
  int startIndex = 0;
  int endIndex = 0;
  if (isStackedHeader && stackedHeaderCell != null) {
    final List<List<int>> spannedColumns =
        getConsecutiveRanges(getChildColumnIndexes(stackedHeaderCell));
    final List<int>? spannedColumn = spannedColumns
        .singleWhereOrNull((List<int> element) => element.first == columnIndex);
    if (spannedColumn != null) {
      startIndex = spannedColumn.reduce(min);
      endIndex = startIndex + spannedColumn.length - 1;
    }
    rowIndex = rowIndex - 1;
  } else {
    if (rowIndex >= dataGridConfiguration.stackedHeaderRows.length) {
      return rowSpan;
    }
  }

  while (rowIndex >= 0) {
    final StackedHeaderRow stackedHeaderRow =
        dataGridConfiguration.stackedHeaderRows[rowIndex];
    for (final StackedHeaderCell stackedColumn in stackedHeaderRow.cells) {
      if (isStackedHeader) {
        final List<List<int>> columnsRange =
            getConsecutiveRanges(getChildColumnIndexes(stackedColumn));
        for (final List<int> column in columnsRange) {
          if ((startIndex >= column.first && startIndex <= column.last) ||
              (endIndex >= column.first && endIndex <= column.last)) {
            return rowSpan;
          }
        }
      } else if (stackedColumn.columnNames.isNotEmpty) {
        final List<String> children = stackedColumn.columnNames;
        for (int child = 0; child < children.length; child++) {
          if (children[child] == mappingName) {
            return rowSpan;
          }
        }
      }
    }

    rowSpan += 1;
    rowIndex -= 1;
  }

  return rowSpan;
}

/// Help to resolve the child column indexes to consecutive range
List<List<int>> getConsecutiveRanges(List<int> columnsIndex) {
  int endIndex = 1;
  final List<List<int>> list = <List<int>>[];
  if (columnsIndex.isEmpty) {
    return list;
  }
  for (int i = 1; i <= columnsIndex.length; i++) {
    if (i == columnsIndex.length ||
        columnsIndex[i] - columnsIndex[i - 1] != 1) {
      if (endIndex == 1) {
        list.add(columnsIndex.sublist(i - endIndex, (i - endIndex) + 1));
      } else {
        list.add(columnsIndex.sublist(i - endIndex, i));
      }
      endIndex = 1;
    } else {
      endIndex++;
    }
  }
  return list;
}

//------------------------ StackedHeader-Helper-End --------------------------//

//----------------------------------------------------------------------------//
//--------------------- DataGrid Helper Method -------------------------------//
//----------------------------------------------------------------------------//

/// Get the visible line based on view size and scroll offset.
/// Based on the [TextDirection] it will return visible lines info.
VisibleLinesCollection getVisibleLines(
    DataGridConfiguration dataGridConfiguration) {
  if (dataGridConfiguration.textDirection == TextDirection.rtl) {
    dataGridConfiguration.container.scrollColumns.markDirty();
  }

  return dataGridConfiguration.container.scrollColumns.getVisibleLines(
      dataGridConfiguration.textDirection == TextDirection.rtl);
}

/// Helps to scroll the [SfDataGrid] vertically.
/// [canAnimate]: decide to apply animation on scrolling or not.
Future<void> scrollVertical(
    DataGridConfiguration dataGridConfiguration, double verticalOffset,
    [bool canAnimate = false]) async {
  final ScrollController? verticalController =
      dataGridConfiguration.verticalScrollController;

  if (verticalController == null || !verticalController.hasClients) {
    return;
  }

  verticalOffset = verticalOffset > verticalController.position.maxScrollExtent
      ? verticalController.position.maxScrollExtent
      : verticalOffset;
  verticalOffset = verticalOffset.isNegative || verticalOffset == 0.0
      ? verticalController.position.minScrollExtent
      : verticalOffset;

  if (canAnimate) {
    await dataGridConfiguration.verticalScrollController!.animateTo(
        verticalOffset,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn);
  } else {
    dataGridConfiguration.verticalScrollController!.jumpTo(verticalOffset);
  }
  dataGridConfiguration.container.updateScrollBars();
}

/// Helps to scroll the [SfDataGrid] horizontally.
/// [canAnimate]: decide to apply animation on scrolling or not.
Future<void> scrollHorizontal(
    DataGridConfiguration dataGridConfiguration, double horizontalOffset,
    [bool canAnimate = false]) async {
  final ScrollController? horizontalController =
      dataGridConfiguration.horizontalScrollController;

  if (horizontalController == null || !horizontalController.hasClients) {
    return;
  }

  horizontalOffset =
      horizontalOffset > horizontalController.position.maxScrollExtent
          ? horizontalController.position.maxScrollExtent
          : horizontalOffset;
  horizontalOffset = horizontalOffset.isNegative || horizontalOffset == 0.0
      ? horizontalController.position.minScrollExtent
      : horizontalOffset;

  if (canAnimate) {
    await dataGridConfiguration.horizontalScrollController!.animateTo(
        horizontalOffset,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn);
  } else {
    dataGridConfiguration.horizontalScrollController!.jumpTo(horizontalOffset);
  }
  dataGridConfiguration.container.updateScrollBars();
}

/// Decide to enable swipe in [SfDataGrid]
bool canSwipeRow(DataGridConfiguration dataGridConfiguration,
    DataGridRowSwipeDirection swipeDirection, double swipeOffset) {
  if (dataGridConfiguration.container.horizontalOffset == 0) {
    if ((dataGridConfiguration.container.extentWidth >
            dataGridConfiguration.viewWidth) &&
        swipeDirection == DataGridRowSwipeDirection.endToStart &&
        swipeOffset <= 0) {
      return false;
    } else {
      return true;
    }
  } else if (dataGridConfiguration.container.horizontalOffset ==
      dataGridConfiguration.container.extentWidth -
          dataGridConfiguration.viewWidth) {
    if ((dataGridConfiguration.container.extentWidth >
            dataGridConfiguration.viewWidth) &&
        swipeDirection == DataGridRowSwipeDirection.startToEnd &&
        swipeOffset >= 0) {
      return false;
    } else {
      return true;
    }
  } else {
    return false;
  }
}

/// Decide the swipe direction based on [TextDirection].
DataGridRowSwipeDirection getSwipeDirection(
    DataGridConfiguration dataGridConfiguration, double swipingOffset) {
  return swipingOffset >= 0
      ? dataGridConfiguration.textDirection == TextDirection.ltr
          ? DataGridRowSwipeDirection.startToEnd
          : DataGridRowSwipeDirection.endToStart
      : dataGridConfiguration.textDirection == TextDirection.ltr
          ? DataGridRowSwipeDirection.endToStart
          : DataGridRowSwipeDirection.startToEnd;
}

/// Helps to get the [DataGridRow] based on respective rowIndex.
DataGridRow getDataGridRow(
    DataGridConfiguration dataGridConfiguration, int rowIndex) {
  final int recordIndex = resolveToRecordIndex(dataGridConfiguration, rowIndex);
  return effectiveRows(dataGridConfiguration.source)[recordIndex];
}

/// Helps to get the [DataGridRowAdapter] based on respective [DataGridRow].
DataGridRowAdapter? getDataGridRowAdapter(
    DataGridConfiguration dataGridConfiguration, DataGridRow dataGridRow) {
  DataGridRowAdapter buildBlankRow(DataGridRow dataGridRow) {
    return DataGridRowAdapter(
        cells: dataGridConfiguration.columns
            .map<Widget>(
                (GridColumn dataCell) => SizedBox.fromSize(size: Size.zero))
            .toList());
  }

  return dataGridConfiguration.source.buildRow(dataGridRow) ??
      buildBlankRow(dataGridRow);
}

/// Check the length of two list.
/// If its not satisfies it throw a exception.
bool debugCheckTheLength(DataGridConfiguration dataGridConfiguration,
    int columnLength, int cellLength, String message) {
  cellLength += dataGridConfiguration.showCheckboxColumn ? 1 : 0;
  assert(() {
    if (columnLength != cellLength) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$message: is not true'),
      ]);
    }
    return true;
  }());
  return true;
}

/// Return the cumulative distance of frozen top rows. The cumulative distance
/// covered the header, stacked header and freeze pane
double getCumulativeFrozenRowsHeight(
    DataGridConfiguration dataGridConfiguration) {
  final int topFrozenRowsLength = dataGridConfiguration.container.frozenRows;
  double cumulativeFrozenRowsHeight = 0.0;
  for (int index = 0; index < topFrozenRowsLength; index++) {
    cumulativeFrozenRowsHeight +=
        dataGridConfiguration.container.rowHeights[index];
  }
  return cumulativeFrozenRowsHeight;
}

/// Return the cumulative distance of frozen bottom rows.
double getCumulativeFooterFrozenRowsHeight(
    DataGridConfiguration dataGridConfiguration) {
  final int bottomFrozenRowsLength =
      dataGridConfiguration.container.footerFrozenRows;
  double cumulativeFooterFrozenRowsHeight = 0.0;
  for (int index = 0; index < bottomFrozenRowsLength; index++) {
    final int rowIndex = dataGridConfiguration.container.rowCount - index;
    cumulativeFooterFrozenRowsHeight +=
        dataGridConfiguration.container.rowHeights[rowIndex];
  }
  return cumulativeFooterFrozenRowsHeight;
}

/// Return the cumulative distance of frozen column on left side. The
/// cumulative distance covered the row header, indent cell, freeze pane
double getCumulativeFrozenColumnsWidth(
    DataGridConfiguration dataGridConfiguration) {
  final int leftColumnCount = dataGridConfiguration.container.frozenColumns;
  double cumulativeFrozenColumnWidth = 0.0;
  for (int index = 0; index < leftColumnCount; index++) {
    cumulativeFrozenColumnWidth +=
        dataGridConfiguration.container.columnWidths[index];
  }
  return cumulativeFrozenColumnWidth;
}

/// Return the cumulative distance of frozen right side columns.
double getCumulativeFooterFrozenColumnsWidth(
    DataGridConfiguration dataGridConfiguration) {
  final int rightColumnCount =
      dataGridConfiguration.container.footerFrozenColumns;
  double cumulativeFooterFrozenColumnWidth = 0.0;
  for (int index = 0; index < rightColumnCount; index++) {
    final int columnIndex = dataGridConfiguration.container.columnCount - index;
    cumulativeFooterFrozenColumnWidth +=
        dataGridConfiguration.container.columnWidths[columnIndex];
  }
  return cumulativeFooterFrozenColumnWidth;
}

/// Resolve the cumulative horizontal offset with frozen rows.
double resolveVerticalScrollOffset(
    DataGridConfiguration dataGridConfiguration, double verticalOffset) {
  final double leftOffset =
      getCumulativeFrozenRowsHeight(dataGridConfiguration);
  final double rightOffset =
      getCumulativeFooterFrozenRowsHeight(dataGridConfiguration);
  final double bottomOffset =
      dataGridConfiguration.container.extentHeight - rightOffset;
  if (verticalOffset >= bottomOffset) {
    return dataGridConfiguration
        .verticalScrollController!.position.maxScrollExtent;
  }

  if (verticalOffset <= leftOffset) {
    return dataGridConfiguration
        .verticalScrollController!.position.minScrollExtent;
  }

  for (int i = 0; i < dataGridConfiguration.container.frozenRows; i++) {
    verticalOffset -= dataGridConfiguration.container.rowHeights[i];
  }

  return verticalOffset;
}

/// Resolve the cumulative horizontal offset with frozen column.
double resolveHorizontalScrollOffset(
    DataGridConfiguration dataGridConfiguration, double horizontalOffset) {
  final double topOffset =
      getCumulativeFrozenColumnsWidth(dataGridConfiguration);
  final double bottomOffset =
      getCumulativeFooterFrozenColumnsWidth(dataGridConfiguration);
  final double rightOffset =
      dataGridConfiguration.container.extentWidth - bottomOffset;
  if (horizontalOffset >= rightOffset) {
    return dataGridConfiguration
        .horizontalScrollController!.position.maxScrollExtent;
  }

  if (horizontalOffset <= topOffset) {
    return dataGridConfiguration
        .horizontalScrollController!.position.minScrollExtent;
  }

  for (int i = 0; i < dataGridConfiguration.container.frozenColumns; i++) {
    horizontalOffset -= dataGridConfiguration.container.columnWidths[i];
  }

  return horizontalOffset;
}

/// Get the vertical offset with reduction of frozen rows
double getVerticalOffset(
    DataGridConfiguration dataGridConfiguration, int rowIndex) {
  if (rowIndex < 0) {
    return dataGridConfiguration.container.verticalOffset;
  }

  final double cumulativeOffset = selection_helper
      .getVerticalCumulativeDistance(dataGridConfiguration, rowIndex);

  return resolveVerticalScrollOffset(dataGridConfiguration, cumulativeOffset);
}

/// Get the vertical offset with reduction of frozen columns
double getHorizontalOffset(
    DataGridConfiguration dataGridConfiguration, int columnIndex) {
  if (columnIndex < 0) {
    return dataGridConfiguration.container.horizontalOffset;
  }

  final double cumulativeOffset = selection_helper
      .getHorizontalCumulativeDistance(dataGridConfiguration, columnIndex);

  return resolveHorizontalScrollOffset(dataGridConfiguration, cumulativeOffset);
}

/// Resolve the scroll offset to [DataGridScrollPosition].
/// It's helps to get the position of rows and column scroll into desired
/// DataGridScrollPosition.
double resolveScrollOffsetToPosition(
    DataGridScrollPosition position,
    ScrollAxisBase scrollAxisBase,
    double measuredScrollOffset,
    double viewDimension,
    double headerExtent,
    double bottomExtent,
    double defaultDimension,
    double defaultScrollOffset,
    int index) {
  if (position == DataGridScrollPosition.center) {
    measuredScrollOffset = measuredScrollOffset -
        ((viewDimension - bottomExtent - headerExtent) / 2) +
        (defaultDimension / 2);
  } else if (position == DataGridScrollPosition.end) {
    measuredScrollOffset = measuredScrollOffset -
        (viewDimension - bottomExtent - headerExtent) +
        defaultDimension;
  } else if (position == DataGridScrollPosition.makeVisible) {
    final VisibleLinesCollection visibleLines =
        scrollAxisBase.getVisibleLines();
    final int startIndex =
        visibleLines[visibleLines.firstBodyVisibleIndex].lineIndex;
    final int endIndex =
        visibleLines[visibleLines.lastBodyVisibleIndex].lineIndex;
    if (index > startIndex && index < endIndex) {
      measuredScrollOffset = defaultScrollOffset;
    }
    if (defaultScrollOffset - measuredScrollOffset < 0) {
      measuredScrollOffset = measuredScrollOffset -
          (viewDimension - bottomExtent - headerExtent) +
          defaultDimension;
    }
  }

  return measuredScrollOffset;
}
