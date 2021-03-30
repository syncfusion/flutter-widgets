part of pdf;

abstract class _PdfMultipleValueField extends _PdfDynamicField {
  // constructor
  _PdfMultipleValueField({PdfFont? font, PdfBrush? brush, Rect? bounds})
      : super(font: font, bounds: bounds, brush: brush);

  // fields
  final Map<PdfGraphics, _PdfTemplateValuePair> _list =
      <PdfGraphics, _PdfTemplateValuePair>{};

  // implementation
  @override
  void _performDraw(PdfGraphics graphics, _Point? _location, double scalingX,
      double scalingY) {
    super._performDraw(graphics, _location, scalingX, scalingY);
    final String? value = _getValue(graphics);

    if (_list.containsKey(graphics)) {
      final _PdfTemplateValuePair pair = _list[graphics]!;

      if (pair.value != value) {
        final Size size = _obtainSize();
        pair.template.reset(size.width, size.height);
        pair.template.graphics!.drawString(value!, font,
            pen: pen,
            brush: brush,
            bounds: Rect.fromLTWH(0, 0, size.width, size.height),
            format: stringFormat);
      }
    } else {
      final PdfTemplate template =
          PdfTemplate(_obtainSize().width, _obtainSize().height);
      _list[graphics] = _PdfTemplateValuePair(template, value!);
      template.graphics!.drawString(value, font,
          pen: pen,
          brush: brush,
          bounds:
              Rect.fromLTWH(0, 0, _obtainSize().width, _obtainSize().height),
          format: stringFormat);
      final Offset drawLocation =
          Offset(_location!.x + bounds.left, _location.y + bounds.top);
      graphics.drawPdfTemplate(
          template,
          drawLocation,
          Size(
              template.size.width * scalingX, template.size.height * scalingY));
    }
  }
}
