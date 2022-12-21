import 'dart:ui';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void sampleBrowserSamples() {
  group('Sample Browser Samples', () {
    // Create styles for worksheet
    List<Style> balanceSheetStyles(Workbook workbook) {
      final Style style = workbook.styles.add('Style');
      style.fontColor = '#308DA2';
      style.fontSize = 28;
      style.bold = true;
      style.borders.bottom.lineStyle = LineStyle.double;
      style.vAlign = VAlignType.center;

      final Style style1 = workbook.styles.add('Style1');
      style1.bold = true;
      style1.fontSize = 12;
      style1.fontColor = '#595959';
      style1.vAlign = VAlignType.center;
      style1.borders.bottom.lineStyle = LineStyle.thin;
      style1.borders.bottom.color = '#A6A6A6';
      style1.borders.right.lineStyle = LineStyle.thin;
      style1.borders.right.color = '#A6A6A6';

      final Style style2 = workbook.styles.add('Style2');
      style2.fontColor = '#595959';
      style2.wrapText = true;
      style2.vAlign = VAlignType.center;
      style2.borders.bottom.lineStyle = LineStyle.thin;
      style2.borders.bottom.color = '#A6A6A6';
      style2.borders.right.lineStyle = LineStyle.thin;
      style2.borders.right.color = '#A6A6A6';
      style2.numberFormat = r'_($* #,##0_);_($* (#,##0);_($* "-"_);_(@_)';

      final Style style3 = workbook.styles.add('style3');
      style3.backColor = '#F2F2F2';
      style3.fontColor = '#313F55';
      style3.vAlign = VAlignType.center;
      style3.borders.bottom.lineStyle = LineStyle.thin;
      style3.borders.bottom.color = '#308DA2';
      style3.borders.right.lineStyle = LineStyle.thin;
      style3.borders.right.color = '#A6A6A6';

      final Style style4 = workbook.styles.add('Style4');
      style4.backColor = '#CFEBF1';
      style4.bold = true;
      style4.vAlign = VAlignType.center;
      style4.borders.bottom.lineStyle = LineStyle.medium;
      style4.borders.bottom.color = '#308DA2';
      style4.borders.right.lineStyle = LineStyle.thin;
      style4.borders.right.color = '#A6A6A6';

      final Style style5 = workbook.styles.add('Style5');
      style5.fontSize = 12;
      style5.vAlign = VAlignType.center;
      style5.hAlign = HAlignType.right;
      style5.indent = 1;
      style5.borders.bottom.lineStyle = LineStyle.thick;
      style5.borders.bottom.color = '#308DA2';
      style5.borders.right.lineStyle = LineStyle.thin;
      style5.borders.right.color = '#A6A6A6';
      style5.borders.left.lineStyle = LineStyle.thin;
      style5.borders.left.color = '#A6A6A6';

      final Style style6 = workbook.styles.add('Style6');
      style6.fontColor = '#595959';
      style6.wrapText = true;
      style6.vAlign = VAlignType.center;
      style6.borders.right.lineStyle = LineStyle.thin;
      style6.borders.right.color = '#A6A6A6';
      style6.numberFormat = r'_($* #,##0_);_($* (#,##0);_($* "-"_);_(@_)';

      final Style style7 = workbook.styles.add('Style7');
      style7.fontColor = '#595959';
      style7.wrapText = true;
      style7.vAlign = VAlignType.center;
      style7.borders.bottom.lineStyle = LineStyle.thin;
      style7.borders.bottom.color = '#A6A6A6';

      final Style style8 = workbook.styles.add('style8');
      style8.backColor = '#F2F2F2';
      style8.fontColor = '#313F55';
      style8.vAlign = VAlignType.center;
      style8.borders.bottom.lineStyle = LineStyle.thin;
      style8.borders.bottom.color = '#308DA2';
      style8.borders.right.lineStyle = LineStyle.thin;
      style8.borders.right.color = '#A6A6A6';
      style8.numberFormat = r'_($* #,##0_);_($* (#,##0);_($* "-"_);_(@_)';

      final Style style9 = workbook.styles.add('style9');
      style9.backColor = '#CFEBF1';
      style9.bold = true;
      style9.vAlign = VAlignType.center;
      style9.borders.bottom.lineStyle = LineStyle.medium;
      style9.borders.bottom.color = '#308DA2';
      style9.borders.right.lineStyle = LineStyle.thin;
      style9.borders.right.color = '#A6A6A6';
      style9.numberFormat = r'_($* #,##0_);_($* (#,##0);_($* "-"_);_(@_)';

      return <Style>[
        style,
        style1,
        style2,
        style3,
        style4,
        style5,
        style6,
        style7,
        style8,
        style9
      ];
    }

    test('Invoice', () {
      //Create a Excel document.

      //Creating a workbook.
      final Workbook workbook = Workbook();
      //Accessing via index
      final Worksheet sheet = workbook.worksheets[0];
      sheet.name = 'Invoice';
      sheet.showGridlines = false;

      sheet.enableSheetCalculations();
      sheet.getRangeByName('A1').columnWidth = 4.09;
      sheet.getRangeByName('B1:C1').columnWidth = 13.09;
      sheet.getRangeByName('D1').columnWidth = 11.47;
      sheet.getRangeByName('E1').columnWidth = 7.77;
      sheet.getRangeByName('F1').columnWidth = 9;
      sheet.getRangeByName('G1').columnWidth = 8.09;
      sheet.getRangeByName('H1').columnWidth = 3.73;

      sheet.getRangeByName('A1:H1').cellStyle.backColor = '#333F4F';
      sheet.getRangeByName('A1:H1').merge();
      sheet.getRangeByName('B4:D6').merge();

      sheet.getRangeByName('B4').text = 'INVOICE';
      sheet.getRangeByName('B4').cellStyle.bold = true;
      sheet.getRangeByName('B4').cellStyle.fontSize = 32;

      final Style style1 = workbook.styles.add('style1');
      style1.borders.bottom.lineStyle = LineStyle.medium;
      style1.borders.bottom.color = '#AEAAAA';

      sheet.getRangeByName('B7:G7').merge();
      sheet.getRangeByName('B7:G7').cellStyle = style1;

      sheet.getRangeByName('B13:G13').merge();
      sheet.getRangeByName('B13:G13').cellStyle = style1;

      sheet.getRangeByName('B8').text = 'BILL TO:';
      sheet.getRangeByName('B8').cellStyle.fontSize = 9;
      sheet.getRangeByName('B8').cellStyle.bold = true;

      sheet.getRangeByName('B9').text = 'Abraham Swearegin';
      sheet.getRangeByName('B9').cellStyle.fontSize = 12;
      sheet.getRangeByName('B9').cellStyle.bold = true;

      sheet.getRangeByName('B10').text =
          'United States, California, San Mateo,';
      sheet.getRangeByName('B10').cellStyle.fontSize = 9;

      sheet.getRangeByName('B11').text = '9920 BridgePointe Parkway,';
      sheet.getRangeByName('B11').cellStyle.fontSize = 9;

      sheet.getRangeByName('B12').number = 9365550136;
      sheet.getRangeByName('B12').cellStyle.fontSize = 9;
      sheet.getRangeByName('B12').cellStyle.hAlign = HAlignType.left;

      final Range range1 = sheet.getRangeByName('F8:G8');
      final Range range2 = sheet.getRangeByName('F9:G9');
      final Range range3 = sheet.getRangeByName('F10:G10');
      final Range range4 = sheet.getRangeByName('E11:G11');
      final Range range5 = sheet.getRangeByName('F12:G12');

      range1.merge();
      range2.merge();
      range3.merge();
      range4.merge();
      range5.merge();

      sheet.getRangeByName('F8').text = 'INVOICE#';
      range1.cellStyle.fontSize = 8;
      range1.cellStyle.bold = true;
      range1.cellStyle.hAlign = HAlignType.right;

      sheet.getRangeByName('F9').number = 2058557939;
      range2.cellStyle.fontSize = 9;
      range2.cellStyle.hAlign = HAlignType.right;

      sheet.getRangeByName('F10').text = 'DATE';
      range3.cellStyle.fontSize = 8;
      range3.cellStyle.bold = true;
      range3.cellStyle.hAlign = HAlignType.right;

      sheet.getRangeByName('E11').dateTime = DateTime(2020, 08, 31);
      sheet.getRangeByName('E11').numberFormat =
          r'[$-x-sysdate]dddd, mmmm dd, yyyy';
      range4.cellStyle.fontSize = 9;
      range4.cellStyle.hAlign = HAlignType.right;

      range5.cellStyle.fontSize = 8;
      range5.cellStyle.bold = true;
      range5.cellStyle.hAlign = HAlignType.right;

      final Range range6 = sheet.getRangeByName('B15:G15');
      range6.cellStyle.fontSize = 10;
      range6.cellStyle.bold = true;

      sheet.getRangeByIndex(15, 2).text = 'Code';
      sheet.getRangeByIndex(16, 2).text = 'CA-1098';
      sheet.getRangeByIndex(17, 2).text = 'LJ-0192';
      sheet.getRangeByIndex(18, 2).text = 'So-B909-M';
      sheet.getRangeByIndex(19, 2).text = 'FK-5136';
      sheet.getRangeByIndex(20, 2).text = 'HL-U509';

      sheet.getRangeByIndex(15, 3).text = 'Description';
      sheet.getRangeByIndex(16, 3).text = 'AWC Logo Cap';
      sheet.getRangeByIndex(17, 3).text = 'Long-Sleeve Logo Jersey, M';
      sheet.getRangeByIndex(18, 3).text = 'Mountain Bike Socks, M';
      sheet.getRangeByIndex(19, 3).text = 'ML Fork';
      sheet.getRangeByIndex(20, 3).text = 'Sports-100 Helmet, Black';

      sheet.getRangeByIndex(15, 3, 15, 4).merge();
      sheet.getRangeByIndex(16, 3, 16, 4).merge();
      sheet.getRangeByIndex(17, 3, 17, 4).merge();
      sheet.getRangeByIndex(18, 3, 18, 4).merge();
      sheet.getRangeByIndex(19, 3, 19, 4).merge();
      sheet.getRangeByIndex(20, 3, 20, 4).merge();

      sheet.getRangeByIndex(15, 5).text = 'Quantity';
      sheet.getRangeByIndex(16, 5).number = 2;
      sheet.getRangeByIndex(17, 5).number = 3;
      sheet.getRangeByIndex(18, 5).number = 2;
      sheet.getRangeByIndex(19, 5).number = 6;
      sheet.getRangeByIndex(20, 5).number = 1;

      sheet.getRangeByIndex(15, 6).text = 'Price';
      sheet.getRangeByIndex(16, 6).number = 8.99;
      sheet.getRangeByIndex(17, 6).number = 49.99;
      sheet.getRangeByIndex(18, 6).number = 9.50;
      sheet.getRangeByIndex(19, 6).number = 175.49;
      sheet.getRangeByIndex(20, 6).number = 34.99;

      sheet.getRangeByIndex(15, 7).text = 'Total';
      sheet.getRangeByIndex(16, 7).formula = '=E16*F16+(E16*F16)';
      sheet.getRangeByIndex(17, 7).formula = '=E17*F17+(E17*F17)';
      sheet.getRangeByIndex(18, 7).formula = '=E18*F18+(E18*F18)';
      sheet.getRangeByIndex(19, 7).formula = '=E19*F19+(E19*F19)';
      sheet.getRangeByIndex(20, 7).formula = '=E20*F20+(E20*F20)';
      sheet.getRangeByIndex(15, 6, 20, 7).numberFormat = r'$#,##0.00';

      sheet.getRangeByName('E15:G15').cellStyle.hAlign = HAlignType.right;
      sheet.getRangeByName('B15:G15').cellStyle.fontSize = 10;
      sheet.getRangeByName('B15:G15').cellStyle.bold = true;
      sheet.getRangeByName('B16:G20').cellStyle.fontSize = 9;

      sheet.getRangeByName('E22:G22').merge();
      sheet.getRangeByName('E22:G22').cellStyle.hAlign = HAlignType.right;
      sheet.getRangeByName('E23:G24').merge();

      final Range range7 = sheet.getRangeByName('E22');
      final Range range8 = sheet.getRangeByName('E23');
      range7.text = 'TOTAL';
      range7.cellStyle.fontSize = 8;
      range7.cellStyle.fontColor = '#4D6575';
      range8.formula = r'=SUM(G16:G20)';
      range8.numberFormat = r'$#,##0.00';
      range8.cellStyle.fontSize = 24;
      range8.cellStyle.hAlign = HAlignType.right;
      range8.cellStyle.bold = true;

      sheet.getRangeByIndex(26, 1).text =
          '800 Interchange Blvd, Suite 2501, Austin, TX 78721 | support@adventure-works.com';
      sheet.getRangeByIndex(26, 1).cellStyle.fontSize = 8;

      final Range range9 = sheet.getRangeByName('A26:H27');
      range9.cellStyle.backColor = '#ACB9CA';
      range9.merge();
      range9.cellStyle.hAlign = HAlignType.center;
      range9.cellStyle.vAlign = VAlignType.center;

      final Picture picture = sheet.pictures.addBase64(3, 4, invoicejpeg);
      picture.lastRow = 7;
      picture.lastColumn = 8;

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      saveAsExcel(bytes, 'Invoice.xlsx');
    });

    test('Balance Sheet', () {
      //Creating a workbook.
      final Workbook workbook = Workbook();
      //Accessing via index
      final Worksheet sheet = workbook.worksheets[0];
      sheet.name = 'Summary';
      sheet.showGridlines = false;
      final Worksheet sheet2 = workbook.worksheets.addWithName('Assets');
      sheet2.showGridlines = false;
      final Worksheet sheet3 = workbook.worksheets.addWithName('Liabilities');
      sheet3.showGridlines = false;
      final Worksheet sheet4 = workbook.worksheets.addWithName('Categories');
      sheet4.showGridlines = false;

      final List<Style> styles = balanceSheetStyles(workbook);

      sheet.enableSheetCalculations();
      sheet.getRangeByName('A1').columnWidth = 0.96;
      sheet.getRangeByIndex(2, 1).rowHeight = 30;
      sheet.getRangeByName('A3').rowHeight = 40;

      final Range range = sheet.getRangeByIndex(3, 2);
      range.setText('Balance Sheet');
      range.cellStyle = styles[0];
      range.columnWidth = 15.41;
      sheet.getRangeByIndex(1, 3).columnWidth = 15.41;

      sheet.getRangeByName('B5:C5').merge();
      sheet.getRangeByName('B6:C6').merge();
      sheet.getRangeByName('B7:C7').merge();
      sheet.getRangeByName('B8:C8').merge();
      sheet.getRangeByName('B9:C9').merge();
      sheet.getRangeByName('B10:C10').merge();
      sheet.getRangeByName('B11:C11').merge();
      sheet.getRangeByName('B12:C12').merge();
      sheet.getRangeByName('B13:C13').merge();
      sheet.getRangeByName('B14:C14').merge();

      sheet.getRangeByName('C3:E3').cellStyle = styles[0];

      Range range1 = sheet.getRangeByName('D4');
      range1.cellStyle = styles[5];
      range1.text = 'FY-2019';

      Range range2 = sheet.getRangeByName('E4');
      range2.cellStyle = styles[5];
      range2.text = 'FY-2019';

      sheet.getRangeByName('B5').text = 'Asset Type';
      sheet.getRangeByName('D5').text = 'Prior Year';
      sheet.getRangeByName('E5').text = 'Current Year';

      sheet.getRangeByName('B5:E5').cellStyle = styles[1];

      sheet.getRangeByName('B6').text = 'Current Asset';
      sheet.getRangeByName('B7').text = 'Fixed Assets';
      sheet.getRangeByName('B8').text = 'Other Assets';
      sheet.getRangeByName('B9').text = 'Current Liabilities';
      sheet.getRangeByName('B10').text = 'Long-term Liabilities';
      sheet.getRangeByName('B11').text = 'Owner Equity';

      sheet.getRangeByName('B6:E14').rowHeight = 20;
      sheet.getRangeByName('B6:E11').cellStyle = styles[2];

      sheet.getRangeByName('B12:C13').cellStyle = styles[3];
      sheet.getRangeByName('D12:E13').cellStyle = styles[8];
      sheet.getRangeByName('B12').text = 'Total Assets';
      sheet.getRangeByName('B13').text =
          'Total Liabilities & Stockholder Equity';

      sheet.getRangeByName('B14:C14').cellStyle = styles[4];
      sheet.getRangeByName('D14:E14').cellStyle = styles[9];
      sheet.getRangeByName('B14').text = 'Balance';

      sheet.getRangeByName('D4:E14').autoFitColumns();

      // Sheet2
      sheet2.getRangeByName('A1').columnWidth = 0.96;

      sheet2.getRangeByName('B1').text = 'Assets';
      sheet2.getRangeByName('B1:E1').cellStyle = styles[0];
      sheet2.getRangeByIndex(1, 2).columnWidth = 15.27;

      sheet2.getRangeByIndex(1, 3).columnWidth = 31.27;

      range1 = sheet2.getRangeByName('D2');
      range1.cellStyle = styles[5];
      range1.text = 'FY-2019';

      range2 = sheet2.getRangeByName('E2');
      range2.cellStyle = styles[5];
      range2.text = 'FY-2020';

      sheet2.getRangeByName('B3').text = 'Asset Type';
      sheet2.getRangeByName('C3').text = 'Description';
      sheet2.getRangeByName('D3').text = 'Prior Year';
      sheet2.getRangeByName('E3').text = 'Current Year';

      sheet2.getRangeByName('B3:E3').cellStyle = styles[1];

      sheet2.getRangeByName('B4:B7').text = 'Current Assets';
      sheet2.getRangeByName('B8:B12').text = 'Fixed Assets';
      sheet2.getRangeByIndex(13, 2).text = 'Other Assets';

      sheet2.getRangeByName('C4').text = 'Cash';
      sheet2.getRangeByName('C5').text = 'Investments';
      sheet2.getRangeByName('C6').text = 'Inventories';
      sheet2.getRangeByName('C7').text = 'Accounts receivable';
      sheet2.getRangeByName('C8').text = 'Pre-paid expenses';
      sheet2.getRangeByName('C9').text = 'Property and equipment';
      sheet2.getRangeByName('C10').text = 'Leasehold improvements';
      sheet2.getRangeByName('C11').text = 'Equity and other investments';
      sheet2.getRangeByName('C12').text =
          'Less accumulated depreciation (Negative Value)';
      sheet2.getRangeByName('C13').text = 'Charity';
      sheet2.getRangeByName('B4:E12').cellStyle = styles[2];
      sheet2.getRangeByName('B13:E13').cellStyle = styles[6];

      sheet2.getRangeByName('D4').number = 102100;
      sheet2.getRangeByName('D5').number = 10000;
      sheet2.getRangeByName('D6').number = 31000;
      sheet2.getRangeByName('D7').number = 40500;
      sheet2.getRangeByName('D8').number = 1500;
      sheet2.getRangeByName('D9').number = 381000;
      sheet2.getRangeByName('D10').number = 12000;
      sheet2.getRangeByName('D11').number = 20000;
      sheet2.getRangeByName('D12').number = -56000;
      sheet2.getRangeByName('D13').number = 10500;

      sheet2.getRangeByName('E4').number = 100000;
      sheet2.getRangeByName('E5').number = 10000;
      sheet2.getRangeByName('E6').number = 30000;
      sheet2.getRangeByName('E7').number = 40000;
      sheet2.getRangeByName('E8').number = 1500;
      sheet2.getRangeByName('E9').number = 324300;
      sheet2.getRangeByName('E10').number = 14000;
      sheet2.getRangeByName('E11').number = 21500;
      sheet2.getRangeByName('E12').number = -46500;
      sheet2.getRangeByName('E13').number = 4000;

      sheet2.getRangeByName('C3:C13').autoFitRows();
      sheet2.autoFitColumn(4);
      sheet2.autoFitColumn(5);

      // sheet3
      sheet3.getRangeByName('A1').columnWidth = 0.96;
      sheet3.getRangeByIndex(1, 3).columnWidth = 22.27;

      sheet3.getRangeByName('B1').text = 'Liabilities';
      sheet3.getRangeByName('B1:E1').cellStyle = styles[0];

      sheet3.autoFitColumn(2);

      range1 = sheet3.getRangeByName('D2');
      range1.cellStyle = styles[5];
      range1.text = 'FY-2019';

      range2 = sheet3.getRangeByName('E2');
      range2.cellStyle = styles[5];
      range2.text = 'FY-2020';

      sheet3.getRangeByName('B3').text = 'Liabilities Type';
      sheet3.getRangeByName('C3').text = 'Description';
      sheet3.getRangeByName('D3').text = 'Prior Year';
      sheet3.getRangeByName('E3').text = 'Current Year';

      sheet3.getRangeByName('B3:E3').cellStyle = styles[1];

      sheet3.getRangeByName('B4:E11').cellStyle = styles[2];
      sheet3.getRangeByName('B12:E12').cellStyle = styles[6];
      sheet3.getRangeByName('B4:B8').text = 'Current Liabilities';
      sheet3.getRangeByName('B9:B10').text = 'Long-term Liabilities';
      sheet3.getRangeByIndex(10, 2, 11, 2).text = 'Owner Equity';

      sheet3.getRangeByIndex(4, 3).text = 'Accounts payable';
      sheet3.getRangeByIndex(5, 3).text = 'Accrued wages';
      sheet3.getRangeByIndex(6, 3).text = 'Accrued compensation';
      sheet3.getRangeByIndex(7, 3).text = 'Income taxes payable';
      sheet3.getRangeByIndex(8, 3).text = 'Unearned revenue';
      sheet3.getRangeByIndex(9, 3).text = 'Notes Payable';
      sheet3.getRangeByIndex(10, 3).text = 'Bonds Payable';
      sheet3.getRangeByIndex(11, 3).text = 'Investment capital';
      sheet3.getRangeByIndex(12, 3).text = 'Accumulated retained earnings';

      sheet3.getRangeByName('D4').number = 35900;
      sheet3.getRangeByName('D5').number = 8500;
      sheet3.getRangeByName('D6').number = 7900;
      sheet3.getRangeByName('D7').number = 6100;
      sheet3.getRangeByName('D8').number = 1500;
      sheet3.getRangeByName('D9').number = 20000;
      sheet3.getRangeByName('D10').number = 400000;
      sheet3.getRangeByName('D11').number = 11000;
      sheet3.getRangeByName('D12').number = 22000;

      sheet3.getRangeByName('E4').number = 30000;
      sheet3.getRangeByName('E5').number = 6400;
      sheet3.getRangeByName('E6').number = 5000;
      sheet3.getRangeByName('E7').number = 5300;
      sheet3.getRangeByName('E8').number = 1700;
      sheet3.getRangeByName('E9').number = 22000;
      sheet3.getRangeByName('E10').number = 380100;
      sheet3.getRangeByName('E11').number = 12500;
      sheet3.getRangeByName('E12').number = 20700;

      sheet3.getRangeByName('C3:C12').autoFitRows();
      sheet3.autoFitColumn(4);
      sheet3.autoFitColumn(5);

      // sheet4
      sheet4.getRangeByName('A1').columnWidth = 0.96;

      sheet4.getRangeByName('B1').text = 'Categories';
      sheet4.getRangeByName('B1').cellStyle = styles[0];
      sheet4.getRangeByName('B1').columnWidth = 59.27;

      sheet4.getRangeByName('B3:B8').cellStyle = styles[7];
      sheet4.getRangeByIndex(3, 2).text = 'Current Assets';
      sheet4.getRangeByIndex(4, 2).text = 'Fixed Assets';
      sheet4.getRangeByIndex(5, 2).text = 'Other Assets';
      sheet4.getRangeByIndex(6, 2).text = 'Current Liabilities';
      sheet4.getRangeByIndex(7, 2).text = 'Long-term Liabilities';
      sheet4.getRangeByIndex(8, 2).text = 'Owner Equity';

      sheet.getRangeByIndex(6, 4).formula = r'=SUM(Assets!$D$4:$D$8)';
      sheet.getRangeByIndex(7, 4).formula = r'=SUM(Assets!$D$9:$D$12)';
      sheet.getRangeByIndex(8, 4).formula = r'=SUM(Assets!D13)';
      sheet.getRangeByIndex(9, 4).formula = r'=SUM(Liabilities!$D$4:$D$8)';
      sheet.getRangeByIndex(10, 4).formula = r'=SUM(Liabilities!$D$9:$D$10)';
      sheet.getRangeByIndex(11, 4).formula = r'=SUM(Liabilities!$D$11:$D$12)';
      sheet.getRangeByIndex(12, 4).formula =
          r'=SUM(SUM(Assets!$D$4:$D$8),SUM(Assets!$D$9:$D$12),SUM(Assets!$D$13))';
      sheet.getRangeByIndex(13, 4).formula =
          r'=SUM(SUM(Liabilities!$D$4:$D$8), SUM(Liabilities!$D$9:$D$10), SUM(Liabilities!$D$11:$D$12))';
      sheet.getRangeByIndex(14, 4).formula = '=D12-D13';

      sheet.getRangeByIndex(6, 5).formula = r'=SUM(Assets!$E$4:$E$8)';
      sheet.getRangeByIndex(7, 5).formula = r'=SUM(Assets!$E$9:$E$12)';
      sheet.getRangeByIndex(8, 5).formula = r'=SUM(Assets!E13)';
      sheet.getRangeByIndex(9, 5).formula = r'=SUM(Liabilities!$E$4:$E$8)';
      sheet.getRangeByIndex(10, 5).formula = r'=SUM(Liabilities!$E$9:$E$10)';
      sheet.getRangeByIndex(11, 5).formula = r'=SUM(Liabilities!$E$11:$E$12)';
      sheet.getRangeByIndex(12, 5).formula =
          r'=SUM(SUM(Assets!$E$4:$E$8),SUM(Assets!$E$9:$E$12),SUM(Assets!$E$13))';
      sheet.getRangeByIndex(13, 5).formula =
          r'=SUM(SUM(Liabilities!$E$4:$E$8), SUM(Liabilities!$E$9:$E$10), SUM(Liabilities!$E$11:$E$12))';
      sheet.getRangeByIndex(14, 5).formula = '=E12-E13';

      // sheet1 Image Hyperlink
      final Picture picture = sheet.pictures.addBase64(2, 2, assetspng);
      picture.height = 30;
      picture.width = 100;
      sheet.hyperlinks
          .addImage(picture, HyperlinkType.workbook, 'Assets!B1', 'Assets');

      final Picture picture1 = sheet.pictures.addBase64(2, 3, liabilitiespng);
      picture1.height = 30;
      picture1.width = 100;
      sheet.hyperlinks.addImage(
          picture1, HyperlinkType.workbook, 'Liabilities!B1', 'Liabilities');

      final Picture picture2 = sheet.pictures.addBase64(2, 4, categoriespng);
      picture2.height = 30;
      picture2.width = 100;
      sheet.hyperlinks.addImage(
          picture2, HyperlinkType.workbook, 'Categories!B1', 'Categories');

      sheet.protect('Syncfusion');
      ExcelSheetProtectionOption option = ExcelSheetProtectionOption();
      option.lockedCells = true;
      option.insertColumns = true;
      sheet2.protect('Syncfusion', option);
      option = ExcelSheetProtectionOption();
      option.formatCells = true;
      sheet3.protect('Syncfusion', option);
      sheet4.protect('Syncfusion');

      workbook.protect(true, true, 'Syncfusion');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'BalanceSheet.xlsx');
      workbook.dispose();
    });

    test('Attendances Tracker', () {
      //Creating a workbook.
      final Workbook workbook = Workbook();
      //Accessing via index
      final Worksheet sheet = workbook.worksheets[0];
      final DateTime datetime = DateTime.now().toLocal();
      final DateFormat formatter = DateFormat('MMM');
      sheet.name = '${formatter.format(datetime)}-${datetime.year}';

      // Enable sheet calculation.
      sheet.enableSheetCalculations();

      // Import data to sheet.
      final List<ExcelDataRow> dataRows = _buildAttendanceReportDataRows();
      sheet.importData(dataRows, 1, 1);

      // Insert column
      sheet.insertColumn(3, 5);

      sheet.getRangeByName('C1').setText('Present Count');
      sheet.getRangeByName('C2').setFormula("=COUNTIFS(H2:AL2,'P')");
      sheet.getRangeByName('C3').setFormula("=COUNTIFS(H3:AL3,'P')");
      sheet.getRangeByName('C4').setFormula("=COUNTIFS(H4:AL4,'P')");
      sheet.getRangeByName('C5').setFormula("=COUNTIFS(H5:AL5,'P')");
      sheet.getRangeByName('C6').setFormula("=COUNTIFS(H6:AL6,'P')");
      sheet.getRangeByName('C7').setFormula("=COUNTIFS(H7:AL7,'P')");
      sheet.getRangeByName('C8').setFormula("=COUNTIFS(H8:AL8,'P')");
      sheet.getRangeByName('C9').setFormula("=COUNTIFS(H9:AL9,'P')");
      sheet.getRangeByName('C10').setFormula("=COUNTIFS(H10:AL10,'P')");

      sheet.getRangeByName('D1').setText('Leave Count');
      sheet.getRangeByName('D2').setFormula("=COUNTIFS(H2:AL2,'L')");
      sheet.getRangeByName('D3').setFormula("=COUNTIFS(H3:AL3,'L')");
      sheet.getRangeByName('D4').setFormula("=COUNTIFS(H4:AL4,'L')");
      sheet.getRangeByName('D5').setFormula("=COUNTIFS(H5:AL5,'L')");
      sheet.getRangeByName('D6').setFormula("=COUNTIFS(H6:AL6,'L')");
      sheet.getRangeByName('D7').setFormula("=COUNTIFS(H7:AL7,'L')");
      sheet.getRangeByName('D8').setFormula("=COUNTIFS(H8:AL8,'L')");
      sheet.getRangeByName('D9').setFormula("=COUNTIFS(H9:AL9,'L')");
      sheet.getRangeByName('D10').setFormula("=COUNTIFS(H10:AL10,'L')");

      sheet.getRangeByName('E1').setText('Absent Count');
      sheet.getRangeByName('E2').setFormula("=COUNTIFS(H2:AL2,'A')");
      sheet.getRangeByName('E3').setFormula("=COUNTIFS(H3:AL3,'A')");
      sheet.getRangeByName('E4').setFormula("=COUNTIFS(H4:AL4,'A')");
      sheet.getRangeByName('E5').setFormula("=COUNTIFS(H5:AL5,'A')");
      sheet.getRangeByName('E6').setFormula("=COUNTIFS(H6:AL6,'A')");
      sheet.getRangeByName('E7').setFormula("=COUNTIFS(H7:AL7,'A')");
      sheet.getRangeByName('E8').setFormula("=COUNTIFS(H8:AL8,'A')");
      sheet.getRangeByName('E9').setFormula("=COUNTIFS(H9:AL9,'A')");
      sheet.getRangeByName('E10').setFormula("=COUNTIFS(H10:AL10,'A')");

      sheet.getRangeByName('F1').setText('Unplanned %');
      sheet.getRangeByName('F2').setFormula('=E2/(C2+D2+E2)');
      sheet.getRangeByName('F3').setFormula('=E3/(C3+D3+E3)');
      sheet.getRangeByName('F4').setFormula('=E4/(C4+D4+E4)');
      sheet.getRangeByName('F5').setFormula('=E5/(C5+D5+E5)');
      sheet.getRangeByName('F6').setFormula('=E6/(C6+D6+E6)');
      sheet.getRangeByName('F7').setFormula('=E7/(C7+D7+E7)');
      sheet.getRangeByName('F8').setFormula('=E8/(C8+D8+E8)');
      sheet.getRangeByName('F9').setFormula('=E9/(C9+D9+E9)');
      sheet.getRangeByName('F10').setFormula('=E10/(C10+D10+E10)');

      sheet.getRangeByName('G1').setText('Planned %');
      sheet.getRangeByName('G2').setFormula('=D2/(C2+D2+E2)');
      sheet.getRangeByName('G3').setFormula('=D3/(C3+D3+E3)');
      sheet.getRangeByName('G4').setFormula('=D4/(C4+D4+E4)');
      sheet.getRangeByName('G5').setFormula('=D5/(C5+D5+E5)');
      sheet.getRangeByName('G6').setFormula('=D6/(C6+D6+E6)');
      sheet.getRangeByName('G7').setFormula('=D7/(C7+D7+E7)');
      sheet.getRangeByName('G8').setFormula('=D8/(C8+D8+E8)');
      sheet.getRangeByName('G9').setFormula('=D9/(C9+D9+E9)');
      sheet.getRangeByName('G10').setFormula('=D10/(C10+D10+E10)');

      //Apply conditional Formatting.
      ConditionalFormats statusCondition =
          sheet.getRangeByName('H2:AL10').conditionalFormats;

      ConditionalFormat leaveCondition = statusCondition.addCondition();
      leaveCondition.formatType = ExcelCFType.cellValue;
      leaveCondition.operator = ExcelComparisonOperator.equal;
      leaveCondition.firstFormula = '"L"';
      leaveCondition.backColorRgb = const Color.fromARGB(255, 253, 167, 92);

      ConditionalFormat absentCondition = statusCondition.addCondition();
      absentCondition.formatType = ExcelCFType.cellValue;
      absentCondition.operator = ExcelComparisonOperator.equal;
      absentCondition.firstFormula = '"A"';
      absentCondition.backColorRgb = const Color.fromARGB(255, 255, 105, 124);

      ConditionalFormat presentCondition = statusCondition.addCondition();
      presentCondition.formatType = ExcelCFType.cellValue;
      presentCondition.operator = ExcelComparisonOperator.equal;
      presentCondition.firstFormula = '"P"';
      presentCondition.backColorRgb = const Color.fromARGB(255, 67, 233, 123);

      ConditionalFormat weekendCondition = statusCondition.addCondition();
      weekendCondition.formatType = ExcelCFType.cellValue;
      weekendCondition.operator = ExcelComparisonOperator.equal;
      weekendCondition.firstFormula = '"WE"';
      weekendCondition.backColorRgb = const Color.fromARGB(255, 240, 240, 240);

      final ConditionalFormats presentSummaryCF =
          sheet.getRangeByName('C2:C10').conditionalFormats;
      final ConditionalFormat presentCountCF = presentSummaryCF.addCondition();
      presentCountCF.formatType = ExcelCFType.dataBar;
      DataBar dataBar = presentCountCF.dataBar!;
      dataBar.barColorRgb = const Color.fromARGB(255, 61, 242, 142);

      final ConditionalFormats leaveSummaryCF =
          sheet.getRangeByName('D2:D10').conditionalFormats;
      final ConditionalFormat leaveCountCF = leaveSummaryCF.addCondition();
      leaveCountCF.formatType = ExcelCFType.dataBar;
      dataBar = leaveCountCF.dataBar!;
      dataBar.barColorRgb = const Color.fromARGB(255, 242, 71, 23);

      final ConditionalFormats absentSummaryCF =
          sheet.getRangeByName('E2:E10').conditionalFormats;
      final ConditionalFormat absentCountCF = absentSummaryCF.addCondition();
      absentCountCF.formatType = ExcelCFType.dataBar;
      dataBar = absentCountCF.dataBar!;
      dataBar.barColorRgb = const Color.fromARGB(255, 255, 10, 69);

      final ConditionalFormats unplannedSummaryCF =
          sheet.getRangeByName('F2:F10').conditionalFormats;
      final ConditionalFormat unplannedCountCF =
          unplannedSummaryCF.addCondition();
      unplannedCountCF.formatType = ExcelCFType.dataBar;
      dataBar = unplannedCountCF.dataBar!;
      dataBar.maxPoint.type = ConditionValueType.highestValue;
      dataBar.barColorRgb = const Color.fromARGB(255, 142, 142, 142);

      final ConditionalFormats plannedSummaryCF =
          sheet.getRangeByName('G2:G10').conditionalFormats;
      final ConditionalFormat plannedCountCF = plannedSummaryCF.addCondition();
      plannedCountCF.formatType = ExcelCFType.dataBar;
      dataBar = plannedCountCF.dataBar!;
      dataBar.maxPoint.type = ConditionValueType.highestValue;
      dataBar.barColorRgb = const Color.fromARGB(255, 56, 136, 254);

      statusCondition = sheet.getRangeByName('C12:C18').conditionalFormats;
      leaveCondition = statusCondition.addCondition();
      leaveCondition.formatType = ExcelCFType.cellValue;
      leaveCondition.operator = ExcelComparisonOperator.equal;
      leaveCondition.firstFormula = '"L"';
      leaveCondition.backColorRgb = const Color.fromARGB(255, 253, 167, 92);

      absentCondition = statusCondition.addCondition();
      absentCondition.formatType = ExcelCFType.cellValue;
      absentCondition.operator = ExcelComparisonOperator.equal;
      absentCondition.firstFormula = '"A"';
      absentCondition.backColorRgb = const Color.fromARGB(255, 255, 105, 124);

      presentCondition = statusCondition.addCondition();
      presentCondition.formatType = ExcelCFType.cellValue;
      presentCondition.operator = ExcelComparisonOperator.equal;
      presentCondition.firstFormula = '"P"';
      presentCondition.backColorRgb = const Color.fromARGB(255, 67, 233, 123);

      weekendCondition = statusCondition.addCondition();
      weekendCondition.formatType = ExcelCFType.cellValue;
      weekendCondition.operator = ExcelComparisonOperator.equal;
      weekendCondition.firstFormula = '"WE"';
      weekendCondition.backColorRgb = const Color.fromARGB(255, 240, 240, 240);

      sheet.getRangeByIndex(12, 3).setText('P');
      sheet.getRangeByIndex(14, 3).setText('L');
      sheet.getRangeByIndex(16, 3).setText('A');
      sheet.getRangeByIndex(18, 3).setText('WE');
      sheet.getRangeByIndex(12, 4).setText('Present');
      sheet.getRangeByIndex(14, 4).setText('Leave');
      sheet.getRangeByIndex(16, 4).setText('Absent');
      sheet.getRangeByIndex(18, 4).setText('Weekend');

      // Row height and column width.
      sheet.getRangeByName('A1:AL1').rowHeight = 24;
      sheet.getRangeByName('A2:AL10').rowHeight = 20;
      sheet.getRangeByName('A1:B1').columnWidth = 19.64;
      sheet.getRangeByName('C1:G1').columnWidth = 15.64;
      sheet.getRangeByName('H1:AL10').columnWidth = 3.64;
      sheet.getRangeByIndex(13, 1).rowHeight = 3.8;
      sheet.getRangeByIndex(15, 1).rowHeight = 3.8;
      sheet.getRangeByIndex(17, 1).rowHeight = 3.8;

      //Apply styles
      final Style style = workbook.styles.add('Style');
      style.fontSize = 12;
      style.fontColorRgb = const Color.fromARGB(255, 64, 64, 64);
      style.bold = true;
      style.borders.all.lineStyle = LineStyle.medium;
      style.borders.all.colorRgb = const Color.fromARGB(255, 195, 195, 195);
      style.vAlign = VAlignType.center;
      style.hAlign = HAlignType.left;

      sheet.getRangeByName('A1:AL10').cellStyle = style;

      sheet.getRangeByName('A1:AL1').cellStyle.backColorRgb =
          const Color.fromARGB(255, 58, 56, 56);
      sheet.getRangeByName('A1:AL1').cellStyle.fontColorRgb =
          const Color.fromARGB(255, 255, 255, 255);

      sheet.getRangeByName('C2:AL10').cellStyle.hAlign = HAlignType.center;
      sheet.getRangeByName('H1:AL1').cellStyle.hAlign = HAlignType.center;

      sheet.getRangeByName('A2:B10').cellStyle.indent = 1;
      sheet.getRangeByName('A1:G1').cellStyle.indent = 1;
      sheet.getRangeByName('H2:AL10').cellStyle.borders.all.colorRgb =
          const Color.fromARGB(255, 255, 255, 255);

      sheet.getRangeByName('F2:G10').numberFormat = '.00%';

      sheet.getRangeByName('C12:C18').cellStyle = style;
      sheet.getRangeByName('C12:C18').cellStyle.hAlign = HAlignType.center;
      sheet.getRangeByName('C12:C18').cellStyle.borders.all.lineStyle =
          LineStyle.none;

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AttendanceTracker.xlsx');
      workbook.dispose();
    });
    test('Table', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Products');
      sheet.getRangeByName('B1').setText('Qtr1');
      sheet.getRangeByName('C1').setText('Qtr2');
      sheet.getRangeByName('D1').setText('Qtr3');
      sheet.getRangeByName('E1').setText('Qtr4');

      sheet.getRangeByName('A2').setText('Alfreds Futterkiste');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('D2').setNumber(5079.6);
      sheet.getRangeByName('E2').setNumber(1249.2);

      sheet.getRangeByName('A3').setText('Antonio Moreno Taqueria');
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('D3').setNumber(943.89);
      sheet.getRangeByName('E3').setNumber(349.6);

      sheet.getRangeByName('A4').setText('Around the Horn');
      sheet.getRangeByName('B4').setNumber(1267.5);
      sheet.getRangeByName('C4').setNumber(1062.5);
      sheet.getRangeByName('D4').setNumber(744.6);
      sheet.getRangeByName('E4').setNumber(162.56);

      sheet.getRangeByName('A5').setText('Bon app');
      sheet.getRangeByName('B5').setNumber(1418);
      sheet.getRangeByName('C5').setNumber(756);
      sheet.getRangeByName('D5').setNumber(1267.5);
      sheet.getRangeByName('E5').setNumber(1062.5);

      sheet.getRangeByName('A6').setText('Eastern Connection');
      sheet.getRangeByName('B6').setNumber(4728);
      sheet.getRangeByName('C6').setNumber(4547.92);
      sheet.getRangeByName('D6').setNumber(1418);
      sheet.getRangeByName('E6').setNumber(756);

      sheet.getRangeByName('A7').setText('Ernst Handel');
      sheet.getRangeByName('B7').setNumber(943.89);
      sheet.getRangeByName('C7').setNumber(349.6);
      sheet.getRangeByName('D7').setNumber(4728);
      sheet.getRangeByName('E7').setNumber(4547.92);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:E7'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium9;

      table.showTotalRow = true;
      table.showFirstColumn = true;
      table.showBandedColumns = true;
      table.showBandedRows = true;
      table.columns[0].totalRowLabel = 'Total';
      table.columns[1].totalFormula = ExcelTableTotalFormula.sum;
      table.columns[2].totalFormula = ExcelTableTotalFormula.sum;
      table.columns[3].totalFormula = ExcelTableTotalFormula.sum;
      table.columns[4].totalFormula = ExcelTableTotalFormula.sum;

      final Range range = sheet.getRangeByName('B2:E8');
      range.numberFormat = r'_($* #,##0.00_)';

      sheet.getRangeByName('A1:E7').autoFitColumns();
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Table.xlsx');
      workbook.dispose();
    });
    test('DataValidation', () {
      //creates three worksheets and accessing the first sheet
      final Workbook workbook = Workbook(3);
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('B7').text =
          'Select an item from the validation list';
      sheet.getRangeByName('C7').cellStyle.borders.all.lineStyle =
          LineStyle.medium;
      //Accessing the cell Range C7 and applying the list properties
      final DataValidation listValidation =
          sheet.getRangeByName('C7').dataValidation;

      listValidation.listOfValues = <String>['PDF', 'XlsIO', 'DocIO'];
      listValidation.promptBoxText = 'Data Validation list';
      listValidation.showPromptBox = true;

      sheet.getRangeByName('B9').text = 'Enter a Number between 0 to 10';
      sheet.getRangeByName('C9').cellStyle.borders.all.lineStyle =
          LineStyle.medium;
      //Accessing the cell Range C9 and applying the integer properties
      final DataValidation integerValidation =
          sheet.getRangeByName('C9').dataValidation;
      integerValidation.allowType = ExcelDataValidationType.integer;
      integerValidation.comparisonOperator =
          ExcelDataValidationComparisonOperator.between;
      integerValidation.firstFormula = '0';
      integerValidation.secondFormula = '10';
      integerValidation.showErrorBox = true;
      integerValidation.errorBoxText = 'Enter Value between 0 to 10';
      integerValidation.errorBoxTitle = 'Error';
      integerValidation.promptBoxText =
          'Data Validation using Condition for Numbers';
      integerValidation.showPromptBox = true;

      sheet.getRangeByName('B11').text =
          'Enter the Date between 5/10/2003 to 5/10/2004';
      sheet.getRangeByName('C11').cellStyle.borders.all.lineStyle =
          LineStyle.medium;
      //Accessing the cell Range C11 and applying the date properties
      final DataValidation dateValidation =
          sheet.getRangeByName('C11').dataValidation;
      dateValidation.allowType = ExcelDataValidationType.date;
      dateValidation.comparisonOperator =
          ExcelDataValidationComparisonOperator.between;
      dateValidation.firstDateTime = DateTime(2003, 5, 10);
      dateValidation.secondDateTime = DateTime(2004, 5, 10);
      dateValidation.showErrorBox = true;
      dateValidation.errorBoxText =
          'Enter Value between 5/10/2003 to 5/10/2004 and in yyyy/mm/dd format or in mm/dd/yyyy format';
      dateValidation.errorBoxTitle = 'ERROR';
      dateValidation.promptBoxText = 'Data Validation using Condition for Date';
      dateValidation.showPromptBox = true;

      sheet.getRangeByName('B13').text = 'Enter the Text length between 1 to 6';
      sheet.getRangeByName('C13').cellStyle.borders.all.lineStyle =
          LineStyle.medium;
      //Accessing the cell Range C13 and applying the textLength properties
      final DataValidation textLengthValidation =
          sheet.getRangeByName('C13').dataValidation;
      textLengthValidation.allowType = ExcelDataValidationType.textLength;
      textLengthValidation.comparisonOperator =
          ExcelDataValidationComparisonOperator.between;
      textLengthValidation.firstFormula = '1';
      textLengthValidation.secondFormula = '6';
      textLengthValidation.showErrorBox = true;
      textLengthValidation.errorBoxText = 'Retype text length to 6 character';
      textLengthValidation.errorBoxTitle = 'ERROR';
      textLengthValidation.promptBoxText =
          'Data Validation using Condition for TextLength';
      textLengthValidation.showPromptBox = true;

      sheet.getRangeByName('B15').text =
          'Enter the Time between 10:00 to 12:00';
      sheet.getRangeByName('C15').cellStyle.borders.all.lineStyle =
          LineStyle.medium;
      //Accessing the cell Range C15 and applying the time properties
      final DataValidation timeValidation =
          sheet.getRangeByName('C15').dataValidation;
      timeValidation.allowType = ExcelDataValidationType.time;
      timeValidation.comparisonOperator =
          ExcelDataValidationComparisonOperator.between;
      timeValidation.firstFormula = '10:00';
      timeValidation.secondFormula = '12:00';
      timeValidation.showErrorBox = true;
      timeValidation.errorBoxText = 'Enter the time between 10:00 to 12:00';
      timeValidation.errorBoxTitle = 'ERROR';
      timeValidation.promptBoxText = 'Data Validation using Condition for Time';
      timeValidation.showPromptBox = true;

      sheet.getRangeByName('B2:C2').merge();
      sheet.getRangeByName('B2').text = 'Simple Data validation';
      sheet.getRangeByName('B5').text = 'Validation criteria';
      sheet.getRangeByName('C5').text = 'Validation';
      sheet.getRangeByName('B5').cellStyle.bold = true;
      sheet.getRangeByName('C5').cellStyle.bold = true;
      sheet.getRangeByName('B2').cellStyle.bold = true;
      sheet.getRangeByName('B2').cellStyle.fontSize = 16;
      sheet.getRangeByName('B2').cellStyle.hAlign = HAlignType.center;
      sheet.getRangeByName('A1:C15').autoFit();

      //Save and dispose Workbook
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'DataValidation.xlsx');
      workbook.dispose();
    });
  });
}

