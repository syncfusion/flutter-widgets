import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/annotations/pdf_annotation.dart';
import '../pdf/implementation/annotations/pdf_ellipse_annotation.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void shapeAnnotations() {
  group('Line annotation', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
          points, 'Line Annotation',
          leaderLine: 0, leaderLineExt: 0);
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 0);
      lineAnnotation.leaderLineExt = 0;
      lineAnnotation.leaderLine = 0;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotation.pdf');
    });
    test('using set Appearance', () {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfPage page = document.pages.add();
      page.graphics.drawString('Line Annotation', font,
          brush: PdfBrushes.black,
          bounds: const Rect.fromLTWH(250, 170, 200, 15));
      final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
          <int>[250, 602, 450, 602], 'Line Annotation',
          color: PdfColor(255, 0, 0), setAppearance: true);
      lineAnnotation.captionType = PdfLineCaptionType.top;
      page.annotations.add(lineAnnotation);
      final PdfLineAnnotation lineAnnotation2 = PdfLineAnnotation(
          <int>[250, 502, 450, 502], 'Line Annotation',
          color: PdfColor(255, 0, 0), setAppearance: true);
      lineAnnotation2.captionType = PdfLineCaptionType.inline;
      page.annotations.add(lineAnnotation2);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotationSA.pdf');
      document.dispose();
    });
  });

  group('Line annotation', () {
    test('Sample 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation =
          PdfLineAnnotation(points, 'Line Annotation');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 255);
      lineAnnotation.leaderLineExt = 10;
      lineAnnotation.leaderLine = (lineAnnotation.leaderLine == 0) ? 10 : 2;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      lineAnnotation.linePoints = points;
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotation2.pdf');
    });
  });

  group('Line annotation', () {
    test('Sample 3', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation =
          PdfLineAnnotation(points, 'Line Annotation');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 255);
      lineAnnotation.leaderLineExt = 10;
      lineAnnotation.leaderLine = (lineAnnotation.leaderLine == 0) ? 10 : 2;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      lineAnnotation.linePoints = points;
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotation3.pdf');
    });
  });

  for (final PdfBorderStyle style in PdfBorderStyle.values) {
    group('Line annotation', () {
      test('Sample $style', () {
        final PdfDocument document = PdfDocument();
        final PdfPage page = document.pages.add();
        final List<int> points = <int>[80, 120, 150, 420];
        final PdfLineAnnotation lineAnnotation =
            PdfLineAnnotation(points, 'Line Annotation');
        final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
        lineBorder.borderStyle = style;
        lineBorder.width = 1;
        lineBorder.dashArray = 3;
        lineAnnotation.border = lineBorder;

        page.annotations.add(lineAnnotation);
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason: 'failed to perform line Annotations');
        savePdf(bytes, 'FLUT-1956-$style.pdf');
      });
    });
  }

  group('Line annotation review', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation =
          PdfLineAnnotation(points, 'Line Annotation');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 0);
      lineAnnotation.leaderLineExt = 0;
      lineAnnotation.leaderLine = 0;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotationReview.pdf');
    });
  });

  group('Line annotation comment', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation =
          PdfLineAnnotation(points, 'Line Annotation');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 0);
      lineAnnotation.leaderLineExt = 0;
      lineAnnotation.leaderLine = 0;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotationComment.pdf');
    });
  });

  group('Square annotation', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation squareAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 80, 80), 'SquareAnnotation');
      squareAnnotation.innerColor = PdfColor(255, 0, 0);
      squareAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Square Annotation', font, brush: brush);
      page.annotations.add(squareAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform square Annotations');
      savePdf(bytes, 'FLUT-1956-SquareAnnotation.pdf');
    });
  });

  group('Square annotation review', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation squareAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 80, 80), 'SquareAnnotation');
      squareAnnotation.innerColor = PdfColor(255, 0, 0);
      squareAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Square Annotation', font, brush: brush);
      page.annotations.add(squareAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform square Annotations');
      savePdf(bytes, 'FLUT-1956-SquareAnnotationReview.pdf');
    });
  });

  group('Square annotation coment', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation squareAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 80, 80), 'SquareAnnotation');
      squareAnnotation.innerColor = PdfColor(255, 0, 0);
      squareAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Square Annotation', font, brush: brush);
      page.annotations.add(squareAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform square Annotations');
      savePdf(bytes, 'FLUT-1956-SquareAnnotationComment.pdf');
    });
  });

  group('Rectangle annotation', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation rectAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'RectangleAnnotation');
      rectAnnotation.innerColor = PdfColor(255, 0, 0);
      rectAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Rectangle Annotation', font, brush: brush);
      page.annotations.add(rectAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform rectangle Annotations');
      savePdf(bytes, 'FLUT-1956-RectangleAnnotation.pdf');
    });
  });

  group('Rectangle annotation review', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation rectAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'RectangleAnnotation');
      rectAnnotation.innerColor = PdfColor(255, 0, 0);
      rectAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Rectangle Annotation', font, brush: brush);
      page.annotations.add(rectAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform rectangle Annotations');
      savePdf(bytes, 'FLUT-1956-RectangleAnnotationReview.pdf');
    });
  });

  group('Rectangle annotation comment', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation rectAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'RectangleAnnotation');
      rectAnnotation.innerColor = PdfColor(255, 0, 0);
      rectAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Rectangle Annotation', font, brush: brush);
      page.annotations.add(rectAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform rectangle Annotations');
      savePdf(bytes, 'FLUT-1956-RectangleAnnotationComment.pdf');
    });
  });

  group('Circle annotation', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(10, 100, 100, 100), 'CircleAnnotation');
      circleAnnotation.innerColor = PdfColor(255, 0, 0);
      circleAnnotation.color = PdfColor(255, 0, 255);
      page.graphics.drawString('Circle Annotation', font, brush: brush);
      page.annotations.add(circleAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle Annotations');
      savePdf(bytes, 'FLUT-1956-CircleAnnotation.pdf');
    });
  });

  group('Circle annotation review history', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(10, 100, 100, 100), 'CircleAnnotation');
      circleAnnotation.innerColor = PdfColor(255, 0, 0);
      circleAnnotation.color = PdfColor(255, 0, 255);
      page.graphics.drawString('Circle Annotation', font, brush: brush);
      page.annotations.add(circleAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle review Annotations');
      savePdf(bytes, 'FLUT-1956-CircleAnnotationReview.pdf');
    });
  });

  group('Circle annotation comments', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(10, 100, 100, 100), 'CircleAnnotation');
      circleAnnotation.innerColor = PdfColor(255, 0, 0);
      circleAnnotation.color = PdfColor(255, 0, 255);
      page.graphics.drawString('Circle Annotation', font, brush: brush);
      page.annotations.add(circleAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle comment Annotations');
      savePdf(bytes, 'FLUT-1956-CircleAnnotationComment.pdf');
    });
  });

  group('Ellipse annotation', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation');
      ellipseAnnotation.innerColor = PdfColor(255, 0, 0);
      ellipseAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Ellipse Annotation', font, brush: brush);
      page.annotations.add(ellipseAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform ellipse Annotations');
      savePdf(bytes, 'FLUT-1956-ellipseAnnotation.pdf');
    });
  });

  group('Ellipse annotation review', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation');
      ellipseAnnotation.innerColor = PdfColor(255, 0, 0);
      ellipseAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Ellipse Annotation', font, brush: brush);
      page.annotations.add(ellipseAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform ellipse Annotations');
      savePdf(bytes, 'FLUT-1956-ellipseAnnotationReview.pdf');
    });
  });

  group('Ellipse annotation comment', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation');
      ellipseAnnotation.innerColor = PdfColor(255, 0, 0);
      ellipseAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Ellipse Annotation', font, brush: brush);
      page.annotations.add(ellipseAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform ellipse Annotations');
      savePdf(bytes, 'FLUT-1956-ellipseAnnotationComment.pdf');
    });
  });

  group('Polygon annotation', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      final PdfPolygonAnnotation polygonAnnotation =
          PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
      polygonAnnotation.bounds = const Rect.fromLTWH(30, 110, 100, 70);
      polygonAnnotation.text = 'polygon';
      polygonAnnotation.color = PdfColor(255, 0, 0);
      polygonAnnotation.innerColor = PdfColor(255, 0, 255);
      page.graphics.drawString('Polygon Annotation', font, brush: brush);

      page.annotations.add(polygonAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform ellipse Annotations');
      savePdf(bytes, 'FLUT-1956-polygonAnnotation.pdf');
    });
  });

  group('Polygon annotation review', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      final PdfPolygonAnnotation polygonAnnotation =
          PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
      polygonAnnotation.bounds = const Rect.fromLTWH(0, 30, 100, 70);
      polygonAnnotation.text = 'polygon';
      polygonAnnotation.color = PdfColor(255, 0, 0);
      polygonAnnotation.innerColor = PdfColor(255, 0, 255);
      page.graphics.drawString('Polygon Annotation', font, brush: brush);
      page.annotations.add(polygonAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform polygon Annotations');
      savePdf(bytes, 'FLUT-1956-polygonAnnotationReview.pdf');
    });
  });

  group('Polygon annotation comment', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      final PdfPolygonAnnotation polygonAnnotation =
          PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      polygonAnnotation.border = lineBorder;
      polygonAnnotation.bounds = const Rect.fromLTWH(0, 30, 100, 70);
      polygonAnnotation.text = 'polygon';
      polygonAnnotation.color = PdfColor(255, 0, 0);
      polygonAnnotation.innerColor = PdfColor(255, 0, 255);
      page.graphics.drawString('Polygon Annotation', font, brush: brush);
      page.annotations.add(polygonAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform polygon Annotations');
      savePdf(bytes, 'FLUT-1956-polygonAnnotationComment.pdf');
    });
  });

  group('Circle annotation With modified date and subject', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(10, 100, 100, 100), 'CircleAnnotation');
      circleAnnotation.innerColor = PdfColor(255, 0, 0);
      circleAnnotation.color = PdfColor(255, 0, 255);
      circleAnnotation.subject = 'CircleAnnotation';
      circleAnnotation.modifiedDate = DateTime(2015, 1, 18);
      page.graphics.drawString('Circle Annotation', font, brush: brush);
      page.annotations.add(circleAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle comment Annotations');
      savePdf(bytes, 'FLUT-1956-CircleWithSubjectModifiedDate.pdf');
    });
  });

  group('Circle annotation With modified date and subject', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(10, 100, 100, 100), 'CircleAnnotation');
      circleAnnotation.innerColor = PdfColor(255, 0, 0);
      circleAnnotation.color = PdfColor(255, 0, 255);
      circleAnnotation.subject = 'CircleAnnotation';
      circleAnnotation.modifiedDate = DateTime(2015, 1, 18);
      page.graphics.drawString('Circle Annotation', font, brush: brush);
      page.annotations.add(circleAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle comment Annotations');
      savePdf(bytes, 'FLUT-1956-CircleWithSubjectModifiedDate.pdf');
    });
  });

  group('Circle annotation With All properties', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(10, 100, 100, 100), 'CircleAnnotation',
          innerColor: PdfColor(255, 0, 0),
          color: PdfColor(255, 0, 255),
          author: 'syncfusion',
          subject: 'Circle Annot',
          modifiedDate: DateTime(2015, 1, 18));
      page.graphics.drawString('Circle Annotation', font, brush: brush);
      page.annotations.add(circleAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle comment Annotations');
      savePdf(bytes, 'FLUT-1956-CircleWithAnnotProperties.pdf');
    });
  });

  group('Circle annotation With SetAppearance', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(350, 170, 80, 80), 'CircleAnnotation');
      circleAnnotation.innerColor = PdfColor(255, 0, 0);
      circleAnnotation.color = PdfColor(255, 0, 255);
      circleAnnotation.subject = 'CircleAnnotation';
      circleAnnotation.modifiedDate = DateTime(2015, 1, 18);
      page.graphics.drawString('Circle Annotation', font,
          brush: brush, bounds: const Rect.fromLTWH(350, 130, 0, 0));
      circleAnnotation.setAppearance = true;
      page.annotations.add(circleAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle circle Annotations');
      savePdf(bytes, 'FLUT-1956-CircleWithSetApp.pdf');
    });
  });

  group('Rectangle annotation flatten', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation rectAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'RectangleAnnotation');
      rectAnnotation.innerColor = PdfColor(255, 0, 0);
      rectAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Rectangle Annotation', font, brush: brush);
      rectAnnotation.flatten();
      page.annotations.add(rectAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform rectangle Annotations');
      savePdf(bytes, 'FLUT-1956-RectangleAnnotFlatten.pdf');
    });
  });

  group('Rectangle annotation setAppearance', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation rectAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'RectangleAnnotation');
      rectAnnotation.innerColor = PdfColor(255, 0, 0);
      rectAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Rectangle Annotation', font, brush: brush);
      rectAnnotation.setAppearance = true;
      page.annotations.add(rectAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform rectangle Annotations');
      savePdf(bytes, 'FLUT-1956-RectangleAnnotSetApp.pdf');
    });
  });

  group('Polygon annotation Flatten', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      final PdfPolygonAnnotation polygonAnnotation =
          PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
      polygonAnnotation.bounds = const Rect.fromLTWH(0, 30, 100, 70);
      polygonAnnotation.text = 'polygon';
      polygonAnnotation.color = PdfColor(255, 0, 0);
      polygonAnnotation.innerColor = PdfColor(255, 0, 255);
      page.graphics.drawString('Polygon Annotation', font,
          brush: brush, bounds: const Rect.fromLTWH(50, 420, 0, 0));
      polygonAnnotation.flatten();

      page.annotations.add(polygonAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform polygon Annotations');
      savePdf(bytes, 'FLUT-1956-polygonAnnotFlatten.pdf');
    });
  });

  group('Polygon annotation setAppearance', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      final PdfPolygonAnnotation polygonAnnotation =
          PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
      polygonAnnotation.bounds = const Rect.fromLTWH(0, 30, 100, 70);
      polygonAnnotation.text = 'polygon';
      polygonAnnotation.color = PdfColor(255, 0, 0);
      polygonAnnotation.innerColor = PdfColor(255, 0, 255);
      page.graphics.drawString('Polygon Annotation', font,
          brush: brush, bounds: const Rect.fromLTWH(50, 420, 0, 0));
      polygonAnnotation.setAppearance = true;

      page.annotations.add(polygonAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform polygon Annotations');
      savePdf(bytes, 'FLUT-1956-polygonAnnotSetApp.pdf');
    });
  });

  group('Polygon annotation setAppearance', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      final PdfPolygonAnnotation polygonAnnotation =
          PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
      polygonAnnotation.bounds = const Rect.fromLTWH(0, 30, 100, 70);
      polygonAnnotation.text = 'polygon';
      polygonAnnotation.color = PdfColor(255, 0, 0);
      polygonAnnotation.innerColor = PdfColor(255, 0, 255);
      page.graphics.drawString('Polygon Annotation', font,
          brush: brush, bounds: const Rect.fromLTWH(50, 420, 0, 0));
      polygonAnnotation.setAppearance = true;

      page.annotations.add(polygonAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform polygon Annotations');
      savePdf(bytes, 'FLUT-1956-polygonAnnotSetApp.pdf');
    });
  });

  group('Line annotation flatten', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation =
          PdfLineAnnotation(points, 'Line Annot');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 255);
      lineAnnotation.leaderLineExt = 10;
      lineAnnotation.leaderLine = (lineAnnotation.leaderLine == 0) ? 10 : 2;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      lineAnnotation.linePoints = points;
      lineAnnotation.flatten();
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotFlatten.pdf');
    });
  });

  group('Line annotation setAppearance', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation =
          PdfLineAnnotation(points, 'Line Annot');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 255);
      lineAnnotation.leaderLineExt = 10;
      lineAnnotation.leaderLine = (lineAnnotation.leaderLine == 0) ? 10 : 2;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      lineAnnotation.linePoints = points;
      lineAnnotation.setAppearance = true;
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotSetApp.pdf');
    });
  });

  group('Rectangle annotation flattenPopup', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation rectAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'RectangleAnnotation');
      rectAnnotation.innerColor = PdfColor(255, 0, 0);
      rectAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Rectangle Annotation', font, brush: brush);
      PdfAnnotationHelper.getHelper(rectAnnotation).flattenPopups = true;
      page.annotations.add(rectAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform rectangle Annotations');
      savePdf(bytes, 'FLUT-1956-RectangleAnnotFlattenPopup.pdf');
    });
  });

  group('Circle annotation With flatten popup', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(350, 170, 80, 80), 'CircleAnnotation');
      circleAnnotation.innerColor = PdfColor(255, 0, 0);
      circleAnnotation.color = PdfColor(255, 0, 255);
      circleAnnotation.author = 'Syncfusion';
      circleAnnotation.modifiedDate = DateTime(2015, 1, 18);
      page.graphics.drawString('Circle Annotation', font,
          brush: brush, bounds: const Rect.fromLTWH(350, 130, 0, 0));
      PdfAnnotationHelper.getHelper(circleAnnotation).flattenPopups = true;
      page.annotations.add(circleAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle circle Annotations');
      savePdf(bytes, 'FLUT-1956-CircleWithFlattenPopup.pdf');
    });
  });

  group('Line annotation flatten popup', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation =
          PdfLineAnnotation(points, 'Line Annot');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 255);
      lineAnnotation.leaderLineExt = 10;
      lineAnnotation.leaderLine = (lineAnnotation.leaderLine == 0) ? 10 : 2;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      lineAnnotation.linePoints = points;
      PdfAnnotationHelper.getHelper(lineAnnotation).flattenPopups = true;
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotFtPopup.pdf');
    });
  });

  group('Line annotation Popup', () {
    test('Sample 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation =
          PdfLineAnnotation(points, 'Line Annotation');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 0);
      lineAnnotation.leaderLineExt = 0;
      lineAnnotation.leaderLine = 0;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotationPopup1.pdf');
    });
  });

  group('Line annotation Popup', () {
    test('Sample 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation =
          PdfLineAnnotation(points, 'Line Annotation');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 0);
      lineAnnotation.leaderLineExt = 0;
      lineAnnotation.leaderLine = 0;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotationPopup2.pdf');
    });
  });

  group('Square annotation popup', () {
    test('Sample 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation squareAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 80, 80), 'SquareAnnotation');
      squareAnnotation.innerColor = PdfColor(255, 0, 0);
      squareAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Square Annotation', font, brush: brush);
      page.annotations.add(squareAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform square Annotations');
      savePdf(bytes, 'FLUT-1956-SquareAnnotationPopup1.pdf');
    });
  });

  group('Square annotation popup', () {
    test('Sample 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation squareAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 80, 80), 'SquareAnnotation');
      squareAnnotation.innerColor = PdfColor(255, 0, 0);
      squareAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Square Annotation', font, brush: brush);
      page.annotations.add(squareAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform square Annotations');
      savePdf(bytes, 'FLUT-1956-SquareAnnotationPopup2.pdf');
    });
  });

  group('Ellipse annotation popup', () {
    test('Sample 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation');
      ellipseAnnotation.innerColor = PdfColor(255, 0, 0);
      ellipseAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Ellipse Annotation', font, brush: brush);
      page.annotations.add(ellipseAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform ellipse Annotations');
      savePdf(bytes, 'FLUT-1956-ellipseAnnotPopup1.pdf');
    });
  });

  group('Ellipse annotation popup', () {
    test('Sample 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation');
      ellipseAnnotation.innerColor = PdfColor(255, 0, 0);
      ellipseAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Ellipse Annotation', font, brush: brush);
      page.annotations.add(ellipseAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform ellipse Annotations');
      savePdf(bytes, 'FLUT-1956-ellipseAnnotPopup2.pdf');
    });
  });

  group('Polygon annotation popup', () {
    test('Sample 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      final PdfPolygonAnnotation polygonAnnotation =
          PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
      polygonAnnotation.bounds = const Rect.fromLTWH(0, 30, 100, 70);
      polygonAnnotation.text = 'polygon';
      polygonAnnotation.color = PdfColor(255, 0, 0);
      polygonAnnotation.innerColor = PdfColor(255, 0, 255);
      page.graphics.drawString('Polygon Annotation', font, brush: brush);
      page.annotations.add(polygonAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform polygon Annotations');
      savePdf(bytes, 'FLUT-1956-polygonAnnotPopup1.pdf');
    });
  });

  group('Polygon annotation popup', () {
    test('Sample 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      final PdfPolygonAnnotation polygonAnnotation =
          PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      polygonAnnotation.border = lineBorder;
      polygonAnnotation.bounds = const Rect.fromLTWH(0, 30, 100, 70);
      polygonAnnotation.text = 'polygon';
      polygonAnnotation.color = PdfColor(255, 0, 0);
      polygonAnnotation.innerColor = PdfColor(255, 0, 255);
      page.graphics.drawString('Polygon Annotation', font, brush: brush);
      page.annotations.add(polygonAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform polygon Annotations');
      savePdf(bytes, 'FLUT-1956-polygonAnnotPopup2.pdf');
    });
  });

  group('Circle annotation flattenPopup', () {
    test('Sample 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(10, 100, 100, 100), 'CircleAnnotation');
      circleAnnotation.innerColor = PdfColor(255, 0, 0);
      circleAnnotation.color = PdfColor(255, 0, 255);
      page.graphics.drawString('Circle Annotation', font, brush: brush);
      PdfAnnotationHelper.getHelper(circleAnnotation).flattenPopups = true;
      page.annotations.add(circleAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle Annotations');
      savePdf(bytes, 'FLUT-1956-CircleAnnotFtPopup2.pdf');
    });
  });

  group('Rectangle annotation flatten', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation rectAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'RectangleAnnotation',
          opacity: 0.89);
      rectAnnotation.innerColor = PdfColor(255, 0, 0);
      rectAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Rectangle Annotation', font, brush: brush);
      rectAnnotation.flatten();
      page.annotations.add(rectAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform rectangle Annotations');
      savePdf(bytes, 'FLUT-1956-RectangleAnnotFlattenOP.pdf');
    });
  });

  group('Polygon annotation Flatten', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      final PdfPolygonAnnotation polygonAnnotation =
          PdfPolygonAnnotation(polypoints, 'PolygonAnnotation', opacity: 0.91);
      polygonAnnotation.bounds = const Rect.fromLTWH(0, 30, 100, 70);
      polygonAnnotation.color = PdfColor(255, 0, 0);
      polygonAnnotation.innerColor = PdfColor(255, 0, 255);
      page.graphics.drawString('Polygon Annotation', font,
          brush: brush, bounds: const Rect.fromLTWH(50, 420, 0, 0));
      polygonAnnotation.flatten();

      page.annotations.add(polygonAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform polygon Annotations');
      savePdf(bytes, 'FLUT-1956-polygonAnnotFlattenOP.pdf');
    });
  });

  group('Line annotation flatten', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final List<int> points = <int>[80, 420, 150, 420];
      final PdfLineAnnotation lineAnnotation =
          PdfLineAnnotation(points, 'Line Annot', opacity: 0.95);
      final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
      lineBorder.borderStyle = PdfBorderStyle.solid;
      lineBorder.width = 1;
      lineAnnotation.border = lineBorder;
      lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
      lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
      lineAnnotation.endLineStyle = PdfLineEndingStyle.diamond;
      lineAnnotation.innerColor = PdfColor(0, 255, 0);
      lineAnnotation.color = PdfColor(0, 255, 255);
      lineAnnotation.leaderLineExt = 10;
      lineAnnotation.leaderLine = (lineAnnotation.leaderLine == 0) ? 10 : 2;
      lineAnnotation.lineCaption = true;
      lineAnnotation.captionType = PdfLineCaptionType.inline;
      lineAnnotation.linePoints = points;
      lineAnnotation.flatten();
      page.annotations.add(lineAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform line Annotations');
      savePdf(bytes, 'FLUT-1956-LineAnnotFlattenOP.pdf');
    });
  });

  group('Rectangle annotation flattenPopup', () {
    test('Sample 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation rectAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'RectangleAnnotation');
      rectAnnotation.subject = 'Rectangle annotation with faltten popup';
      rectAnnotation.innerColor = PdfColor(255, 0, 0);
      rectAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Rectangle Annotation', font, brush: brush);
      PdfAnnotationHelper.getHelper(rectAnnotation).flattenPopups = true;
      page.annotations.add(rectAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform rectangle Annotations');
      savePdf(bytes, 'FLUT-1956-RectangleAnnotFlattenPopup1.pdf');
    });
  });

  group('Rectangle annotation flattenPopup', () {
    test('Sample 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final PdfRectangleAnnotation rectAnnotation = PdfRectangleAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'RectangleAnnotation');
      rectAnnotation.author = 'Rect';
      rectAnnotation.innerColor = PdfColor(255, 0, 0);
      rectAnnotation.color = PdfColor(255, 255, 0);
      page.graphics.drawString('Rectangle Annotation', font, brush: brush);
      PdfAnnotationHelper.getHelper(rectAnnotation).flattenPopups = true;
      page.annotations.add(rectAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform rectangle Annotations');
      savePdf(bytes, 'FLUT-1956-RectangleAnnotFlattenPopup2.pdf');
    });
  });

  for (final PdfLineEndingStyle lineStyle in PdfLineEndingStyle.values) {
    group('Line annotation flatten', () {
      test('Sample with $lineStyle', () {
        final PdfDocument document = PdfDocument();
        document.compressionLevel = PdfCompressionLevel.none;
        final PdfPage page = document.pages.add();
        final List<int> points = <int>[80, 420, 150, 420];
        final PdfLineAnnotation lineAnnotation =
            PdfLineAnnotation(points, 'Line Annot', opacity: 0.95);
        final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
        lineBorder.borderStyle = PdfBorderStyle.solid;
        lineBorder.width = 1;
        lineAnnotation.border = lineBorder;
        lineAnnotation.lineIntent = PdfLineIntent.lineDimension;
        lineAnnotation.beginLineStyle = PdfLineEndingStyle.butt;
        lineAnnotation.endLineStyle = lineStyle;
        lineAnnotation.innerColor = PdfColor(0, 255, 0);
        lineAnnotation.color = PdfColor(0, 255, 255);
        lineAnnotation.leaderLineExt = 10;
        lineAnnotation.leaderLine = 2;
        lineAnnotation.lineCaption = true;
        lineAnnotation.captionType = PdfLineCaptionType.top;
        lineAnnotation.linePoints = points;
        lineAnnotation.flatten();
        page.annotations.add(lineAnnotation);
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason: 'failed to perform line Annotations');
        savePdf(bytes, 'FLUT-1956-LineAt$lineStyle.pdf');
      });
    });
  }

  group('Ellipse annotation flattenPopup', () {
    test('Sample', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfEllipseAnnotation ellipseAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(0, 30, 100, 50), 'EllipseAnnotation');
      ellipseAnnotation.innerColor = PdfColor(255, 0, 0);
      ellipseAnnotation.color = PdfColor(255, 255, 0);
      ellipseAnnotation.author = 'Syncfusion';
      PdfAnnotationHelper.getHelper(ellipseAnnotation).flattenPopups = true;
      page.annotations.add(ellipseAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform ellipse Annotations');
      savePdf(bytes, 'FLUT-1956-ellipseAnnotFlattenPopup.pdf');
    });
  });

  group('Circle annotation With flattenPopup', () {
    test('Sample 1', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(350, 170, 80, 80), 'CircleAnnotation');
      circleAnnotation.innerColor = PdfColor(255, 0, 0);
      circleAnnotation.color = PdfColor(255, 0, 255);
      PdfAnnotationHelper.getHelper(circleAnnotation).flattenPopups = true;
      page.annotations.add(circleAnnotation);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle circle Annotations');
      savePdf(bytes, 'FLUT-1956-CircleWithFlattenPopup.pdf');
    });
  });

  group('Circle annotation With flatten popup', () {
    test('Sample 2', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
          const Rect.fromLTWH(100, 170, 80, 80), 'CircleAnnotation',
          border: PdfAnnotationBorder(5));
      circleAnnotation.innerColor = PdfColor(255, 0, 0);
      circleAnnotation.color = PdfColor(255, 0, 255);
      circleAnnotation.author = 'Syncfusion';
      circleAnnotation.subject = 'CircleAnnotation';
      circleAnnotation.modifiedDate = DateTime(2015, 1, 18);
      circleAnnotation.opacity = 0.5;
      circleAnnotation.flatten();
      PdfAnnotationHelper.getHelper(circleAnnotation).flattenPopups = true;
      PdfEllipseAnnotationHelper.getHelper(circleAnnotation).element;
      page.annotations.add(circleAnnotation);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to perform circle circle Annotations');
      savePdf(bytes, 'FLUT-1956-CircleWithFlattenPopup2.pdf');
    });
  });
}
