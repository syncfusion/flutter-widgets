import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';

///  Creates the  class for RowHeightCustomization sample
// ignore: must_be_immutable
class RowHeightCustomizationSample extends StatelessWidget {
  /// Creates the  class for  RowHeightCustomization with required details.
  RowHeightCustomizationSample(this.sampleName, {this.textDirection = 'ltr'});

  /// sample name
  String sampleName;

  /// text direction
  String textDirection;

  /// To do
  final DataGridController _controller = DataGridController();

  final ColumnSizer _columnSizer = ColumnSizer();

  ///To do
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
                final Widget child = _buildDataGrid(sampleName, setState)!;
                if (sampleName == 'row_height_inside_view') {
                  return SizedBox(height: 400.0, child: child);
                }
                return child;
              },
            ),
          )),
    );
  }

  SfDataGrid? _buildDataGrid(String sample, dynamic setState) {
    switch (sample) {
      case 'query_row_height':
        return SfDataGrid(
          columns: columns,
          source: employeeDataGridSource,
          onQueryRowHeight: (RowHeightDetails rowHeightDetails) {
            return rowHeightDetails.rowHeight == 0 ? 200 : 100;
          },
        );
      case 'row_height_getIntrinsicRowHeight':
        return SfDataGrid(
          columns: columns,
          source: employeeDataGridSource,
          onQueryRowHeight: (RowHeightDetails rowHeightDetails) {
            return rowHeightDetails
                .getIntrinsicRowHeight(rowHeightDetails.rowIndex);
          },
        );
      case 'refresh_specific_row':
        return SfDataGrid(
          columns: columns,
          source: employeeDataGridSource,
          columnSizer: _columnSizer,
          controller: _controller,
          footerFrozenRowsCount: 1,
          onQueryRowHeight: (RowHeightDetails rowHeightDetails) {
            return rowHeightDetails
                .getIntrinsicRowHeight(rowHeightDetails.rowIndex);
          },
          footerHeight: 70,
          footer: TextButton(
              child: const Text('Update Cell'),
              onPressed: () {
                employeeDataGridSource.employees[1].name = 'Maria Anders';
                employeeDataGridSource.employees[1].designation =
                    'Sales Representative';
                employeeDataGridSource.employees[1].salary = 25000;
                _controller.refreshRow(1, recalculateRowHeight: true);
                employeeDataGridSource.buildDataGridRow();
                employeeDataGridSource.updateDataGridDataSource();
              }),
        );
      case 'row_height_with_stacked_header':
        return SfDataGrid(
          columns: columns,
          source: employeeDataGridSource,
          stackedHeaderRows: <StackedHeaderRow>[
            StackedHeaderRow(cells: <StackedHeaderCell>[
              StackedHeaderCell(
                  columnNames: <String>['id', 'name'],
                  child: const Text('EmployeeInfo'))
            ]),
            StackedHeaderRow(cells: <StackedHeaderCell>[
              StackedHeaderCell(
                  columnNames: <String>['salary', 'designation'],
                  child: const Text('Employees Details'))
            ]),
          ],
          onQueryRowHeight: (RowHeightDetails rowHeightDetails) {
            return rowHeightDetails.rowHeight == 0 ? 300 : 49;
          },
        );
      case 'row_height_hidden_columns':
        return SfDataGrid(
          columns: <GridColumn>[
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
          ],
          source: employeeDataGridSource,
          onQueryRowHeight: (RowHeightDetails rowHeightDetails) {
            return rowHeightDetails.getIntrinsicRowHeight(
                rowHeightDetails.rowIndex,
                canIncludeHiddenColumns: true);
          },
        );
      case 'row_height_inside_view':
        // To load minimum rows to the view.
        employeeDataGridSource.dataGridRows
            .removeRange(2, employeeDataGridSource.dataGridRows.length);

        return SfDataGrid(
          columns: columns,
          source: employeeDataGridSource,
          columnSizer: _columnSizer,
          controller: _controller,
          onQueryRowHeight: (RowHeightDetails rowHeightDetails) => 150.0,
          footerHeight: 50,
          footer: const Center(child: Text('Remove rows')),
        );
    }
    return null;
  }
}
