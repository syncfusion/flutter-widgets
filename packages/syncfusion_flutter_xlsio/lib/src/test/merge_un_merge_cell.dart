// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioMergeUnmergeCells() {
  group('Merge Cell', () {
    test('Columns', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByName('A1:D1');
      range1.number = 10;
      range1.merge();
      final Range range2 = sheet.getRangeByName('E6:N6');
      range2.text = 'M';
      range2.merge();
      final Range range3 = sheet.getRangeByIndex(12, 16, 12, 22);
      range3.dateTime = DateTime(2020, 12, 12);
      range3.merge();
      final Range range4 = sheet.getRangeByName('A15:I15');
      range4.number = 44;
      range4.merge();
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMergeCellColumns.xlsx');
      workbook.dispose();
    });

    test('Rows', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByIndex(1, 2, 4, 2);
      range1.number = 22;
      range1.merge();
      final Range range2 = sheet.getRangeByName('F8:F15');
      range2.text = 'Text';
      range2.merge();
      final Range range3 = sheet.getRangeByIndex(4, 10, 25, 10);
      range3.dateTime = DateTime(1997, 11, 22);
      range3.merge();
      final Range range4 = sheet.getRangeByName('P8:P40');
      range4.number = 55;
      range4.merge();
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMergeCellRows.xlsx');
      workbook.dispose();
    });

    test('ColumnsRows', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByIndex(1, 2, 5, 4);
      range1.text = 'Helloo';
      range1.merge();
      final Range range2 = sheet.getRangeByName('G5:J22');
      range2.dateTime = DateTime(2222, 10, 10);
      range2.merge();
      final Range range3 = sheet.getRangeByIndex(15, 15, 20, 35);
      range3.number = -444;
      range3.merge();
      final Range range4 = sheet.getRangeByName('A10:B20');
      range4.text = 'world';
      range4.merge();
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMergeCellColumnsRows.xlsx');
      workbook.dispose();
    });

    test('ColumnsRow Intersection', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1, 10, 10).merge();
      sheet.getRangeByName('A9:M20').merge();
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMergeCellColumnsRowsIntersection.xlsx');
      workbook.dispose();
    });

    test('Cell_Styles', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style style1 = workbook.styles.add('Style1');
      style1.fontName = 'Chiller';
      style1.fontSize = 20;
      style1.backColor = '#892011';
      style1.fontColor = '#FF0066';
      style1.hAlign = HAlignType.center;
      style1.vAlign = VAlignType.center;
      style1.borders.all.lineStyle = LineStyle.double;
      style1.borders.all.color = '#00B0F0';
      style1.italic = true;
      style1.bold = true;
      style1.underline = true;
      style1.rotation = 180;
      final Range range1 = sheet.getRangeByIndex(2, 2, 4, 4);
      range1.merge();
      range1.text = 'Hello';
      range1.cellStyle = style1;

      final Style style2 = workbook.styles.add('Style2');
      style2.fontName = 'Agency FB';
      style2.fontSize = 15;
      style2.backColor = '#A914DE';
      style2.fontColor = '#FA98C0';
      style2.numberFormat = '0.00%';
      style2.hAlign = HAlignType.left;
      style2.vAlign = VAlignType.top;
      style2.borders.top.lineStyle = LineStyle.thick;
      style2.borders.top.color = '#D1ED27';
      style2.indent = 2;
      final Range range2 = sheet.getRangeByName('H8:I12');
      range2.number = 44;
      range2.merge();
      range2.cellStyle = style2;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMergeCellCellStyle.xlsx');
      workbook.dispose();
    });

    test('Build_In_Styles', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range1 = sheet.getRangeByName('A2:B4');
      final Range range11 = sheet.getRangeByName('A2');
      range11.number = 10;
      range1.merge();
      range1.builtInStyle = BuiltInStyles.checkCell;

      final Range range2 = sheet.getRangeByName('D8:F15');
      range2.text = 'Hello';
      range2.merge();
      range2.builtInStyle = BuiltInStyles.good;

      final Range range3 = sheet.getRangeByName('J16:M22');
      range3.text = 'Universal';
      range3.merge();
      range3.builtInStyle = BuiltInStyles.total;

      final Range range4 = sheet.getRangeByName('I2:K4');
      range4.dateTime = DateTime(2022, 11, 22);
      range4.merge();
      range4.builtInStyle = BuiltInStyles.accent2_40;

      final Range range5 = sheet.getRangeByIndex(22, 1, 24, 4);
      range5.number = 4;
      range5.merge();
      range5.builtInStyle = BuiltInStyles.currency0;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMergeCellBuildInStyle.xlsx');
      workbook.dispose();
    });
  });

  group('unmerge Cell', () {
    test('Columns', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByName('A1:D1');
      range1.number = 10;
      range1.merge();
      range1.unmerge();
      final Range range2 = sheet.getRangeByName('E6:N6');
      range2.text = 'M';
      range2.merge();
      range2.unmerge();
      final Range range3 = sheet.getRangeByIndex(12, 16, 12, 22);
      range3.dateTime = DateTime(2020, 12, 12);
      range3.merge();
      range3.unmerge();
      final Range range4 = sheet.getRangeByName('A15:I15');
      range4.number = 44;
      range4.merge();
      range4.unmerge();
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelunmergeCellColumns.xlsx');
      workbook.dispose();
    });

    test('Rows', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByIndex(1, 2, 4, 2);
      range1.number = 22;
      range1.merge();
      range1.unmerge();
      final Range range2 = sheet.getRangeByName('F8:F15');
      range2.text = 'Text';
      range2.merge();
      range2.unmerge();
      final Range range3 = sheet.getRangeByIndex(4, 10, 25, 10);
      range3.dateTime = DateTime(1997, 11, 22);
      range3.merge();
      range3.unmerge();
      final Range range4 = sheet.getRangeByName('P8:P40');
      range4.number = 55;
      range4.merge();
      range4.unmerge();
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelunmergeCellRows.xlsx');
      workbook.dispose();
    });

    test('ColumnsRows', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByIndex(1, 2, 5, 4);
      range1.text = 'Helloo';
      range1.merge();
      range1.unmerge();
      final Range range2 = sheet.getRangeByName('G5:J22');
      range1.dateTime = DateTime(2222, 10, 10);
      range2.merge();
      range2.unmerge();
      final Range range3 = sheet.getRangeByIndex(15, 15, 20, 35);
      range3.number = 444;
      range3.merge();
      range3.unmerge();
      final Range range4 = sheet.getRangeByName('A10:B20');
      range4.text = 'world';
      range4.merge();
      range4.unmerge();
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelunmergeCellColumnsRows.xlsx');
      workbook.dispose();
    });

    test('Cell_Styles', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style style1 = workbook.styles.add('Style1');
      style1.fontName = 'Chiller';
      style1.fontSize = 20;
      style1.backColor = '#892011';
      style1.fontColor = '#FF0066';
      style1.hAlign = HAlignType.center;
      style1.vAlign = VAlignType.center;
      style1.borders.all.lineStyle = LineStyle.double;
      style1.borders.all.color = '#00B0F0';
      style1.italic = true;
      style1.bold = true;
      style1.underline = true;
      style1.rotation = 180;
      final Range range1 = sheet.getRangeByIndex(2, 2, 4, 4);
      range1.merge();
      range1.text = 'Hello';
      range1.cellStyle = style1;
      range1.unmerge();

      final Style style2 = workbook.styles.add('Style2');
      style2.fontName = 'Agency FB';
      style2.fontSize = 15;
      style2.backColor = '#A914DE';
      style2.fontColor = '#FA98C0';
      style2.numberFormat = '0.00%';
      style2.hAlign = HAlignType.left;
      style2.vAlign = VAlignType.top;
      style2.borders.top.lineStyle = LineStyle.thick;
      style2.borders.top.color = '#D1ED27';
      style2.indent = 2;
      final Range range2 = sheet.getRangeByName('H8:I12');
      range2.number = 44;
      range2.merge();
      range2.cellStyle = style2;
      range2.unmerge();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelunmergeCellCellStyle.xlsx');
      workbook.dispose();
    });

    test('Build_In_Styles', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range1 = sheet.getRangeByName('A2:B4');
      final Range range11 = sheet.getRangeByName('A2');
      range11.number = 10;
      range1.merge();
      range1.builtInStyle = BuiltInStyles.checkCell;
      range1.unmerge();

      final Range range2 = sheet.getRangeByName('D8:F15');
      range2.text = 'Hello';
      range2.merge();
      range2.builtInStyle = BuiltInStyles.good;
      range2.unmerge();

      final Range range3 = sheet.getRangeByName('J16:M22');
      range3.text = 'Universal';
      range3.merge();
      range3.builtInStyle = BuiltInStyles.total;
      range3.unmerge();

      final Range range4 = sheet.getRangeByName('I2:K4');
      range4.dateTime = DateTime(2022, 11, 22);
      range4.merge();
      range4.builtInStyle = BuiltInStyles.accent2_40;
      range4.unmerge();

      final Range range5 = sheet.getRangeByIndex(22, 1, 24, 4);
      range5.number = 4;
      range5.merge();
      range5.builtInStyle = BuiltInStyles.currency0;
      range5.unmerge();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelunmergeCellBuildInStyle.xlsx');
      workbook.dispose();
    });
  });
}
