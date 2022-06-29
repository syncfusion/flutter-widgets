import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';
import '../model/employees.dart';

/// load more class
// ignore: must_be_immutable
class LoadMoreSample extends StatelessWidget {
  /// Creates the  class for load more sample with required details.
  LoadMoreSample(this.sampleName, {this.textDirection = 'ltr'});

  ///sample name
  final String sampleName;

  /// text direction
  final String textDirection;

  /// To Do
  LoadMoreDataGridSource loadMoreDataGridSource = LoadMoreDataGridSource();

  /// An instance of a [DataGridController] that can be used to manage selection
  /// and current cell operations in the data grid.
  DataGridController dataGridController = DataGridController();

  Widget _buildProgressIndicator() {
    return Container(
        height: 60.0,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            border: BorderDirectional(
                top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.26)))),
        child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: const SizedBox(
                child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
            ))));
  }

  /// Callback method for load more builder
  Widget _buildLoadMoreView(BuildContext context, LoadMoreRows loadMoreRows) {
    Future<String> loadRows() async {
      // Call the loadMoreRows function to call the
      // DataGridSource.handleLoadMoreRows method. So, additional
      // rows can be added from handleLoadMoreRows method.
      await loadMoreRows();
      return Future<String>.value('Completed');
    }

    return FutureBuilder<String>(
      initialData: 'Loading',
      future: loadRows(),
      builder: (BuildContext context, AsyncSnapshot<String> snapShot) {
        return snapShot.data == 'Loading'
            ? _buildProgressIndicator()
            : SizedBox.fromSize(size: Size.zero);
      },
    );
  }

  Widget _buildLoadMoreButtonView(
      BuildContext context, LoadMoreRows loadMoreRows) {
    bool showIndicator = false;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return showIndicator
          ? _buildProgressIndicator()
          : Container(
              height: 60.0,
              width: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                height: 36,
                child: TextButton(
                  onPressed: () async {
                    if (context is StatefulElement && context.state.mounted) {
                      setState(() {
                        showIndicator = true;
                      });
                    }

                    await loadMoreRows();

                    if (context is StatefulElement && context.state.mounted) {
                      setState(() {
                        showIndicator = false;
                      });
                    }
                  },
                  child: const Text('LOAD MORE',
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Syncfusion Flutter DataGrid'),
          ),
          body: Directionality(
            textDirection:
                textDirection == 'ltr' ? TextDirection.ltr : TextDirection.rtl,
            child: StatefulBuilder(builder: (BuildContext context,
                void Function(void Function()) setState) {
              return _buildDataGrid(sampleName, setState)!;
            }),
          )),
    );
  }

  // ignore: public_member_api_docs
  SfDataGrid? _buildDataGrid(String sample, dynamic setState) {
    switch (sample) {
      case 'default':
        return SfDataGrid(
            source: loadMoreDataGridSource,
            loadMoreViewBuilder: _buildLoadMoreView,
            columnWidthMode: ColumnWidthMode.fill,
            columns: columns);
      case 'footerView':
        return SfDataGrid(
            source: loadMoreDataGridSource,
            loadMoreViewBuilder: _buildLoadMoreView,
            columnWidthMode: ColumnWidthMode.fill,
            footerFrozenRowsCount: 1,
            footer: const Center(
              child: SizedBox(child: Text('Footer View')),
            ),
            columns: columns);

      case 'freezePanes':
        return SfDataGrid(
            source: loadMoreDataGridSource,
            loadMoreViewBuilder: _buildLoadMoreView,
            columnWidthMode: ColumnWidthMode.fill,
            footerFrozenRowsCount: 3,
            columns: columns);

      case 'loadMoreButton':
        return SfDataGrid(
            source: LoadMoreDataGridSource(),
            loadMoreViewBuilder: _buildLoadMoreButtonView,
            columnWidthMode: ColumnWidthMode.fill,
            columns: columns);
      case 'row_manipulation':
        return SfDataGrid(
            source: loadMoreDataGridSource,
            loadMoreViewBuilder: _buildLoadMoreView,
            columnWidthMode: ColumnWidthMode.fill,
            footerFrozenRowsCount: 1,
            footer: SizedBox(
              child: Row(
                children: <Widget>[
                  MaterialButton(
                      child: const Text('Add Row'),
                      onPressed: () {
                        loadMoreDataGridSource.employeeData.insert(
                          5,
                          Employees(10000, 'Joes', 'Manager', 20000),
                        );
                        loadMoreDataGridSource.buildDataGridRow();
                        loadMoreDataGridSource.updateDataGridSource();
                      }),
                  MaterialButton(
                      child: const Text('Remove Row'),
                      onPressed: () {
                        loadMoreDataGridSource.employeeData.removeAt(5);
                        loadMoreDataGridSource.buildDataGridRow();
                        loadMoreDataGridSource.updateDataGridSource();
                      }),
                  MaterialButton(
                    onPressed: () {
                      dataGridController.scrollToRow(15);
                    },
                    child: const Text('Scroll To Row'),
                  )
                ],
              ),
            ),
            columns: columns);
    }
    return null;
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class LoadMoreDataGridSource extends EmployeeDataGridSource {
  /// Creates the employee data source class with required details.
  LoadMoreDataGridSource() : super(employeesData: <Employees>[]) {
    employeeData = getEmployeesData(0, 13, employeeData);
    buildDataGridRow();
  }

  /// Build the data grid rows to the source by using the `employeeData` property.
  @override
  void buildDataGridRow() {
    _employeeData = employeeData
        .map<DataGridRow>((Employees e) => DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.designation),
              DataGridCell<int>(columnName: 'salary', value: e.salary),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = <DataGridRow>[];

  /// Employee collection
  List<Employees> employeeData = <Employees>[];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  Future<void> handleLoadMoreRows() async {
    await Future<dynamic>.delayed(const Duration(seconds: 5));
    employeeData = getEmployeesData(employeeData.length, 5, employeeData);
    buildDataGridRow();
    notifyListeners();
  }

  /// Refreshes the data grid source.
  void updateDataGridSource() {
    notifyListeners();
  }

  /// Returns the collection of employee data to generate `DataGridRows`.
  List<Employees> getEmployeesData(
      int startIndex, int endIndex, List<Employees> employeeData) {
    for (int i = startIndex; i <= startIndex + endIndex; i++) {
      employeeData.add(employees[i]);
    }
    return employeeData;
  }
}
