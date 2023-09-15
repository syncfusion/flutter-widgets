import 'dart:ui';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioConditionalFormatting() {
  group('Conditional Formatting', () {
    group('CellValues', () {
      test('Between', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A4').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.between;
        condition1.firstFormula = '10';
        condition1.secondFormula = '20';
        condition1.backColor = '#209301';
        condition1.fontColor = '#FFFFFF';
        condition1.isBold = true;
        condition1.isItalic = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.double;
        condition1.bottomBorderColor = '#738911';
        sheet.getRangeByIndex(1, 1).number = 16;
        sheet.getRangeByIndex(2, 1).number = 18;
        sheet.getRangeByIndex(3, 1).number = 12;
        sheet.getRangeByIndex(4, 1).number = 10;

        // Applying conditional formatting.
        final ConditionalFormats conditions1 =
            sheet.getRangeByName('B1:B8').conditionalFormats;
        final ConditionalFormat condition2 = conditions1.addCondition();
        condition2.formatType = ExcelCFType.cellValue;
        condition2.operator = ExcelComparisonOperator.between;
        condition2.firstFormula = r'=$A$4';
        condition2.secondFormula = r'=$A$2';
        condition2.backColor = '#382102';
        condition2.fontColor = '#FF328F';
        condition2.isBold = true;
        condition2.isItalic = true;
        condition2.underline = true;
        condition2.rightBorderStyle = LineStyle.thick;
        condition2.rightBorderColor = '#20099F';
        condition2.numberFormat = '0.00';

        sheet.getRangeByIndex(1, 2).number = 12;
        sheet.getRangeByIndex(2, 2).number = 19;
        sheet.getRangeByIndex(3, 2).number = 11;
        sheet.getRangeByIndex(4, 2).number = 14;
        sheet.getRangeByIndex(5, 2).number = 10;
        sheet.getRangeByIndex(6, 2).number = 12;
        sheet.getRangeByIndex(7, 2).number = 13;
        sheet.getRangeByIndex(8, 2).number = 20;

        condition1.backColor = '#7AD223';
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFCellValueBetween.xlsx');
        workbook.dispose();
      });
      test('Not Between', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:B4').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.notBetween;
        condition1.firstFormula = '25+5';
        condition1.secondFormula = '65';
        condition1.backColor = '#AAFFDD';
        condition1.fontColor = '#F378A4';
        condition1.isItalic = true;
        condition1.bottomBorderStyle = LineStyle.double;
        condition1.bottomBorderColor = '#738911';
        sheet.getRangeByIndex(1, 1).number = 20;
        sheet.getRangeByIndex(2, 1).number = 38;
        sheet.getRangeByIndex(3, 1).number = 16;
        sheet.getRangeByIndex(4, 1).number = 76;
        sheet.getRangeByIndex(1, 2).number = 90;
        sheet.getRangeByIndex(2, 2).number = 55;
        sheet.getRangeByIndex(3, 2).number = 82;
        sheet.getRangeByIndex(4, 2).number = 4;

        // Applying conditional formatting.
        final ConditionalFormats conditions1 =
            sheet.getRangeByName('E1:G2').conditionalFormats;
        final ConditionalFormat condition2 = conditions1.addCondition();
        condition2.formatType = ExcelCFType.cellValue;
        condition2.operator = ExcelComparisonOperator.notBetween;
        condition2.firstFormula = r'$B$4';
        condition2.secondFormula = r'$A$2';
        condition2.backColor = '#98AAEE';
        condition2.fontColor = '#DDDEEE';
        condition2.isItalic = true;
        condition2.rightBorderStyle = LineStyle.thin;
        condition2.rightBorderColor = '#FFFAAA';
        condition2.numberFormat = '0.0';

        sheet.getRangeByIndex(1, 5).number = 39;
        sheet.getRangeByIndex(2, 5).number = 10;
        sheet.getRangeByIndex(1, 6).number = 100;
        sheet.getRangeByIndex(2, 6).number = 56;
        sheet.getRangeByIndex(1, 7).number = 25;
        sheet.getRangeByIndex(2, 7).number = 70;

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFCellValueNotBetween.xlsx');
        workbook.dispose();
      });
      test('Equal', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('D1:D20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.equal;
        condition1.firstFormula = '16';
        condition1.backColor = '#DDFFAA';
        condition1.fontColor = '#2D37FF';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#24599A';
        condition1.topBorderStyle = LineStyle.medium;
        condition1.topBorderColor = '#24599A';
        condition1.rightBorderStyle = LineStyle.medium;
        condition1.rightBorderColor = '#24599A';
        condition1.leftBorderStyle = LineStyle.medium;
        condition1.leftBorderColor = '#24599A';

        conditions = sheet.getRangeByName('A1:A4').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.equal;
        condition1.firstFormula = "'M'";
        condition1.backColor = '#DDCCEE';

        sheet.getRangeByIndex(1, 4).number = 56;
        sheet.getRangeByIndex(2, 4).number = 16;
        sheet.getRangeByIndex(3, 4).number = 7;
        sheet.getRangeByIndex(4, 4).number = 16;
        sheet.getRangeByIndex(5, 4).number = 50;
        sheet.getRangeByIndex(6, 4).number = 47;
        sheet.getRangeByIndex(7, 4).number = 16;
        sheet.getRangeByIndex(8, 4).number = 16;
        sheet.getRangeByIndex(9, 4).number = 23;
        sheet.getRangeByIndex(10, 4).number = 16;
        sheet.getRangeByIndex(11, 4).number = 13;
        sheet.getRangeByIndex(12, 4).number = 12;
        sheet.getRangeByIndex(13, 4).number = 16;
        sheet.getRangeByIndex(14, 4).number = 16;
        sheet.getRangeByIndex(15, 4).number = 16;
        sheet.getRangeByIndex(16, 4).number = 16;
        sheet.getRangeByIndex(17, 4).number = 23;
        sheet.getRangeByIndex(18, 4).number = 10;
        sheet.getRangeByIndex(19, 4).number = 13;
        sheet.getRangeByIndex(20, 4).number = 16;

        sheet.getRangeByIndex(1, 1).setText('M');
        sheet.getRangeByIndex(2, 1).setText('Z');
        sheet.getRangeByIndex(3, 1).number = 7;
        sheet.getRangeByIndex(4, 1).setText('M');

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFCellValueEqual.xlsx');
        workbook.dispose();
      });
      test('Not Equal', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('D1:D20').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.notEqual;
        condition1.firstFormula = '16';
        condition1.backColor = '#DDFFAA';
        condition1.fontColor = '#2D37FF';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#24599A';
        condition1.topBorderStyle = LineStyle.medium;
        condition1.topBorderColor = '#24599A';
        condition1.rightBorderStyle = LineStyle.medium;
        condition1.rightBorderColor = '#24599A';
        condition1.leftBorderStyle = LineStyle.medium;
        condition1.leftBorderColor = '#24599A';
        sheet.getRangeByIndex(1, 4).number = 56;
        sheet.getRangeByIndex(2, 4).number = 16;
        sheet.getRangeByIndex(3, 4).number = 7;
        sheet.getRangeByIndex(4, 4).number = 16;
        sheet.getRangeByIndex(5, 4).number = 50;
        sheet.getRangeByIndex(6, 4).number = 47;
        sheet.getRangeByIndex(7, 4).number = 16;
        sheet.getRangeByIndex(8, 4).number = 16;
        sheet.getRangeByIndex(9, 4).number = 23;
        sheet.getRangeByIndex(10, 4).number = 16;
        sheet.getRangeByIndex(11, 4).number = 13;
        sheet.getRangeByIndex(12, 4).number = 12;
        sheet.getRangeByIndex(13, 4).number = 16;
        sheet.getRangeByIndex(14, 4).number = 16;
        sheet.getRangeByIndex(15, 4).number = 16;
        sheet.getRangeByIndex(16, 4).number = 16;
        sheet.getRangeByIndex(17, 4).number = 23;
        sheet.getRangeByIndex(18, 4).number = 10;
        sheet.getRangeByIndex(19, 4).number = 13;
        sheet.getRangeByIndex(20, 4).number = 16;

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFCellValueNotEqual.xlsx');
        workbook.dispose();
      });
      test('Greater', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('B1:B20').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.greater;
        condition1.firstFormula = '22';
        condition1.backColor = '#30DD93';
        condition1.fontColor = '#43410D';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#EEFFCC';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#2D23D2';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#162216';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#DEAEA1';

        sheet.getRangeByIndex(1, 2).number = 12;
        sheet.getRangeByIndex(2, 2).number = 22;
        sheet.getRangeByIndex(3, 2).number = 26;
        sheet.getRangeByIndex(4, 2).number = 13;
        sheet.getRangeByIndex(5, 2).number = 34;
        sheet.getRangeByIndex(6, 2).number = 42;
        sheet.getRangeByIndex(7, 2).number = 11;
        sheet.getRangeByIndex(8, 2).number = 36;
        sheet.getRangeByIndex(9, 2).number = 43;
        sheet.getRangeByIndex(10, 2).number = 1;
        sheet.getRangeByIndex(11, 2).number = 23;
        sheet.getRangeByIndex(12, 2).number = 15;
        sheet.getRangeByIndex(13, 2).number = 34;
        sheet.getRangeByIndex(14, 2).number = 44;
        sheet.getRangeByIndex(15, 2).number = 30;
        sheet.getRangeByIndex(16, 2).number = 4;
        sheet.getRangeByIndex(17, 2).number = 42;
        sheet.getRangeByIndex(18, 2).number = 55;
        sheet.getRangeByIndex(19, 2).number = 14;
        sheet.getRangeByIndex(20, 2).number = 6;

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFCellValueGreater.xlsx');
        workbook.dispose();
      });
      test('Less', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('B1:B20').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.less;
        condition1.firstFormula = '40';
        condition1.backColor = '#30DD93';
        condition1.fontColor = '#43410D';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#EEFFCC';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#2D23D2';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#162216';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#DEAEA1';

        // Applying conditional formatting.
        final ConditionalFormats conditions2 =
            sheet.getRangeByName('B1:B20').conditionalFormats;
        final ConditionalFormat condition2 = conditions2.addCondition();
        condition2.formatType = ExcelCFType.cellValue;
        condition2.operator = ExcelComparisonOperator.greater;
        condition2.firstFormula = '40';
        condition2.backColor = '#EEEAAA';

        sheet.getRangeByIndex(1, 2).number = 12;
        sheet.getRangeByIndex(2, 2).number = 22;
        sheet.getRangeByIndex(3, 2).number = 26;
        sheet.getRangeByIndex(4, 2).number = 13;
        sheet.getRangeByIndex(5, 2).number = 34;
        sheet.getRangeByIndex(6, 2).number = 42;
        sheet.getRangeByIndex(7, 2).number = 11;
        sheet.getRangeByIndex(8, 2).number = 36;
        sheet.getRangeByIndex(9, 2).number = 43;
        sheet.getRangeByIndex(10, 2).number = 1;
        sheet.getRangeByIndex(11, 2).number = 23;
        sheet.getRangeByIndex(12, 2).number = 15;
        sheet.getRangeByIndex(13, 2).number = 34;
        sheet.getRangeByIndex(14, 2).number = 44;
        sheet.getRangeByIndex(15, 2).number = 30;
        sheet.getRangeByIndex(16, 2).number = 4;
        sheet.getRangeByIndex(17, 2).number = 42;
        sheet.getRangeByIndex(18, 2).number = 55;
        sheet.getRangeByIndex(19, 2).number = 14;
        sheet.getRangeByIndex(20, 2).number = 6;

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFCellValueLess.xlsx');
        workbook.dispose();
      });
      test('Greater or Equal', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('B1:B20').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.greaterOrEqual;
        condition1.firstFormula = '24';
        condition1.backColor = '#45AA44';
        condition1.fontColor = '#E798FA';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#EEDDCC';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#2D23D2';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#162216';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#DEAEA1';

        sheet.getRangeByIndex(1, 2).number = 12;
        sheet.getRangeByIndex(2, 2).number = 24;
        sheet.getRangeByIndex(3, 2).number = 26;
        sheet.getRangeByIndex(4, 2).number = 13;
        sheet.getRangeByIndex(5, 2).number = 34;
        sheet.getRangeByIndex(6, 2).number = 42;
        sheet.getRangeByIndex(7, 2).number = 11;
        sheet.getRangeByIndex(8, 2).number = 36;
        sheet.getRangeByIndex(9, 2).number = 43;
        sheet.getRangeByIndex(10, 2).number = 1;
        sheet.getRangeByIndex(11, 2).number = 24;
        sheet.getRangeByIndex(12, 2).number = 15;
        sheet.getRangeByIndex(13, 2).number = 34;
        sheet.getRangeByIndex(14, 2).number = 44;
        sheet.getRangeByIndex(15, 2).number = 30;
        sheet.getRangeByIndex(16, 2).number = 4;
        sheet.getRangeByIndex(17, 2).number = 42;
        sheet.getRangeByIndex(18, 2).number = 55;
        sheet.getRangeByIndex(19, 2).number = 14;
        sheet.getRangeByIndex(20, 2).number = 6;

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFCellValueGreaterOrEqual.xlsx');
        workbook.dispose();
      });
      test('Less or Equal', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('B1:B20').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.lessOrEqual;
        condition1.firstFormula = '40';
        condition1.backColor = '#45AA44';
        condition1.fontColor = '#E798FA';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#EEDDCC';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#2D23D2';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#162216';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#DEAEA1';

        sheet.getRangeByIndex(1, 2).number = 12;
        sheet.getRangeByIndex(2, 2).number = 24;
        sheet.getRangeByIndex(3, 2).number = 26;
        sheet.getRangeByIndex(4, 2).number = 40;
        sheet.getRangeByIndex(5, 2).number = 34;
        sheet.getRangeByIndex(6, 2).number = 42;
        sheet.getRangeByIndex(7, 2).number = 11;
        sheet.getRangeByIndex(8, 2).number = 36;
        sheet.getRangeByIndex(9, 2).number = 43;
        sheet.getRangeByIndex(10, 2).number = 1;
        sheet.getRangeByIndex(11, 2).number = 24;
        sheet.getRangeByIndex(12, 2).number = 15;
        sheet.getRangeByIndex(13, 2).number = 34;
        sheet.getRangeByIndex(14, 2).number = 44;
        sheet.getRangeByIndex(15, 2).number = 30;
        sheet.getRangeByIndex(16, 2).number = 40;
        sheet.getRangeByIndex(17, 2).number = 42;
        sheet.getRangeByIndex(18, 2).number = 55;
        sheet.getRangeByIndex(19, 2).number = 14;
        sheet.getRangeByIndex(20, 2).number = 40;

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFCellValueLessOrEqual.xlsx');
        workbook.dispose();
      });
      test('CellValue sample', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition2 = conditions.addCondition();
        condition2.formatType = ExcelCFType.cellValue;
        condition2.operator = ExcelComparisonOperator.greater;
        condition2.firstFormula = '50';
        condition2.backColor = '#AACC44';
        condition2.underline = true;
        condition2.bottomBorderStyle = LineStyle.double;
        condition2.bottomBorderColor = '#678968';

        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.between;
        condition1.firstFormula = '22';
        condition1.secondFormula = '44';
        condition1.backColor = '#45AA42';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#EEDDCC';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#2D23D2';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#162216';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#DEAEA1';

        sheet.getRangeByIndex(1, 1).setNumber(10);
        sheet.getRangeByIndex(2, 1).setNumber(22);
        sheet.getRangeByIndex(3, 1).setNumber(46);
        sheet.getRangeByIndex(4, 1).setNumber(55);
        sheet.getRangeByIndex(5, 1).setNumber(45);
        sheet.getRangeByIndex(6, 1).setNumber(51);
        sheet.getRangeByIndex(7, 1).setNumber(35);
        sheet.getRangeByIndex(8, 1).setNumber(20);
        sheet.getRangeByIndex(9, 1).setNumber(24);
        sheet.getRangeByIndex(10, 1).setNumber(34);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFCellValueSample1.xlsx');
        workbook.dispose();
      });
    });
    group('Uuique/Duplicate', () {
      test('Unique number', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('B1:B10').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.unique;
        condition1.backColor = '#0EE00E';
        condition1.fontColor = '#E92B11';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#D69718';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#7A13EB';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#CC66FF';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#6666FF';
        condition1.numberFormat = '(0.00)';
        condition1.stopIfTrue = true;

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.lessOrEqual;
        condition1.firstFormula = '40';
        condition1.stopIfTrue = true;

        sheet.getRangeByIndex(1, 2).setNumber(55);
        sheet.getRangeByIndex(2, 2).setNumber(22);
        sheet.getRangeByIndex(3, 2).setNumber(46);
        sheet.getRangeByIndex(4, 2).setNumber(55);
        sheet.getRangeByIndex(5, 2).setNumber(45);
        sheet.getRangeByIndex(6, 2).setNumber(51);
        sheet.getRangeByIndex(7, 2).setNumber(55);
        sheet.getRangeByIndex(8, 2).setNumber(20);
        sheet.getRangeByIndex(9, 2).setNumber(24);
        sheet.getRangeByIndex(10, 2).setNumber(55);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFUniqueNumbers.xlsx');
        workbook.dispose();
      });
      test('Duplicate number', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('B1:B10').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.duplicate;
        condition1.backColor = '#0EE00E';
        condition1.fontColor = '#E92B11';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#D69718';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#7A13EB';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#CC66FF';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#6666FF';
        condition1.numberFormat = '(0.00)';
        condition1.stopIfTrue = true;

        sheet.getRangeByIndex(1, 2).setNumber(55);
        sheet.getRangeByIndex(2, 2).setNumber(22);
        sheet.getRangeByIndex(3, 2).setNumber(46);
        sheet.getRangeByIndex(4, 2).setNumber(55);
        sheet.getRangeByIndex(5, 2).setNumber(45);
        sheet.getRangeByIndex(6, 2).setNumber(51);
        sheet.getRangeByIndex(7, 2).setNumber(55);
        sheet.getRangeByIndex(8, 2).setNumber(20);
        sheet.getRangeByIndex(9, 2).setNumber(24);
        sheet.getRangeByIndex(10, 2).setNumber(55);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFDuplicateNumbers.xlsx');
        workbook.dispose();
      });
      test('Unique Text', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('B1:B10').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.unique;
        condition1.backColor = '#757171';
        condition1.fontColor = '#D9DC1D';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#999718';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#7B13AD';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#DDEEAA';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#6666AA';
        condition1.numberFormat = '@';

        conditions = sheet.getRangeByName('I4:J7').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.unique;
        condition1.backColor = '#1BDADF';
        condition1.topBorderStyle = LineStyle.thick;
        condition1.topBorderColor = '#6A2D97';

        conditions = sheet.getRangeByName('D10:G10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.unique;
        condition1.fontColor = '#FE7F00';

        sheet.getRangeByIndex(1, 2).setText('Book');
        sheet.getRangeByIndex(2, 2).setText('Pen');
        sheet.getRangeByIndex(3, 2).setText('Book');
        sheet.getRangeByIndex(4, 2).setText('desk');
        sheet.getRangeByIndex(5, 2).setText('Book');
        sheet.getRangeByIndex(6, 2).setText('Note');
        sheet.getRangeByIndex(7, 2).setText('Pen');
        sheet.getRangeByIndex(8, 2).setText('Book');
        sheet.getRangeByIndex(9, 2).setText('Book');
        sheet.getRangeByIndex(10, 2).setText('Pencil');

        sheet.getRangeByIndex(4, 9).setText('man');
        sheet.getRangeByIndex(5, 9).setText('Monkey');
        sheet.getRangeByIndex(6, 9).setText('Man');
        sheet.getRangeByIndex(7, 9).setText('Mammal');
        sheet.getRangeByIndex(4, 10).setText('Man');
        sheet.getRangeByIndex(5, 10).setText('animal');
        sheet.getRangeByIndex(6, 10).setText('woman');
        sheet.getRangeByIndex(7, 10).setText('Mammal');

        sheet.getRangeByIndex(10, 4).setText('Ice');
        sheet.getRangeByIndex(10, 5).setText('Ice');
        sheet.getRangeByIndex(10, 6).setText('Hot');
        sheet.getRangeByIndex(10, 7).setText('Ice');

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFUniqueText.xlsx');
        workbook.dispose();
      });
      test('Duplicate Text', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('B1:B10').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.duplicate;
        condition1.backColor = '#757171';
        condition1.fontColor = '#D9DC1D';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#999718';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#7B13AD';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#DDEEAA';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#6666AA';
        condition1.numberFormat = '@';

        conditions = sheet.getRangeByName('I4:J7').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.duplicate;
        condition1.backColor = '#1BDADF';
        condition1.topBorderStyle = LineStyle.thick;
        condition1.topBorderColor = '#6A2D97';

        conditions = sheet.getRangeByName('D10:G10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.duplicate;
        condition1.fontColor = '#FE7F00';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.unique;
        condition1.fontColor = '#567891';

        sheet.getRangeByIndex(1, 2).setText('Book');
        sheet.getRangeByIndex(2, 2).setText('Pen');
        sheet.getRangeByIndex(3, 2).setText('Book');
        sheet.getRangeByIndex(4, 2).setText('desk');
        sheet.getRangeByIndex(5, 2).setText('Book');
        sheet.getRangeByIndex(6, 2).setText('Note');
        sheet.getRangeByIndex(7, 2).setText('Pen');
        sheet.getRangeByIndex(8, 2).setText('Book');
        sheet.getRangeByIndex(9, 2).setText('Book');
        sheet.getRangeByIndex(10, 2).setText('Pencil');

        sheet.getRangeByIndex(4, 9).setText('man');
        sheet.getRangeByIndex(5, 9).setText('Monkey');
        sheet.getRangeByIndex(6, 9).setText('Man');
        sheet.getRangeByIndex(7, 9).setText('Mammal');
        sheet.getRangeByIndex(4, 10).setText('Man');
        sheet.getRangeByIndex(5, 10).setText('animal');
        sheet.getRangeByIndex(6, 10).setText('woman');
        sheet.getRangeByIndex(7, 10).setText('Mammal');

        sheet.getRangeByIndex(10, 4).setText('Ice');
        sheet.getRangeByIndex(10, 5).setText('Ice');
        sheet.getRangeByIndex(10, 6).setText('Hot');
        sheet.getRangeByIndex(10, 7).setText('Ice');

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFDuplicateText.xlsx');
        workbook.dispose();
      });
      test('Unique DateTime', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('B1:B15').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.unique;
        condition1.backColor = '#43BEE9';
        condition1.fontColor = '#D42CB0';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#DA9210';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#660066';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#F60000';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#CEC010';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.between;
        condition1.firstFormula = r'=$B$7';
        condition1.secondFormula = r'=$B$2';
        condition1.stopIfTrue = true;

        sheet.getRangeByIndex(1, 2).setDateTime(DateTime(2020, 11, 11));
        sheet.getRangeByIndex(2, 2).setDateTime(DateTime(2020, 12, 12));
        sheet.getRangeByIndex(3, 2).setDateTime(DateTime(2020, 11, 11));
        sheet.getRangeByIndex(4, 2).setDateTime(DateTime(2020, 11, 4));
        sheet.getRangeByIndex(5, 2).setDateTime(DateTime(2020, 4, 23));
        sheet.getRangeByIndex(6, 2).setDateTime(DateTime(2020, 6, 16));
        sheet.getRangeByIndex(7, 2).setDateTime(DateTime(2020, 6, 8));
        sheet.getRangeByIndex(8, 2).setDateTime(DateTime(2020));
        sheet.getRangeByIndex(9, 2).setDateTime(DateTime(2020, 2, 27));
        sheet.getRangeByIndex(10, 2).setDateTime(DateTime(2020, 3, 31));
        sheet.getRangeByIndex(11, 2).setDateTime(DateTime(2020, 8, 31));
        sheet.getRangeByIndex(12, 2).setDateTime(DateTime(2020, 9, 22));
        sheet.getRangeByIndex(13, 2).setDateTime(DateTime(2020, 6, 5));
        sheet.getRangeByIndex(14, 2).setDateTime(DateTime(2020, 6, 8));
        sheet.getRangeByIndex(15, 2).setDateTime(DateTime(2020, 3, 31));

        sheet.autoFitColumn(2);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFUniqueDateTime.xlsx');
        workbook.dispose();
      });
      test('Duplicate DateTime', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheet1 = workbook.worksheets[1];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('B1:B15').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.duplicate;
        condition1.backColor = '#43BEE9';
        condition1.fontColor = '#2BC341';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#833C0C';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#D02292';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#FF6600';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#CF2753';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.notBetween;
        condition1.firstFormula = r'=$B$7';
        condition1.secondFormula = r'=$B$2';
        condition1.fontColor = '#5F2987';
        condition1.stopIfTrue = true;

        final ConditionalFormats conditions1 =
            sheet1.getRangeByName('D1:D15').conditionalFormats;
        ConditionalFormat condition2 = conditions1.addCondition();
        condition2.formatType = ExcelCFType.duplicate;
        condition2.backColor = '#43BEE9';
        condition2.fontColor = '#D42CB0';
        condition2.isItalic = true;
        condition2.isBold = true;
        condition2.underline = true;
        condition2.bottomBorderStyle = LineStyle.medium;
        condition2.bottomBorderColor = '#DA9210';
        condition2.topBorderStyle = LineStyle.double;
        condition2.topBorderColor = '#660066';
        condition2.rightBorderStyle = LineStyle.thick;
        condition2.rightBorderColor = '#F60000';
        condition2.leftBorderStyle = LineStyle.thin;
        condition2.leftBorderColor = '#CEC010';

        condition2 = conditions1.addCondition();
        condition2.formatType = ExcelCFType.cellValue;
        condition2.operator = ExcelComparisonOperator.notBetween;
        condition2.firstFormula = r'=$D$7';
        condition2.secondFormula = r'=$D$2';
        condition2.fontColor = '#5F2987';

        sheet.getRangeByIndex(1, 2).setDateTime(DateTime(2020, 11, 11));
        sheet.getRangeByIndex(2, 2).setDateTime(DateTime(2020, 12, 12));
        sheet.getRangeByIndex(3, 2).setDateTime(DateTime(2020, 11, 11));
        sheet.getRangeByIndex(4, 2).setDateTime(DateTime(2020, 11, 4));
        sheet.getRangeByIndex(5, 2).setDateTime(DateTime(2020, 4, 23));
        sheet.getRangeByIndex(6, 2).setDateTime(DateTime(2020, 6, 16));
        sheet.getRangeByIndex(7, 2).setDateTime(DateTime(2020, 6, 8));
        sheet.getRangeByIndex(8, 2).setDateTime(DateTime(2020));
        sheet.getRangeByIndex(9, 2).setDateTime(DateTime(2020, 2, 27));
        sheet.getRangeByIndex(10, 2).setDateTime(DateTime(2020, 3, 31));
        sheet.getRangeByIndex(11, 2).setDateTime(DateTime(2020, 8, 31));
        sheet.getRangeByIndex(12, 2).setDateTime(DateTime(2020, 9, 22));
        sheet.getRangeByIndex(13, 2).setDateTime(DateTime(2020, 6, 5));
        sheet.getRangeByIndex(14, 2).setDateTime(DateTime(2020, 6, 8));
        sheet.getRangeByIndex(15, 2).setDateTime(DateTime(2020, 3, 31));

        sheet1.getRangeByIndex(1, 4).setDateTime(DateTime(2020, 11, 11));
        sheet1.getRangeByIndex(2, 4).setDateTime(DateTime(2020, 12, 12));
        sheet1.getRangeByIndex(3, 4).setDateTime(DateTime(2020, 11, 11));
        sheet1.getRangeByIndex(4, 4).setDateTime(DateTime(2020, 11, 4));
        sheet1.getRangeByIndex(5, 4).setDateTime(DateTime(2020, 4, 23));
        sheet1.getRangeByIndex(6, 4).setDateTime(DateTime(2020, 6, 16));
        sheet1.getRangeByIndex(7, 4).setDateTime(DateTime(2020, 6, 8));
        sheet1.getRangeByIndex(8, 4).setDateTime(DateTime(2020));
        sheet1.getRangeByIndex(9, 4).setDateTime(DateTime(2020, 2, 27));
        sheet1.getRangeByIndex(10, 4).setDateTime(DateTime(2020, 3, 31));
        sheet1.getRangeByIndex(11, 4).setDateTime(DateTime(2020, 8, 31));
        sheet1.getRangeByIndex(12, 4).setDateTime(DateTime(2020, 9, 22));
        sheet1.getRangeByIndex(13, 4).setDateTime(DateTime(2020, 6, 5));
        sheet1.getRangeByIndex(14, 4).setDateTime(DateTime(2020, 6, 8));
        sheet1.getRangeByIndex(15, 4).setDateTime(DateTime(2020, 3, 31));

        sheet.autoFitColumn(2);
        sheet1.autoFitColumn(4);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFDuplicateDateTime.xlsx');
        workbook.dispose();
      });
      test('Unique and Duplicate', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheet1 = workbook.worksheets[1];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:D4').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.unique;
        condition1.backColor = '#9CC97D';
        condition1.fontColor = '#D46112';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#FF33CC';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#FFFF00';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#321DF7';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#16E0A6';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.duplicate;
        condition1.backColor = '#6460FC';
        condition1.fontColor = '#F4B084';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#64F8B2';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#B4DF17';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#B59F67';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#D78593';

        conditions = sheet.getRangeByName('J6:M6').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.unique;
        condition1.fontColor = '#483DAE';
        condition1.isItalic = true;
        condition1.rightBorderStyle = LineStyle.medium;
        condition1.rightBorderColor = '#013FFA';

        conditions = sheet1.getRangeByName('B4:B16').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.duplicate;
        condition1.backColor = '#FFD966';
        condition1.underline = true;

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.unique;
        condition1.backColor = '#AEDDEE';

        conditions = sheet1.getRangeByName('C10:D14').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.duplicate;
        condition1.underline = true;
        condition1.isBold = true;
        condition1.bottomBorderStyle = LineStyle.double;
        condition1.bottomBorderColor = '#47DECB';

        sheet.getRangeByIndex(1, 1).setNumber(16);
        sheet.getRangeByIndex(2, 1).setNumber(22);
        sheet.getRangeByIndex(3, 1).setNumber(22);
        sheet.getRangeByIndex(4, 1).setDateTime(DateTime(2021, 6, 16));
        sheet.getRangeByIndex(1, 2).setText('Helloo');
        sheet.getRangeByIndex(2, 2).setText('World');
        sheet.getRangeByIndex(3, 2).setText('Monkey');
        sheet.getRangeByIndex(4, 2).setText('Helloo');
        sheet.getRangeByIndex(1, 3).setText('Helloo');
        sheet.getRangeByIndex(2, 3).setDateTime(DateTime(2021, 6, 16));
        sheet.getRangeByIndex(3, 3).setDateTime(DateTime(2021, 3, 31));
        sheet.getRangeByIndex(4, 3).setNumber(44);
        sheet.getRangeByIndex(1, 4).setNumber(88);
        sheet.getRangeByIndex(2, 4).setDateTime(DateTime(2021, 2, 27));
        sheet.getRangeByIndex(3, 4).setDateTime(DateTime(2021, 6, 16));
        sheet.getRangeByIndex(4, 4).setText('Helloo');

        sheet.getRangeByName('J6').setNumber(13);
        sheet.getRangeByName('K6').setNumber(13);
        sheet.getRangeByName('L6').setText('Ice');
        sheet.getRangeByName('M6').setText('Cream');

        sheet1.getRangeByIndex(4, 2).setNumber(34);
        sheet1.getRangeByIndex(5, 2).setNumber(23);
        sheet1.getRangeByIndex(6, 2).setText('Man');
        sheet1.getRangeByIndex(7, 2).setDateTime(DateTime(2021, 2, 3));
        sheet1.getRangeByIndex(9, 2).setNumber(23);
        sheet1.getRangeByIndex(10, 2).setText('world');
        sheet1.getRangeByIndex(11, 2).setText('Varun');
        sheet1.getRangeByIndex(12, 2).setNumber(54);
        sheet1.getRangeByIndex(13, 2).setNumber(15);
        sheet1.getRangeByIndex(14, 2).setDateTime(DateTime(2020));
        sheet1.getRangeByIndex(15, 2).setNumber(44);
        sheet1.getRangeByIndex(16, 2).setText('Man');

        sheet1.getRangeByName('C10').setText('M');
        sheet1.getRangeByName('C11').setText('MM');
        sheet1.getRangeByName('C12').setNumber(23);
        sheet1.getRangeByName('C13').setNumber(12);
        sheet1.getRangeByName('C10').setNumber(14);

        sheet1.getRangeByName('D10').setText('ZZ');
        sheet1.getRangeByName('D11').setText('M');
        sheet1.getRangeByName('D12').setText('MM');
        sheet1.getRangeByName('D13').setNumber(73);
        sheet1.getRangeByName('D14').setNumber(21);

        sheet.getRangeByName('A1:D4').autoFitColumns();

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFUniqueDuplicate.xlsx');
        workbook.dispose();
      });
    });
    group('Specific Text', () {
      test('Containing', () {
        // create a Excel
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.text = 'M';
        condition1.backColor = '#00B0F0';
        condition1.fontColor = '#CE2622';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#C6D53B';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#17D33F';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#A44C9A';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#FFE699';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.between;
        condition1.text = 'J';
        condition1.backColor = '#F4B084';
        condition1.isBold = true;
        condition1.stopIfTrue = true;

        conditions = sheet.getRangeByName('B1:B10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.containsText;
        condition1.text = 'Raj';
        condition1.fontColor = '#9C5BCD';
        condition1.isItalic = true;
        condition1.isBold = true;

        conditions = sheet.getRangeByName('C1:C10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.containsText;
        condition1.text = 'Pass';
        condition1.backColor = '#3EF30D';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.containsText;
        condition1.text = 'Fail';
        condition1.backColor = '#F70707';

        sheet.getRangeByIndex(1, 1).setText('John');
        sheet.getRangeByIndex(2, 1).setText('James');
        sheet.getRangeByIndex(3, 1).setText('Anne');
        sheet.getRangeByIndex(4, 1).setText('Jai');
        sheet.getRangeByIndex(5, 1).setText('Harish');
        sheet.getRangeByIndex(6, 1).setText('Dinesh');
        sheet.getRangeByIndex(7, 1).setText('Avnish');
        sheet.getRangeByIndex(8, 1).setText('Yamini');
        sheet.getRangeByIndex(9, 1).setText('Kani');
        sheet.getRangeByIndex(10, 1).setText('Anu');

        sheet.getRangeByIndex(1, 2).setText('Mark');
        sheet.getRangeByIndex(2, 2).setText('Bond');
        sheet.getRangeByIndex(3, 2).setText('Wind');
        sheet.getRangeByIndex(4, 2).setText('Edward');
        sheet.getRangeByIndex(5, 2).setText('Raj');
        sheet.getRangeByIndex(6, 2).setText('Kumar');
        sheet.getRangeByIndex(7, 2).setText('Mic');
        sheet.getRangeByIndex(8, 2).setText('Raj');
        sheet.getRangeByIndex(9, 2).setText('Kumar');
        sheet.getRangeByIndex(10, 2).setText('Sri');

        sheet.getRangeByIndex(1, 3).setText('Pass');
        sheet.getRangeByIndex(2, 3).setText('Pass');
        sheet.getRangeByIndex(3, 3).setText('Fail');
        sheet.getRangeByIndex(4, 3).setText('Pass');
        sheet.getRangeByIndex(5, 3).setText('Pass');
        sheet.getRangeByIndex(6, 3).setText('Fail');
        sheet.getRangeByIndex(7, 3).setText('Fail');
        sheet.getRangeByIndex(8, 3).setText('Pass');
        sheet.getRangeByIndex(9, 3).setText('Fail');
        sheet.getRangeByIndex(10, 3).setText('Pass');
        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFSpecificTextContains.xlsx');
        workbook.dispose();
      });
      test('Not Containing', () {
        // create a Excel
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.notContainsText;
        condition1.text = 'n';
        condition1.backColor = '#00B0F0';
        condition1.fontColor = '#CE2622';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#C6D53B';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#17D33F';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#A44C9A';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#FFE699';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.notContainsText;
        condition1.text = 'A';
        condition1.backColor = '#F4B084';
        condition1.isBold = true;
        condition1.stopIfTrue = true;

        conditions = sheet.getRangeByName('B1:B10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.notContainsText;
        condition1.text = 'D';
        condition1.fontColor = '#AD2358';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;

        conditions = sheet.getRangeByName('C1:C10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.notContainsText;
        condition1.text = 'Pass';
        condition1.backColor = '#3EF30D';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.notContainsText;
        condition1.text = 'Fail';
        condition1.backColor = '#F70707';

        sheet.getRangeByIndex(1, 1).setText('John');
        sheet.getRangeByIndex(2, 1).setText('James');
        sheet.getRangeByIndex(3, 1).setText('Anne');
        sheet.getRangeByIndex(4, 1).setText('Jai');
        sheet.getRangeByIndex(5, 1).setText('Harish');
        sheet.getRangeByIndex(6, 1).setText('Dinesh');
        sheet.getRangeByIndex(7, 1).setText('Avnish');
        sheet.getRangeByIndex(8, 1).setText('Yamini');
        sheet.getRangeByIndex(9, 1).setText('Kani');
        sheet.getRangeByIndex(10, 1).setText('Anu');

        sheet.getRangeByIndex(1, 2).setText('Mark');
        sheet.getRangeByIndex(2, 2).setText('Bond');
        sheet.getRangeByIndex(3, 2).setText('Wind');
        sheet.getRangeByIndex(4, 2).setText('Edward');
        sheet.getRangeByIndex(5, 2).setText('Raj');
        sheet.getRangeByIndex(6, 2).setText('Kumar');
        sheet.getRangeByIndex(7, 2).setText('Mic');
        sheet.getRangeByIndex(8, 2).setText('Raj');
        sheet.getRangeByIndex(9, 2).setText('Kumar');
        sheet.getRangeByIndex(10, 2).setText('Sri');

        sheet.getRangeByIndex(1, 3).setText('Pass');
        sheet.getRangeByIndex(2, 3).setText('Pass');
        sheet.getRangeByIndex(3, 3).setText('Fail');
        sheet.getRangeByIndex(4, 3).setText('Pass');
        sheet.getRangeByIndex(5, 3).setText('Pass');
        sheet.getRangeByIndex(6, 3).setText('Fail');
        sheet.getRangeByIndex(7, 3).setText('Fail');
        sheet.getRangeByIndex(8, 3).setText('Pass');
        sheet.getRangeByIndex(9, 3).setText('Fail');
        sheet.getRangeByIndex(10, 3).setText('Pass');
        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFSpecificTextNotContains.xlsx');
        workbook.dispose();
      });
      test('Begin With', () {
        // create a Excel
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.beginsWith;
        condition1.text = 'An';
        condition1.backColor = '#00B0F0';
        condition1.fontColor = '#CE2622';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#C6D53B';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#17D33F';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#A44C9A';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#FFE699';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.beginsWith;
        condition1.text = 'H';
        condition1.backColor = '#F4B084';
        condition1.isBold = true;

        conditions = sheet.getRangeByName('B1:B10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.beginsWith;
        condition1.text = 'R';
        condition1.backColor = '#AD2244';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;

        conditions = sheet.getRangeByName('C1:C10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.beginsWith;
        condition1.text = 'pa';
        condition1.fontColor = '#3EF30D';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.beginsWith;
        condition1.text = 'Fa';
        condition1.fontColor = '#F70707';

        sheet.getRangeByIndex(1, 1).setText('John');
        sheet.getRangeByIndex(2, 1).setText('James');
        sheet.getRangeByIndex(3, 1).setText('Anne');
        sheet.getRangeByIndex(4, 1).setText('Jai');
        sheet.getRangeByIndex(5, 1).setText('Harish');
        sheet.getRangeByIndex(6, 1).setText('Dinesh');
        sheet.getRangeByIndex(7, 1).setText('Avnish');
        sheet.getRangeByIndex(8, 1).setText('Yamini');
        sheet.getRangeByIndex(9, 1).setText('Kani');
        sheet.getRangeByIndex(10, 1).setText('Anu');

        sheet.getRangeByIndex(1, 2).setText('Mark');
        sheet.getRangeByIndex(2, 2).setText('Bond');
        sheet.getRangeByIndex(3, 2).setText('Wind');
        sheet.getRangeByIndex(4, 2).setText('Edward');
        sheet.getRangeByIndex(5, 2).setText('Raj');
        sheet.getRangeByIndex(6, 2).setText('Kumar');
        sheet.getRangeByIndex(7, 2).setText('Mic');
        sheet.getRangeByIndex(8, 2).setText('Raj');
        sheet.getRangeByIndex(9, 2).setText('Kumar');
        sheet.getRangeByIndex(10, 2).setText('Sri');

        sheet.getRangeByIndex(1, 3).setText('Pass');
        sheet.getRangeByIndex(2, 3).setText('Pass');
        sheet.getRangeByIndex(3, 3).setText('Fail');
        sheet.getRangeByIndex(4, 3).setText('Pass');
        sheet.getRangeByIndex(5, 3).setText('Pass');
        sheet.getRangeByIndex(6, 3).setText('Fail');
        sheet.getRangeByIndex(7, 3).setText('Fail');
        sheet.getRangeByIndex(8, 3).setText('Pass');
        sheet.getRangeByIndex(9, 3).setText('Fail');
        sheet.getRangeByIndex(10, 3).setText('Pass');

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFSpecificTextBeginWith.xlsx');
        workbook.dispose();
      });
      test('Ends With', () {
        // create a Excel
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.endsWith;
        condition1.text = 'sh';
        condition1.backColor = '#00B0F0';
        condition1.fontColor = '#CE2622';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#C6D53B';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#17D33F';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#A44C9A';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#FFE699';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.endsWith;
        condition1.text = 'i';
        condition1.backColor = '#F4B084';
        condition1.isBold = true;

        conditions = sheet.getRangeByName('B1:B10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.endsWith;
        condition1.text = 'd';
        condition1.backColor = '#AD2244';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;

        conditions = sheet.getRangeByName('C1:C10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.endsWith;
        condition1.text = 'ss';
        condition1.fontColor = '#3EF30D';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.specificText;
        condition1.operator = ExcelComparisonOperator.endsWith;
        condition1.text = 'il';
        condition1.fontColor = '#F70707';

        sheet.getRangeByIndex(1, 1).setText('John');
        sheet.getRangeByIndex(2, 1).setText('James');
        sheet.getRangeByIndex(3, 1).setText('Anne');
        sheet.getRangeByIndex(4, 1).setText('Jai');
        sheet.getRangeByIndex(5, 1).setText('Harish');
        sheet.getRangeByIndex(6, 1).setText('Dinesh');
        sheet.getRangeByIndex(7, 1).setText('Avnish');
        sheet.getRangeByIndex(8, 1).setText('Yamini');
        sheet.getRangeByIndex(9, 1).setText('Kani');
        sheet.getRangeByIndex(10, 1).setText('Anu');

        sheet.getRangeByIndex(1, 2).setText('Mark');
        sheet.getRangeByIndex(2, 2).setText('Bond');
        sheet.getRangeByIndex(3, 2).setText('Wind');
        sheet.getRangeByIndex(4, 2).setText('Edward');
        sheet.getRangeByIndex(5, 2).setText('Raj');
        sheet.getRangeByIndex(6, 2).setText('Kumar');
        sheet.getRangeByIndex(7, 2).setText('Mic');
        sheet.getRangeByIndex(8, 2).setText('Raj');
        sheet.getRangeByIndex(9, 2).setText('Kumar');
        sheet.getRangeByIndex(10, 2).setText('Sri');

        sheet.getRangeByIndex(1, 3).setText('Pass');
        sheet.getRangeByIndex(2, 3).setText('Pass');
        sheet.getRangeByIndex(3, 3).setText('Fail');
        sheet.getRangeByIndex(4, 3).setText('Pass');
        sheet.getRangeByIndex(5, 3).setText('Pass');
        sheet.getRangeByIndex(6, 3).setText('Fail');
        sheet.getRangeByIndex(7, 3).setText('Fail');
        sheet.getRangeByIndex(8, 3).setText('Pass');
        sheet.getRangeByIndex(9, 3).setText('Fail');
        sheet.getRangeByIndex(10, 3).setText('Pass');

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFSpecificTextEndWith.xlsx');
        workbook.dispose();
      });
    });
    group('Date Occuring', () {
      // create a Excel
      final Workbook workbook = Workbook();

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // Applying conditional formatting.
      ConditionalFormats conditions =
          sheet.getRangeByName('A1:A10').conditionalFormats;
      ConditionalFormat condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.timePeriod;
      condition1.backColor = '#FFFF00';
      condition1.fontColor = '#FF33CC';
      condition1.isItalic = true;
      condition1.isBold = true;
      condition1.underline = true;
      condition1.bottomBorderStyle = LineStyle.medium;
      condition1.bottomBorderColor = '#2F2BD3';
      condition1.topBorderStyle = LineStyle.double;
      condition1.topBorderColor = '#44BA9B';
      condition1.rightBorderStyle = LineStyle.thick;
      condition1.rightBorderColor = '#663300';
      condition1.leftBorderStyle = LineStyle.thin;
      condition1.leftBorderColor = '#823B89';

      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.timePeriod;
      condition1.timePeriodType = CFTimePeriods.yesterday;
      condition1.backColor = '#F4B084';
      condition1.isBold = true;

      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.timePeriod;
      condition1.timePeriodType = CFTimePeriods.tomorrow;
      condition1.backColor = '#47AADD';
      condition1.isItalic = true;

      conditions = sheet.getRangeByName('B1:B10').conditionalFormats;
      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.timePeriod;
      condition1.timePeriodType = CFTimePeriods.thisWeek;
      condition1.backColor = '#FF3300';
      condition1.isItalic = true;
      condition1.isBold = true;
      condition1.underline = true;
      condition1.numberFormat = 'd-mmm';

      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.timePeriod;
      condition1.timePeriodType = CFTimePeriods.lastWeek;
      condition1.backColor = '#FF3399';
      condition1.isItalic = true;
      condition1.isBold = true;
      condition1.underline = true;
      condition1.numberFormat = 'd-mmm';

      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.timePeriod;
      condition1.timePeriodType = CFTimePeriods.nextWeek;
      condition1.backColor = '#70C2AD';
      condition1.isItalic = true;
      condition1.isBold = true;
      condition1.underline = true;
      condition1.numberFormat = 'd-mmm';

      conditions = sheet.getRangeByName('C1:C10').conditionalFormats;
      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.timePeriod;
      condition1.timePeriodType = CFTimePeriods.thisMonth;
      condition1.fontColor = '#00FF99';
      condition1.underline = true;
      condition1.numberFormat = 'mmm-yy';

      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.timePeriod;
      condition1.timePeriodType = CFTimePeriods.lastMonth;
      condition1.fontColor = '#3333FF';
      condition1.underline = true;
      condition1.numberFormat = 'mmm-yy';

      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.timePeriod;
      condition1.timePeriodType = CFTimePeriods.nextMonth;
      condition1.fontColor = '#F6DB3C';
      condition1.underline = true;
      condition1.numberFormat = 'mmm-yy';

      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.timePeriod;
      condition1.timePeriodType = CFTimePeriods.last7Days;
      condition1.isBold = true;
      condition1.isItalic = true;

      final DateTime now = DateTime.now();
      sheet
          .getRangeByIndex(1, 1)
          .setDateTime(DateTime(now.year, now.month, now.day));
      sheet
          .getRangeByIndex(2, 1)
          .setDateTime(DateTime(now.year, now.month, now.day - 1));
      sheet
          .getRangeByIndex(3, 1)
          .setDateTime(DateTime(now.year, now.month, now.day));
      sheet
          .getRangeByIndex(4, 1)
          .setDateTime(DateTime(now.year, now.month, now.day + 1));
      sheet
          .getRangeByIndex(5, 1)
          .setDateTime(DateTime(now.year, now.month, now.day - 1));
      sheet
          .getRangeByIndex(6, 1)
          .setDateTime(DateTime(now.year, now.month, now.day + 1));
      sheet
          .getRangeByIndex(7, 1)
          .setDateTime(DateTime(now.year, now.month, now.day - 1));
      sheet
          .getRangeByIndex(8, 1)
          .setDateTime(DateTime(now.year, now.month, now.day - 1));
      sheet
          .getRangeByIndex(9, 1)
          .setDateTime(DateTime(now.year, now.month, now.day));
      sheet
          .getRangeByIndex(10, 1)
          .setDateTime(DateTime(now.year, now.month, now.day + 1));
      sheet
          .getRangeByIndex(1, 2)
          .setDateTime(DateTime(now.year, now.month, now.day - 3));
      sheet
          .getRangeByIndex(2, 2)
          .setDateTime(DateTime(now.year, now.month, now.day + 7));
      sheet
          .getRangeByIndex(3, 2)
          .setDateTime(DateTime(now.year, now.month, now.day));
      sheet
          .getRangeByIndex(4, 2)
          .setDateTime(DateTime(now.year, now.month, now.day + 7));
      sheet
          .getRangeByIndex(5, 2)
          .setDateTime(DateTime(now.year, now.month, now.day + 7));
      sheet
          .getRangeByIndex(6, 2)
          .setDateTime(DateTime(now.year, now.month, now.day - 3));
      sheet
          .getRangeByIndex(7, 2)
          .setDateTime(DateTime(now.year, now.month, now.day - 7));
      sheet
          .getRangeByIndex(8, 2)
          .setDateTime(DateTime(now.year, now.month, now.day - 7));
      sheet
          .getRangeByIndex(9, 2)
          .setDateTime(DateTime(now.year, now.month, now.day));
      sheet
          .getRangeByIndex(10, 2)
          .setDateTime(DateTime(now.year, now.month, now.day + 3));

      sheet
          .getRangeByIndex(1, 3)
          .setDateTime(DateTime(now.year, now.month + 1, now.day));
      sheet
          .getRangeByIndex(2, 3)
          .setDateTime(DateTime(now.year, now.month - 1, now.day - 1));
      sheet
          .getRangeByIndex(3, 3)
          .setDateTime(DateTime(now.year, now.month, now.day));
      sheet
          .getRangeByIndex(4, 3)
          .setDateTime(DateTime(now.year, now.month - 1, now.day + 1));
      sheet
          .getRangeByIndex(5, 3)
          .setDateTime(DateTime(now.year, now.month - 1, now.day - 1));
      sheet
          .getRangeByIndex(6, 3)
          .setDateTime(DateTime(now.year, now.month + 1, now.day + 1));
      sheet
          .getRangeByIndex(7, 3)
          .setDateTime(DateTime(now.year, now.month, now.day - 1));
      sheet
          .getRangeByIndex(8, 3)
          .setDateTime(DateTime(now.year, now.month + 1, now.day - 1));
      sheet
          .getRangeByIndex(9, 3)
          .setDateTime(DateTime(now.year, now.month, now.day));
      sheet
          .getRangeByIndex(10, 3)
          .setDateTime(DateTime(now.year, now.month - 1, now.day + 1));

      sheet.autoFitColumn(1);
      sheet.autoFitColumn(2);
      sheet.autoFitColumn(3);

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCFDateOccuring.xlsx');
      workbook.dispose();
    });
    group('Blank & No Blank', () {
      // create a Excel
      final Workbook workbook = Workbook();

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // Applying conditional formatting.
      final ConditionalFormats conditions =
          sheet.getRangeByName('D1:E10').conditionalFormats;
      ConditionalFormat condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.blank;
      condition1.backColor = '#83BC5C';
      condition1.fontColor = '#BE3014';
      condition1.isItalic = true;
      condition1.isBold = true;
      condition1.underline = true;
      condition1.bottomBorderStyle = LineStyle.medium;
      condition1.bottomBorderColor = '#1EAE88';
      condition1.topBorderStyle = LineStyle.double;
      condition1.topBorderColor = '#B208C4';
      condition1.rightBorderStyle = LineStyle.thick;
      condition1.rightBorderColor = '#F43A3A';
      condition1.leftBorderStyle = LineStyle.thin;
      condition1.leftBorderColor = '#99FF66';

      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.noBlank;
      condition1.backColor = '#79E5ED';
      condition1.fontColor = '#D63318';
      condition1.isItalic = true;
      condition1.isBold = true;
      condition1.underline = true;
      condition1.bottomBorderStyle = LineStyle.medium;
      condition1.bottomBorderColor = '#5D40AE';
      condition1.topBorderStyle = LineStyle.double;
      condition1.topBorderColor = '#D2C51C';
      condition1.rightBorderStyle = LineStyle.thick;
      condition1.rightBorderColor = '#AB435E';
      condition1.leftBorderStyle = LineStyle.thin;
      condition1.leftBorderColor = '#8D56FC';

      sheet.getRangeByIndex(1, 4).setText('M');
      sheet.getRangeByIndex(2, 4).setText('Hello');
      sheet.getRangeByIndex(4, 4).setText('Hii');
      sheet.getRangeByIndex(7, 4).setText('Ice');
      sheet.getRangeByIndex(8, 4).setText('M');
      sheet.getRangeByIndex(10, 4).setText('Wave');
      sheet.getRangeByIndex(2, 5).setNumber(26);
      sheet.getRangeByIndex(3, 5).setNumber(44);
      sheet.getRangeByIndex(6, 5).setNumber(22);
      sheet.getRangeByIndex(9, 5).setNumber(16);

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCFBlankNoBlank.xlsx');
      workbook.dispose();
    });
    group('Error & No Error', () {
      // create a Excel
      final Workbook workbook = Workbook();

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // Applying conditional formatting.
      final ConditionalFormats conditions =
          sheet.getRangeByName('A1:A10').conditionalFormats;
      ConditionalFormat condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.containsErrors;
      condition1.backColor = '#332891';
      condition1.fontColor = '#ADADEE';
      condition1.isItalic = true;
      condition1.isBold = true;
      condition1.underline = true;
      condition1.bottomBorderStyle = LineStyle.medium;
      condition1.bottomBorderColor = '#1EAE88';
      condition1.topBorderStyle = LineStyle.double;
      condition1.topBorderColor = '#B208C4';
      condition1.rightBorderStyle = LineStyle.thick;
      condition1.rightBorderColor = '#F43A3A';
      condition1.leftBorderStyle = LineStyle.thin;
      condition1.leftBorderColor = '#99FF66';

      condition1 = conditions.addCondition();
      condition1.formatType = ExcelCFType.notContainsErrors;
      condition1.backColor = '#FFD966';
      condition1.fontColor = '#329001';
      condition1.isItalic = true;
      condition1.isBold = true;
      condition1.underline = true;
      condition1.bottomBorderStyle = LineStyle.medium;
      condition1.bottomBorderColor = '#AFAFAF';
      condition1.topBorderStyle = LineStyle.double;
      condition1.topBorderColor = '#2891DD';
      condition1.rightBorderStyle = LineStyle.thick;
      condition1.rightBorderColor = '#9332A1';
      condition1.leftBorderStyle = LineStyle.thin;
      condition1.leftBorderColor = '#FFEEDD';

      sheet.getRangeByIndex(1, 1).setFormula('=SUM(A1,M)');
      sheet.getRangeByIndex(2, 1).setText('M');
      sheet.getRangeByIndex(3, 1).setText('Z');
      sheet.getRangeByIndex(4, 1).setText('HII');
      sheet.getRangeByIndex(5, 1).setFormula('=N/A');
      sheet.getRangeByIndex(6, 1).setNumber(44);
      sheet.getRangeByIndex(7, 1).setFormula('=#NUM!');
      sheet.getRangeByIndex(8, 1).setText('Heloo');
      sheet.getRangeByIndex(9, 1).setFormula('=#NULL!');
      sheet.getRangeByIndex(10, 1).setNumber(88);

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelCFErrorNoError.xlsx');
      workbook.dispose();
    });
    group('Top Bottom', () {
      test('Top', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheet1 = workbook.worksheets[1];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        TopBottom topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.top;
        topBottom.percent = true;
        topBottom.rank = 70;
        condition1.backColor = '#934ADD';
        condition1.fontColor = '#DABC11';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#FF33CC';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#00FFF0';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#321DF7';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#A2921A';

        conditions = sheet.getRangeByName('B1:B20').conditionalFormats;
        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.top;
        topBottom.rank = 10;
        condition1.backColor = '#DF6613';
        condition1.fontColor = '#93E61A';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#4AA7DA';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#A1496F';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#67DBAC';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#FFD243';

        conditions = sheet1.getRangeByName('C1:C20').conditionalFormats;
        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.top;
        topBottom.percent = true;
        topBottom.rank = 50;
        condition1.backColor = '#378191';
        condition1.fontColor = '#29AD11';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#DEFDEF';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#FF00FF';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#00FFCC';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#00CCCC';

        conditions = sheet1.getRangeByName('A1:A10').conditionalFormats;
        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.top;
        topBottom.percent = true;
        try {
          topBottom.rank = 110;
        } catch (e) {
          expect('Exception: Rank must be between 1 and 100', e.toString());
        }

        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.top;
        try {
          topBottom.rank = 1001;
        } catch (e) {
          expect('Exception: Rank must be between 1 and 1000', e.toString());
        }

        conditions = sheet1.getRangeByName('D1:D10').conditionalFormats;
        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.top;
        topBottom.rank = 2;
        condition1.fontColor = '#8B6CDA';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#82CC28';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#DDDCCC';

        sheet.getRangeByIndex(1, 1).setText('Mark');
        sheet.getRangeByIndex(2, 1).setNumber(29);
        sheet.getRangeByIndex(3, 1).setNumber(13);
        sheet.getRangeByIndex(4, 1).setNumber(148);
        sheet.getRangeByIndex(5, 1).setNumber(98);
        sheet.getRangeByIndex(6, 1).setNumber(60);
        sheet.getRangeByIndex(7, 1).setNumber(69);
        sheet.getRangeByIndex(8, 1).setNumber(49);
        sheet.getRangeByIndex(9, 1).setNumber(100);
        sheet.getRangeByIndex(10, 1).setNumber(125);
        sheet.getRangeByIndex(11, 1).setNumber(80);
        sheet.getRangeByIndex(12, 1).setNumber(60);
        sheet.getRangeByIndex(13, 1).setNumber(89);
        sheet.getRangeByIndex(14, 1).setNumber(123);
        sheet.getRangeByIndex(15, 1).setNumber(75);
        sheet.getRangeByIndex(16, 1).setNumber(108);
        sheet.getRangeByIndex(17, 1).setNumber(37);
        sheet.getRangeByIndex(18, 1).setNumber(131);
        sheet.getRangeByIndex(19, 1).setNumber(139);
        sheet.getRangeByIndex(20, 1).setNumber(79);

        sheet.getRangeByIndex(1, 2).setText('Mark');
        sheet.getRangeByIndex(2, 2).setNumber(29);
        sheet.getRangeByIndex(3, 2).setNumber(13);
        sheet.getRangeByIndex(4, 2).setNumber(148);
        sheet.getRangeByIndex(5, 2).setNumber(98);
        sheet.getRangeByIndex(6, 2).setNumber(60);
        sheet.getRangeByIndex(7, 2).setNumber(69);
        sheet.getRangeByIndex(8, 2).setNumber(49);
        sheet.getRangeByIndex(9, 2).setNumber(100);
        sheet.getRangeByIndex(10, 2).setNumber(125);
        sheet.getRangeByIndex(11, 2).setNumber(80);
        sheet.getRangeByIndex(12, 2).setNumber(60);
        sheet.getRangeByIndex(13, 2).setNumber(89);
        sheet.getRangeByIndex(14, 2).setNumber(123);
        sheet.getRangeByIndex(15, 2).setNumber(75);
        sheet.getRangeByIndex(16, 2).setNumber(108);
        sheet.getRangeByIndex(17, 2).setNumber(37);
        sheet.getRangeByIndex(18, 2).setNumber(131);
        sheet.getRangeByIndex(19, 2).setNumber(139);
        sheet.getRangeByIndex(20, 2).setNumber(79);

        sheet1.getRangeByIndex(1, 3).setText('Mark');
        sheet1.getRangeByIndex(2, 3).setNumber(29);
        sheet1.getRangeByIndex(3, 3).setNumber(13);
        sheet1.getRangeByIndex(4, 3).setNumber(148);
        sheet1.getRangeByIndex(5, 3).setNumber(98);
        sheet1.getRangeByIndex(6, 3).setNumber(60);
        sheet1.getRangeByIndex(7, 3).setNumber(69);
        sheet1.getRangeByIndex(8, 3).setNumber(49);
        sheet1.getRangeByIndex(9, 3).setNumber(100);
        sheet1.getRangeByIndex(10, 3).setNumber(125);
        sheet1.getRangeByIndex(11, 3).setNumber(80);
        sheet1.getRangeByIndex(12, 3).setNumber(60);
        sheet1.getRangeByIndex(13, 3).setNumber(89);
        sheet1.getRangeByIndex(14, 3).setNumber(123);
        sheet1.getRangeByIndex(15, 3).setNumber(75);
        sheet1.getRangeByIndex(16, 3).setNumber(108);
        sheet1.getRangeByIndex(17, 3).setNumber(37);
        sheet1.getRangeByIndex(18, 3).setNumber(131);
        sheet1.getRangeByIndex(19, 3).setNumber(139);
        sheet1.getRangeByIndex(20, 3).setNumber(79);

        sheet1.getRangeByIndex(1, 4).setNumber(200);
        sheet1.getRangeByIndex(2, 4).setNumber(110);
        sheet1.getRangeByIndex(3, 4).setNumber(120);
        sheet1.getRangeByIndex(4, 4).setNumber(200);
        sheet1.getRangeByIndex(5, 4).setNumber(130);
        sheet1.getRangeByIndex(6, 4).setNumber(140);
        sheet1.getRangeByIndex(7, 4).setNumber(190);
        sheet1.getRangeByIndex(8, 4).setNumber(210);
        sheet1.getRangeByIndex(9, 4).setNumber(148);
        sheet1.getRangeByIndex(10, 4).setNumber(185);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFTop.xlsx');
        workbook.dispose();
      });
      test('Bottom', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheet1 = workbook.worksheets[1];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        TopBottom topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.bottom;
        topBottom.percent = true;
        topBottom.rank = 60;
        condition1.backColor = '#934ADD';
        condition1.fontColor = '#DABC11';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#FF33CC';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#00FFF0';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#321DF7';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#A2921A';

        conditions = sheet.getRangeByName('B1:B20').conditionalFormats;
        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.bottom;
        topBottom.rank = 8;
        condition1.backColor = '#DF6613';
        condition1.fontColor = '#93E61A';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#4AA7DA';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#A1496F';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#67DBAC';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#FFD243';

        conditions = sheet1.getRangeByName('C1:C20').conditionalFormats;
        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.bottom;
        topBottom.percent = true;
        topBottom.rank = 50;
        condition1.backColor = '#378191';
        condition1.fontColor = '#29AD11';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#DEFDEF';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#FF00FF';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#00FFCC';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#00CCCC';

        conditions = sheet1.getRangeByName('D1:D10').conditionalFormats;
        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.bottom;
        topBottom.rank = 4;
        condition1.fontColor = '#8B6CDA';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#82CC28';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#DDDCCC';

        sheet.getRangeByIndex(1, 1).setText('Mark');
        sheet.getRangeByIndex(2, 1).setNumber(29);
        sheet.getRangeByIndex(3, 1).setNumber(13);
        sheet.getRangeByIndex(4, 1).setNumber(148);
        sheet.getRangeByIndex(5, 1).setNumber(98);
        sheet.getRangeByIndex(6, 1).setNumber(60);
        sheet.getRangeByIndex(7, 1).setNumber(69);
        sheet.getRangeByIndex(8, 1).setNumber(49);
        sheet.getRangeByIndex(9, 1).setNumber(100);
        sheet.getRangeByIndex(10, 1).setNumber(125);
        sheet.getRangeByIndex(11, 1).setNumber(80);
        sheet.getRangeByIndex(12, 1).setNumber(60);
        sheet.getRangeByIndex(13, 1).setNumber(89);
        sheet.getRangeByIndex(14, 1).setNumber(123);
        sheet.getRangeByIndex(15, 1).setNumber(75);
        sheet.getRangeByIndex(16, 1).setNumber(108);
        sheet.getRangeByIndex(17, 1).setNumber(37);
        sheet.getRangeByIndex(18, 1).setNumber(131);
        sheet.getRangeByIndex(19, 1).setNumber(139);
        sheet.getRangeByIndex(20, 1).setNumber(79);

        sheet.getRangeByIndex(1, 2).setText('Mark');
        sheet.getRangeByIndex(2, 2).setNumber(29);
        sheet.getRangeByIndex(3, 2).setNumber(13);
        sheet.getRangeByIndex(4, 2).setNumber(148);
        sheet.getRangeByIndex(5, 2).setNumber(98);
        sheet.getRangeByIndex(6, 2).setNumber(60);
        sheet.getRangeByIndex(7, 2).setNumber(69);
        sheet.getRangeByIndex(8, 2).setNumber(49);
        sheet.getRangeByIndex(9, 2).setNumber(100);
        sheet.getRangeByIndex(10, 2).setNumber(125);
        sheet.getRangeByIndex(11, 2).setNumber(80);
        sheet.getRangeByIndex(12, 2).setNumber(60);
        sheet.getRangeByIndex(13, 2).setNumber(89);
        sheet.getRangeByIndex(14, 2).setNumber(123);
        sheet.getRangeByIndex(15, 2).setNumber(75);
        sheet.getRangeByIndex(16, 2).setNumber(108);
        sheet.getRangeByIndex(17, 2).setNumber(37);
        sheet.getRangeByIndex(18, 2).setNumber(131);
        sheet.getRangeByIndex(19, 2).setNumber(139);
        sheet.getRangeByIndex(20, 2).setNumber(79);

        sheet1.getRangeByIndex(1, 3).setText('Mark');
        sheet1.getRangeByIndex(2, 3).setNumber(29);
        sheet1.getRangeByIndex(3, 3).setNumber(13);
        sheet1.getRangeByIndex(4, 3).setNumber(148);
        sheet1.getRangeByIndex(5, 3).setNumber(98);
        sheet1.getRangeByIndex(6, 3).setNumber(60);
        sheet1.getRangeByIndex(7, 3).setNumber(69);
        sheet1.getRangeByIndex(8, 3).setNumber(49);
        sheet1.getRangeByIndex(9, 3).setNumber(100);
        sheet1.getRangeByIndex(10, 3).setNumber(125);
        sheet1.getRangeByIndex(11, 3).setNumber(80);
        sheet1.getRangeByIndex(12, 3).setNumber(60);
        sheet1.getRangeByIndex(13, 3).setNumber(89);
        sheet1.getRangeByIndex(14, 3).setNumber(123);
        sheet1.getRangeByIndex(15, 3).setNumber(75);
        sheet1.getRangeByIndex(16, 3).setNumber(108);
        sheet1.getRangeByIndex(17, 3).setNumber(37);
        sheet1.getRangeByIndex(18, 3).setNumber(131);
        sheet1.getRangeByIndex(19, 3).setNumber(139);
        sheet1.getRangeByIndex(20, 3).setNumber(79);

        sheet1.getRangeByIndex(1, 4).setNumber(200);
        sheet1.getRangeByIndex(2, 4).setNumber(110);
        sheet1.getRangeByIndex(3, 4).setNumber(120);
        sheet1.getRangeByIndex(4, 4).setNumber(200);
        sheet1.getRangeByIndex(5, 4).setNumber(130);
        sheet1.getRangeByIndex(6, 4).setNumber(140);
        sheet1.getRangeByIndex(7, 4).setNumber(190);
        sheet1.getRangeByIndex(8, 4).setNumber(210);
        sheet1.getRangeByIndex(9, 4).setNumber(148);
        sheet1.getRangeByIndex(10, 4).setNumber(185);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFBottom.xlsx');
        workbook.dispose();
      });
      test('Top/Bottom', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        TopBottom topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.top;
        topBottom.percent = true;
        topBottom.rank = 60;
        condition1.backColor = '#934ADD';
        condition1.fontColor = '#DABC11';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#FF33CC';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#00FFF0';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#321DF7';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#A2921A';

        expect(condition1.topBottom!.type, ExcelCFTopBottomType.top);
        expect(condition1.topBottom!.percent, true);
        expect(condition1.topBottom!.rank, 60);

        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.bottom;
        topBottom.percent = true;
        topBottom.rank = 40;
        condition1.backColor = '#DF6613';
        condition1.fontColor = '#93E61A';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#4AA7DA';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#A1496F';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#67DBAC';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#FFD243';

        conditions = sheet.getRangeByName('B1:B20').conditionalFormats;
        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        condition1.backColor = '#378191';
        condition1.fontColor = '#29AD11';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#DEFDEF';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#FF00FF';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#00FFCC';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#00CCCC';
        condition1.numberFormat = '0.0';

        condition1 = conditions.addCondition();
        // Applying top or bottom rule in the conditional formatting.
        condition1.formatType = ExcelCFType.topBottom;
        topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.bottom;
        topBottom.rank = 8;
        condition1.fontColor = '#8B6CDA';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#82CC28';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#DDDCCC';
        condition1.stopIfTrue = true;

        sheet.getRangeByIndex(1, 1).setText('Mark');
        sheet.getRangeByIndex(2, 1).setNumber(29);
        sheet.getRangeByIndex(3, 1).setNumber(13);
        sheet.getRangeByIndex(4, 1).setNumber(148);
        sheet.getRangeByIndex(5, 1).setNumber(98);
        sheet.getRangeByIndex(6, 1).setNumber(60);
        sheet.getRangeByIndex(7, 1).setNumber(69);
        sheet.getRangeByIndex(8, 1).setNumber(49);
        sheet.getRangeByIndex(9, 1).setNumber(100);
        sheet.getRangeByIndex(10, 1).setNumber(125);
        sheet.getRangeByIndex(11, 1).setNumber(80);
        sheet.getRangeByIndex(12, 1).setNumber(60);
        sheet.getRangeByIndex(13, 1).setNumber(89);
        sheet.getRangeByIndex(14, 1).setNumber(123);
        sheet.getRangeByIndex(15, 1).setNumber(75);
        sheet.getRangeByIndex(16, 1).setNumber(108);
        sheet.getRangeByIndex(17, 1).setNumber(37);
        sheet.getRangeByIndex(18, 1).setNumber(131);
        sheet.getRangeByIndex(19, 1).setNumber(139);
        sheet.getRangeByIndex(20, 1).setNumber(79);

        sheet.getRangeByIndex(1, 2).setText('Mark');
        sheet.getRangeByIndex(2, 2).setNumber(29);
        sheet.getRangeByIndex(3, 2).setNumber(13);
        sheet.getRangeByIndex(4, 2).setNumber(148);
        sheet.getRangeByIndex(5, 2).setNumber(98);
        sheet.getRangeByIndex(6, 2).setNumber(60);
        sheet.getRangeByIndex(7, 2).setNumber(69);
        sheet.getRangeByIndex(8, 2).setNumber(49);
        sheet.getRangeByIndex(9, 2).setNumber(100);
        sheet.getRangeByIndex(10, 2).setNumber(125);
        sheet.getRangeByIndex(11, 2).setNumber(80);
        sheet.getRangeByIndex(12, 2).setNumber(60);
        sheet.getRangeByIndex(13, 2).setNumber(89);
        sheet.getRangeByIndex(14, 2).setNumber(123);
        sheet.getRangeByIndex(15, 2).setNumber(75);
        sheet.getRangeByIndex(16, 2).setNumber(108);
        sheet.getRangeByIndex(17, 2).setNumber(37);
        sheet.getRangeByIndex(18, 2).setNumber(131);
        sheet.getRangeByIndex(19, 2).setNumber(139);
        sheet.getRangeByIndex(20, 2).setNumber(79);

        expect(condition1.backColor, '#FFFFFF');

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFTopBottom.xlsx');
        workbook.dispose();
      });
    });
    group('Above/Below Average', () {
      test('Above Avg', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheet1 = workbook.worksheets[1];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        AboveBelowAverage aboveBelowAverage = condition1.aboveBelowAverage!;
        condition1.backColor = '#45E3AB';
        condition1.fontColor = '#7D00FA';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#07EB2D';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#D1A321';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#AB5959';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#BFE34B';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.topBottom;
        final TopBottom topBottom = condition1.topBottom!;
        topBottom.rank = 5;
        condition1.stopIfTrue = true;

        conditions = sheet.getRangeByName('C1:D10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.above;
        condition1.backColor = '#D3FF57';
        condition1.fontColor = '#C95C31';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#A51CCA';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#41A57D';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#FF2970';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#EAC216';

        conditions = sheet1.getRangeByName('D1:E5').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.above;
        condition1.backColor = '#DEDEFF';
        condition1.fontColor = '#8ABA3C';
        condition1.isItalic = true;
        condition1.topBorderStyle = LineStyle.thick;
        condition1.topBorderColor = '#89123A';

        sheet.getRangeByIndex(1, 1).setText('Mark');
        sheet.getRangeByIndex(2, 1).setNumber(23);
        sheet.getRangeByIndex(3, 1).setNumber(13);
        sheet.getRangeByIndex(4, 1).setNumber(148);
        sheet.getRangeByIndex(5, 1).setNumber(113);
        sheet.getRangeByIndex(6, 1).setNumber(60);
        sheet.getRangeByIndex(7, 1).setNumber(79);
        sheet.getRangeByIndex(8, 1).setNumber(49);
        sheet.getRangeByIndex(9, 1).setNumber(100);
        sheet.getRangeByIndex(10, 1).setNumber(125);
        sheet.getRangeByIndex(11, 1).setNumber(80);
        sheet.getRangeByIndex(12, 1).setNumber(117);
        sheet.getRangeByIndex(13, 1).setNumber(89);
        sheet.getRangeByIndex(14, 1).setNumber(123);
        sheet.getRangeByIndex(15, 1).setNumber(75);
        sheet.getRangeByIndex(16, 1).setNumber(108);
        sheet.getRangeByIndex(17, 1).setNumber(100);
        sheet.getRangeByIndex(18, 1).setNumber(131);
        sheet.getRangeByIndex(19, 1).setNumber(139);
        sheet.getRangeByIndex(20, 1).setNumber(79);

        sheet.getRangeByIndex(1, 3).setText('Mark');
        sheet.getRangeByIndex(2, 3).setNumber(191);
        sheet.getRangeByIndex(3, 3).setNumber(80);
        sheet.getRangeByIndex(4, 3).setNumber(110);
        sheet.getRangeByIndex(5, 3).setNumber(98);
        sheet.getRangeByIndex(6, 3).setNumber(150);
        sheet.getRangeByIndex(7, 3).setNumber(98);
        sheet.getRangeByIndex(8, 3).setNumber(158);
        sheet.getRangeByIndex(9, 3).setNumber(160);
        sheet.getRangeByIndex(10, 3).setNumber(125);
        sheet.getRangeByIndex(1, 4).setText('Mark');
        sheet.getRangeByIndex(2, 4).setNumber(160);
        sheet.getRangeByIndex(3, 4).setNumber(89);
        sheet.getRangeByIndex(4, 4).setNumber(123);
        sheet.getRangeByIndex(5, 4).setNumber(75);
        sheet.getRangeByIndex(6, 4).setNumber(108);
        sheet.getRangeByIndex(7, 4).setNumber(45);
        sheet.getRangeByIndex(8, 4).setNumber(170);
        sheet.getRangeByIndex(9, 4).setNumber(120);
        sheet.getRangeByIndex(10, 4).setNumber(79);

        sheet1.getRangeByIndex(1, 4).setNumber(122);
        sheet1.getRangeByIndex(2, 4).setNumber(200);
        sheet1.getRangeByIndex(3, 4).setNumber(600);
        sheet1.getRangeByIndex(4, 4).setNumber(491);
        sheet1.getRangeByIndex(5, 4).setNumber(789);
        sheet1.getRangeByIndex(1, 5).setNumber(301);
        sheet1.getRangeByIndex(2, 5).setNumber(891);
        sheet1.getRangeByIndex(3, 5).setNumber(189);
        sheet1.getRangeByIndex(4, 5).setNumber(890);
        sheet1.getRangeByIndex(5, 5).setNumber(1000);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFAboveAvg.xlsx');
        workbook.dispose();
      });
      test('Below Avg', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheet1 = workbook.worksheets[1];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        AboveBelowAverage aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.below;
        condition1.backColor = '#45E3AB';
        condition1.fontColor = '#7D00FA';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#07EB2D';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#D1A321';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#AB5959';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#BFE34B';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.topBottom;
        final TopBottom topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.bottom;
        topBottom.rank = 3;
        condition1.stopIfTrue = true;

        conditions = sheet.getRangeByName('C1:D10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.below;
        condition1.backColor = '#D3FF57';
        condition1.fontColor = '#C95C31';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#A51CCA';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#41A57D';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#FF2970';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#EAC216';

        conditions = sheet1.getRangeByName('D1:E5').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.below;
        condition1.backColor = '#DEDEFF';
        condition1.fontColor = '#8ABA3C';
        condition1.isItalic = true;
        condition1.topBorderStyle = LineStyle.thick;
        condition1.topBorderColor = '#89123A';

        sheet.getRangeByIndex(1, 1).setText('Mark');
        sheet.getRangeByIndex(2, 1).setNumber(23);
        sheet.getRangeByIndex(3, 1).setNumber(13);
        sheet.getRangeByIndex(4, 1).setNumber(148);
        sheet.getRangeByIndex(5, 1).setNumber(113);
        sheet.getRangeByIndex(6, 1).setNumber(60);
        sheet.getRangeByIndex(7, 1).setNumber(79);
        sheet.getRangeByIndex(8, 1).setNumber(49);
        sheet.getRangeByIndex(9, 1).setNumber(100);
        sheet.getRangeByIndex(10, 1).setNumber(125);
        sheet.getRangeByIndex(11, 1).setNumber(80);
        sheet.getRangeByIndex(12, 1).setNumber(117);
        sheet.getRangeByIndex(13, 1).setNumber(89);
        sheet.getRangeByIndex(14, 1).setNumber(123);
        sheet.getRangeByIndex(15, 1).setNumber(75);
        sheet.getRangeByIndex(16, 1).setNumber(108);
        sheet.getRangeByIndex(17, 1).setNumber(100);
        sheet.getRangeByIndex(18, 1).setNumber(131);
        sheet.getRangeByIndex(19, 1).setNumber(139);
        sheet.getRangeByIndex(20, 1).setNumber(79);

        sheet.getRangeByIndex(1, 3).setText('Mark');
        sheet.getRangeByIndex(2, 3).setNumber(191);
        sheet.getRangeByIndex(3, 3).setNumber(80);
        sheet.getRangeByIndex(4, 3).setNumber(110);
        sheet.getRangeByIndex(5, 3).setNumber(98);
        sheet.getRangeByIndex(6, 3).setNumber(150);
        sheet.getRangeByIndex(7, 3).setNumber(98);
        sheet.getRangeByIndex(8, 3).setNumber(158);
        sheet.getRangeByIndex(9, 3).setNumber(160);
        sheet.getRangeByIndex(10, 3).setNumber(125);
        sheet.getRangeByIndex(1, 4).setText('Mark');
        sheet.getRangeByIndex(2, 4).setNumber(160);
        sheet.getRangeByIndex(3, 4).setNumber(89);
        sheet.getRangeByIndex(4, 4).setNumber(123);
        sheet.getRangeByIndex(5, 4).setNumber(75);
        sheet.getRangeByIndex(6, 4).setNumber(108);
        sheet.getRangeByIndex(7, 4).setNumber(45);
        sheet.getRangeByIndex(8, 4).setNumber(170);
        sheet.getRangeByIndex(9, 4).setNumber(120);
        sheet.getRangeByIndex(10, 4).setNumber(79);

        sheet1.getRangeByIndex(1, 4).setNumber(122);
        sheet1.getRangeByIndex(2, 4).setNumber(200);
        sheet1.getRangeByIndex(3, 4).setNumber(600);
        sheet1.getRangeByIndex(4, 4).setNumber(491);
        sheet1.getRangeByIndex(5, 4).setNumber(789);
        sheet1.getRangeByIndex(1, 5).setNumber(301);
        sheet1.getRangeByIndex(2, 5).setNumber(891);
        sheet1.getRangeByIndex(3, 5).setNumber(189);
        sheet1.getRangeByIndex(4, 5).setNumber(890);
        sheet1.getRangeByIndex(5, 5).setNumber(1000);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFBelowAvg.xlsx');
        workbook.dispose();
      });
      test('Equal Above Avg', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheet1 = workbook.worksheets[1];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        AboveBelowAverage aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.equalOrAbove;
        condition1.backColor = '#BB2F54';
        condition1.fontColor = '#FFFF4B';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#87BAD3';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#D38EDA';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#EFA41D';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#5FCCCF';

        conditions = sheet.getRangeByName('C1:D10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.equalOrAbove;
        condition1.backColor = '#FF0000';
        condition1.fontColor = '#EC9EE1';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#B469FF';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#B6A53C';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#C400F2';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#B8F200';

        conditions = sheet1.getRangeByName('D1:E5').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.equalOrAbove;
        condition1.backColor = '#16FAC4';
        condition1.fontColor = '#FF9933';
        condition1.isItalic = true;
        condition1.topBorderStyle = LineStyle.thick;
        condition1.topBorderColor = '#8B4B76';

        sheet.getRangeByIndex(1, 1).setText('Mark');
        sheet.getRangeByIndex(2, 1).setNumber(23);
        sheet.getRangeByIndex(3, 1).setNumber(13);
        sheet.getRangeByIndex(4, 1).setNumber(148);
        sheet.getRangeByIndex(5, 1).setNumber(113);
        sheet.getRangeByIndex(6, 1).setNumber(60);
        sheet.getRangeByIndex(7, 1).setNumber(79);
        sheet.getRangeByIndex(8, 1).setNumber(49);
        sheet.getRangeByIndex(9, 1).setNumber(100);
        sheet.getRangeByIndex(10, 1).setNumber(125);
        sheet.getRangeByIndex(11, 1).setNumber(80);
        sheet.getRangeByIndex(12, 1).setNumber(117);
        sheet.getRangeByIndex(13, 1).setNumber(89);
        sheet.getRangeByIndex(14, 1).setNumber(123);
        sheet.getRangeByIndex(15, 1).setNumber(75);
        sheet.getRangeByIndex(16, 1).setNumber(108);
        sheet.getRangeByIndex(17, 1).setNumber(100);
        sheet.getRangeByIndex(18, 1).setNumber(131);
        sheet.getRangeByIndex(19, 1).setNumber(139);
        sheet.getRangeByIndex(20, 1).setNumber(79);

        sheet.getRangeByIndex(1, 3).setText('Mark');
        sheet.getRangeByIndex(2, 3).setNumber(191);
        sheet.getRangeByIndex(3, 3).setNumber(80);
        sheet.getRangeByIndex(4, 3).setNumber(120);
        sheet.getRangeByIndex(5, 3).setNumber(98);
        sheet.getRangeByIndex(6, 3).setNumber(150);
        sheet.getRangeByIndex(7, 3).setNumber(98);
        sheet.getRangeByIndex(8, 3).setNumber(158);
        sheet.getRangeByIndex(9, 3).setNumber(160);
        sheet.getRangeByIndex(10, 3).setNumber(100);
        sheet.getRangeByIndex(1, 4).setText('Mark');
        sheet.getRangeByIndex(2, 4).setNumber(160);
        sheet.getRangeByIndex(3, 4).setNumber(89);
        sheet.getRangeByIndex(4, 4).setNumber(123);
        sheet.getRangeByIndex(5, 4).setNumber(75);
        sheet.getRangeByIndex(6, 4).setNumber(160);
        sheet.getRangeByIndex(7, 4).setNumber(45);
        sheet.getRangeByIndex(8, 4).setNumber(170);
        sheet.getRangeByIndex(9, 4).setNumber(120);
        sheet.getRangeByIndex(10, 4).setNumber(10);

        sheet1.getRangeByIndex(1, 4).setNumber(610);
        sheet1.getRangeByIndex(2, 4).setNumber(200);
        sheet1.getRangeByIndex(3, 4).setNumber(600);
        sheet1.getRangeByIndex(4, 4).setNumber(491);
        sheet1.getRangeByIndex(5, 4).setNumber(789);
        sheet1.getRangeByIndex(1, 5).setNumber(301);
        sheet1.getRangeByIndex(2, 5).setNumber(891);
        sheet1.getRangeByIndex(3, 5).setNumber(100);
        sheet1.getRangeByIndex(4, 5).setNumber(900);
        sheet1.getRangeByIndex(5, 5).setNumber(500);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFEqualAboveAvg.xlsx');
        workbook.dispose();
      });
      test('Equal Below Avg', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheet1 = workbook.worksheets[1];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        AboveBelowAverage aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.equalOrBelow;
        condition1.backColor = '#BB2F54';
        condition1.fontColor = '#FFFF4B';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#87BAD3';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#D38EDA';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#EFA41D';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#5FCCCF';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.topBottom;
        final TopBottom topBottom = condition1.topBottom!;
        topBottom.type = ExcelCFTopBottomType.bottom;
        topBottom.rank = 3;
        condition1.stopIfTrue = true;

        conditions = sheet.getRangeByName('C1:D10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.equalOrBelow;
        condition1.backColor = '#FF0000';
        condition1.fontColor = '#EC9EE1';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#B469FF';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#B6A53C';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#C400F2';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#B8F200';

        conditions = sheet1.getRangeByName('D1:E5').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.equalOrBelow;
        condition1.backColor = '#16FAC4';
        condition1.fontColor = '#FF9933';
        condition1.isItalic = true;
        condition1.topBorderStyle = LineStyle.thick;
        condition1.topBorderColor = '#8B4B76';

        sheet.getRangeByIndex(1, 1).setText('Mark');
        sheet.getRangeByIndex(2, 1).setNumber(23);
        sheet.getRangeByIndex(3, 1).setNumber(13);
        sheet.getRangeByIndex(4, 1).setNumber(148);
        sheet.getRangeByIndex(5, 1).setNumber(113);
        sheet.getRangeByIndex(6, 1).setNumber(60);
        sheet.getRangeByIndex(7, 1).setNumber(79);
        sheet.getRangeByIndex(8, 1).setNumber(49);
        sheet.getRangeByIndex(9, 1).setNumber(100);
        sheet.getRangeByIndex(10, 1).setNumber(125);
        sheet.getRangeByIndex(11, 1).setNumber(80);
        sheet.getRangeByIndex(12, 1).setNumber(117);
        sheet.getRangeByIndex(13, 1).setNumber(89);
        sheet.getRangeByIndex(14, 1).setNumber(123);
        sheet.getRangeByIndex(15, 1).setNumber(75);
        sheet.getRangeByIndex(16, 1).setNumber(108);
        sheet.getRangeByIndex(17, 1).setNumber(100);
        sheet.getRangeByIndex(18, 1).setNumber(131);
        sheet.getRangeByIndex(19, 1).setNumber(139);
        sheet.getRangeByIndex(20, 1).setNumber(79);

        sheet.getRangeByIndex(1, 3).setText('Mark');
        sheet.getRangeByIndex(2, 3).setNumber(191);
        sheet.getRangeByIndex(3, 3).setNumber(80);
        sheet.getRangeByIndex(4, 3).setNumber(120);
        sheet.getRangeByIndex(5, 3).setNumber(98);
        sheet.getRangeByIndex(6, 3).setNumber(150);
        sheet.getRangeByIndex(7, 3).setNumber(98);
        sheet.getRangeByIndex(8, 3).setNumber(158);
        sheet.getRangeByIndex(9, 3).setNumber(160);
        sheet.getRangeByIndex(10, 3).setNumber(100);
        sheet.getRangeByIndex(1, 4).setText('Mark');
        sheet.getRangeByIndex(2, 4).setNumber(160);
        sheet.getRangeByIndex(3, 4).setNumber(89);
        sheet.getRangeByIndex(4, 4).setNumber(123);
        sheet.getRangeByIndex(5, 4).setNumber(75);
        sheet.getRangeByIndex(6, 4).setNumber(160);
        sheet.getRangeByIndex(7, 4).setNumber(45);
        sheet.getRangeByIndex(8, 4).setNumber(170);
        sheet.getRangeByIndex(9, 4).setNumber(120);
        sheet.getRangeByIndex(10, 4).setNumber(10);

        sheet1.getRangeByIndex(1, 4).setNumber(610);
        sheet1.getRangeByIndex(2, 4).setNumber(200);
        sheet1.getRangeByIndex(3, 4).setNumber(600);
        sheet1.getRangeByIndex(4, 4).setNumber(491);
        sheet1.getRangeByIndex(5, 4).setNumber(789);
        sheet1.getRangeByIndex(1, 5).setNumber(301);
        sheet1.getRangeByIndex(2, 5).setNumber(891);
        sheet1.getRangeByIndex(3, 5).setNumber(100);
        sheet1.getRangeByIndex(4, 5).setNumber(900);
        sheet1.getRangeByIndex(5, 5).setNumber(500);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFEqualBelowAvg.xlsx');
        workbook.dispose();
      });
      test('Std dev Above Avg', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheet1 = workbook.worksheets[1];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        AboveBelowAverage aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.aboveStdDev;
        condition1.backColor = '#FF00FF';
        condition1.fontColor = '#3CF133';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#882DDB';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#FCBD0C';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#F71611';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#09DCFF';

        conditions = sheet.getRangeByName('C1:D10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.aboveStdDev;
        aboveBelowAverage.stdDevValue = 2;
        condition1.backColor = '#FF0000';
        condition1.fontColor = '#EC9EE1';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#B469FF';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#B6A53C';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#C400F2';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#B8F200';

        conditions = sheet1.getRangeByName('D1:E5').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.above;
        condition1.backColor = '#35D33D';
        condition1.fontColor = '#F7E711';
        condition1.isItalic = true;
        condition1.topBorderStyle = LineStyle.thick;
        condition1.topBorderColor = '#F11760';

        sheet.getRangeByIndex(1, 1).setText('Mark');
        sheet.getRangeByIndex(2, 1).setNumber(10);
        sheet.getRangeByIndex(3, 1).setNumber(100);
        sheet.getRangeByIndex(4, 1).setNumber(190);
        sheet.getRangeByIndex(5, 1).setNumber(200);
        sheet.getRangeByIndex(6, 1).setNumber(89);
        sheet.getRangeByIndex(7, 1).setNumber(4);
        sheet.getRangeByIndex(8, 1).setNumber(200);
        sheet.getRangeByIndex(9, 1).setNumber(210);
        sheet.getRangeByIndex(10, 1).setNumber(99);
        sheet.getRangeByIndex(11, 1).setNumber(100);
        sheet.getRangeByIndex(12, 1).setNumber(12);
        sheet.getRangeByIndex(13, 1).setNumber(44);
        sheet.getRangeByIndex(14, 1).setNumber(150);
        sheet.getRangeByIndex(15, 1).setNumber(180);
        sheet.getRangeByIndex(16, 1).setNumber(20);
        sheet.getRangeByIndex(17, 1).setNumber(1);
        sheet.getRangeByIndex(18, 1).setNumber(30);
        sheet.getRangeByIndex(19, 1).setNumber(194);
        sheet.getRangeByIndex(20, 1).setNumber(120);

        sheet.getRangeByIndex(1, 3).setText('Mark');
        sheet.getRangeByIndex(2, 3).setNumber(100);
        sheet.getRangeByIndex(3, 3).setNumber(200);
        sheet.getRangeByIndex(4, 3).setNumber(45);
        sheet.getRangeByIndex(5, 3).setNumber(300);
        sheet.getRangeByIndex(6, 3).setNumber(120);
        sheet.getRangeByIndex(7, 3).setNumber(79);
        sheet.getRangeByIndex(8, 3).setNumber(16);
        sheet.getRangeByIndex(9, 3).setNumber(40);
        sheet.getRangeByIndex(10, 3).setNumber(127);
        sheet.getRangeByIndex(1, 4).setText('Mark');
        sheet.getRangeByIndex(2, 4).setNumber(30);
        sheet.getRangeByIndex(3, 4).setNumber(200);
        sheet.getRangeByIndex(4, 4).setNumber(20);
        sheet.getRangeByIndex(5, 4).setNumber(75);
        sheet.getRangeByIndex(6, 4).setNumber(120);
        sheet.getRangeByIndex(7, 4).setNumber(45);
        sheet.getRangeByIndex(8, 4).setNumber(160);
        sheet.getRangeByIndex(9, 4).setNumber(200);
        sheet.getRangeByIndex(10, 4).setNumber(1);

        sheet1.getRangeByIndex(1, 4).setNumber(10);
        sheet1.getRangeByIndex(2, 4).setNumber(200);
        sheet1.getRangeByIndex(3, 4).setNumber(120);
        sheet1.getRangeByIndex(4, 4).setNumber(491);
        sheet1.getRangeByIndex(5, 4).setNumber(230);
        sheet1.getRangeByIndex(1, 5).setNumber(301);
        sheet1.getRangeByIndex(2, 5).setNumber(300);
        sheet1.getRangeByIndex(3, 5).setNumber(89);
        sheet1.getRangeByIndex(4, 5).setNumber(300);
        sheet1.getRangeByIndex(5, 5).setNumber(500);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFStdDevAboveAvg.xlsx');
        workbook.dispose();
      });
      test('Std dev below Avg', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(2);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheet1 = workbook.worksheets[1];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        AboveBelowAverage aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.belowStdDev;
        condition1.backColor = '#FF00FF';
        condition1.fontColor = '#3CF133';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#882DDB';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#FCBD0C';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#F71611';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#09DCFF';

        conditions = sheet.getRangeByName('C1:D10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.belowStdDev;
        aboveBelowAverage.stdDevValue = 2;
        condition1.backColor = '#FF0000';
        condition1.fontColor = '#EC9EE1';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#B469FF';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#B6A53C';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#C400F2';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#B8F200';

        conditions = sheet1.getRangeByName('D1:E5').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.below;
        condition1.backColor = '#35D33D';
        condition1.fontColor = '#F7E711';
        condition1.isItalic = true;
        condition1.topBorderStyle = LineStyle.thick;
        condition1.topBorderColor = '#F11760';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.belowStdDev;
        try {
          aboveBelowAverage.stdDevValue = 4;
        } catch (e) {
          expect('Exception: NumStd must be between 1 and 3', e.toString());
        }

        sheet.getRangeByIndex(1, 1).setText('Mark');
        sheet.getRangeByIndex(2, 1).setNumber(10);
        sheet.getRangeByIndex(3, 1).setNumber(100);
        sheet.getRangeByIndex(4, 1).setNumber(190);
        sheet.getRangeByIndex(5, 1).setNumber(200);
        sheet.getRangeByIndex(6, 1).setNumber(89);
        sheet.getRangeByIndex(7, 1).setNumber(4);
        sheet.getRangeByIndex(8, 1).setNumber(200);
        sheet.getRangeByIndex(9, 1).setNumber(210);
        sheet.getRangeByIndex(10, 1).setNumber(99);
        sheet.getRangeByIndex(11, 1).setNumber(100);
        sheet.getRangeByIndex(12, 1).setNumber(12);
        sheet.getRangeByIndex(13, 1).setNumber(44);
        sheet.getRangeByIndex(14, 1).setNumber(150);
        sheet.getRangeByIndex(15, 1).setNumber(180);
        sheet.getRangeByIndex(16, 1).setNumber(20);
        sheet.getRangeByIndex(17, 1).setNumber(1);
        sheet.getRangeByIndex(18, 1).setNumber(30);
        sheet.getRangeByIndex(19, 1).setNumber(194);
        sheet.getRangeByIndex(20, 1).setNumber(120);

        sheet.getRangeByIndex(1, 3).setText('Mark');
        sheet.getRangeByIndex(2, 3).setNumber(100);
        sheet.getRangeByIndex(3, 3).setNumber(200);
        sheet.getRangeByIndex(4, 3).setNumber(45);
        sheet.getRangeByIndex(5, 3).setNumber(300);
        sheet.getRangeByIndex(6, 3).setNumber(120);
        sheet.getRangeByIndex(7, 3).setNumber(79);
        sheet.getRangeByIndex(8, 3).setNumber(16);
        sheet.getRangeByIndex(9, 3).setNumber(40);
        sheet.getRangeByIndex(10, 3).setNumber(127);
        sheet.getRangeByIndex(1, 4).setText('Mark');
        sheet.getRangeByIndex(2, 4).setNumber(30);
        sheet.getRangeByIndex(3, 4).setNumber(200);
        sheet.getRangeByIndex(4, 4).setNumber(20);
        sheet.getRangeByIndex(5, 4).setNumber(75);
        sheet.getRangeByIndex(6, 4).setNumber(120);
        sheet.getRangeByIndex(7, 4).setNumber(45);
        sheet.getRangeByIndex(8, 4).setNumber(160);
        sheet.getRangeByIndex(9, 4).setNumber(-200);
        sheet.getRangeByIndex(10, 4).setNumber(1);

        sheet1.getRangeByIndex(1, 4).setNumber(10);
        sheet1.getRangeByIndex(2, 4).setNumber(200);
        sheet1.getRangeByIndex(3, 4).setNumber(120);
        sheet1.getRangeByIndex(4, 4).setNumber(491);
        sheet1.getRangeByIndex(5, 4).setNumber(230);
        sheet1.getRangeByIndex(1, 5).setNumber(301);
        sheet1.getRangeByIndex(2, 5).setNumber(300);
        sheet1.getRangeByIndex(3, 5).setNumber(89);
        sheet1.getRangeByIndex(4, 5).setNumber(300);
        sheet1.getRangeByIndex(5, 5).setNumber(500);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFStdDevBelowAvg.xlsx');
        workbook.dispose();
      });
      test('Above below Avg', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(1);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:A20').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        AboveBelowAverage aboveBelowAverage = condition1.aboveBelowAverage!;
        condition1.backColor = '#45E3AB';
        condition1.fontColor = '#7D00FA';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#07EB2D';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#D1A321';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#AB5959';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#BFE34B';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.topBottom;
        final TopBottom topBottom = condition1.topBottom!;
        topBottom.rank = 5;
        condition1.stopIfTrue = true;

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.below;
        condition1.backColor = '#FF99CC';
        condition1.fontColor = '#D12F69';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#0FF11A';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#FF01BC';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#F3EE0D';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#03C7FD';

        conditions = sheet.getRangeByName('C1:D10').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.below;
        condition1.backColor = '#D3FF57';
        condition1.fontColor = '#C95C31';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#A51CCA';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#41A57D';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#FF2970';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#EAC216';

        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.aboveBelowAverage;
        aboveBelowAverage = condition1.aboveBelowAverage!;
        aboveBelowAverage.averageType = ExcelCFAverageType.aboveStdDev;
        condition1.backColor = '#DEDEFF';
        condition1.fontColor = '#8ABA3C';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#A5FFCA';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#ED127D';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#FFDDFF';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#EE4571';

        expect(aboveBelowAverage.averageType, ExcelCFAverageType.aboveStdDev);
        expect(aboveBelowAverage.stdDevValue, 1);

        sheet.getRangeByIndex(1, 1).setText('Mark');
        sheet.getRangeByIndex(2, 1).setNumber(23);
        sheet.getRangeByIndex(3, 1).setNumber(13);
        sheet.getRangeByIndex(4, 1).setNumber(148);
        sheet.getRangeByIndex(5, 1).setNumber(113);
        sheet.getRangeByIndex(6, 1).setNumber(60);
        sheet.getRangeByIndex(7, 1).setNumber(79);
        sheet.getRangeByIndex(8, 1).setNumber(49);
        sheet.getRangeByIndex(9, 1).setNumber(100);
        sheet.getRangeByIndex(10, 1).setNumber(125);
        sheet.getRangeByIndex(11, 1).setNumber(80);
        sheet.getRangeByIndex(12, 1).setNumber(117);
        sheet.getRangeByIndex(13, 1).setNumber(89);
        sheet.getRangeByIndex(14, 1).setNumber(123);
        sheet.getRangeByIndex(15, 1).setNumber(75);
        sheet.getRangeByIndex(16, 1).setNumber(108);
        sheet.getRangeByIndex(17, 1).setNumber(100);
        sheet.getRangeByIndex(18, 1).setNumber(131);
        sheet.getRangeByIndex(19, 1).setNumber(139);
        sheet.getRangeByIndex(20, 1).setNumber(79);

        sheet.getRangeByIndex(1, 3).setText('Mark');
        sheet.getRangeByIndex(2, 3).setNumber(191);
        sheet.getRangeByIndex(3, 3).setNumber(80);
        sheet.getRangeByIndex(4, 3).setNumber(110);
        sheet.getRangeByIndex(5, 3).setNumber(98);
        sheet.getRangeByIndex(6, 3).setNumber(150);
        sheet.getRangeByIndex(7, 3).setNumber(98);
        sheet.getRangeByIndex(8, 3).setNumber(158);
        sheet.getRangeByIndex(9, 3).setNumber(160);
        sheet.getRangeByIndex(10, 3).setNumber(125);
        sheet.getRangeByIndex(1, 4).setText('Mark');
        sheet.getRangeByIndex(2, 4).setNumber(160);
        sheet.getRangeByIndex(3, 4).setNumber(89);
        sheet.getRangeByIndex(4, 4).setNumber(123);
        sheet.getRangeByIndex(5, 4).setNumber(75);
        sheet.getRangeByIndex(6, 4).setNumber(108);
        sheet.getRangeByIndex(7, 4).setNumber(45);
        sheet.getRangeByIndex(8, 4).setNumber(170);
        sheet.getRangeByIndex(9, 4).setNumber(120);
        sheet.getRangeByIndex(10, 4).setNumber(79);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFAboveBelow.xlsx');
        workbook.dispose();
      });
    });
    group('Formulas & R1C1 style', () {
      test('Formula 1', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(1);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:D4').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.formula;
        condition1.firstFormula = "=OR(A1='apple',A1='kiwi',A1='lime')";
        condition1.backColor = '#299DDF';
        condition1.fontColor = '#392DDE';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#992AAD';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#D1A321';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#DF391D';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#BFE34B';

        sheet.getRangeByIndex(1, 1).setText('carrot');
        sheet.getRangeByIndex(2, 1).setText('apple');
        sheet.getRangeByIndex(3, 1).setText('onion');
        sheet.getRangeByIndex(4, 1).setText('Mango');
        sheet.getRangeByIndex(1, 2).setText('kiwi');
        sheet.getRangeByIndex(2, 2).setText('Grapes');
        sheet.getRangeByIndex(4, 2).setText('Orange');
        sheet.getRangeByIndex(1, 3).setText('Custard');
        sheet.getRangeByIndex(2, 3).setText('apple');
        sheet.getRangeByIndex(3, 3).setText('Grapes');
        sheet.getRangeByIndex(4, 3).setText('kiwi');
        sheet.getRangeByIndex(1, 4).setText('apple');
        sheet.getRangeByIndex(2, 4).setText('Orange');
        sheet.getRangeByIndex(3, 4).setText('lime');
        sheet.getRangeByIndex(4, 4).setText('kiwi');

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFFormula1.xlsx');
        workbook.dispose();
      });
      test('Formula R1C1', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(1);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:B10').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.formula;
        condition1.firstFormulaR1C1 = 'ISODD(R[1]C1)';
        condition1.backColor = '#884111';
        condition1.fontColor = '#392DDE';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#992AAD';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#D1A321';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#DF391D';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#BFE34B';

        conditions = sheet.getRangeByName('D10:F15').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.formula;
        condition1.firstFormulaR1C1 = '=ISNUMBER(RC)';
        condition1.backColor = '#890DDF';
        condition1.fontColor = '#DDAAEE';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#1D2F44';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#8712AA';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#1930FF';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#84AAEE';

        conditions = sheet.getRangeByName('I4:J12').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.formula;
        condition1.firstFormulaR1C1 = 'RC1 > 100';
        condition1.backColor = '#CC00FF';
        condition1.fontColor = '#1AE6D7';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#D4EE12';

        sheet.getRangeByIndex(1, 1).setNumber(123);
        sheet.getRangeByIndex(2, 1).setNumber(23);
        sheet.getRangeByIndex(3, 1).setNumber(25);
        sheet.getRangeByIndex(4, 1).setNumber(5);
        sheet.getRangeByIndex(5, 1).setNumber(44);
        sheet.getRangeByIndex(6, 1).setNumber(2);
        sheet.getRangeByIndex(7, 1).setNumber(67);
        sheet.getRangeByIndex(8, 1).setNumber(92);
        sheet.getRangeByIndex(9, 1).setNumber(68);
        sheet.getRangeByIndex(10, 1).setNumber(84);
        sheet.getRangeByIndex(1, 2).setNumber(12);
        sheet.getRangeByIndex(2, 2).setNumber(23);
        sheet.getRangeByIndex(3, 2).setNumber(103);
        sheet.getRangeByIndex(4, 2).setNumber(107);
        sheet.getRangeByIndex(5, 2).setNumber(19);
        sheet.getRangeByIndex(6, 2).setNumber(62);
        sheet.getRangeByIndex(7, 2).setNumber(444);
        sheet.getRangeByIndex(8, 2).setNumber(902);
        sheet.getRangeByIndex(9, 2).setNumber(301);
        sheet.getRangeByIndex(10, 2).setNumber(30);

        sheet.getRangeByIndex(10, 4).setNumber(123);
        sheet.getRangeByIndex(11, 4).setText('MM');
        sheet.getRangeByIndex(12, 4).setNumber(25);
        sheet.getRangeByIndex(13, 4).setNumber(5);
        sheet.getRangeByIndex(14, 4).setText('Heloo');
        sheet.getRangeByIndex(15, 4).setText('Hi');
        sheet.getRangeByIndex(10, 5).setNumber(92);
        sheet.getRangeByIndex(11, 5).setText('D');
        sheet.getRangeByIndex(12, 5).setNumber(84);
        sheet.getRangeByIndex(13, 5).setText('M');
        sheet.getRangeByIndex(14, 5).setText('Z');
        sheet.getRangeByIndex(15, 5).setText('Hi');
        sheet.getRangeByIndex(10, 6).setNumber(19);
        sheet.getRangeByIndex(11, 6).setText('MM');
        sheet.getRangeByIndex(12, 6).setNumber(444);
        sheet.getRangeByIndex(13, 6).setNumber(902);
        sheet.getRangeByIndex(14, 6).setText('World');
        sheet.getRangeByIndex(15, 6).setNumber(30);

        sheet.getRangeByIndex(4, 9).setNumber(123);
        sheet.getRangeByIndex(5, 9).setNumber(23);
        sheet.getRangeByIndex(6, 9).setNumber(25);
        sheet.getRangeByIndex(7, 9).setNumber(5);
        sheet.getRangeByIndex(8, 9).setNumber(44);
        sheet.getRangeByIndex(9, 9).setNumber(2);
        sheet.getRangeByIndex(10, 9).setNumber(67);
        sheet.getRangeByIndex(11, 9).setNumber(92);
        sheet.getRangeByIndex(12, 9).setNumber(68);
        sheet.getRangeByIndex(4, 10).setNumber(84);
        sheet.getRangeByIndex(5, 10).setNumber(12);
        sheet.getRangeByIndex(6, 10).setNumber(23);
        sheet.getRangeByIndex(7, 10).setNumber(103);
        sheet.getRangeByIndex(8, 10).setNumber(107);
        sheet.getRangeByIndex(9, 10).setNumber(19);
        sheet.getRangeByIndex(10, 10).setNumber(62);
        sheet.getRangeByIndex(11, 10).setNumber(444);
        sheet.getRangeByIndex(12, 10).setNumber(902);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFFormulaR1C1.xlsx');
        workbook.dispose();
      });
      test('Formula R1C1 1', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(1);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        ConditionalFormats conditions =
            sheet.getRangeByName('A1:C8').conditionalFormats;
        ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.formula;
        condition1.firstFormulaR1C1 = "=RC3='TN'";
        condition1.backColor = '#884111';
        condition1.fontColor = '#392DDE';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.underline = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#992AAD';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#D1A321';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#DF391D';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#BFE34B';

        conditions = sheet.getRangeByName('D10:E19').conditionalFormats;
        condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.formula;
        condition1.firstFormulaR1C1 = '=AND(RC>NOW(),RC<=(NOW()+30))';
        condition1.backColor = '#00FFFF';
        condition1.fontColor = '#43CB35';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#DC3A24';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#1015F0';

        sheet.getRangeByIndex(1, 1).setText('ID');
        sheet.getRangeByIndex(2, 1).setNumber(2);
        sheet.getRangeByIndex(3, 1).setNumber(14);
        sheet.getRangeByIndex(4, 1).setNumber(7);
        sheet.getRangeByIndex(5, 1).setNumber(4);
        sheet.getRangeByIndex(6, 1).setNumber(24);
        sheet.getRangeByIndex(7, 1).setNumber(45);
        sheet.getRangeByIndex(8, 1).setNumber(1);
        sheet.getRangeByIndex(1, 2).setText('Name');
        sheet.getRangeByIndex(2, 2).setText('Merry');
        sheet.getRangeByIndex(3, 2).setText('John');
        sheet.getRangeByIndex(4, 2).setText('Abi');
        sheet.getRangeByIndex(5, 2).setText('Arman');
        sheet.getRangeByIndex(6, 2).setText('Jai');
        sheet.getRangeByIndex(7, 2).setText('Anne');
        sheet.getRangeByIndex(8, 2).setText('Alice');
        sheet.getRangeByIndex(1, 3).setText('State');
        sheet.getRangeByIndex(2, 3).setText('TN');
        sheet.getRangeByIndex(3, 3).setText('KR');
        sheet.getRangeByIndex(4, 3).setText('AP');
        sheet.getRangeByIndex(5, 3).setText('TN');
        sheet.getRangeByIndex(6, 3).setText('TN');
        sheet.getRangeByIndex(7, 3).setText('UP');
        sheet.getRangeByIndex(8, 3).setText('AP');

        sheet.getRangeByIndex(10, 4).setDateTime(DateTime(2021, 2));
        sheet.getRangeByIndex(11, 4).setDateTime(DateTime(2021, 3, 31));
        sheet.getRangeByIndex(12, 4).setDateTime(DateTime(2021, 2, 27));
        sheet.getRangeByIndex(13, 4).setDateTime(DateTime(2021, 12, 11));
        sheet.getRangeByIndex(14, 4).setDateTime(DateTime(2021, 6, 21));
        sheet.getRangeByIndex(15, 4).setDateTime(DateTime(2021, 4, 13));
        sheet.getRangeByIndex(16, 4).setDateTime(DateTime(2021, 11, 23));
        sheet.getRangeByIndex(17, 4).setDateTime(DateTime(2021, 2, 4));
        sheet.getRangeByIndex(18, 4).setDateTime(DateTime(2021, 7, 27));
        sheet.getRangeByIndex(19, 4).setDateTime(DateTime(2021, 4, 3));
        sheet.getRangeByIndex(10, 5).setDateTime(DateTime(2021, 2));
        sheet.getRangeByIndex(11, 5).setDateTime(DateTime(2021, 5, 31));
        sheet.getRangeByIndex(12, 5).setDateTime(DateTime(2021, 9, 27));
        sheet.getRangeByIndex(13, 5).setDateTime(DateTime(2021, 1, 11));
        sheet.getRangeByIndex(14, 5).setDateTime(DateTime(2021, 3, 21));
        sheet.getRangeByIndex(15, 5).setDateTime(DateTime(2021, 9, 13));
        sheet.getRangeByIndex(16, 5).setDateTime(DateTime(2021, 11, 23));
        sheet.getRangeByIndex(17, 5).setDateTime(DateTime(2021, 12, 4));
        sheet.getRangeByIndex(18, 5).setDateTime(DateTime(2021, 8, 27));
        sheet.getRangeByIndex(19, 5).setDateTime(DateTime(2021, 10, 3));
        sheet.autoFitColumn(4);
        sheet.autoFitColumn(5);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFFormulaR1C1Sample.xlsx');
        workbook.dispose();
      });
      test('Cell Value R1C1', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook(1);

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('B1:C10').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();
        condition1.formatType = ExcelCFType.cellValue;
        condition1.operator = ExcelComparisonOperator.between;
        condition1.firstFormulaR1C1 = 'R2C1';
        condition1.secondFormulaR1C1 = '=R8C2';
        condition1.backColor = '#00FFFF';
        condition1.fontColor = '#43CB35';
        condition1.isItalic = true;
        condition1.isBold = true;
        condition1.bottomBorderStyle = LineStyle.medium;
        condition1.bottomBorderColor = '#DC3A24';
        condition1.topBorderStyle = LineStyle.double;
        condition1.topBorderColor = '#1015F0';
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColor = '#DF391D';
        condition1.leftBorderStyle = LineStyle.thin;
        condition1.leftBorderColor = '#BFE34B';

        sheet.getRangeByIndex(1, 2).setNumber(38);
        sheet.getRangeByIndex(2, 2).setNumber(19);
        sheet.getRangeByIndex(3, 2).setNumber(147);
        sheet.getRangeByIndex(4, 2).setNumber(12);
        sheet.getRangeByIndex(5, 2).setNumber(30);
        sheet.getRangeByIndex(6, 2).setNumber(45);
        sheet.getRangeByIndex(7, 2).setNumber(65);
        sheet.getRangeByIndex(8, 2).setNumber(29);
        sheet.getRangeByIndex(9, 2).setNumber(6);
        sheet.getRangeByIndex(10, 2).setNumber(80);
        sheet.getRangeByIndex(1, 3).setNumber(76);
        sheet.getRangeByIndex(2, 3).setNumber(1);
        sheet.getRangeByIndex(3, 3).setNumber(70);
        sheet.getRangeByIndex(4, 3).setNumber(29);
        sheet.getRangeByIndex(5, 3).setNumber(40);
        sheet.getRangeByIndex(6, 3).setNumber(3);
        sheet.getRangeByIndex(7, 3).setNumber(41);
        sheet.getRangeByIndex(8, 3).setNumber(139);
        sheet.getRangeByIndex(9, 3).setNumber(-1);
        sheet.getRangeByIndex(10, 3).setNumber(9);

        // Save and dispose workbook.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFFormulaCellValue.xlsx');
        workbook.dispose();
      });
    });
    group('Color Scale', () {
      test('2-ColorScale_1', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        sheet.getRangeByName('A9').number = 54;
        sheet.getRangeByName('A10').number = 63;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(2);
        colorScale.criteria[0].formatColor = '#63BE7B';
        colorScale.criteria[0].type = ConditionValueType.lowestValue;

        colorScale.criteria[1].formatColor = '#FFEF9C';
        colorScale.criteria[1].type = ConditionValueType.highestValue;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, '2-ColorScale_lowHigh.xlsx');
        workbook.dispose();
      });
      test('2-ColorScale_2', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        sheet.getRangeByName('A9').number = 54;
        sheet.getRangeByName('A10').number = 63;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(2);
        colorScale.criteria[0].formatColor = '#63BE7B';
        colorScale.criteria[0].type = ConditionValueType.number;
        colorScale.criteria[0].value = '10';

        colorScale.criteria[1].formatColor = '#FFEF9C';
        colorScale.criteria[1].type = ConditionValueType.number;
        colorScale.criteria[1].value = '90';

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, '2-ColorScale_number.xlsx');
        workbook.dispose();
      });
      test('2-ColorScale_3', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        sheet.getRangeByName('A9').number = 54;
        sheet.getRangeByName('A10').number = 63;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(2);
        colorScale.criteria[0].formatColor = '#63BE7B';
        colorScale.criteria[0].type = ConditionValueType.formula;
        colorScale.criteria[0].value = 'A2-A1';

        colorScale.criteria[1].formatColor = '#FFEF9C';
        colorScale.criteria[1].type = ConditionValueType.formula;
        colorScale.criteria[1].value = 'SUM(A1:A3)';

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, '2-ColorScale_formula.xlsx');
        workbook.dispose();
      });
      test('2-ColorScale_4', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        sheet.getRangeByName('A9').number = 54;
        sheet.getRangeByName('A10').number = 63;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(2);
        colorScale.criteria[0].formatColor = '#63BE7B';
        colorScale.criteria[0].type = ConditionValueType.percent;
        colorScale.criteria[0].value = '15';

        colorScale.criteria[1].formatColor = '#FFEF9C';
        colorScale.criteria[1].type = ConditionValueType.percent;
        colorScale.criteria[1].value = '80';

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, '2-ColorScale_percent.xlsx');
        workbook.dispose();
      });
      test('2-ColorScale_5', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        sheet.getRangeByName('A9').number = 54;
        sheet.getRangeByName('A10').number = 63;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(2);
        colorScale.criteria[0].formatColor = '#63BE7B';
        colorScale.criteria[0].type = ConditionValueType.percentile;
        colorScale.criteria[0].value = '10';

        colorScale.criteria[1].formatColor = '#FFEF9C';
        colorScale.criteria[1].type = ConditionValueType.percentile;
        colorScale.criteria[1].value = '85';

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, '2-ColorScale_percentile.xlsx');
        workbook.dispose();
      });
      test('3-ColorScale_1', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        sheet.getRangeByName('A9').number = 54;
        sheet.getRangeByName('A10').number = 63;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(3);
        colorScale.criteria[0].formatColor = '#63BE7B';
        colorScale.criteria[0].type = ConditionValueType.lowestValue;

        colorScale.criteria[1].formatColor = '#FFFFFF';
        colorScale.criteria[1].type = ConditionValueType.number;
        colorScale.criteria[1].value = '70';

        colorScale.criteria[2].formatColor = '#F8696B';
        colorScale.criteria[2].type = ConditionValueType.highestValue;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, '3-ColorScale_1.xlsx');
        workbook.dispose();
      });
      test('3-ColorScale_2', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        sheet.getRangeByName('A9').number = 54;
        sheet.getRangeByName('A10').number = 63;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(3);
        colorScale.criteria[0].formatColor = '#63BE7B';
        colorScale.criteria[0].type = ConditionValueType.lowestValue;

        colorScale.criteria[1].formatColor = '#FFFFFF';
        colorScale.criteria[1].type = ConditionValueType.percentile;
        colorScale.criteria[1].value = '50';

        colorScale.criteria[2].formatColor = '#F8696B';
        colorScale.criteria[2].type = ConditionValueType.highestValue;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, '3-ColorScale_2.xlsx');
        workbook.dispose();
      });
      test('3-ColorScale_3', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        sheet.getRangeByName('A9').number = 54;
        sheet.getRangeByName('A10').number = 63;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(3);
        colorScale.criteria[0].formatColor = '#63BE7B';
        colorScale.criteria[0].type = ConditionValueType.lowestValue;

        colorScale.criteria[1].formatColor = '#FFFFFF';
        colorScale.criteria[1].type = ConditionValueType.formula;
        colorScale.criteria[1].value = 'SUM(A2:A3)';

        colorScale.criteria[2].formatColor = '#F8696B';
        colorScale.criteria[2].type = ConditionValueType.highestValue;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, '3-ColorScale_3.xlsx');
        workbook.dispose();
      });
      test('3-ColorScale_4', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        sheet.getRangeByName('A9').number = 54;
        sheet.getRangeByName('A10').number = 63;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(3);
        colorScale.criteria[0].formatColor = '#63BE7B';
        colorScale.criteria[0].type = ConditionValueType.lowestValue;

        colorScale.criteria[1].formatColor = '#FFFFFF';
        colorScale.criteria[1].type = ConditionValueType.percent;
        colorScale.criteria[1].value = '60';

        colorScale.criteria[2].formatColor = '#F8696B';
        colorScale.criteria[2].type = ConditionValueType.highestValue;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, '3-ColorScale_4.xlsx');
        workbook.dispose();
      });
      test('3-ColorScale_5', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        sheet.getRangeByName('A9').number = 54;
        sheet.getRangeByName('A10').number = 63;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(3);
        colorScale.criteria[0].formatColor = '#63BE7B';
        colorScale.criteria[0].type = ConditionValueType.lowestValue;

        colorScale.criteria[1].formatColor = '#FFFFFF';
        colorScale.criteria[1].type = ConditionValueType.percentile;
        colorScale.criteria[1].value = '55';

        colorScale.criteria[2].formatColor = '#F8696B';
        colorScale.criteria[2].type = ConditionValueType.highestValue;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, '3-ColorScale_5.xlsx');
        workbook.dispose();
      });
    });
    group('Icon Set', () {
      test('FourRating', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.fourRating;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '40';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '60';
        iconSet.iconCriteria[3].type = ConditionValueType.percent;
        iconSet.iconCriteria[3].value = '80';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetFourRating.xlsx');
        workbook.dispose();
      });
      test('FourArrows', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.fourArrows;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '40';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '60';
        iconSet.iconCriteria[3].type = ConditionValueType.percent;
        iconSet.iconCriteria[3].value = '80';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetFourArrows.xlsx');
        workbook.dispose();
      });
      test('FourRedToBlack', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.fourRedToBlack;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '40';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '60';
        iconSet.iconCriteria[3].type = ConditionValueType.percent;
        iconSet.iconCriteria[3].value = '80';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetFourRedToBlack.xlsx');
        workbook.dispose();
      });
      test('FourTrafficLights', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.fourTrafficLights;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '40';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '60';
        iconSet.iconCriteria[3].type = ConditionValueType.percent;
        iconSet.iconCriteria[3].value = '80';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetFourTrafficLights.xlsx');
        workbook.dispose();
      });
      test('FourArrows', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.fourArrows;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '40';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '60';
        iconSet.iconCriteria[3].type = ConditionValueType.percent;
        iconSet.iconCriteria[3].value = '80';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetFourArrows.xlsx');
        workbook.dispose();
      });
      test('FourRating', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.fourRating;
        iconSet.iconCriteria[1].type = ConditionValueType.number;
        iconSet.iconCriteria[1].value = '40';
        iconSet.iconCriteria[2].type = ConditionValueType.number;
        iconSet.iconCriteria[2].value = '60';
        iconSet.iconCriteria[3].type = ConditionValueType.number;
        iconSet.iconCriteria[3].value = '80';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetFourRating.xlsx');
        workbook.dispose();
      });
      test('ThreeArrows', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.threeArrows;
        iconSet.iconCriteria[1].type = ConditionValueType.lowestValue;
        iconSet.iconCriteria[1].value = '20';
        iconSet.iconCriteria[2].type = ConditionValueType.highestValue;
        iconSet.iconCriteria[2].value = '60';

        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetThreeArrows.xlsx');
        workbook.dispose();
      });
      test('ThreeSymbols', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.threeArrows;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '20';
        iconSet.iconCriteria[2].value = '50';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetThreeSymbols.xlsx');
        workbook.dispose();
      });
      test('ThreeArrowsGray', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.threeArrowsGray;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '20';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '50';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetThreeArrowsGray.xlsx');
        workbook.dispose();
      });
      test('ThreeTrafficLights1', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.threeTrafficLights1;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '20';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '50';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetThreeTrafficLights1.xlsx');
        workbook.dispose();
      });
      test('ThreeTrafficLights2', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.threeTrafficLights2;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '20';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '50';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetThreeTrafficLights2.xlsx');
        workbook.dispose();
      });
      test('ThreeFlags', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.threeFlags;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '20';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '50';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetThreeFlags.xlsx');
        workbook.dispose();
      });
      test('ThreeSigns', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.threeSigns;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '20';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '50';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetThreeSigns.xlsx');
        workbook.dispose();
      });
      test('ThreeSymbols', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.threeSymbols;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '20';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '50';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetThreeSymbols.xlsx');
        workbook.dispose();
      });
      test('ThreeSymbols2', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.threeSymbols2;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '20';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '50';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetThreeSymbols2.xlsx');
        workbook.dispose();
      });
      test('FiveArrows', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.fiveArrows;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '50';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '70';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetFiveArrows.xlsx');
        workbook.dispose();
      });
      test('FiveArrowsGray', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.fiveArrowsGray;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '50';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '60';
        iconSet.iconCriteria[3].type = ConditionValueType.percent;
        iconSet.iconCriteria[3].value = '70';
        iconSet.iconCriteria[4].type = ConditionValueType.percent;
        iconSet.iconCriteria[4].value = '80';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetFiveArrowsGray.xlsx');
        workbook.dispose();
      });
      test('FiveRating', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.fiveRating;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '50';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '60';
        iconSet.iconCriteria[3].type = ConditionValueType.percent;
        iconSet.iconCriteria[3].value = '70';
        iconSet.iconCriteria[4].type = ConditionValueType.percent;
        iconSet.iconCriteria[4].value = '80';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetFiveRating.xlsx');
        workbook.dispose();
      });
      test('FiveQuarters', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 13;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 47;
        sheet.getRangeByName('A7').number = 34;
        sheet.getRangeByName('A8').number = 21;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 08;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = condition.iconSet!;
        iconSet.iconSet = ExcelIconSetType.fiveQuarters;
        iconSet.iconCriteria[1].type = ConditionValueType.percent;
        iconSet.iconCriteria[1].value = '50';
        iconSet.iconCriteria[2].type = ConditionValueType.percent;
        iconSet.iconCriteria[2].value = '60';
        iconSet.iconCriteria[3].type = ConditionValueType.percent;
        iconSet.iconCriteria[3].value = '70';
        iconSet.iconCriteria[4].type = ConditionValueType.percent;
        iconSet.iconCriteria[4].value = '80';
        iconSet.showIconOnly = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'IconSetFiveQuarters.xlsx');
        workbook.dispose();
      });
      test('CustomIcons', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();
        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 125;
        sheet.getRangeByName('A2').number = 279;
        sheet.getRangeByName('A3').number = 42;
        sheet.getRangeByName('A4').number = 384;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 212;
        sheet.getRangeByName('A7').number = 88;
        sheet.getRangeByName('A8').number = 181;
        sheet.getRangeByName('A9').number = 310;
        sheet.getRangeByName('A10').number = 181;

        //Create iconset for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();
        //Set FormatType as IconSet.
        conditionalFormat.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = conditionalFormat.iconSet!;
        //Set conditions for IconCriteria.
        iconSet.iconSet = ExcelIconSetType.threeFlags;

        final IconConditionValue iconValue1 =
            iconSet.iconCriteria[0] as IconConditionValue;
        iconValue1.iconSet = ExcelIconSetType.fiveBoxes;

        final IconConditionValue iconValue2 =
            iconSet.iconCriteria[1] as IconConditionValue;
        iconValue2.iconSet = ExcelIconSetType.threeSigns;
        iconValue2.index = 2;
        iconValue2.type = ConditionValueType.percent;
        iconValue2.value = '50';
        iconValue2.operator = ConditionalFormatOperator.greaterThan;

        final IconConditionValue iconValue3 =
            iconSet.iconCriteria[2] as IconConditionValue;
        iconValue3.iconSet = ExcelIconSetType.fourRating;
        iconValue3.index = 0;
        iconValue3.type = ConditionValueType.percent;
        iconValue3.value = '75';
        iconValue3.operator = ConditionalFormatOperator.greaterThan;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'CustomIconSet.xlsx');
        workbook.dispose();
      });
      test('CustomIcons2', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();
        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 125;
        sheet.getRangeByName('A2').number = 279;
        sheet.getRangeByName('A3').number = 42;
        sheet.getRangeByName('A4').number = 384;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 212;
        sheet.getRangeByName('A7').number = 88;
        sheet.getRangeByName('A8').number = 181;
        sheet.getRangeByName('A9').number = 310;
        sheet.getRangeByName('A10').number = 181;

        //Create iconset for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();
        //Set FormatType as IconSet.
        conditionalFormat.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = conditionalFormat.iconSet!;
        //Set conditions for IconCriteria.
        iconSet.iconSet = ExcelIconSetType.fourRating;

        final IconConditionValue iconValue1 =
            iconSet.iconCriteria[0] as IconConditionValue;
        iconValue1.iconSet = ExcelIconSetType.fiveArrows;
        iconValue1.index = 3;

        final IconConditionValue iconValue2 =
            iconSet.iconCriteria[1] as IconConditionValue;
        iconValue2.iconSet = ExcelIconSetType.threeSigns;
        iconValue2.index = 2;
        iconValue2.type = ConditionValueType.percent;
        iconValue2.value = '25';
        iconValue2.operator = ConditionalFormatOperator.greaterThan;

        final IconConditionValue iconValue3 =
            iconSet.iconCriteria[2] as IconConditionValue;
        iconValue3.iconSet = ExcelIconSetType.fourRedToBlack;
        iconValue3.index = 1;
        iconValue3.type = ConditionValueType.percent;
        iconValue3.value = '50';
        iconValue3.operator = ConditionalFormatOperator.greaterThan;

        final IconConditionValue iconValue4 =
            iconSet.iconCriteria[3] as IconConditionValue;
        iconValue4.iconSet = ExcelIconSetType.fiveQuarters;
        iconValue4.index = 2;
        iconValue4.type = ConditionValueType.percent;
        iconValue4.value = '75';
        iconValue4.operator = ConditionalFormatOperator.greaterThan;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'CustomIconSet2.xlsx');
        workbook.dispose();
      });
      test('CustomIcons3', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();
        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 125;
        sheet.getRangeByName('A2').number = 279;
        sheet.getRangeByName('A3').number = 42;
        sheet.getRangeByName('A4').number = 384;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 212;
        sheet.getRangeByName('A7').number = 88;
        sheet.getRangeByName('A8').number = 181;
        sheet.getRangeByName('A9').number = 310;
        sheet.getRangeByName('A10').number = 181;

        //Create iconset for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();
        //Set FormatType as IconSet.
        conditionalFormat.formatType = ExcelCFType.iconSet;
        final IconSet iconSet = conditionalFormat.iconSet!;
        //Set conditions for IconCriteria.
        iconSet.iconSet = ExcelIconSetType.fiveArrows;

        final IconConditionValue iconValue1 =
            iconSet.iconCriteria[0] as IconConditionValue;
        iconValue1.iconSet = ExcelIconSetType.fourRedToBlack;
        iconValue1.index = 3;

        final IconConditionValue iconValue2 =
            iconSet.iconCriteria[1] as IconConditionValue;
        iconValue2.iconSet = ExcelIconSetType.fiveQuarters;
        iconValue2.index = 3;
        iconValue2.type = ConditionValueType.percent;
        iconValue2.value = '20';
        iconValue2.operator = ConditionalFormatOperator.greaterThan;

        final IconConditionValue iconValue3 =
            iconSet.iconCriteria[2] as IconConditionValue;
        iconValue3.iconSet = ExcelIconSetType.threeSigns;
        iconValue3.index = 1;
        iconValue3.type = ConditionValueType.percent;
        iconValue3.value = '40';
        iconValue3.operator = ConditionalFormatOperator.greaterThan;

        final IconConditionValue iconValue4 =
            iconSet.iconCriteria[3] as IconConditionValue;
        iconValue4.iconSet = ExcelIconSetType.fiveQuarters;
        iconValue4.index = 4;
        iconValue4.type = ConditionValueType.percent;
        iconValue4.value = '60';
        iconValue4.operator = ConditionalFormatOperator.greaterThan;

        final IconConditionValue iconValue5 =
            iconSet.iconCriteria[4] as IconConditionValue;
        iconValue5.iconSet = ExcelIconSetType.threeTrafficLights2;
        iconValue5.index = 2;
        iconValue5.type = ConditionValueType.percent;
        iconValue5.value = '80';
        iconValue5.operator = ConditionalFormatOperator.greaterThan;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'CustomIconSet3.xlsx');
        workbook.dispose();
      });
    });
    group('Data Bar', () {
      test('DataBar-1', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 1277;
        sheet.getRangeByName('A2').number = 1003;
        sheet.getRangeByName('A3').number = 1105;
        sheet.getRangeByName('A4').number = 952;
        sheet.getRangeByName('A5').number = 770;
        sheet.getRangeByName('A6').number = 621;
        sheet.getRangeByName('A7').number = 1311;
        sheet.getRangeByName('A8').number = 730;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A8').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.dataBar;
        final DataBar dataBar = conditionalFormat.dataBar!;

        //Set the constraints
        dataBar.minPoint.type = ConditionValueType.lowestValue;
        dataBar.maxPoint.type = ConditionValueType.highestValue;

        //Set color for DataBar
        dataBar.barColor = '#9CD0F3';

        //Hide the data bar values
        dataBar.showValue = false;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DataBar-1.xlsx');
        workbook.dispose();
      });
      test('DataBar-2', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 90;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 70;
        sheet.getRangeByName('A7').number = 96;
        sheet.getRangeByName('A8').number = 94;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 26;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.dataBar;
        final DataBar dataBar = condition.dataBar!;
        dataBar.minPoint.type = ConditionValueType.percent;
        dataBar.minPoint.value = '10';
        dataBar.maxPoint.type = ConditionValueType.percent;
        dataBar.maxPoint.value = '80';
        dataBar.barColor = '#9CD0F3';
        dataBar.showValue = false;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DataBar-2.xlsx');
        workbook.dispose();
      });
      test('DataBar-3', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 90;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 70;
        sheet.getRangeByName('A7').number = 96;
        sheet.getRangeByName('A8').number = 94;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 26;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.dataBar;
        final DataBar dataBar = condition.dataBar!;
        dataBar.minPoint.type = ConditionValueType.lowestValue;
        dataBar.maxPoint.type = ConditionValueType.highestValue;
        dataBar.dataBarAxisPosition = DataBarAxisPosition.middle;
        dataBar.barColor = '#9CD0F3';
        dataBar.showValue = false;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DataBar-3.xlsx');
        workbook.dispose();
      });
      test('DataBar-4', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 90;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 70;
        sheet.getRangeByName('A7').number = 96;
        sheet.getRangeByName('A8').number = 94;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 26;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.dataBar;
        final DataBar dataBar = condition.dataBar!;
        dataBar.minPoint.type = ConditionValueType.lowestValue;
        dataBar.maxPoint.type = ConditionValueType.highestValue;
        dataBar.dataBarDirection = DataBarDirection.rightToLeft;
        dataBar.barColor = '#9CD0F3';
        dataBar.showValue = false;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DataBar-4.xlsx');
        workbook.dispose();
      });
      test('DataBar-5', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 98;
        sheet.getRangeByName('A2').number = 89;
        sheet.getRangeByName('A3').number = 90;
        sheet.getRangeByName('A4').number = 78;
        sheet.getRangeByName('A5').number = 68;
        sheet.getRangeByName('A6').number = 70;
        sheet.getRangeByName('A7').number = 96;
        sheet.getRangeByName('A8').number = 94;
        sheet.getRangeByName('A9').number = 53;
        sheet.getRangeByName('A10').number = 26;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.dataBar;
        final DataBar dataBar = condition.dataBar!;

        dataBar.barColor = '#9ACD32';
        dataBar.negativeFillColor = '#FFC0CB';
        dataBar.negativeBorderColor = '#F5F5F5';
        dataBar.barAxisColor = '#FFFF00';
        dataBar.borderColor = '#F5F5F5';
        dataBar.dataBarDirection = DataBarDirection.rightToLeft;
        dataBar.dataBarAxisPosition = DataBarAxisPosition.middle;
        dataBar.hasGradientFill = true;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DataBar-5.xlsx');
        workbook.dispose();
      });
      test('DataBar-6', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 20;
        sheet.getRangeByName('A2').number = 9;
        sheet.getRangeByName('A3').number = -18;
        sheet.getRangeByName('A4').number = -12;
        sheet.getRangeByName('A5').number = 3;
        sheet.getRangeByName('A6').number = -27;
        sheet.getRangeByName('A7').number = 19;
        sheet.getRangeByName('A8').number = 33;
        sheet.getRangeByName('A9').number = 23;
        sheet.getRangeByName('A10').number = -19;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.dataBar;
        final DataBar dataBar = condition.dataBar!;
        dataBar.barColor = '#FFD700';
        dataBar.negativeFillColor = '#006400';

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DataBar-6.xlsx');
        workbook.dispose();
      });
      test('DataBar-7', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 20;
        sheet.getRangeByName('A2').number = 9;
        sheet.getRangeByName('A3').number = -18;
        sheet.getRangeByName('A4').number = -12;
        sheet.getRangeByName('A5').number = 3;
        sheet.getRangeByName('A6').number = -27;
        sheet.getRangeByName('A7').number = 19;
        sheet.getRangeByName('A8').number = 33;
        sheet.getRangeByName('A9').number = 23;
        sheet.getRangeByName('A10').number = -19;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();

        condition.formatType = ExcelCFType.dataBar;
        final DataBar dataBar = condition.dataBar!;
        dataBar.barColor = '#FFD700';
        dataBar.negativeFillColor = '#006400';
        dataBar.dataBarAxisPosition = DataBarAxisPosition.none;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DataBar-7.xlsx');
        workbook.dispose();
      });
      test('DataBar-8', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 1277;
        sheet.getRangeByName('A2').number = 1003;
        sheet.getRangeByName('A3').number = -1105;
        sheet.getRangeByName('A4').number = -752;
        sheet.getRangeByName('A5').number = 770;
        sheet.getRangeByName('A6').number = -621;
        sheet.getRangeByName('A7').number = 1311;
        sheet.getRangeByName('A8').number = 730;
        sheet.getRangeByName('A9').number = 511;
        sheet.getRangeByName('A10').number = 952;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        conditionalFormat.formatType = ExcelCFType.dataBar;
        final DataBar dataBar = conditionalFormat.dataBar!;

        //Set type and value.
        dataBar.minPoint.type = ConditionValueType.percent;
        dataBar.minPoint.value = '20';
        dataBar.maxPoint.type = ConditionValueType.percent;
        dataBar.maxPoint.value = '90';
        //Set minumum percentage.
        dataBar.percentMin = 20;
        // Set maximum percentage.
        dataBar.percentMax = 90;
        //Set color for DataBar
        dataBar.barColor = '#FF7C80';
        //Hide the data bar values
        dataBar.showValue = false;
        // Set Gradient fill to false.
        dataBar.hasGradientFill = false;
        //Set NegativeBorder color for DataBar
        dataBar.negativeBorderColor = '#ED7D31';
        //Set NegativeBar color for DataBar
        dataBar.negativeFillColor = '#013461';
        //Set BarAxis color for DataBar.
        dataBar.barAxisColor = '#FFDD12';
        //Set Border color for DataBar
        dataBar.borderColor = '#12DD01';
        //Set Bar Axis Position.
        dataBar.dataBarAxisPosition = DataBarAxisPosition.middle;
        //Set Bar Direction
        dataBar.dataBarDirection = DataBarDirection.rightToLeft;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DataBar-8.xlsx');
        workbook.dispose();
      });
      test('DataBar-9', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 20;
        sheet.getRangeByName('A2').number = 9;
        sheet.getRangeByName('A3').number = -18;
        sheet.getRangeByName('A4').number = -12;
        sheet.getRangeByName('A5').number = 3;
        sheet.getRangeByName('A6').number = -27;
        sheet.getRangeByName('A7').number = 19;
        sheet.getRangeByName('A8').number = 33;
        sheet.getRangeByName('A9').number = 23;
        sheet.getRangeByName('A10').number = -19;

        final ConditionalFormats conditions =
            sheet.getRangeByName('A1:A10').conditionalFormats;
        final ConditionalFormat condition = conditions.addCondition();
        condition.formatType = ExcelCFType.dataBar;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DataBar-9.xlsx');
        workbook.dispose();
      });
    });
    group('Color property RGB', () {
      test('Format with RGB', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();
        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByIndex(1, 1).setText('Conditional Formts');
        sheet.getRangeByIndex(2, 1).setNumber(10);
        sheet.getRangeByIndex(3, 1).setNumber(20);
        sheet.getRangeByIndex(4, 1).setNumber(30);
        sheet.getRangeByIndex(5, 1).setNumber(40);
        sheet.getRangeByIndex(6, 1).setNumber(50);
        sheet.getRangeByIndex(7, 1).setNumber(60);
        sheet.getRangeByIndex(8, 1).setNumber(70);
        sheet.getRangeByIndex(9, 1).setNumber(80);
        sheet.getRangeByIndex(10, 1).setNumber(90);
        sheet.getRangeByIndex(11, 1).setNumber(100);

        // Applying conditional formatting to 'A1:A11'.
        final ConditionalFormats conditions =
            sheet.getRangeByName('A2:A11').conditionalFormats;
        final ConditionalFormat condition1 = conditions.addCondition();

        //Set formatType.
        condition1.formatType = ExcelCFType.cellValue;

        //Set operators.
        condition1.operator = ExcelComparisonOperator.greater;

        //Set firstFormula.
        condition1.firstFormula = '30';

        //Set back color RGB.
        condition1.backColorRgb = const Color.fromARGB(250, 156, 135, 5);
        //Set font Color RGB.
        condition1.fontColorRgb = const Color.fromARGB(234, 151, 13, 145);
        //Set left border style and color RGB.
        condition1.leftBorderStyle = LineStyle.double;
        condition1.leftBorderColorRgb = const Color.fromARGB(190, 14, 0, 200);
        //Set right border style and color RGB.
        condition1.rightBorderStyle = LineStyle.thick;
        condition1.rightBorderColorRgb = const Color.fromARGB(255, 200, 200, 0);
        //Set top border style and color RGB.
        condition1.topBorderStyle = LineStyle.medium;
        condition1.topBorderColorRgb = const Color.fromARGB(200, 141, 13, 0);
        //Set bottom border style and color RGB.
        condition1.bottomBorderStyle = LineStyle.thin;
        condition1.bottomBorderColorRgb =
            const Color.fromARGB(255, 0, 200, 100);

        //save and dispose.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFRGB.xlsx');
        workbook.dispose();
      });
      test('ColorScale RGB', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A8').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        // set colorscale CF.
        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(3);

        // set Color for FormatcolorRgb Property.
        colorScale.criteria[0].formatColorRgb =
            const Color.fromARGB(255, 134, 10, 200);
        colorScale.criteria[0].type = ConditionValueType.lowestValue;
        colorScale.criteria[0].value = '0';

        // set Color for FormatcolorRgb Property.
        colorScale.criteria[1].formatColorRgb =
            const Color.fromARGB(255, 13, 200, 20);
        colorScale.criteria[1].type = ConditionValueType.percentile;
        colorScale.criteria[1].value = '55';

        // set Color for FormatcolorRgb Property.
        // colorScale.criteria[2].formatColor = '#78976A';
        colorScale.criteria[2].formatColorRgb =
            const Color.fromARGB(255, 184, 110, 20);
        colorScale.criteria[2].type = ConditionValueType.highestValue;
        colorScale.criteria[2].value = '0';

        expect(
            colorScale.criteria[1].formatColorRgb.value
                .toRadixString(16)
                .toUpperCase(),
            colorScale.criteria[1].formatColor);

        //save and dispose.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFColorScaleRGB.xlsx');
        workbook.dispose();
      });
      test('ColorScale RGB_1', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();

        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = 84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;

        //Create color scale for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A8').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();

        // set colorscale CF.
        conditionalFormat.formatType = ExcelCFType.colorScale;
        final ColorScale colorScale = conditionalFormat.colorScale!;

        //Sets 3 - color scale and its constraints
        colorScale.setConditionCount(3);

        // set Color for FormatcolorRgb Property.
        colorScale.criteria[0].formatColorRgb =
            const Color.fromARGB(255, 134, 10, 20);
        colorScale.criteria[0].type = ConditionValueType.number;
        colorScale.criteria[0].value = '20';

        // set Color for FormatcolorRgb Property.
        colorScale.criteria[1].formatColor = '#FFFF00';
        colorScale.criteria[1].type = ConditionValueType.percent;
        colorScale.criteria[1].value = '45';

        // set Color for FormatcolorRgb Property.
        colorScale.criteria[2].formatColorRgb =
            const Color.fromARGB(255, 18, 110, 200);
        colorScale.criteria[2].type = ConditionValueType.highestValue;
        colorScale.criteria[2].value = '0';

        expect(
            colorScale.criteria[1].formatColorRgb.value
                .toRadixString(16)
                .toUpperCase(),
            colorScale.criteria[1].formatColor.replaceAll('#', 'FF'));

        //save and dispose.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFColorScaleRGB1.xlsx');
        workbook.dispose();
      });
      test('DataBar RGB', () {
        // Create a new Excel Document.
        final Workbook workbook = Workbook();
        // Accessing sheet via index.
        final Worksheet sheet = workbook.worksheets[0];
        sheet.getRangeByName('A1').number = 12;
        sheet.getRangeByName('A2').number = 29;
        sheet.getRangeByName('A3').number = 41;
        sheet.getRangeByName('A4').number = -84;
        sheet.getRangeByName('A5').number = 90;
        sheet.getRangeByName('A6').number = 112;
        sheet.getRangeByName('A7').number = 131;
        sheet.getRangeByName('A8').number = 20;
        //Create data bars for the data in specified range.
        final ConditionalFormats conditionalFormats =
            sheet.getRangeByName('A1:A8').conditionalFormats;
        final ConditionalFormat conditionalFormat =
            conditionalFormats.addCondition();
        conditionalFormat.formatType = ExcelCFType.dataBar;
        final DataBar dataBar = conditionalFormat.dataBar!;
        //Set type and value.
        dataBar.minPoint.type = ConditionValueType.percent;
        dataBar.minPoint.value = '10';
        dataBar.maxPoint.type = ConditionValueType.percent;
        dataBar.maxPoint.value = '90';

        //Set color for DataBar
        dataBar.barColorRgb = const Color.fromARGB(255, 200, 13, 145);
        //Hide the data bar values
        dataBar.showValue = false;
        // Set Gradient fill to false.
        dataBar.hasGradientFill = false;
        //Set NegativeBorder color for DataBar
        dataBar.negativeBorderColorRgb = const Color.fromARGB(255, 200, 130, 0);
        // Set NegativeBar color for DataBar
        dataBar.negativeFillColorRgb = const Color.fromARGB(230, 201, 230, 100);
        // Set BarAxis color for DataBar.
        dataBar.barAxisColorRgb = const Color.fromARGB(255, 134, 44, 224);
        //Set Border color for DataBar.
        dataBar.borderColorRgb = const Color.fromARGB(245, 45, 244, 230);
        //Set Bar Axis Position.
        dataBar.dataBarAxisPosition = DataBarAxisPosition.middle;
        //Set Bar Direction
        dataBar.dataBarDirection = DataBarDirection.rightToLeft;
        dataBar.hasBorder = true;

        //save and dispose.
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCFDataBarRGB.xlsx');
        workbook.dispose();
      });
    });
  });
}
