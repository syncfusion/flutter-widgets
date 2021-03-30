part of pdf;

/// The class provides methods and properties to handle the collections of [PdfLayer]
class PdfLayerCollection extends PdfObjectCollection {
  // Contructor
  PdfLayerCollection._(PdfDocument document) {
    _document = document;
    _sublayer = false;
    if (document._isLoadedDocument) {
      _getDocumentLayer(document);
    }
  }

  PdfLayerCollection._withLayer(PdfDocument? document, PdfLayer? layer) {
    _document = document;
    _parent = layer;
    _sublayer = true;
  }

  // Fields
  PdfDocument? _document;
  bool? _sublayer;
  PdfLayer? _parent;
  final _PdfDictionary _optionalContent = _PdfDictionary();
  final Map<_PdfReferenceHolder, PdfLayer> _layerDictionary =
      <_PdfReferenceHolder, PdfLayer>{};
  int _bdcCount = 0;

  //Properties
  /// Gets [PdfLayer] by its index from [PdfLayerCollection].
  PdfLayer operator [](int index) {
    if (index < 0 || index >= count) {
      throw RangeError('index');
    }
    return _list[index] as PdfLayer;
  }

  // Implementation
  /// Creates a new [PdfLayer] with name and adds it to the end of the collection.
  PdfLayer add({String? name, bool? visible}) {
    final PdfLayer layer = PdfLayer._();
    if (name != null) {
      layer.name = name;
    }
    layer._document = _document;
    if (visible != null) {
      layer.visible = visible;
    }
    layer._layerId = 'OCG_' + _PdfResources._globallyUniqueIdentifier;
    layer._layer = layer;
    _add(layer);
    return layer;
  }

  /// Removes layer from the collection by using layer or layer name and may also remove graphical content, if isRemoveGraphicalContent is true.
  void remove(
      {PdfLayer? layer, String? name, bool isRemoveGraphicalContent = false}) {
    if (layer != null) {
      _removeLayer(layer, isRemoveGraphicalContent);
      _list.remove(layer);
    } else if (name != null) {
      bool isFind = false;
      for (int i = 0; i < _list.length; i++) {
        final PdfLayer layer = _list[i] as PdfLayer;
        if (layer.name == name) {
          isFind = true;
          _removeLayer(layer, isRemoveGraphicalContent);
          _list.remove(layer);
          i = i - 1;
        }
      }
      if (!isFind) {
        ArgumentError.value('Given layerName is not found');
      }
    } else {
      ArgumentError.value('layer or layerName must be required');
    }
  }

  /// Removes layer by its index from collections and may also remove graphical content if isRemoveGraphicalContent is true.
  void removeAt(int index, [bool isRemoveGraphicalContent = false]) {
    if (index < 0 || index > _list.length - 1) {
      ArgumentError.value(
          '$index Value can not be less 0 and greater List.Count - 1');
    }
    final PdfLayer layer = this[index];
    _list.removeAt(index);
    _removeLayer(layer, isRemoveGraphicalContent);
  }

  /// Clears layers from the [PdfLayerCollection].
  void clear() {
    for (int i = 0; i < _list.length; i++) {
      final PdfLayer layer = this[i];
      _removeLayer(layer, true);
    }
    _list.clear();
  }

  int _add(PdfLayer layer) {
    _list.add(layer);
    final int index = count - 1;
    if (_document is PdfDocument) {
      _createLayer(layer);
    }
    layer._layer = layer;
    return index;
  }

  void _createLayer(PdfLayer layer) {
    final _PdfDictionary ocProperties = _PdfDictionary();
    ocProperties[_DictionaryProperties.ocg] =
        _createOptionalContentDictionary(layer);
    ocProperties[_DictionaryProperties.defaultView] =
        _createOptionalContentViews(layer);
    _document!._catalog[_DictionaryProperties.ocProperties] = ocProperties;
    _document!._catalog
        .setProperty(_DictionaryProperties.ocProperties, ocProperties);
  }

