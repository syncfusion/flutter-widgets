part of datagrid;

typedef _DataGridStateDetails = _DataGridSettings Function();

/// Signature for [SfDataGrid.onQueryCellStyle] callback.
typedef QueryCellStyleCallback = DataGridCellStyle Function(
    QueryCellStyleArgs queryCellStyleArgs);

/// Signature for [SfDataGrid.onQueryRowStyle] callback.
typedef QueryRowStyleCallback = DataGridCellStyle Function(
    QueryRowStyleArgs queryRowStyleArgs);

/// Signature for [SfDataGrid.cellBuilder] callback
typedef CellBuilderCallback = Widget Function(
    BuildContext contex, GridColumn column, int rowIndex);

/// Signature for [SfDataGrid.headerCellBuilder] callback.
typedef HeaderCellBuilderCallback = Widget Function(
    BuildContext contex, GridColumn column);

/// Signature for [SfDataGrid.onQueryRowHeight] callback
typedef QueryRowHeightCallback = double Function(RowHeightDetails details);

/// Signature for [SfDataGrid.onSelectionChanging] callback.
typedef SelectionChangingCallback = bool Function(
    List<Object> addedRows, List<Object> removedRows);

/// Signature for [SfDataGrid.onSelectionChanged] callback.
typedef SelectionChangedCallback = void Function(
    List<Object> addedRows, List<Object> removedRows);

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

/// A material design datagrid.
///
/// DataGrid lets you display and manipulate data in a tabular view. It is built
/// from the ground up to achieve the best possible performance even when
/// loading large amounts of data.
///
/// DataGrid supports different types of column types to populate the columns
/// for different types of data such as int, double, DateTime, String.
///
/// You can use [GridWidgetColumn] to load any widget in a column. [source]
/// property enables you to populate the data for the [SfDataGrid].
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
///       columns: [
///       GridNumericColumn(mappingName: 'id')
///       ..headerText = 'ID',
///       GridTextColumn(mappingName: 'name')
///       ..headerText = 'Name',
///       GridTextColumn(mappingName: 'designation')
///       ..headerText = 'Designation',
///       GridNumericColumn(mappingName: 'salary')
///       ..headerText = 'Salary',
///     ],
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
/// class EmployeeDataSource extends DataGridSource{
///   @override
///   List<Object> get dataSource => _employees;
///
///   @override
///   getCellValue(int rowIndex, String columnName){
///     switch (columnName) {
///       case 'id':
///         return _employees[rowIndex].id;
///         break;
///       case 'name':
///         return _employees[rowIndex].name;
///         break;
///       case 'salary':
///         return _employees[rowIndex].salary;
///         break;
///       case 'designation':
///         return _employees[rowIndex].designation;
///         break;
///       default:
///         return ‘ ’;
///         break;
///    }
///   }
///
/// ```
class SfDataGrid extends StatefulWidget {
  /// Creates a widget describing a datagrid.
  ///
  /// The [columns] and [source] argument must be defined and must not be null.
  const SfDataGrid(
      {@required this.source,
      @required this.columns,
      Key key,
      double rowHeight,
      double headerRowHeight,
      double defaultColumnWidth,
      GridLinesVisibility gridLinesVisibility,
      ColumnWidthCalculationMode columnWidthCalculationMode,
      ColumnWidthCalculationRange columnWidthCalculationRange,
      ColumnWidthMode columnWidthMode,
      SelectionMode selectionMode,
      GridNavigationMode navigationMode,
      this.frozenColumnsCount = 0,
      this.footerFrozenColumnsCount = 0,
      this.frozenRowsCount = 0,
      this.footerFrozenRowsCount = 0,
      bool allowSorting,
      bool allowMultiColumnSorting,
      bool allowTriStateSorting,
      bool showSortNumbers,
      SortingGestureType sortingGestureType,
      this.selectionManager,
      this.controller,
      this.columnSizer,
      this.cellBuilder,
      this.headerCellBuilder,
      this.onQueryCellStyle,
      this.onQueryRowStyle,
      this.onQueryRowHeight,
      this.onSelectionChanged,
      this.onSelectionChanging,
      this.onCellRenderersCreated,
      this.onCurrentCellActivating,
      this.onCurrentCellActivated,
      this.onCellTap,
      this.onCellDoubleTap,
      this.onCellSecondaryTap,
      this.onCellLongPress})
      : assert(source != null),
        assert(columns != null),
        assert(frozenColumnsCount != null && frozenColumnsCount >= 0),
        assert(
            footerFrozenColumnsCount != null && footerFrozenColumnsCount >= 0),
        assert(frozenRowsCount != null && frozenRowsCount >= 0),
        assert(footerFrozenRowsCount != null && footerFrozenRowsCount >= 0),
        rowHeight = rowHeight,
        headerRowHeight = headerRowHeight,
        defaultColumnWidth = defaultColumnWidth ?? (kIsWeb ? 100.0 : 90.0),
        gridLinesVisibility =
            gridLinesVisibility ?? GridLinesVisibility.horizontal,
        columnWidthCalculationMode =
            columnWidthCalculationMode ?? ColumnWidthCalculationMode.textSize,
        columnWidthMode = columnWidthMode ?? ColumnWidthMode.none,
        columnWidthCalculationRange = columnWidthCalculationRange ??
            ColumnWidthCalculationRange.visibleRows,
        selectionMode = selectionMode ?? SelectionMode.none,
        navigationMode = navigationMode ?? GridNavigationMode.row,
        allowSorting = allowSorting ?? false,
        allowMultiColumnSorting = allowMultiColumnSorting ?? false,
        allowTriStateSorting = allowTriStateSorting ?? false,
        showSortNumbers = showSortNumbers ?? false,
        sortingGestureType = sortingGestureType ?? SortingGestureType.tap,
        super(key: key);

