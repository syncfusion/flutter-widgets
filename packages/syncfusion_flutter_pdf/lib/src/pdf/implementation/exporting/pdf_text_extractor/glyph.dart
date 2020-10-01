part of pdf;

class _Glyph {
  _Glyph() {
    _initialize();
  }

  //Fields
  double _descent;

  //Properties
  double ascent;
  _MatrixHelper transformMatrix;
  Rect boundingRect;
  double charSpacing;
  double wordSpacing;
  double horizontalScaling;
  double fontSize;
  String fontFamily;
  String name;
  int charId;
  double width;
  List<PdfFontStyle> fontStyle;
  String toUnicode;
  bool isRotated;
  int rotationAngle;
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
    transformMatrix = _MatrixHelper(1, 0, 0, 1, 0, 0);
    charSpacing = 0;
    wordSpacing = 0;
    horizontalScaling = 100;
    fontSize = 0;
    width = 0;
  }
}
