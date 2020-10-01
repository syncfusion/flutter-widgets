part of pdf;

/// Gets the details of character in the word.
class TextGlyph {
  TextGlyph._() {
    _initialize();
  }

  //Fields
  /// Gets the bounds of glyph.
  Rect bounds;

  /// Gets the text of glyph.
  String text;

  /// Gets the font size of glyph.
  double fontSize;

  /// Gets the font name of glyph.
  String fontName;

  /// Gets the font style of glyph.
  List<PdfFontStyle> fontStyle;

  //Implementation
  void _initialize() {
    bounds = Rect.fromLTWH(0, 0, 0, 0);
    fontSize = 0;
  }
}
