part of pdf;

/// Represents a PDF document and can be used to create a new PDF document
/// from the scratch.
class PdfDocument {
  //Constructor
  /// Initialize a new instance of the [PdfDocument] class
  /// from the PDF data as list of bytes
  ///
  /// To initialize a new instance of the [PdfDocument] class for an exisitng
  /// PDF document, we can use the named parameters
  /// to load PDF data and password
  /// or add conformance level to the PDF
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
  PdfDocument(
      {List<int>? inputBytes,
      PdfConformanceLevel? conformanceLevel,
      String? password}) {
    _isLoadedDocument = inputBytes != null;
    _password = password;
    _initialize(inputBytes);
    if (!_isLoadedDocument && conformanceLevel != null) {
      _initializeConformance(conformanceLevel);
    }
  }

  /// Initialize a new instance of the [PdfDocument] class
  /// from the PDF data as base64 string
  ///
  /// If the document is encrypted, then we have to provide open or permission
  /// passwords to load PDF document
  ///
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
  PdfDocument.fromBase64String(String base64String, {String? password}) {
    if (base64String.isEmpty) {
      ArgumentError.value(base64String, 'PDF data', 'PDF data cannot be null');
    }
    _password = password;
    _isLoadedDocument = true;
    _initialize(base64.decode(base64String));
  }
  //Constants
  static const double _defaultMargin = 40;

  //Fields
  late _PdfMainObjectCollection _objects;
  late _PdfCrossTable _crossTable;
  late _PdfCatalog _catalog;
  PdfPageCollection? _pages;
  PdfPageSettings? _settings;
  PdfSectionCollection? _sections;
  PdfFileStructure? _fileStructure;
  PdfColorSpace? _colorSpace;
  PdfDocumentTemplate? _template;
  PdfBookmarkBase? _outlines;
  PdfNamedDestinationCollection? _namedDestinations;
  bool _isLoadedDocument = false;
  List<int>? _data;
  bool _isStreamCopied = false;
  PdfBookmarkBase? _bookmark;
  Map<PdfPage, dynamic>? _bookmarkHashTable;
  PdfDocumentInformation? _documentInfo;
  PdfSecurity? _security;
  int? _position;
  int? _orderPosition;
  int? _onPosition;
  int? _offPosition;
  _PdfArray? _primitive;
  _PdfArray? _printLayer;
  _PdfArray? _on;
  _PdfArray? _off;
  _PdfArray? _order;
  String? _password;
  late bool _isEncrypted;
  PdfConformanceLevel _conformanceLevel = PdfConformanceLevel.none;
  PdfLayerCollection? _layers;
  _PdfReference? _currentSavingObject;
  PdfAttachmentCollection? _attachments;
  bool? _isAttachOnlyEncryption;
  PdfForm? _form;

  //Events
  List<_DocumentSavedHandler>? _documentSavedList;

  /// Gets or  sets the PDF document compression level.
  PdfCompressionLevel? compressionLevel;

  /// The event raised on Pdf password.
  ///
  /// ```dart
  /// //Load an existing PDF document
  /// PdfDocument document =
  ///     PdfDocument(inputBytes: File('input.pdf').readAsBytesSync())
  ///       //Subsribe the onPdfPassword event
  ///       ..onPdfPassword = loadOnPdfPassword;
  /// //Access the attachments
  /// PdfAttachmentCollection attachmentCollection = document.attachments;
  /// //Iterates the attachments
  /// for (int i = 0; i < attachmentCollection.count; i++) {
  ///   //Extracts the attachment and saves it to the disk
  ///   File(attachmentCollection[i].fileName)
  ///       .writeAsBytesSync(attachmentCollection[i].data);
  /// }
  /// //Disposes the document
  /// document.dispose();
  ///
  /// void loadOnPdfPassword(PdfDocument sender, PdfPasswordArgs args) {
  ///   //Sets the value of PDF password.
  ///   args.attachmentOpenPassword = 'syncfusion';
  /// }
  /// ```
  PdfPasswordCallback? onPdfPassword;

