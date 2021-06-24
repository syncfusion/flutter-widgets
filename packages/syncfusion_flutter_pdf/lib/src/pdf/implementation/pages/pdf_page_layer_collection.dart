part of pdf;

/// The class provides methods and properties
/// to handle the collections of [PdfPageLayer].
class PdfPageLayerCollection extends PdfObjectCollection {
  //Constructor
  /// Initializes a new instance of the
  /// [PdfPageLayerCollection] class with PDF page.
  PdfPageLayerCollection(PdfPage page) : super() {
    _optionalContent = _PdfDictionary();
    _subLayer = false;
    _page = page;
    _parseLayers(page);
  }

  //Fields
  late PdfPage _page;
  late bool _subLayer;
  _PdfDictionary? _optionalContent;
  int _bdcCount = 0;

  //Properties
  /// Gets [PdfPageLayer] by its index from [PdfPageLayerCollection].
  PdfPageLayer operator [](int index) => _returnValue(index);
  PdfPageLayer _returnValue(int index) {
    return _list[index] as PdfPageLayer;
  }

  //Public methods
  /// Creates a new [PdfPageLayer] and adds it to the end of the collection.
  PdfPageLayer add({String? name, bool? visible}) {
    final PdfPageLayer layer = PdfPageLayer(_page);
    if (name != null) {
      layer.name = name;
      layer._layerID ??= 'OCG_' + _PdfResources._globallyUniqueIdentifier;
    }
    if (visible != null) {
      layer.visible = visible;
    }
    addLayer(layer);
    return layer;
  }

  /// Adds [PdfPageLayer] to the collection.
  int addLayer(PdfPageLayer layer) {
    if (layer.page != _page) {
      ArgumentError.value(layer, 'The layer belongs to another page');
    }
    _list.add(layer);
    final int listIndex = count - 1;
    _page._contents._add(_PdfReferenceHolder(layer));
    if (layer._layerID != null) {
      if (_page._isLoadedPage) {
        _createLayerLoadedPage(layer);
      } else {
        final _PdfDictionary ocProperties = _PdfDictionary();
        ocProperties[_DictionaryProperties.ocg] =
            _createOptionContentDictionary(layer);
        ocProperties[_DictionaryProperties.defaultView] =
            _createOptionalContentViews(layer);
        _page._document!._catalog[_DictionaryProperties.ocProperties] =
            ocProperties;
      }
    }
    return listIndex;
  }

  /// Returns index of the [PdfPageLayer] in the collection if exists,
  /// -1 otherwise.
  int indexOf(PdfPageLayer layer) {
    return _list.indexOf(layer);
  }

  //Implementation
  void _parseLayers(PdfPage page) {
    if (!page._isTextExtraction) {
      final _PdfArray contents = page._contents;
      final _PdfDictionary? resource = _page._getResources();
      _PdfDictionary? ocProperties;
      _PdfDictionary? propertie;
      PdfPage? pdfLoaded;
      final Map<_PdfReferenceHolder?, PdfPageLayer> pageLayerCollection =
          <_PdfReferenceHolder?, PdfPageLayer>{};
      if (page._isLoadedPage) {
        pdfLoaded = page;
      }
      if (pdfLoaded != null) {
        propertie = _PdfCrossTable._dereference(
            resource![_DictionaryProperties.properties]) as _PdfDictionary?;
        if (pdfLoaded._document != null) {
          ocProperties = _PdfCrossTable._dereference(pdfLoaded._document!
              ._catalog[_DictionaryProperties.ocProperties]) as _PdfDictionary?;
        }
      }

      if (ocProperties != null && (propertie != null)) {
        propertie._items!.forEach((_PdfName? key, _IPdfPrimitive? value) {
          final _PdfReferenceHolder? layerReferenceHolder =
              value as _PdfReferenceHolder?;
          final _PdfDictionary? layerDictionary =
              _PdfCrossTable._dereference(value) as _PdfDictionary?;
          if ((layerDictionary != null && layerReferenceHolder != null) ||
              layerDictionary!.containsKey(_DictionaryProperties.ocg)) {
            _addLayer(page, layerDictionary, layerReferenceHolder, key!._name,
                pageLayerCollection, false);
          }
        });
      }
      if (ocProperties != null && pageLayerCollection.isNotEmpty) {
        _checkVisible(ocProperties, pageLayerCollection);
      }

      final _PdfStream saveStream = _PdfStream();
      final _PdfStream restoreStream = _PdfStream();
      const int saveState = 113;
      const int restoreState = 81;
      saveStream._dataStream = <int>[saveState];
      if (contents.count > 0) {
        contents._insert(0, _PdfReferenceHolder(saveStream));
      } else {
        contents._add(_PdfReferenceHolder(saveStream));
      }
      restoreStream._dataStream = <int>[restoreState];
      contents._add(_PdfReferenceHolder(restoreStream));
    }
  }

