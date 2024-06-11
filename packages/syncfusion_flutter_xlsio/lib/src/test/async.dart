import 'dart:ui';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioAsync() {
  group('Excel Async', () {
    test('AutoFilter Async', () async {
      final Workbook workbook = Workbook(4);
      final Worksheet sheet = workbook.worksheets[0];

      ///Loading data for text filter
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

      //Intialize text filter
      sheet.autoFilters.filterRange = sheet.getRangeByName('A1:B10');
      final AutoFilter autofilter = sheet.autoFilters[0];
      autofilter.addTextFilter(<String>{'Angela Davis', 'Al-BirUni'});

      final Worksheet sheet2 = workbook.worksheets[1];

      ///Loading data for color filter
      sheet2.getRangeByName('E1').setText('Title');
      sheet2.getRangeByName('E2').setText('Sales Representative');
      sheet2.getRangeByName('E3').setText('Owner');
      sheet2.getRangeByName('E4').setText('Owner');
      sheet2.getRangeByName('E5').setText('Sales Representative');
      sheet2.getRangeByName('E6').setText('Order Administrator');
      sheet2.getRangeByName('E7').setText('Sales Representative');
      sheet2.getRangeByName('E8').setText('Marketing Manager');
      sheet2.getRangeByName('E9').setText('Owner');
      sheet2.getRangeByName('E10').setText('Owner');

      sheet2.getRangeByName('F1').setText('DOJ');
      sheet2.getRangeByName('F2').dateTime = DateTime(2006, 9, 10);
      sheet2.getRangeByName('F3').dateTime = DateTime(2000, 6, 10);
      sheet2.getRangeByName('F4').dateTime = DateTime(2002, 9, 18);
      sheet2.getRangeByName('F5').dateTime = DateTime(2009, 5, 23);
      sheet2.getRangeByName('F6').dateTime = DateTime(2012, 1, 6);
      sheet2.getRangeByName('F7').dateTime = DateTime(2007, 7, 19);
      sheet2.getRangeByName('F8').dateTime = DateTime(2008, 6, 30);
      sheet2.getRangeByName('F9').dateTime = DateTime(2002, 4, 16);
      sheet2.getRangeByName('F10').dateTime = DateTime(2008, 11, 29);

      sheet2.getRangeByName('G1').setText('City');
      sheet2.getRangeByName('G2').setText('Berlin');
      sheet2.getRangeByName('G3').setText('México D.F.');
      sheet2.getRangeByName('G4').setText('México D.F.');
      sheet2.getRangeByName('G5').setText('London');
      sheet2.getRangeByName('G6').setText('Luleå');
      sheet2.getRangeByName('G7').setText('Mannheim');
      sheet2.getRangeByName('G8').setText('Strasbourg');
      sheet2.getRangeByName('G9').setText('Madrid');
      sheet2.getRangeByName('G10').setText('Marseille');

      sheet2.getRangeByName('E2').cellStyle.backColor = '#008000';
      sheet2.getRangeByName('E3').cellStyle.backColor = '#0000FF';
      sheet2.getRangeByName('E4').cellStyle.backColor = '#FF0000';
      sheet2.getRangeByName('E5').cellStyle.backColor = '#FF0000';
      sheet2.getRangeByName('E6').cellStyle.backColor = '#FFFFFF';
      sheet2.getRangeByName('E7').cellStyle.backColor = '#FF0000';
      sheet2.getRangeByName('E8').cellStyle.backColor = '#FFFFFF';
      sheet2.getRangeByName('E9').cellStyle.backColor = '#0000FF';
      sheet2.getRangeByName('E10').cellStyle.backColor = '#008000';

      sheet2.getRangeByName('G2').cellStyle.fontColor = '#FF0000';
      sheet2.getRangeByName('G3').cellStyle.fontColor = '#008000';
      sheet2.getRangeByName('G4').cellStyle.fontColor = '#0000FF';
      sheet2.getRangeByName('G5').cellStyle.fontColor = '#000000';
      sheet2.getRangeByName('G6').cellStyle.fontColor = '#FF0000';
      sheet2.getRangeByName('G7').cellStyle.fontColor = '#008000';
      sheet2.getRangeByName('G8').cellStyle.fontColor = '#0000FF';
      sheet2.getRangeByName('G9').cellStyle.fontColor = '#000000';
      sheet2.getRangeByName('G10').cellStyle.fontColor = '#FF0000';

      //Intialize Filter Range
      sheet2.autoFilters.filterRange = sheet2.getRangeByName('E1:G10');
      final AutoFilter autofilter2 = sheet2.autoFilters[2];
      autofilter2.addColorFilter('#0000FF', ExcelColorFilterType.fontColor);
      sheet2.getRangeByName('E1:G10').autoFitColumns();

      ///Loading data for number fulter
      final Worksheet sheet3 = workbook.worksheets[2];

      sheet3.getRangeByName('A1').setNumber(10);
      sheet3.getRangeByName('A2').setNumber(15);
      sheet3.getRangeByName('A3').setNumber(15.4);
      sheet3.getRangeByName('A4').setNumber(20.4567678);
      sheet3.getRangeByName('A5').setNumber(10);
      sheet3.getRangeByName('A6').setNumber(20.00087788767667657577557007);
      sheet3.getRangeByName('A7').setNumber(233);
      sheet3.getRangeByName('A8').setNumber(10);
      sheet3.getRangeByName('A9').setNumber(10.01);
      sheet3.getRangeByName('A10').setNumber(9.99);

      sheet3.getRangeByName('B1').setText('Angela Davis');
      sheet3.getRangeByName('B2').setText('Sigmund Freud.');
      sheet3.getRangeByName('B3').setText('Enoch Powell');
      sheet3.getRangeByName('B4').setText('Al-Biruni');
      sheet3.getRangeByName('B5').setText('Joseph Campbell');
      sheet3.getRangeByName('B6').setText('Will Roscoe');
      sheet3.getRangeByName('B7').setText('Barry Bishop');
      sheet3.getRangeByName('B8').setText('Christopher Hogwood');
      sheet3.getRangeByName('B9').setText('Cornel West');
      sheet3.getRangeByName('B10').setText('KarlMarx');

      //Intialize Filter Range
      sheet3.autoFilters.filterRange = sheet3.getRangeByName('A1:C10');
      final AutoFilter filter = sheet3.autoFilters[0];
      final AutoFilterCondition firstCondition = filter.firstCondition;
      firstCondition.conditionOperator = ExcelFilterCondition.equal;
      firstCondition.numberValue = 10;

      //Loading data for datetime fulter
      final Worksheet sheet4 = workbook.worksheets[3];

      sheet4.getRangeByName('A1').setText('Title');
      sheet4.getRangeByName('A2').setText('Sales Representative');
      sheet4.getRangeByName('A3').setText('Owner');
      sheet4.getRangeByName('A4').setText('Owner');
      sheet4.getRangeByName('A5').setText('Sales Representative');
      sheet4.getRangeByName('A6').setText('Order Administrator');
      sheet4.getRangeByName('A7').setText('Sales Representative');
      sheet4.getRangeByName('A8').setText('Marketing Manager');
      sheet4.getRangeByName('A9').setText('Owner');
      sheet4.getRangeByName('A10').setText('Owner');

      sheet4.getRangeByName('B1').setText('DOJ');
      sheet4.getRangeByName('B2').dateTime = DateTime(2006, 9, 10);
      sheet4.getRangeByName('B3').dateTime = DateTime(2000, 6, 10);
      sheet4.getRangeByName('B4').dateTime = DateTime(2002, 9, 18);
      sheet4.getRangeByName('B5').dateTime = DateTime(2009, 5, 23);
      sheet4.getRangeByName('B6').dateTime = DateTime(2012, 1, 6);
      sheet4.getRangeByName('B7').dateTime = DateTime(2007, 7, 19);
      sheet4.getRangeByName('B8').dateTime = DateTime(2008, 6, 30);
      sheet4.getRangeByName('B9').dateTime = DateTime(2002, 4, 16);
      sheet4.getRangeByName('B10').dateTime = DateTime(2008, 11, 29);

      sheet4.getRangeByName('C1').setText('City');
      sheet4.getRangeByName('C2').setText('Berlin');
      sheet4.getRangeByName('C3').setText('México D.F.');
      sheet4.getRangeByName('C4').setText('México D.F.');
      sheet4.getRangeByName('C5').setText('London');
      sheet4.getRangeByName('C6').setText('Luleå');
      sheet4.getRangeByName('C7').setText('Mannheim');
      sheet4.getRangeByName('C8').setText('Strasbourg');
      sheet4.getRangeByName('C9').setText('Madrid');
      sheet4.getRangeByName('C10').setText('Marseille');

      //Intialize Filter Range
      sheet4.autoFilters.filterRange = sheet4.getRangeByName('A1:C10');
      final AutoFilter autofilter3 = sheet4.autoFilters[1];
      autofilter3.addDateFilter(DateTime(2002), DateTimeFilterType.year);

      //saving Sheet
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'AutoFilterAsync.xlsx');
      workbook.dispose();
    });
    test('ConditionalFormats Async', () async {
      final Workbook workbook = Workbook(3);

      // Conditional Formats for data bar
      final Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1').number = 1277;
      sheet.getRangeByName('A2').number = 1003;
      sheet.getRangeByName('A3').number = 1105;
      sheet.getRangeByName('A4').number = 952;
      sheet.getRangeByName('A5').number = 770;
      sheet.getRangeByName('A6').number = 621;
      sheet.getRangeByName('A7').number = 1311;
      sheet.getRangeByName('A8').number = 730;

      final ConditionalFormats conditionalFormats =
          sheet.getRangeByName('A1:A8').conditionalFormats;
      final ConditionalFormat conditionalFormat =
          conditionalFormats.addCondition();

      conditionalFormat.formatType = ExcelCFType.dataBar;
      final DataBar dataBar = conditionalFormat.dataBar!;

      dataBar.minPoint.type = ConditionValueType.lowestValue;
      dataBar.maxPoint.type = ConditionValueType.highestValue;

      dataBar.barColor = '#9CD0F3';

      dataBar.showValue = false;

      // Conditional Formats for color scale
      final Worksheet sheet2 = workbook.worksheets[1];

      sheet2.getRangeByName('A1').number = 12;
      sheet2.getRangeByName('A2').number = 29;
      sheet2.getRangeByName('A3').number = 41;
      sheet2.getRangeByName('A4').number = 84;
      sheet2.getRangeByName('A5').number = 90;
      sheet2.getRangeByName('A6').number = 112;
      sheet2.getRangeByName('A7').number = 131;
      sheet2.getRangeByName('A8').number = 20;
      sheet2.getRangeByName('A9').number = 54;
      sheet2.getRangeByName('A10').number = 63;

      final ConditionalFormats conditionalFormats2 =
          sheet2.getRangeByName('A1:A10').conditionalFormats;
      final ConditionalFormat conditionalFormat2 =
          conditionalFormats2.addCondition();

      conditionalFormat2.formatType = ExcelCFType.colorScale;
      final ColorScale colorScale = conditionalFormat2.colorScale!;

      colorScale.setConditionCount(2);
      colorScale.criteria[0].formatColor = '#63BE7B';
      colorScale.criteria[0].type = ConditionValueType.lowestValue;

      colorScale.criteria[1].formatColor = '#FFEF9C';
      colorScale.criteria[1].type = ConditionValueType.highestValue;

      // Conditional Formats for icon set
      final Worksheet sheet3 = workbook.worksheets[2];

      sheet3.getRangeByName('A1').number = 98;
      sheet3.getRangeByName('A2').number = 89;
      sheet3.getRangeByName('A3').number = 13;
      sheet3.getRangeByName('A4').number = 78;
      sheet3.getRangeByName('A5').number = 68;
      sheet3.getRangeByName('A6').number = 47;
      sheet3.getRangeByName('A7').number = 34;
      sheet3.getRangeByName('A8').number = 21;
      sheet3.getRangeByName('A9').number = 53;
      sheet3.getRangeByName('A10').number = 08;

      final ConditionalFormats conditions =
          sheet3.getRangeByName('A1:A10').conditionalFormats;
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

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ConditionalFormatsAsync.xlsx');
      workbook.dispose();
    });
    test('Excel BuildInStyle Async', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      // Good, Bad, and Neutral
      final Range range1 = sheet.getRangeByIndex(1, 1);
      range1.number = 4;
      range1.builtInStyle = BuiltInStyles.bad;

      final Range range2 = sheet.getRangeByName('A2');
      range2.text = 'M';
      range2.builtInStyle = BuiltInStyles.good;

      final Range range3 = sheet.getRangeByName('A3');
      range3.text = 'Zee';
      range3.builtInStyle = BuiltInStyles.neutral;
      // Excel BuildInStyle NumberFormat
      final Range range4 = sheet.getRangeByName('B1');
      range4.number = 44;
      range4.builtInStyle = BuiltInStyles.comma0;

      final Range range5 = sheet.getRangeByName('B2');
      range5.number = 444;
      range5.builtInStyle = BuiltInStyles.currency;

      final Range range6 = sheet.getRangeByName('B3');
      range6.number = 4444;
      range6.builtInStyle = BuiltInStyles.currency0;

      final Range range7 = sheet.getRangeByName('B4');
      range7.number = 4;
      range7.builtInStyle = BuiltInStyles.percent;
      // Data and Model
      final Range range8 = sheet.getRangeByIndex(1, 3);
      range8.number = 22;
      range8.builtInStyle = BuiltInStyles.calculation;

      final Range range9 = sheet.getRangeByName('C2');
      range9.text = 'Hai';
      range9.builtInStyle = BuiltInStyles.checkCell;

      final Range range10 = sheet.getRangeByName('C3');
      range10.text = 'Jumbo';
      range10.builtInStyle = BuiltInStyles.explanatoryText;

      final Range range11 = sheet.getRangeByIndex(4, 3);
      range11.number = 44;
      range11.builtInStyle = BuiltInStyles.input;

      final Range range12 = sheet.getRangeByIndex(5, 3);
      range12.text = 'MJ';
      range12.builtInStyle = BuiltInStyles.linkedCell;

      final Range range13 = sheet.getRangeByIndex(6, 3);
      range13.setNumber(-40);
      range13.builtInStyle = BuiltInStyles.note;

      final Range range14 = sheet.getRangeByIndex(7, 3);
      range14.setText('zeee');
      range14.builtInStyle = BuiltInStyles.output;

      final Range range15 = sheet.getRangeByIndex(8, 3);
      range15.text = 'Wrong!';
      range15.builtInStyle = BuiltInStyles.warningText;
      // Titles and Heading
      final Range range16 = sheet.getRangeByIndex(1, 4);
      range16.text = 'Time';
      range16.builtInStyle = BuiltInStyles.heading1;

      final Range range17 = sheet.getRangeByName('D2');
      range17.text = 'POWER';
      range17.builtInStyle = BuiltInStyles.heading2;

      final Range range18 = sheet.getRangeByName('D3');
      range18.text = 'TriAngle';
      range18.builtInStyle = BuiltInStyles.heading3;

      final Range range19 = sheet.getRangeByIndex(4, 4);
      range19.number = 1000;
      range19.builtInStyle = BuiltInStyles.heading4;

      final Range range20 = sheet.getRangeByIndex(5, 4);
      range20.text = 'Man';
      range20.builtInStyle = BuiltInStyles.title;

      final Range range21 = sheet.getRangeByIndex(6, 4);
      range21.setNumber(200);
      range21.builtInStyle = BuiltInStyles.total;

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelBuildInStyleAsync.xlsx');
      workbook.dispose();
    });
    test('Freezepane Async', () async {
      //Creating a workbook.
      final Workbook workbook = Workbook(0);
      //Adding a Sheet with name to workbook.
      final Worksheet sheet = workbook.worksheets.addWithName('Table');

      //Load data
      sheet.getRangeByName('A1').setText('Products');
      sheet.getRangeByName('B1').setText('Qtr1');
      sheet.getRangeByName('C1').setText('Qtr2');
      sheet.getRangeByName('D1').setText('Qtr3');
      sheet.getRangeByName('E1').setText('Qtr4');

      sheet.getRangeByName('A2').setText('Phone Holder');
      sheet.getRangeByName('B2').setNumber(744.6);
      sheet.getRangeByName('C2').setNumber(162.56);
      sheet.getRangeByName('D2').setNumber(5079.6);
      sheet.getRangeByName('E2').setNumber(1249.2);

      sheet.getRangeByName('A3').setText('Digital Picture Frame');
      sheet.getRangeByName('B3').setNumber(5079.6);
      sheet.getRangeByName('C3').setNumber(1249.2);
      sheet.getRangeByName('D3').setNumber(943.89);
      sheet.getRangeByName('E3').setNumber(349.6);

      sheet.getRangeByName('A4').setText('USB Charging Cable');
      sheet.getRangeByName('B4').setNumber(1267.5);
      sheet.getRangeByName('C4').setNumber(1062.5);
      sheet.getRangeByName('D4').setNumber(744.6);
      sheet.getRangeByName('E4').setNumber(162.56);

      sheet.getRangeByName('A5').setText('Selfie Stick Tripod');
      sheet.getRangeByName('B5').setNumber(1418);
      sheet.getRangeByName('C5').setNumber(756);
      sheet.getRangeByName('D5').setNumber(1267.5);
      sheet.getRangeByName('E5').setNumber(1062.5);

      sheet.getRangeByName('A6').setText('MicroSD Card');
      sheet.getRangeByName('B6').setNumber(4728);
      sheet.getRangeByName('C6').setNumber(4547.92);
      sheet.getRangeByName('D6').setNumber(1418);
      sheet.getRangeByName('E6').setNumber(756);

      sheet.getRangeByName('A7').setText('HDMI Cable');
      sheet.getRangeByName('B7').setNumber(943.89);
      sheet.getRangeByName('C7').setNumber(349.6);
      sheet.getRangeByName('D7').setNumber(4728);
      sheet.getRangeByName('E7').setNumber(4547.92);

      sheet.getRangeByName('A8').setText('Key Finder');
      sheet.getRangeByName('B8').setNumber(149.33);
      sheet.getRangeByName('C8').setNumber(642.04);
      sheet.getRangeByName('D8').setNumber(1249.83);
      sheet.getRangeByName('E8').setNumber(7850.1);

      sheet.getRangeByName('A9').setText('Light Stand');
      sheet.getRangeByName('B9').setNumber(6534.22);
      sheet.getRangeByName('C9').setNumber(3201.95);
      sheet.getRangeByName('D9').setNumber(1002.25);
      sheet.getRangeByName('E9').setNumber(124.60);

      sheet.getRangeByName('A10').setText('External Hard Drive');
      sheet.getRangeByName('B10').setNumber(245.45);
      sheet.getRangeByName('C10').setNumber(955.2);
      sheet.getRangeByName('D10').setNumber(4655.99);
      sheet.getRangeByName('E10').setNumber(8745.45);

      sheet.getRangeByName('A11').setText('Laptop');
      sheet.getRangeByName('B11').setNumber(450.105);
      sheet.getRangeByName('C11').setNumber(1049.54);
      sheet.getRangeByName('D11').setNumber(1248.35);
      sheet.getRangeByName('E11').setNumber(204.1);

      sheet.getRangeByName('A12').setText('Graphic Card');
      sheet.getRangeByName('B12').setNumber(764.77);
      sheet.getRangeByName('C12').setNumber(955.2);
      sheet.getRangeByName('D12').setNumber(100.4);
      sheet.getRangeByName('E12').setNumber(8383.9);

      sheet.getRangeByName('A13').setText('Keyboard');
      sheet.getRangeByName('B13').setNumber(943.89);
      sheet.getRangeByName('C13').setNumber(349.6);
      sheet.getRangeByName('D13').setNumber(4728);
      sheet.getRangeByName('E13').setNumber(4547.92);

      sheet.getRangeByName('A14').setText('Mouse');
      sheet.getRangeByName('B14').setNumber(234.33);
      sheet.getRangeByName('C14').setNumber(982.6);
      sheet.getRangeByName('D14').setNumber(719.7);
      sheet.getRangeByName('E14').setNumber(7249);

      sheet.getRangeByName('A15').setText('Webcam');
      sheet.getRangeByName('B15').setNumber(749.11);
      sheet.getRangeByName('C15').setNumber(349.2);
      sheet.getRangeByName('D15').setNumber(743.09);
      sheet.getRangeByName('E15').setNumber(564.97);

      sheet.getRangeByName('A16').setText('eBook Reader');
      sheet.getRangeByName('B16').setNumber(3217.04);
      sheet.getRangeByName('C16').setNumber(652.5);
      sheet.getRangeByName('D16').setNumber(842.6);
      sheet.getRangeByName('E16').setNumber(242.56);

      sheet.getRangeByName('A17').setText('GPS Navigator');
      sheet.getRangeByName('B17').setNumber(843.5);
      sheet.getRangeByName('C17').setNumber(619.3);
      sheet.getRangeByName('D17').setNumber(167.56);
      sheet.getRangeByName('E17').setNumber(189.5);

      sheet.getRangeByName('A18').setText('Monitor');
      sheet.getRangeByName('B18').setNumber(952.8);
      sheet.getRangeByName('C18').setNumber(4547);
      sheet.getRangeByName('D18').setNumber(1418);
      sheet.getRangeByName('E18').setNumber(756);

      sheet.getRangeByName('A19').setText('Laptop Stand');
      sheet.getRangeByName('B19').setNumber(413.89);
      sheet.getRangeByName('C19').setNumber(349.6);
      sheet.getRangeByName('D19').setNumber(4728);
      sheet.getRangeByName('E19').setNumber(4547.92);

      sheet.getRangeByName('A20').setText('Smartwatch');
      sheet.getRangeByName('B20').setNumber(948.07);
      sheet.getRangeByName('C20').setNumber(642.04);
      sheet.getRangeByName('D20').setNumber(1249.83);
      sheet.getRangeByName('E20').setNumber(7850.1);

      sheet.getRangeByName('A21').setText('Bluetooth Earphones');
      sheet.getRangeByName('B21').setNumber(1134);
      sheet.getRangeByName('C21').setNumber(3201.95);
      sheet.getRangeByName('D21').setNumber(1002.25);
      sheet.getRangeByName('E21').setNumber(124.60);

      sheet.getRangeByName('A22').setText('Reader Case');
      sheet.getRangeByName('B22').setNumber(865.76);
      sheet.getRangeByName('C22').setNumber(955.2);
      sheet.getRangeByName('D22').setNumber(4655.99);
      sheet.getRangeByName('E22').setNumber(8745.45);

      sheet.getRangeByName('A23').setText('Smart Glass');
      sheet.getRangeByName('B23').setNumber(1450.5);
      sheet.getRangeByName('C23').setNumber(1049.54);
      sheet.getRangeByName('D23').setNumber(1248.35);
      sheet.getRangeByName('E23').setNumber(204.1);

      sheet.getRangeByName('A24').setText('Remote Controller');
      sheet.getRangeByName('B24').setNumber(877.75);
      sheet.getRangeByName('C24').setNumber(955.2);
      sheet.getRangeByName('D24').setNumber(100.4);
      sheet.getRangeByName('E24').setNumber(8383.9);

      sheet.getRangeByName('A25').setText('Game Console');
      sheet.getRangeByName('B25').setNumber(343.89);
      sheet.getRangeByName('C25').setNumber(349.6);
      sheet.getRangeByName('D25').setNumber(4728);
      sheet.getRangeByName('E25').setNumber(447.92);

      ///Create a table with the data in a range
      final ExcelTable table = sheet.tableCollection
          .create('Table1', sheet.getRangeByName('A1:E25'));

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

      final Range range = sheet.getRangeByName('B2:E26');
      range.numberFormat = r'_($* #,##0.00_)';

      sheet.getRangeByName('A1:E25').autoFitColumns();
      //Freezepane
      sheet.getRangeByName('A2').freezePanes();

      //Save and dispose Workbook
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'FreezepaneAsync.xlsx');
      workbook.dispose();
    });
    test('Excel PageSetup Async', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Style style = workbook.styles.add('style');
      style.fontColor = '#C67878';
      final Range range = sheet.getRangeByName('A1:D4');
      range.text = 'BlackWhite';
      range.cellStyle = style;
      // Blackandwhite
      sheet.pageSetup.isBlackAndWhite = true;
      // grid line
      sheet.pageSetup.showGridlines = true;
      // Print headings
      sheet.pageSetup.showHeadings = true;
      // Center Horizontally and center Vertically
      sheet.pageSetup.isCenterHorizontally = true;
      sheet.pageSetup.isCenterVertically = true;
      // landscape
      sheet.pageSetup.orientation = ExcelPageOrientation.landscape;

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'PageSetupAsync.xlsx');
      workbook.dispose();
    });
    test('Excel Named range Async', () async {
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
      // Formula
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

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'NamedRangeAsync.xlsx');
      workbook.dispose();
    });
    test('Excel Text async', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      range.text = 'M\nM';
      final Range range1 = sheet.getRangeByName('A2');
      range1.text = 'M\tJ';
      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.text = '--';
      final Range range3 = sheet.getRangeByName('A4');
      range3.text = '#';
      final Range range4 = sheet.getRangeByName('A5');
      range4.text = '|';
      final Range range5 = sheet.getRangeByIndex(6, 1);
      range5.text = r'\\';
      final Range range6 = sheet.getRangeByIndex(7, 1);
      range6.text = "'";
      final Range range7 = sheet.getRangeByName('A8');
      range7.text = '@';
      final Range range8 = sheet.getRangeByIndex(9, 1);
      range8.text = '!';
      final Range range9 = sheet.getRangeByName('A10');
      range9.text = r'$';
      final Range range10 = sheet.getRangeByName('A11');
      range10.text = '%';
      final Range range11 = sheet.getRangeByIndex(12, 1);
      range11.text = '^';
      final Range range12 = sheet.getRangeByName('A13');
      range12.text = '&';
      final Range range13 = sheet.getRangeByIndex(14, 1);
      range13.text = '*';
      final Range range14 = sheet.getRangeByName('A15');
      range14.text = '(';
      final Range range15 = sheet.getRangeByIndex(16, 1);
      range15.text = ')';
      final Range range16 = sheet.getRangeByIndex(17, 1);
      range16.text = '+';
      final Range range17 = sheet.getRangeByName('A18');
      range17.text = '}';
      final Range range18 = sheet.getRangeByIndex(19, 1);
      range18.text = ']';
      final Range range19 = sheet.getRangeByName('A20');
      range19.text = '{';
      final Range range20 = sheet.getRangeByName('A21');
      range20.text = '[';
      final Range range21 = sheet.getRangeByIndex(22, 1);
      range21.text = '"';
      final Range range22 = sheet.getRangeByName('A23');
      range22.text = ':';
      final Range range23 = sheet.getRangeByIndex(24, 1);
      range23.text = ';';
      final Range range24 = sheet.getRangeByName('A25');
      range24.text = '?';
      final Range range25 = sheet.getRangeByIndex(26, 1);
      range25.text = '/';
      final Range range26 = sheet.getRangeByIndex(27, 1);
      range26.text = '>';
      final Range range27 = sheet.getRangeByName('A28');
      range27.text = '.';
      final Range range28 = sheet.getRangeByIndex(29, 1);
      range28.text = '<';
      final Range range29 = sheet.getRangeByName('A30');
      range29.text = ',';
      final Range range30 = sheet.getRangeByName('A31');
      range30.text = '`';
      final Range range31 = sheet.getRangeByName('A32');
      range31.text = '~';
      final Range range32 = sheet.getRangeByIndex(33, 1);
      range32.text = '=';
      final Range range33 = sheet.getRangeByName('A34');
      range33.text = '_';
      final Range range34 = sheet.getRangeByName('A35');
      range34.text = '0';
      final Range range35 = sheet.getRangeByIndex(36, 1);
      range35.text = '4';
      final Range range36 = sheet.getRangeByIndex(37, 1);
      range36.text = '44';
      final Range range37 = sheet.getRangeByName('A38');
      range37.text = '444';
      final Range range38 = sheet.getRangeByIndex(39, 1);
      range38.text = 'a';
      final Range range39 = sheet.getRangeByName('A40');
      range39.text = 'b';
      final Range range40 = sheet.getRangeByName('A41');
      range40.text = 'c';
      final Range range41 = sheet.getRangeByName('A42');
      range41.text = 'd';
      final Range range42 = sheet.getRangeByIndex(43, 1);
      range42.text = 'e';
      final Range range43 = sheet.getRangeByName('A44');
      range43.text = 'f';
      final Range range44 = sheet.getRangeByName('A45');
      range44.text = 'g';
      final Range range45 = sheet.getRangeByIndex(46, 1);
      range45.text = 'h';
      final Range range46 = sheet.getRangeByIndex(47, 1);
      range46.text = 'i';
      final Range range47 = sheet.getRangeByName('A48');
      range47.text = 'j';
      final Range range48 = sheet.getRangeByIndex(49, 1);
      range48.text = 'k';
      final Range range49 = sheet.getRangeByName('A50');
      range49.text = 'l';
      final Range range50 = sheet.getRangeByName('A51');
      range50.text = 'm';
      final Range range51 = sheet.getRangeByName('A52');
      range51.text = 'n';
      final Range range52 = sheet.getRangeByIndex(53, 1);
      range52.text = 'o';
      final Range range53 = sheet.getRangeByName('A54');
      range53.text = 'p';
      final Range range54 = sheet.getRangeByName('A55');
      range54.text = 'q';
      final Range range55 = sheet.getRangeByIndex(56, 1);
      range55.text = 'r';
      final Range range56 = sheet.getRangeByIndex(57, 1);
      range56.text = 's';
      final Range range57 = sheet.getRangeByName('A58');
      range57.text = 't';
      final Range range58 = sheet.getRangeByIndex(59, 1);
      range58.text = 'u';
      final Range range59 = sheet.getRangeByName('A60');
      range59.text = 'v';
      final Range range60 = sheet.getRangeByName('A61');
      range60.text = 'w';
      final Range range61 = sheet.getRangeByName('A62');
      range61.text = 'x';
      final Range range62 = sheet.getRangeByIndex(63, 1);
      range62.text = 'y';
      final Range range63 = sheet.getRangeByName('A64');
      range63.text = 'z';
      final Range range64 = sheet.getRangeByName('A65');
      range64.text = 'A';
      final Range range65 = sheet.getRangeByIndex(66, 1);
      range65.text = 'B';
      final Range range66 = sheet.getRangeByIndex(67, 1);
      range66.text = 'C';
      final Range range67 = sheet.getRangeByName('A68');
      range67.text = 'D';
      final Range range68 = sheet.getRangeByIndex(69, 1);
      range68.text = 'E';
      final Range range69 = sheet.getRangeByName('A70');
      range69.text = 'F';
      final Range range70 = sheet.getRangeByName('A71');
      range70.text = 'G';
      final Range range71 = sheet.getRangeByName('A72');
      range71.text = 'H';
      final Range range72 = sheet.getRangeByIndex(73, 1);
      range72.text = 'I';
      final Range range73 = sheet.getRangeByName('A74');
      range73.text = 'J';
      final Range range74 = sheet.getRangeByName('A75');
      range74.text = 'K';
      final Range range75 = sheet.getRangeByIndex(76, 1);
      range75.text = 'L';
      final Range range76 = sheet.getRangeByIndex(77, 1);
      range76.text = 'M';
      final Range range77 = sheet.getRangeByName('A78');
      range77.text = 'N';
      final Range range78 = sheet.getRangeByIndex(79, 1);
      range78.text = 'O';
      final Range range79 = sheet.getRangeByName('A80');
      range79.text = 'P';
      final Range range80 = sheet.getRangeByName('A81');
      range80.text = 'Q';
      final Range range81 = sheet.getRangeByName('A82');
      range81.text = 'R';
      final Range range82 = sheet.getRangeByIndex(83, 1);
      range82.text = 'S';
      final Range range83 = sheet.getRangeByName('A84');
      range83.text = 'T';
      final Range range84 = sheet.getRangeByName('A85');
      range84.text = 'U';
      final Range range85 = sheet.getRangeByIndex(86, 1);
      range85.text = 'V';
      final Range range86 = sheet.getRangeByIndex(87, 1);
      range86.text = 'W';
      final Range range87 = sheet.getRangeByName('A88');
      range87.text = 'X';
      final Range range88 = sheet.getRangeByIndex(89, 1);
      range88.text = 'Y';
      final Range range89 = sheet.getRangeByName('A90');
      range89.text = 'Z';
      final Range range90 = sheet.getRangeByName('A91');
      range90.text = '0';
      final Range range91 = sheet.getRangeByName('A92');
      range91.text = '1';
      final Range range92 = sheet.getRangeByIndex(93, 1);
      range92.text = '2';
      final Range range93 = sheet.getRangeByName('A94');
      range93.text = '3';
      final Range range94 = sheet.getRangeByName('A95');
      range94.text = '4';
      final Range range95 = sheet.getRangeByIndex(96, 1);
      range95.text = '5';
      final Range range96 = sheet.getRangeByIndex(97, 1);
      range96.text = '6';
      final Range range97 = sheet.getRangeByName('A98');
      range97.text = '7';
      final Range range98 = sheet.getRangeByIndex(99, 1);
      range98.text = '8';
      final Range range99 = sheet.getRangeByName('A100');
      range99.text = '9';
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'TextAsync.xlsx');
      workbook.dispose();
    });
    test('Excel Number Async', () async {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[1];
      // number for single range
      final Range range = sheet.getRangeByIndex(1, 1);
      range.number = -100;
      // number for multiple range
      final Range range1 = sheet.getRangeByIndex(2, 1, 2, 2);
      range1.number = 26;
      // number with Name Index
      final Range range2 = sheet.getRangeByName('A3');
      range2.number = 100000;
      // number for Multiple final Range with Name Index
      final Range range3 = sheet.getRangeByName('A4:C4');
      range3.number = -1000;
      // number for single range
      final Range range4 = sheet.getRangeByIndex(1, 1);
      range4.setNumber(-10);
      // number for multiple range
      final Range range5 = sheet.getRangeByIndex(2, 1, 2, 2);
      range5.setNumber(26);
      // number with Name Index
      final Range range6 = sheet.getRangeByName('A3');
      range6.setNumber(100000);
      // number for Multiple final Range with Name Index
      final Range range7 = sheet.getRangeByName('A4:C4');
      range7.setNumber(-1000);
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'NumberAsync.xlsx');
      workbook.dispose();
    });
    test('Excel DateTime Async', () async {
      final Workbook workbook = Workbook(2);
      final Worksheet sheet = workbook.worksheets[0];
      // setDateTime() for single and Multiple Range
      final Range range = sheet.getRangeByIndex(1, 1);
      range.setDateTime(DateTime(2004, 12, 24, 18, 30, 50));
      final Range range1 = sheet.getRangeByIndex(4, 1, 4, 4);
      range1.setDateTime(DateTime(1990, 3, 25, 16, 50, 40));
      final Range range2 = sheet.getRangeByName('J15:M20');
      range2.setDateTime(DateTime.now());
      final Range range3 = sheet.getRangeByName('O2:R6');
      range3.setDateTime(DateTime(2002, 5, 5, 22, 49, 20));
      // dateTime() for single and Multiple Range
      final Range range4 = sheet.getRangeByIndex(2, 1);
      range4.dateTime = DateTime(2011, 1, 20, 20, 37, 80);
      final Range range5 = sheet.getRangeByIndex(3, 1, 3, 4);
      range5.dateTime = DateTime(1999, 6, 5, 6, 0, 40);
      final Range range6 = sheet.getRangeByName('K20:N30');
      range6.dateTime = DateTime.now();
      final Range range7 = sheet.getRangeByName('S12:V16');
      range7.dateTime = DateTime(2323, 10, 15, 2, 9);

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelDateTimeAsync.xlsx');
      workbook.dispose();
    });
    test('Excel DisplayText Async', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      range.numberFormat = 'h:mm:ss AM/PM';
      range.setDateTime(DateTime(2020, 8, 23, 10, 15, 20));
      // ignore: unused_local_variable
      String text = range.displayText;
      final Range range1 = sheet.getRangeByIndex(1, 2);
      range1.numberFormat = 'h:mm';
      range1.setDateTime(DateTime(2020, 08, 23, 8, 15, 20));
      text = range1.displayText;
      final Range range2 = sheet.getRangeByIndex(1, 3);
      range2.numberFormat = 'mm:ss.0';
      range2.setDateTime(DateTime(2020, 08, 23, 8, 15, 20));
      text = range2.displayText;
      final Range range3 = sheet.getRangeByIndex(1, 4);
      range3.numberFormat = '[h]:mm:ss';
      range3.setDateTime(DateTime(2020, 08, 23, 8, 15, 20));
      text = range3.displayText;
      final Range range4 = sheet.getRangeByIndex(1, 5);
      range4.numberFormat = 'h.mm';
      range4.setDateTime(DateTime(2011, 04, 04, 12, 47, 6));
      text = range4.displayText;
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'DisplayTextAsync.xlsx');
      workbook.dispose();
    });
    test('Excel NumberFormat Async', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range1 = sheet.getRangeByName('A1');
      range1.number = 100;
      range1.numberFormat = '0';

      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.number = 10;
      range2.numberFormat = '0.00';

      final Range range3 = sheet.getRangeByName('A5');
      range3.number = 44;
      range3.numberFormat = '#,##0';

      final Range range4 = sheet.getRangeByIndex(17, 1);
      range4.number = 1;
      range4.numberFormat = '#,##0.00';

      final Range range5 = sheet.getRangeByName('A7');
      range5.number = 4.00;
      range5.numberFormat = '#,##0';

      final Range range6 = sheet.getRangeByIndex(9, 1);
      range6.number = 16;
      range6.numberFormat = r"'$'#,##0_)";

      final Range range7 = sheet.getRangeByName('A11');
      range7.number = 22;
      range7.numberFormat = r"\('$'#,##0\)";

      final Range range8 = sheet.getRangeByIndex(13, 1);
      range8.number = -33;
      range8.numberFormat = r"'$'#,##0_)";

      final Range range9 = sheet.getRangeByName('A15');
      range9.number = 2.20;
      range9.numberFormat = r"[Red]\('$'#,##0\)";

      final Range range10 = sheet.getRangeByIndex(1, 3);
      range10.number = -64;
      range10.numberFormat = r"'$'#,##0.00_)";

      final Range range11 = sheet.getRangeByName('C3');
      range11.number = 25;
      range11.numberFormat = r"\('$'#,##0.00\)";

      final Range range12 = sheet.getRangeByIndex(5, 3);
      range12.number = 55;
      range12.numberFormat = r"'$'#,##0.00_)";

      final Range range13 = sheet.getRangeByName('C7');
      range13.number = 30;
      range13.numberFormat = r"[Red]\('$'#,##0.00\)";

      final Range range14 = sheet.getRangeByIndex(9, 3);
      range14.number = 11;
      range14.numberFormat = '0%';

      final Range range15 = sheet.getRangeByName('C11');
      range15.number = 4;
      range15.numberFormat = '0.00%';

      final Range range16 = sheet.getRangeByIndex(13, 3);
      range16.number = 432561;
      range16.numberFormat = '0.00E+00';

      final Range range17 = sheet.getRangeByName('C15');
      range17.number = 38.00;
      range17.numberFormat = '# ?/?';

      final Range range18 = sheet.getRangeByIndex(1, 5);
      range18.number = -33;
      range18.numberFormat = '# ??/??';

      final Range range19 = sheet.getRangeByName('E3');
      range19.dateTime = DateTime(2022, 08, 23, 8, 15, 20);
      range19.numberFormat = r'm/d/yyyy';

      final Range range20 = sheet.getRangeByIndex(5, 5);
      range20.dateTime = DateTime(2024, 01, 03, 18, 45, 60);
      range20.numberFormat = r'd\-mmm\-yy';

      final Range range21 = sheet.getRangeByName('E7');
      range21.dateTime = DateTime(2000, 12, 12);
      range21.numberFormat = r'd\-mmm';

      final Range range22 = sheet.getRangeByIndex(9, 5);
      range22.dateTime = DateTime(2011, 11, 11);
      range22.numberFormat = r'mmm\-yy';

      final Range range23 = sheet.getRangeByName('E11');
      range23.dateTime = DateTime(2120, 08, 09, 10, 11, 12);
      range23.numberFormat = r'h:mm\\ AM/PM';

      final Range range24 = sheet.getRangeByIndex(13, 5);
      range24.dateTime = DateTime(1997, 09, 10, 11, 12, 13);
      range24.numberFormat = r'h:mm:ss\\ AM/PM';

      final Range range25 = sheet.getRangeByName('E15');
      range25.dateTime = DateTime.now();
      range25.numberFormat = 'h:mm';

      final Range range26 = sheet.getRangeByIndex(1, 7);
      range26.dateTime = DateTime(2021, 11, 07, 20, 40, 19);
      range26.numberFormat = 'h:mm:ss';

      final Range range27 = sheet.getRangeByName('G3');
      range27.dateTime = DateTime(2024, 03, 07, 2, 4, 6);
      range27.numberFormat = r'm/d/yyyy\\ h:mm';

      final Range range28 = sheet.getRangeByIndex(5, 7);
      range28.number = -11;
      range28.numberFormat = '#,##0_)';

      final Range range29 = sheet.getRangeByName('G7');
      range29.number = 2.59;
      range29.numberFormat = '(#,##0)';

      final Range range30 = sheet.getRangeByIndex(9, 7);
      range30.number = -39;
      range30.numberFormat = '#,##0_)';

      final Range range31 = sheet.getRangeByName('G11');
      range31.number = 194;
      range31.numberFormat = '[Red](#,##0)';

      final Range range32 = sheet.getRangeByIndex(13, 7);
      range32.number = -10;
      range32.numberFormat = '#,##0.00_)';

      final Range range33 = sheet.getRangeByName('G15');
      range33.number = 54;
      range33.numberFormat = '(#,##0.00)';

      final Range range34 = sheet.getRangeByIndex(1, 9);
      range34.number = 60;
      range34.numberFormat = '#,##0.00_)';

      final Range range35 = sheet.getRangeByName('I3');
      range35.number = 99.9;
      range35.numberFormat = '[Red](#,##0.00)';

      final Range range36 = sheet.getRangeByIndex(5, 9);
      range36.number = 160;
      range36.numberFormat = r'_(* #,##0_)';

      final Range range37 = sheet.getRangeByName('I7');
      range37.number = 37.00;
      range37.numberFormat = r'_(* \\(#,##0\\)';

      final Range range38 = sheet.getRangeByIndex(9, 9);
      range38.number = -3.3;
      range38.numberFormat = r"_(* '-'_)";

      final Range range39 = sheet.getRangeByName('I11');
      range39.number = 763;
      range39.numberFormat = r'_(@_)';

      final Range range40 = sheet.getRangeByIndex(13, 9);
      range40.number = 3828;
      range40.numberFormat = r"_('$'* #,##0_)";

      final Range range41 = sheet.getRangeByName('I15');
      range41.number = 4.40;
      range41.numberFormat = r"_('$'* \(#,##0\)";

      final Range range42 = sheet.getRangeByIndex(1, 11);
      range42.number = 112;
      range42.numberFormat = r"_('$'* '-'_)";

      final Range range43 = sheet.getRangeByName('K3');
      range43.number = 44;
      range43.numberFormat = r'_(@_)';

      final Range range44 = sheet.getRangeByIndex(5, 11);
      range44.number = 29;
      range44.numberFormat = '_(* #,##0.00_)';

      final Range range45 = sheet.getRangeByName('K7');
      range45.number = -231.9;
      range45.numberFormat = r'_(* \\(#,##0.00\\)';

      final Range range46 = sheet.getRangeByIndex(9, 11);
      range46.number = 134;
      range46.numberFormat = r"_(* '-'??_)";

      final Range range47 = sheet.getRangeByName('K11');
      range47.number = 2212;
      range47.numberFormat = r'_(@_)';

      final Range range48 = sheet.getRangeByIndex(13, 11);
      range48.number = -33.6;
      range48.numberFormat = r"_('$'* #,##0.00_)";

      final Range range49 = sheet.getRangeByName('K15');
      range49.number = 25.8;
      range49.numberFormat = r"_('$'* \(#,##0.00\)";

      final Range range50 = sheet.getRangeByIndex(1, 13);
      range50.number = -64.2;
      range50.numberFormat = r"_('$'* '-'??_)";

      final Range range51 = sheet.getRangeByName('M3');
      range51.number = 100;
      range51.numberFormat = r'_(@_)';

      final Range range52 = sheet.getRangeByIndex(5, 13);
      range52.dateTime = DateTime(2008, 08, 08, 8, 8, 8);
      range52.numberFormat = 'mm:ss';

      final Range range53 = sheet.getRangeByName('M7');
      range53.dateTime = DateTime(2019, 09, 09, 9, 19, 9);
      range53.numberFormat = '[h]:mm:ss';

      final Range range54 = sheet.getRangeByIndex(9, 13);
      range54.dateTime = DateTime(2007, 07, 07, 7, 7, 7);
      range54.numberFormat = 'mm:ss.0';

      final Range range55 = sheet.getRangeByName('M11');
      range55.number = 567;
      range55.numberFormat = '##0.0E+0';

      final Range range56 = sheet.getRangeByIndex(13, 13);
      range56.number = 1622;
      range56.numberFormat = '@';

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelNumberFormatAsync.xlsx');
      workbook.dispose();
    });
    test('Excel MergeCells Async', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      // Merge row
      final Range range1 = sheet.getRangeByName('A1:D1');
      range1.number = 10;
      range1.merge();
      // Unmerge row
      final Range range2 = sheet.getRangeByName('E4:H4');
      range2.text = 'M';
      range2.merge();
      range2.unmerge();
      // Merge column
      final Range range3 = sheet.getRangeByIndex(4, 2, 7, 2);
      range3.dateTime = DateTime(1997, 11, 22);
      range3.merge();
      // Unmerge column
      final Range range4 = sheet.getRangeByName('P8:P40');
      range4.number = 55;
      range4.merge();
      range4.unmerge();
      // Merge Rows and columns
      final Range range5 = sheet.getRangeByIndex(1, 7, 8, 10);
      range5.text = 'Helloo';
      range5.merge();
      // Unmerge Rows and columns
      final Range range6 = sheet.getRangeByName('G15:I20');
      range6.dateTime = DateTime(2222, 10, 10);
      range6.merge();
      range6.unmerge();

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelMergeCellAsync.xlsx');
      workbook.dispose();
    });
    test('Excel Cell style async', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      // number formate
      final CellStyle cellStyle1 = CellStyle(workbook);
      cellStyle1.name = 'Style1';
      cellStyle1.numberFormat = '#,##0.00';
      workbook.styles.addStyle(cellStyle1);
      final Range range = sheet.getRangeByName('A1');
      range.number = 10;
      range.cellStyle = cellStyle1;
      // border
      final CellStyle cellStyle2 = CellStyle(workbook);
      cellStyle2.name = 'Style1';
      cellStyle2.borders.all.lineStyle = LineStyle.double;
      cellStyle2.borders.all.color = '#111111';
      workbook.styles.addStyle(cellStyle2);
      final Range range1 = sheet.getRangeByName('A2');
      range1.cellStyle = cellStyle2;
      // font
      final CellStyle cellStyle3 = CellStyle(workbook);
      cellStyle3.name = 'Style1';
      cellStyle3.fontName = 'Comic Sans MS';
      cellStyle3.fontColor = '#839202';
      cellStyle3.fontSize = 11;
      cellStyle3.bold = true;
      cellStyle3.italic = true;
      cellStyle3.underline = true;
      workbook.styles.addStyle(cellStyle3);
      final Range range2 = sheet.getRangeByName('A3');
      range2.text = 'Hello';
      range2.cellStyle = cellStyle3;
      final Range range3 = sheet.getRangeByName('A4');
      range3.number = 1000;
      range3.cellStyle = cellStyle3;
      // alignment
      final CellStyle cellStyle4 = CellStyle(workbook);
      cellStyle4.name = 'Style1';
      cellStyle4.hAlign = HAlignType.center;
      workbook.styles.addStyle(cellStyle4);
      final Range range4 = sheet.getRangeByName('A5');
      range4.text = 'Hi';
      range4.cellStyle = cellStyle4;
      final Range range5 = sheet.getRangeByName('A6');
      range5.number = 10;
      range5.cellStyle = cellStyle4;

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'CellStylesAsync.xlsx');
      workbook.dispose();
    });
    test('Excel tables Async', () async {
      // Create a new Excel Document.
      final Workbook workbook = Workbook(2);

      // Accessing sheet via index.
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[1];

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

      /// Create table with the data in given range
      final ExcelTable table =
          sheet.tableCollection.create('Table1', sheet.getRangeByName('A1:C4'));

      final ExcelTable table1 = sheet1.tableCollection
          .create('Table2', sheet1.getRangeByName('F1:H4'));

      final ExcelTable table2 = sheet.tableCollection
          .create('Table3', sheet.getRangeByName('J8:L11'));

      final ExcelTable table3 = sheet1.tableCollection
          .create('Table4', sheet1.getRangeByName('A6:C9'));

      /// Multiple Sheet with Multiple Table
      /// Formatting table with a built-in style
      table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium15;
      table1.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark10;
      table2.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleDark5;
      table3.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleLight9;

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'TablesAsync.xlsx');
      workbook.dispose();
    });
    test('Excel Formula Async', () async {
      final Workbook workbook = Workbook(1);
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
      final Worksheet sheet2 = workbook.worksheets.add();
      final Worksheet sheet3 = workbook.worksheets.add();
      final Worksheet sheet4 = workbook.worksheets.add();
      sheet2.getRangeByIndex(1, 1).number = 10;
      sheet2.getRangeByIndex(1, 2).number = 20;
      sheet2.enableSheetCalculations();

      sheet3.getRangeByIndex(1, 1).formula = '=Sheet2!A1+Sheet2!B1';
      sheet3.getRangeByIndex(1, 2).formula = '=Sheet2!A1-Sheet2!B1';
      sheet3.getRangeByIndex(1, 3).formula = '=Sheet2!A1*Sheet2!B1';
      sheet3.getRangeByIndex(1, 4).formula = '=Sheet2!A1/Sheet2!B1';

      final Range range1 = sheet4.getRangeByIndex(1, 1);
      range1.formula = '=Sheet3!A1';
      final Range range2 = sheet4.getRangeByIndex(1, 2);
      range2.formula = '=Sheet3!B1';
      final Range range3 = sheet4.getRangeByIndex(1, 3);
      range3.formula = '=Sheet3!C1';
      final Range range4 = sheet4.getRangeByIndex(1, 4);
      range4.formula = '=Sheet3!D1';
      final Range range5 = sheet4.getRangeByIndex(1, 5);
      range5.formula = '=SUM(Sheet3!A1:A2)';

      final Worksheet sheet5 = workbook.worksheets.add();
      sheet5.getRangeByIndex(1, 1).number = 10;
      sheet5.getRangeByIndex(1, 2).number = 20;
      sheet5.getRangeByIndex(1, 3).number = 12;
      sheet5.getRangeByIndex(2, 1).number = 23;
      sheet5.getRangeByIndex(2, 2).number = 43;
      sheet5.getRangeByIndex(2, 3).number = 31;
      sheet5.getRangeByIndex(3, 1).number = 25;
      sheet5.getRangeByIndex(3, 2).number = 52;
      sheet5.getRangeByIndex(3, 3).number = 23;
      sheet5.getRangeByIndex(4, 1).number = 41;
      sheet5.getRangeByIndex(4, 2).number = 75;
      sheet5.getRangeByIndex(4, 3).number = 54;

      sheet5.enableSheetCalculations();

      Range range6 = sheet5.getRangeByName('A6');
      range6.formula = '=B1-A1';
      expect('10.0', range6.calculatedValue);
      range6 = sheet5.getRangeByName('A7');
      range6.formula = '=C1*B1';
      expect('240.0', range6.calculatedValue);
      range6 = sheet5.getRangeByName('A8');
      range6.formula = '=B3/B2';
      expect('1.2093023255813953', range6.calculatedValue);
      range6 = sheet5.getRangeByName('A9');
      range6.formula = '=B2>A1';
      expect('TRUE', range6.calculatedValue);
      range6 = sheet5.getRangeByName('A10');
      range6.formula = '=B3<A2';
      expect('FALSE', range6.calculatedValue);
      range6 = sheet5.getRangeByName('A11');
      range6.formula = '=C1>=A3';
      expect('FALSE', range6.calculatedValue);
      range6 = sheet5.getRangeByName('B6');
      range6.formula = '=C3<=A4';
      expect('FALSE', range6.calculatedValue);
      range6 = sheet5.getRangeByName('B7');
      range6.formula = '=C3=A2';
      expect('TRUE', range6.calculatedValue);
      range6 = sheet5.getRangeByName('B8');
      range6.formula = '=A2<>B2';
      expect('TRUE', range6.calculatedValue);
      range6 = sheet5.getRangeByName('B9');
      range6.formula = '=-A1';
      expect('-10.0', range6.calculatedValue);
      range6 = sheet5.getRangeByName('B10');
      range6.formula = '=B4^3';
      expect('421875.0', range6.calculatedValue);
      range6 = sheet5.getRangeByName('B11');
      range6.formula = '=(A1+B1)*(B1-A1)';
      expect('300.0', range6.calculatedValue);
      range6 = sheet5.getRangeByName('B12');
      range6.formula = '=A1&" "&B1';
      expect('10.0 20.0', range6.calculatedValue);

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelFormulaAsync.xlsx');
      workbook.dispose();
    });
    test('Excel Culture Async', () async {
      final Workbook workbook = Workbook.withCulture('en-IN');
      final Worksheet sheet = workbook.worksheets[0];

      final Range range1 = sheet.getRangeByIndex(2, 2);
      range1.numberFormat = r'm/d/yyyy';
      range1.dateTime = DateTime(2021, 12, 22);
      range1.displayText;

      final Range range2 = sheet.getRangeByIndex(4, 4);
      range2.numberFormat = 'dd MMMM yyyy';
      range2.dateTime = DateTime(2022, 11, 21);
      range2.displayText;

      final Worksheet sheet2 = workbook.worksheets.add();

      final Range range3 = sheet2.getRangeByIndex(2, 2);
      range3.numberFormat = 'h:mm';
      range3.dateTime = DateTime(2021, 12, 22, 22, 22, 22);
      range3.displayText;

      final Range range4 = sheet2.getRangeByIndex(4, 4);
      range4.numberFormat = 'h:mm:ss';
      range4.dateTime = DateTime(2022, 11, 21, 21, 21, 21);
      range4.displayText;

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelCultureAsync.xlsx');
      workbook.dispose();
    });
    test('Excel Image Async', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Picture picture1 = sheet.pictures.addBase64(1, 2, image24png);
      picture1.rotation = 60;

      final Picture picture2 = sheet.pictures.addBase64(10, 10, image6png);
      picture2.row = 20;
      picture2.lastRow = 25;
      picture2.column = 15;
      picture2.lastColumn = 20;

      final Picture picture3 = sheet.pictures.addBase64(1, 15, image16jpg);
      picture3.height = 300;
      picture3.width = 500;

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelImageAsync.xlsx');
      workbook.dispose();
    });
    test('multiple sheets', () async {
      final Workbook workbook = Workbook(2);

      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      final Range range1 = sheet.getRangeByIndex(10, 10);
      sheet.hyperlinks.add(range1, HyperlinkType.url, 'http://www.google.com');
      sheet.hyperlinks.add(sheet.getRangeByName('J16'), HyperlinkType.url,
          'http://www.gmail.com');
      final Hyperlink link1 = sheet.hyperlinks.add(sheet.getRangeByName('G16'),
          HyperlinkType.url, 'http://www.gmail.com');
      link1.screenTip = 'login here';

      final Worksheet sheet1 = workbook.worksheets[1];
      sheet1.hyperlinks.add(sheet1.getRangeByIndex(2, 10), HyperlinkType.url,
          'http://www.fb.com');
      sheet1.hyperlinks.add(sheet1.getRangeByName('D16'), HyperlinkType.url,
          'http://www.yahoo.com');

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelHyperlinkMultipleSheet.xlsx');
    });
    test('Excel AutoFit Async', () async {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      // Range AutoFitColumn
      Range range = sheet.getRangeByName('A1');
      range.setText('Test for AutoFit Column');
      range = sheet.getRangeByName('A2');
      range.setText(
          'WrapText WrapText WrapText WrapText WrapText WrapText WrapText');

      sheet.getRangeByName('A1:A2').autoFitColumns();
      // Range AutoFitRow
      Range range2 = sheet.getRangeByName('C1');
      range2.setText('Test for AutoFit Row');
      range2.cellStyle.fontSize = 15;
      range2 = sheet.getRangeByName('C2');
      range2.setText(
          'WrapText WrapText WrapText WrapText WrapText WrapText WrapText');
      range2.cellStyle.wrapText = true;

      sheet.getRangeByName('C1:C2').autoFitRows();
      // Range Autofit
      Range range3 = sheet.getRangeByName('F1');
      range3.setText('WrapText WrapText WrapText WrapText WrapText WrapText');
      range3.cellStyle.wrapText = true;
      range3 = sheet.getRangeByName('F2');
      range3.setText('Test for AutoFit Text');
      range3.cellStyle.fontSize = 15;

      range3 = sheet.getRangeByName('G1');
      range3.setText('WrapText WrapText WrapText WrapText WrapText WrapText');
      range3 = sheet.getRangeByName('G2');
      range3.setText('Test for AutoFit Text');
      range3.cellStyle.fontSize = 15;

      sheet.getRangeByName('F1:G2').autoFit();

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelAutoFitAsync.xlsx');
      workbook.dispose();
    });
    test('Excel Image Hyperlink Async', () async {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      Hyperlink link = sheet.hyperlinks.add(sheet.getRangeByIndex(3, 10),
          HyperlinkType.url, 'http://www.fb.com', 'Fb login');
      link.textToDisplay = 'FaceBook';
      final Picture picture1 = sheet.pictures.addBase64(1, 1, image14png);
      link = sheet.hyperlinks
          .addImage(picture1, HyperlinkType.url, 'http://www.syncfusion.com');
      link = sheet.hyperlinks.add(
          sheet.getRangeByIndex(1, 4), HyperlinkType.workbook, 'Sheet1!R5');

      final Picture picture2 = sheet.pictures.addBase64(10, 10, image24png);
      link = sheet.hyperlinks
          .addImage(picture2, HyperlinkType.url, 'http://www.gmail.com');
      sheet.pictures.addBase64(30, 3, image10jpg);
      sheet.pictures.addBase64(40, 15, image16jpg);
      final Picture picture5 = sheet.pictures.addBase64(50, 25, image18jpg);
      sheet.hyperlinks
          .addImage(picture5, HyperlinkType.url, 'http://www.fb.com');
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'ExcelImageHyperlinkAsync.xlsx');
      workbook.dispose();
    });
  });
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

    test('Invoice', () async {
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

      final List<int> bytes = await workbook.save();
      workbook.dispose();

      saveAsExcel(bytes, 'InvoiceAsync.xlsx');
    });

    test('Balance Sheet', () async {
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

      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'BalanceSheetAsync.xlsx');
      workbook.dispose();
    });

    test('Attendances Tracker', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'AttendanceTrackerAsync.xlsx');
      workbook.dispose();
    });
    test('Table', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'TableAsync.xlsx');
      workbook.dispose();
    });
    test('DataValidation', () async {
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
      final List<int> bytes = await workbook.save();
      saveAsExcel(bytes, 'DataValidationAsync.xlsx');
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
