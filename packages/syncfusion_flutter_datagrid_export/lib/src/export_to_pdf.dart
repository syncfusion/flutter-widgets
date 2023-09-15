import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'enum.dart';
import 'helper.dart';

/// Exports the [SfDataGrid] to Pdf with the given rows and columns

extension DataGridPdfExportExtensions on SfDataGridState {
  // Initializes the properties to the converter.
  void _initializeProperties(DataGridToPdfConverter converter,
      {required bool canRepeatHeaders,
      required bool exportStackedHeaders,
      required bool fitAllColumnsInOnePage,
      required List<String> excludeColumns,
      required bool autoColumnWidth,
      required bool exportTableSummaries,
      int rowIndex = 0,
      DataGridCellPdfExportCallback? cellExport,
      DataGridPdfHeaderFooterExportCallback? headerFooterExport}) {
    converter
      ..canRepeatHeaders = canRepeatHeaders
      ..exportStackedHeaders = exportStackedHeaders
      ..autoColumnWidth = autoColumnWidth
      ..fitAllColumnsInOnePage = fitAllColumnsInOnePage
      ..cellExport = cellExport
      ..excludeColumns = excludeColumns
      ..headerFooterExport = headerFooterExport
      ..exportTableSummaries = exportTableSummaries
      ..rowIndex = rowIndex;
  }

  /// Exports the `SfDataGrid` to `PdfDocument`.
  ///
  /// If the `rows` is set, the given list of DataGridRow collections is exported.
  /// Typically, you can set this property to export the selected rows from `SfDataGrid`.
  ///
  /// Use `cellExport` argument as the callback, and it will be called for
  /// each cell. You can customize the cell in Pdf document.
  ///
  /// Use `fitAllColumnsInOnePage` argument to fit all the columns in a page.
  ///
  /// Use the `converter` argument to set the customized Pdf converter.
  /// To customize the default Pdf converter, override the `DataGridToPdfConverter`
  /// class and override the necessary methods.
  ///
  /// Use the `headerFooterExport` argument to set the header and footer for each page.
  ///
  /// The following example shows how to export the SfDataGrid to PdfDocument.
  ///
  /// ```dart
  /// final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  ///
  /// Future<void> exportDataGridToPdf() async {
  ///   final PdfDocument document =
  ///       _key.currentState!.exportToPdfDocument(fitAllColumnsInOnePage: true);
  ///   final List<int> bytes = document.save();
  ///   File('DataGrid.pdf').writeAsBytes(bytes);
  ///   document.dispose();
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
  ///                   'Export to PDF',
  ///                   style: TextStyle(color: Colors.white),
  ///                 )),
  ///                 onPressed: exportDataGridToPdf),
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
  PdfDocument exportToPdfDocument(
      {List<DataGridRow>? rows,
      bool exportStackedHeaders = true,
      bool canRepeatHeaders = true,
      bool fitAllColumnsInOnePage = false,
      bool autoColumnWidth = true,
      bool exportTableSummaries = true,
      List<String> excludeColumns = const <String>[],
      DataGridToPdfConverter? converter,
      DataGridCellPdfExportCallback? cellExport,
      DataGridPdfHeaderFooterExportCallback? headerFooterExport}) {
    converter ??= DataGridToPdfConverter();
    _initializeProperties(converter,
        autoColumnWidth: autoColumnWidth,
        fitAllColumnsInOnePage: fitAllColumnsInOnePage,
        canRepeatHeaders: canRepeatHeaders,
        exportStackedHeaders: exportStackedHeaders,
        cellExport: cellExport,
        headerFooterExport: headerFooterExport,
        excludeColumns: excludeColumns,
        exportTableSummaries: exportTableSummaries);

    return converter.exportToPdfDocument(widget, rows);
  }

