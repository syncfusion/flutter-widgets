part of pdf;

/// Base class for the main shapes.
abstract class PdfShapeElement extends PdfLayoutElement {
  // fields
  PdfPen? _pen;
  PdfBrush? _brush;

  // properties
  /// Gets a pen that will be used to draw the element.
  PdfPen get pen {
    _pen ??= PdfPens.black;
    return _pen!;
  }

  /// Sets a pen that will be used to draw the element.
  set pen(PdfPen value) {
    _pen = value;
  }

  // implementation
  PdfPen _obtainPen() {
    return (_pen == null) ? PdfPens.black : _pen!;
  }

  @override
  PdfLayoutResult? _layout(_PdfLayoutParams param) {
    final _ShapeLayouter layouter = _ShapeLayouter(this);
    final PdfLayoutResult? result = layouter._layout(param);
    return result;
  }

  _Rectangle? _getBoundsInternal();
}
