part of datagrid;

/// A base class which provides the details for callbacks that use
/// [DataGridCellTapDetails], [DataGridCellDoubleTapDetails] and
/// [DataGridCellLongPressDetails].
///
/// See also:
///
/// * [DataGridCellTapDetails], which uses [DataGridCellTapCallback].
/// * [DataGridCellDoubleTapDetails], which uses
/// [DataGridCellDoubleTapCallback].
/// * [DataGridCellLongPressDetails], which uses
/// [DataGridCellLongPressCallback].
class DataGridCellDetails {
  /// Creates a [DataGridCellDetails] with the specified [rowColumnIndex] and
  /// [column].
  DataGridCellDetails({required this.rowColumnIndex, required this.column});

  /// The coordinates of the cell in [SfDataGrid].
  final RowColumnIndex rowColumnIndex;

  /// The corresponding column of a cell.
  final GridColumn column;
}

/// Details for callbacks that use [DataGridCellTapDetails].
///
/// See also:
///
/// [DataGridCellTapCallback].
class DataGridCellTapDetails extends DataGridCellDetails {
  /// Creates a [DataGridCellTapDetails] with the specified [rowColumnIndex],
  /// [column], [globalPosition], [localPosition] and [kind].
  DataGridCellTapDetails(
      {required RowColumnIndex rowColumnIndex,
      required GridColumn column,
      required this.globalPosition,
      required this.localPosition,
      required this.kind})
      : super(rowColumnIndex: rowColumnIndex, column: column);

  /// The global position at which the pointer contacted the screen.
  final Offset globalPosition;

  /// The local position at which the pointer contacted the screen.
  final Offset localPosition;

  /// The kind of the device that initiated the event.
  final PointerDeviceKind kind;
}

/// Details for callbacks that use [RowHeightDetails]

/// see also:
///
/// [QueryRowHeightCallback]
class RowHeightDetails {
  /// Creates a [RowHeightDetails] with the specified [rowIndex]
  /// and [rowHeight].
  RowHeightDetails(this.rowIndex, this.rowHeight);

  late ColumnSizer _columnSizer;

  /// An index of a row.
  int rowIndex;

  ///The height of the row at the specified [rowIndex].
  ///If you want to change this height, you can return a different
  /// height from the [SfDataGrid.onQueryRowHeight] callback.
  double rowHeight;

  /// Gets the row height to fit the row based on the [DataGridCell.value]. For
  /// header cells, it considers the [GridColumn.columnName].
  ///
  /// You can set the [canIncludeHiddenColumns] argument as true to consider the
  /// hidden columns also in auto size calculation. If you want to exclude any
  /// column, you can use `excludedColumn` argument.
  ///
  /// You can override [ColumnSizer.computeHeaderCellHeight] or
  /// [ColumnSizer.computeCellHeight] methods to perform the custom calculation
  /// for height. If you want to calculate the height based on different
  /// [TextStyle], you can override these methods and call the super method with
  ///  the required [TextStyle]. Also, set the custom [ColumnSizer] to
  /// [SfDataGrid.columnSizer] property.
  ///
  /// The auto size is calculated based on default [TextStyle] of the datagrid.
  double getIntrinsicRowHeight(int rowIndex,
      {bool canIncludeHiddenColumns = false,
      List<String> excludedColumns = const <String>[]}) {
    return _columnSizer._getAutoFitRowHeight(rowIndex,
        canIncludeHiddenColumns: canIncludeHiddenColumns,
        excludedColumns: excludedColumns);
  }
}

/// Details for callbacks that use [DataGridCellDoubleTapDetails].
///
/// See also:
///
/// [DataGridCellDoubleTapCallback].
class DataGridCellDoubleTapDetails extends DataGridCellDetails {
  /// Creates a [DataGridCellDoubleTapDetails] with the specified [rowColumnIndex]
  /// and [column].
  DataGridCellDoubleTapDetails(
      {required RowColumnIndex rowColumnIndex, required GridColumn column})
      : super(rowColumnIndex: rowColumnIndex, column: column);
}

