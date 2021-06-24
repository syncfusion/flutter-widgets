part of pdf;

/// Represents internal catalog of the PDF document.
class _PdfCatalog extends _PdfDictionary {
  /// Initializes a new instance of the [PdfCatalog] class.
  _PdfCatalog() {
    this[_DictionaryProperties.type] = _PdfName('Catalog');
  }

  _PdfCatalog.fromDocument(PdfDocument document, _PdfDictionary? catalog)
      : super(catalog) {
    _document = document;
    if (containsKey(_DictionaryProperties.names)) {
      final _IPdfPrimitive? obj =
          _PdfCrossTable._dereference(this[_DictionaryProperties.names]);
      if (obj is _PdfDictionary) {
        _catalogNames = _PdfCatalogNames(obj);
      }
    }
    readMetadata();
    freezeChanges(this);
  }

  PdfSectionCollection? _sections;
  // ignore: unused_field
  PdfDocument? _document;
  _XmpMetadata? _metadata;
  _PdfCatalogNames? _catalogNames;
  PdfForm? _forms;
  // ignore: unused_element
  PdfSectionCollection? get _pages => _sections;
  set _pages(PdfSectionCollection? sections) {
    if (_sections != sections) {
      _sections = sections;
      this[_DictionaryProperties.pages] = _PdfReferenceHolder(sections);
    }
  }

  _PdfDictionary? get _destinations {
    _PdfDictionary? dests;
    if (containsKey(_DictionaryProperties.dests)) {
      dests = _PdfCrossTable._dereference(this[_DictionaryProperties.dests])
          as _PdfDictionary?;
    }
    return dests;
  }

  _PdfCatalogNames? get _names {
    if (_catalogNames == null) {
      _catalogNames = _PdfCatalogNames();
      this[_DictionaryProperties.names] = _PdfReferenceHolder(_catalogNames);
    }
    return _catalogNames;
  }

  PdfForm? get _form => _forms;
  set _form(PdfForm? value) {
    if (_forms != value) {
      _forms = value;
      if (!_forms!._isLoadedForm) {
        this[_DictionaryProperties.acroForm] = _PdfReferenceHolder(_forms);
      }
    }
  }

  //Implementation
  /// Reads Xmp from the document.
  void readMetadata() {
    //Read metadata if present.
    final _IPdfPrimitive? rhMetadata = this[_DictionaryProperties.metadata];
    if (_PdfCrossTable._dereference(rhMetadata) is _PdfStream) {
      final _PdfStream xmpStream =
          _PdfCrossTable._dereference(rhMetadata)! as _PdfStream;
      bool isFlateDecode = false;
      if (xmpStream.containsKey(_DictionaryProperties.filter)) {
        _IPdfPrimitive? obj = xmpStream[_DictionaryProperties.filter];
        if (obj is _PdfReferenceHolder) {
          final _PdfReferenceHolder rh = obj;
          obj = rh.object;
        }
        if (obj != null) {
          if (obj is _PdfName) {
            final _PdfName filter = obj;

            if (filter._name == _DictionaryProperties.flateDecode) {
              isFlateDecode = true;
            }
          } else if (obj is _PdfArray) {
            final _PdfArray filter = obj;
            _IPdfPrimitive? pdfFilter;
            for (pdfFilter in filter._elements) {
              if (pdfFilter != null && pdfFilter is _PdfName) {
                final _PdfName filtername = pdfFilter;
                if (filtername._name == _DictionaryProperties.flateDecode) {
                  isFlateDecode = true;
                }
              }
            }
          }
        }
      }

      if (xmpStream.compress! || isFlateDecode) {
        try {
          xmpStream._decompress();
        } catch (e) {
          //non-compressed stream will throws exception when try to decompress
        }
      }
      XmlDocument xmp;
      try {
        xmp = XmlDocument.parse(utf8.decode(xmpStream._dataStream!));
      } catch (e) {
        xmpStream._decompress();
        try {
          xmp = XmlDocument.parse(utf8.decode(xmpStream._dataStream!));
        } catch (e1) {
          return;
        }
      }
      _metadata = _XmpMetadata.fromXmlDocument(xmp);
    }
  }
}
