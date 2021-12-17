import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'enum.dart';
import 'helper.dart';

/// Signature for `cellExport` callback which is passed as an argument in
/// `exportToExcelWorkbook` and `exportToExcelWorksheet` methods.
typedef DataGridCellExcelExportCallback = void Function(
    DataGridCellExcelExportDetails details);

/// Details for the callback that use [DataGridCellExcelExportDetails].
class DataGridCellExcelExportDetails {
  /// Creates the [DataGridCellExcelExportDetails].
  const DataGridCellExcelExportDetails(
      this.cellValue, this.columnName, this.excelRange, this.cellType);

  /// The value of the cell. Typically, it is [DataGridCell.value].
  final Object? cellValue;

  /// The name of a column.
  final String columnName;

  /// The range in the Excel worksheet.
  final Range excelRange;

  /// The type of the cell.
  final DataGridExportCellType cellType;
}

/// A helper class to export the [SfDataGrid] to Excel.
///
/// Override this class and required methods from this class to perform the
/// customized exporting operation.
class DataGridToExcelConverter {
  /// A row index of [SfDataGrid] which keeps track of the row index
  /// while exporting.
  int excelRowIndex = 1;

  /// A column index of [SfDataGrid] which keeps track of the column index
  /// while exporting.
  int excelColumnIndex = 1;

  /// The start of the column index in Excel. The first column of the SfDataGrid
  ///  will begin at this column index in Excel
  int startColumnIndex = 1;

  /// The start of the row index in Excel. The first row of the SfDataGrid will
  /// begin at this row index in Excel.
  int startRowIndex = 1;

  /// Decides whether the stacked headers should be exported to Excel.
  ///
  /// Defaults to true.
  bool exportStackedHeaders = true;

  /// Decides whether the table summary rows should be exported to Excel.
  ///
  /// Defaults to true.
  bool exportTableSummaries = true;

  /// The default width of the columns in Excel while exporting.
  ///
  /// Defaults to 90.
  double defaultColumnWidth = 90.0;

  /// The default height of the rows in Excel while exporting.
  ///
  /// Defaults to 49.
  double defaultRowHeight = 49.0;

  /// Decides whether the width of the columns in [SfDataGrid] should be
  /// exported same in Excel.
  ///
  /// Defaults to true.
  bool exportColumnWidth = true;

  /// Decides whether the height of the rows in [SfDataGrid] should be
  /// exported same in Excel.
  ///
  /// Defaults to true.
  bool exportRowHeight = true;

  /// Holds the cell export callback function.
  DataGridCellExcelExportCallback? cellExport;

  /// Excludes certain columns to the exporting.
  List<String> excludeColumns = <String>[];

  /// The collection of grid columns that proceeds to export.
  List<GridColumn> get columns => _columns;
  List<GridColumn> _columns = <GridColumn>[];

  /// Exports the column headers to Excel.
  @protected
  void exportColumnHeaders(SfDataGrid dataGrid, Worksheet worksheet) {
    if (columns.isEmpty) {
      return;
    }

    // Resets the column index when creating a new row.
    excelColumnIndex = startColumnIndex;

    _setRowHeight(dataGrid, DataGridExportCellType.columnHeader, worksheet);

    for (final GridColumn column in columns) {
      exportColumnHeader(dataGrid, column, column.columnName, worksheet);
      excelColumnIndex++;
    }
    excelRowIndex++;
  }

  /// Exports a column header to Excel.
  @protected
  void exportColumnHeader(SfDataGrid dataGrid, GridColumn column,
      String columnName, Worksheet worksheet) {
    Range range;
    int rowSpan = 0;

    if (exportStackedHeaders && dataGrid.stackedHeaderRows.isNotEmpty) {
      rowSpan = getRowSpan(
          dataGrid: dataGrid,
          isStackedHeader: false,
          columnName: column.columnName,
          rowIndex: excelRowIndex - startRowIndex - 1,
          columnIndex: dataGrid.columns.indexOf(column));
    }

    if (rowSpan > 0) {
      range = worksheet.getRangeByIndex(excelRowIndex - rowSpan,
          excelColumnIndex, excelRowIndex, excelColumnIndex);
      range.merge();
    } else {
      range = worksheet.getRangeByIndex(excelRowIndex, excelColumnIndex);
    }

    // Align cell content to the center position.
    range.cellStyle
      ..hAlign = HAlignType.center
      ..vAlign = VAlignType.center;

    _exportCellToExcel(worksheet, range, column,
        DataGridExportCellType.columnHeader, columnName);
  }

