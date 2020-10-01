part of pdf;

/// Represents the Uri annotation.
class PdfUriAnnotation extends PdfActionLinkAnnotation {
  // constructor
  /// Initializes a new instance of the
  /// [PdfUriAnnotation] class with specified bounds and Uri.
  PdfUriAnnotation({Rect bounds, String uri}) : super(bounds) {
    ArgumentError.checkNotNull(uri, 'uri');
    _uriAction ??= PdfUriAction();
    this.uri = uri;
  }

  PdfUriAnnotation._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, String text)
      : super._(dictionary, crossTable) {
    super.text = text;
  }

  // fields
  String _uri = '';
  PdfUriAction _uriAction;

  // properties
  /// Gets the Uri address.
  String get uri {
    if (_isLoadedAnnotation) {
      return _getUriText();
    } else {
      return _uri;
    }
  }

  /// Sets the Uri address.
  set uri(String value) {
    ArgumentError.checkNotNull(value, 'uri');
    if (_isLoadedAnnotation) {
      if (_uri != value) {
        _uri = value;
        if (_dictionary.containsKey(_DictionaryProperties.a)) {
          final _PdfDictionary dictionary =
              _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.a]);
          if (dictionary != null) {
            dictionary._setString(_DictionaryProperties.uri, _uri);
          }
          dictionary.modify();
        }
      }
    } else {
      _uri = value;
      if (_uriAction.uri != value) {
        _uriAction.uri = value;
        if (_isLoadedAnnotation) {
          _PdfDictionary dictionary = _dictionary;
          if (_dictionary.containsKey(_DictionaryProperties.a)) {
            dictionary = _PdfCrossTable._dereference(
                _dictionary[_DictionaryProperties.a]) as _PdfDictionary;
            if (dictionary != null) {
              dictionary._setString(_DictionaryProperties.uri, _uri);
            }
            _dictionary.modify();
          }
        }
      }
    }
  }

  @override

  /// Gets the action.
  PdfAction get action => super.action;

  /// Sets the action.
  @override
  set action(PdfAction value) {
    super.action = value;
    _uriAction.next = value;
  }

  // implementation
  @override
  void _initialize() {
    super._initialize();
    _uriAction ??= PdfUriAction();
    _dictionary.setProperty(_PdfName(_DictionaryProperties.subtype),
        _PdfName(_DictionaryProperties.link));
    _dictionary.setProperty(_PdfName(_DictionaryProperties.a),
        _uriAction._element ??= _uriAction._dictionary);
  }

  String _getUriText() {
    String uriText = '';
    if (_dictionary.containsKey(_DictionaryProperties.a)) {
      final _PdfDictionary dictionary =
          _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.a])
              as _PdfDictionary;
      if (dictionary != null &&
          dictionary.containsKey(_DictionaryProperties.uri)) {
        final _PdfString text =
            _PdfCrossTable._dereference(dictionary[_DictionaryProperties.uri])
                as _PdfString;
        if (text != null) {
          uriText = text.value;
        }
      }
    }
    return uriText;
  }

  @override
  _IPdfPrimitive _element;
}
