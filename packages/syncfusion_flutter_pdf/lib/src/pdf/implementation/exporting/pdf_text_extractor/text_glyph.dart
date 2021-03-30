part of pdf;

/// Gets the details of character in the word.
class TextGlyph {
  TextGlyph._(String text, String fontName, List<PdfFontStyle> fontStyle,
      [Rect bounds = const Rect.fromLTWH(0, 0, 0, 0), double fontSize = 0]) {
    this.text = text;
    this.fontName = fontName;
    this.fontStyle = fontStyle;
    this.bounds = bounds;
    this.fontSize = fontSize;
  }

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
}
