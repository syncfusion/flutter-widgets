import '../../xlsio.dart';
// ignore: depend_on_referenced_packages, directives_ordering
import 'package:flutter_test/flutter_test.dart';

// ignore: public_member_api_docs
void saveAsExcel(List<int>? bytes, String fileName) {
  //Comment the below line when saving Excel document in local machine
  bytes = null;
  //Uncomment the below lines when saving Excel document in local machine
  //Directory('output').create(recursive: true);
  //File('output/$fileName').writeAsBytes(bytes!);
}

// ignore: public_member_api_docs
void xlsioWorkbook() {
  group('SaveWorkbook', () {
    test('Empty', () {
      final Workbook workbook = Workbook();
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorkbookEmpty.xlsx');
      workbook.dispose();
    });
    test('Sheets', () {
      final Workbook workbook = Workbook(4);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorkbookSheets.xlsx');
      workbook.dispose();
    });
    test('Worstcases', () {
      final Workbook workbook = Workbook();
      try {
        const String fileName = '';
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, fileName);
      } catch (e) {
        expect('Exception: fileName should not be null or empty', e.toString());
      }
      workbook.dispose();
    });

    test('SaveWorkbook Culture', () {
      final Workbook workbook = Workbook.withCulture('en-IN', 'INR', 4);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSaveWorkbookCulture.xlsx');
      workbook.dispose();
    });
  });
}
