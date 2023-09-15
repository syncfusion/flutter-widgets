import 'dart:math';

import '../../graphics/figures/base/text_layouter.dart';
import 'pdf_grid.dart';
import 'pdf_grid_cell.dart';
import 'styles/style.dart';

/// Provides customization of the settings for the particular row.
/// ```dart
/// //Create a new PDF document
/// PdfDocument document = PdfDocument();
/// //Create a PdfGrid
/// PdfGrid grid = PdfGrid();
/// //Add columns to grid
/// grid.columns.add(count: 3);
/// //Add headers to grid
/// grid.headers.add(2);
/// PdfGridRow header = grid.headers[0];
/// header.cells[0].value = 'Employee ID';
/// header.cells[1].value = 'Employee Name';
/// header.cells[2].value = 'Salary';
/// //Add rows to grid
/// PdfGridRow row1 = grid.rows.add();
/// row1.cells[0].value = 'E01';
/// row1.cells[1].value = 'Clay';
/// row1.cells[2].value = '\$10,000';
/// PdfGridRow row2 = grid.rows.add();
/// row2.cells[0].value = 'E02';
/// row2.cells[1].value = 'Simon';
/// row2.cells[2].value = '\$12,000';
/// //Set the row span
/// row1.cells[1].rowSpan = 2;
/// //Set the row height
/// row2.height = 20;
/// //Set the row style
/// row1.style = PdfGridRowStyle(
///     backgroundBrush: PdfBrushes.dimGray,
///     textPen: PdfPens.lightGoldenrodYellow,
///     textBrush: PdfBrushes.darkOrange,
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
/// //Draw the grid in PDF document page
/// grid.draw(
///     page: document.pages.add(), bounds: Rect.zero);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfGridRow {
  /// Initializes a new instance of the [PdfGridRow] class with the parent grid.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// grid.headers.add(2);
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Set the row span
  /// row1.cells[1].rowSpan = 2;
  /// //Set the row height
  /// row2.height = 20;
  /// //Set the row style
  /// row1.style = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.dimGray,
  ///     textPen: PdfPens.lightGoldenrodYellow,
  ///     textBrush: PdfBrushes.darkOrange,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridRow(PdfGrid grid, {PdfGridRowStyle? style, double? height}) {
    _helper = PdfGridRowHelper(this);
    _initialize(grid, style, height);
  }

  //Fields
  late PdfGridRowHelper _helper;
  PdfGridRowStyle? _style;
  late double _height;
  late double _width;

  //Properties
  /// Gets the cells from the selected row.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// grid.headers.add(2);
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Set the row span
  /// row1.cells[1].rowSpan = 2;
  /// //Set the row height
  /// row2.height = 20;
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridCellCollection get cells {
    _helper.cells ??= PdfGridCellCollectionHelper.load(this);
    return _helper.cells!;
  }

  /// Gets or sets the row style.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// grid.headers.add(2);
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Set the row span
  /// row1.cells[1].rowSpan = 2;
  /// //Set the row height
  /// row2.height = 20;
  /// //Set the row style
  /// row1.style = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.dimGray,
  ///     textPen: PdfPens.lightGoldenrodYellow,
  ///     textBrush: PdfBrushes.darkOrange,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// //Create the PDF grid row style. Assign to second row
  /// PdfGridRowStyle rowStyle = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.lightGoldenrodYellow,
  ///     textPen: PdfPens.indianRed,
  ///     textBrush: PdfBrushes.lightYellow,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// row2.style = rowStyle;
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridRowStyle get style {
    _style ??= PdfGridRowStyle();
    return _style!;
  }

  set style(PdfGridRowStyle? value) {
    _style = value;
  }

  /// Gets or sets the height of the row.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// grid.headers.add(2);
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Set the row span
  /// row1.cells[1].rowSpan = 2;
  /// //Set the row height
  /// row2.height = 20;
  /// //Set the row style
  /// row1.style = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.dimGray,
  ///     textPen: PdfPens.lightGoldenrodYellow,
  ///     textBrush: PdfBrushes.darkOrange,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get height {
    if (!_helper.isRowHeightSet) {
      _height = _measureHeight();
    }
    return _height;
  }

  set height(double value) {
    _helper.isRowHeightSet = true;
    _height = value;
  }

  //Implementation
  void _initialize(PdfGrid grid, PdfGridRowStyle? style, double? height) {
    if (style != null) {
      _style = style;
    }
    _helper.grid = grid;
    if (height != null) {
      this.height = height;
    } else {
      _height = -1;
    }
    _width = -1;
    _helper.rowSpanExists = false;
    _helper.rowBreakHeight = 0;
    _helper.rowOverflowIndex = 0;
    _helper.isRowBreaksNextPage = false;
    _helper.isrowFinish = false;
    _helper.rowMergeComplete = true;
    _helper.noOfPageCount = 0;
    _helper.isRowHeightSet = false;
    _helper.maximumRowSpan = 0;
    _helper.isPageBreakRowSpanApplied = false;
    _helper.isRowSpanRowHeightSet = false;
    _helper.isHeaderRow = false;
  }

  double _measureHeight() {
    double rowSpanRemainingHeight = 0;
    bool isHeader = false;
    double rowHeight = cells[0].rowSpan > 1 ? 0 : cells[0].height;
    double maxHeight = 0;
    if (PdfGridHeaderCollectionHelper.getHelper(_helper.grid.headers)
            .indexOf(this) !=
        -1) {
      isHeader = true;
    }
    for (int i = 0; i < _helper.cells!.count; i++) {
      final PdfGridCell cell = _helper.cells![i];
      if (PdfGridCellHelper.getHelper(cell).rowSpanRemainingHeight >
          rowSpanRemainingHeight) {
        rowSpanRemainingHeight =
            PdfGridCellHelper.getHelper(cell).rowSpanRemainingHeight;
      }
      if (PdfGridCellHelper.getHelper(cell).isRowMergeContinue) {
        continue;
      }
      if (!PdfGridCellHelper.getHelper(cell).isRowMergeContinue) {
        _helper.rowMergeComplete = false;
      }
      if (cell.rowSpan > 1) {
        if (maxHeight < cell.height) {
          maxHeight = cell.height;
        }
        continue;
      }
      rowHeight = max(rowHeight, cell.height);
    }
    if (rowHeight == 0) {
      rowHeight = maxHeight;
    } else if (rowSpanRemainingHeight > 0) {
      rowHeight = rowHeight + rowSpanRemainingHeight;
    }
    if (isHeader && maxHeight != 0 && rowHeight != 0 && rowHeight < maxHeight) {
      rowHeight = maxHeight;
    }
    return rowHeight;
  }
}

