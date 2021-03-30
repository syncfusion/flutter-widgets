part of pdf;

/// Represents the state of a Graphics object. \
/// This object is returned by a call to the Save methods.
class PdfGraphicsState {
  // Constructors
  /// Initializes a new instance of the [PdfGraphicsState] class.
  PdfGraphicsState._(PdfGraphics graphics, _PdfTransformationMatrix matrix) {
    _graphics = graphics;
    _matrix = matrix;
    _initialize();
  }

  //Fields
  late PdfGraphics _graphics;
  late _PdfTransformationMatrix _matrix;
  late double _characterSpacing;
  late double _wordSpacing;
  late double _textScaling;
  PdfPen? _pen;
  PdfBrush? _brush;
  PdfFont? _font;
  late PdfColorSpace _colorSpace;
  late int _textRenderingMode;

  //Implementation
  void _initialize() {
    _textRenderingMode = _TextRenderingMode.fill;
    _colorSpace = PdfColorSpace.rgb;
    _characterSpacing = 0.0;
    _wordSpacing = 0.0;
    _textScaling = 100.0;
  }
}
