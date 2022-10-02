import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../datagrid.dart';
import '../grid_common/line_size_host.dart';
import '../grid_common/scroll_axis.dart';
import 'helper/datagrid_configuration.dart';
import 'helper/datagrid_helper.dart' as grid_helper;
import 'runtime/cell_renderers.dart';
import 'runtime/column.dart';
import 'runtime/generator.dart';
import 'selection/selection_manager.dart';
import 'selection/selection_manager.dart' as selection_manager;
import 'widgets/scrollview_widget.dart';

/// Signature for [SfDataGrid.onQueryRowHeight] callback
typedef QueryRowHeightCallback = double Function(RowHeightDetails details);

/// Signature for [SfDataGrid.onSelectionChanging] callback.
typedef SelectionChangingCallback = bool Function(
    List<DataGridRow> addedRows, List<DataGridRow> removedRows);

/// Signature for [SfDataGrid.onSelectionChanged] callback.
typedef SelectionChangedCallback = void Function(
    List<DataGridRow> addedRows, List<DataGridRow> removedRows);

/// Signature for [SfDataGrid.onCurrentCellActivating] callback.
typedef CurrentCellActivatingCallback = bool Function(
    RowColumnIndex newRowColumnIndex, RowColumnIndex oldRowColumnIndex);

/// Signature for [SfDataGrid.onCurrentCellActivated] callback.
typedef CurrentCellActivatedCallback = void Function(
    RowColumnIndex newRowColumnIndex, RowColumnIndex oldRowColumnIndex);

/// Signature for [SfDataGrid.onCellTap] and [SfDataGrid.onCellSecondaryTap]
/// callbacks.
typedef DataGridCellTapCallback = void Function(DataGridCellTapDetails details);

/// Signature for [SfDataGrid.onCellDoubleTap] callback.
typedef DataGridCellDoubleTapCallback = void Function(
    DataGridCellDoubleTapDetails details);

/// Signature for [SfDataGrid.onCellLongPress] callback.
typedef DataGridCellLongPressCallback = void Function(
    DataGridCellLongPressDetails details);

/// The signature of [DataGridSource.handleLoadMoreRows] function.
typedef LoadMoreRows = Future<void> Function();

/// Signature for the [SfDataGrid.loadMoreViewBuilder] function.
typedef LoadMoreViewBuilder = Widget? Function(
    BuildContext context, LoadMoreRows loadMoreRows);

/// Signature for the [SfDataGrid.onSwipeStart] callback.
typedef DataGridSwipeStartCallback = bool Function(
    DataGridSwipeStartDetails swipeStartDetails);

/// Signature for the [SfDataGrid.onSwipeUpdate] callback.
typedef DataGridSwipeUpdateCallback = bool Function(
    DataGridSwipeUpdateDetails swipeUpdateDetails);

/// Signature for the [SfDataGrid.onSwipeEnd] callback.
typedef DataGridSwipeEndCallback = void Function(
    DataGridSwipeEndDetails swipeEndDetails);

/// Holds the arguments for the [SfDataGrid.startSwipeActionsBuilder] callback.
typedef DataGridSwipeActionsBuilder = Widget? Function(
    BuildContext context, DataGridRow dataGridRow, int rowIndex);

/// The signature of [DataGridSource.canSubmitCell] and
/// [DataGridSource.onCellSubmit] methods.
typedef CellSubmit = void Function();

/// Signature for the [SfDataGrid.onColumnResizeStart] callback.
typedef ColumnResizeStartCallback = bool Function(
    ColumnResizeStartDetails details);

/// Signature for the [SfDataGrid.onColumnResizeUpdate] callback.
typedef ColumnResizeUpdateCallback = bool Function(
    ColumnResizeUpdateDetails details);

/// Signature for the [SfDataGrid.onColumnResizeEnd] callback.
typedef ColumnResizeEndCallback = void Function(ColumnResizeEndDetails details);

/// Signature for the [SfDataGrid.onFilterChanging] callback.
typedef DataGridFilterChangingCallback = bool Function(
    DataGridFilterChangeDetails details);

/// Signature for the [SfDataGrid.onFilterChanged] callback.
typedef DataGridFilterChangedCallback = void Function(
    DataGridFilterChangeDetails details);

/// Signature for the [DataGridSourceChangeNotifier] listener.
typedef _DataGridSourceListener = void Function(
    {RowColumnIndex? rowColumnIndex});

/// Signature for the [DataGridSourceChangeNotifier] listener.
typedef _DataGridPropertyChangeListener = void Function(
    {RowColumnIndex? rowColumnIndex,
    String? propertyName,
    bool recalculateRowHeight});

/// Row configuration and cell data for a [SfDataGrid].
///
/// Return this list of [DataGridRow] objects to [DataGridSource.rows] property.
///
/// The data for each row can be passed as the cells argument to the
/// constructor of each [DataGridRow] object.
class DataGridRow {
  /// Creates [DataGridRow] for the [SfDataGrid].
  const DataGridRow({required List<DataGridCell> cells}) : _cells = cells;

  /// The data for this row.
  ///
  /// There must be exactly as many cells as there are columns in the
  /// [SfDataGrid].
  final List<DataGridCell> _cells;

  /// Returns the collection of [DataGridCell] which is created for
  /// [DataGridRow].
  List<DataGridCell> getCells() {
    return _cells;
  }
}

/// The data for a cell of a [SfDataGrid].
///
/// The list of [DataGridCell] objects should be passed as the cells argument
/// to the constructor of each [DataGridRow] object.
@optionalTypeArgs
class DataGridCell<T> {
  /// Creates [DataGridCell] for the [SfDataGrid].
  const DataGridCell({required this.columnName, required this.value});

  /// The name of a column
  final String columnName;

  /// The value of a cell.
  ///
  /// Provide value of a cell to perform the sorting for whole data available
  /// in datagrid.
  final T? value;
}

/// Row configuration and widget of cell for a [SfDataGrid].
///
/// The widget for each cell can be provided in the [DataGridRowAdapter.cells]
/// property.
class DataGridRowAdapter {
  /// Creates [DataGridRowAdapter] for the [SfDataGrid].
  const DataGridRowAdapter({required this.cells, this.key, this.color});

  /// The key for the row.
  final Key? key;

  /// The color for the row.
  final Color? color;

  /// The widget of each cell for this row.
  ///
  /// There must be exactly as many cells as there are columns in the
  /// [SfDataGrid].
  final List<Widget> cells;
}

/// Row configuration for stacked header in [SfDataGrid]. The columns for this
/// stacked header row are provided in the [StackedHeaderCell] property of the
/// [StackedHeaderRow] object.
///
/// See also:
///
/// [StackedHeaderCell] – which provides the configuration for column in stacked
/// header row.
class StackedHeaderRow {
  /// Creates the [StackedHeaderRow] for [SfDataGrid] widget.
  StackedHeaderRow({required this.cells});

  /// The collection of [StackedHeaderCell] in stacked header row.
  List<StackedHeaderCell> cells;
}

/// Column configuration for stacked header row in `SfDataGrid`.
///
/// See also:
///
/// [StackedHeaderRow] – which provides configuration for stacked header row.
class StackedHeaderCell {
  /// Creates the [StackedHeaderCell] for [StackedHeaderRow].
  StackedHeaderCell(
      {this.text, required this.columnNames, required this.child}) {
    _childColumnIndexes = <int>[];
  }

  /// The collection of string which is the [GridColumn.columnName] of the
  /// columns defined in the [SfDataGrid].
  ///
  /// The columns are spanned as a stacked header based on this collection. If
  /// the given collection has the sequence of columns which are presented in
  /// the [SfDataGrid], those columns will be spanned. Otherwise, stacked header
  ///  is added for each column which are not in sequence order in regular
  /// columns.
  final List<String> columnNames;

  /// The widget that represents the data of this cell.
  ///
  /// Typically, a [Text] widget.
  final Widget child;

  /// The text of the stacked header cell while exporting the [SfDataGrid] to
  /// Excel or Pdf.
  ///
  /// This property won’t affect the UI and this is used while exporting the
  /// [SfDataGrid].
  ///
  /// As widget can’t be exported to Excel or PDF, set this property to give the
  /// corresponding text while exporting the [SfDataGrid] to Excel or Pdf.
  final String? text;

  late List<int> _childColumnIndexes;
}

/// Row configuration of table summary in [SfDataGrid].
///
/// The summary columns for this table summary row are provided in [columns]
/// property of the [GridTableSummaryRow] object.
///
///See also,
///
/// * [GridSummaryColumn] -Which provides the configuration for summary column in
/// table summary row.
/// * [SfDataGrid.tableSummaryRows] – Enables you to add the table summary rows
/// to DataGrid.
class GridTableSummaryRow {
  /// Creates the [GridTableSummaryRow] to the [SfDataGrid].
  GridTableSummaryRow(
      {this.title,
      this.color,
      required this.columns,
      required this.position,
      this.titleColumnSpan = 0,
      this.showSummaryInRow = true})
      : assert(titleColumnSpan >= 0);

  /// A string that has the format and summary column information to be
  /// displayed in row.
  final String? title;

  /// The color of the summary row.
  final Color? color;

  /// Indicates how many columns should be spanned for
  /// [GridTableSummaryRow.title].
  ///
  /// This is applicable only if the [GridTableSummaryRow.showSummaryInRow]
  /// is false.
  ///
  /// If [GridTableSummaryRow.titleColumnSpan] value is greater than 0, then the
  /// [GridTableSummaryRow.title] will be rendered along with summary values as
  /// defined through summary columns.
  final int titleColumnSpan;

  /// Indicates whether the summary value should be displayed in whole row or
  /// based on individual columns.
  ///
  /// Defaults to true.
  final bool showSummaryInRow;

  /// The collection of [GridSummaryColumn].
  final List<GridSummaryColumn> columns;

  /// Indicates the position of the table summary row.
  final GridTableSummaryRowPosition position;
}

/// Column configuration for table summary row.
///
/// See also,
///
/// * [GridTableSummaryRow] – Which provides configuration for table summary row.
class GridSummaryColumn {
  /// Creates the [GridSummaryColumn] to the [GridTableSummaryRow].
  const GridSummaryColumn(
      {required this.name,
      required this.columnName,
      required this.summaryType});

  /// Indicates the name of the summary column.
  final String name;

  /// Indicates the name of the column.
  ///
  /// See also,
  ///
  /// [GridColumn.columnName] – the name of the column.
  final String columnName;

  /// Indicates the summary type which should be displayed for column.
  final GridSummaryType summaryType;
}

/// A material design datagrid.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=-ULsEfjxFuY}
///
/// DataGrid lets you display and manipulate data in a tabular view. It is built
/// from the ground up to achieve the best possible performance even when
/// loading large amounts of data.
///
/// DataGrid supports different types of column types to populate the columns
/// for different types of data such as int, double, DateTime, String.
///
/// [source] property enables you to populate the data for the [SfDataGrid].
///
/// This sample shows how to populate the data for the [SfDataGrid] and display
/// with four columns: id, name, designation and salary.
/// The columns are defined by four [GridColumn] objects.
///
/// ``` dart
///   final List<Employee> _employees = <Employee>[];
///   final EmployeeDataSource _employeeDataSource = EmployeeDataSource();
///
///   @override
///   void initState(){
///     super.initState();
///     populateData();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return SfDataGrid(
///       source: _employeeDataSource,
///       columnWidthMode: ColumnWidthMode.fill,
///       columns: <GridColumn>[
///         GridColumn(columnName: 'id', label: Text('ID')),
///         GridColumn(columnName: 'name', label: Text('Name')),
///         GridColumn(columnName: 'designation', label: Text('Designation')),
///         GridColumn(columnName: 'salary', label: Text('Salary')),
///     );
///   }
///
///   void populateData(){
///     _employees.add(Employee(10001, 'James', 'Project Lead', 10000));
///     _employees.add(Employee(10002, 'Kathryn', 'Manager', 10000));
///     _employees.add(Employee(10003, 'Lara', 'Developer', 10000));
///     _employees.add(Employee(10004, 'Michael', 'Designer', 10000));
///     _employees.add(Employee(10005, 'Martin', 'Developer', 10000));
///     _employees.add(Employee(10006, 'Newberry', 'Developer', 15000));
///     _employees.add(Employee(10007, 'Balnc', 'Developer', 15000));
/// 	  _employees.add(Employee(10008, 'Perry', 'Developer', 15000));
///     _employees.add(Employee(10009, 'Gable', 'Developer', 15000));
///     _employees.add(Employee(10010, 'Grimes', 'Developer', 15000));
///   }
/// }
///
/// class Employee {
///   Employee(this.id, this.name, this.designation, this.salary);
///   final int id;
///   final String name;
///   final String designation;
///   final int salary;
/// }
///
/// class EmployeeDataSource extends DataGridSource {
///   @override
///   List<DataGridRow> get rows => _employees
///       .map<DataGridRow>((dataRow) => DataGridRow(cells: [
///             DataGridCell<int>(columnName: 'id', value: dataRow.id),
///             DataGridCell<String>(columnName: 'name', value: dataRow.name),
///             DataGridCell<String>(
///                 columnName: 'designation', value: dataRow.designation),
///             DataGridCell<int>(columnName: 'salary', value: dataRow.salary),
///           ]))
///       .toList();
///
///   @override
///   DataGridRowAdapter? buildRow(DataGridRow row) {
///     return DataGridRowAdapter(
///         cells: row.getCells().map<Widget>((dataCell) {
///           return Text(dataCell.value.toString());
///         }).toList());
///   }
/// }
///
/// ```
class SfDataGrid extends StatefulWidget {
  /// Creates a widget describing a datagrid.
  ///
  /// The [columns] and [source] argument must be defined and must not be null.
  const SfDataGrid({
    required this.source,
    required this.columns,
    Key? key,
    this.rowHeight = double.nan,
    this.headerRowHeight = double.nan,
    this.defaultColumnWidth = double.nan,
    this.gridLinesVisibility = GridLinesVisibility.horizontal,
    this.headerGridLinesVisibility = GridLinesVisibility.horizontal,
    this.columnWidthMode = ColumnWidthMode.none,
    this.columnSizer,
    this.columnWidthCalculationRange = ColumnWidthCalculationRange.visibleRows,
    this.selectionMode = SelectionMode.none,
    this.navigationMode = GridNavigationMode.row,
    this.frozenColumnsCount = 0,
    this.footerFrozenColumnsCount = 0,
    this.frozenRowsCount = 0,
    this.footerFrozenRowsCount = 0,
    this.allowSorting = false,
    this.allowMultiColumnSorting = false,
    this.allowTriStateSorting = false,
    this.showSortNumbers = false,
    this.sortingGestureType = SortingGestureType.tap,
    this.stackedHeaderRows = const <StackedHeaderRow>[],
    this.selectionManager,
    this.controller,
    this.onQueryRowHeight,
    this.onSelectionChanged,
    this.onSelectionChanging,
    this.onCurrentCellActivating,
    this.onCurrentCellActivated,
    this.onCellTap,
    this.onCellDoubleTap,
    this.onCellSecondaryTap,
    this.onCellLongPress,
    this.isScrollbarAlwaysShown = false,
    this.horizontalScrollPhysics = const AlwaysScrollableScrollPhysics(),
    this.verticalScrollPhysics = const AlwaysScrollableScrollPhysics(),
    this.loadMoreViewBuilder,
    this.allowPullToRefresh = false,
    this.refreshIndicatorDisplacement = 40.0,
    this.refreshIndicatorStrokeWidth = 2.0,
    this.allowSwiping = false,
    this.swipeMaxOffset = 200.0,
    this.horizontalScrollController,
    this.verticalScrollController,
    this.onSwipeStart,
    this.onSwipeUpdate,
    this.onSwipeEnd,
    this.startSwipeActionsBuilder,
    this.endSwipeActionsBuilder,
    this.highlightRowOnHover = true,
    this.allowColumnsResizing = false,
    this.columnResizeMode = ColumnResizeMode.onResize,
    this.onColumnResizeStart,
    this.onColumnResizeUpdate,
    this.onColumnResizeEnd,
    this.allowEditing = false,
    this.editingGestureType = EditingGestureType.doubleTap,
    this.footer,
    this.footerHeight = 49.0,
    this.showCheckboxColumn = false,
    this.checkboxColumnSettings = const DataGridCheckboxColumnSettings(),
    this.tableSummaryRows = const <GridTableSummaryRow>[],
    this.rowsPerPage,
    this.shrinkWrapColumns = false,
    this.shrinkWrapRows = false,
    this.rowsCacheExtent,
    this.allowFiltering = false,
    this.onFilterChanging,
    this.onFilterChanged,
  })  : assert(frozenColumnsCount >= 0),
        assert(footerFrozenColumnsCount >= 0),
        assert(frozenRowsCount >= 0),
        assert(footerFrozenRowsCount >= 0),
        super(key: key);

  /// The height of each row except the column header.
  ///
  /// Defaults to 49.0
  final double rowHeight;

  /// The height of the column header row.
  ///
  /// Defaults to 56.0
  final double headerRowHeight;

  /// The collection of the [GridColumn].
  ///
  /// Defaults to empty.
  final List<GridColumn> columns;

  /// The [DataGridSource] that provides the data for each row in [SfDataGrid]. Must
  /// be non-null.
  ///
  /// This object is expected to be long-lived, not recreated with each build.
  ///
  /// Defaults to null
  final DataGridSource source;

  /// The width of each column.
  ///
  /// If the [columnWidthMode] is set for [SfDataGrid] or [GridColumn], or
  /// [GridColumn.width] is set, [defaultColumnWidth] will not be considered.
  ///
  /// Defaults to 90.0 for Android & iOS and 100.0 for Web.
  final double defaultColumnWidth;

  /// How the column widths are determined.
  ///
  /// Defaults to [ColumnWidthMode.none]
  ///
  /// Also refer [ColumnWidthMode]
  final ColumnWidthMode columnWidthMode;

  /// How the row count should be considered when calculating the width of a
  /// column.
  ///
  /// Provides options to consider only visible rows or all the rows which are
  /// available in [SfDataGrid].
  ///
  /// Defaults to [ColumnWidthCalculationRange.visibleRows]
  ///
  /// Also refer [ColumnWidthCalculationRange]
  final ColumnWidthCalculationRange columnWidthCalculationRange;

  /// The [ColumnSizer] used to control the column width sizing operation of
  /// each columns.
  ///
  /// You can override the available methods and customize the required
  /// operations in the custom [ColumnSizer].
  final ColumnSizer? columnSizer;

  /// How the border should be visible.
  ///
  /// Decides whether vertical, horizontal, both the borders and no borders
  /// should be drawn.
  ///
  /// Defaults to [GridLinesVisibility.horizontal]
  ///
  /// Also refer [GridLinesVisibility]
  final GridLinesVisibility gridLinesVisibility;

