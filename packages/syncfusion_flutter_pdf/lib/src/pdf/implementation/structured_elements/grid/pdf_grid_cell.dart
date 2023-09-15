import 'dart:ui';

import '../../drawing/drawing.dart';
import '../../graphics/brushes/pdf_brush.dart';
import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/enums.dart';
import '../../graphics/figures/base/element_layouter.dart';
import '../../graphics/figures/base/text_layouter.dart';
import '../../graphics/figures/enums.dart';
import '../../graphics/figures/pdf_template.dart';
import '../../graphics/figures/pdf_text_element.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/fonts/pdf_string_format.dart';
import '../../graphics/fonts/pdf_string_layout_result.dart';
import '../../graphics/fonts/pdf_string_layouter.dart';
import '../../graphics/images/pdf_image.dart';
import '../../graphics/pdf_color.dart';
import '../../graphics/pdf_graphics.dart';
import '../../graphics/pdf_pen.dart';
import '../../pages/pdf_page.dart';
import 'enums.dart';
import 'layouting/pdf_grid_layouter.dart';
import 'pdf_grid.dart';
import 'pdf_grid_row.dart';
import 'styles/pdf_borders.dart';
import 'styles/style.dart';

/// Represents the schema of a cell in a [PdfGrid].
/// ```dart
/// //Create a new PDF document
/// PdfDocument document = PdfDocument();
/// //Create a PdfGrid
/// PdfGrid grid = PdfGrid();
/// //Add columns to grid
/// grid.columns.add(count: 3);
/// //Add headers to grid
/// PdfGridRow header = grid.headers.add(1)[0];
/// header.cells[0].value = 'Employee ID';
/// header.cells[1].value = 'Employee Name';
/// header.cells[2].value = 'Salary';
/// //Add rows to grid
/// PdfGridRow row1 = grid.rows.add();
/// row1.cells[0].value = 'E01';
/// row1.cells[1].value = 'Clay';
/// //Apply the cell style to specific row cells
/// row1.cells[0].style = PdfGridCellStyle(
///   backgroundBrush: PdfBrushes.lightYellow,
///   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
///   font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
///   textBrush: PdfBrushes.white,
///   textPen: PdfPens.orange,
/// );
/// PdfGridCell gridCell = PdfGridCell(
///     row: row1,
///     format: PdfStringFormat(
///         alignment: PdfTextAlignment.center,
///         lineAlignment: PdfVerticalAlignment.bottom,
///         wordSpacing: 10));
/// gridCell.value = '\$10,000';
/// row1.cells[2].value = gridCell.value;
/// row1.cells[2].stringFormat = gridCell.stringFormat;
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
class PdfGridCell {
  /// Initializes a new instance of the [PdfGridCell] class.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// //Apply the cell style to specific row cells
  /// row1.cells[0].style = PdfGridCellStyle(
  ///   backgroundBrush: PdfBrushes.lightYellow,
  ///   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///   font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
  ///   textBrush: PdfBrushes.white,
  ///   textPen: PdfPens.orange,
  /// );
  /// PdfGridCell gridCell = PdfGridCell(
  ///     row: row1,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.bottom,
  ///         wordSpacing: 10));
  /// gridCell.value = '\$10,000';
  /// row1.cells[2].value = gridCell.value;
  /// row1.cells[2].stringFormat = gridCell.stringFormat;
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
  PdfGridCell(
      {PdfGridCellStyle? style,
      PdfStringFormat? format,
      PdfGridRow? row,
      int? rowSpan,
      int? columnSpan}) {
    _helper = PdfGridCellHelper(this);
    _initialize(style, format, row, rowSpan, columnSpan);
  }

  //Fields
  late PdfGridCellHelper _helper;
  late double _width;
  late double _height;
  late double _outerCellWidth;
  late int _rowSpan;
  late int _columnSpan;
  dynamic _value;
  PdfStringFormat? _format;
  PdfGridCell? _parent;
  late double _tempRowSpanRemainingHeight;
  late PdfGridImagePosition _imagePosition;
  late PdfGridStretchOption _pdfGridStretchOption;
  PdfGridCellStyle? _style;
  late double _maxValue;

