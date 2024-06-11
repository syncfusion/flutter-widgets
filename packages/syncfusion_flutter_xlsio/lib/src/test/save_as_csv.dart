// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

///save as CSV format
void xlsioSaveAsCSV() {
  group('FLUT-6810_1', () {
    test('save as CSV with text', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      //Text
      worksheet.getRangeByName('A1:D4').setText('Hello');
      worksheet.getRangeByName('F2').setText('xyz');
      worksheet.getRangeByName('A10').setText('abc');
      worksheet.getRangeByName('G3').setText('Text');
      //Save as CSV format
      final List<int> bytes = workbook.saveAsCSV(',');
      saveAsExcel(bytes, 'FLUT-6810_1.csv');
      workbook.dispose();
    });
    test('FLUT-6810_2', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      //Text with separator
      worksheet.getRangeByName('A1:B2').setText('Hello,world');
      worksheet.getRangeByName('G3').setText('x,l,s,i,o');
      worksheet.getRangeByName('A6').setText('x,y,z');
      //Save as CSV format
      final List<int> bytes = workbook.saveAsCSV(',');
      saveAsExcel(bytes, 'FLUT-6810_2.csv');
      workbook.dispose();
    });
    test('FLUT-6810_3', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];

      worksheet.getRangeByName('A1:D4').setText('Hello');
      worksheet.getRangeByName('F1').setText('Hello world');
      worksheet.getRangeByName('G5').number = 20;
      worksheet.getRangeByName('B11').setText('x;l;s;i;o');
      worksheet.getRangeByName('C21').setText('Hello');
      //Save as CSV format as with semicolon ';' separator
      final List<int> bytes = workbook.saveAsCSV(';');
      saveAsExcel(bytes, 'FLUT-6810_3.csv');
      workbook.dispose();
    });
    test('FLUT-6810_4', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];

      worksheet.getRangeByName('A1:D4').setText('Hello');
      worksheet.getRangeByName('F1').setText('Hello world');
      worksheet.getRangeByName('G5').number = 20;
      worksheet.getRangeByName('B11').setText('x\tl\ts\ti\to');
      worksheet.getRangeByName('C21').setText('He"llo');
      //Save as CSV format as with tab '\t' separator
      final List<int> bytes = workbook.saveAsCSV('\t');
      saveAsExcel(bytes, 'FLUT-6810_4.csv');
      workbook.dispose();
    });
    test('FLUT-6810_5', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];

      worksheet.getRangeByName('A1:D4').setText('Hello');
      worksheet.getRangeByName('F1').setText('Hello world');
      worksheet.getRangeByName('G5').number = 20;
      worksheet.getRangeByName('B11').setText('x l s i o');
      worksheet.getRangeByName('C21').setText('Hello');
      //Save as CSV format as with colon ':' separator
      final List<int> bytes = workbook.saveAsCSV(':');
      saveAsExcel(bytes, 'FLUT-6810_5.csv');
      workbook.dispose();
    });
    test('FLUT-6810_6', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      //Number
      worksheet.getRangeByName('A1:D4').number = 1;
      worksheet.getRangeByName('A1').numberFormat = '0.00E+00';
      worksheet.getRangeByName('G2').number = 20;
      worksheet.getRangeByName('G2').numberFormat = '0%';
      worksheet.getRangeByName('F3').number = 10.5;
      worksheet.getRangeByName('F3').numberFormat = r"'$'#,##0_)";
      worksheet.getRangeByName('A14').number = 100;
      worksheet.getRangeByName('A14').numberFormat = '0.00%';
      //Save as CSV format
      final List<int> bytes = workbook.saveAsCSV(',');
      saveAsExcel(bytes, 'FLUT-6810_6.csv');
      workbook.dispose();
    });
    test('FLUT-6810_7', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      //DateTime and format
      worksheet.getRangeByName('A1').setDateTime(DateTime(2022, 1, 1, 1));
      worksheet.getRangeByName('A1').numberFormat = r'm/d/yyyy';
      worksheet.getRangeByName('C4').dateTime = DateTime(2024, 03, 07, 2, 4, 6);
      worksheet.getRangeByName('C4').numberFormat = r'm/d/yyyy\\ h:mm';
      //Save as CSV format
      final List<int> bytes = workbook.saveAsCSV(',');
      saveAsExcel(bytes, 'FLUT-6810_7.csv');
      workbook.dispose();
    });
    test('FLUT-6810_8', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      //Formulae with enableSheetCalculations
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
      range.formula = '=B1-A1';
      range = sheet.getRangeByName('A7');
      range.formula = '=C1*B1';
      range = sheet.getRangeByName('A8');
      range.formula = 'SUM(A1,B1)';
      range = sheet.getRangeByName('A9');
      range.formula = '=AVERAGE(A1,B1)';
      range = sheet.getRangeByName('A10');
      range.formula = '=B3<A2';
      range = sheet.getRangeByName('A11');
      range.formula = '=C1>=A3';
      range = sheet.getRangeByName('B6');
      range.formula = '=C3<=A4';
      range = sheet.getRangeByName('B7');
      range.formula = '=C3=A2';
      range = sheet.getRangeByName('B8');
      range.formula = '=A2<>B2';
      range = sheet.getRangeByName('B9');
      range.formula = '=-A1';
      range = sheet.getRangeByName('B10');
      range.formula = '=B4^3';
      range = sheet.getRangeByName('B11');
      range.formula = '=(A1+B1)*(B1-A1)';
      range = sheet.getRangeByName('B12');
      range.formula = '=A1&" "&B1';
      //Save as CSV format
      final List<int> bytes = workbook.saveAsCSV(',');
      saveAsExcel(bytes, 'FLUT-6810_8.csv');
      workbook.dispose();
    });
    test('FLUT-6810_9', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      //Formulae without enableSheetCalculations
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

      Range range = sheet.getRangeByName('A6');
      range.formula = '=B1-A1';
      range = sheet.getRangeByName('A7');
      range.formula = '=C1*B1';
      range = sheet.getRangeByName('A8');
      range.formula = 'SUM(A1,B1)';
      range = sheet.getRangeByName('A9');
      range.formula = '=AVERAGE(A1,B1)';
      range = sheet.getRangeByName('A10');
      range.formula = '=B3<A2';
      range = sheet.getRangeByName('A11');
      range.formula = '=C1>=A3';
      range = sheet.getRangeByName('B6');
      range.formula = '=C3<=A4';
      range = sheet.getRangeByName('B7');
      range.formula = '=C3=A2';
      range = sheet.getRangeByName('B8');
      range.formula = '=A2<>B2';
      range = sheet.getRangeByName('B9');
      range.formula = '=-A1';
      range = sheet.getRangeByName('B10');
      range.formula = '=B4^3';
      range = sheet.getRangeByName('B11');
      range.formula = '=(A1+B1)*(B1-A1)';
      range = sheet.getRangeByName('B12');
      range.formula = '=A1&" "&B1';
      //Save as CSV format
      final List<int> bytes = workbook.saveAsCSV(',');
      saveAsExcel(bytes, 'FLUT-6810_9.csv');
      workbook.dispose();
    });
    test('FLUT-6810_10', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.enableSheetCalculations();
      //Formulae with number format
      worksheet.getRangeByName('A1:C3').number = 10;
      worksheet.getRangeByName('D3').formula = '=A2+A1';
      worksheet.getRangeByName('D3').numberFormat = '0.00%';
      //Save as CSV format
      final List<int> bytes = workbook.saveAsCSV(',');
      saveAsExcel(bytes, 'FLUT-6810_10.csv');
      workbook.dispose();
    });
  });
}
