import 'dart:math';
import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../drawing/drawing.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_margins.dart';
import '../graphics/pdf_resources.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_layer_collection.dart';
import 'pdf_section.dart';
import 'pdf_section_collection.dart';

/// The [PdfLayer] used to create layers in PDF document.
class PdfLayer implements IPdfWrapper {
  // Constructor
  PdfLayer._() {
    _helper = PdfLayerHelper(this);
    _clipPageTemplates = true;
    _helper._content = PdfStream();
    _helper.dictionary = PdfDictionary();
  }

  // Fields
  late PdfLayerHelper _helper;
  bool _clipPageTemplates = true;
  PdfGraphics? _graphics;
  final Map<PdfGraphics, PdfGraphics> _graphicsMap =
      <PdfGraphics, PdfGraphics>{};
  final Map<PdfPage, PdfGraphics> _pageGraphics = <PdfPage, PdfGraphics>{};
  bool _isEmptyLayer = false;
  String? _name;
  bool _visible = true;
  PdfLayerCollection? _layerCollection;
  bool? _isPresent;

  // Properties
  /// Gets the name of the layer
  String? get name => _name;

  /// Sets the name of the layer
  set name(String? value) {
    _name = value;
    if (_helper.dictionary != null && _name != null && _name != '') {
      _helper.dictionary!
          .setProperty(PdfDictionaryProperties.name, PdfString(_name!));
    }
  }

  /// Gets the visibility of the page layer.
  bool get visible {
    if (_helper.dictionary != null &&
        _helper.dictionary!.containsKey(PdfDictionaryProperties.visible)) {
      _visible =
          (_helper.dictionary![PdfDictionaryProperties.visible]! as PdfBoolean)
              .value!;
    }
    return _visible;
  }

  /// Sets the visibility of the page layer.
  set visible(bool value) {
    _visible = value;
    if (_helper.dictionary != null) {
      _helper.dictionary![PdfDictionaryProperties.visible] = PdfBoolean(value);
    }
  }

  /// Gets the collection of child [PdfLayer]
  PdfLayerCollection get layers {
    _layerCollection ??=
        PdfLayerCollectionHelper.withLayer(_helper.document, _helper.layer);
    return _layerCollection!;
  }