  //Properties
  /// Gets the width of the [PdfGrid] cell.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add the styles to specific cell
  /// header.cells[0].style.stringFormat = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom,
  ///     wordSpacing: 10);
  /// header.cells[1].style.textPen = PdfPens.mediumVioletRed;
  /// header.cells[2].style.backgroundBrush = PdfBrushes.yellow;
  /// header.cells[2].style.textBrush = PdfBrushes.darkOrange;
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10000';
  /// //Sets the rowSpan
  /// row1.cells[1].rowSpan = 1;
  /// //Sets the colSpan
  /// row1.cells[1].columnSpan = 2;
  /// //Apply the cell style to specific row cells
  /// row1.cells[0].style = PdfGridCellStyle(
  ///   backgroundBrush: PdfBrushes.lightYellow,
  ///   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///   font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
  ///   textBrush: PdfBrushes.white,
  ///   textPen: PdfPens.orange,
  /// );
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Gets the width of the PDF grid cell
  /// double width = row2.cells[2].width;
  /// //Gets the height of the PDF grid cell
  /// double height = row2.cells[2].height;
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get width {
    if (_width == -1 ||
        PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(_helper.row!).grid)
            .isComplete) {
      _width = _measureWidth();
    }
    return double.parse(_width.toStringAsFixed(4));
  }

  /// Gets the height of the [PdfGrid] cell.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add the styles to specific cell
  /// header.cells[0].style.stringFormat = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom,
  ///     wordSpacing: 10);
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10000';
  /// //Sets the rowSpan
  /// row1.cells[1].rowSpan = 1;
  /// //Sets the colSpan
  /// row1.cells[1].columnSpan = 2;
  /// //Apply the cell style to specific row cells
  /// row1.cells[0].style = PdfGridCellStyle(
  ///   backgroundBrush: PdfBrushes.lightYellow,
  ///   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///   font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
  ///   textBrush: PdfBrushes.white,
  ///   textPen: PdfPens.orange,
  /// );
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Gets the width of the PDF grid cell
  /// double width = row2.cells[2].width;
  /// //Gets the height of the PDF grid cell
  /// double height = row2.cells[2].height;
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  double get height {
    if (_height == -1) {
      _height = _helper.measureHeight();
    }
    return _height;
  }

  /// Gets or sets a value that indicates the total number of rows that cell spans
  /// within a [PdfGrid].
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10000';
  /// //Sets the rowSpan
  /// row1.cells[1].rowSpan = 1;
  /// //Sets the colSpan
  /// row1.cells[1].columnSpan = 2;
  /// //Apply the cell style to specific row cells
  /// row1.cells[0].style = PdfGridCellStyle(
  ///   backgroundBrush: PdfBrushes.lightYellow,
  ///   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///   font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
  ///   textBrush: PdfBrushes.white,
  ///   textPen: PdfPens.orange,
  /// );
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Gets the width of the PDF grid cell
  /// double width = row2.cells[2].width;
  /// //Gets the height of the PDF grid cell
  /// double height = row2.cells[2].height;
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get rowSpan => _rowSpan;
  set rowSpan(int value) {
    if (value < 1) {
      throw ArgumentError.value('value', 'row span',
          'Invalid span specified, must be greater than or equal to 1');
    }
    if (value > 1) {
      _rowSpan = value;
      PdfGridRowHelper.getHelper(_helper.row!).rowSpanExists = true;
      PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(_helper.row!).grid)
          .hasRowSpan = true;
    }
  }

  /// Gets or sets a value that indicates the total number of columns that cell spans
  /// within a [PdfGrid].
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add the styles to specific cell
  /// header.cells[0].style.stringFormat = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom,
  ///     wordSpacing: 10);
  /// header.cells[1].style.textPen = PdfPens.mediumVioletRed;
  /// header.cells[2].style.backgroundBrush = PdfBrushes.yellow;
  /// header.cells[2].style.textBrush = PdfBrushes.darkOrange;
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10000';
  /// //Sets the rowSpan
  /// row1.cells[1].rowSpan = 1;
  /// //Sets the colSpan
  /// row1.cells[1].columnSpan = 2;
  /// //Apply the cell style to specific row cells
  /// row1.cells[0].style = PdfGridCellStyle(
  ///   backgroundBrush: PdfBrushes.lightYellow,
  ///   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///   font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
  ///   textBrush: PdfBrushes.white,
  ///   textPen: PdfPens.orange,
  /// );
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Gets the width of the PDF grid cell
  /// double width = row2.cells[2].width;
  /// //Gets the height of the PDF grid cell
  /// double height = row2.cells[2].height;
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get columnSpan => _columnSpan;
  set columnSpan(int value) {
    if (value < 1) {
      throw ArgumentError.value('value', 'column span',
          'Invalid span specified, must be greater than or equal to 1');
    }
    if (value > 1) {
      _columnSpan = value;
      PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(_helper.row!).grid)
          .hasColumnSpan = true;
    }
  }

  /// Gets or sets the cell style.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add the styles to specific cell
  /// header.cells[0].style.stringFormat = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom,
  ///     wordSpacing: 10);
  /// header.cells[1].style.textPen = PdfPens.mediumVioletRed;
  /// header.cells[2].style.backgroundBrush = PdfBrushes.yellow;
  /// header.cells[2].style.textBrush = PdfBrushes.darkOrange;
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// //Apply the cell style to specific row cells
  /// row1.cells[0].style = PdfGridCellStyle(
  ///   backgroundBrush: PdfBrushes.lightYellow,
  ///   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///   font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
  ///   textBrush: PdfBrushes.white,
  ///   textPen: PdfPens.orange,
  /// );
  /// PdfGridCell gridCell = PdfGridCell(
  ///     row: row1,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.bottom,
  ///         wordSpacing: 10));
  /// gridCell.value = '\$10,000';
  /// row1.cells[2].value = gridCell.value;
  /// row1.cells[2].stringFormat = gridCell.stringFormat;
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Add the style to specific cell
  /// row2.cells[2].style.borders = PdfBorders(
  ///     left: PdfPen(PdfColor(240, 0, 0), width: 2),
  ///     top: PdfPen(PdfColor(0, 240, 0), width: 3),
  ///     bottom: PdfPen(PdfColor(0, 0, 240), width: 4),
  ///     right: PdfPen(PdfColor(240, 100, 240), width: 5));
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridCellStyle get style {
    _style ??= PdfGridCellStyle();
    return _style!;
  }

  set style(PdfGridCellStyle value) {
    _style = value;
  }

  /// Gets or sets the value of the cell.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// //Apply the cell style to specific row cells
  /// PdfGridCell gridCell = PdfGridCell(
  ///     row: row1,
  ///     format: PdfStringFormat(
  ///         alignment: PdfTextAlignment.center,
  ///         lineAlignment: PdfVerticalAlignment.bottom,
  ///         wordSpacing: 10));
  /// gridCell.value = '\$10,000';
  /// row1.cells[2].value = gridCell.value;
  /// row1.cells[2].stringFormat = gridCell.stringFormat;
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
  dynamic get value => _value;
  set value(dynamic value) {
    _value = value;
    _setValue(value);
  }

  /// Gets or sets the string format.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add the styles to specific cell
  /// header.cells[0].style.stringFormat = PdfStringFormat(
  ///     alignment: PdfTextAlignment.center,
  ///     lineAlignment: PdfVerticalAlignment.bottom,
  ///     wordSpacing: 10);
  /// header.cells[1].style.textPen = PdfPens.mediumVioletRed;
  /// header.cells[2].style.backgroundBrush = PdfBrushes.yellow;
  /// header.cells[2].style.textBrush = PdfBrushes.darkOrange;
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// row1.cells[0].value = 'E01';
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10,000';
  /// //Apply the cell style to specific row cells
  /// row1.cells[0].style = PdfGridCellStyle(
  ///   backgroundBrush: PdfBrushes.lightYellow,
  ///   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///   font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
  ///   textBrush: PdfBrushes.white,
  ///   textPen: PdfPens.orange,
  /// );
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
  PdfStringFormat get stringFormat {
    _format ??= PdfStringFormat();
    return _format!;
  }

  set stringFormat(PdfStringFormat value) {
    _format = value;
  }

  /// Gets or sets the image alignment type of the [PdfGridCell] image.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// PdfGridCell cell1 = row1.cells[0];
  /// //Sets the image alignment type of the PdfGridCell image
  /// cell1.imagePosition = PdfGridImagePosition.center;
  /// cell1.style.backgroundImage = PdfBitmap(imageData);
  /// cell1.style.cellPadding = PdfPaddings(left: 0, right: 0, top: 10, bottom: 10);
  /// row1.cells[1].value = 'Clay';
  /// row1.cells[2].value = '\$10000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridImagePosition get imagePosition => _imagePosition;
  set imagePosition(PdfGridImagePosition value) {
    if (_imagePosition != value) {
      _imagePosition = value;
    }
  }

  //Implementation
  void _initialize(PdfGridCellStyle? style, PdfStringFormat? format,
      PdfGridRow? row, int? rowSpan, int? columnSpan) {
    if (row != null) {
      _helper.row = row;
    }
    if (style != null) {
      _style = style;
    }
    if (format != null) {
      stringFormat = format;
    }
    if (rowSpan != null && rowSpan > 1) {
      this.rowSpan = rowSpan;
    } else {
      _rowSpan = 1;
    }
    if (columnSpan != null && columnSpan > 1) {
      this.columnSpan = columnSpan;
    } else {
      _columnSpan = 1;
    }
    _width = -1;
    _height = -1;
    _helper.finished = true;
    _helper.pageCount = 0;
    _helper.present = false;
    _outerCellWidth = -1;
    _helper.rowSpanRemainingHeight = 0;
    _imagePosition = PdfGridImagePosition.stretch;
    _pdfGridStretchOption = PdfGridStretchOption.none;
    _helper.isCellMergeContinue = false;
    _helper.isRowMergeContinue = false;
    _tempRowSpanRemainingHeight = 0;
    _maxValue = 3.40282347E+38;
  }

  void _setValue(dynamic value) {
    if (value == null) {
      throw ArgumentError.value(value, 'value', 'value cannot be null');
    }
    if (_value is PdfGrid) {
      PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(_helper.row!).grid)
          .isSingleGrid = false;
      PdfGridHelper.getHelper(_value as PdfGrid).parentCell = this;
      PdfGridHelper.getHelper(_value as PdfGrid).isChildGrid = true;
      for (int i = 0; i < _value.rows.count; i++) {
        final PdfGridRow row = _value.rows[i] as PdfGridRow;
        for (int j = 0; j < row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j];
          cell._parent = this;
        }
      }
    }
  }

  PdfFont? _getTextFont() {
    return style.font ??
        _helper.row!.style.font ??
        PdfGridRowHelper.getHelper(_helper.row!).grid.style.font ??
        PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(_helper.row!).grid)
            .defaultFont;
  }

  PdfBrush? _getTextBrush() {
    return style.textBrush ??
        _helper.row!.style.textBrush ??
        PdfGridRowHelper.getHelper(_helper.row!).grid.style.textBrush ??
        PdfBrushes.black;
  }

  PdfPen? _getTextPen() {
    return style.textPen ??
        _helper.row!.style.textPen ??
        PdfGridRowHelper.getHelper(_helper.row!).grid.style.textPen;
  }

  PdfBrush? _getBackgroundBrush() {
    return style.backgroundBrush ??
        _helper.row!.style.backgroundBrush ??
        PdfGridRowHelper.getHelper(_helper.row!).grid.style.backgroundBrush;
  }

  double _measureWidth() {
    double? width = 0;
    final PdfStringLayouter layouter = PdfStringLayouter();
    if (value is String) {
      double? defaultWidth = _maxValue;
      if (_parent != null) {
        defaultWidth = _getColumnWidth();
      }
      final PdfStringLayoutResult result = layouter.layout(
          value, _getTextFont()!, stringFormat,
          width: defaultWidth, height: _maxValue);
      width += result.size.width;
      width += (style.borders.left.width + style.borders.right.width) * 2;
    } else if (value is PdfGrid) {
      width = PdfGridHelper.getHelper(value).gridSize.width;
    } else if (value is PdfTextElement) {
      double? defaultWidth = _maxValue;
      if (_parent != null) {
        defaultWidth = _getColumnWidth();
      }
      final PdfTextElement element = value as PdfTextElement;
      String? temp = element.text;
      if (!_helper.finished) {
        temp = (_helper.remainingString != null &&
                _helper.remainingString!.isNotEmpty)
            ? _helper.remainingString
            : value as String;
      }
      final PdfStringLayoutResult result = layouter.layout(
          temp!, element.font, element.stringFormat ?? stringFormat,
          width: defaultWidth, height: _maxValue);
      width += result.size.width;
      width += (style.borders.left.width + style.borders.right.width) * 2;
    }
    return width +
        PdfGridRowHelper.getHelper(_helper.row!).grid.style.cellSpacing +
        (style.cellPadding != null
            ? (style.cellPadding!.left + style.cellPadding!.right)
            : (PdfGridRowHelper.getHelper(_helper.row!)
                    .grid
                    .style
                    .cellPadding
                    .left +
                PdfGridRowHelper.getHelper(_helper.row!)
                    .grid
                    .style
                    .cellPadding
                    .right));
  }

  double _getColumnWidth() {
    double defaultWidth =
        PdfGridCellHelper.getHelper(_parent!)._calculateWidth()! /
            PdfGridRowHelper.getHelper(_helper.row!).grid.columns.count;
    if (defaultWidth <= 0) {
      defaultWidth = _maxValue;
    }
    return defaultWidth;
  }
}

