part of pdf;

class _Glyph {
  _Glyph() {
    _initialize();
  }

  //Fields
  late double _descent;

  //Properties
  late double ascent;
  late _MatrixHelper transformMatrix;
  late Rect boundingRect;
  late double charSpacing;
  late double wordSpacing;
  late double horizontalScaling;
  late double fontSize;
  String fontFamily = '';
  String name = '';
  int charId = -1;
  late double width;
  List<PdfFontStyle> fontStyle = <PdfFontStyle>[];
  String toUnicode = '';
  late bool isRotated;
  late int rotationAngle;
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