  _IPdfPrimitive? _createOptionalContentDictionary(PdfLayer layer) {
    final _PdfDictionary dictionary = _PdfDictionary();
    dictionary[_DictionaryProperties.name] = _PdfString(layer.name!);
    dictionary[_DictionaryProperties.type] = _PdfName('OCG');
    dictionary[_DictionaryProperties.layerID] = _PdfName(layer._layerId);
    dictionary[_DictionaryProperties.visible] = _PdfBoolean(layer.visible);

    layer._usage = _setPrintOption(layer);
    dictionary[_DictionaryProperties.usage] = _PdfReferenceHolder(layer._usage);
    _document!._printLayer!._add(_PdfReferenceHolder(dictionary));

    final _PdfReferenceHolder reference = _PdfReferenceHolder(dictionary);
    _document!._primitive!._add(reference);
    layer._referenceHolder = reference;
    layer._dictionary = dictionary;

    // Order of the layers
    final _PdfDictionary? ocProperties = _PdfCrossTable._dereference(
            _document!._catalog[_DictionaryProperties.ocProperties])
        as _PdfDictionary?;
    _createSublayer(ocProperties, reference, layer);
    if (layer.visible) {
      _document!._on!._add(reference);
    } else {
      _document!._off!._add(reference);
    }
    return _document!._primitive;
  }

  _PdfDictionary _setPrintOption(PdfLayer layer) {
    final _PdfDictionary _usage = _PdfDictionary();
    layer._printOption = _PdfDictionary();
    layer._printOption![_DictionaryProperties.subtype] = _PdfName('Print');
    _usage[_DictionaryProperties.print] =
        _PdfReferenceHolder(layer._printOption);
    return _usage;
  }

  void _createSublayer(_PdfDictionary? ocProperties,
      _PdfReferenceHolder reference, PdfLayer layer) {
    if (_sublayer == false) {
      if (ocProperties != null) {
        _PdfArray? order;
        final _PdfDictionary? defaultview = _PdfCrossTable._dereference(
            ocProperties[_DictionaryProperties.defaultView]) as _PdfDictionary?;
        if (defaultview != null) {
          order = _PdfCrossTable._dereference(
              defaultview[_DictionaryProperties.ocgOrder]) as _PdfArray?;
        }
        if (_document!._order != null && order != null) {
          _document!._order = order;
        }
        _document!._order!._add(reference);
      } else {
        _document!._order!._add(reference);
      }
    } else {
      layer._parent = _parent;
      if (ocProperties != null) {
        _PdfArray? order;
        final _PdfDictionary? defaultview = _PdfCrossTable._dereference(
            ocProperties[_DictionaryProperties.defaultView]) as _PdfDictionary?;
        if (defaultview != null) {
          order = _PdfCrossTable._dereference(
              defaultview[_DictionaryProperties.ocgOrder]) as _PdfArray?;
        }
        if (_document!._order != null && order != null) {
          _document!._order = order;
        }
      }
      if (_parent!._child.isEmpty) {
        _parent!._sublayer._add(reference);
      } else if (_document!._order!._contains(_parent!._referenceHolder!)) {
        final int position =
            _document!._order!._indexOf(_parent!._referenceHolder!);
        _document!._order!._removeAt(position + 1);
        _parent!._sublayer._add(reference);
      } else {
        _parent!._sublayer._add(reference);
      }
      if (_document!._order!._contains(_parent!._referenceHolder!)) {
        final int position =
            _document!._order!._indexOf(_parent!._referenceHolder!);
        _document!._order!._insert(position + 1, _parent!._sublayer);
      } else {
        if (_parent!._parent != null) {
          if (_parent!._parent!._sublayer
              ._contains(_parent!._referenceHolder!)) {
            int position = _parent!._parent!._sublayer
                ._indexOf(_parent!._referenceHolder!);
            if (_parent!._sublayer.count == 1) {
              _parent!._parent!._sublayer
                  ._insert(position + 1, _parent!._sublayer);
            }

            if (_document!._order!
                ._contains(_parent!._parent!._referenceHolder!)) {
              position = _document!._order!
                  ._indexOf(_parent!._parent!._referenceHolder!);
              _document!._order!._removeAt(position + 1);
              _document!._order!
                  ._insert(position + 1, _parent!._parent!._sublayer);
            }
          }
        }
      }

      _parent!._child.add(layer);

      if (_parent!._parentLayer.isEmpty) {
        layer._parentLayer.add(_parent!);
      } else {
        for (int i = 0; i < _parent!._parentLayer.length; i++) {
          if (!layer._parentLayer.contains(_parent!._parentLayer[i])) {
            layer._parentLayer.add(_parent!._parentLayer[i]);
          }
        }
        layer._parentLayer.add(_parent!);
      }
    }
  }

