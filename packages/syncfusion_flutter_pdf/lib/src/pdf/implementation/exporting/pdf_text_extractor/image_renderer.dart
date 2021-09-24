part of pdf;

class _ImageRenderer {
  //Constructor
  _ImageRenderer(_PdfRecordCollection? contentElements,
      _PdfPageResources resources, this.currentPageHeight,
      [_GraphicsObject? g]) {
    const int dpiX = 96;
    _graphicsObject = _GraphicsObject();
    _graphicsState = _GraphicStateCollection();
    _objects = _GraphicObjectDataCollection();
    final _GraphicObjectData newObject = _GraphicObjectData();
    newObject.currentTransformationMatrix =
        _MatrixHelper(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
    final _MatrixHelper transformMatrix =
        g != null ? g._transformMatrix! : _graphicsObject!._transformMatrix!;
    newObject.currentTransformationMatrix!._translate(
        transformMatrix.offsetX / 1.333, transformMatrix.offsetY / 1.333);
    newObject.drawing2dMatrixCTM = _MatrixHelper(1, 0, 0, 1, 0, 0);
    newObject.drawing2dMatrixCTM!._translate(
        transformMatrix.offsetX / 1.333, transformMatrix.offsetY / 1.333);
    newObject.documentMatrix = _MatrixHelper(
        1.33333333333333 * (dpiX / 96) * transformMatrix.m11,
        0,
        0,
        -1.33333333333333 * (dpiX / 96) * transformMatrix.m22,
        0,
        currentPageHeight! * transformMatrix.m22);
    _objects!._push(newObject);
    _objects!._push(newObject);
    _contentElements = contentElements;
    _resources = resources;
    imageRenderGlyphList = <_Glyph>[];
    _initialize();
  }

  //Fields
  _GraphicObjectDataCollection? _objects;
  _GraphicStateCollection? _graphicsState;
  _GraphicsObject? _graphicsObject;
  _PdfRecordCollection? _contentElements;
  _PdfPageResources? _resources;

  double? currentPageHeight;
  late List<_Glyph> imageRenderGlyphList;
  _PdfRecordCollection? _type3RecordCollection;
  late bool _isType3Font;
  late List<String> _symbolChars;
  late bool _isXGraphics;
  late int _xobjectGraphicsCount;
  int? _renderingMode;
  late bool _textMatrix;
  late bool _isCurrentPositionChanged;
  Offset? _currentLocation;
  late Offset _endTextPosition;
  late bool isScaledText;
  late bool _skipRendering;
  late Map<String, bool> _layersVisibilityDictionary;
  late int _inlayersCount;
  bool? _selectablePrintDocument;
  double? _pageHeight;
  late bool _isExtractLineCollection;
  double? _textScaling = 100;
  late bool _isNextFill;
  double? pageRotation;
  double? zoomFactor;
  Map<String, String>? _substitutedFontsList;
  late double _textElementWidth;
  late List<_TextElement> extractTextElement;
  late List<_TextElement> _whiteSpace;
  //Properties
  _GraphicObjectData get objects => _objects!.last;
  _MatrixHelper? get textLineMatrix {
    return objects.textLineMatrix;
  }

  set textLineMatrix(_MatrixHelper? value) {
    objects.textLineMatrix = value;
  }

  _MatrixHelper? get textMatrix {
    return objects.textMatrix;
  }

  set textMatrix(_MatrixHelper? value) {
    objects.textMatrix = value;
  }

  _MatrixHelper? get drawing2dMatrixCTM {
    return objects.drawing2dMatrixCTM;
  }

  set drawing2dMatrixCTM(_MatrixHelper? value) {
    objects.drawing2dMatrixCTM = value;
  }

  _MatrixHelper? get currentTransformationMatrix {
    return objects.currentTransformationMatrix;
  }

  set currentTransformationMatrix(_MatrixHelper? value) {
    objects.currentTransformationMatrix = value;
  }

  _MatrixHelper? get documentMatrix {
    return objects.documentMatrix;
  }

  set documentMatrix(_MatrixHelper? value) {
    objects.documentMatrix = value;
  }

  Offset? get currentLocation {
    return _currentLocation;
  }

  set currentLocation(Offset? value) {
    _currentLocation = value;
    _isCurrentPositionChanged = true;
  }

  double? get textLeading => _objects!.textLeading;

  set textLeading(double? value) {
    objects.textLeading = value;
  }

  String? get currentFont => _objects!.currentFont;

  set currentFont(String? value) {
    objects.currentFont = value;
  }

  double? get fontSize => _objects!.fontSize;

  set fontSize(double? value) {
    objects.fontSize = value;
  }

  //Implementation
  void _initialize() {
    _selectablePrintDocument = false;
    _isType3Font = false;
    _symbolChars = <String>['(', ')', '[', ']', '<', '>'];
    _isXGraphics = false;
    _xobjectGraphicsCount = 0;
    _renderingMode = 0;
    _textMatrix = false;
    _isCurrentPositionChanged = false;
    _currentLocation = const Offset(0, 0);
    isScaledText = false;
    _skipRendering = false;
    _layersVisibilityDictionary = <String, bool>{};
    _inlayersCount = 0;
    _pageHeight = 0;
    _isExtractLineCollection = false;
    _isNextFill = false;
    pageRotation = 0;
    zoomFactor = 1;
    _substitutedFontsList = <String, String>{};
    extractTextElement = <_TextElement>[];
    _whiteSpace = <_TextElement>[];
  }

  void _renderAsImage() {
    final _PdfRecordCollection? _recordCollection =
        _isType3Font ? _type3RecordCollection : _contentElements;
    if (_recordCollection != null) {
      final List<_PdfRecord> records = _recordCollection._recordCollection;
      for (int i = 0; i < records.length; i++) {
        final _PdfRecord record = records[i];
        final String token = record._operatorName!;
        final List<String>? elements = record._operands;
        for (int j = 0; j < _symbolChars.length; j++) {
          if (token.contains(_symbolChars[j])) {
            token.replaceAll(_symbolChars[j], '');
          }
        }
        switch (token.trim()) {
          case 'BDC':
            {
              if (elements!.length > 1) {
                final String layerID = elements[1].replaceAll('/', '');
                if (_layersVisibilityDictionary.containsKey(layerID) &&
                    !_layersVisibilityDictionary[layerID]!) {
                  _skipRendering = true;
                }
                if (_skipRendering) {
                  _inlayersCount++;
                }
              }
            }
            break;
          case 'EMC':
            {
              if (_inlayersCount > 0) {
                _inlayersCount--;
              }
              if (_inlayersCount <= 0) {
                _skipRendering = false;
              }
            }
            break;
          case 'q':
            {
              final _GraphicObjectData data = _GraphicObjectData();
              if (_objects!.count > 0) {
                final _GraphicObjectData prevData = _objects!.last;
                data.currentTransformationMatrix =
                    prevData.currentTransformationMatrix;
                data._mitterLength = prevData._mitterLength;
                data.textLineMatrix = prevData.textLineMatrix;
                data.documentMatrix = prevData.documentMatrix;
                data.textMatrixUpdate = prevData.textMatrixUpdate;
                data.drawing2dMatrixCTM = prevData.drawing2dMatrixCTM;
                data._horizontalScaling = prevData._horizontalScaling;
                data.rise = prevData.rise;
                data.transformMatrixTM = prevData.transformMatrixTM;
                data.characterSpacing = prevData.characterSpacing;
                data.wordSpacing = prevData.wordSpacing;
                data._nonStrokingOpacity = prevData._nonStrokingOpacity;
                data._strokingOpacity = prevData._strokingOpacity;
              }
              if (_isXGraphics) {
                _xobjectGraphicsCount++;
              }
              _objects!._push(data);
              final _GraphicsState? state = _graphicsObject!._save();
              _graphicsState!._push(state);
              break;
            }
          case 'Q':
            {
              if (_isXGraphics) {
                _xobjectGraphicsCount--;
              }
              _objects!._pop();
              if (_graphicsState!.count > 0) {
                _graphicsObject!._restore(_graphicsState!._pop()!);
              }
              break;
            }
          case 'Tr':
            {
              _renderingMode = int.parse(elements![0]);
              break;
            }
          case 'Tm':
            {
              final double a = double.tryParse(elements![0])!;
              final double b = double.tryParse(elements[1])!;
              final double c = double.tryParse(elements[2])!;
              final double d = double.tryParse(elements[3])!;
              final double e = double.tryParse(elements[4])!;
              final double f = double.tryParse(elements[5])!;
              _setTextMatrix(a, b, c, d, e, f);
              if (_textMatrix) {
                _graphicsObject!._restore(_graphicsState!._pop()!);
              }
              final _GraphicsState? state = _graphicsObject!._save();
              _graphicsState!._push(state);
              _graphicsObject!
                  ._multiplyTransform(_MatrixHelper(a, -b, -c, d, e, -f));
              currentLocation = const Offset(0, 0);
              _textMatrix = true;
              break;
            }
          case 'cm':
            {
              final double a = double.tryParse(elements![0])!;
              final double b = double.tryParse(elements[1])!;
              final double c = double.tryParse(elements[2])!;
              final double d = double.tryParse(elements[3])!;
              final double e = double.tryParse(elements[4])!;
              final double f = double.tryParse(elements[5])!;
              drawing2dMatrixCTM = _setMatrix(a, b, c, d, e, f);
              break;
            }
          case 'BT':
            {
              textLineMatrix = _MatrixHelper(1, 0, 0, 1, 0, 0);
              textMatrix = _MatrixHelper(1, 0, 0, 1, 0, 0);
              currentLocation = const Offset(0, 0);
              break;
            }
          case 'ET':
            {
              currentLocation = const Offset(0, 0);
              if (isScaledText) {
                isScaledText = false;
                _graphicsObject!._restore(_graphicsState!._pop()!);
              }
              if (_textMatrix) {
                _graphicsObject!._restore(_graphicsState!._pop()!);
                _textMatrix = false;
              }
              if (_renderingMode == 2 &&
                  _recordCollection._recordCollection.length > i + 1 &&
                  _recordCollection._recordCollection[i + 1]._operatorName !=
                      'q') {
                _renderingMode = 0;
              }
              break;
            }
          case 'T*':
            {
              _moveToNextLineWithCurrentTextLeading();
              _drawNewLine();
              break;
            }
          case 'TJ':
            {
              if (_skipRendering) {
                break;
              }
              if (fontSize != 0) {
                _renderTextElementWithSpacing(elements!, token);
              }
              break;
            }
          case 'Tj':
            {
              if (_skipRendering) {
                break;
              }
              if (fontSize != 0) {
                _renderTextElementWithLeading(elements!, token);
              }
              break;
            }
          case '\'':
            {
              _moveToNextLineWithCurrentTextLeading();
              final _MatrixHelper transformMatrix =
                  _getTextRenderingMatrix(false);
              objects.textMatrixUpdate = transformMatrix;
              if (_textScaling != 100) {
                final _GraphicsState? state = _graphicsObject!._save();
                _graphicsState!._push(state);
                _graphicsObject!._scaleTransform(_textScaling! / 100, 1);
                isScaledText = true;
                currentLocation = Offset(
                    currentLocation!.dx / (_textScaling! / 100),
                    currentLocation!.dy);
              }
              _renderTextElementWithLeading(elements!, token);
              break;
            }

          case 'Tf':
            {
              _renderFont(elements!);
              break;
            }
          case 'TD':
            {
              currentLocation = Offset(
                  currentLocation!.dx + double.tryParse(elements![0])!,
                  currentLocation!.dy - double.tryParse(elements[1])!);
              _moveToNextLineWithLeading(elements);
              break;
            }
          case 'Td':
            {
              final double dx = double.tryParse(elements![0])!;
              final double dy = double.tryParse(elements[1])!;
              currentLocation =
                  Offset(currentLocation!.dx + dx, currentLocation!.dy - dy);
              _moveToNextLine(dx, dy);
              break;
            }
          case 'TL':
            {
              textLeading = -double.tryParse(elements![0])!;
              break;
            }
          case 'Tw':
            {
              _getWordSpacing(elements!);
              break;
            }
          case 'Tc':
            {
              _getCharacterSpacing(elements!);
              break;
            }
          case 'Tz':
            {
              _getScalingFactor(elements!);
              break;
            }
          case 'Do':
            {
              if (_skipRendering) {
                break;
              }
              _getXObject(elements!);
              break;
            }
          case 're':
            {
              if (_skipRendering) {
                break;
              }
              if (i < _recordCollection._count &&
                  _recordCollection._recordCollection[i + 1]._operatorName ==
                      'f') {
                _isNextFill = true;
              }
              if (!(drawing2dMatrixCTM!.m11 == 0 &&
                  drawing2dMatrixCTM!.m21 == 0 &&
                  _isNextFill)) {
                _getClipRectangle(elements!);
              }
              break;
            }
          case 'b':
          case 'b*':
            {
              if (_skipRendering) {
                break;
              }
              final _MatrixHelper initialmatrix = documentMatrix!;
              final _MatrixHelper currentCTM = _MatrixHelper(
                  drawing2dMatrixCTM!.m11,
                  drawing2dMatrixCTM!.m12,
                  drawing2dMatrixCTM!.m21,
                  drawing2dMatrixCTM!.m22,
                  drawing2dMatrixCTM!.offsetX,
                  drawing2dMatrixCTM!.offsetY);
              final _MatrixHelper result = currentCTM * initialmatrix;
              final _MatrixHelper transformMatrix = _MatrixHelper(
                  result.m11,
                  result.m12,
                  result.m21,
                  result.m22,
                  result.offsetX,
                  result.offsetY);
              _MatrixHelper graphicsTransformMatrix =
                  _MatrixHelper(1, 0, 0, 1, 0, 0);
              graphicsTransformMatrix =
                  graphicsTransformMatrix * transformMatrix;
              _graphicsObject!._transformMatrix =
                  _MatrixHelper(1, 0, 0, 1, 0, 0) * transformMatrix;
              break;
            }
          case 'W':
          case 'W*':
            _graphicsObject!._transformMatrix = _MatrixHelper(1, 0, 0, 1, 0, 0);
            break;
          default:
            break;
        }
      }
    }
  }

  _MatrixHelper _getTextRenderingMatrix(bool isPath) {
    _MatrixHelper mat = _MatrixHelper(
        fontSize! * (objects._horizontalScaling! / 100),
        0,
        0,
        isPath ? fontSize! : (-fontSize!),
        0,
        (isPath ? objects.rise! : (fontSize! + objects.rise!)) as double);
    mat *= textLineMatrix! * currentTransformationMatrix!;
    return mat;
  }

  void _getWordSpacing(List<String> spacing) {
    objects.wordSpacing = double.tryParse(spacing[0]);
  }

  void _getCharacterSpacing(List<String> spacing) {
    objects.characterSpacing = double.tryParse(spacing[0]);
  }

  void _getClipRectangle(List<String> rectangle) {
    double x = double.tryParse(rectangle[0])!;
    final double y = double.tryParse(rectangle[1])!;
    double? height = double.tryParse(rectangle[3]);
    if (x < 0 && height! < 0 && _isNextFill) {
      if (-height >= currentPageHeight!) {
        x = 0;
        height = 0;
      }
    }
    _isNextFill = false;
    _currentLocation = Offset(x, y + height!);
  }

  void _renderFont(List<String> fontElements) {
    int i;
    for (i = 0; i < fontElements.length; i++) {
      if (fontElements[i].contains('/')) {
        currentFont = fontElements[i].replaceAll('/', '');
        break;
      }
    }
    fontSize = double.tryParse(fontElements[i + 1]);
    if (_resources!.containsKey(currentFont)) {
      final _FontStructure structure =
          _resources![currentFont!] as _FontStructure;
      if (structure._isStandardFont) {
        structure._createStandardFont(fontSize!);
      } else if (structure._isStandardCJKFont) {
        structure._createStandardCJKFont(fontSize!);
      }
    }
  }

  void _drawNewLine() {
    _isCurrentPositionChanged = true;
    if ((-textLeading!) != 0) {
      _currentLocation = Offset(
          _currentLocation!.dx,
          (-textLeading!) < 0
              ? _currentLocation!.dy - (-textLeading!)
              : _currentLocation!.dy + (-textLeading!));
    } else {
      _currentLocation =
          Offset(_currentLocation!.dx, _currentLocation!.dy + fontSize!);
    }
  }

  void _getScalingFactor(List<String> elements) {
    _textScaling = double.tryParse(elements[0]);
    objects._horizontalScaling = double.tryParse(elements[0]);
  }

  void _getXObject(List<String> xobjectElement) {
    final String key = xobjectElement[0].replaceAll('/', '');
    if (_resources!.containsKey(key)) {
      final dynamic resource = _resources![key];
      if (resource is _XObjectElement) {
        List<_Glyph>? xObjectGlyphs;
        final _XObjectElement xObjectElement = resource;
        xObjectElement._isExtractTextLine = _isExtractLineCollection;
        if (_selectablePrintDocument!) {
          xObjectElement._isPrintSelected = _selectablePrintDocument;
          xObjectElement._pageHeight = _pageHeight;
        }
        final Map<String, dynamic> result = xObjectElement._render(
            _graphicsObject,
            _resources,
            _graphicsState,
            _objects,
            currentPageHeight,
            xObjectGlyphs);
        _graphicsState = result['graphicStates'] as _GraphicStateCollection?;
        _objects = result['objects'] as _GraphicObjectDataCollection?;
        xObjectGlyphs = result['glyphList'] as List<_Glyph>?;
        final List<_TextElement>? tempExtractTextElement =
            result['extractTextElement'] as List<_TextElement>?;
        if (tempExtractTextElement != null &&
            tempExtractTextElement.isNotEmpty) {
          extractTextElement.addAll(tempExtractTextElement);
        }
        imageRenderGlyphList.addAll(xObjectGlyphs!);
        xObjectGlyphs.clear();
      }
    }
  }

  void _renderTextElementWithLeading(
      List<String> textElements, String tokenType) {
    String text = textElements.join();
    if (_resources!.containsKey(currentFont)) {
      final _FontStructure structure =
          _resources![currentFont!] as _FontStructure;
      structure.isSameFont = _resources!.isSameFont();
      structure.fontSize = fontSize;

      if (!structure.isEmbedded &&
          structure.font != null &&
          structure._isStandardCJKFont) {
        text = structure.fromUnicodeText(structure.getEncodedText(text, true));
      } else if (!structure.isEmbedded &&
          structure.font != null &&
          structure._isStandardFont) {
        text = structure.getEncodedText(text, true);
      } else {
        text = structure.decodeTextExtraction(text, _resources!.isSameFont());
      }
      final _TextElement element = _TextElement(text, documentMatrix);
      element.fontStyle = structure.fontStyle!;
      element.fontName = structure.fontName!;
      element.fontSize = fontSize!;
      element.textScaling = _textScaling;
      element.fontEncoding = structure.fontEncoding;
      element.fontGlyphWidths = structure.fontGlyphWidths;
      element.defaultGlyphWidth = structure.defaultGlyphWidth;
      element._text = text;
      element.unicodeCharMapTable = structure.unicodeCharMapTable;
      final Map<int, int> glyphWidths = structure.fontGlyphWidths!;
      element.characterMapTable = structure.characterMapTable;
      element.reverseMapTable = structure.reverseMapTable;
      element.structure = structure;
      element.isEmbeddedFont = structure.isEmbedded;
      element.currentTransformationMatrix = currentTransformationMatrix;
      element.textLineMatrix = textMatrix;
      element._rise = objects.rise;
      element.transformMatrix = documentMatrix;
      element.documentMatrix = documentMatrix;
      element.fontId = currentFont;
      element.octDecMapTable = structure.octDecMapTable;
      element.textHorizontalScaling = objects._horizontalScaling;
      element.zapfPostScript = structure.zapfPostScript;
      element.lineWidth = objects._mitterLength;
      element.renderingMode = _renderingMode;
      element.pageRotation = pageRotation;
      element.zoomFactor = zoomFactor;
      element.substitutedFontsList = _substitutedFontsList;
      element.wordSpacing = objects.wordSpacing;
      element.characterSpacing = objects.characterSpacing;
      final _MatrixHelper tempTextMatrix = _MatrixHelper(0, 0, 0, 0, 0, 0);
      tempTextMatrix.type = _MatrixTypes.identity;
      if (_isCurrentPositionChanged) {
        _isCurrentPositionChanged = false;
        _endTextPosition = currentLocation!;
        final Map<String, dynamic> renderedResult = element._render(
            _graphicsObject,
            Offset(_endTextPosition.dx,
                _endTextPosition.dy + ((-textLeading!) / 4)),
            _textScaling,
            glyphWidths,
            structure._type1GlyphHeight,
            structure.differenceTable,
            structure.differencesDictionary,
            structure.differenceEncoding,
            tempTextMatrix);
        _textElementWidth = renderedResult['textElementWidth'] as double;
        textMatrix = renderedResult['tempTextMatrix'] as _MatrixHelper;
      } else {
        _endTextPosition = Offset(
            _endTextPosition.dx + _textElementWidth, _endTextPosition.dy);
        final Map<String, dynamic> renderedResult = element._render(
            _graphicsObject,
            Offset(
                _endTextPosition.dx, _endTextPosition.dy + (-textLeading! / 4)),
            _textScaling,
            glyphWidths,
            structure._type1GlyphHeight,
            structure.differenceTable,
            structure.differencesDictionary,
            structure.differenceEncoding,
            tempTextMatrix);
        _textElementWidth = renderedResult['textElementWidth'] as double;
        textMatrix = renderedResult['tempTextMatrix'] as _MatrixHelper;
      }
      if (!structure.isWhiteSpace) {
        if (_whiteSpace.isNotEmpty &&
            extractTextElement.isNotEmpty &&
            _whiteSpace.length == 1) {
          if (extractTextElement[extractTextElement.length - 1]
                      .textLineMatrix!
                      .offsetY ==
                  element.textLineMatrix!.offsetY &&
              _whiteSpace[0].textLineMatrix!.offsetY ==
                  element.textLineMatrix!.offsetY) {
            if (_whiteSpace[0]._text.isNotEmpty) {
              element.textElementGlyphList
                  .insert(0, _whiteSpace[0].textElementGlyphList[0]);
            }
            extractTextElement.add(_whiteSpace[0]);
          }
          _whiteSpace = <_TextElement>[];
        }
        imageRenderGlyphList.addAll(element.textElementGlyphList);
        if (_isExtractLineCollection) {
          extractTextElement.add(element);
        }
        _whiteSpace = <_TextElement>[];
      } else {
        _whiteSpace.add(element);
      }
    }
  }

  void _renderTextElementWithSpacing(
      List<String> textElements, String tokenType) {
    List<String> decodedList = <String>[];
    final String text = textElements.join();
    if (_resources!.containsKey(currentFont)) {
      final _FontStructure structure =
          _resources![currentFont!] as _FontStructure;
      structure.isSameFont = _resources!.isSameFont();
      structure.fontSize = fontSize;
      List<double>? characterSpacings;
      if (!structure.isEmbedded &&
          structure._isStandardCJKFont &&
          structure.font != null) {
        decodedList =
            structure.decodeCjkTextExtractionTJ(text, _resources!.isSameFont());
      } else {
        decodedList =
            structure.decodeTextExtractionTJ(text, _resources!.isSameFont());
      }
      final List<int> bytes =
          utf8.encode(structure.getEncodedText(text, _resources!.isSameFont()));
      final Map<int, int> encodedTextBytes = <int, int>{};
      int z = 0;
      for (int j = 0; j < bytes.length; j = j + 2) {
        encodedTextBytes[z] = bytes[j];
        z++;
      }
      final _TextElement element = _TextElement(text, documentMatrix);
      element.fontStyle = structure.fontStyle!;
      element.fontName = structure.fontName!;
      element.fontSize = fontSize!;
      element.textScaling = _textScaling;
      element.encodedTextBytes = encodedTextBytes;
      element.fontEncoding = structure.fontEncoding;
      element.fontGlyphWidths = structure.fontGlyphWidths;
      element.defaultGlyphWidth = structure.defaultGlyphWidth;
      element.renderingMode = _renderingMode;
      element.unicodeCharMapTable = structure.unicodeCharMapTable;
      final Map<int, int> glyphWidths = structure.fontGlyphWidths!;
      element.cidToGidReverseMapTable = structure.cidToGidReverseMapTable;
      element.characterMapTable = structure.characterMapTable;
      element.reverseMapTable = structure.reverseMapTable;
      // //element.fontfile2Glyph = structure.glyphFontFile2;
      element.structure = structure;
      element.isEmbeddedFont = structure.isEmbedded;
      element.currentTransformationMatrix = currentTransformationMatrix;
      element.textLineMatrix = textMatrix;
      element._rise = objects.rise;
      element.transformMatrix = documentMatrix;
      element.documentMatrix = documentMatrix;
      element.fontId = currentFont;
      element.octDecMapTable = structure.octDecMapTable;
      element.textHorizontalScaling = objects._horizontalScaling;
      element.zapfPostScript = structure.zapfPostScript;
      element.lineWidth = objects._mitterLength;
      element.renderingMode = _renderingMode;
      element.pageRotation = pageRotation;
      element.zoomFactor = zoomFactor;
      element.substitutedFontsList = _substitutedFontsList;
      if (structure.flags != null) {
        element.fontFlag = structure.flags!.value!.toInt();
      }
      element.wordSpacing = objects.wordSpacing;
      element.characterSpacing = objects.characterSpacing;
      final _MatrixHelper tempTextMatrix = _MatrixHelper(0, 0, 0, 0, 0, 0);
      tempTextMatrix.type = _MatrixTypes.identity;
      if (_isCurrentPositionChanged) {
        _isCurrentPositionChanged = false;
        _endTextPosition = currentLocation!;
      } else {
        _endTextPosition = Offset(
            _endTextPosition.dx + _textElementWidth, _endTextPosition.dy);
      }
      final Map<String, dynamic> renderedResult = element._renderWithSpacing(
          _graphicsObject,
          Offset(_endTextPosition.dx, _endTextPosition.dy - fontSize!),
          decodedList,
          characterSpacings,
          _textScaling,
          glyphWidths,
          structure._type1GlyphHeight,
          structure.differenceTable,
          structure.differencesDictionary,
          structure.differenceEncoding,
          tempTextMatrix);
      _textElementWidth = renderedResult['textElementWidth'] as double;
      textMatrix = renderedResult['tempTextMatrix'] as _MatrixHelper;
      if (!structure.isWhiteSpace) {
        if (_whiteSpace.isNotEmpty &&
            extractTextElement.isNotEmpty &&
            _whiteSpace.length == 1) {
          if (extractTextElement[extractTextElement.length - 1]
                      .textLineMatrix!
                      .offsetY ==
                  element.textLineMatrix!.offsetY &&
              _whiteSpace[0].textLineMatrix!.offsetY ==
                  element.textLineMatrix!.offsetY &&
              _whiteSpace[0].textElementGlyphList.isNotEmpty) {
            element.textElementGlyphList
                .insert(0, _whiteSpace[0].textElementGlyphList[0]);
            extractTextElement.add(_whiteSpace[0]);
          }
          _whiteSpace = <_TextElement>[];
        }
        imageRenderGlyphList.addAll(element.textElementGlyphList);
        if (_isExtractLineCollection) {
          extractTextElement.add(element);
        }
        _whiteSpace = <_TextElement>[];
      } else {
        _whiteSpace.add(element);
      }
    }
  }

  void _moveToNextLineWithCurrentTextLeading() {
    _moveToNextLine(0, textLeading!);
  }

  void _moveToNextLineWithLeading(List<String> elements) {
    final double dx = double.tryParse(elements[0])!;
    final double dy = double.tryParse(elements[1])!;
    textLeading = dy;
    _moveToNextLine(dx, dy);
  }

  void _moveToNextLine(double tx, double ty) {
    textLineMatrix =
        textMatrix = _MatrixHelper(1, 0, 0, 1, tx, ty) * textLineMatrix!;
  }

  void _setTextMatrix(
      double a, double b, double c, double d, double e, double f) {
    textLineMatrix = textMatrix = _MatrixHelper(a, b, c, d, e, f);
  }

  _MatrixHelper _setMatrix(
      double a, double b, double c, double d, double e, double f) {
    currentTransformationMatrix = _MatrixHelper(a, b, c, d, e, f) *
        _objects!.last.currentTransformationMatrix!;
    return _MatrixHelper(
        currentTransformationMatrix!.m11,
        currentTransformationMatrix!.m12,
        currentTransformationMatrix!.m21,
        currentTransformationMatrix!.m22,
        currentTransformationMatrix!.offsetX,
        currentTransformationMatrix!.offsetY);
  }
}
