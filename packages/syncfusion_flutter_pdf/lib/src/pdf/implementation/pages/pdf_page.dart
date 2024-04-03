import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../annotations/pdf_annotation_collection.dart';
import '../forms/pdf_field.dart';
import '../forms/pdf_form.dart';
import '../forms/pdf_form_field_collection.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_resources.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_page_layer.dart';
import 'pdf_page_layer_collection.dart';
import 'pdf_page_settings.dart';
import 'pdf_section.dart';
import 'pdf_section_collection.dart';

/// Provides methods and properties to create PDF pages
/// and its elements, [PdfPage].
/// ```dart
/// //Create a new PDF documentation
/// PdfDocument document = PdfDocument();
/// //Create a new PDF page and draw the text
/// document.pages.add().graphics.drawString(
///     'Hello World!!!',
///     PdfStandardFont(PdfFontFamily.helvetica, 27),
///     brush: PdfBrushes.darkBlue,
///     bounds: const Rect.fromLTWH(170, 100, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfPage implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfPage] class.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF page
  /// PdfPage page = document.pages.add();
  /// //Draw the text to the page
  /// page.graphics.drawString(
  ///     'Hello World!!!',
  ///     PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue,
  ///     bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPage() {
    _helper = PdfPageHelper(this);
    _initialize();
  }

  PdfPage._fromDictionary(PdfDocument document, PdfCrossTable crossTable,
      PdfDictionary dictionary) {
    _helper = PdfPageHelper(this);
    _helper._pdfDocument = document;
    _helper.dictionary = dictionary;
    _helper.crossTable = crossTable;
    _helper.isLoadedPage = true;
    _size = Size.zero;
    _helper.isTextExtraction = false;
    _graphicStateUpdated = false;
  }

  //Fields
  late PdfPageHelper _helper;
  PdfPageLayerCollection? _layers;
  int _defaultLayerIndex = -1;
  Size? _size;
  late bool _graphicStateUpdated;
  PdfFormFieldsTabOrder _formFieldsTabOrder = PdfFormFieldsTabOrder.none;
  PdfPageRotateAngle? _rotation;

  //Properties
  /// Gets size of the PDF page- Read only
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF page and Gets the size of its page
  /// Size size = document.pages.add().size;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Size get size {
    if (_helper.isLoadedPage) {
      if (_size == null || (_size!.width == 0 && _size!.height == 0)) {
        double width = 0;
        double height = 0;
        final IPdfPrimitive? mBox = _helper.dictionary!.getValue(
            PdfDictionaryProperties.mediaBox, PdfDictionaryProperties.parent);
        final IPdfPrimitive? cBox = _helper.dictionary!.getValue(
            PdfDictionaryProperties.cropBox, PdfDictionaryProperties.parent);
        if (cBox != null && cBox is PdfArray) {
          final num c0 = (cBox[0]! as PdfNumber).value!;
          final num? c1 = (cBox[1]! as PdfNumber).value;
          final num c2 = (cBox[2]! as PdfNumber).value!;
          final num? c3 = (cBox[3]! as PdfNumber).value;
          width = (c2 - c0).toDouble();
          height = c3 != 0 ? (c3! - c1!).toDouble() : c1!.toDouble();
        } else if (mBox != null && mBox is PdfArray) {
          final num m0 = (mBox[0]! as PdfNumber).value!;
          final num? m1 = (mBox[1]! as PdfNumber).value;
          final num m2 = (mBox[2]! as PdfNumber).value!;
          final num? m3 = (mBox[3]! as PdfNumber).value;
          width = (m2 - m0).toDouble();
          height = m3 != 0 ? (m3! - m1!).toDouble() : m1!.toDouble();
        }
        _size = Size(width, height);
      }
      return _size!;
    } else {
      return _helper.section!.pageSettings.size;
    }
  }

  /// Gets a collection of the annotations of the page- Read only.
  /// ```dart
  /// //Creates a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Creates a rectangle annotation
  /// PdfRectangleAnnotation rectangleAnnotation = PdfRectangleAnnotation(
  ///     Rect.fromLTWH(0, 30, 80, 80), 'Rectangle Annotation',
  ///     author: 'Syncfusion',
  ///     color: PdfColor(255, 0, 0),
  ///     modifiedDate: DateTime.now());
  /// //Create a new PDF page and Adds the annotation to the PDF page
  /// document.pages.add().annotations.add(rectangleAnnotation);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfAnnotationCollection get annotations {
    if (!_helper.isLoadedPage) {
      if (_helper._annotations == null) {
        _helper._annotations = PdfAnnotationCollection(this);
        if (!_helper.dictionary!.containsKey(PdfDictionaryProperties.annots)) {
          _helper.dictionary![PdfDictionaryProperties.annots] =
              PdfAnnotationCollectionHelper.getHelper(_helper._annotations!)
                  .internalAnnotations;
        }
        PdfAnnotationCollectionHelper.getHelper(_helper._annotations!)
                .internalAnnotations =
            _helper.dictionary![PdfDictionaryProperties.annots] as PdfArray?;
      }
    } else {
      if (_helper._annotations == null || _helper.importAnnotation) {
        // Create the annotations.
        _helper.createAnnotations(_helper.getWidgetReferences());
      }
      if (_helper._annotations == null ||
          (PdfAnnotationCollectionHelper.getHelper(_helper._annotations!)
                      .internalAnnotations
                      .count ==
                  0 &&
              _helper._annotations!.count != 0)) {
        _helper._annotations = PdfAnnotationCollectionHelper.load(this);
      }
    }
    return _helper._annotations!;
  }

  /// Gets the graphics of the `defaultLayer`.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF page and draw the text
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!!!',
  ///     PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue,
  ///     bounds: const Rect.fromLTWH(170, 100, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGraphics get graphics {
    _helper.isDefaultGraphics = true;
    return defaultLayer.graphics;
  }

  /// Gets the collection of the page's layers (Read only).
  /// ```dart
  /// //Creates a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Creates a new page
  /// PdfPage page = document.pages.add();
  /// //Gets the layers from the page and Add the new layer.
  /// PdfPageLayer layer = page.layers.add(name: 'Layer1');
  /// //Get the layer graphics.
  /// PdfGraphics graphics = layer.graphics;
  /// graphics.translateTransform(100, 60);
  /// //Draw an Arc.
  /// graphics.drawArc(Rect.fromLTWH(0, 0, 50, 50), 360, 360,
  ///     pen: PdfPen(PdfColor(250, 0, 0), width: 50));
  /// graphics.drawArc(Rect.fromLTWH(0, 0, 50, 50), 360, 360,
  ///     pen: PdfPen(PdfColor(0, 0, 250), width: 30));
  /// graphics.drawArc(Rect.fromLTWH(0, 0, 50, 50), 360, 360,
  ///     pen: PdfPen(PdfColor(250, 250, 0), width: 20));
  /// graphics.drawArc(Rect.fromLTWH(0, 0, 50, 50), 360, 360,
  ///     pen: PdfPen(PdfColor(0, 250, 0), width: 10));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageLayerCollection get layers {
    if (!_helper.isTextExtraction && !_graphicStateUpdated) {
      _layers = PdfPageLayerCollection(this);
      _graphicStateUpdated = true;
    } else {
      _layers ??= PdfPageLayerCollection(this);
    }
    return _layers!;
  }

  /// Gets the default layer of the page (Read only).
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF page and gets the default layer
  /// PdfPageLayer defaultLayer = document.pages.add().defaultLayer;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageLayer get defaultLayer => layers[defaultLayerIndex];

  /// Gets or sets index of the default layer (Read only).
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF page and gets the default layer index
  /// int layerIndex = document.pages.add().defaultLayerIndex;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get defaultLayerIndex {
    if (layers.count == 0 || _defaultLayerIndex == -1) {
      final PdfPageLayer layer = layers.add();
      _defaultLayerIndex = layers.indexOf(layer);
    }
    return _defaultLayerIndex;
  }

  /// Gets or sets the tab order type for form fields
  PdfFormFieldsTabOrder get formFieldsTabOrder => _formFieldsTabOrder;
  set formFieldsTabOrder(PdfFormFieldsTabOrder value) {
    _formFieldsTabOrder = value;
    if (_formFieldsTabOrder != PdfFormFieldsTabOrder.none) {
      String tabs = ' ';
      if (_formFieldsTabOrder == PdfFormFieldsTabOrder.row) {
        tabs = PdfDictionaryProperties.r;
      }
      if (_formFieldsTabOrder == PdfFormFieldsTabOrder.column) {
        tabs = PdfDictionaryProperties.c;
      }
      if (_formFieldsTabOrder == PdfFormFieldsTabOrder.structure) {
        tabs = PdfDictionaryProperties.s;
      }
      _helper.dictionary![PdfDictionaryProperties.tabs] = PdfName(tabs);
    }
  }

  /// Gets or sets the rotation of PDF page
  ///
  /// This property only works on existing PDF document pages
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: data);
  /// //Rotation of the PDF page
  /// PdfPageRotateAngle rotation = document.pages[0].rotation;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageRotateAngle get rotation {
    _rotation ??= _obtainRotation();
    return _rotation!;
  }

  set rotation(PdfPageRotateAngle angle) {
    if (_helper.isLoadedPage && rotation != angle) {
      _rotation = angle;
      _helper.dictionary![PdfDictionaryProperties.rotate] =
          PdfNumber(PdfSectionCollectionHelper.rotateFactor * angle.index);
    }
  }

  //Public methods
  /// Get the PDF page size reduced by page margins and
  /// page template dimensions.
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF page
  /// PdfPage page = document.pages.add();
  /// //Gets the page client size
  /// Size clientSize = page.getClientSize();
  /// //Draw the text to the page
  /// page.graphics.drawString(
  ///     'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 27),
  ///     brush: PdfBrushes.darkBlue,
  ///     bounds: Rect.fromLTWH(400, 600, clientSize.width, clientSize.height));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Size getClientSize() {
    return _helper.isLoadedPage
        ? size
        : PdfSectionHelper.getHelper(_helper.section!)
            .getActualBounds(this, true)
            .size
            .size;
  }

  /// Creates a template from the page content.
  /// ```dart
  /// //Loads an existing PDF document and create the template
  /// PdfTemplate template =
  ///     PdfDocument(inputBytes: File('input.pdf').readAsBytesSync())
  ///         .pages[0]
  ///         .createTemplate();
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Sets the page settings margin
  /// document.pageSettings.setMargins(2);
  /// //Create a new PDF page
  /// PdfPage page = document.pages.add();
  /// //Draw the Pdf template by using created template
  /// page.graphics.drawPdfTemplate(
  ///     template, Offset(20, 0), Size(page.size.width / 2, page.size.height));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfTemplate createTemplate() {
    return _helper._getContent();
  }

  //Implementation

  void _initialize() {
    _helper.dictionary = PdfDictionary();
    _helper.dictionary![PdfDictionaryProperties.type] = PdfName('Page');
    _helper.dictionary!.beginSave = _pageBeginSave;
    _size = Size.zero;
    _helper.isTextExtraction = false;
    _graphicStateUpdated = false;
  }

  void _drawPageTemplates(PdfDocument doc) {
    // Draw Background templates.
    final bool hasBackTemplates = PdfSectionHelper.getHelper(_helper.section!)
        .containsTemplates(doc, this, false);
    if (hasBackTemplates) {
      final PdfPageLayer backLayer =
          PdfPageLayerHelper.fromClipPageTemplate(this, false);
      final PdfPageLayerCollection layer = PdfPageLayerCollection(this);
      _layers = layer;
      _layers!.addLayer(backLayer);
      PdfSectionHelper.getHelper(_helper.section!)
          .drawTemplates(this, backLayer, doc, false);
    }

    // Draw Foreground templates.
    final bool hasFrontTemplates = PdfSectionHelper.getHelper(_helper.section!)
        .containsTemplates(doc, this, true);

    if (hasFrontTemplates) {
      final PdfPageLayer frontLayer =
          PdfPageLayerHelper.fromClipPageTemplate(this, false);
      final PdfPageLayerCollection layer = PdfPageLayerCollection(this);
      _layers = layer;
      _layers!.addLayer(frontLayer);
      PdfSectionHelper.getHelper(_helper.section!)
          .drawTemplates(this, frontLayer, doc, true);
    }
  }

  PdfPageRotateAngle _obtainRotation() {
    PdfDictionary? parent = _helper.dictionary;
    PdfNumber? angle;
    while (parent != null && angle == null) {
      if (parent.containsKey(PdfDictionaryProperties.rotate)) {
        if (parent[PdfDictionaryProperties.rotate] is PdfReferenceHolder) {
          angle =
              (parent[PdfDictionaryProperties.rotate]! as PdfReferenceHolder)
                  .object as PdfNumber?;
        } else {
          angle = parent[PdfDictionaryProperties.rotate] as PdfNumber?;
        }
      }
      if (parent.containsKey(PdfDictionaryProperties.parent)) {
        IPdfPrimitive? parentPrimitive = parent[PdfDictionaryProperties.parent];
        if (parentPrimitive != null) {
          parentPrimitive = PdfCrossTable.dereference(parentPrimitive);
          parent = parentPrimitive != null && parentPrimitive is PdfDictionary
              ? parentPrimitive
              : null;
        } else {
          parent = null;
        }
      } else {
        parent = null;
      }
    }
    angle ??= PdfNumber(0);
    if (angle.value!.toInt() < 0) {
      angle.value = 360 + angle.value!.toInt();
    }
    final PdfPageRotateAngle rotateAngle =
        _getRotationFromAngle(angle.value! ~/ 90);
    return rotateAngle;
  }

  PdfPageRotateAngle _getRotationFromAngle(int angle) {
    if (angle == 1) {
      return PdfPageRotateAngle.rotateAngle90;
    } else if (angle == 2) {
      return PdfPageRotateAngle.rotateAngle180;
    } else if (angle == 3) {
      return PdfPageRotateAngle.rotateAngle270;
    } else {
      return PdfPageRotateAngle.rotateAngle0;
    }
  }

  void _pageBeginSave(Object sender, SavePdfPrimitiveArgs? args) {
    final PdfDocument? doc = args!.writer!.document;
    if (doc != null && _helper.document != null) {
      _drawPageTemplates(doc);
    }
    if (_helper.beginSave != null) {
      _helper.beginSave!();
    }
  }
}

