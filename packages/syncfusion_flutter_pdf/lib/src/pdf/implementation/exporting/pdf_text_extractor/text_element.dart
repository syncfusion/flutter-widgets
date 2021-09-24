part of pdf;

class _TextElement {
  //constructor
  _TextElement(String text, _MatrixHelper? transformMatrix) {
    _text = text;
    transformations = _TransformationStack(transformMatrix);
    _initialize();
  }

  //Fields
  late String _text;
  late _TransformationStack transformations;
  late List<_Glyph> textElementGlyphList;
  bool? isExtractTextData;
  late String fontName;
  late List<PdfFontStyle> fontStyle;
  double fontSize = 0;
  double? textScaling;
  double? characterSpacing;
  double? wordSpacing;
  int? renderingMode;
  Map<int, int>? encodedTextBytes;
  String? fontEncoding;
  Map<int, int>? fontGlyphWidths;
  double? defaultGlyphWidth;
  Map<int, String>? unicodeCharMapTable;
  Map<int, int>? cidToGidReverseMapTable;
  late Map<double, String> characterMapTable;
  Map<String, double>? reverseMapTable;
  late _FontStructure structure;
  late bool isEmbeddedFont;
  _MatrixHelper? currentTransformationMatrix;
  _MatrixHelper? textLineMatrix;
  _MatrixHelper? transformMatrix;
  int? _rise;
  _MatrixHelper? documentMatrix;
  String? fontId;
  Map<int, int>? octDecMapTable;
  double? textHorizontalScaling;
  String? zapfPostScript;
  double? lineWidth;
  double? pageRotation;
  double? zoomFactor;
  Map<String, String>? substitutedFontsList;
  PdfFont? font;
  String renderedText = '';
  int? fontFlag;
  late bool isTextGlyphAdded;
  double? currentGlyphWidth;
  late double charSizeMultiplier;
  List<int>? macRomanToUnicode;

  //Implementation
  void _initialize() {
    fontName = '';
    fontStyle = <PdfFontStyle>[];
    charSizeMultiplier = 0.001;
    currentGlyphWidth = 0;
    isTextGlyphAdded = false;
    textElementGlyphList = <_Glyph>[];
    isExtractTextData = false;
    textScaling = 100;
    textHorizontalScaling = 100;
    characterSpacing = 0;
    wordSpacing = 0;
    defaultGlyphWidth = 0;
    reverseMapTable = <String, double>{};
    isEmbeddedFont = false;
    documentMatrix = _MatrixHelper(0, 0, 0, 0, 0, 0);
    documentMatrix!.type = _MatrixTypes.identity;
    fontId = '';
    lineWidth = 0;
    pageRotation = 0;
    zoomFactor = 1;
    substitutedFontsList = <String, String>{};
    fontFlag = 0;
    macRomanToUnicode = <int>[
      196,
      197,
      199,
      201,
      209,
      214,
      220,
      225,
      224,
      226,
      228,
      227,
      229,
      231,
      233,
      232,
      234,
      235,
      237,
      236,
      238,
      239,
      241,
      243,
      242,
      244,
      246,
      245,
      250,
      249,
      251,
      252,
      8224,
      176,
      162,
      163,
      167,
      8226,
      182,
      223,
      174,
      169,
      8482,
      180,
      168,
      8800,
      198,
      216,
      8734,
      177,
      8804,
      8805,
      165,
      181,
      8706,
      8721,
      8719,
      960,
      8747,
      170,
      186,
      937,
      230,
      248,
      191,
      161,
      172,
      8730,
      402,
      8776,
      8710,
      171,
      187,
      8230,
      160,
      192,
      195,
      213,
      338,
      339,
      8211,
      8212,
      8220,
      8221,
      8216,
      8217,
      247,
      9674,
      255,
      376,
      8260,
      8364,
      8249,
      8250,
      64257,
      64258,
      8225,
      183,
      8218,
      8222,
      8240,
      194,
      202,
      193,
      203,
      200,
      205,
      206,
      207,
      204,
      211,
      212,
      63743,
      210,
      218,
      219,
      217,
      305,
      710,
      732,
      175,
      728,
      729,
      730,
      184,
      733,
      731,
      711
    ];
  }

