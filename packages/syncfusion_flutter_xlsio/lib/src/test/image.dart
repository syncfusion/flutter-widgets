// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioImage() {
  group('Image', () {
    test('jpeg format ', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.pictures.addBase64(1, 1, image1jpg);

      sheet.pictures.addBase64(8, 5, image1jpg);
      sheet.pictures.addBase64(4, 15, image9jpg);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageJpegFormat.xlsx');
      workbook.dispose();
    });

    test('png format ', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.pictures.addBase64(5, 1, image3png);

      sheet.pictures.addBase64(10, 6, image5png);
      sheet.pictures.addBase64(1, 16, image6png);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImagePngFormat.xlsx');
      workbook.dispose();
    });

    test('jpeg_png Format', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      sheet.pictures.addBase64(1, 2, image24png);
      sheet.pictures.addBase64(10, 15, image10jpg);

      sheet.pictures.addBase64(1, 20, image7png);
      sheet.pictures.addBase64(40, 1, image12jpg);

      sheet.pictures.addBase64(40, 15, image8png);
      sheet.pictures.addBase64(40, 10, image11jpg);

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageJpg_PngFormat.xlsx');
      workbook.dispose();
    });

    test('rotation property', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Picture picture1 = sheet.pictures.addBase64(1, 2, image24png);
      picture1.rotation = 60;

      final Picture picture2 = sheet.pictures.addBase64(24, 10, image14png);
      picture2.rotation = 120;

      final Picture picture3 = sheet.pictures.addBase64(8, 15, image15jpg);
      picture3.rotation = 90;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageRotation.xlsx');
      workbook.dispose();
    });

    test('horizontal flip property', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Picture picture1 = sheet.pictures.addBase64(1, 2, image25png);
      picture1.horizontalFlip = true;

      final Picture picture2 = sheet.pictures.addBase64(30, 13, image13jpg);
      picture2.horizontalFlip = true;

      final Picture picture3 = sheet.pictures.addBase64(8, 15, image26png);
      picture3.horizontalFlip = true;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageHorizontalFlip.xlsx');
      workbook.dispose();
    });

    test('vertical flip property', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Picture picture1 = sheet.pictures.addBase64(1, 2, image25png);
      picture1.verticalFlip = true;

      final Picture picture2 = sheet.pictures.addBase64(25, 13, image13jpg);
      picture2.verticalFlip = true;

      final Picture picture3 = sheet.pictures.addBase64(8, 15, image26png);
      picture3.verticalFlip = true;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageVerticalFlip.xlsx');
      workbook.dispose();
    });

    test('Height_width property', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Picture picture1 = sheet.pictures.addBase64(1, 2, image15jpg);
      picture1.height = 200;
      picture1.width = 200;

      final Picture picture2 = sheet.pictures.addBase64(10, 10, image4png);
      picture2.height = 250;
      picture2.width = 150;

      final Picture picture3 = sheet.pictures.addBase64(1, 15, image16jpg);
      picture3.height = 300;
      picture3.width = 500;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageHeightWidth.xlsx');
      workbook.dispose();
    });

    test('image layout property', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      final Picture picture1 = sheet.pictures.addBase64(1, 1, image18jpg);
      picture1.row = 1;
      picture1.lastRow = 5;
      picture1.column = 5;
      picture1.lastColumn = 10;

      final Picture picture2 = sheet.pictures.addBase64(10, 10, image6png);
      picture2.row = 20;
      picture2.lastRow = 25;
      picture2.column = 15;
      picture2.lastColumn = 20;

      final Picture picture3 = sheet.pictures.addBase64(1, 15, image19jpg);
      picture3.row = 1;
      picture3.lastRow = 13;
      picture3.column = 30;
      picture3.lastColumn = 35;

      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ExcelImageLayOut.xlsx');
      workbook.dispose();
    });
  });
}
