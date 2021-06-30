part of pdf;

/// Details of a word present in the line.
class TextWord {
  //constructor
  TextWord._(this.text, this.fontName, this.fontStyle, List<TextGlyph> glyphs,
      [this.bounds = const Rect.fromLTWH(0, 0, 0, 0), this.fontSize = 0]) {
    _glyphs = glyphs;
  }

  //Fields
  /// Gets the text.
  late String text;

  /// Gets the bounds of the word.
  late Rect bounds;

  /// Gets the font size of the word.
  late double fontSize;

  /// Gets the font name of the word.
  late String fontName;

  /// Gets the font style of the word.
  late List<PdfFontStyle> fontStyle;
  List<TextGlyph> _glyphs = <TextGlyph>[];

  //Properties
  /// Gets the text glyph with bounds in the word.
  List<TextGlyph> get glyphs => _glyphs;
}
