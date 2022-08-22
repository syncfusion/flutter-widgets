import 'package:flutter/material.dart';
import '../../../datagrid.dart';
import '../data_source/employee_datagrid_source.dart';
import 'basic_datagrid_sample.dart';

/// Creates the  class for programmatic scrolling sample
// ignore: must_be_immutable
class ProgrammaticScrollingSample extends StatefulWidget {
  /// Creates the  class for programmatic scrolling sample with required details.
  ProgrammaticScrollingSample(this.sampleName, {this.textDirection = 'ltr'});

  /// sample name
  String sampleName;

  /// text direction
  String textDirection;

  @override
  ProgrammaticScrollingSampleState createState() =>
      ProgrammaticScrollingSampleState();
}

/// Creates the  class for programmatic scrolling state class
// ignore: must_be_immutable
class ProgrammaticScrollingSampleState
    extends State<ProgrammaticScrollingSample> {
  /// selection mode
  SelectionMode selectionMode = SelectionMode.none;

  /// selection mode
  GridNavigationMode navigationMode = GridNavigationMode.row;

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
              child: _buildDataGrid(widget.sampleName, setState)!)),
    );
  }

  SfDataGrid? _buildDataGrid(String sample, dynamic setState) {
    switch (sample) {
      case 'programmatic_scrolling':
        return SfDataGrid(
          columns: columns,
          source: _employeeDataGridSource,
          defaultColumnWidth: 300,
          controller: controller,
          footerFrozenRowsCount: 1,
          footer: Row(
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  controller.scrollToColumn(3);
                },
                child: const Text('Scroll To Column'),
              ),
              MaterialButton(
                onPressed: () {
                  controller.scrollToRow(15);
                },
                child: const Text('Scroll To Row'),
              )
            ],
          ),
        );
      case 'scroll_to_cell':
        return SfDataGrid(
          columns: columns,
          source: _employeeDataGridSource,
          defaultColumnWidth: 300,
          controller: controller,
          footerFrozenRowsCount: 1,
          footerHeight: 140,
          footer: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      controller.scrollToCell(7, 3);
                    },
                    child: const Text('Scroll to Cell'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      controller.scrollToVerticalOffset(550);
                    },
                    child: const Text('Vertical offset'),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      controller.scrollToHorizontalOffset(300);
                    },
                    child: const Text('Horizontal offset'),
                  )
                ],
              )
            ],
          ),
        );

      case 'scrolling_disabled':
        return SfDataGrid(
            columns: columns,
            source: EmployeeDataGridSource(employeesData: populateData()),
            defaultColumnWidth: 300,
            horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
            verticalScrollPhysics: const NeverScrollableScrollPhysics());
    }
    return null;
  }
}