  // Implementation
  /// Initializes Graphics context of the layer.
  PdfGraphics createGraphics(PdfPage page) {
    _helper.page = page;
    if (_graphics == null) {
      PdfPageHelper.getHelper(page)
          .contents
          .add(PdfReferenceHolder(_helper.layer));
    }
    final PdfResources? resource = PdfPageHelper.getHelper(page).getResources();
    if (PdfLayerHelper.getHelper(_helper.layer!).layerId == null ||
        PdfLayerHelper.getHelper(_helper.layer!).layerId!.isEmpty) {
      PdfLayerHelper.getHelper(_helper.layer!).layerId =
          'OCG_${PdfResources.globallyUniqueIdentifier}';
    }
    if (resource != null &&
        resource.containsKey(PdfDictionaryProperties.properties)) {
      final PdfDictionary? propertie =
          resource[PdfDictionaryProperties.properties] as PdfDictionary?;
      if (propertie != null) {
        if (PdfLayerHelper.getHelper(_helper.layer!).layerId![0] == '/') {
          PdfLayerHelper.getHelper(_helper.layer!).layerId =
              PdfLayerHelper.getHelper(_helper.layer!).layerId!.substring(1);
        }
        propertie[PdfLayerHelper.getHelper(_helper.layer!).layerId] =
            PdfLayerHelper.getHelper(_helper.layer!).referenceHolder;
      } else {
        resource.properties[PdfLayerHelper.getHelper(_helper.layer!).layerId] =
            PdfLayerHelper.getHelper(_helper.layer!).referenceHolder;
        resource[PdfDictionaryProperties.properties] = resource.properties;
      }
    } else {
      resource!.properties[PdfLayerHelper.getHelper(_helper.layer!).layerId] =
          PdfLayerHelper.getHelper(_helper.layer!).referenceHolder;
      resource[PdfDictionaryProperties.properties] = resource.properties;
    }

    if (_graphics == null) {
      final Function resources = PdfPageHelper.getHelper(page).getResources;
      bool isPageHasMediaBox = false;
      if (PdfPageHelper.getHelper(page)
          .dictionary!
          .containsKey(PdfName(PdfDictionaryProperties.mediaBox))) {
        isPageHasMediaBox = true;
      }
      double llx = 0;
      double lly = 0;
      double urx = 0;
      double ury = 0;
      final PdfArray? mediaBox = PdfPageHelper.getHelper(page)
          .dictionary!
          .getValue(PdfDictionaryProperties.mediaBox,
              PdfDictionaryProperties.parent) as PdfArray?;
      if (mediaBox != null) {
        // Lower Left X co-ordinate Value.
        llx = (mediaBox[0]! as PdfNumber).value!.toDouble();
        // Lower Left Y co-ordinate value.
        lly = (mediaBox[1]! as PdfNumber).value!.toDouble();
        // Upper right X co-ordinate value.
        urx = (mediaBox[2]! as PdfNumber).value!.toDouble();
        // Upper right Y co-ordinate value.
        ury = (mediaBox[3]! as PdfNumber).value!.toDouble();
      }
      PdfArray? cropBox;
      if (PdfPageHelper.getHelper(page)
          .dictionary!
          .containsKey(PdfDictionaryProperties.cropBox)) {
        cropBox = PdfPageHelper.getHelper(page).dictionary!.getValue(
                PdfDictionaryProperties.cropBox, PdfDictionaryProperties.parent)
            as PdfArray?;
        final double cropX = (cropBox![0]! as PdfNumber).value!.toDouble();
        final double cropY = (cropBox[1]! as PdfNumber).value!.toDouble();
        final double cropRX = (cropBox[2]! as PdfNumber).value!.toDouble();
        final double cropRY = (cropBox[3]! as PdfNumber).value!.toDouble();
        if ((cropX < 0 || cropY < 0 || cropRX < 0 || cropRY < 0) &&
            (cropY.abs().floor() == page.size.height.abs().floor()) &&
            (cropX.abs().floor()) == page.size.width.abs().floor()) {
          final Size pageSize = Size(<double>[cropX, cropRX].reduce(max),
              <double>[cropY, cropRY].reduce(max));
          _graphics =
              PdfGraphicsHelper.load(pageSize, resources, _helper._content!);
        } else {
          _graphics =
              PdfGraphicsHelper.load(page.size, resources, _helper._content!);
          PdfGraphicsHelper.getHelper(_graphics!).cropBox = cropBox;
        }
      } else if ((llx < 0 || lly < 0 || urx < 0 || ury < 0) &&
          (lly.abs().floor() == page.size.height.abs().floor()) &&
          (urx.abs().floor() == page.size.width.abs().floor())) {
        final Size pageSize = Size(
            <double>[llx, urx].reduce(max), <double>[lly, ury].reduce(max));
        if (pageSize.width <= 0 || pageSize.height <= 0) {
          _graphics =
              PdfGraphicsHelper.load(pageSize, resources, _helper._content!);
        }
      } else {
        _graphics =
            PdfGraphicsHelper.load(page.size, resources, _helper._content!);
      }
      if (isPageHasMediaBox) {
        PdfGraphicsHelper.getHelper(_graphics!).mediaBoxUpperRightBound = ury;
      }
      if (!PdfPageHelper.getHelper(page).isLoadedPage) {
        final PdfSectionCollection? sectionCollection =
            PdfSectionHelper.getHelper(PdfPageHelper.getHelper(page).section!)
                .parent;
        if (sectionCollection != null) {
          _graphics!.colorSpace =
              PdfSectionCollectionHelper.getHelper(sectionCollection)
                  .document!
                  .colorSpace;
        }
      }
      if (!_graphicsMap.containsKey(_graphics)) {
        _graphicsMap[_graphics!] = _graphics!;
      }
      if (!_pageGraphics.containsKey(page)) {
        _pageGraphics[page] = _graphics!;
      }
      _helper._content!.beginSave = _beginSaveContent;
    } else {
      if (!_helper.pages.contains(page)) {
        _graphicsContent(page);
      } else if (_pageGraphics.containsKey(page)) {
        _graphics = _pageGraphics[page];
        return _graphics!;
      }
    }
    PdfGraphicsHelper.getHelper(_graphics!)
        .streamWriter!
        .write(PdfOperators.newLine);
    _graphics!.save();
    PdfGraphicsHelper.getHelper(_graphics!).initializeCoordinates();
    if (PdfGraphicsHelper.getHelper(_graphics!).hasTransparencyBrush) {
      PdfGraphicsHelper.getHelper(_graphics!).setTransparencyGroup(page);
    }
    if (PdfPageHelper.getHelper(page).isLoadedPage &&
        (page.rotation != PdfPageRotateAngle.rotateAngle0 ||
            PdfPageHelper.getHelper(page)
                .dictionary!
                .containsKey(PdfDictionaryProperties.rotate))) {
      PdfArray? cropBox;
      if (PdfPageHelper.getHelper(page)
          .dictionary!
          .containsKey(PdfDictionaryProperties.cropBox)) {
        cropBox = PdfPageHelper.getHelper(page).dictionary!.getValue(
                PdfDictionaryProperties.cropBox, PdfDictionaryProperties.parent)
            as PdfArray?;
      }
      _updatePageRotation(page, _graphics, cropBox);
    }
    if (!PdfPageHelper.getHelper(page).isLoadedPage) {
      final PdfRectangle clipRect =
          PdfSectionHelper.getHelper(PdfPageHelper.getHelper(page).section!)
              .getActualBounds(page, true);
      if (_clipPageTemplates) {
        if (PdfPageHelper.getHelper(page).origin.dx >= 0 &&
            PdfPageHelper.getHelper(page).origin.dy >= 0) {
          PdfGraphicsHelper.getHelper(_graphics!)
              .clipTranslateMarginsWithBounds(clipRect);
        }
      } else {
        final PdfMargins margins =
            PdfPageHelper.getHelper(page).section!.pageSettings.margins;
        PdfGraphicsHelper.getHelper(_graphics!).clipTranslateMargins(
            clipRect.x,
            clipRect.y,
            margins.left,
            margins.top,
            margins.right,
            margins.bottom);
      }
    }
    if (!_helper.pages.contains(page)) {
      _helper.pages.add(page);
    }
    PdfGraphicsHelper.getHelper(_graphics!).setLayer(null, this);
    return _graphics!;
  }

