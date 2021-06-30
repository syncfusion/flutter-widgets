part of datagrid;

/// Signature for the `_DataGridSettings` callback.
typedef _DataGridStateDetails = _DataGridSettings Function();

/// Signature for [SfDataGrid.onQueryRowHeight] callback
typedef QueryRowHeightCallback = double Function(RowHeightDetails details);

/// Signature for [SfDataGrid.onSelectionChanging] callback.
typedef SelectionChangingCallback = bool Function(
    List<DataGridRow> addedRows, List<DataGridRow> removedRows);

/// Signature for [SfDataGrid.onSelectionChanged] callback.
typedef SelectionChangedCallback = void Function(
    List<DataGridRow> addedRows, List<DataGridRow> removedRows);

/// Signature for [SfDataGrid.onCellRenderersCreated] callback.
typedef CellRenderersCreatedCallback = void Function(
    Map<String, GridCellRendererBase> cellRenderers);

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
    BuildContext context, DataGridRow dataGridRow);

/// The signature of [DataGridSource.canSubmitCell] and
/// [DataGridSource.onCellSubmit] methods.
typedef CellSubmit = void Function();

/// Row configuration and cell data for a [SfDataGrid].
///
/// Return this list of [DataGridRow] objects to [DataGridSource.rows] property.
///
/// The data for each row can be passed as the cells argument to the
/// constructor of each [DataGridRow] object.
class DataGridRow {
  /// ToDo
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
  /// ToDo
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
  /// ToDo
  const DataGridRowAdapter({required this.cells, this.key, this.color});

  /// ToDo
  final Key? key;

  /// The color for the row.
  final Color? color;

  /// The widget of each cell for this row.
  ///
  /// There must be exactly as many cells as there are columns in the
  /// [SfDataGrid].
  final List<Widget> cells;
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
  const SfDataGrid(
      {required this.source,
      required this.columns,
      Key? key,
      this.rowHeight = double.nan,
      this.headerRowHeight = double.nan,
      this.defaultColumnWidth = double.nan,
      this.gridLinesVisibility = GridLinesVisibility.horizontal,
      this.headerGridLinesVisibility = GridLinesVisibility.horizontal,
      this.columnWidthMode = ColumnWidthMode.none,
      this.columnSizer,
      this.columnWidthCalculationRange =
          ColumnWidthCalculationRange.visibleRows,
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
      this.onCellRenderersCreated,
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
      this.allowEditing = false,
      this.editingGestureType = EditingGestureType.doubleTap,
      this.footer,
      this.footerHeight = 49.0})
      : assert(frozenColumnsCount >= 0),
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
  /// Each column associated with its own renderer and it controls the
  /// corresponding column related operations.
  ///
  /// Defaults to null.
  final List<GridColumn> columns;

  /// The datasource that provides the data for each row in [SfDataGrid]. Must
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

  /// Called when the cell renderers are created for each column.
  ///
  /// This method is called once when the [SfDataGrid] is loaded. Users can
  /// provide the custom cell renderer to the existing collection.
  final CellRenderersCreatedCallback? onCellRenderersCreated;

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

  /// Called when a long press gesture with a primary button has been
  /// recognized for a cell.
  final DataGridCellTapCallback? onCellSecondaryTap;

  /// Called when a tap with a cell has occurred with a secondary button.
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
  /// [footerFrozenColumnsCount]
  /// [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
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
  /// [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
  /// color of the frozen line.
  final int footerFrozenColumnsCount;

  /// The number of non-scrolling rows at the top of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// [footerFrozenRowsCount]
  /// [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
  /// color of the frozen line.
  final int frozenRowsCount;

  /// The number of non-scrolling rows at the bottom of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// [SfDataGridThemeData.frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData.frozenPaneLineColor], which is used to customize the
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
  /// [SfDataGrid.onSwipeStart]
  /// [SfDataGrid.onSwipeUpdate]
  /// [SfDataGrid.onSwipeEnd]
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
  /// [SfDataGridThemeData.rowHoverColor] – This helps you to change row highlighting color on hovering.
  /// [SfDataGridThemeData.rowHoverTextStyle] – This helps you to change the [TextStyle] of row on hovering.
  final bool highlightRowOnHover;

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

