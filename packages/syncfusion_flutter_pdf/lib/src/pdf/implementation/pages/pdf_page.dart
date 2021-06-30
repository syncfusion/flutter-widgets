part of pdf;

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
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfPage implements _IPdfWrapper {
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
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPage() {
    _initialize();
  }

  PdfPage._fromDictionary(PdfDocument document, _PdfCrossTable crossTable,
      _PdfDictionary dictionary) {
    _pdfDocument = document;
    _dictionary = dictionary;
    _crossTable = crossTable;
    _isLoadedPage = true;
    _size = const Size(0, 0);
    _isTextExtraction = false;
    _graphicStateUpdated = false;
  }

  //Fields
  bool? _isNewPage;
  PdfSection? _section;
  PdfAnnotationCollection? _annotations;
  late _PdfDictionary _dictionary;
  _PdfResources? _resources;
  PdfPageLayerCollection? _layers;
  int _defaultLayerIndex = -1;
  bool _isLoadedPage = false;
  PdfDocument? _pdfDocument;
  Size? _size;
  _PdfCrossTable? _crossTable;
  bool _checkResources = false;
  final List<_PdfDictionary> _terminalAnnotation = <_PdfDictionary>[];
  final _PdfArray _annotsReference = _PdfArray();
  late bool _isTextExtraction;
  late bool _graphicStateUpdated;
  bool _isDefaultGraphics = false;
  PdfFormFieldsTabOrder _formFieldsTabOrder = PdfFormFieldsTabOrder.none;

  /// Raises before the page saves.
  Function? _beginSave;

  //Properties
  /// Gets size of the PDF page- Read only
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF page and Gets the size of its page
  /// Size size = document.pages.add().size;
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Size get size {
    if (_isLoadedPage) {
      if (_size == null || (_size!.width == 0 && _size!.height == 0)) {
        double width = 0;
        double height = 0;
        final _IPdfPrimitive? primitive = _dictionary._getValue(
            _DictionaryProperties.mediaBox, _DictionaryProperties.parent);
        if (primitive is _PdfArray) {
          final _PdfArray mBox = primitive;
          final num m0 = (mBox[0]! as _PdfNumber).value!;
          final num? m1 = (mBox[1]! as _PdfNumber).value;
          final num m2 = (mBox[2]! as _PdfNumber).value!;
          final num? m3 = (mBox[3]! as _PdfNumber).value;
          width = (m2 - m0).toDouble();
          height = m3 != 0 ? (m3! - m1!).toDouble() : m1!.toDouble();
        }
        _size = Size(width, height);
      }
      return _size!;
    } else {
      return _section!.pageSettings.size;
    }
  }

  Offset get _origin {
    if (_section != null) {
      return _section!.pageSettings._origin.offset;
    } else {
      return Offset.zero;
    }
  }

  PdfDocument? get _document {
    if (_isLoadedPage) {
      return _pdfDocument;
    } else {
      if (_section != null) {
        if (_section!._parent != null) {
          return _section!._parent!._document;
        } else if (_section!._pdfDocument != null) {
          return _section!._pdfDocument;
        } else {
          return null;
        }
      } else {
        return null;
      }
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
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfAnnotationCollection get annotations {
    if (!_isLoadedPage) {
      if (_annotations == null) {
        _annotations = PdfAnnotationCollection(this);
        if (!_dictionary.containsKey(_DictionaryProperties.annots)) {
          _dictionary[_DictionaryProperties.annots] =
              _annotations!._internalAnnotations;
        }
        _annotations!._internalAnnotations =
            _dictionary[_DictionaryProperties.annots] as _PdfArray?;
      }
    } else {
      if (_annotations == null) {
        // Create the annotations.
        _createAnnotations(_getWidgetReferences());
      }
      if (_annotations == null ||
          (_annotations!._annotations.count == 0 && _annotations!.count != 0)) {
        _annotations = PdfAnnotationCollection._(this);
      }
    }
    return _annotations!;
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
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGraphics get graphics {
    _isDefaultGraphics = true;
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
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPageLayerCollection get layers {
    if (!_isTextExtraction && !_graphicStateUpdated) {
      _layers = PdfPageLayerCollection(this);
      _graphicStateUpdated = true;
    } else {
      _layers ??= PdfPageLayerCollection(this);
    }
    return _layers!;
  }

  /// Gets array of page's content.
  _PdfArray get _contents {
    final _IPdfPrimitive? contents =
        _dictionary[_DictionaryProperties.contents];
    _PdfArray? elements;
    if (contents is _PdfReferenceHolder) {
      final _PdfReferenceHolder holder = contents;
      final _IPdfPrimitive? primitive = holder.object;
      if (primitive is _PdfArray) {
        elements = primitive;
      } else if (primitive is _PdfStream) {
        elements = _PdfArray();
        elements._add(_PdfReferenceHolder(primitive));
        if (!_isTextExtraction) {
          _dictionary[_DictionaryProperties.contents] = elements;
        }
      }
    } else if (contents is _PdfArray) {
      elements = contents;
    }
    if (elements == null) {
      elements = _PdfArray();
      if (!_isTextExtraction) {
        _dictionary[_DictionaryProperties.contents] = elements;
      }
    }
    return elements;
  }

  /// Gets the default layer of the page (Read only).
  /// ```dart
  /// //Create a new PDF documentation
  /// PdfDocument document = PdfDocument();
  /// //Create a new PDF page and gets the default layer
  /// PdfPageLayer defaultLayer = document.pages.add().defaultLayer;
  /// //Save the document.
  /// List<int> bytes = document.save();
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
  /// List<int> bytes = document.save();
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
        tabs = _DictionaryProperties.r;
      }
      if (_formFieldsTabOrder == PdfFormFieldsTabOrder.column) {
        tabs = _DictionaryProperties.c;
      }
      if (_formFieldsTabOrder == PdfFormFieldsTabOrder.structure) {
        tabs = _DictionaryProperties.s;
      }
      _dictionary[_DictionaryProperties.tabs] = _PdfName(tabs);
    }
  }

  PdfPageOrientation get _orientation => _obtainOrientation();

  PdfPageRotateAngle get _rotation => _obtainRotation();

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
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Size getClientSize() {
    return _isLoadedPage
        ? size
        : _section!._getActualBounds(this, true).size.size;
  }

  //Implementation

  void _assignSection(PdfSection section) {
    _section = section;
    _dictionary[_DictionaryProperties.parent] = _PdfReferenceHolder(section);
  }

  void _initialize() {
    _dictionary = _PdfDictionary();
    _dictionary[_DictionaryProperties.type] = _PdfName('Page');
    _dictionary._beginSave = _pageBeginSave;
    _size = const Size(0, 0);
    _isTextExtraction = false;
    _graphicStateUpdated = false;
  }

  void _drawPageTemplates(PdfDocument document) {
    // Draw Background templates.
    final bool hasBackTemplates =
        _section!._containsTemplates(document, this, false);
    if (hasBackTemplates) {
      final PdfPageLayer backLayer =
          PdfPageLayer._fromClipPageTemplate(this, false);
      final PdfPageLayerCollection _layer = PdfPageLayerCollection(this);
      _layers = _layer;
      _layers!.addLayer(backLayer);
      _section!._drawTemplates(this, backLayer, document, false);
    }

    // Draw Foreground templates.
    final bool hasFrontTemplates =
        _section!._containsTemplates(document, this, true);

    if (hasFrontTemplates) {
      final PdfPageLayer frontLayer =
          PdfPageLayer._fromClipPageTemplate(this, false);
      final PdfPageLayerCollection _layer = PdfPageLayerCollection(this);
      _layers = _layer;
      _layers!.addLayer(frontLayer);
      _section!._drawTemplates(this, frontLayer, document, true);
    }
  }

  PdfPageRotateAngle _obtainRotation() {
    _PdfDictionary? parent = _dictionary;
    _PdfNumber? angle;
    while (parent != null && angle == null) {
      if (parent.containsKey(_DictionaryProperties.rotate)) {
        if (parent[_DictionaryProperties.rotate] is _PdfReferenceHolder) {
          angle = (parent[_DictionaryProperties.rotate]! as _PdfReferenceHolder)
              .object as _PdfNumber?;
        } else {
          angle = parent[_DictionaryProperties.rotate] as _PdfNumber?;
        }
      }
      if (parent.containsKey(_DictionaryProperties.parent)) {
        _IPdfPrimitive? parentPrimitive = parent[_DictionaryProperties.parent];
        if (parentPrimitive != null) {
          parentPrimitive = _PdfCrossTable._dereference(parentPrimitive);
          parent = parentPrimitive != null && parentPrimitive is _PdfDictionary
              ? parentPrimitive
              : null;
        } else {
          parent = null;
        }
      } else {
        parent = null;
      }
    }
    angle ??= _PdfNumber(0);
    if (angle.value!.toInt() < 0) {
      angle.value = 360 + angle.value!.toInt();
    }
    final PdfPageRotateAngle rotateAngle =
        _getRotationFromAngle(angle.value! ~/ 90);
    return rotateAngle;
  }

  PdfPageRotateAngle _getRotationFromAngle(int angle) {
    if (angle == 90) {
      return PdfPageRotateAngle.rotateAngle90;
    } else if (angle == 180) {
      return PdfPageRotateAngle.rotateAngle180;
    } else if (angle == 270) {
      return PdfPageRotateAngle.rotateAngle270;
    } else {
      return PdfPageRotateAngle.rotateAngle0;
    }
  }

  PdfPageOrientation _obtainOrientation() {
    return (size.width > size.height)
        ? PdfPageOrientation.landscape
        : PdfPageOrientation.portrait;
  }

  _PdfResources? _getResources() {
    if (_resources == null) {
      if (!_isLoadedPage) {
        _resources = _PdfResources();
        _dictionary[_DictionaryProperties.resources] = _resources;
      } else {
        if (!_dictionary.containsKey(_DictionaryProperties.resources) ||
            _checkResources) {
          _resources = _PdfResources();
          _dictionary[_DictionaryProperties.resources] = _resources;
          // Check for the resources in the corresponding page section.
          if (_resources!._getNames()!.isEmpty || _resources!._items!.isEmpty) {
            if (_dictionary.containsKey(_DictionaryProperties.parent)) {
              _IPdfPrimitive? obj = _dictionary[_DictionaryProperties.parent];
              _PdfDictionary? parentDic;
              if (obj is _PdfReferenceHolder) {
                parentDic = obj.object as _PdfDictionary?;
              } else {
                parentDic = obj as _PdfDictionary?;
              }
              if (parentDic!.containsKey(_DictionaryProperties.resources)) {
                obj = parentDic[_DictionaryProperties.resources];
                if (obj is _PdfDictionary && obj._items!.isNotEmpty) {
                  _dictionary[_DictionaryProperties.resources] = obj;
                  _resources = _PdfResources(obj);
                  final _PdfDictionary xobjects = _PdfDictionary();
                  if (_resources!.containsKey(_DictionaryProperties.xObject)) {
                    final _PdfDictionary? xObject =
                        _resources![_DictionaryProperties.xObject]
                            as _PdfDictionary?;

                    if (xObject != null) {
                      final _PdfArray? content = _PdfCrossTable._dereference(
                              _dictionary[_DictionaryProperties.contents])
                          as _PdfArray?;

                      if (content != null) {
                        for (int i = 0; i < content.count; i++) {
                          final _PdfStream pageContent =
                              _PdfCrossTable._dereference(content[i])!
                                  as _PdfStream;
                          pageContent._decompress();
                        }
                      } else {
                        final _PdfStream pageContent =
                            _PdfCrossTable._dereference(_dictionary[
                                _DictionaryProperties.contents])! as _PdfStream;
                        pageContent._decompress();
                      }
                      _resources!
                          .setProperty(_DictionaryProperties.xObject, xobjects);
                      _setResources(_resources);
                    }
                  }
                } else if (obj is _PdfReferenceHolder) {
                  bool isValueEqual = false;

                  if (obj is _PdfReferenceHolder) {
                    final _PdfDictionary pageSourceDictionary =
                        obj.object! as _PdfDictionary;
                    if (pageSourceDictionary._items!.length ==
                            _resources!._items!.length ||
                        _resources!._items!.isEmpty) {
                      for (final _PdfName? key in _resources!._items!.keys) {
                        if (pageSourceDictionary._items!.containsKey(key)) {
                          if (pageSourceDictionary._items!
                              .containsValue(_resources![key])) {
                            isValueEqual = true;
                          }
                        } else {
                          isValueEqual = false;
                          break;
                        }
                      }
                      if (isValueEqual || _resources!._items!.isEmpty) {
                        _dictionary[_DictionaryProperties.resources] = obj;
                        _resources =
                            _PdfResources(obj.object as _PdfDictionary?);
                      }
                      _setResources(_resources);
                    }
                  }
                }
              }
            }
          }
        } else {
          final _IPdfPrimitive? dicObj =
              _dictionary[_DictionaryProperties.resources];
          final _PdfDictionary? dic =
              _crossTable!._getObject(dicObj) as _PdfDictionary?;
          _resources = _PdfResources(dic);
          _dictionary[_DictionaryProperties.resources] = _resources;
          if (_dictionary.containsKey(_DictionaryProperties.parent)) {
            final _PdfDictionary? parentDic = _PdfCrossTable._dereference(
                _dictionary[_DictionaryProperties.parent]) as _PdfDictionary?;
            if (parentDic != null &&
                parentDic.containsKey(_DictionaryProperties.resources)) {
              final _IPdfPrimitive? resource =
                  parentDic[_DictionaryProperties.resources];
              if (dicObj is _PdfReferenceHolder &&
                  resource is _PdfReferenceHolder &&
                  resource.reference == dicObj.reference) {
                final _PdfDictionary? resourceDict =
                    _PdfCrossTable._dereference(dicObj) as _PdfDictionary?;
                if (resourceDict != null) {
                  _resources = _PdfResources(resourceDict);
                }
              }
            }
          }
          _setResources(_resources);
        }
        _checkResources = true;
      }
    }
    return _resources;
  }

  void _setResources(_PdfResources? resources) {
    _resources = resources;
    _dictionary[_DictionaryProperties.resources] = _resources;
  }

  void _pageBeginSave(Object sender, _SavePdfPrimitiveArgs? args) {
    final PdfDocument? doc = args!.writer!._document;
    if (doc != null && _document != null) {
      _drawPageTemplates(doc);
    }
    if (_beginSave != null) {
      _beginSave!();
    }
  }

  // Retrieves the terminal annotations.
  void _createAnnotations(List<int> widgetReferences) {
    _PdfArray? annots;
    if (_dictionary.containsKey(_DictionaryProperties.annots)) {
      annots = _crossTable!
          ._getObject(_dictionary[_DictionaryProperties.annots]) as _PdfArray?;
      if (annots != null) {
        for (int count = 0; count < annots.count; ++count) {
          final _PdfDictionary? annotDicrionary =
              _crossTable!._getObject(annots[count]) as _PdfDictionary?;
          final _PdfReferenceHolder annotReference =
              annots[count]! as _PdfReferenceHolder;
          if (_document != null &&
              _document!._crossTable.encryptor != null &&
              _document!._crossTable.encryptor!._encryptOnlyAttachment!) {
            if (annotDicrionary != null &&
                annotDicrionary.containsKey(_DictionaryProperties.subtype)) {
              final _IPdfPrimitive? primitive = annotDicrionary
                  ._items![_PdfName(_DictionaryProperties.subtype)];
              if (primitive is _PdfName &&
                  primitive._name == 'FileAttachment' &&
                  annotDicrionary.containsKey(_DictionaryProperties.fs)) {
                final _IPdfPrimitive? file =
                    annotDicrionary[_DictionaryProperties.fs];
                if (file != null && file is _PdfReferenceHolder) {
                  final _IPdfPrimitive? streamDictionary = file.object;
                  if (streamDictionary != null &&
                      streamDictionary is _PdfDictionary &&
                      streamDictionary.containsKey(_DictionaryProperties.ef)) {
                    _PdfDictionary? attachmentStream;
                    _IPdfPrimitive? holder =
                        streamDictionary[_DictionaryProperties.ef];
                    if (holder is _PdfReferenceHolder) {
                      holder = holder.object;
                      if (holder != null && holder is _PdfDictionary) {
                        attachmentStream = holder;
                      }
                    } else if (holder is _PdfDictionary) {
                      attachmentStream = holder;
                    }
                    if (attachmentStream != null &&
                        attachmentStream.containsKey(_DictionaryProperties.f)) {
                      holder = attachmentStream[_DictionaryProperties.f];
                      if (holder != null && holder is _PdfReferenceHolder) {
                        final _PdfReference? reference = holder.reference;
                        holder = holder.object;
                        if (holder != null && holder is _PdfStream) {
                          final _PdfStream encryptedObj = holder;
                          if (_document!._isLoadedDocument) {
                            if (_document!.onPdfPassword != null &&
                                _document!._password == '') {
                              final PdfPasswordArgs args = PdfPasswordArgs._();
                              _document!._setUserPassword(args);
                              _document!._password =
                                  args.attachmentOpenPassword;
                            }
                            _document!._checkEncryption(_document!
                                ._crossTable.encryptor!._encryptOnlyAttachment);
                            encryptedObj.decrypt(
                                _document!._crossTable.encryptor!,
                                reference!._objNum);
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
          if (annotDicrionary != null &&
              annotDicrionary.containsKey(_DictionaryProperties.subtype)) {
            final _PdfName? name = annotDicrionary
                ._items![_PdfName(_DictionaryProperties.subtype)] as _PdfName?;
            if (name != null && name._name.toString() == 'Widget') {
              if (annotDicrionary.containsKey(_DictionaryProperties.parent)) {
                final _PdfDictionary? annotParentDictionary = (annotDicrionary
                            ._items![_PdfName(_DictionaryProperties.parent)]!
                        as _PdfReferenceHolder)
                    .object as _PdfDictionary?;
                if (annotParentDictionary != null) {
                  if (!annotParentDictionary
                      .containsKey(_DictionaryProperties.fields)) {
                    if (annotReference.reference != null &&
                        !widgetReferences
                            .contains(annotReference.reference!._objNum)) {
                      if (!_document!.form._terminalFields
                          .contains(annotParentDictionary)) {
                        _document!.form._terminalFields
                            .add(annotParentDictionary);
                      }
                    } else if (annotParentDictionary
                            .containsKey(_DictionaryProperties.kids) &&
                        annotParentDictionary.count == 1) {
                      annotDicrionary.remove(_DictionaryProperties.parent);
                    }
                  } else if (!annotParentDictionary
                      .containsKey(_DictionaryProperties.kids)) {
                    annotDicrionary.remove(_DictionaryProperties.parent);
                  }
                }
              } else if (!_document!.form._terminalFields
                  .contains(annotDicrionary)) {
                _document!.form._widgetDictionary ??=
                    <String?, List<_PdfDictionary>>{};
                if (annotDicrionary.containsKey(_DictionaryProperties.t)) {
                  final String? fieldName = (annotDicrionary
                              ._items![_PdfName(_DictionaryProperties.t)]!
                          as _PdfString)
                      .value;
                  if (_document!.form._widgetDictionary!
                      .containsKey(fieldName)) {
                    final List<_PdfDictionary> dict =
                        _document!.form._widgetDictionary![fieldName]!;
                    dict.add(annotDicrionary);
                  } else {
                    if (!_document!.form.fields._addedFieldNames
                        .contains(fieldName)) {
                      _document!.form._widgetDictionary![fieldName] =
                          <_PdfDictionary>[annotDicrionary];
                    }
                  }
                }
              }
            }
          }
          if (annotReference.reference != null) {
            if (!_annotsReference._contains(annotReference.reference!)) {
              _annotsReference._add(annotReference.reference!);
            }
            bool skip = false;
            if (_document != null &&
                widgetReferences.contains(annotReference.reference!._objNum)) {
              final PdfFormFieldCollection collection = _document!.form.fields;
              for (int i = 0; i < collection.count; i++) {
                final PdfField field = collection[i];
                if (field._isLoadedField) {
                  final _IPdfPrimitive widget = field._getWidgetAnnotation(
                      field._dictionary, field._crossTable);
                  final _PdfReference widgetReference =
                      _crossTable!._getReference(widget);
                  if (annotReference.reference!._objNum ==
                          widgetReference._objNum &&
                      annotReference.reference!._genNum ==
                          widgetReference._genNum) {
                    skip = true;
                  }
                }
              }
            }
            if (annotDicrionary != null && annotReference.reference != null) {
              if (!widgetReferences
                      .contains(annotReference.reference!._objNum) &&
                  !skip) {
                if (!_terminalAnnotation.contains(annotDicrionary)) {
                  _terminalAnnotation.add(annotDicrionary);
                }
              }
            }
          }
        }
      }
    }
    _annotations = PdfAnnotationCollection._(this);
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
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfTemplate createTemplate() {
    return _getContent();
  }

  PdfTemplate _getContent() {
    final List<int> combinedData = layers._combineContent(false)!;
    final _PdfDictionary? resources = _PdfCrossTable._dereference(
        _dictionary[_DictionaryProperties.resources]) as _PdfDictionary?;
    final PdfTemplate template =
        PdfTemplate._(_origin, size, combinedData, resources!, _isLoadedPage);
    return template;
  }

  // Gets the documents widget reference collection
  List<int> _getWidgetReferences() {
    final List<int> _widgetReferences = <int>[];
    final PdfFormFieldCollection collection = _document!.form.fields;
    for (int i = 0; i < collection.count; i++) {
      final PdfField field = collection[i];
      if (field._isLoadedField) {
        final _IPdfPrimitive widget =
            field._getWidgetAnnotation(field._dictionary, field._crossTable);
        final Map<String, dynamic> widgetReference =
            _document!._objects._getReference(widget, false);
        _widgetReferences.add(((widgetReference['isNew'] as bool)
                ? _crossTable!._getReference(widget)._objNum
                : (widgetReference['reference'] as _PdfReference)._objNum)!
            .toSigned(64));
        widgetReference.clear();
      }
    }
    return _widgetReferences;
  }

  _PdfArray? _obtainAnnotations() {
    final _IPdfPrimitive? obj = _dictionary._getValue(
        _DictionaryProperties.annots, _DictionaryProperties.parent);
    return (obj != null && obj is _PdfReferenceHolder ? obj.object : obj)
        as _PdfArray?;
  }

  //_IPdfWrapper elements
  @override
  _IPdfPrimitive? get _element => _dictionary;
  @override
  //ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _dictionary = value! as _PdfDictionary;
  }
}