  void _updatePageRotation(
      PdfPage page, PdfGraphics? graphics, PdfArray? cropBox) {
    PdfNumber? rotation;
    if (PdfPageHelper.getHelper(page)
        .dictionary!
        .containsKey(PdfDictionaryProperties.rotate)) {
      rotation = PdfPageHelper.getHelper(page)
          .dictionary![PdfDictionaryProperties.rotate] as PdfNumber?;
      rotation ??= rotation = PdfCrossTable.dereference(
          PdfPageHelper.getHelper(page)
              .dictionary![PdfDictionaryProperties.rotate]) as PdfNumber?;
    } else if (page.rotation != PdfPageRotateAngle.rotateAngle0) {
      if (page.rotation == PdfPageRotateAngle.rotateAngle90) {
        rotation = PdfNumber(90);
      } else if (page.rotation == PdfPageRotateAngle.rotateAngle180) {
        rotation = PdfNumber(180);
      } else if (page.rotation == PdfPageRotateAngle.rotateAngle270) {
        rotation = PdfNumber(270);
      }
    }
    if (rotation!.value == 90) {
      graphics!.translateTransform(0, page.size.height);
      graphics.rotateTransform(-90);
      if (cropBox != null) {
        final double height = (cropBox[3]! as PdfNumber).value!.toDouble();
        final Size cropBoxSize = Size(
            (cropBox[2]! as PdfNumber).value!.toDouble(),
            height != 0
                ? height
                : (cropBox[1]! as PdfNumber).value!.toDouble());
        final Offset cropBoxOffset = Offset(
            (cropBox[0]! as PdfNumber).value!.toDouble(),
            (cropBox[1]! as PdfNumber).value!.toDouble());
        if (page.size.height < cropBoxSize.height) {
          PdfGraphicsHelper.getHelper(graphics).clipBounds.size = PdfSize(
              page.size.height - cropBoxOffset.dy,
              cropBoxSize.width - cropBoxOffset.dx);
        } else {
          PdfGraphicsHelper.getHelper(graphics).clipBounds.size = PdfSize(
              cropBoxSize.height - cropBoxOffset.dy,
              cropBoxSize.width - cropBoxOffset.dx);
        }
      } else {
        PdfGraphicsHelper.getHelper(graphics).clipBounds.size =
            PdfSize(page.size.height, page.size.width);
      }
    } else if (rotation.value == 180) {
      graphics!.translateTransform(page.size.width, page.size.height);
      graphics.rotateTransform(-180);
    } else if (rotation.value == 270) {
      graphics!.translateTransform(page.size.width, 0);
      graphics.rotateTransform(-270);
      PdfGraphicsHelper.getHelper(graphics).clipBounds.size =
          PdfSize(page.size.height, page.size.width);
    }
  }