  late _RowGenerator _rowGenerator;
  late _VisualContainerHelper _container;
  late _DataGridStateDetails _dataGridStateDetails;
  late _DataGridSettings _dataGridSettings;
  late ColumnSizer _columnSizer;
  late _CurrentCellManager _currentCell;
  AnimationController? _swipingAnimationController;

  late Map<String, GridCellRendererBase> _cellRenderers;
  TextDirection _textDirection = TextDirection.ltr;
  SfDataGridThemeData? _dataGridThemeData;
  DataGridSource? _source;
  List<GridColumn>? _columns;
  SelectionManagerBase? _rowSelectionManager;
  DataGridController? _controller;
  Animation<double>? _swipingAnimation;

  @override
  void initState() {
    _columns = <GridColumn>[];
    _dataGridSettings = _DataGridSettings();
    _dataGridStateDetails = _onDataGridStateDetailsChanged;
    _dataGridSettings.gridPaint = Paint();

    _rowGenerator = _RowGenerator(dataGridStateDetails: _dataGridStateDetails);
    _container = _VisualContainerHelper(rowGenerator: _rowGenerator);
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
    _dataGridSettings.textDirection = newTextDirection;
    _container._needToSetHorizontalOffset = true;
  }

  void _onDataGridThemeDataChanged(SfDataGridThemeData? newThemeData) {
    if (newThemeData == null || _dataGridThemeData == newThemeData) {
      return;
    }

    final bool canUpdate =
        _dataGridThemeData != null && _dataGridThemeData != newThemeData;
    _dataGridThemeData = newThemeData;
    _dataGridSettings.dataGridThemeData = newThemeData;
    _updateDecoration();
    if (canUpdate) {
      _container._refreshViewStyle();
    }
  }

  void _onDataGridTextScaleFactorChanged(double textScaleFactor) {
    if (textScaleFactor == _dataGridSettings.textScaleFactor) {
      return;
    }

    _dataGridSettings.textScaleFactor = textScaleFactor;
    _dataGridSettings.headerRowHeight = widget.headerRowHeight.isNaN
        ? (_dataGridSettings.textScaleFactor > 1.0)
            ? _headerRowHeight * _dataGridSettings.textScaleFactor
            : _headerRowHeight
        : widget.headerRowHeight;
    _dataGridSettings.rowHeight = widget.rowHeight.isNaN
        ? (_dataGridSettings.textScaleFactor > 1.0)
            ? _rowHeight * _dataGridSettings.textScaleFactor
            : _rowHeight
        : widget.rowHeight;
    // Refreshes the default line size, column widths and row heights in initial
    // `SfDataGrid` build. So, restricts the codes in initial loading by using
    // the `_container._isGridLoaded` property.
    if (_container._isGridLoaded) {
      if (_dataGridSettings.columnWidthMode != ColumnWidthMode.none) {
        _dataGridSettings.columnSizer._resetAutoCalculation();
        if (!_container._isDirty) {
          // Refreshes the autofit columns only if don't have explicit width.
          _dataGridSettings.columnSizer._refresh(0.0);
        }
      }
      // Refresh header rows height.
      _updateHeaderRowHeight();
      // Refresh data rows height.
      _container.rowHeights.defaultLineSize = _dataGridSettings.rowHeight;
      if (!_container._isDirty) {
        _container.setRowHeights();
      }
    }
  }

  void _updateHeaderRowHeight() {
    final _LineSizeCollection lineSizeCollection =
        _container.columnWidths as _LineSizeCollection;
    lineSizeCollection.suspendUpdates();
    final int headerIndex =
        _GridIndexResolver.getHeaderIndex(_dataGridSettings);
    if (_container.rowCount > 0) {
      for (int i = 0; i <= headerIndex; i++) {
        _container.rowHeights[i] = _dataGridSettings.headerRowHeight;
      }
    }
    lineSizeCollection.resumeUpdates();
    _container.updateScrollBars();
  }