  _MatrixHelper _getTextRenderingMatrix() {
    return _MatrixHelper(fontSize * (textHorizontalScaling! / 100), 0, 0,
            -fontSize, 0, fontSize + _rise!) *
        textLineMatrix! *
        currentTransformationMatrix!;
  }

  Map<String, dynamic> _render(
      _GraphicsObject? g,
      Offset currentLocation,
      double? textScaling,
      Map<int, int>? glyphWidths,
      double? type1Height,
      Map<int, String> differenceTable,
      Map<String, String?> differenceMappedTable,
      Map<int, String>? differenceEncoding,
      _MatrixHelper? txtMatrix) {
    txtMatrix = _MatrixHelper(0, 0, 0, 0, 0, 0);
    txtMatrix.type = _MatrixTypes.identity;
    double changeInX = currentLocation.dx.toDouble();
    Offset location = Offset(currentLocation.dx, currentLocation.dy);
    if (!isEmbeddedFont &&
        (structure._isStandardFont || structure._isStandardCJKFont) &&
        structure.font != null) {
      final _MatrixHelper defaultTransformations =
          g!._transformMatrix!._clone();
      for (int i = 0; i < _text.length; i++) {
        final String character = _text[i];
        g._transformMatrix = _MatrixHelper(1, 0, 0, 1, 0, 0);
        final _Glyph glyph = _Glyph();
        glyph.fontSize = fontSize;
        glyph.fontFamily = fontName;
        glyph.fontStyle = fontStyle;
        glyph.transformMatrix = _getTextRenderingMatrix();
        glyph.name = character;
        glyph.horizontalScaling = textHorizontalScaling!;
        glyph.charId = character.codeUnitAt(0);
        glyph.toUnicode = character;
        glyph.charSpacing = characterSpacing!;
        if (structure._isStandardFont) {
          final PdfStandardFont font = structure.font! as PdfStandardFont;
          glyph.width = font._getCharWidthInternal(character) *
              PdfFont._characterSizeMultiplier;
        } else if (structure._isStandardCJKFont) {
          final PdfCjkStandardFont font = structure.font! as PdfCjkStandardFont;
          glyph.width = font._getCharWidthInternal(character) *
              PdfFont._characterSizeMultiplier;
        }
        final _MatrixHelper identity = _MatrixHelper.identity._clone();
        identity._scale(0.01, 0.01, 0.0, 0.0);
        identity._translate(0.0, 1.0);
        transformations._pushTransform(identity * glyph.transformMatrix);
        final _MatrixHelper transform = g._transformMatrix!;
        _MatrixHelper matrix = transform._clone();
        matrix = matrix * transformations.currentTransform!._clone();
        g._transformMatrix = matrix;
        double? tempFontSize = 0;
        if (glyph.transformMatrix.m11 > 0) {
          tempFontSize = glyph.transformMatrix.m11;
        } else if (glyph.transformMatrix.m12 != 0 &&
            glyph.transformMatrix.m21 != 0) {
          if (glyph.transformMatrix.m12 < 0) {
            tempFontSize = -glyph.transformMatrix.m12;
          } else {
            tempFontSize = glyph.transformMatrix.m12;
          }
        } else {
          tempFontSize = glyph.fontSize;
        }
        glyph.boundingRect = Rect.fromLTWH(
            (matrix.offsetX / 1.3333333333333333) / zoomFactor!,
            ((matrix.offsetY - (tempFontSize * zoomFactor!)) /
                    1.3333333333333333) /
                zoomFactor!,
            glyph.width * tempFontSize,
            tempFontSize);
        textElementGlyphList.add(glyph);
        _updateTextMatrix(glyph);
        transformations._popTransform();
        renderedText += character;
      }
      g._transformMatrix = defaultTransformations;
      txtMatrix = textLineMatrix;
    } else {
      int letterCount = 0;
      for (int i = 0; i < _text.length; i++) {
        final String letter = _text[i];
        letterCount += 1;
        final int charCode = letter.codeUnitAt(0);
        isTextGlyphAdded = false;
        if (charCode.toUnsigned(8) > 126 &&
            fontEncoding == 'MacRomanEncoding' &&
            !isEmbeddedFont) {
          isTextGlyphAdded = true;
          final _MatrixHelper? tempMatrix =
              drawSystemFontGlyphShape(letter, g!, txtMatrix);
          if (tempMatrix != null) {
            txtMatrix = tempMatrix;
          } else {
            isTextGlyphAdded = false;
          }
        } else {
          if (renderingMode == 1) {
            isTextGlyphAdded = true;
            final _MatrixHelper? tempMatrix =
                drawSystemFontGlyphShape(letter, g!, txtMatrix);
            if (tempMatrix != null) {
              txtMatrix = tempMatrix;
            } else {
              isTextGlyphAdded = false;
            }
          } else if (reverseMapTable!.isNotEmpty &&
              reverseMapTable!.containsKey(letter)) {
            final int tempCharCode = reverseMapTable![letter]!.toInt();
            if (fontGlyphWidths != null) {
              currentGlyphWidth = (fontGlyphWidths!.containsKey(tempCharCode)
                      ? fontGlyphWidths![tempCharCode]
                      : defaultGlyphWidth)! *
                  charSizeMultiplier;
            } else {
              currentGlyphWidth = defaultGlyphWidth! * charSizeMultiplier;
            }
            txtMatrix = drawGlyphs(currentGlyphWidth, g!, txtMatrix, letter);
            isTextGlyphAdded = true;
          } else {
            if (characterMapTable.isNotEmpty &&
                characterMapTable.containsKey(charCode)) {
              final String tempLetter = characterMapTable[charCode]![0];
              isTextGlyphAdded = true;
              final _MatrixHelper? tempMatrix =
                  drawSystemFontGlyphShape(tempLetter, g!, txtMatrix);
              if (tempMatrix != null) {
                txtMatrix = tempMatrix;
              } else {
                isTextGlyphAdded = false;
              }
            }
          }
          if (!isTextGlyphAdded) {
            if (characterMapTable.isNotEmpty &&
                characterMapTable.containsKey(charCode)) {
              final String unicode = characterMapTable[charCode]![0];
              if (fontGlyphWidths == null) {
                currentGlyphWidth = defaultGlyphWidth! * charSizeMultiplier;
              } else {
                if (structure.fontType!._name == 'Type0') {
                  if (cidToGidReverseMapTable != null &&
                      cidToGidReverseMapTable!.containsKey(charCode) &&
                      !structure.isMappingDone) {
                    currentGlyphWidth =
                        fontGlyphWidths![cidToGidReverseMapTable![charCode]!]! *
                            charSizeMultiplier;
                  } else if (fontGlyphWidths!.containsKey(charCode)) {
                    currentGlyphWidth =
                        fontGlyphWidths![charCode]! * charSizeMultiplier;
                  } else {
                    if (reverseMapTable!.containsKey(unicode) &&
                        !fontGlyphWidths!
                            .containsKey(reverseMapTable![unicode]!.toInt())) {
                      currentGlyphWidth =
                          defaultGlyphWidth! * charSizeMultiplier;
                    }
                  }
                } else if (structure.fontType!._name == 'TrueType' &&
                    fontGlyphWidths!.containsKey(charCode)) {
                  currentGlyphWidth =
                      fontGlyphWidths![charCode]! * charSizeMultiplier;
                }
              }
            } else if (cidToGidReverseMapTable != null &&
                cidToGidReverseMapTable!.isNotEmpty) {
              if (cidToGidReverseMapTable!.containsKey(charCode)) {
                final int? cidGidKey = cidToGidReverseMapTable![charCode];
                if (fontGlyphWidths != null &&
                    fontGlyphWidths!.containsKey(cidGidKey)) {
                  currentGlyphWidth =
                      fontGlyphWidths![cidGidKey!]! * charSizeMultiplier;
                }
              }
            } else if (fontGlyphWidths != null) {
              currentGlyphWidth = (fontGlyphWidths!.containsKey(charCode)
                      ? fontGlyphWidths![charCode]
                      : defaultGlyphWidth)! *
                  charSizeMultiplier;
            }
          }
        }
        if (letterCount < _text.length) {
          location = Offset(location.dx + characterSpacing!, location.dy);
        }
        if (!isTextGlyphAdded) {
          txtMatrix = drawGlyphs(currentGlyphWidth, g!, txtMatrix, letter);
        }
      }
    }
    changeInX = location.dx - changeInX;
    return <String, dynamic>{
      'textElementWidth': changeInX,
      'tempTextMatrix': txtMatrix
    };
  }