  List<int>? _combineContent(bool skipSave) {
    final bool decompress = _page._isLoadedPage;
    List<int>? combinedData;
    final List<int> end = <int>[13, 10];
    if (_page._isLoadedPage) {
      combinedData = _combineProcess(_page, decompress, end, skipSave);
    }
    return combinedData;
  }

  List<int> _combineProcess(
      PdfPage page, bool decompress, List<int> end, bool isTextExtraction) {
    final List<int> data = <int>[];
    for (int i = 0; i < page._contents.count; i++) {
      _PdfStream? layerStream;
      final _IPdfPrimitive? contentPrimitive = page._contents[i];
      if (contentPrimitive != null && contentPrimitive is _PdfReferenceHolder) {
        final _IPdfPrimitive? primitive = contentPrimitive.object;
        if (primitive != null && primitive is _PdfStream) {
          layerStream = primitive;
        }
      } else if (contentPrimitive != null && contentPrimitive is _PdfStream) {
        layerStream = contentPrimitive;
      }
      if (layerStream != null) {
        if (decompress) {
          final bool isChanged =
              layerStream._isChanged != null && layerStream._isChanged!;
          layerStream._decompress();
          layerStream._isChanged = isChanged || !isTextExtraction;
        }
        data.addAll(layerStream._dataStream!);
        data.addAll(end);
      }
    }
    return data;
  }

  void _createLayerLoadedPage(PdfPageLayer layer) {
    final _PdfDictionary ocProperties = _PdfDictionary();
    final _IPdfPrimitive? ocgroups = _createOptionContentDictionary(layer);
    bool isPresent = false;
    if (_page._document != null &&
        _page._document!._catalog
            .containsKey(_DictionaryProperties.ocProperties)) {
      final _PdfDictionary? ocDictionary = _PdfCrossTable._dereference(
              _page._document!._catalog[_DictionaryProperties.ocProperties])
          as _PdfDictionary?;
      if (ocDictionary != null &&
          ocDictionary.containsKey(_DictionaryProperties.ocg)) {
        final _PdfArray? ocgsList =
            _PdfCrossTable._dereference(ocDictionary[_DictionaryProperties.ocg])
                as _PdfArray?;
        if (ocgsList != null) {
          isPresent = true;
          if (!ocgsList._contains(layer._referenceHolder!)) {
            ocgsList._insert(ocgsList.count, layer._referenceHolder!);
          }
        }
        if (ocDictionary.containsKey(_DictionaryProperties.defaultView)) {
          final _PdfDictionary? defaultView =
              ocDictionary[_DictionaryProperties.defaultView]
                  as _PdfDictionary?;
          if (defaultView != null) {
            _PdfArray? _on = _PdfCrossTable._dereference(
                defaultView[_DictionaryProperties.ocgOn]) as _PdfArray?;
            final _PdfArray? order = _PdfCrossTable._dereference(
                defaultView[_DictionaryProperties.ocgOrder]) as _PdfArray?;
            _PdfArray? off = _PdfCrossTable._dereference(
                defaultView[_DictionaryProperties.ocgOff]) as _PdfArray?;
            final _PdfArray? usage = _PdfCrossTable._dereference(
                    defaultView[_DictionaryProperties.usageApplication])
                as _PdfArray?;

            if (_on == null) {
              _on = _PdfArray();
              defaultView[_DictionaryProperties.ocgOn] = _on;
            }

            if (!layer.visible && off == null) {
              off = _PdfArray();
              defaultView[_DictionaryProperties.ocgOff] = off;
            }

            if (order != null && !order._contains(layer._referenceHolder!)) {
              order._insert(order.count, layer._referenceHolder!);
            }

            if (layer.visible && !_on._contains(layer._referenceHolder!)) {
              _on._insert(_on.count, layer._referenceHolder!);
            }
            if (!layer.visible &&
                off != null &&
                !off._contains(layer._referenceHolder!)) {
              off._insert(off.count, layer._referenceHolder!);
            }

            if (usage != null && usage.count > 0) {
              final _PdfDictionary? asDictionary =
                  _PdfCrossTable._dereference(usage[0]) as _PdfDictionary?;
              if (asDictionary != null &&
                  asDictionary.containsKey(_DictionaryProperties.ocg)) {
                final _PdfArray? usageOcGroup = _PdfCrossTable._dereference(
                    asDictionary[_DictionaryProperties.ocg]) as _PdfArray?;
                if (usageOcGroup != null &&
                    !usageOcGroup._contains(layer._referenceHolder!)) {
                  usageOcGroup._insert(
                      usageOcGroup.count, layer._referenceHolder!);
                }
              }
            }
          }
        }
      }
    }
    if (!isPresent && _page._document != null) {
      ocProperties[_DictionaryProperties.ocg] = ocgroups;
      ocProperties[_DictionaryProperties.defaultView] =
          _createOptionalContentViews(layer);
      _page._document!._catalog
          .setProperty(_DictionaryProperties.ocProperties, ocProperties);
    }
  }