  void _setUp() {
    _initializeDataGridDataSource();
    _initializeCellRendererCollection();

    //DataGrid Controller
    _controller =
        _dataGridSettings.controller = widget.controller ?? DataGridController()
          .._dataGridStateDetails = _dataGridStateDetails;

    _controller!._addDataGridPropertyChangeListener(
        _handleDataGridPropertyChangeListeners);

    _dataGridSettings.verticalScrollController =
        widget.verticalScrollController ?? ScrollController();
    _dataGridSettings.horizontalScrollController =
        widget.horizontalScrollController ?? ScrollController();

    //AutoFit controller initializing
    _columnSizer =
        _dataGridSettings.columnSizer = widget.columnSizer ?? ColumnSizer()
          .._dataGridStateDetails = _dataGridStateDetails;

    //CurrentCell Manager initializing
    _currentCell = _dataGridSettings.currentCell =
        _CurrentCellManager(dataGridStateDetails: _dataGridStateDetails);

    //Selection Manager initializing
    _rowSelectionManager = _dataGridSettings.rowSelectionManager =
        widget.selectionManager ?? RowSelectionManager();
    _rowSelectionManager!._dataGridStateDetails = _dataGridStateDetails;
    _controller!._addDataGridPropertyChangeListener(
        _rowSelectionManager!._handleSelectionPropertyChanged);

    _initializeProperties();
  }

  @protected
  void _gridLoaded() {
    _container._refreshDefaultLineSize();
    _refreshContainerAndView();
  }

  @protected
  void _refreshContainerAndView({bool isDataSourceChanged = false}) {
    if (isDataSourceChanged) {
      _rowSelectionManager!
          ._updateSelectionController(isDataSourceChanged: isDataSourceChanged);
    }

    _ensureSelectionProperties();
    _container
      .._refreshHeaderLineCount()
      .._updateRowAndColumnCount()
      .._isGridLoaded = true;
  }

  void _updateVisualDensity(VisualDensity visualDensity) {
    if (_dataGridSettings.visualDensity == visualDensity) {
      return;
    }

    final Offset baseDensity = visualDensity.baseSizeAdjustment;

    _dataGridSettings
      ..visualDensity = visualDensity
      ..headerRowHeight += baseDensity.dy
      ..rowHeight += baseDensity.dy;

    // Refreshes the default line size, and row heights in initial
    // `SfDataGrid` build. So, restricts the codes in initial loading by using
    // the `_container._isGridLoaded` property.
    if (_container._isGridLoaded) {
      // Refresh header rows height.
      _updateHeaderRowHeight();
      // Refresh data rows height.
      _container.rowHeights.defaultLineSize = _dataGridSettings.rowHeight;
    }
  }

  void _initializeDataGridDataSource() {
    if (_source != widget.source) {
      _removeDataGridSourceListeners();
      _source = widget.source;
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

    _rowSelectionManager?._dataGridStateDetails = _dataGridStateDetails;
    _currentCell._dataGridStateDetails = _dataGridStateDetails;
    _columnSizer._dataGridStateDetails = _dataGridStateDetails;
    _updateDataGridStateDetails();
  }

  void _initializeCellRendererCollection() {
    _cellRenderers = <String, GridCellRendererBase>{};
    _cellRenderers['TextField'] =
        GridCellTextFieldRenderer(_dataGridStateDetails);
    _cellRenderers['ColumnHeader'] =
        GridHeaderCellRenderer(_dataGridStateDetails);
    _cellRenderers['StackedHeader'] =
        _GridStackedHeaderCellRenderer(_dataGridStateDetails);

    if (widget.onCellRenderersCreated != null) {
      widget.onCellRenderersCreated!(_cellRenderers);
      for (final MapEntry<String, GridCellRendererBase> renderer
          in _cellRenderers.entries) {
        renderer.value._dataGridStateDetails = _dataGridStateDetails;
      }
    }
  }

  void _processCellUpdate(RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex != RowColumnIndex(-1, -1)) {
      final int rowIndex = _GridIndexResolver.resolveToRowIndex(
          _dataGridSettings, rowColumnIndex.rowIndex);
      final int columnIndex = _GridIndexResolver.resolveToScrollColumnIndex(
          _dataGridSettings, rowColumnIndex.columnIndex);

      final DataRowBase? dataRow = _rowGenerator.items.firstWhereOrNull(
          (DataRowBase dataRow) => dataRow.rowIndex == rowIndex);

      if (dataRow == null) {
        return;
      }

      dataRow._dataGridRow = _source!._effectiveRows[rowColumnIndex.rowIndex];
      dataRow._dataGridRowAdapter = _SfDataGridHelper.getDataGridRowAdapter(
          _dataGridSettings, dataRow._dataGridRow!);

      final DataCellBase? dataCell = dataRow._visibleColumns.firstWhereOrNull(
          (DataCellBase dataCell) => dataCell.columnIndex == columnIndex);

      if (dataCell == null) {
        return;
      }

      setState(() {
        dataCell
          .._isDirty = true
          .._updateColumn();
      });
    }
  }