  /// The height of each row except the column header.
  ///
  /// Defaults to 49.0
  final double rowHeight;

  /// The height of the column header row.
  ///
  ///Defaults to 56.0
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

  /// How the column widths should be calculated.
  ///
  /// Provides options to calculate whether each cell in a column should be
  /// measured based on the size of the text or should be measured based on the
  /// length of the text.
  /// When the [ColumnWidthCalculationMode.textLength], the text in each cell
  /// which has large length is considered for text size measurement.
  ///
  /// Defaults to [ColumnWidthCalculationMode.textSize]
  ///
  /// Also refer [ColumnWidthCalculationMode]
  final ColumnWidthCalculationMode columnWidthCalculationMode;

  /// The [ColumnSizer] used to control the column width sizing operation of
  /// each columns.
  ///
  /// You can override the available methods and customize the required
  /// operations in the custom [ColumnSizer].
  final ColumnSizer columnSizer;

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

  /// How the border should be visible.
  ///
  /// Decides whether vertical, horizontal, both the borders and no borders
  /// should be drawn.
  ///
  /// Defaults to [GridLinesVisibility.horizontal]
  ///
  /// Also refer [GridLinesVisibility]
  final GridLinesVisibility gridLinesVisibility;

  /// Invoked when the style for each cell is applied.
  ///
  /// Users can set the styling for the cells based on the condition.
  final QueryCellStyleCallback onQueryCellStyle;

  /// Invoked when the style for each row is applied.
  ///
  /// Users can set the styling for the cells based on the condition.
  final QueryRowStyleCallback onQueryRowStyle;

  /// A builder that sets the widget for the [GridWidgetColumn].
  ///
  /// The widget returned by this method is wrapped in a cell.
  final CellBuilderCallback cellBuilder;

