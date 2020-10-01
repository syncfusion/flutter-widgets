part of pdf;

abstract class _PdfStaticField extends PdfAutomaticField {
  // constructor
  /// Represents automatic field which value can be evaluated
  /// in the moment of creation.
  _PdfStaticField({PdfFont font, PdfBrush brush, Rect bounds})
      : super._(font, brush: brush, bounds: bounds);

  // fields
  PdfTemplate _template;
  final List<PdfGraphics> _graphicsList = <PdfGraphics>[];

  // implementation
  @override
  void _performDraw(PdfGraphics graphics, _Point _location, double scalingX,
      double scalingY) {
    super._performDraw(graphics, _location, scalingX, scalingY);

    final String value = _getValue(graphics);
    final Offset drawLocation =
        Offset(_location.x + bounds.left, _location.y + bounds.top);

    if (_template == null) {
      _template = PdfTemplate(_obtainSize().width, _obtainSize().height);
      _template.graphics.drawString(value, _obtainFont(),
          pen: pen,
          brush: _obtainBrush(),
          bounds:
              Rect.fromLTWH(0, 0, _obtainSize().width, _obtainSize().height),
          format: stringFormat);
      graphics.drawPdfTemplate(
          _template,
          drawLocation,
          Size(_template.size.width * scalingX,
              _template.size.height * scalingY));
      _graphicsList.add(graphics);
    } else {
      if (!_graphicsList.contains(graphics)) {
        graphics.drawPdfTemplate(
            _template,
            drawLocation,
            Size(_template.size.width * scalingX,
                _template.size.height * scalingY));
        _graphicsList.add(graphics);
      }
    }
  }
}
