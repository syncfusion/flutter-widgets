import 'dart:math';

import 'package:collection/collection.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// ----------------- Stacked header helper methods -------------------//

/// Returns the column sequences for the stacked header column by using the
/// columnNames property.
List<int> getColumnSequences(List<GridColumn> columns, StackedHeaderCell cell) {
  final List<int> childSequences = <int>[];
  if (cell.columnNames.isNotEmpty) {
    for (final String columnName in cell.columnNames) {
      final GridColumn? column = columns.firstWhereOrNull(
          (GridColumn column) => column.columnName == columnName);
      if (column != null) {
        childSequences.add(columns.indexOf(column));
      }
    }
  }

  if (childSequences.isNotEmpty) {
    childSequences.sort();
  }
  return childSequences;
}

/// Returns the collection of consecutive ranges for the given column indexes
List<List<int>> getConsecutiveRanges(List<int> columnIndexes) {
  int endIndex = 1;
  final List<List<int>> list = <List<int>>[];
  if (columnIndexes.isEmpty) {
    return list;
  }
  for (int i = 1; i <= columnIndexes.length; i++) {
    if (i == columnIndexes.length ||
        columnIndexes[i] - columnIndexes[i - 1] != 1) {
      if (endIndex == 1) {
        list.add(columnIndexes.sublist(i - endIndex, (i - endIndex) + 1));
      } else {
        list.add(columnIndexes.sublist(i - endIndex, i));
      }
      endIndex = 1;
    } else {
      endIndex++;
    }
  }
  return list;
}

/// Returns the row span to the stacked header and column header row.
int getRowSpan(
    {String? columnName,
    required int rowIndex,
    required int columnIndex,
    required bool isStackedHeader,
    required SfDataGrid dataGrid,
    StackedHeaderCell? stackedHeaderCell}) {
  int startIndex = 0, endIndex = 0, rowSpan = 0;
  if (isStackedHeader && stackedHeaderCell != null) {
    final List<List<int>> columnIndexes = getConsecutiveRanges(
        getColumnSequences(dataGrid.columns, stackedHeaderCell));
    final List<int>? spannedColumn = columnIndexes
        .singleWhereOrNull((List<int> column) => column.first == columnIndex);
    if (spannedColumn != null) {
      startIndex = spannedColumn.reduce(min);
      endIndex = startIndex + spannedColumn.length - 1;
    }
  } else {
    if (rowIndex >= dataGrid.stackedHeaderRows.length) {
      return rowSpan;
    }
  }

  while (rowIndex >= 0) {
    final StackedHeaderRow stackedHeaderRow =
        dataGrid.stackedHeaderRows[rowIndex];
    for (final StackedHeaderCell stackedColumn in stackedHeaderRow.cells) {
      if (isStackedHeader) {
        final List<List<int>> columnIndexes = getConsecutiveRanges(
            getColumnSequences(dataGrid.columns, stackedColumn));
        for (final List<int> column in columnIndexes) {
          if ((startIndex >= column.first && startIndex <= column.last) ||
              (endIndex >= column.first && endIndex <= column.last)) {
            return rowSpan;
          }
        }
      } else if (stackedColumn.columnNames.isNotEmpty) {
        final List<String> children = stackedColumn.columnNames;
        for (int child = 0; child < children.length; child++) {
          if (children[child] == columnName) {
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

/// Returns the start and end index of the given spanned columns when the
/// exclude columns are applied.
List<int> getSpannedCellStartAndEndIndex(
    {required int columnSpan,
    required int columnIndex,
    required int startColumnIndex,
    required List<GridColumn> columns,
    required List<String> excludeColumns}) {
  int excludeColumnsCount = 0;
  int firstColumnIndex = startColumnIndex + columnIndex;
  int lastColumnIndex = firstColumnIndex + columnSpan;
  final List<int> excludeColumnIndexes = <int>[];

  for (final String columnName in excludeColumns) {
    final GridColumn? column = columns.firstWhereOrNull(
        (GridColumn element) => element.columnName == columnName);
    if (column != null) {
      excludeColumnIndexes.add(columns.indexOf(column));
    }
  }

  if (firstColumnIndex > startColumnIndex) {
    // Updates the first and last column index if any exclude column exists
    // before the `firstColumnIndex`.
    excludeColumnsCount =
        excludeColumnIndexes.where((int index) => index < columnIndex).length;

    firstColumnIndex =
        max(startColumnIndex, firstColumnIndex - excludeColumnsCount);
    lastColumnIndex =
        max(startColumnIndex, lastColumnIndex - excludeColumnsCount);
  }

  // To remove the in-between excluded columns from the `lastColumnIndex`.
  excludeColumnsCount = excludeColumnIndexes
      .where((int index) =>
          index >= columnIndex && index <= columnIndex + columnSpan)
      .length;
  lastColumnIndex -= excludeColumnsCount;

  return <int>[firstColumnIndex, lastColumnIndex];
}

/// ----------------- Table summary row helper methods -------------------//

/// Gets title column count of the given summary column.
int getTitleColumnCount(GridTableSummaryRow summaryRow,
    List<GridColumn> columns, List<String> excludeColumns) {
  int currentColumnSpan = 0;
  for (int i = 0; i < summaryRow.titleColumnSpan; i++) {
    if (i <= columns.length) {
      if (!excludeColumns.contains(columns[i].columnName)) {
        currentColumnSpan++;
      }
    }
  }
  return currentColumnSpan;
}

/// Returns the column index to the summary column.
int getSummaryColumnIndex(
    List<GridColumn> columns, String columnName, List<String> excludeColumns) {
  if (excludeColumns.contains(columnName)) {
    return -1;
  }

  final List<GridColumn> visibleColumns = columns
      .where((GridColumn column) => !excludeColumns.contains(column.columnName))
      .toList();
  final GridColumn? column = visibleColumns.firstWhereOrNull(
      (GridColumn element) => element.columnName == columnName);
  return column != null ? visibleColumns.indexOf(column) : -1;
}