  Map<String, dynamic> _renderWithSpacing(
      _GraphicsObject? g,
      Offset currentLocation,
      List<String> decodedList,
      List<double>? characterSpacing,
      double? textScaling,
      Map<int, int>? glyphWidths,
      double? type1Height,
      Map<int, String> differenceTable,
      Map<String, String?> differenceMappedTable,
      Map<int, String>? differenceEncoding,
      _MatrixHelper? txtMatrix) {
    txtMatrix = _MatrixHelper(0, 0, 0, 0, 0, 0);
    txtMatrix.type = _MatrixTypes.identity;
    double changeInX = currentLocation.dx.toDouble();
    Offset location = Offset(currentLocation.dx, currentLocation.dy);
    // ignore: avoid_function_literals_in_foreach_calls
    decodedList.forEach((String word) {
      final double? space = double.tryParse(word);
      if (space != null) {
        _updateTextMatrixWithSpacing(space);
      } else {
        if (!isEmbeddedFont &&
            structure.font != null &&
            (structure._isStandardFont || structure._isStandardCJKFont)) {
          final _MatrixHelper defaultTransformations =
              g!._transformMatrix!._clone();
          if (word != '' && word[word.length - 1] == 's') {
            word = word.substring(0, word.length - 1);
          }
          for (int i = 0; i < word.length; i++) {
            final String character = word[i];
            g._transformMatrix = _MatrixHelper(1, 0, 0, 1, 0, 0);
            final _Glyph glyph = _Glyph();
            glyph.fontSize = fontSize;
            glyph.fontFamily = fontName;
            glyph.fontStyle = fontStyle;
            glyph.transformMatrix = _getTextRenderingMatrix();
            glyph.name = character;
            glyph.horizontalScaling = textHorizontalScaling!;
            glyph.charId = character.codeUnitAt(0);
            glyph.toUnicode = character;
            glyph.charSpacing = this.characterSpacing!;
            if (structure._isStandardFont) {
              final PdfStandardFont font = structure.font! as PdfStandardFont;
              glyph.width = font._getCharWidthInternal(character) *
                  PdfFont._characterSizeMultiplier;
            } else if (structure._isStandardCJKFont) {
              final PdfCjkStandardFont font =
                  structure.font! as PdfCjkStandardFont;
              glyph.width = font._getCharWidthInternal(character) *
                  PdfFont._characterSizeMultiplier;
            }
            final _MatrixHelper identity = _MatrixHelper.identity._clone();
            identity._scale(0.01, 0.01, 0.0, 0.0);
            identity._translate(0.0, 1.0);
            transformations._pushTransform(identity * glyph.transformMatrix);
            final _MatrixHelper transform = g._transformMatrix!;
            _MatrixHelper matrix = transform._clone();
            matrix = matrix * transformations.currentTransform!._clone();
            g._transformMatrix = matrix;
            double? tempFontSize = 0;
            if (glyph.transformMatrix.m11 > 0) {
              tempFontSize = glyph.transformMatrix.m11;
            } else if (glyph.transformMatrix.m12 != 0 &&
                glyph.transformMatrix.m21 != 0) {
              if (glyph.transformMatrix.m12 < 0) {
                tempFontSize = -glyph.transformMatrix.m12;
              } else {
                tempFontSize = glyph.transformMatrix.m12;
              }
            } else {
              tempFontSize = glyph.fontSize;
            }
            glyph.boundingRect = Rect.fromLTWH(
                (matrix.offsetX / 1.3333333333333333) / zoomFactor!,
                ((matrix.offsetY - (tempFontSize * zoomFactor!)) /
                        1.3333333333333333) /
                    zoomFactor!,
                glyph.width * tempFontSize,
                tempFontSize);
            textElementGlyphList.add(glyph);
            _updateTextMatrix(glyph);
            transformations._popTransform();
            renderedText += character;
          }
          g._transformMatrix = defaultTransformations;
          txtMatrix = textLineMatrix;
        } else {
          if (word != '' && word[word.length - 1] == 's') {
            word = word.substring(0, word.length - 1);
          }
          if (word != '') {
            int letterCount = 0;
            bool isComplexScript = false;
            if (reverseMapTable!.isNotEmpty &&
                reverseMapTable!.containsKey(word)) {
              final int charCode = reverseMapTable![word]!.toInt();
              if (characterMapTable.isNotEmpty &&
                  characterMapTable.containsKey(charCode)) {
                final String tempLetter = characterMapTable[charCode]!;
                isTextGlyphAdded = true;
                isComplexScript = true;
                final _MatrixHelper? tempMatrix =
                    drawSystemFontGlyphShape(tempLetter, g!, txtMatrix);
                if (tempMatrix != null) {
                  txtMatrix = tempMatrix;
                } else {
                  isTextGlyphAdded = false;
                  isComplexScript = false;
                }
              }
            }
            if (!isComplexScript) {
              for (int i = 0; i < word.length; i++) {
                final String letter = word[i];
                letterCount += 1;
                int charCode = letter.codeUnitAt(0);
                isTextGlyphAdded = false;
                if (charCode.toUnsigned(8) > 126 &&
                    fontEncoding == 'MacRomanEncoding' &&
                    !isEmbeddedFont) {
                  isTextGlyphAdded = true;
                  final _MatrixHelper? tempMatrix =
                      drawSystemFontGlyphShape(letter, g!, txtMatrix);
                  if (tempMatrix != null) {
                    txtMatrix = tempMatrix;
                  } else {
                    isTextGlyphAdded = false;
                  }
                } else {
                  if (renderingMode == 1) {
                    isTextGlyphAdded = true;
                    final _MatrixHelper? tempMatrix =
                        drawSystemFontGlyphShape(letter, g!, txtMatrix);
                    if (tempMatrix != null) {
                      txtMatrix = tempMatrix;
                    } else {
                      isTextGlyphAdded = false;
                    }
                  } else {
                    if (reverseMapTable!.isNotEmpty &&
                        reverseMapTable!.containsKey(letter)) {
                      charCode = reverseMapTable![letter]!.toInt();
                    }
                    if (characterMapTable.isNotEmpty &&
                        characterMapTable.containsKey(charCode)) {
                      final String tempLetter = characterMapTable[charCode]![0];
                      isTextGlyphAdded = true;
                      final _MatrixHelper? tempMatrix =
                          drawSystemFontGlyphShape(tempLetter, g!, txtMatrix);
                      if (tempMatrix != null) {
                        txtMatrix = tempMatrix;
                      } else {
                        isTextGlyphAdded = false;
                      }
                    }
                  }
                  if (characterMapTable.isNotEmpty &&
                      characterMapTable.containsKey(charCode)) {
                    final String unicode = characterMapTable[charCode]![0];
                    if (fontGlyphWidths == null) {
                      currentGlyphWidth =
                          defaultGlyphWidth! * charSizeMultiplier;
                    } else {
                      if (structure.fontType!._name == 'Type0') {
                        if (cidToGidReverseMapTable != null &&
                            cidToGidReverseMapTable!.containsKey(charCode) &&
                            !structure.isMappingDone) {
                          currentGlyphWidth = fontGlyphWidths![
                                  cidToGidReverseMapTable![charCode]!]! *
                              charSizeMultiplier;
                        } else if (fontGlyphWidths!.containsKey(charCode)) {
                          currentGlyphWidth =
                              fontGlyphWidths![charCode]! * charSizeMultiplier;
                        } else {
                          if (reverseMapTable!.containsKey(unicode) &&
                              !fontGlyphWidths!.containsKey(
                                  reverseMapTable![unicode]!.toInt())) {
                            currentGlyphWidth =
                                defaultGlyphWidth! * charSizeMultiplier;
                          }
                        }
                      } else if (structure.fontType!._name == 'TrueType' &&
                          fontGlyphWidths!.containsKey(charCode)) {
                        currentGlyphWidth =
                            fontGlyphWidths![charCode]! * charSizeMultiplier;
                      }
                    }
                  } else if (cidToGidReverseMapTable != null &&
                      cidToGidReverseMapTable!.isNotEmpty) {
                    if (cidToGidReverseMapTable!.containsKey(charCode)) {
                      final int? cidGidKey = cidToGidReverseMapTable![charCode];
                      if (fontGlyphWidths != null &&
                          fontGlyphWidths!.containsKey(cidGidKey)) {
                        currentGlyphWidth =
                            fontGlyphWidths![cidGidKey!]! * charSizeMultiplier;
                      }
                    }
                  } else if (fontGlyphWidths != null) {
                    currentGlyphWidth = (fontGlyphWidths!.containsKey(charCode)
                            ? fontGlyphWidths![charCode]
                            : defaultGlyphWidth)! *
                        charSizeMultiplier;
                  }
                }
                if (letterCount < word.length) {
                  location =
                      Offset(location.dx + this.characterSpacing!, location.dy);
                }
                if (!isTextGlyphAdded) {
                  txtMatrix =
                      drawGlyphs(currentGlyphWidth, g!, txtMatrix, letter);
                }
              }
            }
          }
        }
      }
    });
    changeInX = location.dx - changeInX;
    return <String, dynamic>{
      'textElementWidth': changeInX,
      'tempTextMatrix': txtMatrix
    };
  }