  _IPdfPrimitive? _createOptionContentDictionary(PdfPageLayer layer) {
    final _PdfDictionary optionalContent = _PdfDictionary();
    optionalContent[_DictionaryProperties.name] = _PdfString(layer.name!);
    optionalContent[_DictionaryProperties.type] = _PdfName('OCG');
    optionalContent[_DictionaryProperties.layerID] = _PdfName(layer._layerID);
    optionalContent[_DictionaryProperties.visible] = _PdfBoolean(layer.visible);
    layer._usage = _setPrintOption(layer);
    optionalContent[_DictionaryProperties.usage] =
        _PdfReferenceHolder(layer._usage);
    _page._document!._printLayer!._add(_PdfReferenceHolder(optionalContent));
    final _PdfReferenceHolder reference = _PdfReferenceHolder(optionalContent);
    _page._document!._primitive!._add(reference);
    layer._dictionary = optionalContent;
    layer._referenceHolder = reference;
    if (!_subLayer) {
      _page._document!._order!._add(reference);
      _page._document!._orderPosition = _page._document!._orderPosition! + 1;
    }
    if (layer.visible) {
      _page._document!._on!._add(reference);
      _page._document!._onPosition = _page._document!._onPosition! + 1;
    } else {
      _page._document!._off!._add(reference);
      _page._document!._offPosition = _page._document!._offPosition! + 1;
    }
    _page._document!._position = _page._document!._position! + 1;
    final _PdfResources? resource = _page._getResources();
    if (resource != null &&
        resource.containsKey(_DictionaryProperties.properties) &&
        _page._isLoadedPage) {
      final _PdfDictionary? dic =
          resource[_DictionaryProperties.properties] as _PdfDictionary?;
      if (dic != null) {
        dic[layer._layerID] = reference;
      } else {
        resource._properties[layer._layerID] = reference;
        resource[_DictionaryProperties.properties] = resource._properties;
      }
    } else {
      resource!._properties[layer._layerID] = reference;
      resource[_DictionaryProperties.properties] = resource._properties;
    }
    return _page._document!._primitive;
  }

  _PdfDictionary _setPrintOption(PdfPageLayer layer) {
    final _PdfDictionary _usage = _PdfDictionary();
    layer._printOption = _PdfDictionary();
    layer._printOption![_DictionaryProperties.subtype] = _PdfName('Print');
    _usage[_DictionaryProperties.print] =
        _PdfReferenceHolder(layer._printOption);
    return _usage;
  }