  /// How the border should be visible in header cells.
  ///
  /// Decides whether vertical or horizontal or both the borders or no borders
  /// should be drawn.
  ///
  /// [GridLinesVisibility.horizontal] will be useful if you are using
  /// [stackedHeaderRows] to improve the readability.
  ///
  /// Defaults to [GridLinesVisibility.horizontal]
  ///
  /// Also refer [GridLinesVisibility].
  ///
  /// See also, [gridLinesVisibility] – To set the border for cells other than
  /// header cells.
  final GridLinesVisibility headerGridLinesVisibility;

  /// Invoked when the row height for each row is queried.
  final QueryRowHeightCallback? onQueryRowHeight;

  /// How the rows should be selected.
  ///
  /// Provides options to select single row or multiple rows.
  ///
  /// Defaults to [SelectionMode.none].
  ///
  /// Also refer [SelectionMode]
  final SelectionMode selectionMode;

  /// Invoked when the row is selected.
  ///
  /// This callback never be called when the [onSelectionChanging] is returned
  /// as false.
  final SelectionChangedCallback? onSelectionChanged;

  /// Invoked when the row is being selected or being unselected
  ///
  /// This callback's return type is [bool]. So, if you want to cancel the
  /// selection on a row based on the condition, return false.
  /// Otherwise, return true.
  final SelectionChangingCallback? onSelectionChanging;

  /// The [SelectionManagerBase] used to control the selection operations
  /// in [SfDataGrid].
  ///
  /// You can override the available methods and customize the required
  /// operations in the custom [RowSelectionManager].
  ///
  /// Defaults to null
  final SelectionManagerBase? selectionManager;

  /// The [DataGridController] used to control the current cell navigation and
  /// selection operation.
  ///
  /// Defaults to null.
  ///
  /// This object is expected to be long-lived, not recreated with each build.
  final DataGridController? controller;

  /// Decides whether the navigation in the [SfDataGrid] should be cell wise
  /// or row wise.
  final GridNavigationMode navigationMode;

  /// Invoked when the cell is activated.
  ///
  /// This callback never be called when the [onCurrentCellActivating] is
  /// returned as false.
  final CurrentCellActivatedCallback? onCurrentCellActivated;

  /// Invoked when the cell is being activated.
  ///
  /// This callback's return type is [bool]. So, if you want to cancel cell
  /// activation based on the condition, return false. Otherwise,
  /// return true.
  final CurrentCellActivatingCallback? onCurrentCellActivating;

  /// Called when a tap with a cell has occurred.
  final DataGridCellTapCallback? onCellTap;

  /// Called when user is tapped a cell with a primary button at the same cell
  /// twice in quick succession.
  final DataGridCellDoubleTapCallback? onCellDoubleTap;

  /// Called when a tap with a cell has occurred with a secondary button.
  final DataGridCellTapCallback? onCellSecondaryTap;

  /// Called when a long press gesture with a primary button has been
  /// recognized for a cell.
  final DataGridCellLongPressCallback? onCellLongPress;

  /// The number of non-scrolling columns at the left side of [SfDataGrid].
  ///
  /// In Right To Left (RTL) mode, this count refers to the number of
  /// non-scrolling columns at the right side of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// * [footerFrozenColumnsCount]
  /// * [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// * [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
  /// color of the frozen line
  final int frozenColumnsCount;

  /// The number of non-scrolling columns at the right side of [SfDataGrid].
  ///
  /// In Right To Left (RTL) mode, this count refers to the number of
  /// non-scrolling columns at the left side of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// * [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// * [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
  /// color of the frozen line.
  final int footerFrozenColumnsCount;

  /// The number of non-scrolling rows at the top of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// * [footerFrozenRowsCount]
  /// * [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// * [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
  /// color of the frozen line.
  final int frozenRowsCount;

  /// The number of non-scrolling rows at the bottom of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// * [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// * [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
  /// color of the frozen line.
  final int footerFrozenRowsCount;

  /// Decides whether user can sort the column simply by tapping the column
  /// header.
  ///
  /// Defaults to false.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfDataGrid(
  ///     source: _employeeDataSource,
  ///     allowSorting: true,
  ///     columns: [
  ///         GridColumn(columnName: 'id', label: Text('ID')),
  ///         GridColumn(columnName: 'name', label: Text('Name')),
  ///         GridColumn(columnName: 'designation', label: Text('Designation')),
  ///         GridColumn(columnName: 'salary', label: Text('Salary')),
  ///   ]);
  /// }
  ///
  /// class EmployeeDataSource extends DataGridSource {
  ///   @override
  ///   List<DataGridRow> get rows => _employees
  ///       .map<DataGridRow>((dataRow) => DataGridRow(cells: [
  ///             DataGridCell<int>(columnName: 'id', value: dataRow.id),
  ///             DataGridCell<String>(columnName: 'name', value: dataRow.name),
  ///             DataGridCell<String>(
  ///                 columnName: 'designation', value: dataRow.designation),
  ///             DataGridCell<int>(columnName: 'salary', value: dataRow.salary),
  ///           ]))
  ///       .toList();
  ///
  ///   @override
  ///   DataGridRowAdapter? buildRow(DataGridRow row) {
  ///     return DataGridRowAdapter(
  ///         cells: row.getCells().map<Widget>((dataCell) {
  ///       return Text(dataCell.value.toString());
  ///     }).toList());
  ///   }
  /// }
  ///
  /// ```
  ///
  ///
  /// See also:
  ///
  /// * [GridColumn.allowSorting] - which allows users to sort the columns in
  /// [SfDataGrid].
  /// * [sortingGestureType] – which allows users to sort the column in tap or
  /// double tap.
  /// * [DataGridSource.sortedColumns] - which is the collection of
  /// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  final bool allowSorting;

  /// Decides whether user can sort more than one column.
  ///
  /// Defaults to false.
  ///
  /// This is applicable only if the [allowSorting] is set as true.
  ///
  /// See also:
  ///
  /// * [DataGridSource.sortedColumns] - which is the collection of
  /// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  final bool allowMultiColumnSorting;

  /// Decides whether user can sort the column in three states: ascending,
  /// descending, unsorted.
  ///
  /// Defaults to false.
  ///
  /// This is applicable only if the [allowSorting] is set as true.
  ///
  /// See also:
  ///
  /// * [DataGridSource.sortedColumns] - which is the collection of
  /// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  final bool allowTriStateSorting;

  /// Decides whether the sequence number should be displayed on the header cell
  ///  of sorted column during multi-column sorting.
  ///
  /// Defaults to false
  ///
  /// This is applicable only if the [allowSorting] and
  /// [allowMultiColumnSorting] are set as true.
  ///
  /// See also:
  ///
  /// * [DataGridSource.sortedColumns] - which is the collection of
  /// [SortColumnDetails] objects to sort the columns in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  final bool showSortNumbers;

  /// Decides whether the sorting should be applied on tap or double tap the
  /// column header.
  ///
  /// Default to [SortingGestureType.tap]
  ///
  /// see also:
  ///
  /// [allowSorting]
  final SortingGestureType sortingGestureType;

  /// The collection of [StackedHeaderRow].
  ///
  /// Stacked headers enable you to display headers that span across multiple
  /// columns and rows. These rows are displayed above to the regular column
  /// headers.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfDataGrid(source: _employeeDataSource, columns: <GridColumn>[
  ///     GridColumn(columnName: 'id', label: Text('ID')),
  ///     GridColumn(columnName: 'name', label: Text('Name')),
  ///     GridColumn(columnName: 'designation', label: Text('Designation')),
  ///     GridColumn(columnName: 'salary', label: Text('Salary'))
  ///   ], stackedHeaderRows: [
  ///     StackedHeaderRow(cells: [
  ///       StackedHeaderCell(
  ///         columnNames: ['id', 'name', 'designation', 'salary'],
  ///         child: Center(
  ///           child: Text('Order Details'),
  ///         ),
  ///       ),
  ///     ])
  ///   ]);
  /// }
  /// ```
  final List<StackedHeaderRow> stackedHeaderRows;

  /// Indicates whether the horizontal and vertical scrollbars should always
  /// be visible. When false, both the scrollbar will be shown during scrolling
  /// and will fade out otherwise. When true, both the scrollbar will always be
  /// visible and never fade out.
  ///
  /// Defaults to false
  final bool isScrollbarAlwaysShown;

  /// How the horizontal scroll view should respond to user input.
  /// For example, determines how the horizontal scroll view continues to animate after the user stops dragging the scroll view.
  ///
  /// Defaults to [AlwaysScrollableScrollPhysics].
  final ScrollPhysics horizontalScrollPhysics;

  /// How the vertical scroll view should respond to user input.
  /// For example, determines how the vertical scroll view continues to animate after the user stops dragging the scroll view.
  ///
  /// Defaults to [AlwaysScrollableScrollPhysics].
  final ScrollPhysics verticalScrollPhysics;

  /// A builder that sets the widget to display at the bottom of the datagrid
  /// when vertical scrolling reaches the end of the datagrid.
  ///
  /// You should override [DataGridSource.handleLoadMoreRows] method to load
  /// more rows and then notify the datagrid about the changes. The
  /// [DataGridSource.handleLoadMoreRows] can be called to load more rows from
  /// this builder using `loadMoreRows` function which is passed as a parameter
  /// to this builder.
  ///
  /// ## Infinite scrolling
  ///
  /// The example below demonstrates infinite scrolling by showing the circular
  /// progress indicator until the rows are loaded when vertical scrolling
  /// reaches the end of the datagrid,
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(title: Text('Syncfusion Flutter DataGrid')),
  ///     body: SfDataGrid(
  ///       source: employeeDataSource,
  ///       loadMoreViewBuilder:
  ///           (BuildContext context, LoadMoreRows loadMoreRows) {
  ///         Future<String> loadRows() async {
  ///           await loadMoreRows();
  ///           return Future<String>.value('Completed');
  ///         }
  ///
  ///         return FutureBuilder<String>(
  ///           initialData: 'loading',
  ///           future: loadRows(),
  ///           builder: (context, snapShot) {
  ///             if (snapShot.data == 'loading') {
  ///               return Container(
  ///                   height: 98.0,
  ///                   color: Colors.white,
  ///                   width: double.infinity,
  ///                   alignment: Alignment.center,
  ///                   child: CircularProgressIndicator(valueColor:
  ///                             AlwaysStoppedAnimation(Colors.deepPurple)));
  ///             } else {
  ///               return SizedBox.fromSize(size: Size.zero);
  ///             }
  ///           },
  ///         );
  ///       },
  ///       columns: <GridColumn>[
  ///           GridColumn(columnName: 'id', label: Text('ID')),
  ///           GridColumn(columnName: 'name', label: Text('Name')),
  ///           GridColumn(columnName: 'designation', label: Text('Designation')),
  ///           GridColumn(columnName: 'salary', label: Text('Salary')),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// ## Load more button
  ///
  /// The example below demonstrates how to show the button when vertical
  /// scrolling is reached at the end of the datagrid and display the circular
  /// indicator when you tap that button. In the onPressed flatbutton callback,
  /// you can call the `loadMoreRows` function to add more rows.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(title: Text('Syncfusion Flutter DataGrid')),
  ///     body: SfDataGrid(
  ///       source: employeeDataSource,
  ///       loadMoreViewBuilder:
  ///           (BuildContext context, LoadMoreRows loadMoreRows) {
  ///         bool showIndicator = false;
  ///         return StatefulBuilder(
  ///             builder: (BuildContext context, StateSetter setState) {
  ///           if (showIndicator) {
  ///             return Container(
  ///                 height: 98.0,
  ///                 color: Colors.white,
  ///                 width: double.infinity,
  ///                 alignment: Alignment.center,
  ///                 child: CircularProgressIndicator(valueColor:
  ///                           AlwaysStoppedAnimation(Colors.deepPurple)));
  ///           } else {
  ///             return Container(
  ///               height: 98.0,
  ///               color: Colors.white,
  ///               width: double.infinity,
  ///               alignment: Alignment.center,
  ///               child: Container(
  ///                 height: 36.0,
  ///                 width: 142.0,
  ///                 child: FlatButton(
  ///                   color: Colors.deepPurple,
  ///                   child: Text('LOAD MORE',
  ///                       style: TextStyle(color: Colors.white)),
  ///                   onPressed: () async {
  ///                     if (context is StatefulElement &&
  ///                         context.state != null &&
  ///                         context.state.mounted) {
  ///                       setState(() {
  ///                         showIndicator = true;
  ///                       });
  ///                     }
  ///                     await loadMoreRows();
  ///                     if (context is StatefulElement &&
  ///                         context.state != null &&
  ///                         context.state.mounted) {
  ///                       setState(() {
  ///                         showIndicator = false;
  ///                       });
  ///                     }
  ///                   },
  ///                 ),
  ///               ),
  ///             );
  ///           }
  ///         });
  ///       },
  ///       columns: <GridColumn>[
  ///           GridColumn(columnName: 'id', label: Text('ID')),
  ///           GridColumn(columnName: 'name', label: Text('Name')),
  ///           GridColumn(columnName: 'designation', label: Text('Designation')),
  ///           GridColumn(columnName: 'salary', label: Text('Salary')),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final LoadMoreViewBuilder? loadMoreViewBuilder;

  /// Decides whether refresh indicator should be shown when datagrid is pulled
  /// down.
  ///
  /// See also,
  ///
  /// [DataGridSource.handleRefresh] – This will be called when datagrid
  /// is pulled down to refresh the data.
  final bool allowPullToRefresh;

  /// The distance from the [SfDataGrid]’s top or bottom edge to where the refresh
  /// indicator will settle. During the drag that exposes the refresh indicator,
  /// its actual displacement may significantly exceed this value.
  ///
  /// By default, the value of `refreshIndicatorDisplacement` is 40.0.
  final double refreshIndicatorDisplacement;

  /// Defines `strokeWidth` for `RefreshIndicator` used by [SfDataGrid].
  ///
  /// By default, the value of `refreshIndicatorStrokeWidth` is 2.0 pixels.
  final double refreshIndicatorStrokeWidth;

  /// Decides whether to swipe a row “right to left” or “left to right” for custom
  /// actions such as deleting, editing, and so on. When the user swipes a row,
  /// the row will be moved, and swipe view will be shown for custom actions.
  ///
  /// You can show the widgets for left or right swipe view using
  /// [SfDataGrid.startSwipeActionsBuilder] and [SfDataGrid.endSwipeActionsBuilder].
  ///
  /// See also,
  ///
  /// * [SfDataGrid.onSwipeStart]
  /// * [SfDataGrid.onSwipeUpdate]
  /// * [SfDataGrid.onSwipeEnd]
  final bool allowSwiping;

  /// Defines the maximum offset in which a row can be swiped.
  ///
  /// Defaults to 200.
  final double swipeMaxOffset;

  /// Controls a horizontal scrolling in DataGrid.
  ///
  /// You can use addListener method to listen whenever you do the horizontal scrolling.
  ///
  final ScrollController? horizontalScrollController;

  /// Controls a vertical scrolling in DataGrid.
  ///
  /// You can use addListener method to listen whenever you do the vertical scrolling.
  ///
  final ScrollController? verticalScrollController;

  /// Called when row swiping is started.
  ///
  /// You can disable the swiping for specific row by returning false.
  final DataGridSwipeStartCallback? onSwipeStart;

  /// Called when row is being swiped.
  ///
  /// You can disable the swiping for specific requirement on swiping itself by
  /// returning false.
  final DataGridSwipeUpdateCallback? onSwipeUpdate;

  /// Called when swiping of a row is ended (i.e. when reaches the max offset).
  final DataGridSwipeEndCallback? onSwipeEnd;

  /// A builder that sets the widget for the background view in which a row is
  /// swiped in the reading direction (e.g., from left to right in left-to-right
  /// languages).
  final DataGridSwipeActionsBuilder? startSwipeActionsBuilder;

  /// A builder that sets the widget for the background view in which a row is
  /// swiped in the reverse of reading direction (e.g., from right to left in
  /// left-to-right languages).
  final DataGridSwipeActionsBuilder? endSwipeActionsBuilder;

  /// Decides whether to highlight a row when mouse hovers over it.
  ///
  /// see also,
  ///
  /// * [SfDataGridThemeData.rowHoverColor] – This helps you to change row highlighting color on hovering.
  /// * [SfDataGridThemeData.rowHoverTextStyle] – This helps you to change the [TextStyle] of row on hovering.
  final bool highlightRowOnHover;

  /// Decides whether a column can be resized by the user interactively using a
  /// pointer or not.
  ///
  /// In mobile platforms, resize indicator will be shown on the right side
  /// border of the column header when the user long-press a column header. Then,
  /// users tap and drag the resizing indicator to perform the column resizing.
  ///
  /// In web and desktop platforms, resizing can be performed by clicking and dragging the
  /// right side (left side in RTL mode) border of a column header.
  ///
  /// DataGrid does not automatically resize the columns when you perform column
  /// resizing. You should maintain the column width collection at the application
  /// level and set the column width of corresponding column using the
  /// [SfDataGrid.onColumnResizeUpdate] callback.
  ///
  /// The column width must be set inside the `setState` method to refresh
  /// the DataGrid.
  ///
  /// If you want to disable the column resizing for specific columns,
  /// return `false` for the specific columns in [SfDataGrid.onColumnResizeStart].
  ///
  /// The following example shows how to set the column width when
  /// resizing a column.
  ///
  ///  ```dart
  /// Map<String, double> columnWidths = {
  ///   'id': double.nan,
  ///   'name': double.nan,
  ///   'designation': double.nan,
  ///   'salary': double.nan
  /// };
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text('Syncfusion Flutter DataGrid'),
  ///     ),
  ///     body: SfDataGrid(
  ///       source: employeeDataSource,
  ///       allowColumnsResizing: true,
  ///       onColumnResizeUpdate: (details) {
  ///         setState(() {
  ///           columnWidths[details.column.columnName] = details.width;
  ///         });
  ///         return true;
  ///       },
  ///       columns: <GridColumn>[
  ///         GridColumn(
  ///             columnName: 'id',
  ///             width: columnWidths['id']!,
  ///             label: Container(
  ///                 padding: const EdgeInsets.all(16.0),
  ///                 alignment: Alignment.center,
  ///                 child: const Text(
  ///                   'ID',
  ///                 ))),
  ///         GridColumn(
  ///             columnName: 'name',
  ///             width: columnWidths['name']!,
  ///             label: Container(
  ///                 padding: const EdgeInsets.all(8.0),
  ///                 alignment: Alignment.center,
  ///                 child: const Text('Name'))),
  ///         GridColumn(
  ///             columnName: 'designation',
  ///             width: columnWidths['designation']!,
  ///             label: Container(
  ///                 padding: const EdgeInsets.all(8.0),
  ///                 alignment: Alignment.center,
  ///                 child: const Text(
  ///                   'Designation',
  ///                   overflow: TextOverflow.ellipsis,
  ///                 ))),
  ///         GridColumn(
  ///             columnName: 'salary',
  ///             width: columnWidths['salary']!,
  ///             label: Container(
  ///                 padding: const EdgeInsets.all(8.0),
  ///                 alignment: Alignment.center,
  ///                 child: const Text('Salary'))),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///  ```
  ///
  /// Defaults to false.
  ///
  /// See also,
  ///
  /// * [SfDataGrid.onColumnResizeStart]
  /// * [SfDataGrid.onColumnResizeUpdate]
  /// * [SfDataGrid.onColumnResizeEnd]
  final bool allowColumnsResizing;

