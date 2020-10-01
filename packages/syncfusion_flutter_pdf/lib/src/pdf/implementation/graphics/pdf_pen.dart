part of pdf;

/// A class defining settings for drawing operations,
/// that determines the color, width, and style of the drawing elements.
class PdfPen {
  //Constructor
  /// Initializes a new instance of the [PdfPen] class.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create a new PDF pen instance.
  /// PdfPen pen = PdfPen(PdfColor(255, 0, 0));
  /// //Draw rectangle with the pen.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: pen, bounds: Rect(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Close the document.
  /// doc.dispose();
  /// ```
  PdfPen(PdfColor pdfColor,
      {double width,
      PdfDashStyle dashStyle,
      PdfLineCap lineCap,
      PdfLineJoin lineJoin}) {
    if (pdfColor != null) {
      _color = pdfColor;
    }
    _initialize(width, dashStyle, lineCap, lineJoin);
  }

  /// Initializes a new instance of the [PdfPen] with [PdfBrush].
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create a new PDF pen instance using brush.
  /// PdfPen pen = PdfPen(pdfBrush);
  /// //Draw rectangle with the pen.
  /// doc.pages
  ///     .add()
  ///     .graphics
  ///     .drawRectangle(pen: pen, bounds: Rect(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Close the document.
  /// doc.dispose();
  /// ```
  PdfPen.fromBrush(PdfBrush brush,
      {double width,
      PdfDashStyle dashStyle,
      PdfLineCap lineCap,
      PdfLineJoin lineJoin}) {
    ArgumentError.checkNotNull(brush, 'brush');
    _setBrush(brush);
    if (width != null) {
      _width = width;
    }
    _initialize(width, dashStyle, lineCap, lineJoin);
  }

  PdfPen._immutable(PdfColor pdfColor) {
    if (pdfColor != null) {
      _color = pdfColor;
    }
    _immutable = true;
    _initialize();
  }

  //Fields
  bool _immutable = false;
  //ignore:unused_field
  PdfColorSpace _colorSpace;
  PdfDashStyle _dashStyle;
  PdfColor _color;
  PdfBrush _brush;
  double _dashOffset;
  List<double> _dashPattern;
  PdfLineCap _lineCap;
  PdfLineJoin _lineJoin;
  double _width = 1.0;
  double _miterLimit;
  bool _isSkipPatternWidth;

  //Properties
  @override
  bool operator ==(Object other) {
    return other is PdfPen ? _isEqual(other) : false;
  }

  @override
  int get hashCode => width.hashCode;

  /// Gets the color of the pen.
  PdfColor get color => _color;

  /// Sets the color of the pen.
  set color(PdfColor value) {
    _checkImmutability();
    _color = value;
  }

  /// Gets the brush, which specifies the pen behavior.
  PdfBrush get brush => _brush;

  /// Sets the brush, which specifies the pen behavior.
  set brush(PdfBrush value) {
    _checkImmutability();
    _setBrush(value);
  }

  /// Gets the dash offset of the pen.
  double get dashOffset => _dashOffset;

  /// Sets the dash offset of the pen.
  set dashOffset(double value) {
    _checkImmutability();
    _dashOffset = value;
  }

  /// Gets the dash pattern of the pen.
  List<double> get dashPattern => _dashPattern;

  /// Sets the dash pattern of the pen.
  set dashPattern(List<double> value) {
    if (dashStyle == PdfDashStyle.solid) {
      UnsupportedError('''This operation is not allowed. 
          Set Custom dash style to change the pattern.''');
    }
    _checkImmutability();
    _dashPattern = value;
  }

  /// Gets the line cap of the pen.
  PdfLineCap get lineCap => _lineCap;

  /// Sets the line cap of the pen.
  set lineCap(PdfLineCap value) {
    _checkImmutability();
    _lineCap = value;
  }

  /// Gets the line join style of the pen.
  PdfLineJoin get lineJoin => _lineJoin;

  /// Sets the line join style of the pen.
  set lineJoin(PdfLineJoin value) {
    _checkImmutability();
    _lineJoin = value;
  }

  /// Gets the width of the pen.
  double get width => _width;

  /// Sets the width of the pen.
  set width(double value) {
    _checkImmutability();
    _width = value;
  }