  void _processUpdateDataSource() {
    setState(() {
      // Need to endEdit the editing [DataGridCell] before perform refreshing.
      if (_dataGridSettings.currentCell.isEditing) {
        _dataGridSettings.currentCell
            ._onCellSubmit(_dataGridSettings, canRefresh: false);
      }

      _initializeDataGridDataSource();
      _dataGridSettings.source = _source!;

      if (!listEquals<GridColumn>(_columns, widget.columns)) {
        if (widget.selectionMode != SelectionMode.none &&
            widget.navigationMode == GridNavigationMode.cell &&
            _rowSelectionManager != null) {
          _rowSelectionManager!._onRowColumnChanged(-1, widget.columns.length);
        }

        _resetColumn();
      }

      if (widget.selectionMode != SelectionMode.none &&
          widget.navigationMode == GridNavigationMode.cell &&
          _rowSelectionManager != null) {
        _rowSelectionManager!
            ._onRowColumnChanged(widget.source._effectiveRows.length, -1);
      }

      if (widget.allowSwiping) {
        _dataGridSettings.container.resetSwipeOffset();
      }

      if (widget.footer != null) {
        final DataRowBase? footerRow = _rowGenerator.items.firstWhereOrNull(
            (DataRowBase row) =>
                row.rowType == RowType.footerRow && row.rowIndex >= 0);
        if (footerRow != null) {
          // Need to reset the old footer row height in rowHeights collection.
          _container.rowHeights[footerRow.rowIndex] =
              _dataGridSettings.rowHeight;
        }
      }

      _container
        .._updateRowAndColumnCount()
        .._refreshView()
        .._isDirty = true;

      // FLUT-3219 Need to reset the vertical offset when both the controller offset
      // scrollbar offset are not identical
      if (_dataGridSettings.verticalScrollController != null &&
          _dataGridSettings.verticalScrollController!.hasClients &&
          _dataGridSettings.verticalScrollController!.offset == 0 &&
          _dataGridSettings.container.verticalOffset > 0) {
        _dataGridSettings.container.verticalOffset = 0;
        _dataGridSettings.container.verticalScrollBar._value = 0;
      }
    });
    if (_dataGridSettings.source.shouldRecalculateColumnWidths()) {
      _dataGridSettings.columnSizer._resetAutoCalculation();
    }

    if (_dataGridSettings.dataGridFocusNode != null &&
        !_dataGridSettings.dataGridFocusNode!.hasPrimaryFocus) {
      _dataGridSettings.dataGridFocusNode!.requestFocus();
    }
  }

  void _processSorting() {
    setState(() {
      _container
        .._updateRowAndColumnCount()
        .._refreshView()
        .._isDirty = true;
    });
  }