  /// Decides how column should be resized. It can be either along with indicator moves or releasing a pointer.
  ///
  /// See also [ColumnResizeMode]
  final ColumnResizeMode columnResizeMode;

  /// Called when a column is being resized when tapping and dragging the right-side border of the column header.
  ///
  /// You can return `false` to disable the column resizing.
  final ColumnResizeStartCallback? onColumnResizeStart;

  /// Called when a column is resizing when tapping and dragging the right-side border of the column header.
  ///
  /// You can return `false` to disable the column resizing.
  final ColumnResizeUpdateCallback? onColumnResizeUpdate;

  /// Called when a column is resized successfully.
  final ColumnResizeEndCallback? onColumnResizeEnd;

  /// Decides whether cell should be moved into edit mode based on
  /// [editingGestureType].
  ///
  /// Defaults to false.
  ///
  /// Editing can be enabled only if the [selectionMode] is other than none and
  /// [navigationMode] is cell.
  ///
  /// You can load the required widget on editing using [DataGridSource.buildEditWidget] method.
  ///
  /// The following example shows how to load the [TextField] for `id` column
  /// by overriding the `onCellSubmit` and `buildEditWidget` methods in
  /// [DataGridSource] class.
  ///
  /// ```dart
  ///
  /// class EmployeeDataSource extends DataGridSource {
  ///
  ///  TextEditingController editingController = TextEditingController();
  ///
  ///  dynamic newCellValue;
  ///
  ///  /// Creates the employee data source class with required details.
  ///   EmployeeDataSource({required List<Employee> employeeData}) {
  ///     employees = employeeData;
  ///     _employeeData = employeeData
  ///         .map<DataGridRow>((e) => DataGridRow(cells: [
  ///               DataGridCell<int>(columnName: 'id', value: e.id),
  ///               DataGridCell<String>(columnName: 'name', value: e.name),
  ///               DataGridCell<String>(
  ///                   columnName: 'designation', value: e.designation),
  ///               DataGridCell<int>(columnName: 'salary', value: e.salary),
  ///             ]))
  ///         .toList();
  ///   }
  ///
  ///   List<DataGridRow> _employeeData = [];
  ///
  ///   List<Employee> employees = [];
  ///
  ///   @override
  ///   List<DataGridRow> get rows => _employeeData;
  ///
  ///   @override
  ///   DataGridRowAdapter buildRow(DataGridRow row) {
  ///     return DataGridRowAdapter(
  ///         cells: row.getCells().map<Widget>((e) {
  ///       return Container(
  ///         alignment: (e.columnName == 'id' || e.columnName == 'salary')
  ///             ? Alignment.centerRight
  ///             : Alignment.centerLeft,
  ///         padding: EdgeInsets.all(8.0),
  ///         child: Text(e.value.toString()),
  ///       );
  ///     }).toList());
  ///   }
  ///
  ///   @override
  ///   Widget? buildEditWidget(DataGridRow dataGridRow,
  ///       RowColumnIndex rowColumnIndex, GridColumn column, submitCell) {
  ///     // To set the value for TextField when cell is moved into edit mode.
  ///     final String displayText = dataGridRow
  ///             .getCells()
  ///             .firstWhere((DataGridCell dataGridCell) =>
  ///                 dataGridCell.columnName == column.columnName)
  ///             .value
  ///             ?.toString() ??
  ///         '';
  ///
  ///     /// Returning the TextField with the numeric keyboard configuration.
  ///     if (column.columnName == 'id') {
  ///       return Container(
  ///           padding: const EdgeInsets.all(8.0),
  ///           alignment: Alignment.centerRight,
  ///           child: TextField(
  ///             autofocus: true,
  ///             controller: editingController..text = displayText,
  ///             textAlign: TextAlign.right,
  ///             decoration: const InputDecoration(
  ///                 contentPadding: EdgeInsets.all(0),
  ///                 border: InputBorder.none,
  ///                 isDense: true),
  ///             inputFormatters: [
  ///               FilteringTextInputFormatter.allow(RegExp('[0-9]'))
  ///             ],
  ///             keyboardType: TextInputType.number,
  ///             onChanged: (String value) {
  ///               if (value.isNotEmpty) {
  ///                 print(value);
  ///                 newCellValue = int.parse(value);
  ///               } else {
  ///                 newCellValue = null;
  ///               }
  ///             },
  ///             onSubmitted: (String value) {
  ///               /// Call [CellSubmit] callback to fire the canSubmitCell and
  ///               /// onCellSubmit to commit the new value in single place.
  ///               submitCell();
  ///             },
  ///           ));
  ///     }
  ///   }
  ///
  ///   @override
  ///   void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
  ///       GridColumn column) {
  ///     final dynamic oldValue = dataGridRow
  ///             .getCells()
  ///             .firstWhereOrNull((DataGridCell dataGridCell) =>
  ///                 dataGridCell.columnName == column.columnName)
  ///             ?.value ??
  ///         '';
  ///
  ///     final int dataRowIndex = rows.indexOf(dataGridRow);
  ///
  ///     if (newCellValue == null || oldValue == newCellValue) {
  ///       return;
  ///     }
  ///
  ///     if (column.columnName == 'id') {
  ///       rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
  ///           DataGridCell<int>(columnName: 'id', value: newCellValue);
  ///
  ///       // Save the new cell value to model collection also.
  ///       employees[dataRowIndex].id = newCellValue as int;
  ///     }
  ///
  ///     // To reset the new cell value after successfully updated to DataGridRow
  ///     //and underlying mode.
  ///     newCellValue = null;
  ///   }
  /// }
  ///
  /// ```
  /// The following example shows how to enable editing and set the
  /// [DataGridSource] for [SfDataGrid].
  /// ```dart
  ///
  /// List<Employee> employees = <Employee>[];
  ///
  /// late EmployeeDataSource employeeDataSource;
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   employees = getEmployeeData();
  ///   employeeDataSource = EmployeeDataSource(employeeData: employees);
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text('Syncfusion Flutter DataGrid'),
  ///     ),
  ///     body: SfDataGrid(
  ///       source: employeeDataSource,
  ///       allowEditing: true,
  ///       columnWidthMode: ColumnWidthMode.fill,
  ///       selectionMode: SelectionMode.single,
  ///       navigationMode: GridNavigationMode.cell,
  ///       columns: <GridColumn>[
  ///         GridColumn(
  ///             columnName: 'id',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(16.0),
  ///                 alignment: Alignment.centerRight,
  ///                 child: Text(
  ///                   'ID',
  ///                 ))),
  ///         GridColumn(
  ///             columnName: 'name',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(8.0),
  ///                 alignment: Alignment.centerLeft,
  ///                 child: Text('Name'))),
  ///         GridColumn(
  ///             columnName: 'designation',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(8.0),
  ///                 alignment: Alignment.centerLeft,
  ///                 child: Text(
  ///                   'Designation',
  ///                   overflow: TextOverflow.ellipsis,
  ///                 ))),
  ///         GridColumn(
  ///             columnName: 'salary',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(8.0),
  ///                 alignment: Alignment.centerRight,
  ///                 child: Text('Salary'))),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  /// See also,
  /// * [GridColumn.allowEditing] – You can enable or disable editing for an
  /// individual column.
  /// * [DataGridSource.onCellBeginEdit]- This will be triggered when a cell is
  /// moved to edit mode.
  /// * [DataGridSource.canSubmitCell]- This will be triggered before
  /// [DataGridSource.onCellSubmit] method is called. You can use this method
  /// if you want to not end the editing based on any criteria.
  /// * [DataGridSource.onCellSubmit] – This will be triggered when the cell’s
  /// editing is completed.
  final bool allowEditing;

  /// Decides whether the editing should be triggered on tap or double tap
  /// the cells.
  ///
  /// Defaults to [EditingGestureType.doubleTap].
  ///
  /// See also,
  /// * [allowEditing] – This will enable the editing option for cells.
  final EditingGestureType editingGestureType;

  /// The widget to show over the bottom of the [SfDataGrid].
  ///
  /// This footer will be displayed like normal row and shown below to last row.
  ///
  /// See also,
  ///
  /// [SfDataGrid.footerHeight] – This enables you to change the height of the
  /// footer.
  final Widget? footer;

  /// The height of the footer.
  ///
  /// Defaults to 49.0.
  final double footerHeight;

  /// Decides whether [Checkbox] should be displayed in each row to select or
  /// deselect the rows.
  ///
  /// Defaults to false.
  ///
  /// If true, [Checkbox] column will be added at the beginning of each row.
  /// Rows can be selected only if the [SfDataGrid.selectionMode] is other than
  /// none.
  ///
  /// [SfDataGrid.onSelectionChanging] and [SfDataGrid.onSelectionChanging]
  /// callbacks will be called whenever you select the rows using [Checkbox] in
  /// each row.
  ///
  /// See also,
  /// [SfDataGrid.checkboxColumnSettings] – Provides the customization options
  /// to the checkbox column.
  final bool showCheckboxColumn;

  /// Whether the extent of the horizontal scroll view should be determined by the number of columns available.
  ///
  /// By default, if the DataGrid’s parent width is infinity, width is set as 300. If `shrinkWrapColumns` property is true, the width is expanding to view all the columns available in DataGrid.
  ///
  /// Shrink wrapping is significantly more expensive than setting the width manually.
  ///
  /// See also,
  ///
  ///[shrinkWrapRows] -  Whether the extent of the vertical scroll view should be determined by the number of rows available.
  final bool shrinkWrapColumns;

  /// Whether the extent of the vertical scroll view should be determined by the number of rows available.
  ///
  /// By default, if the DataGrid’s parent height is infinity, height is set as 300. If `shrinkWrapRows` property is true, the height is expanding to view all the rows available in DataGrid.
  ///
  /// Shrink wrapping is significantly more expensive than setting the height manually.
  ///
  /// See also,
  ///
  /// [shrinkWrapColumns] - Whether the extent of the horizontal scroll view should be determined by the number of columns available.
  final bool shrinkWrapRows;

  /// Contains all the properties of the checkbox column.
  ///
  /// This settings are applied to checkbox column, only if
  /// [SfDataGrid.showCheckboxColumn] is `true`.
  final DataGridCheckboxColumnSettings checkboxColumnSettings;

  /// The collection of [GridTableSummaryRow].
  ///
  /// This enables you to show the total or summary for columns i.e Max, Min,
  /// Average, and Count for the whole DataGrid.
  ///
  /// Load the required widget in summary cell by overriding and returning the
  /// widget in [DataGridSource.buildTableSummaryCellWidget] method.
  ///
  /// The following example shows how to display the table summary rows at the top
  /// and bottom with different options.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text('Syncfusion Flutter DataGrid'),
  ///     ),
  ///     body: SfDataGrid(
  ///       source: employeeDataSource,
  ///       tableSummaryRows: [
  ///         GridTableSummaryRow(
  ///             showSummaryInRow: true,
  ///             title: 'Total Employee Count: {Count}',
  ///             columns: [
  ///               GridSummaryColumn(
  ///                   name: 'Count',
  ///                   columnName: 'name',
  ///                   summaryType: GridSummaryType.count)
  ///             ],
  ///             position: GridTableSummaryRowPosition.top),
  ///         GridTableSummaryRow(
  ///             showSummaryInRow: false,
  ///             columns: [
  ///               GridSummaryColumn(
  ///                   name: 'Sum',
  ///                   columnName: 'salary',
  ///                   summaryType: GridSummaryType.sum)
  ///             ],
  ///             position: GridTableSummaryRowPosition.bottom)
  ///       ],
  ///       columns: <GridColumn>[
  ///         GridColumn(
  ///             columnName: 'id',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(16.0),
  ///                 alignment: Alignment.center,
  ///                 child: Text(
  ///                   'ID',
  ///                 ))),
  ///         GridColumn(
  ///             columnName: 'name',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(8.0),
  ///                 alignment: Alignment.center,
  ///                 child: Text('Name'))),
  ///         GridColumn(
  ///             columnName: 'designation',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(8.0),
  ///                 alignment: Alignment.center,
  ///                 child: Text(
  ///                   'Designation',
  ///                   overflow: TextOverflow.ellipsis,
  ///                 ))),
  ///         GridColumn(
  ///             columnName: 'salary',
  ///             label: Container(
  ///                 padding: EdgeInsets.all(8.0),
  ///                 alignment: Alignment.center,
  ///                 child: Text('Salary'))),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
  /// class EmployeeDataSource extends DataGridSource {
  /// @override
  /// Widget? buildTableSummaryCellWidget(
  ///     GridTableSummaryRow summaryRow,
  ///     GridSummaryColumn? summaryColumn,
  ///     RowColumnIndex rowColumnIndex,
  ///     String summaryValue) {
  ///   return Container(
  ///       padding: EdgeInsets.all(16.0),
  ///       alignment: Alignment.centerLeft,
  ///       child: Text(summaryValue));
  /// }
  /// ```
  final List<GridTableSummaryRow> tableSummaryRows;

  /// The number of rows to show on each page.
  ///
  /// This property is applicable only if the [SfDataPager] is used to represent
  /// the paging functionality.
  ///
  /// If you set the value as null, the rows per page is automatically decided
  /// based on divided value of the number of rows loaded through [DataGridSource.rows] by [SfDataPager.pageCount].
  ///
  /// If you want to maintain the rows per page constantly the same, set the required number of rows to this property.
  final int? rowsPerPage;

  /// Decides how many rows should be added with the currently visible items in viewport size.
  ///
  /// By default, the rows which are presented in viewport will be re-used
  /// when the vertical scrolling is performed for better performance.
  ///
  /// You can set the rows cache extent to avoid the visible changes which are occurred
  /// due to re-using. For example, if you are showing the checkbox in a column and
  /// not set the rows using this property, checkbox state changes with the
  /// animation can be seen when vertical scrolling is perform
  final int? rowsCacheExtent;

  /// Decides whether the UI filtering should be enabled for all the columns.
  ///
  /// [GridColumn.allowFiltering] has the highest priority over this property.
  ///
  /// See also,
  /// * [SfDataGrid.onFilterChanging] – This callback will be called if the
  /// column is being filtered through UI filtering.
  /// * [SfDataGrid.onFilterChanged] – This callback will be called if the
  /// column is filtered through UI filtering.
  /// * [DataGridSource.filterConditions] – This property holds the
  /// collection of the filter conditions which are applied for various columns.
  final bool allowFiltering;

  /// Called when the filtering is being applied through UI filtering.
  ///
  /// You can return `false` from this callback to restrict the column from
  /// being filtered.
  final DataGridFilterChangingCallback? onFilterChanging;

  /// Called after the UI filtering is applied to [SfDataGrid].
  ///
  /// This callback will not be triggered when the filter conditions are added
  /// programmatically.
  final DataGridFilterChangedCallback? onFilterChanged;

  @override
  State<StatefulWidget> createState() => SfDataGridState();
}

