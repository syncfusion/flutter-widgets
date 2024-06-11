import 'dart:convert';
import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'images.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pdfImage() {
  group('Image Pagination', () {
    test('FLUT-3506-CircularImageDrawing', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(faceImagePng);
      final PdfGraphics pageGraphics = page.graphics;
      final PdfGraphicsState state = pageGraphics.save();
      final PdfPath path = PdfPath();
      path.addEllipse(const Rect.fromLTWH(150, 50, 200, 200));
      pageGraphics.setClip(path: path);
      pageGraphics.drawImage(image, const Rect.fromLTWH(150, 50, 200, 200));
      pageGraphics.restore(state);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_3506_CircularImageDrawing.pdf');
      document.dispose();
    });
    test('image - FitColumnsToPage - Zero', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitColumnsToPage);
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 0, 0),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitColumnsToPageZero.pdf');
    });
    test('image - FitPage - Zero', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitPage);
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 0, 0),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitPageZero.pdf');
    });
    test('image - FitElement - Zero', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitElement);
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 0, 0),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitElementZero.pdf');
    });
    test('image - FitColumnsToPage - Paginate', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitColumnsToPage);
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitColumnsToPagePaginate.pdf');
    });
    test('image - FitPage - Paginate', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitPage);
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitPagePaginate.pdf');
    });
    test('image - FitElement - Paginate', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitElement);
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitElementPaginate.pdf');
    });
    test('image - FitColumnsToPage - OnePage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.onePage,
          breakType: PdfLayoutBreakType.fitColumnsToPage);
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitColumnsToPageOnePage.pdf');
    });
    test('image - FitPage - OnePage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.onePage,
          breakType: PdfLayoutBreakType.fitPage);
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitPageOnePage.pdf');
    });
    test('image - FitElement - OnePage', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.onePage,
          breakType: PdfLayoutBreakType.fitElement);
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitElementOnePage.pdf');
    });
    test('image - FitColumnsToPage - PaginateBounds', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitColumnsToPage,
          paginateBounds: const Rect.fromLTWH(20, 400, 350, 500));
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitColumnsToPagePaginateBounds.pdf');
    });
    test('image - FitPage - PaginateBounds', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitPage,
          paginateBounds: const Rect.fromLTWH(20, 400, 350, 500));
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitPagePaginateBounds.pdf');
    });
    test('image - FitElement - PaginateBounds', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitElement,
          paginateBounds: const Rect.fromLTWH(20, 400, 350, 500));
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result != null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitElementPaginateBounds.pdf');
    });
    test('image - FitColumnsToPage - result', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitColumnsToPage,
          paginateBounds: const Rect.fromLTWH(20, 400, 350, 500));
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      result!.page.graphics.drawString(
          'FitColumnsToPage - Pagination result check',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 10, 400, 50));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitColumnsToPageResult.pdf');
    });
    test('image - FitPage - result', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitPage,
          paginateBounds: const Rect.fromLTWH(20, 400, 350, 500));
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      result!.page.graphics.drawString('FitPage - Pagination result check',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 10, 400, 50));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitPageResult.pdf');
    });
    test('image - FitElement - result', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat(
          layoutType: PdfLayoutType.paginate,
          breakType: PdfLayoutBreakType.fitElement,
          paginateBounds: const Rect.fromLTWH(20, 400, 350, 500));
      final PdfLayoutResult? result = image.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      result!.page.graphics.drawString('FitElement - Pagination result check',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(0, result.bounds.bottom + 10, 400, 50));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitElementResult.pdf');
    });
    test('image - FitColumnsToPage - Graphics', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat =
          PdfLayoutFormat(breakType: PdfLayoutBreakType.fitColumnsToPage);
      final PdfLayoutResult? result = image.draw(
          graphics: page.graphics,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result == null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitColumnsToPageGraphics.pdf');
    });
    test('image - FitPage - Graphics', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat =
          PdfLayoutFormat(breakType: PdfLayoutBreakType.fitPage);
      final PdfLayoutResult? result = image.draw(
          graphics: page.graphics,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result == null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitPageGraphics.pdf');
    });
    test('image - FitElement - Graphics', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      final PdfLayoutFormat layoutFormat =
          PdfLayoutFormat(breakType: PdfLayoutBreakType.fitElement);
      final PdfLayoutResult? result = image.draw(
          graphics: page.graphics,
          bounds: const Rect.fromLTWH(20, 400, 350, 500),
          format: layoutFormat);
      final List<int> bytes = document.saveSync();
      expect(result == null, true);
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1826_FitElementGraphics.pdf');
    });
  });
  group('PDF image - PNG', () {
    test('chartPng', () {
      final PdfDocument document = PdfDocument();
      document.pages.add().graphics.drawImage(
          PdfBitmap(base64.decode(chartPng)),
          const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Chart_PNG.pdf');
    });
    test('alphaPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(alphaPng);
      expect(image.width, 1296, reason: 'Failed to get width of an image');
      expect(image.height, 972, reason: 'Failed to get height of an image');
      expect(image.horizontalResolution, 0,
          reason: 'Failed to get horizontal resolution of an image');
      expect(image.verticalResolution, 0,
          reason: 'Failed to get vertical resolution of an image');
      expect(
          image.physicalDimension.width == 1296 &&
              image.physicalDimension.height == 972,
          true,
          reason: 'Failed to get size of an image');
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_alpha_PNG.pdf');
    });
    test('pdfImagePng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(pdfImagePng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_PDFImage_PNG.pdf');
    });
    test('twoPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(twoPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_2_PNG.pdf');
    });
    test('careersPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(careersPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Careers_PNG.pdf');
    });
    test('defectIDSD12778Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD12778Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD12778_PNG.pdf');
    });
    test('defectIDSD14507Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD14507Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD14507_PNG.pdf');
    });
    test('defectIDSD2422Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD2422Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD2422_PNG.pdf');
    });
    test('defectIDSD8724_1Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD8724_1Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD8724_1_PNG.pdf');
    });
    test('defectIDSD8724_2Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD8724_2Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD8724_2_PNG.pdf');
    });
    test('defectIDSD8724_3Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD8724_3Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD8724_3_PNG.pdf');
    });
    test('defectIDWF21245Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF21245Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF21245_PNG.pdf');
    });
    test('defectIDWF21326Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF21326Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF21326_PNG.pdf');
    });
    test('defectIDWF21383Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF21383Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF21383_PNG.pdf');
    });
    test('defectIDWF21524Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF21524Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF21524_PNG.pdf');
    });
    test('defectIDWF7500_1Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF7500_1Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF7500_1_PNG.pdf');
    });
    test('defect4472Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defect4472Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Defect_4472_PNG.pdf');
    });
    test('defect4835Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defect4835Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Defect_4835_PNG.pdf');
    });
    test('defect5482Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defect5482Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Defect_5482_PNG.pdf');
    });
    test('defect5483Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defect5483Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Defect_5483_PNG.pdf');
    });
    test('designPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(designPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_design_PNG.pdf');
    });
    test('ejdotnetcore1791Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(ejdotnetcore1791Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_EJDOTNETCORE_1791_PNG.pdf');
    });
    test('invalidPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(invalidPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Invalid_PNG.pdf');
    });
    test('linePng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(linePng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_line_PNG.pdf');
    });
    test('logoPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(logoPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_logo_PNG.pdf');
    });
    test('pdfheaderPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(pdfheaderPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_pdf_header_PNG.pdf');
    });
    test('wf24126Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf24126Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF24126_PNG.pdf');
    });
    test('wf25185Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf25185Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF25185_PNG.pdf');
    });
    test('wf36671Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf36671Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF36671_PNG.pdf');
    });
    test('wf36671logoPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf36671logoPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF36671_logo_PNG.pdf');
    });
    test('wf52351Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf52351Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF52351_PNG.pdf');
    });
    test('wf19973Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf19973Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_19973_PNG.pdf');
    });
    test('wf24914Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf24914Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_24914_PNG.pdf');
    });
    test('wf28482Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf28482Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_28482_PNG.pdf');
    });
    test('wf33271imgPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf33271imgPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_33271_img_PNG.pdf');
    });
    test('wf35623inputPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf35623inputPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_35623_input_PNG.pdf');
    });
    test('wf35735Png', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf35735Png);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_35735_PNG.pdf');
    });
    test('wf39786HorizontalStretchPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image =
          PdfBitmap.fromBase64String(wf39786HorizontalStretchPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_39786_HorizontalStretch_PNG.pdf');
    });
    test('wf39786VerticalStretchPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image =
          PdfBitmap.fromBase64String(wf39786VerticalStretchPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_39786_VerticalStretch_PNG.pdf');
    });
    test('wf40976SyncPng', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf40976SyncPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_40976_Sync_PNG.pdf');
    });
  });
  group('PDF image - JPEG', () {
    test('sample1Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(sample1Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_sample1_JPEG.pdf');
    });
    test('cmykJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(cmykJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_CMYK_JPEG.pdf');
    });
    test('wf43381Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf43381Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF43381_JPEG.pdf');
    });
    test('animalsJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(animalsJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_animals_JPEG.pdf');
    });
    test('autumnLeavesJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(autumnLeavesJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Autumn Leaves_JPEG.pdf');
    });
    test('bussinessJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(bussinessJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_bussiness_JPEG.pdf');
    });
    test('defectIDSD12899Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD12899Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD12899_JPEG.pdf');
    });
    test('defectIDSD13662Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD13662Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD13662_JPEG.pdf');
    });
    test('defectIDSD13662_2Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD13662_2Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD13662_2_JPEG.pdf');
    });
    test('defectIDSD13726Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD13726Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD13726_JPEG.pdf');
    });
    test('defectIDSD3209Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD3209Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD3209_JPEG.pdf');
    });
    test('defectIDSD6175_3Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD6175_3Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD6175_3_JPEG.pdf');
    });
    test('defectIDSD8412_1Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD8412_1Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD8412_1_JPEG.pdf');
    });
    test('defectIDSD8574Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD8574Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD8574_JPEG.pdf');
    });
    test('defectIDSD8574_1Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD8574_1Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD8574_1_JPEG.pdf');
    });
    test('defectIDSD8648Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD8648Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD8648_JPEG.pdf');
    });
    test('defectIDSD877Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD877Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD877_JPEG.pdf');
    });
    test('defectIDSD9066Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD9066Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD9066_JPEG.pdf');
    });
    test('defectIDSD9185Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDSD9185Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_SD9185_JPEG.pdf');
    });
    test('defectIDWF12618Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF12618Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF12618_JPEG.pdf');
    });
    test('defectIDWF132451Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF132451Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF13245_1_JPEG.pdf');
    });
    test('defectIDWF132452Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF132452Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF13245_2_JPEG.pdf');
    });
    test('defectIDWF13455Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF13455Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF13455_JPEG.pdf');
    });
    test('defectIDWF172391Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF172391Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF17239_1_JPEG.pdf');
    });
    test('defectIDWF37266Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defectIDWF37266Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_DefectID_WF37266_JPEG.pdf');
    });
    test('defect4639Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defect4639Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Defect_4639_JPEG.pdf');
    });
    test('defect4948Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defect4948Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Defect_4948_JPEG.pdf');
    });
    test('defect4961Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defect4961Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Defect_4961_JPEG.pdf');
    });
    test('defect6693Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(defect6693Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Defect_6693_JPEG.pdf');
    });
    test('ejdotnetcore1791Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(ejdotnetcore1791Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_EJDOTNETCORE_1791_JPEG.pdf');
    });
    test('galacticJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(galacticJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_galactic_JPEG.pdf');
    });
    test('grayScaleImageJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(grayScaleImageJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_grayScaleImage_JPEG.pdf');
    });
    test('grayScaleImage2Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(grayScaleImage2Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_grayScaleImage2_JPEG.pdf');
    });
    test('greyJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(greyJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Grey_JPEG.pdf');
    });
    test('highImageJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(highImageJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_highImage_JPEG.pdf');
    });
    test('imageJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(imageJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_Image_JPEG.pdf');
    });
    test('inputJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(inputJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_input_JPEG.pdf');
    });
    test('logoJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(logoJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_logo_JPEG.pdf');
    });
    test('logo12Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(logo12Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_logo12_JPEG.pdf');
    });
    test('maskJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(maskJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_mask_JPEG.pdf');
    });
    test('mask2Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(mask2Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_mask2_JPEG.pdf');
    });
    test('mask3Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(mask3Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_mask3_JPEG.pdf');
    });
    test('mask4Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(mask4Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_mask4_JPEG.pdf');
    });
    test('mouseJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(mouseJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_mouse_JPEG.pdf');
    });
    test('pdfDemoJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(pdfDemoJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_PDFDemo_JPEG.pdf');
    });
    test('replaceImageJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(replaceImageJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_ReplaceImage_JPEG.pdf');
    });
    test('signatureJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(signatureJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_signature_JPEG.pdf');
    });
    test('simpleJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(simpleJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_simple_JPEG.pdf');
    });
    test('spaceJpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(spaceJpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_space_JPEG.pdf');
    });
    test('wf37696Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf37696Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF37696_JPEG.pdf');
    });
    test('wf51478Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf51478Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF51478_JPEG.pdf');
    });
    test('wf8518Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf8518Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF8518_JPEG.pdf');
    });
    test('wf19865Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf19865Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_19865_JPEG.pdf');
    });
    test('wf28569Jpeg', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(wf28569Jpeg);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 400, 250));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_556_WF_28569_JPEG.pdf');
    });
    test('FLUT_1296_PNG image Dispose issue', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfImage image = PdfBitmap.fromBase64String(screenShotPng);
      page.graphics.drawImage(image, const Rect.fromLTWH(10, 10, 100, 300));
      final List<int> bytes = document.saveSync();
      document.dispose();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to draw image in PDF document');
      savePdf(bytes, 'FLUT_1296_ScreenShotPNG.pdf');
    });
    test('FLUT-850491 Incorrect image dimensions recorded by PdfBitmap', () {
      final PdfImage image = PdfBitmap.fromBase64String(cbimagePng);
      expect(image.width, 480);
      expect(image.height, 640);
      final PdfDocument pdf = PdfDocument();
      pdf.pageSettings.size =
          Size(image.width.toDouble(), image.height.toDouble());
      pdf.pageSettings.margins.all = 0;
      pdf.pages.add().graphics.drawImage(
            image,
            Rect.fromLTWH(
                0, 0, image.width.toDouble(), image.height.toDouble()),
          );
      savePdf(pdf.saveSync(), 'FLUT-850491-test.pdf');
      pdf.dispose();
    });
  });
}
