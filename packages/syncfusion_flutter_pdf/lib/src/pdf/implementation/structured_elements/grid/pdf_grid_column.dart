import '../../graphics/fonts/pdf_string_format.dart';
import 'pdf_grid.dart';
import 'pdf_grid_cell.dart';
import 'pdf_grid_row.dart';

/// Represents the schema of a column in a [PdfGrid].
/// ```dart
/// //Create a new PDF document
/// PdfDocument document = PdfDocument();
/// //Create a PdfGrid
/// PdfGrid grid = PdfGrid();
/// //Create column to the PDF grid
/// PdfGridColumn column = PdfGridColumn(grid);
/// //Add columns to grid
/// grid.columns.add(column: column);
/// grid.columns.add(count: 2);
/// //Add headers to grid
/// grid.headers.add(1);
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
/// //Set the width
/// grid.columns[1].width = 50;
/// //Draw the grid in PDF document page
/// grid.draw(
///     page: document.pages.add(), bounds: Rect.zero);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfGridColumn {
  //Constructors
  /// Initializes a new instance of the [PdfGridColumn] class
  /// with the parent grid.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Create column to the PDF grid
  /// PdfGridColumn column = PdfGridColumn(grid);
  /// //Add columns to grid
  /// grid.columns.add(column: column);
  /// grid.columns.add(count: 2);
  /// //Add headers to grid
  /// grid.headers.add(1);
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
  /// //Set the width
  /// grid.columns[1].width = 50;
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridColumn(PdfGrid grid) {
    _helper = PdfGridColumnHelper(this);
    _grid = grid;
    _helper.width = -1;
    _helper.isCustomWidth = false;
  }

  //Fields
  late PdfGridColumnHelper _helper;
  late PdfGrid _grid;
  PdfStringFormat? _format;

  //Properties
  /// Gets the width of the [PdfGridColumn].
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Create column to the PDF grid
  /// PdfGridColumn column = PdfGridColumn(grid);
  /// //Add columns to grid
  /// grid.columns.add(column: column);
  /// grid.columns.add(count: 2);
  /// //Add headers to grid
  /// grid.headers.add(1);
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
  /// //Set the width
  /// grid.columns[1].width = 50;
  /// //Set the column text format
  /// grid.columns[0].format = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom);
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get width => _helper.width;
  set width(double value) {
    _helper.isCustomWidth = true;
    _helper.width = value;
  }

  /// Gets the information about the text formatting.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Create column to the PDF grid
  /// PdfGridColumn column = PdfGridColumn(grid);
  /// //Add columns to grid
  /// grid.columns.add(column: column);
  /// grid.columns.add(count: 2);
  /// //Add headers to grid
  /// grid.headers.add(1);
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
  /// //Set the width
  /// grid.columns[1].width = 50;
  /// //Set the column text format
  /// grid.columns[0].format = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom);
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfStringFormat get format => _format ??= PdfStringFormat();
  set format(PdfStringFormat value) {
    _format = value;
  }

  /// Gets the parent [PdfGrid].
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Create column to the PDF grid
  /// PdfGridColumn column = PdfGridColumn(grid);
  /// //Add columns to grid
  /// grid.columns.add(column: column);
  /// grid.columns.add(count: 2);
  /// //Add headers to grid
  /// grid.headers.add(1);
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
  /// //Set the width
  /// grid.columns[1].width = 50;
  /// //Set the column text format
  /// grid.columns[0].format = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom);
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGrid get grid => _grid;
}

/// [PdfGridColumn] helper
class PdfGridColumnHelper {
  /// internal constructor
  PdfGridColumnHelper(this.base);

  /// internal field
  PdfGridColumn base;

  /// internal method
  static PdfGridColumnHelper getHelper(PdfGridColumn base) {
    return base._helper;
  }

  /// internal field
  late bool isCustomWidth;

  /// internal field
  late double width;
}

