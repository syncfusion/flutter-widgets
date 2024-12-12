// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioNumberFormat() {
  group('NumberFormats', () {
    test('All', () {
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

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelNumberFormat.xlsx');
      workbook.dispose();
    });
    test('Number', () {
      // Create a new Excel document.
      final Workbook workbook = Workbook();

      // Accessing worksheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      range.setNumber(279);
      range.numberFormat = '0.0';

      final Range range1 = sheet.getRangeByIndex(2, 1);
      range1.setNumber(-2211);
      range1.numberFormat = '#,##0.00';

      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.setNumber(9032);
      range2.numberFormat = '[Blue](#,##0.000)';

      final Range range3 = sheet.getRangeByIndex(4, 1);
      range3.setNumber(1291);
      range3.numberFormat = '(#,##0.0000)';

      final Range range4 = sheet.getRangeByIndex(5, 1);
      range4.setNumber(-22);
      range4.numberFormat = '#,##0.00000_)';

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      saveAsExcel(bytes, 'ExcelNumberFormatNumber.xlsx');
    });
    test('Currency', () {
      // Create a new Excel document.
      final Workbook workbook = Workbook();

      // Accessing worksheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      range.setNumber(2955);
      range.numberFormat = r'$#,##0.0';

      final Range range1 = sheet.getRangeByName('A2');
      range1.setNumber(22.11);
      range1.numberFormat = r'([Red]$0.00)';

      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.setNumber(9312);
      range2.numberFormat = r'($#,##0.00)';

      final Range range3 = sheet.getRangeByName('A4');
      range3.setNumber(111);
      range3.numberFormat = r'[BLUE]$0.0000';

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      saveAsExcel(bytes, 'ExcelNumberFormatCurrency.xlsx');
    });
    test('Percentage', () {
      // Create a new Excel document.
      final Workbook workbook = Workbook();

      // Accessing worksheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      range.setNumber(29);
      range.numberFormat = '0%';

      final Range range1 = sheet.getRangeByName('A2');
      range1.setNumber(22.11);
      range1.numberFormat = '0.00%';

      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.setNumber(0.09312);
      range2.numberFormat = '0.000%';

      final Range range3 = sheet.getRangeByName('A4');
      range3.setNumber(0.111);
      range3.numberFormat = '0.0000%';

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      saveAsExcel(bytes, 'ExcelNumberFormatPercentage.xlsx');
    });
    test('Date', () {
      // Create a new Excel document.
      final Workbook workbook = Workbook();

      // Accessing worksheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      range.setDateTime(DateTime(2020, 8, 23, 8, 15, 20));
      range.numberFormat = r'm/d/yyyy';

      final Range range1 = sheet.getRangeByName('A2');
      range1.setDateTime(DateTime(2002, 12, 3, 23, 45, 45));
      range1.numberFormat = 'dddd, mmmm dd, yyyy';

      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.setDateTime(DateTime(2012, 11, 22, 5, 45, 45));
      range2.numberFormat = 'yyyy-mm-dd';

      final Range range3 = sheet.getRangeByName('A4');
      range3.setDateTime(DateTime(2014, 10, 12, 20, 5, 5));
      range3.numberFormat = r'm/d';

      final Range range4 = sheet.getRangeByIndex(5, 1);
      range4.setDateTime(DateTime(2020, 8, 23, 8, 15, 20));
      range4.numberFormat = r'm/d/yy';

      final Range range5 = sheet.getRangeByName('A6');
      range5.setDateTime(DateTime(1999, 7, 30, 5, 34, 40));
      range5.numberFormat = 'mm/dd/yy';

      final Range range6 = sheet.getRangeByIndex(7, 1);
      range6.setDateTime(DateTime(2012, 11, 22, 5, 45, 45));
      range6.numberFormat = 'd-mmm';

      final Range range7 = sheet.getRangeByName('A8');
      range7.setDateTime(DateTime(2014, 10, 12, 20, 5, 5));
      range7.numberFormat = 'd-mmm-yy';

      final Range range8 = sheet.getRangeByIndex(9, 1);
      range8.setDateTime(DateTime(2020, 8, 23, 8, 15, 20));
      range8.numberFormat = 'mmmm-yy';

      final Range range9 = sheet.getRangeByName('A10');
      range9.setDateTime(DateTime(2002, 12, 3, 23, 45, 45));
      range9.numberFormat = 'mmmm d, yyyy';

      final Range range10 = sheet.getRangeByIndex(11, 1);
      range10.setDateTime(DateTime(2012, 11, 22, 5, 45, 45));
      range10.numberFormat = 'mmmmm';

      final Range range11 = sheet.getRangeByName('A12');
      range11.setDateTime(DateTime(2014, 10, 12, 20, 5, 5));
      range11.numberFormat = 'mmmmm-yy';

      final Range range12 = sheet.getRangeByIndex(13, 1);
      range12.setDateTime(DateTime(2020, 8, 23, 8, 15, 20));
      range12.numberFormat = 'd-mmm-yyyy';

      final Range range13 = sheet.getRangeByName('A14');
      range13.setDateTime(DateTime(2002, 12, 3, 23, 45, 45));
      range13.numberFormat = r'm/d/yy h:mm AM/PM';

      final Range range14 = sheet.getRangeByIndex(15, 1);
      range14.setDateTime(DateTime(2012, 11, 22, 5, 45, 45));
      range14.numberFormat = r'm/d/yy h:mm';

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      saveAsExcel(bytes, 'ExcelNumberFormatDate.xlsx');
    });

    test('Time', () {
      // Create a new Excel document.
      final Workbook workbook = Workbook();

      // Accessing worksheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      range.setDateTime(DateTime(2020, 8, 23, 8, 15, 20));
      range.numberFormat = 'h:mm:ss AM/PM';

      final Range range1 = sheet.getRangeByName('A2');
      range1.setDateTime(DateTime(2002, 12, 3, 23, 45, 45));
      range1.numberFormat = 'h:mm';

      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.setDateTime(DateTime(2012, 11, 22, 5, 45, 45));
      range2.numberFormat = 'h:mm AM/PM';

      final Range range3 = sheet.getRangeByName('A4');
      range3.setDateTime(DateTime(2014, 10, 12, 20, 5, 5));
      range3.numberFormat = 'h:mm:ss';

      final Range range4 = sheet.getRangeByIndex(5, 1);
      range4.setDateTime(DateTime(2020, 8, 23, 8, 15, 20));
      range4.numberFormat = 'mm:ss.0';

      final Range range5 = sheet.getRangeByName('A6');
      range5.setDateTime(DateTime(1999, 7, 30, 5, 34, 40));
      range5.numberFormat = '[h]:mm:ss';

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      saveAsExcel(bytes, 'ExcelNumberFormatTime.xlsx');
    });
    test('Accounting', () {
      // Create a new Excel document.
      final Workbook workbook = Workbook();

      // Accessing worksheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      range.setNumber(79);
      range.numberFormat = r'_($* #,##0_)';

      final Range range1 = sheet.getRangeByIndex(2, 1);
      range1.setNumber(2211);
      range1.numberFormat = r'_($* (#,##0.00)';

      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.setNumber(9.032);
      range2.numberFormat = r'_($* "-"???_)';

      final Range range3 = sheet.getRangeByIndex(4, 1);
      range3.setNumber(1.1291);
      range3.numberFormat = r'_($* #,##0.0000_)';

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      saveAsExcel(bytes, 'ExcelNumberFormatAccounting.xlsx');
    });
    test('Scientific', () {
      // Create a new Excel document.
      final Workbook workbook = Workbook();

      // Accessing worksheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      range.setNumber(791);
      range.numberFormat = '0.E+00';

      final Range range1 = sheet.getRangeByIndex(2, 1);
      range1.setNumber(22.11);
      range1.numberFormat = '0.00E+00';

      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.setNumber(9.1032);
      range2.numberFormat = '0.0000E+00';

      final Range range3 = sheet.getRangeByIndex(4, 1);
      range3.setNumber(11.1);
      range3.numberFormat = '0.0E+00';

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      saveAsExcel(bytes, 'ExcelNumberFormatScientific.xlsx');
    });
    test('Fraction', () {
      // Create a new Excel document.
      final Workbook workbook = Workbook();

      // Accessing worksheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      range.setNumber(29.4);
      range.numberFormat = '# ?/?';

      final Range range1 = sheet.getRangeByName('A2');
      range1.setNumber(22.11);
      range1.numberFormat = '# ??/??';

      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.setNumber(0.09312);
      range2.numberFormat = '# ???/???';

      final Range range3 = sheet.getRangeByName('A4');
      range3.setNumber(11.4);
      range3.numberFormat = '# ?/2';

      final Range range4 = sheet.getRangeByIndex(5, 1);
      range4.setNumber(47.98);
      range4.numberFormat = '# ?/4';

      final Range range5 = sheet.getRangeByName('A6');
      range5.setNumber(7.39);
      range5.numberFormat = '# ?/8';

      final Range range6 = sheet.getRangeByIndex(7, 1);
      range6.setNumber(21.5);
      range6.numberFormat = '# ??/16';

      final Range range7 = sheet.getRangeByName('A8');
      range7.setNumber(13.1);
      range7.numberFormat = '# ?/10';

      final Range range8 = sheet.getRangeByIndex(9, 1);
      range8.setNumber(49.56);
      range8.numberFormat = '# ??/100';

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      saveAsExcel(bytes, 'ExcelNumberFormatFraction.xlsx');
    });
    test('Text', () {
      // Create a new Excel document.
      final Workbook workbook = Workbook();

      // Accessing worksheet via index.
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      range.setNumber(-12.89);
      range.numberFormat = '@';

      final Range range1 = sheet.getRangeByName('A2');
      range1.setNumber(2311);
      range1.numberFormat = r'_(@_)';

      final Range range2 = sheet.getRangeByIndex(3, 1);
      range2.setNumber(0.09312);
      range2.numberFormat = '* @';

      final Range range3 = sheet.getRangeByName('A4');
      range3.setNumber(11.4);
      range3.numberFormat = '^ @';

      // Save and dispose workbook.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      saveAsExcel(bytes, 'ExcelNumberFormatText.xlsx');
    });
  });
}