/// [PdfGridCell] helper
class PdfGridCellHelper {
  /// internal constructor
  PdfGridCellHelper(this.base);

  /// internal field
  PdfGridCell base;

  /// internal method
  static PdfGridCellHelper getHelper(PdfGridCell base) {
    return base._helper;
  }

  /// internal field
  PdfGridRow? row;

  /// internal field
  late bool finished;

  /// internal field
  String? remainingString;

  /// internal field
  bool present = false;

  /// internal field
  late bool isCellMergeContinue;

  /// internal method
  late bool isRowMergeContinue;

  /// internal method
  late double rowSpanRemainingHeight;

  /// internal method
  late int pageCount;

  /// internal method
  double measureHeight() {
    final double width = _calculateWidth()! -
        (base.style.cellPadding == null
            ? (PdfGridRowHelper.getHelper(row!).grid.style.cellPadding.right +
                PdfGridRowHelper.getHelper(row!).grid.style.cellPadding.left)
            : (base.style.cellPadding!.right +
                base.style.cellPadding!.left +
                base.style.borders.left.width +
                base.style.borders.right.width));
    base._outerCellWidth = width;
    double height = 0;
    final PdfStringLayouter layouter = PdfStringLayouter();
    if (base.value is PdfTextElement) {
      final PdfTextElement element = base.value as PdfTextElement;
      String? temp = element.text;
      if (!finished) {
        temp = (remainingString != null && remainingString!.isNotEmpty)
            ? remainingString
            : base.value as String;
      }
      final PdfStringLayoutResult result = layouter.layout(
          temp!, element.font, element.stringFormat ?? base.stringFormat,
          width: width, height: base._maxValue);
      height += result.size.height +
          ((base.style.borders.top.width + base.style.borders.bottom.width) *
              2);
    } else if (base.value is String || remainingString is String) {
      String? currentValue = base.value as String;
      if (!finished) {
        currentValue = (remainingString != null && remainingString!.isNotEmpty)
            ? remainingString
            : base.value as String;
      }
      final PdfStringLayoutResult result = layouter.layout(
          currentValue!, base._getTextFont()!, base.stringFormat,
          width: width, height: base._maxValue);
      height += result.size.height +
          ((base.style.borders.top.width + base.style.borders.bottom.width) *
              2);
    } else if (base.value is PdfGrid) {
      height = PdfGridHelper.getHelper(base.value as PdfGrid).size.height;
    } else if (base.value is PdfImage) {
      final PdfImage img = base._value as PdfImage;
      height = img.height / (96 / 72);
    }
    height += base.style.cellPadding == null
        ? (PdfGridRowHelper.getHelper(row!).grid.style.cellPadding.top +
            PdfGridRowHelper.getHelper(row!).grid.style.cellPadding.bottom)
        : (base.style.cellPadding!.top + base.style.cellPadding!.bottom);
    height += PdfGridRowHelper.getHelper(row!).grid.style.cellSpacing;
    return height;
  }

  double? _calculateWidth() {
    final int cellIndex = row!.cells.indexOf(base);
    final int columnSpan = base.columnSpan;
    double width = 0;
    for (int i = 0; i < columnSpan; i++) {
      width +=
          PdfGridRowHelper.getHelper(row!).grid.columns[cellIndex + i].width;
    }
    if (base._parent != null &&
        PdfGridRowHelper.getHelper(
                    PdfGridCellHelper.getHelper(base._parent!).row!)
                .getWidth() >
            0 &&
        PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
            .isChildGrid! &&
        (PdfGridRowHelper.getHelper(row!).getWidth() >
            PdfGridRowHelper.getHelper(
                    PdfGridCellHelper.getHelper(base._parent!).row!)
                .getWidth())) {
      width = 0;
      for (int j = 0; j < base._parent!.columnSpan; j++) {
        width += PdfGridRowHelper.getHelper(
                PdfGridCellHelper.getHelper(base._parent!).row!)
            .grid
            .columns[j]
            .width;
      }
      width = width / row!.cells.count;
    } else if (base._parent != null &&
        PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
            .isChildGrid! &&
        width == -1) {
      width = _findGridColumnWidth(base._parent!);
      width = width / row!.cells.count;
    }
    return width;
  }

  double _findGridColumnWidth(PdfGridCell pdfGridCell) {
    double width = -1;
    if (pdfGridCell._parent != null && pdfGridCell._outerCellWidth == -1) {
      width = _findGridColumnWidth(pdfGridCell._parent!);
      width = width / PdfGridCellHelper.getHelper(pdfGridCell).row!.cells.count;
    } else if (pdfGridCell._parent == null && pdfGridCell._outerCellWidth > 0) {
      width = pdfGridCell._outerCellWidth;
    }
    return width;
  }

  /// internal method
  PdfGraphics drawCellBorders(PdfGraphics graphics, PdfRectangle bounds) {
    final PdfBorders borders = base.style.borders;
    if (PdfGridRowHelper.getHelper(row!).grid.style.borderOverlapStyle ==
        PdfBorderOverlapStyle.inside) {
      bounds.x = bounds.x + borders.left.width;
      bounds.y = bounds.y + borders.top.width;
      bounds.width = bounds.width - borders.right.width;
      bounds.height = bounds.height - borders.bottom.width;
    }
    PdfPen? pen = base.style.borders.left;
    if (PdfBordersHelper.isAll(base.style.borders)) {
      _setTransparency(graphics, pen);
      graphics.drawRectangle(pen: pen, bounds: bounds.rect);
    } else {
      Offset p1 = Offset(bounds.x, bounds.y + bounds.height);
      Offset p2 = Offset(bounds.x, bounds.y);
      if (base._style!.borders.left.dashStyle == PdfDashStyle.solid &&
          !PdfPenHelper.getHelper(pen).isImmutable) {
        pen.lineCap = PdfLineCap.square;
      }
      _setTransparency(graphics, pen);
      graphics.drawLine(pen, p1, p2);
      graphics.restore();

      p1 = Offset(bounds.x + bounds.width, bounds.y);
      p2 = Offset(bounds.x + bounds.width, bounds.y + bounds.height);
      pen = base._style!.borders.right;
      if (bounds.x + bounds.width > graphics.clientSize.width - pen.width / 2) {
        p1 = Offset(graphics.clientSize.width - pen.width / 2, bounds.y);
        p2 = Offset(graphics.clientSize.width - pen.width / 2,
            bounds.y + bounds.height);
      }
      if (base._style!.borders.right.dashStyle == PdfDashStyle.solid &&
          !PdfPenHelper.getHelper(pen).isImmutable) {
        pen.lineCap = PdfLineCap.square;
      }
      _setTransparency(graphics, pen);
      graphics.drawLine(pen, p1, p2);
      graphics.restore();
      p1 = Offset(bounds.x, bounds.y);
      p2 = Offset(bounds.x + bounds.width, bounds.y);
      pen = base._style!.borders.top;
      if (base._style!.borders.top.dashStyle == PdfDashStyle.solid &&
          !PdfPenHelper.getHelper(pen).isImmutable) {
        pen.lineCap = PdfLineCap.square;
      }
      _setTransparency(graphics, pen);
      graphics.drawLine(pen, p1, p2);
      graphics.restore();
      p1 = Offset(bounds.x + bounds.width, bounds.y + bounds.height);
      p2 = Offset(bounds.x, bounds.y + bounds.height);
      pen = base._style!.borders.bottom;
      if (bounds.y + bounds.height >
          graphics.clientSize.height - pen.width / 2) {
        p1 = Offset(bounds.x + bounds.width,
            graphics.clientSize.height - pen.width / 2);
        p2 = Offset(bounds.x, graphics.clientSize.height - pen.width / 2);
      }
      if (base._style!.borders.bottom.dashStyle == PdfDashStyle.solid &&
          !PdfPenHelper.getHelper(pen).isImmutable) {
        pen.lineCap = PdfLineCap.square;
      }
      _setTransparency(graphics, pen);
      graphics.drawLine(pen, p1, p2);
    }
    graphics.restore();
    return graphics;
  }

