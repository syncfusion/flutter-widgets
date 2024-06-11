// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

/// PageSetup settings
void xlsioPageSetup() {
  group('PageSetup settings', () {
    // Blackandwhite
    test('FLUT_6932_1', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style style = workbook.styles.add('style');
      style.fontColor = '#C67878';
      final Range range = sheet.getRangeByName('A1:D4');
      range.text = 'BlackWhite';
      range.cellStyle = style;
      // Blackandwhite
      sheet.pageSetup.isBlackAndWhite = true;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_1.xlsx');
      workbook.dispose();
    });
    // Print grid lines
    test('FLUT_6932_2', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1:D4').text = 'GridLines';
      // Cell GridLines are printed
      sheet.pageSetup.showGridlines = true;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_2.xlsx');
      workbook.dispose();
    });
    // Print headings
    test('FLUT_6932_3', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1:D4').text = 'Headings';
      // Print headings
      sheet.pageSetup.showHeadings = true;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_3.xlsx');
      workbook.dispose();
    });
    // Center Horizontally and center Vertically
    test('FLUT_6932_4', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1:D4').text = 'Hello';
      // Center Horizontally and center Vertically
      sheet.pageSetup.isCenterHorizontally = true;
      sheet.pageSetup.isCenterVertically = true;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_4.xlsx');
      workbook.dispose();
    });
    // Fit to page
    test('FLUT_6932_5', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      // Fit to page
      sheet.getRangeByName('A1:X80').text = 'PagePrint';
      sheet.getRangeByName('A1:M1').text = 'Page';
      sheet.getRangeByName('C1:C80').text = 'Page';
      sheet.pageSetup.isFitToPage = true;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_5.xlsx');
      workbook.dispose();
    });
    // Landscape page orientation
    test('FLUT_6932_6', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      // Landscape page orientation
      sheet.getRangeByName('A1:D4').text = 'Hello';
      sheet.pageSetup.orientation = ExcelPageOrientation.landscape;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_6.xlsx');
      workbook.dispose();
    });
    // Over then down page order
    test('FLUT_6932_7', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      // Over then down PageOrder
      sheet.getRangeByName('A1:X80').text = 'PagePrint';
      sheet.getRangeByName('A1:M1').text = 'Page';
      sheet.getRangeByName('C1:C80').text = 'Page';
      sheet.pageSetup.order = ExcelPageOrder.overThenDown;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_7.xlsx');
      workbook.dispose();
    });
    // Print cell errer as dash
    test('FLUT_6932_8', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      // Print cell errer as dash
      sheet.getRangeByName('A1:D3').text = 'Hello';
      sheet.getRangeByName('B4').number = 987;
      sheet.getRangeByName('C4').number = 5678;
      sheet.getRangeByName('D4').formula = 'ASIN(B4:C4)';
      sheet.pageSetup.printErrors = CellErrorPrintOptions.dash;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_8.xlsx');
      workbook.dispose();
    });
    // Page margins
    test('FLUT_6932_9', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1:M20').text = 'Hello';
      // Page margins
      sheet.pageSetup.topMargin = 1;
      sheet.pageSetup.leftMargin = 2;
      sheet.pageSetup.rightMargin = 1.25;
      sheet.pageSetup.bottomMargin = 1;
      sheet.pageSetup.footerMargin = 4;
      sheet.pageSetup.headerMargin = 3.5;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_9.xlsx');
      workbook.dispose();
    });

    // Fit to pages tall
    test('FLUT_6932_10', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1').text = 'S:NO';
      sheet.getRangeByName('B1').text = 'Name';
      sheet.getRangeByName('C1').text = 'Roll NO';
      sheet.getRangeByName('D1').text = 'Tottal mark';
      sheet.getRangeByName('A2:A150').number = 1;
      sheet.getRangeByName('B2:B150').text = 'Names';
      sheet.getRangeByName('C2:C150').number = 36288;
      sheet.getRangeByName('D2:D150').number = 425;
      // Fit to pages tall
      sheet.pageSetup.fitToPagesTall = 2;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_10.xlsx');
      workbook.dispose();
    });
    // Fit to pages wide
    test('FLUT_6932_11', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1').text = 'S:NO';
      sheet.getRangeByName('A2').text = 'Name';
      sheet.getRangeByName('A3').text = 'Roll NO';
      sheet.getRangeByName('A4').text = 'Tottal mark';
      sheet.getRangeByName('B1:BB1').number = 1;
      sheet.getRangeByName('B2:BB2').text = 'Names';
      sheet.getRangeByName('B3:BB3').number = 7584;
      sheet.getRangeByName('B4:BB4').number = 423;
      // Fit to pages wide
      sheet.pageSetup.fitToPagesWide = 2;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_11.xlsx');
      workbook.dispose();
    });
    // Paper size
    test('FLUT_6932_12', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1:M40').text = 'Hello';
      // A2 paper size
      sheet.pageSetup.paperSize = ExcelPaperSize.a2Paper;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_12.xlsx');
      workbook.dispose();
    });
    // Paper margin with paper size
    test('FLUT_6932_13', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1:M20').text = 'Hello';

      sheet.pageSetup.paperSize = ExcelPaperSize.paperFolio;
      // Paper margin with paper size
      sheet.pageSetup.topMargin = 1;
      sheet.pageSetup.leftMargin = 2;
      sheet.pageSetup.rightMargin = 5;
      sheet.pageSetup.bottomMargin = 1;
      sheet.pageSetup.footerMargin = 1;
      sheet.pageSetup.headerMargin = 1;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_13.xlsx');
      workbook.dispose();
    });
    // Print title row
    test('FLUT_6932_14', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'S:NO';
      sheet.getRangeByName('B1').text = 'Name';
      sheet.getRangeByName('C1').text = 'Roll NO';
      sheet.getRangeByName('D1').text = 'Tottal mark';
      sheet.getRangeByName('A2:A100').number = 1;
      sheet.getRangeByName('B2:B100').text = 'Names';
      sheet.getRangeByName('C2:C100').number = 36288;
      sheet.getRangeByName('D2:D100').number = 425;
      // Print title row
      sheet.pageSetup.printTitleRows = 'A1:D1';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_14.xlsx');
      workbook.dispose();
    });
    // Print title column
    test('FLUT_6932_15', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1').text = 'S:NO';
      sheet.getRangeByName('A2').text = 'Name';
      sheet.getRangeByName('A3').text = 'Roll NO';
      sheet.getRangeByName('A4').text = 'Tottal mark';
      sheet.getRangeByName('B1:MM1').number = 1;
      sheet.getRangeByName('B2:MM2').text = 'Names';
      sheet.getRangeByName('B3:MM3').number = 7584;
      sheet.getRangeByName('B4:MM4').number = 423;
      // Print title rows and column
      sheet.pageSetup.printTitleColumns = 'A1:A4';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_15.xlsx');
      workbook.dispose();
    });
    // Print titles for different sheets
    test('FLUT_6932_16', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet1 = workbook.worksheets[0];
      sheet1.getRangeByName('A1').text = 'S:NO';
      sheet1.getRangeByName('B1').text = 'Name';
      sheet1.getRangeByName('C1').text = 'Roll NO';
      sheet1.getRangeByName('D1').text = 'Tottal mark';
      sheet1.getRangeByName('A2:A100').number = 1;
      sheet1.getRangeByName('B2:B100').text = 'Names';
      sheet1.getRangeByName('C2:C100').number = 36288;
      sheet1.getRangeByName('D2:D100').number = 425;
      // Print title row
      sheet1.pageSetup.printTitleRows = 'A1:D1';

      final Worksheet sheet2 = workbook.worksheets[1];
      sheet2.getRangeByName('A1').text = 'S:NO';
      sheet2.getRangeByName('A2').text = 'Name';
      sheet2.getRangeByName('A3').text = 'Roll NO';
      sheet2.getRangeByName('A4').text = 'Tottal mark';
      sheet2.getRangeByName('B1:MM1').number = 1;
      sheet2.getRangeByName('B2:MM2').text = 'Names';
      sheet2.getRangeByName('B3:MM3').number = 7584;
      sheet2.getRangeByName('B4:MM4').number = 423;
      // Print title rows and columns
      sheet2.pageSetup.printTitleColumns = 'A1:A4';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_16.xlsx');
      workbook.dispose();
    });
    // Print area for different sheets
    test('FLUT_6932_17', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet1 = workbook.worksheets[0];
      sheet1.getRangeByName('A1:M40').text = 'PrintArea';
      // Print area for sheet1
      sheet1.pageSetup.printArea = 'A1:E10';
      final Worksheet sheet2 = workbook.worksheets[1];
      sheet2.getRangeByName('A1:M40').text = 'PrintArea';
      // Print area for sheet2
      sheet2.pageSetup.printArea = 'A1:D20';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_17.xlsx');
      workbook.dispose();
    });
    // Draft quality
    test('FLUT_6932_18', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style style = workbook.styles.add('style');
      style.fontColor = '#C67878';
      final Range range = sheet.getRangeByName('A1:D4');
      range.text = 'Draft';
      range.cellStyle = style;
      // Draft quality
      sheet.pageSetup.isDraft = true;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_18.xlsx');
      workbook.dispose();
    });
    // Print quality
    test('FLUT_6932_19', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      // Print quality
      sheet.getRangeByName('A1:M20').text = 'Hello';
      sheet.pageSetup.printQuality = 700;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6932_19.xlsx');
      workbook.dispose();
    });
  });
}