  /// Exports all the data rows to Excel.
  @protected
  void exportRows(
      SfDataGrid dataGrid, List<DataGridRow> rows, Worksheet worksheet) {
    if (rows.isEmpty) {
      return;
    }

    for (final DataGridRow row in rows) {
      // Resets the column index when creating a new row.
      excelColumnIndex = startColumnIndex;

      _setRowHeight(dataGrid, DataGridExportCellType.row, worksheet);

      for (final GridColumn column in columns) {
        exportRow(dataGrid, row, column, worksheet);
        excelColumnIndex++;
      }
      excelRowIndex++;
    }
  }

  /// Exports a [DataGridRow] to Excel.
  @protected
  void exportRow(SfDataGrid dataGrid, DataGridRow row, GridColumn column,
      Worksheet worksheet) {
    final Object? cellValue = getCellValue(row, column);
    final Range range =
        worksheet.getRangeByIndex(excelRowIndex, excelColumnIndex);
    _exportCellToExcel(
        worksheet, range, column, DataGridExportCellType.row, cellValue);
  }

  /// Exports all the stacked header rows to Excel.
  @protected
  void exportStackedHeaderRows(SfDataGrid dataGrid, Worksheet worksheet) {
    if (dataGrid.stackedHeaderRows.isEmpty) {
      return;
    }

    for (final StackedHeaderRow row in dataGrid.stackedHeaderRows) {
      exportStackedHeaderRow(dataGrid, row, worksheet);
      excelRowIndex++;
    }
  }

  /// Exports a stacked header row to Excel.
  @protected
  void exportStackedHeaderRow(SfDataGrid dataGrid,
      StackedHeaderRow stackedHeaderRow, Worksheet worksheet) {
    _setRowHeight(dataGrid, DataGridExportCellType.stackedHeader, worksheet);

    for (final StackedHeaderCell column in stackedHeaderRow.cells) {
      final List<int> columnSequences =
          getColumnSequences(dataGrid.columns, column);
      for (final List<int> indexes in getConsecutiveRanges(columnSequences)) {
        final int columnIndex = indexes.reduce(min);
        final int columnSpan = indexes.length - 1;
        final int rowSpan = getRowSpan(
            dataGrid: dataGrid,
            isStackedHeader: true,
            columnIndex: columnIndex,
            stackedHeaderCell: column,
            rowIndex: excelRowIndex - startRowIndex - 1);

        _exportStackedHeaderCell(
            dataGrid, column, columnIndex, columnSpan, rowSpan, worksheet);
      }
    }
  }

  /// Export table summary rows to the Excel.
  @protected
  void exportTableSummaryRows(SfDataGrid dataGrid,
      GridTableSummaryRowPosition position, Worksheet worksheet) {
    if (dataGrid.tableSummaryRows.isEmpty) {
      return;
    }

    final List<GridTableSummaryRow> summaryRows = dataGrid.tableSummaryRows
        .where((GridTableSummaryRow row) => row.position == position)
        .toList();

    if (summaryRows.isEmpty) {
      return;
    }

    for (final GridTableSummaryRow summaryRow in summaryRows) {
      exportTableSummaryRow(dataGrid, summaryRow, worksheet);
      excelRowIndex++;
    }
  }