  void _resetColumn({bool clearEditing = true}) {
    if (_columns != null) {
      _columns!
        ..clear()
        ..addAll(widget.columns);
      _dataGridSettings.columns = _columns!;
    }

    for (final DataRowBase dataRow in _rowGenerator.items) {
      if (!clearEditing && dataRow._isEditing) {
        return;
      }

      for (final DataCellBase dataCell in dataRow._visibleColumns) {
        dataCell.columnIndex = -1;
      }
    }

    if (_textDirection == TextDirection.rtl) {
      _container._needToSetHorizontalOffset = true;
    }
    _container._needToRefreshColumn = true;
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
        _dataGridSettings.currentCell
            ._onCellSubmit(_dataGridSettings, canRefresh: false);
        final int rowIndex = _GridIndexResolver.resolveToRowIndex(
            _dataGridSettings, rowColumnIndex.rowIndex);

        final DataRowBase? dataRow = _rowGenerator.items.firstWhereOrNull(
            (DataRowBase dataRow) => dataRow.rowIndex == rowIndex);

        if (dataRow == null) {
          return;
        }
        setState(() {
          dataRow
            .._isDirty = true
            .._rowIndexChanged();
          if (recalculateRowHeight) {
            _dataGridSettings.container.rowHeightManager.setDirty(rowIndex);
            _dataGridSettings.container
              .._needToRefreshColumn = true
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
        // To rebuild the datagrid on hovering the header cell. isDirtly already
        // been set in header cell widget itself
      });
    }

    if (propertyName == 'Swiping') {
      setState(() {
        // Need to end-edit the editing [DataGridCell] before swiping a
        // [DataGridRow] or refreshing
        _dataGridSettings.currentCell
            ._onCellSubmit(_dataGridSettings, canRefresh: false);
        _container._isDirty = true;
      });
    }

    if (propertyName == 'editing' && rowColumnIndex != null) {
      _processCellUpdate(rowColumnIndex);
    }
  }

  void _updateDataGridStateDetails() {
    _dataGridSettings
      ..source = _source!
      ..columns = _columns!
      ..textDirection = _textDirection
      ..cellRenderers = _cellRenderers
      ..container = _container
      ..rowGenerator = _rowGenerator
      ..visualDensity = _dataGridSettings.visualDensity
      ..headerLineCount = _container._headerLineCount
      ..onQueryRowHeight = widget.onQueryRowHeight
      ..dataGridThemeData = _dataGridThemeData
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
      ..editingGestureType = widget.editingGestureType
      ..allowEditing = widget.allowEditing
      ..rowHeight = (widget.rowHeight.isNaN
          ? _dataGridSettings.rowHeight.isNaN
              ? _rowHeight
              : _dataGridSettings.rowHeight
          : widget.rowHeight)
      ..headerRowHeight = (widget.headerRowHeight.isNaN
          ? _dataGridSettings.headerRowHeight.isNaN
              ? _headerRowHeight
              : _dataGridSettings.headerRowHeight
          : widget.headerRowHeight)
      ..defaultColumnWidth = (widget.defaultColumnWidth.isNaN
          ? _dataGridSettings.defaultColumnWidth
          : widget.defaultColumnWidth)
      ..footer = widget.footer
      ..footerHeight = widget.footerHeight;

    if (widget.allowPullToRefresh) {
      _dataGridSettings.refreshIndicatorKey ??=
          GlobalKey<RefreshIndicatorState>();
    }
  }

  _DataGridSettings _onDataGridStateDetailsChanged() => _dataGridSettings;