  /// Exports the `SfDataGrid` to `PdfGrid`.
  ///
  /// If the `rows` is set, the given list of DataGridRow collections is exported.
  /// Typically, you can set this property to export the selected rows from `SfDataGrid`.
  ///
  /// Use the `cellExport` argument as the callback, and it will be called for
  /// each cell. You can customize the cell in Pdf document.
  ///
  /// Use `fitAllColumnsInOnePage` argument to fit all the columns in a page.
  ///
  /// Use the `converter` argument to set the customized Pdf converter.
  /// To customize the default Pdf converter, override the `DataGridToPdfConverter`
  /// class and override the necessary methods.
  ///
  /// The following example shows how to export the SfDataGrid to PdfGrid.
  ///
  /// ```dart
  /// final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  ///
  /// Future<void> exportDataGridToPdf() async {
  ///   final PdfDocument pdfDocument = PdfDocument();
  ///   final PdfGrid pdfGrid =
  ///       _key.currentState!.exportToPdfGrid(fitAllColumnsInOnePage: true);
  ///   pdfGrid.draw(
  ///       page: pdfDocument.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
  ///   final List<int> bytes = pdfDocument.save();
  ///   File('DataGrid.pdf').writeAsBytes(bytes);
  ///   pdfDocument.dispose();
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
  ///                   'Export to PDF',
  ///                   style: TextStyle(color: Colors.white),
  ///                 )),
  ///                 onPressed: exportDataGridToPdf),
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
  PdfGrid exportToPdfGrid(
      {List<DataGridRow>? rows,
      bool exportStackedHeaders = true,
      bool canRepeatHeaders = true,
      bool fitAllColumnsInOnePage = false,
      bool autoColumnWidth = true,
      bool exportTableSummaries = true,
      List<String> excludeColumns = const <String>[],
      DataGridToPdfConverter? converter,
      DataGridCellPdfExportCallback? cellExport}) {
    converter ??= DataGridToPdfConverter();
    _initializeProperties(converter,
        autoColumnWidth: autoColumnWidth,
        fitAllColumnsInOnePage: fitAllColumnsInOnePage,
        canRepeatHeaders: canRepeatHeaders,
        cellExport: cellExport,
        exportStackedHeaders: exportStackedHeaders,
        excludeColumns: excludeColumns,
        exportTableSummaries: exportTableSummaries);

    return converter.exportToPdfGrid(widget, rows);
  }
}

/// A helper class to export the [SfDataGrid] to Pdf.
///
/// Override this class and required methods from this class to perform the customized exporting operation.

class DataGridToPdfConverter {
  /// Decides whether the  headers should be repeated to all pages in the pdf document.
  ///
  /// Defaults to true.
  bool canRepeatHeaders = true;

  /// Decides whether the Stacked headers should be exported in the pdf document.
  ///
  /// Defaults to true.
  bool exportStackedHeaders = true;

  /// Decides whether the all columns should be fit into one page.
  ///
  /// Defaults to false.
  bool fitAllColumnsInOnePage = false;

  /// Decides whether the all columns width should be set auto width(actual width).
  ///
  /// Defaults to true.
  bool autoColumnWidth = true;

  /// A row index of [SfDataGrid] which keeps track of the row index while exporting.
  int rowIndex = 0;

  /// A column index of [SfDataGrid] which keeps track of the column index while exporting.
  int _columnIndex = 0;

  /// Excludes certain columns to the exporting.
  List<String> excludeColumns = <String>[];

  /// The collection of grid columns that proceeds to export.
  List<GridColumn> get columns => _columns;
  List<GridColumn> _columns = <GridColumn>[];

  /// Decides whether the table summary rows should be exported to Excel.
  ///
  /// Defaults to true.
  bool exportTableSummaries = true;

  /// Details for the callback that use [DataGridCellPdfExportDetails]
  DataGridCellPdfExportCallback? cellExport;

  /// Details for the callback that use [DataGridPdfHeaderFooterExportDetails]
  DataGridPdfHeaderFooterExportCallback? headerFooterExport;

  //pdf pen style for draw borders width and color
  final PdfPen _pdfPen = PdfPen(PdfColor(168, 168, 168), width: 0.2);

