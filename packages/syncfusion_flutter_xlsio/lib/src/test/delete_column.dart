// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioDeleteColumn() {
  group('DeleteColumn', () {
    test('text', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.setText('Hello');
      range = sheet.getRangeByIndex(1, 4);
      range.setText('World');
      range = sheet.getRangeByName('D3');
      range.setText('Hii');
      range = sheet.getRangeByIndex(8, 2);
      range.setText('Zee');
      range = sheet.getRangeByName('G1:J2');
      range.setText('MZ');
      sheet.deleteColumn(1, 3);
      sheet.deleteColumn(2, 2);
      sheet.getRangeByName('D4:F7').text = 'Helloo';
      sheet.deleteColumn(3, 2);
      range = sheet.getRangeByName('f11:G19');
      range.setText('Ice');
      sheet.deleteColumn(5);
      range = sheet.getRangeByIndex(24, 1, 28, 20);
      range.setText('Cream');
      sheet.deleteColumn(17, 3);
      sheet.deleteColumn(10, 4);
      sheet.getRangeByIndex(22, 1).setText('Universe');
      sheet.deleteColumn(1);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteColumnText.xlsx');
      workbook.dispose();
    });
    test('Number', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.number = 2891;
      range = sheet.getRangeByIndex(2, 4, 8, 8);
      range.setNumber(44);
      range = sheet.getRangeByName('J10');
      range.number = 10;
      range = sheet.getRangeByIndex(15, 15);
      range.setNumber(2891);
      range = sheet.getRangeByName('L17:T27');
      range.number = 22;
      sheet.deleteColumn(2, 2);
      sheet.deleteColumn(3, 4);
      sheet.deleteColumn(8, 1);
      sheet.deleteColumn(11);
      range = sheet.getRangeByIndex(8, 2, 10, 14);
      range.setNumber(-134);
      range = sheet.getRangeByName('E18:I20');
      range.number = 8130;
      sheet.deleteColumn(14, 6);
      sheet.deleteColumn(4, 2);
      sheet.deleteColumn(2);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteColumnNumber.xlsx');
      workbook.dispose();
    });
    test('DateTime', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1:D8');
      range.setDateTime(DateTime(2020, 7, 7, 1));
      final Range range1 = sheet.getRangeByName('J4:M10');
      range1.setDateTime(DateTime(1997, 11, 22));
      final Range range2 = sheet.getRangeByName('E11');
      range2.setDateTime(DateTime.now());
      final Range range3 = sheet.getRangeByName('G18:Z22');
      range3.setDateTime(DateTime(1995, 5, 5));
      sheet.deleteColumn(4);
      sheet.deleteColumn(4, 5);
      sheet.deleteColumn(20);
      sheet.deleteColumn(14, 2);
      sheet.deleteColumn(22);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteColumnDateTime.xlsx');
      workbook.dispose();
    });
    test('CellStyle', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Style style = workbook.styles.add('style');
      style.backColor = '#009900';
      style.fontName = 'Ink Free';
      style.fontSize = 18;
      style.fontColor = '#4CDCC7';
      style.italic = true;
      style.wrapText = true;
      style.hAlign = HAlignType.right;
      style.vAlign = VAlignType.top;
      style.borders.top.lineStyle = LineStyle.double;
      style.borders.top.color = '#ED943B';
      style.numberFormat = '(#,##0)';

      final CellStyle style1 = CellStyle(workbook);
      style1.backColor = '#D6383D';
      style1.fontName = 'Colonna MT';
      style1.fontSize = 14;
      style1.fontColor = '#377443';
      style1.italic = true;
      style1.bold = true;
      style1.wrapText = true;
      style1.hAlign = HAlignType.left;
      style1.vAlign = VAlignType.center;
      style1.borders.top.lineStyle = LineStyle.thick;
      style1.borders.top.color = '#482911';
      style1.numberFormat = '(#,##0.0)';
      workbook.styles.addStyle(style1);

      final Range range1 = sheet.getRangeByIndex(1, 1, 4, 4);
      range1.text = 'Zee';
      range1.cellStyle = style;
      final Range range2 = sheet.getRangeByIndex(8, 4, 10, 14);
      range2.number = 4423;
      range2.cellStyle = style1;
      sheet.deleteColumn(1);
      sheet.deleteColumn(4, 4);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteColumnCellStyle.xlsx');
      workbook.dispose();
    });
    test('BuiltInStyle', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1:D1');
      range.setText('Hello');
      range.builtInStyle = BuiltInStyles.bad;

      range = sheet.getRangeByIndex(2, 2, 3, 10);
      range.setNumber(4488);
      range.builtInStyle = BuiltInStyles.heading1;

      range = sheet.getRangeByName('D6:G7');
      range.setText('World');
      range.builtInStyle = BuiltInStyles.accent4;

      range = sheet.getRangeByIndex(20, 14, 22, 20);
      range.setNumber(92);
      range.builtInStyle = BuiltInStyles.checkCell;

      range = sheet.getRangeByName('E10:H14');
      range.setText('Universe');
      range.builtInStyle = BuiltInStyles.input;

      sheet.deleteColumn(2, 2);
      sheet.deleteColumn(6, 3);
      sheet.deleteColumn(6, 4);
      sheet.deleteColumn(2);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteColumnBuiltInStyle.xlsx');
      workbook.dispose();
    });
    test('NumberFormat', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1:D1');
      range.setNumber(2783);
      range.numberFormat = '#,##0.00';
      final Range range1 = sheet.getRangeByName('B2:G2');
      range1.setNumber(22.11);
      range1.numberFormat = r'([Red]$0.00)';
      final Range range2 = sheet.getRangeByIndex(6, 3, 10, 20);
      range2.setNumber(0.09312);
      range2.numberFormat = '0.000%';
      final Range range3 = sheet.getRangeByName('E20:I25');
      range3.setDateTime(DateTime(2014, 10, 12, 20, 5, 5));
      range3.numberFormat = 'm/d';
      final Range range4 = sheet.getRangeByIndex(12, 1, 12, 40);
      range4.setNumber(9.032);
      range4.numberFormat = r'_($* "-"???_)';
      final Range range5 = sheet.getRangeByIndex(25, 25);
      range5.setNumber(11.1);
      range5.numberFormat = '0.0E+00';
      final Range range6 = sheet.getRangeByIndex(17, 10);
      range6.setNumber(21.5);
      range6.numberFormat = '# ??/16';

      sheet.deleteColumn(1);
      sheet.deleteColumn(4, 3);
      sheet.deleteColumn(6, 2);
      sheet.deleteColumn(15, 10);
      sheet.deleteColumn(1);
      sheet.deleteColumn(14, 8);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteColumnNumberFormat.xlsx');
      workbook.dispose();
    });
    test('HyperLinks', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      range.setNumber(1);
      final Hyperlink link = sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      link.screenTip = 'Click Here to know about Syncfusion';
      link.textToDisplay = 'Syncfusion';
      final Range range1 = sheet.getRangeByIndex(3, 4);
      final Hyperlink link1 = sheet.hyperlinks
          .add(range1, HyperlinkType.url, 'http://www.google.com');
      link1.screenTip = 'Search anything';
      link1.textToDisplay = 'Google';
      sheet.insertColumn(1, 2);
      sheet.deleteColumn(4, 2);
      sheet.deleteColumn(1, 2);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteColumnHyperlink.xlsx');
      workbook.dispose();
    });
    test('ColumnWidth', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1:D1');
      range.text = 'z';
      range.columnWidth = 20;
      final Range range1 = sheet.getRangeByIndex(3, 3, 4, 10);
      range1.number = 4;
      range1.columnWidth = 30;

      sheet.deleteColumn(1, 2);
      sheet.deleteColumn(4, 4);
      sheet.deleteColumn(2);
      sheet.deleteColumn(2, 2);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteColumnColumnWidth.xlsx');
      workbook.dispose();
    });
    test('All', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Style style = workbook.styles.add('style');
      style.backColor = '#009900';
      style.fontName = 'Baskerville Old Face';
      style.fontSize = 18;
      style.fontColor = '#4CDCC7';
      style.italic = true;
      style.wrapText = true;
      style.hAlign = HAlignType.right;
      style.vAlign = VAlignType.top;
      style.borders.top.lineStyle = LineStyle.double;
      style.borders.top.color = '#ED943B';
      style.numberFormat = '(#,##0)';

      final CellStyle style1 = CellStyle(workbook);
      style1.backColor = '#93A83A';
      style1.fontName = 'Copperplate Gothic Bold';
      style1.fontSize = 14;
      style1.fontColor = '#A44ABB';
      style1.italic = true;
      style1.bold = true;
      style1.wrapText = true;
      style1.hAlign = HAlignType.left;
      style1.vAlign = VAlignType.center;
      style1.borders.top.lineStyle = LineStyle.thick;
      style1.borders.top.color = '#779988';
      style1.numberFormat = '(#,##0.00)';
      workbook.styles.addStyle(style1);

      final Range range1 = sheet.getRangeByIndex(1, 1, 1, 4);
      range1.text = 'Z';
      range1.cellStyle = style;
      final Range range2 = sheet.getRangeByIndex(3, 3, 3, 8);
      range2.number = 4423;
      range2.cellStyle = style1;
      sheet.getRangeByName('A1').columnWidth = 14;

      sheet.deleteColumn(1);
      sheet.deleteColumn(4, 2);
      sheet.deleteColumn(2, 3);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteColumn.xlsx');
      workbook.dispose();
    });
  });
}