/// Contains the state for a [SfDataGrid]. This class can be used to
/// programmatically show the refresh indicator, see the [refresh]
/// method.
class SfDataGridState extends State<SfDataGrid>
    with SingleTickerProviderStateMixin {
  static const double _minWidth = 300.0;
  static const double _minHeight = 300.0;
  static const double _rowHeight = 49.0;
  static const double _headerRowHeight = 56.0;

  late RowGenerator _rowGenerator;
  late VisualContainerHelper _container;
  late DataGridConfiguration _dataGridConfiguration;
  AnimationController? _swipingAnimationController;

  late Map<String, GridCellRendererBase> _cellRenderers;
  TextDirection _textDirection = TextDirection.ltr;
  SfDataGridThemeData? _dataGridThemeData;
  DataGridThemeHelper? _dataGridThemeHelper;
  SfLocalizations? _localizations;
  DataGridSource? _source;
  List<GridColumn>? _columns;
  SelectionManagerBase? _rowSelectionManager;
  DataGridController? _controller;
  Animation<double>? _swipingAnimation;
  DataGridStateDetails? _dataGridStateDetails;

  Size? _screenSize;

  @override
  void initState() {
    _columns = <GridColumn>[];
    _dataGridConfiguration = DataGridConfiguration();
    _dataGridStateDetails = _onDataGridStateDetailsChanged;
    _dataGridConfiguration.gridPaint = Paint();

    _rowGenerator = RowGenerator(dataGridStateDetails: _dataGridStateDetails!);
    _container = VisualContainerHelper(
        rowGenerator: _rowGenerator,
        dataGridStateDetails: _dataGridStateDetails!);
    _swipingAnimationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _setUp();
    _updateDataGridStateDetails();
    super.initState();
  }

  void _onDataGridTextDirectionChanged(TextDirection? newTextDirection) {
    if (newTextDirection == null || _textDirection == newTextDirection) {
      return;
    }

    _textDirection = newTextDirection;
    _dataGridConfiguration.textDirection = newTextDirection;
    _container.needToSetHorizontalOffset = true;
  }

  void _onDataGridThemeDataChanged(
      SfDataGridThemeData? newThemeData, ColorScheme? newColorScheme) {
    // Refreshes the data grid rows when the `SfDataGridThemeData` or
    // `ThemeData.colorScheme` is changed at runtime.
    if (_dataGridThemeData == newThemeData &&
        _dataGridConfiguration.colorScheme == newColorScheme) {
      return;
    }

    bool canRefreshView = false;
    if (newThemeData != null && _dataGridThemeData != newThemeData) {
      _dataGridThemeData = newThemeData;
      canRefreshView = true;
    }

    if (newColorScheme != null &&
        _dataGridConfiguration.colorScheme != newColorScheme) {
      _dataGridConfiguration.colorScheme = newColorScheme;
      canRefreshView = true;
    }

    if (canRefreshView) {
      _dataGridThemeHelper = DataGridThemeHelper(
          _dataGridThemeData, _dataGridConfiguration.colorScheme);
      _dataGridConfiguration.dataGridThemeHelper = _dataGridThemeHelper;
      _updateDecoration();
      _container.refreshViewStyle();
    }
  }

  void _onDataGridTextScaleFactorChanged(double textScaleFactor) {
    if (textScaleFactor == _dataGridConfiguration.textScaleFactor) {
      return;
    }

    _dataGridConfiguration.textScaleFactor = textScaleFactor;
    _dataGridConfiguration.headerRowHeight = widget.headerRowHeight.isNaN
        ? (_dataGridConfiguration.textScaleFactor > 1.0)
            ? _headerRowHeight * _dataGridConfiguration.textScaleFactor
            : _headerRowHeight
        : widget.headerRowHeight;
    _dataGridConfiguration.rowHeight = widget.rowHeight.isNaN
        ? (_dataGridConfiguration.textScaleFactor > 1.0)
            ? _rowHeight * _dataGridConfiguration.textScaleFactor
            : _rowHeight
        : widget.rowHeight;
    // Refreshes the default line size, column widths and row heights in initial
    // `SfDataGrid` build. So, restricts the codes in initial loading by using
    // the `_container.isGridLoaded` property.
    if (_container.isGridLoaded) {
      if (_dataGridConfiguration.columnWidthMode != ColumnWidthMode.none) {
        resetAutoCalculation(_dataGridConfiguration.columnSizer);
        if (!_container.isDirty) {
          // Refreshes the autofit columns only if don't have explicit width.
          refreshColumnSizer(_dataGridConfiguration.columnSizer, 0.0);
        }
      }
      // Refresh header rows height.
      _updateHeaderRowHeight();
      // Refresh data rows height.
      _container.rowHeights.defaultLineSize = _dataGridConfiguration.rowHeight;
      if (!_container.isDirty) {
        _container.setRowHeights();
      }
    }
  }

  void _onDataGridLocalizationsChanged(SfLocalizations newLocalizations) {
    if (_localizations != newLocalizations) {
      _localizations = newLocalizations;
      _dataGridConfiguration
        ..localizations = newLocalizations
        ..dataGridFilterHelper.advancedFilterHelper.initProperties();
    }
  }

  void _updateHeaderRowHeight() {
    final LineSizeCollection lineSizeCollection =
        _container.columnWidths as LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    final int headerIndex = grid_helper.getHeaderIndex(_dataGridConfiguration);
    if (_container.rowCount > 0) {
      for (int i = 0; i <= headerIndex; i++) {
        _container.rowHeights[i] = _dataGridConfiguration.headerRowHeight;
      }
    }
    lineSizeCollection.resumeUpdates();
    _container.updateScrollBars();
  }

  void _setUp() {
    _initializeDataGridDataSource();
    _initializeCellRendererCollection();

    //DataGrid Controller
    _controller = _dataGridConfiguration.controller =
        widget.controller ?? DataGridController()
          .._dataGridStateDetails = _dataGridStateDetails;

    _controller!._addDataGridPropertyChangeListener(
        _handleDataGridPropertyChangeListeners);
    if (widget.verticalScrollController != null) {
      _dataGridConfiguration.disposeVerticalScrollController = false;
    }
    if (widget.horizontalScrollController != null) {
      _dataGridConfiguration.disposeHorizontalScrollController = false;
    }

    _dataGridConfiguration.verticalScrollController =
        widget.verticalScrollController ?? ScrollController();
    _dataGridConfiguration.horizontalScrollController =
        widget.horizontalScrollController ?? ScrollController();

    //AutoFit controller initializing
    _dataGridConfiguration.columnSizer = widget.columnSizer ?? ColumnSizer();
    setStateDetailsInColumnSizer(
        _dataGridConfiguration.columnSizer, _dataGridStateDetails!);

    //CurrentCell Manager initializing
    _dataGridConfiguration.currentCell =
        CurrentCellManager(_dataGridStateDetails!);
    _dataGridConfiguration.dataGridFilterHelper =
        DataGridFilterHelper(_dataGridStateDetails!);

    //Selection Manager initializing
    _rowSelectionManager = _dataGridConfiguration.rowSelectionManager =
        widget.selectionManager ?? RowSelectionManager();
    selection_manager.setStateDetailsInSelectionManagerBase(
        _rowSelectionManager!, _dataGridStateDetails!);

    _controller!
        ._addDataGridPropertyChangeListener(_handleSelectionPropertyChanged);

    _dataGridConfiguration.columnResizeController =
        ColumnResizeController(dataGridStateDetails: _dataGridStateDetails!);

    _initializeProperties();

    // Apply filter on initial loading.
    if (_dataGridConfiguration.source._filterConditions.isNotEmpty) {
      _dataGridConfiguration.dataGridFilterHelper.applyFilter();
    }
  }

  @protected
  void _gridLoaded() {
    _container.refreshDefaultLineSize();
    _refreshContainerAndView();
  }

  @protected
  void _refreshContainerAndView({bool isDataSourceChanged = false}) {
    if (isDataSourceChanged) {
      selection_manager.updateSelectionController(
          dataGridConfiguration: _dataGridConfiguration,
          isDataSourceChanged: isDataSourceChanged);
    }

    _ensureSelectionProperties();
    _container
      ..refreshHeaderLineCount()
      ..updateRowAndColumnCount()
      ..isGridLoaded = true;
  }

  void _updateVisualDensity(VisualDensity visualDensity) {
    if (_dataGridConfiguration.visualDensity == visualDensity) {
      return;
    }

    final Offset baseDensity = visualDensity.baseSizeAdjustment;

    _dataGridConfiguration
      ..visualDensity = visualDensity
      ..headerRowHeight += baseDensity.dy
      ..rowHeight += baseDensity.dy;

    // Refreshes the default line size, and row heights in initial
    // `SfDataGrid` build. So, restricts the codes in initial loading by using
    // the `_container.isGridLoaded` property.
    if (_container.isGridLoaded) {
      // Refresh header rows height.
      _updateHeaderRowHeight();
      // Refresh data rows height.
      _container.rowHeights.defaultLineSize = _dataGridConfiguration.rowHeight;
    }
  }

  void _initializeDataGridDataSource() {
    if (_source != widget.source) {
      _removeDataGridSourceListeners();
      _source = widget.source.._dataGridStateDetails = _dataGridStateDetails;
      _addDataGridSourceListeners();
    }
    _source?._updateDataSource();
  }

  void _initializeProperties() {
    if (!listEquals<GridColumn>(_columns, widget.columns)) {
      if (_columns != null) {
        _columns!
          ..clear()
          ..addAll(widget.columns);
      }
    }

    _updateDataGridStateDetails();
    if (_columns!.isNotEmpty) {
      /// Need to add check box column, when showCheckboxColumn is true.
      _addCheckboxColumn(_dataGridConfiguration);
    }
  }

  void _initializeCellRendererCollection() {
    _cellRenderers = <String, GridCellRendererBase>{};
    _cellRenderers['TextField'] = GridCellTextFieldRenderer();
    setStateDetailsInCellRendererBase(
        _cellRenderers['TextField']!, _dataGridStateDetails!);
    _cellRenderers['ColumnHeader'] = GridHeaderCellRenderer();
    setStateDetailsInCellRendererBase(
        _cellRenderers['ColumnHeader']!, _dataGridStateDetails!);
    _cellRenderers['StackedHeader'] = GridStackedHeaderCellRenderer();
    setStateDetailsInCellRendererBase(
        _cellRenderers['StackedHeader']!, _dataGridStateDetails!);
    _cellRenderers['Checkbox'] = GridCheckboxRenderer();
    setStateDetailsInCellRendererBase(
        _cellRenderers['Checkbox']!, _dataGridStateDetails!);
    _cellRenderers['TableSummary'] = GridTableSummaryCellRenderer();
    setStateDetailsInCellRendererBase(
        _cellRenderers['TableSummary']!, _dataGridStateDetails!);
  }

  void _processCellUpdate(RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex != RowColumnIndex(-1, -1)) {
      final int rowIndex = grid_helper.resolveToRowIndex(
          _dataGridConfiguration, rowColumnIndex.rowIndex);
      final int columnIndex = grid_helper.resolveToScrollColumnIndex(
          _dataGridConfiguration, rowColumnIndex.columnIndex);

      final DataRowBase? dataRow = _rowGenerator.items.firstWhereOrNull(
          (DataRowBase dataRow) => dataRow.rowIndex == rowIndex);

      if (dataRow == null) {
        return;
      }

      dataRow.dataGridRow = _source!._effectiveRows[rowColumnIndex.rowIndex];
      dataRow.dataGridRowAdapter = grid_helper.getDataGridRowAdapter(
          _dataGridConfiguration, dataRow.dataGridRow!);

      final DataCellBase? dataCell = dataRow.visibleColumns.firstWhereOrNull(
          (DataCellBase dataCell) => dataCell.columnIndex == columnIndex);

      if (dataCell == null) {
        return;
      }

      setState(() {
        _refreshCell(dataCell);
        _updateSummaryColumns(columnIndex);
      });
    }
  }

  void _refreshCell(DataCellBase dataCell) {
    dataCell
      ..isDirty = true
      ..updateColumn();
  }

  void _updateSummaryColumns(int columnIndex) {
    final String columnName =
        _dataGridConfiguration.columns[columnIndex].columnName;
    if (_dataGridConfiguration.tableSummaryRows.isNotEmpty) {
      for (final GridTableSummaryRow tableSummaryRow
          in _dataGridConfiguration.tableSummaryRows) {
        final GridSummaryColumn? summaryColumn = tableSummaryRow.columns
            .firstWhereOrNull(
                (GridSummaryColumn column) => column.columnName == columnName);
        // Returns if the updated cell doesn't exist in the table summary row.
        if (summaryColumn == null) {
          return;
        }

        final DataRowBase? summaryDataRow = _rowGenerator.items
            .firstWhereOrNull(
                (DataRowBase row) => row.tableSummaryRow == tableSummaryRow);
        if (summaryDataRow != null) {
          for (final DataCellBase column in summaryDataRow.visibleColumns) {
            final int titleColumnSpan = grid_helper.getSummaryTitleColumnSpan(
                _dataGridConfiguration, tableSummaryRow);
            if (tableSummaryRow.showSummaryInRow ||
                (titleColumnSpan > 0 && column.columnIndex < titleColumnSpan)) {
              if (tableSummaryRow.title != null) {
                if (tableSummaryRow.title!.contains(summaryColumn.name)) {
                  _refreshCell(column);
                }
              }
            } else if (column.summaryColumn != null &&
                column.summaryColumn!.columnName == columnName) {
              _refreshCell(column);
            }
          }
        }
      }
    }
  }

  void _processUpdateDataSource() {
    if (_dataGridConfiguration.source._suspendDataPagerUpdate) {
      return;
    }
    setState(() {
      // Resets the editing before processing the `onCellSubmit`.
      _processEditing();

      // Need to endEdit the editing [DataGridCell] before perform refreshing.
      if (_dataGridConfiguration.currentCell.isEditing) {
        _dataGridConfiguration.currentCell
            .onCellSubmit(_dataGridConfiguration, canRefresh: false);
      }

      _initializeDataGridDataSource();
      _dataGridConfiguration.source = _source!;

      if (!listEquals<GridColumn>(_columns, widget.columns)) {
        if (widget.selectionMode != SelectionMode.none &&
            widget.navigationMode == GridNavigationMode.cell &&
            _rowSelectionManager != null) {
          selection_manager.onRowColumnChanged(
              _dataGridConfiguration, -1, widget.columns.length);
        }

        _resetColumn();
      }

      if (_dataGridConfiguration.source._filterConditions.isNotEmpty) {
        _dataGridConfiguration.dataGridFilterHelper.applyFilter();
      }

      if (widget.selectionMode != SelectionMode.none)
        selection_manager.removeUnWantedDataGridRows(_dataGridConfiguration);
      if (widget.selectionMode != SelectionMode.none &&
          widget.navigationMode == GridNavigationMode.cell &&
          _rowSelectionManager != null) {
        selection_manager.onRowColumnChanged(
            _dataGridConfiguration, widget.source._effectiveRows.length, -1);
      }

      if (widget.allowSwiping) {
        _dataGridConfiguration.container.resetSwipeOffset();
      }

      if (widget.footer != null) {
        final DataRowBase? footerRow = _rowGenerator.items.firstWhereOrNull(
            (DataRowBase row) =>
                row.rowType == RowType.footerRow && row.rowIndex >= 0);
        if (footerRow != null) {
          // Need to reset the old footer row height in rowHeights collection.
          _container.rowHeights[footerRow.rowIndex] =
              _dataGridConfiguration.rowHeight;
        }
      }

      _container
        ..updateRowAndColumnCount()
        ..refreshView()
        ..isDirty = true;

      // FLUT-3219 Need to refresh the scrolling offsets if the container's
      // offsets and the ScrollController's offsets are not identical.
      _refreshScrollOffsets();
    });
    if (_dataGridConfiguration.source.shouldRecalculateColumnWidths()) {
      resetAutoCalculation(_dataGridConfiguration.columnSizer);
    }

    // Allow focus only if any data cell is in editing state and the
    // data grid currently isn't focused.
    if (_dataGridConfiguration.currentCell.isEditing &&
        _dataGridConfiguration.dataGridFocusNode != null &&
        !_dataGridConfiguration.dataGridFocusNode!.hasPrimaryFocus) {
      _dataGridConfiguration.dataGridFocusNode!.requestFocus();
    }
  }

  // Refreshes the scrolling offsets when the container and the scrollController
  // offsets are different.
  void _refreshScrollOffsets([bool canRefreshHorizontalOffset = false]) {
    // Refreshes the vertical offset.
    if (_dataGridConfiguration.verticalScrollController != null &&
        _dataGridConfiguration.verticalScrollController!.hasClients &&
        _dataGridConfiguration.verticalScrollController!.offset == 0 &&
        _dataGridConfiguration.container.verticalOffset > 0) {
      _dataGridConfiguration.container
        ..verticalOffset = 0
        ..verticalScrollBar.value = 0;
    }
    // Refreshes the horizontal offset.
    if (canRefreshHorizontalOffset) {
      if (_dataGridConfiguration.horizontalScrollController != null &&
          _dataGridConfiguration.horizontalScrollController!.hasClients &&
          _dataGridConfiguration.horizontalScrollController!.offset == 0) {
        final double maxScrollExtent = _dataGridConfiguration
            .horizontalScrollController!.position.maxScrollExtent;
        if (_dataGridConfiguration.textDirection == TextDirection.ltr &&
            _dataGridConfiguration.container.horizontalOffset > 0.0) {
          _dataGridConfiguration.container
            ..horizontalOffset = 0
            ..horizontalScrollBar.value = 0;
        } else if (_dataGridConfiguration.textDirection == TextDirection.rtl &&
            _dataGridConfiguration.container.horizontalOffset <
                maxScrollExtent) {
          _dataGridConfiguration.container
            ..horizontalOffset = maxScrollExtent
            ..horizontalScrollBar.value = maxScrollExtent;
        }
      }
    }
  }

  void _processSorting() {
    setState(() {
      _container
        ..updateRowAndColumnCount()
        ..refreshView()
        ..isDirty = true;
    });
  }

  void _processEditing() {
    if (!_dataGridConfiguration.currentCell.isEditing) {
      return;
    }

    final DataRowBase? dataRow = _dataGridConfiguration.rowGenerator.items
        .firstWhereOrNull((DataRowBase dataRow) => dataRow.isEditing);

    if (dataRow == null) {
      return;
    }

    final DataCellBase? dataCell = dataRow.visibleColumns
        .firstWhereOrNull((DataCellBase dataCell) => dataCell.isEditing);

    if (dataCell == null || !dataCell.isEditing) {
      return;
    }

    final RowColumnIndex rowColumnIndex =
        grid_helper.resolveToRecordRowColumnIndex(_dataGridConfiguration,
            RowColumnIndex(dataCell.rowIndex, dataCell.columnIndex));

    /// Issue:
    /// FLUT-6409 - Other cells are not moving into edit mode when removing
    /// last row and the cell in that row is in edit mode
    ///
    /// Fix:
    /// The issue occurred due to not resetting the editing properties after
    /// removing a row or column from the collection. If a row or column has
    /// a negative index, that row or column currently does not exist in the
    /// data grid. We have fixed the issue by resetting the editing properties.
    if (rowColumnIndex.rowIndex.isNegative ||
        rowColumnIndex.columnIndex.isNegative) {
      dataCell.editingWidget = null;
      dataCell.isDirty = true;
      dataCell.isEditing = dataRow.isEditing = false;

      _dataGridConfiguration.currentCell
        ..isEditing = false
        ..rowIndex = -1
        ..columnIndex = -1;
    }
  }

  void _resetColumn({bool clearEditing = true}) {
    if (_columns != null) {
      _columns!
        ..clear()
        ..addAll(widget.columns);
      _dataGridConfiguration.columns = _columns!;
      if (_columns!.isNotEmpty) {
        /// Add check box column, while refreshing.
        _addCheckboxColumn(_dataGridConfiguration);
      }
    }

    for (final DataRowBase dataRow in _rowGenerator.items) {
      if (!clearEditing && dataRow.isEditing) {
        return;
      }

      for (final DataCellBase dataCell in dataRow.visibleColumns) {
        dataCell.columnIndex = -1;
      }
    }

    if (_textDirection == TextDirection.rtl) {
      _container.needToSetHorizontalOffset = true;
    }
    _container.needToRefreshColumn = true;
  }

  void _handleListeners() {
    _processUpdateDataSource();
  }

  void _handleNotifyListeners({RowColumnIndex? rowColumnIndex}) {
    if (rowColumnIndex != null) {
      _processCellUpdate(rowColumnIndex);
    }
    if (rowColumnIndex == null) {
      _processUpdateDataSource();
    }
  }

  void _handleDataGridPropertyChangeListeners(
      {RowColumnIndex? rowColumnIndex,
      String? propertyName,
      bool recalculateRowHeight = false}) {
    if (propertyName == 'refreshRow') {
      if (rowColumnIndex != null) {
        // Need to endEdit before refreshing the row.
        _dataGridConfiguration.currentCell
            .onCellSubmit(_dataGridConfiguration, canRefresh: false);
        final int rowIndex = grid_helper.resolveToRowIndex(
            _dataGridConfiguration, rowColumnIndex.rowIndex);

        final DataRowBase? dataRow = _rowGenerator.items.firstWhereOrNull(
            (DataRowBase dataRow) => dataRow.rowIndex == rowIndex);

        if (dataRow == null) {
          return;
        }
        setState(() {
          dataRow
            ..isDirty = true
            ..rowIndexChanged();
          if (recalculateRowHeight) {
            _dataGridConfiguration.container.rowHeightManager
                .setDirty(rowIndex);
            _dataGridConfiguration.container
              ..needToRefreshColumn = true
              ..setRowHeights();
          }
        });
      }
    }

    if (rowColumnIndex == null && propertyName == 'Sorting') {
      _processSorting();
    }

    if (propertyName == 'hoverOnCell') {
      setState(() {
        // To rebuild the datagrid on hovering the header cell. isDirty already
        // been set in header cell widget itself
      });
    }

    if (propertyName == 'Swiping') {
      setState(() {
        // Need to end-edit the editing [DataGridCell] before swiping a
        // [DataGridRow] or refreshing
        _dataGridConfiguration.currentCell
            .onCellSubmit(_dataGridConfiguration, canRefresh: false);
        _container.isDirty = true;
      });
    }

    if (propertyName == 'columnResizing') {
      setState(() {
        // Rebuild the DataGrid to change the column width and indicator visibility when the column resize is processed.
      });
    }

    if (propertyName == 'editing' && rowColumnIndex != null) {
      _processCellUpdate(rowColumnIndex);
    }

    if (propertyName == 'Filtering') {
      setState(() {
        _dataGridConfiguration.container
          ..resetSwipeOffset()
          ..updateRowAndColumnCount()
          ..refreshView()
          ..isDirty = true;

        _refreshScrollOffsets();
      });
    }
  }

  void _updateDataGridStateDetails() {
    _dataGridConfiguration
      ..source = _source!
      ..columns = _columns!
      ..textDirection = _textDirection
      ..cellRenderers = _cellRenderers
      ..container = _container
      ..rowGenerator = _rowGenerator
      ..visualDensity = _dataGridConfiguration.visualDensity
      ..headerLineCount = _container.headerLineCount
      ..onQueryRowHeight = widget.onQueryRowHeight
      ..gridLinesVisibility = widget.gridLinesVisibility
      ..headerGridLinesVisibility = widget.headerGridLinesVisibility
      ..columnWidthMode = widget.columnWidthMode
      ..columnWidthCalculationRange = widget.columnWidthCalculationRange
      ..selectionMode = widget.selectionMode
      ..onSelectionChanged = widget.onSelectionChanged
      ..onSelectionChanging = widget.onSelectionChanging
      ..navigationMode = widget.navigationMode
      ..onCurrentCellActivated = widget.onCurrentCellActivated
      ..onCurrentCellActivating = widget.onCurrentCellActivating
      ..onCellTap = widget.onCellTap
      ..onCellDoubleTap = widget.onCellDoubleTap
      ..onCellSecondaryTap = widget.onCellSecondaryTap
      ..onCellLongPress = widget.onCellLongPress
      ..frozenColumnsCount = widget.frozenColumnsCount
      ..footerFrozenColumnsCount = widget.footerFrozenColumnsCount
      ..frozenRowsCount = widget.frozenRowsCount
      ..footerFrozenRowsCount = widget.footerFrozenRowsCount
      ..allowSorting = widget.allowSorting
      ..allowMultiColumnSorting = widget.allowMultiColumnSorting
      ..allowTriStateSorting = widget.allowTriStateSorting
      ..sortingGestureType = widget.sortingGestureType
      ..showSortNumbers = widget.showSortNumbers
      ..isControlKeyPressed = false
      ..stackedHeaderRows = widget.stackedHeaderRows
      ..isScrollbarAlwaysShown = widget.isScrollbarAlwaysShown
      ..horizontalScrollPhysics = widget.horizontalScrollPhysics
      ..verticalScrollPhysics = widget.verticalScrollPhysics
      ..loadMoreViewBuilder = widget.loadMoreViewBuilder
      ..refreshIndicatorDisplacement = widget.refreshIndicatorDisplacement
      ..allowPullToRefresh = widget.allowPullToRefresh
      ..refreshIndicatorStrokeWidth = widget.refreshIndicatorStrokeWidth
      ..allowSwiping = widget.allowSwiping
      ..swipeMaxOffset = widget.swipeMaxOffset
      ..onSwipeStart = widget.onSwipeStart
      ..onSwipeUpdate = widget.onSwipeUpdate
      ..onSwipeEnd = widget.onSwipeEnd
      ..startSwipeActionsBuilder = widget.startSwipeActionsBuilder
      ..endSwipeActionsBuilder = widget.endSwipeActionsBuilder
      ..swipingAnimationController ??= _swipingAnimationController
      ..swipingAnimation ??= _swipingAnimation
      ..highlightRowOnHover = widget.highlightRowOnHover
      ..allowColumnsResizing = widget.allowColumnsResizing
      ..columnResizeMode = widget.columnResizeMode
      ..onColumnResizeStart = widget.onColumnResizeStart
      ..onColumnResizeUpdate = widget.onColumnResizeUpdate
      ..onColumnResizeEnd = widget.onColumnResizeEnd
      ..editingGestureType = widget.editingGestureType
      ..allowEditing = widget.allowEditing
      ..rowHeight = (widget.rowHeight.isNaN
          ? _dataGridConfiguration.rowHeight.isNaN
              ? _rowHeight
              : _dataGridConfiguration.rowHeight
          : widget.rowHeight)
      ..headerRowHeight = (widget.headerRowHeight.isNaN
          ? _dataGridConfiguration.headerRowHeight.isNaN
              ? _headerRowHeight
              : _dataGridConfiguration.headerRowHeight
          : widget.headerRowHeight)
      ..defaultColumnWidth = (widget.defaultColumnWidth.isNaN
          ? _dataGridConfiguration.defaultColumnWidth
          : widget.defaultColumnWidth)
      ..footer = widget.footer
      ..footerHeight = widget.footerHeight
      ..showCheckboxColumn = widget.showCheckboxColumn
      ..checkboxColumnSettings = widget.checkboxColumnSettings
      ..tableSummaryRows = widget.tableSummaryRows
      ..rowsPerPage = widget.rowsPerPage
      ..shrinkWrapColumns = widget.shrinkWrapColumns
      ..shrinkWrapRows = widget.shrinkWrapRows
      ..rowsCacheExtent = widget.rowsCacheExtent
      ..dataGridThemeHelper = _dataGridThemeHelper
      ..allowFiltering = widget.allowFiltering
      ..onFilterChanging = widget.onFilterChanging
      ..onFilterChanged = widget.onFilterChanged;

    if (widget.allowPullToRefresh) {
      _dataGridConfiguration.refreshIndicatorKey ??=
          GlobalKey<RefreshIndicatorState>();
    }
  }

  DataGridConfiguration _onDataGridStateDetailsChanged() =>
      _dataGridConfiguration;

  void _updateProperties(SfDataGrid oldWidget) {
    final bool isSourceChanged = widget.source != oldWidget.source;
    final bool isDataSourceChanged =
        !listEquals<DataGridRow>(oldWidget.source.rows, widget.source.rows);
    final bool isColumnsChanged =
        !listEquals<GridColumn>(_columns, widget.columns);
    // Issue:
    // FLUT-5815 - Range error occurs while doing column manipulations at
    // runtime and calling setstate to refresh the changes.
    //
    // Fix:
    // `isColumnsChanged` property is also true if a user sets the columns as a
    // collection at every time. So, we have used the column's length to check
    // whether the columns collection is changed or not at runtime
    // and update required changes in the data grid based on it.
    final bool isColumnsCollectionChanged =
        _columns!.length != widget.columns.length;
    final bool isSelectionManagerChanged =
        oldWidget.selectionManager != widget.selectionManager ||
            oldWidget.selectionMode != widget.selectionMode;
    final bool isColumnSizerChanged =
        oldWidget.columnSizer != widget.columnSizer ||
            oldWidget.columnWidthMode != widget.columnWidthMode ||
            oldWidget.columnWidthCalculationRange !=
                widget.columnWidthCalculationRange;
    final bool isDataGridControllerChanged =
        oldWidget.controller != widget.controller;
    final bool isFrozenColumnPaneChanged = oldWidget.frozenColumnsCount !=
            widget.frozenColumnsCount ||
        oldWidget.footerFrozenColumnsCount != widget.footerFrozenColumnsCount;
    final bool isFrozenRowPaneChanged =
        oldWidget.frozenRowsCount != widget.frozenRowsCount ||
            oldWidget.footerFrozenRowsCount != widget.footerFrozenRowsCount;
    final bool isSortingChanged = oldWidget.allowSorting != widget.allowSorting;
    final bool isMultiColumnSortingChanged =
        oldWidget.allowMultiColumnSorting != widget.allowMultiColumnSorting;
    final bool isShowSortNumbersChanged =
        oldWidget.showSortNumbers != widget.showSortNumbers;
    final bool isStackedHeaderRowsChanged = !listEquals<StackedHeaderRow>(
        oldWidget.stackedHeaderRows, widget.stackedHeaderRows);
    final bool isPullToRefreshPropertiesChanged =
        oldWidget.allowPullToRefresh != widget.allowPullToRefresh ||
            oldWidget.refreshIndicatorDisplacement !=
                widget.refreshIndicatorDisplacement ||
            oldWidget.refreshIndicatorStrokeWidth !=
                widget.refreshIndicatorStrokeWidth;
    final bool isSwipingChanged = widget.allowSwiping != oldWidget.allowSwiping;
    final bool isMaxSwipeOffsetChanged =
        widget.swipeMaxOffset != oldWidget.swipeMaxOffset;
    final bool isFooterRowChanged = widget.footer != oldWidget.footer ||
        widget.footerHeight != oldWidget.footerHeight;
    final bool isTableSummaryRowsChanged =
        widget.tableSummaryRows != oldWidget.tableSummaryRows;
    final bool isRowsPerPageChanged =
        widget.rowsPerPage != oldWidget.rowsPerPage;
    // To apply filtering to the runtime changes of columns.
    final bool canApplyFiltering =
        isColumnsChanged && _columns!.length != widget.columns.length;

    if (oldWidget.verticalScrollController != widget.verticalScrollController) {
      if (widget.verticalScrollController != null) {
        _dataGridConfiguration.disposeVerticalScrollController = false;
      }
      _dataGridConfiguration.verticalScrollController =
          widget.verticalScrollController ?? ScrollController();
    }

    if (oldWidget.horizontalScrollController !=
        widget.horizontalScrollController) {
      if (widget.horizontalScrollController != null) {
        _dataGridConfiguration.disposeHorizontalScrollController = false;
      }
      _dataGridConfiguration.horizontalScrollController =
          widget.horizontalScrollController ?? ScrollController();
    }

    if (!oldWidget.allowColumnsResizing && widget.allowColumnsResizing) {
      _dataGridConfiguration.columnResizeController.setHitTestPrecision();
    }

    final bool isEditingChanged =
        oldWidget.allowEditing != widget.allowEditing ||
            oldWidget.editingGestureType != widget.editingGestureType;

    void refreshEditing() {
      bool isEditingImpactAPIsChanged = isSourceChanged ||
          isDataSourceChanged ||
          oldWidget.stackedHeaderRows.length != widget.stackedHeaderRows.length;

      /// Need to end-edit the editing when sorting re-order the row on
      /// refreshing
      isEditingImpactAPIsChanged =
          (isSortingChanged || isMultiColumnSortingChanged) &&
              (oldWidget.source.sortedColumns.isNotEmpty ||
                  widget.source.sortedColumns.isNotEmpty ||
                  oldWidget.source.sortedColumns.length !=
                      widget.source.sortedColumns.length);

      if (isEditingChanged ||
          isEditingImpactAPIsChanged ||
          isSelectionManagerChanged ||
          oldWidget.navigationMode != widget.navigationMode) {
        isEditingImpactAPIsChanged = isEditingImpactAPIsChanged ||
            isColumnsChanged ||
            isStackedHeaderRowsChanged;

        if (_dataGridConfiguration.currentCell.isEditing) {
          _dataGridConfiguration.currentCell.onCellSubmit(
              _dataGridConfiguration,
              canRefresh: !isEditingImpactAPIsChanged);
        }
      }
    }

    void refreshFooterView() {
      if (oldWidget.footer != null) {
        final DataRowBase? footerRow = _rowGenerator.items.firstWhereOrNull(
            (DataRowBase row) =>
                row.rowType == RowType.footerRow && row.rowIndex >= 0);
        if (footerRow != null) {
          if (isFooterRowChanged) {
            // Need to reset the old footer row height in rowHeights collection.
            _container.rowHeights[footerRow.rowIndex] =
                _dataGridConfiguration.rowHeight;
            // We remove the old footer view widget and recreate it in
            // `ScrollViewWidget` when the footer property is changed. Thus updates
            // the runtime changes of the footer view widget.
            _rowGenerator.items.remove(footerRow);
          } else if (isSourceChanged ||
              isDataSourceChanged ||
              isStackedHeaderRowsChanged) {
            _container.rowHeights[footerRow.rowIndex] =
                _dataGridConfiguration.rowHeight;
          }
        }
      }
    }

    void refreshTableSummaryRows() {
      if (isTableSummaryRowsChanged) {
        if (oldWidget.tableSummaryRows.isNotEmpty) {
          _container.rowGenerator.items.removeWhere((DataRowBase row) =>
              row.rowType == RowType.tableSummaryRow ||
              row.rowType == RowType.tableSummaryCoveredRow);
        }
        _container.refreshHeaderLineCount();
      }
    }

    if (!_dataGridConfiguration.isDesktop &&
        _dataGridConfiguration.allowColumnsResizing) {
      final ColumnResizeController columnResizeController =
          _dataGridConfiguration.columnResizeController;
      if (!columnResizeController.isResizing &&
          columnResizeController.isResizeIndicatorVisible) {
        columnResizeController.isResizeIndicatorVisible = false;
      }
    }

    if (isSourceChanged ||
        isColumnsChanged ||
        isDataSourceChanged ||
        isSelectionManagerChanged ||
        isColumnSizerChanged ||
        isDataGridControllerChanged ||
        isFrozenColumnPaneChanged ||
        isFrozenRowPaneChanged ||
        isSortingChanged ||
        isMultiColumnSortingChanged ||
        isShowSortNumbersChanged ||
        isStackedHeaderRowsChanged ||
        isSwipingChanged ||
        isFooterRowChanged ||
        isTableSummaryRowsChanged ||
        oldWidget.rowHeight != widget.rowHeight ||
        oldWidget.headerRowHeight != widget.headerRowHeight ||
        oldWidget.defaultColumnWidth != widget.defaultColumnWidth ||
        oldWidget.navigationMode != widget.navigationMode ||
        oldWidget.showCheckboxColumn != widget.showCheckboxColumn ||
        oldWidget.rowsCacheExtent != widget.rowsCacheExtent ||
        isRowsPerPageChanged) {
      // Need to endEdit before refreshing
      refreshEditing();

      // Need to initialize the data source when the `isColumnsCollectionChanged`
      // property is true to adapt the `DataGridRow.cells` changes that made by
      // the user based on the `columns` collection changes.
      if (isSourceChanged || isColumnsCollectionChanged) {
        _initializeDataGridDataSource();
      }
      if (isSortingChanged || isMultiColumnSortingChanged) {
        if (!widget.allowSorting) {
          _dataGridConfiguration.source
            ..sortedColumns.clear()
            .._updateDataSource();
        } else if (widget.allowSorting && !widget.allowMultiColumnSorting) {
          while (_dataGridConfiguration.source.sortedColumns.length > 1) {
            _dataGridConfiguration.source.sortedColumns.removeAt(0);
          }
          _dataGridConfiguration.source._updateDataSource();
        }
      }

      if (isDataGridControllerChanged) {
        oldWidget.controller?._removeDataGridPropertyChangeListener(
            _handleDataGridPropertyChangeListeners);

        _controller = _dataGridConfiguration.controller =
            widget.controller ?? _controller!;
        _controller!._dataGridStateDetails = _dataGridStateDetails;

        _controller?._addDataGridPropertyChangeListener(
            _handleDataGridPropertyChangeListeners);
      }

      if (oldWidget.columnSizer != widget.columnSizer) {
        _dataGridConfiguration.columnSizer =
            widget.columnSizer ?? ColumnSizer();
        setStateDetailsInColumnSizer(
            _dataGridConfiguration.columnSizer, _dataGridStateDetails!);
      }

      _initializeProperties();

      if (canApplyFiltering) {
        _dataGridConfiguration.dataGridFilterHelper.applyFilter();
      }

      if (isStackedHeaderRowsChanged || isColumnsChanged) {
        _onStackedHeaderRowsPropertyChanged(oldWidget, widget);
      }

      if (isRowsPerPageChanged) {
        _processUpdateDataSource();
      }

      refreshFooterView();

      refreshTableSummaryRows();

      _container.refreshDefaultLineSize();

      _updateSelectionController(oldWidget,
          isDataGridControlChanged: isDataGridControllerChanged,
          isSelectionManagerChanged: isSelectionManagerChanged,
          isSourceChanged: isSourceChanged,
          isDataSourceChanged: isDataSourceChanged);

      _container.updateRowAndColumnCount();

      if (isSourceChanged ||
          isColumnsChanged ||
          isColumnSizerChanged ||
          isFrozenColumnPaneChanged ||
          isSortingChanged ||
          isStackedHeaderRowsChanged ||
          oldWidget.showCheckboxColumn != widget.showCheckboxColumn ||
          widget.allowSorting && isMultiColumnSortingChanged ||
          widget.allowSorting &&
              widget.allowMultiColumnSorting &&
              isShowSortNumbersChanged) {
        _resetColumn(clearEditing: false);
        if (isColumnSizerChanged) {
          resetAutoCalculation(_dataGridConfiguration.columnSizer);
        }
      }

      if (isSourceChanged ||
          isColumnsCollectionChanged ||
          isDataSourceChanged ||
          isFrozenRowPaneChanged ||
          isStackedHeaderRowsChanged ||
          isSortingChanged ||
          isTableSummaryRowsChanged ||
          widget.allowSorting && isMultiColumnSortingChanged ||
          isRowsPerPageChanged) {
        _container.refreshView(clearEditing: false);
      }

      if (widget.allowSwiping ||
          (oldWidget.allowSwiping && !widget.allowSwiping)) {
        if (isDataSourceChanged ||
            isColumnSizerChanged ||
            isMaxSwipeOffsetChanged ||
            isFrozenRowPaneChanged ||
            isFrozenColumnPaneChanged ||
            canApplyFiltering ||
            (oldWidget.allowSwiping && !widget.allowSwiping ||
                isRowsPerPageChanged)) {
          _container.resetSwipeOffset();
        }
      }

      if (isSourceChanged || isDataSourceChanged) {
        // FLUT-5404 Need to refresh the scrolling offsets if the container's
        // offsets and the ScrollController's offsets are not identical.
        _refreshScrollOffsets(true);
      }

      _container.isDirty = true;
    } else {
      if (oldWidget.gridLinesVisibility != widget.gridLinesVisibility ||
          oldWidget.allowTriStateSorting != widget.allowTriStateSorting ||
          oldWidget.headerGridLinesVisibility !=
              widget.headerGridLinesVisibility ||
          oldWidget.sortingGestureType != widget.sortingGestureType ||
          isEditingChanged) {
        // Need to endEdit before refreshing
        if (isEditingChanged && _dataGridConfiguration.currentCell.isEditing) {
          _dataGridConfiguration.currentCell
              .onCellSubmit(_dataGridConfiguration, canRefresh: false);
        }
        _initializeProperties();
        _container.isDirty = true;
      } else if (isPullToRefreshPropertiesChanged || isMaxSwipeOffsetChanged) {
        _initializeProperties();
      }
    }
  }

  void _handleSelectionPropertyChanged(
      {RowColumnIndex? rowColumnIndex,
      String? propertyName,
      bool recalculateRowHeight = false}) {
    selection_manager.handleSelectionPropertyChanged(
        dataGridConfiguration: _dataGridStateDetails!(),
        propertyName: propertyName,
        rowColumnIndex: rowColumnIndex,
        recalculateRowHeight: recalculateRowHeight);
  }

  void _updateSelectionController(SfDataGrid oldWidget,
      {bool isSelectionManagerChanged = false,
      bool isDataGridControlChanged = false,
      bool isSourceChanged = false,
      bool isDataSourceChanged = false}) {
    if (isSourceChanged) {
      oldWidget.controller?._removeDataGridPropertyChangeListener(
          _handleSelectionPropertyChanged);
      widget.controller
          ?._addDataGridPropertyChangeListener(_handleSelectionPropertyChanged);
    }

    if (isSelectionManagerChanged) {
      _rowSelectionManager = _dataGridConfiguration.rowSelectionManager =
          widget.selectionManager ?? _rowSelectionManager!;
      selection_manager.setStateDetailsInSelectionManagerBase(
          _rowSelectionManager!, _dataGridStateDetails!);
    }

    if (isSourceChanged) {
      _rowSelectionManager!.handleDataGridSourceChanges();
    }

    selection_manager.updateSelectionController(
        dataGridConfiguration: _dataGridConfiguration,
        isSelectionModeChanged: oldWidget.selectionMode != widget.selectionMode,
        isNavigationModeChanged:
            oldWidget.navigationMode != widget.navigationMode,
        isDataSourceChanged: isDataSourceChanged);

    if (isDataGridControlChanged) {
      _ensureSelectionProperties();
    }
  }

  void _onStackedHeaderRowsPropertyChanged(
      SfDataGrid oldWidget, SfDataGrid widget) {
    _container.refreshHeaderLineCount();
    if (oldWidget.stackedHeaderRows.isNotEmpty) {
      _rowGenerator.items.removeWhere(
          (DataRowBase row) => row.rowType == RowType.stackedHeaderRow);
    }
    if (widget.onQueryRowHeight != null) {
      _container.rowHeightManager.reset();
    }

    // FlUT-3851 Needs to reset the vertical and horizontal offset when both the
    // controller's offset and scrollbar's offset are not identical.
    if ((oldWidget.stackedHeaderRows.isNotEmpty &&
            widget.stackedHeaderRows.isEmpty) ||
        (oldWidget.stackedHeaderRows.isEmpty &&
            widget.stackedHeaderRows.isNotEmpty)) {
      if (_dataGridConfiguration.verticalScrollController!.hasClients &&
          _dataGridConfiguration.container.verticalOffset > 0) {
        _dataGridConfiguration.container.verticalOffset = 0;
        _dataGridConfiguration.container.verticalScrollBar.value = 0;
      }
      if (_dataGridConfiguration.horizontalScrollController!.hasClients &&
          _dataGridConfiguration.container.horizontalOffset > 0) {
        _dataGridConfiguration.container.horizontalOffset = 0;
        _dataGridConfiguration.container.horizontalScrollBar.value = 0;
      }
    }
  }

  void _ensureSelectionProperties() {
    if (_controller!.selectedRows.isNotEmpty) {
      _rowSelectionManager?.onSelectedRowsChanged();
    }

    if (_controller!.selectedRow != null) {
      _rowSelectionManager?.onSelectedRowChanged();
    }

    if (_controller!.selectedIndex != -1) {
      _rowSelectionManager?.onSelectedIndexChanged();
    }
  }

  void _updateBoxPainter() {
    if (widget.selectionMode == SelectionMode.multiple &&
        widget.navigationMode == GridNavigationMode.row) {
      _dataGridConfiguration.configuration ??=
          createLocalImageConfiguration(context);
      if (_dataGridConfiguration.boxPainter == null) {
        _updateDecoration();
      }
    }
  }

  void _updateDecoration() {
    final BorderSide borderSide = BorderSide(
        color: _dataGridConfiguration
            .dataGridThemeHelper!.currentCellStyle.borderColor);
    final BoxDecoration decoration = BoxDecoration(
        border: Border(
            bottom: borderSide,
            top: borderSide,
            left: borderSide,
            right: borderSide));

    _dataGridConfiguration.boxPainter = decoration.createBoxPainter();
  }

  void _addDataGridSourceListeners() {
    _source?._addDataGridPropertyChangeListener(
        _handleDataGridPropertyChangeListeners);
    _source?._addDataGridSourceListener(_handleNotifyListeners);
    _source?.addListener(_handleListeners);
  }

  void _removeDataGridSourceListeners() {
    _source?._removeDataGridPropertyChangeListener(
        _handleDataGridPropertyChangeListeners);
    _source?._removeDataGridSourceListener(_handleNotifyListeners);
    _source?.removeListener(_handleListeners);
  }

  /// Need to add the check box column, when showCheckboxColumn is true.
  void _addCheckboxColumn(DataGridConfiguration dataGridConfiguration) {
    if (widget.showCheckboxColumn) {
      dataGridConfiguration.columns.insert(
          0,
          GridCheckboxColumn(
              columnName: '',
              label: widget.checkboxColumnSettings.label ?? const SizedBox(),
              width: widget.checkboxColumnSettings.width));
    }
  }

  /// Show the refresh indicator and call the
  /// [DataGridSource.handleRefresh].
  ///
  /// To access this method, create the [SfDataGrid] with a
  /// [GlobalKey<SfDataGridState>].
  ///
  /// The future returned from this method completes when the
  /// [DataGridSource.handleRefresh] method’s future completes.
  ///
  /// By default, if you call this method without any parameter,
  /// [RefreshIndicator] will be shown. If you want to disable the
  /// [RefreshIndicator] and call the [DataGridSource.handleRefresh] method
  /// alone, pass the parameter as `false`.
  Future<void> refresh([bool showRefreshIndicator = true]) async {
    if (_dataGridConfiguration.allowPullToRefresh &&
        _dataGridConfiguration.refreshIndicatorKey != null) {
      if (showRefreshIndicator) {
        await _dataGridConfiguration.refreshIndicatorKey!.currentState?.show();
      } else {
        await _dataGridConfiguration.source.handleRefresh();
      }
    }
  }

  @override
  void didChangeDependencies() {
    final ThemeData themeData = Theme.of(context);
    _dataGridConfiguration.isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    // Sets column resizing hitTestPrecision based on the platform.

    if (_dataGridConfiguration.allowColumnsResizing) {
      _dataGridConfiguration.columnResizeController.setHitTestPrecision();
    }

    _onDataGridTextDirectionChanged(Directionality.of(context));

    _onDataGridThemeDataChanged(
        SfDataGridTheme.of(context), themeData.colorScheme);
    _onDataGridTextScaleFactorChanged(MediaQuery.textScaleFactorOf(context));
    _updateVisualDensity(themeData.visualDensity);
    _dataGridConfiguration.defaultColumnWidth = widget.defaultColumnWidth.isNaN
        ? _dataGridConfiguration.isDesktop
            ? 100
            : 90
        : widget.defaultColumnWidth;
    _onDataGridLocalizationsChanged(SfLocalizations.of(context));

    // This is used to dismiss the filtering popup menu manually when resizing
    // the current window size. By default, the popup menu will not be
    // dismissed when resizing the window. So, we have used this workaround to
    // achieve this behavior.
    if (_dataGridConfiguration.isDesktop) {
      final Size currentScreenSize = MediaQuery.of(context).size;
      _screenSize ??= currentScreenSize;
      if (_screenSize != currentScreenSize &&
          _dataGridConfiguration
              .dataGridFilterHelper.isFilterPopupMenuShowing) {
        Navigator.pop(context);
        _dataGridConfiguration.dataGridFilterHelper.isFilterPopupMenuShowing =
            false;
      }
      _screenSize = currentScreenSize;
    }

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfDataGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateProperties(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_dataGridConfiguration.isDesktop) {
      _updateBoxPainter();
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final double measuredHeight = _dataGridConfiguration.viewHeight =
          constraints.maxHeight.isInfinite ? _minHeight : constraints.maxHeight;
      double measuredWidth = _dataGridConfiguration.viewWidth =
          constraints.maxWidth.isInfinite ? _minWidth : constraints.maxWidth;

      // FLUT-6545 if shrinkWrapColumns is true, we need to set the container extended width value to the viewWidth
      // because the row selection colors are applied based on this size while cell is in editing
      if (_dataGridConfiguration.shrinkWrapColumns) {
        measuredWidth = _dataGridConfiguration.viewWidth =
            _dataGridConfiguration.container.extentWidth;
      }
      if (!_container.isGridLoaded) {
        _gridLoaded();
        if (_textDirection == TextDirection.rtl) {
          _container.needToSetHorizontalOffset = true;
        }
        _container.isDirty = true;
        updateColumnSizerLoadedInitiallyFlag(
            _dataGridConfiguration.columnSizer, true);
      }

      return ScrollViewWidget(
        width: measuredWidth,
        height: measuredHeight,
        dataGridStateDetails: _dataGridStateDetails!,
      );
    });
  }

  @override
  void dispose() {
    _removeDataGridSourceListeners();
    _controller?.removeListener(_handleDataGridPropertyChangeListeners);
    _dataGridConfiguration
      ..gridPaint = null
      ..boxPainter = null
      ..configuration = null;
    _dataGridThemeData = null;
    if (_swipingAnimationController != null) {
      _swipingAnimationController!.dispose();
      _swipingAnimationController = null;
    }
    _dataGridConfiguration.dataGridFilterHelper.checkboxFilterHelper
      ..textController.dispose()
      ..searchboxFocusNode.dispose();
    _dataGridConfiguration.dataGridFilterHelper.advancedFilterHelper
      ..firstValueTextController.dispose()
      ..secondValueTextController.dispose();
    super.dispose();
  }
}

