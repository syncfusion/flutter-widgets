part of pdf;

/// Represents Bezier curve shape.
class PdfBezierCurve extends PdfShapeElement {
  // constructor
  /// Initializes a new instance of the [PdfBezierCurve] class
  /// with the specified [PdfPen] and [Offset] structure.
  PdfBezierCurve(Offset startPoint, Offset firstControlPoint,
      Offset secondControlPoint, Offset endPoint,
      {PdfPen pen})
      : super._(pen: pen) {
    this.startPoint = startPoint;
    this.firstControlPoint = firstControlPoint;
    this.secondControlPoint = secondControlPoint;
    this.endPoint = endPoint;
  }

  // fields
  _Point _startPoint = _Point.empty;
  _Point _firstControlPoint = _Point.empty;
  _Point _secondControlPoint = _Point.empty;
  _Point _endPoint = _Point.empty;

  // properties
  /// Gets the starting point of the curve
  Offset get startPoint => _startPoint.offset;

  /// Sets the starting point of the curve
  set startPoint(Offset value) {
    if (value != null) {
      _startPoint = _Point.fromOffset(value);
    }
  }

  /// Gets the first control point of the curve.
  Offset get firstControlPoint => _firstControlPoint.offset;

  /// Sets the first control point of the curve.
  set firstControlPoint(Offset value) {
    if (value != null) {
      _firstControlPoint = _Point.fromOffset(value);
    }
  }

  /// Gets the second control point of the curve
  Offset get secondControlPoint => _secondControlPoint.offset;

  /// Sets the second control point of the curve
  set secondControlPoint(Offset value) {
    if (value != null) {
      _secondControlPoint = _Point.fromOffset(value);
    }
  }

  /// Gets the ending point of the curve.
  Offset get endPoint => _endPoint.offset;

  /// Sets the ending point of the curve.
  set endPoint(Offset value) {
    if (value != null) {
      _endPoint = _Point.fromOffset(value);
    }
  }

  // implementation

  @override
  void _drawInternal(PdfGraphics graphics, _Rectangle bounds) {
    ArgumentError.checkNotNull(graphics, 'graphics');
    graphics.drawBezier(
        startPoint, firstControlPoint, secondControlPoint, endPoint,
        pen: _obtainPen());
  }
}
