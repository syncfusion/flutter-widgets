part of pdf;

/// The [PdfLayer] used to create layers in PDF document.
class PdfLayer implements _IPdfWrapper {
  // Constructor
  PdfLayer._() {
    _clipPageTemplates = true;
    _content = _PdfStream();
    _dictionary = _PdfDictionary();
  }

  // Fields
  bool _clipPageTemplates = true;
  _PdfStream? _content;
  PdfGraphics? _graphics;
  PdfLayer? _layer;
  String? _layerId;
  _PdfReferenceHolder? _referenceHolder;
  final Map<PdfGraphics, PdfGraphics> _graphicsMap =
      <PdfGraphics, PdfGraphics>{};
  final Map<PdfPage, PdfGraphics> _pageGraphics = <PdfPage, PdfGraphics>{};
  bool _isEmptyLayer = false;
  final List<PdfLayer> _parentLayer = <PdfLayer>[];
  String? _name;
  bool _visible = true;
  _PdfDictionary? _dictionary;
  bool _isEndState = false;
  final List<PdfPage> _pages = <PdfPage>[];
  PdfPage? _page;
  PdfDocument? _document;
  PdfLayerCollection? _layerCollection;
  _PdfDictionary? _printOption;
  _PdfDictionary? _usage;
  PdfLayer? _parent;
  final List<PdfLayer> _child = <PdfLayer>[];
  final _PdfArray _sublayer = _PdfArray();
  final List<String> _xobject = <String>[];
  bool _pageParsed = false;
  bool? _isPresent;

  // Properties
  /// Gets the name of the layer
  String? get name => _name;

  /// Sets the name of the layer
  set name(String? value) {
    _name = value;
    if (_dictionary != null && _name != null && _name != '') {
      _dictionary!.setProperty(_DictionaryProperties.name, _PdfString(_name!));
    }
  }

  /// Gets the visibility of the page layer.
  bool get visible {
    if (_dictionary != null &&
        _dictionary!.containsKey(_DictionaryProperties.visible)) {
      _visible =
          (_dictionary![_DictionaryProperties.visible] as _PdfBoolean).value!;
    }
    return _visible;
  }

  /// Sets the visibility of the page layer.
  set visible(bool value) {
    _visible = value;
    if (_dictionary != null) {
      _dictionary![_DictionaryProperties.visible] = _PdfBoolean(value);
    }
  }

  /// Gets the collection of child [PdfLayer]
  PdfLayerCollection get layers {
    _layerCollection ??= PdfLayerCollection._withLayer(_document, _layer);
    return _layerCollection!;
  }