  /// A builder that sets the widget for the headercell.
  ///
  /// The widget returned by this method is wrapped in a header cell and
  /// builder will replace the default header.
  ///
  /// Builder will load the widget in text area alone. When sorting is applied
  /// the default sort icon will be loaded even if the widget is loaded from the
  /// builder. You can customize the sort icon by using
  /// [SfDataGridThemeData.headerStyle.sortIconColor].
  ///
  /// ``` dart
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return SfDataGrid(
  ///       source: _employeeDataSource,
  ///       headerCellBuilder: (buildContext, column) {
  ///                 if (column.mappingName == 'name') {
  ///                   return Row(children: [
  ///                     Icon(Icons.account_circle),
  ///                     SizedBox(width: 5),
  ///                     Flexible(
  ///                         child: Text(
  ///                       'Employee Name',
  ///                       overflow: TextOverflow.ellipsis,
  ///                     ))
  ///                   ]);
  ///                 }
  ///                 return null;
  ///               },
  ///       columns: [
  ///       GridNumericColumn(mappingName: 'id')
  ///       ..headerText = 'ID',
  ///       GridTextColumn(mappingName: 'name')
  ///       ..headerText = 'Name',
  ///       GridTextColumn(mappingName: 'designation')
  ///       ..headerText = 'Designation',
  ///       GridNumericColumn(mappingName: 'salary')
  ///       ..headerText = 'Salary',
  ///     ],
  ///     );
  ///   }
  /// ```
  final HeaderCellBuilderCallback headerCellBuilder;

  /// Invoked when the row height for each row is queried.
  final QueryRowHeightCallback onQueryRowHeight;

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
  final SelectionChangedCallback onSelectionChanged;

  /// Invoked when the row is being selected or being unselected
  ///
  /// This callback's return type is [bool]. So, if you want to cancel the
  /// selection on a row based on the condition, return false.
  /// Otherwise, return true.
  final SelectionChangingCallback onSelectionChanging;

  /// The [SelectionManagerBase] used to control the selection operations
  /// in [SfDataGrid].
  ///
  /// You can override the available methods and customize the required
  /// operations in the custom [RowSelectionManager].
  ///
  /// Defaults to null
  final SelectionManagerBase selectionManager;

  /// The [DataGridController] used to control the current cell navigation and
  /// selection operation.
  ///
  /// Defaults to null.
  ///
  /// This object is expected to be long-lived, not recreated with each build.
  final DataGridController controller;

  /// Called when the cell renderers are created for each column.
  ///
  /// This method is called once when the [SfDataGrid] is loaded. Users can
  /// provide the custom cell renderer to the existing collection.
  final CellRenderersCreatedCallback onCellRenderersCreated;

  /// Decides whether the navigation in the [SfDataGrid] should be cell wise
  /// or row wise.
  final GridNavigationMode navigationMode;

  /// Invoked when the cell is activated.
  ///
  /// This callback never be called when the [onCurrentCellActivating] is
  /// returned as false.
  final CurrentCellActivatedCallback onCurrentCellActivated;

  /// Invoked when the cell is being activated.
  ///
  /// This callback's return type is [bool]. So, if you want to cancel cell
  /// activation based on the condition, return false. Otherwise,
  /// return true.
  final CurrentCellActivatingCallback onCurrentCellActivating;

  /// Called when a tap with a cell has occurred.
  final DataGridCellTapCallback onCellTap;

  /// Called when user is tapped a cell with a primary button at the same cell
  /// twice in quick succession.
  final DataGridCellDoubleTapCallback onCellDoubleTap;

  /// Called when a long press gesture with a primary button has been
  /// recognized for a cell.
  final DataGridCellTapCallback onCellSecondaryTap;

  /// Called when a tap with a cell has occurred with a secondary button.
  final DataGridCellLongPressCallback onCellLongPress;

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
  /// [SfDataGridThemeData. frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData. frozenPaneLineColor], which is used to customize the
  /// color of the frozen line.
  final int footerFrozenColumnsCount;

  /// The number of non-scrolling rows at the top of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// [footerFrozenRowsCount]
  /// [SfDataGridThemeData. frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData. frozenPaneLineColor], which is used to customize the
  /// color of the frozen line.
  final int frozenRowsCount;

  /// The number of non-scrolling rows at the bottom of [SfDataGrid].
  ///
  /// Defaults to 0
  ///
  /// See also:
  ///
  /// [SfDataGridThemeData. frozenPaneLineWidth], which is used to customize the
  /// width of the frozen line.
  /// [SfDataGridThemeData. frozenPaneLineColor], which is used to customize the
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
  ///     GridNumericColumn(mappingName: 'id')
  ///     ..headerText = 'ID',
  ///     GridTextColumn(mappingName: 'name')
  ///     ..headerText = 'Name',
  ///     GridTextColumn(mappingName: 'designation')
  ///     ..headerText = 'Designation',
  ///     GridNumericColumn(mappingName: 'salary')
  ///     ..headerText = 'Salary',
  ///   ]);
  /// }
  ///
  /// class EmployeeDataSource extends DataGridSource<Employee> {
  ///
  /// @override
  /// List<Object> get dataSource => _employees;
  ///
  /// @override
  /// Object getValue(Employee data, String columnName) {
  /// switch (columnName) {
  ///   case 'id':
  ///     return data.id;
  ///   break;
  ///   case 'name':
  ///     return data.name;
  ///     break;
  ///   case 'salary':
  ///     return data.salary;
  ///     break;
  ///   case 'designation':
  ///     return data.designation;
  ///     break;
  ///   default:
  ///     return ' ';
  ///     break;
  ///    }
  ///  }
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
  /// * [DataGridController.sortedColumns] - which is the collection of
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
  ///[allowMultiColumnSorting] are set as true.
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

  @override
  State<StatefulWidget> createState() => _SfDataGridState();
}

class _SfDataGridState extends State<SfDataGrid> {
  Map<String, GridCellRendererBase> _cellRenderers = {};
  _RowGenerator _rowGenerator;
  _VisualContainerHelper _container;
  _DataGridStateDetails _dataGridStateDetails;
  _DataGridSettings _dataGridSettings;
  ColumnSizer _columnSizer;
  TextDirection _textDirection = TextDirection.ltr;
  SfDataGridThemeData _dataGridThemeData;
  DataGridSource _source;
  List<GridColumn> _columns;
  SelectionManagerBase _rowSelectionManager;
  DataGridController _controller;
  _CurrentCellManager _currentCell;

