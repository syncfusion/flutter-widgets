part of datagrid;

/// Holds the arguments for the [SfDataGrid.onQueryRowStyle] callback.
class QueryRowStyleArgs {
  /// Creates the [QueryRowStyleArgs] with the specified [rowIndex].
  QueryRowStyleArgs({@required this.rowIndex});

  /// An index of a row in which the style is applied.
  final int rowIndex;

  /// Decides how the style is applied when selection and row style are applied.
  StylePreference stylePreference = StylePreference.selection;
}

/// Holds the arguments for the [SfDataGrid.onQueryCellStyle] callback.
class QueryCellStyleArgs {
  /// Creates the [QueryRowStyleArgs] with the specified [gridColumn],
  /// [rowIndex], [columnIndex], [cellValue] and [displayText].
  QueryCellStyleArgs(
      {@required this.column,
      @required this.rowIndex,
      @required this.columnIndex,
      @required this.cellValue,
      @required this.displayText});

  /// A [GridColumn] in which the style is applied.
  final GridColumn column;

  /// A row index of a cell.
  final int rowIndex;

  /// A column index of a cell.
  final int columnIndex;

  /// The value of a cell. Typically it is from underlying datasource.
  final Object cellValue;

  /// The display text of a cell. Typically it is the formatted text when number
  /// format or date format is applied for column.
  String displayText;

  /// Decides how the style is applied when selection and cell style are
  /// applied.
  StylePreference stylePreference = StylePreference.selection;
}

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
  DataGridCellDetails({@required this.rowColumnIndex, @required this.column});

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
      {@required RowColumnIndex rowColumnIndex,
      @required GridColumn column,
      @required this.globalPosition,
      @required this.localPosition,
      @required this.kind})
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

  /// An index of a row.
  int rowIndex;

  ///The height of the row at the specified [rowIndex].
  ///If you want to change this height, you can return a different
  /// height from the [SfDataGrid.onQueryRowHeight] callback.
  double rowHeight;
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
      {@required RowColumnIndex rowColumnIndex, @required GridColumn column})
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
      {@required RowColumnIndex rowColumnIndex,
      @required GridColumn column,
      @required this.globalPosition,
      @required this.localPosition,
      @required this.velocity})
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
/// * [DataGridSource.sortedColums] – which is the collection of
/// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
class SortColumnDetails {
  /// Creates the [SortColumnDetails] for [SfDataGrid] widget.
  SortColumnDetails({this.name, this.sortDirection});

  /// The name of the column.
  final String name;

  /// The direction of sort operation.
  final DataGridSortDirection sortDirection;
}