  //Properties
  /// Gets the security features of the document like encryption.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Set security options
  /// security.keySize = PdfEncryptionKeySize.key128Bit;
  /// security.algorithm = PdfEncryptionAlgorithm.rc4;
  /// security.userPassword = 'password';
  /// security.ownerPassword = 'syncfusion';
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfSecurity get security {
    _security ??= PdfSecurity._();
    if (_conformanceLevel != PdfConformanceLevel.none) {
      _security!._conformance = true;
    }
    return _security!;
  }

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
  PdfSectionCollection? get sections => _sections;

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
      _settings!.setMargins(_defaultMargin);
    }
    return _settings!;
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
    _settings = settings;
  }

  /// Gets a template to all pages in the document.
  PdfDocumentTemplate get template {
    _template ??= PdfDocumentTemplate();
    return _template!;
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
      return _colorSpace!;
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
    return _fileStructure!;
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
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Create document bookmarks.
  /// document.bookmarks.add('Interactive Feature')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..color = PdfColor(255, 0, 0);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBookmarkBase get bookmarks {
    if (_isLoadedDocument) {
      if (_bookmark == null) {
        if (_catalog.containsKey(_DictionaryProperties.outlines)) {
          final _IPdfPrimitive? outlines = _PdfCrossTable._dereference(
              _catalog[_DictionaryProperties.outlines]);
          if (outlines != null && outlines is _PdfDictionary) {
            _bookmark = PdfBookmarkBase._load(outlines, _crossTable);
            _bookmark!._reproduceTree();
          } else {
            _bookmark = _createBookmarkRoot();
          }
        } else {
          _bookmark = _createBookmarkRoot();
        }
      }
      return _bookmark!;
    } else {
      if (_outlines == null) {
        _outlines = PdfBookmarkBase._internal();
        _catalog[_DictionaryProperties.outlines] =
            _PdfReferenceHolder(_outlines);
      }
      return _outlines!;
    }
  }

  /// Gets the named destination collection of the document.
  PdfNamedDestinationCollection get namedDestinationCollection {
    if (_isLoadedDocument) {
      if (_namedDestinations == null) {
        if (_catalog.containsKey(_DictionaryProperties.names) &&
            (_namedDestinations == null)) {
          final _PdfDictionary? namedDestinations =
              _PdfCrossTable._dereference(_catalog[_DictionaryProperties.names])
                  as _PdfDictionary?;
          _namedDestinations =
              PdfNamedDestinationCollection._(namedDestinations, _crossTable);
        }
        _namedDestinations ??= _createNamedDestinations();
      }
      return _namedDestinations!;
    } else {
      if (_namedDestinations == null) {
        _namedDestinations = PdfNamedDestinationCollection();
        _catalog[_DictionaryProperties.names] =
            _PdfReferenceHolder(_namedDestinations);
        final _PdfReferenceHolder? names =
            _catalog[_DictionaryProperties.names] as _PdfReferenceHolder?;
        if (names != null) {
          final _PdfDictionary? dic = names.object as _PdfDictionary?;
          if (dic != null) {
            dic[_DictionaryProperties.dests] =
                _PdfReferenceHolder(_namedDestinations);
          }
        }
      }
      return _namedDestinations!;
    }
  }

  /// Gets document's information and properties such as document's title, subject, keyword etc.
  PdfDocumentInformation get documentInformation {
    if (_documentInfo == null) {
      if (_isLoadedDocument) {
        final _PdfDictionary trailer = _crossTable.trailer!;
        if (_PdfCrossTable._dereference(trailer[_DictionaryProperties.info])
            is _PdfDictionary) {
          final _PdfDictionary? entry =
              _PdfCrossTable._dereference(trailer[_DictionaryProperties.info])
                  as _PdfDictionary?;
          _documentInfo = PdfDocumentInformation._(_catalog,
              dictionary: entry,
              isLoaded: true,
              conformance: _conformanceLevel);
        } else {
          _documentInfo = PdfDocumentInformation._(_catalog,
              conformance: _conformanceLevel);
          _crossTable.trailer![_DictionaryProperties.info] =
              _PdfReferenceHolder(_documentInfo);
        }
        // Read document's info dictionary if present.
        _readDocumentInfo();
      } else {
        _documentInfo =
            PdfDocumentInformation._(_catalog, conformance: _conformanceLevel);
        _crossTable.trailer![_DictionaryProperties.info] =
            _PdfReferenceHolder(_documentInfo);
      }
    }
    return _documentInfo!;
  }

  /// Gets the collection of PdfLayer from the PDF document.
  PdfLayerCollection get layers {
    _layers ??= PdfLayerCollection._(this);
    return _layers!;
  }

  /// Gets the attachment collection of the document.
  PdfAttachmentCollection get attachments {
    if (_attachments == null) {
      if (!_isLoadedDocument) {
        _attachments = PdfAttachmentCollection();
        if (_conformanceLevel == PdfConformanceLevel.a1b ||
            _conformanceLevel == PdfConformanceLevel.a2b) {
          _attachments!._conformance = true;
        }
        _catalog._names!._embeddedFiles = _attachments!;
      } else {
        if (onPdfPassword != null && _password == '') {
          final PdfPasswordArgs args = PdfPasswordArgs._();
          onPdfPassword!(this, args);
          _password = args.attachmentOpenPassword;
        }
        if (_isAttachOnlyEncryption!) {
          _checkEncryption(_isAttachOnlyEncryption);
        }
        final _IPdfPrimitive? attachmentDictionary =
            _PdfCrossTable._dereference(_catalog[_DictionaryProperties.names]);
        if (attachmentDictionary != null &&
            attachmentDictionary is _PdfDictionary &&
            attachmentDictionary
                .containsKey(_DictionaryProperties.embeddedFiles)) {
          _attachments =
              PdfAttachmentCollection._(attachmentDictionary, _crossTable);
        } else {
          _attachments = PdfAttachmentCollection();
          _catalog._names!._embeddedFiles = _attachments!;
        }
      }
    }
    return _attachments!;
  }

  /// Gets the interactive form of the document.
  PdfForm get form {
    if (_isLoadedDocument) {
      if (_form == null) {
        if (_catalog.containsKey(_DictionaryProperties.acroForm)) {
          final _IPdfPrimitive? formDictionary = _PdfCrossTable._dereference(
              _catalog[_DictionaryProperties.acroForm]);
          if (formDictionary is _PdfDictionary) {
            _form = PdfForm._internal(_crossTable, formDictionary);
            if (_form != null && _form!.fields.count != 0) {
              _catalog._form = _form;
              List<int>? widgetReference;
              if (_form!._crossTable!._document != null) {
                for (int i = 0;
                    i < _form!._crossTable!._document!.pages.count;
                    i++) {
                  final PdfPage? page = _form!._crossTable!._document!.pages[i];
                  if (widgetReference == null && page != null) {
                    widgetReference = page._getWidgetReferences();
                  }
                  if (page != null &&
                      widgetReference != null &&
                      widgetReference.isNotEmpty) {
                    page._createAnnotations(widgetReference);
                  }
                }
                if (widgetReference != null) widgetReference.clear();
                if (!_form!._formHasKids) {
                  _form!.fields
                      ._createFormFieldsFromWidgets(_form!.fields.count);
                }
              }
            }
          }
        } else {
          _form = PdfForm._internal(_crossTable);
          _catalog.setProperty(
              _DictionaryProperties.acroForm, _PdfReferenceHolder(_form));
          _catalog._form = _form!;
          return _form!;
        }
      } else {
        return _form!;
      }
    } else {
      return _catalog._form ??= PdfForm();
    }
    return _form!;
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
    if (security._encryptAttachments && security.userPassword == '') {
      throw ArgumentError.value(
          'User password cannot be empty for encrypt only attachment.');
    }
    if (_isLoadedDocument) {
      if (_security != null) {
        if (_security!._encryptAttachments) {
          fileStructure.incrementalUpdate = false;
          if (_security!._encryptor.userPassword.isEmpty) {
            _security!._encryptor.encryptOnlyAttachment = false;
          }
        }
      }
      if (fileStructure.incrementalUpdate &&
          (_security == null ||
              (_security != null &&
                  !_security!._modifiedSecurity &&
                  !_security!.permissions._modifiedPermissions))) {
        _copyOldStream(writer);
        if (_catalog.changed!) {
          _readDocumentInfo();
        }
      } else {
        _crossTable = _PdfCrossTable._fromCatalog(_crossTable.count,
            _crossTable.encryptorDictionary, _crossTable._documentCatalog);
        _crossTable._document = this;
        _crossTable.trailer![_DictionaryProperties.info] =
            _PdfReferenceHolder(documentInformation);
      }
      _appendDocument(writer);
    } else {
      if (_conformanceLevel == PdfConformanceLevel.a1b ||
          _conformanceLevel == PdfConformanceLevel.a2b ||
          _conformanceLevel == PdfConformanceLevel.a3b) {
        documentInformation._xmpMetadata;
        if (_conformanceLevel == PdfConformanceLevel.a3b &&
            _catalog._names != null &&
            attachments.count > 0) {
          final _PdfName fileRelationShip =
              _PdfName(_DictionaryProperties.afRelationship);
          final _PdfArray fileAttachmentAssociationArray = _PdfArray();
          for (int i = 0; i < attachments.count; i++) {
            if (!attachments[i]
                ._dictionary
                ._items!
                .containsKey(fileRelationShip)) {
              attachments[i]._dictionary._items![fileRelationShip] =
                  _PdfName('Alternative');
            }
            fileAttachmentAssociationArray
                ._add(_PdfReferenceHolder(attachments[i]._dictionary));
          }
          _catalog._items![_PdfName(_DictionaryProperties.af)] =
              fileAttachmentAssociationArray;
        }
      }
      _crossTable._save(writer);
      final _DocumentSavedArgs argsSaved = _DocumentSavedArgs(writer);
      _onDocumentSaved(argsSaved);
    }
    return writer._buffer!;
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
    _crossTable._dispose();
    _security = null;
    _currentSavingObject = null;
  }

  //Implementation
  void _initialize(List<int>? pdfData) {
    _isAttachOnlyEncryption = false;
    _isEncrypted = false;
    _data = pdfData;
    _objects = _PdfMainObjectCollection();
    if (_isLoadedDocument) {
      _crossTable = _PdfCrossTable(this, pdfData);
      _isEncrypted = _checkEncryption(false);
      final _PdfCatalog catalog = _getCatalogValue();
      if (catalog.containsKey(_DictionaryProperties.pages) &&
          !catalog.containsKey(_DictionaryProperties.type)) {
        catalog._addItems(_DictionaryProperties.type,
            _PdfName(_DictionaryProperties.catalog));
      }
      if (catalog.containsKey(_DictionaryProperties.type)) {
        if (!(catalog[_DictionaryProperties.type] as _PdfName)
            ._name!
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
        final _PdfName? version =
            catalog[_DictionaryProperties.version] as _PdfName?;
        if (version != null) {
          _setFileVersion('PDF-' + version._name!);
          hasVersion = true;
        }
      }
      if (!hasVersion) {
        _readFileVersion();
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
    _position = 0;
    _orderPosition = 0;
    _onPosition = 0;
    _offPosition = 0;
    _primitive = _PdfArray();
    _on = _PdfArray();
    _off = _PdfArray();
    _order = _PdfArray();
    _printLayer = _PdfArray();
  }

  bool _checkEncryption(bool? isAttachEncryption) {
    bool wasEncrypted = false;
    if (_crossTable.encryptorDictionary != null) {
      final _PdfDictionary encryptionDict = _crossTable.encryptorDictionary!;
      _password ??= '';
      final _PdfDictionary trailerDict = _crossTable.trailer!;
      _PdfArray? obj;
      if (trailerDict.containsKey(_DictionaryProperties.id)) {
        _IPdfPrimitive? primitive = trailerDict[_DictionaryProperties.id];
        if (primitive is _PdfArray) {
          obj = primitive;
        } else if (primitive is _PdfReferenceHolder) {
          primitive = primitive.object;
          if (primitive != null && primitive is _PdfArray) {
            obj = primitive;
          }
        }
      }
      obj ??= _PdfArray().._add(_PdfString.fromBytes(<int>[]));
      final _PdfString key = obj[0] as _PdfString;
      final _PdfEncryptor encryptor = _PdfEncryptor();
      if (encryptionDict.containsKey(_DictionaryProperties.encryptMetadata)) {
        _IPdfPrimitive? primitive =
            encryptionDict[_DictionaryProperties.encryptMetadata];
        if (primitive is _PdfBoolean) {
          encryptor.encryptMetadata = primitive.value!;
        } else if (primitive is _PdfReferenceHolder) {
          primitive = primitive._object;
          if (primitive != null && primitive is _PdfBoolean) {
            encryptor.encryptMetadata = primitive.value!;
          }
        }
      }
      wasEncrypted = true;
      encryptor._readFromDictionary(encryptionDict);
      bool encryption = true;
      if (!isAttachEncryption! && encryptor._encryptOnlyAttachment!) {
        encryption = false;
      }
      if (!encryptor._checkPassword(_password!, key, encryption)) {
        throw ArgumentError.value(_password, 'password',
            'Cannot open an encrypted document. The password is invalid.');
      }
      encryptionDict.encrypt = false;
      final PdfSecurity security = PdfSecurity._().._encryptor = encryptor;
      _security = security;
      _security!._encryptOnlyAttachment = encryptor._encryptOnlyAttachment!;
      _isAttachOnlyEncryption = encryptor._encryptOnlyAttachment;
      if (_isAttachOnlyEncryption!) {
        security._encryptor._encryptionOptions =
            PdfEncryptionOptions.encryptOnlyAttachments;
      } else if (!encryptor.encryptMetadata) {
        security._encryptor._encryptionOptions =
            PdfEncryptionOptions.encryptAllContentsExceptMetadata;
      }
      _crossTable.encryptor = encryptor;
    }
    return wasEncrypted;
  }

  void _copyOldStream(_PdfWriter writer) {
    writer._write(_data);
    _isStreamCopied = true;
  }

  void _appendDocument(_PdfWriter writer) {
    writer._document = this;
    _crossTable._save(writer);
    security._encryptor.encrypt = true;
    final _DocumentSavedArgs argsSaved = _DocumentSavedArgs(writer);
    _onDocumentSaved(argsSaved);
  }

  void _readFileVersion() {
    final _PdfReader _reader = _PdfReader(_data);
    _reader.position = 0;
    String token = _reader._getNextToken()!;
    if (token.startsWith('%')) {
      token = _reader._getNextToken()!;
      _setFileVersion(token);
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
    final int index = _objects._lookFor(_crossTable.documentCatalog!)!;
    _objects._reregisterReference(index, catalog);
    catalog.position = -1;
    return catalog;
  }

  void _setCatalog(_PdfCatalog catalog) {
    _catalog = catalog;
    if (_catalog.containsKey(_DictionaryProperties.outlines)) {
      final _PdfReferenceHolder? outlines =
          _catalog[_DictionaryProperties.outlines] as _PdfReferenceHolder?;
      _PdfDictionary? dic;
      if (outlines == null) {
        dic = _catalog[_DictionaryProperties.outlines] as _PdfDictionary?;
      } else if (outlines.object is _PdfDictionary) {
        dic = outlines.object as _PdfDictionary?;
      }
      if (dic != null && dic.containsKey(_DictionaryProperties.first)) {
        final _PdfReferenceHolder? first =
            dic[_DictionaryProperties.first] as _PdfReferenceHolder?;
        if (first != null) {
          final _PdfDictionary? firstDic = first.object as _PdfDictionary?;
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
    return _pages!;
  }

  /// Creates a bookmarks collection to the document.
  PdfBookmarkBase? _createBookmarkRoot() {
    _bookmark = PdfBookmarkBase._internal();
    _catalog.setProperty(
        _DictionaryProperties.outlines, _PdfReferenceHolder(_bookmark));
    return _bookmark;
  }

  _PdfArray? _getNamedDestination(_IPdfPrimitive obj) {
    _PdfDictionary? destinations;
    _PdfArray? destination;
    if (obj is _PdfName) {
      destinations = _catalog._destinations;
      final _IPdfPrimitive? name = destinations![obj];
      destination = _extractDestination(name);
    } else if (obj is _PdfString) {
      final _PdfCatalogNames? names = _catalog._names;
      if (names != null) {
        destinations = names._destinations;
        final _IPdfPrimitive? name =
            names._getNamedObjectFromTree(destinations, obj);
        destination = _extractDestination(name);
      }
    }
    return destination;
  }

  _PdfArray? _extractDestination(_IPdfPrimitive? obj) {
    _PdfDictionary? dic;
    if (obj is _PdfDictionary) {
      dic = obj;
    } else if (obj is _PdfReferenceHolder) {
      final _PdfReferenceHolder holder = obj;
      if (holder._object is _PdfDictionary) {
        dic = (holder._object as _PdfDictionary?);
      } else if (holder._object is _PdfArray) {
        obj = (holder._object as _PdfArray?) as _PdfReferenceHolder;
      }
    }
    _PdfArray? destination;
    if (obj is _PdfArray) {
      destination = obj;
    }
    if (dic != null) {
      obj = _PdfCrossTable._dereference(dic[_DictionaryProperties.d]);
      destination = obj as _PdfArray?;
    }
    return destination;
  }

  PdfNamedDestinationCollection? _createNamedDestinations() {
    _namedDestinations = PdfNamedDestinationCollection();
    final _PdfReferenceHolder? catalogReference =
        _catalog[_DictionaryProperties.names] as _PdfReferenceHolder?;

    if (catalogReference != null) {
      final _PdfDictionary? catalogNames =
          catalogReference.object as _PdfDictionary?;
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

  Map<PdfPage, dynamic>? _createBookmarkDestinationDictionary() {
    PdfBookmarkBase? current = bookmarks;
    if (_bookmarkHashTable == null) {
      _bookmarkHashTable = <PdfPage, dynamic>{};
      final Queue<_CurrentNodeInfo> stack = Queue<_CurrentNodeInfo>();
      _CurrentNodeInfo ni = _CurrentNodeInfo(current._list);
      do {
        for (; ni.index < ni.kids.length;) {
          current = ni.kids[ni.index];
          final PdfNamedDestination? ndest =
              (current as PdfBookmark).namedDestination;
          if (ndest != null) {
            if (ndest.destination != null) {
              final PdfPage page = ndest.destination!.page;
              List<dynamic>? list;
              if (_bookmarkHashTable!.containsKey(page)) {
                list = _bookmarkHashTable![page] as List<dynamic>?;
              }
              if (list == null) {
                list = <dynamic>[];
                _bookmarkHashTable![page] = list;
              }
              list.add(current);
            }
          } else {
            final PdfDestination? dest = current.destination;
            final PdfPage page = dest!.page;
            List<dynamic>? list = _bookmarkHashTable!.containsKey(page)
                ? _bookmarkHashTable![page] as List<dynamic>?
                : null;
            if (list == null) {
              list = <dynamic>[];
              _bookmarkHashTable![page] = list;
            }
            list.add(current);
          }
          ni.index = ni.index + 1;
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

  void _readDocumentInfo() {
    // Read document's info if present.
    final _PdfDictionary? info = _PdfCrossTable._dereference(
        _crossTable.trailer![_DictionaryProperties.info]) as _PdfDictionary?;
    if (info != null && _documentInfo == null) {
      _documentInfo = PdfDocumentInformation._(_catalog,
          dictionary: info, isLoaded: true, conformance: _conformanceLevel);
    }
    if (info != null &&
        !info.changed! &&
        _crossTable.trailer![_DictionaryProperties.info]
            is _PdfReferenceHolder) {
      _documentInfo = PdfDocumentInformation._(_catalog,
          dictionary: info, isLoaded: true, conformance: _conformanceLevel);
      if (_catalog.changed!) {
        _documentInfo!.modificationDate = DateTime.now();
      }
      if (_objects._lookFor(_documentInfo!._element!)! > -1) {
        _objects._reregisterReference(
            _objects._lookFor(info)!, _documentInfo!._element!);
        _documentInfo!._element!.position = -1;
      }
    }
  }

  void _initializeConformance(PdfConformanceLevel conformance) {
    _conformanceLevel = conformance;
    if (_conformanceLevel == PdfConformanceLevel.a1b ||
        _conformanceLevel == PdfConformanceLevel.a2b ||
        _conformanceLevel == PdfConformanceLevel.a3b) {
      //Note : PDF/A is based on Pdf 1.4.  Hence it does not support cross reference
      //stream which is an Pdf 1.5 feature.
      fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceTable;
      if (_conformanceLevel == PdfConformanceLevel.a1b) {
        fileStructure.version = PdfVersion.version1_4;
      } else {
        fileStructure.version = PdfVersion.version1_7;
      }
      //Embed the Color Profie.
      final _PdfDictionary dict = _PdfDictionary();
      dict['Info'] = _PdfString('sRGB IEC61966-2.1');
      dict['S'] = _PdfName('GTS_PDFA1');
      dict['OutputConditionIdentifier'] = _PdfString('custom');
      dict['Type'] = _PdfName('OutputIntent');
      dict['OutputCondition'] = _PdfString('');
      dict['RegistryName'] = _PdfString('');
      final _PdfICCColorProfile srgbProfile = _PdfICCColorProfile();
      dict['DestOutputProfile'] = _PdfReferenceHolder(srgbProfile);
      final _PdfArray outputIntent = _PdfArray();
      outputIntent._add(dict);
      _catalog['OutputIntents'] = outputIntent;
    }
  }

  //Raises DocumentSaved event.
  void _onDocumentSaved(_DocumentSavedArgs args) {
    if (_documentSavedList != null && _documentSavedList!.isNotEmpty) {
      for (int i = 0; i < _documentSavedList!.length; i++) {
        _documentSavedList![i](this, args);
      }
    }
  }

  void _setUserPassword(PdfPasswordArgs args) {
    onPdfPassword!(this, args);
  }
}

/// Delegate for handling the PDF password
///
/// ```dart
/// //Load an existing PDF document
/// PdfDocument document =
///     PdfDocument(inputBytes: File('input.pdf').readAsBytesSync())
///       //Subsribe the onPdfPassword event
///       ..onPdfPassword = loadOnPdfPassword;
/// //Access the attachments
/// PdfAttachmentCollection attachmentCollection = document.attachments;
/// //Iterates the attachments
/// for (int i = 0; i < attachmentCollection.count; i++) {
///   //Extracts the attachment and saves it to the disk
///   File(attachmentCollection[i].fileName)
///       .writeAsBytesSync(attachmentCollection[i].data);
/// }
/// //Disposes the document
/// document.dispose();
///
/// void loadOnPdfPassword(PdfDocument sender, PdfPasswordArgs args) {
///   //Sets the value of PDF password.
///   args.attachmentOpenPassword = 'syncfusion';
/// }
/// ```
typedef PdfPasswordCallback = void Function(
    PdfDocument sender, PdfPasswordArgs args);

/// Arguments of Pdf Password.
///
/// ```dart
/// //Load an existing PDF document
/// PdfDocument document =
///     PdfDocument(inputBytes: File('input.pdf').readAsBytesSync())
///       //Subsribe the onPdfPassword event
///       ..onPdfPassword = loadOnPdfPassword;
/// //Access the attachments
/// PdfAttachmentCollection attachmentCollection = document.attachments;
/// //Iterates the attachments
/// for (int i = 0; i < attachmentCollection.count; i++) {
///   //Extracts the attachment and saves it to the disk
///   File(attachmentCollection[i].fileName)
///       .writeAsBytesSync(attachmentCollection[i].data);
/// }
/// //Disposes the document
/// document.dispose();
///
/// void loadOnPdfPassword(PdfDocument sender, PdfPasswordArgs args) {
///   //Sets the value of PDF password.
///   args.attachmentOpenPassword = 'syncfusion';
/// }
/// ```
class PdfPasswordArgs {
  PdfPasswordArgs._() {
    attachmentOpenPassword = '';
  }
  //Fields
  /// A value of PDF password.
  ///
  /// ```dart
  /// //Load an existing PDF document
  /// PdfDocument document =
  ///     PdfDocument(inputBytes: File('input.pdf').readAsBytesSync())
  ///       //Subsribe the onPdfPassword event
  ///       ..onPdfPassword = loadOnPdfPassword;
  /// //Access the attachments
  /// PdfAttachmentCollection attachmentCollection = document.attachments;
  /// //Iterates the attachments
  /// for (int i = 0; i < attachmentCollection.count; i++) {
  ///   //Extracts the attachment and saves it to the disk
  ///   File(attachmentCollection[i].fileName)
  ///       .writeAsBytesSync(attachmentCollection[i].data);
  /// }
  /// //Disposes the document
  /// document.dispose();
  ///
  /// void loadOnPdfPassword(PdfDocument sender, PdfPasswordArgs args) {
  ///   //Sets the value of PDF password.
  ///   args.attachmentOpenPassword = 'syncfusion';
  /// }
  /// ```
  String? attachmentOpenPassword;
}

typedef _DocumentSavedHandler = void Function(
    Object sender, _DocumentSavedArgs args);

class _DocumentSavedArgs {
  //Constructor
  _DocumentSavedArgs(_IPdfWriter writer) {
    _writer = writer;
  }

  //Fields
  _IPdfWriter? _writer;

  //Properties
  _IPdfWriter? get writer => _writer;
}