  static const double _minWidth = 300.0;
  static const double _minHeight = 300.0;
  static const double _headerRowHeight = 56.0;
  static const double _rowHeight = 49.0;

  @override
  void initState() {
    _columns = [];
    _dataGridSettings = _DataGridSettings();
    _dataGridStateDetails = _onDataGridStateDetailsChanged;
    _dataGridSettings.gridPaint = Paint();
    _rowGenerator = _RowGenerator(dataGridStateDetails: _dataGridStateDetails);
    _container = _VisualContainerHelper(rowGenerator: _rowGenerator);
    _setUp();
    _updateDataGridStateDetails();
    super.initState();
  }

  set textDirection(TextDirection newTextDirection) {
    if (_textDirection == newTextDirection) {
      return;
    }

    _textDirection = newTextDirection;
    _dataGridSettings.textDirection = newTextDirection;
    _container._needToSetHorizontalOffset = true;
  }

  set dataGridThemeData(SfDataGridThemeData newThemeData) {
    if (_dataGridThemeData == newThemeData) {
      return;
    }

    final canUpdate =
        _dataGridThemeData != null && _dataGridThemeData != newThemeData;
    _dataGridThemeData = newThemeData;
    _dataGridSettings.dataGridThemeData = newThemeData;
    _updateDecoration();
    if (canUpdate) {
      _container._refreshViewStyle();
    }
  }

