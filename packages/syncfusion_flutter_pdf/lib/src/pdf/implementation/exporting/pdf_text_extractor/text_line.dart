import 'dart:ui';

import '../../graphics/fonts/enums.dart';
import 'text_word.dart';

/// Details of the text present in a line
class TextLine {
  //constructor
  TextLine._() {
    wordCollection = <TextWord>[];
    bounds = Rect.zero;
    fontSize = 0;
    text = '';
    pageIndex = 0;
    fontName = '';
    fontStyle = <PdfFontStyle>[];
  }

  //Fields
  /// Gets the collection of words present in the line.
  late List<TextWord> wordCollection;

  /// Gets the bounds of the text.
  late Rect bounds;

  /// Gets the font name of the text.
  late String fontName;

  /// Gets the font style of the text.
  late List<PdfFontStyle> fontStyle;

  /// Gets the font size of the text.
  late double fontSize;

  /// Gets the page index.
  late int pageIndex;

  /// Gets the text.
  late String text;
}

// ignore: avoid_classes_with_only_static_members
/// [TextLine] helper
class TextLineHelper {
  /// internal method
  static TextLine initialize() {
    return TextLine._();
  }
}
