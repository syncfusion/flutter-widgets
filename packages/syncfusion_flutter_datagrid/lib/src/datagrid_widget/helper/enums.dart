/// Describes the possible values for row region.
///
/// These values are used to update the row region for the row elements
/// in a [SfDataGrid] control.
enum RowRegion {
  /// Specifies the header region which is frozen at the top of the view.
  header,

  /// Specifies the footer region which is frozen at the bottom of the view.
  footer,

  /// Specifies the body region which is scrollable in view.
  body,
}

/// Describes the possible values for row types.
enum RowType {
  /// Specifies the data row that displays the header text.
  headerRow,

  /// Specifies the data row that displays the row data.
  dataRow,

  /// Specifies the StackedHeaderRow that displays the stacked header text.
  stackedHeaderRow,

  /// Specifies the footer row that displays the footer row data
  footerRow,

  /// Specifies the SpannedDataRow that displays the table summary value in
  /// corresponding columns.
  tableSummaryRow,

  /// Specifies the SpannedDataRow that displays the table summary value in row.
  tableSummaryCoveredRow,
}

/// Describes the possible values for cell types.
enum CellType {
  /// Specifies the header cell.
  headerCell,

  /// Specifies the data  cell.
  gridCell,

  /// Specifies the indent cell.
  indentCell,

  /// Specifies the row header cell.
  rowHeaderCell,

  /// Specifies the stacked header cell.
  stackedHeaderCell,

  /// Specifies the checkbox cell.
  checkboxCell,

  /// Specifies the table summary cell
  tableSummaryCell,
}

/// Determines how border lines should be shown in [SfDataGrid].
enum GridLinesVisibility {
  /// Borders are not drawn.
  none,

  /// Both vertical and horizontal borders are visible.
  both,

  /// Only vertical borders are visible.
  vertical,

  /// Only horizontal borders are visible.
  horizontal,
}

/// Determines how the width of the columns are adjusted.
enum ColumnWidthMode {
  /// No sizing. Default column width or defined width set to column.
  none,

  /// Calculates the width of column based on [GridColumn.columnName].
  ///
  /// The default `TextStyle` of datagrid is considered internally to calculate
  /// the auto size. If you want to set your required `TextStyle` for calculation,
  /// you can override the [ColumnSizer.computeHeaderCellWidth] method and pass
  /// the required `TextStyle` to base class.
  ///
  /// See also,
  ///
  /// [GridColumn.autoFitPadding] – Represents the amount of space which should
  /// be added along with the auto size.
  fitByColumnName,

  /// Set the column width by calculating the max size among the header cell and
  /// among the cells in column.
  ///
  /// See also,
  ///
  /// [GridColumn.autoFitPadding] – Represents the amount of space which should
  /// be added along with the auto size.
  auto,

  /// Set the column width by calculating the max size among the cells in column.
  /// Auto fit calculation will be depending upon the [DataGridCell.value] property.
  ///
  /// The default `TextStyle` of datagrid is considered internally to calculate
  /// the auto size. If you want to set your required `TextStyle` for calculation,
  /// you can override the [ColumnSizer.computeCellWidth] method and pass the
  /// required `TextStyle` to base class.
  ///
  /// See also,
  ///
  /// [GridColumn.autoFitPadding] – Represents the amount of space which should
  /// be added along with the auto size.
  fitByCellValue,

  /// Calculates the auto width for all the columns except the last column which
  /// is visible and the remaining width from total width of [SfDataGrid] is set
  /// to last column if `width` of this column is not set.
  lastColumnFill,

  /// Divides the total width equally for columns.
  fill,
}

/// Determines how the row count should be considered when calculating
/// the width of a column.
enum ColumnWidthCalculationRange {
  /// Column auto sizing considers all the rows in the grid.
  allRows,

  /// Column auto sizing considers visible rows only in the grid.
  visibleRows,
}

/// Determines how the selection is applied.
enum SelectionMode {
  /// No rows can be selected.
  none,

  /// Specifies that only one row can be selected.
  single,

  /// Specifies that only one row can be selected,
  /// and selected row can be de-selected when again
  /// tapping on that selected row.
  singleDeselect,

  /// Specifies that multiple rows can be selected.
  multiple
}

/// Decides whether the navigation in the [SfDataGrid] should be cell wise
/// or row wise.
enum GridNavigationMode {
  /// The current cell can be shown to notify
  /// the currently activated cell for cell wise navigation.
  cell,

  /// The selection can be moved among
  /// the rows alone and current cell will not be shown.
  row
}

