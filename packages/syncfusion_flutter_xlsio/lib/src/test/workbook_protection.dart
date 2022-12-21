// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioWorkbookProtection() {
  group('Workbook Protection', () {
    test('without password', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).text = 'Workbook is protected';
      workbook.protect(true, true);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelWorkbookProtection1.xlsx');
      workbook.dispose();
    });
    test('with password', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).text = 'Workbook is protected';
      workbook.protect(true, true, 'Syncfusion');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelWorkbookProtection2.xlsx');
      workbook.dispose();
    });
    test('with isProtectWindow fasle', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).text = 'Workbook is protected';
      workbook.protect(false, true, 'Syncfusion');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelWorkbookProtection3.xlsx');
      workbook.dispose();
    });
    test('with isProtectContent fasle', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).text = 'Workbook is protected';
      workbook.protect(true, false, 'Syncfusion');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelWorkbookProtection4.xlsx');
      workbook.dispose();
    });
    test('WorsrCase1', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).text = 'Workbook is protected';
      workbook.protect(true, true, 'Syncfusion');
      try {
        workbook.protect(true, true, 'Syncfusion');
      } catch (e) {
        expect(
            'Exception: Workbook is already protected. Use Unprotect before calling method.',
            e.toString());
      }
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelWorkbookProtectionWorstCase1.xlsx');
      workbook.dispose();
    });
    test('WorsrCase2', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).text = 'Workbook is protected';
      try {} catch (e) {
        expect('Exception: One of params must be TRUE.', e.toString());
      }
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelWorkbookProtectionWorstCase2.xlsx');
      workbook.dispose();
    });
  });
}
