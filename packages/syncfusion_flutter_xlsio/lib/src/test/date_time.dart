// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioDateTime() {
  group('DateTime', () {
    test('setDateTime()', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 2);
      range.setDateTime(DateTime(2020, 1, 1, 1));
      final Range range1 = sheet.getRangeByIndex(2, 4);
      range1.setDateTime(DateTime(2014, 12, 30));
      final Range range2 = sheet.getRangeByIndex(8, 8);
      range2.setDateTime(DateTime.now());
      final Range range3 = sheet.getRangeByIndex(7, 7);
      range3.setDateTime(DateTime(2013, 5, 23));

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDateTimeSetDateTime.xlsx');
      workbook.dispose();
    });

    test('setDateTime() by Name Index', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByName('A4');
      range.setDateTime(DateTime(2020, 7, 7, 1));
      final Range range1 = sheet.getRangeByName('D4');
      range1.setDateTime(DateTime(1997, 11, 22));
      final Range range2 = sheet.getRangeByName('E4');
      range2.setDateTime(DateTime.now());
      final Range range3 = sheet.getRangeByName('J6');
      range3.setDateTime(DateTime(1995, 5, 5));

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDateTimeSetDateTimeByNameIndex.xlsx');
      workbook.dispose();
    });

    test('dateTime', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(3, 4);
      range.dateTime = DateTime(2442, 12, 6, 23, 34, 23);
      final Range range1 = sheet.getRangeByIndex(10, 7);
      range1.dateTime = DateTime(1998, 3, 9, 3, 50, 40);
      final Range range2 = sheet.getRangeByIndex(3, 5);
      range2.dateTime = DateTime.now();
      final Range range3 = sheet.getRangeByIndex(3, 2);
      range3.dateTime = DateTime(2014, 5, 9, 2, 7);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDateTimedateTime.xlsx');
      workbook.dispose();
    });

    test('dateTime by Name Index', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByName('A2');
      range.dateTime = DateTime(2022, 12, 30, 10, 43);
      final Range range1 = sheet.getRangeByName('B4');
      range1.dateTime = DateTime(1995, 6, 16, 10, 30, 40);
      final Range range2 = sheet.getRangeByName('C6');
      range2.dateTime = DateTime.now();
      final Range range3 = sheet.getRangeByName('D8');
      range3.dateTime = DateTime(2014, 3, 31, 16, 27);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDateTimedateTimeByNameIndex.xlsx');
      workbook.dispose();
    });

    test('setDateTime() for Multiple Range', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 2, 3, 4);
      range.setDateTime(DateTime(2004, 12, 24, 18, 30, 50));
      final Range range1 = sheet.getRangeByIndex(8, 10, 9, 12);
      range1.setDateTime(DateTime(1990, 3, 25, 16, 50, 40));
      final Range range2 = sheet.getRangeByName('J15:M20');
      range2.setDateTime(DateTime.now());
      final Range range3 = sheet.getRangeByName('O2:R6');
      range3.setDateTime(DateTime(2002, 5, 5, 22, 49, 20));

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDateTimeSetDateTimeForMultipleRange.xlsx');
    });

    test('dateTime() for Multiple Range', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(5, 4, 7, 8);
      range.dateTime = DateTime(2011, 1, 20, 20, 37, 80);
      final Range range1 = sheet.getRangeByIndex(10, 10, 12, 12);
      range1.dateTime = DateTime(1999, 6, 5, 6, 0, 40);
      final Range range2 = sheet.getRangeByName('K20:N30');
      range2.dateTime = DateTime.now();
      final Range range3 = sheet.getRangeByName('S12:V16');
      range3.dateTime = DateTime(2323, 10, 15, 2, 9);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDateTimedateTimeForMultipleRange.xlsx');
      workbook.dispose();
    });

    test('get() for Multiple range', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      // Multiple final Range for DateTime
      final Range range2 = sheet.getRangeByName('D2:D4');
      range2.setDateTime(DateTime(2020, 1, 1, 1));
      expect(range2.dateTime, DateTime(2020, 1, 1, 1));
      expect(sheet.getRangeByName('D2:D5').dateTime, DateTime(0001));
      sheet.getRangeByName('D5').number = sheet.getRangeByName('D4').number;
      expect(sheet.getRangeByName('D2:D5').dateTime, DateTime(0001));
      expect(sheet.getRangeByName('D1:D5').dateTime, DateTime(0001));

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetRangeForMultipleRange.xlsx');
      workbook.dispose();
    });
  });
}