/// Specifies the direction of the sort operation.
enum DataGridSortDirection {
  /// Sorts in ascending order.
  ascending,

  /// Sorts in descending order.
  descending
}

/// Specifies the different tap actions available for applying sorting.
enum SortingGestureType {
  /// Sorting is applied on tap the header.
  tap,

  /// Sorting is applied on double tap the header.
  doubleTap,
}

/// The direction in which a row in [SfDataGrid] is swiped.
enum DataGridRowSwipeDirection {
  /// The row is swiped by dragging in the reading direction (e.g., from left to
  /// right in left-to-right languages).
  startToEnd,

  /// The row is swiped by dragging in the reverse of the reading (e.g., from
  /// right to left in left-to-right languages).
  endToStart,
}

/// Decides how to scroll request to the corresponding position.
enum DataGridScrollPosition {
  /// Scroll to the start of a [SfDataGrid].
  start,

  /// Scroll to the end of a [SfDataGrid].
  end,

  /// Scroll to make a specified item visible.
  ///
  /// If the given item is not visible and it is presented at top of the datagrid, that item will be visible at top of the [SfDataGrid]. Also, behaves same for bottom case.
  makeVisible,

  /// Scroll to the center of a [SfDataGrid].
  center,
}

/// Decides whether column resizing should be processed when resizing indicator moves or pointer stopped contacting the screen.
enum ColumnResizeMode {
  /// Column resizing happens as the resizing indicator moves.
  onResize,

  /// Column resizing happens when pointer stopped contacting the screen.
  onResizeEnd,
}

/// Specifies the different tap actions available for allow editing.
enum EditingGestureType {
  /// Editing is triggered on single tap.
  tap,

  /// Editing is triggered on double tap.
  doubleTap
}

/// Determines how table summary row should be positioned in [SfDataGrid].
enum GridTableSummaryRowPosition {
  /// Specifies that the table summary row is positioned at the top.
  top,

  /// Specifies that the table summary row is positioned at the bottom.
  bottom,
}

/// Determines which summary type should be displayed for summary column.
enum GridSummaryType {
  /// Specifies the sum of the values in specific summary column
  sum,

  /// Specifies the maximum value of the specific summary column.
  maximum,

  /// Specifies the minimum value of the specific summary column.
  minimum,

  /// Specifies the average of the summary column.
  average,

  /// Specifies the count of rows available in [SfDataGrid].
  count,
}

/// Determines the type of the filter condition which should be compared
/// between rows.
enum FilterType {
  /// Checks whether the cell value contain the given filter value.
  contains,

  /// Checks whether the cell value ends with the given filter value.
  endsWith,

  /// Checks whether the cell value is equivalent to the given filter value.
  equals,

  /// Checks whether the cell value is greater than the given filter value.
  greaterThan,

  /// Checks whether the cell value is greater than or equal to the given filter
  /// value.
  greaterThanOrEqual,

  /// Checks whether the cell value is lesser than the given filter value.
  lessThan,

  /// Checks whether the cell value is lesser than or equal to the given filter
  /// value.
  lessThanOrEqual,

  /// Checks whether the cell value does not contain the given filter value.
  doesNotContain,

  /// Checks whether the cell value does not end with the given filter value.
  doesNotEndsWith,

  /// Checks whether the cell value is not equivalent to the given filter value.
  notEqual,

  /// Checks whether the cell value does not begin with the given filter value.
  doesNotBeginWith,

  /// Checks whether the cell value begins with the given filter value.
  beginsWith,
}

/// Determines the type of the logical operator to be applied between multiple
/// filter conditions.
enum FilterOperator {
  /// AND logical operator is applied between multiple filter conditions.
  and,

  /// OR logical operator is applied between multiple filter conditions.
  or,
}

/// Determines how the filter comparison should behave.
enum FilterBehavior {
  /// Converts the cell value as string and compare the condition.
  stringDataType,

  /// Compares the cell value with its actual data type.
  strongDataType,
}

/// Determines how the filter menu should be opened.
enum FilteredFrom {
  /// Specifies the checkbox filter.
  checkboxFilter,

  /// Specifies the advanced filter.
  advancedFilter,

  /// Specifies the none.
  none,
}

/// Determines how the filter comparison should behave.
enum AdvancedFilterType {
  /// Specifies that the filtering options should be available based on string
  /// comparison.
  text,

  /// Specifies that the filtering options should be available based on numeric
  /// values.
  numeric,

  /// Specifies that the filtering options should be available based on date
  /// values.
  date,
}
