import 'dart:collection';
import 'dart:ui';

import 'package:intl/intl.dart' as bidi;

import '../../graphics/fonts/enums.dart';
import '../../graphics/fonts/pdf_cjk_standard_font.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/fonts/pdf_standard_font.dart';
import 'font_structure.dart';
import 'glyph.dart';
import 'graphic_object_data.dart';
import 'matrix_helper.dart';

/// internal class
class TextElement {
  //constructor
  /// internal constructor
  TextElement(this.text, MatrixHelper? transformMatrix) {
    transformations = _TransformationStack(transformMatrix);
    _initialize();
  }

  //Fields
  /// internal field
  late String text;

  /// internal field
  late _TransformationStack transformations;

  /// internal field
  late List<Glyph> textElementGlyphList;

  /// internal field
  late bool isExtractTextData;

  /// internal field
  late String fontName;

  /// internal field
  late List<PdfFontStyle> fontStyle;

  /// internal field
  double fontSize = 0;

  /// internal field
  double? textScaling;

  /// internal field
  double? characterSpacing;

  /// internal field
  double? wordSpacing;

  /// internal field
  int? renderingMode;

  /// internal field
  Map<int, int>? encodedTextBytes;

  /// internal field
  String? fontEncoding;

  /// internal field
  Map<int, int>? fontGlyphWidths;

  /// internal field
  double? defaultGlyphWidth;

  /// internal field
  Map<int, String>? unicodeCharMapTable;

  /// internal field
  Map<int, int>? cidToGidReverseMapTable;

  /// internal field
  late Map<double, String> characterMapTable;

  /// internal field
  Map<String, double>? reverseMapTable;

  /// internal field
  late FontStructure structure;

  /// internal field
  late bool isEmbeddedFont;

  /// internal field
  MatrixHelper? currentTransformationMatrix;

  /// internal field
  MatrixHelper? textLineMatrix;

  /// internal field
  MatrixHelper? transformMatrix;

  /// internal field
  int? rise;

  /// internal field
  MatrixHelper? documentMatrix;

  /// internal field
  String? fontId;

  /// internal field
  Map<int, int>? octDecMapTable;

  /// internal field
  double? textHorizontalScaling;

  /// internal field
  String? zapfPostScript;

  /// internal field
  double? lineWidth;

  /// internal field
  double? pageRotation;

  /// internal field
  double? zoomFactor;

  /// internal field
  Map<String, String>? substitutedFontsList;

  /// internal field
  PdfFont? font;

  /// internal field
  String renderedText = '';

  /// internal field
  int? fontFlag;

  /// internal field
  late bool isTextGlyphAdded;

  /// internal field
  double? currentGlyphWidth;

  /// internal field
  late double charSizeMultiplier;

  /// internal field
  List<int>? macRomanToUnicode;

