import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'fonts.dart';
// ignore: avoid_relative_lib_imports
import 'images.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void userGuideSamples() {
  group('UG-Getting Started', () {
    test('create pdf document', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Add a new page and draw text
      document.pages.add().graphics.drawString(
          'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: const Rect.fromLTWH(0, 0, 150, 20));
      //Save the document
      savePdf(document.saveSync(), 'UG_create_pdf_Document.pdf');
      //Dispose the document
      document.dispose();
    });
    test('creating pdf document with image', () {
      //Creates a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw the image
      document.pages.add().graphics.drawImage(
          PdfBitmap.fromBase64String(imageJpeg),
          const Rect.fromLTWH(0, 0, 100, 100));
      //Saves the document
      savePdf(document.saveSync(), 'UG_creating_pdf_document_with_image.pdf');
      //Dispose the document
      document.dispose();
    });
    test('creating pdf document with table', () {
      //Creates a new PDF document
      final PdfDocument document = PdfDocument();
      //Create a PdfGrid
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'RollNo';
      header.cells[1].value = 'Name';
      header.cells[2].value = 'Class';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = '1';
      row1.cells[1].value = 'Arya';
      row1.cells[2].value = '6';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = '12';
      row2.cells[1].value = 'John';
      row2.cells[2].value = '9';
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = '42';
      row3.cells[1].value = 'Tony';
      row3.cells[2].value = '8';
      //Draw grid to the page of the PDF document
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      //Saves the document
      savePdf(document.saveSync(), 'UG_creating_pdf_document_with_table.pdf');
      //Dispose the document
      document.dispose();
    });
    test('Getting Started - document with basic element', () {
      //Creates a new PDF document
      final PdfDocument document = PdfDocument();
      //Adds page settings
      document.pageSettings.orientation = PdfPageOrientation.landscape;
      document.pageSettings.margins.all = 50;
      //Adds a page to the document
      final PdfPage page = document.pages.add();
      final PdfGraphics graphics = page.graphics;
      //Loads the image
      final PdfImage image = PdfBitmap.fromBase64String(imageJpeg);
      //PdfImage image = PdfBitmap(File('image.jpg').readAsBytesSync());
      //Draws the image to the PDF page
      page.graphics.drawImage(image, const Rect.fromLTWH(176, 0, 390, 130));
      final PdfBrush solidBrush = PdfSolidBrush(PdfColor(126, 151, 173));
      final Rect bounds = Rect.fromLTWH(0, 160, graphics.clientSize.width, 30);
      //Draws a rectangle to place the heading in that region
      graphics.drawRectangle(brush: solidBrush, bounds: bounds);
      //Creates a font for adding the heading in the page
      final PdfFont subHeadingFont =
          PdfStandardFont(PdfFontFamily.timesRoman, 14);
      //Creates a text element to add the invoice number
      PdfTextElement element =
          PdfTextElement(text: 'INVOICE 001', font: subHeadingFont);
      element.brush = PdfBrushes.white;
      //Draws the heading on the page
      PdfLayoutResult result = element.draw(
          page: page, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))!;
      const String currentDate = 'DATE Apr 20, 2020';
      //Measures the width of the text to place it in the correct location
      final Size textSize = subHeadingFont.measureString(currentDate);
      //Draws the date by using drawString method
      graphics.drawString(currentDate, subHeadingFont,
          brush: element.brush,
          bounds: Offset(graphics.clientSize.width - textSize.width - 10,
                  result.bounds.top) &
              Size(textSize.width + 2, 20));
      //Creates text elements to add the address and draw it to the page
      element = PdfTextElement(
          text: 'BILL TO ',
          font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
              style: PdfFontStyle.bold));
      element.brush = PdfSolidBrush(PdfColor(126, 155, 203));
      result = element.draw(
          page: page,
          bounds: Rect.fromLTWH(10, result.bounds.bottom + 25, 0, 0))!;
      final PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 10);
      element = PdfTextElement(text: 'Victuailles en stock ', font: timesRoman);
      element.brush = PdfBrushes.black;
      result = element.draw(
          page: page,
          bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
      element = PdfTextElement(
          text: '2, rue du Commerce, Lyon, France ', font: timesRoman);
      element.brush = PdfBrushes.black;
      result = element.draw(
          page: page,
          bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
      //Draws a line at the bottom of the address
      graphics.drawLine(
          PdfPen(PdfColor(126, 151, 173), width: 0.7),
          Offset(0, result.bounds.bottom + 3),
          Offset(graphics.clientSize.width, result.bounds.bottom + 3));
      //Creates a PDF grid
      final PdfGrid grid = PdfGrid();
      grid.style.cellPadding =
          PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);
      grid.columns.add(count: 5);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Product Id';
      header.cells[1].value = 'Product';
      header.cells[2].value = 'Price';
      header.cells[3].value = 'Quantity';
      header.cells[4].value = 'Total';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'CA-1098';
      row1.cells[1].value = 'AWC Logo Cap';
      row1.cells[2].value = r'$8.99';
      row1.cells[3].value = '2';
      row1.cells[4].value = r'$17.98';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'LJ-0192-M';
      row2.cells[1].value = 'Long-Sleeve Logo Jersey,M';
      row2.cells[2].value = r'$49.99';
      row2.cells[3].value = '3';
      row2.cells[4].value = r'$149.97';
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = 'So-B909-M';
      row3.cells[1].value = 'Mountain Bike Socks,M';
      row3.cells[2].value = r'$9.5';
      row3.cells[3].value = '2';
      row3.cells[4].value = r'$19';
      final PdfGridRow row4 = grid.rows.add();
      row4.cells[0].value = 'LJ-0192';
      row4.cells[1].value = 'Long-Sleeve Logo Jersey,M';
      row4.cells[2].value = r'$49.99';
      row4.cells[3].value = '4';
      row4.cells[4].value = r'$199.96';
      //Creates the header style
      final PdfGridCellStyle headerStyle = PdfGridCellStyle();
      headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
      headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
      headerStyle.textBrush = PdfBrushes.white;
      headerStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,
          style: PdfFontStyle.regular);
      //Adds cell customizations
      for (int i = 0; i < header.cells.count; i++) {
        if (i == 0 || i == 1) {
          header.cells[i].stringFormat =
              PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle);
        } else {
          header.cells[i].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.right,
              lineAlignment: PdfVerticalAlignment.middle);
        }
        header.cells[i].style = headerStyle;
      }
      //Creates the grid cell styles
      final PdfGridCellStyle cellStyle = PdfGridCellStyle();
      cellStyle.borders.all = PdfPens.white;
      cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
      cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 12);
      cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
      //Adds cell customizations
      for (int i = 0; i < grid.rows.count; i++) {
        final PdfGridRow row = grid.rows[i];
        for (int j = 0; j < row.cells.count; j++) {
          row.cells[j].style = cellStyle;
          if (j == 0 || j == 1) {
            row.cells[j].stringFormat =
                PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle);
          } else {
            row.cells[j].stringFormat = PdfStringFormat(
                alignment: PdfTextAlignment.right,
                lineAlignment: PdfVerticalAlignment.middle);
          }
        }
      }
      //Creates layout format settings to allow the table pagination
      final PdfLayoutFormat layoutFormat =
          PdfLayoutFormat(layoutType: PdfLayoutType.paginate);
      //Draws the grid to the PDF page
      final PdfLayoutResult gridResult = grid.draw(
          page: page,
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
              graphics.clientSize.width, graphics.clientSize.height - 100),
          format: layoutFormat)!;
      gridResult.page.graphics.drawString(
          r'Grand Total :                             $386.91', subHeadingFont,
          brush: PdfSolidBrush(PdfColor(126, 155, 203)),
          bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + 30, 0, 0));
      gridResult.page.graphics.drawString(
          'Thank you for your business !', subHeadingFont,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(520, gridResult.bounds.bottom + 60, 0, 0));
      //Save the document
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'UG_document_with_basic_element.pdf');
      //Dispose the document
      document.dispose();
    });
  });
  group('UG-Working with Document', () {
    test('adding document settings_1', () {
      //Create a new PDF documentation
      final PdfDocument document = PdfDocument();
      //Set the page size
      document.pageSettings.size = PdfPageSize.a4;
      //Draw the text by adding page to the document
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.mediumVioletRed,
          bounds: const Rect.fromLTWH(170, 100, 0, 0));
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_adding_document_settings_1.pdf');
      document.dispose();
    });
    test('adding document settings_2', () {
      //Create a new PDF documentation
      final PdfDocument document = PdfDocument();
      //Set the page size
      document.pageSettings.size = const Size(200, 300);
      //Draw the text by adding page to the document
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 19),
          brush: PdfBrushes.mediumVioletRed);
      //Save and close the PDF document
      savePdf(document.saveSync(), 'UG_adding_document_settings_2.pdf');
      document.dispose();
    });
    test('adding document settings_3', () {
      //Create a new PDF documentation
      final PdfDocument document = PdfDocument();
      //Set the page size
      document.pageSettings.size = PdfPageSize.a4;
      //Change the page orientation to landscape
      document.pageSettings.orientation = PdfPageOrientation.landscape;
      //Draw the text by adding page to the document
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.mediumVioletRed,
          bounds: const Rect.fromLTWH(170, 100, 0, 0));
      //Save and close the PDF document
      savePdf(document.saveSync(), 'UG_adding_document_settings_3.pdf');
      document.dispose();
    });
    test('adding document settings_4', () {
      //Create a new PDF documentation
      final PdfDocument document = PdfDocument();
      //Set the page size
      document.pageSettings.size = PdfPageSize.a4;
      //Change the page orientation to 90 degree
      document.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      //Draw the text by adding page to the document
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.mediumVioletRed,
          bounds: const Rect.fromLTWH(170, 100, 0, 0));
      //Save and close the PDF document
      savePdf(document.saveSync(), 'UG_adding_document_settings_4.pdf');
      document.dispose();
    });
    test('creating sections in pdf', () {
      //Create a new PDF documentation
      final PdfDocument document = PdfDocument();
      //Add a section to PDF document
      final PdfSection section = document.sections!.add();
      //Draw the text by section page graphics
      section.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.mediumVioletRed,
          bounds: const Rect.fromLTWH(170, 100, 0, 0));
      //Save and close the PDF document
      savePdf(document.saveSync(), 'UG_creating_sections.pdf');
      document.dispose();
    });
  });
  group('UG-Working with Pages', () {
    test('adding a new page', () {
      //Create a new PDF documentation
      final PdfDocument document = PdfDocument();
      //Create a new PDF page and draw the text
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue,
          bounds: const Rect.fromLTWH(170, 100, 0, 0));
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_adding_a_new_page.pdf');
      document.dispose();
    });
    test('adding margin', () {
      //Create a new PDF documentation
      final PdfDocument document = PdfDocument();
      //Set margin for all the pages
      document.pageSettings.margins.all = 200;
      //Draw the text by adding page to the document
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_adding_margin.pdf');
      document.dispose();
    });
    test('adding sections with different page setting', () {
      //Create a PDF document
      final PdfDocument document = PdfDocument();
      //Set the font
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      //Section - 1
      //Add section to the document
      PdfSection section = document.sections!.add();
      //Create page settings to the section
      section.pageSettings.rotate = PdfPageRotateAngle.rotateAngle0;
      section.pageSettings.size = const Size(300, 400);
      //Draw simple text on the page
      section.pages.add().graphics.drawString('Rotated by 0 degrees', font,
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      //Section - 2
      //Add section to the document
      section = document.sections!.add();
      //Create page settings to the section
      section.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      section.pageSettings.size = const Size(300, 400);
      //Draw simple text on the page
      section.pages.add().graphics.drawString('Rotated by 90 degrees', font,
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      //Section - 3
      //Add section to the document
      section = document.sections!.add();
      //Create page settings to the section
      section.pageSettings.rotate = PdfPageRotateAngle.rotateAngle180;
      section.pageSettings.size = const Size(500, 200);
      //Draw simple text on the page
      section.pages.add().graphics.drawString('Rotated by 180 degrees', font,
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      //Section - 4
      //Add section to the document
      section = document.sections!.add();
      //Create page settings to the section
      section.pageSettings.rotate = PdfPageRotateAngle.rotateAngle270;
      section.pageSettings.size = const Size(300, 200);
      //Draw simple text on the page
      section.pages.add().graphics.drawString('Rotated by 270 degrees', font,
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      //Save and dispose the PDF document
      savePdf(document.saveSync(),
          'UG_adding_sections_with_different_page_settings.pdf');
      document.dispose();
    });
    test('rotating pdf page', () {
      //Create a PDF document
      final PdfDocument document = PdfDocument();
      //Add section to the document
      PdfSection section = document.sections!.add();
      //Create page settings to the section
      section.pageSettings.rotate = PdfPageRotateAngle.rotateAngle180;
      section.pageSettings.size = PdfPageSize.a4;
      //Draw simple text on the page
      section.pages.add().graphics.drawString('Rotated by 180 degrees',
          PdfStandardFont(PdfFontFamily.helvetica, 14),
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      //Add section to the document
      section = document.sections!.add();
      //Create page settings to the section
      section.pageSettings.rotate = PdfPageRotateAngle.rotateAngle270;
      section.pageSettings.size = PdfPageSize.a4;
      //Draw simple text on the page
      section.pages.add().graphics.drawString('Rotated by 270 degrees',
          PdfStandardFont(PdfFontFamily.helvetica, 14),
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_rotating_pdf_page.pdf');
      document.dispose();
    });
  });
  group('UG-Working with Text', () {
    test('drawing text in pdf document', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw text
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 20),
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(10, 10, 300, 50));
      //Saves the document
      savePdf(document.saveSync(), 'UG_drawing_text_in_document.pdf');
      //Disposes the document
      document.dispose();
    });
    test('drawing text using standard fonts', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw text
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 16),
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(10, 10, 300, 50));
      //Saves the document
      savePdf(document.saveSync(), 'UG_drawing_text_standard_fonts.pdf');
      //Disposes the document
      document.dispose();
    });
    test('drawing text using true type font', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw text
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfTrueTypeFont.fromBase64String(arialTTF, 14),
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(10, 10, 300, 50));
      //Saves the document
      savePdf(document.saveSync(), 'UG_drawing_text_truetype_fonts.pdf');
      //Disposes the document
      document.dispose();
    });
    test('drawing text using cjk fonts', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create page and draw text
      document.pages.add().graphics.drawString(
          'こんにちは世界', PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 20),
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(10, 10, 300, 50));
      //Saves the document
      savePdf(document.saveSync(), 'UG_drawing_text_cjk_fonts.pdf');
      //Disposes the document
      document.dispose();
    });
    test('measure a string', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Set a standard font
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      const String text = 'Hello World!!!';
      //Measure the text
      final Size size = font.measureString(text);
      //Draw text
      document.pages.add().graphics.drawString(text, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(0, 0, size.width, size.height));
      //Saves the document
      savePdf(document.saveSync(), 'UG_measure_a_string.pdf');
      //Disposes the document
      document.dispose();
    });
    test('drawing right to left text', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Adds a page to the document
      final PdfPage page = document.pages.add();
      const String text =
          'سنبدأ بنظرة عامة مفاهيمية على مستند PDF بسيط. تم تصميم هذا الفصل ليكون توجيهًا مختصرًا قبل الغوص في مستند حقيقي وإنشاءه من البداية.\r\n \r\nيمكن تقسيم ملف PDF إلى أربعة أجزاء: الرأس والجسم والجدول الإسناد الترافقي والمقطورة. يضع الرأس الملف كملف PDF ، حيث يحدد النص المستند المرئي ، ويسرد جدول الإسناد الترافقي موقع كل شيء في الملف ، ويوفر المقطع الدعائي تعليمات حول كيفية بدء قراءة الملف.\r\n\r\nرأس الصفحة هو ببساطة رقم إصدار PDF وتسلسل عشوائي للبيانات الثنائية. البيانات الثنائية تمنع التطبيقات الساذجة من معالجة ملف PDF كملف نصي. سيؤدي ذلك إلى ملف تالف ، لأن ملف PDF يتكون عادةً من نص عادي وبيانات ثنائية (على سبيل المثال ، يمكن تضمين ملف خط ثنائي بشكل مباشر في ملف PDF).\r\n\r\nלאחר הכותרת והגוף מגיע טבלת הפניה המקושרת. הוא מתעדת את מיקום הבית של כל אובייקט בגוף הקובץ. זה מאפשר גישה אקראית של המסמך, ולכן בעת עיבוד דף, רק את האובייקטים הנדרשים עבור דף זה נקראים מתוך הקובץ. זה עושה מסמכי PDF הרבה יותר מהר מאשר קודמיו PostScript, אשר היה צריך לקרוא את כל הקובץ לפני עיבוד זה.';
      //Draw text
      page.graphics.drawString(
          text, PdfTrueTypeFont.fromBase64String(arialTTF, 14),
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: PdfStringFormat(
              textDirection: PdfTextDirection.rightToLeft,
              alignment: PdfTextAlignment.right,
              paragraphIndent: 35));
      //Saves the document
      savePdf(document.saveSync(), 'UG_drawing_right_to_left_text.pdf');
      //Disposes the document
      document.dispose();
    });
    test('creating multi column text_1', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Adds a page to the document
      final PdfPage page = document.pages.add();
      const String text =
          'Adventure Works Cycles, the fictitious company on which the AdventureWorks sample databases are based, is a large, multinational manufacturing company. The company manufactures and sells metal and composite bicycles to North American, European and Asian commercial markets. While its base operation is located in Washington with 290 employees, several regional sales teams are located throughout their market base.';
      //Create a text element with the text and font
      //Draw the text in the first column
      PdfTextElement(
              text: text, font: PdfStandardFont(PdfFontFamily.timesRoman, 14))
          .draw(
              page: page,
              bounds: Rect.fromLTWH(0, 0, page.getClientSize().width / 2,
                  page.getClientSize().height / 2));
      //Create a text element with the text and font
      //Draw the text in second column
      PdfTextElement(
              text: text, font: PdfStandardFont(PdfFontFamily.timesRoman, 14))
          .draw(
              page: page,
              bounds: Rect.fromLTWH(
                  page.getClientSize().width / 2,
                  0,
                  page.getClientSize().width / 2,
                  page.getClientSize().height / 2));
      //Saves the document
      savePdf(document.saveSync(), 'UG_multi_column_text_1.pdf');
      //Disposes the document
      document.dispose();
    });
    test('creating multi column text_2', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Adds a page to the document
      final PdfPage page = document.pages.add();
      const String text =
          'Adventure Works Cycles, the fictitious company on which the AdventureWorks sample databases are based, is a large, multinational manufacturing company. The company manufactures and sells metal and composite bicycles to North American, European and Asian commercial markets. While its base operation is located in Washington with 290 employees, several regional sales teams are located throughout their market base.';
      //Create a text element with the text and font
      final PdfTextElement textElement = PdfTextElement(
          text: text, font: PdfStandardFont(PdfFontFamily.timesRoman, 20));
      //Create layout format
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitPage);
      //Draw the first paragraph
      final PdfLayoutResult result = textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, 0, page.getClientSize().width / 2,
              page.getClientSize().height),
          format: layoutFormat)!;
      //Draw the second paragraph from the first paragraph end position
      textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 300,
              page.getClientSize().width / 2, page.getClientSize().height),
          format: layoutFormat);
      //Saves the document
      savePdf(document.saveSync(), 'UG_multi_column_text_2.pdf');
      //Disposes the document
      document.dispose();
    });
    test('Draw text with Pens and Brushes', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Add a new page and draw text using PdfPen and PdfSolidBrush
      document.pages.add().graphics.drawString(
          'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          pen: PdfPen(PdfColor(255, 0, 0), width: 0.5),
          bounds: const Rect.fromLTWH(0, 0, 500, 50));
      //Save the document
      savePdf(document.saveSync(), 'UG_text_with_pen_and_brush.pdf');
      //Dispose the document
      document.dispose();
    });
  });
  group('UG-Working with List', () {
    test('adding an ordered list', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create ordered list and draw on page
      PdfOrderedList(
              items: PdfListItemCollection(<String>[
                'Mammals',
                'Reptiles',
                'Birds',
                'Insects',
                'Aquatic Animals'
              ]),
              font: PdfStandardFont(PdfFontFamily.timesRoman, 20,
                  style: PdfFontStyle.italic),
              indent: 20,
              format: PdfStringFormat(lineSpacing: 10))
          .draw(
              page: document.pages.add(),
              bounds: const Rect.fromLTWH(0, 20, 0, 0));
      //Saves the document
      savePdf(document.saveSync(), 'UG_ordered_list.pdf');
      //Disposes the document
      document.dispose();
    });
    test('addding an unordered list', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create unordered list and draw list on page
      PdfUnorderedList(
              text: 'Mammals\nReptiles\nBirds\nInsects\nAquatic Animals',
              font: PdfStandardFont(PdfFontFamily.helvetica, 12),
              textIndent: 10,
              format: PdfStringFormat(lineSpacing: 10))
          .draw(
              page: document.pages.add(),
              bounds: const Rect.fromLTWH(0, 10, 0, 0));
      //Saves the document
      savePdf(document.saveSync(), 'UG_unordered_list.pdf');
      //Disposes the document
      document.dispose();
    });
    test('addind a sub list', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Adds a page to the document
      final PdfPage page = document.pages.add();
      //Create font
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 16);
      final PdfListItemCollection item =
          PdfListItemCollection(<String>['Mammals', 'Reptiles']);
      final PdfListItemCollection item_2 = PdfListItemCollection(<String>[
        'body covered by scales',
        'cold-blooded',
        'have a backbone',
        'most lay hard-shelled eggs on land',
      ]);
      final PdfListItemCollection item_3 = PdfListItemCollection(<String>[
        'body covered by scales',
        'cold-blooded',
        'have a backbone',
        'most lay hard-shelled eggs on land'
      ]);
      //Create a string format
      final PdfStringFormat format = PdfStringFormat(lineSpacing: 10);
      //Create ordered list
      final PdfOrderedList oList =
          PdfOrderedList(items: item, font: font, format: format);
      //Create ordered sub list
      oList.items[0].subList = PdfOrderedList(
          items: item_2, font: font, format: format, markerHierarchy: true);
      //Create ordered sub list
      oList.items[1].subList = PdfOrderedList(
          items: item_3, font: font, format: format, markerHierarchy: true);
      //Draw ordered list with sub list
      oList.draw(
          page: page,
          bounds: Rect.fromLTWH(
              0, 10, page.getClientSize().width, page.getClientSize().height));
      //Create unordered list
      final PdfUnorderedList uList =
          PdfUnorderedList(items: item, font: font, format: format);
      //Create unordered sub list
      uList.items[0].subList = PdfUnorderedList(
          items: item_2,
          font: font,
          format: format,
          style: PdfUnorderedMarkerStyle.circle);
      //Create unordered sub list
      uList.items[1].subList = PdfUnorderedList(
          items: item_3,
          font: font,
          format: format,
          style: PdfUnorderedMarkerStyle.circle);
      //Draw unordered list with sub list
      uList.draw(
          page: page,
          bounds: Rect.fromLTWH(
              0, 400, page.getClientSize().width, page.getClientSize().height));
      //Saves the document
      savePdf(document.saveSync(), 'UG_sub_list.pdf');
      //Disposes the document
      document.dispose();
    });
  });
  group('UG-Working with Images', () {
    test('inserting an image in document', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Adds a page to the document
      final PdfPage page = document.pages.add();
      //Draw the image
      page.graphics.drawImage(
          PdfBitmap.fromBase64String(imageJpeg),
          Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height));
      //Saves the document
      savePdf(document.saveSync(), 'UG_inserting_an_image.pdf');
      //Disposes the document
      document.dispose();
    });
    test('apply transparency and rotation to image', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Adds a page to the document
      final PdfPage page = document.pages.add();
      //Save the current graphics state
      final PdfGraphicsState state = page.graphics.save();
      //Translate the coordinate system to the  required position
      page.graphics.translateTransform(20, 100);
      //Apply transparency
      page.graphics.setTransparency(0.5);
      //Rotate the coordinate system
      page.graphics.rotateTransform(-45);
      //Draw image
      page.graphics.drawImage(
          PdfBitmap.fromBase64String(imageJpeg),
          Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height));
      //Restore the graphics state
      page.graphics.restore(state);
      //Saves the document
      savePdf(document.saveSync(), 'UG_applying_transparency_and_rotation.pdf');
      //Disposes the document
      document.dispose();
    });
  });
  group('UG-Working with Shapes', () {
    test('adding a polygon', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw a polygon on PDF document
      document.pages.add().graphics.drawPolygon(<Offset>[
        const Offset(10, 100),
        const Offset(10, 200),
        const Offset(100, 100),
        const Offset(55, 150)
      ], pen: PdfPens.black, brush: PdfSolidBrush(PdfColor(165, 42, 42)));
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_Polygon.pdf');
      //Dispose the document
      document.dispose();
    });
    test('adding a line', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw a line on PDF document
      document.pages.add().graphics.drawLine(
          PdfPen(PdfColor(165, 42, 42), width: 5),
          const Offset(10, 100),
          const Offset(10, 200));
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_line.pdf');
      //Dispose the document
      document.dispose();
    });
    test('adding a curve', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create an instance of Bezier curve
      final PdfBezierCurve bezier = PdfBezierCurve(const Offset(100, 10),
          const Offset(150, 50), const Offset(50, 80), const Offset(100, 10));
      //Draw a Bezier curve
      bezier.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(200, 100, 0, 0));
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_curve.pdf');
      //Dispose the document
      document.dispose();
    });
    test('adding a path', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create an instance of the path
      final PdfPath path = PdfPath();
      //Add the lines to draw path
      path.addLine(const Offset(10, 100), const Offset(10, 200));
      path.addLine(const Offset(100, 100), const Offset(100, 200));
      path.addLine(const Offset(100, 200), const Offset(55, 150));
      //Draw the path
      path.draw(page: document.pages.add(), bounds: Rect.zero);
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_path.pdf');
      //Dispose the document
      document.dispose();
    });
    test('adding a rectangle', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw the rectangle on PDF document
      document.pages.add().graphics.drawRectangle(
          brush: PdfBrushes.chocolate,
          bounds: const Rect.fromLTWH(10, 10, 100, 50));
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_rectangle.pdf');
      //Dispose the document
      document.dispose();
    });
    test('adding a pie', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw a pie on page
      document.pages.add().graphics.drawPie(
          const Rect.fromLTWH(10, 50, 200, 200), 90, 180,
          pen: PdfPen(PdfColor(165, 42, 42), width: 5),
          brush: PdfBrushes.green);
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_pie.pdf');
      //Dispose the document
      document.dispose();
    });
    test('adding a arc', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw arc on page
      document.pages.add().graphics.drawArc(
          const Rect.fromLTWH(100, 140, 200, 400), 70, 190,
          pen: PdfPen(PdfColor(165, 42, 42), width: 5));
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_arc.pdf');
      //Dispose the document
      document.dispose();
    });
    test('adding a bezier', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw Bezier on page
      document.pages.add().graphics.drawBezier(const Offset(100, 10),
          const Offset(150, 50), const Offset(50, 80), const Offset(100, 10),
          pen: PdfPen(PdfColor(165, 42, 42)));
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_bezier.pdf');
      //Dispose the document
      document.dispose();
    });
    test('adding a ellipse', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Draw an Ellipse on page
      document.pages.add().graphics.drawEllipse(
          const Rect.fromLTWH(10, 200, 450, 150),
          pen: PdfPen(PdfColor(165, 42, 42), width: 5),
          brush: PdfBrushes.darkOrange);
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_ellipse.pdf');
      //Dispose the document
      document.dispose();
    });
  });

  group('UG-Working with Hyperlinks', () {
    test('web navigation', () {
      //Create a new Pdf document
      final PdfDocument document = PdfDocument();
      //Create and draw the web link in the PDF page
      PdfTextWebLink(
              url: 'www.google.co.in',
              text: 'google',
              font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
              brush: PdfSolidBrush(PdfColor(0, 0, 0)),
              pen: PdfPens.brown,
              format: PdfStringFormat(
                  alignment: PdfTextAlignment.center,
                  lineAlignment: PdfVerticalAlignment.middle))
          .draw(document.pages.add(), const Offset(50, 40));
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_web_navigation.pdf');
      //Dispose document
      document.dispose();
    });
    test('internal document navigation', () {
      //Create a new Pdf document
      final PdfDocument document = PdfDocument();
      //Create a page
      final PdfPage page = document.pages.add();
      //Create a document link
      final PdfDocumentLinkAnnotation docLink = PdfDocumentLinkAnnotation(
          const Rect.fromLTWH(10, 40, 30, 30),
          PdfDestination(document.pages.add(), const Offset(10, 0)));
      //Set the destination mode
      docLink.destination!.mode = PdfDestinationMode.fitToPage;
      //Add the document link to the page
      page.annotations.add(docLink);
      //Save the PDF document
      savePdf(document.saveSync(), 'UG_internal_document_navigation.pdf');
      //Dispose document
      document.dispose();
    });
  });
  group('UG-Working with Headers and Footers', () {
    test('adding graphics and automatic fields to header and footers', () {
      //Create a new pdf document
      final PdfDocument document = PdfDocument();
      //Add the pages to the document
      for (int i = 1; i <= 5; i++) {
        document.pages.add().graphics.drawString(
            'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
            bounds: const Rect.fromLTWH(250, 0, 615, 100));
      }
      //Create the header with specific bounds
      final PdfPageTemplateElement header = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 300));
      //Create the date and time field
      final PdfDateTimeField dateAndTimeField = PdfDateTimeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
      //Create the composite field with date field
      final PdfCompositeField compositefields = PdfCompositeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          text: '{0}      Header',
          fields: <PdfAutomaticField>[dateAndTimeField]);
      //Add composite field in header
      compositefields.draw(header.graphics,
          Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
      //Add the header at top of the document
      document.template.top = header;
      //Create the footer with specific bounds
      final PdfPageTemplateElement footer = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));
      //Create the page number field
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      //Sets the number style for page number
      pageNumber.numberStyle = PdfNumberStyle.upperRoman;
      //Create the page count field
      final PdfPageCountField count = PdfPageCountField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      //set the number style for page count
      count.numberStyle = PdfNumberStyle.upperRoman;
      //Create the date and time field
      final PdfDateTimeField dateTimeField = PdfDateTimeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      //Sets the date and time
      dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      //Sets the date and time format
      dateTimeField.dateFormatString = "hh':'mm':'ss";
      //Create the composite field with page number page count
      final PdfCompositeField compositeField = PdfCompositeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          text: 'Page {0} of {1}, Time:{2}',
          fields: <PdfAutomaticField>[pageNumber, count, dateTimeField]);
      compositeField.bounds = footer.bounds;
      //Add the composite field in footer
      compositeField.draw(
          footer.graphics,
          Offset(
              290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
      //Add the footer at the bottom of the document
      document.template.bottom = footer;
      //Save the PDF document
      savePdf(
          document.saveSync(), 'UG_adding_graphics_and_automatic_fields.pdf');
      //Dispose document
      document.dispose();
    });
  });
  group('UG-Working with Bookmarks', () {
    test('adding bookmarks to pdf', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Creates document bookmark
      final PdfBookmark bookmark = document.bookmarks.add('page 1');
      //Sets the destination page and destination location
      bookmark.destination =
          PdfDestination(document.pages.add(), const Offset(100, 100));
      //Sets the text style
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      //Sets the bookmark color(RGB)
      bookmark.color = PdfColor(255, 0, 0);
      //Save the document
      savePdf(document.saveSync(), 'UG_adding_bookmark.pdf');
      //Dispose the document
      document.dispose();
    });
    test('adding a child to the bookmarks', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Add a page
      final PdfPage page = document.pages.add();
      //Creates document bookmark
      final PdfBookmark bookmark = document.bookmarks.add('page 1');
      //Inserts the child bookmark
      final PdfBookmark childBookmark1 = bookmark.insert(0, 'heading 1');
      //Adds the child bookmark
      final PdfBookmark childBookmark2 = bookmark.add('heading 2');
      //Sets the text style
      childBookmark1.textStyle = <PdfTextStyle>[
        PdfTextStyle.bold,
        PdfTextStyle.italic
      ];
      childBookmark2.textStyle = <PdfTextStyle>[PdfTextStyle.italic];
      //Sets the destination page and destination location
      childBookmark1.destination = PdfDestination(page, const Offset(100, 100));
      childBookmark2.destination = PdfDestination(page, const Offset(100, 400));
      //Sets the bookmark color(RGB)
      childBookmark1.color = PdfColor(0, 255, 0);
      childBookmark2.color = PdfColor(0, 0, 255);
      //Saves the bookmark
      savePdf(document.saveSync(), 'UG_adding_child_bookmark.pdf');
      //Dispose the document
      document.dispose();
    });
  });
  group('UG-Working with Watermarks', () {
    test('adding text watermarks', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Add a page to the document and get page graphics
      final PdfGraphics graphics = document.pages.add().graphics;
      //Watermark text
      final PdfGraphicsState state = graphics.save();
      graphics.setTransparency(0.25);
      graphics.rotateTransform(-40);
      graphics.drawString('Imported using Essential PDF',
          PdfStandardFont(PdfFontFamily.helvetica, 20),
          pen: PdfPens.red,
          brush: PdfBrushes.red,
          bounds: const Rect.fromLTWH(-150, 450, 0, 0));
      graphics.restore(state);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_text_watermark.pdf');
      document.dispose();
    });
    test('adding image watermarks', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Add a page to the document and get page graphics
      final PdfGraphics graphics = document.pages.add().graphics;
      //Watermark image
      final PdfGraphicsState state = graphics.save();
      graphics.setTransparency(0.25);
      graphics.drawImage(
          PdfBitmap.fromBase64String(alphaPng),
          Rect.fromLTWH(
              0, 0, graphics.clientSize.width, graphics.clientSize.height));
      graphics.restore(state);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_image_watermark.pdf');
    });
  });
  group('UG-Working with tables', () {
    test('creating a table_1', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create a PdfGrid class
      final PdfGrid grid = PdfGrid();
      //Add the columns to the grid
      grid.columns.add(count: 3);
      //Add header to the grid
      grid.headers.add(1);
      //Add the rows to the grid
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Employee ID';
      header.cells[1].value = 'Employee Name';
      header.cells[2].value = 'Salary';
      //Add rows to grid
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = 'E01';
      row.cells[1].value = 'Clay';
      row.cells[2].value = r'$10,000';
      row = grid.rows.add();
      row.cells[0].value = 'E02';
      row.cells[1].value = 'Simon';
      row.cells[2].value = r'$12,000';
      //Set the grid style
      grid.style = PdfGridStyle(
          cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
          backgroundBrush: PdfBrushes.blue,
          textBrush: PdfBrushes.white,
          font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
      //Draw the grid
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_creating_table_1.pdf');
      document.dispose();
    });
    test('creating a table_2', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create a PdfGrid
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'ID';
      header.cells[1].value = 'Name';
      header.cells[2].value = 'Salary';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'E01';
      row1.cells[1].value = 'Clay';
      row1.cells[2].value = r'$10,000';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'E02';
      row2.cells[1].value = 'Thomas';
      row2.cells[2].value = r'$10,500';
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = 'E02';
      row3.cells[1].value = 'Simon';
      row3.cells[2].value = r'$12,000';
      //Draw the grid in PDF document
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_creating_table_2.pdf');
      document.dispose();
    });
    test('cell customization in grid', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create a PdfGrid
      final PdfGrid grid = PdfGrid();
      //Add columns to grid
      grid.columns.add(count: 3);
      //Add headers to grid
      final PdfGridRow header = grid.headers.add(1)[0];
      header.cells[0].value = 'Employee ID';
      header.cells[1].value = 'Employee Name';
      header.cells[2].value = 'Salary';
      //Add the styles to specific cell
      header.cells[0].style.stringFormat = PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.bottom,
          wordSpacing: 10);
      header.cells[1].style.textPen = PdfPens.mediumVioletRed;
      header.cells[2].style.backgroundBrush = PdfBrushes.yellow;
      header.cells[2].style.textBrush = PdfBrushes.darkOrange;
      //Add rows to grid
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'E01';
      row1.cells[1].value = 'Clay';
      row1.cells[2].value = r'$10,000';
      //Apply the cell style to specific row cells
      row1.cells[0].style = PdfGridCellStyle(
        backgroundBrush: PdfBrushes.lightYellow,
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
        textBrush: PdfBrushes.white,
        textPen: PdfPens.orange,
      );
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'E02';
      row2.cells[1].value = 'Simon';
      row2.cells[2].value = r'$12,000';
      //Add the style to specific cell
      row2.cells[2].style.borders = PdfBorders(
          left: PdfPen(PdfColor(240, 0, 0), width: 2),
          top: PdfPen(PdfColor(0, 240, 0), width: 3),
          bottom: PdfPen(PdfColor(0, 0, 240), width: 4),
          right: PdfPen(PdfColor(240, 100, 240), width: 5));
      //Draw the grid in PDF document page
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_cell_customization_grid.pdf');
      document.dispose();
    });
    test('row customization grid', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create a PdfGrid
      final PdfGrid grid = PdfGrid();
      //Add columns to grid
      grid.columns.add(count: 3);
      //Add headers to grid
      grid.headers.add(2);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Employee ID';
      header.cells[1].value = 'Employee Name';
      header.cells[2].value = 'Salary';
      //Add rows to grid
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'E01';
      row1.cells[1].value = 'Clay';
      row1.cells[2].value = r'$10,000';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'E02';
      row2.cells[1].value = 'Simon';
      row2.cells[2].value = r'$12,000';
      //Set the row span
      row1.cells[1].rowSpan = 2;
      //Set the row height
      row2.height = 20;
      //Set the row style
      row1.style = PdfGridRowStyle(
          backgroundBrush: PdfBrushes.dimGray,
          textPen: PdfPens.lightGoldenrodYellow,
          textBrush: PdfBrushes.darkOrange,
          font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
      //Create the PDF grid row style. Assign to second row
      final PdfGridRowStyle rowStyle = PdfGridRowStyle(
          backgroundBrush: PdfBrushes.lightGoldenrodYellow,
          textPen: PdfPens.indianRed,
          textBrush: PdfBrushes.lightYellow,
          font: PdfStandardFont(PdfFontFamily.timesRoman, 12));
      row2.style = rowStyle;
      //Draw the grid in PDF document page
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_row_customization_grid.pdf');
      document.dispose();
    });
    test('column customization grid', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create a PdfGrid
      final PdfGrid grid = PdfGrid();
      //Add columns to grid
      grid.columns.add(count: 3);
      //Add headers to grid
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Employee ID';
      header.cells[1].value = 'Employee Name';
      header.cells[2].value = 'Salary';
      //Add rows to grid
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'E01';
      row1.cells[1].value = 'Clay';
      row1.cells[2].value = r'$10,000';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'E02';
      row2.cells[1].value = 'Simon';
      row2.cells[2].value = r'$12,000';
      //Set the width
      grid.columns[1].width = 50;
      //Create and customize the string formats
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.center;
      format.lineAlignment = PdfVerticalAlignment.bottom;
      //Set the column text format
      grid.columns[0].format = format;
      //Draw the grid in PDF document page
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_column_customization_grid.pdf');
      document.dispose();
    });
    test('table customization grid', () {
      //Create a new Pdf document
      final PdfDocument document = PdfDocument();
      //Create a string format
      final PdfStringFormat format = PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.bottom,
          wordSpacing: 10);
      //Create a cell style
      final PdfGridCellStyle cellStyle = PdfGridCellStyle(
        backgroundBrush: PdfBrushes.lightYellow,
        borders: PdfBorders(
            left: PdfPen(PdfColor(240, 0, 0), width: 2),
            top: PdfPen(PdfColor(0, 240, 0), width: 3),
            bottom: PdfPen(PdfColor(0, 0, 240), width: 4),
            right: PdfPen(PdfColor(240, 100, 240), width: 5)),
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
        format: format,
        textBrush: PdfBrushes.white,
        textPen: PdfPens.orange,
      );
      //Create a grid style
      final PdfGridStyle gridStyle = PdfGridStyle(
        cellSpacing: 2,
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        borderOverlapStyle: PdfBorderOverlapStyle.inside,
        backgroundBrush: PdfBrushes.lightGray,
        textPen: PdfPens.black,
        textBrush: PdfBrushes.white,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 17),
      );
      //Create a grid
      final PdfGrid grid = PdfGrid();
      //Adds the columns to the grid
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Employee Id';
      header.cells[1].value = 'Employee name';
      header.cells[2].value = 'Employee role';
      //Apply the grid style
      grid.rows.applyStyle(gridStyle);
      //Add rows to grid. Set the cells style
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'E01';
      row1.cells[1].value = 'Clay';
      row1.cells[2].value = 'Product manager';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'E02';
      row2.cells[1].value = 'Thomas';
      row2.cells[2].value = 'Software engineer';
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = 'E03';
      row3.cells[1].value = 'Albert';
      row3.cells[2].value = 'Test engineer';
      //Set the row cells style
      for (int i = 0; i < grid.columns.count; i++) {
        row1.cells[i].style = cellStyle;
        row2.cells[i].style = cellStyle;
        row3.cells[i].style = cellStyle;
      }
      //Draw the grid in PDF document page
      grid.draw(page: document.pages.add(), bounds: Rect.zero);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_table_customization_grid.pdf');
      document.dispose();
    });
    test('pagination in grid', () {
      //Create a new PDF documentation
      final PdfDocument document = PdfDocument();
      //Create a PdfGrid
      final PdfGrid grid = PdfGrid();
      //Add the columns to the grid
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Name';
      header.cells[1].value = 'Age';
      header.cells[2].value = 'Sex';
      //Add rows to grid. Set the cells style
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Bob';
      row1.cells[1].value = '22';
      row1.cells[2].value = 'Male';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Sam';
      row2.cells[1].value = '23';
      row2.cells[2].value = 'Male';
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = 'Falitha';
      row3.cells[1].value = '19';
      row3.cells[2].value = 'Female';
      //Create a PdfLayoutFormat for pagination
      final PdfLayoutFormat format = PdfLayoutFormat(
          breakType: PdfLayoutBreakType.fitColumnsToPage,
          layoutType: PdfLayoutType.paginate);
      //Draw the grid in PDF document page
      grid.draw(page: document.pages.add(), bounds: Rect.zero, format: format);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_pagination_grid.pdf');
      document.dispose();
    });
    test('adding multiple table', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Create a PdfGrid
      final PdfGrid grid = PdfGrid();
      //Add the columns to the grid
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Product Id';
      header.cells[1].value = 'Product name';
      header.cells[2].value = 'Price';
      //Add rows to grid
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'P01';
      row1.cells[1].value = 'Water bottle';
      row1.cells[2].value = 'Rs: 100';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'P02';
      row2.cells[1].value = 'Trimmer';
      row2.cells[2].value = 'Rs: 1200';
      //Draw grid on the page of PDF document and store the grid position in PdfLayoutResult
      final PdfLayoutResult result = grid.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(0, 0, 400, 300))!;
      //Create a second PdfGrid in the same page
      final PdfGrid grid2 = PdfGrid();
      //Add columns to second grid
      grid2.columns.add(count: 3);
      grid2.headers.add(1);
      final PdfGridRow header1 = grid2.headers[0];
      header1.cells[0].value = 'Employee ID';
      header1.cells[1].value = 'Employee Name';
      header1.cells[2].value = 'Salary';
      //Add rows to grid
      final PdfGridRow row11 = grid2.rows.add();
      row11.cells[0].value = 'E01';
      row11.cells[1].value = 'Clay';
      row11.cells[2].value = r'$10,000';
      final PdfGridRow row12 = grid2.rows.add();
      row12.cells[0].value = 'E02';
      row12.cells[1].value = 'Simon';
      row12.cells[2].value = r'$12,000';
      //Draw the grid in PDF document page
      grid2.draw(
          page: result.page,
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 20, 400, 300));
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_multiple_tables.pdf');
      document.dispose();
    });
  });
  group('UG-Working with Flow Layout', () {
    test('flow model using pdfLayoutResult', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Add a page to the document
      final PdfPage page = document.pages.add();
      //Draw image on the page in the specified location and with required size
      page.graphics.drawImage(PdfBitmap.fromBase64String(imageJpeg),
          const Rect.fromLTWH(150, 30, 200, 100));
      //Load the paragraph text into PdfTextElement with standard font
      final PdfTextElement textElement = PdfTextElement(
          text:
              'Adventure Works Cycles, the fictitious company on which the AdventureWorks sample databases are based, is a large, multinational manufacturing company. The company manufactures and sells metal and composite bicycles to North American, European and Asian commercial markets. While its base operation is located in Bothell, Washington with 290 employees, several regional sales teams are located throughout their market base.',
          font: PdfStandardFont(PdfFontFamily.helvetica, 12));
      //Draw the paragraph text on page and maintain the position in PdfLayoutResult
      PdfLayoutResult layoutResult = textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, 150, page.getClientSize().width,
              page.getClientSize().height))!;
      //Assign header text to PdfTextElement
      textElement.text = 'Top 5 sales stores';
      //Assign standard font to PdfTextElement
      textElement.font = PdfStandardFont(PdfFontFamily.helvetica, 14,
          style: PdfFontStyle.bold);
      //Draw the header text on page, below the paragraph text with a height gap of 20 and maintain the position in PdfLayoutResult
      layoutResult = textElement.draw(
          page: page,
          bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 20, 0, 0))!;
      //Initialize PdfGrid for drawing the table
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'ID';
      header.cells[1].value = 'Name';
      header.cells[2].value = 'Salary';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'E01';
      row1.cells[1].value = 'Clay';
      row1.cells[2].value = r'$10,000';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'E02';
      row2.cells[1].value = 'Thomas';
      row2.cells[2].value = r'$10,500';
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = 'E02';
      row3.cells[1].value = 'Simon';
      row3.cells[2].value = r'$12,000';
      //Draws the grid
      grid.draw(
          page: page,
          bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 20, 0, 0));
      //Saves the document
      savePdf(document.saveSync(), 'UG_flow_model.pdf');
      //Disposes the document
      document.dispose();
    });
  });
  group('UG-Working with Templates', () {
    test('creating new template', () {
      //Create a new PDF document.
      final PdfDocument document = PdfDocument();
      //Create a PDF Template.
      final PdfTemplate template = PdfTemplate(100, 50);
      //Draw a rectangle on the template graphics
      template.graphics!.drawRectangle(
          brush: PdfBrushes.burlyWood,
          bounds: const Rect.fromLTWH(0, 0, 100, 50));
      //Draw a string using the graphics of the template.
      template.graphics!.drawString(
          'Hello World', PdfStandardFont(PdfFontFamily.helvetica, 14),
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(5, 5, 0, 0));
      //Add a new page and draw the template on the page graphics of the document.
      document.pages.add().graphics.drawPdfTemplate(template, Offset.zero);
      //Save and dispose the PDF document
      savePdf(document.saveSync(), 'UG_creating_new_template.pdf');
      document.dispose();
    });
    test('working with PdfPageTemplateElement', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Add a page to the PDF document
      final PdfPage page = document.pages.add();
      final Rect bounds = Rect.fromLTWH(0, 0, page.getClientSize().width, 50);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 7);
      //Create a header and draw the image
      final PdfPageTemplateElement header = PdfPageTemplateElement(bounds);
      //Draw the image in the header
      header.graphics.drawImage(PdfBitmap.fromBase64String(imageJpeg),
          const Rect.fromLTWH(0, 0, 100, 50));
      //Add the header at the top
      document.template.top = header;
      //Create a Page template that can be used as footer
      final PdfPageTemplateElement footer = PdfPageTemplateElement(bounds);
      //Add the fields in composite fields
      final PdfCompositeField compositeField = PdfCompositeField(
          font: font,
          brush: PdfBrushes.black,
          text: 'Page {0} of {1}',
          fields: <PdfAutomaticField>[
            PdfPageNumberField(font: font, brush: PdfBrushes.black),
            PdfPageCountField(font: font, brush: PdfBrushes.black)
          ]);
      compositeField.bounds = footer.bounds;
      //Draw the composite field in footer
      compositeField.draw(footer.graphics, const Offset(470, 40));
      //Add the footer template at the bottom
      document.template.bottom = footer;
      //Save and dispose the PDF document
      savePdf(
          document.saveSync(), 'UG_working_with_PdfPageTemplateElement.pdf');
    });
    test('adding stamp to the PDF document', () {
      //Create a new PDF document
      final PdfDocument document = PdfDocument();
      //Add a page to the PDF document
      final PdfPage page = document.pages.add();
      //Create template and draw text in template graphics
      final PdfPageTemplateElement custom =
          PdfPageTemplateElement(Offset.zero & page.getClientSize(), page);
      custom.dock = PdfDockStyle.fill;
      final PdfGraphicsState state = custom.graphics.save();
      custom.graphics.rotateTransform(-40);
      custom.graphics.drawString(
          'STAMP PDF DOCUMENT', PdfStandardFont(PdfFontFamily.helvetica, 20),
          pen: PdfPens.red,
          brush: PdfBrushes.red,
          bounds: const Rect.fromLTWH(-150, 450, 400, 400));
      custom.graphics.restore(state);
      //Add template as a stamp to the PDF document
      document.template.stamps.add(custom);
      //Draw rectangle to the page graphics
      page.graphics.drawRectangle(
          pen: PdfPen(PdfColor(0, 0, 0), width: 5),
          brush: PdfBrushes.lightGray,
          bounds: Offset.zero & page.getClientSize());
      //Save the document
      savePdf(document.saveSync(), 'UG_adding_stamp.pdf');
      //Dispose the document
      document.dispose();
    });
  });
}