/// A datasource for obtaining the row data for the [SfDataGrid].
///
/// The following APIs are mandatory to process the data,
/// * [rows] - The number of rows in a datagrid and row selection depends
/// on the [rows]. So, set the collection required for datagrid in
/// [rows].
/// * [buildRow] - The data needed for the cells is obtained from
/// [buildRow].
///
/// Call the [notifyDataSourceListeners] when performing CRUD in the underlying
/// datasource.
///
/// [DataGridSource] objects are expected to be long-lived, not recreated with
/// each build.
/// ``` dart
/// final List<Employee> _employees = <Employee>[];
///
/// class EmployeeDataSource extends DataGridSource {
///   @override
///   List<DataGridRow> get rows => _employees
///       .map<DataGridRow>((dataRow) => DataGridRow(cells: [
///             DataGridCell<int>(columnName: 'id', value: dataRow.id),
///             DataGridCell<String>(columnName: 'name', value: dataRow.name),
///             DataGridCell<String>(
///                 columnName: 'designation', value: dataRow.designation),
///             DataGridCell<int>(columnName: 'salary', value: dataRow.salary),
///           ]))
///       .toList();
///
///   @override
///   DataGridRowAdapter? buildRow(DataGridRow row) {
///     return DataGridRowAdapter(
///         cells: row.getCells().map<Widget>((dataCell) {
///           return Text(dataCell.value.toString());
///         }).toList());
///   }
/// }
/// ```

