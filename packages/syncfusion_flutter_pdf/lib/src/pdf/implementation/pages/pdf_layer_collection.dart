import '../../interfaces/pdf_interface.dart';
import '../exporting/pdf_text_extractor/parser/content_parser.dart';
import '../general/pdf_collection.dart';
import '../graphics/pdf_resources.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'pdf_layer.dart';
import 'pdf_page.dart';

/// The class provides methods and properties to handle the collections of [PdfLayer]
class PdfLayerCollection extends PdfObjectCollection {
  // Contructor
  PdfLayerCollection._(PdfDocument document) {
    _helper = PdfLayerCollectionHelper(this, document);
  }

  PdfLayerCollection._withLayer(PdfDocument? document, PdfLayer? layer) {
    _helper = PdfLayerCollectionHelper._(this, document, layer);
  }

  // Fields
  late PdfLayerCollectionHelper _helper;

  //Properties
  /// Gets [PdfLayer] by its index from [PdfLayerCollection].
  PdfLayer operator [](int index) {
    if (index < 0 || index >= count) {
      throw RangeError('index');
    }
    return _helper.list[index] as PdfLayer;
  }

  // Implementation
  /// Creates a new [PdfLayer] with name and adds it to the end of the collection.
  PdfLayer add({String? name, bool? visible}) {
    return _helper.add(name, visible);
  }

  /// Removes layer from the collection by using layer or layer name and may also remove graphical content, if isRemoveGraphicalContent is true.
  void remove(
      {PdfLayer? layer, String? name, bool isRemoveGraphicalContent = false}) {
    _helper.remove(layer, name, isRemoveGraphicalContent);
  }

  /// Removes layer by its index from collections and may also remove graphical content if isRemoveGraphicalContent is true.
  void removeAt(int index, [bool isRemoveGraphicalContent = false]) {
    _helper.removeAt(index, isRemoveGraphicalContent);
  }

  /// Clears layers from the [PdfLayerCollection].
  void clear() {
    _helper.clear();
  }
}

/// [PdfLayerCollection] helper
class PdfLayerCollectionHelper extends PdfObjectCollectionHelper {
  /// internal constructor
  PdfLayerCollectionHelper(this.layerCollection, PdfDocument document)
      : super(layerCollection) {
    _document = document;
    _sublayer = false;
    if (PdfDocumentHelper.getHelper(document).isLoadedDocument) {
      _getDocumentLayer(document);
    }
  }

  /// internal constructor
  PdfLayerCollectionHelper._(
      this.layerCollection, PdfDocument? document, PdfLayer? layer)
      : super(layerCollection) {
    _document = document;
    _parent = layer;
    _sublayer = true;
  }

  /// internal field
  late PdfLayerCollection layerCollection;

  PdfDocument? _document;
  bool? _sublayer;
  PdfLayer? _parent;
  final PdfDictionary _optionalContent = PdfDictionary();
  final Map<PdfReferenceHolder, PdfLayer> _layerDictionary =
      <PdfReferenceHolder, PdfLayer>{};
  int _bdcCount = 0;

  /// internal method
  static PdfLayerCollection load(PdfDocument document) {
    return PdfLayerCollection._(document);
  }

  /// internal method
  static PdfLayerCollection withLayer(PdfDocument? document, PdfLayer? layer) {
    return PdfLayerCollection._withLayer(document, layer);
  }

  /// Creates a new [PdfLayer] with name and adds it to the end of the collection.
  PdfLayer add(String? name, bool? visible) {
    final PdfLayer layer = PdfLayerHelper.internal();
    if (name != null) {
      layer.name = name;
    }
    PdfLayerHelper.getHelper(layer).document = _document;
    if (visible != null) {
      layer.visible = visible;
    }
    PdfLayerHelper.getHelper(layer).layerId =
        'OCG_${PdfResources.globallyUniqueIdentifier}';
    PdfLayerHelper.getHelper(layer).layer = layer;
    _add(layer);
    return layer;
  }