  // Implementation
  /// Initializes Graphics context of the layer.
  PdfGraphics createGraphics(PdfPage page) {
    _page = page;
    if (_graphics == null) {
      page._contents._add(_PdfReferenceHolder(_layer));
    }
    final _PdfResources? resource = page._getResources();
    if (_layer!._layerId == null || _layer!._layerId!.isEmpty) {
      _layer!._layerId = 'OCG_' + _PdfResources._globallyUniqueIdentifier;
    }
    if (resource != null &&
        resource.containsKey(_DictionaryProperties.properties)) {
      final _PdfDictionary? propertie =
          resource[_DictionaryProperties.properties] as _PdfDictionary?;
      if (propertie != null) {
        if (_layer!._layerId![0] == '/') {
          _layer!._layerId = _layer!._layerId!.substring(1);
        }
        propertie[_layer!._layerId] = _layer!._referenceHolder;
      } else {
        resource._properties[_layer!._layerId] = _layer!._referenceHolder;
        resource[_DictionaryProperties.properties] = resource._properties;
      }
    } else {
      resource!._properties[_layer!._layerId] = _layer!._referenceHolder;
      resource[_DictionaryProperties.properties] = resource._properties;
    }

    if (_graphics == null) {
      final Function resources = page._getResources;
      bool isPageHasMediaBox = false;
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
      if (mediaBox != null) {
        // Lower Left X co-ordinate Value.
        llx = (mediaBox[0] as _PdfNumber).value!.toDouble();
        // Lower Left Y co-ordinate value.
        lly = (mediaBox[1] as _PdfNumber).value!.toDouble();
        // Upper right X co-ordinate value.
        urx = (mediaBox[2] as _PdfNumber).value!.toDouble();
        // Upper right Y co-ordinate value.
        ury = (mediaBox[3] as _PdfNumber).value!.toDouble();
      }
      _PdfArray? cropBox;
      if (page._dictionary.containsKey(_DictionaryProperties.cropBox)) {
        cropBox = page._dictionary._getValue(
                _DictionaryProperties.cropBox, _DictionaryProperties.parent)
            as _PdfArray?;
        final double cropX = (cropBox![0] as _PdfNumber).value!.toDouble();
        final double cropY = (cropBox[1] as _PdfNumber).value!.toDouble();
        final double cropRX = (cropBox[2] as _PdfNumber).value!.toDouble();
        final double cropRY = (cropBox[3] as _PdfNumber).value!.toDouble();
        if ((cropX < 0 || cropY < 0 || cropRX < 0 || cropRY < 0) &&
            (cropY.abs().floor() == page.size.height.abs().floor()) &&
            (cropX.abs().floor()) == page.size.width.abs().floor()) {
          final Size pageSize =
              Size([cropX, cropRX].reduce(max), [cropY, cropRY].reduce(max));
          _graphics = PdfGraphics._(pageSize, resources, _content!);
        } else {
          _graphics = PdfGraphics._(page.size, resources, _content!);
          _graphics!._cropBox = cropBox;
        }
      } else if ((llx < 0 || lly < 0 || urx < 0 || ury < 0) &&
          (lly.abs().floor() == page.size.height.abs().floor()) &&
          (urx.abs().floor() == page.size.width.abs().floor())) {
        final Size pageSize =
            Size([llx, urx].reduce(max), [lly, ury].reduce(max));
        if (pageSize.width <= 0 || pageSize.height <= 0) {
          _graphics = PdfGraphics._(pageSize, resources, _content!);
        }
      } else {
        _graphics = PdfGraphics._(page.size, resources, _content!);
      }
      if (isPageHasMediaBox) {
        _graphics!._mediaBoxUpperRightBound = ury;
      }
      if (!page._isLoadedPage) {
        final PdfSectionCollection? sectionCollection = page._section!._parent;
        if (sectionCollection != null) {
          _graphics!.colorSpace = sectionCollection._document!.colorSpace;
        }
      }
      if (!_graphicsMap.containsKey(_graphics)) {
        _graphicsMap[_graphics!] = _graphics!;
      }
      if (!_pageGraphics.containsKey(page)) {
        _pageGraphics[page] = _graphics!;
      }
      _content!._beginSave = _beginSaveContent;
    } else {
      if (!_pages.contains(page)) {
        _graphicsContent(page);
      } else if (_pageGraphics.containsKey(page)) {
        _graphics = _pageGraphics[page];
        return _graphics!;
      }
    }
    _graphics!._streamWriter!._write(_Operators.newLine);
    _graphics!.save();
    _graphics!._initializeCoordinates();
    if (_graphics!._hasTransparencyBrush) {
      _graphics!._setTransparencyGroup(page);
    }
    if (page._isLoadedPage &&
        (page._rotation != PdfPageRotateAngle.rotateAngle0 ||
            page._dictionary.containsKey(_DictionaryProperties.rotate))) {
      _PdfArray? cropBox;
      if (page._dictionary.containsKey(_DictionaryProperties.cropBox)) {
        cropBox = page._dictionary._getValue(
                _DictionaryProperties.cropBox, _DictionaryProperties.parent)
            as _PdfArray?;
      }
      _updatePageRotation(page, _graphics, cropBox);
    }
    if (!page._isLoadedPage) {
      final _Rectangle clipRect = page._section!._getActualBounds(page, true);
      if (_clipPageTemplates) {
        if (page._origin.dx >= 0 && page._origin.dy >= 0) {
          _graphics!._clipTranslateMarginsWithBounds(clipRect);
        }
      } else {
        final PdfMargins margins = page._section!.pageSettings.margins;
        _graphics!._clipTranslateMargins(clipRect.x, clipRect.y, margins.left,
            margins.top, margins.right, margins.bottom);
      }
    }
    if (!_pages.contains(page)) {
      _pages.add(page);
    }
    _graphics!._setLayer(null, this);
    return _graphics!;
  }

