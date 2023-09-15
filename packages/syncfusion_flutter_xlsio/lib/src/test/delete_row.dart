// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioDeleteRow() {
  group('DeleteRow', () {
    test('Text', () {
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
      range = sheet.getRangeByName('J1:K5');
      range.setText('MZ');
      sheet.deleteRow(1, 2);
      sheet.deleteRow(4, 2);
      sheet.getRangeByName('D4:F7').text = 'Helloo';
      sheet.deleteRow(2, 2);
      range = sheet.getRangeByName('f11:G19');
      range.setText('Ice');
      range = sheet.getRangeByIndex(24, 1, 28, 2);
      range.setText('Cream');
      sheet.deleteRow(6, 5);
      sheet.deleteRow(27, 3);
      sheet.getRangeByIndex(22, 1).setText('Universe');
      sheet.insertRow(1, 2);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteRowText.xlsx');
      workbook.dispose();
    });
    test('Number', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.number = 2891;
      range = sheet.getRangeByIndex(2, 4, 8, 8);
      range.setNumber(44);
      range = sheet.getRangeByName('J12');
      range.number = 10;
      range = sheet.getRangeByIndex(17, 17);
      range.setNumber(2891);
      range = sheet.getRangeByName('N17:O27');
      range.number = 22;
      sheet.deleteRow(4, 2);
      sheet.deleteRow(12, 5);
      sheet.deleteRow(16, 1);
      range = sheet.getRangeByIndex(8, 2, 10, 14);
      range.setNumber(-134);
      range = sheet.getRangeByName('E18:I20');
      range.number = 8130;
      sheet.deleteRow(7);
      sheet.deleteRow(10, 3);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteRowNumber.xlsx');
      workbook.dispose();
    });
    test('Formula', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).number = 10;
      sheet.getRangeByIndex(2, 1).number = 20;
      sheet.getRangeByName('A3').setNumber(33);
      sheet.getRangeByName('A4').setNumber(44);
      sheet.getRangeByIndex(1, 2).number = 16;
      sheet.getRangeByIndex(2, 2).number = 31;
      final Range range = sheet.getRangeByIndex(8, 1);
      range.formula = '=A1+A2';
      final Range range1 = sheet.getRangeByIndex(8, 3);
      range1.formula = '=A1-B1';
      final Range range2 = sheet.getRangeByName('A7');
      range2.setFormula('=MIN(A1:B4)');
      sheet.deleteRow(4);
      sheet.deleteRow(2);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteRowFormula.xlsx');
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
      final Range range2 = sheet.getRangeByIndex(8, 4, 10, 4);
      range2.number = 4423;
      range2.cellStyle = style1;
      sheet.deleteRow(1, 2);
      sheet.deleteRow(4, 2);
      sheet.deleteRow(3, 2);

      final List<int> bytes = workbook.saveAsStream();

      saveAsExcel(bytes, 'ExcelDeleteRowCellstyle.xlsx');
      workbook.dispose();
    });
    test('BuiltInStyle', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      Range range = sheet.getRangeByName('A1');
      range.setText('Hello');
      range.builtInStyle = BuiltInStyles.bad;

      range = sheet.getRangeByIndex(2, 2);
      range.setNumber(4488);
      range.builtInStyle = BuiltInStyles.heading1;

      range = sheet.getRangeByName('A4');
      range.setText('World');
      range.builtInStyle = BuiltInStyles.accent4;

      range = sheet.getRangeByIndex(5, 4);
      range.setNumber(92);
      range.builtInStyle = BuiltInStyles.checkCell;

      range = sheet.getRangeByName('E10');
      range.setText('Universe');
      range.builtInStyle = BuiltInStyles.input;

      range = sheet.getRangeByIndex(8, 2);
      range.setNumber(7453);
      range.builtInStyle = BuiltInStyles.warningText;

      sheet.deleteRow(3);
      sheet.deleteRow(5, 2);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteRowBuiltInStyle.xlsx');
      workbook.dispose();
    });
    test('NumberFormat', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.setNumber(2783);
      range.numberFormat = '#,##0.00';
      final Range range1 = sheet.getRangeByName('B2');
      range1.setNumber(22.11);
      range1.numberFormat = r'([Red]$0.00)';
      final Range range2 = sheet.getRangeByIndex(3, 3);
      range2.setNumber(0.09312);
      range2.numberFormat = '0.000%';
      final Range range3 = sheet.getRangeByName('A4');
      range3.setDateTime(DateTime(2014, 10, 12, 20, 5, 5));
      range3.numberFormat = 'm/d';
      final Range range4 = sheet.getRangeByIndex(3, 1);
      range4.setNumber(9.032);
      range4.numberFormat = r'_($* "-"???_)';
      final Range range5 = sheet.getRangeByIndex(6, 1);
      range5.setNumber(11.1);
      range5.numberFormat = '0.0E+00';
      final Range range6 = sheet.getRangeByIndex(7, 1);
      range6.setNumber(21.5);
      range6.numberFormat = '# ??/16';
      final Range range7 = sheet.getRangeByName('I9');
      range7.setNumber(403);
      range7.numberFormat = '@';
      sheet.deleteRow(2);
      final Range range8 = sheet.getRangeByIndex(10, 4);
      range8.number = 3437;
      range8.numberFormat = '(#,##0)';
      sheet.deleteRow(1, 2);
      sheet.deleteRow(6, 3);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteRowNumberFormat.xlsx');
      workbook.dispose();
    });
    test('Hyperlink', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      final Hyperlink link = sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      link.screenTip = 'Click Here to know about Syncfusion';
      link.textToDisplay = 'Syncfusion';
      final Range range1 = sheet.getRangeByIndex(2, 4);
      sheet.hyperlinks.add(range1, HyperlinkType.url, 'http://www.google.com',
          'Search anything', 'Google');
      final Range range2 = sheet.getRangeByIndex(4, 7);
      sheet.hyperlinks.add(range2, HyperlinkType.workbook, 'Sheet1!A15');
      sheet.hyperlinks.add(
          sheet.getRangeByName('F7'), HyperlinkType.url, 'http://www.fb.com');

      sheet.deleteRow(1);
      sheet.deleteRow(4, 2);
      sheet.deleteRow(2);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDeleteRowHyperlink.xlsx');
      workbook.dispose();
    });
  });
}