  void _updateProperties(SfDataGrid oldWidget) {
    final bool isSourceChanged = widget.source != oldWidget.source;
    final bool isDataSourceChanged =
        !listEquals<DataGridRow>(oldWidget.source.rows, widget.source.rows);
    final bool isColumnsChanged =
        !listEquals<GridColumn>(_columns, widget.columns);
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

    if (oldWidget.verticalScrollController != widget.verticalScrollController) {
      _dataGridSettings.verticalScrollController =
          widget.verticalScrollController ?? ScrollController();
    }

    if (oldWidget.horizontalScrollController !=
        widget.horizontalScrollController) {
      _dataGridSettings.horizontalScrollController =
          widget.horizontalScrollController ?? ScrollController();
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

        if (_dataGridSettings.currentCell.isEditing) {
          _dataGridSettings.currentCell._onCellSubmit(_dataGridSettings,
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
                _dataGridSettings.rowHeight;
            // We remove the old footer view widget and recreate it in
            // `ScrollViewWidget` when the footer property is changed. Thus updates
            // the runtime changes of the footer view widget.
            _rowGenerator.items.remove(footerRow);
          } else if (isSourceChanged ||
              isDataSourceChanged ||
              isStackedHeaderRowsChanged) {
            _container.rowHeights[footerRow.rowIndex] =
                _dataGridSettings.rowHeight;
          }
        }
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
        oldWidget.rowHeight != widget.rowHeight ||
        oldWidget.headerRowHeight != widget.headerRowHeight ||
        oldWidget.defaultColumnWidth != widget.defaultColumnWidth ||
        oldWidget.navigationMode != widget.navigationMode) {
      // Need to endEdit before refreshing
      refreshEditing();

      if (isSourceChanged) {
        _initializeDataGridDataSource();
      }
      if (isSortingChanged || isMultiColumnSortingChanged) {
        if (!widget.allowSorting) {
          _dataGridSettings.source
            ..sortedColumns.clear()
            .._updateDataSource();
        } else if (widget.allowSorting && !widget.allowMultiColumnSorting) {
          while (_dataGridSettings.source.sortedColumns.length > 1) {
            _dataGridSettings.source.sortedColumns.removeAt(0);
          }
          _dataGridSettings.source._updateDataSource();
        }
      }

      if (isDataGridControllerChanged) {
        oldWidget.controller?._addDataGridPropertyChangeListener(
            _handleDataGridPropertyChangeListeners);

        _controller =
            _dataGridSettings.controller = widget.controller ?? _controller!
              .._dataGridStateDetails = _dataGridStateDetails;

        _controller?._addDataGridPropertyChangeListener(
            _handleDataGridPropertyChangeListeners);
      }

      if (oldWidget.columnSizer != widget.columnSizer) {
        _columnSizer =
            _dataGridSettings.columnSizer = widget.columnSizer ?? ColumnSizer()
              .._dataGridStateDetails = _dataGridStateDetails;
      }

      _initializeProperties();

      if (isStackedHeaderRowsChanged || isColumnsChanged) {
        _onStackedHeaderRowsPropertyChanged(oldWidget, widget);
      }

      refreshFooterView();

      _container._refreshDefaultLineSize();

      _updateSelectionController(oldWidget,
          isDataGridControlChanged: isDataGridControllerChanged,
          isSelectionManagerChanged: isSelectionManagerChanged,
          isSourceChanged: isSourceChanged,
          isDataSourceChanged: isDataSourceChanged);

      _container._updateRowAndColumnCount();

      if (isSourceChanged ||
          isColumnsChanged ||
          isColumnSizerChanged ||
          isFrozenColumnPaneChanged ||
          isSortingChanged ||
          isStackedHeaderRowsChanged ||
          widget.allowSorting && isMultiColumnSortingChanged ||
          widget.allowSorting &&
              widget.allowMultiColumnSorting &&
              isShowSortNumbersChanged) {
        _resetColumn(clearEditing: false);
        if (isColumnSizerChanged) {
          _dataGridSettings.columnSizer._resetAutoCalculation();
        }
      }

      if (isSourceChanged ||
          isDataSourceChanged ||
          isFrozenRowPaneChanged ||
          isStackedHeaderRowsChanged ||
          isSortingChanged ||
          widget.allowSorting && isMultiColumnSortingChanged) {
        _container._refreshView(clearEditing: false);
      }

      if (widget.allowSwiping ||
          (oldWidget.allowSwiping && !widget.allowSwiping)) {
        if (isDataSourceChanged ||
            isColumnSizerChanged ||
            isMaxSwipeOffsetChanged ||
            isFrozenRowPaneChanged ||
            isFrozenColumnPaneChanged ||
            (oldWidget.allowSwiping && !widget.allowSwiping)) {
          _container.resetSwipeOffset();
        }
      }

      _container._isDirty = true;
    } else {
      if (oldWidget.gridLinesVisibility != widget.gridLinesVisibility ||
          oldWidget.allowTriStateSorting != widget.allowTriStateSorting ||
          oldWidget.headerGridLinesVisibility !=
              widget.headerGridLinesVisibility ||
          oldWidget.sortingGestureType != widget.sortingGestureType ||
          isEditingChanged) {
        // Need to endEdit before refreshing
        if (isEditingChanged && _dataGridSettings.currentCell.isEditing) {
          _dataGridSettings.currentCell
              ._onCellSubmit(_dataGridSettings, canRefresh: false);
        }
        _initializeProperties();
        _container._isDirty = true;
      } else if (isPullToRefreshPropertiesChanged || isMaxSwipeOffsetChanged) {
        _initializeProperties();
      }
    }
  }

