import 'dart:convert';
import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'fonts.dart';
// ignore: avoid_relative_lib_imports
import 'images.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_docs.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_encryption.dart';
// ignore: avoid_relative_lib_imports
import 'pfx_files.dart';

// ignore: public_member_api_docs
void sampleBrowserSamples() {
  group('Sample Browser Sample', () {
    test('Digital Signature', () {
      final PdfDocument document = PdfDocument.fromBase64String(sbSignPdf);
      final PdfFormFieldCollection fields = document.form.fields;
      final PdfSignatureField signature = fields[6] as PdfSignatureField;
      final PdfCertificate certificate =
          PdfCertificate(base64.decode(sbPfx), 'password123');
      signature.signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'johndoe@owned.us',
          locationInfo: 'Honolulu, Hawaii',
          reason: 'I am author of this document.');
      final PdfGraphics graphics = signature.appearance.normal.graphics!;
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      graphics.drawImage(
          PdfBitmap.fromBase64String(pdfPngImage),
          Rect.fromLTWH((signature.bounds.width / 2) - 12, 2, 24,
              signature.bounds.height - 5));
      graphics.drawString(
          'TestCertificate', PdfStandardFont(PdfFontFamily.helvetica, 11),
          brush: brush,
          bounds: Rect.fromLTWH(
              0, 10, signature.bounds.width / 2, signature.bounds.height - 10));
      graphics.drawString(
          'Digitally signed by TestCertificate\r\nDate:${DateTime(2021, 03, 11)}',
          PdfStandardFont(PdfFontFamily.helvetica, 8),
          brush: brush,
          bounds: Rect.fromLTWH(signature.bounds.width / 2, 3,
              signature.bounds.width / 2, signature.bounds.height - 3));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve header and footer sample');
      savePdf(bytes, 'SB_DigitalSignature.pdf');
      document.dispose();
    });
    test('Digital Signature -2', () {
      final PdfDocument document = PdfDocument.fromBase64String(sbSignPdf);
      //Get the signature field.
      final PdfSignatureField signatureField =
          document.form.fields[6] as PdfSignatureField;
      //Create Pdf certificate.
      final PdfCertificate certificate =
          PdfCertificate(base64.decode(sbPfx), 'password123');
      //Get signature field and sign.
      signatureField.signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'johndoe@owned.us',
          locationInfo: 'Honolulu, Hawaii',
          reason: 'I am author of this document.');
      //Get the signatue field bounds.
      final Rect bounds = signatureField.bounds;
      //Draw appearance.
      //Get the signature field appearance graphics.
      final PdfGraphics graphics = signatureField.appearance.normal.graphics!;
      graphics.drawString(
          'Test Certificate', PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(0, 0, bounds.width / 2, bounds.height),
          brush: PdfBrushes.black,
          format: PdfStringFormat(
              lineAlignment: PdfVerticalAlignment.middle,
              alignment: PdfTextAlignment.center));
      //Get certificate subject name.
      final String subject = certificate.subjectName;
      final String date = DateTime(2021, 03, 11).toString();
      graphics.drawString('Digitally signed by $subject $date',
          PdfStandardFont(PdfFontFamily.helvetica, 7),
          bounds: Rect.fromLTWH(
              (bounds.width / 2) + 2, 0, bounds.width / 2, bounds.height),
          brush: PdfBrushes.black,
          format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve header and footer sample');
      savePdf(bytes, 'SB_DigitalSignature2.pdf');
      document.dispose();
    });
    test('Digital Signature -3', () {
      final PdfDocument document = PdfDocument.fromBase64String(multiSignPdf);
      document.fileStructure.incrementalUpdate = true;
      final PdfSignatureField signatureField =
          document.form.fields[0] as PdfSignatureField;
      signatureField.signature = PdfSignature(
          certificate: PdfCertificate(base64.decode(pdfPfx), 'syncfusion'));
      signatureField.appearance.normal.graphics!.drawImage(
          PdfBitmap.fromBase64String(sign1), const Rect.fromLTWH(0, 0, 90, 20));
      final List<int> bytes = document.saveSync();
      final PdfDocument ldoc = PdfDocument(inputBytes: bytes);
      ldoc.fileStructure.incrementalUpdate = true;
      final PdfSignatureField signatureField2 =
          ldoc.form.fields[1] as PdfSignatureField;
      signatureField2.signature = PdfSignature(
          certificate: PdfCertificate(base64.decode(pdfPfx2), 'password123'));
      signatureField2.appearance.normal.graphics!.drawImage(
          PdfBitmap.fromBase64String(sign2), const Rect.fromLTWH(0, 0, 90, 20));
      final List<int> lbytes = ldoc.saveSync();
      expect(lbytes.isNotEmpty, true,
          reason: 'Failed to preserve header and footer sample');
      savePdf(lbytes, 'SB_DigitalSignature3.pdf');
      document.dispose();
      ldoc.dispose();
    });
    test('Header and Footer', () {
      final PdfDocument document = _createHeaderFooterSample();
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve header and footer sample');
      savePdf(bytes, 'SB_header_and_footer.pdf');
      document.dispose();
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument doc = _createHeaderFooterSample();
        final PdfSecurity security = doc.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        security.permissions.add(PdfPermissionsFlags.print);
        final List<int> encryptedBytes = doc.saveSync();
        expect(encryptedBytes.isNotEmpty, true,
            reason: 'Failed to preserve header and footer sample');
        savePdf(encryptedBytes, 'SB_HeaderAndFooter_$algorithm.pdf');
        doc.dispose();
      });
    });
    test('Bookmarks', () {
      final PdfDocument document = _createBookmarkSample();
      //Save and dispose the document.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve bookmark sample');
      savePdf(bytes, 'SB_bookmark.pdf');
      document.dispose();
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument doc = _createBookmarkSample();
        final PdfSecurity security = doc.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        security.permissions.add(PdfPermissionsFlags.print);
        final List<int> encryptedBytes = doc.saveSync();
        expect(encryptedBytes.isNotEmpty, true,
            reason: 'Failed to preserve Bookmark sample');
        savePdf(encryptedBytes, 'SB_Bookmark_$algorithm.pdf');
        doc.dispose();
      });
    });
    test('rtl text', () {
      final PdfDocument document = _createRTLSample();
      //Save and dispose.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to preserve RTL sample');
      savePdf(bytes, 'SB_rtl_text.pdf');
      document.dispose();
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument doc = _createRTLSample();
        final PdfSecurity security = doc.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        security.permissions.add(PdfPermissionsFlags.print);
        final List<int> encryptedBytes = doc.saveSync();
        expect(encryptedBytes.isNotEmpty, true,
            reason: 'Failed to preserve Bookmark sample');
        savePdf(encryptedBytes, 'SB_RTL_$algorithm.pdf');
        doc.dispose();
      });
    });
    test('bullets and list', () {
      final PdfDocument document = _createListsSample();
      //Save and dispose the document.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve Bullets and Lists sample');
      savePdf(bytes, 'SB_bulets_and_lists.pdf');
      document.dispose();
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument doc = _createListsSample();
        final PdfSecurity security = doc.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        security.permissions.add(PdfPermissionsFlags.print);
        final List<int> encryptedBytes = doc.saveSync();
        expect(encryptedBytes.isNotEmpty, true,
            reason: 'Failed to preserve Bullets and Lists sample');
        savePdf(encryptedBytes, 'SB_Lists_$algorithm.pdf');
        doc.dispose();
      });
    });
    test('hello world', () {
      //Create a new PDF document.
      final PdfDocument document = PdfDocument();

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
      final PdfDocument document = _createImageSample();
      //Save and dispose the PDF document.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve Image to PDF sample');
      savePdf(bytes, 'SB_image_to_pdf.pdf');
      document.dispose();
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument doc = _createImageSample();
        final PdfSecurity security = doc.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        security.permissions.add(PdfPermissionsFlags.print);
        final List<int> encryptedBytes = doc.saveSync();
        expect(encryptedBytes.isNotEmpty, true,
            reason: 'Failed to preserve Image to PDF sample');
        savePdf(encryptedBytes, 'SB_ImageToPdf_$algorithm.pdf');
        doc.dispose();
      });
    });
    test('table', () {
      final PdfDocument document = _createTableSample();
      //Save and dispose document.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to preserve table sample');
      savePdf(bytes, 'SB_table.pdf');
      document.dispose();
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument doc = _createTableSample();
        final PdfSecurity security = doc.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        security.permissions.add(PdfPermissionsFlags.print);
        final List<int> encryptedBytes = doc.saveSync();
        expect(encryptedBytes.isNotEmpty, true,
            reason: 'Failed to preserve table sample');
        savePdf(encryptedBytes, 'SB_Table_$algorithm.pdf');
        doc.dispose();
      });
    });
    test('Annotation', () {
      //Load the PDF document.
      PdfDocument document = PdfDocument.fromBase64String(flut6019Pdf);
      //Get the page.
      final PdfPage page = document.pages[0];
      //Create a line annotation.
      final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
          <int>[60, 710, 187, 710], 'Introduction',
          color: PdfColor(0, 0, 255),
          author: 'John Milton',
          border: PdfAnnotationBorder(2),
          setAppearance: true,
          lineIntent: PdfLineIntent.lineDimension);
      //Add the line annotation to the page.
      page.annotations.add(lineAnnotation);
      //Create a ellipse Annotation.
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTRB(475, 771, 549, 815), 'Page Number',
          author: 'John Milton',
          border: PdfAnnotationBorder(2),
          color: PdfColor(255, 0, 0),
          setAppearance: true);
      //Add the ellipse annotation to the page.
      page.annotations.add(ellipseAnnotation);
      //Create a rectangle annotation.
      final PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTRB(57, 250, 565, 349), 'Usage',
          color: PdfColor(255, 170, 0),
          border: PdfAnnotationBorder(2),
          author: 'John Milton',
          setAppearance: true);
      //Add the rectangle annotation to the page.
      page.annotations.add(rectangleAnnotation);
      //Create a polygon annotation.
      final PdfPolygonAnnotation polygonAnnotation = PdfPolygonAnnotation(<int>[
        129,
        356,
        486,
        356,
        532,
        333,
        486,
        310,
        129,
        310,
        83,
        333,
        129,
        356
      ], 'Chapter 1 Conceptual Overview',
          color: PdfColor(255, 0, 0),
          border: PdfAnnotationBorder(2),
          author: 'John Milton',
          setAppearance: true);
      //Add the polygon annotation to the page.
      page.annotations.add(polygonAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve annotation sample');
      document = PdfDocument(inputBytes: bytes);
      final PdfAnnotationCollection collection = document.pages[0].annotations;
      expect((collection[0] as PdfLineAnnotation).bounds,
          const Rect.fromLTRB(52.0, 124.0, 195.0, 140.0),
          reason: 'Failed to preserve line annotation bounds');
      expect((collection[1] as PdfEllipseAnnotation).bounds,
          const Rect.fromLTRB(475.0, 771.0, 549.0, 815.0),
          reason: 'Failed to preserve ellipse annotation bounds');
      expect((collection[2] as PdfRectangleAnnotation).bounds,
          const Rect.fromLTRB(57.0, 250.0, 565.0, 349.0),
          reason: 'Failed to preserve line annotation bounds');
      expect((collection[3] as PdfPolygonAnnotation).bounds,
          const Rect.fromLTRB(81.0, 484.0, 534.0, 534.0),
          reason: 'Failed to preserve line annotation bounds');
      document.dispose();
    });
    test('Annotation flatten', () {
      //Load the PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(flut6019Pdf);
      //Get the page.
      final PdfPage page = document.pages[0];
      //Create a line annotation.
      final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
          <int>[60, 710, 187, 710], 'Introduction',
          color: PdfColor(0, 0, 255),
          author: 'John Milton',
          border: PdfAnnotationBorder(2),
          setAppearance: true,
          lineIntent: PdfLineIntent.lineDimension);
      //Add the line annotation to the page.
      page.annotations.add(lineAnnotation);
      //Create a ellipse Annotation.
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTRB(475, 771, 549, 815), 'Page Number',
          author: 'John Milton',
          border: PdfAnnotationBorder(2),
          color: PdfColor(255, 0, 0),
          setAppearance: true);
      //Add the ellipse annotation to the page.
      page.annotations.add(ellipseAnnotation);
      //Create a rectangle annotation.
      final PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTRB(57, 250, 565, 349), 'Usage',
          color: PdfColor(255, 170, 0),
          border: PdfAnnotationBorder(2),
          author: 'John Milton',
          setAppearance: true);
      //Add the rectangle annotation to the page.
      page.annotations.add(rectangleAnnotation);
      //Create a polygon annotation.
      final PdfPolygonAnnotation polygonAnnotation = PdfPolygonAnnotation(<int>[
        129,
        356,
        486,
        356,
        532,
        333,
        486,
        310,
        129,
        310,
        83,
        333,
        129,
        356
      ], 'Chapter 1 Conceptual Overview',
          color: PdfColor(255, 0, 0),
          border: PdfAnnotationBorder(2),
          author: 'John Milton',
          setAppearance: true);
      //Add the polygon annotation to the page.
      page.annotations.add(polygonAnnotation);
      //Flatten all the annotations.
      page.annotations.flattenAllAnnotations();
      final List<int> encryptedBytes = document.saveSync();
      expect(encryptedBytes.isNotEmpty, true,
          reason: 'Failed to preserve annotation flatten sample');
      savePdf(encryptedBytes, 'Flut_6019_AnnotationFlatten.pdf');
      document.dispose();
    });
    test('Conformance A1B', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      //Add page to the PDF
      final PdfPage page = document.pages.add();
      //Get page client size
      final Size pageSize = page.getClientSize();
      //Draw rectangle
      page.graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
          pen: PdfPen(PdfColor(142, 170, 219)));
      //Create a PDF true type font.
      final PdfFont contentFont =
          PdfTrueTypeFont.fromBase64String(robotoTTF, 9);
      final PdfFont headerFont =
          PdfTrueTypeFont.fromBase64String(robotoTTF, 30);
      final PdfFont footerFont =
          PdfTrueTypeFont.fromBase64String(robotoTTF, 18);
      //Generate PDF grid.
      final PdfGrid grid = _getGrid(contentFont);
      //Draw the header section by creating text element
      final PdfLayoutResult result = _drawHeader(
          page, pageSize, grid, contentFont, headerFont, footerFont);
      //Draw grid
      _drawGrid(page, grid, result, contentFont);
      //Add invoice footer
      _drawFooter(page, pageSize, contentFont);
      //Save and dispose the document.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve conformance A1B sample');
      savePdf(bytes, 'Flut_6019_ConformanceA1B.pdf');
      document.dispose();
    });
    test('Conformance A2B', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a2b);
      //Add page to the PDF
      final PdfPage page = document.pages.add();
      //Get page client size
      final Size pageSize = page.getClientSize();
      //Draw rectangle
      page.graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
          pen: PdfPen(PdfColor(142, 170, 219)));
      //Create a PDF true type font.
      final PdfFont contentFont =
          PdfTrueTypeFont.fromBase64String(robotoTTF, 9);
      final PdfFont headerFont =
          PdfTrueTypeFont.fromBase64String(robotoTTF, 30);
      final PdfFont footerFont =
          PdfTrueTypeFont.fromBase64String(robotoTTF, 18);
      //Generate PDF grid.
      final PdfGrid grid = _getGrid(contentFont);
      //Draw the header section by creating text element
      final PdfLayoutResult result = _drawHeader(
          page, pageSize, grid, contentFont, headerFont, footerFont);
      //Draw grid
      _drawGrid(page, grid, result, contentFont);
      //Add invoice footer
      _drawFooter(page, pageSize, contentFont);
      //Save and dispose the document.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve conformance A2B sample');
      savePdf(bytes, 'Flut_6019_ConformanceA2B.pdf');
      document.dispose();
    });
    test('Conformance A3B', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      const String text =
          'Adventure Works Cycles, the fictitious company on which the AdventureWorks sample databases are based, is a large, multinational manufacturing company. The company manufactures and sells metal and composite bicycles to North American, European and Asian commercial markets. While its base operation is located in Bothell, Washington with 290 employees, several regional sales teams are located throughout their market base.';
      document.attachments.add(PdfAttachment(
          'AdventureCycle.txt', utf8.encode(text),
          description: 'Adventure Works Cycles', mimeType: 'application/txt'));
      //Add page to the PDF
      final PdfPage page = document.pages.add();
      //Get page client size
      final Size pageSize = page.getClientSize();
      //Draw rectangle
      page.graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
          pen: PdfPen(PdfColor(142, 170, 219)));
      //Create a PDF true type font.
      final PdfFont contentFont =
          PdfTrueTypeFont.fromBase64String(robotoTTF, 9);
      final PdfFont headerFont =
          PdfTrueTypeFont.fromBase64String(robotoTTF, 30);
      final PdfFont footerFont =
          PdfTrueTypeFont.fromBase64String(robotoTTF, 18);
      //Generate PDF grid.
      final PdfGrid grid = _getGrid(contentFont);
      //Draw the header section by creating text element
      final PdfLayoutResult result = _drawHeader(
          page, pageSize, grid, contentFont, headerFont, footerFont);
      //Draw grid
      _drawGrid(page, grid, result, contentFont);
      //Add invoice footer
      _drawFooter(page, pageSize, contentFont);
      //Save and dispose the document.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve conformance A3B sample');
      savePdf(bytes, 'Flut_6019_ConformanceA3B.pdf');
      document.dispose();
    });
    test('Certificate', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument();
      document.pageSettings.orientation = PdfPageOrientation.landscape;
      document.pageSettings.margins.all = 0;
      //Add page to the PDF
      final PdfPage page = document.pages.add();
      //Get the page size
      final Size pageSize = page.getClientSize();
      //Draw image
      page.graphics.drawImage(PdfBitmap.fromBase64String(certificateJpg),
          Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
      //Create font
      final PdfFont nameFont = PdfStandardFont(PdfFontFamily.helvetica, 22);
      final PdfFont controlFont = PdfStandardFont(PdfFontFamily.helvetica, 19);
      final PdfFont dateFont = PdfStandardFont(PdfFontFamily.helvetica, 16);
      double x = _calculateXPosition('John Milton', nameFont, pageSize.width);
      page.graphics.drawString('John Milton', nameFont,
          bounds: Rect.fromLTWH(x, 253, 0, 0),
          brush: PdfSolidBrush(PdfColor(20, 58, 86)));
      x = _calculateXPosition(
          'Getting Started with PDF Development', controlFont, pageSize.width);
      page.graphics.drawString(
          'Getting Started with PDF Development', controlFont,
          bounds: Rect.fromLTWH(x, 340, 0, 0),
          brush: PdfSolidBrush(PdfColor(20, 58, 86)));
      final String dateText =
          'on ${DateFormat('MMMM d, yyyy').format(DateTime(2021, 12, 17, 9, 10, 12, 22, 12))}';
      x = _calculateXPosition(dateText, dateFont, pageSize.width);
      page.graphics.drawString(dateText, dateFont,
          bounds: Rect.fromLTWH(x, 385, 0, 0),
          brush: PdfSolidBrush(PdfColor(20, 58, 86)));
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve certificate sample');
      savePdf(bytes, 'Flut_6019_Certificate.pdf');
      document.dispose();
    });
    test('Digital Signature - cms - sha1', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(sbSignPdf);
      //Get the signature field.
      final PdfSignatureField signatureField =
          document.form.fields[6] as PdfSignatureField;
      //Create Pdf certificate.
      final List<int> pfxData = base64.decode(pdfPfx);
      final PdfCertificate certificate = PdfCertificate(pfxData, 'syncfusion');
      //Get signature field and sign.
      signatureField.signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'johndoe@owned.us',
          locationInfo: 'Honolulu, Hawaii',
          reason: 'I am author of this document.',
          digestAlgorithm: DigestAlgorithm.sha1);
      //Get the signatue field bounds.
      final Rect bounds = signatureField.bounds;
      //Draw appearance.
      //Get the signature field appearance graphics.
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      if (graphics != null) {
        graphics.drawRectangle(
            pen: PdfPens.black,
            bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height));
        graphics.drawImage(PdfBitmap.fromBase64String(signatureJpeg),
            const Rect.fromLTWH(2, 1, 30, 30));
        //Get certificate subject name.
        final String subject = certificate.subjectName;
        graphics.drawString(
            'Digitally signed by $subject \r\nReason: Testing signature \r\nLocation: USA',
            PdfStandardFont(PdfFontFamily.helvetica, 7),
            bounds: Rect.fromLTWH(45, 0, bounds.width - 45, bounds.height),
            brush: PdfBrushes.black,
            format:
                PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve certificate sample');
      savePdf(bytes, 'Flut_6019_DigitalSignature_cms_sha1.pdf');
      document.dispose();
    });
    test('Digital Signature - cms - sha256', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(sbSignPdf);
      //Get the signature field.
      final PdfSignatureField signatureField =
          document.form.fields[6] as PdfSignatureField;
      //Create Pdf certificate.
      final List<int> pfxData = base64.decode(pdfPfx);
      final PdfCertificate certificate = PdfCertificate(pfxData, 'syncfusion');
      //Get signature field and sign.
      signatureField.signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'johndoe@owned.us',
          locationInfo: 'Honolulu, Hawaii',
          reason: 'I am author of this document.');
      //Get the signatue field bounds.
      final Rect bounds = signatureField.bounds;
      //Draw appearance.
      //Get the signature field appearance graphics.
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      if (graphics != null) {
        graphics.drawRectangle(
            pen: PdfPens.black,
            bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height));
        graphics.drawImage(PdfBitmap.fromBase64String(signatureJpeg),
            const Rect.fromLTWH(2, 1, 30, 30));
        //Get certificate subject name.
        final String subject = certificate.subjectName;
        graphics.drawString(
            'Digitally signed by $subject \r\nReason: Testing signature \r\nLocation: USA',
            PdfStandardFont(PdfFontFamily.helvetica, 7),
            bounds: Rect.fromLTWH(45, 0, bounds.width - 45, bounds.height),
            brush: PdfBrushes.black,
            format:
                PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve certificate sample');
      savePdf(bytes, 'Flut_6019_DigitalSignature_cms_sha256.pdf');
      document.dispose();
    });
    test('Digital Signature - cms - sha384', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(sbSignPdf);
      //Get the signature field.
      final PdfSignatureField signatureField =
          document.form.fields[6] as PdfSignatureField;
      //Create Pdf certificate.
      final List<int> pfxData = base64.decode(pdfPfx);
      final PdfCertificate certificate = PdfCertificate(pfxData, 'syncfusion');
      //Get signature field and sign.
      signatureField.signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'johndoe@owned.us',
          locationInfo: 'Honolulu, Hawaii',
          reason: 'I am author of this document.',
          digestAlgorithm: DigestAlgorithm.sha384);
      //Get the signatue field bounds.
      final Rect bounds = signatureField.bounds;
      //Draw appearance.
      //Get the signature field appearance graphics.
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      if (graphics != null) {
        graphics.drawRectangle(
            pen: PdfPens.black,
            bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height));
        graphics.drawImage(PdfBitmap.fromBase64String(signatureJpeg),
            const Rect.fromLTWH(2, 1, 30, 30));
        //Get certificate subject name.
        final String subject = certificate.subjectName;
        graphics.drawString(
            'Digitally signed by $subject \r\nReason: Testing signature \r\nLocation: USA',
            PdfStandardFont(PdfFontFamily.helvetica, 7),
            bounds: Rect.fromLTWH(45, 0, bounds.width - 45, bounds.height),
            brush: PdfBrushes.black,
            format:
                PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve certificate sample');
      savePdf(bytes, 'Flut_6019_DigitalSignature_cms_sha384.pdf');
      document.dispose();
    });
    test('Digital Signature - cms - sha512', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(sbSignPdf);
      //Get the signature field.
      final PdfSignatureField signatureField =
          document.form.fields[6] as PdfSignatureField;
      //Create Pdf certificate.
      final List<int> pfxData = base64.decode(pdfPfx);
      final PdfCertificate certificate = PdfCertificate(pfxData, 'syncfusion');
      //Get signature field and sign.
      signatureField.signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'johndoe@owned.us',
          locationInfo: 'Honolulu, Hawaii',
          reason: 'I am author of this document.',
          digestAlgorithm: DigestAlgorithm.sha512);
      //Get the signatue field bounds.
      final Rect bounds = signatureField.bounds;
      //Draw appearance.
      //Get the signature field appearance graphics.
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      if (graphics != null) {
        graphics.drawRectangle(
            pen: PdfPens.black,
            bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height));
        graphics.drawImage(PdfBitmap.fromBase64String(signatureJpeg),
            const Rect.fromLTWH(2, 1, 30, 30));
        //Get certificate subject name.
        final String subject = certificate.subjectName;
        graphics.drawString(
            'Digitally signed by $subject \r\nReason: Testing signature \r\nLocation: USA',
            PdfStandardFont(PdfFontFamily.helvetica, 7),
            bounds: Rect.fromLTWH(45, 0, bounds.width - 45, bounds.height),
            brush: PdfBrushes.black,
            format:
                PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve certificate sample');
      savePdf(bytes, 'Flut_6019_DigitalSignature_cms_sha512.pdf');
      document.dispose();
    });
    test('Digital Signature - cades - sha1', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(sbSignPdf);
      //Get the signature field.
      final PdfSignatureField signatureField =
          document.form.fields[6] as PdfSignatureField;
      //Create Pdf certificate.
      final List<int> pfxData = base64.decode(pdfPfx);
      final PdfCertificate certificate = PdfCertificate(pfxData, 'syncfusion');
      //Get signature field and sign.
      signatureField.signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'johndoe@owned.us',
          locationInfo: 'Honolulu, Hawaii',
          reason: 'I am author of this document.',
          digestAlgorithm: DigestAlgorithm.sha1,
          cryptographicStandard: CryptographicStandard.cades);
      //Get the signatue field bounds.
      final Rect bounds = signatureField.bounds;
      //Draw appearance.
      //Get the signature field appearance graphics.
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      if (graphics != null) {
        graphics.drawRectangle(
            pen: PdfPens.black,
            bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height));
        graphics.drawImage(PdfBitmap.fromBase64String(signatureJpeg),
            const Rect.fromLTWH(2, 1, 30, 30));
        //Get certificate subject name.
        final String subject = certificate.subjectName;
        graphics.drawString(
            'Digitally signed by $subject \r\nReason: Testing signature \r\nLocation: USA',
            PdfStandardFont(PdfFontFamily.helvetica, 7),
            bounds: Rect.fromLTWH(45, 0, bounds.width - 45, bounds.height),
            brush: PdfBrushes.black,
            format:
                PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve certificate sample');
      savePdf(bytes, 'Flut_6019_DigitalSignature_cades_sha1.pdf');
      document.dispose();
    });
    test('Digital Signature - cades - sha256', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(sbSignPdf);
      //Get the signature field.
      final PdfSignatureField signatureField =
          document.form.fields[6] as PdfSignatureField;
      //Create Pdf certificate.
      final List<int> pfxData = base64.decode(pdfPfx);
      final PdfCertificate certificate = PdfCertificate(pfxData, 'syncfusion');
      //Get signature field and sign.
      signatureField.signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'johndoe@owned.us',
          locationInfo: 'Honolulu, Hawaii',
          reason: 'I am author of this document.',
          cryptographicStandard: CryptographicStandard.cades);
      //Get the signatue field bounds.
      final Rect bounds = signatureField.bounds;
      //Draw appearance.
      //Get the signature field appearance graphics.
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      if (graphics != null) {
        graphics.drawRectangle(
            pen: PdfPens.black,
            bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height));
        graphics.drawImage(PdfBitmap.fromBase64String(signatureJpeg),
            const Rect.fromLTWH(2, 1, 30, 30));
        //Get certificate subject name.
        final String subject = certificate.subjectName;
        graphics.drawString(
            'Digitally signed by $subject \r\nReason: Testing signature \r\nLocation: USA',
            PdfStandardFont(PdfFontFamily.helvetica, 7),
            bounds: Rect.fromLTWH(45, 0, bounds.width - 45, bounds.height),
            brush: PdfBrushes.black,
            format:
                PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve certificate sample');
      savePdf(bytes, 'Flut_6019_DigitalSignature_cades_sha256.pdf');
      document.dispose();
    });
    test('Digital Signature - cades - sha384', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(sbSignPdf);
      //Get the signature field.
      final PdfSignatureField signatureField =
          document.form.fields[6] as PdfSignatureField;
      //Create Pdf certificate.
      final List<int> pfxData = base64.decode(pdfPfx);
      final PdfCertificate certificate = PdfCertificate(pfxData, 'syncfusion');
      //Get signature field and sign.
      signatureField.signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'johndoe@owned.us',
          locationInfo: 'Honolulu, Hawaii',
          reason: 'I am author of this document.',
          digestAlgorithm: DigestAlgorithm.sha384,
          cryptographicStandard: CryptographicStandard.cades);
      //Get the signatue field bounds.
      final Rect bounds = signatureField.bounds;
      //Draw appearance.
      //Get the signature field appearance graphics.
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      if (graphics != null) {
        graphics.drawRectangle(
            pen: PdfPens.black,
            bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height));
        graphics.drawImage(PdfBitmap.fromBase64String(signatureJpeg),
            const Rect.fromLTWH(2, 1, 30, 30));
        //Get certificate subject name.
        final String subject = certificate.subjectName;
        graphics.drawString(
            'Digitally signed by $subject \r\nReason: Testing signature \r\nLocation: USA',
            PdfStandardFont(PdfFontFamily.helvetica, 7),
            bounds: Rect.fromLTWH(45, 0, bounds.width - 45, bounds.height),
            brush: PdfBrushes.black,
            format:
                PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve certificate sample');
      savePdf(bytes, 'Flut_6019_DigitalSignature_cades_sha384.pdf');
      document.dispose();
    });
    test('Digital Signature - cades - sha512', () {
      //Create a PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(sbSignPdf);
      //Get the signature field.
      final PdfSignatureField signatureField =
          document.form.fields[6] as PdfSignatureField;
      //Create Pdf certificate.
      final List<int> pfxData = base64.decode(pdfPfx);
      final PdfCertificate certificate = PdfCertificate(pfxData, 'syncfusion');
      //Get signature field and sign.
      signatureField.signature = PdfSignature(
          certificate: certificate,
          contactInfo: 'johndoe@owned.us',
          locationInfo: 'Honolulu, Hawaii',
          reason: 'I am author of this document.',
          digestAlgorithm: DigestAlgorithm.sha512,
          cryptographicStandard: CryptographicStandard.cades);
      //Get the signatue field bounds.
      final Rect bounds = signatureField.bounds;
      //Draw appearance.
      //Get the signature field appearance graphics.
      final PdfGraphics? graphics = signatureField.appearance.normal.graphics;
      if (graphics != null) {
        graphics.drawRectangle(
            pen: PdfPens.black,
            bounds: Rect.fromLTWH(0, 0, bounds.width, bounds.height));
        graphics.drawImage(PdfBitmap.fromBase64String(signatureJpeg),
            const Rect.fromLTWH(2, 1, 30, 30));
        //Get certificate subject name.
        final String subject = certificate.subjectName;
        graphics.drawString(
            'Digitally signed by $subject \r\nReason: Testing signature \r\nLocation: USA',
            PdfStandardFont(PdfFontFamily.helvetica, 7),
            bounds: Rect.fromLTWH(45, 0, bounds.width - 45, bounds.height),
            brush: PdfBrushes.black,
            format:
                PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
      }
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve certificate sample');
      savePdf(bytes, 'Flut_6019_DigitalSignature_cades_sha512.pdf');
      document.dispose();
    });
    test('Encryption rc4x40Bit', () {
      //Load the PDF document.
      PdfDocument document = PdfDocument.fromBase64String(creditCardPdf);
      // Get the PDF security.
      final PdfSecurity security = document.security;
      //Set passwords
      security.userPassword = 'password@123';
      security.ownerPassword = 'syncfusion';
      //Set the encryption algorithm.
      security.algorithm = PdfEncryptionAlgorithm.rc4x40Bit;
      //Set the permissions.
      security.permissions.addAll(<PdfPermissionsFlags>[
        PdfPermissionsFlags.print,
        PdfPermissionsFlags.fullQualityPrint
      ]);
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve encryption sample');
      document = PdfDocument(inputBytes: bytes, password: 'syncfusion');
      expect(document.security.algorithm, PdfEncryptionAlgorithm.rc4x40Bit,
          reason: 'Failed to preserve encryption sample');
      document.dispose();
    });
    test('Encryption rc4x128Bit', () {
      //Load the PDF document.
      PdfDocument document = PdfDocument.fromBase64String(creditCardPdf);
      // Get the PDF security.
      final PdfSecurity security = document.security;
      //Set passwords
      security.userPassword = 'password@123';
      security.ownerPassword = 'syncfusion';
      //Set the encryption algorithm.
      security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
      //Set the permissions.
      security.permissions.addAll(<PdfPermissionsFlags>[
        PdfPermissionsFlags.print,
        PdfPermissionsFlags.fullQualityPrint
      ]);
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve encryption sample');
      document = PdfDocument(inputBytes: bytes, password: 'syncfusion');
      expect(document.security.algorithm, PdfEncryptionAlgorithm.rc4x128Bit,
          reason: 'Failed to preserve encryption sample');
      document.dispose();
    });
    test('Encryption aesx128Bit', () {
      //Load the PDF document.
      PdfDocument document = PdfDocument.fromBase64String(creditCardPdf);
      // Get the PDF security.
      final PdfSecurity security = document.security;
      //Set passwords
      security.userPassword = 'password@123';
      security.ownerPassword = 'syncfusion';
      //Set the encryption algorithm.
      security.algorithm = PdfEncryptionAlgorithm.aesx128Bit;
      //Set the permissions.
      security.permissions.addAll(<PdfPermissionsFlags>[
        PdfPermissionsFlags.print,
        PdfPermissionsFlags.fullQualityPrint
      ]);
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve encryption sample');
      document = PdfDocument(inputBytes: bytes, password: 'syncfusion');
      expect(document.security.algorithm, PdfEncryptionAlgorithm.aesx128Bit,
          reason: 'Failed to preserve encryption sample');
      document.dispose();
    });
    test('Encryption aesx256Bit', () {
      //Load the PDF document.
      PdfDocument document = PdfDocument.fromBase64String(creditCardPdf);
      // Get the PDF security.
      final PdfSecurity security = document.security;
      //Set passwords
      security.userPassword = 'password@123';
      security.ownerPassword = 'syncfusion';
      //Set the encryption algorithm.
      security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
      //Set the permissions.
      security.permissions.addAll(<PdfPermissionsFlags>[
        PdfPermissionsFlags.print,
        PdfPermissionsFlags.fullQualityPrint
      ]);
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve encryption sample');
      document = PdfDocument(inputBytes: bytes, password: 'syncfusion');
      expect(document.security.algorithm, PdfEncryptionAlgorithm.aesx256Bit,
          reason: 'Failed to preserve encryption sample');
      document.dispose();
    });
    test('Encryption aesx256BitRevision6', () {
      //Load the PDF document.
      PdfDocument document = PdfDocument.fromBase64String(creditCardPdf);
      // Get the PDF security.
      final PdfSecurity security = document.security;
      //Set passwords
      security.userPassword = 'password@123';
      security.ownerPassword = 'syncfusion';
      //Set the encryption algorithm.
      security.algorithm = PdfEncryptionAlgorithm.aesx256BitRevision6;
      //Set the permissions.
      security.permissions.addAll(<PdfPermissionsFlags>[
        PdfPermissionsFlags.print,
        PdfPermissionsFlags.fullQualityPrint
      ]);
      //Save and launch the document
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve encryption sample');
      document = PdfDocument(inputBytes: bytes, password: 'syncfusion');
      expect(document.security.algorithm,
          PdfEncryptionAlgorithm.aesx256BitRevision6,
          reason: 'Failed to preserve encryption sample');
      document.dispose();
    });
    test('Find Text', () {
      //Load the PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(pdfSuccinctly);
      //Create PDF text extractor to find text.
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      //Find the text
      final List<MatchedItem> result = extractor.findText(<String>['PDF']);
      //Highlight the searched text from the document.
      for (int i = 0; i < result.length; i++) {
        final MatchedItem item = result[i];
        //Get page.
        final PdfPage page = document.pages[item.pageIndex];
        //Set transparency to the page graphics.
        page.graphics.save();
        page.graphics.setTransparency(0.5);
        //Draw rectangle to highlight the text.
        page.graphics
            .drawRectangle(bounds: item.bounds, brush: PdfBrushes.yellow);
        page.graphics.restore();
      }
      //Save and dispose the document.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve find text sample');
      savePdf(bytes, 'Flut_6019_findText.pdf');
      document.dispose();
    });
    test('Extract Text', () {
      //Load the PDF document.
      final PdfDocument document = PdfDocument.fromBase64String(pdfSuccinctly);
      //Create PDF text extractor to find text.
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      final String text = extractor.extractText();
      expect(base64.encode(utf8.encode(text)),
          'SW50cm9kdWN0aW9uDQoNCkFkb2JlIFN5c3RlbXMgSW5jb3Jwb3JhdGVkJ3MgUG9ydGFibGUgRG9jdW1lbnQgRm9ybWF0IChQREYpIGlzIHRoZSBkZSBmYWN0bw0Kc3RhbmRhcmQgZm9yIHRoZSBhY2N1cmF0ZSwgcmVsaWFibGUsIGFuZCBwbGF0Zm9ybS1pbmRlcGVuZGVudCByZXByZXNlbnRhdGlvbiBvZiBhDQpwYWdlZCBkb2N1bWVudC4gSXQncyB0aGUgb25seSB1bml2ZXJzYWxseSBhY2NlcHRlZCBmaWxlIGZvcm1hdCB0aGF0IGFsbG93cyBwaXhlbC1wZXJmZWN0DQpsYXlvdXRzLiBJbiBhZGRpdGlvbiwgUERGIHN1cHBvcnRzIHVzZXIgaW50ZXJhY3Rpb24gYW5kIGNvbGxhYm9yYXRpdmUgd29ya2Zsb3dzIHRoYXQNCmFyZSBub3QgcG9zc2libGUgd2l0aCBwcmludGVkIGRvY3VtZW50cy4NClBERiBkb2N1bWVudHMgaGF2ZSBiZWVuIGluIHdpZGVzcHJlYWQgdXNlIGZvciB5ZWFycywgYW5kIGRvemVucyBvZiBmcmVlIGFuZA0KY29tbWVyY2lhbCBQREYgcmVhZGVycywgZWRpdG9ycywgYW5kIGxpYnJhcmllcyBhcmUgcmVhZGlseSBhdmFpbGFibGUuIEhvd2V2ZXIsIGRlc3BpdGUNCnRoaXMgcG9wdWxhcml0eSwgaXQncyBzdGlsbCBkaWZmaWN1bHQgdG8gZmluZCBhIHN1Y2NpbmN0IGd1aWRlIHRvIHRoZSBuYXRpdmUgUERGIGZvcm1hdC4NClVuZGVyc3RhbmRpbmcgdGhlIGludGVybmFsIHdvcmtpbmdzIG9mIGEgUERGIG1ha2VzIGl0IHBvc3NpYmxlIHRvIGR5bmFtaWNhbGx5DQpnZW5lcmF0ZSBQREYgZG9jdW1lbnRzLiBGb3IgZXhhbXBsZSwgYSB3ZWIgc2VydmVyIGNhbiBleHRyYWN0IGluZm9ybWF0aW9uIGZyb20gYQ0KZGF0YWJhc2UsIHVzZSBpdCB0byBjdXN0b21pemUgYW4gaW52b2ljZSwgYW5kIHNlcnZlIGl0IHRvIHRoZSBjdXN0b21lciBvbiB0aGUgZmx5Lg0KDQpUaGUgUERGIFN0YW5kYXJkDQoNClRoZSBQREYgZm9ybWF0IGlzIGFuIG9wZW4gc3RhbmRhcmQgbWFpbnRhaW5lZCBieSB0aGUgSW50ZXJuYXRpb25hbCBPcmdhbml6YXRpb24gZm9yDQpTdGFuZGFyZGl6YXRpb24uIFRoZSBvZmZpY2lhbCBzcGVjaWZpY2F0aW9uIGlzIGRlZmluZWQgaW4gSVNPIDMyMDAwLTE6MjAwOCwgYnV0IEFkb2JlDQphbHNvIHByb3ZpZGVzIGEgZnJlZSwgY29tcHJlaGVuc2l2ZSBndWlkZSBjYWxsZWQgUERGIFJlZmVyZW5jZSwgU2l4dGggRWRpdGlvbiwNCnZlcnNpb24gMS43Lg0KDQpDaGFwdGVyIDEgQ29uY2VwdHVhbCBPdmVydmlldw0KDQpXZSdsbCBiZWdpbiB3aXRoIGEgY29uY2VwdHVhbCBvdmVydmlldyBvZiBhIHNpbXBsZSBQREYgZG9jdW1lbnQuIFRoaXMgY2hhcHRlciBpcw0KZGVzaWduZWQgdG8gYmUgYSBicmllZiBvcmllbnRhdGlvbiBiZWZvcmUgZGl2aW5nIGluIGFuZCBjcmVhdGluZyBhIHJlYWwgZG9jdW1lbnQgZnJvbQ0Kc2NyYXRjaC4NCkEgUERGIGZpbGUgY2FuIGJlIGRpdmlkZWQgaW50byBmb3VyIHBhcnRzOiBhIGhlYWRlciwgYm9keSwgY3Jvc3MtcmVmZXJlbmNlIHRhYmxlLCBhbmQNCnRyYWlsZXIuIFRoZSBoZWFkZXIgbWFya3MgdGhlIGZpbGUgYXMgYSBQREYsIHRoZSBib2R5IGRlZmluZXMgdGhlIHZpc2libGUgZG9jdW1lbnQsIHRoZQ0KY3Jvc3MtcmVmZXJlbmNlIHRhYmxlIGxpc3RzIHRoZSBsb2NhdGlvbiBvZiBldmVyeXRoaW5nIGluIHRoZSBmaWxlLCBhbmQgdGhlIHRyYWlsZXIgcHJvdmlkZXMNCmluc3RydWN0aW9ucyBmb3IgaG93IHRvIHN0YXJ0IHJlYWRpbmcgdGhlIGZpbGUuDQoNClBERiBTdWNjaW5jdGx5DQoNClBhZ2UgNCBvZiA4DQoNCg0KRXZlcnkgUERGIGZpbGUgbXVzdCBoYXZlIHRoZXNlIGZvdXIgY29tcG9uZW50cy4NCg0KUERGIFN1Y2NpbmN0bHkNCg0KUGFnZSA1IG9mIDgNCg0KDQpIZWFkZXINCg0KVGhlIGhlYWRlciBpcyBzaW1wbHkgYSBQREYgdmVyc2lvbiBudW1iZXIgYW5kIGFuIGFyYml0cmFyeSBzZXF1ZW5jZSBvZiBiaW5hcnkgZGF0YS4NClRoZSBiaW5hcnkgZGF0YSBwcmV2ZW50cyBuYcOvdmUgYXBwbGljYXRpb25zIGZyb20gcHJvY2Vzc2luZyB0aGUgUERGIGFzIGEgdGV4dCBmaWxlLg0KVGhpcyB3b3VsZCByZXN1bHQgaW4gYSBjb3JydXB0ZWQgZmlsZSwgc2luY2UgYSBQREYgdHlwaWNhbGx5IGNvbnNpc3RzIG9mIGJvdGggcGxhaW4gdGV4dA0KYW5kIGJpbmFyeSBkYXRhIChlLmcuLCBhIGJpbmFyeSBmb250IGZpbGUgY2FuIGJlIGRpcmVjdGx5IGVtYmVkZGVkIGluIGEgUERGKS4NCg0KQm9keQ0KDQpUaGUgYm9keSBvZiBhIFBERiBjb250YWlucyB0aGUgZW50aXJlIHZpc2libGUgZG9jdW1lbnQuIFRoZSBtaW5pbXVtIGVsZW1lbnRzDQpyZXF1aXJlZCBpbiBhIHZhbGlkIFBERiBib2R5IGFyZToNCjEuIEEgcGFnZSB0cmVlDQoyLiBQYWdlcw0KMy4gUmVzb3VyY2VzDQo0LiBDb250ZW50DQo1LiBUaGUgY2F0YWxvZw0KVGhlIHBhZ2UgdHJlZSBzZXJ2ZXMgYXMgdGhlIHJvb3Qgb2YgdGhlIGRvY3VtZW50LiBJbiB0aGUgc2ltcGxlc3QgY2FzZSwgaXQgaXMganVzdCBhIGxpc3QNCm9mIHRoZSBwYWdlcyBpbiB0aGUgZG9jdW1lbnQuIEVhY2ggcGFnZSBpcyBkZWZpbmVkIGFzIGFuIGluZGVwZW5kZW50IGVudGl0eSB3aXRoDQptZXRhZGF0YSAoZS5nLiwgcGFnZSBkaW1lbnNpb25zKSBhbmQgYSByZWZlcmVuY2UgdG8gaXRzIHJlc291cmNlcyBhbmQgY29udGVudCwgd2hpY2gNCmFyZSBkZWZpbmVkIHNlcGFyYXRlbHkuIFRvZ2V0aGVyLCB0aGUgcGFnZSB0cmVlIGFuZCBwYWdlIG9iamVjdHMgY3JlYXRlIHRoZSAicGFwZXIiDQp0aGF0IGNvbXBvc2VzIHRoZSBkb2N1bWVudC4NClJlc291cmNlcyBhcmUgb2JqZWN0cyB0aGF0IGFyZSByZXF1aXJlZCB0byByZW5kZXIgYSBwYWdlLiBGb3IgZXhhbXBsZSwgYSBzaW5nbGUgZm9udA0KaXMgdHlwaWNhbGx5IHVzZWQgYWNyb3NzIHNldmVyYWwgcGFnZXMsIHNvIHN0b3JpbmcgdGhlIGZvbnQgaW5mb3JtYXRpb24gaW4gYW4gZXh0ZXJuYWwNCnJlc291cmNlIGlzIG11Y2ggbW9yZSBlZmZpY2llbnQuIEEgY29udGVudCBvYmplY3QgZGVmaW5lcyB0aGUgdGV4dCBhbmQgZ3JhcGhpY3MgdGhhdA0KYWN0dWFsbHkgc2hvdyB1cCBvbiB0aGUgcGFnZS4gVG9nZXRoZXIsIGNvbnRlbnQgb2JqZWN0cyBhbmQgcmVzb3VyY2VzIGRlZmluZSB0aGUNCmFwcGVhcmFuY2Ugb2YgYW4gaW5kaXZpZHVhbCBwYWdlLg0KRmluYWxseSwgdGhlIGRvY3VtZW50J3MgY2F0YWxvZyB0ZWxscyBhcHBsaWNhdGlvbnMgd2hlcmUgdG8gc3RhcnQgcmVhZGluZyB0aGUgZG9jdW1lbnQuDQpPZnRlbiwgdGhpcyBpcyBqdXN0IGEgcG9pbnRlciB0byB0aGUgcm9vdCBwYWdlIHRyZWUuDQoNClBERiBTdWNjaW5jdGx5DQoNClBhZ2UgNiBvZiA4DQoNCg0KQ3Jvc3MtUmVmZXJlbmNlIFRhYmxlDQoNCkFmdGVyIHRoZSBoZWFkZXIgYW5kIHRoZSBib2R5IGNvbWVzIHRoZSBjcm9zcy1yZWZlcmVuY2UgdGFibGUuIEl0IHJlY29yZHMgdGhlIGJ5dGUNCmxvY2F0aW9uIG9mIGVhY2ggb2JqZWN0IGluIHRoZSBib2R5IG9mIHRoZSBmaWxlLiBUaGlzIGVuYWJsZXMgcmFuZG9tLWFjY2VzcyBvZiB0aGUNCmRvY3VtZW50LCBzbyB3aGVuIHJlbmRlcmluZyBhIHBhZ2UsIG9ubHkgdGhlIG9iamVjdHMgcmVxdWlyZWQgZm9yIHRoYXQgcGFnZSBhcmUgcmVhZA0KZnJvbSB0aGUgZmlsZS4gVGhpcyBtYWtlcyBQREZzIG11Y2ggZmFzdGVyIHRoYW4gdGhlaXIgUG9zdFNjcmlwdCBwcmVkZWNlc3NvcnMsIHdoaWNoDQpoYWQgdG8gcmVhZCBpbiB0aGUgZW50aXJlIGZpbGUgYmVmb3JlIHByb2Nlc3NpbmcgaXQuDQoNClRyYWlsZXINCg0KRmluYWxseSwgd2UgY29tZSB0byB0aGUgbGFzdCBjb21wb25lbnQgb2YgYSBQREYgZG9jdW1lbnQuIFRoZSB0cmFpbGVyIHRlbGxzDQphcHBsaWNhdGlvbnMgaG93IHRvIHN0YXJ0IHJlYWRpbmcgdGhlIGZpbGUuIEF0IG1pbmltdW0sIGl0IGNvbnRhaW5zIHRocmVlIHRoaW5nczoNCg0KUERGIFN1Y2NpbmN0bHkNCg0KUGFnZSA3IG9mIDgNCg0KDQoxLiBBIHJlZmVyZW5jZSB0byB0aGUgY2F0YWxvZyB3aGljaCBsaW5rcyB0byB0aGUgcm9vdCBvZiB0aGUgZG9jdW1lbnQuDQoyLiBUaGUgbG9jYXRpb24gb2YgdGhlIGNyb3NzLXJlZmVyZW5jZSB0YWJsZS4NCjMuIFRoZSBzaXplIG9mIHRoZSBjcm9zcy1yZWZlcmVuY2UgdGFibGUuDQpTaW5jZSBhIHRyYWlsZXIgaXMgYWxsIHlvdSBuZWVkIHRvIGJlZ2luIHByb2Nlc3NpbmcgYSBkb2N1bWVudCwgUERGcyBhcmUgdHlwaWNhbGx5DQpyZWFkIGJhY2stdG8tZnJvbnQ6IGZpcnN0LCB0aGUgZW5kIG9mIHRoZSBmaWxlIGlzIGZvdW5kLCBhbmQgdGhlbiB5b3UgcmVhZCBiYWNrd2FyZHMgdW50aWwNCnlvdSBhcnJpdmUgYXQgdGhlIGJlZ2lubmluZyBvZiB0aGUgdHJhaWxlci4gQWZ0ZXIgdGhhdCwgeW91IHNob3VsZCBoYXZlIGFsbCB0aGUgaW5mb3JtYXRpb24NCnlvdSBuZWVkIHRvIGxvYWQgYW55IHBhZ2UgaW4gdGhlIFBERi4NCg0KU3VtbWFyeQ0KDQpUbyBjb25jbHVkZSBvdXIgb3ZlcnZpZXcsIGEgUERGIGRvY3VtZW50IGhhcyBhIGhlYWRlciwgYSBib2R5LCBhIGNyb3NzLXJlZmVyZW5jZQ0KdGFibGUsIGFuZCBhIHRyYWlsZXIuIFRoZSB0cmFpbGVyIHNlcnZlcyBhcyB0aGUgZW50cnl3YXkgdG8gdGhlIGVudGlyZSBkb2N1bWVudCwgZ2l2aW5nDQp5b3UgYWNjZXNzIHRvIGFueSBvYmplY3QgdmlhIHRoZSBjcm9zcy1yZWZlcmVuY2UgdGFibGUsIGFuZCBwb2ludGluZyB5b3UgdG93YXJkIHRoZQ0Kcm9vdCBvZiB0aGUgZG9jdW1lbnQuIFRoZSByZWxhdGlvbnNoaXAgYmV0d2VlbiB0aGVzZSBlbGVtZW50cyBpcyBzaG93biBpbiB0aGUNCmZvbGxvd2luZyBmaWd1cmUuDQoNClBERiBTdWNjaW5jdGx5DQoNClBhZ2UgOCBvZiA4DQoNCg==',
          reason: 'failed');
      document.dispose();
    });
    test('Form filling', () {
      //Load the PDF document.
      final PdfDocument document =
          PdfDocument.fromBase64String(formSampleTemplate);
      //Get the form
      final PdfForm form = document.form;
      //Get text box and fill value
      final PdfTextBoxField name = document.form.fields[1] as PdfTextBoxField;
      name.text = 'George';
      final PdfTextBoxField email = document.form.fields[2] as PdfTextBoxField;
      email.text = 'george.sample@gmail.com';
      //Get the radio button and select
      final PdfRadioButtonListField gender =
          form.fields[3] as PdfRadioButtonListField;
      gender.selectedIndex = 0;
      final PdfTextBoxField dob = form.fields[0] as PdfTextBoxField;
      dob.text = '16/01/1992';
      //Get the combo box field and select
      final PdfComboBoxField country = form.fields[4] as PdfComboBoxField;
      country.selectedValue = 'Alaska';
      //Get the checkbox field
      final PdfCheckBoxField newsletter = form.fields[5] as PdfCheckBoxField;
      newsletter.isChecked = true;
      //Disable to view the form field values properly in mobile viewers
      form.setDefaultAppearance(false);
      //Save and dispose the document.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve find text sample');
      savePdf(bytes, 'Flut_6019_FormFilling.pdf');
      document.dispose();
    });
    test('Form filling flatten', () {
      //Load the PDF document.
      final PdfDocument document =
          PdfDocument.fromBase64String(formSampleTemplate);
      //Get the form
      final PdfForm form = document.form;
      //Get text box and fill value
      final PdfTextBoxField name = document.form.fields[1] as PdfTextBoxField;
      name.text = 'George';
      final PdfTextBoxField email = document.form.fields[2] as PdfTextBoxField;
      email.text = 'george.sample@gmail.com';
      //Get the radio button and select
      final PdfRadioButtonListField gender =
          form.fields[3] as PdfRadioButtonListField;
      gender.selectedIndex = 0;
      final PdfTextBoxField dob = form.fields[0] as PdfTextBoxField;
      dob.text = '16/01/1992';
      //Get the combo box field and select
      final PdfComboBoxField country = form.fields[4] as PdfComboBoxField;
      country.selectedValue = 'Alaska';
      //Get the checkbox field
      final PdfCheckBoxField newsletter = form.fields[5] as PdfCheckBoxField;
      newsletter.isChecked = true;
      //Disable to view the form field values properly in mobile viewers
      form.setDefaultAppearance(false);
      form.flattenAllFields();
      //Save and dispose the document.
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to preserve find text sample');
      savePdf(bytes, 'Flut_6019_FormFilling_Flatten.pdf');
      document.dispose();
    });
    const String importdatajson =
        'eyJkb2IiOiIwNS8wMS8xOTkyIiwibmFtZSI6IkpvaG4iLCJlbWFpbCI6IkpvaG4uc2ltb25zYmlzdHJvQGdtYWlsLmNvbSIsImdlbmRlciI6Ik1hbGUiLCJzdGF0ZSI6Ikdlb3JnaWEiLCJuZXdzbGV0dGVyIjoiT24ifQ==';
    const String importdataxfdf =
        'PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjx4ZmRmIHhtbG5zPSJodHRwOi8vbnMuYWRvYmUuY29tL3hmZGYvIiB4bWw6c3BhY2U9InByZXNlcnZlIj4NCiAgPGZpZWxkcz4NCiAgICA8ZmllbGQgbmFtZT0iZG9iIj4NCiAgICAgIDx2YWx1ZT4wNS8wMS8xOTkyPC92YWx1ZT4NCiAgICA8L2ZpZWxkPg0KICAgIDxmaWVsZCBuYW1lPSJuYW1lIj4NCiAgICAgIDx2YWx1ZT5Kb2huPC92YWx1ZT4NCiAgICA8L2ZpZWxkPg0KICAgIDxmaWVsZCBuYW1lPSJlbWFpbCI+DQogICAgICA8dmFsdWU+Sm9obi5zaW1vbnNiaXN0cm9AZ21haWwuY29tPC92YWx1ZT4NCiAgICA8L2ZpZWxkPg0KICAgIDxmaWVsZCBuYW1lPSJnZW5kZXIiPg0KICAgICAgPHZhbHVlPk1hbGU8L3ZhbHVlPg0KICAgIDwvZmllbGQ+DQogICAgPGZpZWxkIG5hbWU9InN0YXRlIj4NCiAgICAgIDx2YWx1ZT5HZW9yZ2lhPC92YWx1ZT4NCiAgICA8L2ZpZWxkPg0KICAgIDxmaWVsZCBuYW1lPSJuZXdzbGV0dGVyIj4NCiAgICAgIDx2YWx1ZT5PbjwvdmFsdWU+DQogICAgPC9maWVsZD4NCiAgPC9maWVsZHM+DQogIDxmIGhyZWY9IiIvPg0KPC94ZmRmPg==';
    const String importdataxml =
        'PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjxGaWVsZHM+DQogIDxkb2I+MDUvMDEvMTk5MjwvZG9iPg0KICA8bmFtZT5Kb2huPC9uYW1lPg0KICA8ZW1haWw+Sm9obi5zaW1vbnNiaXN0cm9AZ21haWwuY29tPC9lbWFpbD4NCiAgPGdlbmRlcj5NYWxlPC9nZW5kZXI+DQogIDxzdGF0ZT5HZW9yZ2lhPC9zdGF0ZT4NCiAgPG5ld3NsZXR0ZXI+T248L25ld3NsZXR0ZXI+DQo8L0ZpZWxkcz4=';
    test('Import sample', () async {
      final List<String> importData = <String>[
        importdatajson,
        importdataxfdf,
        importdataxml
      ];
      final List<DataFormat> format = <DataFormat>[
        DataFormat.json,
        DataFormat.xfdf,
        DataFormat.xml
      ];
      for (int i = 0; i < format.length; i++) {
        //Load the PDF data
        final PdfDocument document =
            PdfDocument.fromBase64String(formSampleTemplate);
        // //Import form data
        document.form.importData(base64.decode(importData[i]), format[i], true);
        //Save and launch the PDF document
        final List<int> documentBytes = await document.save();
        savePdf(documentBytes, 'Import_SB_sample_${format[i]}.pdf');
        document.dispose();
      }
    });
    const String expectedjson =
        'eyJkb2IiOiIwNS8wMS8xOTkyIiwibmFtZSI6IkpvaG4iLCJlbWFpbCI6IkpvaG4uc2ltb25zYmlzdHJvQGdtYWlsLmNvbSIsImdlbmRlciI6Ik1hbGUiLCJzdGF0ZSI6Ikdlb3JnaWEiLCJuZXdzbGV0dGVyIjoiT24ifQ==';
    const String expectedxfdf =
        'PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHhmZGYgeG1sbnM9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGZkZi8iIHhtbDpzcGFjZT0icHJlc2VydmUiPgogIDxmaWVsZHM+CiAgICA8ZmllbGQgbmFtZT0iZG9iIj4KICAgICAgPHZhbHVlPjA1LzAxLzE5OTI8L3ZhbHVlPgogICAgPC9maWVsZD4KICAgIDxmaWVsZCBuYW1lPSJuYW1lIj4KICAgICAgPHZhbHVlPkpvaG48L3ZhbHVlPgogICAgPC9maWVsZD4KICAgIDxmaWVsZCBuYW1lPSJlbWFpbCI+CiAgICAgIDx2YWx1ZT5Kb2huLnNpbW9uc2Jpc3Ryb0BnbWFpbC5jb208L3ZhbHVlPgogICAgPC9maWVsZD4KICAgIDxmaWVsZCBuYW1lPSJnZW5kZXIiPgogICAgICA8dmFsdWU+TWFsZTwvdmFsdWU+CiAgICA8L2ZpZWxkPgogICAgPGZpZWxkIG5hbWU9InN0YXRlIj4KICAgICAgPHZhbHVlPkdlb3JnaWE8L3ZhbHVlPgogICAgPC9maWVsZD4KICAgIDxmaWVsZCBuYW1lPSJuZXdzbGV0dGVyIj4KICAgICAgPHZhbHVlPk9uPC92YWx1ZT4KICAgIDwvZmllbGQ+CiAgPC9maWVsZHM+CiAgPGYgaHJlZj0iIi8+CjwveGZkZj4=';
    const String expectedXml =
        'PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPEZpZWxkcz4KICA8ZG9iPjA1LzAxLzE5OTI8L2RvYj4KICA8bmFtZT5Kb2huPC9uYW1lPgogIDxlbWFpbD5Kb2huLnNpbW9uc2Jpc3Ryb0BnbWFpbC5jb208L2VtYWlsPgogIDxnZW5kZXI+TWFsZTwvZ2VuZGVyPgogIDxzdGF0ZT5HZW9yZ2lhPC9zdGF0ZT4KICA8bmV3c2xldHRlcj5PbjwvbmV3c2xldHRlcj4KPC9GaWVsZHM+';
    test('Export sample', () async {
      final List<String> exportData = <String>[
        expectedjson,
        expectedxfdf,
        expectedXml
      ];
      final List<DataFormat> format = <DataFormat>[
        DataFormat.json,
        DataFormat.xfdf,
        DataFormat.xml
      ];
      for (int i = 0; i < format.length; i++) {
        //Load the PDF data
        final PdfDocument document =
            PdfDocument.fromBase64String(exportFormSampleTemplate);
        //Export the form data
        final List<int> dataBytes = document.form.exportData(format[i]);
        expect(
            utf8.decode(base64.decode(exportData[i])), utf8.decode(dataBytes),
            reason: 'Failed');
        document.dispose();
      }
    });
  });
}