/// [PdfGridRow] helper
class PdfGridRowHelper {
  /// internal constructor
  PdfGridRowHelper(this.base);

  /// internal field
  PdfGridRow base;

  /// internal method
  static PdfGridRowHelper getHelper(PdfGridRow base) {
    return base._helper;
  }

  /// internal method
  double getWidth() {
    if (base._width == -1) {
      base._width = _measureWidth();
    }
    return base._width;
  }

  double _measureWidth() {
    double width = 0;
    for (int i = 0; i < grid.columns.count; i++) {
      width += grid.columns[i].width;
    }
    return width;
  }

  /// internal field
  late PdfGrid grid;

  /// internal field
  PdfGridCellCollection? cells;

  /// internal method
  late bool rowSpanExists;

  /// internal method
  late bool isHeaderRow;

  /// internal method
  late bool isRowSpanRowHeightSet;

  /// internal method
  late bool isPageBreakRowSpanApplied;

  /// internal method
  late bool isRowHeightSet;

  /// internal method
  late bool rowMergeComplete;

  /// internal method
  late bool isrowFinish;

  /// internal method
  late bool isRowBreaksNextPage;

  /// internal method
  late int maximumRowSpan;

  /// internal method
  late int noOfPageCount;

  /// internal method
  PdfLayoutResult? gridResult;

