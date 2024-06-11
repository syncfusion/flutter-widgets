import '../../interfaces/pdf_interface.dart';
import '../exporting/pdf_text_extractor/parser/content_parser.dart';
import '../general/pdf_collection.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_resources.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../pdf_document/enums.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'pdf_page_layer.dart';

/// The class provides methods and properties
/// to handle the collections of [PdfPageLayer].
class PdfPageLayerCollection extends PdfObjectCollection {
  //Constructor
  /// Initializes a new instance of the
  /// [PdfPageLayerCollection] class with PDF page.
  PdfPageLayerCollection(PdfPage page) : super() {
    _helper = PdfPageLayerCollectionHelper(this, page);
  }

  //Fields
  late PdfPageLayerCollectionHelper _helper;

  //Properties
  /// Gets [PdfPageLayer] by its index from [PdfPageLayerCollection].
  PdfPageLayer operator [](int index) => _helper._returnValue(index);

  //Public methods
  /// Creates a new [PdfPageLayer] and adds it to the end of the collection.
  PdfPageLayer add({String? name, bool? visible}) {
    return _helper.add(name, visible);
  }

  /// Adds [PdfPageLayer] to the collection.
  int addLayer(PdfPageLayer layer) {
    return _helper.addLayer(layer);
  }

  /// Returns index of the [PdfPageLayer] in the collection if exists,
  /// -1 otherwise.
  int indexOf(PdfPageLayer layer) {
    return _helper.indexOf(layer);
  }

  //Implementation

  /// Removes layer from the collection.
  void remove({PdfPageLayer? layer, String? name}) {
    _helper.remove(layer, name);
  }

  /// Removes layer by its index from collections
  void removeAt(int index) {
    _helper.removeAt(index);
  }

  /// Clears layers from the [PdfPageLayerCollection].
  void clear() {
    _helper.clear();
  }
}

/// [PdfPageLayerCollection] helper
class PdfPageLayerCollectionHelper extends PdfObjectCollectionHelper {
  /// internal constructor
  PdfPageLayerCollectionHelper(this.pageLayerCollection, PdfPage page)
      : super(pageLayerCollection) {
    _optionalContent = PdfDictionary();
    _subLayer = false;
    _page = page;
    _parseLayers(page);
  }

  /// internal field
  PdfPageLayerCollection pageLayerCollection;

  //Fields
  late PdfPage _page;
  late bool _subLayer;
  PdfDictionary? _optionalContent;
  int _bdcCount = 0;

  PdfPageLayer _returnValue(int index) {
    return list[index] as PdfPageLayer;
  }

  /// internal method
  static PdfPageLayerCollectionHelper getHelper(
      PdfPageLayerCollection pageLayerCollection) {
    return pageLayerCollection._helper;
  }

  /// internal method
  List<int>? combineContent(bool skipSave) {
    return _combineContent(skipSave);
  }

  void _parseLayers(PdfPage page) {
    if (!PdfPageHelper.getHelper(page).isTextExtraction) {
      final PdfArray contents = PdfPageHelper.getHelper(page).contents;
      final PdfDictionary? resource =
          PdfPageHelper.getHelper(page).getResources();
      PdfDictionary? ocProperties;
      PdfDictionary? propertie;
      PdfPage? pdfLoaded;
      final Map<PdfReferenceHolder?, PdfPageLayer> pageLayerCollection =
          <PdfReferenceHolder?, PdfPageLayer>{};
      if (PdfPageHelper.getHelper(page).isLoadedPage) {
        pdfLoaded = page;
      }
      if (pdfLoaded != null) {
        propertie = PdfCrossTable.dereference(
            resource![PdfDictionaryProperties.properties]) as PdfDictionary?;
        if (PdfPageHelper.getHelper(pdfLoaded).document != null) {
          ocProperties = PdfCrossTable.dereference(PdfDocumentHelper.getHelper(
                  PdfPageHelper.getHelper(pdfLoaded).document!)
              .catalog[PdfDictionaryProperties.ocProperties]) as PdfDictionary?;
        }
      }

      if (ocProperties != null && (propertie != null)) {
        propertie.items!.forEach((PdfName? key, IPdfPrimitive? value) {
          final PdfReferenceHolder? layerReferenceHolder =
              value as PdfReferenceHolder?;
          final PdfDictionary? layerDictionary =
              PdfCrossTable.dereference(value) as PdfDictionary?;
          if ((layerDictionary != null && layerReferenceHolder != null) ||
              layerDictionary!.containsKey(PdfDictionaryProperties.ocg)) {
            _addLayer(page, layerDictionary, layerReferenceHolder, key!.name,
                pageLayerCollection, false);
          }
        });
      }
      if (ocProperties != null && pageLayerCollection.isNotEmpty) {
        _checkVisible(ocProperties, pageLayerCollection);
      }

      final PdfStream saveStream = PdfStream();
      final PdfStream restoreStream = PdfStream();
      const int saveState = 113;
      const int restoreState = 81;
      saveStream.data = <int>[saveState];
      if (contents.count > 0) {
        contents.insert(0, PdfReferenceHolder(saveStream));
      } else {
        contents.add(PdfReferenceHolder(saveStream));
      }
      restoreStream.data = <int>[restoreState];
      contents.add(PdfReferenceHolder(restoreStream));
    }
  }

