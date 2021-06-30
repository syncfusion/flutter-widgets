part of datagrid;

/// Signature for the [DataGridSourceChangeNotifier] listener.
typedef _DataGridSourceListener = void Function(
    {RowColumnIndex? rowColumnIndex});

/// Signature for the [DataGridSourceChangeNotifier] listener.
typedef _DataGridPropertyChangeListener = void Function(
    {RowColumnIndex? rowColumnIndex,
    String? propertyName,
    bool recalculateRowHeight});

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

  List<DataGridRow> _effectiveRows = <DataGridRow>[];

  List<DataGridRow> _unSortedRows = <DataGridRow>[];

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
  ///        return valueA.toLowerCase().compareTo(valueB.toLowerCase());
  ///      }
  ///    }
  ///
  ///    return super.compare(a, b, sortColumn);
  ///  }
  ///
  /// ```
  @protected
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    Object? _getCellValue(List<DataGridCell>? cells, String columnName) {
      return cells
          ?.firstWhereOrNull(
              (DataGridCell element) => element.columnName == columnName)
          ?.value;
    }

    final Object? valueA = _getCellValue(a?.getCells(), sortColumn.name);
    final Object? valueB = _getCellValue(b?.getCells(), sortColumn.name);
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

  _DataGridStateDetails? _dataGridStateDetails;

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

  /// Moves the currentcell to the specified cell coordinates.
  void moveCurrentCellTo(RowColumnIndex rowColumnIndex) {
    if (_dataGridStateDetails != null) {
      final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
      if (rowColumnIndex != RowColumnIndex(-1, -1) &&
          dataGridSettings.selectionMode != SelectionMode.none &&
          dataGridSettings.navigationMode != GridNavigationMode.row) {
        final int rowIndex = _GridIndexResolver.resolveToRowIndex(
            dataGridSettings, rowColumnIndex.rowIndex);
        final int columnIndex =
            _GridIndexResolver.resolveToGridVisibleColumnIndex(
                dataGridSettings, rowColumnIndex.columnIndex);
        // Ignore the scrolling when the row index or column index are in negative
        // or invalid.
        if (rowIndex.isNegative || columnIndex.isNegative) {
          return;
        }
        final SelectionManagerBase rowSelectionController =
            dataGridSettings.rowSelectionManager;
        if (rowSelectionController is RowSelectionManager) {
          rowSelectionController._processSelectionAndCurrentCell(
              dataGridSettings, RowColumnIndex(rowIndex, columnIndex),
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
      final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
      final _ScrollAxisBase scrollRows = dataGridSettings.container.scrollRows;
      final _ScrollAxisBase scrollColumns =
          dataGridSettings.container.scrollColumns;

      if (rowIndex > dataGridSettings.container.rowCount ||
          columnIndex > scrollColumns.lineCount ||
          (rowIndex.isNegative && columnIndex.isNegative)) {
        return;
      }

      final int _rowIndex = _GridIndexResolver.resolveToRowIndex(
          dataGridSettings, rowIndex.toInt());
      final int _columnIndex =
          _GridIndexResolver.resolveToGridVisibleColumnIndex(
              dataGridSettings, columnIndex.toInt());
      double verticalOffset =
          _SfDataGridHelper.getVerticalOffset(dataGridSettings, _rowIndex);
      double horizontalOffset =
          _SfDataGridHelper.getHorizontalOffset(dataGridSettings, _columnIndex);

      if (dataGridSettings.textDirection == TextDirection.rtl &&
          columnIndex == -1) {
        horizontalOffset = dataGridSettings.container.extentWidth -
                    dataGridSettings.viewWidth -
                    horizontalOffset >
                0
            ? dataGridSettings.container.extentWidth -
                dataGridSettings.viewWidth -
                horizontalOffset
            : 0;
      }

      verticalOffset = _SfDataGridHelper.resolveScrollOffsetToPosition(
          rowPosition,
          scrollRows,
          verticalOffset,
          dataGridSettings.viewHeight,
          scrollRows.headerExtent,
          scrollRows.footerExtent,
          dataGridSettings.rowHeight,
          dataGridSettings.container.verticalOffset,
          _rowIndex);

      horizontalOffset = _SfDataGridHelper.resolveScrollOffsetToPosition(
          columnPosition,
          scrollColumns,
          horizontalOffset,
          dataGridSettings.viewWidth,
          scrollColumns.headerExtent,
          scrollColumns.footerExtent,
          dataGridSettings.defaultColumnWidth,
          dataGridSettings.container.horizontalOffset,
          _columnIndex);

      _SfDataGridHelper.scrollVertical(
          dataGridSettings, verticalOffset, canAnimate);
      // Need to add await for the horizontal scrolling alone, to avoid the delay time between vertical and horizontal scrolling.
      await _SfDataGridHelper.scrollHorizontal(
          dataGridSettings, horizontalOffset, canAnimate);
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
      final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
      return _SfDataGridHelper.scrollVertical(
          dataGridSettings, offset, canAnimate);
    }
  }

  /// Scroll the horizontal scrollbar from current value to the given value.
  ///
  /// If you want animation on scrolling, you can pass true as canAnimate argument.
  Future<void> scrollToHorizontalOffset(double offset,
      {bool canAnimate = false}) async {
    if (_dataGridStateDetails != null) {
      final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
      return _SfDataGridHelper.scrollHorizontal(
          dataGridSettings, offset, canAnimate);
    }
  }

  /// Begins the edit to the given [RowColumnIndex] in [SfDataGrid].
  void beginEdit(RowColumnIndex rowColumnIndex) {
    if (_dataGridStateDetails != null) {
      final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
      if (!dataGridSettings.allowEditing ||
          dataGridSettings.selectionMode == SelectionMode.none ||
          dataGridSettings.navigationMode == GridNavigationMode.row) {
        return;
      }

      dataGridSettings.currentCell._onCellBeginEdit(
          editingRowColumnIndex: rowColumnIndex, isProgrammatic: true);
    }
  }

  /// Ends the current editing of a cell in [SfDataGrid].
  void endEdit() {
    if (_dataGridStateDetails != null) {
      final _DataGridSettings dataGridSettings = _dataGridStateDetails!();
      if (!dataGridSettings.allowEditing ||
          dataGridSettings.selectionMode == SelectionMode.none ||
          dataGridSettings.navigationMode == GridNavigationMode.row) {
        return;
      }

      dataGridSettings.currentCell._onCellSubmit(dataGridSettings);
    }
  }
}

/// ToDO
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