  void _setUp() {
    _initializeDataGridDataSource();
    _initializeCellRendererCollection();

    //DataGrid Controller
    _controller =
        _dataGridSettings.controller = widget.controller ?? DataGridController()
          .._dataGridStateDetails = _dataGridStateDetails;

    _controller?.addListener(_handleDataGridSourceChanged);
    //AutoFit controller initializing
    _columnSizer = widget.columnSizer ?? ColumnSizer()
      .._dataGridStateDetails = _dataGridStateDetails;

    //CurrentCell Manager initializing
    _currentCell = _dataGridSettings.currentCell =
        _CurrentCellManager(_dataGridStateDetails);

    //Selection Manager initializing
    _rowSelectionManager = _dataGridSettings.rowSelectionManager =
        widget.selectionManager ??
            RowSelectionManager(dataGridStateDetails: _dataGridStateDetails);
    _rowSelectionManager?._dataGridStateDetails = _dataGridStateDetails;
    _controller?.addListener(_rowSelectionManager.handleDataGridSourceChanges);

    _initializeProperties();
  }

  @protected
  void _gridLoaded() {
    _container._refreshDefaultLineSize();
    _refreshContainerAndView();
  }

  @protected
  void _refreshContainerAndView({bool isDataSourceChanged = false}) {
    if (_rowGenerator == null) {
      return;
    }

    if (isDataSourceChanged) {
      _rowSelectionManager._updateSelectionController(
          isDataSourceChanged: isDataSourceChanged);
    }

    _ensureSelectionProperties();
    _container
      .._refreshHeaderLineCount()
      .._updateRowAndColumnCount()
      .._isGridLoaded = true;
  }

  void _initializeDataGridDataSource() {
    if (_source != widget.source) {
      _source?.removeListener(_handleDataGridSourceChanged);
      _source = widget.source;
      _source?.addListener(_handleDataGridSourceChanged);
    }
    _source._updateDataSource();
  }

  void _initializeProperties() {
    if (!listEquals<GridColumn>(_columns, widget.columns)) {
      _columns
        ..clear()
        ..addAll(widget.columns ?? _columns);
    }

    _rowSelectionManager?._dataGridStateDetails = _dataGridStateDetails;
    _currentCell?._dataGridStateDetails = _dataGridStateDetails;
    _columnSizer?._dataGridStateDetails = _dataGridStateDetails;
    _updateDataGridStateDetails();
  }

  void _initializeCellRendererCollection() {
    _cellRenderers = {};
    _cellRenderers['TextField'] =
        GridCellTextFieldRenderer(_dataGridStateDetails);
    _cellRenderers['ColumnHeader'] =
        GridHeaderCellRenderer(_dataGridStateDetails);
    _cellRenderers['Numeric'] =
        GridCellNumericTextFieldRenderer(_dataGridStateDetails);
    _cellRenderers['Widget'] = GridCellWidgetRenderer(_dataGridStateDetails);
    _cellRenderers['DateTime'] =
        GridCellDateTimeRenderer(_dataGridStateDetails);

    if (widget.onCellRenderersCreated != null) {
      widget.onCellRenderersCreated(_cellRenderers);
      for (final renderer in _cellRenderers.entries) {
        renderer.value._dataGridStateDetails = _dataGridStateDetails;
      }
    }
  }