  _MatrixHelper? drawGlyphs(double? glyphwidth, _GraphicsObject g,
      _MatrixHelper? temptextmatrix, String? glyphChar) {
    final _MatrixHelper defaultTransformations = g._transformMatrix!._clone();
    g._transformMatrix = _MatrixHelper(1, 0, 0, 1, 0, 0);
    final _Glyph glyph = _Glyph();
    glyph.fontSize = fontSize;
    glyph.fontFamily = fontName;
    glyph.fontStyle = fontStyle;
    glyph.transformMatrix = _getTextRenderingMatrix();
    glyph.horizontalScaling = textHorizontalScaling!;
    glyph.width = glyphwidth!;
    glyph.charSpacing = characterSpacing!;
    if (glyphChar == ' ') {
      glyph.wordSpacing = wordSpacing!;
    }
    final _MatrixHelper identity = _MatrixHelper(1, 0, 0, 1, 0, 0);
    identity._scale(0.01, 0.01, 0.0, 0.0);
    identity._translate(0.0, 1.0);
    transformations._pushTransform(identity * glyph.transformMatrix);
    final _MatrixHelper transform = g._transformMatrix!;
    _MatrixHelper matrix = transform._clone();
    matrix *= transformations.currentTransform!._clone();
    g._transformMatrix = matrix;
    if (!structure.isMappingDone) {
      if (cidToGidReverseMapTable != null &&
          cidToGidReverseMapTable!.containsKey(glyphChar!.codeUnitAt(0)) &&
          (structure.characterMapTable.isNotEmpty)) {
        glyphChar = characterMapTable[
            cidToGidReverseMapTable![glyphChar.codeUnitAt(0)]];
      } else if (structure.characterMapTable.isNotEmpty) {
        glyphChar = structure.mapCharactersFromTable(glyphChar!);
      } else if (structure.differencesDictionary.isNotEmpty) {
        glyphChar = structure.mapDifferences(glyphChar);
      } else if (structure.cidToGidReverseMapTable
          .containsKey(glyphChar!.codeUnitAt(0))) {
        glyphChar = String.fromCharCode(
            structure.cidToGidReverseMapTable[glyphChar.codeUnitAt(0)]!);
      }
      if (glyphChar!.contains('\u0092')) {
        glyphChar = glyphChar.replaceAll('\u0092', '’');
      }
    }
    double? tempFontSize;
    if (glyph.transformMatrix.m11 > 0) {
      tempFontSize = glyph.transformMatrix.m11;
    } else if (glyph.transformMatrix.m12 != 0 &&
        glyph.transformMatrix.m21 != 0) {
      tempFontSize = glyph.transformMatrix.m12 < 0
          ? -glyph.transformMatrix.m12
          : glyph.transformMatrix.m12;
    } else {
      tempFontSize = glyph.fontSize;
    }
    glyph.toUnicode = glyphChar!;
    if (matrix.m12 != 0 && matrix.m21 != 0) {
      glyph.isRotated = true;
      if (matrix.m12 < 0 && matrix.m21 > 0) {
        glyph.rotationAngle = 270;
      } else if (matrix.m12 > 0 && matrix.m21 < 0) {
        glyph.rotationAngle = 90;
      } else if (matrix.m12 < 0 && matrix.m21 < 0) {
        glyph.rotationAngle = 180;
      }
      glyph.boundingRect = Rect.fromLTWH(
          ((matrix.offsetX +
                      ((tempFontSize + (glyph.ascent / 1000.0)) * matrix.m21)) /
                  1.3333333333333333) /
              zoomFactor!,
          (((matrix.offsetY - (tempFontSize * matrix.m21)) /
                      1.3333333333333333) -
                  (tempFontSize * zoomFactor! / 1.3333333333333333)) /
              zoomFactor!,
          glyph.width * tempFontSize,
          tempFontSize);
    } else {
      glyph.boundingRect = Rect.fromLTWH(
          (matrix.offsetX / 1.3333333333333333) / zoomFactor!,
          ((matrix.offsetY - (tempFontSize * zoomFactor!)) /
                  1.3333333333333333) /
              zoomFactor!,
          glyph.width * tempFontSize,
          tempFontSize);
    }
    if (glyph.toUnicode.length != 1) {
      textElementGlyphList.add(glyph);
      for (int i = 0; i < glyph.toUnicode.length - 1; i++) {
        final _Glyph emptyGlyph = _Glyph();
        textElementGlyphList.add(emptyGlyph);
      }
    } else {
      textElementGlyphList.add(glyph);
    }
    _updateTextMatrix(glyph);
    transformations._popTransform();
    g._transformMatrix = defaultTransformations;
    temptextmatrix = textLineMatrix;
    renderedText += glyphChar;
    return temptextmatrix;
  }

