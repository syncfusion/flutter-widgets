// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioDataValidation() {
  group('DataValidation', () {
    group('Test cases for allowType', () {
      test('TextLength AllowType', () {
        //creates one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell by cellName and applying the textLength properties
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be between 1 to 5 characters';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.promptBoxTitle = 'textLength';

        expect(
            textLengthValidation.allowType, ExcelDataValidationType.textLength);
        expect(textLengthValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.between);
        expect(textLengthValidation.firstFormula, '1');
        expect(textLengthValidation.secondFormula, '5');
        expect(textLengthValidation.errorBoxText,
            'Text length should be between 1 to 5 characters');
        expect(textLengthValidation.errorBoxTitle, 'ERROR');
        expect(textLengthValidation.promptBoxText,
            'Data validation for text length');
        expect(textLengthValidation.showPromptBox, true);
        expect(textLengthValidation.promptBoxTitle, 'textLength');

        //Accessing the second cell by cellName and applying the textLength properties
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation1.firstFormula = '1';
        textLengthValidation1.secondFormula = '5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidation.xlsx');
        workbook.dispose();
      });

      test('Integer AllowType', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the integer properties
        final DataValidation integerValidation =
            sheet.getRangeByName('A1').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        integerValidation.firstFormula = '1';
        integerValidation.secondFormula = '5';
        integerValidation.errorBoxText =
            'Integer value should be given between 1 to 5';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxText = 'Data validation for integer';
        integerValidation.showPromptBox = true;

        expect(integerValidation.allowType, ExcelDataValidationType.integer);
        expect(integerValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.between);
        expect(integerValidation.firstFormula, '1');
        expect(integerValidation.secondFormula, '5');
        expect(integerValidation.errorBoxText,
            'Integer value should be given between 1 to 5');
        expect(integerValidation.errorBoxTitle, 'ERROR');
        expect(integerValidation.promptBoxText, 'Data validation for integer');
        expect(integerValidation.showPromptBox, true);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelIntegerValidation.xlsx');
        workbook.dispose();
      });

      test('Decimal AllowType', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the decimal properties
        final DataValidation decimalValidation =
            sheet.getRangeByName('A1').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        decimalValidation.firstFormula = '1.5';
        decimalValidation.secondFormula = '5.5';
        decimalValidation.errorBoxText =
            'decimal value should be given and it should be between 1.5 and 2.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxText = 'Data validation for decimal';
        decimalValidation.showPromptBox = true;

        expect(decimalValidation.allowType, ExcelDataValidationType.decimal);
        expect(decimalValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.between);
        expect(decimalValidation.firstFormula, '1.5');
        expect(decimalValidation.secondFormula, '5.5');
        expect(decimalValidation.errorBoxText,
            'decimal value should be given and it should be between 1.5 and 2.5');
        expect(decimalValidation.errorBoxTitle, 'ERROR');
        expect(decimalValidation.promptBoxText, 'Data validation for decimal');
        expect(decimalValidation.showPromptBox, true);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceldecimalValidation.xlsx');
        workbook.dispose();
      });

      test('Any AllowType', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the any properties
        final DataValidation anyValidation =
            sheet.getRangeByName('A1').dataValidation;
        anyValidation.allowType = ExcelDataValidationType.any;

        expect(anyValidation.allowType, ExcelDataValidationType.any);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelAnyValidation.xlsx');
        workbook.dispose();
      });

      test('Date AllowType', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the date properties
        final DataValidation dateValidation =
            sheet.getRangeByName('A1').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);
        dateValidation.secondDateTime = DateTime(1997, 07, 25);
        dateValidation.errorBoxText =
            'date value should be given and it should be between 22ndJuly1997 and 25thJuly1997';
        dateValidation.errorBoxTitle = 'ERROR';
        dateValidation.promptBoxText = 'Data validation for date';
        dateValidation.showPromptBox = true;

        expect(dateValidation.allowType, ExcelDataValidationType.date);
        expect(dateValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.between);
        expect(dateValidation.firstDateTime, DateTime(1997, 07, 22));
        expect(dateValidation.secondDateTime, DateTime(1997, 07, 25));
        expect(dateValidation.errorBoxText,
            'date value should be given and it should be between 22ndJuly1997 and 25thJuly1997');
        expect(dateValidation.promptBoxText, 'Data validation for date');
        expect(dateValidation.errorBoxTitle, 'ERROR');
        expect(dateValidation.showPromptBox, true);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceldateValidation.xlsx');
        workbook.dispose();
      });

      test('User AllowType', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the User properties
        final DataValidation listValidation =
            sheet.getRangeByName('A1').dataValidation;
        listValidation.allowType = ExcelDataValidationType.user;
        listValidation.listOfValues = <String>['List1', 'List2', 'List3'];
        listValidation.errorBoxText = 'The value given in list should be given';
        listValidation.errorBoxTitle = 'ERROR';
        listValidation.promptBoxText = 'Data validation for list';
        listValidation.showPromptBox = true;

        expect(listValidation.allowType, ExcelDataValidationType.user);
        expect(
            listValidation.listOfValues, <String>['List1', 'List2', 'List3']);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelUserValidation.xlsx');
        workbook.dispose();
      });

      test('Formula AllowType', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the custom property
        final DataValidation customValidation =
            sheet.getRangeByName('A1').dataValidation;
        customValidation.allowType = ExcelDataValidationType.formula;
        customValidation.firstFormula = '=ISNUMBER(C2)';
        customValidation.errorBoxText = 'Valid Custom value should be given';
        customValidation.errorBoxTitle = 'ERROR';
        customValidation.promptBoxText = 'Data validation for Custom';
        customValidation.showPromptBox = true;

        expect(customValidation.allowType, ExcelDataValidationType.formula);
        expect(customValidation.firstFormula, '=ISNUMBER(C2)');
        expect(customValidation.errorBoxText,
            'Valid Custom value should be given');

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelFormulaValidation.xlsx');
        workbook.dispose();
      });

      test('Time AllowType', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the Time property
        final DataValidation timeValidation =
            sheet.getRangeByName('A1').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.firstFormula = '1:00';
        timeValidation.secondFormula = '2:00';
        timeValidation.errorBoxText = 'Valid Time value should be given';
        timeValidation.errorBoxTitle = 'ERROR';
        timeValidation.promptBoxText = 'Data validation for Time';
        timeValidation.showPromptBox = true;

        expect(timeValidation.allowType, ExcelDataValidationType.time);
        expect(timeValidation.firstFormula, '1:00');
        expect(timeValidation.secondFormula, '2:00');
        expect(timeValidation.errorBoxText, 'Valid Time value should be given');

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelTimeValidation.xlsx');
        workbook.dispose();
      });
      test('DataRange', () {
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the dataRange property
        final DataValidation dataRangeValidation =
            sheet.getRangeByName('A1').dataValidation;
        sheet.getRangeByName('D1').text = 'ListItem1';
        sheet.getRangeByName('D2').text = 'ListItem2';

        dataRangeValidation.dataRange = sheet.getRangeByName('D1:D2');
        dataRangeValidation.errorBoxText =
            'Valid value given in list should be given';
        dataRangeValidation.errorBoxTitle = 'ERROR';
        dataRangeValidation.promptBoxText = 'List';
        dataRangeValidation.showPromptBox = true;

        expect(dataRangeValidation.allowType, ExcelDataValidationType.user);
        expect(
            dataRangeValidation.errorStyle, ExcelDataValidationErrorStyle.stop);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDataRangeValidation.xlsx');
        workbook.dispose();
      });
    });
    group('TextLength AllowType', () {
      test('Between Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the textLength with Between property
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be between 1 and 5';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxTitle = 'TextLength';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        expect(textLengthValidation.errorStyle,
            ExcelDataValidationErrorStyle.warning);

        //Accessing the second cell in excel-sheet and applying the textLength with Between property
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation1.firstFormula = '1';
        textLengthValidation1.secondFormula = '5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationbetween.xlsx');
        workbook.dispose();
      });
      test('NotBetween Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the textLength with NotBetween property
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notBetween;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should not be between 1 and 5';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxTitle = 'TextLength';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        expect(textLengthValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.notBetween);

        //Accessing the second cell in excel-sheet and applying the textLength with NotBetween property
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.notBetween;
        textLengthValidation1.firstFormula = '1';
        textLengthValidation1.secondFormula = '5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationnotbetween.xlsx');
        workbook.dispose();
      });
      test('EqualTo Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the textLength with Equal property
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.equal;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.errorBoxText =
            'Text length should be equal to 1 character';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxTitle = 'TextLength';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        expect(textLengthValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.equal);

        //Accessing the second cell in excel-sheet and applying the textLength with Equal property
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.equal;
        textLengthValidation1.firstFormula = '1';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationequal.xlsx');
        workbook.dispose();
      });
      test('NotEqual property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the textLength with NotEqual property
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notEqual;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.errorBoxText =
            'Text length should not be equal to 1 character';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxTitle = 'TextLength';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.errorStyle =
            ExcelDataValidationErrorStyle.information;

        expect(textLengthValidation.errorStyle,
            ExcelDataValidationErrorStyle.information);
        expect(textLengthValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.notEqual);

        //Accessing the second cell in excel-sheet and applying the textLength with NotEqual property
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.notEqual;
        textLengthValidation1.firstFormula = '1';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationNotEqual.xlsx');
        workbook.dispose();
      });
      test('Greater Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the textLength with GreaterThan property
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.greater;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.errorBoxText =
            'Text length should be greater than 1 character';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxTitle = 'TextLength';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.errorStyle =
            ExcelDataValidationErrorStyle.information;

        expect(textLengthValidation.errorStyle,
            ExcelDataValidationErrorStyle.information);

        //Accessing the second cell in excel-sheet and applying the textLength with GreaterThan property
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.greater;
        textLengthValidation1.firstFormula = '1';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationGreater.xlsx');
        workbook.dispose();
      });
      test('LessThan Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the textLength with LessThan property
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.less;
        textLengthValidation.firstFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be less than 5 characters';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxTitle = 'TextLength';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        expect(textLengthValidation.errorStyle,
            ExcelDataValidationErrorStyle.warning);
        expect(textLengthValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.less);

        //Accessing the second cell in excel-sheet and applying the textLength with LessThan property
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.less;
        textLengthValidation1.firstFormula = '5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationLessThan.xlsx');
        workbook.dispose();
      });
      test('GreaterThanOrEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the textLength
        //with GreaterThanOrEqual property
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.greaterOrEqual;
        textLengthValidation.firstFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be greaterThanorEqual to 5 characters';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxTitle = 'TextLength';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        expect(textLengthValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.greaterOrEqual);

        //Accessing the second cell in excel-sheet and applying the textLength
        //with GreaterThanOrEqual property
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.greaterOrEqual;
        textLengthValidation1.firstFormula = '5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationGraterThanOrEqual.xlsx');
        workbook.dispose();
      });
      test('LessThanOrEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the textLength
        //with LessThanOrEqual property
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.lessOrEqual;
        textLengthValidation.firstFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be lessThanOrEqual to 5 characters';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxTitle = 'TextLength';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        expect(textLengthValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.lessOrEqual);

        //Accessing the second cell in excel-sheet and applying the textLength
        //with LessThanOrEqual property
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.lessOrEqual;
        textLengthValidation1.firstFormula = '5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationLessThanOrEqual.xlsx');
        workbook.dispose();
      });
    });
    group('Integer AllowType', () {
      test('Between Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in the worksheet and applying the Integer with Between Property
        final DataValidation integerValidation =
            sheet.getRangeByName('A1').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        integerValidation.firstFormula = '1';
        integerValidation.secondFormula = '5';
        integerValidation.errorBoxText =
            'Integer value should be between 1 to 5';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxTitle = 'Integer';
        integerValidation.promptBoxText = 'Data validation for Integer';
        integerValidation.showPromptBox = true;
        integerValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        expect(integerValidation.allowType, ExcelDataValidationType.integer);
        expect(integerValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.between);

        //Accessing the second cell in the worksheet and applying the Integer with Between Property
        final DataValidation integerValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        integerValidation1.allowType = ExcelDataValidationType.integer;
        integerValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        integerValidation1.firstFormula = '1';
        integerValidation1.secondFormula = '5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelIntegerValidationbetween.xlsx');
        workbook.dispose();
      });
      test('NotBetween Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the integer with NotBetween property
        final DataValidation integerValidation =
            sheet.getRangeByName('A1').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notBetween;
        integerValidation.firstFormula = '1';
        integerValidation.secondFormula = '5';
        integerValidation.errorBoxText =
            'Integer value should not be between 1 to 5';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxTitle = 'Integer';
        integerValidation.promptBoxText = 'Data validation for Integer';
        integerValidation.showPromptBox = true;
        integerValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(integerValidation.allowType, ExcelDataValidationType.integer);
        expect(integerValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.notBetween);

        //Accessing the second cell in worksheet and applying the integer with NotBetween property
        final DataValidation integerValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        integerValidation1.allowType = ExcelDataValidationType.integer;
        integerValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.notBetween;
        integerValidation1.firstFormula = '1';
        integerValidation1.secondFormula = '5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelIntegerValidationNotBetween.xlsx');
        workbook.dispose();
      });
      test('Equal Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the integer with EqualTo property
        final DataValidation integerValidation =
            sheet.getRangeByName('A1').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.equal;
        integerValidation.firstFormula = '1';
        integerValidation.errorBoxText = 'Integer value should be equal to 1';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxTitle = 'Integer';
        integerValidation.promptBoxText = 'Data validation for Integer';
        integerValidation.showPromptBox = true;
        integerValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(integerValidation.allowType, ExcelDataValidationType.integer);
        expect(integerValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.equal);

        //Accessing the second cell in worksheet and applying the integer with EqualTo property
        final DataValidation integerValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        integerValidation1.allowType = ExcelDataValidationType.integer;
        integerValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.equal;
        integerValidation1.firstFormula = '1';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelIntegerValidationEqual.xlsx');
        workbook.dispose();
      });
      test('NotEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the integer with NotEqualTo property
        final DataValidation integerValidation =
            sheet.getRangeByName('A1').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notEqual;
        integerValidation.firstFormula = '1';
        integerValidation.errorBoxText =
            'Integer value should not be equal to 1';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxTitle = 'Integer';
        integerValidation.promptBoxText = 'Data validation for Integer';
        integerValidation.showPromptBox = true;
        integerValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(integerValidation.allowType, ExcelDataValidationType.integer);
        expect(integerValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.notEqual);

        //Accessing the second cell in worksheet and applying the integer with NotEqualTo property
        final DataValidation integerValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        integerValidation1.allowType = ExcelDataValidationType.integer;
        integerValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.notEqual;
        integerValidation1.firstFormula = '1';

        //Save and dispose workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelIntegerValidationNotEqual.xlsx');
        workbook.dispose();
      });
      test('Greater Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the integer with GreaterThan property
        final DataValidation integerValidation =
            sheet.getRangeByName('A1').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.greater;
        integerValidation.firstFormula = '1';
        integerValidation.errorBoxText =
            'Integer value should be greater than 1';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxTitle = 'Integer';
        integerValidation.promptBoxText = 'Data validation for Integer';
        integerValidation.showPromptBox = true;
        integerValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(integerValidation.allowType, ExcelDataValidationType.integer);
        expect(integerValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.greater);

        //Accessing the second cell in worksheet and applying the integer with GreaterThan property
        final DataValidation integerValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        integerValidation1.allowType = ExcelDataValidationType.integer;
        integerValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.greater;
        integerValidation1.firstFormula = '1';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelIntegerValidationGreaterThan.xlsx');
        workbook.dispose();
      });
      test('Less Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the integer with LessThan property
        final DataValidation integerValidation =
            sheet.getRangeByName('A1').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.less;
        integerValidation.firstFormula = '2';
        integerValidation.errorBoxText = 'Integer value should be less than 2';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxTitle = 'Integer';
        integerValidation.promptBoxText = 'Data validation for Integer';
        integerValidation.showPromptBox = true;
        integerValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(integerValidation.allowType, ExcelDataValidationType.integer);
        expect(integerValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.less);

        //Accessing the second cell in worksheet and applying the integer with LessThan property
        final DataValidation integerValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        integerValidation1.allowType = ExcelDataValidationType.integer;
        integerValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.less;
        integerValidation1.firstFormula = '2';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelIntegerValidationLessThan.xlsx');
        workbook.dispose();
      });
      test('greaterOrEqual', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the integer with GreaterThanOrEqual property
        final DataValidation integerValidation =
            sheet.getRangeByName('A1').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.greaterOrEqual;
        integerValidation.firstFormula = '2';
        integerValidation.errorBoxText =
            'Integer value should be greater than or Equal to 2';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxTitle = 'Integer';
        integerValidation.promptBoxText = 'Data validation for Integer';
        integerValidation.showPromptBox = true;
        integerValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(integerValidation.allowType, ExcelDataValidationType.integer);
        expect(integerValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.greaterOrEqual);

        //Accessing the second cell in worksheet and applying the integer with GreaterThanOrEqual property
        final DataValidation integerValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        integerValidation1.allowType = ExcelDataValidationType.integer;
        integerValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.greaterOrEqual;
        integerValidation1.firstFormula = '2';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelIntegerValidationGreaterOrEqual.xlsx');
        workbook.dispose();
      });
      test('LessThanOrEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the integer with LessThanOrEqual property
        final DataValidation integerValidation =
            sheet.getRangeByName('A1').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.lessOrEqual;
        integerValidation.firstFormula = '2';
        integerValidation.errorBoxText =
            'Integer value should be less than or Equal to 2';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxTitle = 'Integer';
        integerValidation.promptBoxText = 'Data validation for Integer';
        integerValidation.showPromptBox = true;
        integerValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(integerValidation.allowType, ExcelDataValidationType.integer);
        expect(integerValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.lessOrEqual);

        //Accessing the second cell in worksheet and applying the integer with LessThanOrEqual property
        final DataValidation integerValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        integerValidation1.allowType = ExcelDataValidationType.integer;
        integerValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.lessOrEqual;
        integerValidation1.firstFormula = '2';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelIntegerValidationLesseOrrEqual.xlsx');
        workbook.dispose();
      });
    });
    group('Decimal AllowType', () {
      test('Between Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the decimal with Between property
        final DataValidation decimalValidation =
            sheet.getRangeByName('A1').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        decimalValidation.firstFormula = '2.5';
        decimalValidation.secondFormula = '5.5';
        decimalValidation.errorBoxText =
            'decimal value should be between 2.5 to 5.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxTitle = 'Decimal';
        decimalValidation.promptBoxText = 'Data validation for decimal';
        decimalValidation.showPromptBox = true;
        decimalValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        expect(decimalValidation.allowType, ExcelDataValidationType.decimal);
        expect(decimalValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.between);

        //Accessing the second cell in worksheet and applying the decimal with Between property
        final DataValidation decimalValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        decimalValidation1.allowType = ExcelDataValidationType.decimal;
        decimalValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        decimalValidation1.firstFormula = '2.5';
        decimalValidation1.secondFormula = '5.5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDecimalValidationBetween.xlsx');
        workbook.dispose();
      });
      test('NotBetween Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the decimal with NotBetween property
        final DataValidation decimalValidation =
            sheet.getRangeByName('A1').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notBetween;
        decimalValidation.firstFormula = '1.5';
        decimalValidation.secondFormula = '5.5';
        decimalValidation.errorBoxText =
            'decimal value should not be between 1.5 to 5.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxTitle = 'decimal';
        decimalValidation.promptBoxText = 'Data validation for decimal';
        decimalValidation.showPromptBox = true;
        decimalValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(decimalValidation.allowType, ExcelDataValidationType.decimal);
        expect(decimalValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.notBetween);

        //Accessing the second cell in worksheet and applying the decimal with NotBetween property
        final DataValidation decimalValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        decimalValidation1.allowType = ExcelDataValidationType.decimal;
        decimalValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.notBetween;
        decimalValidation1.firstFormula = '1.5';
        decimalValidation1.secondFormula = '5.5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDecimalValidationNotBetween.xlsx');
        workbook.dispose();
      });
      test('Equal Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the decimal with EqualTo property
        final DataValidation decimalValidation =
            sheet.getRangeByName('A1').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.equal;
        decimalValidation.firstFormula = '1.5';
        decimalValidation.errorBoxText = 'Decimal value should be equal to 1.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxTitle = 'Decimal';
        decimalValidation.promptBoxText = 'Data validation for Decimal';
        decimalValidation.showPromptBox = true;
        decimalValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(decimalValidation.allowType, ExcelDataValidationType.decimal);
        expect(decimalValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.equal);

        //Accessing the second cell in worksheet and applying the decimal with EqualTo property
        final DataValidation decimalValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        decimalValidation1.allowType = ExcelDataValidationType.decimal;
        decimalValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.equal;
        decimalValidation1.firstFormula = '1.5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDecimalValidationEqual.xlsx');
        workbook.dispose();
      });
      test('NotEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the decimal with NotEqualTo property
        final DataValidation decimalValidation =
            sheet.getRangeByName('A1').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notEqual;
        decimalValidation.firstFormula = '1.5';
        decimalValidation.errorBoxText =
            'Decimal value should not be equal to 1.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxTitle = 'Decimal';
        decimalValidation.promptBoxText = 'Data validation for Decimal';
        decimalValidation.showPromptBox = true;
        decimalValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(decimalValidation.allowType, ExcelDataValidationType.decimal);
        expect(decimalValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.notEqual);

        //Accessing the second cell in worksheet and applying the decimal with NotEqualTo property
        final DataValidation decimalValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        decimalValidation1.allowType = ExcelDataValidationType.decimal;
        decimalValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.notEqual;
        decimalValidation1.firstFormula = '1.5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDecimalValidationNotEqual.xlsx');
        workbook.dispose();
      });
      test('Greater Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the decimal with GreaterThan property
        final DataValidation decimalValidation =
            sheet.getRangeByName('A1').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.greater;
        decimalValidation.firstFormula = '1.5';
        decimalValidation.errorBoxText =
            'Decimal value should be greater than 1.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxTitle = 'Decimal';
        decimalValidation.promptBoxText = 'Data validation for Decimal';
        decimalValidation.showPromptBox = true;
        decimalValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(decimalValidation.allowType, ExcelDataValidationType.decimal);
        expect(decimalValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.greater);

        //Accessing the second cell in worksheet and applying the decimal with GreaterThan property
        final DataValidation decimalValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        decimalValidation1.allowType = ExcelDataValidationType.decimal;
        decimalValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.greater;
        decimalValidation1.firstFormula = '1.5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDecimalValidationGreaterThan.xlsx');
        workbook.dispose();
      });
      test('Less Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the decimal with LessThan property
        final DataValidation decimalValidation =
            sheet.getRangeByName('A1').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.less;
        decimalValidation.firstFormula = '2.5';
        decimalValidation.errorBoxText =
            'Decimal value should be less than 2.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxTitle = 'Decimal';
        decimalValidation.promptBoxText = 'Data validation for Decimal';
        decimalValidation.showPromptBox = true;
        decimalValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(decimalValidation.allowType, ExcelDataValidationType.decimal);
        expect(decimalValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.less);

        //Accessing the second cell in worksheet and applying the decimal with LessThan property
        final DataValidation decimalValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        decimalValidation1.allowType = ExcelDataValidationType.decimal;
        decimalValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.less;
        decimalValidation1.firstFormula = '2.5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDecimalValidationLessThan.xlsx');
        workbook.dispose();
      });
      test('GreaterOrEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the decimal with GreaterThanOrEqual property
        final DataValidation decimalValidation =
            sheet.getRangeByName('A1').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.greaterOrEqual;
        decimalValidation.firstFormula = '2.5';
        decimalValidation.errorBoxText =
            'Decimal value should be greater than or Equal to 2.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxTitle = 'Decimal';
        decimalValidation.promptBoxText = 'Data validation for Decimal';
        decimalValidation.showPromptBox = true;
        decimalValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(decimalValidation.allowType, ExcelDataValidationType.decimal);
        expect(decimalValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.greaterOrEqual);

        //Accessing the second cell in worksheet and applying the decimal with GreaterThanOrEqual property
        final DataValidation decimalValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        decimalValidation1.allowType = ExcelDataValidationType.decimal;
        decimalValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.greaterOrEqual;
        decimalValidation1.firstFormula = '2.5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDecimalValidationGreaterOrEqual.xlsx');
        workbook.dispose();
      });
      test('LessThanOrEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the decimal with LessThanOrEqual property
        final DataValidation decimalValidation =
            sheet.getRangeByName('A1').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.lessOrEqual;
        decimalValidation.firstFormula = '2.5';
        decimalValidation.errorBoxText =
            'Decimal value should be less than or Equal to 2.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxTitle = 'Decimal';
        decimalValidation.promptBoxText = 'Data validation for Decimal';
        decimalValidation.showPromptBox = true;
        decimalValidation.errorStyle = ExcelDataValidationErrorStyle.stop;

        expect(decimalValidation.allowType, ExcelDataValidationType.decimal);
        expect(decimalValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.lessOrEqual);

        //Accessing the second cell in worksheet and applying the decimal with LessThanOrEqual property
        final DataValidation decimalValidation1 =
            sheet.getRangeByName('A2').dataValidation;
        decimalValidation1.allowType = ExcelDataValidationType.decimal;
        decimalValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.lessOrEqual;
        decimalValidation1.firstFormula = '2.5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDecimalValidationLesseOrrEqual.xlsx');
        workbook.dispose();
      });
    });
    group('Date Property', () {
      test('Between Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the date with Between property
        final DataValidation dateValidation =
            sheet.getRangeByName('A1').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);
        dateValidation.secondDateTime = DateTime(1997, 07, 25);

        expect(dateValidation.allowType, ExcelDataValidationType.date);
        expect(dateValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.between);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDateValidationbetween.xlsx');
        workbook.dispose();
      });
      test('NotBetween Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the date with NotBetween property
        final DataValidation dateValidation =
            sheet.getRangeByName('A1').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notBetween;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);
        dateValidation.secondDateTime = DateTime(1997, 07, 25);

        expect(dateValidation.allowType, ExcelDataValidationType.date);
        expect(dateValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.notBetween);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDateValidationNotBetween.xlsx');
        workbook.dispose();
      });
      test('Equal Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the date with Equal property
        final DataValidation dateValidation =
            sheet.getRangeByName('A1').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.equal;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);

        expect(dateValidation.allowType, ExcelDataValidationType.date);
        expect(dateValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.equal);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDateValidationEqual.xlsx');
        workbook.dispose();
      });
      test('Notequal Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the date with NotEqual property
        final DataValidation dateValidation =
            sheet.getRangeByName('A1').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notEqual;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);

        expect(dateValidation.allowType, ExcelDataValidationType.date);
        expect(dateValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.notEqual);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDateValidationNotEqual.xlsx');
        workbook.dispose();
      });
      test('Greater Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the date with GreaterThan property
        final DataValidation dateValidation =
            sheet.getRangeByName('A1').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.greater;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);

        expect(dateValidation.allowType, ExcelDataValidationType.date);
        expect(dateValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.greater);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDateValidationGreater.xlsx');
        workbook.dispose();
      });
      test('less', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the date with LessThan property
        final DataValidation dateValidation =
            sheet.getRangeByName('A1').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.less;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);

        expect(dateValidation.allowType, ExcelDataValidationType.date);
        expect(dateValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.less);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDateValidationLessThan.xlsx');
        workbook.dispose();
      });
      test('GreaterOrEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the date with GreaterThanOrEqual property
        final DataValidation dateValidation =
            sheet.getRangeByName('A1').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.greaterOrEqual;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);

        expect(dateValidation.allowType, ExcelDataValidationType.date);
        expect(dateValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.greaterOrEqual);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDateValidationGreaterOrEqual.xlsx');
        workbook.dispose();
      });
      test('LessOrEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the date with LessOrEqual property
        final DataValidation dateValidation =
            sheet.getRangeByName('A1').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.lessOrEqual;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);

        expect(dateValidation.allowType, ExcelDataValidationType.date);
        expect(dateValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.lessOrEqual);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDateValidationLessOrEqual.xlsx');
        workbook.dispose();
      });
    });
    group('Time AllowType', () {
      test('Between Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the Time with Between property
        final DataValidation timeValidation =
            sheet.getRangeByName('A1').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        timeValidation.firstFormula = '10:00';
        timeValidation.secondFormula = '16:00';

        expect(timeValidation.allowType, ExcelDataValidationType.time);
        expect(timeValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.between);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelTimeValidationBetween.xlsx');
        workbook.dispose();
      });
      test('NotBetween Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the Time with NotBetween property
        final DataValidation timeValidation =
            sheet.getRangeByName('A1').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notBetween;
        timeValidation.firstFormula = '10:00';
        timeValidation.secondFormula = '16:00';

        expect(timeValidation.allowType, ExcelDataValidationType.time);
        expect(timeValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.notBetween);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelTimeValidationNotBetween.xlsx');
        workbook.dispose();
      });
      test('Equal Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the Time with Equal property
        final DataValidation timeValidation =
            sheet.getRangeByName('A1').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.equal;
        timeValidation.firstFormula = '10:00';

        expect(timeValidation.allowType, ExcelDataValidationType.time);
        expect(timeValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.equal);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelTimeValidationEqual.xlsx');
        workbook.dispose();
      });
      test('NotEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the Time with NotEqual property
        final DataValidation timeValidation =
            sheet.getRangeByName('A1').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notEqual;
        timeValidation.firstFormula = '10:00';

        expect(timeValidation.allowType, ExcelDataValidationType.time);
        expect(timeValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.notEqual);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelTimeValidationNotEqual.xlsx');
        workbook.dispose();
      });
      test('Greater Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the Time with Greater property
        final DataValidation timeValidation =
            sheet.getRangeByName('A1').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.greater;
        timeValidation.firstFormula = '10:00';

        expect(timeValidation.allowType, ExcelDataValidationType.time);
        expect(timeValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.greater);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelTimeValidationGreater.xlsx');
        workbook.dispose();
      });
      test('Less Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the Time with LessThan property
        final DataValidation timeValidation =
            sheet.getRangeByName('A1').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.less;
        timeValidation.firstFormula = '10:00';

        expect(timeValidation.allowType, ExcelDataValidationType.time);
        expect(timeValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.less);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelTimeValidationLessThan.xlsx');
        workbook.dispose();
      });
      test('GreaterOrEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the Time with GreaterOrEqual property
        final DataValidation timeValidation =
            sheet.getRangeByName('A1').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.greaterOrEqual;
        timeValidation.firstFormula = '10:00';

        expect(timeValidation.allowType, ExcelDataValidationType.time);
        expect(timeValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.greaterOrEqual);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelTimeValidationGreaterOrEqual.xlsx');
        workbook.dispose();
      });
      test('LessOrEqual Property', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the Time with LessThanOrEqual property
        final DataValidation timeValidation =
            sheet.getRangeByName('A1').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.lessOrEqual;
        timeValidation.firstFormula = '10:00';

        expect(timeValidation.allowType, ExcelDataValidationType.time);
        expect(timeValidation.comparisonOperator,
            ExcelDataValidationComparisonOperator.lessOrEqual);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelTimeValidationLessOrEqual.xlsx');
        workbook.dispose();
      });
    });

    group('promptBoxProperties', () {
      test('promptPositionProperties', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the textLength with promptBox property
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.promptBoxVPosition = 50;
        textLengthValidation.promptBoxHPosition = 50;
        textLengthValidation.promptBoxText = 'textLength Validation';
        textLengthValidation.isPromptBoxPositionFixed = true;
        textLengthValidation.isEmptyCellAllowed = false;

        expect(textLengthValidation.promptBoxVPosition, 50);
        expect(textLengthValidation.promptBoxHPosition, 50);
        expect(textLengthValidation.isPromptBoxPositionFixed, true);
        expect(textLengthValidation.isEmptyCellAllowed, false);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationpromptBox.xlsx');
        workbook.dispose();
      });
    });
    group('AllowType Properties', () {
      test('between', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the textLength property
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.errorBoxText =
            'textLength should be between 1 and 5';
        textLengthValidation.errorBoxTitle = 'textLength Validation';
        textLengthValidation.promptBoxVPosition = 50;
        textLengthValidation.promptBoxHPosition = 50;
        textLengthValidation.isPromptBoxPositionFixed = true;
        textLengthValidation.isEmptyCellAllowed = false;

        //Accessing second cell in worksheet and applying the integer property
        final DataValidation integerValidation =
            sheet.getRangeByName('A2').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notBetween;
        integerValidation.firstFormula = '1';
        integerValidation.secondFormula = '5';
        integerValidation.errorBoxText =
            'Integer Value should be between 1 and 5';
        integerValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        //Accessing third cell in worksheet and applying the decimal property
        DataValidation decimalValidation =
            sheet.getRangeByName('A3').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.equal;
        decimalValidation.firstFormula = '1';
        decimalValidation.errorBoxText = 'decimal Value should be equal to 1';
        decimalValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        //Accessing fourth cell in worksheet and applying the decimal property
        decimalValidation = sheet.getRangeByName('A4').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.notEqual;
        decimalValidation.firstFormula = '1';
        decimalValidation.errorBoxText =
            'decimal Value should not be equal to 1';
        decimalValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        //Accessing fifth cell in worksheet and applying the time property
        final DataValidation timeValidation =
            sheet.getRangeByName('A5').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        timeValidation.firstFormula = '10:00';
        timeValidation.secondFormula = '14:00';
        timeValidation.errorBoxText =
            'Time Value should be between 10:00 and 14:00';
        timeValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        //Accessing sixth cell in worksheet and applying the date property
        final DataValidation dateValidation =
            sheet.getRangeByName('A6').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);
        dateValidation.secondDateTime = DateTime(1997, 07, 25);
        dateValidation.errorBoxText =
            'date Value should be between 22/07/1997 and 25/07/1997';
        dateValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        //Accessing seventh cell in worksheet and applying the list property
        final DataValidation listValidation =
            sheet.getRangeByName('A7').dataValidation;
        listValidation.allowType = ExcelDataValidationType.user;
        listValidation.listOfValues = <String>['List1', 'List2', 'List3'];
        listValidation.errorBoxText = 'Value should be chosen from the list';
        listValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        //Accessing eighth cell in worksheet and applying the custom property
        final DataValidation customValidation =
            sheet.getRangeByName('A8').dataValidation;
        customValidation.allowType = ExcelDataValidationType.formula;
        customValidation.firstFormula = 'ISNUMBER(A8)';
        customValidation.errorBoxText =
            'Value provided does not match with the formula provided';
        customValidation.errorStyle = ExcelDataValidationErrorStyle.warning;

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDataValidationAllowTypeProperties.xlsx');
        workbook.dispose();
      });
      test('promptPositionProperties', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in worksheet and applying the textLength with promptbox properties
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.promptBoxText = 'textLength Validation';
        textLengthValidation.promptBoxVPosition = 50;
        textLengthValidation.promptBoxHPosition = 50;
        textLengthValidation.isPromptBoxPositionFixed = true;
        textLengthValidation.isEmptyCellAllowed = false;

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationpromptBox.xlsx');
        workbook.dispose();
      });
    });
    group('ConditionalFormat followed by DataValidation', () {
      test('dataValidation applied to cell without conditional formats', () {
        //creates one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell by cellName and applying the textLength properties
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be between 1 to 5 characters';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.promptBoxTitle = 'texLength';

        // Applying conditional formatting.
        final ConditionalFormats conditions =
            sheet.getRangeByName('A2:A4').conditionalFormats;
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
        sheet.getRangeByIndex(2, 1).number = 18;
        sheet.getRangeByIndex(3, 1).number = 12;
        sheet.getRangeByIndex(4, 1).number = 10;

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDataValidationWithoutConditionalFormat.xlsx');
        workbook.dispose();
      });

      test('dataValidation applied to cell with conditional formats', () {
        //creates one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
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

        //Accessing the first cell by cellName and applying the textLength properties
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be between 1 to 5 characters';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.promptBoxTitle = 'texLength';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDataValidationWithConditionalFormat.xlsx');
        workbook.dispose();
      });
      test(
          'dataValidation applied to cell with conditional formats and hyperlinks',
          () {
        //creates one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
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

        //Accessing the first cell by cellName and applying the textLength properties
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be between 1 to 5 characters';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.promptBoxTitle = 'texLength';

        //Accessing the first cell by cellName and applying the hyperLink properties
        final Range range = sheet.getRangeByName('A1');
        sheet.hyperlinks
            .add(range, HyperlinkType.url, 'http://www.syncfusion.com');

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(
            bytes, 'ExcelDataValidationWithHyperLinkandConditionalFormat.xlsx');
        workbook.dispose();
      });
    });
    group('Multiple Range', () {
      test('textLength', () {
        //creates one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the cell range A1:A4 by cellName and applying the textLength properties
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1:A4').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be between 1 to 5 characters';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.promptBoxTitle = 'texLength';

        expect(
            textLengthValidation.allowType, ExcelDataValidationType.textLength);

        //Accessing the cell Range B1:B5 by cellName and applying the textLength properties
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('B1:B5').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation1.firstFormula = '1';
        textLengthValidation1.secondFormula = '5';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceltextLengthValidationMulRangeAllowType.xlsx');
        workbook.dispose();
      });
      test('Integer', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the cell Range A1:A4 in excel-sheet and applying the integer properties
        final DataValidation integerValidation =
            sheet.getRangeByName('A1:A4').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        integerValidation.firstFormula = '1';
        integerValidation.secondFormula = '5';
        integerValidation.errorBoxText =
            'Integer value should be given between 1 to 5';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxText = 'Data validation for integer';
        integerValidation.showPromptBox = true;

        expect(integerValidation.allowType, ExcelDataValidationType.integer);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelIntegerValidationMulRangeAllowType.xlsx');
        workbook.dispose();
      });
      test('Decimal', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the cell Range A1:B4 in excel-sheet and applying the decimal properties
        final DataValidation decimalValidation =
            sheet.getRangeByName('A1:B4').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        decimalValidation.firstFormula = '1.5';
        decimalValidation.secondFormula = '5.5';
        decimalValidation.errorBoxText =
            'decimal value should be given and it should be between 1.5 and 2.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxText = 'Data validation for decimal';
        decimalValidation.showPromptBox = true;

        expect(decimalValidation.allowType, ExcelDataValidationType.decimal);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDecimalValidationMUlRangeAllowType.xlsx');
        workbook.dispose();
      });
      test('Any', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the first cell in excel-sheet and applying the any properties
        final DataValidation anyValidation =
            sheet.getRangeByName('A1:B4').dataValidation;
        anyValidation.allowType = ExcelDataValidationType.any;

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelAnyValidationMulRangeAllowType.xlsx');
        workbook.dispose();
      });
      test('Date', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the cell Range A1:B4 in excel-sheet and applying the date properties
        final DataValidation dateValidation =
            sheet.getRangeByName('A1:B4').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);
        dateValidation.secondDateTime = DateTime(1997, 07, 25);
        dateValidation.errorBoxText =
            'date value should be given and it should be between 22ndJuly1997 and 25thJuly1997';
        dateValidation.errorBoxTitle = 'ERROR';
        dateValidation.promptBoxText = 'Data validation for date';
        dateValidation.showPromptBox = true;

        expect(dateValidation.allowType, ExcelDataValidationType.date);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExceldateValidationMulRangeAllowType.xlsx');
        workbook.dispose();
      });
      test('User', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the cell Range A1:B4 excel-sheet and applying the list properties
        final DataValidation listValidation =
            sheet.getRangeByName('A1:B4').dataValidation;
        listValidation.listOfValues = <String>['List1', 'List2', 'List3'];
        listValidation.errorBoxText = 'The value given in list should be given';
        listValidation.errorBoxTitle = 'ERROR';
        listValidation.promptBoxText = 'Data validation for list';
        listValidation.showPromptBox = true;

        expect(listValidation.allowType, ExcelDataValidationType.user);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelUserValidationMulRangeAllowType.xlsx');
        workbook.dispose();
      });
      test('Formula', () {
        //Creating one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the cell Range A1:B4 in excel-sheet and applying the Custom property
        final DataValidation customValidation =
            sheet.getRangeByName('A1:B4').dataValidation;
        customValidation.allowType = ExcelDataValidationType.formula;
        customValidation.firstFormula = 'ISNUMBER(A1)';
        customValidation.errorBoxText = 'Valid value should be given';
        customValidation.errorBoxTitle = 'ERROR';
        customValidation.promptBoxText = 'Data validation for Custom';
        customValidation.showPromptBox = true;

        expect(customValidation.allowType, ExcelDataValidationType.formula);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCustomValidationMulRangeAllowType.xlsx');
        workbook.dispose();
      });
      test('Time', () {
        //Creating one worksheet and accessing the first sheet.
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the cellRange A1:B4 in excel-sheet and applying the Time property
        final DataValidation timeValidation =
            sheet.getRangeByName('A1:B4').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.firstFormula = '1:00';
        timeValidation.secondFormula = '2:00';
        timeValidation.errorBoxText = 'Valid Time value should be given';
        timeValidation.errorBoxTitle = 'ERROR';
        timeValidation.promptBoxText = 'Data validation for Time';
        timeValidation.showPromptBox = true;

        expect(timeValidation.allowType, ExcelDataValidationType.time);

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelTimeValidationMulRangeAllowType.xlsx');
        workbook.dispose();
      });
    });
    group('Single and Multiple Range in Single Sheet', () {
      test('allowType', () {
        //creates one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(1);
        final Worksheet sheet = workbook.worksheets[0];

        //Accessing the cell range A1:A4 by cellName and applying the textLength properties
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1:A4').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be between 1 to 5 characters';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.promptBoxTitle = 'texLength';

        //Accessing the cell Range A5 by cellName and applying the textLength properties
        final DataValidation textLengthValidation1 =
            sheet.getRangeByName('A5').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation1.errorBoxText =
            'Text length should be between 1 to 5 characters';
        textLengthValidation1.firstFormula = '6';
        textLengthValidation1.secondFormula = '10';
        textLengthValidation1.promptBoxTitle = 'texLength';
        textLengthValidation1.promptBoxText = 'Data validation for text length';

        //Accessing the cell Range B1:B4 by cell Name and applying the integer properties
        DataValidation integerValidation =
            sheet.getRangeByName('B1:B4').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        integerValidation.firstFormula = '1';
        integerValidation.secondFormula = '5';
        integerValidation.errorBoxText =
            'Integer value should be given between 1 to 5';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxText = 'Data validation for integer';
        integerValidation.showPromptBox = true;
        integerValidation.promptBoxTitle = 'integer';

        //Accessing the cell Range B5 by cell Name and applying the integer properties
        integerValidation = sheet.getRangeByName('B5').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        integerValidation.firstFormula = '1';
        integerValidation.secondFormula = '5';
        integerValidation.errorBoxText =
            'Integer value should be given between 1 to 5';
        integerValidation.promptBoxTitle = 'integer';
        integerValidation.promptBoxText = 'Data validation for integer';

        //Accessing the cell Range C1:C4 by cell Name and applying the decimal properties
        DataValidation decimalValidation =
            sheet.getRangeByName('C1:C4').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        decimalValidation.firstFormula = '1.5';
        decimalValidation.secondFormula = '5.5';
        decimalValidation.errorBoxText =
            'decimal value should be given and it should be between 1.5 and 2.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxText = 'Data validation for decimal';
        decimalValidation.showPromptBox = true;
        decimalValidation.promptBoxTitle = 'decimal';

        //Accessing the cell Range C5 by cell Name and applying the decimal properties
        decimalValidation = sheet.getRangeByName('C5').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        decimalValidation.firstFormula = '1.5';
        decimalValidation.secondFormula = '5.5';
        decimalValidation.errorBoxText =
            'decimal value should be given and it should be between 1.5 and 2.5';
        decimalValidation.promptBoxTitle = 'decimal';
        decimalValidation.promptBoxText = 'Data validation for decimal';

        //Accessing the cell Range D1:D4 in worksheet and applying the Custom property
        DataValidation customValidation =
            sheet.getRangeByName('D1:D4').dataValidation;
        customValidation.allowType = ExcelDataValidationType.formula;
        customValidation.firstFormula = 'ISNUMBER(D1)';
        customValidation.promptBoxTitle = 'custom';
        customValidation.errorBoxText =
            'Value should be given as per custom provided';
        customValidation.promptBoxText = 'DataValidation for custom';

        //Accessing the cell Range D5 in worksheet and applying the Custom property
        customValidation = sheet.getRangeByName('D5').dataValidation;
        customValidation.allowType = ExcelDataValidationType.formula;
        customValidation.firstFormula = 'ISNUMBER(D5)';
        customValidation.promptBoxTitle = 'custom';
        customValidation.errorBoxText =
            'Value should be given as per custom provided';
        customValidation.promptBoxText = 'DataValidation for custom';

        //Accessing the cell Range E1:E4 and applying the date properties
        DataValidation dateValidation =
            sheet.getRangeByName('E1:E4').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);
        dateValidation.secondDateTime = DateTime(1997, 07, 25);
        dateValidation.errorBoxText =
            'date value should be given and it should be between 22ndJuly1997 and 25thJuly1997';
        dateValidation.errorBoxTitle = 'ERROR';
        dateValidation.promptBoxText = 'Data validation for date';
        dateValidation.showPromptBox = true;
        dateValidation.promptBoxTitle = 'date';

        //Accessing the cell Range E5 and applying the date properties
        dateValidation = sheet.getRangeByName('E5').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);
        dateValidation.secondDateTime = DateTime(1997, 07, 25);
        dateValidation.errorBoxText =
            'date value should be given and it should be between 22ndJuly1997 and 25thJuly1997';
        dateValidation.promptBoxTitle = 'date';
        dateValidation.promptBoxText = 'Data validation for date';

        //Accessing the cell Range F1:F4 and applying the Time property
        DataValidation timeValidation =
            sheet.getRangeByName('F1:F4').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.firstFormula = '1:00';
        timeValidation.secondFormula = '2:00';
        timeValidation.errorBoxText = 'Valid Time value should be given';
        timeValidation.errorBoxTitle = 'ERROR';
        timeValidation.promptBoxText = 'Data validation for Time';
        timeValidation.showPromptBox = true;
        timeValidation.promptBoxTitle = 'Time';

        //Accessing the cell Range F5 and applying the Time property
        timeValidation = sheet.getRangeByName('F5').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.firstFormula = '1:00';
        timeValidation.secondFormula = '2:00';
        timeValidation.errorBoxText = 'Valid Time value should be given';
        timeValidation.errorBoxTitle = 'ERROR';
        timeValidation.promptBoxText = 'Data validation for Time';
        timeValidation.showPromptBox = true;
        timeValidation.promptBoxTitle = 'Time';

        //Accessing the cell Range G1:G4 and applying the list properties
        DataValidation listValidation =
            sheet.getRangeByName('G1:G4').dataValidation;
        listValidation.allowType = ExcelDataValidationType.user;
        listValidation.listOfValues = <String>['List1', 'List2', 'List3'];
        listValidation.errorBoxText = 'The value given in list should be given';
        listValidation.errorBoxTitle = 'ERROR';
        listValidation.promptBoxText = 'Data validation for list';
        listValidation.showPromptBox = true;
        listValidation.promptBoxTitle = 'list';
        listValidation.errorBoxText = 'list value should be given';

        //Accessing the cell Range G5 and applying the list properties
        listValidation = sheet.getRangeByName('G5').dataValidation;
        listValidation.allowType = ExcelDataValidationType.user;
        listValidation.listOfValues = <String>['List1', 'List2', 'List3'];
        listValidation.errorBoxText = 'The value given in list should be given';
        listValidation.errorBoxTitle = 'ERROR';
        listValidation.promptBoxText = 'Data validation for list';
        listValidation.showPromptBox = true;
        listValidation.promptBoxTitle = 'formula';
        listValidation.errorBoxText = 'list value should be given';

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDataValidationpropertiesSingleSheet.xlsx');
        workbook.dispose();
      });
    });
    group('Single and Multiple Range in multiple Sheet', () {
      test('allowType', () {
        //creates one worksheet and accessing the first sheet
        final Workbook workbook = Workbook(2);
        final Worksheet sheet = workbook.worksheets[0];
        final Worksheet sheettwo = workbook.worksheets[1];

        //Accessing the cell range A1:A4 by cellName and applying the textLength properties
        final DataValidation textLengthValidation =
            sheet.getRangeByName('A1:A4').dataValidation;
        textLengthValidation.allowType = ExcelDataValidationType.textLength;
        textLengthValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation.firstFormula = '1';
        textLengthValidation.secondFormula = '5';
        textLengthValidation.errorBoxText =
            'Text length should be between 1 to 5 characters';
        textLengthValidation.errorBoxTitle = 'ERROR';
        textLengthValidation.promptBoxText = 'Data validation for text length';
        textLengthValidation.showPromptBox = true;
        textLengthValidation.promptBoxTitle = 'texLength';

        //Accessing the cell Range A5 by cellName and applying the textLength properties
        final DataValidation textLengthValidation1 =
            sheettwo.getRangeByName('A5').dataValidation;
        textLengthValidation1.allowType = ExcelDataValidationType.textLength;
        textLengthValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        textLengthValidation1.errorBoxText =
            'Text length should be between 1 to 5 characters';
        textLengthValidation1.firstFormula = '6';
        textLengthValidation1.secondFormula = '10';
        textLengthValidation1.promptBoxTitle = 'texLength';
        textLengthValidation1.promptBoxText = 'Data validation for text length';

        //Accessing the cell Range B1:B4 by cell Name and applying the integer properties
        final DataValidation integerValidation =
            sheet.getRangeByName('B1:B4').dataValidation;
        integerValidation.allowType = ExcelDataValidationType.integer;
        integerValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        integerValidation.firstFormula = '1';
        integerValidation.secondFormula = '5';
        integerValidation.errorBoxText =
            'Integer value should be given between 1 to 5';
        integerValidation.errorBoxTitle = 'ERROR';
        integerValidation.promptBoxText = 'Data validation for integer';
        integerValidation.showPromptBox = true;
        integerValidation.promptBoxTitle = 'integer';

        //Accessing the cell Range B5 by cell Name and applying the integer properties
        final DataValidation integerValidation1 =
            sheettwo.getRangeByName('B5').dataValidation;
        integerValidation1.allowType = ExcelDataValidationType.integer;
        integerValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        integerValidation1.firstFormula = '1';
        integerValidation1.secondFormula = '5';
        integerValidation1.errorBoxText =
            'Integer value should be given between 1 to 5';
        integerValidation1.promptBoxTitle = 'integer';
        integerValidation1.promptBoxText = 'Data validation for integer';

        //Accessing the cell Range C1:C4 by cell Name and applying the decimal properties
        final DataValidation decimalValidation =
            sheet.getRangeByName('C1:C4').dataValidation;
        decimalValidation.allowType = ExcelDataValidationType.decimal;
        decimalValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        decimalValidation.firstFormula = '1.5';
        decimalValidation.secondFormula = '5.5';
        decimalValidation.errorBoxText =
            'decimal value should be given and it should be between 1.5 and 2.5';
        decimalValidation.errorBoxTitle = 'ERROR';
        decimalValidation.promptBoxText = 'Data validation for decimal';
        decimalValidation.showPromptBox = true;
        decimalValidation.promptBoxTitle = 'decimal';

        //Accessing the cell Range C5 by cell Name and applying the decimal properties
        final DataValidation decimalValidation1 =
            sheettwo.getRangeByName('C5').dataValidation;
        decimalValidation1.allowType = ExcelDataValidationType.decimal;
        decimalValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        decimalValidation1.firstFormula = '1.5';
        decimalValidation1.secondFormula = '5.5';
        decimalValidation1.errorBoxText =
            'decimal value should be given and it should be between 1.5 and 2.5';
        decimalValidation1.promptBoxTitle = 'decimal';
        decimalValidation1.promptBoxText = 'Data validation for decimal';

        //Accessing the cell Range D1:D4 in worksheet and applying the Custom property
        final DataValidation customValidation =
            sheet.getRangeByName('D1:D4').dataValidation;
        customValidation.allowType = ExcelDataValidationType.formula;
        customValidation.firstFormula = 'ISNUMBER(D1)';
        customValidation.promptBoxTitle = 'custom';
        customValidation.errorBoxText =
            'Value should be given as per custom provided';
        customValidation.promptBoxText = 'DataValidation for custom';

        //Accessing the cell Range D5 in worksheet and applying the Custom property
        final DataValidation customValidation1 =
            sheettwo.getRangeByName('D5').dataValidation;
        customValidation1.allowType = ExcelDataValidationType.formula;
        customValidation1.firstFormula = 'ISNUMBER(D5)';
        customValidation1.promptBoxTitle = 'custom';
        customValidation1.errorBoxText =
            'Value should be given as per custom provided';
        customValidation1.promptBoxText = 'DataValidation for custom';

        //Accessing the cell Range E1:E4 and applying the date properties
        final DataValidation dateValidation =
            sheet.getRangeByName('E1:E4').dataValidation;
        dateValidation.allowType = ExcelDataValidationType.date;
        dateValidation.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        dateValidation.firstDateTime = DateTime(1997, 07, 22);
        dateValidation.secondDateTime = DateTime(1997, 07, 25);
        dateValidation.errorBoxText =
            'date value should be given and it should be between 22ndJuly1997 and 25thJuly1997';
        dateValidation.errorBoxTitle = 'ERROR';
        dateValidation.promptBoxText = 'Data validation for date';
        dateValidation.showPromptBox = true;
        dateValidation.promptBoxTitle = 'date';

        //Accessing the cell Range E5 and applying the date properties
        final DataValidation dateValidation1 =
            sheettwo.getRangeByName('E5').dataValidation;
        dateValidation1.allowType = ExcelDataValidationType.date;
        dateValidation1.comparisonOperator =
            ExcelDataValidationComparisonOperator.between;
        dateValidation1.firstDateTime = DateTime(1997, 07, 22);
        dateValidation1.secondDateTime = DateTime(1997, 07, 25);
        dateValidation1.errorBoxText =
            'date value should be given and it should be between 22ndJuly1997 and 25thJuly1997';
        dateValidation1.promptBoxTitle = 'date';
        dateValidation1.promptBoxText = 'Data validation for date';

        //Accessing the cell Range F1:F4 and applying the Time property
        final DataValidation timeValidation =
            sheet.getRangeByName('F1:F4').dataValidation;
        timeValidation.allowType = ExcelDataValidationType.time;
        timeValidation.firstFormula = '1:00';
        timeValidation.secondFormula = '2:00';
        timeValidation.errorBoxText = 'Valid Time value should be given';
        timeValidation.errorBoxTitle = 'ERROR';
        timeValidation.promptBoxText = 'Data validation for Time';
        timeValidation.showPromptBox = true;
        timeValidation.promptBoxTitle = 'Time';

        //Accessing the cell Range F5 and applying the Time property
        final DataValidation timeValidation1 =
            sheettwo.getRangeByName('F5').dataValidation;
        timeValidation1.allowType = ExcelDataValidationType.time;
        timeValidation1.firstFormula = '1:00';
        timeValidation1.secondFormula = '2:00';
        timeValidation1.errorBoxText = 'Valid Time value should be given';
        timeValidation1.errorBoxTitle = 'ERROR';
        timeValidation1.promptBoxText = 'Data validation for Time';
        timeValidation1.showPromptBox = true;
        timeValidation1.promptBoxTitle = 'Time';

        //Accessing the cell Range G1:G4 and applying the list properties
        final DataValidation listValidation =
            sheet.getRangeByName('G1:G4').dataValidation;
        listValidation.allowType = ExcelDataValidationType.user;
        listValidation.listOfValues = <String>['List1', 'List2', 'List3'];
        listValidation.errorBoxText = 'The value given in list should be given';
        listValidation.errorBoxTitle = 'ERROR';
        listValidation.promptBoxText = 'Data validation for list';
        listValidation.showPromptBox = true;
        listValidation.promptBoxTitle = 'list';
        listValidation.errorBoxText = 'list value should be given';

        //Accessing the cell Range G5 and applying the list properties
        final DataValidation listValidation1 =
            sheettwo.getRangeByName('G5').dataValidation;
        listValidation1.allowType = ExcelDataValidationType.user;
        listValidation1.listOfValues = <String>['List1', 'List2', 'List3'];
        listValidation1.errorBoxText =
            'The value given in list should be given';
        listValidation1.errorBoxTitle = 'ERROR';
        listValidation1.promptBoxText = 'Data validation for list';
        listValidation1.showPromptBox = true;
        listValidation1.promptBoxTitle = 'list';
        listValidation1.errorBoxText = 'list value should be given';

        //Accessing the cell Range H1:H4 in excel-sheet and applying the dataRange property
        DataValidation dataRangeValidation =
            sheet.getRangeByName('H1:H4').dataValidation;
        sheet.getRangeByName('A6').text = 'ListItem1';
        sheet.getRangeByName('A7').text = 'ListItem2';
        sheet.getRangeByName('A8').text = 'ListItem3';
        sheet.getRangeByName('A9').text = 'ListItem4';
        sheet.getRangeByName('A10').text = 'ListItem5';

        dataRangeValidation.dataRange = sheet.getRangeByName('A6:A10');
        dataRangeValidation.errorBoxText =
            'Valid value given in list should be given';
        dataRangeValidation.errorBoxTitle = 'ERROR';
        dataRangeValidation.promptBoxText = 'List';
        dataRangeValidation.showPromptBox = true;

        //Accessing the cell Range H5 in excel-sheet and applying the dataRange property
        dataRangeValidation = sheet.getRangeByName('H5').dataValidation;
        sheet.getRangeByName('A6').text = 'ListItem1';
        sheet.getRangeByName('A7').text = 'ListItem2';

        dataRangeValidation.dataRange = sheet.getRangeByName('A6');
        dataRangeValidation.errorBoxText =
            'Valid value given in list should be given';
        dataRangeValidation.errorBoxTitle = 'ERROR';
        dataRangeValidation.promptBoxText = 'List';
        dataRangeValidation.showPromptBox = true;

        //Accessing the cell Range I1:I4 and applying the list properties
        DataValidation listValidationtwo =
            sheet.getRangeByName('I1:I4').dataValidation;
        listValidationtwo.listOfValues = <String>['List1', 'List2', 'List3'];
        listValidationtwo.errorBoxText =
            'The value given in list should be given';
        listValidationtwo.errorBoxTitle = 'ERROR';
        listValidationtwo.promptBoxText = 'Data validation for list';
        listValidationtwo.showPromptBox = true;
        listValidationtwo.isEmptyCellAllowed = false;
        listValidationtwo.isSuppressDropDownArrow = false;

        //Accessing the cell Range I5 and applying the list properties
        listValidationtwo = sheet.getRangeByName('I5').dataValidation;
        listValidationtwo.listOfValues = <String>['List1', 'List2', 'List3'];
        listValidationtwo.errorBoxText =
            'The value given in list should be given';
        listValidationtwo.errorBoxTitle = 'ERROR';
        listValidationtwo.promptBoxText = 'Data validation for list';
        listValidationtwo.showPromptBox = true;

        //Save and dispose Workbook
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelDataValidationpropertiesmultiplesheet.xlsx');
        workbook.dispose();
      });
    });
  });
}
