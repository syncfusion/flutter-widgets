part of pdf;

/// Represents class which can concatenate multiple
/// automatic fields into single string.
class PdfCompositeField extends _PdfMultipleValueField {
  // constructor
  /// Initializes the new instance of the [PdfCompositeField] class.
  ///
  /// [font] - Specifies the [PdfFont] to use.
  /// [brush] - Specifies the color and texture to the text.
  /// [text] - The wide-chracter string to be drawn.
  /// [fields] - The list of [PdfAutomaticField] objects.
  PdfCompositeField(
      {PdfFont font,
      PdfBrush brush,
      String text,
      List<PdfAutomaticField> fields})
      : super(font: font, brush: brush) {
    this.text = (text == null) ? '' : text;
    this.fields = fields;
  }

  // field
  /// Internal variable to store list of automatic fields.
  List<PdfAutomaticField> _fields;
  String _text = '';

  // properties
  /// Get the text for user format to display the page details
  /// (eg. Input text:page {0} of {1} as dispalyed to page 1 of 5)
  String get text => _text;

  /// Set the text for user format to display the page details
  /// (eg. Input text:page {0} of {1} as dispalyed to page 1 of 5)
  set text(String value) {
    ArgumentError.checkNotNull(value, 'text');
    _text = value;
  }

  /// Gets the automatic fields(like page number, page count and etc.,)
  List<PdfAutomaticField> get fields {
    _fields ??= <PdfAutomaticField>[];
    return _fields;
  }

  /// Sets the automatic fields(like page number, page count and etc.,)
  set fields(List<PdfAutomaticField> value) {
    if (value != null) {
      _fields = value;
    }
  }

  // implementation
  @override
  String _getValue(PdfGraphics graphics) {
    String _copyText;
    if (fields != null && fields.isNotEmpty) {
      _copyText = _text;
      for (int i = 0; i < fields.length; i++) {
        _copyText = _copyText.replaceAll('{$i}', fields[i]._getValue(graphics));
      }
    }
    return (_copyText == null) ? _text : _copyText;
  }
}
