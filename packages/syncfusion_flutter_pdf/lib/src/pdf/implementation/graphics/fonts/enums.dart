/// Specifies style information applied to text.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString('Hello World!',
///       PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Close the document.
/// document.dispose();
/// ```
enum PdfFontStyle {
  ///Represents Regular text
  regular,

  ///Represents Bold text
  bold,

  ///Represents Italic text
  italic,

  ///Represents Underline text
  underline,

  ///Represents Strikeout text
  strikethrough
}

/// Indicates type of standard PDF fonts.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString(
///       'Hello world!', PdfStandardFont(PdfFontFamily.helvetica, 12),
///       brush: PdfBrushes.black);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Close the document.
/// document.dispose();
/// ```
enum PdfFontFamily {
  /// Represents the Helvetica font.
  helvetica,

  /// Represents the Courier font.
  courier,

  /// Represents the Times Roman font.
  timesRoman,

  /// Represents the Symbol font.
  symbol,

  /// Represents the ZapfDingbats font.
  zapfDingbats,
}

/// Specifies the type of SubSuperscript.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString(
///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
///       format: PdfStringFormat(
///           alignment: PdfTextAlignment.left,
///           subSuperscript: PdfSubSuperscript.subscript));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Close the document.
/// document.dispose();
/// ```
enum PdfSubSuperscript {
  /// Specifies no subscript or superscript.
  none,

  /// Specifies superscript format.
  superscript,

  /// Specifies subscript format.
  subscript
}

/// Specifies the type of CJK font.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString(
///       'こんにちは世界', PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 20),
///       brush: PdfBrushes.black);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Close the document.
/// document.dispose();
/// ```
enum PdfCjkFontFamily {
  /// Represents the Hanyang Systems Gothic Medium font.
  hanyangSystemsGothicMedium,

  /// Represents the Hanyang Systems shin myeong Jo Medium font.
  hanyangSystemsShinMyeongJoMedium,

  /// Represents the Heisei kaku GothicW5 font.
  heiseiKakuGothicW5,

  /// Represents the Heisei MinchoW3 font.
  heiseiMinchoW3,

  /// Represents the Monotype Hei Medium font.
  monotypeHeiMedium,

  /// Represents the monotype sung Light font.
  monotypeSungLight,

  /// Represents the sinotype song light font.
  sinoTypeSongLight
}

/// Specifies the types of text wrapping.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString(
///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
///       format: PdfStringFormat(
///           alignment: PdfTextAlignment.left, wordWrap: PdfWordWrapType.word));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Close the document.
/// document.dispose();
/// ```
enum PdfWordWrapType {
  /// Text wrapping between lines when formatting
  /// within a rectangle is disabled.
  none,

  /// Text is wrapped by words. If there is a word that is longer than bounds'
  /// width, this word is wrapped by characters.
  word,

  /// Text is wrapped by words. If there is a word that is longer than bounds'
  /// width, it won't be wrapped at all and the process will be finished.
  wordOnly,

  /// Text is wrapped by characters. In this case the word
  /// at the end of the text line can be split.
  character
}

/// Break type of the line.
enum LineType {
  /// Unknown type line.
  none,

  /// The line has new line symbol.
  newLineBreak,

  /// layout break.
  layoutBreak,

  /// The line is the first in the paragraph.
  firstParagraphLine,

  /// The line is the last in the paragraph.
  lastParagraphLine
}
