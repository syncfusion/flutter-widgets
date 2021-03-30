part of pdf;

/// Represents signature field in the PDF Form.
class PdfSignatureField extends PdfField {
  //Constructor
  /// Initializes a new instance of the [PdfSignatureField] class.
  PdfSignatureField(PdfPage page, String name,
      {Rect bounds = Rect.zero,
      int borderWidth = 1,
      PdfHighlightMode? highlightMode,
      PdfSignature? signature,
      String? tooltip})
      : super(page, name, bounds,
            borderWidth: borderWidth,
            highlightMode: highlightMode,
            tooltip: tooltip) {
    if (page._document != null) {
      form!._signatureFlags = [
        _SignatureFlags.signaturesExists,
        _SignatureFlags.appendOnly
      ];
    }
    if (signature != null) {
      this.signature = signature;
    }
  }

  PdfSignatureField._(_PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._load(dictionary, crossTable);

  //Fields
  bool _skipKidsCertificate = false;
  PdfSignature? _signature;

  //Properties
  /// Gets or sets the width of the border.
  ///
  /// The default value is 1.
  int get borderWidth => _borderWidth;
  set borderWidth(int value) => _borderWidth = value;

  /// Gets or sets the highlighting mode.
  ///
  /// The default mode is invert.
  PdfHighlightMode get highlightMode => _highlightMode;
  set highlightMode(PdfHighlightMode value) => _highlightMode = value;

  ///Gets the visual appearance of the field
  PdfAppearance get appearance => _widget!.appearance;

  /// Gets or sets the digital signature for signing the field.
  PdfSignature? get signature {
    if (_isLoadedField && _signature == null) {
      if (_dictionary.containsKey(_DictionaryProperties.v)) {
        _setSignature(_dictionary[_DictionaryProperties.v]);
      }
    }
    return _signature;
  }

  set signature(PdfSignature? value) {
    _initializeSignature(value);
  }

  //Implementations
  @override
  void _initialize() {
    super._initialize();
    form!.fieldAutoNaming
        ? _widget!._dictionary.setProperty(
            _DictionaryProperties.ft, _PdfName(_DictionaryProperties.sig))
        : _dictionary.setProperty(
            _DictionaryProperties.ft, _PdfName(_DictionaryProperties.sig));
  }

  void _initializeSignature(PdfSignature? value) {
    if (value != null) {
      _signature = value;
      _signature!._page = page;
      _signature!._document = _signature!._page!._document;
      _signature!._checkAnnotationElementsContainsSignature(page!, name);
      _signature!._field = this;
      _signature!._document!._catalog._beginSave =
          _signature!._catalogBeginSave;
      _dictionary._beginSaveList ??= [];
      _dictionary._beginSaveList!.add(_signature!._dictionaryBeginSave);
      if (!_skipKidsCertificate) {
        _signature!._signatureDictionary =
            _PdfSignatureDictionary(_signature!._document!, _signature!);
        if (!_signature!._document!._isLoadedDocument ||
            _signature!._document!.fileStructure.incrementalUpdate != false) {
          _signature!._document!._objects
              ._add(_signature!._signatureDictionary!._element);
          _signature!
              ._document!
              ._objects[_signature!._document!._objects._count - 1]
              ._isModified = true;
          _signature!._signatureDictionary!._element.position = -1;
        }
        if (_isLoadedField) {
          form!._signatureFlags = <_SignatureFlags>[
            _SignatureFlags.signaturesExists,
            _SignatureFlags.appendOnly
          ];
          final _PdfDictionary widget =
              _getWidgetAnnotation(_dictionary, _crossTable);
          widget[_DictionaryProperties.v] =
              _PdfReferenceHolder(_signature!._signatureDictionary);
          widget.modify();
          _changed = true;
          widget.setProperty(_DictionaryProperties.fieldFlags, _PdfNumber(0));
          _signature!._signatureDictionary!._dictionary._archive = false;
        } else {
          _widget!._dictionary.setProperty(_DictionaryProperties.v,
              _PdfReferenceHolder(_signature!._signatureDictionary));
          _widget!._dictionary
              .setProperty(_DictionaryProperties.fieldFlags, _PdfNumber(0));
        }
      } else {
        _widget!._dictionary
            .setProperty(_DictionaryProperties.fieldFlags, _PdfNumber(0));
      }
      _widget!.bounds = bounds;
    }
  }

  void _draw() {
    if (!_isLoadedField) {
      super._draw();
      if (_widget!._pdfAppearance != null) {
        page!.graphics
            .drawPdfTemplate(_widget!.appearance.normal, bounds.topLeft);
      }
    } else if (_flattenField) {
      if (_dictionary[_DictionaryProperties.ap] != null) {
        final _IPdfPrimitive? dictionary =
            _dictionary[_DictionaryProperties.ap];
        final _IPdfPrimitive? appearanceDictionary =
            _PdfCrossTable._dereference(dictionary);
        PdfTemplate template;
        if (appearanceDictionary != null &&
            appearanceDictionary is _PdfDictionary) {
          final _IPdfPrimitive? appearanceRefHolder =
              appearanceDictionary[_DictionaryProperties.n];
          final _IPdfPrimitive? objectDictionary =
              _PdfCrossTable._dereference(appearanceRefHolder);
          if (objectDictionary != null && objectDictionary is _PdfDictionary) {
            if (objectDictionary is _PdfStream) {
              final _PdfStream stream = objectDictionary;
              template = PdfTemplate._fromPdfStream(stream);
              page!.graphics.drawPdfTemplate(template, bounds.topLeft);
            }
          }
        }
      } else {
        //signature field without appearance dictionary
        final PdfBrush brush = PdfSolidBrush(_getBackColor(true));
        final _GraphicsProperties graphicsProperties =
            _GraphicsProperties(this);
        final _PaintParams paintingParameters = _PaintParams(
            bounds: graphicsProperties._bounds,
            backBrush: brush,
            foreBrush: graphicsProperties._foreBrush,
            borderPen: graphicsProperties._borderPen,
            style: graphicsProperties._style,
            borderWidth: graphicsProperties._borderWidth,
            shadowBrush: graphicsProperties._shadowBrush);
        _FieldPainter().drawSignature(page!.graphics, paintingParameters);
      }
    }
  }

  void _drawAppearance(PdfTemplate template) {
    super._drawAppearance(template);
    _FieldPainter().drawSignature(template.graphics!, _PaintParams());
  }

  void _setSignature(_IPdfPrimitive? signature) {
    if (signature is _PdfReferenceHolder &&
        signature.object != null &&
        signature.object is _PdfDictionary) {
      final _PdfDictionary signatureDictionary =
          signature.object as _PdfDictionary;
      _signature = PdfSignature();
      _signature!._document = _crossTable!._document;
      String? subFilterType = '';
      if (signatureDictionary.containsKey(_DictionaryProperties.subFilter)) {
        final _IPdfPrimitive? filter = _PdfCrossTable._dereference(
            signatureDictionary[_DictionaryProperties.subFilter]);
        if (filter != null && filter is _PdfName) {
          subFilterType = filter._name;
        }
        if (subFilterType == 'ETSI.CAdES.detached') {
          _signature!.cryptographicStandard = CryptographicStandard.cades;
        }
      }
      if (_crossTable!._document != null &&
          !_crossTable!._document!._isLoadedDocument) {
        if (signatureDictionary.containsKey(_DictionaryProperties.reference)) {
          final _IPdfPrimitive? tempArray =
              signatureDictionary[_DictionaryProperties.reference];
          if (tempArray != null && tempArray is _PdfArray) {
            final _IPdfPrimitive? tempDictionary = tempArray._elements[0];
            if (tempDictionary != null && tempDictionary is _PdfDictionary) {
              if (tempDictionary.containsKey(_DictionaryProperties.data)) {
                final _PdfMainObjectCollection? mainObjectCollection =
                    _crossTable!._document!._objects;
                _IPdfPrimitive? tempReferenceHolder =
                    tempDictionary[_DictionaryProperties.data];
                if (tempReferenceHolder != null &&
                    tempReferenceHolder is _PdfReferenceHolder &&
                    !mainObjectCollection!
                        ._containsReference(tempReferenceHolder.reference!)) {
                  final _IPdfPrimitive? tempObject = mainObjectCollection
                      ._objectCollection![
                          tempReferenceHolder.reference!.objectCollectionIndex!]
                      ._object;
                  tempReferenceHolder = _PdfReferenceHolder(tempObject);
                  tempDictionary.setProperty(
                      _DictionaryProperties.data, tempReferenceHolder);
                }
              }
            }
          }
        }
        signatureDictionary.remove(_DictionaryProperties.byteRange);
        _PdfSignatureDictionary._fromDictionary(
            _crossTable!._document!, signatureDictionary);
        _dictionary.remove(_DictionaryProperties.contents);
        _dictionary.remove(_DictionaryProperties.byteRange);
      }
      if (signatureDictionary.containsKey(_DictionaryProperties.m) &&
          signatureDictionary[_DictionaryProperties.m] is _PdfString) {
        _signature!._signedDate = _dictionary._getDateTime(
            signatureDictionary[_DictionaryProperties.m] as _PdfString);
      }
      if (signatureDictionary.containsKey(_DictionaryProperties.name) &&
          signatureDictionary[_DictionaryProperties.name] is _PdfString) {
        _signature!.signedName =
            (signatureDictionary[_DictionaryProperties.name] as _PdfString)
                .value;
      }
      if (signatureDictionary.containsKey(_DictionaryProperties.reason)) {
        final _IPdfPrimitive? reason = _PdfCrossTable._dereference(
            signatureDictionary[_DictionaryProperties.reason]);
        if (reason != null && reason is _PdfString) {
          _signature!.reason = reason.value;
        }
      }
      if (signatureDictionary.containsKey(_DictionaryProperties.location)) {
        final _IPdfPrimitive? location = _PdfCrossTable._dereference(
            signatureDictionary[_DictionaryProperties.location]);
        if (location != null && location is _PdfString) {
          _signature!.locationInfo = location.value;
        }
      }
      if (signatureDictionary.containsKey(_DictionaryProperties.contactInfo)) {
        final _IPdfPrimitive? contactInfo = _PdfCrossTable._dereference(
            signatureDictionary[_DictionaryProperties.contactInfo]);
        if (contactInfo != null && contactInfo is _PdfString) {
          _signature!.contactInfo = contactInfo.value;
        }
      }
      if (signatureDictionary.containsKey(_DictionaryProperties.byteRange)) {
        _signature!._byteRange =
            signatureDictionary[_DictionaryProperties.byteRange] as _PdfArray?;
        if (_crossTable!.documentCatalog != null) {
          final _PdfDictionary catalog = _crossTable!._documentCatalog!;
          bool hasPermission = false;
          if (catalog.containsKey(_DictionaryProperties.perms)) {
            final _IPdfPrimitive? primitive =
                catalog[_DictionaryProperties.perms];
            final _IPdfPrimitive? catalogDictionary =
                (primitive is _PdfReferenceHolder)
                    ? primitive.object
                    : primitive;
            if (catalogDictionary != null &&
                catalogDictionary is _PdfDictionary &&
                catalogDictionary.containsKey(_DictionaryProperties.docMDP)) {
              final _IPdfPrimitive? docPermission =
                  catalogDictionary[_DictionaryProperties.docMDP];
              final _IPdfPrimitive? permissionDictionary =
                  (docPermission is _PdfReferenceHolder)
                      ? docPermission.object
                      : docPermission;
              if (permissionDictionary != null &&
                  permissionDictionary is _PdfDictionary &&
                  permissionDictionary
                      .containsKey(_DictionaryProperties.byteRange)) {
                final _IPdfPrimitive? byteRange = _PdfCrossTable._dereference(
                    permissionDictionary[_DictionaryProperties.byteRange]);
                bool isValid = true;
                if (byteRange != null &&
                    byteRange is _PdfArray &&
                    _signature != null &&
                    _signature!._byteRange != null) {
                  for (int i = 0; i < byteRange.count; i++) {
                    final _IPdfPrimitive? byteValue = byteRange[i];
                    final _IPdfPrimitive? signByte = _signature!._byteRange![i];
                    if (byteValue != null &&
                        signByte != null &&
                        byteValue is _PdfNumber &&
                        signByte is _PdfNumber &&
                        byteValue.value != signByte.value) {
                      isValid = false;
                      break;
                    }
                  }
                }

                hasPermission = isValid;
              }
            }
          }
          if (hasPermission &&
              signatureDictionary
                  .containsKey(_DictionaryProperties.reference)) {
            _IPdfPrimitive? primitive =
                signatureDictionary[_DictionaryProperties.reference];
            if (primitive is _PdfArray) {
              primitive = primitive._elements[0];
            }
            _IPdfPrimitive? reference = (primitive is _PdfReferenceHolder)
                ? primitive.object
                : primitive;
            if (reference != null &&
                reference is _PdfDictionary &&
                reference.containsKey('TransformParams')) {
              primitive = reference['TransformParams'];
              if (primitive is _PdfReferenceHolder) {
                reference = primitive.object as _PdfDictionary;
              } else if (primitive is _PdfDictionary) {
                reference = primitive;
              }
              if (reference is _PdfDictionary &&
                  reference.containsKey(_DictionaryProperties.p)) {
                final _IPdfPrimitive? permissionNumber =
                    _PdfCrossTable._dereference(
                        reference[_DictionaryProperties.p]);
                if (permissionNumber != null &&
                    permissionNumber is _PdfNumber) {
                  _signature!.documentPermissions = _signature!
                      ._getCertificateFlags(permissionNumber.value as int);
                }
              }
            }
          }
        }
      }
    }
  }
}
