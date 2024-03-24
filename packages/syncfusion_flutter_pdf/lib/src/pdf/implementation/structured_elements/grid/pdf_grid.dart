import 'dart:math';
import 'dart:ui';

import '../../drawing/drawing.dart';
import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/enums.dart';
import '../../graphics/figures/base/element_layouter.dart';
import '../../graphics/figures/base/layout_element.dart';
import '../../graphics/figures/base/text_layouter.dart';
import '../../graphics/fonts/enums.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/fonts/pdf_standard_font.dart';
import '../../graphics/fonts/pdf_true_type_font.dart';
import '../../graphics/pdf_color.dart';
import '../../graphics/pdf_graphics.dart';
import '../../graphics/pdf_pen.dart';
import '../../pages/pdf_page.dart';
import 'enums.dart';
import 'layouting/pdf_grid_layouter.dart';
import 'pdf_grid_cell.dart';
import 'pdf_grid_column.dart';
import 'pdf_grid_row.dart';
import 'styles/pdf_borders.dart';
import 'styles/style.dart';

/// Represents a flexible grid that consists of columns and rows.
/// ```dart
/// //Create a new PDF document
/// PdfDocument document = PdfDocument();
/// //Create a PdfGrid class
/// PdfGrid grid = PdfGrid();
/// //Add the columns to the grid
/// grid.columns.add(count: 3);
/// //Add header to the grid
/// grid.headers.add(1);
/// //Add the rows to the grid
/// PdfGridRow header = grid.headers[0];
/// header.cells[0].value = 'Employee ID';
/// header.cells[1].value = 'Employee Name';
/// header.cells[2].value = 'Salary';
/// //Add rows to grid
/// PdfGridRow row = grid.rows.add();
/// row.cells[0].value = 'E01';
/// row.cells[1].value = 'Clay';
/// row.cells[2].value = '\$10,000';
/// row = grid.rows.add();
/// row.cells[0].value = 'E02';
/// row.cells[1].value = 'Simon';
/// row.cells[2].value = '\$12,000';
/// //Set the grid style
/// grid.style = PdfGridStyle(
///     cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
///     backgroundBrush: PdfBrushes.blue,
///     textBrush: PdfBrushes.white,
///     font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
/// //Draw the grid
/// grid.draw(
///     page: document.pages.add(), bounds: Rect.zero);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfGrid extends PdfLayoutElement {
  /// Initializes a new instance of the [PdfGrid] class.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGrid() {
    _helper = PdfGridHelper(this);
    _initialize();
  }

  //Fields
  late PdfGridHelper _helper;
  PdfGridColumnCollection? _columns;
  PdfGridRowCollection? _rows;
  PdfGridStyle? _style;
  PdfGridHeaderCollection? _headers;

  /// Gets or sets a value indicating whether to repeat header.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Sets repeatHeader
  /// grid.repeatHeader = true;
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// for (int i = 0; i < 500; i++) {
  ///   final PdfGridRow row = grid.rows.add();
  ///   row.cells[0].value = 'Row - $i Cell - 1';
  ///   row.cells[1].value = 'Row - $i Cell - 2';
  ///   row.cells[2].value = 'Row - $i Cell - 3';
  /// }
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  late bool repeatHeader;

  /// Gets or sets a value indicating whether to split or cut rows that overflow a page.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Sets allowRowBreakingAcrossPages
  /// grid.allowRowBreakingAcrossPages = true;
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(100);
  /// //Add the rows to the grid
  /// for (int i = 0; i < 100; i++) {
  ///   final PdfGridRow header = grid.headers[i];
  ///   header.cells[0].value = 'Header - $i Cell - 1';
  ///   final PdfTextElement element = PdfTextElement(font: PdfStandardFont(PdfFontFamily.timesRoman, 15));
  ///   element.text =
  ///       'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
  ///   header.cells[1].value = element;
  ///   header.cells[2].value = 'Header - $i Cell - 3';
  /// }
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  late bool allowRowBreakingAcrossPages;
  late PdfRectangle _gridLocation;
  bool _headerRow = true;
  bool _bandedRow = true;
  late bool _bandedColumn;
  late bool _totalRow;
  late bool _firstColumn;
  late bool _lastColumn;
  Map<PdfTrueTypeFont, PdfTrueTypeFont>? _boldFontCache;
  Map<PdfTrueTypeFont, PdfTrueTypeFont>? _regularFontCache;
  Map<PdfTrueTypeFont, PdfTrueTypeFont>? _italicFontCache;

  //Events
  /// The event raised on starting cell lay outing.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// // Sets the event raised on starting cell lay outing.
  /// grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
  ///   if (args.rowIndex == 1 && args.cellIndex == 1) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  ///   if (args.isHeaderRow && args.cellIndex == 0) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  /// };
  /// grid.style.cellPadding = PdfPaddings();
  /// grid.style.cellPadding.all = 15;
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridBeginCellLayoutCallback? beginCellLayout;

  /// The event raised on finished cell layout.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// // Sets the event raised on finished cell layout.
  /// grid.endCellLayout = (Object sender, PdfGridEndCellLayoutArgs args) {
  ///   if (args.isHeaderRow && args.cellIndex == 0) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  ///   if (args.rowIndex == 1 && args.cellIndex == 1) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  /// };
  /// grid.style.cellPadding = PdfPaddings();
  /// grid.style.cellPadding.all = 15;
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridEndCellLayoutCallback? endCellLayout;

  //Properties
  /// Gets the column collection of the PdfGrid.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Set the grid style
  /// grid.style = PdfGridStyle(
  ///     cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///     backgroundBrush: PdfBrushes.blue,
  ///     textBrush: PdfBrushes.white,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridColumnCollection get columns {
    _columns ??= PdfGridColumnCollection(this);
    return _columns!;
  }

  /// Gets the row collection from the PdfGrid.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Set the grid style
  /// grid.style = PdfGridStyle(
  ///     cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///     backgroundBrush: PdfBrushes.blue,
  ///     textBrush: PdfBrushes.white,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridRowCollection get rows {
    _rows ??= PdfGridRowCollection(this);
    return _rows!;
  }

  /// Gets the headers collection from the PdfGrid.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Set the grid style
  /// grid.style = PdfGridStyle(
  ///     cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///     backgroundBrush: PdfBrushes.blue,
  ///     textBrush: PdfBrushes.white,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridHeaderCollection get headers {
    _headers ??= PdfGridHeaderCollection(this);
    return _headers!;
  }

  /// Gets the grid style.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Set the grid style
  /// grid.style = PdfGridStyle(
  ///     cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///     backgroundBrush: PdfBrushes.blue,
  ///     textBrush: PdfBrushes.white,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridStyle get style {
    _style ??= PdfGridStyle();
    return _style!;
  }

  set style(PdfGridStyle value) {
    _style = value;
  }

  //Implementation
  void _initialize() {
    _helper.gridSize = PdfSize.empty;
    _helper.isComplete = false;
    _helper.isDrawn = false;
    _helper.isSingleGrid = true;
    _helper.isWidthSet = false;
    repeatHeader = false;
    allowRowBreakingAcrossPages = true;
    _gridLocation = PdfRectangle.empty;
    _helper.hasColumnSpan = false;
    _helper.hasRowSpan = false;
    _helper.isChildGrid ??= false;
    _helper.isPageWidth = false;
    _helper.isRearranged = false;
    _helper.initialWidth = 0;
    _helper.rowLayoutBoundswidth = 0;
    _helper.listOfNavigatePages = <int>[];
    _helper.parentCellIndex = 0;
    _helper.isBuiltinStyle = false;
    _helper.defaultFont = PdfStandardFont(PdfFontFamily.helvetica, 8);
    _helper.defaultBorder = PdfBorders();
  }

  /// Draws the [PdfGrid]
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  @override
  PdfLayoutResult? draw(
      {Rect? bounds,
      PdfLayoutFormat? format,
      PdfGraphics? graphics,
      PdfPage? page}) {
    final PdfRectangle rectangle =
        bounds != null ? PdfRectangle.fromRect(bounds) : PdfRectangle.empty;
    _helper.initialWidth = rectangle.width == 0
        ? page != null
            ? page.getClientSize().width
            : graphics!.clientSize.width
        : rectangle.width;
    _helper.isWidthSet = true;
    if (page != null) {
      final PdfLayoutResult? result =
          super.draw(page: page, bounds: bounds, format: format);
      _helper.isComplete = true;
      return result;
    } else if (graphics != null) {
      _helper.drawInternal(graphics, rectangle);
    }
    return null;
  }

  /// Apply built-in table style to the table
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// PdfGridBuiltInStyleSettings tableStyleOption =
  ///     PdfGridBuiltInStyleSettings();
  /// tableStyleOption.applyStyleForBandedRows = true;
  /// tableStyleOption.applyStyleForHeaderRow = true;
  ///Apply built-in table style
  /// grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable6ColorfulAccent1,
  ///     settings: tableStyleOption);
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void applyBuiltInStyle(PdfGridBuiltInStyle gridStyle,
      {PdfGridBuiltInStyleSettings? settings}) {
    _intializeBuiltInStyle(gridStyle, settings: settings);
  }

  void _intializeBuiltInStyle(PdfGridBuiltInStyle gridStyle,
      {PdfGridBuiltInStyleSettings? settings}) {
    if (settings != null) {
      _headerRow = settings.applyStyleForHeaderRow;
      _totalRow = settings.applyStyleForLastRow;
      _firstColumn = settings.applyStyleForFirstColumn;
      _lastColumn = settings.applyStyleForLastColumn;
      _bandedColumn = settings.applyStyleForBandedColumns;
      _bandedRow = settings.applyStyleForBandedRows;
    } else {
      _totalRow = false;
      _firstColumn = false;
      _lastColumn = false;
      _bandedColumn = false;
    }
    _helper.isBuiltinStyle = true;
    _helper.gridBuiltinStyle = gridStyle;
  }

  PdfFont? _createBoldFont(PdfFont font) {
    _boldFontCache ??= <PdfTrueTypeFont, PdfTrueTypeFont>{};
    if (font is PdfStandardFont) {
      final PdfStandardFont standardFont = font;
      return PdfStandardFont(standardFont.fontFamily, font.size,
          style: PdfFontStyle.bold);
    } else {
      if (_boldFontCache!.containsKey(font)) {
        return _boldFontCache![font as PdfTrueTypeFont];
      } else {
        final PdfTrueTypeFont trueTypeFont = font as PdfTrueTypeFont;
        final PdfFont boldStyleFont = PdfTrueTypeFont(
            PdfTrueTypeFontHelper.getHelper(trueTypeFont).fontInternal.fontData,
            font.size,
            style: PdfFontStyle.bold);
        _boldFontCache![font] = boldStyleFont as PdfTrueTypeFont;
        return boldStyleFont;
      }
    }
  }

  PdfFont? _createRegularFont(PdfFont font) {
    _regularFontCache ??= <PdfTrueTypeFont, PdfTrueTypeFont>{};
    if (font is PdfStandardFont) {
      final PdfStandardFont standardFont = font;
      return PdfStandardFont(standardFont.fontFamily, font.size,
          style: PdfFontStyle.regular);
    } else {
      if (_regularFontCache!.containsKey(font)) {
        return _regularFontCache![font as PdfTrueTypeFont];
      } else {
        final PdfTrueTypeFont trueTypeFont = font as PdfTrueTypeFont;
        final PdfFont ttfFont = PdfTrueTypeFont(
            PdfTrueTypeFontHelper.getHelper(trueTypeFont).fontInternal.fontData,
            font.size,
            style: PdfFontStyle.regular);
        _regularFontCache![font] = ttfFont as PdfTrueTypeFont;
        return ttfFont;
      }
    }
  }

  PdfFont? _createItalicFont(PdfFont? font) {
    _italicFontCache ??= <PdfTrueTypeFont, PdfTrueTypeFont>{};
    if (font is PdfStandardFont) {
      final PdfStandardFont standardFont = font;
      return PdfStandardFont(standardFont.fontFamily, font.size,
          style: PdfFontStyle.italic);
    } else {
      if (_italicFontCache!.containsKey(font)) {
        return _italicFontCache![font! as PdfTrueTypeFont];
      } else {
        final PdfTrueTypeFont trueTypeFont = font! as PdfTrueTypeFont;
        final PdfFont italicStyleFont = PdfTrueTypeFont(
            PdfTrueTypeFontHelper.getHelper(trueTypeFont).fontInternal.fontData,
            font.size,
            style: PdfFontStyle.italic);
        _italicFontCache![font as PdfTrueTypeFont] =
            italicStyleFont as PdfTrueTypeFont;
        return italicStyleFont;
      }
    }
  }

  PdfFont? _changeFontStyle(PdfFont font) {
    PdfFont? pdfFont;
    if (font.style == PdfFontStyle.regular) {
      pdfFont = _createBoldFont(font);
    } else if (font.style == PdfFontStyle.bold) {
      pdfFont = _createRegularFont(font);
    }
    return pdfFont;
  }

  PdfBrush? _applyBandedColStyle(
      bool firstColumn, PdfColor backColor, int cellIndex) {
    PdfBrush? backBrush;
    if (firstColumn) {
      if (cellIndex.isEven) {
        backBrush = PdfSolidBrush(backColor);
      }
    } else {
      if (cellIndex.isOdd) {
        backBrush = PdfSolidBrush(backColor);
      }
    }
    return backBrush;
  }

  PdfBrush? _applyBandedRowStyle(
      bool headerRow, PdfColor backColor, int rowIndex) {
    PdfBrush? backBrush;
    if (headerRow) {
      if (rowIndex.isOdd) {
        backBrush = PdfSolidBrush(backColor);
      }
    } else {
      if (rowIndex.isEven) {
        backBrush = PdfSolidBrush(backColor);
      }
    }
    return backBrush;
  }

  void _applyTableGridLight(PdfColor borderColor) {
    final PdfPen borderPen = PdfPen(borderColor);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
        }
      }
    }
    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
      }
    }
  }

  void _applyPlainTable1(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = borderPen;
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
            }
          } else {
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              if (_bandedRow) {
                if (i % 2 != 0) {
                  cell.style.backgroundBrush = backBrush;
                }
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);
          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(borderColor);
          if (_bandedColumn) {
            if (!(_lastColumn && j == row.cells.count)) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
          }
        }
      }
    }
  }

  void _applyPlainTable2(PdfColor borderColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfPen emptyPen = PdfPen(PdfColor.empty);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = borderPen;
          if (_bandedColumn) {
            cell.style.borders.left = borderPen;
            cell.style.borders.right = borderPen;
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.bottom = borderPen;
            if (_firstColumn && j == 1) {
              cell.style.borders.left = emptyPen;
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.borders.right = emptyPen;
            }
          } else {
            if (_bandedRow) {
              cell.style.borders.top = borderPen;
              cell.style.borders.bottom = borderPen;
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.borders.left = emptyPen;
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.borders.right = emptyPen;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;
        if (i == rows.count) {
          cell.style.borders.bottom = borderPen;
        }
        if (_bandedColumn) {
          cell.style.borders.left = borderPen;
          cell.style.borders.right = borderPen;
        }
        if (_bandedRow) {
          cell.style.borders.top = borderPen;
          cell.style.borders.bottom = borderPen;
        }
        if (i == rows.count && _totalRow) {
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = borderPen;
          if (_bandedColumn) {
            cell.style.borders.left = borderPen;
            cell.style.borders.right = borderPen;
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.right = emptyPen;
          } else if (_bandedColumn) {
            cell.style.borders.right = emptyPen;
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.left = emptyPen;
          } else if (_bandedColumn) {
            cell.style.borders.left = emptyPen;
          }
        }
      }
    }
  }

  void _applyPlainTable3(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfPen whitePen = PdfPen(PdfColor.empty);
    final PdfBrush backBrush = PdfSolidBrush(backColor);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = whitePen;
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
            if (i == 1) {
              cell.style.borders.bottom = borderPen;
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
            }
          } else {
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
                if (_firstColumn && j == 2) {
                  cell.style.borders.left = borderPen;
                }
                if (_headerRow && i == 1) {
                  cell.style.borders.top = borderPen;
                }
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
              if (cell.value is String) {
                final String cellvalue = cell.value as String;
                cell.value = cellvalue.toUpperCase();
              }
              cell.style.borders.right = borderPen;
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.borders.all = whitePen;
              if (cell.value is String) {
                final String cellvalue = cell.value as String;
                cell.value = cellvalue.toUpperCase();
              }
              if (_bandedColumn) {
                cell.style.backgroundBrush = null;
                if (_bandedRow) {
                  if (i % 2 != 0) {
                    cell.style.backgroundBrush = backBrush;
                  }
                }
              }
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = whitePen;
        if (_bandedRow && _bandedColumn) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (_firstColumn && j == 2) {
            cell.style.borders.left = borderPen;
          }
          if (_headerRow && i == 1) {
            cell.style.borders.top = borderPen;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              if (_firstColumn && j == 2) {
                cell.style.borders.left = borderPen;
              }
              if (_headerRow && i == 1) {
                cell.style.borders.top = borderPen;
              }
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (_firstColumn && j == 2) {
              cell.style.borders.left = borderPen;
            }
            if (_headerRow && i == 1) {
              cell.style.borders.top = borderPen;
            }
          }
        }
        if (i == rows.count && _totalRow) {
          if (_bandedRow) {
            cell.style.borders.all = whitePen;
          }
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          if (cell.value is String) {
            final String cellvalue = cell.value as String;
            cell.value = cellvalue.toUpperCase();
          }
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              if (_firstColumn && j == 2) {
                cell.style.borders.left = borderPen;
              }
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
          }
          cell.style.borders.right = borderPen;
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
            cell.style.backgroundBrush = null;

            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }
            cell.style.borders.all = whitePen;
          } else if (_bandedColumn) {
            cell.style.backgroundBrush = null;
          }
        }

        if (_headerRow && i == 1) {
          cell.style.borders.top = borderPen;
        }
      }
    }
  }

  void _applyPlainTable4(PdfColor backColor) {
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen whitePen = PdfPen(PdfColor.empty);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = whitePen;
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
            }
          } else {
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
              if (cell.value is String) {
                final String cellvalue = cell.value as String;
                cell.value = cellvalue.toUpperCase();
              }
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              if (_bandedRow) {
                if (i % 2 != 0) {
                  cell.style.backgroundBrush = backBrush;
                }
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.borders.all = whitePen;
              cell.style.font = _changeFontStyle(font);
              if (cell.value is String) {
                final String cellvalue = cell.value as String;
                cell.value = cellvalue.toUpperCase();
              }
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = whitePen;
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
          }
        }
        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);
          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.borders.all = whitePen;
            cell.style.font = _changeFontStyle(font);
            if (cell.value is String) {
              final String cellvalue = cell.value as String;
              cell.value = cellvalue.toUpperCase();
            }
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          if (cell.value is String) {
            final String cellvalue = cell.value as String;
            cell.value = cellvalue.toUpperCase();
          }
          if (cell.value is String) {
            final String cellvalue = cell.value as String;
            cell.value = cellvalue.toUpperCase();
          }
          if (_bandedColumn) {
            if (!(_lastColumn && j == row.cells.count)) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
          }
        }
      }
    }
  }

  void _applyPlainTable5(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfPen whitePen = PdfPen(PdfColor.empty);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen backBrushPen = PdfPen(backColor, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = whitePen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            if (font.style != PdfFontStyle.italic) {
              cell.style.font = _createItalicFont(font);
            }
            if (i == 1) {
              cell.style.borders.bottom = borderPen;
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                if (_firstColumn && j == 2) {
                  cell.style.borders.left = borderPen;
                } else {
                  cell.style.borders.all = backBrushPen;
                }
              }
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
                if (_firstColumn && j == 2) {
                  cell.style.borders.left = borderPen;
                } else {
                  cell.style.borders.all = backBrushPen;
                }
              }
            }
            if (_firstColumn && j == 1) {
              cell.style.borders.all = whitePen;
              cell.style.backgroundBrush = null;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              if (font.style != PdfFontStyle.italic) {
                cell.style.font = _createItalicFont(font);
              }
              cell.style.borders.right = borderPen;
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _createItalicFont(font);
              cell.style.borders.all = whitePen;
              cell.style.backgroundBrush = null;
              cell.style.borders.left = borderPen;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = whitePen;
        if (_bandedRow && _bandedColumn) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);
          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (cell.style.backgroundBrush != null) {
            if (_firstColumn && j == 2) {
              cell.style.borders.left = borderPen;
            } else {
              cell.style.borders.all = backBrushPen;
            }
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              if (_firstColumn && j == 2) {
                cell.style.borders.left = borderPen;
              } else {
                cell.style.borders.all = backBrushPen;
              }
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (_firstColumn && j == 2) {
              cell.style.borders.left = borderPen;
            } else {
              cell.style.borders.all = backBrushPen;
            }
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.borders.all = PdfPen(PdfColor.empty);
          cell.style.backgroundBrush = null;
          cell.style.borders.top = borderPen;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          if (font.style != PdfFontStyle.italic) {
            cell.style.font = _createItalicFont(font);
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.borders.all = whitePen;
            cell.style.backgroundBrush = null;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            if (font.style != PdfFontStyle.italic) {
              cell.style.font = _createItalicFont(font);
            }
            cell.style.borders.right = borderPen;
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _createItalicFont(font);
            cell.style.borders.all = whitePen;
            cell.style.backgroundBrush = null;
            cell.style.borders.left = borderPen;
          }
        }

        if (_headerRow && i == 1) {
          cell.style.borders.top = borderPen;
        }
      }
    }
  }

  void _applyGridTable1Light(PdfColor borderColor, PdfColor headerBottomColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          } else {
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        if (_headerRow && i == 1) {
          cell.style.borders.top = PdfPen(headerBottomColor);
        }
        if (_totalRow) {
          if (i == rows.count) {
            cell.style.borders.top = PdfPen(headerBottomColor);
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
      }
    }
  }

  void _applyGridTable2(PdfColor borderColor, PdfColor backColor) {
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen borderPen = PdfPen(borderColor, width: 0.25);
    final PdfPen backColorPen = PdfPen(backColor, width: 0.25);
    final PdfPen emptyPen = PdfPen(PdfColor.empty);
    final PdfPen headerBorder = PdfPen(borderColor);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        row.cells[0].style.borders.bottom = headerBorder;
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          if (j == 1) {
            cell.style.borders.left = emptyPen;
          } else if (j == row.cells.count) {
            cell.style.borders.right = emptyPen;
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = PdfPen(PdfColor.empty);
            if (PdfGridRowHelper.getHelper(
                        PdfGridCellHelper.getHelper(cell).row!)
                    .grid
                    .style
                    .cellSpacing >
                0) {
              cell.style.borders.bottom = headerBorder;
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                if (j == 1) {
                  cell.style.borders.left = backColorPen;
                } else if (row.cells.count % 2 != 0 && j == row.cells.count) {
                  cell.style.borders.right = backColorPen;
                }
              }
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
              if (cell.style.backgroundBrush != null) {
                if (j == 1) {
                  cell.style.borders.left = backColorPen;
                } else if (j == row.cells.count) {
                  cell.style.borders.right = backColorPen;
                }
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              if (_bandedRow) {
                if (i % 2 != 0) {
                  cell.style.backgroundBrush = backBrush;
                }
                if (cell.style.backgroundBrush != null) {
                  if (j == 1) {
                    cell.style.borders.left = backColorPen;
                  } else if (j == row.cells.count) {
                    cell.style.borders.right = backColorPen;
                  }
                }
              }

              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        if (j == 1) {
          cell.style.borders.left = emptyPen;
        } else if (j == row.cells.count) {
          cell.style.borders.right = emptyPen;
        }
        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedRowStyle(_headerRow, backColor, i);
          cell.style.backgroundBrush ??=
              _applyBandedColStyle(_firstColumn, backColor, j);
          if (cell.style.backgroundBrush != null) {
            if (j == 1) {
              cell.style.borders.left = backColorPen;
            } else if (j == row.cells.count) {
              cell.style.borders.right = backColorPen;
            }
          }
        } else {
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);

            if (cell.style.backgroundBrush != null) {
              if (j == 1) {
                cell.style.borders.left = backColorPen;
              } else if (j == row.cells.count) {
                cell.style.borders.right = backColorPen;
              }
            }
          }
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              if (j == 1) {
                cell.style.borders.left = backColorPen;
              } else if (row.cells.count % 2 != 0 && j == row.cells.count) {
                cell.style.borders.right = backColorPen;
              }
            }
          }
        }
        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.backgroundBrush = null;
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = headerBorder;
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.backgroundBrush = null;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
              if (cell.style.backgroundBrush == null) {
                cell.style.borders.right = emptyPen;
              }
            }
          } else if (_bandedColumn) {
            cell.style.backgroundBrush = null;
          }
        }

        if (_headerRow && _headers!.count > 0) {
          if (i == 1) {
            cell.style.borders.top = headerBorder;
          }
        }
      }
    }
  }

  void _applyGridTable3(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen whitePen = PdfPen(PdfColor.empty);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = whitePen;
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = whitePen;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _createItalicFont(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = whitePen;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _createItalicFont(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.all = PdfPen(PdfColor.empty);
          cell.style.backgroundBrush = null;
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = whitePen;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _createItalicFont(font);
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderPen;
            }
          } else {
            cell.style.borders.top = borderPen;
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = whitePen;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _createItalicFont(font);
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderPen;
            }
          } else {
            cell.style.borders.top = borderPen;
          }
        }
      }
    }
  }

  void _applyGridTable4(
      PdfColor borderColor, PdfColor backColor, PdfColor headerBackColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen headerBackColorPen = PdfPen(headerBackColor, width: 0.5);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = PdfPen(headerBackColor);
            cell.style.textBrush = PdfSolidBrush(PdfColor(255, 255, 255));
            cell.style.backgroundBrush = PdfSolidBrush(headerBackColor);
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              if (_bandedColumn) {
                cell.style.backgroundBrush =
                    _applyBandedColStyle(_firstColumn, backColor, j);
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);
          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }

          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(borderColor);
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }

            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          } else if (_bandedColumn) {
            cell.style.backgroundBrush = null;
          }
        }

        if (_headerRow && _headers!.count > 0) {
          if (i == 1) {
            cell.style.borders.top = headerBackColorPen;
          }
        }
      }
    }
  }

  void _applyGridTable5Dark(PdfColor headerBackColor, PdfColor oddRowBackColor,
      PdfColor evenRowBackColor) {
    final PdfPen whitePen = PdfPen(PdfColor(255, 255, 255), width: 0.5);
    final PdfBrush evenRowBrush = PdfSolidBrush(evenRowBackColor);
    final PdfBrush oddRowBrush = PdfSolidBrush(oddRowBackColor);
    final PdfBrush headerBrush = PdfSolidBrush(headerBackColor);
    final PdfBrush textBrush = PdfSolidBrush(PdfColor(255, 255, 255));

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = whitePen;
          cell.style.backgroundBrush = evenRowBrush;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.textBrush = PdfSolidBrush(PdfColor(255, 255, 255));
            cell.style.backgroundBrush = headerBrush;
            cell.style.borders.all = PdfPen(PdfColor.empty, width: 0.5);
            if (j == 1) {
              cell.style.borders.left = whitePen;
            } else if (j == row.cells.count) {
              cell.style.borders.right = whitePen;
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, oddRowBackColor, j);

              cell.style.backgroundBrush ??= evenRowBrush;
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = oddRowBrush;
              }
            }
            if ((_firstColumn && j == 1) ||
                (_lastColumn && j == row.cells.count)) {
              cell.style.backgroundBrush = headerBrush;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.textBrush = textBrush;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = whitePen;
        cell.style.backgroundBrush = evenRowBrush;

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, oddRowBackColor, j);
          if (cell.style.backgroundBrush == null) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, oddRowBackColor, i);

            cell.style.backgroundBrush ??= evenRowBrush;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, oddRowBackColor, j);

            cell.style.backgroundBrush ??= evenRowBrush;
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, oddRowBackColor, i);

            cell.style.backgroundBrush ??= evenRowBrush;
          }
        }
        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.textBrush = textBrush;
          cell.style.backgroundBrush = PdfSolidBrush(headerBackColor);
          cell.style.borders.all = whitePen;
          if (j == 1) {
            cell.style.borders.left = whitePen;
          } else if (j == row.cells.count) {
            cell.style.borders.right = whitePen;
          }
        }

        if ((_firstColumn && j == 1) || (_lastColumn && j == row.cells.count)) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = headerBrush;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.textBrush = textBrush;
          }
        }
      }
    }
  }

  void _applyGridTable6Colorful(
      PdfColor borderColor, PdfColor backColor, PdfColor textColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen headerBottomPen = PdfPen(borderColor);
    final PdfBrush textBrush = PdfSolidBrush(textColor);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = borderPen;
          cell.style.textBrush = textBrush;
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
            }
          } else {
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        cell.style.textBrush = textBrush;

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          if (_bandedColumn && (!(_lastColumn && j == row.cells.count))) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(borderColor);
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }

        if (_headerRow && i == 1) {
          cell.style.borders.top = headerBottomPen;
        }
      }
    }
  }

  void _applyGridTable7Colorful(
      PdfColor borderColor, PdfColor backColor, PdfColor textColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfBrush textBrush = PdfSolidBrush(textColor);
    final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.textBrush = textBrush;
          cell.style.borders.all = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = PdfPen(PdfColor(255, 255, 255));
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }

            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = whitePen;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _createItalicFont(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = whitePen;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _createItalicFont(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];

      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = borderPen;
        cell.style.textBrush = textBrush;
        if (_bandedRow && _bandedColumn) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.all = PdfPen(PdfColor.empty);
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = whitePen;
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderPen;
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _createItalicFont(font);
          } else {
            cell.style.borders.top = borderPen;
          }
        }

        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = whitePen;
            cell.style.borders.left = borderPen;
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderPen;
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _createItalicFont(font);
          } else {
            cell.style.borders.top = borderPen;
          }
        }
      }
    }
  }

  void _applyListTable1Light(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfPen emptyPen = PdfPen(PdfColor.empty);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen backBrushPen = PdfPen(backColor, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);

            if (i == 1) {
              cell.style.borders.bottom = PdfPen(borderColor);
            }
            if (_bandedColumn) {
              if (_lastColumn && j == rows.count) {
                cell.style.backgroundBrush =
                    _applyBandedColStyle(_firstColumn, backColor, j);
              }
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.all = backBrushPen;
              }
              if (_lastColumn && j == row.cells.count) {
                cell.style.borders.all = emptyPen;
                cell.style.backgroundBrush = null;
              }
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.all = backBrushPen;
              }
            }

            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
                cell.style.borders.all = backBrushPen;
              }
            }

            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = emptyPen;
              if (_bandedRow && i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (cell.style.backgroundBrush != null) {
            cell.style.borders.all = backBrushPen;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.all = backBrushPen;
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.all = backBrushPen;
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          } else {
            cell.style.borders.top = borderPen;
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = emptyPen;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          cell.style.borders.all = emptyPen;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          if (_bandedColumn) {
            if (!(_lastColumn && j == row.cells.count)) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.all = backBrushPen;
            }
          }

          cell.style.borders.top = PdfPen(borderColor);
        }

        if (_headerRow && i == 1) {
          cell.style.borders.top = borderPen;
        }
      }
    }
  }

  void _applyListTable2(PdfColor borderColor, PdfColor backColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen backColorPen = PdfPen(backColor, width: 0.5);
    final PdfPen emptyPen = PdfPen(PdfColor.empty, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.borders.bottom = borderPen;
          cell.style.borders.top = borderPen;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (_lastColumn && j == row.cells.count) {
                cell.style.backgroundBrush = null;
              }
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.right = backColorPen;
                cell.style.borders.left = backColorPen;
              }
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.right = backColorPen;
                cell.style.borders.left = backColorPen;
              }
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.borders.left = backColorPen;
                cell.style.borders.right = backColorPen;
                cell.style.backgroundBrush = backBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              cell.style.borders.left = emptyPen;
              cell.style.borders.right = emptyPen;
              if (_bandedRow && i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
                if (cell.style.backgroundBrush != null) {
                  cell.style.borders.left = backColorPen;
                  cell.style.borders.right = backColorPen;
                }
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;
        cell.style.borders.bottom = borderPen;
        cell.style.borders.top = borderPen;
        if (_bandedRow && _bandedColumn) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (cell.style.backgroundBrush != null) {
            cell.style.borders.right = backColorPen;
            cell.style.borders.left = backColorPen;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.right = backColorPen;
              cell.style.borders.left = backColorPen;
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.left = backColorPen;
              cell.style.borders.right = backColorPen;
            }
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = borderPen;
          cell.style.borders.bottom = borderPen;

          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);

          if (_bandedColumn) {
            if (!(j == row.cells.count && _lastColumn)) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
            }
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.right = backColorPen;
              cell.style.borders.left = backColorPen;
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.left = emptyPen;
            cell.style.borders.right = emptyPen;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.right = backColorPen;
              }
            }
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
      }
    }
  }

  void _applyListTable3(PdfColor backColor) {
    final PdfPen backColorPen = PdfPen(backColor, width: 0.5);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen emptyPen = PdfPen(PdfColor.empty, width: 0.5);
    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = backColorPen;
          if (j == 1) {
            cell.style.borders.left = backColorPen;
          } else if (j == row.cells.count) {
            cell.style.borders.right = backColorPen;
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = backColorPen;
            cell.style.backgroundBrush = backBrush;
            cell.style.textBrush = PdfSolidBrush(PdfColor(255, 255, 255));
          } else {
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
          if (_bandedColumn) {
            cell.style.borders.left = backColorPen;
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;
        if (headers.count == 0 && i == 1) {
          cell.style.borders.top = backColorPen;
        }
        if (j == 1) {
          cell.style.borders.left = backColorPen;
        } else if (j == row.cells.count) {
          cell.style.borders.right = backColorPen;
        }
        if (i == rows.count) {
          cell.style.borders.bottom = backColorPen;
        }
        if (_bandedColumn) {
          cell.style.borders.left = backColorPen;
        }
        if (_bandedRow) {
          cell.style.borders.top = backColorPen;
        }
        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(backColor);
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
      }
    }
  }

  void _applyListTable4(
      PdfColor borderColor, PdfColor headerBackColor, PdfColor bandRowColor) {
    final PdfPen borderColorPen = PdfPen(borderColor, width: 0.5);
    final PdfBrush headerBrush = PdfSolidBrush(headerBackColor);
    final PdfBrush bandRowBrush = PdfSolidBrush(bandRowColor);
    final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = whitePen;
          cell.style.borders.top = borderColorPen;
          if (j == 1) {
            cell.style.borders.left = borderColorPen;
          } else if (j == row.cells.count) {
            cell.style.borders.right = borderColorPen;
          }
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.all = PdfPen(headerBackColor, width: 0.5);
            cell.style.backgroundBrush = headerBrush;
            cell.style.textBrush = PdfSolidBrush(PdfColor(255, 255, 255));
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, bandRowColor, j);
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = bandRowBrush;
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;

              if (_bandedRow && i % 2 != 0) {
                cell.style.backgroundBrush = bandRowBrush;
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = whitePen;
        cell.style.borders.top = borderColorPen;
        if (j == 1) {
          cell.style.borders.left = borderColorPen;
        } else if (j == row.cells.count) {
          cell.style.borders.right = borderColorPen;
        }
        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, bandRowColor, j);
          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, bandRowColor, i);
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, bandRowColor, j);
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, bandRowColor, i);
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(borderColor);
          if (_bandedColumn) {
            if (!(_lastColumn && j == rows.count)) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, bandRowColor, j);
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, bandRowColor, i);
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }

        if (i == rows.count) {
          cell.style.borders.bottom = borderColorPen;
        }
      }
    }
  }

  void _applyListTable5Dark(PdfColor backColor) {
    final PdfBrush backColorBrush = PdfSolidBrush(backColor);
    final PdfPen whitePen = PdfPen(PdfColor(255, 255, 255), width: 0.5);
    final PdfBrush whiteBrush = PdfSolidBrush(PdfColor(255, 255, 255));
    final PdfPen emptyPen = PdfPen(PdfColor.empty);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.textBrush = whiteBrush;
          cell.style.backgroundBrush = backColorBrush;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.backgroundBrush = backColorBrush;
            cell.style.textBrush = whiteBrush;
            cell.style.borders.bottom =
                PdfPen(PdfColor(255, 255, 255), width: 2);
            if (_bandedColumn) {
              if (j > 1) {
                cell.style.borders.left = whitePen;
              }
            }
          } else {
            if (_firstColumn) {
              if (j == 1) {
                final PdfFont font = cell.style.font ??
                    row.style.font ??
                    PdfGridRowHelper.getHelper(row).grid.style.font ??
                    _helper.defaultFont;
                cell.style.font = _changeFontStyle(font);
              } else if (j == 2) {
                cell.style.borders.left = whitePen;
              }
            }
            if (_bandedColumn) {
              if (j > 1) {
                cell.style.borders.left = whitePen;
              }
            }
            if (_bandedRow) {
              cell.style.borders.top = whitePen;
            }
            if (_lastColumn && j == row.cells.count) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.borders.left = whitePen;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;
        cell.style.textBrush = whiteBrush;
        cell.style.backgroundBrush = backColorBrush;
        if (_firstColumn) {
          if (!(_totalRow && i == rows.count)) {
            if (j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            } else if (j == 2) {
              cell.style.borders.left = whitePen;
            }
          }
        }
        if (_bandedColumn) {
          if (j > 1) {
            cell.style.borders.left = whitePen;
          }
        }
        if (_bandedRow) {
          cell.style.borders.top = whitePen;
        }
        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = whitePen;
          if (_headerRow) {
            if (_firstColumn && j == 1) {
              cell.style.borders.top = emptyPen;
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.borders.top = emptyPen;
            }
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.left = whitePen;
          }
        }
      }
    }
  }

  void _applyListTable6Colorful(
      PdfColor borderColor, PdfColor backColor, PdfColor textColor) {
    final PdfBrush backColorBrush = PdfSolidBrush(backColor);
    final PdfPen borderColorPen = PdfPen(borderColor, width: 0.5);
    final PdfPen backColorPen = PdfPen(backColor, width: 0.5);
    final PdfPen emptyPen = PdfPen(PdfColor.empty, width: 0.5);
    final PdfBrush textBrush = PdfSolidBrush(textColor);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = borderColorPen;
          cell.style.textBrush = textBrush;
          if (_headerRow) {
            if (_bandedColumn) {
              if (!(_lastColumn && j == row.cells.count)) {
                cell.style.backgroundBrush =
                    _applyBandedColStyle(_firstColumn, backColor, j);
              }
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.left = backColorPen;
                cell.style.borders.right = backColorPen;
              }
            }

            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            cell.style.borders.bottom = borderColorPen;
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                if (i == 1 && _headerRow) {
                  cell.style.borders.top = borderColorPen;
                }
              }
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backColorBrush;
                if (j == 1) {
                  cell.style.borders.left = backColorPen;
                } else if (j == row.cells.count) {
                  cell.style.borders.right = backColorPen;
                }
                if (i == 1) {
                  cell.style.borders.top = borderColorPen;
                }
              }
            }
            if (_firstColumn && j == 1) {
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = emptyPen;
              cell.style.borders.top = borderColorPen;
              if (_bandedRow) {
                if (i % 2 != 0) {
                  cell.style.backgroundBrush = backColorBrush;
                }
              }
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _changeFontStyle(font);
              cell.style.borders.left = emptyPen;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.textBrush = textBrush;
        cell.style.borders.all = emptyPen;
        if (headers.count == 0 && i == 1) {
          cell.style.borders.top = borderColorPen;
        }
        if (i == rows.count) {
          cell.style.borders.bottom = borderColorPen;
        }

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (cell.style.backgroundBrush != null) {
            if (j == 1) {
              cell.style.borders.left = backColorPen;
            } else if (j == row.cells.count) {
              cell.style.borders.right = backColorPen;
            }
          }
          if (i == 1 && _headerRow) {
            cell.style.borders.top = borderColorPen;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.left = backColorPen;
              cell.style.borders.right = backColorPen;
              if (i == 1 && _headerRow) {
                cell.style.borders.top = borderColorPen;
              }
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (j == 1) {
              cell.style.borders.left = backColorPen;
            } else if (j == row.cells.count) {
              cell.style.borders.right = backColorPen;
            }
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderColorPen;
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
          }
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.left = emptyPen;
            cell.style.borders.right = emptyPen;
            if (_bandedRow) {
              cell.style.backgroundBrush =
                  _applyBandedRowStyle(_headerRow, backColor, i);
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.right = backColorPen;
              }
            }

            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _changeFontStyle(font);
            if (i == 1 && _headerRow) {
              cell.style.borders.top = borderColorPen;
            }
          } else if (_bandedColumn) {
            cell.style.backgroundBrush = null;
          }
        }
        if (_totalRow && i == rows.count) {
          cell.style.backgroundBrush = null;
          cell.style.borders.left = emptyPen;
          cell.style.borders.right = emptyPen;
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          cell.style.font = _changeFontStyle(font);
          cell.style.borders.top = PdfPen(borderColor);
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
            }
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.left = backColorPen;
              cell.style.borders.right = backColorPen;
            }
          }
        }
      }
    }
  }

  void _applyListTable7Colorful(
      PdfColor borderColor, PdfColor backColor, PdfColor textColor) {
    final PdfPen borderPen = PdfPen(borderColor, width: 0.5);
    final PdfPen emptyPen = PdfPen(PdfColor.empty);
    final PdfBrush backBrush = PdfSolidBrush(backColor);
    final PdfPen backColorPen = PdfPen(backColor, width: 0.5);
    final PdfBrush textBrush = PdfSolidBrush(textColor);

    if (headers.count > 0) {
      for (int i = 1; i <= headers.count; i++) {
        final PdfGridRow row = headers[i - 1];
        for (int j = 1; j <= row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j - 1];
          cell.style.borders.all = emptyPen;
          cell.style.textBrush = textBrush;
          if (_headerRow) {
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            if (font.style != PdfFontStyle.italic) {
              cell.style.font = _createItalicFont(font);
            }
            if (i == 1) {
              cell.style.borders.bottom = borderPen;
            }
          } else {
            if (_bandedColumn) {
              cell.style.backgroundBrush =
                  _applyBandedColStyle(_firstColumn, backColor, j);
              if (cell.style.backgroundBrush != null) {
                cell.style.borders.all = backColorPen;
              }
            }
            if (_bandedRow) {
              if (i % 2 != 0) {
                cell.style.backgroundBrush = backBrush;
                cell.style.borders.all = backColorPen;
              }
            }
            if (_firstColumn && j == 1) {
              cell.style.backgroundBrush = null;
              cell.style.borders.all = emptyPen;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _createItalicFont(font);
              cell.style.borders.right = borderPen;
            }
            if (_lastColumn && j == row.cells.count) {
              cell.style.backgroundBrush = null;
              final PdfFont font = cell.style.font ??
                  row.style.font ??
                  PdfGridRowHelper.getHelper(row).grid.style.font ??
                  _helper.defaultFont;
              cell.style.font = _createItalicFont(font);
              cell.style.borders.all = emptyPen;
              cell.style.borders.left = borderPen;
            }

            if (_firstColumn && j == 2) {
              cell.style.borders.left = borderPen;
            }
          }
        }
      }
    }

    for (int i = 1; i <= rows.count; i++) {
      final PdfGridRow row = rows[i - 1];
      for (int j = 1; j <= row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j - 1];
        cell.style.borders.all = emptyPen;
        cell.style.textBrush = textBrush;

        if (_bandedColumn && _bandedRow) {
          cell.style.backgroundBrush =
              _applyBandedColStyle(_firstColumn, backColor, j);

          cell.style.backgroundBrush ??=
              _applyBandedRowStyle(_headerRow, backColor, i);
          if (cell.style.backgroundBrush != null) {
            cell.style.borders.all = backColorPen;
          }
        } else {
          if (_bandedColumn) {
            cell.style.backgroundBrush =
                _applyBandedColStyle(_firstColumn, backColor, j);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.all = backColorPen;
            }
          }
          if (_bandedRow) {
            cell.style.backgroundBrush =
                _applyBandedRowStyle(_headerRow, backColor, i);
            if (cell.style.backgroundBrush != null) {
              cell.style.borders.all = backColorPen;
            }
          }
        }
        if (_firstColumn && j == 1) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            cell.style.borders.all = emptyPen;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _createItalicFont(font);
            cell.style.borders.right = borderPen;
          }
        }

        if (_firstColumn && j == 2) {
          cell.style.borders.all = emptyPen;
          cell.style.borders.left = borderPen;
        }

        if (_totalRow && i == rows.count) {
          final PdfFont font = cell.style.font ??
              row.style.font ??
              PdfGridRowHelper.getHelper(row).grid.style.font ??
              _helper.defaultFont;
          if (font.style != PdfFontStyle.italic) {
            cell.style.font = _createItalicFont(font);
          }
          cell.style.borders.all = emptyPen;
          cell.style.borders.top = borderPen;
          cell.style.backgroundBrush = null;
        }
        if (_lastColumn && j == row.cells.count) {
          if (!(_totalRow && i == rows.count)) {
            cell.style.backgroundBrush = null;
            final PdfFont font = cell.style.font ??
                row.style.font ??
                PdfGridRowHelper.getHelper(row).grid.style.font ??
                _helper.defaultFont;
            cell.style.font = _createItalicFont(font);
            cell.style.borders.all = emptyPen;
            cell.style.borders.left = borderPen;
          }
        }
        if (_headerRow && i == 1) {
          cell.style.borders.top = borderPen;
        }
      }
    }
  }
}

