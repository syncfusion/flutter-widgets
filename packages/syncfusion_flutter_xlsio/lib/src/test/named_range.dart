// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

/// Named range
void xlsioNamedRange() {
  group('Named range support', () {
    // Multiple named ranges in difrent worksheets and workbook
    test('FLUT-6973_1', () {
      final Workbook workbook = Workbook(3);
      final Worksheet sheet1 = workbook.worksheets[0];
      final Worksheet sheet2 = workbook.worksheets[1];
      final Worksheet sheet3 = workbook.worksheets[2];
      // Multiple named ranges in difrent worksheets and workbook
      // Sheet1
      sheet1.getRangeByName('A1:D4').setText('Sheet1Txt');
      final Range range1 = sheet1.getRangeByName('A1:C1');
      final Range range2 = sheet1.getRangeByName('A2:C2');
      final Range range3 = sheet1.getRangeByName('A3:C3');
      final Range range4 = sheet1.getRangeByName('A4:C4');
      sheet1.names.add('Sheet1Name1', range1);
      sheet1.names.add('Sheet1Name2', range2);
      sheet1.names.add('Sheet1Name3', range3);
      workbook.names.add('BookName1', range4);
      // Sheet2
      sheet2.getRangeByName('A1:D4').setText('Sheet2Txt');
      final Range range5 = sheet2.getRangeByName('A1:C1');
      final Range range6 = sheet2.getRangeByName('A2:C2');
      final Range range7 = sheet2.getRangeByName('A3:C3');
      final Range range8 = sheet2.getRangeByName('A4:C4');
      sheet2.names.add('Sheet2Name1', range5);
      sheet2.names.add('Sheet2Name2', range6);
      sheet2.names.add('Sheet2Name3', range7);
      workbook.names.add('BookName2', range8);
      // Sheet 3
      sheet3.getRangeByName('A1:D4').setText('Sheet3Txt');
      final Range range9 = sheet3.getRangeByName('A1:C1');
      final Range range10 = sheet3.getRangeByName('A2:C2');
      final Range range11 = sheet3.getRangeByName('A3:C3');
      final Range range12 = sheet3.getRangeByName('A4:C4');
      sheet3.names.add('Sheet3Name1', range9);
      sheet3.names.add('Sheet3Name2', range10);
      sheet3.names.add('Sheet3Name3', range11);
      workbook.names.add('BookName3', range12);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT-6973_1.xlsx');
      workbook.dispose();
    });
    // Add named range for workbook
    test('FLUT-6973_2', () {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet1 = workbook.worksheets[0];
      final Worksheet sheet2 = workbook.worksheets[1];
      sheet1.getRangeByName('A1:G1').number = 10;
      sheet1.getRangeByName('A2:G2').number = 20;
      sheet1.getRangeByName('A3:G3').number = 25;
      final Range range1 = sheet1.getRangeByName('A1');
      final Range range2 = sheet1.getRangeByName('A2');
      final Range range3 = sheet1.getRangeByName('A3');
      workbook.names.add('NumberOne', range1);
      workbook.names.add('NumberTwo', range2);
      workbook.names.add('NumberThree', range3);
      final Range range4 = sheet1.getRangeByName('B1:B3');
      workbook.names.add('namedRange', range4);
      final Range range5 = sheet1.getRangeByName('C1');
      final Range range6 = sheet1.getRangeByName('C2');
      workbook.names.add('FirstNumber', range5);
      workbook.names.add('SecondNumber', range6);
      // // Formula
      final Range rangeFormula1 = sheet1.getRangeByIndex(4, 1);
      rangeFormula1.formula = '=NumberOne-NumberTwo+NumberThree';
      final Range rangeFormula2 = sheet1.getRangeByIndex(4, 2);
      rangeFormula2.formula = '=SUM(namedRange)';
      final Range rangeFormula3 = sheet1.getRangeByIndex(4, 3);
      rangeFormula3.formula = '=FirstNumber>SecondNumber';
      final Range rangeFormula4 = sheet1.getRangeByIndex(4, 4);
      rangeFormula4.formula = '=IF(FirstNumber<SecondNumber, "Yes", "No")';
      final Range rangeFormula5 = sheet1.getRangeByIndex(4, 5);
      rangeFormula5.formula = '=-NumberOne';
      final Range rangeFormula6 = sheet1.getRangeByIndex(4, 6);
      rangeFormula6.formula = '=AVERAGE(namedRange)';
      final Range rangeFormula7 = sheet1.getRangeByIndex(4, 7);
      rangeFormula7.formula = '=COUNT(namedRange)';
      // // Formulas in sheet2
      final Range range2Formula = sheet2.getRangeByIndex(1, 1);
      range2Formula.formula = '=NumberOne-NumberTwo+NumberThree';
      final Range range2Formula2 = sheet2.getRangeByIndex(1, 2);
      range2Formula2.formula = '=SUM(namedRange)';
      final Range range2Formula3 = sheet2.getRangeByIndex(1, 3);
      range2Formula3.formula = '=FirstNumber>SecondNumber';
      final Range range2Formula4 = sheet2.getRangeByIndex(1, 4);
      range2Formula4.formula = '=IF(FirstNumber<SecondNumber, "Yes", "No")';
      final Range range2Formula5 = sheet2.getRangeByIndex(1, 5);
      range2Formula5.formula = '=-NumberOne';
      final Range range2Formula6 = sheet2.getRangeByIndex(1, 6);
      range2Formula6.formula = '=AVERAGE(namedRange)';
      final Range range2Formula7 = sheet2.getRangeByIndex(1, 7);
      range2Formula7.formula = '=COUNT(namedRange)';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT-6973_2.xlsx');
      workbook.dispose();
    });
    // Add named range for workbook
    test('FLUT-6973_3', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      // Add named range for worksheet
      final Name nameRange = workbook.names.add('Title');
      // Add range
      nameRange.refersToRange = worksheet.getRangeByName('A1:C1');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT-6973_3.xlsx');
      workbook.dispose();
    });
    // Delete a named range
    test('FLUT-6973_4', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet.getRangeByName('A1:C1');
      final Range range2 = worksheet.getRangeByName('A2:C2');
      final Range range3 = worksheet.getRangeByName('A3:C3');
      final Range range4 = worksheet.getRangeByName('A4:C4');
      worksheet.names.add('named1', range1);
      final Name name2 = worksheet.names.add('named2', range2);
      worksheet.names.add('named3', range3);
      worksheet.names.add('named4', range4);
      // Delete named range
      name2.delete();

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT-6973_4.xlsx');
      workbook.dispose();
    });
    // Remove named range with name
    test('FLUT-6973_5', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet.getRangeByName('A1:C1');
      final Range range2 = worksheet.getRangeByName('A2:C2');
      final Range range3 = worksheet.getRangeByName('A3:C3');
      final Range range4 = worksheet.getRangeByName('A4:C4');
      worksheet.names.add('named1', range1);
      worksheet.names.add('named2', range2);
      worksheet.names.add('named3', range3);
      worksheet.names.add('named4', range4);
      // Remove named range with name
      worksheet.names.remove('named3');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT-6973_5.xlsx');
      workbook.dispose();
    });
    // Remove named range with index
    test('FLUT-6973_6', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet.getRangeByName('A1:C1');
      final Range range2 = worksheet.getRangeByName('A2:C2');
      final Range range3 = worksheet.getRangeByName('A3:C3');
      final Range range4 = worksheet.getRangeByName('A4:C4');
      worksheet.names.add('named1', range1);
      worksheet.names.add('named2', range2);
      worksheet.names.add('named3', range3);
      worksheet.names.add('named4', range4);
      // Remove named range with index
      worksheet.names.removeAt(0);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT-6973_6.xlsx');
      workbook.dispose();
    });
    // Get named ranges count
    test('FLUT-6973_7', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet.getRangeByName('A1:C1');
      final Range range2 = worksheet.getRangeByName('A2:C2');
      workbook.names.add('Title', range1);
      worksheet.names.add('Body', range2);
      // Get named ranges count
      final int sheetCount = worksheet.names.count;
      final int bookCount = workbook.names.count;
      assert(sheetCount == 1 && bookCount == 2);
      workbook.dispose();
    });
    // Get parent worksheet
    test('FLUT-6973_8', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet.getRangeByName('A1:C1');
      final Range range2 = worksheet.getRangeByName('A2:C2');
      workbook.names.add('Title', range1);
      worksheet.names.add('Body', range2);
      // Get parent worksheet
      final Worksheet sheet1 = worksheet.names.parentWorksheet;
      final Worksheet sheet2 = workbook.names.parentWorksheet;

      assert(sheet1 == worksheet && sheet2 == worksheet);
      workbook.dispose();
    });
    // Set description
    test('FLUT-6973_9', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet.getRangeByName('A1:C1');
      final Range range2 = worksheet.getRangeByName('A2:C2');
      final Name name1 = workbook.names.add('Title', range1);
      final Name name2 = worksheet.names.add('Body', range2);
      // Set description
      name1.description = 'This is title';
      name2.description = 'This is body';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT-6973_10.xlsx');
      workbook.dispose();
    });
    // Hidden the named range
    test('FLUT-6973_10', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet.getRangeByName('A1:C1');
      final Range range2 = worksheet.getRangeByName('A2:C2');
      final Name name1 = workbook.names.add('Title', range1);
      worksheet.names.add('Body', range2);
      // Hidden the named range
      name1.isVisible = false;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'FLUT-6973_11.xlsx');
      workbook.dispose();
    });
    // Check the name of named range
    test('FLUT-6973_11', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet.getRangeByName('A1:C1');
      final Range range2 = worksheet.getRangeByName('A2:C2');
      final Name name1 = workbook.names.add('Title', range1);
      final Name name2 = worksheet.names.add('Body', range2);
      // Check the name of named range
      final String nameing1 = name1.name;
      final String nameing2 = name2.name;
      assert(nameing1 == 'Title' && nameing2 == 'Body');
      workbook.dispose();
    });
    // Check index of named range
    test('FLUT-6973_12', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet.getRangeByName('A1:C1');
      final Range range2 = worksheet.getRangeByName('A2:C2');
      final Name name1 = workbook.names.add('Title', range1);
      final Name name2 = worksheet.names.add('Body', range2);
      // Check index of named range
      final int index1 = name1.index;
      final int index2 = name2.index;
      assert(index1 == 0 && index2 == 1);
      workbook.dispose();
    });
    // Check scope of named range
    test('FLUT-6973_13', () {
      final Workbook workbook = Workbook();
      final Worksheet worksheet = workbook.worksheets[0];
      worksheet.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet.getRangeByName('A1:C1');
      final Range range2 = worksheet.getRangeByName('A2:C2');
      final Name name1 = workbook.names.add('Title', range1);
      final Name name2 = worksheet.names.add('Body', range2);
      // Check scope of named range
      final String scope1 = name1.scope;
      final String scope2 = name2.scope;
      assert(scope1 == 'workbook' && scope2 == 'Sheet1');
      workbook.dispose();
    });
    // Check parent worksheet
    test('FLUT-6973_14', () {
      final Workbook workbook = Workbook(2);
      final Worksheet worksheet1 = workbook.worksheets[0];
      final Worksheet worksheet2 = workbook.worksheets[1];
      worksheet1.getRangeByName('A1:D4').setText('Hello');
      final Range range1 = worksheet1.getRangeByName('A1:C1');
      final Name name1 = worksheet1.names.add('named1', range1);

      worksheet2.getRangeByName('A1:D4').setText('Hello');
      final Range range2 = worksheet2.getRangeByName('A1:D1');
      final Name name2 = worksheet2.names.add('named2', range2);
      // Check parent worksheet
      final Worksheet checkSheet1 = name1.worksheet;
      final Worksheet checkSheet2 = name2.worksheet;
      assert(checkSheet1 == worksheet1 && checkSheet2 == worksheet2);
      workbook.dispose();
    });
  });
}
