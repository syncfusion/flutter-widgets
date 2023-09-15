import '../../drawing/drawing.dart';

/// internal class
class TtfMetrics {
  /// internal field
  int? lineGap;

  /// internal field
  bool? contains;

  /// internal field
  late bool isSymbol;

  /// internal field
  late PdfRectangle fontBox;

  /// internal field
  late bool isFixedPitch;

  /// internal field
  double? italicAngle;

  /// internal field
  String? postScriptName;

  /// internal field
  String? fontFamily;

  /// internal field
  late double capHeight;

  /// internal field
  late double leading;

  /// internal field
  double macAscent = 0;

  /// internal field
  double macDescent = 0;

  /// internal field
  late double winDescent;

  /// internal field
  late double winAscent;

  /// internal field
  late double stemV;

  /// internal field
  late List<int> widthTable;

  /// internal field
  int? macStyle;

  /// internal field
  double? subscriptSizeFactor;

  /// internal field
  double? superscriptSizeFactor;
  //Properties
  /// internal property
  bool get isItalic => macStyle! & 2 != 0;

  /// internal property
  bool get isBold => macStyle! & 1 != 0;
}
