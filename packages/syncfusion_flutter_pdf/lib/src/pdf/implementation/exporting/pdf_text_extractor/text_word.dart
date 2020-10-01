part of pdf;

/// Details of a word present in the line.
class TextWord {
  //constructor
  TextWord._() {
    _glyphs = <TextGlyph>[];
    bounds = Rect.fromLTWH(0, 0, 0, 0);
    fontSize = 0;
  }

  //Fields
  /// Gets the text.
  String text;

  /// Gets the bounds of the word.
  Rect bounds;

  /// Gets the font size of the word.
  double fontSize;

  /// Gets the font name of the word.
  String fontName;

  /// Gets the font style of the word.
  List<PdfFontStyle> fontStyle;
  List<TextGlyph> _glyphs;

  //Properties
  /// Gets the text glyph with bounds in the word.
  List<TextGlyph> get glyphs => _glyphs;
}
