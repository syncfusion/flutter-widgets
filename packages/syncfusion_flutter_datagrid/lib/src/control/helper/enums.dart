part of datagrid;

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

  /// Calculates the width of column based on header content.
  /// So that header content is not truncated.
  header,

  /// Calculates the width of column based on header and cell contents.
  /// So that header and cell content’s are not truncated.
  auto,

  /// Calculates the width of column based on cell contents.
  /// So that cell content’s are not truncated.
  cells,

  /// Applies [ColumnWidthMode.cells] width to all the columns except last
  ///  column which is visible and the remaining width from total width of
  ///  [SfDataGrid] is set to last column.
  lastColumnFill,

  /// Divides the total width equally for columns.
  fill,
}

/// Determines how the column widths should be calculated.
enum ColumnWidthCalculationMode {
  /// The cell size is calculated by calculating and comparing the size of
  /// the text in a cell.
  textSize,

  /// The cell size is calculated by calculating the
  /// string width of the longest string (maximum length) in a column.
  ///
  /// By this way, the width will not be calculated for each cell and
  /// width is calculated for longest string alone.
  textLength,
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

/// Decides whether the selection should be applied above the cell/row style
/// or both selection and cell or row style should be applied.
enum StylePreference {
  /// Selection should be applied above the applied cell or row style.
  selection,

  /// Selection and cell or row style should be applied.
  styleAndSelection
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
