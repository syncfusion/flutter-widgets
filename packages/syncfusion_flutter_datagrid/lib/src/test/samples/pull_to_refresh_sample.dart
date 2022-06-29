import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';
import '../model/employees.dart';

/// A statelessWidget that build a datagrid with the pull to refresh feature.
// ignore: must_be_immutable
class PullToRefreshSample extends StatelessWidget {
  /// Creates the  class for pull to refresh sample with required details
  PullToRefreshSample(this.sampleName, {this.textDirection = 'ltr'});

  ///sample name
  final String sampleName;

  /// text direction
  String textDirection;

  /// datagrid source class instances
  PullToRefreshDataGridSource pullToRefreshDataGridSource =
      PullToRefreshDataGridSource();

  /// An instance of a [DataGridController] that can be used to manage selection
  /// and current cell operations in the data grid.
  DataGridController dataGridController = DataGridController();

  ///To Do
  double headerRowHeight = 56.0;

  ///To Do
  bool stackedHeader = false;

  ///To Do
  List<StackedHeaderRow> stackedHeaderRows = <StackedHeaderRow>[];

  // ignore: annotate_overrides
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Row(),
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
            key: _key,
            source: pullToRefreshDataGridSource,
            allowPullToRefresh: true,
            columnWidthMode: ColumnWidthMode.fill,
            footerFrozenRowsCount: 1,
            footerHeight: 100,
            stackedHeaderRows:
                stackedHeader ? stackedHeaderRows : <StackedHeaderRow>[],
            footer: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    MaterialButton(
                        child: const Text('PullToRefresh'),
                        onPressed: () {
                          _key.currentState!.refresh(false);
                        }),
                    MaterialButton(
                        child: const Text('Change header height'),
                        onPressed: () {
                          headerRowHeight = 70;
                        }),
                    MaterialButton(
                        child: const Text('Stacked Header'),
                        onPressed: () {
                          stackedHeader = true;
                          stackedHeaderRows = <StackedHeaderRow>[
                            StackedHeaderRow(cells: <StackedHeaderCell>[
                              StackedHeaderCell(
                                  columnNames: <String>['id', 'name'],
                                  child: const Text('Employee Details')),
                              StackedHeaderCell(columnNames: <String>[
                                'salary',
                                'designation'
                              ], child: const Text('Employee Information'))
                            ])
                          ];
                          setState(() {});
                        }),
                  ],
                ),
              ],
            ),
            columns: columns);

      case 'footerView':
        return SfDataGrid(
            source: pullToRefreshDataGridSource,
            columnWidthMode: ColumnWidthMode.fill,
            footerFrozenRowsCount: 1,
            footer: const Center(
              child: SizedBox(child: Text('Footer View')),
            ),
            columns: columns);

      case 'freezePanes':
        return SfDataGrid(
            source: pullToRefreshDataGridSource,
            columnWidthMode: ColumnWidthMode.fill,
            footerFrozenRowsCount: 3,
            stackedHeaderRows:
                stackedHeader ? stackedHeaderRows : <StackedHeaderRow>[],
            footer: Row(
              children: <Widget>[
                MaterialButton(
                    child: const Text('PullToRefresh'),
                    onPressed: () {
                      _key.currentState!.refresh(false);
                    }),
                MaterialButton(
                    child: const Text('Change header height'),
                    onPressed: () {
                      headerRowHeight = 70;
                    }),
                MaterialButton(
                    child: const Text('Stacked Heaeder'),
                    onPressed: () {
                      stackedHeader = true;
                      stackedHeaderRows = <StackedHeaderRow>[
                        StackedHeaderRow(cells: <StackedHeaderCell>[
                          StackedHeaderCell(
                              columnNames: <String>['id', 'name'],
                              child: const Text('Employee Details')),
                          StackedHeaderCell(
                              columnNames: <String>['salary', 'designation'],
                              child: const Text('Employee Information'))
                        ])
                      ];
                    }),
              ],
            ),
            columns: columns);

      case 'stacked_header':
        return SfDataGrid(
            key: _key,
            source: pullToRefreshDataGridSource,
            columnWidthMode: ColumnWidthMode.fill,
            footerFrozenRowsCount: 1,
            headerRowHeight: headerRowHeight,
            footer: Row(
              children: <Widget>[
                MaterialButton(
                    child: const Text('PullToRefresh'),
                    onPressed: () {
                      _key.currentState!.refresh();
                    }),
                MaterialButton(
                    child: const Text('Change header height'),
                    onPressed: () {
                      headerRowHeight = 70;
                    }),
              ],
            ),
            stackedHeaderRows: <StackedHeaderRow>[
              StackedHeaderRow(cells: <StackedHeaderCell>[
                StackedHeaderCell(
                    columnNames: <String>['id', 'name'],
                    child: const Text('Employee Details')),
                StackedHeaderCell(
                    columnNames: <String>['salary', 'designation'],
                    child: const Text('Employee Information'))
              ])
            ],
            columns: columns);
    }
    return null;
  }
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class PullToRefreshDataGridSource extends EmployeeDataGridSource {
  /// Creates the employee data source class with required details.
  PullToRefreshDataGridSource() : super(employeesData: <Employees>[]) {
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

  /// The collection of [Employees].
  List<Employees> employeeData = <Employees>[];

  final List<Employees> _employees = populateData();

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  Future<void> handleRefresh() async {
    // await Future<dynamic>.delayed(const Duration(seconds: 10));
    employeeData = getEmployeesData(employeeData.length, 1, employeeData);
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
      employeeData.add(_employees[i]);
    }
    return employeeData;
  }
}
