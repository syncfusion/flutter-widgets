// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioCulture() {
  group('Culture', () {
    group('Date', () {
      test('Sample1', () {
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

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureDateSample_1.xlsx');
        workbook.dispose();
      });

      test('Sample2', () {
        final Workbook workbook = Workbook.withCulture('sq-AL');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(3, 3);
        range1.numberFormat = r'm/d/yyyy';
        range1.dateTime = DateTime(2022, 11, 21);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(6, 6);
        range2.numberFormat = 'dd MMMM yyyy';
        range2.dateTime = DateTime(2022, 11, 21);
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureDateSample_2.xlsx');
        workbook.dispose();
      });

      test('Sample3', () {
        final Workbook workbook = Workbook.withCulture('fr-CA');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(5, 5);
        range1.numberFormat = r'm/d/yyyy';
        range1.dateTime = DateTime(2022, 11, 21);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(7, 7);
        range2.numberFormat = 'dd MMMM yyyy';
        range2.dateTime = DateTime(2022, 11, 21);
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureDateSample_3.xlsx');
        workbook.dispose();
      });
      test('Sample4', () {
        final Workbook workbook = Workbook.withCulture('ur-IN');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(1, 5);
        range1.numberFormat = r'm/d/yyyy';
        range1.dateTime = DateTime(2022, 11, 21);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(2, 7);
        range2.numberFormat = 'dd MMMM yyyy';
        range2.dateTime = DateTime(2022, 11, 21);
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureDateSample_4.xlsx');
        workbook.dispose();
      });
    });
    group('Time', () {
      test('Sample1', () {
        final Workbook workbook = Workbook.withCulture('en-IN');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = 'h:mm';
        range1.dateTime = DateTime(2021, 12, 22, 22, 22, 22);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(4, 4);
        range2.numberFormat = 'h:mm:ss';
        range2.dateTime = DateTime(2022, 11, 21, 21, 21, 21);
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureTimeSample_1.xlsx');
        workbook.dispose();
      });

      test('Sample2', () {
        final Workbook workbook = Workbook.withCulture('zu-ZA');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = 'h:mm';
        range1.dateTime = DateTime(2012, 2, 3, 4, 7, 50);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(4, 4);
        range2.numberFormat = 'h:mm:ss';
        range2.dateTime = DateTime(2021, 12, 8, 21, 38, 45);
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureTimeSample_2.xlsx');
        workbook.dispose();
      });

      test('Sample3', () {
        final Workbook workbook = Workbook.withCulture('mi-NZ');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = r'h:mm\\ AM/PM';
        range1.dateTime = DateTime(2012, 2, 3, 4, 7, 50);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(4, 4);
        range2.numberFormat = r'h:mm:ss\\ AM/PM';
        range2.dateTime = DateTime(2021, 12, 8, 21, 38, 45);
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureTimeSample_3.xlsx');
        workbook.dispose();
      });

      test('Sample4', () {
        final Workbook workbook = Workbook.withCulture('ha-Latn-NG');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = r'h:mm\\ AM/PM';
        range1.dateTime = DateTime(2012, 2, 3, 4, 7, 50);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(4, 4);
        range2.numberFormat = r'h:mm:ss\\ AM/PM';
        range2.dateTime = DateTime(2021, 12, 8, 21, 38, 45);
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureTimeSample_4.xlsx');
        workbook.dispose();
      });
    });

    group('Date_Time', () {
      test('Sample1', () {
        final Workbook workbook = Workbook.withCulture('nl-NL');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = r'm/d/yyyy\\ h:mm';
        range1.dateTime = DateTime(2021, 12, 22, 22, 22, 22);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(4, 4);
        range2.numberFormat = r'm/d/yyyy\\ h:mm';
        range2.dateTime = DateTime(2001, 2, 2, 2, 2, 2);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(6, 6);
        range3.numberFormat = r'm/d/yyyy\\ h:mm';
        range3.dateTime = DateTime(2031, 5, 4, 6, 7, 42);
        range3.displayText;

        final Range range4 = sheet.getRangeByIndex(8, 8);
        range4.numberFormat = r'm/d/yyyy\\ h:mm';
        range4.dateTime = DateTime(2056, 12, 14, 16, 17, 42);
        range4.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureDateTimeSample_1.xlsx');
        workbook.dispose();
      });

      test('Sample2', () {
        final Workbook workbook = Workbook.withCulture('zu-ZA');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = r'm/d/yyyy\\ h:mm';
        range1.dateTime = DateTime(2000, 7, 26, 21, 38, 49);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(4, 4);
        range2.numberFormat = r'm/d/yyyy\\ h:mm';
        range2.dateTime = DateTime(2001, 2, 2, 2, 2, 2);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(6, 6);
        range3.numberFormat = r'm/d/yyyy\\ h:mm';
        range3.dateTime = DateTime(2031, 5, 4, 6, 7, 42);
        range3.displayText;

        final Range range4 = sheet.getRangeByIndex(8, 8);
        range4.numberFormat = r'm/d/yyyy\\ h:mm';
        range4.dateTime = DateTime(2056, 12, 14, 16, 17, 42);
        range4.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureDateTimeSample_2.xlsx');
        workbook.dispose();
      });

      test('Sample3', () {
        final Workbook workbook = Workbook.withCulture('en-PH');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = r'm/d/yyyy\\ h:mm';
        range1.dateTime = DateTime(2012, 2, 3, 4, 7, 50);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(4, 4);
        range2.numberFormat = r'm/d/yyyy\\ h:mm';
        range2.dateTime = DateTime(2001, 2, 2, 2, 2, 2);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(6, 6);
        range3.numberFormat = r'm/d/yyyy\\ h:mm';
        range3.dateTime = DateTime(2031, 5, 4, 6, 7, 42);
        range3.displayText;

        final Range range4 = sheet.getRangeByIndex(8, 8);
        range4.numberFormat = r'm/d/yyyy\\ h:mm';
        range4.dateTime = DateTime(2056, 12, 14, 16, 17, 42);
        range4.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureDateTimeSample_3.xlsx');
        workbook.dispose();
      });

      test('Sample4', () {
        final Workbook workbook = Workbook.withCulture('fr-CA');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = r'm/d/yyyy\\ h:mm';
        range1.dateTime = DateTime(1990, 3, 23, 22, 24, 34);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(4, 4);
        range2.numberFormat = r'm/d/yyyy\\ h:mm';
        range2.dateTime = DateTime(2001, 2, 2, 2, 2, 2);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(6, 6);
        range3.numberFormat = r'm/d/yyyy\\ h:mm';
        range3.dateTime = DateTime(2031, 5, 4, 6, 7, 42);
        range3.displayText;

        final Range range4 = sheet.getRangeByIndex(8, 8);
        range4.numberFormat = r'm/d/yyyy\\ h:mm';
        range4.dateTime = DateTime(2056, 12, 14, 16, 17, 42);
        range4.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureDateTimeSample_4 .xlsx');
        workbook.dispose();
      });
    });

    group('Number', () {
      test('Sample1', () {
        final Workbook workbook = Workbook.withCulture('fi-FI');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(1, 1);
        range.numberFormat = '0.00';
        range.setNumber(279613);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = '#,##0.00';
        range1.setNumber(-22114);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(3, 3);
        range2.numberFormat = '[Blue](#,##0)';
        range2.setNumber(9032223);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(4, 4);
        range3.numberFormat = '#,##0';
        range3.number = 12911;
        range3.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureNumberSample_1.xlsx');
        workbook.dispose();
      });

      test('Sample2', () {
        final Workbook workbook = Workbook.withCulture('de-DE');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(1, 1);
        range.numberFormat = '0.00';
        range.setNumber(2788);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = '#,##0.00';
        range1.setNumber(-22114);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(3, 3);
        range2.numberFormat = '[RED](#,##0)';
        range2.setNumber(9032223);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(4, 4);
        range3.numberFormat = '#,##0';
        range3.number = 12911;
        range3.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureNumberSample_2.xlsx');
        workbook.dispose();
      });

      test('Sample3', () {
        final Workbook workbook = Workbook.withCulture('it-IT');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(3, 3);
        range.numberFormat = '0.00';
        range.setNumber(88);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(5, 5);
        range1.numberFormat = '#,##0.00';
        range1.setNumber(-22114);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(7, 7);
        range2.numberFormat = '[RED](#,##0)';
        range2.setNumber(9032223);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(9, 9);
        range3.numberFormat = '#,##0';
        range3.number = 12911;
        range3.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureNumberSample_3.xlsx');
        workbook.dispose();
      });

      test('Sample4', () {
        final Workbook workbook = Workbook.withCulture('th-TH');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(3, 3);
        range.numberFormat = '0.00';
        range.setNumber(88);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(5, 5);
        range1.numberFormat = '#,##0.00';
        range1.setNumber(-22114);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(7, 7);
        range2.numberFormat = '[YELLOW](#,##0)';
        range2.setNumber(9032223);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(9, 9);
        range3.numberFormat = '#,##0';
        range3.number = 12911;
        range3.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureNumberSample_4.xlsx');
        workbook.dispose();
      });
    });

    group('Currency', () {
      test('Sample1', () {
        final Workbook workbook = Workbook.withCulture('nl-NL', 'ANG');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(1, 1);
        range.numberFormat = r'$#,##0.00';
        range.setNumber(1231);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(3, 3);
        range1.numberFormat = r'$#,##0';
        range1.number = 3212;
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(5, 5);
        range2.numberFormat = r'_($* #,##0.00_)';
        range2.number = 4055;
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(7, 7);
        range3.numberFormat = r'[Red]$#,##0.00';
        range3.number = 37101;
        range3.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureCurrencySample_1.xlsx');
        workbook.dispose();
      });

      test('Sample2', () {
        final Workbook workbook = Workbook.withCulture('de-DE');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(2, 2);
        range.numberFormat = r'$#,##0.00';
        range.setNumber(1231);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(4, 4);
        range1.numberFormat = r'$#,##0';
        range1.number = 3212;
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(6, 6);
        range2.numberFormat = r'_($* #,##0.00_)';
        range2.number = 4055;
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(8, 8);
        range3.numberFormat = r'[BLUE]$#,##0.00';
        range3.number = 37101;
        range3.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureCurrencySample_2.xlsx');
        workbook.dispose();
      });

      test('Sample3', () {
        final Workbook workbook = Workbook.withCulture('it-IT');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(2, 2);
        range.numberFormat = r'$#,##0.00';
        range.setNumber(1231);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(4, 4);
        range1.numberFormat = r'$#,##0';
        range1.number = 3212;
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(6, 6);
        range2.numberFormat = r'_($* #,##0.00_)';
        range2.number = 4055;
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(8, 8);
        range3.numberFormat = r'[BLUE]$#,##0.00';
        range3.number = 37101;
        range3.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureCurrencySample_3.xlsx');
        workbook.dispose();
      });

      test('Sample4', () {
        final Workbook workbook = Workbook.withCulture('fi-FI');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(2, 2);
        range.numberFormat = r'$#,##0.00';
        range.setNumber(1231);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(4, 4);
        range1.numberFormat = r'$#,##0';
        range1.number = 3212;
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(6, 6);
        range2.numberFormat = r'_($* #,##0.00_)';
        range2.number = 4055;
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(8, 8);
        range3.numberFormat = r'[BLUE]$#,##0.00';
        range3.number = 37101;
        range3.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureCurrencySample_4.xlsx');
        workbook.dispose();
      });
    });

    group('Account', () {
      test('Sample1', () {
        final Workbook workbook = Workbook.withCulture('es-US');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.numberFormat = '0%';
        range1.setNumber(131);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(2, 2);
        range2.numberFormat = '0.00%';
        range2.setNumber(142);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(3, 3);
        range3.numberFormat = '#,##0_)';
        range3.number = 44134412;
        range3.displayText;

        final Range range4 = sheet.getRangeByIndex(4, 4);
        range4.numberFormat = r'_(* \\(#,##0\\)';
        range4.number = 78554;
        range4.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureAccountSample_1.xlsx');
        workbook.dispose();
      });

      test('Sample2', () {
        final Workbook workbook = Workbook.withCulture('de-CH');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.numberFormat = '0%';
        range1.setNumber(13);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(2, 2);
        range2.numberFormat = '0.00%';
        range2.setNumber(144);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(3, 3);
        range3.numberFormat = '#,##0_)';
        range3.number = 4444;
        range3.displayText;

        final Range range4 = sheet.getRangeByIndex(4, 4);
        range4.numberFormat = r'_(* \\(#,##0\\)';
        range4.number = 78554;
        range4.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureAccountSample_2.xlsx');
        workbook.dispose();
      });

      test('Sample3', () {
        final Workbook workbook = Workbook.withCulture('fr-FR');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.numberFormat = '0%';
        range1.setNumber(12);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(2, 2);
        range2.numberFormat = '0.00%';
        range2.setNumber(2244);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(3, 3);
        range3.numberFormat = '#,##0_)';
        range3.number = 441355;
        range3.displayText;

        final Range range4 = sheet.getRangeByIndex(4, 4);
        range4.numberFormat = r'_(* \\(#,##0\\)';
        range4.number = 78554;
        range4.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureAccountSample_3.xlsx');
        workbook.dispose();
      });

      test('Sample4', () {
        final Workbook workbook = Workbook.withCulture('sq-AL');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range1 = sheet.getRangeByIndex(1, 1);
        range1.numberFormat = '0%';
        range1.setNumber(11);
        range1.displayText;

        final Range range2 = sheet.getRangeByIndex(2, 2);
        range2.numberFormat = '0.00%';
        range2.setNumber(1441);
        range2.displayText;

        final Range range3 = sheet.getRangeByIndex(3, 3);
        range3.numberFormat = '#,##0_)';
        range3.number = 441144;
        range3.displayText;

        final Range range4 = sheet.getRangeByIndex(4, 4);
        range4.numberFormat = r'_(* \\(#,##0\\)';
        range4.number = 5544;
        range4.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureAccountSample_4.xlsx');
        workbook.dispose();
      });
    });

    group('Other Format', () {
      test('Sample1', () {
        final Workbook workbook = Workbook.withCulture('de-AT');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(1, 1);
        range.numberFormat = '0.00E+00';
        range.setNumber(34225);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = '##0.0E+0';
        range1.setNumber(1245);
        range1.displayText;

        final Range range2 = sheet.getRangeByName('E5');
        range2.numberFormat = '@';
        range2.number = 23781;
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureOtherFormatSample_1.xlsx');
        workbook.dispose();
      });

      test('Sample2', () {
        final Workbook workbook = Workbook.withCulture('it-CH');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(3, 3);
        range.numberFormat = '0.00E+00';
        range.setNumber(76474);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(7, 7);
        range1.numberFormat = '##0.0E+0';
        range1.number = 96431;
        range1.displayText;

        final Range range2 = sheet.getRangeByName('E5');
        range2.numberFormat = '@';
        range2.number = 9321;
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureOtherFormatSample_2.xlsx');
        workbook.dispose();
      });

      test('Sample3', () {
        final Workbook workbook = Workbook.withCulture('nl-BE');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(1, 1);
        range.numberFormat = '0.00E+00';
        range.setNumber(219869);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(3, 3);
        range1.numberFormat = '##0.0E+0';
        range1.number = -24322;
        range1.displayText;

        final Range range2 = sheet.getRangeByName('D4');
        range2.numberFormat = '@';
        range2.number = 9321;
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureOtherFormatSample_3.xlsx');
        workbook.dispose();
      });

      test('Sample4', () {
        final Workbook workbook = Workbook.withCulture('sr-Cyrl-ME');
        final Worksheet sheet = workbook.worksheets[0];

        final Range range = sheet.getRangeByIndex(1, 1);
        range.numberFormat = '0.00E+00';
        range.setNumber(8752.0);
        range.displayText;

        final Range range1 = sheet.getRangeByIndex(2, 2);
        range1.numberFormat = '##0.0E+0';
        range1.number = 29494;
        range1.displayText;

        final Range range2 = sheet.getRangeByName('C3');
        range2.numberFormat = '@';
        range2.number = 2120;
        range2.displayText;

        final List<int> bytes = workbook.saveAsStream();
        saveAsExcel(bytes, 'ExcelCultureOtherFormatSample_4.xlsx');
        workbook.dispose();
      });
    });
  });
}