  _MatrixHelper? drawSystemFontGlyphShape(
      String letter, _GraphicsObject g, _MatrixHelper? temptextmatrix) {
    final _MatrixHelper? defaultTransformations = g._transformMatrix;
    g._transformMatrix = _MatrixHelper(1, 0, 0, 1, 0, 0);
    final _Glyph gly = _Glyph();
    gly.horizontalScaling = textHorizontalScaling!;
    gly.charSpacing = characterSpacing!;
    gly.fontSize = fontSize;
    gly.name = letter;
    gly.charId = letter.codeUnitAt(0).toUnsigned(8).toInt();
    gly.transformMatrix = _getTextRenderingMatrix();
    if (letter == ' ') {
      gly.wordSpacing = wordSpacing!;
    }
    double? systemFontGlyph;
    if (fontGlyphWidths != null && fontGlyphWidths!.isNotEmpty) {
      if (reverseMapTable != null && reverseMapTable!.containsKey(letter)) {
        final int charCode = reverseMapTable![letter]!.toInt();
        if (fontGlyphWidths!.containsKey(charCode)) {
          systemFontGlyph = fontGlyphWidths![charCode]! * charSizeMultiplier;
        } else {
          return null;
        }
      } else if (fontGlyphWidths!.containsKey(letter.codeUnitAt(0))) {
        systemFontGlyph =
            fontGlyphWidths![letter.codeUnitAt(0)]! * charSizeMultiplier;
      }
    }
    gly.width = (systemFontGlyph == null) ? 0 : systemFontGlyph;
    final _MatrixHelper identity = _MatrixHelper(1, 0, 0, 1, 0, 0);
    identity._scale(0.01, 0.01, 0.0, 0.0);
    identity._translate(0.0, 1.0);
    transformations._pushTransform(identity * gly.transformMatrix);
    final _MatrixHelper transform = g._transformMatrix!;
    _MatrixHelper matrix = transform._clone();
    matrix = matrix * transformations.currentTransform!._clone();
    g._transformMatrix = matrix;
    double? tempFontSize = 0;
    if (gly.transformMatrix.m11 > 0) {
      tempFontSize = gly.transformMatrix.m11;
    } else if (gly.transformMatrix.m12 != 0 && gly.transformMatrix.m21 != 0) {
      tempFontSize = gly.transformMatrix.m12 < 0
          ? -gly.transformMatrix.m12
          : gly.transformMatrix.m12;
    } else {
      tempFontSize = gly.fontSize;
    }
    String? glyphName = letter;
    if (!structure.isMappingDone) {
      if (cidToGidReverseMapTable != null &&
          cidToGidReverseMapTable!.containsKey(glyphName.codeUnitAt(0)) &&
          (structure.characterMapTable.isNotEmpty)) {
        glyphName = characterMapTable[
            cidToGidReverseMapTable![glyphName.codeUnitAt(0)]];
      } else if (structure.characterMapTable.isNotEmpty) {
        glyphName = structure.mapCharactersFromTable(glyphName);
      } else if (structure.differencesDictionary.isNotEmpty) {
        glyphName = structure.mapDifferences(glyphName);
      } else if (structure.cidToGidReverseMapTable
          .containsKey(glyphName.codeUnitAt(0))) {
        glyphName = String.fromCharCode(
            structure.cidToGidReverseMapTable[glyphName.codeUnitAt(0)]!);
      }
      if (glyphName!.contains('\u0092')) {
        glyphName = glyphName.replaceAll('\u0092', '’');
      }
    }
    gly.toUnicode = glyphName;
    gly.boundingRect = Rect.fromLTWH(
        (matrix.offsetX / 1.3333333333333333) / zoomFactor!,
        ((matrix.offsetY - (tempFontSize * zoomFactor!)) / 1.3333333333333333) /
            zoomFactor!,
        gly.width * tempFontSize,
        tempFontSize);
    textElementGlyphList.add(gly);
    _updateTextMatrix(gly);
    transformations._popTransform();
    g._transformMatrix = defaultTransformations;
    temptextmatrix = textLineMatrix;
    renderedText += glyphName;
    return temptextmatrix;
  }