abstract class DataGridSource extends DataGridSourceChangeNotifier
    with DataPagerDelegate {
  /// The collection of rows to display in [SfDataGrid].
  ///
  /// This must be non-null, but may be empty.
  List<DataGridRow> get rows => List<DataGridRow>.empty();

  /// Called to obtain the widget for each cell of the row.
  ///
  /// This method will be called for every row that are visible in datagrid’s
  /// view port from the collection which is assigned to [DataGridSource.rows]
  /// property.
  ///
  /// Return the widgets in the order in which those should be displayed in
  /// each column of a row in [DataGridRowAdapter.cells].
  ///
  /// The number of widgets in the collection must be exactly as many cells
  /// as [SfDataGrid.columns] in the [SfDataGrid].
  ///
  /// This method will be called whenever you call the [notifyListeners] method.
  DataGridRowAdapter? buildRow(DataGridRow row);

  /// Return the copy of the [DataGridSource.rows].
  /// It holds the sorted collection if the sorting is applied in DataGrid.
  ///
  /// Use this property to get the corresponding visible row index to perform the customization
  /// such as alternate row color, setting row color based on row index and so on.
  List<DataGridRow> get effectiveRows => _effectiveRows;

  List<DataGridRow> _effectiveRows = <DataGridRow>[];

  List<DataGridRow> _unSortedRows = <DataGridRow>[];

  /// Holds the collection of [DataGridRow] to be displayed in the [SfDataPager] page.
  List<DataGridRow> _paginatedRows = <DataGridRow>[];

  /// Helps to suspend the multiple update on SfDataGrid using with
  /// SfDataPager.
  bool _suspendDataPagerUpdate = false;

  DataGridStateDetails? _dataGridStateDetails;

  final Map<String, List<FilterCondition>> _filterConditions =
      <String, List<FilterCondition>>{};

  /// Holds the collection of [FilterCondition] based on the columns.
  ///
  /// Here, key is the name of the column. Value is the collection of filter
  /// conditions.
  ///
  /// Use [DataGridSource.addFilterCondition] and
  /// [DataGridSource.removeFilterCondition] to add or remove the filter
  /// conditions for columns.
  Map<String, List<FilterCondition>> get filterConditions =>
      Map<String, List<FilterCondition>>.unmodifiable(_filterConditions);

  /// Called whenever you call [notifyListeners] or [notifyDataSourceListeners]
  /// in the DataGridSource class. If you want to recalculate all columns
  /// width (may be when underlying data gets changed), return true.
  ///
  /// Returning true may impact performance as the column widths are
  /// recalculated again (whenever the notifyListeners is called).
  ///
  /// If you are aware that column widths are going to be same whenever
  /// underlying data changes, return 'false' from this method.
  ///
  /// Note: Column widths will be recalculated automatically whenever a new
  /// instance of DataGridSource is assigned to SfDataGrid.
  /// ``` dart
  /// class EmployeeDataSource extends DataGridSource {
  ///   @override
  ///   List<DataGridRow> get rows => _employees
  ///       .map<DataGridRow>((dataRow) => DataGridRow(cells: [
  ///             DataGridCell<int>(columnName: 'id', value: dataRow.id),
  ///             DataGridCell<String>(columnName: 'name', value: dataRow.name),
  ///             DataGridCell<String>(
  ///                 columnName: 'designation', value: dataRow.designation),
  ///             DataGridCell<int>(columnName: 'salary', value: dataRow.salary),
  ///           ]))
  ///       .toList();
  ///
  ///   @override
  ///   bool shouldRecalculateColumnWidths() {
  ///     return true;
  ///   }
  ///
  ///   @override
  ///   DataGridRowAdapter? buildRow(DataGridRow row) {
  ///     return DataGridRowAdapter(
  ///         cells: row.getCells().map<Widget>((dataCell) {
  ///           return Text(dataCell.value.toString());
  ///         }).toList());
  ///   }
  /// }
  ///
  /// ```
  @protected
  bool shouldRecalculateColumnWidths() {
    return false;
  }

  /// The collection of [SortColumnDetails] objects to sort the columns in
  /// [SfDataGrid].
  ///
  /// You can use this property to sort the columns programmatically also.
  /// Call [sort] method after you added the column details in [sortedColumns]
  /// programmatically.
  ///
  /// The following example show how to sort the columns on datagrid  loading,
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text('Syncfusion Flutter DataGrid'),
  ///     ),
  ///     body: Column(
  ///       children: [
  ///         TextButton(
  ///           child: Text('Click'),
  ///           onPressed: () {
  ///             _employeeDataSource.sortedColumns
  ///                 .add(SortColumnDetails('id', SortDirection.ascending));
  ///             _employeeDataSource.sort();
  ///           },
  ///         ),
  ///         SfDataGrid(
  ///           source: _employeeDataSource,
  ///           allowSorting: true,
  ///           columns: <GridColumn>[
  ///               GridColumn(columnName: 'id', label: Text('ID')),
  ///               GridColumn(columnName: 'name', label: Text('Name')),
  ///               GridColumn(columnName: 'designation', label: Text('Designation')),
  ///               GridColumn(columnName: 'salary', label: Text('Salary')),
  ///           ],
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///```
  /// See also:
  ///
  /// * [SfDataGrid.allowSorting] – which allows users to sort the columns in
  /// [SfDataGrid].
  /// * [GridColumn.allowSorting] - which allows users to sort the corresponding
  /// column in [SfDataGrid].
  /// * [DataGridSource.sort] - call this method when you are adding the
  /// [SortColumnDetails] programmatically to [DataGridSource.sortedColumns].
  List<SortColumnDetails> get sortedColumns => _sortedColumns;
  final List<SortColumnDetails> _sortedColumns = <SortColumnDetails>[];

  /// Called when the sorting is applied to the column.
  ///
  /// Overriding this method gives complete control over sorting. You can handle
  /// the sorting completely in your own way. The rows argument provides the
  /// unsorted [DataGridRow] collection.
  ///
  /// You can apply the sorting to rows argument. DataGrid will render the rows
  /// based on the [rows] argument. You don’t need to call [notifyListeners]
  /// within this method. However, you must override this method only if you
  /// want to write the entire sorting logic by yourself. Otherwise, for custom
  /// comparison, you can just override [DataGridSource.compare] method and
  /// return the custom sorting order.
  ///
  /// For most of your cases, the 'compare' method should be sufficient.
  /// The [DataGridSource.compare] method can be used to do custom sorting based
  /// on the length of the text, case insensitive sorting, and so on.
  ///
  /// See also,
  ///
  /// [DataGridSource.compare] – To write the custom sorting for most of the use
  /// cases.
  @protected
  void performSorting(List<DataGridRow> rows) {
    if (sortedColumns.isEmpty) {
      return;
    }
    rows.sort((DataGridRow a, DataGridRow b) {
      return _compareValues(sortedColumns, a, b);
    });
  }

  /// To update the sorted collection in _paginatedRows, notifyListener should be
  /// called instead notifyDataGridPropertyChangeListener. Because, notifyListener is common for
  /// in DataPagerDelegate and DataGridSource will get notified.
  void _updateDataPagerOnSorting() {
    if (_pageCount > 0 &&
        _paginatedRows.isNotEmpty &&
        !_suspendDataPagerUpdate) {
      _suspendDataPagerUpdate = true;
      notifyListeners();
      _suspendDataPagerUpdate = false;
    }
  }

  int _compareValues(
      List<SortColumnDetails> sortedColumns, DataGridRow a, DataGridRow b) {
    if (sortedColumns.length > 1) {
      for (int i = 0; i < sortedColumns.length; i++) {
        final SortColumnDetails sortColumn = sortedColumns[i];
        final int compareResult = compare(a, b, sortColumn);
        if (compareResult != 0) {
          return compareResult;
        } else {
          final List<SortColumnDetails> remainingSortColumns = sortedColumns
              .skipWhile((SortColumnDetails value) => value == sortColumn)
              .toList(growable: false);
          return _compareValues(remainingSortColumns, a, b);
        }
      }
    }
    final SortColumnDetails sortColumn = sortedColumns.last;
    return compare(a, b, sortColumn);
  }

  /// Called when the sorting is applied for column. This method compares the
  /// two objects and returns the order either they are equal, or one is
  /// greater than or lesser than the other.
  ///
  /// You can return the following values,
  /// * a negative integer if a is smaller than b,
  /// *	zero if a is equal to b, and
  /// *	a positive integer if a is greater than b.
  ///
  /// You can override this method and do the custom sorting based
  /// on your requirement. Here [sortColumn] provides the details about the
  /// column which is currently sorted with the sort direction. You can get the
  /// currently sorted column and do the custom sorting for specific column.
  ///
  ///
  /// The below example shows how to sort the `name` column based on the case
  /// insensitive in ascending or descending order.
  ///
  /// ```dart
  /// class EmployeeDataSource extends DataGridSource {
  ///   @override
  ///   List<DataGridRow> get rows => _employees
  ///       .map<DataGridRow>((dataRow) => DataGridRow(cells: [
  ///             DataGridCell<int>(columnName: 'id', value: dataRow.id),
  ///             DataGridCell<String>(columnName: 'name', value: dataRow.name),
  ///             DataGridCell<String>(
  ///                 columnName: 'designation', value: dataRow.designation),
  ///             DataGridCell<int>(columnName: 'salary', value: dataRow.salary),
  ///           ]))
  ///       .toList();
  ///
  ///   @override
  ///   DataGridRowAdapter? buildRow(DataGridRow row) {
  ///     return DataGridRowAdapter(
  ///         cells: row.getCells().map<Widget>((dataCell) {
  ///           return Text(dataCell.value.toString());
  ///         }).toList());
  ///   }
  ///
  ///  @override
  ///   int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
  ///    if (sortColumn.name == 'name') {
  ///      final String? valueA = a
  ///          ?.getCells()
  ///          .firstWhereOrNull((dataCell) => dataCell.columnName == 'name')
  ///          ?.value;
  ///      final String? valueB = b
  ///          ?.getCells()
  ///          .firstWhereOrNull((dataCell) => dataCell.columnName == 'name')
  ///          ?.value;
  ///
  ///      if (valueA == null || valueB == null) {
  ///        return 0;
  ///      }
  ///
  ///      if (sortColumn.sortDirection == DataGridSortDirection.ascending) {
  ///        return valueA.toLowerCase().compareTo(valueB.toLowerCase());
  ///      } else {
  ///        return valueB.toLowerCase().compareTo(valueA.toLowerCase());
  ///      }
  ///    }
  ///
  ///    return super.compare(a, b, sortColumn);
  ///  }
  ///
  /// ```
  @protected
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    Object? getCellValue(List<DataGridCell>? cells, String columnName) {
      return cells
          ?.firstWhereOrNull(
              (DataGridCell element) => element.columnName == columnName)
          ?.value;
    }

    final Object? valueA = getCellValue(a?.getCells(), sortColumn.name);
    final Object? valueB = getCellValue(b?.getCells(), sortColumn.name);
    return _compareTo(valueA, valueB, sortColumn.sortDirection);
  }

  int _compareTo(
      dynamic value1, dynamic value2, DataGridSortDirection sortDirection) {
    if (sortDirection == DataGridSortDirection.ascending) {
      if (value1 == null) {
        return -1;
      } else if (value2 == null) {
        return 1;
      }
      return value1.compareTo(value2) as int;
    } else {
      if (value1 == null) {
        return 1;
      } else if (value2 == null) {
        return -1;
      }
      return value2.compareTo(value1) as int;
    }
  }

  void _updateDataSource() {
    if (sortedColumns.isNotEmpty) {
      _unSortedRows = rows.toList();
      _effectiveRows = _unSortedRows;
    } else {
      _effectiveRows = rows;
    }
    // Should refresh sorting when the data grid source is updated.
    performSorting(_effectiveRows);

    // Should refresh filtering when the filterConditions is not empty.
    if (_filterConditions.isNotEmpty) {
      _dataGridStateDetails!().dataGridFilterHelper.applyFilter();
    }

    /// Helps to update the sorted collection in _paginatedRows
    /// by call the DataPagerDelegate.handlePageChange after sorting.
    _updateDataPagerOnSorting();
  }

  /// Call this method when you are adding the [SortColumnDetails]
  /// programmatically to the [DataGridSource.sortedColumns].
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text('Syncfusion Flutter DataGrid'),
  ///     ),
  ///     body: Column(
  ///       children: [
  ///         FlatButton(
  ///           child: Text('Click'),
  ///           onPressed: () {
  ///             _employeeDataSource.sortedColumns
  ///                 .add(SortColumnDetails('id', SortDirection.ascending));
  ///             _employeeDataSource.sort();
  ///           },
  ///         ),
  ///         SfDataGrid(
  ///           source: _employeeDataSource,
  ///           allowSorting: true,
  ///           columns: <GridColumn>[
  ///               GridColumn(columnName: 'id', label:Text('ID')),
  ///               GridColumn(columnName: 'name', label:Text('Name')),
  ///               GridColumn(columnName: 'designation', label: Text('Designation')),
  ///               GridColumn(columnName: 'salary', label: Text('Salary')),
  ///           ],
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  void sort() {
    _updateDataSource();
    _notifyDataGridPropertyChangeListeners(propertyName: 'Sorting');
  }

  /// An indexer to retrieve the data from the underlying datasource. If the
  /// sorting is applied, the data will be retrieved from the sorted datasource.
  DataGridRow operator [](int index) => _effectiveRows[index];

  /// Called when [LoadMoreRows] function is called from the
  /// [SfDataGrid.loadMoreViewBuilder].
  ///
  /// Call the [notifyListeners] to refresh the datagrid based on current
  /// available rows.
  ///
  /// See also,
  ///
  /// [SfDataGrid.loadMoreViewBuilder] - A builder that sets the widget to
  /// display at end of the datagrid when end of the datagrid is reached on
  /// vertical scrolling.
  @protected
  Future<void> handleLoadMoreRows() async {}

  /// Called when the `swipe to refresh` is performed in [SfDataGrid].
  ///
  /// This method will be called only if the
  /// [SfDataGrid.allowPullToRefresh] property returns true.
  ///
  /// Call the [notifyListeners] to refresh the datagrid based on current
  /// available rows.
  @protected
  Future<void> handleRefresh() async {}

  /// Call this method to add the [FilterCondition] programmatically.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Column(
  ///     children: [
  ///       Expanded(
  ///         child: SfDataGrid(source: _employeeDataSource, columns: [
  ///           GridColumn(columnName: 'id', label: Text('ID')),
  ///           GridColumn(columnName: 'name', label: Text('Name')),
  ///           GridColumn(columnName: 'designation', label: Text('Designation')),
  ///           GridColumn(columnName: 'salary', label: Text('Salary')),
  ///         ]),
  ///       ),
  ///       MaterialButton(
  ///           child: Text('Add Filter'),
  ///           onPressed: () {
  ///             _employeeDataSource.addFilter('id',
  ///                 FilterCondition(type: FilterType.greaterThan, value: 1005));
  ///           }),
  ///     ],
  ///   );
  /// }
  /// ```
  void addFilter(String columnName, FilterCondition filterCondition) {
    final List<FilterCondition> conditions = <FilterCondition>[
      if (_filterConditions.containsKey(columnName))
        ..._filterConditions[columnName]!,
      filterCondition
    ];

    _filterConditions[columnName] = conditions;

    _refreshFilter(_dataGridStateDetails!());
  }

  /// Remove the [FilterCondition] from the given column.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Column(
  ///     children: [
  ///       Expanded(
  ///         child: SfDataGrid(source: _employeeDataSource, columns: [
  ///           GridColumn(columnName: 'id', label: Text('ID')),
  ///           GridColumn(columnName: 'name', label: Text('Name')),
  ///           GridColumn(columnName: 'designation', label: Text('Designation')),
  ///           GridColumn(columnName: 'salary', label: Text('Salary')),
  ///         ]),
  ///       ),
  ///       MaterialButton(
  ///           child: Text('Remove Filter'),
  ///           onPressed: () {
  ///             _employeeDataSource.removeFilter('name',
  ///                 FilterCondition(type: FilterType.equals, value: 'James'));
  ///           }),
  ///     ],
  ///   );
  /// }
  /// ```
  void removeFilter(String columnName, FilterCondition filterCondition) {
    if (!_filterConditions.containsKey(columnName) ||
        !_filterConditions[columnName]!.contains(filterCondition)) {
      return;
    }

    final List<FilterCondition> conditions = _filterConditions[columnName]!
      ..remove(filterCondition);

    if (conditions.isEmpty) {
      _filterConditions.remove(columnName);
    } else {
      _filterConditions[columnName] = conditions;
    }

    _refreshFilter(_dataGridStateDetails!());
  }

  /// Clear the [FilterCondition] from a given column or clear all the filter
  /// conditions from all the columns.
  ///
  /// Pass the required [columnName] to remove the filter conditions from the
  /// specific column.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Column(
  ///     children: [
  ///       Expanded(
  ///         child: SfDataGrid(source: _employeeDataSource, columns: [
  ///           GridColumn(columnName: 'id', label: Text('ID')),
  ///           GridColumn(columnName: 'name', label: Text('Name')),
  ///           GridColumn(columnName: 'designation', label: Text('Designation')),
  ///           GridColumn(columnName: 'salary', label: Text('Salary')),
  ///         ]),
  ///       ),
  ///       MaterialButton(
  ///           child: Text('Clear Filters'),
  ///           onPressed: () {
  ///             _employeeDataSource.clearFilters();
  ///           }),
  ///     ],
  ///   );
  /// }
  /// ```
  void clearFilters({String? columnName}) {
    if (_filterConditions.isNotEmpty) {
      if (columnName != null && _filterConditions.containsKey(columnName)) {
        _filterConditions.remove(columnName);
        _refreshFilter(_dataGridStateDetails!());
      } else if (columnName == null) {
        _filterConditions.clear();
        _refreshFilter(_dataGridStateDetails!());
      }
    }
  }

  void _refreshFilter(DataGridConfiguration dataGridConfiguration) {
    if (dataGridConfiguration.currentCell.isEditing) {
      dataGridConfiguration.currentCell
          .onCellSubmit(dataGridConfiguration, canRefresh: false);
    }

    _updateDataSource();

    notifyDataGridPropertyChangeListeners(dataGridConfiguration.source,
        propertyName: 'Filtering');
  }

  /// Called to obtain the widget when a cell is moved into edit mode.
  ///
  /// The following example shows how to override this method and return the
  /// widget for specific column.
  ///
  /// ```dart
  ///
  /// TextEditingController editingController = TextEditingController();
  ///
  /// dynamic newCellValue;
  ///
  /// @override
  /// Widget? buildEditWidget(DataGridRow dataGridRow,
  ///     RowColumnIndex rowColumnIndex, GridColumn column,
  ///     CellSubmit submitCell) {
  ///   // To set the value for TextField when cell is moved into edit mode.
  ///   final String displayText = dataGridRow
  ///       .getCells()
  ///       .firstWhere((DataGridCell dataGridCell) =>
  ///   dataGridCell.columnName == column.columnName)
  ///       .value
  ///       ?.toString() ??
  ///       '';
  ///
  ///   /// Returning the TextField with the numeric keyboard configuration.
  ///   if (column.columnName == 'id') {
  ///     return Container(
  ///         padding: const EdgeInsets.all(8.0),
  ///         alignment: Alignment.centerRight,
  ///         child: TextField(
  ///           autofocus: true,
  ///           controller: editingController..text = displayText,
  ///           textAlign: TextAlign.right,
  ///           decoration: const InputDecoration(
  ///               contentPadding: EdgeInsets.all(0),
  ///               border: InputBorder.none,
  ///               isDense: true),
  ///           inputFormatters: [
  ///             FilteringTextInputFormatter.allow(RegExp('[0-9]'))
  ///           ],
  ///           keyboardType: TextInputType.number,
  ///           onChanged: (String value) {
  ///             if (value.isNotEmpty) {
  ///               print(value);
  ///               newCellValue = int.parse(value);
  ///             } else {
  ///               newCellValue = null;
  ///             }
  ///           },
  ///           onSubmitted: (String value) {
  ///             /// Call [CellSubmit] callback to fire the canSubmitCell and
  ///             /// onCellSubmit to commit the new value in single place.
  ///             submitCell();
  ///           },
  ///         ));
  ///   }
  /// }
  /// ```
  /// Call the cellSubmit function whenever you are trying to save the cell
  /// values. When you call this method, it will call [canSubmitCell] and
  /// [onCellSubmit] methods. So, your usual cell value updation will be done
  /// in single place.
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    return null;
  }

  /// Called whenever the cell is moved into edit mode.
  ///
  /// If you want to disable editing for the cells in specific scenarios,
  /// you can return false.
  ///
  /// [rowColumnIndex] represents the index of row and column which are
  /// currently in view not based on the actual index. If you want to get the
  /// actual row index even after sorting is applied, you can use
  /// `DataGridSource.rows.indexOf` method and pass the [dataGridRow]. It will
  /// provide the actual row index from unsorted [DataGridRow] collection.
  bool onCellBeginEdit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    return true;
  }

  /// Called whenever the cell’s editing is completed.
  ///
  /// Typically, this will be called whenever the [notifyListeners] is called
  /// when cell is in editing mode and key navigation is performed to move a
  /// cell to another cell from the cell which is currently editing.
  /// For eg, Enter key, TAB key and so on.
  ///
  /// The following example show how to override this method and save the
  /// currently edited value for specific column.
  ///
  /// ``` dart
  /// @override
  /// void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
  ///     GridColumn column) {
  ///   final dynamic oldValue = dataGridRow
  ///       .getCells()
  ///       .firstWhereOrNull((DataGridCell dataGridCell) =>
  ///   dataGridCell.columnName == column.columnName)
  ///       ?.value ??
  ///       '';
  ///
  ///   final int dataRowIndex = rows.indexOf(dataGridRow);
  ///
  ///   if (newCellValue == null || oldValue == newCellValue) {
  ///     return;
  ///   }
  ///
  ///   if (column.columnName == 'id') {
  ///     rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
  ///         DataGridCell<int>(columnName: 'id', value: newCellValue);
  ///
  ///     // Save the new cell value to model collection also.
  ///     employees[dataRowIndex].id = newCellValue as int;
  ///   }
  ///
  ///   // To reset the new cell value after successfully updated to DataGridRow
  ///   //and underlying mode.
  ///   newCellValue = null;
  /// }
  ///```
  /// This method will never be called when you return false from [onCellBeginEdit].
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {}

  /// Called whenever the cell’s editing is completed i.e. prior to
  /// [onCellSubmit] method.
  ///
  /// If you want to restrict the cell from being end its editing, you can
  /// return false. Otherwise, return true. [onCellSubmit] will be called only
  /// if the [canSubmitCell] returns true.
  bool canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    return true;
  }

  /// Called when you press the [LogicalKeyboardKey.escape] key when
  /// the [DataGridCell] on editing to cancel the editing.
  void onCellCancelEdit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {}

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) {
    if (effectiveRows.isEmpty || _pageCount == 0) {
      _paginatedRows = <DataGridRow>[];
      return Future<bool>.value(true);
    }

    final DataGridConfiguration dataGridConfiguration =
        _dataGridStateDetails!();

    final int rowsPerPage = dataGridConfiguration.rowsPerPage ??
        (effectiveRows.length / _pageCount).ceil();
    final int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;

    /// Need to calculate endIndex for the last page, when the number of rows is
    /// lesser than rowsPerPage.
    if (endIndex > effectiveRows.length) {
      endIndex = effectiveRows.length;
    }

    /// Get particular range from the sorted collection.
    if (startIndex < effectiveRows.length && endIndex <= effectiveRows.length) {
      _paginatedRows = effectiveRows.getRange(startIndex, endIndex).toList();
    } else {
      _paginatedRows = <DataGridRow>[];
    }

    /// Updates the collection in data pager.
    notifyListeners();

    return Future<bool>.value(true);
  }

  /// Calculates the summary value for the table summary row of a specific column.
  ///
  /// Override this method to write the custom logic to calculate the custom
  /// summary.
  ///
  /// The `summaryColumn` will be null for the spanned table summary columns.
  String calculateSummaryValue(GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex) {
    final int titleColumnSpan = grid_helper.getSummaryTitleColumnSpan(
        _dataGridStateDetails!(), summaryRow);

    if (summaryRow.showSummaryInRow ||
        (!summaryRow.showSummaryInRow &&
            titleColumnSpan > 0 &&
            rowColumnIndex.columnIndex < titleColumnSpan)) {
      String title = summaryRow.title ?? '';
      if (summaryRow.title != null) {
        for (final GridSummaryColumn cell in summaryRow.columns) {
          if (title.contains(cell.name)) {
            final String summaryValue =
                grid_helper.getSummaryValue(cell, _effectiveRows);
            title = title.replaceAll('{${cell.name}}', summaryValue);
          }
        }
      }
      return title;
    } else {
      return grid_helper.getSummaryValue(summaryColumn!, _effectiveRows);
    }
  }

  /// Called to obtain the widget for each cell of the table summary row.
  ///
  /// Typically, a [Text] widget. `summaryValue` argument holds the calculated
  /// summary value based on [GridSummaryColumn.summaryType]. Use this
  /// `summaryValue` argument and display in your required widget.
  ///
  /// This method will be called for visible cells in table summary rows.
  ///
  /// The `summaryColumn` will be null for the spanned table summary columns.
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return null;
  }
}

