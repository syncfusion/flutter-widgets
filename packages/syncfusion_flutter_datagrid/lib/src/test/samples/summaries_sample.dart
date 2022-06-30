import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';
import '../model/employees.dart';

///  Creates the  class for summaries sample
// ignore: must_be_immutable
class SummariesSample extends StatelessWidget {
  /// Creates the  class for sorting with required details.
  SummariesSample(this.sampleName, {this.textDirection = 'ltr'});

  /// sample name
  String sampleName;

  /// To Do
  GridTableSummaryRowPosition gridTableSummaryRowPosition =
      GridTableSummaryRowPosition.top;

  /// text direction
  String textDirection;

  /// To Do
  ColumnSizer columnSizer = ColumnSizer();

  /// To Do
  SummariesDataGridSource summaryDataGridSource = SummariesDataGridSource();

  ///To Do
  GridSummaryType summaryType = GridSummaryType.sum;

  /// To Do
  List<GridTableSummaryRow> tableSummaryRows = <GridTableSummaryRow>[];

  /// To Do
  bool isColumnsEmpty = false;

  /// To Do
  bool visible = true;

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
                return _buildDataGrid(sampleName, setState)!;
              },
            ),
          )),
    );
  }

  SfDataGrid? _buildDataGrid(String sample, dynamic setState) {
    switch (sample) {
      case 'top_position':
        return SfDataGrid(
          source: summaryDataGridSource,
          footerFrozenRowsCount: 1,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                showSummaryInRow: false,
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: gridTableSummaryRowPosition),
          ],
          columns: columns,
          footer: TextButton(
              onPressed: () {
                gridTableSummaryRowPosition =
                    GridTableSummaryRowPosition.bottom;
                setState(() {});
              },
              child: const Text('Bottom Position')),
        );
      case 'both_position':
        return SfDataGrid(
          source: summaryDataGridSource,
          footerFrozenRowsCount: 1,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                showSummaryInRow: false,
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
            GridTableSummaryRow(
                showSummaryInRow: false,
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Average',
                      columnName: 'salary',
                      summaryType: GridSummaryType.average)
                ],
                position: GridTableSummaryRowPosition.bottom)
          ],
          columns: columns,
        );
      case 'add_summary_row':
        return SfDataGrid(
          source: summaryDataGridSource,
          footerFrozenRowsCount: 1,
          tableSummaryRows: tableSummaryRows,
          columns: columns,
          footer: TextButton(
              onPressed: () {
                tableSummaryRows = <GridTableSummaryRow>[
                  GridTableSummaryRow(
                      showSummaryInRow: false,
                      columns: <GridSummaryColumn>[
                        const GridSummaryColumn(
                            name: 'Sum',
                            columnName: 'salary',
                            summaryType: GridSummaryType.sum)
                      ],
                      position: GridTableSummaryRowPosition.top),
                ];
                setState(() {});
              },
              child: const Text('summary row at run time')),
        );
      case 'empty_title':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: '',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
        );

      case 'swiping':
        return SfDataGrid(
          source: summaryDataGridSource,
          allowSwiping: true,
          startSwipeActionsBuilder:
              (BuildContext context, DataGridRow row, int rowIndex) {
            return MaterialButton(
                onPressed: () {
                  summaryDataGridSource._employees[rowIndex].salary = 5000;
                  summaryDataGridSource.buildDataGridRow();
                  summaryDataGridSource.updateDataGridDataSource();
                },
                child: const Text('Update cell value'));
          },
          endSwipeActionsBuilder:
              (BuildContext context, DataGridRow row, int rowIndex) {
            return MaterialButton(
                onPressed: () {
                  summaryDataGridSource._employees.removeAt(rowIndex - 2);
                  summaryDataGridSource.buildDataGridRow();
                  summaryDataGridSource.updateDataGridDataSource();
                },
                child: const Text('Delete Row'));
          },
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: '{Sum}',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
        );
      case 'grid_summary_type_count':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: '{Count}',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Count',
                      columnName: 'salary',
                      summaryType: GridSummaryType.count)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
        );
      case 'grid_summary_type_minimum':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: '{Minimum}',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Minimum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.minimum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
        );

      case 'grid_summary_type_maximum':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: '{Maximum}',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Maximum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.maximum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
        );
      case 'empty_rows':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum),
                ],
                position: GridTableSummaryRowPosition.top),
            GridTableSummaryRow(
                showSummaryInRow: false,
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Average',
                      columnName: 'salary',
                      summaryType: GridSummaryType.average)
                ],
                position: GridTableSummaryRowPosition.bottom)
          ],
          columns: columns,
          footerFrozenRowsCount: 1,
          footer: TextButton(
              onPressed: () {
                summaryDataGridSource.dataGridRows = <DataGridRow>[];
                summaryDataGridSource.buildDataGridRow();
                summaryDataGridSource.updateDataGridDataSource();
              },
              child: const Text('Empty Rows')),
        );
      case 'row_manipulation':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
          footerFrozenRowsCount: 1,
          footer: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        summaryDataGridSource._employees.insert(
                            1, Employees(10002, 'Kathryn', 'Manager', 30000));
                        summaryDataGridSource.buildDataGridRow();
                        summaryDataGridSource.updateDataGridDataSource();
                      },
                      child: const Text('Add')),
                  TextButton(
                      onPressed: () {
                        summaryDataGridSource._employees.removeAt(1);
                        summaryDataGridSource.buildDataGridRow();
                        summaryDataGridSource.updateDataGridDataSource();
                      },
                      child: const Text('Remove')),
                  TextButton(
                      onPressed: () {
                        summaryDataGridSource._employees[1].salary = 20000;
                        summaryDataGridSource.buildDataGridRow();
                        summaryDataGridSource.updateDataGridDataSource();
                      },
                      child: const Text('Update'))
                ],
              ),
            ],
          ),
        );
      case 'summary_with_wrong_mappingname':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'price',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
        );
      case 'summary_with_row_height_customization':
        return SfDataGrid(
          source: summaryDataGridSource,
          onQueryRowHeight: (RowHeightDetails details) {
            return details.getIntrinsicRowHeight(details.rowIndex);
          },
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: '{Sum}',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
        );
      case 'summary_with_columns':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: isColumnsEmpty ? <GridColumn>[] : columns,
          footerFrozenRowsCount: 1,
          footer: TextButton(
              onPressed: () {
                isColumnsEmpty = true;
                setState(() {});
              },
              child: const Text('Empty columns')),
        );
      case 'summary_with_stackedHeader':
        return SfDataGrid(
          source: summaryDataGridSource,
          stackedHeaderRows: <StackedHeaderRow>[
            StackedHeaderRow(cells: <StackedHeaderCell>[
              StackedHeaderCell(
                  columnNames: <String>['id', 'name'],
                  child: const Center(child: Text('Employees'))),
              StackedHeaderCell(
                  columnNames: <String>['designation', 'salary'],
                  child: const Center(child: Text('Designation Details')))
            ])
          ],
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
        );
      case 'summary_with_freezePanes':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
          frozenRowsCount: 3,
        );
      case 'summary_with_column_width':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
          defaultColumnWidth: 200,
        );
      case 'summary_with_column_manipulation':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
          footerFrozenRowsCount: 1,
          footer: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        columns.removeLast();
                        summaryDataGridSource.buildDataGridRow();
                        summaryDataGridSource.updateDataGridDataSource();
                        setState(() {});
                      },
                      child: const Text('Remove column')),
                  TextButton(
                      onPressed: () {
                        columns.insert(
                            3,
                            GridColumn(
                                columnName: 'salary',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      'Salary',
                                      overflow: TextOverflow.ellipsis,
                                    ))));
                        summaryDataGridSource.buildDataGridRow();
                        summaryDataGridSource.updateDataGridDataSource();
                        setState(() {});
                      },
                      child: const Text('Add column'))
                ],
              )
            ],
          ),
        );

      case 'summary_with_columns_span':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                showSummaryInRow: false,
                titleColumnSpan: 3,
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
        );
      case 'summary_with_name_column':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'name',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
          columns: columns,
        );
      case 'summary_with_hidden_column':
        return SfDataGrid(
          source: summaryDataGridSource,
          tableSummaryRows: <GridTableSummaryRow>[
            GridTableSummaryRow(
                title: 'Total Price: {Sum} for all employees',
                columns: <GridSummaryColumn>[
                  const GridSummaryColumn(
                      name: 'Sum',
                      columnName: 'salary',
                      summaryType: GridSummaryType.sum)
                ],
                position: GridTableSummaryRowPosition.top),
          ],
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
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Designation',
                      overflow: TextOverflow.ellipsis,
                    ))),
            GridColumn(
                columnName: 'salary',
                visible: visible,
                label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Salary',
                      overflow: TextOverflow.ellipsis,
                    ))),
          ],
          defaultColumnWidth: 200,
          footerFrozenRowsCount: 1,
          footer: TextButton(
              onPressed: () {
                visible = false;
                setState(() {});
              },
              child: const Text('visible')),
        );
    }
    return null;
  }
}

/// create DataGridSource class for summaries
class SummariesDataGridSource extends EmployeeDataGridSource {
  // ignore: public_member_api_docs
  SummariesDataGridSource() : super(employeesData: <Employees>[]);

  final List<Employees> _employees = populateData();

  @override
  void buildDataGridRow() {
    dataGridRows = _employees
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
                        DataGridCell<int>(
                            columnName: 'id', value: dataGridRow.id),
                        DataGridCell<String>(
                            columnName: 'name', value: dataGridRow.name),
                        DataGridCell<String>(
                            columnName: 'designation',
                            value: dataGridRow.designation),
                      ]
                : <DataGridCell>[]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }
}