  void _updateTextMatrixWithSpacing(double space) {
    final double x = -(space * 0.001 * fontSize * textHorizontalScaling! / 100);
    final Offset point = textLineMatrix!._transform(const Offset(0.0, 0.0));
    final Offset point2 = textLineMatrix!._transform(Offset(x, 0.0));
    if (point.dx != point2.dx) {
      textLineMatrix!.offsetX = point2.dx;
    } else {
      textLineMatrix!.offsetY = point2.dy;
    }
  }

  void _updateTextMatrix(_Glyph glyph) {
    textLineMatrix = _calculateTextMatrix(textLineMatrix!, glyph);
  }

  _MatrixHelper _calculateTextMatrix(_MatrixHelper m, _Glyph glyph) {
    if (glyph.charId == 32) {
      glyph.wordSpacing = wordSpacing!;
    }
    final double width = glyph.width;
    final double offsetX =
        (width * glyph.fontSize + glyph.charSpacing + glyph.wordSpacing) *
            (glyph.horizontalScaling / 100);
    return _MatrixHelper(1.0, 0.0, 0.0, 1.0, offsetX, 0.0) * m;
  }
}

class _TransformationStack {
  _TransformationStack([_MatrixHelper? transformMatrix]) {
    _initialTransform = (transformMatrix != null)
        ? transformMatrix
        : _MatrixHelper(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
    transformStack = Queue<_MatrixHelper>();
  }

  //Fields
  late _MatrixHelper _currentTransform;
  _MatrixHelper? _initialTransform;
  late Queue<_MatrixHelper> transformStack;

  //Properties
  _MatrixHelper? get currentTransform {
    if (transformStack.isEmpty) {
      return _initialTransform;
    }
    return _currentTransform * _initialTransform!;
  }

  //Implementation
  void _pushTransform(_MatrixHelper transformMatrix) {
    transformStack.addLast(transformMatrix);
    _MatrixHelper matrix = _MatrixHelper.identity._clone();
    for (final _MatrixHelper current in transformStack) {
      matrix *= current;
    }
    _currentTransform = matrix;
  }

  void _popTransform() {
    transformStack.removeLast();
    _MatrixHelper matrix = _MatrixHelper.identity._clone();
    for (final _MatrixHelper current in transformStack) {
      matrix *= current;
    }
    _currentTransform = matrix;
  }
}
