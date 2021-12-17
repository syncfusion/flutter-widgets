import 'dart:ui';

import '../../graphics/fonts/enums.dart';
import 'text_glyph.dart';

/// Details of a word present in the line.
class TextWord {
  //constructor
  TextWord._(this.text, this.fontName, this.fontStyle, List<TextGlyph> glyphs,
      this.bounds, this.fontSize) {
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

// ignore: avoid_classes_with_only_static_members
/// [TextWord] helper
class TextWordHelper {
  /// internal method
  static TextWord initialize(String text, String fontName,
      List<PdfFontStyle> fontStyle, List<TextGlyph> glyphs,
      [Rect bounds = Rect.zero, double fontSize = 0]) {
    return TextWord._(text, fontName, fontStyle, glyphs, bounds, fontSize);
  }
}
