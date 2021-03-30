part of pdf;

/// Represents the appearance of an annotation.
class PdfAppearance implements _IPdfWrapper {
  // Constructor
  /// Initializes a instance of the [PdfAppearance] class.
  PdfAppearance(PdfAnnotation annotation) : super() {
    _annotation = annotation;
  }

  // Fields
  PdfTemplate? _templateNormal;
  late PdfAnnotation _annotation;
  final _PdfDictionary _dictionary = _PdfDictionary();
  PdfTemplate? _templatePressed;

  // Properties
  /// Gets PdfTmplate object which applied to annotation in normal state.
  PdfTemplate get normal {
    if (_templateNormal == null) {
      _templateNormal = PdfTemplate(
          _annotation.bounds.size.width, _annotation.bounds.size.height);
      _dictionary.setProperty(
          _DictionaryProperties.n, _PdfReferenceHolder(_templateNormal));
    }
    return _templateNormal!;
  }

  /// Sets PdfTmplate object which applied to annotation in normal state.
  set normal(PdfTemplate value) {
    if (_templateNormal != value) {
      _templateNormal = value;
      _dictionary.setProperty(
          _DictionaryProperties.n, _PdfReferenceHolder(_templateNormal));
    }
  }

  /// Gets or sets [PdfTemplate] object which applied to an annotation when mouse button is pressed.
  PdfTemplate get pressed {
    if (_templatePressed == null) {
      _templatePressed =
          PdfTemplate(_annotation.bounds.width, _annotation.bounds.height);
      _dictionary.setProperty(
          _DictionaryProperties.d, _PdfReferenceHolder(_templatePressed));
    }
    return _templatePressed!;
  }

  set pressed(PdfTemplate value) {
    if (value != _templatePressed) {
      _templatePressed = value;
      _dictionary.setProperty(
          _DictionaryProperties.d, _PdfReferenceHolder(_templatePressed));
    }
  }

  // Implementation
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _element = value;
  }
}
