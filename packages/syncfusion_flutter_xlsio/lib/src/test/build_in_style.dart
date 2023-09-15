// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioBuildInStyle() {
  group('BuildInStyle', () {
    test('Good, Bad, and Neutral', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByIndex(1, 2);
      range1.number = 4;
      range1.builtInStyle = BuiltInStyles.bad;

      final Range range2 = sheet.getRangeByName('A4');
      range2.text = 'M';
      range2.builtInStyle = BuiltInStyles.good;

      final Range range3 = sheet.getRangeByName('D4');
      range3.text = 'Zee';
      range3.builtInStyle = BuiltInStyles.neutral;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelBuildInStyleGood_Bad.xlsx');
      workbook.dispose();
    });

    test('Data and Model', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByIndex(10, 1);
      range1.number = 22;
      range1.builtInStyle = BuiltInStyles.calculation;

      final Range range2 = sheet.getRangeByName('F5');
      range2.text = 'Hai';
      range2.builtInStyle = BuiltInStyles.checkCell;

      final Range range3 = sheet.getRangeByName('H8');
      range3.text = 'Jumbo';
      range3.builtInStyle = BuiltInStyles.explanatoryText;

      final Range range4 = sheet.getRangeByIndex(6, 3);
      range4.number = 44;
      range4.builtInStyle = BuiltInStyles.input;

      final Range range5 = sheet.getRangeByIndex(2, 8);
      range5.text = 'MJ';
      range5.builtInStyle = BuiltInStyles.linkedCell;

      final Range range6 = sheet.getRangeByIndex(6, 10);
      range6.setNumber(-40);
      range6.builtInStyle = BuiltInStyles.note;

      final Range range7 = sheet.getRangeByIndex(5, 6);
      range7.setText('zeee');
      range7.builtInStyle = BuiltInStyles.output;

      final Range range8 = sheet.getRangeByIndex(10, 10);
      range8.text = 'Wrong!';
      range8.builtInStyle = BuiltInStyles.warningText;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelBuildInStyleDataModel.xlsx');
      workbook.dispose();
    });

    test('Titles and Heading', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range1 = sheet.getRangeByIndex(10, 12);
      range1.text = 'Time';
      range1.builtInStyle = BuiltInStyles.heading1;

      final Range range2 = sheet.getRangeByName('H5');
      range2.text = 'POWER';
      range2.builtInStyle = BuiltInStyles.heading2;

      final Range range3 = sheet.getRangeByName('A3');
      range3.text = 'TriAngle';
      range3.builtInStyle = BuiltInStyles.heading3;

      final Range range4 = sheet.getRangeByIndex(4, 3);
      range4.number = 1000;
      range4.builtInStyle = BuiltInStyles.heading4;

      final Range range5 = sheet.getRangeByIndex(1, 8);
      range5.text = 'Man';
      range5.builtInStyle = BuiltInStyles.title;

      final Range range6 = sheet.getRangeByIndex(6, 10);
      range6.setNumber(200);
      range6.builtInStyle = BuiltInStyles.total;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelBuildInStyleTitlesHeading.xlsx');
      workbook.dispose();
    });

    test('Themes Cell style', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range1 = sheet.getRangeByIndex(2, 2);
      range1.number = 1622;
      range1.builtInStyle = BuiltInStyles.accent1;

      final Range range2 = sheet.getRangeByName('B4');
      range2.text = 'Hai';
      range2.builtInStyle = BuiltInStyles.accent2;

      final Range range3 = sheet.getRangeByName('B6');
      range3.text = 'Animals!!!!';
      range3.builtInStyle = BuiltInStyles.accent3;

      final Range range4 = sheet.getRangeByIndex(8, 2);
      range4.number = -751;
      range4.builtInStyle = BuiltInStyles.accent4;

      final Range range5 = sheet.getRangeByIndex(10, 2);
      range5.text = 'Sky';
      range5.builtInStyle = BuiltInStyles.accent5;

      final Range range6 = sheet.getRangeByIndex(12, 2);
      range6.setNumber(120);
      range6.builtInStyle = BuiltInStyles.accent6;

      final Range range7 = sheet.getRangeByIndex(2, 4);
      range7.setNumber(100);
      range7.builtInStyle = BuiltInStyles.accent6_20;

      final Range range8 = sheet.getRangeByIndex(4, 4);
      range8.text = 'Welcome';
      range8.builtInStyle = BuiltInStyles.accent5_20;

      final Range range9 = sheet.getRangeByName('D6');
      range9.setText('Chennai');
      range9.builtInStyle = BuiltInStyles.accent4_20;

      final Range range10 = sheet.getRangeByName('D8');
      range10.setNumber(-1616);
      range10.builtInStyle = BuiltInStyles.accent3_20;

      final Range range11 = sheet.getRangeByIndex(10, 4);
      range11.number = 41290;
      range11.builtInStyle = BuiltInStyles.accent2_20;

      final Range range12 = sheet.getRangeByName('D12');
      range12.text = 'Magnum';
      range12.builtInStyle = BuiltInStyles.accent1_20;

      final Range range13 = sheet.getRangeByName('F2');
      range13.text = 'Effel';
      range13.builtInStyle = BuiltInStyles.accent1_40;

      final Range range14 = sheet.getRangeByIndex(4, 6);
      range14.number = 2901;
      range14.builtInStyle = BuiltInStyles.accent2_40;

      final Range range15 = sheet.getRangeByIndex(6, 6);
      range15.text = 'Magic';
      range15.builtInStyle = BuiltInStyles.accent3_40;

      final Range range16 = sheet.getRangeByIndex(8, 6);
      range16.setNumber(2020);
      range16.builtInStyle = BuiltInStyles.accent4_40;

      final Range range17 = sheet.getRangeByIndex(10, 6);
      range17.setNumber(100);
      range17.builtInStyle = BuiltInStyles.accent5_40;

      final Range range18 = sheet.getRangeByIndex(12, 6);
      range18.text = 'Disney';
      range18.builtInStyle = BuiltInStyles.accent6_40;

      final Range range19 = sheet.getRangeByName('H2');
      range19.setNumber(4444);
      range19.builtInStyle = BuiltInStyles.accent6_60;

      final Range range20 = sheet.getRangeByName('H4');
      range20.setNumber(16);
      range20.builtInStyle = BuiltInStyles.accent5_60;

      final Range range21 = sheet.getRangeByIndex(6, 8);
      range21.number = -3712128;
      range21.builtInStyle = BuiltInStyles.accent4_60;

      final Range range22 = sheet.getRangeByName('H8');
      range22.text = 'Universe';
      range22.builtInStyle = BuiltInStyles.accent3_60;

      final Range range23 = sheet.getRangeByName('H10');
      range23.text = 'Paris';
      range23.builtInStyle = BuiltInStyles.accent2_60;

      final Range range24 = sheet.getRangeByIndex(12, 8);
      range24.number = 1003839;
      range24.builtInStyle = BuiltInStyles.accent1_60;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelBuildInStyleThemeCellStyle.xlsx');
      workbook.dispose();
    });

    test('NumberFormat', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.number = 4;
      range1.builtInStyle = BuiltInStyles.comma;

      final Range range2 = sheet.getRangeByName('C3');
      range2.number = 44;
      range2.builtInStyle = BuiltInStyles.comma0;

      final Range range3 = sheet.getRangeByName('E5');
      range3.number = 444;
      range3.builtInStyle = BuiltInStyles.currency;

      final Range range4 = sheet.getRangeByName('G7');
      range4.number = 4444;
      range4.builtInStyle = BuiltInStyles.currency0;

      final Range range5 = sheet.getRangeByName('I9');
      range5.number = 4;
      range5.builtInStyle = BuiltInStyles.percent;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelBuildInStyleNumberFormat.xlsx');
      workbook.dispose();
    });
  });
}