  /// Export table summary row to the Excel.
  @protected
  void exportTableSummaryRow(SfDataGrid dataGrid,
      GridTableSummaryRow summaryRow, Worksheet worksheet) {
    // Resets the column index when creating a new row.
    excelColumnIndex = startColumnIndex;

    _setRowHeight(dataGrid, DataGridExportCellType.tableSummaryRow, worksheet);

    if (summaryRow.showSummaryInRow) {
      _exportTableSummaryCell(
          sheet: worksheet,
          dataGrid: dataGrid,
          summaryRow: summaryRow,
          columnSpan: columns.length);
    } else {
      int titleColumnCount = summaryRow.titleColumnSpan;
      if (titleColumnCount > 0) {
        // To consider the exclude columns in the `titleColumnCount`.
        titleColumnCount =
            getTitleColumnCount(summaryRow, dataGrid.columns, excludeColumns);

        if (titleColumnCount > 0) {
          _exportTableSummaryCell(
              sheet: worksheet,
              dataGrid: dataGrid,
              summaryRow: summaryRow,
              columnSpan: titleColumnCount);
        }
      }

      for (final GridSummaryColumn summaryColumn in summaryRow.columns) {
        final GridColumn? column = dataGrid.columns.firstWhereOrNull(
            (GridColumn element) =>
                element.columnName == summaryColumn.columnName);
        final int columnIndex = getSummaryColumnIndex(
            dataGrid.columns, summaryColumn.columnName, excludeColumns);

        // Restricts if the column doesn't exist or its column index is less
        // than the `titleColumnCount`. because the `titleColumn` summary cell
        // has already exported.
        if (columnIndex < 0 ||
            (excelColumnIndex + columnIndex) <
                (excelColumnIndex + titleColumnCount)) {
          continue;
        }

        _exportTableSummaryCell(
            column: column,
            sheet: worksheet,
            dataGrid: dataGrid,
            summaryRow: summaryRow,
            columnIndex: columnIndex,
            summaryColumn: summaryColumn);
      }
    }
  }

  /// Gets the cell value required for data rows.
  @protected
  Object? getCellValue(DataGridRow row, GridColumn column) {
    final DataGridCell cellValue = row.getCells().firstWhereOrNull(
        (DataGridCell cell) => cell.columnName == column.columnName)!;
    return cellValue.value;
  }

  /// Exports the [SfDataGrid] to Excel [Worksheet].
  void exportToExcelWorksheet(
      SfDataGrid dataGrid, List<DataGridRow>? rows, Worksheet worksheet) {
    _columns = dataGrid.columns
        .where(
            (GridColumn column) => !excludeColumns.contains(column.columnName))
        .toList();

    // Return if all the columns are `excludeColumns`.
    if (columns.isEmpty) {
      return;
    }

    rows ??= dataGrid.source.effectiveRows;

    _setColumnWidths(exportColumnWidth, worksheet, defaultColumnWidth);

    if (exportStackedHeaders) {
      // Exports the stacked header rows.
      exportStackedHeaderRows(dataGrid, worksheet);
    }

    // Exports the column header row.
    exportColumnHeaders(dataGrid, worksheet);

    // Exports the top table summary rows.
    if (exportTableSummaries) {
      exportTableSummaryRows(
          dataGrid, GridTableSummaryRowPosition.top, worksheet);
    }

    // Exports the data rows.
    exportRows(dataGrid, rows, worksheet);

    // Exports the bottom table summary rows.
    if (exportTableSummaries) {
      exportTableSummaryRows(
          dataGrid, GridTableSummaryRowPosition.bottom, worksheet);
    }
  }

  /// Exports the [SfDataGrid] to Excel [Workbook].
  Workbook exportToExcelWorkbook(SfDataGrid dataGrid, List<DataGridRow>? rows) {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    exportToExcelWorksheet(dataGrid, rows, sheet);
    return workbook;
  }

  void _exportCellToExcel(Worksheet sheet, Range range, GridColumn column,
      DataGridExportCellType cellType, Object? cellValue) {
    range.setValue(cellValue);
    if (cellExport != null) {
      final DataGridCellExcelExportDetails details =
          DataGridCellExcelExportDetails(
              cellValue, column.columnName, range, cellType);
      cellExport!(details);
    }
  }

  void _exportStackedHeaderCell(SfDataGrid dataGrid, StackedHeaderCell column,
      int columnIndex, int columnSpan, int rowSpan, Worksheet sheet) {
    Range range;
    int firstColumnIndex = startColumnIndex + columnIndex;
    int lastColumnIndex = firstColumnIndex + columnSpan;

    if (excludeColumns.isNotEmpty) {
      final List<int> startAndEndIndex = getSpannedCellStartAndEndIndex(
          columnSpan: columnSpan,
          columnIndex: columnIndex,
          columns: dataGrid.columns,
          excludeColumns: excludeColumns,
          startColumnIndex: startColumnIndex);

      firstColumnIndex = startAndEndIndex[0];
      lastColumnIndex = startAndEndIndex[1];
    }

    if (firstColumnIndex <= lastColumnIndex) {
      excelColumnIndex = firstColumnIndex;
      if (rowSpan > 0 || lastColumnIndex > firstColumnIndex) {
        range = sheet.getRangeByIndex(excelRowIndex - rowSpan, firstColumnIndex,
            excelRowIndex, lastColumnIndex);
        range.merge();
      } else {
        range = sheet.getRangeByIndex(excelRowIndex, firstColumnIndex);
      }

      // Align cell content to the center position.
      range.cellStyle
        ..hAlign = HAlignType.center
        ..vAlign = VAlignType.center;

      _exportCellToExcel(sheet, range, dataGrid.columns[columnIndex],
          DataGridExportCellType.stackedHeader, column.text);
    }
  }

