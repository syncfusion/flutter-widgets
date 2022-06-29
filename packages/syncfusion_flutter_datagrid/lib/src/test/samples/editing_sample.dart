import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';

///  Creates the  class for editing sample
// ignore: must_be_immutable
class EditingSample extends StatelessWidget {
  /// Creates the  class for editing with required details.
  EditingSample(this.sampleName, {this.textDirection = 'ltr'});

  /// sample name
  final String sampleName;

  /// text direction
  String textDirection;

  final DataGridController _dataGridController = DataGridController();

  /// checks whether the editing should be enabled or not in the `SfDataGrid`.
  bool allowEditing = true;

  /// Defines the default width of all the columns.
  double defaultColumnWidth = 90;

  ///Editing geture type
  EditingGestureType editingGestureType = EditingGestureType.doubleTap;

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
                textDirection == 'ltr' ? TextDirection.ltr : TextDirection.ltr,
            child: StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return SizedBox(
                    width: 500, child: _buildDataGrid(sampleName, setState));
              },
            ),
          )),
    );
  }

  SfDataGrid? _buildDataGrid(String sample, dynamic setState) {
    switch (sample) {
      case 'default':
        return SfDataGrid(
          source: EditingDataGridSource(),
          allowEditing: true,
          allowSorting: true,
          selectionMode: SelectionMode.single,
          navigationMode: GridNavigationMode.cell,
          controller: _dataGridController,
          editingGestureType: editingGestureType,
          footerFrozenRowsCount: 1,
          columns: columns,
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
          footerHeight: 150,
          footer: SizedBox(
            width: 200,
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    MaterialButton(
                        onPressed: () {
                          _dataGridController.endEdit();
                        },
                        child: const Text('End Edit')),
                    MaterialButton(
                        child: const Text('Add column'),
                        onPressed: () {
                          columns.insert(
                            0,
                            GridColumn(
                                columnName: 'id',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      'ID',
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                          );
                          setState(() {});
                        }),
                  ],
                ),
                Column(
                  children: <Widget>[
                    MaterialButton(
                        child: const Text('Programmatic Editing'),
                        onPressed: () {
                          _dataGridController.beginEdit(RowColumnIndex(2, 0));
                        }),
                    MaterialButton(
                        child: const Text('Remove column'),
                        onPressed: () {
                          columns.removeAt(0);
                          setState(() {});
                        }),
                    MaterialButton(
                        child: const Text('Gesture Type'),
                        onPressed: () {
                          editingGestureType = EditingGestureType.tap;
                          setState(() {});
                        }),
                  ],
                ),
              ],
            ),
          ),
        );
      case 'freezePane':
        return SfDataGrid(
            source: EditingDataGridSource(),
            allowEditing: allowEditing,
            selectionMode: SelectionMode.single,
            navigationMode: GridNavigationMode.cell,
            controller: _dataGridController,
            frozenRowsCount: 1,
            editingGestureType: EditingGestureType.tap,
            frozenColumnsCount: 1,
            defaultColumnWidth: defaultColumnWidth,
            columns: columns,
            footerFrozenRowsCount: 1,
            footerHeight: 100,
            footer: SizedBox(
              width: 100,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    child: MaterialButton(
                        child: const Text('Restricted Column'),
                        onPressed: () {
                          allowEditing = false;
                          setState(() {});
                        }),
                  ),
                  SizedBox(
                    width: 50,
                    child: MaterialButton(
                        child: const Text('Update Column Width'),
                        onPressed: () {
                          defaultColumnWidth = 200;
                          setState(() {});
                        }),
                  ),
                ],
              ),
            ));
    }
    return null;
  }
}

// ignore: public_member_api_docs
class EditingDataGridSource extends EmployeeDataGridSource {
  // ignore: public_member_api_docs, empty_constructor_bodies
  EditingDataGridSource() : super(employeesData: populateData());

  /// Helps to hold the new value of all editable widget.
  /// Based on the new value we will commit the new value into the corresponding
  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    if (column.columnName == 'id') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'id', value: newCellValue);
      employees[dataRowIndex].id = newCellValue as int;
    } else if (column.columnName == 'name') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'name', value: newCellValue);
      employees[dataRowIndex].name = newCellValue.toString();
    } else if (column.columnName == 'designation') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'designation', value: newCellValue);
      employees[dataRowIndex].designation = newCellValue.toString();
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'salary', value: newCellValue);
      employees[dataRowIndex].salary = newCellValue as int;
    }
  }

  @override
  bool canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    if (rowColumnIndex.equals(RowColumnIndex(2, 1))) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value
            ?.toString() ??
        '';

    newCellValue = null;

    final bool isNumericType =
        column.columnName == 'id' || column.columnName == 'salary';

    // Holds regular expression pattern based on the column type.
    final RegExp regExp = _getRegExp(isNumericType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        key: const Key('textField'),
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp)
        ],
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          submitCell();
        },
      ),
    );
  }

  @override
  bool onCellBeginEdit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    if (rowColumnIndex.equals(RowColumnIndex(2, 0)) ||
        (dataGridRow.getCells()[0].value == 10002 &&
            rowColumnIndex.equals(RowColumnIndex(1, 0)))) {
      return false;
    } else {
      return true;
    }
  }

  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    return isNumericKeyBoard ? RegExp('[0-9]') : RegExp('[a-zA-Z ]');
  }
}
