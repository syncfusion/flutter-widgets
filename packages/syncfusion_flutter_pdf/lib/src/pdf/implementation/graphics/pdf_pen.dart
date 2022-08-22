import '../io/pdf_stream_writer.dart';
import 'brushes/pdf_solid_brush.dart';
import 'enums.dart';
import 'pdf_color.dart';
import 'pdf_transformation_matrix.dart';

/// A class defining settings for drawing operations,
/// that determines the color, width, and style of the drawing elements.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument doc = PdfDocument()
///   ..pages.add().graphics.drawRectangle(
///       //Create a new PDF pen instance.
///       pen: PdfPen(PdfColor(255, 0, 0)),
///       bounds: Rect.fromLTWH(0, 0, 200, 100));
/// //Save the document.
/// List<int> bytes = doc.save();
/// //Close the document.
/// doc.dispose();
/// ```
class PdfPen {
  //Constructor
  /// Initializes a new instance of the [PdfPen] class.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       //Create a new PDF pen instance.
  ///       pen: PdfPen(PdfColor(255, 0, 0)),
  ///       bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Close the document.
  /// doc.dispose();
  /// ```
  PdfPen(PdfColor pdfColor,
      {double width = 1.0,
      PdfDashStyle dashStyle = PdfDashStyle.solid,
      PdfLineCap lineCap = PdfLineCap.flat,
      PdfLineJoin lineJoin = PdfLineJoin.miter}) {
    _helper = PdfPenHelper(this);
    _color = pdfColor;
    _initialize(width, dashStyle, lineCap, lineJoin);
  }

  /// Initializes a new instance of the [PdfPen] with [PdfBrush].
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       //Create a new PDF pen instance.
  ///       pen: PdfPen.fromBrush(PdfBrushes.red),
  ///       bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = doc.save();
  /// //Close the document.
  /// doc.dispose();
  /// ```
  PdfPen.fromBrush(PdfBrush brush,
      {double width = 1.0,
      PdfDashStyle dashStyle = PdfDashStyle.solid,
      PdfLineCap lineCap = PdfLineCap.flat,
      PdfLineJoin lineJoin = PdfLineJoin.miter}) {
    _helper = PdfPenHelper(this);
    _setBrush(brush);
    _width = width;
    _initialize(width, dashStyle, lineCap, lineJoin);
  }

  PdfPen._immutable(PdfColor pdfColor) {
    _helper = PdfPenHelper(this);
    _color = pdfColor;
    _helper.isImmutable = true;
    _initialize(1.0, PdfDashStyle.solid, PdfLineCap.flat, PdfLineJoin.miter);
  }

  //Fields
  late PdfPenHelper _helper;
  //ignore:unused_field
  late PdfColorSpace _colorSpace;
  PdfDashStyle _dashStyle = PdfDashStyle.solid;
  PdfColor _color = PdfColor(0, 0, 0);
  PdfBrush? _brush;
  late double _dashOffset;
  late List<double> _dashPattern;
  PdfLineCap _lineCap = PdfLineCap.flat;
  PdfLineJoin _lineJoin = PdfLineJoin.miter;
  double _width = 1.0;
  late double _miterLimit;

  //Properties
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is PdfPen && _isEqual(other);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => width.hashCode;

  /// Gets or sets the color of the pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       pen: PdfPen(PdfColor(255, 0, 0)),
  ///       bounds: Rect.fromLTWH(10, 10, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfColor get color => _color;
  set color(PdfColor value) {
    _checkImmutability();
    _color = value;
  }

  /// Gets or sets the brush, which specifies the pen behavior.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       //Set brush
  ///       pen: PdfPen(PdfColor(255, 0, 0))..brush = PdfBrushes.green,
  ///       bounds: Rect.fromLTWH(10, 10, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfBrush? get brush => _brush;
  set brush(PdfBrush? value) {
    _checkImmutability();
    _setBrush(value);
  }

  /// Gets or sets the dash offset of the pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       //Set pen dash offset.
  ///       pen: PdfPen(PdfColor(255, 0, 0))..dashOffset = 0.5,
  ///       bounds: Rect.fromLTWH(10, 10, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  double get dashOffset => _dashOffset;
  set dashOffset(double value) {
    _checkImmutability();
    _dashOffset = value;
  }

  /// Gets or sets the dash pattern of the pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       //Set pen dash pattern.
  ///       pen: PdfPen(PdfColor(255, 0, 0))..dashPattern = [4, 2, 1, 3],
  ///       bounds: Rect.fromLTWH(10, 10, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  List<double> get dashPattern => _dashPattern;
  set dashPattern(List<double> value) {
    if (dashStyle == PdfDashStyle.solid) {
      UnsupportedError(
          'This operation is not allowed. Set Custom dash style to change the pattern.');
    }
    _checkImmutability();
    _dashPattern = value;
  }

