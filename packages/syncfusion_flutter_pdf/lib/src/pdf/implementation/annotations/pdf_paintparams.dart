part of pdf;

class _PaintParams {
  _PaintParams({
    PdfBrush backBrush,
    PdfBrush foreBrush,
    PdfPen borderPen,
  }) {
    _backBrush = backBrush;
    _foreBrush = foreBrush;
    _borderPen = borderPen;
  }
  // Fields
  PdfBrush _backBrush;
  PdfBrush _foreBrush;
  PdfPen _borderPen;
}