  void _setTransparency(PdfGraphics graphics, PdfPen pen) {
    graphics.save();
    graphics.setTransparency(PdfColorHelper.getHelper(pen.color).alpha / 255);
  }

  /// internal method
  PdfStringLayoutResult? draw(
      PdfGraphics? graphics, PdfRectangle bounds, bool cancelSubsequentSpans) {
    bool isrowbreak = false;
    if (!PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
        .isSingleGrid) {
      if ((remainingString != null) || (PdfGridLayouter.repeatRowIndex != -1)) {
        _drawParentCells(graphics!, bounds, true);
      } else if (PdfGridRowHelper.getHelper(row!).grid.rows.count > 1) {
        for (int i = 0;
            i < PdfGridRowHelper.getHelper(row!).grid.rows.count;
            i++) {
          if (row == PdfGridRowHelper.getHelper(row!).grid.rows[i]) {
            if (PdfGridRowHelper.getHelper(
                        PdfGridRowHelper.getHelper(row!).grid.rows[i])
                    .rowBreakHeight >
                0) {
              isrowbreak = true;
            }
            if ((i > 0) && isrowbreak) {
              _drawParentCells(graphics!, bounds, false);
            }
          }
        }
      }
    }
    PdfStringLayoutResult? result;
    if (cancelSubsequentSpans) {
      final int currentCellIndex = row!.cells.indexOf(base);
      for (int i = currentCellIndex + 1;
          i <= currentCellIndex + base._columnSpan;
          i++) {
        PdfGridCellHelper.getHelper(row!.cells[i]).isCellMergeContinue = false;
        PdfGridCellHelper.getHelper(row!.cells[i]).isRowMergeContinue = false;
      }
      base._columnSpan = 1;
    }
    if (isCellMergeContinue || isRowMergeContinue) {
      if (isCellMergeContinue &&
          PdfGridRowHelper.getHelper(row!).grid.style.allowHorizontalOverflow) {
        if ((PdfGridRowHelper.getHelper(row!).rowOverflowIndex > 0 &&
                (row!.cells.indexOf(base) !=
                    PdfGridRowHelper.getHelper(row!).rowOverflowIndex + 1)) ||
            (PdfGridRowHelper.getHelper(row!).rowOverflowIndex == 0 &&
                isCellMergeContinue)) {
          return result;
        }
      } else {
        return result;
      }
    }
    bounds = _adjustOuterLayoutArea(bounds, graphics);
    graphics = _drawCellBackground(graphics, bounds);
    final PdfPen? textPen = base._getTextPen();
    final PdfBrush? textBrush = base._getTextBrush();
    final PdfFont? font = base._getTextFont();
    final PdfStringFormat strFormat =
        base.style.stringFormat ?? base.stringFormat;
    PdfRectangle innerLayoutArea = bounds.clone();
    if (innerLayoutArea.height >= graphics!.clientSize.height) {
      if (PdfGridRowHelper.getHelper(row!).grid.allowRowBreakingAcrossPages) {
        innerLayoutArea.height = innerLayoutArea.height - innerLayoutArea.y;
        bounds.height = bounds.height - bounds.y;
        if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
            .isChildGrid!) {
          innerLayoutArea.height = innerLayoutArea.height -
              PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                          PdfGridHelper.getHelper(
                                  PdfGridRowHelper.getHelper(row!).grid)
                              .parentCell!)
                      .row!)
                  .grid
                  .style
                  .cellPadding
                  .bottom;
        }
      } else {
        innerLayoutArea.height = graphics.clientSize.height;
        bounds.height = graphics.clientSize.height;
      }
    }
    innerLayoutArea = _adjustContentLayoutArea(innerLayoutArea);
    if (base.value is PdfGrid) {
      graphics.save();
      graphics.setClip(bounds: innerLayoutArea.rect, mode: PdfFillMode.winding);
      final PdfGrid childGrid = base.value as PdfGrid;
      PdfGridHelper.getHelper(childGrid).isChildGrid = true;
      PdfGridHelper.getHelper(childGrid).parentCell = base;
      PdfGridHelper.getHelper(childGrid).listOfNavigatePages = <int>[];
      PdfGridLayouter layouter = PdfGridLayouter(childGrid);
      PdfLayoutFormat? format = PdfLayoutFormat();
      if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
              .layoutFormat !=
          null) {
        format = PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
            .layoutFormat;
      } else {
        format.layoutType = PdfLayoutType.paginate;
      }
      if (PdfGraphicsHelper.getHelper(graphics).layer != null) {
        final PdfLayoutParams param = PdfLayoutParams();
        param.page = PdfGraphicsHelper.getHelper(graphics).page;
        param.bounds = innerLayoutArea;
        param.format = format;
        PdfGridHelper.getHelper(childGrid).setSpan();
        final PdfLayoutResult? childGridResult = layouter.layout(param);
        base.value = childGrid;
        if (childGridResult != null && param.page != childGridResult.page) {
          PdfGridRowHelper.getHelper(row!).gridResult = childGridResult;
          bounds.height = graphics.clientSize.height - bounds.y;
        }
      } else {
        PdfGridHelper.getHelper(childGrid).setSpan();
        layouter = PdfGridLayouter(base.value as PdfGrid);
        layouter.layoutGrid(graphics, innerLayoutArea);
      }
      graphics.restore();
    } else if (base.value is PdfTextElement) {
      final PdfTextElement textelement = base.value as PdfTextElement;
      final PdfPage? page = PdfGraphicsHelper.getHelper(graphics).page;
      PdfTextElementHelper.getHelper(textelement).isPdfTextElement = true;
      final String textElementString = textelement.text;
      PdfTextLayoutResult? textlayoutresult;
      if (finished) {
        textlayoutresult = textelement.draw(
            page: page, bounds: innerLayoutArea.rect) as PdfTextLayoutResult?;
      } else {
        textelement.text = remainingString!;
        textlayoutresult = textelement.draw(
            page: page, bounds: innerLayoutArea.rect) as PdfTextLayoutResult?;
      }
      if (textlayoutresult!.remainder != null &&
          textlayoutresult.remainder!.isNotEmpty) {
        remainingString = textlayoutresult.remainder;
        finished = false;
      } else {
        remainingString = null;
        finished = true;
      }
      textelement.text = textElementString;
    } else if (base.value is String || remainingString is String) {
      String? temp;
      PdfRectangle layoutRectangle;
      if (innerLayoutArea.height < font!.height) {
        layoutRectangle = PdfRectangle(innerLayoutArea.x, innerLayoutArea.y,
            innerLayoutArea.width, font.height);
      } else {
        layoutRectangle = innerLayoutArea;
      }
      if (innerLayoutArea.height < font.height &&
          PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
              .isChildGrid! &&
          PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
                  .parentCell !=
              null) {
        final double height = layoutRectangle.height -
            PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                        PdfGridHelper.getHelper(
                                PdfGridRowHelper.getHelper(row!).grid)
                            .parentCell!)
                    .row!)
                .grid
                .style
                .cellPadding
                .bottom -
            PdfGridRowHelper.getHelper(row!).grid.style.cellPadding.bottom;
        if (height > 0 && height < font.height) {
          layoutRectangle.height = height;
        } else if (height +
                    PdfGridRowHelper.getHelper(row!)
                        .grid
                        .style
                        .cellPadding
                        .bottom >
                0 &&
            height +
                    PdfGridRowHelper.getHelper(row!)
                        .grid
                        .style
                        .cellPadding
                        .bottom <
                font.height) {
          layoutRectangle.height = height +
              PdfGridRowHelper.getHelper(row!).grid.style.cellPadding.bottom;
        } else if (bounds.height < font.height) {
          layoutRectangle.height = bounds.height;
        } else if (bounds.height -
                PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                            PdfGridHelper.getHelper(
                                    PdfGridRowHelper.getHelper(row!).grid)
                                .parentCell!)
                        .row!)
                    .grid
                    .style
                    .cellPadding
                    .bottom <
            font.height) {
          layoutRectangle.height = bounds.height -
              PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                          PdfGridHelper.getHelper(
                                  PdfGridRowHelper.getHelper(row!).grid)
                              .parentCell!)
                      .row!)
                  .grid
                  .style
                  .cellPadding
                  .bottom;
        }
      }
      if (base.style.cellPadding != null &&
          base.style.cellPadding!.bottom == 0 &&
          base.style.cellPadding!.left == 0 &&
          base.style.cellPadding!.right == 0 &&
          base.style.cellPadding!.top == 0) {
        layoutRectangle.width = layoutRectangle.width -
            base.style.borders.left.width +
            base.style.borders.right.width;
      }
      if (finished) {
        temp = remainingString != null && remainingString!.isEmpty
            ? remainingString
            : base.value as String;
        graphics.drawString(temp!, font,
            pen: textPen,
            brush: textBrush,
            bounds: layoutRectangle.rect,
            format: strFormat);
      } else {
        graphics.drawString(remainingString!, font,
            pen: textPen,
            brush: textBrush,
            bounds: layoutRectangle.rect,
            format: strFormat);
      }
      result = PdfGraphicsHelper.getHelper(graphics).stringLayoutResult;
      if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
              .isChildGrid! &&
          PdfGridRowHelper.getHelper(row!).rowBreakHeight > 0 &&
          result != null) {
        bounds.height = bounds.height -
            PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(
                        PdfGridHelper.getHelper(
                                PdfGridRowHelper.getHelper(row!).grid)
                            .parentCell!)
                    .row!)
                .grid
                .style
                .cellPadding
                .bottom;
      }
    } else if (base._value is PdfImage) {
      if (base.style.cellPadding != null &&
          base.style.cellPadding !=
              PdfPaddings(left: 0, right: 0, top: 0, bottom: 0)) {
        final PdfPaddings padding = base.style.cellPadding!;
        bounds = PdfRectangle(
            bounds.x + padding.left,
            bounds.y + padding.top,
            bounds.width - (padding.left + padding.right),
            bounds.height - (padding.top + padding.bottom));
      } else if (PdfGridRowHelper.getHelper(row!).grid.style.cellPadding !=
          PdfPaddings(left: 0, right: 0, top: 0, bottom: 0)) {
        final PdfPaddings padding =
            PdfGridRowHelper.getHelper(row!).grid.style.cellPadding;
        bounds = PdfRectangle(
            bounds.x + padding.left,
            bounds.y + padding.top,
            bounds.width - (padding.left + padding.right),
            bounds.height - (padding.top + padding.bottom));
      }
      final PdfImage img = base.value as PdfImage;
      double? imgWidth = img.width.toDouble();
      double? imgHeight = img.height.toDouble();
      double spaceX = 0;
      double spaceY = 0;
      if (base._pdfGridStretchOption == PdfGridStretchOption.uniform ||
          base._pdfGridStretchOption == PdfGridStretchOption.uniformToFill) {
        double ratio = 1;
        if (imgWidth > bounds.width) {
          ratio = imgWidth / bounds.width;
          imgWidth = bounds.width;
          imgHeight = imgHeight / ratio;
        }
        if (imgHeight > bounds.height) {
          ratio = imgHeight / bounds.height;
          imgHeight = bounds.height;
          imgWidth = imgWidth / ratio;
        }
        if (imgWidth < bounds.width && imgHeight < bounds.height) {
          spaceX = bounds.width - imgWidth;
          spaceY = bounds.height - imgHeight;
          if (spaceX < spaceY) {
            ratio = imgWidth / bounds.width;
            imgWidth = bounds.width;
            imgHeight = imgHeight / ratio;
          } else {
            ratio = imgHeight / bounds.height;
            imgHeight = bounds.height;
            imgWidth = imgWidth / ratio;
          }
        }
      }
      if (base._pdfGridStretchOption == PdfGridStretchOption.fill ||
          base._pdfGridStretchOption == PdfGridStretchOption.none) {
        imgWidth = bounds.width;
        imgHeight = bounds.height;
      }
      if (base._pdfGridStretchOption == PdfGridStretchOption.uniformToFill) {
        double ratio = 1;
        if (imgWidth == bounds.width && imgHeight < bounds.height) {
          ratio = imgHeight / bounds.height;
          imgHeight = bounds.height;
          imgWidth = imgWidth / ratio;
        }
        if (imgHeight == bounds.height && imgWidth < bounds.width) {
          ratio = imgWidth / bounds.width;
          imgWidth = bounds.width;
          imgHeight = imgHeight / ratio;
        }
        final PdfPage graphicsPage =
            PdfGraphicsHelper.getHelper(graphics).page!;
        final PdfGraphicsState st = graphicsPage.graphics.save();
        graphicsPage.graphics
            .setClip(bounds: bounds.rect, mode: PdfFillMode.winding);
        graphicsPage.graphics.drawImage(
            img, Rect.fromLTWH(bounds.x, bounds.y, imgWidth, imgHeight));
        graphicsPage.graphics.restore(st);
      } else {
        graphics = _setImagePosition(graphics, img,
            PdfRectangle(bounds.x, bounds.y, imgWidth, imgHeight));
      }
      graphics!.save();
    }
    graphics = drawCellBorders(graphics, bounds);
    return result;
  }

  void _drawParentCells(PdfGraphics graphics, PdfRectangle bounds, bool b) {
    final PdfPoint location = PdfPoint(
        PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
                .defaultBorder
                .right
                .width /
            2,
        PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
                .defaultBorder
                .top
                .width /
            2);
    if ((bounds.height < graphics.clientSize.height) && (b == true)) {
      bounds.height = bounds.height + bounds.y - location.y;
    }
    final PdfRectangle rect =
        PdfRectangle(location.x, location.y, bounds.width, bounds.height);
    if (b == false) {
      rect.y = bounds.y;
      rect.height = bounds.height;
    }
    PdfGridCell? c = base;
    if (base._parent != null) {
      if ((PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(c).row!)
                  .grid
                  .rows
                  .count ==
              1) &&
          (PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(c).row!)
                  .grid
                  .rows[0]
                  .cells
                  .count ==
              1)) {
        PdfGridCellHelper.getHelper(
                PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(c).row!)
                    .grid
                    .rows[0]
                    .cells[0])
            .present = true;
      } else {
        for (int rowIndex = 0;
            rowIndex <
                PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(c).row!)
                    .grid
                    .rows
                    .count;
            rowIndex++) {
          final PdfGridRow r =
              PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(c).row!)
                  .grid
                  .rows[rowIndex];
          if (r == PdfGridCellHelper.getHelper(c).row) {
            for (int cellIndex = 0; cellIndex < row!.cells.count; cellIndex++) {
              final PdfGridCell cell = row!.cells[cellIndex];
              if (cell == c) {
                PdfGridCellHelper.getHelper(cell).present = true;
                break;
              }
            }
          }
        }
      }
      while (c!._parent != null) {
        c = c._parent;
        PdfGridCellHelper.getHelper(c!).present = true;
        rect.x = rect.x +
            PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(c).row!)
                .grid
                .style
                .cellPadding
                .left;
      }
    }
    if (bounds.x >= rect.x) {
      rect.x = rect.x - bounds.x;
      if (rect.x < 0) {
        rect.x = bounds.x;
      }
    }
    PdfGrid pdfGrid =
        PdfGridRowHelper.getHelper(PdfGridCellHelper.getHelper(c).row!).grid;
    for (int i = 0; i < pdfGrid.rows.count; i++) {
      for (int j = 0; j < pdfGrid.rows[i].cells.count; j++) {
        if (PdfGridCellHelper.getHelper(pdfGrid.rows[i].cells[j]).present ==
            true) {
          int cellcount = 0;
          if (pdfGrid.rows[i].style.backgroundBrush != null) {
            base.style.backgroundBrush = pdfGrid.rows[i].style.backgroundBrush;
            double cellwidth = 0;
            if (j > 0) {
              for (int n = 0; n < j; n++) {
                cellwidth += pdfGrid.columns[n].width;
              }
            }
            rect.width =
                PdfGridRowHelper.getHelper(pdfGrid.rows[i]).getWidth() -
                    cellwidth;
            final PdfGrid? grid = pdfGrid.rows[i].cells[j].value as PdfGrid?;
            if (grid != null) {
              for (int l = 0; l < grid.rows.count; l++) {
                for (int m = 0; m < grid.rows[l].cells.count; m++) {
                  if ((PdfGridCellHelper.getHelper(grid.rows[l].cells[m])
                          .present) &&
                      m > 0) {
                    rect.width = grid.rows[l].cells[m].width;
                    cellcount = m;
                  }
                }
              }
            }
            graphics = _drawCellBackground(graphics, rect)!;
          }
          PdfGridCellHelper.getHelper(pdfGrid.rows[i].cells[j]).present = false;
          if (pdfGrid.rows[i].cells[j].style.backgroundBrush != null) {
            base.style.backgroundBrush =
                pdfGrid.rows[i].cells[j].style.backgroundBrush;
            if (cellcount == 0) {
              rect.width = pdfGrid.columns[j].width;
            }
            graphics = _drawCellBackground(graphics, rect)!;
          }
          if (pdfGrid.rows[i].cells[j].value is PdfGrid) {
            if (!PdfGridRowHelper.getHelper(pdfGrid.rows[i]).isrowFinish) {
              if (cellcount == 0) {
                rect.x = rect.x + pdfGrid.style.cellPadding.left;
              }
            }
            pdfGrid = pdfGrid.rows[i].cells[j].value as PdfGrid;
            if (pdfGrid.style.backgroundBrush != null) {
              base.style.backgroundBrush = pdfGrid.style.backgroundBrush;
              if (cellcount == 0) {
                if (j < pdfGrid.columns.count) {
                  rect.width = pdfGrid.columns[j].width;
                }
              }
              graphics = _drawCellBackground(graphics, rect)!;
            }
            i = -1;
            break;
          }
        }
      }
    }
    if (bounds.height < graphics.clientSize.height) {
      bounds.height = bounds.height - bounds.y - location.y;
    }
  }

  PdfGraphics? _drawCellBackground(PdfGraphics? graphics, PdfRectangle bounds) {
    final PdfBrush? backgroundBrush = base._getBackgroundBrush();
    if (backgroundBrush != null) {
      graphics!.save();
      graphics.drawRectangle(brush: backgroundBrush, bounds: bounds.rect);
      graphics.restore();
    }
    if (base.style.backgroundImage != null) {
      final PdfImage? image = base.style.backgroundImage;
      if (base.style.cellPadding != null &&
          base.style.cellPadding !=
              PdfPaddings(left: 0, right: 0, top: 0, bottom: 0)) {
        final PdfPaddings padding = base.style.cellPadding!;
        bounds = PdfRectangle(
            bounds.x + padding.left,
            bounds.y + padding.top,
            bounds.width - (padding.left + padding.right),
            bounds.height - (padding.top + padding.bottom));
      } else if (PdfGridRowHelper.getHelper(row!).grid.style.cellPadding !=
          PdfPaddings(left: 0, right: 0, top: 0, bottom: 0)) {
        final PdfPaddings padding =
            PdfGridRowHelper.getHelper(row!).grid.style.cellPadding;
        bounds = PdfRectangle(
            bounds.x + padding.left,
            bounds.y + padding.top,
            bounds.width - (padding.left + padding.right),
            bounds.height - (padding.top + padding.bottom));
      }
      return _setImagePosition(graphics, image, bounds);
    }
    return graphics;
  }

  PdfRectangle _adjustContentLayoutArea(PdfRectangle bounds) {
    PdfPaddings? padding = base.style.cellPadding;
    if (base.value is PdfGrid) {
      final PdfSize size = PdfGridHelper.getHelper(base.value).gridSize;
      if (padding == null) {
        padding = PdfGridRowHelper.getHelper(row!).grid.style.cellPadding;
        bounds.width = bounds.width - (padding.right + padding.left);
        bounds.height = bounds.height - (padding.bottom + padding.top);
        if (base.stringFormat.alignment == PdfTextAlignment.center) {
          bounds.x =
              bounds.x + padding.left + ((bounds.width - size.width) / 2);
          bounds.y =
              bounds.y + padding.top + ((bounds.height - size.height) / 2);
        } else if (base.stringFormat.alignment == PdfTextAlignment.left) {
          bounds.x = bounds.x + padding.left;
          bounds.y = bounds.y + padding.top;
        } else if (base.stringFormat.alignment == PdfTextAlignment.right) {
          bounds.x = bounds.x + padding.left + (bounds.width - size.width);
          bounds.y = bounds.y + padding.top;
          bounds.width = size.width;
        }
      } else {
        bounds.width = bounds.width - (padding.right + padding.left);
        bounds.height = bounds.height - (padding.bottom + padding.top);

        if (base.stringFormat.alignment == PdfTextAlignment.center) {
          bounds.x =
              bounds.x + padding.left + ((bounds.width - size.width) / 2);
          bounds.y =
              bounds.y + padding.top + ((bounds.height - size.height) / 2);
        } else if (base.stringFormat.alignment == PdfTextAlignment.left) {
          bounds.x = bounds.x + padding.left;
          bounds.y = bounds.y + padding.top;
        } else if (base.stringFormat.alignment == PdfTextAlignment.right) {
          bounds.x = bounds.x + padding.left + (bounds.width - size.width);
          bounds.y = bounds.y + padding.top;
          bounds.width = size.width;
        }
      }
    } else {
      if (padding == null) {
        padding = PdfGridRowHelper.getHelper(row!).grid.style.cellPadding;
        bounds.x = bounds.x + padding.left;
        bounds.y = bounds.y + padding.top;
        bounds.width = bounds.width - (padding.right + padding.left);
        bounds.height = bounds.height - (padding.bottom + padding.top);
      } else {
        bounds.x = bounds.x + padding.left;
        bounds.y = bounds.y + padding.top;
        bounds.width = bounds.width - (padding.right + padding.left);
        bounds.height = bounds.height - (padding.bottom + padding.top);
      }
    }
    return bounds;
  }

  PdfRectangle _adjustOuterLayoutArea(PdfRectangle bounds, PdfGraphics? g) {
    bool isHeader = false;
    final double cellSpacing =
        PdfGridRowHelper.getHelper(row!).grid.style.cellSpacing;
    if (cellSpacing > 0) {
      bounds = PdfRectangle(bounds.x + cellSpacing, bounds.y + cellSpacing,
          bounds.width - cellSpacing, bounds.height - cellSpacing);
    }
    final int currentColIndex = row!.cells.indexOf(base);
    if (base.columnSpan > 1 ||
        (PdfGridRowHelper.getHelper(row!).rowOverflowIndex > 0 &&
            (currentColIndex ==
                PdfGridRowHelper.getHelper(row!).rowOverflowIndex + 1) &&
            isCellMergeContinue)) {
      int span = base.columnSpan;
      if (span == 1 && isCellMergeContinue) {
        for (int j = currentColIndex + 1;
            j < PdfGridRowHelper.getHelper(row!).grid.columns.count;
            j++) {
          if (PdfGridCellHelper.getHelper(row!.cells[j]).isCellMergeContinue) {
            span++;
          } else {
            break;
          }
        }
      }
      double totalWidth = 0;
      for (int i = currentColIndex; i < currentColIndex + span; i++) {
        if (PdfGridRowHelper.getHelper(row!)
            .grid
            .style
            .allowHorizontalOverflow) {
          double width;
          final double compWidth = PdfGridHelper.getHelper(
                          PdfGridRowHelper.getHelper(row!).grid)
                      .size
                      .width <
                  g!.clientSize.width
              ? PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
                  .size
                  .width
              : g.clientSize.width;
          if (PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row!).grid)
                  .size
                  .width >
              g.clientSize.width) {
            width = bounds.x +
                totalWidth +
                PdfGridRowHelper.getHelper(row!).grid.columns[i].width;
          } else {
            width = totalWidth +
                PdfGridRowHelper.getHelper(row!).grid.columns[i].width;
          }
          if (width > compWidth) {
            break;
          }
        }
        totalWidth += PdfGridRowHelper.getHelper(row!).grid.columns[i].width;
      }
      totalWidth -= PdfGridRowHelper.getHelper(row!).grid.style.cellSpacing;
      bounds.width = totalWidth;
    }
    if (base.rowSpan > 1 || PdfGridRowHelper.getHelper(row!).rowSpanExists) {
      int span = base.rowSpan;
      int currentRowIndex = PdfGridRowCollectionHelper.indexOf(
          PdfGridRowHelper.getHelper(row!).grid.rows, row);
      if (currentRowIndex == -1) {
        currentRowIndex = PdfGridHeaderCollectionHelper.getHelper(
                PdfGridRowHelper.getHelper(row!).grid.headers)
            .indexOf(row!);
        if (currentRowIndex != -1) {
          isHeader = true;
        }
      }
      if (span == 1 && isCellMergeContinue) {
        for (int j = currentRowIndex + 1;
            j < PdfGridRowHelper.getHelper(row!).grid.rows.count;
            j++) {
          if (isHeader
              ? PdfGridCellHelper.getHelper(PdfGridRowHelper.getHelper(row!)
                      .grid
                      .headers[j]
                      .cells[currentColIndex])
                  .isCellMergeContinue
              : PdfGridCellHelper.getHelper(PdfGridRowHelper.getHelper(row!)
                      .grid
                      .rows[j]
                      .cells[currentColIndex])
                  .isCellMergeContinue) {
            span++;
          } else {
            break;
          }
        }
      }
      double totalHeight = 0;
      double max = 0;
      if (isHeader) {
        for (int i = currentRowIndex; i < currentRowIndex + span; i++) {
          totalHeight +=
              PdfGridRowHelper.getHelper(row!).grid.headers[i].height;
        }
        totalHeight -= PdfGridRowHelper.getHelper(row!).grid.style.cellSpacing;
        bounds.height = totalHeight;
      } else {
        for (int i = currentRowIndex; i < currentRowIndex + span; i++) {
          if (!PdfGridRowHelper.getHelper(
                  PdfGridRowHelper.getHelper(row!).grid.rows[i])
              .isRowSpanRowHeightSet) {
            PdfGridRowHelper.getHelper(
                    PdfGridRowHelper.getHelper(row!).grid.rows[i])
                .isRowHeightSet = false;
          }
          totalHeight += isHeader
              ? PdfGridRowHelper.getHelper(row!).grid.headers[i].height
              : PdfGridRowHelper.getHelper(row!).grid.rows[i].height;
          final PdfGridRow gridRow =
              PdfGridRowHelper.getHelper(row!).grid.rows[i];
          final int rowIndex = PdfGridRowCollectionHelper.indexOf(
              PdfGridRowHelper.getHelper(row!).grid.rows, gridRow);
          if (base.rowSpan > 1) {
            for (int cellIndex = 0;
                cellIndex < gridRow.cells.count;
                cellIndex++) {
              final PdfGridCell cell = gridRow.cells[cellIndex];
              if (cell.rowSpan > 1) {
                double tempHeight = 0;
                for (int j = i; j < i + cell.rowSpan; j++) {
                  if (!PdfGridRowHelper.getHelper(
                          PdfGridRowHelper.getHelper(row!).grid.rows[j])
                      .isRowSpanRowHeightSet) {
                    PdfGridRowHelper.getHelper(
                            PdfGridRowHelper.getHelper(row!).grid.rows[j])
                        .isRowHeightSet = false;
                  }
                  tempHeight +=
                      PdfGridRowHelper.getHelper(row!).grid.rows[j].height;
                  if (!PdfGridRowHelper.getHelper(
                          PdfGridRowHelper.getHelper(row!).grid.rows[j])
                      .isRowSpanRowHeightSet) {
                    PdfGridRowHelper.getHelper(
                            PdfGridRowHelper.getHelper(row!).grid.rows[j])
                        .isRowHeightSet = true;
                  }
                }
                if (cell.height > tempHeight) {
                  if (max < (cell.height - tempHeight)) {
                    max = cell.height - tempHeight;
                    if (base._tempRowSpanRemainingHeight != 0 &&
                        max > base._tempRowSpanRemainingHeight) {
                      max += base._tempRowSpanRemainingHeight;
                    }
                    final int index = gridRow.cells.indexOf(cell);
                    PdfGridCellHelper.getHelper(PdfGridRowHelper.getHelper(row!)
                            .grid
                            .rows[(rowIndex + cell.rowSpan) - 1]
                            .cells[index])
                        .rowSpanRemainingHeight = max;
                    base._tempRowSpanRemainingHeight =
                        PdfGridCellHelper.getHelper(
                                PdfGridRowHelper.getHelper(row!)
                                    .grid
                                    .rows[(rowIndex + cell.rowSpan) - 1]
                                    .cells[index])
                            .rowSpanRemainingHeight;
                  }
                }
              }
            }
          }
          if (!PdfGridRowHelper.getHelper(
                  PdfGridRowHelper.getHelper(row!).grid.rows[i])
              .isRowSpanRowHeightSet) {
            PdfGridRowHelper.getHelper(
                    PdfGridRowHelper.getHelper(row!).grid.rows[i])
                .isRowHeightSet = true;
          }
        }
        final int cellIndex = row!.cells.indexOf(base);
        totalHeight -= PdfGridRowHelper.getHelper(row!).grid.style.cellSpacing;
        if (row!.cells[cellIndex].height > totalHeight &&
            (!PdfGridRowHelper.getHelper(PdfGridRowHelper.getHelper(row!)
                    .grid
                    .rows[(currentRowIndex + span) - 1])
                .isRowHeightSet)) {
          PdfGridCellHelper.getHelper(PdfGridRowHelper.getHelper(row!)
                      .grid
                      .rows[(currentRowIndex + span) - 1]
                      .cells[cellIndex])
                  .rowSpanRemainingHeight =
              row!.cells[cellIndex].height - totalHeight;
          totalHeight = row!.cells[cellIndex].height;
          bounds.height = totalHeight;
        } else {
          bounds.height = totalHeight;
        }
        if (!PdfGridRowHelper.getHelper(row!).rowMergeComplete) {
          bounds.height = totalHeight;
        }
      }
    }
    return bounds;
  }

  PdfGraphics? _setImagePosition(
      PdfGraphics? graphics, PdfImage? image, PdfRectangle bounds) {
    if (base._imagePosition == PdfGridImagePosition.stretch) {
      graphics!.drawImage(image!, bounds.rect);
    } else if (base._imagePosition == PdfGridImagePosition.center) {
      double gridCentreX;
      double gridCentreY;
      gridCentreX = bounds.x + (bounds.width / 4);
      gridCentreY = bounds.y + (bounds.height / 4);
      graphics!.drawImage(
          image!,
          Rect.fromLTWH(
              gridCentreX, gridCentreY, bounds.width / 2, bounds.height / 2));
    } else if (base._imagePosition == PdfGridImagePosition.fit) {
      final double imageWidth = image!.physicalDimension.width;
      final double imageHeight = image.physicalDimension.height;
      double? x;
      double? y;
      if (imageHeight > imageWidth) {
        y = bounds.y;
        x = bounds.x + bounds.width / 4;
        graphics!.drawImage(
            image, Rect.fromLTWH(x, y, bounds.width / 2, bounds.height));
      } else {
        x = bounds.x;
        y = bounds.y + (bounds.height / 4);
        graphics!.drawImage(
            image, Rect.fromLTWH(x, y, bounds.width, bounds.height / 2));
      }
    } else if (base._imagePosition == PdfGridImagePosition.tile) {
      final double cellLeft = bounds.x;
      final double cellTop = bounds.y;
      final double pWidth = _physicalDimension(image, true);
      final double pHeight = _physicalDimension(image, false);
      double? x = cellLeft;
      double y = cellTop;
      for (; y < bounds.bottom;) {
        for (x = cellLeft; x! < bounds.right;) {
          if (x + pWidth > bounds.right && y + pHeight > bounds.bottom) {
            final PdfTemplate template =
                PdfTemplate(bounds.right - x, bounds.bottom - y);
            template.graphics!.drawImage(image!, Rect.zero);
            graphics!.drawPdfTemplate(template, Offset(x, y));
          } else if (x + pWidth > bounds.right) {
            final PdfTemplate template = PdfTemplate(bounds.right - x, pHeight);
            template.graphics!.drawImage(image!, Rect.zero);
            graphics!.drawPdfTemplate(template, Offset(x, y));
          } else if (y + pHeight > bounds.bottom) {
            final PdfTemplate template = PdfTemplate(pWidth, bounds.bottom - y);
            template.graphics!.drawImage(image!, Rect.zero);
            graphics!.drawPdfTemplate(template, Offset(x, y));
          } else {
            graphics!.drawImage(image!, Rect.fromLTWH(x, y, 0, 0));
          }
          x += pWidth;
        }
        y += pHeight;
      }
    }
    return graphics;
  }

  //if horizontal/vertical resolution is not set, resolution set as default 96.
  double _physicalDimension(PdfImage? image, bool isHorizontal) {
    if (isHorizontal) {
      return image!.width /
          ((image.horizontalResolution > 0 ? image.horizontalResolution : 96) /
              72);
    } else {
      return image!.height /
          ((image.verticalResolution > 0 ? image.verticalResolution : 96) / 72);
    }
  }
}

