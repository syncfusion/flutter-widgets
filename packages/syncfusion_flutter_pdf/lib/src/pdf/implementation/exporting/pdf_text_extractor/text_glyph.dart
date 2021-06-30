part of pdf;

/// Gets the details of character in the word.
class TextGlyph {
  TextGlyph._(this.text, this.fontName, this.fontStyle,
      [this.bounds = const Rect.fromLTWH(0, 0, 0, 0), this.fontSize = 0]);

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