List<ExcelDataRow> _buildAttendanceReportDataRows() {
  List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
  final List<_Attendance> reports = _getAttendanceReports();

  excelDataRows = reports.map<ExcelDataRow>((_Attendance dataRow) {
    return ExcelDataRow(cells: <ExcelDataCell>[
      ExcelDataCell(columnHeader: 'Employee Name', value: dataRow.employeeName),
      ExcelDataCell(columnHeader: 'Supervisor', value: dataRow.supervisor),
      ExcelDataCell(columnHeader: 1, value: dataRow.day1),
      ExcelDataCell(columnHeader: 2, value: dataRow.day2),
      ExcelDataCell(columnHeader: 3, value: dataRow.day3),
      ExcelDataCell(columnHeader: 4, value: dataRow.day4),
      ExcelDataCell(columnHeader: 5, value: dataRow.day5),
      ExcelDataCell(columnHeader: 6, value: dataRow.day6),
      ExcelDataCell(columnHeader: 7, value: dataRow.day7),
      ExcelDataCell(columnHeader: 8, value: dataRow.day8),
      ExcelDataCell(columnHeader: 9, value: dataRow.day9),
      ExcelDataCell(columnHeader: 10, value: dataRow.day10),
      ExcelDataCell(columnHeader: 11, value: dataRow.day11),
      ExcelDataCell(columnHeader: 12, value: dataRow.day12),
      ExcelDataCell(columnHeader: 13, value: dataRow.day13),
      ExcelDataCell(columnHeader: 14, value: dataRow.day14),
      ExcelDataCell(columnHeader: 15, value: dataRow.day15),
      ExcelDataCell(columnHeader: 16, value: dataRow.day16),
      ExcelDataCell(columnHeader: 17, value: dataRow.day17),
      ExcelDataCell(columnHeader: 18, value: dataRow.day18),
      ExcelDataCell(columnHeader: 19, value: dataRow.day19),
      ExcelDataCell(columnHeader: 20, value: dataRow.day20),
      ExcelDataCell(columnHeader: 21, value: dataRow.day21),
      ExcelDataCell(columnHeader: 22, value: dataRow.day22),
      ExcelDataCell(columnHeader: 23, value: dataRow.day23),
      ExcelDataCell(columnHeader: 24, value: dataRow.day24),
      ExcelDataCell(columnHeader: 25, value: dataRow.day25),
      ExcelDataCell(columnHeader: 26, value: dataRow.day26),
      ExcelDataCell(columnHeader: 27, value: dataRow.day27),
      ExcelDataCell(columnHeader: 28, value: dataRow.day28),
      ExcelDataCell(columnHeader: 29, value: dataRow.day29),
      ExcelDataCell(columnHeader: 30, value: dataRow.day30),
      ExcelDataCell(columnHeader: 31, value: dataRow.day31),
    ]);
  }).toList();

  return excelDataRows;
}

