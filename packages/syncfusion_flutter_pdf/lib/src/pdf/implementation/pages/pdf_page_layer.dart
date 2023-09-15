import 'dart:math';
import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../drawing/drawing.dart';
import '../graphics/enums.dart';
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
import 'enum.dart';
import 'pdf_section.dart';
import 'pdf_section_collection.dart';

/// The [PdfPageLayer] used to create layers in PDF document.
/// Layers refers to sections of content in a PDF document that can be
/// selectively viewed or hidden by document authors or consumers.
class PdfPageLayer implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfPageLayer] class
  /// with specified PDF page.
  PdfPageLayer(PdfPage pdfPage) {
    _helper = PdfPageLayerHelper(this);
    _initialize(pdfPage, true);
  }

  PdfPageLayer._fromClipPageTemplate(PdfPage pdfPage,
      [bool? clipPageTemplates]) {
    _helper = PdfPageLayerHelper(this);
    _initialize(pdfPage, clipPageTemplates);
  }

  //Fields
  late PdfPageLayerHelper _helper;
  late PdfPage _page;
  bool? _clipPageTemplates;
  String? _name;
  PdfGraphicsState? _graphicsState;
  bool _isEndState = false;
  bool _isSaved = false;
  bool _visible = true;

  //Properties
  /// Gets parent page of the layer.
  PdfPage get page => _page;

  /// Gets Graphics context of the layer, used to draw various graphical
  /// content on layer.
  PdfGraphics get graphics {
    if (_helper.graphics == null || _isSaved) {
      _initializeGraphics(page);
    }
    return _helper.graphics!;
  }

  /// Gets the name of the layer
  String? get name {
    return _name;
  }

  /// Sets the name of the layer
  set name(String? value) {
    if (value != null) {
      _name = value;
      _helper.layerID ??= 'OCG_${PdfResources.globallyUniqueIdentifier}';
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
    _helper._content = PdfStream();
    _helper.dictionary = PdfDictionary();
  }

  void _initializeGraphics(PdfPage? page) {
    if (_helper.graphics == null) {
      final Function resources = PdfPageHelper.getHelper(page!).getResources;
      bool isPageHasMediaBox = false;
      bool isInvalidSize = false;
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
      final PdfReferenceHolder referenceHolder = PdfReferenceHolder(this);
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
          _helper.graphics =
              PdfGraphicsHelper.load(pageSize, resources, _helper._content!);
          if (!PdfPageHelper.getHelper(page)
                  .contents
                  .contains(referenceHolder) &&
              !PdfPageHelper.getHelper(page).isDefaultGraphics &&
              !_isContainsPageContent(
                  PdfPageHelper.getHelper(page).contents, referenceHolder)) {
            PdfPageHelper.getHelper(page).contents.add(referenceHolder);
          }
        } else {
          _helper.graphics =
              PdfGraphicsHelper.load(page.size, resources, _helper._content!);
          PdfGraphicsHelper.getHelper(_helper.graphics!).cropBox = cropBox;
          if (!PdfPageHelper.getHelper(page)
                  .contents
                  .contains(referenceHolder) &&
              !PdfPageHelper.getHelper(page).isDefaultGraphics &&
              !_isContainsPageContent(
                  PdfPageHelper.getHelper(page).contents, referenceHolder)) {
            PdfPageHelper.getHelper(page).contents.add(referenceHolder);
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
          _helper.graphics =
              PdfGraphicsHelper.load(pageSize, resources, _helper._content!);
          if (!PdfPageHelper.getHelper(page)
                  .contents
                  .contains(referenceHolder) &&
              !PdfPageHelper.getHelper(page).isDefaultGraphics &&
              !_isContainsPageContent(
                  PdfPageHelper.getHelper(page).contents, referenceHolder)) {
            PdfPageHelper.getHelper(page).contents.add(referenceHolder);
          }
        }
      } else {
        _helper.graphics =
            PdfGraphicsHelper.load(page.size, resources, _helper._content!);
        if (!PdfPageHelper.getHelper(page).contents.contains(referenceHolder) &&
            !PdfPageHelper.getHelper(page).isDefaultGraphics &&
            !_isContainsPageContent(
                PdfPageHelper.getHelper(page).contents, referenceHolder)) {
          PdfPageHelper.getHelper(page).contents.add(referenceHolder);
        }
      }

      if (isPageHasMediaBox) {
        PdfGraphicsHelper.getHelper(_helper.graphics!).mediaBoxUpperRightBound =
            isInvalidSize ? -lly : ury;
      }
      if (!PdfPageHelper.getHelper(page).isLoadedPage) {
        final PdfSectionCollection? sectionCollection =
            PdfSectionHelper.getHelper(PdfPageHelper.getHelper(page).section!)
                .parent;
        if (sectionCollection != null) {
          _helper.graphics!.colorSpace =
              PdfSectionCollectionHelper.getHelper(sectionCollection)
                  .document!
                  .colorSpace;
          _helper.colorSpace =
              PdfSectionCollectionHelper.getHelper(sectionCollection)
                  .document!
                  .colorSpace;
        }
      }
      _helper._content!.beginSave = _beginSaveContent;
    }
    _graphicsState = _helper.graphics!.save();
    if (name != null && name!.isNotEmpty) {
      PdfGraphicsHelper.getHelper(_helper.graphics!)
          .streamWriter!
          .write('/OC /${_helper.layerID!} BDC\n');
      _isEndState = true;
    }
    PdfGraphicsHelper.getHelper(_helper.graphics!).initializeCoordinates();
    if (PdfGraphicsHelper.getHelper(_helper.graphics!).hasTransparencyBrush) {
      PdfGraphicsHelper.getHelper(_helper.graphics!)
          .setTransparencyGroup(page!);
    }
    if (page != null &&
        (!PdfPageHelper.getHelper(page).isLoadedPage) &&
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
      _updatePageRotation(page, _helper.graphics, cropBox);
    }
    if (page != null && !PdfPageHelper.getHelper(page).isLoadedPage) {
      final PdfRectangle clipRect =
          PdfSectionHelper.getHelper(PdfPageHelper.getHelper(page).section!)
              .getActualBounds(page, true);
      if (_clipPageTemplates!) {
        if (PdfPageHelper.getHelper(page).origin.dx >= 0 &&
            PdfPageHelper.getHelper(page).origin.dy >= 0) {
          PdfGraphicsHelper.getHelper(_helper.graphics!)
              .clipTranslateMarginsWithBounds(clipRect);
        }
      } else {
        final PdfMargins margins =
            PdfPageHelper.getHelper(page).section!.pageSettings.margins;
        PdfGraphicsHelper.getHelper(_helper.graphics!).clipTranslateMargins(
            clipRect.x,
            clipRect.y,
            margins.left,
            margins.top,
            margins.right,
            margins.bottom);
      }
    }
    PdfGraphicsHelper.getHelper(_helper.graphics!).setLayer(this);
    _isSaved = false;
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

  void _beginSaveContent(Object sender, SavePdfPrimitiveArgs? args) {
    if (_graphicsState != null) {
      if (_isEndState) {
        PdfGraphicsHelper.getHelper(_helper.graphics!)
            .streamWriter!
            .write('EMC\n');
        _isEndState = false;
      }
      graphics.restore(_graphicsState);
      _graphicsState = null;
    }
    _isSaved = true;
  }

  void _setVisibility(bool? value) {
    PdfDictionary? oCProperties;
    if (PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(_page).document!)
        .catalog
        .containsKey(PdfDictionaryProperties.ocProperties)) {
      oCProperties = PdfCrossTable.dereference(
          PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(_page).document!)
              .catalog[PdfDictionaryProperties.ocProperties]) as PdfDictionary?;
    }
    if (oCProperties != null) {
      final PdfDictionary? defaultView =
          oCProperties[PdfDictionaryProperties.defaultView] as PdfDictionary?;
      if (defaultView != null) {
        PdfArray? ocgON =
            defaultView[PdfDictionaryProperties.ocgOn] as PdfArray?;
        PdfArray? ocgOFF =
            defaultView[PdfDictionaryProperties.ocgOff] as PdfArray?;
        if (_helper.referenceHolder != null) {
          if (value == false) {
            if (ocgON != null) {
              _removeContent(ocgON, _helper.referenceHolder);
            }
            if (ocgOFF == null) {
              ocgOFF = PdfArray();
              defaultView.items![PdfName(PdfDictionaryProperties.ocgOff)] =
                  ocgOFF;
            }
            ocgOFF.insert(ocgOFF.count, _helper.referenceHolder!);
          } else if (value ?? true) {
            if (ocgOFF != null) {
              _removeContent(ocgOFF, _helper.referenceHolder);
            }
            if (ocgON == null) {
              ocgON = PdfArray();
              defaultView.items![PdfName(PdfDictionaryProperties.ocgOn)] =
                  ocgON;
            }
            ocgON.insert(ocgON.count, _helper.referenceHolder!);
          }
        }
      }
    }
  }

  bool _isContainsPageContent(
      PdfArray content, PdfReferenceHolder referenceHolder) {
    for (int i = 0; i < content.count; i++) {
      final IPdfPrimitive? primitive = content.elements[i];
      if (primitive != null && primitive is PdfReferenceHolder) {
        final PdfReferenceHolder holder = primitive;
        if (holder.reference != null && referenceHolder.reference != null) {
          if (holder.reference!.objNum == referenceHolder.reference!.objNum) {
            return true;
          }
        } else {
          if (identical(holder, referenceHolder)) {
            return true;
          } else if (identical(holder.object, referenceHolder.object)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _removeContent(PdfArray content, PdfReferenceHolder? referenceHolder) {
    bool flag = false;
    for (int i = 0; i < content.count; i++) {
      final IPdfPrimitive? primitive = content.elements[i];
      if (primitive != null && primitive is PdfReferenceHolder) {
        final PdfReferenceHolder holder = primitive;
        if (holder.reference != null && referenceHolder!.reference != null) {
          if (holder.reference!.objNum == referenceHolder.reference!.objNum) {
            content.elements.removeAt(i);
            flag = true;
            i--;
          }
        }
      }
    }
    if (flag) {
      content.changed = true;
    }
  }
}

/// [PdfPageLayer] helper
class PdfPageLayerHelper {
  /// internal constructor
  PdfPageLayerHelper(this.base);

  /// internal field
  late PdfPageLayer base;
  PdfStream? _content;

  /// internal method
  static PdfPageLayerHelper getHelper(PdfPageLayer base) {
    return base._helper;
  }

  /// internal method
  static PdfPageLayer fromClipPageTemplate(PdfPage pdfPage,
      [bool? clipPageTemplates]) {
    return PdfPageLayer._fromClipPageTemplate(pdfPage, clipPageTemplates);
  }

  /// internal property
  IPdfPrimitive? get element => _content;
  //ignore: unused_element
  set element(IPdfPrimitive? value) {
    _content = value as PdfStream?;
  }

  /// internal field
  //ignore:unused_field
  PdfColorSpace? colorSpace;

  /// internal field
  PdfDictionary? dictionary;

  /// internal field
  String? layerID;

  /// internal field
  PdfDictionary? printOption;

  /// internal field
  PdfDictionary? usage;

  /// internal field
  PdfReferenceHolder? referenceHolder;

  /// internal field
  PdfGraphics? graphics;
}
