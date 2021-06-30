part of pdf;

/// Represents bullet for the list.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new unordered list.
/// PdfUnorderedList uList = PdfUnorderedList(
///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     marker: //Create an unordered marker.
///         PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.disk))
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfUnorderedMarker extends PdfMarker {
  //Constructor
  /// Initializes a new instance of the [PdfUnorderedMarker] class
  /// with Pdf unordered marker style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new unordered list.
  /// PdfUnorderedList uList = PdfUnorderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: //Create an unordered marker.
  ///         PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.disk))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfUnorderedMarker(
      {this.style = PdfUnorderedMarkerStyle.none,
      PdfFont? font,
      String? text,
      PdfTemplate? template}) {
    if (font != null) {
      this.font = font;
    }
    if (text != null) {
      this.text = text;
      style = PdfUnorderedMarkerStyle.customString;
    } else if (template != null) {
      _template = template;
      style = PdfUnorderedMarkerStyle.customTemplate;
    }
  }

  //Fields
  /// Gets and sets the marker style.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new unordered list.
  /// PdfUnorderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.disk))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfUnorderedMarkerStyle style = PdfUnorderedMarkerStyle.none;

  /// Holds the marker text.
  String? _text;

  // /// Holds the marker image.
  // PdfImage _image;

  /// Marker temlapte.
  PdfTemplate? _template;

  /// Marker size.
  _Size? _size;

  /// Font used when draws styled marker
  late PdfFont _unicodeFont;

  //Properties
  /// Gets or sets template of the marker.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new unordered list.
  /// PdfUnorderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: PdfUnorderedMarker(template: (PdfTemplate(100, 100)
  ///         ..graphics!.drawRectangle(
  ///             brush: PdfBrushes.red,
  ///             bounds: const Rect.fromLTWH(0, 0, 100, 100)))))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfTemplate? get template => _template;
  set template(PdfTemplate? value) {
    if (value != null) {
      _template = value;
      style = PdfUnorderedMarkerStyle.customTemplate;
    }
  }

  /// Gets marker text.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new unordered list.
  /// PdfUnorderedList(
  ///     items: PdfListItemCollection(['Essential tools', 'Essential grid']),
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     marker: PdfUnorderedMarker(text: 'Text'))
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String? get text => _text;
  set text(String? value) {
    if (value != null) {
      _text = value;
      style = PdfUnorderedMarkerStyle.customString;
    }
  }

  //Implementation
  /// Draws the specified graphics.
  void _draw(PdfGraphics? graphics, Offset point, PdfBrush? brush, PdfPen? pen,
      [PdfList? curList]) {
    final PdfTemplate templete = PdfTemplate(_size!.width, _size!.height);
    Offset offset = Offset(point.dx, point.dy);
    switch (style) {
      case PdfUnorderedMarkerStyle.customTemplate:
        templete.graphics!
            .drawPdfTemplate(_template!, const Offset(0, 0), _size!.size);
        offset = Offset(
            point.dx,
            point.dy +
                ((curList!.font!.height > font!.height
                        ? curList.font!.height
                        : font!.height) /
                    2) -
                (_size!.height / 2));
        break;
      case PdfUnorderedMarkerStyle.customImage:
        //  templete.graphics.drawImage(
        //      _image, 1, 1, _size.width - 2, _size.height - 2);
        break;
      default:
        final _Point location = _Point.empty;
        if (pen != null) {
          location.x = location.x + pen.width;
          location.y = location.y + pen.width;
        }
        templete.graphics!.drawString(_getStyledText(), _unicodeFont,
            pen: pen,
            brush: brush,
            bounds: Rect.fromLTWH(location.x, location.y, 0, 0));
        break;
    }
    graphics!.drawPdfTemplate(templete, offset);
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