List<_Attendance> _getAttendanceReports() {
  final List<_Attendance> reports = <_Attendance>[];
  reports.add(_Attendance(
      'Maria Anders',
      'Michael Holz',
      'P',
      'P',
      'P',
      'P',
      'WE',
      'WE',
      'P',
      'A',
      'P',
      'A',
      'A',
      'WE',
      'WE',
      'P',
      'P',
      'P',
      'P',
      'A',
      'WE',
      'WE',
      'P',
      'P',
      'L',
      'A',
      'L',
      'WE',
      'WE',
      'P',
      'P',
      'A',
      'L'));
  reports.add(_Attendance(
      'Ana Trujillo',
      'Michael Holz',
      'P',
      'P',
      'P',
      'L',
      'WE',
      'WE',
      'P',
      'P',
      'P',
      'P',
      'A',
      'WE',
      'WE',
      'P',
      'P',
      'L',
      'L',
      'P',
      'WE',
      'WE',
      'P',
      'P',
      'P',
      'P',
      'L',
      'WE',
      'WE',
      'P',
      'P',
      'L',
      'P'));
  reports.add(_Attendance(
      'Antonio Moreno',
      'Liz Nixon',
      'A',
      'P',
      'L',
      'L',
      'WE',
      'WE',
      'P',
      'A',
      'A',
      'P',
      'L',
      'WE',
      'WE',
      'A',
      'P',
      'L',
      'A',
      'P',
      'WE',
      'WE',
      'P',
      'L',
      'L',
      'P',
      'P',
      'WE',
      'WE',
      'L',
      'P',
      'A',
      'A'));
  reports.add(_Attendance(
      'Thomas Hardy',
      'Liu Wong',
      'L',
      'A',
      'L',
      'p',
      'WE',
      'WE',
      'P',
      'A',
      'A',
      'P',
      'A',
      'WE',
      'WE',
      'A',
      'P',
      'P',
      'L',
      'P',
      'WE',
      'WE',
      'P',
      'P',
      'P',
      'L',
      'P',
      'WE',
      'WE',
      'L',
      'A',
      'P',
      'P'));
  reports.add(_Attendance(
      'Christina Berglund',
      'Mary Saveley',
      'P',
      'P',
      'P',
      'L',
      'WE',
      'WE',
      'P',
      'P',
      'P',
      'P',
      'P',
      'WE',
      'WE',
      'A',
      'P',
      'P',
      'L',
      'P',
      'WE',
      'WE',
      'A',
      'A',
      'P',
      'P',
      'P',
      'WE',
      'WE',
      'A',
      'A',
      'P',
      'P'));
  reports.add(_Attendance(
      'Hanna Moos',
      'Liu Wong',
      'L',
      'P',
      'P',
      'A',
      'WE',
      'WE',
      'P',
      'P',
      'A',
      'P',
      'L',
      'WE',
      'WE',
      'A',
      'P',
      'P',
      'L',
      'P',
      'WE',
      'WE',
      'A',
      'P',
      'P',
      'P',
      'L',
      'WE',
      'WE',
      'P',
      'L',
      'L',
      'P'));
  reports.add(_Attendance(
      'Frederique Citeaux',
      'Mary Saveley',
      'A',
      'A',
      'A',
      'P',
      'WE',
      'WE',
      'A',
      'P',
      'L',
      'A',
      'P',
      'WE',
      'WE',
      'P',
      'P',
      'L',
      'P',
      'P',
      'WE',
      'WE',
      'A',
      'A',
      'P',
      'P',
      'L',
      'WE',
      'WE',
      'L',
      'P',
      'A',
      'A'));
  reports.add(_Attendance(
      'Martin Sommer',
      'Michael Holz',
      'L',
      'P',
      'L',
      'A',
      'WE',
      'WE',
      'P',
      'L',
      'P',
      'L',
      'A',
      'WE',
      'WE',
      'A',
      'P',
      'P',
      'A',
      'P',
      'WE',
      'WE',
      'A',
      'P',
      'A',
      'P',
      'L',
      'WE',
      'WE',
      'A',
      'L',
      'L',
      'L'));
  reports.add(_Attendance(
      'Laurence Lebihan',
      'Mary Saveley',
      'P',
      'P',
      'P',
      'P',
      'WE',
      'WE',
      'P',
      'P',
      'P',
      'P',
      'P',
      'WE',
      'WE',
      'A',
      'P',
      'P',
      'P',
      'P',
      'WE',
      'WE',
      'A',
      'P',
      'P',
      'P',
      'A',
      'WE',
      'WE',
      'L',
      'P',
      'P',
      'P'));
  return reports;
}

class _Attendance {
  _Attendance(
      this.employeeName,
      this.supervisor,
      this.day1,
      this.day2,
      this.day3,
      this.day4,
      this.day5,
      this.day6,
      this.day7,
      this.day8,
      this.day9,
      this.day10,
      this.day11,
      this.day12,
      this.day13,
      this.day14,
      this.day15,
      this.day16,
      this.day17,
      this.day18,
      this.day19,
      this.day20,
      this.day21,
      this.day22,
      this.day23,
      this.day24,
      this.day25,
      this.day26,
      this.day27,
      this.day28,
      this.day29,
      this.day30,
      this.day31);
  late String employeeName;
  late String supervisor;
  late String day1;
  late String day2;
  late String day3;
  late String day4;
  late String day5;
  late String day6;
  late String day7;
  late String day8;
  late String day9;
  late String day10;
  late String day11;
  late String day12;
  late String day13;
  late String day14;
  late String day15;
  late String day16;
  late String day17;
  late String day18;
  late String day19;
  late String day20;
  late String day21;
  late String day22;
  late String day23;
  late String day24;
  late String day25;
  late String day26;
  late String day27;
  late String day28;
  late String day29;
  late String day30;
  late String day31;
}