double _calculateXPosition(String text, PdfFont font, double pageWidth) {
  final Size textSize =
      font.measureString(text, layoutArea: Size(pageWidth, 0));
  return (pageWidth - textSize.width) / 2;
}

//Draws the invoice header
PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid,
    PdfFont contentFont, PdfFont headerFont, PdfFont footerFont) {
  //Draw rectangle
  page.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(91, 126, 215)),
      bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
  //Draw string
  page.graphics.drawString('INVOICE', headerFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
      brush: PdfSolidBrush(PdfColor(65, 104, 205)));
  page.graphics.drawString(r'$' + _getTotalAmount(grid).toString(), footerFont,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
      brush: PdfBrushes.white,
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle));
  //Draw string
  page.graphics.drawString('Amount', contentFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.bottom));
  //Create data foramt and convert it to text.
  final DateFormat format = DateFormat.yMMMMd('en_US');
  final String invoiceNumber =
      'Invoice Number: 2058557939\r\n\r\nDate: ${format.format(DateTime(2022, 11, 11))}';
  final Size contentSize = contentFont.measureString(invoiceNumber);
  const String address =
      'Bill To: \r\n\r\nAbraham Swearegin, \r\n\r\nUnited States, California, San Mateo, \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136';
  PdfTextElement(text: invoiceNumber, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
          contentSize.width + 30, pageSize.height - 120));
  return PdfTextElement(text: address, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(30, 120, pageSize.width - (contentSize.width + 30),
          pageSize.height - 120))!;
}