  /// Exports the column headers to Pdf.
  @protected
  void exportColumnHeaders(
      SfDataGrid dataGrid, List<GridColumn> columns, PdfGrid pdfGrid) {
    if (columns.isEmpty) {
      return;
    }
    _columnIndex = 0;
    for (final GridColumn column in columns) {
      exportColumnHeader(dataGrid, column, column.columnName, pdfGrid);
      _columnIndex++;
    }
  }

  /// Exports a column header to Pdf
  @protected
  void exportColumnHeader(SfDataGrid dataGrid, GridColumn column,
      String columnName, PdfGrid pdfGrid) {
    int rowSpan = 0;
    PdfGridRow columnHeader = pdfGrid.headers[rowIndex];
    PdfGridCell pdfCell = columnHeader.cells[_columnIndex];

    if (dataGrid.stackedHeaderRows.isNotEmpty && exportStackedHeaders) {
      rowSpan = getRowSpan(
          dataGrid: dataGrid,
          isStackedHeader: false,
          columnName: column.columnName,
          rowIndex: rowIndex - 1,
          columnIndex: dataGrid.columns.indexOf(column));
    }
    if (rowSpan > 0) {
      // Retrieve the header cell at the given index by subtracting the number of rows
      // spanned by the previous cells in the same row.
      columnHeader = pdfGrid.headers[rowIndex - rowSpan];
      pdfCell = columnHeader.cells[_columnIndex];
      pdfCell.rowSpan = rowSpan + 1;
      pdfCell.value = columnName;
    } else {
      pdfCell.value = columnName;
    }
    pdfCell.style.borders.all = _pdfPen;
    _exportCellToPdf(
        DataGridExportCellType.columnHeader, pdfCell, columnName, column);
  }

  /// Exports all the data rows to Pdf.
  @protected
  void exportRows(
      List<GridColumn> columns, List<DataGridRow> rows, PdfGrid pdfGrid) {
    for (final DataGridRow row in rows) {
      exportRow(columns, row, pdfGrid);
      rowIndex++;
    }
  }

  /// Exports a [DataGridRow] to Pdf.
  @protected
  void exportRow(List<GridColumn> columns, DataGridRow row, PdfGrid pdfGrid) {
    int cellIndex = 0;
    final PdfGridRow pdfRow = pdfGrid.rows.add();

    for (final GridColumn column in columns) {
      final PdfGridCell pdfCell = pdfRow.cells[cellIndex];
      final Object cellValue = getCellValue(column, row) ?? '';
      pdfCell.value = cellValue.toString();
      pdfCell.style.borders.all = _pdfPen;
      cellIndex++;
      _exportCellToPdf(DataGridExportCellType.row, pdfCell, cellValue, column);
    }
  }

  /// Exports the [SfDataGrid] to [PdfDocument].
  ///
  /// If the `rows` is set, the given list of DataGridRow collection is exported. Typically, you can set this property to export
  PdfDocument exportToPdfDocument(
      SfDataGrid dataGrid, List<DataGridRow>? rows) {
    final PdfDocument pdfDocument = PdfDocument();

    //adding page into pdf document
    final PdfPage pdfPage = pdfDocument.pages.add();

    _exportHeaderFooter(pdfPage, pdfDocument.template);

    //export pdf grid into pdf document
    final PdfGrid pdfGrid = exportToPdfGrid(dataGrid, rows);

    //Draw the pdf grid into pdf document
    pdfGrid.draw(page: pdfPage, bounds: Rect.zero);

    return pdfDocument;
  }

  /// Exports the [SfDataGrid] to [PdfGrid].
  ///
  /// If the `rows` is set, the given list of DataGridRow collection is exported. Typically, you can set this property to export the selected rows from `SfDataGrid`.
  ///
  /// Use `cellExport` argument which is the callback and it will be called for each cell. You can customize the cell in pdf document.

