part of pdf;

/// The [PdfPageLayer] used to create layers in PDF document.
/// Layers refers to sections of content in a PDF document that can be
/// selectively viewed or hidden by document authors or consumers.
class PdfPageLayer implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfPageLayer] class
  /// with specified PDF page.
  PdfPageLayer(PdfPage pdfPage) {
    _initialize(pdfPage, true);
  }

  PdfPageLayer._fromClipPageTemplate(PdfPage pdfPage,
      [bool? clipPageTemplates]) {
    _initialize(pdfPage, clipPageTemplates);
  }

  //Fields
  _PdfStream? _content;
  late PdfPage _page;
  bool? _clipPageTemplates;

  String? _name;
  PdfGraphics? _graphics;
  //ignore:unused_field
  PdfColorSpace? _colorSpace;
  PdfGraphicsState? _graphicsState;
  bool _isEndState = false;
  bool _isSaved = false;
  _PdfDictionary? _dictionary;
  bool _visible = true;
  String? _layerID;
  _PdfDictionary? _printOption;
  _PdfDictionary? _usage;
  _PdfReferenceHolder? _referenceHolder;

  //Properties
  /// Gets parent page of the layer.
  PdfPage get page => _page;

  /// Gets Graphics context of the layer, used to draw various graphical
  /// content on layer.
  PdfGraphics get graphics {
    if (_graphics == null || _isSaved) {
      _initializeGraphics(page);
    }
    return _graphics!;
  }

  /// Gets the name of the layer
  String? get name {
    return _name;
  }

  /// Sets the name of the layer
  set name(String? value) {
    if (value != null) {
      _name = value;
      _layerID ??= 'OCG_' + _PdfResources._globallyUniqueIdentifier;
    }
  }

  /// Gets the visibility of the page layer.
  bool get visible {
    if (_dictionary != null &&
        _dictionary!.containsKey(_DictionaryProperties.visible)) {
      _visible =
          (_dictionary![_DictionaryProperties.visible]! as _PdfBoolean).value!;
    }
    return _visible;
  }

  /// Sets the visibility of the page layer.
  set visible(bool value) {
    _visible = value;
    if (_dictionary != null) {
      _dictionary![_DictionaryProperties.visible] = _PdfBoolean(value);
    }
    _setVisibility(_visible);
  }

  //Implementation
  void _initialize(PdfPage? pdfPage, bool? clipPageTemplates) {
    if (pdfPage != null) {
      _page = pdfPage;
    } else {
      throw ArgumentError.value(pdfPage, 'page');
    }
    _clipPageTemplates = clipPageTemplates;
    _content = _PdfStream();
    _dictionary = _PdfDictionary();
  }

  void _initializeGraphics(PdfPage? page) {
    if (_graphics == null) {
      final Function resources = page!._getResources;
      bool isPageHasMediaBox = false;
      bool isInvalidSize = false;
      if (page._dictionary
          .containsKey(_PdfName(_DictionaryProperties.mediaBox))) {
        isPageHasMediaBox = true;
      }
      double llx = 0;
      double lly = 0;
      double urx = 0;
      double ury = 0;
      final _PdfArray? mediaBox = page._dictionary._getValue(
              _DictionaryProperties.mediaBox, _DictionaryProperties.parent)
          as _PdfArray?;
      final _PdfReferenceHolder referenceHolder = _PdfReferenceHolder(this);
      if (mediaBox != null) {
        // Lower Left X co-ordinate Value.
        llx = (mediaBox[0]! as _PdfNumber).value!.toDouble();
        // Lower Left Y co-ordinate value.
        lly = (mediaBox[1]! as _PdfNumber).value!.toDouble();
        // Upper right X co-ordinate value.
        urx = (mediaBox[2]! as _PdfNumber).value!.toDouble();
        // Upper right Y co-ordinate value.
        ury = (mediaBox[3]! as _PdfNumber).value!.toDouble();
      }
      _PdfArray? cropBox;
      if (page._dictionary.containsKey(_DictionaryProperties.cropBox)) {
        cropBox = page._dictionary._getValue(
                _DictionaryProperties.cropBox, _DictionaryProperties.parent)
            as _PdfArray?;
        final double cropX = (cropBox![0]! as _PdfNumber).value!.toDouble();
        final double cropY = (cropBox[1]! as _PdfNumber).value!.toDouble();
        final double cropRX = (cropBox[2]! as _PdfNumber).value!.toDouble();
        final double cropRY = (cropBox[3]! as _PdfNumber).value!.toDouble();
        if ((cropX < 0 || cropY < 0 || cropRX < 0 || cropRY < 0) &&
            (cropY.abs().floor() == page.size.height.abs().floor()) &&
            (cropX.abs().floor()) == page.size.width.abs().floor()) {
          final Size pageSize = Size(<double>[cropX, cropRX].reduce(max),
              <double>[cropY, cropRY].reduce(max));
          _graphics = PdfGraphics._(pageSize, resources, _content!);
          if (!page._contents._contains(referenceHolder) &&
              !page._isDefaultGraphics &&
              !_isContainsPageContent(page._contents, referenceHolder)) {
            page._contents._add(referenceHolder);
          }
        } else {
          _graphics = PdfGraphics._(page.size, resources, _content!);
          _graphics!._cropBox = cropBox;
          if (!page._contents._contains(referenceHolder) &&
              !page._isDefaultGraphics &&
              !_isContainsPageContent(page._contents, referenceHolder)) {
            page._contents._add(referenceHolder);
          }
        }
      } else if ((llx < 0 || lly < 0 || urx < 0 || ury < 0) &&
          (lly.abs().floor() == page.size.height.abs().floor()) &&
          (urx.abs().floor() == page.size.width.abs().floor())) {
        Size pageSize = Size(
            <double>[llx, urx].reduce(max), <double>[lly, ury].reduce(max));
        if (pageSize.width <= 0 || pageSize.height <= 0) {
          isInvalidSize = true;
          if (llx < 0) {
            llx = -llx;
          } else if (urx < 0) {
            urx = -urx;
          }
          if (lly < 0) {
            lly = -lly;
          } else if (ury < 0) {
            ury = -ury;
          }
          pageSize = Size(
              <double>[llx, urx].reduce(max), <double>[lly, ury].reduce(max));
          _graphics = PdfGraphics._(pageSize, resources, _content!);
          if (!page._contents._contains(referenceHolder) &&
              !page._isDefaultGraphics &&
              !_isContainsPageContent(page._contents, referenceHolder)) {
            page._contents._add(referenceHolder);
          }
        }
      } else {
        _graphics = PdfGraphics._(page.size, resources, _content!);
        if (!page._contents._contains(referenceHolder) &&
            !page._isDefaultGraphics &&
            !_isContainsPageContent(page._contents, referenceHolder)) {
          page._contents._add(referenceHolder);
        }
      }

      if (isPageHasMediaBox) {
        _graphics!._mediaBoxUpperRightBound = isInvalidSize ? -lly : ury;
      }
      if (!page._isLoadedPage) {
        final PdfSectionCollection? sectionCollection = page._section!._parent;
        if (sectionCollection != null) {
          _graphics!.colorSpace = sectionCollection._document!.colorSpace;
          _colorSpace = sectionCollection._document!.colorSpace;
        }
      }
      _content!._beginSave = _beginSaveContent;
    }
    _graphicsState = _graphics!.save();
    if (name != null && name!.isNotEmpty) {
      _graphics!._streamWriter!._write('/OC /' + _layerID! + ' BDC\n');
      _isEndState = true;
    }
    _graphics!._initializeCoordinates();
    if (_graphics!._hasTransparencyBrush) {
      _graphics!._setTransparencyGroup(page!);
    }
    if (page != null &&
        !page._isLoadedPage &&
        (page.rotation != PdfPageRotateAngle.rotateAngle0 ||
            page._dictionary.containsKey(_DictionaryProperties.rotate))) {
      _PdfArray? cropBox;
      if (page._dictionary.containsKey(_DictionaryProperties.cropBox)) {
        cropBox = page._dictionary._getValue(
                _DictionaryProperties.cropBox, _DictionaryProperties.parent)
            as _PdfArray?;
      }
      _updatePageRotation(page, _graphics, cropBox);
    }
    if (page != null && !page._isLoadedPage) {
      final _Rectangle clipRect = page._section!._getActualBounds(page, true);
      if (_clipPageTemplates!) {
        if (page._origin.dx >= 0 && page._origin.dy >= 0) {
          _graphics!._clipTranslateMarginsWithBounds(clipRect);
        }
      } else {
        final PdfMargins margins = page._section!.pageSettings.margins;
        _graphics!._clipTranslateMargins(clipRect.x, clipRect.y, margins.left,
            margins.top, margins.right, margins.bottom);
      }
    }
    _graphics!._setLayer(this);
    _isSaved = false;
  }

  void _updatePageRotation(
      PdfPage page, PdfGraphics? graphics, _PdfArray? cropBox) {
    _PdfNumber? rotation;
    if (page._dictionary.containsKey(_DictionaryProperties.rotate)) {
      rotation = page._dictionary[_DictionaryProperties.rotate] as _PdfNumber?;
      rotation ??= rotation = _PdfCrossTable._dereference(
          page._dictionary[_DictionaryProperties.rotate]) as _PdfNumber?;
    } else if (page.rotation != PdfPageRotateAngle.rotateAngle0) {
      if (page.rotation == PdfPageRotateAngle.rotateAngle90) {
        rotation = _PdfNumber(90);
      } else if (page.rotation == PdfPageRotateAngle.rotateAngle180) {
        rotation = _PdfNumber(180);
      } else if (page.rotation == PdfPageRotateAngle.rotateAngle270) {
        rotation = _PdfNumber(270);
      }
    }
    if (rotation!.value == 90) {
      graphics!.translateTransform(0, page.size.height);
      graphics.rotateTransform(-90);
      if (cropBox != null) {
        final double height = (cropBox[3]! as _PdfNumber).value!.toDouble();
        final Size cropBoxSize = Size(
            (cropBox[2]! as _PdfNumber).value!.toDouble(),
            height != 0
                ? height
                : (cropBox[1]! as _PdfNumber).value!.toDouble());
        final Offset cropBoxOffset = Offset(
            (cropBox[0]! as _PdfNumber).value!.toDouble(),
            (cropBox[1]! as _PdfNumber).value!.toDouble());
        if (page.size.height < cropBoxSize.height) {
          graphics._clipBounds.size = _Size(page.size.height - cropBoxOffset.dy,
              cropBoxSize.width - cropBoxOffset.dx);
        } else {
          graphics._clipBounds.size = _Size(
              cropBoxSize.height - cropBoxOffset.dy,
              cropBoxSize.width - cropBoxOffset.dx);
        }
      } else {
        graphics._clipBounds.size = _Size(page.size.height, page.size.width);
      }
    } else if (rotation.value == 180) {
      graphics!.translateTransform(page.size.width, page.size.height);
      graphics.rotateTransform(-180);
    } else if (rotation.value == 270) {
      graphics!.translateTransform(page.size.width, 0);
      graphics.rotateTransform(-270);
      graphics._clipBounds.size = _Size(page.size.height, page.size.width);
    }
  }

  void _beginSaveContent(Object sender, _SavePdfPrimitiveArgs? args) {
    if (_graphicsState != null) {
      if (_isEndState) {
        graphics._streamWriter!._write('EMC\n');
        _isEndState = false;
      }
      graphics.restore(_graphicsState);
      _graphicsState = null;
    }
    _isSaved = true;
  }

  void _setVisibility(bool? value) {
    _PdfDictionary? oCProperties;
    if (_page._document!._catalog
        .containsKey(_DictionaryProperties.ocProperties)) {
      oCProperties = _PdfCrossTable._dereference(
              _page._document!._catalog[_DictionaryProperties.ocProperties])
          as _PdfDictionary?;
    }
    if (oCProperties != null) {
      final _PdfDictionary? defaultView =
          oCProperties[_DictionaryProperties.defaultView] as _PdfDictionary?;
      if (defaultView != null) {
        _PdfArray? ocgON =
            defaultView[_DictionaryProperties.ocgOn] as _PdfArray?;
        _PdfArray? ocgOFF =
            defaultView[_DictionaryProperties.ocgOff] as _PdfArray?;
        if (_referenceHolder != null) {
          if (value == false) {
            if (ocgON != null) {
              _removeContent(ocgON, _referenceHolder);
            }
            if (ocgOFF == null) {
              ocgOFF = _PdfArray();
              defaultView._items![_PdfName(_DictionaryProperties.ocgOff)] =
                  ocgOFF;
            }
            ocgOFF._insert(ocgOFF.count, _referenceHolder!);
          } else if (value == true) {
            if (ocgOFF != null) {
              _removeContent(ocgOFF, _referenceHolder);
            }
            if (ocgON == null) {
              ocgON = _PdfArray();
              defaultView._items![_PdfName(_DictionaryProperties.ocgOn)] =
                  ocgON;
            }
            ocgON._insert(ocgON.count, _referenceHolder!);
          }
        }
      }
    }
  }

  bool _isContainsPageContent(
      _PdfArray content, _PdfReferenceHolder referenceHolder) {
    for (int i = 0; i < content.count; i++) {
      final _IPdfPrimitive? primitive = content._elements[i];
      if (primitive != null && primitive is _PdfReferenceHolder) {
        final _PdfReferenceHolder holder = primitive;
        if (holder.reference != null && referenceHolder.reference != null) {
          if (holder.reference!._objNum == referenceHolder.reference!._objNum) {
            return true;
          }
        } else {
          if (identical(holder, referenceHolder)) {
            return true;
          } else if (identical(holder._object, referenceHolder._object)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _removeContent(_PdfArray content, _PdfReferenceHolder? referenceHolder) {
    bool flag = false;
    for (int i = 0; i < content.count; i++) {
      final _IPdfPrimitive? primitive = content._elements[i];
      if (primitive != null && primitive is _PdfReferenceHolder) {
        final _PdfReferenceHolder holder = primitive;
        if (holder.reference != null && referenceHolder!.reference != null) {
          if (holder.reference!._objNum == referenceHolder.reference!._objNum) {
            content._elements.removeAt(i);
            flag = true;
            i--;
          }
        }
      }
    }
    if (flag) {
      content._isChanged = true;
    }
  }

  //_IPdfWrapper elements
  @override
  _IPdfPrimitive? get _element => _content;
  @override
  //ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _content = value as _PdfStream?;
  }
}
