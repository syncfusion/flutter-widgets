part of pdf;

/// Represents extended appearance of the annotation. It has two states such as On state and Off state.
class _PdfExtendedAppearance implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfExtendedAppearance] class.
  _PdfExtendedAppearance() : super();

  //Fields
  _PdfAppearanceState? _normal;
  _PdfAppearanceState? _pressed;
  _PdfAppearanceState? _mouseHover;
  final _PdfDictionary _dictionary = _PdfDictionary();

  //Properties
  /// Gets the normal appearance of the annotation.
  _PdfAppearanceState get normal {
    if (_normal == null) {
      _normal = _PdfAppearanceState();
      _dictionary.setProperty(
          _DictionaryProperties.n, _PdfReferenceHolder(_normal));
    }
    return _normal!;
  }

  /// Gets the appearance when mouse is hovered.
  _PdfAppearanceState get mouseHover {
    if (_mouseHover == null) {
      _mouseHover = _PdfAppearanceState();
      _dictionary.setProperty(
          _DictionaryProperties.r, _PdfReferenceHolder(_mouseHover));
    }
    return _mouseHover!;
  }

  /// Gets the pressed state annotation.
  _PdfAppearanceState get pressed {
    if (_pressed == null) {
      _pressed = _PdfAppearanceState();
      _dictionary.setProperty(
          _DictionaryProperties.d, _PdfReferenceHolder(_pressed));
    }
    return _pressed!;
  }

  //Implementation
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _element = value;
  }
}
