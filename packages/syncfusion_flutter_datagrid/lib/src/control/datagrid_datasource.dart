part of datagrid;

typedef _DataGridSourceListener = void Function(
    {RowColumnIndex rowColumnIndex,
    String propertyName,
    bool recalculateRowHeight});

/// A datasource for obtaining the row data for the [SfDataGrid].
///
/// The following APIs are mandatory to process the data,
/// * [dataSource] - The number of rows in a datagrid and row selection depends
/// on the [dataSource]. So, set the collection required for datagrid in
/// [dataSource].
/// * [getCellValue] - The data needed for the cells is obtained from
/// [getCellValue].
///
/// Call the [notifyDataSourceListeners] when performing CRUD in the underlying
/// datasource. When updating data in a cell, pass the corresponding
/// [RowColumnIndex] to the [notifyDataSourceListeners].
///
/// [DataGridSource] objects are expected to be long-lived, not recreated with
/// each build.
/// ``` dart
/// final List<Employee> _employees = <Employee>[];
///
/// class EmployeeDataSource extends DataGridSource
/// {
///   @override
///   List<Object> get dataSource => _employees;
///
///   @override
///   getCellValue(int rowIndex, String columnName){
///     switch (columnName) {
///       case 'id':
///         return employees[rowIndex].id;
///         break;
///       case 'name':
///         return employees[rowIndex].name;
///         break;
///       case 'salary':
///         return employees[rowIndex].salary;
///         break;
///       case 'designation':
///         return employees[rowIndex].designation;
///         break;
///       default:
///         return ' ';
///         break;
///     }
///   }
/// ```