/// [PdfGrid] helper
class PdfGridHelper {
  /// internal constructor
  PdfGridHelper(this.base);

  /// internal field
  PdfGrid base;

  /// internal method
  static PdfGridHelper getHelper(PdfGrid base) {
    return base._helper;
  }

  /// internal method
  late PdfBorders defaultBorder;

  /// internal method
  late bool isPageWidth;

  /// internal method
  bool? isChildGrid;

  /// internal method
  late bool hasRowSpan;

  /// internal method
  late bool hasColumnSpan;

  /// internal method
  late bool isSingleGrid;

  /// internal method
  late bool isComplete;

  /// Gets a value indicating whether the start cell layout event should be raised.
  bool get raiseBeginCellLayout => base.beginCellLayout != null;

  /// internal method/// Gets a value indicating whether the end cell layout event should be raised.
  bool get raiseEndCellLayout => base.endCellLayout != null;

  /// internal method
  late bool isBuiltinStyle;

  /// internal method
  late bool isRearranged;

  /// internal method
  late bool isDrawn;

  /// internal method
  late bool isWidthSet;

  /// internal method
  late PdfSize gridSize;

  /// internal method
  late double rowLayoutBoundswidth;

  /// internal method
  late double initialWidth;

  /// internal method
  late PdfFont defaultFont;