  void _graphicsContent(PdfPage page) {
    final PdfStream stream = PdfStream();
    _graphics = PdfGraphicsHelper.load(
        page.size, PdfPageHelper.getHelper(page).getResources, stream);
    PdfPageHelper.getHelper(page).contents.add(PdfReferenceHolder(stream));
    stream.beginSave = _beginSaveContent;
    if (!_graphicsMap.containsKey(_graphics)) {
      _graphicsMap[_graphics!] = _graphics!;
    }
    if (!_pageGraphics.containsKey(page)) {
      _pageGraphics[page] = _graphics!;
    }
  }

  void _beginSaveContent(Object sender, SavePdfPrimitiveArgs? e) {
    bool flag = false;
    PdfGraphics? keyValue;
    _graphicsMap.forEach((PdfGraphics? key, PdfGraphics? values) {
      if (!flag) {
        _graphics = key;
        if (!_isEmptyLayer) {
          _helper.beginLayer(_graphics);
          PdfGraphicsHelper.getHelper(_graphics!).endMarkContent();
        }
        PdfGraphicsHelper.getHelper(_graphics!)
            .streamWriter!
            .write(PdfOperators.restoreState + PdfOperators.newLine);
        keyValue = key;
        flag = true;
      }
    });
    if (keyValue != null) {
      _graphicsMap.remove(keyValue);
    }
  }
}

/// [PdfLayer] helper
class PdfLayerHelper {
  /// internal constructor
  PdfLayerHelper(this.base);

  /// internal field
  late PdfLayer base;
  PdfStream? _content;

  /// internal method
  static PdfLayerHelper getHelper(PdfLayer base) {
    return base._helper;
  }

  /// internal method
  static PdfLayer internal() {
    return PdfLayer._();
  }

  /// internal field
  PdfLayer? layer;

  /// internal field
  String? layerId;

  /// internal field
  PdfReferenceHolder? referenceHolder;

  /// internal field
  final List<PdfLayer> parentLayer = <PdfLayer>[];

  /// internal field
  PdfDictionary? dictionary;

  /// internal field
  bool isEndState = false;

  /// internal method
  final List<PdfPage> pages = <PdfPage>[];

  /// internal method
  PdfPage? page;

  /// internal method
  PdfDocument? document;

  /// internal method
  PdfDictionary? printOption;

  /// internal method
  PdfDictionary? usage;

  /// internal method
  PdfLayer? parent;

  /// internal method
  final List<PdfLayer> child = <PdfLayer>[];

  /// internal method
  final PdfArray sublayer = PdfArray();

  /// internal method
  final List<String> xobject = <String>[];

  /// internal method
  bool pageParsed = false;

  /// internal method
  void beginLayer(PdfGraphics? currentGraphics) {
    if (base._graphicsMap.containsKey(currentGraphics)) {
      base._graphics = base._graphicsMap[currentGraphics];
    } else {
      base._graphics = currentGraphics;
    }
    if (base._graphics != null) {
      if (base._name != null && base._name != '') {
        base._isEmptyLayer = true;
        if (parentLayer.isNotEmpty) {
          for (int i = 0; i < parentLayer.length; i++) {
            PdfGraphicsHelper.getHelper(base._graphics!).streamWriter!.write(
                '/OC /${PdfLayerHelper.getHelper(parentLayer[i]).layerId!} BDC\n');
          }
        }
        if (base.name != null && base.name != '') {
          PdfGraphicsHelper.getHelper(base._graphics!)
              .streamWriter!
              .write('/OC /${layerId!} BDC\n');
          isEndState = true;
        } else {
          _content!.write('/OC /${layerId!} BDC\n');
        }
      }
    }
  }