  List<int>? _combineContent(bool skipSave) {
    final bool decompress = PdfPageHelper.getHelper(_page).isLoadedPage;
    List<int>? combinedData;
    final List<int> end = <int>[13, 10];
    if (PdfPageHelper.getHelper(_page).isLoadedPage) {
      combinedData = _combineProcess(_page, decompress, end, skipSave);
    }
    return combinedData;
  }

  List<int> _combineProcess(
      PdfPage page, bool decompress, List<int> end, bool isTextExtraction) {
    final List<int> data = <int>[];
    for (int i = 0; i < PdfPageHelper.getHelper(page).contents.count; i++) {
      PdfStream? layerStream;
      final IPdfPrimitive? contentPrimitive =
          PdfPageHelper.getHelper(page).contents[i];
      if (contentPrimitive != null && contentPrimitive is PdfReferenceHolder) {
        final IPdfPrimitive? primitive = contentPrimitive.object;
        if (primitive != null && primitive is PdfStream) {
          layerStream = primitive;
        }
      } else if (contentPrimitive != null && contentPrimitive is PdfStream) {
        layerStream = contentPrimitive;
      }
      if (layerStream != null) {
        if (decompress) {
          final bool isChanged =
              layerStream.changed != null && layerStream.changed!;
          layerStream.decompress();
          layerStream.changed = isChanged || !isTextExtraction;
        }
        data.addAll(layerStream.dataStream!);
        data.addAll(end);
      }
    }
    return data;
  }

