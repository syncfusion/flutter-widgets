part of pdf;

/// Represents the base class for the link annotations.
abstract class PdfLinkAnnotation extends PdfAnnotation {
  // constructor
  /// Initializes new instance of
  /// [PdfLinkAnnotation] class with specified bounds.
  PdfLinkAnnotation([Rect bounds]) : super._(bounds: bounds);

  PdfLinkAnnotation._(_PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._internal(dictionary, crossTable);

  // fields
  PdfHighlightMode _highlightMode = PdfHighlightMode.noHighlighting;

  //properties
  /// Gets the highlight mode of the link annotation.
  PdfHighlightMode get highlightMode =>
      _isLoadedAnnotation ? _obtainHighlightMode() : _highlightMode;

  /// Sets the highlight mode of the link annotation.
  set highlightMode(PdfHighlightMode value) {
    _highlightMode = value;
    final String mode = _getHighlightMode(_highlightMode);
    _dictionary.._setName(_PdfName(_DictionaryProperties.h), mode);
  }

  // implementation
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(_PdfName(_DictionaryProperties.subtype),
        _PdfName(_DictionaryProperties.link));
  }

  String _getHighlightMode(PdfHighlightMode mode) {
    String hightlightMode;
    switch (mode) {
      case PdfHighlightMode.invert:
        hightlightMode = 'I';
        break;
      case PdfHighlightMode.noHighlighting:
        hightlightMode = 'N';
        break;
      case PdfHighlightMode.outline:
        hightlightMode = 'O';
        break;
      case PdfHighlightMode.push:
        hightlightMode = 'P';
        break;
    }
    return hightlightMode;
  }

  PdfHighlightMode _obtainHighlightMode() {
    PdfHighlightMode mode = PdfHighlightMode.noHighlighting;
    if (_dictionary.containsKey(_DictionaryProperties.h)) {
      final _PdfName name = _dictionary[_DictionaryProperties.h];
      switch (name._name) {
        case 'I':
          mode = PdfHighlightMode.invert;
          break;
        case 'N':
          mode = PdfHighlightMode.noHighlighting;
          break;
        case 'O':
          mode = PdfHighlightMode.outline;
          break;
        case 'P':
          mode = PdfHighlightMode.push;
          break;
      }
    }
    return mode;
  }
}