  _IPdfPrimitive? _createOptionalContentViews(PdfPageLayer layer) {
    final _PdfArray usageApplication = _PdfArray();
    _optionalContent![_DictionaryProperties.name] = _PdfString('Layers');
    _optionalContent![_DictionaryProperties.ocgOrder] = _page._document!._order;
    _optionalContent![_DictionaryProperties.ocgOn] = _page._document!._on;
    _optionalContent![_DictionaryProperties.ocgOff] = _page._document!._off;
    final _PdfArray category = _PdfArray();
    category._add(_PdfName('Print'));
    final _PdfDictionary applicationDictionary = _PdfDictionary();
    applicationDictionary[_DictionaryProperties.category] = category;
    applicationDictionary[_DictionaryProperties.ocg] =
        _page._document!._printLayer;
    applicationDictionary[_DictionaryProperties.event] = _PdfName('Print');
    usageApplication._add(_PdfReferenceHolder(applicationDictionary));
    if (_page._document!._conformanceLevel != PdfConformanceLevel.a2b &&
        _page._document!._conformanceLevel != PdfConformanceLevel.a3b) {
      _optionalContent![_DictionaryProperties.usageApplication] =
          usageApplication;
    }
    return _optionalContent;
  }

  void _addLayer(
      PdfPage page,
      _PdfDictionary dictionary,
      _PdfReferenceHolder? reference,
      String? key,
      Map<_PdfReferenceHolder?, PdfPageLayer> pageLayerCollection,
      bool isResourceLayer) {
    final PdfPageLayer layer = PdfPageLayer(page);
    _list.add(layer);
    if (!pageLayerCollection.containsKey(reference)) {
      pageLayerCollection[reference] = layer;
    }
    layer._dictionary = dictionary;
    layer._referenceHolder = reference;
    layer._layerID = key;
    if (dictionary.containsKey(_DictionaryProperties.name)) {
      final _PdfString? layerName =
          _PdfCrossTable._dereference(dictionary[_DictionaryProperties.name])
              as _PdfString?;
      if (layerName != null) {
        layer._name = layerName.value;
      }
    }
  }

  void _checkVisible(_PdfDictionary ocproperties,
      Map<_PdfReferenceHolder?, PdfPageLayer> layerDictionary) {
    final _PdfDictionary? defaultView = _PdfCrossTable._dereference(
        ocproperties[_DictionaryProperties.defaultView]) as _PdfDictionary?;
    if (defaultView != null) {
      final _PdfArray? visible =
          _PdfCrossTable._dereference(defaultView[_DictionaryProperties.ocgOff])
              as _PdfArray?;
      if (visible != null && layerDictionary.isNotEmpty) {
        for (int i = 0; i < visible.count; i++) {
          if (layerDictionary.containsKey(visible[i]! as _PdfReferenceHolder)) {
            final PdfPageLayer? pdfLayer =
                layerDictionary[visible[i]! as _PdfReferenceHolder];
            if (pdfLayer != null) {
              pdfLayer._visible = false;
              if (pdfLayer._dictionary != null &&
                  pdfLayer._dictionary!
                      .containsKey(_DictionaryProperties.visible)) {
                pdfLayer._dictionary!.setProperty(
                    _DictionaryProperties.visible, _PdfBoolean(false));
              }
            }
          }
        }
      }
    }
  }

  /// Removes layer from the collection.
  void remove({PdfPageLayer? layer, String? name}) {
    if (layer == null && name == null) {
      ArgumentError.value('layer or layerName required');
    }
    if (layer != null) {
      _removeLayer(layer);
      _list.remove(layer);
    } else {
      for (int i = 0; i < _list.length; i++) {
        final PdfPageLayer layer = _list[i] as PdfPageLayer;
        if (layer.name == name) {
          _removeLayer(layer);
          _list.remove(layer);
          break;
        }
      }
    }
  }

  /// Removes layer by its index from collections
  void removeAt(int index) {
    if (index < 0 || index > _list.length - 1) {
      ArgumentError.value(
          '$index Value can not be less 0 and greater List.Count - 1');
    }
    final PdfPageLayer layer = this[index];
    _removeLayer(layer);
    _list.removeAt(index);
  }

  /// Clears layers from the [PdfPageLayerCollection].
  void clear() {
    for (int i = 0; i < _page.layers._list.length; i++) {
      final PdfPageLayer layer = _page.layers._list[i] as PdfPageLayer;
      _removeLayer(layer);
    }
    _list.clear();
  }

