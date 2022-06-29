part of xlsio;

// ignore: public_member_api_docs
void xlsioWorksheet() {
  group('SaveWorksheet', () {
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
  });
}
