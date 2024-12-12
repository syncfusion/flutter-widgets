import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/drawing/drawing.dart';
import '../pdf/implementation/structured_elements/grid/pdf_grid.dart';
import '../pdf/implementation/structured_elements/grid/pdf_grid_cell.dart';
import '../pdf/implementation/structured_elements/grid/pdf_grid_row.dart';

// ignore: avoid_relative_lib_imports
import 'images.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pdfGrid() {
  group('Single Grid', () {
    //Header styles
    test('Headers', () {
      //Single header row
      final PdfDocument document = PdfDocument();
      final PdfImage image = PdfBitmap.fromBase64String(logoJpeg);

      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = 'Row - 2 Cell - 1';
      row2_1.cells[1].value = 'Row - 2 Cell - 2';
      row2_1.cells[2].value = 'Row - 2 Cell - 3';
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);

      //Multiple header rows
      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = 'Header - 1 Cell - 2';
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = 'Row - 1 Cell - 1';
      row1_2.cells[1].value = 'Row - 1 Cell - 2';
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';
      grid2.draw(page: document.pages.add(), bounds: Rect.zero);

      //Headers alone
      final PdfGrid grid3 = PdfGrid();
      grid3.columns.add(count: 3);
      grid3.headers.add(2);
      final PdfGridRow header1_3 = grid3.headers[0];
      header1_3.cells[0].value = 'Header - 1 Cell - 1';
      header1_3.cells[1].value = 'Header - 1 Cell - 2';
      header1_3.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_3 = grid3.headers[1];
      header2_3.cells[0].value = 'Header - 2 Cell - 1';
      header2_3.cells[1].value = 'Header - 2 Cell - 2';
      header2_3.cells[2].value = 'Header - 2 Cell - 3';
      grid3.draw(page: document.pages.add(), bounds: Rect.zero);

      //Multi line text in header
      final PdfGrid grid4 = PdfGrid();
      grid4.columns.add(count: 1);
      grid4.columns.add(column: PdfGridColumn(grid4));
      grid4.columns.add();
      grid4.headers.add(3);
      final PdfGridRow header1_4 = grid4.headers[0];
      header1_4.cells[0].value = 'Header - 1 Cell - 1\r\nMultiple line text';
      header1_4.cells[1].value = 'Header - 1 Cell - 2';
      header1_4.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_4 = grid4.headers[1];
      header2_4.cells[0].value = 'Header - 2 Cell - 1';
      header2_4.cells[1].value = 'Header - 2 Cell - 2\r\nMultiple line text';
      header2_4.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow header3_4 = grid4.headers[2];
      header3_4.cells[0].value = 'Header - 2 Cell - 1';
      header3_4.cells[1].value = 'Header - 2 Cell - 2';
      header3_4.cells[2].value = 'Header - 2 Cell - 3\r\nMultiple line text';
      final PdfGridRow row1_4 = grid4.rows.add();
      row1_4.cells[0].value = 'Row - 1 Cell - 1';
      row1_4.cells[1].value = 'Row - 1 Cell - 2';
      row1_4.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_4 = grid4.rows.add();
      row2_4.cells[0].value = 'Row - 2 Cell - 1';
      row2_4.cells[1].value = 'Row - 2 Cell - 2';
      row2_4.cells[2].value = 'Row - 2 Cell - 3';
      grid4.draw(page: document.pages.add(), bounds: Rect.zero);

      //Cell styles
      final PdfGrid grid5 = PdfGrid();
      grid5.columns.add(count: 3);
      grid5.headers.add(1);
      final PdfGridRow header1_5 = grid5.headers[0];
      final PdfStringFormat headerStringCenterFormat1_5 = PdfStringFormat();
      headerStringCenterFormat1_5.alignment = PdfTextAlignment.center;
      headerStringCenterFormat1_5.lineAlignment = PdfVerticalAlignment.bottom;
      headerStringCenterFormat1_5.wordSpacing = 10;
      final PdfGridCellStyle headerCellStyle1_5 = PdfGridCellStyle(
          backgroundBrush: PdfBrushes.gray,
          borders: PdfBorders(
              left: PdfPen(PdfColor(240, 0, 0), width: 2),
              top: PdfPen(PdfColor(0, 240, 0), width: 3),
              bottom: PdfPen(PdfColor(0, 0, 240), width: 4),
              right: PdfPen(PdfColor(240, 100, 240), width: 5)),
          cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
          font: PdfStandardFont(PdfFontFamily.timesRoman, 25),
          format: headerStringCenterFormat1_5,
          textBrush: PdfBrushes.white,
          textPen: PdfPens.black);
      header1_5.cells[0].value = 'Header - 1 Cell - 1';
      header1_5.cells[0].style = headerCellStyle1_5;
      header1_5.cells[1].value = 'Header - 1 Cell - 2';
      header1_5.cells[1].style = PdfGridCellStyle(backgroundImage: image);
      header1_5.cells[2].value = 'Header - 1 Cell - 3';
      header1_5.cells[2].style = headerCellStyle1_5;
      final PdfGridRow row1_5 = grid5.rows.add();
      row1_5.cells[0].value = 'Row - 1 Cell - 1';
      row1_5.cells[0].rowSpan = 1;
      row1_5.cells[0].columnSpan = 1;
      row1_5.cells[0].style = headerCellStyle1_5;
      row1_5.cells[0].stringFormat = headerStringCenterFormat1_5;
      row1_5.cells[1].value = 'Row - 1 Cell - 2';
      row1_5.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_5 = grid5.rows.add();
      row2_5.cells[0].value = 'Row - 2 Cell - 1';
      row2_5.cells[1].value = 'Row - 2 Cell - 2';
      row2_5.cells[2].value = 'Row - 2 Cell - 3';
      grid5.draw(page: document.pages.add(), bounds: Rect.zero);

      //Row styles
      final PdfGrid grid6 = PdfGrid();
      grid6.columns.add(count: 3);
      grid6.headers.add(1);
      final PdfGridRow header1_6 = grid6.headers[0];
      header1_6.style = PdfGridRowStyle(
          backgroundBrush: PdfBrushes.lightGray,
          textPen: PdfPens.black,
          textBrush: PdfBrushes.white,
          font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
      header1_6.cells[0].value = 'Header - 1 Cell - 1';
      header1_6.cells[1].value = 'Header - 1 Cell - 2';
      header1_6.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_6 = grid6.rows.add();
      row1_6.cells[0].value = 'Row - 1 Cell - 1';
      row1_6.cells[1].value = 'Row - 1 Cell - 2';
      row1_6.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_6 = grid6.rows.add();
      row2_6.cells[0].value = 'Row - 2 Cell - 1';
      row2_6.cells[1].value = 'Row - 2 Cell - 2';
      row2_6.cells[2].value = 'Row - 2 Cell - 3';
      grid6.draw(page: document.pages.add(), bounds: Rect.zero);

      //Grid style
      final PdfGrid grid7 = PdfGrid();
      final PdfGridStyle gridStyle_7 = PdfGridStyle(
          cellSpacing: 2,
          cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
          borderOverlapStyle: PdfBorderOverlapStyle.inside,
          backgroundBrush: PdfBrushes.lightGray,
          textPen: PdfPens.black,
          textBrush: PdfBrushes.white,
          font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
      grid7.columns.add(count: 3);
      grid7.headers.add(1);
      final PdfGridRow header1_7 = grid7.headers[0];
      header1_7.cells[0].value = 'Header - 1 Cell - 1';
      header1_7.cells[1].value = 'Header - 1 Cell - 2';
      header1_7.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_7 = grid7.rows.add();
      row1_7.cells[0].value = 'Row - 1 Cell - 1';
      row1_7.cells[1].value = 'Row - 1 Cell - 2';
      row1_7.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_7 = grid7.rows.add();
      row2_7.cells[0].value = 'Row - 2 Cell - 1';
      row2_7.cells[1].value = 'Row - 2 Cell - 2';
      row2_7.cells[2].value = 'Row - 2 Cell - 3';
      grid7.style = gridStyle_7;
      grid7.draw(page: document.pages.add(), bounds: Rect.zero);

      //Image drawing in header row
      final PdfGrid grid8 = PdfGrid();
      grid8.columns.add(count: 3);
      grid8.headers.add(1);
      final PdfGridRow header1_8 = grid8.headers[0];
      header1_8.cells[0].value = image;
      header1_8.cells[1].value = image;
      header1_8.cells[2].value = image;
      final PdfGridRow row1_8 = grid8.rows.add();
      row1_8.cells[0].value = 'Row - 1 Cell - 1';
      row1_8.cells[1].value = 'Row - 1 Cell - 2';
      row1_8.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_8 = grid8.rows.add();
      row2_8.cells[0].value = 'Row - 2 Cell - 1';
      row2_8.cells[1].value = 'Row - 2 Cell - 2';
      row2_8.cells[2].value = 'Row - 2 Cell - 3';
      grid8.draw(page: document.pages.add(), bounds: Rect.zero);

      final PdfTextElement element = PdfTextElement();
      element.text = 'Text Element Text';
      element.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);

      //TextElement drawing in header row
      final PdfGrid grid9 = PdfGrid();
      grid9.columns.add(count: 3);
      grid9.columns[0].format = PdfStringFormat();
      grid9.columns[0].format.alignment = PdfTextAlignment.center;
      grid9.headers.add(1);
      final PdfGridRow header1_9 = grid9.headers[0];
      header1_9.cells[0].value = element;
      header1_9.cells[1].value = element;
      header1_9.cells[2].value = element;
      final PdfGridRow row1_9 = grid9.columns[0].grid.rows.add();
      row1_9.cells[0].value = 'Row - 1 Cell - 1';
      row1_9.cells[1].value = 'Row - 1 Cell - 2';
      row1_9.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_9 = grid9.rows.add();
      row2_9.cells[0].value = 'Row - 2 Cell - 1';
      row2_9.cells[1].value = 'Row - 2 Cell - 2';
      row2_9.cells[2].value = 'Row - 2 Cell - 3';
      grid9.draw(page: document.pages.add(), bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_1.pdf');
    });
    //Header row - page pagination with empty bounds
    test('Headers-PaginationWithPage_1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(500);
      for (int i = 0; i < 500; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_2.pdf');
    });
    //Header row - graphics pagination with empty bounds
    test('Headers-PaginationWithGraphics_1', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(500);
      for (int i = 0; i < 500; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(graphics: document.pages.add().graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_3.pdf');
    });
    //Header styles - 0 margins
    test('Headers-0-margins', () {
      //Single header row
      final PdfDocument document = PdfDocument();
      final PdfImage image = PdfBitmap.fromBase64String(logoJpeg);
      document.pageSettings.margins.all = 0;
      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = 'Row - 2 Cell - 1';
      row2_1.cells[1].value = 'Row - 2 Cell - 2';
      row2_1.cells[2].value = 'Row - 2 Cell - 3';
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);

      //Multiple header rows
      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = 'Header - 1 Cell - 2';
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = 'Row - 1 Cell - 1';
      row1_2.cells[1].value = 'Row - 1 Cell - 2';
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';
      grid2.draw(page: document.pages.add(), bounds: Rect.zero);

      //Headers alone
      final PdfGrid grid3 = PdfGrid();
      grid3.columns.add(count: 3);
      grid3.headers.add(2);
      final PdfGridRow header1_3 = grid3.headers[0];
      header1_3.cells[0].value = 'Header - 1 Cell - 1';
      header1_3.cells[1].value = 'Header - 1 Cell - 2';
      header1_3.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_3 = grid3.headers[1];
      header2_3.cells[0].value = 'Header - 2 Cell - 1';
      header2_3.cells[1].value = 'Header - 2 Cell - 2';
      header2_3.cells[2].value = 'Header - 2 Cell - 3';
      grid3.draw(page: document.pages.add(), bounds: Rect.zero);

      //Multi line text in header
      final PdfGrid grid4 = PdfGrid();
      grid4.columns.add(count: 3);
      grid4.headers.add(3);
      final PdfGridRow header1_4 = grid4.headers[0];
      header1_4.cells[0].value = 'Header - 1 Cell - 1\r\nMultiple line text';
      header1_4.cells[1].value = 'Header - 1 Cell - 2';
      header1_4.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_4 = grid4.headers[1];
      header2_4.cells[0].value = 'Header - 2 Cell - 1';
      header2_4.cells[1].value = 'Header - 2 Cell - 2\r\nMultiple line text';
      header2_4.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow header3_4 = grid4.headers[2];
      header3_4.cells[0].value = 'Header - 2 Cell - 1';
      header3_4.cells[1].value = 'Header - 2 Cell - 2';
      header3_4.cells[2].value = 'Header - 2 Cell - 3\r\nMultiple line text';
      final PdfGridRow row1_4 = grid4.rows.add();
      row1_4.cells[0].value = 'Row - 1 Cell - 1';
      row1_4.cells[1].value = 'Row - 1 Cell - 2';
      row1_4.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_4 = grid4.rows.add();
      row2_4.cells[0].value = 'Row - 2 Cell - 1';
      row2_4.cells[1].value = 'Row - 2 Cell - 2';
      row2_4.cells[2].value = 'Row - 2 Cell - 3';
      grid4.draw(page: document.pages.add(), bounds: Rect.zero);

      //Cell styles
      final PdfGrid grid5 = PdfGrid();
      grid5.columns.add(count: 3);
      grid5.headers.add(1);
      final PdfGridRow header1_5 = grid5.headers[0];
      final PdfGridCellStyle headerCellStyle1_5 = PdfGridCellStyle();
      headerCellStyle1_5.backgroundBrush = PdfBrushes.gray;
      final PdfBorders headerBorder1_5 = PdfBorders();
      headerBorder1_5.left = PdfPen(PdfColor(240, 0, 0), width: 2);
      headerBorder1_5.top = PdfPen(PdfColor(0, 240, 0), width: 3);
      headerBorder1_5.bottom = PdfPen(PdfColor(0, 0, 240), width: 4);
      headerBorder1_5.right = PdfPen(PdfColor(240, 100, 240), width: 5);
      headerCellStyle1_5.borders = headerBorder1_5;
      headerCellStyle1_5.cellPadding =
          PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      headerCellStyle1_5.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      final PdfStringFormat headerStringCenterFormat1_5 = PdfStringFormat();
      headerStringCenterFormat1_5.alignment = PdfTextAlignment.center;
      headerStringCenterFormat1_5.lineAlignment = PdfVerticalAlignment.bottom;
      headerStringCenterFormat1_5.wordSpacing = 10;
      headerCellStyle1_5.stringFormat = headerStringCenterFormat1_5;
      headerCellStyle1_5.textBrush = PdfBrushes.white;
      headerCellStyle1_5.textPen = PdfPens.black;
      header1_5.cells[0].value = 'Header - 1 Cell - 1';
      header1_5.cells[0].style = headerCellStyle1_5;
      header1_5.cells[1].value = 'Header - 1 Cell - 2';
      header1_5.cells[1].style.backgroundImage = image;
      header1_5.cells[2].value = 'Header - 1 Cell - 3';
      header1_5.cells[2].style = headerCellStyle1_5;
      final PdfGridRow row1_5 = grid5.rows.add();
      row1_5.cells[0].value = 'Row - 1 Cell - 1';
      row1_5.cells[1].value = 'Row - 1 Cell - 2';
      row1_5.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_5 = grid5.rows.add();
      row2_5.cells[0].value = 'Row - 2 Cell - 1';
      row2_5.cells[1].value = 'Row - 2 Cell - 2';
      row2_5.cells[2].value = 'Row - 2 Cell - 3';
      grid5.draw(page: document.pages.add(), bounds: Rect.zero);

      //Row styles
      final PdfGrid grid6 = PdfGrid();
      grid6.columns.add(count: 3);
      grid6.headers.add(1);
      final PdfGridRow header1_6 = grid6.headers[0];
      final PdfGridRowStyle gridHeaderStyle_6 = PdfGridRowStyle();
      gridHeaderStyle_6.backgroundBrush = PdfBrushes.lightGray;
      gridHeaderStyle_6.textPen = PdfPens.black;
      gridHeaderStyle_6.textBrush = PdfBrushes.white;
      gridHeaderStyle_6.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      header1_6.style = gridHeaderStyle_6;
      header1_6.cells[0].value = 'Header - 1 Cell - 1';
      header1_6.cells[1].value = 'Header - 1 Cell - 2';
      header1_6.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_6 = grid6.rows.add();
      row1_6.cells[0].value = 'Row - 1 Cell - 1';
      row1_6.cells[1].value = 'Row - 1 Cell - 2';
      row1_6.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_6 = grid6.rows.add();
      row2_6.cells[0].value = 'Row - 2 Cell - 1';
      row2_6.cells[1].value = 'Row - 2 Cell - 2';
      row2_6.cells[2].value = 'Row - 2 Cell - 3';
      grid6.draw(graphics: document.pages.add().graphics, bounds: Rect.zero);

      //Grid style
      final PdfGrid grid7 = PdfGrid();
      final PdfGridStyle gridStyle_7 = PdfGridStyle();
      gridStyle_7.cellSpacing = 2;
      gridStyle_7.cellPadding =
          PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      gridStyle_7.borderOverlapStyle = PdfBorderOverlapStyle.inside;
      gridStyle_7.backgroundBrush = PdfBrushes.lightGray;
      gridStyle_7.textPen = PdfPens.black;
      gridStyle_7.textBrush = PdfBrushes.white;
      gridStyle_7.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      grid7.columns.add(count: 3);
      grid7.headers.add(1);
      final PdfGridRow header1_7 = grid7.headers[0];
      header1_7.cells[0].value = 'Header - 1 Cell - 1';
      header1_7.cells[1].value = 'Header - 1 Cell - 2';
      header1_7.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_7 = grid7.rows.add();
      row1_7.cells[0].value = 'Row - 1 Cell - 1';
      row1_7.cells[1].value = 'Row - 1 Cell - 2';
      row1_7.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_7 = grid7.rows.add();
      row2_7.cells[0].value = 'Row - 2 Cell - 1';
      row2_7.cells[1].value = 'Row - 2 Cell - 2';
      row2_7.cells[2].value = 'Row - 2 Cell - 3';
      grid7.style = gridStyle_7;
      grid7.draw(graphics: document.pages.add().graphics, bounds: Rect.zero);

      //Image drawing in header row
      final PdfGrid grid8 = PdfGrid();
      grid8.columns.add(count: 3);
      grid8.headers.add(1);
      final PdfGridRow header1_8 = grid8.headers[0];
      header1_8.cells[0].value = image;
      header1_8.cells[1].value = image;
      header1_8.cells[2].value = image;
      final PdfGridRow row1_8 = grid8.rows.add();
      row1_8.cells[0].value = 'Row - 1 Cell - 1';
      row1_8.cells[1].value = 'Row - 1 Cell - 2';
      row1_8.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_8 = grid8.rows.add();
      row2_8.cells[0].value = 'Row - 2 Cell - 1';
      row2_8.cells[1].value = 'Row - 2 Cell - 2';
      row2_8.cells[2].value = 'Row - 2 Cell - 3';
      grid8.draw(page: document.pages.add(), bounds: Rect.zero);

      final PdfTextElement element = PdfTextElement();
      element.text = 'Text Element Text';
      element.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);

      //TextElement drawing in header row
      final PdfGrid grid9 = PdfGrid();
      grid9.columns.add(count: 3);
      grid9.headers.add(1);
      final PdfGridRow header1_9 = grid9.headers[0];
      header1_9.cells[0].value = element;
      header1_9.cells[1].value = element;
      header1_9.cells[2].value = element;
      final PdfGridRow row1_9 = grid9.rows.add();
      row1_9.cells[0].value = 'Row - 1 Cell - 1';
      row1_9.cells[1].value = 'Row - 1 Cell - 2';
      row1_9.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_9 = grid9.rows.add();
      row2_9.cells[0].value = 'Row - 2 Cell - 1';
      row2_9.cells[1].value = 'Row - 2 Cell - 2';
      row2_9.cells[2].value = 'Row - 2 Cell - 3';
      grid9.draw(page: document.pages.add(), bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_4.pdf');
    });
    //Header row - page pagination with bounds
    test('Headers-PaginationWithPage_2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(500);
      for (int i = 0; i < 500; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: const Rect.fromLTWH(100, 100, 400, 300));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_5.pdf');
    });
    //Header row - graphics pagination with bounds
    test('Headers-PaginationWithGraphics_2', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(500);
      for (int i = 0; i < 500; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(
          graphics: document.pages.add().graphics,
          bounds: const Rect.fromLTWH(100, 100, 400, 300));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_6.pdf');
    });
    //Header row - page pagination bounds with empty bounds
    test('Headers-PaginationWithPage_3', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(500);
      for (int i = 0; i < 500; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.paginateBounds = const Rect.fromLTWH(100, 100, 400, 300);
      grid.draw(page: page, bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_7.pdf');
    });
    //Header row - graphics pagination bounds with empty bounds
    test('Headers-PaginationWithGraphics_3', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(500);
      for (int i = 0; i < 500; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.paginateBounds = const Rect.fromLTWH(100, 100, 400, 300);
      grid.draw(
          graphics: document.pages.add().graphics,
          bounds: Rect.zero,
          format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_8.pdf');
    });
    //Header row - page pagination bounds with bounds
    test('Headers-PaginationWithPage_4', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(500);
      for (int i = 0; i < 500; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.paginateBounds = const Rect.fromLTWH(100, 100, 400, 300);
      grid.draw(
          page: page,
          bounds: const Rect.fromLTWH(100, 100, 400, 300),
          format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_9.pdf');
    });
    //Header row - graphics pagination bounds with bounds
    test('Headers-PaginationWithGraphics_5', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(500);
      for (int i = 0; i < 500; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.paginateBounds = const Rect.fromLTWH(100, 100, 400, 300);
      grid.draw(
          graphics: document.pages.add().graphics,
          bounds: const Rect.fromLTWH(100, 100, 400, 300),
          format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_10.pdf');
    });
    //Header row - Allow horizontal overflow - next page (with page overload)
    test('Headers-HorizontalOverflow-NextPage-Page', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 20);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
        header.cells[3].value = 'Header - $i Cell - 4';
        header.cells[4].value = 'Header - $i Cell - 5';
        header.cells[5].value = 'Header - $i Cell - 6';
        header.cells[6].value = 'Header - $i Cell - 7';
        header.cells[7].value = 'Header - $i Cell - 8';
        header.cells[8].value = 'Header - $i Cell - 9';
        header.cells[9].value = 'Header - $i Cell - 10';
        header.cells[10].value = 'Header - $i Cell - 11';
        header.cells[11].value = 'Header - $i Cell - 12';
        header.cells[12].value = 'Header - $i Cell - 13';
        header.cells[13].value = 'Header - $i Cell - 14';
        header.cells[14].value = 'Header - $i Cell - 15';
        header.cells[15].value = 'Header - $i Cell - 16';
        header.cells[16].value = 'Header - $i Cell - 17';
        header.cells[17].value = 'Header - $i Cell - 18';
        header.cells[18].value = 'Header - $i Cell - 19';
        header.cells[19].value = 'Header - $i Cell - 20';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = 'Row - 1 Cell - 6';
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      row1.cells[10].value = 'Row - 1 Cell - 11';
      row1.cells[11].value = 'Row - 1 Cell - 12';
      row1.cells[12].value = 'Row - 1 Cell - 13';
      row1.cells[13].value = 'Row - 1 Cell - 14';
      row1.cells[14].value = 'Row - 1 Cell - 15';
      row1.cells[15].value = 'Row - 1 Cell - 16';
      row1.cells[16].value = 'Row - 1 Cell - 17';
      row1.cells[17].value = 'Row - 1 Cell - 18';
      row1.cells[18].value = 'Row - 1 Cell - 19';
      row1.cells[19].value = 'Row - 1 Cell - 20';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = 'Row - 2 Cell - 6';
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      row2.cells[10].value = 'Row - 2 Cell - 11';
      row2.cells[11].value = 'Row - 2 Cell - 12';
      row2.cells[12].value = 'Row - 2 Cell - 13';
      row2.cells[13].value = 'Row - 2 Cell - 14';
      row2.cells[14].value = 'Row - 2 Cell - 15';
      row2.cells[15].value = 'Row - 2 Cell - 16';
      row2.cells[16].value = 'Row - 2 Cell - 17';
      row2.cells[17].value = 'Row - 2 Cell - 18';
      row2.cells[18].value = 'Row - 2 Cell - 19';
      row2.cells[19].value = 'Row - 2 Cell - 20';
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_11.pdf');
    });
    //Header row - Allow horizontal overflow - last page (with page overload)
    test('Headers-HorizontalOverflow-LastPage-Page', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 20);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
        header.cells[3].value = 'Header - $i Cell - 4';
        header.cells[4].value = 'Header - $i Cell - 5';
        header.cells[5].value = 'Header - $i Cell - 6';
        header.cells[6].value = 'Header - $i Cell - 7';
        header.cells[7].value = 'Header - $i Cell - 8';
        header.cells[8].value = 'Header - $i Cell - 9';
        header.cells[9].value = 'Header - $i Cell - 10';
        header.cells[10].value = 'Header - $i Cell - 11';
        header.cells[11].value = 'Header - $i Cell - 12';
        header.cells[12].value = 'Header - $i Cell - 13';
        header.cells[13].value = 'Header - $i Cell - 14';
        header.cells[14].value = 'Header - $i Cell - 15';
        header.cells[15].value = 'Header - $i Cell - 16';
        header.cells[16].value = 'Header - $i Cell - 17';
        header.cells[17].value = 'Header - $i Cell - 18';
        header.cells[18].value = 'Header - $i Cell - 19';
        header.cells[19].value = 'Header - $i Cell - 20';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = 'Row - 1 Cell - 6';
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      row1.cells[10].value = 'Row - 1 Cell - 11';
      row1.cells[11].value = 'Row - 1 Cell - 12';
      row1.cells[12].value = 'Row - 1 Cell - 13';
      row1.cells[13].value = 'Row - 1 Cell - 14';
      row1.cells[14].value = 'Row - 1 Cell - 15';
      row1.cells[15].value = 'Row - 1 Cell - 16';
      row1.cells[16].value = 'Row - 1 Cell - 17';
      row1.cells[17].value = 'Row - 1 Cell - 18';
      row1.cells[18].value = 'Row - 1 Cell - 19';
      row1.cells[19].value = 'Row - 1 Cell - 20';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = 'Row - 2 Cell - 6';
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      row2.cells[10].value = 'Row - 2 Cell - 11';
      row2.cells[11].value = 'Row - 2 Cell - 12';
      row2.cells[12].value = 'Row - 2 Cell - 13';
      row2.cells[13].value = 'Row - 2 Cell - 14';
      row2.cells[14].value = 'Row - 2 Cell - 15';
      row2.cells[15].value = 'Row - 2 Cell - 16';
      row2.cells[16].value = 'Row - 2 Cell - 17';
      row2.cells[17].value = 'Row - 2 Cell - 18';
      row2.cells[18].value = 'Row - 2 Cell - 19';
      row2.cells[19].value = 'Row - 2 Cell - 20';
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_12.pdf');
    });

    //Row styles
    test('Rows', () {
      //Single content row
      final PdfDocument document = PdfDocument();
      final PdfImage image = PdfBitmap.fromBase64String(logoJpeg);

      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);

      //Multiple content rows
      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = 'Header - 1 Cell - 2';
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = 'Row - 1 Cell - 1';
      row1_2.cells[1].value = 'Row - 1 Cell - 2';
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';
      grid2.draw(page: document.pages.add(), bounds: Rect.zero);

      //contents alone
      final PdfGrid grid3 = PdfGrid();
      grid3.columns.add(count: 3);
      final PdfGridRow row1_3 = grid3.rows.add();
      row1_3.cells[0].value = 'Row - 1 Cell - 1';
      row1_3.cells[1].value = 'Row - 1 Cell - 2';
      row1_3.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_3 = grid3.rows.add();
      row2_3.cells[0].value = 'Row - 2 Cell - 1';
      row2_3.cells[1].value = 'Row - 2 Cell - 2';
      row2_3.cells[2].value = 'Row - 2 Cell - 3';
      grid3.draw(page: document.pages.add(), bounds: Rect.zero);

      //Multi line text in content row
      final PdfGrid grid4 = PdfGrid();
      grid4.columns.add(count: 3);
      grid4.headers.add(3);
      final PdfGridRow header1_4 = grid4.headers[0];
      header1_4.cells[0].value = 'Header - 1 Cell - 1';
      header1_4.cells[1].value = 'Header - 1 Cell - 2';
      header1_4.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_4 = grid4.headers[1];
      header2_4.cells[0].value = 'Header - 2 Cell - 1';
      header2_4.cells[1].value = 'Header - 2 Cell - 2\r\nMultiple line text';
      header2_4.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow header3_4 = grid4.headers[2];
      header3_4.cells[0].value = 'Header - 2 Cell - 1';
      header3_4.cells[1].value = 'Header - 2 Cell - 2';
      header3_4.cells[2].value = 'Header - 2 Cell - 3\r\nMultiple line text';
      final PdfGridRow row1_4 = grid4.rows.add();
      row1_4.cells[0].value = 'Row - 1 Cell - 1\r\nMultiple line text';
      row1_4.cells[1].value = 'Row - 1 Cell - 2';
      row1_4.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_4 = grid4.rows.add();
      row2_4.cells[0].value = 'Row - 2 Cell - 1';
      row2_4.cells[1].value = 'Row - 2 Cell - 2\r\nMultiple line text';
      row2_4.cells[2].value = 'Row - 2 Cell - 3';
      final PdfGridRow row3_4 = grid4.rows.add();
      row3_4.cells[0].value = 'Row - 3 Cell - 1';
      row3_4.cells[1].value = 'Row - 3 Cell - 2';
      row3_4.cells[2].value = 'Row - 3 Cell - 3\r\nMultiple line text';
      grid4.draw(page: document.pages.add(), bounds: Rect.zero);

      //Cell styles
      final PdfGrid grid5 = PdfGrid();
      grid5.columns.add(count: 3);
      grid5.headers.add(1);
      final PdfGridRow header1_5 = grid5.headers[0];
      final PdfGridCellStyle rowCellStyle1_5 = PdfGridCellStyle();
      rowCellStyle1_5.backgroundBrush = PdfBrushes.gray;
      final PdfBorders headerBorder1_5 = PdfBorders(
          left: PdfPens.red,
          top: PdfPens.black,
          right: PdfPens.green,
          bottom: PdfPens.blue);
      rowCellStyle1_5.borders = headerBorder1_5;
      rowCellStyle1_5.borders.all = PdfPen(PdfColor(245, 0, 0), width: 2);
      rowCellStyle1_5.cellPadding =
          PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      rowCellStyle1_5.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      final PdfStringFormat headerStringCenterFormat1_5 = PdfStringFormat();
      headerStringCenterFormat1_5.alignment = PdfTextAlignment.center;
      headerStringCenterFormat1_5.lineAlignment = PdfVerticalAlignment.bottom;
      headerStringCenterFormat1_5.wordSpacing = 10;
      rowCellStyle1_5.stringFormat = headerStringCenterFormat1_5;
      rowCellStyle1_5.textBrush = PdfBrushes.white;
      rowCellStyle1_5.textPen = PdfPens.black;
      header1_5.cells[0].value = 'Header - 1 Cell - 1';
      header1_5.cells[1].value = 'Header - 1 Cell - 2';
      header1_5.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_5 = grid5.rows.add();
      row1_5.cells[0].value = 'Row - 1 Cell - 1';
      row1_5.cells[0].style = rowCellStyle1_5;
      row1_5.cells[1].value = 'Row - 1 Cell - 2';
      row1_5.cells[1].style.backgroundImage = image;
      row1_5.cells[2].value = 'Row - 1 Cell - 3';
      row1_5.cells[2].style = rowCellStyle1_5;
      final PdfGridRow row2_5 = grid5.rows.add();
      row2_5.cells[0].value = 'Row - 2 Cell - 1';
      row2_5.cells[1].value = 'Row - 2 Cell - 2';
      row2_5.cells[1].style = rowCellStyle1_5;
      row2_5.cells[2].value = 'Row - 2 Cell - 3';
      grid5.draw(page: document.pages.add(), bounds: Rect.zero);

      //Row styles
      final PdfGrid grid6 = PdfGrid();
      grid6.columns.add(count: 3);
      grid6.headers.add(1);
      final PdfGridRow header1_6 = grid6.headers[0];
      final PdfGridRowStyle gridRowStyle_6 = PdfGridRowStyle();
      gridRowStyle_6.backgroundBrush = PdfBrushes.lightGray;
      gridRowStyle_6.textPen = PdfPens.black;
      gridRowStyle_6.textBrush = PdfBrushes.white;
      gridRowStyle_6.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      header1_6.cells[0].value = 'Header - 1 Cell - 1';
      header1_6.cells[1].value = 'Header - 1 Cell - 2';
      header1_6.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_6 = grid6.rows.add();
      row1_6.style = gridRowStyle_6;
      row1_6.cells[0].value = 'Row - 1 Cell - 1';
      row1_6.cells[1].value = 'Row - 1 Cell - 2';
      row1_6.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_6 = grid6.rows.add();
      row2_6.cells[0].value = 'Row - 2 Cell - 1';
      row2_6.cells[1].value = 'Row - 2 Cell - 2';
      row2_6.cells[2].value = 'Row - 2 Cell - 3';
      grid6.draw(page: document.pages.add(), bounds: Rect.zero);

      //Grid style
      final PdfGrid grid7 = PdfGrid();
      final PdfGridStyle gridStyle_7 = PdfGridStyle();
      gridStyle_7.cellSpacing = 2;
      gridStyle_7.cellPadding =
          PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      gridStyle_7.borderOverlapStyle = PdfBorderOverlapStyle.inside;
      gridStyle_7.backgroundBrush = PdfBrushes.lightGray;
      gridStyle_7.textPen = PdfPens.black;
      gridStyle_7.textBrush = PdfBrushes.white;
      gridStyle_7.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      grid7.columns.add(count: 3);
      grid7.headers.add(1);
      final PdfGridRow header1_7 = grid7.headers[0];
      header1_7.cells[0].value = 'Header - 1 Cell - 1';
      header1_7.cells[1].value = 'Header - 1 Cell - 2';
      header1_7.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_7 = grid7.rows.add();
      row1_7.cells[0].value = 'Row - 1 Cell - 1';
      row1_7.cells[1].value = 'Row - 1 Cell - 2';
      row1_7.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_7 = grid7.rows.add();
      row2_7.cells[0].value = 'Row - 2 Cell - 1';
      row2_7.cells[1].value = 'Row - 2 Cell - 2';
      row2_7.cells[2].value = 'Row - 2 Cell - 3';
      grid7.style = gridStyle_7;
      grid7.draw(page: document.pages.add(), bounds: Rect.zero);

      //Image drawing in content row
      final PdfGrid grid8 = PdfGrid();
      grid8.columns.add(count: 3);
      grid8.headers.add(1);
      final PdfGridRow header1_8 = grid8.headers[0];
      header1_8.cells[0].value = 'Header - 1 Cell - 1';
      header1_8.cells[1].value = 'Header - 1 Cell - 2';
      header1_8.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_8 = grid8.rows.add();
      row1_8.cells[0].value = image;
      row1_8.cells[1].value = image;
      row1_8.cells[2].value = image;
      final PdfGridRow row2_8 = grid8.rows.add();
      row2_8.cells[0].value = 'Row - 2 Cell - 1';
      row2_8.cells[1].value = 'Row - 2 Cell - 2';
      row2_8.cells[2].value = 'Row - 2 Cell - 3';
      grid8.draw(page: document.pages.add(), bounds: Rect.zero);

      final PdfTextElement element = PdfTextElement();
      element.text = 'Text Element Text';
      element.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);

      //TextElement drawing in header row
      final PdfGrid grid9 = PdfGrid();
      grid9.columns.add(count: 3);
      grid9.headers.add(1);
      final PdfGridRow header1_9 = grid9.headers[0];
      header1_9.cells[0].value = 'Header - 1 Cell - 1';
      header1_9.cells[1].value = 'Header - 1 Cell - 2';
      header1_9.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_9 = grid9.rows.add();
      row1_9.cells[0].value = element;
      row1_9.cells[1].value = element;
      row1_9.cells[2].value = element;
      final PdfGridRow row2_9 = grid9.rows.add();
      row2_9.cells[0].value = 'Row - 2 Cell - 1';
      row2_9.cells[1].value = 'Row - 2 Cell - 2';
      row2_9.cells[2].value = 'Row - 2 Cell - 3';
      grid9.draw(page: document.pages.add(), bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_13.pdf');
    });
    //Content row - page pagination with empty bounds
    test('Rows-PaginationWithPage_1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_14.pdf');
    });
    //content row - graphics pagination with empty bounds
    test('Rows-PaginationWithGraphics_1', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      grid.draw(graphics: document.pages.add().graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_15.pdf');
    });
    //Content styles - 0 margins
    test('Rows-0-margins', () {
      //Single content row
      final PdfDocument document = PdfDocument();
      document.pageSettings.margins.all = 0;
      final PdfImage image = PdfBitmap.fromBase64String(logoJpeg);

      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);

      //Multiple content rows
      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = 'Header - 1 Cell - 2';
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = 'Row - 1 Cell - 1';
      row1_2.cells[1].value = 'Row - 1 Cell - 2';
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';
      grid2.draw(page: document.pages.add(), bounds: Rect.zero);

      //contents alone
      final PdfGrid grid3 = PdfGrid();
      grid3.columns.add(count: 3);
      final PdfGridRow row1_3 = grid3.rows.add();
      row1_3.cells[0].value = 'Row - 1 Cell - 1';
      row1_3.cells[1].value = 'Row - 1 Cell - 2';
      row1_3.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_3 = grid3.rows.add();
      row2_3.cells[0].value = 'Row - 2 Cell - 1';
      row2_3.cells[1].value = 'Row - 2 Cell - 2';
      row2_3.cells[2].value = 'Row - 2 Cell - 3';
      grid3.draw(page: document.pages.add(), bounds: Rect.zero);

      //Multi line text in content row
      final PdfGrid grid4 = PdfGrid();
      grid4.columns.add(count: 3);
      grid4.headers.add(3);
      final PdfGridRow header1_4 = grid4.headers[0];
      header1_4.cells[0].value = 'Header - 1 Cell - 1';
      header1_4.cells[1].value = 'Header - 1 Cell - 2';
      header1_4.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_4 = grid4.headers[1];
      header2_4.cells[0].value = 'Header - 2 Cell - 1';
      header2_4.cells[1].value = 'Header - 2 Cell - 2\r\nMultiple line text';
      header2_4.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow header3_4 = grid4.headers[2];
      header3_4.cells[0].value = 'Header - 2 Cell - 1';
      header3_4.cells[1].value = 'Header - 2 Cell - 2';
      header3_4.cells[2].value = 'Header - 2 Cell - 3\r\nMultiple line text';
      final PdfGridRow row1_4 = grid4.rows.add();
      row1_4.cells[0].value = 'Row - 1 Cell - 1\r\nMultiple line text';
      row1_4.cells[1].value = 'Row - 1 Cell - 2';
      row1_4.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_4 = grid4.rows.add();
      row2_4.cells[0].value = 'Row - 2 Cell - 1';
      row2_4.cells[1].value = 'Row - 2 Cell - 2\r\nMultiple line text';
      row2_4.cells[2].value = 'Row - 2 Cell - 3';
      final PdfGridRow row3_4 = grid4.rows.add();
      row3_4.cells[0].value = 'Row - 3 Cell - 1';
      row3_4.cells[1].value = 'Row - 3 Cell - 2';
      row3_4.cells[2].value = 'Row - 3 Cell - 3\r\nMultiple line text';
      grid4.draw(page: document.pages.add(), bounds: Rect.zero);

      //Cell styles
      final PdfGrid grid5 = PdfGrid();
      grid5.columns.add(count: 3);
      grid5.headers.add(1);
      final PdfGridRow header1_5 = grid5.headers[0];
      final PdfGridCellStyle rowCellStyle1_5 = PdfGridCellStyle();
      rowCellStyle1_5.backgroundBrush = PdfBrushes.gray;
      final PdfBorders headerBorder1_5 = PdfBorders();
      headerBorder1_5.left = PdfPen(PdfColor(240, 0, 0), width: 2);
      headerBorder1_5.top = PdfPen(PdfColor(0, 240, 0), width: 3);
      headerBorder1_5.bottom = PdfPen(PdfColor(0, 0, 240), width: 4);
      headerBorder1_5.right = PdfPen(PdfColor(240, 100, 240), width: 5);
      rowCellStyle1_5.borders = headerBorder1_5;
      rowCellStyle1_5.cellPadding =
          PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      rowCellStyle1_5.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      final PdfStringFormat headerStringCenterFormat1_5 = PdfStringFormat();
      headerStringCenterFormat1_5.alignment = PdfTextAlignment.center;
      headerStringCenterFormat1_5.lineAlignment = PdfVerticalAlignment.bottom;
      headerStringCenterFormat1_5.wordSpacing = 10;
      rowCellStyle1_5.stringFormat = headerStringCenterFormat1_5;
      rowCellStyle1_5.textBrush = PdfBrushes.white;
      rowCellStyle1_5.textPen = PdfPens.black;
      header1_5.cells[0].value = 'Header - 1 Cell - 1';
      header1_5.cells[1].value = 'Header - 1 Cell - 2';
      header1_5.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_5 = grid5.rows.add();
      row1_5.cells[0].value = 'Row - 1 Cell - 1';
      row1_5.cells[0].style = rowCellStyle1_5;
      row1_5.cells[1].value = 'Row - 1 Cell - 2';
      row1_5.cells[1].style.backgroundImage = image;
      row1_5.cells[2].value = 'Row - 1 Cell - 3';
      row1_5.cells[2].style = rowCellStyle1_5;
      final PdfGridRow row2_5 = grid5.rows.add();
      row2_5.cells[0].value = 'Row - 2 Cell - 1';
      row2_5.cells[1].value = 'Row - 2 Cell - 2';
      row2_5.cells[1].style = rowCellStyle1_5;
      row2_5.cells[2].value = 'Row - 2 Cell - 3';
      grid5.draw(page: document.pages.add(), bounds: Rect.zero);

      //Row styles
      final PdfGrid grid6 = PdfGrid();
      grid6.columns.add(count: 3);
      grid6.headers.add(1);
      final PdfGridRow header1_6 = grid6.headers[0];
      final PdfGridRowStyle gridRowStyle_6 = PdfGridRowStyle();
      gridRowStyle_6.backgroundBrush = PdfBrushes.lightGray;
      gridRowStyle_6.textPen = PdfPens.black;
      gridRowStyle_6.textBrush = PdfBrushes.white;
      gridRowStyle_6.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      header1_6.cells[0].value = 'Header - 1 Cell - 1';
      header1_6.cells[1].value = 'Header - 1 Cell - 2';
      header1_6.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_6 = grid6.rows.add();
      row1_6.style = gridRowStyle_6;
      row1_6.cells[0].value = 'Row - 1 Cell - 1';
      row1_6.cells[1].value = 'Row - 1 Cell - 2';
      row1_6.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_6 = grid6.rows.add();
      row2_6.cells[0].value = 'Row - 2 Cell - 1';
      row2_6.cells[1].value = 'Row - 2 Cell - 2';
      row2_6.cells[2].value = 'Row - 2 Cell - 3';
      grid6.draw(page: document.pages.add(), bounds: Rect.zero);

      //Grid style
      final PdfGrid grid7 = PdfGrid();
      final PdfGridStyle gridStyle_7 = PdfGridStyle();
      gridStyle_7.cellSpacing = 2;
      gridStyle_7.cellPadding =
          PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      gridStyle_7.borderOverlapStyle = PdfBorderOverlapStyle.inside;
      gridStyle_7.backgroundBrush = PdfBrushes.lightGray;
      gridStyle_7.textPen = PdfPens.black;
      gridStyle_7.textBrush = PdfBrushes.white;
      gridStyle_7.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      grid7.columns.add(count: 3);
      grid7.headers.add(1);
      final PdfGridRow header1_7 = grid7.headers[0];
      header1_7.cells[0].value = 'Header - 1 Cell - 1';
      header1_7.cells[1].value = 'Header - 1 Cell - 2';
      header1_7.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_7 = grid7.rows.add();
      row1_7.cells[0].value = 'Row - 1 Cell - 1';
      row1_7.cells[1].value = 'Row - 1 Cell - 2';
      row1_7.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_7 = grid7.rows.add();
      row2_7.cells[0].value = 'Row - 2 Cell - 1';
      row2_7.cells[1].value = 'Row - 2 Cell - 2';
      row2_7.cells[2].value = 'Row - 2 Cell - 3';
      grid7.style = gridStyle_7;
      grid7.draw(page: document.pages.add(), bounds: Rect.zero);

      //Image drawing in content row
      final PdfGrid grid8 = PdfGrid();
      grid8.columns.add(count: 3);
      grid8.headers.add(1);
      final PdfGridRow header1_8 = grid8.headers[0];
      header1_8.cells[0].value = 'Header - 1 Cell - 1';
      header1_8.cells[1].value = 'Header - 1 Cell - 2';
      header1_8.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_8 = grid8.rows.add();
      row1_8.cells[0].value = image;
      row1_8.cells[1].value = image;
      row1_8.cells[2].value = image;
      final PdfGridRow row2_8 = grid8.rows.add();
      row2_8.cells[0].value = 'Row - 2 Cell - 1';
      row2_8.cells[1].value = 'Row - 2 Cell - 2';
      row2_8.cells[2].value = 'Row - 2 Cell - 3';
      grid8.draw(page: document.pages.add(), bounds: Rect.zero);

      final PdfTextElement element = PdfTextElement();
      element.text = 'Text Element Text';
      element.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);

      //TextElement drawing in header row
      final PdfGrid grid9 = PdfGrid();
      grid9.columns.add(count: 3);
      grid9.headers.add(1);
      final PdfGridRow header1_9 = grid9.headers[0];
      header1_9.cells[0].value = 'Header - 1 Cell - 1';
      header1_9.cells[1].value = 'Header - 1 Cell - 2';
      header1_9.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_9 = grid9.rows.add();
      row1_9.cells[0].value = element;
      row1_9.cells[1].value = element;
      row1_9.cells[2].value = element;
      final PdfGridRow row2_9 = grid9.rows.add();
      row2_9.cells[0].value = 'Row - 2 Cell - 1';
      row2_9.cells[1].value = 'Row - 2 Cell - 2';
      row2_9.cells[2].value = 'Row - 2 Cell - 3';
      grid9.draw(page: document.pages.add(), bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_16.pdf');
    });
    //Content row - page pagination with bounds
    test('Rows-PaginationWithPage_2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      grid.draw(page: page, bounds: const Rect.fromLTWH(100, 100, 400, 300));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_17.pdf');
    });
    //Content row - graphics pagination with bounds
    test('Rows-PaginationWithGraphics_2', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      grid.draw(
          graphics: document.pages.add().graphics,
          bounds: const Rect.fromLTWH(100, 100, 400, 300));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_18.pdf');
    });
    //Content row - page pagination bounds with empty bounds
    test('Rows-PaginationWithPage_3', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.paginateBounds = const Rect.fromLTWH(100, 100, 400, 300);
      grid.draw(page: page, bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_19.pdf');
    });
    //Content row - graphics pagination bounds with empty bounds
    test('Rows-PaginationWithGraphics_3', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.paginateBounds = const Rect.fromLTWH(100, 100, 400, 300);
      grid.draw(
          graphics: document.pages.add().graphics,
          bounds: Rect.zero,
          format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_20.pdf');
    });
    //Content row - page pagination bounds with bounds
    test('Rows-PaginationWithPage_4', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.paginateBounds = const Rect.fromLTWH(100, 100, 400, 300);
      grid.draw(
          page: page,
          bounds: const Rect.fromLTWH(100, 100, 400, 300),
          format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_21.pdf');
    });
    //Content row - graphics pagination bounds with bounds
    test('Rows-PaginationWithGraphics_5', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.paginateBounds = const Rect.fromLTWH(100, 100, 400, 300);
      grid.draw(
          graphics: document.pages.add().graphics,
          bounds: const Rect.fromLTWH(100, 100, 400, 300),
          format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_22.pdf');
    });
    //Content row - Allow horizontal overflow - next page (with page overload)
    test('Rows-HorizontalOverflow-NextPage-Page', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 20);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      header.cells[3].value = 'Header - 1 Cell - 4';
      header.cells[4].value = 'Header - 1 Cell - 5';
      header.cells[5].value = 'Header - 1 Cell - 6';
      header.cells[6].value = 'Header - 1 Cell - 7';
      header.cells[7].value = 'Header - 1 Cell - 8';
      header.cells[8].value = 'Header - 1 Cell - 9';
      header.cells[9].value = 'Header - 1 Cell - 10';
      header.cells[10].value = 'Header - 1 Cell - 11';
      header.cells[11].value = 'Header - 1 Cell - 12';
      header.cells[12].value = 'Header - 1 Cell - 13';
      header.cells[13].value = 'Header - 1 Cell - 14';
      header.cells[14].value = 'Header - 1 Cell - 15';
      header.cells[15].value = 'Header - 1 Cell - 16';
      header.cells[16].value = 'Header - 1 Cell - 17';
      header.cells[17].value = 'Header - 1 Cell - 18';
      header.cells[18].value = 'Header - 1 Cell - 19';
      header.cells[19].value = 'Header - 1 Cell - 20';
      for (int i = 0; i < 100; i++) {
        final PdfGridRow row1 = grid.rows.add();
        row1.cells[0].value = 'Row - $i Cell - 1';
        row1.cells[1].value = 'Row - $i Cell - 2';
        row1.cells[2].value = 'Row - $i Cell - 3';
        row1.cells[3].value = 'Row - $i Cell - 4';
        row1.cells[4].value = 'Row - $i Cell - 5';
        row1.cells[5].value = 'Row - $i Cell - 6';
        row1.cells[6].value = 'Row - $i Cell - 7';
        row1.cells[7].value = 'Row - $i Cell - 8';
        row1.cells[8].value = 'Row - $i Cell - 9';
        row1.cells[9].value = 'Row - $i Cell - 10';
        row1.cells[10].value = 'Row - $i Cell - 11';
        row1.cells[11].value = 'Row - $i Cell - 12';
        row1.cells[12].value = 'Row - $i Cell - 13';
        row1.cells[13].value = 'Row - $i Cell - 14';
        row1.cells[14].value = 'Row - $i Cell - 15';
        row1.cells[15].value = 'Row - $i Cell - 16';
        row1.cells[16].value = 'Row - $i Cell - 17';
        row1.cells[17].value = 'Row - $i Cell - 18';
        row1.cells[18].value = 'Row - $i Cell - 19';
        row1.cells[19].value = 'Row - $i Cell - 20';
      }
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_23.pdf');
    });
    //Content row - Allow horizontal overflow - last page (with page overload)
    test('Rows-HorizontalOverflow-LastPage-Page', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 20);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      header.cells[3].value = 'Header - 1 Cell - 4';
      header.cells[4].value = 'Header - 1 Cell - 5';
      header.cells[5].value = 'Header - 1 Cell - 6';
      header.cells[6].value = 'Header - 1 Cell - 7';
      header.cells[7].value = 'Header - 1 Cell - 8';
      header.cells[8].value = 'Header - 1 Cell - 9';
      header.cells[9].value = 'Header - 1 Cell - 10';
      header.cells[10].value = 'Header - 1 Cell - 11';
      header.cells[11].value = 'Header - 1 Cell - 12';
      header.cells[12].value = 'Header - 1 Cell - 13';
      header.cells[13].value = 'Header - 1 Cell - 14';
      header.cells[14].value = 'Header - 1 Cell - 15';
      header.cells[15].value = 'Header - 1 Cell - 16';
      header.cells[16].value = 'Header - 1 Cell - 17';
      header.cells[17].value = 'Header - 1 Cell - 18';
      header.cells[18].value = 'Header - 1 Cell - 19';
      header.cells[19].value = 'Header - 1 Cell - 20';
      for (int i = 0; i < 100; i++) {
        final PdfGridRow row1 = grid.rows.add();
        row1.cells[0].value = 'Row - $i Cell - 1';
        row1.cells[1].value = 'Row - $i Cell - 2';
        row1.cells[2].value = 'Row - $i Cell - 3';
        row1.cells[3].value = 'Row - $i Cell - 4';
        row1.cells[4].value = 'Row - $i Cell - 5';
        row1.cells[5].value = 'Row - $i Cell - 6';
        row1.cells[6].value = 'Row - $i Cell - 7';
        row1.cells[7].value = 'Row - $i Cell - 8';
        row1.cells[8].value = 'Row - $i Cell - 9';
        row1.cells[9].value = 'Row - $i Cell - 10';
        row1.cells[10].value = 'Row - $i Cell - 11';
        row1.cells[11].value = 'Row - $i Cell - 12';
        row1.cells[12].value = 'Row - $i Cell - 13';
        row1.cells[13].value = 'Row - $i Cell - 14';
        row1.cells[14].value = 'Row - $i Cell - 15';
        row1.cells[15].value = 'Row - $i Cell - 16';
        row1.cells[16].value = 'Row - $i Cell - 17';
        row1.cells[17].value = 'Row - $i Cell - 18';
        row1.cells[18].value = 'Row - $i Cell - 19';
        row1.cells[19].value = 'Row - $i Cell - 20';
      }
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_24.pdf');
    });
    //Content row - Allow horizontal overflow - next page (with graphics overload)
    test('Rows-HorizontalOverflow-NextPage-Graphics', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 20);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      header.cells[3].value = 'Header - 1 Cell - 4';
      header.cells[4].value = 'Header - 1 Cell - 5';
      header.cells[5].value = 'Header - 1 Cell - 6';
      header.cells[6].value = 'Header - 1 Cell - 7';
      header.cells[7].value = 'Header - 1 Cell - 8';
      header.cells[8].value = 'Header - 1 Cell - 9';
      header.cells[9].value = 'Header - 1 Cell - 10';
      header.cells[10].value = 'Header - 1 Cell - 11';
      header.cells[11].value = 'Header - 1 Cell - 12';
      header.cells[12].value = 'Header - 1 Cell - 13';
      header.cells[13].value = 'Header - 1 Cell - 14';
      header.cells[14].value = 'Header - 1 Cell - 15';
      header.cells[15].value = 'Header - 1 Cell - 16';
      header.cells[16].value = 'Header - 1 Cell - 17';
      header.cells[17].value = 'Header - 1 Cell - 18';
      header.cells[18].value = 'Header - 1 Cell - 19';
      header.cells[19].value = 'Header - 1 Cell - 20';
      for (int i = 0; i < 100; i++) {
        final PdfGridRow row1 = grid.rows.add();
        row1.cells[0].value = 'Row - $i Cell - 1';
        row1.cells[1].value = 'Row - $i Cell - 2';
        row1.cells[2].value = 'Row - $i Cell - 3';
        row1.cells[3].value = 'Row - $i Cell - 4';
        row1.cells[4].value = 'Row - $i Cell - 5';
        row1.cells[5].value = 'Row - $i Cell - 6';
        row1.cells[6].value = 'Row - $i Cell - 7';
        row1.cells[7].value = 'Row - $i Cell - 8';
        row1.cells[8].value = 'Row - $i Cell - 9';
        row1.cells[9].value = 'Row - $i Cell - 10';
        row1.cells[10].value = 'Row - $i Cell - 11';
        row1.cells[11].value = 'Row - $i Cell - 12';
        row1.cells[12].value = 'Row - $i Cell - 13';
        row1.cells[13].value = 'Row - $i Cell - 14';
        row1.cells[14].value = 'Row - $i Cell - 15';
        row1.cells[15].value = 'Row - $i Cell - 16';
        row1.cells[16].value = 'Row - $i Cell - 17';
        row1.cells[17].value = 'Row - $i Cell - 18';
        row1.cells[18].value = 'Row - $i Cell - 19';
        row1.cells[19].value = 'Row - $i Cell - 20';
      }
      grid.draw(graphics: document.pages.add().graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_25.pdf');
    });
    //Content row - Allow horizontal overflow - last page (with graphics overload)
    test('Rows-HorizontalOverflow-LastPage-Graphics', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 20);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      header.cells[3].value = 'Header - 1 Cell - 4';
      header.cells[4].value = 'Header - 1 Cell - 5';
      header.cells[5].value = 'Header - 1 Cell - 6';
      header.cells[6].value = 'Header - 1 Cell - 7';
      header.cells[7].value = 'Header - 1 Cell - 8';
      header.cells[8].value = 'Header - 1 Cell - 9';
      header.cells[9].value = 'Header - 1 Cell - 10';
      header.cells[10].value = 'Header - 1 Cell - 11';
      header.cells[11].value = 'Header - 1 Cell - 12';
      header.cells[12].value = 'Header - 1 Cell - 13';
      header.cells[13].value = 'Header - 1 Cell - 14';
      header.cells[14].value = 'Header - 1 Cell - 15';
      header.cells[15].value = 'Header - 1 Cell - 16';
      header.cells[16].value = 'Header - 1 Cell - 17';
      header.cells[17].value = 'Header - 1 Cell - 18';
      header.cells[18].value = 'Header - 1 Cell - 19';
      header.cells[19].value = 'Header - 1 Cell - 20';
      for (int i = 0; i < 100; i++) {
        final PdfGridRow row1 = grid.rows.add();
        row1.cells[0].value = 'Row - $i Cell - 1';
        row1.cells[1].value = 'Row - $i Cell - 2';
        row1.cells[2].value = 'Row - $i Cell - 3';
        row1.cells[3].value = 'Row - $i Cell - 4';
        row1.cells[4].value = 'Row - $i Cell - 5';
        row1.cells[5].value = 'Row - $i Cell - 6';
        row1.cells[6].value = 'Row - $i Cell - 7';
        row1.cells[7].value = 'Row - $i Cell - 8';
        row1.cells[8].value = 'Row - $i Cell - 9';
        row1.cells[9].value = 'Row - $i Cell - 10';
        row1.cells[10].value = 'Row - $i Cell - 11';
        row1.cells[11].value = 'Row - $i Cell - 12';
        row1.cells[12].value = 'Row - $i Cell - 13';
        row1.cells[13].value = 'Row - $i Cell - 14';
        row1.cells[14].value = 'Row - $i Cell - 15';
        row1.cells[15].value = 'Row - $i Cell - 16';
        row1.cells[16].value = 'Row - $i Cell - 17';
        row1.cells[17].value = 'Row - $i Cell - 18';
        row1.cells[18].value = 'Row - $i Cell - 19';
        row1.cells[19].value = 'Row - $i Cell - 20';
      }
      grid.draw(graphics: document.pages.add().graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_26.pdf');
    });
    //Header row - Allow horizontal overflow - next page (with graphics overload)
    test('Headers-HorizontalOverflow-NextPage-Graphics', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 20);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
        header.cells[3].value = 'Header - $i Cell - 4';
        header.cells[4].value = 'Header - $i Cell - 5';
        header.cells[5].value = 'Header - $i Cell - 6';
        header.cells[6].value = 'Header - $i Cell - 7';
        header.cells[7].value = 'Header - $i Cell - 8';
        header.cells[8].value = 'Header - $i Cell - 9';
        header.cells[9].value = 'Header - $i Cell - 10';
        header.cells[10].value = 'Header - $i Cell - 11';
        header.cells[11].value = 'Header - $i Cell - 12';
        header.cells[12].value = 'Header - $i Cell - 13';
        header.cells[13].value = 'Header - $i Cell - 14';
        header.cells[14].value = 'Header - $i Cell - 15';
        header.cells[15].value = 'Header - $i Cell - 16';
        header.cells[16].value = 'Header - $i Cell - 17';
        header.cells[17].value = 'Header - $i Cell - 18';
        header.cells[18].value = 'Header - $i Cell - 19';
        header.cells[19].value = 'Header - $i Cell - 20';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = 'Row - 1 Cell - 6';
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      row1.cells[10].value = 'Row - 1 Cell - 11';
      row1.cells[11].value = 'Row - 1 Cell - 12';
      row1.cells[12].value = 'Row - 1 Cell - 13';
      row1.cells[13].value = 'Row - 1 Cell - 14';
      row1.cells[14].value = 'Row - 1 Cell - 15';
      row1.cells[15].value = 'Row - 1 Cell - 16';
      row1.cells[16].value = 'Row - 1 Cell - 17';
      row1.cells[17].value = 'Row - 1 Cell - 18';
      row1.cells[18].value = 'Row - 1 Cell - 19';
      row1.cells[19].value = 'Row - 1 Cell - 20';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = 'Row - 2 Cell - 6';
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      row2.cells[10].value = 'Row - 2 Cell - 11';
      row2.cells[11].value = 'Row - 2 Cell - 12';
      row2.cells[12].value = 'Row - 2 Cell - 13';
      row2.cells[13].value = 'Row - 2 Cell - 14';
      row2.cells[14].value = 'Row - 2 Cell - 15';
      row2.cells[15].value = 'Row - 2 Cell - 16';
      row2.cells[16].value = 'Row - 2 Cell - 17';
      row2.cells[17].value = 'Row - 2 Cell - 18';
      row2.cells[18].value = 'Row - 2 Cell - 19';
      row2.cells[19].value = 'Row - 2 Cell - 20';
      grid.draw(graphics: document.pages.add().graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_27.pdf');
    });
    //Header row - Allow horizontal overflow - last page (with graphics overload)
    test('Headers-HorizontalOverflow-LastPage-Graphics', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 20);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
        header.cells[3].value = 'Header - $i Cell - 4';
        header.cells[4].value = 'Header - $i Cell - 5';
        header.cells[5].value = 'Header - $i Cell - 6';
        header.cells[6].value = 'Header - $i Cell - 7';
        header.cells[7].value = 'Header - $i Cell - 8';
        header.cells[8].value = 'Header - $i Cell - 9';
        header.cells[9].value = 'Header - $i Cell - 10';
        header.cells[10].value = 'Header - $i Cell - 11';
        header.cells[11].value = 'Header - $i Cell - 12';
        header.cells[12].value = 'Header - $i Cell - 13';
        header.cells[13].value = 'Header - $i Cell - 14';
        header.cells[14].value = 'Header - $i Cell - 15';
        header.cells[15].value = 'Header - $i Cell - 16';
        header.cells[16].value = 'Header - $i Cell - 17';
        header.cells[17].value = 'Header - $i Cell - 18';
        header.cells[18].value = 'Header - $i Cell - 19';
        header.cells[19].value = 'Header - $i Cell - 20';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = 'Row - 1 Cell - 6';
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      row1.cells[10].value = 'Row - 1 Cell - 11';
      row1.cells[11].value = 'Row - 1 Cell - 12';
      row1.cells[12].value = 'Row - 1 Cell - 13';
      row1.cells[13].value = 'Row - 1 Cell - 14';
      row1.cells[14].value = 'Row - 1 Cell - 15';
      row1.cells[15].value = 'Row - 1 Cell - 16';
      row1.cells[16].value = 'Row - 1 Cell - 17';
      row1.cells[17].value = 'Row - 1 Cell - 18';
      row1.cells[18].value = 'Row - 1 Cell - 19';
      row1.cells[19].value = 'Row - 1 Cell - 20';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = 'Row - 2 Cell - 6';
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      row2.cells[10].value = 'Row - 2 Cell - 11';
      row2.cells[11].value = 'Row - 2 Cell - 12';
      row2.cells[12].value = 'Row - 2 Cell - 13';
      row2.cells[13].value = 'Row - 2 Cell - 14';
      row2.cells[14].value = 'Row - 2 Cell - 15';
      row2.cells[15].value = 'Row - 2 Cell - 16';
      row2.cells[16].value = 'Row - 2 Cell - 17';
      row2.cells[17].value = 'Row - 2 Cell - 18';
      row2.cells[18].value = 'Row - 2 Cell - 19';
      row2.cells[19].value = 'Row - 2 Cell - 20';
      grid.draw(graphics: document.pages.add().graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_28.pdf');
    });
    //Header row - image drawing with empty bounds - Horizontal overflow - last page
    test('Headers-Graphics_HOF_LastPage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_29.pdf');
    });
    //Header row - image drawing with empty bounds - Horizontal overflow - next page
    test('Headers-Graphics_HOF_NextPage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_30.pdf');
    });
    //Content row - image drawing with empty bounds - Horizontal overflow - last page
    test('Content-Graphics_HOF_LastPage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_31.pdf');
    });
    //Content row - image drawing with empty bounds - Horizontal overflow - next page
    test('Content-Graphics_HOF_NextPage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_32.pdf');
    });
    //Header row - image drawing with empty bounds - Horizontal overflow - last page - graphics
    test('Headers-Graphics_HOF_LastPage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(graphics: page.graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_33.pdf');
    });
    //Header row - image drawing with empty bounds - Horizontal overflow - next page - graphics
    test('Headers-Graphics_HOF_NextPage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(graphics: page.graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_34.pdf');
    });
    //Content row - image drawing with empty bounds - Horizontal overflow - last page - graphics
    test('Content-Graphics_HOF_LastPage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(graphics: page.graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_35.pdf');
    });
    //Content row - image drawing with empty bounds - Horizontal overflow - next page - graphics
    test('Content-Graphics_HOF_NextPage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(graphics: page.graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_36.pdf');
    });

    //PdfGridBeginCellLayoutEvent
    test('PdfGridBeginCellLayoutEvent', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
        if (args.rowIndex == 1 && args.cellIndex == 1) {
          args.graphics.drawRectangle(
              pen: PdfPen(PdfColor(250, 100, 0), width: 2),
              brush: PdfBrushes.white,
              bounds: args.bounds);
        }
        if (args.isHeaderRow && args.cellIndex == 0) {
          args.graphics.drawRectangle(
              pen: PdfPen(PdfColor(250, 100, 0), width: 2),
              brush: PdfBrushes.white,
              bounds: args.bounds);
        }
      };
      grid.style.cellPadding = PdfPaddings();
      grid.style.cellPadding.all = 15;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(graphics: page.graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_37.pdf');
    });
    //PdfGridEndCellLayoutEvent
    test('PdfGridEndCellLayoutEvent', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.endCellLayout = (Object sender, PdfGridEndCellLayoutArgs args) {
        if (args.isHeaderRow && args.cellIndex == 0) {
          args.graphics.drawRectangle(
              pen: PdfPen(PdfColor(250, 100, 0), width: 2),
              brush: PdfBrushes.white,
              bounds: args.bounds);
        }
        if (args.rowIndex == 1 && args.cellIndex == 1) {
          args.graphics.drawRectangle(
              pen: PdfPen(PdfColor(250, 100, 0), width: 2),
              brush: PdfBrushes.white,
              bounds: args.bounds);
        }
      };
      grid.style.cellPadding = PdfPaddings();
      grid.style.cellPadding.all = 15;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(graphics: page.graphics, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_38.pdf');
    });
    //PdfGrid - BeginPageLayout - EndPageLayout
    test('PageLayoutEvents', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.beginPageLayout = (Object sender, BeginPageLayoutArgs args) {
        args.page.graphics.drawRectangle(
            pen: PdfPen(PdfColor(0, 0, 0)),
            bounds: const Rect.fromLTWH(10, 300, 100, 50));
      };
      grid.endPageLayout = (Object sender, EndPageLayoutArgs args) {
        args.result.page.graphics.drawRectangle(
            pen: PdfPen(PdfColor(0, 0, 0)),
            bounds: const Rect.fromLTWH(150, 300, 100, 50));
      };
      grid.style.cellPadding = PdfPaddings();
      grid.style.cellPadding.all = 15;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_39.pdf');
    });
    //Header - pagination bounds with empty bounds - pagination bounds
    test('Header-PageLayoutBounds-empty bounds', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(500);
      for (int i = 0; i < 500; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.paginateBounds = Rect.zero;
      grid.draw(
          page: page,
          bounds: const Rect.fromLTWH(100, 100, 400, 300),
          format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_40.pdf');
    });

    //Content - pagination bounds with empty bounds - pagination bounds
    test('Content-PageLayoutBounds-empty bounds', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row1 = grid.rows.add();
        row1.cells[0].value = 'Row - $i Cell - 1';
        row1.cells[1].value = 'Row - $i Cell - 2';
        row1.cells[2].value = 'Row - $i Cell - 3';
      }
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.paginateBounds = Rect.zero;
      grid.draw(
          page: page,
          bounds: const Rect.fromLTWH(100, 100, 400, 300),
          format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_41.pdf');
    });
    //Header-content column span
    test('Column span', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1 Column Span';
      header.cells[0].columnSpan = 2;
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[1].columnSpan = 2;
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_42.pdf');
    });
    //Row span - Header and content
    test('Row span', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(2);
      final PdfGridRow header1 = grid.headers[0];
      header1.cells[0].value = 'Header - 1 Cell - 1 Row Span';
      header1.cells[0].rowSpan = 2;
      header1.cells[1].value = 'Header - 1 Cell - 1';
      header1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2 = grid.headers[1];
      header2.cells[0].value = 'Header - 2 Cell - 1';
      header2.cells[1].value = 'Header - 2 Cell - 2';
      header2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[1].rowSpan = 2;
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_43.pdf');
    });
    //Header - Content - Column and row span
    test('Column and Row span', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(2);
      final PdfGridRow header1 = grid.headers[0];
      header1.cells[0].value = 'Header - 1 Cell - 1 Row Span';
      header1.cells[0].rowSpan = 2;
      header1.cells[0].columnSpan = 2;
      header1.cells[1].value = 'Header - 1 Cell - 1';
      header1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2 = grid.headers[1];
      header2.cells[0].value = 'Header - 2 Cell - 1';
      header2.cells[1].value = 'Header - 2 Cell - 2';
      header2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[1].rowSpan = 2;
      row1.cells[1].columnSpan = 2;
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_44.pdf');
    });
    //Two grids in same page
    test('Two grids - same page', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header_1 = grid1.headers[0];
      header_1.cells[0].value = 'Header - 1 Cell - 1';
      header_1.cells[1].value = 'Header - 1 Cell - 2';
      header_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = 'Row - 2 Cell - 1';
      row2_1.cells[1].value = 'Row - 2 Cell - 2';
      row2_1.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutResult? result =
          grid1.draw(page: page, bounds: const Rect.fromLTWH(0, 0, 400, 300));
      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(1);
      final PdfGridRow header_2 = grid2.headers[0];
      header_2.cells[0].value = 'Header - 1 Cell - 1';
      header_2.cells[1].value = 'Header - 1 Cell - 2';
      header_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = 'Row - 1 Cell - 1';
      row1_2.cells[1].value = 'Row - 1 Cell - 2';
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';
      grid2.draw(
          page: result!.page,
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 20, 400, 300));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_45.pdf');
    });
    //Header row - Pagination-PdfLayoutBreakType-fitElement
    test('Headers-Pagination-PdfLayoutBreakType-fitElement', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value =
            'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.breakType = PdfLayoutBreakType.fitElement;
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_46.pdf');
    });
    //Header row - Pagination-PdfLayoutBreakType-fitColumnsToPage
    test('Headers-Pagination-PdfLayoutBreakType-fitColumnsToPage', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value =
            'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.breakType = PdfLayoutBreakType.fitColumnsToPage;
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_47.pdf');
    });
    //Content-Pagination-PdfLayoutBreakType-fitElement
    test('Content-Pagination-PdfLayoutBreakType-fitElement', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 100; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value =
            'Row - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.breakType = PdfLayoutBreakType.fitElement;
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_48.pdf');
    });

    //Content-Pagination-PdfLayoutBreakType-fitColumnsToPage
    test('Content-Pagination-PdfLayoutBreakType-fitColumnsToPage', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 100; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value =
            'Row - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.breakType = PdfLayoutBreakType.fitColumnsToPage;
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_49.pdf');
    });
    //Simple grid - apply style and set span methods
    test('apply style and set span methods', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      header.height = 20;
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.height = 20;
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.height = 20;
      grid.rows.setSpan(0, 0, 2, 2);
      final PdfGridRowStyle style = PdfGridRowStyle();
      style.textPen = PdfPens.red;
      grid.rows.applyStyle(style);
      final PdfGridCellStyle styles = PdfGridCellStyle();
      styles.borders.all = PdfPens.red;
      grid.headers.applyStyle(styles);
      grid.rows[0].cells[0].value = 'Syncfusion Pdf';
      grid.draw(page: page, bounds: const Rect.fromLTWH(0, 200, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_54.pdf');
    });
    //Simple grid - image position
    test('Image position', () {
      final PdfDocument document = PdfDocument();
      final PdfImage image = PdfBitmap.fromBase64String(logoJpeg);
      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      final PdfGridRow row1 = grid1.rows.add();
      final PdfGridCell cell1 = row1.cells[0];
      cell1.imagePosition = PdfGridImagePosition.center;
      cell1.style.backgroundImage = image;
      cell1.style.cellPadding =
          PdfPaddings(left: 0, right: 0, top: 10, bottom: 10);
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);

      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      final PdfGridRow row2 = grid2.rows.add();
      final PdfGridCell cell2 = row2.cells[0];
      cell2.imagePosition = PdfGridImagePosition.fit;
      cell2.style.backgroundImage = image;
      cell2.style.cellPadding =
          PdfPaddings(left: 0, right: 0, top: 10, bottom: 10);
      grid2.draw(page: document.pages.add(), bounds: Rect.zero);

      final PdfGrid grid3 = PdfGrid();
      grid3.columns.add(count: 3);
      final PdfGridRow row3 = grid3.rows.add();
      final PdfGridCell cell3 = row3.cells[0];
      cell3.imagePosition = PdfGridImagePosition.tile;
      cell3.style.backgroundImage = image;
      cell3.style.cellPadding =
          PdfPaddings(left: 0, right: 0, top: 10, bottom: 10);
      grid3.draw(page: document.pages.add(), bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_55.pdf');
    });
    //Header row - Pagination-PdfLayoutBreakType-fitElement-Text element
    test('Headers-Pagination-PdfLayoutBreakType-fitElement-Text element', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        final PdfTextElement element = PdfTextElement();
        element.text =
            'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        element.font = PdfStandardFont(PdfFontFamily.timesRoman, 15);
        header.cells[1].value = element;

        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.breakType = PdfLayoutBreakType.fitElement;
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_56.pdf');
    });
    //Header row - Pagination-PdfLayoutBreakType-fitColumnsToPage-Text element
    test('Headers-Pagination-PdfLayoutBreakType-fitColumnsToPage-Text element',
        () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        final PdfTextElement element = PdfTextElement();
        element.text =
            'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        element.font = PdfStandardFont(PdfFontFamily.timesRoman, 15);
        header.cells[1].value = element;

        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.breakType = PdfLayoutBreakType.fitColumnsToPage;
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_57.pdf');
    });
  });
  group('Nested Grid', () {
    //Simple nested grid - Header cell
    test('Simple-NestedGrid-Header cell', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();

      final PdfGrid childGrid = PdfGrid();
      childGrid.columns.add(count: 2);
      childGrid.headers.add(1);
      final PdfGridRow childHeader = childGrid.headers[0];
      childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
      childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
      final PdfGridRow childRow1 = childGrid.rows.add();
      childRow1.cells[0].value = 'Row - 1 Cell - 1';
      childRow1.cells[1].value = 'Row - 1 Cell - 2';

      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 3);
      parentGrid.headers.add(1);
      final PdfGridRow parentHeader = parentGrid.headers[0];
      parentHeader.cells[0].value = childGrid;
      parentHeader.cells[1].value = 'Header - 1 Cell - 2';
      parentHeader.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow parentRow1 = parentGrid.rows.add();
      parentRow1.cells[0].value = 'Row - 1 Cell - 1';
      parentRow1.cells[1].value = 'Row - 1 Cell - 2';
      parentRow1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow parentRow2 = parentGrid.rows.add();
      parentRow2.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2.cells[1].value = 'Row - 2 Cell - 2';
      parentRow2.cells[2].value = 'Row - 2 Cell - 3';
      parentGrid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_50.pdf');
    });
    //Simple nested grid - Content cell
    test('Simple-NestedGrid-Content cell', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();

      final PdfGrid childGrid = PdfGrid();
      childGrid.columns.add(count: 2);
      childGrid.headers.add(1);
      final PdfGridRow childHeader = childGrid.headers[0];
      childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
      childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
      final PdfGridRow childRow1 = childGrid.rows.add();
      childRow1.cells[0].value = 'Child Row - 1 Cell - 1';
      childRow1.cells[1].value = 'Child Row - 1 Cell - 2';

      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 3);
      parentGrid.headers.add(1);
      final PdfGridRow parentHeader = parentGrid.headers[0];
      parentHeader.cells[0].value = 'Header - 1 Cell - 1';
      parentHeader.cells[1].value = 'Header - 1 Cell - 2';
      parentHeader.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow parentRow1 = parentGrid.rows.add();
      parentRow1.cells[0].value = childGrid;
      parentRow1.cells[1].value = 'Row - 1 Cell - 2';
      parentRow1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow parentRow2 = parentGrid.rows.add();
      parentRow2.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2.cells[1].value = 'Row - 2 Cell - 2';
      parentRow2.cells[2].value = 'Row - 2 Cell - 3';
      parentGrid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_51.pdf');
    });
    //Simple nested grid - Header cell style
    test('Simple-NestedGrid-Header cell style', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();

      final PdfGridCellStyle cellStyle = PdfGridCellStyle();
      cellStyle.backgroundBrush = PdfBrushes.gray;
      final PdfBorders border = PdfBorders();
      border.left = PdfPen(PdfColor(240, 0, 0), width: 2);
      border.top = PdfPen(PdfColor(0, 240, 0), width: 3);
      border.bottom = PdfPen(PdfColor(0, 0, 240), width: 4);
      border.right = PdfPen(PdfColor(240, 100, 240), width: 5);
      cellStyle.borders = border;
      cellStyle.cellPadding = PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      cellStyle.cellPadding!.all = 5;
      cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      final PdfStringFormat stringCenterFormat = PdfStringFormat();
      stringCenterFormat.alignment = PdfTextAlignment.center;
      stringCenterFormat.lineAlignment = PdfVerticalAlignment.bottom;
      stringCenterFormat.wordSpacing = 10;
      cellStyle.stringFormat = stringCenterFormat;
      cellStyle.textBrush = PdfBrushes.white;
      cellStyle.textPen = PdfPens.black;

      final PdfGrid childGrid = PdfGrid();
      childGrid.columns.add(count: 2);
      childGrid.headers.add(1);
      final PdfGridRow childHeader = childGrid.headers[0];
      childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
      childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
      final PdfGridRow childRow1 = childGrid.rows.add();
      childRow1.cells[0].value = 'Row - 1 Cell - 1';
      childRow1.cells[0].style.textPen = PdfPens.green;
      childRow1.cells[1].value = 'Row - 1 Cell - 2';

      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 3);
      parentGrid.headers.add(1);
      final PdfGridRow parentHeader = parentGrid.headers[0];
      parentHeader.cells[0].value = childGrid;
      parentHeader.cells[0].style = cellStyle;
      parentHeader.cells[1].value = 'Header - 1 Cell - 2';
      parentHeader.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow parentRow1 = parentGrid.rows.add();
      parentRow1.cells[0].value = 'Row - 1 Cell - 1';
      parentRow1.cells[1].value = 'Row - 1 Cell - 2';
      parentRow1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow parentRow2 = parentGrid.rows.add();
      parentRow2.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2.cells[1].value = 'Row - 2 Cell - 2';
      parentRow2.cells[2].value = 'Row - 2 Cell - 3';
      parentGrid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_52.pdf');
    });
    //Simple nested grid - Content cell style
    test('Simple-NestedGrid-Content cell style', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();

      final PdfGridCellStyle cellStyle = PdfGridCellStyle();
      cellStyle.backgroundBrush = PdfBrushes.gray;
      final PdfBorders border = PdfBorders();
      border.left = PdfPen(PdfColor(240, 0, 0), width: 2);
      border.top = PdfPen(PdfColor(0, 240, 0), width: 3);
      border.bottom = PdfPen(PdfColor(0, 0, 240), width: 4);
      border.right = PdfPen(PdfColor(240, 100, 240), width: 5);
      cellStyle.borders = border;
      cellStyle.cellPadding = PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      cellStyle.cellPadding!.all = 5;
      cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      final PdfStringFormat stringCenterFormat = PdfStringFormat();
      stringCenterFormat.alignment = PdfTextAlignment.center;
      stringCenterFormat.lineAlignment = PdfVerticalAlignment.bottom;
      stringCenterFormat.wordSpacing = 10;
      cellStyle.stringFormat = stringCenterFormat;
      cellStyle.textBrush = PdfBrushes.white;
      cellStyle.textPen = PdfPens.black;

      final PdfGrid childGrid = PdfGrid();
      childGrid.columns.add(count: 2);
      childGrid.headers.add(1);
      final PdfGridRow childHeader = childGrid.headers[0];
      childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
      childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
      final PdfGridRow childRow1 = childGrid.rows.add();
      childRow1.cells[0].value = 'Child Row - 1 Cell - 1';
      childRow1.cells[0].style.textPen = PdfPens.green;
      childRow1.cells[1].value = 'Child Row - 1 Cell - 2';

      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 3);
      parentGrid.headers.add(1);
      final PdfGridRow parentHeader = parentGrid.headers[0];
      parentHeader.cells[0].value = 'Header - 1 Cell - 1';
      parentHeader.cells[1].value = 'Header - 1 Cell - 2';
      parentHeader.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow parentRow1 = parentGrid.rows.add();
      parentRow1.cells[0].value = childGrid;
      parentRow1.cells[0].style = cellStyle;
      parentRow1.cells[1].value = 'Row - 1 Cell - 2';
      parentRow1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow parentRow2 = parentGrid.rows.add();
      parentRow2.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2.cells[1].value = 'Row - 2 Cell - 2';
      parentRow2.cells[2].value = 'Row - 2 Cell - 3';
      parentGrid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_53.pdf');
    });
    test('Multi level grid', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid childGrid = PdfGrid();
      childGrid.columns.add(count: 2);
      childGrid.headers.add(1);
      final PdfGridRow childHeader = childGrid.headers[0];
      childHeader.cells[0].value = 'Child - 1 Header - 1 Cell - 1';
      childHeader.cells[1].value = 'Child - 1 Header - 1 Cell - 2';
      final PdfGridRow childRow1 = childGrid.rows.add();
      childRow1.cells[0].value = 'Child - 1 Row - 1 Cell - 1';
      childRow1.cells[1].value = 'Child - 1 Row - 1 Cell - 2';

      final PdfGrid childGrid2 = PdfGrid();
      childGrid2.columns.add(count: 2);
      childGrid2.headers.add(1);
      final PdfGridRow childHeader2 = childGrid2.headers[0];
      childHeader2.cells[0].value = 'Child - 2 Header - 1 Cell - 1';
      childHeader2.cells[1].value = 'Child - 2 Header - 1 Cell - 2';
      final PdfGridRow childRow1_2 = childGrid2.rows.add();
      childRow1_2.cells[0].value = childGrid;
      childRow1_2.cells[0].columnSpan = 2;
      childRow1_2.cells[1].value = 'Child - 2 Row - 1 Cell - 2';

      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 3);
      parentGrid.headers.add(1);
      final PdfGridRow parentHeader = parentGrid.headers[0];
      parentHeader.cells[0].value = 'Header - 1 Cell - 1';
      parentHeader.cells[1].value = 'Header - 1 Cell - 2';
      parentHeader.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow parentRow1 = parentGrid.rows.add();
      parentRow1.cells[0].value = childGrid2;
      parentRow1.cells[1].value = 'Row - 1 Cell - 2';
      parentRow1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow parentRow2 = parentGrid.rows.add();
      parentRow2.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2.cells[1].value = 'Row - 2 Cell - 2';
      parentRow2.cells[2].value = 'Row - 2 Cell - 3';

      parentGrid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_58.pdf');
    });
    // //Simple nested grid - Header cell
    // test('-Coverage Test - 1', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    //   final PdfGrid childGrid = PdfGrid();
    //   childGrid.columns.add(count: 2);
    //   childGrid.headers.add(1);
    //   final PdfGridRow childHeader = childGrid.headers[0];
    //   childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
    //   childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
    //   final PdfGridRow childRow1 = childGrid.rows.add();
    //   childRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childRow1.cells[1].value = 'Row - 1 Cell - 2 Test Entry';
    //   final PdfGrid parentGrid = PdfGrid();
    //   parentGrid.columns.add(count: 3);
    //   parentGrid.headers.add(1);
    //   final PdfGridRow parentHeader = parentGrid.headers[0];
    //   parentHeader.cells[0].value = childGrid;
    //   parentHeader.cells[1].value = 'Header - 1 Cell - 2';
    //   parentHeader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow parentRow1 = parentGrid.rows.add();
    //   parentRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   parentRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   parentRow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow parentRow2 = parentGrid.rows.add();
    //   parentRow2.cells[0].value = 'Row - 2 Cell - 1';
    //   parentRow2.cells[1].value = 'Row - 2 Cell - 2';
    //   parentRow2.cells[2].value = 'Row - 2 Cell - 3';

    //   childRow1.cells[1]._parent = parentHeader.cells[0];
    //   childGrid._isChildGrid = true;
    //   final double width = childRow1.cells[1]._calculateWidth()!;
    //   parentGrid.columns[0].width = width;
    //   parentGrid.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_59.pdf');
    // });

    // //Simple nested grid - Header cell
    // test('-Coverage Test - 2', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    //   final PdfGrid childGrid = PdfGrid();
    //   childGrid.columns.add(count: 2);
    //   childGrid.headers.add(1);
    //   final PdfGridRow childHeader = childGrid.headers[0];
    //   childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
    //   childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
    //   final PdfGridRow childRow1 = childGrid.rows.add();
    //   childRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childRow1.cells[1].value = 'Row - 1 Cell - 2 Test Entry';
    //   final PdfGrid parentGrid = PdfGrid();
    //   parentGrid.columns.add(count: 3);
    //   parentGrid.headers.add(1);
    //   final PdfGridRow parentHeader = parentGrid.headers[0];
    //   parentHeader.cells[0].value = childGrid;
    //   parentHeader.cells[1].value = 'Header - 1 Cell - 2';
    //   parentHeader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow parentRow1 = parentGrid.rows.add();
    //   parentRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   parentRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   parentRow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow parentRow2 = parentGrid.rows.add();
    //   parentRow2.cells[0].value = 'Row - 2 Cell - 1';
    //   parentRow2.cells[1].value = 'Row - 2 Cell - 2';
    //   parentRow2.cells[2].value = 'Row - 2 Cell - 3';

    //   childRow1.cells[1]._parent = parentHeader.cells[0];
    //   childGrid._isChildGrid = true;
    //   childRow1.cells[1]._parent!._outerCellWidth = 100;
    //   final double width = childRow1.cells[1]._calculateWidth()!;
    //   parentGrid.columns[0].width = width;
    //   parentGrid.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_60.pdf');
    // });
    // //Simple nested grid - Header cell
    // test('-Coverage Test - 3', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    //   final PdfGrid childGrid = PdfGrid();
    //   childGrid.columns.add(count: 2);
    //   childGrid.headers.add(1);
    //   final PdfGridRow childHeader = childGrid.headers[0];
    //   childHeader.cells[0].value = 'Child - 1 Cell - 1';
    //   childHeader.cells[1].value = 'Child - 1 Cell - 2';
    //   final PdfGridRow childRow1 = childGrid.rows.add();
    //   childRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   final PdfGrid parentGrid = PdfGrid();
    //   parentGrid.columns.add(count: 3);
    //   parentGrid.headers.add(1);
    //   final PdfGridRow parentHeader = parentGrid.headers[0];
    //   parentHeader.cells[0].value = childGrid;
    //   final double width = parentHeader.cells[0]._measureWidth();
    //   parentHeader.cells[1].value = 'Header - 1 Cell - 2';
    //   parentGrid.columns[1].width = width;
    //   parentHeader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow parentRow1 = parentGrid.rows.add();
    //   parentRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   parentRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   parentRow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow parentRow2 = parentGrid.rows.add();
    //   parentRow2.cells[0].value = 'Row - 2 Cell - 1';
    //   parentRow2.cells[1].value = 'Row - 2 Cell - 2';
    //   parentRow2.cells[2].value = 'Row - 2 Cell - 3';
    //   parentGrid.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_61.pdf');
    // });
    // test('-Coverage Test - 4', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();
    //   final PdfGridCellStyle headerCellStyle = PdfGridCellStyle();
    //   headerCellStyle.backgroundBrush = PdfBrushes.gray;
    //   final PdfBorders headerBorder = PdfBorders();
    //   headerBorder.left = PdfPen(PdfColor(240, 0, 0), width: 2);
    //   headerBorder.top = PdfPen(PdfColor(0, 240, 0), width: 3);
    //   headerBorder.bottom = PdfPen(PdfColor(0, 0, 240), width: 4);
    //   headerBorder.right = PdfPen(PdfColor(240, 100, 240), width: 5);
    //   headerCellStyle.borders = headerBorder;
    //   headerCellStyle.cellPadding =
    //       PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
    //   headerCellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
    //   final PdfStringFormat headerStringCenterFormat = PdfStringFormat();
    //   headerStringCenterFormat.alignment = PdfTextAlignment.center;
    //   headerStringCenterFormat.lineAlignment = PdfVerticalAlignment.bottom;
    //   headerCellStyle.stringFormat = headerStringCenterFormat;
    //   headerCellStyle.stringFormat!.wordSpacing = 10;
    //   headerCellStyle.textBrush = PdfBrushes.white;
    //   headerCellStyle.textPen = PdfPens.black;
    //   final PdfTextElement element = PdfTextElement();
    //   element.text = 'Text Element Text';
    //   element.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);

    //   //TextElement drawing in header row
    //   final PdfGrid grid9 = PdfGrid();
    //   grid9.columns.add(count: 3);
    //   grid9.headers.add(1);
    //   final PdfGridRow header1_9 = grid9.headers[0];
    //   header1_9.cells[0].value = element;
    //   header1_9.cells[0].style = headerCellStyle;
    //   header1_9.cells[1].value = element;
    //   header1_9.cells[2].value = element;
    //   final PdfGridRow row1_9 = grid9.rows.add();
    //   row1_9.cells[0].value = PdfBitmap.fromBase64String(logoJpeg);
    //   row1_9.cells[0].style.cellPadding =
    //       PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
    //   row1_9.cells[0].style.cellPadding!.all = 5;
    //   row1_9.cells[0].imagePosition = PdfGridImagePosition.stretch;
    //   row1_9.cells[0]._pdfGridStretchOption = _PdfGridStretchOption.uniform;
    //   row1_9.cells[1].value = 'Row - 1 Cell - 2';
    //   row1_9.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow row2_9 = grid9.rows.add();
    //   row2_9.cells[0].value = 'Row - 2 Cell - 1';
    //   row2_9.cells[1].value = 'Row - 2 Cell - 2';
    //   row2_9.cells[2].value = 'Row - 2 Cell - 3';
    //   grid9.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_62.pdf');
    // });
    // test('-Coverage Test - 5', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();
    //   final PdfGridCellStyle headerCellStyle = PdfGridCellStyle();
    //   headerCellStyle.backgroundBrush = PdfBrushes.gray;
    //   final PdfBorders headerBorder = PdfBorders();
    //   headerBorder.left = PdfPen(PdfColor(240, 0, 0), width: 2);
    //   headerBorder.top = PdfPen(PdfColor(0, 240, 0), width: 3);
    //   headerBorder.bottom = PdfPen(PdfColor(0, 0, 240), width: 4);
    //   headerBorder.right = PdfPen(PdfColor(240, 100, 240), width: 5);
    //   headerCellStyle.borders = headerBorder;
    //   headerCellStyle.cellPadding =
    //       PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
    //   headerCellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
    //   final PdfStringFormat headerStringCenterFormat = PdfStringFormat();
    //   headerStringCenterFormat.alignment = PdfTextAlignment.center;
    //   headerStringCenterFormat.lineAlignment = PdfVerticalAlignment.bottom;
    //   headerCellStyle.stringFormat = headerStringCenterFormat;
    //   headerCellStyle.stringFormat!.wordSpacing = 10;
    //   headerCellStyle.textBrush = PdfBrushes.white;
    //   headerCellStyle.textPen = PdfPens.black;
    //   final PdfTextElement element = PdfTextElement();
    //   element.text = 'Text Element Text';
    //   element.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);

    //   //TextElement drawing in header row
    //   final PdfGrid grid9 = PdfGrid();
    //   grid9.columns.add(count: 3);
    //   grid9.headers.add(1);
    //   final PdfGridRow header1_9 = grid9.headers[0];
    //   header1_9.cells[0].value = element;
    //   header1_9.cells[0].style = headerCellStyle;
    //   header1_9.cells[1].value = element;
    //   header1_9.cells[2].value = element;
    //   final PdfGridRow row1_9 = grid9.rows.add();
    //   row1_9.cells[0].value = PdfBitmap.fromBase64String(logoJpeg);
    //   row1_9.cells[0].style.cellPadding =
    //       PdfPaddings(left: 1, right: 2, top: 3, bottom: 4);
    //   row1_9.cells[0].style.cellPadding!.all = 5;
    //   row1_9.cells[0].imagePosition = PdfGridImagePosition.stretch;
    //   row1_9.cells[0]._pdfGridStretchOption =
    //       _PdfGridStretchOption.uniformToFill;
    //   row1_9.cells[1].value = 'Row - 1 Cell - 2';
    //   row1_9.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow row2_9 = grid9.rows.add();
    //   row2_9.cells[0].value = 'Row - 2 Cell - 1';
    //   row2_9.cells[1].value = 'Row - 2 Cell - 2';
    //   row2_9.cells[2].value = 'Row - 2 Cell - 3';
    //   grid9.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_63.pdf');
    // });
    // test('-Coverage Test - 6', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    //   final PdfGrid childGrid = PdfGrid();
    //   childGrid.columns.add(count: 2);
    //   childGrid.headers.add(1);
    //   final PdfGridRow childHeader = childGrid.headers[0];
    //   childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
    //   childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
    //   final PdfGridRow childRow1 = childGrid.rows.add();
    //   childRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childRow1.cells[1].value = 'Row - 1 Cell - 2';

    //   final PdfGrid parentGrid = PdfGrid();
    //   parentGrid.columns.add(count: 3);
    //   parentGrid.headers.add(1);
    //   final PdfGridRow parentHeader = parentGrid.headers[0];
    //   parentHeader.cells[0].value = childGrid;
    //   parentHeader.cells[1].value = 'Header - 1 Cell - 2';
    //   parentHeader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow parentRow1 = parentGrid.rows.add();
    //   parentRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   parentRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   parentRow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow parentRow2 = parentGrid.rows.add();
    //   parentRow2.cells[0].value = 'Row - 2 Cell - 1';
    //   parentRow2.cells[1].value = 'Row - 2 Cell - 2';
    //   parentRow2.cells[2].value = 'Row - 2 Cell - 3';

    //   childRow1.cells[1]._parent = parentHeader.cells[0];
    //   childRow1.cells[1]._drawParentCells(
    //       page.graphics, _Rectangle(100, 100, 300, 300), false);

    //   parentGrid.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_64.pdf');
    // });
    // test('-Coverage Test - 7', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    //   final PdfGrid childGrid = PdfGrid();
    //   childGrid.columns.add(count: 2);
    //   childGrid.headers.add(1);
    //   final PdfGridRow childHeader = childGrid.headers[0];
    //   childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
    //   childHeader.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[0].style.cellPadding!.all = 5;
    //   childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
    //   childHeader.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[1].style.cellPadding!.all = 5;
    //   final PdfGridRow childRow1 = childGrid.rows.add();
    //   childRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childRow1.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   childRow1.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 5, top: 3, bottom: 7);

    //   final PdfGrid parentGrid = PdfGrid();
    //   parentGrid.columns.add(count: 3);
    //   parentGrid.headers.add(1);
    //   final PdfGridRow parentHeader = parentGrid.headers[0];
    //   parentHeader.cells[0].value = childGrid;
    //   parentHeader.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 5, top: 3, bottom: 7);
    //   parentHeader.cells[0].stringFormat = PdfStringFormat();
    //   parentHeader.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    //   parentHeader.cells[1].value = 'Header - 1 Cell - 2';
    //   parentHeader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow parentRow1 = parentGrid.rows.add();
    //   parentRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   parentRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   parentRow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow parentRow2 = parentGrid.rows.add();
    //   parentRow2.cells[0].value = 'Row - 2 Cell - 1';
    //   parentRow2.cells[1].value = 'Row - 2 Cell - 2';
    //   parentRow2.cells[2].value = 'Row - 2 Cell - 3';
    //   parentHeader.cells[0]
    //       ._adjustContentLayoutArea(_Rectangle(0, 0, 400, 200));

    //   parentGrid.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_65.pdf');
    // });
    // test('-Coverage Test - 8', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    //   final PdfGrid childGrid = PdfGrid();
    //   childGrid.columns.add(count: 2);
    //   childGrid.headers.add(1);
    //   final PdfGridRow childHeader = childGrid.headers[0];
    //   childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
    //   childHeader.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[0].style.cellPadding!.all = 5;
    //   childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
    //   childHeader.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[1].style.cellPadding!.all = 5;
    //   final PdfGridRow childRow1 = childGrid.rows.add();
    //   childRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childRow1.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   childRow1.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 5, top: 3, bottom: 7);

    //   final PdfGrid parentGrid = PdfGrid();
    //   parentGrid.columns.add(count: 3);
    //   parentGrid.headers.add(1);
    //   final PdfGridRow parentHeader = parentGrid.headers[0];
    //   parentHeader.cells[0].value = childGrid;
    //   parentHeader.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 5, top: 3, bottom: 7);
    //   parentHeader.cells[0].stringFormat = PdfStringFormat();
    //   parentHeader.cells[0].stringFormat.alignment = PdfTextAlignment.left;
    //   parentHeader.cells[1].value = 'Header - 1 Cell - 2';
    //   parentHeader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow parentRow1 = parentGrid.rows.add();
    //   parentRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   parentRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   parentRow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow parentRow2 = parentGrid.rows.add();
    //   parentRow2.cells[0].value = 'Row - 2 Cell - 1';
    //   parentRow2.cells[1].value = 'Row - 2 Cell - 2';
    //   parentRow2.cells[2].value = 'Row - 2 Cell - 3';
    //   parentHeader.cells[0]
    //       ._adjustContentLayoutArea(_Rectangle(0, 0, 400, 200));

    //   parentGrid.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_66.pdf');
    // });
    // test('-Coverage Test - 9', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    //   final PdfGrid childGrid = PdfGrid();
    //   childGrid.columns.add(count: 2);
    //   childGrid.headers.add(1);
    //   final PdfGridRow childHeader = childGrid.headers[0];
    //   childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
    //   childHeader.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[0].style.cellPadding!.all = 5;
    //   childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
    //   childHeader.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[1].style.cellPadding!.all = 5;
    //   final PdfGridRow childRow1 = childGrid.rows.add();
    //   childRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childRow1.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   childRow1.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 5, top: 3, bottom: 7);

    //   final PdfGrid parentGrid = PdfGrid();
    //   parentGrid.columns.add(count: 3);
    //   parentGrid.headers.add(1);
    //   final PdfGridRow parentHeader = parentGrid.headers[0];
    //   parentHeader.cells[0].value = childGrid;
    //   parentHeader.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 5, top: 3, bottom: 7);
    //   parentHeader.cells[0].stringFormat = PdfStringFormat();
    //   parentHeader.cells[0].stringFormat.alignment = PdfTextAlignment.right;
    //   parentHeader.cells[1].value = 'Header - 1 Cell - 2';
    //   parentHeader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow parentRow1 = parentGrid.rows.add();
    //   parentRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   parentRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   parentRow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow parentRow2 = parentGrid.rows.add();
    //   parentRow2.cells[0].value = 'Row - 2 Cell - 1';
    //   parentRow2.cells[1].value = 'Row - 2 Cell - 2';
    //   parentRow2.cells[2].value = 'Row - 2 Cell - 3';
    //   parentHeader.cells[0]
    //       ._adjustContentLayoutArea(_Rectangle(0, 0, 400, 200));

    //   parentGrid.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_67.pdf');
    // });
    // test('-Coverage Test - 10', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    //   final PdfGrid childGrid = PdfGrid();
    //   childGrid.columns.add(count: 2);
    //   childGrid.headers.add(1);
    //   final PdfGridRow childHeader = childGrid.headers[0];
    //   childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
    //   childHeader.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[0].style.cellPadding!.all = 5;
    //   childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
    //   childHeader.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[1].style.cellPadding!.all = 5;
    //   final PdfGridRow childRow1 = childGrid.rows.add();
    //   childRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childRow1.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   childRow1.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 5, top: 3, bottom: 7);

    //   final PdfGrid parentGrid = PdfGrid();
    //   parentGrid.columns.add(count: 3);
    //   parentGrid.headers.add(1);
    //   final PdfGridRow parentHeader = parentGrid.headers[0];
    //   parentHeader.cells[0].value = childGrid;
    //   parentHeader.cells[0].stringFormat = PdfStringFormat();
    //   parentHeader.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    //   parentHeader.cells[1].value = 'Header - 1 Cell - 2';
    //   parentHeader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow parentRow1 = parentGrid.rows.add();
    //   parentRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   parentRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   parentRow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow parentRow2 = parentGrid.rows.add();
    //   parentRow2.cells[0].value = 'Row - 2 Cell - 1';
    //   parentRow2.cells[1].value = 'Row - 2 Cell - 2';
    //   parentRow2.cells[2].value = 'Row - 2 Cell - 3';
    //   parentHeader.cells[0]
    //       ._adjustContentLayoutArea(_Rectangle(0, 0, 400, 200));

    //   parentGrid.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_68.pdf');
    // });
    // test('-Coverage Test - 11', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    //   final PdfGrid childGrid = PdfGrid();
    //   childGrid.columns.add(count: 2);
    //   childGrid.headers.add(1);
    //   final PdfGridRow childHeader = childGrid.headers[0];
    //   childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
    //   childHeader.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[0].style.cellPadding!.all = 5;
    //   childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
    //   childHeader.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[1].style.cellPadding!.all = 5;
    //   final PdfGridRow childRow1 = childGrid.rows.add();
    //   childRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childRow1.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   childRow1.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 5, top: 3, bottom: 7);

    //   final PdfGrid parentGrid = PdfGrid();
    //   parentGrid.columns.add(count: 3);
    //   parentGrid.headers.add(1);
    //   final PdfGridRow parentHeader = parentGrid.headers[0];
    //   parentHeader.cells[0].value = childGrid;
    //   parentHeader.cells[0].stringFormat = PdfStringFormat();
    //   parentHeader.cells[0].stringFormat.alignment = PdfTextAlignment.left;
    //   parentHeader.cells[1].value = 'Header - 1 Cell - 2';
    //   parentHeader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow parentRow1 = parentGrid.rows.add();
    //   parentRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   parentRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   parentRow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow parentRow2 = parentGrid.rows.add();
    //   parentRow2.cells[0].value = 'Row - 2 Cell - 1';
    //   parentRow2.cells[1].value = 'Row - 2 Cell - 2';
    //   parentRow2.cells[2].value = 'Row - 2 Cell - 3';
    //   parentHeader.cells[0]
    //       ._adjustContentLayoutArea(_Rectangle(0, 0, 400, 200));

    //   parentGrid.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_69.pdf');
    // });
    // test('-Coverage Test - 12', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfPage page = document.pages.add();

    //   final PdfGrid childGrid = PdfGrid();
    //   childGrid.columns.add(count: 2);
    //   childGrid.headers.add(1);
    //   final PdfGridRow childHeader = childGrid.headers[0];
    //   childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
    //   childHeader.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[0].style.cellPadding!.all = 5;
    //   childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
    //   childHeader.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childHeader.cells[1].style.cellPadding!.all = 5;
    //   final PdfGridRow childRow1 = childGrid.rows.add();
    //   childRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childRow1.cells[0].style.cellPadding =
    //       PdfPaddings(left: 3, right: 2, top: 3, bottom: 4);
    //   childRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   childRow1.cells[1].style.cellPadding =
    //       PdfPaddings(left: 3, right: 5, top: 3, bottom: 7);

    //   final PdfGrid parentGrid = PdfGrid();
    //   parentGrid.columns.add(count: 3);
    //   parentGrid.headers.add(1);
    //   final PdfGridRow parentHeader = parentGrid.headers[0];
    //   parentHeader.cells[0].value = childGrid;
    //   parentHeader.cells[0].stringFormat = PdfStringFormat();
    //   parentHeader.cells[0].stringFormat.alignment = PdfTextAlignment.right;
    //   parentHeader.cells[1].value = 'Header - 1 Cell - 2';
    //   parentHeader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow parentRow1 = parentGrid.rows.add();
    //   parentRow1.cells[0].value = 'Row - 1 Cell - 1';
    //   parentRow1.cells[1].value = 'Row - 1 Cell - 2';
    //   parentRow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow parentRow2 = parentGrid.rows.add();
    //   parentRow2.cells[0].value = 'Row - 2 Cell - 1';
    //   parentRow2.cells[1].value = 'Row - 2 Cell - 2';
    //   parentRow2.cells[2].value = 'Row - 2 Cell - 3';
    //   parentHeader.cells[0]
    //       ._adjustContentLayoutArea(_Rectangle(0, 0, 400, 200));

    //   parentGrid.draw(page: page, bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'PDFGrid_70.pdf');
    // });
    //Content row - page pagination with empty bounds - Reapeat header
    test('Rows-PaginationWithPage_Reapeat header', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.repeatHeader = true;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_71.pdf');
    });
    //Header row - Pagination-PdfLayoutBreakType-fitElement-Text element
    test('Headers-Pagination-fitElement-row breaking', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.allowRowBreakingAcrossPages = true;
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        final PdfTextElement element = PdfTextElement();
        element.text =
            'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        element.font = PdfStandardFont(PdfFontFamily.timesRoman, 15);
        header.cells[1].value = element;

        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.breakType = PdfLayoutBreakType.fitElement;
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_72.pdf');
    });
    //Header row - Pagination-PdfLayoutBreakType-fitColumnsToPage-Text element
    test('Headers-PaginationfitColumnsToPage-row breaking', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.allowRowBreakingAcrossPages = true;
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        final PdfTextElement element = PdfTextElement();
        element.text =
            'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        element.font = PdfStandardFont(PdfFontFamily.timesRoman, 15);
        header.cells[1].value = element;

        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.breakType = PdfLayoutBreakType.fitColumnsToPage;
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_73.pdf');
    });
    //Coverage Test - 13
    test('-Coverage Test - 13', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.allowRowBreakingAcrossPages = true;
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value =
            'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.breakType = PdfLayoutBreakType.fitColumnsToPage;
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_74.pdf');
    });
    //Coverage Test - 14
    test('-Coverage Test - 14', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.allowRowBreakingAcrossPages = true;
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value =
            'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      final PdfLayoutFormat format = PdfLayoutFormat();
      format.breakType = PdfLayoutBreakType.fitElement;
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_75.pdf');
    });
    //Coverage Test - 15
    test('-Coverage Test - 15', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.allowRowBreakingAcrossPages = true;
      grid.columns.add(count: 3);
      grid.headers.add(10);
      for (int i = 0; i < 10; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value =
            'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      PdfGridCellHelper.getHelper(row1.cells[0])
          .draw(page.graphics, PdfRectangle(100, 100, 150, 20), true);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_76.pdf');
    });
    //Coverage Test - 16
    test('-Coverage Test - 16', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfTemplate template1 = PdfTemplate(500, 500);
      final PdfGrid grid = PdfGrid();
      grid.allowRowBreakingAcrossPages = true;
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';

      PdfGridCellHelper.getHelper(row1.cells[0])
          .draw(template1.graphics, PdfRectangle(100, 100, 150, 20), true);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(graphics: template1.graphics, bounds: Rect.zero);
      page.graphics.drawPdfTemplate(template1, const Offset(0, 50));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_77.pdf');
    });
    //Coverage Test - 17
    test('-Coverage Test - 17', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 10);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
        header.cells[3].value = 'Header - $i Cell - 4';
        header.cells[4].value = 'Header - $i Cell - 5';
        header.cells[5].value = 'Header - $i Cell - 6';
        header.cells[6].value = 'Header - $i Cell - 7';
        header.cells[7].value = 'Header - $i Cell - 8';
        header.cells[8].value = 'Header - $i Cell - 9';
        header.cells[9].value = 'Header - $i Cell - 10';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = 'Row - 1 Cell - 6';
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = 'Row - 2 Cell - 6';
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      row2.cells[1].columnSpan = 2;
      row1.cells[5].columnSpan = 2;
      row2.cells[5].columnSpan = 2;
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_81.pdf');
    });
    //Coverage Test - 19
    test('-Coverage Test - 19', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 5);
      grid.headers.add(10);
      for (int i = 0; i < 10; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
        header.cells[3].value = 'Header - $i Cell - 4';
        header.cells[4].value = 'Header - $i Cell - 5';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      row2.cells[1].columnSpan = 2;
      row1.cells[3].columnSpan = 2;
      row2.cells[3].columnSpan = 2;
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_82.pdf');
    });
    //Coverage Test - 18
    test('-Coverage Test - 18- SetStyle', () {
      final PdfDocument document = PdfDocument();
      final PdfGridCellStyle cellStyle = PdfGridCellStyle();
      cellStyle.backgroundBrush = PdfBrushes.gray;
      final PdfBorders border = PdfBorders();
      border.left = PdfPen(PdfColor(240, 0, 0), width: 2);
      border.top = PdfPen(PdfColor(0, 240, 0), width: 3);
      border.bottom = PdfPen(PdfColor(0, 0, 240), width: 4);
      border.right = PdfPen(PdfColor(240, 100, 240), width: 5);
      cellStyle.borders = border;
      cellStyle.cellPadding = PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.center;
      format.lineAlignment = PdfVerticalAlignment.bottom;
      format.wordSpacing = 10;
      cellStyle.stringFormat = format;
      cellStyle.textBrush = PdfBrushes.white;
      cellStyle.textPen = PdfPens.black;
      final PdfGridStyle gridStyle = PdfGridStyle();
      gridStyle.cellSpacing = 2;
      gridStyle.cellPadding = PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      gridStyle.borderOverlapStyle = PdfBorderOverlapStyle.inside;
      gridStyle.backgroundBrush = PdfBrushes.lightGray;
      gridStyle.textPen = PdfPens.black;
      gridStyle.textBrush = PdfBrushes.white;
      gridStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(10);
      for (int i = 0; i < 10; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      grid.rows.applyStyle(cellStyle);
      grid.rows.applyStyle(gridStyle);
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'PDFGrid_83.pdf');
    });
    // //Coverage Test - 20
    // test('-Coverage Test - 20', () {
    //   final PdfGrid childgrid = PdfGrid();
    //   childgrid.columns.add(count: 3);
    //   childgrid.headers.add(1);
    //   final PdfGridRow childheader = childgrid.headers[0];
    //   childheader.cells[0].value = 'Header - 1 Cell - 1';
    //   childheader.cells[1].value = 'Header - 1 Cell - 2';
    //   childheader.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow childrow1 = childgrid.rows.add();
    //   childrow1.cells[0].value = 'Row - 1 Cell - 1';
    //   childrow1.cells[1].value = 'Row - 1 Cell - 2';
    //   childrow1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow childrow2 = childgrid.rows.add();
    //   childrow2.cells[0].value = 'Row - 2 Cell - 1';
    //   childrow2.cells[1].value = 'Row - 2 Cell - 2';
    //   childrow2.cells[2].value = 'Row - 2 Cell - 3';

    //   final PdfGrid grid = PdfGrid();
    //   grid.columns.add(count: 3);
    //   grid.headers.add(1);
    //   final PdfGridRow header = grid.headers[0];
    //   header.cells[0].value = 'Header - 1 Cell - 1';
    //   header.cells[1].value = 'Header - 1 Cell - 2';
    //   header.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow row1 = grid.rows.add();
    //   row1.cells[0].value = childgrid;
    //   childgrid._isChildGrid = true;
    //   childrow1.cells[0]._parent = row1.cells[0];
    //   childrow1.cells[0]._parent!._row!._width = 100;
    //   row1._width = 200;
    //   row1.cells[0].columnSpan = 2;
    //   row1.cells[1].value = 'Row - 1 Cell - 2';
    //   row1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow row2 = grid.rows.add();
    //   row2.cells[0].value = 'Row - 2 Cell - 1';
    //   row2.cells[1].value = 'Row - 2 Cell - 2';
    //   row2.cells[2].value = 'Row - 2 Cell - 3';
    //   expect(childrow1.cells[0]._calculateWidth() != null, true,
    //       reason: 'Failed to draw Simple PDF grid');
    //   childrow1.cells[0]._outerCellWidth = -1;
    // });
  });
  group('Border test', () {
    test('applying border settings', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'ID';
      header.cells[1].value = 'Name';
      header.cells[2].value = 'Salary';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'E01';
      row1.cells[1].value = 'Clay';
      row1.cells[2].value = r'$10,000';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'E02';
      row2.cells[1].value = 'Thomas';
      row2.cells[2].value = r'$10,500';
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = 'E02';
      row3.cells[1].value = 'Simon';
      row3.cells[2].value = r'$12,000';
      grid.headers[0].cells[0].style.borders.top = PdfPens.red;
      grid.headers[0].cells[0].style.borders.left = PdfPens.green;
      grid.headers[0].cells[1].style.borders.top = PdfPens.yellow;
      grid.headers[0].cells[1].style.borders.left = PdfPens.blue;
      grid.headers[0].cells[2].style.borders.top = PdfPens.gray;
      grid.headers[0].cells[2].style.borders.left = PdfPens.greenYellow;
      grid.headers[0].cells[2].style.borders.right = PdfPens.lavender;
      grid.rows[0].cells[0].style.borders.top = PdfPens.lightBlue;
      grid.rows[0].cells[0].style.borders.left = PdfPens.lightCyan;
      grid.rows[0].cells[1].style.borders.top = PdfPen(PdfColor(255, 0, 0));
      grid.rows[0].cells[1].style.borders.left =
          PdfPen.fromBrush(PdfBrushes.green);
      grid.rows[0].cells[2].style.borders.top = PdfPens.yellow;
      grid.rows[0].cells[2].style.borders.left = PdfPens.blue;
      grid.rows[0].cells[2].style.borders.right = PdfPens.greenYellow;
      grid.rows[1].cells[0].style.borders.top = PdfPens.red;
      grid.rows[1].cells[0].style.borders.left = PdfPens.green;
      grid.rows[1].cells[1].style.borders.top = PdfPens.yellow;
      grid.rows[1].cells[1].style.borders.left = PdfPens.blue;
      grid.rows[1].cells[2].style.borders.top = PdfPens.gray;
      grid.rows[1].cells[2].style.borders.left = PdfPens.greenYellow;
      grid.rows[1].cells[2].style.borders.right = PdfPens.lavender;
      grid.rows[2].cells[0].style.borders.top = PdfPens.lightBlue;
      grid.rows[2].cells[0].style.borders.left = PdfPens.lightCyan;
      grid.rows[2].cells[0].style.borders.bottom = PdfPens.red;
      grid.rows[2].cells[1].style.borders.top = PdfPens.red;
      grid.rows[2].cells[1].style.borders.left = PdfPens.green;
      grid.rows[2].cells[1].style.borders.bottom = PdfPens.yellow;
      grid.rows[2].cells[2].style.borders.top = PdfPens.yellow;
      grid.rows[2].cells[2].style.borders.left = PdfPens.blue;
      grid.rows[2].cells[2].style.borders.right = PdfPens.greenYellow;
      grid.rows[2].cells[2].style.borders.bottom = PdfPens.gray;
      grid.draw(page: page, bounds: const Rect.fromLTWH(0, 20, 0, 0));
      savePdf(document.saveSync(), 'PDFGrid_84.pdf');
      document.dispose();
    });
    test('border settings on nested grid', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid childGrid = PdfGrid();
      childGrid.columns.add(count: 2);
      childGrid.headers.add(1);
      final PdfGridRow childHeader = childGrid.headers[0];
      childHeader.cells[0].value = 'Child Header - 1 Cell - 1';
      childHeader.cells[1].value = 'Child Header - 1 Cell - 2';
      final PdfGridRow childRow1 = childGrid.rows.add();
      childRow1.cells[0].value = 'Row - 1 Cell - 1';
      childRow1.cells[1].value = 'Row - 1 Cell - 2';
      childRow1.cells[0].style.borders.top =
          PdfPen.fromBrush(PdfBrushes.green, width: 10);
      childRow1.cells[0].style.borders.left =
          PdfPen.fromBrush(PdfBrushes.red, width: 10);
      childRow1.cells[0].style.borders.bottom =
          PdfPen.fromBrush(PdfBrushes.blue, width: 10);
      childRow1.cells[1].style.borders.top =
          PdfPen.fromBrush(PdfBrushes.gray, width: 10);
      childRow1.cells[1].style.borders.right =
          PdfPen.fromBrush(PdfBrushes.greenYellow, width: 10);
      childRow1.cells[1].style.borders.left =
          PdfPen.fromBrush(PdfBrushes.yellow, width: 10);
      childRow1.cells[1].style.borders.bottom =
          PdfPen.fromBrush(PdfBrushes.violet, width: 10);
      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 3);
      parentGrid.headers.add(1);
      final PdfGridRow parentHeader = parentGrid.headers[0];
      parentHeader.cells[0].value = childGrid;
      parentHeader.cells[1].value = 'Header - 1 Cell - 2';
      parentHeader.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow parentRow1 = parentGrid.rows.add();
      parentRow1.cells[0].value = 'Row - 1 Cell - 1';
      parentRow1.cells[1].value = 'Row - 1 Cell - 2';
      parentRow1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow parentRow2 = parentGrid.rows.add();
      parentRow2.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2.cells[1].value = 'Row - 2 Cell - 2';
      parentRow2.cells[2].value = 'Row - 2 Cell - 3';
      parentGrid.headers[0].cells[0].value.headers[0].cells[0].style.borders
          .top = PdfPens.lightCyan;
      parentGrid.headers[0].cells[0].value.headers[0].cells[0].style.borders
          .left = PdfPens.lightSkyBlue;
      parentGrid.headers[0].cells[0].value.headers[0].cells[0].style.borders
          .bottom = PdfPens.lightSeaGreen;
      parentGrid.headers[0].cells[0].value.headers[0].cells[1].style.borders
          .top = PdfPens.limeGreen;
      parentGrid.headers[0].cells[0].value.headers[0].cells[1].style.borders
          .left = PdfPens.maroon;
      parentGrid.headers[0].cells[0].value.headers[0].cells[1].style.borders
          .right = PdfPens.mediumBlue;
      parentGrid.headers[0].cells[0].value.headers[0].cells[1].style.borders
          .bottom = PdfPens.mintCream;
      parentGrid.rows[1].cells[1].style.borders.all =
          PdfPen(PdfColor(255, 0, 0), width: 10);
      parentGrid.draw(page: page, bounds: Rect.zero);
      savePdf(document.saveSync(), 'PDFGrid_85.pdf');
      document.dispose();
    });
    test('Image position test 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 2);
      parentGrid.headers.add(1);
      final PdfGridRow parentHeader = parentGrid.headers[0];
      parentHeader.cells[0].value = 'ID';
      parentHeader.cells[1].value = 'Name';
      final PdfGridRow parentRow1 = parentGrid.rows.add();
      parentRow1.cells[0].value = 'Row - 1 Cell - 1';
      parentRow1.cells[1].value = 'Row - 1 Cell - 2';
      final PdfGridRow parentRow2 = parentGrid.rows.add();
      parentRow2.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2.cells[1].value = 'Row - 2 Cell - 2';
      final PdfGridCell cell = parentGrid.rows[0].cells[0];
      cell.rowSpan = 2;
      cell.columnSpan = 2;
      cell.value = 'Center';
      cell.stringFormat.alignment = PdfTextAlignment.center;
      cell.imagePosition = PdfGridImagePosition.center;
      cell.style.backgroundImage = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      parentGrid.draw(page: page, bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final PdfGrid parentGrid2 = PdfGrid();
      parentGrid2.columns.add(count: 2);
      parentGrid2.headers.add(1);
      final PdfGridRow parentHeader2 = parentGrid2.headers[0];
      parentHeader2.cells[0].value = 'ID';
      parentHeader2.cells[1].value = 'Name';
      final PdfGridRow parentRow1_2 = parentGrid2.rows.add();
      parentRow1_2.cells[0].value = 'Row - 1 Cell - 1';
      parentRow1_2.cells[1].value = 'Row - 1 Cell - 2';
      final PdfGridRow parentRow2_2 = parentGrid2.rows.add();
      parentRow2_2.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2_2.cells[1].value = 'Row - 2 Cell - 2';
      final PdfGridCell cell2 = parentGrid2.rows[0].cells[0];
      cell2.rowSpan = 2;
      cell2.columnSpan = 2;
      cell2.value = 'Stretch';
      cell2.stringFormat.alignment = PdfTextAlignment.center;
      cell2.imagePosition = PdfGridImagePosition.stretch;
      cell2.style.backgroundImage =
          PdfBitmap.fromBase64String(autumnLeavesJpeg);
      parentGrid2.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final PdfGrid parentGrid3 = PdfGrid();
      parentGrid3.columns.add(count: 2);
      parentGrid3.headers.add(1);
      final PdfGridRow parentHeader3 = parentGrid3.headers[0];
      parentHeader3.cells[0].value = 'ID';
      parentHeader3.cells[1].value = 'Name';
      final PdfGridRow parentRow1_3 = parentGrid3.rows.add();
      parentRow1_3.cells[0].value = 'Row - 1 Cell - 1';
      parentRow1_3.cells[1].value = 'Row - 1 Cell - 2';
      final PdfGridRow parentRow2_3 = parentGrid3.rows.add();
      parentRow2_3.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2_3.cells[1].value = 'Row - 2 Cell - 2';
      final PdfGridCell cell3 = parentGrid3.rows[0].cells[0];
      cell3.rowSpan = 2;
      cell3.columnSpan = 2;
      cell3.value = 'fit';
      cell3.stringFormat.alignment = PdfTextAlignment.center;
      cell3.imagePosition = PdfGridImagePosition.fit;
      cell3.style.backgroundImage =
          PdfBitmap.fromBase64String(autumnLeavesJpeg);
      parentGrid3.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final PdfGrid parentGrid4 = PdfGrid();
      parentGrid4.columns.add(count: 2);
      parentGrid4.headers.add(1);
      final PdfGridRow parentHeader4 = parentGrid4.headers[0];
      parentHeader4.cells[0].value = 'ID';
      parentHeader4.cells[1].value = 'Name';
      final PdfGridRow parentRow1_4 = parentGrid4.rows.add();
      parentRow1_4.cells[0].value = 'Row - 1 Cell - 1';
      parentRow1_4.cells[1].value = 'Row - 1 Cell - 2';
      final PdfGridRow parentRow2_4 = parentGrid4.rows.add();
      parentRow2_4.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2_4.cells[1].value = 'Row - 2 Cell - 2';
      final PdfGridCell cell4 = parentGrid4.rows[0].cells[0];
      cell4.rowSpan = 2;
      cell4.columnSpan = 2;
      cell4.value = 'tile';
      cell4.stringFormat.alignment = PdfTextAlignment.center;
      cell4.imagePosition = PdfGridImagePosition.tile;
      cell4.style.backgroundImage =
          PdfBitmap.fromBase64String(autumnLeavesJpeg);
      parentGrid4.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      savePdf(document.saveSync(), 'FLUT_3173_1.pdf');
      document.dispose();
    });
    test('Image position test 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 2);
      parentGrid.headers.add(1);
      final PdfGridRow parentHeader = parentGrid.headers[0];
      parentHeader.cells[0].value = 'Header - 1 Cell - 1';
      parentHeader.cells[1].value = 'Header - 1 Cell - 2';
      final PdfGridRow parentRow1 = parentGrid.rows.add();
      parentRow1.cells[0].value = 'Row - 1 Cell - 1';
      parentRow1.cells[0].style.backgroundImage =
          PdfBitmap.fromBase64String(logoJpeg);
      parentRow1.cells[0].imagePosition = PdfGridImagePosition.stretch;
      parentRow1.cells[1].value = 'Row - 1 Cell - 2';
      final PdfGridRow parentRow2 = parentGrid.rows.add();
      parentRow2.cells[0].value = 'Row - 2 Cell - 1';
      parentRow2.cells[0].style.backgroundImage =
          PdfBitmap.fromBase64String(logoJpeg);
      parentRow2.cells[0].imagePosition = PdfGridImagePosition.fit;
      parentRow2.cells[1].value = 'Row - 2 Cell - 2';
      final PdfGridRow parentRow3 = parentGrid.rows.add();
      parentRow3.cells[0].value = 'Row - 3 Cell - 1';
      parentRow3.cells[0].style.backgroundImage =
          PdfBitmap.fromBase64String(logoJpeg);
      parentRow3.cells[0].imagePosition = PdfGridImagePosition.center;
      parentRow3.cells[1].value = 'Row - 3 Cell - 2';
      final PdfGridRow parentRow4 = parentGrid.rows.add();
      parentRow4.cells[0].value = 'Row - 4 Cell - 1';
      parentRow4.cells[0].style.backgroundImage =
          PdfBitmap.fromBase64String(logoJpeg);
      parentRow4.cells[0].imagePosition = PdfGridImagePosition.tile;
      parentRow4.cells[1].value = 'Row - 4 Cell - 2';
      for (int i = 5; i < 101; i++) {
        final PdfGridRow row = parentGrid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
      }
      final PdfGridRow lastRow1 = parentGrid.rows.add();
      lastRow1.cells[0].value = 'Row - 101 Cell - 1';
      lastRow1.cells[1].value = 'Row - 101 Cell - 2';
      lastRow1.cells[1].style.backgroundImage =
          PdfBitmap.fromBase64String(logoJpeg);
      lastRow1.cells[1].imagePosition = PdfGridImagePosition.tile;
      final PdfGridRow lastRow2 = parentGrid.rows.add();
      lastRow2.cells[0].value = 'Row - 102 Cell - 1';
      lastRow2.cells[1].value = 'Row - 102 Cell - 2';
      lastRow2.cells[1].style.backgroundImage =
          PdfBitmap.fromBase64String(logoJpeg);
      lastRow2.cells[1].imagePosition = PdfGridImagePosition.center;
      final PdfGridRow lastRow3 = parentGrid.rows.add();
      lastRow3.cells[0].value = 'Row - 103 Cell - 1';
      lastRow3.cells[1].value = 'Row - 103 Cell - 2';
      lastRow3.cells[1].style.backgroundImage =
          PdfBitmap.fromBase64String(logoJpeg);
      lastRow3.cells[1].imagePosition = PdfGridImagePosition.fit;
      final PdfGridRow lastRow4 = parentGrid.rows.add();
      lastRow4.cells[0].value = 'Row - 104 Cell - 1';
      lastRow4.cells[1].value = 'Row - 104 Cell - 2';
      lastRow4.cells[1].style.backgroundImage =
          PdfBitmap.fromBase64String(logoJpeg);
      lastRow4.cells[1].imagePosition = PdfGridImagePosition.stretch;
      parentGrid.draw(page: page, bounds: const Rect.fromLTWH(10, 10, 0, 0));
      savePdf(document.saveSync(), 'FLUT_3173_2.pdf');
      document.dispose();
    });
    test('Image position test 3', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 2);
      parentGrid.headers.add(1);
      final PdfGridRow parentHeader = parentGrid.headers[0];
      parentHeader.cells[0].value = 'Header - 1 Cell - 1';
      parentHeader.cells[0].style.backgroundImage =
          PdfBitmap.fromBase64String(autumnLeavesJpeg);
      parentHeader.cells[0].imagePosition = PdfGridImagePosition.stretch;
      parentHeader.cells[1].value = 'Header - 1 Cell - 2';
      parentGrid.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final PdfGrid parentGrid2 = PdfGrid();
      parentGrid2.columns.add(count: 2);
      parentGrid2.headers.add(1);
      final PdfGridRow parentHeader2 = parentGrid2.headers[0];
      parentHeader2.cells[0].value = 'Header - 1 Cell - 1';
      parentHeader2.cells[1].value = 'Header - 1 Cell - 2';
      parentHeader2.cells[1].style.backgroundImage =
          PdfBitmap.fromBase64String(autumnLeavesJpeg);
      parentHeader2.cells[1].imagePosition = PdfGridImagePosition.center;
      parentGrid2.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final PdfGrid parentGrid3 = PdfGrid();
      parentGrid3.columns.add(count: 2);
      parentGrid3.headers.add(1);
      final PdfGridRow parentHeader3 = parentGrid3.headers[0];
      parentHeader3.cells[0].value = 'Header - 1 Cell - 1';
      parentHeader3.cells[0].style.backgroundImage =
          PdfBitmap.fromBase64String(autumnLeavesJpeg);
      parentHeader3.cells[0].imagePosition = PdfGridImagePosition.tile;
      parentHeader3.cells[1].value = 'Header - 1 Cell - 2';
      parentGrid3.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final PdfGrid parentGrid4 = PdfGrid();
      parentGrid4.columns.add(count: 2);
      parentGrid4.headers.add(1);
      final PdfGridRow parentHeader4 = parentGrid4.headers[0];
      parentHeader4.cells[0].value = 'Header - 1 Cell - 1';
      parentHeader4.cells[1].value = 'Header - 1 Cell - 2';
      parentHeader4.cells[1].style.backgroundImage =
          PdfBitmap.fromBase64String(autumnLeavesJpeg);
      parentHeader4.cells[1].imagePosition = PdfGridImagePosition.fit;
      parentGrid4.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      savePdf(document.saveSync(), 'FLUT_3173_3.pdf');
      document.dispose();
    });
    const String text2 =
        'The Portable Document Format (PDF) is a file format developed by Adobe in 1993 to present documents, including text formatting and images, in a manner independent of application software, hardware, and operating systems.[2][3] Based on the PostScript language, each PDF file encapsulates a complete description of a fixed-layout flat document, including the text, fonts, vector graphics, raster images and other information needed to display it. The Portable Document Format (PDF) is a file format developed by Adobe in 1993 to present documents, including text formatting and images, in a manner independent of application software, hardware, and operating systems.[2][3] Based on the PostScript language, each PDF file encapsulates a complete description of a fixed-layout flat document, including the text, fonts, vector graphics, raster images and other information needed to display it.The Portable Document Format (PDF) is a file format developed by Adobe in 1993 to present documents, including text formatting and images, in a manner independent of application software, hardware, and operating systems.[2][3] Based on the PostScript language, each PDF file encapsulates a complete description of a fixed-layout flat document, including the text, fonts, vector graphics, raster images and other information needed to display it. The Portable Document Format (PDF) is a file format developed by Adobe in 1993 to present documents, including text formatting and images, in a manner independent of application software, hardware, and operating systems.[2][3] Based on the PostScript language, each PDF file encapsulates a complete description of a fixed-layout flat document, including the text, fonts, vector graphics, raster images and other information needed to display it.';
    const String text1 =
        'The Portable Document Format (PDF) is a file format developed by Adobe in 1993 to present documents, including text formatting and images, in a manner independent of application software, hardware, and operating systems.[2][3] Based on the PostScript language, each PDF file encapsulates a complete description of a fixed-layout flat document, including the text, fonts, vector graphics, raster images and other information needed to display it. The Portable Document Format (PDF) is a file format developed by Adobe in 1993 to present documents, including text formatting and images, in a manner independent of application software, hardware, and operating systems.[2][3] Based on the PostScript language, each PDF file encapsulates a complete description of a fixed-layout flat document, including the text, fonts, vector graphics, raster images and other information needed to display it.';
    test('Image position test 4', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      final PdfImage image = PdfBitmap.fromBase64String(logoPng);
      grid.columns.add(count: 2);
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = image;
      row1.cells[1].value = text2;
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = image;
      row2.cells[0].imagePosition = PdfGridImagePosition.fit;
      row2.cells[1].value = text2;
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = image;
      row3.cells[0].imagePosition = PdfGridImagePosition.center;
      row3.cells[1].value = text2;
      final PdfGridRow row4 = grid.rows.add();
      row4.cells[0].value = image;
      row4.cells[0].imagePosition = PdfGridImagePosition.tile;
      row4.cells[1].value = text2;
      grid.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      savePdf(document.saveSync(), 'FLUT_3173_4.pdf');
      document.dispose();
    });
    test('Image position test 5', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      final PdfImage image = PdfBitmap.fromBase64String(logoPng);
      grid.columns.add(count: 1);
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = image;
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = image;
      row2.cells[0].imagePosition = PdfGridImagePosition.fit;
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = image;
      row3.cells[0].imagePosition = PdfGridImagePosition.center;
      final PdfGridRow row4 = grid.rows.add();
      row4.cells[0].value = image;
      row4.cells[0].imagePosition = PdfGridImagePosition.tile;
      grid.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 2);
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = image;
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = image;
      row2_2.cells[0].imagePosition = PdfGridImagePosition.fit;
      final PdfGridRow row3_2 = grid2.rows.add();
      row3_2.cells[0].value = image;
      row3_2.cells[0].imagePosition = PdfGridImagePosition.center;
      final PdfGridRow row4_2 = grid2.rows.add();
      row4_2.cells[0].value = image;
      row4_2.cells[0].imagePosition = PdfGridImagePosition.tile;
      grid2.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      savePdf(document.saveSync(), 'FLUT_3173_5.pdf');
      document.dispose();
    });
    test('Image position test 6', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      final PdfImage image = PdfBitmap.fromBase64String(logoPng);
      grid.columns.add(count: 1);
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Stretch';
      row1.cells[0].style.backgroundImage = image;
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Fit';
      row2.cells[0].style.backgroundImage = image;
      row2.cells[0].imagePosition = PdfGridImagePosition.fit;
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = 'Center';
      row3.cells[0].style.backgroundImage = image;
      row3.cells[0].imagePosition = PdfGridImagePosition.center;
      final PdfGridRow row4 = grid.rows.add();
      row4.cells[0].value = 'Tile';
      row4.cells[0].style.backgroundImage = image;
      row4.cells[0].imagePosition = PdfGridImagePosition.tile;
      grid.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 1);
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = text1;
      row1_2.cells[0].style.backgroundImage = image;
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = text1;
      row2_2.cells[0].style.backgroundImage = image;
      row2_2.cells[0].imagePosition = PdfGridImagePosition.fit;
      final PdfGridRow row3_2 = grid2.rows.add();
      row3_2.cells[0].value = text1;
      row3_2.cells[0].style.backgroundImage = image;
      row3_2.cells[0].imagePosition = PdfGridImagePosition.center;
      final PdfGridRow row4_2 = grid2.rows.add();
      row4_2.cells[0].value = text1;
      row4_2.cells[0].style.backgroundImage = image;
      row4_2.cells[0].imagePosition = PdfGridImagePosition.tile;
      grid2.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      savePdf(document.saveSync(), 'FLUT_3173_6.pdf');
      document.dispose();
    });
    test('Image position test 7', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      final PdfImage image = PdfBitmap.fromBase64String(logoPng);
      grid.columns.add(count: 2);
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Stretch';
      row1.cells[0].style.backgroundImage = image;
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Fit';
      row2.cells[0].style.backgroundImage = image;
      row2.cells[0].imagePosition = PdfGridImagePosition.fit;
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = 'Center';
      row3.cells[0].style.backgroundImage = image;
      row3.cells[0].imagePosition = PdfGridImagePosition.center;
      final PdfGridRow row4 = grid.rows.add();
      row4.cells[0].value = 'Tile';
      row4.cells[0].style.backgroundImage = image;
      row4.cells[0].imagePosition = PdfGridImagePosition.tile;
      grid.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 2);
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = text1;
      row1_2.cells[0].style.backgroundImage = image;
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = text1;
      row2_2.cells[0].style.backgroundImage = image;
      row2_2.cells[0].imagePosition = PdfGridImagePosition.fit;
      final PdfGridRow row3_2 = grid2.rows.add();
      row3_2.cells[0].value = text1;
      row3_2.cells[0].style.backgroundImage = image;
      row3_2.cells[0].imagePosition = PdfGridImagePosition.center;
      final PdfGridRow row4_2 = grid2.rows.add();
      row4_2.cells[0].value = text1;
      row4_2.cells[0].style.backgroundImage = image;
      row4_2.cells[0].imagePosition = PdfGridImagePosition.tile;
      grid2.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final PdfGrid grid3 = PdfGrid();
      grid3.columns.add(count: 2);
      final PdfGridRow row1_3 = grid3.rows.add();
      row1_3.cells[0].value = text1;
      row1_3.cells[0].style.backgroundImage = image;
      row1_3.cells[1].value = text2;
      final PdfGridRow row2_3 = grid3.rows.add();
      row2_3.cells[0].value = text1;
      row2_3.cells[0].style.backgroundImage = image;
      row2_3.cells[0].imagePosition = PdfGridImagePosition.fit;
      row2_3.cells[1].value = text2;
      final PdfGridRow row3_3 = grid3.rows.add();
      row3_3.cells[0].value = text1;
      row3_3.cells[0].style.backgroundImage = image;
      row3_3.cells[0].imagePosition = PdfGridImagePosition.center;
      row3_3.cells[1].value = text2;
      final PdfGridRow row4_3 = grid3.rows.add();
      row4_3.cells[0].value = text1;
      row4_3.cells[0].style.backgroundImage = image;
      row4_3.cells[0].imagePosition = PdfGridImagePosition.tile;
      row4_3.cells[1].value = text2;
      grid3.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      savePdf(document.saveSync(), 'FLUT_3173_7.pdf');
      document.dispose();
    });
  });

  pdfGridModuleCoverage();
}

