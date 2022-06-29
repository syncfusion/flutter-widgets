import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void shapes() {
  shapeCurve();
  shapePie();
  shapeEllipse();
  shapeArc();
  shapePath();
  shapePolygon();
}

// ignore: public_member_api_docs
void shapeCurve() {
  group('BezeirCurve test case', () {
    test('draw curve 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBezierCurve bezier = PdfBezierCurve(const Offset(100, 10),
          const Offset(150, 50), const Offset(50, 80), const Offset(100, 10));
      bezier.draw(page: page, bounds: const Rect.fromLTWH(200, 100, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to draw Bezeir curve');
      savePdf(bytes, 'FLUT-708-ShapeWithCurve1.pdf');
      document.dispose();
    });
  });

  group('BezeirCurve test case', () {
    test('draw curve 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBezierCurve bezier = PdfBezierCurve(Offset.zero,
          const Offset(100, 50), const Offset(50, 50), const Offset(100, 100));
      bezier.startPoint = Offset.zero;
      bezier.firstControlPoint = const Offset(100, 50);
      bezier.secondControlPoint = const Offset(50, 50);
      bezier.endPoint = const Offset(100, 100);
      bezier.draw(page: page, bounds: const Rect.fromLTWH(100, 150, 0, 0));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to draw Bezeir curve');
      savePdf(bytes, 'FLUT-708-ShapeWithCurve2.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
void shapePie() {
  group('DrawPie test case', () {
    test('draw pie 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      const Rect bounds = Rect.fromLTWH(10, 50, 200, 200);
      final PdfPen pen = PdfPen(PdfColor(165, 42, 42), width: 5);
      page.graphics.drawPie(bounds, 90, 180, pen: pen, brush: PdfBrushes.green);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to draw pie');
      savePdf(bytes, 'FLUT-708-ShapeWithPie1.pdf');
      document.dispose();
    });
  });

  group('DrawPie test case', () {
    test('draw pie 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      const Rect bounds = Rect.fromLTWH(100, 150, 200, 200);
      final PdfPen pen = PdfPen(PdfColor(165, 42, 42), width: 5);
      page.graphics.drawPie(bounds, 180, 60, pen: pen, brush: PdfBrushes.green);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to draw pie');
      savePdf(bytes, 'FLUT-708-ShapeWithPie2.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
void shapeEllipse() {
  group('DrawEllipse test case', () {
    test('draw Ellipse 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPen pen = PdfPen(PdfColor(165, 42, 42), width: 5);
      page.graphics.drawEllipse(const Rect.fromLTWH(10, 20, 50, 100),
          pen: pen, brush: PdfBrushes.darkOrange);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to draw Ellipse');
      savePdf(bytes, 'FLUT-708-ShapeWithEllipse1.pdf');
      document.dispose();
    });
  });

  group('DrawEllipse test case', () {
    test('draw Ellipse 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPen pen = PdfPen(PdfColor(165, 42, 42), width: 5);
      page.graphics.drawEllipse(const Rect.fromLTWH(10, 200, 450, 150),
          pen: pen, brush: PdfBrushes.darkOrange);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to draw Ellipse');
      savePdf(bytes, 'FLUT-708-ShapeWithEllipse2.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
void shapeArc() {
  group('DrawArc test case', () {
    test('draw Arc 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPen pen = PdfPen(PdfColor(165, 42, 42), width: 5);
      const Rect bounds = Rect.fromLTWH(20, 40, 200, 200);
      page.graphics.drawArc(bounds, 270, 90, pen: pen);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to draw Arc');
      savePdf(bytes, 'FLUT-708-ShapeWithArc1.pdf');
      document.dispose();
    });
  });

  group('DrawArc test case', () {
    test('draw Arc 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPen pen = PdfPen(PdfColor(165, 42, 42), width: 5);
      const Rect bounds = Rect.fromLTWH(100, 140, 200, 400);
      page.graphics.drawArc(bounds, 70, 190, pen: pen);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to draw Arc');
      savePdf(bytes, 'FLUT-708-ShapeWithArc2.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
void shapePath() {
  group('DrawPath test case', () {
    test('draw Path 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPath path = PdfPath();
      path.addLine(const Offset(10, 100), const Offset(10, 200));
      path.addLine(const Offset(100, 100), const Offset(100, 200));
      path.addLine(const Offset(100, 200), const Offset(55, 150));
      // path.brush = PdfBrushes.darkSeaGreen;
      path.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed  to draw Path');
      savePdf(bytes, 'FLUT-708-ShapeWithPath1.pdf');
      document.dispose();
    });
  });

  shapePathWithAll();
}

// ignore: public_member_api_docs
void shapePolygon() {
  group('DrawPolygon test case', () {
    test('draw Polygon 1', () {
      final PdfDocument document = PdfDocument();
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
      expect(bytes.isNotEmpty, true, reason: 'failed  to draw Path');
      savePdf(bytes, 'FLUT-708-ShapeWithPolygon1.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
void shapePathWithAll() {
  group('DrawPath test case', () {
    test('draw PathWithOtherShapes 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPath path = PdfPath();
      path.addPie(const Rect.fromLTWH(20, 20, 70, 70), -45, 90);
      final List<Offset> polygonPoints = <Offset>[
        const Offset(23, 20),
        const Offset(40, 10),
        const Offset(57, 20),
        const Offset(50, 40),
        const Offset(30, 40)
      ];
      path.addRectangle(const Rect.fromLTWH(10, 10, 200, 100));
      path.addArc(const Rect.fromLTWH(10, 10, 100, 100), 0, -90);
      path.addEllipse(const Rect.fromLTWH(10, 10, 200, 100));
      path.addPolygon(polygonPoints);
      path.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw Path with all shapes');
      savePdf(bytes, 'FLUT-708-ShapeWithPath2.pdf');
      document.dispose();
    });
  });

  group('DrawPath test case', () {
    test('draw PathWithOtherShapes 2', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPath path = PdfPath();
      final List<Offset> polygonPoints = <Offset>[
        const Offset(23, 20),
        const Offset(40, 10),
        const Offset(57, 20),
        const Offset(50, 40),
        const Offset(30, 40)
      ];
      path.addBezier(const Offset(30, 30), const Offset(90, 0),
          const Offset(60, 90), const Offset(120, 30));
      path.addPolygon(polygonPoints);
      path.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw Path with all shapes');
      savePdf(bytes, 'FLUT-708-ShapeWithPath3.pdf');
      document.dispose();
    });
  });

  group('DrawPath test', () {
    test('to draw PathWithShapes 3', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final List<Offset> pathPoints = <Offset>[
        Offset.zero,
        const Offset(100, 0),
        const Offset(100, 100),
        const Offset(0, 100),
        Offset.zero,
        const Offset(100, 100),
        const Offset(0, 100),
        const Offset(100, 0)
      ];
      //Create path types.
      final List<int> pathTypes = <int>[0, 1, 1, 129, 0, 1, 1, 1];
      final PdfPath path = PdfPath(
          brush: PdfBrushes.red,
          fillMode: PdfFillMode.alternate,
          points: pathPoints,
          pathTypes: pathTypes);
      path.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed  to draw Path with all shapes');
      savePdf(bytes, 'FLUT-708-ShapeWithPath4.pdf');
      document.dispose();
    });
  });
}
