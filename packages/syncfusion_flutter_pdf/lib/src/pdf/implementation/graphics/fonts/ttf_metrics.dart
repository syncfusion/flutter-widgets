part of pdf;

class _TtfMetrics {
  int? lineGap;
  bool? contains;
  late bool isSymbol;
  late _Rectangle fontBox;
  late bool isFixedPitch;
  double? italicAngle;
  String? postScriptName;
  String? fontFamily;
  late double capHeight;
  late double leading;
  double macAscent = 0;
  double macDescent = 0;
  late double winDescent;
  late double winAscent;
  late double stemV;
  late List<int> widthTable;
  int? macStyle;
  double? subscriptSizeFactor;
  double? superscriptSizeFactor;
  //Properties
  bool get isItalic => macStyle! & 2 != 0;
  bool get isBold => macStyle! & 1 != 0;
}
