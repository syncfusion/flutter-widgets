import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';

// ignore: public_member_api_docs, must_be_immutable
class SelectionSample extends StatefulWidget {
  /// Creates the  class for selection sample with required details.
  SelectionSample(this.sampleName, {this.textDirection = 'ltr'});

  /// sample name
  String sampleName;

  /// Instance of datagrid widget
  SfDataGrid? datagrid;

  /// text direction
  String textDirection;

  @override
  SelectionSampleState createState() => SelectionSampleState();
}

/// A state class [SelectionSampleState] can be used to maintain the selection
/// sample state details.
class SelectionSampleState extends State<SelectionSample> {
  /// selection mode
  SelectionMode selectionMode = SelectionMode.none;

  /// selection mode
  GridNavigationMode navigationMode = GridNavigationMode.row;

  late EmployeeDataGridSource _employeeDataGridSource;

  late DataGridController _controller;

  @override
  void initState() {
    columns = getColumns();
    _controller = DataGridController();
    _employeeDataGridSource =
        EmployeeDataGridSource(employeesData: populateData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('DataGrid Widget Test'),
          ),
          body: Directionality(
              textDirection: widget.textDirection == 'ltr'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: _buildDataGrid(widget.sampleName, setState)!)),
    );
  }

  SfDataGrid? _buildDataGrid(String sample, dynamic setState) {
    switch (sample) {
      case 'selection_with_row_addition_deletion':
        widget.datagrid = SfDataGrid(
          columns: columns,
          source: _employeeDataGridSource,
          footerFrozenRowsCount: 1,
          selectionMode: SelectionMode.multiple,
          footerHeight: 90,
          controller: _controller,
          footer: Row(
            children: <Widget>[
              MaterialButton(
                  child: const Text('Add row'),
                  onPressed: () {
                    setState(() {
                      _employeeDataGridSource.dataGridRows.insert(
                          2,
                          const DataGridRow(cells: <DataGridCell>[
                            DataGridCell<int>(value: 2, columnName: 'id'),
                            DataGridCell<String>(
                                value: 'Michael', columnName: 'name'),
                            DataGridCell<String>(
                                value: 'Designer', columnName: 'designation'),
                            DataGridCell<int>(
                                value: 20000, columnName: 'salary'),
                          ]));
                      _employeeDataGridSource.updateDataGridDataSource();
                    });
                  }),
              MaterialButton(
                  child: const Text('Remove row'),
                  onPressed: () {
                    setState(() {
                      _employeeDataGridSource.dataGridRows.removeAt(2);
                      _employeeDataGridSource.updateDataGridDataSource();
                    });
                  }),
            ],
          ),
          stackedHeaderRows: <StackedHeaderRow>[
            StackedHeaderRow(cells: <StackedHeaderCell>[
              StackedHeaderCell(
                  columnNames: <String>['id,name'],
                  child: const Text('Employee Name')),
              StackedHeaderCell(
                  columnNames: <String>['designation', 'salary'],
                  child: const Text('Designation Details'))
            ])
          ],
        );
        break;
      case 'selection_feature':
        widget.datagrid = SfDataGrid(
            columns: getColumns(),
            controller: _controller,
            source: EmployeeDataGridSource(employeesData: populateData()),
            navigationMode: navigationMode,
            selectionMode: selectionMode,
            footerFrozenRowsCount: 1,
            footerHeight: 140,
            footer: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    MaterialButton(
                        child: const Text('single'),
                        onPressed: () {
                          setState(() {
                            selectionMode = SelectionMode.single;
                          });
                        }),
                    MaterialButton(
                        child: const Text('none'),
                        onPressed: () {
                          setState(() {
                            selectionMode = SelectionMode.none;
                          });
                        }),
                    MaterialButton(
                        child: const Text('multiple'),
                        onPressed: () {
                          setState(() {
                            selectionMode = SelectionMode.multiple;
                          });
                        }),
                    MaterialButton(
                        child: const Text('singledeselect'),
                        onPressed: () {
                          setState(() {
                            selectionMode = SelectionMode.singleDeselect;
                          });
                        })
                  ],
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                        child: const Text('row'),
                        onPressed: () {
                          setState(() {
                            navigationMode = GridNavigationMode.row;
                          });
                        }),
                    MaterialButton(
                        child: const Text('cell'),
                        onPressed: () {
                          setState(() {
                            navigationMode = GridNavigationMode.cell;
                          });
                        }),
                  ],
                )
              ],
            ));
        break;
    }
    return widget.datagrid;
  }
}
