// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioAutoFit() {
  group('AutoFit', () {
    test('Column', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.setText('Test for AutoFit Column');

      sheet.autoFitColumn(1);
      expect(sheet.getColumnWidth(1), 22.14);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitColumn.xlsx');
      workbook.dispose();
    });

    test('Column with WrapText', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.setText(
          'WrapText WrapText WrapText WrapText WrapText WrapText WrapText');
      range.columnWidth = 35;
      range.cellStyle.wrapText = true;

      sheet.autoFitColumn(1);
      expect(sheet.getColumnWidth(1), 28.0);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitColumnWrapText.xlsx');
      workbook.dispose();
    });

    test('Column with Indent', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.setText('Text');
      range.cellStyle.indent = 5;

      range = sheet.getRangeByName('B1');
      range.setText('Hello World Syncfusion');
      range.cellStyle.hAlign = HAlignType.right;

      sheet.autoFitColumn(1);
      sheet.autoFitColumn(2);
      expect(sheet.getColumnWidth(1), 10.57);
      expect(sheet.getColumnWidth(2), 21.71);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitColumnWithIndent.xlsx');
      workbook.dispose();
    });

    test('Column with Font', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.setText('Hello World Syncfusion');
      range.cellStyle.fontName = 'Arial';
      range.cellStyle.fontSize = 18;

      sheet.autoFitColumn(1);
      expect(sheet.getColumnWidth(1), 37.0);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitColumnWithFont.xlsx');
      workbook.dispose();
    });

    test('Column with Number', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.setNumber(10000000000);

      range = sheet.getRangeByName('B1');
      range.setNumber(10000000000000);

      sheet.autoFitColumn(1);
      sheet.autoFitColumn(2);
      expect(sheet.getColumnWidth(1), 13.29);
      expect(sheet.getColumnWidth(2), 16.57);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitColumnWithNumber.xlsx');
      workbook.dispose();
    });

    test('Column with Rotation', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.cellStyle.rotation = 90;
      range.setText('This is Rotation Text');

      range = sheet.getRangeByName('B1');
      range.cellStyle.rotation = 45;
      range.setText('This is a  Rotation Text');

      sheet.autoFitColumn(1);
      sheet.autoFitColumn(2);
      expect(sheet.getColumnWidth(1), 3.0);
      expect(sheet.getColumnWidth(2), 17.43);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitColumnWithRotation.xlsx');
      workbook.dispose();
    });

    test('Row', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByName('A1');
      range1.setText('WrapTextWrapTextWrapTextWrapText');
      final Style style = workbook.styles.add('Style1');
      style.wrapText = true;
      range1.cellStyle = style;

      sheet.autoFitRow(1);
      expect(sheet.getRowHeight(1), 86.25);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitRow.xlsx');
      workbook.dispose();
    });

    test('Row with Empty', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.setText(' ');

      range.columnWidth = 35;
      sheet.autoFitRow(1);
      expect(sheet.getRowHeight(1), 15);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitRowEmpty.xlsx');
      workbook.dispose();
    });

    test('Row with WrapText', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.setText(
          'WrapText WrapText WrapText WrapText WrapText WrapText WrapText');
      range.columnWidth = 35;
      range.cellStyle.wrapText = true;

      sheet.autoFitRow(1);
      expect(sheet.getRowHeight(1), 42.75);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitRowWrapText.xlsx');
      workbook.dispose();
    });

    test('Row with Indent', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.setText('Text');
      range.cellStyle.indent = 5;

      range = sheet.getRangeByName('B1');
      range.setText('Hello World Syncfusion');
      range.cellStyle.vAlign = VAlignType.top;

      sheet.autoFitRow(1);
      sheet.autoFitRow(2);
      expect(sheet.getRowHeight(1), 15);
      expect(sheet.getRowHeight(2), 15);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitRownWithIndent.xlsx');
      workbook.dispose();
    });

    test('Row with Font', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.setText('Hello World Syncfusion');
      range.cellStyle.fontName = 'Arial';
      range.cellStyle.fontSize = 20;

      sheet.autoFitRow(1);
      expect(sheet.getRowHeight(1), 25.5);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitRowWithFont.xlsx');
      workbook.dispose();
    });

    test('Row with Number', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.setNumber(10000000000);

      range = sheet.getRangeByName('A2');
      range.setNumber(10000000000000);
      range.cellStyle.wrapText = true;

      sheet.autoFitRow(1);
      sheet.autoFitRow(2);
      expect(sheet.getRowHeight(1), 15);
      expect(sheet.getRowHeight(2), 15);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitRowWithNumber.xlsx');
      workbook.dispose();
    });

    test('Row with Rotation', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.cellStyle.rotation = 90;
      range.setText('This is Rotation Text');

      range = sheet.getRangeByName('A2');
      range.cellStyle.rotation = 45;
      range.setText('This is a  Rotation Text');

      sheet.autoFitRow(1);
      sheet.autoFitRow(2);
      expect(sheet.getRowHeight(1), 98.5725);
      final int height = sheet.getRowHeight(2).ceil();
      expect(height, 90);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AutoFitRowWithRotation.xlsx');
      workbook.dispose();
    });

    test('Range AutoFitColumn', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.setText('Test for AutoFit Column');
      range = sheet.getRangeByName('A2');
      range.setText(
          'WrapText WrapText WrapText WrapText WrapText WrapText WrapText');

      sheet.getRangeByName('A1:A2').autoFitColumns();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'RangeAutoFitColumn.xlsx');
      workbook.dispose();
    });

    test('Range AutoFitRow', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.setText('Test for AutoFit Row');
      range.cellStyle.fontSize = 15;
      range = sheet.getRangeByName('A2');
      range.setText(
          'WrapText WrapText WrapText WrapText WrapText WrapText WrapText');
      range.cellStyle.wrapText = true;

      sheet.getRangeByName('A1:A2').autoFitRows();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'RangeAutoFitRow.xlsx');
      workbook.dispose();
    });

    test('Range AutoFit', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.setText('WrapText WrapText WrapText WrapText WrapText WrapText');
      range.cellStyle.wrapText = true;
      range = sheet.getRangeByName('A2');
      range.setText('Test for AutoFit Text');
      range.cellStyle.fontSize = 15;

      range = sheet.getRangeByName('B1');
      range.setText('WrapText WrapText WrapText WrapText WrapText WrapText');
      range = sheet.getRangeByName('B2');
      range.setText('Test for AutoFit Text');
      range.cellStyle.fontSize = 15;

      sheet.getRangeByName('A1:B2').autoFit();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'RangeAutoFit.xlsx');
      workbook.dispose();
    });
  });
}
