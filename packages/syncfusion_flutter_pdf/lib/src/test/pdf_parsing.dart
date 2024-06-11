import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/pages/pdf_page.dart';
import '../pdf/implementation/primitives/pdf_array.dart';
import '../pdf/implementation/primitives/pdf_dictionary.dart';
import '../pdf/implementation/primitives/pdf_name.dart';
import '../pdf/implementation/primitives/pdf_number.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_docs.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pdfParsing() {
  group('PDF Parsing', () {
    test('Load empty PDF', () {
      final PdfDocument doc = PdfDocument();
      final List<int> input = doc.saveSync();
      doc.dispose();
      final PdfDocument document = PdfDocument(inputBytes: input);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw header at top');
      savePdf(bytes, 'FLUT_945_Empty.pdf');
      document.dispose();
    });
    test('Add a new page in empty loaded PDF', () {
      final PdfDocument doc = PdfDocument();
      final List<int> input = doc.saveSync();
      doc.dispose();
      final PdfDocument document = PdfDocument(inputBytes: input);
      PdfPage page = document.pages[0];
      expect(document.pages.indexOf(page), 0);
      page = document.pages.add();
      expect(document.pages.indexOf(page), 1);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw header at top');
      savePdf(bytes, 'FLUT_945_NewPage.pdf');
      document.dispose();
    });
    test('Add a new page insert at 0 in loaded hello world PDF', () {
      final PdfDocument doc = PdfDocument();
      doc.pages.add().graphics.drawString(
          'hello world', PdfStandardFont(PdfFontFamily.helvetica, 12));
      final List<int> input = doc.saveSync();
      doc.dispose();
      final PdfDocument document = PdfDocument(inputBytes: input);
      document.pages.insert(0);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to draw header at top');
      savePdf(bytes, 'FLUT_945_Insert_0.pdf');
      document.dispose();
    });
    test('Add a new page insert at 10 in loaded PDF', () {
      final PdfDocument document = PdfDocument();
      for (int i = 0; i < 10; i++) {
        document.pages.add();
      }
      final List<int> bytes = document.saveSync();
      document.dispose();
      final PdfDocument loadedDocument = PdfDocument(inputBytes: bytes);
      final List<int> loadedbytes = loadedDocument.saveSync();
      expect(loadedbytes.isNotEmpty, true,
          reason: 'failed to draw header at top');
      savePdf(loadedbytes, 'FLUT_945_Insert_10.pdf');
      loadedDocument.dispose();
    });
    test('page count - 1', () {
      final PdfDocument document = PdfDocument();
      for (int i = 0; i < 10; i++) {
        document.pages.add();
      }
      final List<int> bytes = document.saveSync();
      final PdfDocument loadedDocument = PdfDocument(inputBytes: bytes);
      expect(loadedDocument.pages.count, 10,
          reason: 'failed to get page count');
      loadedDocument.dispose();
      document.dispose();
    });
    test('page count - 2', () {
      final PdfDocument document = PdfDocument();
      PdfSection section = document.sections!.add();
      for (int i = 0; i < 5; i++) {
        section.pages.add();
      }
      section = document.sections!.add();
      for (int i = 0; i < 5; i++) {
        section.pages.add();
      }
      final List<int> bytes = document.saveSync();
      final PdfDocument loadedDocument = PdfDocument(inputBytes: bytes);
      expect(loadedDocument.pages.count, 10,
          reason: 'failed to get page count');
      loadedDocument.dispose();
      document.dispose();
    });
    test('page dictionary - 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(barcodePdf);
      for (int i = 0; i < document.pages.count; i++) {
        final Iterable<PdfName?> key =
            PdfPageHelper.getHelper(document.pages[i]).dictionary!.items!.keys;
        expect(key.elementAt(0)!.name, 'Type');
        expect(key.elementAt(1)!.name, 'Parent');
        expect(key.elementAt(2)!.name, 'Contents');
        expect(key.elementAt(3)!.name, 'Resources');
      }
      final dynamic value1 =
          PdfPageHelper.getHelper(document.pages[0]).dictionary!.items!.values;
      expect((value1.elementAt(0) as PdfName).name, 'Page');
      expect(
          ((value1.elementAt(3) as PdfDictionary).items!.keys.elementAt(0)!)
              .name,
          'ProcSet');
      final dynamic value2 =
          PdfPageHelper.getHelper(document.pages[1]).dictionary!.items!.values;
      expect(
          ((value2.elementAt(3) as PdfDictionary).items!.keys.elementAt(1)!)
              .name,
          'Font');
      document.dispose();
    });
    test('page dictionary -3', () {
      final PdfDocument document = PdfDocument.fromBase64String(essentialPdf);
      for (int i = 0; i < document.pages.count; i++) {
        final Iterable<PdfName?> key =
            PdfPageHelper.getHelper(document.pages[i]).dictionary!.items!.keys;
        expect(key.elementAt(0)!.name, 'Contents');
        expect(key.elementAt(1)!.name, 'Type');
        expect(key.elementAt(2)!.name, 'Parent');
        expect(key.elementAt(3)!.name, 'Resources');
        expect(key.elementAt(4)!.name, 'MediaBox');
      }
      final dynamic items =
          PdfPageHelper.getHelper(document.pages[0]).dictionary!.items;
      expect((items[items.keys.elementAt(4)] as PdfArray).count, 4);
      expect(
          (PdfPageHelper.getHelper(document.pages[0])
                  .dictionary!
                  .items!
                  .values
                  .elementAt(1)! as PdfName)
              .name,
          'Page');
      expect(
          (PdfPageHelper.getHelper(document.pages[1])
                  .dictionary!
                  .items!
                  .values
                  .elementAt(3)! as PdfDictionary)
              .items!
              .keys
              .elementAt(0)!
              .name,
          'XObject');
      document.dispose();
    });
    test('page dictionary -4', () {
      final PdfDocument document = PdfDocument.fromBase64String(essentialXlsio);
      for (int i = 0; i < document.pages.count; i++) {
        final Iterable<PdfName?> key =
            PdfPageHelper.getHelper(document.pages[i]).dictionary!.items!.keys;
        expect(key.elementAt(0)!.name, 'Contents');
        expect(key.elementAt(1)!.name, 'Type');
        expect(key.elementAt(2)!.name, 'Parent');
        expect(key.elementAt(3)!.name, 'Resources');
        expect(key.elementAt(4)!.name, 'MediaBox');
      }
      final dynamic value2 =
          PdfPageHelper.getHelper(document.pages[1]).dictionary!.items!.values;
      expect(
          ((value2.elementAt(4) as PdfArray).elements[0]! as PdfNumber).value,
          0);
      expect(
          ((value2.elementAt(4) as PdfArray).elements[3]! as PdfNumber).value,
          842);
      expect(
          ((value2.elementAt(3) as PdfDictionary).items!.values.elementAt(1)!
                  as PdfArray)
              .count,
          3);
      document.dispose();
    });
  });
  group('Remove page', () {
    test('page creation and removal', () {
      final PdfDocument document = PdfDocument();
      for (int i = 0; i < 5; i++) {
        final PdfPage page = document.pages.add();
        page.graphics.drawString(
            'Page ${i + 1}', PdfStandardFont(PdfFontFamily.helvetica, 14));
      }
      final List<int> bytes = document.saveSync();
      final PdfDocument ldoc = PdfDocument(inputBytes: bytes);
      ldoc.pages.removeAt(0);
      expect(ldoc.pages.count, 4, reason: 'failed to remove page');
      final List<int> lbytes = ldoc.saveSync();
      savePdf(lbytes, 'FLUT_2310_PageCreateRemove.pdf');
    });
    test('multiple page creation and removal', () {
      final PdfDocument document = PdfDocument();
      for (int i = 0; i < 5; i++) {
        final PdfPage page = document.pages.add();
        page.graphics.drawString(
            'Page ${i + 1}', PdfStandardFont(PdfFontFamily.helvetica, 14));
      }
      final List<int> bytes = document.saveSync();
      final PdfDocument ldoc = PdfDocument(inputBytes: bytes);
      ldoc.pages.removeAt(4);
      ldoc.pages.removeAt(2);
      ldoc.pages.remove(ldoc.pages[0]);
      expect(ldoc.pages.count, 2, reason: 'failed to remove page');
      final List<int> lbytes = ldoc.saveSync();
      savePdf(lbytes, 'FLUT_2310_MultiplePageCreateRemove.pdf');
    });
    test('page removal - barcode.pdf - 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(barcodePdf);
      document.pages.removeAt(0);
      expect(document.pages.count, 1, reason: 'failed to remove page');
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Flut_2310_barcode_1.pdf');
    });
    test('page removal - barcode.pdf - 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(barcodePdf);
      document.pages.add();
      document.pages.removeAt(0);
      expect(document.pages.count, 2, reason: 'failed to remove page');
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Flut_2310_barcode_2.pdf');
    });
    test('page removal - barcode.pdf - 3', () {
      final PdfDocument document = PdfDocument.fromBase64String(barcodePdf);
      document.pages.insert(0);
      document.pages.removeAt(0);
      expect(document.pages.count, 2, reason: 'failed to remove page');
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Flut_2310_barcode_3.pdf');
    });
    test('page removal - FLUT_2310_Bookmark.pdf', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkPageRemove);
      document.pages.removeAt(0);
      expect(document.pages.count, 125, reason: 'failed to remove page');
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_2310_Bookmark.pdf');
    });
    test('page removal with bookmarks', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfStandardFont font = PdfStandardFont(PdfFontFamily.helvetica, 20);
      final PdfBookmark bookmark1 = document.bookmarks.add('bookmark 1');
      final PdfBookmark bookmark2 = document.bookmarks.add('bookmark 2');
      final PdfBookmark bookmark3 = document.bookmarks.add('bookmark 3');
      bookmark1.destination = PdfDestination(page3, const Offset(300, 400));
      bookmark2.destination = PdfDestination(page, const Offset(400, 600));
      bookmark3.destination = PdfDestination(page2, const Offset(20, 20));
      page.graphics.drawString('hello world2', font,
          bounds: Rect.fromLTWH(400, 600, page.getClientSize().width,
              page.getClientSize().height));
      page2.graphics.drawString('hello world3', font,
          bounds: Rect.fromLTWH(20, 20, page2.getClientSize().width,
              page2.getClientSize().height));
      page3.graphics.drawString('hello world1', font,
          bounds: Rect.fromLTWH(300, 400, page3.getClientSize().width,
              page3.getClientSize().height));
      final List<int> bytes = document.saveSync();
      final PdfDocument ldoc = PdfDocument(inputBytes: bytes);
      ldoc.pages.removeAt(0);
      expect(ldoc.pages.count, 2, reason: 'failed to remove page');
      final List<int> lbytes = ldoc.saveSync();
      savePdf(lbytes, 'FLUT_2310_PageBookmarkRemove.pdf');
    });
  });
}

