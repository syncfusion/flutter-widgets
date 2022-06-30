import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';
import '../model/employees.dart';

///  Creates the  class for sorting sample
// ignore: must_be_immutable
class SortingSample extends StatelessWidget {
  /// Creates the  class for sorting with required details.
  SortingSample(this.sampleName, {this.textDirection = 'ltr'});

  /// sample name
  String sampleName;

  /// Instance of datagrid widget
  SfDataGrid? datagrid;

  /// text direction
  String textDirection;

  /// employeeDataGrid Source
  final EmployeeDataGridSource employeeDataGridSource =
      EmployeeDataGridSource(employeesData: populateData());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('DataGrid Widget Test'),
          ),
          body: Directionality(
            textDirection:
                textDirection == 'ltr' ? TextDirection.ltr : TextDirection.rtl,
            child: StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                datagrid = _buildDataGrid(sampleName, setState);
                return datagrid!;
              },
            ),
          )),
    );
  }

  SfDataGrid? _buildDataGrid(String sample, dynamic setState) {
    switch (sample) {
      case 'sorting_with_doubleTap':
        return SfDataGrid(
          columns: columns,
          source: employeeDataGridSource,
          allowSorting: true,
          sortingGestureType: SortingGestureType.doubleTap,
        );
      case 'multicolumn_sorting':
        return SfDataGrid(
          columns: columns,
          source: employeeDataGridSource,
          allowSorting: true,
          allowMultiColumnSorting: true,
          footerFrozenRowsCount: 1,
          footer: SizedBox(
              height: 70,
              child: MaterialButton(
                child: const Text('Disable MultiColumnSorting'),
                onPressed: () {
                  employeeDataGridSource.sortedColumns.clear();
                  employeeDataGridSource.updateDataGridDataSource();
                },
              )),
        );
      case 'programmatic_sorting':
        return SfDataGrid(
          columns: columns,
          source: employeeDataGridSource,
          footerFrozenRowsCount: 1,
          footer: SizedBox(
              height: 70,
              child: MaterialButton(
                child: const Text('ProgrammaticSorting'),
                onPressed: () {
                  employeeDataGridSource.sortedColumns.add(
                      const SortColumnDetails(
                          name: 'id',
                          sortDirection: DataGridSortDirection.descending));
                  employeeDataGridSource.sort();
                },
              )),
        );
      case 'sorting_feature':
        return SfDataGrid(
          columns: columns,
          source: employeeDataGridSource,
          allowSorting: true,
          footerHeight: 120,
          footerFrozenRowsCount: 1,
          footer: SizedBox(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    MaterialButton(
                        child: const Text('Clear Sorting'),
                        onPressed: () {
                          employeeDataGridSource.sortedColumns.clear();
                          employeeDataGridSource.updateDataGridDataSource();
                        }),
                    MaterialButton(
                        child: const Text('Add Row'),
                        onPressed: () {
                          employeeDataGridSource.employees.insert(0,
                              Employees(10021, 'James', 'Project Lead', 38000));
                          employeeDataGridSource.buildDataGridRow();
                          employeeDataGridSource.updateDataGridDataSource();
                        }),
                    MaterialButton(
                        child: const Text('Delete Row'),
                        onPressed: () {
                          employeeDataGridSource.employees.removeAt(0);
                          employeeDataGridSource.buildDataGridRow();
                          employeeDataGridSource.updateDataGridDataSource();
                        }),
                  ],
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                        child: const Text('Update null to cell'),
                        onPressed: () {
                          employeeDataGridSource.employees[0].salary = null;
                          employeeDataGridSource.buildDataGridRow();
                          employeeDataGridSource.updateDataGridDataSource();
                        }),
                    MaterialButton(
                        child: const Text('Update datagrid'),
                        onPressed: () {
                          employeeDataGridSource.employees[0].salary = null;
                          employeeDataGridSource.buildDataGridRow();
                        })
                  ],
                ),
              ],
            ),
          ),
        );
    }
    return null;
  }
}
