// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioDisplayText() {
  group('DisplayText', () {
    test('getDateDisplay()', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      range.numberFormat = 'm/d/yyyy';
      range.setDateTime(DateTime(2020, 8, 23, 8, 15, 20));
      expect('8/23/2020', range.displayText);
      final Range range1 = sheet.getRangeByIndex(1, 2);
      range1.numberFormat = 'd-mmm-yy';
      range1.setDateTime(DateTime(2020, 08, 23, 8, 15, 20));
      expect('23-Aug-20', range1.displayText);
      final Range range2 = sheet.getRangeByIndex(1, 3);
      range2.numberFormat = 'mmm-yy';
      range2.setDateTime(DateTime(2020, 08, 23, 8, 15, 20));
      expect('Aug-20', range2.displayText);
      final Range range3 = sheet.getRangeByIndex(1, 4);
      range3.numberFormat = 'd/mm';
      range3.setDateTime(DateTime(2020, 08, 23, 8, 15, 20));
      expect('23/08', range3.displayText);
      final Range range4 = sheet.getRangeByIndex(1, 5);
      range4.numberFormat = 'd.mm.yyyy';
      range4.setDateTime(DateTime(2001, 09, 2, 8, 15, 20));
      expect('2.09.2001', range4.displayText);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetDateDisplay.xlsx');
      workbook.dispose();
    });

    test('getTimeDisplay', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      range.numberFormat = 'h:mm:ss AM/PM';
      range.setDateTime(DateTime(2020, 8, 23, 10, 15, 20));
      // ignore: unused_local_variable
      String text = range.displayText;
      final Range range1 = sheet.getRangeByIndex(1, 2);
      range1.numberFormat = 'h:mm';
      range1.setDateTime(DateTime(2020, 08, 23, 8, 15, 20));
      text = range1.displayText;
      final Range range2 = sheet.getRangeByIndex(1, 3);
      range2.numberFormat = 'mm:ss.0';
      range2.setDateTime(DateTime(2020, 08, 23, 8, 15, 20));
      text = range2.displayText;
      final Range range3 = sheet.getRangeByIndex(1, 4);
      range3.numberFormat = '[h]:mm:ss';
      range3.setDateTime(DateTime(2020, 08, 23, 8, 15, 20));
      text = range3.displayText;
      final Range range4 = sheet.getRangeByIndex(1, 5);
      range4.numberFormat = 'h.mm';
      range4.setDateTime(DateTime(2011, 04, 04, 12, 47, 6));
      text = range4.displayText;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetTimeDisplay.xlsx');
      workbook.dispose();
    });

    test('getDateTimeDisplay', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.numberFormat = 'm/d/yyyy h:mm';
      range1.setDateTime(DateTime(2020, 8, 23, 10, 15, 20));
      // ignore: unused_local_variable
      final String text = range1.displayText;
      final Range range2 = sheet.getRangeByIndex(1, 2);
      range2.numberFormat = 'm.d.yyyy h.mm';
      range2.setDateTime(DateTime(2013, 12, 13, 13, 13, 13));
      expect('12.13.2013 13.13', range2.displayText);
      final Range range3 = sheet.getRangeByIndex(1, 3);
      range3.numberFormat = 'mmm-yy hh:mm';
      range3.setDateTime(DateTime(2011, 12, 12, 12, 02, 12));
      expect('Dec 11 12:2', range3.displayText);
      final Range range4 = sheet.getRangeByIndex(1, 4);
      range4.numberFormat = 'd-mmm-yy hh.mm';
      range4.setDateTime(DateTime(2014, 2, 14, 14, 14, 14));
      expect('14 Feb 14 14.14', range4.displayText);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetDateTimeDisplay.xlsx');
      workbook.dispose();
    });

    test('getNumberDisplay', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      range.numberFormat = '0.00';
      range.setNumber(279);
      expect('279.00', range.displayText);
      final Range range1 = sheet.getRangeByIndex(2, 2);
      range1.numberFormat = '#,##0.0000';
      range1.setNumber(-2211);
      expect('-2,211.0000', range1.displayText);
      final Range range2 = sheet.getRangeByIndex(3, 3);
      range2.numberFormat = '[Blue](#,##0)';
      range2.setNumber(9032);
      expect('[Blue](9,032)', range2.displayText);
      final Range range3 = sheet.getRangeByIndex(4, 4);
      range3.numberFormat = '(#,##0)';
      range3.number = 1291;
      expect('(1,291)', range3.displayText);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetNumberDisplay.xlsx');
      workbook.dispose();
    });

    test('getAccountsDisplay', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.numberFormat = '0%';
      range1.setNumber(123);
      expect('12300%', range1.displayText);
      final Range range2 = sheet.getRangeByIndex(2, 2);
      range2.numberFormat = '0.00%';
      range2.setNumber(145);
      expect('14500.00%', range2.displayText);
      final Range range3 = sheet.getRangeByIndex(3, 3);
      range3.numberFormat = '#,##0_)';
      range3.setNumber(4444.4);
      expect('4,444_)', range3.displayText);
      final Range range4 = sheet.getRangeByIndex(4, 4);
      range4.numberFormat = r'_(* \\(#,##0\\)';
      range4.setNumber(23892);
      expect(r'_(* (23,892)', range4.displayText);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetAccountsDisplay.xlsx');
      workbook.dispose();
    });

    test('getCurrencyDisplay', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      range.numberFormat = r'$#,##0';
      range.setNumber(1231);
      expect(r'$1,231', range.displayText);
      final Range range1 = sheet.getRangeByIndex(3, 1);
      range1.numberFormat = r'$#,##0.00';
      range1.number = 3212;
      expect(r'$3,212.00', range1.displayText);
      final Range range2 = sheet.getRangeByIndex(5, 1);
      range2.numberFormat = r"_('$'* '-'??_)";
      range2.number = 4055;
      expect(r'$ 4055', range2.displayText);
      final Range range3 = sheet.getRangeByIndex(7, 1);
      range3.numberFormat = r'[GREEN]$#,##0.00';
      range3.number = 37101;
      expect(r'[GREEN]$37,101.00', range3.displayText);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetCurrencyDisplay.xlsx');
      workbook.dispose();
    });

    test('getOtherDisplay', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      range.numberFormat = '0.00E+00';
      range.setNumber(12345);
      expect('1.23E+04', range.displayText);
      final Range range1 = sheet.getRangeByIndex(1, 2);
      range1.numberFormat = '##0.0E+0';
      range1.setNumber(12345);
      expect('12.3E+3', range1.displayText);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetOtherDisplay.xlsx');
      workbook.dispose();
    });

    test('getTimeDisplay1', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range3 = sheet.getRangeByIndex(1, 4);
      range3.numberFormat = '[h]:mm:ss';
      range3.setNumber(0.4900549768);
      // ignore: unused_local_variable
      final String text = range3.displayText;
      // expect('11:45:41', range3.displayText);

      final Range range4 = sheet.getRangeByIndex(1, 5);
      range4.numberFormat = 'hh:mm:ss.000';
      range4.setNumber(0.4900549768);
      expect('11:45:40.749', range4.displayText);

      final Range range5 = sheet.getRangeByIndex(1, 6);
      range5.numberFormat = 'hh:mm:ss.00';
      range5.setNumber(0.4900549768);
      expect('11:45:40.75', range5.displayText);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetTimeDisplay1.xlsx');
      workbook.dispose();
    });
  });
}