  /// internal method
  late int rowOverflowIndex;

  /// internal method
  late double rowBreakHeight;

  /// internal method
  int get index => grid.rows._indexOf(base);
}

/// Provides access to an ordered, strongly typed collection of
/// [PdfGridRow] objects.
/// ```dart
/// //Create a new PDF document
/// PdfDocument document = PdfDocument();
/// //Create a PdfGrid
/// PdfGrid grid = PdfGrid();
/// //Add columns to grid
/// grid.columns.add(count: 3);
/// //Add headers to grid
/// grid.headers.add(2);
/// PdfGridRow header = grid.headers[0];
/// header.cells[0].value = 'Employee ID';
/// header.cells[1].value = 'Employee Name';
/// header.cells[2].value = 'Salary';
/// //Add rows to grid
/// grid.rows.add();
/// grid.rows.add();
/// //Gets the row collection
/// PdfGridRowCollection rowCollection = grid.rows;
/// PdfGridRow row1 = rowCollection[0];
/// row1.cells[0].value = 'E01';
/// row1.cells[1].value = 'Clay';
/// row1.cells[2].value = '\$10,000';
/// PdfGridRow row2 = rowCollection[1];
/// row2.cells[0].value = 'E02';
/// row2.cells[1].value = 'Simon';
/// row2.cells[2].value = '\$12,000';
/// //Set the row span
/// row1.cells[1].rowSpan = 2;
/// //Set the row height
/// row2.height = 20;
/// //Set the row style
/// rowCollection[0].style = PdfGridRowStyle(
///     backgroundBrush: PdfBrushes.dimGray,
///     textPen: PdfPens.lightGoldenrodYellow,
///     textBrush: PdfBrushes.darkOrange,
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
/// //Draw the grid in PDF document page
/// grid.draw(
///     page: document.pages.add(), bounds: Rect.zero);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfGridRowCollection {
  /// Initializes a new instance of the [PdfGridRowCollection] class
  /// with the parent grid.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// grid.headers.add(2);
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// grid.rows.add();
  /// grid.rows.add();
  /// //Gets the row collection
  /// PdfGridRowCollection rowCollection = grid.rows;
  /// PdfGridRow row1 = rowCollection[0];
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = rowCollection[1];
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Set the row span
  /// row1.cells[1].rowSpan = 2;
  /// //Set the row height
  /// row2.height = 20;
  /// //Set the row style
  /// rowCollection[0].style = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.dimGray,
  ///     textPen: PdfPens.lightGoldenrodYellow,
  ///     textBrush: PdfBrushes.darkOrange,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridRowCollection(PdfGrid grid) {
    _grid = grid;
    _rows = <PdfGridRow>[];
  }

  //Fields
  late PdfGrid _grid;
  late List<PdfGridRow> _rows;

  //Properties
  /// Gets the rows count.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// grid.headers.add(2);
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// grid.rows.add();
  /// grid.rows.add();
  /// //Gets the row count
  /// int rowCount = grid.rows.count;
  /// //Gets the row collection
  /// PdfGridRowCollection rowCollection = grid.rows;
  /// PdfGridRow row1 = rowCollection[0];
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = rowCollection[1];
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Set the row span
  /// row1.cells[1].rowSpan = 2;
  /// //Set the row height
  /// row2.height = 20;
  /// //Set the row style
  /// rowCollection[0].style = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.dimGray,
  ///     textPen: PdfPens.lightGoldenrodYellow,
  ///     textBrush: PdfBrushes.darkOrange,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get count => _rows.length;

  /// Gets the [PdfGridRow] at the specified index.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// grid.headers.add(2);
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// grid.rows.add();
  /// grid.rows.add();
  /// //Gets the row collection
  /// PdfGridRowCollection rowCollection = grid.rows;
  /// PdfGridRow row1 = rowCollection[0];
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = rowCollection[1];
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Set the row span
  /// row1.cells[1].rowSpan = 2;
  /// //Set the row height
  /// row2.height = 20;
  /// //Set the row style
  /// rowCollection[0].style = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.dimGray,
  ///     textPen: PdfPens.lightGoldenrodYellow,
  ///     textBrush: PdfBrushes.darkOrange,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridRow operator [](int index) => _returnValue(index);

  //Public methods
  /// Add a row to the grid.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// grid.headers.add(2);
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// grid.rows.add();
  /// grid.rows.add();
  /// //Gets the row collection
  /// PdfGridRowCollection rowCollection = grid.rows;
  /// PdfGridRow row1 = rowCollection[0];
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = rowCollection[1];
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Set the row span
  /// row1.cells[1].rowSpan = 2;
  /// //Set the row height
  /// row2.height = 20;
  /// //Set the row style
  /// rowCollection[0].style = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.dimGray,
  ///     textPen: PdfPens.lightGoldenrodYellow,
  ///     textBrush: PdfBrushes.darkOrange,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridRow add([PdfGridRow? row]) {
    if (row == null) {
      final PdfGridRow row = PdfGridRow(_grid);
      add(row);
      return row;
    } else {
      row.style.font = _grid.style.font;
      row.style.backgroundBrush = _grid.style.backgroundBrush;
      row.style.textPen = _grid.style.textPen;
      row.style.textBrush = _grid.style.textBrush;
      if (row.cells.count == 0) {
        for (int i = 0; i < _grid.columns.count; i++) {
          PdfGridCellCollectionHelper.getHelper(row.cells).add(PdfGridCell());
        }
      }
      _rows.add(row);
      return row;
    }
  }

  /// Sets the row span and column span to a cell.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// grid.headers.add(2);
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Set the rows span
  /// grid.rows.setSpan(0, 1, 2, 1);
  /// //Set the row height
  /// row2.height = 20;
  /// //Set the row style
  /// row1.style = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.dimGray,
  ///     textPen: PdfPens.lightGoldenrodYellow,
  ///     textBrush: PdfBrushes.darkOrange,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void setSpan(int rowIndex, int cellIndex, int rowSpan, int columnSpan) {
    if (rowIndex > _grid.rows.count) {
      ArgumentError.value(rowIndex, 'rowIndex', 'Index out of range');
    }
    if (cellIndex > _grid.columns.count) {
      ArgumentError.value(cellIndex, 'cellIndex', 'Index out of range');
    }
    final PdfGridCell cell = _grid.rows[rowIndex].cells[cellIndex];
    cell.rowSpan = rowSpan;
    cell.columnSpan = columnSpan;
  }

  /// Applies the style to all the rows in the grid.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// grid.headers.add(2);
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Set the rows span
  /// grid.rows.setSpan(0, 1, 2, 1);
  /// //Set the row height
  /// row2.height = 20;
  /// //Set the row style
  /// row1.style = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.dimGray,
  ///     textPen: PdfPens.lightGoldenrodYellow,
  ///     textBrush: PdfBrushes.darkOrange,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// //Create the PDF grid row style. Assign to whole rows
  /// PdfGridRowStyle rowStyle = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.lightGoldenrodYellow,
  ///     textPen: PdfPens.indianRed,
  ///     textBrush: PdfBrushes.lightYellow,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// grid.rows.applyStyle(rowStyle);
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void applyStyle(PdfGridStyleBase style) {
    if (style is PdfGridCellStyle) {
      for (int i = 0; i < _grid.rows.count; i++) {
        final PdfGridRow row = _grid.rows[i];
        for (int j = 0; j < row.cells.count; j++) {
          row.cells[j].style = style;
        }
      }
    } else if (style is PdfGridRowStyle) {
      for (int i = 0; i < _grid.rows.count; i++) {
        _grid.rows[i].style = style;
      }
    } else if (style is PdfGridStyle) {
      _grid.style = style;
    }
  }

  //Implementation
  PdfGridRow _returnValue(int index) {
    if (index < 0 || index >= _rows.length) {
      // ignore: deprecated_member_use
      throw IndexError(index, _rows);
    }
    return _rows[index];
  }

  int _indexOf(PdfGridRow? row) {
    return _rows.indexOf(row!);
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfGridRowCollection] helper
class PdfGridRowCollectionHelper {
  /// internal method
  static PdfGrid getGrid(PdfGridRowCollection collection) {
    return collection._grid;
  }

