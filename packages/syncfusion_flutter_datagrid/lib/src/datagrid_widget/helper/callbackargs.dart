// ignore_for_file: use_setters_to_change_properties

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../grid_common/row_column_index.dart';
import '../runtime/column.dart';
import 'datagrid_configuration.dart';
import 'enums.dart';

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
@immutable
class DataGridCellDetails {
  /// Creates a [DataGridCellDetails] with the specified [rowColumnIndex] and
  /// [column].
  const DataGridCellDetails(
      {required this.rowColumnIndex, required this.column});

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
@immutable
class DataGridCellTapDetails extends DataGridCellDetails {
  /// Creates a [DataGridCellTapDetails] with the specified [rowColumnIndex],
  /// [column], [globalPosition], [localPosition] and [kind].
  const DataGridCellTapDetails(
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

  /// An index of a row.
  final int rowIndex;

  ///The height of the row at the specified [rowIndex].
  ///If you want to change this height, you can return a different
  /// height from the [SfDataGrid.onQueryRowHeight] callback.
  final double rowHeight;

  late ColumnSizer _columnSizer;

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
    return getAutoFitRowHeight(_columnSizer, rowIndex,
        canIncludeHiddenColumns: canIncludeHiddenColumns,
        excludedColumns: excludedColumns);
  }
}

/// Details for callbacks that use [DataGridCellDoubleTapDetails].
///
/// See also:
///
/// [DataGridCellDoubleTapCallback].
@immutable
class DataGridCellDoubleTapDetails extends DataGridCellDetails {
  /// Creates a [DataGridCellDoubleTapDetails] with the specified [rowColumnIndex]
  /// and [column].
  const DataGridCellDoubleTapDetails(
      {required RowColumnIndex rowColumnIndex, required GridColumn column})
      : super(rowColumnIndex: rowColumnIndex, column: column);
}

/// Details for callbacks that use [DataGridCellLongPressDetails].
///
/// See also:
///
/// [DataGridCellLongPressCallback].
@immutable
class DataGridCellLongPressDetails extends DataGridCellDetails {
  /// Creates a [DataGridCellLongPressDetails] with the specified
  /// [rowColumnIndex], [column], [globalPosition], [localPosition].
  const DataGridCellLongPressDetails({
    required RowColumnIndex rowColumnIndex,
    required GridColumn column,
    required this.globalPosition,
    required this.localPosition,
  }) : super(rowColumnIndex: rowColumnIndex, column: column);

  /// The global position at which the pointer contacted the screen.
  final Offset globalPosition;

  /// The local position at which the pointer contacted the screen.
  final Offset localPosition;
}

/// Configuration details to sort a column in [SfDataGrid].
///
/// See also:
///
/// * [DataGridSource.sortedColumns] – which is the collection of
/// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
@immutable
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
  DataGridSwipeStartDetails({
    required this.rowIndex,
    required this.swipeDirection,
  });
  late DataGridConfiguration _dataGridConfiguration;

  /// An index of a row which is swiped.
  final int rowIndex;

  /// The direction in which a row is swiped.
  final DataGridRowSwipeDirection swipeDirection;

  /// Sets the maximum offset in which a row can be swiped.
  ///
  /// Typically, this method can be used to set the different maximum offset for swiping based on the swipe direction.
  void setSwipeMaxOffset(double offset) {
    _dataGridConfiguration.effectiveSwipeMaxOffset = offset;
  }
}

/// Holds the arguments for the [SfDataGrid.onSwipeUpdate] callback.
@immutable
class DataGridSwipeUpdateDetails {
  /// Creates a [DataGridSwipeUpdateDetails] class for [SfDataGrid].
  const DataGridSwipeUpdateDetails(
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
@immutable
class DataGridSwipeEndDetails {
  /// Creates a [DataGridSwipeEndDetails] class for [SfDataGrid].
  const DataGridSwipeEndDetails(
      {required this.rowIndex, required this.swipeDirection});

  /// An index of a row which is swiped.
  final int rowIndex;

  /// The direction in which a row is swiped.
  final DataGridRowSwipeDirection swipeDirection;
}

/// Holds the arguments for the [SfDataGrid.onColumnResizeStart] callback.
@immutable
class ColumnResizeStartDetails {
  /// Creates the [ColumnResizeStartDetails] with the specified [column] and [width].
  const ColumnResizeStartDetails({required this.column, required this.width});

  ///  A column that is going to be resized.
  final GridColumn column;

  /// Current width of a column.
  final double width;
}

/// Holds the arguments for the [SfDataGrid.onColumnResizeUpdate] callback.
@immutable
class ColumnResizeUpdateDetails {
  /// Creates the [ColumnResizeUpdateDetails] with the specified [column] and [width].
  const ColumnResizeUpdateDetails({required this.column, required this.width});

  ///  A column that is being resized.
  final GridColumn column;

  /// Currently resized width of a column.
  final double width;
}

/// Holds the arguments for the [SfDataGrid.onColumnResizeEnd] callback.
@immutable
class ColumnResizeEndDetails {
  /// Creates the [ColumnResizeEndDetails] with the specified [column] and [width].
  const ColumnResizeEndDetails({required this.column, required this.width});

  ///  A column that is resized.
  final GridColumn column;

  /// Currently resized width of a column.
  final double width;
}

/// Details for callbacks that use [DataGridFilterChangeDetails].
///
/// See also:
///
/// * [DataGridFilterChangingCallback]
/// * [DataGridFilterChangedCallback]
@immutable
class DataGridFilterChangeDetails {
  /// Creates the [DataGridFilterChangeDetails] for the
  /// `DataGridFilterChangingCallback` and `DataGridFilterChangedCallback`.
  const DataGridFilterChangeDetails(
      {required this.column, required this.filterConditions});

  /// The column where the current filtering is applied.
  final GridColumn column;

  /// Holds the collection of [FilterCondition] which are applied currently to
  /// the column.
  final List<FilterCondition> filterConditions;
}

/// Sets the `columnSizer` instance to the [RowHeightDetails] class.
void setColumnSizerInRowHeightDetailsArgs(
    RowHeightDetails rowHeightDetails, ColumnSizer columnSizer) {
  rowHeightDetails._columnSizer = columnSizer;
}

///Sets the `dataGridConfiguration` instance to the [DataGridSwipeStartDetails] class
void setSwipeOffsetInDataGridSwipeStartDetailsArgs(
    DataGridConfiguration dataGridConfiguration,
    DataGridSwipeStartDetails swipeStartDetails) {
  swipeStartDetails._dataGridConfiguration = dataGridConfiguration;
}
