part of pdf;

class _PaintParams {
  _PaintParams(
      {PdfBrush? backBrush,
      PdfBrush? foreBrush,
      PdfPen? borderPen,
      Rect? bounds,
      PdfBorderStyle? style,
      int? borderWidth,
      PdfBrush? shadowBrush}) {
    _backBrush = backBrush;
    _foreBrush = foreBrush;
    _borderPen = borderPen;
    _bounds = bounds;
    _style = style;
    _borderWidth = borderWidth;
    _shadowBrush = shadowBrush;
  }
  // Fields
  PdfBrush? _backBrush;
  PdfBrush? _foreBrush;
  PdfPen? _borderPen;
  Rect? _bounds;
  PdfBorderStyle? _style;
  int? _borderWidth;
  PdfBrush? _shadowBrush;
}
