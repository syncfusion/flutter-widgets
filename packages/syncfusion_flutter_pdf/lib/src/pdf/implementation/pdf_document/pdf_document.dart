part of pdf;

/// Represents a PDF document and can be used to create a new PDF document
/// from the scratch.
class PdfDocument {
  //Constructor
  /// Initialize a new instance of the [PdfDocument] class
  /// from the PDF data as list of bytes
  ///
  /// To initialize a new instance of the [PdfDocument] class for an exisitng
  /// PDF document, we can use the optional parameter to load PDF data
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Add a PDF page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     bounds: Rect.fromLTWH(0, 0, 150, 20));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDocument({List<int> inputBytes}) {
    _isLoadedDocument = inputBytes != null;
    _initialize(inputBytes);
  }

  /// Initialize a new instance of the [PdfDocument] class
  /// from the PDF data as base64 string
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData);
  /// //Add a PDF page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     bounds: Rect.fromLTWH(0, 0, 150, 20));
  /// //Save the updated PDF document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDocument.fromBase64String(String base64String) {
    ArgumentError.checkNotNull(base64String);
    if (base64String.isEmpty) {
      ArgumentError.value(base64String, 'PDF data', 'PDF data cannot be null');
    }
    _isLoadedDocument = true;
    _initialize(base64.decode(base64String));
  }
  //Constants
  static const double _defaultMargin = 40;

  //Fields
  _PdfMainObjectCollection _objects;
  _PdfCrossTable _crossTable;
  _PdfCatalog _catalog;
  PdfPageCollection _pages;
  PdfPageSettings _settings;
  PdfSectionCollection _sections;
  PdfFileStructure _fileStructure;
  PdfColorSpace _colorSpace;
  PdfDocumentTemplate _template;
  PdfBookmarkBase _outlines;
  PdfNamedDestinationCollection _namedDestinations;
  bool _isLoadedDocument = false;
  List<int> _data;
  bool _isStreamCopied = false;
  PdfBookmarkBase _bookmark;
  Map<PdfPage, dynamic> _bookmarkHashTable;

  /// Gets or  sets the PDF document compression level.
  PdfCompressionLevel compressionLevel;

  //Properties
  /// Gets the collection of the sections in the document.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Add a new section.
  /// PdfSection section = document.sections.add();
  /// //Create page for the newly added section and draw text.
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///      brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  PdfSectionCollection get sections => _sections;

  /// Gets the document's page setting.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Get the document page settings.
  /// document.pageSettings.margins.all = 50;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  PdfPageSettings get pageSettings {
    if (_settings == null) {
      _settings = PdfPageSettings();
      _settings.setMargins(_defaultMargin);
    }
    return _settings;
  }

  /// Sets the document's page setting.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Create a PDF page settings.
  /// PdfPageSettings settings = PdfPageSettings();
  /// settings.margins.all = 50;
  /// //Set the page settings to document.
  /// document.pageSettings = settings;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  set pageSettings(PdfPageSettings settings) {
    if (settings == null) {
      throw ArgumentError.notNull('settings');
    } else {
      _settings = settings;
    }
  }

  /// Gets a template to all pages in the document.
  PdfDocumentTemplate get template {
    _template ??= PdfDocumentTemplate();
    return _template;
  }

  /// Sets a template to all pages in the document.
  set template(PdfDocumentTemplate value) {
    _template = value;
  }

  /// Gets the color space of the document.
  /// This property can be used to create PDF document in RGB,
  /// Grayscale or CMYK color spaces.
  ///
  /// By default the document uses RGB color space.
  PdfColorSpace get colorSpace {
    if ((_colorSpace == PdfColorSpace.rgb) ||
        ((_colorSpace == PdfColorSpace.cmyk) ||
            (_colorSpace == PdfColorSpace.grayScale))) {
      return _colorSpace;
    } else {
      return PdfColorSpace.rgb;
    }
  }

  /// Sets the color space of the document.
  /// This property can be used to create PDF document in RGB,
  /// Grayscale or CMYK color spaces.
  ///
  /// By default the document uses RGB color space.
  set colorSpace(PdfColorSpace value) {
    if ((value == PdfColorSpace.rgb) ||
        ((value == PdfColorSpace.cmyk) || (value == PdfColorSpace.grayScale))) {
      _colorSpace = value;
    } else {
      _colorSpace = PdfColorSpace.rgb;
    }
  }

  /// Gets the internal structure of the PDF document.
  PdfFileStructure get fileStructure {
    _fileStructure ??= PdfFileStructure();
    return _fileStructure;
  }

  /// Sets the internal structure of the PDF document.
  set fileStructure(PdfFileStructure value) {
    _fileStructure = value;
  }

  /// Gets the collection of pages in the document.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Get the page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  PdfPageCollection get pages => _getPageCollection();

  /// Gets the bookmark collection of the document.
  PdfBookmarkBase get bookmarks {
    if (_isLoadedDocument) {
      if (_bookmark == null) {
        if (_catalog.containsKey(_DictionaryProperties.outlines)) {
          final _PdfDictionary outlines = _PdfCrossTable._dereference(
              _catalog[_DictionaryProperties.outlines]) as _PdfDictionary;
          if (outlines != null) {
            _bookmark = PdfBookmarkBase._load(outlines, _crossTable);
            _bookmark._reproduceTree();
          } else {
            _bookmark = _createBookmarkRoot();
          }
        } else {
          _bookmark = _createBookmarkRoot();
        }
      }
      // _bookmark._isLoadedBookmark = true;
      return _bookmark;
    } else {
      if (_outlines == null) {
        _outlines = PdfBookmarkBase._internal();
        _catalog[_DictionaryProperties.outlines] =
            _PdfReferenceHolder(_outlines);
      }
      return _outlines;
    }
  }

  /// Gets the named destination collection of the document.
  PdfNamedDestinationCollection get namedDestinationCollection {
    if (_isLoadedDocument) {
      if (_namedDestinations == null) {
        if (_catalog.containsKey(_DictionaryProperties.names) &&
            (_namedDestinations == null)) {
          final _PdfDictionary namedDestinations =
              _PdfCrossTable._dereference(_catalog[_DictionaryProperties.names])
                  as _PdfDictionary;
          _namedDestinations =
              PdfNamedDestinationCollection._(namedDestinations, _crossTable);
        }
        _namedDestinations ??= _createNamedDestinations();
      }
      return _namedDestinations;
    } else {
      if (_namedDestinations == null) {
        _namedDestinations = PdfNamedDestinationCollection();
        _catalog[_DictionaryProperties.names] =
            _PdfReferenceHolder(_namedDestinations);
        final _PdfReferenceHolder names =
            _catalog[_DictionaryProperties.names] as _PdfReferenceHolder;
        if (names != null) {
          final _PdfDictionary dic = names.object as _PdfDictionary;
          if (dic != null) {
            dic[_DictionaryProperties.dests] =
                _PdfReferenceHolder(_namedDestinations);
          }
        }
      }
      return _namedDestinations;
    }
  }

  //Public methods
  /// Saves the document and return the saved bytes as list of int.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Get the page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  List<int> save() {
    final List<int> buffer = <int>[];
    final _PdfWriter writer = _PdfWriter(buffer);
    writer._document = this;
    _checkPages();
    if (_isLoadedDocument) {
      if (fileStructure.incrementalUpdate) {
        _copyOldStream(writer);
      } else {
        _crossTable = _PdfCrossTable._fromCatalog(
            _crossTable.count, _crossTable._documentCatalog);
        _crossTable._document = this;
      }
      _appendDocument(writer);
    } else {
      _crossTable._save(writer);
    }
    return writer._buffer;
  }

  void _checkPages() {
    if (!_isLoadedDocument) {
      if (pages.count == 0) {
        pages.add();
      }
    }
  }

  /// Releases all the resources used by document instances.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Get the page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = document.save();
  /// document.dispose();
  /// ```
  void dispose() {
    PdfBrushes._dispose();
    PdfPens._dispose();
    if (_crossTable != null) {
      _crossTable._dispose();
    }
  }

  //Implementation
  void _initialize(List<int> pdfData) {
    _data = pdfData;
    _objects = _PdfMainObjectCollection();
    if (_isLoadedDocument) {
      _crossTable = _PdfCrossTable(this, pdfData);
      if (_checkEncryption(false)) {
        throw ArgumentError.value(
            'Encryption', 'Cannot open an encrypted document.');
      } else {
        final _PdfCatalog catalog = _getCatalogValue();
        if (catalog != null &&
            catalog.containsKey(_DictionaryProperties.pages) &&
            !catalog.containsKey(_DictionaryProperties.type)) {
          catalog._addItems(_DictionaryProperties.type,
              _PdfName(_DictionaryProperties.catalog));
        }
        if (catalog.containsKey(_DictionaryProperties.type)) {
          if (!(catalog[_DictionaryProperties.type] as _PdfName)
              ._name
              .contains(_DictionaryProperties.catalog)) {
            catalog[_DictionaryProperties.type] =
                _PdfName(_DictionaryProperties.catalog);
          }
          _setCatalog(catalog);
        } else {
          throw ArgumentError.value(
              catalog, 'Cannot find the PDF catalog information');
        }
        bool hasVersion = false;
        if (catalog.containsKey(_DictionaryProperties.version)) {
          final _PdfName version =
              catalog[_DictionaryProperties.version] as _PdfName;
          if (version != null) {
            _setFileVersion('PDF-' + version._name);
            hasVersion = true;
          }
        }
        if (!hasVersion) {
          _readFileVersion();
        }
      }
    } else {
      _crossTable = _PdfCrossTable(this);
      _crossTable._document = this;
      _catalog = _PdfCatalog();
      _objects._add(_catalog);
      _catalog.position = -1;
      _sections = PdfSectionCollection._(this);
      _pages = PdfPageCollection._(this);
      _catalog._pages = _sections;
    }
    compressionLevel = PdfCompressionLevel.normal;
  }

  bool _checkEncryption(bool isAttachEncryption) {
    return _crossTable.encryptorDictionary != null;
  }

  void _copyOldStream(_PdfWriter writer) {
    writer._write(_data);
    _isStreamCopied = true;
  }

  void _appendDocument(_PdfWriter writer) {
    _crossTable._save(writer);
  }

  void _readFileVersion() {
    final _PdfReader _reader = _PdfReader(_data);
    _reader.position = 0;
    String token = _reader._getNextToken();
    if (token.startsWith('%')) {
      token = _reader._getNextToken();
      if (token != null) {
        _setFileVersion(token);
      }
    }
  }

  void _setFileVersion(String token) {
    switch (token) {
      case 'PDF-1.4':
        fileStructure.version = PdfVersion.version1_4;
        break;
      case 'PDF-1.0':
        fileStructure.version = PdfVersion.version1_0;
        //fileStructure.incrementalUpdate = false;
        break;
      case 'PDF-1.1':
        fileStructure.version = PdfVersion.version1_1;
        //fileStructure.incrementalUpdate = false;
        break;
      case 'PDF-1.2':
        fileStructure.version = PdfVersion.version1_2;
        //fileStructure.incrementalUpdate = false;
        break;
      case 'PDF-1.3':
        fileStructure.version = PdfVersion.version1_3;
        //fileStructure.incrementalUpdate = false;
        break;
      case 'PDF-1.5':
        fileStructure.version = PdfVersion.version1_5;
        break;
      case 'PDF-1.6':
        fileStructure.version = PdfVersion.version1_6;
        break;
      case 'PDF-1.7':
        fileStructure.version = PdfVersion.version1_7;
        break;
      case 'PDF-2.0':
        fileStructure.version = PdfVersion.version2_0;
        break;
    }
  }

  _PdfCatalog _getCatalogValue() {
    final _PdfCatalog catalog =
        _PdfCatalog.fromDocument(this, _crossTable.documentCatalog);
    final int index = _objects._lookFor(_crossTable.documentCatalog);
    _objects._reregisterReference(index, catalog);
    catalog.position = -1;
    return catalog;
  }

  void _setCatalog(_PdfCatalog catalog) {
    ArgumentError.checkNotNull(catalog);
    _catalog = catalog;
    if (_catalog.containsKey(_DictionaryProperties.outlines)) {
      final _PdfReferenceHolder outlines =
          _catalog[_DictionaryProperties.outlines] as _PdfReferenceHolder;
      _PdfDictionary dic;
      if (outlines == null) {
        dic = _catalog[_DictionaryProperties.outlines] as _PdfDictionary;
      } else if (outlines.object is _PdfDictionary) {
        dic = outlines.object;
      }
      if (dic != null && dic.containsKey(_DictionaryProperties.first)) {
        final _PdfReferenceHolder first =
            dic[_DictionaryProperties.first] as _PdfReferenceHolder;
        if (first != null) {
          final _PdfDictionary firstDic = first.object as _PdfDictionary;
          if (firstDic == null) {
            dic.remove(_DictionaryProperties.first);
          }
        }
      }
    }
  }

  PdfPageCollection _getPageCollection() {
    _pages ??= _isLoadedDocument
        ? PdfPageCollection._fromCrossTable(this, _crossTable)
        : PdfPageCollection._(this);
    return _pages;
  }

  /// Creates a bookmarks collection to the document.
  PdfBookmarkBase _createBookmarkRoot() {
    _bookmark = PdfBookmarkBase._internal();
    _catalog.setProperty(
        _DictionaryProperties.outlines, _PdfReferenceHolder(_bookmark));
    return _bookmark;
  }

  _PdfArray _getNamedDestination(_PdfName name) {
    final _PdfDictionary destinations = _catalog._destinations;
    final _IPdfPrimitive obj = destinations[name];
    final _PdfArray destination = _extractDestination(obj);
    return destination;
  }

  _PdfArray _extractDestination(_IPdfPrimitive obj) {
    _PdfDictionary dic;
    if (obj is _PdfDictionary) {
      dic = obj;
    } else if (obj is _PdfReferenceHolder) {
      final _PdfReferenceHolder holder = (obj as _PdfReferenceHolder);
      if (holder._object is _PdfDictionary) {
        dic = (holder._object as _PdfDictionary);
      } else if (holder._object is _PdfArray) {
        obj = (holder._object as _PdfArray);
      }
    }
    _PdfArray destination = obj as _PdfArray;

    if (dic != null) {
      obj = _PdfCrossTable._dereference(dic[_DictionaryProperties.d]);
      destination = obj as _PdfArray;
    }
    return destination;
  }

  PdfNamedDestinationCollection _createNamedDestinations() {
    _namedDestinations = PdfNamedDestinationCollection();
    final _PdfReferenceHolder catalogReference =
        _catalog[_DictionaryProperties.names] as _PdfReferenceHolder;

    if (catalogReference != null) {
      final _PdfDictionary catalogNames =
          catalogReference.object as _PdfDictionary;
      if (catalogNames != null) {
        catalogNames.setProperty(_DictionaryProperties.dests,
            _PdfReferenceHolder(_namedDestinations));
      }
    } else {
      _catalog.setProperty(
          _DictionaryProperties.names, _PdfReferenceHolder(_namedDestinations));
    }
    _catalog.modify();
    return _namedDestinations;
  }

  Map<PdfPage, dynamic> _createBookmarkDestinationDictionary() {
    PdfBookmarkBase current = bookmarks;
    if (_bookmarkHashTable == null && current != null) {
      _bookmarkHashTable = <PdfPage, dynamic>{};
      final Queue<_CurrentNodeInfo> stack = Queue<_CurrentNodeInfo>();
      _CurrentNodeInfo ni = _CurrentNodeInfo(current._list);
      do {
        for (; ni.index < ni.kids.length;) {
          current = ni.kids[ni.index];
          final PdfNamedDestination ndest =
              (current as PdfBookmark).namedDestination;
          if (ndest != null) {
            if (ndest.destination != null) {
              final PdfPage page = ndest.destination.page;
              List<dynamic> list = _bookmarkHashTable.containsKey(page)
                  ? _bookmarkHashTable[page] as List<dynamic>
                  : null;
              if (list == null) {
                list = <dynamic>[];
                _bookmarkHashTable[page] = list;
              }
              list.add(current);
            }
          } else {
            final PdfDestination dest = (current as PdfBookmark).destination;
            if (dest != null) {
              final PdfPage page = dest.page;
              List<dynamic> list = _bookmarkHashTable.containsKey(page)
                  ? _bookmarkHashTable[page] as List<dynamic>
                  : null;
              if (list == null) {
                list = <dynamic>[];
                _bookmarkHashTable[page] = list;
              }
              list.add(current);
            }
          }
          ++ni.index;
          if (current.count > 0) {
            stack.addLast(ni);
            ni = _CurrentNodeInfo(current._list);
            continue;
          }
        }
        if (stack.isNotEmpty) {
          ni = stack.removeLast();
          while ((ni.index == ni.kids.length) && (stack.isNotEmpty)) {
            ni = stack.removeLast();
          }
        }
      } while (ni.index < ni.kids.length);
    }
    return _bookmarkHashTable;
  }
}