  void _updateSelectionController(SfDataGrid oldWidget,
      {bool isSelectionManagerChanged = false,
      bool isDataGridControlChanged = false,
      bool isSourceChanged = false,
      bool isDataSourceChanged = false}) {
    if (isSourceChanged) {
      oldWidget.controller?._addDataGridPropertyChangeListener(
          _rowSelectionManager!._handleSelectionPropertyChanged);
      widget.controller?._addDataGridPropertyChangeListener(
          _rowSelectionManager!._handleSelectionPropertyChanged);
    }

    if (isSelectionManagerChanged) {
      _rowSelectionManager = _dataGridSettings.rowSelectionManager =
          widget.selectionManager ?? _rowSelectionManager!
            .._dataGridStateDetails = _dataGridStateDetails;
    }

    if (isSourceChanged) {
      _rowSelectionManager!.handleDataGridSourceChanges();
    }

    _rowSelectionManager?._updateSelectionController(
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
    _container._refreshHeaderLineCount();
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
      if (_dataGridSettings.verticalScrollController!.hasClients &&
          _dataGridSettings.container.verticalOffset > 0) {
        _dataGridSettings.container.verticalOffset = 0;
        _dataGridSettings.container.verticalScrollBar._value = 0;
      }
      if (_dataGridSettings.horizontalScrollController!.hasClients &&
          _dataGridSettings.container.horizontalOffset > 0) {
        _dataGridSettings.container.horizontalOffset = 0;
        _dataGridSettings.container.horizontalScrollBar._value = 0;
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
      _dataGridSettings.configuration ??=
          createLocalImageConfiguration(context);
      if (_dataGridSettings.boxPainter == null) {
        _updateDecoration();
      }
    }
  }

  void _updateDecoration() {
    final BorderSide borderSide =
        BorderSide(color: _dataGridThemeData!.currentCellStyle.borderColor);
    final BoxDecoration decoration = BoxDecoration(
        border: Border(
            bottom: borderSide,
            top: borderSide,
            left: borderSide,
            right: borderSide));

    _dataGridSettings.boxPainter = decoration.createBoxPainter();
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
    if (_dataGridSettings.allowPullToRefresh &&
        _dataGridSettings.refreshIndicatorKey != null) {
      if (showRefreshIndicator) {
        await _dataGridSettings.refreshIndicatorKey!.currentState?.show();
      } else {
        await _dataGridSettings.source.handleRefresh();
      }
    }
  }

  @override
  void didChangeDependencies() {
    final ThemeData themeData = Theme.of(context);
    _dataGridSettings._isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    _onDataGridTextDirectionChanged(Directionality.of(context));
    _onDataGridThemeDataChanged(SfDataGridTheme.of(context));
    _onDataGridTextScaleFactorChanged(MediaQuery.textScaleFactorOf(context));
    _updateVisualDensity(themeData.visualDensity);
    _dataGridSettings.defaultColumnWidth = widget.defaultColumnWidth.isNaN
        ? _dataGridSettings._isDesktop
            ? 100
            : 90
        : widget.defaultColumnWidth;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfDataGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateProperties(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_dataGridSettings._isDesktop) {
      _updateBoxPainter();
    }

    return LayoutBuilder(
        builder: (BuildContext _context, BoxConstraints _constraints) {
      final double _measuredHeight = _dataGridSettings.viewHeight =
          _constraints.maxHeight.isInfinite
              ? _minHeight
              : _constraints.maxHeight;
      final double _measuredWidth = _dataGridSettings.viewWidth =
          _constraints.maxWidth.isInfinite ? _minWidth : _constraints.maxWidth;

      if (!_container._isGridLoaded) {
        _gridLoaded();
        if (_textDirection == TextDirection.rtl) {
          _container._needToSetHorizontalOffset = true;
        }
        _container._isDirty = true;
        _columnSizer._isColumnSizerLoadedInitially = true;
      }

      return _ScrollViewWidget(
        dataGridStateDetails: _dataGridStateDetails,
        width: _measuredWidth,
        height: _measuredHeight,
      );
    });
  }

  @override
  void dispose() {
    _removeDataGridSourceListeners();
    _controller?.removeListener(_handleDataGridPropertyChangeListeners);
    _dataGridSettings
      ..gridPaint = null
      ..boxPainter = null
      ..configuration = null;
    _dataGridThemeData = null;
    if (_swipingAnimationController != null) {
      _swipingAnimationController!.dispose();
      _swipingAnimationController = null;
    }
    super.dispose();
  }
}

class _DataGridSettings {
  // late assignable values and non-null
  late Map<String, GridCellRendererBase> cellRenderers;
  late DataGridSource source;
  late List<GridColumn> columns;
  late _VisualContainerHelper container;
  late _RowGenerator rowGenerator;
  late ColumnWidthMode columnWidthMode;
  late ColumnWidthCalculationRange columnWidthCalculationRange;
  late ColumnSizer columnSizer;
  late SelectionManagerBase rowSelectionManager;
  late DataGridController controller;
  late _CurrentCellManager currentCell;
  late double viewWidth;
  late double viewHeight;
  late ScrollPhysics horizontalScrollPhysics;
  late ScrollPhysics verticalScrollPhysics;