  /// Removes layer from the collection by using layer or layer name and may also remove graphical content, if isRemoveGraphicalContent is true.
  void remove(PdfLayer? layer, String? name, bool isRemoveGraphicalContent) {
    if (layer != null) {
      _removeLayer(layer, isRemoveGraphicalContent);
      list.remove(layer);
    } else if (name != null) {
      bool isFind = false;
      for (int i = 0; i < list.length; i++) {
        final PdfLayer layer = list[i] as PdfLayer;
        if (layer.name == name) {
          isFind = true;
          _removeLayer(layer, isRemoveGraphicalContent);
          list.remove(layer);
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
  void removeAt(int index, bool isRemoveGraphicalContent) {
    if (index < 0 || index > list.length - 1) {
      ArgumentError.value(
          '$index Value can not be less 0 and greater List.Count - 1');
    }
    final PdfLayer layer = layerCollection[index];
    list.removeAt(index);
    _removeLayer(layer, isRemoveGraphicalContent);
  }

  /// Clears layers from the [PdfLayerCollection].
  void clear() {
    for (int i = 0; i < list.length; i++) {
      final PdfLayer layer = layerCollection[i];
      _removeLayer(layer, true);
    }
    list.clear();
  }

  int _add(PdfLayer layer) {
    list.add(layer);
    final int index = layerCollection.count - 1;
    if (_document is PdfDocument) {
      _createLayer(layer);
    }
    PdfLayerHelper.getHelper(layer).layer = layer;
    return index;
  }

  void _createLayer(PdfLayer layer) {
    final PdfDictionary ocProperties = PdfDictionary();
    ocProperties[PdfDictionaryProperties.ocg] =
        _createOptionalContentDictionary(layer);
    ocProperties[PdfDictionaryProperties.defaultView] =
        _createOptionalContentViews(layer);
    PdfDocumentHelper.getHelper(_document!)
        .catalog[PdfDictionaryProperties.ocProperties] = ocProperties;
    PdfDocumentHelper.getHelper(_document!)
        .catalog
        .setProperty(PdfDictionaryProperties.ocProperties, ocProperties);
  }

  IPdfPrimitive? _createOptionalContentDictionary(PdfLayer layer) {
    final PdfDictionary dictionary = PdfDictionary();
    dictionary[PdfDictionaryProperties.name] = PdfString(layer.name!);
    dictionary[PdfDictionaryProperties.type] = PdfName('OCG');
    dictionary[PdfDictionaryProperties.layerID] =
        PdfName(PdfLayerHelper.getHelper(layer).layerId);
    dictionary[PdfDictionaryProperties.visible] = PdfBoolean(layer.visible);

    PdfLayerHelper.getHelper(layer).usage = _setPrintOption(layer);
    dictionary[PdfDictionaryProperties.usage] =
        PdfReferenceHolder(PdfLayerHelper.getHelper(layer).usage);
    PdfDocumentHelper.getHelper(_document!)
        .printLayer!
        .add(PdfReferenceHolder(dictionary));

    final PdfReferenceHolder reference = PdfReferenceHolder(dictionary);
    PdfDocumentHelper.getHelper(_document!).pdfPrimitive!.add(reference);
    PdfLayerHelper.getHelper(layer).referenceHolder = reference;
    PdfLayerHelper.getHelper(layer).dictionary = dictionary;

    // Order of the layers
    final PdfDictionary? ocProperties = PdfCrossTable.dereference(
        PdfDocumentHelper.getHelper(_document!)
            .catalog[PdfDictionaryProperties.ocProperties]) as PdfDictionary?;
    _createSublayer(ocProperties, reference, layer);
    if (layer.visible) {
      PdfDocumentHelper.getHelper(_document!).on!.add(reference);
    } else {
      PdfDocumentHelper.getHelper(_document!).off!.add(reference);
    }
    return PdfDocumentHelper.getHelper(_document!).pdfPrimitive;
  }

  PdfDictionary _setPrintOption(PdfLayer layer) {
    final PdfDictionary usage = PdfDictionary();
    PdfLayerHelper.getHelper(layer).printOption = PdfDictionary();
    PdfLayerHelper.getHelper(layer)
        .printOption![PdfDictionaryProperties.subtype] = PdfName('Print');
    usage[PdfDictionaryProperties.print] =
        PdfReferenceHolder(PdfLayerHelper.getHelper(layer).printOption);
    return usage;
  }

  void _createSublayer(PdfDictionary? ocProperties,
      PdfReferenceHolder reference, PdfLayer layer) {
    if (_sublayer == false) {
      if (ocProperties != null) {
        PdfArray? order;
        final PdfDictionary? defaultview = PdfCrossTable.dereference(
                ocProperties[PdfDictionaryProperties.defaultView])
            as PdfDictionary?;
        if (defaultview != null) {
          order = PdfCrossTable.dereference(
              defaultview[PdfDictionaryProperties.ocgOrder]) as PdfArray?;
        }
        if (PdfDocumentHelper.getHelper(_document!).order != null &&
            order != null) {
          PdfDocumentHelper.getHelper(_document!).order = order;
        }
        PdfDocumentHelper.getHelper(_document!).order!.add(reference);
      } else {
        PdfDocumentHelper.getHelper(_document!).order!.add(reference);
      }
    } else {
      PdfLayerHelper.getHelper(layer).parent = _parent;
      if (ocProperties != null) {
        PdfArray? order;
        final PdfDictionary? defaultview = PdfCrossTable.dereference(
                ocProperties[PdfDictionaryProperties.defaultView])
            as PdfDictionary?;
        if (defaultview != null) {
          order = PdfCrossTable.dereference(
              defaultview[PdfDictionaryProperties.ocgOrder]) as PdfArray?;
        }
        if (PdfDocumentHelper.getHelper(_document!).order != null &&
            order != null) {
          PdfDocumentHelper.getHelper(_document!).order = order;
        }
      }
      if (PdfLayerHelper.getHelper(_parent!).child.isEmpty) {
        PdfLayerHelper.getHelper(_parent!).sublayer.add(reference);
      } else if (PdfDocumentHelper.getHelper(_document!)
          .order!
          .contains(PdfLayerHelper.getHelper(_parent!).referenceHolder!)) {
        final int position = PdfDocumentHelper.getHelper(_document!)
            .order!
            .indexOf(PdfLayerHelper.getHelper(_parent!).referenceHolder!);
        PdfDocumentHelper.getHelper(_document!).order!.removeAt(position + 1);
        PdfLayerHelper.getHelper(_parent!).sublayer.add(reference);
      } else {
        PdfLayerHelper.getHelper(_parent!).sublayer.add(reference);
      }
      if (PdfDocumentHelper.getHelper(_document!)
          .order!
          .contains(PdfLayerHelper.getHelper(_parent!).referenceHolder!)) {
        final int position = PdfDocumentHelper.getHelper(_document!)
            .order!
            .indexOf(PdfLayerHelper.getHelper(_parent!).referenceHolder!);
        PdfDocumentHelper.getHelper(_document!)
            .order!
            .insert(position + 1, PdfLayerHelper.getHelper(_parent!).sublayer);
      } else {
        if (PdfLayerHelper.getHelper(_parent!).parent != null) {
          if (PdfLayerHelper.getHelper(
                  PdfLayerHelper.getHelper(_parent!).parent!)
              .sublayer
              .contains(PdfLayerHelper.getHelper(_parent!).referenceHolder!)) {
            int position = PdfLayerHelper.getHelper(
                    PdfLayerHelper.getHelper(_parent!).parent!)
                .sublayer
                .indexOf(PdfLayerHelper.getHelper(_parent!).referenceHolder!);
            if (PdfLayerHelper.getHelper(_parent!).sublayer.count == 1) {
              PdfLayerHelper.getHelper(
                      PdfLayerHelper.getHelper(_parent!).parent!)
                  .sublayer
                  .insert(position + 1,
                      PdfLayerHelper.getHelper(_parent!).sublayer);
            }
            if (PdfDocumentHelper.getHelper(_document!).order!.contains(
                PdfLayerHelper.getHelper(
                        PdfLayerHelper.getHelper(_parent!).parent!)
                    .referenceHolder!)) {
              position = PdfDocumentHelper.getHelper(_document!).order!.indexOf(
                  PdfLayerHelper.getHelper(
                          PdfLayerHelper.getHelper(_parent!).parent!)
                      .referenceHolder!);
              PdfDocumentHelper.getHelper(_document!)
                  .order!
                  .removeAt(position + 1);
              PdfDocumentHelper.getHelper(_document!).order!.insert(
                  position + 1,
                  PdfLayerHelper.getHelper(
                          PdfLayerHelper.getHelper(_parent!).parent!)
                      .sublayer);
            }
          }
        }
      }

      PdfLayerHelper.getHelper(_parent!).child.add(layer);

      if (PdfLayerHelper.getHelper(_parent!).parentLayer.isEmpty) {
        PdfLayerHelper.getHelper(layer).parentLayer.add(_parent!);
      } else {
        for (int i = 0;
            i < PdfLayerHelper.getHelper(_parent!).parentLayer.length;
            i++) {
          if (!PdfLayerHelper.getHelper(layer)
              .parentLayer
              .contains(PdfLayerHelper.getHelper(_parent!).parentLayer[i])) {
            PdfLayerHelper.getHelper(layer)
                .parentLayer
                .add(PdfLayerHelper.getHelper(_parent!).parentLayer[i]);
          }
        }
        PdfLayerHelper.getHelper(layer).parentLayer.add(_parent!);
      }
    }
  }

  IPdfPrimitive _createOptionalContentViews(PdfLayer layer) {
    final PdfArray usageApplication = PdfArray();
    _optionalContent[PdfDictionaryProperties.name] = PdfString('Layers');
    _optionalContent[PdfDictionaryProperties.ocgOrder] =
        PdfDocumentHelper.getHelper(_document!).order;
    _optionalContent[PdfDictionaryProperties.ocgOn] =
        PdfDocumentHelper.getHelper(_document!).on;
    _optionalContent[PdfDictionaryProperties.ocgOff] =
        PdfDocumentHelper.getHelper(_document!).off;
    final PdfArray category = PdfArray();
    category.add(PdfName('Print'));
    final PdfDictionary applicationDictionary = PdfDictionary();
    applicationDictionary[PdfDictionaryProperties.category] = category;
    applicationDictionary[PdfDictionaryProperties.ocg] =
        PdfDocumentHelper.getHelper(_document!).printLayer;
    applicationDictionary[PdfDictionaryProperties.event] = PdfName('Print');
    usageApplication.add(PdfReferenceHolder(applicationDictionary));
    _optionalContent[PdfDictionaryProperties.usageApplication] =
        usageApplication;
    return _optionalContent;
  }

  void _getDocumentLayer(PdfDocument document) {
    PdfDictionary? layerDictionary;
    PdfReferenceHolder layerReference;
    if (PdfDocumentHelper.getHelper(_document!)
        .catalog
        .containsKey(PdfDictionaryProperties.ocProperties)) {
      final PdfDictionary? ocProperties = PdfCrossTable.dereference(
          PdfDocumentHelper.getHelper(_document!)
              .catalog[PdfDictionaryProperties.ocProperties]) as PdfDictionary?;
      if (ocProperties != null) {
        if (ocProperties.containsKey(PdfDictionaryProperties.ocg)) {
          final PdfArray ocGroup = PdfCrossTable.dereference(
              ocProperties[PdfDictionaryProperties.ocg])! as PdfArray;
          for (int i = 0; i < ocGroup.count; i++) {
            if (ocGroup[i] is PdfReferenceHolder) {
              layerReference = ocGroup[i]! as PdfReferenceHolder;
              layerDictionary = layerReference.object as PdfDictionary?;
              final PdfLayer layer = PdfLayerHelper.internal();
              if (layerDictionary != null &&
                  layerDictionary.containsKey(PdfDictionaryProperties.name)) {
                final PdfString layerName = PdfCrossTable.dereference(
                        layerDictionary[PdfDictionaryProperties.name])!
                    as PdfString;
                layer.name = layerName.value;
                PdfLayerHelper.getHelper(layer).dictionary = layerDictionary;
                PdfLayerHelper.getHelper(layer).referenceHolder =
                    layerReference;
                final IPdfPrimitive? layerId = PdfCrossTable.dereference(
                    layerDictionary[PdfDictionaryProperties.layerID]);
                if (layerId != null) {
                  PdfLayerHelper.getHelper(layer).layerId = layerId.toString();
                }
                final PdfDictionary? usage = PdfCrossTable.dereference(
                        layerDictionary[PdfDictionaryProperties.usage])
                    as PdfDictionary?;

                if (usage != null) {
                  final PdfDictionary? printOption = PdfCrossTable.dereference(
                      usage[PdfDictionaryProperties.print]) as PdfDictionary?;

                  if (printOption != null) {
                    PdfLayerHelper.getHelper(layer).printOption = printOption;
                  }
                }
              }
              PdfLayerHelper.getHelper(layer).document = document;
              PdfLayerHelper.getHelper(layer).layer = layer;
              // layer.parsingLayerPage();
              _layerDictionary[layerReference] = layer;
              list.add(layer);
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

  void _checkLayerVisible(PdfDictionary ocProperties) {
    PdfArray? visible;
    if (PdfDocumentHelper.getHelper(_document!)
        .catalog
        .containsKey(PdfDictionaryProperties.ocProperties)) {
      final PdfDictionary? defaultView = PdfCrossTable.dereference(
          ocProperties[PdfDictionaryProperties.defaultView]) as PdfDictionary?;

      if (defaultView != null &&
          defaultView.containsKey(PdfDictionaryProperties.ocgOff)) {
        visible = PdfCrossTable.dereference(
            defaultView[PdfDictionaryProperties.ocgOff]) as PdfArray?;
      }
      if (visible != null) {
        for (int i = 0; i < visible.count; i++) {
          final PdfLayer? pdfLayer =
              _layerDictionary[visible[i]! as PdfReferenceHolder];
          if (pdfLayer != null) {
            pdfLayer.visible = false;
            if (PdfLayerHelper.getHelper(pdfLayer).dictionary != null &&
                PdfLayerHelper.getHelper(pdfLayer)
                    .dictionary!
                    .containsKey(PdfDictionaryProperties.visible)) {
              PdfLayerHelper.getHelper(pdfLayer).dictionary!.setProperty(
                  PdfDictionaryProperties.visible, PdfBoolean(false));
            }
          }
        }
      }
    }
  }

  void _checkParentLayer(PdfDictionary ocProperties) {
    final PdfDictionary? defaultView = PdfCrossTable.dereference(
        ocProperties[PdfDictionaryProperties.defaultView]) as PdfDictionary?;
    if (defaultView != null) {
      final PdfArray? array = PdfCrossTable.dereference(
          defaultView[PdfDictionaryProperties.ocgOrder]) as PdfArray?;
      if (array != null) {
        _parsingLayerOrder(array, _layerDictionary);
      }
    }
  }

  void _checkLayerLock(PdfDictionary ocProperties) {
    PdfArray? locked;
    final PdfDictionary? defaultView = PdfCrossTable.dereference(
        ocProperties[PdfDictionaryProperties.defaultView]) as PdfDictionary?;
    if (defaultView != null &&
        defaultView.containsKey(PdfDictionaryProperties.ocgLock)) {
      locked = PdfCrossTable.dereference(
          defaultView[PdfDictionaryProperties.ocgLock]) as PdfArray?;
    }
    if (locked != null) {
      for (int i = 0; i < locked.count; i++) {
        final PdfLayer? pdfLayer =
            _layerDictionary[locked[i]! as PdfReferenceHolder];
        if (pdfLayer != null) {
          continue;
        }
      }
    }
  }

  void _createLayerHierarchical(PdfDictionary ocProperties) {
    final PdfDictionary? defaultView = PdfCrossTable.dereference(
        ocProperties[PdfDictionaryProperties.defaultView]) as PdfDictionary?;
    if (defaultView != null &&
        defaultView.containsKey(PdfDictionaryProperties.ocgOrder)) {
      if (_layerDictionary.isNotEmpty) {
        list.clear();
        _layerDictionary.forEach((PdfReferenceHolder key, PdfLayer value) {
          final PdfLayer pdfLayer = value;
          if (PdfLayerHelper.getHelper(pdfLayer).parent == null &&
              !list.contains(pdfLayer)) {
            list.add(pdfLayer);
          } else if (PdfLayerHelper.getHelper(pdfLayer).child.isNotEmpty) {
            _addChildlayer(PdfLayerHelper.getHelper(pdfLayer).parent!);
          } else if (PdfLayerHelper.getHelper(pdfLayer).parent != null &&
              PdfLayerHelper.getHelper(pdfLayer).child.isEmpty &&
              !PdfLayerHelper.getHelper(pdfLayer)
                  .parent!
                  .layers
                  ._helper
                  .list
                  .contains(pdfLayer)) {
            PdfLayerHelper.getHelper(pdfLayer)
                .parent!
                .layers
                ._helper
                ._addNestedLayer(pdfLayer);
          }
        });
      }
    }
  }

  void _addChildlayer(PdfLayer pdfLayer) {
    for (int i = 0; i < PdfLayerHelper.getHelper(pdfLayer).child.length; i++) {
      final PdfLayer child = PdfLayerHelper.getHelper(pdfLayer).child[i];
      if (!pdfLayer.layers._helper.list.contains(child)) {
        pdfLayer.layers._helper._addNestedLayer(child);
      }
    }
  }

  int _addNestedLayer(PdfLayer layer) {
    list.add(layer);
    PdfLayerHelper.getHelper(layer).layer = layer;
    return list.length - 1;
  }

  void _parsingLayerOrder(
      PdfArray array, Map<PdfReferenceHolder, PdfLayer> layerDictionary,
      [PdfLayer? parent]) {
    PdfReferenceHolder reference;
    PdfLayer? layer;
    for (int i = 0; i < array.count; i++) {
      if (array[i] is PdfReferenceHolder) {
        reference = array[i]! as PdfReferenceHolder;
        layerDictionary.forEach((PdfReferenceHolder key, PdfLayer value) {
          if (identical(key.object, reference.object) ||
              identical(key.reference, reference.reference)) {
            layer = value;
          }
        });
        if (layer != null) {
          if (parent != null) {
            PdfLayerHelper.getHelper(parent).child.add(layer!);
            if (PdfLayerHelper.getHelper(parent).parentLayer.isEmpty) {
              PdfLayerHelper.getHelper(parent).parentLayer.add(parent);
              PdfLayerHelper.getHelper(layer!).parent = parent;
            } else {
              for (int j = 0;
                  j < PdfLayerHelper.getHelper(parent).parentLayer.length;
                  j++) {
                if (!PdfLayerHelper.getHelper(layer!).parentLayer.contains(
                    PdfLayerHelper.getHelper(parent).parentLayer[j])) {
                  PdfLayerHelper.getHelper(layer!)
                      .parentLayer
                      .add(PdfLayerHelper.getHelper(parent).parentLayer[j]);
                }
              }
              PdfLayerHelper.getHelper(layer!).parentLayer.add(parent);
              PdfLayerHelper.getHelper(layer!).parent = parent;
            }
          }
          if (array.count > i + 1 &&
              PdfCrossTable.dereference(array[i + 1]) is PdfArray) {
            i++;
            final PdfArray pdfArray =
                PdfCrossTable.dereference(array[i])! as PdfArray;
            PdfLayerHelper.getHelper(layer!).sublayer.add(pdfArray);
            _parsingLayerOrder(pdfArray, layerDictionary, layer);
          }
        }
      } else if (PdfCrossTable.dereference(array[i]) is PdfArray) {
        final PdfArray? subarray =
            PdfCrossTable.dereference(array[i]) as PdfArray?;
        if (subarray == null) {
          return;
        }
        if (subarray[0] is PdfString) {
          parent = null;
          _parsingLayerOrder(subarray, layerDictionary, parent);
        } else {
          parent = null;
          _parsingLayerOrder(PdfCrossTable.dereference(array[i])! as PdfArray,
              layerDictionary, parent);
        }
      }
    }
  }

  void _removeLayer(PdfLayer layer, bool isRemoveContent) {
    PdfDictionary? dictionary;
    if (_document != null) {
      dictionary = PdfDocumentHelper.getHelper(_document!).catalog;
      if (dictionary.containsKey(PdfDictionaryProperties.ocProperties)) {
        final PdfDictionary? ocPropertie = PdfCrossTable.dereference(
            dictionary[PdfDictionaryProperties.ocProperties]) as PdfDictionary?;
        if (ocPropertie != null) {
          final PdfArray? ocGroup = PdfCrossTable.dereference(
              ocPropertie[PdfDictionaryProperties.ocg]) as PdfArray?;
          if (ocGroup != null) {
            _removeOCProperties(
                ocGroup, PdfLayerHelper.getHelper(layer).referenceHolder);
          }
          if (ocPropertie.containsKey(PdfDictionaryProperties.defaultView)) {
            final PdfDictionary? defaultView = PdfCrossTable.dereference(
                    ocPropertie[PdfDictionaryProperties.defaultView])
                as PdfDictionary?;
            if (defaultView != null) {
              PdfArray? on, off;
              if (defaultView.containsKey(PdfDictionaryProperties.ocgOrder)) {
                final PdfArray? order = PdfCrossTable.dereference(
                    defaultView[PdfDictionaryProperties.ocgOrder]) as PdfArray?;
                if (order != null) {
                  _removeOrder(layer, order, <PdfArray>[]);
                  // _removeOCProperties(order, layer.referenceHolder);
                }
              }
              if (defaultView.containsKey(PdfDictionaryProperties.ocgLock)) {
                final PdfArray? locked = PdfCrossTable.dereference(
                    defaultView[PdfDictionaryProperties.ocgLock]) as PdfArray?;
                if (locked != null) {
                  _removeOCProperties(
                      locked, PdfLayerHelper.getHelper(layer).referenceHolder);
                }
              }
              if (defaultView.containsKey(PdfDictionaryProperties.ocgOff)) {
                off = PdfCrossTable.dereference(
                    defaultView[PdfDictionaryProperties.ocgOff]) as PdfArray?;
              }
              if (defaultView.containsKey(PdfDictionaryProperties.ocgOn)) {
                on = PdfCrossTable.dereference(
                    defaultView[PdfDictionaryProperties.ocgOn]) as PdfArray?;
              } else if (defaultView.containsKey('ON')) {
                on = PdfCrossTable.dereference(defaultView['ON']) as PdfArray?;
              }
              if (defaultView
                  .containsKey(PdfDictionaryProperties.usageApplication)) {
                final PdfArray? usage = PdfCrossTable.dereference(
                        defaultView[PdfDictionaryProperties.usageApplication])
                    as PdfArray?;
                if (usage != null) {
                  _removeOCProperties(
                      usage, PdfLayerHelper.getHelper(layer).referenceHolder);
                }
              }
              _removeVisible(layer, on, off);
            }
          }
        }
      }
      if (isRemoveContent) {
        _removeLayerContent(layer);
      }
    }
  }

  void _removeVisible(PdfLayer layer, PdfArray? on, PdfArray? off) {
    if (layer.visible) {
      if (on != null) {
        _removeOCProperties(
            on, PdfLayerHelper.getHelper(layer).referenceHolder);
      }
    } else {
      if (off != null) {
        _removeOCProperties(
            off, PdfLayerHelper.getHelper(layer).referenceHolder);
      }
    }
  }

  void _removeOrder(PdfLayer layer, PdfArray order, List<PdfArray> arrayList) {
    bool isRemoveOrder = false;
    for (int i = 0; i < order.count; i++) {
      if (order[i] is PdfReferenceHolder) {
        final PdfReferenceHolder holder = order[i]! as PdfReferenceHolder;
        if (identical(holder.object,
                PdfLayerHelper.getHelper(layer).referenceHolder!.object) ||
            identical(holder.reference,
                PdfLayerHelper.getHelper(layer).referenceHolder!.reference)) {
          if (i != order.count - 1) {
            if (order[i + 1] is PdfArray) {
              order.removeAt(i);
              order.removeAt(i);
              isRemoveOrder = true;
              break;
            } else {
              order.removeAt(i);
              isRemoveOrder = true;
              break;
            }
          } else {
            order.removeAt(i);
            isRemoveOrder = true;
            break;
          }
        }
      } else if (order[i] is PdfArray) {
        arrayList.add(order[i]! as PdfArray);
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
      PdfArray content, PdfReferenceHolder? referenceHolder) {
    bool isChange = false;
    for (int i = 0; i < content.count; i++) {
      final IPdfPrimitive? primitive = content.elements[i];
      if (primitive != null && primitive is PdfReferenceHolder) {
        final PdfReferenceHolder holder = primitive;
        if (holder.reference != null && referenceHolder!.reference != null) {
          if (holder.reference!.objNum == referenceHolder.reference!.objNum) {
            content.elements.removeAt(i);
            isChange = true;
            i--;
          }
        } else if (identical(holder, referenceHolder)) {
          content.elements.removeAt(i);
          isChange = true;
          i--;
        } else if (identical(holder.object, referenceHolder!.object)) {
          content.elements.removeAt(i);
          isChange = true;
          i--;
        }
      } else if (primitive != null && primitive is PdfArray) {
        _removeOCProperties(primitive, referenceHolder);
      }
    }
    if (isChange) {
      content.changed = true;
    }
  }

  void _removeLayerContent(PdfLayer layer) {
    PdfDictionary? properties;
    bool isSkip = false;
    PdfDictionary? xObject;
    if (!PdfLayerHelper.getHelper(layer).pageParsed) {
      PdfLayerHelper.getHelper(layer).parsingLayerPage();
      _removeLayerContent(layer);
      return;
    }
    if (PdfLayerHelper.getHelper(layer).pages.isNotEmpty) {
      for (int i = 0; i < PdfLayerHelper.getHelper(layer).pages.length; i++) {
        final PdfDictionary? resource = PdfCrossTable.dereference(PdfPageHelper
                .getHelper(PdfLayerHelper.getHelper(layer).pages[i])
            .dictionary![PdfDictionaryProperties.resources]) as PdfDictionary?;
        if (resource != null) {
          properties = PdfCrossTable.dereference(
              resource[PdfDictionaryProperties.properties]) as PdfDictionary?;
          xObject = PdfCrossTable.dereference(
              resource[PdfDictionaryProperties.xObject]) as PdfDictionary?;
          if (properties != null) {
            if (properties
                .containsKey(PdfLayerHelper.getHelper(layer).layerId)) {
              properties.remove(PdfLayerHelper.getHelper(layer).layerId);
            }
          }
          if (xObject != null &&
              PdfLayerHelper.getHelper(layer).xobject.isNotEmpty) {
            for (final PdfName? key in xObject.items!.keys) {
              if (PdfLayerHelper.getHelper(layer).xobject.contains(key!.name)) {
                xObject.remove(key);
              }
              if (xObject.items!.isEmpty) {
                break;
              }
            }
          }
          final PdfArray content =
              PdfPageHelper.getHelper(PdfLayerHelper.getHelper(layer).pages[i])
                  .contents;
          for (int m = 0; m < content.count; m++) {
            List<int>? stream = <int>[];
            final PdfStream data = PdfStream();
            final PdfStream pageContent =
                PdfCrossTable.dereference(content[m])! as PdfStream;
            if (PdfPageHelper.getHelper(
                    PdfLayerHelper.getHelper(layer).pages[i])
                .isLoadedPage) {
              pageContent.decompress();
            }
            stream = pageContent.dataStream;
            final ContentParser parser = ContentParser(stream);
            final PdfRecordCollection recordCollection = parser.readContent()!;
            for (int j = 0; j < recordCollection.recordCollection.length; j++) {
              final String? mOperator =
                  recordCollection.recordCollection[j].operatorName;
              if (mOperator == 'BMC' ||
                  mOperator == 'EMC' ||
                  mOperator == 'BDC') {
                _processBeginMarkContent(layer, mOperator,
                    recordCollection.recordCollection[j].operands, data);
                isSkip = true;
              }
              if (mOperator == PdfOperators.paintXObject) {
                if (PdfLayerHelper.getHelper(layer).xobject.contains(
                    recordCollection.recordCollection[j].operands![0])) {
                  isSkip = true;
                }
              }
              if (mOperator == 'RG' ||
                  mOperator == PdfOperators.saveState ||
                  mOperator == PdfOperators.restoreState ||
                  mOperator == PdfOperators.setLineWidth ||
                  mOperator == PdfOperators.setLineCapStyle ||
                  mOperator == PdfOperators.setLineJoinStyle ||
                  mOperator == PdfOperators.setMiterLimit ||
                  mOperator == PdfOperators.setDashPattern ||
                  mOperator == PdfOperators.setGraphicsState ||
                  mOperator == PdfOperators.currentMatrix ||
                  mOperator == PdfOperators.selectColorSpaceForNonStroking ||
                  mOperator == PdfOperators.selectColorSpaceForStroking) {
                if (!isSkip) {
                  _streamWrite(recordCollection.recordCollection[j].operands,
                      mOperator, false, data);
                }
              } else if (!isSkip) {
                _streamWrite(recordCollection.recordCollection[j].operands,
                    mOperator, true, data);
              }
              isSkip = false;
            }
            if (data.dataStream!.isNotEmpty) {
              pageContent.clear();
              pageContent.dataStream!.clear();
              pageContent.write(data.dataStream);
            } else {
              pageContent.clear();
            }
          }
        }
      }
    }
  }

  void _processBeginMarkContent(PdfLayer parser, String? mOperator,
      List<String>? operands, PdfStream data) {
    if ('BDC' == mOperator) {
      String? operand;
      if (operands!.length > 1 && ((operands[0]) == '/OC')) {
        operand = operands[1].substring(1);
      }
      if (_bdcCount > 0) {
        _bdcCount++;
        return;
      }
      if (operand != null &&
          (operand == PdfLayerHelper.getHelper(parser).layerId)) {
        _bdcCount++;
      }
    }
    _streamWrite(operands, mOperator, true, data);
    if (('EMC' == mOperator) && _bdcCount > 0) {
      _bdcCount--;
    }
  }

  void _streamWrite(
      List<String>? operands, String? mOperator, bool skip, PdfStream data) {
    PdfString pdfString;
    if (skip && _bdcCount > 0) {
      return;
    }
    if (operands != null) {
      for (final String operand in operands) {
        pdfString = PdfString(operand);
        data.write(pdfString.data);
        data.write(PdfOperators.whiteSpace);
      }
    }
    pdfString = PdfString(mOperator!);
    data.write(pdfString.data);
    data.write(PdfOperators.newLine);
  }
}