  void _exportTableSummaryCell(
      {int columnSpan = 0,
      int columnIndex = 0,
      GridColumn? column,
      required Worksheet sheet,
      required SfDataGrid dataGrid,
      GridSummaryColumn? summaryColumn,
      required GridTableSummaryRow summaryRow}) {
    Range range;
    final GridColumn? column = dataGrid.columns.firstWhereOrNull(
        (GridColumn column) => column.columnName == summaryColumn?.columnName);
    final RowColumnIndex rowColumnIndex = RowColumnIndex(
        excelRowIndex - startRowIndex,
        column != null ? dataGrid.columns.indexOf(column) : 0);
    final String summaryValue = dataGrid.source.calculateSummaryValue(
        summaryRow, summaryColumn ?? summaryRow.columns.first, rowColumnIndex);

    columnIndex += startColumnIndex;
    excelColumnIndex = columnIndex;

    if (columnSpan > 0) {
      range = sheet.getRangeByIndex(excelRowIndex, excelColumnIndex,
          excelRowIndex, excelColumnIndex + columnSpan - 1);
      range.merge();
    } else {
      range = sheet.getRangeByIndex(excelRowIndex, excelColumnIndex);
    }

    _exportCellToExcel(sheet, range, column ?? dataGrid.columns[0],
        DataGridExportCellType.tableSummaryRow, summaryValue);
  }

  void _setColumnWidths(
      bool exportColumnWidth, Worksheet sheet, double columnWidth) {
    excelColumnIndex = startColumnIndex;
    for (final GridColumn column in columns) {
      if (exportColumnWidth && !column.actualWidth.isNaN) {
        columnWidth = column.actualWidth;
      }

      sheet.setColumnWidthInPixels(excelColumnIndex, columnWidth.toInt());
      excelColumnIndex++;
    }
  }

  void _setRowHeight(
      SfDataGrid dataGrid, DataGridExportCellType cellType, Worksheet sheet) {
    if (exportRowHeight) {
      switch (cellType) {
        case DataGridExportCellType.columnHeader:
        case DataGridExportCellType.stackedHeader:
          final double height =
              dataGrid.headerRowHeight.isNaN ? 56.0 : dataGrid.headerRowHeight;
          sheet.setRowHeightInPixels(excelRowIndex, height);
          break;
        case DataGridExportCellType.row:
        case DataGridExportCellType.tableSummaryRow:
          final double height =
              dataGrid.rowHeight.isNaN ? 49.0 : dataGrid.rowHeight;
          sheet.setRowHeightInPixels(excelRowIndex, height);
          break;
      }
    } else {
      sheet.setRowHeightInPixels(excelRowIndex, defaultRowHeight);
    }
  }
}

/// Provides the extension methods for the [SfDataGridState] to export the
/// [SfDataGrid] to Excel.
extension DataGridExcelExportExtensions on SfDataGridState {
  // Initializes the properties to the converter.
  void _initializeProperties(DataGridToExcelConverter converter,
      {required int excelStartRowIndex,
      required int excelStartColumnIndex,
      required bool canExportStackedHeaders,
      required bool canExportTableSummaries,
      required bool canExportColumnWidth,
      required bool canExportRowHeight,
      required int columnWidth,
      required int rowHeight,
      required List<String> excludeColumns,
      DataGridCellExcelExportCallback? cellExport}) {
    converter
      ..defaultColumnWidth = columnWidth.toDouble()
      ..defaultRowHeight = rowHeight.toDouble()
      ..excelRowIndex = excelStartRowIndex
      ..startRowIndex = excelStartRowIndex
      ..excelColumnIndex = excelStartColumnIndex
      ..startColumnIndex = excelStartColumnIndex
      ..exportStackedHeaders = canExportStackedHeaders
      ..exportTableSummaries = canExportTableSummaries
      ..exportColumnWidth = canExportColumnWidth
      ..exportRowHeight = canExportRowHeight
      ..excludeColumns = excludeColumns
      ..cellExport = cellExport;
  }