  void _removeLayer(PdfPageLayer layer) {
    _PdfDictionary? ocProperties;
    _removeLayerContent(layer);
    final _PdfDictionary? resource = _PdfCrossTable._dereference(
        _page._dictionary[_DictionaryProperties.resources]) as _PdfDictionary?;
    if (resource != null) {
      final _PdfDictionary? properties = _PdfCrossTable._dereference(
          resource[_DictionaryProperties.properties]) as _PdfDictionary?;
      if (properties != null &&
          layer._layerID != null &&
          properties.containsKey(layer._layerID)) {
        properties.remove(layer._layerID);
      }
    }
    final PdfPage page = _page;
    if (page._document != null &&
        page._document!._catalog
            .containsKey(_DictionaryProperties.ocProperties)) {
      ocProperties = _PdfCrossTable._dereference(
              page._document!._catalog[_DictionaryProperties.ocProperties])
          as _PdfDictionary?;
    }
    if (ocProperties != null) {
      final _PdfArray? ocGroup =
          _PdfCrossTable._dereference(ocProperties[_DictionaryProperties.ocg])
              as _PdfArray?;
      if (ocGroup != null) {
        _removeContent(ocGroup, layer._referenceHolder);
      }
      final _PdfDictionary? defaultView = _PdfCrossTable._dereference(
          ocProperties[_DictionaryProperties.defaultView]) as _PdfDictionary?;
      if (defaultView != null) {
        final _PdfArray? _on = _PdfCrossTable._dereference(
            defaultView[_DictionaryProperties.ocgOn]) as _PdfArray?;
        final _PdfArray? order = _PdfCrossTable._dereference(
            defaultView[_DictionaryProperties.ocgOrder]) as _PdfArray?;
        final _PdfArray? off = _PdfCrossTable._dereference(
            defaultView[_DictionaryProperties.ocgOff]) as _PdfArray?;
        final _PdfArray? usage = _PdfCrossTable._dereference(
            defaultView[_DictionaryProperties.usageApplication]) as _PdfArray?;

        if (usage != null && usage.count > 0) {
          for (int i = 0; i < usage.count; i++) {
            final _PdfDictionary? usageDictionary =
                _PdfCrossTable._dereference(usage[i]) as _PdfDictionary?;
            if (usageDictionary != null &&
                usageDictionary.containsKey(_DictionaryProperties.ocg)) {
              final _PdfArray? usageOcGroup =
                  usageDictionary[_DictionaryProperties.ocg] as _PdfArray?;
              if (usageOcGroup != null) {
                _removeContent(usageOcGroup, layer._referenceHolder);
              }
            }
          }
        }
        if (order != null) {
          _removeContent(order, layer._referenceHolder);
        }
        if (layer.visible && _on != null) {
          _removeContent(_on, layer._referenceHolder);
        } else if (off != null) {
          _removeContent(off, layer._referenceHolder);
        }
      }
    }
  }

  void _removeContent(_PdfArray content, _PdfReferenceHolder? referenceHolder) {
    bool flag = false;
    for (int i = 0; i < content.count; i++) {
      final _IPdfPrimitive? primitive = content._elements[i];
      if (primitive != null && primitive is _PdfReferenceHolder) {
        final _PdfReferenceHolder reference = primitive;
        if (reference.reference != null && referenceHolder!.reference != null) {
          if (reference.reference!._objNum ==
              referenceHolder.reference!._objNum) {
            content._elements.removeAt(i);
            flag = true;
            i--;
          }
        } else if (identical(content._elements[i]!, referenceHolder)) {
          content._elements.removeAt(i);
          flag = true;
          i--;
        } else if (identical(
            (content._elements[i]! as _PdfReferenceHolder)._object,
            referenceHolder!._object)) {
          content._elements.removeAt(i);
          flag = true;
          i--;
        }
      } else if (content._elements[i]! is _PdfArray) {
        _removeContent(content._elements[i]! as _PdfArray, referenceHolder);
      }
    }
    if (flag) {
      content._isChanged = true;
    }
  }

