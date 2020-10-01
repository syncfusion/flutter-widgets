part of pdf;

/// Represents base class for link annotations with associated action.
abstract class PdfActionLinkAnnotation extends PdfLinkAnnotation {
  // constructor
  /// Initializes a new instance of the [PdfActionLinkAnnotation]
  ///  class with specified bounds and action to be performed.
  PdfActionLinkAnnotation(Rect bounds, [PdfAction action]) : super(bounds) {
    if (action != null) {
      this.action = action;
    }
  }

  PdfActionLinkAnnotation._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._(dictionary, crossTable);

  // fields
  PdfAction _action;

  // properties
  /// Gets the action for the link annotation.
  PdfAction get action => _action;

  /// Sets the action for the link annotation.
  set action(PdfAction value) {
    ArgumentError.checkNotNull(value, 'action');
    _action = value;
  }
}
