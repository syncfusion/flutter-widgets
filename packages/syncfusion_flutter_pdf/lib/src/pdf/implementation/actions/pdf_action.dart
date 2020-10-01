part of pdf;

/// Represents base class for all action types.
class PdfAction implements _IPdfWrapper {
  // constructor
  PdfAction._() : super() {
    _initialize();
  }
  // fields
  PdfAction _action;
  final _PdfDictionary _dictionary = _PdfDictionary();

  // properties
  /// Gets the next action
  /// to be performed after the action represented by this instance.
  PdfAction get next => _action;

  /// Sets the next action
  /// to be performed after the action represented by this instance.
  set next(PdfAction value) {
    ArgumentError.checkNotNull(value, 'next');
    if (_action != value) {
      _action = value;
      _dictionary._setArray(_DictionaryProperties.next,
          <_IPdfPrimitive>[_PdfReferenceHolder(_action)]);
    }
  }

  // implementation
  void _initialize() {
    _dictionary.setProperty(_PdfName(_DictionaryProperties.type),
        _PdfName(_DictionaryProperties.action));
    _element = _dictionary;
  }

  @override
  _IPdfPrimitive _element;
}
