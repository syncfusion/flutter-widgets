import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';
import '../model/employees.dart';

/// datagrid controller
late DataGridController controller;

///To Do
bool isSwitchDataGrid = false;

/// create instance for datagrid source
EmployeeDataGridSourceWithMoreColumns employeeDataGridSourceWithMoreColumns =
    EmployeeDataGridSourceWithMoreColumns(employeesData: employees);

/// basic datagrid sample class
// ignore: must_be_immutable
class BasicDataGridSample extends StatefulWidget {
  /// Creates the  class for basic datarid sample sample with required details.
  BasicDataGridSample(this.sampleName, {this.textDirection = 'ltr'});

  ///sample name
  String sampleName;

  ///text direction
  final String textDirection;

  /// Instance of datagrid widget
  SfDataGrid? datagrid;

  @override
  BasicDataGridSampleState createState() => BasicDataGridSampleState();
}

/// Creates sample for datagrid.
// ignore: must_be_immutable
class BasicDataGridSampleState extends State<BasicDataGridSample> {
  late EmployeeDataGridSource _employeeDataGridSource;
  @override
  void initState() {
    columns = getColumns();
    _employeeDataGridSource =
        EmployeeDataGridSource(employeesData: populateData());
    controller = DataGridController();
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
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                widget.datagrid = isSwitchDataGrid
                    ? _buildDataGrid('SwitchDataSource', setState)!
                    : _buildDataGrid(widget.sampleName, setState)!;
                return Container(child: widget.datagrid);
              },
            ),
          )),
    );
  }

  SfDataGrid? _buildDataGrid(String sample, dynamic setState) {
    switch (sample) {
      case 'BasicUseCases':
        return SfDataGrid(
          columns: columns,
          source: _employeeDataGridSource,
          footerFrozenRowsCount: 1,
          footer: MaterialButton(
              child: const Text('Switch DataGrid'),
              onPressed: () {
                isSwitchDataGrid = true;
                columns = <GridColumn>[
                  GridColumn(
                      columnName: 'id',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'ID',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'name',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Name',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'designation',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Designation',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'salary',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'Salary',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'name',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Name1',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'designation',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Designation1',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'salary',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'Salary1',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'id1',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'ID1',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'name',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Name2',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'designation',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Designation2',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'salary',
                      label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'Salary2',
                            overflow: TextOverflow.ellipsis,
                          ))),
                ];
                setState(() {});
              }),
        );
      case 'SetWidthandHeight':
        return SfDataGrid(
            defaultColumnWidth: 300,
            rowHeight: 80,
            columns: columns,
            source: _employeeDataGridSource);
      case 'QueryRowHeight':
        return SfDataGrid(
          columns: columns,
          source: _employeeDataGridSource,
          onQueryRowHeight: (RowHeightDetails details) {
            if (details.rowIndex == 3) {
              return 200;
            } else if (details.rowIndex == 0) {
              return 0;
            }

            return 100;
          },
        );
      case 'StackedHeader':
        return SfDataGrid(
            columns: columns,
            source: _employeeDataGridSource,
            headerRowHeight: 100,
            stackedHeaderRows: <StackedHeaderRow>[
              StackedHeaderRow(cells: <StackedHeaderCell>[
                StackedHeaderCell(
                    columnNames: <String>['id', 'name'],
                    child: const Text('EmployeeInfo'))
              ]),
              StackedHeaderRow(cells: <StackedHeaderCell>[
                StackedHeaderCell(
                    columnNames: <String>['designation', 'salary'],
                    child: const Text('Employees'))
              ]),
            ]);

      case 'FrozenPanes':
        return SfDataGrid(
          defaultColumnWidth: 140.0,
          columns: columns,
          source: _employeeDataGridSource,
          frozenRowsCount: 1,
          frozenColumnsCount: 1,
          footerFrozenRowsCount: 1,
          footerFrozenColumnsCount: 1,
        );
      case 'SetHeaderRowHeight':
        return SfDataGrid(
          columns: columns,
          source: _employeeDataGridSource,
          headerRowHeight: 0,
        );
      case 'Sorting':
        return SfDataGrid(
          columns: columns,
          source: EmployeeDataGridSource(employeesData: populateData()),
          allowSorting: true,
          allowMultiColumnSorting: true,
          allowTriStateSorting: true,
        );
      case 'Selection':
        return SfDataGrid(
          columns: getColumns(),
          controller: controller,
          source: EmployeeDataGridSource(employeesData: employees),
          navigationMode: GridNavigationMode.cell,
          selectionMode: SelectionMode.single,
        );
      case 'Footer':
        return SfDataGrid(
          columns: columns,
          source: _employeeDataGridSource,
          footer:
              const SizedBox(height: 70, child: Center(child: Text('Add Row'))),
        );
      case 'ColumnWidthMode':
        return SfDataGrid(
            columnWidthMode: ColumnWidthMode.fitByColumnName,
            source: _employeeDataGridSource,
            columns: columns);
      case 'EmptyDataSource':
        return SfDataGrid(
            source: EmployeeDataGridSource(employeesData: <Employees>[]),
            columns: columns);
      case 'SwitchDataSource':
        return SfDataGrid(
          source: employeeDataGridSourceWithMoreColumns,
          columns: columns,
        );
      case 'dataGrid_with_zero_column':
        return SfDataGrid(
          source: EmployeeDataGridSource(employeesData: <Employees>[]),
          columns: const <GridColumn>[],
        );
      case 'CRUD_Operation':
        return SfDataGrid(
          source: _employeeDataGridSource,
          columns: getColumns(),
          footerFrozenRowsCount: 1,
          footerHeight: 200,
          footer: SizedBox(
            height: 200,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: Row(
                    children: <Widget>[
                      MaterialButton(
                        child: const Text('Add Row'),
                        onPressed: () {
                          _employeeDataGridSource.employees.insert(0,
                              Employees(10021, 'Grimes', 'Developer', 15000));
                          _employeeDataGridSource.buildDataGridRow();
                          _employeeDataGridSource.updateDataGridDataSource();
                        },
                      ),
                      MaterialButton(
                        child: const Text('Remove Row'),
                        onPressed: () {
                          _employeeDataGridSource.rows.removeAt(0);
                          _employeeDataGridSource.updateDataGridDataSource();
                        },
                      ),
                      MaterialButton(
                        child: const Text('Update Cell Value'),
                        onPressed: () {
                          _employeeDataGridSource.employees[5].name =
                              'John Paul';
                          _employeeDataGridSource.buildDataGridRow();
                          _employeeDataGridSource
                              .updateNotifyDataSourceListeners(
                                  rowColumnIndex: RowColumnIndex(5, 1));
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                      child: const Text('Update Row Cells Value'),
                      onPressed: () {
                        _employeeDataGridSource.employees[1].id = 1;
                        _employeeDataGridSource.employees[1].name = 'Antony';
                        _employeeDataGridSource.employees[1].designation =
                            'Senior Designer';
                        _employeeDataGridSource.employees[1].salary = 35000;
                        _employeeDataGridSource.buildDataGridRow();
                        _employeeDataGridSource
                            .updateNotifyDataSourceListeners();
                      },
                    ),
                    MaterialButton(
                      child: const Text('Replace Row'),
                      onPressed: () {
                        _employeeDataGridSource.employees[1] =
                            Employees(0, 'James', 'Project Lead', 33000);
                        _employeeDataGridSource.buildDataGridRow();
                        _employeeDataGridSource
                            .updateNotifyDataSourceListeners();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      case 'gridcolumn_visibility':
        return SfDataGrid(
            columnWidthMode: ColumnWidthMode.fitByColumnName,
            source: _employeeDataGridSource,
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'id',
                  visible: false,
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'ID',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'name',
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Name',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'designation',
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Designation',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridColumn(
                  columnName: 'salary',
                  label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'Salary',
                        overflow: TextOverflow.ellipsis,
                      ))),
            ]);
      case 'gridcolumn':
        return SfDataGrid(
          footerFrozenRowsCount: 1,
          columns: columns,
          source: _employeeDataGridSource,
          footer: Row(
            children: <Widget>[
              MaterialButton(
                child: const Text('Remove Column'),
                onPressed: () {
                  columns.removeAt(0);
                  _employeeDataGridSource.buildDataGridRow();
                  _employeeDataGridSource.updateDataGridDataSource();
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
                  _employeeDataGridSource.buildDataGridRow();
                  _employeeDataGridSource.updateDataGridDataSource();
                },
              ),
            ],
          ),
        );
      case 'column-manipulation':
        return SfDataGrid(
          footerFrozenRowsCount: 1,
          columns: columns,
          source: _employeeDataGridSource,
          footer: Row(
            children: <Widget>[
              MaterialButton(
                child: const Text('Remove Column'),
                onPressed: () {
                  setState(() {
                    columns.removeAt(0);
                  });
                },
              ),
              MaterialButton(
                child: const Text('Add Column'),
                onPressed: () {
                  setState(() {
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
                  });
                },
              ),
            ],
          ),
        );
    }
    return null;
  }
}

/// datagrid source class
class EmployeeDataGridSourceWithMoreColumns extends EmployeeDataGridSource {
  // ignore: public_member_api_docs
  EmployeeDataGridSourceWithMoreColumns(
      {required List<Employees> employeesData})
      : super(employeesData: <Employees>[]) {
    _employees = employeesData;
    buildDataGridRow();
  }

  List<Employees> _employees = <Employees>[];
  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  @override
  void buildDataGridRow() {
    _dataGridRows = _employees
        .map<DataGridRow>((Employees dataGridRow) =>
            DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(
                  columnName: 'designation', value: dataGridRow.designation),
              DataGridCell<int>(
                  columnName: 'salary', value: dataGridRow.salary),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(
                  columnName: 'designation', value: dataGridRow.designation),
              DataGridCell<int>(
                  columnName: 'salary', value: dataGridRow.salary),
              DataGridCell<int>(columnName: 'id1', value: dataGridRow.id),
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(
                  columnName: 'designation', value: dataGridRow.designation),
              DataGridCell<int>(
                  columnName: 'salary', value: dataGridRow.salary),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;
}