/// Refreshes the effective rows based on the given `filterRows`.
void refreshEffectiveRows(DataGridSource source, List<DataGridRow> filterRows) {
  source._effectiveRows = filterRows;
}

/// Controls a [SfDataGrid] widget.
///
/// This can be used to control the selection and current-cell operations such
/// as programmatically select a row or rows, move the current-cell to
/// required position.
///
/// DataGrid controllers are typically stored as member variables in [State]
/// objects and are reused in each [State.build].
class DataGridController extends DataGridSourceChangeNotifier {
  /// Creates the [DataGridController] with the [selectedIndex], [selectedRow]
  /// and [selectedRows].
  DataGridController(
      {int selectedIndex = -1,
      DataGridRow? selectedRow,
      List<DataGridRow> selectedRows = const <DataGridRow>[]})
      : _selectedRow = selectedRow,
        _selectedIndex = selectedIndex,
        _selectedRows = selectedRows.toList() {
    _currentCell = RowColumnIndex(-1, -1);
    _horizontalOffset = 0.0;
    _verticalOffset = 0.0;
  }

  DataGridStateDetails? _dataGridStateDetails;

  /// The collection of objects that contains object of corresponding
  /// to the selected rows in [SfDataGrid].
  List<DataGridRow> get selectedRows => _selectedRows;
  List<DataGridRow> _selectedRows = List<DataGridRow>.empty();

  /// The collection of objects that contains object of corresponding
  /// to the selected rows in [SfDataGrid].
  set selectedRows(List<DataGridRow> newSelectedRows) {
    if (_selectedRows == newSelectedRows) {
      return;
    }

    _selectedRows = newSelectedRows;
    _notifyDataGridPropertyChangeListeners(propertyName: 'selectedRows');
  }

  /// An index of the corresponding selected row.
  int get selectedIndex => _selectedIndex;
  int _selectedIndex;

  /// Whether the currently selected cell is in editing mode.
  bool get isCurrentCellInEditing => _isCurrentCellInEditing();

  bool _isCurrentCellInEditing() {
    if (_dataGridStateDetails != null) {
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails!();
      return dataGridConfiguration.currentCell.isEditing;
    } else {
      return false;
    }
  }