  /// Exports the `SfDataGrid` to the given `Worksheet`.
  ///
  /// Use the `cellExport` argument as the callback, and it will be called for
  /// each cell. You can customize the cell in an Excel sheet.
  ///
  /// Use `defaultColumnWidth` and `defaultRowHeight` arguments to set the default
  /// column width and row height in Excel while exporting.
  ///
  /// Define the start of the row and column index in Excel sheet where DataGrid
  /// content should be started using `startRowIndex` and `startColumnIndex`.
  ///
  /// ```dart
  /// final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  ///
  /// Future<void> exportDataGridToExcel() async {
  ///   final Workbook workbook = Workbook();
  ///   final Worksheet worksheet = workbook.worksheets[0];
  ///   _key.currentState!.exportToExcelWorksheet(worksheet);
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('DataGrid.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text(
  ///         'Syncfusion Flutter DataGrid Export',
  ///         overflow: TextOverflow.ellipsis,
  ///       ),
  ///     ),
  ///     body: Column(
  ///       children: <Widget>[
  ///         Container(
  ///           margin: const EdgeInsets.all(12.0),
  ///           child: const SizedBox(
  ///               height: 40.0,
  ///               width: 150.0,
  ///               child: MaterialButton(
  ///                   color: Colors.blue,
  ///                   child: Center(
  ///                       child: Text(
  ///                     'Export to Excel',
  ///                     style: TextStyle(color: Colors.white),
  ///                   )),
  ///                   onPressed: exportDataGridToExcel)),
  ///         ),
  ///         Expanded(
  ///           child: SfDataGrid(
  ///             key: _key,
  ///             source: employeeDataSource,
  ///             columns: <GridColumn>[
  ///               GridColumn(
  ///                   columnName: 'ID',
  ///                   label: Container(
  ///                       padding: const EdgeInsets.all(16.0),
  ///                       alignment: Alignment.center,
  ///                       child: const Text(
  ///                         'ID',
  ///                       ))),
  ///               GridColumn(
  ///                   columnName: 'Name',
  ///                   label: Container(
  ///                       padding: const EdgeInsets.all(8.0),
  ///                       alignment: Alignment.center,
  ///                       child: const Text('Name'))),
  ///               GridColumn(
  ///                   columnName: 'Designation',
  ///                   label: Container(
  ///                       padding: const EdgeInsets.all(8.0),
  ///                       alignment: Alignment.center,
  ///                       child: const Text(
  ///                         'Designation',
  ///                         overflow: TextOverflow.ellipsis,
  ///                       ))),
  ///               GridColumn(
  ///                   columnName: 'Salary',
  ///                   label: Container(
  ///                       padding: const EdgeInsets.all(8.0),
  ///                       alignment: Alignment.center,
  ///                       child: const Text('Salary'))),
  ///             ],
  ///           ),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  void exportToExcelWorksheet(Worksheet worksheet,
      {List<DataGridRow>? rows,
      bool exportStackedHeaders = true,
      bool exportTableSummaries = true,
      int defaultColumnWidth = 90,
      int defaultRowHeight = 49,
      bool exportColumnWidth = true,
      bool exportRowHeight = true,
      int startColumnIndex = 1,
      int startRowIndex = 1,
      List<String> excludeColumns = const <String>[],
      DataGridToExcelConverter? converter,
      DataGridCellExcelExportCallback? cellExport}) {
    converter ??= DataGridToExcelConverter();

    _initializeProperties(
      converter,
      cellExport: cellExport,
      rowHeight: defaultRowHeight,
      columnWidth: defaultColumnWidth,
      excludeColumns: excludeColumns,
      excelStartRowIndex: startRowIndex,
      excelStartColumnIndex: startColumnIndex,
      canExportRowHeight: exportRowHeight,
      canExportColumnWidth: exportColumnWidth,
      canExportTableSummaries: exportTableSummaries,
      canExportStackedHeaders: exportStackedHeaders,
    );

    converter.exportToExcelWorksheet(widget, rows, worksheet);
  }