  PdfGrid exportToPdfGrid(SfDataGrid dataGrid, List<DataGridRow>? rows) {
    rows ??= dataGrid.source.effectiveRows;
    final PdfGrid pdfGrid = PdfGrid();
    pdfGrid.style.cellPadding = PdfPaddings(
      left: 3,
      right: 3,
      top: 2,
      bottom: 2,
    );

    //final List<GridColumn> columns = dataGrid.columns;
    _columns = dataGrid.columns
        .where(
            (GridColumn column) => !excludeColumns.contains(column.columnName))
        .toList();

    //if fit all columns in one page is false then horizontal overflow is true and type is next page
    if (!fitAllColumnsInOnePage) {
      pdfGrid.style.allowHorizontalOverflow = true;
      pdfGrid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
    }

    //Get the total number of Column
    final int columnCount = columns.length;

    //to add number of columns in grid column
    pdfGrid.columns.add(count: columnCount);

    //default header count value is 1 (column header)
    int headerCount = 1;

    //get the total column header count value if staked header is true
    if (dataGrid.stackedHeaderRows.isNotEmpty && exportStackedHeaders) {
      headerCount = dataGrid.stackedHeaderRows.length + headerCount;
    }

    //add headers to grid
    pdfGrid.headers.add(headerCount);

    //check if stacked header export or not
    if (dataGrid.stackedHeaderRows.isNotEmpty && exportStackedHeaders) {
      exportStackedHeaderRows(dataGrid, pdfGrid);
    }

    //Export the column headers
    exportColumnHeaders(dataGrid, columns, pdfGrid);

    // Exports the top table summary rows.
    if (exportTableSummaries) {
      exportTableSummaryRows(
          dataGrid, GridTableSummaryRowPosition.top, pdfGrid);
    }

    //Export the rows
    exportRows(columns, rows, pdfGrid);

    // Exports the bottom table summary rows.
    if (exportTableSummaries) {
      exportTableSummaryRows(
          dataGrid, GridTableSummaryRowPosition.bottom, pdfGrid);
    }

    //Can Repeate header for all pages
    pdfGrid.repeatHeader = canRepeatHeaders;

    //if fit all columns in one page is false then auto column width is true
    if (!fitAllColumnsInOnePage && !autoColumnWidth) {
      int columnIndex = 0;
      for (final GridColumn column in columns) {
        pdfGrid.columns[columnIndex].width = column.actualWidth;
        columnIndex++;
      }
    }

    return pdfGrid;
  }

  /// Exports all the stacked header rows to Pdf.
  @protected
  void exportStackedHeaderRows(SfDataGrid dataGrid, PdfGrid pdfGrid) {
    for (final StackedHeaderRow row in dataGrid.stackedHeaderRows) {
      exportStackedHeaderRow(dataGrid, row, pdfGrid);

      rowIndex++;
    }
  }

  /// Exports a stacked header row to Pdf.
  @protected
  void exportStackedHeaderRow(
      SfDataGrid dataGrid, StackedHeaderRow stackedHeaderRow, PdfGrid pdfGrid) {
    for (final StackedHeaderCell column in stackedHeaderRow.cells) {
      int columnSpanValue = 0;
      final List<int> columnSequences =
          getColumnSequences(dataGrid.columns, column);
      for (final List<int> indexes in getConsecutiveRanges(columnSequences)) {
        _columnIndex = indexes.reduce(min);
        columnSpanValue = indexes.length;
        final int rowSpan = getRowSpan(
            dataGrid: dataGrid,
            isStackedHeader: true,
            columnIndex: _columnIndex,
            stackedHeaderCell: column,
            rowIndex: rowIndex - 1);

        _exportStackedHeaderCell(
            dataGrid, column, _columnIndex, columnSpanValue, rowSpan, pdfGrid);
      }
    }
  }

