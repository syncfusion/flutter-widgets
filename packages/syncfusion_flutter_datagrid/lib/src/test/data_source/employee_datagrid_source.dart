// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../model/employees.dart';

List<GridColumn> columns = getColumns();

/// employee collection
List<Employees> employees = populateData();

class EmployeeDataGridSource extends DataGridSource {
  EmployeeDataGridSource({required List<Employees> employeesData}) {
    employees = employeesData;
    buildDataGridRow();
  }
  late List<Employees> employees;
  List<DataGridRow> dataGridRows = <DataGridRow>[];

  void buildDataGridRow() {
    dataGridRows = employees
        .map<DataGridRow>((Employees dataGridRow) => DataGridRow(
            cells: columns.isNotEmpty
                ? columns.length != 3
                    ? <DataGridCell>[
                        DataGridCell<int>(
                            columnName: 'id', value: dataGridRow.id),
                        DataGridCell<String>(
                            columnName: 'name', value: dataGridRow.name),
                        DataGridCell<String>(
                            columnName: 'designation',
                            value: dataGridRow.designation),
                        DataGridCell<int>(
                            columnName: 'salary', value: dataGridRow.salary),
                      ]
                    : <DataGridCell>[
                        DataGridCell<String>(
                            columnName: 'name', value: dataGridRow.name),
                        DataGridCell<String>(
                            columnName: 'designation',
                            value: dataGridRow.designation),
                        DataGridCell<int>(
                            columnName: 'salary', value: dataGridRow.salary),
                      ]
                : <DataGridCell>[]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: columns
            .map<Widget>((GridColumn e) => _getWidgets(
                e.columnName,
                row
                        .getCells()
                        .firstWhere((DataGridCell element) =>
                            element.columnName == e.columnName)
                        .value ??
                    '',
                canApplyFormating: true))
            .toList());
  }

  void updateDataGridDataSource() {
    notifyListeners();
  }

  void updateNotifyDataSourceListeners({RowColumnIndex? rowColumnIndex}) {
    notifyDataSourceListeners();
    if (rowColumnIndex != null) {
      notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
    } else {
      notifyDataSourceListeners();
    }
  }
}

List<GridColumn> getColumns() {
  return <GridColumn>[
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
  ];
}

Widget _getWidgets(String columnName, dynamic cellValue,
    {bool canApplyFormating = false, TextStyle? headerTextStyle}) {
  switch (columnName) {
    case 'customerId':
    case 'productId':
    case 'id':
      return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerRight,
        child: Text(cellValue.toString(),
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: headerTextStyle),
      );
    case 'city':
    case 'name':
    case 'customerName':
    case 'product':
    case 'designation':
      return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerLeft,
        child: Text(cellValue.toString(),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: headerTextStyle),
      );

    case 'freight':
    case 'price':
    case 'unitPrice':
    case 'id1':
      return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerRight,
        child: Text('id:${cellValue.toString()}',
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: headerTextStyle),
      );
    case 'salary':
      return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerRight,
        child: Text(cellValue.toString(),
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: headerTextStyle),
      );
    case 'dateTime':
      return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerRight,
        child: Text(cellValue.toString(),
            softWrap: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: headerTextStyle),
      );
    default:
      return Container();
  }
}

List<Employees> populateData() {
  return <Employees>[
    Employees(10001, 'James', 'Project Lead', 20000),
    Employees(10002, 'Kathryn', 'Manager', 30000),
    Employees(10003, 'Lara', 'Developer', 15000),
    Employees(10004, 'Michael', 'Designer', 15000),
    Employees(10005, 'Martin', 'Developer', 15000),
    Employees(10006, 'Newberry', 'Developer', 15000),
    Employees(10007, 'Balnc', 'Developer', 15000),
    Employees(10008, 'Perry', 'Developer', 85000),
    Employees(10009, 'Gable', 'Developer', 15000),
    Employees(10010, 'Grimes', 'Developer', 15000),
    Employees(10011, 'James', 'Project Lead', 20000),
    Employees(10012, 'Kathryn', 'Manager', 30000),
    Employees(10013, 'Lara', 'Developer', 15000),
    Employees(10014, 'Michael', 'Designer', 15000),
    Employees(10015, 'Martin', 'Developer', 15000),
    Employees(10016, 'Newberry', 'Developer', 15000),
    Employees(10017, 'Balnc', 'Developer', 15000),
    Employees(10018, 'Perry', 'Developer', 18000),
    Employees(10019, 'Gable', 'Developer', 15000),
    Employees(10020, 'Grimes', 'Developer', 15000)
  ];
}
