part of pdf;

/// Represents the text area with the ability to span several pages
/// and inherited from the [PdfLayoutElement] class
class PdfTextElement extends PdfLayoutElement {
  //Constructors
  /// Initializes a new instance of the [PdfTextElement] class.
  PdfTextElement(
      {String text = '',
      PdfFont? font,
      PdfPen? pen,
      PdfBrush? brush,
      PdfStringFormat? format}) {
    _initialize(text, font, pen, brush, format);
  }

  //Fields
  /// A value indicating the text that should be printed.
  late String text;

  /// Gets or sets a [PdfFont] that defines the text format.
  late PdfFont font;

  /// Gets or sets a [PdfPen] that determines the color, width,
  /// and style of the text
  PdfPen? pen;

  /// Gets or sets the [PdfBrush] that will be used to draw the text with color
  /// and texture.
  PdfBrush? brush;

  /// Gets or sets the [PdfStringFormat] that will be used to
  /// set the string format
  PdfStringFormat? stringFormat;
  late bool _isPdfTextElement;

  //Implementation
  void _initialize(String text, PdfFont? font, PdfPen? pen, PdfBrush? brush,
      PdfStringFormat? format) {
    this.text = text;
    if (font != null) {
      this.font = font;
    } else {
      this.font = PdfStandardFont(PdfFontFamily.helvetica, 8);
    }
    if (brush != null) {
      this.brush = brush;
    }
    if (pen != null) {
      this.pen = pen;
    }
    if (format != null) {
      stringFormat = format;
    }
    _isPdfTextElement = false;
  }

  PdfBrush _obtainBrush() {
    return (brush == null) ? PdfSolidBrush(PdfColor(0, 0, 0)) : brush!;
  }

  @override
  PdfLayoutResult? _layout(_PdfLayoutParams param) {
    final _TextLayouter layouter = _TextLayouter(this);
    final PdfLayoutResult? result = layouter._layout(param);
    return (result != null && result is PdfTextLayoutResult) ? result : null;
  }

  @override
  void _drawInternal(PdfGraphics graphics, _Rectangle bounds) {
    graphics.drawString(text, font,
        pen: pen,
        brush: _obtainBrush(),
        bounds: bounds.rect,
        format: stringFormat);
  }
}
