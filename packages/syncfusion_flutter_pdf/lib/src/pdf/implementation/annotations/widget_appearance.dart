part of pdf;

/// The Syncfusion.Pdf.Interactive namespace contains classes used to create interactive elements.
class _WidgetAppearance implements _IPdfWrapper {
  //Constructors
  _WidgetAppearance() : super() {
    _dictionary.setProperty(
        _DictionaryProperties.bc, _borderColor._toArray(PdfColorSpace.rgb));
    _dictionary.setProperty(
        _DictionaryProperties.bg, _backColor._toArray(PdfColorSpace.rgb));
  }

  //Fields
  final _PdfDictionary _dictionary = _PdfDictionary();
  PdfColor _borderColor = PdfColor(0, 0, 0);
  PdfColor _backColor = PdfColor(255, 255, 255);
  String? _normalCaption = '';

  //Properties
  /// Gets or sets the color of the border.
  PdfColor get borderColor => _borderColor;
  set borderColor(PdfColor value) {
    if (_borderColor != value) {
      _borderColor = value;
      value._alpha == 0
          ? _dictionary.setProperty(
              _DictionaryProperties.bc, _PdfArray(<int>[]))
          : _dictionary.setProperty(_DictionaryProperties.bc,
              _borderColor._toArray(PdfColorSpace.rgb));
    }
  }

  /// Gets or sets the color of the background.
  PdfColor get backColor => _backColor;
  set backColor(PdfColor value) {
    if (_backColor != value) {
      _backColor = value;
      if (_backColor._alpha == 0) {
        _dictionary.setProperty(
            _DictionaryProperties.bc, _PdfArray(<int>[0, 0, 0]));
        _dictionary.remove(_DictionaryProperties.bg);
      } else {
        _dictionary.setProperty(
            _DictionaryProperties.bg, _backColor._toArray(PdfColorSpace.rgb));
      }
    }
  }

  String? get normalCaption => _normalCaption;
  set normalCaption(String? value) {
    if (_normalCaption != value) {
      _normalCaption = value;
      _dictionary._setString(_DictionaryProperties.ca, _normalCaption);
    }
  }

  //Overrides
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError('Primitive element can\'t be set');
  }
}
