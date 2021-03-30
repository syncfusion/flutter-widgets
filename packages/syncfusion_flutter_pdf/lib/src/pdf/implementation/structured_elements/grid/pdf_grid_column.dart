part of pdf;

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
///     page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
/// //Save the document.
/// List<int> bytes = document.save();
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
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridColumn(PdfGrid grid) {
    _grid = grid;
    _width = -1;
    _isCustomWidth = false;
  }

  //Fields
  late PdfGrid _grid;
  late double _width;
  PdfStringFormat? _format;
  late bool _isCustomWidth;

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
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get width => _width;
  set width(double value) {
    _isCustomWidth = true;
    _width = value;
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
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
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
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGrid get grid => _grid;
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
///     page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
/// //Save the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfGridColumnCollection {
  /// Initializes a new instance of the [PdfGridColumnCollection] class
  /// with the parent grid.
  PdfGridColumnCollection(PdfGrid grid) {
    _grid = grid;
    _columns = <PdfGridColumn>[];
    _columnsWidth = -1;
  }

  //Fields
  late PdfGrid _grid;
  late List<PdfGridColumn> _columns;
  late double _columnsWidth;

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
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get count => _columns.length;

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
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridColumn operator [](int index) => _returnValue(index);
  double get _width {
    if (_columnsWidth == -1) {
      _columnsWidth = _measureColumnsWidth();
    }
    if (_grid._initialWidth != 0 &&
        _columnsWidth != _grid._initialWidth &&
        !_grid.style.allowHorizontalOverflow) {
      _columnsWidth = _grid._initialWidth;
      _grid._isPageWidth = true;
    }
    return _columnsWidth;
  }

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
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void add({int? count, PdfGridColumn? column}) {
    if (count == null && column == null) {
      final PdfGridColumn column = PdfGridColumn(_grid);
      _columns.add(column);
    } else {
      if (count != null) {
        for (int i = 0; i < count; i++) {
          _columns.add(PdfGridColumn(_grid));
          for (int i = 0; i < _grid.rows.count; i++) {
            final PdfGridRow row = _grid.rows[i];
            final PdfGridCell cell = PdfGridCell();
            cell.value = '';
            row.cells._add(cell);
          }
        }
      }
      if (column != null) {
        _columns.add(column);
      }
    }
  }

  //Implementation
  PdfGridColumn _returnValue(int index) {
    if (index < 0 || index >= _columns.length) {
      throw IndexError(index, _columns);
    }
    return _columns[index];
  }

  double _measureColumnsWidth() {
    double totalWidth = 0;
    _grid._measureColumnsWidth();
    for (int i = 0; i < _columns.length; i++) {
      totalWidth += _columns[i].width;
    }
    return totalWidth;
  }

  List<double?> _getDefaultWidths(double? totalWidth) {
    final List<double?> widths = List<double?>.filled(count, 0);
    int subFactor = count;
    for (int i = 0; i < count; i++) {
      if (_grid._isPageWidth &&
          totalWidth! >= 0 &&
          !_columns[i]._isCustomWidth) {
        _columns[i].width = -1;
      } else {
        widths[i] = _columns[i].width;
        if (_columns[i].width > 0 && _columns[i]._isCustomWidth) {
          totalWidth = totalWidth! - _columns[i].width;
          subFactor--;
        } else {
          widths[i] = -1;
        }
      }
    }
    for (int i = 0; i < count; i++) {
      final double width = totalWidth! / subFactor;
      if (widths[i]! <= 0) {
        widths[i] = width;
      }
    }
    return widths;
  }
}
