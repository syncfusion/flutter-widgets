part of pdf;

/// Represents the annotation with associated action.
class PdfActionAnnotation extends PdfActionLinkAnnotation {
  // constructor
  /// Initializes a new instance of the
  /// [PdfActionAnnotation] class with specified bounds and action.
  PdfActionAnnotation(Rect bounds, PdfAction action) : super(bounds, action);

  // implementation

  @override
  void _save() {
    super._save();
    _dictionary.setProperty(_PdfName(_DictionaryProperties.a), action._element);
  }

  @override
  _IPdfPrimitive _element;
}