//Draws the grid
void _drawGrid(
    PdfPage page, PdfGrid grid, PdfLayoutResult result, PdfFont contentFont) {
  Rect? totalPriceCellBounds;
  Rect? quantityCellBounds;
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
      totalPriceCellBounds = args.bounds;
    } else if (args.cellIndex == grid.columns.count - 2) {
      quantityCellBounds = args.bounds;
    }
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
  //Draw grand total.
  page.graphics.drawString('Grand Total', contentFont,
      bounds: Rect.fromLTWH(quantityCellBounds!.left, result.bounds.bottom + 10,
          quantityCellBounds!.width, quantityCellBounds!.height));
  page.graphics.drawString(_getTotalAmount(grid).toString(), contentFont,
      bounds: Rect.fromLTWH(
          totalPriceCellBounds!.left,
          result.bounds.bottom + 10,
          totalPriceCellBounds!.width,
          totalPriceCellBounds!.height));
}

//Draw the invoice footer data.
void _drawFooter(PdfPage page, Size pageSize, PdfFont contentFont) {
  final PdfPen linePen =
      PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
  linePen.dashPattern = <double>[3, 3];
  //Draw line
  page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
      Offset(pageSize.width, pageSize.height - 100));
  const String footerContent =
      '800 Interchange Blvd.\r\n\r\nSuite 2501, Austin, TX 78721\r\n\r\nAny Questions? support@adventure-works.com';
  //Added 30 as a margin for the layout
  page.graphics.drawString(footerContent, contentFont,
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
}