/// [PdfPage] helper
class PdfPageHelper {
  /// internal constructor
  PdfPageHelper(this.base);

  /// internal field
  late PdfPage base;

  /// internal field
  bool importAnnotation = false;

  /// internal method
  static PdfPageHelper getHelper(PdfPage base) {
    return base._helper;
  }

  /// internal method
  static PdfPage fromDictionary(PdfDocument document, PdfCrossTable crossTable,
      PdfDictionary dictionary) {
    return PdfPage._fromDictionary(document, crossTable, dictionary);
  }

  /// internal method
  IPdfPrimitive? get element => dictionary;

  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfDictionary) {
      dictionary = value;
    }
  }

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  /// internal field
  bool? isNewPage;

  /// internal method
  PdfSection? section;

  /// internal method
  bool isLoadedPage = false;

  /// internal method
  PdfCrossTable? crossTable;

  /// internal method
  final List<PdfDictionary> terminalAnnotation = <PdfDictionary>[];

  /// internal method
  final PdfArray annotsReference = PdfArray();

  /// internal method
  late bool isTextExtraction;

  /// internal method
  bool isDefaultGraphics = false;

  /// Raises before the page saves.
  Function? beginSave;
  PdfDocument? _pdfDocument;
  PdfResources? _resources;
  Rect _cBox = Rect.zero;
  Rect _mBox = Rect.zero;
  bool _checkResources = false;
  PdfAnnotationCollection? _annotations;

  /// internal method
  Offset get origin {
    if (section != null) {
      return PdfPageSettingsHelper.getHelper(section!.pageSettings)
          .origin
          .offset;
    } else {
      return Offset.zero;
    }
  }

  /// internal property
  PdfDocument? get document {
    if (isLoadedPage || _pdfDocument != null) {
      return _pdfDocument;
    } else {
      if (section != null) {
        if (PdfSectionHelper.getHelper(section!).parent != null) {
          return PdfSectionCollectionHelper.getHelper(
                  PdfSectionHelper.getHelper(section!).parent!)
              .document;
        } else if (PdfSectionHelper.getHelper(section!).document != null) {
          return PdfSectionHelper.getHelper(section!).document;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  set document(PdfDocument? value) {
    _pdfDocument = value;
  }

  /// Gets the crop box.
  Rect get cropBox {
    if (_cBox.isEmpty) {
      final IPdfPrimitive? cBox = dictionary!.getValue(
          PdfDictionaryProperties.cropBox, PdfDictionaryProperties.parent);
      if (cBox != null && cBox is PdfArray) {
        final double width = (cBox[2]! as PdfNumber).value!.toDouble();
        final double height = (cBox[3]! as PdfNumber).value != 0
            ? (cBox[3]! as PdfNumber).value!.toDouble()
            : (cBox[1]! as PdfNumber).value!.toDouble();
        final double x = (cBox[0]! as PdfNumber).value!.toDouble();
        final double y = (cBox[1]! as PdfNumber).value!.toDouble();
        _cBox = _calculateBounds(x, y, width, height);
      }
    }
    return _cBox;
  }

  /// Gets the media box.
  Rect get mediaBox {
    if (_mBox.isEmpty) {
      final IPdfPrimitive? mBox = dictionary!.getValue(
          PdfDictionaryProperties.mediaBox, PdfDictionaryProperties.parent);
      if (mBox != null && mBox is PdfArray) {
        final double width = (mBox[2]! as PdfNumber).value!.toDouble();
        final double height = (mBox[3]! as PdfNumber).value != 0
            ? (mBox[3]! as PdfNumber).value!.toDouble()
            : (mBox[1]! as PdfNumber).value!.toDouble();
        final double x = (mBox[0]! as PdfNumber).value!.toDouble();
        final double y = (mBox[1]! as PdfNumber).value!.toDouble();
        _mBox = _calculateBounds(x, y, width, height);
      }
    }
    return _mBox;
  }

  /// Gets array of page's content.
  PdfArray get contents {
    final IPdfPrimitive? contentArray =
        dictionary![PdfDictionaryProperties.contents];
    PdfArray? elements;
    if (contentArray is PdfReferenceHolder) {
      final PdfReferenceHolder holder = contentArray;
      final IPdfPrimitive? primitive = holder.object;
      if (primitive is PdfArray) {
        elements = primitive;
      } else if (primitive is PdfStream) {
        elements = PdfArray();
        elements.add(PdfReferenceHolder(primitive));
        if (!isTextExtraction) {
          dictionary![PdfDictionaryProperties.contents] = elements;
        }
      }
    } else if (contentArray is PdfArray) {
      elements = contentArray;
    }
    if (elements == null) {
      elements = PdfArray();
      if (!isTextExtraction) {
        dictionary![PdfDictionaryProperties.contents] = elements;
      }
    }
    return elements;
  }

  /// internal property
  PdfPageOrientation get orientation => _obtainOrientation();

  PdfPageOrientation _obtainOrientation() {
    return (base.size.width > base.size.height)
        ? PdfPageOrientation.landscape
        : PdfPageOrientation.portrait;
  }

  Rect _calculateBounds(double x, double y, double width, double height) {
    width = width - x;
    if (height != y) {
      height = height - y;
    }
    return Rect.fromLTWH(x, y, width, height);
  }

  /// internal method
  void assignSection(PdfSection section) {
    this.section = section;
    dictionary![PdfDictionaryProperties.parent] = PdfReferenceHolder(section);
  }

  /// internal method
  PdfResources? getResources() {
    if (_resources == null) {
      if (!isLoadedPage) {
        _resources = PdfResources();
        dictionary![PdfDictionaryProperties.resources] = _resources;
      } else {
        if (!dictionary!.containsKey(PdfDictionaryProperties.resources) ||
            _checkResources) {
          _resources = PdfResources();
          dictionary![PdfDictionaryProperties.resources] = _resources;
          // Check for the resources in the corresponding page section.
          if (_resources!.getNames()!.isEmpty || _resources!.items!.isEmpty) {
            if (dictionary!.containsKey(PdfDictionaryProperties.parent)) {
              IPdfPrimitive? obj = dictionary![PdfDictionaryProperties.parent];
              PdfDictionary? parentDic;
              if (obj is PdfReferenceHolder) {
                parentDic = obj.object as PdfDictionary?;
              } else {
                parentDic = obj as PdfDictionary?;
              }
              if (parentDic!.containsKey(PdfDictionaryProperties.resources)) {
                obj = parentDic[PdfDictionaryProperties.resources];
                if (obj is PdfDictionary && obj.items!.isNotEmpty) {
                  dictionary![PdfDictionaryProperties.resources] = obj;
                  _resources = PdfResources(obj);
                  final PdfDictionary xobjects = PdfDictionary();
                  if (_resources!
                      .containsKey(PdfDictionaryProperties.xObject)) {
                    final PdfDictionary? xObject =
                        _resources![PdfDictionaryProperties.xObject]
                            as PdfDictionary?;

                    if (xObject != null) {
                      final IPdfPrimitive? content = PdfCrossTable.dereference(
                          dictionary![PdfDictionaryProperties.contents]);
                      if (content != null) {
                        if (content is PdfArray) {
                          for (int i = 0; i < content.count; i++) {
                            final PdfStream pageContent =
                                PdfCrossTable.dereference(content[i])!
                                    as PdfStream;
                            pageContent.decompress();
                          }
                        } else if (content is PdfStream) {
                          content.decompress();
                        }
                      }
                      _resources!.setProperty(
                          PdfDictionaryProperties.xObject, xobjects);
                      setResources(_resources);
                    }
                  }
                } else if (obj is PdfReferenceHolder) {
                  bool isValueEqual = false;
                  final PdfDictionary pageSourceDictionary =
                      obj.object! as PdfDictionary;
                  if (pageSourceDictionary.items!.length ==
                          _resources!.items!.length ||
                      _resources!.items!.isEmpty) {
                    for (final PdfName? key in _resources!.items!.keys) {
                      if (pageSourceDictionary.items!.containsKey(key)) {
                        if (pageSourceDictionary.items!
                            .containsValue(_resources![key])) {
                          isValueEqual = true;
                        }
                      } else {
                        isValueEqual = false;
                        break;
                      }
                    }
                    if (isValueEqual || _resources!.items!.isEmpty) {
                      dictionary![PdfDictionaryProperties.resources] = obj;
                      _resources = PdfResources(obj.object as PdfDictionary?);
                    }
                    setResources(_resources);
                  }
                }
              }
            }
          }
        } else {
          final IPdfPrimitive? dicObj =
              dictionary![PdfDictionaryProperties.resources];
          final PdfDictionary? dic =
              crossTable!.getObject(dicObj) as PdfDictionary?;
          _resources = PdfResources(dic);
          dictionary![PdfDictionaryProperties.resources] = _resources;
          if (dictionary!.containsKey(PdfDictionaryProperties.parent)) {
            final PdfDictionary? parentDic = PdfCrossTable.dereference(
                dictionary![PdfDictionaryProperties.parent]) as PdfDictionary?;
            if (parentDic != null &&
                parentDic.containsKey(PdfDictionaryProperties.resources)) {
              final IPdfPrimitive? resource =
                  parentDic[PdfDictionaryProperties.resources];
              if (dicObj is PdfReferenceHolder &&
                  resource is PdfReferenceHolder &&
                  resource.reference == dicObj.reference) {
                final PdfDictionary? resourceDict =
                    PdfCrossTable.dereference(dicObj) as PdfDictionary?;
                if (resourceDict != null) {
                  _resources = PdfResources(resourceDict);
                }
              }
            }
          }
          setResources(_resources);
        }
        _checkResources = true;
      }
    }
    return _resources;
  }

  /// internal method
  void setResources(PdfResources? resources) {
    _resources = resources;
    dictionary![PdfDictionaryProperties.resources] = _resources;
  }

  /// internal method
  void createAnnotations(List<int> widgetReferences) {
    PdfArray? annots;
    if (dictionary!.containsKey(PdfDictionaryProperties.annots)) {
      annots = crossTable!
          .getObject(dictionary![PdfDictionaryProperties.annots]) as PdfArray?;
      if (annots != null) {
        for (int count = 0; count < annots.count; ++count) {
          PdfDictionary? annotDictionary;
          if (crossTable!.getObject(annots[count]) is PdfDictionary) {
            annotDictionary =
                crossTable!.getObject(annots[count]) as PdfDictionary?;
          }
          PdfReferenceHolder? annotReference;
          if (crossTable!.getObject(annots[count]) is PdfReferenceHolder) {
            annotReference =
                crossTable!.getObject(annots[count]) as PdfReferenceHolder?;
          }
          if (document != null &&
              PdfDocumentHelper.getHelper(document!).crossTable.encryptor !=
                  null &&
              PdfDocumentHelper.getHelper(document!)
                  .crossTable
                  .encryptor!
                  .encryptAttachmentOnly!) {
            if (annotDictionary != null &&
                annotDictionary.containsKey(PdfDictionaryProperties.subtype)) {
              final IPdfPrimitive? primitive = annotDictionary
                  .items![PdfName(PdfDictionaryProperties.subtype)];
              if (primitive is PdfName &&
                  primitive.name == 'FileAttachment' &&
                  annotDictionary.containsKey(PdfDictionaryProperties.fs)) {
                final IPdfPrimitive? file =
                    annotDictionary[PdfDictionaryProperties.fs];
                if (file != null && file is PdfReferenceHolder) {
                  final IPdfPrimitive? streamDictionary = file.object;
                  if (streamDictionary != null &&
                      streamDictionary is PdfDictionary &&
                      streamDictionary
                          .containsKey(PdfDictionaryProperties.ef)) {
                    PdfDictionary? attachmentStream;
                    IPdfPrimitive? holder =
                        streamDictionary[PdfDictionaryProperties.ef];
                    if (holder is PdfReferenceHolder) {
                      holder = holder.object;
                      if (holder != null && holder is PdfDictionary) {
                        attachmentStream = holder;
                      }
                    } else if (holder is PdfDictionary) {
                      attachmentStream = holder;
                    }
                    if (attachmentStream != null &&
                        attachmentStream
                            .containsKey(PdfDictionaryProperties.f)) {
                      holder = attachmentStream[PdfDictionaryProperties.f];
                      if (holder != null && holder is PdfReferenceHolder) {
                        final PdfReference? reference = holder.reference;
                        holder = holder.object;
                        if (holder != null && holder is PdfStream) {
                          final PdfStream encryptedObj = holder;
                          if (PdfDocumentHelper.getHelper(document!)
                              .isLoadedDocument) {
                            if (document!.onPdfPassword != null &&
                                PdfDocumentHelper.getHelper(document!)
                                        .password ==
                                    '') {
                              final PdfPasswordArgs args =
                                  PdfPasswordArgsHelper.load();
                              PdfDocumentHelper.getHelper(document!)
                                  .setUserPassword(args);
                              PdfDocumentHelper.getHelper(document!).password =
                                  args.attachmentOpenPassword;
                            }
                            PdfDocumentHelper.getHelper(document!)
                                .checkEncryption(
                                    PdfDocumentHelper.getHelper(document!)
                                        .crossTable
                                        .encryptor!
                                        .encryptAttachmentOnly);
                            encryptedObj.decrypt(
                                PdfDocumentHelper.getHelper(document!)
                                    .crossTable
                                    .encryptor!,
                                reference!.objNum);
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
          if (annotDictionary != null &&
              annotDictionary.containsKey(PdfDictionaryProperties.subtype)) {
            final PdfName? name = annotDictionary
                .items![PdfName(PdfDictionaryProperties.subtype)] as PdfName?;
            if (name != null && name.name.toString() != 'Widget') {
              if (!terminalAnnotation.contains(annotDictionary)) {
                terminalAnnotation.add(annotDictionary);
              }
            } else if (name != null && name.name.toString() == 'Widget') {
              if (annotDictionary.containsKey(PdfDictionaryProperties.parent)) {
                final PdfDictionary? annotParentDictionary = (annotDictionary
                            .items![PdfName(PdfDictionaryProperties.parent)]!
                        as PdfReferenceHolder)
                    .object as PdfDictionary?;
                if (annotParentDictionary != null) {
                  if (!annotParentDictionary
                      .containsKey(PdfDictionaryProperties.fields)) {
                    if (annotReference != null &&
                        annotReference.reference != null &&
                        !widgetReferences
                            .contains(annotReference.reference!.objNum)) {
                      if (!PdfFormHelper.getHelper(document!.form)
                          .terminalFields
                          .contains(annotParentDictionary)) {
                        PdfFormHelper.getHelper(document!.form)
                            .terminalFields
                            .add(annotParentDictionary);
                      }
                    } else if (annotParentDictionary
                            .containsKey(PdfDictionaryProperties.kids) &&
                        annotParentDictionary.count == 1) {
                      annotDictionary.remove(PdfDictionaryProperties.parent);
                    }
                  } else if (!annotParentDictionary
                      .containsKey(PdfDictionaryProperties.kids)) {
                    annotDictionary.remove(PdfDictionaryProperties.parent);
                  }
                }
              } else if (!PdfFormHelper.getHelper(document!.form)
                  .terminalFields
                  .contains(annotDictionary)) {
                Map<String?, List<PdfDictionary>>? widgetDictionary =
                    PdfFormHelper.getHelper(document!.form).widgetDictionary;
                if (widgetDictionary == null) {
                  PdfFormHelper.getHelper(document!.form).widgetDictionary =
                      <String?, List<PdfDictionary>>{};
                  widgetDictionary =
                      PdfFormHelper.getHelper(document!.form).widgetDictionary;
                }
                if (annotDictionary.containsKey(PdfDictionaryProperties.t)) {
                  final String? fieldName = (annotDictionary
                              .items![PdfName(PdfDictionaryProperties.t)]!
                          as PdfString)
                      .value;
                  if (widgetDictionary!.containsKey(fieldName)) {
                    final List<PdfDictionary> dict =
                        widgetDictionary[fieldName]!;
                    dict.add(annotDictionary);
                  } else {
                    if (!PdfFormFieldCollectionHelper.getHelper(
                            document!.form.fields)
                        .addedFieldNames
                        .contains(fieldName)) {
                      widgetDictionary[fieldName] = <PdfDictionary>[
                        annotDictionary
                      ];
                    }
                  }
                }
              }
            }
          }
          if (annotReference != null && annotReference.reference != null) {
            if (!annotsReference.contains(annotReference.reference!)) {
              annotsReference.add(annotReference.reference!);
            }
            bool skip = false;
            if (document != null &&
                widgetReferences.contains(annotReference.reference!.objNum)) {
              final PdfFormFieldCollection collection = document!.form.fields;
              for (int i = 0; i < collection.count; i++) {
                final PdfField field = collection[i];
                final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
                if (helper.isLoadedField) {
                  final IPdfPrimitive widget = helper.getWidgetAnnotation(
                      helper.dictionary!, helper.crossTable);
                  final PdfReference widgetReference =
                      crossTable!.getReference(widget);
                  if (annotReference.reference!.objNum ==
                          widgetReference.objNum &&
                      annotReference.reference!.genNum ==
                          widgetReference.genNum) {
                    skip = true;
                  }
                }
              }
            }
            if (annotDictionary != null && annotReference.reference != null) {
              if (!widgetReferences
                      .contains(annotReference.reference!.objNum) &&
                  !skip) {
                if (!terminalAnnotation.contains(annotDictionary)) {
                  terminalAnnotation.add(annotDictionary);
                }
              }
            }
          }
        }
      }
    }
    if (importAnnotation) {
      importAnnotation = false;
    }
    _annotations = PdfAnnotationCollectionHelper.load(base);
  }

  PdfTemplate _getContent() {
    final List<int> combinedData =
        PdfPageLayerCollectionHelper.getHelper(base.layers)
            .combineContent(false)!;
    final PdfDictionary? resources = PdfCrossTable.dereference(
        dictionary![PdfDictionaryProperties.resources]) as PdfDictionary?;
    final PdfTemplate template = PdfTemplateHelper.internal(
        origin, base.size, combinedData, resources!, isLoadedPage);
    return template;
  }

  /// internal method
  List<int> getWidgetReferences() {
    final List<int> widgetReferences = <int>[];
    final PdfFormFieldCollection collection = document!.form.fields;
    for (int i = 0; i < collection.count; i++) {
      final PdfField field = collection[i];
      final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
      if (helper.isLoadedField) {
        final IPdfPrimitive widget =
            helper.getWidgetAnnotation(helper.dictionary!, helper.crossTable);
        final Map<String, dynamic> widgetReference =
            PdfDocumentHelper.getHelper(document!)
                .objects
                .getReference(widget, false);
        widgetReferences.add(((widgetReference['isNew'] as bool)
                ? crossTable!.getReference(widget).objNum
                : (widgetReference['reference'] as PdfReference).objNum)!
            .toSigned(64));
        widgetReference.clear();
      }
    }
    return widgetReferences;
  }

  /// internal method
  PdfArray? obtainAnnotations() {
    final IPdfPrimitive? obj = dictionary!.getValue(
        PdfDictionaryProperties.annots, PdfDictionaryProperties.parent);
    return (obj != null && obj is PdfReferenceHolder ? obj.object : obj)
        as PdfArray?;
  }
}