// ignore: public_member_api_docs
void saveDocument() {
  group('Crop Box', () {
    test('Rotation Angle 0', () {
      final PdfDocument document = PdfDocument.fromBase64String(cropAdobe0);
      document.pages.add().graphics.drawRectangle(
          bounds: const Rect.fromLTWH(0, 0, 300, 80), brush: PdfBrushes.red);
      final List<int> bytes = document.saveSync();
      document.dispose();
      savePdf(bytes, 'CropAdobe0.pdf');
    });
    test('Rotation Angle 90', () {
      final PdfDocument document = PdfDocument.fromBase64String(cropAdobe90);
      document.pages.add().graphics.drawRectangle(
          bounds: const Rect.fromLTWH(0, 0, 300, 80), brush: PdfBrushes.red);
      final List<int> bytes = document.saveSync();
      document.dispose();
      savePdf(bytes, 'CropAdobe90.pdf');
    });
    test('Rotation Angle 180', () {
      final PdfDocument document = PdfDocument.fromBase64String(cropAdobe180);
      document.pages.add().graphics.drawRectangle(
          bounds: const Rect.fromLTWH(0, 0, 300, 80), brush: PdfBrushes.red);
      final List<int> bytes = document.saveSync();
      document.dispose();
      savePdf(bytes, 'CropAdobe180.pdf');
    });
    test('Rotation Angle 270', () {
      final PdfDocument document = PdfDocument.fromBase64String(cropAdobe270);
      document.pages.add().graphics.drawRectangle(
          bounds: const Rect.fromLTWH(0, 0, 300, 80), brush: PdfBrushes.red);
      final List<int> bytes = document.saveSync();
      document.dispose();
      savePdf(bytes, 'CropAdobe270.pdf');
    });
  });
}