// ignore: public_member_api_docs
void pdfGridModuleCoverage() {
  group('PdfGrid module coverage: ', () {
    test('Test case 1', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 20);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
        header.cells[3].value = 'Header - $i Cell - 4';
        header.cells[4].value = 'Header - $i Cell - 5';
        header.cells[5].value = 'Header - $i Cell - 6';
        header.cells[6].value = 'Header - $i Cell - 7';
        header.cells[7].value = 'Header - $i Cell - 8';
        header.cells[8].value = 'Header - $i Cell - 9';
        header.cells[9].value = 'Header - $i Cell - 10';
        header.cells[10].value = 'Header - $i Cell - 11';
        header.cells[11].value = 'Header - $i Cell - 12';
        header.cells[12].value = 'Header - $i Cell - 13';
        header.cells[13].value = 'Header - $i Cell - 14';
        header.cells[14].value = 'Header - $i Cell - 15';
        header.cells[15].value = 'Header - $i Cell - 16';
        header.cells[16].value = 'Header - $i Cell - 17';
        header.cells[17].value = 'Header - $i Cell - 18';
        header.cells[18].value = 'Header - $i Cell - 19';
        header.cells[19].value = 'Header - $i Cell - 20';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = 'Row - 1 Cell - 6';
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      row1.cells[10].value = 'Row - 1 Cell - 11';
      row1.cells[11].value = 'Row - 1 Cell - 12';
      row1.cells[12].value = 'Row - 1 Cell - 13';
      row1.cells[13].value = 'Row - 1 Cell - 14';
      row1.cells[14].value = 'Row - 1 Cell - 15';
      row1.cells[15].value = 'Row - 1 Cell - 16';
      row1.cells[16].value = 'Row - 1 Cell - 17';
      row1.cells[17].value = 'Row - 1 Cell - 18';
      row1.cells[18].value = 'Row - 1 Cell - 19';
      row1.cells[19].value = 'Row - 1 Cell - 20';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = 'Row - 2 Cell - 6';
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      row2.cells[10].value = 'Row - 2 Cell - 11';
      row2.cells[11].value = 'Row - 2 Cell - 12';
      row2.cells[12].value = 'Row - 2 Cell - 13';
      row2.cells[13].value = 'Row - 2 Cell - 14';
      row2.cells[14].value = 'Row - 2 Cell - 15';
      row2.cells[15].value = 'Row - 2 Cell - 16';
      row2.cells[16].value = 'Row - 2 Cell - 17';
      row2.cells[17].value = 'Row - 2 Cell - 18';
      row2.cells[18].value = 'Row - 2 Cell - 19';
      row2.cells[19].value = 'Row - 2 Cell - 20';
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage1.pdf');
    });

    test('Test case 2', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 20);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
        header.cells[3].value = 'Header - $i Cell - 4';
        header.cells[4].value = 'Header - $i Cell - 5';
        header.cells[5].value = 'Header - $i Cell - 6';
        header.cells[6].value = 'Header - $i Cell - 7';
        header.cells[7].value = 'Header - $i Cell - 8';
        header.cells[8].value = 'Header - $i Cell - 9';
        header.cells[9].value = 'Header - $i Cell - 10';
        header.cells[10].value = 'Header - $i Cell - 11';
        header.cells[11].value = 'Header - $i Cell - 12';
        header.cells[12].value = 'Header - $i Cell - 13';
        header.cells[13].value = 'Header - $i Cell - 14';
        header.cells[14].value = 'Header - $i Cell - 15';
        header.cells[15].value = 'Header - $i Cell - 16';
        header.cells[16].value = 'Header - $i Cell - 17';
        header.cells[17].value = 'Header - $i Cell - 18';
        header.cells[18].value = 'Header - $i Cell - 19';
        header.cells[19].value = 'Header - $i Cell - 20';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = 'Row - 1 Cell - 6';
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      row1.cells[10].value = 'Row - 1 Cell - 11';
      row1.cells[11].value = 'Row - 1 Cell - 12';
      row1.cells[12].value = 'Row - 1 Cell - 13';
      row1.cells[13].value = 'Row - 1 Cell - 14';
      row1.cells[14].value = 'Row - 1 Cell - 15';
      row1.cells[15].value = 'Row - 1 Cell - 16';
      row1.cells[16].value = 'Row - 1 Cell - 17';
      row1.cells[17].value = 'Row - 1 Cell - 18';
      row1.cells[18].value = 'Row - 1 Cell - 19';
      row1.cells[19].value = 'Row - 1 Cell - 20';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = 'Row - 2 Cell - 6';
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      row2.cells[10].value = 'Row - 2 Cell - 11';
      row2.cells[11].value = 'Row - 2 Cell - 12';
      row2.cells[12].value = 'Row - 2 Cell - 13';
      row2.cells[13].value = 'Row - 2 Cell - 14';
      row2.cells[14].value = 'Row - 2 Cell - 15';
      row2.cells[15].value = 'Row - 2 Cell - 16';
      row2.cells[16].value = 'Row - 2 Cell - 17';
      row2.cells[17].value = 'Row - 2 Cell - 18';
      row2.cells[18].value = 'Row - 2 Cell - 19';
      row2.cells[19].value = 'Row - 2 Cell - 20';
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage2.pdf');
    });

    test('Test case 3', () {
      final PdfDocument document = PdfDocument();
      final PdfImage image = PdfBitmap.fromBase64String(logoJpeg);

      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);

      //Multiple content rows
      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = 'Header - 1 Cell - 2';
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = 'Row - 1 Cell - 1';
      row1_2.cells[1].value = 'Row - 1 Cell - 2';
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';
      grid2.draw(page: document.pages.add(), bounds: Rect.zero);

      //contents alone
      final PdfGrid grid3 = PdfGrid();
      grid3.columns.add(count: 3);
      final PdfGridRow row1_3 = grid3.rows.add();
      row1_3.cells[0].value = 'Row - 1 Cell - 1';
      row1_3.cells[1].value = 'Row - 1 Cell - 2';
      row1_3.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_3 = grid3.rows.add();
      row2_3.cells[0].value = 'Row - 2 Cell - 1';
      row2_3.cells[1].value = 'Row - 2 Cell - 2';
      row2_3.cells[2].value = 'Row - 2 Cell - 3';
      grid3.draw(page: document.pages.add(), bounds: Rect.zero);

      //Multi line text in content row
      final PdfGrid grid4 = PdfGrid();
      grid4.columns.add(count: 3);
      grid4.headers.add(3);
      final PdfGridRow header1_4 = grid4.headers[0];
      header1_4.cells[0].value = 'Header - 1 Cell - 1';
      header1_4.cells[1].value = 'Header - 1 Cell - 2';
      header1_4.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_4 = grid4.headers[1];
      header2_4.cells[0].value = 'Header - 2 Cell - 1';
      header2_4.cells[1].value = 'Header - 2 Cell - 2\r\nMultiple line text';
      header2_4.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow header3_4 = grid4.headers[2];
      header3_4.cells[0].value = 'Header - 2 Cell - 1';
      header3_4.cells[1].value = 'Header - 2 Cell - 2';
      header3_4.cells[2].value = 'Header - 2 Cell - 3\r\nMultiple line text';
      final PdfGridRow row1_4 = grid4.rows.add();
      row1_4.cells[0].value = 'Row - 1 Cell - 1\r\nMultiple line text';
      row1_4.cells[1].value = 'Row - 1 Cell - 2';
      row1_4.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_4 = grid4.rows.add();
      row2_4.cells[0].value = 'Row - 2 Cell - 1';
      row2_4.cells[1].value = 'Row - 2 Cell - 2\r\nMultiple line text';
      row2_4.cells[2].value = 'Row - 2 Cell - 3';
      final PdfGridRow row3_4 = grid4.rows.add();
      row3_4.cells[0].value = 'Row - 3 Cell - 1';
      row3_4.cells[1].value = 'Row - 3 Cell - 2';
      row3_4.cells[2].value = 'Row - 3 Cell - 3\r\nMultiple line text';
      grid4.draw(page: document.pages.add(), bounds: Rect.zero);

      //Cell styles
      final PdfGrid grid5 = PdfGrid();
      grid5.columns.add(count: 3);
      grid5.headers.add(1);
      final PdfGridRow header1_5 = grid5.headers[0];
      final PdfGridCellStyle rowCellStyle1_5 = PdfGridCellStyle();
      rowCellStyle1_5.backgroundBrush = PdfBrushes.gray;
      final PdfBorders headerBorder1_5 = PdfBorders(
          left: PdfPens.red,
          top: PdfPens.black,
          right: PdfPens.green,
          bottom: PdfPens.blue);
      rowCellStyle1_5.borders = headerBorder1_5;
      rowCellStyle1_5.borders.all = PdfPen(PdfColor(245, 0, 0), width: 2);
      rowCellStyle1_5.cellPadding =
          PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      rowCellStyle1_5.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      final PdfStringFormat headerStringCenterFormat1_5 = PdfStringFormat();
      headerStringCenterFormat1_5.alignment = PdfTextAlignment.center;
      headerStringCenterFormat1_5.lineAlignment = PdfVerticalAlignment.bottom;
      headerStringCenterFormat1_5.wordSpacing = 10;
      rowCellStyle1_5.stringFormat = headerStringCenterFormat1_5;
      rowCellStyle1_5.textBrush = PdfBrushes.white;
      rowCellStyle1_5.textPen = PdfPens.black;
      header1_5.cells[0].value = 'Header - 1 Cell - 1';
      header1_5.cells[1].value = 'Header - 1 Cell - 2';
      header1_5.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_5 = grid5.rows.add();
      row1_5.cells[0].value = 'Row - 1 Cell - 1';
      row1_5.cells[0].style = rowCellStyle1_5;
      row1_5.cells[1].value = 'Row - 1 Cell - 2';
      row1_5.cells[1].style.backgroundImage = image;
      row1_5.cells[2].value = 'Row - 1 Cell - 3';
      row1_5.cells[2].style = rowCellStyle1_5;
      final PdfGridRow row2_5 = grid5.rows.add();
      row2_5.cells[0].value = 'Row - 2 Cell - 1';
      row2_5.cells[1].value = 'Row - 2 Cell - 2';
      row2_5.cells[1].style = rowCellStyle1_5;
      row2_5.cells[2].value = 'Row - 2 Cell - 3';
      grid5.draw(page: document.pages.add(), bounds: Rect.zero);

      //Row styles
      final PdfGrid grid6 = PdfGrid();
      grid6.columns.add(count: 3);
      grid6.headers.add(1);
      final PdfGridRow header1_6 = grid6.headers[0];
      final PdfGridRowStyle gridRowStyle_6 = PdfGridRowStyle();
      gridRowStyle_6.backgroundBrush = PdfBrushes.lightGray;
      gridRowStyle_6.textPen = PdfPens.black;
      gridRowStyle_6.textBrush = PdfBrushes.white;
      gridRowStyle_6.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      header1_6.cells[0].value = 'Header - 1 Cell - 1';
      header1_6.cells[1].value = 'Header - 1 Cell - 2';
      header1_6.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_6 = grid6.rows.add();
      row1_6.style = gridRowStyle_6;
      row1_6.cells[0].value = 'Row - 1 Cell - 1';
      row1_6.cells[1].value = 'Row - 1 Cell - 2';
      row1_6.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_6 = grid6.rows.add();
      row2_6.cells[0].value = 'Row - 2 Cell - 1';
      row2_6.cells[1].value = 'Row - 2 Cell - 2';
      row2_6.cells[2].value = 'Row - 2 Cell - 3';
      grid6.draw(page: document.pages.add(), bounds: Rect.zero);

      //Grid style
      final PdfGrid grid7 = PdfGrid();
      final PdfGridStyle gridStyle_7 = PdfGridStyle();
      gridStyle_7.cellSpacing = 2;
      gridStyle_7.cellPadding =
          PdfPaddings(left: 2, right: 3, top: 4, bottom: 5);
      gridStyle_7.borderOverlapStyle = PdfBorderOverlapStyle.inside;
      gridStyle_7.backgroundBrush = PdfBrushes.lightGray;
      gridStyle_7.textPen = PdfPens.black;
      gridStyle_7.textBrush = PdfBrushes.white;
      gridStyle_7.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);
      grid7.columns.add(count: 3);
      grid7.headers.add(1);
      final PdfGridRow header1_7 = grid7.headers[0];
      header1_7.cells[0].value = 'Header - 1 Cell - 1';
      header1_7.cells[1].value = 'Header - 1 Cell - 2';
      header1_7.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_7 = grid7.rows.add();
      row1_7.cells[0].value = 'Row - 1 Cell - 1';
      row1_7.cells[1].value = 'Row - 1 Cell - 2';
      row1_7.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_7 = grid7.rows.add();
      row2_7.cells[0].value = 'Row - 2 Cell - 1';
      row2_7.cells[1].value = 'Row - 2 Cell - 2';
      row2_7.cells[2].value = 'Row - 2 Cell - 3';
      grid7.style = gridStyle_7;
      grid7.draw(page: document.pages.add(), bounds: Rect.zero);

      //Image drawing in content row
      final PdfGrid grid8 = PdfGrid();
      grid8.columns.add(count: 3);
      grid8.headers.add(1);
      final PdfGridRow header1_8 = grid8.headers[0];
      header1_8.cells[0].value = 'Header - 1 Cell - 1';
      header1_8.cells[1].value = 'Header - 1 Cell - 2';
      header1_8.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_8 = grid8.rows.add();
      row1_8.cells[0].value = image;
      row1_8.cells[1].value = image;
      row1_8.cells[2].value = image;
      final PdfGridRow row2_8 = grid8.rows.add();
      row2_8.cells[0].value = 'Row - 2 Cell - 1';
      row2_8.cells[1].value = 'Row - 2 Cell - 2';
      row2_8.cells[2].value = 'Row - 2 Cell - 3';
      grid8.draw(page: document.pages.add(), bounds: Rect.zero);

      final PdfTextElement element = PdfTextElement();
      element.text = 'Text Element Text';
      element.font = PdfStandardFont(PdfFontFamily.timesRoman, 25);

      final PdfGrid grid9 = PdfGrid();
      grid9.columns.add(count: 3);
      grid9.headers.add(1);
      final PdfGridRow header1_9 = grid9.headers[0];
      header1_9.cells[0].value = 'Header - 1 Cell - 1';
      header1_9.cells[1].value = 'Header - 1 Cell - 2';
      header1_9.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_9 = grid9.rows.add();
      row1_9.cells[0].value = element;
      row1_9.cells[1].value = element;
      row1_9.cells[2].value = element;
      final PdfGridRow row2_9 = grid9.rows.add();
      row2_9.cells[0].value = 'Row - 2 Cell - 1';
      row2_9.cells[1].value = 'Row - 2 Cell - 2';
      row2_9.cells[2].value = 'Row - 2 Cell - 3';
      grid9.draw(page: document.pages.add(), bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage3.pdf');
    });

    test('Test case 4', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 20);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      header.cells[3].value = 'Header - 1 Cell - 4';
      header.cells[4].value = 'Header - 1 Cell - 5';
      header.cells[5].value = 'Header - 1 Cell - 6';
      header.cells[6].value = 'Header - 1 Cell - 7';
      header.cells[7].value = 'Header - 1 Cell - 8';
      header.cells[8].value = 'Header - 1 Cell - 9';
      header.cells[9].value = 'Header - 1 Cell - 10';
      header.cells[10].value = 'Header - 1 Cell - 11';
      header.cells[11].value = 'Header - 1 Cell - 12';
      header.cells[12].value = 'Header - 1 Cell - 13';
      header.cells[13].value = 'Header - 1 Cell - 14';
      header.cells[14].value = 'Header - 1 Cell - 15';
      header.cells[15].value = 'Header - 1 Cell - 16';
      header.cells[16].value = 'Header - 1 Cell - 17';
      header.cells[17].value = 'Header - 1 Cell - 18';
      header.cells[18].value = 'Header - 1 Cell - 19';
      header.cells[19].value = 'Header - 1 Cell - 20';
      for (int i = 0; i < 100; i++) {
        final PdfGridRow row1 = grid.rows.add();
        row1.cells[0].value = 'Row - $i Cell - 1';
        row1.cells[1].value = 'Row - $i Cell - 2';
        row1.cells[2].value = 'Row - $i Cell - 3';
        row1.cells[3].value = 'Row - $i Cell - 4';
        row1.cells[4].value = 'Row - $i Cell - 5';
        row1.cells[5].value = 'Row - $i Cell - 6';
        row1.cells[6].value = 'Row - $i Cell - 7';
        row1.cells[7].value = 'Row - $i Cell - 8';
        row1.cells[8].value = 'Row - $i Cell - 9';
        row1.cells[9].value = 'Row - $i Cell - 10';
        row1.cells[10].value = 'Row - $i Cell - 11';
        row1.cells[11].value = 'Row - $i Cell - 12';
        row1.cells[12].value = 'Row - $i Cell - 13';
        row1.cells[13].value = 'Row - $i Cell - 14';
        row1.cells[14].value = 'Row - $i Cell - 15';
        row1.cells[15].value = 'Row - $i Cell - 16';
        row1.cells[16].value = 'Row - $i Cell - 17';
        row1.cells[17].value = 'Row - $i Cell - 18';
        row1.cells[18].value = 'Row - $i Cell - 19';
        row1.cells[19].value = 'Row - $i Cell - 20';
      }
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage4.pdf');
    });

    test('Test case 5', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 20);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      header.cells[3].value = 'Header - 1 Cell - 4';
      header.cells[4].value = 'Header - 1 Cell - 5';
      header.cells[5].value = 'Header - 1 Cell - 6';
      header.cells[6].value = 'Header - 1 Cell - 7';
      header.cells[7].value = 'Header - 1 Cell - 8';
      header.cells[8].value = 'Header - 1 Cell - 9';
      header.cells[9].value = 'Header - 1 Cell - 10';
      header.cells[10].value = 'Header - 1 Cell - 11';
      header.cells[11].value = 'Header - 1 Cell - 12';
      header.cells[12].value = 'Header - 1 Cell - 13';
      header.cells[13].value = 'Header - 1 Cell - 14';
      header.cells[14].value = 'Header - 1 Cell - 15';
      header.cells[15].value = 'Header - 1 Cell - 16';
      header.cells[16].value = 'Header - 1 Cell - 17';
      header.cells[17].value = 'Header - 1 Cell - 18';
      header.cells[18].value = 'Header - 1 Cell - 19';
      header.cells[19].value = 'Header - 1 Cell - 20';
      for (int i = 0; i < 100; i++) {
        final PdfGridRow row1 = grid.rows.add();
        row1.cells[0].value = 'Row - $i Cell - 1';
        row1.cells[1].value = 'Row - $i Cell - 2';
        row1.cells[2].value = 'Row - $i Cell - 3';
        row1.cells[3].value = 'Row - $i Cell - 4';
        row1.cells[4].value = 'Row - $i Cell - 5';
        row1.cells[5].value = 'Row - $i Cell - 6';
        row1.cells[6].value = 'Row - $i Cell - 7';
        row1.cells[7].value = 'Row - $i Cell - 8';
        row1.cells[8].value = 'Row - $i Cell - 9';
        row1.cells[9].value = 'Row - $i Cell - 10';
        row1.cells[10].value = 'Row - $i Cell - 11';
        row1.cells[11].value = 'Row - $i Cell - 12';
        row1.cells[12].value = 'Row - $i Cell - 13';
        row1.cells[13].value = 'Row - $i Cell - 14';
        row1.cells[14].value = 'Row - $i Cell - 15';
        row1.cells[15].value = 'Row - $i Cell - 16';
        row1.cells[16].value = 'Row - $i Cell - 17';
        row1.cells[17].value = 'Row - $i Cell - 18';
        row1.cells[18].value = 'Row - $i Cell - 19';
        row1.cells[19].value = 'Row - $i Cell - 20';
      }
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage5.pdf');
    });

    test('Test case 6', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 10);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
        header.cells[3].value = 'Header - $i Cell - 4';
        header.cells[4].value = 'Header - $i Cell - 5';
        header.cells[5].value = 'Header - $i Cell - 6';
        header.cells[6].value = 'Header - $i Cell - 7';
        header.cells[7].value = 'Header - $i Cell - 8';
        header.cells[8].value = 'Header - $i Cell - 9';
        header.cells[9].value = 'Header - $i Cell - 10';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = 'Row - 1 Cell - 6';
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = 'Row - 2 Cell - 6';
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      row2.cells[1].columnSpan = 2;
      row1.cells[5].columnSpan = 2;
      row2.cells[5].columnSpan = 2;
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage6.pdf');
    });

    test('Test case 7', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.allowRowBreakingAcrossPages = true;
      grid.columns.add(count: 3);
      grid.headers.add(10);
      for (int i = 0; i < 10; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value =
            'Header - $i Cell - 2 Sample text for pagination. Lorem ipsum dolor sit amet,\r\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      PdfGridCellHelper.getHelper(row1.cells[0])
          .draw(page.graphics, PdfRectangle(100, 100, 150, 20), true);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage7.pdf');
    });

    test('Test case 8', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfTemplate template1 = PdfTemplate(500, 500);
      final PdfGrid grid = PdfGrid();
      grid.allowRowBreakingAcrossPages = true;
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      PdfGridCellHelper.getHelper(row1.cells[0])
          .draw(template1.graphics, PdfRectangle(100, 100, 150, 20), true);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(graphics: template1.graphics, bounds: Rect.zero);
      page.graphics.drawPdfTemplate(template1, const Offset(0, 50));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage8.pdf');
    });

    test('Test case 9', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = 'Row - 2 Cell - 1';
      row2_1.cells[1].value = 'Row - 2 Cell - 2';
      row2_1.cells[2].value = 'Row - 2 Cell - 3';

      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 20);
      grid.headers.add(100);
      const int i = 0;
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = grid1;
      header.cells[1].value = 'Header - $i Cell - 2';
      header.cells[2].value = 'Header - $i Cell - 3';
      header.cells[3].value = 'Header - $i Cell - 4';
      header.cells[4].value = 'Header - $i Cell - 5';
      header.cells[5].value = 'Header - $i Cell - 6';
      header.cells[6].value = grid1;
      header.cells[7].value = 'Header - $i Cell - 8';
      header.cells[8].value = 'Header - $i Cell - 9';
      header.cells[9].value = 'Header - $i Cell - 10';
      header.cells[10].value = 'Header - $i Cell - 11';
      header.cells[11].value = 'Header - $i Cell - 12';
      header.cells[12].value = 'Header - $i Cell - 13';
      header.cells[13].value = 'Header - $i Cell - 14';
      header.cells[14].value = 'Header - $i Cell - 15';
      header.cells[15].value = 'Header - $i Cell - 16';
      header.cells[16].value = 'Header - $i Cell - 17';
      header.cells[17].value = 'Header - $i Cell - 18';
      header.cells[18].value = 'Header - $i Cell - 19';
      header.cells[19].value = 'Header - $i Cell - 20';

      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = grid1;
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = grid1;
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      row1.cells[10].value = 'Row - 1 Cell - 11';
      row1.cells[11].value = 'Row - 1 Cell - 12';
      row1.cells[12].value = 'Row - 1 Cell - 13';
      row1.cells[13].value = 'Row - 1 Cell - 14';
      row1.cells[14].value = 'Row - 1 Cell - 15';
      row1.cells[15].value = 'Row - 1 Cell - 16';
      row1.cells[16].value = 'Row - 1 Cell - 17';
      row1.cells[17].value = 'Row - 1 Cell - 18';
      row1.cells[18].value = 'Row - 1 Cell - 19';
      row1.cells[19].value = 'Row - 1 Cell - 20';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = grid1;
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      row2.cells[10].value = 'Row - 2 Cell - 11';
      row2.cells[11].value = 'Row - 2 Cell - 12';
      row2.cells[12].value = 'Row - 2 Cell - 13';
      row2.cells[13].value = 'Row - 2 Cell - 14';
      row2.cells[14].value = 'Row - 2 Cell - 15';
      row2.cells[15].value = 'Row - 2 Cell - 16';
      row2.cells[16].value = 'Row - 2 Cell - 17';
      row2.cells[17].value = 'Row - 2 Cell - 18';
      row2.cells[18].value = 'Row - 2 Cell - 19';
      row2.cells[19].value = grid1;
      grid1.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));

      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = grid;
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = grid;
      row1_2.cells[1].value = grid1;
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = grid;
      row2_2.cells[2].value = 'Row - 2 Cell - 3';
      grid2.draw(page: document.pages.add(), bounds: Rect.zero);

      grid.draw(page: document.pages.add(), bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage9.pdf');
    });

    test('Test case 10', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfTemplate template1 = PdfTemplate(500, 500);

      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = 'Row - 2 Cell - 1';
      row2_1.cells[1].value = 'Row - 2 Cell - 2';
      row2_1.cells[2].value = 'Row - 2 Cell - 3';
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);

      final PdfGrid grid = PdfGrid();
      grid.allowRowBreakingAcrossPages = true;
      grid.columns.add(count: 3);
      grid.headers.add(100);
      for (int i = 0; i < 100; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      PdfGridCellHelper.getHelper(row1.cells[0])
          .draw(template1.graphics, PdfRectangle(100, 100, 150, 20), true);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = grid1;

      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = grid;
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = grid;
      row1_2.cells[1].value = grid1;
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = grid;
      row2_2.cells[2].value = 'Row - 2 Cell - 3';
      grid2.draw(page: document.pages.add(), bounds: Rect.zero);

      grid.draw(graphics: template1.graphics, bounds: Rect.zero);
      page.graphics.drawPdfTemplate(template1, const Offset(0, 50));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage10.pdf');
    });

    test('Test case 11', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();

      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = 'Header - 1 Cell - 2';
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = 'Row - 1 Cell - 1';
      row1_2.cells[1].value = 'Row - 1 Cell - 2';
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';

      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      grid.rows.add(grid2.rows[0]);
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = grid2;
      PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row1).grid)
          .parentCell = PdfGridHelper.getHelper(
              PdfGridRowHelper.getHelper(grid2.rows[0]).grid)
          .parentCell;
      PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row1).grid)
          .isChildGrid = true;
      PdfGridRowHelper.getHelper(row1).grid.style.cellPadding.top = -0.5;
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = grid2;
      grid.rows.add(grid2.rows[0]);
      grid.draw(page: page, bounds: Rect.zero);
      grid2.draw(page: page, bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage11.pdf');
    });

    test('Test case 12', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();

      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = 'Header - 1 Cell - 2';
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = 'Row - 1 Cell - 1';
      row1_2.cells[1].value = 'Row - 1 Cell - 2';
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';

      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = grid2;
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row1).grid)
          .parentCell = PdfGridHelper.getHelper(
              PdfGridRowHelper.getHelper(grid2.rows[0]).grid)
          .parentCell;
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = grid2;
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(page: page, bounds: Rect.zero);
      grid2.draw(page: page, bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage12.pdf');
    });

    test('Test case 13a', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      for (int i = 0; i < 5; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = 'Header - 1 Cell - 2';
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = 'Row - 1 Cell - 1';
      row1_2.cells[1].value = 'Row - 1 Cell - 2';
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';

      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = grid2;
      PdfGridRowHelper.getHelper(row1).grid.style.cellSpacing = 500;
      PdfGridCellHelper.getHelper(
              PdfGridRowHelper.getHelper(row1).grid.rows[1].cells[0])
          .pageCount = 1;
      grid.rows.add(grid2.rows[0]);

      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    });

    test('Test case 13', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();

      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = 'Header - 1 Cell - 2';
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = 'Row - 1 Cell - 1';
      row1_2.cells[1].value = 'Row - 1 Cell - 2';
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';

      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      grid.rows.add(grid2.rows[0]);
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = PdfBitmap.fromBase64String(highImageJpeg);
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = grid2;
      PdfGridHelper.getHelper(PdfGridRowHelper.getHelper(row1).grid)
          .parentCell = PdfGridHelper.getHelper(
              PdfGridRowHelper.getHelper(grid2.rows[0]).grid)
          .parentCell;
      PdfGridRowHelper.getHelper(row1).noOfPageCount = 3;
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = grid2;
      grid.rows.add(grid2.rows[0]);
      grid.draw(page: page, bounds: Rect.zero);
      grid2.draw(page: page, bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage13.pdf');
    });

    test('Test case 14', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = 'Header - 1 Cell - 1';
      header1_1.cells[1].value = 'Header - 1 Cell - 2';
      header1_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = 'Row - 1 Cell - 1';
      row1_1.cells[1].value = 'Row - 1 Cell - 2';
      row1_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = 'Row - 2 Cell - 1';
      row2_1.cells[1].value = 'Row - 2 Cell - 2';
      row2_1.cells[2].value = 'Row - 2 Cell - 3';

      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 20);
      grid.headers.add(100);
      const int i = 0;
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = grid1;
      header.cells[1].value = 'Header - $i Cell - 2';
      header.cells[2].value = 'Header - $i Cell - 3';
      header.cells[3].value = 'Header - $i Cell - 4';
      header.cells[4].value = 'Header - $i Cell - 5';
      header.cells[5].value = 'Header - $i Cell - 6';
      header.cells[6].value = grid1;
      header.cells[7].value = 'Header - $i Cell - 8';
      header.cells[8].value = 'Header - $i Cell - 9';
      header.cells[9].value = 'Header - $i Cell - 10';
      header.cells[10].value = 'Header - $i Cell - 11';
      header.cells[11].value = 'Header - $i Cell - 12';
      header.cells[12].value = 'Header - $i Cell - 13';
      header.cells[13].value = 'Header - $i Cell - 14';
      header.cells[14].value = 'Header - $i Cell - 15';
      header.cells[15].value = 'Header - $i Cell - 16';
      header.cells[16].value = 'Header - $i Cell - 17';
      header.cells[17].value = 'Header - $i Cell - 18';
      header.cells[18].value = 'Header - $i Cell - 19';
      header.cells[19].value = 'Header - $i Cell - 20';

      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = grid1;
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = grid1;
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      row1.cells[10].value = 'Row - 1 Cell - 11';
      row1.cells[11].value = 'Row - 1 Cell - 12';
      row1.cells[12].value = 'Row - 1 Cell - 13';
      row1.cells[13].value = 'Row - 1 Cell - 14';
      row1.cells[14].value = 'Row - 1 Cell - 15';
      row1.cells[15].value = 'Row - 1 Cell - 16';
      row1.cells[16].value = 'Row - 1 Cell - 17';
      row1.cells[17].value = 'Row - 1 Cell - 18';
      row1.cells[18].value = 'Row - 1 Cell - 19';
      row1.cells[19].value = 'Row - 1 Cell - 20';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = grid1;
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      row2.cells[10].value = 'Row - 2 Cell - 11';
      row2.cells[11].value = 'Row - 2 Cell - 12';
      row2.cells[12].value = 'Row - 2 Cell - 13';
      row2.cells[13].value = 'Row - 2 Cell - 14';
      row2.cells[14].value = 'Row - 2 Cell - 15';
      row2.cells[15].value = 'Row - 2 Cell - 16';
      row2.cells[16].value = 'Row - 2 Cell - 17';
      row2.cells[17].value = 'Row - 2 Cell - 18';
      row2.cells[18].value = 'Row - 2 Cell - 19';
      row2.cells[19].value = grid1;
      grid1.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));

      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = 'Header - 1 Cell - 1';
      header1_2.cells[1].value = grid;
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = grid;
      row1_2.cells[1].value = grid1;
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = 'Row - 2 Cell - 1';
      row2_2.cells[1].value = grid;
      row2_2.cells[2].value = 'Row - 2 Cell - 3';
      PdfGridRowHelper.getHelper(row2_2).grid = grid1;
      grid2.draw(page: document.pages.add(), bounds: Rect.zero);

      grid.draw(page: document.pages.add(), bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage14.pdf');
    });

    // test('Test case 15', () {
    //   final PdfDocument document = PdfDocument();
    //   final PdfGrid grid1 = PdfGrid();
    //   grid1.columns.add(count: 3);
    //   grid1.headers.add(1);
    //   final PdfGridRow header1_1 = grid1.headers[0];
    //   header1_1.cells[0].value = 'Header - 1 Cell - 1';
    //   header1_1.cells[1].value = 'Header - 1 Cell - 2';
    //   header1_1.cells[2].value = 'Header - 1 Cell - 3';
    //   final PdfGridRow row1_1 = grid1.rows.add();
    //   row1_1.cells[0].value = 'Row - 1 Cell - 1';
    //   row1_1.cells[1].value = 'Row - 1 Cell - 2';
    //   row1_1.cells[2].value = 'Row - 1 Cell - 3';
    //   final PdfGridRow row2_1 = grid1.rows.add();
    //   row2_1.cells[0].value = 'Row - 2 Cell - 1';
    //   row2_1.cells[1].value = 'Row - 2 Cell - 2';
    //   row2_1.cells[2].value = 'Row - 2 Cell - 3';
    //   final PdfGrid grid = PdfGrid();
    //   grid.style.allowHorizontalOverflow = true;
    //   grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
    //   grid.columns.add(count: 2);
    //   grid.headers.add(2);
    //   final PdfGridRow header = grid.headers[0];
    //   header.cells[0].value = 'Header - 1 Cell - 1';
    //   header.cells[1].value = 'Header - 1 Cell - 2';

    //   final PdfGridRow row1 = grid.rows.add();
    //   for (int i = 0; i < 2; i++) {
    //     row1.cells[i].value = grid1;
    //     row1.cells[i]._height = i + 10.0;
    //   }
    //   row1._isRowBreaksNextPage = true;

    //   grid.draw(
    //       page: document.pages.add(), bounds: Rect.zero);
    //   final List<int> bytes = document.saveSync();
    //   expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
    //   savePdf(bytes, 'FLUT-3065-PDFGridCoverage15.pdf');
    // });

    test('Test case 16', () {
      final PdfDocument document = PdfDocument();

      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 3);
      parentGrid.headers.add(1);
      final PdfGridRow header_1 = parentGrid.headers[0];
      header_1.cells[0].value = 'Header - 1 Cell - 1';
      header_1.cells[1].value = 'Header - 1 Cell - 2';
      header_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row_1 = parentGrid.rows.add();
      row_1.cells[0].value = 'Row - 1 Cell - 1';
      row_1.cells[1].value = 'Row - 1 Cell - 2';
      row_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row_2 = parentGrid.rows.add();
      row_2.cells[0].value = 'Row - 2 Cell - 1';

      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = parentGrid;
      header1_1.cells[1].value = parentGrid;
      header1_1.cells[2].value = parentGrid;
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = parentGrid;
      row1_1.cells[1].value = parentGrid;
      row1_1.cells[2].value = parentGrid;
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = parentGrid;
      row2_1.cells[1].value = parentGrid;
      row2_1.cells[2].value = parentGrid;

      final PdfGrid grid = PdfGrid();
      grid.style.allowHorizontalOverflow = true;
      grid.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid.columns.add(count: 20);
      grid.headers.add(10);
      const int i = 0;
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = grid1;
      header.cells[1].value = 'Header - $i Cell - 2';
      header.cells[2].value = 'Header - $i Cell - 3';
      header.cells[3].value = 'Header - $i Cell - 4';
      header.cells[4].value = 'Header - $i Cell - 5';
      header.cells[5].value = 'Header - $i Cell - 6';
      header.cells[6].value = grid1;
      header.cells[7].value = 'Header - $i Cell - 8';
      header.cells[8].value = 'Header - $i Cell - 9';
      header.cells[9].value = 'Header - $i Cell - 10';
      header.cells[10].value = 'Header - $i Cell - 11';
      header.cells[11].value = 'Header - $i Cell - 12';
      header.cells[12].value = 'Header - $i Cell - 13';
      header.cells[13].value = 'Header - $i Cell - 14';
      header.cells[14].value = 'Header - $i Cell - 15';
      header.cells[15].value = 'Header - $i Cell - 16';
      header.cells[16].value = 'Header - $i Cell - 17';
      header.cells[17].value = 'Header - $i Cell - 18';
      header.cells[18].value = 'Header - $i Cell - 19';
      header.cells[19].value = 'Header - $i Cell - 20';

      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = grid1;
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.cells[3].value = 'Row - 1 Cell - 4';
      row1.cells[4].value = 'Row - 1 Cell - 5';
      row1.cells[5].value = grid1;
      row1.cells[6].value = 'Row - 1 Cell - 7';
      row1.cells[7].value = 'Row - 1 Cell - 8';
      row1.cells[8].value = 'Row - 1 Cell - 9';
      row1.cells[9].value = 'Row - 1 Cell - 10';
      row1.cells[10].value = 'Row - 1 Cell - 11';
      row1.cells[11].value = 'Row - 1 Cell - 12';
      row1.cells[12].value = 'Row - 1 Cell - 13';
      row1.cells[13].value = 'Row - 1 Cell - 14';
      row1.cells[14].value = 'Row - 1 Cell - 15';
      row1.cells[15].value = 'Row - 1 Cell - 16';
      row1.cells[16].value = 'Row - 1 Cell - 17';
      row1.cells[17].value = 'Row - 1 Cell - 18';
      row1.cells[18].value = 'Row - 1 Cell - 19';
      row1.cells[19].value = 'Row - 1 Cell - 20';

      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      row2.cells[3].value = 'Row - 2 Cell - 4';
      row2.cells[4].value = 'Row - 2 Cell - 5';
      row2.cells[5].value = grid1;
      row2.cells[6].value = 'Row - 2 Cell - 7';
      row2.cells[7].value = 'Row - 2 Cell - 8';
      row2.cells[8].value = 'Row - 2 Cell - 9';
      row2.cells[9].value = 'Row - 2 Cell - 10';
      row2.cells[10].value = 'Row - 2 Cell - 11';
      row2.cells[11].value = 'Row - 2 Cell - 12';
      row2.cells[12].value = 'Row - 2 Cell - 13';
      row2.cells[13].value = 'Row - 2 Cell - 14';
      row2.cells[14].value = 'Row - 2 Cell - 15';
      row2.cells[15].value = 'Row - 2 Cell - 16';
      row2.cells[16].value = 'Row - 2 Cell - 17';
      row2.cells[17].value = 'Row - 2 Cell - 18';
      row2.cells[18].value = 'Row - 2 Cell - 19';
      row2.cells[19].value = grid1;
      grid1.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));

      final PdfGrid grid2 = PdfGrid();
      grid2.columns.add(count: 3);
      grid2.headers.add(2);
      final PdfGridRow header1_2 = grid2.headers[0];
      header1_2.cells[0].value = grid1;
      header1_2.cells[1].value = 'Header - 1 Cell - 2';
      header1_2.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow header2_2 = grid2.headers[1];
      header2_2.cells[0].value = 'Header - 2 Cell - 1';
      header2_2.cells[1].value = 'Header - 2 Cell - 2';
      header2_2.cells[2].value = 'Header - 2 Cell - 3';
      final PdfGridRow row1_2 = grid2.rows.add();
      row1_2.cells[0].value = header2_2;
      row1_2.cells[1].value = grid1;
      row1_2.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2_2 = grid2.rows.add();
      row2_2.cells[0].value = row1_2;
      row2_2.cells[1].value = 'Row - 2 Cell - 2';
      row2_2.cells[2].value = 'Row - 2 Cell - 3';
      grid2.draw(page: document.pages.add(), bounds: Rect.zero);

      final PdfGrid grid3 = PdfGrid();
      grid3.columns.add(count: 2);
      final PdfGridRow row3_1 = grid3.rows.add();
      row3_1.cells[0].value = grid;
      row3_1.cells[1].value = grid1;
      grid3.draw(page: document.pages.add(), bounds: Rect.zero);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage16.pdf');
    });
    test('Test case 17', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid parentGrid = PdfGrid();
      parentGrid.columns.add(count: 3);
      parentGrid.headers.add(1);
      final PdfGridRow header_1 = parentGrid.headers[0];
      header_1.cells[0].value = 'Header - 1 Cell - 1';
      header_1.cells[1].value = 'Header - 1 Cell - 2';
      header_1.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row_1 = parentGrid.rows.add();
      row_1.cells[0].value = 'Row - 1 Cell - 1';
      row_1.cells[1].value = 'Row - 1 Cell - 2';
      row_1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row_2 = parentGrid.rows.add();
      row_2.cells[0].value = 'Row - 2 Cell - 1';
      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 3);
      grid1.headers.add(1);
      final PdfGridRow header1_1 = grid1.headers[0];
      header1_1.cells[0].value = parentGrid;
      header1_1.cells[1].value = parentGrid;
      header1_1.cells[2].value = parentGrid;
      final PdfGridRow row1_1 = grid1.rows.add();
      row1_1.cells[0].value = parentGrid;
      row1_1.cells[1].value = parentGrid;
      row1_1.cells[2].value = parentGrid;
      final PdfGridRow row2_1 = grid1.rows.add();
      row2_1.cells[0].value = parentGrid;
      row2_1.cells[1].value = parentGrid;
      row2_1.cells[2].value = parentGrid;
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = grid1;
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      header.height = 770;
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = grid1;
      row1.cells[2].value = 'Row - 1 Cell - 3';
      row1.height = 764;
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = grid1;
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = parentGrid;
      row2.height = 763;
      grid.rows.setSpan(0, 0, 2, 2);
      final PdfGridRowStyle style = PdfGridRowStyle();
      style.textPen = PdfPens.red;
      grid.rows.applyStyle(style);
      final PdfGridCellStyle styles = PdfGridCellStyle();
      styles.borders.all = PdfPens.red;
      grid.headers.applyStyle(styles);
      grid.rows[0].cells[0].value = 'Syncfusion Pdf';
      grid.draw(page: page, bounds: const Rect.fromLTWH(0, 200, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'FLUT-3065-PDFGridCoverage17.pdf');
    });
  });
  group('FLUT - 5402', () {
    test('test 1', () {
      final PdfDocument document = PdfDocument();
      final PdfGrid grid1 = PdfGrid();
      grid1.columns.add(count: 4);
      grid1.headers.add(3);
      final PdfGridRow header1 = grid1.headers[0];
      header1.cells[0].value = 'Details';
      header1.cells[0].columnSpan = 4;
      final PdfGridRow header2 = grid1.headers[1];
      header2.cells[0].value = 'Header - 1 Cell - 1 and 2';
      header2.cells[0].columnSpan = 2;
      header2.cells[2].value = 'Header - 1 Cell - 3 and 4';
      header2.cells[2].columnSpan = 2;
      final PdfGridRow header3 = grid1.headers[2];
      header3.cells[0].value = 'Cell - 1';
      header3.cells[1].value = 'Cell - 2';
      header3.cells[2].value = 'Cell - 3';
      header3.cells[3].value = 'Cell - 4';
      for (int i = 0; i < 1; i++) {
        final PdfGridRow row = grid1.rows.add();
        row.cells[0].value = 'Row - 1 Cell - 1';
        row.cells[1].value = 'Row - 1 Cell - 2';
        row.cells[2].value = 'Row - 1 Cell - 3';
        row.cells[3].value = 'Row - 1 Cell - 4';
      }
      grid1.style.allowHorizontalOverflow = true;
      grid1.draw(page: document.pages.add(), bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to PDF grid with allowHorizontalOverFlow.');
      savePdf(bytes, 'FLUT-5402-1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid1 = PdfGrid();
      grid1.style.allowHorizontalOverflow = true;
      grid1.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid1.columns.add(count: 4);
      grid1.columns[0].width = 200;
      grid1.columns[1].width = 300;
      grid1.headers.add(3);
      final PdfGridRow header1 = grid1.headers[0];
      header1.cells[0].value = 'Details';
      header1.cells[0].columnSpan = 4;
      final PdfGridRow header2 = grid1.headers[1];
      header2.cells[0].value = 'Header - 1 Cell - 1 and 2';
      header2.cells[0].columnSpan = 2;
      header2.cells[2].value = 'Header - 1 Cell - 3 and 4';
      header2.cells[2].columnSpan = 2;
      header2.cells[3].value = '';
      final PdfGridRow header3 = grid1.headers[2];
      header3.cells[0].value = 'Cell - 1';
      header3.cells[1].value = 'Cell - 2';
      header3.cells[2].value = 'Cell - 3';
      header3.cells[3].value = 'Cell - 4';
      for (int i = 0; i < 20; i++) {
        final PdfGridRow row = grid1.rows.add();
        row.cells[0].value = 'Row - 1 Cell - 1';
        row.cells[1].value = 'Row - 1 Cell - 2';
        row.cells[2].value = 'Row - 1 Cell - 3';
        row.cells[3].value = 'Row - 1 Cell - 4';
      }
      grid1.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to PDF grid with horizontalOverFlowType.');
      savePdf(bytes, 'FLUT-5402-2.pdf');
      document.dispose();
    });
  });
  group('FLUT-5501', () {
    test('test 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPageTemplateElement header = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 70));
      final PdfDateTimeField dateAndTimeField = PdfDateTimeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
      final PdfCompositeField compositefields = PdfCompositeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          text: '{0}      Header',
          fields: <PdfAutomaticField>[dateAndTimeField]);
      compositefields.draw(header.graphics,
          Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
      document.template.top = header;
      final PdfPageTemplateElement footer = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      pageNumber.numberStyle = PdfNumberStyle.upperRoman;
      final PdfPageCountField count = PdfPageCountField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      count.numberStyle = PdfNumberStyle.upperRoman;
      final PdfDateTimeField dateTimeField = PdfDateTimeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateTimeField.dateFormatString = "hh':'mm':'ss";
      final PdfCompositeField compositeField = PdfCompositeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          text: 'Page {0} of {1}, Time:{2}',
          fields: <PdfAutomaticField>[pageNumber, count, dateTimeField]);
      compositeField.bounds = footer.bounds;
      compositeField.draw(
          footer.graphics,
          Offset(
              290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
      document.template.bottom = footer;
      final PdfGrid grid1 = PdfGrid();
      grid1.style.allowHorizontalOverflow = true;
      grid1.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid1.columns.add(count: 4);
      grid1.columns[0].width = 200;
      grid1.columns[1].width = 300;
      grid1.headers.add(1);
      final PdfGridRow header3 = grid1.headers[0];
      header3.cells[0].value = 'Cell - 1';
      header3.cells[1].value = 'Cell - 2';
      header3.cells[2].value = 'Cell - 3';
      header3.cells[3].value = 'Cell - 4';
      for (int i = 0; i < 100; i++) {
        final PdfGridRow row = grid1.rows.add();
        row.cells[0].value = 'Row - 1 Cell - 1';
        row.cells[1].value = 'Row - 1 Cell - 2';
        row.cells[2].value = 'Row - 1 Cell - 3';
        row.cells[3].value = 'Row - 1 Cell - 4';
      }
      grid1.draw(
        page: page,
        bounds: Rect.zero,
      );
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_5501_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPageTemplateElement header = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 70));
      final PdfDateTimeField dateAndTimeField = PdfDateTimeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
      final PdfCompositeField compositefields = PdfCompositeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          text: '{0}      Header',
          fields: <PdfAutomaticField>[dateAndTimeField]);
      compositefields.draw(header.graphics,
          Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
      document.template.top = header;
      final PdfPageTemplateElement footer = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      pageNumber.numberStyle = PdfNumberStyle.upperRoman;
      final PdfPageCountField count = PdfPageCountField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      count.numberStyle = PdfNumberStyle.upperRoman;
      final PdfDateTimeField dateTimeField = PdfDateTimeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateTimeField.dateFormatString = "hh':'mm':'ss";
      final PdfCompositeField compositeField = PdfCompositeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          text: 'Page {0} of {1}, Time:{2}',
          fields: <PdfAutomaticField>[pageNumber, count, dateTimeField]);
      compositeField.bounds = footer.bounds;
      compositeField.draw(
          footer.graphics,
          Offset(
              290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
      document.template.bottom = footer;
      final PdfGrid grid1 = PdfGrid();
      grid1.style.allowHorizontalOverflow = true;
      grid1.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid1.columns.add(count: 4);
      grid1.headers.add(3);
      final PdfGridRow header1 = grid1.headers[0];
      header1.cells[0].value = 'Details';
      header1.cells[0].columnSpan = 4;
      final PdfGridRow header2 = grid1.headers[1];
      header2.cells[0].value = 'Header - 1 Cell - 1 and 2';
      header2.cells[0].columnSpan = 2;
      header2.cells[2].value = 'Header - 1 Cell - 3 and 4';
      header2.cells[2].columnSpan = 2;
      header2.cells[3].value = '';
      final PdfGridRow header3 = grid1.headers[2];
      header3.cells[0].value = 'Cell - 1';
      header3.cells[1].value = 'Cell - 2';
      header3.cells[2].value = 'Cell - 3';
      header3.cells[3].value = 'Cell - 4';
      for (int i = 0; i < 100; i++) {
        final PdfGridRow row = grid1.rows.add();
        row.cells[0].value = 'Row - 1 Cell - 1';
        row.cells[1].value = 'Row - 1 Cell - 2';
        row.cells[2].value = 'Row - 1 Cell - 3';
        row.cells[3].value = 'Row - 1 Cell - 4';
      }
      grid1.draw(
        page: page,
        bounds: Rect.zero,
      );
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_5501_2.pdf');
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid1 = PdfGrid();
      grid1.style.allowHorizontalOverflow = true;
      grid1.style.horizontalOverflowType = PdfHorizontalOverflowType.nextPage;
      grid1.columns.add(count: 4);
      grid1.columns[0].width = 500;
      grid1.headers.add(3);
      final PdfGridRow header1 = grid1.headers[0];
      header1.cells[0].value = 'Details';
      header1.cells[0].columnSpan = 4;
      final PdfGridRow header2 = grid1.headers[1];
      header2.cells[0].value = 'Header - 1 Cell - 1 and 2';
      header2.cells[0].columnSpan = 2;
      header2.cells[2].value = 'Header - 1 Cell - 3 and 4';
      header2.cells[2].columnSpan = 2;
      final PdfGridRow header3 = grid1.headers[2];
      header3.cells[0].value = 'Cell - 1';
      header3.cells[1].value = 'Cell - 2';
      header3.cells[2].value = 'Cell - 3';
      header3.cells[3].value = 'Cell - 4';
      for (int i = 0; i < 5; i++) {
        final PdfGridRow row = grid1.rows.add();
        row.cells[0].value = 'Row - 1 Cell - 1';
        row.cells[1].value = 'Row - 1 Cell - 2';
        row.cells[2].value = 'Row - 1 Cell - 3';
        row.cells[3].value = 'Row - 1 Cell - 4';
      }
      grid1.draw(
        page: page,
        bounds: Rect.zero,
      );
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_5501_3.pdf');
      document.dispose();
    });
  });
  group(
      'FLUT-843924 Null check error occurs while drawing PDF grid in a loaded page',
      () {
    test('test', () {
      PdfDocument document = PdfDocument();
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      final PdfPage pdfPage = document.pages[0];
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Sign';
      header.cells[1].value = 'Sign';
      header.cells[2].value = 'Sign';
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = 'Sign';
      row.cells[1].value = 'Sign';
      row.cells[2].value = 'Sign';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'xxxxxxx';
      row1.cells[1].value = 'xxxxxxx';
      row1.cells[2].value = 'xxxxxxxx';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Lead';
      row2.cells[1].value = 'Manager';
      row2.cells[2].value = 'Manager';
      grid.style = PdfGridStyle(
          cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
          backgroundBrush: PdfBrushes.white,
          textBrush: PdfBrushes.black,
          font: PdfStandardFont(PdfFontFamily.helvetica, 25));
      grid.draw(page: pdfPage, bounds: Rect.zero);
      savePdf(document.saveSync(), 'FLUT-843615_test.pdf');
      document.dispose();
    });
  });
}
