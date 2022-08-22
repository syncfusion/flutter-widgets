import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_docs.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void hyperLink() {
  group('Hyper link for web nagivation with page', () {
    test('Sample file 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.center;
      format.lineAlignment = PdfVerticalAlignment.middle;
      final PdfTextWebLink webLink = PdfTextWebLink(
          url: 'www.google.co.in',
          text: 'google',
          font: font,
          brush: brush,
          pen: PdfPens.brown,
          format: format);
      webLink.draw(page, const Offset(50, 40));
      page.graphics.drawString('Go to google Web Site through page', font,
          brush: brush, bounds: const Rect.fromLTWH(110, 40, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to navigate web link');
      savePdf(bytes, 'FLUT-553-WebLinkWithPage.pdf');
      document.dispose();
    });
  });

  group('Hyper link for web nagivation', () {
    test('Sample file 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      final PdfTextWebLink webLink =
          PdfTextWebLink(url: 'www.syncfusion.com', text: 'Syncfusion');
      webLink.url = 'www.syncfusion.com';
      webLink.text = 'Syncfusion';
      webLink.font = font;
      webLink.brush = brush;
      webLink.pen = PdfPens.limeGreen;
      webLink.draw(page, const Offset(50, 40));
      page.graphics.drawString(
          'Go to syncfusion Web Site through the graphics', font,
          brush: brush, bounds: const Rect.fromLTWH(140, 40, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to navigate web link');
      savePdf(bytes, 'FLUT-553-WebLinkWithGraphics.pdf');
      document.dispose();
    });
  });

  group('Hyper link for internal document navigation', () {
    test('Sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 30, 30);
      final PdfPage navPage = document.pages.add();
      final PdfDestination destination =
          PdfDestination(navPage, const Offset(10, 0));
      final PdfDocumentLinkAnnotation inLink =
          PdfDocumentLinkAnnotation(bounds, destination);
      inLink.destination!.zoom = 2;
      page.annotations.add(inLink);
      page.graphics.drawString(
          "To click the box, Let's moved to second page with the zoom 200%",
          font,
          brush: brush,
          bounds: const Rect.fromLTWH(70, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform internal document navigation');
      savePdf(bytes, 'FLUT-553-InternalDocNagivation.pdf');
      document.dispose();
    });
  });

  documentNagivationWithDestinationModes();

  group('Hyper link for Action Annotation test with the uriAction', () {
    test('noHighlighting', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 100, 30);
      final PdfUriAction uriAction = PdfUriAction('www.syncfusion.com');
      final PdfActionAnnotation actionAnnotation =
          PdfActionAnnotation(bounds, uriAction);
      actionAnnotation.highlightMode = PdfHighlightMode.noHighlighting;
      page.annotations.add(actionAnnotation);
      page.graphics.drawString(
          'Hyper link for Action Annotation with the uriAction', font,
          brush: brush, bounds: const Rect.fromLTWH(130, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform ActionAnnotation link');
      document.dispose();
    });
    test('PdfHighlightMode.push', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 100, 30);
      final PdfUriAction uriAction = PdfUriAction('www.syncfusion.com');
      final PdfActionAnnotation actionAnnotation =
          PdfActionAnnotation(bounds, uriAction);
      if (actionAnnotation.highlightMode != PdfHighlightMode.push) {
        actionAnnotation.highlightMode = PdfHighlightMode.push;
      }
      page.annotations.add(actionAnnotation);
      page.graphics.drawString(
          'Hyper link for Action Annotation with the uriAction', font,
          brush: brush, bounds: const Rect.fromLTWH(130, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform ActionAnnotation link');
      savePdf(bytes, 'FLUT-553-ActionAnnotationsWithHighLight1.pdf');
      document.dispose();
    });
    test('PdfHighlightMode.outline', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 100, 30);
      final PdfUriAction uriAction = PdfUriAction('www.syncfusion.com');
      final PdfActionAnnotation actionAnnotation =
          PdfActionAnnotation(bounds, uriAction);
      actionAnnotation.border.horizontalRadius = 2;
      actionAnnotation.border.verticalRadius = 2;
      actionAnnotation.highlightMode = PdfHighlightMode.outline;
      page.annotations.add(actionAnnotation);
      page.graphics.drawString(
          'Hyper link for Action Annotation with the uriAction', font,
          brush: brush, bounds: const Rect.fromLTWH(130, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform ActionAnnotation link');
      document.dispose();
    });
    test('sample file with PdfHighlightMode.invert', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 100, 30);
      final PdfUriAction uriAction = PdfUriAction('www.syncfusion.com');
      final PdfActionAnnotation actionAnnotation =
          PdfActionAnnotation(bounds, uriAction);
      final PdfAnnotationBorder border = PdfAnnotationBorder(5);
      actionAnnotation.border = border;
      actionAnnotation.highlightMode = PdfHighlightMode.invert;
      page.annotations.add(actionAnnotation);
      page.graphics.drawString(
          'Hyper link for Action Annotation with the uriAction', font,
          brush: brush, bounds: const Rect.fromLTWH(130, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform ActionAnnotation link');
      savePdf(bytes, 'FLUT-553-ActionAnnotationsWithHighLight2.pdf');
      document.dispose();
    });
  });

  group('Hyper link for UriAnnotation', () {
    test('Sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 30, 30);
      final PdfUriAnnotation uriAnnotation =
          PdfUriAnnotation(bounds: bounds, uri: 'www.google.com');
      uriAnnotation.text = 'Uri Annotation';
      page.annotations.add(uriAnnotation);
      page.graphics.drawString('Click the box for google site', font,
          brush: brush, bounds: const Rect.fromLTWH(70, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform uri annotation');
      savePdf(bytes, 'FLUT-553-UriAnnotations.pdf');
      document.dispose();
    });
  });

  group('Uri Annotation test with the Next action', () {
    test('sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 30, 30);
      final PdfUriAnnotation uriAnnotation =
          PdfUriAnnotation(bounds: bounds, uri: 'www.google.co.in');
      uriAnnotation.uri = 'www.google.com';
      uriAnnotation.text = 'Uri Annotation';
      final PdfUriAction uriAction = PdfUriAction('www.syncfusion.com');
      if (uriAction.next == null) {
        uriAnnotation.action ??= uriAction;
      }
      page.annotations.add(uriAnnotation);
      page.graphics.drawString(
          'Click the box for google site and instantly you will be taken to Syncfusion site',
          font,
          brush: brush,
          bounds: const Rect.fromLTWH(70, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform uri annotation with next action');
      savePdf(bytes, 'FLUT-553-UriAnnotationsWithAction.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
void documentNagivationWithDestinationModes() {
  group('Hyper link for internal document navigation', () {
    test('With destinationMode.fitR Sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 30, 30);
      final PdfPage navPage = document.pages.add();
      final PdfDestination destination =
          PdfDestination(navPage, const Offset(10, 0));
      final PdfDocumentLinkAnnotation inLink =
          PdfDocumentLinkAnnotation(bounds, destination);
      inLink.destination!.mode = PdfDestinationMode.fitR;
      page.annotations.add(inLink);
      page.graphics.drawString(
          "To click the box, Let's moved to second page with the fitR", font,
          brush: brush, bounds: const Rect.fromLTWH(70, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform internal document navigation');
      savePdf(bytes, 'FLUT-553-InternalDocNagivationWithFitR.pdf');
      document.dispose();
    });
  });
  group('Hyper link for internal document navigation', () {
    test('With destinationMode.fitH Sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 30, 30);
      final PdfPage navPage = document.pages.add();
      final PdfDestination destination =
          PdfDestination(navPage, const Offset(10, 0));
      final PdfDocumentLinkAnnotation inLink =
          PdfDocumentLinkAnnotation(bounds, destination);
      inLink.destination!.zoom = 1;
      inLink.destination!.mode = PdfDestinationMode.fitH;
      page.annotations.add(inLink);
      page.graphics.drawString(
          "To click the box, Let's moved to second page with the fitH", font,
          brush: brush, bounds: const Rect.fromLTWH(70, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform internal document navigation');
      savePdf(bytes, 'FLUT-553-InternalDocNagivationWithFitH.pdf');
      document.dispose();
    });
  });
  group('Hyper link for internal document navigation', () {
    test('With destinationMode.fitToPage Sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 30, 30);
      final PdfPage navPage = document.pages.add();
      final PdfDestination destination =
          PdfDestination(navPage, const Offset(10, 0));
      final PdfDocumentLinkAnnotation inLink =
          PdfDocumentLinkAnnotation(bounds, destination);
      inLink.destination!.zoom = 1;
      inLink.destination!.mode = PdfDestinationMode.fitToPage;
      page.annotations.add(inLink);
      page.graphics.drawString(
          "To click the box, Let's moved to second page with the fitToPage",
          font,
          brush: brush,
          bounds: const Rect.fromLTWH(70, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform internal document navigation');
      savePdf(bytes, 'FLUT-553-InternalDocNagivationWithfitToPage.pdf');
      document.dispose();
    });
  });
  group('Hyper link for internal document navigation', () {
    test('With destinationMode.Location Sample file', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0));
      final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 14);
      const Rect bounds = Rect.fromLTWH(10, 40, 30, 30);
      final PdfPage navPage = document.pages.add();
      final PdfDestination destination =
          PdfDestination(navPage, const Offset(10, 0));
      final PdfDocumentLinkAnnotation inLink =
          PdfDocumentLinkAnnotation(bounds, destination);
      inLink.destination!.zoom = 3;
      inLink.destination!.mode = PdfDestinationMode.location;
      page.annotations.add(inLink);
      page.graphics.drawString(
          "To click the box, Let's moved to second page with the Location",
          font,
          brush: brush,
          bounds: const Rect.fromLTWH(70, 57, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to perform internal document navigation');
      savePdf(bytes, 'FLUT-553-InternalDocNagivationWithLocation.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
void uriAnnotation() {
  group('Uri Annotation from existing document', () {
    test('sample 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(uriAnot1);
      final PdfPage page = document.pages[0];
      final PdfUriAnnotation uriAnnot = page.annotations[0] as PdfUriAnnotation;
      expect(uriAnnot.uri, 'www.google.com',
          reason: 'Failed to get the uri annotation');
      uriAnnot.uri = 'https://www.syncfusion.com/';
      final PdfUriAnnotation uriAnnotation = PdfUriAnnotation(
          bounds: const Rect.fromLTWH(40, 240, 30, 30),
          uri: 'https://flutter.dev/');
      page.annotations.add(uriAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to get uri annotation from existing document');
      savePdf(bytes, 'FLUT-1735-UriAnnotations1.pdf');
      document.dispose();
    });
  });

  group('Uri Annotation from existing document', () {
    test('sample 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(uriAnot2);
      final PdfUriAnnotation uriAnnotation =
          document.pages[0].annotations[0] as PdfUriAnnotation;
      expect(uriAnnotation.uri, 'www.google.com',
          reason: 'Failed to get the uri annotation');
      uriAnnotation.uri = 'https://flutter.dev/';

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to get uri annotation from existing document');
      savePdf(bytes, 'FLUT-1735-UriAnnotations2.pdf');
      document.dispose();
    });
  });

  group('Uri Annotation from existing document', () {
    test('sample 3', () {
      final PdfDocument document = PdfDocument.fromBase64String(uriAnot3);
      final PdfPage page = document.pages[0];
      final PdfUriAnnotation uriAnnot = page.annotations[0] as PdfUriAnnotation;
      final PdfUriAnnotation uriAnnot1 =
          page.annotations[1] as PdfUriAnnotation;
      final PdfUriAnnotation uriAnnot2 =
          page.annotations[2] as PdfUriAnnotation;
      final PdfUriAnnotation uriAnnot3 =
          page.annotations[3] as PdfUriAnnotation;
      expect(uriAnnot.uri, 'www.google.com',
          reason: 'Failed to get the uri annotation');
      expect(uriAnnot1.uri, 'https://www.syncfusion.com/',
          reason: 'Failed to get the uri annotation');
      expect(uriAnnot2.uri, 'https://flutter.dev/',
          reason: 'Failed to get the uri annotation');
      expect(uriAnnot3.uri, 'https://dart.dev/',
          reason: 'Failed to get the uri annotation');
      uriAnnot.uri = 'https://www.syncfusion.com/';
      final PdfUriAnnotation uriAnnotation = PdfUriAnnotation(
          bounds: const Rect.fromLTWH(180, 440, 30, 30), uri: uriAnnot3.uri);
      page.annotations.add(uriAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to get uri annotation from existing document');
      savePdf(bytes, 'FLUT-1735-UriAnnotations3.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
void textWeblinkAnnotation() {
  group('TextWeblink Annotation from existing document', () {
    test('sample 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(webLinkFile1);
      final PdfPage page = document.pages[0];
      final PdfTextWebLink weblink = page.annotations[0] as PdfTextWebLink;
      expect(weblink.url, 'www.google.co.in',
          reason: 'Failed to get the weblink annotation');
      weblink.url = 'https://www.syncfusion.com/';

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to get weblink annotation from existing document');
      savePdf(bytes, 'FLUT-1959-WeblinkAnnotation.pdf');
      document.dispose();
    });
  });

  group('TextWeblink Annotation from existing document', () {
    test('sample 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(webLinkFile2);
      final PdfPage page = document.pages[0];
      final PdfTextWebLink weblink = page.annotations[0] as PdfTextWebLink;
      expect(weblink.url, 'www.syncfusion.com',
          reason: 'Failed to get the weblink annotation');
      weblink.url = 'https://dart.dev/';

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to get weblink annotation from existing document');
      savePdf(bytes, 'FLUT-1959-WeblinkAnnotation2.pdf');
      document.dispose();
    });
  });

  group('TextWeblink Annotation from existing document', () {
    test('sample 3', () {
      final PdfDocument document = PdfDocument.fromBase64String(webLinkFile3);
      final PdfPage page = document.pages[0];
      final PdfTextWebLink weblink = page.annotations[0] as PdfTextWebLink;
      final PdfTextWebLink weblink1 = page.annotations[1] as PdfTextWebLink;
      final PdfTextWebLink weblink2 = page.annotations[2] as PdfTextWebLink;
      final PdfTextWebLink weblink3 = page.annotations[3] as PdfTextWebLink;
      expect(weblink.url, 'www.syncfusion.com',
          reason: 'Failed to get the weblink annotation');
      expect(weblink1.url, 'https://www.google.co.in/',
          reason: 'Failed to get the weblink annotation');
      expect(weblink2.url, 'https://flutter.dev/',
          reason: 'Failed to get the weblink annotation');
      expect(weblink3.url, 'https://dart.dev/',
          reason: 'Failed to get the weblink annotation');
      weblink1.url = 'www.google.com';

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to get weblink annotation from existing document');
      savePdf(bytes, 'FLUT-1959-WeblinkAnnotation3.pdf');
      document.dispose();
    });
  });

  group('TextWeblink Annotation from existing document', () {
    test('sample 4', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(webLinkWExternalFile1);
      final PdfPage page = document.pages[0];
      final PdfTextWebLink weblink = page.annotations[0] as PdfTextWebLink;
      expect(weblink.url, 'http://www.antennahouse.com/purchase.htm',
          reason: 'Failed to get the weblink annotation');
      weblink.url = 'www.google.com';

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to get weblink annotation from existing document');
      document.dispose();
    });
  });

  group('TextWeblink Annotation from existing document', () {
    test('sample 5', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(webLinkWExternalFile2);
      final PdfPage page = document.pages[0];
      final PdfTextWebLink weblink = page.annotations[0] as PdfTextWebLink;
      final PdfTextWebLink weblink1 = page.annotations[1] as PdfTextWebLink;
      expect(weblink.url, 'http://dx.doi.org/10.1063/1.3374401',
          reason: 'Failed to get the weblink annotation');
      expect(weblink1.url, 'http://dx.doi.org/10.1063/1.3374401',
          reason: 'Failed to get the weblink annotation');
      weblink.url = 'www.google.com';

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to get weblink annotation from existing document');
      savePdf(bytes, 'FLUT-1959-WeblinkAnnotation5.pdf');
      document.dispose();
    });
  });

  group('TextWeblink Annotation from existing document', () {
    test('sample 6', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(webLinkWExternalFile3);
      final PdfPage page = document.pages[0];
      final PdfTextWebLink weblink = page.annotations[0] as PdfTextWebLink;
      expect(weblink.url, 'http://programmingwithmosh.com',
          reason: 'Failed to get the weblink annotation');

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to get weblink annotation from existing document');
      document.dispose();
    });
  });
}