  void _createLayerLoadedPage(PdfPageLayer layer) {
    final PdfDictionary ocProperties = PdfDictionary();
    final IPdfPrimitive? ocgroups = _createOptionContentDictionary(layer);
    bool isPresent = false;
    if (PdfPageHelper.getHelper(_page).document != null &&
        PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(_page).document!)
            .catalog
            .containsKey(PdfDictionaryProperties.ocProperties)) {
      final PdfDictionary? ocDictionary = PdfCrossTable.dereference(
          PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(_page).document!)
              .catalog[PdfDictionaryProperties.ocProperties]) as PdfDictionary?;
      if (ocDictionary != null &&
          ocDictionary.containsKey(PdfDictionaryProperties.ocg)) {
        final PdfArray? ocgsList =
            PdfCrossTable.dereference(ocDictionary[PdfDictionaryProperties.ocg])
                as PdfArray?;
        if (ocgsList != null) {
          isPresent = true;
          if (!ocgsList
              .contains(PdfPageLayerHelper.getHelper(layer).referenceHolder!)) {
            ocgsList.insert(ocgsList.count,
                PdfPageLayerHelper.getHelper(layer).referenceHolder!);
          }
        }
        if (ocDictionary.containsKey(PdfDictionaryProperties.defaultView)) {
          final PdfDictionary? defaultView =
              ocDictionary[PdfDictionaryProperties.defaultView]
                  as PdfDictionary?;
          if (defaultView != null) {
            PdfArray? on = PdfCrossTable.dereference(
                defaultView[PdfDictionaryProperties.ocgOn]) as PdfArray?;
            final PdfArray? order = PdfCrossTable.dereference(
                defaultView[PdfDictionaryProperties.ocgOrder]) as PdfArray?;
            PdfArray? off = PdfCrossTable.dereference(
                defaultView[PdfDictionaryProperties.ocgOff]) as PdfArray?;
            final PdfArray? usage = PdfCrossTable.dereference(
                    defaultView[PdfDictionaryProperties.usageApplication])
                as PdfArray?;

            if (on == null) {
              on = PdfArray();
              defaultView[PdfDictionaryProperties.ocgOn] = on;
            }

            if (!layer.visible && off == null) {
              off = PdfArray();
              defaultView[PdfDictionaryProperties.ocgOff] = off;
            }

            final PdfReferenceHolder referenceHolder =
                PdfPageLayerHelper.getHelper(layer).referenceHolder!;
            if (order != null && !order.contains(referenceHolder)) {
              order.insert(order.count, referenceHolder);
            }

            if (layer.visible && !on.contains(referenceHolder)) {
              on.insert(on.count, referenceHolder);
            }
            if (!layer.visible &&
                off != null &&
                !off.contains(referenceHolder)) {
              off.insert(off.count, referenceHolder);
            }

            if (usage != null && usage.count > 0) {
              final PdfDictionary? asDictionary =
                  PdfCrossTable.dereference(usage[0]) as PdfDictionary?;
              if (asDictionary != null &&
                  asDictionary.containsKey(PdfDictionaryProperties.ocg)) {
                final PdfArray? usageOcGroup = PdfCrossTable.dereference(
                    asDictionary[PdfDictionaryProperties.ocg]) as PdfArray?;
                if (usageOcGroup != null &&
                    !usageOcGroup.contains(referenceHolder)) {
                  usageOcGroup.insert(usageOcGroup.count, referenceHolder);
                }
              }
            }
          }
        }
      }
    }
    if (!isPresent && PdfPageHelper.getHelper(_page).document != null) {
      ocProperties[PdfDictionaryProperties.ocg] = ocgroups;
      ocProperties[PdfDictionaryProperties.defaultView] =
          _createOptionalContentViews(layer);
      PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(_page).document!)
          .catalog
          .setProperty(PdfDictionaryProperties.ocProperties, ocProperties);
    }
  }

  IPdfPrimitive? _createOptionContentDictionary(PdfPageLayer layer) {
    final PdfDictionary optionalContent = PdfDictionary();
    optionalContent[PdfDictionaryProperties.name] = PdfString(layer.name!);
    optionalContent[PdfDictionaryProperties.type] = PdfName('OCG');
    optionalContent[PdfDictionaryProperties.layerID] =
        PdfName(PdfPageLayerHelper.getHelper(layer).layerID);
    optionalContent[PdfDictionaryProperties.visible] =
        PdfBoolean(layer.visible);
    PdfPageLayerHelper.getHelper(layer).usage = _setPrintOption(layer);
    optionalContent[PdfDictionaryProperties.usage] =
        PdfReferenceHolder(PdfPageLayerHelper.getHelper(layer).usage);
    final PdfDocument document = PdfPageHelper.getHelper(_page).document!;
    PdfDocumentHelper.getHelper(document)
        .printLayer!
        .add(PdfReferenceHolder(optionalContent));
    final PdfReferenceHolder reference = PdfReferenceHolder(optionalContent);
    PdfDocumentHelper.getHelper(document).pdfPrimitive!.add(reference);
    PdfPageLayerHelper.getHelper(layer).dictionary = optionalContent;
    PdfPageLayerHelper.getHelper(layer).referenceHolder = reference;
    if (!_subLayer) {
      PdfDocumentHelper.getHelper(document).order!.add(reference);
      PdfDocumentHelper.getHelper(document).orderPosition =
          PdfDocumentHelper.getHelper(document).orderPosition! + 1;
    }
    if (layer.visible) {
      PdfDocumentHelper.getHelper(document).on!.add(reference);
      PdfDocumentHelper.getHelper(document).onPosition =
          PdfDocumentHelper.getHelper(document).onPosition! + 1;
    } else {
      PdfDocumentHelper.getHelper(document).off!.add(reference);
      PdfDocumentHelper.getHelper(document).offPosition =
          PdfDocumentHelper.getHelper(document).offPosition! + 1;
    }
    PdfDocumentHelper.getHelper(document).position =
        PdfDocumentHelper.getHelper(document).position! + 1;
    final PdfResources? resource =
        PdfPageHelper.getHelper(_page).getResources();
    if (resource != null &&
        resource.containsKey(PdfDictionaryProperties.properties) &&
        PdfPageHelper.getHelper(_page).isLoadedPage) {
      final PdfDictionary? dic =
          resource[PdfDictionaryProperties.properties] as PdfDictionary?;
      if (dic != null) {
        dic[PdfPageLayerHelper.getHelper(layer).layerID] = reference;
      } else {
        resource.properties[PdfPageLayerHelper.getHelper(layer).layerID] =
            reference;
        resource[PdfDictionaryProperties.properties] = resource.properties;
      }
    } else {
      resource!.properties[PdfPageLayerHelper.getHelper(layer).layerID] =
          reference;
      resource[PdfDictionaryProperties.properties] = resource.properties;
    }
    return PdfDocumentHelper.getHelper(document).pdfPrimitive;
  }

  PdfDictionary _setPrintOption(PdfPageLayer layer) {
    final PdfDictionary usage = PdfDictionary();
    PdfPageLayerHelper.getHelper(layer).printOption = PdfDictionary();
    PdfPageLayerHelper.getHelper(layer)
        .printOption![PdfDictionaryProperties.subtype] = PdfName('Print');
    usage[PdfDictionaryProperties.print] =
        PdfReferenceHolder(PdfPageLayerHelper.getHelper(layer).printOption);
    return usage;
  }

  IPdfPrimitive? _createOptionalContentViews(PdfPageLayer layer) {
    final PdfDocument document = PdfPageHelper.getHelper(_page).document!;
    final PdfArray usageApplication = PdfArray();
    _optionalContent![PdfDictionaryProperties.name] = PdfString('Layers');
    _optionalContent![PdfDictionaryProperties.ocgOrder] =
        PdfDocumentHelper.getHelper(document).order;
    _optionalContent![PdfDictionaryProperties.ocgOn] =
        PdfDocumentHelper.getHelper(document).on;
    _optionalContent![PdfDictionaryProperties.ocgOff] =
        PdfDocumentHelper.getHelper(document).off;
    final PdfArray category = PdfArray();
    category.add(PdfName('Print'));
    final PdfDictionary applicationDictionary = PdfDictionary();
    applicationDictionary[PdfDictionaryProperties.category] = category;
    applicationDictionary[PdfDictionaryProperties.ocg] =
        PdfDocumentHelper.getHelper(document).printLayer;
    applicationDictionary[PdfDictionaryProperties.event] = PdfName('Print');
    usageApplication.add(PdfReferenceHolder(applicationDictionary));
    if (PdfDocumentHelper.getHelper(document).conformanceLevel !=
            PdfConformanceLevel.a2b &&
        PdfDocumentHelper.getHelper(document).conformanceLevel !=
            PdfConformanceLevel.a3b) {
      _optionalContent![PdfDictionaryProperties.usageApplication] =
          usageApplication;
    }
    return _optionalContent;
  }

  void _addLayer(
      PdfPage page,
      PdfDictionary dictionary,
      PdfReferenceHolder? reference,
      String? key,
      Map<PdfReferenceHolder?, PdfPageLayer> pageLayerCollection,
      bool isResourceLayer) {
    final PdfPageLayer layer = PdfPageLayer(page);
    list.add(layer);
    if (!pageLayerCollection.containsKey(reference)) {
      pageLayerCollection[reference] = layer;
    }
    final PdfPageLayerHelper layerHelper = PdfPageLayerHelper.getHelper(layer);
    layerHelper.dictionary = dictionary;
    layerHelper.referenceHolder = reference;
    layerHelper.layerID = key;
    if (dictionary.containsKey(PdfDictionaryProperties.name)) {
      final PdfString? layerName =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.name])
              as PdfString?;
      if (layerName != null) {
        layer.name = layerName.value;
      }
    }
  }

  void _checkVisible(PdfDictionary ocproperties,
      Map<PdfReferenceHolder?, PdfPageLayer> layerDictionary) {
    final PdfDictionary? defaultView = PdfCrossTable.dereference(
        ocproperties[PdfDictionaryProperties.defaultView]) as PdfDictionary?;
    if (defaultView != null) {
      final PdfArray? visible =
          PdfCrossTable.dereference(defaultView[PdfDictionaryProperties.ocgOff])
              as PdfArray?;
      if (visible != null && layerDictionary.isNotEmpty) {
        for (int i = 0; i < visible.count; i++) {
          if (layerDictionary.containsKey(visible[i]! as PdfReferenceHolder)) {
            final PdfPageLayer? pdfLayer =
                layerDictionary[visible[i]! as PdfReferenceHolder];
            if (pdfLayer != null) {
              pdfLayer.visible = false;
              if (PdfPageLayerHelper.getHelper(pdfLayer).dictionary != null &&
                  PdfPageLayerHelper.getHelper(pdfLayer)
                      .dictionary!
                      .containsKey(PdfDictionaryProperties.visible)) {
                PdfPageLayerHelper.getHelper(pdfLayer).dictionary!.setProperty(
                    PdfDictionaryProperties.visible, PdfBoolean(false));
              }
            }
          }
        }
      }
    }
  }

  void _removeLayer(PdfPageLayer layer) {
    PdfDictionary? ocProperties;
    _removeLayerContent(layer);
    final PdfDictionary? resource = PdfCrossTable.dereference(
        PdfPageHelper.getHelper(_page)
            .dictionary![PdfDictionaryProperties.resources]) as PdfDictionary?;
    if (resource != null) {
      final PdfDictionary? properties = PdfCrossTable.dereference(
          resource[PdfDictionaryProperties.properties]) as PdfDictionary?;
      if (properties != null &&
          PdfPageLayerHelper.getHelper(layer).layerID != null &&
          properties.containsKey(PdfPageLayerHelper.getHelper(layer).layerID)) {
        properties.remove(PdfPageLayerHelper.getHelper(layer).layerID);
      }
    }
    final PdfPage page = _page;
    if (PdfPageHelper.getHelper(page).document != null &&
        PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(page).document!)
            .catalog
            .containsKey(PdfDictionaryProperties.ocProperties)) {
      ocProperties = PdfCrossTable.dereference(
          PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(page).document!)
              .catalog[PdfDictionaryProperties.ocProperties]) as PdfDictionary?;
    }
    if (ocProperties != null) {
      final PdfArray? ocGroup =
          PdfCrossTable.dereference(ocProperties[PdfDictionaryProperties.ocg])
              as PdfArray?;
      if (ocGroup != null) {
        _removeContent(
            ocGroup, PdfPageLayerHelper.getHelper(layer).referenceHolder);
      }
      final PdfDictionary? defaultView = PdfCrossTable.dereference(
          ocProperties[PdfDictionaryProperties.defaultView]) as PdfDictionary?;
      if (defaultView != null) {
        final PdfArray? on = PdfCrossTable.dereference(
            defaultView[PdfDictionaryProperties.ocgOn]) as PdfArray?;
        final PdfArray? order = PdfCrossTable.dereference(
            defaultView[PdfDictionaryProperties.ocgOrder]) as PdfArray?;
        final PdfArray? off = PdfCrossTable.dereference(
            defaultView[PdfDictionaryProperties.ocgOff]) as PdfArray?;
        final PdfArray? usage = PdfCrossTable.dereference(
            defaultView[PdfDictionaryProperties.usageApplication]) as PdfArray?;

        if (usage != null && usage.count > 0) {
          for (int i = 0; i < usage.count; i++) {
            final PdfDictionary? usageDictionary =
                PdfCrossTable.dereference(usage[i]) as PdfDictionary?;
            if (usageDictionary != null &&
                usageDictionary.containsKey(PdfDictionaryProperties.ocg)) {
              final PdfArray? usageOcGroup =
                  usageDictionary[PdfDictionaryProperties.ocg] as PdfArray?;
              if (usageOcGroup != null) {
                _removeContent(usageOcGroup,
                    PdfPageLayerHelper.getHelper(layer).referenceHolder);
              }
            }
          }
        }
        if (order != null) {
          _removeContent(
              order, PdfPageLayerHelper.getHelper(layer).referenceHolder);
        }
        if (layer.visible && on != null) {
          _removeContent(
              on, PdfPageLayerHelper.getHelper(layer).referenceHolder);
        } else if (off != null) {
          _removeContent(
              off, PdfPageLayerHelper.getHelper(layer).referenceHolder);
        }
      }
    }
  }

  void _removeContent(PdfArray content, PdfReferenceHolder? referenceHolder) {
    bool flag = false;
    for (int i = 0; i < content.count; i++) {
      final IPdfPrimitive? primitive = content.elements[i];
      if (primitive != null && primitive is PdfReferenceHolder) {
        final PdfReferenceHolder reference = primitive;
        if (reference.reference != null && referenceHolder!.reference != null) {
          if (reference.reference!.objNum ==
              referenceHolder.reference!.objNum) {
            content.elements.removeAt(i);
            flag = true;
            i--;
          }
        } else if (identical(content.elements[i], referenceHolder)) {
          content.elements.removeAt(i);
          flag = true;
          i--;
        } else if (identical(
            (content.elements[i]! as PdfReferenceHolder).object,
            referenceHolder!.object)) {
          content.elements.removeAt(i);
          flag = true;
          i--;
        }
      } else if (content.elements[i]! is PdfArray) {
        _removeContent(content.elements[i]! as PdfArray, referenceHolder);
      }
    }
    if (flag) {
      content.changed = true;
    }
  }

  void _removeLayerContent(PdfPageLayer layer) {
    bool isSkip = false;
    for (int m = 0; m < PdfPageHelper.getHelper(_page).contents.count; m++) {
      bool isNewContentStream = false;
      bool? removePageContent = false;
      List<int>? stream = <int>[];
      final IPdfPrimitive? primitive =
          PdfPageHelper.getHelper(_page).contents[m];
      if (primitive! is PdfReferenceHolder) {
        final PdfReferenceHolder pdfReference = primitive as PdfReferenceHolder;
        if (pdfReference.reference == null) {
          isNewContentStream = true;
        }
      }
      final PdfStream pageContent =
          PdfCrossTable.dereference(PdfPageHelper.getHelper(_page).contents[m])!
              as PdfStream;
      final PdfStream data = PdfStream();
      if (PdfPageHelper.getHelper(_page).isLoadedPage) {
        pageContent.decompress();
      }
      stream = pageContent.dataStream;
      final ContentParser parser = ContentParser(stream);
      final PdfRecordCollection recordCollection = parser.readContent()!;
      for (int j = 0; j < recordCollection.recordCollection.length; j++) {
        final String? mOperator =
            recordCollection.recordCollection[j].operatorName;
        if (mOperator == 'BMC' || mOperator == 'EMC' || mOperator == 'BDC') {
          final Map<String, bool> returnedValue = _processBeginMarkContent(
              layer,
              mOperator,
              recordCollection.recordCollection[j].operands,
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
        if (recordCollection.recordCollection[j].operands!.isNotEmpty &&
            recordCollection.recordCollection[j].operands![0].startsWith('/')) {
          id = recordCollection.recordCollection[j].operands![0].substring(1);
        }
        if (mOperator == PdfOperators.paintXObject &&
            (id == PdfPageLayerHelper.getHelper(layer).layerID)) {
          isSkip = true;
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
          _streamWrite(recordCollection.recordCollection[j].operands, mOperator,
              true, data);
        }
        isSkip = false;
      }
      if (data.dataStream!.isNotEmpty && !removePageContent!) {
        pageContent.clear();
        pageContent.dataStream!.clear();
        pageContent.write(data.dataStream);
      } else {
        pageContent.clear();
      }
      if (removePageContent!) {
        _removeContent(PdfPageHelper.getHelper(_page).contents,
            PdfPageLayerHelper.getHelper(layer).referenceHolder);
        if (PdfPageLayerHelper.getHelper(layer).graphics != null &&
            PdfGraphicsHelper.getHelper(
                        PdfPageLayerHelper.getHelper(layer).graphics!)
                    .streamWriter !=
                null) {
          final PdfStream? lcontent = PdfGraphicsHelper.getHelper(
                  PdfPageLayerHelper.getHelper(layer).graphics!)
              .streamWriter!
              .stream;
          if (lcontent != null) {
            _removeContent(PdfPageHelper.getHelper(_page).contents,
                PdfReferenceHolder(lcontent));
          }
        }
      }
    }
  }

  Map<String, bool> _processBeginMarkContent(
      PdfPageLayer parser,
      String? mOperator,
      List<String>? operands,
      PdfStream data,
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
          (operand == PdfPageLayerHelper.getHelper(parser).layerID) &&
          !isNewContentStream) {
        _bdcCount++;
      } else if (operand != null &&
          (operand == PdfPageLayerHelper.getHelper(parser).layerID) &&
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

  /// Creates a new [PdfPageLayer] and adds it to the end of the collection.
  PdfPageLayer add(String? name, bool? visible) {
    final PdfPageLayer layer = PdfPageLayer(_page);
    if (name != null) {
      layer.name = name;
      final String? layerID = PdfPageLayerHelper.getHelper(layer).layerID;
      if (layerID == null) {
        PdfPageLayerHelper.getHelper(layer).layerID =
            'OCG_${PdfResources.globallyUniqueIdentifier}';
      }
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
    list.add(layer);
    final int listIndex = pageLayerCollection.count - 1;
    PdfPageHelper.getHelper(_page).contents.add(PdfReferenceHolder(layer));
    if (PdfPageLayerHelper.getHelper(layer).layerID != null) {
      if (PdfPageHelper.getHelper(_page).isLoadedPage) {
        _createLayerLoadedPage(layer);
      } else {
        final PdfDictionary ocProperties = PdfDictionary();
        ocProperties[PdfDictionaryProperties.ocg] =
            _createOptionContentDictionary(layer);
        ocProperties[PdfDictionaryProperties.defaultView] =
            _createOptionalContentViews(layer);
        PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(_page).document!)
            .catalog[PdfDictionaryProperties.ocProperties] = ocProperties;
      }
    }
    return listIndex;
  }

  /// Returns index of the [PdfPageLayer] in the collection if exists,
  /// -1 otherwise.
  int indexOf(PdfPageLayer layer) {
    return list.indexOf(layer);
  }

  //Implementation

  /// Removes layer from the collection.
  void remove(PdfPageLayer? layer, String? name) {
    if (layer == null && name == null) {
      ArgumentError.value('layer or layerName required');
    }
    if (layer != null) {
      _removeLayer(layer);
      list.remove(layer);
    } else {
      for (int i = 0; i < list.length; i++) {
        final PdfPageLayer layer = list[i] as PdfPageLayer;
        if (layer.name == name) {
          _removeLayer(layer);
          list.remove(layer);
          break;
        }
      }
    }
  }

  /// Removes layer by its index from collections
  void removeAt(int index) {
    if (index < 0 || index > list.length - 1) {
      ArgumentError.value(
          '$index Value can not be less 0 and greater List.Count - 1');
    }
    final PdfPageLayer layer = pageLayerCollection[index];
    _removeLayer(layer);
    list.removeAt(index);
  }

  /// Clears layers from the [PdfPageLayerCollection].
  void clear() {
    for (int i = 0; i < _page.layers._helper.list.length; i++) {
      final PdfPageLayer layer = _page.layers._helper.list[i] as PdfPageLayer;
      _removeLayer(layer);
    }
    _page.layers._helper.list.clear();
  }
}
