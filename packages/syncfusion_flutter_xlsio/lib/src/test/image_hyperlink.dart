// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioImageHyperlink() {
  group('Image Hyperlink', () {
    test('different types jpg images', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      final Picture picture1 = sheet.pictures.addBase64(1, 1, image1jpg);
      sheet.hyperlinks
          .addImage(picture1, HyperlinkType.url, 'http://www.syncfusion.com');
      sheet.hyperlinks.addImage(sheet.pictures.addBase64(10, 10, image10jpg),
          HyperlinkType.url, 'mailto:Username@syncfusion.com');
      sheet.hyperlinks.addImage(sheet.pictures.addBase64(1, 15, image11jpg),
          HyperlinkType.file, r'C:\\Program files');
      sheet.hyperlinks.addImage(
          sheet.pictures.addBase64(30, 30, image12jpg),
          HyperlinkType.unc,
          r'C:\\Program Files\\Syncfusion\\Essential Studio');
      sheet.hyperlinks.addImage(sheet.pictures.addBase64(30, 1, image13jpg),
          HyperlinkType.workbook, 'Sheet1!L5');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageHyperlinkJpg.xlsx');
      workbook.dispose();
    });
    test('different types png images', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      final Picture picture1 = sheet.pictures.addBase64(1, 1, image14png);
      sheet.hyperlinks
          .addImage(picture1, HyperlinkType.url, 'http://www.syncfusion.com');
      sheet.hyperlinks.addImage(sheet.pictures.addBase64(10, 10, image26png),
          HyperlinkType.url, 'mailto:Username@syncfusion.com');
      sheet.hyperlinks.addImage(sheet.pictures.addBase64(1, 15, image24png),
          HyperlinkType.file, r'C:\\Program files');
      sheet.hyperlinks.addImage(
          sheet.pictures.addBase64(30, 20, image27png),
          HyperlinkType.unc,
          r'C:\\Program Files\\Syncfusion\\Essential Studio');
      sheet.hyperlinks.addImage(sheet.pictures.addBase64(30, 1, image25png),
          HyperlinkType.workbook, 'Sheet1!L5');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageHyperlinkPng.xlsx');
      workbook.dispose();
    });
    test('Screen tips', () {
      final Workbook workbook = Workbook(1);
      final Worksheet sheet = workbook.worksheets[0];
      final Picture picture1 = sheet.pictures.addBase64(1, 1, image14png);
      sheet.hyperlinks.addImage(picture1, HyperlinkType.url,
          'http://www.syncfusion.com', 'Click Here to know about Syncfusion');
      Hyperlink link = sheet.hyperlinks.addImage(
          sheet.pictures.addBase64(10, 10, image10jpg),
          HyperlinkType.url,
          'mailto:Username@syncfusion.com');
      link.screenTip = 'Mail to User';
      sheet.hyperlinks.addImage(sheet.pictures.addBase64(1, 15, image24png),
          HyperlinkType.file, r'C:\\Program files', 'Open the program file');
      link = sheet.hyperlinks.addImage(
          sheet.pictures.addBase64(30, 20, image12jpg),
          HyperlinkType.unc,
          r'C:\\Program Files\\Syncfusion\\Essential Studio');
      link.screenTip = 'Open Essential studio';
      sheet.hyperlinks.addImage(sheet.pictures.addBase64(30, 1, image25png),
          HyperlinkType.workbook, 'Sheet1!L5', 'Move to L5 cell');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageHyperlinkScreenTips.xlsx');
      workbook.dispose();
    });
    test('Multiple Sheets', () {
      final Workbook workbook = Workbook(3);
      final Worksheet sheet = workbook.worksheets[0];
      final Worksheet sheet1 = workbook.worksheets[1];
      final Worksheet sheet2 = workbook.worksheets[2];
      final Picture picture1 = sheet.pictures.addBase64(1, 1, image14png);
      sheet.hyperlinks.addImage(picture1, HyperlinkType.url,
          'http://www.syncfusion.com', 'Click Here to know about Syncfusion');
      Hyperlink link = sheet1.hyperlinks.addImage(
          sheet1.pictures.addBase64(10, 10, image10jpg),
          HyperlinkType.url,
          'mailto:Username@syncfusion.com');
      link.screenTip = 'Mail to User';
      sheet1.hyperlinks.addImage(sheet1.pictures.addBase64(1, 15, image24png),
          HyperlinkType.file, r'C:\\Program files', 'Open the program file');
      link = sheet2.hyperlinks.addImage(
          sheet2.pictures.addBase64(30, 20, image12jpg),
          HyperlinkType.unc,
          r'C:\\Program Files\\Syncfusion\\Essential Studio');
      link.screenTip = 'Open Essential studio';
      sheet2.hyperlinks.addImage(sheet2.pictures.addBase64(30, 1, image25png),
          HyperlinkType.workbook, 'Sheet1!L5', 'Move to L5 cell');
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageHyperlinkMultipleSheets.xlsx');
      workbook.dispose();
    });
    test('With hyperlinks and images', () {
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
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageHyperlink1.xlsx');
      workbook.dispose();
    });
  });
}
