// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioInsertColumn() {
  group('InsertColumn', () {
    test('Text', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.setText('Hello');
      final Range range1 = sheet.getRangeByName('B2');
      range1.setText('World');
      final Range range2 = sheet.getRangeByName('C3');
      range2.setText('Universe');
      final Range range3 = sheet.getRangeByName('D4:E5');
      range3.setText('Zee');
      sheet.insertColumn(1);
      final Range range4 = sheet.getRangeByName('A1');
      range4.setText('Berry');
      sheet.insertColumn(6, 2);
      sheet.insertColumn(4, 4);
      sheet.insertColumn(2, 2);
      sheet.insertColumn(1, 5);
      sheet.insertColumn(4);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelInsertColumnText.xlsx');
      workbook.dispose();
    });
    test('Number', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('B1');
      range.setNumber(44);
      final Range range1 = sheet.getRangeByName('B4');
      range1.setNumber(467);
      final Range range2 = sheet.getRangeByName('C3');
      range2.setNumber(-78);
      final Range range3 = sheet.getRangeByName('D4:E5');
      range3.setNumber(6879);
      sheet.insertColumn(2);
      final Range range4 = sheet.getRangeByName('A1');
      range4.setNumber(14691);
      sheet.insertColumn(6, 2);
      sheet.insertColumn(5, 5);
      sheet.insertColumn(2, 3);
      sheet.insertColumn(1);
      sheet.insertColumn(6, 4);
      sheet.insertColumn(8, 1);
      sheet.insertColumn(12, 4);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelInsertColumnNumber.xlsx');
      workbook.dispose();
    });
    test('DateTime', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.setDateTime(DateTime(2020, 7, 7, 1));
      final Range range1 = sheet.getRangeByName('A4:B12');
      range1.setDateTime(DateTime(1997, 11, 22));
      final Range range2 = sheet.getRangeByName('C6');
      range2.setDateTime(DateTime.now());
      final Range range3 = sheet.getRangeByName('D3');
      range3.setDateTime(DateTime(1995, 5, 5));
      final Range range4 = sheet.getRangeByName('G6:L12');
      range4.setDateTime(DateTime(2024, 7, 4));
      sheet.insertColumn(3, 2);
      sheet.insertColumn(4);
      sheet.insertColumn(8, 4);
      sheet.insertColumn(15, 6);
      sheet.insertColumn(25, 4);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelInsertColumnDateTime.xlsx');
      workbook.dispose();
    });
    test('CellStyle', () {
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

      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'Z';
      range1.cellStyle = style;
      sheet.insertColumn(1, 2);
      final Range range2 = sheet.getRangeByIndex(3, 6);
      range2.number = 4423;
      range2.cellStyle = style1;
      sheet.insertColumn(2, 4);
      sheet.insertColumn(8, 5);
      sheet.insertColumn(5);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelInsertColumnCellStyle.xlsx');
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
      range = sheet.getRangeByName('D8');
      range.setText('World');
      range.builtInStyle = BuiltInStyles.accent4;
      range = sheet.getRangeByIndex(12, 10);
      range.setNumber(92);
      range.builtInStyle = BuiltInStyles.checkCell;
      sheet.insertColumn(1, 4);
      sheet.insertColumn(8, 4);
      sheet.insertColumn(12, 2);
      sheet.insertColumn(4);
      sheet.insertColumn(7, 5);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelInsertColumnBuiltInStyle.xlsx');
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
      final Range range4 = sheet.getRangeByIndex(3, 7);
      range4.setNumber(9.032);
      range4.numberFormat = r'_($* "-"???_)';
      final Range range5 = sheet.getRangeByIndex(6, 6);
      range5.setNumber(11.1);
      range5.numberFormat = '0.0E+00';
      final Range range6 = sheet.getRangeByIndex(7, 10);
      range6.setNumber(21.5);
      range6.numberFormat = '# ??/16';
      sheet.insertColumn(2, 2);
      sheet.insertColumn(6, 3);
      sheet.insertColumn(10, 4);
      sheet.insertColumn(8);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelInsertColumnNumberFormat.xlsx');
      workbook.dispose();
    });
    test('Hyperlink', () {
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
      sheet.insertColumn(1);
      sheet.insertColumn(3, 2);
      sheet.insertColumn(2, 2);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelInsertColumnHyperlink.xlsx');
      workbook.dispose();
    });
    test('All', () {
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
      final Range range = sheet.getRangeByIndex(1, 1);
      range.setNumber(1);
      range.columnWidth = 16;
      final Hyperlink link = sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      link.screenTip = 'Click Here to know about Syncfusion';
      link.textToDisplay = 'Syncfusion';
      final Range range1 = sheet.getRangeByIndex(2, 4);
      final Hyperlink link1 = sheet.hyperlinks
          .add(range1, HyperlinkType.url, 'http://www.google.com');
      link1.screenTip = 'Search anything';
      link1.textToDisplay = 'Google';
      sheet.getRangeByName('A1').cellStyle = style;
      sheet.getRangeByName('C3').text = 'z';
      sheet.insertColumn(1);
      sheet.insertColumn(3, 4);
      sheet.insertColumn(9, 2);
      sheet.insertColumn(1);
      sheet.insertColumn(12);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelInsertColumn.xlsx');
      workbook.dispose();
    });
    group('InsertColumn Format', () {
      test('CellStyle', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        final Style style = workbook.styles.add('style');
        style.backColor = '#A21117';
        style.fontName = 'Engravers MT';
        style.fontSize = 18;
        style.fontColor = '#FF9966';
        style.italic = true;
        style.wrapText = true;
        style.bold = true;
        style.hAlign = HAlignType.center;
        style.vAlign = VAlignType.top;
        style.borders.left.lineStyle = LineStyle.double;
        style.borders.left.color = '#FF00FF';

        final Style style2 = workbook.styles.add('style2');
        style2.fontColor = '#5AB2D1';
        style2.fontName = 'Broadway';

        final Style style3 = workbook.styles.add('style3');
        style3.wrapText = true;
        style3.rotation = 180;

        final CellStyle style1 = CellStyle(workbook);
        style1.backColor = '#44F92B';
        style1.fontName = 'Viner Hand ITC';
        style1.fontSize = 20;
        style1.fontColor = '#9412E4';
        style1.hAlign = HAlignType.left;
        style1.vAlign = VAlignType.center;
        style1.borders.top.lineStyle = LineStyle.medium;
        style1.borders.top.color = '#779988';
        style1.numberFormat = '(#,##0.00)';
        workbook.styles.addStyle(style1);

        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Z';
        range1.cellStyle = style;
        sheet.insertColumn(1, 2, ExcelInsertOptions.formatAsAfter);

        final Range range2 = sheet.getRangeByName('C3');
        range2.number = 1221;
        range2.cellStyle = style1;
        sheet.insertColumn(3, 2, ExcelInsertOptions.formatAsAfter);
        sheet.insertColumn(6, 4, ExcelInsertOptions.formatAsBefore);

        final Range range3 = sheet.getRangeByIndex(4, 5, 7, 7);
        range3.text = 'MZ';
        range3.cellStyle = style2;
        sheet.insertColumn(6, 1, ExcelInsertOptions.formatAsBefore);
        sheet.insertColumn(5, 2, ExcelInsertOptions.formatAsAfter);

        Range range4 = sheet.getRangeByName('J7');
        range4.text = 'Welcome Everyone';
        range4.cellStyle = style3;
        sheet.insertColumn(10, 2, ExcelInsertOptions.formatAsAfter);
        range4 = sheet.getRangeByIndex(7, 10);
        range4.text = 'Disney World';
        sheet.insertColumn(10, 3, ExcelInsertOptions.formatAsBefore);
        sheet.insertColumn(5, 2, ExcelInsertOptions.formatAsAfter);

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelInsertColumnCellStyleFormat.xlsx');
        workbook.dispose();
      });
      test('ColumnWidth', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByName('A1');
        range.text = 'z';
        range.columnWidth = 20;
        sheet.insertColumn(2, 2, ExcelInsertOptions.formatAsBefore);
        sheet.insertColumn(1, 1, ExcelInsertOptions.formatAsAfter);
        final Range range1 = sheet.getRangeByIndex(3, 3);
        range1.number = 4;
        range1.columnWidth = 30;
        sheet.insertColumn(3, 2, ExcelInsertOptions.formatAsAfter);
        sheet.insertColumn(5, 4, ExcelInsertOptions.formatAsBefore);

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelInsertColumnColumnWidth.xlsx');
        workbook.dispose();
      });
      test('BuiltInStyle Formats', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        Range range = sheet.getRangeByName('A1');
        range.setText('Hello');
        range.builtInStyle = BuiltInStyles.bad;
        sheet.insertColumn(1, 3, ExcelInsertOptions.formatAsAfter);
        sheet.insertColumn(3, 2, ExcelInsertOptions.formatAsBefore);
        range = sheet.getRangeByIndex(3, 3);
        range.setNumber(4488);
        range.builtInStyle = BuiltInStyles.heading1;
        sheet.insertColumn(3, 2, ExcelInsertOptions.formatAsAfter);
        range = sheet.getRangeByName('D8');
        range.setText('World');
        range.builtInStyle = BuiltInStyles.accent4;
        range = sheet.getRangeByIndex(4, 12);
        range.setNumber(92);
        range.builtInStyle = BuiltInStyles.checkCell;
        sheet.insertColumn(6, 6, ExcelInsertOptions.formatAsBefore);
        sheet.insertColumn(18, 10, ExcelInsertOptions.formatAsAfter);
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelInsertColumnBuiltInStyleFormat.xlsx');
        workbook.dispose();
      });
      test('NumberFormat format', () {
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
        final Range range3 = sheet.getRangeByName('J4');
        range3.setDateTime(DateTime(2014, 10, 12, 20, 5, 5));
        range3.numberFormat = 'm/d';
        final Range range4 = sheet.getRangeByIndex(12, 10);
        range4.setNumber(9.032);
        range4.numberFormat = r'_($* "-"???_)';
        final Range range5 = sheet.getRangeByIndex(6, 6);
        range5.setNumber(11.1);
        range5.numberFormat = '0.0E+00';
        Range range6 = sheet.getRangeByIndex(7, 14);
        range6.setNumber(21.5);
        range6.numberFormat = '# ??/16';
        sheet.insertColumn(1, 1, ExcelInsertOptions.formatAsAfter);
        sheet.insertColumn(3, 3, ExcelInsertOptions.formatAsBefore);
        sheet.insertColumn(7, 4, ExcelInsertOptions.formatAsAfter);
        sheet.insertColumn(14, 2, ExcelInsertOptions.formatAsAfter);
        range6 = sheet.getRangeByName('M12');
        range6.number = 72;
        sheet.insertColumn(21, 2, ExcelInsertOptions.formatAsBefore);
        sheet.insertColumn(4, 1, ExcelInsertOptions.formatAsAfter);

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelInsertColumnNumberFormat2.xlsx');
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

        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Z';
        range1.cellStyle = style;
        final Range range2 = sheet.getRangeByIndex(3, 1);
        range2.number = 4423;
        range2.cellStyle = style1;
        sheet.getRangeByName('A1').columnWidth = 14;
        sheet.insertColumn(1);
        sheet.insertColumn(2);
        sheet.insertColumn(4, 2, ExcelInsertOptions.formatAsBefore);
        sheet.insertColumn(3, 2, ExcelInsertOptions.formatAsAfter);

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelInsertColumn2.xlsx');
        workbook.dispose();
      });
      test('ColumnWidth_3', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByIndex(1, 1, 1, 1024).columnWidth = 1.74;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelInsertColumnWidth_1.xlsx');
        workbook.dispose();
      });
      test('ColumnWidth_2', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByIndex(1, 2).columnWidth = 5;
        sheet.insertColumn(2);
        final Range range = sheet.getRangeByName('D1');
        range.text = 'z';
        range.columnWidth = 20;
        sheet.insertColumn(4, 2, ExcelInsertOptions.formatAsBefore);
        sheet.insertColumn(1, 3, ExcelInsertOptions.formatAsAfter);
        sheet.getRangeByName('B4:D6').number = 10;
        sheet.insertColumn(5, 2, ExcelInsertOptions.formatAsAfter);
        sheet.getRangeByIndex(1, 4).columnWidth = 40;
        sheet.insertColumn(3, 3, ExcelInsertOptions.formatAsBefore);
        sheet.insertColumn(4, 6);
        sheet.insertColumn(12, 4, ExcelInsertOptions.formatAsAfter);
        sheet.insertColumn(1, 3, ExcelInsertOptions.formatAsAfter);
        sheet.deleteColumn(1, 5);
        sheet.deleteColumn(4, 10);
        final Range range1 = sheet.getRangeByIndex(3, 3);
        range1.number = 4;
        range1.columnWidth = 30;
        sheet.insertColumn(3, 2, ExcelInsertOptions.formatAsAfter);
        sheet.insertColumn(5, 4, ExcelInsertOptions.formatAsBefore);
        sheet.insertColumn(4, 2);

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelInsertColumnWidth_1.xlsx');
        workbook.dispose();
      });
      test('ColumnWidth_3', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1:D1').columnWidth = 20;

        sheet.insertColumn(3, 5);

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelInsertColumnWidth_2.xlsx');
        workbook.dispose();
      });
    });
  });
}
