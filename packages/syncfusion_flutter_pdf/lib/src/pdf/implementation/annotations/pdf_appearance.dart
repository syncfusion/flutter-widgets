part of pdf;

/// Represents the appearance of an annotation.
class PdfAppearance implements _IPdfWrapper {
  // Constructor
  /// Initializes a new instance of the [PdfAppearance] class.
  PdfAppearance(PdfAnnotation annotation) : super() {
    _annotation = annotation;
  }

  // Fields
  PdfTemplate _templateNormal;
  PdfAnnotation _annotation;
  final _PdfDictionary _dictionary = _PdfDictionary();

  // Properties
  /// Gets PdfTmplate object which applied to annotation in normal state.
  PdfTemplate get normal {
    if (_templateNormal == null) {
      _templateNormal = PdfTemplate(
          _annotation.bounds.size.width, _annotation.bounds.size.height);
      _dictionary.setProperty(
          _DictionaryProperties.n, _PdfReferenceHolder(_templateNormal));
    }
    return _templateNormal;
  }

  /// Sets PdfTmplate object which applied to annotation in normal state.
  set normal(PdfTemplate value) {
    ArgumentError.checkNotNull(value);

    if (_templateNormal != value) {
      _templateNormal = value;
      _dictionary.setProperty(
          _DictionaryProperties.n, _PdfReferenceHolder(_templateNormal));
    }
  }

  // Implementation
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  set _element(_IPdfPrimitive value) {
    _element = value;
  }
}
