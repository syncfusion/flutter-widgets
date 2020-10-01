part of pdf;

/// Represents the state of a Graphics object. \
/// This object is returned by a call to the Save methods.
class PdfGraphicsState {
  // Constructors
  /// Initializes a new instance of the [PdfGraphicsState] class.
  PdfGraphicsState._(PdfGraphics graphics, _PdfTransformationMatrix matrix) {
    if (graphics != null && matrix != null) {
      _graphics = graphics;
      _matrix = matrix;
    }
    _initialize();
  }

  //Fields
  PdfGraphics _graphics;
  _PdfTransformationMatrix _matrix;
  double _characterSpacing;
  double _wordSpacing;
  double _textScaling;
  PdfPen _pen;
  PdfBrush _brush;
  PdfFont _font;
  PdfColorSpace _colorSpace;

  /// Gets or sets the text rendering mode.
  int _textRenderingMode;

  //Implementation
  void _initialize() {
    _textRenderingMode = _TextRenderingMode.fill;
    _colorSpace = PdfColorSpace.rgb;
    _characterSpacing = 0.0;
    _wordSpacing = 0.0;
    _textScaling = 100.0;
  }
}