  void _removeLayerContent(PdfPageLayer layer) {
    bool isSkip = false;
    for (int m = 0; m < _page._contents.count; m++) {
      bool isNewContentStream = false;
      bool? removePageContent = false;
      List<int>? stream = <int>[];
      final _IPdfPrimitive? primitive = _page._contents[m];
      if (primitive! is _PdfReferenceHolder) {
        final _PdfReferenceHolder pdfReference =
            primitive as _PdfReferenceHolder;
        if (pdfReference.reference == null) {
          isNewContentStream = true;
        }
      }
      final _PdfStream pageContent =
          _PdfCrossTable._dereference(_page._contents[m])! as _PdfStream;
      final _PdfStream data = _PdfStream();
      if (_page._isLoadedPage) {
        pageContent._decompress();
      }
      stream = pageContent._dataStream;
      final _ContentParser parser = _ContentParser(stream);
      final _PdfRecordCollection recordCollection = parser._readContent()!;
      for (int j = 0; j < recordCollection._recordCollection.length; j++) {
        final String? mOperator =
            recordCollection._recordCollection[j]._operatorName;
        if (mOperator == 'BMC' || mOperator == 'EMC' || mOperator == 'BDC') {
          final Map<String, bool> returnedValue = _processBeginMarkContent(
              layer,
              mOperator,
              recordCollection._recordCollection[j]._operands,
              data,
              isNewContentStream,
              removePageContent);
          removePageContent = returnedValue['removePageContent'];
          isSkip = true;
          if (removePageContent!) {
            break;
          }
        }
        String? id;
        if (recordCollection._recordCollection[j]._operands!.isNotEmpty &&
            recordCollection._recordCollection[j]._operands![0]
                .startsWith('/')) {
          id = recordCollection._recordCollection[j]._operands![0].substring(1);
        }
        if (mOperator == _Operators.paintXObject && (id == layer._layerID)) {
          isSkip = true;
        }
        if (mOperator == 'RG' ||
            mOperator == _Operators.saveState ||
            mOperator == _Operators.restoreState ||
            mOperator == _Operators.setLineWidth ||
            mOperator == _Operators.setLineCapStyle ||
            mOperator == _Operators.setLineJoinStyle ||
            mOperator == _Operators.setMiterLimit ||
            mOperator == _Operators.setDashPattern ||
            mOperator == _Operators.setGraphicsState ||
            mOperator == _Operators.currentMatrix ||
            mOperator == _Operators.selectColorSpaceForNonStroking ||
            mOperator == _Operators.selectColorSpaceForStroking) {
          if (!isSkip) {
            _streamWrite(recordCollection._recordCollection[j]._operands,
                mOperator, false, data);
          }
        } else if (!isSkip) {
          _streamWrite(recordCollection._recordCollection[j]._operands,
              mOperator, true, data);
        }
        isSkip = false;
      }
      if (data._dataStream!.isNotEmpty && !removePageContent!) {
        pageContent.clear();
        pageContent._dataStream!.clear();
        pageContent._write(data._dataStream);
      } else {
        pageContent.clear();
      }
      if (removePageContent!) {
        _removeContent(_page._contents, layer._referenceHolder);
        if (layer._graphics != null && layer._graphics!._streamWriter != null) {
          final _PdfStream? lcontent = layer._graphics!._streamWriter!._stream;
          if (lcontent != null) {
            _removeContent(_page._contents, _PdfReferenceHolder(lcontent));
          }
        }
      }
    }
  }

  Map<String, bool> _processBeginMarkContent(
      PdfPageLayer parser,
      String? mOperator,
      List<String>? operands,
      _PdfStream data,
      bool isNewContentStream,
      bool? removePageContent) {
    removePageContent = false;
    if ('BDC' == mOperator) {
      String? operand;
      if (operands!.length > 1 && ((operands[0]) == '/OC')) {
        operand = operands[1].substring(1);
      }
      if (_bdcCount > 0) {
        _bdcCount++;
        return <String, bool>{'removePageContent': removePageContent};
      }
      if (operand != null &&
          (operand == parser._layerID) &&
          !isNewContentStream) {
        _bdcCount++;
      } else if (operand != null &&
          (operand == parser._layerID) &&
          isNewContentStream) {
        removePageContent = true;
      }
    }
    _streamWrite(operands, mOperator, true, data);

    if (('EMC' == mOperator) && _bdcCount > 0) {
      _bdcCount--;
    }
    return <String, bool>{'removePageContent': removePageContent};
  }

  void _streamWrite(
      List<String>? operands, String? mOperator, bool skip, _PdfStream data) {
    _PdfString pdfString;
    if (skip && _bdcCount > 0) {
      return;
    }
    if (operands != null) {
      for (final String operand in operands) {
        pdfString = _PdfString(operand);
        data._write(pdfString.data);
        data._write(_Operators.whiteSpace);
      }
    }
    pdfString = _PdfString(mOperator!);
    data._write(pdfString.data);
    data._write(_Operators.newLine);
  }
}
