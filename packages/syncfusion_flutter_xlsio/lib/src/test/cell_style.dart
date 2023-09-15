// ignore_for_file: avoid_print
import 'dart:ui';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioCellStyle() {
  group('CellStyle', () {
    test('BackColor', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.backColor = '#B129B2';
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.cellStyle = cellStyle1;
      final Range range2 = sheet.getRangeByName('D1');
      range2.cellStyle = cellStyle1;

      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style2';
      cellStyle2.backColor = '#F82C29';
      workbook.styles.addStyle(cellStyle2);
      final Range range3 = sheet.getRangeByIndex(3, 1);
      range3.cellStyle = cellStyle2;
      final Range range4 = sheet.getRangeByName('D3');
      range4.cellStyle = cellStyle2;

      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style3';
      cellStyle3.backColor = '#3D13D9';
      workbook.styles.addStyle(cellStyle3);
      final Range range5 = sheet.getRangeByIndex(5, 1);
      range5.cellStyle = cellStyle3;
      final Range range6 = sheet.getRangeByName('D5');
      range6.cellStyle = cellStyle3;

      final CellStyle cellStyle4 = CellStyle(workbook);
      cellStyle4.name = 'Style4';
      cellStyle4.backColor = '#25C763';
      workbook.styles.addStyle(cellStyle4);
      final Range range7 = sheet.getRangeByIndex(7, 1);
      range7.cellStyle = cellStyle4;
      final Range range8 = sheet.getRangeByName('D7');
      range8.cellStyle = cellStyle4;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleBackColor.xlsx');
      workbook.dispose();
    });

    test('Font Properties', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.fontName = 'Comic Sans MS';
      cellStyle1.fontColor = '#839202';
      cellStyle1.fontSize = 11;
      cellStyle1.bold = true;
      cellStyle1.italic = true;
      cellStyle1.underline = true;
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'Hello';
      range1.cellStyle = cellStyle1;
      final Range range2 = sheet.getRangeByName('A2');
      range2.number = 1000;
      range2.cellStyle = cellStyle1;

      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style2';
      cellStyle2.fontName = 'French Script MT';
      cellStyle2.fontColor = '#0219A2';
      cellStyle2.fontSize = 22;
      cellStyle2.bold = false;
      cellStyle2.italic = true;
      cellStyle2.underline = false;
      workbook.styles.addStyle(cellStyle2);
      final Range range3 = sheet.getRangeByIndex(1, 2);
      range3.text = 'Hello';
      range3.cellStyle = cellStyle2;
      final Range range4 = sheet.getRangeByName('B2');
      range4.number = 1000;
      range4.cellStyle = cellStyle2;

      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style3';
      cellStyle3.fontName = 'Broadway';
      cellStyle3.fontColor = '#2881D2';
      cellStyle3.fontSize = 10;
      cellStyle3.bold = false;
      cellStyle3.italic = false;
      cellStyle3.underline = true;
      workbook.styles.addStyle(cellStyle3);
      final Range range5 = sheet.getRangeByIndex(1, 3);
      range5.text = 'Hello';
      range5.cellStyle = cellStyle3;
      final Range range6 = sheet.getRangeByName('C2');
      range6.number = 1000;
      range6.cellStyle = cellStyle3;

      final CellStyle cellStyle4 = CellStyle(workbook);
      cellStyle4.name = 'Style4';
      cellStyle4.fontName = 'Snap ITC';
      cellStyle4.fontColor = '#7311DA';
      cellStyle4.fontSize = 9;
      cellStyle4.bold = true;
      cellStyle4.italic = false;
      cellStyle4.underline = true;
      workbook.styles.addStyle(cellStyle4);
      final Range range7 = sheet.getRangeByIndex(1, 4);
      range7.text = 'Hello';
      range7.cellStyle = cellStyle4;
      final Range range8 = sheet.getRangeByName('D2');
      range8.number = 1000;
      range8.cellStyle = cellStyle4;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleFontProperities.xlsx');
      workbook.dispose();
    });

    test('Rotation', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.rotation = 10;
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'Hi';
      range1.cellStyle = cellStyle1;
      final Range range11 = sheet.getRangeByName('D1');
      range11.number = 10;
      range11.cellStyle = cellStyle1;

      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style2';
      cellStyle2.rotation = 60;
      workbook.styles.addStyle(cellStyle2);
      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.text = 'Hi';
      range2.cellStyle = cellStyle2;
      final Range range21 = sheet.getRangeByName('D3');
      range21.number = 10;
      range21.cellStyle = cellStyle2;

      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style3';
      cellStyle3.rotation = 90;
      workbook.styles.addStyle(cellStyle3);
      final Range range3 = sheet.getRangeByIndex(5, 1);
      range3.text = 'Hi';
      range3.cellStyle = cellStyle3;
      final Range range31 = sheet.getRangeByName('D5');
      range31.number = 10;
      range31.cellStyle = cellStyle3;

      final CellStyle cellStyle4 = CellStyle(workbook);
      cellStyle4.name = 'Style4';
      cellStyle4.rotation = 180;
      workbook.styles.addStyle(cellStyle4);
      final Range range4 = sheet.getRangeByIndex(7, 1);
      range4.text = 'Hi';
      range4.cellStyle = cellStyle4;
      final Range range41 = sheet.getRangeByName('D7');
      range41.number = 10;
      range41.cellStyle = cellStyle4;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleRotation.xlsx');
    });

    test('Horizontal Alignment', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.hAlign = HAlignType.center;
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'Hi';
      range1.cellStyle = cellStyle1;
      final Range range11 = sheet.getRangeByName('D1');
      range11.number = 10;
      range11.cellStyle = cellStyle1;

      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style2';
      cellStyle2.hAlign = HAlignType.justify;
      workbook.styles.addStyle(cellStyle2);
      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.text = 'Hi';
      range2.cellStyle = cellStyle2;
      final Range range21 = sheet.getRangeByName('D3');
      range21.number = 10;
      range21.cellStyle = cellStyle2;

      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style3';
      cellStyle3.hAlign = HAlignType.left;
      workbook.styles.addStyle(cellStyle3);
      final Range range3 = sheet.getRangeByIndex(5, 1);
      range3.text = 'Hi';
      range3.cellStyle = cellStyle3;
      final Range range31 = sheet.getRangeByName('D5');
      range31.number = 10;
      range31.cellStyle = cellStyle3;

      final CellStyle cellStyle4 = CellStyle(workbook);
      cellStyle4.name = 'Style4';
      cellStyle4.hAlign = HAlignType.right;
      workbook.styles.addStyle(cellStyle4);
      final Range range4 = sheet.getRangeByIndex(7, 1);
      range4.text = 'Hi';
      range4.cellStyle = cellStyle4;
      final Range range41 = sheet.getRangeByName('D7');
      range41.number = 10;
      range41.cellStyle = cellStyle4;

      final CellStyle cellStyle5 = CellStyle(workbook);
      cellStyle5.name = 'Style5';
      cellStyle5.hAlign = HAlignType.general;
      workbook.styles.addStyle(cellStyle5);
      final Range range5 = sheet.getRangeByIndex(9, 1);
      range5.text = 'Hi';
      range5.cellStyle = cellStyle5;
      final Range range51 = sheet.getRangeByName('D9');
      range51.number = 10;
      range51.cellStyle = cellStyle5;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleHorizontalAlignment.xlsx');
      workbook.dispose();
    });

    test('Vertical Alignment', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.vAlign = VAlignType.bottom;
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'Hi';
      range1.cellStyle = cellStyle1;
      final Range range11 = sheet.getRangeByName('D1');
      range11.number = 10;
      range11.cellStyle = cellStyle1;

      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style2';
      cellStyle2.vAlign = VAlignType.center;
      workbook.styles.addStyle(cellStyle2);
      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.text = 'Hi';
      range2.cellStyle = cellStyle2;
      final Range range21 = sheet.getRangeByName('D3');
      range21.number = 10;
      range21.cellStyle = cellStyle2;

      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style3';
      cellStyle3.vAlign = VAlignType.top;
      workbook.styles.addStyle(cellStyle3);
      final Range range3 = sheet.getRangeByIndex(5, 1);
      range3.text = 'Hi';
      range3.cellStyle = cellStyle3;
      final Range range31 = sheet.getRangeByName('D5');
      range31.number = 10;
      range31.cellStyle = cellStyle3;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleVerticalAlignment.xlsx');
      workbook.dispose();
    });

    test('Indent', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.indent = 2;
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'Hi';
      range1.cellStyle = cellStyle1;
      final Range range11 = sheet.getRangeByName('D1');
      range11.number = 10;
      range11.cellStyle = cellStyle1;

      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style2';
      cellStyle2.indent = 3;
      workbook.styles.addStyle(cellStyle2);
      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.text = 'Hi';
      range2.cellStyle = cellStyle2;
      final Range range21 = sheet.getRangeByName('D3');
      range21.number = 10;
      range21.cellStyle = cellStyle2;

      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style3';
      cellStyle3.indent = 4;
      workbook.styles.addStyle(cellStyle3);
      final Range range3 = sheet.getRangeByIndex(5, 1);
      range3.text = 'Hi';
      range3.cellStyle = cellStyle3;
      final Range range31 = sheet.getRangeByName('D5');
      range31.number = 10;
      range31.cellStyle = cellStyle3;

      final CellStyle cellStyle4 = CellStyle(workbook);
      cellStyle4.name = 'Style4';
      cellStyle4.indent = 1;
      workbook.styles.addStyle(cellStyle4);
      final Range range4 = sheet.getRangeByIndex(7, 1);
      range4.text = 'Hi';
      range4.cellStyle = cellStyle4;
      final Range range41 = sheet.getRangeByName('D7');
      range41.number = 10;
      range41.cellStyle = cellStyle4;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleIndent.xlsx');
      workbook.dispose();
    });

    test('Borders', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.borders.all.lineStyle = LineStyle.double;
      cellStyle1.borders.all.color = '#111111';
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 2);
      range1.cellStyle = cellStyle1;

      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style2';
      cellStyle2.borders.all.lineStyle = LineStyle.thick;
      cellStyle2.borders.all.color = '#111111';
      workbook.styles.addStyle(cellStyle2);
      final Range range2 = sheet.getRangeByIndex(3, 2);
      range2.cellStyle = cellStyle2;

      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style3';
      cellStyle3.borders.all.lineStyle = LineStyle.medium;
      cellStyle3.borders.all.color = '#111111';
      workbook.styles.addStyle(cellStyle3);
      final Range range3 = sheet.getRangeByIndex(5, 2);
      range3.cellStyle = cellStyle3;

      final CellStyle cellStyle4 = CellStyle(workbook);
      cellStyle4.name = 'Style4';
      cellStyle4.borders.all.lineStyle = LineStyle.thin;
      cellStyle4.borders.all.color = '#111111';
      workbook.styles.addStyle(cellStyle4);
      final Range range4 = sheet.getRangeByIndex(7, 2);
      range4.cellStyle = cellStyle4;

      final CellStyle cellStyle5 = CellStyle(workbook);
      cellStyle5.name = 'Style5';
      cellStyle5.borders.top.lineStyle = LineStyle.double;
      cellStyle5.borders.top.color = '#111111';
      workbook.styles.addStyle(cellStyle5);
      final Range range5 = sheet.getRangeByIndex(9, 2);
      range5.cellStyle = cellStyle5;

      final CellStyle cellStyle6 = CellStyle(workbook);
      cellStyle6.name = 'Style6';
      cellStyle6.borders.bottom.lineStyle = LineStyle.double;
      cellStyle6.borders.bottom.color = '#111111';
      workbook.styles.addStyle(cellStyle6);
      final Range range6 = sheet.getRangeByIndex(11, 2);
      range6.cellStyle = cellStyle6;

      final CellStyle cellStyle7 = CellStyle(workbook);
      cellStyle7.name = 'Style7';
      cellStyle7.borders.left.lineStyle = LineStyle.double;
      cellStyle7.borders.left.color = '#111111';
      workbook.styles.addStyle(cellStyle7);
      final Range range7 = sheet.getRangeByIndex(13, 2);
      range7.cellStyle = cellStyle7;

      final CellStyle cellStyle8 = CellStyle(workbook);
      cellStyle8.name = 'Style8';
      cellStyle8.borders.right.lineStyle = LineStyle.double;
      cellStyle8.borders.right.color = '#111111';
      workbook.styles.addStyle(cellStyle8);
      final Range range8 = sheet.getRangeByIndex(15, 2);
      range8.cellStyle = cellStyle8;

      final CellStyle cellStyle9 = CellStyle(workbook);
      cellStyle9.name = 'Style9';
      cellStyle9.borders.top.lineStyle = LineStyle.thick;
      cellStyle9.borders.top.color = '#111111';
      workbook.styles.addStyle(cellStyle9);
      final Range range9 = sheet.getRangeByIndex(9, 4);
      range9.cellStyle = cellStyle9;

      final CellStyle cellStyle10 = CellStyle(workbook);
      cellStyle10.name = 'Style10';
      cellStyle10.borders.top.lineStyle = LineStyle.thin;
      cellStyle10.borders.top.color = '#111111';
      workbook.styles.addStyle(cellStyle10);
      final Range range10 = sheet.getRangeByIndex(9, 6);
      range10.cellStyle = cellStyle10;

      final CellStyle cellStyle11 = CellStyle(workbook);
      cellStyle11.name = 'Style11';
      cellStyle11.borders.top.lineStyle = LineStyle.medium;
      cellStyle11.borders.top.color = '#111111';
      workbook.styles.addStyle(cellStyle11);
      final Range range11 = sheet.getRangeByIndex(9, 8);
      range11.cellStyle = cellStyle11;

      final CellStyle cellStyle12 = CellStyle(workbook);
      cellStyle12.name = 'Style12';
      cellStyle12.borders.bottom.lineStyle = LineStyle.thick;
      cellStyle12.borders.bottom.color = '#111111';
      workbook.styles.addStyle(cellStyle12);
      final Range range12 = sheet.getRangeByIndex(11, 4);
      range12.cellStyle = cellStyle12;

      final CellStyle cellStyle13 = CellStyle(workbook);
      cellStyle13.name = 'Style13';
      cellStyle13.borders.bottom.lineStyle = LineStyle.thin;
      cellStyle13.borders.bottom.color = '#111111';
      workbook.styles.addStyle(cellStyle13);
      final Range range13 = sheet.getRangeByIndex(11, 6);
      range13.cellStyle = cellStyle13;

      final CellStyle cellStyle14 = CellStyle(workbook);
      cellStyle14.name = 'Style14';
      cellStyle14.borders.bottom.lineStyle = LineStyle.medium;
      cellStyle14.borders.bottom.color = '#111111';
      workbook.styles.addStyle(cellStyle14);
      final Range range14 = sheet.getRangeByIndex(11, 8);
      range14.cellStyle = cellStyle14;

      final CellStyle cellStyle15 = CellStyle(workbook);
      cellStyle15.name = 'Style15';
      cellStyle15.borders.left.lineStyle = LineStyle.thick;
      cellStyle15.borders.left.color = '#111111';
      workbook.styles.addStyle(cellStyle15);
      final Range range15 = sheet.getRangeByIndex(13, 4);
      range15.cellStyle = cellStyle15;

      final CellStyle cellStyle16 = CellStyle(workbook);
      cellStyle16.name = 'Style16';
      cellStyle16.borders.left.lineStyle = LineStyle.thin;
      cellStyle16.borders.left.color = '#111111';
      workbook.styles.addStyle(cellStyle16);
      final Range range16 = sheet.getRangeByIndex(13, 6);
      range16.cellStyle = cellStyle16;

      final CellStyle cellStyle17 = CellStyle(workbook);
      cellStyle17.name = 'Style17';
      cellStyle17.borders.left.lineStyle = LineStyle.medium;
      cellStyle17.borders.left.color = '#111111';
      workbook.styles.addStyle(cellStyle17);
      final Range range17 = sheet.getRangeByIndex(13, 8);
      range17.cellStyle = cellStyle17;

      final CellStyle cellStyle18 = CellStyle(workbook);
      cellStyle18.name = 'Style18';
      cellStyle18.borders.right.lineStyle = LineStyle.thick;
      cellStyle18.borders.right.color = '#111111';
      workbook.styles.addStyle(cellStyle18);
      final Range range18 = sheet.getRangeByIndex(15, 4);
      range18.cellStyle = cellStyle18;

      final CellStyle cellStyle19 = CellStyle(workbook);
      cellStyle19.name = 'Style19';
      cellStyle19.borders.right.lineStyle = LineStyle.thin;
      cellStyle19.borders.right.color = '#111111';
      workbook.styles.addStyle(cellStyle19);
      final Range range19 = sheet.getRangeByIndex(15, 6);
      range19.cellStyle = cellStyle19;

      final CellStyle cellStyle20 = CellStyle(workbook);
      cellStyle20.name = 'Style20';
      cellStyle20.borders.right.lineStyle = LineStyle.medium;
      cellStyle20.borders.right.color = '#111111';
      workbook.styles.addStyle(cellStyle20);
      final Range range20 = sheet.getRangeByIndex(15, 8);
      range20.cellStyle = cellStyle20;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleBorder.xlsx');
      workbook.dispose();
    });

    test('NumberFormat', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.numberFormat = '#,##0.00';
      workbook.styles.addStyle(cellStyle1);
      final Range range11 = sheet.getRangeByName('A1');
      range11.number = 10;
      range11.cellStyle = cellStyle1;

      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style2';
      cellStyle2.numberFormat = r"'$'#,##0.00_)";
      workbook.styles.addStyle(cellStyle2);
      final Range range21 = sheet.getRangeByName('A3');
      range21.number = 10;
      range21.cellStyle = cellStyle2;

      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style3';
      cellStyle3.numberFormat = '[Red](#,##0)';
      workbook.styles.addStyle(cellStyle3);
      final Range range31 = sheet.getRangeByName('A5');
      range31.number = 10;
      range31.cellStyle = cellStyle3;

      final CellStyle cellStyle4 = CellStyle(workbook);
      cellStyle4.name = 'Style4';
      cellStyle4.wrapText = true;
      cellStyle4.numberFormat = 'm/d/yyyy';
      workbook.styles.addStyle(cellStyle4);
      final Range range41 = sheet.getRangeByName('A7');
      range41.number = 10;
      range41.cellStyle = cellStyle4;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleNumberFormat.xlsx');
      workbook.dispose();
    });

    test('WrapText', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.wrapText = true;
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByName('A1');
      range1.text = 'Hi, This is MJ';
      range1.cellStyle = cellStyle1;

      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style2';
      cellStyle2.wrapText = true;
      workbook.styles.addStyle(cellStyle2);
      final Range range2 = sheet.getRangeByName('A3');
      range2.number = 1000000;
      range2.cellStyle = cellStyle2;

      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style3';
      cellStyle3.wrapText = true;
      workbook.styles.addStyle(cellStyle3);
      final Range range31 = sheet.getRangeByName('D4');
      range31.text = 'Nature is a gift of God';
      range31.cellStyle = cellStyle3;

      final CellStyle cellStyle4 = CellStyle(workbook);
      cellStyle4.name = 'Style4';
      cellStyle4.wrapText = true;
      workbook.styles.addStyle(cellStyle4);
      final Range range41 = sheet.getRangeByName('J4');
      range41.text = 'Be a good human';
      range41.cellStyle = cellStyle4;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleWrapText.xlsx');
      workbook.dispose();
    });
    test('all properties ', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.backColor = '#FF5050';
      cellStyle1.fontName = 'Aldhabi';
      cellStyle1.fontColor = '#138939';
      cellStyle1.fontSize = 16;
      cellStyle1.bold = true;
      cellStyle1.italic = true;
      cellStyle1.underline = true;
      cellStyle1.rotation = 120;
      cellStyle1.hAlign = HAlignType.center;
      cellStyle1.vAlign = VAlignType.bottom;
      cellStyle1.indent = 1;
      cellStyle1.borders.all.lineStyle = LineStyle.double;
      cellStyle1.borders.all.color = '#FFFF66';
      cellStyle1.numberFormat = '#,##0.00';
      cellStyle1.wrapText = true;
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'Hello';
      range1.cellStyle = cellStyle1;
      final Range range11 = sheet.getRangeByName('D1');
      range11.number = 10;
      range11.cellStyle = cellStyle1;
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleAllProperties.xlsx');
      workbook.dispose();
    });

    // test('WrostCase', () {
    //   final Workbook workbook = Workbook();
    //   final CellStyle cellStyle1 = CellStyle(workbook);
    //   cellStyle1.name = 'Style1';
    //   try {
    //     workbook.styles.addStyle(null);
    //   } catch (e) {
    //     expect('Exception: style should not be null', e.toString());
    //   }
    //   final List<int> bytes = workbook.saveAsStream();
    //   saveAsExcel(bytes, 'ExcelCellStyleException.xlsx');
    //   workbook.dispose();
    // });

    test('CellStyle', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1:A4').cellStyle.backColor = '#859430';
      final Range range = sheet.getRangeByName('C1:C4');
      range.text = 'M';
      range.cellStyle.fontColor = '#628782';
      final Range range1 = sheet.getRangeByName('E1:E4');
      range1.text = 'M';
      range1.cellStyle.fontSize = 20;
      final Range range2 = sheet.getRangeByName('G1:G4');
      range2.text = 'M';
      range2.cellStyle.fontName = 'Chiller';
      final Range range3 = sheet.getRangeByName('I1:I4');
      range3.text = 'M';
      range3.cellStyle.bold = true;
      range3.cellStyle.italic = true;
      final Range range4 = sheet.getRangeByName('K1:K4');
      range4.text = 'M';
      range4.cellStyle.hAlign = HAlignType.center;
      range4.cellStyle.vAlign = VAlignType.center;
      final Range range5 = sheet.getRangeByName('M1:M4');
      range5.text = 'Welcome Everyone';
      range5.cellStyle.wrapText = true;
      final Range range6 = sheet.getRangeByName('O1:O4');
      range6.text = 'M';
      range6.cellStyle.underline = true;
      final Range range7 = sheet.getRangeByName('A8:A12');
      range7.text = 'M';
      range7.cellStyle.rotation = 60;
      final Range range8 = sheet.getRangeByName('B8:B12');
      range8.text = 'M';
      range8.cellStyle.indent = 2;
      sheet.getRangeByName('C8:C12').cellStyle.borders.all.lineStyle =
          LineStyle.medium;
      sheet.getRangeByName('C8:C12').cellStyle.borders.all.color = '#290D34';
      sheet.getRangeByName('E8:E12').cellStyle.borders.top.lineStyle =
          LineStyle.thick;
      sheet.getRangeByName('E8:E12').cellStyle.borders.top.color = '#AAACCC';
      sheet.getRangeByName('G8:G12').cellStyle.borders.bottom.lineStyle =
          LineStyle.thin;
      sheet.getRangeByName('G8:G12').cellStyle.borders.bottom.color = '#3423AA';
      sheet.getRangeByName('I8:I12').cellStyle.borders.left.lineStyle =
          LineStyle.double;
      sheet.getRangeByName('I8:I12').cellStyle.borders.left.color = '#EEFFAA';
      sheet.getRangeByName('K8:K12').cellStyle.borders.right.lineStyle =
          LineStyle.medium;
      sheet.getRangeByName('K8:K12').cellStyle.borders.right.color = '#388421';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelcellStyle.xlsx');
      workbook.dispose();
    });

    test('CurrencyNumberFormat', () {
      final Workbook workbook = Workbook.withCulture('id-ID', 'IDR');
      final Worksheet sheet = workbook.worksheets[0]..name = 'Sheet1';

      sheet.getRangeByName('A1')
        ..setText('Prices')
        ..builtInStyle = BuiltInStyles.heading1;
      sheet.getRangeByName('A2')
        ..builtInStyle = BuiltInStyles.currency
        ..setNumber(123456789);
      sheet.getRangeByName('A3')
        ..builtInStyle = BuiltInStyles.currency
        ..setNumber(200000);

      sheet.getRangeByName('A1:A3').autoFit();

      final Range range1 = sheet.getRangeByName('A2');
      expect(r'[$IDR]  123.456.789,00', range1.displayText);
      final Range range2 = sheet.getRangeByName('A3');
      expect(r'[$IDR]  200.000,00', range2.displayText);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleCurrencyNumberFormat.xlsx');
      workbook.dispose();
    });
  });

  group('GlobalStyles', () {
    test('backColor', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style style1 = workbook.styles.add('style1');
      style1.backColor = '#7030A0';
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'Hai';
      range1.cellStyle = style1;
      final Range range11 = sheet.getRangeByName('D1');
      range11.number = 10;
      range11.cellStyle = style1;

      final Style style2 = workbook.styles.add('style2');
      style2.backColor = '#3333FF';
      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.text = 'Hai';
      range2.cellStyle = style2;
      final Range range12 = sheet.getRangeByName('D3');
      range12.number = 10;
      range12.cellStyle = style2;

      final Style style3 = workbook.styles.add('style3');
      style3.backColor = '#CCFF66';
      final Range range3 = sheet.getRangeByIndex(5, 1);
      range3.text = 'Hai';
      range3.cellStyle = style3;
      final Range range13 = sheet.getRangeByName('D5');
      range13.number = 10;
      range13.cellStyle = style3;

      final Style style4 = workbook.styles.add('style4');
      style4.backColor = '#19FFFF';
      final Range range4 = sheet.getRangeByIndex(7, 1);
      range4.text = 'Hai';
      range4.cellStyle = style4;
      final Range range14 = sheet.getRangeByName('D7');
      range14.number = 10;
      range14.cellStyle = style4;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGlobalStyleBackColor.xlsx');
      workbook.dispose();
    });
    group('Font Properties', () {
      test('FontName', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.fontName = 'Castellar';
        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Hai';
        range1.cellStyle = style1;
        final Range range11 = sheet.getRangeByName('D1');
        range11.number = 10;
        range11.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.fontName = 'Elephant';
        final Range range2 = sheet.getRangeByIndex(3, 1);
        range2.text = 'Hai';
        range2.cellStyle = style2;
        final Range range12 = sheet.getRangeByName('D3');
        range12.number = 10;
        range12.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.fontName = 'Chiller';
        final Range range3 = sheet.getRangeByIndex(5, 1);
        range3.text = 'Hai';
        range3.cellStyle = style3;
        final Range range13 = sheet.getRangeByName('D5');
        range13.number = 10;
        range13.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.fontName = 'Jokerman';
        final Range range4 = sheet.getRangeByIndex(7, 1);
        range4.text = 'Hai';
        range4.cellStyle = style4;
        final Range range14 = sheet.getRangeByName('D7');
        range14.number = 10;
        range14.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleFontName.xlsx');
        workbook.dispose();
      });

      test('FontColor', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.fontName = 'Castellar';
        style1.fontColor = '#99FF66';
        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Hai';
        range1.cellStyle = style1;
        final Range range11 = sheet.getRangeByName('D1');
        range11.number = 10;
        range11.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.fontName = 'Elephant';
        style2.fontColor = '#EF25EF';
        final Range range2 = sheet.getRangeByIndex(3, 1);
        range2.text = 'Hai';
        range2.cellStyle = style2;
        final Range range12 = sheet.getRangeByName('D3');
        range12.number = 10;
        range12.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.fontName = 'Chiller';
        style3.fontColor = '#FF0000';
        final Range range3 = sheet.getRangeByIndex(5, 1);
        range3.text = 'Hai';
        range3.cellStyle = style3;
        final Range range13 = sheet.getRangeByName('D5');
        range13.number = 10;
        range13.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.fontName = 'Jokerman';
        style4.fontColor = '#E8ED13';
        final Range range4 = sheet.getRangeByIndex(7, 1);
        range4.text = 'Hai';
        range4.cellStyle = style4;
        final Range range14 = sheet.getRangeByName('D7');
        range14.number = 10;
        range14.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleFontColor.xlsx');
        workbook.dispose();
      });
      test('FontSize', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.fontName = 'Castellar';
        style1.fontColor = '#99FF66';
        style1.fontSize = 14;
        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Hai';
        range1.cellStyle = style1;
        final Range range11 = sheet.getRangeByName('D1');
        range11.number = 10;
        range11.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.fontName = 'Elephant';
        style2.fontColor = '#EF25EF';
        style2.fontSize = 10;
        final Range range2 = sheet.getRangeByIndex(3, 1);
        range2.text = 'Hai';
        range2.cellStyle = style2;
        final Range range12 = sheet.getRangeByName('D3');
        range12.number = 10;
        range12.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.fontName = 'Chiller';
        style3.fontColor = '#FF0000';
        style3.fontSize = 20;
        final Range range3 = sheet.getRangeByIndex(5, 1);
        range3.text = 'Hai';
        range3.cellStyle = style3;
        final Range range13 = sheet.getRangeByName('D5');
        range13.number = 10;
        range13.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.fontName = 'Jokerman';
        style4.fontColor = '#E8ED13';
        style4.fontSize = 18;
        final Range range4 = sheet.getRangeByIndex(7, 1);
        range4.text = 'Hai';
        range4.cellStyle = style4;
        final Range range14 = sheet.getRangeByName('D7');
        range14.number = 10;
        range14.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleFontSize.xlsx');
        workbook.dispose();
      });

      test('FontStyle ', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.fontName = 'Castellar';
        style1.fontColor = '#99FF66';
        style1.fontSize = 14;
        style1.bold = true;
        style1.italic = true;
        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Hai';
        range1.cellStyle = style1;
        final Range range11 = sheet.getRangeByName('D1');
        range11.number = 10;
        range11.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.fontName = 'Elephant';
        style2.fontColor = '#EF25EF';
        style2.fontSize = 10;
        style2.bold = false;
        style2.italic = true;
        final Range range2 = sheet.getRangeByIndex(3, 1);
        range2.text = 'Hai';
        range2.cellStyle = style2;
        final Range range12 = sheet.getRangeByName('D3');
        range12.number = 10;
        range12.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.fontName = 'Chiller';
        style3.fontColor = '#FF0000';
        style3.fontSize = 20;
        style3.bold = true;
        style3.italic = false;
        final Range range3 = sheet.getRangeByIndex(5, 1);
        range3.text = 'Hai';
        range3.cellStyle = style3;
        final Range range13 = sheet.getRangeByName('D5');
        range13.number = 10;
        range13.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.fontName = 'Jokerman';
        style4.fontColor = '#E8ED13';
        style4.fontSize = 18;
        style4.bold = true;
        style4.italic = true;
        final Range range4 = sheet.getRangeByIndex(7, 1);
        range4.text = 'Hai';
        range4.cellStyle = style4;
        final Range range14 = sheet.getRangeByName('D7');
        range14.number = 10;
        range14.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleFontStyle.xlsx');
        workbook.dispose();
      });

      test('UnderLine ', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.fontName = 'Castellar';
        style1.fontColor = '#99FF66';
        style1.fontSize = 14;
        style1.bold = true;
        style1.italic = true;
        style1.underline = true;
        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Hai';
        range1.cellStyle = style1;
        final Range range11 = sheet.getRangeByName('D1');
        range11.number = 10;
        range11.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.fontName = 'Elephant';
        style2.fontColor = '#EF25EF';
        style2.fontSize = 10;
        style2.bold = false;
        style2.italic = true;
        style2.underline = true;
        final Range range2 = sheet.getRangeByIndex(3, 1);
        range2.text = 'Hai';
        range2.cellStyle = style2;
        final Range range12 = sheet.getRangeByName('D3');
        range12.number = 10;
        range12.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.fontName = 'Chiller';
        style3.fontColor = '#FF0000';
        style3.fontSize = 20;
        style3.bold = true;
        style3.italic = false;
        style3.underline = true;
        final Range range3 = sheet.getRangeByIndex(5, 1);
        range3.text = 'Hai';
        range3.cellStyle = style3;
        final Range range13 = sheet.getRangeByName('D5');
        range13.number = 10;
        range13.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.fontName = 'Jokerman';
        style4.fontColor = '#E8ED13';
        style4.fontSize = 18;
        style4.bold = true;
        style4.italic = true;
        style4.underline = true;
        final Range range4 = sheet.getRangeByIndex(7, 1);
        range4.text = 'Hai';
        range4.cellStyle = style4;
        final Range range14 = sheet.getRangeByName('D7');
        range14.number = 10;
        range14.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleFontUnderLine.xlsx');
        workbook.dispose();
      });
    });

    group('Alignment', () {
      test('Horizontal', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.hAlign = HAlignType.center;
        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Hai';
        range1.cellStyle = style1;
        final Range range11 = sheet.getRangeByName('D1');
        range11.number = 10;
        range11.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.hAlign = HAlignType.justify;
        final Range range2 = sheet.getRangeByIndex(3, 1);
        range2.text = 'Hai';
        range2.cellStyle = style2;
        final Range range12 = sheet.getRangeByName('D3');
        range12.number = 10;
        range12.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.hAlign = HAlignType.left;
        final Range range3 = sheet.getRangeByIndex(5, 1);
        range3.text = 'Hai';
        range3.cellStyle = style3;
        final Range range13 = sheet.getRangeByName('D5');
        range13.number = 10;
        range13.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.hAlign = HAlignType.right;
        final Range range4 = sheet.getRangeByIndex(7, 1);
        range4.text = 'Hai';
        range4.cellStyle = style4;
        final Range range14 = sheet.getRangeByName('D7');
        range14.number = 10;
        range14.cellStyle = style4;

        final Style style5 = workbook.styles.add('style5');
        style5.hAlign = HAlignType.general;
        final Range range5 = sheet.getRangeByIndex(9, 1);
        range5.text = 'Hai';
        range5.cellStyle = style5;
        final Range range15 = sheet.getRangeByName('D9');
        range15.number = 10;
        range15.cellStyle = style5;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleHorizontal.xlsx');
        workbook.dispose();
      });

      test('Vertical', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.vAlign = VAlignType.bottom;
        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Hai';
        range1.cellStyle = style1;
        final Range range11 = sheet.getRangeByName('D1');
        range11.number = 10;
        range11.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.vAlign = VAlignType.center;
        final Range range2 = sheet.getRangeByIndex(3, 1);
        range2.text = 'Hai';
        range2.cellStyle = style2;
        final Range range12 = sheet.getRangeByName('D3');
        range12.number = 10;
        range12.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.vAlign = VAlignType.top;
        final Range range3 = sheet.getRangeByIndex(5, 1);
        range3.text = 'Hai';
        range3.cellStyle = style3;
        final Range range13 = sheet.getRangeByName('D5');
        range13.number = 10;
        range13.cellStyle = style3;
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleVertical.xlsx');
        workbook.dispose();
      });

      test('Indent', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.indent = 1;
        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Hai';
        range1.cellStyle = style1;
        final Range range11 = sheet.getRangeByName('D1');
        range11.number = 10;
        range11.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.indent = 2;
        final Range range2 = sheet.getRangeByIndex(3, 1);
        range2.text = 'Hai';
        range2.cellStyle = style2;
        final Range range12 = sheet.getRangeByName('D3');
        range12.number = 10;
        range12.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.indent = 3;
        final Range range3 = sheet.getRangeByIndex(5, 1);
        range3.text = 'Hai';
        range3.cellStyle = style3;
        final Range range13 = sheet.getRangeByName('D5');
        range13.number = 10;
        range13.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.indent = 4;
        final Range range4 = sheet.getRangeByIndex(7, 1);
        range4.text = 'Hai';
        range4.cellStyle = style4;
        final Range range14 = sheet.getRangeByName('D7');
        range14.number = 10;
        range14.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleIndent.xlsx');
        workbook.dispose();
      });

      test('Rotation', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.rotation = 20;
        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.text = 'Hai';
        range1.cellStyle = style1;
        final Range range11 = sheet.getRangeByName('D1');
        range11.number = 10;
        range11.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.rotation = 60;
        final Range range2 = sheet.getRangeByIndex(3, 1);
        range2.text = 'Hai';
        range2.cellStyle = style2;
        final Range range12 = sheet.getRangeByName('D3');
        range12.number = 10;
        range12.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.rotation = 90;
        final Range range3 = sheet.getRangeByIndex(5, 1);
        range3.text = 'Hai';
        range3.cellStyle = style3;
        final Range range13 = sheet.getRangeByName('D5');
        range13.number = 10;
        range13.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.rotation = 120;
        final Range range4 = sheet.getRangeByIndex(7, 1);
        range4.text = 'Hai';
        range4.cellStyle = style4;
        final Range range14 = sheet.getRangeByName('D7');
        range14.number = 10;
        range14.cellStyle = style4;

        final Style style5 = workbook.styles.add('style5');
        style5.rotation = 150;
        final Range range5 = sheet.getRangeByIndex(9, 1);
        range5.text = 'Hai';
        range5.cellStyle = style5;
        final Range range15 = sheet.getRangeByName('D9');
        range15.number = 10;
        range15.cellStyle = style5;

        final Style style6 = workbook.styles.add('style6');
        style6.rotation = 180;
        final Range range6 = sheet.getRangeByIndex(11, 1);
        range6.text = 'Hai';
        range6.cellStyle = style6;
        final Range range16 = sheet.getRangeByName('D11');
        range16.number = 10;
        range16.cellStyle = style6;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleRotation.xlsx');
        workbook.dispose();
      });

      test('WrapText', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.wrapText = true;
        final Range range1 = sheet.getRangeByIndex(4, 8);
        range1.text = 'Hai,This is Myself';
        range1.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.wrapText = true;
        final Range range2 = sheet.getRangeByIndex(10, 1);
        range2.number = 99999999;
        range2.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.wrapText = true;
        final Range range3 = sheet.getRangeByIndex(5, 5);
        range3.text = 'Spread Positivity';
        range3.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.wrapText = true;
        final Range range4 = sheet.getRangeByIndex(8, 8);
        range4.text = 'Best out of all';
        range4.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleWrapText.xlsx');
        workbook.dispose();
      });
    });

    group('Borders', () {
      test('All', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.borders.all.lineStyle = LineStyle.double;
        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.borders.all.lineStyle = LineStyle.medium;
        style2.borders.all.color = '#0CA0A4';
        final Range range2 = sheet.getRangeByIndex(4, 4);
        range2.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.borders.all.lineStyle = LineStyle.thick;
        style3.borders.all.color = '#F1289F';
        final Range range3 = sheet.getRangeByIndex(6, 6);
        range3.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.borders.all.lineStyle = LineStyle.thin;
        style4.borders.all.color = '#CCC111';
        final Range range4 = sheet.getRangeByIndex(8, 8);
        range4.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleBorderAll.xlsx');
        workbook.dispose();
      });

      test('Top', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.borders.top.lineStyle = LineStyle.double;
        style1.borders.top.color = '#C2BF37';
        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.borders.top.lineStyle = LineStyle.medium;
        style2.borders.top.color = '#AD37CD';
        final Range range2 = sheet.getRangeByIndex(4, 2);
        range2.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.borders.top.lineStyle = LineStyle.thick;
        style3.borders.top.color = '#EB5F19';
        final Range range3 = sheet.getRangeByIndex(6, 2);
        range3.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.borders.top.lineStyle = LineStyle.thin;
        style4.borders.top.color = '#002060';
        final Range range4 = sheet.getRangeByIndex(8, 2);
        range4.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleBorderTop.xlsx');
        workbook.dispose();
      });

      test('Bottom', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.borders.bottom.lineStyle = LineStyle.double;
        style1.borders.bottom.color = '#200AEC';
        final Range range1 = sheet.getRangeByIndex(2, 4);
        range1.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.borders.bottom.lineStyle = LineStyle.medium;
        style2.borders.bottom.color = '#AD37CD';
        final Range range2 = sheet.getRangeByIndex(4, 4);
        range2.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.borders.bottom.lineStyle = LineStyle.thick;
        style3.borders.bottom.color = '#EFEA25';
        final Range range3 = sheet.getRangeByIndex(6, 4);
        range3.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.borders.bottom.lineStyle = LineStyle.thin;
        style4.borders.bottom.color = '#FF0066';
        final Range range4 = sheet.getRangeByIndex(8, 4);
        range4.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleBorderBottom.xlsx');
        workbook.dispose();
      });

      test('Left', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.borders.left.lineStyle = LineStyle.double;
        style1.borders.left.color = '#E62626';
        final Range range1 = sheet.getRangeByIndex(2, 6);
        range1.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.borders.left.lineStyle = LineStyle.medium;
        style2.borders.left.color = '#FF0DC0';
        final Range range2 = sheet.getRangeByIndex(4, 6);
        range2.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.borders.left.lineStyle = LineStyle.thick;
        style3.borders.left.color = '#45E79E';
        final Range range3 = sheet.getRangeByIndex(6, 6);
        range3.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.borders.left.lineStyle = LineStyle.thin;
        style4.borders.left.color = '#663300';
        final Range range4 = sheet.getRangeByIndex(8, 6);
        range4.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleBorderLeft.xlsx');
        workbook.dispose();
      });

      test('Right', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        final Style style1 = workbook.styles.add('style1');
        style1.borders.right.lineStyle = LineStyle.double;
        style1.borders.right.color = '#B36415';
        final Range range1 = sheet.getRangeByIndex(2, 8);
        range1.cellStyle = style1;

        final Style style2 = workbook.styles.add('style2');
        style2.borders.right.lineStyle = LineStyle.medium;
        style2.borders.right.color = '#7DFC64';
        final Range range2 = sheet.getRangeByIndex(4, 8);
        range2.cellStyle = style2;

        final Style style3 = workbook.styles.add('style3');
        style3.borders.right.lineStyle = LineStyle.thick;
        style3.borders.right.color = '#19B1E1';
        final Range range3 = sheet.getRangeByIndex(6, 8);
        range3.cellStyle = style3;

        final Style style4 = workbook.styles.add('style4');
        style4.borders.right.lineStyle = LineStyle.thin;
        style4.borders.right.color = '#154B21';
        final Range range4 = sheet.getRangeByIndex(8, 8);
        range4.cellStyle = style4;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelGlobalStyleBorderRight.xlsx');
        workbook.dispose();
      });
    });

    test('NumberFormat', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style style1 = workbook.styles.add('style1');
      style1.numberFormat = 'h:mm';
      final Range range1 = sheet.getRangeByIndex(2, 1);
      range1.number = 44;
      range1.cellStyle = style1;

      final Style style11 = workbook.styles.add('style11');
      style11.numberFormat = '@';
      final Range range11 = sheet.getRangeByName('E1');
      range11.number = 10;
      range11.cellStyle = style11;

      final Style style2 = workbook.styles.add('style2');
      style2.numberFormat = r'_(* \\(#,##0\\)';
      final Range range2 = sheet.getRangeByIndex(4, 2);
      range2.number = 24;
      range2.cellStyle = style2;

      final Style style12 = workbook.styles.add('style12');
      style12.numberFormat = '0.00%';
      final Range range12 = sheet.getRangeByName('G1');
      range12.number = 10;
      range12.cellStyle = style12;

      final Style style3 = workbook.styles.add('style3');
      style3.numberFormat = '# ?/?';
      final Range range3 = sheet.getRangeByIndex(5, 1);
      range3.number = 16.00;
      range3.cellStyle = style3;

      final Style style13 = workbook.styles.add('style13');
      style13.numberFormat = '[Red](#,##0.00)';
      final Range range13 = sheet.getRangeByName('C9');
      range13.number = 10;
      range13.cellStyle = style13;

      final Style style4 = workbook.styles.add('style4');
      style4.numberFormat = r"_('$'* \(#,##0\)";
      final Range range4 = sheet.getRangeByIndex(14, 1);
      range4.number = 200;
      range4.cellStyle = style4;

      final Style style14 = workbook.styles.add('style14');
      style14.numberFormat = r"_('$'* #,##0.00_)";
      final Range range14 = sheet.getRangeByName('E7');
      range14.number = 10;
      range14.cellStyle = style14;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGlobalStyleNumberFormat.xlsx');
      workbook.dispose();
    });
    test('All Properties', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Style style = workbook.styles.add('style');
      style.backColor = '#37D8E9';
      style.fontName = 'Times  Roman';
      style.fontSize = 20;
      style.fontColor = '#C67878';
      style.italic = true;
      style.bold = true;
      style.underline = true;
      style.wrapText = true;
      style.hAlign = HAlignType.left;
      style.vAlign = VAlignType.bottom;
      style.rotation = 90;
      style.borders.all.lineStyle = LineStyle.thick;
      style.borders.all.color = '#9954CC';
      style.numberFormat = r'_(\$* #,##0_)';
      final Range range1 = sheet.getRangeByIndex(3, 4);
      range1.number = 10;
      range1.cellStyle = style;
      final Range range11 = sheet.getRangeByIndex(7, 7);
      range11.text = 'Zee';
      range11.cellStyle = style;

      final Style style1 = workbook.styles.add('style1');
      style1.backColor = '#009900';
      style1.fontName = 'Ink Free';
      style1.fontSize = 18;
      style1.fontColor = '#4CDCC7';
      style1.italic = true;
      style1.wrapText = true;
      style1.hAlign = HAlignType.right;
      style1.vAlign = VAlignType.top;
      style1.borders.top.lineStyle = LineStyle.double;
      style1.borders.top.color = '#ED943B';
      style1.numberFormat = '(#,##0)';
      final Range range2 = sheet.getRangeByIndex(5, 1);
      range2.number = 100;
      range2.cellStyle = style1;
      final Range range12 = sheet.getRangeByIndex(6, 6);
      range12.text = 'M';
      range12.cellStyle = style1;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGlobalStyleAllProperties.xlsx');
      workbook.dispose();
    });
    test('WrostCase', () {
      final Workbook workbook = Workbook();
      try {
        workbook.styles.add('');
      } catch (e) {
        expect('Exception: name should not be empty', e.toString());
      }
      try {
        workbook.styles.add('style1');
        workbook.styles.add('style1');
      } catch (e) {
        expect('Exception: Name of style must be unique.', e.toString());
      }
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleException.xlsx');
      workbook.dispose();
    });

    test('GlobalStyleChanges', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1:A4').text = 'M';
      final Style style1 = workbook.styles.add('style1');
      style1.backColor = '#73802A';

      sheet.getRangeByName('A1:A4').cellStyle = style1;
      sheet.getRangeByName('A2').cellStyle.backColor = '#ADF427';
      sheet.getRangeByName('A3').cellStyle.backColor = '#ADF427';

      sheet.getRangeByName('C1:C4').text = 'M';
      final Style style2 = workbook.styles.add('Style2');
      style2.fontColor = '#208499';
      style2.fontName = 'Chiller';
      style2.fontSize = 14;

      sheet.getRangeByName('C1:C4').cellStyle = style2;
      sheet.getRangeByName('C2').cellStyle.fontColor = '#984842';
      sheet.getRangeByName('C3').cellStyle.fontName = 'Arial';
      sheet.getRangeByName('C4').cellStyle.fontSize = 16;

      sheet.getRangeByName('E1:E4').text = 'M';
      final Style style3 = workbook.styles.add('Style3');
      style3.bold = true;
      style3.italic = true;
      style3.underline = true;

      sheet.getRangeByName('E1:E4').cellStyle = style3;
      sheet.getRangeByName('E2').cellStyle.bold = false;
      sheet.getRangeByName('E3').cellStyle.italic = false;
      sheet.getRangeByName('E4').cellStyle.underline = false;

      sheet.getRangeByName('G1:G4').text = 'M';
      final Style style4 = workbook.styles.add('Style4');
      style4.hAlign = HAlignType.center;
      style4.vAlign = VAlignType.center;

      sheet.getRangeByName('G1:G4').cellStyle = style4;
      sheet.getRangeByName('G2').cellStyle.hAlign = HAlignType.left;
      sheet.getRangeByName('G3').cellStyle.vAlign = VAlignType.bottom;
      sheet.getRangeByName('G3').cellStyle.hAlign = HAlignType.left;

      sheet.getRangeByName('I1:I4').text = 'M';
      final Style style5 = workbook.styles.add('Style5');
      style5.indent = 2;

      sheet.getRangeByName('I1:I4').cellStyle = style5;
      sheet.getRangeByName('I4').cellStyle.indent = 4;

      sheet.getRangeByName('K1:K4').text = 'Welcome everyone';
      final Style style6 = workbook.styles.add('Style6');
      style6.wrapText = true;

      sheet.getRangeByName('K1:K4').cellStyle = style6;
      sheet.getRangeByName('K3').cellStyle.wrapText = false;

      sheet.getRangeByName('A8:A12').text = 'M';
      final Style style7 = workbook.styles.add('Style7');
      style7.rotation = 90;

      sheet.getRangeByName('A8:A12').cellStyle = style7;
      sheet.getRangeByName('A10').cellStyle.rotation = 180;

      sheet.getRangeByName('C8:C12').text = 'M';
      final Style style8 = workbook.styles.add('Style8');
      style8.borders.all.lineStyle = LineStyle.double;
      style8.borders.all.color = '#904031';

      sheet.getRangeByName('C8:C12').cellStyle = style8;
      sheet.getRangeByName('C10').cellStyle.borders.all.lineStyle =
          LineStyle.medium;
      sheet.getRangeByName('C11').cellStyle.borders.all.lineStyle =
          LineStyle.medium;
      sheet.getRangeByName('C12').cellStyle.borders.all.lineStyle =
          LineStyle.medium;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGlobalstyle_1.xlsx');
    });

    test('ExcelCellStyleForMultipleRange', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1, 30, 30);
      range.text = 'Hello World';

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByName('A1:D1');
      range1.cellStyle = cellStyle1;
      expect(range1.cellStyle.name, 'Style1');
      expect(sheet.getRangeByName('A1:E1').cellStyle.name, '');

      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style2';
      workbook.styles.addStyle(cellStyle2);
      final Range range2 = sheet.getRangeByName('A2:D2');
      range2.cellStyle = cellStyle2;
      expect(range2.cellStyle.index, 2);
      expect(sheet.getRangeByName('A2:E2').cellStyle.index, 1);

      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style3';
      cellStyle3.backColor = '#111111';
      workbook.styles.addStyle(cellStyle3);
      final Range range3 = sheet.getRangeByName('A3:D3');
      range3.cellStyle = cellStyle3;
      expect(range3.cellStyle.backColor, '#111111');
      expect(sheet.getRangeByName('A3:E3').cellStyle.backColor, 'none');

      final CellStyle cellStyle4 = CellStyle(workbook);
      cellStyle4.name = 'Style4';
      cellStyle4.bold = true;
      workbook.styles.addStyle(cellStyle4);
      final Range range4 = sheet.getRangeByName('A4:D4');
      range4.cellStyle = cellStyle4;
      expect(range4.cellStyle.bold, true);
      expect(sheet.getRangeByName('A4:E4').cellStyle.bold, false);

      final CellStyle cellStyle5 = CellStyle(workbook);
      cellStyle5.name = 'Style5';
      cellStyle5.fontColor = '#111111';
      workbook.styles.addStyle(cellStyle5);
      final Range range5 = sheet.getRangeByName('A5:D5');
      range5.cellStyle = cellStyle5;
      expect(range5.cellStyle.fontColor, '#111111');
      expect(sheet.getRangeByName('A5:E5').cellStyle.fontColor, '#000000');

      final CellStyle cellStyle6 = CellStyle(workbook);
      cellStyle6.name = 'Style6';
      cellStyle6.fontName = 'Arial';
      workbook.styles.addStyle(cellStyle6);
      final Range range6 = sheet.getRangeByName('A6:D6');
      range6.cellStyle = cellStyle6;
      expect(range6.cellStyle.fontName, 'Arial');
      expect(sheet.getRangeByName('A6:E6').cellStyle.fontName, 'Calibri');

      final CellStyle cellStyle7 = CellStyle(workbook);
      cellStyle7.name = 'Style7';
      cellStyle7.fontSize = 14;
      workbook.styles.addStyle(cellStyle7);
      final Range range7 = sheet.getRangeByName('A7:D7');
      range7.cellStyle = cellStyle7;
      expect(range7.cellStyle.fontSize, 14);
      expect(sheet.getRangeByName('A7:E7').cellStyle.fontSize, 11);

      final CellStyle cellStyle8 = CellStyle(workbook);
      cellStyle8.name = 'Style8';
      cellStyle8.hAlign = HAlignType.center;
      workbook.styles.addStyle(cellStyle8);
      final Range range8 = sheet.getRangeByName('A8:D8');
      range8.cellStyle = cellStyle8;
      expect(range8.cellStyle.hAlign, HAlignType.center);
      expect(
          sheet.getRangeByName('A8:E8').cellStyle.hAlign, HAlignType.general);

      final CellStyle cellStyle9 = CellStyle(workbook);
      cellStyle9.name = 'Style9';
      cellStyle9.indent = 2;
      workbook.styles.addStyle(cellStyle9);
      final Range range9 = sheet.getRangeByName('A9:D9');
      range9.cellStyle = cellStyle9;
      expect(range9.cellStyle.indent, 2);
      expect(sheet.getRangeByName('A9:E9').cellStyle.indent, 0);

      final CellStyle cellStyle11 = CellStyle(workbook);
      cellStyle11.name = 'Style11';
      cellStyle11.italic = true;
      workbook.styles.addStyle(cellStyle11);
      final Range range11 = sheet.getRangeByName('A11:D11');
      range11.cellStyle = cellStyle11;
      expect(range11.cellStyle.italic, true);
      expect(sheet.getRangeByName('A11:E11').cellStyle.italic, false);

      final CellStyle cellStyle13 = CellStyle(workbook);
      cellStyle13.name = 'Style13';
      cellStyle13.numberFormat = '@';
      workbook.styles.addStyle(cellStyle13);
      final Range range13 = sheet.getRangeByName('A13:D13');
      range13.cellStyle = cellStyle13;
      expect(range13.cellStyle.numberFormat, '@');
      expect(sheet.getRangeByName('A13:E13').cellStyle.numberFormat, 'General');
      expect(range13.cellStyle.numberFormatIndex, 49);
      expect(sheet.getRangeByName('A13:E13').cellStyle.numberFormatIndex, 0);
      sheet.getRangeByName('A13:E13').cellStyle.numberFormat = '@';
      expect(sheet.getRangeByName('A13:E13').cellStyle.numberFormat, '@');

      final CellStyle cellStyle14 = CellStyle(workbook);
      cellStyle14.name = 'Style14';
      cellStyle14.rotation = 45;
      workbook.styles.addStyle(cellStyle14);
      final Range range14 = sheet.getRangeByName('A14:D14');
      range14.cellStyle = cellStyle14;
      expect(range14.cellStyle.rotation, 45);
      expect(sheet.getRangeByName('A14:E14').cellStyle.rotation, 0);

      final CellStyle cellStyle15 = CellStyle(workbook);
      cellStyle15.name = 'Style15';
      cellStyle15.underline = true;
      workbook.styles.addStyle(cellStyle15);
      final Range range15 = sheet.getRangeByName('A15:D15');
      range15.cellStyle = cellStyle15;
      expect(range15.cellStyle.underline, true);
      expect(sheet.getRangeByName('A15:E15').cellStyle.underline, false);

      final CellStyle cellStyle16 = CellStyle(workbook);
      cellStyle16.name = 'Style16';
      cellStyle16.vAlign = VAlignType.center;
      workbook.styles.addStyle(cellStyle16);
      final Range range16 = sheet.getRangeByName('A16:D16');
      range16.cellStyle = cellStyle16;
      expect(range16.cellStyle.vAlign, VAlignType.center);
      expect(
          sheet.getRangeByName('A16:E16').cellStyle.vAlign, VAlignType.bottom);

      final CellStyle cellStyle17 = CellStyle(workbook);
      cellStyle17.name = 'Style17';
      cellStyle17.wrapText = true;
      workbook.styles.addStyle(cellStyle17);
      final Range range17 = sheet.getRangeByName('A17:D17');
      range17.cellStyle = cellStyle17;
      expect(range17.cellStyle.wrapText, true);
      expect(sheet.getRangeByName('A17:E17').cellStyle.wrapText, false);

      final CellStyle cellStyle18 = CellStyle(workbook);
      cellStyle18.name = 'Style18';
      cellStyle18.borders.right.lineStyle = LineStyle.thick;
      cellStyle18.borders.right.color = '#111111';
      workbook.styles.addStyle(cellStyle18);
      final Range range18 = sheet.getRangeByName('A18:D18');
      range18.cellStyle = cellStyle18;
      expect(range18.cellStyle.borders.right.lineStyle, LineStyle.thick);
      expect(range18.cellStyle.borders.right.color, '#111111');
      expect(sheet.getRangeByName('A18:E18').cellStyle.borders.right.lineStyle,
          LineStyle.none);
      expect(sheet.getRangeByName('A18:E18').cellStyle.borders.right.color,
          '#000000');

      final CellStyle cellStyle19 = CellStyle(workbook);
      cellStyle19.name = 'Style19';
      cellStyle19.borders.right.lineStyle = LineStyle.thin;
      cellStyle19.borders.right.color = '#111111';
      workbook.styles.addStyle(cellStyle19);
      final Range range19 = sheet.getRangeByName('A19:D19');
      range19.cellStyle = cellStyle19;
      expect(range19.cellStyle.borders.right.lineStyle, LineStyle.thin);
      expect(range19.cellStyle.borders.right.color, '#111111');
      expect(sheet.getRangeByName('A19:E19').cellStyle.borders.right.lineStyle,
          LineStyle.none);
      expect(sheet.getRangeByName('A19:E19').cellStyle.borders.right.color,
          '#000000');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleForMultipleRange.xlsx');
      workbook.dispose();
    });
  });
  group('CellStyle Rgb color Property', () {
    test('BackcolorRgb', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style style = workbook.styles.add('style');
      // set back color.
      style.backColorRgb = const Color.fromARGB(255, 255, 56, 255);
      final Range range = sheet.getRangeByIndex(3, 4, 4, 5);
      range.number = 10;
      range.cellStyle = style;
      sheet.getRangeByIndex(3, 4).cellStyle.backColor = '#896318';

      final Style style1 = workbook.styles.add('style1');
      // set back color.
      style1.backColorRgb = const Color.fromARGB(255, 20, 200, 20);
      final Range range2 = sheet.getRangeByIndex(1, 2, 4, 2);
      range2.number = 10;
      range2.cellStyle = style1;
      sheet.getRangeByIndex(1, 2).cellStyle.backColorRgb =
          const Color.fromARGB(255, 255, 56, 255);

      final Style style2 = workbook.styles.add('style2');
      // set back color.
      style2.backColor = '#00AADD';
      final Range range3 = sheet.getRangeByIndex(10, 15, 10, 20);
      range3.number = 10;
      range3.cellStyle = style2;
      sheet.getRangeByIndex(10, 16).cellStyle.backColor = '#896318';

      final Style style3 = workbook.styles.add('style3');
      // set back color.
      style3.backColor = '#CCAADD';
      final Range range4 = sheet.getRangeByIndex(10, 1, 14, 4);
      range4.number = 10;
      range4.cellStyle = style3;
      sheet.getRangeByIndex(10, 2).cellStyle.backColorRgb =
          const Color.fromARGB(255, 25, 56, 255);

      sheet.getRangeByIndex(20, 4, 24, 10).cellStyle.backColorRgb =
          const Color.fromARGB(255, 0, 200, 200);

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style4';
      cellStyle1.backColor = '#19FFDD';
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'M';
      range1.cellStyle = cellStyle1;

      print(range1.cellStyle.backColor);
      print(range1.cellStyle.backColorRgb);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleBackcolorRgb.xlsx');
      workbook.dispose();
    });
    test('FontcolorRgb', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style style = workbook.styles.add('style');
      // set font color.
      style.fontColorRgb = const Color.fromARGB(255, 255, 56, 255);
      final Range range = sheet.getRangeByIndex(3, 4, 4, 5);
      range.number = 100;
      range.cellStyle = style;
      sheet.getRangeByIndex(3, 4).cellStyle.fontColor = '#896318';

      final Style style1 = workbook.styles.add('style1');
      // set font color.
      style1.fontColorRgb = const Color.fromARGB(255, 20, 200, 20);
      final Range range2 = sheet.getRangeByIndex(1, 2, 4, 2);
      range2.text = 'MMMM';
      range2.cellStyle = style1;
      sheet.getRangeByIndex(1, 2).cellStyle.fontColorRgb =
          const Color.fromARGB(255, 255, 56, 255);

      final Style style2 = workbook.styles.add('style2');
      // set font color.
      style2.fontColor = '#00AADD';
      final Range range3 = sheet.getRangeByIndex(10, 15, 10, 20);
      range3.text = 'Helloo';
      range3.cellStyle = style2;
      sheet.getRangeByIndex(10, 16).cellStyle.fontColor = '#896318';

      final Style style3 = workbook.styles.add('style3');
      // set font color.
      style3.fontColor = '#CCAADD';
      final Range range4 = sheet.getRangeByIndex(10, 1, 14, 4);
      range4.number = 1000;
      range4.cellStyle = style3;
      sheet.getRangeByIndex(10, 2).cellStyle.fontColorRgb =
          const Color.fromARGB(255, 25, 56, 255);

      sheet.getRangeByIndex(20, 4, 24, 10).cellStyle.fontColorRgb =
          const Color.fromARGB(255, 0, 200, 200);
      sheet.getRangeByIndex(20, 4, 24, 10).text = 'World';

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style4';
      cellStyle1.fontColor = '#19FFDD';
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'M';
      range1.cellStyle = cellStyle1;

      print(range1.cellStyle.fontColor);
      print(range1.cellStyle.fontColorRgb);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStylefontcolorRgb.xlsx');
      workbook.dispose();
    });
    test('Border colorRgb', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style style = workbook.styles.add('style');
      // set left border color.
      style.borders.left.lineStyle = LineStyle.thick;
      style.borders.left.colorRgb = const Color.fromARGB(255, 255, 56, 255);
      final Range range = sheet.getRangeByIndex(3, 4, 4, 5);
      range.number = 100;
      range.cellStyle = style;
      sheet.getRangeByIndex(3, 4).cellStyle.borders.left.color = '#896318';

      final Style style1 = workbook.styles.add('style1');
      // set all border style and color.
      style1.borders.all.lineStyle = LineStyle.double;
      style1.borders.all.colorRgb = const Color.fromARGB(255, 20, 200, 20);
      final Range range2 = sheet.getRangeByIndex(1, 2, 4, 2);
      range2.text = 'MMMM';
      range2.cellStyle = style1;
      sheet.getRangeByIndex(1, 2).cellStyle.borders.all.colorRgb =
          const Color.fromARGB(255, 255, 56, 255);

      final Style style2 = workbook.styles.add('style2');
      // set right border style and color.
      style2.borders.right.lineStyle = LineStyle.thin;
      style2.borders.right.color = '#00AADD';
      final Range range3 = sheet.getRangeByIndex(10, 15, 10, 20);
      range3.text = 'Helloo';
      range3.cellStyle = style2;
      sheet.getRangeByIndex(10, 16).cellStyle.borders.right.color = '#896318';

      final Style style3 = workbook.styles.add('style3');
      // set top border style and color.
      style3.borders.right.lineStyle = LineStyle.medium;
      final Range range4 = sheet.getRangeByIndex(10, 1, 14, 4);
      range4.number = 1000;
      range4.cellStyle = style3;
      sheet.getRangeByIndex(10, 2).cellStyle.borders.right.colorRgb =
          const Color.fromARGB(255, 25, 56, 255);

      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style4';
      cellStyle1.borders.bottom.lineStyle = LineStyle.double;
      cellStyle1.borders.bottom.color = '#19FFDD';
      workbook.styles.addStyle(cellStyle1);
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.text = 'M';
      range1.cellStyle = cellStyle1;

      print(range1.cellStyle.borders.bottom.color);
      print(range1.cellStyle.borders.bottom.colorRgb);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCellStyleBordercolorRgb.xlsx');
      workbook.dispose();
    });
    test('line styles', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      //Line styles for all borders
      sheet.getRangeByName('A1').cellStyle.borders.all.lineStyle =
          LineStyle.dashed;
      sheet.getRangeByName('B2').cellStyle.borders.all.lineStyle =
          LineStyle.dotted;
      sheet.getRangeByName('C3').cellStyle.borders.all.lineStyle =
          LineStyle.hair;
      sheet.getRangeByName('D4').cellStyle.borders.all.lineStyle =
          LineStyle.dashDot;
      sheet.getRangeByName('E5').cellStyle.borders.all.lineStyle =
          LineStyle.mediumDashDot;
      sheet.getRangeByName('F6').cellStyle.borders.all.lineStyle =
          LineStyle.mediumDashDotDot;
      sheet.getRangeByName('G7').cellStyle.borders.all.lineStyle =
          LineStyle.mediumDashed;
      sheet.getRangeByName('H8').cellStyle.borders.all.lineStyle =
          LineStyle.slantDashDot;
      sheet.getRangeByName('I9').cellStyle.borders.all.lineStyle =
          LineStyle.dashDotDot;
      sheet.getRangeByName('J10').cellStyle.borders.all.lineStyle =
          LineStyle.thick;
      sheet.getRangeByName('K11').cellStyle.borders.all.lineStyle =
          LineStyle.thin;
      sheet.getRangeByName('L12').cellStyle.borders.all.lineStyle =
          LineStyle.medium;
      sheet.getRangeByName('M13').cellStyle.borders.all.lineStyle =
          LineStyle.double;
      //set color for all border.
      final Range range = sheet.getRangeByName('A1:M13');
      range.cellStyle.borders.all.colorRgb =
          const Color.fromARGB(255, 240, 7, 7);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelLineStyle.xlsx');
      workbook.dispose();
    });
  });
}