  /// Exports a stacked header cell to Pdf.
  void _exportStackedHeaderCell(SfDataGrid dataGrid, StackedHeaderCell column,
      int columnIndex, int columnSpan, int rowSpan, PdfGrid pdfGrid) {
    PdfGridRow stakedHeaderRow = pdfGrid.headers[rowIndex];

    int firstColumnIndex = columnIndex;
    int lastColumnIndex = firstColumnIndex + columnSpan;

    if (excludeColumns.isNotEmpty) {
      final List<int> startAndEndIndex = getSpannedCellStartAndEndIndex(
          columnSpan: columnSpan - 1,
          columnIndex: columnIndex,
          columns: dataGrid.columns,
          excludeColumns: excludeColumns,
          startColumnIndex: 0);

      firstColumnIndex = startAndEndIndex[0];
      lastColumnIndex = startAndEndIndex[1];
      columnSpan = lastColumnIndex - firstColumnIndex + 1;
    }
    PdfGridCell pdfCell = stakedHeaderRow.cells[firstColumnIndex];
    if (firstColumnIndex <= lastColumnIndex) {
      if (rowSpan > 0) {
        stakedHeaderRow = pdfGrid.headers[rowIndex - rowSpan];
        pdfCell = stakedHeaderRow.cells[firstColumnIndex];
        pdfCell.columnSpan = columnSpan;
        pdfCell.rowSpan = rowSpan + 1;
      } else if (columnSpan >= 0) {
        pdfCell = stakedHeaderRow.cells[firstColumnIndex];
        pdfCell.columnSpan = columnSpan;
      }
      pdfCell.value = column.text ?? '';
    }
    pdfCell.style.borders.all = _pdfPen;

    _exportCellToPdf(DataGridExportCellType.stackedHeader, pdfCell,
        pdfCell.value, dataGrid.columns[firstColumnIndex]);
  }

  /// Gets the cell value required for data rows.
  @protected
  Object? getCellValue(GridColumn column, DataGridRow row) {
    final DataGridCell cellValue = row.getCells().firstWhereOrNull(
        (DataGridCell element) => element.columnName == column.columnName)!;
    return cellValue.value;
  }

  void _exportCellToPdf(
    DataGridExportCellType cellType,
    PdfGridCell pdfCell,
    Object? cellValue,
    GridColumn column,
  ) {
    if (cellExport != null) {
      final DataGridCellPdfExportDetails details = DataGridCellPdfExportDetails(
          cellType, pdfCell, cellValue, column.columnName);
      cellExport!(details);
    }
  }

  void _exportHeaderFooter(
      PdfPage pdfPage, PdfDocumentTemplate pdfDocumentTemplate) {
    if (headerFooterExport != null) {
      final DataGridPdfHeaderFooterExportDetails details =
          DataGridPdfHeaderFooterExportDetails(pdfPage, pdfDocumentTemplate);
      headerFooterExport!(details);
    }
  }

