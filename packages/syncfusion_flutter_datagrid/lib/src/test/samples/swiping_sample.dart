import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';

/// Swiping sample

// ignore: must_be_immutable
class SwipingSample extends StatefulWidget {
  // ignore: public_member_api_docs
  SwipingSample(this.sampleName, {this.textDirection = 'ltr'});

  /// sample name
  String sampleName;

  /// text direction
  String textDirection;

  @override
  SwipingSampleState createState() => SwipingSampleState();
}

/// A state class [SwipingSampleState] can be used to maintain the swiping
/// sample state details.
class SwipingSampleState extends State<SwipingSample> {
  bool _allowSwiping = true;
  double _swipeMaxOffset = 200;
  late ColumnWidthMode? _columnWidthMode;
  double _defaultColumnWidth = 230;
  late EmployeeDataGridSource _employeeDataGridSource;

  @override
  void initState() {
    columns = getColumns();
    _columnWidthMode = ColumnWidthMode.auto;
    _employeeDataGridSource =
        EmployeeDataGridSource(employeesData: populateData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Swiping Sample'),
          ),
          body: SizedBox(
              child: Directionality(
                  textDirection: widget.textDirection == 'ltr'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: _buildDataGrid(widget.sampleName)))),
    );
  }

  SfDataGrid _buildDataGrid(String sampleName) {
    SfDataGrid? datagrid;
    switch (sampleName) {
      case 'default':
        datagrid = SfDataGrid(
          swipeMaxOffset: _swipeMaxOffset,
          allowSwiping: _allowSwiping,
          columnWidthMode: _columnWidthMode!,
          startSwipeActionsBuilder:
              (BuildContext context, DataGridRow row, int rowIndex) {
            return MaterialButton(
                onPressed: () {
                  _employeeDataGridSource.employees[rowIndex].id = 11;
                  _employeeDataGridSource.buildDataGridRow();
                  _employeeDataGridSource.updateDataGridDataSource();
                },
                child: const Text('Update cell value'));
          },
          endSwipeActionsBuilder:
              (BuildContext context, DataGridRow row, int rowIndex) {
            return MaterialButton(
                onPressed: () {
                  _employeeDataGridSource.employees.removeAt(rowIndex - 2);
                  _employeeDataGridSource.buildDataGridRow();
                  _employeeDataGridSource.updateDataGridDataSource();
                },
                child: const Text('Delete Row'));
          },
          source: _employeeDataGridSource,
          columns: columns,
          footerFrozenRowsCount: 1,
          footerHeight: 100,
          defaultColumnWidth: _defaultColumnWidth,
          stackedHeaderRows: <StackedHeaderRow>[
            StackedHeaderRow(cells: <StackedHeaderCell>[
              StackedHeaderCell(
                  columnNames: <String>['id', 'name'],
                  child: const Text('Employee Details'))
            ]),
            StackedHeaderRow(cells: <StackedHeaderCell>[
              StackedHeaderCell(
                  columnNames: <String>['designation', 'salary'],
                  child: const Text('Designation Details'))
            ]),
          ],
          footer: SizedBox(
            width: 500,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          _allowSwiping = false;
                          setState(() {});
                        },
                        child: const Text('reset allowSwiping')),
                    TextButton(
                        onPressed: () {
                          _columnWidthMode = ColumnWidthMode.fill;
                          setState(() {});
                        },
                        child: const Text('swiping with columnsizing'))
                  ],
                ),
                SizedBox(
                  child: Row(
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            _swipeMaxOffset = 100;
                            setState(() {});
                          },
                          child: const Text('update the swipeMaxOffset')),
                      TextButton(
                          onPressed: () {
                            _defaultColumnWidth = 100;
                            setState(() {});
                          },
                          child: const Text('update columnWidth')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        break;
    }
    return datagrid!;
  }
}