  /// internal method
  static void setGrid(PdfGridRowCollection collection, PdfGrid value) {
    collection._grid = value;
  }

  /// internal method
  static List<PdfGridRow> getRows(PdfGridRowCollection collection) {
    return collection._rows;
  }

  /// internal method
  static void setRows(PdfGridRowCollection collection, List<PdfGridRow> value) {
    collection._rows = value;
  }

  /// internal method
  static int indexOf(PdfGridRowCollection collection, PdfGridRow? row) {
    return collection._indexOf(row);
  }
}

/// Provides customization of the settings for the header.
/// ```dart
/// //Create a new PDF document
/// PdfDocument document = PdfDocument();
/// //Create a PdfGrid
/// PdfGrid grid = PdfGrid();
/// //Add columns to grid
/// grid.columns.add(count: 3);
/// //Add headers to grid
/// grid.headers.add(2);
/// PdfGridHeaderCollection headers = grid.headers;
/// headers[0].cells[0].value = 'Employee ID';
/// headers[0].cells[1].value = 'Employee Name';
/// headers[0].cells[2].value = 'Salary';
/// //Add rows to grid
/// PdfGridRow row1 = grid.rows.add();
/// row1.cells[0].value = 'E01';
/// row1.cells[1].value = 'Clay';
/// row1.cells[2].value = '\$10,000';
/// PdfGridRow row2 = grid.rows.add();
/// row2.cells[0].value = 'E02';
/// row2.cells[1].value = 'Simon';
/// row2.cells[2].value = '\$12,000';
/// //Set the rows span
/// grid.rows.setSpan(0, 1, 2, 1);
/// //Draw the grid in PDF document page
/// grid.draw(
///     page: document.pages.add(), bounds: Rect.zero);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfGridHeaderCollection {
  /// Initializes a new instance of the [PdfGridHeaderCollection] class
  /// with the parent grid.
  PdfGridHeaderCollection(PdfGrid grid) {
    _helper = PdfGridHeaderCollectionHelper(this);
    _helper.grid = grid;
    _rows = <PdfGridRow>[];
  }

  //Fields
  late PdfGridHeaderCollectionHelper _helper;
  late List<PdfGridRow> _rows;

  //Properties
  ///  Gets the number of header in the [PdfGrid].
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Gets the headers collection from the grid
  /// PdfGridHeaderCollection headers = grid.headers;
  /// //Add headers to grid
  /// headers.add(1);
  /// Gets a header row from the headers collection
  /// headers[0].cells[0].value = 'Employee ID';
  /// headers[0].cells[1].value = 'Employee Name';
  /// headers[0].cells[2].value = 'Salary';
  /// Gets the headers count
  /// int headerCount = headers.count;
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get count => _rows.length;

  /// Gets a [PdfGridRow] object that represents the header row in a
  /// [PdfGridHeaderCollection] control.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Gets the headers collection from the grid
  /// PdfGridHeaderCollection headers = grid.headers;
  /// //Add headers to grid
  /// headers.add(1);
  /// Gets a header row from the headers collection
  /// headers[0].cells[0].value = 'Employee ID';
  /// headers[0].cells[1].value = 'Employee Name';
  /// headers[0].cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridRow operator [](int index) => _returnValue(index);

  //Public methods
  /// [PdfGrid] enables you to quickly and easily add rows
  /// to the header at run time.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Gets the headers collection from the grid
  /// PdfGridHeaderCollection headers = grid.headers;
  /// //Add headers to grid
  /// headers.add(1);
  /// headers[0].cells[0].value = 'Employee ID';
  /// headers[0].cells[1].value = 'Employee Name';
  /// headers[0].cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  List<PdfGridRow> add(int count) {
    return _addRows(count);
  }

  /// Enables you to set the appearance of the header row in a [PdfGrid].
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Gets the headers collection from the grid
  /// PdfGridHeaderCollection headers = grid.headers;
  /// //Add headers to grid
  /// headers.add(1);
  /// headers[0].cells[0].value = 'Employee ID';
  /// headers[0].cells[1].value = 'Employee Name';
  /// headers[0].cells[2].value = 'Salary';
  /// //Create the header row style. Assign to whole headers
  /// PdfGridRowStyle headerStyle = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.lightGoldenrodYellow,
  ///     textPen: PdfPens.indianRed,
  ///     textBrush: PdfBrushes.lightYellow,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// headers.applyStyle(headerStyle);
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void applyStyle(PdfGridStyleBase style) {
    if (style is PdfGridCellStyle) {
      for (int i = 0; i < _rows.length; i++) {
        final PdfGridRow row = _rows[i];
        for (int j = 0; j < row.cells.count; j++) {
          row.cells[j].style = style;
        }
      }
    } else if (style is PdfGridRowStyle) {
      for (int i = 0; i < _rows.length; i++) {
        _rows[i].style = style;
      }
    }
  }

  /// Removes all the header information in the [PdfGrid].
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Gets the headers collection from the grid
  /// PdfGridHeaderCollection headers = grid.headers;
  /// //Add headers to grid
  /// headers.add(1);
  /// headers[0].cells[0].value = 'Employee ID';
  /// headers[0].cells[1].value = 'Employee Name';
  /// headers[0].cells[2].value = 'Salary';
  /// //Create the header row style. Assign to whole headers
  /// PdfGridRowStyle headerStyle = PdfGridRowStyle(
  ///     backgroundBrush: PdfBrushes.lightGoldenrodYellow,
  ///     textPen: PdfPens.indianRed,
  ///     textBrush: PdfBrushes.lightYellow,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
  /// headers.applyStyle(headerStyle);
  /// //Clear the headers
  /// headers.clear();
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void clear() {
    _rows.clear();
  }

  //Implementation
  PdfGridRow _returnValue(int index) {
    if (index < 0 || index >= count) {
      // ignore: deprecated_member_use
      throw IndexError(index, _rows);
    }
    return _rows[index];
  }

  void _add(PdfGridRow row) {
    PdfGridRowHelper.getHelper(row).isHeaderRow = true;
    _rows.add(row);
  }

  List<PdfGridRow> _addRows(int count) {
    PdfGridRow row;
    for (int i = 0; i < count; i++) {
      row = PdfGridRow(_helper.grid);
      for (int j = 0; j < _helper.grid.columns.count; j++) {
        PdfGridCellCollectionHelper.getHelper(row.cells).add(PdfGridCell());
      }
      _add(row);
    }
    return _rows.toList();
  }
}

/// [PdfGridHeaderCollection] helper
class PdfGridHeaderCollectionHelper {
  /// internal constructor
  PdfGridHeaderCollectionHelper(this.base);

  /// internal field
  PdfGridHeaderCollection base;

  /// internal method
  static PdfGridHeaderCollectionHelper getHelper(PdfGridHeaderCollection base) {
    return base._helper;
  }

  /// internal method
  late PdfGrid grid;

  /// internal method
  int indexOf(PdfGridRow row) {
    return base._rows.indexOf(row);
  }
}
