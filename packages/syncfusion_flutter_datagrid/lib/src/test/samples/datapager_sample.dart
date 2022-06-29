import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';
import '../model/employees.dart';
import 'basic_datagrid_sample.dart';

/// Defines the number of rows that should be displayed on a page.
int rowsPerPage = 0;

/// Data controller
DataPagerController dataPagerController = DataPagerController();

/// data pager sample
// ignore: must_be_immutable
class DataPagerSample extends StatefulWidget {
  /// Creates the  class for data pager sample with required details.
  DataPagerSample(this.sampleName, {this.textDirection = 'ltr'});

  /// Instance of datapager widget
  SfDataPager? dataPager;

  ///sample name
  final String sampleName;

  ///To Do
  bool datagridWithDataPager = false;

  /// To do
  String textDirection;

  @override
  DataPagerSampleState createState() => DataPagerSampleState();
}

/// Creates sample for datapager
// ignore: must_be_immutable
class DataPagerSampleState extends State<DataPagerSample> {
  ///To Do
  bool datagridWithDataPager = false;

  ///Employee collection
  final EmployeeDataGridSource _employeeInfoDataSource =
      EmployeeDataGridSource(employeesData: employees);

  /// create instance for dataGridSource class
  PagingDataGridSourcewithHandlePageChange
      pagingDataGridSourcewithHandlePageChange =
      PagingDataGridSourcewithHandlePageChange(employeeData: populateData());

  @override
  void initState() {
    columns = getColumns();
    controller = DataGridController();
    rowsPerPage = 5;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('DataPager Widget testing')),
        body: Directionality(
          textDirection: widget.textDirection == 'ltr'
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              widget.dataPager = _buildDataPager(widget.sampleName, setState);
              if (widget.sampleName.contains('datagrid') == true) {
                datagridWithDataPager = true;
              } else {
                datagridWithDataPager = false;
              }
              return datagridWithDataPager
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                            height: constraints.maxHeight - 60,
                            child: _buildDataGrid(widget.sampleName, setState)),
                        SizedBox(height: 60, child: widget.dataPager),
                      ],
                    )
                  : Container(child: widget.dataPager);
            },
          ),
        ),
      ),
    );
  }

  SfDataGrid? _buildDataGrid(
      String sample, void Function(void Function()) setState) {
    switch (sample) {
      case 'datapager_with_rowsPerPage_datagrid_handlePageChanges':
        return SfDataGrid(
          source: pagingDataGridSourcewithHandlePageChange,
          rowsPerPage: rowsPerPage,
          columns: columns,
        );
      case 'datapager_with_datagrid_rowsPerPage':
        return SfDataGrid(
            source: _employeeInfoDataSource,
            rowsPerPage: rowsPerPage,
            columns: columns);
      default:
        return SfDataGrid(
            source: _employeeInfoDataSource,
            footerFrozenRowsCount: 1,
            footerHeight: 60,
            allowSorting: true,
            footer: Row(
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    _employeeInfoDataSource.employees
                        .insert(0, Employees(10000, 'Jose', 'Manager', 30000));
                    _employeeInfoDataSource.buildDataGridRow();
                    _employeeInfoDataSource.updateDataGridDataSource();
                  },
                  child: const Text('Add Row'),
                ),
                MaterialButton(
                  onPressed: () {
                    _employeeInfoDataSource.employees.removeAt(0);
                    _employeeInfoDataSource.buildDataGridRow();
                    _employeeInfoDataSource.updateDataGridDataSource();
                  },
                  child: const Text('Remove Row'),
                ),
                MaterialButton(
                    child: const Text('Sorting'),
                    onPressed: () {
                      _employeeInfoDataSource.sortedColumns.add(
                          const SortColumnDetails(
                              name: 'id',
                              sortDirection: DataGridSortDirection.descending));
                      _employeeInfoDataSource.sort();
                    })
              ],
            ),
            columns: columns);
    }
  }

  /// create datapager widget
  SfDataPager? _buildDataPager(
      String sample, void Function(void Function()) setState) {
    switch (sample) {
      case 'default':
        return SfDataPager(
            pageCount: 8,
            delegate: EmployeeDataGridSource(employeesData: <Employees>[]));
      case 'visibleItemsCount':
        return SfDataPager(
            pageCount: 8,
            visibleItemsCount: 3,
            delegate: EmployeeDataGridSource(employeesData: <Employees>[]));

      case 'pageCount':
        return SfDataPager(
            pageCount: 8,
            delegate: EmployeeDataGridSource(employeesData: <Employees>[]));

      case 'direction':
        return SfDataPager(
            direction: Axis.vertical,
            pageCount: 8,
            delegate: EmployeeDataGridSource(employeesData: <Employees>[]));
      case 'resizingItemButton':
        return SfDataPager(
            pageCount: 8,
            itemHeight: 150,
            itemWidth: 150,
            delegate: EmployeeDataGridSource(employeesData: <Employees>[]));
      case 'navigation_button':
        return SfDataPager(
            pageCount: 8,
            pageItemBuilder: (String name) {
              return Text(name);
            },
            delegate: EmployeeDataGridSource(employeesData: <Employees>[]));
      case 'datapager_with_datagrid':
        return SfDataPager(pageCount: 8, delegate: _employeeInfoDataSource);

      case 'datapager_controller_with_datagrid':
        return SfDataPager(
          pageCount: 8,
          delegate: _employeeInfoDataSource,
          controller: dataPagerController,
        );
      case 'datapager_with_rowsPerPage_datagrid_handlePageChanges':
        return SfDataPager(
          pageCount: (employees.length / rowsPerPage).ceilToDouble(),
          delegate: pagingDataGridSourcewithHandlePageChange,
          controller: dataPagerController,
        );
      case 'datapager_with_datagrid_rowsPerPage':
        return SfDataPager(
          pageCount: (employees.length / rowsPerPage).ceilToDouble(),
          controller: dataPagerController,
          delegate: employeeDataGridSourceWithMoreColumns,
        );
    }
    return null;
  }
}

