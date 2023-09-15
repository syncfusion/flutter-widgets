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
void crossReferenceStream() {
  group('Cross reference stream', () {
    test('test case 1', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      //Set the type of the PDF cross reference.
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      //Create page and draw text.
      document.pages.add().graphics.drawString(
          'Hello World, \n Wowwww, welcome to cross reference stream',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfBrushes.black,
          bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw hello world in cross reference stream');
      savePdf(bytes, 'FLUT-1417-CrossRefernceStream.pdf');
      document.dispose();
    });
  });

  group('Cross reference stream', () {
    test('test case 2', () {
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      final PdfPage page = document.pages.add();
      final PdfBezierCurve bezier = PdfBezierCurve(const Offset(100, 10),
          const Offset(150, 50), const Offset(50, 80), const Offset(100, 10));
      bezier.draw(page: page, bounds: const Rect.fromLTWH(200, 100, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw cross reference stream test case 2');
      savePdf(bytes, 'FLUT-1417-CrossRefernceStream2.pdf');
      document.dispose();
    });
  });

  group('Cross reference stream', () {
    test('test case 3', () {
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(165, 42, 42));
      final List<Offset> points = <Offset>[
        const Offset(10, 100),
        const Offset(10, 200),
        const Offset(100, 100),
        const Offset(100, 200),
        const Offset(55, 150)
      ];
      page.graphics.drawPolygon(points, pen: PdfPens.black, brush: brush);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw cross reference stream test case 3');
      savePdf(bytes, 'FLUT-1417-CrossRefernceStream3.pdf');
      document.dispose();
    });
  });

  group('Cross reference stream', () {
    test('test case 4', () {
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
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

      final PdfGridBuiltInStyleSettings tableStyleOption =
          PdfGridBuiltInStyleSettings();
      tableStyleOption.applyStyleForBandedRows = true;
      tableStyleOption.applyStyleForHeaderRow = true;

      //Apply built-in table style
      grid.applyBuiltInStyle(PdfGridBuiltInStyle.plainTable1,
          settings: tableStyleOption);

      grid.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw built-in plain table style1');
      savePdf(bytes, 'FLUT-824-plainTable1.pdf');
    });

    test('plain table style 2', () {
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
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

      final PdfGridBuiltInStyleSettings tableStyleOption =
          PdfGridBuiltInStyleSettings();
      tableStyleOption.applyStyleForBandedRows = true;
      tableStyleOption.applyStyleForHeaderRow = true;

      //Apply built-in table style
      grid.applyBuiltInStyle(PdfGridBuiltInStyle.plainTable2,
          settings: tableStyleOption);

      grid.draw(
          page: document.pages.add(),
          bounds: const Rect.fromLTWH(10, 10, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw cross reference stream test case 2');
      savePdf(bytes, 'FLUT-1417-CrossRefernceStream4.pdf');
      document.dispose();
    });
  });

  group('Cross reference stream', () {
    test('test case 5', () {
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 11);
      final PdfFont font1 = PdfStandardFont(PdfFontFamily.timesRoman, 19);
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfPage page1 = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      page1.graphics.drawString('page1', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page2.graphics.drawString('page2', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      page3.graphics.drawString('page3', font,
          bounds: const Rect.fromLTWH(250, 0, 615, 100));
      final PdfPageTemplateElement templateElement =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
      final PdfCompositeField compositeField = PdfCompositeField(
          font: font1,
          brush: brush,
          text: 'Composite field text can be drawn with the template graphics');
      compositeField.bounds = templateElement.bounds;
      compositeField.draw(templateElement.graphics);
      document.template.bottom = templateElement;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to draw cross reference stream test case 5');
      savePdf(bytes, 'FLUT-1417-CrossRefernceStream5.pdf');
      document.dispose();
    });
  });

  group('Cross reference stream with sample Browser: Sample', () {
    test('Header and Footer', () {
      //Create PDF document.
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      //Create a header template and draw image/text.
      final PdfPageTemplateElement headerElement =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
      headerElement.graphics.drawString(
          'This is page header', PdfStandardFont(PdfFontFamily.helvetica, 10),
          bounds: const Rect.fromLTWH(0, 0, 515, 50),
          format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      headerElement.graphics.setTransparency(0.6);
      headerElement.graphics.drawString(
          'PDF Succinctly', PdfStandardFont(PdfFontFamily.helvetica, 10),
          bounds: const Rect.fromLTWH(0, 0, 515, 50),
          format: PdfStringFormat(
              alignment: PdfTextAlignment.right,
              lineAlignment: PdfVerticalAlignment.middle));
      headerElement.graphics
          .drawLine(PdfPens.gray, const Offset(0, 49), const Offset(515, 49));
      document.template.top = headerElement;
      //Create a footer template and draw a text.
      final PdfPageTemplateElement footerElement =
          PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
      footerElement.graphics.drawString(
        'This is page footer',
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        bounds: const Rect.fromLTWH(0, 35, 515, 50),
      );
      footerElement.graphics.setTransparency(0.6);
      PdfCompositeField(text: 'Page {0} of {1}', fields: <PdfAutomaticField>[
        PdfPageNumberField(brush: PdfBrushes.black),
        PdfPageCountField(brush: PdfBrushes.black)
      ]).draw(footerElement.graphics, const Offset(450, 35));
      document.template.bottom = footerElement;
      //Add page and draw text.
      final PdfPage page = document.pages.add();
      //Create font
      final PdfStandardFont h1Font = PdfStandardFont(
          PdfFontFamily.helvetica, 25,
          style: PdfFontStyle.bold);
      final PdfStandardFont contentFont = PdfStandardFont(
          PdfFontFamily.helvetica, 17,
          style: PdfFontStyle.regular);
      //Get the page client size
      final Size size = page.getClientSize();
      //Create a text element and draw it to the page
      PdfLayoutResult? result = PdfTextElement(
              text: 'PDF Succinctly',
              font: PdfStandardFont(PdfFontFamily.helvetica, 30,
                  style: PdfFontStyle.bold),
              brush: PdfBrushes.red,
              format: PdfStringFormat(alignment: PdfTextAlignment.center))
          .draw(
              page: page,
              bounds: Rect.fromLTWH(0, 30, size.width, size.height - 30));

      result = PdfTextElement(text: 'Introduction', font: h1Font).draw(
          page: page,
          bounds: Rect.fromLTWH(0, result!.bounds.bottom + 30, size.width,
              size.height - result.bounds.bottom + 30));

      result = PdfTextElement(
              text:
                  "Adobe Systems Incorporated's Portable Document Format (PDF) is the de facto standard for the accurate, reliable, and platform-independent representation of a paged document. It's the only universally accepted file format that allows pixel-perfect layouts. In addition, PDF supports user interaction and collaborative workflows that are not possible with printed documents.\r\n\r\nPDF documents have been in widespread use for years, and dozens of free and commercial PDF readers, editors, and libraries are readily available. However, despite this popularity, it's still difficult to find a succinct guide to the native PDF format. Understanding the internal workings of a PDF makes it possible to dynamically generate PDF documents. For example, a web server can extract information from a database, use it to customize an invoice, and serve it to the customer on the fly.",
              font: contentFont)
          .draw(
              page: result!.page,
              bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
                  size.height - result.bounds.bottom + 30));

      result = PdfTextElement(text: 'The PDF Standard', font: h1Font).draw(
          page: result!.page,
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
              size.height - result.bounds.bottom + 30),
          format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));

      result = PdfTextElement(
              text:
                  'The PDF format is an open standard maintained by the International Organization for Standardization. The official specification is defined in ISO 32000-1:2008, but Adobe also provides a free, comprehensive guide called PDF Reference, Sixth Edition, version 1.7.',
              font: contentFont)
          .draw(
              page: result!.page,
              bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
                  size.height - result.bounds.bottom + 30),
              format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
      final PdfTextElement element =
          PdfTextElement(text: 'Conceptual Overview', font: h1Font);
      result = element.draw(
          page: result!.page,
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
              size.height - result.bounds.bottom + 30),
          format: PdfLayoutFormat(
              paginateBounds:
                  Rect.fromLTWH(0, 30, size.width, size.height - 30)));
      result = PdfTextElement(
              text:
                  "We'll begin with a conceptual overview of a simple PDF document. This chapter is designed to be a brief orientation before diving in and creating a real document from scratch. A PDF file can be divided into four parts: a header, body, cross-reference table, and trailer. The header marks the file as a PDF, the body defines the visible document, the cross-reference table lists the location of everything in the file, and the trailer provides instructions for how to start reading the file.",
              font: contentFont)
          .draw(
              page: result!.page,
              bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
                  size.height - result.bounds.bottom + 30));
      //Save and dispose
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve header and footer sample');
      document.dispose();
      savePdf(bytes, 'SB_header_and_footer.pdf');
    });
    test('Bookmarks', () {
      PdfLayoutResult? addParagraph(
          PdfPage page, String text, Rect bounds, bool isTitle,
          {bool subTitle = false}) {
        return PdfTextElement(
          text: text,
          font: PdfStandardFont(
              PdfFontFamily.helvetica,
              isTitle
                  ? subTitle
                      ? 16
                      : 18
                  : 13,
              style: isTitle ? PdfFontStyle.bold : PdfFontStyle.regular),
        ).draw(
            page: page,
            bounds: Rect.fromLTWH(
                bounds.left, bounds.top, bounds.width, bounds.height));
      }

      PdfBookmark addBookmark(PdfPage page, String text, Offset point,
          {PdfDocument? doc, PdfBookmark? bookmark, PdfColor? color}) {
        PdfBookmark? book;
        if (doc != null) {
          book = doc.bookmarks.add(text);
          book.destination = PdfDestination(page, point);
        } else {
          book = bookmark!.add(text);
          book.destination = PdfDestination(page, point);
        }
        book.color = color ?? PdfColor(0, 0, 0);
        return book;
      }

      //Create a PDF document
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      //Add a new PDF page
      final PdfPage page = document.pages.add();

      final Size pageSize = page.getClientSize();
      //Draw string.
      page.graphics.drawString(
          'PDF Succinctly', PdfStandardFont(PdfFontFamily.helvetica, 30),
          brush: PdfBrushes.red,
          bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
          format: PdfStringFormat(alignment: PdfTextAlignment.center));

      //Draw text
      PdfLayoutResult? result = addParagraph(page, 'Introduction',
          Rect.fromLTWH(0, 60, pageSize.width, pageSize.height), true);

      //Add bookmark
      addBookmark(page, 'Introduction', result!.bounds.topLeft, doc: document);
      result = addParagraph(
          result.page,
          "Adobe Systems Incorporated's Portable Document Format (PDF) is the de facto standard for the accurate, reliable, and platform-independent representation of a paged document. It's the only universally accepted file format that allows pixel-perfect layouts.In addition, PDF supports user interaction and collaborative workflows that are not possible with printed documents.",
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false);
      result = addParagraph(
          result!.page,
          'The PDF Standard',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          true);
      final PdfBookmark standardBookmark = addBookmark(
          result!.page, 'The PDF Standard', result.bounds.topLeft,
          doc: document);
      result = addParagraph(
          result.page,
          'The PDF format is an open standard maintained by the International Organization for Standardization. The official specification is defined in ISO 32000-1:2008, but Adobe also provides a free, comprehensive guide called PDF Reference - Sixth Edition.\nConceptual Overview: A PDF file can be divided into four parts: a header, body, cross-reference table, and trailer. The header marks the file as a PDF, the body defines the visible document, the cross-reference table lists the location of everything in the file, and the trailer provides instructions for how to start reading the file.',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false);
      result = addParagraph(
          result!.page,
          'Header',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          true);
      addBookmark(result!.page, 'Header', result.bounds.topLeft,
          bookmark: standardBookmark);
      result = addParagraph(
          result.page,
          'The header is simply a PDF version number and an arbitrary sequence of binary data. The binary data prevents naïve applications from processing the PDF as a text file. This would result in a corrupted file, since a PDF typically consists of both plain text and binary data (e.g., a binary font file can be directly embedded in a PDF).',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false);
      result = addParagraph(
          result!.page,
          'Body',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          true);
      final PdfBookmark bodyBookmark = addBookmark(
          result!.page, 'Body', result.bounds.topLeft,
          bookmark: standardBookmark);

      result = addParagraph(
          result.page,
          'The body of a PDF contains the entire visible document. The minimum elements required in a valid PDF body are:\n1) A page tree \n2) Pages \n3) Resources \n4) Content \n5) The catalog',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false);
      result = addParagraph(
          result!.page,
          '1. The Page Tree',
          Rect.fromLTWH(
              0, result.bounds.bottom + 50, pageSize.width, pageSize.height),
          true,
          subTitle: true);
      addBookmark(result!.page, '1. The Page Tree', result.bounds.topLeft,
          bookmark: bodyBookmark);

      result = addParagraph(
          result.page,
          "The page tree is a dictionary object containing a list of the pages that make up the document. A minimal page tree contains just one page. Objects are enclosed in the obj and endobj tags, and they begin with a unique identification number (1 0). The first number is the object number, and the second is the generation number. The latter is only used for incremental updates, so all the generation numbers in our examples will be 0. As we'll see in a moment, PDFs use these identifiers to refer to individual objects from elsewhere in the document.",
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false);
      result = addParagraph(
          result!.page,
          '2. Page(s)',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          true,
          subTitle: true);
      addBookmark(result!.page, '2. Page(s)', result.bounds.topLeft,
          bookmark: bodyBookmark);

      result = addParagraph(
          result.page,
          "Next, we'll create the second object, which is the only page referenced by /Kids in the previous section. The /Type entry always specifies the type of the object. Many times, this can be omitted if the object type can be inferred by context. Note that PDF uses a name to identify the object type-not a literal string.",
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false);
      result = addParagraph(
          result!.page,
          '3. Resources',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          true,
          subTitle: true);
      addBookmark(result!.page, '3. Resources', result.bounds.topLeft,
          bookmark: bodyBookmark);

      result = addParagraph(
          result.page,
          "The third object is a resource defining a font configuration. The /Font key contains a whole dictionary, opposed to the name/value pairs we've seen previously (e.g., /Type /Page). The font we configured is called /F0, and the font face we selected is /Times-Roman. The /Subtype is the format of the font file, and /Type1 refers to the PostScript type 1 file format.",
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false);
      result = addParagraph(
          result!.page,
          '4. Content',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          true,
          subTitle: true);
      addBookmark(result!.page, '4. Content', result.bounds.topLeft,
          bookmark: bodyBookmark);

      result = addParagraph(
          result.page,
          'Finally, we are able to specify the actual content of the page. Page content is represented as a stream object. Stream objects consist of a dictionary of metadata and a stream of bytes.',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false,
          subTitle: true);
      result = addParagraph(
          result!.page,
          '5. Catalog',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          true,
          subTitle: true);
      addBookmark(result!.page, '5. Catalog', result.bounds.topLeft,
          bookmark: bodyBookmark);

      result = addParagraph(
          result.page,
          'The last section of the body is the catalog, which points to the root page tree (1 0 R). This may seem like an unnecessary reference, but dividing a document into multiple page trees is a common way to optimize PDFs. In such a case, programs need to know where the document starts.',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false);
      result = addParagraph(
          result!.page,
          'Cross-Reference Table',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          true);
      addBookmark(result!.page, 'Cross-Reference Table', result.bounds.topLeft,
          bookmark: standardBookmark);
      result = addParagraph(
          result.page,
          "The cross-reference table provides the location of each object in the body of the file. Locations are recorded as byte-offsets from the beginning of the file. This is another job for pdftk-all we have to do is add the xref keyword. We'll take a closer look at the cross-reference table after we generate the final PDF.",
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false);
      result = addParagraph(
          result!.page,
          'Trailer',
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          true);
      addBookmark(result!.page, 'Trailer', result.bounds.topLeft,
          bookmark: standardBookmark);
      result = addParagraph(
          result.page,
          "The last part of the file is the trailer. It's comprised of the trailer keyword, followed by a dictionary that contains a reference to the catalog, then a pointer to the crossreference table, and finally an end-of-file marker. The /Root points to the catalog, not the root page tree. This is important because the catalog can also contain important information about the document structure. The startxref keyword points to the location (in bytes) of the beginning of the crossreference table.",
          Rect.fromLTWH(
              0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
          false);
      //Save and dispose the document.
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'SB_bookmark.pdf');
      document.dispose();
    });
    test('rtl text', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      //Create a PDF true type font.
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 12);
      const String rtlText =
          'سنبدأ بنظرة عامة مفاهيمية على مستند PDF بسيط. تم تصميم هذا الفصل ليكون توجيهًا مختصرًا قبل الغوص في مستند حقيقي وإنشاءه من البداية.\r\n \r\nيمكن تقسيم ملف PDF إلى أربعة أجزاء: الرأس والجسم والجدول الإسناد الترافقي والمقطورة. يضع الرأس الملف كملف PDF ، حيث يحدد النص المستند المرئي ، ويسرد جدول الإسناد الترافقي موقع كل شيء في الملف ، ويوفر المقطع الدعائي تعليمات حول كيفية بدء قراءة الملف.\r\n\r\nرأس الصفحة هو ببساطة رقم إصدار PDF وتسلسل عشوائي للبيانات الثنائية. البيانات الثنائية تمنع التطبيقات الساذجة من معالجة ملف PDF كملف نصي. سيؤدي ذلك إلى ملف تالف ، لأن ملف PDF يتكون عادةً من نص عادي وبيانات ثنائية (على سبيل المثال ، يمكن تضمين ملف خط ثنائي بشكل مباشر في ملف PDF).\r\n\r\nלאחר הכותרת והגוף מגיע טבלת הפניה המקושרת. הוא מתעדת את מיקום הבית של כל אובייקט בגוף הקובץ. זה מאפשר גישה אקראית של המסמך, ולכן בעת עיבוד דף, רק את האובייקטים הנדרשים עבור דף זה נקראים מתוך הקובץ. זה עושה מסמכי PDF הרבה יותר מהר מאשר קודמיו PostScript, אשר היה צריך לקרוא את כל הקובץ לפני עיבוד זה.';
      //Add page and draw string.
      document.pages.add().graphics.drawString(rtlText, font,
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(0, 0, 515, 742),
          format: PdfStringFormat(
              textDirection: PdfTextDirection.rightToLeft,
              alignment: PdfTextAlignment.right,
              paragraphIndent: 35));
      //Save and dispose.
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'SB_rtl_text.pdf');
      document.dispose();
    });
    test('bullets and list', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      //Add a new PDF page.
      final PdfPage page = document.pages.add();

      //Draw text to the PDF page.
      page.graphics.drawString(
          'Types of Animals',
          PdfStandardFont(PdfFontFamily.timesRoman, 18,
              style: PdfFontStyle.bold),
          brush: PdfBrushes.darkBlue,
          bounds: Rect.fromLTWH(
              0, 20, page.getClientSize().width, page.getClientSize().height));

      //Create a PDF standard font.
      final PdfStandardFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);

      //Create PDF lists.
      final PdfOrderedList animals = PdfOrderedList(
          font: PdfStandardFont(PdfFontFamily.helvetica, 12,
              style: PdfFontStyle.bold),
          items: PdfListItemCollection(<String>[
            'Mammals',
            'Reptiles',
            'Birds',
            'Insects',
            'Aquatic Animals'
          ]),
          markerHierarchy: true,
          format: PdfStringFormat(lineSpacing: 10));
      animals.textIndent = 10;

      //Create sub list
      animals.items[0].subList = PdfOrderedList(
          marker: PdfOrderedMarker(font: font, style: PdfNumberStyle.numeric),
          font: font,
          items: PdfListItemCollection(<String>[
            'body covered by hair or fur',
            'warm-blooded',
            'have a backbone',
            'produce milk',
            'Examples'
          ]),
          markerHierarchy: true);

      animals.items[0].subList!.indent = 20;
      animals.items[0].subList!.textIndent = 8;
      final PdfUnorderedMarker unorderedMarker = PdfUnorderedMarker(
          font: PdfStandardFont(PdfFontFamily.courier, 10),
          style: PdfUnorderedMarkerStyle.circle);

      animals.items[0].subList!.items[4].subList = PdfUnorderedList(
          marker: unorderedMarker,
          font: font,
          items: PdfListItemCollection(<String>['Tiger', 'Bat']));
      animals.items[0].subList!.items[4].subList!.indent = 28;
      animals.items[0].subList!.items[4].subList!.textIndent = 8;
      animals.items[1].subList = PdfOrderedList(
          marker: PdfOrderedMarker(font: font, style: PdfNumberStyle.numeric),
          font: font,
          items: PdfListItemCollection(<String>[
            'body covered by scales',
            'cold-blooded',
            'have a backbone',
            'most lay hard-shelled eggs on land',
            'Examples'
          ]),
          markerHierarchy: true);
      animals.items[1].subList!.indent = 20;
      animals.items[1].subList!.textIndent = 8;
      animals.items[1].subList!.items[4].subList = PdfUnorderedList(
          marker: unorderedMarker,
          font: font,
          items: PdfListItemCollection(<String>['Snake', 'Lizard']));
      animals.items[1].subList!.items[4].subList!.indent = 28;
      animals.items[1].subList!.items[4].subList!.textIndent = 8;
      animals.items[2].subList = PdfOrderedList(
          marker: PdfOrderedMarker(font: font, style: PdfNumberStyle.numeric),
          font: font,
          items: PdfListItemCollection(<String>[
            'body covered by feathers',
            'warm-blooded',
            'have a backbone',
            'lay eggs',
            'Examples'
          ]),
          markerHierarchy: true);
      animals.items[2].subList!.indent = 20;
      animals.items[2].subList!.textIndent = 8;
      animals.items[2].subList!.items[4].subList = PdfUnorderedList(
          marker: unorderedMarker,
          font: font,
          items: PdfListItemCollection(<String>['Pigeon', 'Hen']));
      animals.items[2].subList!.items[4].subList!.textIndent = 8;
      animals.items[2].subList!.items[4].subList!.indent = 28;
      animals.items[3].subList = PdfOrderedList(
          marker: PdfOrderedMarker(font: font, style: PdfNumberStyle.numeric),
          font: font,
          items: PdfListItemCollection(<String>[
            'most are small air-breathing animals',
            '6 legs',
            '2 antennae',
            '3 body sections (head, thorax, abdomen)',
            'Examples'
          ]),
          markerHierarchy: true);
      animals.items[3].subList!.indent = 20;
      animals.items[3].subList!.textIndent = 8;
      animals.items[3].subList!.items[4].subList = PdfUnorderedList(
          marker: unorderedMarker,
          font: font,
          items: PdfListItemCollection(<String>['Butterfly', 'Spider']));
      animals.items[3].subList!.items[4].subList!.textIndent = 8;
      animals.items[3].subList!.items[4].subList!.indent = 28;
      animals.items[4].subList = PdfOrderedList(
          marker: PdfOrderedMarker(font: font, style: PdfNumberStyle.numeric),
          font: font,
          items: PdfListItemCollection(<String>[
            'most have gills',
            'found in lakes, rivers, and oceans',
            'Examples'
          ]),
          markerHierarchy: true);
      animals.items[4].subList!.indent = 20;
      animals.items[4].subList!.textIndent = 8;
      animals.items[4].subList!.items[2].subList = PdfUnorderedList(
          marker: unorderedMarker,
          font: font,
          items: PdfListItemCollection(<String>['Blue Shark', 'Fish']));
      animals.items[4].subList!.items[2].subList!.indent = 28;
      animals.items[4].subList!.items[2].subList!.textIndent = 8;
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat();
      layoutFormat.layoutType = PdfLayoutType.paginate;
      //Draw the list.
      animals.draw(
          page: page,
          bounds: const Rect.fromLTWH(0, 60, 0, 0),
          format: layoutFormat);
      //Save and dispose the document.
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'SB_bulets_and_lists.pdf');
      document.dispose();
    });
    test('hello world', () {
      //Create a new PDF document.
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;

      //Add a new PDF page.
      final PdfPage page = document.pages.add();

      //Draw text to the PDF page.
      page.graphics.drawString(
          'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: const Rect.fromLTWH(0, 40, 200, 30));

      page.graphics.drawString(
          'Hello World!',
          PdfStandardFont(PdfFontFamily.helvetica, 20,
              style: PdfFontStyle.bold),
          brush: PdfBrushes.blue,
          bounds: const Rect.fromLTWH(0, 80, 200, 30));

      page.graphics.drawString(
          'Hello World!',
          PdfStandardFont(PdfFontFamily.helvetica, 20,
              style: PdfFontStyle.italic),
          brush: PdfBrushes.red,
          bounds: const Rect.fromLTWH(0, 120, 200, 30));

      page.graphics.drawString(
          'Hello World!',
          PdfStandardFont(PdfFontFamily.helvetica, 20,
              style: PdfFontStyle.underline),
          brush: PdfBrushes.green,
          bounds: const Rect.fromLTWH(0, 160, 200, 30));

      page.graphics.drawString(
          'Hello World!',
          PdfStandardFont(PdfFontFamily.helvetica, 20,
              style: PdfFontStyle.strikethrough),
          brush: PdfBrushes.brown,
          bounds: const Rect.fromLTWH(0, 200, 200, 30));
      //Save and dispose the PDF document.
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'SB_hello_world.pdf');
      document.dispose();
    });
    test('image to pdf', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      //Get page graphics.
      final PdfGraphics graphics = document.pages.add().graphics;
      graphics.drawString(
          'JPEG Image',
          PdfStandardFont(PdfFontFamily.helvetica, 12,
              style: PdfFontStyle.bold),
          bounds: const Rect.fromLTWH(0, 40, 0, 0),
          brush: PdfBrushes.blue);
      //Load the JPEG image.
      PdfBitmap image = PdfBitmap.fromBase64String(imageJpeg);
      //Draw image.
      graphics.drawImage(image, const Rect.fromLTWH(0, 70, 515, 215));
      graphics.drawString(
          'PNG Image',
          PdfStandardFont(PdfFontFamily.helvetica, 12,
              style: PdfFontStyle.bold),
          bounds: const Rect.fromLTWH(0, 355, 0, 0),
          brush: PdfBrushes.blue);
      //Load the PNG image.
      image = PdfBitmap.fromBase64String(logoPng);
      //Draw image.
      graphics.drawImage(image, const Rect.fromLTWH(0, 365, 199, 300));

      //Save and dispose the PDF document.
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'SB_image_to_pdf.pdf');
      document.dispose();
    });
    test('table', () {
      //Create a new PDF document.
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      //Add a PDF page.
      final PdfPage page = document.pages.add();
      //String format for table cells.
      final PdfStringFormat format = PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle);
      //Draw line
      page.graphics.drawLine(PdfPen(PdfColor(0, 0, 110), width: 2),
          const Offset(0, 3), Offset(page.getClientSize().width, 3));
      //Draw string
      page.graphics.drawString(
          'Northwind Customers',
          PdfStandardFont(PdfFontFamily.helvetica, 18,
              style: PdfFontStyle.bold),
          brush: PdfSolidBrush(PdfColor(17, 50, 140)),
          format: format,
          bounds: Rect.fromLTWH(0, 5, page.getClientSize().width, 50));
      //Draw line
      page.graphics.drawLine(PdfPen(PdfColor(0, 0, 110), width: 3),
          const Offset(0, 55), Offset(page.getClientSize().width, 55));
      //Draw image
      page.graphics.drawImage(PdfBitmap.fromBase64String(logoJpeg),
          Rect.fromLTWH(page.getClientSize().width - 120, 9, 120, 42));
      //Create a PDF header border
      final PdfBorders headerBorder = PdfBorders();
      headerBorder.all = PdfPen(PdfColor(17, 50, 140));
      //Create a PDF header style.
      final PdfGridCellStyle headerStyle = PdfGridCellStyle(
          borders: headerBorder,
          format: format,
          font: PdfStandardFont(PdfFontFamily.helvetica, 6),
          cellPadding: PdfPaddings(left: 2, right: 2, top: 1, bottom: 1),
          textBrush: PdfBrushes.white,
          backgroundBrush: PdfSolidBrush(PdfColor(58, 78, 133)));
      //Row border and row style.
      final PdfBorders rowBorder = PdfBorders();
      rowBorder.all = PdfPen(PdfColor(17, 50, 140), width: 0.5);
      final PdfGridCellStyle rowStyle = PdfGridCellStyle(
          borders: rowBorder,
          font: PdfStandardFont(PdfFontFamily.helvetica, 6),
          cellPadding: PdfPaddings(left: 2, right: 2, top: 1, bottom: 1),
          format: format);
      final dynamic data = <String, List<Map<String, String>>>{
        'Customers': <Map<String, String>>[
          <String, String>{
            'CustomerID': 'ALFKI',
            'CompanyName': 'Alfreds Futterkiste',
            'ContactName': 'Maria Anders',
            'ContactTitle': 'Sales Representative',
            'Address': 'Obere Str. 57',
            'City': 'Berlin',
            'PostalCode': '12209',
            'Country': 'Germany',
            'Phone': '030-0074321',
            'Fax': '030-0076545'
          },
          <String, String>{
            'CustomerID': 'ANATR',
            'CompanyName': 'Ana Trujillo Emparedados y helados',
            'ContactName': 'Ana Trujillo',
            'ContactTitle': 'Owner',
            'Address': 'Avda. de la Constitución 2222',
            'City': 'México D.F.',
            'PostalCode': '05021',
            'Country': 'Mexico',
            'Phone': '(5) 555-4729',
            'Fax': '(5) 555-3745'
          },
          <String, String>{
            'CustomerID': 'ANTON',
            'CompanyName': 'Antonio Moreno Taquería',
            'ContactName': 'Antonio Moreno',
            'ContactTitle': 'Owner',
            'Address': 'Mataderos  2312',
            'City': 'México D.F.',
            'PostalCode': '05023',
            'Country': 'Mexico',
            'Phone': '(5) 555-3932',
            'Fax': '(5) 555-3745'
          },
          <String, String>{
            'CustomerID': 'AROUT',
            'CompanyName': 'Around the Horn',
            'ContactName': 'Thomas Hardy',
            'ContactTitle': 'Sales Representative',
            'Address': '120 Hanover Sq.',
            'City': 'London',
            'PostalCode': 'WA1 1DP',
            'Country': 'UK',
            'Phone': '(171) 555-7788',
            'Fax': '(171) 555-6750'
          },
          <String, String>{
            'CustomerID': 'BERGS',
            'CompanyName': 'Berglunds snabbköp',
            'ContactName': 'Christina Berglund',
            'ContactTitle': 'Order Administrator',
            'Address': 'Berguvsvägen  8',
            'City': 'Luleå',
            'PostalCode': 'S-958 22',
            'Country': 'Sweden',
            'Phone': '0921-12 34 65',
            'Fax': '0921-12 34 67'
          },
          <String, String>{
            'CustomerID': 'BLAUS',
            'CompanyName': 'Blauer See Delikatessen',
            'ContactName': 'Hanna Moos',
            'ContactTitle': 'Sales Representative',
            'Address': 'Forsterstr. 57',
            'City': 'Mannheim',
            'PostalCode': '68306',
            'Country': 'Germany',
            'Phone': '0621-08460',
            'Fax': '0621-08924'
          },
          <String, String>{
            'CustomerID': 'BLONP',
            'CompanyName': 'Blondesddsl père et fils',
            'ContactName': 'Frédérique Citeaux',
            'ContactTitle': 'Marketing Manager',
            'Address': '24, place Kléber',
            'City': 'Strasbourg',
            'PostalCode': '67000',
            'Country': 'France',
            'Phone': '88.60.15.31',
            'Fax': '88.60.15.32'
          },
          <String, String>{
            'CustomerID': 'BOLID',
            'CompanyName': 'Bólido Comidas preparadas',
            'ContactName': 'Martín Sommer',
            'ContactTitle': 'Owner',
            'Address': 'C/ Araquil, 67',
            'City': 'Madrid',
            'PostalCode': '28023',
            'Country': 'Spain',
            'Phone': '(91) 555 22 82',
            'Fax': '(91) 555 91 99'
          },
          <String, String>{
            'CustomerID': 'BONAP',
            'CompanyName': 'Bon app',
            'ContactName': 'Laurence Lebihan',
            'ContactTitle': 'Owner',
            'Address': '12, rue des Bouchers',
            'City': 'Marseille',
            'PostalCode': '13008',
            'Country': 'France',
            'Phone': '91.24.45.40',
            'Fax': '91.24.45.41'
          },
          <String, String>{
            'CustomerID': 'BOTTM',
            'CompanyName': 'Bottom-Dollar Markets',
            'ContactName': 'Elizabeth Lincoln',
            'ContactTitle': 'Accounting Manager',
            'Address': '23 Tsawassen Blvd.',
            'City': 'Tsawassen',
            'PostalCode': 'T2F 8M4',
            'Country': 'Canada',
            'Phone': '(604) 555-4729',
            'Fax': '(604) 555-3745'
          },
          <String, String>{
            'CustomerID': 'BSBEV',
            'CompanyName': "B's Beverages",
            'ContactName': 'Victoria Ashworth',
            'ContactTitle': 'Sales Representative',
            'Address': 'Fauntleroy Circus',
            'City': 'London',
            'PostalCode': 'EC2 5NT',
            'Country': 'UK',
            'Phone': '(171) 555-1212',
            'Fax': '(604) 555-3745'
          },
          <String, String>{
            'CustomerID': 'CACTU',
            'CompanyName': 'Cactus Comidas para llevar',
            'ContactName': 'Patricio Simpson',
            'ContactTitle': 'Sales Agent',
            'Address': 'Cerrito 333',
            'City': 'Buenos Aires',
            'PostalCode': '1010',
            'Country': 'Argentina',
            'Phone': '(1) 135-5555',
            'Fax': '(1) 135-4892'
          },
          <String, String>{
            'CustomerID': 'CENTC',
            'CompanyName': 'Centro comercial Moctezuma',
            'ContactName': 'Francisco Chang',
            'ContactTitle': 'Marketing Manager',
            'Address': 'Sierras de Granada 9993',
            'City': 'México D.F.',
            'PostalCode': '05022',
            'Country': 'Mexico',
            'Phone': '(5) 555-3392',
            'Fax': '(5) 555-7293'
          },
          <String, String>{
            'CustomerID': 'CHOPS',
            'CompanyName': 'Chop-suey Chinese',
            'ContactName': 'Yang Wang',
            'ContactTitle': 'Owner',
            'Address': 'Hauptstr. 29',
            'City': 'Bern',
            'PostalCode': '3012',
            'Country': 'Switzerland',
            'Phone': '0452-076545',
            'Fax': '(604) 555-3745'
          },
          <String, String>{
            'CustomerID': 'COMMI',
            'CompanyName': 'Comércio Mineiro',
            'ContactName': 'Pedro Afonso',
            'ContactTitle': 'Sales Associate',
            'Address': 'Av. dos Lusíadas, 23',
            'City': 'Sao Paulo',
            'PostalCode': '05432-043',
            'Country': 'Brazil',
            'Phone': '(11) 555-7647',
            'Fax': '(171) 555-9199'
          },
          <String, String>{
            'CustomerID': 'CONSH',
            'CompanyName': 'Consolidated Holdings',
            'ContactName': 'Elizabeth Brown',
            'ContactTitle': 'Sales Representative',
            'Address': 'Berkeley Gardens 12  Brewery',
            'City': 'London',
            'PostalCode': 'WX1 6LT',
            'Country': 'UK',
            'Phone': '(171) 555-2282',
            'Fax': '(171) 555-9199'
          },
          <String, String>{
            'CustomerID': 'DRACD',
            'CompanyName': 'Drachenblut Delikatessen',
            'ContactName': 'Sven Ottlieb',
            'ContactTitle': 'Order Administrator',
            'Address': 'Walserweg 21',
            'City': 'Aachen',
            'PostalCode': '52066',
            'Country': 'Germany',
            'Phone': '0241-039123',
            'Fax': '0241-059428'
          },
          <String, String>{
            'CustomerID': 'DUMON',
            'CompanyName': 'Du monde entier',
            'ContactName': 'Janine Labrune',
            'ContactTitle': 'Owner',
            'Address': '67, rue des Cinquante Otages',
            'City': 'Nantes',
            'PostalCode': '44000',
            'Country': 'France',
            'Phone': '40.67.88.88',
            'Fax': '40.67.89.89'
          },
          <String, String>{
            'CustomerID': 'EASTC',
            'CompanyName': 'Eastern Connection',
            'ContactName': 'Ann Devon',
            'ContactTitle': 'Sales Agent',
            'Address': '35 King George',
            'City': 'London',
            'PostalCode': 'WX3 6FW',
            'Country': 'UK',
            'Phone': '(171) 555-0297',
            'Fax': '(171) 555-3373'
          },
          <String, String>{
            'CustomerID': 'ERNSH',
            'CompanyName': 'Ernst Handel',
            'ContactName': 'Roland Mendel',
            'ContactTitle': 'Sales Manager',
            'Address': 'Kirchgasse 6',
            'City': 'Graz',
            'PostalCode': '8010',
            'Country': 'Austria',
            'Phone': '7675-3425',
            'Fax': '7675-3426'
          },
          <String, String>{
            'CustomerID': 'FAMIA',
            'CompanyName': 'Familia Arquibaldo',
            'ContactName': 'Aria Cruz',
            'ContactTitle': 'Marketing Assistant',
            'Address': 'Rua Orós, 92',
            'City': 'Sao Paulo',
            'PostalCode': '05442-030',
            'Country': 'Brazil',
            'Phone': '(11) 555-9857',
            'Fax': '(171) 555-9199'
          },
          <String, String>{
            'CustomerID': 'FISSA',
            'CompanyName': 'FISSA Fabrica Inter. Salchichas S.A.',
            'ContactName': 'Diego Roel',
            'ContactTitle': 'Accounting Manager',
            'Address': 'C/ Moralzarzal, 86',
            'City': 'Madrid',
            'PostalCode': '28034',
            'Country': 'Spain',
            'Phone': '(91) 555 94 44',
            'Fax': '(91) 555 55 93'
          },
          <String, String>{
            'CustomerID': 'FOLIG',
            'CompanyName': 'Folies gourmandes',
            'ContactName': 'Martine Rancé',
            'ContactTitle': 'Assistant Sales Agent',
            'Address': '184, chaussée de Tournai',
            'City': 'Lille',
            'PostalCode': '59000',
            'Country': 'France',
            'Phone': '20.16.10.16',
            'Fax': '20.16.10.17'
          },
          <String, String>{
            'CustomerID': 'FOLKO',
            'CompanyName': 'Folk och fä HB',
            'ContactName': 'Maria Larsson',
            'ContactTitle': 'Owner',
            'Address': 'Åkergatan 24',
            'City': 'Bräcke',
            'PostalCode': 'S-844 67',
            'Country': 'Sweden',
            'Phone': '0695-34 67 21',
            'Fax': '(604) 555-3745'
          },
          <String, String>{
            'CustomerID': 'FRANK',
            'CompanyName': 'Frankenversand',
            'ContactName': 'Peter Franken',
            'ContactTitle': 'Marketing Manager',
            'Address': 'Berliner Platz 43',
            'City': 'München',
            'PostalCode': '80805',
            'Country': 'Germany',
            'Phone': '089-0877310',
            'Fax': '089-0877451'
          },
          <String, String>{
            'CustomerID': 'FRANR',
            'CompanyName': 'France restauration',
            'ContactName': 'Carine Schmitt',
            'ContactTitle': 'Marketing Manager',
            'Address': '54, rue Royale',
            'City': 'Nantes',
            'PostalCode': '44000',
            'Country': 'France',
            'Phone': '40.32.21.21',
            'Fax': '40.32.21.20'
          },
          <String, String>{
            'CustomerID': 'FRANS',
            'CompanyName': 'Franchi S.p.A.',
            'ContactName': 'Paolo Accorti',
            'ContactTitle': 'Sales Representative',
            'Address': 'Via Monte Bianco 34',
            'City': 'Torino',
            'PostalCode': '10100',
            'Country': 'Italy',
            'Phone': '011-4988260',
            'Fax': '011-4988261'
          },
          <String, String>{
            'CustomerID': 'FURIB',
            'CompanyName': 'Furia Bacalhau e Frutos do Mar',
            'ContactName': 'Lino Rodriguez',
            'ContactTitle': 'Sales Manager',
            'Address': 'Jardim das rosas n. 32',
            'City': 'Lisboa',
            'PostalCode': '1675',
            'Country': 'Portugal',
            'Phone': '(1) 354-2534',
            'Fax': '(1) 354-2535'
          },
          <String, String>{
            'CustomerID': 'GALED',
            'CompanyName': 'Galería del gastrónomo',
            'ContactName': 'Eduardo Saavedra',
            'ContactTitle': 'Marketing Manager',
            'Address': 'Rambla de Cataluña, 23',
            'City': 'Barcelona',
            'PostalCode': '08022',
            'Country': 'Spain',
            'Phone': '(93) 203 4560',
            'Fax': '(93) 203 4561'
          },
          <String, String>{
            'CustomerID': 'GODOS',
            'CompanyName': 'Godos Cocina Típica',
            'ContactName': 'José Pedro Freyre',
            'ContactTitle': 'Sales Manager',
            'Address': 'C/ Romero, 33',
            'City': 'Sevilla',
            'PostalCode': '41101',
            'Country': 'Spain',
            'Phone': '(95) 555 82 82',
            'Fax': '(604) 555-3745'
          },
          <String, String>{
            'CustomerID': 'GOURL',
            'CompanyName': 'Gourmet Lanchonetes',
            'ContactName': 'André Fonseca',
            'ContactTitle': 'Sales Associate',
            'Address': 'Av. Brasil, 442',
            'City': 'Campinas',
            'PostalCode': '04876-786',
            'Country': 'Brazil',
            'Phone': '(11) 555-9482',
            'Fax': '(604) 555-3745'
          },
          <String, String>{
            'CustomerID': 'GREAL',
            'CompanyName': 'Great Lakes Food Market',
            'ContactName': 'Howard Snyder',
            'ContactTitle': 'Marketing Manager',
            'Address': '2732 Baker Blvd.',
            'City': 'Eugene',
            'PostalCode': '97403',
            'Country': 'USA',
            'Phone': '(503) 555-7555',
            'Fax': '(604) 555-3745'
          },
          <String, String>{
            'CustomerID': 'GROSR',
            'CompanyName': 'GROSELLA-Restaurante',
            'ContactName': 'Manuel Pereira',
            'ContactTitle': 'Owner',
            'Address': '5ª Ave. Los Palos Grandes',
            'City': 'Caracas',
            'PostalCode': '1081',
            'Country': 'Venezuela',
            'Phone': '(2) 283-2951',
            'Fax': '(604) 555-3745'
          },
          <String, String>{
            'CustomerID': 'HANAR',
            'CompanyName': 'Hanari Carnes',
            'ContactName': 'Mario Pontes',
            'ContactTitle': 'Accounting Manager',
            'Address': 'Rua do Paço, 67',
            'City': 'Rio de Janeiro',
            'PostalCode': '05454-876',
            'Country': 'Brazil',
            'Phone': '(21) 555-0091',
            'Fax': '(21) 555-8765'
          },
          <String, String>{
            'CustomerID': 'HILAA',
            'CompanyName': 'HILARION-Abastos',
            'ContactName': 'Carlos Hernández',
            'ContactTitle': 'Sales Representative',
            'Address': 'Carrera 22 con Ave. Carlos Soublette #8-35',
            'City': 'San Cristóbal',
            'PostalCode': '5022',
            'Country': 'Venezuela',
            'Phone': '(5) 555-1340',
            'Fax': '(5) 555-1948'
          },
          <String, String>{
            'CustomerID': 'HUNGC',
            'CompanyName': 'Hungry Coyote Import Store',
            'ContactName': 'Yoshi Latimer',
            'ContactTitle': 'Sales Representative',
            'Address': 'City Center Plaza 516 Main St.',
            'City': 'Elgin',
            'PostalCode': '97827',
            'Country': 'USA',
            'Phone': '(503) 555-6874',
            'Fax': '(503) 555-2376'
          },
          <String, String>{
            'CustomerID': 'HUNGO',
            'CompanyName': 'Hungry Owl All-Night Grocers',
            'ContactName': 'Patricia McKenna',
            'ContactTitle': 'Sales Associate',
            'Address': '8 Johnstown Road',
            'City': 'Cork',
            'Country': 'Ireland',
            'Phone': '2967 542',
            'Fax': '2967 3333'
          },
          <String, String>{
            'CustomerID': 'ISLAT',
            'CompanyName': 'Island Trading',
            'ContactName': 'Helen Bennett',
            'ContactTitle': 'Marketing Manager',
            'Address': 'Garden House Crowther Way',
            'City': 'Cowes',
            'PostalCode': 'PO31 7PJ',
            'Country': 'UK',
            'Phone': '(198) 555-8888',
            'Fax': '(171) 555-9199'
          },
          <String, String>{
            'CustomerID': 'KOENE',
            'CompanyName': 'Königlich Essen',
            'ContactName': 'Philip Cramer',
            'ContactTitle': 'Sales Associate',
            'Address': 'Maubelstr. 90',
            'City': 'Brandenburg',
            'PostalCode': '14776',
            'Country': 'Germany',
            'Phone': '0555-09876',
            'Fax': '(604) 555-3745'
          },
          <String, String>{
            'CustomerID': 'LACOR',
            'CompanyName': "La corne d'abondance",
            'ContactName': 'Daniel Tonini',
            'ContactTitle': 'Sales Representative',
            'Address': "67, avenue de l'Europe",
            'City': 'Versailles',
            'PostalCode': '78000',
            'Country': 'France',
            'Phone': '30.59.84.10',
            'Fax': '30.59.85.11'
          },
          <String, String>{
            'CustomerID': 'LAMAI',
            'CompanyName': "La maison d'Asie",
            'ContactName': 'Annette Roulet',
            'ContactTitle': 'Sales Manager',
            'Address': '1 rue Alsace-Lorraine',
            'City': 'Toulouse',
            'PostalCode': '31000',
            'Country': 'France',
            'Phone': '61.77.61.10',
            'Fax': '61.77.61.11'
          },
          <String, String>{
            'CustomerID': 'LAUGB',
            'CompanyName': 'Laughing Bacchus Wine Cellars',
            'ContactName': 'Yoshi Tannamuri',
            'ContactTitle': 'Marketing Assistant',
            'Address': '1900 Oak St.',
            'City': 'Vancouver',
            'PostalCode': 'V3F 2K1',
            'Country': 'Canada',
            'Phone': '(604) 555-3392',
            'Fax': '(604) 555-7293'
          },
          <String, String>{
            'CustomerID': 'LAZYK',
            'CompanyName': 'Lazy K Kountry Store',
            'ContactName': 'John Steel',
            'ContactTitle': 'Marketing Manager',
            'Address': '12 Orchestra Terrace',
            'City': 'Walla Walla',
            'PostalCode': '99362',
            'Country': 'USA',
            'Phone': '(509) 555-7969',
            'Fax': '(509) 555-6221'
          },
          <String, String>{
            'CustomerID': 'LEHMS',
            'CompanyName': 'Lehmanns Marktstand',
            'ContactName': 'Renate Messner',
            'ContactTitle': 'Sales Representative',
            'Address': 'Magazinweg 7',
            'City': 'Frankfurt a.M.',
            'PostalCode': '60528',
            'Country': 'Germany',
            'Phone': '069-0245984',
            'Fax': '069-0245874'
          },
          <String, String>{
            'CustomerID': 'LETSS',
            'CompanyName': "Let's Stop N Shop",
            'ContactName': 'Jaime Yorres',
            'ContactTitle': 'Owner',
            'Address': '87 Polk St. Suite 5',
            'City': 'San Francisco',
            'PostalCode': '94117',
            'Country': 'USA',
            'Phone': '(415) 555-5938',
            'Fax': '(604) 555-3745'
          },
          <String, String>{
            'CustomerID': 'LILAS',
            'CompanyName': 'LILA-Supermercado',
            'ContactName': 'Carlos González',
            'ContactTitle': 'Accounting Manager',
            'Address': 'Carrera 52 con Ave. Bolívar #65-98 Llano Largo',
            'City': 'Barquisimeto',
            'PostalCode': '3508',
            'Country': 'Venezuela',
            'Phone': '(9) 331-6954',
            'Fax': '(9) 331-7256'
          },
          <String, String>{
            'CustomerID': 'LINOD',
            'CompanyName': 'LINO-Delicateses',
            'ContactName': 'Felipe Izquierdo',
            'ContactTitle': 'Owner',
            'Address': 'Ave. 5 de Mayo Porlamar',
            'City': 'I. de Margarita',
            'PostalCode': '4980',
            'Country': 'Venezuela',
            'Phone': '(8) 34-56-12',
            'Fax': '(8) 34-93-93'
          },
          <String, String>{
            'CustomerID': 'LONEP',
            'CompanyName': 'Lonesome Pine Restaurant',
            'ContactName': 'Fran Wilson',
            'ContactTitle': 'Sales Manager',
            'Address': '89 Chiaroscuro Rd.',
            'City': 'Portland',
            'PostalCode': '97219',
            'Country': 'USA',
            'Phone': '(503) 555-9573',
            'Fax': '(503) 555-9646'
          }
        ]
      };
      final dynamic details = data['Customers'];

      //Create a PDF grid.
      final PdfGrid grid = PdfGrid();
      //Add columns
      grid.columns.add(count: details[0].length);
      //Enable repeat header.
      grid.repeatHeader = true;
      //Create header row.
      final PdfGridRow header = grid.headers.add(1)[0];
      int i = 0;
      //Set value to the header row.
      details[0].forEach((String key, dynamic value) {
        header.cells[i].value = key;
        header.cells[i++].style = headerStyle;
      });
      //Set values to the row
      for (i = 0; i < details.length; i++) {
        final PdfGridRow row = grid.rows.add();
        int j = 0;
        details[i].forEach((String key, dynamic value) {
          row.cells[j++].value = value;
          if (i % 2 != 0) {
            row.style.backgroundBrush = PdfSolidBrush(PdfColor(176, 196, 222));
          }
        });
      }
      grid.rows.applyStyle(rowStyle);
      //Draw grid.
      grid.draw(
          page: page,
          bounds: Rect.fromLTWH(0, 65, page.getClientSize().width,
              page.getClientSize().height - 70));
      //Save and dispose document.
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'SB_table.pdf');
      document.dispose();
    });
  });
}