  /// Export table summary rows to the Excel.
  @protected
  void exportTableSummaryRows(SfDataGrid dataGrid,
      GridTableSummaryRowPosition position, PdfGrid pdfGrid) {
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
      exportTableSummaryRow(dataGrid, summaryRow, pdfGrid);

      rowIndex++;
    }
  }

  /// Export table summary row to the Excel.
  @protected
  void exportTableSummaryRow(
      SfDataGrid dataGrid, GridTableSummaryRow summaryRow, PdfGrid pdfGrid) {
    final PdfGridRow tableSummaryRow = pdfGrid.rows.add();
    // Resets the column index when creating a new row.
    _columnIndex = 0;
    if (summaryRow.showSummaryInRow) {
      _exportTableSummaryCell(
          pdfGrid: pdfGrid,
          dataGrid: dataGrid,
          summaryRow: summaryRow,
          columnSpan: columns.length,
          tableSummaryRow: tableSummaryRow);
    } else {
      int titleColumnCount = summaryRow.titleColumnSpan;
      if (titleColumnCount > 0) {
        // To consider the exclude columns in the `titleColumnCount`.
        titleColumnCount =
            getTitleColumnCount(summaryRow, dataGrid.columns, excludeColumns);

        if (titleColumnCount > 0) {
          _exportTableSummaryCell(
              pdfGrid: pdfGrid,
              dataGrid: dataGrid,
              summaryRow: summaryRow,
              columnSpan: titleColumnCount,
              tableSummaryRow: tableSummaryRow);
        }
      }

      for (final GridSummaryColumn summaryColumn in summaryRow.columns) {
        final GridColumn? column = dataGrid.columns.firstWhereOrNull(
            (GridColumn element) =>
                element.columnName == summaryColumn.columnName);
        final int summaryColumnIndex = getSummaryColumnIndex(
            dataGrid.columns, summaryColumn.columnName, excludeColumns);

        // Restricts if the column doesn't exist or its column index is less
        // than the `titleColumnCount`. because the `titleColumn` summary cell
        // has already exported.
        if (summaryColumnIndex < 0 || (summaryColumnIndex < titleColumnCount)) {
          continue;
        }

        _exportTableSummaryCell(
            column: column,
            pdfGrid: pdfGrid,
            dataGrid: dataGrid,
            summaryRow: summaryRow,
            startColumnIndex: summaryColumnIndex,
            summaryColumn: summaryColumn,
            tableSummaryRow: tableSummaryRow);
      }
    }
  }

  void _exportTableSummaryCell(
      {int columnSpan = 0,
      int startColumnIndex = 0,
      GridColumn? column,
      required PdfGrid pdfGrid,
      required SfDataGrid dataGrid,
      GridSummaryColumn? summaryColumn,
      PdfGridRow? tableSummaryRow,
      required GridTableSummaryRow summaryRow}) {
    final GridColumn? column = dataGrid.columns.firstWhereOrNull(
        (GridColumn column) => column.columnName == summaryColumn?.columnName);
    final RowColumnIndex rowColumnIndex = RowColumnIndex(
        rowIndex, column != null ? dataGrid.columns.indexOf(column) : 0);

    final String summaryValue = dataGrid.source.calculateSummaryValue(
        summaryRow, summaryColumn ?? summaryRow.columns.first, rowColumnIndex);

    PdfGridCell pdfCell = tableSummaryRow!.cells[startColumnIndex];
    if (columnSpan > 0) {
      pdfCell = tableSummaryRow.cells[startColumnIndex];
      pdfCell.columnSpan = columnSpan;
    } else {
      pdfCell = tableSummaryRow.cells[startColumnIndex];
    }
    pdfCell.value = summaryValue;

    //Applying row cell borders style
    for (int i = 0; i < tableSummaryRow.cells.count; i++) {
      tableSummaryRow.cells[i].style.borders.all = _pdfPen;
    }
    _exportCellToPdf(DataGridExportCellType.tableSummaryRow, pdfCell,
        pdfCell.value, column ?? dataGrid.columns[0]);
  }
}

/// Details for the callback that use [DataGridCellPdfExportDetails]
class DataGridCellPdfExportDetails {
  ///the callback event [DataGridCellPdfExportDetails]
  const DataGridCellPdfExportDetails(
      this.cellType, this.pdfCell, this.cellValue, this.columnName);

  /// The type of the cell.
  final DataGridExportCellType cellType;

  /// A corresponding cell in the Pdf document.
  final PdfGridCell pdfCell;

  /// The value of the cell. Typically, it is [DataGridCell.value].
  final Object? cellValue;

  /// The name of a column.
  final String columnName;
}

/// Details for the callback that use [DataGridPdfHeaderFooterExportDetails]
class DataGridPdfHeaderFooterExportDetails {
  ///
  DataGridPdfHeaderFooterExportDetails(this.pdfPage, this.pdfDocumentTemplate);

  /// The [PdfPage] which is currently being exported.
  final PdfPage pdfPage;

  /// The corresponding [PdfDocumentTemplate] to set the header and footer.
  final PdfDocumentTemplate pdfDocumentTemplate;
}

/// Signature for `cellExport` callback which is passed as an argument in
/// `exportToPdfGrid` and `exportToPdfDocument` methods.
typedef DataGridCellPdfExportCallback = void Function(
    DataGridCellPdfExportDetails details);

/// Signature for `headerFooterExport` callback which is passed as an argument
/// `exportToPdfGrid` and `exportToPdfDocument` methods.
typedef DataGridPdfHeaderFooterExportCallback = void Function(
    DataGridPdfHeaderFooterExportDetails details);
