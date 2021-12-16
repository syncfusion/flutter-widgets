import 'dart:ui';
import '../../graphics/fonts/enums.dart';

/// Gets the details of character in the word.
class TextGlyph {
  TextGlyph._(this.text, this.fontName, this.fontStyle, this.bounds,
      this.fontSize, this.isRotated);

  //Fields
  /// Gets the bounds of glyph.
  late Rect bounds;

  /// Gets the text of glyph.
  late String text;

  /// Gets the font size of glyph.
  late double fontSize;

  /// Gets the font name of glyph.
  late String fontName;

  /// Gets the font style of glyph.
  late List<PdfFontStyle> fontStyle;

  /// Gets or sets a value indicating whether the glyph is rotated or not.
  late bool isRotated;
}

// ignore: avoid_classes_with_only_static_members
/// [TextGlyph] helper
class TextGlyphHelper {
  /// internal method
  static TextGlyph initialize(
      String text, String fontName, List<PdfFontStyle> fontStyle,
      [Rect bounds = Rect.zero, double fontSize = 0, bool isRotated = false]) {
    return TextGlyph._(text, fontName, fontStyle, bounds, fontSize, isRotated);
  }
}
