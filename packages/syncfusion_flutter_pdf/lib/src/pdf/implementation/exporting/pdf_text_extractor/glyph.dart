import 'dart:ui';

import '../../graphics/fonts/enums.dart';
import 'matrix_helper.dart';

/// internal class
class Glyph {
  /// internal constructor
  Glyph() {
    _initialize();
  }

  //Fields
  late double _descent;

  //Properties
  /// internal field
  late double ascent;

  /// internal field
  late MatrixHelper transformMatrix;

  /// internal field
  late Rect boundingRect;

  /// internal field
  late double charSpacing;

  /// internal field
  late double wordSpacing;

  /// internal field
  late double horizontalScaling;

  /// internal field
  late double fontSize;

  /// internal field
  String fontFamily = '';

  /// internal field
  String name = '';

  /// internal field
  int charId = -1;

  /// internal field
  late double width;

  /// internal field
  List<PdfFontStyle> fontStyle = <PdfFontStyle>[];

  /// internal field
  String toUnicode = '';

  /// internal field
  late bool isRotated;

  /// internal field
  late int rotationAngle;

  /// internal field
  double get descent {
    return _descent;
  }

  set descent(double value) {
    _descent = (value > 0) ? -value : value;
  }

  //Implementation
  void _initialize() {
    rotationAngle = 0;
    isRotated = false;
    ascent = 1000;
    descent = 0;
    transformMatrix = MatrixHelper(1, 0, 0, 1, 0, 0);
    charSpacing = 0;
    wordSpacing = 0;
    horizontalScaling = 100;
    fontSize = 0;
    width = 0;
  }
}
