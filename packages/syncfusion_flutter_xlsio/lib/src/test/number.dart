// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioNumber() {
  group('Numbers', () {
    test('setNumber()', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 2);
      range.setNumber(-10);
      final Range range1 = sheet.getRangeByIndex(6, 2);
      range1.setNumber(0.0);
      final Range range2 = sheet.getRangeByIndex(15, 15);
      range2.setNumber(100);
      final Range range3 = sheet.getRangeByIndex(4, 8);
      range3.setNumber(10.00);
      final Worksheet sheet1 = workbook.worksheets[1];
      final Range range4 = sheet1.getRangeByIndex(4, 8);
      range4.setNumber(44);
      final Range range5 = sheet1.getRangeByIndex(2, 4);
      range5.setNumber(0.34);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelNumbersUsingSetNumber.xlsx');
      workbook.dispose();
    });

    test('setNumber() with Name Index', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A4');
      range.setNumber(-10);
      final Range range1 = sheet.getRangeByName('Z10');
      range1.setNumber(0.0);
      final Range range2 = sheet.getRangeByName('AA4');
      range2.setNumber(100);
      final Range range3 = sheet.getRangeByName('D4');
      range3.setNumber(10.00);
      final Worksheet sheet1 = workbook.worksheets[1];
      final Range range4 = sheet1.getRangeByName('J16');
      range4.setNumber(-44);
      final Range range5 = sheet1.getRangeByName('M22');
      range5.setNumber(4.34);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelNumbersUsingSetNumberNameIndex.xlsx');
      workbook.dispose();
    });

    test('setNumber() for Multiple range', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 2, 2, 3);
      range.setNumber(-10);
      final Range range1 = sheet.getRangeByIndex(6, 2, 10, 4);
      range1.setNumber(0.0);
      final Range range2 = sheet.getRangeByIndex(10, 10, 15, 15);
      range2.setNumber(100);
      final Range range3 = sheet.getRangeByIndex(1, 4, 4, 8);
      range3.setNumber(10.00);
      final Worksheet sheet1 = workbook.worksheets[1];
      final Range range4 = sheet1.getRangeByIndex(4, 8, 8, 12);
      range4.setNumber(44);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelNumbersUsingSetNumberForMultipleRange.xlsx');
      workbook.dispose();
    });

    test('setNumber() for Multiple final Range with Name Index', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A4:D10');
      range.setNumber(-10);
      final Range range1 = sheet.getRangeByName('Z16:AA20');
      range1.setNumber(44);
      final Range range2 = sheet.getRangeByName('J16:M22');
      range2.setNumber(100);
      final Range range3 = sheet.getRangeByName('D20:G24');
      range3.setNumber(10.00);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(
          bytes, 'ExcelNumbersUsingSetNumberForMultipleRangeNameIndex.xlsx');
      workbook.dispose();
    });

    test('number', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[1];
      final Range range = sheet.getRangeByIndex(2, 3);
      range.number = -100;
      final Range range1 = sheet.getRangeByIndex(26, 26);
      range1.number = 26;
      final Range range2 = sheet.getRangeByIndex(10, 10);
      range2.number = 100000;
      final Range range3 = sheet.getRangeByIndex(50, 56);
      range3.number = -1000;
      final Range range4 = sheet.getRangeByIndex(8, 12);
      range4.number = -44444;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelNumbersUsingNumber.xlsx');
      workbook.dispose();
    });

    test('number for multiple range', () {
      final Workbook workbook = Workbook(3);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[2];
      final Range range = sheet.getRangeByIndex(2, 3, 10, 12);
      range.number = -100;
      final Range range1 = sheet.getRangeByIndex(10, 10, 20, 20);
      range1.number = 26;
      final Range range2 = sheet.getRangeByIndex(70, 50, 75, 50);
      range2.number = 100000;
      final Range range3 = sheet1.getRangeByIndex(20, 40, 25, 45);
      range3.number = -1000;
      final Range range4 = sheet1.getRangeByIndex(1, 12, 10, 15);
      range4.number = -44444;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelNumbersUsingNumberForMultipleRange.xlsx');
      workbook.dispose();
    });

    test('number with Name Index', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A4');
      range.number = -100;
      final Range range1 = sheet.getRangeByName('Z10');
      range1.number = 10000;
      final Range range2 = sheet.getRangeByName('AA4');
      range2.number = 1234;
      final Range range3 = sheet.getRangeByName('D4');
      range3.number = 4444;
      final Range range4 = sheet.getRangeByName('J16');
      range4.number = 2216;
      final Range range5 = sheet.getRangeByName('M22');
      range5.number = 161616;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelNumbersUsingNumberNameIndex.xlsx');
      workbook.dispose();
    });

    test('number for Multiple final Range with Name Index', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A4:D10');
      range.number = 10;
      final Range range1 = sheet.getRangeByName('Z16:AA20');
      range1.number = 44;
      final Range range2 = sheet.getRangeByName('J16:M22');
      range2.number = 1622;
      final Range range3 = sheet.getRangeByName('D20:G24');
      range3.number = -100;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(
          bytes, 'ExcelNumbersUsingNumberForMultipleRangeNameIndex.xlsx');
      workbook.dispose();
    });

    test('get() for Multiple range', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      // Multiple final Range for Number
      final Range range = sheet.getRangeByName('A1:A4');
      range.setNumber(10);
      expect(range.number, 10);
      expect(sheet.getRangeByName('A1:B5').number.toString(),
          double.nan.toString());
      expect(sheet.getRangeByName('B1:B5').number.toString(),
          double.nan.toString());

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetRangeForMultipleRange.xlsx');
      workbook.dispose();
    });
  });
}
