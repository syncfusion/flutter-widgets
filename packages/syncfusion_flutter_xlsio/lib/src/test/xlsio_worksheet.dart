// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioWorksheet() {
  group('SaveWorksheet', () {
    test('FLUT_6815_1', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.enableSheetCalculations();
      final Style style9 = workbook.styles.add('style9');
      style9.backColor = '#CFEBF1';
      style9.bold = true;
      style9.vAlign = VAlignType.center;
      style9.borders.bottom.lineStyle = LineStyle.medium;
      style9.borders.bottom.color = '#308DA2';
      style9.borders.right.lineStyle = LineStyle.thin;
      style9.borders.right.color = '#A6A6A6';
      style9.numberFormat = '#,##0.00';

      sheet.getRangeByName('I9').setValue(40);
      sheet.getRangeByName('I10').setValue(403625154);
      sheet.getRangeByName('I11').setValue(60);

      const int sumLength = 12;
      // here is code set formula:
      final Range range11 = sheet.getRangeByName('H$sumLength:I$sumLength');
      range11.merge();
      range11.cellStyle = style9;
      const int lastValue = sumLength - 1;
      range11.setFormula('=SUM(I9:I$lastValue)');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6815_1.xlsx');
      workbook.dispose();
    });
    test('worksheet tab color-1', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(2);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[1];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet.tabColor = '#0000FF';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Worksheet-TabColor1.xlsx');
      workbook.dispose();
    });

    test('worksheet tab color-2', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(2);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[1];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet.tabColor = '#FF0000';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Worksheet-TabColor2.xlsx');
      workbook.dispose();
    });

    test('worksheet tab color-3', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(2);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[1];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet.tabColor = '#FFFFFF';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Worksheet-TabColor3.xlsx');
      workbook.dispose();
    });

    test('worksheet tab color-4', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(2);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[1];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet.tabColor = '#000000';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Worksheet-TabColor4.xlsx');
      workbook.dispose();
    });

    test('worksheet tab color-5', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(2);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[1];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet.tabColor = '#008000';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Worksheet-TabColor5.xlsx');
      workbook.dispose();
    });

    test('worksheet tab color-6', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(10);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[1];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet.tabColor = '#FF0000';
      // Accessing sheet via index.
      final Worksheet sheet2 = workbook.worksheets[2];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet2.tabColor = '#FF0000';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Worksheet-TabColor6.xlsx');
      workbook.dispose();
    });

    test('worksheet tab color-7', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(10);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[1];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet.tabColor = '#FF0000';
      // Accessing sheet via index.
      final Worksheet sheet2 = workbook.worksheets[2];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet2.tabColor = '#FFFFFF';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Worksheet-TabColor7.xlsx');
      workbook.dispose();
    });

    test('worksheet tab color-8', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(10);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[1];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet.tabColor = '#008000';
      // Accessing sheet via index.
      final Worksheet sheet2 = workbook.worksheets[2];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet2.tabColor = '#FFFFFF';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Worksheet-TabColor8.xlsx');
      workbook.dispose();
    });

    test('worksheet tab color-9', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(10);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[1];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet.tabColor = '#FF0000';
      // Accessing sheet via index.
      final Worksheet sheet2 = workbook.worksheets[2];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet2.tabColor = '#FFFFFF';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Worksheet-TabColor9.xlsx');
      workbook.dispose();
    });

    test('worksheet tab color-10', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(10);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[1];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet.tabColor = '#FF0000';
      // Accessing sheet via index.
      final Worksheet sheet2 = workbook.worksheets[2];
      sheet.getRangeByName('A1:M10').setText('TabColor');
      //Applied tab color for worksheet.
      sheet2.tabColor = '#FFFFFF';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Worksheet-TabColor10.xlsx');
      workbook.dispose();
    });

    test('Empty', () {
      final Workbook workbook = Workbook();
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetEmpty.xlsx');
      workbook.dispose();
    });

    test('Name', () {
      final Workbook workbook = Workbook();
      workbook.worksheets.addWithName('sale');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetName.xlsx');
      workbook.dispose();
    });

    test('with ColumnIndex', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getColumnIndex('A1');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetWithColumnIndex.xlsx');
      workbook.dispose();
    });

    test('With getRangeByIndex()', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 2);
      range.setText('M');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetWithIndex.xlsx');
      workbook.dispose();
    });

    test('With getRangeByIndex()', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 2, 3, 3);
      range.setNumber(1);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetWithMuiltpleIndex.xlsx');
      workbook.dispose();
    });

    test('With getRangeByName()', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A8');
      range.setNumber(1);
      final Range range1 = sheet.getRangeByName('AA8');
      range1.setText('M');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetWithName.xlsx');
      workbook.dispose();
    });

    test('With getRangeByName()', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A4:B8');
      range.setText('M');
      final Range range2 = sheet.getRangeByName('A11:C12');
      range2.setText('M');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetWithMultpleRange.xlsx');
      workbook.dispose();
    });

    test('RowHeight', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A4');
      range.rowHeight = 50;
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.rowHeight = 10;
      final Range range2 = sheet.getRangeByName('A8');
      range2.rowHeight = 75;
      final Range range3 = sheet.getRangeByIndex(10, 1);
      range3.rowHeight = 100;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetRowHeight.xlsx');
      workbook.dispose();
    });

    test('ColumnWidth', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.columnWidth = 10;
      final Range range1 = sheet.getRangeByIndex(1, 2);
      range1.columnWidth = 20;
      final Range range2 = sheet.getRangeByName('C3');
      range2.columnWidth = 40;
      final Range range3 = sheet.getRangeByIndex(1, 4);
      range3.columnWidth = 60;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetColumnWidth.xlsx');
      workbook.dispose();
    });

    test('RowHeight ColumnWidth', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.rowHeight = 10;
      final Range range1 = sheet.getRangeByIndex(1, 2);
      range1.columnWidth = 20;
      final Range range2 = sheet.getRangeByName('A4');
      range2.rowHeight = 40;
      final Range range3 = sheet.getRangeByIndex(1, 4);
      range3.columnWidth = 5;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetRowHeightColumnWidth.xlsx');
      workbook.dispose();
    });

    test('GridLines', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.showGridlines = false;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorksheetGridLine.xlsx');
      workbook.dispose();
    });

    test('WorstCase', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      try {
        sheet.getRangeByName('A');
      } catch (e) {
        expect('Exception: cellReference cannot be less then 2 symbols',
            e.toString());
      }
      try {
        sheet.getRangeByName('');
      } catch (e) {
        expect('Exception: cellReference should not be null', e.toString());
      }
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelExceptions.xlsx');
      workbook.dispose();
    });

    test('setColumnWidthInPixel', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.setColumnWidthInPixels(2, 20);
      sheet.setColumnWidthInPixels(4, 40);
      sheet.setColumnWidthInPixels(8, 80);
      sheet.setColumnWidthInPixels(12, 120);
      sheet.setColumnWidthInPixels(16, 160);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSetColumnWidthInPIxels.xlsx');
      workbook.dispose();
    });

    test('setRowHeightInPixel', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.setRowHeightInPixels(2, 60);
      sheet.setRowHeightInPixels(4, 40);
      sheet.setRowHeightInPixels(8, 80);
      sheet.setRowHeightInPixels(12, 120);
      sheet.setRowHeightInPixels(16, 160);
      sheet.setRowHeightInPixels(20, 200);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSetRowHeightInPIxels.xlsx');
      workbook.dispose();
    });

    test('SetColumnWidthInPixel and setRowHeightInPixel', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.setRowHeightInPixels(2, 40);
      sheet.setColumnWidthInPixels(2, 80);
      sheet.setRowHeightInPixels(8, 100);
      sheet.setColumnWidthInPixels(8, 200);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSetColumnWidthSetRowHeightInPIxels.xlsx');
      workbook.dispose();
    });

    test('HideRowAndColumn', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      /// Hide first 5 rows.
      sheet.getRangeByName('A1:A5').showRows(false);

      /// Hide columns from C to E
      sheet.getRangeByName('C10:E10').showColumns(false);

      /// Hide Rows from 15 to 20 and columns from G to H.
      sheet.getRangeByName('G15:H20').showRange(false);

      /// Hide Rows from 22 to 25 and Column J
      sheet.getRangeByName('J22:j25').showRange(false);

      /// Hide Rows from 27 to 30 and Column L.
      sheet.getRangeByName('L27:L30').showRange(false);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelHideRowColumn.xlsx');
      workbook.dispose();
    });
  });
  group('RTLDirection', () {
    test('RTLForWorksheet', () {
      //RTL Direction for single worksheet.
      final Workbook workbook = Workbook();

      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Hello World';
      sheet.isRightToLeft = true;
      sheet.getRangeByName('D1').text = 'Hello World';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'RTLForWorksheet.xlsx');
      workbook.dispose();
    });
    test('RTLForWorkbook', () {
      //RTL Direction for whole Workbook.
      final Workbook workbook = Workbook(3);
      workbook.isRightToLeft = true;

      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Hello World';

      final Worksheet sheet1 = workbook.worksheets[1];
      sheet1.getRangeByName('A1').text = 'Hello World';

      final Worksheet sheet2 = workbook.worksheets[2];
      sheet2.getRangeByName('A1').text = 'Hello World';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'RTLForWorkbook.xlsx');
      workbook.dispose();
    });
    test('LTRForParticulareSheet', () {
      //RTL Direction for whole Workbook and LTR for single sheet.
      final Workbook workbook = Workbook(3);
      workbook.isRightToLeft = true;
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Hello World';

      final Worksheet sheet1 = workbook.worksheets[1];
      sheet.getRangeByName('B1').text = 'Hello World';
      sheet1.isRightToLeft = false;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'LTRForParticulareSheet.xlsx');
      workbook.dispose();
    });
    test('LRTForCreatedSheet', () {
      //RTL Direction for whole Workbook and create 2 sheet.
      final Workbook workbook = Workbook(3);
      workbook.isRightToLeft = true;

      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').text = 'Hello World';
      final Worksheet sheet1 = workbook.worksheets[1];
      sheet1.getRangeByName('A1').text = 'Hello World';

      workbook.worksheets.create(2);
      final Worksheet sheet2 = workbook.worksheets[3];
      sheet2.getRangeByName('A1').text = 'Hello World';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'LRTForCreatedSheet.xlsx');
      workbook.dispose();
    });

    test('Hide/show worksheet', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(10);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[2];
      sheet.getRangeByName('A1:M10').setText('Visibility');

      ///set the visibility for the worksheet.
      sheet.visibility = WorksheetVisibility.hidden;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'HideWorksheet.xlsx');
      workbook.dispose();
    });

    test('Hide/show worksheets-1', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(20);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[3];
      final Worksheet sheet2 = workbook.worksheets[10];
      sheet.getRangeByName('A1:M10').setText('Visibility');

      ///set the visibility for the worksheet.
      sheet.visibility = WorksheetVisibility.hidden;
      sheet2.visibility = WorksheetVisibility.hidden;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'HideWorksheet1.xlsx');
      workbook.dispose();
    });

    test('Hide/show worksheet-2', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(20);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[3];
      final Worksheet sheet2 = workbook.worksheets[10];
      sheet.getRangeByName('A1:M10').setText('Visibility');

      ///set the visibility for the worksheet.
      sheet.visibility = WorksheetVisibility.visible;
      sheet2.visibility = WorksheetVisibility.visible;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'HideWorksheet2.xlsx');
      workbook.dispose();
    });
  });
  //test cases for the move worksheet
  group('FLUT-6742-Moving worksheet', () {
    //moving worksheet
    test('FLUT_6742_1', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(20);
      final Worksheet sheet = workbook.worksheets[10];
      final Worksheet sheet1 = workbook.worksheets[3];
      sheet.getRangeByName('A1:B10').text = 'Moving Sheet';
      sheet1.getRangeByName('A1:B20').dateTime = DateTime(2006, 9, 10);
      sheet.hyperlinks.add(sheet.getRangeByName('C1:C5'), HyperlinkType.url,
          'http://www.gmail.com');

      //Move worksheet
      workbook.worksheets.moveTo(workbook.worksheets[10], 5);
      workbook.worksheets.moveTo(workbook.worksheets[3], 15);

      //save and dispose.
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6742_1.xlsx');
      workbook.dispose();
    });
    //Moving worksheet with image
    test('FLUT_6742_2', () {
      final Workbook workbook = Workbook(5);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet2 = workbook.worksheets[2];

      final Picture picture1 = sheet.pictures.addBase64(1, 2, image24png);
      picture1.rotation = 60;

      final Picture picture2 = sheet2.pictures.addBase64(24, 10, image14png);
      picture2.rotation = 120;

      final Picture picture3 = sheet.pictures.addBase64(8, 15, image15jpg);
      picture3.rotation = 90;

      final Picture picture4 = sheet2.pictures.addBase64(1, 2, image24png);
      picture4.rotation = 90;

      //Move worksheet
      workbook.worksheets.moveTo(workbook.worksheets[0], 3);
      workbook.worksheets.moveTo(workbook.worksheets[1], 0);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6742_2.xlsx');
      workbook.dispose();
    });
    //_Moving_worksheet_with_dataValidation
    test('FLUT_6742_3', () {
      //Creating one worksheet and accessing the first sheet
      final Workbook workbook = Workbook(5);
      final Worksheet sheet = workbook.worksheets[0];

      //Accessing the first cell in excel-sheet and applying the date properties
      final DataValidation dateValidation =
          sheet.getRangeByName('A1').dataValidation;
      dateValidation.allowType = ExcelDataValidationType.date;
      dateValidation.comparisonOperator =
          ExcelDataValidationComparisonOperator.between;
      dateValidation.firstDateTime = DateTime(1997, 07, 22);
      dateValidation.secondDateTime = DateTime(1997, 07, 25);
      dateValidation.errorBoxText =
          'date value should be given and it should be between 22ndJuly1997 and 25thJuly1997';
      dateValidation.errorBoxTitle = 'ERROR';
      dateValidation.promptBoxText = 'Data validation for date';
      dateValidation.showPromptBox = true;

      expect(dateValidation.allowType, ExcelDataValidationType.date);
      expect(dateValidation.comparisonOperator,
          ExcelDataValidationComparisonOperator.between);
      expect(dateValidation.firstDateTime, DateTime(1997, 07, 22));
      expect(dateValidation.secondDateTime, DateTime(1997, 07, 25));
      expect(dateValidation.errorBoxText,
          'date value should be given and it should be between 22ndJuly1997 and 25thJuly1997');
      expect(dateValidation.promptBoxText, 'Data validation for date');
      expect(dateValidation.errorBoxTitle, 'ERROR');
      expect(dateValidation.showPromptBox, true);

      //move worksheet
      workbook.worksheets.moveTo(workbook.worksheets[0], 2);

      //Save and dispose Workbook
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6742_3.xlsx');
      workbook.dispose();
    });
    //_Moving_worksheet_with_table
    test('FLUT_6742_4', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(10);
      final Worksheet sheet = workbook.worksheets[5];
      final Worksheet sheet2 = workbook.worksheets[6];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      sheet2
          .getRangeByName('A1')
          .setText(sheet.getRangeByName('A1').displayText);
      sheet2
          .getRangeByName('A2')
          .setText(sheet.getRangeByName('A2').displayText);
      sheet2
          .getRangeByName('A3')
          .setText(sheet.getRangeByName('A3').displayText);
      sheet2
          .getRangeByName('A4')
          .setText(sheet.getRangeByName('A4').displayText);

      sheet2
          .getRangeByName('B1')
          .setText(sheet.getRangeByName('B1').displayText);
      sheet2
          .getRangeByName('B2')
          .setNumber(sheet.getRangeByName('B2').getNumber());
      sheet2
          .getRangeByName('B3')
          .setNumber(sheet.getRangeByName('B3').getNumber());
      sheet2
          .getRangeByName('B4')
          .setNumber(sheet.getRangeByName('B4').getNumber());

      sheet2
          .getRangeByName('C1')
          .setText(sheet.getRangeByName('C1').displayText);
      sheet2
          .getRangeByName('C2')
          .setNumber(sheet.getRangeByName('B2').getNumber());
      sheet2
          .getRangeByName('C3')
          .setNumber(sheet.getRangeByName('B2').getNumber());
      sheet2
          .getRangeByName('C4')
          .setNumber(sheet.getRangeByName('B2').getNumber());
      final ExcelTable table = sheet2.tableCollection
          .create('Table1', sheet2.getRangeByName('A1:C4'));

      expect(table.builtInTableStyle, ExcelTableBuiltInStyle.tableStyleMedium2);

      //Move worksheet
      workbook.worksheets.moveTo(workbook.worksheets[5], 2);
      workbook.worksheets.moveTo(workbook.worksheets[6], 0);

      //save and dispose.
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6742_4.xlsx');
      workbook.dispose();
    });
    //_Moving_worksheet_with_AutoFilterfilter
    test('FLUT_6742_5', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(10);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[9];
      final Worksheet sheet2 = workbook.worksheets[5];
      //Load data
      sheet.getRangeByName('A1').setText('Angela Davis');
      sheet.getRangeByName('A2').setText('aNgeLa DaViS.');
      sheet.getRangeByName('A3').setText('Enoch Powell');
      sheet.getRangeByName('A4').setText('Al-Biruni');
      sheet.getRangeByName('A5').setText('ANgeLa DAViS');
      sheet.getRangeByName('A6').setText('Will Roscoe');
      sheet.getRangeByName('A7').setText('al-biruNi');
      sheet.getRangeByName('A8').setText('Christopher Hogwood');
      sheet.getRangeByName('A9').setText('Al-BirUni');
      sheet.getRangeByName('A10').setText('KarlMarx');

      sheet.getRangeByName('B1').setText('India');
      sheet.getRangeByName('B2').setText('America');
      sheet.getRangeByName('B3').setText('Australia');
      sheet.getRangeByName('B4').setText('Russia');
      sheet.getRangeByName('B5').setText('Canada');
      sheet.getRangeByName('B6').setText('Japan');
      sheet.getRangeByName('B7').setText('China');
      sheet.getRangeByName('B8').setText('Srilanka');
      sheet.getRangeByName('B9').setText('Africa');
      sheet.getRangeByName('B10').setText('France');

      sheet.getRangeByName('C1').setText('DOJ');
      sheet.getRangeByName('C2').dateTime = DateTime(2006, 9, 10);
      sheet.getRangeByName('C3').dateTime = DateTime(2000, 6, 10);
      sheet.getRangeByName('C4').dateTime = DateTime(2002, 9, 18);
      sheet.getRangeByName('C5').dateTime = DateTime(2009, 5, 23);
      sheet.getRangeByName('C6').dateTime = DateTime(2012, 1, 6);
      sheet.getRangeByName('C7').dateTime = DateTime(2007, 7, 19);
      sheet.getRangeByName('C8').dateTime = DateTime(2008, 6, 30);
      sheet.getRangeByName('C9').dateTime = DateTime(2002, 4, 16);
      sheet.getRangeByName('C10').dateTime = DateTime(2008, 11, 29);

      //Intialize Filter Range for text Filter
      sheet1.getRangeByName('A1').setText(sheet.getRangeByName('A1').getText());
      sheet1.getRangeByName('A2').setText(sheet.getRangeByName('A2').getText());
      sheet1.getRangeByName('A3').setText(sheet.getRangeByName('A3').getText());
      sheet1.getRangeByName('A4').setText(sheet.getRangeByName('A4').getText());
      sheet1.getRangeByName('A5').setText(sheet.getRangeByName('A5').getText());
      sheet1.getRangeByName('A6').setText(sheet.getRangeByName('A6').getText());
      sheet1.getRangeByName('A7').setText(sheet.getRangeByName('A7').getText());
      sheet1.getRangeByName('A8').setText(sheet.getRangeByName('A8').getText());
      sheet1.getRangeByName('A9').setText(sheet.getRangeByName('A9').getText());
      sheet1
          .getRangeByName('A10')
          .setText(sheet.getRangeByName('A10').getText());

      sheet1.getRangeByName('B1').setText(sheet.getRangeByName('B1').getText());
      sheet1.getRangeByName('B2').setText(sheet.getRangeByName('B2').getText());
      sheet1.getRangeByName('B3').setText(sheet.getRangeByName('B3').getText());
      sheet1.getRangeByName('B4').setText(sheet.getRangeByName('B4').getText());
      sheet1.getRangeByName('B5').setText(sheet.getRangeByName('B5').getText());
      sheet1.getRangeByName('B6').setText(sheet.getRangeByName('B6').getText());
      sheet1.getRangeByName('B7').setText(sheet.getRangeByName('B7').getText());
      sheet1.getRangeByName('B8').setText(sheet.getRangeByName('B8').getText());
      sheet1.getRangeByName('B9').setText(sheet.getRangeByName('B9').getText());
      sheet1
          .getRangeByName('B10')
          .setText(sheet.getRangeByName('B10').getText());

      sheet.autoFilters.filterRange = sheet.getRangeByName('A1:B10');
      final AutoFilter autofilter = sheet.autoFilters[0];
      autofilter.addTextFilter(<String>{'Angela Davis', 'Al-BirUni'});

      //Intialize Filter Range
      sheet2.getRangeByName('A1').setText('DOJ');
      sheet2.getRangeByName('A2').dateTime =
          sheet.getRangeByName('A1').getDateTime();
      sheet2.getRangeByName('A3').dateTime =
          sheet.getRangeByName('A1').getDateTime();
      sheet2.getRangeByName('A4').dateTime =
          sheet.getRangeByName('A1').getDateTime();
      sheet2.getRangeByName('A5').dateTime =
          sheet.getRangeByName('A1').getDateTime();
      sheet2.getRangeByName('A6').dateTime =
          sheet.getRangeByName('A1').getDateTime();
      sheet2.getRangeByName('A7').dateTime =
          sheet.getRangeByName('A1').getDateTime();
      sheet2.getRangeByName('A8').dateTime =
          sheet.getRangeByName('A1').getDateTime();
      sheet2.getRangeByName('A9').dateTime =
          sheet.getRangeByName('A1').getDateTime();
      sheet2.getRangeByName('A10').dateTime =
          sheet.getRangeByName('A1').getDateTime();
      sheet2.autoFilters.filterRange = sheet2.getRangeByName('A1:A10');
      final AutoFilter autofilter1 = sheet.autoFilters[1];
      autofilter1.addDateFilter(DateTime(2006, 9), DateTimeFilterType.month);

      //Move worksheet
      workbook.worksheets.moveTo(workbook.worksheets[9], 0);
      workbook.worksheets.moveTo(workbook.worksheets[6], 1);

      //save and dispose.
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6742_5.xlsx');
      workbook.dispose();
    });
    //Moving_worksheet_with_conditional_Formattings
    test('FLUT_6742_6', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(10);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[5];

      // Applying conditional formatting.
      final ConditionalFormats conditions =
          sheet.getRangeByName('A1:A4').conditionalFormats;
      final ConditionalFormat condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.cellValue;
      condition1.operator = ExcelComparisonOperator.between;
      condition1.firstFormula = '10';
      condition1.secondFormula = '20';
      condition1.backColor = '#209301';
      condition1.fontColor = '#FFFFFF';
      condition1.isBold = true;
      condition1.isItalic = true;
      condition1.underline = true;
      condition1.bottomBorderStyle = LineStyle.double;
      condition1.bottomBorderColor = '#738911';
      sheet.getRangeByIndex(1, 1).number = 16;
      sheet.getRangeByIndex(2, 1).number = 18;
      sheet.getRangeByIndex(3, 1).number = 12;
      sheet.getRangeByIndex(4, 1).number = 10;

      // Applying conditional formatting.
      final ConditionalFormats conditions1 =
          sheet.getRangeByName('B1:B8').conditionalFormats;
      final ConditionalFormat condition2 = conditions1.addCondition();
      condition2.formatType = ExcelCFType.cellValue;
      condition2.operator = ExcelComparisonOperator.between;
      condition2.firstFormula = r'=$A$4';
      condition2.secondFormula = r'=$A$2';
      condition2.backColor = '#382102';
      condition2.fontColor = '#FF328F';
      condition2.isBold = true;
      condition2.isItalic = true;
      condition2.underline = true;
      condition2.rightBorderStyle = LineStyle.thick;
      condition2.rightBorderColor = '#20099F';
      condition2.numberFormat = '0.00';

      sheet.getRangeByIndex(1, 2).number =
          sheet.getRangeByIndex(1, 1).getNumber();
      sheet.getRangeByIndex(2, 2).number =
          sheet.getRangeByIndex(2, 1).getNumber();
      sheet.getRangeByIndex(3, 2).number =
          sheet.getRangeByIndex(3, 1).getNumber();
      sheet.getRangeByIndex(4, 2).number =
          sheet.getRangeByIndex(4, 1).getNumber();
      sheet.getRangeByIndex(5, 2).number = 10;
      sheet.getRangeByIndex(6, 2).number = 12;
      sheet.getRangeByIndex(7, 2).number = 13;
      sheet.getRangeByIndex(8, 2).number = 20;

      condition1.backColor = '#7AD223';

      ///move worksheet
      workbook.worksheets.moveTo(workbook.worksheets[5], 0);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6742_6.xlsx');
      workbook.dispose();
    });

    //Moving worksheet with formula
    test('FLUT_6742_7', () {
      final Workbook workbook = Workbook(10);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[1];
      sheet1.getRangeByIndex(1, 1).number = 10;
      sheet1.getRangeByIndex(1, 2).number = 20;
      sheet1.getRangeByIndex(1, 3).number = 12;
      sheet1.getRangeByIndex(2, 1).number = 23;
      sheet1.getRangeByIndex(2, 2).number = 43;
      sheet1.getRangeByIndex(2, 3).number = 31;
      sheet1.getRangeByIndex(3, 1).number = 25;
      sheet1.getRangeByIndex(3, 2).number = 52;
      sheet1.getRangeByIndex(3, 3).number = 23;
      sheet1.getRangeByIndex(4, 1).number = 41;
      sheet1.getRangeByIndex(4, 2).number = 75;
      sheet1.getRangeByIndex(4, 3).number = 54;
      sheet.getRangeByIndex(1, 1).number = 10;
      sheet.getRangeByIndex(1, 2).number = 20;
      sheet.getRangeByIndex(1, 3).number = 12;
      sheet.getRangeByIndex(2, 1).number = 23;
      sheet.getRangeByIndex(2, 2).number = 43;
      sheet.getRangeByIndex(2, 3).number = 31;
      sheet.getRangeByIndex(3, 1).number = 25;
      sheet.getRangeByIndex(3, 2).number = 52;
      sheet.getRangeByIndex(3, 3).number = 23;
      sheet.getRangeByIndex(4, 1).number = 41;
      sheet.getRangeByIndex(4, 2).number = 75;
      sheet.getRangeByIndex(4, 3).number = 54;

      sheet.enableSheetCalculations();
      Range range = sheet.getRangeByName('A6');
      range.formula = '=Sheet2!B1-Sheet1!A1';
      range = sheet.getRangeByName('A7');
      range.formula = '=Sheet2!C1*Sheet1!B1';
      range = sheet.getRangeByName('A8');
      range.formula = '=Sheet2!B3/Sheet1!B2';
      range = sheet.getRangeByName('A9');
      range.formula = '=Sheet1!B2>Sheet1!A1';
      range = sheet.getRangeByName('A9');
      range.formula = '=Sheet1!B2>Sheet2!A1';
      expect('TRUE', range.calculatedValue);
      range = sheet.getRangeByName('A10');
      range.formula = '=Sheet1!B3<Sheet2!A2';
      expect('FALSE', range.calculatedValue);
      range = sheet.getRangeByName('A11');
      range.formula = '=Sheet2!C1>=Sheet2!A3';
      expect('FALSE', range.calculatedValue);
      range = sheet.getRangeByName('B6');
      range.formula = '=Sheet2!C3<=Sheet2!A4';
      expect('FALSE', range.calculatedValue);
      range = sheet.getRangeByName('B7');
      range.formula = '=Sheet2!C3=Sheet2!A2';
      expect('TRUE', range.calculatedValue);
      range = sheet.getRangeByName('B8');
      range.formula = '=Sheet2!A2<>Sheet2!B2';
      expect('TRUE', range.calculatedValue);
      range = sheet.getRangeByName('B9');
      range.formula = '=-A1';
      expect('-10.0', range.calculatedValue);
      range = sheet.getRangeByName('B10');
      range.formula = '=B4^3';
      expect('421875.0', range.calculatedValue);
      range = sheet.getRangeByName('B11');
      range.formula = '=(Sheet1!A1+Sheet2!B1)*(Sheet1!B1-Sheet2!A1)';
      expect('300.0', range.calculatedValue);
      range = sheet.getRangeByName('B12');
      range.formula = '=Sheet2!A1&" "&Sheet2!B1';
      expect('10.0 20.0', range.calculatedValue);
      //move worksheet
      workbook.worksheets.moveTo(workbook.worksheets[0], 2);
      workbook.worksheets.moveTo(workbook.worksheets[0], 1);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6742_7.xlsx');
      workbook.dispose();
    });

    //_Moving_Locked_Worksheet
    test('FLUT_6742_8', () {
      final Workbook workbook = Workbook(3);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[2];
      final Range range = sheet.getRangeByName('A1:D4');
      final Range range2 = sheet1.getRangeByName('B1:D10');
      range.setText('LOckedSheet');
      range2.setText('LOckedSheet');
      sheet.protect('Syncfusion');
      sheet1.protect('Syncfusion');
      workbook.worksheets.moveTo(workbook.worksheets[0], 2);
      workbook.worksheets.moveTo(workbook.worksheets[1], 0);
      //range.cellStyle.locked = false;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6742_8.xlsx');
      workbook.dispose();
    });
    //_tryTo_Move_worksheet_with_Neagtive_Destination_index
    test('FLUT_6742_9', () {
      try {
        final Workbook workbook = Workbook(15);
        final Worksheet sheet = workbook.worksheets[10];
        sheet.getRangeByName('A1:S21').text = 'Moving Sheet';
        //Move worksheet
        workbook.worksheets.moveTo(workbook.worksheets[10], -1);
      } catch (e) {
        expect('Exception: destinationIndex should be starts from 0',
            e.toString());
      }
    });
    //_tryTo_move_worksheet_with_outofBoundryIndex
    test('FLUT_6742_10', () {
      try {
        final Workbook workbook = Workbook(15);
        final Worksheet sheet = workbook.worksheets[10];
        sheet.getRangeByName('A1:S21').text = 'Moving Sheet';
        //Move worksheet
        workbook.worksheets.moveTo(workbook.worksheets[10], 100);
      } catch (e) {
        expect(
            'Exception: destinationIndex should be in the range of worksheet count',
            e.toString());
      }
    });
  });
  //test cases for freeze pane
  group('FLUT-6934-Freeze panes', () {
    // Freeze top row
    test('FLUT_6934_1', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      // Freeze top row
      worksheet.getRangeByName('A1:H10').text = 'FreezePane';
      worksheet.getRangeByName('A2').freezePanes();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6934_1.xlsx');
      workbook.dispose();
    });
    // Freeze left column
    test('FLUT_6934_2', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      // Freeze left column
      worksheet.getRangeByName('A1:H10').text = 'FreezePane';
      worksheet.getRangeByName('B1').freezePanes();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6934_2.xlsx');
      workbook.dispose();
    });
    // Freeze both row and column
    test('FLUT_6934_3', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      // Freeze both row and column
      worksheet.getRangeByName('A1:H10').text = 'FreezePane';
      worksheet.getRangeByName('B2').freezePanes();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6934_3.xlsx');
      workbook.dispose();
    });
    // Freeze both rows and columns
    test('FLUT_6934_4', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      // Freeze both rows and columns
      worksheet.getRangeByName('A1:M40').text = 'FreezePane';
      worksheet.getRangeByName('D4').freezePanes();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6934_4.xlsx');
      workbook.dispose();
    });
    // Freeze both row and column
    test('FLUT_6934_5', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      // Freeze panes with more than one cell as input range
      worksheet.getRangeByName('A1:H10').text = 'FreezePane';
      worksheet.getRangeByName('C3:G8').freezePanes();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6934_5.xlsx');
      workbook.dispose();
    });

    /// Removes the existing freeze panes from the worksheet.
    test('FLUT_6934_6', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];

      worksheet.getRangeByName('A1:H10').text = 'FreezePane';
      worksheet.getRangeByName('C4').freezePanes();
      // Removes the existing freeze panes
      worksheet.unfreezePanes();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6934_6.xlsx');
      workbook.dispose();
    });
    // Freeze rows and columns in multiple sheets
    test('FLUT_6934_7', () {
      final Workbook workbook = Workbook(3);
      final Worksheet sheet1 = workbook.worksheets[0];
      // Freeze rows in sheet1
      sheet1.getRangeByName('A1:H10').text = 'FreezePane';
      sheet1.getRangeByName('A5').freezePanes();

      final Worksheet sheet2 = workbook.worksheets[1];
      // Freeze columns in sheet2
      sheet2.getRangeByName('A1:H10').text = 'FreezePane';
      sheet2.getRangeByName('D1').freezePanes();

      final Worksheet sheet3 = workbook.worksheets[2];
      // Freeze both rows and columns in sheet3
      sheet3.getRangeByName('A1:H10').text = 'FreezePane';
      sheet3.getRangeByName('C4').freezePanes();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_6934_7.xlsx');
      workbook.dispose();
    });
  });
}