/// Provides access to an ordered, strongly typed collection of [PdfGridColumn]
/// objects.
/// ```dart
/// //Create a new PDF document
/// PdfDocument document = PdfDocument();
/// //Create a PdfGrid
/// PdfGrid grid = PdfGrid();
/// //Create column to the PDF grid
/// PdfGridColumn column = PdfGridColumn(grid);
/// //Gets column form the PDF grid
/// PdfGridColumnCollection columns = grid.columns;
/// //Add columns to grid
/// columns.add(column: column);
/// columns.add(count: 2);
/// //Add headers to grid
/// grid.headers.add(1);
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
/// //Set the width
/// grid.columns[1].width = 50;
/// //Set the column text format
/// grid.columns[0].format = PdfStringFormat(
///     alignment: PdfTextAlignment.center,
///     lineAlignment: PdfVerticalAlignment.bottom);
/// //Draw the grid in PDF document page
/// grid.draw(
///     page: document.pages.add(), bounds: Rect.zero);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfGridColumnCollection {
  /// Initializes a new instance of the [PdfGridColumnCollection] class
  /// with the parent grid.
  PdfGridColumnCollection(PdfGrid grid) {
    _helper = PdfGridColumnCollectionHelper(this);
    _helper._grid = grid;
    _helper._columns = <PdfGridColumn>[];
    _helper._columnsWidth = -1;
  }

  //Fields
  late PdfGridColumnCollectionHelper _helper;

  //Properties
  /// Gets the number of columns in the [PdfGrid].
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Create column to the PDF grid
  /// PdfGridColumn column = PdfGridColumn(grid);
  /// //Gets column form the PDF grid
  /// PdfGridColumnCollection columns = grid.columns;
  /// //Add columns to grid
  /// columns.add(column: column);
  /// columns.add(count: 2);
  /// //Gets column count
  /// int columnCount = columns.count;
  /// //Add headers to grid
  /// grid.headers.add(1);
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
  /// //Set the width
  /// grid.columns[1].width = 50;
  /// //Set the column text format
  /// grid.columns[0].format = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom);
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get count => _helper._columns.length;

  /// Gets the [PdfGridColumn] at the specified index.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Create column to the PDF grid
  /// PdfGridColumn column = PdfGridColumn(grid);
  /// //Gets column form the PDF grid
  /// PdfGridColumnCollection columns = grid.columns;
  /// //Add columns to grid
  /// columns.add(column: column);
  /// columns.add(count: 2);
  /// //Add headers to grid
  /// grid.headers.add(1);
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
  /// //Set the width
  /// grid.columns[1].width = 50;
  /// //Set the column text format
  /// grid.columns[0].format = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom);
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridColumn operator [](int index) => _returnValue(index);

  //Public methods

  /// Adds the column into the collection.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Create column to the PDF grid
  /// PdfGridColumn column = PdfGridColumn(grid);
  /// //Gets column form the PDF grid
  /// PdfGridColumnCollection columns = grid.columns;
  /// //Add columns to grid
  /// columns.add(column: column);
  /// columns.add(count: 2);
  /// //Add headers to grid
  /// grid.headers.add(1);
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
  /// //Set the width
  /// grid.columns[1].width = 50;
  /// //Set the column text format
  /// grid.columns[0].format = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom);
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void add({int? count, PdfGridColumn? column}) {
    if (count == null && column == null) {
      final PdfGridColumn column = PdfGridColumn(_helper._grid);
      _helper._columns.add(column);
    } else {
      if (count != null) {
        for (int i = 0; i < count; i++) {
          _helper._columns.add(PdfGridColumn(_helper._grid));
          for (int i = 0; i < _helper._grid.rows.count; i++) {
            final PdfGridRow row = _helper._grid.rows[i];
            final PdfGridCell cell = PdfGridCell();
            cell.value = '';
            PdfGridCellCollectionHelper.getHelper(row.cells).add(cell);
          }
        }
      }
      if (column != null) {
        _helper._columns.add(column);
      }
    }
  }

  //Implementation
  PdfGridColumn _returnValue(int index) {
    if (index < 0 || index >= _helper._columns.length) {
      // ignore: deprecated_member_use
      throw IndexError(index, _helper._columns);
    }
    return _helper._columns[index];
  }
}

/// [PdfGridColumnCollection] helper
class PdfGridColumnCollectionHelper {
  /// internal constructor
  PdfGridColumnCollectionHelper(this.base);

  /// internal field
  PdfGridColumnCollection base;
  late double _columnsWidth;
  late PdfGrid _grid;
  late List<PdfGridColumn> _columns;

  /// internal method
  static PdfGridColumnCollectionHelper getHelper(PdfGridColumnCollection base) {
    return base._helper;
  }

  /// internal method
  double get columnWidth {
    if (_columnsWidth == -1) {
      _columnsWidth = _measureColumnsWidth();
    }
    if (PdfGridHelper.getHelper(_grid).initialWidth != 0 &&
        _columnsWidth != PdfGridHelper.getHelper(_grid).initialWidth &&
        !_grid.style.allowHorizontalOverflow) {
      _columnsWidth = PdfGridHelper.getHelper(_grid).initialWidth;
      PdfGridHelper.getHelper(_grid).isPageWidth = true;
    }
    return _columnsWidth;
  }

  double _measureColumnsWidth() {
    double totalWidth = 0;
    PdfGridHelper.getHelper(_grid).measureColumnsWidth();
    for (int i = 0; i < _columns.length; i++) {
      totalWidth += _columns[i].width;
    }
    return totalWidth;
  }

  /// internal method

  List<double?> getDefaultWidths(double? totalWidth) {
    final List<double?> widths = List<double?>.filled(base.count, 0);
    int subFactor = base.count;
    for (int i = 0; i < base.count; i++) {
      if (PdfGridHelper.getHelper(_grid).isPageWidth &&
          totalWidth! >= 0 &&
          !PdfGridColumnHelper.getHelper(_columns[i]).isCustomWidth) {
        _columns[i].width = -1;
      } else {
        widths[i] = _columns[i].width;
        if (_columns[i].width > 0 &&
            PdfGridColumnHelper.getHelper(_columns[i]).isCustomWidth) {
          totalWidth = totalWidth! - _columns[i].width;
          subFactor--;
        } else {
          widths[i] = -1;
        }
      }
    }
    for (int i = 0; i < base.count; i++) {
      final double width = totalWidth! / subFactor;
      if (widths[i]! <= 0) {
        widths[i] = width;
      }
    }
    return widths;
  }
}
