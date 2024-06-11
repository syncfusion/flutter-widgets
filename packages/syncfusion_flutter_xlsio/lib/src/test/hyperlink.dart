// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioHyperlinks() {
  group('hyperlink', () {
    test('range', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByIndex(1, 1);
      sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      final Range range1 = sheet.getRangeByIndex(4, 4);
      sheet.hyperlinks.add(range1, HyperlinkType.url, 'http://www.google.com');
      sheet.hyperlinks.add(sheet.getRangeByIndex(6, 6), HyperlinkType.url,
          'http://www.gmail.com');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelHyperlinkRange.xlsx');
      workbook.dispose();
    });
    test('range name', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      final Range range1 = sheet.getRangeByName('D14');
      sheet.hyperlinks.add(range1, HyperlinkType.url, 'http://www.google.com');
      sheet.hyperlinks.add(sheet.getRangeByName('A20'), HyperlinkType.url,
          'http://www.gmail.com');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelHyperlinkRangeName.xlsx');
      workbook.dispose();
    });
    test('multiple sheets', () {
      final Workbook workbook = Workbook(2);

      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      final Range range1 = sheet.getRangeByIndex(10, 10);
      sheet.hyperlinks.add(range1, HyperlinkType.url, 'http://www.google.com');
      sheet.hyperlinks.add(sheet.getRangeByName('J16'), HyperlinkType.url,
          'http://www.gmail.com');

      final Worksheet sheet1 = workbook.worksheets[1];
      sheet1.hyperlinks.add(sheet1.getRangeByIndex(2, 10), HyperlinkType.url,
          'http://www.fb.com');
      sheet1.hyperlinks.add(sheet1.getRangeByName('D16'), HyperlinkType.url,
          'http://www.yahoo.com');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelHyperlinkMultipleSheet.xlsx');
    });
    test('screentip', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      sheet.hyperlinks.add(range, HyperlinkType.url,
          'http://www.syncfusion.com', 'Click Here to know about Syncfusion');
      final Range range1 = sheet.getRangeByIndex(10, 10);
      sheet.hyperlinks.add(range1, HyperlinkType.url, 'http://www.google.com',
          'Search anything');
      final Hyperlink link1 = sheet.hyperlinks.add(sheet.getRangeByName('J16'),
          HyperlinkType.url, 'http://www.gmail.com');
      link1.screenTip = 'login here';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelHyperlinkScreenTip.xlsx');
    });
    test('TextToDisplay', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      final Hyperlink link = sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      link.screenTip = 'Click Here to know about Syncfusion';
      link.textToDisplay = 'Syncfusion';
      final Range range1 = sheet.getRangeByIndex(10, 4);
      sheet.hyperlinks.add(range1, HyperlinkType.url, 'http://www.google.com',
          'Search anything', 'Google');
      final Hyperlink link1 = sheet.hyperlinks.add(sheet.getRangeByName('J16'),
          HyperlinkType.url, 'http://www.gmail.com');
      link1.screenTip = 'login here';
      link1.textToDisplay = 'Gmail';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelHyperlinkTextToDisplay.xlsx');
    });
    test('Change cellstyle', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final CellStyle style = CellStyle(workbook);
      style.fontColor = '#791193';
      style.underline = false;
      style.fontName = 'Aharoni';
      workbook.styles.addStyle(style);
      final Range range = sheet.getRangeByName('A1');

      final Hyperlink link = sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      link.screenTip = 'Click Here to know about Syncfusion';
      link.textToDisplay = 'Syncfusion';
      range.cellStyle.fontColor = '#000000';
      range.cellStyle.fontName = 'Chiller';

      final Range range1 = sheet.getRangeByIndex(10, 4);
      final Hyperlink link1 = sheet.hyperlinks
          .add(range1, HyperlinkType.url, 'http://www.google.com');
      link1.screenTip = 'Search anything';
      link1.textToDisplay = 'Google';
      range1.cellStyle = style;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelHyperlinkCellstyle.xlsx');
    });
    test('value', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final Range range = sheet.getRangeByName('A1');
      range.text = 'Syncfusion';
      final Hyperlink link = sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      link.screenTip = 'Click Here to know about Syncfusion';
      final Range range1 = sheet.getRangeByIndex(10, 10);
      range1.text = 'Google Go';
      Hyperlink link1 = sheet.hyperlinks
          .add(range1, HyperlinkType.url, 'http://www.google.com');
      link1.screenTip = 'Search anything';
      sheet.getRangeByName('J16').text = 'Gmail';
      link1 = sheet.hyperlinks.add(sheet.getRangeByName('J16'),
          HyperlinkType.url, 'http://www.gmail.com');
      link1.screenTip = 'login here';
      sheet.getRangeByName('J16').text = 'Gmail copy';
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelHyperlinkValue.xlsx');
    });
    test('different types', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      sheet.hyperlinks.add(range, HyperlinkType.workbook, 'Sheet1!A15');

      final Range range1 = sheet.getRangeByName('A2');
      sheet.hyperlinks.add(range1, HyperlinkType.file, r'C:\\Program files');

      final Range range2 = sheet.getRangeByName('A3');
      sheet.hyperlinks
          .add(range2, HyperlinkType.unc, r'C:\\Documents and settings');

      final Range range3 = sheet.getRangeByIndex(4, 1);
      sheet.hyperlinks
          .add(range3, HyperlinkType.url, 'http://www.syncfusion.com');

      final Range range4 = sheet.getRangeByName('A5');
      final Hyperlink link4 = sheet.hyperlinks.add(range4, HyperlinkType.unc,
          r'C:\\Program Files\\Syncfusion\\Essential Studio');
      link4.screenTip = 'Click here for files';

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelHyperlinkTypes.xlsx');
      workbook.dispose();
    });
    test('Image', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Range range = sheet.getRangeByIndex(1, 1);
      sheet.hyperlinks
          .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
      sheet.pictures.addBase64(2, 1, image1jpg);
      final Range range1 = sheet.getRangeByIndex(1, 7);
      sheet.hyperlinks.add(range1, HyperlinkType.workbook, 'Sheet1!A15');
      sheet.pictures.addBase64(10, 10, image9jpg);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelHyperlinkImage.xlsx');
      workbook.dispose();
    });
  });
}
