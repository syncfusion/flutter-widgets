import 'dart:convert';
import 'dart:ui';

import 'font_structure.dart';
import 'glyph.dart';
import 'graphic_object_data.dart';
import 'graphic_object_data_collection.dart';
import 'matrix_helper.dart';
import 'page_resource_loader.dart';
import 'parser/content_parser.dart';
import 'text_element.dart';
import 'xobject_element.dart';

/// internal class
class ImageRenderer {
  /// internal constructor
  ImageRenderer(PdfRecordCollection? contentElements,
      PdfPageResources resources, this.currentPageHeight,
      [GraphicsObject? g]) {
    const int dpiX = 96;
    _graphicsObject = GraphicsObject();
    _graphicsState = GraphicStateCollection();
    graphicsObjects = GraphicObjectDataCollection();
    final GraphicObjectData newObject = GraphicObjectData();
    newObject.currentTransformationMatrix =
        MatrixHelper(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
    final MatrixHelper transformMatrix =
        g != null ? g.transformMatrix! : _graphicsObject!.transformMatrix!;
    newObject.currentTransformationMatrix!.translate(
        transformMatrix.offsetX / 1.333, transformMatrix.offsetY / 1.333);
    newObject.drawing2dMatrixCTM = MatrixHelper(1, 0, 0, 1, 0, 0);
    newObject.drawing2dMatrixCTM!.translate(
        transformMatrix.offsetX / 1.333, transformMatrix.offsetY / 1.333);
    newObject.documentMatrix = MatrixHelper(
        1.33333333333333 * (dpiX / 96) * transformMatrix.m11,
        0,
        0,
        -1.33333333333333 * (dpiX / 96) * transformMatrix.m22,
        0,
        currentPageHeight! * transformMatrix.m22);
    graphicsObjects!.push(newObject);
    graphicsObjects!.push(newObject);
    _contentElements = contentElements;
    _resources = resources;
    imageRenderGlyphList = <Glyph>[];
    _initialize();
  }

  //Fields
  /// internal field
  GraphicObjectDataCollection? graphicsObjects;
  GraphicStateCollection? _graphicsState;
  GraphicsObject? _graphicsObject;
  PdfRecordCollection? _contentElements;
  PdfPageResources? _resources;
  String? _actualText;

  /// internal field
  double? currentPageHeight;

  /// internal field
  late List<Glyph> imageRenderGlyphList;
  PdfRecordCollection? _type3RecordCollection;
  late bool _isType3Font;
  late List<String> _symbolChars;

  /// internal field
  late bool isXGraphics;

  /// internal field
  late int xobjectGraphicsCount;
  int? _renderingMode;
  late bool _textMatrix;
  late bool _isCurrentPositionChanged;
  Offset? _currentLocation;
  late Offset _endTextPosition;

  /// internal field
  late bool isScaledText;
  late bool _skipRendering;
  late Map<String, bool> _layersVisibilityDictionary;
  late int _inlayersCount;

  /// internal field
  bool? selectablePrintDocument;

  /// internal field
  double? pageHeight;

  /// internal field
  late bool isExtractLineCollection;
  double? _textScaling = 100;
  late bool _isNextFill;

  /// internal field
  double? pageRotation;

  /// internal field
  double? zoomFactor;
  Map<String, String>? _substitutedFontsList;
  late double _textElementWidth;

  /// internal field
  late List<TextElement> extractTextElement;
  late List<TextElement> _whiteSpace;
  //Properties
  /// internal property
  GraphicObjectData get objects => graphicsObjects!.last;

  /// internal property
  MatrixHelper? get textLineMatrix {
    return objects.textLineMatrix;
  }

  set textLineMatrix(MatrixHelper? value) {
    objects.textLineMatrix = value;
  }

  /// internal property
  MatrixHelper? get textMatrix {
    return objects.textMatrix;
  }

  set textMatrix(MatrixHelper? value) {
    objects.textMatrix = value;
  }

  /// internal property
  MatrixHelper? get drawing2dMatrixCTM {
    return objects.drawing2dMatrixCTM;
  }

  set drawing2dMatrixCTM(MatrixHelper? value) {
    objects.drawing2dMatrixCTM = value;
  }

  /// internal property
  MatrixHelper? get currentTransformationMatrix {
    return objects.currentTransformationMatrix;
  }

  set currentTransformationMatrix(MatrixHelper? value) {
    objects.currentTransformationMatrix = value;
  }

  /// internal property
  MatrixHelper? get documentMatrix {
    return objects.documentMatrix;
  }

  set documentMatrix(MatrixHelper? value) {
    objects.documentMatrix = value;
  }

  /// internal property
  Offset? get currentLocation {
    return _currentLocation;
  }

  set currentLocation(Offset? value) {
    _currentLocation = value;
    _isCurrentPositionChanged = true;
  }

  /// internal property
  double? get textLeading => graphicsObjects!.textLeading;

  set textLeading(double? value) {
    objects.textLeading = value;
  }

  /// internal property
  String? get currentFont => graphicsObjects!.currentFont;

  set currentFont(String? value) {
    objects.currentFont = value;
  }

  /// internal property
  double? get fontSize => graphicsObjects!.fontSize;

  set fontSize(double? value) {
    objects.fontSize = value;
  }

  //Implementation
  void _initialize() {
    selectablePrintDocument = false;
    _isType3Font = false;
    _symbolChars = <String>['(', ')', '[', ']', '<', '>'];
    isXGraphics = false;
    xobjectGraphicsCount = 0;
    _renderingMode = 0;
    _textMatrix = false;
    _isCurrentPositionChanged = false;
    _currentLocation = Offset.zero;
    isScaledText = false;
    _skipRendering = false;
    _layersVisibilityDictionary = <String, bool>{};
    _inlayersCount = 0;
    pageHeight = 0;
    isExtractLineCollection = false;
    _isNextFill = false;
    pageRotation = 0;
    zoomFactor = 1;
    _substitutedFontsList = <String, String>{};
    extractTextElement = <TextElement>[];
    _whiteSpace = <TextElement>[];
  }

  /// internal method
  void renderAsImage() {
    final PdfRecordCollection? pdfRecordCollection =
        _isType3Font ? _type3RecordCollection : _contentElements;
    if (pdfRecordCollection != null) {
      final List<PdfRecord> records = pdfRecordCollection.recordCollection;
      for (int i = 0; i < records.length; i++) {
        final PdfRecord record = records[i];
        final String token = record.operatorName!;
        final List<String>? elements = record.operands;
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
                if (elements[1].contains('ActualText') &&
                    elements[1].contains('(')) {
                  _actualText = elements[1].substring(
                      elements[1].indexOf('(') + 1,
                      elements[1].lastIndexOf(')'));
                  const String bigEndianPreambleString = 'þÿ';
                  if (_actualText != null &&
                      _actualText!.startsWith(bigEndianPreambleString)) {
                    _actualText = null;
                  }
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
              _actualText = null;
            }
            break;
          case 'q':
            {
              final GraphicObjectData data = GraphicObjectData();
              if (graphicsObjects!.count > 0) {
                final GraphicObjectData prevData = graphicsObjects!.last;
                data.currentTransformationMatrix =
                    prevData.currentTransformationMatrix;
                data.mitterLength = prevData.mitterLength;
                data.textLineMatrix = prevData.textLineMatrix;
                data.documentMatrix = prevData.documentMatrix;
                data.textMatrixUpdate = prevData.textMatrixUpdate;
                data.drawing2dMatrixCTM = prevData.drawing2dMatrixCTM;
                data.horizontalScaling = prevData.horizontalScaling;
                data.rise = prevData.rise;
                data.transformMatrixTM = prevData.transformMatrixTM;
                data.characterSpacing = prevData.characterSpacing;
                data.wordSpacing = prevData.wordSpacing;
                data.nonStrokingOpacity = prevData.nonStrokingOpacity;
                data.strokingOpacity = prevData.strokingOpacity;
              }
              if (isXGraphics) {
                xobjectGraphicsCount++;
              }
              graphicsObjects!.push(data);
              final GraphicsState? state = _graphicsObject!.save();
              _graphicsState!.push(state);
              break;
            }
          case 'Q':
            {
              if (isXGraphics) {
                xobjectGraphicsCount--;
              }
              graphicsObjects!.pop();
              if (_graphicsState!.count > 0) {
                _graphicsObject!.restore(_graphicsState!.pop()!);
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
                _graphicsObject!.restore(_graphicsState!.pop()!);
              }
              final GraphicsState? state = _graphicsObject!.save();
              _graphicsState!.push(state);
              _graphicsObject!
                  .multiplyTransform(MatrixHelper(a, -b, -c, d, e, -f));
              currentLocation = Offset.zero;
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
              textLineMatrix = MatrixHelper(1, 0, 0, 1, 0, 0);
              textMatrix = MatrixHelper(1, 0, 0, 1, 0, 0);
              currentLocation = Offset.zero;
              break;
            }
          case 'ET':
            {
              currentLocation = Offset.zero;
              if (isScaledText) {
                isScaledText = false;
                _graphicsObject!.restore(_graphicsState!.pop()!);
              }
              if (_textMatrix) {
                _graphicsObject!.restore(_graphicsState!.pop()!);
                _textMatrix = false;
              }
              if (_renderingMode == 2 &&
                  pdfRecordCollection.recordCollection.length > i + 1 &&
                  pdfRecordCollection.recordCollection[i + 1].operatorName !=
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
          case "'":
            {
              _moveToNextLineWithCurrentTextLeading();
              final MatrixHelper transformMatrix =
                  _getTextRenderingMatrix(false);
              objects.textMatrixUpdate = transformMatrix;
              if (_textScaling != 100) {
                final GraphicsState? state = _graphicsObject!.save();
                _graphicsState!.push(state);
                _graphicsObject!.scaleTransform(_textScaling! / 100, 1);
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
              if (i < pdfRecordCollection.count &&
                  pdfRecordCollection.recordCollection[i + 1].operatorName ==
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
              final MatrixHelper initialmatrix = documentMatrix!;
              final MatrixHelper currentCTM = MatrixHelper(
                  drawing2dMatrixCTM!.m11,
                  drawing2dMatrixCTM!.m12,
                  drawing2dMatrixCTM!.m21,
                  drawing2dMatrixCTM!.m22,
                  drawing2dMatrixCTM!.offsetX,
                  drawing2dMatrixCTM!.offsetY);
              final MatrixHelper result = currentCTM * initialmatrix;
              final MatrixHelper transformMatrix = MatrixHelper(
                  result.m11,
                  result.m12,
                  result.m21,
                  result.m22,
                  result.offsetX,
                  result.offsetY);
              MatrixHelper graphicsTransformMatrix =
                  MatrixHelper(1, 0, 0, 1, 0, 0);
              graphicsTransformMatrix =
                  graphicsTransformMatrix * transformMatrix;
              _graphicsObject!.transformMatrix =
                  MatrixHelper(1, 0, 0, 1, 0, 0) * transformMatrix;
              break;
            }
          case 'W':
          case 'W*':
            _graphicsObject!.transformMatrix = MatrixHelper(1, 0, 0, 1, 0, 0);
            break;
          default:
            break;
        }
      }
    }
  }

  MatrixHelper _getTextRenderingMatrix(bool isPath) {
    MatrixHelper mat = MatrixHelper(
        fontSize! * (objects.horizontalScaling! / 100),
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
      final FontStructure structure =
          _resources![currentFont!] as FontStructure;
      if (structure.isStandardFont) {
        structure.createStandardFont(fontSize!);
      } else if (structure.isStandardCJKFont) {
        structure.createStandardCJKFont(fontSize!);
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
    objects.horizontalScaling = double.tryParse(elements[0]);
  }

  void _getXObject(List<String> xobjectElement) {
    final String key = xobjectElement[0].replaceAll('/', '');
    if (_resources!.containsKey(key)) {
      final dynamic resource = _resources![key];
      if (resource is XObjectElement) {
        List<Glyph>? xObjectGlyphs;
        final XObjectElement xObjectElement = resource;
        xObjectElement.isExtractTextLine = isExtractLineCollection;
        if (selectablePrintDocument!) {
          xObjectElement.isPrintSelected = selectablePrintDocument;
          xObjectElement.pageHeight = pageHeight;
        }
        final Map<String, dynamic> result = xObjectElement.renderTextElement(
            _graphicsObject,
            _resources,
            _graphicsState,
            graphicsObjects,
            currentPageHeight,
            xObjectGlyphs);
        _graphicsState = result['graphicStates'] as GraphicStateCollection?;
        graphicsObjects = result['objects'] as GraphicObjectDataCollection?;
        xObjectGlyphs = result['glyphList'] as List<Glyph>?;
        final List<TextElement>? tempExtractTextElement =
            result['extractTextElement'] as List<TextElement>?;
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
    final List<dynamic> retrievedCharCodes = <dynamic>[];
    if (_resources!.containsKey(currentFont)) {
      final FontStructure structure =
          _resources![currentFont!] as FontStructure;
      structure.isSameFont = _resources!.isSameFont();
      structure.fontSize = fontSize;
      if (!structure.isEmbedded &&
          structure.font != null &&
          structure.isStandardCJKFont) {
        text = structure.fromUnicodeText(structure.getEncodedText(text, true));
      } else if (!structure.isEmbedded &&
          structure.font != null &&
          structure.isStandardFont) {
        text = structure.getEncodedText(text, true);
      } else {
        text = structure.decodeTextExtraction(
            text, _resources!.isSameFont(), retrievedCharCodes);
      }
      if (_actualText != null && _actualText!.isNotEmpty) {
        text = _actualText!;
        _actualText = null;
      }
      final TextElement element = TextElement(text, documentMatrix);
      element.fontStyle = structure.fontStyle!;
      element.fontName = structure.fontName!;
      element.fontSize = fontSize!;
      element.textScaling = _textScaling;
      element.fontEncoding = structure.fontEncoding;
      element.fontGlyphWidths = structure.fontGlyphWidths;
      element.defaultGlyphWidth = structure.defaultGlyphWidth;
      element.text = text;
      element.unicodeCharMapTable = structure.unicodeCharMapTable;
      final Map<int, int> glyphWidths = structure.fontGlyphWidths!;
      element.characterMapTable = structure.characterMapTable;
      element.reverseMapTable = structure.reverseMapTable;
      element.structure = structure;
      element.isEmbeddedFont = structure.isEmbedded;
      element.currentTransformationMatrix = currentTransformationMatrix;
      element.textLineMatrix = textMatrix;
      element.rise = objects.rise;
      element.transformMatrix = documentMatrix;
      element.documentMatrix = documentMatrix;
      element.fontId = currentFont;
      element.octDecMapTable = structure.octDecMapTable;
      element.textHorizontalScaling = objects.horizontalScaling;
      element.zapfPostScript = structure.zapfPostScript;
      element.lineWidth = objects.mitterLength;
      element.renderingMode = _renderingMode;
      element.pageRotation = pageRotation;
      element.zoomFactor = zoomFactor;
      element.substitutedFontsList = _substitutedFontsList;
      element.wordSpacing = objects.wordSpacing;
      element.characterSpacing = objects.characterSpacing;
      element.isExtractTextData = isExtractLineCollection;
      final MatrixHelper tempTextMatrix = MatrixHelper(0, 0, 0, 0, 0, 0);
      tempTextMatrix.type = MatrixTypes.identity;
      if (_isCurrentPositionChanged) {
        _isCurrentPositionChanged = false;
        _endTextPosition = currentLocation!;
        final Map<String, dynamic> renderedResult = element.renderTextElement(
            _graphicsObject,
            Offset(_endTextPosition.dx,
                _endTextPosition.dy + ((-textLeading!) / 4)),
            _textScaling,
            glyphWidths,
            structure.type1GlyphHeight,
            structure.differenceTable,
            structure.differencesDictionary,
            structure.differenceEncoding,
            tempTextMatrix,
            retrievedCharCodes);
        _textElementWidth = renderedResult['textElementWidth'] as double;
        textMatrix = renderedResult['tempTextMatrix'] as MatrixHelper;
      } else {
        _endTextPosition = Offset(
            _endTextPosition.dx + _textElementWidth, _endTextPosition.dy);
        final Map<String, dynamic> renderedResult = element.renderTextElement(
            _graphicsObject,
            Offset(
                _endTextPosition.dx, _endTextPosition.dy + (-textLeading! / 4)),
            _textScaling,
            glyphWidths,
            structure.type1GlyphHeight,
            structure.differenceTable,
            structure.differencesDictionary,
            structure.differenceEncoding,
            tempTextMatrix);
        _textElementWidth = renderedResult['textElementWidth'] as double;
        textMatrix = renderedResult['tempTextMatrix'] as MatrixHelper;
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
            if (_whiteSpace[0].text.isNotEmpty) {
              element.textElementGlyphList
                  .insert(0, _whiteSpace[0].textElementGlyphList[0]);
            }
            extractTextElement.add(_whiteSpace[0]);
          }
          _whiteSpace = <TextElement>[];
        }
        imageRenderGlyphList.addAll(element.textElementGlyphList);
        if (isExtractLineCollection) {
          extractTextElement.add(element);
        }
        _whiteSpace = <TextElement>[];
      } else {
        _whiteSpace.add(element);
      }
    }
  }

  void _renderTextElementWithSpacing(
      List<String> textElements, String tokenType) {
    List<String> decodedList = <String>[];
    Map<List<dynamic>, String> decodedListCollection =
        <List<dynamic>, String>{};
    final String text = textElements.join();
    if (_resources!.containsKey(currentFont)) {
      final FontStructure structure =
          _resources![currentFont!] as FontStructure;
      structure.isSameFont = _resources!.isSameFont();
      structure.fontSize = fontSize;
      List<double>? characterSpacings;
      if (!structure.isEmbedded &&
          structure.isStandardCJKFont &&
          structure.font != null) {
        decodedList =
            structure.decodeCjkTextExtractionTJ(text, _resources!.isSameFont());
        for (final String decodedString in decodedList) {
          decodedListCollection[<dynamic>[]] = decodedString;
        }
      } else {
        decodedListCollection =
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
      final TextElement element = TextElement(text, documentMatrix);
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
      element.rise = objects.rise;
      element.transformMatrix = documentMatrix;
      element.documentMatrix = documentMatrix;
      element.fontId = currentFont;
      element.octDecMapTable = structure.octDecMapTable;
      element.textHorizontalScaling = objects.horizontalScaling;
      element.zapfPostScript = structure.zapfPostScript;
      element.lineWidth = objects.mitterLength;
      element.renderingMode = _renderingMode;
      element.pageRotation = pageRotation;
      element.zoomFactor = zoomFactor;
      element.substitutedFontsList = _substitutedFontsList;
      element.isExtractTextData = isExtractLineCollection;
      if (structure.flags != null) {
        element.fontFlag = structure.flags!.value!.toInt();
      }
      element.wordSpacing = objects.wordSpacing;
      element.characterSpacing = objects.characterSpacing;
      final MatrixHelper tempTextMatrix = MatrixHelper(0, 0, 0, 0, 0, 0);
      tempTextMatrix.type = MatrixTypes.identity;
      if (_isCurrentPositionChanged) {
        _isCurrentPositionChanged = false;
        _endTextPosition = currentLocation!;
      } else {
        _endTextPosition = Offset(
            _endTextPosition.dx + _textElementWidth, _endTextPosition.dy);
      }
      final Map<String, dynamic> renderedResult = element.renderWithSpacing(
          _graphicsObject,
          Offset(_endTextPosition.dx, _endTextPosition.dy - fontSize!),
          decodedListCollection,
          characterSpacings,
          _textScaling,
          glyphWidths,
          structure.type1GlyphHeight,
          structure.differenceTable,
          structure.differencesDictionary,
          structure.differenceEncoding,
          tempTextMatrix);
      _textElementWidth = renderedResult['textElementWidth'] as double;
      textMatrix = renderedResult['tempTextMatrix'] as MatrixHelper;
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
          _whiteSpace = <TextElement>[];
        }
        imageRenderGlyphList.addAll(element.textElementGlyphList);
        if (isExtractLineCollection) {
          extractTextElement.add(element);
        }
        _whiteSpace = <TextElement>[];
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
    textMatrix = MatrixHelper(1, 0, 0, 1, tx, ty) * textLineMatrix!;
    textLineMatrix = textMatrix!.clone();
  }

  void _setTextMatrix(
      double a, double b, double c, double d, double e, double f) {
    textMatrix = MatrixHelper(a, b, c, d, e, f);
    textLineMatrix = textMatrix!.clone();
  }

  MatrixHelper _setMatrix(
      double a, double b, double c, double d, double e, double f) {
    currentTransformationMatrix = MatrixHelper(a, b, c, d, e, f) *
        graphicsObjects!.last.currentTransformationMatrix!;
    return MatrixHelper(
        currentTransformationMatrix!.m11,
        currentTransformationMatrix!.m12,
        currentTransformationMatrix!.m21,
        currentTransformationMatrix!.m22,
        currentTransformationMatrix!.offsetX,
        currentTransformationMatrix!.offsetY);
  }
}
