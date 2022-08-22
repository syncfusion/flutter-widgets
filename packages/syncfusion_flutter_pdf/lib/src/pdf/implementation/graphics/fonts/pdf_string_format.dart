import '../enums.dart';
import 'enums.dart';

/// Represents the text layout information on PDF
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawString(
///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
///       //Create a new PDF string format instance.
///       format: PdfStringFormat(
///           alignment: PdfTextAlignment.left,
///           lineAlignment: PdfVerticalAlignment.top,
///           textDirection: PdfTextDirection.leftToRight,
///           characterSpacing: 0.5,
///           wordSpacing: 0.5,
///           lineSpacing: 0.5,
///           subSuperscript: PdfSubSuperscript.superscript,
///           paragraphIndent: 10,
///           measureTrailingSpaces: true,
///           wordWrap: PdfWordWrapType.word));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Close the document.
/// document.dispose();
/// ```
class PdfStringFormat {
  //Constructor
  /// Initializes a new instance of the [PdfStringFormat] class
  /// with horizontal alignment and vertical alignment of text.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       //Create a new PDF string format instance.
  ///       format: PdfStringFormat(
  ///           alignment: PdfTextAlignment.left,
  ///           lineAlignment: PdfVerticalAlignment.top,
  ///           textDirection: PdfTextDirection.leftToRight,
  ///           characterSpacing: 0.5,
  ///           wordSpacing: 0.5,
  ///           lineSpacing: 0.5,
  ///           subSuperscript: PdfSubSuperscript.superscript,
  ///           paragraphIndent: 10,
  ///           measureTrailingSpaces: true,
  ///           wordWrap: PdfWordWrapType.word));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfStringFormat(
      {PdfTextAlignment alignment = PdfTextAlignment.left,
      PdfVerticalAlignment lineAlignment = PdfVerticalAlignment.top,
      PdfTextDirection textDirection = PdfTextDirection.none,
      double characterSpacing = 0,
      double wordSpacing = 0,
      double lineSpacing = 0,
      PdfSubSuperscript subSuperscript = PdfSubSuperscript.none,
      double paragraphIndent = 0,
      bool measureTrailingSpaces = false,
      PdfWordWrapType wordWrap = PdfWordWrapType.word}) {
    _helper = PdfStringFormatHelper();
    _initialize(
        alignment,
        lineAlignment,
        textDirection,
        characterSpacing,
        wordSpacing,
        lineSpacing,
        subSuperscript,
        paragraphIndent,
        measureTrailingSpaces,
        wordWrap);
  }

  //Fields
  late PdfStringFormatHelper _helper;

  /// Gets and sets Horizontal text alignment.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       format: PdfStringFormat(alignment: PdfTextAlignment.left));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  late PdfTextAlignment alignment;

  /// Gets and sets Vertical text alignment.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.top));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  late PdfVerticalAlignment lineAlignment;

  /// Gets and sets text rendering direction.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       format: PdfStringFormat(textDirection: PdfTextDirection.rightToLeft));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  late PdfTextDirection textDirection;

  /// Gets and sets Character spacing value.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Draw the text.
  /// document.pages
  ///     .add()
  ///     .graphics
  ///     .drawString('Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///         format: PdfStringFormat(characterSpacing: 0.5));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  late double characterSpacing;

  /// Gets and sets Word spacing value.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Draw the text.
  /// document.pages
  ///     .add()
  ///     .graphics
  ///     .drawString('Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///         format: PdfStringFormat(wordSpacing: 0.5));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  late double wordSpacing;

  /// Gets and sets Text leading or Line spacing.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Draw the text.
  /// document.pages
  ///     .add()
  ///     .graphics
  ///     .drawString('Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///         format: PdfStringFormat(lineSpacing: 0.5));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  late double lineSpacing;

  /// Gets and sets if the text should be a part of the current clipping path.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       bounds: Rect.fromLTWH(0, 0, 200, 100),
  ///       format: PdfStringFormat(
  ///           alignment: PdfTextAlignment.center,
  ///           lineAlignment: PdfVerticalAlignment.middle,
  ///           characterSpacing: 1)
  ///         //Set the clip path.
  ///         ..clipPath = true);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  bool clipPath = false;

  /// Gets and sets whether the text is in subscript or superscript mode.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       bounds: Rect.fromLTWH(0, 0, 200, 100),
  ///       format: PdfStringFormat(
  ///           alignment: PdfTextAlignment.center,
  ///           lineAlignment: PdfVerticalAlignment.middle,
  ///           characterSpacing: 1,
  ///           subSuperscript: PdfSubSuperscript.subscript));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  late PdfSubSuperscript subSuperscript;

  /// Gets and sets whether entire lines are laid out in the
  /// formatting rectangle only or not.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       bounds: Rect.fromLTWH(0, 0, 200, 100),
  ///       format: PdfStringFormat(
  ///           alignment: PdfTextAlignment.center,
  ///           lineAlignment: PdfVerticalAlignment.middle,
  ///           characterSpacing: 1,
  ///           lineSpacing: 1.1,
  ///           measureTrailingSpaces: true,
  ///           paragraphIndent: 2.1,
  ///           wordSpacing: 1.5,
  ///           wordWrap: PdfWordWrapType.word,
  ///           subSuperscript: PdfSubSuperscript.subscript)
  ///         ..clipPath = true
  ///         ..noClip = true
  ///         //Set line limit.
  ///         ..lineLimit = true);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  bool lineLimit = true;

  /// Gets and sets whether spaces at the end of the line should be
  /// left or removed.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       format: PdfStringFormat(measureTrailingSpaces: true));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  late bool measureTrailingSpaces;

  /// Gets and sets whether the text region should be clipped or not.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       bounds: Rect.fromLTWH(0, 0, 200, 100),
  ///       format: PdfStringFormat(
  ///           alignment: PdfTextAlignment.center,
  ///           lineAlignment: PdfVerticalAlignment.middle,
  ///           characterSpacing: 1,
  ///           lineSpacing: 1.1,
  ///           measureTrailingSpaces: true,
  ///           paragraphIndent: 2.1,
  ///           wordSpacing: 1.5,
  ///           wordWrap: PdfWordWrapType.word,
  ///           subSuperscript: PdfSubSuperscript.subscript)
  ///         ..clipPath = true
  ///         //Set no clip.
  ///         ..noClip = true
  ///         ..lineLimit = true);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  bool noClip = false;

  /// Gets and sets text wrapping type.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       format: PdfStringFormat(wordWrap: PdfWordWrapType.word));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  late PdfWordWrapType wordWrap;

  //Indent of the first line in the paragraph.
  late double _paragraphIndent;

  //Properties
  /// Gets or sets the indent of the first line in the paragraph.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawString(
  ///       'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       format: PdfStringFormat(paragraphIndent: 2.1));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  double get paragraphIndent => _paragraphIndent;
  set paragraphIndent(double value) {
    _paragraphIndent = value;
    _helper.firstLineIndent = value;
  }

  //Implementation
  void _initialize(
      PdfTextAlignment textAlignment,
      PdfVerticalAlignment verticalAlignment,
      PdfTextDirection textDirection,
      double characterSpacing,
      double wordSpacing,
      double lineSpacing,
      PdfSubSuperscript subSuperscript,
      double paragraphIndent,
      bool measureTrailingSpaces,
      PdfWordWrapType wordWrap) {
    alignment = textAlignment;
    lineAlignment = verticalAlignment;
    this.characterSpacing = characterSpacing;
    this.lineSpacing = lineSpacing;
    this.measureTrailingSpaces = measureTrailingSpaces;
    this.paragraphIndent = paragraphIndent;
    this.subSuperscript = subSuperscript;
    this.textDirection = textDirection;
    this.wordSpacing = wordSpacing;
    this.wordWrap = wordWrap;
  }
}

/// [PdfStringFormat] helper
class PdfStringFormatHelper {
  /// internal method
  static PdfStringFormatHelper getHelper(PdfStringFormat format) {
    return format._helper;
  }

  /// internal field
  double scalingFactor = 100;

  /// internal field
  late double firstLineIndent;
}
