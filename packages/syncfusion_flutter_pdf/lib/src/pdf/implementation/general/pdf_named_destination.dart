part of pdf;

/// Represents an named destination which goes to a destination
/// in the current document.
class PdfNamedDestination implements _IPdfWrapper {
  /// Initializes a new instance of the [PdfNamedDestination] class
  /// with the title to be displayed.
  PdfNamedDestination(String title) {
    ArgumentError.checkNotNull(title, 'The title can\'t be null');
    this.title = title;
    _initialize();
  }

  PdfNamedDestination._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable, bool isLoaded)
      : super() {
    _dictionary = dictionary;
    _crossTable = crossTable;
    _isLoaded = isLoaded;
  }

  /// Internal variable to store named destination's destination.
  PdfDestination _destination;

  /// Internal variable to store dictinary.
  _PdfDictionary _dictionary = _PdfDictionary();
  _PdfCrossTable _crossTable = _PdfCrossTable();
  bool _isLoaded = false;

  /// Gets the named destination's destination.
  PdfDestination get destination {
    if (_isLoaded) {
      return _obtainDestination();
    } else {
      return _destination;
    }
  }

  /// Sets the named destination's destination.
  /// The destination property has to be mentioned as multiples of 100.
  /// If we mention as 2, the zoom value will be 200.
  set destination(PdfDestination value) {
    ArgumentError.checkNotNull(value, 'The title can\'t be null');
    if (value != null) {
      _destination = value;
      _dictionary.setProperty(_DictionaryProperties.d, _destination);
    }
  }

  /// Gets the named destination title.
  String get title {
    if (_isLoaded) {
      String title = '';
      if (_dictionary.containsKey(_DictionaryProperties.title)) {
        final _PdfString str = _crossTable
            ._getObject(_dictionary[_DictionaryProperties.title]) as _PdfString;
        title = str.value;
      }
      return title;
    } else {
      final _PdfString title =
          _dictionary[_DictionaryProperties.title] as _PdfString;
      String value;
      if (title != null) {
        value = title.value;
      }
      return value;
    }
  }

  /// Sets the named destination title.
  set title(String value) {
    ArgumentError.checkNotNull(value, 'The title can\'t be null');
    _dictionary[_DictionaryProperties.title] = _PdfString(value);
  }

  /// Initializes instance.
  void _initialize() {
    _dictionary._beginSave = (Object sender, _SavePdfPrimitiveArgs ars) {
      _dictionary.setProperty(_DictionaryProperties.d, _destination);
    };
    _dictionary.setProperty(
        _DictionaryProperties.s, _PdfName(_DictionaryProperties.goTo));
  }

  PdfDestination _obtainDestination() {
    if (_dictionary.containsKey(_DictionaryProperties.d) &&
        (_destination == null)) {
      final _IPdfPrimitive obj =
          _crossTable._getObject(_dictionary[_DictionaryProperties.d]);
      final _PdfArray destination = obj as _PdfArray;
      if (destination != null && destination.count > 1) {
        final _PdfReferenceHolder referenceHolder =
            destination[0] as _PdfReferenceHolder;
        PdfPage page;
        if (referenceHolder != null) {
          final _PdfDictionary dictionary =
              _crossTable._getObject(referenceHolder) as _PdfDictionary;
          if (dictionary != null) {
            page = _crossTable._document.pages._getPage(dictionary);
          }
        }

        final _PdfName mode = destination[1] as _PdfName;
        if (mode != null) {
          if ((mode._name == 'FitBH' || mode._name == 'FitH') &&
              destination.count > 2) {
            final _PdfNumber top = destination[2] as _PdfNumber;
            if (page != null) {
              final double topValue =
                  (top == null) ? 0 : page.size.height - top.value;
              _destination = PdfDestination(page, Offset(0, topValue));
              _destination.mode = PdfDestinationMode.fitH;
            }
          } else if (mode._name == 'XYZ' && destination.count > 3) {
            final _PdfNumber left = destination[2] as _PdfNumber;
            final _PdfNumber top = destination[3] as _PdfNumber;
            _PdfNumber zoom;
            if (destination.count > 4 && destination[4] is _PdfNumber) {
              zoom = destination[4] as _PdfNumber;
            }
            if (page != null) {
              final double topValue =
                  (top == null) ? 0 : page.size.height - top.value;
              final double leftValue = (left == null) ? 0 : left.value;
              _destination = PdfDestination(page, Offset(leftValue, topValue));
              if (zoom != null) {
                _destination.zoom = zoom.value.toDouble();
              }
            }
          } else {
            if (page != null && mode._name == 'Fit') {
              _destination = PdfDestination(page);
              _destination.mode = PdfDestinationMode.fitToPage;
            }
          }
        }
      }
    }
    return _destination;
  }

  /// Gets the element.
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  set _element(_IPdfPrimitive value) {
    throw ArgumentError();
  }
}
