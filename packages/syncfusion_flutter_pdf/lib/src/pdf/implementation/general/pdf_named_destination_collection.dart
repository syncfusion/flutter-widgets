part of pdf;

/// Implements a collection of named destinations in the document.
class PdfNamedDestinationCollection implements _IPdfWrapper {
  /// Initializes a new instance of the [PdfNamedDestinationCollection] class.
  PdfNamedDestinationCollection() : super() {
    _initialize();
  }

  PdfNamedDestinationCollection._(
      _PdfDictionary? dictionary, _PdfCrossTable? crossTable) {
    _dictionary = dictionary;
    if (crossTable != null) {
      _crossTable = crossTable;
    }
    if (_dictionary != null &&
        _dictionary!.containsKey(_DictionaryProperties.dests)) {
      final _PdfDictionary? destination =
          _PdfCrossTable._dereference(_dictionary![_DictionaryProperties.dests])
              as _PdfDictionary?;
      if (destination != null &&
          destination.containsKey(_DictionaryProperties.names)) {
        _addCollection(destination);
      } else if (destination != null &&
          destination.containsKey(_DictionaryProperties.kids)) {
        final _PdfArray? kids =
            _PdfCrossTable._dereference(destination[_DictionaryProperties.kids])
                as _PdfArray?;
        if (kids != null) {
          for (int i = 0; i < kids.count; i++) {
            _findDestination(
                _PdfCrossTable._dereference(kids[i]) as _PdfDictionary?);
          }
        }
      }
    }
    _crossTable._document!._catalog._beginSave =
        (Object sender, _SavePdfPrimitiveArgs? ars) {
      for (final PdfNamedDestination values in _namedCollections) {
        _namedDestination._add(_PdfString(values.title));
        _namedDestination._add(_PdfReferenceHolder(values));
      }
      _dictionary!.setProperty(
          _DictionaryProperties.names, _PdfReferenceHolder(_namedDestination));

      if (_dictionary!.containsKey(_DictionaryProperties.dests)) {
        final _PdfDictionary? destsDictionary = _PdfCrossTable._dereference(
            _dictionary![_DictionaryProperties.dests]) as _PdfDictionary?;
        if (destsDictionary != null &&
            !destsDictionary.containsKey(_DictionaryProperties.kids)) {
          destsDictionary.setProperty(_DictionaryProperties.names,
              _PdfReferenceHolder(_namedDestination));
        }
      } else {
        _dictionary!.setProperty(_DictionaryProperties.names,
            _PdfReferenceHolder(_namedDestination));
      }
    };
    _crossTable._document!._catalog.modify();
  }

  /// Collection of the named destinations.
  final List<PdfNamedDestination> _namedCollections = <PdfNamedDestination>[];

  /// Internal variable to store dictinary.
  _PdfDictionary? _dictionary = _PdfDictionary();
  _PdfCrossTable _crossTable = _PdfCrossTable();

  /// Array of the named destinations.
  final _PdfArray _namedDestination = _PdfArray();

  /// Gets number of the elements in the collection.
  int get count => _namedCollections.length;

  /// Gets the [PdfNamedDestination] at the specified index.
  PdfNamedDestination operator [](int index) {
    if (index < 0 || index > count - 1) {
      throw RangeError('$index, Index is out of range.');
    }
    return _namedCollections[index];
  }

  /// Creates and adds a named destination.
  void add(PdfNamedDestination namedDestination) {
    _namedCollections.add(namedDestination);
  }

  /// Determines whether the specified named destinations
  /// presents in the collection.
  bool contains(PdfNamedDestination namedDestination) {
    return _namedCollections.contains(namedDestination);
  }

  /// Remove the specified named destination from the document.
  void remove(String title) {
    int index = -1;
    for (int i = 0; i < _namedCollections.length; i++) {
      if (_namedCollections[i].title == title) {
        index = i;
        break;
      }
    }
    removeAt(index);
  }

  /// Remove the specified named destination from the document.
  void removeAt(int index) {
    if (index >= _namedCollections.length) {
      throw RangeError(
          'The index value should not be greater than or equal to the count.');
    }
    _namedCollections.removeAt(index);
  }

  /// Removes all the named destination from the collection.
  void clear() {
    _namedCollections.clear();
  }

  /// Inserts a new named destination at the specified index.
  void insert(int index, PdfNamedDestination namedDestination) {
    if (index < 0 || index > count) {
      throw RangeError(
          'The index can\'t be less then zero or greater then Count.');
    }
    _namedCollections.insert(index, namedDestination);
  }

  /// Initializes instance.
  void _initialize() {
    _dictionary!._beginSave = (Object sender, _SavePdfPrimitiveArgs? ars) {
      for (final PdfNamedDestination values in _namedCollections) {
        _namedDestination._add(_PdfString(values.title));
        _namedDestination._add(_PdfReferenceHolder(values));
      }
      _dictionary!.setProperty(
          _DictionaryProperties.names, _PdfReferenceHolder(_namedDestination));
    };
  }

  void _addCollection(_PdfDictionary namedDictionary) {
    final _PdfArray? elements = _PdfCrossTable._dereference(
        namedDictionary[_DictionaryProperties.names]) as _PdfArray?;
    if (elements != null) {
      for (int i = 1; i <= elements.count; i = i + 2) {
        _PdfReferenceHolder? reference;
        if (elements[i] is _PdfReferenceHolder) {
          reference = elements[i] as _PdfReferenceHolder;
        }
        _PdfDictionary? dictionary;
        if (reference != null && reference.object is _PdfArray) {
          dictionary = _PdfDictionary();
          dictionary.setProperty(_DictionaryProperties.d,
              _PdfArray(reference.object as _PdfArray?));
        } else if (reference == null && elements[i] is _PdfArray) {
          dictionary = _PdfDictionary();
          final _PdfArray referenceArray = elements[i] as _PdfArray;
          dictionary.setProperty(
              _DictionaryProperties.d, _PdfArray(referenceArray));
        } else {
          dictionary = reference!.object as _PdfDictionary?;
        }
        if (dictionary != null) {
          final PdfNamedDestination namedDestinations =
              PdfNamedDestination._(dictionary, _crossTable, true);
          final _PdfString? title = elements[i - 1] as _PdfString?;
          if (title != null) {
            namedDestinations.title = title.value!;
          }
          _namedCollections.add(namedDestinations);
        }
      }
    }
  }

  void _findDestination(_PdfDictionary? destination) {
    if (destination != null &&
        destination.containsKey(_DictionaryProperties.names)) {
      _addCollection(destination);
    } else if (destination != null &&
        destination.containsKey(_DictionaryProperties.kids)) {
      final _PdfArray? kids =
          _PdfCrossTable._dereference(destination[_DictionaryProperties.kids])
              as _PdfArray?;
      if (kids != null) {
        for (int i = 0; i < kids.count; i++) {
          _findDestination(
              _PdfCrossTable._dereference(kids[i]) as _PdfDictionary?);
        }
      }
    }
  }

  /// Gets the element.
  @override
  _IPdfPrimitive? get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError();
  }
}