  /// Gets the miter limit.
  double get miterLimit => _miterLimit;

  /// Sets the miter limit.
  set miterLimit(double value) {
    _checkImmutability();
    _miterLimit = value;
  }

  /// Gets the dash style of the pen.
  PdfDashStyle get dashStyle => _dashStyle;

  /// Sets the dash style of the pen.
  set dashStyle(PdfDashStyle value) {
    _checkImmutability();
    _setDashStyle(value);
  }

  //Implementation

  bool _isEqual(PdfPen other) {
    return width == other.width &&
        miterLimit == other.miterLimit &&
        lineJoin == other.lineJoin &&
        lineCap == other.lineCap &&
        dashStyle == other.dashStyle &&
        _hasSameDashPattern(other.dashPattern) &&
        brush == other.brush &&
        color == other.color;
  }

  bool _hasSameDashPattern(List<double> otherPattern) {
    if (dashPattern.length == otherPattern.length) {
      bool isSame = true;
      for (int i = 0; i < dashPattern.length; i++) {
        isSame &= dashPattern[0] == otherPattern[0];
      }
      return isSame;
    } else {
      return false;
    }
  }

  void _checkImmutability() {
    if (_immutable) {
      throw UnsupportedError('The immutable object can\'t be changed');
    }
  }

  void _setDashStyle(PdfDashStyle value) {
    if (_dashStyle != value) {
      _dashStyle = value;
      switch (_dashStyle) {
        case PdfDashStyle.custom:
          break;
        case PdfDashStyle.dash:
          _dashPattern = <double>[3, 1];
          break;
        case PdfDashStyle.dot:
          _dashPattern = <double>[1, 1];
          break;
        case PdfDashStyle.dashDot:
          _dashPattern = <double>[3, 1, 1, 1];
          break;
        case PdfDashStyle.dashDotDot:
          _dashPattern = <double>[3, 1, 1, 1, 1, 1];
          break;
        case PdfDashStyle.solid:
          break;
        default:
          _dashStyle = PdfDashStyle.solid;
          _dashPattern = <double>[];
          break;
      }
    }
  }

  void _initialize(
      [double width,
      PdfDashStyle dashStyle,
      PdfLineCap lineCap,
      PdfLineJoin lineJoin]) {
    if (width != null) {
      _width = width;
    }
    _colorSpace = PdfColorSpace.rgb;
    if (dashStyle != null) {
      this.dashStyle = dashStyle;
    } else {
      _dashStyle = PdfDashStyle.solid;
    }
    _color ??= PdfColor(0, 0, 0);
    _dashOffset = 0;
    _dashPattern = <double>[];
    _lineCap = lineCap ?? PdfLineCap.flat;
    _lineJoin = lineJoin ?? PdfLineJoin.miter;
    _miterLimit = 0.0;
  }

  void _setBrush(PdfBrush brush) {
    if (brush is PdfSolidBrush) {
      _color = brush.color;
      _brush = brush;
    }
  }

  bool _monitorChanges(
      PdfPen currentPen,
      _PdfStreamWriter streamWriter,
      Function getResources,
      bool saveState,
      PdfColorSpace currentColorSpace,
      _PdfTransformationMatrix matrix) {
    bool diff = false;
    saveState = true;
    if (currentPen == null) {
      diff = true;
    }
    diff = _dashControl(currentPen, saveState, streamWriter);
    streamWriter._setLineWidth(width);
    streamWriter._setLineJoin(lineJoin);
    streamWriter._setLineCap(lineCap);
    if (miterLimit > 0) {
      streamWriter._setMiterLimit(miterLimit);
      diff = true;
    }
    streamWriter._setColorAndSpace(color, currentColorSpace, true);
    diff = true;
    return diff;
  }

  bool _dashControl(PdfPen pen, bool saveState, _PdfStreamWriter streamWriter) {
    saveState = true;
    final List<double> pattern = _getPattern();
    streamWriter._setLineDashPattern(pattern, dashOffset * width);
    return saveState;
  }

  List<double> _getPattern() {
    final List<double> pattern = dashPattern;
    _isSkipPatternWidth ??= false;
    if (!_isSkipPatternWidth) {
      for (int i = 0; i < pattern.length; ++i) {
        pattern[i] *= width;
      }
    }
    return pattern;
  }
}
