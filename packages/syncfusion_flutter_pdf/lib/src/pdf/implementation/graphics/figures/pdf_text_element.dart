import '../../drawing/drawing.dart';
import '../brushes/pdf_solid_brush.dart';
import '../fonts/enums.dart';
import '../fonts/pdf_font.dart';
import '../fonts/pdf_standard_font.dart';
import '../fonts/pdf_string_format.dart';
import '../pdf_color.dart';
import '../pdf_graphics.dart';
import '../pdf_pen.dart';
import 'base/element_layouter.dart';
import 'base/layout_element.dart';
import 'base/text_layouter.dart';

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
    _helper = PdfTextElementHelper(this);
    _initialize(text, font, pen, brush, format);
  }

  //Fields
  late PdfTextElementHelper _helper;

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
    _helper.isPdfTextElement = false;
  }
}

/// [PdfTextElement] helper
class PdfTextElementHelper {
  /// internal constructor
  PdfTextElementHelper(this.base);

  /// internal field
  PdfTextElement base;

  /// internal field
  late bool isPdfTextElement;

  /// internal method
  static PdfTextElementHelper getHelper(PdfTextElement base) {
    return base._helper;
  }

  /// internal method
  PdfBrush obtainBrush() {
    return (base.brush == null)
        ? PdfSolidBrush(PdfColor(0, 0, 0))
        : base.brush!;
  }

  /// internal method
  PdfLayoutResult? layout(PdfLayoutParams param) {
    final TextLayouter layouter = TextLayouter(base);
    final PdfLayoutResult? result = layouter.layout(param);
    return (result != null && result is PdfTextLayoutResult) ? result : null;
  }

  /// internal method
  void drawInternal(PdfGraphics graphics, PdfRectangle bounds) {
    graphics.drawString(base.text, base.font,
        pen: base.pen,
        brush: obtainBrush(),
        bounds: bounds.rect,
        format: base.stringFormat);
  }
}
