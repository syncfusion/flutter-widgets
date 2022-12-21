// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioFormulas() {
  group('formula', () {
    test('range', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).number = 10;
      final Range range1 = sheet.getRangeByIndex(1, 2);
      range1.formula = '=A1';
      final Range range2 = sheet.getRangeByIndex(1, 3);
      range2.formula = '=B1';
      final Range range3 = sheet.getRangeByIndex(1, 4);
      range3.formula = r'=$C1';
      sheet.enableSheetCalculations();
      expect('10.0', range3.calculatedValue);
      expect('10.0', range3.calculatedValue);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelFormula_1.xlsx');
      workbook.dispose();
    });

    test('operators', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
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
      expect('10.0', range.calculatedValue);
      range = sheet.getRangeByName('A7');
      range.formula = '=C1*B1';
      expect('240.0', range.calculatedValue);
      range = sheet.getRangeByName('A8');
      range.formula = '=B3/B2';
      expect(range.calculatedValue, '1.2093023255813953');
      range = sheet.getRangeByName('A9');
      range.formula = '=B2>A1';
      expect('TRUE', range.calculatedValue);
      range = sheet.getRangeByName('A10');
      range.formula = '=B3<A2';
      expect('FALSE', range.calculatedValue);
      range = sheet.getRangeByName('A11');
      range.formula = '=C1>=A3';
      expect('FALSE', range.calculatedValue);
      range = sheet.getRangeByName('B6');
      range.formula = '=C3<=A4';
      expect('FALSE', range.calculatedValue);
      range = sheet.getRangeByName('B7');
      range.formula = '=C3=A2';
      expect('TRUE', range.calculatedValue);
      range = sheet.getRangeByName('B8');
      range.formula = '=A2<>B2';
      expect('TRUE', range.calculatedValue);
      range = sheet.getRangeByName('B9');
      range.formula = '=-A1';
      expect('-10.0', range.calculatedValue);
      range = sheet.getRangeByName('B10');
      range.formula = '=B4^3';
      expect('421875.0', range.calculatedValue);
      range = sheet.getRangeByName('B11');
      range.formula = '=(A1+B1)*(B1-A1)';
      expect('300.0', range.calculatedValue);
      range = sheet.getRangeByName('B12');
      range.formula = '=A1&" "&B1';
      expect('10.0 20.0', range.calculatedValue);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelOperators.xlsx');
      workbook.dispose();
    });

    test('date final Range formula', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.enableSheetCalculations();
      sheet.getRangeByName('A1').dateTime = DateTime(2020, 9, 4, 8, 15, 20);
      final Range range = sheet.getRangeByName('B1');
      range.formula = '=A1';
      expect('44078.343981481485', range.calculatedValue);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelDateRange.xlsx');
      workbook.dispose();
    });

    test('range addition', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).number = 10;
      sheet.getRangeByIndex(2, 1).number = 20;
      final Range range = sheet.getRangeByIndex(3, 1);
      range.formula = '=A1+A2';
      sheet.enableSheetCalculations();
      expect('30.0', range.calculatedValue);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelFormula_2.xlsx');
      workbook.dispose();
    });

    test('range addition 2', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).number = 10;
      sheet.getRangeByIndex(2, 1).number = 20;
      final Range range = sheet.getRangeByIndex(3, 1);
      range.formula = '= A1 + A2';
      sheet.enableSheetCalculations();
      expect('30.0', range.calculatedValue);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelFormula_3.xlsx');
      workbook.dispose();
    });

    test('sum', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet2 = workbook.worksheets.add();
      sheet.getRangeByName('A1').number = 2;
      sheet.getRangeByName('B1').number = 3;
      sheet.getRangeByName('A2').number = 5;
      sheet.getRangeByName('B2').number = 4;
      sheet.getRangeByName('A3').number = 6;
      sheet.getRangeByName('B3').number = 7;
      sheet.getRangeByName('A4').number = 9;
      sheet.getRangeByName('B4').number = 8;

      sheet.enableSheetCalculations();
      Range range = sheet.getRangeByName('A7');
      range.formula = '=SUM(A1:A4,B1:B4)';
      expect(range.calculatedValue, '44.0');
      range = sheet.getRangeByName('A8');
      range.formula = 'SUM(A1,B1)';
      expect(range.calculatedValue, '5.0');

      range = sheet2.getRangeByName('A1');
      range.formula = '=SUM(Sheet1!A1:A4,Sheet1!B1:B4)';
      expect(range.calculatedValue, '44.0');
      range = sheet2.getRangeByName('A2');
      range.formula = '=SUM(Sheet1!A1:Sheet1!A4,Sheet1!B1:Sheet1!B4)';
      expect(range.calculatedValue, '44.0');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSumFormula.xlsx');
      workbook.dispose();
    });

    test('average', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').number = 2;
      sheet.getRangeByName('B1').number = 3;
      sheet.getRangeByName('A2').number = 5;
      sheet.getRangeByName('B2').number = 4;
      sheet.getRangeByName('A3').number = 6;
      sheet.getRangeByName('B3').number = 7;
      sheet.getRangeByName('A4').number = 9;
      sheet.getRangeByName('B4').number = 8;

      sheet.enableSheetCalculations();
      Range range = sheet.getRangeByName('A8');
      range.formula = '=AVERAGE(A1:A4,B1:B4)';
      expect(range.calculatedValue, '5.5');
      range = sheet.getRangeByName('A9');
      range.formula = '=AVERAGE(A1,B1)';
      expect(range.calculatedValue, '2.5');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelAverageFormula.xlsx');
      workbook.dispose();
    });

    test('max', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').number = 2;
      sheet.getRangeByName('B1').number = 3;
      sheet.getRangeByName('A2').number = 5;
      sheet.getRangeByName('B2').number = 4;
      sheet.getRangeByName('A3').number = 6;
      sheet.getRangeByName('B3').number = 7;
      sheet.getRangeByName('A4').number = 9;
      sheet.getRangeByName('B4').number = 8;

      sheet.enableSheetCalculations();
      Range range = sheet.getRangeByName('A8');
      range.formula = '=MAX(A1:A4,B1:B4)';
      expect(range.calculatedValue, '9.0');
      range = sheet.getRangeByName('A9');
      range.formula = '=MAX(A1,B1)';
      expect(range.calculatedValue, '3.0');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMaxFormula.xlsx');
      workbook.dispose();
    });

    test('min', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').number = 2;
      sheet.getRangeByName('B1').number = 3;
      sheet.getRangeByName('A2').number = 5;
      sheet.getRangeByName('B2').number = 4;
      sheet.getRangeByName('A3').number = 6;
      sheet.getRangeByName('B3').number = 7;
      sheet.getRangeByName('A4').number = 9;
      sheet.getRangeByName('B4').number = 8;

      sheet.enableSheetCalculations();
      Range range = sheet.getRangeByName('A8');
      range.formula = '=MIN(A1:A4,B1:B4)';
      expect(range.calculatedValue, '2.0');
      range = sheet.getRangeByName('A9');
      range.formula = '=MIN(A1,B1)';
      expect(range.calculatedValue, '2.0');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMinFormula.xlsx');
      workbook.dispose();
    });

    test('count', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').number = 2;
      sheet.getRangeByName('B1').number = 3;
      sheet.getRangeByName('A2').number = 5;
      sheet.getRangeByName('B2').number = 4;
      sheet.getRangeByName('A3').number = 6;
      sheet.getRangeByName('B3').number = 7;
      sheet.getRangeByName('A4').number = 9;
      sheet.getRangeByName('B4').number = 8;

      sheet.enableSheetCalculations();
      Range range = sheet.getRangeByName('A8');
      range.formula = '=COUNT(A1:A4,B1:B4)';
      expect(range.calculatedValue, '8');
      range = sheet.getRangeByName('A9');
      range.formula = '=COUNT(A1,B1)';
      expect(range.calculatedValue, '2');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCountFormula.xlsx');
      workbook.dispose();
    });

    test('If', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').number = 2;
      sheet.getRangeByName('B1').number = 3;
      sheet.getRangeByName('A2').number = 5;
      sheet.getRangeByName('B2').number = 4;
      sheet.getRangeByName('A3').number = 6;
      sheet.getRangeByName('B3').number = 7;
      sheet.getRangeByName('A4').number = 9;
      sheet.getRangeByName('B4').number = 8;

      sheet.enableSheetCalculations();
      Range range = sheet.getRangeByName('A7');
      range.formula = '=IF(A4 > B3, "Yes", "No")';
      expect(range.calculatedValue, 'Yes');
      range = sheet.getRangeByName('A8');
      range.formula = '=IF(A4 < B3, "Yes", "No")';
      expect(range.calculatedValue, 'No');
      range = sheet.getRangeByName('A9');
      range.formula = '=IF(A6 > B6, "Yes", "No")';
      expect(range.calculatedValue, 'No');
      range = sheet.getRangeByName('A10');
      range.formula = '=IF(A6 < B6, "Yes", "No")';
      expect(range.calculatedValue, 'No');
      range = sheet.getRangeByName('A11');
      range.formula = '=IF(A4 > B3, A1, B1)';
      expect(range.calculatedValue, '2.0');
      range = sheet.getRangeByName('A12');
      range.formula = '=IF(A4 < B3, A1, B1)';
      expect(range.calculatedValue, '3.0');
      range = sheet.getRangeByName('A13');
      range.formula = '=IF(A4 > B3, A20, B20)';
      expect(range.calculatedValue, '');
      range = sheet.getRangeByName('A14');
      range.formula = '=IF(A4 < B3, A20, B20)';
      expect(range.calculatedValue, '');
      range = sheet.getRangeByName('A15');
      range.formula = '=IF(A4 > B3,,)';
      expect(range.calculatedValue, '0');
      range = sheet.getRangeByName('A16');
      range.formula = '=IF(0,0)';
      expect(range.calculatedValue, 'FALSE');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelIFFormula.xlsx');
      workbook.dispose();
    });

    test('formula with sheet', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet2 = workbook.worksheets.add();
      final Worksheet sheet3 = workbook.worksheets.add();
      sheet.getRangeByIndex(1, 1).number = 10;
      sheet.getRangeByIndex(1, 2).number = 20;
      sheet.enableSheetCalculations();

      sheet2.getRangeByIndex(1, 1).formula = '=Sheet1!A1+Sheet1!B1';
      sheet2.getRangeByIndex(1, 2).formula = '=Sheet1!A1-Sheet1!B1';
      sheet2.getRangeByIndex(1, 3).formula = '=Sheet1!A1*Sheet1!B1';
      sheet2.getRangeByIndex(1, 4).formula = '=Sheet1!A1/Sheet1!B1';

      final Range range1 = sheet3.getRangeByIndex(1, 1);
      range1.formula = '=Sheet2!A1';
      final Range range2 = sheet3.getRangeByIndex(1, 2);
      range2.formula = '=Sheet2!B1';
      final Range range3 = sheet3.getRangeByIndex(1, 3);
      range3.formula = '=Sheet2!C1';
      final Range range4 = sheet3.getRangeByIndex(1, 4);
      range4.formula = '=Sheet2!D1';
      final Range range5 = sheet3.getRangeByIndex(1, 5);
      range5.formula = '=SUM(Sheet2!A1:A2)';

      expect(range1.calculatedValue, '30.0');
      expect(range2.calculatedValue, '-10.0');
      expect(range3.calculatedValue, '200.0');
      expect(range4.calculatedValue, '0.5');
      expect(range5.calculatedValue, '30.0');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSheetFormula.xlsx');
      workbook.dispose();
    });

    test('formula with error cases 1', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet2 = workbook.worksheets.add();
      sheet.getRangeByIndex(1, 1).number = 10;
      sheet.getRangeByIndex(1, 2).number = 20;
      sheet.getRangeByIndex(1, 3).text = '11/12/2010';
      sheet.getRangeByIndex(1, 4).text = '11:30:07 PM';
      sheet.enableSheetCalculations();

      final Range range1 = sheet2.getRangeByIndex(1, 1);
      range1.formula = '=Sheet1!"A1+Sheet1!"B1"';
      final Range range2 = sheet2.getRangeByIndex(1, 2);
      range2.formula = '=Sheet1!C1';
      final Range range3 = sheet2.getRangeByIndex(1, 3);
      range3.formula = '=Sheet1!D1';
      final Range range4 = sheet2.getRangeByIndex(1, 4);
      range4.formula = '=Sheet1!A2A';
      final Range range5 = sheet2.getRangeByIndex(1, 5);
      range5.formula = '=Sheet1!A1:D1';
      final Range range6 = sheet2.getRangeByIndex(1, 6);
      range6.formula = '=Sheet1!D1:A1';
      final Range range7 = sheet2.getRangeByIndex(1, 7);
      range7.formula = '=Sheet1!12:12';
      final Range range8 = sheet2.getRangeByIndex(1, 8);
      range8.formula = '"Formula"';
      final Range range9 = sheet2.getRangeByIndex(1, 9);
      range9.formula = 'TRUE';
      final Range range10 = sheet2.getRangeByIndex(1, 10);
      range10.formula = 'FALSE';

      expect(range1.calculatedValue, 'Exception: mismatched string quotes');
      expect(range2.calculatedValue, '11/12/2010');
      expect(range3.calculatedValue, '11:30:07 PM');
      expect(range4.calculatedValue, 'Exception: mismatched string quotes');
      expect(range5.calculatedValue, 'Exception: #NAME?');
      expect(range6.calculatedValue, 'Exception: #NAME?');
      expect(range7.calculatedValue, '0');
      expect(range8.calculatedValue, 'Formula');
      expect(range9.calculatedValue, 'TRUE');
      expect(range10.calculatedValue, 'FALSE');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelFormula_4.xlsx');
      workbook.dispose();
    });

    test('formula with error cases 3', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByIndex(1, 1).number = 10;
      sheet.getRangeByIndex(1, 2).number = 20;
      sheet.getRangeByIndex(1, 3).text = 'Text1';
      sheet.getRangeByIndex(1, 4).text = 'Text2';
      sheet.enableSheetCalculations();

      final Range range1 = sheet.getRangeByIndex(2, 1);
      range1.formula = '=A1/F5';
      final Range range2 = sheet.getRangeByIndex(2, 2);
      range2.formula = '=B1+D1';
      final Range range3 = sheet.getRangeByIndex(2, 3);
      range3.formula = '=#REF!+#REF!';
      final Range range4 = sheet.getRangeByIndex(2, 4);
      range4.formula = '=SUM(A1 A2)';
      final Range range5 = sheet.getRangeByIndex(2, 5);
      range5.formula = '=Sheet2!D1';

      expect(range1.calculatedValue, '#DIV/0!');
      expect(range2.calculatedValue, 'Exception: #VALUE!');
      expect(range3.calculatedValue, '#VALUE!');
      expect(range4.calculatedValue, '10.0');
      expect(range5.calculatedValue, '#REF!');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelFormula_6.xlsx');
      workbook.dispose();
    });

    test('formula with error cases 4', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.enableSheetCalculations();

      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.formula = '=#N/A';
      final Range range2 = sheet.getRangeByIndex(1, 2);
      range2.formula = '=#VALUE!';
      final Range range3 = sheet.getRangeByIndex(1, 3);
      range3.formula = '=#REF!';
      final Range range4 = sheet.getRangeByIndex(1, 4);
      range4.formula = '=#DIV/0!';
      final Range range5 = sheet.getRangeByIndex(1, 5);
      range5.formula = '=#NUM!';
      final Range range6 = sheet.getRangeByIndex(1, 6);
      range6.formula = '=#NAME?';
      final Range range7 = sheet.getRangeByIndex(1, 7);
      range7.formula = '=#NULL!';

      expect(range1.calculatedValue, '#N/A');
      expect(range2.calculatedValue, '#VALUE!');
      expect(range3.calculatedValue, '#REF!');
      expect(range4.calculatedValue, '#DIV/0!');
      expect(range5.calculatedValue, '#NUM!');
      expect(range6.calculatedValue, '#NAME?');
      expect(range7.calculatedValue, '#NULL!');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelFormula_7.xlsx');
      workbook.dispose();
    });

    test('formula with operators 1', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.enableSheetCalculations();

      final Range range1 = sheet.getRangeByName('A1');
      range1.formula = '=NAN+1';
      final Range range2 = sheet.getRangeByName('B1');
      range2.formula = '=TRUE+1';
      final Range range3 = sheet.getRangeByName('C1');
      range3.formula = '=FALSE+2';
      final Range range4 = sheet.getRangeByName('D1');
      range4.formula = '="10">"20"';
      final Range range5 = sheet.getRangeByName('E1');
      range5.formula = '="10"<"20"';
      final Range range6 = sheet.getRangeByName('F1');
      range6.formula = '="10">="20"';
      final Range range7 = sheet.getRangeByName('G1');
      range7.formula = '="10"<="20"';
      final Range range8 = sheet.getRangeByName('H1');
      range8.formula = '="10"="20"';
      final Range range9 = sheet.getRangeByName('I1');
      range9.formula = '="10"<>"20"';
      final Range range10 = sheet.getRangeByName('J1');
      range10.formula = '="Apple">"Ball"';
      final Range range11 = sheet.getRangeByName('K1');
      range11.formula = '="Apple"<"Ball"';
      final Range range12 = sheet.getRangeByName('L1');
      range12.formula = '="Apple">="Ball"';
      final Range range13 = sheet.getRangeByName('M1');
      range13.formula = '="Apple"<="Ball"';
      final Range range14 = sheet.getRangeByName('N1');
      range14.formula = '="Apple"="Ball"';
      final Range range15 = sheet.getRangeByName('O1');
      range15.formula = '="Apple"<>"Ball"';

      expect(range1.calculatedValue, '#NAME?');
      expect(range2.calculatedValue, '2.0');
      expect(range3.calculatedValue, '2.0');
      expect(range4.calculatedValue, 'FALSE');
      expect(range5.calculatedValue, 'TRUE');
      expect(range6.calculatedValue, 'FALSE');
      expect(range7.calculatedValue, 'FALSE');
      expect(range8.calculatedValue, 'FALSE');
      expect(range9.calculatedValue, 'TRUE');
      expect(range10.calculatedValue, 'FALSE');
      expect(range11.calculatedValue, 'TRUE');
      expect(range12.calculatedValue, 'FALSE');
      expect(range13.calculatedValue, 'FALSE');
      expect(range14.calculatedValue, 'FALSE');
      expect(range15.calculatedValue, 'TRUE');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelFormula_8.xlsx');
      workbook.dispose();
    });

    test('formula with operators 2', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.enableSheetCalculations();

      sheet.getRangeByName('A5').number = 10;
      sheet.getRangeByName('A6').number = 20;
      sheet.getRangeByName('B5').number = 30;
      sheet.getRangeByName('B6').number = 40;

      final Range range1 = sheet.getRangeByName('A1');
      range1.formula = '=10>"20"';
      final Range range2 = sheet.getRangeByName('B1');
      range2.formula = '="10">20';
      final Range range3 = sheet.getRangeByName('C1');
      range3.formula = '=10<"20"';
      final Range range4 = sheet.getRangeByName('D1');
      range4.formula = '="10"<20';
      final Range range5 = sheet.getRangeByName('E1');
      range5.formula = '=10>="20"';
      final Range range6 = sheet.getRangeByName('F1');
      range6.formula = '="10">=20';
      final Range range7 = sheet.getRangeByName('G1');
      range7.formula = '=10<="20"';
      final Range range8 = sheet.getRangeByName('H1');
      range8.formula = '="10"<=20';
      final Range range9 = sheet.getRangeByName('I1');
      range9.formula = '=10="20"';
      final Range range10 = sheet.getRangeByName('J1');
      range10.formula = '="10"=20';
      final Range range11 = sheet.getRangeByName('K1');
      range11.formula = '=10<>"20"';
      final Range range12 = sheet.getRangeByName('L1');
      range12.formula = '="10"<>"20"';
      final Range range13 = sheet.getRangeByName('M1');
      range13.formula = '="Apple"<>"Ball"';
      final Range range14 = sheet.getRangeByName('N1');
      range14.formula = '=A5:B5+A6:B6';
      final Range range15 = sheet.getRangeByName('O1');
      range15.formula = '=Sheet1!A5:B5+Sheet1!A6:B6';
      final Range range16 = sheet.getRangeByName('P1');
      range16.formula = '=(A5:B5)+(A6:B6)';

      expect(range1.calculatedValue, 'FALSE');
      expect(range2.calculatedValue, 'TRUE');
      expect(range3.calculatedValue, 'TRUE');
      expect(range4.calculatedValue, 'FALSE');
      expect(range5.calculatedValue, 'FALSE');
      expect(range6.calculatedValue, 'TRUE');
      expect(range7.calculatedValue, 'TRUE');
      expect(range8.calculatedValue, 'FALSE');
      expect(range9.calculatedValue, 'FALSE');
      expect(range10.calculatedValue, 'FALSE');
      expect(range11.calculatedValue, 'TRUE');
      expect(range12.calculatedValue, 'TRUE');
      expect(range13.calculatedValue, 'TRUE');
      expect(range14.calculatedValue, 'Exception: #NAME?');
      expect(range15.calculatedValue, 'Exception: #NAME?');
      expect(range16.calculatedValue, 'Exception: #NAME?');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelFormula_9.xlsx');
      workbook.dispose();
    });
    test('get() for Multiple range', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1:A4');
      range.setNumber(10);

      // Multiple final Range for Formula
      final Range range3 = sheet.getRangeByName('E1:E4');
      range3.formula = '=A1+A2';
      sheet.enableSheetCalculations();
      expect(range3.formula, '=A1+A2');
      expect(range3.calculatedValue, '20.0');
      expect(sheet.getRangeByName('E1:E5').text, null);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelGetRangeForMultipleRange.xlsx');
      workbook.dispose();
    });

    test('Index func', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[1];
      sheet.getRangeByName('A1').number = 10;
      sheet.getRangeByName('A2').number = 5;
      sheet.getRangeByName('B1').number = 4;
      sheet.getRangeByName('B2').number = 8;

      sheet.enableSheetCalculations();
      Range range = sheet.getRangeByName('A3');
      range.formula = '=INDEX(A1:A2,2,1)';
      expect(range.calculatedValue, '5.0');
      range = sheet.getRangeByName('A4');
      range.formula = '=INDEX(A1:B2,1,1,1)';
      expect(range.calculatedValue, '10.0');
      range = sheet1.getRangeByName('A1');
      range.formula = '=INDEX(Sheet1!A1:B2,2,2)';
      expect(range.calculatedValue, '8.0');
      range = sheet.getRangeByName('A5');
      range.formula = '=INDEX(B1,1)';
      expect(range.calculatedValue, '4.0');
      final Range range1 = sheet.getRangeByName('A6');
      range1.formula = '=INDEX(A1:A2,A2)';
      expect(range1.calculatedValue, '#REF!');
      final Range range2 = sheet.getRangeByName('A7');
      range2.formula = '=INDEX(A1:B2,a,2)';
      expect(range2.calculatedValue, '#REF!');
      final Range range3 = sheet.getRangeByIndex(8, 1);
      range3.formula = '=INDEX(A1:B2)';
      expect(range3.calculatedValue, 'wrong number of arguments');
      sheet.getRangeByName('B3').text = 'Z';
      final Range range4 = sheet.getRangeByName('A9');
      range4.formula = '=INDEX(A1:B3,3,2)';
      expect(range4.calculatedValue, 'Z');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelFormulaIndex.xlsx');
      workbook.dispose();
    });

    test('Match Func', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').number = 10;
      sheet.getRangeByName('A2').number = 8;
      sheet.getRangeByName('A3').number = 6;
      sheet.getRangeByName('A4').number = 4;
      sheet.getRangeByName('B1').text = 'm';
      sheet.getRangeByName('B2').text = 'o';
      sheet.getRangeByName('B3').text = 'u';
      sheet.getRangeByName('B4').text = 'z';
      sheet.getRangeByName('C1').text = 'Anu';
      sheet.getRangeByName('C2').text = 'Bril';
      sheet.getRangeByName('C3').text = 'Mery';
      sheet.getRangeByName('C4').text = 'Varun';
      sheet.getRangeByName('E1').dateTime = DateTime(2020, 11);
      sheet.getRangeByName('E2').dateTime = DateTime(2020, 11, 10);
      sheet.getRangeByName('E3').dateTime = DateTime(2020, 11, 20);
      sheet.getRangeByName('E4').dateTime = DateTime(2020, 11, 30);
      sheet.enableSheetCalculations();
      final Range range = sheet.getRangeByName('A5');
      range.formula = '=MATCH(8,A1:A4,0)';
      expect(range.calculatedValue, '2');
      final Range range1 = sheet.getRangeByName('A6');
      range1.formula = '=MATCH(8,A1:A4,-1)';
      expect(range1.calculatedValue, '2');
      final Range range2 = sheet.getRangeByName('A7');
      range2.formula = '=MATCH(8,A1:A4,1)';
      expect(range2.calculatedValue, '#N/A');
      final Range range3 = sheet.getRangeByName('B5');
      range3.formula = '=MATCH(B3,B1:B4,0)';
      expect(range3.calculatedValue, '3');
      final Range range4 = sheet.getRangeByName('B6');
      range4.formula = '=MATCH(B2,B1:B4,-1)';
      expect(range4.calculatedValue, '#N/A');
      final Range range5 = sheet.getRangeByName('B7');
      range5.formula = '=MATCH(B1,B1:B4,1)';
      expect(range5.calculatedValue, '1');
      final Range range6 = sheet.getRangeByName('C5');
      range6.formula = '=MATCH(C4,C1:C4,0)';
      expect(range6.calculatedValue, '4');
      final Range range7 = sheet.getRangeByName('C6');
      range7.formula = '=MATCH(C3,C1:C4,1)';
      expect(range7.calculatedValue, '3');
      final Range range8 = sheet.getRangeByName('A10');
      range8.formula = '=MATCH(o,B1:B4,0)';
      expect(range8.calculatedValue, '#NAME?');
      final Range range9 = sheet.getRangeByName('E5');
      range9.formula = '=MATCH(E2,E1:E4,0)';
      expect(range9.calculatedValue, '2');
      final Range range10 = sheet.getRangeByName('A8');
      range10.formula = '=MATCH(5,A1:A4,-1)';
      expect(range10.calculatedValue, '3');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelFormulaMatch.xlsx');
      workbook.dispose();
    });

    test('AND', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setNumber(75);
      sheet.getRangeByName('A2').setNumber(32);
      sheet.getRangeByName('A3').setNumber(84);
      sheet.getRangeByName('A4').setNumber(57);
      sheet.getRangeByName('A5').setNumber(65);
      sheet.enableSheetCalculations();

      Range range = sheet.getRangeByName('B1');
      range.formula = '=AND(A1>35,A1<75)';
      expect(range.calculatedValue, 'FALSE');
      range = sheet.getRangeByName('B2');
      range.formula = '=AND(A2>35,A2<75)';
      expect(range.calculatedValue, 'FALSE');
      range = sheet.getRangeByName('B3');
      range.formula = '=AND(A3>35,A3<75)';
      expect(range.calculatedValue, 'FALSE');
      range = sheet.getRangeByName('B4');
      range.formula = '=AND(A4>35,A4<75)';
      expect(range.calculatedValue, 'TRUE');
      range = sheet.getRangeByName('B5');
      range.formula = '=AND(A5>35,A5<75)';
      expect(range.calculatedValue, 'TRUE');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelANDFormula.xlsx');
      workbook.dispose();
    });

    test('OR', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Green');
      sheet.getRangeByName('A2').setText('Red');
      sheet.getRangeByName('A3').setText('Blue');
      sheet.getRangeByName('A4').setText('Red');
      sheet.getRangeByName('A5').setText('Green');
      sheet.getRangeByName('A6').setText('Blue');
      sheet.enableSheetCalculations();

      Range range = sheet.getRangeByName('B1');
      range.formula = '=OR(A1="Green",A1="Red")';
      expect(range.calculatedValue, 'TRUE');
      range = sheet.getRangeByName('B2');
      range.formula = '=OR(A2="Green",A2="Red")';
      expect(range.calculatedValue, 'TRUE');
      range = sheet.getRangeByName('B3');
      range.formula = '=OR(A3="Green",A3="Red")';
      expect(range.calculatedValue, 'FALSE');
      range = sheet.getRangeByName('B4');
      range.formula = '=OR(A4="Green",A4="Red")';
      expect(range.calculatedValue, 'TRUE');
      range = sheet.getRangeByName('B5');
      range.formula = '=OR(A5="Green",A5="Red")';
      expect(range.calculatedValue, 'TRUE');
      range = sheet.getRangeByName('B6');
      range.formula = '=OR(A6="Green",A6="Red")';
      expect(range.calculatedValue, 'FALSE');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelORFormula.xlsx');
      workbook.dispose();
    });

    test('NOT', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Green');
      sheet.getRangeByName('A2').setText('Red');
      sheet.getRangeByName('A3').setText('Blue');
      sheet.getRangeByName('A4').setText('Red');
      sheet.getRangeByName('A5').setText('Green');
      sheet.getRangeByName('A6').setText('Blue');
      sheet.enableSheetCalculations();

      Range range = sheet.getRangeByName('B1');
      range.formula = '=NOT(A1="Green")';
      expect(range.calculatedValue, 'FALSE');
      range = sheet.getRangeByName('B2');
      range.formula = '=NOT(A2="Red")';
      expect(range.calculatedValue, 'FALSE');
      range = sheet.getRangeByName('B3');
      range.formula = '=NOT(A3="Red")';
      expect(range.calculatedValue, 'TRUE');
      range = sheet.getRangeByName('B4');
      range.formula = '=NOT(A4="Blue")';
      expect(range.calculatedValue, 'TRUE');
      range = sheet.getRangeByName('B5');
      range.formula = '=NOT(A5="Green")';
      expect(range.calculatedValue, 'FALSE');
      range = sheet.getRangeByName('B6');
      range.formula = '=NOT(A6="Blue")';
      expect(range.calculatedValue, 'TRUE');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelNOTFormula.xlsx');
      workbook.dispose();
    });

    test('Nested Functions', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('B3').setText('Team A');
      sheet.getRangeByName('B4').setNumber(85);
      sheet.getRangeByName('B5').setNumber(92);
      sheet.getRangeByName('B6').setNumber(95);
      sheet.getRangeByName('B7').setNumber(81);
      sheet.getRangeByName('B8').setNumber(79);
      sheet.getRangeByName('B9').setNumber(90);
      sheet.getRangeByName('B10').setNumber(98);

      sheet.getRangeByName('D3').setText('Team B');
      sheet.getRangeByName('D4').setNumber(94);
      sheet.getRangeByName('D5').setNumber(93);
      sheet.getRangeByName('D6').setNumber(85);
      sheet.getRangeByName('D7').setNumber(83);
      sheet.getRangeByName('D8').setNumber(90);
      sheet.getRangeByName('D9').setNumber(90);
      sheet.getRangeByName('D10').setNumber(88);

      final Range range = sheet.getRangeByName('C14');
      range.formula = '=AVERAGE(MAX(B4:B10),MAX(D4:D10))';
      sheet.enableSheetCalculations();

      expect(range.calculatedValue, '96.0');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'NestedFunctions.xlsx');
      workbook.dispose();
    });

    test('Nested Functions 2', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('B3').setText('Team A');
      sheet.getRangeByName('B4').setNumber(47);
      sheet.getRangeByName('B5').setNumber(43);
      sheet.getRangeByName('B6').setNumber(40);
      sheet.getRangeByName('B7').setNumber(51);
      sheet.getRangeByName('B8').setNumber(53);
      sheet.getRangeByName('B9').setNumber(50);

      sheet.getRangeByName('D3').setText('Team B');
      sheet.getRangeByName('D4').setNumber(72);
      sheet.getRangeByName('D5').setNumber(43);
      sheet.getRangeByName('D6').setNumber(84);
      sheet.getRangeByName('D7').setNumber(90);
      sheet.getRangeByName('D8').setNumber(42);
      sheet.getRangeByName('D9').setNumber(56);

      final Range range1 = sheet.getRangeByName('B14');
      range1.formula = '=IF(AVERAGE(B4:B9) > 50, "PASS", "FAIL")';

      final Range range2 = sheet.getRangeByName('D14');
      range2.formula = '=IF(AVERAGE(D4:D9) > 50, "PASS", "FAIL")';

      sheet.enableSheetCalculations();

      expect(range1.calculatedValue, 'FAIL');
      expect(range2.calculatedValue, 'PASS');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'NestedFunctions2.xlsx');
      workbook.dispose();
    });

    test('NestedFunctions 3', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Color');
      sheet.getRangeByName('A2').setText('Red');
      sheet.getRangeByName('A3').setText('Green');
      sheet.getRangeByName('A4').setText('Red');
      sheet.getRangeByName('A5').setText('Blue');
      sheet.getRangeByName('A6').setText('Red');
      sheet.getRangeByName('A7').setText('Blue');

      sheet.getRangeByName('B1').setText('Size');
      sheet.getRangeByName('B2').setText('Small');
      sheet.getRangeByName('B3').setText('Large');
      sheet.getRangeByName('B4').setText('Medium');
      sheet.getRangeByName('B5').setText('Large');
      sheet.getRangeByName('B6').setText('Small');
      sheet.getRangeByName('B7').setText('Medium');

      sheet.getRangeByName('C1').setText('Flag');

      final Style style = workbook.styles.add('Style1');
      style.backColor = '#809EEA';

      sheet.getRangeByName('A1:C1').cellStyle = style;

      sheet.enableSheetCalculations();

      Range range = sheet.getRangeByName('C2');
      range.formula = '=IF(AND(A2="Red",B2="Small"),"x","")';
      expect(range.calculatedValue, 'x');
      range = sheet.getRangeByName('C3');
      range.formula = '=IF(AND(A3="Red",B3="Small"),"x","")';
      expect(range.calculatedValue, '');
      range = sheet.getRangeByName('C4');
      range.formula = '=IF(AND(A4="Red",B4="Small"),"x","")';
      expect(range.calculatedValue, '');
      range = sheet.getRangeByName('C5');
      range.formula = '=IF(AND(A5="Red",B5="Small"),"x","")';
      expect(range.calculatedValue, '');
      range = sheet.getRangeByName('C6');
      range.formula = '=IF(AND(A6="Red",B6="Small"),"x","")';
      expect(range.calculatedValue, 'x');
      range = sheet.getRangeByName('C7');
      range.formula = '=IF(AND(A7="Red",B7="Small"),"x","")';
      expect(range.calculatedValue, '');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'NestedFunctions3.xlsx');
      workbook.dispose();
    });

    test('Nested Functions 4', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('B3').setText('Team A');
      sheet.getRangeByName('B4').setNumber(47);
      sheet.getRangeByName('B5').setNumber(43);
      sheet.getRangeByName('B6').setNumber(40);
      sheet.getRangeByName('B7').setNumber(51);
      sheet.getRangeByName('B8').setNumber(53);
      sheet.getRangeByName('B9').setNumber(50);

      sheet.getRangeByName('D3').setText('Team B');
      sheet.getRangeByName('D4').setNumber(72);
      sheet.getRangeByName('D5').setNumber(43);
      sheet.getRangeByName('D6').setNumber(84);
      sheet.getRangeByName('D7').setNumber(90);
      sheet.getRangeByName('D8').setNumber(42);
      sheet.getRangeByName('D9').setNumber(56);

      final Range range1 = sheet.getRangeByName('B14');
      range1.formula =
          '=IF(SUM(AVERAGE(B4:B9), MIN(MAX(COUNT(SUM(MIN(COUNT(D4:D9),2),1),2,1),D4), MIN(1,2))) > 70, "PASS", "FAIL")';

      final Range range2 = sheet.getRangeByName('D14');
      range2.formula =
          '=IF(AVERAGE(SUM(D4:D9), MIN(COUNT(B7,D7), MAX(B8,D8))) > 50, "PASS", "FAIL")';

      sheet.enableSheetCalculations();

      expect(range1.calculatedValue, 'FAIL');
      expect(range2.calculatedValue, 'PASS');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'NestedFunctions4.xlsx');
      workbook.dispose();
    });

    test('Trim', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText(' syncfusion');
      sheet.getRangeByName('A2').setText('software ');

      sheet.getRangeByName('B1').setText('  Proper text ');
      sheet.getRangeByName('B2').setText('      Text      ');

      sheet.enableSheetCalculations();

      Range range = sheet.getRangeByName('A4');
      range.formula = '=TRIM(A1)';
      expect(range.calculatedValue, 'syncfusion');
      range = sheet.getRangeByName('A5');
      range.formula = '=TRIM(A2)';
      expect(range.calculatedValue, 'software');
      range = sheet.getRangeByName('B4');
      range.formula = '=TRIM(B1)';
      expect(range.calculatedValue, 'Proper text');
      range = sheet.getRangeByName('C5');
      range.formula = '=TRIM(B2)';
      expect(range.calculatedValue, 'Text');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Trim.xlsx');
      workbook.dispose();
    });

    test('Concatenate', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Syncfusion ');
      sheet.getRangeByName('A2').setText('Software');

      sheet.getRangeByName('B1').setText('Test');
      sheet.getRangeByName('B2').setText('Text');

      sheet.enableSheetCalculations();

      Range range = sheet.getRangeByName('A4');
      range.formula = '=CONCATENATE(A1,A2)';
      expect(range.calculatedValue, 'Syncfusion Software');
      range = sheet.getRangeByName('B4');
      range.formula = '=CONCATENATE(B1,B2)';
      expect(range.calculatedValue, 'TestText');
      range = sheet.getRangeByName('C4');
      range.formula = '=CONCATENATE(A1,A2," ",B1," ",B2)';
      expect(range.calculatedValue, 'Syncfusion Software "Test "Text');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Concatenate.xlsx');
      workbook.dispose();
    });

    test('Lower', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('Syncfusion');
      sheet.getRangeByName('A2').setText('SOFTWARE');

      sheet.enableSheetCalculations();

      Range range = sheet.getRangeByName('A4');
      range.formula = '=LOWER(A1)';
      expect(range.calculatedValue, 'syncfusion');
      range = sheet.getRangeByName('A5');
      range.formula = '=LOWER(A2)';
      expect(range.calculatedValue, 'software');
      range = sheet.getRangeByName('A6');
      range.formula = '=LOWER("TEsT teXT")';
      expect(range.calculatedValue, 'test text');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Lower.xlsx');
      workbook.dispose();
    });

    test('Upper', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('syncfusion');
      sheet.getRangeByName('A2').setText('software');

      sheet.getRangeByName('B1').setText('Test');
      sheet.getRangeByName('B2').setText('Text');

      sheet.enableSheetCalculations();

      Range range = sheet.getRangeByName('A4');
      range.formula = '=UPPER(A1)';
      expect(range.calculatedValue, 'SYNCFUSION');
      range = sheet.getRangeByName('A5');
      range.formula = '=UPPER(A2)';
      expect(range.calculatedValue, 'SOFTWARE');
      range = sheet.getRangeByName('A6');
      range.formula = '=UPPER("TEsT teXT")';
      expect(range.calculatedValue, 'TEST TEXT');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'Upper.xlsx');
      workbook.dispose();
    });
    test('AverageIFs', () {
      final Workbook workbook = Workbook();

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // set the value to the cell.
      sheet.getRangeByName('A1').setText('Apple');
      sheet.getRangeByName('A2').setText('Grapes');
      sheet.getRangeByName('A3').setText('Banana');
      sheet.getRangeByName('A4').setText('Grapes');
      sheet.getRangeByName('A5').setText('Grapes');
      sheet.getRangeByName('A6').setText('Banana');
      sheet.getRangeByName('A7').setText('Apple');
      sheet.getRangeByName('A8').setText('Banana');
      sheet.getRangeByName('A9').setText('Apple');
      sheet.getRangeByName('A10').setText('Grapes');
      sheet.getRangeByName('B1').setText('red');
      sheet.getRangeByName('B2').setText('blue');
      sheet.getRangeByName('B3').setText('yellow');
      sheet.getRangeByName('B4').setText('blue1');
      sheet.getRangeByName('B5').setText('blue');
      sheet.getRangeByName('B6').setText('yellow');
      sheet.getRangeByName('B7').setText('red1');
      sheet.getRangeByName('B8').setText('yellow');
      sheet.getRangeByName('B9').setText('red1');
      sheet.getRangeByName('B10').setText('blue1');
      sheet.getRangeByName('C1').setNumber(58);
      sheet.getRangeByName('C2').setNumber(1200);
      sheet.getRangeByName('C3').setNumber(300);
      sheet.getRangeByName('C4').setNumber(500);
      sheet.getRangeByName('C5').setNumber(1000);
      sheet.getRangeByName('C6').setNumber(600);
      sheet.getRangeByName('C7').setNumber(200);
      sheet.getRangeByName('C8').setNumber(339);
      sheet.getRangeByName('C9').setNumber(400);
      sheet.getRangeByName('C10').setNumber(100);
      sheet.getRangeByName('D1').setNumber(2);
      sheet.getRangeByName('D2').setNumber(3);
      sheet.getRangeByName('D3').setNumber(4);
      sheet.getRangeByName('D4').setNumber(2);
      sheet.getRangeByName('D5').setNumber(1);
      sheet.getRangeByName('D6').setNumber(4);
      sheet.getRangeByName('D7').setNumber(3);
      sheet.getRangeByName('D8').setNumber(2);
      sheet.getRangeByName('D9').setNumber(1);
      sheet.getRangeByName('D10').setNumber(2);

      // Formula calculation is enabled for the sheet.
      sheet.enableSheetCalculations();

      // Setting formula in the cell.
      Range range = sheet.getRangeByName('D12');
      range.setFormula('=AVERAGEIFS(C1:C10,D1:D10,">2")');
      range.calculatedValue;
      range = sheet.getRangeByName('D13');
      range.setFormula('=AVERAGEIFS(C1:C10,A1:A10,"Apple")');
      range.calculatedValue;
      range = sheet.getRangeByName('D14');
      range.setFormula('=AVERAGEIFS(C1:C10,A1:A10,"Apple",B1:B10,"red1")');
      range.calculatedValue;
      range = sheet.getRangeByName('D15');
      range.setFormula(
          '=AVERAGEIFS(C1:C10,A1:A10,"Apple",B1:B10,"red",D1:D10,">=1")');
      range.calculatedValue;
      range = sheet.getRangeByName('D16');
      range.setFormula(
          '=AVERAGEIFS(C1:C10,A1:A10,"Grapes",D1:D10,"<=2",B1:B10,"blue")');
      range.calculatedValue;
      range = sheet.getRangeByName('D17');
      range.setFormula('=AVERAGEIFS(C1:C10,C1:D10,">2")');
      range.calculatedValue;
      range = sheet.getRangeByName('D18');
      range.setFormula('=AVERAGEIFS(C1:C10,D1:D10,"2")');
      range.calculatedValue;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelAverageIfs.xlsx');
      workbook.dispose();
    });
    test('SumIfs', () {
      final Workbook workbook = Workbook();

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // set the value to the cell.
      sheet.getRangeByName('A1').setText('Apple');
      sheet.getRangeByName('A2').setText('Grapes');
      sheet.getRangeByName('A3').setText('Banana');
      sheet.getRangeByName('A4').setText('Grapes');
      sheet.getRangeByName('A5').setText('Grapes');
      sheet.getRangeByName('A6').setText('Banana');
      sheet.getRangeByName('A7').setText('Apple');
      sheet.getRangeByName('A8').setText('Banana');
      sheet.getRangeByName('A9').setText('Apple');
      sheet.getRangeByName('A10').setText('Grapes');
      sheet.getRangeByName('B1').setText('red');
      sheet.getRangeByName('B2').setText('blue');
      sheet.getRangeByName('B3').setText('yellow');
      sheet.getRangeByName('B4').setText('blue1');
      sheet.getRangeByName('B5').setText('blue');
      sheet.getRangeByName('B6').setText('yellow');
      sheet.getRangeByName('B7').setText('red1');
      sheet.getRangeByName('B8').setText('yellow');
      sheet.getRangeByName('B9').setText('red1');
      sheet.getRangeByName('B10').setText('blue1');
      sheet.getRangeByName('C1').setNumber(58);
      sheet.getRangeByName('C2').setNumber(1200);
      sheet.getRangeByName('C3').setNumber(300);
      sheet.getRangeByName('C4').setNumber(500);
      sheet.getRangeByName('C5').setNumber(1000);
      sheet.getRangeByName('C6').setNumber(600);
      sheet.getRangeByName('C7').setNumber(200);
      sheet.getRangeByName('C8').setNumber(339);
      sheet.getRangeByName('C9').setNumber(400);
      sheet.getRangeByName('C10').setNumber(100);
      sheet.getRangeByName('D1').setNumber(2);
      sheet.getRangeByName('D2').setNumber(3);
      sheet.getRangeByName('D3').setNumber(4);
      sheet.getRangeByName('D4').setNumber(2);
      sheet.getRangeByName('D5').setNumber(1);
      sheet.getRangeByName('D6').setNumber(4);
      sheet.getRangeByName('D7').setNumber(3);
      sheet.getRangeByName('D8').setNumber(2);
      sheet.getRangeByName('D9').setNumber(1);
      sheet.getRangeByName('D10').setNumber(2);

      // Formula calculation is enabled for the sheet.
      sheet.enableSheetCalculations();

      // // Setting formula in the cell.
      Range range = sheet.getRangeByName('D12');
      range.setFormula('=SUMIFS(C1:C10,D1:D10,">=2")');
      expect(range.calculatedValue, '3297.0');
      range = sheet.getRangeByName('D13');
      range.setFormula('=SUMIFS(C1:C10,A1:A10,"Banana")');
      expect(range.calculatedValue, '1239.0');
      range = sheet.getRangeByName('D14');
      range.setFormula('=SUMIFS(C1:C10,A1:A10,"Apple",B1:B10,"red1")');
      expect(range.calculatedValue, '600.0');
      range = sheet.getRangeByName('D15');
      range.setFormula(
          '=SUMIFS(C1:C10,A1:A10,"Banana",B1:B10,"yellow1",D1:D10,">=1")');
      expect(range.calculatedValue, '0.0');
      range = sheet.getRangeByName('D16');
      range.setFormula(
          '=SUMIFS(C1:C10,A1:A10,"Grapes",D1:D10,">=2",B1:B10,"blue")');
      expect(range.calculatedValue, '1200.0');
      range = sheet.getRangeByName('D17');
      range.setFormula('=SUMIFS(C1:C10,C1:D10,">=2")');
      expect(range.calculatedValue, '#VALUE!');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSumIfs.xlsx');
      workbook.dispose();
    });
    test('MINIfs', () {
      final Workbook workbook = Workbook();

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // set the value to the cell.
      sheet.getRangeByName('A1').setText('Apple');
      sheet.getRangeByName('A2').setText('Grapes');
      sheet.getRangeByName('A3').setText('Banana');
      sheet.getRangeByName('A4').setText('Grapes');
      sheet.getRangeByName('A5').setText('Grapes');
      sheet.getRangeByName('A6').setText('Banana');
      sheet.getRangeByName('A7').setText('Apple');
      sheet.getRangeByName('A8').setText('Banana');
      sheet.getRangeByName('A9').setText('Apple');
      sheet.getRangeByName('A10').setText('Grapes');
      sheet.getRangeByName('B1').setText('red');
      sheet.getRangeByName('B2').setText('blue');
      sheet.getRangeByName('B3').setText('yellow');
      sheet.getRangeByName('B4').setText('blue1');
      sheet.getRangeByName('B5').setText('blue');
      sheet.getRangeByName('B6').setText('yellow');
      sheet.getRangeByName('B7').setText('red1');
      sheet.getRangeByName('B8').setText('yellow');
      sheet.getRangeByName('B9').setText('red1');
      sheet.getRangeByName('B10').setText('blue1');
      sheet.getRangeByName('C1').setNumber(58);
      sheet.getRangeByName('C2').setNumber(1200);
      sheet.getRangeByName('C3').setNumber(300);
      sheet.getRangeByName('C4').setNumber(500);
      sheet.getRangeByName('C5').setNumber(1000);
      sheet.getRangeByName('C6').setNumber(600);
      sheet.getRangeByName('C7').setNumber(200);
      sheet.getRangeByName('C8').setNumber(339);
      sheet.getRangeByName('C9').setNumber(400);
      sheet.getRangeByName('C10').setNumber(100);
      sheet.getRangeByName('D1').setNumber(2);
      sheet.getRangeByName('D2').setNumber(3);
      sheet.getRangeByName('D3').setNumber(4);
      sheet.getRangeByName('D4').setNumber(2);
      sheet.getRangeByName('D5').setNumber(1);
      sheet.getRangeByName('D6').setNumber(4);
      sheet.getRangeByName('D7').setNumber(3);
      sheet.getRangeByName('D8').setNumber(2);
      sheet.getRangeByName('D9').setNumber(1);
      sheet.getRangeByName('D10').setNumber(2);

      // Formula calculation is enabled for the sheet.
      sheet.enableSheetCalculations();

      // // Setting formula in the cell.
      Range range = sheet.getRangeByName('D12');
      range.setFormula('=MINIFS(C1:C10,D1:D10,">3")');
      expect(range.calculatedValue, '300.0');
      range = sheet.getRangeByName('D13');
      range.setFormula('=MINIFS(C1:C10,A1:A10,"Grapes")');
      expect(range.calculatedValue, '100.0');
      range = sheet.getRangeByName('D14');
      range.setFormula('=MINIFS(C1:C10,A1:A10,"Apple",B1:B10,"red1")');
      expect(range.calculatedValue, '200.0');
      range = sheet.getRangeByName('D15');
      range.setFormula(
          '=MINIFS(C1:C10,A1:A10,"Banana",B1:B10,"yellow",D1:D10,"<=2")');
      expect(range.calculatedValue, '339.0');
      range = sheet.getRangeByName('D16');
      range.setFormula(
          '=MINIFS(C1:C10,A1:A10,"Grapes",D1:D10,">2",B1:B10,"blue1")');
      expect(range.calculatedValue, '0.0');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMinIfs.xlsx');
      workbook.dispose();
    });
    test('MAXIfs', () {
      final Workbook workbook = Workbook();

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // set the value to the cell.
      sheet.getRangeByName('A1').setText('Apple');
      sheet.getRangeByName('A2').setText('Grapes');
      sheet.getRangeByName('A3').setText('Banana');
      sheet.getRangeByName('A4').setText('Grapes');
      sheet.getRangeByName('A5').setText('Grapes');
      sheet.getRangeByName('A6').setText('Banana');
      sheet.getRangeByName('A7').setText('Apple');
      sheet.getRangeByName('A8').setText('Banana');
      sheet.getRangeByName('A9').setText('Apple');
      sheet.getRangeByName('A10').setText('Grapes');
      sheet.getRangeByName('B1').setText('red');
      sheet.getRangeByName('B2').setText('blue');
      sheet.getRangeByName('B3').setText('yellow');
      sheet.getRangeByName('B4').setText('blue1');
      sheet.getRangeByName('B5').setText('blue');
      sheet.getRangeByName('B6').setText('yellow');
      sheet.getRangeByName('B7').setText('red1');
      sheet.getRangeByName('B8').setText('yellow');
      sheet.getRangeByName('B9').setText('red1');
      sheet.getRangeByName('B10').setText('blue1');
      sheet.getRangeByName('C1').setNumber(58);
      sheet.getRangeByName('C2').setNumber(1200);
      sheet.getRangeByName('C3').setNumber(300);
      sheet.getRangeByName('C4').setNumber(500);
      sheet.getRangeByName('C5').setNumber(1000);
      sheet.getRangeByName('C6').setNumber(600);
      sheet.getRangeByName('C7').setNumber(200);
      sheet.getRangeByName('C8').setNumber(339);
      sheet.getRangeByName('C9').setNumber(400);
      sheet.getRangeByName('C10').setNumber(100);
      sheet.getRangeByName('D1').setNumber(2);
      sheet.getRangeByName('D2').setNumber(3);
      sheet.getRangeByName('D3').setNumber(4);
      sheet.getRangeByName('D4').setNumber(2);
      sheet.getRangeByName('D5').setNumber(1);
      sheet.getRangeByName('D6').setNumber(4);
      sheet.getRangeByName('D7').setNumber(3);
      sheet.getRangeByName('D8').setNumber(2);
      sheet.getRangeByName('D9').setNumber(1);
      sheet.getRangeByName('D10').setNumber(2);

      // Formula calculation is enabled for the sheet.
      sheet.enableSheetCalculations();

      // // Setting formula in the cell.
      Range range = sheet.getRangeByName('D12');
      range.setFormula('=MAXIFS(C1:C10,D1:D10,">3")');
      expect(range.calculatedValue, '600.0');
      range = sheet.getRangeByName('D13');
      range.setFormula('=MAXIFS(C1:C10,A1:A10,"Grapes")');
      expect(range.calculatedValue, '1200.0');
      range = sheet.getRangeByName('D14');
      range.setFormula('=MAXIFS(C1:C10,A1:A10,"Apple",B1:B10,"red1")');
      expect(range.calculatedValue, '400.0');
      range = sheet.getRangeByName('D15');
      range.setFormula(
          '=MAXIFS(C1:C10,A1:A10,"Grapes",B1:B10,"blue",D1:D10,"<=1")');
      expect(range.calculatedValue, '1000.0');
      range = sheet.getRangeByName('D16');
      range.setFormula(
          '=MAXIFS(C1:C10,A1:A10,"Grapes",D1:D10,">1",B1:B10,"blue1")');
      expect(range.calculatedValue, '500.0');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelMaxIfs.xlsx');
      workbook.dispose();
    });
    test('COUNTIfs', () {
      final Workbook workbook = Workbook();

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // set the value to the cell.
      sheet.getRangeByName('A1').setText('Apple');
      sheet.getRangeByName('A2').setText('Grapes');
      sheet.getRangeByName('A3').setText('Banana');
      sheet.getRangeByName('A4').setText('Grapes');
      sheet.getRangeByName('A5').setText('Grapes');
      sheet.getRangeByName('A6').setText('Banana');
      sheet.getRangeByName('A7').setText('Apple');
      sheet.getRangeByName('A8').setText('Banana');
      sheet.getRangeByName('A9').setText('Apple');
      sheet.getRangeByName('A10').setText('Grapes');
      sheet.getRangeByName('B1').setText('red');
      sheet.getRangeByName('B2').setText('blue');
      sheet.getRangeByName('B3').setText('yellow');
      sheet.getRangeByName('B4').setText('blue1');
      sheet.getRangeByName('B5').setText('blue');
      sheet.getRangeByName('B6').setText('yellow');
      sheet.getRangeByName('B7').setText('red1');
      sheet.getRangeByName('B8').setText('yellow');
      sheet.getRangeByName('B9').setText('red1');
      sheet.getRangeByName('B10').setText('blue1');
      sheet.getRangeByName('C1').setNumber(58);
      sheet.getRangeByName('C2').setNumber(1200);
      sheet.getRangeByName('C3').setNumber(300);
      sheet.getRangeByName('C4').setNumber(500);
      sheet.getRangeByName('C5').setNumber(1000);
      sheet.getRangeByName('C6').setNumber(600);
      sheet.getRangeByName('C7').setNumber(200);
      sheet.getRangeByName('C8').setNumber(339);
      sheet.getRangeByName('C9').setNumber(400);
      sheet.getRangeByName('C10').setNumber(100);
      sheet.getRangeByName('D1').setNumber(2);
      sheet.getRangeByName('D2').setNumber(3);
      sheet.getRangeByName('D3').setNumber(4);
      sheet.getRangeByName('D4').setNumber(2);
      sheet.getRangeByName('D5').setNumber(1);
      sheet.getRangeByName('D6').setNumber(4);
      sheet.getRangeByName('D7').setNumber(3);
      sheet.getRangeByName('D8').setNumber(2);
      sheet.getRangeByName('D9').setNumber(1);
      sheet.getRangeByName('D10').setNumber(2);

      // Formula calculation is enabled for the sheet.
      sheet.enableSheetCalculations();

      // // Setting formula in the cell.
      Range range = sheet.getRangeByName('D12');
      range.setFormula('=COUNTIFS(A1:A10,"Grapes")');
      expect(range.calculatedValue, '4.0');
      range = sheet.getRangeByName('D13');
      range.setFormula('=COUNTIFS(A1:A10,"Grapes",B1:B10,"blue")');
      expect(range.calculatedValue, '2.0');
      range = sheet.getRangeByName('D14');
      range.setFormula('=COUNTIFS(A1:A10,"Grapes",B1:B10,"blue",D1:D10,">=2")');
      expect(range.calculatedValue, '1.0');
      range = sheet.getRangeByName('D15');
      range.setFormula('=COUNTIFS(A1:A10,"Apple",B1:B10,"red1",D1:D10,"<>2")');
      expect(range.calculatedValue, '2.0');
      range = sheet.getRangeByName('D16');
      range.setFormula(
          '=COUNTIFS(A1:A10,"Banana",B1:B10,"yellow",D1:D10,">=2",C1:C10,">100")');
      expect(range.calculatedValue, '3.0');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCountIfs.xlsx');
      workbook.dispose();
    });
    test('VLookUP', () {
      final Workbook workbook = Workbook(2);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[1];

      // set the value to the cell.
      sheet.getRangeByName('A1').setText('ID');
      sheet.getRangeByName('A2').setNumber(11);
      sheet.getRangeByName('A3').setNumber(22);
      sheet.getRangeByName('A4').setNumber(33);
      sheet.getRangeByName('A5').setNumber(44);
      sheet.getRangeByName('A6').setNumber(55);
      sheet.getRangeByName('A7').setNumber(66);
      sheet.getRangeByName('A8').setNumber(77);
      sheet.getRangeByName('A9').setNumber(88);
      sheet.getRangeByName('A10').setNumber(99);
      sheet.getRangeByName('B1').setText('F Name');
      sheet.getRangeByName('B2').setText('Anderson');
      sheet.getRangeByName('B3').setText('Emily');
      sheet.getRangeByName('B4').setText('James');
      sheet.getRangeByName('B5').setText('Jessy');
      sheet.getRangeByName('B6').setText('John');
      sheet.getRangeByName('B7').setText('Karan');
      sheet.getRangeByName('B8').setText('Mark');
      sheet.getRangeByName('B9').setText('Mia');
      sheet.getRangeByName('B10').setText('Virat');
      sheet.getRangeByName('C1').setText('L Name');
      sheet.getRangeByName('C2').setText('Halk');
      sheet.getRangeByName('C3').setText('Smith');
      sheet.getRangeByName('C4').setText('Mark');
      sheet.getRangeByName('C5').setText('Karthick');
      sheet.getRangeByName('C6').setText('Cena');
      sheet.getRangeByName('C7').setText('Johar');
      sheet.getRangeByName('C8').setText('Reed');
      sheet.getRangeByName('C9').setText('Clark');
      sheet.getRangeByName('C10').setText('Kholi');
      sheet.getRangeByName('D1').setText('Mark');
      sheet.getRangeByName('D2').setNumber(100);
      sheet.getRangeByName('D3').setNumber(89);
      sheet.getRangeByName('D4').setNumber(48);
      sheet.getRangeByName('D5').setNumber(64);
      sheet.getRangeByName('D6').setNumber(40);
      sheet.getRangeByName('D7').setNumber(20);
      sheet.getRangeByName('D8').setNumber(69);
      sheet.getRangeByName('D9').setNumber(98);
      sheet.getRangeByName('D10').setNumber(99);

      // Formula calculation is enabled for the sheet.
      sheet.enableSheetCalculations();

      // Setting formula in the cell.
      // Approximate Match
      Range range = sheet.getRangeByName('C12');
      range.setText('ID');
      range = sheet.getRangeByName('D12');
      range.setNumber(22);
      range = sheet.getRangeByName('C13');
      range.setText('Mark');
      range = sheet.getRangeByName('D13');
      range.setFormula('=VLOOKUP(D12,A2:D10,4,TRUE)');
      expect(range.calculatedValue, '89.0');
      range = sheet.getRangeByName('C14');
      range.setText('F Name');
      range = sheet.getRangeByName('D14');
      range.setFormula('=VLOOKUP(A3,A2:D10,2,1)');
      expect(range.calculatedValue, 'Emily');
      range = sheet.getRangeByName('C15');
      range.setText('L Name');
      range = sheet.getRangeByName('D15');
      range.setFormula('=VLOOKUP(D14,B2:D10,2)');
      range.calculatedValue;
      expect(range.calculatedValue, 'Smith');
      // Exact Match
      range = sheet.getRangeByName('C17');
      range.setText('ID');
      range = sheet.getRangeByName('D17');
      range.setNumber(88);
      range = sheet.getRangeByName('C18');
      range.setText('F Name');
      range = sheet.getRangeByName('D18');
      range.setFormula('=VLOOKUP(D17,A2:D10,2,FALSE)');
      expect(range.calculatedValue, 'Mia');
      range = sheet.getRangeByName('C19');
      range.setText('L Name');
      range = sheet.getRangeByName('D19');
      range.setFormula('=VLOOKUP(D18,B2:D10,2,0)');
      expect(range.calculatedValue, 'Clark');
      range = sheet.getRangeByName('C20');
      range.setText('Mark');
      range = sheet.getRangeByName('D20');
      range.setFormula('=VLOOKUP(D19,C2:D10,2,0)');
      expect(range.calculatedValue, '98.0');

      // Formula calculation is enabled for the sheet.
      sheet1.enableSheetCalculations();
      // Approximate Match
      Range range1 = sheet1.getRangeByName('A1');
      range1.setText('ID');
      range1 = sheet1.getRangeByName('B1');
      range1.setNumber(55);
      range1 = sheet1.getRangeByName('A2');
      range1.setText('F Name');
      range1 = sheet1.getRangeByName('B2');
      range1.setFormula('=VLOOKUP(B1,Sheet1!A2:D10,2)');
      expect(range1.calculatedValue, 'John');
      range1 = sheet1.getRangeByName('A3');
      range1.setText('L Name');
      range1 = sheet1.getRangeByName('B3');
      range1.setFormula('=VLOOKUP(B2,Sheet1!B2:D10,2,1)');
      expect(range1.calculatedValue, 'Cena');
      range1 = sheet1.getRangeByName('A4');
      range1.setText('Mark');
      range1 = sheet1.getRangeByName('B4');
      range1.setFormula('=VLOOKUP(B2,Sheet1!B2:D10,3,TRUE)');
      expect(range1.calculatedValue, '40.0');

      // Exact Match
      range1 = sheet1.getRangeByName('A6');
      range1.setText('ID');
      range1 = sheet1.getRangeByName('B6');
      range1.setNumber(33);
      range1 = sheet1.getRangeByName('A7');
      range1.setText('F Name');
      range1 = sheet1.getRangeByName('B7');
      range1.setFormula('=VLOOKUP(B6,Sheet1!A2:D10,2,FALSE)');
      expect(range1.calculatedValue, 'James');
      range1 = sheet1.getRangeByName('A8');
      range1.setText('L Name');
      range1 = sheet1.getRangeByName('B8');
      range1.setFormula('=VLOOKUP(Sheet1!A4,Sheet1!A2:D10,3,0)');
      expect(range1.calculatedValue, 'Mark');
      range1 = sheet1.getRangeByName('A9');
      range1.setText('Mark');
      range1 = sheet1.getRangeByName('B9');
      range1.setFormula('=VLOOKUP(Sheet1!A4,Sheet1!A2:D10,4,0)');
      expect(range1.calculatedValue, '48.0');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelVLookUPFuc.xlsx');
      workbook.dispose();
    });

    test('SumIF', () {
      final Workbook workbook = Workbook();

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // // set the value to the cell.
      sheet.getRangeByName('A1').setText('Category');
      sheet.getRangeByName('A2').setText('Veg');
      sheet.getRangeByName('A3').setText('Veg');
      sheet.getRangeByName('A4').setText('Fruits');
      sheet.getRangeByName('A5').setText('Other');
      sheet.getRangeByName('A6').setText('Fruits');
      sheet.getRangeByName('A7').setText('Veg');
      sheet.getRangeByName('A8').setText('Other');
      sheet.getRangeByName('A9').setText('Veg');
      sheet.getRangeByName('A10').setText('Fruits');
      sheet.getRangeByName('B1').setText('Items');
      sheet.getRangeByName('B2').setText('Tomato');
      sheet.getRangeByName('B3').setText('Onion');
      sheet.getRangeByName('B4').setText('Apple');
      sheet.getRangeByName('B5').setText('Butter');
      sheet.getRangeByName('B6').setText('Orange');
      sheet.getRangeByName('B7').setText('Carrot');
      sheet.getRangeByName('B8').setText('Honey');
      sheet.getRangeByName('B9').setText('Tomato');
      sheet.getRangeByName('B10').setText('Apple');
      sheet.getRangeByName('C1').setText('Qty');
      sheet.getRangeByName('C2').setNumber(2);
      sheet.getRangeByName('C3').setNumber(5);
      sheet.getRangeByName('C4').setNumber(10);
      sheet.getRangeByName('C5').setNumber(8);
      sheet.getRangeByName('C6').setNumber(6);
      sheet.getRangeByName('C7').setNumber(12);
      sheet.getRangeByName('C8').setNumber(4);
      sheet.getRangeByName('C9').setNumber(5);
      sheet.getRangeByName('C10').setNumber(7);
      sheet.getRangeByName('D1').setText('Amount');
      sheet.getRangeByName('D2').setNumber(100);
      sheet.getRangeByName('D3').setNumber(350);
      sheet.getRangeByName('D4').setNumber(1000);
      sheet.getRangeByName('D5').setNumber(500);
      sheet.getRangeByName('D6').setNumber(400);
      sheet.getRangeByName('D7').setNumber(742);
      sheet.getRangeByName('D8').setNumber(800);
      sheet.getRangeByName('D9').setNumber(250);
      sheet.getRangeByName('D10').setNumber(849);

      // Formula calculation is enabled for the sheet.
      sheet.enableSheetCalculations();

      // Setting formula in the cell.
      Range range = sheet.getRangeByName('D12');
      range.setFormula('=SUMIF(A2:A10,A9,D2:D10)');
      expect(range.calculatedValue, '1442.0');
      range = sheet.getRangeByName('D13');
      range.setFormula('=SUMIF(B2:B10,B9,C2:C10)');
      expect(range.calculatedValue, '7.0');
      range = sheet.getRangeByName('D14');
      range.setFormula('=SUMIF(A2:A10,"Fruits",D2:D10)');
      expect(range.calculatedValue, '2249.0');
      range = sheet.getRangeByName('D15');
      range.setFormula('=SUMIF(B2:B10,"*o",D2:D10)');
      expect(range.calculatedValue, '350.0');
      range = sheet.getRangeByName('D16');
      range.setFormula('=SUMIF(C2:C10,">=10",D2:D10)');
      expect(range.calculatedValue, '1742.0');
      range = sheet.getRangeByName('D17');
      range.setFormula('=SUMIF(C2:D10,">5",D2:D10)');
      expect(range.calculatedValue, '3491.0');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSumIFFunc.xlsx');
      workbook.dispose();
    });

    test('SumProduct', () {
      final Workbook workbook = Workbook(2);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[1];

      // set the value to the cell.
      sheet.getRangeByName('A1').setText('Category');
      sheet.getRangeByName('A2').setText('Apple');
      sheet.getRangeByName('A3').setText('Orange');
      sheet.getRangeByName('A4').setText('Grapes');
      sheet.getRangeByName('A5').setText('Pineapple');
      sheet.getRangeByName('A6').setText('Mango');
      sheet.getRangeByName('A7').setText('Grapes');
      sheet.getRangeByName('A8').setText('Orange');
      sheet.getRangeByName('A9').setText('Mango');
      sheet.getRangeByName('A10').setText('Apple');
      sheet.getRangeByName('A11').setText('Mango');
      sheet.getRangeByName('B1').setText('Qty');
      sheet.getRangeByName('B2').setNumber(4);
      sheet.getRangeByName('B3').setNumber(9);
      sheet.getRangeByName('B4').setNumber(10);
      sheet.getRangeByName('B5').setNumber(7.5);
      sheet.getRangeByName('B6').setNumber(15);
      sheet.getRangeByName('B7').setNumber(6);
      sheet.getRangeByName('B8').setNumber(13);
      sheet.getRangeByName('B9').setNumber(17);
      sheet.getRangeByName('B10').setNumber(6.5);
      sheet.getRangeByName('B11').setNumber(3);
      sheet.getRangeByName('C1').setText('UnitPrice');
      sheet.getRangeByName('C2').setNumber(94.5);
      sheet.getRangeByName('C3').setNumber(58);
      sheet.getRangeByName('C4').setNumber(43);
      sheet.getRangeByName('C5').setNumber(38);
      sheet.getRangeByName('C6').setNumber(60);
      sheet.getRangeByName('C7').setNumber(43);
      sheet.getRangeByName('C8').setNumber(58);
      sheet.getRangeByName('C9').setNumber(60);
      sheet.getRangeByName('C10').setNumber(94.5);
      sheet.getRangeByName('C11').setNumber(60);

      // Formula calculation is enabled for the sheet.
      sheet.enableSheetCalculations();

      // Setting formula in the cell.
      Range range = sheet.getRangeByName('B14');
      range.text = 'Total';
      range = sheet.getRangeByName('C14');
      range.setFormula('=SUMPRODUCT(B2:B11,C2:C11)');
      expect(range.calculatedValue, '5341.25');
      range = sheet.getRangeByName('B15');
      range.text = 'Apple';
      range = sheet.getRangeByName('C15');
      range.setFormula('=SUMPRODUCT(--(A2:A11="Apple"), B2:B11, C2:C11)');
      expect(range.calculatedValue, '992.25');
      range = sheet.getRangeByName('B16');
      range.text = 'Mango>3';
      range = sheet.getRangeByName('C16');
      range.setFormula('=SUMPRODUCT((A2:A11=A11)*(B2:B11>3)*(C2:C11))');
      expect(range.calculatedValue, '#VALUE!');
      range = sheet.getRangeByName('B17');
      range.text = 'Orange';
      range = sheet.getRangeByName('C17');
      range.setFormula('=SUMPRODUCT(--(A2:A11="Orange"), B2:B11,C2:C11)');
      expect(range.calculatedValue, '1276.0');

      // Formula calculation is enabled for the sheet.
      sheet1.enableSheetCalculations();
      // Setting formula in the cell.
      Range range1 = sheet1.getRangeByName('A1');
      range1.text = 'Grapes';
      range1 = sheet1.getRangeByName('B1');
      range1.setFormula(
          '=SUMPRODUCT(--(Sheet1!A2:A11="Grapes"),Sheet1!B2:B11,Sheet1!C2:C11)');
      expect(range1.calculatedValue, '688.0');
      range1 = sheet1.getRangeByName('A2');
      range1.text = 'Values';
      range1 = sheet1.getRangeByName('B2');
      range1.setFormula('=SUMPRODUCT({2,2,2},{4,4,4})');
      expect(range1.calculatedValue, '24.0');
      range1 = sheet1.getRangeByName('B3');
      range1.setFormula('=SUMPRODUCT({FALSE,TRUE,FALSE},{FALSE,FALSE,FALSE})');
      expect(range1.calculatedValue, '0.0');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelSumProductFunc.xlsx');
      workbook.dispose();
    });
    test('Product', () {
      final Workbook workbook = Workbook(1);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet2 = workbook.worksheets.add();

      // set the value to the cell.
      sheet.getRangeByName('A1').number = 2;
      sheet.getRangeByName('B1').number = 3;
      sheet.getRangeByName('A2').number = 5;
      sheet.getRangeByName('B2').number = 4;
      sheet.getRangeByName('A3').number = 6;
      sheet.getRangeByName('B3').number = 7;
      sheet.getRangeByName('A4').number = 9;
      sheet.getRangeByName('B4').number = 8;
      sheet.getRangeByName('C1').text = 'Hi';

      // Formula calculation is enabled for the sheet.
      sheet.enableSheetCalculations();

      // Setting formula in the cell.
      Range range = sheet.getRangeByName('A7');
      range.formula = '=PRODUCT(A1:A4,B1:B4)';
      expect(range.calculatedValue, '362880.0');
      range = sheet.getRangeByName('A8');
      range.formula = 'PRODUCT(A1,C1)';
      expect(range.calculatedValue, '2.0');
      range = sheet.getRangeByName('A9');
      range.formula = 'TRUE';
      expect(range.calculatedValue, 'TRUE');
      range = sheet.getRangeByName('A10');
      range.formula = '=PRODUCT(B1,A9)';
      expect(range.calculatedValue, '3.0');
      range = sheet.getRangeByName('A11');
      range.formula = '=PRODUCT(B3,FALSE)';
      expect(range.calculatedValue, '0.0');

      range = sheet2.getRangeByName('A1');
      range.formula = '=PRODUCT(Sheet1!A1:A4)';
      expect(range.calculatedValue, '540.0');
      range = sheet2.getRangeByName('A2');
      range.formula = '=PRODUCT(Sheet1!A3:Sheet1!A4,Sheet1!B3:Sheet1!B4)';
      expect(range.calculatedValue, '3024.0');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelProductFunc.xlsx');
      workbook.dispose();
    });
    test('FLUT_3960', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet1 = workbook.worksheets[0];

      // This sheet has a space in its name.
      sheet1.name = 'Sheet 1';
      final Worksheet sheet2 = workbook.worksheets.addWithName('Sheet 2');

      // This sheet has no space in its name.
      final Worksheet sheet3 = workbook.worksheets.addWithName('Sheet3');

      // Enable calculation for worksheet.
      sheet1.enableSheetCalculations();
      sheet1.getRangeByIndex(1, 1).setNumber(3.14159);

      sheet2.enableSheetCalculations();
      // Try to access sheet 1, cell A1. This fails.
      sheet2.getRangeByIndex(1, 1).setFormula("='Sheet 1'!A1");

      // Try to access sheet 3, cell A1. This succeeds.
      sheet2.getRangeByIndex(1, 2).setFormula('=Sheet3!A1');

      sheet3.enableSheetCalculations();
      sheet3.getRangeByIndex(1, 1).setNumber(2.71828);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT_3960.xlsx');
      workbook.dispose();
    });
    test('Row', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook();

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];
      sheet.enableSheetCalculations();

      sheet.getRangeByName('A2').setFormula('=ROW()');
      sheet.getRangeByName('A4').setFormula('=ROW(A7)');

      sheet.getRangeByName('C2').setFormula('=ROW(A1:A5)');
      sheet.getRangeByName('C4').setFormula('=@ROW(A1:A5)');

      Range range = sheet.getRangeByName('E2');
      range.formula = '=ROW(F12)';
      range = sheet.getRangeByName('E4');
      range.formula = '=ROW() - Row(F3)';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT-6581.xlsx');
      workbook.dispose();
    });
  });
}