  void _processCellUpdate(RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex != RowColumnIndex(-1, -1)) {
      final rowIndex = _GridIndexResolver.resolveToRowIndex(
          _dataGridSettings, rowColumnIndex.rowIndex);
      final columnIndex = _GridIndexResolver.resolveToScrollColumnIndex(
          _dataGridSettings, rowColumnIndex.columnIndex);

      final dataRow = _rowGenerator.items.firstWhere(
          (dataRow) => dataRow.rowIndex == rowIndex,
          orElse: () => null);

      if (dataRow == null) {
        return;
      }

      final dataCell = dataRow._visibleColumns.firstWhere(
          (dataCell) => dataCell.columnIndex == columnIndex,
          orElse: () => null);

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
      _initializeDataGridDataSource();
      _dataGridSettings.source = _source;
      if (!listEquals<GridColumn>(_columns, widget.columns)) {
        if (widget.selectionMode != SelectionMode.none &&
            widget.navigationMode == GridNavigationMode.cell) {
          _rowSelectionManager._onRowColumnChanged(-1, widget.columns.length);
        }

        _resetColumn();
      }

      if (widget.selectionMode != SelectionMode.none &&
          widget.navigationMode == GridNavigationMode.cell) {
        _rowSelectionManager._onRowColumnChanged(
            widget.source._effectiveDataSource.length, -1);
      }

      if (!_suspendDataPagerUpdate) {
        widget.source.notifyListeners();
      }

      _container
        .._updateRowAndColumnCount()
        .._refreshView()
        .._isDirty = true;
    });
  }

  void _processSorting() {
    setState(() {
      _dataGridSettings.source._updateDataSource();
      _container
        .._updateRowAndColumnCount()
        .._refreshView()
        .._isDirty = true;
    });
  }

  void _resetColumn() {
    _columns
      ..clear()
      ..addAll(widget.columns);
    _dataGridSettings.columns = _columns;

    for (final dataRow in _rowGenerator.items) {
      for (final dataCell in dataRow._visibleColumns) {
        dataCell.columnIndex = -1;
      }
    }

    if (_textDirection == TextDirection.rtl) {
      _container._needToSetHorizontalOffset = true;
    }
    _container._needToRefreshColumn = true;
  }

  void _handleDataGridSourceChanged(
      {RowColumnIndex rowColumnIndex,
      String propertyName,
      bool recalculateRowHeight}) {
    if (rowColumnIndex != null && propertyName == null) {
      _processCellUpdate(rowColumnIndex);
    }

    if (rowColumnIndex == null && propertyName == null) {
      _processUpdateDataSource();
    }
    if (propertyName == 'refreshRow') {
      final rowIndex = _GridIndexResolver.resolveToRowIndex(
          _dataGridSettings, rowColumnIndex.rowIndex);

      final dataRow = _rowGenerator.items.firstWhere(
          (dataRow) => dataRow.rowIndex == rowIndex,
          orElse: () => null);
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

    if (rowColumnIndex == null && propertyName == 'Sorting') {
      _processSorting();
    }
  }

  void _updateDataGridStateDetails() {
    _dataGridSettings
      ..textDirection = _textDirection
      ..cellRenderers = _cellRenderers
      ..container = _container
      ..rowGenerator = _rowGenerator
      ..rowHeight =
          widget.rowHeight ?? (_dataGridSettings.rowHeight ?? _rowHeight)
      ..headerRowHeight = widget.headerRowHeight ??
          (_dataGridSettings.headerRowHeight ?? _headerRowHeight)
      ..source = _source
      ..columns = _columns
      ..defaultColumnWidth = widget.defaultColumnWidth
      ..headerLineCount = _container._headerLineCount
      ..onQueryCellStyle = widget.onQueryCellStyle
      ..onQueryRowStyle = widget.onQueryRowStyle
      ..cellBuilder = widget.cellBuilder
      ..headerCellBuilder = widget.headerCellBuilder
      ..onQueryRowHeight = widget.onQueryRowHeight
      ..dataGridThemeData = _dataGridThemeData
      ..gridLinesVisibility = widget.gridLinesVisibility
      ..columnWidthMode = widget.columnWidthMode
      ..columnSizer = _columnSizer
      ..columnWidthCalculationMode = widget.columnWidthCalculationMode
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
      ..isControlKeyPressed = false;
  }

  _DataGridSettings _onDataGridStateDetailsChanged() => _dataGridSettings;

  void _updateProperties(SfDataGrid oldWidget) {
    final isSourceChanged = widget.source != oldWidget.source;
    final isDataSourceChanged = !listEquals<Object>(
        oldWidget.source.dataSource, widget.source.dataSource);
    final isColumnsChanged = !listEquals<GridColumn>(_columns, widget.columns);
    final isSelectionManagerChanged =
        oldWidget.selectionManager != widget.selectionManager ||
            oldWidget.selectionMode != widget.selectionMode;
    final isColumnSizerChanged = oldWidget.columnSizer != widget.columnSizer ||
        oldWidget.columnWidthCalculationMode !=
            widget.columnWidthCalculationMode ||
        oldWidget.columnWidthMode != widget.columnWidthMode ||
        oldWidget.columnWidthCalculationRange !=
            widget.columnWidthCalculationRange;
    final isDataGridControllerChanged =
        oldWidget.controller != widget.controller;
    final isFrozenColumnPaneChanged = oldWidget.frozenColumnsCount !=
            widget.frozenColumnsCount ||
        oldWidget.footerFrozenColumnsCount != widget.footerFrozenColumnsCount;
    final isFrozenRowPaneChanged =
        oldWidget.frozenRowsCount != widget.frozenRowsCount ||
            oldWidget.footerFrozenRowsCount != widget.footerFrozenRowsCount;
    final isSortingChanged = oldWidget.allowSorting != widget.allowSorting;
    final isMultiColumnSortingChanged =
        oldWidget.allowMultiColumnSorting != widget.allowMultiColumnSorting;
    final isShowSortNumbersChanged =
        oldWidget.showSortNumbers != widget.showSortNumbers;
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
        oldWidget.rowHeight != widget.rowHeight ||
        oldWidget.headerRowHeight != widget.headerRowHeight ||
        oldWidget.defaultColumnWidth != widget.defaultColumnWidth ||
        oldWidget.navigationMode != widget.navigationMode) {
      if (isSourceChanged) {
        _initializeDataGridDataSource();
      }
      if (isSortingChanged || isMultiColumnSortingChanged) {
        if (!widget.allowSorting) {
          _dataGridSettings.source.sortedColumns.clear();
          _dataGridSettings.source._updateDataSource();
        } else if (widget.allowSorting && !widget.allowMultiColumnSorting) {
          while (_dataGridSettings.source.sortedColumns.length > 1) {
            _dataGridSettings.source.sortedColumns.removeAt(0);
          }
          _dataGridSettings.source._updateDataSource();
        }
      }

      if (isDataGridControllerChanged) {
        oldWidget.controller?.removeListener(_handleDataGridSourceChanged);

        _controller =
            _dataGridSettings.controller = widget.controller ?? _controller
              .._dataGridStateDetails = _dataGridStateDetails;

        _controller?.addListener(_handleDataGridSourceChanged);
      }

      _initializeProperties();
      _container._refreshDefaultLineSize();

      _updateSelectionController(
          oldWidget: oldWidget,
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
          widget.allowSorting && isMultiColumnSortingChanged ||
          widget.allowSorting &&
              widget.allowMultiColumnSorting &&
              isShowSortNumbersChanged) {
        _resetColumn();
        if (isColumnSizerChanged) {
          _dataGridSettings.columnSizer._resetAutoCalculation();
        }
      }

      if (isSourceChanged || isDataSourceChanged || isFrozenRowPaneChanged) {
        _container._refreshView();
      }

      _container._isDirty = true;
    } else {
      if (oldWidget.gridLinesVisibility != widget.gridLinesVisibility ||
          oldWidget.allowTriStateSorting != widget.allowTriStateSorting ||
          oldWidget.sortingGestureType != widget.sortingGestureType) {
        _initializeProperties();
        _container._isDirty = true;
      }
    }
  }

  void _updateSelectionController(
      {SfDataGrid oldWidget,
      bool isSelectionManagerChanged,
      bool isDataGridControlChanged,
      bool isSourceChanged,
      bool isDataSourceChanged}) {
    if (isSourceChanged) {
      oldWidget.controller
          ?.removeListener(_rowSelectionManager.handleDataGridSourceChanges);
      widget.controller
          ?.addListener(_rowSelectionManager.handleDataGridSourceChanges);
    }

    if (isSelectionManagerChanged) {
      _rowSelectionManager = _dataGridSettings.rowSelectionManager =
          widget.selectionManager ?? _rowSelectionManager
            .._dataGridStateDetails = _dataGridStateDetails;
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

  void _ensureSelectionProperties() {
    if (_controller.selectedRows.isNotEmpty) {
      _rowSelectionManager?.onSelectedRowsChanged();
    }

    if (_controller.selectedRow != null) {
      _rowSelectionManager?.onSelectedRowChanged();
    }

    if (_controller.selectedIndex != null && _controller.selectedIndex != -1) {
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
    final borderSide =
        BorderSide(color: _dataGridThemeData.currentCellStyle.borderColor);
    final decoration = BoxDecoration(
        border: Border(
            bottom: borderSide,
            top: borderSide,
            left: borderSide,
            right: borderSide));

    _dataGridSettings.boxPainter = decoration.createBoxPainter();
  }

  @override
  void didChangeDependencies() {
    textDirection = Directionality.of(context);
    dataGridThemeData = SfDataGridTheme.of(context);
    _dataGridSettings.textScaleFactor =
        MediaQuery.of(context, nullOk: true)?.textScaleFactor ?? 1.0;
    _dataGridSettings.headerRowHeight = widget.headerRowHeight ??
        (_dataGridSettings.textScaleFactor > 1.0
            ? 56.0 * _dataGridSettings.textScaleFactor
            : 56.0);
    _dataGridSettings.rowHeight = widget.rowHeight ??
        (_dataGridSettings.textScaleFactor > 1.0
            ? 49.0 * _dataGridSettings.textScaleFactor
            : 49.0);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfDataGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateProperties(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      _updateBoxPainter();
    }

    return LayoutBuilder(builder: (_context, _constraints) {
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
    _source?.removeListener(_handleDataGridSourceChanged);
    _controller?.removeListener(_handleDataGridSourceChanged);
    _dataGridSettings
      ..gridPaint = null
      ..boxPainter = null
      ..configuration = null;
    _dataGridThemeData = null;
    super.dispose();
  }
}

class _DataGridSettings {
  Map<String, GridCellRendererBase> cellRenderers;
  DataGridSource source;
  List<GridColumn> columns;
  double rowHeight;
  double headerRowHeight;
  double defaultColumnWidth;
  double textScaleFactor;
  _VisualContainerHelper container;
  _RowGenerator rowGenerator;
  int headerLineCount;
  SfDataGridThemeData dataGridThemeData;
  CellBuilderCallback cellBuilder;
  HeaderCellBuilderCallback headerCellBuilder;
  QueryCellStyleCallback onQueryCellStyle;
  QueryRowStyleCallback onQueryRowStyle;
  QueryRowHeightCallback onQueryRowHeight;
  TextDirection textDirection;
  GridLinesVisibility gridLinesVisibility;
  ColumnWidthMode columnWidthMode;
  ColumnSizer columnSizer;
  ColumnWidthCalculationMode columnWidthCalculationMode;
  ColumnWidthCalculationRange columnWidthCalculationRange;
  SelectionManagerBase rowSelectionManager;
  SelectionMode selectionMode;
  SelectionChangingCallback onSelectionChanging;
  SelectionChangedCallback onSelectionChanged;
  DataGridController controller;
  _CurrentCellManager currentCell;
  GridNavigationMode navigationMode;
  CurrentCellActivatedCallback onCurrentCellActivated;
  CurrentCellActivatingCallback onCurrentCellActivating;
  ScrollController verticalController;
  ScrollController horizontalController;
  FocusNode dataGridFocusNode;
  double viewWidth;
  double viewHeight;
  Paint gridPaint;
  ImageConfiguration configuration;
  BoxPainter boxPainter;
  DataGridCellTapCallback onCellTap;
  DataGridCellDoubleTapCallback onCellDoubleTap;
  DataGridCellTapCallback onCellSecondaryTap;
  DataGridCellLongPressCallback onCellLongPress;
  int frozenColumnsCount;
  int footerFrozenColumnsCount;
  int frozenRowsCount;
  int footerFrozenRowsCount;
  bool allowSorting;
  bool allowMultiColumnSorting;
  bool allowTriStateSorting;
  bool showSortNumbers;
  SortingGestureType sortingGestureType;
  bool isControlKeyPressed;
}