  _IPdfPrimitive _createOptionalContentViews(PdfLayer layer) {
    final _PdfArray usageApplication = _PdfArray();
    _optionalContent[_DictionaryProperties.name] = _PdfString('Layers');
    _optionalContent[_DictionaryProperties.ocgOrder] = _document!._order;
    _optionalContent[_DictionaryProperties.ocgOn] = _document!._on;
    _optionalContent[_DictionaryProperties.ocgOff] = _document!._off;
    final _PdfArray category = _PdfArray();
    category._add(_PdfName('Print'));
    final _PdfDictionary applicationDictionary = _PdfDictionary();
    applicationDictionary[_DictionaryProperties.category] = category;
    applicationDictionary[_DictionaryProperties.ocg] = _document!._printLayer;
    applicationDictionary[_DictionaryProperties.event] = _PdfName('Print');
    usageApplication._add(_PdfReferenceHolder(applicationDictionary));
    _optionalContent[_DictionaryProperties.usageApplication] = usageApplication;
    return _optionalContent;
  }

  void _getDocumentLayer(PdfDocument document) {
    _PdfDictionary? layerDictionary;
    _PdfReferenceHolder layerReference;
    if (document._catalog.containsKey(_DictionaryProperties.ocProperties)) {
      final _PdfDictionary? ocProperties = _PdfCrossTable._dereference(
              document._catalog[_DictionaryProperties.ocProperties])
          as _PdfDictionary?;
      if (ocProperties != null) {
        if (ocProperties.containsKey(_DictionaryProperties.ocg)) {
          final _PdfArray ocGroup = _PdfCrossTable._dereference(
              ocProperties[_DictionaryProperties.ocg]) as _PdfArray;
          for (int i = 0; i < ocGroup.count; i++) {
            if (ocGroup[i] is _PdfReferenceHolder) {
              layerReference = ocGroup[i] as _PdfReferenceHolder;
              layerDictionary = layerReference.object as _PdfDictionary?;
              final PdfLayer layer = PdfLayer._();
              if (layerDictionary != null &&
                  layerDictionary.containsKey(_DictionaryProperties.name)) {
                final _PdfString layerName = _PdfCrossTable._dereference(
                    layerDictionary[_DictionaryProperties.name]) as _PdfString;
                layer.name = layerName.value;
                layer._dictionary = layerDictionary;
                layer._referenceHolder = layerReference;
                final _IPdfPrimitive? layerId = _PdfCrossTable._dereference(
                    layerDictionary[_DictionaryProperties.layerID]);
                if (layerId != null) {
                  layer._layerId = layerId.toString();
                }
                final _PdfDictionary? usage = _PdfCrossTable._dereference(
                        layerDictionary[_DictionaryProperties.usage])
                    as _PdfDictionary?;

                if (usage != null) {
                  final _PdfDictionary? printOption =
                      _PdfCrossTable._dereference(
                              usage[_DictionaryProperties.print])
                          as _PdfDictionary?;

                  if (printOption != null) {
                    layer._printOption = printOption;
                  }
                }
              }
              layer._document = document;
              layer._layer = layer;
              // layer._parsingLayerPage();
              _layerDictionary[layerReference] = layer;
              _list.add(layer);
            }
          }
        }
        _checkLayerLock(ocProperties);
        _checkLayerVisible(ocProperties);
        _checkParentLayer(ocProperties);
        _createLayerHierarchical(ocProperties);
      }
    }
  }