/// Provides access to an ordered, strongly typed collection of
/// [PdfGridCell] objects.
/// ```dart
/// //Create a new PDF document
/// PdfDocument document = PdfDocument();
/// //Create a PdfGrid
/// PdfGrid grid = PdfGrid();
/// //Add columns to grid
/// grid.columns.add(count: 3);
/// //Add headers to grid
/// PdfGridRow header = grid.headers.add(1)[0];
/// header.cells[0].value = 'Employee ID';
/// header.cells[1].value = 'Employee Name';
/// header.cells[2].value = 'Salary';
/// //Add rows to grid
/// PdfGridRow row1 = grid.rows.add();
/// //Gets the cell collection from the row
/// PdfGridCellCollection cellCollection = row1.cells;
/// //Gets the specific cell from the row collection
/// PdfGridCell cell1 = cellCollection[0];
/// cell1.value = 'E01';
/// cell1.style.cellPadding = PdfPaddings(left: 0, right: 0, top: 10, bottom: 10);
/// cellCollection[1].value = 'Clay';
/// cellCollection[2].value = '\$10000';
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
class PdfGridCellCollection {
  //Constructors
  /// Initializes a new instance of the [PdfGridCellCollection] class
  /// with the row.
  PdfGridCellCollection._(PdfGridRow row) {
    _helper = PdfGridCellCollectionHelper(this);
    _helper.row = row;
    _helper._cells = <PdfGridCell>[];
  }