  /// Exports the `SfDataGrid` to Excel `Workbook`.
  ///
  /// If the `rows` is set, the given list of DataGridRow collections is exported.
  /// Typically, you can set this property to export the selected rows from
  /// `SfDataGrid`.
  ///
  /// Use `cellExport` argument as the callback, and it will be called for
  /// each cell. You can customize the cell in the Excel sheet.
  ///
  /// Set the customized Excel converter using the `converter` argument.
  /// To customize the default Excel converter, override the
  /// `DataGridToExcelConverter` class and override the necessary methods.
  ///
  /// Use `defaultColumnWidth` and `defaultRowHeight` arguments to set the
  /// default column width and row height in Excel while exporting.
  ///
  /// Define the start of the row and column index in the Excel sheet where DataGrid
  /// content should be started using `startRowIndex` and `startColumnIndex`.
  ///
  /// The following example shows how to export the SfDataGrid to the Excel workbook.
  ///
  /// ```dart
  /// final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  ///
  /// Future<void> exportDataGridToExcel() async {
  ///   final Workbook workbook = _key.currentState!.exportToExcelWorkbook();
  ///   final List<int> bytes = workbook.saveAsStream();
  ///   File('DataGrid.xlsx').writeAsBytes(bytes);
  ///   workbook.dispose();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: const Text(
  ///         'Syncfusion Flutter DataGrid Export',
  ///         overflow: TextOverflow.ellipsis,
  ///       ),
  ///     ),
  ///     body: Column(
  ///       children: <Widget>[
  ///         Container(
  ///           margin: const EdgeInsets.all(12.0),
  ///           child: const SizedBox(
  ///             height: 40.0,
  ///             width: 150.0,
  ///             child: MaterialButton(
  ///                 color: Colors.blue,
  ///                 child: Center(
  ///                     child: Text(
  ///                   'Export to Excel',
  ///                   style: TextStyle(color: Colors.white),
  ///                 )),
  ///                 onPressed: exportDataGridToExcel),
  ///           ),
  ///         ),
  ///         Expanded(
  ///           child: SfDataGrid(
  ///             key: _key,
  ///             source: employeeDataSource,
  ///             columns: <GridColumn>[
  ///               GridColumn(
  ///                   columnName: 'ID',
  ///                   label: Container(
  ///                       padding: const EdgeInsets.all(16.0),
  ///                       alignment: Alignment.center,
  ///                       child: const Text(
  ///                         'ID',
  ///                       ))),
  ///               GridColumn(
  ///                   columnName: 'Name',
  ///                   label: Container(
  ///                       padding: const EdgeInsets.all(8.0),
  ///                       alignment: Alignment.center,
  ///                       child: const Text('Name'))),
  ///               GridColumn(
  ///                   columnName: 'Designation',
  ///                   label: Container(
  ///                       padding: const EdgeInsets.all(8.0),
  ///                       alignment: Alignment.center,
  ///                       child: const Text(
  ///                         'Designation',
  ///                         overflow: TextOverflow.ellipsis,
  ///                       ))),
  ///               GridColumn(
  ///                   columnName: 'Salary',
  ///                   label: Container(
  ///                       padding: const EdgeInsets.all(8.0),
  ///                       alignment: Alignment.center,
  ///                       child: const Text('Salary'))),
  ///             ],
  ///           ),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  Workbook exportToExcelWorkbook(
      {List<DataGridRow>? rows,
      bool exportStackedHeaders = true,
      bool exportTableSummaries = true,
      int defaultColumnWidth = 90,
      int defaultRowHeight = 49,
      bool exportRowHeight = true,
      bool exportColumnWidth = true,
      int startColumnIndex = 1,
      int startRowIndex = 1,
      List<String> excludeColumns = const <String>[],
      DataGridToExcelConverter? converter,
      DataGridCellExcelExportCallback? cellExport}) {
    converter ??= DataGridToExcelConverter();

    _initializeProperties(
      converter,
      cellExport: cellExport,
      rowHeight: defaultRowHeight,
      columnWidth: defaultColumnWidth,
      excludeColumns: excludeColumns,
      excelStartRowIndex: startRowIndex,
      excelStartColumnIndex: startColumnIndex,
      canExportRowHeight: exportRowHeight,
      canExportColumnWidth: exportColumnWidth,
      canExportTableSummaries: exportTableSummaries,
      canExportStackedHeaders: exportStackedHeaders,
    );

    return converter.exportToExcelWorkbook(widget, rows);
  }
}
