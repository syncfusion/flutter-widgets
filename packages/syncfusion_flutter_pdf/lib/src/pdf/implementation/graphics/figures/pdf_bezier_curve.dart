import 'dart:ui';

import '../../drawing/drawing.dart';
import '../pdf_graphics.dart';
import '../pdf_pen.dart';
import 'base/pdf_shape_element.dart';

/// Represents Bezier curve shape.
class PdfBezierCurve extends PdfShapeElement {
  // constructor
  /// Initializes a new instance of the [PdfBezierCurve] class
  /// with the specified [PdfPen] and [Offset] structure.
  PdfBezierCurve(Offset startPoint, Offset firstControlPoint,
      Offset secondControlPoint, Offset endPoint,
      {PdfPen? pen}) {
    _helper = PdfBezierCurveHelper(this);
    if (pen != null) {
      super.pen = pen;
    }
    this.startPoint = startPoint;
    this.firstControlPoint = firstControlPoint;
    this.secondControlPoint = secondControlPoint;
    this.endPoint = endPoint;
  }

  // fields
  late PdfBezierCurveHelper _helper;
  PdfPoint _startPoint = PdfPoint.empty;
  PdfPoint _firstControlPoint = PdfPoint.empty;
  PdfPoint _secondControlPoint = PdfPoint.empty;
  PdfPoint _endPoint = PdfPoint.empty;

  // properties
  /// Gets the starting point of the curve
  Offset get startPoint => _startPoint.offset;

  /// Sets the starting point of the curve
  set startPoint(Offset value) {
    _startPoint = PdfPoint.fromOffset(value);
  }

  /// Gets the first control point of the curve.
  Offset get firstControlPoint => _firstControlPoint.offset;

  /// Sets the first control point of the curve.
  set firstControlPoint(Offset value) {
    _firstControlPoint = PdfPoint.fromOffset(value);
  }

  /// Gets the second control point of the curve
  Offset get secondControlPoint => _secondControlPoint.offset;

  /// Sets the second control point of the curve
  set secondControlPoint(Offset value) {
    _secondControlPoint = PdfPoint.fromOffset(value);
  }

  /// Gets the ending point of the curve.
  Offset get endPoint => _endPoint.offset;

  /// Sets the ending point of the curve.
  set endPoint(Offset value) {
    _endPoint = PdfPoint.fromOffset(value);
  }
}

/// [PdfBezierCurve] helper
class PdfBezierCurveHelper {
  /// internal constructor
  PdfBezierCurveHelper(this.base);

  /// internal field
  late PdfBezierCurve base;

  /// internal method
  static PdfBezierCurveHelper getHelper(PdfBezierCurve base) {
    return base._helper;
  }

  /// internal method
  void drawInternal(PdfGraphics graphics, PdfRectangle bounds) {
    graphics.drawBezier(base.startPoint, base.firstControlPoint,
        base.secondControlPoint, base.endPoint,
        pen: PdfShapeElementHelper.obtainPen(base));
  }

  /// internal method
  PdfRectangle? getBoundsInternal() {
    return null;
  }
}
