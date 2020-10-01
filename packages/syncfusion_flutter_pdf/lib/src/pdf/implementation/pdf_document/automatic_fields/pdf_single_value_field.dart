part of pdf;

abstract class _PdfSingleValueField extends _PdfDynamicField {
  // constructor
  _PdfSingleValueField([PdfFont font, PdfBrush brush, Rect bounds])
      : super(font: font, bounds: bounds, brush: brush);

  // field
  final Map<PdfDocument, _PdfTemplateValuePair> _list =
      <PdfDocument, _PdfTemplateValuePair>{};
  final List<PdfGraphics> _painterGraphics = <PdfGraphics>[];

  // implementation
  @override
  void _performDraw(PdfGraphics graphics, _Point _location, double scalingX,
      double scalingY) {
    if (graphics._page is PdfPage) {
      super._performDraw(graphics, _location, scalingX, scalingY);
      final PdfPage page = _PdfDynamicField._getPageFromGraphics(graphics);
      final PdfDocument document = page._document;
      final String value = _getValue(graphics);

      if (_list.containsKey(document)) {
        final _PdfTemplateValuePair pair = _list[document];

        if (pair.value != value) {
          final Size size = _obtainSize();
          pair.template.reset(size.width, size.height);
          pair.template.graphics.drawString(value, _obtainFont(),
              pen: pen,
              brush: _obtainBrush(),
              bounds: bounds.topLeft & size,
              format: stringFormat);
        }

        if (!_painterGraphics.contains(graphics)) {
          final Offset drawLocation =
              Offset(_location.x + bounds.left, _location.y + bounds.top);
          graphics.drawPdfTemplate(
              pair.template,
              drawLocation,
              Size(pair.template.size.width * scalingX,
                  pair.template.size.height * scalingY));
          _painterGraphics.add(graphics);
        }
      } else {
        final PdfTemplate template =
            PdfTemplate(_obtainSize().width, _obtainSize().height);
        _list[document] = _PdfTemplateValuePair(template, value);
        final _PdfTemplateValuePair pair = _list[document];
        template.graphics.drawString(value, _obtainFont(),
            pen: pen,
            brush: _obtainBrush(),
            bounds: Rect.fromLTWH(
                bounds.left, bounds.top, bounds.width, bounds.height),
            format: stringFormat);
        final Offset drawLocation =
            Offset(_location.x + bounds.left, _location.y + bounds.top);
        graphics.drawPdfTemplate(
            pair.template,
            drawLocation,
            Size(pair.template.size.width * scalingX,
                pair.template.size.height * scalingY));
        _painterGraphics.add(graphics);
      }
    }
  }
}
