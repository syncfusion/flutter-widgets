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
///   DataGridRowAdapter buildRow(DataGridRow row) {
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
  List<DataGridRow> get rows => List.empty();

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

  List<DataGridRow> _effectiveRows = [];

  List<DataGridRow> _unSortedRows = [];

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
  ///   DataGridRowAdapter buildRow(DataGridRow row) {
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
  ///               GridTextColumn(columnName: 'id', label = Text('ID')),
  ///               GridTextColumn(columnName: 'name', label = Text('Name')),
  ///               GridTextColumn(columnName: 'designation', label = Text('Designation')),
  ///               GridTextColumn(columnName: 'salary', label = Text('Salary')),
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
  List<SortColumnDetails> _sortedColumns = [];

  /// Called when the sorting is applied to a column.
  ///
  /// [SfDataGrid] sorts the data by cloning the datasource assigned in
  /// [rows] property and applying the sorting in that cloned datasource.
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

    _effectiveRows.sort((a, b) {
      return _compareValues(sortedColumns, a, b);
    });

    return true;
  }

  int _compareValues(
      List<SortColumnDetails> sortedColumns, DataGridRow a, DataGridRow b) {
    if (sortedColumns.length > 1) {
      for (int i = 0; i < sortedColumns.length; i++) {
        final SortColumnDetails sortColumn = sortedColumns[i];
        final compareResult = compare(a, b, sortColumn);
        if (compareResult != 0) {
          return compareResult;
        } else {
          final List<SortColumnDetails> remainingSortColumns = sortedColumns
              .skipWhile((value) => value == sortColumn)
              .toList(growable: false);
          return _compareValues(remainingSortColumns, a, b);
        }
      }
    }
    final sortColumn = sortedColumns.last;
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
  ///   DataGridRowAdapter buildRow(DataGridRow row) {
  ///     return DataGridRowAdapter(
  ///         cells: row.getCells().map<Widget>((dataCell) {
  ///           return Text(dataCell.value.toString());
  ///         }).toList());
  ///   }
  ///
  ///   @override
  ///   int compare(DataGridRow a, DataGridRow b, SortColumnDetails sortColumn) {
  ///     if (sortColumn.name == 'name') {
  ///       final String valueA = a
  ///           .getCells()
  ///           .firstWhere((dataCell) => dataCell.columnName == 'name',
  ///               orElse: () => null)
  ///           ?.value;
  ///       final String valueB = b
  ///           .getCells()
  ///           .firstWhere((dataCell) => dataCell.columnName == 'name',
  ///               orElse: () => null)
  ///           ?.value;
  ///       if (sortColumn.sortDirection == DataGridSortDirection.ascending) {
  ///         return valueA.toLowerCase().compareTo(valueB.toLowerCase());
  ///       } else {
  ///         return valueA.toLowerCase().compareTo(valueB.toLowerCase());
  ///       }
  ///     }
  ///
  ///     return super.compare(a, b, sortColumn);
  ///   }
  /// }
  ///
  /// ```
  @protected
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    Object? _getCellValue(List<DataGridCell>? cells, String columnName) {
      return cells
              ?.firstWhereOrNull((element) => element.columnName == columnName)
              ?.value ??
          null;
    }

    final valueA = _getCellValue(a?.getCells() ?? null, sortColumn.name);
    final valueB = _getCellValue(b?.getCells() ?? null, sortColumn.name);
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
      _unSortedRows = rows.toList();
      _effectiveRows = _unSortedRows;
    } else {
      _effectiveRows = rows;
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
  ///               GridTextColumn(columnName: 'id', label = Text('ID')),
  ///               GridTextColumn(columnName: 'name', label = Text('Name')),
  ///               GridTextColumn(columnName: 'designation', label = Text('Designation')),
  ///               GridTextColumn(columnName: 'salary', label = Text('Salary')),
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
  }

  _DataGridStateDetails? _dataGridStateDetails;

  /// The collection of objects that contains object of corresponding
  /// to the selected rows in [SfDataGrid].
  List<DataGridRow> get selectedRows => _selectedRows;
  List<DataGridRow> _selectedRows = List.empty();

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
  double _verticalOffset = 0.0;

  /// The current scroll offset of the horizontal scrollbar.
  double get horizontalOffset => _horizontalOffset;
  double _horizontalOffset = 0.0;

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
      final _DataGridSettings? dataGridSettings = _dataGridStateDetails!();
      if (dataGridSettings != null &&
          rowColumnIndex != RowColumnIndex(-1, -1) &&
          dataGridSettings.selectionMode != SelectionMode.none &&
          dataGridSettings.navigationMode != GridNavigationMode.row) {
        final rowIndex = _GridIndexResolver.resolveToRowIndex(
            dataGridSettings, rowColumnIndex.rowIndex);
        final columnIndex = _GridIndexResolver.resolveToGridVisibleColumnIndex(
            dataGridSettings, rowColumnIndex.columnIndex);
        if (rowIndex < 0 || columnIndex < 0) {
          return;
        }
        final rowSelectionController = dataGridSettings.rowSelectionManager;
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
      final scrollRows = dataGridSettings.container.scrollRows;
      final scrollColumns = dataGridSettings.container.scrollColumns;

      if (rowIndex > dataGridSettings.container.rowCount ||
          columnIndex > scrollColumns.lineCount) {
        return;
      }
      final _rowIndex = _GridIndexResolver.resolveToRowIndex(
          dataGridSettings, rowIndex.toInt());
      final _columnIndex = _GridIndexResolver.resolveToGridVisibleColumnIndex(
          dataGridSettings, columnIndex.toInt());
      double verticalOffset = _rowIndex < 0
          ? dataGridSettings.container.verticalOffset
          : _SelectionHelper.getVerticalCumulativeDistance(
              dataGridSettings, _rowIndex);
      double horizontalOffset = _columnIndex < 0
          ? dataGridSettings.container.horizontalOffset
          : _SelectionHelper.getHorizontalCumulativeDistance(
              dataGridSettings, _columnIndex);
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
      if (rowPosition == DataGridScrollPosition.center) {
        verticalOffset = verticalOffset -
            ((dataGridSettings.viewHeight -
                    scrollRows.footerExtent -
                    scrollRows.headerExtent) /
                2) +
            (dataGridSettings.rowHeight / 2);
      } else if (rowPosition == DataGridScrollPosition.end) {
        verticalOffset = verticalOffset -
            (dataGridSettings.viewHeight -
                scrollRows.footerExtent -
                scrollRows.headerExtent) +
            dataGridSettings.rowHeight;
      } else if (rowPosition == DataGridScrollPosition.makeVisible) {
        final visibleRows = scrollRows.getVisibleLines();
        final startIndex =
            visibleRows[visibleRows.firstBodyVisibleIndex].lineIndex;
        final endIndex =
            visibleRows[visibleRows.lastBodyVisibleIndex].lineIndex;
        if (_rowIndex > startIndex && _rowIndex < endIndex) {
          verticalOffset = dataGridSettings.container.verticalOffset;
        }
        if (dataGridSettings.container.verticalOffset - verticalOffset < 0) {
          verticalOffset = verticalOffset -
              (dataGridSettings.viewHeight -
                  scrollRows.footerExtent -
                  scrollRows.headerExtent) +
              dataGridSettings.rowHeight;
        }
      }
      if (columnPosition == DataGridScrollPosition.center) {
        horizontalOffset = horizontalOffset -
            ((dataGridSettings.viewWidth -
                    scrollColumns.footerExtent -
                    scrollColumns.headerExtent) /
                2) +
            (dataGridSettings.defaultColumnWidth / 2);
      } else if (columnPosition == DataGridScrollPosition.end) {
        horizontalOffset = horizontalOffset -
            (dataGridSettings.viewWidth -
                scrollColumns.footerExtent -
                scrollColumns.headerExtent) +
            dataGridSettings.defaultColumnWidth;
      } else if (columnPosition == DataGridScrollPosition.makeVisible) {
        final visibleColumns = scrollColumns.getVisibleLines();
        final startIndex =
            visibleColumns[visibleColumns.firstBodyVisibleIndex].lineIndex;
        final endIndex =
            visibleColumns[visibleColumns.lastBodyVisibleIndex].lineIndex;
        if (_columnIndex > startIndex && _columnIndex < endIndex) {
          horizontalOffset = dataGridSettings.container.horizontalOffset;
        }
        if (dataGridSettings.container.horizontalOffset - horizontalOffset <
            0) {
          horizontalOffset = horizontalOffset -
              (dataGridSettings.viewWidth -
                  scrollColumns.footerExtent -
                  scrollColumns.headerExtent) +
              dataGridSettings.defaultColumnWidth;
        }
      }

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
    for (final listener in _dataGridSourceListeners) {
      listener(rowColumnIndex: rowColumnIndex);
    }
  }

  /// Call this method whenever the rowColumnIndex, propertyName and recalculateRowHeight of the underlying data are updated internally.
  void _notifyDataGridPropertyChangeListeners(
      {RowColumnIndex? rowColumnIndex,
      String? propertyName,
      bool recalculateRowHeight = false}) {
    for (final listener in _dataGridPropertyChangeListeners) {
      listener(
          rowColumnIndex: rowColumnIndex,
          propertyName: propertyName,
          recalculateRowHeight: recalculateRowHeight);
    }
  }
}