  //Fields
  late PdfGridCellCollectionHelper _helper;

  //Properties
  /// Gets the cells count.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// //Gets the cell collection from the row
  /// PdfGridCellCollection cellCollection = row1.cells;
  /// //Gets the specific cell from the row collection
  /// PdfGridCell cell1 = cellCollection[0];
  /// cell1.value = 'E01';
  /// cell1.style.cellPadding = PdfPaddings(left: 0, right: 0, top: 10, bottom: 10);
  /// cellCollection[1].value = 'Clay';
  /// cellCollection[2].value = '\$10000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Gets the cells count
  /// int cellsCount = cellCollection.count;
  /// //Gets the index of particular cell
  /// int index = cellCollection.indexOf(cell1);
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get count => _helper._cells.length;

  /// Gets the [PdfGridCell] at the specified index.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// //Gets the cell collection from the row
  /// PdfGridCellCollection cellCollection = row1.cells;
  /// //Gets the specific cell from the row collection
  /// PdfGridCell cell1 = cellCollection[0];
  /// cell1.value = 'E01';
  /// cell1.style.cellPadding = PdfPaddings(left: 0, right: 0, top: 10, bottom: 10);
  /// cellCollection[1].value = 'Clay';
  /// cellCollection[2].value = '\$10000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Gets the cells count
  /// int cellsCount = cellCollection.count;
  /// //Gets the index of particular cell
  /// int index = cellCollection.indexOf(cell1);
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridCell operator [](int index) => _returnValue(index);