/// datasource class
class PagingDataGridSourcewithHandlePageChange extends EmployeeDataGridSource {
  /// Creates the employee data source class with required details.
  PagingDataGridSourcewithHandlePageChange({required this.employeeData})
      : super(employeesData: <Employees>[]) {
    _paginatedRows = employeeData.getRange(0, rowsPerPage).toList();
    buildDataGridRow();
  }

  /// create rows
  @override
  void buildDataGridRow() {
    _dataGridRows = _paginatedRows
        .map<DataGridRow>(
            (Employees e) => DataGridRow(cells: <DataGridCell<dynamic>>[
                  DataGridCell<int>(columnName: 'id', value: e.id),
                  DataGridCell<String>(columnName: 'name', value: e.name),
                  DataGridCell<String>(
                      columnName: 'designation', value: e.designation),
                  DataGridCell<int>(columnName: 'salary', value: e.salary),
                ]))
        .toList();
  }

  /// Employee collection
  List<Employees> employeeData = <Employees>[];

  List<Employees> _paginatedRows = <Employees>[];

  /// DataGridRows collection
  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) {
    final int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;

    /// Need to calculate endIndex for the last page, when the number of rows is
    /// lesser than rowsPerPage.
    if (endIndex > employeeData.length) {
      endIndex = employeeData.length;
    }

    /// Get particular range from the sorted collection.
    if (startIndex < effectiveRows.length && endIndex <= effectiveRows.length) {
      _paginatedRows = employeeData.getRange(startIndex, endIndex).toList();
    } else {
      _paginatedRows = <Employees>[];
    }
    buildDataGridRow();

    /// To update the collection in data pager.
    updateDataSource();

    return Future<bool>.value(true);
  }

  /// Refreshes the data grid source.
  void updateDataSource() {
    notifyListeners();
  }
}