  int headerLineCount = 0;
  int frozenColumnsCount = 0;
  int footerFrozenColumnsCount = 0;
  int frozenRowsCount = 0;
  int footerFrozenRowsCount = 0;
  double rowHeight = double.nan;
  double headerRowHeight = double.nan;
  double defaultColumnWidth = double.nan;
  double swipingOffset = 0.0;
  double refreshIndicatorDisplacement = 40.0;
  double refreshIndicatorStrokeWidth = 2.0;
  double swipeMaxOffset = 200.0;
  double textScaleFactor = 1.0;
  double footerHeight = 49.0;

  bool allowSorting = false;
  bool allowMultiColumnSorting = false;
  bool isControlKeyPressed = false;
  bool allowTriStateSorting = false;
  bool showSortNumbers = false;
  bool _isDesktop = false;
  bool isScrollbarAlwaysShown = false;
  bool allowPullToRefresh = false;
  bool allowSwiping = false;
  // This flag is used to restrict the scrolling while updating the swipe offset
  // of a row that already swiped in view.
  bool isSwipingApplied = false;
  bool highlightRowOnHover = true;
  bool allowEditing = false;

  SortingGestureType sortingGestureType = SortingGestureType.tap;
  GridNavigationMode navigationMode = GridNavigationMode.row;
  TextDirection textDirection = TextDirection.ltr;
  GridLinesVisibility gridLinesVisibility = GridLinesVisibility.horizontal;
  GridLinesVisibility headerGridLinesVisibility =
      GridLinesVisibility.horizontal;
  SelectionMode selectionMode = SelectionMode.none;
  ColumnResizeMode columnResizeMode = ColumnResizeMode.onResize;
  ScrollDirection scrollingState = ScrollDirection.idle;
  EditingGestureType editingGestureType = EditingGestureType.doubleTap;

  Paint? gridPaint;
  BoxPainter? boxPainter;
  FocusNode? dataGridFocusNode;
  ImageConfiguration? configuration;
  GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;
  Animation<double>? swipingAnimation;
  AnimationController? swipingAnimationController;
  List<StackedHeaderRow> stackedHeaderRows = <StackedHeaderRow>[];
  VisualDensity visualDensity = VisualDensity.adaptivePlatformDensity;
  SfDataGridThemeData? dataGridThemeData;
  ScrollController? verticalScrollController;
  ScrollController? horizontalScrollController;
  DataGridSwipeStartCallback? onSwipeStart;
  DataGridSwipeUpdateCallback? onSwipeUpdate;
  DataGridSwipeEndCallback? onSwipeEnd;
  DataGridSwipeActionsBuilder? startSwipeActionsBuilder;
  DataGridSwipeActionsBuilder? endSwipeActionsBuilder;
  QueryRowHeightCallback? onQueryRowHeight;
  SelectionChangingCallback? onSelectionChanging;
  SelectionChangedCallback? onSelectionChanged;
  CurrentCellActivatedCallback? onCurrentCellActivated;
  CurrentCellActivatingCallback? onCurrentCellActivating;
  DataGridCellTapCallback? onCellTap;
  DataGridCellDoubleTapCallback? onCellDoubleTap;
  DataGridCellTapCallback? onCellSecondaryTap;
  DataGridCellLongPressCallback? onCellLongPress;
  LoadMoreViewBuilder? loadMoreViewBuilder;
  Widget? footer;
}