  /// internal method
  void parsingLayerPage() {
    if (document != null &&
        PdfDocumentHelper.getHelper(document!).isLoadedDocument) {
      for (int i = 0; i < document!.pages.count; i++) {
        final PdfDictionary pageDictionary =
            PdfPageHelper.getHelper(document!.pages[i]).dictionary!;
        final PdfPage page = document!.pages[i];
        if (pageDictionary.containsKey(PdfDictionaryProperties.resources)) {
          final PdfDictionary? resources = PdfCrossTable.dereference(
                  pageDictionary[PdfDictionaryProperties.resources])
              as PdfDictionary?;
          if (resources != null &&
                  (resources.containsKey(PdfDictionaryProperties.properties)) ||
              (resources!.containsKey(PdfDictionaryProperties.xObject))) {
            final PdfDictionary? properties = PdfCrossTable.dereference(
                    resources[PdfDictionaryProperties.properties])
                as PdfDictionary?;
            final PdfDictionary? xObject = PdfCrossTable.dereference(
                resources[PdfDictionaryProperties.xObject]) as PdfDictionary?;
            if (properties != null) {
              properties.items!.forEach((PdfName? key, IPdfPrimitive? value) {
                if (value is PdfReferenceHolder) {
                  final PdfDictionary? dictionary =
                      value.object as PdfDictionary?;
                  _parsingDictionary(dictionary, value, page, key);
                }
              });
              if (properties.items!.isEmpty) {
                pageParsed = true;
              }
            }
            if (xObject != null) {
              xObject.items!.forEach((PdfName? key, IPdfPrimitive? value) {
                PdfReferenceHolder reference = value! as PdfReferenceHolder;
                PdfDictionary dictionary = reference.object! as PdfDictionary;
                if (dictionary.containsKey('OC')) {
                  final PdfName? layerID = key;
                  reference = dictionary['OC']! as PdfReferenceHolder;
                  dictionary = PdfCrossTable.dereference(dictionary['OC'])!
                      as PdfDictionary;
                  final bool isPresent =
                      _parsingDictionary(dictionary, reference, page, layerID)!;
                  if (isPresent) {
                    PdfLayerHelper.getHelper(layer!)
                        .xobject
                        .add(layerID!.name!);
                  }
                }
              });
              if (xObject.items!.isEmpty) {
                pageParsed = true;
              }
            }
          }
        }
      }
    }
  }

  bool? _parsingDictionary(PdfDictionary? dictionary,
      PdfReferenceHolder? reference, PdfPage? page, PdfName? layerID) {
    if (base._isPresent == null || !base._isPresent!) {
      base._isPresent = false;
      if (!dictionary!.containsKey(PdfDictionaryProperties.name) &&
          dictionary.containsKey(PdfDictionaryProperties.ocg)) {
        if (dictionary.containsKey(PdfDictionaryProperties.ocg)) {
          final PdfArray? pdfArray =
              PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.ocg])
                  as PdfArray?;
          if (pdfArray == null) {
            reference =
                dictionary[PdfDictionaryProperties.ocg] as PdfReferenceHolder?;
            dictionary = PdfCrossTable.dereference(
                dictionary[PdfDictionaryProperties.ocg]) as PdfDictionary?;
            if (dictionary != null &&
                dictionary.containsKey(PdfDictionaryProperties.name)) {
              base._isPresent = _setLayerPage(reference, page, layerID);
            }
          } else {
            for (int a = 0; a < pdfArray.count; a++) {
              if (pdfArray[a] is PdfReferenceHolder) {
                reference = pdfArray[a]! as PdfReferenceHolder;
                dictionary = reference.object as PdfDictionary?;
                base._isPresent = _setLayerPage(reference, page, layerID);
              }
            }
          }
        }
      } else if (dictionary.containsKey(PdfDictionaryProperties.name)) {
        base._isPresent = _setLayerPage(reference, page, layerID);
      }
      return base._isPresent;
    } else {
      return false;
    }
  }

  bool _setLayerPage(
      PdfReferenceHolder? reference, PdfPage? page, PdfName? layerID) {
    bool isPresent = false;
    if (PdfLayerHelper.getHelper(layer!).referenceHolder != null) {
      if (identical(
              PdfLayerHelper.getHelper(layer!).referenceHolder, reference) ||
          identical(PdfLayerHelper.getHelper(layer!).referenceHolder!.object,
              reference!.object) ||
          PdfLayerHelper.getHelper(layer!).referenceHolder?.reference?.objNum ==
              reference.reference?.objNum) {
        PdfLayerHelper.getHelper(layer!).pageParsed = true;
        isPresent = true;
        PdfLayerHelper.getHelper(layer!).layerId = layerID!.name;
        PdfLayerHelper.getHelper(layer!).page = page;
        if (!PdfLayerHelper.getHelper(layer!).pages.contains(page)) {
          PdfLayerHelper.getHelper(layer!).pages.add(page!);
        }
      }
    }
    return isPresent;
  }

  /// internal property
  IPdfPrimitive? get element => _content;
  //ignore: unused_element
  set element(IPdfPrimitive? value) {
    _content = value as PdfStream?;
  }
}