  /// internal method
  PdfLayoutFormat? layoutFormat;

  /// internal method
  late int parentCellIndex;

  /// internal method
  late List<int> listOfNavigatePages;

  /// internal method
  PdfGridBuiltInStyle? gridBuiltinStyle;

  /// internal method
  PdfGridCell? parentCell;

  /// internal method
  PdfSize get size {
    if (gridSize == PdfSize.empty) {
      gridSize = _measure();
    }
    return gridSize;
  }

  /// internal method
  PdfSize _measure() {
    double height = 0;
    final double width =
        PdfGridColumnCollectionHelper.getHelper(base.columns).columnWidth;
    for (int i = 0; i < base.headers.count; i++) {
      height += base.headers[i].height;
    }
    for (int i = 0; i < base.rows.count; i++) {
      height += base.rows[i].height;
    }
    return PdfSize(width, height);
  }

  /// internal method
  void setSpan() {
    int colSpan, rowSpan = 1;
    int currentCellIndex, currentRowIndex = 0;
    int maxSpan = 0;
    for (int i = 0; i < base.headers.count; i++) {
      final PdfGridRow row = base.headers[i];
      maxSpan = 0;
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        maxSpan = max(maxSpan, cell.rowSpan);
        if (!PdfGridCellHelper.getHelper(cell).isCellMergeContinue &&
            !PdfGridCellHelper.getHelper(cell).isRowMergeContinue &&
            (cell.columnSpan > 1 || cell.rowSpan > 1)) {
          if (cell.columnSpan + j > row.cells.count) {
            throw ArgumentError.value(
                'Invalid span specified at row $j column $i');
          }
          if (cell.rowSpan + i > base.headers.count) {
            throw ArgumentError.value(
                'Invalid span specified at row $j column $i');
          }
          if (cell.columnSpan > 1 && cell.rowSpan > 1) {
            colSpan = cell.columnSpan;
            rowSpan = cell.rowSpan;
            currentCellIndex = j;
            currentRowIndex = i;
            while (colSpan > 1) {
              currentCellIndex++;
              PdfGridCellHelper.getHelper(row.cells[currentCellIndex])
                  .isCellMergeContinue = true;
              PdfGridCellHelper.getHelper(row.cells[currentCellIndex])
                  .isRowMergeContinue = true;
              row.cells[currentCellIndex].rowSpan = rowSpan;
              colSpan--;
            }
            currentCellIndex = j;
            colSpan = cell.columnSpan;
            while (rowSpan > 1) {
              currentRowIndex++;
              PdfGridCellHelper.getHelper(
                      base.headers[currentRowIndex].cells[j])
                  .isRowMergeContinue = true;
              PdfGridCellHelper.getHelper(
                      base.headers[currentRowIndex].cells[currentCellIndex])
                  .isRowMergeContinue = true;
              rowSpan--;
              while (colSpan > 1) {
                currentCellIndex++;
                PdfGridCellHelper.getHelper(
                        base.headers[currentRowIndex].cells[currentCellIndex])
                    .isCellMergeContinue = true;
                PdfGridCellHelper.getHelper(
                        base.headers[currentRowIndex].cells[currentCellIndex])
                    .isRowMergeContinue = true;
                colSpan--;
              }
              colSpan = cell.columnSpan;
              currentCellIndex = j;
            }
          } else if (cell.columnSpan > 1 && cell.rowSpan == 1) {
            colSpan = cell.columnSpan;
            currentCellIndex = j;
            while (colSpan > 1) {
              currentCellIndex++;
              PdfGridCellHelper.getHelper(row.cells[currentCellIndex])
                  .isCellMergeContinue = true;
              colSpan--;
            }
          } else if (cell.columnSpan == 1 && cell.rowSpan > 1) {
            rowSpan = cell.rowSpan;
            currentRowIndex = i;
            while (rowSpan > 1) {
              currentRowIndex++;
              PdfGridCellHelper.getHelper(
                      base.headers[currentRowIndex].cells[j])
                  .isRowMergeContinue = true;
              rowSpan--;
            }
          }
        }
      }
      PdfGridRowHelper.getHelper(row).maximumRowSpan = maxSpan;
    }
    colSpan = rowSpan = 1;
    currentCellIndex = currentRowIndex = 0;
    if (hasColumnSpan || hasRowSpan) {
      for (int i = 0; i < base.rows.count; i++) {
        final PdfGridRow row = base.rows[i];
        maxSpan = 0;
        for (int j = 0; j < row.cells.count; j++) {
          final PdfGridCell cell = row.cells[j];
          maxSpan = max(maxSpan, cell.rowSpan);
          if (!PdfGridCellHelper.getHelper(cell).isCellMergeContinue &&
              !PdfGridCellHelper.getHelper(cell).isRowMergeContinue &&
              (cell.columnSpan > 1 || cell.rowSpan > 1)) {
            if (cell.columnSpan + j > row.cells.count) {
              throw ArgumentError.value(
                  'Invalid span specified at row $j column $i');
            }
            if (cell.rowSpan + i > base.rows.count) {
              throw ArgumentError.value(
                  'Invalid span specified at row $j column $i');
            }
            if (cell.columnSpan > 1 && cell.rowSpan > 1) {
              colSpan = cell.columnSpan;
              rowSpan = cell.rowSpan;
              currentCellIndex = j;
              currentRowIndex = i;
              while (colSpan > 1) {
                currentCellIndex++;
                PdfGridCellHelper.getHelper(row.cells[currentCellIndex])
                    .isCellMergeContinue = true;
                PdfGridCellHelper.getHelper(row.cells[currentCellIndex])
                    .isRowMergeContinue = true;
                colSpan--;
              }
              currentCellIndex = j;
              colSpan = cell.columnSpan;
              while (rowSpan > 1) {
                currentRowIndex++;
                PdfGridCellHelper.getHelper(base.rows[currentRowIndex].cells[j])
                    .isRowMergeContinue = true;
                PdfGridCellHelper.getHelper(
                        base.rows[currentRowIndex].cells[currentCellIndex])
                    .isRowMergeContinue = true;
                rowSpan--;
                while (colSpan > 1) {
                  currentCellIndex++;
                  PdfGridCellHelper.getHelper(
                          PdfGridRowHelper.getHelper(base.rows[currentRowIndex])
                              .cells![currentCellIndex])
                      .isCellMergeContinue = true;
                  PdfGridCellHelper.getHelper(
                          PdfGridRowHelper.getHelper(base.rows[currentRowIndex])
                              .cells![currentCellIndex])
                      .isRowMergeContinue = true;
                  colSpan--;
                }
                colSpan = cell.columnSpan;
                currentCellIndex = j;
              }
            } else if (cell.columnSpan > 1 && cell.rowSpan == 1) {
              colSpan = cell.columnSpan;
              currentCellIndex = j;
              while (colSpan > 1) {
                currentCellIndex++;
                PdfGridCellHelper.getHelper(row.cells[currentCellIndex])
                    .isCellMergeContinue = true;
                colSpan--;
              }
            } else if (cell.columnSpan == 1 && cell.rowSpan > 1) {
              rowSpan = cell.rowSpan;
              currentRowIndex = i;
              while (rowSpan > 1) {
                currentRowIndex++;
                PdfGridCellHelper.getHelper(base.rows[currentRowIndex].cells[j])
                    .isRowMergeContinue = true;
                rowSpan--;
              }
            }
          }
        }
        PdfGridRowHelper.getHelper(row).maximumRowSpan = maxSpan;
      }
    }
  }

  /// internal method
  void measureColumnsWidth([PdfRectangle? bounds]) {
    if (bounds == null) {
      List<double?> widths = List<double>.filled(base.columns.count, 0);
      double cellWidth = 0;
      if (base.headers.count > 0) {
        for (int i = 0; i < base.headers[0].cells.count; i++) {
          for (int j = 0; j < base.headers.count; j++) {
            cellWidth = max(
                cellWidth,
                initialWidth > 0.0
                    ? min(initialWidth, base.headers[j].cells[i].width)
                    : base.headers[j].cells[i].width);
          }
          widths[i] = cellWidth;
        }
      }
      cellWidth = 0;
      for (int i = 0; i < base.columns.count; i++) {
        for (int j = 0; j < base.rows.count; j++) {
          final bool isGrid = base.rows[j].cells[i].value != null &&
              base.rows[j].cells[i].value is PdfGrid;
          if ((base.rows[j].cells[i].columnSpan == 1 &&
                  !PdfGridCellHelper.getHelper(base.rows[j].cells[i])
                      .isCellMergeContinue) ||
              isGrid) {
            if (isGrid &&
                !PdfGridRowHelper.getHelper(base.rows[j])
                    .grid
                    .style
                    .allowHorizontalOverflow &&
                initialWidth != 0) {
              PdfGridHelper.getHelper(base.rows[j].cells[i].value as PdfGrid)
                      .initialWidth =
                  initialWidth -
                      (PdfGridRowHelper.getHelper(base.rows[j])
                              .grid
                              .style
                              .cellPadding
                              .right +
                          PdfGridRowHelper.getHelper(base.rows[j])
                              .grid
                              .style
                              .cellPadding
                              .left +
                          base.rows[j].cells[i].style.borders.left.width / 2 +
                          base._gridLocation.x);
            }
            cellWidth = max(
                widths[i]!,
                max(
                    cellWidth,
                    initialWidth > 0.0
                        ? min(initialWidth, base.rows[j].cells[i].width)
                        : base.rows[j].cells[i].width));
            cellWidth = max(base.columns[i].width, cellWidth);
          }
        }
        if (base.rows.count != 0) {
          widths[i] = cellWidth;
        }
        cellWidth = 0;
      }
      for (int i = 0; i < base.rows.count; i++) {
        for (int j = 0; j < base.columns.count; j++) {
          if (base.rows[i].cells[j].columnSpan > 1) {
            double totalWidth = widths[j]!;
            for (int k = 1; k < base.rows[i].cells[j].columnSpan; k++) {
              totalWidth = totalWidth + widths[j + k]!;
            }
            if (base.rows[i].cells[j].width > totalWidth) {
              double extendedWidth = base.rows[i].cells[j].width - totalWidth;
              extendedWidth = extendedWidth / base.rows[i].cells[j].columnSpan;
              for (int k = j; k < j + base.rows[i].cells[j].columnSpan; k++) {
                widths[k] = widths[k]! + extendedWidth;
              }
            }
          }
        }
      }
      if (isChildGrid! && initialWidth != 0) {
        widths = PdfGridColumnCollectionHelper.getHelper(base.columns)
            .getDefaultWidths(initialWidth);
      }
      for (int i = 0; i < base.columns.count; i++) {
        if (base.columns[i].width < 0 ||
            (base.columns[i].width > 0 &&
                !PdfGridColumnHelper.getHelper(base.columns[i])
                    .isCustomWidth)) {
          PdfGridColumnHelper.getHelper(base.columns[i]).width = widths[i]!;
        }
      }
    } else {
      List<double?> widths =
          PdfGridColumnCollectionHelper.getHelper(base.columns)
              .getDefaultWidths(bounds.width - bounds.x);
      for (int i = 0; i < base.columns.count; i++) {
        if (base.columns[i].width < 0) {
          PdfGridColumnHelper.getHelper(base.columns[i]).width = widths[i]!;
        } else if (base.columns[i].width > 0 &&
            !PdfGridColumnHelper.getHelper(base.columns[i]).isCustomWidth &&
            widths[i]! > 0 &&
            isComplete) {
          PdfGridColumnHelper.getHelper(base.columns[i]).width = widths[i]!;
        }
      }
      if (parentCell != null &&
          (!base.style.allowHorizontalOverflow) &&
          (!PdfGridRowHelper.getHelper(
                  PdfGridCellHelper.getHelper(parentCell!).row!)
              .grid
              .style
              .allowHorizontalOverflow)) {
        double padding = 0;
        double columnWidth = 0;
        int columnCount = base.columns.count;
        if (parentCell!.style.cellPadding != null) {
          padding += parentCell!.style.cellPadding!.left +
              parentCell!.style.cellPadding!.right;
        } else {
          padding += PdfGridRowHelper.getHelper(
                      PdfGridCellHelper.getHelper(parentCell!).row!)
                  .grid
                  .style
                  .cellPadding
                  .left +
              PdfGridRowHelper.getHelper(
                      PdfGridCellHelper.getHelper(parentCell!).row!)
                  .grid
                  .style
                  .cellPadding
                  .right;
        }
        for (int i = 0; i < parentCell!.columnSpan; i++) {
          columnWidth += PdfGridRowHelper.getHelper(
                  PdfGridCellHelper.getHelper(parentCell!).row!)
              .grid
              .columns[parentCellIndex + i]
              .width;
        }
        for (int i = 0; i < base.columns.count; i++) {
          if (base.columns[i].width > 0 &&
              PdfGridColumnHelper.getHelper(base.columns[i]).isCustomWidth) {
            columnWidth -= base.columns[i].width;
            columnCount--;
          }
        }
        if (columnWidth > padding) {
          final double childGridColumnWidth =
              (columnWidth - padding) / columnCount;
          if (parentCell != null &&
              parentCell!.stringFormat.alignment != PdfTextAlignment.right) {
            for (int j = 0; j < base.columns.count; j++) {
              if (!PdfGridColumnHelper.getHelper(base.columns[j])
                  .isCustomWidth) {
                PdfGridColumnHelper.getHelper(base.columns[j]).width =
                    childGridColumnWidth;
              }
            }
          }
        }
      }
      if (parentCell != null &&
          PdfGridRowHelper.getHelper(
                      PdfGridCellHelper.getHelper(parentCell!).row!)
                  .getWidth() >
              0) {
        if (isChildGrid! &&
            size.width >
                PdfGridRowHelper.getHelper(
                        PdfGridCellHelper.getHelper(parentCell!).row!)
                    .getWidth()) {
          widths = PdfGridColumnCollectionHelper.getHelper(base.columns)
              .getDefaultWidths(bounds.width);
          for (int i = 0; i < base.columns.count; i++) {
            base.columns[i].width = widths[i]!;
          }
        }
      }
    }
  }

  /// internal method
  void onBeginCellLayout(PdfGridBeginCellLayoutArgs args) {
    if (raiseBeginCellLayout) {
      base.beginCellLayout!(base, args);
    }
  }

  /// internal method
  void onEndCellLayout(PdfGridEndCellLayoutArgs args) {
    if (raiseEndCellLayout) {
      base.endCellLayout!(base, args);
    }
  }

  /// internal method
  void drawInternal(PdfGraphics graphics, PdfRectangle bounds) {
    setSpan();
    final PdfGridLayouter layouter = PdfGridLayouter(base);
    layouter.layoutGrid(graphics, bounds);
    isComplete = true;
  }

  /// internal method
  PdfLayoutResult? layout(PdfLayoutParams param) {
    if (param.bounds!.width < 0) {
      ArgumentError.value('width', 'width', 'out of range');
    }
    if (base.rows.count != 0) {
      final PdfBorders borders = base.rows[0].cells[0].style.borders;
      if (borders.left.width != 1) {
        final double x = borders.left.width / 2;
        final double y = borders.top.width / 2;
        if (param.bounds!.x == defaultBorder.right.width / 2 &&
            param.bounds!.y == defaultBorder.right.width / 2) {
          param.bounds = PdfRectangle(x, y, size.width, size.height);
        }
      }
    }
    setSpan();
    layoutFormat = param.format;
    base._gridLocation = param.bounds!;
    return PdfGridLayouter(base).layoutInternal(param);
  }

  /// internal method
  void applyBuiltinStyles(PdfGridBuiltInStyle? gridStyle) {
    switch (gridStyle) {
      case PdfGridBuiltInStyle.tableGrid:
        base._applyTableGridLight(PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.tableGridLight:
        base._applyTableGridLight(PdfColor(191, 191, 191));
        break;

      case PdfGridBuiltInStyle.plainTable1:
        base._applyPlainTable1(
            PdfColor(191, 191, 191), PdfColor(242, 242, 242));
        break;

      case PdfGridBuiltInStyle.plainTable2:
        base._applyPlainTable2(PdfColor(127, 127, 127));
        break;

      case PdfGridBuiltInStyle.plainTable3:
        base._applyPlainTable3(
            PdfColor(127, 127, 127), PdfColor(242, 242, 242));
        break;

      case PdfGridBuiltInStyle.plainTable4:
        base._applyPlainTable4(PdfColor(242, 242, 242));
        break;

      case PdfGridBuiltInStyle.plainTable5:
        base._applyPlainTable5(
            PdfColor(127, 127, 127), PdfColor(242, 242, 242));
        break;
      case PdfGridBuiltInStyle.gridTable1Light:
        base._applyGridTable1Light(
            PdfColor(153, 153, 153), PdfColor(102, 102, 102));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent1:
        base._applyGridTable1Light(
            PdfColor(189, 214, 238), PdfColor(156, 194, 229));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent2:
        base._applyGridTable1Light(
            PdfColor(247, 202, 172), PdfColor(244, 176, 131));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent3:
        base._applyGridTable1Light(
            PdfColor(219, 219, 219), PdfColor(201, 201, 201));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent4:
        base._applyGridTable1Light(
            PdfColor(255, 229, 153), PdfColor(255, 217, 102));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent5:
        base._applyGridTable1Light(
            PdfColor(180, 198, 231), PdfColor(142, 170, 219));
        break;

      case PdfGridBuiltInStyle.gridTable1LightAccent6:
        base._applyGridTable1Light(
            PdfColor(192, 224, 179), PdfColor(168, 208, 141));
        break;

      case PdfGridBuiltInStyle.gridTable2:
        base._applyGridTable2(PdfColor(102, 102, 102), PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent1:
        base._applyGridTable2(PdfColor(156, 194, 229), PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent2:
        base._applyGridTable2(PdfColor(244, 176, 131), PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent3:
        base._applyGridTable2(PdfColor(201, 201, 201), PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent4:
        base._applyGridTable2(PdfColor(255, 217, 102), PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent5:
        base._applyGridTable2(PdfColor(142, 170, 219), PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.gridTable2Accent6:
        base._applyGridTable2(PdfColor(168, 208, 141), PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.gridTable3:
        base._applyGridTable3(PdfColor(102, 102, 102), PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent1:
        base._applyGridTable3(PdfColor(156, 194, 229), PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent2:
        base._applyGridTable3(PdfColor(244, 176, 131), PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent3:
        base._applyGridTable3(PdfColor(201, 201, 201), PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent4:
        base._applyGridTable3(PdfColor(255, 217, 102), PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent5:
        base._applyGridTable3(PdfColor(142, 170, 219), PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.gridTable3Accent6:
        base._applyGridTable3(PdfColor(168, 208, 141), PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.gridTable4:
        base._applyGridTable4(PdfColor(102, 102, 102), PdfColor(204, 204, 204),
            PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent1:
        base._applyGridTable4(PdfColor(156, 194, 229), PdfColor(222, 234, 246),
            PdfColor(91, 155, 213));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent2:
        base._applyGridTable4(PdfColor(244, 176, 131), PdfColor(251, 228, 213),
            PdfColor(237, 125, 49));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent3:
        base._applyGridTable4(PdfColor(201, 201, 201), PdfColor(237, 237, 237),
            PdfColor(165, 165, 165));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent4:
        base._applyGridTable4(PdfColor(255, 217, 102), PdfColor(255, 242, 204),
            PdfColor(255, 192, 0));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent5:
        base._applyGridTable4(PdfColor(142, 170, 219), PdfColor(217, 226, 243),
            PdfColor(68, 114, 196));
        break;

      case PdfGridBuiltInStyle.gridTable4Accent6:
        base._applyGridTable4(PdfColor(168, 208, 141), PdfColor(226, 239, 217),
            PdfColor(112, 173, 71));
        break;

      case PdfGridBuiltInStyle.gridTable5Dark:
        base._applyGridTable5Dark(PdfColor(0, 0, 0), PdfColor(153, 153, 153),
            PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent1:
        base._applyGridTable5Dark(PdfColor(91, 155, 213),
            PdfColor(189, 214, 238), PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent2:
        base._applyGridTable5Dark(PdfColor(237, 125, 49),
            PdfColor(247, 202, 172), PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent3:
        base._applyGridTable5Dark(PdfColor(165, 165, 165),
            PdfColor(219, 219, 219), PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent4:
        base._applyGridTable5Dark(PdfColor(255, 192, 0),
            PdfColor(255, 229, 153), PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent5:
        base._applyGridTable5Dark(PdfColor(68, 114, 196),
            PdfColor(180, 198, 231), PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.gridTable5DarkAccent6:
        base._applyGridTable5Dark(PdfColor(112, 171, 71),
            PdfColor(197, 224, 179), PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.gridTable6Colorful:
        base._applyGridTable6Colorful(PdfColor(102, 102, 102),
            PdfColor(204, 204, 204), PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent1:
        base._applyGridTable6Colorful(PdfColor(156, 194, 229),
            PdfColor(222, 234, 246), PdfColor(46, 116, 181));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent2:
        base._applyGridTable6Colorful(PdfColor(244, 176, 131),
            PdfColor(251, 228, 213), PdfColor(196, 89, 17));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent3:
        base._applyGridTable6Colorful(PdfColor(201, 201, 201),
            PdfColor(237, 237, 237), PdfColor(123, 123, 123));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent4:
        base._applyGridTable6Colorful(PdfColor(255, 217, 102),
            PdfColor(255, 242, 204), PdfColor(191, 143, 0));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent5:
        base._applyGridTable6Colorful(PdfColor(142, 170, 219),
            PdfColor(217, 226, 243), PdfColor(47, 84, 150));
        break;

      case PdfGridBuiltInStyle.gridTable6ColorfulAccent6:
        base._applyGridTable6Colorful(PdfColor(168, 208, 141),
            PdfColor(226, 239, 217), PdfColor(83, 129, 53));
        break;

      case PdfGridBuiltInStyle.gridTable7Colorful:
        base._applyGridTable7Colorful(PdfColor(102, 102, 102),
            PdfColor(204, 204, 204), PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent1:
        base._applyGridTable7Colorful(PdfColor(156, 194, 229),
            PdfColor(222, 234, 246), PdfColor(46, 116, 181));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent2:
        base._applyGridTable7Colorful(PdfColor(244, 176, 131),
            PdfColor(251, 228, 213), PdfColor(196, 89, 17));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent3:
        base._applyGridTable7Colorful(PdfColor(201, 201, 201),
            PdfColor(237, 237, 237), PdfColor(123, 123, 123));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent4:
        base._applyGridTable7Colorful(PdfColor(255, 217, 102),
            PdfColor(255, 242, 204), PdfColor(191, 143, 0));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent5:
        base._applyGridTable7Colorful(PdfColor(142, 170, 219),
            PdfColor(217, 226, 243), PdfColor(47, 84, 150));
        break;

      case PdfGridBuiltInStyle.gridTable7ColorfulAccent6:
        base._applyGridTable7Colorful(PdfColor(168, 208, 141),
            PdfColor(226, 239, 217), PdfColor(83, 129, 53));
        break;
      case PdfGridBuiltInStyle.listTable1Light:
        base._applyListTable1Light(
            PdfColor(102, 102, 102), PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent1:
        base._applyListTable1Light(
            PdfColor(156, 194, 229), PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent2:
        base._applyListTable1Light(
            PdfColor(244, 176, 131), PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent3:
        base._applyListTable1Light(
            PdfColor(201, 201, 201), PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent4:
        base._applyListTable1Light(
            PdfColor(255, 217, 102), PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent5:
        base._applyListTable1Light(
            PdfColor(142, 170, 219), PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.listTable1LightAccent6:
        base._applyListTable1Light(
            PdfColor(168, 208, 141), PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.listTable2:
        base._applyListTable2(PdfColor(102, 102, 102), PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.listTable2Accent1:
        base._applyListTable2(PdfColor(156, 194, 229), PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.listTable2Accent2:
        base._applyListTable2(PdfColor(244, 176, 131), PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.listTable2Accent3:
        base._applyListTable2(PdfColor(201, 201, 201), PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.listTable2Accent4:
        base._applyListTable2(PdfColor(255, 217, 102), PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.listTable2Accent5:
        base._applyListTable2(PdfColor(142, 170, 219), PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.listTable2Accent6:
        base._applyListTable2(PdfColor(168, 208, 141), PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.listTable3:
        base._applyListTable3(PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.listTable3Accent1:
        base._applyListTable3(PdfColor(91, 155, 213));
        break;

      case PdfGridBuiltInStyle.listTable3Accent2:
        base._applyListTable3(PdfColor(237, 125, 49));
        break;

      case PdfGridBuiltInStyle.listTable3Accent3:
        base._applyListTable3(PdfColor(165, 165, 165));
        break;

      case PdfGridBuiltInStyle.listTable3Accent4:
        base._applyListTable3(PdfColor(255, 192, 0));
        break;

      case PdfGridBuiltInStyle.listTable3Accent5:
        base._applyListTable3(PdfColor(68, 114, 196));
        break;

      case PdfGridBuiltInStyle.listTable3Accent6:
        base._applyListTable3(PdfColor(112, 171, 71));
        break;

      case PdfGridBuiltInStyle.listTable4:
        base._applyListTable4(PdfColor(102, 102, 102), PdfColor(0, 0, 0),
            PdfColor(204, 204, 204));
        break;

      case PdfGridBuiltInStyle.listTable4Accent1:
        base._applyListTable4(PdfColor(156, 194, 229), PdfColor(91, 155, 213),
            PdfColor(222, 234, 246));
        break;

      case PdfGridBuiltInStyle.listTable4Accent2:
        base._applyListTable4(PdfColor(244, 176, 131), PdfColor(237, 125, 49),
            PdfColor(251, 228, 213));
        break;

      case PdfGridBuiltInStyle.listTable4Accent3:
        base._applyListTable4(PdfColor(201, 201, 201), PdfColor(165, 165, 165),
            PdfColor(237, 237, 237));
        break;

      case PdfGridBuiltInStyle.listTable4Accent4:
        base._applyListTable4(PdfColor(255, 217, 102), PdfColor(255, 192, 0),
            PdfColor(255, 242, 204));
        break;

      case PdfGridBuiltInStyle.listTable4Accent5:
        base._applyListTable4(PdfColor(142, 170, 219), PdfColor(68, 114, 196),
            PdfColor(217, 226, 243));
        break;

      case PdfGridBuiltInStyle.listTable4Accent6:
        base._applyListTable4(PdfColor(168, 208, 141), PdfColor(112, 173, 71),
            PdfColor(226, 239, 217));
        break;

      case PdfGridBuiltInStyle.listTable5Dark:
        base._applyListTable5Dark(PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent1:
        base._applyListTable5Dark(PdfColor(91, 155, 213));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent2:
        base._applyListTable5Dark(PdfColor(237, 125, 49));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent3:
        base._applyListTable5Dark(PdfColor(165, 165, 165));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent4:
        base._applyListTable5Dark(PdfColor(255, 192, 0));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent5:
        base._applyListTable5Dark(PdfColor(68, 114, 196));
        break;

      case PdfGridBuiltInStyle.listTable5DarkAccent6:
        base._applyListTable5Dark(PdfColor(112, 173, 71));
        break;

      case PdfGridBuiltInStyle.listTable6Colorful:
        base._applyListTable6Colorful(PdfColor(102, 102, 102),
            PdfColor(204, 204, 204), PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent1:
        base._applyListTable6Colorful(PdfColor(91, 155, 213),
            PdfColor(222, 234, 246), PdfColor(46, 116, 181));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent2:
        base._applyListTable6Colorful(PdfColor(237, 125, 49),
            PdfColor(251, 228, 213), PdfColor(196, 89, 17));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent3:
        base._applyListTable6Colorful(PdfColor(165, 165, 165),
            PdfColor(237, 237, 237), PdfColor(123, 123, 123));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent4:
        base._applyListTable6Colorful(PdfColor(255, 192, 0),
            PdfColor(255, 242, 204), PdfColor(191, 143, 0));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent5:
        base._applyListTable6Colorful(PdfColor(68, 114, 196),
            PdfColor(217, 226, 243), PdfColor(47, 84, 150));
        break;

      case PdfGridBuiltInStyle.listTable6ColorfulAccent6:
        base._applyListTable6Colorful(PdfColor(112, 173, 71),
            PdfColor(226, 239, 217), PdfColor(83, 129, 53));
        break;

      case PdfGridBuiltInStyle.listTable7Colorful:
        base._applyListTable7Colorful(PdfColor(102, 102, 102),
            PdfColor(204, 204, 204), PdfColor(0, 0, 0));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent1:
        base._applyListTable7Colorful(PdfColor(91, 155, 213),
            PdfColor(222, 234, 246), PdfColor(46, 116, 181));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent2:
        base._applyListTable7Colorful(PdfColor(237, 125, 49),
            PdfColor(251, 228, 213), PdfColor(196, 89, 17));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent3:
        base._applyListTable7Colorful(PdfColor(165, 165, 165),
            PdfColor(237, 237, 237), PdfColor(123, 123, 123));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent4:
        base._applyListTable7Colorful(PdfColor(255, 192, 0),
            PdfColor(255, 242, 204), PdfColor(191, 143, 0));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent5:
        base._applyListTable7Colorful(PdfColor(68, 114, 196),
            PdfColor(217, 226, 243), PdfColor(47, 84, 150));
        break;

      case PdfGridBuiltInStyle.listTable7ColorfulAccent6:
        base._applyListTable7Colorful(PdfColor(112, 173, 71),
            PdfColor(226, 239, 217), PdfColor(83, 129, 53));
        break;

      // ignore: no_default_cases
      default:
    }
  }
}

/// Delegate for handling StartCellLayoutEvent.
typedef PdfGridBeginCellLayoutCallback = void Function(
    Object sender, PdfGridBeginCellLayoutArgs args);

/// Delegate for handling EndCellLayoutEvent.
typedef PdfGridEndCellLayoutCallback = void Function(
    Object sender, PdfGridEndCellLayoutArgs args);

/// Represents arguments of StartCellLayout Event.
class PdfGridBeginCellLayoutArgs extends GridCellLayoutArgs {
  //Constructor
  PdfGridBeginCellLayoutArgs._(
      PdfGraphics graphics,
      int rowIndex,
      int cellInder,
      PdfRectangle bounds,
      String value,
      PdfGridCellStyle? style,
      bool isHeaderRow)
      : super._(graphics, rowIndex, cellInder, bounds, value, isHeaderRow) {
    if (style != null) {
      this.style = style;
    }
    skip = false;
  }
  //Fields
  /// PDF grid cell style
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// //Apply the cell style to specific row cells
  /// row.cells[0].style = PdfGridCellStyle(
  ///   backgroundBrush: PdfBrushes.lightYellow,
  ///   cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
  ///   font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
  ///   textBrush: PdfBrushes.white,
  ///   textPen: PdfPens.orange,
  /// );
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGridCellStyle? style;

  /// A value that indicates whether the cell is drawn or not in the PDF document.
  late bool skip;
}

// ignore: avoid_classes_with_only_static_members
/// [PdfGridBeginCellLayoutArgs] helper
class PdfGridBeginCellLayoutArgsHelper {
  /// internal method
  static PdfGridBeginCellLayoutArgs load(
      PdfGraphics graphics,
      int rowIndex,
      int cellInder,
      PdfRectangle bounds,
      String value,
      PdfGridCellStyle? style,
      bool isHeaderRow) {
    return PdfGridBeginCellLayoutArgs._(
        graphics, rowIndex, cellInder, bounds, value, style, isHeaderRow);
  }
}

/// Represents arguments of EndCellLayout Event.
class PdfGridEndCellLayoutArgs extends GridCellLayoutArgs {
  //Constructor
  PdfGridEndCellLayoutArgs._(
      PdfGraphics graphics,
      int rowIndex,
      int cellInder,
      PdfRectangle bounds,
      String value,
      PdfGridCellStyle? style,
      bool isHeaderRow)
      : super._(graphics, rowIndex, cellInder, bounds, value, isHeaderRow) {
    if (style != null) {
      this.style = style;
    }
  }
  //Fields
  /// PDF grid cell style
  PdfGridCellStyle? style;
}

// ignore: avoid_classes_with_only_static_members
/// [PdfGridEndCellLayoutArgs] helper
class PdfGridEndCellLayoutArgsHelper {
  /// internal method
  static PdfGridEndCellLayoutArgs load(
      PdfGraphics graphics,
      int rowIndex,
      int cellInder,
      PdfRectangle bounds,
      String value,
      PdfGridCellStyle? style,
      bool isHeaderRow) {
    return PdfGridEndCellLayoutArgs._(
        graphics, rowIndex, cellInder, bounds, value, style, isHeaderRow);
  }
}

/// Represents the abstract class of the [GridCellLayoutArgs].
abstract class GridCellLayoutArgs {
  //Constructors
  /// Initializes a new instance of the [StartCellLayoutArgs] class.
  GridCellLayoutArgs._(PdfGraphics graphics, int rowIndex, int cellIndex,
      PdfRectangle bounds, String value, bool isHeaderRow) {
    _rowIndex = rowIndex;
    _cellIndex = cellIndex;
    _value = value;
    _bounds = bounds.rect;
    _graphics = graphics;
    _isHeaderRow = isHeaderRow;
  }

  //Fields
  late int _rowIndex;
  late int _cellIndex;
  late String _value;
  late Rect _bounds;
  late PdfGraphics _graphics;
  late bool _isHeaderRow;

  //Properties
  /// Gets the index of the row.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// // Sets the event raised on starting cell lay outing.
  /// grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
  ///   if (args.rowIndex == 1 && args.cellIndex == 1) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  ///   if (args.isHeaderRow && args.cellIndex == 0) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  /// };
  /// grid.style.cellPadding = PdfPaddings();
  /// grid.style.cellPadding.all = 15;
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get rowIndex => _rowIndex;

  /// Gets the index of the cell.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// // Sets the event raised on starting cell lay outing.
  /// grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
  ///   if (args.rowIndex == 1 && args.cellIndex == 1) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  ///   if (args.isHeaderRow && args.cellIndex == 0) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  /// };
  /// grid.style.cellPadding = PdfPaddings();
  /// grid.style.cellPadding.all = 15;
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get cellIndex => _cellIndex;

  /// Gets the value.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// // Sets the event raised on starting cell lay outing.
  /// grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
  ///   if (args.rowIndex == 1 && args.cellIndex == 1) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  ///   if (args.isHeaderRow && args.cellIndex == 0) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  /// };
  /// grid.style.cellPadding = PdfPaddings();
  /// grid.style.cellPadding.all = 15;
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String get value => _value;

  /// Gets the bounds of the cell.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// // Sets the event raised on starting cell lay outing.
  /// grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
  ///   if (args.rowIndex == 1 && args.cellIndex == 1) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  ///   if (args.isHeaderRow && args.cellIndex == 0) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  /// };
  /// grid.style.cellPadding = PdfPaddings();
  /// grid.style.cellPadding.all = 15;
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Rect get bounds => _bounds;

  /// Gets the graphics, on which the cell should be drawn.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// // Sets the event raised on starting cell lay outing.
  /// grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
  ///   if (args.rowIndex == 1 && args.cellIndex == 1) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  ///   if (args.isHeaderRow && args.cellIndex == 0) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  /// };
  /// grid.style.cellPadding = PdfPaddings();
  /// grid.style.cellPadding.all = 15;
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGraphics get graphics => _graphics;

  /// Gets the type of Grid row.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// // Sets the event raised on starting cell lay outing.
  /// grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
  ///   if (args.rowIndex == 1 && args.cellIndex == 1) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  ///   if (args.isHeaderRow && args.cellIndex == 0) {
  ///     args.graphics.drawRectangle(
  ///         pen: PdfPen(PdfColor(250, 100, 0), width: 2),
  ///         brush: PdfBrushes.white,
  ///         bounds: args.bounds);
  ///   }
  /// };
  /// grid.style.cellPadding = PdfPaddings();
  /// grid.style.cellPadding.all = 15;
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: Rect.zero);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool get isHeaderRow => _isHeaderRow;
}

/// Arguments of BeginPageLayoutEvent.
class PdfGridBeginPageLayoutArgs extends BeginPageLayoutArgs {
  //Constructor
  PdfGridBeginPageLayoutArgs._(super.bounds, super.page, int? startRow) {
    startRowIndex = startRow ?? 0;
  }

  //Fields
  /// Gets the start row index.
  late int startRowIndex;
}

// ignore: avoid_classes_with_only_static_members
/// [PdfGridBeginPageLayoutArgs] helper
class PdfGridBeginPageLayoutArgsHelper {
  /// internal method
  static PdfGridBeginPageLayoutArgs load(
      Rect bounds, PdfPage page, int? startRow) {
    return PdfGridBeginPageLayoutArgs._(bounds, page, startRow);
  }
}

/// Arguments of EndPageLayoutEvent.
class PdfGridEndPageLayoutArgs extends EndPageLayoutArgs {
  //Constructor
  PdfGridEndPageLayoutArgs._(super.result);
}

// ignore: avoid_classes_with_only_static_members
/// [PdfGridEndPageLayoutArgs] helper
class PdfGridEndPageLayoutArgsHelper {
  /// internal method
  static PdfGridEndPageLayoutArgs load(PdfLayoutResult result) {
    return PdfGridEndPageLayoutArgs._(result);
  }
}

/// Represents the grid built-in style settings.
class PdfGridBuiltInStyleSettings {
  // Constructor
  /// Represents the grid built-in style settings.
  PdfGridBuiltInStyleSettings(
      {this.applyStyleForBandedColumns = false,
      this.applyStyleForBandedRows = true,
      this.applyStyleForFirstColumn = false,
      this.applyStyleForHeaderRow = true,
      this.applyStyleForLastColumn = false,
      this.applyStyleForLastRow = false});

  //Fields
  /// Gets or sets a value indicating whether to apply style bands to the columns in a table.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// PdfGridBuiltInStyleSettings tableStyleOption =
  ///     PdfGridBuiltInStyleSettings();
  /// //Sets applyStyleForBandedColumns
  /// tableStyleOption.applyStyleForBandedColumns = true;
  ///Apply built-in table style
  /// grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable6ColorfulAccent1,
  ///     settings: tableStyleOption);
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool applyStyleForBandedColumns;

  /// Gets or sets a value indicating whether to apply style bands to the rows in a table.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// PdfGridBuiltInStyleSettings tableStyleOption =
  ///     PdfGridBuiltInStyleSettings();
  /// //Sets applyStyleForBandedRows
  /// tableStyleOption.applyStyleForBandedRows = true;
  ///Apply built-in table style
  /// grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable6ColorfulAccent1,
  ///     settings: tableStyleOption);
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool applyStyleForBandedRows;

  /// Gets or sets a value indicating whether to apply first-column formatting to the first column of the specified table.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// PdfGridBuiltInStyleSettings tableStyleOption =
  ///     PdfGridBuiltInStyleSettings();
  /// //Sets applyStyleForFirstColumn
  /// tableStyleOption.applyStyleForFirstColumn = true;
  ///Apply built-in table style
  /// grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable6ColorfulAccent1,
  ///     settings: tableStyleOption);
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool applyStyleForFirstColumn;

  ///  Gets or sets a value indicating whether to apply heading-row formatting to the first row of the table.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// PdfGridBuiltInStyleSettings tableStyleOption =
  ///     PdfGridBuiltInStyleSettings();
  /// //Sets applyStyleForHeaderRow
  /// tableStyleOption.applyStyleForHeaderRow = true;
  ///Apply built-in table style
  /// grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable6ColorfulAccent1,
  ///     settings: tableStyleOption);
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool applyStyleForHeaderRow;

  /// Gets or sets a value indicating whether to apply first-column formatting to the first column of the specified table.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// PdfGridBuiltInStyleSettings tableStyleOption =
  ///     PdfGridBuiltInStyleSettings();
  /// //Sets applyStyleForLastColumn
  /// tableStyleOption.applyStyleForLastColumn = true;
  ///Apply built-in table style
  /// grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable6ColorfulAccent1,
  ///     settings: tableStyleOption);
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool applyStyleForLastColumn;

  /// Gets or sets a value indicating whether to apply last-row formatting to the last row of the specified table.
  /// ```dart
  /// //Create a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Create a PdfGrid class
  /// PdfGrid grid = PdfGrid();
  /// //Add the columns to the grid
  /// grid.columns.add(count: 3);
  /// //Add header to the grid
  /// grid.headers.add(1);
  /// //Add the rows to the grid
  /// PdfGridRow header = grid.headers[0];
  /// header.cells[0].value = 'Employee ID';
  /// header.cells[1].value = 'Employee Name';
  /// header.cells[2].value = 'Salary';
  /// //Add rows to grid
  /// PdfGridRow row = grid.rows.add();
  /// row.cells[0].value = 'E01';
  /// row.cells[1].value = 'Clay';
  /// row.cells[2].value = '\$10,000';
  /// row = grid.rows.add();
  /// row.cells[0].value = 'E02';
  /// row.cells[1].value = 'Simon';
  /// row.cells[2].value = '\$12,000';
  /// PdfGridBuiltInStyleSettings tableStyleOption =
  ///     PdfGridBuiltInStyleSettings();
  /// //Sets applyStyleForLastRow
  /// tableStyleOption.applyStyleForLastRow = true;
  ///Apply built-in table style
  /// grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable6ColorfulAccent1,
  ///     settings: tableStyleOption);
  /// //Draw the grid
  /// grid.draw(
  ///     page: document.pages.add(), bounds: const Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool applyStyleForLastRow;
}
