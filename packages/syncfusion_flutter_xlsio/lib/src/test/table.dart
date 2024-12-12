// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioTable() {
  group('Tables', () {
    test('Table without TableStyles', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.None;

      expect(table.displayName, 'Table1');
      expect(table.builtInTableStyle, ExcelTableBuiltInStyle.None);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'TableWithoutTableStyles.xlsx');
      workbook.dispose();
    });

    test('Table with DefaultStyle', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      expect(table.builtInTableStyle, ExcelTableBuiltInStyle.tableStyleMedium2);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'TableWithDefaultStyle.xlsx');
      workbook.dispose();
    });

    test('Multiple Sheet with Multiple Table', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(2);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[1];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      sheet.getRangeByName('J8').setText('Name');
      sheet.getRangeByName('J9').setText('Rahul');
      sheet.getRangeByName('J10').setText('Mark');
      sheet.getRangeByName('J11').setText('Levi');

      sheet.getRangeByName('K8').setText('SubjectA');
      sheet.getRangeByName('K9').setNumber(80);
      sheet.getRangeByName('K10').setNumber(90);
      sheet.getRangeByName('K11').setNumber(92);

      sheet.getRangeByName('L8').setText('SubjectB');
      sheet.getRangeByName('L9').setNumber(76);
      sheet.getRangeByName('L10').setNumber(71);
      sheet.getRangeByName('L11').setNumber(89);

      sheet1.getRangeByName('F1').setText('Vegetables');
      sheet1.getRangeByName('F2').setText('Egg Plant');
      sheet1.getRangeByName('F3').setText('DrumStick');
      sheet1.getRangeByName('F4').setText('Tomato');

      sheet1.getRangeByName('G1').setText('CostA1');
      sheet1.getRangeByName('G2').setNumber(744.6);
      sheet1.getRangeByName('G3').setNumber(5079.6);
      sheet1.getRangeByName('G4').setNumber(1267.5);

      sheet1.getRangeByName('H1').setText('CostB1');
      sheet1.getRangeByName('H2').setNumber(162.56);
      sheet1.getRangeByName('H3').setNumber(1249.2);
      sheet1.getRangeByName('H4').setNumber(1062.5);

      sheet1.getRangeByName('A6').setText('Product A');
      sheet1.getRangeByName('A7').setText('shirt');
      sheet1.getRangeByName('A8').setText('bags');
      sheet1.getRangeByName('A9').setText('Trousers');

      sheet1.getRangeByName('B6').setText('Cost1');
      sheet1.getRangeByName('B7').setNumber(654);
      sheet1.getRangeByName('B8').setNumber(745);
      sheet1.getRangeByName('B9').setNumber(187);

      sheet1.getRangeByName('C6').setText('Cost2');
      sheet1.getRangeByName('C7').setNumber(967);
      sheet1.getRangeByName('C8').setNumber(543);
      sheet1.getRangeByName('C9').setNumber(864);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      final ExcelTable table1 = sheet1.tableCollection
          .create('Table2', sheet1.getRangeByName('F1:H4'));

      final ExcelTable table2 = sheet.tableCollection
          .create('Table3', sheet.getRangeByName('J8:L11'));

      final ExcelTable table3 = sheet1.tableCollection
          .create('Table4', sheet1.getRangeByName('A6:C9'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium15;
      table1.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark10;
      table2.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark5;
      table3.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight9;

      expect(table1.displayName, 'Table2');
      expect(table3.builtInTableStyle, ExcelTableBuiltInStyle.tableStyleLight9);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'MultipleSheetsWithMultipleTables.xlsx');
      workbook.dispose();
    });

    test('Single Sheet with Multiple Tables', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      //Load data
      sheet.getRangeByName('F1').setText('Vegetables');
      sheet.getRangeByName('F2').setText('tomato');
      sheet.getRangeByName('F3').setText('onion');
      sheet.getRangeByName('F4').setText('Beans');

      sheet.getRangeByName('G1').setText('Cost1');
      sheet.getRangeByName('G2').setNumber(744);
      sheet.getRangeByName('G3').setNumber(5079);
      sheet.getRangeByName('G4').setNumber(126);

      sheet.getRangeByName('H1').setText('Cost2');
      sheet.getRangeByName('H2').setNumber(168);
      sheet.getRangeByName('H3').setNumber(1249);
      sheet.getRangeByName('H4').setNumber(1062);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      final ExcelTable table1 =
          sheet.tableCollection.create('Table2', sheet.getRangeByName('F1:H4'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight11;
      table1.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark7;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'SingleSheetWithMultipleTables.xlsx');
      workbook.dispose();
    });

    test('Multiple Sheet with Single Table', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(2);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      final Worksheet sheet1 = workbook.worksheets[1];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      sheet1.getRangeByName('F1').setText('Product A');
      sheet1.getRangeByName('F2').setText('shirt');
      sheet1.getRangeByName('F3').setText('bags');
      sheet1.getRangeByName('F4').setText('Trousers');

      sheet1.getRangeByName('G1').setText('Cost1');
      sheet1.getRangeByName('G2').setNumber(654);
      sheet1.getRangeByName('G3').setNumber(745);
      sheet1.getRangeByName('G4').setNumber(187);

      sheet1.getRangeByName('H1').setText('Cost2');
      sheet1.getRangeByName('H2').setNumber(967);
      sheet1.getRangeByName('H3').setNumber(543);
      sheet1.getRangeByName('H4').setNumber(864);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      final ExcelTable table1 = sheet1.tableCollection
          .create('Table2', sheet1.getRangeByName('F1:H4'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium15;
      table1.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark10;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'MultipleSheetsWithSingleTable.xlsx');
      workbook.dispose();
    });

    test('Single Sheet with Single Table', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight7;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'SingleSheetWithSingleTable.xlsx');
      workbook.dispose();
    });

    test('Show First Column and Show Last Column', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium6;

      /// Shows First Column
      table.showFirstColumn = true;
      expect(table.showFirstColumn, true);

      /// Shows Last Column
      table.showLastColumn = true;
      expect(table.showLastColumn, true);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ShowFirstColumnAndShowLastColumn.xlsx');
      workbook.dispose();
    });

    test('Table Style Column Stripes', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      //Load data
      sheet.getRangeByName('F1').setText('Vegetables');
      sheet.getRangeByName('F2').setText('tomato');
      sheet.getRangeByName('F3').setText('onion');
      sheet.getRangeByName('F4').setText('Beans');

      sheet.getRangeByName('G1').setText('Cost1');
      sheet.getRangeByName('G2').setNumber(744);
      sheet.getRangeByName('G3').setNumber(5079);
      sheet.getRangeByName('G4').setNumber(126);

      sheet.getRangeByName('H1').setText('Cost2');
      sheet.getRangeByName('H2').setNumber(168);
      sheet.getRangeByName('H3').setNumber(1249);
      sheet.getRangeByName('H4').setNumber(1062);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      final ExcelTable table1 =
          sheet.tableCollection.create('Table2', sheet.getRangeByName('F1:H4'));

      /// shows Table Style Row Stripes
      table.showBandedRows = true;
      expect(table.showBandedRows, true);

      /// shows Table Style Column Stripes
      table1.showBandedColumns = true;
      expect(table1.showBandedColumns, true);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'TableStyleColumnStripes.xlsx');
      workbook.dispose();
    });

    test('Show First Column and Show Last Column', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      ///Shows First Column
      table.showFirstColumn = true;
      expect(table.showFirstColumn, true);

      ///Shows Last Column
      table.showLastColumn = true;
      expect(table.showLastColumn, true);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ShowFirstColumnAndShowLastColumn.xlsx');
      workbook.dispose();
    });

    test('Default Column Names', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight2;

      expect(table.columns[0].columnName, 'Column1');
      expect(table.columns[1].columnName, 'Column2');
      expect(table.columns[2].columnName, 'Column3');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'DefaultColumnNames.xlsx');
      workbook.dispose();
    });

    test('Repeated Column Names', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('Fruits');
      sheet.getRangeByName('B2').setText('Strawberry');
      sheet.getRangeByName('B3').setText('Apple');
      sheet.getRangeByName('B4').setText('Guava');

      sheet.getRangeByName('C1').setText('Fruits');
      sheet.getRangeByName('C2').setText('Papaya');
      sheet.getRangeByName('C3').setText('Grapes');
      sheet.getRangeByName('C4').setText('Pineapple');

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark8;

      expect(table.columns[0].columnName, 'Fruits');
      expect(table.columns[1].columnName, 'Fruits2');
      expect(table.columns[2].columnName, 'Fruits3');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'RepeatedColumnNames.xlsx');
      workbook.dispose();
    });

    test('Show Header Row', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      // Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      // Load Data
      sheet.getRangeByName('F1').setText('Vegetables');
      sheet.getRangeByName('F2').setText('tomato');
      sheet.getRangeByName('F3').setText('onion');
      sheet.getRangeByName('F4').setText('Beans');

      sheet.getRangeByName('G1').setText('Cost1');
      sheet.getRangeByName('G2').setNumber(744);
      sheet.getRangeByName('G3').setNumber(5079);
      sheet.getRangeByName('G4').setNumber(126);

      sheet.getRangeByName('H1').setText('Cost2');
      sheet.getRangeByName('H2').setNumber(168);
      sheet.getRangeByName('H3').setNumber(1249);
      sheet.getRangeByName('H4').setNumber(1062);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      final ExcelTable table1 =
          sheet.tableCollection.create('Table2', sheet.getRangeByName('F1:H4'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium2;

      /// Shows Header Row
      table1.showHeaderRow = false;

      expect(table1.showHeaderRow, false);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ShowHeaderRow.xlsx');
      workbook.dispose();
    });

    test('Totals Calculation', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('Grapes');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('Sum');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('Average');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      sheet.getRangeByName('D1').setText('Custom');
      sheet.getRangeByName('D2').setNumber(176.8);
      sheet.getRangeByName('D3').setNumber(524);
      sheet.getRangeByName('D4').setNumber(824.7);

      sheet.getRangeByName('E1').setText('Standard Deviation');
      sheet.getRangeByName('E2').setNumber(263);
      sheet.getRangeByName('E3').setNumber(6547.2);
      sheet.getRangeByName('E4').setNumber(754.5);

      sheet.getRangeByName('F1').setText('Count');
      sheet.getRangeByName('F2').setNumber(847);
      sheet.getRangeByName('F3').setNumber(837.6);
      sheet.getRangeByName('F4').setNumber(912.4);

      sheet.getRangeByName('G1').setText('Minimum');
      sheet.getRangeByName('G2').setNumber(625);
      sheet.getRangeByName('G3').setNumber(6254.76);
      sheet.getRangeByName('G4').setNumber(6368.6);

      sheet.getRangeByName('H1').setText('Maximum');
      sheet.getRangeByName('H2').setNumber(922);
      sheet.getRangeByName('H3').setNumber(2654.7);
      sheet.getRangeByName('H4').setNumber(6346);

      sheet.getRangeByName('I1').setText('Variance');
      sheet.getRangeByName('I2').setNumber(5836);
      sheet.getRangeByName('I3').setNumber(7455.4);
      sheet.getRangeByName('I4').setNumber(1960.4);

      sheet.getRangeByName('J1').setText('Count Numbers');
      sheet.getRangeByName('J2').setNumber(5634);
      sheet.getRangeByName('J3').setNumber(8635);
      sheet.getRangeByName('J4').setNumber(3845.6);

      sheet.getRangeByName('K1').setText('None');
      sheet.getRangeByName('K2').setNumber(34);
      sheet.getRangeByName('K3').setNumber(636);
      sheet.getRangeByName('K4').setNumber(243);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:K4'));

      sheet.getRangeByName('A1:K4').autoFit();

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium9;

      ///Adding Total Row
      table.showTotalRow = true;
      table.columns[0].totalRowLabel = 'Total';
      table.columns[1].totalFormula = ExcelTableTotalFormula.sum;
      table.columns[2].totalFormula = ExcelTableTotalFormula.average;
      table.columns[3].totalFormula = ExcelTableTotalFormula.custom;
      table.columns[4].totalFormula = ExcelTableTotalFormula.stdDev;
      table.columns[5].totalFormula = ExcelTableTotalFormula.count;
      table.columns[6].totalFormula = ExcelTableTotalFormula.min;
      table.columns[7].totalFormula = ExcelTableTotalFormula.max;
      table.columns[8].totalFormula = ExcelTableTotalFormula.variable;
      table.columns[9].totalFormula = ExcelTableTotalFormula.countNums;
      table.columns[10].totalFormula = ExcelTableTotalFormula.none;

      expect(table.showTotalRow, true);
      expect(table.columns[0].totalRowLabel, 'Total');
      expect(table.columns[1].totalFormula, ExcelTableTotalFormula.sum);
      expect(table.columns[2].totalFormula, ExcelTableTotalFormula.average);
      expect(table.columns[3].totalFormula, ExcelTableTotalFormula.custom);
      expect(table.columns[4].totalFormula, ExcelTableTotalFormula.stdDev);
      expect(table.columns[5].totalFormula, ExcelTableTotalFormula.count);
      expect(table.columns[6].totalFormula, ExcelTableTotalFormula.min);
      expect(table.columns[7].totalFormula, ExcelTableTotalFormula.max);
      expect(table.columns[8].totalFormula, ExcelTableTotalFormula.variable);
      expect(table.columns[9].totalFormula, ExcelTableTotalFormula.countNums);
      expect(table.columns[10].totalFormula, ExcelTableTotalFormula.none);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'TotalsCalculation.xlsx');
      workbook.dispose();
    });

    test('Alternativetext and Summary', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('Grapes');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('Sum');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('Average');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium12;

      table.altTextTitle = 'Fruits Cost';
      table.altTextSummary =
          'This table describes the Cost of Fruits mentioned';

      expect(table.altTextTitle, 'Fruits Cost');
      expect(table.altTextSummary,
          'This table describes the Cost of Fruits mentioned');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'AlternativetextAndSummary.xlsx');
      workbook.dispose();
    });

    test('Table for Single Row', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');

      sheet.getRangeByName('B1').setText('Sum');

      sheet.getRangeByName('C1').setText('Average');

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C1'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium12;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'TableForSingleRow.xlsx');
      workbook.dispose();
    });

    test('Remove Table', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('Grapes');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('Sum');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('Average');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      sheet.getRangeByName('F1').setText('Vegetables');
      sheet.getRangeByName('F2').setText('tomato');
      sheet.getRangeByName('F3').setText('onion');
      sheet.getRangeByName('F4').setText('Beans');

      sheet.getRangeByName('G1').setText('Cost1');
      sheet.getRangeByName('G2').setNumber(744);
      sheet.getRangeByName('G3').setNumber(5079);
      sheet.getRangeByName('G4').setNumber(126);

      sheet.getRangeByName('H1').setText('Cost2');
      sheet.getRangeByName('H2').setNumber(168);
      sheet.getRangeByName('H3').setNumber(1249);
      sheet.getRangeByName('H4').setNumber(1062);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      final ExcelTable table1 =
          sheet.tableCollection.create('Table2', sheet.getRangeByName('F1:H4'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium12;
      table1.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium16;

      /// Removes a table from the worksheet.
      sheet.tableCollection.remove(table1);

      //expect(table1.builtInTableStyle, TableBuiltInStyles.None);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'RemoveTable.xlsx');
      workbook.dispose();
    });

    test('RemoveAt Table', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('Grapes');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('Sum');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('Average');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      sheet.getRangeByName('F1').setText('Vegetables');
      sheet.getRangeByName('F2').setText('tomato');
      sheet.getRangeByName('F3').setText('onion');
      sheet.getRangeByName('F4').setText('Beans');

      sheet.getRangeByName('G1').setText('Cost1');
      sheet.getRangeByName('G2').setNumber(744);
      sheet.getRangeByName('G3').setNumber(5079);
      sheet.getRangeByName('G4').setNumber(126);

      sheet.getRangeByName('H1').setText('Cost2');
      sheet.getRangeByName('H2').setNumber(168);
      sheet.getRangeByName('H3').setNumber(1249);
      sheet.getRangeByName('H4').setNumber(1062);

      sheet.getRangeByName('D6').setText('Product A');
      sheet.getRangeByName('D7').setText('shirt');
      sheet.getRangeByName('D8').setText('bags');
      sheet.getRangeByName('D9').setText('Trousers');

      sheet.getRangeByName('E6').setText('Cost1');
      sheet.getRangeByName('E7').setNumber(654);
      sheet.getRangeByName('E8').setNumber(745);
      sheet.getRangeByName('E9').setNumber(187);

      sheet.getRangeByName('F6').setText('Cost2');
      sheet.getRangeByName('F7').setNumber(967);
      sheet.getRangeByName('F8').setNumber(543);
      sheet.getRangeByName('F9').setNumber(864);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      final ExcelTable table1 =
          sheet.tableCollection.create('Table2', sheet.getRangeByName('F1:H4'));

      final ExcelTable table2 =
          sheet.tableCollection.create('Table3', sheet.getRangeByName('D6:F9'));

      ///Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark10;
      table1.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark3;
      table2.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark9;

      /// Removes a table from the worksheet at the specified index.
      sheet.tableCollection.removeAt(0);

      //expect(table.builtInTableStyle, TableBuiltInStyles.None);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'RemoveTableAtSpecifiedIndex.xlsx');
      workbook.dispose();
    });

    test('Modify Column Names', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));
      table.columns[0].columnName = 'Fruits Varieties';
      table.columns[1].columnName = 'Column1';
      table.columns[2].columnName = 'Column2';

      expect(table.columns[0].columnName, 'Fruits Varieties');
      expect(table.columns[1].columnName, 'Column1');
      expect(table.columns[2].columnName, 'Column2');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ModifyingColumnName.xlsx');
      workbook.dispose();
    });

    test('ModifyTableName', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));
      table.displayName = 'FruitsCost';

      expect(table.displayName, 'FruitsCost');

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ModifyingTableName.xlsx');
      workbook.dispose();
    });

    test('ValidTableName', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));
      table.displayName = 'FruitsCost';
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark2;
      try {
        table.displayName = 'Fruits Cost';
      } catch (e) {
        expect(
            'Exception: This is not a valid name. Name should not contain space or characters not allowed.',
            e.toString());
      }

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'CheckSpecialCharactersInTableName.xlsx');
      workbook.dispose();
    });

    test('CheckValidTableName', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));
      table.displayName = 'FruitsCost';

      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium7;

      try {
        table.displayName = '5FruitsCost';
      } catch (e) {
        expect(
            'Exception: This is not a valid name. Name should start with letter or underscore.',
            e.toString());
      }

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'CheckStartingIndexInTableName.xlsx');
      workbook.dispose();
    });

    test('Repeated Table Name', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      sheet.getRangeByName('F1').setText('Vegetables');
      sheet.getRangeByName('F2').setText('tomato');
      sheet.getRangeByName('F3').setText('onion');
      sheet.getRangeByName('F4').setText('Beans');

      sheet.getRangeByName('G1').setText('Cost1');
      sheet.getRangeByName('G2').setNumber(744);
      sheet.getRangeByName('G3').setNumber(5079);
      sheet.getRangeByName('G4').setNumber(126);

      sheet.getRangeByName('H1').setText('Cost2');
      sheet.getRangeByName('H2').setNumber(168);
      sheet.getRangeByName('H3').setNumber(1249);
      sheet.getRangeByName('H4').setNumber(1062);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      final ExcelTable table1 =
          sheet.tableCollection.create('Table2', sheet.getRangeByName('F1:H4'));

      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium10;
      table1.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium6;

      try {
        table1.displayName = 'Table1';
      } catch (e) {
        expect(
            'Exception: Name already exist.Name must be unique', e.toString());
      }
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'RepeatedTableName.xlsx');
      workbook.dispose();
    });

    test('Update Table Range', () {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(1);
      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      //Load data
      sheet.getRangeByName('A1').setText('Fruits');
      sheet.getRangeByName('A2').setText('banana');
      sheet.getRangeByName('A3').setText('Cherry');
      sheet.getRangeByName('A4').setText('Banana');

      sheet.getRangeByName('B1').setText('CostA');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('B4').setNumber(1267.5);

      sheet.getRangeByName('C1').setText('CostB');
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('C4').setNumber(1062.5);

      sheet.getRangeByName('F1').setText('Vegetables');
      sheet.getRangeByName('F2').setText('tomato');
      sheet.getRangeByName('F3').setText('onion');
      sheet.getRangeByName('F4').setText('Beans');

      sheet.getRangeByName('G1').setText('Cost1');
      sheet.getRangeByName('G2').setNumber(744);
      sheet.getRangeByName('G3').setNumber(5079);
      sheet.getRangeByName('G4').setNumber(126);

      sheet.getRangeByName('H1').setText('Cost2');
      sheet.getRangeByName('H2').setNumber(168);
      sheet.getRangeByName('H3').setNumber(1249);
      sheet.getRangeByName('H4').setNumber(1062);

      ///Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      final ExcelTable table1 =
          sheet.tableCollection.create('Table2', sheet.getRangeByName('F1:H4'));

      table1.dataRange = sheet.getRangeByName('A7:C10');

      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium10;
      table1.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium6;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'UpdateTableRange.xlsx');
      workbook.dispose();
    });
  });
}
