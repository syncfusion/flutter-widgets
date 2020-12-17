part of pdf;

///	A class containing the information about the document.
class PdfDocumentInformation extends _IPdfWrapper {
  //Constructor
  PdfDocumentInformation._(_PdfCatalog catalog,
      {_PdfDictionary dictionary,
      bool isLoaded = false,
      PdfConformanceLevel conformance}) {
    ArgumentError.checkNotNull(catalog, 'catalog');
    _catalog = catalog;
    if (conformance != null) {
      _conformance = conformance;
    }
    if (isLoaded) {
      ArgumentError.checkNotNull(dictionary, 'dictionary');
      _dictionary = dictionary;
    } else {
      _dictionary = _PdfDictionary();
      if (_conformance != PdfConformanceLevel.a1b) {
        _dictionary._setDateTime(
            _DictionaryProperties.creationDate, _creationDate);
      }
    }
  }

  //Fields
  _PdfDictionary _dictionary;
  _PdfCatalog _catalog;
  DateTime _creationDate = DateTime.now();
  DateTime _modificationDate = DateTime.now();
  String _title;
  String _author;
  String _subject;
  String _keywords;
  String _creator;
  String _producer;
  _XmpMetadata _xmp;
  bool _isRemoveModifyDate = false;
  PdfConformanceLevel _conformance;

  //Properties
  /// Gets the creation date of the PDF document
  DateTime get creationDate {
    if (_dictionary.containsKey(_DictionaryProperties.creationDate) &&
        _dictionary[_DictionaryProperties.creationDate] is _PdfString) {
      return _creationDate = _dictionary
          ._getDateTime(_dictionary[_DictionaryProperties.creationDate]);
    }
    return _creationDate = DateTime.now();
  }

  /// Sets the creation date of the PDF document
  set creationDate(DateTime value) {
    if (_creationDate != value) {
      _creationDate = value;
      _dictionary._setDateTime(
          _DictionaryProperties.creationDate, _creationDate);
    }
  }

  /// Gets the modification date of the PDF document
  DateTime get modificationDate {
    if (_dictionary.containsKey(_DictionaryProperties.modificationDate) &&
        _dictionary[_DictionaryProperties.modificationDate] is _PdfString) {
      return _modificationDate = _dictionary
          ._getDateTime(_dictionary[_DictionaryProperties.modificationDate]);
    }
    return _modificationDate = DateTime.now();
  }

  /// Sets the modification date of the PDF document
  set modificationDate(DateTime value) {
    _modificationDate = value;
    _dictionary._setDateTime(
        _DictionaryProperties.modificationDate, _modificationDate);
  }

  /// Gets the title.
  String get title {
    if (_dictionary.containsKey(_DictionaryProperties.title) &&
        _dictionary[_DictionaryProperties.title] is _PdfString) {
      return _title = (_dictionary[_DictionaryProperties.title] as _PdfString)
          .value
          .replaceAll('\u0000', '');
    }
    return _title = '';
  }

  /// Sets the title.
  set title(String value) {
    if (_title != value) {
      _title = value;
      _dictionary._setString(_DictionaryProperties.title, _title);
    }
  }

  /// Gets the author.
  String get author {
    if (_dictionary.containsKey(_DictionaryProperties.author) &&
        _dictionary[_DictionaryProperties.author] is _PdfString) {
      return _author =
          (_dictionary[_DictionaryProperties.author] as _PdfString).value;
    }
    return _author = '';
  }

  /// Sets the author.
  set author(String value) {
    if (_author != value) {
      _author = value;
      _dictionary._setString(_DictionaryProperties.author, _author);
    }
  }

  /// Gets the subject.
  String get subject {
    if (_dictionary.containsKey(_DictionaryProperties.subject) &&
        _dictionary[_DictionaryProperties.subject] is _PdfString) {
      return _subject =
          (_dictionary[_DictionaryProperties.subject] as _PdfString).value;
    }
    return _subject = '';
  }

