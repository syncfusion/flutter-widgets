import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/graphics/pdf_margins.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pageSettings() {
  group('page settings', () {
    final PdfPageSettings ps = PdfPageSettings();
    ps.size = const Size(565, 780);
    test('size', () {
      expect(ps.size.width, 565);
      expect(ps.size.height, 780);
    });

    final PdfPageSettings pageSettings1 = PdfPageSettings(PdfPageSize.a4);
    pageSettings1.orientation = PdfPageOrientation.landscape;
    final PdfPageSettings pageSettings2 = PdfPageSettings();
    pageSettings2.orientation = PdfPageOrientation.landscape;
    pageSettings2.size = PdfPageSize.a5;
    test('orientation', () {
      expect(pageSettings1.orientation, PdfPageOrientation.landscape);
      expect(pageSettings1.size.width, 842);
      expect(pageSettings1.size.height, 595);
      expect(pageSettings2.orientation, PdfPageOrientation.landscape);
      expect(pageSettings2.size.width, 595);
      expect(pageSettings2.size.height, 421);
    });
    final PdfPageSettings ps1 =
        PdfPageSettings(const Size(500, 600), PdfPageOrientation.landscape);
    test('orientation', () {
      expect(ps1.orientation, PdfPageOrientation.landscape);
      expect(ps1.size.width, 600);
      expect(ps1.size.height, 500);
    });
    final PdfPageSettings r1 = PdfPageSettings(PdfPageSize.a4);
    r1.rotate = PdfPageRotateAngle.rotateAngle0;
    final PdfPageSettings r2 = PdfPageSettings(PdfPageSize.a4);
    r2.rotate = PdfPageRotateAngle.rotateAngle180;
    final PdfPageSettings r3 = PdfPageSettings(PdfPageSize.a4);
    r3.rotate = PdfPageRotateAngle.rotateAngle270;
    final PdfPageSettings r4 = PdfPageSettings(PdfPageSize.a4);
    r4.rotate = PdfPageRotateAngle.rotateAngle90;
    test('rotation', () {
      expect(r1.rotate, PdfPageRotateAngle.rotateAngle0);
      expect(r2.rotate, PdfPageRotateAngle.rotateAngle180);
      expect(r3.rotate, PdfPageRotateAngle.rotateAngle270);
      expect(r4.rotate, PdfPageRotateAngle.rotateAngle90);
    });
    final PdfPageSettings m1 = PdfPageSettings(PdfPageSize.a4);
    m1.setMargins(40);
    final PdfPageSettings m2 = PdfPageSettings(PdfPageSize.a4);
    m2.setMargins(20, 20, 30, 30);
    final PdfPageSettings m3 = PdfPageSettings(PdfPageSize.a4);
    m3.setMargins(40, 30);
    final PdfPageSettings m4 = PdfPageSettings(PdfPageSize.a4);
    m4.setMargins(40, null, 30);
    final PdfPageSettings m5 = PdfPageSettings(PdfPageSize.a4);
    m5.setMargins(40, null, 30, 10);
    final PdfPageSettings m6 = PdfPageSettings(PdfPageSize.a4);
    m6.setMargins(40, 20, null, 10);
    test('set margins', () {
      expect(m1.margins.left, 40);
      expect(m1.margins.top, 40);
      expect(m1.margins.right, 40);
      expect(m1.margins.bottom, 40);

      expect(m2.margins.left, 20);
      expect(m2.margins.top, 20);
      expect(m2.margins.right, 30);
      expect(m2.margins.bottom, 30);

      expect(m3.margins.left, 40);
      expect(m3.margins.top, 30);
      expect(m3.margins.right, 40);
      expect(m3.margins.bottom, 30);

      expect(m4.margins.left, 40);
      expect(m4.margins.top, 40);
      expect(m4.margins.right, 40);
      expect(m4.margins.bottom, 40);

      expect(m5.margins.left, 40);
      expect(m5.margins.top, 10);
      expect(m5.margins.right, 40);
      expect(m5.margins.bottom, 10);

      expect(m6.margins.left, 40);
      expect(m6.margins.top, 20);
      expect(m6.margins.right, 40);
      expect(m6.margins.bottom, 20);
    });
  });

  group('page size', () {
    final PdfPageSettings a0 = PdfPageSettings(PdfPageSize.a0);
    final PdfPageSettings a1 = PdfPageSettings(PdfPageSize.a1);
    final PdfPageSettings a10 = PdfPageSettings(PdfPageSize.a10);
    final PdfPageSettings a2 = PdfPageSettings(PdfPageSize.a2);
    final PdfPageSettings a3 = PdfPageSettings(PdfPageSize.a3);
    final PdfPageSettings a4 = PdfPageSettings(PdfPageSize.a4);
    final PdfPageSettings a5 = PdfPageSettings(PdfPageSize.a5);
    final PdfPageSettings a6 = PdfPageSettings(PdfPageSize.a6);
    final PdfPageSettings a7 = PdfPageSettings(PdfPageSize.a7);
    final PdfPageSettings a8 = PdfPageSettings(PdfPageSize.a8);
    final PdfPageSettings a9 = PdfPageSettings(PdfPageSize.a9);
    final PdfPageSettings halfLetter = PdfPageSettings(PdfPageSize.halfLetter);
    final PdfPageSettings archA = PdfPageSettings(PdfPageSize.archA);
    final PdfPageSettings archB = PdfPageSettings(PdfPageSize.archB);
    final PdfPageSettings archC = PdfPageSettings(PdfPageSize.archC);
    final PdfPageSettings archD = PdfPageSettings(PdfPageSize.archD);
    final PdfPageSettings archE = PdfPageSettings(PdfPageSize.archE);
    final PdfPageSettings b0 = PdfPageSettings(PdfPageSize.b0);
    final PdfPageSettings b1 = PdfPageSettings(PdfPageSize.b1);
    final PdfPageSettings b2 = PdfPageSettings(PdfPageSize.b2);
    final PdfPageSettings b3 = PdfPageSettings(PdfPageSize.b3);
    final PdfPageSettings b4 = PdfPageSettings(PdfPageSize.b4);
    final PdfPageSettings b5 = PdfPageSettings(PdfPageSize.b5);
    final PdfPageSettings flsa = PdfPageSettings(PdfPageSize.flsa);
    final PdfPageSettings ledger = PdfPageSettings(PdfPageSize.ledger);
    final PdfPageSettings legal = PdfPageSettings(PdfPageSize.legal);
    final PdfPageSettings letter = PdfPageSettings(PdfPageSize.letter);
    final PdfPageSettings letter11x17 =
        PdfPageSettings(PdfPageSize.letter11x17);
    final PdfPageSettings note = PdfPageSettings(PdfPageSize.note);

    a3.orientation = PdfPageOrientation.landscape;

    test('constants', () {
      expect(a0.width, 2380);
      expect(a0.height, 3368);
      expect(a1.width, 1684);
      expect(a1.height, 2380);
      expect(a2.width, 1190);
      expect(a2.height, 1684);
      expect(a3.width, 1190);
      expect(a3.height, 842);
      expect(a4.width, 595);
      expect(a4.height, 842);
      expect(a5.width, 421);
      expect(a5.height, 595);
      expect(a6.width, 297);
      expect(a6.height, 421);
      expect(a7.width, 210);
      expect(a7.height, 297);
      expect(a8.width, 148);
      expect(a8.height, 210);
      expect(a9.width, 105);
      expect(a9.height, 148);
      expect(a10.width, 74);
      expect(a10.height, 105);
      expect(b0.width, 2836);
      expect(b0.height, 4008);
      expect(b1.width, 2004);
      expect(b1.height, 2836);
      expect(b2.width, 1418);
      expect(b2.height, 2004);
      expect(b3.width, 1002);
      expect(b3.height, 1418);
      expect(b4.width, 709);
      expect(b4.height, 1002);
      expect(b5.width, 501);
      expect(b5.height, 709);
      expect(archA.width, 648);
      expect(archA.height, 864);
      expect(archB.width, 864);
      expect(archB.height, 1296);
      expect(archC.width, 1296);
      expect(archC.height, 1728);
      expect(archD.width, 1728);
      expect(archD.height, 2592);
      expect(archE.width, 2592);
      expect(archE.height, 3456);
      expect(flsa.width, 612);
      expect(flsa.height, 936);
      expect(halfLetter.width, 396);
      expect(halfLetter.height, 612);
      expect(letter11x17.width, 792);
      expect(letter11x17.height, 1224);
      expect(letter.width, 612);
      expect(letter.height, 792);
      expect(ledger.width, 1224);
      expect(ledger.height, 792);
      expect(note.width, 540);
      expect(note.height, 720);
      expect(legal.width, 612);
      expect(legal.height, 1008);
    });
  });
  group('margins', () {
    final PdfPageSettings ps = PdfPageSettings(PdfPageSize.a4);
    ps.margins = PdfMargins();

    test('all', () {
      expect(ps.margins.left, 0);
      expect(ps.margins.right, 0);
      expect(ps.margins.top, 0);
      expect(ps.margins.bottom, 0);
    });

    final PdfPageSettings ps1 = PdfPageSettings();
    ps1.setMargins(10);

    test('set margin', () {
      expect(ps1.margins.left, 10);
      expect(ps1.margins.right, 10);
      expect(ps1.margins.top, 10);
      expect(ps1.margins.bottom, 10);
    });
  });
  group('margins', () {
    final PdfMargins margin = PdfMargins();
    margin.left = 10;
    margin.right = 20;
    margin.top = 40;
    margin.bottom = 30;

    test('left, right, top, bottom', () {
      expect(margin.left, 10);
      expect(margin.right, 20);
      expect(margin.top, 40);
      expect(margin.bottom, 30);
    });
    final PdfMargins margin1 = PdfMargins();
    margin1.all = 40;

    test('all', () {
      expect(margin1.left, 40);
      expect(margin1.right, 40);
      expect(margin1.top, 40);
      expect(margin1.bottom, 40);
    });
  });
  group('margins internal functions', () {
    final PdfMargins margin = PdfMargins();
    PdfMarginsHelper.getHelper(margin).setMargins(20.05);
    final PdfMargins margin1 = PdfMargins();
    PdfMarginsHelper.getHelper(margin1).setMarginsAll(10.05, 20.4, 10.00, 5.0);
    final PdfMargins margin2 = PdfMargins();
    PdfMarginsHelper.getHelper(margin2).setMarginsLT(20, 30);

    test('setMargins', () {
      expect(margin.left, 20.05);
      expect(margin.right, 20.05);
      expect(margin.top, 20.05);
      expect(margin.bottom, 20.05);
    });
    test('setMarginsAll', () {
      expect(margin1.left, 10.05);
      expect(margin1.top, 20.4);
      expect(margin1.right, 10.00);
      expect(margin1.bottom, 5.0);
    });
    test('setMarginsLT', () {
      expect(margin2.left, 20);
      expect(margin2.top, 30);
      expect(margin2.right, 20);
      expect(margin2.bottom, 30);
    });
  });
  group('Behavior testing', () {
    test('test 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0, 0, 0, 0);
      page.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      final PdfPage page2 = document.pages.add();
      page2.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      expect(document.sections!.count, 2);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.size = const Size(515, 762);
      page.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      final PdfPage page2 = document.pages.add();
      page2.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      expect(document.sections!.count, 2);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_2.pdf');
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.orientation = PdfPageOrientation.landscape;
      page.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      final PdfPage page2 = document.pages.add();
      page2.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      expect(document.sections!.count, 2);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_3.pdf');
      document.dispose();
    });
    test('test 4', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      page.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      final PdfPage page2 = document.pages.add();
      page2.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      expect(document.sections!.count, 1);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_4.pdf');
      document.dispose();
    });
    test('test 5', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section = document.sections!.add();
      final PdfPage page = section.pages.add();
      page.graphics.drawRectangle(
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          pen: PdfPens.red);
      final PdfSection section2 = document.sections!.add();
      section2.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      final PdfPage page2 = section2.pages.add();
      final Size clientSize = page2.getClientSize();
      page2.graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, clientSize.width, clientSize.height),
          pen: PdfPens.red);
      expect(document.sections!.count, 2);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_5.pdf');
      document.dispose();
    });
    test('test 6', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section = document.sections!.add();
      final PdfPage page = section.pages.add();
      page.graphics.drawRectangle(
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          pen: PdfPens.red);
      section.pageSettings.orientation = PdfPageOrientation.landscape;
      section.pageSettings.size = const Size(515, 762);
      section.pageSettings.setMargins(0);
      section.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      final PdfPage page2 = section.pages.add();
      final Size clientSize = page2.getClientSize();
      page2.graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, clientSize.width, clientSize.height),
          pen: PdfPens.red);
      final PdfSection section2 = document.sections!.add();
      section2.pageSettings.orientation = PdfPageOrientation.landscape;
      section2.pageSettings.size = const Size(515, 762);
      section2.pageSettings.setMargins(0);
      section2.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      final PdfPage page3 = section2.pages.add();
      page3.graphics.drawRectangle(
          bounds: Rect.fromLTWH(
              0, 0, page3.getClientSize().width, page3.getClientSize().height),
          pen: PdfPens.red);
      final PdfPage page4 = section2.pages.add();
      final Size clientSize2 = page4.getClientSize();
      page4.graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, clientSize2.width, clientSize2.height),
          pen: PdfPens.red);
      expect(document.sections!.count, 2);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_6.pdf');
      document.dispose();
    });
    test('test 7', () {
      final PdfDocument document = PdfDocument();
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      document.pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      document.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      expect(document.sections!.count, 1);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_7.pdf');
      document.dispose();
    });
    test('test 8', () {
      final PdfDocument document = PdfDocument();
      document.sections!.add().pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      document.sections!.add().pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      document.sections!.add().pages.add().graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      document.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      expect(document.sections!.count, 3);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_8.pdf');
      document.dispose();
    });
    test('test 9', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      page.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      document.pageSettings.setMargins(0);
      final PdfPage page2 = document.pages.add();
      page2.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      document.pageSettings.setMargins(40);
      final PdfPage page3 = document.pages.add();
      page3.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      document.pageSettings.setMargins(100);
      final PdfPage page4 = document.pages.add();
      page4.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      expect(document.sections!.count, 4);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_9.pdf');
      document.dispose();
    });
    test('test 10', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.orientation = PdfPageOrientation.landscape;
      page.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      final PdfPage page2 = document.pages.add();
      document.pageSettings.setMargins(0);
      page2.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      final PdfPage page3 = document.pages.add();
      document.pageSettings.size = const Size(515, 762);
      page3.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      final PdfPage page4 = document.pages.add();
      page4.graphics.drawString(
          'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
          brush: PdfBrushes.darkBlue);
      expect(document.sections!.count, 4);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_10.pdf');
      document.dispose();
    });
    test('test 11', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section = document.sections!.add();
      final PdfPage page = section.pages.add();
      page.graphics.drawRectangle(
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          pen: PdfPens.red);
      section.pageSettings.orientation = PdfPageOrientation.landscape;
      section.pageSettings.size = const Size(515, 762);
      section.pageSettings.setMargins(0);
      section.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      final PdfPage page2 = section.pages.add();
      final Size clientSize = page2.getClientSize();
      page2.graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, clientSize.width, clientSize.height),
          pen: PdfPens.red);
      final PdfSection section2 = document.sections!.add();
      section2.pageSettings.orientation = PdfPageOrientation.landscape;
      section2.pageSettings.size = const Size(515, 762);
      section2.pageSettings.margins.top = 0;
      section2.pageSettings.margins.left = 0;
      section2.pageSettings.margins.right = 0;
      section2.pageSettings.margins.bottom = 0;
      section2.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      final PdfPage page3 = section2.pages.add();
      page3.graphics.drawRectangle(
          bounds: Rect.fromLTWH(
              0, 0, page3.getClientSize().width, page3.getClientSize().height),
          pen: PdfPens.red);
      final PdfPage page4 = section2.pages.add();
      final Size clientSize2 = page4.getClientSize();
      page4.graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, clientSize2.width, clientSize2.height),
          pen: PdfPens.red);
      expect(document.sections!.count, 2);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_11.pdf');
      document.dispose();
    });
    test('test 12', () {
      final PdfDocument document = PdfDocument();
      final PdfSection section = document.sections!.add();
      final PdfPage page = section.pages.add();
      page.graphics.drawRectangle(
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          pen: PdfPens.red);
      section.pageSettings =
          PdfPageSettings(const Size(515, 762), PdfPageOrientation.landscape)
            ..margins.all = 0
            ..rotate = PdfPageRotateAngle.rotateAngle90;
      final PdfPage page2 = section.pages.add();
      final Size clientSize = page2.getClientSize();
      page2.graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, clientSize.width, clientSize.height),
          pen: PdfPens.red);
      final PdfSection section2 = document.sections!.add();
      section2.pageSettings =
          PdfPageSettings(const Size(515, 762), PdfPageOrientation.landscape)
            ..margins.all = 0
            ..rotate = PdfPageRotateAngle.rotateAngle90;
      final PdfPage page3 = section2.pages.add();
      page3.graphics.drawRectangle(
          bounds: Rect.fromLTWH(
              0, 0, page3.getClientSize().width, page3.getClientSize().height),
          pen: PdfPens.red);
      final PdfPage page4 = section2.pages.add();
      final Size clientSize2 = page4.getClientSize();
      page4.graphics.drawRectangle(
          bounds: Rect.fromLTWH(0, 0, clientSize2.width, clientSize2.height),
          pen: PdfPens.red);
      document.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
      expect(document.sections!.count, 2);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_4004_test_12.pdf');
      document.dispose();
    });
  });
}