  void _updatePageRotation(
      PdfPage page, PdfGraphics? graphics, _PdfArray? cropBox) {
    _PdfNumber? rotation;
    if (page._dictionary.containsKey(_DictionaryProperties.rotate)) {
      rotation = page._dictionary[_DictionaryProperties.rotate] as _PdfNumber?;
      rotation ??= rotation = _PdfCrossTable._dereference(
          page._dictionary[_DictionaryProperties.rotate]) as _PdfNumber?;
    } else if (page._rotation != PdfPageRotateAngle.rotateAngle0) {
      if (page._rotation == PdfPageRotateAngle.rotateAngle90) {
        rotation = _PdfNumber(90);
      } else if (page._rotation == PdfPageRotateAngle.rotateAngle180) {
        rotation = _PdfNumber(180);
      } else if (page._rotation == PdfPageRotateAngle.rotateAngle270) {
        rotation = _PdfNumber(270);
      }
    }
    if (rotation!.value == 90) {
      graphics!.translateTransform(0, page.size.height);
      graphics.rotateTransform(-90);
      if (cropBox != null) {
        final double height = (cropBox[3] as _PdfNumber).value!.toDouble();
        final Size cropBoxSize = Size(
            (cropBox[2] as _PdfNumber).value!.toDouble(),
            height != 0
                ? height
                : (cropBox[1] as _PdfNumber).value!.toDouble());
        final Offset cropBoxOffset = Offset(
            (cropBox[0] as _PdfNumber).value!.toDouble(),
            (cropBox[1] as _PdfNumber).value!.toDouble());
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

  void _graphicsContent(PdfPage page) {
    final _PdfStream stream = _PdfStream();
    _graphics = PdfGraphics._(page.size, page._getResources, stream);
    page._contents._add(_PdfReferenceHolder(stream));
    stream._beginSave = _beginSaveContent;
    if (!_graphicsMap.containsKey(_graphics)) {
      _graphicsMap[_graphics!] = _graphics!;
    }
    if (!_pageGraphics.containsKey(page)) {
      _pageGraphics[page] = _graphics!;
    }
  }

  void _beginSaveContent(Object sender, _SavePdfPrimitiveArgs? e) {
    bool flag = false;
    PdfGraphics? keyValue;
    _graphicsMap.forEach((PdfGraphics? key, PdfGraphics? values) {
      if (!flag) {
        _graphics = key;
        if (!_isEmptyLayer) {
          _beginLayer(_graphics);
          _graphics!._endMarkContent();
        }
        _graphics!._streamWriter!
            ._write(_Operators.restoreState + _Operators.newLine);
        keyValue = key;
        flag = true;
      }
    });
    if (keyValue != null) {
      _graphicsMap.remove(keyValue);
    }
  }

  void _beginLayer(PdfGraphics? currentGraphics) {
    if (_graphicsMap.containsKey(currentGraphics)) {
      _graphics = _graphicsMap[currentGraphics];
    } else {
      _graphics = currentGraphics;
    }
    if (_graphics != null) {
      if (_name != null && _name != '') {
        _isEmptyLayer = true;
        if (_parentLayer.isNotEmpty) {
          for (int i = 0; i < _parentLayer.length; i++) {
            _graphics!._streamWriter!
                ._write('/OC /' + _parentLayer[i]._layerId! + ' BDC\n');
          }
        }
        if (name != null && name != '') {
          _graphics!._streamWriter!._write('/OC /' + _layerId! + ' BDC\n');
          _isEndState = true;
        } else {
          _content!._write('/OC /' + _layerId! + ' BDC\n');
        }
      }
    }
  }

  void _parsingLayerPage() {
    if (_document != null && _document!._isLoadedDocument) {
      for (int i = 0; i < _document!.pages.count; i++) {
        final _PdfDictionary pageDictionary = _document!.pages[i]._dictionary;
        final PdfPage? page = _document!.pages[i];
        if (pageDictionary.containsKey(_DictionaryProperties.resources)) {
          final _PdfDictionary? resources = _PdfCrossTable._dereference(
                  pageDictionary[_DictionaryProperties.resources])
              as _PdfDictionary?;
          if (resources != null &&
                  (resources.containsKey(_DictionaryProperties.properties)) ||
              (resources!.containsKey(_DictionaryProperties.xObject))) {
            final _PdfDictionary? properties = _PdfCrossTable._dereference(
                resources[_DictionaryProperties.properties]) as _PdfDictionary?;
            final _PdfDictionary? xObject = _PdfCrossTable._dereference(
                resources[_DictionaryProperties.xObject]) as _PdfDictionary?;
            if (properties != null) {
              properties._items!
                  .forEach((_PdfName? key, _IPdfPrimitive? value) {
                if (value is _PdfReferenceHolder) {
                  final _PdfDictionary? dictionary =
                      value.object as _PdfDictionary?;
                  _parsingDictionary(dictionary, value, page, key);
                }
              });
              if (properties._items!.isEmpty) {
                _pageParsed = true;
              }
            }
            if (xObject != null) {
              xObject._items!.forEach((_PdfName? key, _IPdfPrimitive? value) {
                _PdfReferenceHolder reference = value as _PdfReferenceHolder;
                _PdfDictionary dictionary = reference.object as _PdfDictionary;
                if (dictionary.containsKey('OC')) {
                  final _PdfName? layerID = key;
                  reference = dictionary['OC'] as _PdfReferenceHolder;
                  dictionary = _PdfCrossTable._dereference(dictionary['OC'])
                      as _PdfDictionary;
                  final bool isPresent =
                      _parsingDictionary(dictionary, reference, page, layerID)!;
                  if (isPresent) {
                    _layer!._xobject.add(layerID!._name!);
                  }
                }
              });
              if (xObject._items!.isEmpty) {
                _pageParsed = true;
              }
            }
          }
        }
      }
    }
  }

  bool? _parsingDictionary(_PdfDictionary? dictionary,
      _PdfReferenceHolder? reference, PdfPage? page, _PdfName? layerID) {
    if (_isPresent == null || !_isPresent!) {
      _isPresent = false;
      if (!dictionary!.containsKey(_DictionaryProperties.name) &&
          dictionary.containsKey(_DictionaryProperties.ocg)) {
        if (dictionary.containsKey(_DictionaryProperties.ocg)) {
          final _PdfArray? pdfArray =
              _PdfCrossTable._dereference(dictionary[_DictionaryProperties.ocg])
                  as _PdfArray?;
          if (pdfArray == null) {
            reference =
                dictionary[_DictionaryProperties.ocg] as _PdfReferenceHolder?;
            dictionary = _PdfCrossTable._dereference(
                dictionary[_DictionaryProperties.ocg]) as _PdfDictionary?;
            if (dictionary != null &&
                dictionary.containsKey(_DictionaryProperties.name)) {
              _isPresent = _setLayerPage(reference, page, layerID);
            }
          } else {
            for (int a = 0; a < pdfArray.count; a++) {
              if (pdfArray[a] is _PdfReferenceHolder) {
                reference = pdfArray[a] as _PdfReferenceHolder;
                dictionary = reference.object as _PdfDictionary?;
                _isPresent = _setLayerPage(reference, page, layerID);
              }
            }
          }
        }
      } else if (dictionary.containsKey(_DictionaryProperties.name)) {
        _isPresent = _setLayerPage(reference, page, layerID);
      }
      return _isPresent;
    } else {
      return false;
    }
  }

  bool _setLayerPage(
      _PdfReferenceHolder? reference, PdfPage? page, _PdfName? layerID) {
    bool isPresent = false;
    if (_layer!._referenceHolder != null) {
      if (identical(_layer!._referenceHolder, reference) ||
          identical(_layer!._referenceHolder!._object, reference!._object) ||
          _layer!._referenceHolder?.reference?._objNum ==
              reference.reference?._objNum) {
        _layer!._pageParsed = true;
        isPresent = true;
        _layer!._layerId = layerID!._name;
        _layer!._page = page;
        if (!_layer!._pages.contains(page)) {
          _layer!._pages.add(page!);
        }
      }
    }
    return isPresent;
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