  void _checkLayerVisible(_PdfDictionary ocProperties) {
    _PdfArray? visible;
    if (_document!._catalog.containsKey(_DictionaryProperties.ocProperties)) {
      final _PdfDictionary? defaultView = _PdfCrossTable._dereference(
          ocProperties[_DictionaryProperties.defaultView]) as _PdfDictionary?;

      if (defaultView != null &&
          defaultView.containsKey(_DictionaryProperties.ocgOff)) {
        visible = _PdfCrossTable._dereference(
            defaultView[_DictionaryProperties.ocgOff]) as _PdfArray?;
      }
      if (visible != null) {
        for (int i = 0; i < visible.count; i++) {
          final PdfLayer? pdfLayer =
              _layerDictionary[visible[i] as _PdfReferenceHolder];
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

  void _checkParentLayer(_PdfDictionary ocProperties) {
    final _PdfDictionary? defaultView = _PdfCrossTable._dereference(
        ocProperties[_DictionaryProperties.defaultView]) as _PdfDictionary?;
    if (defaultView != null) {
      final _PdfArray? array = _PdfCrossTable._dereference(
          defaultView[_DictionaryProperties.ocgOrder]) as _PdfArray?;
      if (array != null) {
        _parsingLayerOrder(array, _layerDictionary);
      }
    }
  }

  void _checkLayerLock(_PdfDictionary ocProperties) {
    _PdfArray? locked;
    final _PdfDictionary? defaultView = _PdfCrossTable._dereference(
        ocProperties[_DictionaryProperties.defaultView]) as _PdfDictionary?;
    if (defaultView != null &&
        defaultView.containsKey(_DictionaryProperties.ocgLock)) {
      locked = _PdfCrossTable._dereference(
          defaultView[_DictionaryProperties.ocgLock]) as _PdfArray?;
    }
    if (locked != null) {
      for (int i = 0; i < locked.count; i++) {
        final PdfLayer? pdfLayer =
            _layerDictionary[locked[i] as _PdfReferenceHolder];
        if (pdfLayer != null) {
          continue;
        }
      }
    }
  }

  void _createLayerHierarchical(_PdfDictionary ocProperties) {
    final _PdfDictionary? defaultView = _PdfCrossTable._dereference(
        ocProperties[_DictionaryProperties.defaultView]) as _PdfDictionary?;
    if (defaultView != null &&
        defaultView.containsKey(_DictionaryProperties.ocgOrder)) {
      if (_layerDictionary.isNotEmpty) {
        _list.clear();
        _layerDictionary.forEach((_PdfReferenceHolder key, PdfLayer value) {
          final PdfLayer pdfLayer = value;
          if (pdfLayer._parent == null && !_list.contains(pdfLayer)) {
            _list.add(pdfLayer);
          } else if (pdfLayer._child.isNotEmpty) {
            _addChildlayer(pdfLayer._parent!);
          } else if (pdfLayer._parent != null &&
              pdfLayer._child.isEmpty &&
              !pdfLayer._parent!.layers._list.contains(pdfLayer)) {
            pdfLayer._parent!.layers._addNestedLayer(pdfLayer);
          }
        });
      }
    }
  }

  void _addChildlayer(PdfLayer pdfLayer) {
    for (int i = 0; i < pdfLayer._child.length; i++) {
      final PdfLayer? child = pdfLayer._child[i];
      if (!pdfLayer.layers._list.contains(child)) {
        pdfLayer.layers._addNestedLayer(child!);
      }
    }
  }

  int _addNestedLayer(PdfLayer layer) {
    _list.add(layer);
    layer._layer = layer;
    return _list.length - 1;
  }

  void _parsingLayerOrder(
      _PdfArray array, Map<_PdfReferenceHolder, PdfLayer> layerDictionary,
      [PdfLayer? parent]) {
    _PdfReferenceHolder reference;
    PdfLayer? layer;
    for (int i = 0; i < array.count; i++) {
      if (array[i] is _PdfReferenceHolder) {
        reference = array[i] as _PdfReferenceHolder;
        layerDictionary.forEach((_PdfReferenceHolder key, PdfLayer value) {
          if (identical(key.object, reference.object) ||
              identical(key.reference, reference.reference)) {
            layer = value;
          }
        });
        if (layer != null) {
          if (parent != null) {
            parent._child.add(layer!);
            if (parent._parentLayer.isEmpty) {
              layer!._parentLayer.add(parent);
              layer!._parent = parent;
            } else {
              for (int j = 0; j < parent._parentLayer.length; j++) {
                if (!layer!._parentLayer.contains(parent._parentLayer[j])) {
                  layer!._parentLayer.add(parent._parentLayer[j]);
                }
              }
              layer!._parentLayer.add(parent);
              layer!._parent = parent;
            }
          }
          if (array.count > i + 1 &&
              _PdfCrossTable._dereference(array[i + 1]) is _PdfArray) {
            i++;
            final _PdfArray pdfArray =
                _PdfCrossTable._dereference(array[i]) as _PdfArray;
            layer!._sublayer._add(pdfArray);
            _parsingLayerOrder(pdfArray, layerDictionary, layer);
          }
        }
      } else if (_PdfCrossTable._dereference(array[i]) is _PdfArray) {
        final _PdfArray? subarray =
            _PdfCrossTable._dereference(array[i]) as _PdfArray?;
        if (subarray == null) {
          return;
        }
        if (subarray[0] is _PdfString) {
          parent = null;
          _parsingLayerOrder(subarray, layerDictionary, parent);
        } else {
          parent = null;
          _parsingLayerOrder(_PdfCrossTable._dereference(array[i]) as _PdfArray,
              layerDictionary, parent);
        }
      }
    }
  }

  void _removeLayer(PdfLayer layer, bool isRemoveContent) {
    _PdfDictionary? dictionary;
    if (_document != null) {
      dictionary = _document!._catalog;
      if (dictionary.containsKey(_DictionaryProperties.ocProperties)) {
        final _PdfDictionary? ocPropertie = _PdfCrossTable._dereference(
            dictionary[_DictionaryProperties.ocProperties]) as _PdfDictionary?;
        if (ocPropertie != null) {
          final _PdfArray? ocGroup = _PdfCrossTable._dereference(
              ocPropertie[_DictionaryProperties.ocg]) as _PdfArray?;
          if (ocGroup != null) {
            _removeOCProperties(ocGroup, layer._referenceHolder);
          }
          if (ocPropertie.containsKey(_DictionaryProperties.defaultView)) {
            final _PdfDictionary? defaultView = _PdfCrossTable._dereference(
                    ocPropertie[_DictionaryProperties.defaultView])
                as _PdfDictionary?;
            if (defaultView != null) {
              _PdfArray? _on, off;
              if (defaultView.containsKey(_DictionaryProperties.ocgOrder)) {
                final _PdfArray? order = _PdfCrossTable._dereference(
                    defaultView[_DictionaryProperties.ocgOrder]) as _PdfArray?;
                if (order != null) {
                  _removeOrder(layer, order, <_PdfArray>[]);
                  // _removeOCProperties(order, layer._referenceHolder);
                }
              }
              if (defaultView.containsKey(_DictionaryProperties.ocgLock)) {
                final _PdfArray? locked = _PdfCrossTable._dereference(
                    defaultView[_DictionaryProperties.ocgLock]) as _PdfArray?;
                if (locked != null) {
                  _removeOCProperties(locked, layer._referenceHolder);
                }
              }
              if (defaultView.containsKey(_DictionaryProperties.ocgOff)) {
                off = _PdfCrossTable._dereference(
                    defaultView[_DictionaryProperties.ocgOff]) as _PdfArray?;
              }
              if (defaultView.containsKey(_DictionaryProperties.ocgOn)) {
                _on = _PdfCrossTable._dereference(
                    defaultView[_DictionaryProperties.ocgOn]) as _PdfArray?;
              } else if (_on == null && defaultView.containsKey('ON')) {
                _on = _PdfCrossTable._dereference(defaultView['ON'])
                    as _PdfArray?;
              }
              if (defaultView
                  .containsKey(_DictionaryProperties.usageApplication)) {
                final _PdfArray? usage = _PdfCrossTable._dereference(
                        defaultView[_DictionaryProperties.usageApplication])
                    as _PdfArray?;
                if (usage != null) {
                  _removeOCProperties(usage, layer._referenceHolder);
                }
              }
              _removeVisible(layer, _on, off);
            }
          }
        }
      }
      if (isRemoveContent) {
        _removeLayerContent(layer);
      }
    }
  }

  void _removeVisible(PdfLayer layer, _PdfArray? _on, _PdfArray? off) {
    if (layer.visible) {
      if (_on != null) {
        _removeOCProperties(_on, layer._referenceHolder);
      }
    } else {
      if (off != null) {
        _removeOCProperties(off, layer._referenceHolder);
      }
    }
  }

  void _removeOrder(
      PdfLayer layer, _PdfArray order, List<_PdfArray> arrayList) {
    bool isRemoveOrder = false;
    for (int i = 0; i < order.count; i++) {
      if (order[i] is _PdfReferenceHolder) {
        final _PdfReferenceHolder holder = order[i] as _PdfReferenceHolder;
        if (identical(holder.object, layer._referenceHolder!.object) ||
            identical(holder.reference, layer._referenceHolder!.reference)) {
          if (i != order.count - 1) {
            if (order[i + 1] is _PdfArray) {
              order._removeAt(i);
              order._removeAt(i);
              isRemoveOrder = true;
              break;
            } else {
              order._removeAt(i);
              isRemoveOrder = true;
              break;
            }
          } else {
            order._removeAt(i);
            isRemoveOrder = true;
            break;
          }
        }
      } else if (order[i] is _PdfArray) {
        arrayList.add(order[i] as _PdfArray);
      }
    }
    if (!isRemoveOrder) {
      for (int i = 0; i < arrayList.length; i++) {
        order = arrayList[i];
        arrayList.removeAt(i);
        i = i - 1;
        _removeOrder(layer, order, arrayList);
      }
    }
  }

  void _removeOCProperties(
      _PdfArray content, _PdfReferenceHolder? referenceHolder) {
    bool isChange = false;
    for (int i = 0; i < content.count; i++) {
      final _IPdfPrimitive? primitive = content._elements[i];
      if (primitive != null && primitive is _PdfReferenceHolder) {
        final _PdfReferenceHolder holder = primitive;
        if (holder.reference != null && referenceHolder!.reference != null) {
          if (holder.reference!._objNum == referenceHolder.reference!._objNum) {
            content._elements.removeAt(i);
            isChange = true;
            i--;
          }
        } else if (identical(holder, referenceHolder)) {
          content._elements.removeAt(i);
          isChange = true;
          i--;
        } else if (identical(holder._object, referenceHolder!._object)) {
          content._elements.removeAt(i);
          isChange = true;
          i--;
        }
      } else if (primitive != null && primitive is _PdfArray) {
        _removeOCProperties(primitive, referenceHolder);
      }
    }
    if (isChange) {
      content._isChanged = true;
    }
  }

  void _removeLayerContent(PdfLayer layer) {
    _PdfDictionary? properties;
    bool isSkip = false;
    _PdfDictionary? xObject;
    if (!layer._pageParsed) {
      layer._parsingLayerPage();
      _removeLayerContent(layer);
      return;
    }
    if (layer._pages.isNotEmpty) {
      for (int i = 0; i < layer._pages.length; i++) {
        final _PdfDictionary? resource = _PdfCrossTable._dereference(
                layer._pages[i]._dictionary[_DictionaryProperties.resources])
            as _PdfDictionary?;
        if (resource != null) {
          properties = _PdfCrossTable._dereference(
              resource[_DictionaryProperties.properties]) as _PdfDictionary?;
          xObject = _PdfCrossTable._dereference(
              resource[_DictionaryProperties.xObject]) as _PdfDictionary?;
          if (properties != null) {
            if (properties.containsKey(layer._layerId)) {
              properties.remove(layer._layerId);
            }
          }
          if (xObject != null && layer._xobject.isNotEmpty) {
            for (final _PdfName? key in xObject._items!.keys) {
              if (layer._xobject.contains(key!._name)) {
                xObject.remove(key);
              }
              if (xObject._items!.isEmpty) {
                break;
              }
            }
          }
          final _PdfArray content = layer._pages[i]._contents;
          for (int m = 0; m < content.count; m++) {
            List<int>? stream = <int>[];
            final _PdfStream data = _PdfStream();
            final _PdfStream pageContent =
                _PdfCrossTable._dereference(content[m]) as _PdfStream;
            if (layer._pages[i]._isLoadedPage) {
              pageContent._decompress();
            }
            stream = pageContent._dataStream;
            final _ContentParser parser = _ContentParser(stream);
            final _PdfRecordCollection recordCollection =
                parser._readContent()!;
            for (int j = 0;
                j < recordCollection._recordCollection.length;
                j++) {
              final String? mOperator =
                  recordCollection._recordCollection[j]._operatorName;
              if (mOperator == 'BMC' ||
                  mOperator == 'EMC' ||
                  mOperator == 'BDC') {
                _processBeginMarkContent(layer, mOperator,
                    recordCollection._recordCollection[j]._operands, data);
                isSkip = true;
              }
              if (mOperator == _Operators.paintXObject) {
                if (layer._xobject.contains(
                    recordCollection._recordCollection[j]._operands![0])) {
                  isSkip = true;
                }
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
            if (data._dataStream!.isNotEmpty) {
              pageContent.clear();
              pageContent._dataStream!.clear();
              pageContent._write(data._dataStream);
            } else {
              pageContent.clear();
            }
          }
        }
      }
    }
  }

  void _processBeginMarkContent(PdfLayer parser, String? mOperator,
      List<String>? operands, _PdfStream data) {
    if ('BDC' == mOperator) {
      String? operand;
      if (operands!.length > 1 && ((operands[0]) == '/OC')) {
        operand = operands[1].substring(1);
      }
      if (_bdcCount > 0) {
        _bdcCount++;
        return;
      }
      if (operand != null && (operand == parser._layerId)) {
        _bdcCount++;
      }
    }
    _streamWrite(operands, mOperator, true, data);
    if (('EMC' == mOperator) && _bdcCount > 0) {
      _bdcCount--;
    }
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