//Create PDF grid and return
PdfGrid _getGrid(PdfFont contentFont) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Product Id';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Product Name';
  headerRow.cells[2].value = 'Price';
  headerRow.cells[3].value = 'Quantity';
  headerRow.cells[4].value = 'Total';
  _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
  _addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
  _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
  _addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
  _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
  _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
  final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);
  final PdfBorders borders = PdfBorders();
  borders.all = PdfPen(PdfColor(142, 179, 219), width: 0.5);
  grid.rows.applyStyle(PdfGridCellStyle(borders: borders));
  grid.columns[1].width = 200;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    headerRow.cells[i].style.borders.all = whitePen;
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    if (i.isEven) {
      row.style.backgroundBrush = PdfSolidBrush(PdfColor(217, 226, 243));
    }
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  //Set font
  grid.style.font = contentFont;
  return grid;
}

//Create and row for the grid.
void _addProducts(String productId, String productName, double price,
    int quantity, double total, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  row.cells[0].value = productId;
  row.cells[1].value = productName;
  row.cells[2].value = price.toString();
  row.cells[3].value = quantity.toString();
  row.cells[4].value = total.toString();
}

//Get the total amount.
double _getTotalAmount(PdfGrid grid) {
  double total = 0;
  for (int i = 0; i < grid.rows.count; i++) {
    final String value =
        grid.rows[i].cells[grid.columns.count - 1].value as String;
    total += double.parse(value);
  }
  return total;
}