  /// An index of the corresponding selected row.
  set selectedIndex(int newSelectedIndex) {
    if (_selectedIndex == newSelectedIndex) {
      return;
    }

    _selectedIndex = newSelectedIndex;
    _notifyDataGridPropertyChangeListeners(propertyName: 'selectedIndex');
  }

  /// An object of the corresponding selected row.
  ///
  /// The given object must be given from the underlying datasource of the
  /// [SfDataGrid].
  DataGridRow? get selectedRow => _selectedRow;
  DataGridRow? _selectedRow;

  /// An object of the corresponding selected row.
  ///
  /// The given object must be given from the underlying datasource of the
  /// [SfDataGrid].
  set selectedRow(DataGridRow? newSelectedRow) {
    if (_selectedRow == newSelectedRow) {
      return;
    }

    _selectedRow = newSelectedRow;
    _notifyDataGridPropertyChangeListeners(propertyName: 'selectedRow');
  }

  /// The current scroll offset of the vertical scrollbar.
  double get verticalOffset => _verticalOffset;
  late double _verticalOffset;

  /// The current scroll offset of the horizontal scrollbar.
  double get horizontalOffset => _horizontalOffset;
  late double _horizontalOffset;

  ///If the [rowIndex] alone is given, the entire row will be set as dirty.
  ///So, data which is displayed in a row will be refreshed.
  /// You can call this method when the data is updated in row in
  ///  underlying datasource.
  ///
  /// If the `recalculateRowHeight` is set as true along with the [rowIndex],
  /// [SfDataGrid.onQueryRowHeight] callback will be called for that row.
  ///  So, the row height can be reset based on the modified data.
  ///  This is useful when setting auto row height
  /// using [SfDataGrid.onQueryRowHeight] callback.
  void refreshRow(int rowIndex, {bool recalculateRowHeight = false}) {
    _notifyDataGridPropertyChangeListeners(
        rowColumnIndex: RowColumnIndex(rowIndex, -1),
        propertyName: 'refreshRow',
        recalculateRowHeight: recalculateRowHeight);
  }

  /// A cell which is currently active.
  ///
  /// This is used to identify the currently active cell to process the
  /// key navigation.
  RowColumnIndex get currentCell => _currentCell;
  RowColumnIndex _currentCell = RowColumnIndex.empty;

  /// Moves the current-cell to the specified cell coordinates.
  void moveCurrentCellTo(RowColumnIndex rowColumnIndex) {
    if (_dataGridStateDetails != null) {
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails!();
      if (rowColumnIndex != RowColumnIndex(-1, -1) &&
          dataGridConfiguration.selectionMode != SelectionMode.none &&
          dataGridConfiguration.navigationMode != GridNavigationMode.row) {
        final int rowIndex = grid_helper.resolveToRowIndex(
            dataGridConfiguration, rowColumnIndex.rowIndex);
        final int columnIndex = grid_helper.resolveToGridVisibleColumnIndex(
            dataGridConfiguration, rowColumnIndex.columnIndex);
        // Ignore the scrolling when the row index or column index are in negative
        // or invalid.
        if (rowIndex.isNegative || columnIndex.isNegative) {
          return;
        }
        final SelectionManagerBase rowSelectionController =
            dataGridConfiguration.rowSelectionManager;
        if (rowSelectionController is RowSelectionManager) {
          selection_manager.processSelectionAndCurrentCell(
              dataGridConfiguration, RowColumnIndex(rowIndex, columnIndex),
              isProgrammatic: true);
        }
      }
    }
  }

  /// Scrolls the [SfDataGrid] to the given row and column index.
  ///
  /// If you want animation on scrolling, you can pass true as canAnimate argument.
  ///
  /// Also, you can control the position of a row when it comes to view by
  /// passing the [DataGridScrollPosition] as an argument for rowPosition where
  /// as you can pass [DataGridScrollPosition] as an argument for columnPosition
  /// to control the position of a column.
  Future<void> scrollToCell(double rowIndex, double columnIndex,
      {bool canAnimate = false,
      DataGridScrollPosition rowPosition = DataGridScrollPosition.start,
      DataGridScrollPosition columnPosition =
          DataGridScrollPosition.start}) async {
    if (_dataGridStateDetails != null) {
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails!();
      final ScrollAxisBase scrollRows =
          dataGridConfiguration.container.scrollRows;
      final ScrollAxisBase scrollColumns =
          dataGridConfiguration.container.scrollColumns;

      if (rowIndex > dataGridConfiguration.container.rowCount ||
          columnIndex > scrollColumns.lineCount ||
          (rowIndex.isNegative && columnIndex.isNegative)) {
        return;
      }

      final int getRowIndex = grid_helper.resolveToRowIndex(
          dataGridConfiguration, rowIndex.toInt());
      final int getColumnIndex = grid_helper.resolveToGridVisibleColumnIndex(
          dataGridConfiguration, columnIndex.toInt());
      double verticalOffset =
          grid_helper.getVerticalOffset(dataGridConfiguration, getRowIndex);
      double horizontalOffset = grid_helper.getHorizontalOffset(
          dataGridConfiguration, getColumnIndex);

      if (dataGridConfiguration.textDirection == TextDirection.rtl &&
          columnIndex == -1) {
        horizontalOffset = dataGridConfiguration.container.extentWidth -
                    dataGridConfiguration.viewWidth -
                    horizontalOffset >
                0
            ? dataGridConfiguration.container.extentWidth -
                dataGridConfiguration.viewWidth -
                horizontalOffset
            : 0;
      }

      verticalOffset = grid_helper.resolveScrollOffsetToPosition(
          rowPosition,
          scrollRows,
          verticalOffset,
          dataGridConfiguration.viewHeight,
          scrollRows.headerExtent,
          scrollRows.footerExtent,
          dataGridConfiguration.rowHeight,
          dataGridConfiguration.container.verticalOffset,
          getRowIndex);

      horizontalOffset = grid_helper.resolveScrollOffsetToPosition(
          columnPosition,
          scrollColumns,
          horizontalOffset,
          dataGridConfiguration.viewWidth,
          scrollColumns.headerExtent,
          scrollColumns.footerExtent,
          dataGridConfiguration.defaultColumnWidth,
          dataGridConfiguration.container.horizontalOffset,
          getColumnIndex);

      grid_helper.scrollVertical(
          dataGridConfiguration, verticalOffset, canAnimate);
      // Need to add await for the horizontal scrolling alone, to avoid the delay time between vertical and horizontal scrolling.
      await grid_helper.scrollHorizontal(
          dataGridConfiguration, horizontalOffset, canAnimate);
    }
  }

  /// Scrolls the [SfDataGrid] to the given index.
  ///
  /// If you want animation on scrolling, you can pass true as canAnimate argument.
  ///
  /// Also, you can control the position of a row when it comes to view by passing
  /// the [DataGridScrollPosition] as an argument for position.
  Future<void> scrollToRow(double rowIndex,
      {bool canAnimate = false,
      DataGridScrollPosition position = DataGridScrollPosition.start}) async {
    return scrollToCell(rowIndex, -1,
        canAnimate: canAnimate, rowPosition: position);
  }

  /// Scrolls the [SfDataGrid] to the given column index.
  ///
  /// If you want animation on scrolling, you can pass true as canAnimate argument.
  ///
  /// Also, you can control the position of a row when it comes to view by passing
  /// the [DataGridScrollPosition] as an argument for position.
  Future<void> scrollToColumn(double columnIndex,
      {bool canAnimate = false,
      DataGridScrollPosition position = DataGridScrollPosition.start}) async {
    return scrollToCell(-1, columnIndex,
        canAnimate: canAnimate, columnPosition: position);
  }

  /// Scroll the vertical scrollbar from current position to the given value.
  ///
  /// If you want animation on scrolling, you can pass true as canAnimate argument.
  Future<void> scrollToVerticalOffset(double offset,
      {bool canAnimate = false}) async {
    if (_dataGridStateDetails != null) {
      final DataGridConfiguration dataGridSettings = _dataGridStateDetails!();
      return grid_helper.scrollVertical(dataGridSettings, offset, canAnimate);
    }
  }

  /// Scroll the horizontal scrollbar from current value to the given value.
  ///
  /// If you want animation on scrolling, you can pass true as canAnimate argument.
  Future<void> scrollToHorizontalOffset(double offset,
      {bool canAnimate = false}) async {
    if (_dataGridStateDetails != null) {
      final DataGridConfiguration dataGridSettings = _dataGridStateDetails!();
      return grid_helper.scrollHorizontal(dataGridSettings, offset, canAnimate);
    }
  }

  /// Begins the edit to the given [RowColumnIndex] in [SfDataGrid].
  void beginEdit(RowColumnIndex rowColumnIndex) {
    if (_dataGridStateDetails != null) {
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails!();
      if (!dataGridConfiguration.allowEditing ||
          dataGridConfiguration.selectionMode == SelectionMode.none ||
          dataGridConfiguration.navigationMode == GridNavigationMode.row) {
        return;
      }

      dataGridConfiguration.currentCell.onCellBeginEdit(
          editingRowColumnIndex: rowColumnIndex, isProgrammatic: true);
    }
  }

  /// Ends the current editing of a cell in [SfDataGrid].
  void endEdit() {
    if (_dataGridStateDetails != null) {
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails!();
      if (!dataGridConfiguration.allowEditing ||
          dataGridConfiguration.selectionMode == SelectionMode.none ||
          dataGridConfiguration.navigationMode == GridNavigationMode.row) {
        return;
      }

      dataGridConfiguration.currentCell.onCellSubmit(dataGridConfiguration);
    }
  }
}

/// A delegate that provides the row count details and method to listen the
/// page navigation in [SfDataPager].
///
/// The following code initializes the data source and controller.
///
/// ```dart
/// finalList<Employee>paginatedDataTable=<Employee>[];
/// ```
///
/// The following code example shows how to initialize the [DataPagerDelegate].
///
/// ```dart
/// class PaginatedDataGridSource extends DataPagerDelegate{
/// @override
/// Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
///  _paginatedData = paginatedDataTable
///    .getRange(startRowIndex, endRowIndex )
///    .toList(growable: false);
///  notifyListeners();
///  return true;
/// }
/// }
/// ```
class DataPagerDelegate {
  /// Number of pages to be displayed in the [SfDataPager].
  double _pageCount = 0;

  /// Called when the page is navigated.
  ///
  /// Return true, if the navigation should be performed. Otherwise, return
  /// false to disable the navigation for specific page index.
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    return true;
  }
}

/// A class that can be provided the change notification to the [SfDataGrid].
class DataGridSourceChangeNotifier extends ChangeNotifier {
  final ObserverList<_DataGridSourceListener> _dataGridSourceListeners =
      ObserverList<_DataGridSourceListener>();

  void _addDataGridSourceListener(_DataGridSourceListener listener) {
    _dataGridSourceListeners.add(listener);
  }

  void _removeDataGridSourceListener(_DataGridSourceListener listener) {
    _dataGridSourceListeners.remove(listener);
  }

  final ObserverList<_DataGridPropertyChangeListener>
      _dataGridPropertyChangeListeners =
      ObserverList<_DataGridPropertyChangeListener>();

  void _addDataGridPropertyChangeListener(
      _DataGridPropertyChangeListener listener) {
    _dataGridPropertyChangeListeners.add(listener);
  }

  void _removeDataGridPropertyChangeListener(
      _DataGridPropertyChangeListener listener) {
    _dataGridPropertyChangeListeners.remove(listener);
  }

  @protected
  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  /// Calls all the datagrid source listeners.
  /// Call this method whenever the underlying data is added or removed. If the value of the specific cell is updated, call this method with RowColumnIndex argument where it refers the corresponding row and column index of the cell.
  @protected
  void notifyDataSourceListeners({RowColumnIndex? rowColumnIndex}) {
    for (final Function listener in _dataGridSourceListeners) {
      listener(rowColumnIndex: rowColumnIndex);
    }
  }

  /// Call this method whenever the rowColumnIndex, propertyName and recalculateRowHeight of the underlying data are updated internally.
  void _notifyDataGridPropertyChangeListeners(
      {RowColumnIndex? rowColumnIndex,
      String? propertyName,
      bool recalculateRowHeight = false}) {
    for (final Function listener in _dataGridPropertyChangeListeners) {
      listener(
          rowColumnIndex: rowColumnIndex,
          propertyName: propertyName,
          recalculateRowHeight: recalculateRowHeight);
    }
  }
}

/// Call this method whenever the rowColumnIndex, propertyName and recalculateRowHeight of the
/// underlying data are updated internally.
void notifyDataGridPropertyChangeListeners(DataGridSource source,
    {RowColumnIndex? rowColumnIndex,
    String? propertyName,
    bool recalculateRowHeight = false}) {
  source._notifyDataGridPropertyChangeListeners(
      rowColumnIndex: rowColumnIndex,
      recalculateRowHeight: recalculateRowHeight,
      propertyName: propertyName);
}

/// Invokes the `handleLoadMoreRows` method in [DataGridSource].
Future<void> handleLoadMoreRows(DataGridSource source) async {
  return source.handleLoadMoreRows();
}

/// Invokes the `handleRefresh` method in [DataGridSource].
Future<void> handleRefresh(DataGridSource source) async {
  return source.handleRefresh();
}

/// Refreshes the current [DataGridSource].
void updateDataSource(DataGridSource source) {
  source._updateDataSource();
}

/// Gets the `effectiveRows` from the [DataGridSource].
List<DataGridRow> effectiveRows(DataGridSource source) {
  if (source._paginatedRows.isNotEmpty && source._pageCount > 0.0) {
    return source._paginatedRows;
  } else {
    return source._effectiveRows;
  }
}

/// Helps to set the page count in DataGridSource.
void setPageCount(DataPagerDelegate delegate, double pageCount) {
  final DataGridSource source = delegate as DataGridSource;
  final double oldPageCount = source._pageCount;
  source._pageCount = pageCount;

  /// If the pageCount is changed during CRUD operation(while removing last page), we should update the
  /// current page.
  if (oldPageCount != pageCount) {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      source.notifyListeners();
    });
  }

  /// User removes the DataPager in view at runtime, we need to reset the
  /// DataPager properties in DataGridSource.
  if (source._paginatedRows.isNotEmpty && source._pageCount == 0.0) {
    /// We couldn't refresh the view at same time when framework doing an
    /// frame refreshing.
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      source._paginatedRows = <DataGridRow>[];
      source.notifyDataSourceListeners();
    });
  }
}

/// Sets the given selected index to the controller's `selectedIndex` property.
void updateSelectedIndex(DataGridController controller, int newSelectedIndex) {
  controller._selectedIndex = newSelectedIndex;
}

/// Updates the given [DataGridRow] to the controller's `selectedRow` property.
void updateSelectedRow(
    DataGridController controller, DataGridRow? newSelectedRow) {
  controller._selectedRow = newSelectedRow;
}

/// Updates the given index to the controller's `currentCell` property.
void updateCurrentCellIndex(
    DataGridController controller, RowColumnIndex newCurrentCellIndex) {
  controller._currentCell = newCurrentCellIndex;
}

/// Updates the given offset to the controller's `verticalOffset` property.
void updateVerticalOffset(DataGridController controller, double offset) {
  controller._verticalOffset = offset;
}

/// Updates the given offset to the controller's `horizontalOffset` property.
void updateHorizontalOffset(DataGridController controller, double offset) {
  controller._horizontalOffset = offset;
}

/// Sets the `childColumnIndexes` property in the [StackedHeaderCell].
void setChildColumnIndexes(
    StackedHeaderCell stackedHeaderCell, List<int> childSequence) {
  stackedHeaderCell._childColumnIndexes = childSequence;
}

/// Helps to get the child column indexes of the given `StackedHeaderCell`.
List<int> getChildColumnIndexes(StackedHeaderCell stackedHeaderCell) {
  return stackedHeaderCell._childColumnIndexes;
}

/// Call this method to add the [FilterCondition] in the UI filtering.
void addFilterConditions(DataGridSource source, String columnName,
    List<FilterCondition> conditions) {
  source._filterConditions[columnName] = conditions;
}

/// Call this method to remove the [FilterCondition] in the UI filtering.
void removeFilterConditions(DataGridSource source, String columnName) {
  source._filterConditions.remove(columnName);
}

/// ToDo
class DataGridThemeHelper {
  /// ToDo

  DataGridThemeHelper(
      SfDataGridThemeData? dataGridThemeData, ColorScheme? colorScheme) {
    brightness = dataGridThemeData!.brightness ?? colorScheme!.brightness;
    headerColor =
        dataGridThemeData.headerColor ?? Colors.transparent.withOpacity(0.0001);
    gridLineColor = dataGridThemeData.gridLineColor ??
        colorScheme!.onSurface.withOpacity(0.12);
    gridLineStrokeWidth = dataGridThemeData.gridLineStrokeWidth ?? 1;
    frozenPaneElevation = dataGridThemeData.frozenPaneElevation ?? 5;
    frozenPaneLineWidth = dataGridThemeData.frozenPaneLineWidth ?? 2;
    selectionColor = dataGridThemeData.selectionColor ??
        colorScheme!.onSurface.withOpacity(0.08);
    headerHoverColor = dataGridThemeData.headerHoverColor ??
        colorScheme!.onSurface.withOpacity(0.04);
    rowHoverColor = dataGridThemeData.rowHoverColor ??
        colorScheme!.onSurface.withOpacity(0.04);
    sortIconColor = dataGridThemeData.sortIconColor ??
        colorScheme!.onSurface.withOpacity(0.6);
    frozenPaneLineColor = dataGridThemeData.frozenPaneLineColor ??
        colorScheme!.onSurface.withOpacity(0.38);
    columnResizeIndicatorColor =
        dataGridThemeData.columnResizeIndicatorColor ?? colorScheme!.primary;
    columnResizeIndicatorStrokeWidth =
        dataGridThemeData.columnResizeIndicatorStrokeWidth ?? 2;
    currentCellStyle = dataGridThemeData.currentCellStyle ??
        DataGridCurrentCellStyle(
            borderColor: colorScheme!.onSurface.withOpacity(0.26),
            borderWidth: 1.0);
    rowHoverTextStyle = dataGridThemeData.rowHoverTextStyle ??
        TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: colorScheme!.onSurface.withOpacity(0.87));
    sortIcon = dataGridThemeData.sortIcon;
  }

  ///ToDo
  late Brightness brightness;

// ignore: public_member_api_docs
  late Color headerColor;

  /// To do
  late Color gridLineColor;

  /// To do

  late double gridLineStrokeWidth;

  /// To do

  late Color selectionColor;

  /// To do

  late DataGridCurrentCellStyle currentCellStyle;

  /// To do

  late double frozenPaneLineWidth;

  /// To do

  late Color frozenPaneLineColor;

  /// To do

  late Color sortIconColor;

  /// To do

  late Color headerHoverColor;

  /// To do

  late double frozenPaneElevation;

  /// To do

  late Color columnResizeIndicatorColor;

  /// To do

  late double columnResizeIndicatorStrokeWidth;

  /// To do

  late Color rowHoverColor;

  /// To do

  late TextStyle rowHoverTextStyle;

  /// To do

  late Widget? sortIcon;
}
