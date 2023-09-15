// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioWorksheetProtection() {
  group('Worksheet Protection', () {
    test('default option', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).text = 'Z';
      sheet.protect('Syncfusion');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionDefault.xlsx');
      workbook.dispose();
    });
    test('default option with lock cell', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1:D4');
      range.text = 'MZ';
      sheet.protect('Syncfusion');
      // Unlocking the cell to edit.
      range.cellStyle.locked = false;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionUnlockcell.xlsx');
      workbook.dispose();
    });
    test('ExcelSheetProtection Option', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1:D4');
      range.text = 'MZ';
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.content = true;
      options.insertColumns = true;
      options.objects = true;
      options.scenarios = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionOptions.xlsx');
      workbook.dispose();
    });
    test('content', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.content = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionContent.xlsx');
      workbook.dispose();
    });
    test('objects', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.objects = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionObjects.xlsx');
      workbook.dispose();
    });
    test('scenarios', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.scenarios = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionscenarios.xlsx');
      workbook.dispose();
    });
    test('formatCells', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.formatCells = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionformatCells.xlsx');
      workbook.dispose();
    });
    test('formatColumns', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.formatColumns = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionformatColumns.xlsx');
      workbook.dispose();
    });
    test('formatRows', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.formatRows = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionformatRows.xlsx');
      workbook.dispose();
    });
    test('insertColumns', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.insertColumns = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectioninsertColumns.xlsx');
      workbook.dispose();
    });
    test('insertRows', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.insertRows = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectioninsertRows.xlsx');
      workbook.dispose();
    });
    test('insertHyperlinks', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.insertHyperlinks = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectioninsertHyperlinks.xlsx');
      workbook.dispose();
    });
    test('deleteColumns', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.deleteColumns = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectiondeleteColumns.xlsx');
      workbook.dispose();
    });
    test('deleteRows', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.deleteRows = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectiondeleteRows.xlsx');
      workbook.dispose();
    });
    test('lockedCells', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.lockedCells = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionLockedCells.xlsx');
      workbook.dispose();
    });
    test('sort', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.sort = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionsort.xlsx');
      workbook.dispose();
    });
    test('useAutoFilter', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.useAutoFilter = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionuseAutoFilter.xlsx');
      workbook.dispose();
    });
    test('usePivotTableAndPivotChart', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.usePivotTableAndPivotChart = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(
          bytes, 'ExcelworksheetProtectionusePivotTableAndPivotChart.xlsx');
      workbook.dispose();
    });
    test('unlockedCells', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.unlockedCells = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionunlockedCells.xlsx');
      workbook.dispose();
    });
    test('All Options', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.content = true;
      options.objects = true;
      options.scenarios = true;
      options.formatCells = true;
      options.formatColumns = true;
      options.formatRows = true;
      options.insertColumns = true;
      options.insertRows = true;
      options.insertHyperlinks = true;
      options.deleteColumns = true;
      options.deleteRows = true;
      options.lockedCells = true;
      options.sort = true;
      options.useAutoFilter = true;
      options.usePivotTableAndPivotChart = true;
      options.unlockedCells = true;
      sheet.protect('Syncfusion', options);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionAllOption.xlsx');
      workbook.dispose();
    });
    test('All', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.setText('Worksheet Protected');

      final ExcelSheetProtectionOption options = ExcelSheetProtectionOption();
      options.all = true;

      sheet.protect('Password', options);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionAllOption1.xlsx');
      workbook.dispose();
    });
    test('Multiple sheets', () {
      final Workbook workbook = Workbook(3);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[1];
      final Worksheet sheet2 = workbook.worksheets[2];
      final ExcelSheetProtectionOption options =
          ExcelSheetProtectionOption.excelSheetProtectionOption;
      options.objects = true;
      options.scenarios = true;
      options.formatCells = true;
      options.formatRows = true;
      options.insertColumns = true;
      options.deleteRows = true;
      options.useAutoFilter = true;
      options.unlockedCells = true;
      sheet.protect('Syncfusion', options);
      sheet1.protect('AAAA');
      final ExcelSheetProtectionOption options1 = ExcelSheetProtectionOption();
      options1.deleteColumns = true;
      options1.sort = true;
      sheet2.protect('ZZZZ', options1);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelworksheetProtectionMultipleSheet.xlsx');
      workbook.dispose();
    });
  });
}
