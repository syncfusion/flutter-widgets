import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import '../../pdf.dart';
import '../pdf/implementation/io/pdf_constants.dart';
import '../pdf/implementation/io/pdf_cross_table.dart';
import '../pdf/implementation/pages/pdf_page.dart';
import '../pdf/implementation/primitives/pdf_dictionary.dart';
import 'import_export_docs.dart';
import 'pdf_docs.dart';
import 'pdf_document.dart';

// ignore: public_member_api_docs
void annotationImportExport() {
  final List<String> fdfList = <String>[
    exportFdf0,
    exportFdf1,
    exportFdf2,
    exportFdf3,
    exportFdf5,
    exportFdf6,
    exportFdf8,
    exportFdf13,
    exportFdf14,
    exportFdf15,
    exportFdf16,
    exportFdf17,
    exportFdf18
  ];
  group('Annotation import FDF format', () {
    test('test 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportFdf4), PdfAnnotationDataFormat.fdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfEllipseAnnotation) {
        final PdfEllipseAnnotation annotation =
            annots[0] as PdfEllipseAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(240.0, 40.0, 440.0, 140.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '255, 0, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 0, 255');
        expect(annotation.text, 'rectangle');
        expect(annotation.border.width, 1);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_fdf_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportFdf7), PdfAnnotationDataFormat.fdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfLineAnnotation) {
        final PdfLineAnnotation annotation = annots[0] as PdfLineAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(69.0, 411.0, 261.0, 433.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '0, 128, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 128, 0');
        expect(annotation.text, 'Line Annotation');
        expect(annotation.border.width, 1);
        expect(
            annotation.border.borderStyle.toString(), 'PdfBorderStyle.solid');
        expect(annotation.linePoints.toString(), '[80, 420, 250, 420]');
        expect(annotation.leaderLineExt, 0);
        expect(annotation.captionType.toString(), 'PdfLineCaptionType.inline');
        expect(annotation.leaderLine, 0);
        expect(annotation.lineCaption, true);
        expect(annotation.lineIntent, PdfLineIntent.lineDimension);
        expect(annotation.beginLineStyle, PdfLineEndingStyle.butt);
        expect(annotation.endLineStyle, PdfLineEndingStyle.diamond);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_fdf_2.pdf');
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportFdf9), PdfAnnotationDataFormat.fdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfTextMarkupAnnotation) {
        final PdfTextMarkupAnnotation annotation =
            annots[0] as PdfTextMarkupAnnotation;
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '138, 43, 226');
        expect(annotation.text, 'Markup annotation with highlight style');
        expect(annotation.textMarkupAnnotationType,
            PdfTextMarkupAnnotationType.highlight);
        expect(annotation.boundsCollection.toString(),
            '[Rect.fromLTRB(240.0, 340.0, 340.0, 360.0), Rect.fromLTRB(240.0, 360.0, 390.0, 380.0)]');
        expect(annotation.author, 'Markup annotation');
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_fdf_3.pdf');
      document.dispose();
    });
    test('test 4', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportFdf10), PdfAnnotationDataFormat.fdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfPolygonAnnotation) {
        final PdfPolygonAnnotation annotation =
            annots[0] as PdfPolygonAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(99.0, 441.0, 351.0, 643.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '255, 0, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 0, 255');
        expect(annotation.text, 'polygon');
        expect(annotation.border.width, 1);
        expect(annotation.border.borderStyle, PdfBorderStyle.solid);
        expect(annotation.polygonPoints.toString(),
            '[100, 300, 150, 200, 300, 200, 350, 300, 300, 400, 150, 400, 100, 300]');
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_fdf_4.pdf');
      document.dispose();
    });
    test('test 5', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportFdf11), PdfAnnotationDataFormat.fdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfPopupAnnotation) {
        final PdfPopupAnnotation annotation = annots[0] as PdfPopupAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(40.0, 190.0, 70.0, 220.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '0, 0, 0');
        expect(annotation.text, 'Test popup annotation');
        expect(annotation.icon, PdfPopupIcon.comment);
        expect(annotation.open, false);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_fdf_5.pdf');
      document.dispose();
    });
    test('test 6', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportFdf12), PdfAnnotationDataFormat.fdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfRectangleAnnotation) {
        final PdfRectangleAnnotation annotation =
            annots[0] as PdfRectangleAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(240.0, 40.0, 440.0, 140.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '255, 0, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 0, 255');
        expect(annotation.text, 'rectangle');
        expect(annotation.border.width, 1);
        expect(annotation.border.borderStyle, PdfBorderStyle.solid);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_fdf_6.pdf');
      document.dispose();
    });
    test('test 7', () {
      for (int i = 0; i < fdfList.length; i++) {
        final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
        document.importAnnotation(
            base64.decode(fdfList[i]), PdfAnnotationDataFormat.fdf);
        final List<int> bytes = document.saveSync();
        savePdf(bytes, 'FLUT-854551-annotation_import_fdf_${i + 7}.pdf');
        document.dispose();
      }
    });
    test('test 8', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportFdf4), PdfAnnotationDataFormat.fdf);
      document.importAnnotation(
          base64.decode(exportFdf7), PdfAnnotationDataFormat.fdf);
      document.importAnnotation(
          base64.decode(exportFdf9), PdfAnnotationDataFormat.fdf);
      document.importAnnotation(
          base64.decode(exportFdf10), PdfAnnotationDataFormat.fdf);
      document.importAnnotation(
          base64.decode(exportFdf11), PdfAnnotationDataFormat.fdf);
      document.importAnnotation(
          base64.decode(exportFdf12), PdfAnnotationDataFormat.fdf);
      document.pages[0].annotations.flattenAllAnnotations();
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_fdf_20.pdf');
      document.dispose();
    });
  });
  group('Annotation import XFDF format', () {
    final List<String> xfdfList = <String>[
      exportXfdf0,
      exportXfdf1,
      exportXfdf2,
      exportXfdf3,
      exportXfdf5,
      exportXfdf6,
      exportXfdf8,
      exportXfdf13,
      exportXfdf14,
      exportXfdf15,
      exportXfdf16,
      exportXfdf17,
      exportXfdf18
    ];
    test('test 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportXfdf4), PdfAnnotationDataFormat.xfdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfEllipseAnnotation) {
        final PdfEllipseAnnotation annotation =
            annots[0] as PdfEllipseAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(240.0, 40.0, 440.0, 140.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '255, 0, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 0, 255');
        expect(annotation.text, 'rectangle');
        expect(annotation.border.width, 1);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_xfdf_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportXfdf7), PdfAnnotationDataFormat.xfdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfLineAnnotation) {
        final PdfLineAnnotation annotation = annots[0] as PdfLineAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(69.0, 411.0, 261.0, 433.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '0, 128, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 128, 0');
        expect(annotation.text, 'Line Annotation');
        expect(annotation.border.width, 1);
        expect(
            annotation.border.borderStyle.toString(), 'PdfBorderStyle.solid');
        expect(annotation.linePoints.toString(), '[80, 420, 250, 420]');
        expect(annotation.leaderLineExt, 0);
        expect(annotation.captionType.toString(), 'PdfLineCaptionType.inline');
        expect(annotation.leaderLine, 0);
        expect(annotation.lineCaption, true);
        expect(annotation.lineIntent, PdfLineIntent.lineDimension);
        expect(annotation.beginLineStyle, PdfLineEndingStyle.butt);
        expect(annotation.endLineStyle, PdfLineEndingStyle.diamond);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_xfdf_2.pdf');
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportXfdf9), PdfAnnotationDataFormat.xfdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfTextMarkupAnnotation) {
        final PdfTextMarkupAnnotation annotation =
            annots[0] as PdfTextMarkupAnnotation;
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '138, 43, 226');
        expect(annotation.text, 'Markup annotation with highlight style');
        expect(annotation.textMarkupAnnotationType,
            PdfTextMarkupAnnotationType.highlight);
        expect(annotation.boundsCollection.toString(),
            '[Rect.fromLTRB(240.0, 340.0, 340.0, 360.0), Rect.fromLTRB(240.0, 360.0, 390.0, 380.0)]');
        expect(annotation.author, 'Markup annotation');
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_xfdf_3.pdf');
      document.dispose();
    });
    test('test 4', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportXfdf10), PdfAnnotationDataFormat.xfdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfPolygonAnnotation) {
        final PdfPolygonAnnotation annotation =
            annots[0] as PdfPolygonAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(99.0, 441.0, 351.0, 643.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '255, 0, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 0, 255');
        expect(annotation.text, 'polygon');
        expect(annotation.border.width, 1);
        expect(annotation.border.borderStyle, PdfBorderStyle.solid);
        expect(annotation.polygonPoints.toString(),
            '[100, 300, 150, 200, 300, 200, 350, 300, 300, 400, 150, 400, 100, 300]');
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_xfdf_4.pdf');
      document.dispose();
    });
    test('test 5', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportXfdf11), PdfAnnotationDataFormat.xfdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfPopupAnnotation) {
        final PdfPopupAnnotation annotation = annots[0] as PdfPopupAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(40.0, 190.0, 70.0, 220.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '0, 0, 0');
        expect(annotation.text, 'Test popup annotation');
        expect(annotation.icon, PdfPopupIcon.comment);
        expect(annotation.open, false);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_xfdf_5.pdf');
      document.dispose();
    });
    test('test 6', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportXfdf12), PdfAnnotationDataFormat.xfdf);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfRectangleAnnotation) {
        final PdfRectangleAnnotation annotation =
            annots[0] as PdfRectangleAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(240.0, 40.0, 440.0, 140.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '255, 0, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 0, 255');
        expect(annotation.text, 'rectangle');
        expect(annotation.border.width, 1);
        expect(annotation.border.borderStyle, PdfBorderStyle.solid);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_xfdf_6.pdf');
      document.dispose();
    });
    test('test 7', () {
      for (int i = 0; i < xfdfList.length; i++) {
        final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
        document.importAnnotation(
            base64.decode(xfdfList[i]), PdfAnnotationDataFormat.xfdf);
        final List<int> bytes = document.saveSync();
        savePdf(bytes, 'FLUT-854551-annotation_import_xfdf_${i + 7}.pdf');
        document.dispose();
      }
    });
    test('test 8', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportXfdf4), PdfAnnotationDataFormat.xfdf);
      document.importAnnotation(
          base64.decode(exportXfdf7), PdfAnnotationDataFormat.xfdf);
      document.importAnnotation(
          base64.decode(exportXfdf9), PdfAnnotationDataFormat.xfdf);
      document.importAnnotation(
          base64.decode(exportXfdf10), PdfAnnotationDataFormat.xfdf);
      document.importAnnotation(
          base64.decode(exportXfdf11), PdfAnnotationDataFormat.xfdf);
      document.importAnnotation(
          base64.decode(exportXfdf12), PdfAnnotationDataFormat.xfdf);
      document.pages[0].annotations.flattenAllAnnotations();
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_xfdf_20.pdf');
      document.dispose();
    });
  });
  group('Annotation import JSON format', () {
    final List<String> jsonList = <String>[
      exportJson0,
      exportJson1,
      exportJson2,
      exportJson3,
      exportJson5,
      exportJson6,
      exportJson8,
      exportJson13,
      exportJson14,
      exportJson15,
      exportJson16,
      exportJson17,
      exportJson18
    ];
    test('test 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportJson4), PdfAnnotationDataFormat.json);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfEllipseAnnotation) {
        final PdfEllipseAnnotation annotation =
            annots[0] as PdfEllipseAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(240.0, 40.0, 440.0, 140.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '255, 0, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 0, 255');
        expect(annotation.text, 'rectangle');
        expect(annotation.border.width, 1);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_json_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportJson7), PdfAnnotationDataFormat.json);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfLineAnnotation) {
        final PdfLineAnnotation annotation = annots[0] as PdfLineAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(69.0, 411.0, 261.0, 433.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '0, 128, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 128, 0');
        expect(annotation.text, 'Line Annotation');
        expect(annotation.border.width, 1);
        expect(
            annotation.border.borderStyle.toString(), 'PdfBorderStyle.solid');
        expect(annotation.linePoints.toString(), '[80, 420, 250, 420]');
        expect(annotation.leaderLineExt, 0);
        expect(annotation.captionType.toString(), 'PdfLineCaptionType.inline');
        expect(annotation.leaderLine, 0);
        expect(annotation.lineCaption, true);
        expect(annotation.lineIntent, PdfLineIntent.lineDimension);
        expect(annotation.beginLineStyle, PdfLineEndingStyle.butt);
        expect(annotation.endLineStyle, PdfLineEndingStyle.diamond);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_json_2.pdf');
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportJson9), PdfAnnotationDataFormat.json);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfTextMarkupAnnotation) {
        final PdfTextMarkupAnnotation annotation =
            annots[0] as PdfTextMarkupAnnotation;
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '138, 43, 226');
        expect(annotation.text, 'Markup annotation with highlight style');
        expect(annotation.textMarkupAnnotationType,
            PdfTextMarkupAnnotationType.highlight);
        expect(annotation.boundsCollection.toString(),
            '[Rect.fromLTRB(240.0, 340.0, 340.0, 360.0), Rect.fromLTRB(240.0, 360.0, 390.0, 380.0)]');
        expect(annotation.author, 'Markup annotation');
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_json_3.pdf');
      document.dispose();
    });
    test('test 4', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportJson10), PdfAnnotationDataFormat.json);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfPolygonAnnotation) {
        final PdfPolygonAnnotation annotation =
            annots[0] as PdfPolygonAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(99.0, 441.0, 351.0, 643.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '255, 0, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 0, 255');
        expect(annotation.text, 'polygon');
        expect(annotation.border.width, 1);
        expect(annotation.border.borderStyle, PdfBorderStyle.solid);
        expect(annotation.polygonPoints.toString(),
            '[100, 300, 150, 200, 300, 200, 350, 300, 300, 400, 150, 400, 100, 300]');
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_json_4.pdf');
      document.dispose();
    });
    test('test 5', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportJson11), PdfAnnotationDataFormat.json);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfPopupAnnotation) {
        final PdfPopupAnnotation annotation = annots[0] as PdfPopupAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(40.0, 190.0, 70.0, 220.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '0, 0, 0');
        expect(annotation.text, 'Test popup annotation');
        expect(annotation.icon, PdfPopupIcon.comment);
        expect(annotation.open, false);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_json_5.pdf');
      document.dispose();
    });
    test('test 6', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportJson12), PdfAnnotationDataFormat.json);
      final PdfAnnotationCollection annots = document.pages[0].annotations;
      expect(annots.count, 1);
      if (annots[0] is PdfRectangleAnnotation) {
        final PdfRectangleAnnotation annotation =
            annots[0] as PdfRectangleAnnotation;
        expect(annotation.bounds.toString(),
            'Rect.fromLTRB(240.0, 40.0, 440.0, 140.0)');
        expect(
            '${annotation.color.r}, ${annotation.color.g}, ${annotation.color.b}',
            '255, 0, 0');
        expect(
            '${annotation.innerColor.r}, ${annotation.innerColor.g}, ${annotation.innerColor.b}',
            '0, 0, 255');
        expect(annotation.text, 'rectangle');
        expect(annotation.border.width, 1);
        expect(annotation.border.borderStyle, PdfBorderStyle.solid);
      }
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_json_6.pdf');
      document.dispose();
    });
    test('test 7', () {
      for (int i = 0; i < jsonList.length; i++) {
        final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
        document.importAnnotation(
            base64.decode(jsonList[i]), PdfAnnotationDataFormat.json);
        final List<int> bytes = document.saveSync();
        savePdf(bytes, 'FLUT-854551-annotation_import_json_${i + 7}.pdf');
        document.dispose();
      }
    });
    test('test 8', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportJson4), PdfAnnotationDataFormat.json);
      document.importAnnotation(
          base64.decode(exportJson7), PdfAnnotationDataFormat.json);
      document.importAnnotation(
          base64.decode(exportJson9), PdfAnnotationDataFormat.json);
      document.importAnnotation(
          base64.decode(exportJson10), PdfAnnotationDataFormat.json);
      document.importAnnotation(
          base64.decode(exportJson11), PdfAnnotationDataFormat.json);
      document.importAnnotation(
          base64.decode(exportJson12), PdfAnnotationDataFormat.json);
      document.pages[0].annotations.flattenAllAnnotations();
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT-854551-annotation_import_json_20.pdf');
      document.dispose();
    });
  });
  group('Annotation export support', () {
    const List<PdfAnnotationDataFormat> formats =
        PdfAnnotationDataFormat.values;
    test('test 1', () {
      final List<String> test1Data = <String>[
        exportValue1fdf,
        exportValue1xfdf,
        exportValue1json
      ];
      for (int i = 0; i < formats.length; i++) {
        final PdfDocument document =
            PdfDocument.fromBase64String(annotationAdobePdf);
        final List<int> bytes = document.exportAnnotation(formats[i]);
        expect(base64.encode(bytes), test1Data[i],
            reason: 'Test 1: Failed to export ${formats[i]}');
        document.dispose();
      }
    });
    test('test 2', () {
      final List<String> test2Data = <String>[
        exportValue2fdf,
        exportValue2xfdf,
        exportValue2json
      ];
      for (int i = 0; i < formats.length; i++) {
        final PdfDocument document =
            PdfDocument.fromBase64String(annotationAPPdf);
        final List<int> bytes = document.exportAnnotation(formats[i]);
        expect(base64.encode(bytes), test2Data[i],
            reason: 'Test 2: Failed to export ${formats[i]}');
        document.dispose();
      }
    });
    test('test 3', () {
      final List<String> test3Data = <String>[
        exportValue3fdf,
        exportValue3xfdf,
        exportValue3json
      ];
      for (int i = 0; i < formats.length; i++) {
        final PdfDocument document =
            PdfDocument.fromBase64String(annotationAdobePdf);
        final List<int> bytes =
            document.exportAnnotation(formats[i], exportAppearance: true);
        expect(base64.encode(bytes), test3Data[i],
            reason: 'Test 3: Failed to export ${formats[i]}');
        document.dispose();
      }
    });
    test('test 4', () {
      final List<String> test4Data = <String>[
        exportValue4fdf,
        exportValue4xfdf,
        exportValue4json
      ];
      for (int i = 0; i < formats.length; i++) {
        final PdfDocument document =
            PdfDocument.fromBase64String(annotationAPPdf);
        final List<int> bytes =
            document.exportAnnotation(formats[i], exportAppearance: true);
        expect(base64.encode(bytes), test4Data[i],
            reason: 'Test 4: Failed to export ${formats[i]}');
        document.dispose();
      }
    });
    test('test 5', () {
      final List<String> test5Data = <String>[
        exportValue5fdf,
        exportValue5xfdf,
        exportValue5json
      ];
      for (int i = 0; i < formats.length; i++) {
        final PdfDocument document =
            PdfDocument.fromBase64String(annotationAdobePdf);
        final List<int> bytes = document.exportAnnotation(formats[i],
            exportAppearance: true,
            exportTypes: <PdfAnnotationExportType>[
              PdfAnnotationExportType.rectangleAnnotation,
              PdfAnnotationExportType.highlightAnnotation
            ]);
        expect(base64.encode(bytes), test5Data[i],
            reason: 'Test 5: Failed to export ${formats[i]}');
        document.dispose();
      }
    });
    test('test 6', () {
      final List<String> test6Data = <String>[
        exportValue6fdf,
        exportValue6xfdf,
        exportValue6json
      ];
      for (int i = 0; i < formats.length; i++) {
        final PdfDocument document =
            PdfDocument.fromBase64String(annotationAPPdf);
        final List<int> bytes = document.exportAnnotation(formats[i],
            exportAppearance: true,
            exportTypes: <PdfAnnotationExportType>[
              PdfAnnotationExportType.rectangleAnnotation,
              PdfAnnotationExportType.highlightAnnotation
            ]);
        expect(base64.encode(bytes), test6Data[i],
            reason: 'Test 6: Failed to export ${formats[i]}');
        document.dispose();
      }
    });
    test('test 7', () {
      final List<String> test7Data = <String>[
        exportValue7fdf,
        exportValue7xfdf,
        exportValue7json
      ];
      for (int i = 0; i < formats.length; i++) {
        final PdfDocument document =
            PdfDocument.fromBase64String(annotationAdobePdf);
        final List<PdfAnnotation> exportAnnotations = <PdfAnnotation>[];
        final PdfAnnotationCollection collection =
            document.pages[0].annotations;
        for (int i = 0; i < collection.count; i++) {
          if (collection[i] is PdfRectangleAnnotation ||
              collection[i] is PdfLineAnnotation ||
              collection[i] is PdfTextMarkupAnnotation) {
            exportAnnotations.add(collection[i]);
          }
        }
        final List<int> bytes = document.exportAnnotation(formats[i],
            exportAppearance: true, exportList: exportAnnotations);
        expect(base64.encode(bytes), test7Data[i],
            reason: 'Test 7: Failed to export ${formats[i]}');
        document.dispose();
      }
    });
    test('test 8', () {
      final List<String> test8Data = <String>[
        exportValue8fdf,
        exportValue8xfdf,
        exportValue8json
      ];
      for (int i = 0; i < formats.length; i++) {
        final PdfDocument document =
            PdfDocument.fromBase64String(annotationAPPdf);
        final List<PdfAnnotation> exportAnnotations = <PdfAnnotation>[];
        final PdfAnnotationCollection collection =
            document.pages[0].annotations;
        for (int i = 0; i < collection.count; i++) {
          if (collection[i] is PdfRectangleAnnotation ||
              collection[i] is PdfLineAnnotation ||
              collection[i] is PdfTextMarkupAnnotation) {
            exportAnnotations.add(collection[i]);
          }
        }
        final List<int> bytes = document.exportAnnotation(formats[i],
            exportAppearance: true, exportList: exportAnnotations);
        expect(base64.encode(bytes), test8Data[i],
            reason: 'Test 8: Failed to export ${formats[i]}');
        document.dispose();
      }
    });
    test('test 9', () {
      final List<String> test9Data = <String>[
        exportValue9fdf,
        exportValue9xfdf,
        exportValue9json
      ];
      for (int i = 0; i < formats.length; i++) {
        final PdfDocument document = PdfDocument.fromBase64String(annotation1);
        final List<PdfAnnotation> exportAnnotations = <PdfAnnotation>[];
        for (int i = document.pages.count - 1; i >= 0; i--) {
          final PdfAnnotationCollection collection =
              document.pages[i].annotations;
          for (int j = 0; j < collection.count; j++) {
            if (formats[i] == PdfAnnotationDataFormat.json) {
              if (collection[j] is PdfPolygonAnnotation ||
                  collection[j] is PdfRectangleAnnotation) {
                exportAnnotations.add(collection[j]);
              }
            } else {
              if (collection[j] is PdfLineAnnotation ||
                  collection[j] is PdfEllipseAnnotation) {
                exportAnnotations.add(collection[j]);
              }
            }
          }
        }
        final List<int> bytes = document.exportAnnotation(formats[i],
            exportAppearance: true, exportList: exportAnnotations);
        expect(base64.encode(bytes), test9Data[i],
            reason: 'Test 9: Failed to export ${formats[i]}');
        document.dispose();
      }
    });
  });
  group('FLUT-869022 Annotation Import and Export issues', () {
    test('test 1', () {
      const String json = '{"pdfAnnotation":{}}';
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      List<int>? bytes = document.exportAnnotation(PdfAnnotationDataFormat.json,
          exportAppearance: true);
      expect(utf8.decode(bytes), json,
          reason: 'Failed to export annotation from Empty PDF.');
      bytes = null;
      document.dispose();
    });
    test('test 2', () {
      const String fdf = '%FDF-1.2\r\n';
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      List<int>? bytes = document.exportAnnotation(PdfAnnotationDataFormat.fdf,
          exportAppearance: true);
      expect(utf8.decode(bytes), fdf,
          reason: 'Failed to export annotation from Empty PDF.');
      bytes = null;
      document.dispose();
    });
    test('test 3', () {
      const String xfdf =
          '<?xml version="1.0" encoding="utf-8"?>\n<xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve">\n  <fields/>\n  <f href=""/>\n</xfdf>';
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      List<int>? bytes = document.exportAnnotation(PdfAnnotationDataFormat.xfdf,
          exportAppearance: true);
      expect(utf8.decode(bytes), xfdf,
          reason: 'Failed to export annotation from Empty PDF.');
      bytes = null;
      document.dispose();
    });
  });
  group('FLUT-869022 Annotation Import and Export issues', () {
    test('test 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportXfdf13), PdfAnnotationDataFormat.xfdf);
      final PdfPage page = document.pages[0];
      page.annotations;
      final PdfDictionary ap = PdfCrossTable.dereference(
          PdfPageHelper.getHelper(page).terminalAnnotation[0]
              [PdfDictionaryProperties.ap])! as PdfDictionary;
      expect(ap.containsKey('N'), true, reason: 'Failed to import annotation');
      expect(ap.containsKey('R'), true, reason: 'Failed to import annotation');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportXfdf16), PdfAnnotationDataFormat.xfdf);
      final PdfPage page = document.pages[0];
      page.annotations;
      final PdfDictionary sound = PdfCrossTable.dereference(
          PdfPageHelper.getHelper(page).terminalAnnotation[0]
              [PdfDictionaryProperties.sound])! as PdfDictionary;
      expect(sound.containsKey('B'), true,
          reason: 'Failed to import annotation');
      expect(sound.containsKey('R'), true,
          reason: 'Failed to import annotation');
      expect(sound.containsKey('C'), true,
          reason: 'Failed to import annotation');
      expect(sound.containsKey('E'), true,
          reason: 'Failed to import annotation');
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      document.importAnnotation(
          base64.decode(exportJson16), PdfAnnotationDataFormat.json);
      final PdfPage page = document.pages[0];
      page.annotations;
      final PdfDictionary sound = PdfCrossTable.dereference(
          PdfPageHelper.getHelper(page).terminalAnnotation[0]
              [PdfDictionaryProperties.sound])! as PdfDictionary;
      expect(sound.containsKey('B'), true,
          reason: 'Failed to import annotation');
      expect(sound.containsKey('R'), true,
          reason: 'Failed to import annotation');
      expect(sound.containsKey('C'), true,
          reason: 'Failed to import annotation');
      expect(sound.containsKey('E'), true,
          reason: 'Failed to import annotation');
      document.dispose();
    });
  });
}
