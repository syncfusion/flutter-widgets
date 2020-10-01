part of pdf;

/// Represents the text layout information on PDF
class PdfStringFormat {
  //Constructor
  /// Initializes a new instance of the [PdfStringFormat] class
  /// with horizontal alignment and vertical alignment of text.
  PdfStringFormat(
      {PdfTextAlignment alignment,
      PdfVerticalAlignment lineAlignment,
      PdfTextDirection textDirection,
      double characterSpacing,
      double wordSpacing,
      double lineSpacing,
      PdfSubSuperscript subSuperscript,
      double paragraphIndent,
      bool measureTrailingSpaces,
      PdfWordWrapType wordWrap}) {
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
  /// Gets and sets Horizontal text alignment.
  PdfTextAlignment alignment;

  /// Gets and sets Vertical text alignment.
  PdfVerticalAlignment lineAlignment;

  /// Gets and sets text rendering direction.
  PdfTextDirection textDirection;

  /// Gets and sets Character spacing value.
  double characterSpacing;

  /// Gets and sets Word spacing value.
  double wordSpacing;

  /// Gets and sets Text leading or Line spacing.
  double lineSpacing;

  /// Gets and sets if the text should be a part of the current clipping path.
  bool clipPath;

  /// Gets and sets whether the text is in subscript or superscript mode.
  PdfSubSuperscript subSuperscript;

  /// The scaling factor of the text being drawn.
  double _scalingFactor;

  /// Indent of the first line in the paragraph.
  double _paragraphIndent;

  double _firstLineIndent;

  /// Gets and sets whether entire lines are laid out in the
  /// formatting rectangle only or not.
  bool lineLimit;

  /// Gets and sets whether spaces at the end of the line should be
  /// left or removed.
  bool measureTrailingSpaces;

  /// Gets and sets whether the text region should be clipped or not.
  bool noClip;

  /// Gets and sets text wrapping type.
  PdfWordWrapType wordWrap;

  //Properties
  /// Gets the indent of the first line in the paragraph.
  double get paragraphIndent => _paragraphIndent;

  /// Sets the indent of the first line in the paragraph.
  set paragraphIndent(double value) {
    _paragraphIndent = value;
    _firstLineIndent = value;
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
    alignment = textAlignment ?? PdfTextAlignment.left;
    lineAlignment = verticalAlignment ?? PdfVerticalAlignment.top;
    this.characterSpacing = characterSpacing ?? 0;
    clipPath = false;
    lineLimit = true;
    this.lineSpacing = lineSpacing ?? 0;
    this.measureTrailingSpaces = measureTrailingSpaces ?? false;
    noClip = false;
    _firstLineIndent ??= 0;
    this.paragraphIndent = paragraphIndent ?? 0;
    this.subSuperscript = subSuperscript ?? PdfSubSuperscript.none;
    this.textDirection = textDirection ?? PdfTextDirection.none;
    this.wordSpacing = wordSpacing ?? 0;
    this.wordWrap = wordWrap ?? PdfWordWrapType.word;
    _scalingFactor = 100;
  }
}