  /// Gets or sets the line cap of the pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       pen: PdfPen(PdfColor(255, 0, 0),
  ///           dashStyle: PdfDashStyle.custom, lineCap: PdfLineCap.round)
  ///         ..dashPattern = [4, 2, 1, 3],
  ///       bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfLineCap get lineCap => _lineCap;
  set lineCap(PdfLineCap value) {
    _checkImmutability();
    _lineCap = value;
  }

  /// Gets or sets the line join style of the pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       pen: PdfPen(PdfColor(255, 0, 0),
  ///           dashStyle: PdfDashStyle.custom, lineJoin: PdfLineJoin.bevel)
  ///         ..dashPattern = [4, 2, 1, 3],
  ///       bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfLineJoin get lineJoin => _lineJoin;
  set lineJoin(PdfLineJoin value) {
    _checkImmutability();
    _lineJoin = value;
  }

  /// Gets or sets the width of the pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       //Set pen width.
  ///       pen: PdfPen(PdfColor(255, 0, 0), width: 4),
  ///       bounds: Rect.fromLTWH(10, 10, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  double get width => _width;
  set width(double value) {
    _checkImmutability();
    _width = value;
  }

  /// Gets or sets the miter limit.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       pen: PdfPen(PdfColor(255, 0, 0), width: 4)
  ///         //Set miter limit,
  ///         ..miterLimit = 2,
  ///       bounds: Rect.fromLTWH(10, 10, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  double get miterLimit => _miterLimit;
  set miterLimit(double value) {
    _checkImmutability();
    _miterLimit = value;
  }

  /// Gets or sets the dash style of the pen.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawRectangle(
  ///       pen: PdfPen(PdfColor(255, 0, 0),
  ///           dashStyle: PdfDashStyle.custom, lineJoin: PdfLineJoin.bevel)
  ///         ..dashPattern = [4, 2, 1, 3],
  ///       bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Close the document.
  /// document.dispose();
  /// ```
  PdfDashStyle get dashStyle => _dashStyle;
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
    if (_helper.isImmutable) {
      throw UnsupportedError("The immutable object can't be changed");
    }
  }

  void _setDashStyle(PdfDashStyle? value) {
    if (_dashStyle != value) {
      _dashStyle = value!;
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
          _dashPattern = <double>[];
          break;
      }
    }
  }

  void _initialize(double width, PdfDashStyle dashStyle, PdfLineCap lineCap,
      PdfLineJoin lineJoin) {
    _width = width;
    _colorSpace = PdfColorSpace.rgb;
    _dashOffset = 0;
    _dashPattern = <double>[];
    _dashStyle = PdfDashStyle.solid;
    _lineCap = lineCap;
    _lineJoin = lineJoin;
    _miterLimit = 0.0;
  }

  void _setBrush(PdfBrush? brush) {
    if (brush is PdfSolidBrush) {
      _color = brush.color;
      _brush = brush;
    }
  }
}

/// [PdfPen] helper
class PdfPenHelper {
  /// internal constructor
  PdfPenHelper(this.base);

  /// internal field
  late PdfPen base;

  /// internal method
  static PdfPenHelper getHelper(PdfPen base) {
    return base._helper;
  }

  /// internal field
  bool isImmutable = false;

  /// internal method
  static PdfPen immutable(PdfColor pdfColor) {
    return PdfPen._immutable(pdfColor);
  }

  /// internal field
  bool? isSkipPatternWidth;

  /// internal method
  bool monitorChanges(
      PdfPen? currentPen,
      PdfStreamWriter streamWriter,
      Function? getResources,
      bool saveState,
      PdfColorSpace? currentColorSpace,
      PdfTransformationMatrix? matrix) {
    bool diff = false;
    saveState = true;
    if (currentPen == null) {
      diff = true;
    }
    diff = _dashControl(currentPen, saveState, streamWriter);
    streamWriter.setLineWidth(base.width);
    streamWriter.setLineJoin(base.lineJoin);
    streamWriter.setLineCap(base.lineCap);
    if (base.miterLimit > 0) {
      streamWriter.setMiterLimit(base.miterLimit);
      diff = true;
    }
    streamWriter.setColorAndSpace(base.color, currentColorSpace, true);
    diff = true;
    return diff;
  }

  bool _dashControl(PdfPen? pen, bool saveState, PdfStreamWriter streamWriter) {
    saveState = true;
    final List<double>? pattern = _getPattern();
    streamWriter.setLineDashPattern(pattern, base.dashOffset * base.width);
    return saveState;
  }

  List<double>? _getPattern() {
    final List<double> pattern = base.dashPattern;
    isSkipPatternWidth ??= false;
    if (!isSkipPatternWidth!) {
      for (int i = 0; i < pattern.length; ++i) {
        pattern[i] *= base.width;
      }
    }
    return pattern;
  }
}
