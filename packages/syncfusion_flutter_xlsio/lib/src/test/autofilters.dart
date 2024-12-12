// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

///tets Method For Autofilter
void xlsioAutoFilters() {
  group('AutoFilter', () {
    group('CombinationFilter', () {
      test('Text-Filter', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        ///Loading data
        sheet.getRangeByName('A1').setText('Angela Davis');
        sheet.getRangeByName('A2').setText('aNgeLa DaViS.');
        sheet.getRangeByName('A3').setText('Enoch Powell');
        sheet.getRangeByName('A4').setText('Al-Biruni');
        sheet.getRangeByName('A5').setText('ANgeLa DAViS');
        sheet.getRangeByName('A6').setText('Will Roscoe');
        sheet.getRangeByName('A7').setText('al-biruNi');
        sheet.getRangeByName('A8').setText('Christopher Hogwood');
        sheet.getRangeByName('A9').setText('Al-BirUni');
        sheet.getRangeByName('A10').setText('KarlMarx');

        sheet.getRangeByName('B1').setText('India');
        sheet.getRangeByName('B2').setText('America');
        sheet.getRangeByName('B3').setText('Australia');
        sheet.getRangeByName('B4').setText('Russia');
        sheet.getRangeByName('B5').setText('Canada');
        sheet.getRangeByName('B6').setText('Japan');
        sheet.getRangeByName('B7').setText('China');
        sheet.getRangeByName('B8').setText('Srilanka');
        sheet.getRangeByName('B9').setText('Africa');
        sheet.getRangeByName('B10').setText('France');

        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:B10');
        final AutoFilter autofilter = sheet.autoFilters[0];
        autofilter.addTextFilter(<String>{'Angela Davis', 'Al-BirUni'});

        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'CombinationFilter_1.xlsx');
        workbook.dispose();
      });
    });

    group('CustomFilter', () {
      group('CustomFilter with Number', () {
        group('Initialize Filter with single condition', () {
          test('Filter Equal values', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data
            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(15);
            sheet.getRangeByName('A3').setNumber(15.4);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(10);
            sheet.getRangeByName('A6').setNumber(20.00087788767667657577557007);
            sheet.getRangeByName('A7').setNumber(233);
            sheet.getRangeByName('A8').setNumber(10);
            sheet.getRangeByName('A9').setNumber(10.01);
            sheet.getRangeByName('A10').setNumber(9.99);

            sheet.getRangeByName('B1').setText('Angela Davis');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('Will Roscoe');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Christopher Hogwood');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('KarlMarx');

            //Intialize Filter Range
            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[0];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator = ExcelFilterCondition.equal;
            firstCondition.numberValue = 10;
            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilterEqualValue_1.xlsx');
            workbook.dispose();
          });

          test('Filter greater values', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data
            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(15);
            sheet.getRangeByName('A3').setNumber(15.4);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(10);
            sheet.getRangeByName('A6').setNumber(20.00087788767667657577557007);
            sheet.getRangeByName('A7').setNumber(233);
            sheet.getRangeByName('A8').setNumber(10);
            sheet.getRangeByName('A9').setNumber(10.01);
            sheet.getRangeByName('A10').setNumber(9.99);

            sheet.getRangeByName('B1').setText('Angela Davis');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('Will Roscoe');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Christopher Hogwood');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('KarlMarx');

            //Intialize Filter Range

            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[0];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator = ExcelFilterCondition.greater;
            firstCondition.numberValue = 15;

            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_2.xlsx');
            workbook.dispose();
          });

          test('Filter greaterOrEqual Value ', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data
            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(15);
            sheet.getRangeByName('A3').setNumber(15.4);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(10);
            sheet.getRangeByName('A6').setNumber(20.00087788767667657577557007);
            sheet.getRangeByName('A7').setNumber(233);
            sheet.getRangeByName('A8').setNumber(10);
            sheet.getRangeByName('A9').setNumber(10.01);
            sheet.getRangeByName('A10').setNumber(9.99);

            sheet.getRangeByName('B1').setText('Angela Davis');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('Will Roscoe');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Christopher Hogwood');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('KarlMarx');

            //Intialize Filter Range

            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[0];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator =
                ExcelFilterCondition.greaterOrEqual;
            firstCondition.numberValue = 15;

            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_3.xlsx');
            workbook.dispose();
          });

          test('Filter less Value', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data

            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(10.000330378);
            sheet.getRangeByName('A3').setNumber(33.456455555555);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(20);
            sheet.getRangeByName('A6').setNumber(20.00087788767667657577557007);
            sheet.getRangeByName('A7').setNumber(233);
            sheet.getRangeByName('A8').setNumber(4444);
            sheet.getRangeByName('A9').setNumber(34567);
            sheet.getRangeByName('A10').setNumber(3656555566565656);

            sheet.getRangeByName('B1').setText('Angela Davis');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('Will Roscoe');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Christopher Hogwood');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('KarlMarx');
            //Intialize Filter Range
            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[0];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator = ExcelFilterCondition.less;
            firstCondition.numberValue = 20;

            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_4.xlsx');
            workbook.dispose();
          });

          test('Filter lessOrEqual Value', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data

            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(10.000330378);
            sheet.getRangeByName('A3').setNumber(33.456455555555);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(20);
            sheet.getRangeByName('A6').setNumber(20.00087788767667657577557007);
            sheet.getRangeByName('A7').setNumber(21);
            sheet.getRangeByName('A8').setNumber(4444);
            sheet.getRangeByName('A9').setNumber(34567);
            sheet.getRangeByName('A10').setNumber(3656555566565656);

            sheet.getRangeByName('B1').setText('Angela Davis');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('Will Roscoe');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Christopher Hogwood');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('KarlMarx');

            //Intialize Filter Range

            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[0];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator = ExcelFilterCondition.lessOrEqual;
            firstCondition.numberValue = 21;

            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_5.xlsx');
            workbook.dispose();
          });
          test('notEqual', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data

            sheet.getRangeByName('A1').setNumber(20);
            sheet.getRangeByName('A2').setNumber(10.000330378);
            sheet.getRangeByName('A3').setNumber(33.456455555555);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(20);
            sheet.getRangeByName('A6').setNumber(20);
            sheet.getRangeByName('A7').setNumber(21);
            sheet.getRangeByName('A8').setNumber(4444);
            sheet.getRangeByName('A9').setNumber(34567);
            sheet.getRangeByName('A10').setNumber(3656555566565656);

            sheet.getRangeByName('B1').setText('Angela Davis');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('Will Roscoe');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Christopher Hogwood');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('KarlMarx');

            //Intialize Filter Range

            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[0];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator = ExcelFilterCondition.notEqual;
            firstCondition.numberValue = 20;

            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_6.xlsx');
            workbook.dispose();
          });
        });

        group('Initialize Filter With two Conditions with AND Operator', () {
          group('Equal operator with other operators', () {
            test('Equal_AND_Graeter values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.00);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.less;
              firstCondition.numberValue = 10;

              filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.greater;
              secondCondition.numberValue = 5;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_6.xlsx');
              workbook.dispose();
            });

            test('Equal_AND_GraeterOrEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.equal;
              firstCondition.numberValue = 10;

              //filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.greaterOrEqual;
              secondCondition.numberValue = 10;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_7.xlsx');
              workbook.dispose();
            });

            test('Equal_AND_less values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet
                  .getRangeByName('A6')
                  .setNumber(20.00087788767667657577557007);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.equal;
              firstCondition.numberValue = 25;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.less;
              secondCondition.numberValue = 35;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_8.xlsx');
              workbook.dispose();
            });

            test('Equal_AND_LessOrEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.0008);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.equal;
              firstCondition.numberValue = 35;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_9.xlsx');
              workbook.dispose();
            });

            test('Equal_AND_NotEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.00);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.equal;
              firstCondition.numberValue = 25;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 10;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_9.xlsx');
              workbook.dispose();
            });
          });
          group('Greater Operator with other operators', () {
            test('Greater_AND_GreaterOrEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.greater;
              firstCondition.numberValue = 10;

              filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.greaterOrEqual;
              secondCondition.numberValue = 10;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_10.xlsx');
              workbook.dispose();
            });

            test('Greater_AND_Less values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.greater;
              firstCondition.numberValue = 10;

              filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.less;
              secondCondition.numberValue = 35;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_12.xlsx');
              workbook.dispose();
            });

            test('Greater_AND_lessOREqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.greater;
              firstCondition.numberValue = 10;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              secondCondition.numberValue = 35;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_13.xlsx');
              workbook.dispose();
            });

            test('Greater_AND_notEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.greater;
              firstCondition.numberValue = 20;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_14.xlsx');
              workbook.dispose();
            });
          });
          group('GreaterOrEqual Operator With Other Operator', () {
            test('greaterOrEqual_AND_less values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.greaterOrEqual;
              firstCondition.numberValue = 10;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.less;
              secondCondition.numberValue = 35;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_15.xlsx');
              workbook.dispose();
            });

            test('greaterOrEqual_AND_lessOrEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.greaterOrEqual;
              firstCondition.numberValue = 10;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              secondCondition.numberValue = 35;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_16.xlsx');
              workbook.dispose();
            });

            test('greaterOrEqual_AND_less values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.greaterOrEqual;
              firstCondition.numberValue = 10;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_17.xlsx');
              workbook.dispose();
            });
          });

          group('less Operator with other Operators', () {
            test('less_AND_lessOrEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.less;
              firstCondition.numberValue = 10;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_18.xlsx');
              workbook.dispose();
            });
            test('less_AND_notEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.less;
              firstCondition.numberValue = 35;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_19.xlsx');
              workbook.dispose();
            });
          });
          group('lessOrEqual Operator with other Operator', () {
            test('less_AND_notEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              firstCondition.numberValue = 35;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_20.xlsx');
              workbook.dispose();
            });
          });
        });

        group('Initialize Filter With two Conditions with OR Operator', () {
          group('Equal operator with other operators', () {
            test('Equal_OR_Graeter values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.equal;
              firstCondition.numberValue = 10;

              //filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.greater;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_21.xlsx');
              workbook.dispose();
            });

            test('Equal_OR_GraeterOrEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.equal;
              firstCondition.numberValue = 10;

              //filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.greaterOrEqual;
              secondCondition.numberValue = 35;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_21.xlsx');
              workbook.dispose();
            });

            test('Equal_OR_less values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.equal;
              firstCondition.numberValue = 25;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.less;
              secondCondition.numberValue = 35;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_2.xlsx');
              workbook.dispose();
            });

            test('Equal_OR_LessOrEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.equal;
              firstCondition.numberValue = 35;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_23.xlsx');
              workbook.dispose();
            });

            test('Equal_OR_NotEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.equal;
              firstCondition.numberValue = 25;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_2.xlsx');
              workbook.dispose();
            });
          });
          group('Greater Operator with other operators', () {
            test('Greater_OR_GreaterOrEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.greater;
              firstCondition.numberValue = 30;

              //filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.greaterOrEqual;
              secondCondition.numberValue = 20;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_25.xlsx');
              workbook.dispose();
            });

            test('Greater_OR_Less values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.greater;
              firstCondition.numberValue = 35;

              //filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.less;
              secondCondition.numberValue = 10;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_25.xlsx');
              workbook.dispose();
            });

            test('Greater_OR_lessOREqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.greater;
              firstCondition.numberValue = 10;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              secondCondition.numberValue = 35;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_25.xlsx');
              workbook.dispose();
            });

            test('Greater_OR_notEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.greater;
              firstCondition.numberValue = 5;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_26.xlsx');
              workbook.dispose();
            });
          });
          group('GreaterOrEqual Operator With Other Operator', () {
            test('greaterOrEqual_OR_less values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.greaterOrEqual;
              firstCondition.numberValue = 10;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.less;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_27.xlsx');
              workbook.dispose();
            });

            test('greaterOrEqual_OR_lessOrEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.greaterOrEqual;
              firstCondition.numberValue = 10;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_28.xlsx');
              workbook.dispose();
            });

            test('greaterOrEqual_OR_less values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.greaterOrEqual;
              firstCondition.numberValue = 10;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_30.xlsx');
              workbook.dispose();
            });
          });
          group('less Operator with other Operators', () {
            test('less_OR_lessOrEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet
                  .getRangeByName('A6')
                  .setNumber(20.00087788767667657577557007);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.less;
              firstCondition.numberValue = 10;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_30.xlsx');
              workbook.dispose();
            });

            test('less_OR_notEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.less;
              firstCondition.numberValue = 35;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_31.xlsx');
              workbook.dispose();
            });
          });
          group('lessOrEqual Operator with other Operator', () {
            test('less_OR_notEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              firstCondition.numberValue = 35;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_32.xlsx');
              workbook.dispose();
            });
          });
        });
      });

      ///CustomFilter For String Data Type
      group('CustomFilter with String', () {
        group('Initialize Filter with single condition', () {
          test('Filter Equal values', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data
            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(15);
            sheet.getRangeByName('A3').setNumber(15.4);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(10);
            sheet.getRangeByName('A6').setNumber(20.00087788767667657577557007);
            sheet.getRangeByName('A7').setNumber(233);
            sheet.getRangeByName('A8').setNumber(10);
            sheet.getRangeByName('A9').setNumber(10.01);
            sheet.getRangeByName('A10').setNumber(9.99);

            sheet.getRangeByName('B1').setText('Angela Davis');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('Angela Davis');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Angela Davis');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('KarlMarx');

            //Intialize Filter Range
            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[1];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator = ExcelFilterCondition.equal;
            firstCondition.textValue = 'Angela Davis';
            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_33.xlsx');
            workbook.dispose();
          });

          test('Contains', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data
            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(15);
            sheet.getRangeByName('A3').setNumber(15.4);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(10);
            sheet.getRangeByName('A6').setNumber(20);
            sheet.getRangeByName('A7').setNumber(233);
            sheet.getRangeByName('A8').setNumber(10);
            sheet.getRangeByName('A9').setNumber(10.01);
            sheet.getRangeByName('A10').setNumber(9.99);

            sheet.getRangeByName('B1').setText('Angela Davis');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('Will Roscoe');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Christopher Hogwood');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('KarlMarx');

            //Intialize Filter Range

            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[1];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator = ExcelFilterCondition.contains;
            firstCondition.textValue = 'Angela';

            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_33.xlsx');
            workbook.dispose();
          });

          test('beginsWith', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data
            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(15);
            sheet.getRangeByName('A3').setNumber(15.4);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(10);
            sheet.getRangeByName('A6').setNumber(20);
            sheet.getRangeByName('A7').setNumber(233);
            sheet.getRangeByName('A8').setNumber(10);
            sheet.getRangeByName('A9').setNumber(10.01);
            sheet.getRangeByName('A10').setNumber(9.99);

            sheet.getRangeByName('B1').setText('Angela Davis');
            sheet.getRangeByName('B2').setText('joseph campbell');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('Will Roscoe');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Joseph Campbell');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('KarlMarx');

            //Intialize Filter Range

            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[0];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator = ExcelFilterCondition.beginsWith;
            firstCondition.textValue = 'Joseph';

            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_34.xlsx');
            workbook.dispose();
          });

          test('doesNotBeginWith', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data

            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(10.000330378);
            sheet.getRangeByName('A3').setNumber(33.456455555555);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(20);
            sheet.getRangeByName('A6').setNumber(20);
            sheet.getRangeByName('A7').setNumber(233);
            sheet.getRangeByName('A8').setNumber(4444);
            sheet.getRangeByName('A9').setNumber(34567);
            sheet.getRangeByName('A10').setNumber(3656555566565656);

            sheet.getRangeByName('B1').setText('Angela Davis');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('Will Roscoe');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Joseph Campbell');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('KarlMarx');
            //Intialize Filter Range
            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[0];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator =
                ExcelFilterCondition.doesNotBeginWith;
            firstCondition.textValue = 'Joseph';

            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_35.xlsx');
            workbook.dispose();
          });

          test('endsWith', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data

            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(10.000330378);
            sheet.getRangeByName('A3').setNumber(33.456455555555);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(20);
            sheet.getRangeByName('A6').setNumber(20.00087788767667657577557007);
            sheet.getRangeByName('A7').setNumber(21);
            sheet.getRangeByName('A8').setNumber(4444);
            sheet.getRangeByName('A9').setNumber(34567);
            sheet.getRangeByName('A10').setNumber(3656555566565656);

            sheet.getRangeByName('B1').setText('KarlMarx');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('KarlMarx');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Christopher Hogwood');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('Karl Marx');

            //Intialize Filter Range

            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[0];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator = ExcelFilterCondition.endsWith;
            firstCondition.textValue = 'Marx';

            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_36.xlsx');
            workbook.dispose();
          });

          test('doesNotEndWith', () {
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];

            ///Loading data

            sheet.getRangeByName('A1').setNumber(10);
            sheet.getRangeByName('A2').setNumber(10.000330378);
            sheet.getRangeByName('A3').setNumber(33.456455555555);
            sheet.getRangeByName('A4').setNumber(20.4567678);
            sheet.getRangeByName('A5').setNumber(20);
            sheet.getRangeByName('A6').setNumber(20);
            sheet.getRangeByName('A7').setNumber(21);
            sheet.getRangeByName('A8').setNumber(4444);
            sheet.getRangeByName('A9').setNumber(34567);
            sheet.getRangeByName('A10').setNumber(3656555566565656);

            sheet.getRangeByName('B1').setText('KarlMarx');
            sheet.getRangeByName('B2').setText('Sigmund Freud.');
            sheet.getRangeByName('B3').setText('Enoch Powell');
            sheet.getRangeByName('B4').setText('Al-Biruni');
            sheet.getRangeByName('B5').setText('Joseph Campbell');
            sheet.getRangeByName('B6').setText('KarlMarx');
            sheet.getRangeByName('B7').setText('Barry Bishop');
            sheet.getRangeByName('B8').setText('Christopher Hogwood');
            sheet.getRangeByName('B9').setText('Cornel West');
            sheet.getRangeByName('B10').setText('Karl Marx');

            //Intialize Filter Range

            sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
            final AutoFilter filter = sheet.autoFilters[0];
            final AutoFilterCondition firstCondition = filter.firstCondition;
            firstCondition.conditionOperator =
                ExcelFilterCondition.doesNotEndWith;
            firstCondition.textValue = 'Marx';

            //filter.logicalOperator = ExcelLogicalOperator.and;

            final List<int> bytes = workbook.saveAsStream();
            saveAsExcel(bytes, 'CustomFilter_37.xlsx');
            workbook.dispose();
          });
        });

        group('Initialize Filter With two Conditions with AND Operator', () {
          group('BeginsWith operator with other operators', () {
            test('BeginsWith_AND_Contains values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.0);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.beginsWith;
              firstCondition.textValue = 'karl';

              filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.contains;
              secondCondition.textValue = 'marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_38.xlsx');
              workbook.dispose();
            });

            test('BeginsWith_AND_Contains values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.0);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.beginsWith;
              firstCondition.textValue = 'karl';

              filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              secondCondition.textValue = 'marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_39.xlsx');
              workbook.dispose();
            });

            test('BeginsWith_AND_Contains values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.0);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.beginsWith;
              firstCondition.textValue = 'karl';

              filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotContain;
              secondCondition.textValue = 'marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_40.xlsx');
              workbook.dispose();
            });

            test('BeginsWith_AND_Contains values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.0);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.beginsWith;
              firstCondition.textValue = 'karl';

              filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.endsWith;
              secondCondition.textValue = 'marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_41.xlsx');
              workbook.dispose();
            });

            test('beginsWith_AND_Equal values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.beginsWith;
              firstCondition.textValue = 'karl';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.equal;
              secondCondition.textValue = 'karlMarx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });
          });

          group('Contains Operator with other operators', () {
            test('Contains_AND_doesNotBeginWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.contains;
              firstCondition.textValue = 'karl';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_41.xlsx');
              workbook.dispose();
            });

            test('Contains_AND_doesNotBeginWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.contains;
              firstCondition.textValue = 'karl';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_42.xlsx');
              workbook.dispose();
            });

            test('Contains_AND_doesNotContain values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.contains;
              firstCondition.textValue = 'karl';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotContain;
              secondCondition.textValue = 'Joseph';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_43.xlsx');
              workbook.dispose();
            });

            test('Contains_AND_doesNotEndWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.contains;
              firstCondition.textValue = 'karl';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotEndWith;
              secondCondition.textValue = 'Bishop';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_44.xlsx');
              workbook.dispose();
            });

            test('Contains_AND_EndsWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              firstCondition.textValue = 'karl';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.endsWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter_46.xlsx');
              workbook.dispose();
            });
          });
          group('doesNotBeginWith Operator With Other Operator', () {
            test('doesNotBeginWith_AND_doesNotContain values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              firstCondition.textValue = 'Angela';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotContain;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('doesNotBeginWith_AND_doesNotEndWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              firstCondition.textValue = 'Angela';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotEndWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('doesNotBeginWith_AND_doesNotEndWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              firstCondition.textValue = 'Angela';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.endsWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });
          });

          group('doesNotContain Operator with other Operators', () {
            test('doesNotContain_AND_doesNotEndWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotContain;
              firstCondition.textValue = 'Angela';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotEndWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('doesNotContain_AND_doesNotEndWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotContain;
              firstCondition.textValue = 'Angela';

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.endsWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('doesNotContain_AND_notEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              firstCondition.numberValue = 35;

              filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });
          });
        });
        group('Initialize Filter With two Conditions with OR Operator', () {
          group('BeginsWith operator with other operators', () {
            test('BeginsWith_AND_Contains values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.0);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.beginsWith;
              firstCondition.textValue = 'karl';

              ///filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.contains;
              secondCondition.textValue = 'marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('BeginsWith_AND_Contains values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.0);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.beginsWith;
              firstCondition.textValue = 'karl';

              ///filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              secondCondition.textValue = 'marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('BeginsWith_AND_Contains values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.0);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.beginsWith;
              firstCondition.textValue = 'karl';

              //filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotContain;
              secondCondition.textValue = 'marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('BeginsWith_AND_Contains values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20.0);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range

              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.beginsWith;
              firstCondition.textValue = 'karl';

              //filter.logicalOperator = ExcelLogicalOperator.and;

              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.endsWith;
              secondCondition.textValue = 'marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('beginsWith_AND_Equal values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.beginsWith;
              firstCondition.textValue = 'karl';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.equal;
              secondCondition.textValue = 'karlMarx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });
          });

          group('Contains Operator with other operators', () {
            test('Contains_AND_doesNotBeginWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.contains;
              firstCondition.textValue = 'karl';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('Contains_AND_doesNotBeginWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.contains;
              firstCondition.textValue = 'karl';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('Contains_AND_doesNotContain values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.contains;
              firstCondition.textValue = 'karl';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotContain;
              secondCondition.textValue = 'Joseph';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('Contains_AND_doesNotEndWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator = ExcelFilterCondition.contains;
              firstCondition.textValue = 'karl';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotEndWith;
              secondCondition.textValue = 'Bishop';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('Contains_AND_EndsWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              firstCondition.textValue = 'karl';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.endsWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });
          });
          group('doesNotBeginWith Operator With Other Operator', () {
            test('doesNotBeginWith_AND_doesNotContain values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              firstCondition.textValue = 'Angela';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotContain;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('doesNotBeginWith_AND_doesNotEndWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              firstCondition.textValue = 'Angela';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotEndWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('doesNotBeginWith_AND_doesNotEndWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotBeginWith;
              firstCondition.textValue = 'Angela';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.endsWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });
          });
          group('doesNotContain Operator with other Operators', () {
            test('doesNotContain_AND_doesNotEndWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotContain;
              firstCondition.textValue = 'Angela';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator =
                  ExcelFilterCondition.doesNotEndWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });

            test('doesNotContain_AND_doesNotEndWith values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Karl Marx.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Karlmarx');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('KarlMarx');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[1];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.doesNotContain;
              firstCondition.textValue = 'Angela';

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.endsWith;
              secondCondition.textValue = 'Marx';

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });
            test('doesNotContain_AND_notEqual values Filter', () {
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              ///Loading data
              sheet.getRangeByName('A1').setNumber(10);
              sheet.getRangeByName('A2').setNumber(10.000330378);
              sheet.getRangeByName('A3').setNumber(20);
              sheet.getRangeByName('A4').setNumber(25);
              sheet.getRangeByName('A5').setNumber(33.456455555555);
              sheet.getRangeByName('A6').setNumber(20);
              sheet.getRangeByName('A7').setNumber(20);
              sheet.getRangeByName('A8').setNumber(4444);
              sheet.getRangeByName('A9').setNumber(20);
              sheet.getRangeByName('A10').setNumber(25);

              sheet.getRangeByName('B1').setText('Angela Davis');
              sheet.getRangeByName('B2').setText('Sigmund Freud.');
              sheet.getRangeByName('B3').setText('Enoch Powell');
              sheet.getRangeByName('B4').setText('Al-Biruni');
              sheet.getRangeByName('B5').setText('Joseph Campbell');
              sheet.getRangeByName('B6').setText('Will Roscoe');
              sheet.getRangeByName('B7').setText('Barry Bishop');
              sheet.getRangeByName('B8').setText('Christopher Hogwood');
              sheet.getRangeByName('B9').setText('Cornel West');
              sheet.getRangeByName('B10').setText('KarlMarx');

              sheet.getRangeByName('C1').setText('Alfonse');
              sheet.getRangeByName('C2').setNumber(33);
              sheet.getRangeByName('C3').setText('Mohamed');
              sheet.getRangeByName('C4').setText('Yusuf');
              sheet.getRangeByName('C5').setText('Khan');
              sheet.getRangeByName('C6').setNumber(3333465);
              sheet.getRangeByName('C7').setText('bishop');
              sheet.getRangeByName('C8').setNumber(444284354674);
              sheet.getRangeByName('C9').setText('Fernandous');

              //Intialize Filter Range
              sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
              final AutoFilter filter = sheet.autoFilters[0];
              final AutoFilterCondition firstCondition = filter.firstCondition;
              firstCondition.conditionOperator =
                  ExcelFilterCondition.lessOrEqual;
              firstCondition.numberValue = 35;

              //filter.logicalOperator = ExcelLogicalOperator.and;
              final AutoFilterCondition secondCondition =
                  filter.secondCondition;
              secondCondition.conditionOperator = ExcelFilterCondition.notEqual;
              secondCondition.numberValue = 25;

              final List<int> bytes = workbook.saveAsStream();
              saveAsExcel(bytes, 'CustomFilter.xlsx');
              workbook.dispose();
            });
          });
        });
      });
    });
    group('DateTimeFilter', () {
      test('YearFilter', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 4, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');

        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDateFilter(DateTime(2002), DateTimeFilterType.year);
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DatetimeFilter_1.xlsx');
        workbook.dispose();
      });

      test('Filter the Month', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 4, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');

        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDateFilter(DateTime(2006, 9), DateTimeFilterType.month);
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DatetimeFilter.xlsx');
        workbook.dispose();
      });
      test('Day-Filter', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 4, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');

        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDateFilter(DateTime(2007, 7, 19), DateTimeFilterType.day);
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DatetimeFilter.xlsx');
        workbook.dispose();
      });
    });
    group('ColorFilter', () {
      group('ColorFilter CellColor', () {
        test('ColorFilterFontColor-1', () {
          final Workbook workbook = Workbook();
          final Worksheet sheet = workbook.worksheets[0];

          sheet.getRangeByName('A1').setText('Title');
          sheet.getRangeByName('A2').setText('Sales Representative');
          sheet.getRangeByName('A3').setText('Owner');
          sheet.getRangeByName('A4').setText('Owner');
          sheet.getRangeByName('A5').setText('Sales Representative');
          sheet.getRangeByName('A6').setText('Order Administrator');
          sheet.getRangeByName('A7').setText('Sales Representative');
          sheet.getRangeByName('A8').setText('Marketing Manager');
          sheet.getRangeByName('A9').setText('Owner');
          sheet.getRangeByName('A10').setText('Owner');

          sheet.getRangeByName('B1').setText('DOJ');
          sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
          sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
          sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
          sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
          sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
          sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
          sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
          sheet.getRangeByName('B9').dateTime = DateTime(2002, 4, 16);
          sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

          sheet.getRangeByName('C1').setText('City');
          sheet.getRangeByName('C2').setText('Berlin');
          sheet.getRangeByName('C3').setText('México D.F.');
          sheet.getRangeByName('C4').setText('México D.F.');
          sheet.getRangeByName('C5').setText('London');
          sheet.getRangeByName('C6').setText('Luleå');
          sheet.getRangeByName('C7').setText('Mannheim');
          sheet.getRangeByName('C8').setText('Strasbourg');
          sheet.getRangeByName('C9').setText('Madrid');
          sheet.getRangeByName('C10').setText('Marseille');

          sheet.getRangeByName('A2').cellStyle.backColor = '#008000';
          sheet.getRangeByName('A3').cellStyle.backColor = '#0000FF';
          sheet.getRangeByName('A4').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A5').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A6').cellStyle.backColor = '#FFFFFF';
          sheet.getRangeByName('A7').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A8').cellStyle.backColor = '#FFFFFF';
          sheet.getRangeByName('A9').cellStyle.backColor = '#0000FF';
          sheet.getRangeByName('A10').cellStyle.backColor = '#008000';

          sheet.getRangeByName('C2').cellStyle.fontColor = '#FF0000';
          sheet.getRangeByName('C3').cellStyle.fontColor = '#008000';
          sheet.getRangeByName('C4').cellStyle.fontColor = '#0000FF';
          sheet.getRangeByName('C5').cellStyle.fontColor = '#000000';
          sheet.getRangeByName('C6').cellStyle.fontColor = '#FF0000';
          sheet.getRangeByName('C7').cellStyle.fontColor = '#008000';
          sheet.getRangeByName('C8').cellStyle.fontColor = '#0000FF';
          sheet.getRangeByName('C9').cellStyle.fontColor = '#000000';
          sheet.getRangeByName('C10').cellStyle.fontColor = '#FF0000';

          //Intialize Filter Range
          sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
          final AutoFilter autofilter = sheet.autoFilters[2];
          autofilter.addColorFilter('#0000FF', ExcelColorFilterType.fontColor);
          sheet.getRangeByName('A1:C10').autoFitColumns();
          //saving Sheet
          final List<int> bytes = workbook.saveAsStream();
          saveAsExcel(bytes, 'ColorFilterFontColor.xlsx');
          workbook.dispose();
        });

        test('ColorFilterFontColor-2', () {
          final Workbook workbook = Workbook();
          final Worksheet sheet = workbook.worksheets[0];

          sheet.getRangeByName('A1').setText('Title');
          sheet.getRangeByName('A2').setText('Sales Representative');
          sheet.getRangeByName('A3').setText('Owner');
          sheet.getRangeByName('A4').setText('Owner');
          sheet.getRangeByName('A5').setText('Sales Representative');
          sheet.getRangeByName('A6').setText('Order Administrator');
          sheet.getRangeByName('A7').setText('Sales Representative');
          sheet.getRangeByName('A8').setText('Marketing Manager');
          sheet.getRangeByName('A9').setText('Owner');
          sheet.getRangeByName('A10').setText('Owner');

          sheet.getRangeByName('B1').setText('DOJ');
          sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
          sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
          sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
          sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
          sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
          sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
          sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
          sheet.getRangeByName('B9').dateTime = DateTime(2002, 4, 16);
          sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

          sheet.getRangeByName('C1').setText('City');
          sheet.getRangeByName('C2').setText('Berlin');
          sheet.getRangeByName('C3').setText('México D.F.');
          sheet.getRangeByName('C4').setText('México D.F.');
          sheet.getRangeByName('C5').setText('London');
          sheet.getRangeByName('C6').setText('Luleå');
          sheet.getRangeByName('C7').setText('Mannheim');
          sheet.getRangeByName('C8').setText('Strasbourg');
          sheet.getRangeByName('C9').setText('Madrid');
          sheet.getRangeByName('C10').setText('Marseille');

          sheet.getRangeByName('A2').cellStyle.backColor = '#008000';
          sheet.getRangeByName('A3').cellStyle.backColor = '#0000FF';
          sheet.getRangeByName('A4').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A5').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A6').cellStyle.backColor = '#FFFFFF';
          sheet.getRangeByName('A7').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A8').cellStyle.backColor = '#FFFFFF';
          sheet.getRangeByName('A9').cellStyle.backColor = '#0000FF';
          sheet.getRangeByName('A10').cellStyle.backColor = '#008000';

          sheet.getRangeByName('C2').cellStyle.fontColor = '#FF0000';
          sheet.getRangeByName('C3').cellStyle.fontColor = '#008000';
          sheet.getRangeByName('C4').cellStyle.fontColor = '#0000FF';
          sheet.getRangeByName('C5').cellStyle.fontColor = '#000000';
          sheet.getRangeByName('C6').cellStyle.fontColor = '#FF0000';
          sheet.getRangeByName('C7').cellStyle.fontColor = '#008000';
          sheet.getRangeByName('C8').cellStyle.fontColor = '#0000FF';
          sheet.getRangeByName('C9').cellStyle.fontColor = '#000000';
          sheet.getRangeByName('C10').cellStyle.fontColor = '#FF0000';

          //Intialize Filter Range
          sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
          final AutoFilter autofilter = sheet.autoFilters[2];
          autofilter.addColorFilter('#0000FF', ExcelColorFilterType.fontColor);
          sheet.getRangeByName('A1:C10').autoFitColumns();
          //saving Sheet
          final List<int> bytes = workbook.saveAsStream();
          saveAsExcel(bytes, 'ColorFilterFontColor_2.xlsx');
          workbook.dispose();
        });

        test('ColorFilterFontColor-3', () {
          final Workbook workbook = Workbook();
          final Worksheet sheet = workbook.worksheets[0];

          sheet.getRangeByName('A1').setText('Title');
          sheet.getRangeByName('A2').setText('Sales Representative');
          sheet.getRangeByName('A3').setText('Owner');
          sheet.getRangeByName('A4').setText('Owner');
          sheet.getRangeByName('A5').setText('Sales Representative');
          sheet.getRangeByName('A6').setText('Order Administrator');
          sheet.getRangeByName('A7').setText('Sales Representative');
          sheet.getRangeByName('A8').setText('Marketing Manager');
          sheet.getRangeByName('A9').setText('Owner');
          sheet.getRangeByName('A10').setText('Owner');

          sheet.getRangeByName('B1').setText('DOJ');
          sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
          sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
          sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
          sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
          sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
          sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
          sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
          sheet.getRangeByName('B9').dateTime = DateTime(2002, 4, 16);
          sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

          sheet.getRangeByName('C1').setText('City');
          sheet.getRangeByName('C2').setText('Berlin');
          sheet.getRangeByName('C3').setText('México D.F.');
          sheet.getRangeByName('C4').setText('México D.F.');
          sheet.getRangeByName('C5').setText('London');
          sheet.getRangeByName('C6').setText('Luleå');
          sheet.getRangeByName('C7').setText('Mannheim');
          sheet.getRangeByName('C8').setText('Strasbourg');
          sheet.getRangeByName('C9').setText('Madrid');
          sheet.getRangeByName('C10').setText('Marseille');

          sheet.getRangeByName('A2').cellStyle.backColor = '#008000';
          sheet.getRangeByName('A3').cellStyle.backColor = '#0000FF';
          sheet.getRangeByName('A4').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A5').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A6').cellStyle.backColor = '#FFFFFF';
          sheet.getRangeByName('A7').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A8').cellStyle.backColor = '#FFFFFF';
          sheet.getRangeByName('A9').cellStyle.backColor = '#0000FF';
          sheet.getRangeByName('A10').cellStyle.backColor = '#008000';

          sheet.getRangeByName('C2').cellStyle.fontColor = '#FF0000';
          sheet.getRangeByName('C3').cellStyle.fontColor = '#008000';
          sheet.getRangeByName('C4').cellStyle.fontColor = '#0000FF';
          sheet.getRangeByName('C5').cellStyle.fontColor = '#000000';
          sheet.getRangeByName('C6').cellStyle.fontColor = '#FF0000';
          sheet.getRangeByName('C7').cellStyle.fontColor = '#008000';
          sheet.getRangeByName('C8').cellStyle.fontColor = '#0000FF';
          sheet.getRangeByName('C9').cellStyle.fontColor = '#000000';
          sheet.getRangeByName('C10').cellStyle.fontColor = '#FF0000';

          //Intialize Filter Range
          sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
          final AutoFilter autofilter = sheet.autoFilters[2];
          autofilter.addColorFilter('#008000', ExcelColorFilterType.fontColor);
          sheet.getRangeByName('A1:C10').autoFitColumns();
          //saving Sheet
          final List<int> bytes = workbook.saveAsStream();
          saveAsExcel(bytes, 'ColorFilterFontColor.xlsx');
          workbook.dispose();
        });
      });

      group('CellColor', () {
        test('ColorFilterCellColor1', () {
          final Workbook workbook = Workbook();
          final Worksheet sheet = workbook.worksheets[0];

          sheet.getRangeByName('A1').setText('Title');
          sheet.getRangeByName('A2').setText('Sales Representative');
          sheet.getRangeByName('A3').setText('Owner');
          sheet.getRangeByName('A4').setText('Owner');
          sheet.getRangeByName('A5').setText('Sales Representative');
          sheet.getRangeByName('A6').setText('Order Administrator');
          sheet.getRangeByName('A7').setText('Sales Representative');
          sheet.getRangeByName('A8').setText('Marketing Manager');
          sheet.getRangeByName('A9').setText('Owner');
          sheet.getRangeByName('A10').setText('Owner');

          sheet.getRangeByName('B1').setText('DOJ');
          sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
          sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
          sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
          sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
          sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
          sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
          sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
          sheet.getRangeByName('B9').dateTime = DateTime(2002, 4, 16);
          sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

          sheet.getRangeByName('C1').setText('City');
          sheet.getRangeByName('C2').setText('Berlin');
          sheet.getRangeByName('C3').setText('México D.F.');
          sheet.getRangeByName('C4').setText('México D.F.');
          sheet.getRangeByName('C5').setText('London');
          sheet.getRangeByName('C6').setText('Luleå');
          sheet.getRangeByName('C7').setText('Mannheim');
          sheet.getRangeByName('C8').setText('Strasbourg');
          sheet.getRangeByName('C9').setText('Madrid');
          sheet.getRangeByName('C10').setText('Marseille');

          sheet.getRangeByName('A2').cellStyle.backColor = '#008000';
          sheet.getRangeByName('A3').cellStyle.backColor = '#0000FF';
          sheet.getRangeByName('A4').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A5').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A6').cellStyle.backColor = '#FFFFFF';
          sheet.getRangeByName('A7').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A8').cellStyle.backColor = '#FFFFFF';
          sheet.getRangeByName('A9').cellStyle.backColor = '#0000FF';
          sheet.getRangeByName('A10').cellStyle.backColor = '#008000';

          sheet.getRangeByName('C2').cellStyle.fontColor = '#FF0000';
          sheet.getRangeByName('C3').cellStyle.fontColor = '#008000';
          sheet.getRangeByName('C4').cellStyle.fontColor = '#0000FF';
          sheet.getRangeByName('C5').cellStyle.fontColor = '#000000';
          sheet.getRangeByName('C6').cellStyle.fontColor = '#FF0000';
          sheet.getRangeByName('C7').cellStyle.fontColor = '#008000';
          sheet.getRangeByName('C8').cellStyle.fontColor = '#0000FF';
          sheet.getRangeByName('C9').cellStyle.fontColor = '#000000';
          sheet.getRangeByName('C10').cellStyle.fontColor = '#FF0000';

          //Intialize Filter Range
          sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
          final AutoFilter autofilter = sheet.autoFilters[0];
          autofilter.addColorFilter('#FF0000', ExcelColorFilterType.cellColor);
          sheet.getRangeByName('A1:C10').autoFitColumns();
          //saving Sheet
          final List<int> bytes = workbook.saveAsStream();
          saveAsExcel(bytes, 'ColorFilterCellColor_1.xlsx');
          workbook.dispose();
        });

        test('ColorFilterCellColor', () {
          final Workbook workbook = Workbook();
          final Worksheet sheet = workbook.worksheets[0];

          sheet.getRangeByName('A1').setText('Title');
          sheet.getRangeByName('A2').setText('Sales Representative');
          sheet.getRangeByName('A3').setText('Owner');
          sheet.getRangeByName('A4').setText('Owner');
          sheet.getRangeByName('A5').setText('Sales Representative');
          sheet.getRangeByName('A6').setText('Order Administrator');
          sheet.getRangeByName('A7').setText('Sales Representative');
          sheet.getRangeByName('A8').setText('Marketing Manager');
          sheet.getRangeByName('A9').setText('Owner');
          sheet.getRangeByName('A10').setText('Owner');

          sheet.getRangeByName('B1').setText('DOJ');
          sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
          sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
          sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
          sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
          sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
          sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
          sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
          sheet.getRangeByName('B9').dateTime = DateTime(2002, 4, 16);
          sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

          sheet.getRangeByName('C1').setText('City');
          sheet.getRangeByName('C2').setText('Berlin');
          sheet.getRangeByName('C3').setText('México D.F.');
          sheet.getRangeByName('C4').setText('México D.F.');
          sheet.getRangeByName('C5').setText('London');
          sheet.getRangeByName('C6').setText('Luleå');
          sheet.getRangeByName('C7').setText('Mannheim');
          sheet.getRangeByName('C8').setText('Strasbourg');
          sheet.getRangeByName('C9').setText('Madrid');
          sheet.getRangeByName('C10').setText('Marseille');

          sheet.getRangeByName('A2').cellStyle.backColor = '#008000';
          sheet.getRangeByName('A3').cellStyle.backColor = '#0000FF';
          sheet.getRangeByName('A4').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A5').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A6').cellStyle.backColor = '#FFFFFF';
          sheet.getRangeByName('A7').cellStyle.backColor = '#FF0000';
          sheet.getRangeByName('A8').cellStyle.backColor = '#FFFFFF';
          sheet.getRangeByName('A9').cellStyle.backColor = '#0000FF';
          sheet.getRangeByName('A10').cellStyle.backColor = '#008000';

          sheet.getRangeByName('C2').cellStyle.fontColor = '#FF0000';
          sheet.getRangeByName('C3').cellStyle.fontColor = '#008000';
          sheet.getRangeByName('C4').cellStyle.fontColor = '#0000FF';
          sheet.getRangeByName('C5').cellStyle.fontColor = '#000000';
          sheet.getRangeByName('C6').cellStyle.fontColor = '#FF0000';
          sheet.getRangeByName('C7').cellStyle.fontColor = '#008000';
          sheet.getRangeByName('C8').cellStyle.fontColor = '#0000FF';
          sheet.getRangeByName('C9').cellStyle.fontColor = '#000000';
          sheet.getRangeByName('C10').cellStyle.fontColor = '#FF0000';

          //Intialize Filter Range
          sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
          final AutoFilter autofilter = sheet.autoFilters[0];
          autofilter.addColorFilter('#0000FF', ExcelColorFilterType.cellColor);
          sheet.getRangeByName('A1:C10').autoFitColumns();
          //saving Sheet
          final List<int> bytes = workbook.saveAsStream();
          saveAsExcel(bytes, 'ColorFilterCellColor_2.xlsx');
          workbook.dispose();
        });
      });
    });
    group('DynamicFilter', () {
      test('Quater1 of the year', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 3, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');
        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDynamicFilter(DynamicFilterType.quarter1);
        sheet.getRangeByName('A1:C10').autoFitColumns();
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DynamicFilter.xlsx');
        workbook.dispose();
      });
      test('quater2 of the year', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 3, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');
        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDynamicFilter(DynamicFilterType.quarter2);
        sheet.getRangeByName('A1:C10').autoFitColumns();
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DynamicFilter.xlsx');
        workbook.dispose();
      });

      test('Quater3 of the year', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 3, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');
        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDynamicFilter(DynamicFilterType.quarter3);
        sheet.getRangeByName('A1:C10').autoFitColumns();
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DynamicFilter.xlsx');
        workbook.dispose();
      });

      test('Quater4 Of the year', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 3, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');
        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDynamicFilter(DynamicFilterType.quarter4);
        sheet.getRangeByName('A1:C10').autoFitColumns();
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DynamicFilter.xlsx');
        workbook.dispose();
      });

      test('This Week', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 3, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');
        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDynamicFilter(DynamicFilterType.thisMonth);
        sheet.getRangeByName('A1:C10').autoFitColumns();
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DynamicFilter.xlsx');
        workbook.dispose();
      });

      test('thisWeek', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 3, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');
        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDynamicFilter(DynamicFilterType.thisWeek);
        sheet.getRangeByName('A1:C10').autoFitColumns();
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DynamicFilter.xlsx');
        workbook.dispose();
      });
      test('NextMonth', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 3, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');
        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDynamicFilter(DynamicFilterType.nextMonth);
        sheet.getRangeByName('A1:C10').autoFitColumns();
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DynamicFilter.xlsx');
        workbook.dispose();
      });

      test('LastYear', () {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];

        sheet.getRangeByName('A1').setText('Title');
        sheet.getRangeByName('A2').setText('Sales Representative');
        sheet.getRangeByName('A3').setText('Owner');
        sheet.getRangeByName('A4').setText('Owner');
        sheet.getRangeByName('A5').setText('Sales Representative');
        sheet.getRangeByName('A6').setText('Order Administrator');
        sheet.getRangeByName('A7').setText('Sales Representative');
        sheet.getRangeByName('A8').setText('Marketing Manager');
        sheet.getRangeByName('A9').setText('Owner');
        sheet.getRangeByName('A10').setText('Owner');

        sheet.getRangeByName('B1').setText('DOJ');
        sheet.getRangeByName('B2').dateTime = DateTime(2021, 9, 10);
        sheet.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
        sheet.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
        sheet.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
        sheet.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
        sheet.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
        sheet.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
        sheet.getRangeByName('B9').dateTime = DateTime(2002, 3, 16);
        sheet.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

        sheet.getRangeByName('C1').setText('City');
        sheet.getRangeByName('C2').setText('Berlin');
        sheet.getRangeByName('C3').setText('México D.F.');
        sheet.getRangeByName('C4').setText('México D.F.');
        sheet.getRangeByName('C5').setText('London');
        sheet.getRangeByName('C6').setText('Luleå');
        sheet.getRangeByName('C7').setText('Mannheim');
        sheet.getRangeByName('C8').setText('Strasbourg');
        sheet.getRangeByName('C9').setText('Madrid');
        sheet.getRangeByName('C10').setText('Marseille');
        //Intialize Filter Range
        sheet.autoFilters.filterRange = sheet.getRangeByName('A1:C10');
        final AutoFilter autofilter = sheet.autoFilters[1];
        autofilter.addDynamicFilter(DynamicFilterType.lastYear);
        sheet.getRangeByName('A1:C10').autoFitColumns();
        //saving Sheet
        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'DynamicFilter.xlsx');
        workbook.dispose();
      });
    });
  });
}