  //Public methods
  /// Returns the index of a particular cell in the collection.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid
  /// PdfGrid grid = PdfGrid();
  /// //Add columns to grid
  /// grid.columns.add(count: 3);
  /// //Add headers to grid
  /// PdfGridRow header = grid.headers.add(1)[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row1 = grid.rows.add();
  /// //Gets the cell collection from the row
  /// PdfGridCellCollection cellCollection = row1.cells;
  /// //Gets the specific cell from the row collection
  /// PdfGridCell cell1 = cellCollection[0];
  /// cell1.value = 'E01';
  /// cell1.style.cellPadding = PdfPaddings(left: 0, right: 0, top: 10, bottom: 10);
  /// cellCollection[1].value = 'Clay';
  /// cellCollection[2].value = '\$10000';
  /// PdfGridRow row2 = grid.rows.add();
  /// row2.cells[0].value = 'E02';
  /// row2.cells[1].value = 'Simon';
  /// row2.cells[2].value = '\$12,000';
  /// //Gets the cells count
  /// int cellsCount = cellCollection.count;
  /// //Gets the index of particular cell
  /// int index = cellCollection.indexOf(cell1);
  /// //Draw the grid in PDF document page
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int indexOf(PdfGridCell cell) {
    return _helper._cells.indexOf(cell);
  }

  //Implementation
  PdfGridCell _returnValue(int index) {
    if (index < 0 || index >= _helper._cells.length) {
      // ignore: deprecated_member_use
      throw IndexError(index, _helper._cells);
    }
    return _helper._cells[index];
  }
}

/// [PdfGridCellCollection] helper
class PdfGridCellCollectionHelper {
  /// internal constructor
  PdfGridCellCollectionHelper(this.base);

  /// internal field
  PdfGridCellCollection base;

  /// internal field
  late PdfGridRow row;
  late List<PdfGridCell> _cells;

  /// internal method
  static PdfGridCellCollectionHelper getHelper(PdfGridCellCollection base) {
    return base._helper;
  }

  /// internal method
  static PdfGridCellCollection load(PdfGridRow row) {
    return PdfGridCellCollection._(row);
  }

  /// internal method
  void add(PdfGridCell cell) {
    // cell.style ??= _row!.style as PdfGridCellStyle;
    PdfGridCellHelper.getHelper(cell).row = row;
    _cells.add(cell);
  }
}