  /// Sets the subject.
  set subject(String value) {
    if (_subject != value) {
      _subject = value;
      _dictionary._setString(_DictionaryProperties.subject, _subject);
    }
  }

  /// Gets the keywords.
  String get keywords {
    if (_dictionary.containsKey(_DictionaryProperties.keywords) &&
        _dictionary[_DictionaryProperties.keywords] is _PdfString) {
      return _keywords =
          (_dictionary[_DictionaryProperties.keywords] as _PdfString).value;
    }
    return _keywords = '';
  }

  /// Sets the keywords.
  set keywords(String value) {
    if (_keywords != value) {
      _keywords = value;
      _dictionary._setString(_DictionaryProperties.keywords, _keywords);
    }
    if (_catalog != null && _catalog._metadata != null) {
      _xmp = _xmpMetadata;
    }
  }

  /// Gets the creator.
  String get creator {
    if (_dictionary.containsKey(_DictionaryProperties.creator) &&
        _dictionary[_DictionaryProperties.creator] is _PdfString) {
      return _creator =
          (_dictionary[_DictionaryProperties.creator] as _PdfString).value;
    }
    return _creator = '';
  }

  /// Sets the creator.
  set creator(String value) {
    if (_creator != value) {
      _creator = value;
      _dictionary._setString(_DictionaryProperties.creator, _creator);
    }
  }

  /// Gets the producer.
  String get producer {
    if (_dictionary.containsKey(_DictionaryProperties.producer) &&
        _dictionary[_DictionaryProperties.producer] is _PdfString) {
      return _producer =
          (_dictionary[_DictionaryProperties.producer] as _PdfString).value;
    }
    return _producer = '';
  }

  /// Sets the producer.
  set producer(String value) {
    if (_producer != value) {
      _producer = value;
      _dictionary._setString(_DictionaryProperties.producer, _producer);
    }
  }

  /// Gets Xmp metadata of the document.
  ///
  /// Represents the document information in Xmp format.
  _XmpMetadata get _xmpMetadata {
    if (_xmp == null) {
      if (_catalog._metadata == null && _catalog._pages != null) {
        _xmp = _XmpMetadata(_catalog._pages._document.documentInformation);
        _catalog.setProperty(
            _DictionaryProperties.metadata, _PdfReferenceHolder(_xmp));
      } else {
        if (_dictionary.changed && !_catalog.changed) {
          _xmp = _XmpMetadata(_catalog._document.documentInformation);
          _catalog.setProperty(
              _DictionaryProperties.metadata, _PdfReferenceHolder(_xmp));
        } else {
          _xmp = _catalog._metadata;
          _catalog.setProperty(
              _DictionaryProperties.metadata, _PdfReferenceHolder(_xmp));
        }
      }
    } else if (_catalog._metadata != null && _catalog._document != null) {
      if (_dictionary.changed && !_catalog.changed) {
        _xmp = _XmpMetadata(_catalog._document.documentInformation);
        _catalog.setProperty(
            _DictionaryProperties.metadata, _PdfReferenceHolder(_xmp));
      }
    }
    return _xmp;
  }

  /// Remove the modification date from existing document.
  void removeModificationDate() {
    if (_dictionary != null &&
        _dictionary.containsKey(_DictionaryProperties.modificationDate)) {
      _dictionary.remove(_DictionaryProperties.modificationDate);
      if (_dictionary.changed && !_catalog.changed) {
        _catalog._document.documentInformation._dictionary
            .remove(_DictionaryProperties.modificationDate);
        _catalog._document.documentInformation._isRemoveModifyDate = true;
        _xmp = _XmpMetadata(_catalog._document.documentInformation);
        _catalog.setProperty(
            _DictionaryProperties.metadata, _PdfReferenceHolder(_xmp));
      }
    }
  }

  //Overrides
  @override
  _IPdfPrimitive get _element => _dictionary;
}
