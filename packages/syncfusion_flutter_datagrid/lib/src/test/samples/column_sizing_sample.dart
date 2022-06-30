// ignore_for_file: public_member_api_docs, unnecessary_statements

import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';
import '../model/employees.dart';

/// column sizing sample
// ignore: must_be_immutable
class ColumnSizerSample extends StatelessWidget {
  ColumnSizerSample(this.sampleName, {this.textDirection = 'ltr'});

  /// Sample name
  String sampleName;

  /// To Do
  double width = 500;

  /// column width mode
  ColumnWidthMode columnWidthMode = ColumnWidthMode.none;

  /// column width mode
  bool switchDataSource = false;

  /// text direction
  String textDirection;

  ///To do
  ColumnWidthCalculationRange columnWidthCalculationRange =
      ColumnWidthCalculationRange.visibleRows;

  EmployeeDataGridSource employeeDataGridSource =
      EmployeeDataGridSource(employeesData: populateData());

  ColumnSizingsource columnSizingsource = ColumnSizingsource();

  final List<GridColumn> _columns = <GridColumn>[
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
        columnName: 'id',
        label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.centerRight,
            child: const Text(
              'ID',
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Column Sizing Sample'),
            ),
            body: Directionality(
              textDirection: textDirection == 'ltr'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: StatefulBuilder(builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return SizedBox(
                    width: width, child: _buildDataGrid(sampleName, setState));
              }),
            )));
  }

  SfDataGrid? _buildDataGrid(
      String sampleName, void Function(void Function()) setState) {
    switch (sampleName) {
      case 'default':
        return SfDataGrid(
          columnWidthMode: columnWidthMode,
          source: columnSizingsource,
          columns: _columns,
          footerFrozenRowsCount: 1,
          footerHeight: 200,
          footer: SizedBox(
              width: 600, child: _getColumnWidthModeInButtons(setState)),
        );
      case 'empty collection':
        return SfDataGrid(
          columnWidthMode: columnWidthMode,
          source: columnSizingsource,
          // ignore: always_specify_types
          columns: _columns,
          footerFrozenRowsCount: 1,
          footerHeight: 200,
          footer: SizedBox(
              width: 600,
              child: Column(
                children: <Widget>[
                  _getColumnWidthModeInButtons(setState),
                  TextButton(
                      onPressed: () {
                        columnSizingsource.employees = <Employees>[];
                        columnSizingsource.buildDataGridRow();
                        columnSizingsource.updateDataGridDataSource;
                        setState(() {});
                      },
                      child: const Text('Empty Collection'))
                ],
              )),
        );
      case 'hide column':
        return SfDataGrid(
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          source: columnSizingsource,
          // ignore: always_specify_types
          columns: <GridColumn>[
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
                visible: false,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Designation',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'salary',
                visible: false,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Salary',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'name',
                visible: false,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Name1',
                      overflow: TextOverflow.ellipsis,
                    ))),
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
                columnName: 'designation',
                visible: false,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Designation1',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'salary',
                visible: false,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Salary1',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'name',
                visible: false,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Name2',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'designation',
                visible: false,
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
          ],
          footerFrozenRowsCount: 1,
          footerHeight: 200,
          footer: SizedBox(
              width: 600,
              child: Column(
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        width = 400;
                        setState(() {});
                      },
                      child: const Text('Change parent widget width')),
                  TextButton(
                      onPressed: () {
                        // ignore: always_specify_types
                        setState(() {});
                      },
                      child: const Text('hide ID column'))
                ],
              )),
        );
      case 'column width':
        return SfDataGrid(
          source: columnSizingsource,
          columnWidthMode: ColumnWidthMode.fill,
          columns: <GridColumn>[
            GridColumn(
                columnName: 'name',
                minimumWidth: 200,
                maximumWidth: 500,
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
                minimumWidth: 200,
                maximumWidth: 500,
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
                columnName: 'id',
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'ID',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                minimumWidth: 200,
                maximumWidth: 500,
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
          ],
        );

      case 'number formmating':
        return SfDataGrid(
          columnWidthMode: ColumnWidthMode.auto,
          source: employeeDataGridSource,
          columns: columns,
        );
      case 'change container size':
        return SfDataGrid(
          columnWidthMode: ColumnWidthMode.fill,
          source: columnSizingsource,
          columns: _columns,
          footerFrozenRowsCount: 1,
          footer: SizedBox(
              width: width,
              child: Column(
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        width = 400;
                        setState(() {});
                      },
                      child: const Text('Change parent widget width')),
                ],
              )),
        );
      case 'Swithching between datasoucre':
        return SfDataGrid(
            source:
                switchDataSource ? employeeDataGridSource : columnSizingsource,
            columns: switchDataSource ? columns : _columns,
            columnWidthMode: ColumnWidthMode.auto,
            footerFrozenRowsCount: 1,
            footerHeight: 100,
            footer: Column(
              children: <Widget>[
                Row(
                  children: <TextButton>[
                    TextButton(
                        onPressed: () {
                          columnSizingsource.employeesCollection[0]
                              .designation = 'senior Human Resource';
                          columnSizingsource._dataGridRows[0] =
                              DataGridRow(cells: <DataGridCell>[
                            DataGridCell<int>(
                                columnName: 'id',
                                value: columnSizingsource
                                    .employeesCollection[0].id),
                            DataGridCell<String>(
                                columnName: 'name',
                                value: columnSizingsource
                                    .employeesCollection[0].name),
                            DataGridCell<String>(
                                columnName: 'designation',
                                value: columnSizingsource
                                    .employeesCollection[0].designation),
                            DataGridCell<int>(
                                columnName: 'salary',
                                value: columnSizingsource
                                    .employeesCollection[0].salary),
                            DataGridCell<String>(
                                columnName: 'name',
                                value: columnSizingsource
                                    .employeesCollection[0].name),
                            DataGridCell<String>(
                                columnName: 'designation',
                                value: columnSizingsource
                                    .employeesCollection[0].designation),
                            DataGridCell<int>(
                                columnName: 'salary',
                                value: columnSizingsource
                                    .employeesCollection[0].salary),
                            DataGridCell<String>(
                                columnName: 'name',
                                value: columnSizingsource
                                    .employeesCollection[0].name),
                            DataGridCell<String>(
                                columnName: 'designation',
                                value: columnSizingsource
                                    .employeesCollection[0].designation),
                            DataGridCell<int>(
                                columnName: 'salary',
                                value: columnSizingsource
                                    .employeesCollection[0].salary),
                          ]);
                          columnSizingsource.buildDataGridRow();
                          // ignore: invalid_use_of_protected_member
                          columnSizingsource.notifyDataSourceListeners(
                              rowColumnIndex: RowColumnIndex(0, 2));
                        },
                        child: const Text('Update value')),
                    TextButton(
                        onPressed: () {
                          switchDataSource = true;

                          setState(() {});
                        },
                        child: const Text('Switch Datasource')),
                  ],
                ),
              ],
            ));
      case 'crud operation':
        return SfDataGrid(
          columnWidthMode: ColumnWidthMode.fill,
          source: columnSizingsource,
          footerFrozenRowsCount: 1,
          columns: _columns,
          footer: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        _columns.removeAt(0);
                        columnSizingsource.buildDataGridRow(true);
                        setState(() {});
                      },
                      child: const Text('Remove Column')),
                  TextButton(
                      onPressed: () {
                        _columns.insert(
                          0,
                          GridColumn(
                              columnName: 'name',
                              label: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Name',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                        );
                        columnSizingsource.buildDataGridRow();
                        setState(() {});
                      },
                      child: const Text('Add Column')),
                ],
              ),
            ],
          ),
        );
      case 'columnWidthCalculationRange':
        return SfDataGrid(
            columnWidthMode: columnWidthMode,
            columnWidthCalculationRange: columnWidthCalculationRange,
            footerFrozenRowsCount: 1,
            footerHeight: 200,
            footer: SizedBox(
                child: Column(
              children: <Widget>[
                _getColumnWidthModeInButtons(setState),
                TextButton(
                    onPressed: () {
                      columnSizingsource.employeesCollection[3].designation =
                          'Senior Product Manager';

                      columnSizingsource._dataGridRows[3] =
                          DataGridRow(cells: <DataGridCell>[
                        DataGridCell<int>(
                            columnName: 'id',
                            value:
                                columnSizingsource.employeesCollection[3].id),
                        DataGridCell<String>(
                            columnName: 'name',
                            value:
                                columnSizingsource.employeesCollection[3].name),
                        DataGridCell<String>(
                            columnName: 'designation',
                            value: columnSizingsource
                                .employeesCollection[3].designation),
                        DataGridCell<int>(
                            columnName: 'salary',
                            value: columnSizingsource
                                .employeesCollection[3].salary),
                        DataGridCell<String>(
                            columnName: 'name',
                            value:
                                columnSizingsource.employeesCollection[3].name),
                        DataGridCell<String>(
                            columnName: 'designation',
                            value: columnSizingsource
                                .employeesCollection[3].designation),
                        DataGridCell<int>(
                            columnName: 'salary',
                            value: columnSizingsource
                                .employeesCollection[3].salary),
                        DataGridCell<String>(
                            columnName: 'name',
                            value:
                                columnSizingsource.employeesCollection[3].name),
                        DataGridCell<String>(
                            columnName: 'designation',
                            value: columnSizingsource
                                .employeesCollection[3].designation),
                        DataGridCell<int>(
                            columnName: 'salary',
                            value: columnSizingsource
                                .employeesCollection[3].salary),
                      ]);
                      columnSizingsource.buildDataGridRow();
                      // ignore: invalid_use_of_protected_member
                      columnSizingsource.notifyListeners();
                    },
                    child: const Text('update cell value')),
                TextButton(
                    onPressed: () {
                      columnWidthCalculationRange =
                          ColumnWidthCalculationRange.allRows;
                      setState(() {});
                    },
                    child: const Text('allRows'))
              ],
            )),
            source: employeeDataGridSource,
            columns: columns);
    }
    return null;
  }

  Widget _getColumnWidthModeInButtons(void Function(void Function()) setState) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            TextButton(
                onPressed: () {
                  columnWidthMode = ColumnWidthMode.auto;
                  setState(() {});
                },
                child: const Text('Auto')),
            TextButton(
                onPressed: () {
                  columnWidthMode = ColumnWidthMode.fill;
                  setState(() {});
                },
                child: const Text('Fill')),
            TextButton(
                onPressed: () {
                  columnWidthMode = ColumnWidthMode.fitByCellValue;
                  setState(() {});
                },
                child: const Text('FitByCellValue'))
          ],
        ),
        Row(
          children: <TextButton>[
            TextButton(
                onPressed: () {
                  columnWidthMode = ColumnWidthMode.fitByColumnName;
                  setState(() {});
                },
                child: const Text('FitByColumnName')),
            TextButton(
                onPressed: () {
                  columnWidthMode = ColumnWidthMode.lastColumnFill;
                  setState(() {});
                },
                child: const Text('LastColumnFill')),
          ],
        )
      ],
    );
  }
}

class ColumnSizingsource extends EmployeeDataGridSource {
  ColumnSizingsource() : super(employeesData: <Employees>[]) {
    buildDataGridRow();
  }

  List<Employees> employeesCollection = employees;
  List<DataGridRow> _dataGridRows = <DataGridRow>[];

  /// padding
  double padding = 8.0;

  /// font size
  double fontSize = 14.0;

  @override
  void buildDataGridRow([bool isColumnRemoved = false]) {
    _dataGridRows = employeesCollection
        .map<DataGridRow>((Employees dataGridRow) =>
            DataGridRow(cells: <DataGridCell>[
              DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
              if (!isColumnRemoved)
                DataGridCell<String>(
                    columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(
                  columnName: 'designation', value: dataGridRow.designation),
              DataGridCell<int>(
                  columnName: 'salary', value: dataGridRow.salary),
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
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(padding),
        child: Text(
          e.value.toString(),
          style: TextStyle(fontSize: fontSize),
        ),
      );
    }).toList());
  }

  @override
  void updateDataGridDataSource() {
    notifyListeners();
  }

  @override
  bool shouldRecalculateColumnWidths() {
    return true;
  }
}
