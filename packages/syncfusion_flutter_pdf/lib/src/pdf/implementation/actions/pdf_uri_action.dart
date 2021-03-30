part of pdf;

/// Represents an action which resolves unique resource identifier.
class PdfUriAction extends PdfAction {
  // constructor
  /// Initializes a new instance of the [PdfUriAction] class.
  ///
  /// [uri] - the unique resource identifier.
  PdfUriAction([String? uri]) : super._() {
    if (uri != null) {
      this.uri = uri;
    }
    _initialize();
  }

  // fields
  String _uri = '';

  // proporties
  /// Gets the unique resource identifier.
  String get uri => _uri;

  /// Sets the unique resource identifier.
  set uri(String value) {
    _uri = value;
    _dictionary._setString(_DictionaryProperties.uri, _uri);
  }

  // implementation
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(
        _PdfName(_DictionaryProperties.s), _PdfName(_DictionaryProperties.uri));
  }
}
