part of pdf;

class _TtfMetrics {
  int lineGap;
  bool contains;
  bool isSymbol;
  _Rectangle fontBox;
  bool isFixedPitch;
  double italicAngle;
  String postScriptName;
  String fontFamily;
  double capHeight;
  double leading;
  double macAscent;
  double macDescent;
  double winDescent;
  double winAscent;
  double stemV;
  List<int> widthTable;
  int macStyle;
  double subscriptSizeFactor;
  double superscriptSizeFactor;
  //Properties
  bool get isItalic => macStyle & 2 != 0;
  bool get isBold => macStyle & 1 != 0;
}
