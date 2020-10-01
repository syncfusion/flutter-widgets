part of pdf;

/// Details of the text present in a line
class TextLine {
  //constructor
  TextLine._() {
    wordCollection = <TextWord>[];
    bounds = Rect.fromLTWH(0, 0, 0, 0);
    fontSize = 0;
    text = '';
  }

  //Fields
  /// Gets the collection of words present in the line.
  List<TextWord> wordCollection;

  /// Gets the bounds of the text.
  Rect bounds;

  /// Gets the font name of the text.
  String fontName;

  /// Gets the font style of the text.
  List<PdfFontStyle> fontStyle;

  /// Gets the font size of the text.
  double fontSize;

  /// Gets the page index.
  int pageIndex;

  /// Gets the text.
  String text;
}