abstract class DataGridSource<T extends Object>
    extends DataGridSourceChangeNotifier with DataPagerDelegate {
  /// Creates the [DataGridSource] for [SfDataGrid] widget.
  DataGridSource({List<T> dataSource}) {
    _dataSource = dataSource ?? [];
    _sortedColumns = [];
    _effectiveDataSource = [];
  }

  /// An underlying datasource to populate the rows for [SfDataGrid].
  ///
  /// This property should be set to process the selection operation.
  List<T> get dataSource => _dataSource;
  List<T> _dataSource;

  List<T> _effectiveDataSource;

  List<T> _unSortedDataSource = [];

  /// Called to obtain the data for the cells.
  Object getCellValue(int rowIndex, String columnName) {
    return getValue(_effectiveDataSource[rowIndex], columnName);
  }

  /// Called to obtain the data for the cells from the corresponding object.
  Object getValue(T data, String columnName) => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataGridSource && runtimeType == other.runtimeType;

  @override
  int get hashCode {
    final List<Object> _hashList = [this, dataSource];
    return hashList(_hashList);
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
  ///             GridNumericColumn(mappingName: 'id', headerText: 'ID'),
  ///             GridTextColumn(mappingName: 'name', headerText: 'Name'),
  ///             GridTextColumn(
  ///                 mappingName: 'designation', headerText: 'Designation'),
  ///             GridNumericColumn(mappingName: 'salary', headerText: 'Salary')
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
  List<SortColumnDetails> _sortedColumns;

  /// Called when the sorting is applied to a column.
  ///
  /// [SfDataGrid] sorts the data by cloning the datasource assigned in
  /// [dataSource] property and applying the sorting in that cloned datasource.
  /// So, users won’t need to apply the sorting for the columns in application
  /// level.
  ///
  /// This method will be called when the corresponding column’s
  /// [GridColumn.allowSorting] and [SfDataGrid.allowSorting] are enabled.
  ///
  /// You can override this method and apply the custom sorting based on your
  /// requirement.
  @protected
  Future<bool> handleSort() async {
    if (sortedColumns.isEmpty) {
      return true;
    }
    _effectiveDataSource.sort((a, b) {
      return _compare(sortedColumns, a, b);
    });
    return true;
  }

  int _compare(List<SortColumnDetails> sortedColumns, Object a, Object b) {
    if (sortedColumns.length > 1) {
      for (int i = 0; i < sortedColumns.length; i++) {
        final SortColumnDetails _sortColumn = sortedColumns[i];
        final Object value1 = getValue(a, _sortColumn.name);
        final Object value2 = getValue(b, _sortColumn.name);
        final compareResult =
            _compareTo(value1, value2, _sortColumn.sortDirection);
        if (compareResult != 0) {
          return compareResult;
        } else {
          final List<SortColumnDetails> remainingSortColumns = sortedColumns
              .skipWhile((value) => value == _sortColumn)
              .toList(growable: false);
          return _compare(remainingSortColumns, a, b);
        }
      }
    }
    final _sortColumn = sortedColumns.last;
    final Object value1 = getValue(a, _sortColumn.name);
    final Object value2 = getValue(b, _sortColumn.name);
    return _compareTo(value1, value2, _sortColumn.sortDirection);
  }

  int _compareTo(
      dynamic value1, dynamic value2, DataGridSortDirection sortDirection) {
    if (sortDirection == DataGridSortDirection.ascending) {
      if (value1 == null) {
        return -1;
      } else if (value2 == null) {
        return 1;
      }
      return value1.compareTo(value2);
    } else {
      if (value1 == null) {
        return 1;
      } else if (value2 == null) {
        return -1;
      }
      return value2.compareTo(value1);
    }
  }

  Future<bool> _updateDataSource() {
    if (sortedColumns.isNotEmpty) {
      _unSortedDataSource = dataSource.toList();
      _effectiveDataSource = _unSortedDataSource;
    } else {
      _effectiveDataSource = dataSource;
    }
    return handleSort();
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
  ///             GridNumericColumn(mappingName: 'id', headerText: 'ID'),
  ///             GridTextColumn(mappingName: 'name', headerText: 'Name'),
  ///             GridTextColumn(
  ///                 mappingName: 'designation', headerText: 'Designation'),
  ///             GridNumericColumn(mappingName: 'salary', headerText: 'Salary')
  ///           ],
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  void sort() {
    _updateDataSource();
    notifyDataSourceListeners(propertyName: 'Sorting');
  }

  /// An indexer to retrieve the data from the underlying datasource. If the
  /// sorting is applied, the data will be retrieved from the sorted datasource.
  ///
  /// You can use this indexer when you get the data for the widget that you
  /// return in [SfDataGrid.cellBuilder] callback for [GridWidgetColumn].
  T operator [](int index) => _effectiveDataSource[index];
}

/// Controls a [SfDataGrid] widget.
///
/// This can be used to control the selection and currentcell operations such
/// as programmatically select a row or rows, move the currentcell to
/// required position.
///
/// DataGrid controllers are typically stored as member variables in [State]
/// objects and are reused in each [State.build].
class DataGridController extends DataGridSourceChangeNotifier {
  /// Creates the [DataGridController] with the [selectedIndex], [selectedRow]
  /// and [selectedRows].
  DataGridController(
      {int selectedIndex, Object selectedRow, List<Object> selectedRows})
      : _selectedRow = selectedRow,
        _selectedIndex = selectedIndex,
        _selectedRows = selectedRows ?? [] {
    _currentCell = RowColumnIndex(-1, -1);
  }

  _DataGridStateDetails _dataGridStateDetails;

  /// The collection of objects that contains object of corresponding
  /// to the selected rows in [SfDataGrid].
  List<Object> get selectedRows => _selectedRows;
  List<Object> _selectedRows = [];

  /// The collection of objects that contains object of corresponding
  /// to the selected rows in [SfDataGrid].
  set selectedRows(List<Object> newSelectedRows) {
    if (_selectedRows == newSelectedRows) {
      return;
    }

    _selectedRows = newSelectedRows;
    notifyDataSourceListeners(propertyName: 'selectedRows');
  }

  /// An index of the corresponding selected row.
  int get selectedIndex => _selectedIndex;
  int _selectedIndex;

  /// An index of the corresponding selected row.
  set selectedIndex(int newSelectedIndex) {
    if (_selectedIndex == newSelectedIndex) {
      return;
    }

    _selectedIndex = newSelectedIndex;
    notifyDataSourceListeners(propertyName: 'selectedIndex');
  }

  /// An object of the corresponding selected row.
  ///
  /// The given object must be given from the underlying datasource of the
  /// [SfDataGrid].
  Object get selectedRow => _selectedRow;
  Object _selectedRow;

  /// An object of the corresponding selected row.
  ///
  /// The given object must be given from the underlying datasource of the
  /// [SfDataGrid].
  set selectedRow(Object newSelectedRow) {
    if (_selectedRow == newSelectedRow) {
      return;
    }

    _selectedRow = newSelectedRow;
    notifyDataSourceListeners(propertyName: 'selectedRow');
  }

  ///If the [rowIndex] alone is given, the entire row will be set as dirty.
  ///So, data which is displayed in a row will be refreshed.
  /// You can call this method when the data is updated in row in
  ///  underlying datasource.
  ///
  /// If the [canRecalculateRowHeight] is set as true along with the [rowIndex],
  /// [SfDataGrid.onQueryRowHeight] callback will be called for that row.
  ///  So, the row height can be reset based on the modified data.
  ///  This is useful when setting auto row height
  /// using [SfDataGrid.onQueryRowHeight] callback.
  void refreshRow(int rowIndex, {bool recalculateRowHeight}) {
    notifyDataSourceListeners(
        rowColumnIndex: RowColumnIndex(rowIndex, -1),
        propertyName: 'refreshRow',
        recalculateRowHeight: recalculateRowHeight);
  }

  /// A cell which is currently active.
  ///
  /// This is used to identify the currently active cell to process the
  /// key navigation.
  RowColumnIndex get currentCell => _currentCell;
  RowColumnIndex _currentCell;

  /// Moves the currentcell to the specified cell coordinates.
  void moveCurrentCellTo(RowColumnIndex rowColumnIndex) {
    final _DataGridSettings dataGridSettings = _dataGridStateDetails();
    if (dataGridSettings != null &&
        rowColumnIndex != null &&
        rowColumnIndex != RowColumnIndex(-1, -1) &&
        dataGridSettings.selectionMode != SelectionMode.none &&
        dataGridSettings.navigationMode != GridNavigationMode.row) {
      final rowIndex = _GridIndexResolver.resolveToRowIndex(
          dataGridSettings, rowColumnIndex.rowIndex);
      final columnIndex = _GridIndexResolver.resolveToGridVisibleColumnIndex(
          dataGridSettings, rowColumnIndex.columnIndex);

      final rowSelectionController = dataGridSettings.rowSelectionManager;
      if (rowSelectionController is RowSelectionManager) {
        rowSelectionController._processSelectionAndCurrentCell(
            dataGridSettings, RowColumnIndex(rowIndex, columnIndex),
            isProgrammatic: true);
      }
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataGridController && runtimeType == other.runtimeType;

  @override
  int get hashCode {
    final List<Object> _hashList = [
      selectedRows,
      selectedRow,
      selectedIndex,
      currentCell
    ];
    return hashList(_hashList);
  }
}

/// ToDO
class DataGridSourceChangeNotifier extends ChangeNotifier {
  ObserverList<_DataGridSourceListener> _dataSourceListeners =
      ObserverList<_DataGridSourceListener>();

  @override
  void addListener(Object listener) {
    if (listener is _DataGridSourceListener) {
      _dataSourceListeners.add(listener);
    } else {
      super.addListener(listener);
    }
  }

  @override
  void removeListener(Object listener) {
    if (listener is _DataGridSourceListener) {
      _dataSourceListeners.remove(listener);
    } else {
      super.removeListener(listener);
    }
  }

  @protected
  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  /// ToDO
  @protected
  void notifyDataSourceListeners(
      {RowColumnIndex rowColumnIndex,
      String propertyName,
      bool recalculateRowHeight}) {
    for (final listener in _dataSourceListeners) {
      listener(
          rowColumnIndex: rowColumnIndex,
          propertyName: propertyName,
          recalculateRowHeight: recalculateRowHeight);
    }
  }

  @mustCallSuper
  @override
  void dispose() {
    super.dispose();
    _dataSourceListeners = null;
  }
}