/// Details for callbacks that use [DataGridCellLongPressDetails].
///
/// See also:
///
/// [DataGridCellLongPressCallback].
class DataGridCellLongPressDetails extends DataGridCellDetails {
  /// Creates a [DataGridCellLongPressDetails] with the specified
  /// [rowColumnIndex], [column], [globalPosition], [localPosition] and
  /// [velocity].
  DataGridCellLongPressDetails(
      {required RowColumnIndex rowColumnIndex,
      required GridColumn column,
      required this.globalPosition,
      required this.localPosition,
      required this.velocity})
      : super(rowColumnIndex: rowColumnIndex, column: column);

  /// The global position at which the pointer contacted the screen.
  final Offset globalPosition;

  /// The local position at which the pointer contacted the screen.
  final Offset localPosition;

  /// The pointer's velocity when it stopped contacting the screen.
  final Velocity velocity;
}

/// Configuration details to sort a column in [SfDataGrid].
///
/// See also:
///
/// * [DataGridSource.sortedColumns] – which is the collection of
/// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
class SortColumnDetails {
  /// Creates the [SortColumnDetails] for [SfDataGrid] widget.
  const SortColumnDetails({required this.name, required this.sortDirection});

  /// The name of the column.
  final String name;

  /// The direction of sort operation.
  final DataGridSortDirection sortDirection;
}

/// Holds the arguments for the [SfDataGrid.onSwipeStart] callback.
class DataGridSwipeStartDetails {
  /// Creates a [DataGridSwipeStartDetails] class for [SfDataGrid].
  DataGridSwipeStartDetails(
      {required this.rowIndex, required this.swipeDirection});

  /// An index of a row which is swiped.
  final int rowIndex;

  /// The direction in which a row is swiped.
  final DataGridRowSwipeDirection swipeDirection;
}

/// Holds the arguments for the [SfDataGrid.onSwipeUpdate] callback.
class DataGridSwipeUpdateDetails {
  /// Creates a [DataGridSwipeUpdateDetails] class for [SfDataGrid].
  DataGridSwipeUpdateDetails(
      {required this.rowIndex,
      required this.swipeOffset,
      required this.swipeDirection});

  /// An index of a row which is swiped.
  final int rowIndex;

  /// Defines the current offset in which a row is swiped.
  final double swipeOffset;

  /// The direction in which a row is swiped.
  final DataGridRowSwipeDirection swipeDirection;
}

/// Holds the arguments for the [SfDataGrid.onSwipeEnd] callback.
class DataGridSwipeEndDetails {
  /// Creates a [DataGridSwipeEndDetails] class for [SfDataGrid].
  DataGridSwipeEndDetails(
      {required this.rowIndex, required this.swipeDirection});

  /// An index of a row which is swiped.
  final int rowIndex;

  /// The direction in which a row is swiped.
  final DataGridRowSwipeDirection swipeDirection;
}

/// Holds the arguments for the [SfDataGrid.onColumnResizeStart] callback.
class ColumnResizeStartDetails {
  /// Creates the [ColumnResizeStartDetails] with the specified [column] and [width].
  ColumnResizeStartDetails({required this.column, required this.width});

  ///  A column that is going to be resized.
  final GridColumn column;

  /// Current width of a column.
  final double width;
}

/// Holds the arguments for the [SfDataGrid.onColumnResizeUpdate] callback.
class ColumnResizeUpdateDetails {
  /// Creates the [ColumnResizeUpdateDetails] with the specified [column] and [width].
  ColumnResizeUpdateDetails({required this.column, required this.width});

  ///  A column that is being resized.
  final GridColumn column;

  /// Currently resized width of a column.
  final double width;
}

/// Holds the arguments for the [SfDataGrid.onColumnResizeEnd] callback.
class ColumnResizeEndDetails {
  /// Creates the [ColumnResizeEndDetails] with the specified [column] and [width].
  ColumnResizeEndDetails({required this.column, required this.width});

  ///  A column that is resized.
  final GridColumn column;

  /// Currently resized width of a column.
  final double width;
}