  //Implementation
  void _initialize() {
    fontName = '';
    fontStyle = <PdfFontStyle>[];
    charSizeMultiplier = 0.001;
    currentGlyphWidth = 0;
    isTextGlyphAdded = false;
    textElementGlyphList = <Glyph>[];
    isExtractTextData = false;
    textScaling = 100;
    textHorizontalScaling = 100;
    characterSpacing = 0;
    wordSpacing = 0;
    defaultGlyphWidth = 0;
    reverseMapTable = <String, double>{};
    isEmbeddedFont = false;
    documentMatrix = MatrixHelper(0, 0, 0, 0, 0, 0);
    documentMatrix!.type = MatrixTypes.identity;
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

  MatrixHelper _getTextRenderingMatrix() {
    return MatrixHelper(fontSize * (textHorizontalScaling! / 100), 0, 0,
            -fontSize, 0, fontSize + rise!) *
        textLineMatrix! *
        currentTransformationMatrix!;
  }

  /// internal method
  Map<String, dynamic> renderTextElement(
      GraphicsObject? g,
      Offset currentLocation,
      double? textScaling,
      Map<int, int>? glyphWidths,
      double? type1Height,
      Map<int, String> differenceTable,
      Map<String, String?> differenceMappedTable,
      Map<int, String>? differenceEncoding,
      MatrixHelper? txtMatrix,
      [List<dynamic>? retrievedCharCodes]) {
    txtMatrix = MatrixHelper(0, 0, 0, 0, 0, 0);
    txtMatrix.type = MatrixTypes.identity;
    double changeInX = currentLocation.dx;
    Offset location = Offset(currentLocation.dx, currentLocation.dy);
    if (!isEmbeddedFont &&
        (structure.isStandardFont || structure.isStandardCJKFont) &&
        structure.font != null) {
      final MatrixHelper defaultTransformations = g!.transformMatrix!.clone();
      for (int i = 0; i < text.length; i++) {
        final String character = text[i];
        g.transformMatrix = MatrixHelper(1, 0, 0, 1, 0, 0);
        final Glyph glyph = Glyph();
        glyph.fontSize = fontSize;
        glyph.fontFamily = fontName;
        glyph.fontStyle = fontStyle;
        glyph.transformMatrix = _getTextRenderingMatrix();
        glyph.name = character;
        glyph.horizontalScaling = textHorizontalScaling!;
        glyph.charId = character.codeUnitAt(0);
        glyph.toUnicode = character;
        glyph.charSpacing = characterSpacing!;
        if (structure.isStandardFont) {
          final PdfStandardFont font = structure.font! as PdfStandardFont;
          glyph.width = PdfStandardFontHelper.getHelper(font)
                  .getCharWidthInternal(character) *
              PdfFontHelper.characterSizeMultiplier;
        } else if (structure.isStandardCJKFont) {
          final PdfCjkStandardFont font = structure.font! as PdfCjkStandardFont;
          glyph.width = PdfCjkStandardFontHelper.getHelper(font)
                  .getCharWidthInternal(character) *
              PdfFontHelper.characterSizeMultiplier;
        }
        final MatrixHelper identity = MatrixHelper.identity.clone();
        identity.scale(0.01, 0.01, 0.0, 0.0);
        identity.translate(0.0, 1.0);
        transformations._pushTransform(identity * glyph.transformMatrix);
        final MatrixHelper transform = g.transformMatrix!;
        MatrixHelper matrix = transform.clone();
        matrix = matrix * transformations.currentTransform!.clone();
        g.transformMatrix = matrix;
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
        if (tempFontSize.toInt() == 0) {
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
      g.transformMatrix = defaultTransformations;
      txtMatrix = textLineMatrix;
    } else {
      int letterCount = 0;
      if ((retrievedCharCodes != null &&
              text.length != retrievedCharCodes.length) ||
          !bidi.Bidi.hasAnyRtl(text)) {
        retrievedCharCodes = null;
      }
      for (int i = 0; i < text.length; i++) {
        final String letter = text[i];
        final dynamic retrievedCharCode = (retrievedCharCodes != null &&
                i < retrievedCharCodes.length &&
                retrievedCharCodes[i] != null &&
                retrievedCharCodes[i] != 0)
            ? retrievedCharCodes[i]
            : null;
        letterCount += 1;
        final int charCode = letter.codeUnitAt(0);
        isTextGlyphAdded = false;
        if (charCode.toUnsigned(8) > 126 &&
            fontEncoding == 'MacRomanEncoding' &&
            !isEmbeddedFont) {
          isTextGlyphAdded = true;
          final MatrixHelper? tempMatrix = drawSystemFontGlyphShape(
              letter, g!, txtMatrix, retrievedCharCode);
          if (tempMatrix != null) {
            txtMatrix = tempMatrix;
          } else {
            isTextGlyphAdded = false;
          }
        } else {
          if (renderingMode == 1) {
            isTextGlyphAdded = true;
            final MatrixHelper? tempMatrix = drawSystemFontGlyphShape(
                letter, g!, txtMatrix, retrievedCharCode);
            if (tempMatrix != null) {
              txtMatrix = tempMatrix;
            } else {
              isTextGlyphAdded = false;
            }
          } else if (reverseMapTable!.isNotEmpty &&
              reverseMapTable!.containsKey(letter)) {
            final int tempCharCode = reverseMapTable![letter]!.toInt();
            if (fontGlyphWidths != null) {
              currentGlyphWidth = (fontGlyphWidths!
                          .containsKey(retrievedCharCode ?? tempCharCode)
                      ? fontGlyphWidths![retrievedCharCode ?? tempCharCode]
                      : defaultGlyphWidth)! *
                  charSizeMultiplier;
            } else {
              currentGlyphWidth = defaultGlyphWidth! * charSizeMultiplier;
            }
            txtMatrix =
                drawGlyphs(currentGlyphWidth, g!, txtMatrix, letter, false);
            isTextGlyphAdded = true;
          } else {
            if (characterMapTable.isNotEmpty &&
                characterMapTable.containsKey(charCode)) {
              final String tempLetter = characterMapTable[charCode]![0];
              isTextGlyphAdded = true;
              final MatrixHelper? tempMatrix = drawSystemFontGlyphShape(
                  tempLetter, g!, txtMatrix, retrievedCharCode);
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
                if (structure.fontType!.name == 'Type0') {
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
                } else if (structure.fontType!.name == 'TrueType' &&
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
        if (letterCount < text.length) {
          location = Offset(location.dx + characterSpacing!, location.dy);
        }
        if (!isTextGlyphAdded) {
          txtMatrix =
              drawGlyphs(currentGlyphWidth, g!, txtMatrix, letter, false);
        }
      }
    }
    changeInX = location.dx - changeInX;
    return <String, dynamic>{
      'textElementWidth': changeInX,
      'tempTextMatrix': txtMatrix
    };
  }

  /// internal method
  Map<String, dynamic> renderWithSpacing(
      GraphicsObject? g,
      Offset currentLocation,
      Map<List<dynamic>?, String> decodedList,
      List<double>? characterSpacing,
      double? textScaling,
      Map<int, int>? glyphWidths,
      double? type1Height,
      Map<int, String> differenceTable,
      Map<String, String?> differenceMappedTable,
      Map<int, String>? differenceEncoding,
      MatrixHelper? txtMatrix) {
    txtMatrix = MatrixHelper(0, 0, 0, 0, 0, 0);
    txtMatrix.type = MatrixTypes.identity;
    double changeInX = currentLocation.dx;
    Offset location = Offset(currentLocation.dx, currentLocation.dy);
    // ignore: avoid_function_literals_in_foreach_calls
    decodedList.forEach((List<dynamic>? keys, String word) {
      final double? space = double.tryParse(word);
      if (space != null) {
        _updateTextMatrixWithSpacing(space);
      } else {
        if (!isEmbeddedFont &&
            structure.font != null &&
            (structure.isStandardFont || structure.isStandardCJKFont)) {
          final MatrixHelper defaultTransformations =
              g!.transformMatrix!.clone();
          if (word != '' && word[word.length - 1] == 's') {
            word = word.substring(0, word.length - 1);
          }
          for (int i = 0; i < word.length; i++) {
            final String character = word[i];
            g.transformMatrix = MatrixHelper(1, 0, 0, 1, 0, 0);
            final Glyph glyph = Glyph();
            glyph.fontSize = fontSize;
            glyph.fontFamily = fontName;
            glyph.fontStyle = fontStyle;
            glyph.transformMatrix = _getTextRenderingMatrix();
            glyph.name = character;
            glyph.horizontalScaling = textHorizontalScaling!;
            glyph.charId = character.codeUnitAt(0);
            glyph.toUnicode = character;
            glyph.charSpacing = this.characterSpacing!;
            if (structure.isStandardFont) {
              final PdfStandardFont font = structure.font! as PdfStandardFont;
              glyph.width = PdfStandardFontHelper.getHelper(font)
                      .getCharWidthInternal(character) *
                  PdfFontHelper.characterSizeMultiplier;
            } else if (structure.isStandardCJKFont) {
              final PdfCjkStandardFont font =
                  structure.font! as PdfCjkStandardFont;
              glyph.width = PdfCjkStandardFontHelper.getHelper(font)
                      .getCharWidthInternal(character) *
                  PdfFontHelper.characterSizeMultiplier;
            }
            final MatrixHelper identity = MatrixHelper.identity.clone();
            identity.scale(0.01, 0.01, 0.0, 0.0);
            identity.translate(0.0, 1.0);
            transformations._pushTransform(identity * glyph.transformMatrix);
            final MatrixHelper transform = g.transformMatrix!;
            MatrixHelper matrix = transform.clone();
            matrix = matrix * transformations.currentTransform!.clone();
            g.transformMatrix = matrix;
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
          g.transformMatrix = defaultTransformations;
          txtMatrix = textLineMatrix;
        } else {
          if (word != '' && word[word.length - 1] == 's') {
            word = word.substring(0, word.length - 1);
          }
          final bool containsRTL = bidi.Bidi.hasAnyRtl(word);
          if ((keys != null &&
                  word.length > keys.length &&
                  keys.length > word.length + 2) ||
              !containsRTL) {
            keys = null;
          }
          if (word != '') {
            int letterCount = 0;
            bool isComplexScript = false;
            if ((!containsRTL || (containsRTL && word.length <= 1)) &&
                reverseMapTable!.isNotEmpty &&
                reverseMapTable!.containsKey(word)) {
              final int charCode = reverseMapTable![word]!.toInt();
              final dynamic retrievedCharCode = (keys != null &&
                      keys.isNotEmpty &&
                      keys[0] != null &&
                      keys[0] != 0)
                  ? keys[0]
                  : null;
              if (characterMapTable.isNotEmpty &&
                  characterMapTable.containsKey(charCode)) {
                final String tempLetter = characterMapTable[charCode]!;
                isTextGlyphAdded = true;
                isComplexScript = true;
                final MatrixHelper? tempMatrix = drawSystemFontGlyphShape(
                    tempLetter, g!, txtMatrix, retrievedCharCode);
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
                final dynamic retrievedCharCode = (keys != null &&
                        i < keys.length &&
                        keys[i] != null &&
                        keys[i] != 0)
                    ? keys[i]
                    : null;
                isTextGlyphAdded = false;
                if (charCode.toUnsigned(8) > 126 &&
                    fontEncoding == 'MacRomanEncoding' &&
                    !isEmbeddedFont) {
                  isTextGlyphAdded = true;
                  final MatrixHelper? tempMatrix = drawSystemFontGlyphShape(
                      letter, g!, txtMatrix, retrievedCharCode);
                  if (tempMatrix != null) {
                    txtMatrix = tempMatrix;
                  } else {
                    isTextGlyphAdded = false;
                  }
                } else {
                  if (renderingMode == 1) {
                    isTextGlyphAdded = true;
                    final MatrixHelper? tempMatrix = drawSystemFontGlyphShape(
                        letter, g!, txtMatrix, retrievedCharCode);
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
                      final MatrixHelper? tempMatrix = drawSystemFontGlyphShape(
                          tempLetter, g!, txtMatrix, retrievedCharCode);
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
                      if (structure.fontType!.name == 'Type0') {
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
                      } else if (structure.fontType!.name == 'TrueType' &&
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
                if (!isTextGlyphAdded &&
                    (retrievedCharCode == null ||
                        (retrievedCharCode != null &&
                            retrievedCharCode is! String))) {
                  txtMatrix = drawGlyphs(
                      currentGlyphWidth, g!, txtMatrix, letter, i == 0);
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

  /// internal method
  MatrixHelper? drawGlyphs(double? glyphwidth, GraphicsObject g,
      MatrixHelper? temptextmatrix, String? glyphChar, bool renderWithSpace) {
    final MatrixHelper defaultTransformations = g.transformMatrix!.clone();
    g.transformMatrix = MatrixHelper(1, 0, 0, 1, 0, 0);
    final Glyph glyph = Glyph();
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
    final MatrixHelper identity = MatrixHelper(1, 0, 0, 1, 0, 0);
    identity.scale(0.01, 0.01, 0.0, 0.0);
    identity.translate(0.0, 1.0);
    transformations._pushTransform(identity * glyph.transformMatrix);
    final MatrixHelper transform = g.transformMatrix!;
    MatrixHelper matrix = transform.clone();
    matrix *= transformations.currentTransform!.clone();
    g.transformMatrix = matrix;
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
      final double x = ((matrix.offsetX +
                  ((tempFontSize + (glyph.ascent / 1000.0)) * matrix.m21)) /
              1.3333333333333333) /
          zoomFactor!;
      double y = ((matrix.offsetY -
                  ((pageRotation == 270
                          ? tempFontSize
                          : (glyph.width * tempFontSize)) *
                      zoomFactor!)) /
              1.3333333333333333) /
          zoomFactor!;
      double width = glyph.width * tempFontSize;
      double height = tempFontSize;
      if (pageRotation == 270) {
        if (textElementGlyphList.isEmpty || renderWithSpace) {
          y += width;
        } else {
          final Glyph tempGlyph =
              textElementGlyphList[textElementGlyphList.length - 1];
          if (textElementGlyphList.length == 1 && tempGlyph.toUnicode == ' ') {
            y += width;
          } else {
            y = tempGlyph.boundingRect.top + tempGlyph.boundingRect.height;
          }
        }
        height = width;
        width = tempFontSize;
      }
      glyph.boundingRect = Rect.fromLTWH(x, y, width, height);
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
        final Glyph emptyGlyph = Glyph();
        textElementGlyphList.add(emptyGlyph);
      }
    } else {
      textElementGlyphList.add(glyph);
    }
    _updateTextMatrix(glyph);
    transformations._popTransform();
    g.transformMatrix = defaultTransformations;
    temptextmatrix = textLineMatrix;
    renderedText += glyphChar;
    return temptextmatrix;
  }

  /// internal method
  MatrixHelper? drawSystemFontGlyphShape(
      String letter, GraphicsObject g, MatrixHelper? temptextmatrix,
      [dynamic charCode]) {
    final MatrixHelper? defaultTransformations = g.transformMatrix;
    g.transformMatrix = MatrixHelper(1, 0, 0, 1, 0, 0);
    final Glyph gly = Glyph();
    gly.horizontalScaling = textHorizontalScaling!;
    gly.charSpacing = characterSpacing!;
    gly.fontSize = fontSize;
    gly.name = letter;
    gly.charId = letter.codeUnitAt(0).toUnsigned(8);
    gly.transformMatrix = _getTextRenderingMatrix();
    if (letter == ' ') {
      gly.wordSpacing = wordSpacing!;
    }
    double? systemFontGlyph;
    if (fontGlyphWidths != null && fontGlyphWidths!.isNotEmpty) {
      if (reverseMapTable != null && reverseMapTable!.containsKey(letter)) {
        if (charCode != null && charCode is String) {
          systemFontGlyph = 0;
        } else {
          charCode ??= reverseMapTable![letter]!.toInt();
          if (fontGlyphWidths!.containsKey(charCode)) {
            systemFontGlyph = fontGlyphWidths![charCode]! * charSizeMultiplier;
          } else {
            return null;
          }
        }
      } else if (fontGlyphWidths!.containsKey(letter.codeUnitAt(0))) {
        systemFontGlyph =
            fontGlyphWidths![letter.codeUnitAt(0)]! * charSizeMultiplier;
      }
    }
    gly.width = (systemFontGlyph == null) ? 0 : systemFontGlyph;
    final MatrixHelper identity = MatrixHelper(1, 0, 0, 1, 0, 0);
    identity.scale(0.01, 0.01, 0.0, 0.0);
    identity.translate(0.0, 1.0);
    transformations._pushTransform(identity * gly.transformMatrix);
    final MatrixHelper transform = g.transformMatrix!;
    MatrixHelper matrix = transform.clone();
    matrix = matrix * transformations.currentTransform!.clone();
    g.transformMatrix = matrix;
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
    if (isExtractTextData && gly.toUnicode.length != 1) {
      for (int i = 0; i < gly.toUnicode.length - 1; i++) {
        final Glyph emptyGlyph = Glyph();
        emptyGlyph.boundingRect =
            Rect.fromLTWH(gly.boundingRect.right, gly.boundingRect.top, 0, 0);
        textElementGlyphList.add(emptyGlyph);
      }
    }
    _updateTextMatrix(gly);
    transformations._popTransform();
    g.transformMatrix = defaultTransformations;
    temptextmatrix = textLineMatrix;
    renderedText += glyphName;
    return temptextmatrix;
  }

  void _updateTextMatrixWithSpacing(double space) {
    final double x = -(space * 0.001 * fontSize * textHorizontalScaling! / 100);
    final Offset point = textLineMatrix!.transform(Offset.zero);
    final Offset point2 = textLineMatrix!.transform(Offset(x, 0.0));
    if (point.dx != point2.dx) {
      textLineMatrix!.offsetX = point2.dx;
    } else {
      textLineMatrix!.offsetY = point2.dy;
    }
  }

  void _updateTextMatrix(Glyph glyph) {
    textLineMatrix = _calculateTextMatrix(textLineMatrix!, glyph);
  }

  MatrixHelper _calculateTextMatrix(MatrixHelper m, Glyph glyph) {
    if (glyph.charId == 32) {
      glyph.wordSpacing = wordSpacing!;
    }
    final double width = glyph.width;
    final double offsetX =
        (width * glyph.fontSize + glyph.charSpacing + glyph.wordSpacing) *
            (glyph.horizontalScaling / 100);
    return MatrixHelper(1.0, 0.0, 0.0, 1.0, offsetX, 0.0) * m;
  }
}

class _TransformationStack {
  _TransformationStack([MatrixHelper? transformMatrix]) {
    _initialTransform = (transformMatrix != null)
        ? transformMatrix
        : MatrixHelper(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
    transformStack = Queue<MatrixHelper>();
  }

  //Fields
  late MatrixHelper _currentTransform;
  MatrixHelper? _initialTransform;
  late Queue<MatrixHelper> transformStack;

  //Properties
  MatrixHelper? get currentTransform {
    if (transformStack.isEmpty) {
      return _initialTransform;
    }
    return _currentTransform * _initialTransform!;
  }

  //Implementation
  void _pushTransform(MatrixHelper transformMatrix) {
    transformStack.addLast(transformMatrix);
    MatrixHelper matrix = MatrixHelper.identity.clone();
    for (final MatrixHelper current in transformStack) {
      matrix *= current;
    }
    _currentTransform = matrix;
  }

  void _popTransform() {
    transformStack.removeLast();
    MatrixHelper matrix = MatrixHelper.identity.clone();
    for (final MatrixHelper current in transformStack) {
      matrix *= current;
    }
    _currentTransform = matrix;
  }
}
