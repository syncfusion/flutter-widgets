part of pdf;

/// Represents bullet for the list.
class PdfUnorderedMarker extends PdfMarker {
  /// Initializes a new instance of the [PdfUnorderedMarker] class
  /// with Pdf unordered marker style.
  PdfUnorderedMarker(
      {this.style, PdfFont font, String text, PdfTemplate template}) {
    this.font = font;
    if (text != null) {
      this.text = text;
      style = PdfUnorderedMarkerStyle.customString;
    } else if (template != null) {
      _template = template;
      style = PdfUnorderedMarkerStyle.customTemplate;
    }
  }

  /// Holds the marker text.
  String _text;

  /// Gets and sets the marker style.
  PdfUnorderedMarkerStyle style = PdfUnorderedMarkerStyle.none;

  // /// Holds the marker image.
  // PdfImage _image;

  /// Marker temlapte.
  PdfTemplate _template;

  /// Marker size.
  _Size _size;

  /// Font used when draws styled marker
  PdfFont _unicodeFont;

  /// Gets template of the marker.
  PdfTemplate get template => _template;

  /// Sets template of the marker.
  set template(PdfTemplate value) {
    ArgumentError.checkNotNull(value, 'template');
    _template = value;
    style = PdfUnorderedMarkerStyle.customTemplate;
  }

  /// Gets marker text.
  String get text => _text;

  ///Sets marker text.
  set text(String value) {
    if (value == null) {
      throw ArgumentError('text');
    }
    _text = value;
    style = PdfUnorderedMarkerStyle.customString;
  }

  /// Draws the specified graphics.
  void _draw(PdfGraphics graphics, Offset point, PdfBrush brush, PdfPen pen,
      [PdfList curList]) {
    final PdfTemplate templete = PdfTemplate(_size.width, _size.height);
    Offset offset = Offset(point.dx, point.dy);
    switch (style) {
      case PdfUnorderedMarkerStyle.customTemplate:
        templete.graphics
            .drawPdfTemplate(_template, const Offset(0, 0), _size.size);
        offset = Offset(
            point.dx,
            point.dy +
                ((curList.font.height > font.height
                        ? curList.font.height
                        : font.height) /
                    2) -
                (_size.height / 2));
        break;
      case PdfUnorderedMarkerStyle.customImage:
        //  templete.graphics.drawImage(
        //      _image, 1, 1, _size.width - 2, _size.height - 2);
        break;
      default:
        final _Point location = _Point.empty;
        if (pen != null) {
          location.x += pen.width;
          location.y += pen.width;
        }
        templete.graphics.drawString(_getStyledText(), _unicodeFont,
            pen: pen,
            brush: brush,
            bounds: Rect.fromLTWH(location.x, location.y, 0, 0));
        break;
    }
    graphics.drawPdfTemplate(templete, offset);
  }

  /// Gets the styled text.
  String _getStyledText() {
    String text = '';
    switch (style) {
      case PdfUnorderedMarkerStyle.disk:
        text = '\x6C';
        break;
      case PdfUnorderedMarkerStyle.square:
        text = '\x6E';
        break;
      case PdfUnorderedMarkerStyle.asterisk:
        text = '\x5D';
        break;
      case PdfUnorderedMarkerStyle.circle:
        text = '\x6D';
        break;
      default:
        break;
    }
    return text;
  }
}
