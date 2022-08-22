import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';
import '../model/employees.dart';

/// stacked header class
// ignore: must_be_immutable
class StackedHeadersSample extends StatefulWidget {
  /// Creates the  class for stacked header with required details.
  StackedHeadersSample(this.sampleName, {this.textDirection = 'ltr'});

  /// sample name
  String sampleName;

  /// text direction
  String textDirection;

  @override
  StackedHeadersSampleState createState() => StackedHeadersSampleState();
}

///  Creates the  class for stacked header
// ignore: must_be_immutable
class StackedHeadersSampleState extends State<StackedHeadersSample> {
  String _stackedHeader = '';
  late EmployeeDataGridSource _employeeDataGridSource;

  @override
  void initState() {
    columns = getColumns();
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
      case 'stackedheader_row_manipulation':
        return SfDataGrid(
          columns: columns,
          source: _employeeDataGridSource,
          stackedHeaderRows: _getStackedHeaderRow(_stackedHeader),
          footerFrozenRowsCount: 1,
          footerHeight: 150,
          footer: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  MaterialButton(
                      child: const Text('Add stacked header'),
                      onPressed: () {
                        setState(() {
                          _stackedHeader = 'Add stacked header';
                        });
                      }),
                  MaterialButton(
                      child: const Text('Remove stacked header'),
                      onPressed: () {
                        setState(() {
                          _stackedHeader = 'Remove stacked header';
                        });
                      }),
                ],
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                      child: const Text('Set null to cell'),
                      onPressed: () {
                        setState(() {
                          _stackedHeader =
                              'provide null to stacked header cell';
                        });
                      }),
                  MaterialButton(
                      child: const Text('Add the stacked header cell'),
                      onPressed: () {
                        setState(() {
                          _stackedHeader = 'Add the stacked header cell';
                        });
                      })
                ],
              )
            ],
          ),
        );

      case 'emptysource_with_stackedheader':
        return SfDataGrid(
            columns: columns,
            source: EmployeeDataGridSource(employeesData: <Employees>[]),
            stackedHeaderRows: <StackedHeaderRow>[
              StackedHeaderRow(cells: <StackedHeaderCell>[
                StackedHeaderCell(
                    columnNames: <String>['salary', 'id'],
                    child: const Text('EmployeeInfo'))
              ]),
              StackedHeaderRow(cells: <StackedHeaderCell>[
                StackedHeaderCell(
                    columnNames: <String>['name', 'designation'],
                    child: const Text('Employees Details'))
              ]),
            ]);

      case 'multiple_stackedheader':
        return SfDataGrid(
            columns: columns,
            source: _employeeDataGridSource,
            footerHeight: 140,
            footerFrozenRowsCount: 1,
            footer: Column(
              children: <Widget>[
                MaterialButton(
                    child: const Text('Multiple stacked header'),
                    onPressed: () {
                      _employeeDataGridSource.employees.clear();
                      _employeeDataGridSource.buildDataGridRow();
                      _employeeDataGridSource.updateDataGridDataSource();
                      setState(() {});
                    })
              ],
            ),
            stackedHeaderRows: <StackedHeaderRow>[
              StackedHeaderRow(cells: <StackedHeaderCell>[
                StackedHeaderCell(columnNames: <String>[
                  'id',
                  'name',
                  'designation',
                  'salary'
                ], child: const Text('Employees'))
              ]),
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
            ]);

      case 'stackedheader_with_crud_operation':
        return SfDataGrid(
            columns: columns,
            source: _employeeDataGridSource,
            footerHeight: 140,
            allowSorting: true,
            footerFrozenRowsCount: 1,
            footer: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    MaterialButton(
                        child: const Text('Add row'),
                        onPressed: () {
                          _employeeDataGridSource.employees.insert(
                              0, Employees(1, 'Nill', 'Developer', 20000));

                          _employeeDataGridSource.buildDataGridRow();
                          _employeeDataGridSource.updateDataGridDataSource();
                        }),
                    MaterialButton(
                        child: const Text('Remove row'),
                        onPressed: () {
                          _employeeDataGridSource.employees.removeAt(0);
                          _employeeDataGridSource.buildDataGridRow();
                          _employeeDataGridSource.updateDataGridDataSource();
                        })
                  ],
                ),
              ],
            ),
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
            ]);
      case 'stackedheader_with_column_manipulation':
        return SfDataGrid(
            footerFrozenRowsCount: 1,
            columns: columns,
            source: _employeeDataGridSource,
            allowSorting: true,
            stackedHeaderRows: <StackedHeaderRow>[
              StackedHeaderRow(cells: <StackedHeaderCell>[
                StackedHeaderCell(
                    columnNames: <String>['id'],
                    child: const Text('Employee ID')),
                StackedHeaderCell(
                    columnNames: <String>['name'],
                    child: const Text('Employee Name')),
                StackedHeaderCell(
                    columnNames: <String>['designation', 'salary'],
                    child: const Text('Employee Details'))
              ])
            ],
            footer: SizedBox(
                child: Row(
              children: <Widget>[
                MaterialButton(
                  child: const Text('Remove Column'),
                  onPressed: () {
                    columns.removeAt(0);
                    setState(() {});
                  },
                ),
                MaterialButton(
                  child: const Text('Add Column'),
                  onPressed: () {
                    columns.insert(
                        0,
                        GridColumn(
                            columnName: 'id',
                            label: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                alignment: Alignment.centerRight,
                                child: const Text(
                                  'ID',
                                  overflow: TextOverflow.ellipsis,
                                ))));
                    setState(() {});
                  },
                ),
              ],
            )));

      case 'stackedheader_with_header_height_zero':
        return SfDataGrid(
          headerRowHeight: 0,
          columns: columns,
          source: _employeeDataGridSource,
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
    }
    return null;
  }

  List<StackedHeaderRow> _getStackedHeaderRow(String behaviour) {
    late List<StackedHeaderRow> stackedHeaderRows;
    switch (behaviour) {
      case 'Add stacked header':
        stackedHeaderRows = <StackedHeaderRow>[
          StackedHeaderRow(cells: <StackedHeaderCell>[
            StackedHeaderCell(
                columnNames: <String>['id', 'name'],
                child: const Center(child: Text('Employees'))),
            StackedHeaderCell(
                columnNames: <String>['designation', 'salary'],
                child: const Center(child: Text('Designation Details')))
          ])
        ];
        break;
      case 'Remove stacked header':
        stackedHeaderRows = <StackedHeaderRow>[];
        break;
      case 'provide null to stacked header cell':
        stackedHeaderRows = <StackedHeaderRow>[
          StackedHeaderRow(cells: <StackedHeaderCell>[
            StackedHeaderCell(
                columnNames: <String>['id', 'name'],
                child: const Center(child: Text(' '))),
            StackedHeaderCell(
                columnNames: <String>['designation', 'salary'],
                child: const Center(child: Text('Designation Details')))
          ])
        ];
        break;
      case 'Add the stacked header cell':
        stackedHeaderRows = <StackedHeaderRow>[
          StackedHeaderRow(cells: <StackedHeaderCell>[
            StackedHeaderCell(
                columnNames: <String>['id', 'name'],
                child: const Center(child: Text('Employees Details'))),
            StackedHeaderCell(
                columnNames: <String>['designation'],
                child: const Center(child: Text('Designation Cell'))),
            StackedHeaderCell(
                columnNames: <String>['salary'],
                child: const Center(child: Text('Salary'))),
          ])
        ];
        break;
      case '':
        stackedHeaderRows = <StackedHeaderRow>[];
        break;
    }
    return stackedHeaderRows;
  }
}