final dynamic _tableData = <String, List<Map<String, String>>>{
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

PdfDocument _createTableSample() {
  //Create a new PDF document.
  final PdfDocument document = PdfDocument();
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
  page.graphics.drawString('Northwind Customers',
      PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
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
  final dynamic details = _tableData['Customers'];
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
      bounds: Rect.fromLTWH(
          0, 65, page.getClientSize().width, page.getClientSize().height - 70));
  return document;
}

PdfDocument _createImageSample() {
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Get page graphics.
  final PdfGraphics graphics = document.pages.add().graphics;
  graphics.drawString('JPEG Image',
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      bounds: const Rect.fromLTWH(0, 40, 0, 0), brush: PdfBrushes.blue);
  //Load the JPEG image.
  PdfBitmap image = PdfBitmap.fromBase64String(imageJpeg);
  //Draw image.
  graphics.drawImage(image, const Rect.fromLTWH(0, 70, 515, 215));
  graphics.drawString('PNG Image',
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      bounds: const Rect.fromLTWH(0, 355, 0, 0), brush: PdfBrushes.blue);
  //Load the PNG image.
  image = PdfBitmap.fromBase64String(logoPng);
  //Draw image.
  graphics.drawImage(image, const Rect.fromLTWH(0, 365, 199, 300));
  return document;
}

PdfDocument _createListsSample() {
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Add a new PDF page.
  final PdfPage page = document.pages.add();

  //Draw text to the PDF page.
  page.graphics.drawString('Types of Animals',
      PdfStandardFont(PdfFontFamily.timesRoman, 18, style: PdfFontStyle.bold),
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
  return document;
}

PdfDocument _createRTLSample() {
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
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
  return document;
}

PdfLayoutResult _addParagraph(
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
      bounds:
          Rect.fromLTWH(bounds.left, bounds.top, bounds.width, bounds.height))!;
}

PdfBookmark _addBookmark(PdfPage page, String text, Offset point,
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

PdfDocument _createBookmarkSample() {
  //Create a PDF document
  final PdfDocument document = PdfDocument();
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
  PdfLayoutResult result = _addParagraph(page, 'Introduction',
      Rect.fromLTWH(0, 60, pageSize.width, pageSize.height), true);

  //Add bookmark
  _addBookmark(page, 'Introduction', result.bounds.topLeft, doc: document);
  result = _addParagraph(
      result.page,
      "Adobe Systems Incorporated's Portable Document Format (PDF) is the de facto standard for the accurate, reliable, and platform-independent representation of a paged document. It's the only universally accepted file format that allows pixel-perfect layouts.In addition, PDF supports user interaction and collaborative workflows that are not possible with printed documents.",
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false);
  result = _addParagraph(
      result.page,
      'The PDF Standard',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      true);
  final PdfBookmark standardBookmark = _addBookmark(
      result.page, 'The PDF Standard', result.bounds.topLeft,
      doc: document);
  result = _addParagraph(
      result.page,
      'The PDF format is an open standard maintained by the International Organization for Standardization. The official specification is defined in ISO 32000-1:2008, but Adobe also provides a free, comprehensive guide called PDF Reference - Sixth Edition.\nConceptual Overview: A PDF file can be divided into four parts: a header, body, cross-reference table, and trailer. The header marks the file as a PDF, the body defines the visible document, the cross-reference table lists the location of everything in the file, and the trailer provides instructions for how to start reading the file.',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false);
  result = _addParagraph(
      result.page,
      'Header',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      true);
  _addBookmark(result.page, 'Header', result.bounds.topLeft,
      bookmark: standardBookmark);
  result = _addParagraph(
      result.page,
      'The header is simply a PDF version number and an arbitrary sequence of binary data. The binary data prevents naïve applications from processing the PDF as a text file. This would result in a corrupted file, since a PDF typically consists of both plain text and binary data (e.g., a binary font file can be directly embedded in a PDF).',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false);
  result = _addParagraph(
      result.page,
      'Body',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      true);
  final PdfBookmark bodyBookmark = _addBookmark(
      result.page, 'Body', result.bounds.topLeft,
      bookmark: standardBookmark);

  result = _addParagraph(
      result.page,
      'The body of a PDF contains the entire visible document. The minimum elements required in a valid PDF body are:\n1) A page tree \n2) Pages \n3) Resources \n4) Content \n5) The catalog',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false);
  result = _addParagraph(
      result.page,
      '1. The Page Tree',
      Rect.fromLTWH(
          0, result.bounds.bottom + 50, pageSize.width, pageSize.height),
      true,
      subTitle: true);
  _addBookmark(result.page, '1. The Page Tree', result.bounds.topLeft,
      bookmark: bodyBookmark);

  result = _addParagraph(
      result.page,
      "The page tree is a dictionary object containing a list of the pages that make up the document. A minimal page tree contains just one page. Objects are enclosed in the obj and endobj tags, and they begin with a unique identification number (1 0). The first number is the object number, and the second is the generation number. The latter is only used for incremental updates, so all the generation numbers in our examples will be 0. As we'll see in a moment, PDFs use these identifiers to refer to individual objects from elsewhere in the document.",
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false);
  result = _addParagraph(
      result.page,
      '2. Page(s)',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      true,
      subTitle: true);
  _addBookmark(result.page, '2. Page(s)', result.bounds.topLeft,
      bookmark: bodyBookmark);

  result = _addParagraph(
      result.page,
      "Next, we'll create the second object, which is the only page referenced by /Kids in the previous section. The /Type entry always specifies the type of the object. Many times, this can be omitted if the object type can be inferred by context. Note that PDF uses a name to identify the object type-not a literal string.",
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false);
  result = _addParagraph(
      result.page,
      '3. Resources',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      true,
      subTitle: true);
  _addBookmark(result.page, '3. Resources', result.bounds.topLeft,
      bookmark: bodyBookmark);

  result = _addParagraph(
      result.page,
      "The third object is a resource defining a font configuration. The /Font key contains a whole dictionary, opposed to the name/value pairs we've seen previously (e.g., /Type /Page). The font we configured is called /F0, and the font face we selected is /Times-Roman. The /Subtype is the format of the font file, and /Type1 refers to the PostScript type 1 file format.",
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false);
  result = _addParagraph(
      result.page,
      '4. Content',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      true,
      subTitle: true);
  _addBookmark(result.page, '4. Content', result.bounds.topLeft,
      bookmark: bodyBookmark);

  result = _addParagraph(
      result.page,
      'Finally, we are able to specify the actual content of the page. Page content is represented as a stream object. Stream objects consist of a dictionary of metadata and a stream of bytes.',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false,
      subTitle: true);
  result = _addParagraph(
      result.page,
      '5. Catalog',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      true,
      subTitle: true);
  _addBookmark(result.page, '5. Catalog', result.bounds.topLeft,
      bookmark: bodyBookmark);

  result = _addParagraph(
      result.page,
      'The last section of the body is the catalog, which points to the root page tree (1 0 R). This may seem like an unnecessary reference, but dividing a document into multiple page trees is a common way to optimize PDFs. In such a case, programs need to know where the document starts.',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false);
  result = _addParagraph(
      result.page,
      'Cross-Reference Table',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      true);
  _addBookmark(result.page, 'Cross-Reference Table', result.bounds.topLeft,
      bookmark: standardBookmark);
  result = _addParagraph(
      result.page,
      "The cross-reference table provides the location of each object in the body of the file. Locations are recorded as byte-offsets from the beginning of the file. This is another job for pdftk-all we have to do is add the xref keyword. We'll take a closer look at the cross-reference table after we generate the final PDF.",
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false);
  result = _addParagraph(
      result.page,
      'Trailer',
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      true);
  _addBookmark(result.page, 'Trailer', result.bounds.topLeft,
      bookmark: standardBookmark);
  result = _addParagraph(
      result.page,
      "The last part of the file is the trailer. It's comprised of the trailer keyword, followed by a dictionary that contains a reference to the catalog, then a pointer to the crossreference table, and finally an end-of-file marker. The /Root points to the catalog, not the root page tree. This is important because the catalog can also contain important information about the document structure. The startxref keyword points to the location (in bytes) of the beginning of the crossreference table.",
      Rect.fromLTWH(
          0, result.bounds.bottom + 30, pageSize.width, pageSize.height),
      false);
  return document;
}

PdfDocument _createHeaderFooterSample() {
  //Create PDF document.
  final PdfDocument document = PdfDocument();
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
  final PdfStandardFont h1Font =
      PdfStandardFont(PdfFontFamily.helvetica, 25, style: PdfFontStyle.bold);
  final PdfStandardFont contentFont =
      PdfStandardFont(PdfFontFamily.helvetica, 17, style: PdfFontStyle.regular);
  //Get the page client size
  final Size size = page.getClientSize();
  //Create a text element and draw it to the page
  PdfLayoutResult result = PdfTextElement(
          text: 'PDF Succinctly',
          font: PdfStandardFont(PdfFontFamily.helvetica, 30,
              style: PdfFontStyle.bold),
          brush: PdfBrushes.red,
          format: PdfStringFormat(alignment: PdfTextAlignment.center))
      .draw(
          page: page,
          bounds: Rect.fromLTWH(0, 30, size.width, size.height - 30))!;

  result = PdfTextElement(text: 'Introduction', font: h1Font).draw(
      page: page,
      bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
          size.height - result.bounds.bottom + 30))!;

  result = PdfTextElement(
          text:
              "Adobe Systems Incorporated's Portable Document Format (PDF) is the de facto standard for the accurate, reliable, and platform-independent representation of a paged document. It's the only universally accepted file format that allows pixel-perfect layouts. In addition, PDF supports user interaction and collaborative workflows that are not possible with printed documents.\r\n\r\nPDF documents have been in widespread use for years, and dozens of free and commercial PDF readers, editors, and libraries are readily available. However, despite this popularity, it's still difficult to find a succinct guide to the native PDF format. Understanding the internal workings of a PDF makes it possible to dynamically generate PDF documents. For example, a web server can extract information from a database, use it to customize an invoice, and serve it to the customer on the fly.",
          font: contentFont)
      .draw(
          page: result.page,
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
              size.height - result.bounds.bottom + 30))!;

  result = PdfTextElement(text: 'The PDF Standard', font: h1Font).draw(
      page: result.page,
      bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
          size.height - result.bounds.bottom + 30),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;

  result = PdfTextElement(
          text:
              'The PDF format is an open standard maintained by the International Organization for Standardization. The official specification is defined in ISO 32000-1:2008, but Adobe also provides a free, comprehensive guide called PDF Reference, Sixth Edition, version 1.7.',
          font: contentFont)
      .draw(
          page: result.page,
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
              size.height - result.bounds.bottom + 30),
          format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate))!;
  final PdfTextElement element =
      PdfTextElement(text: 'Conceptual Overview', font: h1Font);
  result = element.draw(
      page: result.page,
      bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
          size.height - result.bounds.bottom + 30),
      format: PdfLayoutFormat(
          paginateBounds: Rect.fromLTWH(0, 30, size.width, size.height - 30)))!;
  result = PdfTextElement(
          text:
              "We'll begin with a conceptual overview of a simple PDF document. This chapter is designed to be a brief orientation before diving in and creating a real document from scratch. A PDF file can be divided into four parts: a header, body, cross-reference table, and trailer. The header marks the file as a PDF, the body defines the visible document, the cross-reference table lists the location of everything in the file, and the trailer provides instructions for how to start reading the file.",
          font: contentFont)
      .draw(
          page: result.page,
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, size.width,
              size.height - result.bounds.bottom + 30))!;
  return document;
}
